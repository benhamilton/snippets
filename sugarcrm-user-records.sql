/*
	View the last x number of records a user has viewed (may or may not have edited)
	modify the where clause with 
	1. correct UTC time zone i.e. +10:00 is Brisbane, +11:00 is Sydney
	2. correct dates to search between
	3. correct user_name
	4. update the max number of records to return
*/
select 
	t.id,
	t.module_name as 'module',
	t.item_summary as 'record_name',	
	t.date_modified as 'date'
from 
	tracker t
	join users on users.id = t.user_id
where
	convert_tz(t.date_modified,'+00:00','+10:00') > '2019-01-01'
	and convert_tz(t.date_modified,'+00:00','+10:00') < '2019-01-31'
	and users.user_name = 'Vicki'
	order by t.date_modified desc
	limit 1000;