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

class AnswerTypeController extends AbstractActionController {

	public function selectAction() {
		$logger        = $this->getServiceLocator()->get( 'Log\App' );
   	//$entityManager = $this->getServiceLocator()->get('doctrine.entitymanager.orm_default');

		/* if they're not logged in - redirect to login */
		if ( $user = $this->identity() ) {
			$viewModel = new ViewModel();
      $viewModel->setTerminal(true);
      return $viewModel;
		}
	}

	public function multiselectAction() {
		$logger        = $this->getServiceLocator()->get( 'Log\App' );
   	//$entityManager = $this->getServiceLocator()->get('doctrine.entitymanager.orm_default');

		/* if they're not logged in - redirect to login */
		if ( $user = $this->identity() ) {
			$viewModel = new ViewModel();
      $viewModel->setTerminal(true);
      return $viewModel;
		}
	}

	public function textareaAction() {
		$logger        = $this->getServiceLocator()->get( 'Log\App' );
   	//$entityManager = $this->getServiceLocator()->get('doctrine.entitymanager.orm_default');

		/* if they're not logged in - redirect to login */
		if ( $user = $this->identity() ) {
			$viewModel = new ViewModel();
      $viewModel->setTerminal(true);
      return $viewModel;
		}
	}
	public function textAction() {
		$logger        = $this->getServiceLocator()->get( 'Log\App' );
   	//$entityManager = $this->getServiceLocator()->get('doctrine.entitymanager.orm_default');

		/* if they're not logged in - redirect to login */
		if ( $user = $this->identity() ) {
			$viewModel = new ViewModel();
      $viewModel->setTerminal(true);
      return $viewModel;
		}
	}

	public function checkboxAction() {
		$logger        = $this->getServiceLocator()->get( 'Log\App' );
   	//$entityManager = $this->getServiceLocator()->get('doctrine.entitymanager.orm_default');

		/* if they're not logged in - redirect to login */
		if ( $user = $this->identity() ) {
			$viewModel = new ViewModel();
      $viewModel->setTerminal(true);
      return $viewModel;
		}
	}
	public function radioAction() {
		$logger        = $this->getServiceLocator()->get( 'Log\App' );
   	//$entityManager = $this->getServiceLocator()->get('doctrine.entitymanager.orm_default');

		/* if they're not logged in - redirect to login */
		if ( $user = $this->identity() ) {
			$viewModel = new ViewModel();
      $viewModel->setTerminal(true);
      return $viewModel;
		}
	}
	public function enumAction() {
		$logger        = $this->getServiceLocator()->get( 'Log\App' );
   	//$entityManager = $this->getServiceLocator()->get('doctrine.entitymanager.orm_default');

		/* if they're not logged in - redirect to login */
		if ( $user = $this->identity() ) {
			$viewModel = new ViewModel();
      $viewModel->setTerminal(true);
      return $viewModel;
		}
	}
}
