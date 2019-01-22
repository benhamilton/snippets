/* extract all undeleted meetings from sugarcrm */
select 
	meetings.id as meeting_id,
	meetings.name as meeting_name,
	meetings.date_entered as meeting_date_entered,
	meetings.date_modified as meeting_date_modified,
	cmu.user_name as meeting_modified_by_user,
	ccu.user_name as meeting_created_by_user,
	meetings.description as meeting_description,
	meetings.deleted as meeting_deleted,
	au.user_name as meeting_assigned_user,
	meetings.duration_hours as meeting_duration_hours,
	meetings.duration_minutes as meeting_duration_minutes,
	meetings.date_start as meeting_date_start,
	meetings.date_end as meeting_date_end,
	meetings.parent_type as meeting_parent_type,
	pcon.first_name, 
	pcon.last_name,
	pcaa.name as contact_account_name,
	pacc.name as parent_account_name,
	meetings.status as meeting_status
from meetings
left join meetings_contacts on meetings.id = meetings_contacts.meeting_id
join users cmu on meetings.modified_user_id = cmu.id
join users ccu on meetings.created_by = ccu.id
join users au on meetings.assigned_user_id = au.id
left join contacts pcon on meetings.parent_id = pcon.id
left join accounts_contacts pca on pcon.id = pca.contact_id
left join accounts pcaa on pca.account_id = pcaa.id
left join accounts pacc on meetings.parent_id = pacc.id
where meetings.deleted = '0';