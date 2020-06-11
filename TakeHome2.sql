USE	HR;

# Q1. List all IT related departments where there are no managers .(2 rows)[NOTE:DEPARTMENT TABLE]
SELECT * FROM DEPARTMENTS WHERE DEPARTMENT_NAME LIKE 'IT%' AND MANAGER_ID IS NULL;

# Q2. Print a bonafide certificate for an employee (say for emp. id 123) as below:
#"This is to certify that <full name> with employee id <emp. id> is working as <job id> in dept. <dept ID>. (1 ROW) [NOTE : EMPLOYEES table].
SELECT 
CONCAT('This is to certify that ', first_name, ' ', last_name, ' with employee id ', employee_id, ' is working as ', job_id, ' in dept ', department_id) 
AS 'Certificate' 
FROM EMPLOYEES WHERE EMPLOYEE_ID=123;


#Q3. 3.	Write a  query to display the  employee id, salary & salary range of employees as 'Tier1', 'Tier2' or 'Tier3' 
# as per the range <5000, 5000-10000, >10000 respectively,ordering the output by those tiers.(107 ROWS)[NOTE :EMPLOYEES TABLE]
SELECT EMPLOYEE_ID,SALARY,
CASE 
	WHEN SALARY<5000 THEN 'Tier1' 
    WHEN SALARY<=10000 THEN 'Tier2' 
    ELSE 'Tier3' 
END AS SALARY_RANGE FROM EMPLOYEES ORDER BY SALARY_RANGE;

# Q4. Write a query to display the department-wise and job-id-wise 
# total salaries of employees whose salary is more than 25000.(8 rows) [NOTE : EMPLOYEES TABLE]
SELECT DEPARTMENT_ID, JOB_ID, SUM(SALARY) FROM EMPLOYEES GROUP BY DEPARTMENT_ID,JOB_ID HAVING SUM(SALARY)>25000;

# Q5. Write a query to display names of employees whose first name as well as last name ends with vowels.  (vowels : aeiou )
# (5 rows) [NOTE : EMPLOYEES TABLE]
SELECT CONCAT(FIRST_NAME, ' ' , LAST_NAME) AS FULL_NAME FROM EMPLOYEES WHERE FIRST_NAME REGEXP '[aeiou]$' AND LAST_NAME REGEXP '[aeiou]$';

# Q6. What is the average salary range (diff. between min & max salary) of all types 'Manager's and 'Clerk's. (2 rows)[NOTE : JOBS TABLE]
SELECT
CASE
	WHEN JOB_TITLE LIKE '%Manager' THEN 'MANAGERS'
    WHEN JOB_TITLE LIKE '%Clerk' THEN 'CLERKS'
END AS JOB_TYPE,
AVG(MAX_SALARY - MIN_SALARY)
FROM JOBS
GROUP BY JOB_TYPE
HAVING JOB_TYPE IS NOT NULL;

select * from jobs;

select * from jobs;

# Q7. Show location id and cities of US or UK whose city name starts from 'S' but not from 'South'. (2 rows)[NOTE : LOCATION TABLE]
SELECT LOCATION_ID, CITY FROM LOCATIONS WHERE COUNTRY_ID IN ('US','UK') AND CITY LIKE 's%' AND CITY NOT LIKE 'south%';

USE ORDERS;

# Q8. Write a query to display the all the records of customers whose creation date is before ’12-Jan-2006’ 
# and email address contains ‘gmail’ or ‘yahoo’ and user name starts with ‘dave’. (2 ROWS)[NOTE : ONLINE_CUSTOMER TABLE]
SELECT * FROM ONLINE_CUSTOMER 
WHERE CUSTOMER_CREATION_DATE<'2006-01-12' 
	AND (CUSTOMER_EMAIL LIKE '%gmail%' OR CUSTOMER_EMAIL LIKE '%yahoo%')
    AND CUSTOMER_USERNAME LIKE 'dave%';
    
# Q9. Write query to display the product id,product_description and total worth(product_price * product_quantity available) 
# of each product.(60 rows)[NOTE : PRODUCT TABLE]
SELECT PRODUCT_ID, PRODUCT_DESC, (PRODUCT_PRICE*PRODUCT_QUANTITY_AVAIL) AS 'Total Worth' FROM PRODUCT;

# Q10. Write a query to Display details of customer who have Gmail account and phone number consist of ‘77’ as below:
# <Customer full name> (<customer user name>) created on <date>. Contact Phone: <Phone no.> E-mail: <E-mail id>.
# (6 rows)[NOTE : ONLINE_CUSTOMER TABLE]
SELECT 
CONCAT(CUSTOMER_FNAME,' ',CUSTOMER_LNAME,' (',CUSTOMER_USERNAME,') created on ',CUSTOMER_CREATION_DATE,'. Contact Phone: ',CUSTOMER_PHONE,' E-mail: ',CUSTOMER_EMAIL) AS CUSTOMER_DETAILS
FROM ONLINE_CUSTOMER WHERE CUSTOMER_EMAIL LIKE '%@gmail.com' AND CUSTOMER_PHONE LIKE '%77%';

USE HR;
# Q11. Write a query to Show the count of cities in all countries other than US & UK, with more than 1 city, 
# in the descending  order of country id. (4 rows)[NOTE : LOCATION TABLE]
SELECT COUNTRY_ID, COUNT(CITY) FROM LOCATIONS GROUP BY COUNTRY_ID HAVING COUNTRY_ID NOT IN ('US','UK') AND COUNT(CITY)>1 ORDER BY COUNTRY_ID DESC;

