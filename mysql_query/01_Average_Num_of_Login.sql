SELECT experiment_group,
       COUNT(user_id) as users,
       AVG(cnt_login) as login_average,
       SUM(cnt_login) as login_total
FROM (
      SELECT ex.user_id, 
             ex.experiment_group,
             COUNT(CASE WHEN e.event_name = 'login' THEN e.user_id ELSE NULL END) AS cnt_login
      FROM experiments ex
            INNER JOIN users u ON ex.user_id = u.user_id
            LEFT JOIN events e
                        ON ex.user_id = e.user_id
                        AND e.occurred_at BETWEEN ex.occurred_at AND '2014-06-30 23:59:59'
      WHERE experiment = 'publisher_update'
      GROUP BY ex.user_id, ex.experiment_group
      ) send_m_by_user
GROUP BY experiment_group