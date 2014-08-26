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

delete from domain;
alter table domain auto_increment = 1;
delete from organization;
alter table organization auto_increment = 1;

-- organization stuff
insert into organization (name) values ('Orbital ATK');
SET @organization_id = LAST_INSERT_ID();

-- domain
insert into domain (name, organization_id) values ('go-optimum.com', @organization_id);
SET @domain_id = LAST_INSERT_ID();

-- roles
INSERT INTO `role` (name,level,domain_id) VALUES ('Admin',1,@domain_id),('Mentor',2,@domain_id),('Mentee',3,@domain_id);

-- answer enums
insert into answer_enum (name) values ('Almost Never');
SET @almost_never = LAST_INSERT_ID();
insert into answer_enum (name) values ('Rarely');
SET @rarely = LAST_INSERT_ID();
insert into answer_enum (name) values ('Sometimes');
SET @sometimes = LAST_INSERT_ID();
insert into answer_enum (name) values ('Often');
SET @often = LAST_INSERT_ID();
insert into answer_enum (name) values ('Most of the time');
SET @most = LAST_INSERT_ID();

-- insert the orbital questionnaires
insert into questionnaire (name, description, organization_id, questions_per_page) values ('Goal Setting Self-Assessment', '<p>Are you right on target with your goals? Goal-setting is an important component of success, whether you are aspiring to reach objectives in your career or your personal life. Aspire too high and you may become frustrated and give up; aspire too low and you will never push yourself to reach your full potential. Take this self-assessment to find out whether your goal-setting attitude and behaviors are conducive to success.</p><p>Examine the statements on the following pages and indicate how often or to what degree you agree with them. In order to receive the most accurate results, please answer each question as honestly as possible.</p><p>After finishing your self-assessment, you will receive a report of your strengths and the areas you may need to work on individually or with the help of your mentor.</p>', @organization_id, 1);
SET @questionnaire_id = LAST_INSERT_ID();

-- insert questionnaire sections
insert into section (section_number, name, section_order, questionnaire_id) values (1, 'VISIONING & PLANNING', 1, @questionnaire_id);
SET @section_id = LAST_INSERT_ID();

-- questions
insert into question (question_number, question_text, question_order, section_id, questionnaire_id, answer_type) values (1, null, 1, @section_id, @questionnaire_id, 'ENUM');
SET @question_id = LAST_INSERT_ID();

-- possible answers
insert into answer (answer_number, answer_text, answer_order, question_id) values (1, 'I don\'t make plans for the future; I prefer to go with the flow.', 1, @question_id);
SET @answer_id = LAST_INSERT_ID();

insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @almost_never, 1);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @rarely, 2);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @sometimes, 3);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @often, 4);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @most, 5);

insert into answer (answer_number, answer_text, answer_order, question_id) values (2, 'When working towards a goal, I regularly evaluate my progress.', 2, @question_id);
SET @answer_id = LAST_INSERT_ID();

insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @almost_never, 1);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @rarely, 2);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @sometimes, 3);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @often, 4);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @most, 5);

insert into answer (answer_number, answer_text, answer_order, question_id) values (3, 'Before I set out to accomplish a goal, I think about what could get in my way and how I can overcome these obstacles.', 3, @question_id);
SET @answer_id = LAST_INSERT_ID();

insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @almost_never, 1);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @rarely, 2);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @sometimes, 3);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @often, 4);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @most, 5);

insert into answer (answer_number, answer_text, answer_order, question_id) values (4, 'When necessary, I change and adjust my goals as I progress (e.g. if a deadline to achieve a certain goal isn\'t feasible, I alter it).', 4, @question_id);
SET @answer_id = LAST_INSERT_ID();

insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @almost_never, 1);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @rarely, 2);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @sometimes, 3);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @often, 4);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @most, 5);

insert into answer (answer_number, answer_text, answer_order, question_id) values (5, 'I make a detailed list of all the goals I want to achieve and by when.', 5, @question_id);
SET @answer_id = LAST_INSERT_ID();

insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @almost_never, 1);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @rarely, 2);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @sometimes, 3);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @often, 4);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @most, 5);

insert into answer (answer_number, answer_text, answer_order, question_id) values (6, 'After I decide on an objective, I immediately take the first step towards achieving it.', 6, @question_id);
SET @answer_id = LAST_INSERT_ID();

insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @almost_never, 1);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @rarely, 2);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @sometimes, 3);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @often, 4);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @most, 5);

insert into answer (answer_number, answer_text, answer_order, question_id) values (7, 'I set both short and long-term goals.', 7, @question_id);
SET @answer_id = LAST_INSERT_ID();

insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @almost_never, 1);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @rarely, 2);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @sometimes, 3);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @often, 4);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @most, 5);

insert into answer (answer_number, answer_text, answer_order, question_id) values (8, 'I break down larger, more complex goals into smaller steps.', 8, @question_id);
SET @answer_id = LAST_INSERT_ID();

insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @almost_never, 1);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @rarely, 2);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @sometimes, 3);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @often, 4);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @most, 5);

insert into answer (answer_number, answer_text, answer_order, question_id) values (9, 'When I decide to pursue a goal, I can accurately visualize how I will achieve it.', 9, @question_id);
SET @answer_id = LAST_INSERT_ID();

insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @almost_never, 1);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @rarely, 2);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @sometimes, 3);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @often, 4);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @most, 5);

insert into answer (answer_number, answer_text, answer_order, question_id) values (10, 'I set deadlines for achieving my goals.', 10, @question_id);
SET @answer_id = LAST_INSERT_ID();

insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @almost_never, 1);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @rarely, 2);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @sometimes, 3);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @often, 4);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @most, 5);

insert into answer (answer_number, answer_text, answer_order, question_id) values (11, 'I imagine the benefits of achieving something before I start working towards it.', 11, @question_id);
SET @answer_id = LAST_INSERT_ID();

insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @almost_never, 1);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @rarely, 2);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @sometimes, 3);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @often, 4);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @most, 5);


insert into section (section_number, name, section_order, questionnaire_id) values (2, 'MOTIVATION & DETERMINATION', 2, @questionnaire_id);
SET @section_id = LAST_INSERT_ID();

-- questions
insert into question (question_number, question_text, question_order, section_id, questionnaire_id, answer_type) values (1, null, 1, @section_id, @questionnaire_id, 'ENUM');
SET @question_id = LAST_INSERT_ID();

-- possible answers
insert into answer (answer_number, answer_text, answer_order, question_id) values (1, 'I can\'t seem to achieve what I set out to accomplish.', 1, @question_id);
SET @answer_id = LAST_INSERT_ID();

insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @almost_never, 1);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @rarely, 2);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @sometimes, 3);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @often, 4);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @most, 5);

insert into answer (answer_number, answer_text, answer_order, question_id) values (2, 'I know how to motivate myself to keep trying when I\'m having difficulty reaching a goal.', 2, @question_id);
SET @answer_id = LAST_INSERT_ID();

insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @almost_never, 1);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @rarely, 2);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @sometimes, 3);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @often, 4);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @most, 5);

insert into answer (answer_number, answer_text, answer_order, question_id) values (3, 'I believe that it\'s up to me to decide how to accomplish my goals.', 3, @question_id);
SET @answer_id = LAST_INSERT_ID();

insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @almost_never, 1);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @rarely, 2);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @sometimes, 3);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @often, 4);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @most, 5);

insert into answer (answer_number, answer_text, answer_order, question_id) values (4, 'When my pursuit of a goal isn\'t progressing as I expected, I give up on it.', 4, @question_id);
SET @answer_id = LAST_INSERT_ID();

insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @almost_never, 1);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @rarely, 2);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @sometimes, 3);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @often, 4);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @most, 5);

insert into answer (answer_number, answer_text, answer_order, question_id) values (5, 'If a goal is very difficult to achieve or there\'s a good chance I\'ll fail, I won\'t even waste my time trying for it.', 5, @question_id);
SET @answer_id = LAST_INSERT_ID();

insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @almost_never, 1);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @rarely, 2);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @sometimes, 3);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @often, 4);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @most, 5);

insert into answer (answer_number, answer_text, answer_order, question_id) values (6, 'I am willing to seek other people\'s help or advice when I\'m having difficulty achieving a certain goal.', 6, @question_id);
SET @answer_id = LAST_INSERT_ID();

insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @almost_never, 1);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @rarely, 2);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @sometimes, 3);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @often, 4);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @most, 5);

insert into answer (answer_number, answer_text, answer_order, question_id) values (7, 'I set goals that are challenging.', 7, @question_id);
SET @answer_id = LAST_INSERT_ID();

insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @almost_never, 1);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @rarely, 2);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @sometimes, 3);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @often, 4);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @most, 5);

insert into answer (answer_number, answer_text, answer_order, question_id) values (8, 'I find myself changing my mind about what goal(s) I want to accomplish.', 8, @question_id);
SET @answer_id = LAST_INSERT_ID();

insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @almost_never, 1);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @rarely, 2);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @sometimes, 3);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @often, 4);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @most, 5);

insert into answer (answer_number, answer_text, answer_order, question_id) values (9, 'I manage to overcome the obstacles that get in the way of my goals.', 9, @question_id);
SET @answer_id = LAST_INSERT_ID();

insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @almost_never, 1);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @rarely, 2);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @sometimes, 3);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @often, 4);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @most, 5);

insert into answer (answer_number, answer_text, answer_order, question_id) values (10, 'I reward myself when I successfully reach a goal.', 10, @question_id);
SET @answer_id = LAST_INSERT_ID();

insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @almost_never, 1);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @rarely, 2);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @sometimes, 3);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @often, 4);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @most, 5);



insert into section (section_number, name, section_order, questionnaire_id) values (3, 'CONFIDENCE & RESILIENCY', 3, @questionnaire_id);
SET @section_id = LAST_INSERT_ID();

-- questions
insert into question (question_number, question_text, question_order, section_id, questionnaire_id, answer_type) values (1, null, 1, @section_id, @questionnaire_id, 'ENUM');
SET @question_id = LAST_INSERT_ID();

-- possible answers
insert into answer (answer_number, answer_text, answer_order, question_id) values (1, 'My aspirations seem so difficult to reach that I tend to give up on them.', 1, @question_id);
SET @answer_id = LAST_INSERT_ID();

insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @almost_never, 1);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @rarely, 2);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @sometimes, 3);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @often, 4);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @most, 5);

insert into answer (answer_number, answer_text, answer_order, question_id) values (2, 'Even if I do make a detailed plan on how to achieve my goals, I don\'t believe I have much control as to whether it will work out or not.', 2, @question_id);
SET @answer_id = LAST_INSERT_ID();

insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @almost_never, 1);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @rarely, 2);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @sometimes, 3);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @often, 4);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @most, 5);

insert into answer (answer_number, answer_text, answer_order, question_id) values (3, 'I prefer to set low expectations for myself so that I won\'t be disappointed if I fail.', 3, @question_id);
SET @answer_id = LAST_INSERT_ID();

insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @almost_never, 1);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @rarely, 2);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @sometimes, 3);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @often, 4);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @most, 5);

insert into answer (answer_number, answer_text, answer_order, question_id) values (4, 'I believe I have what it takes to accomplish whatever I pursue.', 4, @question_id);
SET @answer_id = LAST_INSERT_ID();

insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @almost_never, 1);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @rarely, 2);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @sometimes, 3);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @often, 4);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @most, 5);

insert into answer (answer_number, answer_text, answer_order, question_id) values (5, 'I believe that my destiny lies in my hands.', 5, @question_id);
SET @answer_id = LAST_INSERT_ID();

insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @almost_never, 1);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @rarely, 2);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @sometimes, 3);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @often, 4);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @most, 5);

insert into answer (answer_number, answer_text, answer_order, question_id) values (6, 'If I successfully achieve a goal I assume that it\'s only because it was an easy one.', 6, @question_id);
SET @answer_id = LAST_INSERT_ID();

insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @almost_never, 1);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @rarely, 2);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @sometimes, 3);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @often, 4);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @most, 5);

insert into answer (answer_number, answer_text, answer_order, question_id) values (7, 'No matter how hard I strive to reach a goal, in the end, my success is left to chance.', 7, @question_id);
SET @answer_id = LAST_INSERT_ID();

insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @almost_never, 1);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @rarely, 2);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @sometimes, 3);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @often, 4);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @most, 5);

insert into answer (answer_number, answer_text, answer_order, question_id) values (8, 'Most of the factors that will determine my success are beyond my control.', 8, @question_id);
SET @answer_id = LAST_INSERT_ID();

insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @almost_never, 1);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @rarely, 2);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @sometimes, 3);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @often, 4);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @most, 5);

insert into answer (answer_number, answer_text, answer_order, question_id) values (9, 'There\'s no point in setting goals for myself because I don\'t have the skills necessary to achieve them anyway.', 9, @question_id);
SET @answer_id = LAST_INSERT_ID();

insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @almost_never, 1);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @rarely, 2);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @sometimes, 3);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @often, 4);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @most, 5);

insert into answer (answer_number, answer_text, answer_order, question_id) values (10, 'I state my objectives in a positive way (e.g. "I will improve my performance on projects" rather than "I will stop making stupid mistakes on projects").', 10, @question_id);
SET @answer_id = LAST_INSERT_ID();

insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @almost_never, 1);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @rarely, 2);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @sometimes, 3);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @often, 4);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @most, 5);


SET FOREIGN_KEY_CHECKS = 1;
