/* Most important and relevant business Questions answered */ 

/*Question 1 What is the total revenue (GMV) of the platform?
Business Meaning:
   How much money did the platform generate from delivered orders? */
SELECT 
	cast(round(SUM(total_amount),2) as decimal (10,2)) as total_gmv
from orders
where order_status = 'Delivered';

/*Q2. What is the Average Order Value (AOV)?
   Business Meaning:
   How much does a typical customer spend per order? */
   SELECT 
	cast(round(avg(total_amount),2) as decimal (10,2)) as aov
from orders
where order_status = 'Delivered'; 

/*Q3. What percentage of orders are returned?
   Business Meaning:
   How serious is the returns problem operationally? */
SELECT 
	cast(Round(100.0 * sum(case
	when order_status = 'Returned' then 1 else 0 end) / count(*) ,2) as decimal(10,2)) as return_percent
	from orders;

 /*Q4. What percentage of orders are cancelled?
   Business Meaning:
   How much revenue is lost before delivery? */

SELECT
	cast(Round(100.0 * sum(case
	when order_status = 'Cancelled' then 1 else 0 end) / count(*) ,2) as decimal(10,2)) as cancel_percent
	from orders;

 /*Q5. What percentage of customers pay using COD?
   Business Meaning:
   How dependent is the business on Cash on Delivery?
   */

SELECT
	cast(Round(100.0 * sum(case
	when payment_method = 'COD' then 1 else 0 end) / count(*) ,2) as decimal(10,2)) as COD_percent
	from orders;

 /* Q6. What percentage of customers are repeat buyers?
   Business Meaning:
   How strong is customer loyalty? */

with customer_orders as (
	Select 
		customer_id,
		count(*) as order_count
		from orders
		where order_status = 'Delivered' 
		group by customer_id)
SELECT
	cast(Round(100.0 * sum(case
	when order_count>1  then 1 else 0 end) / count(*) ,2) as decimal(10,2)) as repeat_customer_percent
	from customer_orders;

/* Q7. How does revenue trend month by month?
   Business Meaning:
   Is the business growing or stagnating? */
   
SELECT 
	Format(order_date , 'yyyy-MM') as month,
	Sum(total_amount) as monthly_revenue
from orders 
where order_status = 'Delivered' 
group by Format(order_date , 'yyyy-MM')
order by month;

/* Q8. What is the month-over-month (MoM) revenue growth?
   Business Meaning:
   Are we accelerating or slowing down? */

with monthly as(
	SELECT 
	Format(order_date , 'yyyy-MM') as month,
	Sum(total_amount) as revenue
from orders 
where order_status = 'Delivered' 
group by Format(order_date , 'yyyy-MM')
)
SElECT
	month,
	revenue,
	Lag(revenue) over (order by month) as prev_month_revenue,
	cast(round(100.0*(revenue-lag(revenue) over (order by month))/
	Lag(revenue) over (order by month) ,2 ) as decimal(10,2)) as mom_growth_percent
from monthly;

   /*Q9. Which product categories generate the most revenue?
   Business Meaning:
   Where should we focus inventory and marketing?*/

Select 
	p.category,
	cast(sum(oi.quantity * oi.price_sold) as decimal(10,2)) as category_revenue
from order_items oi
join orders o 
on oi.order_id = o.order_id
join products p
on oi.product_id = p.product_id
where o.order_status = 'Delivered' 
group by p.category
order by category_revenue desc;

/* Q10. What are the top 10 highest-revenue products?
   Business Meaning:
   Which SKUs drive the most money? */

Select 
	top 10 
	p.product_name,
	cast(sum(oi.quantity * oi.price_sold) as decimal(10,2)) as revenue
from order_items oi
join orders o
on oi.order_id = o.order_id
join products p 
on oi.product_id = p.product_id
where o.order_status = 'Delivered' 
group by p.product_name
order by revenue desc;

/* Q11. Which states generate the most revenue?
   Business Meaning:
   Where should logistics and marketing be strengthened? */ 
Select 
	state ,
	cast(sum(total_amount)as decimal(10,2)) as revenue 
from orders
where order_status = 'Delivered'
group by state 
order by revenue Desc;

/*Q12. What amount of revenue do the  top 20% customers contribute ?
   Business Meaning:
   Is revenue concentrated among a small user base?*/

   With customer_revenue as (
	Select 
		customer_id ,
		sum(total_amount) as revenue 
	from orders
	where order_status = 'Delivered'
	group by customer_id),
	ranked as (
	Select 
		*,
		NTILE(5) over (order by revenue desc) as bucket
		from customer_revenue)
Select 
	cast(round(100.0 * sum (case when bucket =1 then revenue else 0 end)
	/ sum(revenue), 2) as decimal(10,2)) as top_20_contribution
from ranked;

/*   Q13. Who are the most valuable customers (CLV)?
   Business Meaning:
   Which customers generate the highest lifetime revenue? */ 

SELECT 
	customer_id,
	count(order_id) as total_orders ,
	Sum(total_amount) as total_revenue,
	cast(Round(Avg(total_amount),2) as decimal(10,2)) as avg_order_value
from orders
where order_status = 'Delivered'
group by customer_id 
order by total_revenue Desc;

 /*Q14. What is the RFM segmentation of customers?
   Business Meaning:
   How do we segment customers by loyalty and value? */

WITH rfm_base as (
	SELECT 
		customer_id,
		Max(order_date) as last_order_date,
		count(order_id) as frequency,
		sum(total_amount) as monetary
	from orders	
	where order_status = 'Delivered'
	group by customer_id 
),
rfm_scores as (
	Select 
	* ,
	DateDiff(Day,last_order_date , GETDATE()) as recency_days,
	NTILE(5) over (ORDER BY DATEDIFF(DAY, last_order_date , GETDATE()) ASC) as r_score,
	NTILE(5) over (ORDER BY frequency DESC) as f_score ,
	NTILE(5) over (ORDER BY monetary DESC) as m_score
from rfm_base)
SELECT 
	customer_id,
	recency_days,
	frequency,
	monetary,
	r_score,
	f_score,
	m_score,
	CONCAT(r_score,f_score,m_score) as rfm_code
from rfm_scores;

/* Q15. What is monthly customer retention (cohort analysis)?
   Business Meaning:
   Do customers come back after their first purchase? */ 

With first_purchase as (
	Select 
		customer_id,
		Min(order_date) as first_order_date
		from orders
		where order_status = 'Delivered'
		group by customer_id
		),
cohort_base as (
	SELECT 
		o.customer_id,
		FORMAT(fp.first_order_date , 'yyyy-MM') as cohort_month,
		FORMAT(o.order_date , 'yyyy-MM') as order_month
		from orders o
		join first_purchase fp
			on o.customer_id = fp.customer_id
		where o.order_status = 'Delivered'),
	cohort_counts as ( 
		Select
			cohort_month,
			order_month,
			Count(Distinct customer_id) as active_customers
		from cohort_base
		group by cohort_month, order_month),
cohort_sizes as (
	select 
		cohort_month,
		count(distinct customer_id) as cohort_size
		from cohort_base
		group by cohort_month
		)
	Select 
		c.cohort_month,
		c.order_month,
		c.active_customers,
		s.cohort_size,
		cast(Round(100.0* c.active_customers / s.cohort_size ,2) as decimal(10,2)) as retention_percent
		from cohort_counts c
		join cohort_sizes s
			on c.cohort_month = s.cohort_month
		order by c.cohort_month , c.order_month;

/*    Q16. Which customers are at churn risk?
   Business Meaning:
   Who hasn’t ordered recently and may leave? */
   WITH churn_base as (
	SELECT 
		customer_id,
		MAX(order_date) as last_order_date,
		count(order_id) as total_orders,
		sum(total_amount) as total_revenue
	from orders
	where order_status = 'Delivered'
	group by customer_id
)
SELECT 
	customer_id ,
	DATEDIFF(DAY,last_order_date , GETDATE()) as days_since_last_order,
	total_orders,
	total_revenue,
	case 
	when DATEDIFF(DAY,last_order_date , GETDATE()) > 180 then 'High Risk'
	when DATEDIFF(DAY,last_order_date , GETDATE()) between 90 and 180 then ' Medium Risk '
	else 'Low Risk'
	end as churn_risk_segment
from churn_base;


/*    Q17. Which suppliers have the highest return rates?
   Business Meaning:
   Who is causing quality issues? */ 

   Select 
	p.supplier_id,
	count(case when o.order_status = 'Returned' then 1 end)*100.0 / 
	count(*) as return_rate
	from orders o
	join order_items oi 
		on o.order_id = oi.order_id
	join products p 
		on oi.product_id = p.product_id
	group by p.supplier_id
	order by return_rate DESC;

/*  Q18. What is the relationship between reviews and returns?
   Business Meaning:
   Does low rating correlate with returns? */ 
SELECT 
	r.rating,
	count(*) as review_count
from reviews r 
group by r.rating
order by r.rating;

/* Q19. Which product pairs are frequently bought together?
   Business Meaning:
   Can we do cross-sell and bundle offers? */ 
SELECT 
	oi1.product_id as product_a,
	oi2.product_id as product_b,
	count(*) as pair_count
from order_items oi1
join  order_items oi2 
 on oi1.order_id = oi2.order_id
 and oi1.product_id < oi2.product_id
 group by oi1.product_id , oi2.product_id
 order by pair_count desc;

 /*   Q20. Which customers generate the highest revenue share?
   Business Meaning:
   Should we prioritize VIP customers? */
SELECT 
	customer_id,
	sum(total_amount) as revenue 
from orders
where order_status = 'Delivered'
group by customer_id
order by revenue DESC;
