<?php
/**
 * Zend Framework (http://framework.zend.com/)
 *
 * @link      http://github.com/zendframework/ZendSkeletonApplication for the canonical source repository
 * @copyright Copyright (c) 2005-2014 Zend Technologies USA Inc. (http://www.zend.com)
 * @license   http://framework.zend.com/license/new-bsd New BSD License
 */

namespace CAP\Controller\Rest;

use Zend\Mvc\Controller\AbstractRestfulController;
use Zend\Session\SessionManager;
use Zend\Session\Config\StandardConfig;
use Zend\View\Model\JsonModel;
use CAP\Entity\Customer;
use CAP\Options\ModuleOptions;
use Zend\Mail\Message;
use CAP\Service\UserService;


class ResetPasswordController extends AbstractRestfulController {

	/* POST /reset-password - create is a misnomer its actually the send reset password email function */
	public function create( $data ) {

		$logger = $this->getServiceLocator()->get( 'Log\App' );
		$logger->log( \Zend\Log\Logger::INFO, $data );

    $entityManager = $this->getServiceLocator()->get( 'doctrine.entitymanager.orm_default' );
    $c = $entityManager->createQuery( "SELECT u FROM CAP\Entity\Customer u WHERE u.email = :email" )
      ->setParameter('email', $data['email'])
      ->getResult( \Doctrine\ORM\Query::HYDRATE_OBJECT );

    if ( $c[0] ) {
    	$c = $c[0];
			try {
				$fullLink = $this->getBaseUrl() . $this->url()->fromRoute( 'dashboard', array( 'action' => 'confirm-email', 'id' => $c->getRegistrationToken() ) );
				$this->sendEmail($c->getEmail(),$this->getTranslatorHelper()->translate( 'Centurion Assessment Portal: Reset your password' ),
					sprintf( $this->getTranslatorHelper()->translate( 'Click the link to reset your password => %s' ), $fullLink )
				);
				return new JsonModel( array( 'success' => true, 'message' => 'An email has been sent to '.$c->getEmail() ) );
			} catch ( \Exception $e ) {
				$logger->log( \Zend\Log\Logger::INFO, $e );
				return new JsonModel( array( 'success' => false, 'message' =>'Something went wrong when trying to send the activation email! Please contact your administrator.' ) );
			}

		} else {
			return new JsonModel( array( 'success' => false, 'message' => 'Please enter a valid email address.' ) );
		}

	}



  /**
   * Send Email
   *
   * Sends plain text emails
   *
   */
  private function sendEmail($to = '', $subject = '', $messageText = '') {
      $transport = $this->getServiceLocator()->get('mail.transport');
      $message = new Message();

      $message->addTo($to)
              ->addFrom($this->getOptions()->getSenderEmailAdress())
              ->setSubject($subject)
              ->setBody($messageText);

      $transport->send($message);
  }


  /**
   * Get Base Url
   *
   * Get Base App Url
   *
   */
  private function getBaseUrl() {
      $uri = $this->getRequest()->getUri();
      return sprintf('%s://%s', $uri->getScheme(), $uri->getHost());
  }

  /**
   * get translatorHelper
   *
   * @return  Zend\Mvc\I18n\Translator
   */
  private function getTranslatorHelper() {
      if(null === $this->translatorHelper) {
          $this->translatorHelper = $this->getServiceLocator()->get('MvcTranslator');
      }

      return $this->translatorHelper;
  }

  /**
   * get options
   *
   * @return ModuleOptions
   */
  private function getOptions()
  {
      if(null === $this->options) {
          $this->options = $this->getServiceLocator()->get('cap_module_options');
      }

      return $this->options;
  }


}
