<?php
namespace CAP\Controller\Rest;

use Zend\Mvc\Controller\AbstractRestfulController;
use Zend\View\Model\JsonModel;

class QuestionnaireStatusController extends AbstractRestfulController {

  /* will return questionnaire info for the given id if Admin or one of the questionnaire's Mentees. */
	public function getList() {
		$logger = $this->getServiceLocator()->get( 'Log\App' );
    $logger->log( \Zend\Log\Logger::INFO, "Rest call to GET /questionnaire-status"  );

		/* must be logged in & must be either admin or a mentee of this mentor */
		if ( !$this->identity() ) {
			return JsonModel( array() );
		}

    $qId = $this->params()->fromRoute('questionId');
    $sectionNumber = $this->params()->fromRoute('sectionNumber');
    $cId = $this->params()->fromRoute('customerId');

		$entityManager = $this->getServiceLocator()->get( 'doctrine.entitymanager.orm_default' );

    /* get status of questionnaire and its sections */
    $customerSections = $entityManager->createQuery( "SELECT s.sectionNumber, cs2.name FROM CAP\Entity\CustomerSection cs JOIN cs.completionStatus cs2 JOIN cs.section s WHERE s.questionnaire = :questionnaireId AND s.sectionNumber = :sectionNumber AND cs.customer = :customerId ")
                                            ->setParameter('questionnaireId',$qId)
                                            ->setParameter('sectionNumber', $sectionNumber)
                                            ->setParameter('customerId', $cId)
                                            ->getResult( \Doctrine\ORM\Query::HYDRATE_ARRAY );

    $viewArgs = array('sections' => $customerSections);
    return new JsonModel($viewArgs);
	}

}
