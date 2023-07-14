select
  revenue_line_items.account_id AS rli_acct_id,
  opportunities.id AS rli_opp_id,
  CONCAT(
    "https://instance.sugarondemand.com/#Opportunities/",
    opportunities.id
  ) AS rli_opp_url,
  opportunities.name AS rli_opp_name,
  CONCAT(u2.first_name, " ", u2.last_name) AS rli_opp_owner,
  revenue_line_items.id AS rli_id,
  CONCAT(
    "https://instance.sugarondemand.com/#RevenueLineItems/",
    revenue_line_items.id
  ) AS rli_url,
  revenue_line_items.product_type AS rli_type,
  revenue_line_items.name AS rli_name,
  product_types.name AS rli_product_type,
  product_templates.name AS rli_product,
  CONCAT(u1.first_name, " ", u1.last_name) AS rli_owner,
  revenue_line_items.sales_stage AS rli_sales_stage,
  revenue_line_items.probability AS rli_probability,
  round(revenue_line_items.likely_case, 2) AS rli_likely_case,
  IF (
    revenue_line_items.currency_id = "-99",
    "AUD",
    currencies.iso4217
  ) AS rli_currency,
  revenue_line_items.base_rate AS rli_xe_rate,
  round(
    revenue_line_items.likely_case / revenue_line_items.base_rate,
    2
  ) AS rli_likely_aud,
  IF(
    revenue_line_items.renewal = 1,
    round(
      revenue_line_items.likely_case / revenue_line_items.base_rate,
      2
    ),
    round(
      (
        (
          revenue_line_items.likely_case / revenue_line_items.base_rate
        ) / 100
      ) * revenue_line_items.probability,
      2
    )
  ) AS rli_likely_aud_weighted,
  round(
    (
      (
        revenue_line_items.likely_case / revenue_line_items.base_rate
      ) / revenue_line_items.service_duration_value
    ) * CASE WHEN revenue_line_items.service_duration_unit = "year" THEN 1 WHEN revenue_line_items.service_duration_unit = "month" THEN 12 WHEN revenue_line_items.service_duration_unit = "day" THEN 365 END,
    2
  ) AS rli_likely_arr_aud,
  IF(
    revenue_line_items.renewal = 1,
    round(
      (
        (
          revenue_line_items.likely_case / revenue_line_items.base_rate
        ) / revenue_line_items.service_duration_value
      ) * CASE WHEN revenue_line_items.service_duration_unit = "year" THEN 1 WHEN revenue_line_items.service_duration_unit = "month" THEN 12 WHEN revenue_line_items.service_duration_unit = "day" THEN 365 END,
      2
    ),
    round(
      (
        (
          (
            (
              revenue_line_items.likely_case / revenue_line_items.base_rate
            ) / revenue_line_items.service_duration_value
          ) * CASE WHEN revenue_line_items.service_duration_unit = "year" THEN 1 WHEN revenue_line_items.service_duration_unit = "month" THEN 12 WHEN revenue_line_items.service_duration_unit = "day" THEN 365 END
        ) / 100
      ) * revenue_line_items.probability,
      2
    )
  ) AS rli_likely_arr_aud_weighted,
  CASE WHEN revenue_line_items.service = 0 THEN round(
    (
      revenue_line_items.likely_case / revenue_line_items.base_rate
    ),
    2
  ) WHEN revenue_line_items.service = 1 THEN (
    revenue_line_items.likely_case / revenue_line_items.base_rate
  ) / (
    DATEDIFF(
      revenue_line_items.service_end_date,
      revenue_line_items.service_start_date
    ) + 1
  ) END AS rli_likely_drr_aud,
  CASE WHEN revenue_line_items.service = 0 THEN round(
    (
      (
        revenue_line_items.likely_case / revenue_line_items.base_rate
      ) / 100
    ) * revenue_line_items.probability,
    2
  ) WHEN revenue_line_items.service = 1
  AND revenue_line_items.renewal = 1 THEN (
    revenue_line_items.likely_case / revenue_line_items.base_rate
  ) / (
    DATEDIFF(
      revenue_line_items.service_end_date,
      revenue_line_items.service_start_date
    ) + 1
  ) WHEN revenue_line_items.service = 1
  AND revenue_line_items.renewal = 0 THEN (
    (
      (
        revenue_line_items.likely_case / revenue_line_items.base_rate
      ) / (
        DATEDIFF(
          revenue_line_items.service_end_date,
          revenue_line_items.service_start_date
        ) + 1
      )
    ) / 100
  ) * revenue_line_items.probability END AS rli_likely_drr_aud_weighted,
  revenue_line_items.quantity AS rli_qty,
  revenue_line_items.renewal AS rli_renewal,
  revenue_line_items.service AS rli_service,
  CASE WHEN revenue_line_items.service = 0
  AND revenue_line_items_cstm.date_completion_c > revenue_line_items.date_closed THEN revenue_line_items_cstm.date_completion_c WHEN revenue_line_items.service = 0 THEN revenue_line_items.date_closed WHEN revenue_line_items.service = 1 THEN revenue_line_items.service_start_date END AS rli_service_start_date,
  CASE WHEN revenue_line_items.service = 0
  AND revenue_line_items_cstm.date_completion_c > revenue_line_items.date_closed THEN revenue_line_items_cstm.date_completion_c WHEN revenue_line_items.service = 0 THEN revenue_line_items.date_closed WHEN revenue_line_items.service = 1 THEN revenue_line_items.service_end_date END AS rli_service_end_date,
  revenue_line_items.service_duration_value AS rli_duration_value,
  revenue_line_items.service_duration_unit AS rli_duration_unit,
 CASE 
  WHEN revenue_line_items.service = 1 AND revenue_line_items.renewal = 1 AND revenue_line_items.sales_stage NOT LIKE "Closed%" THEN "Pipeline Renewal"
  WHEN revenue_line_items.service = 1 AND revenue_line_items.renewal = 0 AND revenue_line_items.product_type = "New Business"  AND revenue_line_items.sales_stage NOT LIKE "Closed%" THEN "Pipeline New" 
  WHEN revenue_line_items.service = 1 AND revenue_line_items.renewal = 0 AND revenue_line_items.product_type = "Existing Business"  AND revenue_line_items.sales_stage NOT LIKE "Closed%" THEN "Pipeline Existing"
  WHEN product_templates.name = "Perpetual licence" AND revenue_line_items.sales_stage NOT LIKE "Closed%" THEN "Pipeline Perpetual"

  WHEN revenue_line_items.service = 1 AND revenue_line_items.renewal = 1 AND revenue_line_items.sales_stage = "Closed Lost" THEN "Lost Renewal"
  WHEN revenue_line_items.service = 1 AND revenue_line_items.renewal = 0 AND revenue_line_items.product_type = "New Business"  AND revenue_line_items.sales_stage = "Closed Lost" THEN "Lost New" 
  WHEN revenue_line_items.service = 1 AND revenue_line_items.renewal = 0 AND revenue_line_items.product_type = "Existing Business"  AND revenue_line_items.sales_stage = "Closed Lost" THEN "Lost Existing"
  WHEN product_templates.name = "Perpetual licence" AND revenue_line_items.sales_stage = "Closed Lost" THEN "Lost Perpetual"

  WHEN revenue_line_items.service = 1 AND revenue_line_items.renewal = 1 AND revenue_line_items.probability = 100 AND revenue_line_items.date_closed <= revenue_line_items.service_start_date THEN "Won Renewal" 
  WHEN revenue_line_items.service = 1 AND revenue_line_items.renewal = 1 AND revenue_line_items.probability = 100 AND revenue_line_items.date_closed > revenue_line_items.service_start_date THEN "Won Renewal (Late)"
  WHEN revenue_line_items.service = 1 AND revenue_line_items.renewal = 0 AND revenue_line_items.product_type = "New Business"  AND revenue_line_items.probability = 100 THEN "Won New" 
  WHEN revenue_line_items.service = 1 AND revenue_line_items.renewal = 0 AND revenue_line_items.product_type = "Existing Business" AND revenue_line_items.probability = 100 THEN "Won Existing"
  WHEN product_templates.name = "Perpetual licence" AND revenue_line_items.probability = 100 THEN "Won Perpetual"
  ELSE "" 
END AS rli_arr_status,
  CASE WHEN CURDATE() >= revenue_line_items.service_start_date
  AND CURDATE() <= revenue_line_items.service_end_date THEN "Active" WHEN CURDATE() > revenue_line_items.service_end_date THEN "Past" WHEN CURDATE() < revenue_line_items.service_start_date THEN "Future" ELSE "" END AS rli_arr_active_status,
  revenue_line_items.date_closed AS rli_date_closed,
  revenue_line_items_cstm.date_completion_c AS rli_date_completion,
  revenue_line_items_cstm.date_invoice_c AS rli_date_invoiced,
  revenue_line_items_cstm.invoice_number_c AS rli_invoice_num,
  revenue_line_items_cstm.invoice_url_c AS rli_invoice_url,
  revenue_line_items_cstm.invoiceid_c AS rli_invoice_id,
  revenue_line_items_cstm.po_number_c AS rli_po_num,
  CASE 
  WHEN revenue_line_items.date_closed < "2022-07-01" AND product_templates.name = "Professional Services" THEN "opening balance" 
  WHEN revenue_line_items.date_closed < "2022-07-01" AND product_templates.name = "Engineering Services" THEN "opening balance" 
  WHEN revenue_line_items.date_closed < "2022-07-01" AND product_templates.name = "Engineering Services" THEN "opening balance" 
  WHEN revenue_line_items.date_closed < "2022-07-01" AND product_templates.name = "Professional Services" THEN "opening balance" 
  WHEN revenue_line_items.date_closed >= "2022-07-01" AND product_templates.name = "Professional Services" AND revenue_line_items.product_type = "New Business" THEN "Account Management" 
  WHEN revenue_line_items.date_closed >= "2022-07-01" AND product_templates.name = "Professional Services" AND revenue_line_items.product_type = "Existing Business" THEN "Account Management" 
  WHEN revenue_line_items.date_closed >= "2022-07-01" AND product_templates.name = "Engineering Services" AND revenue_line_items.product_type = "New Business" THEN "Account Management" 
  WHEN revenue_line_items.date_closed >= "2022-07-01" AND product_templates.name = "Engineering Services" AND revenue_line_items.product_type = "Existing Business" THEN "Account Management" 
  WHEN revenue_line_items.date_closed >= "2022-07-01" AND product_templates.name = "Professional Services" AND revenue_line_items.product_type = "Existing Business" THEN "Account Management" 
  WHEN revenue_line_items.date_closed >= "2022-07-01" AND product_templates.name = "Professional Services" AND revenue_line_items.product_type = "New Business" THEN "New Business" 
  WHEN revenue_line_items.date_closed >= "2022-07-01" AND product_templates.name = "Engineering Services" AND revenue_line_items.product_type = "Existing Business" THEN "Account Management" 
  WHEN revenue_line_items.date_closed >= "2022-07-01" AND product_templates.name = "Engineering Services" AND revenue_line_items.product_type = "New Business" THEN "New Business"
  WHEN product_templates.name = "Tier 2 Mobilisation" AND revenue_line_items.product_type = "New Business" THEN "New Business"
  WHEN product_templates.name = "Tier 2 Mobilisation" AND revenue_line_items.product_type = "Existing Business" THEN "Account Management"
  ELSE "" 
END AS rli_ps_category,
 
 round (revenue_line_items_cstm.previousrenewal_c,2) AS rli_previous_renewal,

 round(revenue_line_items_cstm.previousrenewal_c / revenue_line_items.base_rate,2) AS rli_previous_renewal_aud,

 round( revenue_line_items_cstm.uplift_c,2) AS rli_uplift,

 round ( revenue_line_items_cstm.uplift_c / revenue_line_items.base_rate, 2) AS rli_uplift_aud,

CASE
  WHEN revenue_line_items.service = 0 THEN round (((revenue_line_items_cstm.uplift_c / revenue_line_items.base_rate)/100) * revenue_line_items.probability, 2)
   WHEN revenue_line_items.service = 1 AND revenue_line_items.renewal = 0 THEN round (((revenue_line_items_cstm.uplift_c / revenue_line_items.base_rate)/100) * revenue_line_items.probability, 2)
  WHEN revenue_line_items.service = 1 AND revenue_line_items.renewal = 1 THEN round ((revenue_line_items_cstm.uplift_c / revenue_line_items.base_rate),2)
END AS rli_uplift_aud_weighted,
 


round(
    (
      (
        revenue_line_items_cstm.uplift_c / revenue_line_items.base_rate
      ) / revenue_line_items.service_duration_value
    ) * CASE WHEN revenue_line_items.service_duration_unit = "year" THEN 1 WHEN revenue_line_items.service_duration_unit = "month" THEN 12 WHEN revenue_line_items.service_duration_unit = "day" THEN 365 END,
    2
  ) AS rli_uplift_arr_aud,



IF(
    revenue_line_items.renewal = 1,
    round(
      (
        (
          revenue_line_items_cstm.uplift_c / revenue_line_items.base_rate
        ) / revenue_line_items.service_duration_value
      ) * CASE WHEN revenue_line_items.service_duration_unit = "year" THEN 1 WHEN revenue_line_items.service_duration_unit = "month" THEN 12 WHEN revenue_line_items.service_duration_unit = "day" THEN 365 END,
      2
    ),
    round(
      (
        (
          (
            (
              revenue_line_items_cstm.uplift_c / revenue_line_items.base_rate
            ) / revenue_line_items.service_duration_value
          ) * CASE WHEN revenue_line_items.service_duration_unit = "year" THEN 1 WHEN revenue_line_items.service_duration_unit = "month" THEN 12 WHEN revenue_line_items.service_duration_unit = "day" THEN 365 END
        ) / 100
      ) * revenue_line_items.probability,
      2
    )
  ) AS rli_uplift_arr_aud_weighted,



  CASE WHEN revenue_line_items.service = 0 THEN round(
    (
      revenue_line_items_cstm.uplift_c / revenue_line_items.base_rate
    ),
    2
  ) WHEN revenue_line_items.service = 1 THEN (
    revenue_line_items_cstm.uplift_c / revenue_line_items.base_rate
  ) / (
    DATEDIFF(
      revenue_line_items.service_end_date,
      revenue_line_items.service_start_date
    ) + 1
  ) END AS rli_uplift_drr_aud,
 

 CASE WHEN revenue_line_items.service = 0 THEN round(
    (
      (
        revenue_line_items_cstm.uplift_c / revenue_line_items.base_rate
      ) / 100
    ) * revenue_line_items.probability,
    2
  ) WHEN revenue_line_items.service = 1
  AND revenue_line_items.renewal = 1 THEN (
    revenue_line_items_cstm.uplift_c / revenue_line_items.base_rate
  ) / (
    DATEDIFF(
      revenue_line_items.service_end_date,
      revenue_line_items.service_start_date
    ) + 1
  ) WHEN revenue_line_items.service = 1
  AND revenue_line_items.renewal = 0 THEN (
    (
      (
        revenue_line_items_cstm.uplift_c / revenue_line_items.base_rate
      ) / (
        DATEDIFF(
          revenue_line_items.service_end_date,
          revenue_line_items.service_start_date
        ) + 1
      )
    ) / 100
  ) * revenue_line_items.probability END AS rli_uplift_drr_aud_weighted,

CASE 
  WHEN revenue_line_items.sales_stage = "Closed Complete" OR revenue_line_items.sales_stage = "Closed Lost" THEN "Actual" 
  WHEN revenue_line_items.sales_stage = "Closed Won" THEN "Contracted" 
  ELSE "Pipe" 
END AS rli_sales_status,
revenue_line_items.description
from
  revenue_line_items
  left join product_templates ON revenue_line_items.product_template_id = product_templates.id
  left join product_types ON product_templates.type_id = product_types.id
  left join users u1 ON revenue_line_items.assigned_user_id = u1.id
  left join opportunities ON revenue_line_items.opportunity_id = opportunities.id
  left join users u2 ON opportunities.assigned_user_id = u2.id
  left join revenue_line_items_cstm ON revenue_line_items_cstm.id_c = revenue_line_items.id
  left join accounts ON revenue_line_items.account_id = accounts.id
  left join users u3 ON accounts.assigned_user_id = u3.id
  left join currencies ON revenue_line_items.currency_id = currencies.id
where
  revenue_line_items.deleted = 0
  and (
    revenue_line_items.date_closed >= "2021-07-01"
    OR revenue_line_items.service_end_date >= "2021-07-01"
  )