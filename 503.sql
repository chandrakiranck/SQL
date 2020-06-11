USE HR;

SELECT DISTINCT salary FROM Employees;
SELECT DISTINCT department_id FROM Employees;

SELECT DISTINCT salary,department_id FROM Employees;

# sort employee details based on salary in descending order and dept id in ascending
SELECT * FROM Employees ORDER BY salary DESC, department_id;

# sort by column numbers
SELECT * FROM Employees ORDER BY 2,3;

# list the salary, annual salary of employees and sort by annual salary
SELECT salary, salary*12 AS annual_salary FROM Employees ORDER BY annual_salary DESC;

# DATE
SELECT NOW(),SYSDATE(),CURRENT_DATE();

SELECT last_name,salary
FROM Employees
WHERE salary>10000 AND department_id!=90;

SELECT *
FROM Employees
WHERE salary>10000
AND department_id IN (80,60);

SELECT *
FROM Employees
WHERE salary>10000
AND (department_id=80 OR department_id=60);

SELECT DISTINCT(salary)
FROM employees
ORDER BY salary DESC
LIMIT 49,1;

SELECT round(99.966,2);
SELECT truncate(99.966,1);
SELECT mod(505,10);

SELECT substr('Shankar',-6,4);

SELECT CURDATE(), CURTIME();

SELECT PERIOD_DIFF(201909,201801);

SELECT HIRE_DATE,date_format(HIRE_DATE, '%Y---%M----%y-----%m-----%D-----%d') FROM EMPLOYEES;

SELECT last_name,job_id,salary,
	CASE job_id WHEN 'IT_PROG' THEN 1.10*salary
				WHEN 'ST_CLERK' THEN 1.15*salary
                WHEN 'SA_REP' THEN 1.20*salary
                ELSE salary
	END AS revised_salary
FROM employees;

SELECT department_id, max(salary) FROM employees GROUP BY department_id;

#display details of job where min salary is greater than 10000
select * from jobs where min_salary>10000;

# first name, join date of employees who joined between 1991 and 1995
select first_name,hire_date from employees where year(hire_date) between 1991 and 1995;

# first name, join date of employees who is either it programmer or salesman
select first_name,hire_date from employees where job_id in ('IT_PROG','SA_REP');

# all employees who joined after 1st january 2008
select * from employees where hire_date > '2008-01-01';

# employees with id 150 or 160
select * from employees where employee_id in (150,160);

SELECT first_name, salary, commission_pct, hire_date FROM employees WHERE salary < 10000;

SELECT job_title,max_salary-min_salary from jobs where max_salary between 10000 and 20000;

SELECT first_name,salary,round(salary,-3) from employees;

select * from jobs order by job_title desc;

select * from employees where first_name like 's%' or last_name like 's%';

select * from employees where month(hire_date)=5;

select * from employees where commission_pct is null and salary between 5000 and 10000 and department_id=30;

select first_name,adddate(last_day(hire_date),1) as first_salary from employees;

select employee_id, round(datediff(end_date, start_date)/365) from job_history;
select first_name,datediff(curdate(),hire_date)/365 as experience from employees;

select first_name from employees where year(hire_date)=2001;

select substr(job_title, 1,instr(job_title, ' ')) from jobs;

select substring_index(job_title, ' ',1) from jobs;

select * from regions r,countries c where r.region_id=c.region_id;

select * from regions inner join countries;

select * from regions natural join countries;

select * from countries natural join locations;