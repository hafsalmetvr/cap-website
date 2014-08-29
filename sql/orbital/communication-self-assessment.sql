use cap;
SET FOREIGN_KEY_CHECKS = 0;

SELECT id INTO @organization_id FROM organization WHERE name = 'Orbital ATK';

-- answer enums
insert into answer_enum (name) values ('0');
SET @zero = LAST_INSERT_ID();
insert into answer_enum (name) values ('1');
SET @one = LAST_INSERT_ID();
insert into answer_enum (name) values ('2');
SET @two = LAST_INSERT_ID();
insert into answer_enum (name) values ('3');
SET @three = LAST_INSERT_ID();
insert into answer_enum (name) values ('4');
SET @four = LAST_INSERT_ID();
insert into answer_enum (name) values ('5');
SET @five = LAST_INSERT_ID();


insert into questionnaire (name, description, template_dir, type, organization_id, questions_per_page) values ('Communication & Interpersonal Skills Self-Assessment', '<p>Communication skills affect every interaction we have. From negotiating for a promotion to resolving a conflict, good communication skills can greatly improve life, while weak communication skills can make everyday interactions frustrating and potentially damaging.  Fortunately, interpersonal communication is a skill, and understanding your communication style can help you build upon your strengths and improve your weaknesses. This self-assessment measures several dimensions of interpersonal communication, including:</p><ul><li>Empathizing</li><li>Receiving</li><li>Transmitting your message</li><li>Clarifying</li><li>Feedback: Giving and Receiving</li><li>Reading Non Verbal Cues</li><li>Understanding</li></ul><p>Examine the following statements and indicate how often or to what degree you agree with them. While it can be difficult to admit to your communication weaknesses, answering honestly-- rather than giving the answer you hope is true--will give you the most accurate results. Accurate results can help you determine specific steps for improvement.</p><p>After finishing the self-assessment, you will receive a report of your strengths and the areas you may need to work on individually or in conjunction with your mentor.</p>', 'communication-self-assessment', 'QUESTIONNAIRE', @organization_id, 1);
SET @questionnaire_id = LAST_INSERT_ID();

-- insert questionnaire sections
insert into section (section_number, name, section_order, questionnaire_id) values (1, 'EMPATHAZING', 1, @questionnaire_id);
SET @section_id = LAST_INSERT_ID();

-- questions
insert into question (question_number, question_text, question_order, section_id, questionnaire_id, answer_type) values (1, null, 1, @section_id, @questionnaire_id, 'ENUM');
SET @question_id = LAST_INSERT_ID();

-- possible answers
insert into answer (answer_number, answer_text, answer_order, question_id) values (1, 'I smile warmly at people when they want to talk to me', 1, @question_id);
SET @answer_id = LAST_INSERT_ID();

insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @zero, 1);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @one, 2);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @two, 3);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @three, 4);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @four, 5);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @five, 6);

insert into answer (answer_number, answer_text, answer_order, question_id) values (2, 'I encourage people to speak their minds openly and to share their concerns', 2, @question_id);
SET @answer_id = LAST_INSERT_ID();

insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @zero, 1);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @one, 2);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @two, 3);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @three, 4);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @four, 5);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @five, 6);

insert into answer (answer_number, answer_text, answer_order, question_id) values (3, 'I think about why and not just what in terms of the things that people say', 3, @question_id);
SET @answer_id = LAST_INSERT_ID();

insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @zero, 1);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @one, 2);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @two, 3);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @three, 4);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @four, 5);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @five, 6);

insert into answer (answer_number, answer_text, answer_order, question_id) values (4, 'I show genuine interest when people are talking to me, whatever the subject or topic', 4, @question_id);
SET @answer_id = LAST_INSERT_ID();

insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @zero, 1);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @one, 2);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @two, 3);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @three, 4);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @four, 5);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @five, 6);

insert into answer (answer_number, answer_text, answer_order, question_id) values (5, 'I use a variety of careful questioning techniques to understand the other person', 5, @question_id);
SET @answer_id = LAST_INSERT_ID();

insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @zero, 1);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @one, 2);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @two, 3);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @three, 4);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @four, 5);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @five, 6);

insert into answer (answer_number, answer_text, answer_order, question_id) values (6, 'I mirror people\'s boy language when listening (facial cues, proximity, etc)', 6, @question_id);
SET @answer_id = LAST_INSERT_ID();

insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @zero, 1);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @one, 2);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @two, 3);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @three, 4);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @four, 5);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @five, 6);

insert into answer (answer_number, answer_text, answer_order, question_id) values (7, 'I like to find out something about the people I speak with', 7, @question_id);
SET @answer_id = LAST_INSERT_ID();

insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @zero, 1);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @one, 2);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @two, 3);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @three, 4);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @four, 5);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @five, 6);

insert into answer (answer_number, answer_text, answer_order, question_id) values (8, 'I pay attention at the feelings or emotions behind the words', 8, @question_id);
SET @answer_id = LAST_INSERT_ID();

insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @zero, 1);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @one, 2);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @two, 3);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @three, 4);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @four, 5);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @five, 6);

insert into answer (answer_number, answer_text, answer_order, question_id) values (9, 'I am sincere and genuine in my communications', 9, @question_id);
SET @answer_id = LAST_INSERT_ID();

insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @zero, 1);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @one, 2);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @two, 3);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @three, 4);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @four, 5);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @five, 6);

insert into answer (answer_number, answer_text, answer_order, question_id) values (10, 'I engage in as much \'small talk\' as necessary to help people feel comfortable', 10, @question_id);
SET @answer_id = LAST_INSERT_ID();

insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @zero, 1);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @one, 2);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @two, 3);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @three, 4);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @four, 5);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @five, 6);

insert into answer (answer_number, answer_text, answer_order, question_id) values (11, 'I let people finish what they are saying without interruption ', 11, @question_id);
SET @answer_id = LAST_INSERT_ID();

insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @zero, 1);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @one, 2);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @two, 3);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @three, 4);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @four, 5);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @five, 6);

insert into answer (answer_number, answer_text, answer_order, question_id) values (12, 'I maintain good eye contact and gives people my full attention', 12, @question_id);
SET @answer_id = LAST_INSERT_ID();

insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @zero, 1);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @one, 2);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @two, 3);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @three, 4);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @four, 5);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @five, 6);


insert into section (section_number, name, section_order, questionnaire_id) values (2, 'RECEIVING', 2, @questionnaire_id);
SET @section_id = LAST_INSERT_ID();

-- questions
insert into question (question_number, question_text, question_order, section_id, questionnaire_id, answer_type) values (1, null, 1, @section_id, @questionnaire_id, 'ENUM');
SET @question_id = LAST_INSERT_ID();

-- possible answers
insert into answer (answer_number, answer_text, answer_order, question_id) values (1, 'I look to find quiet environments in which to talk and listen to people properly', 1, @question_id);
SET @answer_id = LAST_INSERT_ID();

insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @zero, 1);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @one, 2);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @two, 3);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @three, 4);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @four, 5);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @five, 6);

insert into answer (answer_number, answer_text, answer_order, question_id) values (2, 'I ensure that my body language is positively conducive to attentive listening', 2, @question_id);
SET @answer_id = LAST_INSERT_ID();

insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @zero, 1);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @one, 2);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @two, 3);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @three, 4);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @four, 5);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @five, 6);

insert into answer (answer_number, answer_text, answer_order, question_id) values (3, 'I ensure that my body language is positively conducive to attentive listening', 3, @question_id);
SET @answer_id = LAST_INSERT_ID();

insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @zero, 1);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @one, 2);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @two, 3);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @three, 4);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @four, 5);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @five, 6);


insert into answer (answer_number, answer_text, answer_order, question_id) values (4, 'I make sure that they are in the right frame of mind for all important discussions', 4, @question_id);
SET @answer_id = LAST_INSERT_ID();

insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @zero, 1);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @one, 2);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @two, 3);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @three, 4);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @four, 5);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @five, 6);

insert into answer (answer_number, answer_text, answer_order, question_id) values (5, 'I avoid trivializing the ideas or views expressed by other people in talking with them', 5, @question_id);
SET @answer_id = LAST_INSERT_ID();

insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @zero, 1);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @one, 2);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @two, 3);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @three, 4);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @four, 5);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @five, 6);

insert into answer (answer_number, answer_text, answer_order, question_id) values (6, 'I look at people in the eye and regularly nods to demonstrate that they have understood', 6, @question_id);
SET @answer_id = LAST_INSERT_ID();

insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @zero, 1);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @one, 2);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @two, 3);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @three, 4);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @four, 5);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @five, 6);

insert into answer (answer_number, answer_text, answer_order, question_id) values (7, 'I fully focus my attention and concentrate on what is being said', 7, @question_id);
SET @answer_id = LAST_INSERT_ID();

insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @zero, 1);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @one, 2);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @two, 3);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @three, 4);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @four, 5);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @five, 6);

insert into answer (answer_number, answer_text, answer_order, question_id) values (8, 'I actively try not to let my mind wander when someone is talking to me', 8, @question_id);
SET @answer_id = LAST_INSERT_ID();

insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @zero, 1);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @one, 2);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @two, 3);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @three, 4);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @four, 5);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @five, 6);

insert into answer (answer_number, answer_text, answer_order, question_id) values (9, 'I avoid interrupting before the information sender has finished speaking', 9, @question_id);
SET @answer_id = LAST_INSERT_ID();

insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @zero, 1);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @one, 2);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @two, 3);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @three, 4);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @four, 5);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @five, 6);

insert into answer (answer_number, answer_text, answer_order, question_id) values (10, 'I take in information in on several different \'channels\' where necessary', 10, @question_id);
SET @answer_id = LAST_INSERT_ID();

insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @zero, 1);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @one, 2);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @two, 3);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @three, 4);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @four, 5);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @five, 6);

insert into answer (answer_number, answer_text, answer_order, question_id) values (11, 'I am a good listener', 11, @question_id);
SET @answer_id = LAST_INSERT_ID();

insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @zero, 1);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @one, 2);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @two, 3);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @three, 4);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @four, 5);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @five, 6);

insert into answer (answer_number, answer_text, answer_order, question_id) values (12, 'I have been told that I listen enthusiastically and positively', 12, @question_id);
SET @answer_id = LAST_INSERT_ID();

insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @zero, 1);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @one, 2);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @two, 3);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @three, 4);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @four, 5);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @five, 6);




insert into section (section_number, name, section_order, questionnaire_id) values (3, 'TRANSMITTING YOUR MESSAGE', 3, @questionnaire_id);
SET @section_id = LAST_INSERT_ID();

-- questions
insert into question (question_number, question_text, question_order, section_id, questionnaire_id, answer_type) values (1, null, 1, @section_id, @questionnaire_id, 'ENUM');
SET @question_id = LAST_INSERT_ID();

-- possible answers
insert into answer (answer_number, answer_text, answer_order, question_id) values (1, 'I am highly conscious of the needs of any \'audience\' to which I communicate', 1, @question_id);
SET @answer_id = LAST_INSERT_ID();

insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @zero, 1);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @one, 2);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @two, 3);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @three, 4);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @four, 5);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @five, 6);

insert into answer (answer_number, answer_text, answer_order, question_id) values (2, 'I tend to change and vary my communication style according to the situation', 2, @question_id);
SET @answer_id = LAST_INSERT_ID();

insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @zero, 1);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @one, 2);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @two, 3);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @three, 4);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @four, 5);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @five, 6);

insert into answer (answer_number, answer_text, answer_order, question_id) values (3, 'I ensure that my actions match my words', 3, @question_id);
SET @answer_id = LAST_INSERT_ID();

insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @zero, 1);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @one, 2);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @two, 3);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @three, 4);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @four, 5);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @five, 6);

insert into answer (answer_number, answer_text, answer_order, question_id) values (4, 'I am able to get complicated ideas across clearly', 4, @question_id);
SET @answer_id = LAST_INSERT_ID();


insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @zero, 1);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @one, 2);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @two, 3);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @three, 4);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @four, 5);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @five, 6);

insert into answer (answer_number, answer_text, answer_order, question_id) values (5, 'I deliver my communications at a pace and way that is comfortable for others', 5, @question_id);
SET @answer_id = LAST_INSERT_ID();

insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @zero, 1);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @one, 2);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @two, 3);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @three, 4);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @four, 5);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @five, 6);

insert into answer (answer_number, answer_text, answer_order, question_id) values (6, 'I communicate feelings as well as ideas and facts', 6, @question_id);
SET @answer_id = LAST_INSERT_ID();

insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @zero, 1);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @one, 2);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @two, 3);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @three, 4);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @four, 5);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @five, 6);

insert into answer (answer_number, answer_text, answer_order, question_id) values (7, 'I use multiple channels to get messages across to people', 7, @question_id);
SET @answer_id = LAST_INSERT_ID();

insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @zero, 1);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @one, 2);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @two, 3);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @three, 4);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @four, 5);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @five, 6);

insert into answer (answer_number, answer_text, answer_order, question_id) values (8, 'I find the \'right\' words for the circumstances', 8, @question_id);
SET @answer_id = LAST_INSERT_ID();

insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @zero, 1);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @one, 2);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @two, 3);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @three, 4);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @four, 5);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @five, 6);

insert into answer (answer_number, answer_text, answer_order, question_id) values (9, 'I select the most appropriate method to transmit my messages (face to face, memo, email, IM, etc)', 9, @question_id);
SET @answer_id = LAST_INSERT_ID();

insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @zero, 1);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @one, 2);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @two, 3);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @three, 4);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @four, 5);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @five, 6);

insert into answer (answer_number, answer_text, answer_order, question_id) values (10, 'I avoid over using jargon and confusing or inappropriate language', 10, @question_id);
SET @answer_id = LAST_INSERT_ID();

insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @zero, 1);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @one, 2);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @two, 3);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @three, 4);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @four, 5);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @five, 6);

insert into answer (answer_number, answer_text, answer_order, question_id) values (11, 'I say things in a variety of slightly different ways to reinforce what I\'m trying to convey ', 11, @question_id);
SET @answer_id = LAST_INSERT_ID();

insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @zero, 1);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @one, 2);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @two, 3);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @three, 4);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @four, 5);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @five, 6);

insert into answer (answer_number, answer_text, answer_order, question_id) values (12, 'I am able to lift team spirit and morale through effective communication', 12, @question_id);
SET @answer_id = LAST_INSERT_ID();

insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @zero, 1);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @one, 2);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @two, 3);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @three, 4);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @four, 5);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @five, 6);




insert into section (section_number, name, section_order, questionnaire_id) values (4, 'CLARIFYING', 4, @questionnaire_id);
SET @section_id = LAST_INSERT_ID();

-- questions
insert into question (question_number, question_text, question_order, section_id, questionnaire_id, answer_type) values (1, null, 1, @section_id, @questionnaire_id, 'ENUM');
SET @question_id = LAST_INSERT_ID();

-- possible answers
insert into answer (answer_number, answer_text, answer_order, question_id) values (1, 'I avoid making the other person feel as if they are being interrogated', 1, @question_id);
SET @answer_id = LAST_INSERT_ID();

insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @zero, 1);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @one, 2);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @two, 3);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @three, 4);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @four, 5);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @five, 6);

insert into answer (answer_number, answer_text, answer_order, question_id) values (2, 'I look for the underlying message behind people\'s words', 2, @question_id);
SET @answer_id = LAST_INSERT_ID();

insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @zero, 1);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @one, 2);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @two, 3);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @three, 4);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @four, 5);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @five, 6);

insert into answer (answer_number, answer_text, answer_order, question_id) values (3, 'I ask incisive questions in conversations', 3, @question_id);
SET @answer_id = LAST_INSERT_ID();

insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @zero, 1);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @one, 2);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @two, 3);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @three, 4);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @four, 5);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @five, 6);

insert into answer (answer_number, answer_text, answer_order, question_id) values (4, 'I check my understanding by paraphrasing to test my interpretation of what is said', 4, @question_id);
SET @answer_id = LAST_INSERT_ID();

insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @zero, 1);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @one, 2);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @two, 3);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @three, 4);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @four, 5);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @five, 6);

insert into answer (answer_number, answer_text, answer_order, question_id) values (5, 'I ask open ended questions to understand the context of the situation', 5, @question_id);
SET @answer_id = LAST_INSERT_ID();

insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @zero, 1);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @one, 2);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @two, 3);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @three, 4);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @four, 5);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @five, 6);

insert into answer (answer_number, answer_text, answer_order, question_id) values (6, 'I use probing questions to get people to expand their points as much as necessary', 6, @question_id);
SET @answer_id = LAST_INSERT_ID();

insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @zero, 1);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @one, 2);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @two, 3);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @three, 4);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @four, 5);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @five, 6);

insert into answer (answer_number, answer_text, answer_order, question_id) values (7, 'I openly demonstrate that I can be helpful and genuine in conversations', 7, @question_id);
SET @answer_id = LAST_INSERT_ID();

insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @zero, 1);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @one, 2);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @two, 3);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @three, 4);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @four, 5);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @five, 6);

insert into answer (answer_number, answer_text, answer_order, question_id) values (8, 'I paint \'word pictures\' to help describe the sender\'s message in a different way', 8, @question_id);
SET @answer_id = LAST_INSERT_ID();

insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @zero, 1);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @one, 2);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @two, 3);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @three, 4);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @four, 5);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @five, 6);

insert into answer (answer_number, answer_text, answer_order, question_id) values (9, 'I summarize what I think I have heard to ensure that I am clear', 9, @question_id);
SET @answer_id = LAST_INSERT_ID();

insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @zero, 1);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @one, 2);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @two, 3);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @three, 4);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @four, 5);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @five, 6);

insert into answer (answer_number, answer_text, answer_order, question_id) values (10, 'I am happy to \'speak up\' when I am confused or unsure', 10, @question_id);
SET @answer_id = LAST_INSERT_ID();

insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @zero, 1);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @one, 2);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @two, 3);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @three, 4);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @four, 5);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @five, 6);

insert into answer (answer_number, answer_text, answer_order, question_id) values (11, 'I calmly gather missing information as a conversation flows to build the story', 11, @question_id);
SET @answer_id = LAST_INSERT_ID();

insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @zero, 1);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @one, 2);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @two, 3);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @three, 4);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @four, 5);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @five, 6);

insert into answer (answer_number, answer_text, answer_order, question_id) values (12, 'I carefully probe points that I do not fully understand', 12, @question_id);
SET @answer_id = LAST_INSERT_ID();

insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @zero, 1);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @one, 2);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @two, 3);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @three, 4);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @four, 5);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @five, 6);



insert into section (section_number, name, section_order, questionnaire_id) values (5, 'FEEDBACK: GIVING AND RECEIVING', 5, @questionnaire_id);
SET @section_id = LAST_INSERT_ID();

-- questions
insert into question (question_number, question_text, question_order, section_id, questionnaire_id, answer_type) values (1, null, 1, @section_id, @questionnaire_id, 'ENUM');
SET @question_id = LAST_INSERT_ID();

-- possible answers
insert into answer (answer_number, answer_text, answer_order, question_id) values (1, 'I try to ensure that the \'airtime\' in a conversation is equally shared', 1, @question_id);
SET @answer_id = LAST_INSERT_ID();

insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @zero, 1);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @one, 2);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @two, 3);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @three, 4);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @four, 5);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @five, 6);

insert into answer (answer_number, answer_text, answer_order, question_id) values (2, 'I am appreciated for my direct and clear communication style', 2, @question_id);
SET @answer_id = LAST_INSERT_ID();

insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @zero, 1);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @one, 2);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @two, 3);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @three, 4);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @four, 5);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @five, 6);

insert into answer (answer_number, answer_text, answer_order, question_id) values (3, 'I openly demonstrate that I appreciate other people\'s feedback to me', 3, @question_id);
SET @answer_id = LAST_INSERT_ID();

insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @zero, 1);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @one, 2);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @two, 3);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @three, 4);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @four, 5);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @five, 6);

insert into answer (answer_number, answer_text, answer_order, question_id) values (4, 'I avoid engaging in emotional language or negative feedback responses', 4, @question_id);
SET @answer_id = LAST_INSERT_ID();

insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @zero, 1);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @one, 2);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @two, 3);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @three, 4);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @four, 5);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @five, 6);

insert into answer (answer_number, answer_text, answer_order, question_id) values (5, 'I see every constructive criticism as a positive opportunity to improve', 5, @question_id);
SET @answer_id = LAST_INSERT_ID();

insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @zero, 1);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @one, 2);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @two, 3);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @three, 4);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @four, 5);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @five, 6);

insert into answer (answer_number, answer_text, answer_order, question_id) values (6, 'I find it easy to get others\' attention when speaking with them', 6, @question_id);
SET @answer_id = LAST_INSERT_ID();

insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @zero, 1);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @one, 2);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @two, 3);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @three, 4);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @four, 5);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @five, 6);

insert into answer (answer_number, answer_text, answer_order, question_id) values (7, 'I am not concerned about the other party\'s motives when offering them feedback', 7, @question_id);
SET @answer_id = LAST_INSERT_ID();

insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @zero, 1);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @one, 2);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @two, 3);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @three, 4);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @four, 5);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @five, 6);

insert into answer (answer_number, answer_text, answer_order, question_id) values (8, 'I focus my effort on the key lessons to be given or taken from feedback', 8, @question_id);
SET @answer_id = LAST_INSERT_ID();

insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @zero, 1);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @one, 2);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @two, 3);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @three, 4);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @four, 5);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @five, 6);

insert into answer (answer_number, answer_text, answer_order, question_id) values (9, 'I avoid insults or demeaning the other party when offering critical comments', 9, @question_id);
SET @answer_id = LAST_INSERT_ID();

insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @zero, 1);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @one, 2);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @two, 3);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @three, 4);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @four, 5);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @five, 6);

insert into answer (answer_number, answer_text, answer_order, question_id) values (10, 'I focus on the facts in giving and receiving feedback', 10, @question_id);
SET @answer_id = LAST_INSERT_ID();

insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @zero, 1);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @one, 2);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @two, 3);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @three, 4);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @four, 5);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @five, 6);

insert into answer (answer_number, answer_text, answer_order, question_id) values (11, 'I actively demonstrate that feedback is the \'breakfast\' of effective communicators', 11, @question_id);
SET @answer_id = LAST_INSERT_ID();

insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @zero, 1);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @one, 2);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @two, 3);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @three, 4);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @four, 5);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @five, 6);

insert into answer (answer_number, answer_text, answer_order, question_id) values (12, 'I am sensitive to the needs of myself and others in every communication', 12, @question_id);
SET @answer_id = LAST_INSERT_ID();

insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @zero, 1);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @one, 2);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @two, 3);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @three, 4);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @four, 5);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @five, 6);



insert into section (section_number, name, section_order, questionnaire_id) values (6, 'READING NON VERBAL CLUES', 6, @questionnaire_id);
SET @section_id = LAST_INSERT_ID();

-- questions
insert into question (question_number, question_text, question_order, section_id, questionnaire_id, answer_type) values (1, null, 1, @section_id, @questionnaire_id, 'ENUM');
SET @question_id = LAST_INSERT_ID();

-- possible answers
insert into answer (answer_number, answer_text, answer_order, question_id) values (1, 'I am able to quickly sense when people\'s feelings may not match their words', 1, @question_id);
SET @answer_id = LAST_INSERT_ID();

insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @zero, 1);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @one, 2);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @two, 3);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @three, 4);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @four, 5);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @five, 6);

insert into answer (answer_number, answer_text, answer_order, question_id) values (2, 'I can sense when the climate for open communication is not quite right', 2, @question_id);
SET @answer_id = LAST_INSERT_ID();

insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @zero, 1);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @one, 2);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @two, 3);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @three, 4);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @four, 5);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @five, 6);

insert into answer (answer_number, answer_text, answer_order, question_id) values (3, 'I am good at \'reading\' other people ', 3, @question_id);
SET @answer_id = LAST_INSERT_ID();

insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @zero, 1);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @one, 2);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @two, 3);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @three, 4);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @four, 5);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @five, 6);

insert into answer (answer_number, answer_text, answer_order, question_id) values (4, 'I watch people\'s facial expressions and hand movements carefully', 4, @question_id);
SET @answer_id = LAST_INSERT_ID();

insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @zero, 1);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @one, 2);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @two, 3);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @three, 4);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @four, 5);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @five, 6);

insert into answer (answer_number, answer_text, answer_order, question_id) values (5, 'I am good at sensing negative atmosphere when they walk into a room', 5, @question_id);
SET @answer_id = LAST_INSERT_ID();

insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @zero, 1);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @one, 2);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @two, 3);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @three, 4);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @four, 5);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @five, 6);

insert into answer (answer_number, answer_text, answer_order, question_id) values (6, 'I can easily see inconsistencies between words and body language ', 6, @question_id);
SET @answer_id = LAST_INSERT_ID();

insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @zero, 1);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @one, 2);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @two, 3);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @three, 4);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @four, 5);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @five, 6);

insert into answer (answer_number, answer_text, answer_order, question_id) values (7, 'I recognize when the other party is distracted or has their mind elsewhere', 7, @question_id);
SET @answer_id = LAST_INSERT_ID();

insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @zero, 1);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @one, 2);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @two, 3);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @three, 4);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @four, 5);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @five, 6);

insert into answer (answer_number, answer_text, answer_order, question_id) values (8, 'I adjust my communication if I feel that they are losing the other person\'s attention', 8, @question_id);
SET @answer_id = LAST_INSERT_ID();

insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @zero, 1);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @one, 2);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @two, 3);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @three, 4);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @four, 5);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @five, 6);

insert into answer (answer_number, answer_text, answer_order, question_id) values (9, 'I understand other people\'s non-verbal clues and signals when they are offered', 9, @question_id);
SET @answer_id = LAST_INSERT_ID();

insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @zero, 1);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @one, 2);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @two, 3);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @three, 4);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @four, 5);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @five, 6);

insert into answer (answer_number, answer_text, answer_order, question_id) values (10, 'I can easily spot when someone is confused about what they are saying by their body language', 10, @question_id);
SET @answer_id = LAST_INSERT_ID();

insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @zero, 1);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @one, 2);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @two, 3);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @three, 4);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @four, 5);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @five, 6);

insert into answer (answer_number, answer_text, answer_order, question_id) values (11, 'I quickly notice changes in tone or intonation', 11, @question_id);
SET @answer_id = LAST_INSERT_ID();

insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @zero, 1);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @one, 2);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @two, 3);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @three, 4);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @four, 5);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @five, 6);

insert into answer (answer_number, answer_text, answer_order, question_id) values (12, 'I look to pick up individual\'s underlying feelings in a communication', 12, @question_id);
SET @answer_id = LAST_INSERT_ID();

insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @zero, 1);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @one, 2);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @two, 3);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @three, 4);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @four, 5);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @five, 6);


insert into section (section_number, name, section_order, questionnaire_id) values (7, 'UNDERSTANDING', 7, @questionnaire_id);
SET @section_id = LAST_INSERT_ID();

-- questions
insert into question (question_number, question_text, question_order, section_id, questionnaire_id, answer_type) values (1, null, 1, @section_id, @questionnaire_id, 'ENUM');
SET @question_id = LAST_INSERT_ID();

-- possible answers
insert into answer (answer_number, answer_text, answer_order, question_id) values (1, 'I work to avoid assuming that the other person\'s perspective is the same as mine', 1, @question_id);
SET @answer_id = LAST_INSERT_ID();

insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @zero, 1);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @one, 2);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @two, 3);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @three, 4);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @four, 5);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @five, 6);

insert into answer (answer_number, answer_text, answer_order, question_id) values (2, 'I am good at reading \'between the lines\' wherever necessary', 2, @question_id);
SET @answer_id = LAST_INSERT_ID();

insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @zero, 1);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @one, 2);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @two, 3);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @three, 4);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @four, 5);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @five, 6);

insert into answer (answer_number, answer_text, answer_order, question_id) values (3, 'I carefully follow the \'flow\' of the conversation to respond appropriately', 3, @question_id);
SET @answer_id = LAST_INSERT_ID();

insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @zero, 1);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @one, 2);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @two, 3);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @three, 4);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @four, 5);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @five, 6);

insert into answer (answer_number, answer_text, answer_order, question_id) values (4, 'I try to looks for conversation and discussion to build my general knowledge and understanding', 4, @question_id);
SET @answer_id = LAST_INSERT_ID();

insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @zero, 1);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @one, 2);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @two, 3);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @three, 4);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @four, 5);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @five, 6);

insert into answer (answer_number, answer_text, answer_order, question_id) values (5, 'I ask the other person to summarize their message when I am confused', 5, @question_id);
SET @answer_id = LAST_INSERT_ID();

insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @zero, 1);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @one, 2);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @two, 3);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @three, 4);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @four, 5);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @five, 6);

insert into answer (answer_number, answer_text, answer_order, question_id) values (6, 'I suspend judgment about what is being said for as long as necessary', 6, @question_id);
SET @answer_id = LAST_INSERT_ID();

insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @zero, 1);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @one, 2);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @two, 3);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @three, 4);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @four, 5);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @five, 6);

insert into answer (answer_number, answer_text, answer_order, question_id) values (7, 'I correctly identify the level of people\'s feelings and emotions in a conversation', 7, @question_id);
SET @answer_id = LAST_INSERT_ID();

insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @zero, 1);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @one, 2);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @two, 3);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @three, 4);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @four, 5);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @five, 6);

insert into answer (answer_number, answer_text, answer_order, question_id) values (8, 'I give people time, attention and encouragement to get their message across', 8, @question_id);
SET @answer_id = LAST_INSERT_ID();

insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @zero, 1);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @one, 2);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @two, 3);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @three, 4);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @four, 5);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @five, 6);

insert into answer (answer_number, answer_text, answer_order, question_id) values (9, 'I easily connect to what people say to me to achieve a better mental understanding', 9, @question_id);
SET @answer_id = LAST_INSERT_ID();

insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @zero, 1);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @one, 2);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @two, 3);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @three, 4);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @four, 5);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @five, 6);

insert into answer (answer_number, answer_text, answer_order, question_id) values (10, 'I work hard to respects other people\'s feelings when they offer their comments', 10, @question_id);
SET @answer_id = LAST_INSERT_ID();

insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @zero, 1);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @one, 2);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @two, 3);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @three, 4);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @four, 5);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @five, 6);

insert into answer (answer_number, answer_text, answer_order, question_id) values (11, 'I seek to put what I hear into a reasonable context based on my experience', 11, @question_id);
SET @answer_id = LAST_INSERT_ID();

insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @zero, 1);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @one, 2);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @two, 3);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @three, 4);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @four, 5);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @five, 6);

insert into answer (answer_number, answer_text, answer_order, question_id) values (12, 'I piece together all the different parts of what people say and do to make sense of it', 12, @question_id);
SET @answer_id = LAST_INSERT_ID();

insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @zero, 1);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @one, 2);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @two, 3);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @three, 4);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @four, 5);
insert into answer_enum_map (answer_id, answer_enum_id, answer_enum_order) values (@answer_id, @five, 6);


SET FOREIGN_KEY_CHECKS = 1;
