-- -*- tab-width: 4 indent-tabs-mode: nil -*-
create or replace view v_ar_stmt_info
as
select
-- We retrieve the particular keys of the three tables
-- so that we may use them to make copies of derived 
-- data later:
  sh.stmt_hdr_id -- want to retrieve specific items
-- The sl.stmt_line_id is a joining column that will be provided
-- from the lwx_ar_stmt_lines, right?
-- ,  sl.stmt_line_id
-- We'll also need the sd.stmt_line_dtl_id, but that's provided
-- later in this select clause!
--
, sh.send_to_cust_nbr
, sh.statement_cycle_id
, sh.stmt_run_conc_req_id
, sh.stmt_dte
, sh.over_due_amt
, sh.due_amt
, sh.to_pay_amt
, sh.stmt_due_dte
, sh.not_due_amt
, sh.balance_amt
--
, sl.trans_nbr
-- Definitions of lines provided by the lwx_ar_stmt_lines.rec_type_cde:
--   'F2' ::= "prepaid-section" line
--   'F3' ::= "detail-section" line
--   'F4' ::= "there's an invoice consolidated with the statement"
, sl.rec_type_cde 
--
, sd.*
from
  lwx.lwx_ar_stmt_headers sh
, lwx.lwx_ar_stmt_lines sl
, lwx.lwx_ar_stmt_line_details sd
where
    sh.stmt_hdr_id = sl.stmt_hdr_id
and sl.stmt_line_id = sd.stmt_line_id
;

rem grant select on v_ar_stmt_info to apps;
