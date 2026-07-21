--calculate the total sales per month and the running total of sales over time
SELECT
orderdate,
totalsales,
SUM(totalsales) OVER( ORDER BY orderdate) AS runningsales,
AVG(avg_price) OVER(ORDER BY orderdate) AS movingavg
FROM(
SELECT
DATETRUNC(year,order_date) AS orderdate,
SUM(sales_amount) as totalsales,
AVG(price) AS avg_price
FROM gold.fact_sales
WHERE DATETRUNC(month,order_date) IS NOT NULL
GROUP BY dATETRUNC(year,order_date)
)t
