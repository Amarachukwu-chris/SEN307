-- VUA-SEN307 Database Systems | Week 6 Practical | Lab 4: DML
-- Author: Ogah Christopher (VUG/SEN/24/11932)

USE sen307_11932;

-- PART 1: Departments and Courses (provided)


INSERT INTO Department (dept_name) VALUES
('Software Engineering'),
('Computer Science'),
('Artificial Intelligence'),
('Data Science'),
('Cybersecurity');

INSERT INTO Course (course_code, course_title, credit_units, description, dept_id) VALUES
('SEN307', 'Database Systems', 3,
 'Relational database design, SQL queries, normalization, transactions and indexing using MySQL.',
 (SELECT dept_id FROM Department WHERE dept_name = 'Software Engineering')),
('SEN301', 'Software Architecture', 3,
 'Architectural styles, design patterns, microservices and how to structure large software systems.',
 (SELECT dept_id FROM Department WHERE dept_name = 'Software Engineering')),
('COS301', 'Operating Systems', 3,
 'Processes, threads, CPU scheduling, memory management and file systems.',
 (SELECT dept_id FROM Department WHERE dept_name = 'Computer Science')),
('COS305', 'Computer Networks', 3,
 'TCP/IP, routing, switching, LAN and WAN design and network protocols.',
 (SELECT dept_id FROM Department WHERE dept_name = 'Computer Science')),
('AIN301', 'Introduction to Artificial Intelligence', 3,
 'Intelligent agents, search algorithms, knowledge representation and reasoning.',
 (SELECT dept_id FROM Department WHERE dept_name = 'Artificial Intelligence')),
('AIN305', 'Machine Learning', 3,
 'Supervised and unsupervised learning, neural networks, deep learning and model evaluation.',
 (SELECT dept_id FROM Department WHERE dept_name = 'Artificial Intelligence')),
('AIN307', 'Natural Language Processing', 3,
 'Text processing, word embeddings, language models, sentiment analysis and chatbots.',
 (SELECT dept_id FROM Department WHERE dept_name = 'Artificial Intelligence')),
('DTS301', 'Data Visualization and Analytics', 2,
 'Exploratory data analysis, charts, dashboards and telling stories with data.',
 (SELECT dept_id FROM Department WHERE dept_name = 'Data Science')),
('DTS305', 'Big Data Technologies', 3,
 'Distributed storage and processing of very large datasets with Hadoop and Spark.',
 (SELECT dept_id FROM Department WHERE dept_name = 'Data Science')),
('CYB301', 'Network Security', 3,
 'Firewalls, cryptography, intrusion detection and protecting networks from attacks.',
 (SELECT dept_id FROM Department WHERE dept_name = 'Cybersecurity'));

-- Check: expect 5 departments and 10 courses in total
SELECT d.dept_name, COUNT(c.course_id) AS courses
FROM Department d LEFT JOIN Course c ON d.dept_id = c.dept_id
GROUP BY d.dept_name;

-- ID numbers used in Part 2 (expected: dept_id 1-5 and course_id 1-10, in the order inserted)
SELECT dept_id, dept_name FROM Department;
SELECT course_id, course_code FROM Course;

-- =====================================================================
-- PART 2: Own data
-- dept_id: 1 = Software Engineering, 2 = Computer Science,
--          3 = Artificial Intelligence, 4 = Data Science, 5 = Cybersecurity
-- =====================================================================

-- Look up the real dept_id values by name (auto-increment may not have started at 1)
SET @se = (SELECT dept_id FROM Department WHERE dept_name = 'Software Engineering');
SET @cs = (SELECT dept_id FROM Department WHERE dept_name = 'Computer Science');
SET @ai = (SELECT dept_id FROM Department WHERE dept_name = 'Artificial Intelligence');
SET @ds = (SELECT dept_id FROM Department WHERE dept_name = 'Data Science');
SET @cy = (SELECT dept_id FROM Department WHERE dept_name = 'Cybersecurity');

-- Failed inserts still use up auto-increment numbers, so restart the IDs at 1
-- (these only work while the tables are empty; the Enrolment and CourseAllocation numbers below expect 1-based IDs)
ALTER TABLE Lecturer AUTO_INCREMENT = 1;
ALTER TABLE Student AUTO_INCREMENT = 1;

-- Step 1: Lecturers (10, two per department)
INSERT INTO Lecturer (staff_no, full_name, email, dept_id) VALUES
('VUA/ST/101', 'Dr Amaka Okafor',      'a.okafor@vua.edu.ng',    @se),
('VUA/ST/102', 'Dr Musa Bello',        'm.bello@vua.edu.ng',     @se),
('VUA/ST/103', 'Dr Ngozi Eze',         'n.eze@vua.edu.ng',       @cs),
('VUA/ST/104', 'Prof Ibrahim Danjuma', 'i.danjuma@vua.edu.ng',   @cs),
('VUA/ST/105', 'Dr Chidi Nwosu',       'c.nwosu@vua.edu.ng',     @ai),
('VUA/ST/106', 'Dr Fatima Abdullahi',  'f.abdullahi@vua.edu.ng', @ai),
('VUA/ST/107', 'Dr Emeka Okonkwo',     'e.okonkwo@vua.edu.ng',   @ds),
('VUA/ST/108', 'Dr Halima Suleiman',   'h.suleiman@vua.edu.ng',  @ds),
('VUA/ST/109', 'Dr Tunde Adeyemi',     't.adeyemi@vua.edu.ng',   @cy),
('VUA/ST/110', 'Dr Blessing Udoh',     'b.udoh@vua.edu.ng',      @cy);

-- Step 2: Students (20). Row 3 is me.
-- Gender and date_of_birth for row 3 are left NULL here; fill them in with the UPDATE below if you want.
INSERT INTO Student (matric_no, full_name, gender, date_of_birth, dept_id) VALUES
('20231234',         'Ada Obi',           'F', '2005-03-14', @se),
('20231235',         'John Musa',         'M', '2004-11-02', @cs),
('VUG/SEN/24/11932', 'Ogah Christopher',  NULL, NULL,        @se),
('20231236',         'Chiamaka Nwankwo',  'F', '2005-07-21', @se),
('20231237',         'Ibrahim Yusuf',     'M', '2003-09-30', @cs),
('20231238',         'Folake Adebayo',    'F', '2006-01-18', @ai),
('20231239',         'Emeka Eze',         'M', '2004-05-09', @ai),
('20231240',         'Zainab Lawal',      'F', '2005-12-25', @ds),
('20231241',         'Tochukwu Okeke',    'M', '2003-02-11', @ds),
('20231242',         'Aisha Garba',       'F', '2006-08-03', @cy),
('20231243',         'Oluwaseun Balogun', 'M', '2004-10-17', @cy),
('20231244',         'Ngozi Ibe',         'F', '2007-04-06', @se),
('20231245',         'Abdullahi Sani',    'M', '2005-06-28', @cs),
('20231246',         'Blessing Okon',     'F', '2004-02-14', @ai),
('20231247',         'Chinedu Obi',       'M', '2006-11-12', @ds),
('20231248',         'Hauwa Mohammed',    'F', '2003-12-01', @cy),
('20231249',         'Daniel Ogbu',       'M', '2007-01-23', @se),
('20231250',         'Yetunde Ojo',       'F', '2005-09-15', @cs),
('20231251',         'Samuel Akpan',      'M', '2004-07-07', @ai),
('20231252',         'Patience Ushie',    'F', '2006-03-19', @ds);

-- Optional: fill in my own gender and date of birth (replace the values, then run)
-- UPDATE Student SET gender = 'M', date_of_birth = '2005-01-01' WHERE matric_no = 'VUG/SEN/24/11932';

-- Step 3: Enrolments (40) and course allocations
SELECT student_id, matric_no, full_name FROM Student;
SELECT lecturer_id, full_name FROM Lecturer;

-- Students 19 and 20 are deliberately left with no enrolments (Weeks 7 and 8).
-- Course 1 (SEN307) has 8 students (Week 8, HAVING).
INSERT INTO Enrolment (student_id, course_id) VALUES
(1, 1),  (1, 2),
(2, 1),  (2, 3),
(3, 1),  (3, 2),  (3, 6),
(4, 1),  (4, 8),
(5, 1),  (5, 3),  (5, 4),
(6, 5),  (6, 6),
(7, 5),  (7, 7),
(8, 8),  (8, 9),
(9, 9),  (9, 10),
(10, 4), (10, 10),
(11, 1), (11, 10),
(12, 1), (12, 2), (12, 7),
(13, 3), (13, 4),
(14, 6), (14, 7),
(15, 8), (15, 9),
(16, 4), (16, 10),
(17, 1), (17, 2),
(18, 5), (18, 6), (18, 9);

-- Every course has at least one lecturer; courses 1 and 10 have two.
INSERT INTO CourseAllocation (course_id, lecturer_id) VALUES
(1, 1), (1, 2),
(2, 2),
(3, 3),
(4, 4),
(5, 5),
(6, 6),
(7, 5),
(8, 7),
(9, 8),
(10, 9), (10, 10);

-- =====================================================================
-- PART 3: UPDATE a record
-- =====================================================================

SELECT matric_no, full_name, dept_id FROM Student WHERE matric_no = '20231234';

SET SQL_SAFE_UPDATES = 0;
UPDATE Student SET dept_id = @cs WHERE matric_no = '20231234';
SET SQL_SAFE_UPDATES = 1;

SELECT matric_no, full_name, dept_id FROM Student WHERE matric_no = '20231234';

-- =====================================================================
-- PART 4: Referential integrity
-- =====================================================================

-- Step 1: create a department with a student in it
INSERT INTO Department (dept_name) VALUES ('Library and Information Science');

INSERT INTO Student (matric_no, full_name, dept_id)
VALUES ('20239999', 'Transfer Student',
        (SELECT dept_id FROM Department WHERE dept_name = 'Library and Information Science'));

-- Step 2: try to delete the department. This FAILS with Error 1451.
-- Run this statement on its own, screenshot the error, then carry on from Step 3.
-- (It is commented out so the rest of the script can run top to bottom without stopping.)
-- DELETE FROM Department WHERE dept_name = 'Library and Information Science';

-- Step 3: fix it the correct way
SET SQL_SAFE_UPDATES = 0;

-- 3a: reassign the dependent student to another department
UPDATE Student
SET dept_id = (SELECT dept_id FROM Department WHERE dept_name = 'Software Engineering')
WHERE matric_no = '20239999';

-- 3b: now the delete succeeds
DELETE FROM Department WHERE dept_name = 'Library and Information Science';

SET SQL_SAFE_UPDATES = 1;

SELECT * FROM Department;   -- back to 5 departments

-- =====================================================================
-- FINAL CHECK (screenshot this result)
-- Expected: 5 departments, 10 lecturers, 21 students, 10 courses, 40 enrolments, 12 allocations
-- =====================================================================

SELECT 'Departments' AS tbl, COUNT(*) AS total FROM Department
UNION ALL SELECT 'Lecturers', COUNT(*) FROM Lecturer
UNION ALL SELECT 'Students', COUNT(*) FROM Student
UNION ALL SELECT 'Courses', COUNT(*) FROM Course
UNION ALL SELECT 'Enrolments', COUNT(*) FROM Enrolment
UNION ALL SELECT 'Allocations', COUNT(*) FROM CourseAllocation;
