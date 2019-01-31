select 
	a.id,
	a.type,
	a.module_name,
	a.data
	
from 
	audit_events a
where
	(a.module_name = 'Accounts'
	or a.module_name = 'Contacts'
	or a.module_name = 'Contacts'
	or a.module_name = 'Opportunities'
	or a.module_name = 'Notes'
	or a.module_name = 'Cases'
	or a.module_name = 'Calls'
	or a.module_name = 'Tasks'
	or a.module_name = 'Meetings')
	and convert_tz(a.date_created,'+00:00','+10:00') > '2019-01-01'
	and convert_tz(a.date_created,'+00:00','+10:00') < '2019-01-31'
	#and users.user_name = 'jane.doe'
	order by a.date_created desc
	limit 100;
/*
	hang this together with other modules, i.e. accounts_audit, contacts_audit etc and then join to users, to make more pretty if you need it
*/