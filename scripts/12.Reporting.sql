/*
===============================================================================
Customer Report
===============================================================================

Purpose:
  - This report consolidates key customer metrics and behaviors.

Highlights:

1. Gathers essential fields such as names, ages, and transaction details.

2. Segments customers into categories (VIP, Regular, New) and age groups.

3. Aggregates customer-level metrics:
   - total orders
   - total sales
   - total quantity purchased
   - total products
   - lifespan (in months)

4. Calculates valuable KPIs:
   - recency (months since last order)
   - average order value
   - average monthly spend

===============================================================================
*/
CREATE VIEW gold.rep_customers AS
WITH base_query AS(
/*----------------------------------------------------------------------------
1) Base query: retrieves core columns from tables
------------------------------------------------------------------------------*/
SELECT
s.order_number,
s.product_key,
s.order_date,
s.sales_amount,
s.quantity,
c.customer_key,
c.customer_number,
CONCAT(c.first_name,' ',c.last_name) AS full_name,
DATEDIFF(year,c.birthdate,GETDATE()) as age
FROM gold.fact_sales s
LEFT JOIN gold.dim_customers c 
	ON s.customer_key=c.customer_key
WHERE order_date IS NOT NULL)
, customer_aggregation AS(
/*-------------------------------------------------------------
2)Customer Aggreagations: Summarizes key metrics at the customer level
---------------------------------------------------------------*/
SELECT
customer_key,
customer_number,
full_name,
age,
COUNT(DISTINCT order_number) AS total_orders,
SUM(sales_amount) AS total_sales,
SUM(quantity) AS total_quantity,
COUNT (DISTINCT product_key) AS total_products,
MAX(order_Date) AS lastorder,
DATEDIFF(month,MIN(order_date),MAX(order_date)) AS lifespan
FROM base_query
GROUP BY customer_key,customer_number,full_name,age
)
SELECT
customer_key,
customer_number,
full_name,
age,
CASE
	WHEN age<20 THEN'Under 20'
	WHEN age BETWEEN 20 AND 29 THEN'20-29'
	WHEN age BETWEEN 30 AND 29 THEN'30-39'
	WHEN age BETWEEN 40 AND 49 THEN'40-49'
	ELSE '50 AND ABOVE'
END AS age_group,
CASE
	WHEN lifespan>=12 AND total_sales>5000 THEN 'VIP'
	WHEN lifespan>=12 AND total_sales<5000 THEN 'Regular'
	ELSE'New'
END AS customer_segment,
lastorder,
DATEDIFF(month,lastorder,GETDATE()) AS recency,
total_orders,
total_sales,
total_quantity,
total_products,
lifespan,
-- Compute average over value(AVO)
CASE 
	WHEN total_orders=0 THEN 0
	else total_sales/total_orders
END AS avg_order_value,
--compute average monthly spend
CASE
	WHEN lifespan=0 THEN 0
	ELSE (total_sales/lifespan) 
END AS avg_monthly_spend
from customer_aggregation 



