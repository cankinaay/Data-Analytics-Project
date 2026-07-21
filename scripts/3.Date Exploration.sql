--Find the date of the first and last order.
-- How many years of sales avaible
SELECT
MIN(order_date) first_order_date,
MAX(order_date) last_orer_Date, 
DATEDIFF(MONTH, MIN(order_date),MAX(order_Date)) AS order_range_months
FROM gold.fact_Sales

--Find the youngest and oldest customer
SELECT
MAX(birthdate) AS youngest,
MIN(birthdate) AS oldest,
DATEDIFF(year,MIN(birthdate),GETDATE()) AS oldestage,
DATEDIFF(year,MAX(birthdate), GETDATE()) AS youngestage
FROM gold.dim_customers