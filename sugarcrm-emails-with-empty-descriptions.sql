-- sugar sometimes ends up with an email with an empty description
-- whilst sugar have figured out most, it's normally caused by a
-- mail server not following an RFC correctly
-- this query will give most recent 200 emails affected
-- do a mxtoolbox.com mx lookup, you may find a common mail server
-- at fault, lodge a case with sugar support
SELECT
    e.date_sent,
    et.email_id,
    et.description,
    et.deleted,
    ea.email_address
FROM
    emails_text et
    INNER JOIN emails e ON e.id = et.email_id
    INNER JOIN emails_email_addr_rel rel ON rel.email_id = e.id
    INNER JOIN email_addresses ea ON ea.id = rel.email_address_id
WHERE
    (et.description = '' OR et.description IS NULL)
    AND et.deleted = 0
ORDER BY
    e.date_sent DESC
LIMIT 200;
