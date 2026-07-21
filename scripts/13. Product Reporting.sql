CREATE VIEW gold.report_customers AS
WITH base_query AS (
SELECT
s.order_number,
s.order_date,
s.customer_key,
s.sales_amount,
s.quantity,
p.product_key,
p.product_name,
p.category,
p.subcategory,
p.cost
FROM gold.fact_sales s
LEFT JOIN gold.dim_products p
	ON s.product_key=p.product_key
WHERE order_date IS NOT NULL)
, product_aggreagations AS(
SELECT
product_key,
product_name,
category,
subcategory,
cost,
SUM(sales_amount) AS total_sales,
SUM(quantity) AS total_quantity,
COUNT(DISTINCT customer_key) AS total_customers,
COUNT(DISTINCT order_number) AS total_orders,
MAX(order_date) AS last_order,
DATEDIFF(month, MIN(order_Date),MAX(order_date)) as lifespan,
AVG(CAST(sales_amount AS FLOAT)/NULLIF(quantity,0)) AS avg_selling_price
FROM base_query
GROUP BY
product_key,
product_name,
category,
subcategory,
cost)

SELECT
product_key,
product_name,
category,
subcategory,
cost,
last_order,
DATEDIFF(month,last_order,GETDATE()) recency_in_months,
CASE
	WHEN total_sales>50000 THEN'High Performer'
	WHEN total_sales>=10000 THEN 'Mid Range'
	ELSE 'Low Performer'
END AS product_segment,
lifespan,
total_orders,
total_sales,
total_quantity,
total_customers,
avg_selling_price,
CASE
	WHEN total_orders=0 THEN 0
	ELSE total_sales/total_orders
END AS average_order_revenue,
CASE
	WHEN lifespan=0 THEN 0
	ELSE total_sales/lifespan
END AS average_monthly_revenue
FROM product_aggreagations
