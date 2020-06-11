use hr;

SELECT first_name, department_id, job_id, salary
FROM employees
WHERE first_name = 'Peter';

SELECT employee_id, hire_date, DATE_FORMAT(hire_date, '%a %D %a %b-%Y') as joined_dt
FROM Employees;

select * from employees;

select curdate();

CREATE VIEW bonafied_ceft as
SELECT CONCAT('This is to certify that ',e.first_name,' ',e.last_name,' with emp no. ', e.employee_id,
' as joined our dept. ', d.department_name,' on ', date_format(hire_date, '%D of %M, %Y'),
'. (S)he has been working in our org since ', round(datediff(curdate(),hire_date)/365,2), ' years.') as certificate
FROM Employees e join departments d on e.department_id=d.department_id;

select * from bonafied_ceft;


SELECT employee_id,department_id,job_id,count(*) as empcount
FROM employees
GROUP BY department_id, job_id;

SELECT employee_id, department_id, job_id, count(*) over() as empcount
FROM employees;

SELECT employee_id, department_id, job_id, salary,
		count(*) over(PARTITION BY department_id) as empcount,
		sum(salary) over(PARTITION BY department_id) as sum_sal,
        ROUND((salary / sum(salary) over(PARTITION BY department_id))*100,2) as pct_salary
FROM employees;

SELECT employee_id, d.department_id, d.department_name, job_id, salary, empcount, sum_sal, pct_salary FROM
(
	SELECT employee_id, department_id, job_id, salary,
			count(*) over(PARTITION BY department_id) as empcount,
			sum(salary) over(PARTITION BY department_id) as sum_sal,
			ROUND((salary / sum(salary) over(PARTITION BY department_id))*100,2) as pct_salary
	FROM employees
) as sal_pct_table JOIN departments d
	ON sal_pct_table.department_id = d.department_id
WHERE pct_salary > 30;

SELECT * from 
(SELECT employee_id,salary,
		RANK() OVER(PARTITION BY department_id ORDER BY salary DESC) as sal_rank,
        DENSE_RANK() OVER(PARTITION BY department_id ORDER BY salary DESC) as sal_drank
FROM employees) as rank_tbl
WHERE sal_drank <= 3;

select 'hi';
select 'hi' from employees;

use orders;

# max qty of products, other than promotional product(id starts with 9999) fits in a given carton (say id 10)
select p.product_id, floor(carton10.vol/p.vol) as qty
from (select len*width*height as vol from carton where carton_id=10) as carton10,
	(select product_id, (len*width*height) as vol 
		from product 
        where (len*width*height) = (select min(len*width*height)
									from product
									where product_id not like '9999%'
										and len*width*height is not null)) as p;

# show id, desc and price of products that have the same price, other than the promotional products
select product_id, product_desc, product_price
from product
where product_price in (select product_price
						from product 
						where product_id not like '9999%'
						group by product_price
						having count(*)>1)
order by product_price;

# which class of products have been shipped highest to countries outside India other than USA? Also show the total value of those items
