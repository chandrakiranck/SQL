create database ic3;
use ic3;

create table hired(
emp_id integer,
emp_name varchar(20),
state varchar(2),
constraint pk_hired primary key(emp_id)
);

create table department(
dept_id integer,
emp_id integer,
constraint pk_dept primary key(dept_id,emp_id)
);

create table salary(
emp_id integer,
dept_id integer,
salary float,
constraint pk_salary primary key(emp_id)
);

insert into hired values(1, 'Edwin', 'TN');
insert into hired values(2, 'Perk', 'OR');
insert into hired values(3, 'Abhi', 'AP');
insert into hired values(4, 'Arshad', 'KA');
SELECT * FROM HIRED;

INSERT INTO DEPARTMENT VALUES(2,2);
INSERT INTO DEPARTMENT VALUES(1,1);
INSERT INTO DEPARTMENT VALUES(1,3);
SELECT * FROM DEPARTMENT;

INSERT INTO SALARY VALUES(1,1,25000);
INSERT INTO SALARY VALUES(2,2,30000);
INSERT INTO SALARY VALUES(3,1,50000);
INSERT INTO SALARY VALUES(4,NULL,NULL);
SELECT * FROM SALARY;

# 1. Write a query to display the dept_id, emp_name, state and salary of only those employees who  have  been assigned a department.
SELECT S.DEPT_ID, H.EMP_NAME, H.STATE, S.SALARY
FROM HIRED H, SALARY S 
WHERE H.EMP_ID=S.EMP_ID 
    AND S.DEPT_ID IS NOT NULL;

# 2. Write a query to display all the employee names and their salary,dept_id (irrespective of their assignment to a particular department). 
# Note : [emp_name,salary,dept_id]
SELECT H.EMP_NAME, S.SALARY, S.DEPT_ID
FROM HIRED H, SALARY S
WHERE H.EMP_ID=S.EMP_ID;

# 3. Write a query to display all the records of the department table and the respective employee names assigned to them . 
# Note : [dept_id,emp_name,salary]
SELECT d.dept_id, h.emp_name, s.salary
FROM hired h, department d, salary s
WHERE h.emp_id=d.emp_id AND h.emp_id=s.emp_id;

# 4. write a query to fetch all the distinct records of emp_id from hired & department table together.
SELECT DISTINCT EMP_ID
FROM HIRED NATURAL JOIN DEPARTMENT;

# 5. write a query to fetch all the records of emp_id from hired & department table. together.
SELECT EMP_ID FROM HIRED UNION ALL SELECT EMP_ID FROM DEPARTMENT;

# 6. write a query to display the emp_id,emp_name,salary ,state and whose salary greater than 20000 and belong’s to the state  ‘AP’
SELECT H.EMP_ID, H.EMP_NAME, S.SALARY, H.STATE
FROM HIRED H, SALARY S
WHERE H.EMP_ID=S.EMP_ID AND S.SALARY>20000 AND H.STATE='AP';

# 7. write a query to display the emp_id,emp_name,salary,state and whose salary greater than 10000 and less than 30000
#  and belongs to the state  ‘TN’,’OR’.
SELECT H.EMP_ID, H.EMP_NAME, S.SALARY, H.STATE
FROM HIRED H, SALARY S
WHERE H.EMP_ID=S.EMP_ID AND S.SALARY BETWEEN 10000 AND 30000  AND H.STATE IN ('TN','OR');

CREATE TABLE PRODUCT(
PRODUCT_ID VARCHAR(3),
PRODUCT_NAME VARCHAR(20),
PRICE FLOAT,
CONSTRAINT PK_PRODUCT PRIMARY KEY(PRODUCT_ID)
);

CREATE TABLE SALES(
SALES_ID INTEGER,
PRODUCT_ID VARCHAR(3),
CONSTRAINT PK_SALES PRIMARY KEY(SALES_ID,PRODUCT_ID)
);

CREATE TABLE ORDERS(
SALES_ID INTEGER,
CUST_ID INTEGER,
PRODUCT_ID VARCHAR(3),
ORDER_QUANTITY INTEGER,
ORDER_STATUS VARCHAR(20),
CONSTRAINT PK_ORDERS PRIMARY KEY(SALES_ID,CUST_ID)
);

CREATE TABLE CUSTOMER(
CUST_ID INTEGER,
FIRST_NAME VARCHAR(20),
LAST_NAME VARCHAR(20),
SALES_ID INTEGER,
CONSTRAINT PK_CUSTOMER PRIMARY KEY(CUST_ID)
);

INSERT INTO PRODUCT VALUES('P01','BISCUIT',10);
INSERT INTO PRODUCT VALUES('P02','CHOCOLATES',20);
INSERT INTO PRODUCT VALUES('P03','BREAD',15);
INSERT INTO PRODUCT VALUES('P04','BUTTER',30);
SELECT * FROM PRODUCT;

INSERT INTO SALES VALUES(2,'P02');
INSERT INTO SALES VALUES(1,'P01');
INSERT INTO SALES VALUES(1,'P03');
SELECT * FROM SALES;

INSERT INTO ORDERS VALUES(2,101,'P02',100,'Shipped');
INSERT INTO ORDERS VALUES(1,102,'P01',130,'shipped');
INSERT INTO ORDERS VALUES(1,103,'P03',25,'cancelled');
INSERT INTO ORDERS VALUES(2,104,'P01',50,'cancelled');
SELECT * FROM ORDERS;

INSERT INTO CUSTOMER VALUES(101,'Harry','Dany',2);
INSERT INTO CUSTOMER VALUES(102,'Tom','Adein',1);
INSERT INTO CUSTOMER VALUES(103,'Marina','paul',1);
INSERT INTO CUSTOMER VALUES(104,'peter','kevin',2);
INSERT INTO CUSTOMER VALUES(105,'David','warner',NULL);
SELECT * FROM CUSTOMER;

# 8. write a query to display cust_id,full name along with total quantity of products ordered for sales ids greater than 1 
# and order_status is cancelled. [Note : cust_id,fullname(firstname lastname),order_quantity,sales_id,order_status]
SELECT C.CUST_ID,CONCAT(C.FIRST_NAME,' ',C.LAST_NAME) AS FULLNAME, O.ORDER_QUANTITY,O.SALES_ID,O.ORDER_STATUS
FROM CUSTOMER C, ORDERS O
WHERE C.SALES_ID=O.SALES_ID AND C.SALES_ID>1 AND O.ORDER_STATUS='cancelled';

# 9. Write a query to Show distinct records of customer_id, full name and total order value of premium customers 
# (i.e. the customers who bought items total worth greater than RS.1000 ) [NOTE:  customer_id,fullname (Firstname Lastname),total(orderquantity*price)]
SELECT C.CUST_ID,CONCAT(C.FIRST_NAME,' ',C.LAST_NAME) AS FULLNAME, O.ORDER_QUANTITY*P.PRICE
FROM CUSTOMER C, ORDERS O, PRODUCT P
WHERE C.CUST_ID=O.CUST_ID AND O.PRODUCT_ID=P.PRODUCT_ID AND O.ORDER_QUANTITY*P.PRICE>1000;

# 10. write a query to display the List out customers who haven’t bought any ‘bread’ or ‘butter’.
# [NOTE:cust_id,full name(first_name last_name),sales_id,order_status,product_name]
SELECT C.CUST_ID, CONCAT(C.FIRST_NAME,' ',C.LAST_NAME) AS FULLNAME, O.SALES_ID, O.ORDER_STATUS, P.PRODUCT_NAME
FROM CUSTOMER C, ORDERS O, PRODUCT P
WHERE C.CUST_ID=O.CUST_ID AND O.PRODUCT_ID=P.PRODUCT_ID AND P.PRODUCT_NAME NOT IN ('BREAD','BUTTER');