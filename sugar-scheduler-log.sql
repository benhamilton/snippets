/* change the scheduler ID to show last 10 entries for the scheduler */
SELECT 
  id,
  name,
  date_entered,
  date_modified,
  execute_time,
  status,
  resolution,
  message,
  requeue,
  retry_count,
  failure_count,
  job_delay,
  percent_complete,
  rerun
FROM 
  job_queue
where
  scheduler_id = '2e2c01c4-27a9-11ea-a6ec-8cec4b2f3709'
order by 
  date_entered desc
limit 10;
