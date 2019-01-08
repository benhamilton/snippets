/*
  source: https://community.sugarcrm.com/message/102788-re-add-missing-rows-for-cstm-tables?commentID=102788&et=watches.email.thread#comment-102788
  summary: if you add a custom table at a later date, 
  you could use a variation of this code to add matching 
  rows in the _cstm table for what exists in the initial 
  table
*/
insert into dvjxn_dealership_vehicle_jxn_cstm
(dvjxn_dealership_vehicle_jxn_cstm.id_c)
select distinct
(dvjxn_dealership_vehicle_jxn.id)
from dvjxn_dealership_vehicle_jxn
where NOT EXISTS (
    select dvjxn_dealership_vehicle_jxn_cstm.id_c
    from dvjxn_dealership_vehicle_jxn_cstm
    where dvjxn_dealership_vehicle_jxn.id = dvjxn_dealership_vehicle_jxn_cstm.id_c)
