SELECT
  id,
  file_synced_to_aws,
  file_size,
  filename,
  aws_file_url
FROM 
  notes
WHERE 
  file_synced_to_aws = '1'
  AND file_size > 0
  AND deleted = '0'
  AND date_entered > NOW() - INTERVAL 4 HOUR
ORDER BY 
  date_entered DESC
LIMIT 1000;
