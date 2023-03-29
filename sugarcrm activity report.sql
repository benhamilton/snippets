SELECT 
    Assigned_to AS 'Assigned To',
    start_date AS 'Start Date (UTC+10)',
    Type,
    Status,
    Subject,
    Duration,
    ParentType AS 'Parent Type',
    ParentName AS 'Parent Name',
    Activity_Type AS 'Activity Type',
    concat(’https://XXXXXXXXXXX.sugarondemand.com/#',Type,'s/',RecordID) as ‘Record Link’#',Type,'s/',RecordID) as 'Record Link'
    /* change XXXXXXXXXXX in line above to correct instance name */
FROM
    (SELECT 
        'Meeting' AS 'Type',
            CONCAT_WS(' ', users.first_name, users.last_name) AS 'Assigned_to',
            meetings.status AS 'Status',
            meetings.name AS 'Subject',
            CONVERT_TZ(meetings.date_start, '+00:00', '+10:00') AS 'start_date',
            (meetings.duration_hours * 60) + meetings.duration_minutes AS 'Duration',
            meetings.description AS 'Description',
            meetings.id AS 'RecordID',
            meetings.parent_type AS 'ParentType',
            meetings.parent_id AS 'ParentRecordID',
            meetings.deleted AS 'Deleted',
            meetings_cstm.idx_meeting_type_c AS 'Activity_Type',
            CASE
                WHEN meetings.parent_type = 'Accounts' THEN CONCAT(IFNULL(accounts.name, ''), ' / ', IFNULL(accounts.account_type, ''))
                WHEN meetings.parent_type = 'Contacts' THEN CONCAT(IFNULL(contacts.first_name, ''), ' ', IFNULL(contacts.last_name, ''), ' / ', IFNULL(contacts.title, ''))
                ELSE NULL
            END AS 'ParentName'
    FROM
        users
    LEFT JOIN meetings ON meetings.assigned_user_id = users.id
    left join meetings_cstm on meetings_cstm.id_c=meetings.id
    LEFT JOIN accounts ON accounts.id = meetings.parent_id
        AND accounts.deleted = 0
    LEFT JOIN contacts ON contacts.id = meetings.parent_id
        AND contacts.deleted = 0 UNION ALL SELECT 
        'Attended' AS 'Type',
            CONCAT_WS(' ', users.first_name, users.last_name) AS 'Assigned_to',
            meetings.status AS 'Status',
            meetings.name AS 'Subject',
            CONVERT_TZ(meetings.date_start, '+00:00', '+10:00') AS 'start_date',
            (meetings.duration_hours * 60) + meetings.duration_minutes AS 'Duration',
            meetings.description AS 'Description',
            meetings.id AS 'RecordID',
            meetings.parent_type AS 'ParentType',
            meetings.parent_id AS 'ParentRecordID',
            meetings.deleted AS 'Deleted',
             meetings_cstm.idx_meeting_type_c AS 'Activity_Type',
            CASE
                WHEN meetings.parent_type = 'Accounts' THEN CONCAT(IFNULL(accounts.name, ''), ' / ', IFNULL(accounts.account_type, ''))
                WHEN meetings.parent_type = 'Contacts' THEN CONCAT(IFNULL(contacts.first_name, ''), ' ', IFNULL(contacts.last_name, ''), ' / ', IFNULL(contacts.title, ''))
                ELSE NULL
            END AS 'ParentName'
    FROM
        users
    LEFT JOIN meetings_users ON meetings_users.user_id = users.id
    LEFT JOIN meetings ON meetings.id = meetings_users.meeting_id
	left join meetings_cstm on meetings_cstm.id_c=meetings.id
    LEFT JOIN accounts ON accounts.id = meetings.parent_id
        AND accounts.deleted = 0
    LEFT JOIN contacts ON contacts.id = meetings.parent_id
        AND contacts.deleted = 0
    WHERE
        meetings.assigned_user_id <> meetings_users.user_id
            AND meetings_users.deleted = '0' UNION ALL SELECT 
        'Call' AS 'Type',
            CONCAT_WS(' ', users.first_name, users.last_name) AS 'Assigned_to',
            calls.status AS 'Status',
            calls.name AS 'Subject',
            CONVERT_TZ(calls.date_start, '+00:00', '+10:00') AS 'start_date',
            (calls.duration_hours * 60) + calls.duration_minutes AS 'Duration',
            calls.description AS 'Description',
            calls.id AS 'RecordID',
            calls.parent_type AS 'ParentType',
            calls.parent_id AS 'ParentRecordID',
            calls.deleted AS 'Deleted',
            'Calls' as 'Activity_Type',
            CASE
                WHEN calls.parent_type = 'Accounts' THEN CONCAT(IFNULL(accounts.name, ''), ' / ', IFNULL(accounts.account_type, ''))
                WHEN calls.parent_type = 'Contacts' THEN CONCAT(IFNULL(contacts.first_name, ''), ' ', IFNULL(contacts.last_name, ''), ' / ', IFNULL(contacts.title, ''))
                ELSE NULL
            END AS 'ParentName'
    FROM
        users
    LEFT JOIN calls ON calls.assigned_user_id = users.id
    LEFT JOIN accounts ON accounts.id = calls.parent_id
        AND accounts.deleted = 0
    LEFT JOIN contacts ON contacts.id = calls.parent_id
        AND contacts.deleted = 0 UNION ALL SELECT 
        'Task' AS 'Type',
            CONCAT_WS(' ', users.first_name, users.last_name) AS 'Assigned_to',
            tasks.status AS 'Status',
            tasks.name AS 'Subject',
            CONVERT_TZ(tasks.date_start, '+00:00', '+10:00') AS 'start_date',
            '' AS 'Duration',
            tasks.description AS 'Description',
            tasks.id AS 'RecordID',
            tasks.parent_type AS 'ParentType',
            tasks.parent_id AS 'ParentRecordID',
            tasks.deleted AS 'Deleted',
             'Tasks' as 'Activity Type',
            CASE
                WHEN tasks.parent_type = 'Accounts' THEN CONCAT(IFNULL(accounts.name, ''), ' / ', IFNULL(accounts.account_type, ''))
                WHEN tasks.parent_type = 'Contacts' THEN CONCAT(IFNULL(contacts.first_name, ''), ' ', IFNULL(contacts.last_name, ''), ' / ', IFNULL(contacts.title, ''))
                ELSE NULL
            END AS 'ParentName'
    FROM
        users
    LEFT JOIN tasks ON tasks.assigned_user_id = users.id
    LEFT JOIN accounts ON accounts.id = tasks.parent_id
        AND accounts.deleted = 0
    LEFT JOIN contacts ON contacts.id = tasks.parent_id
        AND contacts.deleted = 0 UNION ALL SELECT 
        'Note' AS 'Type',
            CONCAT_WS(' ', users.first_name, users.last_name) AS 'Assigned_to',
            'N/A' AS 'Status',
            notes.name AS 'Subject',
            CONVERT_TZ(notes.date_entered, '+00:00', '+10:00') AS 'start_date',
            '' AS 'Duration',
            notes.description AS 'Description',
            notes.id AS 'RecordID',
            notes.parent_type AS 'ParentType',
            notes.parent_id AS 'ParentRecordID',
            notes.deleted AS 'Deleted',
            notes_cstm.note_type_c as 'Activity_Type',
            CASE
                WHEN notes.parent_type = 'Accounts' THEN CONCAT(IFNULL(accounts.name, ''), ' / ', IFNULL(accounts.account_type, ''))
                WHEN notes.parent_type = 'Contacts' THEN CONCAT(IFNULL(contacts.first_name, ''), ' ', IFNULL(contacts.last_name, ''), ' / ', IFNULL(contacts.title, ''))
                ELSE NULL
            END AS 'ParentName'
    FROM
        users
    LEFT JOIN notes ON notes.assigned_user_id = users.id
    left join notes_cstm on notes_cstm.id_c = notes.id
    LEFT JOIN accounts ON accounts.id = notes.parent_id
        AND accounts.deleted = 0
    LEFT JOIN contacts ON contacts.id = notes.parent_id
        AND contacts.deleted = 0 UNION ALL SELECT 
        'Email' AS 'Type',
            CONCAT_WS(' ', users.first_name, users.last_name) AS 'Assigned_to',
            emails.status AS 'Status',
            emails.name AS 'Subject',
            CONVERT_TZ(emails.date_entered, '+00:00', '+10:00') AS 'start_date',
            '' AS 'Duration',
            'N/A' AS 'Description',
            emails.id AS 'RecordID',
            emails_beans.bean_module AS 'ParentType',
            emails_beans.bean_id AS 'ParentRecordID',
            emails.deleted AS 'Deleted',
           'Emails' as 'Activity_Type',
            CASE
                WHEN emails_beans.bean_module = 'Accounts' THEN CONCAT(IFNULL(accounts.name, ''), ' / ', IFNULL(accounts.account_type, ''))
                WHEN emails_beans.bean_module = 'Contacts' THEN CONCAT(IFNULL(contacts.first_name, ''), ' ', IFNULL(contacts.last_name, ''), ' / ', IFNULL(contacts.title, ''))
                ELSE NULL
            END AS 'ParentName'
    FROM
        users
    LEFT JOIN emails ON emails.assigned_user_id = users.id
    LEFT JOIN emails_beans ON emails_beans.email_id = emails.id
    LEFT JOIN accounts ON accounts.id = emails_beans.bean_id
        AND accounts.deleted = 0
    LEFT JOIN contacts ON contacts.id = emails_beans.bean_id
        AND contacts.deleted = 0) u
WHERE
    start_date >= DATE_ADD(LAST_DAY(DATE_SUB(NOW(), INTERVAL 2 MONTH)),
        INTERVAL 1 DAY)
        AND start_date <= LAST_DAY(DATE_SUB(NOW(), INTERVAL 1 MONTH))
        AND u.Deleted = '0'
ORDER BY Assigned_to ASC , start_date ASC;

