/* Q1 */
SELECT location_id, city FROM locations WHERE state_province IS NULL;

/* Q2 */
SELECT job_id,job_title,min_salary,max_salary FROM jobs WHERE max_salary>10000;

/* Q3 */
SELECT department_id,department_name,Manager_id FROM departments WHERE manager_id>200 AND location_id=2400;

/* Q4 */
SELECT job_title FROM jobs WHERE min_salary>8000 AND max_salary<20000;

/* Q5 */
SELECT * FROM departments WHERE manager_id IS NOT NULL AND location_id=1700;

/* Q6 */
SELECT product_id, product_desc, product_class_code, product_price FROM product WHERE product_class_code IN (2050,2053,2055);
 
/* Q7 */
SELECT customer_id, order_id, order_date, order_shipment_date FROM order_header ORDER BY customer_id, order_date DESC; 
 
/* Q8 */
SELECT * FROM product WHERE product_class_code=2050 AND product_price>=10000 AND product_price<=30000 AND product_quantity_avail>15;
 
/* Q9 */
SELECT * FROM order_header WHERE order_status!='Shipped';
 
/* Q10 */
SELECT * FROM order_header WHERE order_status='Shipped' AND payment_mode IN ('Credit Card','Net Banking') AND payment_date>'2013-01-01';