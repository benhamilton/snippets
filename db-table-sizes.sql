/* 
  here is the query to find out how many MB each table in the #sugarcrm #database consumes
*/
SELECT
TABLE_SCHEMA as "DBNAME",
  TABLE_NAME AS "Table",
  ROUND((DATA_LENGTH + INDEX_LENGTH) / 1024 / 1024) AS "Size (MB)"
FROM
  information_schema.TABLES
ORDER BY
  (DATA_LENGTH + INDEX_LENGTH)
DESC;