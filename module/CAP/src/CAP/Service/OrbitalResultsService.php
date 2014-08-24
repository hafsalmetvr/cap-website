<?php

namespace CAP\Service;

class OrbitalResultsService {
	private $sl = null;

	public function setServiceLocator($sl) {
		$this->sl = $sl;
	}

	public function getServiceLocator() {
		return $this->sl;
	}

	public function compute($qId, $customer) {
		return array();
	}

}
