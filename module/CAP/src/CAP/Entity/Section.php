<?php

namespace CAP\Entity;

use Doctrine\ORM\Mapping as ORM;

/**
 * Section
 *
 * @ORM\Table(name="section", indexes={@ORM\Index(name="questionnaire_id", columns={"questionnaire_id"})})
 * @ORM\Entity
 */
class Section {
    /**
     * @var integer
     *
     * @ORM\Column(name="id", type="integer", nullable=false)
     * @ORM\Id
     * @ORM\GeneratedValue(strategy="IDENTITY")
     */
    private $id;

    public function getId() {
        return $this->id;
    }

    /**
     * @var integer
     *
     * @ORM\Column(name="section_number", type="integer", nullable=false)
     */
    private $sectionNumber;

    public function getSectionNumber() {
        return $this->id;
    }

    /**
     * @var string
     *
     * @ORM\Column(name="name", type="string", length=255, nullable=false)
     */
    private $name;

    /**
     * Set Name
     *
     * @param  string $name
     * @return User
     */
    public function setName($name) {
        $this->name = $name;

        return $this;
    }

    /**
     * Get Name
     *
     * @return string
     */
    public function getName() {
        return $this->name;
    }



    /**
     * @var string
     *
     * @ORM\Column(name="description", type="text", nullable=false)
     */
    private $description;

    public function getDescription() {
        return $this->description;
    }

    /**
     * @var integer
     *
     * @ORM\Column(name="section_order", type="integer", nullable=false)
     */
    private $sectionOrder = '0';

    public function getSectionOrder() {
        return $this->sectionOrder;
    }

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
}
