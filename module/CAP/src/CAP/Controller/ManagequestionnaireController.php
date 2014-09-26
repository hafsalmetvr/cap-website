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

class ManagequestionnaireController extends AbstractActionController {


	/* Manage questionnaire summary */
	public function IndexAction() {
		$logger        = $this->getServiceLocator()->get( 'Log\App' );
		$logger->log( \Zend\Log\Logger::INFO, "Manage questionnaire index action" );

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




		return new ViewModel($viewArgs);
	}


}















