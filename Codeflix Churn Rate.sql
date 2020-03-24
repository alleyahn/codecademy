WITH month AS 
(SELECT '2017-01-01' as first_day,
         '2017-01-31' as last_day
UNION
SELECT'2017-02-01' as first_day,
        '2017-02-28' as last_day
UNION
SELECT '2017-03-01' as first_day,
        '2018-03-31' as last_day),

cross_join AS
(SELECT *
 FROM subscriptions
CROSS JOIN month),

status AS
(SELECT id, first_day as month,
 CASE WHEN segment = 87 AND (subscription_start < first_day) AND
 (subscription_end > first_day
  OR subscription_end IS NULL)
 THEN 1 ELSE 0 END as is_active_87,
 CASE WHEN segment = 30 AND (subscription_start < first_day) AND
 (subscription_end > first_day
 OR subscription_end IS NULL)
 THEN 1 ELSE 0 END as is_active_30,
 CASE WHEN segment = 87 AND (subscription_end BETWEEN first_day AND last_day) THEN 1 ELSE 0 END AS is_canceled_87,
 CASE WHEN segment = 30 AND (subscription_end BETWEEN first_day AND last_day) THEN 1 ELSE 0 END AS is_canceled_30
FROM cross_join),

status_aggregate AS
(SELECT month, sum(is_active_87) as sum_active_87, 
 sum(is_active_30) as sum_active_30, 
 sum(is_canceled_87) as sum_canceled_87, 
 sum(is_canceled_30) as sum_canceled_30
FROM status
GROUP BY month)

SELECT month,
ROUND((1.0* sum_canceled_87 / sum_active_87),2) as 'Segment 87 Churn Rate', 
ROUND((1.0* sum_canceled_30 / sum_active_30),2) as 'Segment 87 Churn Rate'
from status_aggregate
GROUP BY month;

-- Segment 87 has lower churn rate (9%) compared to Segment 30 (37%)--
