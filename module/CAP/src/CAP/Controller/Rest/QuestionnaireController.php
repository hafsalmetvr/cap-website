<?php
namespace CAP\Controller\Rest;

use Zend\Mvc\Controller\AbstractRestfulController;
use Zend\View\Model\JsonModel;
use CAP\Entity\Customer;
use CAP\Entity\CustomerQuestionnaire;
use CAP\Entity\Questionnaire;

class QuestionnaireController extends AbstractRestfulController {

  /**
   * @var Zend\Mvc\I18n\Translator
   */
  protected $translatorHelper;

  /* will return questionnaire info for the given id if Admin or one of the questionnaire's Mentees. */
	public function get( $id ) {
		$logger = $this->getServiceLocator()->get( 'Log\App' );
		$logger->log( \Zend\Log\Logger::INFO, "Rest call to GET /mentor/".$id );
    $cId = $this->params()->fromRoute('customerId');
    $qService = $this->getServiceLocator()->get( 'cap_questionnaire_service' );

		/* must be logged in & must be either admin or a mentee of this mentor */
		if ( !$this->identity() ) {
			return JsonModel( array() );
		}

    $p = $qService->checkPermissions($id, $cId, $this->identity());
    if (!$p) {
      return new JsonModel();
    }

		$e = $this->getServiceLocator()->get( 'doctrine.entitymanager.orm_default' );
    $q = $e->createQuery( "SELECT q FROM CAP\Entity\Questionnaire q WHERE q.id = :questionnaireId" )
           ->setParameter('questionnaireId', $id)
           ->getResult( \Doctrine\ORM\Query::HYDRATE_ARRAY );

    $cq = $e->createQuery("SELECT cq.id, cq.completed, cs.name as completionStatus FROM CAP\Entity\CustomerQuestionnaire cq JOIN CAP\Entity\CompletionStatus cs WHERE cs.id = cq.completionStatus AND cq.customer = :customerId AND cq.questionnaire = :questionnaireId")
            ->setParameter('questionnaireId', $id)
            ->setParameter('customerId', $cId)
            ->getResult( \Doctrine\ORM\Query::HYDRATE_ARRAY );

    $q[0]['completed'] = $cq[0]['completed'];
    $q[0]['completionStatus'] = $cq[0]['completionStatus'];

    return new JsonModel($q[0]);

	}

	/* will return a list of questionnaires that belong to the logged in user (or all mentors if Admin) */
	public function getList() {
		if ( !$this->identity() ) {
			return JsonModel( array() );
		}

		$logger = $this->getServiceLocator()->get( 'Log\App' );
		$logger->log( \Zend\Log\Logger::INFO, "Rest call to /customer" );

		$e = $this->getServiceLocator()->get( 'doctrine.entitymanager.orm_default' );
    $r = $e->createQuery( "SELECT q FROM CAP\Entity\Questionnaire q" )->getResult( \Doctrine\ORM\Query::HYDRATE_OBJECT );

		$results = array();

		foreach ($q as $questionnaire) {
			array_push($results, array('id' => $questionnaire->getId(),
																 'name'=> $questionnaire->getName()));
		}
		return new JsonModel(array('questionnaires' => $results));
	}

	/* PUT /questionnaire/:id
	 * if a mentee is passed in, questionnaire will be assigned to the mentee
	 */
	public function update($id, $data) {

		if ( !$this->identity() || !( $this->identity()->getRole()->getName() === 'Admin' ) ) {
			return JsonModel( array() );
		}


		$logger = $this->getServiceLocator()->get( 'Log\App' );
		$logger->log( \Zend\Log\Logger::INFO, $id);
    $logger->log( \Zend\Log\Logger::INFO, $data);

		$e = $this->getServiceLocator()->get( 'doctrine.entitymanager.orm_default' );

		if ($data['account']) {

			/* check if this questionnaire is already assigned to this account */
	    $cq = $e->createQuery( "SELECT cq FROM CAP\Entity\CustomerQuestionnaire cq WHERE cq.questionnaireId = :questionnaireId AND cq.customerId = :accountId" )
	    				->setParameter('accountId',$data['account'])
	    				->setParameter('questionnaireId',$id)
	    				->getResult( \Doctrine\ORM\Query::HYDRATE_OBJECT );

	    if ( $cq ) {
        /* TODO: handlethis better */
        $logger->log( \Zend\Log\Logger::INFO, "already assigned");
        return new JsonModel(array('success' => true));
	    }

      try {
        $now = date("Y-m-d H:i:s");

        /* add section and question rows to customer_section and customer_question */
        $cq = new \CAP\Entity\CustomerQuestionnaire;
        $cq->setCustomer( $e->find( 'CAP\Entity\Customer', $data['account'] ) );
        $cq->setCompletionStatus( $e->getRepository('CAP\Entity\CompletionStatus')->findOneBy( array('name' => 'NOT STARTED') ) );
        $cq->setQuestionnaire( $e->find( 'CAP\Entity\Questionnaire', $id ) );
        $e->persist( $cq );

        /* for each section of the questionnaire */
        $sections = $e->getRepository("\CAP\Entity\Section")->findBy(array("questionnaire" => $id));
        foreach ($sections as $section) {
          $cs = new \CAP\Entity\CustomerSection;
          $cs->setCustomer( $e->find( 'CAP\Entity\Customer', $data['account'] ) );
          $cs->setCompletionStatus( $e->getRepository('CAP\Entity\CompletionStatus')->findOneBy( array('name' => 'NOT STARTED') ) );
          $cs->setSection( $e->find( 'CAP\Entity\Section', $section->getId() ) );
          $cs->setCreated($now);
          $e->persist( $cs );
        }

        /* get all the questions for this questionnaire */
        $questions = $e->getRepository("\CAP\Entity\Question")->findBy(array("questionnaire" => $id));
        foreach ($questions as $q) {
          $cq2 = new \CAP\Entity\CustomerQuestion;
          $cq2->setCustomer( $e->find( 'CAP\Entity\Customer', $data['account'] ) );
          $cq2->setCompletionStatus( $e->getRepository('CAP\Entity\CompletionStatus')->findOneBy( array('name' => 'NOT STARTED') ) );
          $cq2->setQuestion( $e->find( 'CAP\Entity\Question', $q->getId() ) );
          $cq2->setCreated($now);
          $e->persist( $cq2 );
        }
      } catch (Exception $e) {
        return new JsonModel(array('success' => false));
      }
	    $e->flush();
		}

    return new JsonModel(array('success' => true));
	}

	/* POST /customer - should create a new customer */
	public function create( $data ) {
		if ( !$this->identity() || !( $this->identity()->getRole()->getName() === 'Admin' ) ) {
			return JsonModel( array() );
		}

		/* TODO Validate $data */
		if (!$data['email']) {
			return new JsonModel(array('status' => false, 'error' => 'Email is required'));
		}


		$logger = $this->getServiceLocator()->get( 'Log\App' );
		$logger->log( \Zend\Log\Logger::INFO, $data );

		$entityManager = $this->getServiceLocator()->get( 'doctrine.entitymanager.orm_default' );
		$c = $entityManager->createQuery( "SELECT u FROM CAP\Entity\Customer u WHERE u.email = :email" )
			->setParameter('email', $data['email'])
			->getResult( \Doctrine\ORM\Query::HYDRATE_OBJECT );

		/* if there's no existing customer then its ok to create one */
		if ( !$c ) {

			$customer = new Customer;
			/* TODO : make domain a global */
			$customer->setDomain( $entityManager->find( 'CAP\Entity\Domain', 3 ) );
			$customer->setRole(   $entityManager->find( 'CAP\Entity\Role', $data['role_id'] ) );

			$customer->setStatus( $entityManager->find( 'CAP\Entity\CustomerStatus', 2 ) );
			$customer->setName( $data['name'] );
			$customer->setEmail( $data['email'] );
			$customer->setRegistrationToken( md5( uniqid( mt_rand(), true ) ) );
			$customer->setPassword( UserService::encryptPassword( $this->generatePassword() ) );

			try {
				$fullLink = $this->getBaseUrl() . $this->url()->fromRoute( 'dashboard', array( 'action' => 'confirm-email', 'id' => $customer->getRegistrationToken() ) );
				$this->sendEmail(
					$customer->getEmail(),
					$this->getTranslatorHelper()->translate( 'Please, confirm your registration!' ),
					sprintf( $this->getTranslatorHelper()->translate( 'Please, click the link to confirm your registration => %s' ), $fullLink )
				);
				$entityManager->persist( $customer );
				$entityManager->flush();

				return new JsonModel( array( 'success' => true, 'message' => 'An email has been sent to '.$customer->getEmail() ) );
			} catch ( \Exception $e ) {
				$logger->log( \Zend\Log\Logger::INFO, $e );
				return new JsonModel( array( 'success' => false, 'message' =>'Something went wrong when trying to send the activation email! Please contact your administrator.' ) );
			}
		} else {
			return new JsonModel( array( 'success' => false, 'message' =>'This email is already registered' ) );
		}
	}

  /**
   * Generate Password
   *
   * Generates random password
   *
   * @return String
   */
  private function generatePassword($l = 8, $c = 0, $n = 0, $s = 0) {
      $count = $c + $n + $s;
      $out = '';
      if(!is_int($l) || !is_int($c) || !is_int($n) || !is_int($s)) {
          trigger_error('Argument(s) not an integer', E_USER_WARNING);
          return false;
      } else if($l < 0 || $l > 20 || $c < 0 || $n < 0 || $s < 0) {
          trigger_error('Argument(s) out of range', E_USER_WARNING);
          return false;
      } else if($c > $l) {
          trigger_error('Number of password capitals required exceeds password length', E_USER_WARNING);
          return false;
      } else if($n > $l) {
          trigger_error('Number of password numerals exceeds password length', E_USER_WARNING);
          return false;
      } else if($s > $l) {
          trigger_error('Number of password capitals exceeds password length', E_USER_WARNING);
          return false;
      } else if($count > $l) {
          trigger_error('Number of password special characters exceeds specified password length', E_USER_WARNING);
          return false;
      }

      $chars = "abcdefghijklmnopqrstuvwxyz";
      $caps = strtoupper($chars);
      $nums = "0123456789";
      $syms = "!@#$%^&*()-+?";

      for ($i = 0; $i < $l; $i++) {
          $out .= substr($chars, mt_rand(0, strlen($chars) - 1), 1);
      }

      if($count) {
          $tmp1 = str_split($out);
          $tmp2 = array();

          for ($i = 0; $i < $c; $i++) {
              array_push($tmp2, substr($caps, mt_rand(0, strlen($caps) - 1), 1));
          }

          for ($i = 0; $i < $n; $i++) {
              array_push($tmp2, substr($nums, mt_rand(0, strlen($nums) - 1), 1));
          }

          for ($i = 0; $i < $s; $i++) {
              array_push($tmp2, substr($syms, mt_rand(0, strlen($syms) - 1), 1));
          }

          $tmp1 = array_slice($tmp1, 0, $l - $count);
          $tmp1 = array_merge($tmp1, $tmp2);
          shuffle($tmp1);
          $out = implode('', $tmp1);
      }

      return $out;
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
