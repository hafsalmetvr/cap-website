<?php
namespace CAP\Service\Factory;

use Zend\ServiceManager\FactoryInterface;
use Zend\ServiceManager\ServiceLocatorInterface;
use CAP\Service\QuestionnaireService;

class QuestionnaireFactory implements FactoryInterface {
    public function createService(ServiceLocatorInterface $serviceLocator) {
        $q =  new QuestionnaireService();
        $q->setServiceLocator($serviceLocator);
        return $q;
    }
}
