use hr;
SET SQL_MODE = ONLY_FULL_GROUP_BY;
SELECT department_id,count(employee_id) from employees where department_id is not null;
SELECT department_id,count(employee_id) from employees where department_id is not null GROUP BY department_id;

use orders;

select * from online_customer;
SELECT 
    customer_id,
    customer_fname,
    CASE customer_gender
        WHEN 'f' THEN 'female'
        WHEN 'm' THEN 'male'
        WHEN 't' THEN 'trans'
        ELSE customer_gender
    END AS gender
FROM
    online_customer;
    
SELECT product_id, product_desc, product_quantity_avail,
CASE
	WHEN product_quantity_avail < 10 THEN 'Low Stock'
    WHEN product_quantity_avail < 50 THEN 'Avg Stock'
    WHEN product_quantity_avail < 100 THEN 'Sufficient Stock'
END AS inventory_status
FROM product;

SELECT * from online_customer where customer_fname='JENNIFER';

# write a query to show discounts offered based on subtotal (qty*price) and subtotal after applying the discount
# subtotal	discount
# <500			5%
# <10000		10%
# <100000		12%
# >100000		15%

SELECT * from product;
SELECT * from order_items;

SELECT 
	i.order_id,
    p.product_desc, 
    p.product_price, 
    i.product_quantity,
    (i.product_quantity*p.product_price) as subtotal,
    CASE
		WHEN (i.product_quantity*p.product_price)<500 THEN 0.95*(i.product_quantity*p.product_price)
        WHEN (i.product_quantity*p.product_price)<10000 THEN 0.9*(i.product_quantity*p.product_price)
        WHEN (i.product_quantity*p.product_price)<100000 THEN 0.88*(i.product_quantity*p.product_price)
        ELSE 0.85*(i.product_quantity*p.product_price)
	END as discounted_subtotal
FROM order_items i INNER JOIN product p
	ON i.product_id = p.product_id;
    
# show customer details and their order summary of all foreign customers
# cust id, fullname, city, country, total qty of products

select * from online_customer;
select * from address;
select * from order_header;
select * from order_items;

SELECT 
    c.customer_id, 
    CONCAT(c.customer_fname,' ',c.customer_lname) as full_name, 
    a.city, 
    a.country, 
    SUM(i.product_quantity) AS total_quantity,
    SUM(i.product_quantity * p.product_price) as total_ord_value
FROM
    address a JOIN online_customer c
		ON a.address_id = c.address_id
	JOIN order_header h
		ON c.customer_id = h.customer_id
	JOIN order_items i
		ON h.order_id = i.order_id
	JOIN product p
		ON i.product_id = p.product_id
WHERE a.country != 'India'
    AND h.order_status = 'Shipped'
GROUP BY c.customer_id, c.customer_fname, c.customer_lname, a.city, a.country;

# same as before but show 0 for total qty for sutomers who have not placed any order
SELECT 
    c.customer_id, 
    CONCAT(c.customer_fname,' ',c.customer_lname) as full_name, 
    a.city, 
    a.country, 
    IFNULL(SUM(i.product_quantity),0) AS total_quantity,
    IFNULL(SUM(i.product_quantity * p.product_price),0) as total_ord_value
FROM
    address a LEFT JOIN online_customer c
		ON a.address_id = c.address_id
	LEFT JOIN order_header h
		ON c.customer_id = h.customer_id
        AND h.order_status = 'Shipped'
	LEFT JOIN order_items i
		ON h.order_id = i.order_id
	LEFT JOIN product p
		ON i.product_id = p.product_id
WHERE a.country != 'India'
	AND h.customer_id IS NULL
GROUP BY c.customer_id, c.customer_fname, c.customer_lname, a.city, a.country;

# display customers who live in the same locality

SELECT 
    c.customer_id,
    concat(c.customer_fname,  ' ', c.customer_lname) as full_name,
    a.address_line1,
    a.address_line2,
    a.city,
    a.pincode
FROM
    address a JOIN online_customer c 
		ON a.address_id = c.address_id
WHERE
    a.pincode IN (SELECT 
            pincode
        FROM
            address
        GROUP BY pincode
        HAVING COUNT(*) > 1);


use hr;
# display employees and their managers
select * from employees;
SELECT 
	e.employee_id,
    CONCAT(e.first_name,' ',e.last_name) as emp_name,
    e.manager_id,
    CONCAT(m.first_name,' ',m.last_name) as mgr_name
FROM 
	employees e LEFT JOIN employees m
		ON e.manager_id = m.employee_id;
        
# show peers (same dept and job) of Bruce Ernst
SELECT 
    p.employee_id, 
    CONCAT(p.first_name, ' ', p.last_name) AS emp_name,
    p.salary,
    e.salary
FROM
    employees e join employees p
		ON e.department_id = p.department_id
        AND e.job_id = p.job_id
WHERE
    CONCAT(e.first_name, ' ',e.last_name) = 'Bruce Ernst'
	AND CONCAT(p.first_name, ' ',p.last_name) != 'Bruce Ernst'
    AND p.salary > e.salary;
    
SELECT 
    employee_id, 
    CONCAT(first_name, ' ', last_name) AS emp_name,
    salary
FROM
    employees e
WHERE
	(department_id, job_id) = (SELECT department_id, job_id 
								FROM employees 
                                WHERE CONCAT(first_name, ' ',last_name) = 'Bruce Ernst')
    AND salary > (SELECT salary FROM employees WHERE CONCAT(first_name, ' ',last_name) = 'Bruce Ernst')
	AND CONCAT(first_name, ' ',last_name) != 'Bruce Ernst';
    
SELECT 
    employee_id, 
    CONCAT(first_name, ' ', last_name) AS emp_name,
    salary
FROM
    employees e
WHERE
	(department_id, job_id) IN (SELECT department_id, job_id 
								FROM employees 
                                WHERE first_name = 'Peter')
    AND salary > ANY (SELECT salary 
						FROM employees 
                        WHERE first_name = 'Peter')
	AND first_name != 'Peter';
                        
SELECT 
    employee_id, 
    CONCAT(first_name, ' ', last_name) AS emp_name,
    salary
FROM
    employees e
WHERE
	(department_id, job_id) IN (SELECT department_id, job_id 
								FROM employees 
                                WHERE first_name = 'Peter'
                                AND salary < e.salary)
	AND first_name != 'Peter';
    
SELECT employee_id, first_name, last_name, salary
FROM employees
WHERE salary = (SELECT max(salary) FROM employees)
	OR salary = (SELECT min(salary) FROM employees);
    
use orders;

SELECT * FROM product WHERE len=width and width=height;
SELECT * FROM product WHERE len=width or width=height or len=height;

# find product(s) with max volume
SELECT product_id, product_desc, (len*width*height) AS volume
FROM Product
WHERE (len*width*height) = (SELECT max(len*width*height) FROM Product);

# find carton(s) that are a optimum fit for the product with max volume
SELECT carton_id, (len*width*height) as volume 
FROM carton 
WHERE (len*width*height) = (SELECT min(len*width*height) FROM carton 
								WHERE (len*width*height) > (SELECT max(len*width*height) FROM Product));

SELECT SUM(p.len*p.width*p.height*i.product_quantity) as order_vol
FROM order_items i join product p
	ON i.product_id = p.product_id
WHERE i.order_id = 10001;

SELECT 
    carton_id, len, width, height, (len * width * height)
FROM
    carton c
WHERE
    len > (SELECT len FROM product p
			WHERE product_id = 201
				AND c.width > p.width
				AND c.height > p.height);


# for a given product (say 201) list all other products that were bought along with it

SELECT product_id, COUNT(*)
FROM order_items
WHERE
    order_id IN (SELECT order_id FROM order_items WHERE product_id = 201)
	AND product_id != 201
GROUP BY product_id
HAVING count(*) > 1;