/*
  View the last 5000 records interacted with by users in SugarCRM
  excepting the 'admin' user due to lots of schedulerrun entries

*/
SELECT
	t.id AS 'id',
	t.date_modified AS 'UTC Datetime',
	u.user_name AS 'Username' ,
	u.last_login AS 'UTC Last Logged In',
	t.module_name AS 'Record Type' ,
	t.item_summary AS 'Record Name'
FROM
	tracker t
JOIN
	users u ON u.id = t.user_id
WHERE
	u.user_name <> 'admin' 
ORDER BY
	t.date_modified DESC
LIMIT 5000;