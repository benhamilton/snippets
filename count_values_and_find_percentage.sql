/*
Needed to count how many records had one value and how many records had a second value.
Then want to know what percentage the first value was of the total. 
added 2014-05-26-21h33m
*/

SELECT
  SUM(IF(field_name = 'value_one',1,0)) AS 'Value One',
  SUM(IF(field_name = 'value_two',1,0)) AS 'Value Two',
  ROUND(SUM(IF(field_name = 'value_one',1,0)) / (SUM(IF(field_name = 'value_one',1,0)) + SUM(IF(field_name = 'value_two',1,0))) * 100) AS 'Percentage'
FROM table_name