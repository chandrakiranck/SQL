USE HR;

SELECT FIRST_NAME,DEPARTMENT_NAME
FROM EMPLOYEES NATURAL JOIN DEPARTMENTS;

# display employee id for employees who did more than one job in the past
SELECT EMPLOYEE_ID
FROM JOB_HISTORY
GROUP BY EMPLOYEE_ID
HAVING COUNT(*)>1;

# display job id of jobs that were done by more than 3 employees for more than 100 days
SELECT JOB_ID
FROM JOB_HISTORY
WHERE END_DATE-START_DATE>100
GROUP BY JOB_ID
HAVING COUNT(*)>1;

# display dept_id,year,no of employees joined
SELECT DEPARTMENT_ID,YEAR(HIRE_DATE),COUNT(*)
FROM EMPLOYEES E
GROUP BY DEPARTMENT_ID,YEAR(HIRE_DATE);

# display department name and number of employees in department
SELECT D.DEPARTMENT_NAME, COUNT(*)
FROM EMPLOYEES E, DEPARTMENTS D
WHERE E.DEPARTMENT_ID=D.DEPARTMENT_ID
GROUP BY E.DEPARTMENT_ID;

# list departments that do not have any managers
SELECT * 
FROM DEPARTMENTS
WHERE MANAGER_ID IS NULL;

# list the employees who are managing a department
select * from 
employees e, departments d 
where e.employee_id=d.manager_id;

# list the employees who are not managing a department
select employee_id from employees where employee_id not in (select manager_id from departments where manager_id is not null);
select manager_id from departments;

# list details of managers/supervisors of employees
select distinct(e1.manager_id),e2.first_name,e2.last_name
from employees e1, employees e2
where e1.manager_id=e2.employee_id;

# list details of employees whose start date is greater than other employees in their department
select jh.department_id,max(jh.start_date),e.first_name,e.last_name
from job_history jh, employees e
where jh.employee_id=e.employee_id
group by jh.department_id;

# list details of employees and departments who are managing a department and not managing a department
select * from employees e left join departments d on e.employee_id=d.manager_id;

# list details of employees and departments who are working for and not working for a department
select * from employees e left join departments d on e.department_id=d.department_id;

# list all departments with and without employees
select * from employees e right join departments d on d.department_id=e.department_id;

select * from jobs union select * from departments;

# list employees who either work for dept no 90 or manage employees working dept 90
select employee_id from employees where department_id=90 union select manager_id from employees where department_id=90;

select last_name,department_id,count(*) over (partition by department_id) dept_cnt from employees;

# list of employees who have same job id as Nayer but draw higher salary than her
SELECT FIRST_NAME,LAST_NAME,JOB_ID,SALARY
FROM EMPLOYEES
WHERE JOB_ID = (SELECT JOB_ID FROM EMPLOYEES WHERE LAST_NAME='Nayer')
AND SALARY > (SELECT SALARY FROM EMPLOYEES WHERE LAST_NAME='Nayer');

# list the departments whose min salary is more than min salary of dept 50
SELECT DEPARTMENT_ID, MIN(SALARY)
FROM EMPLOYEES
GROUP BY DEPARTMENT_ID
HAVING MIN(SALARY) > (SELECT MIN(SALARY) FROM EMPLOYEES WHERE DEPARTMENT_ID=50);

SELECT EMPLOYEE_ID, FIRST_NAME, JOB_ID, SALARY, RANK() OVER (PARTITION BY DEPARTMENT_ID ORDER BY SALARY DESC) AS RANKING,
DENSE_RANK() OVER (PARTITION BY DEPARTMENT_ID ORDER BY SALARY DESC) AS DENSE_RANKING
FROM EMPLOYEES
ORDER BY RANKING;

SELECT EMPLOYEE_ID,FIRST_NAME,JOB_ID,HIRE_DATE,FIRST_VALUE(HIRE_DATE)
OVER (PARTITION BY DEPARTMENT_ID ORDER BY HIRE_DATE) DAY_GAP
FROM EMPLOYEES
ORDER BY DEPARTMENT_ID,DAY_GAP;

use hr;
