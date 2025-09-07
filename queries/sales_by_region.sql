SELECT r.name as region, COUNT(o.id) as order_count, SUM(o.total_amt_usd) as total_sales
FROM region r
JOIN sales_reps sr ON r.id = sr.region_id
JOIN accounts a ON sr.id = a.sales_rep_id
JOIN orders o ON a.id = o.account_id
GROUP BY r.name
ORDER BY total_sales DESC;
