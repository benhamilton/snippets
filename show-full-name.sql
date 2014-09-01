SELECT
	LTRIM(
		RTRIM(
			CONCAT_WS(' ',
				IFNULL(contacts.salutation, ''),
				IFNULL(contacts.first_name, ''),
				IFNULL(contacts.last_name, '')
			)
		)
	) as 'Full Name'
	
FROM 
	contacts
WHERE 
	contacts.deleted = '0';