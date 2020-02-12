select 
  contact.fullname,
  email.address
from 
  ACT2019Demo.dbo.TBL_CONTACT contact 
  left outer join ACT2019Demo.dbo.TBL_EMAIL email on email.CONTACTID=contact.CONTACTID
WHERE email.address NOT LIKE '%_@_%'
/* get all contacts where the email address appears bogus */
