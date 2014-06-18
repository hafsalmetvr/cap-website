<?php

namespace cool-csn\Entity;

use Doctrine\ORM\Mapping as ORM;

/**
 * Question
 *
 * @ORM\Table(name="question", indexes={@ORM\Index(name="questionnaire_id", columns={"questionnaire_id"}), @ORM\Index(name="section_id", columns={"section_id"})})
 * @ORM\Entity
 */
class Question
{
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
     * @var \cool-csn\Entity\Questionnaire
     *
     * @ORM\ManyToOne(targetEntity="cool-csn\Entity\Questionnaire")
     * @ORM\JoinColumns({
     *   @ORM\JoinColumn(name="questionnaire_id", referencedColumnName="id")
     * })
     */
    private $questionnaire;

    /**
     * @var \cool-csn\Entity\Section
     *
     * @ORM\ManyToOne(targetEntity="cool-csn\Entity\Section")
     * @ORM\JoinColumns({
     *   @ORM\JoinColumn(name="section_id", referencedColumnName="id")
     * })
     */
    private $section;


}
