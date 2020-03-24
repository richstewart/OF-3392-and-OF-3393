
SQL*Plus: Release 10.1.0.5.0 - Production on Thu Mar 5 14:57:36 2020

Copyright (c) 1982, 2005, Oracle.  All rights reserved.


Connected to:
Oracle Database 11g Enterprise Edition Release 11.2.0.3.0 - 64bit Production
With the Partitioning, Automatic Storage Management, OLAP and Data Mining options

Logged in at: Thu 05-mar-2020 02:57:37 pm

apps@DEV
SQL> select *
from 


  3  apps@DEV
SQL> clear sql
sql cleared
apps@DEV
SQL> @desc apps.lwx_ar_stmt_headers
 Name                                                              Null?    Type
 ----------------------------------------------------------------- -------- --------------------------------------------
 STMT_HDR_ID                                                       NOT NULL NUMBER(22)
 STATEMENT_CYCLE_ID                                                NOT NULL NUMBER(15)
 STMT_RUN_CONC_REQ_ID                                                       NUMBER(22)
 STMT_DTE                                                          NOT NULL DATE
 STMT_CRNCY_CDE                                                    NOT NULL VARCHAR2(15)
 STMT_LANG_CDE                                                     NOT NULL VARCHAR2(3)
 PPD_PAGE_CNT                                                               NUMBER(22)
 DTL_PAGE_CNT                                                               NUMBER(22)
 INVO_PAGE_CNT                                                              NUMBER(22)
 TOTAL_PAGE_CNT                                                             NUMBER(22)
 LOGO_CDE                                                                   VARCHAR2(30)
 SEND_TO_CUST_ACCT_SITE_ID                                         NOT NULL NUMBER(22)
 SEND_TO_CUST_NBR                                                  NOT NULL VARCHAR2(30)
 SEND_TO_CUST_NME                                                  NOT NULL VARCHAR2(360)
 SEND_TO_LINE_1_ADR                                                         VARCHAR2(240)
 SEND_TO_LINE_2_ADR                                                         VARCHAR2(240)
 SEND_TO_LINE_3_ADR                                                         VARCHAR2(240)
 SEND_TO_LINE_4_ADR                                                         VARCHAR2(240)
 SEND_TO_CITY_NME                                                           VARCHAR2(60)
 SEND_TO_STATE_CDE                                                          VARCHAR2(5)
 SEND_TO_POSTAL_CDE                                                         VARCHAR2(12)
 SEND_TO_CNTRY_NME                                                          VARCHAR2(60)
 REP_PHONE_NBR                                                              VARCHAR2(30)
 OVER_DUE_AMT                                                               NUMBER
 DUE_AMT                                                                    NUMBER
 TO_PAY_AMT                                                                 NUMBER
 STMT_DUE_DTE                                                               DATE
 NOT_DUE_AMT                                                                NUMBER
 BALANCE_AMT                                                                NUMBER
 MSG1_NME                                                                   VARCHAR2(40)
 MSG2_NME                                                                   VARCHAR2(40)
 SCAN_LINE_NME                                                              VARCHAR2(50)
 LW_FAX_NBR                                                                 VARCHAR2(50)
 LW_EMAIL_ADR                                                               VARCHAR2(150)
 CREATED_BY                                                        NOT NULL NUMBER(15)
 CREATION_DATE                                                     NOT NULL DATE
 LAST_UPDATED_BY                                                   NOT NULL NUMBER(15)
 LAST_UPDATED_DATE                                                 NOT NULL DATE
 LAST_UPDATE_LOGIN                                                          NUMBER(15)
 CUST_EMAIL_ADR                                                             VARCHAR2(150)

apps@DEV
SQL> @desc ra_customer_trx_all 
 Name                                                              Null?    Type
 ----------------------------------------------------------------- -------- --------------------------------------------
 CUSTOMER_TRX_ID                                                   NOT NULL NUMBER(15)
 LAST_UPDATE_DATE                                                  NOT NULL DATE
 LAST_UPDATED_BY                                                   NOT NULL NUMBER(15)
 CREATION_DATE                                                     NOT NULL DATE
 CREATED_BY                                                        NOT NULL NUMBER(15)
 LAST_UPDATE_LOGIN                                                          NUMBER(15)
 TRX_NUMBER                                                        NOT NULL VARCHAR2(20)
 CUST_TRX_TYPE_ID                                                  NOT NULL NUMBER(15)
 TRX_DATE                                                          NOT NULL DATE
 SET_OF_BOOKS_ID                                                   NOT NULL NUMBER(15)
 BILL_TO_CONTACT_ID                                                         NUMBER(15)
 BATCH_ID                                                                   NUMBER(15)
 BATCH_SOURCE_ID                                                            NUMBER(15)
 REASON_CODE                                                                VARCHAR2(30)
 SOLD_TO_CUSTOMER_ID                                                        NUMBER(15)
 SOLD_TO_CONTACT_ID                                                         NUMBER(15)
 SOLD_TO_SITE_USE_ID                                                        NUMBER(15)
 BILL_TO_CUSTOMER_ID                                                        NUMBER(15)
 BILL_TO_SITE_USE_ID                                                        NUMBER(15)
 SHIP_TO_CUSTOMER_ID                                                        NUMBER(15)
 SHIP_TO_CONTACT_ID                                                         NUMBER(15)
 SHIP_TO_SITE_USE_ID                                                        NUMBER(15)
 SHIPMENT_ID                                                                NUMBER(15)
 REMIT_TO_ADDRESS_ID                                                        NUMBER(15)
 TERM_ID                                                                    NUMBER(15)
 TERM_DUE_DATE                                                              DATE
 PREVIOUS_CUSTOMER_TRX_ID                                                   NUMBER(15)
 PRIMARY_SALESREP_ID                                                        NUMBER(15)
 PRINTING_ORIGINAL_DATE                                                     DATE
 PRINTING_LAST_PRINTED                                                      DATE
 PRINTING_OPTION                                                            VARCHAR2(20)
 PRINTING_COUNT                                                             NUMBER(15)
 PRINTING_PENDING                                                           VARCHAR2(1)
 PURCHASE_ORDER                                                             VARCHAR2(50)
 PURCHASE_ORDER_REVISION                                                    VARCHAR2(50)
 PURCHASE_ORDER_DATE                                                        DATE
 CUSTOMER_REFERENCE                                                         VARCHAR2(30)
 CUSTOMER_REFERENCE_DATE                                                    DATE
 COMMENTS                                                                   VARCHAR2(1760)
 INTERNAL_NOTES                                                             VARCHAR2(240)
 EXCHANGE_RATE_TYPE                                                         VARCHAR2(30)
 EXCHANGE_DATE                                                              DATE
 EXCHANGE_RATE                                                              NUMBER
 TERRITORY_ID                                                               NUMBER(15)
 INVOICE_CURRENCY_CODE                                                      VARCHAR2(15)
 INITIAL_CUSTOMER_TRX_ID                                                    NUMBER(15)
 AGREEMENT_ID                                                               NUMBER(15)
 END_DATE_COMMITMENT                                                        DATE
 START_DATE_COMMITMENT                                                      DATE
 LAST_PRINTED_SEQUENCE_NUM                                                  NUMBER(15)
 ATTRIBUTE_CATEGORY                                                         VARCHAR2(30)
 ATTRIBUTE1                                                                 VARCHAR2(150)
 ATTRIBUTE2                                                                 VARCHAR2(150)
 ATTRIBUTE3                                                                 VARCHAR2(150)
 ATTRIBUTE4                                                                 VARCHAR2(150)
 ATTRIBUTE5                                                                 VARCHAR2(150)
 ATTRIBUTE6                                                                 VARCHAR2(150)
 ATTRIBUTE7                                                                 VARCHAR2(150)
 ATTRIBUTE8                                                                 VARCHAR2(150)
 ATTRIBUTE9                                                                 VARCHAR2(150)
 ATTRIBUTE10                                                                VARCHAR2(150)
 ORIG_SYSTEM_BATCH_NAME                                                     VARCHAR2(40)
 POST_REQUEST_ID                                                            NUMBER(15)
 REQUEST_ID                                                                 NUMBER(15)
 PROGRAM_APPLICATION_ID                                                     NUMBER(15)
 PROGRAM_ID                                                                 NUMBER(15)
 PROGRAM_UPDATE_DATE                                                        DATE
 FINANCE_CHARGES                                                            VARCHAR2(1)
 COMPLETE_FLAG                                                     NOT NULL VARCHAR2(1)
 POSTING_CONTROL_ID                                                         NUMBER(15)
 BILL_TO_ADDRESS_ID                                                         NUMBER(15)
 RA_POST_LOOP_NUMBER                                                        NUMBER(15)
 SHIP_TO_ADDRESS_ID                                                         NUMBER(15)
 CREDIT_METHOD_FOR_RULES                                                    VARCHAR2(30)
 CREDIT_METHOD_FOR_INSTALLMENTS                                             VARCHAR2(30)
 RECEIPT_METHOD_ID                                                          NUMBER(15)
 ATTRIBUTE11                                                                VARCHAR2(150)
 ATTRIBUTE12                                                                VARCHAR2(150)
 ATTRIBUTE13                                                                VARCHAR2(150)
 ATTRIBUTE14                                                                VARCHAR2(150)
 ATTRIBUTE15                                                                VARCHAR2(150)
 RELATED_CUSTOMER_TRX_ID                                                    NUMBER(15)
 INVOICING_RULE_ID                                                          NUMBER(15)
 SHIP_VIA                                                                   VARCHAR2(30)
 SHIP_DATE_ACTUAL                                                           DATE
 WAYBILL_NUMBER                                                             VARCHAR2(50)
 FOB_POINT                                                                  VARCHAR2(30)
 CUSTOMER_BANK_ACCOUNT_ID                                                   NUMBER(15)
 INTERFACE_HEADER_ATTRIBUTE1                                                VARCHAR2(150)
 INTERFACE_HEADER_ATTRIBUTE2                                                VARCHAR2(150)
 INTERFACE_HEADER_ATTRIBUTE3                                                VARCHAR2(150)
 INTERFACE_HEADER_ATTRIBUTE4                                                VARCHAR2(150)
 INTERFACE_HEADER_ATTRIBUTE5                                                VARCHAR2(150)
 INTERFACE_HEADER_ATTRIBUTE6                                                VARCHAR2(150)
 INTERFACE_HEADER_ATTRIBUTE7                                                VARCHAR2(150)
 INTERFACE_HEADER_ATTRIBUTE8                                                VARCHAR2(150)
 INTERFACE_HEADER_CONTEXT                                                   VARCHAR2(30)
 DEFAULT_USSGL_TRX_CODE_CONTEXT                                             VARCHAR2(30)
 INTERFACE_HEADER_ATTRIBUTE10                                               VARCHAR2(150)
 INTERFACE_HEADER_ATTRIBUTE11                                               VARCHAR2(150)
 INTERFACE_HEADER_ATTRIBUTE12                                               VARCHAR2(150)
 INTERFACE_HEADER_ATTRIBUTE13                                               VARCHAR2(150)
 INTERFACE_HEADER_ATTRIBUTE14                                               VARCHAR2(150)
 INTERFACE_HEADER_ATTRIBUTE15                                               VARCHAR2(150)
 INTERFACE_HEADER_ATTRIBUTE9                                                VARCHAR2(150)
 DEFAULT_USSGL_TRANSACTION_CODE                                             VARCHAR2(30)
 RECURRED_FROM_TRX_NUMBER                                                   VARCHAR2(20)
 STATUS_TRX                                                                 VARCHAR2(30)
 DOC_SEQUENCE_ID                                                            NUMBER(15)
 DOC_SEQUENCE_VALUE                                                         NUMBER(15)
 PAYING_CUSTOMER_ID                                                         NUMBER(15)
 PAYING_SITE_USE_ID                                                         NUMBER(15)
 RELATED_BATCH_SOURCE_ID                                                    NUMBER(15)
 DEFAULT_TAX_EXEMPT_FLAG                                                    VARCHAR2(1)
 CREATED_FROM                                                      NOT NULL VARCHAR2(30)
 ORG_ID                                                                     NUMBER(15)
 WH_UPDATE_DATE                                                             DATE
 GLOBAL_ATTRIBUTE1                                                          VARCHAR2(150)
 GLOBAL_ATTRIBUTE2                                                          VARCHAR2(150)
 GLOBAL_ATTRIBUTE3                                                          VARCHAR2(150)
 GLOBAL_ATTRIBUTE4                                                          VARCHAR2(150)
 GLOBAL_ATTRIBUTE5                                                          VARCHAR2(150)
 GLOBAL_ATTRIBUTE6                                                          VARCHAR2(150)
 GLOBAL_ATTRIBUTE7                                                          VARCHAR2(150)
 GLOBAL_ATTRIBUTE8                                                          VARCHAR2(150)
 GLOBAL_ATTRIBUTE9                                                          VARCHAR2(150)
 GLOBAL_ATTRIBUTE10                                                         VARCHAR2(150)
 GLOBAL_ATTRIBUTE11                                                         VARCHAR2(150)
 GLOBAL_ATTRIBUTE12                                                         VARCHAR2(150)
 GLOBAL_ATTRIBUTE13                                                         VARCHAR2(150)
 GLOBAL_ATTRIBUTE14                                                         VARCHAR2(150)
 GLOBAL_ATTRIBUTE15                                                         VARCHAR2(150)
 GLOBAL_ATTRIBUTE16                                                         VARCHAR2(150)
 GLOBAL_ATTRIBUTE17                                                         VARCHAR2(150)
 GLOBAL_ATTRIBUTE18                                                         VARCHAR2(150)
 GLOBAL_ATTRIBUTE19                                                         VARCHAR2(150)
 GLOBAL_ATTRIBUTE20                                                         VARCHAR2(150)
 GLOBAL_ATTRIBUTE21                                                         VARCHAR2(150)
 GLOBAL_ATTRIBUTE22                                                         VARCHAR2(150)
 GLOBAL_ATTRIBUTE23                                                         VARCHAR2(150)
 GLOBAL_ATTRIBUTE24                                                         VARCHAR2(150)
 GLOBAL_ATTRIBUTE25                                                         VARCHAR2(150)
 GLOBAL_ATTRIBUTE26                                                         VARCHAR2(150)
 GLOBAL_ATTRIBUTE27                                                         VARCHAR2(150)
 GLOBAL_ATTRIBUTE28                                                         VARCHAR2(150)
 GLOBAL_ATTRIBUTE29                                                         VARCHAR2(150)
 GLOBAL_ATTRIBUTE30                                                         VARCHAR2(150)
 GLOBAL_ATTRIBUTE_CATEGORY                                                  VARCHAR2(30)
 EDI_PROCESSED_FLAG                                                         VARCHAR2(1)
 EDI_PROCESSED_STATUS                                                       VARCHAR2(10)
 MRC_EXCHANGE_RATE_TYPE                                                     VARCHAR2(2000)
 MRC_EXCHANGE_DATE                                                          VARCHAR2(2000)
 MRC_EXCHANGE_RATE                                                          VARCHAR2(2000)
 PAYMENT_SERVER_ORDER_NUM                                                   VARCHAR2(80)
 APPROVAL_CODE                                                              VARCHAR2(80)
 ADDRESS_VERIFICATION_CODE                                                  VARCHAR2(80)
 OLD_TRX_NUMBER                                                             VARCHAR2(20)
 BR_AMOUNT                                                                  NUMBER
 BR_UNPAID_FLAG                                                             VARCHAR2(1)
 BR_ON_HOLD_FLAG                                                            VARCHAR2(1)
 DRAWEE_ID                                                                  NUMBER(15)
 DRAWEE_CONTACT_ID                                                          NUMBER(15)
 DRAWEE_SITE_USE_ID                                                         NUMBER(15)
 REMITTANCE_BANK_ACCOUNT_ID                                                 NUMBER(15)
 OVERRIDE_REMIT_ACCOUNT_FLAG                                                VARCHAR2(1)
 DRAWEE_BANK_ACCOUNT_ID                                                     NUMBER(15)
 SPECIAL_INSTRUCTIONS                                                       VARCHAR2(240)
 REMITTANCE_BATCH_ID                                                        NUMBER(15)
 PREPAYMENT_FLAG                                                            VARCHAR2(1)
 CT_REFERENCE                                                               VARCHAR2(150)
 CONTRACT_ID                                                                NUMBER
 BILL_TEMPLATE_ID                                                           NUMBER(15)
 REVERSED_CASH_RECEIPT_ID                                                   NUMBER(15)
 CC_ERROR_CODE                                                              VARCHAR2(80)
 CC_ERROR_TEXT                                                              VARCHAR2(255)
 CC_ERROR_FLAG                                                              VARCHAR2(1)
 UPGRADE_METHOD                                                             VARCHAR2(30)
 LEGAL_ENTITY_ID                                                            NUMBER(15)
 REMIT_BANK_ACCT_USE_ID                                                     NUMBER(15)
 PAYMENT_TRXN_EXTENSION_ID                                                  NUMBER(15)
 AX_ACCOUNTED_FLAG                                                          VARCHAR2(1)
 APPLICATION_ID                                                             NUMBER(15)
 PAYMENT_ATTRIBUTES                                                         VARCHAR2(1000)
 BILLING_DATE                                                               DATE
 INTEREST_HEADER_ID                                                         NUMBER(15)
 LATE_CHARGES_ASSESSED                                                      VARCHAR2(30)
 TRAILER_NUMBER                                                             VARCHAR2(50)

apps@DEV
SQL> select hca.account_number,
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


ACCOUNT_NUMBER                	CUST_ACCOUNT_ID	CREATION_DATE       	            BAL
------------------------------	---------------	--------------------	---------------
2002564539                    	       22430178	14-DEC-2019 18:30:12	          16.63
2002565459                    	       22431098	15-DEC-2019 21:55:21	          17.92
2002565244                    	       22430883	15-DEC-2019 18:00:33	          22.29
2002567054                    	       22438259	17-DEC-2019 11:35:17	             50
2002541065                    	       22403988	27-NOV-2019 06:40:10	          23.47
2002565483                    	       22431122	15-DEC-2019 22:26:34	          44.92
2002539223                    	       22401830	25-NOV-2019 09:50:09	           3.17
2002520134                    	       22325866	04-NOV-2019 08:45:19	           7.35
2002568065                    	       22439374	18-DEC-2019 08:15:24	             25
2002566180                    	       22431986	16-DEC-2019 15:00:11	          25.67
2002537442                    	       22399284	22-NOV-2019 16:35:08	           4.47
2002519829                    	       22325545	03-NOV-2019 18:55:19	           7.41
2002562729                    	       22428152	12-DEC-2019 22:40:26	          11.68
2002566024                    	       22431788	16-DEC-2019 13:15:16	           82.8
2002565409                    	       22431048	15-DEC-2019 20:55:18	          21.64
2002562125                    	       22427451	12-DEC-2019 12:50:08	         103.72
2002562136                    	       22427462	12-DEC-2019 12:50:16	          30.93
2002566851                    	       22437336	17-DEC-2019 08:38:26	           23.3
2002566967                    	       22437487	17-DEC-2019 10:20:41	          36.03
2002565791                    	       22431501	16-DEC-2019 10:30:16	          26.03
2002566569                    	       22432421	16-DEC-2019 21:22:38	          48.31
2002559544                    	       22424265	10-DEC-2019 09:15:46	           55.1
2002556957                    	       22421373	08-DEC-2019 15:15:15	          20.68
2002566292                    	       22432132	16-DEC-2019 16:35:23	          68.57
2002565322                    	       22430961	15-DEC-2019 19:45:09	          30.88
2002565405                    	       22431044	15-DEC-2019 20:55:13	          25.43
2002553079                    	       22417347	05-DEC-2019 15:19:35	            -10
2002554819                    	       22419235	06-DEC-2019 20:25:30	           2.12
2002567097                    	       22438312	17-DEC-2019 11:55:27	          49.32
2002564987                    	       22430626	15-DEC-2019 12:36:08	          17.07
2002565206                    	       22430845	15-DEC-2019 17:20:12	          19.64
2002566782                    	       22437254	17-DEC-2019 06:40:11	           3.99
2002567053                    	       22438258	17-DEC-2019 11:35:16	         169.89
2002537871                    	       22400444	23-NOV-2019 11:25:08	         -98.31
2002565376                    	       22431015	15-DEC-2019 20:35:11	           17.5
2002566496                    	       22432348	16-DEC-2019 20:40:11	          99.93
2002565021                    	       22430660	15-DEC-2019 13:30:11	          68.34
2002567062                    	       22438250	17-DEC-2019 11:40:41	         -130.7
2002567773                    	       22439075	17-DEC-2019 22:20:57	         -20.06
2002566108                    	       22431890	16-DEC-2019 14:03:55	          95.03
2002566662                    	       22434240	17-DEC-2019 00:10:38	          18.18
2002538072                    	       22400645	23-NOV-2019 15:45:11	          10.71
2002566544                    	       22432396	16-DEC-2019 21:04:20	             25
2002538498                    	       22401072	24-NOV-2019 10:55:19	            .99
2002566324                    	       22432169	16-DEC-2019 17:05:11	          68.55
2002565357                    	       22430996	15-DEC-2019 20:15:34	           9.89
2002564421                    	       22430060	14-DEC-2019 15:40:11	         111.01
2002566855                    	       22437344	17-DEC-2019 08:40:21	          97.59
2002565734                    	       22431426	16-DEC-2019 09:40:19	          14.97
2002566806                    	       22437280	17-DEC-2019 07:45:11	           17.6
2002567584                    	       22438886	17-DEC-2019 20:15:36	            -25
2002566534                    	       22432386	16-DEC-2019 21:02:38	          30.58
2002565247                    	       22430886	15-DEC-2019 18:10:09	          16.29
2002565433                    	       22431072	15-DEC-2019 21:15:20	          39.23
2002565335                    	       22430974	15-DEC-2019 19:55:21	          30.08
2002564977                    	       22430616	15-DEC-2019 12:21:10	          17.95
2002566540                    	       22432392	16-DEC-2019 21:03:54	             50
2002565586                    	       22431226	16-DEC-2019 07:20:10	           9.18
2002541728                    	       22404784	27-NOV-2019 21:11:20	          21.39
2002531268                    	       22346429	16-NOV-2019 10:15:14	            -19
2002525655                    	       22336134	10-NOV-2019 17:35:19	            .01
2002526761                    	       22338230	11-NOV-2019 17:15:15	            .01
2002565432                    	       22431071	15-DEC-2019 21:15:18	           16.5
2002566357                    	       22432208	16-DEC-2019 17:50:21	          69.54
2002565109                    	       22430748	15-DEC-2019 15:15:39	          16.29
2002561846                    	       22427086	12-DEC-2019 08:28:50	         -16.24
2002566754                    	       22437226	17-DEC-2019 05:50:09	          32.62
2002562254                    	       22427613	12-DEC-2019 14:05:24	          21.49
2002566776                    	       22437248	17-DEC-2019 06:30:17	          17.03
2002566414                    	       22432266	16-DEC-2019 19:05:20	          12.83
2002566819                    	       22437296	17-DEC-2019 08:05:11	          21.65
2002565038                    	       22430677	15-DEC-2019 13:50:08	          15.07
2002565436                    	       22431075	15-DEC-2019 21:25:11	          32.02
2002565349                    	       22430988	15-DEC-2019 20:05:33	          19.26
2002558775                    	       22423416	09-DEC-2019 15:47:33	           4.99
2002545228                    	       22408600	30-NOV-2019 21:15:10	          96.25
2002565442                    	       22431081	15-DEC-2019 21:35:10	          75.58
2002557473                    	       22421889	08-DEC-2019 21:00:08	          37.61
2002552874                    	       22417109	05-DEC-2019 13:40:23	           9.51
2002565301                    	       22430940	15-DEC-2019 19:15:13	          11.29
2002555610                    	       22420026	07-DEC-2019 14:15:11	          10.81
2002565435                    	       22431074	15-DEC-2019 21:25:11	           32.5
2002567064                    	       22438272	17-DEC-2019 11:45:11	             25
2002550499                    	       22414421	03-DEC-2019 20:40:27	          93.28
2002524127                    	       22334534	08-NOV-2019 11:05:39	         -16.75
2002565216                    	       22430855	15-DEC-2019 17:40:12	          52.17
2002565792                    	       22431502	16-DEC-2019 10:30:18	          38.86
2002567013                    	       22438209	17-DEC-2019 11:05:21	        -123.66
2002562165                    	       22427498	12-DEC-2019 13:10:24	             15
2002559440                    	       22424131	10-DEC-2019 08:03:29	          37.61
2002566305                    	       22432147	16-DEC-2019 16:45:31	          10.99
2002566424                    	       22432276	16-DEC-2019 19:15:10	          16.14
2002565735                    	       22431427	16-DEC-2019 09:43:53	          102.7
2002565462                    	       22431101	15-DEC-2019 22:05:11	          10.28
2002565053                    	       22430692	15-DEC-2019 14:15:13	           31.5
2002563912                    	       22429550	13-DEC-2019 23:30:09	          20.37
2002566558                    	       22432410	16-DEC-2019 21:21:02	          49.21
2002565821                    	       22431536	16-DEC-2019 10:55:37	         -61.08
2002567503                    	       22438808	17-DEC-2019 18:50:07	           6.58
2002553534                    	       22417831	05-DEC-2019 21:21:33	         -16.75
2002565370                    	       22431009	15-DEC-2019 20:25:22	          52.49
2002561570                    	       22426803	11-DEC-2019 20:30:21	          16.04
2002564324                    	       22429963	14-DEC-2019 13:55:23	          14.19
2002564723                    	       22430362	14-DEC-2019 23:15:21	          32.62
2002565728                    	       22431420	16-DEC-2019 09:40:14	          56.17
2002565308                    	       22430947	15-DEC-2019 19:25:10	          25.66
2002566627                    	       22432479	16-DEC-2019 22:36:39	          56.16
2002565494                    	       22431133	15-DEC-2019 23:05:16	          134.9
2002566690                    	       22434268	17-DEC-2019 00:50:08	          12.71
2002566288                    	       22432128	16-DEC-2019 16:35:17	          25.67
2002565260                    	       22430899	15-DEC-2019 18:20:18	          34.22
2002566780                    	       22437252	17-DEC-2019 06:40:08	          17.19
2002566241                    	       22432067	16-DEC-2019 16:05:17	          21.19
2002558772                    	       22423390	09-DEC-2019 15:45:27	          89.84
2002566169                    	       22431973	16-DEC-2019 14:50:09	          15.22
2002565796                    	       22431506	16-DEC-2019 10:35:17	            -40
2002565823                    	       22431541	16-DEC-2019 11:00:11	           28.7
2002567040                    	       22438241	17-DEC-2019 11:25:21	          19.11
2002567194                    	       22438428	17-DEC-2019 13:06:19	          99.72
2002566154                    	       22431955	16-DEC-2019 14:40:13	             60
2002566302                    	       22432144	16-DEC-2019 16:45:26	          11.81
2002565489                    	       22431128	15-DEC-2019 22:42:12	          21.09
2002566059                    	       22431835	16-DEC-2019 13:40:26	           47.9
2002566095                    	       22431877	16-DEC-2019 14:00:41	         129.99
2002566685                    	       22434263	17-DEC-2019 00:30:13	          63.46
2002565235                    	       22430874	15-DEC-2019 18:00:15	          32.12
2002566958                    	       22437478	17-DEC-2019 10:20:20	           -.36
2002566513                    	       22432365	16-DEC-2019 20:50:15	          32.09
2002566528                    	       22432380	16-DEC-2019 21:01:53	          60.27
2002565420                    	       22431059	15-DEC-2019 21:05:16	          19.19
2002567131                    	       22438351	17-DEC-2019 12:15:22	            597
2002565336                    	       22430975	15-DEC-2019 19:55:23	          50.65
2002565502                    	       22431141	15-DEC-2019 23:05:37	          46.51
2002565581                    	       22431221	16-DEC-2019 07:00:12	          27.33
2002566963                    	       22437483	17-DEC-2019 10:20:33	          23.58
2002562189                    	       22427533	12-DEC-2019 13:30:12	           4.92
2002567114                    	       22438331	17-DEC-2019 12:05:22	           87.1
2002566719                    	       22436212	17-DEC-2019 02:05:19	          17.31
2002565395                    	       22431034	15-DEC-2019 20:45:16	          33.54
2002566676                    	       22434254	17-DEC-2019 00:11:14	          37.35
2002565843                    	       22431564	16-DEC-2019 11:15:13	         121.79
2002565783                    	       22431493	16-DEC-2019 10:30:08	          83.54
2002566805                    	       22437279	17-DEC-2019 07:45:10	          11.08
2002566757                    	       22437229	17-DEC-2019 05:50:11	          38.25
2002565290                    	       22430929	15-DEC-2019 19:05:11	          69.73
2002566096                    	       22431878	16-DEC-2019 14:00:48	          11.77
2002565163                    	       22430802	15-DEC-2019 16:30:18	          33.77
2002565267                    	       22430906	15-DEC-2019 18:35:11	          11.24
2002566339                    	       22432187	16-DEC-2019 17:15:22	          21.39
2002565438                    	       22431077	15-DEC-2019 21:25:14	          32.08
2002566326                    	       22432171	16-DEC-2019 17:05:17	          48.86
2002566841                    	       22437324	17-DEC-2019 08:28:33	          69.64
2002566129                    	       22431921	16-DEC-2019 14:20:16	          29.93
2002565234                    	       22430873	15-DEC-2019 18:00:14	          74.61
2002565538                    	       22431177	16-DEC-2019 00:55:09	            .03
2002566492                    	       22432344	16-DEC-2019 20:40:08	          48.43
2002566836                    	       22437318	17-DEC-2019 08:20:11	          40.97
2002566068                    	       22431846	16-DEC-2019 13:50:15	         213.42
2002566242                    	       22432068	16-DEC-2019 16:05:19	          56.43
2002566758                    	       22437230	17-DEC-2019 05:50:12	          24.54
2002566653                    	       22434231	17-DEC-2019 00:10:24	          45.86
2002565042                    	       22430681	15-DEC-2019 13:50:11	         168.97
2002565865                    	       22431592	16-DEC-2019 11:25:28	          52.49
2002566756                    	       22437228	17-DEC-2019 05:50:11	             29
2002566089                    	       22431871	16-DEC-2019 14:00:29	          51.58
2002565724                    	       22431416	16-DEC-2019 09:40:12	          97.98
2002565110                    	       22430749	15-DEC-2019 15:15:40	          56.16
2002565732                    	       22431424	16-DEC-2019 09:40:17	          69.39
2002565407                    	       22431046	15-DEC-2019 20:55:15	          16.47
2002566767                    	       22437239	17-DEC-2019 06:20:08	          29.99
2002566244                    	       22432070	16-DEC-2019 16:05:22	          33.17
2002565264                    	       22430903	15-DEC-2019 18:20:28	          11.66
2002565145                    	       22430784	15-DEC-2019 16:00:23	          26.27
2002565209                    	       22430848	15-DEC-2019 17:20:21	         215.27
2002566771                    	       22437243	17-DEC-2019 06:30:13	          41.99
2002566680                    	       22434258	17-DEC-2019 00:20:15	          53.49
2002565039                    	       22430678	15-DEC-2019 13:50:09	          92.86
2002565166                    	       22430805	15-DEC-2019 16:30:22	           36.4
2002566291                    	       22432131	16-DEC-2019 16:35:22	          44.81
2002565347                    	       22430986	15-DEC-2019 20:05:30	         139.94
2002566612                    	       22432464	16-DEC-2019 22:06:12	          50.22
2002566537                    	       22432389	16-DEC-2019 21:03:31	          74.99
2002564978                    	       22430617	15-DEC-2019 12:21:15	          21.81
2002565060                    	       22430699	15-DEC-2019 14:25:12	          95.39
2002565390                    	       22431029	15-DEC-2019 20:35:27	          20.38
2002565049                    	       22430688	15-DEC-2019 14:00:13	          11.99
2002566531                    	       22432383	16-DEC-2019 21:02:14	          51.53
2002566991                    	       22437517	17-DEC-2019 10:40:21	          11.66
2002564688                    	       22430327	14-DEC-2019 22:13:51	          27.72
2002565044                    	       22430683	15-DEC-2019 13:50:14	          64.35
2002566675                    	       22434253	17-DEC-2019 00:11:11	          56.61
2002565009                    	       22430648	15-DEC-2019 13:10:10	          85.55
2002566258                    	       22432086	16-DEC-2019 16:15:16	          11.13
2002565784                    	       22431494	16-DEC-2019 10:30:11	          10.54
2002566153                    	       22431954	16-DEC-2019 14:40:12	          55.76
2002559467                    	       22424171	10-DEC-2019 08:27:50	          41.11
2002566611                    	       22432463	16-DEC-2019 22:06:10	          23.83
2002565265                    	       22430904	15-DEC-2019 18:20:31	          21.04
2002565197                    	       22430836	15-DEC-2019 17:10:31	           46.1
2002565238                    	       22430877	15-DEC-2019 18:00:19	         172.73
2002566651                    	       22434229	17-DEC-2019 00:10:21	          43.74
2002562250                    	       22427609	12-DEC-2019 14:05:18	           4.68
2002564934                    	       22430573	15-DEC-2019 11:00:25	          41.49
2002566356                    	       22432207	16-DEC-2019 17:50:20	          16.32
2002566128                    	       22431920	16-DEC-2019 14:20:15	          19.29
2002565223                    	       22430862	15-DEC-2019 17:40:23	          65.39
2002565227                    	       22430866	15-DEC-2019 17:40:30	          82.22
2002565404                    	       22431043	15-DEC-2019 20:55:11	          61.42
2002565221                    	       22430860	15-DEC-2019 17:40:18	           8.47
2002567137                    	       22438357	17-DEC-2019 12:15:33	           7.16
2002567104                    	       22438321	17-DEC-2019 12:05:08	           14.7
2002565472                    	       22431111	15-DEC-2019 22:05:49	              8
2002565379                    	       22431018	15-DEC-2019 20:35:14	          16.12
2002565341                    	       22430980	15-DEC-2019 20:05:24	          15.47
2002565845                    	       22431566	16-DEC-2019 11:15:16	         -18.09
2002566505                    	       22432357	16-DEC-2019 20:40:20	          21.18
2002565248                    	       22430887	15-DEC-2019 18:10:11	          11.13
2002566610                    	       22432462	16-DEC-2019 22:06:02	          61.07
2002562234                    	       22427590	12-DEC-2019 13:55:24	          77.03
2002566164                    	       22431966	16-DEC-2019 14:40:21	         108.27
2002566163                    	       22431965	16-DEC-2019 14:40:20	          19.25
2002564733                    	       22430372	14-DEC-2019 23:45:07	          16.09
2002566239                    	       22432065	16-DEC-2019 16:05:14	          165.6
2002566749                    	       22437221	17-DEC-2019 05:20:08	          55.64
2002566499                    	       22432351	16-DEC-2019 20:40:14	          43.88
2002566308                    	       22432150	16-DEC-2019 16:45:35	            8.6
2002567512                    	       22438817	17-DEC-2019 19:00:14	             50
2002566741                    	       22437213	17-DEC-2019 04:30:11	           6.38
2002566848                    	       22437333	17-DEC-2019 08:30:24	          32.64
2002566094                    	       22431876	16-DEC-2019 14:00:39	          69.91
2002566551                    	       22432403	16-DEC-2019 21:20:37	          31.99
2002565297                    	       22430936	15-DEC-2019 19:15:09	          57.23
2002566362                    	       22432213	16-DEC-2019 17:50:28	          53.93
2002566020                    	       22431784	16-DEC-2019 13:15:12	          30.74
2002566113                    	       22431899	16-DEC-2019 14:09:50	          19.28
2002566330                    	       22432176	16-DEC-2019 17:13:01	          96.99
2002562190                    	       22427534	12-DEC-2019 13:30:13	          33.55
2002565064                    	       22430703	15-DEC-2019 14:25:18	          35.76
2002564979                    	       22430618	15-DEC-2019 12:21:21	           9.43
2002565410                    	       22431049	15-DEC-2019 20:55:18	          56.68
2002566367                    	       22432219	16-DEC-2019 18:00:10	          20.32
2002564550                    	       22430189	14-DEC-2019 18:50:09	           83.5
2002566144                    	       22431938	16-DEC-2019 14:30:22	          57.35
2002567078                    	       22438286	17-DEC-2019 11:45:24	             25
2002565492                    	       22431131	15-DEC-2019 23:05:15	          52.49
2002566019                    	       22431783	16-DEC-2019 13:15:09	          15.25
2002566497                    	       22432349	16-DEC-2019 20:40:12	          56.57
2002565564                    	       22431203	16-DEC-2019 06:10:07	          38.51
2002565726                    	       22431418	16-DEC-2019 09:40:13	          34.48
2002565052                    	       22430691	15-DEC-2019 14:15:07	          25.38
2002566070                    	       22431848	16-DEC-2019 13:50:17	          55.09
2002566766                    	       22437238	17-DEC-2019 06:20:07	          12.41
2002562197                    	       22427542	12-DEC-2019 13:39:57	           17.2
2002566652                    	       22434230	17-DEC-2019 00:10:23	          15.99
2002565392                    	       22431031	15-DEC-2019 20:45:14	          16.72
2002565028                    	       22430667	15-DEC-2019 13:30:26	          18.94
2002562220                    	       22427576	12-DEC-2019 13:55:09	           72.2
2002565457                    	       22431096	15-DEC-2019 21:55:18	          16.39
2002565026                    	       22430665	15-DEC-2019 13:30:23	          50.24
2002566146                    	       22431940	16-DEC-2019 14:30:25	          33.94
2002562728                    	       22428151	12-DEC-2019 22:40:26	          -1.06
2002565154                    	       22430793	15-DEC-2019 16:20:13	          23.48
2002566526                    	       22432378	16-DEC-2019 21:01:36	          94.76
2002565241                    	       22430880	15-DEC-2019 18:00:27	          26.21
2002565599                    	       22431243	16-DEC-2019 07:45:14	          30.19
2002566067                    	       22431845	16-DEC-2019 13:50:13	          21.99
2002566550                    	       22432402	16-DEC-2019 21:20:32	            169
2002565445                    	       22431084	15-DEC-2019 21:35:15	          14.57
2002566420                    	       22432272	16-DEC-2019 19:05:40	          57.31
2002566025                    	       22431789	16-DEC-2019 13:15:17	          74.99
2002567058                    	       22438263	17-DEC-2019 11:35:20	          62.99
2002566682                    	       22434260	17-DEC-2019 00:30:11	          37.24
2002566370                    	       22432222	16-DEC-2019 18:00:14	           60.7
2002566538                    	       22432390	16-DEC-2019 21:03:41	          14.77
2002565011                    	       22430650	15-DEC-2019 13:10:12	          25.55
2002566539                    	       22432391	16-DEC-2019 21:03:48	            100
2002566056                    	       22431832	16-DEC-2019 13:40:18	          50.54
2002562123                    	       22427444	12-DEC-2019 12:46:29	           7.44
2002566028                    	       22431792	16-DEC-2019 13:15:21	          43.35
2002566248                    	       22432074	16-DEC-2019 16:05:27	          56.16
2002566659                    	       22434237	17-DEC-2019 00:10:35	          16.23
2002566334                    	       22432182	16-DEC-2019 17:15:17	          47.67
2002565844                    	       22431565	16-DEC-2019 11:15:15	          11.79
2002565840                    	       22431561	16-DEC-2019 11:15:10	         131.72
2002565161                    	       22430800	15-DEC-2019 16:30:12	           38.4
2002566504                    	       22432356	16-DEC-2019 20:40:19	          82.61
2002565377                    	       22431016	15-DEC-2019 20:35:12	          48.56
2002565108                    	       22430747	15-DEC-2019 15:15:38	          38.96
2002566255                    	       22432083	16-DEC-2019 16:15:11	          14.89
2002565487                    	       22431126	15-DEC-2019 22:41:06	          54.11
2002565385                    	       22431024	15-DEC-2019 20:35:20	           19.5
2002566915                    	       22437420	17-DEC-2019 09:35:18	             20
2002565414                    	       22431053	15-DEC-2019 21:05:11	          82.64
2002562238                    	       22427594	12-DEC-2019 13:55:29	          19.63
2002565024                    	       22430663	15-DEC-2019 13:30:17	          14.32
2002566559                    	       22432411	16-DEC-2019 21:21:07	          56.57
2002565133                    	       22430772	15-DEC-2019 15:50:14	          30.48
2002565257                    	       22430896	15-DEC-2019 18:10:24	          -21.2
2002566371                    	       22432223	16-DEC-2019 18:15:13	          21.39
2002563843                    	       22429481	13-DEC-2019 21:05:11	          39.29
2002533047                    	       22348280	18-NOV-2019 13:05:19	           -.46
2002540807                    	       22403730	26-NOV-2019 18:30:09	          23.73
2002547544                    	       22411035	02-DEC-2019 13:02:11	          -7.12
2002561108                    	       22426250	11-DEC-2019 13:20:14	          20.67
2002528730                    	       22343540	13-NOV-2019 11:18:05	             .4
2002564113                    	       22429752	14-DEC-2019 10:05:13	          13.02
2002563929                    	       22429567	14-DEC-2019 00:20:07	         167.71
2002563269                    	       22428786	13-DEC-2019 12:07:06	          44.28
2002567919                    	       22439221	18-DEC-2019 05:30:12	          21.34
2002566926                    	       22437436	17-DEC-2019 09:45:10	          48.28
2002549323                    	       22413004	03-DEC-2019 08:34:22	            .47
2002527457                    	       22338962	12-NOV-2019 10:58:45	           4.06
2002565944                    	       22431693	16-DEC-2019 12:15:08	          18.34
2002565774                    	       22431478	16-DEC-2019 10:20:15	          95.38
2002565771                    	       22431475	16-DEC-2019 10:20:12	          24.41
2002558084                    	       22422565	09-DEC-2019 09:49:25	          16.56
2002564931                    	       22430570	15-DEC-2019 10:50:59	          19.79
2002564837                    	       22430476	15-DEC-2019 08:30:53	         374.86
2002565072                    	       22430711	15-DEC-2019 14:35:17	          45.87
2002565148                    	       22430787	15-DEC-2019 16:10:09	         234.13
2002565076                    	       22430715	15-DEC-2019 14:35:31	           19.5
2002564996                    	       22430635	15-DEC-2019 12:46:01	           24.2
2002565073                    	       22430712	15-DEC-2019 14:35:21	            7.6
2002545903                    	       22409264	01-DEC-2019 15:25:11	         160.49
2002566384                    	       22432236	16-DEC-2019 18:25:16	          33.01
2002566276                    	       22432111	16-DEC-2019 16:25:24	         180.17
2002566381                    	       22432233	16-DEC-2019 18:25:13	          59.99
2002566386                    	       22432238	16-DEC-2019 18:25:18	          58.57
2002566487                    	       22432339	16-DEC-2019 20:30:12	          59.54
2002566488                    	       22432340	16-DEC-2019 20:30:13	           8.62
2002565768                    	       22431471	16-DEC-2019 10:10:18	          56.71
2002566480                    	       22432332	16-DEC-2019 20:15:08	          33.86
2002566489                    	       22432341	16-DEC-2019 20:30:15	          20.88
2002566482                    	       22432334	16-DEC-2019 20:15:10	          21.19
2002565766                    	       22431469	16-DEC-2019 10:10:16	           20.7
2002565763                    	       22431466	16-DEC-2019 10:10:11	          12.52
2002566227                    	       22432046	16-DEC-2019 15:49:42	          46.42
2002566486                    	       22432338	16-DEC-2019 20:30:11	          84.99
2002564243                    	       22429882	14-DEC-2019 12:25:19	          47.27
2002564116                    	       22429755	14-DEC-2019 10:05:18	         206.17
2002566315                    	       22432160	16-DEC-2019 16:55:12	           14.7
2002565908                    	       22431650	16-DEC-2019 11:55:11	          82.57
2002565909                    	       22431651	16-DEC-2019 11:55:12	          19.06
2002565910                    	       22431652	16-DEC-2019 11:55:13	          78.61
2002566319                    	       22432164	16-DEC-2019 16:55:17	           33.9
2002565556                    	       22431195	16-DEC-2019 05:40:08	           36.1
2002566517                    	       22432369	16-DEC-2019 21:00:25	          60.37
2002566472                    	       22432324	16-DEC-2019 20:05:42	           9.61
2002566522                    	       22432374	16-DEC-2019 21:00:57	          22.72
2002566469                    	       22432321	16-DEC-2019 20:05:32	           8.58
2002566523                    	       22432375	16-DEC-2019 21:01:04	             50
2002566475                    	       22432327	16-DEC-2019 20:05:44	          14.98
2002542442                    	       22405814	29-NOV-2019 07:45:08	          19.99
2002524489                    	       22334987	08-NOV-2019 17:30:16	         -54.05
2002550002                    	       22413839	03-DEC-2019 14:06:19	           4.47
2002559451                    	       22424148	10-DEC-2019 08:12:48	            .36
2002543895                    	       22407267	29-NOV-2019 21:10:19	          19.84
2002565094                    	       22430733	15-DEC-2019 15:05:15	          77.02
2002565104                    	       22430743	15-DEC-2019 15:05:39	          20.32
2002565886                    	       22431601	16-DEC-2019 11:35:31	          89.02
2002558723                    	       22423344	09-DEC-2019 15:19:07	          21.19
2002557637                    	       22422053	08-DEC-2019 22:20:11	           -.74
2002560257                    	       22425277	10-DEC-2019 17:49:28	           39.4
2002554427                    	       22418847	06-DEC-2019 15:02:10	            .24
2002566595                    	       22432447	16-DEC-2019 21:46:33	          19.62
2002566598                    	       22432450	16-DEC-2019 21:46:46	           9.48
2002539559                    	       22402233	25-NOV-2019 14:40:11	          36.78
2002532012                    	       22347176	17-NOV-2019 13:15:15	          13.88
2002535484                    	       22375217	20-NOV-2019 16:55:56	          21.22
2002562334                    	       22427721	12-DEC-2019 15:05:13	          19.25
2002564645                    	       22430284	14-DEC-2019 20:50:15	          12.63
2002563725                    	       22429363	13-DEC-2019 18:06:06	          14.93
2002563783                    	       22429421	13-DEC-2019 19:40:13	          86.95
2002563062                    	       22428519	13-DEC-2019 09:52:43	          12.61
2002557871                    	       22422288	09-DEC-2019 06:50:12	          21.39
2002557869                    	       22422286	09-DEC-2019 06:50:11	           3.36
2002567546                    	       22438851	17-DEC-2019 19:30:12	          21.84
2002563776                    	       22429414	13-DEC-2019 19:30:10	          15.78
2002563894                    	       22429532	13-DEC-2019 22:45:09	          36.66
2002565188                    	       22430827	15-DEC-2019 16:50:17	           56.9
2002565183                    	       22430822	15-DEC-2019 16:50:12	          38.43
2002565187                    	       22430826	15-DEC-2019 16:50:16	          30.93
2002565177                    	       22430816	15-DEC-2019 16:40:23	          61.03
2002565182                    	       22430821	15-DEC-2019 16:50:10	          12.49
2002566271                    	       22432106	16-DEC-2019 16:25:16	          48.57
2002565851                    	       22431573	16-DEC-2019 11:15:21	         -22.36
2002565847                    	       22431569	16-DEC-2019 11:15:18	          20.61
2002565852                    	       22431574	16-DEC-2019 11:15:22	          20.18
2002566269                    	       22432104	16-DEC-2019 16:25:12	          59.84
2002553548                    	       22417845	05-DEC-2019 21:40:55	          18.37
2002561899                    	       22427157	12-DEC-2019 09:15:47	          16.99
2002561915                    	       22427182	12-DEC-2019 09:35:12	          61.14
2002566817                    	       22437293	17-DEC-2019 07:55:17	          99.95
2002566814                    	       22437290	17-DEC-2019 07:55:10	             25
2002565126                    	       22430765	15-DEC-2019 15:40:29	          57.89
2002565091                    	       22430730	15-DEC-2019 14:55:22	          19.06
2002565123                    	       22430762	15-DEC-2019 15:40:23	          33.08
2002565068                    	       22430707	15-DEC-2019 14:25:23	          40.71
2002565086                    	       22430725	15-DEC-2019 14:55:09	          18.82
2002565319                    	       22430958	15-DEC-2019 19:35:19	          46.43
2002566083                    	       22431865	16-DEC-2019 14:00:19	          30.77
2002564448                    	       22430087	14-DEC-2019 16:20:10	          40.26
2002566042                    	       22431810	16-DEC-2019 13:25:31	          43.09
2002566081                    	       22431863	16-DEC-2019 14:00:16	          255.1
2002566082                    	       22431864	16-DEC-2019 14:00:17	          74.75
2002566396                    	       22432248	16-DEC-2019 18:35:14	          19.28
2002566408                    	       22432260	16-DEC-2019 18:55:13	          12.21
2002554349                    	       22418758	06-DEC-2019 14:20:14	          11.55
2002543843                    	       22407215	29-NOV-2019 20:40:16	           5.22
2002564919                    	       22430558	15-DEC-2019 10:35:57	          32.86
2002564921                    	       22430560	15-DEC-2019 10:36:06	          57.65
2002564916                    	       22430555	15-DEC-2019 10:35:29	         101.58
2002564918                    	       22430557	15-DEC-2019 10:35:43	          38.88
2002565983                    	       22431738	16-DEC-2019 12:45:10	          29.22
2002566221                    	       22432037	16-DEC-2019 15:40:17	          10.32
2002565450                    	       22431089	15-DEC-2019 21:45:25	          57.21
2002566377                    	       22432229	16-DEC-2019 18:15:30	           60.9
2002564206                    	       22429845	14-DEC-2019 11:45:14	          33.31
2002564205                    	       22429844	14-DEC-2019 11:45:13	          14.98
2002561431                    	       22426661	11-DEC-2019 17:40:45	          50.47
2002564440                    	       22430079	14-DEC-2019 16:10:08	          76.94
2002564201                    	       22429840	14-DEC-2019 11:35:16	          20.79
2002567213                    	       22438451	17-DEC-2019 13:20:28	          60.48
2002567210                    	       22438448	17-DEC-2019 13:20:22	          38.63
2002541169                    	       22404120	27-NOV-2019 09:15:15	          19.78
2002564885                    	       22430524	15-DEC-2019 09:55:16	           43.6
2002566233                    	       22432056	16-DEC-2019 15:55:15	          45.31
2002564295                    	       22429934	14-DEC-2019 13:25:11	            -50
2002565214                    	       22430853	15-DEC-2019 17:30:20	          52.49
2002565213                    	       22430852	15-DEC-2019 17:30:18	          62.99
2002564963                    	       22430602	15-DEC-2019 11:45:25	          56.17
2002564962                    	       22430601	15-DEC-2019 11:45:23	          11.09
2002564961                    	       22430600	15-DEC-2019 11:45:19	          25.43
2002563593                    	       22429210	13-DEC-2019 15:50:18	          21.64
2002564267                    	       22429906	14-DEC-2019 12:55:12	         133.94
2002561998                    	       22427283	12-DEC-2019 10:35:15	           7.64
2002557679                    	       22422095	08-DEC-2019 22:40:13	         -10.68
2002554337                    	       22418741	06-DEC-2019 14:10:18	          21.39
2002566397                    	       22432249	16-DEC-2019 18:45:10	          26.21
2002565590                    	       22431230	16-DEC-2019 07:30:17	          13.37
2002565977                    	       22431731	16-DEC-2019 12:35:22	             15
2002565970                    	       22431724	16-DEC-2019 12:35:09	          12.06
2002564403                    	       22430042	14-DEC-2019 15:20:13	          81.47
2002565998                    	       22431757	16-DEC-2019 12:55:10	          74.99
2002566786                    	       22437258	17-DEC-2019 06:50:11	          94.75
2002566014                    	       22431777	16-DEC-2019 13:05:33	          21.36
2002567031                    	       22438229	17-DEC-2019 11:17:08	         -19.81
2002566765                    	       22437237	17-DEC-2019 06:10:13	          13.26
2002565527                    	       22431166	16-DEC-2019 00:15:10	          25.67
2002565550                    	       22431189	16-DEC-2019 04:55:13	          25.52
2002566875                    	       22437368	17-DEC-2019 09:00:18	          53.11
2002566883                    	       22437376	17-DEC-2019 09:00:34	          53.45
2002566876                    	       22437369	17-DEC-2019 09:00:22	          65.93
2002563822                    	       22429460	13-DEC-2019 20:45:14	          39.37
2002563257                    	       22428773	13-DEC-2019 12:05:09	          17.59
2002558208                    	       22422712	09-DEC-2019 10:45:29	          21.84
2002558774                    	       22423413	09-DEC-2019 15:46:25	          15.99
2002566804                    	       22437277	17-DEC-2019 07:44:48	          55.48
2002566571                    	       22432423	16-DEC-2019 21:22:48	          11.84
2002566577                    	       22432429	16-DEC-2019 21:23:47	          58.71
2002566903                    	       22437407	17-DEC-2019 09:25:11	          18.24
2002563058                    	       22428517	13-DEC-2019 09:50:18	          21.49
2002565705                    	       22431390	16-DEC-2019 09:28:05	          12.17
2002565691                    	       22431369	16-DEC-2019 09:15:37	          24.84
2002562482                    	       22427903	12-DEC-2019 17:45:16	          11.92
2002561430                    	       22426660	11-DEC-2019 17:30:19	          21.41
2002561428                    	       22426658	11-DEC-2019 17:30:17	          21.05
2002559607                    	       22424359	10-DEC-2019 10:04:55	         -39.97
2002562605                    	       22428028	12-DEC-2019 20:00:48	          19.95
2002560049                    	       22424895	10-DEC-2019 15:02:51	          65.53
2002560133                    	       22425005	10-DEC-2019 16:05:52	           -.21
2002564858                    	       22430497	15-DEC-2019 09:06:29	          62.14
2002563803                    	       22429441	13-DEC-2019 20:05:18	          35.99
2002562701                    	       22428124	12-DEC-2019 22:00:29	          67.16
2002538050                    	       22400623	23-NOV-2019 15:05:13	          18.37
2002566946                    	       22437466	17-DEC-2019 10:11:29	          98.09
2002566953                    	       22437473	17-DEC-2019 10:12:55	         102.22
2002566949                    	       22437469	17-DEC-2019 10:12:02	          11.84
2002566051                    	       22431827	16-DEC-2019 13:40:12	          51.36
2002565645                    	       22431307	16-DEC-2019 08:35:29	         219.49
2002564942                    	       22430581	15-DEC-2019 11:10:25	          14.74
2002565762                    	       22431465	16-DEC-2019 10:10:09	         123.16
2002564822                    	       22430461	15-DEC-2019 08:06:16	          12.34
2002561886                    	       22427140	12-DEC-2019 09:05:49	          42.18
2002565283                    	       22430922	15-DEC-2019 18:55:07	          20.32
2002565284                    	       22430923	15-DEC-2019 18:55:10	          72.21
2002562412                    	       22427815	12-DEC-2019 16:15:50	          42.99
2002528712                    	       22343520	13-NOV-2019 11:05:35	           7.27
2002566320                    	       22432165	16-DEC-2019 16:55:19	          56.16
2002565279                    	       22430918	15-DEC-2019 18:45:15	          21.59
2002565228                    	       22430867	15-DEC-2019 17:50:07	          63.59
2002565230                    	       22430869	15-DEC-2019 17:50:10	          25.79
2002565231                    	       22430870	15-DEC-2019 17:50:15	          23.99
2002541212                    	       22404175	27-NOV-2019 10:10:21	          -7.85
2002559642                    	       22424401	10-DEC-2019 10:23:43	          95.21
2002553181                    	       22417466	05-DEC-2019 16:30:12	          10.81
2002549986                    	       22413818	03-DEC-2019 14:03:07	             .6
2002562455                    	       22427871	12-DEC-2019 17:05:51	          21.39
2002566191                    	       22431999	16-DEC-2019 15:10:18	          81.35
2002566618                    	       22432470	16-DEC-2019 22:16:02	          58.44
2002566186                    	       22431994	16-DEC-2019 15:10:14	         203.38
2002566213                    	       22432027	16-DEC-2019 15:38:11	           89.9
2002560936                    	       22426046	11-DEC-2019 11:25:09	         -59.99
2002566103                    	       22431885	16-DEC-2019 14:01:08	         120.51
2002566107                    	       22431889	16-DEC-2019 14:01:14	          43.42
2002563947                    	       22429585	14-DEC-2019 04:30:10	         132.98
2002564957                    	       22430596	15-DEC-2019 11:35:35	          87.49
2002564091                    	       22429730	14-DEC-2019 09:35:11	          35.74
2002528715                    	       22343525	13-NOV-2019 11:15:13	          -1.42
2002520305                    	       22326367	04-NOV-2019 10:48:58	          -3.49
2002524627                    	       22335111	08-NOV-2019 22:00:55	          29.49
2002557301                    	       22421717	08-DEC-2019 19:10:27	          10.59
2002565355                    	       22430994	15-DEC-2019 20:15:32	          89.77
2002566981                    	       22437505	17-DEC-2019 10:30:32	          50.92
2002566978                    	       22437502	17-DEC-2019 10:30:28	          76.09
2002563810                    	       22429448	13-DEC-2019 20:15:27	          16.95
2002560074                    	       22424926	10-DEC-2019 15:18:21	          49.06
2002565879                    	       22431611	16-DEC-2019 11:35:21	           9.77
2002565839                    	       22431559	16-DEC-2019 11:14:11	          80.37
2002565621                    	       22431274	16-DEC-2019 08:05:16	          16.16
2002557601                    	       22422017	08-DEC-2019 22:00:13	          55.71
2002557609                    	       22422025	08-DEC-2019 22:00:21	          10.59
2002563859                    	       22429497	13-DEC-2019 21:25:07	          21.39
2002566631                    	       22434209	16-DEC-2019 23:41:08	          11.74
2002566693                    	       22434271	17-DEC-2019 01:00:08	          42.71
2002566695                    	       22434273	17-DEC-2019 01:00:13	          52.79
2002566696                    	       22434274	17-DEC-2019 01:00:16	          60.48
2002566743                    	       22437215	17-DEC-2019 04:40:09	          33.24
2002566446                    	       22432298	16-DEC-2019 19:35:18	          14.47
2002566442                    	       22432294	16-DEC-2019 19:35:15	          18.14
2002567225                    	       22438464	17-DEC-2019 13:30:15	         104.56
2002564066                    	       22429705	14-DEC-2019 09:05:13	          21.59
2002567969                    	       22439271	18-DEC-2019 06:50:21	          16.05
2002563613                    	       22429237	13-DEC-2019 16:15:21	          17.18
2002566433                    	       22432285	16-DEC-2019 19:25:11	           5.99
2002567004                    	       22437537	17-DEC-2019 10:50:24	          41.99
2002564346                    	       22429985	14-DEC-2019 14:20:15	           6.87
2002564032                    	       22429670	14-DEC-2019 08:35:12	          15.81
2002524680                    	       22335163	09-NOV-2019 05:25:08	          28.61
2002567836                    	       22439138	17-DEC-2019 23:25:34	          -8.47
2002553041                    	       22417301	05-DEC-2019 14:55:23	          25.43
2002565584                    	       22431224	16-DEC-2019 07:10:14	          25.12
2002566894                    	       22437389	17-DEC-2019 09:10:40	           6.75
2002555541                    	       22419957	07-DEC-2019 13:15:09	          20.95
2002564412                    	       22430051	14-DEC-2019 15:30:20	          37.35
2002563921                    	       22429559	13-DEC-2019 23:50:12	          55.68
2002564160                    	       22429799	14-DEC-2019 10:55:15	           19.2
2002567666                    	       22438968	17-DEC-2019 21:15:46	          15.35
2002566202                    	       22432014	16-DEC-2019 15:30:15	          19.04
2002562545                    	       22427968	12-DEC-2019 18:55:12	          25.79
2002562535                    	       22427958	12-DEC-2019 18:35:16	           91.9
2002564801                    	       22430440	15-DEC-2019 07:25:53	          35.21
2002567231                    	       22438470	17-DEC-2019 13:30:22	            3.2
2002567875                    	       22439177	18-DEC-2019 00:35:10	          24.41
2002565930                    	       22431677	16-DEC-2019 12:05:16	          32.07
2002565936                    	       22431683	16-DEC-2019 12:05:23	          36.04
2002567526                    	       22438831	17-DEC-2019 19:20:16	             30
2002567522                    	       22438827	17-DEC-2019 19:20:11	             50
2002564479                    	       22430118	14-DEC-2019 17:10:10	          12.98
2002559379                    	       22424066	10-DEC-2019 06:35:09	         101.87
2002554809                    	       22419225	06-DEC-2019 20:15:35	          10.72
2002541121                    	       22404057	27-NOV-2019 08:15:10	           2.14
2002560934                    	       22426043	11-DEC-2019 11:21:50	           90.1
2002563292                    	       22428819	13-DEC-2019 12:25:10	          57.08
2002562319                    	       22427703	12-DEC-2019 14:49:18	         105.54
2002524050                    	       22334443	08-NOV-2019 10:10:10	           9.86
2002524678                    	       22335161	09-NOV-2019 04:45:12	           2.86
2002562396                    	       22427799	12-DEC-2019 16:10:15	          13.77
2002566197                    	       22432007	16-DEC-2019 15:20:11	          88.61
2002565506                    	       22431145	15-DEC-2019 23:25:14	          18.78
2002558707                    	       22423324	09-DEC-2019 15:04:33	          17.37
2002537955                    	       22400528	23-NOV-2019 13:15:07	          13.74
2002566040                    	       22431808	16-DEC-2019 13:25:30	          17.97
2002558705                    	       22423321	09-DEC-2019 15:03:30	          38.68
2002563040                    	       22428496	13-DEC-2019 09:40:09	          39.53
2002561932                    	       22427202	12-DEC-2019 09:45:12	          41.03
2002558006                    	       22422455	09-DEC-2019 08:59:00	         120.91
2002537942                    	       22400515	23-NOV-2019 12:55:12	          17.48
2002554195                    	       22418576	06-DEC-2019 12:52:03	           25.5
2002562069                    	       22427367	12-DEC-2019 11:40:20	          34.32
2002564140                    	       22429779	14-DEC-2019 10:25:14	             -5
2002524707                    	       22335190	09-NOV-2019 07:25:09	           5.17
2002554292                    	       22418693	06-DEC-2019 13:50:09	          15.02
2002557903                    	       22422322	09-DEC-2019 07:40:11	           3.27
2002567382                    	       22438662	17-DEC-2019 15:50:12	           3.41
2002567483                    	       22438788	17-DEC-2019 18:10:09	          13.81
2002523213                    	       22333493	07-NOV-2019 10:20:06	              5
2002559985                    	       22424820	10-DEC-2019 14:29:54	          39.72
2002566069                    	       22431847	16-DEC-2019 13:50:15	          23.09
2002554807                    	       22419223	06-DEC-2019 20:15:33	         -11.25
2002566179                    	       22431984	16-DEC-2019 14:59:33	          81.88
2002565505                    	       22431144	15-DEC-2019 23:25:14	          67.42
2002563799                    	       22429437	13-DEC-2019 20:05:14	          35.99
2002565334                    	       22430973	15-DEC-2019 19:45:24	          54.55
2002565317                    	       22430956	15-DEC-2019 19:35:16	          16.95
2002566561                    	       22432413	16-DEC-2019 21:21:15	          32.63
2002566102                    	       22431884	16-DEC-2019 14:01:06	         269.76
2002541430                    	       22404463	27-NOV-2019 13:46:52	          20.45
2002565558                    	       22431197	16-DEC-2019 05:50:07	          94.76
2002566592                    	       22432444	16-DEC-2019 21:46:13	         114.18
2002565078                    	       22430717	15-DEC-2019 14:35:34	          23.36
2002565481                    	       22431120	15-DEC-2019 22:26:19	          32.38
2002566507                    	       22432359	16-DEC-2019 20:50:06	          49.32
2002565199                    	       22430838	15-DEC-2019 17:10:35	          25.01
2002566090                    	       22431872	16-DEC-2019 14:00:30	         170.09
2002565361                    	       22431000	15-DEC-2019 20:15:39	           48.8
2002565348                    	       22430987	15-DEC-2019 20:05:31	          62.04
2002566309                    	       22432151	16-DEC-2019 16:50:57	           86.1
2002566568                    	       22432420	16-DEC-2019 21:22:19	          18.57
2002566038                    	       22431806	16-DEC-2019 13:25:26	          15.99
2002566807                    	       22437281	17-DEC-2019 07:45:15	          12.29
2002561940                    	       22427210	12-DEC-2019 09:45:19	          11.12
2002564571                    	       22430210	14-DEC-2019 19:20:10	          56.92
2002562548                    	       22427971	12-DEC-2019 18:55:13	          23.31
2002565168                    	       22430807	15-DEC-2019 16:40:10	          17.76
2002566474                    	       22432326	16-DEC-2019 20:05:43	          44.58
2002560309                    	       22425331	10-DEC-2019 18:50:10	          19.25
2002565919                    	       22431661	16-DEC-2019 11:57:40	          55.63
2002566160                    	       22431962	16-DEC-2019 14:40:17	          68.16
2002565128                    	       22430767	15-DEC-2019 15:40:34	          47.62
2002565795                    	       22431505	16-DEC-2019 10:30:20	          54.47
2002566001                    	       22431760	16-DEC-2019 12:55:12	          39.45
2002565464                    	       22431103	15-DEC-2019 22:05:19	          39.22
2002560815                    	       22425896	11-DEC-2019 09:51:15	          55.49
2002565045                    	       22430684	15-DEC-2019 13:50:15	          43.94
2002565323                    	       22430962	15-DEC-2019 19:45:10	          33.47
2002565877                    	       22431608	16-DEC-2019 11:35:19	          72.76
2002563381                    	       22428928	13-DEC-2019 13:15:21	           6.62
2002563826                    	       22429464	13-DEC-2019 20:45:16	          18.56
2002565102                    	       22430741	15-DEC-2019 15:05:34	          24.29
2002566552                    	       22432404	16-DEC-2019 21:20:41	          58.96
2002566350                    	       22432199	16-DEC-2019 17:40:18	          17.25
2002566086                    	       22431868	16-DEC-2019 14:00:25	          34.24
2002565313                    	       22430952	15-DEC-2019 19:35:13	          30.78
2002566566                    	       22432418	16-DEC-2019 21:22:07	          30.15
2002566140                    	       22431934	16-DEC-2019 14:30:17	           73.4
2002566312                    	       22432157	16-DEC-2019 16:55:10	          19.98
2002565144                    	       22430783	15-DEC-2019 16:00:22	          19.17
2002563973                    	       22429611	14-DEC-2019 06:40:12	          21.49
2002565881                    	       22431613	16-DEC-2019 11:35:23	          35.62
2002564263                    	       22429902	14-DEC-2019 12:55:08	          75.25
2002566311                    	       22432156	16-DEC-2019 16:55:09	          46.53
2002565397                    	       22431036	15-DEC-2019 20:45:20	          33.79
2002566199                    	       22432009	16-DEC-2019 15:20:14	          40.27
2002565046                    	       22430685	15-DEC-2019 13:50:15	          23.79
2002566023                    	       22431787	16-DEC-2019 13:15:16	           8.77
2002566672                    	       22434250	17-DEC-2019 00:10:59	          13.27
2002567894                    	       22439196	18-DEC-2019 02:55:12	           6.99
2002560364                    	       22425386	10-DEC-2019 19:50:08	          21.39
2002566937                    	       22437453	17-DEC-2019 09:55:22	          40.11
2002566565                    	       22432417	16-DEC-2019 21:21:48	          79.91
2002554426                    	       22418831	06-DEC-2019 15:01:15	         -13.49
2002566098                    	       22431880	16-DEC-2019 14:00:53	          57.37
2002565519                    	       22431158	15-DEC-2019 23:45:11	          31.77
2002565193                    	       22430832	15-DEC-2019 17:00:14	           80.3
2002566234                    	       22432051	16-DEC-2019 15:55:48	          18.33
2002566545                    	       22432397	16-DEC-2019 21:04:26	          17.07
2002566823                    	       22437300	17-DEC-2019 08:05:28	          25.61
2002566417                    	       22432269	16-DEC-2019 19:05:30	          24.84
2002567819                    	       22439121	17-DEC-2019 23:25:17	          18.93
2002549360                    	       22413050	03-DEC-2019 08:45:30	          -3.38
2002565210                    	       22430849	15-DEC-2019 17:30:09	          14.83
2002566036                    	       22431804	16-DEC-2019 13:25:22	           13.1
2002565915                    	       22431657	16-DEC-2019 11:55:20	          77.46
2002566596                    	       22432448	16-DEC-2019 21:46:37	          15.47
2002564940                    	       22430579	15-DEC-2019 11:10:19	         169.44
2002564932                    	       22430571	15-DEC-2019 11:00:07	          15.95
2002566826                    	       22437303	17-DEC-2019 08:06:00	         192.65
2002566416                    	       22432268	16-DEC-2019 19:05:27	           20.7
2002566097                    	       22431879	16-DEC-2019 14:00:50	         160.24
2002565985                    	       22431740	16-DEC-2019 12:45:15	          67.24
2002565465                    	       22431104	15-DEC-2019 22:05:22	          34.39
2002565331                    	       22430970	15-DEC-2019 19:45:21	          31.76
2002565520                    	       22431159	15-DEC-2019 23:45:11	          55.25
2002566502                    	       22432354	16-DEC-2019 20:40:17	          12.02
2002565242                    	       22430881	15-DEC-2019 18:00:29	          102.8
2002557604                    	       22422020	08-DEC-2019 22:00:16	          20.99
2002563835                    	       22429473	13-DEC-2019 20:55:29	          25.68
2002563978                    	       22429616	14-DEC-2019 06:50:10	          62.79
2002565554                    	       22431193	16-DEC-2019 05:20:13	          40.18
2002565365                    	       22431004	15-DEC-2019 20:15:45	          63.19
2002566698                    	       22435209	17-DEC-2019 01:25:15	           2.15
2002567068                    	       22438276	17-DEC-2019 11:45:15	          57.89
2002566768                    	       22437240	17-DEC-2019 06:20:09	          16.06
2002564269                    	       22429908	14-DEC-2019 12:55:14	            -40
2002565431                    	       22431070	15-DEC-2019 21:15:17	           18.9
2002566519                    	       22432371	16-DEC-2019 21:00:38	          65.54
2002566821                    	       22437298	17-DEC-2019 08:05:20	          47.99
2002564326                    	       22429965	14-DEC-2019 14:10:10	          18.73
2002564323                    	       22429962	14-DEC-2019 13:55:22	          83.15
2002566394                    	       22432246	16-DEC-2019 18:35:11	          32.24
2002565485                    	       22431124	15-DEC-2019 22:27:11	          40.08
2002562139                    	       22427449	12-DEC-2019 12:50:57	          81.37
2002565298                    	       22430937	15-DEC-2019 19:15:09	          86.59
2002566064                    	       22431842	16-DEC-2019 13:50:10	           17.9
2002565639                    	       22431301	16-DEC-2019 08:35:15	          19.28
2002565756                    	       22431458	16-DEC-2019 10:00:28	          36.49
2002563748                    	       22429386	13-DEC-2019 18:50:10	          37.38
2002564236                    	       22429875	14-DEC-2019 12:25:09	         -55.93
2002565982                    	       22431737	16-DEC-2019 12:45:08	         127.32
2002566105                    	       22431887	16-DEC-2019 14:01:11	         146.99
2002565549                    	       22431188	16-DEC-2019 04:55:12	          46.97
2002566601                    	       22432453	16-DEC-2019 21:46:53	           14.2
2002565157                    	       22430796	15-DEC-2019 16:20:17	           32.2
2002567252                    	       22438495	17-DEC-2019 13:55:13	          33.39
2002565453                    	       22431092	15-DEC-2019 21:55:13	          37.06
2002565344                    	       22430983	15-DEC-2019 20:05:28	           55.1
2002565759                    	       22431461	16-DEC-2019 10:00:34	          43.67
2002561954                    	       22427227	12-DEC-2019 09:55:57	           13.8
2002564019                    	       22429657	14-DEC-2019 08:00:23	          35.71
2002565292                    	       22430931	15-DEC-2019 19:05:14	          19.35
2002565122                    	       22430761	15-DEC-2019 15:40:19	          12.55
2002565378                    	       22431017	15-DEC-2019 20:35:13	          15.52
2002564995                    	       22430634	15-DEC-2019 12:45:56	            -30
2002566536                    	       22432388	16-DEC-2019 21:03:15	          44.49
2002566745                    	       22437217	17-DEC-2019 05:00:14	          19.99
2002565138                    	       22430777	15-DEC-2019 16:00:08	          19.99
2002562479                    	       22427900	12-DEC-2019 17:45:14	          10.71
2002566520                    	       22432372	16-DEC-2019 21:00:48	            -50
2002564854                    	       22430493	15-DEC-2019 09:05:50	          68.19
2002565972                    	       22431726	16-DEC-2019 12:35:15	          30.05
2002565824                    	       22431542	16-DEC-2019 11:00:12	          36.38
2002566668                    	       22434246	17-DEC-2019 00:10:49	          13.03
2002565484                    	       22431123	15-DEC-2019 22:26:58	          38.44
2002564413                    	       22430052	14-DEC-2019 15:30:23	          25.61
2002564976                    	       22430615	15-DEC-2019 12:21:04	          29.66
2002566010                    	       22431773	16-DEC-2019 13:05:18	          43.16
2002565981                    	       22431736	16-DEC-2019 12:45:07	          30.22
2002565830                    	       22431548	16-DEC-2019 11:00:23	          25.43
2002564317                    	       22429956	14-DEC-2019 13:55:16	          19.23
2002564999                    	       22430638	15-DEC-2019 12:46:13	          13.07
2002566378                    	       22432230	16-DEC-2019 18:25:11	           30.3
2002565270                    	       22430909	15-DEC-2019 18:35:20	          17.12
2002565794                    	       22431504	16-DEC-2019 10:30:19	          81.92
2002566223                    	       22432039	16-DEC-2019 15:42:26	           8.33
2002565055                    	       22430694	15-DEC-2019 14:15:16	          40.31
2002564198                    	       22429837	14-DEC-2019 11:35:09	          20.32
2002564674                    	       22430313	14-DEC-2019 21:40:12	          24.33
2002564994                    	       22430633	15-DEC-2019 12:45:52	          25.42
2002565164                    	       22430803	15-DEC-2019 16:30:19	           51.4
2002566299                    	       22432141	16-DEC-2019 16:45:21	          87.73
2002566194                    	       22432002	16-DEC-2019 15:14:24	          21.38
2002566106                    	       22431888	16-DEC-2019 14:01:13	          19.11
2002566317                    	       22432162	16-DEC-2019 16:55:14	          32.15
2002565287                    	       22430926	15-DEC-2019 18:55:14	          64.08
2002566091                    	       22431873	16-DEC-2019 14:00:32	         132.66
2002564117                    	       22429756	14-DEC-2019 10:05:21	           4.99
2002565514                    	       22431153	15-DEC-2019 23:35:15	          67.96
2002565853                    	       22431575	16-DEC-2019 11:15:23	          24.26
2002565016                    	       22430655	15-DEC-2019 13:20:14	          32.99
2002565171                    	       22430810	15-DEC-2019 16:40:17	          55.99
2002566762                    	       22437234	17-DEC-2019 06:10:10	              8
2002566388                    	       22432240	16-DEC-2019 18:25:22	          41.57
2002566674                    	       22434252	17-DEC-2019 00:11:05	          57.45
2002563895                    	       22429533	13-DEC-2019 22:45:10	          21.79
2002566403                    	       22432255	16-DEC-2019 18:55:09	          44.36
2002567071                    	       22438279	17-DEC-2019 11:45:18	          11.99
2002565529                    	       22431168	16-DEC-2019 00:15:11	          16.69
2002565201                    	       22430840	15-DEC-2019 17:10:44	          18.89
2002565025                    	       22430664	15-DEC-2019 13:30:21	          18.99
2002565303                    	       22430942	15-DEC-2019 19:25:06	          13.92
2002566656                    	       22434234	17-DEC-2019 00:10:30	          11.12
2002561076                    	       22426209	11-DEC-2019 12:50:16	         -18.18
2002566298                    	       22432140	16-DEC-2019 16:45:18	            -25
2002566436                    	       22432288	16-DEC-2019 19:25:14	          41.96
2002564930                    	       22430569	15-DEC-2019 10:50:55	          64.22
2002566050                    	       22431826	16-DEC-2019 13:40:10	          35.99
2002566452                    	       22432304	16-DEC-2019 19:45:16	          18.93
2002566882                    	       22437375	17-DEC-2019 09:00:33	          29.38
2002565202                    	       22430841	15-DEC-2019 17:10:47	          81.61
2002566441                    	       22432293	16-DEC-2019 19:35:13	          73.81
2002566214                    	       22432030	16-DEC-2019 15:40:10	          16.26
2002567007                    	       22437540	17-DEC-2019 10:50:26	          20.14
2002566779                    	       22437251	17-DEC-2019 06:40:07	          49.44
2002565974                    	       22431728	16-DEC-2019 12:35:17	          22.28
2002565065                    	       22430704	15-DEC-2019 14:25:19	          68.31
2002566053                    	       22431829	16-DEC-2019 13:40:15	         118.11
2002565116                    	       22430755	15-DEC-2019 15:30:16	          24.43
2002566110                    	       22431892	16-DEC-2019 14:08:39	          34.23
2002566511                    	       22432363	16-DEC-2019 20:50:11	           17.9
2002565721                    	       22431413	16-DEC-2019 09:40:08	           90.9
2002554459                    	       22418891	06-DEC-2019 15:35:15	          -10.5
2002567874                    	       22439176	18-DEC-2019 00:35:09	           4.57
2002566781                    	       22437253	17-DEC-2019 06:40:09	          75.07
2002565087                    	       22430726	15-DEC-2019 14:55:10	          48.75
2002567008                    	       22437541	17-DEC-2019 10:50:28	           50.8
2002566820                    	       22437297	17-DEC-2019 08:05:13	          61.48
2002562161                    	       22427494	12-DEC-2019 13:10:20	          19.68
2002566333                    	       22432181	16-DEC-2019 17:15:17	          32.07
2002566752                    	       22437224	17-DEC-2019 05:30:14	          16.95
2002566564                    	       22432416	16-DEC-2019 21:21:26	          -3.26
2002565423                    	       22431062	15-DEC-2019 21:15:11	          39.21
2002565324                    	       22430963	15-DEC-2019 19:45:11	          17.91
2002565522                    	       22431161	15-DEC-2019 23:55:07	          34.96
2002566252                    	       22432078	16-DEC-2019 16:11:46	          22.73
2002565448                    	       22431087	15-DEC-2019 21:45:16	          36.58
2002566514                    	       22432366	16-DEC-2019 21:00:13	          53.51
2002565294                    	       22430933	15-DEC-2019 19:15:06	          19.23
2002566810                    	       22437284	17-DEC-2019 07:45:19	          88.21
2002566619                    	       22432471	16-DEC-2019 22:16:07	           7.19
2002567677                    	       22438979	17-DEC-2019 21:16:33	          23.99
2002565858                    	       22431584	16-DEC-2019 11:25:19	           9.52
2002565992                    	       22431751	16-DEC-2019 12:55:05	          50.55
2002565054                    	       22430693	15-DEC-2019 14:15:14	          57.63
2002566933                    	       22437449	17-DEC-2019 09:55:17	          67.38
2002565096                    	       22430735	15-DEC-2019 15:05:19	           33.2
2002566473                    	       22432325	16-DEC-2019 20:05:42	          21.39
2002564954                    	       22430593	15-DEC-2019 11:35:23	           27.5
2002566125                    	       22431915	16-DEC-2019 14:17:38	          92.21
2002565162                    	       22430801	15-DEC-2019 16:30:14	          40.66
2002565463                    	       22431102	15-DEC-2019 22:05:15	          31.26
2002566861                    	       22437350	17-DEC-2019 08:40:29	          21.34
2002566640                    	       22434218	17-DEC-2019 00:00:36	          30.68
2002566753                    	       22437225	17-DEC-2019 05:40:10	           47.4
2002566527                    	       22432379	16-DEC-2019 21:01:44	         178.08
2002566018                    	       22431781	16-DEC-2019 13:13:41	          80.23
2002564278                    	       22429917	14-DEC-2019 13:15:12	           12.1
2002556249                    	       22420665	08-DEC-2019 00:30:10	          -5.55
2002551359                    	       22415407	04-DEC-2019 13:10:17	          -6.68
2002551208                    	       22415232	04-DEC-2019 12:10:15	            2.6
2002542921                    	       22406293	29-NOV-2019 11:55:18	          39.39
2002542969                    	       22406341	29-NOV-2019 12:15:20	          11.47
2002540605                    	       22403470	26-NOV-2019 14:58:16	         -17.14
2002556006                    	       22420422	07-DEC-2019 20:40:21	          18.03
2002555891                    	       22420307	07-DEC-2019 19:10:17	          17.07
2002532490                    	       22347654	17-NOV-2019 22:13:29	          26.32
2002540169                    	       22402919	26-NOV-2019 08:55:14	           2.14
2002557899                    	       22422316	09-DEC-2019 07:36:38	            .82
2002525672                    	       22336151	10-NOV-2019 18:05:10	          29.22
2002540337                    	       22403131	26-NOV-2019 11:05:32	          19.28
2002554075                    	       22418436	06-DEC-2019 11:30:32	          91.82
2002554010                    	       22418357	06-DEC-2019 10:45:13	          -10.6
2002546360                    	       22409721	01-DEC-2019 20:50:17	         124.04
2002558466                    	       22423018	09-DEC-2019 12:50:23	           5.34
2002553864                    	       22418180	06-DEC-2019 09:20:12	          17.59
2002567434                    	       22438732	17-DEC-2019 16:55:13	           4.24
2002567409                    	       22438697	17-DEC-2019 16:25:16	             50
2002567286                    	       22438534	17-DEC-2019 14:15:18	          37.09
2002567390                    	       22438675	17-DEC-2019 16:00:38	          41.99
2002561270                    	       22426450	11-DEC-2019 15:26:51	          21.88
2002561199                    	       22426362	11-DEC-2019 14:40:48	          35.47
2002567334                    	       22438602	17-DEC-2019 15:00:16	           3.27
2002567336                    	       22438604	17-DEC-2019 15:00:20	           2.19
2002559773                    	       22424562	10-DEC-2019 12:05:31	         104.81
2002561256                    	       22426432	11-DEC-2019 15:15:14	          19.99
2002529504                    	       22344453	14-NOV-2019 09:45:16	          21.59
2002542196                    	       22405568	28-NOV-2019 19:45:08	          21.39
2002562962                    	       22428397	13-DEC-2019 08:35:13	          37.13
2002562766                    	       22428189	13-DEC-2019 00:15:18	          24.81
2002562861                    	       22428284	13-DEC-2019 06:10:09	          21.39
2002562978                    	       22428419	13-DEC-2019 08:52:26	           40.4
2002562788                    	       22428211	13-DEC-2019 01:30:30	          -2.17
2002562843                    	       22428266	13-DEC-2019 05:20:20	           8.63
2002551443                    	       22415518	04-DEC-2019 13:52:48	            .42
2002560839                    	       22425931	11-DEC-2019 10:10:10	          -4.52
2002560793                    	       22425868	11-DEC-2019 09:40:20	          19.82
2002560833                    	       22425921	11-DEC-2019 10:00:23	          -2.11
2002560852                    	       22425946	11-DEC-2019 10:19:49	          42.59
2002560791                    	       22425866	11-DEC-2019 09:40:19	          21.49
2002549003                    	       22412649	02-DEC-2019 22:58:54	           -.12
2002548217                    	       22411843	02-DEC-2019 17:20:18	          39.99
2002556223                    	       22420639	07-DEC-2019 23:40:19	          60.41
2002517987                    	       22322956	01-NOV-2019 07:15:12	           6.54
2002545694                    	       22409066	01-DEC-2019 11:50:26	          31.43
2002545363                    	       22408735	30-NOV-2019 23:25:09	          19.88
2002545448                    	       22408820	01-DEC-2019 07:10:29	          56.69
2002534239                    	       22357212	19-NOV-2019 14:15:21	           2.15
2002546536                    	       22409897	01-DEC-2019 22:59:54	          18.68
2002563484                    	       22429069	13-DEC-2019 14:30:17	          19.68
2002555354                    	       22419770	07-DEC-2019 10:35:21	          38.76
2002555188                    	       22419604	07-DEC-2019 08:55:16	           9.97
2002560476                    	       22425500	10-DEC-2019 21:40:45	          12.04
2002533678                    	       22348965	19-NOV-2019 06:05:07	           6.51
2002537703                    	       22400276	23-NOV-2019 07:35:09	          13.99
2002539101                    	       22401680	25-NOV-2019 07:55:10	           8.32
2002534653                    	       22361389	19-NOV-2019 21:06:16	           4.15
2002534661                    	       22361397	19-NOV-2019 21:15:34	           5.59
2002541563                    	       22404619	27-NOV-2019 16:35:20	          20.93
2002544768                    	       22408140	30-NOV-2019 15:00:17	           7.21
2002544801                    	       22408173	30-NOV-2019 15:30:17	          35.31
2002557194                    	       22421610	08-DEC-2019 18:00:17	          10.81
2002559853                    	       22424639	10-DEC-2019 12:56:29	          59.98
2002528135                    	       22342227	12-NOV-2019 18:50:25	          16.11
2002528228                    	       22342320	12-NOV-2019 20:20:22	           2.99
2002542849                    	       22406221	29-NOV-2019 11:15:15	          38.25
2002542774                    	       22406146	29-NOV-2019 10:35:27	          27.01
2002563365                    	       22428908	13-DEC-2019 13:10:34	          32.34
2002563369                    	       22428916	13-DEC-2019 13:15:11	          48.13
2002547260                    	       22410713	02-DEC-2019 11:25:15	            .01
2002547311                    	       22410768	02-DEC-2019 11:35:42	          70.81
2002547178                    	       22410622	02-DEC-2019 11:01:21	          19.27
2002518337                    	       22323396	01-NOV-2019 14:30:11	           -.24
2002536072                    	       22388446	21-NOV-2019 08:50:26	            -25
2002536141                    	       22390213	21-NOV-2019 09:55:18	          76.54
2002552518                    	       22416696	05-DEC-2019 10:50:57	          41.62
2002547974                    	       22411547	02-DEC-2019 15:40:32	          83.08
2002529099                    	       22344024	13-NOV-2019 15:50:30	         118.48
2002532360                    	       22347524	17-NOV-2019 19:35:18	           -.53
2002547422                    	       22410894	02-DEC-2019 12:20:25	          40.64
2002533854                    	       22349185	19-NOV-2019 09:55:10	          -9.63
2002520785                    	       22326973	04-NOV-2019 17:05:27	           -4.4
2002536327                    	       22393217	21-NOV-2019 12:46:21	          21.19
2002536423                    	       22395281	21-NOV-2019 14:15:21	          -2.99
2002544439                    	       22407811	30-NOV-2019 10:30:19	          71.85
2002544460                    	       22407832	30-NOV-2019 10:50:13	           2.19
2002561749                    	       22426982	12-DEC-2019 04:55:08	          21.39
2002561758                    	       22426991	12-DEC-2019 06:05:10	          20.08
2002561705                    	       22426938	11-DEC-2019 23:20:16	          -21.4
2002531707                    	       22346871	16-NOV-2019 20:40:13	          -1.88
2002555697                    	       22420113	07-DEC-2019 15:55:10	          11.94
2002555790                    	       22420206	07-DEC-2019 17:40:17	         -87.32
2002559026                    	       22423713	09-DEC-2019 18:30:21	            .01
2002559069                    	       22423756	09-DEC-2019 19:00:21	          17.56
2002526204                    	       22336734	11-NOV-2019 09:50:16	           -.22
2002539843                    	       22402564	25-NOV-2019 20:15:18	          21.34
2002547685                    	       22411202	02-DEC-2019 14:05:49	          63.51
2002543209                    	       22406581	29-NOV-2019 14:30:14	          40.54
2002551958                    	       22416106	04-DEC-2019 21:20:31	          19.87
2002518725                    	       22324450	02-NOV-2019 08:15:10	          -4.53
2002535221                    	       22371232	20-NOV-2019 13:06:51	          20.83
2002550085                    	       22413939	03-DEC-2019 14:53:32	         475.93
2002549839                    	       22413636	03-DEC-2019 12:50:16	          38.15
2002549940                    	       22413760	03-DEC-2019 13:39:20	            -.6
2002556634                    	       22421050	08-DEC-2019 11:15:08	          31.49
2002525954                    	       22336433	11-NOV-2019 06:10:10	          39.16
2002554114                    	       22418474	06-DEC-2019 11:45:27	          44.11
2002519921                    	       22325637	03-NOV-2019 21:00:21	          46.53
2002528489                    	       22343283	13-NOV-2019 07:55:13	           3.99
2002541454                    	       22404491	27-NOV-2019 14:10:28	          41.03
2002552665                    	       22416856	05-DEC-2019 12:00:11	          10.81
2002526984                    	       22338454	11-NOV-2019 20:50:21	           3.17
2002564556                    	       22430195	14-DEC-2019 19:00:12	          21.78
2002563785                    	       22429423	13-DEC-2019 19:40:15	          43.45
2002562099                    	       22427408	12-DEC-2019 12:21:06	          68.62
2002562073                    	       22427371	12-DEC-2019 11:44:47	          35.98
2002562899                    	       22428322	13-DEC-2019 07:15:16	          21.39
2002553589                    	       22417886	05-DEC-2019 22:10:36	          19.99
2002520702                    	       22326881	04-NOV-2019 16:04:36	          -4.77
2002563943                    	       22429581	14-DEC-2019 02:25:18	          68.96
2002564005                    	       22429643	14-DEC-2019 07:40:23	           42.6
2002557004                    	       22421420	08-DEC-2019 15:55:10	          21.44
2002527009                    	       22338479	11-NOV-2019 21:10:28	         118.22
2002563218                    	       22428719	13-DEC-2019 11:45:11	         -34.08
2002555314                    	       22419730	07-DEC-2019 10:15:22	          21.99
2002557423                    	       22421839	08-DEC-2019 20:30:22	           1.84
2002550493                    	       22414415	03-DEC-2019 20:30:35	          33.01
2002550486                    	       22414408	03-DEC-2019 20:30:31	          21.19
2002554548                    	       22418978	06-DEC-2019 16:17:05	          21.98
2002556190                    	       22420606	07-DEC-2019 23:20:17	          10.94
2002566688                    	       22434266	17-DEC-2019 00:40:09	          67.49
2002541259                    	       22404239	27-NOV-2019 11:05:18	            .83
2002547480                    	       22410969	02-DEC-2019 12:50:16	          45.44
2002562298                    	       22427674	12-DEC-2019 14:35:16	          20.93
2002538143                    	       22400717	23-NOV-2019 17:15:09	          12.71
2002564576                    	       22430215	14-DEC-2019 19:30:10	          17.11
2002525696                    	       22336175	10-NOV-2019 18:40:21	          -1.48
2002566165                    	       22431952	16-DEC-2019 14:40:49	            .35
2002565662                    	       22431330	16-DEC-2019 08:55:14	          -8.54
2002564728                    	       22430367	14-DEC-2019 23:25:08	          11.45
2002567640                    	       22438942	17-DEC-2019 20:55:22	            -25
2002559902                    	       22424704	10-DEC-2019 13:40:33	           91.6
2002541408                    	       22404432	27-NOV-2019 13:21:30	          101.9
2002550480                    	       22414402	03-DEC-2019 20:20:28	          13.96
2002557227                    	       22421643	08-DEC-2019 18:20:22	          44.16
2002542657                    	       22406029	29-NOV-2019 09:55:11	          21.18
2002567562                    	       22438867	17-DEC-2019 19:50:17	           2.74
2002565781                    	       22431487	16-DEC-2019 10:24:04	          70.99
2002565897                    	       22431632	16-DEC-2019 11:45:13	          20.99
2002556297                    	       22420713	08-DEC-2019 05:50:23	          21.44
2002563143                    	       22428619	13-DEC-2019 10:40:19	           5.18
2002559500                    	       22424220	10-DEC-2019 08:48:36	          50.48
2002559802                    	       22424596	10-DEC-2019 12:25:17	          19.25
2002549288                    	       22412955	03-DEC-2019 08:15:13	          13.65
2002565711                    	       22431399	16-DEC-2019 09:30:17	          20.13
2002563354                    	       22428898	13-DEC-2019 13:05:14	         183.85
2002563351                    	       22428895	13-DEC-2019 13:05:11	          13.56
2002563357                    	       22428901	13-DEC-2019 13:05:15	          19.07
2002539851                    	       22402572	25-NOV-2019 20:25:09	          20.94
2002564366                    	       22430005	14-DEC-2019 14:40:22	          13.78
2002563982                    	       22429620	14-DEC-2019 07:10:17	           31.5
2002557410                    	       22421826	08-DEC-2019 20:20:24	           9.99
2002540297                    	       22403086	26-NOV-2019 10:45:13	        -185.66
2002561805                    	       22427040	12-DEC-2019 07:50:10	          19.11
2002557306                    	       22421722	08-DEC-2019 19:20:53	          10.75
2002563667                    	       22429304	13-DEC-2019 17:05:28	          21.05
2002559162                    	       22423849	09-DEC-2019 20:25:18	         -19.67
2002524644                    	       22335128	08-NOV-2019 23:10:08	           8.85
2002567551                    	       22438856	17-DEC-2019 19:40:08	           3.24
2002567553                    	       22438858	17-DEC-2019 19:40:10	          15.25
2002564218                    	       22429857	14-DEC-2019 11:55:21	          15.08
2002541643                    	       22404699	27-NOV-2019 19:15:16	          38.45
2002555220                    	       22419636	07-DEC-2019 09:25:21	           9.99
2002543090                    	       22406462	29-NOV-2019 13:30:10	          21.57
2002558161                    	       22422673	09-DEC-2019 10:30:11	          19.01
2002564595                    	       22430234	14-DEC-2019 20:00:11	         -21.85
2002561387                    	       22426609	11-DEC-2019 16:50:14	          59.89
2002560092                    	       22424929	10-DEC-2019 15:21:03	         357.36
2002565007                    	       22430646	15-DEC-2019 13:00:51	          57.35
2002531288                    	       22346449	16-NOV-2019 10:35:13	           -.98
2002539945                    	       22402666	25-NOV-2019 21:50:14	           2.11
2002562445                    	       22427858	12-DEC-2019 16:55:10	          33.04
2002547343                    	       22410808	02-DEC-2019 11:56:45	          -2.54
2002519708                    	       22325424	03-NOV-2019 16:20:14	          46.44
2002562202                    	       22427550	12-DEC-2019 13:40:13	          78.47
2002562203                    	       22427551	12-DEC-2019 13:40:13	          40.64
2002562387                    	       22427786	12-DEC-2019 16:00:10	          87.65
2002547141                    	       22410582	02-DEC-2019 10:58:36	          18.04
2002565631                    	       22431287	16-DEC-2019 08:17:53	          13.55
2002561988                    	       22427272	12-DEC-2019 10:25:13	         121.51
2002561989                    	       22427273	12-DEC-2019 10:25:14	          64.01
2002554377                    	       22418788	06-DEC-2019 14:30:25	          18.15
2002554181                    	       22418563	06-DEC-2019 12:45:11	            4.8
2002547397                    	       22410867	02-DEC-2019 12:10:28	           -.89
2002560759                    	       22425823	11-DEC-2019 09:25:57	          11.87
2002560232                    	       22425249	10-DEC-2019 17:23:45	          65.38
2002540090                    	       22402812	26-NOV-2019 07:36:02	          19.97
2002553928                    	       22418255	06-DEC-2019 09:50:20	           -100
2002542489                    	       22405861	29-NOV-2019 08:25:09	          -5.96
2002563158                    	       22428639	13-DEC-2019 11:00:12	          87.93
2002562770                    	       22428193	13-DEC-2019 00:25:29	           19.9
2002543906                    	       22407278	29-NOV-2019 21:20:08	          90.98
2002567158                    	       22438386	17-DEC-2019 12:35:27	          31.99
2002564434                    	       22430073	14-DEC-2019 16:00:11	           13.9
2002564006                    	       22429644	14-DEC-2019 07:50:14	          77.52
2002539538                    	       22402205	25-NOV-2019 14:19:43	          19.78
2002553757                    	       22418054	06-DEC-2019 07:35:20	          10.66
2002562935                    	       22428361	13-DEC-2019 07:55:17	           19.9
2002561329                    	       22426536	11-DEC-2019 16:10:41	          41.33
2002550548                    	       22414470	03-DEC-2019 21:10:54	          11.12
2002567215                    	       22438453	17-DEC-2019 13:20:30	           7.99
2002557352                    	       22421768	08-DEC-2019 19:50:10	          21.39
2002549747                    	       22413527	03-DEC-2019 12:00:00	           8.47
2002561341                    	       22426550	11-DEC-2019 16:15:14	          98.53
2002561722                    	       22426955	11-DEC-2019 23:50:24	          15.72
2002532385                    	       22347549	17-NOV-2019 19:55:17	         -24.99
2002567901                    	       22439203	18-DEC-2019 03:45:08	          19.99
2002567849                    	       22439151	17-DEC-2019 23:45:13	           13.6
2002563908                    	       22429546	13-DEC-2019 23:21:00	           60.2
2002526777                    	       22338246	11-NOV-2019 17:15:34	            750
2002559559                    	       22424301	10-DEC-2019 09:35:09	           8.71
2002545075                    	       22408447	30-NOV-2019 19:25:15	          55.27
2002563515                    	       22429113	13-DEC-2019 15:00:14	          40.04
2002554093                    	       22418457	06-DEC-2019 11:35:23	          18.94
2002554547                    	       22418969	06-DEC-2019 16:11:32	          -5.07
2002545224                    	       22408596	30-NOV-2019 21:05:14	          13.47
2002564614                    	       22430253	14-DEC-2019 20:20:12	          19.07
2002565959                    	       22431708	16-DEC-2019 12:15:37	          20.09
2002562292                    	       22427667	12-DEC-2019 14:25:22	           7.83
2002547135                    	       22410569	02-DEC-2019 10:53:45	           1.48
2002566832                    	       22437313	17-DEC-2019 08:18:28	         108.17
2002565252                    	       22430891	15-DEC-2019 18:10:17	           16.3
2002558362                    	       22422901	09-DEC-2019 12:00:19	           9.49
2002548278                    	       22411911	02-DEC-2019 17:50:19	          21.34
2002560919                    	       22426026	11-DEC-2019 11:05:47	          21.19
2002537337                    	       22399018	22-NOV-2019 15:00:18	          38.13
2002539400                    	       22402038	25-NOV-2019 12:28:24	         228.86
2002527440                    	       22338940	12-NOV-2019 10:42:24	           6.78
2002544759                    	       22408131	30-NOV-2019 15:00:10	          21.49
2002560140                    	       22425012	10-DEC-2019 16:06:35	          21.19
2002565305                    	       22430944	15-DEC-2019 19:25:07	          18.28
2002565245                    	       22430884	15-DEC-2019 18:00:34	          33.16
2002563862                    	       22429500	13-DEC-2019 21:25:12	          39.99
2002566201                    	       22432012	16-DEC-2019 15:25:45	          42.91
2002566667                    	       22434245	17-DEC-2019 00:10:46	         222.25
2002565765                    	       22431468	16-DEC-2019 10:10:14	          38.48
2002566149                    	       22431944	16-DEC-2019 14:34:46	          65.53
2002566775                    	       22437247	17-DEC-2019 06:30:16	          60.95
2002565246                    	       22430885	15-DEC-2019 18:00:35	          29.53
2002565100                    	       22430739	15-DEC-2019 15:05:30	          17.93
2002566654                    	       22434232	17-DEC-2019 00:10:27	          63.86
2002565717                    	       22431405	16-DEC-2019 09:32:37	          97.99
2002565427                    	       22431066	15-DEC-2019 21:15:14	          40.02
2002547690                    	       22411207	02-DEC-2019 14:06:00	           -.05
2002562369                    	       22427762	12-DEC-2019 15:45:12	          21.59
2002565704                    	       22431388	16-DEC-2019 09:26:04	         102.42
2002567728                    	       22439030	17-DEC-2019 21:50:50	           30.2
2002565496                    	       22431135	15-DEC-2019 23:05:18	          36.19
2002564933                    	       22430572	15-DEC-2019 11:00:14	          13.04
2002556060                    	       22420476	07-DEC-2019 21:20:20	          10.81
2002563845                    	       22429483	13-DEC-2019 21:05:14	          14.62
2002565643                    	       22431305	16-DEC-2019 08:35:26	          54.92
2002566824                    	       22437301	17-DEC-2019 08:05:41	          32.46
2002565751                    	       22431453	16-DEC-2019 10:00:09	          44.41
2002565729                    	       22431421	16-DEC-2019 09:40:15	          21.08
2002565299                    	       22430938	15-DEC-2019 19:15:10	          19.22
2002565366                    	       22431005	15-DEC-2019 20:15:46	          95.23
2002565329                    	       22430968	15-DEC-2019 19:45:19	          28.68
2002564743                    	       22430382	15-DEC-2019 00:15:10	           24.5
2002565744                    	       22431440	16-DEC-2019 09:50:15	          48.73
2002561060                    	       22426173	11-DEC-2019 12:40:19	          65.92
2002566032                    	       22431800	16-DEC-2019 13:25:13	          34.96
2002565555                    	       22431194	16-DEC-2019 05:20:14	          41.36
2002565672                    	       22431340	16-DEC-2019 08:55:26	          23.04
2002567066                    	       22438274	17-DEC-2019 11:45:13	           2.99
2002559529                    	       22424256	10-DEC-2019 09:07:05	         118.75
2002565801                    	       22431512	16-DEC-2019 10:40:11	          14.41
2002563589                    	       22429206	13-DEC-2019 15:50:15	             20
2002561868                    	       22427119	12-DEC-2019 08:50:11	           -.36
2002565945                    	       22431694	16-DEC-2019 12:15:11	          64.04
2002566336                    	       22432184	16-DEC-2019 17:15:20	          28.49
2002565960                    	       22431710	16-DEC-2019 12:17:26	          64.89
2002564199                    	       22429838	14-DEC-2019 11:35:10	          20.32
2002566491                    	       22432343	16-DEC-2019 20:40:07	          53.64
2002567862                    	       22439164	17-DEC-2019 23:55:11	         -17.43
2002565776                    	       22431480	16-DEC-2019 10:20:17	          33.16
2002565232                    	       22430871	15-DEC-2019 17:50:17	          20.37
2002565258                    	       22430897	15-DEC-2019 18:20:15	          20.04
2002564573                    	       22430212	14-DEC-2019 19:20:11	           16.1
2002564296                    	       22429935	14-DEC-2019 13:25:12	          37.97
2002566380                    	       22432232	16-DEC-2019 18:25:13	         107.45
2002566594                    	       22432446	16-DEC-2019 21:46:24	          19.98
2002566635                    	       22434213	16-DEC-2019 23:42:29	          15.05
2002566203                    	       22432015	16-DEC-2019 15:30:18	          48.75
2002564601                    	       22430240	14-DEC-2019 20:00:15	           4.99
2002562684                    	       22428107	12-DEC-2019 21:30:14	          91.47
2002561953                    	       22427226	12-DEC-2019 09:55:17	          13.06
2002559439                    	       22424129	10-DEC-2019 08:02:42	          49.69
2002561985                    	       22427269	12-DEC-2019 10:25:08	          12.23
2002566485                    	       22432337	16-DEC-2019 20:30:09	          22.98
2002562749                    	       22428172	12-DEC-2019 23:15:21	          21.64
2002566449                    	       22432301	16-DEC-2019 19:45:13	           5.99
2002565683                    	       22431358	16-DEC-2019 09:10:12	          38.68
2002566373                    	       22432225	16-DEC-2019 18:15:19	          43.89
2002565229                    	       22430868	15-DEC-2019 17:50:09	          37.38
2002565707                    	       22431393	16-DEC-2019 09:29:18	           69.2
2002567157                    	       22438385	17-DEC-2019 12:35:25	           7.37
2002565468                    	       22431107	15-DEC-2019 22:05:31	         210.38
2002564925                    	       22430564	15-DEC-2019 10:50:18	          38.61
2002566638                    	       22434216	17-DEC-2019 00:00:20	          20.42
2002566039                    	       22431807	16-DEC-2019 13:25:28	          15.15
2002565233                    	       22430872	15-DEC-2019 17:50:18	          35.18
2002565446                    	       22431085	15-DEC-2019 21:35:17	          86.59
2002565274                    	       22430913	15-DEC-2019 18:35:29	          20.27
2002563878                    	       22429516	13-DEC-2019 22:00:57	          44.99
2002565531                    	       22431170	16-DEC-2019 00:25:09	          38.51
2002565921                    	       22431662	16-DEC-2019 12:00:48	           78.3
2002554899                    	       22419315	06-DEC-2019 21:35:19	          25.67
2002565920                    	       22431664	16-DEC-2019 11:58:56	         114.43
2002565702                    	       22431375	16-DEC-2019 09:20:21	          36.34
2002566451                    	       22432303	16-DEC-2019 19:45:15	          78.65
2002565964                    	       22431716	16-DEC-2019 12:25:12	          14.83
2002566687                    	       22434265	17-DEC-2019 00:40:08	           48.4
2002565758                    	       22431460	16-DEC-2019 10:00:31	          58.44
2002566041                    	       22431809	16-DEC-2019 13:25:30	          52.37
2002565135                    	       22430774	15-DEC-2019 15:50:18	          28.95
2002561349                    	       22426561	11-DEC-2019 16:20:12	         -16.96
2002565440                    	       22431079	15-DEC-2019 21:25:19	           56.7
2002563607                    	       22429228	13-DEC-2019 16:09:11	          76.42
2002541898                    	       22405270	28-NOV-2019 08:05:17	           5.19
2002566109                    	       22431894	16-DEC-2019 14:08:06	           4.55
2002559854                    	       22424652	10-DEC-2019 12:56:57	         289.98
2002564936                    	       22430575	15-DEC-2019 11:00:43	          87.54
2002566924                    	       22437434	17-DEC-2019 09:45:07	            100
2002566421                    	       22432273	16-DEC-2019 19:05:50	          64.82
2002567026                    	       22438224	17-DEC-2019 11:15:19	         -14.01
2002532489                    	       22347653	17-NOV-2019 22:13:22	           5.26
2002562229                    	       22427585	12-DEC-2019 13:55:18	          69.91
2002565099                    	       22430738	15-DEC-2019 15:05:28	           10.2
2002561926                    	       22427180	12-DEC-2019 09:35:33	          33.09
2002566262                    	       22432090	16-DEC-2019 16:15:20	          30.88
2002565755                    	       22431457	16-DEC-2019 10:00:26	          38.65
2002565130                    	       22430769	15-DEC-2019 15:50:09	          16.85
2002567775                    	       22439077	17-DEC-2019 22:21:04	            -25
2002555524                    	       22419940	07-DEC-2019 12:55:12	          32.38
2002566389                    	       22432241	16-DEC-2019 18:25:23	          54.99
2002562870                    	       22428293	13-DEC-2019 06:20:12	          19.61
2002563984                    	       22429622	14-DEC-2019 07:10:24	         -35.09
2002565095                    	       22430734	15-DEC-2019 15:05:18	          27.19
2002566548                    	       22432400	16-DEC-2019 21:20:15	         170.48
2002566249                    	       22432075	16-DEC-2019 16:05:28	           53.1
2002566232                    	       22432055	16-DEC-2019 15:55:14	          23.85
2002566400                    	       22432252	16-DEC-2019 18:45:20	          11.77
2002566746                    	       22437218	17-DEC-2019 05:10:10	          49.31
2002565615                    	       22431268	16-DEC-2019 08:05:09	           6.66
2002565017                    	       22430656	15-DEC-2019 13:20:15	          22.25
2002565424                    	       22431063	15-DEC-2019 21:15:12	          63.32
2002565474                    	       22431113	15-DEC-2019 22:15:32	          62.56
2002566331                    	       22432177	16-DEC-2019 17:13:37	         102.46
2002566139                    	       22431933	16-DEC-2019 14:30:15	          58.44
2002563377                    	       22428924	13-DEC-2019 13:15:18	          31.21
2002565289                    	       22430928	15-DEC-2019 19:05:10	           5.64
2002567559                    	       22438864	17-DEC-2019 19:50:14	            597
2002564068                    	       22429707	14-DEC-2019 09:05:15	          35.76
2002567765                    	       22439067	17-DEC-2019 22:20:28	           7.99
2002566837                    	       22437319	17-DEC-2019 08:20:14	           3.99
2002567212                    	       22438450	17-DEC-2019 13:20:27	            -50
2002566621                    	       22432473	16-DEC-2019 22:16:32	          36.31
2002563906                    	       22429544	13-DEC-2019 23:20:54	          20.72
2002566277                    	       22432112	16-DEC-2019 16:26:43	          73.82
2002564305                    	       22429944	14-DEC-2019 13:35:18	          17.99
2002564153                    	       22429792	14-DEC-2019 10:45:09	          18.79
2002566869                    	       22437360	17-DEC-2019 08:50:19	          84.49
2002564949                    	       22430588	15-DEC-2019 11:25:36	          19.99
2002566215                    	       22432031	16-DEC-2019 15:40:11	          -5.82
2002565495                    	       22431134	15-DEC-2019 23:05:17	          77.82
2002566055                    	       22431831	16-DEC-2019 13:40:17	            7.1
2002566603                    	       22432455	16-DEC-2019 21:55:17	          32.21
2002564409                    	       22430048	14-DEC-2019 15:30:16	          38.08
2002565471                    	       22431110	15-DEC-2019 22:05:45	          57.36
2002566793                    	       22437265	17-DEC-2019 07:10:12	             60
2002564888                    	       22430527	15-DEC-2019 09:55:31	          23.19
2002565819                    	       22431532	16-DEC-2019 10:52:40	          95.03
2002566172                    	       22431976	16-DEC-2019 14:50:11	           55.2
2002564676                    	       22430315	14-DEC-2019 21:50:08	          20.58
2002566509                    	       22432361	16-DEC-2019 20:50:10	          18.97
2002566934                    	       22437450	17-DEC-2019 09:55:18	           9.72
2002566176                    	       22431980	16-DEC-2019 14:50:17	          48.86
2002565362                    	       22431001	15-DEC-2019 20:15:40	          20.32
2002566034                    	       22431802	16-DEC-2019 13:25:19	          17.31
2002564059                    	       22429698	14-DEC-2019 08:55:17	          20.83
2002566141                    	       22431935	16-DEC-2019 14:30:18	          75.68
2002564530                    	       22430169	14-DEC-2019 18:20:11	          84.76
2002564080                    	       22429719	14-DEC-2019 09:15:14	           43.3
2002566448                    	       22432300	16-DEC-2019 19:45:12	          22.25
2002566363                    	       22432214	16-DEC-2019 17:50:29	          52.98
2002566683                    	       22434261	17-DEC-2019 00:30:12	          31.13
2002565036                    	       22430675	15-DEC-2019 13:40:16	         105.54
2002565029                    	       22430668	15-DEC-2019 13:30:27	         238.34
2002566428                    	       22432280	16-DEC-2019 19:15:14	          12.08
2002566259                    	       22432087	16-DEC-2019 16:15:18	          22.32
2002565533                    	       22431172	16-DEC-2019 00:25:11	           9.83
2002566349                    	       22432198	16-DEC-2019 17:40:18	         140.67
2002565628                    	       22431284	16-DEC-2019 08:15:08	          12.27
2002564071                    	       22429710	14-DEC-2019 09:05:17	           8.48
2002566423                    	       22432275	16-DEC-2019 19:05:59	          39.32
2002567594                    	       22438896	17-DEC-2019 20:25:29	          15.84
2002565836                    	       22431554	16-DEC-2019 11:00:29	          28.88
2002564582                    	       22430221	14-DEC-2019 19:40:08	          39.11
2002562332                    	       22427717	12-DEC-2019 15:02:00	          35.26
2002566580                    	       22432432	16-DEC-2019 21:24:11	          37.98
2002565873                    	       22431604	16-DEC-2019 11:35:13	          97.49
2002566717                    	       22436210	17-DEC-2019 01:55:25	          34.73
2002565789                    	       22431499	16-DEC-2019 10:30:15	          55.64
2002565480                    	       22431119	15-DEC-2019 22:26:04	          14.09
2002566301                    	       22432143	16-DEC-2019 16:45:25	          11.49
2002565654                    	       22431320	16-DEC-2019 08:45:24	          37.91
2002566587                    	       22432439	16-DEC-2019 21:45:34	          11.01
2002566790                    	       22437262	17-DEC-2019 07:00:09	           9.63
2002566553                    	       22432405	16-DEC-2019 21:20:44	          19.91
2002565057                    	       22430696	15-DEC-2019 14:15:19	          60.98
2002565151                    	       22430790	15-DEC-2019 16:10:16	          29.44
2002564189                    	       22429828	14-DEC-2019 11:15:21	         -39.41
2002565831                    	       22431549	16-DEC-2019 11:00:24	         126.63
2002567010                    	       22437543	17-DEC-2019 10:50:30	           42.3
2002566462                    	       22432314	16-DEC-2019 19:55:15	          46.47
2002567524                    	       22438829	17-DEC-2019 19:20:14	             25
2002561147                    	       22426298	11-DEC-2019 13:50:14	          21.97
2002565932                    	       22431679	16-DEC-2019 12:05:18	          59.38
2002525870                    	       22336349	10-NOV-2019 22:35:10	          15.11
2002566880                    	       22437373	17-DEC-2019 09:00:28	          26.21
2002566393                    	       22432245	16-DEC-2019 18:35:10	          45.99
2002565953                    	       22431702	16-DEC-2019 12:15:29	          15.11
2002567227                    	       22438466	17-DEC-2019 13:30:17	          19.99
2002566181                    	       22431987	16-DEC-2019 15:00:12	          46.97
2002531306                    	       22346467	16-NOV-2019 11:05:14	          -1.38
2002563614                    	       22429238	13-DEC-2019 16:15:22	          12.55
2002566429                    	       22432281	16-DEC-2019 19:15:15	          46.97
2002566127                    	       22431919	16-DEC-2019 14:20:14	          28.94
2002565668                    	       22431336	16-DEC-2019 08:55:23	          38.63
2002565947                    	       22431696	16-DEC-2019 12:15:15	          37.79
2002564682                    	       22430321	14-DEC-2019 22:00:10	          21.71
2002565535                    	       22431174	16-DEC-2019 00:35:06	          25.43
2002566590                    	       22432442	16-DEC-2019 21:45:55	          32.31
2002567111                    	       22438328	17-DEC-2019 12:05:17	         317.05
2002566454                    	       22432306	16-DEC-2019 19:45:18	          76.99
2002565434                    	       22431073	15-DEC-2019 21:15:21	           9.72
2002565618                    	       22431271	16-DEC-2019 08:05:13	          10.05
2002548214                    	       22411840	02-DEC-2019 17:20:15	          21.24
2002547819                    	       22411365	02-DEC-2019 14:58:29	          -8.64
2002565872                    	       22431603	16-DEC-2019 11:35:12	          30.63
2002565733                    	       22431425	16-DEC-2019 09:40:18	          31.15
2002566573                    	       22432425	16-DEC-2019 21:23:07	          28.94
2002563891                    	       22429529	13-DEC-2019 22:35:44	          21.19
2002565443                    	       22431082	15-DEC-2019 21:35:12	          52.96
2002565262                    	       22430901	15-DEC-2019 18:20:23	          20.67
2002564164                    	       22429803	14-DEC-2019 10:55:23	          41.99
2002565147                    	       22430786	15-DEC-2019 16:00:27	          56.72
2002566535                    	       22432387	16-DEC-2019 21:02:53	          33.99
2002565907                    	       22431649	16-DEC-2019 11:55:09	          23.02
2002566605                    	       22432457	16-DEC-2019 21:55:26	           57.4
2002566856                    	       22437345	17-DEC-2019 08:40:22	           74.1
2002566800                    	       22437272	17-DEC-2019 07:35:11	          17.11
2002564415                    	       22430054	14-DEC-2019 15:30:25	          63.59
2002565367                    	       22431006	15-DEC-2019 20:15:48	          32.85
2002565799                    	       22431510	16-DEC-2019 10:40:10	          19.25
2002565189                    	       22430828	15-DEC-2019 17:00:07	          25.66
2002566471                    	       22432323	16-DEC-2019 20:05:39	          12.08
2002566524                    	       22432376	16-DEC-2019 21:01:10	          11.21
2002565375                    	       22431014	15-DEC-2019 20:25:26	          37.66
2002560002                    	       22424838	10-DEC-2019 14:34:00	           37.7
2002565625                    	       22431281	16-DEC-2019 08:15:06	          52.49
2002565636                    	       22431296	16-DEC-2019 08:25:14	          19.26
2002566177                    	       22431971	16-DEC-2019 14:50:44	          52.44
2002565803                    	       22431514	16-DEC-2019 10:40:12	           6.21
2002565833                    	       22431551	16-DEC-2019 11:00:25	          75.22
2002566111                    	       22431895	16-DEC-2019 14:08:50	          47.39
2002566443                    	       22432295	16-DEC-2019 19:35:16	          86.66
2002565551                    	       22431190	16-DEC-2019 05:05:09	          27.89
2002563927                    	       22429565	14-DEC-2019 00:10:14	          39.56
2002566785                    	       22437257	17-DEC-2019 06:50:10	          41.59
2002562440                    	       22427852	12-DEC-2019 16:49:15	          78.98
2002566510                    	       22432362	16-DEC-2019 20:50:11	          15.14
2002561812                    	       22427047	12-DEC-2019 07:50:14	          21.24
2002542923                    	       22406295	29-NOV-2019 11:55:19	          27.39
2002565353                    	       22430992	15-DEC-2019 20:15:30	          38.42
2002565384                    	       22431023	15-DEC-2019 20:35:18	          26.08
2002566512                    	       22432364	16-DEC-2019 20:50:13	          95.61
2002566283                    	       22432123	16-DEC-2019 16:35:11	          23.55
2002566303                    	       22432145	16-DEC-2019 16:45:28	          68.84
2002566270                    	       22432105	16-DEC-2019 16:25:13	          15.82
2002565888                    	       22431621	16-DEC-2019 11:38:04	          19.77
2002563933                    	       22429571	14-DEC-2019 00:50:05	          32.45
2002566686                    	       22434264	17-DEC-2019 00:40:08	          31.56
2002566583                    	       22432435	16-DEC-2019 21:24:37	          35.37
2002561887                    	       22427141	12-DEC-2019 09:06:14	          31.51
2002566119                    	       22431907	16-DEC-2019 14:10:18	          11.24
2002566243                    	       22432069	16-DEC-2019 16:05:20	           22.2
2002565548                    	       22431187	16-DEC-2019 04:05:10	          11.24
2002567358                    	       22438633	17-DEC-2019 15:20:15	          19.99
2002566329                    	       22432174	16-DEC-2019 17:05:27	           57.1
2002565588                    	       22431228	16-DEC-2019 07:30:12	          69.02
2002565074                    	       22430713	15-DEC-2019 14:35:26	          54.91
2002566740                    	       22437212	17-DEC-2019 04:20:06	          27.39
2002567634                    	       22438936	17-DEC-2019 20:55:17	           8.64
2002563879                    	       22429517	13-DEC-2019 22:01:05	          26.99
2002566168                    	       22431972	16-DEC-2019 14:50:07	          30.99
2002560095                    	       22424952	10-DEC-2019 15:27:21	          47.15
2002565913                    	       22431655	16-DEC-2019 11:55:17	          20.23
2002565358                    	       22430997	15-DEC-2019 20:15:35	          21.76
2002566655                    	       22434233	17-DEC-2019 00:10:29	         102.41
2002565681                    	       22431356	16-DEC-2019 09:10:09	          21.59
2002565616                    	       22431269	16-DEC-2019 08:05:10	           9.89
2002566859                    	       22437348	17-DEC-2019 08:40:27	           40.6
2002564535                    	       22430174	14-DEC-2019 18:30:08	          54.26
2002566901                    	       22437402	17-DEC-2019 09:23:32	          131.1
2002566033                    	       22431801	16-DEC-2019 13:25:16	          19.31
2002564914                    	       22430553	15-DEC-2019 10:35:10	          19.79
2002564146                    	       22429785	14-DEC-2019 10:35:14	          37.51
2002565288                    	       22430927	15-DEC-2019 19:05:08	          17.27
2002566866                    	       22437357	17-DEC-2019 08:50:12	           15.5
2002566671                    	       22434249	17-DEC-2019 00:10:57	          56.98
2002565403                    	       22431042	15-DEC-2019 20:55:10	          55.96
2002566116                    	       22431904	16-DEC-2019 14:10:16	          34.08
2002566633                    	       22434211	16-DEC-2019 23:42:06	           5.99
2002566148                    	       22431942	16-DEC-2019 14:33:00	          61.46
2002563769                    	       22429407	13-DEC-2019 19:10:27	          23.32
2002565658                    	       22431326	16-DEC-2019 08:55:11	          48.97
2002566794                    	       22437266	17-DEC-2019 07:10:16	          26.21
2002554580                    	       22419018	06-DEC-2019 16:55:20	          43.59
2002565805                    	       22431516	16-DEC-2019 10:40:14	          73.63
2002564507                    	       22430146	14-DEC-2019 17:50:09	          33.11
2002565900                    	       22431635	16-DEC-2019 11:45:15	          12.35
2002566296                    	       22432138	16-DEC-2019 16:45:15	          15.86
2002566773                    	       22437245	17-DEC-2019 06:30:14	          25.26
2002549103                    	       22412749	03-DEC-2019 00:00:11	          19.73
2002565256                    	       22430895	15-DEC-2019 18:10:23	          44.51
2002566579                    	       22432431	16-DEC-2019 21:23:59	          11.21
2002565509                    	       22431148	15-DEC-2019 23:25:17	          17.07
2002563828                    	       22429466	13-DEC-2019 20:45:18	          18.07
2002566679                    	       22434257	17-DEC-2019 00:11:22	          43.91
2002566825                    	       22437302	17-DEC-2019 08:05:49	          13.98
2002566422                    	       22432274	16-DEC-2019 19:05:55	          94.31
2002565508                    	       22431147	15-DEC-2019 23:25:16	          47.28
2002564671                    	       22430310	14-DEC-2019 21:40:10	          17.46
2002564123                    	       22429762	14-DEC-2019 10:15:11	          36.99
2002519922                    	       22325638	03-NOV-2019 21:00:22	            .98
2002566287                    	       22432127	16-DEC-2019 16:35:16	          14.77
2002567431                    	       22438729	17-DEC-2019 16:55:09	          -2.41
2002567761                    	       22439063	17-DEC-2019 22:10:55	         -16.38
2002566022                    	       22431786	16-DEC-2019 13:15:15	             15
2002564950                    	       22430589	15-DEC-2019 11:25:40	          28.19
2002566586                    	       22432438	16-DEC-2019 21:45:23	          49.43
2002566207                    	       22432019	16-DEC-2019 15:30:26	          33.08
2002565254                    	       22430893	15-DEC-2019 18:10:20	           13.9
2002565158                    	       22430797	15-DEC-2019 16:20:19	          22.93
2002566615                    	       22432467	16-DEC-2019 22:15:27	           40.8
2002565268                    	       22430907	15-DEC-2019 18:35:17	          74.47
2002566453                    	       22432305	16-DEC-2019 19:45:17	          57.35
2002566198                    	       22432008	16-DEC-2019 15:20:14	          59.94
2002565175                    	       22430814	15-DEC-2019 16:40:21	          33.32
2002566304                    	       22432146	16-DEC-2019 16:45:29	          26.21
2002565684                    	       22431359	16-DEC-2019 09:10:13	          66.83
2002563962                    	       22429600	14-DEC-2019 06:00:29	          77.77
2002565518                    	       22431157	15-DEC-2019 23:45:10	          69.27
2002556061                    	       22420477	07-DEC-2019 21:20:21	          57.89
2002567680                    	       22438982	17-DEC-2019 21:16:48	          31.32
2002566340                    	       22432188	16-DEC-2019 17:15:22	          24.84
2002565660                    	       22431328	16-DEC-2019 08:55:13	           26.5
2002564981                    	       22430620	15-DEC-2019 12:35:23	          30.41
2002564935                    	       22430574	15-DEC-2019 11:00:34	          32.91
2002567393                    	       22438678	17-DEC-2019 16:00:40	           6.99
2002565595                    	       22431237	16-DEC-2019 07:36:33	          20.61
2002564958                    	       22430597	15-DEC-2019 11:35:40	          14.54
2002564155                    	       22429794	14-DEC-2019 10:45:12	          38.77
2002566660                    	       22434238	17-DEC-2019 00:10:36	          51.99
2002566597                    	       22432449	16-DEC-2019 21:46:42	          37.17
2002566122                    	       22431910	16-DEC-2019 14:10:21	          99.91
2002565956                    	       22431705	16-DEC-2019 12:15:33	          10.24
2002565261                    	       22430900	15-DEC-2019 18:20:20	          32.62
2002566293                    	       22432133	16-DEC-2019 16:35:24	          18.23
2002566646                    	       22434224	17-DEC-2019 00:01:13	          72.05
2002565373                    	       22431012	15-DEC-2019 20:25:25	           35.3
2002565968                    	       22431722	16-DEC-2019 12:35:07	          56.16
2002561912                    	       22427174	12-DEC-2019 09:31:45	          71.65
2002567528                    	       22438833	17-DEC-2019 19:20:21	          66.11
2002565793                    	       22431492	16-DEC-2019 10:30:19	          63.13
2002563510                    	       22429103	13-DEC-2019 14:50:22	          19.04
2002565082                    	       22430721	15-DEC-2019 14:45:14	          80.99
2002562027                    	       22427311	12-DEC-2019 10:56:42	         -18.99
2002566077                    	       22431859	16-DEC-2019 14:00:11	          830.8
2002566613                    	       22432465	16-DEC-2019 22:06:16	          21.38
2002552402                    	       22416566	05-DEC-2019 10:15:34	          14.06
2002565709                    	       22431397	16-DEC-2019 09:30:15	          64.51
2002566518                    	       22432370	16-DEC-2019 21:00:32	           24.7
2002563793                    	       22429431	13-DEC-2019 19:50:12	          20.13
2002566813                    	       22437289	17-DEC-2019 07:55:09	          18.93
2002565753                    	       22431455	16-DEC-2019 10:00:15	          49.21
2002565901                    	       22431636	16-DEC-2019 11:45:16	          19.63
2002563860                    	       22429498	13-DEC-2019 21:25:09	          57.76
2002564947                    	       22430586	15-DEC-2019 11:25:25	         104.52
2002567601                    	       22438903	17-DEC-2019 20:25:34	            -25
2002561864                    	       22427112	12-DEC-2019 08:46:48	          34.61
2002565402                    	       22431041	15-DEC-2019 20:55:09	          32.85
2002565742                    	       22431438	16-DEC-2019 09:50:13	          53.96
2002565667                    	       22431335	16-DEC-2019 08:55:22	          16.81
2002564990                    	       22430629	15-DEC-2019 12:45:17	          16.04
2002565775                    	       22431479	16-DEC-2019 10:20:16	          59.99
2002565115                    	       22430754	15-DEC-2019 15:30:14	          36.49
2002565380                    	       22431019	15-DEC-2019 20:35:15	          84.65
2002566115                    	       22431903	16-DEC-2019 14:10:15	          49.67
2002566118                    	       22431906	16-DEC-2019 14:10:18	          14.54
2002562222                    	       22427578	12-DEC-2019 13:55:12	          10.48
2002565598                    	       22431242	16-DEC-2019 07:45:12	          28.68
2002565500                    	       22431139	15-DEC-2019 23:05:26	          53.28
2002565394                    	       22431033	15-DEC-2019 20:45:15	         120.38
2002565884                    	       22431616	16-DEC-2019 11:35:27	          29.36
2002566593                    	       22432445	16-DEC-2019 21:46:18	           2.99
2002566390                    	       22432242	16-DEC-2019 18:25:24	         126.44
2002565169                    	       22430808	15-DEC-2019 16:40:12	         264.04
2002564776                    	       22430415	15-DEC-2019 06:10:26	           66.3
2002566877                    	       22437370	17-DEC-2019 09:00:23	           3.27
2002561677                    	       22426910	11-DEC-2019 22:19:38	          17.11
2002565208                    	       22430847	15-DEC-2019 17:20:19	          27.65
2002567099                    	       22438314	17-DEC-2019 11:55:29	         228.35
2002565927                    	       22431674	16-DEC-2019 12:05:12	          25.42
2002564856                    	       22430495	15-DEC-2019 09:06:09	          73.73
2002567077                    	       22438285	17-DEC-2019 11:45:23	          18.97
2002565328                    	       22430967	15-DEC-2019 19:45:16	             11
2002565486                    	       22431125	15-DEC-2019 22:27:21	          18.27
2002552821                    	       22417049	05-DEC-2019 13:17:44	         298.96
2002564964                    	       22430603	15-DEC-2019 11:45:28	          55.64
2002563854                    	       22429492	13-DEC-2019 21:15:11	          16.83
2002563871                    	       22429509	13-DEC-2019 21:50:16	          42.38
2002565333                    	       22430972	15-DEC-2019 19:45:23	          28.24
2002565987                    	       22431742	16-DEC-2019 12:45:20	           86.6
2002566479                    	       22432331	16-DEC-2019 20:05:48	          80.24
2002566192                    	       22432000	16-DEC-2019 15:10:20	          21.05
2002565971                    	       22431725	16-DEC-2019 12:35:13	          80.42
2002565541                    	       22431180	16-DEC-2019 01:25:10	          43.55
2002566372                    	       22432224	16-DEC-2019 18:15:16	           28.1
2002566774                    	       22437246	17-DEC-2019 06:30:15	          32.34
2002565200                    	       22430839	15-DEC-2019 17:10:42	          35.65
2002567050                    	       22438255	17-DEC-2019 11:35:11	          11.66
2002566913                    	       22437418	17-DEC-2019 09:35:14	           5.99
2002566483                    	       22432335	16-DEC-2019 20:15:11	          33.46
2002566432                    	       22432284	16-DEC-2019 19:25:10	         116.53
2002565491                    	       22431130	15-DEC-2019 23:05:14	          35.75
2002545689                    	       22409061	01-DEC-2019 11:50:20	          21.69
2002566466                    	       22432318	16-DEC-2019 20:05:18	          16.49
2002565338                    	       22430977	15-DEC-2019 19:55:25	          18.56
2002563918                    	       22429556	13-DEC-2019 23:50:10	          34.45
2002566011                    	       22431774	16-DEC-2019 13:05:23	          14.32
2002565167                    	       22430806	15-DEC-2019 16:30:23	          17.78
2002565293                    	       22430932	15-DEC-2019 19:05:15	          43.36
2002565120                    	       22430759	15-DEC-2019 15:30:24	          29.16
2002567220                    	       22438458	17-DEC-2019 13:20:35	          19.99
2002566854                    	       22437343	17-DEC-2019 08:40:19	          25.67
2002550542                    	       22414464	03-DEC-2019 21:10:27	           -.05
2002565961                    	       22431709	16-DEC-2019 12:18:54	           89.5
2002566543                    	       22432395	16-DEC-2019 21:04:12	           92.1
2002565411                    	       22431050	15-DEC-2019 20:55:20	          16.65
2002558029                    	       22422494	09-DEC-2019 09:14:25	         483.21
2002561195                    	       22426357	11-DEC-2019 14:30:19	          14.72
2002566584                    	       22432436	16-DEC-2019 21:24:39	         328.71
2002565958                    	       22431707	16-DEC-2019 12:15:36	          53.37
2002562499                    	       22427922	12-DEC-2019 18:05:24	          18.83
2002565441                    	       22431080	15-DEC-2019 21:25:20	          15.01
2002566624                    	       22432476	16-DEC-2019 22:25:50	          22.92
2002566171                    	       22431975	16-DEC-2019 14:50:11	          97.23
2002567024                    	       22438222	17-DEC-2019 11:15:16	          21.54
2002564821                    	       22430460	15-DEC-2019 08:05:59	          36.69
2002565318                    	       22430957	15-DEC-2019 19:35:18	           7.19
2002565285                    	       22430924	15-DEC-2019 18:55:11	          20.51
2002566235                    	       22432058	16-DEC-2019 15:59:20	          22.98
2002564748                    	       22430387	15-DEC-2019 00:35:07	          96.28
2002565526                    	       22431165	16-DEC-2019 00:15:09	          28.61
2002563930                    	       22429568	14-DEC-2019 00:40:07	          30.59
2002566750                    	       22437222	17-DEC-2019 05:30:13	         250.16
2002565587                    	       22431227	16-DEC-2019 07:20:12	          11.24
2002564360                    	       22429999	14-DEC-2019 14:40:15	          19.32
2002563505                    	       22429098	13-DEC-2019 14:50:16	          44.42
2002565211                    	       22430850	15-DEC-2019 17:30:14	            9.2
2002565911                    	       22431653	16-DEC-2019 11:55:15	          54.64
2002565314                    	       22430953	15-DEC-2019 19:35:13	           19.2
2002566434                    	       22432286	16-DEC-2019 19:25:12	          23.53
2002564283                    	       22429922	14-DEC-2019 13:15:17	           97.4
2002565089                    	       22430728	15-DEC-2019 14:55:19	          56.44
2002562340                    	       22427728	12-DEC-2019 15:15:10	          21.19
2002566481                    	       22432333	16-DEC-2019 20:15:09	           5.76
2002566870                    	       22437361	17-DEC-2019 08:50:21	          25.71
2002565416                    	       22431055	15-DEC-2019 21:05:13	          48.36
2002564026                    	       22429664	14-DEC-2019 08:25:16	          19.04
2002566175                    	       22431979	16-DEC-2019 14:50:15	          15.57
2002566407                    	       22432259	16-DEC-2019 18:55:13	           2.58
2002565996                    	       22431755	16-DEC-2019 12:55:08	          12.71
2002566078                    	       22431860	16-DEC-2019 14:00:12	         117.65
2002566355                    	       22432206	16-DEC-2019 17:50:18	          23.31
2002566678                    	       22434256	17-DEC-2019 00:11:20	          33.54
2002561366                    	       22426580	11-DEC-2019 16:36:09	          48.98
2002564857                    	       22430496	15-DEC-2019 09:06:19	          23.53
2002566637                    	       22434215	17-DEC-2019 00:00:17	          99.53
2002566058                    	       22431834	16-DEC-2019 13:40:24	          24.27
2002566541                    	       22432393	16-DEC-2019 21:04:01	          56.16
2002565121                    	       22430760	15-DEC-2019 15:30:26	          53.37
2002566147                    	       22431941	16-DEC-2019 14:30:27	          25.73
2002566968                    	       22437488	17-DEC-2019 10:20:43	          11.66
2002566644                    	       22434222	17-DEC-2019 00:01:05	          35.71
2002565388                    	       22431027	15-DEC-2019 20:35:22	          93.53
2002565022                    	       22430661	15-DEC-2019 13:30:14	          39.39
2002565602                    	       22431246	16-DEC-2019 07:45:16	          15.19
2002566187                    	       22431995	16-DEC-2019 15:10:15	          20.53
2002566365                    	       22432217	16-DEC-2019 18:00:08	          33.46
2002562259                    	       22427621	12-DEC-2019 14:10:00	         198.85
2002565559                    	       22431198	16-DEC-2019 05:50:08	           20.5
2002565477                    	       22431116	15-DEC-2019 22:16:18	          39.23
2002566360                    	       22432211	16-DEC-2019 17:50:25	          42.49
2002565530                    	       22431169	16-DEC-2019 00:25:09	          50.59
2002566570                    	       22432422	16-DEC-2019 21:22:44	          17.19
2002565105                    	       22430744	15-DEC-2019 15:15:29	          38.45
2002566182                    	       22431988	16-DEC-2019 15:00:13	          49.21
2002565577                    	       22431217	16-DEC-2019 07:00:08	           24.6
2002565811                    	       22431524	16-DEC-2019 10:50:12	           33.6
2002566133                    	       22431917	16-DEC-2019 14:22:05	          86.88
2002566021                    	       22431785	16-DEC-2019 13:15:13	          70.81
2002565320                    	       22430959	15-DEC-2019 19:35:20	          30.32
2002565067                    	       22430706	15-DEC-2019 14:25:22	          80.05
2002566076                    	       22431858	16-DEC-2019 14:00:09	         306.35
2002566617                    	       22432469	16-DEC-2019 22:15:47	          37.71
2002557355                    	       22421771	08-DEC-2019 19:50:13	          21.39
2002566411                    	       22432263	16-DEC-2019 18:55:16	          84.17
2002566840                    	       22437322	17-DEC-2019 08:26:07	         239.58
2002564965                    	       22430604	15-DEC-2019 11:45:30	           16.4
2002565012                    	       22430651	15-DEC-2019 13:10:14	          15.19
2002566692                    	       22434270	17-DEC-2019 01:00:06	           6.93
2002565018                    	       22430657	15-DEC-2019 13:20:16	          49.78
2002566245                    	       22432071	16-DEC-2019 16:05:23	          19.46
2002567095                    	       22438310	17-DEC-2019 11:55:24	             50
2002567448                    	       22438748	17-DEC-2019 17:15:14	            100
2002565816                    	       22431529	16-DEC-2019 10:50:20	          29.49
2002566614                    	       22432466	16-DEC-2019 22:15:22	           29.5
2002566493                    	       22432345	16-DEC-2019 20:40:09	          81.08
2002565006                    	       22430645	15-DEC-2019 13:00:44	           38.5
2002565714                    	       22431402	16-DEC-2019 09:30:20	          43.93
2002565259                    	       22430898	15-DEC-2019 18:20:17	           35.3
2002565136                    	       22430775	15-DEC-2019 15:50:20	          10.74
2002566907                    	       22437411	17-DEC-2019 09:25:16	          28.97
2002566130                    	       22431922	16-DEC-2019 14:20:17	           39.2
2002561896                    	       22427153	12-DEC-2019 09:10:17	          20.94
2002564946                    	       22430585	15-DEC-2019 11:25:20	          32.06
2002564319                    	       22429958	14-DEC-2019 13:55:17	          15.66
2002565969                    	       22431723	16-DEC-2019 12:35:08	            -20
2002566210                    	       22432022	16-DEC-2019 15:30:32	            7.6
2002566327                    	       22432172	16-DEC-2019 17:05:20	          17.47
2002567189                    	       22438423	17-DEC-2019 13:00:28	          60.54
2002565118                    	       22430757	15-DEC-2019 15:30:19	           40.1
2002524149                    	       22334562	08-NOV-2019 11:26:02	          -4.25
2002565461                    	       22431100	15-DEC-2019 22:02:36	          93.95
2002565080                    	       22430719	15-DEC-2019 14:45:08	          44.51
2002564395                    	       22430034	14-DEC-2019 15:10:25	         110.54
2002565894                    	       22431629	16-DEC-2019 11:45:10	          68.31
2002566788                    	       22437260	17-DEC-2019 07:00:07	          12.71
2002566641                    	       22434219	17-DEC-2019 00:00:47	          33.47
2002562860                    	       22428283	13-DEC-2019 06:10:07	          21.19
2002565523                    	       22431162	15-DEC-2019 23:55:08	         107.04
2002565629                    	       22431285	16-DEC-2019 08:15:09	           6.89
2002565360                    	       22430999	15-DEC-2019 20:15:38	          22.27
2002566170                    	       22431974	16-DEC-2019 14:50:10	          43.17
2002565866                    	       22431582	16-DEC-2019 11:26:08	          19.36
2002566195                    	       22432004	16-DEC-2019 15:15:51	          65.08
2002567923                    	       22439225	18-DEC-2019 05:30:17	           8.55
2002566229                    	       22432052	16-DEC-2019 15:55:10	          13.53
2002566391                    	       22432243	16-DEC-2019 18:35:08	          15.63
2002567156                    	       22438384	17-DEC-2019 12:35:23	          32.27
2002565226                    	       22430865	15-DEC-2019 17:40:27	           68.7
2002565255                    	       22430894	15-DEC-2019 18:10:21	          71.99
2002532481                    	       22347645	17-NOV-2019 22:11:36	          39.32
2002566606                    	       22432458	16-DEC-2019 21:55:29	          38.41
2002567576                    	       22438878	17-DEC-2019 20:15:23	             15
2002563892                    	       22429530	13-DEC-2019 22:35:45	          17.54
2002564798                    	       22430437	15-DEC-2019 07:25:29	          34.13
2002565371                    	       22431010	15-DEC-2019 20:25:23	          35.71
2002563915                    	       22429553	13-DEC-2019 23:30:11	          21.64
2002564945                    	       22430584	15-DEC-2019 11:25:15	          31.49
2002566515                    	       22432367	16-DEC-2019 21:00:16	          67.38
2002565883                    	       22431615	16-DEC-2019 11:35:26	          48.98
2002565417                    	       22431056	15-DEC-2019 21:05:13	         107.96
2002563792                    	       22429430	13-DEC-2019 19:50:12	           43.4
2002568048                    	       22439355	18-DEC-2019 08:07:51	         -14.03
2002563905                    	       22429543	13-DEC-2019 23:20:50	          12.02
2002566196                    	       22432006	16-DEC-2019 15:20:10	           9.53
2002565640                    	       22431302	16-DEC-2019 08:35:20	          16.57
2002565797                    	       22431508	16-DEC-2019 10:40:07	          78.95
2002566956                    	       22437476	17-DEC-2019 10:20:16	          19.98
2002565149                    	       22430788	15-DEC-2019 16:10:11	          79.99
2002567287                    	       22438535	17-DEC-2019 14:15:19	          22.56
2002565071                    	       22430710	15-DEC-2019 14:35:15	          24.05
2002566945                    	       22437465	17-DEC-2019 10:11:15	          39.98
2002558628                    	       22423227	09-DEC-2019 14:20:34	          21.29
2002565316                    	       22430955	15-DEC-2019 19:35:16	          49.15
2002565600                    	       22431244	16-DEC-2019 07:45:15	          94.17
2002565191                    	       22430830	15-DEC-2019 17:00:11	          32.08
2002567312                    	       22438569	17-DEC-2019 14:35:30	          13.99
2002566490                    	       22432342	16-DEC-2019 20:30:16	          21.67
2002566450                    	       22432302	16-DEC-2019 19:45:14	          36.49
2002566628                    	       22433208	16-DEC-2019 22:56:31	          49.09
2002565275                    	       22430914	15-DEC-2019 18:35:30	           9.68
2002558666                    	       22423274	09-DEC-2019 14:40:17	           5.09
2002565291                    	       22430930	15-DEC-2019 19:05:13	          11.98
2002564960                    	       22430599	15-DEC-2019 11:45:16	          56.16
2002565835                    	       22431553	16-DEC-2019 11:00:28	          29.49
2002565988                    	       22431743	16-DEC-2019 12:46:49	          79.34
2002565236                    	       22430875	15-DEC-2019 18:00:16	          15.67
2002566079                    	       22431861	16-DEC-2019 14:00:13	         185.75
2002565396                    	       22431035	15-DEC-2019 20:45:18	          38.15
2002566562                    	       22432414	16-DEC-2019 21:21:19	          60.98
2002565521                    	       22431160	15-DEC-2019 23:55:05	          34.13
2002547786                    	       22411318	02-DEC-2019 14:37:45	          40.54
2002566770                    	       22437242	17-DEC-2019 06:20:10	          38.15
2002566761                    	       22437233	17-DEC-2019 06:10:09	          55.38
2002567232                    	       22438471	17-DEC-2019 13:30:23	             25
2002566881                    	       22437374	17-DEC-2019 09:00:31	          10.51
2002565743                    	       22431439	16-DEC-2019 09:50:14	          158.4
2002565963                    	       22431715	16-DEC-2019 12:25:11	          17.12
2002565037                    	       22430676	15-DEC-2019 13:50:07	          13.93
2002561238                    	       22426410	11-DEC-2019 15:05:28	          19.11
2002566131                    	       22431923	16-DEC-2019 14:20:18	          12.83
2002565406                    	       22431045	15-DEC-2019 20:55:14	          44.22
2002562921                    	       22428346	13-DEC-2019 07:45:15	          63.95
2002564110                    	       22429749	14-DEC-2019 09:55:15	             15
2002566463                    	       22432315	16-DEC-2019 19:55:16	          21.69
2002566736                    	       22437208	17-DEC-2019 03:10:10	          19.01
2002564447                    	       22430086	14-DEC-2019 16:20:09	          24.66
2002563980                    	       22429618	14-DEC-2019 07:00:12	          36.63
2002565544                    	       22431183	16-DEC-2019 02:15:10	           9.32
2002566368                    	       22432220	16-DEC-2019 18:00:12	           86.7
2002521642                    	       22327960	05-NOV-2019 13:55:17	          32.19
2002536595                    	       22397275	21-NOV-2019 16:30:20	            -25
2002550746                    	       22414668	04-DEC-2019 06:05:13	         -14.83
2002558602                    	       22423193	09-DEC-2019 14:05:23	          38.51
2002522236                    	       22332347	06-NOV-2019 08:25:22	          13.92
2002522288                    	       22332422	06-NOV-2019 09:07:23	            .71
2002524991                    	       22335474	09-NOV-2019 16:30:07	          16.16
2002538890                    	       22401464	24-NOV-2019 20:05:35	           4.26
2002538889                    	       22401463	24-NOV-2019 20:05:34	          30.92
2002543459                    	       22406831	29-NOV-2019 16:40:15	          21.24
2002543419                    	       22406791	29-NOV-2019 16:20:21	          21.59
2002542056                    	       22405428	28-NOV-2019 14:15:12	          37.98
2002541984                    	       22405356	28-NOV-2019 11:25:10	          19.59
2002530150                    	       22345222	14-NOV-2019 19:30:12	           20.9
2002538222                    	       22400796	23-NOV-2019 19:30:14	          38.93
2002524261                    	       22334710	08-NOV-2019 12:55:18	           2.12
2002548563                    	       22412209	02-DEC-2019 19:40:39	         408.24
2002521375                    	       22327639	05-NOV-2019 10:45:12	           -.21
2002521378                    	       22327642	05-NOV-2019 10:45:15	          -4.57
2002521358                    	       22327617	05-NOV-2019 10:25:26	          11.72
2002521758                    	       22328239	05-NOV-2019 15:12:03	            .33
2002535056                    	       22366216	20-NOV-2019 11:00:45	          -3.92
2002530576                    	       22345705	15-NOV-2019 12:30:26	           -.66
2002530849                    	       22346008	15-NOV-2019 16:35:08	          -2.53
2002533203                    	       22348465	18-NOV-2019 15:10:28	          20.08
2002533157                    	       22348410	18-NOV-2019 14:30:20	          21.64
2002546112                    	       22409473	01-DEC-2019 18:05:33	            6.2
2002523406                    	       22333728	07-NOV-2019 13:05:27	           3.68
2002560658                    	       22425689	11-DEC-2019 08:10:38	          17.37
2002526476                    	       22337065	11-NOV-2019 12:45:21	          18.34
2002524913                    	       22335396	09-NOV-2019 13:50:12	           5.59
2002548378                    	       22412015	02-DEC-2019 18:45:45	           -.96
2002538973                    	       22401547	24-NOV-2019 22:05:28	          15.73
2002539787                    	       22402506	25-NOV-2019 19:25:11	         127.01
2002553450                    	       22417747	05-DEC-2019 20:20:19	         -11.77
2002520916                    	       22327116	04-NOV-2019 19:30:17	        4601.41
2002549161                    	       22412807	03-DEC-2019 04:25:07	          39.33
2002561853                    	       22427087	12-DEC-2019 08:31:05	          16.23
2002545319                    	       22408691	30-NOV-2019 22:30:30	          22.09
2002545870                    	       22409231	01-DEC-2019 14:50:14	          -1.46
2002541000                    	       22403923	26-NOV-2019 23:15:15	           -.02
2002542201                    	       22405573	28-NOV-2019 19:55:12	          -5.33
2002526886                    	       22338356	11-NOV-2019 19:05:17	          29.49
2002567245                    	       22438487	17-DEC-2019 13:40:37	         104.63
2002567249                    	       22438491	17-DEC-2019 13:40:42	          16.89
2002567244                    	       22438486	17-DEC-2019 13:40:36	          13.99
2002567906                    	       22439208	18-DEC-2019 04:45:16	           4.23
2002538917                    	       22401491	24-NOV-2019 20:45:28	          19.85
2002538913                    	       22401487	24-NOV-2019 20:45:24	           7.67
2002561182                    	       22426339	11-DEC-2019 14:20:29	          21.19
2002545622                    	       22408994	01-DEC-2019 10:50:24	           4.99
2002559201                    	       22423888	09-DEC-2019 20:55:12	          -4.55
2002539674                    	       22402380	25-NOV-2019 16:50:11	          16.36
2002539209                    	       22401810	25-NOV-2019 09:34:02	          -3.28
2002552307                    	       22416458	05-DEC-2019 09:35:23	           6.29
2002562435                    	       22427846	12-DEC-2019 16:45:13	          22.13
2002558718                    	       22423339	09-DEC-2019 15:15:24	          15.28
2002553752                    	       22418049	06-DEC-2019 07:25:12	          19.56
2002545881                    	       22409242	01-DEC-2019 15:00:16	          21.64
2002545888                    	       22409249	01-DEC-2019 15:00:30	            2.6
2002525127                    	       22335610	09-NOV-2019 20:30:13	           9.61
2002561214                    	       22426379	11-DEC-2019 14:45:35	         -36.87
2002561379                    	       22426596	11-DEC-2019 16:45:54	          88.96
2002560735                    	       22425793	11-DEC-2019 09:10:18	            .96
2002548825                    	       22412471	02-DEC-2019 21:21:05	          25.56
2002551987                    	       22416135	04-DEC-2019 21:50:14	          19.47
2002527548                    	       22339060	12-NOV-2019 12:06:03	          -1.84
2002541547                    	       22404601	27-NOV-2019 16:16:24	          21.05
2002556766                    	       22421182	08-DEC-2019 13:05:10	           2.62
2002530902                    	       22346063	15-NOV-2019 17:25:15	           9.78
2002525532                    	       22336011	10-NOV-2019 14:30:28	           2.87
2002550704                    	       22414626	04-DEC-2019 00:10:14	          -1.44
2002540527                    	       22403366	26-NOV-2019 13:45:21	          34.35
2002540524                    	       22403363	26-NOV-2019 13:45:18	          10.61
2002530103                    	       22345175	14-NOV-2019 18:30:10	           1.48
2002562473                    	       22427893	12-DEC-2019 17:35:14	          21.19
2002532053                    	       22347217	17-NOV-2019 14:10:16	         -34.99
2002532054                    	       22347218	17-NOV-2019 14:10:19	          61.14
2002564388                    	       22430027	14-DEC-2019 15:10:13	          21.39
2002558797                    	       22423430	09-DEC-2019 15:55:54	          36.37
2002540089                    	       22402811	26-NOV-2019 07:30:12	          41.26
2002568044                    	       22439351	18-DEC-2019 08:05:28	            594
2002538969                    	       22401543	24-NOV-2019 21:55:14	           -.05
2002538949                    	       22401523	24-NOV-2019 21:25:10	           8.38
2002542187                    	       22405559	28-NOV-2019 19:25:07	          25.67
2002542259                    	       22405631	28-NOV-2019 21:30:09	          -5.13
2002558000                    	       22422450	09-DEC-2019 08:55:23	          37.43
2002557989                    	       22422438	09-DEC-2019 08:55:11	           5.18
2002554882                    	       22419298	06-DEC-2019 21:15:20	          21.19
2002548879                    	       22412525	02-DEC-2019 21:40:54	           4.55
2002544820                    	       22408192	30-NOV-2019 15:50:17	          21.36
2002518796                    	       22324523	02-NOV-2019 10:05:12	          -6.68
2002557172                    	       22421588	08-DEC-2019 17:45:11	          10.69
2002537822                    	       22400395	23-NOV-2019 10:25:14	           3.95
2002563444                    	       22429015	13-DEC-2019 13:55:25	           56.7
2002535020                    	       22364215	20-NOV-2019 10:25:42	           18.8
2002567319                    	       22438585	17-DEC-2019 14:50:19	            -50
2002552383                    	       22416540	05-DEC-2019 10:10:11	            .43
2002555506                    	       22419922	07-DEC-2019 12:35:21	          54.44
2002538944                    	       22401518	24-NOV-2019 21:15:20	          19.48
2002550073                    	       22413924	03-DEC-2019 14:45:19	          83.99
2002555808                    	       22420224	07-DEC-2019 18:00:09	          10.81
2002535500                    	       22375235	20-NOV-2019 17:00:53	        -102.47
2002528497                    	       22343293	13-NOV-2019 08:05:16	           2.79
2002547512                    	       22411003	02-DEC-2019 13:00:16	          19.63
2002556789                    	       22421205	08-DEC-2019 13:20:18	          21.59
2002561100                    	       22426241	11-DEC-2019 13:10:16	            5.2
2002525069                    	       22335552	09-NOV-2019 19:00:08	          95.36
2002542303                    	       22405675	28-NOV-2019 23:10:08	          14.19
2002528420                    	       22343212	13-NOV-2019 01:35:07	          17.25
2002550670                    	       22414592	03-DEC-2019 23:20:10	           22.8
2002563401                    	       22428958	13-DEC-2019 13:35:11	          47.37
2002563405                    	       22428962	13-DEC-2019 13:35:16	           3.59
2002562878                    	       22428301	13-DEC-2019 06:30:29	          19.47
2002562872                    	       22428295	13-DEC-2019 06:30:21	          37.95
2002564972                    	       22430611	15-DEC-2019 12:20:30	         102.66
2002564974                    	       22430613	15-DEC-2019 12:20:48	          35.51
2002564975                    	       22430614	15-DEC-2019 12:20:57	          57.36
2002550016                    	       22413858	03-DEC-2019 14:15:20	          19.32
2002553535                    	       22417832	05-DEC-2019 21:21:37	          21.66
2002561584                    	       22426817	11-DEC-2019 20:40:21	          -4.87
2002564515                    	       22430154	14-DEC-2019 17:50:15	          42.67
2002546404                    	       22409765	01-DEC-2019 21:10:19	           6.34
2002562447                    	       22427862	12-DEC-2019 17:00:56	            600
2002562852                    	       22428275	13-DEC-2019 05:40:11	          21.39
2002562910                    	       22428334	13-DEC-2019 07:35:11	          15.53
2002547823                    	       22411367	02-DEC-2019 15:00:16	          19.99
2002537843                    	       22400416	23-NOV-2019 10:45:10	          19.19
2002556618                    	       22421034	08-DEC-2019 10:50:37	           8.47
2002537665                    	       22400238	23-NOV-2019 02:25:14	          35.97
2002539938                    	       22402659	25-NOV-2019 21:40:23	          19.87
2002558100                    	       22422584	09-DEC-2019 09:54:13	           69.5
2002567294                    	       22438543	17-DEC-2019 14:25:17	            -50
2002567273                    	       22438519	17-DEC-2019 14:05:16	         217.39
2002567272                    	       22438518	17-DEC-2019 14:05:15	          59.99
2002556974                    	       22421390	08-DEC-2019 15:25:18	          10.59
2002529713                    	       22344702	14-NOV-2019 12:25:20	          19.99
2002546638                    	       22409999	02-DEC-2019 04:55:10	           56.7
2002541035                    	       22403958	27-NOV-2019 02:15:17	          10.39
2002548900                    	       22412546	02-DEC-2019 21:55:16	           9.82
2002563183                    	       22428675	13-DEC-2019 11:21:28	         186.36
2002562717                    	       22428140	12-DEC-2019 22:13:06	          87.19
2002560887                    	       22425991	11-DEC-2019 10:45:12	         -12.59
2002564132                    	       22429771	14-DEC-2019 10:15:25	          64.79
2002554535                    	       22418961	06-DEC-2019 16:03:50	            .74
2002564866                    	       22430505	15-DEC-2019 09:20:45	          56.28
2002565032                    	       22430671	15-DEC-2019 13:40:09	          13.37
2002565033                    	       22430672	15-DEC-2019 13:40:11	          55.65
2002536698                    	       22398273	21-NOV-2019 18:40:15	          21.05
2002537578                    	       22399427	22-NOV-2019 20:20:11	           7.71
2002551943                    	       22416091	04-DEC-2019 21:01:01	          16.32
2002558565                    	       22423143	09-DEC-2019 13:45:17	           5.18
2002563392                    	       22428945	13-DEC-2019 13:25:14	          38.51
2002561958                    	       22427236	12-DEC-2019 10:04:34	         142.15
2002561957                    	       22427233	12-DEC-2019 10:01:43	          52.41
2002561955                    	       22427230	12-DEC-2019 09:59:16	           -.01
2002563695                    	       22429333	13-DEC-2019 17:35:13	          19.54
2002555470                    	       22419886	07-DEC-2019 12:15:09	          19.65
2002545646                    	       22409018	01-DEC-2019 11:06:18	         -44.03
2002534314                    	       22359214	19-NOV-2019 15:10:55	          15.89
2002552056                    	       22416204	04-DEC-2019 23:40:15	         -30.39
2002540361                    	       22403159	26-NOV-2019 11:30:20	          31.44
2002558278                    	       22422799	09-DEC-2019 11:15:13	          21.64
2002531640                    	       22346804	16-NOV-2019 18:50:09	          80.82
2002558257                    	       22422774	09-DEC-2019 11:05:46	          19.24
2002531478                    	       22346642	16-NOV-2019 14:45:11	         -45.84
2002565696                    	       22431379	16-DEC-2019 09:20:08	          10.14
2002566744                    	       22437216	17-DEC-2019 04:50:07	             16
2002565697                    	       22431380	16-DEC-2019 09:20:08	          29.65
2002567791                    	       22439093	17-DEC-2019 22:57:05	           13.6
2002554105                    	       22418475	06-DEC-2019 11:45:10	          15.97
2002523464                    	       22333794	07-NOV-2019 13:55:17	           9.57
2002537423                    	       22399258	22-NOV-2019 16:10:17	          21.05
2002541634                    	       22404690	27-NOV-2019 18:55:15	          40.52
2002562952                    	       22428382	13-DEC-2019 08:16:59	           37.9
2002541932                    	       22405304	28-NOV-2019 09:35:10	           8.41
2002544880                    	       22408252	30-NOV-2019 16:30:16	          -1.29
2002526115                    	       22336620	11-NOV-2019 09:04:31	         107.69
2002556942                    	       22421358	08-DEC-2019 15:05:16	           4.78
2002537778                    	       22400351	23-NOV-2019 09:25:13	          19.74
2002542567                    	       22405939	29-NOV-2019 09:05:14	           -.01
2002522205                    	       22332303	06-NOV-2019 07:55:09	           4.28
2002530984                    	       22346145	15-NOV-2019 19:45:53	          19.99
2002556339                    	       22420755	08-DEC-2019 07:11:28	          18.37
2002558637                    	       22423237	09-DEC-2019 14:27:58	            .32
2002557943                    	       22422370	09-DEC-2019 08:19:16	         -16.42
2002554428                    	       22418849	06-DEC-2019 15:03:37	          51.97
2002558151                    	       22422655	09-DEC-2019 10:23:58	            .31
2002536514                    	       22396230	21-NOV-2019 15:37:02	          41.49
2002562763                    	       22428186	13-DEC-2019 00:15:15	           9.63
2002553828                    	       22418135	06-DEC-2019 08:52:16	         390.36
2002552548                    	       22416738	05-DEC-2019 11:15:11	         -10.93
2002551479                    	       22415569	04-DEC-2019 14:10:34	          33.01
2002567150                    	       22438374	17-DEC-2019 12:32:00	          61.66
2002520050                    	       22325766	04-NOV-2019 06:25:07	           1.99
2002567147                    	       22438370	17-DEC-2019 12:25:35	           4.23
2002567415                    	       22438710	17-DEC-2019 16:35:09	            100
2002557770                    	       22422186	08-DEC-2019 23:50:10	           -.07
2002537695                    	       22400268	23-NOV-2019 07:10:11	          18.76
2002541018                    	       22403941	27-NOV-2019 00:15:11	           -.66
2002559950                    	       22424780	10-DEC-2019 14:10:18	          61.71
2002523502                    	       22333845	07-NOV-2019 14:40:11	           6.63
2002547448                    	       22410905	02-DEC-2019 12:32:58	         -19.59
2002561665                    	       22426898	11-DEC-2019 22:05:47	          21.51
2002550447                    	       22414369	03-DEC-2019 19:51:59	           7.51
2002553149                    	       22417429	05-DEC-2019 16:11:10	           16.8
2002548656                    	       22412302	02-DEC-2019 20:20:26	          12.95
2002567257                    	       22438500	17-DEC-2019 13:55:27	          13.38
2002537551                    	       22399400	22-NOV-2019 19:20:10	           -.21
2002559002                    	       22423689	09-DEC-2019 18:20:22	          28.56
2002558639                    	       22423242	09-DEC-2019 14:30:13	         -45.09
2002549040                    	       22412686	02-DEC-2019 23:20:22	         -10.72
2002566031                    	       22431797	16-DEC-2019 13:23:06	           69.5
2002528269                    	       22342361	12-NOV-2019 21:11:04	         -27.13
2002543262                    	       22406634	29-NOV-2019 15:00:10	          21.19
2002554425                    	       22418846	06-DEC-2019 15:00:25	          19.79
2002525596                    	       22336075	10-NOV-2019 16:05:13	           8.35
2002563276                    	       22428799	13-DEC-2019 12:15:10	          21.24
2002562266                    	       22427635	12-DEC-2019 14:15:21	          33.26
2002560881                    	       22425982	11-DEC-2019 10:39:24	           40.1
2002565574                    	       22431213	16-DEC-2019 06:40:08	          17.07
2002567705                    	       22439007	17-DEC-2019 21:35:32	         -24.49
2002562014                    	       22427299	12-DEC-2019 10:45:18	          35.35
2002552968                    	       22417215	05-DEC-2019 14:15:52	         189.18
2002540075                    	       22402797	26-NOV-2019 07:00:13	          16.31
2002564653                    	       22430292	14-DEC-2019 21:00:12	          30.93
2002568008                    	       22439314	18-DEC-2019 07:45:12	           4.67
2002544740                    	       22408112	30-NOV-2019 14:50:12	          19.43
2002560752                    	       22425815	11-DEC-2019 09:20:16	          36.36
2002553286                    	       22417583	05-DEC-2019 18:15:30	          10.59
2002545704                    	       22409076	01-DEC-2019 12:10:12	          39.18
2002538547                    	       22401121	24-NOV-2019 12:35:26	           8.17
2002530752                    	       22345901	15-NOV-2019 15:20:17	         -21.85
2002541144                    	       22404089	27-NOV-2019 08:47:55	             .3
2002549226                    	       22412872	03-DEC-2019 07:10:11	          27.72
2002558401                    	       22422955	09-DEC-2019 12:30:13	          19.07
2002518216                    	       22323243	01-NOV-2019 12:35:10	           2.91
2002526459                    	       22337045	11-NOV-2019 12:25:29	         -68.97
2002552820                    	       22417046	05-DEC-2019 13:12:08	            .28
2002530921                    	       22346082	15-NOV-2019 18:00:26	         -47.49
2002563454                    	       22429031	13-DEC-2019 14:05:13	           22.1
2002567179                    	       22438413	17-DEC-2019 12:50:20	            600
2002526080                    	       22336579	11-NOV-2019 08:40:11	          -6.99
2002520669                    	       22326830	04-NOV-2019 15:39:33	          82.06
2002560082                    	       22424937	10-DEC-2019 15:20:17	           4.32
2002524078                    	       22334472	08-NOV-2019 10:30:25	           -.21
2002561090                    	       22426229	11-DEC-2019 13:06:35	          53.96
2002524834                    	       22335317	09-NOV-2019 11:20:16	          -2.12
2002545241                    	       22408613	30-NOV-2019 21:25:09	          13.66
2002558094                    	       22422578	09-DEC-2019 09:50:22	           6.99
2002562809                    	       22428232	13-DEC-2019 03:45:11	           17.5
2002548270                    	       22411903	02-DEC-2019 17:50:12	          41.87
2002562880                    	       22428303	13-DEC-2019 06:40:17	            9.7
2002558324                    	       22422853	09-DEC-2019 11:36:21	          21.05
2002553802                    	       22418105	06-DEC-2019 08:27:03	          -62.3
2002543957                    	       22407329	29-NOV-2019 21:50:07	          71.59
2002553412                    	       22417709	05-DEC-2019 19:50:33	         -27.22
2002536574                    	       22397251	21-NOV-2019 16:20:08	          21.46
2002561048                    	       22426177	11-DEC-2019 12:40:10	          34.67
2002551058                    	       22415050	04-DEC-2019 10:43:59	          11.88
2002555073                    	       22419489	07-DEC-2019 05:50:10	          55.64
2002554978                    	       22419394	06-DEC-2019 22:59:33	          -6.57
2002530045                    	       22345111	14-NOV-2019 17:10:26	          -9.19
2002535840                    	       22387232	20-NOV-2019 21:20:42	        -121.67
2002556513                    	       22420929	08-DEC-2019 09:26:23	           54.5
2002556433                    	       22420849	08-DEC-2019 08:35:45	          56.57
2002540742                    	       22403664	26-NOV-2019 17:05:15	          19.25
2002552793                    	       22417005	05-DEC-2019 13:00:37	          21.34
2002552130                    	       22416278	05-DEC-2019 06:40:10	          26.14
2002552178                    	       22416327	05-DEC-2019 07:55:23	          40.66
2002551796                    	       22415944	04-DEC-2019 18:35:10	          21.84
2002563421                    	       22428985	13-DEC-2019 13:45:09	          10.91
2002565134                    	       22430773	15-DEC-2019 15:50:16	          41.99
2002566137                    	       22431931	16-DEC-2019 14:30:12	          35.48
2002544710                    	       22408082	30-NOV-2019 14:20:14	          34.49
2002567295                    	       22438544	17-DEC-2019 14:25:27	           6.54
2002565846                    	       22431567	16-DEC-2019 11:15:17	           14.2
2002565040                    	       22430679	15-DEC-2019 13:50:10	          38.43
2002562997                    	       22428444	13-DEC-2019 09:04:34	          24.34
2002565337                    	       22430976	15-DEC-2019 19:55:24	          16.07
2002565630                    	       22431286	16-DEC-2019 08:15:10	          16.67
2002551482                    	       22415560	04-DEC-2019 14:11:21	          36.36
2002566739                    	       22437211	17-DEC-2019 03:30:07	          17.98
2002567094                    	       22438309	17-DEC-2019 11:55:22	         217.73
2002566060                    	       22431836	16-DEC-2019 13:40:28	          20.03
2002565239                    	       22430878	15-DEC-2019 18:00:22	          20.33
2002565088                    	       22430727	15-DEC-2019 14:55:16	          48.75
2002555753                    	       22420169	07-DEC-2019 16:50:16	          23.97
2002560918                    	       22426025	11-DEC-2019 11:05:45	          15.17
2002566943                    	       22437463	17-DEC-2019 10:10:46	          11.66
2002566636                    	       22434214	17-DEC-2019 00:00:11	            -.7
2002565356                    	       22430995	15-DEC-2019 20:15:33	          19.32
2002567051                    	       22438256	17-DEC-2019 11:35:14	          43.98
2002565369                    	       22431008	15-DEC-2019 20:25:20	          44.38
2002565312                    	       22430951	15-DEC-2019 19:35:12	          18.87
2002566503                    	       22432355	16-DEC-2019 20:40:18	          35.97
2002566071                    	       22431849	16-DEC-2019 13:50:17	         111.28
2002561802                    	       22427035	12-DEC-2019 07:42:45	          53.51
2002566444                    	       22432296	16-DEC-2019 19:35:17	          21.19
2002556798                    	       22421214	08-DEC-2019 13:30:12	          17.09
2002559546                    	       22424282	10-DEC-2019 09:23:29	          64.18
2002567049                    	       22438254	17-DEC-2019 11:35:10	          22.72
2002563390                    	       22428943	13-DEC-2019 13:25:13	           8.91
2002565994                    	       22431753	16-DEC-2019 12:55:07	         125.81
2002566238                    	       22432064	16-DEC-2019 16:05:11	          23.31
2002565999                    	       22431758	16-DEC-2019 12:55:11	          74.89
2002566620                    	       22432472	16-DEC-2019 22:16:17	          35.66
2002566602                    	       22432454	16-DEC-2019 21:55:13	          -38.2
2002566376                    	       22432228	16-DEC-2019 18:15:28	          16.38
2002566607                    	       22432459	16-DEC-2019 22:05:30	          97.74
2002565351                    	       22430990	15-DEC-2019 20:15:29	          51.54
2002565573                    	       22431212	16-DEC-2019 06:40:08	         144.77
2002564971                    	       22430610	15-DEC-2019 12:20:24	           55.5
2002562082                    	       22427383	12-DEC-2019 11:50:16	           14.8
2002566348                    	       22432197	16-DEC-2019 17:40:16	          39.66
2002566581                    	       22432433	16-DEC-2019 21:24:20	          15.14
2002566694                    	       22434272	17-DEC-2019 01:00:10	          11.66
2002565670                    	       22431338	16-DEC-2019 08:55:25	          27.65
2002562191                    	       22427535	12-DEC-2019 13:30:14	          30.08
2002543703                    	       22407075	29-NOV-2019 19:20:10	          18.41
2002567423                    	       22438718	17-DEC-2019 16:45:16	             60
2002566852                    	       22437337	17-DEC-2019 08:38:31	         -47.59
2002563588                    	       22429205	13-DEC-2019 15:50:15	          19.65
2002567055                    	       22438260	17-DEC-2019 11:35:17	         317.99
2002566533                    	       22432385	16-DEC-2019 21:02:29	          18.02
2002566063                    	       22431841	16-DEC-2019 13:50:08	          17.15
2002566961                    	       22437481	17-DEC-2019 10:20:31	            5.3
2002566101                    	       22431883	16-DEC-2019 14:01:04	          45.31
2002564200                    	       22429839	14-DEC-2019 11:35:13	          17.11
2002564929                    	       22430568	15-DEC-2019 10:50:49	           37.8
2002566000                    	       22431759	16-DEC-2019 12:55:12	          28.61
2002565389                    	       22431028	15-DEC-2019 20:35:24	          33.08
2002565368                    	       22431007	15-DEC-2019 20:15:49	          18.22
2002565374                    	       22431013	15-DEC-2019 20:25:26	          19.25
2002564678                    	       22430317	14-DEC-2019 21:50:12	          21.19
2002566286                    	       22432126	16-DEC-2019 16:35:15	         117.13
2002566783                    	       22437255	17-DEC-2019 06:50:07	          20.13
2002566530                    	       22432382	16-DEC-2019 21:02:08	          12.63
2002542922                    	       22406294	29-NOV-2019 11:55:19	          19.25
2002565186                    	       22430825	15-DEC-2019 16:50:15	          23.74
2002566684                    	       22434262	17-DEC-2019 00:30:12	          28.83
2002566737                    	       22437209	17-DEC-2019 03:10:14	           12.5
2002565332                    	       22430971	15-DEC-2019 19:45:22	          64.68
2002537821                    	       22400394	23-NOV-2019 10:25:13	          18.87
2002566778                    	       22437250	17-DEC-2019 06:30:19	          36.36
2002564047                    	       22429686	14-DEC-2019 08:45:16	           3.41
2002566893                    	       22437388	17-DEC-2019 09:10:37	          57.33
2002566764                    	       22437236	17-DEC-2019 06:10:12	          42.77
2002565343                    	       22430982	15-DEC-2019 20:05:27	          39.29
2002565935                    	       22431682	16-DEC-2019 12:05:21	           9.74
2002566379                    	       22432231	16-DEC-2019 18:25:12	           62.7
2002565124                    	       22430763	15-DEC-2019 15:40:26	          18.48
2002565449                    	       22431088	15-DEC-2019 21:45:17	          19.65
2002566426                    	       22432278	16-DEC-2019 19:15:13	          87.71
2002566290                    	       22432130	16-DEC-2019 16:35:21	          25.96
2002563959                    	       22429597	14-DEC-2019 05:50:15	           6.33
2002567052                    	       22438257	17-DEC-2019 11:35:15	             20
2002563739                    	       22429377	13-DEC-2019 18:30:23	          11.77
2002566546                    	       22432398	16-DEC-2019 21:04:36	          64.34
2002566257                    	       22432085	16-DEC-2019 16:15:16	          25.61
2002565090                    	       22430729	15-DEC-2019 14:55:21	          90.96
2002565741                    	       22431437	16-DEC-2019 09:50:11	          19.32
2002562551                    	       22427974	12-DEC-2019 18:55:16	          29.52
2002566816                    	       22437292	17-DEC-2019 07:55:16	          28.24
2002566084                    	       22431866	16-DEC-2019 14:00:22	         171.51
2002556913                    	       22421329	08-DEC-2019 14:45:34	           9.99
2002566358                    	       22432209	16-DEC-2019 17:50:22	          44.51
2002565804                    	       22431515	16-DEC-2019 10:40:13	          22.07
2002565925                    	       22431672	16-DEC-2019 12:05:09	          38.72
2002564016                    	       22429654	14-DEC-2019 08:00:18	          19.11
2002567281                    	       22438527	17-DEC-2019 14:10:06	         -36.86
2002565114                    	       22430753	15-DEC-2019 15:30:12	          19.49
2002560173                    	       22425055	10-DEC-2019 16:35:23	           -.71
2002565020                    	       22430659	15-DEC-2019 13:20:22	          20.38
2002566359                    	       22432210	16-DEC-2019 17:50:23	          48.43
2002549917                    	       22413726	03-DEC-2019 13:23:42	           3.06
2002563852                    	       22429490	13-DEC-2019 21:15:08	          63.15
2002565269                    	       22430908	15-DEC-2019 18:35:19	          69.93
2002566240                    	       22432066	16-DEC-2019 16:05:15	          42.38
2002564973                    	       22430612	15-DEC-2019 12:20:42	          34.21
2002566966                    	       22437486	17-DEC-2019 10:20:40	          71.99
2002565127                    	       22430766	15-DEC-2019 15:40:32	          19.87
2002565986                    	       22431741	16-DEC-2019 12:45:18	          20.03
2002564884                    	       22430523	15-DEC-2019 09:55:09	           8.37
2002565547                    	       22431186	16-DEC-2019 03:45:08	           16.1
2002566273                    	       22432108	16-DEC-2019 16:25:19	          20.47
2002563809                    	       22429447	13-DEC-2019 20:15:27	             22
2002565475                    	       22431114	15-DEC-2019 22:15:52	           67.4
2002565617                    	       22431270	16-DEC-2019 08:05:11	          12.71
2002565525                    	       22431164	16-DEC-2019 00:05:08	         104.99
2002563965                    	       22429603	14-DEC-2019 06:00:46	         113.51
2002565469                    	       22431108	15-DEC-2019 22:05:33	         126.39
2002566013                    	       22431776	16-DEC-2019 13:05:30	          89.76
2002565863                    	       22431590	16-DEC-2019 11:25:25	          29.15
2002565606                    	       22431253	16-DEC-2019 07:55:10	          44.01
2002565899                    	       22431634	16-DEC-2019 11:45:14	          90.64
2002566218                    	       22432034	16-DEC-2019 15:40:13	          24.88
2002567109                    	       22438326	17-DEC-2019 12:05:15	          30.94
2002565818                    	       22431522	16-DEC-2019 10:51:49	          80.23
2002566136                    	       22431930	16-DEC-2019 14:30:11	          31.96
2002563299                    	       22428826	13-DEC-2019 12:25:15	         123.11
2002562214                    	       22427543	12-DEC-2019 13:41:30	          79.59
2002562337                    	       22427724	12-DEC-2019 15:05:17	          18.98
2002565770                    	       22431473	16-DEC-2019 10:10:20	          43.76
2002567311                    	       22438568	17-DEC-2019 14:35:28	            -25
2002561300                    	       22426497	11-DEC-2019 15:54:23	          89.73
2002536513                    	       22396228	21-NOV-2019 15:35:36	          33.59
2002566155                    	       22431956	16-DEC-2019 14:40:13	          23.77
2002565857                    	       22431583	16-DEC-2019 11:25:18	          19.07
2002567014                    	       22438210	17-DEC-2019 11:05:26	          43.46
2002562227                    	       22427583	12-DEC-2019 13:55:16	         108.74
2002566037                    	       22431805	16-DEC-2019 13:25:24	          21.39
2002565027                    	       22430666	15-DEC-2019 13:30:24	          59.75
2002566065                    	       22431843	16-DEC-2019 13:50:11	           21.7
2002565155                    	       22430794	15-DEC-2019 16:20:15	           9.61
2002566114                    	       22431902	16-DEC-2019 14:10:11	          22.95
2002565876                    	       22431607	16-DEC-2019 11:35:18	           23.8
2002553425                    	       22417722	05-DEC-2019 20:00:24	          21.19
2002566138                    	       22431932	16-DEC-2019 14:30:14	          33.05
2002565031                    	       22430670	15-DEC-2019 13:40:08	          15.12
2002566563                    	       22432415	16-DEC-2019 21:21:23	          66.77
2002566145                    	       22431939	16-DEC-2019 14:30:23	          45.99
2002565869                    	       22431597	16-DEC-2019 11:29:14	         138.16
2002565926                    	       22431673	16-DEC-2019 12:05:12	           1.95
2002565001                    	       22430640	15-DEC-2019 13:00:16	          17.63
2002563824                    	       22429462	13-DEC-2019 20:45:15	          20.88
2002565746                    	       22431447	16-DEC-2019 09:55:21	          64.45
2002548387                    	       22412024	02-DEC-2019 18:46:42	          19.71
2002564756                    	       22430395	15-DEC-2019 01:15:09	          14.93
2002559441                    	       22424132	10-DEC-2019 08:04:05	          63.26
2002565212                    	       22430851	15-DEC-2019 17:30:15	          55.85
2002564039                    	       22429678	14-DEC-2019 08:45:09	          33.17
2002566435                    	       22432287	16-DEC-2019 19:25:13	          45.12
2002565757                    	       22431459	16-DEC-2019 10:00:30	           17.6
2002525551                    	       22336030	10-NOV-2019 15:05:26	           -.24
2002564968                    	       22430607	15-DEC-2019 12:10:28	          98.09
2002565760                    	       22431462	16-DEC-2019 10:00:35	          49.99
2002566677                    	       22434255	17-DEC-2019 00:11:19	          23.91
2002566484                    	       22432336	16-DEC-2019 20:15:12	           4.66
2002563009                    	       22428458	13-DEC-2019 09:10:13	           6.94
2002564521                    	       22430160	14-DEC-2019 18:10:13	          -24.3
2002567221                    	       22438459	17-DEC-2019 13:20:39	           2.99
2002564969                    	       22430608	15-DEC-2019 12:10:36	          57.74
2002566980                    	       22437504	17-DEC-2019 10:30:31	          33.13
2002565761                    	       22431463	16-DEC-2019 10:03:50	          28.88
2002566506                    	       22432358	16-DEC-2019 20:40:21	          26.21
2002565412                    	       22431051	15-DEC-2019 20:55:21	          36.36
2002565895                    	       22431630	16-DEC-2019 11:45:11	          16.78
2002565773                    	       22431477	16-DEC-2019 10:20:14	          46.83
2002565034                    	       22430673	15-DEC-2019 13:40:12	          28.24
2002566062                    	       22431839	16-DEC-2019 13:46:39	          20.13
2002565429                    	       22431068	15-DEC-2019 21:15:15	          23.78
2002566995                    	       22437520	17-DEC-2019 10:42:06	            120
2002566354                    	       22432203	16-DEC-2019 17:45:05	         239.16
2002565131                    	       22430770	15-DEC-2019 15:50:10	          20.49
2002565179                    	       22430818	15-DEC-2019 16:40:27	          69.47
2002566261                    	       22432089	16-DEC-2019 16:15:19	          94.79
2002566460                    	       22432312	16-DEC-2019 19:55:13	          46.21
2002541068                    	       22403991	27-NOV-2019 06:50:09	           8.58
2002565787                    	       22431497	16-DEC-2019 10:30:14	          17.11
2002567047                    	       22438252	17-DEC-2019 11:35:08	          88.59
2002565092                    	       22430731	15-DEC-2019 14:55:24	         180.97
2002564941                    	       22430580	15-DEC-2019 11:10:22	          58.17
2002566647                    	       22434225	17-DEC-2019 00:10:13	          20.32
2002565713                    	       22431401	16-DEC-2019 09:30:19	          37.49
2002561691                    	       22426924	11-DEC-2019 22:43:58	          18.83
2002538157                    	       22400731	23-NOV-2019 17:35:08	          20.11
2002566272                    	       22432107	16-DEC-2019 16:25:17	          17.99
2002565973                    	       22431727	16-DEC-2019 12:35:16	         274.97
2002565304                    	       22430943	15-DEC-2019 19:25:07	         117.85
2002567542                    	       22438847	17-DEC-2019 19:30:08	            -25
2002565190                    	       22430829	15-DEC-2019 17:00:09	          63.99
2002558408                    	       22422962	09-DEC-2019 12:30:24	          27.76
2002563957                    	       22429595	14-DEC-2019 05:40:17	          57.23
2002566747                    	       22437219	17-DEC-2019 05:10:11	          47.16
2002564956                    	       22430595	15-DEC-2019 11:35:31	          13.85
2002565224                    	       22430863	15-DEC-2019 17:40:25	          24.02
2002566352                    	       22432201	16-DEC-2019 17:40:20	            -15
2002566124                    	       22431913	16-DEC-2019 14:16:11	          29.14
2002565043                    	       22430682	15-DEC-2019 13:50:13	          28.88
2002565069                    	       22430708	15-DEC-2019 14:25:27	           57.9
2002566412                    	       22432264	16-DEC-2019 19:05:09	          29.49
2002562912                    	       22428336	13-DEC-2019 07:35:12	             75
2002566321                    	       22432166	16-DEC-2019 16:55:20	          12.74
2002565786                    	       22431496	16-DEC-2019 10:30:13	          48.75
2002565557                    	       22431196	16-DEC-2019 05:50:06	          13.61
2002563887                    	       22429525	13-DEC-2019 22:35:30	           5.97
2002567250                    	       22438492	17-DEC-2019 13:47:10	           1504
2002566237                    	       22432062	16-DEC-2019 16:04:26	          99.46
2002565957                    	       22431706	16-DEC-2019 12:15:34	          97.35
2002561956                    	       22427232	12-DEC-2019 10:01:04	          84.51
2002562923                    	       22428348	13-DEC-2019 07:45:21	          21.59
2002565716                    	       22431404	16-DEC-2019 09:30:22	          18.39
2002565004                    	       22430643	15-DEC-2019 13:00:37	          32.82
2002566516                    	       22432368	16-DEC-2019 21:00:19	           55.8
2002566555                    	       22432407	16-DEC-2019 21:20:53	          55.76
2002565139                    	       22430778	15-DEC-2019 16:00:11	          18.99
2002566547                    	       22432399	16-DEC-2019 21:20:09	           1.59
2002565649                    	       22431313	16-DEC-2019 08:43:48	          19.22
2002566289                    	       22432129	16-DEC-2019 16:35:19	          28.49
2002564543                    	       22430182	14-DEC-2019 18:40:09	          26.39
2002566604                    	       22432456	16-DEC-2019 21:55:21	           93.5
2002565513                    	       22431152	15-DEC-2019 23:35:14	          40.44
2002565302                    	       22430941	15-DEC-2019 19:15:15	          58.02
2002565626                    	       22431282	16-DEC-2019 08:15:06	             26
2002550976                    	       22414948	04-DEC-2019 09:55:09	          106.8
2002565176                    	       22430815	15-DEC-2019 16:40:22	          73.73
2002565458                    	       22431097	15-DEC-2019 21:55:20	          28.68
2002565904                    	       22431644	16-DEC-2019 11:54:44	          93.87
2002563950                    	       22429588	14-DEC-2019 05:06:06	         285.81
2002566846                    	       22437331	17-DEC-2019 08:30:20	          71.11
2002566572                    	       22432424	16-DEC-2019 21:22:59	         148.75
2002566663                    	       22434241	17-DEC-2019 00:10:40	          54.03
2002564580                    	       22430219	14-DEC-2019 19:30:12	          53.95
2002558659                    	       22423240	09-DEC-2019 14:31:14	         -26.47
2002562869                    	       22428292	13-DEC-2019 06:20:12	          17.11
2002565220                    	       22430859	15-DEC-2019 17:40:17	          18.01
2002566085                    	       22431867	16-DEC-2019 14:00:24	          57.16
2002562784                    	       22428207	13-DEC-2019 01:11:15	          16.21
2002564986                    	       22430625	15-DEC-2019 12:36:03	          46.21
2002566445                    	       22432297	16-DEC-2019 19:35:17	          62.99
2002565671                    	       22431339	16-DEC-2019 08:55:26	         153.09
2002565184                    	       22430823	15-DEC-2019 16:50:13	          85.56
2002566437                    	       22432289	16-DEC-2019 19:25:14	          21.19
2002566787                    	       22437259	17-DEC-2019 06:50:11	          32.07
2002565665                    	       22431333	16-DEC-2019 08:55:19	          21.84
2002566161                    	       22431963	16-DEC-2019 14:40:18	          83.45
2002565750                    	       22431452	16-DEC-2019 10:00:07	          18.99
2002565976                    	       22431730	16-DEC-2019 12:35:21	          13.36
2002565430                    	       22431069	15-DEC-2019 21:15:16	          14.01
2002565892                    	       22431627	16-DEC-2019 11:45:07	         118.98
2002564661                    	       22430300	14-DEC-2019 21:10:12	          18.63
2002561413                    	       22426641	11-DEC-2019 17:15:33	           1.49
2002561797                    	       22427030	12-DEC-2019 07:40:31	         -10.72
2002566700                    	       22436208	17-DEC-2019 01:45:29	          81.93
2002565710                    	       22431398	16-DEC-2019 09:30:16	          51.98
2002564184                    	       22429823	14-DEC-2019 11:15:12	          19.59
2002565579                    	       22431219	16-DEC-2019 07:00:11	          40.87
2002567181                    	       22438415	17-DEC-2019 13:00:17	         -12.63
2002565810                    	       22431523	16-DEC-2019 10:50:10	          19.65
2002565467                    	       22431106	15-DEC-2019 22:05:28	           16.1
2002564724                    	       22430363	14-DEC-2019 23:15:21	          29.45
2002554557                    	       22418992	06-DEC-2019 16:26:58	           19.2
2002565503                    	       22431142	15-DEC-2019 23:15:08	          19.79
2002566307                    	       22432149	16-DEC-2019 16:45:33	           9.81
2002564988                    	       22430627	15-DEC-2019 12:36:13	          48.75
2002566616                    	       22432468	16-DEC-2019 22:15:42	          23.79
2002565439                    	       22431078	15-DEC-2019 21:25:16	          33.88
2002566994                    	       22437510	17-DEC-2019 10:40:54	          53.24
2002565826                    	       22431544	16-DEC-2019 11:00:18	          10.12
2002564621                    	       22430260	14-DEC-2019 20:30:08	          39.15
2002566975                    	       22437497	17-DEC-2019 10:30:22	          11.26
2002558348                    	       22422864	09-DEC-2019 11:45:44	           84.1
2002566459                    	       22432311	16-DEC-2019 19:55:12	          35.37
2002566670                    	       22434248	17-DEC-2019 00:10:54	          60.41
2002563595                    	       22429212	13-DEC-2019 15:56:45	         101.12
2002565737                    	       22431430	16-DEC-2019 09:48:47	            .36
2002566988                    	       22437514	17-DEC-2019 10:40:16	          48.98
2002531020                    	       22346181	15-NOV-2019 20:45:11	          -14.1
2002566045                    	       22431815	16-DEC-2019 13:29:47	          34.72
2002565788                    	       22431498	16-DEC-2019 10:30:14	          35.53
2002565686                    	       22431361	16-DEC-2019 09:10:14	         264.93
2002566498                    	       22432350	16-DEC-2019 20:40:13	           6.94
2002528240                    	       22342332	12-NOV-2019 20:55:16	           -.08
2002567990                    	       22439294	18-DEC-2019 07:20:11	           2.09
2002566990                    	       22437516	17-DEC-2019 10:40:19	          15.14
2002566608                    	       22432460	16-DEC-2019 22:05:50	           8.88
2002565473                    	       22431112	15-DEC-2019 22:05:54	           19.5
2002549260                    	       22412918	03-DEC-2019 07:50:14	           5.04
2002566828                    	       22437305	17-DEC-2019 08:06:24	          52.03
2002565408                    	       22431047	15-DEC-2019 20:55:16	          29.49
2002566328                    	       22432173	16-DEC-2019 17:05:24	          10.54
2002562681                    	       22428104	12-DEC-2019 21:30:12	          16.99
2002562295                    	       22427671	12-DEC-2019 14:35:08	          16.75
2002566673                    	       22434251	17-DEC-2019 00:11:01	          19.43
2002566465                    	       22432317	16-DEC-2019 20:05:12	           10.5
2002562320                    	       22427701	12-DEC-2019 14:50:13	          39.15
2002565560                    	       22431199	16-DEC-2019 05:50:08	          58.42
2002566649                    	       22434227	17-DEC-2019 00:10:20	          25.73
2002566402                    	       22432254	16-DEC-2019 18:45:30	            9.8
2002564836                    	       22430475	15-DEC-2019 08:30:42	          39.39
2002565129                    	       22430768	15-DEC-2019 15:40:35	          34.16
2002566246                    	       22432072	16-DEC-2019 16:05:24	          15.22
2002563370                    	       22428917	13-DEC-2019 13:15:13	          56.44
2002561345                    	       22426557	11-DEC-2019 16:20:08	          13.75
2002566035                    	       22431803	16-DEC-2019 13:25:20	          14.84
2002566657                    	       22434235	17-DEC-2019 00:10:32	          30.41
2002565663                    	       22431331	16-DEC-2019 08:55:15	          74.31
2002566755                    	       22437227	17-DEC-2019 05:50:10	          17.63
2002565075                    	       22430714	15-DEC-2019 14:35:30	          58.48
2002564053                    	       22429692	14-DEC-2019 08:55:11	         131.98
2002565137                    	       22430776	15-DEC-2019 15:50:22	          25.38
2002565296                    	       22430935	15-DEC-2019 19:15:08	          16.54
2002565669                    	       22431337	16-DEC-2019 08:55:24	          21.59
2002556072                    	       22420488	07-DEC-2019 21:30:13	          19.07
2002565962                    	       22431714	16-DEC-2019 12:25:10	          22.74
2002564247                    	       22429886	14-DEC-2019 12:25:24	         184.58
2002565400                    	       22431039	15-DEC-2019 20:45:23	          85.39
2002565727                    	       22431419	16-DEC-2019 09:40:14	          33.35
2002565567                    	       22431206	16-DEC-2019 06:30:08	          20.25
2002566185                    	       22431993	16-DEC-2019 15:10:12	          49.21
2002565980                    	       22431734	16-DEC-2019 12:38:28	          16.22
2002566409                    	       22432261	16-DEC-2019 18:55:15	          43.49
2002566188                    	       22431996	16-DEC-2019 15:10:16	          56.68
2002561399                    	       22426624	11-DEC-2019 16:59:07	          75.58
2002566658                    	       22434236	17-DEC-2019 00:10:33	          12.98
2002561096                    	       22426237	11-DEC-2019 13:10:13	          20.67
2002566267                    	       22432098	16-DEC-2019 16:20:27	          52.82
2002567059                    	       22438264	17-DEC-2019 11:35:22	           26.8
2002564203                    	       22429842	14-DEC-2019 11:45:10	          75.71
2002566476                    	       22432328	16-DEC-2019 20:05:44	          20.26
2002565785                    	       22431495	16-DEC-2019 10:30:12	          19.99
2002566626                    	       22432478	16-DEC-2019 22:26:13	          15.52
2002562268                    	       22427637	12-DEC-2019 14:15:25	          14.67
2002566508                    	       22432360	16-DEC-2019 20:50:08	           7.92
2002566375                    	       22432227	16-DEC-2019 18:15:25	          15.99
2002563728                    	       22429366	13-DEC-2019 18:06:22	         392.04
2002565619                    	       22431272	16-DEC-2019 08:05:14	          77.98
2002566092                    	       22431874	16-DEC-2019 14:00:33	          63.99
2002566337                    	       22432185	16-DEC-2019 17:15:20	         -15.42
2002565642                    	       22431304	16-DEC-2019 08:35:24	          44.96
2002566843                    	       22437327	17-DEC-2019 08:30:12	          60.84
2002566549                    	       22432401	16-DEC-2019 21:20:28	          36.47
2002565859                    	       22431586	16-DEC-2019 11:25:20	          37.44
2002566335                    	       22432183	16-DEC-2019 17:15:18	          31.86
2002566413                    	       22432265	16-DEC-2019 19:05:15	          60.75
2002554017                    	       22418364	06-DEC-2019 10:45:20	          -3.18
2002566247                    	       22432073	16-DEC-2019 16:05:26	          20.13
2002567450                    	       22438750	17-DEC-2019 17:15:17	             25
2002565035                    	       22430674	15-DEC-2019 13:40:14	          12.18
2002565479                    	       22431118	15-DEC-2019 22:25:54	          59.99
2002539942                    	       22402663	25-NOV-2019 21:50:11	          38.13
2002566589                    	       22432441	16-DEC-2019 21:45:49	          31.99
2002564100                    	       22429739	14-DEC-2019 09:45:09	             43
2002565066                    	       22430705	15-DEC-2019 14:25:20	          16.14
2002566431                    	       22432283	16-DEC-2019 19:25:09	          40.64
2002566691                    	       22434269	17-DEC-2019 00:50:09	          16.04
2002564029                    	       22429667	14-DEC-2019 08:30:00	          95.55
2002566230                    	       22432053	16-DEC-2019 15:55:11	          49.21
2002565251                    	       22430890	15-DEC-2019 18:10:16	          30.45
2002562209                    	       22427558	12-DEC-2019 13:40:20	            -.7
2002565140                    	       22430779	15-DEC-2019 16:00:12	           41.5
2002566575                    	       22432427	16-DEC-2019 21:23:22	          23.53
2002565354                    	       22430993	15-DEC-2019 20:15:31	          52.49
2002564943                    	       22430582	15-DEC-2019 11:10:28	          87.66
2002567323                    	       22438589	17-DEC-2019 14:50:24	          16.38
2002565736                    	       22431429	16-DEC-2019 09:48:07	          78.28
2002562182                    	       22427523	12-DEC-2019 13:20:19	          21.34
2002565273                    	       22430912	15-DEC-2019 18:35:27	          25.43
2002565955                    	       22431704	16-DEC-2019 12:15:32	        -632.82
2002565172                    	       22430811	15-DEC-2019 16:40:18	          30.63
2002565281                    	       22430920	15-DEC-2019 18:45:20	          22.62
2002566989                    	       22437515	17-DEC-2019 10:40:17	          68.18
2002566204                    	       22432016	16-DEC-2019 15:30:21	           5.69
2002566338                    	       22432186	16-DEC-2019 17:15:21	          79.22
2002567394                    	       22438679	17-DEC-2019 16:00:41	         -22.73
2002565391                    	       22431030	15-DEC-2019 20:35:29	         123.59
2002563752                    	       22429390	13-DEC-2019 18:50:20	          21.55
2002565112                    	       22430751	15-DEC-2019 15:15:43	          30.96
2002564194                    	       22429833	14-DEC-2019 11:25:16	          21.34
2002566467                    	       22432319	16-DEC-2019 20:05:25	          55.38
2002564887                    	       22430526	15-DEC-2019 09:55:26	          12.83
2002566797                    	       22437269	17-DEC-2019 07:25:16	            128
2002565413                    	       22431052	15-DEC-2019 20:55:22	          30.48
2002564643                    	       22430282	14-DEC-2019 20:50:14	          39.02
2002566689                    	       22434267	17-DEC-2019 00:50:07	          35.74
2002566585                    	       22432437	16-DEC-2019 21:45:09	          43.08
2002565767                    	       22431470	16-DEC-2019 10:10:17	          91.35
2002566250                    	       22432076	16-DEC-2019 16:05:31	         105.41
2002563371                    	       22428918	13-DEC-2019 13:15:14	          24.77
2002565325                    	       22430964	15-DEC-2019 19:45:13	          13.63
2002567045                    	       22438246	17-DEC-2019 11:27:34	          76.28
2002565862                    	       22431589	16-DEC-2019 11:25:25	          30.95
2002565097                    	       22430736	15-DEC-2019 15:05:22	          66.06
2002566494                    	       22432346	16-DEC-2019 20:40:10	          11.74
2002566364                    	       22432215	16-DEC-2019 17:59:39	          79.74
2002565543                    	       22431182	16-DEC-2019 01:35:11	          10.75
2002565493                    	       22431132	15-DEC-2019 23:05:15	          11.68
2002565159                    	       22430798	15-DEC-2019 16:20:20	          65.54
2002562106                    	       22427422	12-DEC-2019 12:38:46	         248.71
2002565174                    	       22430813	15-DEC-2019 16:40:20	          20.32
2002564277                    	       22429916	14-DEC-2019 13:15:11	          34.15
2002564915                    	       22430554	15-DEC-2019 10:35:20	          46.21
2002565447                    	       22431086	15-DEC-2019 21:35:19	          14.58
2002566012                    	       22431775	16-DEC-2019 13:05:28	          42.51
2002565125                    	       22430764	15-DEC-2019 15:40:27	          25.67
2002562206                    	       22427555	12-DEC-2019 13:40:16	          78.65
2002565878                    	       22431609	16-DEC-2019 11:35:20	           31.7
2002564628                    	       22430267	14-DEC-2019 20:30:13	          76.99
2002565608                    	       22431255	16-DEC-2019 07:55:12	           9.89
2002565306                    	       22430945	15-DEC-2019 19:25:08	          34.21
2002566205                    	       22432017	16-DEC-2019 15:30:23	          41.34
2002565906                    	       22431648	16-DEC-2019 11:55:08	         114.07
2002563893                    	       22429531	13-DEC-2019 22:45:08	          33.55
2002565014                    	       22430653	15-DEC-2019 13:20:09	          20.87
2002566026                    	       22431790	16-DEC-2019 13:15:18	          96.95
2002565101                    	       22430740	15-DEC-2019 15:05:33	          49.67
2002566458                    	       22432310	16-DEC-2019 19:55:11	          25.69
2002566748                    	       22437220	17-DEC-2019 05:20:07	          35.96
2002565382                    	       22431021	15-DEC-2019 20:35:17	          19.11
2002565914                    	       22431656	16-DEC-2019 11:55:19	           21.7
2002565141                    	       22430780	15-DEC-2019 16:00:14	          33.06
2002565688                    	       22431363	16-DEC-2019 09:10:16	          44.93
2002567039                    	       22438240	17-DEC-2019 11:25:20	            -25
2002528023                    	       22340240	12-NOV-2019 17:25:14	           6.38
2002551083                    	       22415080	04-DEC-2019 10:55:16	          104.2
2002550930                    	       22414886	04-DEC-2019 09:20:16	          -2.18
2002551073                    	       22415068	04-DEC-2019 10:45:33	         -10.59
2002550919                    	       22414872	04-DEC-2019 09:13:51	          51.35
2002543681                    	       22407053	29-NOV-2019 19:00:22	          21.16
2002543794                    	       22407166	29-NOV-2019 20:10:12	          19.54
2002543805                    	       22407177	29-NOV-2019 20:10:19	          21.39
2002543790                    	       22407162	29-NOV-2019 20:10:10	          35.38
2002543744                    	       22407116	29-NOV-2019 19:40:17	          20.83
2002543603                    	       22406975	29-NOV-2019 18:20:14	          32.61
2002550381                    	       22414303	03-DEC-2019 18:45:31	           10.9
2002550372                    	       22414294	03-DEC-2019 18:45:14	           2.99
2002550385                    	       22414307	03-DEC-2019 18:45:35	           4.99
2002550191                    	       22414072	03-DEC-2019 16:00:34	           13.1
2002544263                    	       22407635	30-NOV-2019 08:00:19	           5.18
2002544261                    	       22407633	30-NOV-2019 08:00:17	           -7.6
2002544221                    	       22407593	30-NOV-2019 07:20:13	          18.88
2002544096                    	       22407468	29-NOV-2019 23:35:10	          21.34
2002544101                    	       22407473	29-NOV-2019 23:35:15	          18.43
2002549660                    	       22413422	03-DEC-2019 11:15:25	           5.22
2002534899                    	       22362433	20-NOV-2019 09:05:43	          -9.72
2002534905                    	       22362446	20-NOV-2019 09:15:16	         -20.97
2002546808                    	       22410191	02-DEC-2019 08:30:18	           2.62
2002546773                    	       22410148	02-DEC-2019 08:10:22	           -.34
2002555024                    	       22419440	07-DEC-2019 00:20:16	           19.2
2002555054                    	       22419470	07-DEC-2019 03:40:25	          17.59
2002522652                    	       22332863	06-NOV-2019 14:25:25	         -17.97
2002522774                    	       22333004	06-NOV-2019 16:35:08	           -.01
2002529906                    	       22344942	14-NOV-2019 15:05:22	         -50.81
2002530010                    	       22345074	14-NOV-2019 16:37:51	           2.12
2002556574                    	       22420990	08-DEC-2019 10:16:10	           2.42
2002536251                    	       22392297	21-NOV-2019 11:20:18	           8.55
2002552774                    	       22416992	05-DEC-2019 12:50:15	          40.64
2002552685                    	       22416885	05-DEC-2019 12:10:08	          19.19
2002519207                    	       22324923	02-NOV-2019 20:50:12	           8.19
2002525364                    	       22335847	10-NOV-2019 10:10:29	          21.59
2002531761                    	       22346925	16-NOV-2019 22:16:44	         -23.42
2002547002                    	       22410389	02-DEC-2019 09:35:38	            .24
2002547071                    	       22410496	02-DEC-2019 10:05:41	          20.87
2002551584                    	       22415691	04-DEC-2019 15:25:20	            600
2002523674                    	       22334038	07-NOV-2019 18:05:05	          22.32
2002527195                    	       22338658	12-NOV-2019 07:51:42	         932.15
2002527083                    	       22338553	11-NOV-2019 22:35:16	         -26.48
2002527068                    	       22338538	11-NOV-2019 22:11:32	           4.38
2002537039                    	       22398640	22-NOV-2019 10:15:11	          21.19
2002537101                    	       22398721	22-NOV-2019 11:20:06	          21.74
2002530548                    	       22345673	15-NOV-2019 12:10:12	            -25
2002531155                    	       22346316	16-NOV-2019 07:45:11	          37.55
2002520410                    	       22326505	04-NOV-2019 12:27:29	            .24
2002551498                    	       22415594	04-DEC-2019 14:30:15	          28.78
2002551507                    	       22415603	04-DEC-2019 14:30:31	            -25
2002540028                    	       22402749	26-NOV-2019 02:55:10	          11.19
2002561396                    	       22426618	11-DEC-2019 16:54:25	          80.05
2002543503                    	       22406875	29-NOV-2019 17:10:14	          39.65
2002548256                    	       22411888	02-DEC-2019 17:40:17	          21.33
2002543748                    	       22407120	29-NOV-2019 19:50:09	          20.21
2002549222                    	       22412868	03-DEC-2019 07:10:07	           20.1
2002562569                    	       22427992	12-DEC-2019 19:15:15	          16.87
2002546868                    	       22410263	02-DEC-2019 08:50:22	           21.7
2002552289                    	       22416440	05-DEC-2019 09:25:10	          -1.74
2002523079                    	       22333323	07-NOV-2019 08:15:09	          35.18
2002567785                    	       22439087	17-DEC-2019 22:33:50	          20.81
2002527041                    	       22338511	11-NOV-2019 21:40:17	           2.13
2002553381                    	       22417678	05-DEC-2019 19:25:12	          10.91
2002541247                    	       22404220	27-NOV-2019 10:55:30	          -21.1
2002535374                    	       22373290	20-NOV-2019 15:15:11	          16.96
2002542097                    	       22405469	28-NOV-2019 15:55:09	          21.39
2002562308                    	       22427689	12-DEC-2019 14:45:09	          57.15
2002562421                    	       22427828	12-DEC-2019 16:20:19	           56.3
2002562509                    	       22427932	12-DEC-2019 18:15:16	          84.79
2002543004                    	       22406376	29-NOV-2019 12:35:19	         125.25
2002540430                    	       22403248	26-NOV-2019 12:50:07	           5.16
2002540282                    	       22403066	26-NOV-2019 10:20:16	          70.06
2002527098                    	       22338568	11-NOV-2019 23:11:05	         141.05
2002530914                    	       22346075	15-NOV-2019 17:50:12	          72.74
2002565651                    	       22431317	16-DEC-2019 08:45:18	          24.09
2002565570                    	       22431209	16-DEC-2019 06:30:10	          21.44
2002520043                    	       22325759	04-NOV-2019 05:45:12	           4.16
2002562140                    	       22427466	12-DEC-2019 12:53:42	         108.59
2002551658                    	       22415793	04-DEC-2019 16:30:17	          21.84
2002538837                    	       22401411	24-NOV-2019 19:00:15	          38.11
2002519198                    	       22324914	02-NOV-2019 20:40:12	          19.99
2002553132                    	       22417410	05-DEC-2019 16:00:59	          17.99
2002564604                    	       22430243	14-DEC-2019 20:10:09	          162.3
2002537826                    	       22400399	23-NOV-2019 10:35:11	         -23.84
2002564231                    	       22429870	14-DEC-2019 12:15:17	           13.1
2002557556                    	       22421972	08-DEC-2019 21:30:28	          68.48
2002547794                    	       22411334	02-DEC-2019 14:45:23	          54.27
2002534975                    	       22363213	20-NOV-2019 09:59:26	            .49
2002536029                    	       22388390	21-NOV-2019 08:10:10	            5.1
2002563761                    	       22429399	13-DEC-2019 19:00:24	             20
2002563815                    	       22429453	13-DEC-2019 20:25:11	          34.13
2002564175                    	       22429814	14-DEC-2019 11:05:24	          17.49
2002562672                    	       22428095	12-DEC-2019 21:20:11	           18.3
2002544842                    	       22408214	30-NOV-2019 16:00:15	          19.53
2002559556                    	       22424293	10-DEC-2019 09:27:49	          70.72
2002566873                    	       22437365	17-DEC-2019 08:56:10	          62.86
2002549763                    	       22413545	03-DEC-2019 12:06:06	          23.53
2002561297                    	       22426493	11-DEC-2019 15:50:24	          21.44
2002561839                    	       22427078	12-DEC-2019 08:20:14	           16.1
2002535421                    	       22374236	20-NOV-2019 16:01:10	            205
2002558874                    	       22423550	09-DEC-2019 16:43:32	          17.11
2002548962                    	       22412608	02-DEC-2019 22:22:22	          20.87
2002526723                    	       22337362	11-NOV-2019 16:20:14	         146.59
2002536139                    	       22390211	21-NOV-2019 09:55:15	          -9.99
2002531559                    	       22346723	16-NOV-2019 16:50:13	          -2.88
2002560045                    	       22424890	10-DEC-2019 15:00:33	           -.01
2002557285                    	       22421701	08-DEC-2019 19:00:26	          11.21
2002538866                    	       22401440	24-NOV-2019 19:30:21	           4.57
2002530874                    	       22346035	15-NOV-2019 16:55:13	          -2.33
2002539721                    	       22402432	25-NOV-2019 17:50:18	          20.51
2002541134                    	       22404075	27-NOV-2019 08:44:13	           36.1
2002543372                    	       22406744	29-NOV-2019 16:00:28	          40.83
2002561008                    	       22426132	11-DEC-2019 12:20:11	          21.19
2002567329                    	       22438596	17-DEC-2019 14:59:17	            -25
2002560171                    	       22425050	10-DEC-2019 16:32:38	          21.39
2002546252                    	       22409613	01-DEC-2019 19:35:16	          69.15
2002541714                    	       22404770	27-NOV-2019 20:55:55	          17.34
2002528749                    	       22343571	13-NOV-2019 11:45:11	          29.55
2002545389                    	       22408761	01-DEC-2019 00:35:07	            .01
2002529719                    	       22344712	14-NOV-2019 12:35:08	           -1.5
2002560666                    	       22425699	11-DEC-2019 08:18:00	            1.3
2002544979                    	       22408351	30-NOV-2019 18:00:06	          21.39
2002556541                    	       22420957	08-DEC-2019 09:50:48	           8.69
2002555540                    	       22419956	07-DEC-2019 13:05:17	          21.62
2002557799                    	       22422215	09-DEC-2019 00:40:05	            -.1
2002560344                    	       22425366	10-DEC-2019 19:20:14	          15.99
2002558477                    	       22423031	09-DEC-2019 13:00:24	          21.69
2002528157                    	       22342249	12-NOV-2019 19:20:12	           5.29
2002548411                    	       22412049	02-DEC-2019 18:56:27	           4.99
2002541679                    	       22404735	27-NOV-2019 20:10:13	        -176.94
2002534508                    	       22361243	19-NOV-2019 18:05:24	           2.99
2002540576                    	       22403434	26-NOV-2019 14:30:14	          21.64
2002563022                    	       22428473	13-DEC-2019 09:20:10	          21.44
2002563025                    	       22428476	13-DEC-2019 09:20:13	          23.31
2002560284                    	       22425306	10-DEC-2019 18:20:13	          19.07
2002523611                    	       22333971	07-NOV-2019 16:30:14	          10.64
2002541286                    	       22404275	27-NOV-2019 11:35:14	          19.68
2002563103                    	       22428570	13-DEC-2019 10:20:14	          13.57
2002563102                    	       22428569	13-DEC-2019 10:20:13	          15.49
2002544581                    	       22407953	30-NOV-2019 12:30:19	           42.8
2002555892                    	       22420308	07-DEC-2019 19:20:06	          57.63
2002542876                    	       22406248	29-NOV-2019 11:25:18	          18.47
2002540400                    	       22403204	26-NOV-2019 12:10:16	          57.25
2002554870                    	       22419286	06-DEC-2019 21:05:30	          10.69
2002551882                    	       22416030	04-DEC-2019 20:01:51	          10.52
2002536586                    	       22397263	21-NOV-2019 16:21:04	          21.64
2002564878                    	       22430517	15-DEC-2019 09:45:39	          56.16
2002567196                    	       22438432	17-DEC-2019 13:10:08	         199.99
2002556418                    	       22420834	08-DEC-2019 08:26:17	          54.05
2002531610                    	       22346774	16-NOV-2019 18:00:10	          19.07
2002554205                    	       22418590	06-DEC-2019 12:55:14	          18.82
2002542628                    	       22406000	29-NOV-2019 09:35:15	           40.5
2002539591                    	       22402273	25-NOV-2019 15:15:12	           20.4
2002552997                    	       22417252	05-DEC-2019 14:35:09	           9.89
2002557518                    	       22421934	08-DEC-2019 21:20:12	         -10.25
2002561971                    	       22427251	12-DEC-2019 10:05:26	          11.89
2002518812                    	       22324539	02-NOV-2019 10:30:11	           5.01
2002535582                    	       22379224	20-NOV-2019 18:05:44	         -32.31
2002534551                    	       22361287	19-NOV-2019 19:05:14	           3.24
2002547853                    	       22411402	02-DEC-2019 15:06:14	         -65.01
2002554800                    	       22419216	06-DEC-2019 20:06:36	          21.85
2002541165                    	       22404116	27-NOV-2019 09:05:29	           -.12
2002547743                    	       22411271	02-DEC-2019 14:25:26	          21.98
2002550581                    	       22414503	03-DEC-2019 21:45:26	          74.16
2002530027                    	       22345092	14-NOV-2019 16:40:31	          11.96
2002543108                    	       22406480	29-NOV-2019 13:40:07	          21.39
2002532015                    	       22347179	17-NOV-2019 13:25:18	          21.35
2002534594                    	       22361330	19-NOV-2019 20:00:12	           30.2
2002523068                    	       22333310	07-NOV-2019 07:53:35	          10.74
2002542940                    	       22406312	29-NOV-2019 12:05:18	         -14.93
2002561764                    	       22426997	12-DEC-2019 06:25:11	          17.37
2002521921                    	       22329372	05-NOV-2019 18:10:27	           2.13
2002522396                    	       22332548	06-NOV-2019 10:44:34	          49.68
2002536802                    	       22398377	21-NOV-2019 21:25:11	          20.99
2002536931                    	       22398508	22-NOV-2019 07:45:12	          40.64
2002536945                    	       22398528	22-NOV-2019 08:20:17	          21.19
2002550853                    	       22414789	04-DEC-2019 08:30:21	         820.85
2002550842                    	       22414775	04-DEC-2019 08:20:20	           -.04
2002523822                    	       22334186	07-NOV-2019 22:00:26	           -.84
2002526506                    	       22337101	11-NOV-2019 13:05:24	          28.95
2002532908                    	       22348113	18-NOV-2019 11:30:47	            .39
2002532852                    	       22348053	18-NOV-2019 10:50:18	          33.43
2002527649                    	       22339184	12-NOV-2019 13:05:09	          -5.34
2002527716                    	       22339269	12-NOV-2019 13:50:11	          -4.82
2002520543                    	       22326648	04-NOV-2019 14:06:01	         -31.79
2002528800                    	       22343629	13-NOV-2019 12:30:19	         127.52

2547 rows selected.

Elapsed: 00:00:42.99
apps@DEV
SQL> apps@DEV
SQL> print
SP2-0568: No bind variables declared.
apps@DEV
SQL> 
apps@DEV
SQL> 

apps@DEV
SQL> apps@DEV
SQL> 


apps@DEV
SQL> apps@DEV
SQL> apps@DEV
SQL> REM START OF SECONDARY TEST RUN:
apps@DEV
SQL> 
apps@DEV
SQL> 
apps@DEV
SQL> host dir test-harness
 Volume in drive C has no label.
 Volume Serial Number is 2A42-EC8D

 Directory of c:\Users\rstewar\Documents\OF-3392\test-harness

03/05/2020  03:59 PM    <DIR>          .
03/05/2020  03:59 PM    <DIR>          ..
02/21/2020  02:24 PM               133 #junk.txt#
02/21/2020  02:22 PM                34 .#junk.txt
02/25/2020  12:29 PM             6,097 autono_stmt_gen_test.sql
02/25/2020  12:17 PM             5,794 autono_stmt_gen_test.sql~
02/21/2020  03:34 PM             1,898 autono_stmt_gen_testing.sql~
02/24/2020  12:29 PM             3,855 autono_stmt_get_test.sql~
02/21/2020  02:42 PM             1,016 auton_stmt_gen_testing.sql~
02/21/2020  11:55 AM               187 con-stmt-gen-tables-drop.sql
02/25/2020  11:13 AM             1,110 con-stmt-gen-testing.sql
02/21/2020  02:23 PM             1,211 con-stmt-gen-testing.sql~
03/05/2020  03:46 PM            10,718 customer-querying.sql
02/21/2020  05:12 PM             2,675 customer-querying.sql~
02/27/2020  03:05 PM             6,753 ebs-log-new-code-test-20200227.txt
03/05/2020  01:59 PM             6,678 ebs-log-new-code-test-20200305.txt
02/27/2020  02:52 PM             6,678 ebs-log-orig-code-test-20200227.txt
02/27/2020  03:05 PM               810 ebs-output-new-code-test-20200227.txt
03/05/2020  01:58 PM               811 ebs-output-new-code-test-20200305.txt
02/27/2020  02:53 PM               811 ebs-output-orig-code-test-20200227.txt
03/05/2020  03:59 PM           104,359 lwx_ar_query.sql
02/27/2020  02:30 PM         2,197,283 sql-transcript-OF-3392-and-3393-dev-testing-transcript.sql
02/27/2020  03:11 PM            93,994 transcript-test-run-20200227.sql
03/05/2020  02:26 PM           105,112 transcript-test-run-20200305.sql
03/05/2020  12:27 PM               547 variable-settings.sql
03/05/2020  12:27 PM               488 variable-settings.sql~
02/27/2020  10:43 AM             1,474 v_ar_stmt_info.sql
02/21/2020  01:12 PM               846 v_ar_stmt_info.sql~
              26 File(s)      2,561,372 bytes
               2 Dir(s)  126,737,932,288 bytes free

apps@DEV
SQL> @test-harness\variable-settings 2002567196
old   2:   :p_customer_nbr := &1; -- carried in from command line!
new   2:   :p_customer_nbr := 2002567196; -- carried in from command line!

PL/SQL procedure successfully completed.

Elapsed: 00:00:09.08
apps@DEV
SQL> print

 P_CUSTOMER_NBR
---------------
     2002567196


    CUSTOMER_ID
---------------
       22438432


STATEMENT_CYCLE_NME
--------------------------------------------------------------------------------------------------------------------------------
IND

apps@DEV
SQL> select psa.trx_number,
       psa.due_date,
       psa.class,
       psa.amount_due_original,
       psa.amount_due_remaining
from   ar.ar_payment_schedules_all   psa
where  psa.customer_id = :p_customer_id -- 22430178
and    psa.status = 'OP';

SP2-0552: Bind variable "P_CUSTOMER_ID" not declared.
Elapsed: 00:00:00.06
apps@DEV
SQL> select psa.trx_number,
       psa.due_date,
       psa.class,
       psa.amount_due_original,
       psa.amount_due_remaining
from   ar.ar_payment_schedules_all   psa
where  psa.customer_id = :customer_id -- 22430178
and    psa.status = 'OP';


TRX_NUMBER                    	DUE_DATE            	CLASS               	AMOUNT_DUE_ORIGINAL	AMOUNT_DUE_REMAINING
------------------------------	--------------------	--------------------	-------------------	--------------------
28619289                      	04-FEB-2020 00:00:00	INV                 	             199.99	              199.99

Elapsed: 00:00:00.12
apps@DEV
SQL> print

 P_CUSTOMER_NBR
---------------
     2002567196


    CUSTOMER_ID
---------------
       22438432


STATEMENT_CYCLE_NME
--------------------------------------------------------------------------------------------------------------------------------
IND

apps@DEV
SQL> select * from lwx_ar_stmt_headers where send_to_cust_nbr = :p_customer_nbr
  2  ;

no rows selected

Elapsed: 00:00:00.49
apps@DEV
SQL> REM VERIFIED THAT THERE'S NO STATEMENT FOR THIS CUSTOMER YET!
apps@DEV
SQL> REM NEED TO REINSTALL THE ORIGINAL PACKAGE AND RUN A STATEMENT, SAVE THE DATA, DELETE THEM...
apps@DEV
SQL> REM ...AND THEN INSTALL THE NEW PACKAGE, RUN THE STATEMENT, SAVE IT, AND COMPARE, EH?
apps@DEV
SQL> @lwx_ar_invo_stmt_print-original-we-hope.sql

Package created.

Elapsed: 00:00:00.68

Package body created.

Elapsed: 00:00:06.99
apps@DEV
SQL> rem RAN THE STATEMENT UNDER THE "OLD"/"ORIGINAL" CODE, NOW MUST SAVE THE DATA:
apps@DEV
SQL> select * from lwx_ar_stmt_headers where send_to_cust_nbr = :p_customer_nbr;

    STMT_HDR_ID	STATEMENT_CYCLE_ID	STMT_RUN_CONC_REQ_ID	STMT_DTE            	STMT_CRNCY_CDE 	STM	   PPD_PAGE_CNT	   DTL_PAGE_CNT	  INVO_PAGE_CNT	 TOTAL_PAGE_CNT	LOGO_CDE                      	SEND_TO_CUST_ACCT_SITE_ID	SEND_TO_CUST_NBR              	SEND_TO_CUST_NME                                                                                                                                                                                                                                                                                                                                                        	SEND_TO_LINE_1_ADR                                                                                                                                                                                                                              	SEND_TO_LINE_2_ADR                                                                                                                                                                                                                              	SEND_TO_LINE_3_ADR                                                                                                                                                                                                                              	SEND_TO_LINE_4_ADR                                                                                                                                                                                                                              	SEND_TO_CITY_NME                                            	SEND_	SEND_TO_POST	SEND_TO_CNTRY_NME                                           	REP_PHONE_NBR                 	   OVER_DUE_AMT	        DUE_AMT	     TO_PAY_AMT	STMT_DUE_DTE        	    NOT_DUE_AMT	    BALANCE_AMT	MSG1_NME                                	MSG2_NME                                	SCAN_LINE_NME                                     	LW_FAX_NBR                                        	LW_EMAIL_ADR                                                                                                                                          	     CREATED_BY	CREATION_DATE       	LAST_UPDATED_BY	LAST_UPDATED_DATE   	LAST_UPDATE_LOGIN	CUST_EMAIL_ADR
---------------	------------------	--------------------	--------------------	---------------	---	---------------	---------------	---------------	---------------	------------------------------	-------------------------	------------------------------	------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------	------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------	------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------	------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------	------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------	------------------------------------------------------------	-----	------------	------------------------------------------------------------	------------------------------	---------------	---------------	---------------	--------------------	---------------	---------------	----------------------------------------	----------------------------------------	--------------------------------------------------	--------------------------------------------------	------------------------------------------------------------------------------------------------------------------------------------------------------	---------------	--------------------	---------------	--------------------	-----------------	------------------------------------------------------------------------------------------------------------------------------------------------------
        8505107	              3000	           130866396	05-MAR-2020 17:33:24	USD            	En 	              0	              1	              0	              2	RC                            	                  4719795	2002567196                    	JACOB BOYD                                                                                                                                                                                                                                                                                                                                                              	7300 Gary Street                                                                                                                                                                                                                                	                                                                                                                                                                                                                                                	                                                                                                                                                                                                                                                	                                                                                                                                                                                                                                                	Springfield                                                 	VA   	22150       	United States                                               	1-800-453-9775                	              0	         199.99	         199.99	30-MAR-2020 23:59:59	              0	         199.99	                                        	                                        	1111120025671960000199990000000000                	(615) 251-3914                                    	CustomerAccounts@LifeWay.com                                                                                                                          	          32418	05-MAR-2020 17:33:24	          32418	05-MAR-2020 17:33:24	        142960869	

Elapsed: 00:00:00.58
apps@DEV
SQL> select  * from rstewar.v_ar_stmt_info where send_to_cust_nbr = :p_customer_nbr;

    STMT_HDR_ID	SEND_TO_CUST_NBR              	STATEMENT_CYCLE_ID	STMT_RUN_CONC_REQ_ID	STMT_DTE            	   OVER_DUE_AMT	        DUE_AMT	     TO_PAY_AMT	STMT_DUE_DTE        	    NOT_DUE_AMT	    BALANCE_AMT	TRANS_NBR                     	RE	STMT_LINE_DTL_ID	   STMT_LINE_ID	STMT_LINE_DTL_NBR	L	CUSTOMER_TRX_LINE_ID	ORDERED_QTY_CNT	SHIPPED_QTY_CNT	ITEM_NBR                                                                                            	ALT_ITEM_NBR                                                                                        	LINE_DESC_TXT                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           	SELLING_PRICE_AMT	SELLING_DISC_AMT	   EXTENDED_AMT	     CREATED_BY	CREATION_DATE       	LAST_UPDATED_BY	LAST_UPDATE_DATE    	LAST_UPDATE_LOGIN
---------------	------------------------------	------------------	--------------------	--------------------	---------------	---------------	---------------	--------------------	---------------	---------------	------------------------------	--	----------------	---------------	-----------------	-	--------------------	---------------	---------------	----------------------------------------------------------------------------------------------------	----------------------------------------------------------------------------------------------------	----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------	-----------------	----------------	---------------	---------------	--------------------	---------------	--------------------	-----------------
        8505107	2002567196                    	              3000	           130866396	05-MAR-2020 17:33:24	              0	         199.99	         199.99	30-MAR-2020 23:59:59	              0	         199.99	28619289(15347856)            	F3	                	               	                 	 	                    	               	               	                                                                                                    	                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                 	                	               	               	                    	               	                    	

Elapsed: 00:00:00.45
apps@DEV
SQL> begin 
  autono_stmt_gen_test.copy_stmt_data(
    :p_customer_nbr,
    :statement_cycle_nme,

.
  5  apps@DEV
SQL> begin
  2  .
apps@DEV
SQL> begin
  autono_stmt_gen_test.copy_stmt_data(
    :p_customer_nbr,

.
  4  apps@DEV
SQL> begin
  autono_stmt_gen_test.copy_stmt_data(
    :p_customer_nbr,
    :statement_cycle_nme,
    to_date('05-mar-2020 17:33:24','dd-mon-yyyy hh24:mi:ss')
  );
end;

.
  8  apps@DEV
SQL> /
Copied 0 rows into tst_lwx_ar_stmt_line_details.
Copied 0 rows into tst_lwx_ar_stmt_lines.
Copied 1 rows into tst_lwx_ar_stmt_headers.

PL/SQL procedure successfully completed.

Elapsed: 00:00:00.10
apps@DEV
SQL> declare 
  l_error_msg varchar2(2000); 
  l_error_code number; 
begin
  lwx_ar_delete_statements.delete_stmt(
    p_error_msg => l_error_msg,
    p_error_code => l_error_code,
    p_stmt_hdr_id => 8505107,  -- <<<< As seen in the above query against the rstewar.v_ar_stmt_invo
    p_request_id => null
  );
  dbms_output.put_line('Returned error msg:  '||substr(l_error_msg, 1,150));
  dbms_output.put_line('Returned error code:  '||to_char(l_error_code, 'tm9'));
end;

.
 14  apps@DEV
SQL> /
Returned error msg:
Returned error code:

PL/SQL procedure successfully completed.

Elapsed: 00:00:00.12
apps@DEV
SQL> rem SO NOW I'VE DELETED THE STATEMENT CREATED BY THE "ORIGINAL" CODE, AND I'LL BRING IN THE "NEW" CODE:
apps@DEV
SQL> @LWX_AR_INVO_STMT_PRINT_PKB

Package body created.

Elapsed: 00:00:04.76
apps@DEV
SQL> select * from lwx_ar_stmt_headers where send_to_cust_nbr = :p_customer_nbr;

no rows selected

Elapsed: 00:00:00.50
apps@DEV
SQL> rem NOW I'LL PERFORM ANOTHER STATEMENT RUN AND SAVE THE DATA OFF:
apps@DEV
SQL> rem INTERESTINGLY, NO STATEMENT WAS GENERATED!  I'LL NOW HAVE TO RESEARCH WHAT IS WRONG!
apps@DEV
SQL> 
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
;
apps@DEV

SQL>   2    3    4    5    6    7    8    9   10   11   12   13   14   15   16   17   18   19   20   21   22   23   24   25   26   27   28   29   30   31   32   33   34   35   36   37   38   39   40   41   42   43   44   45   46   47   48   49   50   51   52   53   54   55   56  
STATEMENT_CYCLE_ID	L	    SITE_USE_ID	    CUSTOMER_ID	CREATION_DATE       	CUSTOMER_NUMBER               	CUSTOMER_NAME                                                                                                                                                                                                                                                                                                                                                           	       PARTY_ID	CUSTOMER_PROFILE_ID	STATEMENT_CYCLE	ATTRIBUTE1                                                                                                                                            	   COLLECTOR_ID	SALES_CHANNEL_CODE            	NEW_CONS_INV_FLAG                                                                                                                                     	HDR_LOGO_CODE                                                                                                                                         	LINE_LOGO_CODE                                                                                                                                        	STMT_MSG1                                                                                                                                             	STMT_MSG2                                                                                                                                             	CUST_EMAIL_ADR
------------------	-	---------------	---------------	--------------------	------------------------------	------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------	---------------	-------------------	---------------	------------------------------------------------------------------------------------------------------------------------------------------------------	---------------	------------------------------	------------------------------------------------------------------------------------------------------------------------------------------------------	------------------------------------------------------------------------------------------------------------------------------------------------------	------------------------------------------------------------------------------------------------------------------------------------------------------	------------------------------------------------------------------------------------------------------------------------------------------------------	------------------------------------------------------------------------------------------------------------------------------------------------------	------------------------------------------------------------------------------------------------------------------------------------------------------
              3000	 	               	       22438432	17-DEC-2019 13:10:08	2002567196                    	JACOB BOYD                                                                                                                                                                                                                                                                                                                                                              	       29091354	           22468647	IND            	En                                                                                                                                                    	           1000	SG                            	Y                                                                                                                                                     	RC                                                                                                                                                    	RC                                                                                                                                                    	                                                                                                                                                      	                                                                                                                                                      	

Elapsed: 00:00:10.16
apps@DEV
SQL> apps@DEV
SQL> select max(ash.stmt_dte)
from lwx_ar_stmt_headers ash
where ash.send_to_cust_nbr = 2002567196;


MAX(ASH.STMT_DTE)
--------------------


Elapsed: 00:00:00.45
apps@DEV
SQL> select * from lwx_ar_stmt_headers where send_to_cust_nbr = :p_customer_nbr;

no rows selected

Elapsed: 00:00:00.31
apps@DEV
SQL> select nvl(max(ash.stmt_dte), to_date('17-dec-2019 13:10:08','dd-mon-yyyy hh24:mi:ss'))
from lwx_ar_stmt_headers ash
where ash.send_to_cust_nbr = 2002567196;


NVL(MAX(ASH.STMT_DTE
--------------------
17-DEC-2019 13:10:08

Elapsed: 00:00:00.45
apps@DEV
SQL> @LWX_AR_INVO_STMT_PRINT_PKB

Warning: Package Body created with compilation errors.

Elapsed: 00:00:03.94
apps@DEV
SQL> SHOW ERRORS PACKAGE BODY LWX_AR_INVO_STMT_PRINT
Errors for PACKAGE BODY LWX_AR_INVO_STMT_PRINT:

LINE/COL	ERROR
--------	-----------------------------------------------------------------
2352/9  	PL/SQL: SQL Statement ignored
2353/34 	PL/SQL: ORA-00904: "V_CUSTMER_REC"."CUSTOMER_NBR": invalid
        	identifier

apps@DEV
SQL> @LWX_AR_INVO_STMT_PRINT_PKB

Warning: Package Body created with compilation errors.

Elapsed: 00:00:03.38
apps@DEV
SQL> SHOW ERRORS PACKAGE BODY LWX_AR_INVO_STMT_PRINT
Errors for PACKAGE BODY LWX_AR_INVO_STMT_PRINT:

LINE/COL	ERROR
--------	-----------------------------------------------------------------
2352/9  	PL/SQL: SQL Statement ignored
2353/34 	PL/SQL: ORA-00904: "V_CUSTOMER_REC"."CUSTOMER_NBR": invalid
        	identifier

2353/49 	PLS-00302: component 'CUSTOMER_NBR' must be declared
apps@DEV
SQL> @LWX_AR_INVO_STMT_PRINT_PKB

Package body created.

Elapsed: 00:00:04.84
apps@DEV
SQL> REM NOW THAT I'VE ATTEMPTED A CORRECTION TO THE PACKAGE, WE CAN TRY GENERATING A STATEMENT AGAIN.
apps@DEV
SQL> @LWX_AR_INVO_STMT_PRINT_PKB

Package body created.

Elapsed: 00:00:04.93
apps@DEV
SQL> rem JUST RAN A NEW TEST, AFTER CORRECTING THE PACKAGE CODE TO SUBSTITUTE IN THE QUERY!
apps@DEV
SQL> rem NOW MUST SAVE THE RESULTS:
apps@DEV
SQL> select * from rstewar.v_ar_stmt_info where send_to_cust_nbr = :p_customer_nbr
  2  ;

    STMT_HDR_ID	SEND_TO_CUST_NBR              	STATEMENT_CYCLE_ID	STMT_RUN_CONC_REQ_ID	STMT_DTE            	   OVER_DUE_AMT	        DUE_AMT	     TO_PAY_AMT	STMT_DUE_DTE        	    NOT_DUE_AMT	    BALANCE_AMT	TRANS_NBR                     	RE	STMT_LINE_DTL_ID	   STMT_LINE_ID	STMT_LINE_DTL_NBR	L	CUSTOMER_TRX_LINE_ID	ORDERED_QTY_CNT	SHIPPED_QTY_CNT	ITEM_NBR                                                                                            	ALT_ITEM_NBR                                                                                        	LINE_DESC_TXT                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           	SELLING_PRICE_AMT	SELLING_DISC_AMT	   EXTENDED_AMT	     CREATED_BY	CREATION_DATE       	LAST_UPDATED_BY	LAST_UPDATE_DATE    	LAST_UPDATE_LOGIN
---------------	------------------------------	------------------	--------------------	--------------------	---------------	---------------	---------------	--------------------	---------------	---------------	------------------------------	--	----------------	---------------	-----------------	-	--------------------	---------------	---------------	----------------------------------------------------------------------------------------------------	----------------------------------------------------------------------------------------------------	----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------	-----------------	----------------	---------------	---------------	--------------------	---------------	--------------------	-----------------
        8505108	2002567196                    	              3000	           130866437	05-MAR-2020 18:10:04	              0	         199.99	         199.99	30-MAR-2020 23:59:59	              0	         199.99	28619289(15347856)            	F3	                	               	                 	 	                    	               	               	                                                                                                    	                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                 	                	               	               	                    	               	                    	

Elapsed: 00:00:00.61
apps@DEV
SQL> begin 
    autono_stmt_gen_test.copy_stmt_data(
    :p_customer_nbr,
    :p_statement_cycle_nme,
    to_date('05-mar-2020 18:10:04','dd-mon-yyyy hh24:mi:ss') -- <<<< this should be the date pushed into the stmt_dte column...
  );
end;

.
  8  apps@DEV
SQL> /
SP2-0552: Bind variable "P_STATEMENT_CYCLE_NME" not declared.
Elapsed: 00:00:00.00
apps@DEV
SQL> begin 
    autono_stmt_gen_test.copy_stmt_data(
    :p_customer_nbr,
    :statement_cycle_nme,
    to_date('05-mar-2020 18:10:04','dd-mon-yyyy hh24:mi:ss') -- <<<< this should be the date pushed into the stmt_dte column...
  );
end;

/
  8  Copied 0 rows into tst_lwx_ar_stmt_line_details.
Copied 0 rows into tst_lwx_ar_stmt_lines.
Copied 1 rows into tst_lwx_ar_stmt_headers.

PL/SQL procedure successfully completed.

Elapsed: 00:00:00.15
apps@DEV
SQL> REM SAVED THE RESULTS.
apps@DEV
SQL> @desc rstewar.tst_lwx_ar_stmt_headers
 Name                                                              Null?    Type
 ----------------------------------------------------------------- -------- --------------------------------------------
 STMT_HDR_ID                                                       NOT NULL NUMBER(22)
 STATEMENT_CYCLE_ID                                                NOT NULL NUMBER(15)
 STMT_RUN_CONC_REQ_ID                                                       NUMBER(22)
 STMT_DTE                                                          NOT NULL DATE
 STMT_CRNCY_CDE                                                    NOT NULL VARCHAR2(15)
 STMT_LANG_CDE                                                     NOT NULL VARCHAR2(3)
 PPD_PAGE_CNT                                                               NUMBER(22)
 DTL_PAGE_CNT                                                               NUMBER(22)
 INVO_PAGE_CNT                                                              NUMBER(22)
 TOTAL_PAGE_CNT                                                             NUMBER(22)
 LOGO_CDE                                                                   VARCHAR2(30)
 SEND_TO_CUST_ACCT_SITE_ID                                         NOT NULL NUMBER(22)
 SEND_TO_CUST_NBR                                                  NOT NULL VARCHAR2(30)
 SEND_TO_CUST_NME                                                  NOT NULL VARCHAR2(360)
 SEND_TO_LINE_1_ADR                                                         VARCHAR2(240)
 SEND_TO_LINE_2_ADR                                                         VARCHAR2(240)
 SEND_TO_LINE_3_ADR                                                         VARCHAR2(240)
 SEND_TO_LINE_4_ADR                                                         VARCHAR2(240)
 SEND_TO_CITY_NME                                                           VARCHAR2(60)
 SEND_TO_STATE_CDE                                                          VARCHAR2(5)
 SEND_TO_POSTAL_CDE                                                         VARCHAR2(12)
 SEND_TO_CNTRY_NME                                                          VARCHAR2(60)
 REP_PHONE_NBR                                                              VARCHAR2(30)
 OVER_DUE_AMT                                                               NUMBER
 DUE_AMT                                                                    NUMBER
 TO_PAY_AMT                                                                 NUMBER
 STMT_DUE_DTE                                                               DATE
 NOT_DUE_AMT                                                                NUMBER
 BALANCE_AMT                                                                NUMBER
 MSG1_NME                                                                   VARCHAR2(40)
 MSG2_NME                                                                   VARCHAR2(40)
 SCAN_LINE_NME                                                              VARCHAR2(50)
 LW_FAX_NBR                                                                 VARCHAR2(50)
 LW_EMAIL_ADR                                                               VARCHAR2(150)
 CREATED_BY                                                        NOT NULL NUMBER(15)
 CREATION_DATE                                                     NOT NULL DATE
 LAST_UPDATED_BY                                                   NOT NULL NUMBER(15)
 LAST_UPDATED_DATE                                                 NOT NULL DATE
 LAST_UPDATE_LOGIN                                                          NUMBER(15)
 CUST_EMAIL_ADR                                                             VARCHAR2(150)
 TEST_DATE                                                                  DATE
 TEST_SEQUENCE                                                              NUMBER

apps@DEV
SQL> select * from rstewar.tst_lwx_ar_stmt_headers order by test_sequence ;

    STMT_HDR_ID	STATEMENT_CYCLE_ID	STMT_RUN_CONC_REQ_ID	STMT_DTE            	STMT_CRNCY_CDE 	STM	   PPD_PAGE_CNT	   DTL_PAGE_CNT	  INVO_PAGE_CNT	 TOTAL_PAGE_CNT	LOGO_CDE                      	SEND_TO_CUST_ACCT_SITE_ID	SEND_TO_CUST_NBR              	SEND_TO_CUST_NME                                                                                                                                                                                                                                                                                                                                                        	SEND_TO_LINE_1_ADR                                                                                                                                                                                                                              	SEND_TO_LINE_2_ADR                                                                                                                                                                                                                              	SEND_TO_LINE_3_ADR                                                                                                                                                                                                                              	SEND_TO_LINE_4_ADR                                                                                                                                                                                                                              	SEND_TO_CITY_NME                                            	SEND_	SEND_TO_POST	SEND_TO_CNTRY_NME                                           	REP_PHONE_NBR                 	   OVER_DUE_AMT	        DUE_AMT	     TO_PAY_AMT	STMT_DUE_DTE        	    NOT_DUE_AMT	    BALANCE_AMT	MSG1_NME                                	MSG2_NME                                	SCAN_LINE_NME                                     	LW_FAX_NBR                                        	LW_EMAIL_ADR                                                                                                                                          	     CREATED_BY	CREATION_DATE       	LAST_UPDATED_BY	LAST_UPDATED_DATE   	LAST_UPDATE_LOGIN	CUST_EMAIL_ADR                                                                                                                                        	TEST_DATE           	  TEST_SEQUENCE
---------------	------------------	--------------------	--------------------	---------------	---	---------------	---------------	---------------	---------------	------------------------------	-------------------------	------------------------------	------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------	------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------	------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------	------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------	------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------	------------------------------------------------------------	-----	------------	------------------------------------------------------------	------------------------------	---------------	---------------	---------------	--------------------	---------------	---------------	----------------------------------------	----------------------------------------	--------------------------------------------------	--------------------------------------------------	------------------------------------------------------------------------------------------------------------------------------------------------------	---------------	--------------------	---------------	--------------------	-----------------	------------------------------------------------------------------------------------------------------------------------------------------------------	--------------------	---------------
        8503108	              1000	           130851877	25-FEB-2020 10:23:06	USD            	En 	              0	              1	              1	              3	RC                            	                    29001	0000571900                    	Fountain Valley Baptist Church                                                                                                                                                                                                                                                                                                                                          	Po Box 237                                                                                                                                                                                                                                      	                                                                                                                                                                                                                                                	                                                                                                                                                                                                                                                	                                                                                                                                                                                                                                                	Fountain                                                    	CO   	80817-0237  	United States                                               	1-800-453-9775                	         107.34	          202.8	         310.14	21-MAR-2020 23:59:59	              0	         310.14	                                        	                                        	1111100005719000000310140000000001                	(615) 251-3914                                    	CustomerAccounts@LifeWay.com                                                                                                                          	          32418	25-FEB-2020 10:23:06	          32418	25-FEB-2020 10:23:06	        142946339	                                                                                                                                                      	25-FEB-2020 12:30:52	              2
        8503108	              1000	           130851877	25-FEB-2020 10:23:06	USD            	En 	              0	              1	              1	              3	RC                            	                    29001	0000571900                    	Fountain Valley Baptist Church                                                                                                                                                                                                                                                                                                                                          	Po Box 237                                                                                                                                                                                                                                      	                                                                                                                                                                                                                                                	                                                                                                                                                                                                                                                	                                                                                                                                                                                                                                                	Fountain                                                    	CO   	80817-0237  	United States                                               	1-800-453-9775                	         107.34	          202.8	         310.14	21-MAR-2020 23:59:59	              0	         310.14	                                        	                                        	1111100005719000000310140000000001                	(615) 251-3914                                    	CustomerAccounts@LifeWay.com                                                                                                                          	          32418	25-FEB-2020 10:23:06	          32418	25-FEB-2020 10:23:06	        142946339	                                                                                                                                                      	25-FEB-2020 12:30:52	              2
        8503108	              1000	           130851877	25-FEB-2020 10:23:06	USD            	En 	              0	              1	              1	              3	RC                            	                    29001	0000571900                    	Fountain Valley Baptist Church                                                                                                                                                                                                                                                                                                                                          	Po Box 237                                                                                                                                                                                                                                      	                                                                                                                                                                                                                                                	                                                                                                                                                                                                                                                	                                                                                                                                                                                                                                                	Fountain                                                    	CO   	80817-0237  	United States                                               	1-800-453-9775                	         107.34	          202.8	         310.14	21-MAR-2020 23:59:59	              0	         310.14	                                        	                                        	1111100005719000000310140000000001                	(615) 251-3914                                    	CustomerAccounts@LifeWay.com                                                                                                                          	          32418	25-FEB-2020 10:23:06	          32418	25-FEB-2020 10:23:06	        142946339	                                                                                                                                                      	25-FEB-2020 12:30:52	              2
        8503108	              1000	           130851877	25-FEB-2020 10:23:06	USD            	En 	              0	              1	              1	              3	RC                            	                    29001	0000571900                    	Fountain Valley Baptist Church                                                                                                                                                                                                                                                                                                                                          	Po Box 237                                                                                                                                                                                                                                      	                                                                                                                                                                                                                                                	                                                                                                                                                                                                                                                	                                                                                                                                                                                                                                                	Fountain                                                    	CO   	80817-0237  	United States                                               	1-800-453-9775                	         107.34	          202.8	         310.14	21-MAR-2020 23:59:59	              0	         310.14	                                        	                                        	1111100005719000000310140000000001                	(615) 251-3914                                    	CustomerAccounts@LifeWay.com                                                                                                                          	          32418	25-FEB-2020 10:23:06	          32418	25-FEB-2020 10:23:06	        142946339	                                                                                                                                                      	25-FEB-2020 12:30:52	              2
        8503108	              1000	           130851877	25-FEB-2020 10:23:06	USD            	En 	              0	              1	              1	              3	RC                            	                    29001	0000571900                    	Fountain Valley Baptist Church                                                                                                                                                                                                                                                                                                                                          	Po Box 237                                                                                                                                                                                                                                      	                                                                                                                                                                                                                                                	                                                                                                                                                                                                                                                	                                                                                                                                                                                                                                                	Fountain                                                    	CO   	80817-0237  	United States                                               	1-800-453-9775                	         107.34	          202.8	         310.14	21-MAR-2020 23:59:59	              0	         310.14	                                        	                                        	1111100005719000000310140000000001                	(615) 251-3914                                    	CustomerAccounts@LifeWay.com                                                                                                                          	          32418	25-FEB-2020 10:23:06	          32418	25-FEB-2020 10:23:06	        142946339	                                                                                                                                                      	25-FEB-2020 12:30:52	              2
        8503108	              1000	           130851877	25-FEB-2020 10:23:06	USD            	En 	              0	              1	              1	              3	RC                            	                    29001	0000571900                    	Fountain Valley Baptist Church                                                                                                                                                                                                                                                                                                                                          	Po Box 237                                                                                                                                                                                                                                      	                                                                                                                                                                                                                                                	                                                                                                                                                                                                                                                	                                                                                                                                                                                                                                                	Fountain                                                    	CO   	80817-0237  	United States                                               	1-800-453-9775                	         107.34	          202.8	         310.14	21-MAR-2020 23:59:59	              0	         310.14	                                        	                                        	1111100005719000000310140000000001                	(615) 251-3914                                    	CustomerAccounts@LifeWay.com                                                                                                                          	          32418	25-FEB-2020 10:23:06	          32418	25-FEB-2020 10:23:06	        142946339	                                                                                                                                                      	25-FEB-2020 12:30:52	              2
        8503109	              1000	           130852180	25-FEB-2020 14:43:25	USD            	En 	              0	              1	              1	              3	RC                            	                    29001	0000571900                    	Fountain Valley Baptist Church                                                                                                                                                                                                                                                                                                                                          	Po Box 237                                                                                                                                                                                                                                      	                                                                                                                                                                                                                                                	                                                                                                                                                                                                                                                	                                                                                                                                                                                                                                                	Fountain                                                    	CO   	80817-0237  	United States                                               	1-800-453-9775                	         107.34	          202.8	         310.14	21-MAR-2020 23:59:59	              0	         310.14	                                        	                                        	1111100005719000000310140000000001                	(615) 251-3914                                    	CustomerAccounts@LifeWay.com                                                                                                                          	          32418	25-FEB-2020 14:43:25	          32418	25-FEB-2020 14:43:25	        142946645	                                                                                                                                                      	25-FEB-2020 14:46:34	              3
        8503109	              1000	           130852180	25-FEB-2020 14:43:25	USD            	En 	              0	              1	              1	              3	RC                            	                    29001	0000571900                    	Fountain Valley Baptist Church                                                                                                                                                                                                                                                                                                                                          	Po Box 237                                                                                                                                                                                                                                      	                                                                                                                                                                                                                                                	                                                                                                                                                                                                                                                	                                                                                                                                                                                                                                                	Fountain                                                    	CO   	80817-0237  	United States                                               	1-800-453-9775                	         107.34	          202.8	         310.14	21-MAR-2020 23:59:59	              0	         310.14	                                        	                                        	1111100005719000000310140000000001                	(615) 251-3914                                    	CustomerAccounts@LifeWay.com                                                                                                                          	          32418	25-FEB-2020 14:43:25	          32418	25-FEB-2020 14:43:25	        142946645	                                                                                                                                                      	25-FEB-2020 14:46:34	              3
        8503109	              1000	           130852180	25-FEB-2020 14:43:25	USD            	En 	              0	              1	              1	              3	RC                            	                    29001	0000571900                    	Fountain Valley Baptist Church                                                                                                                                                                                                                                                                                                                                          	Po Box 237                                                                                                                                                                                                                                      	                                                                                                                                                                                                                                                	                                                                                                                                                                                                                                                	                                                                                                                                                                                                                                                	Fountain                                                    	CO   	80817-0237  	United States                                               	1-800-453-9775                	         107.34	          202.8	         310.14	21-MAR-2020 23:59:59	              0	         310.14	                                        	                                        	1111100005719000000310140000000001                	(615) 251-3914                                    	CustomerAccounts@LifeWay.com                                                                                                                          	          32418	25-FEB-2020 14:43:25	          32418	25-FEB-2020 14:43:25	        142946645	                                                                                                                                                      	25-FEB-2020 14:46:34	              3
        8503109	              1000	           130852180	25-FEB-2020 14:43:25	USD            	En 	              0	              1	              1	              3	RC                            	                    29001	0000571900                    	Fountain Valley Baptist Church                                                                                                                                                                                                                                                                                                                                          	Po Box 237                                                                                                                                                                                                                                      	                                                                                                                                                                                                                                                	                                                                                                                                                                                                                                                	                                                                                                                                                                                                                                                	Fountain                                                    	CO   	80817-0237  	United States                                               	1-800-453-9775                	         107.34	          202.8	         310.14	21-MAR-2020 23:59:59	              0	         310.14	                                        	                                        	1111100005719000000310140000000001                	(615) 251-3914                                    	CustomerAccounts@LifeWay.com                                                                                                                          	          32418	25-FEB-2020 14:43:25	          32418	25-FEB-2020 14:43:25	        142946645	                                                                                                                                                      	25-FEB-2020 14:46:34	              3
        8503109	              1000	           130852180	25-FEB-2020 14:43:25	USD            	En 	              0	              1	              1	              3	RC                            	                    29001	0000571900                    	Fountain Valley Baptist Church                                                                                                                                                                                                                                                                                                                                          	Po Box 237                                                                                                                                                                                                                                      	                                                                                                                                                                                                                                                	                                                                                                                                                                                                                                                	                                                                                                                                                                                                                                                	Fountain                                                    	CO   	80817-0237  	United States                                               	1-800-453-9775                	         107.34	          202.8	         310.14	21-MAR-2020 23:59:59	              0	         310.14	                                        	                                        	1111100005719000000310140000000001                	(615) 251-3914                                    	CustomerAccounts@LifeWay.com                                                                                                                          	          32418	25-FEB-2020 14:43:25	          32418	25-FEB-2020 14:43:25	        142946645	                                                                                                                                                      	25-FEB-2020 14:46:34	              3
        8503109	              1000	           130852180	25-FEB-2020 14:43:25	USD            	En 	              0	              1	              1	              3	RC                            	                    29001	0000571900                    	Fountain Valley Baptist Church                                                                                                                                                                                                                                                                                                                                          	Po Box 237                                                                                                                                                                                                                                      	                                                                                                                                                                                                                                                	                                                                                                                                                                                                                                                	                                                                                                                                                                                                                                                	Fountain                                                    	CO   	80817-0237  	United States                                               	1-800-453-9775                	         107.34	          202.8	         310.14	21-MAR-2020 23:59:59	              0	         310.14	                                        	                                        	1111100005719000000310140000000001                	(615) 251-3914                                    	CustomerAccounts@LifeWay.com                                                                                                                          	          32418	25-FEB-2020 14:43:25	          32418	25-FEB-2020 14:43:25	        142946645	                                                                                                                                                      	25-FEB-2020 14:46:34	              3
        8504109	              1003	           130855336	27-FEB-2020 14:51:46	USD            	En 	              0	              1	              0	              2	RC                            	                  4693755	2002549807                    	Lively Stone Apostolic Church                                                                                                                                                                                                                                                                                                                                           	3421 Tara Blvd                                                                                                                                                                                                                                  	                                                                                                                                                                                                                                                	                                                                                                                                                                                                                                                	                                                                                                                                                                                                                                                	Clarksville                                                 	TN   	37042       	United States                                               	1-800-453-9775                	              0	          47.78	          47.78	19-FEB-2020 23:59:59	              0	          47.78	                                        	                                        	1111120025498070000047780000000004                	(615) 251-3914                                    	CustomerAccounts@LifeWay.com                                                                                                                          	          32418	27-FEB-2020 14:51:46	          32418	27-FEB-2020 14:51:46	        142949817	                                                                                                                                                      	27-FEB-2020 14:57:04	              4
        8504110	              1003	           130855350	27-FEB-2020 15:03:18	USD            	En 	              0	              1	              0	              2	RC                            	                  4693755	2002549807                    	Lively Stone Apostolic Church                                                                                                                                                                                                                                                                                                                                           	3421 Tara Blvd                                                                                                                                                                                                                                  	                                                                                                                                                                                                                                                	                                                                                                                                                                                                                                                	                                                                                                                                                                                                                                                	Clarksville                                                 	TN   	37042       	United States                                               	1-800-453-9775                	              0	              0	              0	19-FEB-2020 23:59:59	          47.78	          47.78	                                        	                                        	1111120025498070000000000000000002                	(615) 251-3914                                    	CustomerAccounts@LifeWay.com                                                                                                                          	          32418	27-FEB-2020 15:03:18	          32418	27-FEB-2020 15:03:18	        142949831	                                                                                                                                                      	27-FEB-2020 15:08:22	              5
        8505106	              1003	           130866158	05-MAR-2020 13:56:49	USD            	En 	              0	              1	              0	              2	RC                            	                  4693755	2002549807                    	Lively Stone Apostolic Church                                                                                                                                                                                                                                                                                                                                           	3421 Tara Blvd                                                                                                                                                                                                                                  	                                                                                                                                                                                                                                                	                                                                                                                                                                                                                                                	                                                                                                                                                                                                                                                	Clarksville                                                 	TN   	37042       	United States                                               	1-800-453-9775                	              0	          47.78	          47.78	14-FEB-2020 23:59:59	              0	          47.78	                                        	                                        	1111120025498070000047780000000004                	(615) 251-3914                                    	CustomerAccounts@LifeWay.com                                                                                                                          	          32418	05-MAR-2020 13:56:49	          32418	05-MAR-2020 13:56:49	        142960634	                                                                                                                                                      	05-MAR-2020 14:24:42	             21
        8505107	              3000	           130866396	05-MAR-2020 17:33:24	USD            	En 	              0	              1	              0	              2	RC                            	                  4719795	2002567196                    	JACOB BOYD                                                                                                                                                                                                                                                                                                                                                              	7300 Gary Street                                                                                                                                                                                                                                	                                                                                                                                                                                                                                                	                                                                                                                                                                                                                                                	                                                                                                                                                                                                                                                	Springfield                                                 	VA   	22150       	United States                                               	1-800-453-9775                	              0	         199.99	         199.99	30-MAR-2020 23:59:59	              0	         199.99	                                        	                                        	1111120025671960000199990000000000                	(615) 251-3914                                    	CustomerAccounts@LifeWay.com                                                                                                                          	          32418	05-MAR-2020 17:33:24	          32418	05-MAR-2020 17:33:24	        142960869	                                                                                                                                                      	05-MAR-2020 17:41:08	             22
        8505108	              3000	           130866437	05-MAR-2020 18:10:04	USD            	En 	              0	              1	              0	              2	RC                            	                  4719795	2002567196                    	JACOB BOYD                                                                                                                                                                                                                                                                                                                                                              	7300 Gary Street                                                                                                                                                                                                                                	                                                                                                                                                                                                                                                	                                                                                                                                                                                                                                                	                                                                                                                                                                                                                                                	Springfield                                                 	VA   	22150       	United States                                               	1-800-453-9775                	              0	         199.99	         199.99	30-MAR-2020 23:59:59	              0	         199.99	                                        	                                        	1111120025671960000199990000000000                	(615) 251-3914                                    	CustomerAccounts@LifeWay.com                                                                                                                          	          32418	05-MAR-2020 18:10:04	          32418	05-MAR-2020 18:10:04	        142960910	                                                                                                                                                      	05-MAR-2020 18:15:27	             23

17 rows selected.

Elapsed: 00:00:03.95
apps@DEV
SQL> disco
Disconnected from Oracle Database 11g Enterprise Edition Release 11.2.0.3.0 - 64bit Production
With the Partitioning, Automatic Storage Management, OLAP and Data Mining options
apps@DEV
SQL> @connect apps@dev
Enter password: Connected.
Logged in at: Fri 06-mar-2020 09:26:52 am

apps@DEV
SQL> rem is it better now?  now much
apps@DEV
SQL>select * from rstewar.tst_lwx_ar_stmt_headers where stmt_header_id = 8505108;
select * from rstewar.tst_lwx_ar_stmt_headers where stmt_header_id = 8505108
                                                    *
ERROR at line 1:
ORA-00904: "STMT_HEADER_ID": invalid identifier


Elapsed: 00:00:00.13
apps@DEV
SQL> select * from rstewar.tst_lwx_ar_stmt_headers where stmt_hdr_id = 8505108;

    STMT_HDR_ID	STATEMENT_CYCLE_ID	STMT_RUN_CONC_REQ_ID	STMT_DTE            	STMT_CRNCY_CDE 	STM	   PPD_PAGE_CNT	   DTL_PAGE_CNT	  INVO_PAGE_CNT	 TOTAL_PAGE_CNT	LOGO_CDE                      	SEND_TO_CUST_ACCT_SITE_ID	SEND_TO_CUST_NBR              	SEND_TO_CUST_NME                                                                                                                                                                                                                                                                                                                                                        	SEND_TO_LINE_1_ADR
---------------	------------------	--------------------	--------------------	---------------	---	---------------	---------------	---------------	---------------	------------------------------	-------------------------	------------------------------	------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------	------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
SEND_TO_LINE_2_ADR                                                                                                                                                                                                                              	SEND_TO_LINE_3_ADR                                                                                                                                                                                                                              	SEND_TO_LINE_4_ADR                                                                                                                                                                                                                              	SEND_TO_CITY_NME                                            	SEND_	SEND_TO_POST	SEND_TO_CNTRY_NME                                           	REP_PHONE_NBR                 	   OVER_DUE_AMT	        DUE_AMT	     TO_PAY_AMT	STMT_DUE_DTE        	    NOT_DUE_AMT	    BALANCE_AMT
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------	------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------	------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------	------------------------------------------------------------	-----	------------	------------------------------------------------------------	------------------------------	---------------	---------------	---------------	--------------------	---------------	---------------
MSG1_NME                                	MSG2_NME                                	SCAN_LINE_NME                                     	LW_FAX_NBR                                        	LW_EMAIL_ADR                                                                                                                                          	     CREATED_BY	CREATION_DATE       	LAST_UPDATED_BY	LAST_UPDATED_DATE   	LAST_UPDATE_LOGIN	CUST_EMAIL_ADR                                                                                                                                        	TEST_DATE           	  TEST_SEQUENCE
----------------------------------------	----------------------------------------	--------------------------------------------------	--------------------------------------------------	------------------------------------------------------------------------------------------------------------------------------------------------------	---------------	--------------------	---------------	--------------------	-----------------	------------------------------------------------------------------------------------------------------------------------------------------------------	--------------------	---------------
        8505108	              3000	           130866437	05-MAR-2020 18:10:04	USD            	En 	              0	              1	              0	              2	RC                            	                  4719795	2002567196                    	JACOB BOYD                                                                                                                                                                                                                                                                                                                                                              	7300 Gary Street
                                                                                                                                                                                                                                                	                                                                                                                                                                                                                                                	                                                                                                                                                                                                                                                	Springfield                                                 	VA   	22150       	United States                                               	1-800-453-9775                	              0	         199.99	         199.99	30-MAR-2020 23:59:59	              0	         199.99
                                        	                                        	1111120025671960000199990000000000                	(615) 251-3914                                    	CustomerAccounts@LifeWay.com                                                                                                                          	          32418	05-MAR-2020 18:10:04	          32418	05-MAR-2020 18:10:04	        142960910	                                                                                                                                                      	05-MAR-2020 18:15:27	             23


Elapsed: 00:00:00.57
apps@DEV
SQL> set lin 32767
apps@DEV
SQL> /

    STMT_HDR_ID	STATEMENT_CYCLE_ID	STMT_RUN_CONC_REQ_ID	STMT_DTE            	STMT_CRNCY_CDE 	STM	   PPD_PAGE_CNT	   DTL_PAGE_CNT	  INVO_PAGE_CNT	 TOTAL_PAGE_CNT	LOGO_CDE                      	SEND_TO_CUST_ACCT_SITE_ID	SEND_TO_CUST_NBR              	SEND_TO_CUST_NME                                                                                                                                                                                                                                                                                                                                                        	SEND_TO_LINE_1_ADR                                                                                                                                                                                                                              	SEND_TO_LINE_2_ADR                                                                                                                                                                                                                              	SEND_TO_LINE_3_ADR                                                                                                                                                                                                                              	SEND_TO_LINE_4_ADR                                                                                                                                                                                                                              	SEND_TO_CITY_NME                                            	SEND_	SEND_TO_POST	SEND_TO_CNTRY_NME                                           	REP_PHONE_NBR                 	   OVER_DUE_AMT	        DUE_AMT	     TO_PAY_AMT	STMT_DUE_DTE        	    NOT_DUE_AMT	    BALANCE_AMT	MSG1_NME                                	MSG2_NME                                	SCAN_LINE_NME                                     	LW_FAX_NBR                                        	LW_EMAIL_ADR                                                                                                                                          	     CREATED_BY	CREATION_DATE       	LAST_UPDATED_BY	LAST_UPDATED_DATE   	LAST_UPDATE_LOGIN	CUST_EMAIL_ADR                                                                                                                                        	TEST_DATE           	  TEST_SEQUENCE
---------------	------------------	--------------------	--------------------	---------------	---	---------------	---------------	---------------	---------------	------------------------------	-------------------------	------------------------------	------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------	------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------	------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------	------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------	------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------	------------------------------------------------------------	-----	------------	------------------------------------------------------------	------------------------------	---------------	---------------	---------------	--------------------	---------------	---------------	----------------------------------------	----------------------------------------	--------------------------------------------------	--------------------------------------------------	------------------------------------------------------------------------------------------------------------------------------------------------------	---------------	--------------------	---------------	--------------------	-----------------	------------------------------------------------------------------------------------------------------------------------------------------------------	--------------------	---------------
        8505108	              3000	           130866437	05-MAR-2020 18:10:04	USD            	En 	              0	              1	              0	              2	RC                            	                  4719795	2002567196                    	JACOB BOYD                                                                                                                                                                                                                                                                                                                                                              	7300 Gary Street                                                                                                                                                                                                                                	                                                                                                                                                                                                                                                	                                                                                                                                                                                                                                                	                                                                                                                                                                                                                                                	Springfield                                                 	VA   	22150       	United States                                               	1-800-453-9775                	              0	         199.99	         199.99	30-MAR-2020 23:59:59	              0	         199.99	                                        	                                        	1111120025671960000199990000000000                	(615) 251-3914                                    	CustomerAccounts@LifeWay.com                                                                                                                          	          32418	05-MAR-2020 18:10:04	          32418	05-MAR-2020 18:10:04	        142960910	                                                                                                                                                      	05-MAR-2020 18:15:27	             23

Elapsed: 00:00:00.57
apps@DEV
SQL> begin
  .

print

;
print
select * from dual;


end;
.
  3    4    5    6    7    8    9   10   11  apps@DEV
SQL> l
  1  begin
  2    .
  3  print
  4
  5  ;
  6  print
  7  select * from dual;
  8
  9
 10* end;
apps@DEV
SQL> clear sql
sql cleared
apps@DEV
SQL> print

apps@DEV
SQL> apps@DEV
SQL> clear sql
sql cleared
apps@DEV
SQL> declare 
  l_error_msg varchar2(2000); 
  l_error_code number; 
begin
  lwx_ar_delete_statements.delete_stmt(
    p_error_msg => l_error_msg,
    p_error_code => l_error_code,
    p_stmt_hdr_id => 8505108,  -- <<<< As seen in the above query against the rstewar.v_ar_stmt_invo
    p_request_id => null
  );
  dbms_output.put_line('Returned error msg:  '||substr(l_error_msg, 1,150));
  dbms_output.put_line('Returned error code:  '||to_char(l_error_code, 'tm9'));
end;

.
  2    3    4    5    6    7    8    9   10   11   12   13   14   15  apps@DEV
SQL> select * from lwx_ar_stmt_headers where stmt_hdr_id = 8505108;

    STMT_HDR_ID	STATEMENT_CYCLE_ID	STMT_RUN_CONC_REQ_ID	STMT_DTE            	STMT_CRNCY_CDE 	STM	   PPD_PAGE_CNT	   DTL_PAGE_CNT	  INVO_PAGE_CNT	 TOTAL_PAGE_CNT	LOGO_CDE                      	SEND_TO_CUST_ACCT_SITE_ID	SEND_TO_CUST_NBR              	SEND_TO_CUST_NME                                                                                                                                                                                                                                                                                                                                                        	SEND_TO_LINE_1_ADR                                                                                                                                                                                                                              	SEND_TO_LINE_2_ADR                                                                                                                                                                                                                              	SEND_TO_LINE_3_ADR                                                                                                                                                                                                                              	SEND_TO_LINE_4_ADR                                                                                                                                                                                                                              	SEND_TO_CITY_NME                                            	SEND_	SEND_TO_POST	SEND_TO_CNTRY_NME                                           	REP_PHONE_NBR                 	   OVER_DUE_AMT	        DUE_AMT	     TO_PAY_AMT	STMT_DUE_DTE        	    NOT_DUE_AMT	    BALANCE_AMT	MSG1_NME                                	MSG2_NME                                	SCAN_LINE_NME                                     	LW_FAX_NBR                                        	LW_EMAIL_ADR                                                                                                                                          	     CREATED_BY	CREATION_DATE       	LAST_UPDATED_BY	LAST_UPDATED_DATE   	LAST_UPDATE_LOGIN	CUST_EMAIL_ADR
---------------	------------------	--------------------	--------------------	---------------	---	---------------	---------------	---------------	---------------	------------------------------	-------------------------	------------------------------	------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------	------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------	------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------	------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------	------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------	------------------------------------------------------------	-----	------------	------------------------------------------------------------	------------------------------	---------------	---------------	---------------	--------------------	---------------	---------------	----------------------------------------	----------------------------------------	--------------------------------------------------	--------------------------------------------------	------------------------------------------------------------------------------------------------------------------------------------------------------	---------------	--------------------	---------------	--------------------	-----------------	------------------------------------------------------------------------------------------------------------------------------------------------------
        8505108	              3000	           130866437	05-MAR-2020 18:10:04	USD            	En 	              0	              1	              0	              2	RC                            	                  4719795	2002567196                    	JACOB BOYD                                                                                                                                                                                                                                                                                                                                                              	7300 Gary Street                                                                                                                                                                                                                                	                                                                                                                                                                                                                                                	                                                                                                                                                                                                                                                	                                                                                                                                                                                                                                                	Springfield                                                 	VA   	22150       	United States                                               	1-800-453-9775                	              0	         199.99	         199.99	30-MAR-2020 23:59:59	              0	         199.99	                                        	                                        	1111120025671960000199990000000000                	(615) 251-3914                                    	CustomerAccounts@LifeWay.com                                                                                                                          	          32418	05-MAR-2020 18:10:04	          32418	05-MAR-2020 18:10:04	        142960910	

Elapsed: 00:00:00.36
apps@DEV
SQL> declare 
  l_error_msg varchar2(2000); 
  l_error_code number; 
begin
  lwx_ar_delete_statements.delete_stmt(
    p_error_msg => l_error_msg,
    p_error_code => l_error_code,
    p_stmt_hdr_id => 8505108,  -- <<<< As seen in the above query against the rstewar.v_ar_stmt_invo
    p_request_id => null
  );
  dbms_output.put_line('Returned error msg:  '||substr(l_error_msg, 1,150));
  dbms_output.put_line('Returned error code:  '||to_char(l_error_code, 'tm9'));
end;


.
 15  apps@DEV
SQL> select * from rstewar.v_ar_stmt_info where send_to_cust_nbr = :p_customer_nbr;

    STMT_HDR_ID	SEND_TO_CUST_NBR              	STATEMENT_CYCLE_ID	STMT_RUN_CONC_REQ_ID	STMT_DTE            	   OVER_DUE_AMT	        DUE_AMT	     TO_PAY_AMT	STMT_DUE_DTE        	    NOT_DUE_AMT	    BALANCE_AMT	TRANS_NBR                     	RE	STMT_LINE_DTL_ID	   STMT_LINE_ID	STMT_LINE_DTL_NBR	L	CUSTOMER_TRX_LINE_ID	ORDERED_QTY_CNT	SHIPPED_QTY_CNT	ITEM_NBR                                                                                            	ALT_ITEM_NBR                                                                                        	LINE_DESC_TXT                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           	SELLING_PRICE_AMT	SELLING_DISC_AMT	   EXTENDED_AMT	     CREATED_BY	CREATION_DATE       	LAST_UPDATED_BY	LAST_UPDATE_DATE    	LAST_UPDATE_LOGIN
---------------	------------------------------	------------------	--------------------	--------------------	---------------	---------------	---------------	--------------------	---------------	---------------	------------------------------	--	----------------	---------------	-----------------	-	--------------------	---------------	---------------	----------------------------------------------------------------------------------------------------	----------------------------------------------------------------------------------------------------	----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------	-----------------	----------------	---------------	---------------	--------------------	---------------	--------------------	-----------------
        8505108	2002567196                    	              3000	           130866437	05-MAR-2020 18:10:04	              0	         199.99	         199.99	30-MAR-2020 23:59:59	              0	         199.99	28619289(15347856)            	F3	                	               	                 	 	                    	               	               	                                                                                                    	                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                 	                	               	               	                    	               	                    	

Elapsed: 00:00:01.23
apps@DEV
SQL> declare 
  l_error_msg varchar2(2000); 
  l_error_code number; 
begin
  lwx_ar_delete_statements.delete_stmt(
    p_error_msg => l_error_msg,
    p_error_code => l_error_code,
    p_stmt_hdr_id => 8505108,  -- <<<< As seen in the above query against the rstewar.v_ar_stmt_invo
    p_request_id => null
  );
  dbms_output.put_line('Returned error msg:  '||substr(l_error_msg, 1,150));
  dbms_output.put_line('Returned error code:  '||to_char(l_error_code, 'tm9'));
end;

.
  2    3    4    5    6    7    8    9   10   11   12   13   14   15  apps@DEV
SQL> /
Returned error msg:
Returned error code:

PL/SQL procedure successfully completed.

Elapsed: 00:00:00.15
apps@DEV
SQL> commit;

Commit complete.

Elapsed: 00:00:00.10
apps@DEV
SQL> @desc ra_customer_trx_all
 Name                                                              Null?    Type
 ----------------------------------------------------------------- -------- --------------------------------------------
 CUSTOMER_TRX_ID                                                   NOT NULL NUMBER(15)
 LAST_UPDATE_DATE                                                  NOT NULL DATE
 LAST_UPDATED_BY                                                   NOT NULL NUMBER(15)
 CREATION_DATE                                                     NOT NULL DATE
 CREATED_BY                                                        NOT NULL NUMBER(15)
 LAST_UPDATE_LOGIN                                                          NUMBER(15)
 TRX_NUMBER                                                        NOT NULL VARCHAR2(20)
 CUST_TRX_TYPE_ID                                                  NOT NULL NUMBER(15)
 TRX_DATE                                                          NOT NULL DATE
 SET_OF_BOOKS_ID                                                   NOT NULL NUMBER(15)
 BILL_TO_CONTACT_ID                                                         NUMBER(15)
 BATCH_ID                                                                   NUMBER(15)
 BATCH_SOURCE_ID                                                            NUMBER(15)
 REASON_CODE                                                                VARCHAR2(30)
 SOLD_TO_CUSTOMER_ID                                                        NUMBER(15)
 SOLD_TO_CONTACT_ID                                                         NUMBER(15)
 SOLD_TO_SITE_USE_ID                                                        NUMBER(15)
 BILL_TO_CUSTOMER_ID                                                        NUMBER(15)
 BILL_TO_SITE_USE_ID                                                        NUMBER(15)
 SHIP_TO_CUSTOMER_ID                                                        NUMBER(15)
 SHIP_TO_CONTACT_ID                                                         NUMBER(15)
 SHIP_TO_SITE_USE_ID                                                        NUMBER(15)
 SHIPMENT_ID                                                                NUMBER(15)
 REMIT_TO_ADDRESS_ID                                                        NUMBER(15)
 TERM_ID                                                                    NUMBER(15)
 TERM_DUE_DATE                                                              DATE
 PREVIOUS_CUSTOMER_TRX_ID                                                   NUMBER(15)
 PRIMARY_SALESREP_ID                                                        NUMBER(15)
 PRINTING_ORIGINAL_DATE                                                     DATE
 PRINTING_LAST_PRINTED                                                      DATE
 PRINTING_OPTION                                                            VARCHAR2(20)
 PRINTING_COUNT                                                             NUMBER(15)
 PRINTING_PENDING                                                           VARCHAR2(1)
 PURCHASE_ORDER                                                             VARCHAR2(50)
 PURCHASE_ORDER_REVISION                                                    VARCHAR2(50)
 PURCHASE_ORDER_DATE                                                        DATE
 CUSTOMER_REFERENCE                                                         VARCHAR2(30)
 CUSTOMER_REFERENCE_DATE                                                    DATE
 COMMENTS                                                                   VARCHAR2(1760)
 INTERNAL_NOTES                                                             VARCHAR2(240)
 EXCHANGE_RATE_TYPE                                                         VARCHAR2(30)
 EXCHANGE_DATE                                                              DATE
 EXCHANGE_RATE                                                              NUMBER
 TERRITORY_ID                                                               NUMBER(15)
 INVOICE_CURRENCY_CODE                                                      VARCHAR2(15)
 INITIAL_CUSTOMER_TRX_ID                                                    NUMBER(15)
 AGREEMENT_ID                                                               NUMBER(15)
 END_DATE_COMMITMENT                                                        DATE
 START_DATE_COMMITMENT                                                      DATE
 LAST_PRINTED_SEQUENCE_NUM                                                  NUMBER(15)
 ATTRIBUTE_CATEGORY                                                         VARCHAR2(30)
 ATTRIBUTE1                                                                 VARCHAR2(150)
 ATTRIBUTE2                                                                 VARCHAR2(150)
 ATTRIBUTE3                                                                 VARCHAR2(150)
 ATTRIBUTE4                                                                 VARCHAR2(150)
 ATTRIBUTE5                                                                 VARCHAR2(150)
 ATTRIBUTE6                                                                 VARCHAR2(150)
 ATTRIBUTE7                                                                 VARCHAR2(150)
 ATTRIBUTE8                                                                 VARCHAR2(150)
 ATTRIBUTE9                                                                 VARCHAR2(150)
 ATTRIBUTE10                                                                VARCHAR2(150)
 ORIG_SYSTEM_BATCH_NAME                                                     VARCHAR2(40)
 POST_REQUEST_ID                                                            NUMBER(15)
 REQUEST_ID                                                                 NUMBER(15)
 PROGRAM_APPLICATION_ID                                                     NUMBER(15)
 PROGRAM_ID                                                                 NUMBER(15)
 PROGRAM_UPDATE_DATE                                                        DATE
 FINANCE_CHARGES                                                            VARCHAR2(1)
 COMPLETE_FLAG                                                     NOT NULL VARCHAR2(1)
 POSTING_CONTROL_ID                                                         NUMBER(15)
 BILL_TO_ADDRESS_ID                                                         NUMBER(15)
 RA_POST_LOOP_NUMBER                                                        NUMBER(15)
 SHIP_TO_ADDRESS_ID                                                         NUMBER(15)
 CREDIT_METHOD_FOR_RULES                                                    VARCHAR2(30)
 CREDIT_METHOD_FOR_INSTALLMENTS                                             VARCHAR2(30)
 RECEIPT_METHOD_ID                                                          NUMBER(15)
 ATTRIBUTE11                                                                VARCHAR2(150)
 ATTRIBUTE12                                                                VARCHAR2(150)
 ATTRIBUTE13                                                                VARCHAR2(150)
 ATTRIBUTE14                                                                VARCHAR2(150)
 ATTRIBUTE15                                                                VARCHAR2(150)
 RELATED_CUSTOMER_TRX_ID                                                    NUMBER(15)
 INVOICING_RULE_ID                                                          NUMBER(15)
 SHIP_VIA                                                                   VARCHAR2(30)
 SHIP_DATE_ACTUAL                                                           DATE
 WAYBILL_NUMBER                                                             VARCHAR2(50)
 FOB_POINT                                                                  VARCHAR2(30)
 CUSTOMER_BANK_ACCOUNT_ID                                                   NUMBER(15)
 INTERFACE_HEADER_ATTRIBUTE1                                                VARCHAR2(150)
 INTERFACE_HEADER_ATTRIBUTE2                                                VARCHAR2(150)
 INTERFACE_HEADER_ATTRIBUTE3                                                VARCHAR2(150)
 INTERFACE_HEADER_ATTRIBUTE4                                                VARCHAR2(150)
 INTERFACE_HEADER_ATTRIBUTE5                                                VARCHAR2(150)
 INTERFACE_HEADER_ATTRIBUTE6                                                VARCHAR2(150)
 INTERFACE_HEADER_ATTRIBUTE7                                                VARCHAR2(150)
 INTERFACE_HEADER_ATTRIBUTE8                                                VARCHAR2(150)
 INTERFACE_HEADER_CONTEXT                                                   VARCHAR2(30)
 DEFAULT_USSGL_TRX_CODE_CONTEXT                                             VARCHAR2(30)
 INTERFACE_HEADER_ATTRIBUTE10                                               VARCHAR2(150)
 INTERFACE_HEADER_ATTRIBUTE11                                               VARCHAR2(150)
 INTERFACE_HEADER_ATTRIBUTE12                                               VARCHAR2(150)
 INTERFACE_HEADER_ATTRIBUTE13                                               VARCHAR2(150)
 INTERFACE_HEADER_ATTRIBUTE14                                               VARCHAR2(150)
 INTERFACE_HEADER_ATTRIBUTE15                                               VARCHAR2(150)
 INTERFACE_HEADER_ATTRIBUTE9                                                VARCHAR2(150)
 DEFAULT_USSGL_TRANSACTION_CODE                                             VARCHAR2(30)
 RECURRED_FROM_TRX_NUMBER                                                   VARCHAR2(20)
 STATUS_TRX                                                                 VARCHAR2(30)
 DOC_SEQUENCE_ID                                                            NUMBER(15)
 DOC_SEQUENCE_VALUE                                                         NUMBER(15)
 PAYING_CUSTOMER_ID                                                         NUMBER(15)
 PAYING_SITE_USE_ID                                                         NUMBER(15)
 RELATED_BATCH_SOURCE_ID                                                    NUMBER(15)
 DEFAULT_TAX_EXEMPT_FLAG                                                    VARCHAR2(1)
 CREATED_FROM                                                      NOT NULL VARCHAR2(30)
 ORG_ID                                                                     NUMBER(15)
 WH_UPDATE_DATE                                                             DATE
 GLOBAL_ATTRIBUTE1                                                          VARCHAR2(150)
 GLOBAL_ATTRIBUTE2                                                          VARCHAR2(150)
 GLOBAL_ATTRIBUTE3                                                          VARCHAR2(150)
 GLOBAL_ATTRIBUTE4                                                          VARCHAR2(150)
 GLOBAL_ATTRIBUTE5                                                          VARCHAR2(150)
 GLOBAL_ATTRIBUTE6                                                          VARCHAR2(150)
 GLOBAL_ATTRIBUTE7                                                          VARCHAR2(150)
 GLOBAL_ATTRIBUTE8                                                          VARCHAR2(150)
 GLOBAL_ATTRIBUTE9                                                          VARCHAR2(150)
 GLOBAL_ATTRIBUTE10                                                         VARCHAR2(150)
 GLOBAL_ATTRIBUTE11                                                         VARCHAR2(150)
 GLOBAL_ATTRIBUTE12                                                         VARCHAR2(150)
 GLOBAL_ATTRIBUTE13                                                         VARCHAR2(150)
 GLOBAL_ATTRIBUTE14                                                         VARCHAR2(150)
 GLOBAL_ATTRIBUTE15                                                         VARCHAR2(150)
 GLOBAL_ATTRIBUTE16                                                         VARCHAR2(150)
 GLOBAL_ATTRIBUTE17                                                         VARCHAR2(150)
 GLOBAL_ATTRIBUTE18                                                         VARCHAR2(150)
 GLOBAL_ATTRIBUTE19                                                         VARCHAR2(150)
 GLOBAL_ATTRIBUTE20                                                         VARCHAR2(150)
 GLOBAL_ATTRIBUTE21                                                         VARCHAR2(150)
 GLOBAL_ATTRIBUTE22                                                         VARCHAR2(150)
 GLOBAL_ATTRIBUTE23                                                         VARCHAR2(150)
 GLOBAL_ATTRIBUTE24                                                         VARCHAR2(150)
 GLOBAL_ATTRIBUTE25                                                         VARCHAR2(150)
 GLOBAL_ATTRIBUTE26                                                         VARCHAR2(150)
 GLOBAL_ATTRIBUTE27                                                         VARCHAR2(150)
 GLOBAL_ATTRIBUTE28                                                         VARCHAR2(150)
 GLOBAL_ATTRIBUTE29                                                         VARCHAR2(150)
 GLOBAL_ATTRIBUTE30                                                         VARCHAR2(150)
 GLOBAL_ATTRIBUTE_CATEGORY                                                  VARCHAR2(30)
 EDI_PROCESSED_FLAG                                                         VARCHAR2(1)
 EDI_PROCESSED_STATUS                                                       VARCHAR2(10)
 MRC_EXCHANGE_RATE_TYPE                                                     VARCHAR2(2000)
 MRC_EXCHANGE_DATE                                                          VARCHAR2(2000)
 MRC_EXCHANGE_RATE                                                          VARCHAR2(2000)
 PAYMENT_SERVER_ORDER_NUM                                                   VARCHAR2(80)
 APPROVAL_CODE                                                              VARCHAR2(80)
 ADDRESS_VERIFICATION_CODE                                                  VARCHAR2(80)
 OLD_TRX_NUMBER                                                             VARCHAR2(20)
 BR_AMOUNT                                                                  NUMBER
 BR_UNPAID_FLAG                                                             VARCHAR2(1)
 BR_ON_HOLD_FLAG                                                            VARCHAR2(1)
 DRAWEE_ID                                                                  NUMBER(15)
 DRAWEE_CONTACT_ID                                                          NUMBER(15)
 DRAWEE_SITE_USE_ID                                                         NUMBER(15)
 REMITTANCE_BANK_ACCOUNT_ID                                                 NUMBER(15)
 OVERRIDE_REMIT_ACCOUNT_FLAG                                                VARCHAR2(1)
 DRAWEE_BANK_ACCOUNT_ID                                                     NUMBER(15)
 SPECIAL_INSTRUCTIONS                                                       VARCHAR2(240)
 REMITTANCE_BATCH_ID                                                        NUMBER(15)
 PREPAYMENT_FLAG                                                            VARCHAR2(1)
 CT_REFERENCE                                                               VARCHAR2(150)
 CONTRACT_ID                                                                NUMBER
 BILL_TEMPLATE_ID                                                           NUMBER(15)
 REVERSED_CASH_RECEIPT_ID                                                   NUMBER(15)
 CC_ERROR_CODE                                                              VARCHAR2(80)
 CC_ERROR_TEXT                                                              VARCHAR2(255)
 CC_ERROR_FLAG                                                              VARCHAR2(1)
 UPGRADE_METHOD                                                             VARCHAR2(30)
 LEGAL_ENTITY_ID                                                            NUMBER(15)
 REMIT_BANK_ACCT_USE_ID                                                     NUMBER(15)
 PAYMENT_TRXN_EXTENSION_ID                                                  NUMBER(15)
 AX_ACCOUNTED_FLAG                                                          VARCHAR2(1)
 APPLICATION_ID                                                             NUMBER(15)
 PAYMENT_ATTRIBUTES                                                         VARCHAR2(1000)
 BILLING_DATE                                                               DATE
 INTEREST_HEADER_ID                                                         NUMBER(15)
 LATE_CHARGES_ASSESSED                                                      VARCHAR2(30)
 TRAILER_NUMBER                                                             VARCHAR2(50)

apps@DEV
SQL> select to_date('29-feb-2020','dd-mon-yyyy') - 30 new_date from daul;
select to_date('29-feb-2020','dd-mon-yyyy') - 30 new_date from daul
                                                               *
ERROR at line 1:
ORA-00942: table or view does not exist


Elapsed: 00:00:00.12
apps@DEV
SQL> select to_date('29-feb-2020','dd-mon-yyyy') - 30 new_date from dual;

NEW_DATE
--------------------
30-JAN-2020 00:00:00

Elapsed: 00:00:00.11
apps@DEV
SQL> print

 P_CUSTOMER_NBR
---------------
     2002567196


    CUSTOMER_ID
---------------
       22438432


STATEMENT_CYCLE_NME
--------------------------------------------------------------------------------------------------------------------------------
IND

apps@DEV
SQL> select * from rstewar.tst_lwx_ar_stmt_headers where send_to_cust_nbr = :p_customer_nbr;

    STMT_HDR_ID	STATEMENT_CYCLE_ID	STMT_RUN_CONC_REQ_ID	STMT_DTE            	STMT_CRNCY_CDE 	STM	   PPD_PAGE_CNT	   DTL_PAGE_CNT	  INVO_PAGE_CNT	 TOTAL_PAGE_CNT	LOGO_CDE                      	SEND_TO_CUST_ACCT_SITE_ID	SEND_TO_CUST_NBR              	SEND_TO_CUST_NME                                                                                                                                                                                                                                                                                                                                                        	SEND_TO_LINE_1_ADR                                                                                                                                                                                                                              	SEND_TO_LINE_2_ADR                                                                                                                                                                                                                              	SEND_TO_LINE_3_ADR                                                                                                                                                                                                                              	SEND_TO_LINE_4_ADR                                                                                                                                                                                                                              	SEND_TO_CITY_NME                                            	SEND_	SEND_TO_POST	SEND_TO_CNTRY_NME                                           	REP_PHONE_NBR                 	   OVER_DUE_AMT	        DUE_AMT	     TO_PAY_AMT	STMT_DUE_DTE        	    NOT_DUE_AMT	    BALANCE_AMT	MSG1_NME                                	MSG2_NME                                	SCAN_LINE_NME                                     	LW_FAX_NBR                                        	LW_EMAIL_ADR                                                                                                                                          	     CREATED_BY	CREATION_DATE       	LAST_UPDATED_BY	LAST_UPDATED_DATE   	LAST_UPDATE_LOGIN	CUST_EMAIL_ADR                                                                                                                                        	TEST_DATE           	  TEST_SEQUENCE
---------------	------------------	--------------------	--------------------	---------------	---	---------------	---------------	---------------	---------------	------------------------------	-------------------------	------------------------------	------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------	------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------	------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------	------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------	------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------	------------------------------------------------------------	-----	------------	------------------------------------------------------------	------------------------------	---------------	---------------	---------------	--------------------	---------------	---------------	----------------------------------------	----------------------------------------	--------------------------------------------------	--------------------------------------------------	------------------------------------------------------------------------------------------------------------------------------------------------------	---------------	--------------------	---------------	--------------------	-----------------	------------------------------------------------------------------------------------------------------------------------------------------------------	--------------------	---------------
        8505107	              3000	           130866396	05-MAR-2020 17:33:24	USD            	En 	              0	              1	              0	              2	RC                            	                  4719795	2002567196                    	JACOB BOYD                                                                                                                                                                                                                                                                                                                                                              	7300 Gary Street                                                                                                                                                                                                                                	                                                                                                                                                                                                                                                	                                                                                                                                                                                                                                                	                                                                                                                                                                                                                                                	Springfield                                                 	VA   	22150       	United States                                               	1-800-453-9775                	              0	         199.99	         199.99	30-MAR-2020 23:59:59	              0	         199.99	                                        	                                        	1111120025671960000199990000000000                	(615) 251-3914                                    	CustomerAccounts@LifeWay.com                                                                                                                          	          32418	05-MAR-2020 17:33:24	          32418	05-MAR-2020 17:33:24	        142960869	                                                                                                                                                      	05-MAR-2020 17:41:08	             22
        8505108	              3000	           130866437	05-MAR-2020 18:10:04	USD            	En 	              0	              1	              0	              2	RC                            	                  4719795	2002567196                    	JACOB BOYD                                                                                                                                                                                                                                                                                                                                                              	7300 Gary Street                                                                                                                                                                                                                                	                                                                                                                                                                                                                                                	                                                                                                                                                                                                                                                	                                                                                                                                                                                                                                                	Springfield                                                 	VA   	22150       	United States                                               	1-800-453-9775                	              0	         199.99	         199.99	30-MAR-2020 23:59:59	              0	         199.99	                                        	                                        	1111120025671960000199990000000000                	(615) 251-3914                                    	CustomerAccounts@LifeWay.com                                                                                                                          	          32418	05-MAR-2020 18:10:04	          32418	05-MAR-2020 18:10:04	        142960910	                                                                                                                                                      	05-MAR-2020 18:15:27	             23

Elapsed: 00:00:00.37
apps@DEV
SQL> begin 
    autono_stmt_gen_test.copy_stmt_data(
    :p_customer_nbr,
    :statement_cycle_nme,
    to_date('06-mar-2020 18:10:04','dd-mon-yyyy hh24:mi:ss') -- <<<< this should be the date pushed into the stmt_dte column...
  );
end;

.
  8  apps@DEV
SQL> select * from lwx_ar_stmt_headers where send_to_cust_nbr = :p_customer_nbr;

    STMT_HDR_ID	STATEMENT_CYCLE_ID	STMT_RUN_CONC_REQ_ID	STMT_DTE            	STMT_CRNCY_CDE 	STM	   PPD_PAGE_CNT	   DTL_PAGE_CNT	  INVO_PAGE_CNT	 TOTAL_PAGE_CNT	LOGO_CDE                      	SEND_TO_CUST_ACCT_SITE_ID	SEND_TO_CUST_NBR              	SEND_TO_CUST_NME                                                                                                                                                                                                                                                                                                                                                        	SEND_TO_LINE_1_ADR                                                                                                                                                                                                                              	SEND_TO_LINE_2_ADR                                                                                                                                                                                                                              	SEND_TO_LINE_3_ADR                                                                                                                                                                                                                              	SEND_TO_LINE_4_ADR                                                                                                                                                                                                                              	SEND_TO_CITY_NME                                            	SEND_	SEND_TO_POST	SEND_TO_CNTRY_NME                                           	REP_PHONE_NBR                 	   OVER_DUE_AMT	        DUE_AMT	     TO_PAY_AMT	STMT_DUE_DTE        	    NOT_DUE_AMT	    BALANCE_AMT	MSG1_NME                                	MSG2_NME                                	SCAN_LINE_NME                                     	LW_FAX_NBR                                        	LW_EMAIL_ADR                                                                                                                                          	     CREATED_BY	CREATION_DATE       	LAST_UPDATED_BY	LAST_UPDATED_DATE   	LAST_UPDATE_LOGIN	CUST_EMAIL_ADR
---------------	------------------	--------------------	--------------------	---------------	---	---------------	---------------	---------------	---------------	------------------------------	-------------------------	------------------------------	------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------	------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------	------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------	------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------	------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------	------------------------------------------------------------	-----	------------	------------------------------------------------------------	------------------------------	---------------	---------------	---------------	--------------------	---------------	---------------	----------------------------------------	----------------------------------------	--------------------------------------------------	--------------------------------------------------	------------------------------------------------------------------------------------------------------------------------------------------------------	---------------	--------------------	---------------	--------------------	-----------------	------------------------------------------------------------------------------------------------------------------------------------------------------
        8505109	              3000	           130867485	06-MAR-2020 10:24:00	USD            	En 	              0	              1	              0	              2	RC                            	                  4719795	2002567196                    	JACOB BOYD                                                                                                                                                                                                                                                                                                                                                              	7300 Gary Street                                                                                                                                                                                                                                	                                                                                                                                                                                                                                                	                                                                                                                                                                                                                                                	                                                                                                                                                                                                                                                	Springfield                                                 	VA   	22150       	United States                                               	1-800-453-9775                	              0	         199.99	         199.99	03-MAR-2020 23:59:59	              0	         199.99	                                        	                                        	1111120025671960000199990000000000                	(615) 251-3914                                    	CustomerAccounts@LifeWay.com                                                                                                                          	          32418	06-MAR-2020 10:24:00	          32418	06-MAR-2020 10:24:00	        142961962	

Elapsed: 00:00:00.97
apps@DEV
SQL> begin 
    autono_stmt_gen_test.copy_stmt_data(
    :p_customer_nbr,
    :statement_cycle_nme,
    to_date('06-mar-2020 10:24:00','dd-mon-yyyy hh24:mi:ss') -- <<<< this should be the date pushed into the stmt_dte column...
  );
end;

.
  8  apps@DEV
SQL> /
Copied 0 rows into tst_lwx_ar_stmt_line_details.
Copied 0 rows into tst_lwx_ar_stmt_lines.
Copied 1 rows into tst_lwx_ar_stmt_headers.

PL/SQL procedure successfully completed.

Elapsed: 00:00:00.11
apps@DEV
SQL> select * from rstewar.tst_lwx_ar_stmt_headers where send_to_cust_nbr = :p_customer_nbr;

    STMT_HDR_ID	STATEMENT_CYCLE_ID	STMT_RUN_CONC_REQ_ID	STMT_DTE            	STMT_CRNCY_CDE 	STM	   PPD_PAGE_CNT	   DTL_PAGE_CNT	  INVO_PAGE_CNT	 TOTAL_PAGE_CNT	LOGO_CDE                      	SEND_TO_CUST_ACCT_SITE_ID	SEND_TO_CUST_NBR              	SEND_TO_CUST_NME                                                                                                                                                                                                                                                                                                                                                        	SEND_TO_LINE_1_ADR                                                                                                                                                                                                                              	SEND_TO_LINE_2_ADR                                                                                                                                                                                                                              	SEND_TO_LINE_3_ADR                                                                                                                                                                                                                              	SEND_TO_LINE_4_ADR                                                                                                                                                                                                                              	SEND_TO_CITY_NME                                            	SEND_	SEND_TO_POST	SEND_TO_CNTRY_NME                                           	REP_PHONE_NBR                 	   OVER_DUE_AMT	        DUE_AMT	     TO_PAY_AMT	STMT_DUE_DTE        	    NOT_DUE_AMT	    BALANCE_AMT	MSG1_NME                                	MSG2_NME                                	SCAN_LINE_NME                                     	LW_FAX_NBR                                        	LW_EMAIL_ADR                                                                                                                                          	     CREATED_BY	CREATION_DATE       	LAST_UPDATED_BY	LAST_UPDATED_DATE   	LAST_UPDATE_LOGIN	CUST_EMAIL_ADR                                                                                                                                        	TEST_DATE           	  TEST_SEQUENCE
---------------	------------------	--------------------	--------------------	---------------	---	---------------	---------------	---------------	---------------	------------------------------	-------------------------	------------------------------	------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------	------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------	------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------	------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------	------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------	------------------------------------------------------------	-----	------------	------------------------------------------------------------	------------------------------	---------------	---------------	---------------	--------------------	---------------	---------------	----------------------------------------	----------------------------------------	--------------------------------------------------	--------------------------------------------------	------------------------------------------------------------------------------------------------------------------------------------------------------	---------------	--------------------	---------------	--------------------	-----------------	------------------------------------------------------------------------------------------------------------------------------------------------------	--------------------	---------------
        8505109	              3000	           130867485	06-MAR-2020 10:24:00	USD            	En 	              0	              1	              0	              2	RC                            	                  4719795	2002567196                    	JACOB BOYD                                                                                                                                                                                                                                                                                                                                                              	7300 Gary Street                                                                                                                                                                                                                                	                                                                                                                                                                                                                                                	                                                                                                                                                                                                                                                	                                                                                                                                                                                                                                                	Springfield                                                 	VA   	22150       	United States                                               	1-800-453-9775                	              0	         199.99	         199.99	03-MAR-2020 23:59:59	              0	         199.99	                                        	                                        	1111120025671960000199990000000000                	(615) 251-3914                                    	CustomerAccounts@LifeWay.com                                                                                                                          	          32418	06-MAR-2020 10:24:00	          32418	06-MAR-2020 10:24:00	        142961962	                                                                                                                                                      	06-MAR-2020 11:34:18	             24
        8505107	              3000	           130866396	05-MAR-2020 17:33:24	USD            	En 	              0	              1	              0	              2	RC                            	                  4719795	2002567196                    	JACOB BOYD                                                                                                                                                                                                                                                                                                                                                              	7300 Gary Street                                                                                                                                                                                                                                	                                                                                                                                                                                                                                                	                                                                                                                                                                                                                                                	                                                                                                                                                                                                                                                	Springfield                                                 	VA   	22150       	United States                                               	1-800-453-9775                	              0	         199.99	         199.99	30-MAR-2020 23:59:59	              0	         199.99	                                        	                                        	1111120025671960000199990000000000                	(615) 251-3914                                    	CustomerAccounts@LifeWay.com                                                                                                                          	          32418	05-MAR-2020 17:33:24	          32418	05-MAR-2020 17:33:24	        142960869	                                                                                                                                                      	05-MAR-2020 17:41:08	             22
        8505108	              3000	           130866437	05-MAR-2020 18:10:04	USD            	En 	              0	              1	              0	              2	RC                            	                  4719795	2002567196                    	JACOB BOYD                                                                                                                                                                                                                                                                                                                                                              	7300 Gary Street                                                                                                                                                                                                                                	                                                                                                                                                                                                                                                	                                                                                                                                                                                                                                                	                                                                                                                                                                                                                                                	Springfield                                                 	VA   	22150       	United States                                               	1-800-453-9775                	              0	         199.99	         199.99	30-MAR-2020 23:59:59	              0	         199.99	                                        	                                        	1111120025671960000199990000000000                	(615) 251-3914                                    	CustomerAccounts@LifeWay.com                                                                                                                          	          32418	05-MAR-2020 18:10:04	          32418	05-MAR-2020 18:10:04	        142960910	                                                                                                                                                      	05-MAR-2020 18:15:27	             23

Elapsed: 00:00:00.91
apps@DEV
SQL> declare 
  l_error_msg varchar2(2000); 
  l_error_code number; 
begin
  lwx_ar_delete_statements.delete_stmt(
    p_error_msg => l_error_msg,
    p_error_code => l_error_code,
    p_stmt_hdr_id => 8505109,  -- <<<< As seen in the above query against the rstewar.v_ar_stmt_invo
    p_request_id => null
  );
  dbms_output.put_line('Returned error msg:  '||substr(l_error_msg, 1,150));
  dbms_output.put_line('Returned error code:  '||to_char(l_error_code, 'tm9'));
end;

.
 14  apps@DEV
SQL> /
Returned error msg:
Returned error code:

PL/SQL procedure successfully completed.

Elapsed: 00:00:00.09
apps@DEV
SQL> commit;

Commit complete.

Elapsed: 00:00:00.08
apps@DEV
SQL> @lwx_ar_invo_stmt_print-original-we-hope

Package created.

Elapsed: 00:00:00.14

Package body created.

Elapsed: 00:00:06.62
apps@DEV
SQL> select * from lwx_ar_stmt_lines where stmt_hdr_id = 8505109;

no rows selected

Elapsed: 00:00:00.09
apps@DEV
SQL> select * from lwx_ar_stmt_headers where stmt_hdr_id = 8505109;

no rows selected

Elapsed: 00:00:00.09
apps@DEV
SQL> select * from lwx_ar_stmt_headers where send_to_cust_nbr = :p_customer_nbr;

    STMT_HDR_ID	STATEMENT_CYCLE_ID	STMT_RUN_CONC_REQ_ID	STMT_DTE            	STMT_CRNCY_CDE 	STM	   PPD_PAGE_CNT	   DTL_PAGE_CNT	  INVO_PAGE_CNT	 TOTAL_PAGE_CNT	LOGO_CDE                      	SEND_TO_CUST_ACCT_SITE_ID	SEND_TO_CUST_NBR              	SEND_TO_CUST_NME                                                                                                                                                                                                                                                                                                                                                        	SEND_TO_LINE_1_ADR                                                                                                                                                                                                                              	SEND_TO_LINE_2_ADR                                                                                                                                                                                                                              	SEND_TO_LINE_3_ADR                                                                                                                                                                                                                              	SEND_TO_LINE_4_ADR                                                                                                                                                                                                                              	SEND_TO_CITY_NME                                            	SEND_	SEND_TO_POST	SEND_TO_CNTRY_NME                                           	REP_PHONE_NBR                 	   OVER_DUE_AMT	        DUE_AMT	     TO_PAY_AMT	STMT_DUE_DTE        	    NOT_DUE_AMT	    BALANCE_AMT	MSG1_NME                                	MSG2_NME                                	SCAN_LINE_NME                                     	LW_FAX_NBR                                        	LW_EMAIL_ADR                                                                                                                                          	     CREATED_BY	CREATION_DATE       	LAST_UPDATED_BY	LAST_UPDATED_DATE   	LAST_UPDATE_LOGIN	CUST_EMAIL_ADR
---------------	------------------	--------------------	--------------------	---------------	---	---------------	---------------	---------------	---------------	------------------------------	-------------------------	------------------------------	------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------	------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------	------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------	------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------	------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------	------------------------------------------------------------	-----	------------	------------------------------------------------------------	------------------------------	---------------	---------------	---------------	--------------------	---------------	---------------	----------------------------------------	----------------------------------------	--------------------------------------------------	--------------------------------------------------	------------------------------------------------------------------------------------------------------------------------------------------------------	---------------	--------------------	---------------	--------------------	-----------------	------------------------------------------------------------------------------------------------------------------------------------------------------
        8505110	              3000	           130867584	06-MAR-2020 11:39:29	USD            	En 	              0	              1	              0	              2	RC                            	                  4719795	2002567196                    	JACOB BOYD                                                                                                                                                                                                                                                                                                                                                              	7300 Gary Street                                                                                                                                                                                                                                	                                                                                                                                                                                                                                                	                                                                                                                                                                                                                                                	                                                                                                                                                                                                                                                	Springfield                                                 	VA   	22150       	United States                                               	1-800-453-9775                	              0	         199.99	         199.99	03-MAR-2020 23:59:59	              0	         199.99	                                        	                                        	1111120025671960000199990000000000                	(615) 251-3914                                    	CustomerAccounts@LifeWay.com                                                                                                                          	          32418	06-MAR-2020 11:39:29	          32418	06-MAR-2020 11:39:29	        142962067	

Elapsed: 00:00:00.53
apps@DEV
SQL> select * from lwx_ar_stmt_lines where stmt_hdr_id = 8505110;

   STMT_LINE_ID	    STMT_HDR_ID	  STMT_LINE_NBR	I	RE	CUSTOMER_TRX_ID	CASH_RECEIPT_ID	PAYMENT_SCHEDULE_ID	       PAGE_CNT	       LINE_CNT	LOGO_CDE                      	DOC_TITLE_NME                           	REP_MSG_NME                                                 	BILL_TO_CUST_NBR              	BILL_TO_CUST_NME                                                                                                                                                                                                                                                                                                                                                        	BILL_TO_LINE_1_ADR                                                                                                                                                                                                                              	BILL_TO_LINE_2_ADR                                                                                                                                                                                                                              	BILL_TO_LINE_3_ADR                                                                                                                                                                                                                              	BILL_TO_LINE_4_ADR                                                                                                                                                                                                                              	BILL_TO_CITY_NME                                            	BILL_	BILL_TO_POST	BILL_TO_CNTRY_NME                                           	SHIP_TO_CUST_NBR              	SHIP_TO_CUST_NME                                                                                                                                                                                                                                                                                                                                                        	SHIP_TO_LINE_1_ADR                                                                                                                                                                                                                              	SHIP_TO_LINE_2_ADR                                                                                                                                                                                                                              	SHIP_TO_LINE_3_ADR                                                                                                                                                                                                                              	SHIP_TO_LINE_4_ADR                                                                                                                                                                                                                              	SHIP_TO_CITY_NME                                            	SHIP_	SHIP_TO_POST	SHIP_TO_CNTRY_NME                                           	S	TRANS_DTE           	TRANS_NBR                     	DOC_TYPE_NME                  	SLS_CHNL_NME                  	CUST_REF_NME                  	F	P	DUE_DTE             	DOC_REF_NME         	       ORIG_AMT	    OUTSTND_AMT	TERM_MSG1_NME                                                                                       	TERM_MSG2_NME                                                                                       	CUST_CONT_NME                                                                                       	CUST_CONT_PHONE_NBR                               	ORDER_DTE           	SHIP_METH_NME                                                                                       	  SUB_TOTAL_AMT	  SHIP_HNDL_AMT	        TAX_AMT	   PMT_USED_AMT	  TOTAL_DUE_AMT	MKT_MSG1_NME                                      	MKT_MSG2_NME                                      	MKT_MSG3_NME                                      	MKT_MSG4_NME                                      	     CREATED_BY	CREATION_DATE       	LAST_UPDATED_BY	LAST_UPDATE_DATE    	LAST_UPDATE_LOGIN	PURCHASE_ORDER                                    	COMMENTS
---------------	---------------	---------------	-	--	---------------	---------------	-------------------	---------------	---------------	------------------------------	----------------------------------------	------------------------------------------------------------	------------------------------	------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------	------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------	------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------	------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------	------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------	------------------------------------------------------------	-----	------------	------------------------------------------------------------	------------------------------	------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------	------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------	------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------	------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------	------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------	------------------------------------------------------------	-----	------------	------------------------------------------------------------	-	--------------------	------------------------------	------------------------------	------------------------------	------------------------------	-	-	--------------------	--------------------	---------------	---------------	----------------------------------------------------------------------------------------------------	----------------------------------------------------------------------------------------------------	----------------------------------------------------------------------------------------------------	--------------------------------------------------	--------------------	----------------------------------------------------------------------------------------------------	---------------	---------------	---------------	---------------	---------------	--------------------------------------------------	--------------------------------------------------	--------------------------------------------------	--------------------------------------------------	---------------	--------------------	---------------	--------------------	-----------------	--------------------------------------------------	--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
       41004468	        8505110	              1	Y	F3	       27880971	               	           37841087	               	               	RC                            	                                        	                                                            	                              	                                                                                                                                                                                                                                                                                                                                                                        	                                                                                                                                                                                                                                                	                                                                                                                                                                                                                                                	                                                                                                                                                                                                                                                	                                                                                                                                                                                                                                                	                                                            	     	            	                                                            	                              	                                                                                                                                                                                                                                                                                                                                                                        	                                                                                                                                                                                                                                                	                                                                                                                                                                                                                                                	                                                                                                                                                                                                                                                	                                                                                                                                                                                                                                                	                                                            	     	            	                                                            	N	04-FEB-2020 00:00:00	28619289(15347856)            	Invoice                       	SG                            	24B1-774F-0957                	 	 	04-FEB-2020 00:00:00	28619289(15347856)  	         199.99	         199.99	                                                                                                    	                                                                                                    	                                                                                                    	                                                  	                    	                                                                                                    	         199.99	              0	              0	              0	         199.99	                                                  	                                                  	                                                  	                                                  	          32418	06-MAR-2020 11:39:29	          32418	06-MAR-2020 11:39:29	        142962067	24B1-774F-0957                                    	

Elapsed: 00:00:00.67
apps@DEV
SQL> rem SO WHY DOESN'T THE AMOUNT OF 199.99 APPEAR AS AN OVERDUE AMOUNT?
apps@DEV
SQL> rem I'LL RECAPITULATE THE QUERY THE PACKAGE RUNS HERE:
apps@DEV
SQL> select sum(nvl(sl.outstnd_amt,0)) debit_amt
from lwx_ar_stmt_lines sl,
ra_customer_trx_all trx
where sl.stmt_hdr_id = 8505110
and sl.rec_type_cde = 'F3'
and sl.outstnd_amt > 0
and sl.customer_trx_id = trx.customer_trx_id(+)
and trunc(greatest(sl.due_dte, nvl(trx.creation_date, sl.due_dte))) 
      < to_date('07-feb-2020')
and (case trx.attribute5 
       when 'ET' then lwx_ar_query.get_wo_gift_card_receipt(sl.payment_schedule_id)
       when 'WO' then lwx_ar_query.get_wo_gift_card_receipt(sl.payment_schedule_id)
       when 'FC' then lwx_ar_query.get_wo_gift_card_receipt(sl.payment_schedule_id)
       else null
     end ) is null
and (   lwx_ar_invo_stmt_print.get_prepay(sl.payment_schedule_id,'N','Y') is null
     or exists (
       select 1
       from lwx_ar_stmt_lines sl2
       where sl2.stmt_hdr_id != 8505110
       and sl2.rec_type_cde = 'F3'
       and sl2.customer_trx_id = sl.customer_trx_id
     )
.

apps@DEV
SQL> /
and (   lwx_ar_invo_stmt_print.get_prepay(sl.payment_schedule_id,'N','Y') is null
                                                                          *
ERROR at line 16:
ORA-00907: missing right parenthesis


Elapsed: 00:00:00.10
apps@DEV
SQL> select sum(nvl(sl.outstnd_amt,0)) debit_amt
from lwx_ar_stmt_lines sl,
ra_customer_trx_all trx
where sl.stmt_hdr_id = 8505110
and sl.rec_type_cde = 'F3'
and sl.outstnd_amt > 0
and sl.customer_trx_id = trx.customer_trx_id(+)
and trunc(greatest(sl.due_dte, nvl(trx.creation_date, sl.due_dte))) 
      < to_date('07-feb-2020','dd-mon-yyyy')
and (case trx.attribute5 
       when 'ET' then lwx_ar_query.get_wo_gift_card_receipt(sl.payment_schedule_id)
       when 'WO' then lwx_ar_query.get_wo_gift_card_receipt(sl.payment_schedule_id)
       when 'FC' then lwx_ar_query.get_wo_gift_card_receipt(sl.payment_schedule_id)
       else null
     end ) is null
and (   lwx_ar_invo_stmt_print.get_prepay(sl.payment_schedule_id,'N','Y') is null
     or exists (
       select 1
       from lwx_ar_stmt_lines sl2
       where sl2.stmt_hdr_id != 8505110
       and sl2.rec_type_cde = 'F3'
       and sl2.customer_trx_id = sl.customer_trx_id
     )
.

apps@DEV
SQL> /
and (   lwx_ar_invo_stmt_print.get_prepay(sl.payment_schedule_id,'N','Y') is null
                                                                          *
ERROR at line 16:
ORA-00907: missing right parenthesis


Elapsed: 00:00:00.13
apps@DEV
SQL> select sum(nvl(sl.outstnd_amt,0)) debit_amt
from lwx_ar_stmt_lines sl,
ra_customer_trx_all trx
where sl.stmt_hdr_id = 8505110
and sl.rec_type_cde = 'F3'
and sl.outstnd_amt > 0
and sl.customer_trx_id = trx.customer_trx_id(+)
and trunc(greatest(sl.due_dte, nvl(trx.creation_date, sl.due_dte))) 
      < to_date('07-feb-2020','dd-mon-yyyy')
and (case trx.attribute5 
       when 'ET' then lwx_ar_query.get_wo_gift_card_receipt(sl.payment_schedule_id)
       when 'WO' then lwx_ar_query.get_wo_gift_card_receipt(sl.payment_schedule_id)
       when 'FC' then lwx_ar_query.get_wo_gift_card_receipt(sl.payment_schedule_id)
       else null
     end ) is null
and (   lwx_ar_invo_stmt_print.get_prepay(sl.payment_schedule_id,'N','Y') is null
     or exists (
       select 1
       from lwx_ar_stmt_lines sl2
       where sl2.stmt_hdr_id != 8505110
       and sl2.rec_type_cde = 'F3'
       and sl2.customer_trx_id = sl.customer_trx_id
     )
    )
.

apps@DEV
SQL> /

      DEBIT_AMT
---------------
         199.99

Elapsed: 00:00:00.16
apps@DEV
SQL> select nvl(sum(nvl(lasl2.outstnd_amt,0)), 0) credit_amt
from lwx_ar_stmt_lines lasl2
where stmt_hdr_id = 8505110
and rec_type_cde = 'F3'
and outstnd_amt < 0;


     CREDIT_AMT
---------------
              0

Elapsed: 00:00:00.12
apps@DEV
SQL> select sum(nvl(sl.outstnd_amt,0)) debit_amt
from lwx_ar_stmt_lines sl,
ra_customer_trx_all trx
where sl.stmt_hdr_id = 8505110
and sl.rec_type_cde = 'F3'
and sl.outstnd_amt > 0
and sl.customer_trx_id = trx.customer_trx_id(+)
and trunc(greatest(sl.due_dte, nvl(trx.creation_date, sl.due_dte))) 
      < to_date('07-feb-2020','dd-mon-yyyy') - 30
and (case trx.attribute5 
       when 'ET' then lwx_ar_query.get_wo_gift_card_receipt(sl.payment_schedule_id)
       when 'WO' then lwx_ar_query.get_wo_gift_card_receipt(sl.payment_schedule_id)
       when 'FC' then lwx_ar_query.get_wo_gift_card_receipt(sl.payment_schedule_id)
       else null
     end ) is null
and (   lwx_ar_invo_stmt_print.get_prepay(sl.payment_schedule_id,'N','Y') is null
     or exists (
       select 1
       from lwx_ar_stmt_lines sl2
       where sl2.stmt_hdr_id != 8505110
       and sl2.rec_type_cde = 'F3'
       and sl2.customer_trx_id = sl.customer_trx_id
     )
    )
.

apps@DEV
SQL> /

      DEBIT_AMT
---------------


Elapsed: 00:00:00.15
apps@DEV
SQL> select nvl(sum(sl.outstnd_amt),0) debit_amt
from lwx_ar_stmt_lines sl,
ra_customer_trx_all trx
where sl.stmt_hdr_id = 8505110
and sl.rec_type_cde = 'F3'
and sl.outstnd_amt > 0
and sl.customer_trx_id = trx.customer_trx_id(+)
and trunc(greatest(sl.due_dte, nvl(trx.creation_date, sl.due_dte))) 
      < to_date('07-feb-2020','dd-mon-yyyy') - 30
and (case trx.attribute5 
       when 'ET' then lwx_ar_query.get_wo_gift_card_receipt(sl.payment_schedule_id)
       when 'WO' then lwx_ar_query.get_wo_gift_card_receipt(sl.payment_schedule_id)
       when 'FC' then lwx_ar_query.get_wo_gift_card_receipt(sl.payment_schedule_id)
       else null
     end ) is null
and (   lwx_ar_invo_stmt_print.get_prepay(sl.payment_schedule_id,'N','Y') is null
     or exists (
       select 1
       from lwx_ar_stmt_lines sl2
       where sl2.stmt_hdr_id != 8505110
       and sl2.rec_type_cde = 'F3'
       and sl2.customer_trx_id = sl.customer_trx_id
     )
    )
.

apps@DEV
SQL> /

      DEBIT_AMT
---------------
              0

Elapsed: 00:00:00.13
apps@DEV
SQL> select to_date('07-feb-2020','dd-mon-yyyy') - 30 from dual;

TO_DATE('07-FEB-2020
--------------------
08-JAN-2020 00:00:00

Elapsed: 00:00:00.11
apps@DEV
SQL> select /* nvl(sum(sl.outstnd_amt),0) */ sl.outstnd_amt debit_amt
from lwx_ar_stmt_lines sl,
ra_customer_trx_all trx
where sl.stmt_hdr_id = 8505110
and sl.rec_type_cde = 'F3'
and sl.outstnd_amt > 0
and sl.customer_trx_id = trx.customer_trx_id(+)
and trunc(greatest(sl.due_dte, nvl(trx.creation_date, sl.due_dte))) 
      < to_date('07-feb-2020','dd-mon-yyyy') -- - 30
and (case trx.attribute5 
       when 'ET' then lwx_ar_query.get_wo_gift_card_receipt(sl.payment_schedule_id)
       when 'WO' then lwx_ar_query.get_wo_gift_card_receipt(sl.payment_schedule_id)
       when 'FC' then lwx_ar_query.get_wo_gift_card_receipt(sl.payment_schedule_id)
       else null
     end ) is null
and (   lwx_ar_invo_stmt_print.get_prepay(sl.payment_schedule_id,'N','Y') is null
     or exists (
       select 1
       from lwx_ar_stmt_lines sl2
       where sl2.stmt_hdr_id != 8505110
       and sl2.rec_type_cde = 'F3'
       and sl2.customer_trx_id = sl.customer_trx_id
     )
    )
.

apps@DEV
SQL> /

      DEBIT_AMT
---------------
         199.99

Elapsed: 00:00:00.14
apps@DEV
SQL> select /* nvl(sum(sl.outstnd_amt),0) */ sl.due_dte, sl.outstnd_amt debit_amt
from lwx_ar_stmt_lines sl,
ra_customer_trx_all trx
where sl.stmt_hdr_id = 8505110
and sl.rec_type_cde = 'F3'
and sl.outstnd_amt > 0
and sl.customer_trx_id = trx.customer_trx_id(+)
and trunc(greatest(sl.due_dte, nvl(trx.creation_date, sl.due_dte))) 
      < to_date('07-feb-2020','dd-mon-yyyy') -- - 30
and (case trx.attribute5 
       when 'ET' then lwx_ar_query.get_wo_gift_card_receipt(sl.payment_schedule_id)
       when 'WO' then lwx_ar_query.get_wo_gift_card_receipt(sl.payment_schedule_id)
       when 'FC' then lwx_ar_query.get_wo_gift_card_receipt(sl.payment_schedule_id)
       else null
     end ) is null
and (   lwx_ar_invo_stmt_print.get_prepay(sl.payment_schedule_id,'N','Y') is null
     or exists (
       select 1
       from lwx_ar_stmt_lines sl2
       where sl2.stmt_hdr_id != 8505110
       and sl2.rec_type_cde = 'F3'
       and sl2.customer_trx_id = sl.customer_trx_id
     )
    )
.

apps@DEV
SQL> /

DUE_DTE             	      DEBIT_AMT
--------------------	---------------
04-FEB-2020 00:00:00	         199.99

Elapsed: 00:00:00.13
apps@DEV
SQL> select to_date('07-mar-2020','dd-mon-yyyy') - 30 x from dual;

X
--------------------
06-FEB-2020 00:00:00

Elapsed: 00:00:00.11
apps@DEV
SQL> rem I'M GOING TO TRY AND RUN THE OLD CODE AGAIN WITH A STATEMENT AS OF DATE OF 07-MAR-2020.
apps@DEV
SQL> rem THE HOPE IS THAT (to_date('07-mar-2020','dd-mon-yyyy') - 30) == to_date('06-feb-2020','dd-mon-yyyy') 
apps@DEV
SQL> rem WILL SATISFY THE PREDICATE sl.due_dte < (to_date('07-mar-2020','dd-mon-yyyy') - 30) IN THE 
apps@DEV
SQL> rem QUERYING FOR THE "OVERDUE" AMOUNTS AND THUS SHOW HOW THE OLD CODE MIGHT "MISBEHAVE."
apps@DEV
SQL> rem I MUST DELETE THE EXISTING STATEMENT DATA AND START OVER:
apps@DEV
SQL> declare 
  l_error_msg varchar2(2000); 
  l_error_code number; 
begin
  lwx_ar_delete_statements.delete_stmt(
    p_error_msg => l_error_msg,
    p_error_code => l_error_code,
    p_stmt_hdr_id => 8505110,  -- <<<< As seen in the above query against the rstewar.v_ar_stmt_invo
    p_request_id => null
  );
  dbms_output.put_line('Returned error msg:  '||substr(l_error_msg, 1,150));
  dbms_output.put_line('Returned error code:  '||to_char(l_error_code, 'tm9'));
end;

/
 14  Returned error msg:
Returned error code:

PL/SQL procedure successfully completed.

Elapsed: 00:00:00.11
apps@DEV
SQL> rem NOW I'LL TRY TO GENERATE ANOTHER STATEMENT, THIS TIME WITH THE AS OF DATE SET TO 07-MAR-2020.
apps@DEV
SQL> commit;

Commit complete.

Elapsed: 00:00:00.07
apps@DEV
SQL> disco
Disconnected from Oracle Database 11g Enterprise Edition Release 11.2.0.3.0 - 64bit Production
With the Partitioning, Automatic Storage Management, OLAP and Data Mining options
apps@DEV
SQL> exit

Process SQL finished

