-- analyze yearly performance of products by comparing each product's sales to both its average sales performance and the previous year's sales.
WITH yearly_product_sales AS (
SELECT
year(s.order_date) AS orderyear,
p.product_name,
sum(s.sales_amount) as current_sales 
FROM gold.fact_sales s 
LEFT JOIN gold.dim_products p
	ON s.product_key=p.product_key
WHERE order_Date IS NOT NULL
GROUP BY YEAR(s.order_date),p.product_name
)
SELECT
orderyear,
product_name,
current_sales,
AVG(current_Sales) OVER (PARTITION BY product_name) avg_sales,
current_sales- AVG(current_Sales) OVER (PARTITION BY product_name) AS diff_Avg,
CASE
	WHEN current_sales- AVG(current_Sales) OVER (PARTITION BY product_name)>0 THEN 'Above Avg'
	WHEN current_sales- AVG(current_Sales) OVER (PARTITION BY product_name)<0 THEN 'Below Avg'
	ELSE 'Avg'
END AS avg_change,
--Year over year analysis
LAG(current_sales) OVER (PARTITION BY product_name ORDER BY orderyear) AS py_sales,
current_sales-LAG(current_sales) OVER (PARTITION BY product_name ORDER BY orderyear) AS diff_py,
CASE
	WHEN current_sales-LAG(current_sales) OVER (PARTITION BY product_name ORDER BY orderyear)>0 THEN 'Increasing'
	WHEN current_sales- LAG(current_sales) OVER (PARTITION BY product_name ORDER BY orderyear)<0 THEN 'Decreasing'
	ELSE 'No change'
END AS py_change
FROM yearly_product_sales
ORDER BY product_name,orderyear
