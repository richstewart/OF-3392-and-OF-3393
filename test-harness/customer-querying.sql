var p_statement_cycle_nme varchar2(1000)
var p_customer_nbr varchar2(50)

exec :p_statement_cycle_nme := 'W1';
exec :p_customer_nbr := '0000571900';

-- taken from the 
--   lwx_ar_invo_stmt_print.Generate_Con_Stmt procedure's v_customer_cur:
--     CURSOR v_customer_cur IS
select customer_number, count(distinct statement_cycle_name) c_count
select statement_cycle_name, count(*) rc
from(
      SELECT sc.STATEMENT_CYCLE_ID,
             null LANGUAGE,
             hcp.SITE_USE_ID,
             ac.cust_account_id CUSTOMER_ID,
	     ac.creation_date, -- needed as a substitute for the "last statement date" when there are no past statements
             ac.account_number CUSTOMER_NUMBER,
             hp.party_name CUSTOMER_NAME,
             ac.PARTY_ID,
             hCP.CUST_ACCOUNT_PROFILE_ID CUSTOMER_PROFILE_ID,
             sc.name STATEMENT_CYCLE_NAME,
             ac.ATTRIBUTE1,
             hcp.COLLECTOR_ID,
             ac.sales_channel_code,
             nvl(hcp.attribute1,'N') new_cons_inv_flag,
             -- Determine Logo Code (can be different at header and line levels)
             CASE 
               WHEN sc.name = 'WS' THEN 'SD'
               WHEN sc.name = 'WC' THEN 'BH'
               WHEN sclv.logo_code = 'CE' THEN 'RC'
               WHEN sclv.logo_code = 'OI' THEN 'BH'
               WHEN sc.name = 'WF' and upper(ac.attribute1) = 'ES' THEN 'BISP'
               WHEN sc.name = 'WF' THEN 'BI' 
               ELSE sclv.logo_code
             END hdr_logo_code,
             CASE 
               WHEN sc.name = 'WS' THEN 'SD'
               WHEN sc.name = 'WC' THEN 'BH'
               WHEN sc.name = 'WF' and upper(ac.attribute1) = 'ES' THEN 'BISP'
               WHEN sc.name = 'WF' THEN 'BI' 
               ELSE sclv.logo_code
             END line_logo_code,             
             sclv.stmt_msg1,
             sclv.stmt_msg2,
             ac.attribute12 CUST_EMAIL_ADR
        FROM HZ_CUST_ACCOUNTS        ac,
             hz_parties              hp,
             ar_statement_cycles     sc,
             HZ_CUST_PROFILE_CLASSES hcpc,
             HZ_CUSTOMER_PROFILES    hcp,
             (-- Statement Logo Code and Messages Sub-table - based on Sales Channel
              SELECT flv.lookup_code, flv.attribute3 logo_code, 
                     flv.attribute6 stmt_msg1, flv.attribute7 stmt_msg2
              FROM FND_LOOKUP_VALUES_VL flv
              WHERE flv.LOOKUP_TYPE = 'SALES_CHANNEL'
              -- Only get ONT - Order Mgmt lookups
              AND view_application_id = 660) sclv 
       WHERE ac.cust_account_id = hcp.cust_account_id
         AND hcp.SITE_USE_ID IS NULL
         -- AND sc.NAME = :p_statement_cycle_nme
         AND sc.statement_cycle_id = hcp.statement_cycle_id
         AND hcpc.profile_class_id(+) = hcp.profile_class_id
         AND ac.account_NUMBER = NVL(:p_customer_nbr, ac.account_NUMBER)
         AND ac.party_id = hp.party_id
         AND hcp.send_STATEMENTS = 'Y'
         AND ac.sales_channel_code = sclv.lookup_code (+)
) 
group by statement_cycle_name
group by customer_number having count(distinct statement_cycle_name) > 1


-- ********************************************************************************
-- trying to find the "open items" this is the query used by the package to find
-- the so-called open items from "first principles," or something closer!

    -- SQL #4
    -- Open Item Cursor Declaration
    -- Jude Lam 05/02/06 modify the where clause.

var p_customer_id number

    CURSOR v_openitem_cur(p_customer_id IN NUMBER) IS
      SELECT ctt.TYPE,
             rct.PRINTING_OPTION DEFAULT_PRINTING_OPTION,
             aps.CUSTOMER_TRX_ID,
             aps.TRX_NUMBER,
             aps.TRX_DATE,
             aps.CASH_RECEIPT_ID,
             aps.PAYMENT_SCHEDULE_ID,
             aps.CLASS,
             aps.AMOUNT_DUE_ORIGINAL,
             aps.AMOUNT_DUE_REMAINING,
             aps.DUE_DATE,
             aps.TERM_ID,
             aps.TERMS_SEQUENCE_NUMBER,
             rct.ATTRIBUTE3,
             rct.ATTRIBUTE4,
             (case
                when rct.interface_header_context = 'Interest Invoice' then 'LF'
                else rct.attribute5
              end) attribute5,
             rct.ATTRIBUTE6,
             rct.ATTRIBUTE7,
             rct.PURCHASE_ORDER,
--gw             replace(replace(rct.COMMENTS,CHR(10),' '),CHR(13),'') COMMENTS,  -- dhoward 17/MAR/08 -remove multi line chr
             regexp_replace(rct.COMMENTS, '[^ -{^}~]', '') COMMENTS,
             rct.INTERFACE_HEADER_ATTRIBUTE1,
             rct.INTERFACE_HEADER_CONTEXT,
             arm.PAYMENT_TYPE_CODE,
             dtyp.DOC_TYPE_NME,
             cra.COMMENTS CASH_COMMENTS
        FROM AR_PAYMENT_SCHEDULES aps,
             RA_CUSTOMER_TRX      rct,
             RA_CUST_TRX_TYPES    ctt,
             AR_RECEIPT_METHODS   arm,
             AR_CASH_RECEIPTS_ALL cra,
             (-- Document Type Sub Table 
              SELECT LOOKUP_CODE, MEANING doc_type_nme
              FROM FND_LOOKUP_VALUES_VL
              WHERE LOOKUP_TYPE = 'INV/CM') dtyp
       WHERE aps.CUSTOMER_ID = :p_customer_id -- WARNING! THIS IS SEPARATE AND DISTINCT FROM THE "customer_nbr"!!!
         AND (CASE rct.attribute5
               WHEN 'WO' THEN lwx_ar_query.get_wo_gift_card_receipt(APS.PAYMENT_SCHEDULE_ID)
               WHEN 'ET' THEN lwx_ar_query.get_wo_gift_card_receipt(APS.PAYMENT_SCHEDULE_ID)
               WHEN 'FC' THEN lwx_ar_query.get_wo_gift_card_receipt(APS.PAYMENT_SCHEDULE_ID)                 
               ELSE NULL  
              END) IS NULL
         AND rct.CUSTOMER_TRX_ID(+) = nvl(aps.CUSTOMER_TRX_ID, -999) -- Jude Lam 05/17/06 update
         AND ctt.CUST_TRX_TYPE_ID(+) = rct.CUST_TRX_TYPE_ID
         AND aps.status = 'OP'
         AND nvl(rct.RECEIPT_METHOD_ID,0) = arm.RECEIPT_METHOD_ID(+)
         AND nvl(aps.CASH_RECEIPT_ID,0) = cra.CASH_RECEIPT_ID(+)
         AND aps.class = dtyp.lookup_code (+)
         AND (CASE aps.class
               WHEN 'PMT' THEN lwx_ar_query.get_wo_gift_card_receipt(APS.PAYMENT_SCHEDULE_ID)
               ELSE NULL
              END) IS NULL


-- ################################################################################


var p_stmt_header_id number
rem the next is for holding date strings formatted as 'dd-mon-yyyy hh24:mi:ss'
var p_last_stmt_date_global varchar2(21) 
var p_ovr_due_amt number
var p_due_date_adjustment number

-- another query snatched from within the lwx_ar_invo_stmt_print:
begin
         SELECT NVL(DBT.DEBIT_AMT,0) + NVL(CRE.CREDIT_AMT, 0)
          INTO :p_ovr_due_amt
          FROM (-- Debit Amount Table
                SELECT SUM(NVL(sl.OUTSTND_AMT, 0)) DEBIT_AMT
                  FROM LWX_AR_STMT_LINES   SL,
                       RA_CUSTOMER_TRX_ALL TRX
                 WHERE STMT_HDR_ID = :p_stmt_header_id -- 8504107 -- v_stmt_header_id 
                   AND REC_TYPE_CDE = 'F3' 
                   AND OUTSTND_AMT >= 0 
                   AND SL.CUSTOMER_TRX_ID = TRX.CUSTOMER_TRX_ID(+) 
                   AND (TRUNC(GREATEST(SL.DUE_DTE, NVL(TRX.CREATION_DATE, SL.DUE_DTE))) + :p_due_date_adjustment)
                              < trunc(to_date(:p_last_stmt_date_global,'dd-mon-yyyy')) -- to_date('17-dec-2019','dd-mon-yyyy') -- TRUNC(v_last_stmt_date_global)
                   AND (CASE trx.attribute5
                          WHEN 'ET' THEN lwx_ar_query.get_wo_gift_card_receipt(sl.PAYMENT_SCHEDULE_ID)
                          WHEN 'WO' THEN lwx_ar_query.get_wo_gift_card_receipt(sl.PAYMENT_SCHEDULE_ID)
                          WHEN 'FC' THEN lwx_ar_query.get_wo_gift_card_receipt(sl.PAYMENT_SCHEDULE_ID)                            
                          ELSE NULL  
                        END) IS NULL
                   -- Prepay items should not be considered overdue until has appeared in F3 section before
                   AND (lwx_ar_invo_stmt_print.get_prepay(SL.PAYMENT_SCHEDULE_ID,'N','Y') IS NULL
                        OR 
                        EXISTS (SELECT 1 
                                FROM LWX_AR_STMT_LINES SL2
                                WHERE SL2.STMT_HDR_ID <> :p_stmt_header_id -- 8504107  -- v_stmt_header_id
                                AND SL2.REC_TYPE_CDE = 'F3'
                                AND SL2.CUSTOMER_TRX_ID = SL.CUSTOMER_TRX_ID)
                       )
                ) DBT,
               (-- Credit Amount Table 
                SELECT NVL(SUM(NVL(LASL2.OUTSTND_AMT, 0)), 0) CREDIT_AMT
               	  FROM LWX_AR_STMT_LINES LASL2
                 WHERE STMT_HDR_ID = :p_stmt_header_id /* 8504107 */ /* v_stmt_header_id */ AND
            	       REC_TYPE_CDE = 'F3' AND
        	           OUTSTND_AMT < 0 
                ) CRE
		;
end;

/* example block to set the variables: */
begin
  -- We merely need the "lastest" statement information,
  -- so the max() function helps with that.
  -- This isn't necessarily the most general solution!
  select max(stmt_hdr_id)
  into :p_stmt_header_id
  from rstewar.v_ar_stmt_info
  where send_to_cust_nbr = :p_customer_nbr;
  --
  :p_last_stmt_date_global := '25-jan-2020';
  --
  :p_due_date_adjustment := 10;
end;

/* AFTER EXECUTING THE ABOVE BLOCK TO SET THE 
   CLIENT-SIDE VARIABLES, YOU CAN EXECUTE THE
   BLOCK WHICH CALCULATES/DERIVES THE
   "overdue amount," AND STORES IT IN THE 
   p_ovr_due_amt CLIENT-SIDE VARIABLE. */

-- ********************************************************************************


/*
[2020-03-05 Thu 15:32] Greg Wright said:
"DEV was cloned from the 12/18/2019 version of PROD so this query should identify 
customers who were new at that time and had transactions but had never received a
statement:"
*/
select hca.account_number,
       hca.cust_account_id,
       hca.creation_date,
       lwx_ar_query.get_balance(hca.cust_account_id,'NO') bal
from   ar.hz_cust_accounts    hca,
       ar.hz_customer_profiles hcp
where  hca.creation_date >= to_date('01-NOV-2019','DD-MON-YYYY')
and    hca.cust_account_id = hcp.cust_account_id
and    hcp.site_use_id is null
and    lwx_ar_query.get_balance(hca.cust_account_id,'NO') <> 0
and    hca.account_number not in
(
select sh.send_to_cust_nbr
from   lwx.lwx_ar_stmt_headers sh
where  sh.send_to_cust_nbr = hca.account_number)
;


/*
Greg continued:
After you pick a customer you can run it through this query to see what he has: 
*/
select psa.trx_number,
       psa.due_date,
       psa.class,
       psa.amount_due_original,
       psa.amount_due_remaining
from   ar.ar_payment_schedules_all   psa
where  psa.customer_id = :p_customer_id -- 22430178
and    psa.status = 'OP'
