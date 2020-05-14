-- Exported from QuickDBD: https://www.quickdatabasediagrams.com/
-- Link to schema: https://app.quickdatabasediagrams.com/#/d/P2lh31

-- These Drops are here just in case someone makes between 50 and 400 errors and has to start over
--DROP TABLE IF EXISTS titles;
--DROP TABLE IF EXISTS employees;
--DROP TABLE IF EXISTS departments;
--DROP TABLE IF EXISTS dept_manager;
--DROP TABLE IF EXISTS dept_emp;
--DROP TABLE IF EXISTS salaries;

-- Tables code below from quickDBD.  I've also imported data to the tables after running each table code
CREATE TABLE "titles" (
    "title_id" VARCHAR(30)   NOT NULL,
    "title" VARCHAR(30)   NOT NULL,
    CONSTRAINT "pk_titles" PRIMARY KEY (
        "title_id"
     )
);

CREATE TABLE "employees" (
    "emp_no" int   NOT NULL,
    "emp_title_id" VARCHAR(30)   NOT NULL,
    "birth_date" DATE   NOT NULL,
    "first_name" VARCHAR(30)   NOT NULL,
    "last_name" VARCHAR(30)   NOT NULL,
    "sex" VARCHAR(30)   NOT NULL,
    "hire_date" DATE   NOT NULL,
    CONSTRAINT "pk_employees" PRIMARY KEY (
        "emp_no"
     )
);

CREATE TABLE "departments" (
    "dept_no" VARCHAR(30)   NOT NULL,
    "dept_name" VARCHAR(30)   NOT NULL,
    CONSTRAINT "pk_departments" PRIMARY KEY (
        "dept_no"
     )
);

CREATE TABLE "dept_manager" (
    "dept_no" VARCHAR(30)   NOT NULL,
    "emp_no" int   NOT NULL
);

CREATE TABLE "dept_emp" (
    "emp_no" int   NOT NULL,
    "dept_no" VARCHAR(30)   NOT NULL
);

CREATE TABLE "salaries" (
    "emp_no" int   NOT NULL,
    "salary" int   NOT NULL
);

ALTER TABLE "employees" ADD CONSTRAINT "fk_employees_emp_title_id" FOREIGN KEY("emp_title_id")
REFERENCES "titles" ("title_id");

ALTER TABLE "dept_manager" ADD CONSTRAINT "fk_dept_manager_dept_no" FOREIGN KEY("dept_no")
REFERENCES "departments" ("dept_no");

ALTER TABLE "dept_manager" ADD CONSTRAINT "fk_dept_manager_emp_no" FOREIGN KEY("emp_no")
REFERENCES "employees" ("emp_no");

ALTER TABLE "dept_emp" ADD CONSTRAINT "fk_dept_emp_emp_no" FOREIGN KEY("emp_no")
REFERENCES "employees" ("emp_no");

ALTER TABLE "dept_emp" ADD CONSTRAINT "fk_dept_emp_dept_no" FOREIGN KEY("dept_no")
REFERENCES "departments" ("dept_no");

ALTER TABLE "salaries" ADD CONSTRAINT "fk_salaries_emp_no" FOREIGN KEY("emp_no")
REFERENCES "employees" ("emp_no");

--Check any table with code beolw
--SELECT * FROM titles

--1)List the following details of each employee: employee number, last name, first name, sex, and salary.
SELECT e.emp_no, e.last_name, e.first_name, e.sex, s.salary
FROM employees e JOIN salaries s on e.emp_no = s.emp_no;

--2)List first name, last name, and hire date for employees who were hired in 1986.
SELECT first_name, last_name, hire_date
FROM employees WHERE hire_date BETWEEN '1986-01-01' AND '1986-12-31'; --This part took me longer than I should admit (I pulled date wrong from CSV)

--3)List the manager of each department with the following information: department number, department name, 
--	the manager's employee number, last name, first name.  --Joining from 3 tables
SELECT d.dept_no, d.dept_name, dm.emp_no, e.last_name, e.first_name
FROM departments d 
JOIN dept_manager dm on dm.dept_no = d.dept_no
JOIN employees e on e.emp_no = dm.emp_no;	

--4)List the department of each employee with the following information: employee number, last name, first name, and department name.
--Joining from departments to employees accross dept_emp because the two tables have nothing in common (junction table)
SELECT e.emp_no, e.last_name, e.first_name, d.dept_name
FROM employees e 
JOIN dept_emp de on de.emp_no = e.emp_no
JOIN departments d on d.dept_no = de.dept_no;

--5)List first name, last name, and sex for employees whose first name is "Hercules" and last names begin with "B."
SELECT last_name, first_name, sex
FROM employees WHERE first_name  = 'Hercules' AND last_name LIKE 'B%'; --Irony, I asked Richard about this before the HW was assigned

--6)List all employees in the Sales department, including their employee number, last name, first name, and department name.
SELECT e.emp_no, e.last_name, e.first_name, d.dept_name
FROM employees e 
JOIN dept_emp de on de.emp_no = e.emp_no
JOIN departments d on d.dept_no = de.dept_no
WHERE dept_name  = 'Sales'; --Same as #4 but with this filter

--7)List all employees in the Sales and Development departments, including their employee number, last name, first name, and department name.
SELECT e.emp_no, e.last_name, e.first_name, d.dept_name
FROM employees e 
JOIN dept_emp de on de.emp_no = e.emp_no
JOIN departments d on d.dept_no = de.dept_no
WHERE dept_name  = 'Sales' OR dept_name  = 'Development';--Same as above but with 'OR'

--8)In descending order, list the frequency count of employee last names, i.e., how many employees share each last name.
SELECT last_name, COUNT(last_name) AS "Count of Last Name Occurrences" 
FROM employees GROUP BY last_name ORDER BY "Count of Last Name Occurrences" DESC; --Pretty much stright from the class file