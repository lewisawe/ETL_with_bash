SELECT a.name, SUM(o.total_amt_usd) as total_sales
FROM accounts a
JOIN orders o ON a.id = o.account_id
GROUP BY a.name
ORDER BY total_sales DESC
LIMIT 10;
