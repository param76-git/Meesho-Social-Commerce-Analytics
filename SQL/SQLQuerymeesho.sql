

use Meesho_Project

--Checking Nulls in [dbo].[customers]


select * from [dbo].[customers]

select * from [dbo].[customers]
where customer_id is null

select * from [dbo].[customers]
where customer_name is null

select * from [dbo].[customers]
where city is null

select * from [dbo].[customers]
where state is null

select * from [dbo].[customers]
where signup_date is null

-- No nulls found

--Checking nulls in [dbo].[order_items]

select * from [dbo].[order_items]

select * from [dbo].[order_items]
where order_item_id is null

select * from [dbo].[order_items]
where order_id is null

select * from [dbo].[order_items]
where product_id is null

select * from [dbo].[order_items]
where quantity is null

select * from [dbo].[order_items]
where price_sold is null

-- No nulls found

-- Checking nulls in [dbo].[orders]

select * from [dbo].[orders]

select * from [dbo].[orders]
where order_id is null

select * from [dbo].[orders]
where customer_id is null

select * from [dbo].[orders]
where order_date is null

select * from [dbo].[orders]
where delivery_date is null    
/*delivery_date column Has 966 Nulls and 
these are the only nulls in corresponding rows*/

--verifying whether the NULLs belong only to non-delivered orders.
SELECT
order_status,
COUNT(*) AS orders,
COUNT(delivery_date) AS delivery_date_present,
COUNT(*) - COUNT(delivery_date) AS delivery_date_null
FROM orders
GROUP BY order_status;     

-- only Order_status = Cancelled has all the nulls

select * from [dbo].[orders]
where city is null

select * from [dbo].[orders]
where state is null

select * from [dbo].[orders]
where order_status is null

select * from [dbo].[orders]
where total_amount is null

select * from [dbo].[orders]
where payment_method is null

-- No nulls found in any other column

-- Checking nulls in [dbo].[products]

select * from [dbo].[products]

select * from [dbo].[products]
where product_id is null

select * from [dbo].[products]
where supplier_id is null

select * from [dbo].[products]
where product_name is null

select * from [dbo].[products]
where category is null

select * from [dbo].[products]
where subcategory is null

select * from [dbo].[products]
where cost_price is null

select * from [dbo].[products]
where mrp is null

select * from [dbo].[products]
where commission_percent is null

-- No nulls found

-- Checking nulls in [dbo].[returns]

select * from [dbo].[returns]

select * from [dbo].[returns]
where return_id is null

select * from [dbo].[returns]
where order_id is null

select * from [dbo].[returns]
where return_date is null

select * from [dbo].[returns]
where return_reason is null

select * from [dbo].[returns]
where refund_amount is null

-- No nulls found

-- Checking nulls in [dbo].[reviews]

select * from [dbo].[reviews]

select * from [dbo].[reviews]
where review_id is null

select * from [dbo].[reviews]
where order_id is null

select * from [dbo].[reviews]
where rating is null

select * from [dbo].[reviews]
where review_date is null

-- No nulls found

-- Checking nulls in [dbo].[suppliers]

select * from [dbo].[suppliers]

select * from [dbo].[suppliers]
where supplier_id is null

select * from [dbo].[suppliers]
where supplier_name is null

select * from [dbo].[suppliers]
where city is null

select * from [dbo].[suppliers]
where state is null

select * from [dbo].[suppliers]
where registration_date is null

select * from [dbo].[suppliers]
where supplier_tier is null

select * from [dbo].[suppliers]
where avg_rating is null

select * from [dbo].[suppliers]
where quality_score is null

-- No nulls found

