<?php

namespace cool-csn\Entity;

use Doctrine\ORM\Mapping as ORM;

/**
 * QuestionnaireTagMap
 *
 * @ORM\Table(name="questionnaire_tag_map", indexes={@ORM\Index(name="questionnaire_id", columns={"questionnaire_id"}), @ORM\Index(name="tag_id", columns={"tag_id"})})
 * @ORM\Entity
 */
class QuestionnaireTagMap
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
     * @var \cool-csn\Entity\Questionnaire
     *
     * @ORM\ManyToOne(targetEntity="cool-csn\Entity\Questionnaire")
     * @ORM\JoinColumns({
     *   @ORM\JoinColumn(name="questionnaire_id", referencedColumnName="id")
     * })
     */
    private $questionnaire;

    /**
     * @var \cool-csn\Entity\Tag
     *
     * @ORM\ManyToOne(targetEntity="cool-csn\Entity\Tag")
     * @ORM\JoinColumns({
     *   @ORM\JoinColumn(name="tag_id", referencedColumnName="id")
     * })
     */
    private $tag;


}
