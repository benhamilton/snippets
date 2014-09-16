/* 
  Summary: Show what contact records a user has edited in SugarCRM
  Note: modify timezone values (plural) as required
  Note: modify where clause dates and username
*/
select 
	convert_tz(c_a.date_created,'+00:00','+10:00') as 'Date Edited',	
	u.user_name as 'Username',
	case c.deleted WHEN '0' THEN (concat_ws(' ',c.first_name,c.last_name)) WHEN '1' THEN (concat_ws(' ',c.first_name,c.last_name,' (deleted)')) ELSE NULL END as 'Contact Record Edited',
	c_a.field_name as 'Field Name',
	case c_a.data_type 
		when 'varchar' then c_a.before_value_string 
		when 'date' then c_a.before_value_string 
		when 'enum' then c_a.before_value_string 
		when 'team_list' then c_a.before_value_string
		when 'id' then c_a.before_value_string
		when 'url' then c_a.before_value_string
		when 'bool' then c_a.before_value_string
		when 'phone' then c_a.before_value_string
		when 'multienum' then c_a.before_value_string
		when 'text' then c_a.before_value_text 
	ELSE c_a.before_value_string END as 'Before Value',
	case c_a.data_type 
		when 'varchar' then c_a.after_value_string 
		when 'date' then c_a.after_value_string 
		when 'enum' then c_a.after_value_string 
		when 'team_list' then c_a.after_value_string
		when 'id' then c_a.after_value_string
		when 'url' then c_a.after_value_string
		when 'bool' then c_a.after_value_string
		when 'phone' then c_a.after_value_string
		when 'multienum' then c_a.after_value_string
		when 'text' then c_a.after_value_text 
	ELSE c_a.before_value_string END as 'After Value'
from 
	contacts_audit c_a 
	join users u on c_a.created_by = u.id
	join contacts c on c_a.parent_id = c.id
where
	convert_tz(c_a.date_created,'+00:00','+10:00') > '2014-01-01'
	and convert_tz(c_a.date_created,'+00:00','+10:00') < '2014-01-31'
	and u.user_name = 'john.doe'
	order by c_a.date_created asc;
/*
	#future - yet to all all the c_a.data_type values into the case statements
	#future - add code to show the team names
	
	Tag #timezone #tz #utc #gmt #case 
*/

	
