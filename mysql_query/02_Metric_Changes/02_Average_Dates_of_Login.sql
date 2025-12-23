SELECT experiment_group,
       COUNT(user_id) AS users,
       AVG(login_count) AS loginday_average,
       SUM(login_count) AS loginday_total
FROM (
    SELECT ex.user_id,
           ex.experiment_group,
           COUNT(DISTINCT DATE(e.occurred_at)) AS login_count
    FROM experiments ex
    INNER JOIN users u
        ON ex.user_id = u.user_id
    LEFT JOIN events e
        ON ex.user_id = e.user_id
       AND e.occurred_at BETWEEN ex.occurred_at AND '2014-06-30 23:59:59'
       AND e.event_type = 'engagement'
    WHERE ex.experiment = 'publisher_update'
    GROUP BY ex.user_id, ex.experiment_group
) login_by_user
GROUP BY experiment_group;