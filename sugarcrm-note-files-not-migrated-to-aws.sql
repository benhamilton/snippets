/*
  return a count of how many files related to NOTES in #sugarcrm #database are not yet migrated to #aws
*/
select
  count(id) as 'Number of Note Files Not Yet Transferred to AWS S3'
from 
  notes
where 
  file_synced_to_aws = '0'
  and file_size > 0;