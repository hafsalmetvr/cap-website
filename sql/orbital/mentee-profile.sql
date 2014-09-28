use cap;
SET FOREIGN_KEY_CHECKS = 0;

SELECT id INTO @organization_id FROM organization WHERE name = 'Orbital ATK';

-- insert the pre assessment
insert into questionnaire (name, description, template_dir, type, organization_id, questions_per_page) values ('Mentee Profile', '<p>Review the questions provided in the following sections and answer accordingly.  This discussion document will be used as a point of dialogue with you mentor.  All answers are open text and you are expected to provide thoughtful and thorough responses.</p><p>If at any point you are unable to answer a question, you may skip it and return to answer at a later point however, you will be expected to have a completed document at hand for your first mentor meeting.</p>', 'mentee-profile', 'FORM', @organization_id, 4);
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


insert into question (question_number, question_text, question_order, section_id, questionnaire_id, answer_type) values (2, 'Do you understand Orbital\'s mission, strategic goals, and strategic objectives? Explain them as you understand them:', 2, @section_id, @questionnaire_id, 'TEXTAREA');
SET @question_id = LAST_INSERT_ID();

insert into answer (answer_number, answer_text, answer_order, question_id) values (1, '', 1, @question_id);
SET @answer_id = LAST_INSERT_ID();

insert into question (question_number, question_text, question_order, section_id, questionnaire_id, answer_type) values (3, 'Indicate your level of understanding of the roles and functions carried out by the various organizational elements that support Orbital, such as: Business Groups and Corporate Departments, Programs, Business Development, Engineering.', 3, @section_id, @questionnaire_id, 'TEXTAREA');
SET @question_id = LAST_INSERT_ID();

insert into answer (answer_number, answer_text, answer_order, question_id) values (1, '', 1, @question_id);
SET @answer_id = LAST_INSERT_ID();

insert into question (question_number, question_text, question_order, section_id, questionnaire_id, answer_type) values (4, 'Do you understand how your Program or Department and job fit into the  Orbital "big picture"?  Explain.', 4, @section_id, @questionnaire_id, 'TEXTAREA');
SET @question_id = LAST_INSERT_ID();

insert into answer (answer_number, answer_text, answer_order, question_id) values (1, '', 1, @question_id);
SET @answer_id = LAST_INSERT_ID();


insert into question (question_number, question_text, question_order, section_id, questionnaire_id, answer_type) values (5, 'What is the concept of "cross-functional" jobs and what does means for you as you plan your career development?', 5, @section_id, @questionnaire_id, 'TEXTAREA');
SET @question_id = LAST_INSERT_ID();

insert into answer (answer_number, answer_text, answer_order, question_id) values (1, '', 1, @question_id);
SET @answer_id = LAST_INSERT_ID();


insert into question (question_number, question_text, question_order, section_id, questionnaire_id, answer_type) values (6, 'How does the role of a matrix organization affect your job?', 6, @section_id, @questionnaire_id, 'TEXTAREA');
SET @question_id = LAST_INSERT_ID();

insert into answer (answer_number, answer_text, answer_order, question_id) values (1, '', 1, @question_id);
SET @answer_id = LAST_INSERT_ID();





insert into section (section_number, name, section_order, questionnaire_id) values (2, 'Professional Development: Career Planning, Personal Development and Education', 2, @questionnaire_id);
SET @section_id = LAST_INSERT_ID();

insert into question (question_number, question_text, question_order, section_id, questionnaire_id, answer_type) values (1, 'Have you thought about your career plans and established career goals and objectives?', 1, @section_id, @questionnaire_id, 'TEXTAREA');
SET @question_id = LAST_INSERT_ID();

-- possible answers
insert into answer (answer_number, answer_text, answer_order, question_id) values (1, '', 1, @question_id);
SET @answer_id = LAST_INSERT_ID();


insert into question (question_number, question_text, question_order, section_id, questionnaire_id, answer_type) values (2, 'Have you considered what other positions or jobs you would like to progress to within the Orbital organization?', 2, @section_id, @questionnaire_id, 'TEXTAREA');
SET @question_id = LAST_INSERT_ID();

insert into answer (answer_number, answer_text, answer_order, question_id) values (1, '', 1, @question_id);
SET @answer_id = LAST_INSERT_ID();

insert into question (question_number, question_text, question_order, section_id, questionnaire_id, answer_type) values (3, 'Are you interested in acquiring new job skills in more than one area, and if so, which areas appeal to you? ', 3, @section_id, @questionnaire_id, 'TEXTAREA');
SET @question_id = LAST_INSERT_ID();

insert into answer (answer_number, answer_text, answer_order, question_id) values (1, '', 1, @question_id);
SET @answer_id = LAST_INSERT_ID();

insert into question (question_number, question_text, question_order, section_id, questionnaire_id, answer_type) values (4, 'Have you worked in more than one function or group/department within Orbital? Explain:', 4, @section_id, @questionnaire_id, 'TEXTAREA');
SET @question_id = LAST_INSERT_ID();

insert into answer (answer_number, answer_text, answer_order, question_id) values (1, '', 1, @question_id);
SET @answer_id = LAST_INSERT_ID();


insert into question (question_number, question_text, question_order, section_id, questionnaire_id, answer_type) values (5, 'Are you geographically and organizationally mobile?', 5, @section_id, @questionnaire_id, 'TEXTAREA');
SET @question_id = LAST_INSERT_ID();

insert into answer (answer_number, answer_text, answer_order, question_id) values (1, '', 1, @question_id);
SET @answer_id = LAST_INSERT_ID();


insert into question (question_number, question_text, question_order, section_id, questionnaire_id, answer_type) values (6, 'Are you interested in performing more than one job function in Orbital, and if so, which additional functions appeal to you?', 6, @section_id, @questionnaire_id, 'TEXTAREA');
SET @question_id = LAST_INSERT_ID();

insert into answer (answer_number, answer_text, answer_order, question_id) values (1, '', 1, @question_id);
SET @answer_id = LAST_INSERT_ID();


insert into question (question_number, question_text, question_order, section_id, questionnaire_id, answer_type) values (7, 'Are you interested in performing work assignments involving greater use of technology and new processes?', 7, @section_id, @questionnaire_id, 'TEXTAREA');
SET @question_id = LAST_INSERT_ID();

insert into answer (answer_number, answer_text, answer_order, question_id) values (1, '', 1, @question_id);
SET @answer_id = LAST_INSERT_ID();


insert into question (question_number, question_text, question_order, section_id, questionnaire_id, answer_type) values (8, 'Are you proficient in the use of the software applications currently available for use in Orbital?', 8, @section_id, @questionnaire_id, 'TEXTAREA');
SET @question_id = LAST_INSERT_ID();

insert into answer (answer_number, answer_text, answer_order, question_id) values (1, '', 1, @question_id);
SET @answer_id = LAST_INSERT_ID();

insert into question (question_number, question_text, question_order, section_id, questionnaire_id, answer_type) values (9, 'Have you talked with your supervisor or with other advisors about career guidance and direction?', 9, @section_id, @questionnaire_id, 'TEXTAREA');
SET @question_id = LAST_INSERT_ID();

insert into answer (answer_number, answer_text, answer_order, question_id) values (1, '', 1, @question_id);
SET @answer_id = LAST_INSERT_ID();

insert into question (question_number, question_text, question_order, section_id, questionnaire_id, answer_type) values (10, 'Have you asked your supervisor for cross training or other developmental experiences?', 10, @section_id, @questionnaire_id, 'TEXTAREA');
SET @question_id = LAST_INSERT_ID();

insert into answer (answer_number, answer_text, answer_order, question_id) values (1, '', 1, @question_id);
SET @answer_id = LAST_INSERT_ID();

insert into question (question_number, question_text, question_order, section_id, questionnaire_id, answer_type) values (11, 'Have you taken the initiative to further your own growth and development by taking college courses or correspondence courses?', 11, @section_id, @questionnaire_id, 'TEXTAREA');
SET @question_id = LAST_INSERT_ID();

insert into answer (answer_number, answer_text, answer_order, question_id) values (1, '', 1, @question_id);
SET @answer_id = LAST_INSERT_ID();

insert into question (question_number, question_text, question_order, section_id, questionnaire_id, answer_type) values (12, 'Have you made a habit of reading for development such items as management books, industry publications, or trade journals?', 12, @section_id, @questionnaire_id, 'TEXTAREA');
SET @question_id = LAST_INSERT_ID();

insert into answer (answer_number, answer_text, answer_order, question_id) values (1, '', 1, @question_id);
SET @answer_id = LAST_INSERT_ID();

insert into question (question_number, question_text, question_order, section_id, questionnaire_id, answer_type) values (13, 'If you are taking additional college courses, do you know the requirements for degree completion?', 13, @section_id, @questionnaire_id, 'TEXTAREA');
SET @question_id = LAST_INSERT_ID();

insert into answer (answer_number, answer_text, answer_order, question_id) values (1, '', 1, @question_id);
SET @answer_id = LAST_INSERT_ID();

insert into question (question_number, question_text, question_order, section_id, questionnaire_id, answer_type) values (14, 'Do you have specific skills you would like to develop?', 14, @section_id, @questionnaire_id, 'TEXTAREA');
SET @question_id = LAST_INSERT_ID();

insert into answer (answer_number, answer_text, answer_order, question_id) values (1, '', 1, @question_id);
SET @answer_id = LAST_INSERT_ID();

insert into question (question_number, question_text, question_order, section_id, questionnaire_id, answer_type) values (15, 'Are you certified to the appropriate level in your career field?', 15, @section_id, @questionnaire_id, 'TEXTAREA');
SET @question_id = LAST_INSERT_ID();

insert into answer (answer_number, answer_text, answer_order, question_id) values (1, '', 1, @question_id);
SET @answer_id = LAST_INSERT_ID();

insert into question (question_number, question_text, question_order, section_id, questionnaire_id, answer_type) values (16, 'Do you have the skills you need to advance to the positions you would prefer in Orbital?', 16, @section_id, @questionnaire_id, 'TEXTAREA');
SET @question_id = LAST_INSERT_ID();

insert into answer (answer_number, answer_text, answer_order, question_id) values (1, '', 1, @question_id);
SET @answer_id = LAST_INSERT_ID();






insert into section (section_number, name, section_order, questionnaire_id) values (3, 'Job Knowledge & Performance:  Knowledge and Training', 3, @questionnaire_id);
SET @section_id = LAST_INSERT_ID();

-- questions
insert into question (question_number, question_text, question_order, section_id, questionnaire_id, answer_type) values (1, 'Do you know whom to ask for specific information or assistance in performing your job?', 1, @section_id, @questionnaire_id, 'TEXTAREA');
SET @question_id = LAST_INSERT_ID();

-- possible answers
insert into answer (answer_number, answer_text, answer_order, question_id) values (1, '', 1, @question_id);
SET @answer_id = LAST_INSERT_ID();


insert into question (question_number, question_text, question_order, section_id, questionnaire_id, answer_type) values (2, 'Do you have the appropriate tools, supplies, and equipment to complete your job tasks satisfactorily?', 2, @section_id, @questionnaire_id, 'TEXTAREA');
SET @question_id = LAST_INSERT_ID();

insert into answer (answer_number, answer_text, answer_order, question_id) values (1, '', 1, @question_id);
SET @answer_id = LAST_INSERT_ID();

insert into question (question_number, question_text, question_order, section_id, questionnaire_id, answer_type) values (3, 'Do you believe that you have the necessary training and are equipped with the knowledge, skill, and abilities to perform your current job effectively?', 3, @section_id, @questionnaire_id, 'TEXTAREA');
SET @question_id = LAST_INSERT_ID();

insert into answer (answer_number, answer_text, answer_order, question_id) values (1, '', 1, @question_id);
SET @answer_id = LAST_INSERT_ID();

insert into question (question_number, question_text, question_order, section_id, questionnaire_id, answer_type) values (4, 'Do you believe that you have the necessary training and are equipped with the knowledge, skill, and abilities to perform your current job effectively?', 4, @section_id, @questionnaire_id, 'TEXTAREA');
SET @question_id = LAST_INSERT_ID();

insert into answer (answer_number, answer_text, answer_order, question_id) values (1, '', 1, @question_id);
SET @answer_id = LAST_INSERT_ID();


insert into question (question_number, question_text, question_order, section_id, questionnaire_id, answer_type) values (5, 'Do you believe that you have the necessary training and are equipped with the knowledge, skill, and abilities to perform your current job effectively?Do you believe that you need specific training to improve your job performance, and if so, in what specific areas?', 5, @section_id, @questionnaire_id, 'TEXTAREA');
SET @question_id = LAST_INSERT_ID();

insert into answer (answer_number, answer_text, answer_order, question_id) values (1, '', 1, @question_id);
SET @answer_id = LAST_INSERT_ID();


insert into question (question_number, question_text, question_order, section_id, questionnaire_id, answer_type) values (6, 'What steps have you taken to prepare yourself for future career advancement through continuing education, self-development, or rotational assignments?', 6, @section_id, @questionnaire_id, 'TEXTAREA');
SET @question_id = LAST_INSERT_ID();

insert into answer (answer_number, answer_text, answer_order, question_id) values (1, '', 1, @question_id);
SET @answer_id = LAST_INSERT_ID();








insert into section (section_number, name, section_order, questionnaire_id) values (4, 'Job Knowledge & Performance:  Performance Management & Awards', 4, @questionnaire_id);
SET @section_id = LAST_INSERT_ID();

-- questions
insert into question (question_number, question_text, question_order, section_id, questionnaire_id, answer_type) values (1, 'Do you understand the primary functions of your position? Explain.', 1, @section_id, @questionnaire_id, 'TEXTAREA');
SET @question_id = LAST_INSERT_ID();

-- possible answers
insert into answer (answer_number, answer_text, answer_order, question_id) values (1, '', 1, @question_id);
SET @answer_id = LAST_INSERT_ID();


insert into question (question_number, question_text, question_order, section_id, questionnaire_id, answer_type) values (2, 'Does your performance appraisal contain performance elements and standards that are linked to Orbital’s strategic business plan? Explain:', 2, @section_id, @questionnaire_id, 'TEXTAREA');
SET @question_id = LAST_INSERT_ID();

insert into answer (answer_number, answer_text, answer_order, question_id) values (1, '', 1, @question_id);
SET @answer_id = LAST_INSERT_ID();

insert into question (question_number, question_text, question_order, section_id, questionnaire_id, answer_type) values (3, 'Do you know and understand what your position’s daily responsibilities are?', 3, @section_id, @questionnaire_id, 'TEXTAREA');
SET @question_id = LAST_INSERT_ID();

insert into answer (answer_number, answer_text, answer_order, question_id) values (1, '', 1, @question_id);
SET @answer_id = LAST_INSERT_ID();

insert into question (question_number, question_text, question_order, section_id, questionnaire_id, answer_type) values (4, 'Do your performance standards clearly define what results are expected in the completion of your job assignments?', 4, @section_id, @questionnaire_id, 'TEXTAREA');
SET @question_id = LAST_INSERT_ID();

insert into answer (answer_number, answer_text, answer_order, question_id) values (1, '', 1, @question_id);
SET @answer_id = LAST_INSERT_ID();


insert into question (question_number, question_text, question_order, section_id, questionnaire_id, answer_type) values (5, 'Do you know when your next performance appraisal is due? If so, when?', 5, @section_id, @questionnaire_id, 'TEXTAREA');
SET @question_id = LAST_INSERT_ID();

insert into answer (answer_number, answer_text, answer_order, question_id) values (1, '', 1, @question_id);
SET @answer_id = LAST_INSERT_ID();


insert into question (question_number, question_text, question_order, section_id, questionnaire_id, answer_type) values (6, 'Do you periodically record job accomplishments to help your rater complete your performance appraisal?', 6, @section_id, @questionnaire_id, 'TEXTAREA');
SET @question_id = LAST_INSERT_ID();

insert into answer (answer_number, answer_text, answer_order, question_id) values (1, '', 1, @question_id);
SET @answer_id = LAST_INSERT_ID();


insert into question (question_number, question_text, question_order, section_id, questionnaire_id, answer_type) values (7, 'Have you told your manager/supervisor about any feedback you have received and any accomplishments you have made?', 7, @section_id, @questionnaire_id, 'TEXTAREA');
SET @question_id = LAST_INSERT_ID();

insert into answer (answer_number, answer_text, answer_order, question_id) values (1, '', 1, @question_id);
SET @answer_id = LAST_INSERT_ID();


insert into question (question_number, question_text, question_order, section_id, questionnaire_id, answer_type) values (8, 'Have you told your manager/supervisor about after-work activities and interests such as volunteer work, hobbies, and community service?', 8, @section_id, @questionnaire_id, 'TEXTAREA');
SET @question_id = LAST_INSERT_ID();

insert into answer (answer_number, answer_text, answer_order, question_id) values (1, '', 1, @question_id);
SET @answer_id = LAST_INSERT_ID();


insert into question (question_number, question_text, question_order, section_id, questionnaire_id, answer_type) values (9, 'Have you ever received any incentive awards or recognition?  If so, list them.', 9, @section_id, @questionnaire_id, 'TEXTAREA');
SET @question_id = LAST_INSERT_ID();

insert into answer (answer_number, answer_text, answer_order, question_id) values (1, '', 1, @question_id);
SET @answer_id = LAST_INSERT_ID();


insert into section (section_number, name, section_order, questionnaire_id) values (5, 'Personal Growth:  Health and Wellness', 5, @questionnaire_id);
SET @section_id = LAST_INSERT_ID();

-- questions
insert into question (question_number, question_text, question_order, section_id, questionnaire_id, answer_type) values (1, 'Do you have an exercise or personal fitness program?', 1, @section_id, @questionnaire_id, 'TEXTAREA');
SET @question_id = LAST_INSERT_ID();

-- possible answers
insert into answer (answer_number, answer_text, answer_order, question_id) values (1, '', 1, @question_id);
SET @answer_id = LAST_INSERT_ID();


insert into question (question_number, question_text, question_order, section_id, questionnaire_id, answer_type) values (2, 'Do you feel the need to personally participate in efforts such as tobacco cessation classes or stress reduction or management programs?', 2, @section_id, @questionnaire_id, 'TEXTAREA');
SET @question_id = LAST_INSERT_ID();

insert into answer (answer_number, answer_text, answer_order, question_id) values (1, '', 1, @question_id);
SET @answer_id = LAST_INSERT_ID();

insert into question (question_number, question_text, question_order, section_id, questionnaire_id, answer_type) values (3, 'Have you had a physical/dental examination within the last three years?', 3, @section_id, @questionnaire_id, 'TEXTAREA');
SET @question_id = LAST_INSERT_ID();

insert into answer (answer_number, answer_text, answer_order, question_id) values (1, '', 1, @question_id);
SET @answer_id = LAST_INSERT_ID();

insert into question (question_number, question_text, question_order, section_id, questionnaire_id, answer_type) values (4, 'Do you practice safety in the workplace and take action to report all unsafe conditions promptly to either your supervisor or to the proper safety authority?', 4, @section_id, @questionnaire_id, 'TEXTAREA');
SET @question_id = LAST_INSERT_ID();

insert into answer (answer_number, answer_text, answer_order, question_id) values (1, '', 1, @question_id);
SET @answer_id = LAST_INSERT_ID();

insert into section (section_number, name, section_order, questionnaire_id) values (6, 'Personal Growth:  Ethical Behavior and Outside Interests', 6, @questionnaire_id);
SET @section_id = LAST_INSERT_ID();

-- questions
insert into question (question_number, question_text, question_order, section_id, questionnaire_id, answer_type) values (1, 'Are you familiar with Orbital’s ethics guidance and policies?  Explain.', 1, @section_id, @questionnaire_id, 'TEXTAREA');
SET @question_id = LAST_INSERT_ID();

-- possible answers
insert into answer (answer_number, answer_text, answer_order, question_id) values (1, '', 1, @question_id);
SET @answer_id = LAST_INSERT_ID();


insert into question (question_number, question_text, question_order, section_id, questionnaire_id, answer_type) values (2, 'Are you aware of Orbitals core values?  If so, list them.', 2, @section_id, @questionnaire_id, 'TEXTAREA');
SET @question_id = LAST_INSERT_ID();

insert into answer (answer_number, answer_text, answer_order, question_id) values (1, '', 1, @question_id);
SET @answer_id = LAST_INSERT_ID();

insert into question (question_number, question_text, question_order, section_id, questionnaire_id, answer_type) values (3, 'What are your interests outside of the workplace?', 3, @section_id, @questionnaire_id, 'TEXTAREA');
SET @question_id = LAST_INSERT_ID();

insert into answer (answer_number, answer_text, answer_order, question_id) values (1, '', 1, @question_id);
SET @answer_id = LAST_INSERT_ID();




SET FOREIGN_KEY_CHECKS = 1;
