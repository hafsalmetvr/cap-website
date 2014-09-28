<?php
namespace CAP\Controller\Rest;

use Zend\Mvc\Controller\AbstractRestfulController;
use Zend\View\Model\JsonModel;
use Zend\Session\Container;

class ManageQuestionnaireApiController extends AbstractRestfulController {
	
  /**
	 * Function to get questionnaire details
	 * @author <hareendranath777@gmail.com>
	 * @return string JSON string to the client side
  */
  public function get( $id ) {
  	    if($id){  	
		    $e = $this->getServiceLocator()->get( 'doctrine.entitymanager.orm_default' ); 
		    $qs = $e->createQuery("SELECT qs.id, qs.name as questionName, qs.description, sec.name as sectionName FROM CAP\Entity\Questionnaire qs JOIN CAP\Entity\Section sec WHERE sec.questionnaire = qs.id AND qs.id = :questionnaireId")
		            ->setParameter('questionnaireId', $id)
		            ->getResult( \Doctrine\ORM\Query::HYDRATE_ARRAY );
		    $q[0]['name'] = $qs[0]['questionName'];
			$q[0]['description'] = $qs[0]['description'];
			$q[0]['sections'] = $qs[0]['sectionName'];
			
		    return new JsonModel($qs[0]);
  	    } 
	}
  

}
