DROP TABLE IF EXISTS version;
DROP TRIGGER IF EXISTS customer_recommendation_created;
DROP TABLE IF EXISTS customer_recommendation;
DROP TRIGGER IF EXISTS recommendation_created;
DROP TABLE IF EXISTS recommendation;
DROP TRIGGER IF EXISTS customer_answer_created;
DROP TABLE IF EXISTS customer_answer;
DROP TRIGGER IF EXISTS customer_question_created;
DROP TABLE IF EXISTS customer_question;
DROP TRIGGER IF EXISTS customer_section_created;
DROP TABLE IF EXISTS customer_section;
DROP TRIGGER IF EXISTS customer_questionnaire_created;
DROP TABLE IF EXISTS customer_questionnaire;
DROP TRIGGER IF EXISTS completion_status_created;
DROP TABLE IF EXISTS completion_status;
DROP TRIGGER IF EXISTS answer_enum_map_created;
DROP TABLE IF EXISTS answer_enum_map;
DROP TRIGGER IF EXISTS answer_enum_created;
DROP TABLE IF EXISTS answer_enum;
DROP TRIGGER IF EXISTS answer_created;
DROP TABLE IF EXISTS answer;
DROP TRIGGER IF EXISTS question_created;
DROP TABLE IF EXISTS question;
DROP TRIGGER IF EXISTS section_created;
DROP TABLE IF EXISTS section;
DROP TRIGGER IF EXISTS questionnaire_created;
DROP TABLE IF EXISTS questionnaire;
DROP TRIGGER IF EXISTS customer_property_created;
DROP TABLE IF EXISTS customer_property;
DROP TRIGGER IF EXISTS customer_hierarchy_created;
DROP TABLE IF EXISTS customer_hierarchy;
DROP TRIGGER IF EXISTS customer_created;
DROP TABLE IF EXISTS customer;
DROP TRIGGER IF EXISTS customer_status_created;
DROP TABLE IF EXISTS customer_status;
DROP TRIGGER IF EXISTS role_created;
DROP TABLE IF EXISTS role;
DROP TRIGGER IF EXISTS domain_created;
DROP TABLE IF EXISTS domain;
DROP TRIGGER IF EXISTS organization_created;
DROP TABLE IF EXISTS organization;


CREATE TABLE version (
  id int NOT NULL,
  modified timestamp NOT NULL default CURRENT_TIMESTAMP on update CURRENT_TIMESTAMP,
  PRIMARY KEY (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
INSERT INTO version (id) VALUES (1);

CREATE TABLE organization (
  id int NOT NULL auto_increment,
  name varchar(255) NOT NULL,
  created datetime NOT NULL,
  modified timestamp NOT NULL default CURRENT_TIMESTAMP on update CURRENT_TIMESTAMP,
  PRIMARY KEY (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
CREATE TRIGGER organization_created BEFORE INSERT ON organization FOR EACH ROW SET new.created = now();

CREATE TABLE domain (
	id int NOT NULL auto_increment,
	name varchar(255) NOT NULL,
	organization_id int NOT NULL,
  created datetime NOT NULL,
  modified timestamp NOT NULL default CURRENT_TIMESTAMP on update CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  KEY (organization_id),
  CONSTRAINT FOREIGN KEY (organization_id) REFERENCES organization (id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
CREATE TRIGGER domain_created BEFORE INSERT ON domain FOR EACH ROW SET new.created = now();

CREATE TABLE role (
	id int NOT NULL auto_increment,
	name varchar(255) NOT NULL,
	level int NOT NULL DEFAULT 0,
	domain_id int NOT NULL,
  created datetime NOT NULL,
  modified timestamp NOT NULL default CURRENT_TIMESTAMP on update CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  KEY (domain_id),
  CONSTRAINT FOREIGN KEY (domain_id) REFERENCES domain (id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TRIGGER role_created BEFORE INSERT ON role FOR EACH ROW SET new.created = now();

CREATE TABLE customer_status (
	id int NOT NULL auto_increment,
	name varchar(255) NOT NULL,
  created datetime NOT NULL,
  modified timestamp NOT NULL default CURRENT_TIMESTAMP on update CURRENT_TIMESTAMP,
	PRIMARY KEY (id),
	UNIQUE KEY (name)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TRIGGER customer_status_created BEFORE INSERT ON customer_status FOR EACH ROW SET new.created = now();
INSERT INTO customer_status (name) VALUES ('ACTIVE'),('INACTIVE'), ('DELETED');

CREATE TABLE customer (
  id int NOT NULL auto_increment,
  email varchar(255) NOT NULL,
  domain_id int NOT NULL,
  role_id int NOT NULL,
  first_name varchar(255) default NULL,
  last_name varchar(255) default NULL,
  password varchar(255) default NULL,
  status_id int(1) default 1,
  verify_email_token varchar(255) default NULL,
  created datetime NOT NULL,
  modified timestamp NOT NULL default CURRENT_TIMESTAMP on update CURRENT_TIMESTAMP,
  PRIMARY KEY  (id),
  UNIQUE KEY (email,domain_id),
  KEY (role_id),
  CONSTRAINT FOREIGN KEY (domain_id) REFERENCES domain (id) ON DELETE CASCADE,
  CONSTRAINT FOREIGN KEY (role_id) REFERENCES role (id) ON DELETE RESTRICT,
  CONSTRAINT FOREIGN KEY (status_id) REFERENCES customer_status (id) ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TRIGGER customer_created BEFORE INSERT ON customer FOR EACH ROW SET new.created = now();

CREATE TABLE customer_hierarchy (
	id int NOT NULL auto_increment,
	parent_customer_id int NOT NULL,
	child_customer_id int NOT NULL,
  created datetime NOT NULL,
  modified timestamp NOT NULL default CURRENT_TIMESTAMP on update CURRENT_TIMESTAMP,
	PRIMARY KEY (id),
	UNIQUE KEY (parent_customer_id),
	UNIQUE KEY (child_customer_id),
  CONSTRAINT FOREIGN KEY (parent_customer_id) REFERENCES customer (id) ON DELETE RESTRICT,
  CONSTRAINT FOREIGN KEY (child_customer_id) REFERENCES customer (id) ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TRIGGER customer_hierarchy_created BEFORE INSERT ON customer_hierarchy FOR EACH ROW SET new.created = now();

CREATE TABLE customer_property (
	id int NOT NULL auto_increment,
	customer_id int NOT NULL,
	name varchar(255) NOT NULL,
	value varchar(255) NOT NULL,
  created datetime NOT NULL,
  modified timestamp NOT NULL default CURRENT_TIMESTAMP on update CURRENT_TIMESTAMP,
	PRIMARY KEY (id),
	UNIQUE KEY (customer_id),
  CONSTRAINT FOREIGN KEY (customer_id) REFERENCES customer (id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TRIGGER customer_property_created BEFORE INSERT ON customer_property FOR EACH ROW SET new.created = now();

CREATE TABLE questionnaire (
	id int NOT NULL auto_increment,
	name varchar(255) NOT NULL,
	description text NOT NULL,
	organization_id int NOT NULL,
  created datetime NOT NULL,
  modified timestamp NOT NULL default CURRENT_TIMESTAMP on update CURRENT_TIMESTAMP,
	PRIMARY KEY (id),
	KEY (organization_id),
  CONSTRAINT FOREIGN KEY (organization_id) REFERENCES organization (id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TRIGGER questionnaire_created BEFORE INSERT ON questionnaire FOR EACH ROW SET new.created = now();

CREATE TABLE section (
	id int NOT NULL auto_increment,
	section_number int NOT NULL,
	name varchar(255) NOT NULL,
	description text NOT NULL DEFAULT "",
	section_order int NOT NULL DEFAULT 0,
	questionnaire_id int NOT NULL,
  created datetime NOT NULL,
  modified timestamp NOT NULL default CURRENT_TIMESTAMP on update CURRENT_TIMESTAMP,
	PRIMARY KEY (id),
	KEY (questionnaire_id),
  CONSTRAINT FOREIGN KEY (questionnaire_id) REFERENCES questionnaire (id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TRIGGER section_created BEFORE INSERT ON section FOR EACH ROW SET new.created = now();

CREATE TABLE question (
	id int NOT NULL auto_increment,
	question_number int NOT NULL,
	question_text text NOT NULL,
	question_order int NOT NULL DEFAULT 0,
	section_id int NOT NULL,
	questionnaire_id int NOT NULL,
  created datetime NOT NULL,
  modified timestamp NOT NULL default CURRENT_TIMESTAMP on update CURRENT_TIMESTAMP,
	PRIMARY KEY (id),
	KEY (questionnaire_id),
	KEY (section_id),
  CONSTRAINT FOREIGN KEY (questionnaire_id) REFERENCES questionnaire (id) ON DELETE CASCADE,
  CONSTRAINT FOREIGN KEY (section_id) REFERENCES section (id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TRIGGER question_created BEFORE INSERT ON question FOR EACH ROW SET new.created = now();

CREATE TABLE answer (
	id int NOT NULL auto_increment,
	answer_number int NOT NULL,
	answer_text text NOT NULL,
	answer_type enum('TEXT', 'CHECKBOX', 'RADIO', 'TEXTAREA', 'SELECT', 'MULTISELECT', 'ENUM') DEFAULT "TEXT",
	answer_order int NOT NULL DEFAULT 0,
	question_id int NOT NULL,
  created datetime NOT NULL,
  modified timestamp NOT NULL default CURRENT_TIMESTAMP on update CURRENT_TIMESTAMP,
	PRIMARY KEY (id),
	KEY (question_id),
  CONSTRAINT FOREIGN KEY (question_id) REFERENCES question (id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TRIGGER answer_created BEFORE INSERT ON answer FOR EACH ROW SET new.created = now();

CREATE TABLE answer_enum (
	id int NOT NULL auto_increment,
	name varchar(255) NOT NULL,
  created datetime NOT NULL,
  modified timestamp NOT NULL default CURRENT_TIMESTAMP on update CURRENT_TIMESTAMP,
  PRIMARY KEY (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TRIGGER answer_enum_created BEFORE INSERT ON answer_enum FOR EACH ROW SET new.created = now();

CREATE TABLE answer_enum_map (
	id int NOT NULL auto_increment,
	answer_id int NOT NULL,
	answer_enum_id int NOT NULL,
	answer_enum_order int NOT NULL DEFAULT 0,
  created datetime NOT NULL,
  modified timestamp NOT NULL default CURRENT_TIMESTAMP on update CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  KEY (answer_id),
  KEY (answer_enum_id),
  CONSTRAINT FOREIGN KEY (answer_id) REFERENCES answer (id) ON DELETE CASCADE,
  CONSTRAINT FOREIGN KEY (answer_enum_id) REFERENCES answer_enum (id) ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TRIGGER answer_enum_map_created BEFORE INSERT ON answer_enum_map FOR EACH ROW SET new.created = now();

CREATE TABLE completion_status (
	id int NOT NULL auto_increment,
	name varchar(255) NOT NULL,
  created datetime NOT NULL,
  modified timestamp NOT NULL default CURRENT_TIMESTAMP on update CURRENT_TIMESTAMP,
	PRIMARY KEY (id),
	UNIQUE KEY (name)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TRIGGER completion_status_created BEFORE INSERT ON completion_status FOR EACH ROW SET new.created = now();
INSERT INTO completion_status (name) VALUES ('NOT STARTED'),('NOT COMPLETED'),('COMPLETED');

CREATE TABLE recommendation (
	id int NOT NULL auto_increment,
	name varchar(255) NOT NULL,
	description text NOT NULL,
  created datetime NOT NULL,
  modified timestamp NOT NULL default CURRENT_TIMESTAMP on update CURRENT_TIMESTAMP,
	PRIMARY KEY (id),
	UNIQUE KEY (name)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TRIGGER recommendation_created BEFORE INSERT ON recommendation FOR EACH ROW SET new.created = now();


CREATE TABLE customer_questionnaire (
	id int NOT NULL auto_increment,
	customer_id int NOT NULL,
	questionnaire_id int NOT NULL,
	completion_status_id int NOT NULL,
	completed datetime DEFAULT NULL,
  created datetime NOT NULL,
  modified timestamp NOT NULL default CURRENT_TIMESTAMP on update CURRENT_TIMESTAMP,
	PRIMARY KEY (id),
	KEY (customer_id),
	KEY (questionnaire_id),
	KEY (completion_status_id),
  CONSTRAINT FOREIGN KEY (customer_id) REFERENCES customer (id) ON DELETE CASCADE,
  CONSTRAINT FOREIGN KEY (questionnaire_id) REFERENCES questionnaire (id) ON DELETE CASCADE,
  CONSTRAINT FOREIGN KEY (completion_status_id) REFERENCES completion_status (id) ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TRIGGER customer_questionnaire_created BEFORE INSERT ON customer_questionnaire FOR EACH ROW SET new.created = now();

CREATE TABLE customer_section (
	id int NOT NULL auto_increment,
	customer_id int NOT NULL,
	section_id int NOT NULL,
	completion_status_id int NOT NULL,
	completed datetime DEFAULT NULL,
  created datetime NOT NULL,
  modified timestamp NOT NULL default CURRENT_TIMESTAMP on update CURRENT_TIMESTAMP,
	PRIMARY KEY (id),
	KEY (customer_id),
	KEY (section_id),
	KEY (completion_status_id),
  CONSTRAINT FOREIGN KEY (customer_id) REFERENCES customer (id) ON DELETE CASCADE,
  CONSTRAINT FOREIGN KEY (section_id) REFERENCES section (id) ON DELETE CASCADE,
  CONSTRAINT FOREIGN KEY (completion_status_id) REFERENCES completion_status (id) ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TRIGGER customer_section_created BEFORE INSERT ON customer_section FOR EACH ROW SET new.created = now();

CREATE TABLE customer_question (
	id int NOT NULL auto_increment,
	customer_id int NOT NULL,
	question_id int NOT NULL,
	completion_status_id int NOT NULL,
	completed datetime DEFAULT NULL,
  created datetime NOT NULL,
  modified timestamp NOT NULL default CURRENT_TIMESTAMP on update CURRENT_TIMESTAMP,
	PRIMARY KEY (id),
	KEY (customer_id),
	KEY (question_id),
	KEY (completion_status_id),
  CONSTRAINT FOREIGN KEY (customer_id) REFERENCES customer (id) ON DELETE CASCADE,
  CONSTRAINT FOREIGN KEY (question_id) REFERENCES question (id) ON DELETE CASCADE,
  CONSTRAINT FOREIGN KEY (completion_status_id) REFERENCES completion_status (id) ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TRIGGER customer_question BEFORE INSERT ON customer_question FOR EACH ROW SET new.created = now();

CREATE TABLE customer_answer (
	id int NOT NULL auto_increment,
	customer_id int NOT NULL,
	answer_id int NOT NULL,
	answer_enum_id int DEFAULT NULL,
	answer_text text,
  created datetime NOT NULL,
  modified timestamp NOT NULL default CURRENT_TIMESTAMP on update CURRENT_TIMESTAMP,
	PRIMARY KEY (id),
	KEY (customer_id),
	KEY (answer_id),
	KEY (answer_enum_id),
  CONSTRAINT FOREIGN KEY (customer_id) REFERENCES customer (id) ON DELETE CASCADE,
  CONSTRAINT FOREIGN KEY (answer_id) REFERENCES answer (id) ON DELETE CASCADE,
  CONSTRAINT FOREIGN KEY (answer_enum_id) REFERENCES answer_enum (id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TRIGGER customer_answer BEFORE INSERT ON customer_answer FOR EACH ROW SET new.created = now();

CREATE TABLE customer_recommendation (
	id int NOT NULL auto_increment,
	customer_id int NOT NULL,
	questionnaire_id int NOT NULL,
	recommendation_id int NOT NULL,
  created datetime NOT NULL,
  modified timestamp NOT NULL default CURRENT_TIMESTAMP on update CURRENT_TIMESTAMP,
	PRIMARY KEY (id),
	KEY (customer_id),
	KEY (questionnaire_id),
	KEY (recommendation_id),
  CONSTRAINT FOREIGN KEY (customer_id) REFERENCES customer (id) ON DELETE CASCADE,
  CONSTRAINT FOREIGN KEY (questionnaire_id) REFERENCES questionnaire (id) ON DELETE CASCADE,
  CONSTRAINT FOREIGN KEY (recommendation_id) REFERENCES recommendation (id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TRIGGER customer_recommendation BEFORE INSERT ON customer_recommendation FOR EACH ROW SET new.created = now();

