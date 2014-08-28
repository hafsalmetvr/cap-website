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

    $e        = $this->getServiceLocator()->get( 'doctrine.entitymanager.orm_default' );
    $qService = $this->getServiceLocator()->get( 'cap_questionnaire_service' );


    $viewArgs['question'] = $e->getRepository('CAP\Entity\Question')->find($qId);
    $p = $qService->checkPermissions($viewArgs['question']->getQuestionnaireId(), $cId, $this->identity());
    if (!$p) {
      return new JsonModel();
    }

    /* get a list of answers for a given question id */
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

      /* if the section is complete its read only */
      $customerSection = $e->getRepository('CAP\Entity\CustomerSection')->findOneBy(array('customer' => $cId, 'section' => $viewArgs['question']->getSection()->getId()));
      $logger->log( \Zend\Log\Logger::INFO, "section completion status is: ".$customerSection->getCompletionStatus()->getName() );
      if ($customerSection->getCompletionStatus()->getName() === "COMPLETED") {
        $p = READ;
        $logger->log( \Zend\Log\Logger::INFO, "section is complete so making this question read only" );
      }


    }

    $viewArgs['percentComplete'] = $qService->percentComplete($viewArgs['question']->getQuestionnaireId(), $cId, $e);
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
    $qService = $this->getServiceLocator()->get( 'cap_questionnaire_service' );

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
      if (isset($answerData['answerEnumId'])) {
        $a->setAnswerEnum($e->find( 'CAP\Entity\AnswerEnum', $answerData['answerEnumId'] ) );
      }
      if ($answerData['answerText']) {
        $a->setAnswerText($answerData['answerText']);
      }
      $a->setCreated($now);
      $e->persist( $a );
    }

    /* update the status for the question */
    $cq = $e->getRepository("CAP\Entity\CustomerQuestion")->findOneBy( array('question' => $data['questionId'],
                                                                             'customer' => $data['customerId'] ) );


    /* if this question is ENUM then all answers must have an enum_id in order to be COMPLETE otherwise - NOT COMPLETED */
    $statusToSet = 'COMPLETED';
    if ($cq->getQuestion()->getAnswerType() == 'ENUM') {
      /* make sure all the answers are answered */
      foreach ($data['answers'] as $answerData) {
        if (!isset($answerData['answerEnumId']) || is_null($answerData['answerEnumId'])) {
          $statusToSet = 'NOT COMPLETED';
          break;
        }
      }
    }
    $cq->setCompletionStatus( $e->getRepository('CAP\Entity\CompletionStatus')->findOneBy( array('name' => $statusToSet) ) );
    if ($statusToSet === 'COMPLETED') {
      $cq->setCompleted($now);
    }

    $e->persist($cq);
    $e->flush();

    /* get the questionnaire_id */
    $questionnaireId = $e->createQuery( "SELECT q.questionnaireId FROM CAP\Entity\Question q WHERE q.id = :questionId" )
                         ->setParameter('questionId',$data['questionId'])
                         ->getSingleScalarResult();

    $logger->log( \Zend\Log\Logger::INFO, "questionnaire id: ".$questionnaireId );

    /* update statuses for all sections */

    $conn = $e->getConnection();
    /* count of questions that are not complete, by section */
    $sql = "select count(*) as count,cs.name, s.id from customer_question cq join question q on q.id = cq.question_id join completion_status cs on cs.id = cq.completion_status_id join section s on s.id = q.section_id where cq.customer_id = " .$cq->getCustomer()->getId() ." AND q.questionnaire_id = $questionnaireId group by cs.name, s.id";
    $iterator = $conn->query($sql);

    /*
     * - if all questions are completed then section should be completed
     * - if all questions are NOT STARTED then section should be not started
     * - if at least 1 question is NOT COMPLETED then section should be NOT COMPLETED
     */

    $sectionCountData = array();
    while (is_object($iterator) AND ($array = $iterator->fetch()) !== FALSE) {
      if (!isset($sectionCountData[$array['id']])) {
        $sectionCountData[$array['id']] = array();
      }
      $sectionCountData[$array['id']][$array['name']] = $array['count'];
    }

    $sectionStatusCount = array('NOT COMPLETED' => 0, 'NOT STARTED' => 0, 'COMPLETED' => 0);
    foreach ($sectionCountData as $sectionId => $counts) {
      if (!isset($counts['NOT COMPLETED'])) {
        $counts['NOT COMPLETED'] = 0;
      }

      if (!isset($counts['NOT STARTED'])) {
        $counts['NOT STARTED'] = 0;
      }

      if (!isset($counts['COMPLETED'])) {
        $counts['COMPLETED'] = 0;
      }


      $sectionStatusToSet = 'NOT COMPLETED';
      /* if there is at least 1 not completed uestion */
      if ( ($counts['NOT COMPLETED'] == 0) && ($counts['NOT STARTED'] == 0) ) {
        /* all questions in this section are COMPLETED */
        $sectionStatusToSet = 'COMPLETED';
        $sectionStatusCount['COMPLETED']++;
      } elseif ( ($counts['NOT COMPLETED'] == 0) && ($counts['COMPLETED'] == 0) ) {
        /* all questions are NOT STARTED */
        $sectionStatusToSet = 'NOT STARTED';
        $sectionStatusCount['NOT STARTED']++;
      } else {
        $sectionStatusCount['NOT COMPLETED']++;
      }

      /* set section status */
      $cs = $e->getRepository("CAP\Entity\CustomerSection")->findOneBy( array('section' => $sectionId,
                                                                              'customer' => $data['customerId'] ) );

      $logger->log( \Zend\Log\Logger::INFO, $sectionId );
      $logger->log( \Zend\Log\Logger::INFO, $data['customerId'] );

      $cs->setCompletionStatus( $e->getRepository('CAP\Entity\CompletionStatus')->findOneBy( array('name' => $sectionStatusToSet) ) );
      if ($sectionStatusToSet === 'COMPLETED') {
        $cs->setCompleted($now);
      }


      $e->persist($cs);
    }

    /* questionnaire status */
    $questionnaireStatusToSet = 'NOT COMPLETED';
    if ( ($sectionStatusCount['NOT COMPLETED'] == 0) && ($sectionStatusCount['COMPLETED'] == 0) ) {
      /* all of the sections are NOT STARTED */
      $questionnaireStatusToSet = 'NOT STARTED';
    } elseif (($sectionStatusCount['NOT COMPLETED'] == 0) && ($sectionStatusCount['NOT STARTED'] == 0)) {
      /* all sections are completed */
      $questionnaireStatusToSet = 'COMPLETED';
    }
    /* set section status */
    $cqr = $e->getRepository("CAP\Entity\CustomerQuestionnaire")->findOneBy( array('questionnaire' => $questionnaireId,
                                                                            'customer' => $data['customerId'] ) );

    $cqr->setCompletionStatus( $e->getRepository('CAP\Entity\CompletionStatus')->findOneBy( array('name' => $questionnaireStatusToSet) ) );
    if ($questionnaireStatusToSet === 'COMPLETED') {
      $cqr->setCompleted($now);
    }

    $e->persist($cqr);

    $e->flush();

    $viewArgs = array("success" => true);
    $viewArgs['percentComplete'] = $qService->percentComplete($questionnaireId, $cq->getCustomer()->getId(), $e);

    return new JsonModel($viewArgs);
  }

}

