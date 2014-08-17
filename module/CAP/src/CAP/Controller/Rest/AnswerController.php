<?php
namespace CAP\Controller\Rest;

use Zend\Mvc\Controller\AbstractRestfulController;
use Zend\View\Model\JsonModel;
use Zend\Session\Container;


const READ  = 1;
const WRITE = 2;

class AnswerController extends AbstractRestfulController {

	/* will return a list of answers for a give question id and type.  if there's a customer id it will get the customer answer too */
	public function getList() {
    $answerType = $this->params()->fromRoute('answerType');
    $qId = $this->params()->fromRoute('questionId');
    $cId = $this->params()->fromRoute('customerId');
		$logger = $this->getServiceLocator()->get( 'Log\App' );
    $logger->log( \Zend\Log\Logger::INFO, "Rest call to /answer" );
    $logger->log( \Zend\Log\Logger::INFO, $answerType );
    $logger->log( \Zend\Log\Logger::INFO, $qId );
    $logger->log( \Zend\Log\Logger::INFO, $cId );

    $viewArgs = array();

    $e = $this->getServiceLocator()->get( 'doctrine.entitymanager.orm_default' );

    $viewArgs['question'] = $e->getRepository('CAP\Entity\Question')->find($qId);
    $p = $this->checkPermissions($viewArgs['question']->getQuestionnaireId(), $cId);
    if (!$p) {
      return new JsonModel();
    }


    /* get a list of answers for a give question id */
    $viewArgs['answers'] = $e->createQuery( "SELECT a FROM CAP\Entity\Answer a JOIN a.question q WHERE a.question = :questionId ORDER BY a.answerOrder" )
                                            ->setParameter('questionId',$qId)
                                            ->getResult( \Doctrine\ORM\Query::HYDRATE_ARRAY );


    /* if this is an enum - have to get them for each answer */
    if ($viewArgs['question']->getAnswerType() === "ENUM") {
      $em = $e->createQuery( "SELECT em, e FROM CAP\Entity\AnswerEnumMap em JOIN em.answer a JOIN em.answerEnum e WHERE a.question = :questionId ORDER BY em.answerEnumOrder" )
                                              ->setParameter('questionId',$qId)
                                              ->getResult( \Doctrine\ORM\Query::HYDRATE_ARRAY );



      if ($em) {
        /* load the enums on to the answers */
        foreach ($viewArgs['answers'] as $index => $a) {

          $logger->log( \Zend\Log\Logger::INFO, $index );
          $logger->log( \Zend\Log\Logger::INFO, $a );

          $viewArgs['answers'][$index]['answerEnums'] = array();
          foreach ($em as $enum) {
            if ($enum['answerId'] === $a['id']) {
              $viewArgs['answers'][$index]['answerEnums'][] = $enum['answerEnum'];
            }
          }
        }
      }
    }

    $viewArgs['customerAnswers'] = $e->createQuery( "SELECT ca.answerText, a.id as answerId, ae.id as answerEnumId FROM CAP\Entity\CustomerAnswer ca JOIN ca.answer a LEFT JOIN ca.answerEnum ae JOIN a.question q WHERE a.question = :questionId AND ca.customer = :customerId ORDER BY a.answerOrder" )
                                            ->setParameter('questionId',$qId)
                                            ->setParameter('customerId',$cId)
                                            ->getResult( \Doctrine\ORM\Query::HYDRATE_ARRAY );


    /* if the completion status of the customer_question row is 'NOT STARTED' and permission is WRITE
     * then set the completion status to NOT COMPLETED cause they viewed it
    */
    if ($p === WRITE) {
      $customerQuestion = $e->getRepository('CAP\Entity\CustomerQuestion')->findOneBy(array('customer' => $cId, 'question' => $qId));
      if (isset($customerQuestion) && $customerQuestion->getCompletionStatus()->getName() === "NOT STARTED") {
        $logger->log( \Zend\Log\Logger::INFO, "setting customer question completion status to NOT COMPLETED" );
        $customerQuestion->setCompletionStatus($e->getRepository('CAP\Entity\CompletionStatus')->findOneBy(array('name' => 'NOT COMPLETED')));
        $e->persist($customerQuestion);
        $e->flush();
      }
    }

    $viewArgs['success'] = true;
    $viewArgs['disabled'] = ($p === READ);
    return new JsonModel($viewArgs);
	}

  /* POST /answer - create a new (or update) answer
    - if there is a customer id - it should create a customer_answer for an existing answer
    - if not customer id it shold create a new answer for a given question id (not implemented yet)
  */

  public function create( $data ) {
    $logger        = $this->getServiceLocator()->get( 'Log\App' );
    $logger->log( \Zend\Log\Logger::INFO, $data );
    /* set completionstatus to completed */

    $now = date("Y-m-d H:i:s");
    $e = $this->getServiceLocator()->get( 'doctrine.entitymanager.orm_default' );


    /* get all customer answers for this question id and customerid and delete them */
    $answers = $e->createQuery("SELECT ca FROM CAP\Entity\CustomerAnswer ca JOIN ca.answer a WHERE a.question = :questionId AND ca.customer = :customerId")
                 ->setParameter('questionId', $data['questionId'])
                 ->setParameter('customerId', $data['customerId'])
                 ->getResult(\Doctrine\ORM\Query::HYDRATE_OBJECT );

    if ($answers) {
      foreach ($answers as $a) {
        $e->remove($a);
      }
    }

    /* for each section of the questionnaire */
    foreach ($data['answers'] as $answerData) {
      $a = new \CAP\Entity\CustomerAnswer;
      $a->setCustomer( $e->find( 'CAP\Entity\Customer', $data['customerId'] ) );
      $a->setAnswer( $e->find( 'CAP\Entity\Answer', $answerData['answerId'] ) );
      if ($answerData['answerEnumId']) {
        $a->setAnswerEnum($e->find( 'CAP\Entity\AnswerEnum', $answerData['answerEnumId'] ) );
      }
      if ($answerData['answerText']) {
        $a->setAnswerText($answerData['answerText']);
      }
      $a->setCreated($now);
      $e->persist( $a );
    }

    $e->flush();

    $viewArgs = array("success" => true);

    return new JsonModel($viewArgs);
  }

  /* read or write privs? */
  private function checkPermissions($qId, $cId) {
    $logger        = $this->getServiceLocator()->get( 'Log\App' );
    $logger->log( \Zend\Log\Logger::INFO, "check permissions on questionnaire" );

    /* check the session for permission first */
    $session = new Container('user');
    if (!isset($session->permissions)) {
      $session->permissions = array();
    } else {
      if (isset($session->permissions[$qId]) ) {
        $logger->log( \Zend\Log\Logger::INFO, "session says " . $session->permissions[$qId]);
        return $session->permissions[$qId];
      }

    }


    /* scenarios:
     * - Admin can view
     * - parent customer of customer who owns it can view
     * - customer who owns it can view
     */
    $e = $this->getServiceLocator()->get('doctrine.entitymanager.orm_default');
    /* check if this logged in user owns this questionnaire */

    $cqs = array();
    if (isset($cId)) {
      $cqs = $e->createQuery("SELECT cq FROM CAP\Entity\CustomerQuestionnaire cq WHERE cq.questionnaire = :questionnaireId AND cq.customerId = :customerId")
               ->setParameter("questionnaireId", $qId)
               ->setParameter("customerId", $cId)
               ->getResult(\Doctrine\ORM\Query::HYDRATE_OBJECT);

      if (!isset($cqs[0])) {
        /* there is a customer passed in but it is not assigned to this questionnaire */
        $session->permissions[$qId] = false;
        return false;
      }

      /* got here? then the customer is assigned the questionnaire */

      /* if the customer who is assigned the questionnaire is the same person who is logged in */
      if ($cId === $this->identity()->getId()) {
        /* i can only WRITE if its not completed */
        if ($cqs[0]->getCompletionStatus()->getName() === "COMPLETED") {
          $session->permissions[$qId] = READ;
          return READ;
        } else {
          $session->permissions[$qId] = WRITE;
          return WRITE;
        }
      }


      /* check if the logged in user is the parent of this customer */
      $ch = $e->getRepository('CAP\Entity\CustomerHierarchy')->findOneBy(array('parentCustomer' => $this->identity()->getId(),
                                                                               'childCustomer'  => $cId));
      /* this logged in user is the parent customer its ok to view */
      if ($ch) {
        $session->permissions[$qId] = READ;
        return READ;
      }

    }

    /* no customer? does this logged in user own it? */
    $cq = $e->getRepository("\CAP\Entity\CustomerQuestionnaire")->findOneBy(array('questionnaire' => $qId, 'customer' => $this->identity()->getId()));
    if ($cq) {
      /* i own it write if its not completed otherwise read only */
      if ($cq->getCompletionStatus()->getName() === "COMPLETED") {
        $session->permissions[$qId] = READ;
        return READ;
      } else {
        $session->permissions[$qId] = WRITE;
        return WRITE;
      }
    }


    /* still here? only admin can view */
    if ($this->identity()->getRole()->getName() == 'Admin') {
      $session->permissions[$qId] = READ;
      return READ;
    }

    $session->permissions[$qId] = false;
    return false;
  }

}

