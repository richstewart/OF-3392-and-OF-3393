
SQL*Plus: Release 10.1.0.5.0 - Production on Tue Mar 24 12:08:23 2020

Copyright (c) 1982, 2005, Oracle.  All rights reserved.


Connected to:
Oracle Database 11g Enterprise Edition Release 11.2.0.3.0 - 64bit Production
With the Partitioning, Automatic Storage Management, OLAP and Data Mining options

Logged in at: Tue 24-mar-2020 12:08:24 pm


Session altered.

RUNNING THE LWX_FND_QUERY.SET_ORG(102)!!!!

PL/SQL procedure successfully completed.

Elapsed: 00:00:00.12
rstewar@TEST
SQL> rem trying to "test" OF-3392 in test instance, hampered by the problem that duplicated data don't exist in both places.
rstewar@TEST
SQL> rem this is a big issue and is a high cost, primarily in terms of time.
rstewar@TEST
SQL> 
rstewar@TEST
SQL> rem HOPEFULLY, CUSTOMER NUMBER 2002285834 WILL WORK; THEY DON'T APPEAR TO HAVE HAD A STATEMENT BEFORE TODAY, IN THE "TEST" INSTANCE.
rstewar@TEST
SQL> rem according to the web ui, they are on statement cycle IND (query for customers in the web ui, and look at their "AR account details" (I think that's what it was called...)
rstewar@TEST
SQL> rem THE PROBLEM WITH THIS EXERCISE IS THAT IT ONLY TEST WHETHER OR NOT THE INDIVIDUAL PROGRAMMER CAN SET UP ANOTHER TEST CASE IN THE TEST INSTANCE.
rstewar@TEST
SQL> REM IT DOES NOT TEST THE BUSINESS FUNCTIONALITY OR ANYTHING ELSE.  I CAN VERIFY THAT THE PROGRAM DOES RUN PROPERLY FROM START TO FINISH, THAT IS FOR SURE.
rstewar@TEST
SQL> REM THE ONLY WAY THIS BECOMES COST EFFECTIVE IS IF I CAN FIND A WAY TO QUICKLY IDENTIFY THE TARGET CUSTOMER WHICH SATISFIES THE CONSTRAINT 
rstewar@TEST
SQL> REM THAT THEY HAVE A NON-ZERO BALANCE *AND* THEY HAVE *NOT* EVER RECEIVED A STATEMENT.  IN ORDER TO FIND SUCH A PERSON, I MUST HAVE INTIMATE
rstewar@TEST
SQL> REM KNOWLEDGE OF THE DATA MODEL, AND ACCESS TO EVERYTHING IN TEST THAT WAS PROVIDED IN DEV.
rstewar@TEST
SQL> rem trying to find a customer with an open balance who has not received a statement ever before:
rstewar@TEST
SQL> select * 
from (
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

  2    3    4    5    6    7    8    9   10   11   12   13   14   15   16   17   18   19   20   21   22   23   24   25   26   27   28   29   30   31   32   33   34   35   36   37   38   39   40   41   42   43   44   45   46   47   48   49   50   51   52   53   54   55   56   57   58   59  rstewar@TEST
SQL> var :p_customer_nbr number
SP2-0553: Illegal variable name ":p_customer_nbr".
rstewar@TEST
SQL> var p_customer_nbr number
rstewar@TEST
SQL> var p_statement_cycle_nme varchar2(50)
rstewar@TEST
SQL> exec :p_customer_nbr := null;

PL/SQL procedure successfully completed.

Elapsed: 00:00:00.11
rstewar@TEST
SQL> l
  1  select *
  2  from (
  3        SELECT sc.STATEMENT_CYCLE_ID,
  4               null LANGUAGE,
  5               hcp.SITE_USE_ID,
  6               ac.cust_account_id CUSTOMER_ID,
  7  	     ac.creation_date, -- needed as a substitute for the "last statement date" when there are no past statements
  8               ac.account_number CUSTOMER_NUMBER,
  9               hp.party_name CUSTOMER_NAME,
 10               ac.PARTY_ID,
 11               hCP.CUST_ACCOUNT_PROFILE_ID CUSTOMER_PROFILE_ID,
 12               sc.name STATEMENT_CYCLE_NAME,
 13               ac.ATTRIBUTE1,
 14               hcp.COLLECTOR_ID,
 15               ac.sales_channel_code,
 16               nvl(hcp.attribute1,'N') new_cons_inv_flag,
 17               -- Determine Logo Code (can be different at header and line levels)
 18               CASE
 19                 WHEN sc.name = 'WS' THEN 'SD'
 20                 WHEN sc.name = 'WC' THEN 'BH'
 21                 WHEN sclv.logo_code = 'CE' THEN 'RC'
 22                 WHEN sclv.logo_code = 'OI' THEN 'BH'
 23                 WHEN sc.name = 'WF' and upper(ac.attribute1) = 'ES' THEN 'BISP'
 24                 WHEN sc.name = 'WF' THEN 'BI'
 25                 ELSE sclv.logo_code
 26               END hdr_logo_code,
 27               CASE
 28                 WHEN sc.name = 'WS' THEN 'SD'
 29                 WHEN sc.name = 'WC' THEN 'BH'
 30                 WHEN sc.name = 'WF' and upper(ac.attribute1) = 'ES' THEN 'BISP'
 31                 WHEN sc.name = 'WF' THEN 'BI'
 32                 ELSE sclv.logo_code
 33               END line_logo_code,
 34               sclv.stmt_msg1,
 35               sclv.stmt_msg2,
 36               ac.attribute12 CUST_EMAIL_ADR
 37          FROM HZ_CUST_ACCOUNTS        ac,
 38               hz_parties              hp,
 39               ar_statement_cycles     sc,
 40               HZ_CUST_PROFILE_CLASSES hcpc,
 41               HZ_CUSTOMER_PROFILES    hcp,
 42               (-- Statement Logo Code and Messages Sub-table - based on Sales Channel
 43                SELECT flv.lookup_code, flv.attribute3 logo_code,
 44                       flv.attribute6 stmt_msg1, flv.attribute7 stmt_msg2
 45                FROM FND_LOOKUP_VALUES_VL flv
 46                WHERE flv.LOOKUP_TYPE = 'SALES_CHANNEL'
 47                -- Only get ONT - Order Mgmt lookups
 48                AND view_application_id = 660) sclv
 49         WHERE ac.cust_account_id = hcp.cust_account_id
 50           AND hcp.SITE_USE_ID IS NULL
 51           -- AND sc.NAME = :p_statement_cycle_nme
 52           AND sc.statement_cycle_id = hcp.statement_cycle_id
 53           AND hcpc.profile_class_id(+) = hcp.profile_class_id
 54           AND ac.account_NUMBER = NVL(:p_customer_nbr, ac.account_NUMBER)
 55           AND ac.party_id = hp.party_id
 56           AND hcp.send_STATEMENTS = 'Y'
 57           AND ac.sales_channel_code = sclv.lookup_code (+)
 58* )
rstewar@TEST
SQL> /
              FROM FND_LOOKUP_VALUES_VL flv
                   *
ERROR at line 45:
ORA-00942: table or view does not exist


Elapsed: 00:00:00.14
rstewar@TEST
SQL> select * 
from (
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
        FROM apps.HZ_CUST_ACCOUNTS        ac,
             apps.hz_parties              hp,
             apps.ar_statement_cycles     sc,
             apps.HZ_CUST_PROFILE_CLASSES hcpc,
             apps.HZ_CUSTOMER_PROFILES    hcp,
             (-- Statement Logo Code and Messages Sub-table - based on Sales Channel
              SELECT flv.lookup_code, flv.attribute3 logo_code, 
                     flv.attribute6 stmt_msg1, flv.attribute7 stmt_msg2
              FROM apps.FND_LOOKUP_VALUES_VL flv
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
/
  2    3    4    5    6    7    8    9   10   11   12   13   14   15   16   17   18   19   20   21   22   23   24   25   26   27   28   29   30   31   32   33   34   35   36   37   38   39   40   41   42   43   44   45   46   47   48   49   50   51   52   53   54   55   56   57   58   59  
STATEMENT_CYCLE_ID	L	    SITE_USE_ID	    CUSTOMER_ID	CREATION_DATE       	CUSTOMER_NUMBER               	CUSTOMER_NAME       	       PARTY_ID	CUSTOMER_PROFILE_ID	STATEMENT_CYCLE	ATTRIBUTE1                                                                                                                                            	   COLLECTOR_ID	SALES_CHANNEL_CODE            	NEW_CONS_INV_FLAG   	HDR_LOGO_CODE       	LINE_LOGO_CODE      	STMT_MSG1           	STMT_MSG2           	CUST_EMAIL_ADR
------------------	-	---------------	---------------	--------------------	------------------------------	--------------------	---------------	-------------------	---------------	------------------------------------------------------------------------------------------------------------------------------------------------------	---------------	------------------------------	--------------------	--------------------	--------------------	--------------------	--------------------	--------------------
              3000	 	               	           2632	12-sep-2006 14:03:16	0109323250                    	Charles Cole        	          15646	               2632	IND            	En                                                                                                                                                    	           2016	CR                            	Y                   	RC                  	RC                  	                    	                    	
              3000	 	               	           2633	12-sep-2006 14:03:16	0301640240                    	Janet Mills         	          15647	               2633	IND            	En                                                                                                                                                    	           2016	CR                            	Y                   	RC                  	RC                  	                    	                    	
              3000	 	               	           2634	12-sep-2006 14:03:16	0109502690                    	Judy Baker          	          15648	               2634	IND            	En                                                                                                                                                    	           2016	SC                            	Y                   	RC                  	RC                  	                    	                    	
              3000	 	               	           2635	12-sep-2006 14:03:17	0109504340                    	Nadie Barrett       	          15649	               2635	IND            	En                                                                                                                                                    	           2016	CR                            	Y                   	RC                  	RC                  	                    	                    	
              3000	 	               	           2636	12-sep-2006 14:03:17	0301900030                    	Peggy Kirk          	          15650	               2636	IND            	En                                                                                                                                                    	           2016	CR                            	Y                   	RC                  	RC                  	                    	                    	
              3000	 	               	           2637	12-sep-2006 14:03:17	0109743920                    	Robert Spigner      	          15651	               2637	IND            	En                                                                                                                                                    	           2016	CR                            	Y                   	RC                  	RC                  	                    	                    	
              3000	 	               	           2638	12-sep-2006 14:03:18	0109886160                    	Jane Glover         	          15652	               2638	IND            	En                                                                                                                                                    	           2016	CR                            	Y                   	RC                  	RC                  	                    	                    	
              3000	 	               	           2639	12-sep-2006 14:03:18	0302435210                    	Mary Wightman       	          15653	               2639	IND            	En                                                                                                                                                    	           2016	CR                            	Y                   	RC                  	RC                  	                    	                    	
              3000	 	               	           2640	12-sep-2006 14:03:19	0110080590                    	Roland Davis        	          15654	               2640	IND            	En                                                                                                                                                    	           2016	CR                            	Y                   	RC                  	RC                  	                    	                    	
              3000	 	               	           2641	12-sep-2006 14:03:19	0110438660                    	Betty Rice          	          15656	               2641	IND            	En                                                                                                                                                    	           2016	CR                            	Y                   	RC                  	RC                  	                    	                    	
              3000	 	               	           2642	12-sep-2006 14:03:19	0302894740                    	Donna McCarthy      	          15655	               2642	IND            	En                                                                                                                                                    	           2016	CR                            	Y                   	RC                  	RC                  	                    	                    	
              3000	 	               	           2643	12-sep-2006 14:03:20	0110843730                    	Marjorie Small      	          15657	               2643	IND            	En                                                                                                                                                    	           2016	CR                            	Y                   	RC                  	RC                  	                    	                    	
              3000	 	               	           2644	12-sep-2006 14:03:20	0303201210                    	Aileen Green        	          15658	               2644	IND            	En                                                                                                                                                    	           2016	SC                            	Y                   	RC                  	RC                  	                    	                    	
              3000	 	               	           2645	12-sep-2006 14:03:21	0110968980                    	Dorothy Cornine     	          15659	               2645	IND            	En                                                                                                                                                    	           2016	CR                            	Y                   	RC                  	RC                  	                    	                    	
              3000	 	               	           2646	12-sep-2006 14:03:21	0303825840                    	Argie Hilbert       	          15660	               2646	IND            	En                                                                                                                                                    	           2016	CR                            	Y                   	RC                  	RC                  	                    	                    	
              3000	 	               	           2647	12-sep-2006 14:03:21	0112539030                    	Wallace Rivers      	          15661	               2647	IND            	En                                                                                                                                                    	           2016	CR                            	Y                   	RC                  	RC                  	                    	                    	
              3000	 	               	           2648	12-sep-2006 14:03:22	0304266390                    	Max Alexander       	          15662	               2648	IND            	En                                                                                                                                                    	           2016	CR                            	Y                   	RC                  	RC                  	                    	                    	
              3000	 	               	           2649	12-sep-2006 14:03:22	0112864810                    	Joyce Tarr          	          15663	               2649	IND            	En                                                                                                                                                    	           2016	CR                            	Y                   	RC                  	RC                  	                    	                    	
              3000	 	               	           2650	12-sep-2006 14:03:23	0304536900                    	Norma Chapman       	          15664	               2650	IND            	En                                                                                                                                                    	           2016	CR                            	Y                   	RC                  	RC                  	                    	                    	
              3000	 	               	           2651	12-sep-2006 14:03:23	0113787670                    	Teresa Ozment       	          15665	               2651	IND            	En                                                                                                                                                    	           2016	CR                            	Y                   	RC                  	RC                  	                    	                    	
              3000	 	               	           2652	12-sep-2006 14:03:23	0304695480                    	Judy Glauser        	          15666	               2652	IND            	En                                                                                                                                                    	           2016	CR                            	Y                   	RC                  	RC                  	                    	                    	
              3000	 	               	           2653	12-sep-2006 14:03:23	0114083410                    	Sharon Myers        	          15667	               2653	IND            	En                                                                                                                                                    	           2016	CR                            	Y                   	RC                  	RC                  	                    	                    	
              3000	 	               	           2654	12-sep-2006 14:03:24	0305017530                    	Donna Hanson        	          15669	               2654	IND            	En                                                                                                                                                    	           2016	CR                            	Y                   	RC                  	RC                  	                    	                    	
              3000	 	               	           2655	12-sep-2006 14:03:24	0114146120                    	Mary McGee          	          15668	               2655	IND            	En                                                                                                                                                    	           2016	CR                            	Y                   	RC                  	RC                  	                    	                    	
              3000	 	               	           2656	12-sep-2006 14:03:24	0305333350                    	Margaret Silver     	          15671	               2656	IND            	En                                                                                                                                                    	           2016	CR                            	Y                   	RC                  	RC                  	                    	                    	
              3000	 	               	           2657	12-sep-2006 14:03:25	0114311370                    	Florence Ray        	          15670	               2657	IND            	En                                                                                                                                                    	           2016	CR                            	Y                   	RC                  	RC                  	                    	                    	
              3000	 	               	           2658	12-sep-2006 14:03:26	0114377040                    	William Day         	          15672	               2658	IND            	En                                                                                                                                                    	           2016	CR                            	Y                   	RC                  	RC                  	                    	                    	
              3000	 	               	           2659	12-sep-2006 14:03:26	0305355120                    	Bill Hornbeck       	          15673	               2659	IND            	En                                                                                                                                                    	           2016	CR                            	Y                   	RC                  	RC                  	                    	                    	
              3000	 	               	           2660	12-sep-2006 14:03:26	0305908890                    	Anne Thomas         	          15674	               2660	IND            	En                                                                                                                                                    	           2016	CR                            	Y                   	RC                  	RC                  	                    	                    	
              3000	 	               	           2661	12-sep-2006 14:03:26	0114501030                    	Betty Ferren        	          15675	               2661	IND            	En                                                                                                                                                    	           2016	CR                            	Y                   	RC                  	RC                  	                    	                    	
              3000	 	               	           2662	12-sep-2006 14:03:27	0306491800                    	David Blackwell     	          15676	               2662	IND            	En                                                                                                                                                    	           2016	CR                            	Y                   	RC                  	RC                  	                    	                    	
              3000	 	               	           2665	12-sep-2006 14:03:27	0306925940                    	Billie Kelsey       	          15679	               2665	IND            	En                                                                                                                                                    	           2016	CR                            	Y                   	RC                  	RC                  	                    	                    	
              3000	 	               	           2666	12-sep-2006 14:03:28	0307848130                    	Sandra Moore        	          15681	               2666	IND            	En                                                                                                                                                    	           2016	CR                            	Y                   	RC                  	RC                  	                    	                    	
              3000	 	               	           2668	12-sep-2006 14:03:29	0308885230                    	Mary Carr           	          15683	               2669	IND            	En                                                                                                                                                    	           2016	CR                            	Y                   	RC                  	RC                  	                    	                    	
              3000	 	               	           2670	12-sep-2006 14:03:29	0309022090                    	Janey Bagot         	          15685	               2670	IND            	En                                                                                                                                                    	           2016	CR                            	Y                   	RC                  	RC                  	                    	                    	
              3000	 	               	           2674	12-sep-2006 14:03:30	0309076200                    	Charlotte Ellis     	          15687	               2674	IND            	En                                                                                                                                                    	           2016	CR                            	Y                   	RC                  	RC                  	                    	                    	
              3000	 	               	           2676	12-sep-2006 14:03:31	0309356960                    	James Gould         	          15689	               2676	IND            	En                                                                                                                                                    	           2016	CR                            	Y                   	RC                  	RC                  	                    	                    	
              3000	 	               	           2677	12-sep-2006 14:03:31	0309587220                    	Carter Shelton      	          15692	               2677	IND            	En                                                                                                                                                    	           2016	CR                            	Y                   	RC                  	RC                  	                    	                    	
              3000	 	               	           2679	12-sep-2006 14:03:32	0310371120                    	Linda Jennings      	          15693	               2679	IND            	En                                                                                                                                                    	           2016	CR                            	Y                   	RC                  	RC                  	                    	                    	
              3000	 	               	           2681	12-sep-2006 14:03:33	0310590410                    	Kristal Crutchfield 	          15695	               2681	IND            	En                                                                                                                                                    	           2016	CR                            	Y                   	RC                  	RC                  	                    	                    	
              3000	 	               	           2683	12-sep-2006 14:03:33	0311648250                    	Susan Baisden       	          15697	               2683	IND            	En                                                                                                                                                    	           2016	CR                            	Y                   	RC                  	RC                  	                    	                    	
              3000	 	               	           2686	12-sep-2006 14:03:34	0312164760                    	Betty Sullivan      	          15699	               2685	IND            	En                                                                                                                                                    	           2016	CR                            	Y                   	RC                  	RC                  	                    	                    	
              3000	 	               	           2687	12-sep-2006 14:03:34	0312630150                    	Harry Kent          	          15702	               2687	IND            	En                                                                                                                                                    	           2016	CR                            	Y                   	RC                  	RC                  	                    	                    	
              3000	 	               	           2689	12-sep-2006 14:03:35	0312879800                    	Sandra Talbert      	          15703	               2689	IND            	En                                                                                                                                                    	           2016	CR                            	Y                   	RC                  	RC                  	                    	                    	
              3000	 	               	           2690	12-sep-2006 14:03:35	0313123740                    	Dorothy Goodrich    	          15705	               2690	IND            	En                                                                                                                                                    	           2016	CR                            	Y                   	RC                  	RC                  	                    	                    	
              3000	 	               	           2692	12-sep-2006 14:03:36	0313183970                    	Judith Stroud       	          15706	               2692	IND            	En                                                                                                                                                    	           2016	CR                            	Y                   	RC                  	RC                  	                    	                    	
              3000	 	               	           2695	12-sep-2006 14:03:37	0313241480                    	Carol Bohrer        	          15708	               2695	IND            	En                                                                                                                                                    	           2016	SC                            	Y                   	RC                  	RC                  	                    	                    	
              1005	 	               	           2696	12-sep-2006 14:03:37	0313265070                    	Alexanders Bibles Bo	          15710	               2696	WC             	En                                                                                                                                                    	           2003	BH                            	N                   	BH                  	BH                  	                    	                    	
              3000	 	               	           2698	12-sep-2006 14:03:38	0313334950                    	Merrill Larson      	          15712	               2698	IND            	En                                                                                                                                                    	           2016	CR                            	Y                   	RC                  	RC                  	                    	                    	
              3000	 	               	           2701	12-sep-2006 14:03:39	0313511090                    	Milton Walker       	          15714	               2700	IND            	En                                                                                                                                                    	           2016	CR                            	Y                   	RC                  	RC                  	                    	                    	
              3000	 	               	           2703	12-sep-2006 14:03:40	0313960880                    	Carolyn Story       	          15717	               2703	IND            	En                                                                                                                                                    	           2016	SC                            	Y                   	RC                  	RC                  	                    	                    	
              3000	 	               	           2704	12-sep-2006 14:03:40	0314410170                    	Ann Clark           	          15719	               2704	IND            	En                                                                                                                                                    	           2016	CR                            	Y                   	RC                  	RC                  	                    	                    	
              3000	 	               	           2706	12-sep-2006 14:03:41	0315270960                    	Kathleen Gill       	          15721	               2706	IND            	En                                                                                                                                                    	           2016	CR                            	Y                   	RC                  	RC                  	                    	                    	
              3000	 	               	           2708	12-sep-2006 14:03:42	0315612510                    	Brenda Belk         	          15722	               2707	IND            	En                                                                                                                                                    	           2016	SC                            	Y                   	RC                  	RC                  	                    	                    	
              1000	 	               	           2710	12-sep-2006 14:03:42	0316129630                    	Barbara Nichols     	          15724	               2710	W1             	En                                                                                                                                                    	           2009	SC                            	N                   	RC                  	RC                  	                    	                    	
              3000	 	               	           2711	12-sep-2006 14:03:43	0317018240                    	David McKelvey      	          15726	               2711	IND            	En                                                                                                                                                    	           2016	CR                            	Y                   	RC                  	RC                  	                    	                    	
              3000	 	               	           2714	12-sep-2006 14:03:44	0317172670                    	Laura Hudnall       	          15727	               2714	IND            	En                                                                                                                                                    	           2016	CR                            	Y                   	RC                  	RC                  	                    	                    	
              3000	 	               	           2716	12-sep-2006 14:03:45	0317519850                    	Stella Miller       	          15730	               2716	IND            	En                                                                                                                                                    	           2016	CR                            	Y                   	RC                  	RC                  	                    	                    	
              3000	 	               	           2717	12-sep-2006 14:03:45	0317863460                    	Margaret Harrelson  	          15732	               2717	IND            	En                                                                                                                                                    	           2016	CR                            	Y                   	RC                  	RC                  	                    	                    	
              3000	 	               	           2719	12-sep-2006 14:03:48	0318010380                    	Kennith Webb        	          15733	               2719	IND            	En                                                                                                                                                    	           2016	CR                            	Y                   	RC                  	RC                  	                    	                    	
              3000	 	               	           2721	12-sep-2006 14:03:48	0318161500                    	Virginia Wallace    	          15735	               2721	IND            	En                                                                                                                                                    	           2016	CR                            	Y                   	RC                  	RC                  	                    	                    	
              3000	 	               	           2723	12-sep-2006 14:03:49	0318418850                    	Sallye Cosgrove     	          15737	               2723	IND            	En                                                                                                                                                    	           2016	CR                            	Y                   	RC                  	RC                  	                    	                    	
              3000	 	               	           2725	12-sep-2006 14:03:49	0318463300                    	Linda South         	          15738	               2725	IND            	En                                                                                                                                                    	           2016	CR                            	Y                   	RC                  	RC                  	                    	                    	
              3000	 	               	           2726	12-sep-2006 14:03:50	0318739790                    	Julie Davis         	          15740	               2726	IND            	En                                                                                                                                                    	           2016	CR                            	Y                   	RC                  	RC                  	                    	                    	
              3000	 	               	           2727	12-sep-2006 14:03:50	0126572760                    	Patricia Jones      	          15741	               2727	IND            	En                                                                                                                                                    	           2016	CR                            	Y                   	RC                  	RC                  	                    	                    	
              3000	 	               	           2728	12-sep-2006 14:03:51	0319157130                    	Frances Edwards     	          15742	               2728	IND            	En                                                                                                                                                    	           2016	CR                            	Y                   	RC                  	RC                  	                    	                    	
              3000	 	               	           2729	12-sep-2006 14:03:51	0127049870                    	Winnie Howell       	          15743	               2729	IND            	En                                                                                                                                                    	           2016	CR                            	Y                   	RC                  	RC                  	                    	                    	
              3000	 	               	           2730	12-sep-2006 14:03:51	0127593950                    	Frank Smith         	          15744	               2730	IND            	En                                                                                                                                                    	           2016	CR                            	Y                   	RC                  	RC                  	                    	                    	
              3000	 	               	           2731	12-sep-2006 14:03:51	0319298470                    	Deborah Ward        	          15745	               2731	IND            	En                                                                                                                                                    	           2016	CR                            	Y                   	RC                  	RC                  	                    	                    	
              3000	 	               	           2732	12-sep-2006 14:03:52	0319429150                    	Betty Harless       	          15747	               2732	IND            	En                                                                                                                                                    	           2016	CR                            	Y                   	RC                  	RC                  	                    	                    	
              3000	 	               	           2733	12-sep-2006 14:03:52	0127806720                    	Lillian Mendez      	          15746	               2733	IND            	En                                                                                                                                                    	           2016	CR                            	Y                   	RC                  	RC                  	                    	                    	
              3000	 	               	           2734	12-sep-2006 14:03:53	0127868440                    	Sylvia Jackson      	          15749	               2734	IND            	En                                                                                                                                                    	           2016	CR                            	Y                   	RC                  	RC                  	                    	                    	
              3000	 	               	           2735	12-sep-2006 14:03:53	0319565190                    	Loy Culver          	          15748	               2735	IND            	En                                                                                                                                                    	           2016	CR                            	Y                   	RC                  	RC                  	                    	                    	
              3000	 	               	           2736	12-sep-2006 14:03:54	0319918700                    	Ann Iorg            	          15751	               2736	IND            	En                                                                                                                                                    	           2016	CR                            	Y                   	RC                  	RC                  	                    	                    	
              3000	 	               	           2737	12-sep-2006 14:03:54	0128106510                    	Charlotte Pugh      	          15750	               2737	IND            	En                                                                                                                                                    	           2016	CR                            	Y                   	RC                  	RC                  	                    	                    	
              3000	 	               	           2739	12-sep-2006 14:03:55	0320235330                    	Susan Toone         	          15754	               2739	IND            	En                                                                                                                                                    	           2016	CR                            	Y                   	RC                  	RC                  	                    	                    	
              1005	 	               	           2740	12-sep-2006 14:03:55	0300242280                    	Gift & Bible Center 	          15753	               2740	WC             	En                                                                                                                                                    	           2004	BH                            	N                   	BH                  	BH                  	                    	                    	
              3000	 	               	           2741	12-sep-2006 14:03:55	0300565680                    	Mary Fall           	          15756	               2741	IND            	En                                                                                                                                                    	           2016	CR                            	Y                   	RC                  	RC                  	                    	                    	
              3000	 	               	           2742	12-sep-2006 14:03:55	0320379130                    	D Goodfellow        	          15755	               2742	IND            	En                                                                                                                                                    	           2016	CR                            	Y                   	RC                  	RC                  	                    	                    	
              3000	 	               	           2743	12-sep-2006 14:03:56	0320632990                    	John Maddox         	          15758	               2743	IND            	En                                                                                                                                                    	           2016	CR                            	Y                   	RC                  	RC                  	                    	                    	
              3000	 	               	           2744	12-sep-2006 14:03:56	0300836460                    	Jean Pfeifer        	          15757	               2744	IND            	En                                                                                                                                                    	           2016	CR                            	Y                   	RC                  	RC                  	                    	                    	
              3000	 	               	           2745	12-sep-2006 14:03:57	0301216280                    	June Grubb          	          15760	               2745	IND            	En                                                                                                                                                    	           2016	CR                            	Y                   	RC                  	RC                  	                    	                    	
              3000	 	               	           2746	12-sep-2006 14:03:57	0320777780                    	Jo Sealock          	          15759	               2746	IND            	En                                                                                                                                                    	           2016	CR                            	Y                   	RC                  	RC                  	                    	                    	
              3000	 	               	           2747	12-sep-2006 14:03:57	0321481240                    	Diane McDonald      	          15761	               2747	IND            	En                                                                                                                                                    	           2016	CR                            	Y                   	RC                  	RC                  	                    	                    	
              3000	 	               	           2748	12-sep-2006 14:03:57	0301382340                    	Earl Burns          	          15762	               2748	IND            	En                                                                                                                                                    	           2016	CR                            	Y                   	RC                  	RC                  	                    	                    	
              3000	 	               	           2749	12-sep-2006 14:03:58	0321547000                    	Delain Prewitt      	          15764	               2749	IND            	En                                                                                                                                                    	           2016	CR                            	Y                   	RC                  	RC                  	                    	                    	
              1005	 	               	           2750	12-sep-2006 14:03:58	0301634550                    	Second Baptist Books	          15763	               2750	WC             	En                                                                                                                                                    	           2004	BH                            	N                   	BH                  	BH                  	                    	                    	sbcinvoice@second.or
              3000	 	               	           2751	12-sep-2006 14:03:59	0321822480                    	Mary Fowler         	          15765	               2751	IND            	En                                                                                                                                                    	           2016	SC                            	Y                   	RC                  	RC                  	                    	                    	
              3000	 	               	           2752	12-sep-2006 14:03:59	0302972120                    	Leatha Goeth        	          15766	               2752	IND            	En                                                                                                                                                    	           2016	CR                            	Y                   	RC                  	RC                  	                    	                    	
              3000	 	               	           2753	12-sep-2006 14:03:59	0322101220                    	Lena Early          	          15767	               2753	IND            	En                                                                                                                                                    	           2016	CR                            	Y                   	RC                  	RC                  	                    	                    	
              3000	 	               	           2754	12-sep-2006 14:03:59	0303004530                    	Loresa Heyward      	          15768	               2754	IND            	En                                                                                                                                                    	           2016	CR                            	Y                   	RC                  	RC                  	                    	                    	
              3000	 	               	           2755	12-sep-2006 14:04:00	0303365800                    	Tommie Akins        	          15770	               2755	IND            	En                                                                                                                                                    	           2016	CR                            	Y                   	RC                  	RC                  	                    	                    	
              3000	 	               	           2663	12-sep-2006 14:03:27	0115194770                    	Sheila Petek        	          15677	               2663	IND            	En                                                                                                                                                    	           2016	CR                            	Y                   	RC                  	RC                  	                    	                    	
              3000	 	               	           2664	12-sep-2006 14:03:27	0115564380                    	Tom Zumbro          	          15678	               2664	IND            	En                                                                                                                                                    	           2016	CR                            	Y                   	RC                  	RC                  	                    	                    	
              3000	 	               	           2667	12-sep-2006 14:03:28	0115739120                    	Marion Stewart      	          15680	               2667	IND            	En                                                                                                                                                    	           2016	CR                            	Y                   	RC                  	RC                  	                    	                    	
              3000	 	               	           2669	12-sep-2006 14:03:29	0115963840                    	Juanita Walser      	          15682	               2668	IND            	En                                                                                                                                                    	           2016	CR                            	Y                   	RC                  	RC                  	                    	                    	
              3000	 	               	           2671	12-sep-2006 14:03:29	0116167860                    	Doris Goolsbay      	          15684	               2671	IND            	En                                                                                                                                                    	           2016	CR                            	Y                   	RC                  	RC                  	                    	                    	
              3000	 	               	           2672	12-sep-2006 14:03:30	0116651060                    	Earline Hobbs       	          15686	               2672	IND            	En                                                                                                                                                    	           2016	CR                            	Y                   	RC                  	RC                  	                    	                    	
              3000	 	               	           2673	12-sep-2006 14:03:30	0116995270                    	Michael Ward        	          15688	               2673	IND            	En                                                                                                                                                    	           2016	CR                            	Y                   	RC                  	RC                  	                    	                    	
              3000	 	               	           2675	12-sep-2006 14:03:31	0117271790                    	Emily Brown         	          15690	               2675	IND            	En                                                                                                                                                    	           2016	CR                            	Y                   	RC                  	RC                  	                    	                    	
              3000	 	               	           2678	12-sep-2006 14:03:31	0118093240                    	Omer Painter        	          15691	               2678	IND            	En                                                                                                                                                    	           2016	CR                            	Y                   	RC                  	RC                  	                    	                    	
              3000	 	               	           2680	12-sep-2006 14:03:33	0118249500                    	Leah Porter         	          15694	               2680	IND            	En                                                                                                                                                    	           2016	CR                            	Y                   	RC                  	RC                  	                    	                    	
              3000	 	               	           2682	12-sep-2006 14:03:33	0118310130                    	Carolyn Mize        	          15696	               2682	IND            	En                                                                                                                                                    	           2016	CR                            	Y                   	RC                  	RC                  	                    	                    	
              3000	 	               	           2684	12-sep-2006 14:03:33	0118633960                    	Elizabeth Willis    	          15698	               2684	IND            	En                                                                                                                                                    	           2016	CR                            	Y                   	RC                  	RC                  	                    	                    	
              3000	 	               	           2685	12-sep-2006 14:03:34	0118738250                    	Noreen Frederick    	          15700	               2686	IND            	En                                                                                                                                                    	           2016	CR                            	Y                   	RC                  	RC                  	                    	                    	
              3000	 	               	           2688	12-sep-2006 14:03:35	0118899610                    	Jean Worthy         	          15701	               2688	IND            	En                                                                                                                                                    	           2016	SC                            	Y                   	RC                  	RC                  	                    	                    	
              3000	 	               	           2691	12-sep-2006 14:03:35	0119067400                    	Gail Settlemyre     	          15704	               2691	IND            	En                                                                                                                                                    	           2016	CR                            	Y                   	RC                  	RC                  	                    	                    	
              3000	 	               	           2693	12-sep-2006 14:03:36	0119545000                    	Patt Price          	          15707	               2693	IND            	En                                                                                                                                                    	           2016	CR                            	Y                   	RC                  	RC                  	                    	                    	
              3000	 	               	           2694	12-sep-2006 14:03:37	0120162340                    	Thomas Baker        	          15709	               2694	IND            	En                                                                                                                                                    	           2016	SC                            	Y                   	RC                  	RC                  	                    	                    	
              3000	 	               	           2697	12-sep-2006 14:03:37	0120722110                    	Clifford Jett       	          15711	               2697	IND            	En                                                                                                                                                    	           2016	CR                            	Y                   	RC                  	RC                  	                    	                    	
              3000	 	               	           2699	12-sep-2006 14:03:38	0120987290                    	Lillie Waites       	          15713	               2699	IND            	En                                                                                                                                                    	           2016	CR                            	Y                   	RC                  	RC                  	                    	                    	
              3000	 	               	           2700	12-sep-2006 14:03:39	0121147400                    	Anette O'Neal       	          15715	               2701	IND            	En                                                                                                                                                    	           2016	CR                            	Y                   	RC                  	RC                  	                    	                    	
              3000	 	               	           2702	12-sep-2006 14:03:40	0121488130                    	Cherry Blackwell    	          15716	               2702	IND            	En                                                                                                                                                    	           2016	CR                            	Y                   	RC                  	RC                  	                    	                    	
              3000	 	               	           2705	12-sep-2006 14:03:40	0122210240                    	Peggy Miller        	          15718	               2705	IND            	En                                                                                                                                                    	           2016	CR                            	Y                   	RC                  	RC                  	                    	                    	
              3000	 	               	           2707	12-sep-2006 14:03:42	0122933460                    	Mary McMicken       	          15720	               2708	IND            	En                                                                                                                                                    	           2016	CR                            	Y                   	RC                  	RC                  	                    	                    	
              3000	 	               	           2709	12-sep-2006 14:03:42	0123510520                    	Scott Simmons       	          15723	               2709	IND            	En                                                                                                                                                    	           2016	CR                            	Y                   	RC                  	RC                  	                    	                    	
              3000	 	               	           2712	12-sep-2006 14:03:43	0123963130                    	David Hensley       	          15725	               2712	IND            	En                                                                                                                                                    	           2016	CR                            	Y                   	RC                  	RC                  	                    	                    	
              3000	 	               	           2713	12-sep-2006 14:03:44	0125018700                    	Dru Gallemore       	          15728	               2713	IND            	En                                                                                                                                                    	           2016	CR                            	Y                   	RC                  	RC                  	                    	                    	
              3000	 	               	           2715	12-sep-2006 14:03:45	0125157630                    	Mary Stone          	          15729	               2715	IND            	En                                                                                                                                                    	           2016	CR                            	Y                   	RC                  	RC                  	                    	                    	
              3000	 	               	           2718	12-sep-2006 14:03:46	0125245420                    	Janice Dupree       	          15731	               2718	IND            	En                                                                                                                                                    	           2016	CR                            	Y                   	RC                  	RC                  	                    	                    	
              3000	 	               	           2720	12-sep-2006 14:03:48	0125388720                    	Audrey Norwood      	          15734	               2720	IND            	En                                                                                                                                                    	           2016	CR                            	Y                   	RC                  	RC                  	                    	                    	
              3000	 	               	           2722	12-sep-2006 14:03:49	0125395810                    	Brenda Walden       	          15736	               2722	IND            	En                                                                                                                                                    	           2016	CR                            	Y                   	RC                  	RC                  	                    	                    	
              3000	 	               	           2724	12-sep-2006 14:03:49	0125466850                    	Judy Shoemaker      	          15739	               2724	IND            	En                                                                                                                                                    	           2016	CR                            	Y                   	RC                  	RC                  	                    	                    	
              1005	 	               	           2756	12-sep-2006 14:04:00	0322238770                    	Shield Of Faith Bibl	          15769	               2756	WC             	En                                                                                                                                                    	           2003	BH                            	N                   	BH                  	BH                  	                    	                    	
              3000	 	               	           2757	12-sep-2006 14:04:01	0304483020                    	Debra Young         	          15772	               2757	IND            	En                                                                                                                                                    	           2016	CR                            	Y                   	RC                  	RC                  	                    	                    	
              3000	 	               	           2758	12-sep-2006 14:04:01	0322372160                    	Linda Duncan        	          15771	               2758	IND            	En                                                                                                                                                    	           2016	CR                            	Y                   	RC                  	RC                  	                    	                    	
              3000	 	               	           2759	12-sep-2006 14:04:01	0304647390                    	Ronny Byrd          	          15773	               2759	IND            	En                                                                                                                                                    	           2016	CR                            	Y                   	RC                  	RC                  	                    	                    	
              3000	 	               	           2760	12-sep-2006 14:04:01	0322491610                    	Karon Stanley       	          15774	               2760	IND            	En                                                                                                                                                    	           2016	CR                            	Y                   	RC                  	RC                  	                    	                    	
              3000	 	               	           2761	12-sep-2006 14:04:02	0304833410                    	Reginal Hill        	          15775	               2761	IND            	En                                                                                                                                                    	           2016	CR                            	Y                   	RC                  	RC                  	                    	                    	
              3000	 	               	           2762	12-sep-2006 14:04:02	0322651180                    	Hazel Mock          	          15776	               2762	IND            	En                                                                                                                                                    	           2016	CR                            	Y                   	RC                  	RC                  	                    	                    	
              3000	 	               	           2763	12-sep-2006 14:04:03	0322768420                    	Betty Wada          	          15777	               2763	IND            	En                                                                                                                                                    	           2016	SC                            	Y                   	RC                  	RC                  	                    	                    	
              1005	 	               	           2764	12-sep-2006 14:04:03	0305228250                    	Bob Jones University	          15778	               2764	WC             	En                                                                                                                                                    	           2003	BH                            	N                   	BH                  	BH                  	                    	                    	
              3000	 	               	           2765	12-sep-2006 14:04:04	0305829930                    	Florence Miller     	          15779	               2765	IND            	En                                                                                                                                                    	           2016	CR                            	Y                   	RC                  	RC                  	                    	                    	
              3000	 	               	           2766	12-sep-2006 14:04:04	0323198570                    	Dorothy Thurman     	          15780	               2766	IND            	En                                                                                                                                                    	           2016	CR                            	Y                   	RC                  	RC                  	                    	                    	
              3000	 	               	           2767	12-sep-2006 14:04:04	0306256850                    	Ann Ridgell         	          15781	               2767	IND            	En                                                                                                                                                    	           2016	CR                            	Y                   	RC                  	RC                  	                    	                    	
              3000	 	               	           2768	12-sep-2006 14:04:04	0323282390                    	Madeline Thomas     	          15782	               2768	IND            	En                                                                                                                                                    	           2016	CR                            	Y                   	RC                  	RC                  	                    	                    	
              3000	 	               	           2769	12-sep-2006 14:04:04	0306844350                    	Peggy White         	          15783	               2769	IND            	En                                                                                                                                                    	           2016	SC                            	Y                   	RC                  	RC                  	                    	                    	
              3000	 	               	           2770	12-sep-2006 14:04:05	0323340050                    	Mildred Cantrell    	          15784	               2770	IND            	En                                                                                                                                                    	           2016	CR                            	Y                   	RC                  	RC                  	                    	                    	
              3000	 	               	           2771	12-sep-2006 14:04:05	0307064280                    	Jo Collins          	          15785	               2771	IND            	En                                                                                                                                                    	           2016	CR                            	Y                   	RC                  	RC                  	                    	                    	
              3000	 	               	           2772	12-sep-2006 14:04:06	0307180010                    	J F Ellis           	          15787	               2772	IND            	En                                                                                                                                                    	           2016	CR                            	Y                   	RC                  	RC                  	                    	                    	
              3000	 	               	           2773	12-sep-2006 14:04:06	0323600000                    	Glenda McDonald     	          15786	               2773	IND            	En                                                                                                                                                    	           2016	CR                            	Y                   	RC                  	RC                  	                    	                    	
              3000	 	               	           2774	12-sep-2006 14:04:06	0307834190                    	Betty Hirz          	          15788	               2774	IND            	En                                                                                                                                                    	           2016	CR                            	Y                   	RC                  	RC                  	                    	                    	
              3000	 	               	           2775	12-sep-2006 14:04:06	0323648200                    	Jere Barnthouse     	          15789	               2775	IND            	En                                                                                                                                                    	           2001	CR                            	Y                   	RC                  	RC                  	                    	                    	
              3000	 	               	           2776	12-sep-2006 14:04:07	0324105990                    	Cheryl Hale         	          15790	               2776	IND            	En                                                                                                                                                    	           2016	CR                            	Y                   	RC                  	RC                  	                    	                    	
              3000	 	               	           2777	12-sep-2006 14:04:07	0308371080                    	Brenda Stewart      	          15791	               2777	IND            	En                                                                                                                                                    	           2016	CR                            	Y                   	RC                  	RC                  	                    	                    	
              3000	 	               	           2778	12-sep-2006 14:04:07	0308950980                    	Lynda Neely         	          15792	               2778	IND            	En                                                                                                                                                    	           2016	CR                            	Y                   	RC                  	RC                  	                    	                    	
              3000	 	               	           2779	12-sep-2006 14:04:07	0324478560                    	Mary Griffin        	          15793	               2779	IND            	En                                                                                                                                                    	           2016	CR                            	Y                   	RC                  	RC                  	                    	                    	
              3000	 	               	           2780	12-sep-2006 14:04:08	0309083390                    	Bobbye Verbois      	          15794	               2780	IND            	En                                                                                                                                                    	           2016	CR                            	Y                   	RC                  	RC                  	                    	                    	
              3000	 	               	           2781	12-sep-2006 14:04:08	0324518900                    	James Hughes        	          15795	               2781	IND            	En                                                                                                                                                    	           2016	CR                            	Y                   	RC                  	RC                  	                    	                    	
  C-c C-c              3000	 	               	           2782	12-sep-2006 14:04:09	0324694880                    	Judy Lee            	          15797	               2782	IND            	En                                                                                                                                                    	           2016	SC                            	Y                   	RC                  	RC                  	                    	                    	
              3000	 	               	           2783	12-sep-2006 14:04:09	0309403810                    	Kathy Thomas        	          15796	               2783	IND            	En                                                                                                                                                    	           2016	CR                            	Y                   	RC                  	RC                  	                    	                    	
              3000	 	               	           2784	12-sep-2006 14:04:09	0324897590                    	Sharon Forrester    	          15799	               2784	IND            	En                                                                                                                                                    	           2016	CR                            	Y                   	RC                  	RC                  	                    	                    	
              3000	 	               	           2785	12-sep-2006 14:04:09	0309615100                    	Irene Stone         	          15798	               2785	IND            	En                                                                                                                                                    	           2016	CR                            	Y                   	RC                  	RC                  	                    	                    	
              3000	 	               	           2786	12-sep-2006 14:04:10	0325107860                    	Vivian Wilson       	          15800	               2786	IND            	En                                                                                                                                                    	           2016	CR                            	Y                   	RC                  	RC                  	                    	                    	
              3000	 	               	           2787	12-sep-2006 14:04:11	0325502460                    	Betty Lewis         	          15802	               2787	IND            	En                                                                                                                                                    	           2016	CR                            	Y                   	RC                  	RC                  	                    	                    	
              3000	 	               	           2788	12-sep-2006 14:04:11	0310097640                    	Cheryl Power        	          15801	               2788	IND            	En                                                                                                                                                    	           2016	CR                            	Y                   	RC                  	RC                  	                    	                    	
              3000	 	               	           2789	12-sep-2006 14:04:11	0325759040                    	David Giffin        	          15803	               2789	IND            	En                                                                                                                                                    	           2016	SC                            	Y                   	RC                  	RC                  	                    	                    	
              3000	 	               	           2790	12-sep-2006 14:04:11	0326138200                    	Ann Syfrett         	          15805	               2790	IND            	En                                                                                                                                                    	           2016	CR                            	Y                   	RC                  	RC                  	                    	                    	
              3000	 	               	           2791	12-sep-2006 14:04:11	0310295150                    	Franklin Pierce     	          15804	               2791	IND            	En                                                                                                                                                    	           2016	CR                            	Y                   	RC                  	RC                  	                    	                    	

160 rows selected.

Elapsed: 00:00:12.89

rstewar@TEST
SQL> l
  1  select *
  2  from (
  3        SELECT sc.STATEMENT_CYCLE_ID,
  4               null LANGUAGE,
  5               hcp.SITE_USE_ID,
  6               ac.cust_account_id CUSTOMER_ID,
  7  	     ac.creation_date, -- needed as a substitute for the "last statement date" when there are no past statements
  8               ac.account_number CUSTOMER_NUMBER,
  9               hp.party_name CUSTOMER_NAME,
 10               ac.PARTY_ID,
 11               hCP.CUST_ACCOUNT_PROFILE_ID CUSTOMER_PROFILE_ID,
 12               sc.name STATEMENT_CYCLE_NAME,
 13               ac.ATTRIBUTE1,
 14               hcp.COLLECTOR_ID,
 15               ac.sales_channel_code,
 16               nvl(hcp.attribute1,'N') new_cons_inv_flag,
 17               -- Determine Logo Code (can be different at header and line levels)
 18               CASE
 19                 WHEN sc.name = 'WS' THEN 'SD'
 20                 WHEN sc.name = 'WC' THEN 'BH'
 21                 WHEN sclv.logo_code = 'CE' THEN 'RC'
 22                 WHEN sclv.logo_code = 'OI' THEN 'BH'
 23                 WHEN sc.name = 'WF' and upper(ac.attribute1) = 'ES' THEN 'BISP'
 24                 WHEN sc.name = 'WF' THEN 'BI'
 25                 ELSE sclv.logo_code
 26               END hdr_logo_code,
 27               CASE
 28                 WHEN sc.name = 'WS' THEN 'SD'
 29                 WHEN sc.name = 'WC' THEN 'BH'
 30                 WHEN sc.name = 'WF' and upper(ac.attribute1) = 'ES' THEN 'BISP'
 31                 WHEN sc.name = 'WF' THEN 'BI'
 32                 ELSE sclv.logo_code
 33               END line_logo_code,
 34               sclv.stmt_msg1,
 35               sclv.stmt_msg2,
 36               ac.attribute12 CUST_EMAIL_ADR
 37          FROM apps.HZ_CUST_ACCOUNTS        ac,
 38               apps.hz_parties              hp,
 39               apps.ar_statement_cycles     sc,
 40               apps.HZ_CUST_PROFILE_CLASSES hcpc,
 41               apps.HZ_CUSTOMER_PROFILES    hcp,
 42               (-- Statement Logo Code and Messages Sub-table - based on Sales Channel
 43                SELECT flv.lookup_code, flv.attribute3 logo_code,
 44                       flv.attribute6 stmt_msg1, flv.attribute7 stmt_msg2
 45                FROM apps.FND_LOOKUP_VALUES_VL flv
 46                WHERE flv.LOOKUP_TYPE = 'SALES_CHANNEL'
 47                -- Only get ONT - Order Mgmt lookups
 48                AND view_application_id = 660) sclv
 49         WHERE ac.cust_account_id = hcp.cust_account_id
 50           AND hcp.SITE_USE_ID IS NULL
 51           -- AND sc.NAME = :p_statement_cycle_nme
 52           AND sc.statement_cycle_id = hcp.statement_cycle_id
 53           AND hcpc.profile_class_id(+) = hcp.profile_class_id
 54           AND ac.account_NUMBER = NVL(:p_customer_nbr, ac.account_NUMBER)
 55           AND ac.party_id = hp.party_id
 56           AND hcp.send_STATEMENTS = 'Y'
 57           AND ac.sales_channel_code = sclv.lookup_code (+)
 58* )
rstewar@TEST
SQL> select * from (
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
) where rownum < 21;

and    lwx_ar_query.get_balance(hca.cust_account_id,'NO') <> 0
       *
ERROR at line 11:
ORA-00904: "LWX_AR_QUERY"."GET_BALANCE": invalid identifier


Elapsed: 00:00:00.14
rstewar@TEST
SQL> select * from (
select hca.account_number,
       hca.cust_account_id,
       hca.creation_date,
       lwx_ar_query.get_balance(hca.cust_account_id,'NO') bal
from   ar.hz_cust_accounts    hca,
       ar.hz_customer_profiles hcp
where  hca.creation_date >= to_date('01-NOV-2019','DD-MON-YYYY')
and    hca.cust_account_id = hcp.cust_account_id
and    hcp.site_use_id is null
and    apps.lwx_ar_query.get_balance(hca.cust_account_id,'NO') <> 0
and    hca.account_number not in
(
select sh.send_to_cust_nbr
from   lwx.lwx_ar_stmt_headers sh
where  sh.send_to_cust_nbr = hca.account_number)
) where rownum < 21;

       lwx_ar_query.get_balance(hca.cust_account_id,'NO') bal
       *
ERROR at line 5:
ORA-00904: "LWX_AR_QUERY"."GET_BALANCE": invalid identifier


Elapsed: 00:00:00.13
rstewar@TEST
SQL> select * from (
select hca.account_number,
       hca.cust_account_id,
       hca.creation_date,
       apps.lwx_ar_query.get_balance(hca.cust_account_id,'NO') bal
from   ar.hz_cust_accounts    hca,
       ar.hz_customer_profiles hcp
where  hca.creation_date >= to_date('01-NOV-2019','DD-MON-YYYY')
and    hca.cust_account_id = hcp.cust_account_id
and    hcp.site_use_id is null
and    apps.lwx_ar_query.get_balance(hca.cust_account_id,'NO') <> 0
and    hca.account_number not in
(
select sh.send_to_cust_nbr
from   lwx.lwx_ar_stmt_headers sh
where  sh.send_to_cust_nbr = hca.account_number)
) where rownum < 21;


ACCOUNT_NUMBER                	CUST_ACCOUNT_ID	CREATION_DATE       	            BAL
------------------------------	---------------	--------------------	---------------
2002518796                    	       22324523	02-nov-2019 10:05:12	          -6.68
2002551780                    	       22415928	04-dec-2019 18:15:12	            -25
2002553412                    	       22417709	05-dec-2019 19:50:33	         -27.22
2002530045                    	       22345111	14-nov-2019 17:10:26	          -9.19
2002555491                    	       22419907	07-dec-2019 12:25:15	         -38.95
2002556172                    	       22420588	07-dec-2019 22:45:12	         -44.29
2002552383                    	       22416540	05-dec-2019 10:10:11	         -58.51
2002553079                    	       22417347	05-dec-2019 15:19:35	            -10
2002554819                    	       22419235	06-dec-2019 20:25:30	          -23.3
2002540028                    	       22402749	26-nov-2019 02:55:10	            -10
2002554392                    	       22418804	06-dec-2019 14:40:19	            -40
2002554807                    	       22419223	06-dec-2019 20:15:33	            -50
2002527440                    	       22338940	12-nov-2019 10:42:24	           6.78
2002554361                    	       22418770	06-dec-2019 14:24:18	            -40
2002536595                    	       22397275	21-nov-2019 16:30:20	            -25
2002546868                    	       22410263	02-dec-2019 08:50:22	         -12.78
2002531268                    	       22346429	16-nov-2019 10:15:14	            -19
2002554028                    	       22418380	06-dec-2019 10:58:54	            -10
2002544261                    	       22407633	30-nov-2019 08:00:17	         -63.27
2002547671                    	       22411179	02-dec-2019 13:56:10	          -13.5

20 rows selected.

Elapsed: 00:00:08.27
rstewar@TEST
SQL> rem THANKS TO THE ABOVE QUERYING (PROVIDED VIA GREG WRIGHT) I'M GOING TO TRY customer_Number = 2002527440.
rstewar@TEST
SQL> rem OKAY, *THAT* "TEST-RUN" IN TEST-INSTANCE DID PRODUCE SOMETHING WORTHWHILE.  SO I SHALL SAVE THIS TRANSCRIPT ALONG WITH THOSE RESULTS.
rstewar@TEST
SQL> exit
Disconnected from Oracle Database 11g Enterprise Edition Release 11.2.0.3.0 - 64bit Production
With the Partitioning, Automatic Storage Management, OLAP and Data Mining options

Process SQL finished

