SELECT c.experiment_group,
       c.users,
       c.total_treated_users,
       c.total AS total_message,
       c.average AS average_message,
       ROUND(
         (c.average - c.control_average)
         / SQRT((c.variance / c.users) + (c.control_variance / c.control_users))
       , 4) AS t_stat,
       (1 - COALESCE(nd.value, 1)) * 2 AS p_value
FROM (
    SELECT *,
           MAX(CASE WHEN b.experiment_group = 'control_group' THEN b.users END) OVER () AS control_users,
           MAX(CASE WHEN b.experiment_group = 'control_group' THEN b.average END) OVER () AS control_average,
           MAX(CASE WHEN b.experiment_group = 'control_group' THEN b.variance END) OVER () AS control_variance,
           SUM(b.users) OVER () AS total_treated_users
    FROM (
        SELECT sm.experiment_group,
               COUNT(sm.user_id) AS users,
               AVG(sm.ct_sm) AS average,
               SUM(sm.ct_sm) AS total,
               VARIANCE(sm.ct_sm) AS variance,
               STDDEV(sm.ct_sm) AS stdev
        FROM (
            SELECT ex.user_id,
                   ex.experiment_group,
                   COUNT(e.event_name) AS ct_sm
            FROM experiments ex
            INNER JOIN users u
              ON ex.user_id = u.user_id
             AND u.activated_at < '2014-06-01 00:00:00'
            LEFT JOIN events e
              ON ex.user_id = e.user_id
             AND e.occurred_at BETWEEN ex.occurred_at AND '2014-06-30 23:59:59'
             AND e.event_name = 'send_message'
            WHERE ex.experiment = 'publisher_update'
            GROUP BY ex.user_id, ex.experiment_group
        ) sm
        GROUP BY sm.experiment_group
    ) b
) c
LEFT JOIN normal_distribution nd
  ON nd.score = ABS(
       ROUND(
         (c.average - c.control_average)
         / SQRT((c.variance / c.users) + (c.control_variance / c.control_users))
       , 3)
     );
