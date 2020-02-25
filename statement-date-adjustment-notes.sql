-- -*- indent-tabs-mode: nil tab-width: 4 -*-

-- query to determine assignment of customer's to "statement wave"
select wav.name
 from ar.hz_cust_accounts     hca,
      ar.hz_customer_profiles hcp,
      ar.ar_statement_cycles  wav
where hca.account_number = :p_customer_nbr -- '2000049678' --  for example
  and hca.cust_account_id = hcp.cust_account_id
  and hcp.site_use_id is null
  and hcp.statement_cycle_id = wav.statement_cycle_id
;

/*
customer tables to retain statement data:

lwx.lwx_ar_stmt_headers
lwx.lwx_ar_stmt_lines
lwx.lwx_ar_stmt_line_details

*/

/* 
This is an attempt to find the statement-header records of past-generated
statements:
*/
select
  sh.send_to_cust_nbr
, sh.stmt_dte
, sh.over_due_amt
, sh.due_amt
, sh.not_due_amt
, sh.balance_amt
, sh.to_pay_amt
from
  lwx.lwx_ar_stmt_headers sh
where
--     sh.over_due_amt > 0
-- and sh.balance_amt != sh.to_pay_amt
-- and sh.stmt_dte >= to_date('01-jan-2020','dd-mon-yyyy')
-- and
    sh.send_to_cust_nbr = :p_customer_nbr
order by sh.stmt_dte
;

/* 
Another way to look for what was generated for a particular 
customer:
*/

break on stmt_line_id skip 1 dup

select * from v_ar_stmt_info 
where send_to_cust_nbr = :p_customer_nbr
order by stmt_hdr_id, stmt_line_id, stmt_line_dtl_id, stmt_dte
