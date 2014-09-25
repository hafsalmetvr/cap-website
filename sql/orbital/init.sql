use cap;
SET FOREIGN_KEY_CHECKS = 0;
delete from answer_enum;
alter table answer_enum auto_increment = 1;
delete from answer;
alter table answer auto_increment = 1;
delete from answer_enum_map;
alter table answer_enum_map auto_increment = 1;
delete from customer_answer;
alter table customer_answer auto_increment = 1;

delete from question;
alter table question auto_increment = 1;
delete from customer_question;
alter table customer_question auto_increment = 1;

delete from section;
alter table section auto_increment = 1;
delete from customer_section;
alter table customer_section auto_increment = 1;

delete from questionnaire;
alter table questionnaire auto_increment = 1;
delete from customer_questionnaire;
alter table customer_questionnaire auto_increment = 1;

delete from role;
alter table role auto_increment = 1;
delete from domain;
alter table domain auto_increment = 1;
delete from organization;
alter table organization auto_increment = 1;

-- organization stuff
insert into organization (name, template_dir) values ('Orbital ATK','orbital-atk');
SET @organization_id = LAST_INSERT_ID();

-- domain
insert into domain (name, organization_id) values ('go-optimum.com', @organization_id);
SET @domain_id = LAST_INSERT_ID();

-- roles
INSERT INTO `role` (name,level,domain_id) VALUES ('Admin',1,@domain_id),('Mentor',2,@domain_id),('Mentee',3,@domain_id);

SET FOREIGN_KEY_CHECKS = 1;
