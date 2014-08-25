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
		$logger        = $this->getServiceLocator()->get( 'Log\App' );
		$e = $this->getServiceLocator()->get('doctrine.entitymanager.orm_default');

		/* answer id -> point value for enum */
		$ascending = array(
			1 => 1,
			2 => 2,
			3 => 3,
			4 => 4,
			5 => 5
		);

		$descending = array(
			1 => 5,
			2 => 4,
			3 => 3,
			4 => 2,
			5 => 1
		);

		/* questionnaireId => sectionId => answerId */
		$scoringMap = array(
			1 => array(
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
					12 => $descending,
					13 => $ascending,
					14 => $ascending,
					15 => $descending,
					16 => $descending,
					17 => $ascending,
					18 => $ascending,
					19 => $descending,
					20 => $ascending,
					21 => $ascending,
				),
				3 => array(
					22 => $descending,
					23 => $descending,
					24 => $descending,
					25 => $ascending,
					26 => $ascending,
					27 => $descending,
					28 => $descending,
					29 => $descending,
					30 => $descending,
					31 => $ascending,
				),
			),
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
			$score[$s['id']] = array('count' => 0, 'tally' => 0, 'average' => 0, 'answers' => array());
			foreach ($res['questions'][$s['id']] as $q) {
				foreach ($res['answers'][$q['questionId']] as $a) {
					$points = $scoringMap[$qId][$s['id']][$a['answerId']][$a['answerEnumId']];
					//$logger->log( \Zend\Log\Logger::INFO, "points for ".$s['id']." ".$a['answerId']." ".$points );
					$score[$s['id']]['count']++;
					$score[$s['id']]['tally'] += $points;
					$score[$s['id']]['answers'][$a['answerId']] = $points;
					$tmp = array('answer' =>$a, 'section' => $s, 'score' => $points);
					$allAnswers[] = $tmp;
				}
			}
			$score[$s['id']]['average'] = number_format( ($score[$s['id']]['tally'] / $score[$s['id']]['count']), 2);
			$score['tally'] += $score[$s['id']]['tally'];
			$score['count'] += $score[$s['id']]['count'];
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
