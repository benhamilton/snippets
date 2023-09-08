SELECT 
    CONCAT('<a href="https://evolutioncrm.sugarondemand.com/#Opportunities/', o.id, '">', o.name, '</a><br/>') AS link
FROM
    opportunities o
    LEFT JOIN calls c ON c.parent_id = o.id AND (c.status = 'Planned' OR (c.status <> 'Planned' AND c.date_start < CURDATE()))
WHERE
    (c.parent_id IS NULL OR (c.status <> 'Planned' AND c.date_start < CURDATE()))
    AND o.sales_stage NOT IN ('Closed Won', 'Closed Lost')
    AND o.deleted = 0
ORDER BY
    o.date_closed DESC;
