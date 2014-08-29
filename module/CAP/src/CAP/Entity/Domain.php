<?php
namespace CAP\Entity;

use Doctrine\ORM\Mapping as ORM;

/**
 * State
 *
 * @ORM\Table(name="domain")
 * @ORM\Entity
 */
class Domain {
    /**
     * @var integer
     *
     * @ORM\Column(name="id", type="integer")
     * @ORM\Id
     * @ORM\GeneratedValue(strategy="IDENTITY")
     */
    protected $id;

    /**
     * @var string
     *
     * @ORM\Column(name="name", type="string", length=50, nullable=false, unique=true)
     */
    protected $name;

    /**
     * @var CAP\Entity\Organization
     *
     * @ORM\ManyToOne(targetEntity="CAP\Entity\Organization")
     * @ORM\JoinColumn(name="organization_id", referencedColumnName="id", nullable=false)
     */
    protected $organization;

    public function getOrganization() {
        return $this->organization;
    }

    public function setOrganization($o) {
        $this->organization = $o;
        return $this;
    }


    /**
     * Get id
     *
     * @return integer
     */
    public function getId() {
        return $this->id;
    }

    /**
     * Set state
     *
     * @param  string   $state
     * @return Language
     */
    public function setName($name) {
        $this->name = $name;

        return $this;
    }

    /**
     * Get state
     *
     * @return string
     */
    public function getName() {
        return $this->name;
    }
}
