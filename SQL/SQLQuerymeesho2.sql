

-- Checking for duplicate order_id
SELECT
order_id,
COUNT(*) AS duplicate_count
FROM orders
GROUP BY order_id
HAVING COUNT(*) > 1;

/* Verified the orders table for duplicate records using SQL GROUP BY and 
HAVING clauses. No duplicate order_id values were found, confirming data integrity.*/

-- Check for duplicate customer_id
SELECT
customer_id,
COUNT(*) AS duplicate_count
FROM customers
GROUP BY customer_id
HAVING COUNT(*) > 1;

/* Verified the customers table for duplicate records using SQL GROUP BY and 
HAVING clauses. No duplicate customer_id values were found, confirming data integrity.*/

-- Check for duplicate product_id
SELECT
product_id,
COUNT(*) AS duplicate_count
FROM products
GROUP BY product_id
HAVING COUNT(*) > 1;

/* Verified the products table for duplicate records using SQL GROUP BY and 
HAVING clauses. No duplicate product_id values were found, confirming data integrity.*/

-- Check for duplicate supplier_id
SELECT
supplier_id,
COUNT(*) AS duplicate_count
FROM suppliers
GROUP BY supplier_id
HAVING COUNT(*) > 1;

/* Verified the suppliers table for duplicate records using SQL GROUP BY and 
HAVING clauses. No duplicate supplier_id values were found, confirming data integrity.*/

-- Check for duplicate return_id
SELECT
return_id,
COUNT(*) AS duplicate_count
FROM returns
GROUP BY return_id
HAVING COUNT(*) > 1;

/* Verified the returns table for duplicate records using SQL GROUP BY and 
HAVING clauses. No duplicate return_id values were found, confirming data integrity.*/

-- Check for duplicate review_id
SELECT
review_id,
COUNT(*) AS duplicate_count
FROM reviews
GROUP BY review_id
HAVING COUNT(*) > 1;

/* Verified the reviews table for duplicate records using SQL GROUP BY and 
HAVING clauses. No duplicate review_id values were found, confirming data integrity.*/