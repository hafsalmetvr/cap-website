use cap;
SET FOREIGN_KEY_CHECKS = 0;

SELECT id INTO @organization_id FROM organization WHERE name = 'Orbital ATK';

insert into questionnaire (name, description, template_dir, type, organization_id, questions_per_page) values ('Mentor Profile', '<p>The purpose of this activity is to help Orbital identify what each mentor candidate could bring to the Centurion Programs mentoring relationship and what traits he/she has that could benefit a mentee.</p>', 'mentor-profile', 'FORM', @organization_id, 7);
SET @questionnaire_id = LAST_INSERT_ID();

-- section
insert into section (section_number, name, section_order, questionnaire_id) values (1, 'Professional Background', 1, @questionnaire_id);
SET @section_id = LAST_INSERT_ID();

insert into question (question_number, question_text, question_order, section_id, questionnaire_id, answer_type) values (1, 'I am very knowledgeable about:', 1, @section_id, @questionnaire_id, 'TEXTAREA');
SET @question_id = LAST_INSERT_ID();

insert into answer (answer_number, answer_text, answer_order, question_id) values (1, '', 1, @question_id);
SET @answer_id = LAST_INSERT_ID();

insert into question (question_number, question_text, question_order, section_id, questionnaire_id, answer_type) values (2, 'My skills include:', 2, @section_id, @questionnaire_id, 'TEXTAREA');
SET @question_id = LAST_INSERT_ID();

insert into answer (answer_number, answer_text, answer_order, question_id) values (1, '', 1, @question_id);
SET @answer_id = LAST_INSERT_ID();

insert into question (question_number, question_text, question_order, section_id, questionnaire_id, answer_type) values (3, 'I would describe myself (my attributes) as:', 3, @section_id, @questionnaire_id, 'TEXTAREA');
SET @question_id = LAST_INSERT_ID();

insert into answer (answer_number, answer_text, answer_order, question_id) values (1, '', 1, @question_id);
SET @answer_id = LAST_INSERT_ID();

insert into question (question_number, question_text, question_order, section_id, questionnaire_id, answer_type) values (4, 'My previous professional experience includes:', 4, @section_id, @questionnaire_id, 'TEXTAREA');
SET @question_id = LAST_INSERT_ID();

insert into answer (answer_number, answer_text, answer_order, question_id) values (1, '', 1, @question_id);
SET @answer_id = LAST_INSERT_ID();


insert into question (question_number, question_text, question_order, section_id, questionnaire_id, answer_type) values (5, 'My current professional responsibilities are:', 5, @section_id, @questionnaire_id, 'TEXTAREA');
SET @question_id = LAST_INSERT_ID();

insert into answer (answer_number, answer_text, answer_order, question_id) values (1, '', 1, @question_id);
SET @answer_id = LAST_INSERT_ID();

insert into question (question_number, question_text, question_order, section_id, questionnaire_id, answer_type) values (6, 'My notable accomplishments & awards:', 6, @section_id, @questionnaire_id, 'TEXTAREA');
SET @question_id = LAST_INSERT_ID();

insert into answer (answer_number, answer_text, answer_order, question_id) values (1, '', 1, @question_id);
SET @answer_id = LAST_INSERT_ID();

insert into question (question_number, question_text, question_order, section_id, questionnaire_id, answer_type) values (7, 'Professional associations I am involved in and how I contribute:', 7, @section_id, @questionnaire_id, 'TEXTAREA');
SET @question_id = LAST_INSERT_ID();

insert into answer (answer_number, answer_text, answer_order, question_id) values (1, '', 1, @question_id);
SET @answer_id = LAST_INSERT_ID();



-- section
insert into section (section_number, name, section_order, questionnaire_id) values (2, 'Interests', 2, @questionnaire_id);
SET @section_id = LAST_INSERT_ID();

insert into question (question_number, question_text, question_order, section_id, questionnaire_id, answer_type) values (1, 'I am most passionate about:', 1, @section_id, @questionnaire_id, 'TEXTAREA');
SET @question_id = LAST_INSERT_ID();

insert into answer (answer_number, answer_text, answer_order, question_id) values (1, '', 1, @question_id);
SET @answer_id = LAST_INSERT_ID();

insert into question (question_number, question_text, question_order, section_id, questionnaire_id, answer_type) values (2, 'The ways in which I\'d like to help and think I\'d be good at helping another professional are:', 2, @section_id, @questionnaire_id, 'TEXTAREA');
SET @question_id = LAST_INSERT_ID();

insert into answer (answer_number, answer_text, answer_order, question_id) values (1, '', 1, @question_id);
SET @answer_id = LAST_INSERT_ID();

insert into question (question_number, question_text, question_order, section_id, questionnaire_id, answer_type) values (3, 'I am not really interested in or don\'t think I would be good at doing the following as a mentor:', 3, @section_id, @questionnaire_id, 'TEXTAREA');
SET @question_id = LAST_INSERT_ID();

insert into answer (answer_number, answer_text, answer_order, question_id) values (1, '', 1, @question_id);
SET @answer_id = LAST_INSERT_ID();

insert into question (question_number, question_text, question_order, section_id, questionnaire_id, answer_type) values (4, 'On a personal level, my interests and passions include (things I enjoy doing outside of work):', 4, @section_id, @questionnaire_id, 'TEXTAREA');
SET @question_id = LAST_INSERT_ID();

insert into answer (answer_number, answer_text, answer_order, question_id) values (1, '', 1, @question_id);
SET @answer_id = LAST_INSERT_ID();

insert into question (question_number, question_text, question_order, section_id, questionnaire_id, answer_type) values (5, 'I place the highest value on:', 5, @section_id, @questionnaire_id, 'TEXTAREA');
SET @question_id = LAST_INSERT_ID();

insert into answer (answer_number, answer_text, answer_order, question_id) values (1, '', 1, @question_id);
SET @answer_id = LAST_INSERT_ID();


-- section
insert into section (section_number, name, section_order, questionnaire_id) values (3, 'Availability', 3, @questionnaire_id);
SET @section_id = LAST_INSERT_ID();

insert into question (question_number, question_text, question_order, section_id, questionnaire_id, answer_type) values (1, 'I am available for the following number of hours per month for mentoring: Note: the Orbital mentor baseline is 10 hours per month) ', 1, @section_id, @questionnaire_id, 'TEXT');
SET @question_id = LAST_INSERT_ID();

insert into answer (answer_number, answer_text, answer_order, question_id) values (1, '', 1, @question_id);
SET @answer_id = LAST_INSERT_ID();

insert into question (question_number, question_text, question_order, section_id, questionnaire_id, answer_type) values (2, 'I am willing to engage with mentees outside of regularly scheduled business hours.', 2, @section_id, @questionnaire_id, 'RADIO');
SET @question_id = LAST_INSERT_ID();

insert into answer (answer_number, answer_text, answer_order, question_id) values (1, 'Yes', 1, @question_id);
SET @answer_id = LAST_INSERT_ID();
insert into answer (answer_number, answer_text, answer_order, question_id) values (2, 'No', 2, @question_id);
SET @answer_id = LAST_INSERT_ID();


SET FOREIGN_KEY_CHECKS = 1;
