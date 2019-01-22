/* 
source: http://dev.mysql.com/doc/refman/5.0/en/string-functions.html#function_replace 
note: it's case sensitive
*/
UPDATE contacts
SET description = REPLACE(description, 'Brisvegas', 'Brisbane');
