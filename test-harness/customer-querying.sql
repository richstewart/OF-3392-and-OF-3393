var p_statement_cycle_nme varchar2(1000)
exec :p_statement_cycle_nme := 'W1';
var p_customer_nbr varchar2(50)
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
