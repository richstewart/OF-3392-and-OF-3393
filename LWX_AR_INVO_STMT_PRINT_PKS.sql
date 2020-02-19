-- -*- indent-tabs-mode: nil tab-width: 4 -*-
CREATE OR REPLACE PACKAGE LWX_AR_INVO_STMT_PRINT AS

--- ***************************************************************************************************************
---$Id: LWX_AR_INVO_STMT_PRINT_PKS.sql,v 1.36 2018/07/25 21:02:04 gwright Exp $
---
---  Program Description     :  
---         This Package contains Consolidated statement generation program and Invoice
---          selection program. The Consolidated Statement generation program will generate
---          the data file needed by the Heidelberg Printer software.
---          The Invoice Selection Program will select the appropriate invoice to be sent
---          to the Oracle AR BPA for the actual Invoice Printing.
---
--- Parameters Used         :  
---         errbuf          
---          retcode         
---          p_statement_cycle_nme   
---                  
---  Development and Maintenance History:
---  -------------------------------------
---  DATE         AUTHOR                   DESCRIPTION
---  ----------   ------------------------ ---------------------------------------------------------
---  20-DEC-2005  S Saravana Bhavan, BCT   Initial Creation
---  2006-04-27   Jude Lam, TITAN          Added a new function called LWX_GET_FREIGHT_AMT to get total freight
---                                           cost based on the line item.
---  2006-06-07   Jude Lam, TITAN          Added a new function called LWX_GET_ITEM_XREF to get the main item 
---                                           cross reference based on the item id.
---                                        Added a new function called LWX_CALC_DISCOUNT that will return the discount
---                                           percent by calculating the discount amount based on unit selling price
---                                           and unit list price.
---  2006-06-12   Jude Lam, TITAN          Added a new function called LWX_Get_Order_Date to pull in the order date.
---  2006-06-12   Jude Lam, TITAN          Added a new function called LWX_Get_Order_QTY to pull in the total ordered qty.
---  2006-06-20   Jude Lam, TITAN          Added a new function called LWX_Get_Total_weight to calculate the total weight
---                                           of the invoice.
---  2006-09-05   Jude Lam, TITAN          Added statement as of date and debug flag to be the parameters for the Generate_Con_Stmt.
---                                        Added a global varialbe g_debug_flag for debug mode support.
---  2006-09-08   Jude Lam, TITAN          Update the Generate_Con_Stmt parameter for p_stmt_as_of_date to be VARCHAR2 character.
---  2006-09-26   Jude Lam, TITAN          Added two new parameter to the Invoice_Selection program for performance reason.
---  2006-10-11   Lee Neumann, TITAN       Fixed the declare of the description field to work with Translated description.
---  2006-12-26   Greg Wright              Parameters were added to Lwx_AR_Build_F1_Type_Rec so that bill-to information
---                                        could be passed to it from Generate_Con_Stmt.
---  2007-01-03   Greg Wright              Added the parameter p_cust_acct_site_id to Lwx_AR_Build_F1_Type_Rec so that it
---                                        could be passed from Generate_Con_Stmt.
---  2008-07-07   Greg Wright              Added PAYMENT_TYPE_CODE to v_openitem_cur_rec_type so we would have the 
---                                        information to prevent credit card invoices from being consolidated
---  2008-11-25   Greg Wright              Added p_reference_number as third parameter to Lwx_Get_Check_Digit.
---
---  2009-11-12   Jason McCleskey          P-1640 - Addition of get_prepay function to handle modifications
---                                          to accomodate different rules for prepayment handling
---                                        Modified cust and open item recs to avoid multiples requeries of data in procedures
---  2010-08-02   Jason Mccleskey          P-2174/Story 836 - Accounting Service Cleanup - Setup global constant
---                                          for prepay days to be referenced by views and in prep for future changes
---  2010-08-19   Greg Wright              P-2201 SLC 2852, temporarily set gn_prepay_window to 5 for testing.
---  2010-10-14   Greg Wright              P-2201 SLC 2852, changing gn_prepay_window to 105.
---  2011-04-16   Greg Wright              P-2039 SLC 3031, per Yeager, had to modify pragma statements to accomodate
---                                        updating the new package variable g_ItemForFreight.
---  2011-06-01   Greg Wright              Reverting back to 1.20 version for now for lifeway.com testing.
---  2011-10-14   Jason McCleskey          P-2039 - Invoice Selection Performance
---  2012-09-06   Greg Wright              P-2890 - Added CUST_EMAIL_ADR to v_customer_cur_rec_type.
---  2013-05-08   Greg Wright              P-3076 - Update v_openitem_cur_rec_type to contain true
---                                        purchase_order and comments values for excel statements.
---  2016-03-29   Greg Wright              OF-2558 Correct update of lwx_ar_stmt_lines.partial_pmt_ind
---                                        and create function for handling badly formed email addresses.
---  2016-11-17   Greg Wright              Added check_xml_display so it could be accessed globally.
---  2017-04-26   Greg Wright              OF-2592 Add invoices to statement PDF.
---  2017-04-26   Greg Wright              OF-2763 Fix access of contact information for statement PDFs.
---  2017-05-04   Greg Wright              Changes made to speed up queries using global associative arrays
---                                        and result caching.
---  2017-05-10   Greg Wright              Set up separate associative array for prepaid
---  2018-02-19   Greg Wright              OF-2981 - Provide use tax message for invoices.
---  2018-02-21   Greg Wright              OF-2981 - Responded to code review by adding lwx_split_line
---                                        as a global function.
---  2018-04-11  Greg Wright               OF-2934 - Provide the ability to receive a formatted address with
---                                        the addressee appended to the front.
--- 2018-07-24   Greg Wright               OF-3086 - Accomodate Multiple party sites with same location ID.
---  2020-02-18   Rich Stewart             OF-3393 Change use of due dates in statement generation:
---                                        delay the due date of payments by the amount by which the difference
---                                        between the statement date and preceding/last statement date exceeds 30
---                                        days.  I.e., when the statement date and preceding/last statement date
---                                        are between 30 and 40 days apart, then delay the due date by the amount
---                                          "statement date" - ("preceding/last statement date" + "30 days")
---                                        This delay/adjustment amount is added to the line-item due-date when
---                                        comparing it to the "statement date" wherever the program is choosing line-item
---                                        amounts to add to the "overdue amount."
---                                        This v_due_date_adjustment is a package-level global variable defined here.
--- ***************************************************************************************************************

   -- Declaration of Record Type for the Cursors

   -- Global Data Record Type
   
   v_last_stmt_date_global	LWX_AR_STMT_HEADERS.STMT_DTE%TYPE;
   v_statement_date_global	AR_STATEMENT_CYCLE_DATES.STATEMENT_DATE%TYPE;
   g_debug_mode             VARCHAR2(1);

   -- OF-3392 more global state needed in order to control adjustment
   -- to the due-date:
   v_due_date_adjustment number := 0;  -- default to 0

   -- Single Invoice XML Global Values
   v_xml_inv_element            clob;
   v_xml_inv_body               clob;
   v_xml_inv_finished           clob;
   v_xml_inv_first_item         number;
   v_xml_inv_page_cnt           number;
   v_xml_inv_line_cnt           number;   

   -- Prepayments receive special consideration for 105 days 
   -- After that they are then treated as normal items
   gn_prepay_window         CONSTANT NUMBER := 105;
   
   -- Associative array used in xml process for invoice detail
   v_last_stmt_line_id NUMBER(22);
   TYPE stmt_line_dtl_id IS TABLE OF NUMBER  -- Associative array type
     INDEX BY VARCHAR2(64);                  --  indexed by string
   row_stmt_line_dtl_id  stmt_line_dtl_id;  

   -- Associative array used in xml process for detail
   v_last_stmt_hdr_id         NUMBER(22);
   TYPE stmt_line_id IS TABLE OF NUMBER  -- Associative array type
     INDEX BY VARCHAR2(64);                  --  indexed by string
   row_stmt_line_id  stmt_line_id;  

   -- Associative array used in xml process for prepaid lines
   v_last_stmt_hdr_id_prepaid NUMBER(22);
   TYPE stmt_line_id_ppd IS TABLE OF NUMBER  -- Associative array type
     INDEX BY VARCHAR2(64);                  --  indexed by string
   row_stmt_line_id_ppd  stmt_line_id_ppd;  

   -- Customer Cursor Type
   
   TYPE v_customer_cur_rec_type IS RECORD
   (
     STATEMENT_CYCLE_ID		AR_CUSTOMER_PROFILES_V.STATEMENT_CYCLE_ID%TYPE,
     CUSTOMER_PROFILE_ID	AR_CUSTOMER_PROFILES_V.CUSTOMER_PROFILE_ID%TYPE,
     COLLECTOR_ID		AR_CUSTOMER_PROFILES_V.COLLECTOR_ID%TYPE,
     SITE_USE_ID		AR_CUSTOMER_PROFILES_V.SITE_USE_ID%TYPE,
     STATEMENT_CYCLE_NAME	AR_CUSTOMER_PROFILES_V.STATEMENT_CYCLE_NAME%TYPE,	
     CUSTOMER_ID		LWX_AR_CUSTOMERS_V.CUSTOMER_ID%TYPE,
     CUSTOMER_NUMBER		LWX_AR_CUSTOMERS_V.CUSTOMER_NUMBER%TYPE,
     CUSTOMER_NAME		LWX_AR_CUSTOMERS_V.CUSTOMER_NAME%TYPE,
     PARTY_ID			LWX_AR_CUSTOMERS_V.PARTY_ID%TYPE,
     LANGUAGE			LWX_AR_CUSTOMERS_V.LANGUAGE%TYPE,
     ATTRIBUTE1			LWX_AR_CUSTOMERS_V.ATTRIBUTE1%TYPE,
     SALES_CHANNEL_CODE LWX_AR_CUSTOMERS_V.SALES_CHANNEL_CODE%TYPE,
     HDR_LOGO_CODE      FND_LOOKUP_VALUES.ATTRIBUTE3%TYPE,
     LINE_LOGO_CODE     FND_LOOKUP_VALUES.ATTRIBUTE3%TYPE,
     STMT_MSG1          LWX_AR_CUSTOMERS_V.ATTRIBUTE6%TYPE,
     STMT_MSG2          LWX_AR_CUSTOMERS_V.ATTRIBUTE7%TYPE,
     CUST_EMAIL_ADR     LWX_AR_CUSTOMERS_V.ATTRIBUTE12%TYPE
   );
   
   -- Open Item Cursor Type
   
   TYPE v_openitem_cur_rec_type IS RECORD
   (
     CUSTOMER_TRX_ID		AR_PAYMENT_SCHEDULES.CUSTOMER_TRX_ID%TYPE,
     TRX_NUMBER			AR_PAYMENT_SCHEDULES.TRX_NUMBER%TYPE,
     TRX_DATE			AR_PAYMENT_SCHEDULES.TRX_DATE%TYPE,
     CASH_RECEIPT_ID		AR_PAYMENT_SCHEDULES.CASH_RECEIPT_ID%TYPE,	
     PAYMENT_SCHEDULE_ID	AR_PAYMENT_SCHEDULES.PAYMENT_SCHEDULE_ID%TYPE,	
     CLASS			AR_PAYMENT_SCHEDULES.CLASS%TYPE,
     AMOUNT_DUE_ORIGINAL	AR_PAYMENT_SCHEDULES.AMOUNT_DUE_ORIGINAL%TYPE,	
     AMOUNT_DUE_REMAINING	AR_PAYMENT_SCHEDULES.AMOUNT_DUE_REMAINING%TYPE,
     DUE_DATE			AR_PAYMENT_SCHEDULES.DUE_DATE%TYPE,
     TERM_ID			AR_PAYMENT_SCHEDULES.TERM_ID%TYPE,
     ATTRIBUTE3			RA_CUSTOMER_TRX.ATTRIBUTE3%TYPE,
     ATTRIBUTE4			RA_CUSTOMER_TRX.ATTRIBUTE4%TYPE,
     ATTRIBUTE5			RA_CUSTOMER_TRX.ATTRIBUTE5%TYPE,
     ATTRIBUTE6			RA_CUSTOMER_TRX.ATTRIBUTE6%TYPE,
     ATTRIBUTE7			RA_CUSTOMER_TRX.ATTRIBUTE7%TYPE,
     DEFAULT_PRINTING_OPTION	RA_CUST_TRX_TYPES.DEFAULT_PRINTING_OPTION%TYPE,
     TYPE			RA_CUST_TRX_TYPES.TYPE%TYPE,
     PAYMENT_TYPE_CODE AR_RECEIPT_METHODS.PAYMENT_TYPE_CODE%TYPE,
     PURCHASE_ORDER		RA_CUSTOMER_TRX.PURCHASE_ORDER%TYPE,
     DOC_TYPE_NME       FND_LOOKUP_VALUES_VL.MEANING%TYPE,
     TRUE_PURCHASE_ORDER RA_CUSTOMER_TRX.PURCHASE_ORDER%TYPE,
     TRUE_COMMENTS RA_CUSTOMER_TRX.COMMENTS%TYPE
   );
   
   -- Transaction Line Detail Cursor Type
   
   TYPE v_trx_line_dtl_cur_rec_type IS RECORD
   (
     REASON_CODE           RA_CUSTOMER_TRX_LINES.REASON_CODE%TYPE,
     CUSTOMER_TRX_LINE_ID  RA_CUSTOMER_TRX_LINES.CUSTOMER_TRX_LINE_ID%TYPE,
     QUANTITY_ORDERED      RA_CUSTOMER_TRX_LINES.QUANTITY_ORDERED%TYPE,
     QUANTITY_INVOICED     RA_CUSTOMER_TRX_LINES.QUANTITY_INVOICED%TYPE,
     INVENTORY_ITEM_ID     RA_CUSTOMER_TRX_LINES.INVENTORY_ITEM_ID%TYPE,
     UNIT_SELLING_PRICE    RA_CUSTOMER_TRX_LINES.UNIT_SELLING_PRICE%TYPE,
     UNIT_STANDARD_PRICE   RA_CUSTOMER_TRX_LINES.UNIT_STANDARD_PRICE%TYPE,
     EXTENDED_AMOUNT       RA_CUSTOMER_TRX_LINES.EXTENDED_AMOUNT%TYPE,
     DESCRIPTION           RA_CUSTOMER_TRX_LINES.TRANSLATED_DESCRIPTION%TYPE
   );

   v_stmt_header_id             LWX_AR_STMT_HEADERS.STMT_HDR_ID%TYPE;  
   v_stmt_line_id               LWX_AR_STMT_LINES.STMT_LINE_ID%TYPE;   
   
   PROCEDURE Get_Bill_To_Contact_Info(p_bill_to_customer_id IN NUMBER,
                                      p_cust_cont_phone_nbr IN OUT VARCHAR2,
                                      p_cust_cont_nme       IN OUT VARCHAR2,
                                      p_customer_trx_id     IN NUMBER,
                                      p_retcode             IN OUT NUMBER);
   
   PROCEDURE Generate_Con_Stmt( errbuf OUT VARCHAR2
                               ,retcode OUT NUMBER
                               ,p_statement_cycle_nme IN VARCHAR2
                               ,p_customer_nbr        IN VARCHAR2
                               ,p_stmt_as_of_date     IN VARCHAR2
                               ,p_debug_flag          IN VARCHAR2);

   PROCEDURE Lwx_AR_Build_F1_Type_Rec(p_customer_cur_rec     IN V_CUSTOMER_CUR_REC_TYPE
                                     ,p_stmt_header_id       IN OUT NUMBER
                                     ,p_customer_address_1   IN HZ_LOCATIONS.ADDRESS1%TYPE
                                     ,p_customer_address_2   IN HZ_LOCATIONS.ADDRESS2%TYPE
                                     ,p_customer_address_3   IN HZ_LOCATIONS.ADDRESS3%TYPE
                                     ,p_customer_address_4   IN HZ_LOCATIONS.ADDRESS4%TYPE
                                     ,p_customer_city        IN HZ_LOCATIONS.CITY%TYPE
                                     ,p_customer_state       IN HZ_LOCATIONS.STATE%TYPE
                                     ,p_customer_postal_code IN HZ_LOCATIONS.POSTAL_CODE%TYPE
                                     ,p_customer_country     IN FND_TERRITORIES_VL.TERRITORY_SHORT_NAME%TYPE
                                     ,p_cust_acct_site_id    HZ_CUST_ACCT_SITES.CUST_ACCT_SITE_ID%TYPE
                                     ,retcode            IN OUT NUMBER);

   PROCEDURE Lwx_AR_Build_F2_Type_Rec(p_stmt_line_cnt IN NUMBER
   				     ,p_customer_cur_rec IN V_CUSTOMER_CUR_REC_TYPE
   				     ,p_openitem_cur_rec IN V_OPENITEM_CUR_REC_TYPE
   				     ,retcode OUT NUMBER);

   PROCEDURE Lwx_AR_Build_F3_Type_Rec(p_stmt_line_cnt IN NUMBER
   				     ,p_customer_cur_rec IN V_CUSTOMER_CUR_REC_TYPE
   				     ,p_openitem_cur_rec IN V_OPENITEM_CUR_REC_TYPE
   				     ,retcode OUT NUMBER);

   PROCEDURE Lwx_AR_Build_F4_Type_Rec(p_stmt_line_cnt IN NUMBER
   				     ,p_customer_cur_rec IN V_CUSTOMER_CUR_REC_TYPE
   				     ,p_openitem_cur_rec IN V_OPENITEM_CUR_REC_TYPE
   				     ,retcode OUT NUMBER);

   PROCEDURE Lwx_AR_Build_Line_Details(p_line_desc_flag IN VARCHAR2
   			                              ,p_line_type_cde IN VARCHAR2
                                      ,p_trx_line_dtl_cnt IN OUT PLS_INTEGER
                                      ,p_openitem_cur_rec IN V_OPENITEM_CUR_REC_TYPE
                                      ,p_trx_line_dtl_cur_rec IN V_TRX_LINE_DTL_CUR_REC_TYPE
                                      ,retcode OUT NUMBER);

   PROCEDURE Lwx_AR_Build_Line_Details_XML(p_line_desc_flag IN VARCHAR2
   			                                  ,p_line_type_cde IN VARCHAR2
                                          ,p_trx_line_dtl_cnt IN OUT PLS_INTEGER
                                          ,p_openitem_cur_rec IN V_OPENITEM_CUR_REC_TYPE
                                          ,p_trx_line_dtl_cur_rec IN V_TRX_LINE_DTL_CUR_REC_TYPE
                                          ,retcode OUT NUMBER);

   FUNCTION lwx_Item_Row       (P_Stmt_Line_Id     IN lwx_ar_stmt_lines.stmt_line_id%TYPE
                               ,P_Stmt_Line_Dtl_Id IN lwx_ar_stmt_line_details.stmt_line_dtl_id%TYPE)
                               RETURN NUMBER RESULT_CACHE;

   FUNCTION lwx_Detail_Row     (P_Stmt_Hdr_Id      IN lwx_ar_stmt_headers.stmt_hdr_Id%TYPE
                               ,P_Stmt_Line_Id     IN lwx_ar_stmt_lines.stmt_line_id%TYPE)
                               RETURN NUMBER RESULT_CACHE;

   FUNCTION lwx_Prepaid_Row    (P_Stmt_Hdr_Id      IN lwx_ar_stmt_headers.stmt_hdr_Id%TYPE
                               ,P_Stmt_Line_Id     IN lwx_ar_stmt_lines.stmt_line_id%TYPE)
                               RETURN NUMBER RESULT_CACHE;

   FUNCTION Lwx_STMT_Scanned_Line_Logic(p_account_number IN VARCHAR2
   			               ,p_amount_to_pay IN NUMBER
   			               ,retcode OUT NUMBER) RETURN VARCHAR2;
   		   	       
   FUNCTION Lwx_Get_Check_Digit( p_check_digit_constant IN VARCHAR2
                                ,p_account_number       IN VARCHAR2
                                ,p_payment_amt          IN VARCHAR2
                                ,p_reference_number     IN VARCHAR2) RETURN NUMBER;

   PROCEDURE Lwx_Data_File_Phase(retcode OUT NUMBER);

   PROCEDURE Invoice_Selection( errbuf  OUT VARCHAR2
                               ,retcode OUT NUMBER
                               ,p_trx_start_date IN VARCHAR2
                               ,p_trx_end_date IN VARCHAR2
                               ,p_debug_flag IN VARCHAR2);
   			      
   FUNCTION Lwx_INV_Scanned_Line_Logic( p_account_number IN VARCHAR2
                    		       ,p_amount_to_pay IN NUMBER
                                       ,p_trx_number IN VARCHAR2) RETURN VARCHAR2;   			      

   FUNCTION Lwx_Get_Freight_Amt(p_customer_trx_id IN NUMBER) RETURN NUMBER;

   FUNCTION Lwx_Get_Line_Amt(p_customer_trx_id IN NUMBER) RETURN NUMBER;

   FUNCTION Lwx_Get_Item_Xref(p_item_id IN NUMBER) RETURN VARCHAR2;

   FUNCTION Lwx_Calc_Discount( p_unit_selling_price IN NUMBER
                              ,p_unit_list_price IN NUMBER
                              ,p_line_type IN VARCHAR2
                              ,p_item_id IN NUMBER) RETURN VARCHAR2;

   FUNCTION Lwx_Get_Order_Date( p_customer_trx_id IN NUMBER
                               ,p_intfc_header_context IN VARCHAR2
                               ,p_intfc_header_attr1 IN VARCHAR2) RETURN DATE;

   FUNCTION Lwx_Get_Order_Qty( p_customer_trx_id IN NUMBER
                              ,p_intfc_line_context IN VARCHAR2
                              ,p_so_line IN VARCHAR2
                              ,p_intfc_line_attr6 IN VARCHAR2
                              ,p_customer_trx_line_id IN NUMBER
                              ,p_line_type IN VARCHAR2) RETURN NUMBER;

   FUNCTION Lwx_Get_Intl_Line_Desc( p_customer_trx_line_id IN NUMBER
                                   ,p_line_type IN VARCHAR2
                                   ,p_intfc_line_context IN VARCHAR2
                                   ,p_inventory_item_id IN NUMBER
                                   ,p_so_line IN VARCHAR2
                                   ,p_qty IN NUMBER) RETURN VARCHAR2;

   FUNCTION Lwx_Get_Total_Weight( p_customer_trx_id IN NUMBER
                                 ,p_intfc_header_context IN VARCHAR2) RETURN VARCHAR2;

  --- ***************************************************************************************************************
  --- Function Lwx_Get_Use_Tax_Message
  --- Description:
  ---   This is a utility function that will provide a use tax message based on the state code.
  ---   The state codes that require this message are set up in the lookup under Common Lookups
  ---   called LWX_AR_USE_TAX_MESSAGE. If no message is set up for the input state code it returns
  ---   NULL.
  ---
  --- Development History
  --- --------------------
  ---  Date         Name                     Description
  --- ------------  -----------------------  ---------------------------------------------------------------------
  ---  2018-02-19   Greg Wright              OF-2981 - Provide use tax message for invoices.
  --- ***************************************************************************************************************

   FUNCTION LWX_Get_Use_Tax_Message(p_state_code IN VARCHAR2) RETURN VARCHAR2;                               
                                 
   FUNCTION check_xml_display( p_customer_trx_line_id IN NUMBER) RETURN NUMBER;                                 
                                 
  --- ***************************************************************************************************************
  --- Function:   get_prepay
  --- Function Description:
  ---     Determine if an item is either a prepay (Cash with Order) receipt or an invoice
  ---      that has a prepay receipt applied to it.  Return the Payment_Schedule_Id of the item
  ---      being checked if it is prepay.   Else returns NULL
  ---
  ---     Parameters Used:  
  ---       pn_paysched_id   - Unique payment_schedule_id of the item to be check
  ---       pv_check_window  - Y or N.  Include the number of days window in the check?
  ---       pv_check_debits  - Y or N.  Include query for debit items in the check?
  ---
  ---     RETURN - Payment_Schedule_id if item is prepay related - else null
  ---
  ---  Development and Maintenance History:
  ---  ------------------------------------
  ---  DATE              AUTHOR                      DESCRIPTION 
  ---  ----------        ------------------------    ----------------------------------------------------------- 
  ---  2009-11-12        Jason McCleskey             Initial Creation - Consolidate prepay logic into 1 place
  --- ***************************************************************************************************************
   FUNCTION get_prepay ( pn_paysched_id   NUMBER
                                ,pv_check_window  VARCHAR2
                                ,pv_check_debits  VARCHAR2
                               )  RETURN NUMBER;
   PRAGMA RESTRICT_REFERENCES (get_prepay,WNDS);

  --- ***************************************************************************************************************
  --- Function:   get_prepay_window
  --- Function Description:
  ---     Return the window/number of days used in determining if an item needs special consideration
  ---       because it is a prepayment 
  ---
  ---    RETURN - the value of the gn_prepay_window constant
  ---
  ---  Development and Maintenance History:
  ---  ------------------------------------
  ---  DATE              AUTHOR                      DESCRIPTION 
  ---  ----------        ------------------------    ----------------------------------------------------------- 
  ---  2010-08-02        Jason McCleskey             P-2174/Story 836 - Accounting Services Cleanup - Globalized 
  ---                                                  prepay window for use in views and future changes
  --- ***************************************************************************************************************
   FUNCTION get_prepay_window RETURN NUMBER;
   PRAGMA RESTRICT_REFERENCES (get_prepay_window,WNDS);


  --- ***************************************************************************************************************
  --- Function:   edi_print
  --- Description:  Check EDI Test vs Prod status to determine if we can print invoice
  ---
  ---    RETURN - Y - Print invoice
  ---             N - Do not print invoice
  ---
  ---  Development and Maintenance History:
  ---  ------------------------------------
  ---  DATE              AUTHOR                      DESCRIPTION 
  ---  ----------        ------------------------    ----------------------------------------------------------- 
  ---  2011-10-14        Jason McCleskey             P-2039 - Invoice Selection Performance 
  --- ***************************************************************************************************************
   FUNCTION edi_print ( pn_header_id     NUMBER
                       ,pv_document      VARCHAR2) 
    RETURN VARCHAR2;   
   PRAGMA RESTRICT_REFERENCES (edi_print,WNDS);
   
  --- ***************************************************************************************************************
  --- Function:   get_statement_xml
  --- Description:  Builds an XML document (CLOB) the contains all necessary fields for printing a statement
  ---               Primary use of this is by BI Publisher to generate an individual account statement
  ---
  ---    RETURN - XML Document in CLOB format
  ---
  ---  Development and Maintenance History:
  ---  ------------------------------------
  ---  DATE              AUTHOR                      DESCRIPTION 
  ---  ----------        ------------------------    ----------------------------------------------------------- 
  ---  2016-01-09        Greg Wright                 OF-325 - Move Statement Archive off of Samson
  ---  2016-01-22        Jason McCleskey             OF-325 - Used Greg's script to create sql query to pull data
  --- ***************************************************************************************************************
   FUNCTION get_statement_xml
            (pv_account_number  VARCHAR2,
             pd_statement_date  DATE
             ) 
     RETURN CLOB;     

  --- ***************************************************************************************************************
  --- Function:   get_statement_xml
  --- Description:  Used as a pass through to overloaded function (above) from Java OAF pages to avoid adding a bunch
  ---               of additional date manipulation in the java layer where it was already dealing with strings
  ---
  ---    RETURN - XML Document in CLOB format
  ---
  ---  Development and Maintenance History:
  ---  ------------------------------------
  ---  DATE              AUTHOR                      DESCRIPTION 
  ---  ----------        ------------------------    ----------------------------------------------------------- 
  ---  2016-01-22        Jason McCleskey             OF-325 - Used Greg's script to create sql query to pull data
  --- ***************************************************************************************************************
   FUNCTION get_statement_xml
            (pv_account_number  VARCHAR2,
             pv_statement_date  VARCHAR2  -- Format - 31-JAN-16 or 31-JAN-2016
             ) 
     RETURN CLOB;     

   FUNCTION get_invoice_xml
            (pv_customer_trx_id NUMBER
             ) 
     RETURN CLOB;     

  --- ***************************************************************************************************************
  --- Function:     LWX_Email_Invoice
  --- Description:  Evaluate the Order Management Email Address and the Customer Email Address in 
  ---               in order to determine whether the first, the second, or neither is acceptable.
  ---
  ---    RETURN - Acceptable email address or NULL
  ---
  ---  Development and Maintenance History:
  ---  ------------------------------------
  ---  DATE              AUTHOR                      DESCRIPTION 
  ---  ----------        ------------------------    ----------------------------------------------------------- 
  ---  2016-03-29        Greg Wright                 OF-2558 - Added to the issue.
  --- ***************************************************************************************************************

   FUNCTION LWX_Email_Invoice 
            (pv_om_email   VARCHAR2,
             pv_cust_email VARCHAR2
            ) 
     RETURN VARCHAR2;
   
  --- ***************************************************************************************************************
  --- Function lwx_split_line
  --- Description:
  ---   This is a utility function that provides a way to split the use tax message into up to 4
  ---   sections of 50 or fewer characters without dividing words. It returns the number of sections.
  ---   It will not be called if the use tax message is null.
  ---
  --- Parameters:
  ---   str          Input use tax message
  ---   str1         Output first section
  ---   str2         Output second section
  ---   str3         Output third section
  ---   str4         Output fourth section
  ---
  --- Development History
  --- --------------------
  ---  Date         Name                     Description
  --- ------------  -----------------------  ------------------------------------------------------------------------
  ---  2018-02-21   Greg Wright              OF-2981 - Provide use tax message for invoices.
  --- ***************************************************************************************************************
   FUNCTION lwx_split_line (str IN varchar2
                           ,str1 OUT VARCHAR2
                           ,str2 OUT VARCHAR2
                           ,str3 OUT VARCHAR2
                           ,str4 OUT VARCHAR2)
     RETURN NUMBER;

  --- ***************************************************************************************************************
  --- Function lwx_fmt_addr_with_addressee
  --- Description:
  ---   This is a utility function that calls the seeded HZ_FORMAT_PUB.format_address function, which returns
  ---   a formatted address, and then this function sticks addressee on the front, provided address lines 3 and 4 are 
  ---   not used.
  ---
  --- Parameters:
  ---   NUMBER       Location ID.
  ---
  --- Development History
  --- --------------------
  ---  Date         Name                     Description
  --- ------------  -----------------------  ------------------------------------------------------------------------
  ---  2018-04-11   Greg Wright              OF-2934 - Provide use tax message for invoices.
  ---  2018-07-24   Greg Wright              OF-3086 - Accomodate Multiple party sites with same location ID.
  --- ***************************************************************************************************************

   FUNCTION lwx_fmt_addr_with_addressee(p_location_id			IN NUMBER,
                                        p_party_site_id   IN NUMBER)
     RETURN VARCHAR2;
     
END LWX_AR_INVO_STMT_PRINT;
/
