/*
  return a count of how many files related to NOTES in #sugarcrm #database that HAVE migrated to #aws
*/
select
  count(id) as 'Number of Note Files Transferred to AWS S3'
from 
  notes
where 
  file_synced_to_aws = '1'
  and file_size > 0;