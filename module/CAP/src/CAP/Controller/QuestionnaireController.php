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

class QuestionnaireController extends AbstractActionController {


	/* questionnaire summary */
	public function IndexAction() {
		$logger        = $this->getServiceLocator()->get( 'Log\App' );
		$logger->log( \Zend\Log\Logger::INFO, "questionnaire index action" );

		$qService      = $this->getServiceLocator()->get( 'cap_questionnaire_service' );

		$entityManager = $this->getServiceLocator()->get('doctrine.entitymanager.orm_default');

		/* this questionnaire must be assigned to the person who is logged in else redirect to view */
    $qId = $this->params()->fromRoute('questionnaireId');
    $cId = $this->params()->fromRoute('customerId');
		$logger->log( \Zend\Log\Logger::INFO, "qId: ".$qId." cust: ".$cId );
    /* check if this logged in person has access (TODO: make this a service) */
    $p = $qService->checkPermissions($qId, $cId, $this->identity());
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

				$questionCount = $qService->getQuestionCountBySection($qId, $section->getSectionNumber());

				$completedQuestionCount = $qService->getCompletedQuestionCountBySection($qId, $section->getSectionNumber(), $cs->getCustomer()->getId());

				$percentComplete = 0;
				if ($completedQuestionCount > 0) {
					$percentComplete = round( ($completedQuestionCount / $questionCount) * 100);
				}

				$viewArgs['sectionData'][$section->getSectionNumber()] = array('questionCount'          => $questionCount,
					 																														 'completedQuestionCount' => $completedQuestionCount,
																																			 'percentComplete'        => $percentComplete,
																																			 'completionStatus'       => $cs->getCompletionStatus()->getName());

				/* total completed questions in the questionnaire */
				$viewArgs['sectionData']['questionCount'] += $questionCount;
				$viewArgs['sectionData']['completedQuestionCount'] += $completedQuestionCount;

				array_push($viewArgs['sections'],$section);
				$viewArgs['customerSection'][$section->getSectionNumber()] = $cs;
			}

	   	if ($viewArgs['sectionData']['questionCount'] && $viewArgs['sectionData']['completedQuestionCount'] ) {
	   		$viewArgs['sectionData']['percentComplete'] = round( ($viewArgs['sectionData']['completedQuestionCount']  / $viewArgs['sectionData']['questionCount']) * 100);
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


				$questionCount = $qService->getQuestionCountBySection($qId, $section->getSectionNumber());

				$viewArgs['sectionData'][$section->getSectionNumber()] = array('questionCount'          => $questionCount,
																																			'completedQuestionCount' => null,
																																			'percentComplete'        => null,
																																			'completionStatus'       => null);

				$sectionData['sectionData']['questionCount'] += $questionCount;
				array_push($viewArgs['sections'],$section);

			}

    }

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
		$qService      = $this->getServiceLocator()->get( 'cap_questionnaire_service' );
    $p = $qService->checkPermissions($qId, $cId, $this->identity());
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

    $viewArgs['questionCount'] = $qService->questionCount($qId);

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
		$logger->log( \Zend\Log\Logger::INFO, 'section');
		/* do the pagination for this section */
		$questionSlice = array();
		$startIndex = $viewArgs['questionnaire']->getQuestionsPerPage() * ($pageNumber - 1);
		$endIndex   = ($viewArgs['questionnaire']->getQuestionsPerPage() * $pageNumber) - 1;
		$logger->log( \Zend\Log\Logger::INFO, 'start: '.$startIndex.' end: '.$endIndex);
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
		$viewArgs['totalSections'] = $qService->sectionCount($viewArgs['questionnaire']->getId());
		/* if they're on the last page - then the next page is page 1 of the next section */
		$logger->log( \Zend\Log\Logger::INFO, 'total questions in this section: ' . count($questions));

		/* if we're on the last page of this section: */
		if (($endIndex) > (count($questions) - $viewArgs['questionnaire']->getQuestionsPerPage() - 1) ) {
			/* check to make sure we're not at the last section */
			if ($sectionNumber >= $viewArgs['totalSections']) {
				/* we're done! */
				$viewArgs['lastPage'] = true;
			}

			$viewArgs['nextSection'] = $sectionNumber + 1;
			$viewArgs['nextPage']    = 1;

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
			$viewArgs['completedQuestionCount'] = $qService->getCompletedQuestionCountBySection($qId, $sectionNumber, $customer->getId());

			$viewArgs['percentComplete'] = 0;
			if ($viewArgs['completedQuestionCount']) {
				$viewArgs['percentComplete'] = round($viewArgs['completedQuestionCount'] / $viewArgs['questionCount'] * 100);
			}
		}

		$viewModel = new ViewModel($viewArgs);
		$viewModel->setTemplate('cap/questionnaire/page.phtml');
		return $viewModel;
	}


	public function ResultsAction() {
		$logger        = $this->getServiceLocator()->get( 'Log\App' );
		$logger->log( \Zend\Log\Logger::INFO, "questionnaire index action" );

		$qService      = $this->getServiceLocator()->get( 'cap_questionnaire_service' );

		$entityManager = $this->getServiceLocator()->get('doctrine.entitymanager.orm_default');

		/* this questionnaire must be assigned to the person who is logged in else redirect to view */
    $qId = $this->params()->fromRoute('questionnaireId');
    $cId = $this->params()->fromRoute('customerId');

    /* check if this logged in person has access (TODO: make this a service) */
    $p = $qService->checkPermissions($qId, $cId, $this->identity());
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

    /* data i need :
     * - results are custom depending on the organization (need organizationId)
     * - use organizationId to get all the organization specific static content
     * - compute results: avg
     *
     */

    /* get the service for the algorithm for this organization */
    $organizationId = $customer->getDomain()->getOrganization()->getId();
    $algorithmServiceAlias = 'cap_results_algorithm_'.$organizationId;
    $algorithm = $this->getServiceLocator()->get($algorithmServiceAlias);
    $viewArgs['results'] = $algorithm->compute($qId, $customer);

		$logger->log( \Zend\Log\Logger::INFO, $viewArgs['top-5'] );

    $viewArgs['organizationId'] = $organizationId;
    $viewArgs['questionnaireId'] = $qId;

		/* this questionnaire must be assigned to the person who is logged in else redirect to view */
		$viewModel = new ViewModel($viewArgs);
		$template = 'cap/results/'.$organizationId.'/'.$qId.'/results.phtml';
		$viewModel->setTemplate($template);
		return $viewModel;
	}



	public function PdfAction() {

		$logger        = $this->getServiceLocator()->get( 'Log\App' );
		$qService      = $this->getServiceLocator()->get( 'cap_questionnaire_service' );
		$entityManager = $this->getServiceLocator()->get('doctrine.entitymanager.orm_default');

		/* this questionnaire must be assigned to the person who is logged in else redirect to view */
    $qId = $this->params()->fromRoute('questionnaireId');
    $cId = $this->params()->fromRoute('customerId');

    /* check if this logged in person has access (TODO: make this a service) */
    $p = $qService->checkPermissions($qId, $cId, $this->identity());
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

    /* data i need :
     * - results are custom depending on the organization (need organizationId)
     * - use organizationId to get all the organization specific static content
     * - compute results: avg
     *
     */

    /* get the service for the algorithm for this organization */
    $organizationId = $customer->getDomain()->getOrganization()->getId();
    $algorithmServiceAlias = 'cap_results_algorithm_'.$organizationId;
    $algorithm = $this->getServiceLocator()->get($algorithmServiceAlias);
    $viewArgs['results'] = $algorithm->compute($qId, $customer);
    $viewArgs['organizationId'] = $organizationId;
    $viewArgs['questionnaireId'] = $qId;

		/* this questionnaire must be assigned to the person who is logged in else redirect to view */
    $viewRenderer = $this->serviceLocator->get('view_manager')->getRenderer();

    $layoutViewModel = $this->layout();
    $layoutViewModel->setTemplate('layout/pdf-layout');

		$viewModel = new ViewModel($viewArgs);
		$template = 'cap/results/'.$organizationId.'/'.$qId.'/results.phtml';
		$viewModel->setTemplate($template);

    $layoutViewModel->setVariables(array(
        'content' => $viewRenderer->render($viewModel),
    ));

    $htmlOutput = $viewRenderer->render($layoutViewModel);
    $output = $this->serviceLocator->get('mvlabssnappy.pdf.service')->getOutputFromHtml($htmlOutput);

    $response = $this->getResponse();
    $headers  = $response->getHeaders();
    $headers->addHeaderLine('Content-Type', 'application/pdf');
		$now = new \DateTime();
    $headers->addHeaderLine('Content-Disposition', "attachment; filename=\"export-" . $now->format('d-m-Y H:i:s') . ".pdf\"");

    $response->setContent($output);

    return $response;
	}
}

















