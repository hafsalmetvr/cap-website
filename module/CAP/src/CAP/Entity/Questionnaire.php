<?php

namespace CAP\Entity;

use Doctrine\ORM\Mapping as ORM;

/**
 * Questionnaire
 *
 * @ORM\Table(name="questionnaire", indexes={@ORM\Index(name="organization_id", columns={"organization_id"})})
 * @ORM\Entity
 */
class Questionnaire {
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
     * @ORM\Column(name="questions_per_page", type="integer", nullable=false)
     */
    private $questionsPerPage;

    public function getQuestionsPerPage() {
        return $this->questionsPerPage;
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
     * @ORM\Column(name="template_dir", type="string", length=255, nullable=false)
     */
    private $templateDir;
    public function getTemplateDir() {
        return $this->templateDir;
    }


    /**
     * @var string
     *
     * @ORM\Column(name="description", type="text", nullable=false)
     */
    private $description;

    /**
     * Set Name
     *
     * @param  string $name
     * @return User
     */
    public function setDescription($desc) {
        $this->description = $desc;

        return $this;
    }

    /**
     * Get Name
     *
     * @return string
     */
    public function getDescription() {
        return $this->description;
    }

    /**
     * @var string
     *
     * @ORM\Column(name="type", type="string", columnDefinition="ENUM('QUESTIONNAIRE','FORM')")
     */
    protected $type;

    public function getType() {
        return $this->type;
    }

    public function setType($type) {
        $this->type = $type;
        return $this;
    }
    /**
     * Set Name
     *
     * @param  string $name
     * @return User
     */
    public function setSectionOrder($order) {
        $this->sectionOrder = $order;

        return $this;
    }

    /**
     * Get Name
     *
     * @return string
     */
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
     * @var \CAP\Entity\Organization
     *
     * @ORM\ManyToOne(targetEntity="CAP\Entity\Organization")
     * @ORM\JoinColumns({
     *   @ORM\JoinColumn(name="organization_id", referencedColumnName="id")
     * })
     */
    private $organization;


}
