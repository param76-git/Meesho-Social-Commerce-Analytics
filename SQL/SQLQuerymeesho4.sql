

--Validating Business Rules

--Invalid Quantity
SELECT *
FROM order_items
WHERE quantity <= 0;

--Invalid Price
SELECT *
FROM order_items
WHERE price_sold <= 0;

--Invalid Order Amount
SELECT *
FROM orders
WHERE total_amount <= 0;

--Cost > MRP
SELECT *
FROM products
WHERE cost_price > mrp;

--Invalid Rating
SELECT *
FROM reviews
WHERE rating NOT BETWEEN 1 AND 5;

--Delivery Before Order
SELECT *
FROM orders
WHERE delivery_date < order_date;

-- all the checks are giving 0 rows in output 