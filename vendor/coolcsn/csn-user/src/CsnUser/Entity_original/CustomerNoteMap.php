<?php

namespace cool-csn\Entity;

use Doctrine\ORM\Mapping as ORM;

/**
 * CustomerNoteMap
 *
 * @ORM\Table(name="customer_note_map", indexes={@ORM\Index(name="customer_id", columns={"customer_id"}), @ORM\Index(name="customer_note_id", columns={"customer_note_id"})})
 * @ORM\Entity
 */
class CustomerNoteMap
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
     * @var \cool-csn\Entity\CustomerNote
     *
     * @ORM\ManyToOne(targetEntity="cool-csn\Entity\CustomerNote")
     * @ORM\JoinColumns({
     *   @ORM\JoinColumn(name="customer_note_id", referencedColumnName="id")
     * })
     */
    private $customerNote;


}
