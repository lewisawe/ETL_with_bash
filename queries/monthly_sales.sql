SELECT DATE_TRUNC('month', occurred_at) as month, SUM(total_amt_usd) as monthly_sales
FROM orders
GROUP BY month
ORDER BY month;
