--segment products into cost ranges	and count how many products fall into each statement
/*WITH cost_range_table AS 
(SELECT
*,
CASE 
	WHEN cost>1000 THEN 'high'
	WHEN cost>500 THEN 'medium'
	WHEN cost>0 THEN 'low'
END as cost_range
FROM gold.dim_products
WHERE cost IS NOT NULL)
SELECT DISTINCT
cost_range,
COUNT(*) AS total_count
FROM cost_range_table
GROUP BY cost_range
*/

/* Group customers into three segments based on their spending behavior:
   - VIP: Customers with at least 12 months of history and spending more than €5,000.
   - Regular: Customers with at least 12 months of history but spending €5,000 or less.
   - New: Customers with a lifespan less than 12 months.
And find the total number of customers by each group.*/
WITH segment_table1 As 
(SELECT
c.customer_key,
SUM(sales_amount) as total_sales,
MIN(s.order_Date) as min_date,
MAX(s.order_date) AS max_date,
DATEDIFF(month,MIN(s.order_Date),MAX(s.order_date))AS lifespan
FROM gold.fact_sales s
LEFT JOIN gold.dim_customers c
	ON s.customer_key=c.customer_key
GROUP BY c.customer_key)
SELECT
customer_segment,
COUNT(customer_key) numberofcustomer
FROM(
SELECT
customer_key,
CASE
	WHEN lifespan>=12 AND total_sales>5000 THEN 'VIP'
	WHEN lifespan>=12 AND total_Sales<=5000 THEN'Regular'
	ELSE 'New'
END as customer_segment
FROM segment_table1
)T group BY customer_segment
ORDER BY numberofcustomer DESC
