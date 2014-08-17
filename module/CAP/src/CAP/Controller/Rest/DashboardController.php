<?php
namespace CAP\Controller\Rest;

use Zend\Mvc\Controller\AbstractRestfulController;
use Zend\Session\SessionManager;
use Zend\Session\Config\StandardConfig;
use Zend\View\Model\JsonModel;
use CAP\Entity\Customer;
use CAP\Options\ModuleOptions;
use Doctrine\ORM\Query\ResultSetMapping;

class DashboardController extends AbstractRestfulController {

	public function get( $id ) {
		$logger = $this->getServiceLocator()->get( 'Log\App' );
		$logger->log( \Zend\Log\Logger::INFO, "Rest call to GET /dashboard/".$id );
		if ( $id == 'current' ) {
			$e = $this->getServiceLocator()->get( 'doctrine.entitymanager.orm_default' );
			$hydrator = new \DoctrineModule\Stdlib\Hydrator\DoctrineObject( $e );
			return new JsonModel( $hydrator->extract( $this->identity() ) );
		}
	}

	public function getList() {
		$e = $this->getServiceLocator()->get( 'doctrine.entitymanager.orm_default' );
		$logger = $this->getServiceLocator()->get( 'Log\App' );
		$logger->log( \Zend\Log\Logger::INFO, "Rest call to GET /dashboard" );
		//$logger->log( \Zend\Log\Logger::INFO, "Role is ".$this->identity()->getRole() );

		/* fetch the data for the dashboard depending on who is logged in */
		if ( $this->identity()->getRole()->getName() == "Admin" ) {
			/* get every mentee and their mentor */
			return new JsonModel(
				array(
					'saqList' => $this->getSAQList(),
					'mentors' => $this->getAllMentors(),
					'mentees' => $this->getAllMentees(),
					'admins'  => $this->getAllAdmins(),
				)
			);

		}

		if ( $this->identity()->getRole()->getName() == "Mentor" ) {
			/* get all mentees that are children of this mentor */
			/* get all mentees for this mentor */
			$sql = "SELECT c.id, c.name FROM CAP\Entity\CustomerHierarchy ch JOIN ch.childCustomer c WHERE ch.parentCustomerId = :parentId";
			$mentees = $this->getServiceLocator()->get( 'doctrine.entitymanager.orm_default' )->createQuery( $sql )
							 				->setParameter('parentId',$this->identity()->getId())
											->getResult( \Doctrine\ORM\Query::HYDRATE_OBJECT );

			return new JsonModel(array('mentees' => $mentees));
		}


		if ( $this->identity()->getRole()->getName() == "Mentee" ) {
			/* get mentor that is parent of this mentee */
			/* get all questionnaires for this mentee */
			$sql = "SELECT c.id, c.name FROM CAP\Entity\CustomerHierarchy ch JOIN ch.parentCustomer c WHERE ch.childCustomerId = :childId";
			$mentors = $e->createQuery( $sql )
							 		 ->setParameter('childId',$this->identity()->getId())
									 ->getResult( \Doctrine\ORM\Query::HYDRATE_ARRAY );

	    /* get all saqs for this mentee */
	    $saqs = $e->createQuery( "SELECT c.id, c.name, cs.name as completion_status FROM CAP\Entity\CustomerQuestionnaire q JOIN q.questionnaire c JOIN q.completionStatus cs where q.customer = :customerId" )
	              ->setParameter('customerId', $this->identity()->getId())
	              ->getResult( \Doctrine\ORM\Query::HYDRATE_OBJECT );

			return new JsonModel(array('mentors' => $mentors,
																 'saqs' => $saqs
																)
													);
		}


	}

	/* POST /dashboard */
	public function create( $data ) {
		$logger = $this->getServiceLocator()->get( 'Log\App' );
		return new JsonModel( array( 'login' => 'false', 'message' => 'Please enter a valid email and password.' ) );
	}

	private function getSAQList() {
		/* get SAQ List */
		$entityManager = $this->getServiceLocator()->get( 'doctrine.entitymanager.orm_default' );
		$saqList = $entityManager->createQuery( "SELECT q.name, q.id FROM CAP\Entity\Questionnaire q " )->getResult( \Doctrine\ORM\Query::HYDRATE_OBJECT );
		return $saqList;
	}

	private function getAllMentors() {
		$logger = $this->getServiceLocator()->get( 'Log\App' );
		$sql = "SELECT c.id, c.name, s.name as status FROM CAP\Entity\Customer c JOIN c.status s JOIN c.role r WHERE r.name = 'Mentor'";
		$mentors = $this->getServiceLocator()->get( 'doctrine.entitymanager.orm_default' )->createQuery( $sql )->getResult( \Doctrine\ORM\Query::HYDRATE_OBJECT );

		/* get each mentee's mentor */
		foreach ( $mentors as $idx => $mentor ) {
			$sql = "SELECT c.id, c.name FROM CAP\Entity\CustomerHierarchy ch JOIN ch.childCustomer c WHERE ch.parentCustomerId = ".$mentor['id'];
			$mentees = $this->getServiceLocator()->get( 'doctrine.entitymanager.orm_default' )->createQuery( $sql )->getResult( \Doctrine\ORM\Query::HYDRATE_OBJECT );
			$mentors[$idx]['mentees'] = $mentees;
		}
		return $mentors;
	}

	private function getAllAdmins() {
		$logger = $this->getServiceLocator()->get( 'Log\App' );
		/* get all admins */
		$sql = "SELECT c.id, c.name, s.name as status FROM CAP\Entity\Customer c JOIN c.status s JOIN c.role r WHERE r.name = 'Admin'";
		$admins = $this->getServiceLocator()->get( 'doctrine.entitymanager.orm_default' )->createQuery( $sql )->getResult( \Doctrine\ORM\Query::HYDRATE_OBJECT );
		return $admins;
	}

	private function getAllMentees() {
		$logger = $this->getServiceLocator()->get( 'Log\App' );
		/* get all mentees */
		$sql = "SELECT c.id, c.name FROM CAP\Entity\Customer c JOIN c.role r WHERE r.name = 'Mentee'";
		$mentees = $this->getServiceLocator()->get( 'doctrine.entitymanager.orm_default' )->createQuery( $sql )->getResult( \Doctrine\ORM\Query::HYDRATE_OBJECT );

		/* get each mentee's mentor */
		foreach ( $mentees as $idx => $mentee ) {
			$sql = "SELECT c.id, c.name FROM CAP\Entity\CustomerHierarchy ch JOIN ch.parentCustomer c WHERE ch.childCustomerId = ".$mentee['id'];
			$mentor = $this->getServiceLocator()->get( 'doctrine.entitymanager.orm_default' )->createQuery( $sql )->getResult( \Doctrine\ORM\Query::HYDRATE_OBJECT );
			$mentees[$idx]['status'] = $mentor && $mentor[0] ? 'Assigned' : 'Unassigned';
			if ($mentor && $mentor[0]) {
				$mentees[$idx]['mentor'] = $mentor;
			}
		}

		return $mentees;
	}

}
