SELECT DATE_FORMAT(u.activated_at, '%Y-%m') AS month,
       COUNT(CASE WHEN e.experiment_group = 'control_group' THEN u.user_id END) AS control_users,
       COUNT(CASE WHEN e.experiment_group = 'test_group' THEN u.user_id END) AS test_users
FROM experiments e
JOIN users u
  ON u.user_id = e.user_id
GROUP BY month
ORDER BY month;