-- restaurant database

.open restuarant.db

DROP TABLE menus;
DROP TABLE customers;
DROP TABLE members;
DROP TABLE invoices;
DROP TABLE restaurants;

--Create table menus
CREATE TABLE menus (
    menu_id int,
    menu_name text
);

INSERT INTO menus VALUES 
    (1001, 'pizza'),
    (1002, 'hotdog'),
    (1003, 'coke'),
    (1004, 'yogurt'),
    (1005, 'ice cream');

-- Create table customers
CREATE TABLE customers (
    cust_id int,
    cust_name text,
    memeber_id,
    gender text
);

INSERT INTO customers VALUES 
    (1, 'Por', 'M001', 'M'),
    (2, 'Alice', 'M002', 'F'),
    (3, 'James', 'M003', 'M'),
    (4, 'Peter', 'M004', 'M'),
    (5, 'Alex', 'M005', 'M');

-- Create table members
CREATE TABLE members (
    member_id text,
    member_add text
);

INSERT INTO members VALUES 
    ('M001', 'Thailand'),
    ('M002', 'England'),
    ('M003', 'USA'),
    ('M004', 'USA'),
    ('M005', 'Sweden');

-- Create table restaurants
CREATE TABLE restaurants (
    rest_id text,
    rest_name text,
    rest_location text, 
    region text
);

INSERT INTO restaurants VALUES 
    ('R001', 'Real Thai', 'Thailand', 'Asia'),
    ('R002', 'Hungry man', 'England', 'Europe'),
    ('R003', 'Best dessert', 'USA', 'North America'),
    ('R004', 'Oh wow', 'Japan', 'Asia'),
    ('R005', 'Baby food', 'Indonisia', 'Asia');

-- Create table invoices
CREATE TABLE invoices (
    transac_id int,
    invoice_date text,
    rest_id int,
    cust_id,
    menu_id int,
    total real
);

INSERT INTO invoices VALUES 
    (00001, '2021-01-01','R001', 4,1001, 50.75),
    (00002, '2021-02-11','R003', 1,1005, 72.25),
    (00003, '2021-02-12','R003', 5,1004, 25.25),
    (00004, '2021-03-11','R002', 1,1005, 15.25),
    (00005, '2021-05-31','R001', 5,1003, 17.50),
    (00006, '2021-06-05','R005', 5,1003, 16.25),
    (00007, '2021-09-17','R005', 1,1002, 10.25),
    (00008, '2021-10-04','R002', 1,1002, 11.25),
    (00009, '2021-11-15','R001', 4,1001, 11.25),
    (00010, '2021-12-01','R001', 3,1001, 15.25),
    (00011, '2021-12-08','R004', 5,1005, 12.25),
    (00012, '2021-12-09','R002', 5,1004, 22.25),
    (00013, '2021-12-10','R001', 1,1003, 10.25),
    (00014, '2022-01-11','R001', 2,1001, 11.75),
    (00015, '2022-02-12','R005', 1,1001, 50.25),
    (00016, '2022-02-12','R003', 1,1002, 87.25),
    (00017, '2022-02-16','R003', 2,1002, 16.25),
    (00018, '2022-03-03','R003', 3,1003, 90.25),
    (00019, '2022-04-01','R003', 3,1003, 14.25),
    (00020, '2022-04-08','R001', 3,1003, 12.50),
    (00021, '2022-05-09','R001', 4,1002, 11.25),
    (00022, '2022-05-03','R003', 2,1004, 19.25),
    (00023, '2022-05-07','R004', 1,1001, 90.25),
    (00024, '2022-05-10','R005', 1,1005, 17.25),
    (00025, '2022-06-01','R002', 2,1003, 23.25),
    (00026, '2022-06-09','R001', 4,1002, 74.25),
    (00027, '2022-07-03','R001', 5,1001, 11.25),
    (00028, '2022-10-15','R005', 5,1005, 13.25);

.mode box
.header on


--recheck tables
SELECT * FROM menus;
SELECT * FROM customers;
SELECT * FROM members;
SELECT * FROM restaurants;
SELECT * FROM invoices;

.print "Top 3 revenue restaurant in 2022"
SELECT 
    rest.rest_id,
    rest.rest_name,
    SUM(inv.total) AS total_rev
FROM invoices AS inv
JOIN restaurants AS rest 
ON inv.rest_id = rest.rest_id  
WHERE STRFTIME("%Y", invoice_date) = '2022'
GROUP BY 2
ORDER BY 3 DESC
LIMIT 3;


.print "Top spender in 2021"
WITH spender AS(
SELECT
    cus.cust_id,
    SUM(inv.total) AS spend_in_2021
FROM customers AS cus
JOIN invoices AS inv 
ON cus.cust_id = inv.cust_id
WHERE STRFTIME("%Y", invoice_date) = '2021'
GROUP BY 1   
)

SELECT 
    cus.cust_id,
    cus.cust_name,
    spe.spend_in_2021
FROM customers AS cus
JOIN spender AS spe 
ON cus.cust_id = spe.cust_id
ORDER BY spe.spend_in_2021 desc
LIMIT 1;

.print "Membeship status spending"

WITH cust_spend AS (
SELECT 
    cus.cust_id,
    cus.cust_name,
    SUM(inv.total) AS total_rev
FROM invoices as inv 
JOIN customers as cus ON inv.cust_id = cus.cust_id 
WHERE STRFTIME("%Y", invoice_date) BETWEEN '2021' AND '2022' 
GROUP BY 1
    )    

SELECT *,
    CASE WHEN total_rev < 100 THEN 'Silver'
         WHEN total_rev BETWEEN 100 AND 200 THEN 'Gold'
    ELSE 'Platinum'
    END AS membership
FROM cust_spend
ORDER BY total_rev DESC;

.print "YOY all menu"

SELECT 
    ROW_NUMBER() OVER(PARTITION BY invoice_date ),
    m.menu_name,
    SUM(i.total)
FROM invoices i 
JOIN menus m ON i.menu_id = m.menu_id 
   WHERE STRFTIME("%Y", invoice_date) = '2021'
    GROUP BY m.menu_name;

    
