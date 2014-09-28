<?php
namespace CAP\Service\Factory;

use Zend\ServiceManager\FactoryInterface;
use Zend\ServiceManager\ServiceLocatorInterface;
use CAP\Service\OrbitalResultsService;

class OrbitalResultsAlgorithmFactory implements FactoryInterface {
    public function createService(ServiceLocatorInterface $serviceLocator) {
        $o =  new OrbitalResultsService();
        $o->setServiceLocator($serviceLocator);
        return $o;
    }
}
