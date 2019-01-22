/* extract all undeleted call records from sugarcrm */
select 
	calls.id as call_id,
	calls.name as call_name,
	calls.date_entered as call_date_entered,
	calls.date_modified as call_date_modified,
	cmu.user_name as call_modified_by_user,
	ccu.user_name as call_created_by_user,
	calls.description as call_description,
	calls.deleted as call_deleted,
	au.user_name as call_assigned_user,
	calls.duration_hours as call_duration_hours,
	calls.duration_minutes as call_duration_minutes,
	calls.date_start as call_date_start,
	calls.date_end as call_date_end,
	calls.parent_type as call_parent_type,
	pcon.first_name, 
	pcon.last_name,
	pcaa.name as contact_account_name,
	pacc.name as parent_account_name,
	calls.status as call_status,
	calls.direction as call_direction
from calls
left join calls_contacts on calls.id = calls_contacts.call_id
join users cmu on calls.modified_user_id = cmu.id
join users ccu on calls.created_by = ccu.id
join users au on calls.assigned_user_id = au.id
left join contacts pcon on calls.parent_id = pcon.id
left join accounts_contacts pca on pcon.id = pca.contact_id
left join accounts pcaa on pca.account_id = pcaa.id
left join accounts pacc on calls.parent_id = pacc.id
where calls.deleted = '0';