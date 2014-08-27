use cap;
SET FOREIGN_KEY_CHECKS = 0;

SELECT id INTO @organization_id FROM organization WHERE name = 'Orbital ATK';

-- insert the pre assessment
insert into questionnaire (name, description, organization_id, questions_per_page) values ('Mentee Pre-Assessment', '', @organization_id, 1);
SET @questionnaire_id = LAST_INSERT_ID();

-- insert questionnaire sections
insert into section (section_number, name, section_order, questionnaire_id) values (1, 'Professional Development:  Knowledge of Orbital', 1, @questionnaire_id);
SET @section_id = LAST_INSERT_ID();

-- questions
insert into question (question_number, question_text, question_order, section_id, questionnaire_id, answer_type) values (1, 'Have you read Orbital\'s company overview via orbital.com?', 1, @section_id, @questionnaire_id, 'TEXTAREA');
SET @question_id = LAST_INSERT_ID();

-- possible answers
insert into answer (answer_number, answer_text, answer_order, question_id) values (1, '', 1, @question_id);
SET @answer_id = LAST_INSERT_ID();


insert into question (question_number, question_text, question_order, section_id, questionnaire_id, answer_type) values (1, 'Do you understand Orbital\'s mission, strategic goals, and strategic objectives?', 1, @section_id, @questionnaire_id, 'TEXTAREA');
SET @question_id = LAST_INSERT_ID();

insert into answer (answer_number, answer_text, answer_order, question_id) values (1, '', 1, @question_id);
SET @answer_id = LAST_INSERT_ID();

insert into question (question_number, question_text, question_order, section_id, questionnaire_id, answer_type) values (1, 'Do you understand the roles and functions carried out by the various organizational elements that support Orbital, such as:', 1, @section_id, @questionnaire_id, 'CHECKBOX');
SET @question_id = LAST_INSERT_ID();

insert into answer (answer_number, answer_text, answer_order, question_id) values (1, 'Business Groups and Corporate Departments', 1, @question_id);
SET @answer_id = LAST_INSERT_ID();
insert into answer (answer_number, answer_text, answer_order, question_id) values (1, 'Programs', 1, @question_id);
SET @answer_id = LAST_INSERT_ID();
insert into answer (answer_number, answer_text, answer_order, question_id) values (1, 'Business Development', 1, @question_id);
SET @answer_id = LAST_INSERT_ID();
insert into answer (answer_number, answer_text, answer_order, question_id) values (1, 'Engineering', 1, @question_id);
SET @answer_id = LAST_INSERT_ID();


insert into question (question_number, question_text, question_order, section_id, questionnaire_id, answer_type) values (1, '', 1, @section_id, @questionnaire_id, 'TEXTAREA');
SET @question_id = LAST_INSERT_ID();

insert into answer (answer_number, answer_text, answer_order, question_id) values (1, '', 1, @question_id);
SET @answer_id = LAST_INSERT_ID();


insert into question (question_number, question_text, question_order, section_id, questionnaire_id, answer_type) values (1, '', 1, @section_id, @questionnaire_id, 'TEXTAREA');
SET @question_id = LAST_INSERT_ID();

insert into answer (answer_number, answer_text, answer_order, question_id) values (1, '', 1, @question_id);
SET @answer_id = LAST_INSERT_ID();


insert into question (question_number, question_text, question_order, section_id, questionnaire_id, answer_type) values (1, '', 1, @section_id, @questionnaire_id, 'TEXTAREA');
SET @question_id = LAST_INSERT_ID();

insert into answer (answer_number, answer_text, answer_order, question_id) values (1, '', 1, @question_id);
SET @answer_id = LAST_INSERT_ID();


insert into question (question_number, question_text, question_order, section_id, questionnaire_id, answer_type) values (1, '', 1, @section_id, @questionnaire_id, 'TEXTAREA');
SET @question_id = LAST_INSERT_ID();

insert into answer (answer_number, answer_text, answer_order, question_id) values (1, '', 1, @question_id);
SET @answer_id = LAST_INSERT_ID();








insert into section (section_number, name, section_order, questionnaire_id) values (1, 'Professional Development: Career Planning, Personal Development and Education', 1, @questionnaire_id);
SET @section_id = LAST_INSERT_ID();

insert into question (question_number, question_text, question_order, section_id, questionnaire_id, answer_type) values (1, '', 1, @section_id, @questionnaire_id, 'TEXTAREA');
SET @question_id = LAST_INSERT_ID();


insert into section (section_number, name, section_order, questionnaire_id) values (1, 'Job Knowledge & Performance:  Knowledge and Training', 1, @questionnaire_id);
SET @section_id = LAST_INSERT_ID();

insert into section (section_number, name, section_order, questionnaire_id) values (1, 'Job Knowledge & Performance:  Performance Management & Awards', 1, @questionnaire_id);
SET @section_id = LAST_INSERT_ID();

insert into section (section_number, name, section_order, questionnaire_id) values (1, 'Personal Growth:  Health and Wellness', 1, @questionnaire_id);
SET @section_id = LAST_INSERT_ID();

insert into section (section_number, name, section_order, questionnaire_id) values (1, 'Personal Growth:  Ethical Behavior and Outside Interests', 1, @questionnaire_id);
SET @section_id = LAST_INSERT_ID();


SET FOREIGN_KEY_CHECKS = 1;
