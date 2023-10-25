/* count how many emails */
SELECT count(*) 
FROM emails;

/* count how many emails with subject that starts with ... */
SELECT count(*) 
FROM emails
WHERE name like "Email Sent : %";

/* Show some details of emails */
SELECT 
  id,
  date_entered,
  assigned_user_id,
  name,
  type,
  direction
FROM emails
WHERE name like "Email Sent : %"
LIMIT 100;

