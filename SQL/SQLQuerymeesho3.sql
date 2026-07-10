
-- Validating Relationships

--Check1
SELECT *
FROM orders o
LEFT JOIN customers c
ON o.customer_id = c.customer_id
WHERE c.customer_id IS NULL;

--Check2
SELECT *
FROM order_items oi
LEFT JOIN orders o
ON oi.order_id = o.order_id
WHERE o.order_id IS NULL;

--Check3
SELECT *
FROM order_items oi
LEFT JOIN products p
ON oi.product_id = p.product_id
WHERE p.product_id IS NULL;

--Check4
SELECT *
FROM products p
LEFT JOIN suppliers s
ON p.supplier_id = s.supplier_id
WHERE s.supplier_id IS NULL;

--Check5
SELECT *
FROM reviews r
LEFT JOIN orders o
ON r.order_id = o.order_id
WHERE o.order_id IS NULL;

--Check6
SELECT *
FROM returns r
LEFT JOIN orders o
ON r.order_id = o.order_id
WHERE o.order_id IS NULL;

-- all the checks are giving 0 rows in output 

