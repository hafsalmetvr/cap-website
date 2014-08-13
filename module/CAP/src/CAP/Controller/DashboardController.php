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
use Zend\Session\SessionManager;
use Zend\Session\Config\StandardConfig;
use Zend\View\Model\JsonModel;
use CAP\Entity\Customer;
use CAP\Options\ModuleOptions;

class DashboardController extends AbstractActionController {

	public function indexAction() {
		$logger        = $this->getServiceLocator()->get( 'Log\App' );
   	//$entityManager = $this->getServiceLocator()->get('doctrine.entitymanager.orm_default');


		$logger->log( \Zend\Log\Logger::INFO, "Dashboard index action");

		/* if they're not logged in - redirect to login */
		if ( !$user = $this->identity() ) {
			return $this->redirect()->toRoute( 'home');
		}



		/* display the appropriate view depending on the role of the logged in user */


		return new viewModel();
	}


	public function logoutAction() {
		$logger        = $this->getServiceLocator()->get( 'Log\App' );
		$logger->log( \Zend\Log\Logger::INFO, "logout");

		$auth = $this->getServiceLocator()->get('Zend\Authentication\AuthenticationService');
		if ($auth->hasIdentity()) {
	    $auth->clearIdentity();
	    $sessionManager = new SessionManager();
	    $sessionManager->forgetMe();
		}

		return $this->redirect()->toRoute('home',array('action' =>  'index'));
	}

}
