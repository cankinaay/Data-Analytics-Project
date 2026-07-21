SELECT
YEAR(order_date) order_year,
MONTH(order_Date) AS order_month,
sum(sales_amount) as total_Sales,
COUNT(DISTINCT customer_key) total_customers,
SUM(quantity) AS total_quantity
FROM gold.fact_sales
WHERE order_Date IS NOT NULL
GROUP BY YEAR(order_Date),MONTH(order_Date) 
ORDER BY YEAR(order_Date),MONTH(order_Date) 	