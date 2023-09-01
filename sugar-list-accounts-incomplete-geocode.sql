/* SugarCRM list Accounts that have a client_type_c value and incomplete geocode */
select
  a.id,
  a.name,
  a.geocode_status,
  ac.client_type_c,
  concat_ws('','https://evolutioncrm.sugarondemand.com/#Accounts/',id) as link
from 
  accounts a
  left join accounts_cstm ac ON ac.id_c = a.id
where 
  ac.client_type_c is not null
  and a.geocode_status != 'COMPLETED'
order by
  ac.client_type_c ASC;
