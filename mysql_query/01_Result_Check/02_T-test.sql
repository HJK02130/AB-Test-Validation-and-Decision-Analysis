SELECT c.experiment_group,
      c.users,
      c.total_treated_users,
      c.total AS total_message,
      c.average AS average_message,
      ROUND((c.average - c.control_average) / SQRT((c.variance/c.users) + (c.control_variance/c.control_users)),4) AS t_stat,
      (1 - COALESCE(nd.value,1))*2 AS p_value
  FROM (
        SELECT *,
              MAX(CASE WHEN b.experiment_group = 'control_group' THEN b.users ELSE NULL END) OVER () AS control_users,
              MAX(CASE WHEN b.experiment_group = 'control_group' THEN b.average ELSE NULL END) OVER () AS control_average,
              MAX(CASE WHEN b.experiment_group = 'control_group' THEN b.total ELSE NULL END) OVER () AS control_total,
              MAX(CASE WHEN b.experiment_group = 'control_group' THEN b.variance ELSE NULL END) OVER () AS control_variance,
              MAX(CASE WHEN b.experiment_group = 'control_group' THEN b.stdev ELSE NULL END) OVER () AS control_stdev,
              SUM(b.users) OVER () AS total_treated_users
          FROM (
                SELECT sm.experiment_group,
                       COUNT(sm.user_id) AS users,
                       AVG(sm.ct_sm) AS average,
                       SUM(sm.ct_sm) AS total,
                       STDDEV(sm.ct_sm) AS stdev,
                       VARIANCE(sm.ct_sm) AS variance
                  FROM (
                        SELECT ex.user_id,
                               ex.experiment_group,
                               ex.occurred_at,
                               COUNT(e.event_name) as ct_sm
                        FROM experiments ex
                              INNER JOIN users u ON ex.user_id = u.user_id
                              LEFT JOIN events e
                                          ON ex.user_id = e.user_id
                                          AND e.occurred_at BETWEEN ex.occurred_at AND '2014-06-30 23:59:59'
                                          AND e.event_name = 'send_message' 
                        WHERE experiment = 'publisher_update'
                        GROUP BY ex.user_id, ex.experiment_group, ex.occurred_at
                       ) sm
                GROUP BY sm.experiment_group
              ) b
      ) c
  LEFT JOIN normal_distribution nd
            ON nd.score = ABS(ROUND((c.average - c.control_average)/SQRT((c.variance/c.users) + (c.control_variance/c.control_users)),3))