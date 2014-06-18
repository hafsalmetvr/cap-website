<?php

namespace cool-csn\Entity;

use Doctrine\ORM\Mapping as ORM;

/**
 * CustomerAnswer
 *
 * @ORM\Table(name="customer_answer", indexes={@ORM\Index(name="customer_id", columns={"customer_id"}), @ORM\Index(name="answer_id", columns={"answer_id"}), @ORM\Index(name="answer_enum_id", columns={"answer_enum_id"})})
 * @ORM\Entity
 */
class CustomerAnswer
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
     * @var string
     *
     * @ORM\Column(name="answer_text", type="text", nullable=true)
     */
    private $answerText;

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
     * @var \cool-csn\Entity\Customer
     *
     * @ORM\ManyToOne(targetEntity="cool-csn\Entity\Customer")
     * @ORM\JoinColumns({
     *   @ORM\JoinColumn(name="customer_id", referencedColumnName="id")
     * })
     */
    private $customer;

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
