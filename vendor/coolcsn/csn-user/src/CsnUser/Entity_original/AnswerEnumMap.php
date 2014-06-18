<?php

namespace cool-csn\Entity;

use Doctrine\ORM\Mapping as ORM;

/**
 * AnswerEnumMap
 *
 * @ORM\Table(name="answer_enum_map", indexes={@ORM\Index(name="answer_id", columns={"answer_id"}), @ORM\Index(name="answer_enum_id", columns={"answer_enum_id"})})
 * @ORM\Entity
 */
class AnswerEnumMap
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
     * @ORM\Column(name="answer_enum_order", type="integer", nullable=false)
     */
    private $answerEnumOrder = '0';

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
     * @var \cool-csn\Entity\Answer
     *
     * @ORM\ManyToOne(targetEntity="cool-csn\Entity\Answer")
     * @ORM\JoinColumns({
     *   @ORM\JoinColumn(name="answer_id", referencedColumnName="id")
     * })
     */
    private $answer;

    /**
     * @var \cool-csn\Entity\AnswerEnum
     *
     * @ORM\ManyToOne(targetEntity="cool-csn\Entity\AnswerEnum")
     * @ORM\JoinColumns({
     *   @ORM\JoinColumn(name="answer_enum_id", referencedColumnName="id")
     * })
     */
    private $answerEnum;


}
