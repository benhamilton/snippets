// sugarcrm show how many accounts have the same name but have a different value in field account_code
SELECT 
    name, group_concat(account_code), COUNT(id) AS Duplicates
FROM
    accounts
WHERE
    deleted = 0 and account_code!='' and account_code is not null
GROUP BY name 
HAVING COUNT(id) > 1
ORDER BY Duplicates DESC