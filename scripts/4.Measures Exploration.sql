--Find the total sales
SELECT
SUM(sales_amount) AS total_sales
FROM gold.fact_Sales

--How many items are sold
SELECT
SUM(quantity) total_quantity
FROM gold.fact_sales

--Find average selling price
SELECT
AVG(price) AS avg_price
FROM gold.fact_Sales
--Find total number of orders
SELECT DISTINCT
count(DISTINCT order_number) AS total_orders
FROM gold.fact_sales
--Find the total number of products
SELECT DISTINCT
COUNT(product_id) number_of_products
FROM gold.dim_products
-- Find the total number of customers
SELECT
COUNT(DISTINCT customer_id) total_number_customers
FROM gold.dim_customers
-- Find the total number of customer that has placed order
SELECT
COUNT(DISTINCT customer_key) AS total_customers
FROM gold.fact_sales

SELECT'Total_sales' AS measure_name, SUM(sales_amount) AS measure_Value FROM gold.fact_sales
UNION ALL
SELECT'Total_quantity' AS measure_name, SUM(quantity) AS measure_Value FROM gold.fact_sales
UNION ALL
SELECT'Average_price' AS measure_name, AVG(price) AS measure_Value FROM gold.fact_sales
UNION ALL
SELECT'Total_orders' AS measure_name, COUNT(DISTINCT order_number) AS measure_Value FROM gold.fact_sales
UNION ALL
SELECT'number_of_products' AS measure_name, COUNT(product_id) AS measure_Value FROM gold.dim_products
UNION ALL
SELECT'Total_number_customers' AS measure_name, COUNT(DISTINCT customer_id) AS measure_Value FROM gold.dim_customers
UNION ALL
SELECT'Total_customers' AS measure_name, COUNT(customer_key) AS measure_Value FROM gold.fact_sales