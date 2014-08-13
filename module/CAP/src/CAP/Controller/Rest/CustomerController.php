<?php
namespace CAP\Controller\Rest;

use Zend\Mvc\Controller\AbstractRestfulController;
use Zend\Session\SessionManager;
use Zend\Session\Config\StandardConfig;
use Zend\View\Model\JsonModel;
use CAP\Entity\Customer;
use CAP\Options\ModuleOptions;

class CustomerController extends AbstractRestfulController {

	public function get($id) {
		$logger = $this->getServiceLocator()->get( 'Log\App' );
		$logger->log( \Zend\Log\Logger::INFO, "Rest call to GET /user/".$id);
		if ($id == 'current') {
			$e = $this->getServiceLocator()->get('doctrine.entitymanager.orm_default');
			$hydrator = new \DoctrineModule\Stdlib\Hydrator\DoctrineObject($e);
			return new JsonModel( $hydrator->extract($this->identity()) );
		}

	}

	public function getList() {
		$logger = $this->getServiceLocator()->get( 'Log\App' );
		$logger->log( \Zend\Log\Logger::INFO, "Rest call to /user" );
	}

	/* POST /user */
	public function create( $data ) {
		$logger = $this->getServiceLocator()->get( 'Log\App' );
		$logger->log( \Zend\Log\Logger::INFO, $data );

		$user = new Customer;
		$messages = null;

		if ( $this->getRequest()->isPost() ) {
			$authService     = $this->getServiceLocator()->get( 'Zend\Authentication\AuthenticationService' );
			$adapter         = $authService->getAdapter();
			$usernameOrEmail = $data['email'];

			try {
				$user = $this->getEntityManager()->createQuery( "SELECT u FROM CAP\Entity\Customer u WHERE u.email = '$usernameOrEmail'" )->getResult( \Doctrine\ORM\Query::HYDRATE_OBJECT );
				$user = $user[0];

				if ( !isset( $user ) ) {
					$message = 'Please enter a valid email and password.';
					return new JsonModel( array( 'login' => 'false', 'message' => $message ) );
				}

				$adapter->setIdentityValue( $user->getEmail() );
				$adapter->setCredentialValue( $data['password'] );

				$authResult = $authService->authenticate();
				if ( $authResult->isValid() ) {
					$identity = $authResult->getIdentity();
					$authService->getStorage()->write( $identity );

					if ( $data['rememberme'] ) {
						$time = 1209600; // 14 days (1209600/3600 = 336 hours => 336/24 = 14 days)
						$sessionManager = new SessionManager();
						$sessionManager->rememberMe( $time );
					}

					return new JsonModel( array( 'login' => 'true', 'message' => 'success' ) );;
				}

				foreach ( $authResult->getMessages() as $message ) {
					$messages .= "$message\n";
				}
			} catch ( \Exception $e ) {
				return new JsonModel( array( 'login' => 'false', 'message' => 'Unable to process request.  Please contact your administrator.' ) );;
			}

		}
		return new JsonModel( array( 'login' => 'false', 'message' => 'Please enter a valid email and password.' ) );
	}


}
