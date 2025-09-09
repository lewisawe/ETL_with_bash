SELECT channel, COUNT(*) as event_count
FROM web_events
GROUP BY channel
ORDER BY event_count DESC;
