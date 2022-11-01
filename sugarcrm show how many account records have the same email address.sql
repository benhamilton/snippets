// show how many account records have the same email address
SELECT 
    count(distinct accounts.id), email_addresses.email_address
FROM
    email_addr_bean_rel
        INNER JOIN
    accounts ON accounts.id = email_addr_bean_rel.bean_id
        AND accounts.deleted = 0
        INNER JOIN
    email_addresses ON email_addresses.id = email_addr_bean_rel.email_address_id
        AND email_addresses.deleted = 0
WHERE
    email_addr_bean_rel.bean_module = 'Accounts'
        AND email_addr_bean_rel.primary_address = 1
        AND email_addr_bean_rel.deleted = 0
group by email_addresses.email_address
order by count(distinct accounts.id) desc;