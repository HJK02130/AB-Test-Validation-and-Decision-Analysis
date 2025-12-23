SELECT experiment_group,
       COUNT(user_id) as users,
       AVG(cnt_send_message) as average,
       SUM(cnt_send_message) as total
FROM (
      SELECT ex.user_id, 
             ex.experiment_group,
             COUNT(e.event_name) as cnt_send_message
      FROM experiments ex
            INNER JOIN users u
                        ON ex.user_id = u.user_id
                        AND u.activated_at < '2014-06-01 00:00:00' -- 조건 추가
            LEFT JOIN events e
                        ON ex.user_id = e.user_id
                        AND e.occurred_at BETWEEN ex.occurred_at AND '2014-06-30 23:59:59'
                        AND e.event_name = 'send_message' 
      WHERE experiment = 'publisher_update'
      GROUP BY ex.user_id, ex.experiment, ex.experiment_group
      ) send_m_by_user
GROUP BY experiment_group