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

	public function compute($qId, $qTemplate, $customer) {
		$logger        = $this->getServiceLocator()->get( 'Log\App' );
		$e = $this->getServiceLocator()->get('doctrine.entitymanager.orm_default');

		/* answer id -> point value for enum */
		$ascending = array(
			'Almost Never'     => 1,
			'Rarely'           => 2,
			'Sometimes'        => 3,
			'Often'            => 4,
			'Most of the time' => 5
		);

		$descending = array(
			'Almost Never'     => 5,
			'Rarely'           => 4,
			'Sometimes'        => 3,
			'Often'            => 2,
			'Most of the time' => 1
		);


		/* questionnaire->templateDir => sectionNumber => answerId */
		$scoringMap = array(
			'goal-setting-self-assessment' => array(
				1 => array(
					1 => $descending,
					2 => $ascending,
					3 => $ascending,
					4 => $ascending,
					5 => $ascending,
					6 => $ascending,
					7 => $ascending,
					8 => $ascending,
					9 => $ascending,
					10 => $ascending,
					11 => $ascending,
				),
				2 => array(
					1 => $descending,
					2 => $ascending,
					3 => $ascending,
					4 => $descending,
					5 => $descending,
					6 => $ascending,
					7 => $ascending,
					8 => $descending,
					9 => $ascending,
					10 => $ascending,
				),
				3 => array(
					1 => $descending,
					2 => $descending,
					3 => $descending,
					4 => $ascending,
					5 => $ascending,
					6 => $descending,
					7 => $descending,
					8 => $descending,
					9 => $descending,
					10 => $ascending,
				),
			),
			'communication-self-assessment' => array(
				1 => array(	)
			)
		);


		$res = array(
			'answers' => array(),
			'questions' => array(),
			'sections' => array(),
			'top-5' => array(),
			'bottom-5' => array(),
		);

    $answers = $e->createQuery( "SELECT a.answerNumber, a.id as answerId, a.answerOrder, a.answerText, a.questionId, ae.id as answerEnumId, ae.name, ca.answerText as customerAnswerText FROM CAP\Entity\CustomerAnswer ca JOIN ca.answer a LEFT JOIN ca.answerEnum ae JOIN a.question q WHERE q.questionnaire = :questionnaireId AND ca.customer = :customerId ORDER BY a.answerOrder" )
                                            ->setParameter('questionnaireId',$qId)
                                            ->setParameter('customerId',$customer->getId())
                                            ->getResult( \Doctrine\ORM\Query::HYDRATE_ARRAY );


    foreach ($answers as $a) {
    	if (!isset($res['answers'][$a['questionId']])) {
    		$res['answers'][$a['questionId']] = array();
    	}
    	$res['answers'][$a['questionId']][] = $a;
    }

    $questions = $e->createQuery( "SELECT q.questionNumber, q.id as questionId, q.questionOrder, q.questionText, q.sectionId, q.answerType FROM CAP\Entity\Question q WHERE q.questionnaire = :questionnaireId ORDER BY q.questionOrder" )
                                            ->setParameter('questionnaireId',$qId)
                                            ->getResult( \Doctrine\ORM\Query::HYDRATE_ARRAY );


    /* be able to look up question by sectionId */
    foreach ($questions as $q) {
    	if (!isset($res['questions'][$q['sectionId']])) {
    		$res['questions'][$q['sectionId']] = array();
    	}
    	$res['questions'][$q['sectionId']][] = $q;
    }


    $sections = $e->createQuery( "SELECT s.sectionNumber, s.name, s.description, s.sectionOrder, s.id FROM CAP\Entity\Section s WHERE s.questionnaire = :questionnaireId ORDER BY s.sectionOrder" )
                                            ->setParameter('questionnaireId',$qId)
                                            ->getResult( \Doctrine\ORM\Query::HYDRATE_ARRAY );


    /* be able to look up answer by questionId */
    foreach ($sections as $s) {
    	$res['sections'][] = $s;
    }

    $allAnswers = array();

		$score = array('tally' => 0,'average' => 0, 'count' => 0);
		foreach ($res['sections'] as $s) {
			$score[$s['sectionNumber']] = array('count' => 0, 'tally' => 0, 'average' => 0, 'answers' => array());
			foreach ($res['questions'][$s['id']] as $q) {
				foreach ($res['answers'][$q['questionId']] as $a) {
					$points = $scoringMap[$qTemplate][$s['sectionNumber']][$a['answerNumber']][$a['name']];
					//$logger->log( \Zend\Log\Logger::INFO, "points for ".$s['id']." ".$a['answerId']." ".$points );
					$score[$s['sectionNumber']]['count']++;
					$score[$s['sectionNumber']]['tally'] += $points;
					$score[$s['sectionNumber']]['answers'][$a['answerNumber']] = $points;
					$tmp = array('answer' =>$a, 'section' => $s, 'score' => $points);
					$allAnswers[] = $tmp;
				}
			}
			$score[$s['sectionNumber']]['average'] = number_format( ($score[$s['sectionNumber']]['tally'] / $score[$s['sectionNumber']]['count']), 2);
			$score['tally'] += $score[$s['sectionNumber']]['tally'];
			$score['count'] += $score[$s['sectionNumber']]['count'];
		}
		$score['average'] = number_format( ($score['tally'] / $score['count']), 2 );
		$res['score'] = $score;

		/* determine top 5 and bottom 5 */
		usort($allAnswers, function($a, $b) {
			if ($a['score'] === $b['score']) {
				return 0;
			}
			return ($a['score'] > $b['score']);
		});

		$res['bottom-5'] = array_slice($allAnswers,0,5);
		$res['top-5'] = array_slice($allAnswers,count($allAnswers)-5);

		$logger->log( \Zend\Log\Logger::INFO, $res['top-5']);
		$logger->log( \Zend\Log\Logger::INFO, $res['bottom-5']);


    return $res;
	}

}
