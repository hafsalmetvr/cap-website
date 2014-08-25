<?php

namespace CAP\Service;

use Zend\Session\Container;

const READ  = 1;
const WRITE = 2;

class QuestionnaireService {
	private $sl = null;

	public function setServiceLocator($sl) {
		$this->sl = $sl;
	}

	public function getServiceLocator() {
		return $this->sl;
	}

	public function questionCount($qId) {
		$entityManager = $this->getServiceLocator()->get('doctrine.entitymanager.orm_default');
    /* count of all questions */
    $res = 0;
 		$res = $entityManager->createQuery( "SELECT count(q.id) FROM CAP\Entity\Question q WHERE q.questionnaire = :questionnaireId AND q.answerType != 'ENUM'" )
 																	 ->setParameter('questionnaireId',$qId)
																	 ->getSingleScalarResult();

		/* now add the count of answers for each enum question in this section */
		$enumCount = $entityManager->createQuery("SELECT count(a.id) from CAP\Entity\Answer a JOIN a.question q WHERE q.answerType = 'ENUM' AND q.questionnaire = :questionnaireId")
  																 ->setParameter('questionnaireId',$qId)
																	 ->getSingleScalarResult();

		$res += $enumCount;
		return $res;
	}
	public function sectionCount($qId) {
		$entityManager = $this->getServiceLocator()->get('doctrine.entitymanager.orm_default');
    /* count of all questions */
    $res = 0;
 		$res = $entityManager->createQuery( "SELECT count(s.id) FROM CAP\Entity\Section s WHERE s.questionnaire = :questionnaireId" )
 																	 ->setParameter('questionnaireId',$qId)
																	 ->getSingleScalarResult();
		return $res;
	}

  public function percentComplete($questionnaireId, $customerId) {
  	if (!$customerId) {
  		return 0;
  	}
		$e      = $this->getServiceLocator()->get('doctrine.entitymanager.orm_default');
    $logger = $this->getServiceLocator()->get( 'Log\App' );
    $conn   = $e->getConnection();
    /* determine the percent completed */
    /* count of total questions that are not enums */
    $sql = "select count(*) as count from question where questionnaire_id = $questionnaireId and answer_type != 'ENUM'";
    $iterator = $conn->query($sql);
    $res = $iterator->fetch();
    $logger->log( \Zend\Log\Logger::INFO, $res);
    $questionCount = $res['count'];

    /* count of total answers for questions that are enums */
    $sql = "select count(*) as count from answer a join question q on q.id = a.question_id where q.questionnaire_id = $questionnaireId and q.answer_type = 'ENUM'";
    $iterator = $conn->query($sql);
    $res = $iterator->fetch();
    $logger->log( \Zend\Log\Logger::INFO, $res);
    $answerEnumCount = $res['count'];

    $totalQuestions = $questionCount + $answerEnumCount;
    $logger->log( \Zend\Log\Logger::INFO, "total questions: ".$totalQuestions);

    /* count of completed questions that are not enums */
    $sql = "select count(*) as count from customer_question cq join question q on q.id = cq.question_id join completion_status cs on cs.id = cq.completion_status_id where q.questionnaire_id = $questionnaireId and cq.customer_id = $customerId and cs.name = 'COMPLETED' and q.answer_type != 'ENUM'";
    $iterator = $conn->query($sql);
    $res = $iterator->fetch();
    $logger->log( \Zend\Log\Logger::INFO, $res);
    $completedQuestionCount = $res['count'];

    /* count of answer rows for questions that are enums */
    $sql = "select count(*) as count from customer_answer ca join answer a on a.id = ca.answer_id join question q on q.id = a.question_id where q.questionnaire_id = $questionnaireId and ca.customer_id = $customerId and q.answer_type = 'ENUM' and ca.answer_enum_id is not null";
    $iterator = $conn->query($sql);
    $res = $iterator->fetch();
    $logger->log( \Zend\Log\Logger::INFO, $res);
    $completedEnumCount = $res['count'];

    $totalCompletedQuestions = $completedQuestionCount + $completedEnumCount;
    $logger->log( \Zend\Log\Logger::INFO, "total completed questions: ".$totalCompletedQuestions);

    return round(($totalCompletedQuestions/$totalQuestions) * 100);
  }

	public function getCompletedQuestionCountBySection($qId, $sectionNumber, $customerId) {
		$entityManager = $this->getServiceLocator()->get('doctrine.entitymanager.orm_default');

		/* total number of questions this customer has completed */
		$result = 0;
 		$completedQuestionCount = $entityManager->createQuery( "SELECT count(cq.id) FROM CAP\Entity\CustomerQuestion cq JOIN cq.completionStatus cs JOIN cq.question q JOIN q.section s JOIN s.questionnaire q2 WHERE q.id = :questionnaireId AND s.sectionNumber = :sectionNumber AND cq.customer = :customerId AND q.answerType != 'ENUM' AND cs.name = :completionStatus" )
 																						->setParameter('questionnaireId',$qId)
 																						->setParameter('sectionNumber', $sectionNumber)
 																						->setParameter('customerId', $customerId)
																						->setParameter('completionStatus','COMPLETED')
																						->getSingleScalarResult();
 																					//->getResult( \Doctrine\ORM\Query::HYDRATE_OBJECT ) );

		/* now add the count of answers for each enum question in this section */
		$enumCount = $entityManager->createQuery("SELECT count(a.id) from CAP\Entity\CustomerAnswer ca JOIN ca.answerEnum ae JOIN ca.answer a JOIN a.question q WHERE q.answerType = 'ENUM' AND q.section = :sectionNumber AND q.questionnaire = :questionnaireId AND ca.customer = :customerId")
																	 ->setParameter('questionnaireId',$qId)
																	 ->setParameter('sectionNumber',$sectionNumber)
 																	 ->setParameter('customerId', $customerId)
																	 ->getSingleScalarResult();

		$result = $completedQuestionCount + $enumCount;
		return $result;
	}


	public function getQuestionCountBySection($qId, $sectionNumber) {
		$entityManager = $this->getServiceLocator()->get('doctrine.entitymanager.orm_default');

		/* get count of questions for a section */
		$questionCount = 0;
		$questionCount = $entityManager->createQuery( "SELECT count(q.id) FROM CAP\Entity\Question q JOIN q.section s JOIN s.questionnaire q2 WHERE q.questionnaire = :questionnaireId AND s.sectionNumber = :sectionNumber AND q.answerType != 'ENUM'" )
																	 ->setParameter('questionnaireId',$qId)
																	 ->setParameter('sectionNumber',$sectionNumber)
																	 ->getSingleScalarResult();
																	//->getResult( \Doctrine\ORM\Query::HYDRATE_OBJECT ) );

		/* now add the count of answers for each enum question in this section */
		$enumCount = $entityManager->createQuery("SELECT count(a.id) from CAP\Entity\Answer a JOIN a.question q WHERE q.answerType = 'ENUM' AND q.section = :sectionNumber AND q.questionnaire = :questionnaireId")
																	 ->setParameter('questionnaireId',$qId)
																	 ->setParameter('sectionNumber',$sectionNumber)
																	 ->getSingleScalarResult();

		$questionCount += $enumCount;
		return $questionCount;
	}


	/* read or write privs? */
	public function checkPermissions($qId, $cId, $identity) {
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
  		if ($cId === $identity->getId()) {
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
    	$ch = $e->getRepository('CAP\Entity\CustomerHierarchy')->findOneBy(array('parentCustomer' => $identity->getId(),
    																																					 'childCustomer'  => $cId));
    	/* this logged in user is the parent customer its ok to view */
			if ($ch) {
	    	$session->permissions[$qId] = READ;
				return READ;
			}

	  }

	  /* no customer? does this logged in user own it? */
	  $cq = $e->getRepository("\CAP\Entity\CustomerQuestionnaire")->findOneBy(array('questionnaire' => $qId, 'customer' => $identity->getId()));
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
    if ($identity->getRole()->getName() == 'Admin') {
	    $session->permissions[$qId] = READ;
    	return READ;
    }

	  $session->permissions[$qId] = false;
    return false;
	}


}
