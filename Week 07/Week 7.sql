-- VUA-SEN307 Lab 5: SELECT, Filtering and Joins
-- Name: Ogah Christopher   Matric: VUG/SEN/24/11932

USE sen307_11932;

-- Optional sanity check: confirm column names before running the tasks
-- DESCRIBE Student;
-- DESCRIBE Lecturer;
-- DESCRIBE CourseAllocation;

-- --------------------------------------------
-- Recap: check that the Week 6 data is present
-- --------------------------------------------
SELECT 'Departments' AS tbl, COUNT(*) AS total FROM Department
UNION ALL SELECT 'Lecturers', COUNT(*) FROM Lecturer
UNION ALL SELECT 'Students', COUNT(*) FROM Student
UNION ALL SELECT 'Courses', COUNT(*) FROM Course
UNION ALL SELECT 'Enrolments', COUNT(*) FROM Enrolment
UNION ALL SELECT 'Allocations', COUNT(*) FROM CourseAllocation;
-- Counts every row in each table. Any total of 0 means week06/data.sql must be re-run.


-- ============================================
-- Task 1: Students in one department, sorted A-Z
-- Explanation: Student is joined to Department on dept_id, filtered to
-- Software Engineering with WHERE, and sorted alphabetically by full_name.
-- ============================================
SELECT s.student_id, s.full_name, d.dept_name
FROM Student s
INNER JOIN Department d ON s.dept_id = d.dept_id
WHERE d.dept_name = 'Software Engineering'
ORDER BY s.full_name ASC;
-- Lists every Software Engineering student, A to Z by name.


-- ============================================
-- Task 2: Courses with their lecturers (INNER JOIN)
-- Explanation: Course and Lecturer have no direct link, so the query goes
-- Course -> CourseAllocation -> Lecturer using two INNER JOINs. INNER JOIN
-- keeps only rows that match in both tables, so a course with two lecturers
-- appears twice (once per lecturer) and a course with no lecturer is left out.
-- ============================================
SELECT c.course_id, c.course_title, l.full_name AS lecturer_name
FROM Course c
INNER JOIN CourseAllocation ca ON c.course_id = ca.course_id
INNER JOIN Lecturer l ON ca.lecturer_id = l.lecturer_id
ORDER BY c.course_title, l.full_name;
-- Shows each course next to the lecturer(s) teaching it.


-- ============================================
-- Task 3: Students and their courses (LEFT JOIN)
-- Explanation: Student is the left table, so LEFT JOIN keeps every student.
-- Where a student has no enrolment, the Enrolment and Course columns are NULL,
-- so course_title shows NULL for that student.
-- ============================================
SELECT s.full_name, c.course_title
FROM Student s
LEFT JOIN Enrolment e ON s.student_id = e.student_id
LEFT JOIN Course c ON e.course_id = c.course_id
ORDER BY s.full_name;
-- Every student with each course they take; students with no courses show NULL.

-- Task 3 (continued): only the students with no courses
SELECT s.full_name, c.course_title
FROM Student s
LEFT JOIN Enrolment e ON s.student_id = e.student_id
LEFT JOIN Course c ON e.course_id = c.course_id
WHERE c.course_title IS NULL
ORDER BY s.full_name;
-- Keeps only the rows where the LEFT JOIN found no match. This should return
-- the two students created in Week 6. IS NULL is used because "= NULL" never works.


-- ============================================
-- Task 4: Filtering with AND / OR / IN / BETWEEN
-- Explanation: Female students in Software Engineering or Artificial
-- Intelligence, born between 2004-01-01 and 2005-12-31. This uses AND (all
-- conditions must hold), IN (a list of allowed departments, which is a short
-- way to write OR) and BETWEEN (an inclusive date range).
-- ============================================
SELECT s.student_id, s.full_name, s.gender, d.dept_name, s.date_of_birth
FROM Student s
INNER JOIN Department d ON s.dept_id = d.dept_id
WHERE s.gender = 'F'
  AND d.dept_name IN ('Software Engineering', 'Artificial Intelligence')
  AND s.date_of_birth BETWEEN '2004-01-01' AND '2005-12-31'
ORDER BY d.dept_name, s.full_name;
-- Returns only students who meet all three conditions at once.

-- Task 4 (extra): the same idea with OR, using brackets
SELECT s.student_id, s.full_name, s.gender, d.dept_name, s.date_of_birth
FROM Student s
INNER JOIN Department d ON s.dept_id = d.dept_id
WHERE s.gender = 'F'
  AND (d.dept_name = 'Software Engineering' OR d.dept_name = 'Artificial Intelligence')
  AND s.date_of_birth BETWEEN '2004-01-01' AND '2005-12-31'
ORDER BY d.dept_name, s.full_name;
-- Gives the same rows. Brackets matter: AND binds tighter than OR, so without
-- them the gender and date filters would apply only to the second department.


-- ============================================
-- Task 5: Paginating enrolments with LIMIT and OFFSET
-- Explanation: LIMIT 10 returns 10 rows per page. OFFSET says how many rows to
-- skip first: 0 for page 1, 10 for page 2.
-- ============================================

-- Page 1 (rows 1-10)
SELECT *
FROM Enrolment
ORDER BY enrolment_id
LIMIT 10 OFFSET 0;
-- Shows the first 10 enrolments.

-- Page 2 (rows 11-20)
SELECT *
FROM Enrolment
ORDER BY enrolment_id
LIMIT 10 OFFSET 10;
-- Skips the first 10 enrolments and shows the next 10.

-- Why always use ORDER BY with LIMIT? A table has no guaranteed row order.
-- Without ORDER BY, MySQL may return rows in a different order each time, so
-- page 1 and page 2 could overlap or miss rows. ORDER BY enrolment_id fixes the
-- order, so every page is consistent and repeatable.


-- ============================================
-- Challenge (optional): Task 3 rewritten with RIGHT JOIN
-- Explanation: The tables are written in reverse order, so Student comes last
-- and becomes the right table. RIGHT JOIN keeps every row from the right table,
-- so every student is kept, with NULL where there is no enrolment or course.
-- ============================================
SELECT s.full_name, c.course_title
FROM Course c
RIGHT JOIN Enrolment e ON c.course_id = e.course_id
RIGHT JOIN Student s ON e.student_id = s.student_id
ORDER BY s.full_name;
-- Same result as the LEFT JOIN version in Task 3.

-- Which is easier to read? The LEFT JOIN version. It starts from Student (the
-- thing we want every row of) and reads top to bottom, adding detail as it goes.
-- The RIGHT JOIN version starts from Course and only reaches Student on the
-- last line, so you must read to the end to see which table is being preserved.
-- Most people use LEFT JOIN for this reason and just reorder the tables.
