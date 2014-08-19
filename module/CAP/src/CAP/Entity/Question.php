<?php

namespace CAP\Entity;

use Doctrine\ORM\Mapping as ORM;

/**
 * Question
 *
 * @ORM\Table(name="question", indexes={@ORM\Index(name="questionnaire_id", columns={"questionnaire_id"}), @ORM\Index(name="section_id", columns={"section_id"})})
 * @ORM\Entity
 */
class Question {
    /**
     * @var integer
     *
     * @ORM\Column(name="id", type="integer", nullable=false)
     * @ORM\Id
     * @ORM\GeneratedValue(strategy="IDENTITY")
     */
    private $id;

    /**
     * @var integer
     *
     * @ORM\Column(name="question_number", type="integer", nullable=false)
     */
    private $questionNumber;

    /**
     * @var string
     *
     * @ORM\Column(name="question_text", type="text", nullable=false)
     */
    private $questionText;

    /**
     * @var integer
     *
     * @ORM\Column(name="question_order", type="integer", nullable=false)
     */
    private $questionOrder = '0';

    /**
     * @var \DateTime
     *
     * @ORM\Column(name="created", type="datetime", nullable=false)
     */
    private $created;

    /**
     * @var \DateTime
     *
     * @ORM\Column(name="modified", type="datetime", nullable=false)
     */
    private $modified = 'CURRENT_TIMESTAMP';

    /**
     * @var \CAP\Entity\Questionnaire
     *
     * @ORM\ManyToOne(targetEntity="CAP\Entity\Questionnaire")
     * @ORM\JoinColumns({
     *   @ORM\JoinColumn(name="questionnaire_id", referencedColumnName="id")
     * })
     */
    private $questionnaire;
    public function getQuestionnaire() {
        return $this->questionnaire;
    }

    /**
     * @var \CAP\Entity\Section
     *
     * @ORM\ManyToOne(targetEntity="CAP\Entity\Section")
     * @ORM\JoinColumns({
     *   @ORM\JoinColumn(name="section_id", referencedColumnName="id")
     * })
     */
    private $section;
    public function getSection() {
        return $this->section;
    }

    /**
     * @var string
     *
     * @ORM\Column(name="section_id", type="integer", length=255, nullable=true)
     */

    private $sectionId;

     /**
     * @var string
     *
     * @ORM\Column(name="questionnaire_id", type="integer", length=255, nullable=true)
     */

    private $questionnaireId;

    /**
     * @var string
     *
     * @ORM\Column(name="answer_type", type="string", nullable=true)
     */
    private $answerType = 'TEXT';


     /**
     * Get id
     *
     * @return integer
     */
    public function getId() {
        return $this->id;
    }

     /**
     * Get sectionid
     *
     * @return sectionid
     */
    public function getSectionId() {
        return $this->sectionId;
    }

    /**
     * Get questionnaireid
     *
     * @return questionnaireid
     */
    public function getQuestionnaireId() {
        return $this->questionnaireId;
    }

    /**
     * Get questionOrder
     *
     * @return QuestionOrder
     */
    public function getQuestionOrder() {
        return $this->questionOrder;
    }
    public function getQuestionNumber() {
        return $this->questionNumber;
    }
    public function getQuestionText() {
        return $this->questionText;
    }

    public function getAnswerType() {
        return $this->answerType;
    }
}

