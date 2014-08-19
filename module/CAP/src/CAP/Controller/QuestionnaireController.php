<?php
/**
 * Zend Framework (http://framework.zend.com/)
 *
 * @link      http://github.com/zendframework/ZendSkeletonApplication for the canonical source repository
 * @copyright Copyright (c) 2005-2014 Zend Technologies USA Inc. (http://www.zend.com)
 * @license   http://framework.zend.com/license/new-bsd New BSD License
 */

namespace CAP\Controller;

use Zend\Mvc\Controller\AbstractActionController;
use Zend\View\Model\ViewModel;
use Zend\Session\Container;

const READ  = 1;
const WRITE = 2;

class QuestionnaireController extends AbstractActionController {


	/* questionnaire summary */
	public function IndexAction() {
		$logger        = $this->getServiceLocator()->get( 'Log\App' );
		$logger->log( \Zend\Log\Logger::INFO, "questionnaire index action" );

		$entityManager = $this->getServiceLocator()->get('doctrine.entitymanager.orm_default');

		/* this questionnaire must be assigned to the person who is logged in else redirect to view */
    $qId = $this->params()->fromRoute('questionnaireId');
    $cId = $this->params()->fromRoute('customerId');

    /* check if this logged in person has access (TODO: make this a service) */
    $p = $this->checkPermissions($qId, $cId);
		$logger->log( \Zend\Log\Logger::INFO, $p );

    if (!$p) {
    	return $this->redirect()->toRoute('dashboard');
    }

    $permission = $p;
    $viewArgs = array(
    	'permission' => $permission
    );

    if (isset($cId)) {
    	$customer = $entityManager->getRepository('CAP\Entity\Customer')->find($cId);
			$viewArgs['customer'] = $customer;
    } else {
    	/* no customer passed in - but check if i am assigned this SAQ - in which case treat it as if that were passed in */
	  	$cq = $entityManager->getRepository("CAP\Entity\CustomerQuestionnaire")->findOneBy(array('questionnaire' => $qId, 'customer' => $this->identity()->getId()));
	  	if ($cq) {
	  		$customer = $cq->getCustomer();
	  		$cId = $customer->getId();
	  		$viewArgs['customer'] = $customer;
	  	}
    }


    /* data i need:
     * - questionnaire name
     * - questionnaire description
     * - questionnaire completion status
     * - sections:
     * 	 - name
     *   - completion status
     *   - questions completed count
     */

		$viewArgs['sections']    = array();
		$viewArgs['sectionData'] = array('questionCount' => 0);


    /* if there's a customer id then get the questionnaire data with the customer data */
    if (isset($customer)) {
			$viewArgs['sectionData']['completedQuestionCount'] = 0;
			$viewArgs['sectionData']['percentComplete']    = 0;

	 		$customerSections = $entityManager->createQuery( "SELECT cs FROM CAP\Entity\CustomerSection cs JOIN cs.section s JOIN s.questionnaire q JOIN cs.completionStatus cst WHERE s.questionnaire = :questionnaireId AND cs.customer = :customerId" )
					  																 ->setParameter('questionnaireId',$qId)
					  																 ->setParameter('customerId',$cId)
					 																	 ->getResult( \Doctrine\ORM\Query::HYDRATE_OBJECT );

			/* build the view args */
			$viewArgs['questionnaire'] = $customerSections[0]->getSection()->getQuestionnaire();
			$logger->log( \Zend\Log\Logger::INFO, "got questionnaire: " . $viewArgs['questionnaire']->getName());

			foreach ($customerSections as $cs) {
				$section = $cs->getSection();
				$logger->log( \Zend\Log\Logger::INFO, "got questionnaire: " . $section->getName());

	   		$questionCount = $entityManager->createQuery( "SELECT count(q.id) FROM CAP\Entity\Question q JOIN q.section s JOIN s.questionnaire q2 WHERE q.questionnaire = :questionnaireId AND s.sectionNumber = :sectionNumber" )
	    																 ->setParameter('questionnaireId',$qId)
	    																 ->setParameter('sectionNumber',$section->getSectionNumber())
																			 ->getSingleScalarResult();
	   																//->getResult( \Doctrine\ORM\Query::HYDRATE_OBJECT ) );

				/* total questions in the questionnaire */
				$viewArgs['sectionData']['questionCount'] += $questionCount;

				/* total number of questions this customer has completed */
	   		$completedQuestionCount = $entityManager->createQuery( "SELECT count(cq.id) FROM CAP\Entity\CustomerQuestion cq JOIN cq.completionStatus cs JOIN cq.question q JOIN q.section s JOIN s.questionnaire q2 WHERE q.id = :questionnaireId AND s.sectionNumber = :sectionNumber AND cq.customer = :customerId AND cs.name = :completionStatus" )
	   																						->setParameter('questionnaireId',$qId)
	   																						->setParameter('sectionNumber', $section->getSectionNumber())
	   																						->setParameter('customerId', $customer->getId())
																								->setParameter('completionStatus','COMPLETED')
																								->getSingleScalarResult();
	   																					//->getResult( \Doctrine\ORM\Query::HYDRATE_OBJECT ) );


				$percentComplete = 0;
				if ($completedQuestionCount > 0) {
					$percentComplete = $completedQuestionCount / $questionCount;
				}

				$viewArgs['sectionData'][$section->getSectionNumber()] = array('questionCount'          => $questionCount,
																														'completedQuestionCount' => $completedQuestionCount,
																														'percentComplete'        => $percentComplete,
																														'completionStatus'       => $cs->getCompletionStatus()->getName());

				/* total completed questions in the questionnaire */
				$viewArgs['sectionData']['completedQuestionCount'] += $completedQuestionCount;

				array_push($viewArgs['sections'],$section);
				$viewArgs['customerSection'][$section->getSectionNumber()] = $cs;
			}

	   	if ($viewArgs['sectionData']['questionCount'] && $viewArgs['sectionData']['completedQuestionCount'] ) {
	   		$viewArgs['sectionData']['percentCompleted'] = $viewArgs['sectionData']['completedQuestionCount']  / $viewArgs['sectionData']['questionCount'];
	   	}


    } else {

	 		$sections = $entityManager->createQuery( "SELECT s FROM CAP\Entity\Section s JOIN s.questionnaire q WHERE s.questionnaire = :questionnaireId" )
					  																 ->setParameter('questionnaireId',$qId)
					 																	 ->getResult( \Doctrine\ORM\Query::HYDRATE_OBJECT );


			/* build the view args */
			$viewArgs['questionnaire'] = $sections[0]->getQuestionnaire();
			$logger->log( \Zend\Log\Logger::INFO, "got questionnaire: " . $viewArgs['questionnaire']->getName());

			$viewArgs['sections'] = array();

			foreach ($sections as $section) {
			$logger->log( \Zend\Log\Logger::INFO, "got section: " . $section->getName());
	   		$questionCount = $entityManager->createQuery( "SELECT count(q.id) FROM CAP\Entity\Question q JOIN q.section s JOIN s.questionnaire q2 WHERE q.questionnaire = :questionnaireId AND s.sectionNumber = :sectionNumber" )
	    																 ->setParameter('questionnaireId',$qId)
	    																 ->setParameter('sectionNumber',$section->getSectionNumber())
																			 ->getSingleScalarResult();
	   																//->getResult( \Doctrine\ORM\Query::HYDRATE_OBJECT ) );


				$viewArgs['sectionData'][$section->getSectionNumber()] = array('questionCount'          => $questionCount,
																														'completedQuestionCount' => null,
																														'percentComplete'        => null,
																														'completionStatus'       => null);

				$sectionData['sectionData']['questionCount'] += $questionCount;


				array_push($viewArgs['sections'],$section);

			}

    }

		$logger->log( \Zend\Log\Logger::INFO, $viewArgs['sectionData'] );

		return new ViewModel($viewArgs);
	}

	public function PageAction() {
		$logger        = $this->getServiceLocator()->get( 'Log\App' );
		$logger->log( \Zend\Log\Logger::INFO, "questionnaire page action" );

		$entityManager = $this->getServiceLocator()->get('doctrine.entitymanager.orm_default');

		/* this questionnaire must be assigned to the person who is logged in else redirect to view */
    $qId = $this->params()->fromRoute('questionnaireId');
    $cId = $this->params()->fromRoute('customerId');
    $sectionNumber = $this->params()->fromRoute('sectionNumber');
    $pageNumber = $this->params()->fromRoute('id');

		$logger->log( \Zend\Log\Logger::INFO, "questionnaire " . $qId . " section " . $sectionNumber . " page " . $pageNumber  );

    /* check if this logged in person has access (TODO: make this a service) */
    $p = $this->checkPermissions($qId, $cId);
		$logger->log( \Zend\Log\Logger::INFO, 'permission: ' . $p );

    if (!$p) {
    	return $this->redirect()->toRoute('dashboard');
    }

    $permission = $p;
    $viewArgs = array(
    	'questionnaireId' => $qId,
    	'customerId' => $cId,
    	'pageNumber' => $pageNumber,
    	'sectionNumber' => $sectionNumber,
    	'permission' => $permission
    );


    if (isset($cId)) {
    	$customer = $entityManager->getRepository('CAP\Entity\Customer')->find($cId);
			$viewArgs['customer'] = $customer;
    } else {
    	/* no customer passed in - but check if i am assigned this SAQ - in which case treat it as if that were passed in */
	  	$cq = $entityManager->getRepository("CAP\Entity\CustomerQuestionnaire")->findOneBy(array('questionnaire' => $qId, 'customer' => $this->identity()->getId()));
	  	if ($cq) {
	  		$customer = $cq->getCustomer();
	  		$cId = $customer->getId();
	  	}
    }

    /* get:
     * - questionnaire name
     * - % complete
     * - section name
     * - questions for this section
     * - question_answers for each question
     * - customer_answers for each question
		*/

    /* count of all questions */
 		$viewArgs['questionCount'] = $entityManager->createQuery( "SELECT count(q.id) FROM CAP\Entity\Question q WHERE q.questionnaire = :questionnaireId" )
 																	 ->setParameter('questionnaireId',$qId)
																	 ->getSingleScalarResult();


  	/* get all the questions for this section and divide into pages using questionsPerPage */
 		$questions = $entityManager->createQuery( "SELECT q FROM CAP\Entity\Question q JOIN q.section s JOIN s.questionnaire q2 WHERE q.questionnaire = :questionnaireId AND s.sectionNumber = :sectionNumber ORDER BY q.questionOrder" )
 																						->setParameter('questionnaireId',$qId)
 																						->setParameter('sectionNumber', $sectionNumber)
 																						->getResult( \Doctrine\ORM\Query::HYDRATE_OBJECT );


		$logger->log( \Zend\Log\Logger::INFO, 'question count ' . $viewArgs['questionCount']  );

		foreach ($questions as $q) {
			$logger->log( \Zend\Log\Logger::INFO, 'question ' . $q->getQuestionNumber() . " questionnaire " . $q->getQuestionnaire()->getId()  );
		}

		$viewArgs['questionnaire'] = $questions[0]->getQuestionnaire();
		$viewArgs['section']       = $questions[0]->getSection();

		/* do the pagination for this section */
		$questionSlice = array();
		$startIndex = $viewArgs['questionnaire']->getQuestionsPerPage() * ($pageNumber - 1);
		$endIndex   = ($viewArgs['questionnaire']->getQuestionsPerPage() * ($pageNumber)) - 1;

		$count = 0;
		$viewArgs['sections'] = array();
		foreach ($questions as $q) {
			$viewArgs['sections'][$q->getSection()->getSectionNumber()] = $q->getSection();
			if (($startIndex <= $count) && ($count <= $endIndex )) {
				array_push($questionSlice, $q);
			}
			if ($count > $endIndex) {
				break;
			}
			$count++;
		}
		$viewArgs['questions'] = $questionSlice;

		/* calculate totalSections - TODO: optimize this */
		$viewArgs['totalSections'] = 0;
		foreach ($viewArgs['sections'] as $sectionNumber => $section) {
			$viewArgs['totalSections']++;
		}

		/* if they're on the last page - then the next page is page 1 of the next section */
		$logger->log( \Zend\Log\Logger::INFO, 'total questions in this section: ' . count($questions));

		/* if we're on the last page of this section: */
		if (($endIndex) > (count($questions) - $viewArgs['questionnaire']->getQuestionsPerPage()) ) {
			$viewArgs['nextSection'] = $sectionNumber + 1;
			$viewArgs['nextPage']    = 1;
			/* check to make sure we're not at the last section */
			if ($sectionNumber > $viewArgs['totalSections']) {
				/* we're done! */
				$viewArgs['lastPage'] = true;
			}
		} else {
			/* not moving to the next section */
			$viewArgs['nextSection'] = $sectionNumber;
			$viewArgs['nextPage'] = $pageNumber + 1;
		}

		/* determine prevPage info */
		if (($pageNumber > 1)) {
			$viewArgs['prevSection'] = $sectionNumber;
			$viewArgs['prevPage']    = $pageNumber - 1;
		} else {
			/* is there a section to go back to? or do we go back to the summary? */
			if ($sectionNumber > 1) {
				$viewArgs['prevSection'] = $sectionNumber - 1;
				$viewArgs['prevPage']    = 1;
			} else {
				$viewArgs['firstPage'] = true;
			}
		}


		if (isset($customer)) {
			/* total number of questions this customer has completed */
   		$viewArgs['completedQuestionCount'] = $entityManager->createQuery( "SELECT count(cq.id) FROM CAP\Entity\CustomerQuestion cq JOIN cq.completionStatus cs JOIN cq.question q JOIN q.section s JOIN s.questionnaire q2 WHERE q.id = :questionnaireId AND s.sectionNumber = :sectionNumber AND cq.customer = :customerId AND cs.name = :completionStatus" )
   																						->setParameter('questionnaireId',$qId)
   																						->setParameter('sectionNumber', $section->getSectionNumber())
   																						->setParameter('customerId', $customer->getId())
																							->setParameter('completionStatus','COMPLETED')
																							->getSingleScalarResult();

			$viewArgs['percentComplete'] = 0;
			if ($viewArgs['completedQuestionCount']) {
				$viewArgs['percentComplete'] = $viewArgs['completedQuestionCount'] / $viewArgs['questionCount'];
			}
		}

		$viewModel = new ViewModel($viewArgs);
		$viewModel->setTemplate('cap/questionnaire/page.phtml');
		return $viewModel;
	}





	public function ResultsAction() {
		$logger        = $this->getServiceLocator()->get( 'Log\App' );
		$logger->log( \Zend\Log\Logger::INFO, "questionnaire complete action" );

		$entityManager = $this->getServiceLocator()->get('doctrine.entitymanager.orm_default');

		/* this questionnaire must be assigned to the person who is logged in else redirect to view */
		$viewModel = new ViewModel();

		$viewModel->setTemplate('cap/questionnaire/questionnaire.phtml');
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

















