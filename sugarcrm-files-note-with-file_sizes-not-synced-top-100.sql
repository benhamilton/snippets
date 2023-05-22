/*
  list notes with id and the size of the file for notes with files that are not sync'ed to AWS S3
*/
select 
  id, 
  file_size 
from 
  notes
where 
  file_size > 0
  and file_synced_to_aws = '0'
order by
  file_size desc
limit 100;