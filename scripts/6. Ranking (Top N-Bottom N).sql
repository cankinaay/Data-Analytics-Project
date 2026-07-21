-- which 5 products generate the highestr revenue
SELECT top 5
p.product_name,
SUM(s.sales_amount) total_Revenue
FROM gold.fact_sales s
LEFT JOIN gold.dim_products p
	ON  s.product_key=p.product_key
GROUP BY p.product_name
ORDER BY total_Revenue DESC

--	what are the 5 worst performing products in terms of sales?
SELECT top 5
p.product_name,
SUM(s.sales_amount) total_Revenue
FROM gold.fact_sales s
LEFT JOIN gold.dim_products p
	ON  s.product_key=p.product_key
GROUP BY p.product_name
ORDER BY total_Revenue ASC

--find the top 10 customers who have generated the highest revenue
SELECT
*
FROM(
SELECT
c.first_name,
c.last_name,
SUM(s.sales_amount) as total_Sales,
ROW_NUMBER() OVER (ORDER BY SUM(s.sales_amount) DESC ) AS rank_products
FROM gold.fact_sales s 
LEFT JOIN gold.dim_customers c
	ON s.customer_key=c.customer_key
GROUP BY c.first_name,c.last_name)t
WHERE rank_products <=10

--the 3 customers with the fewest order placed
SELECT TOP 3
c.customer_key,
c.first_name,
c.last_name,
COUNT(DISTINCT s.order_number) x
FROM gold.fact_sales s 
LEFT JOIN gold.dim_customers c
	ON s.customer_key=c.customer_key
GROUP BY c.customer_key,c.first_name,c.last_name
ORDER BY x asc
