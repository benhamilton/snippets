/* MySQL to select and show duplicate CONTACTS in SugarCRM  */
SELECT 
	concat_ws(' ',first_name,last_name),
	phone_work,
	phone_mobile,
	deleted
FROM contacts
WHERE concat_ws(' ',first_name,last_name) IN (
	SELECT concat_ws(' ',first_name,last_name)
	FROM contacts
	WHERE deleted = 0
	GROUP BY concat_ws(' ',first_name,last_name)
	HAVING count(concat_ws(' ',first_name,last_name)) > 1)
ORDER BY concat_ws(' ',first_name,last_name), deleted
