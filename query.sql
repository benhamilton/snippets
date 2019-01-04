SET
	@USERNAME = 'Ben Hamilton',
	@STARTDATE = concat(date_add(curdate(), interval -1 day),' 00:00:00'),
	@ENDDATE = concat(curdate(),' 23:59:59'),
	@TZ = '+10:00';
SELECT
	`type`,
	`Username`,
	`Status`,
	`Subject`,
	`Date`
#	,
#	`Duration`,
#	`Description`,
#	`RecordID`,
#	`ParentType`,
#	`ParentRecordID`,
#	'Billable`, # add a billable column (add code for each section)
#	`BudgetAvailable`, 
	/* 
	add a column to show related Account prepaid amount available: meeting > case > account
	or if the meeting is related to a case related to a project: meeting > case > project
	then show related Project Budget Available
	*/
#	`Deleted`
FROM
	(select 
		'Meeting' as 'Type',
		concat_ws(' ', users.first_name, users.last_name  ) as 'Username',
		meetings.status as 'Status',
		meetings.name as 'Subject',
		convert_tz(meetings.date_start,'+00:00',@TZ) AS 'Date',
		"" as 'Duration',
		meetings.description as 'Description',
		meetings.id as 'RecordID',
		"" as 'ParentType',
		"" as 'ParentRecordID',
		meetings.deleted as 'Deleted'
	from users left join meetings on meetings.assigned_user_id = users.id
	UNION ALL
	select 
		'Meeting Attendee' as 'Type',
		concat_ws(' ', users.first_name, users.last_name  ) as 'Username',
		meetings.status as 'Status',
		meetings.name as 'Subject',
		convert_tz(meetings.date_start,'+00:00',@TZ) AS 'Date',
		"" as 'Duration',
		meetings.description as 'Description',
		meetings.id as 'RecordID',
		"" as 'ParentType',
		"" as 'ParentRecordID',
		meetings.deleted as 'Deleted'
	from users 
		left join meetings_users on meetings_users.user_id = users.id
		left join meetings on meetings.id = meetings_users.meeting_id
	where meetings.assigned_user_id <> meetings_users.user_id # remove rows where user is also the assigned user
		and meetings_users.deleted = '0'
	UNION ALL
	select 
		'Call' as 'Type',
		concat_ws(' ', users.first_name, users.last_name  ) as 'Username',
		calls.status as 'Status',
		calls.name as 'Subject',
		convert_tz(calls.date_start,'+00:00',@TZ) AS 'Date',
		"" as 'Duration',
		calls.description as 'Description',
		calls.id as 'RecordID',
		"" as 'ParentType',
		"" as 'ParentRecordID',
		calls.deleted as 'Deleted'
	from users left join calls on calls.assigned_user_id = users.id
	UNION ALL
		select 
		'Task' as 'Type',
		concat_ws(' ', users.first_name, users.last_name  ) as 'Username',
		tasks.status as 'Status',
		tasks.name as 'Subject',
		convert_tz(tasks.date_start,'+00:00',@TZ) AS 'Date',
		"" as 'Duration',
		tasks.description as 'Description',
		tasks.id as 'RecordID',
		"" as 'ParentType',
		"" as 'ParentRecordID',
		tasks.deleted as 'Deleted'
	from users left join tasks on tasks.assigned_user_id = users.id
	UNION ALL
		select 
		'Note' as 'Type',
		concat_ws(' ', users.first_name, users.last_name  ) as 'Username',
		'Created' as 'Status',
		notes.name as 'Subject',
		convert_tz(notes.date_entered,'+00:00',@TZ) AS 'Date',
		"" as 'Duration',
		notes.description as 'Description',
		notes.id as 'RecordID',
		"" as 'ParentType',
		"" as 'ParentRecordID',
		notes.deleted as 'Deleted'
	from users left join notes on notes.assigned_user_id = users.id
	UNION ALL
		select 
		'Email' as 'Type',
		concat_ws(' ', users.first_name, users.last_name  ) as 'Username',
		case
			when emails.status = 'sent' then 'Sent'
			when emails.status = 'read' then 'Read'
			when emails.status = 'archived' then 'Archived'
			when emails.status = 'draft' then 'Draft'
			when emails.status = 'unread' then 'Unread'
		end as 'Status',
		emails.name as 'Subject',
		convert_tz(emails.date_entered,'+00:00',@TZ) AS 'Date',
		"" as 'Duration',
		"" as 'Description',
		emails.id as 'RecordID',
		"" as 'ParentType',
		"" as 'ParentRecordID',
		emails.deleted as 'Deleted'
	from users left join emails on emails.assigned_user_id = users.id
) u

WHERE Username like @USERNAME
	and u.Date  >= @STARTDATE
	and u.Date  <= @ENDDATE
	and u.Deleted = '0'
ORDER BY Username ASC, u.Date ASC;