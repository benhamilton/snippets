SELECT
	`Assigned to`,
	`Start Date (UTC+10)`,
	`Type`,
	`Status`,
	`Subject`,
	`Duration`,
	`ParentType`
FROM
	(select 
		'Meeting' as 'Type', # primary user/assigned to user
		concat_ws(' ', users.first_name, users.last_name  ) as 'Assigned to',
		meetings.status as 'Status',
		meetings.name as 'Subject',
		convert_tz(meetings.date_start,'+00:00','+10:00') AS 'Start Date (UTC+10)',
		(meetings.duration_hours * 60) + meetings.duration_minutes as 'Duration',
		meetings.description as 'Description',
		meetings.id as 'RecordID',
		meetings.parent_type as 'ParentType',
		meetings.parent_id as 'ParentRecordID',
		meetings.deleted as 'Deleted'
	from users 
		left join meetings on meetings.assigned_user_id = users.id
		left join meetings_cstm on meetings_cstm.id_c = meetings.id 
	UNION ALL
	select 
		'Attended' as 'Type', # where not the primary user but invited to meeting
		concat_ws(' ', users.first_name, users.last_name  ) as 'Assigned to',
		meetings.status as 'Status',
		meetings.name as 'Subject',
		convert_tz(meetings.date_start,'+00:00','+10:00') AS 'Start Date (UTC+10)',
		(meetings.duration_hours * 60) + meetings.duration_minutes as 'Duration',
		meetings.description as 'Description',
		meetings.id as 'RecordID',
		meetings.parent_type as 'ParentType',
		meetings.parent_id as 'ParentRecordID',
		meetings.deleted as 'Deleted'
	from users 
		left join meetings_users on meetings_users.user_id = users.id
		left join meetings on meetings.id = meetings_users.meeting_id
	where meetings.assigned_user_id <> meetings_users.user_id 
		and meetings_users.deleted = '0'
	UNION ALL
	select 
		'Call' as 'Type',
		concat_ws(' ', users.first_name, users.last_name  ) as 'Assigned to',
		calls.status as 'Status',
		calls.name as 'Subject',
		convert_tz(calls.date_start,'+00:00','+10:00') AS 'Start Date (UTC+10)',
		(calls.duration_hours * 60) + calls.duration_minutes as 'Duration',
		calls.description as 'Description',
		calls.id as 'RecordID',
		calls.parent_type as 'ParentType',
		calls.parent_id as 'ParentRecordID',
		calls.deleted as 'Deleted'
	from users left join calls on calls.assigned_user_id = users.id
	UNION ALL
		select 
		'Task' as 'Type',
		concat_ws(' ', users.first_name, users.last_name  ) as 'Assigned to',
		tasks.status as 'Status',
		tasks.name as 'Subject',
		convert_tz(tasks.date_start,'+00:00','+10:00') AS 'Start Date (UTC+10)',
		'' as 'Duration',
		tasks.description as 'Description',
		tasks.id as 'RecordID',
		tasks.parent_type as 'ParentType',
		tasks.parent_id as 'ParentRecordID',
		tasks.deleted as 'Deleted'
	from users left join tasks on tasks.assigned_user_id = users.id
) u

WHERE 
	`Start Date (UTC+10)` >= DATE_ADD(LAST_DAY(DATE_SUB(NOW(), INTERVAL 2 MONTH)), INTERVAL 1 DAY)
	AND `Start Date (UTC+10)` <= LAST_DAY(DATE_SUB(NOW(), INTERVAL 1 MONTH))
	AND u.Deleted = '0'

ORDER BY `Assigned to` ASC, `Start Date (UTC+10)` ASC;
