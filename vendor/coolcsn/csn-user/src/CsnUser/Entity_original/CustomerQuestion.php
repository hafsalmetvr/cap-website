<?php

namespace cool-csn\Entity;

use Doctrine\ORM\Mapping as ORM;

/**
 * CustomerQuestion
 *
 * @ORM\Table(name="customer_question", indexes={@ORM\Index(name="customer_id", columns={"customer_id"}), @ORM\Index(name="question_id", columns={"question_id"}), @ORM\Index(name="completion_status_id", columns={"completion_status_id"})})
 * @ORM\Entity
 */
class CustomerQuestion
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
     * @var \DateTime
     *
     * @ORM\Column(name="completed", type="datetime", nullable=true)
     */
    private $completed;

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
     * @var \cool-csn\Entity\Question
     *
     * @ORM\ManyToOne(targetEntity="cool-csn\Entity\Question")
     * @ORM\JoinColumns({
     *   @ORM\JoinColumn(name="question_id", referencedColumnName="id")
     * })
     */
    private $question;

    /**
     * @var \cool-csn\Entity\CompletionStatus
     *
     * @ORM\ManyToOne(targetEntity="cool-csn\Entity\CompletionStatus")
     * @ORM\JoinColumns({
     *   @ORM\JoinColumn(name="completion_status_id", referencedColumnName="id")
     * })
     */
    private $completionStatus;


}
