// From https://sugarclub.sugarcrm.com/explore/help-forums/serve/f/sugar-serve-questions/5995/sql-advanced-reports 
SELECT 
  ops.name,
  opa.date_created,  
  opa.created_by, 
  opa.date_updated, 
  opa.field_name, 
  opa.data_type, 
  opa.before_value_string, 
  opa.after_value_string, 
  opa.before_value_text, 
  opa.after_value_text,
  opa.id, 
  opa.parent_id, 
  opa.event_id 
FROM 
  opportunities_audit AS opa
JOIN 
  opportunities AS ops ON (opa.parent_id = ops.id) 
WHERE 
  opa.date_created >= '2022-07-01 00:00:00'
GROUP BY 
  ops.name
ORDER BY 
  ops.name ASC,
  opa.date_created ASC;