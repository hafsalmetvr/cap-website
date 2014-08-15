<?php
namespace CAP\Controller\Rest;

use Zend\Mvc\Controller\AbstractRestfulController;
use Zend\Session\SessionManager;
use Zend\Session\Config\StandardConfig;
use Zend\View\Model\JsonModel;
use CAP\Entity\Customer;
use CAP\Options\ModuleOptions;
use Zend\Mail\Message;
use CAP\Service\UserService;

class NoteController extends AbstractRestfulController {

  /* will return note title and note data */
	public function get( $id ) {
		$logger = $this->getServiceLocator()->get( 'Log\App' );
		$logger->log( \Zend\Log\Logger::INFO, "Rest call to GET /mentor/".$id );

		/* must be logged in & must be either admin or a mentee of this mentor */
		if ( !$this->identity() ) {
			return JsonModel( array() );
		}

		$entityManager = $this->getServiceLocator()->get( 'doctrine.entitymanager.orm_default' );

    /* make sure you own this note or this note has been shared with you */

    /* TODO: implement this */

    return new JsonModel();

	}

	/* will return a list myNotes and sharedNotes for a given mentor-mentee relationship
    depending on context of who is logged in myNotes should be appropriate
  */
	public function getList() {

	}

	/* PUT /note/:id  - edit a note */
	public function update($id, $data) {
    if ( !$this->identity() ) {
      return JsonModel( array() );
    }


    $logger = $this->getServiceLocator()->get( 'Log\App' );
    $logger->log( \Zend\Log\Logger::INFO, $id);
    $logger->log( \Zend\Log\Logger::INFO, $data);

    /* make sure this is my note */
    $e = $this->getServiceLocator()->get( 'doctrine.entitymanager.orm_default' );
    $n = $e->getRepository('CAP\Entity\CustomerNote')->findOneBy(array('id' => $id, 'customerId' => $this->identity()->getId()));
    if (!$n) {
      return JsonModel( array() );
    }

    $n->setName($data['name']);
    $n->setNote($data['note']);

    $e->persist( $n );
    $e->flush();

    return new JsonModel(array('success' => true));
	}

  public function delete($id) {
    if ( !$this->identity() ) {
      return JsonModel( array() );
    }

    $logger = $this->getServiceLocator()->get( 'Log\App' );
    $logger->log( \Zend\Log\Logger::INFO, $id);

    /* make sure this is my note */
    $e = $this->getServiceLocator()->get( 'doctrine.entitymanager.orm_default' );
    $n = $e->getRepository('CAP\Entity\CustomerNote')->findOneBy(array('id' => $id, 'customerId' => $this->identity()->getId()));
    if (!$n) {
      return JsonModel( array() );
    }
    $e->remove($n);
    $e->flush();

    return new JsonModel(array('success' => true));
  }


	/* POST /customer - should create a new customer */
	public function create( $data ) {
		if ( !$this->identity() || !( $this->identity()->getRole()->getName() === 'Admin' ) ) {
			return JsonModel( array() );
		}
	}
}
