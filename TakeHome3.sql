use orders;

# 1. Write a query to Display the product details (product_class_code, product_id, product_desc, product_price,) 
#	as per the following criteria and sort them in descending order of category:
# 	a.	If the category is 2050, increase the price by 2000
# 	b.	If the category is 2051, increase the price by 500
# 	c.	If the category is 2052, increase the price by 600.
# 	(60 ROWS)[NOTE:PRODUCT TABLE]

SELECT product_class_code, product_id, product_desc,
	CASE product_class_code 
        WHEN 2050 THEN product_price+2000
        WHEN 2051 THEN product_price +500
        WHEN 2052 THEN product_price +600
        ELSE product_price
	END AS 'Product Price'
FROM product
ORDER BY product_class_code DESC;

# 2. Write a Query to display the product description, product class description and product price of all products which are shipped.(168 rows)
# [NOTE : TABLE TO BE USED:PRODUCT_CLASS,PRODUCT, ORDER_ITEMS,ORDER_HEADER]

SELECT p.product_desc, pc.product_class_desc, p.product_price 
FROM product p, product_class pc, order_items oi, order_header oh 
WHERE p.product_class_code = pc.product_class_code
    AND p.product_id = oi.product_id 
    AND oi.order_id = oh.order_id
    AND oh.order_status = 'Shipped';

# 3. Write a query to display the customer_id,customer name, email and order details 
# (order id, product desc,product qty, subtotal(product_quantity * product_price)) for all customers even if they have not ordered any item.
# (225 ROWS) [NOTE : TABLE TO BE USED - online_customer, order_header, order_items, product]
SELECT oc.customer_id, 
       CONCAT(oc.customer_fname,' ', oc.customer_lname) AS fullname, 
       oc.customer_email, 
       o.order_id, 
       o.product_desc,
       o.product_quantity,
       o.subtotal 
FROM online_customer oc 
     LEFT JOIN 
     (SELECT oh.customer_id, 
             oh.order_id, 
             p.product_desc, 
             oi.product_quantity,
             oi.product_quantity * p.product_price AS subtotal
      FROM order_header oh, order_items oi, product p 
      WHERE oh.order_id = oi.order_id 
          AND oi.product_id = p.product_id) AS o
     ON oc.customer_id = o.customer_id;
    
# 4. Write a query to display the customer_id,customer full name ,city,pincode,and 
# order details (order id,order date, product class desc, product desc, subtotal(product_quantity * product_price)) 
# for orders shipped to cities whose pin codes do not have any 0s in them. Sort the output on customer name, order date and subtotal.(52 ROWS)
# [NOTE : TABLE TO BE USED - online_customer, address, order_header, order_items, product, product_class]
SELECT 
    oc.customer_id,
    CONCAT(oc.customer_fname, ' ', oc.customer_lname) AS fullname,
    a.city,
    a.pincode,
    oh.order_id,
    oh.order_date,
    pc.product_class_desc,
    p.product_desc,
    oi.product_quantity * p.product_price AS subtotal
FROM
    online_customer oc,
    address a,
    order_header oh,
    order_items oi,
    product p,
    product_class pc
WHERE
    oi.order_id = oh.order_id
        AND oh.customer_id = oc.customer_id
        AND oc.address_id = a.address_id
        AND oi.product_id = p.product_id
        AND p.product_class_code = pc.product_class_code
        AND CONVERT( pincode , CHAR) NOT LIKE '%0%'
ORDER BY fullname , order_date , subtotal;

# 5. Write a query to display (customer id,customer fullname,city) of customers from outside ‘Karnataka’ who haven’t bought any toys or books.
# (19 ROWS) [NOTE : TABLES TO BE USED – online_customer, address, order_header, order_items, product, product_class].

SELECT 
    oc.customer_id,
    CONCAT(oc.customer_fname, ' ', oc.customer_lname) AS fullname,
    a.city
FROM
    online_customer oc,
    address a
WHERE
    oc.address_id = a.address_id
        AND a.state != 'Karnataka'
        AND oc.customer_id NOT IN 
			(SELECT 
				oc.customer_id
			FROM
				online_customer oc,
				order_header oh,
				order_items oi,
				product p,
				product_class pc
			WHERE
				oi.order_id = oh.order_id
					AND oh.customer_id = oc.customer_id
					AND oi.product_id = p.product_id
					AND p.product_class_code = pc.product_class_code
					AND product_class_desc IN ('toys' , 'books')
			);

# Write a query to display  details (customer id,customer fullname,order id,product quantity) of customers 
# who bought more than ten (i.e. total order qty) products per order.
# (11 ROWS) [NOTE : TABLES TO BE USED - online_customer, order_header, order_items]

SELECT 
    oc.customer_id,
    CONCAT(oc.customer_fname, ' ', oc.customer_lname) AS fullname,
    oh.order_id,
    SUM(oi.product_quantity) AS total_quantity
FROM
    online_customer oc,
    order_header oh,
    order_items oi
WHERE
    oi.order_id = oh.order_id
        AND oh.customer_id = oc.customer_id
GROUP BY oi.order_id
HAVING SUM(oi.product_quantity) > 10;

# 7. Write a query to display the customer full name and total order value(product_quantity*product_price) 
# of premium customers (i.e. the customers who bought items total worth > Rs. 1 lakh.)(2 ROWS)
# [NOTE : TABLES TO BE USED – ONLINE_CUSTOMER,ORDER_HEADER,ORDER_ITEMS,PRODUCT]

SELECT 
    oc.customer_id,
    CONCAT(oc.customer_fname, ' ', oc.customer_lname) AS fullname,
    SUM(oi.product_quantity * p.product_price) AS total_order_value
FROM
    online_customer oc,
    order_header oh,
    order_items oi,
    product p
WHERE
    oi.product_id = p.product_id
        AND oi.order_id = oh.order_id
        AND oh.customer_id = oc.customer_id
GROUP BY oc.customer_id
HAVING total_order_value > 100000;

# 8. Write a query to display the customer id and cutomer full name of customers along with (product_quantity) as total quantity of products
# ordered for order ids > 10060.(6 ROWS) [NOTE : TABLES TO BE USED - online_customer, order_header, order_items]
SELECT 
    oc.customer_id,
    CONCAT(oc.customer_fname, ' ', oc.customer_lname) AS fullname,
    SUM(product_quantity) AS total_quantity
FROM
    online_customer oc,
    order_header oh,
    order_items oi
WHERE
    oi.order_id > 10060
        AND oi.order_id = oh.order_id
        AND oh.customer_id = oc.customer_id
GROUP BY oc.customer_id;

# 9. Write a query to display (product_class_desc, product_id, product_desc, product_quantity_avail ) 
# and Show inventory status of products as below as per their available quantity:
# a. For Electronics and Computer categories, if available quantity is < 10, show 'Low stock', 11 < qty < 30, show 'In stock', > 31, 
# show 'Enough stock'
# b. For Stationery and Clothes categories, if qty < 20, show 'Low stock', 21 < qty < 80, show 'In stock', > 81, show 'Enough stock'
# c. Rest of the categories, if qty < 15 – 'Low Stock', 16 < qty < 50 – 'In Stock', > 51 – 'Enough stock'
# For all categories, if available quantity is 0, show 'Out of stock'.
# (60  ROWS)[NOTE : TABLES TO BE USED – product, product_class].

SELECT 
    pc.product_class_desc,
    p.product_id,
    p.product_desc,
    p.product_quantity_avail,
    CASE
        WHEN
            pc.product_class_desc IN ('Electronics', 'Computer')
        THEN
            CASE
				WHEN p.product_quantity_avail = 0 THEN 'Out of stock'
                WHEN p.product_quantity_avail < 10 THEN 'Low stock'
                WHEN p.product_quantity_avail < 30 THEN 'In stock'
                ELSE 'Enough stock'
            END
        WHEN
            pc.product_class_desc IN ('Stationery', 'Clothes')
        THEN
            CASE
				WHEN p.product_quantity_avail = 0 THEN 'Out of stock'
                WHEN p.product_quantity_avail < 20 THEN 'Low stock'
                WHEN p.product_quantity_avail < 80 THEN 'In stock'
                ELSE 'Enough stock'
            END
        ELSE CASE
				WHEN p.product_quantity_avail = 0 THEN 'Out of stock'
				WHEN p.product_quantity_avail < 15 THEN 'Low stock'
				WHEN p.product_quantity_avail < 50 THEN 'In stock'
				ELSE 'Enough stock'
			END
    END AS inventory_status
FROM
    product_class pc,
    product p
WHERE
    pc.product_class_code = p.product_class_code;