SELECT 'region' as table_name, COUNT(*) as row_count FROM region
UNION ALL
SELECT 'sales_reps', COUNT(*) FROM sales_reps  
UNION ALL
SELECT 'accounts', COUNT(*) FROM accounts
UNION ALL  
SELECT 'orders', COUNT(*) FROM orders
UNION ALL
SELECT 'web_events', COUNT(*) FROM web_events;
