# Set @ContactID = contact_id 

SET @ContactId := 'contact-id-goes-here';

UPDATE calls_contacts cc
SET cc.deleted = '0'
WHERE cc.contact_id = @ContactID;

UPDATE tasks t
SET t.deleted = '0'
WHERE t.contact_id = @ContactID;

UPDATE meetings_contacts mc
SET mc.deleted = '0'
WHERE mc.contact_id = @ContactID;
