CREATE OR REPLACE PACKAGE BODY lwx_ar_invo_stmt_print AS
  --- ***************************************************************************************************************
  ---$Id: LWX_AR_INVO_STMT_PRINT_PKB.sql,v 1.117 2019/01/25 23:19:02 gwright Exp $
  ---
  ---  Program Description   :  This Package contains Consolidated statement generation program and Invoice
  ---                           selection program.
  ---                           The Consolidated Statement generation program will generate
  ---                           the data file needed by the Heidelberg Printer software.
  ---                           The Invoice Selection Program will select the appropriate invoice to be sent
  ---                           to the Oracle AR BPA for the actual Invoice Printing.
  ---
  ---  Parameters Used       :  errbuf
  ---                           retcode
  ---                           p_statement_cycle_nme
  ---
  ---  Development and Maintenance History:
  ---  -------------------------------------
  ---  DATE         AUTHOR                   DESCRIPTION
  ---  ----------   ------------------------ ---------------------------------------------------------
  ---  20-DEC-2005  S Saravana Bhavan, BCT   Initial Creation
  ---  06-MAR-2006  Jude Lam, TITAN          Updated for Maximum Date query to add NVL() and put in debug message for log file.
  ---  14-MAR-2006  Rajmohan K, BCT          Added debug message for log file
  ---  2006-04-25   Jude Lam, TITAN          Added the initialization of variable in the declaration section.
  ---                                        Updated the logic in generating address info. in the Lwx_Data_file_Phase routine.
  ---                                        Redo the Freight section to use the Profile Option item.
  ---                                        Perform varous clean up on processing logic.
  ---  2006-05-01   Jude Lam, TITAN          Continue to perform various issues identified by Greg Wright's testing.
  ---  2006-05-02   Jude Lam, TITAN          Continue to perform various issues identified by Greg Wright's testing.
  ---  2006-05-03   Jude Lam, TITAN          Rewrite the Prepayment section (F2).
  ---  2006-05-04   Jude Lam, TITAN          Updated on the F2 counter.
  ---  2006-05-05   Jude Lam, TITAN          Perform various issue resolution fixes.
  ---  2006-05-08   Jude Lam, TITAN          Update Lwx_AR_Build_F1_Type_Rec so that if the customer does not have sales channel
  ---                                           code, it will not error out for pulling the statement.
  ---  2006-05-17   Jude Lam, TITAN          Update the Lwx_Data_File_Phase to include the consideration of the incl_cur_stmt_ind
  ---                                           flag.
  ---                                        Update the Lwx_Ar_build_F2, F3, F4 procedure on the logic to determine the
  ---                                           incl_cur_stmt_ind field.
  ---                                        Update Generate_Con_Stmt to get the first 30 characters from the PO field
  ---                                           or the Customer Comment field if the PO field is blank.
  ---  2006-05-18   Jude Lam, TITAN          Update Lwx_Ar_Build_Line_Details so that the original list price is
  ---                                           inserted into the selling price column instead of unit selling price.
  ---  2006-05-19   Jude Lam, TITAN          Update the Generate_Con_Stmt section where it calculates the total amount.
  ---                                        Update Lwx_Ar_Build_F1_Type_Rec on the query to put in the collector id into
  ---                                           the v_process_stage message.
  ---  2006-05-23   Jude Lam, TITAN          Update the program to include any open items that has only one installment
  ---                                           to be included in the statement file.
  ---  2006-06-05   Jude Lam, TITAN          Updated the Lwx_Ar_Build_Line_Details for the query that retrieve cross
  ---                                           reference.
  ---  2006-06-07   Jude Lam, TITAN          Added the Lwx_Get_Item_Xref function.
  ---                                        Updated the Lwx_Ar_Build_Line_Details to put in zero if the discount amt
  ---                                           is less than zero.
  ---                                        Added the Lwx_Calc_Discount function.
  ---  2006-06-07   Jude Lam, TITAN          Added the population of the COMMENTS field from ar_cash_receipts_all for
  ---                                           Customer Reference field in Lwx_Ar_Build_F3_Type_Rec and Lwx_Ar_Build_F4_Type_Rec.
  ---  2006-06-09   Jude Lam, TITAN          Updated the Lwx_Ar_Build_Line_Details to address the divided by zero issue.
  ---  2006-06-12   Jude Lam, TITAN          Updated the Lwx_Get_Item_XRef to not to return the Cross Reference Type.
  ---                                        Added a new function called Lwx_Get_Order_Date.
  ---                                        Added a new function called Lwx_Get_Order_Qty.
  ---  2006-06-13   Jude Lam, TITAN          Added the Lwx_Get_Intl_Line_Desc function for international description.
  ---                                        Updated the Lwx_Get_Freight_Amt and Lwx_Get_Line_Amt to consider the
  ---                                           special charges.
  ---  2006-06-14   R. Warner - TITAN        Removed commented-out code in preparation for migration to TEST.
  ---  2006-06-20   Jude Lam, TITAN          Added a new function called LWX_Get_Total_weight to calculate the total weight
  ---                                           of the invoice.
  ---  2006-06-20   Jude Lam, TITAN          Updated the Lwx_Ar_Build_F4_Type function to consider the difference
  ---                                           between regular shipping and handling versus those special charges.
  ---                                        Updated the Lwx_Data_file_Phase to consider the difference between regular
  ---                                           shipping and handling versus those special charges.
  ---  2006-06-28   Jude Lam, TITAN          Updated the LWX_Get_Total_Weight to ignore any non-shippable item as well
  ---                                           as line that does not have weight and shipping freight item.
  ---  2006-07-17   Jude Lam, TITAN          Updated the Lwx_Get_Total_Weight function's main query.
  ---  2006-07-18   Jude Lam, TITAN          Updated the LWX_Data_File_Phase to format the date to MM-DD-YY for F3-1-3 field.
  ---  2006-07-20   Jude Lam, TITAN          Updated the Generate_Con_Stmt to modify the V_DUE_AMT logic.
  ---  2006-07-25   Jude Lam, TITAN          Updated the Lwx_Data_file_Phase to format the date to MM-DD-YY for F2-1-4 field.
  ---  2006-08-24   Jude Lam, TITAN          Updated the LWX_Ar_Build_Line_Detail's query on getting the store information.
  ---  2006-08-25   Jude Lam, TITAN          Updated the Generate_Con_Stmt main query for open items to include close item
  ---                                           that are within the current statement cycle.
  ---  2006-08-30   Jude Lam, TITAN          Updated the Generate_Con_Stmt query for open item to add the time portion.
  ---                                        Updated the Prepayment section to delete F3 record if there is any.
  ---  2006-08-31   Jude Lam, TITAN          Updated for a new definition of Prepayment.  Only those that are linked to
  ---                                           Receipt Method of PM - Cash W/Order will be considered to be Prepayment.
  ---  2006-09-05   Jude Lam, TITAN          Updated the Generate_Con_Stmt to add Statement as of date and debug flag as
  ---                                           parameters.
  ---                                        Added a new Debug_Msg routine to spool debug message.
  ---                                        Updated every module to use the Debug_Msg.
  ---                                        Added the check for taxable or not for the current line detail to put in the *.
  ---  2006-09-06   Jude Lam, TITAN          Updated the Generate_Con_Stmt to replace LWXARINV_JDA to JDA_ORA_AR_INVOICES
  ---                                        Updated the Generate_Con_Stmt to only print once for each open item on
  ---                                           credit memo DO NOT PAY lines.
  ---                                        Updated the Generate_Con_Stmt to ignore the dummy line that is linked to a tax
  ---                                           tax line for interface and conversion.
  ---  2006-09-06   Jude Lam, TITAN          Updated the LWx_Data_File_Phase to show Store name on F3-2-4 data field.
  ---  2006-09-08   Jude Lam, TITAN          Updated the Generate_Con_Stmt so that if the customer has a negative balance,
  ---                                           statement will still be generated.
  ---  2006-09-08   Jude Lam, TITAN          Update the Generate_Con_Stmt parameter for p_stmt_as_of_date to be VARCHAR2 character.
  ---  2006-09-13   Jude Lam, TITAN          Updated the Lwx_Get_Total_Weight to say the word Total Weight in Spanish
  ---                                           when the Logo code is in Spanish.
  ---  2006-09-21   Jude Lam, TITAN          Updated the Invoice_Selection procedure's main query for performance update.
  ---                                        Updated the Invoice_Selection procedure for more debug messages.
  ---                                        Updated the Invoice_Selection procedure to cover Credit and Debit Memo EDI
  ---                                           type as well.
  ---                                        Updated Generate_Con_Stmt to ignore statement date for credit items when
  ---                                           calculate over due and due amount.
  ---  2006-09-26   Jude Lam, TITAN          Updated the Lwx_Data_File_Phase to copy the same store name and sales channel
  ---                                           logic from the F3 section to the F2 section.
  ---  2006-09-26   Jude Lam, TITAN          Added two new parameter to the Invoice_Selection program for performance reason.
  ---  2006-09-27   Jude Lam, TITAN          Additional fixes to Invoice_Selection procedure on number of arguments during the concurrent program submission.
  ---                                        Added additional debug messages in Invoice_Selection procedure.
  ---  2006-10-12   Lee Neumann, TITAN       Tweaked the SQL to assist with Performance
  ---  2006-10-14   Lee Neumann, TITAN       Update for performance of SQL.  Removed view and did direct table hit.
  ---  2006-10-17   Jude Lam, TITAN          Update queries in Generate_Con_Stmt for performance tuning.
  ---  2006-10-17   Jude Lam, TITAN          Update to remove the | and chr(10) and chr(13) characters in the translated_description
  ---                                           field in the main cursor in Generate_Con_Stmt.
  ---  2006-10-23   Jude Lam, TITAN          Updated the Lwx_Stmt_Scanned_line and Lwx_Inv_scanned_Line_logic to
  ---                                           keep any trailing zeros after the decimal is trimmed off.
  ---  2006-10-23   Jude Lam, TITAN          Updated the Generate_Con_Stmt program where it calculates the open balance
  ---                                           to include any open receipts.
  ---  2006-10-24   Jude Lam, TITAN          Updated the query that calculates balance according to code review updates.
  ---  2006-10-27   Jude Lam, TITAN          Updated the Lwx_Inv_Scanned_line_logic for a minor bug fix on using the wrong
  ---                                           variable when formatting the amount.
  ---  2006-11-07   Greg Wright              Performance enhancement.
  ---  2006-11-13   Greg Wright              Adjusted pointer in Lwx_Get_Check_Digit for calculation check digit.
  ---  2006-11-30   Greg Wright              For Spanish statement, do non-case-sensitive check for
  ---                                        language set to 'Es'. Previously checked for 'ES'.
  ---  2006-12-08   Darrin Fuqua             Added 'WC' and 'WF' to Select statement for temporary version.
  ---  2006-12-11   Darrin Fuqua             Excluded selection criteria other than 'WC' and 'WF' for temporary version.
  ---  2006-12-12   Darrin Fuqua             Commented printing_pending flag to run 'WC' and 'WF'.
  ---  2006-12-20   Darrin Fuqua             Uncommented code for special 'WC' and 'WF' runs.
  ---  2006-12-21   Greg Wright              This version includes the following changes:
  ---                                        (1) The validation of bill-to sites was moved to Generate_Con_Stmt from
  ---                                            Lwx_AR_Build_F1_Type_Rec. The procedure, Generate_Con_Stmt, calls
  ---                                            the procedure Lwx_AR_Build_F1_Type_rec after a decision has been made to
  ---                                            generate a statement for the customer. The code has been changed to that if
  ---                                            if a bill-to is set up incorrectly, the customer can be skipped, a message logged,
  ---                                            and the program continue rather than abort.
  ---                                        (2) The number of parameters required for Lwx_AR_Build_F1_Type_Rec was increased,
  ---                                            such that now the 1.10 version of the spec or higher is required.
  ---                                        (3) The calculation of statement balance will no longer include transactions and
  ---                                            payments that have closed in the last 30 days. The impact on prepaid was noted.
  ---                                        (4) In order to have a statement generated, the absolute value of the balance must
  ---                                            now be five dollars or more. Previously, the minimum balance came from a customer
  ---                                            setup, and sometimes these were incorrectly set to zero.
  ---  2006-12-26   Greg Wright              The field v_good_sites was changed to a boolean value, and states of a million dollars
  ---                                        or more were accomodated.
  ---  2007-01-03   Greg Wright              This version includes the following changes:
  ---                                        (1) Prevented updates to print flags except when invoices are consolidated.
  ---                                        (2) Effiency was added by not checking for bill-to information unless the statement
  ---                                            is at least >= 5 or <= -5.
  ---                                        (3) The statement program will no longer die if the address status is blank.
  ---                                        (4) Suppress pipe characters in cust_ref_nme.
  ---  2007-01-10   Greg Wright              Two changes:
  ---                                        (1) Suppress statement and warn when the length of the state code exceeds five bytes.
  ---                                        (2) No longer test against wave codes for non-consolidated invoices.
  ---
  ---  2007-02-08   Greg Wright              Changes to statement process:
  ---                                        (1) Correct calculation of balance due.
  ---                                        Changes to the nonconsolidated invoicing process:
  ---                                        (1) Omit JDA
  ---                                        (2) Compare date parameter to creation_date, not trx_date
  ---                                        (3) Change flag for parent program so closed invoices will print.
  ---                                        (4) Trap "TOO_MANY_ROWS" error in ece-tp-details.
  ---
  ---  2007-02-16   Greg Wright              (1) Add efficiencies identified by Jeff Yeager.
  ---                                        (2) Use (print_last_printed is null) to indicate unprinted invoices rather than
  ---                                            (printing_pending = 'Y'), since credits do not update printing_pending.
  ---                                        (3) Make sure site_use_id is null in AR_CUSTOMER_PROFILES_V.
  ---  2007-04-26   Greg Wright              Accept only the first two characters from state fields.
  ---  2007-06-13   Greg Wright              Patches from 1.53, 1.54, and 1.55 were backed out.
  ---  15-JUN-2007  I. Balodis, TITAN        Created temp. table to write output file of invoices created.
  ---  2007-08-13   David Howard, TITAN      Removed the Global statement date query line from the payment schedule query to allow
  ---                                          future dates to print in the invoice print program.
  ---  18-SEP-2007  Greg Wright              Modified v_openitem_cur to accomodate the null sales channel in late fees.
  ---  2007-11-07   Mike Miller              Issue P-745 (Dev ID D024), added 2 lines to address problem
  ---                                        involving invoices with contact having 2 phones causing
  ---                                        abend.  Change applied in procedure Get_Bill_To_Contact_Info.
  ---  2008-02-19   Greg Wright              Add and modify hints for 10G.
  ---                                        Correct page count variables.
  ---  2008-03-06   David Howard       Payments print the method printed name in the Point of sale field for payments
  ---  2008-03-20   David Howard       Correct the calculation of past_due_amt by using the greater of creation_date
  ---              and due_date
  ---  2008-03-20   David Howard       Removed carrage return and line feed characters from the statements comments
  ---              field.
  ---  2008-03-20   David Howard       Removed prepayments and cash with order trans from the calculation of min statement
  ---              amt.
  ---  2008-04-04   Greg Wright        Modifications made in response to code review.
  ---  2008-07-07   Greg Wright        Modified in conjunction with SLC 2209 to allow web invoices to be sent via nnnnn.
  ---                                  Also modified to not die when a postal code exceeds 12 characters.
  ---  2008-09-18   Greg Wright        Send on-line Worship orders 'WO' by email.
  ---  2008-10-31   Greg Wright        (1) Prevent write transfers from blowing up statements when doc-ref > 20 characters.
  ---                                  (2) Count correct number of lines for invoices.
  ---  2008-11-25   Greg Wright        (1) Change scan line for statements and invoices for Bank of America.
  ---                                  (2) Map CE statement logo to RC.
  ---                                  (3) Map OI statement logo to BH.
  ---  2009-02-19   Greg Wright        Modify references to payment type 'PM - Cash W/Order' to use 'instr' function.
  ---                                  This is necessary because there are two payment types with that name.
  ---  2009-06-13   Greg Wright        Make the following modifications for eGiving.
  ---                                  (1) Mail any invoices with 'EG' sales channel.
  ---                                  (2) Do not consolidate invoices with 'EG' sales channel.
  ---                                  (3) Put trx_number on the subject line of emailed invoices.
  ---                                  (4) Always mail AOL invoices--never email.
  ---  2009-11-12   Jason McCleskey    P-1640 - Modifications for Cash with Order items.  Move from F2 to F3
  ---                                       section after 45 days and change over due and due calcs accordingly
  ---                                  P-1719 - Modify AOL to allow email and Roadrunner to force to Mail
  ---                                  Modifications made for performance and proceduralization to avoid duplication
  ---                                    and requerying of data multiple times
  --- 2009-12-11   Jason McCleskey     P-1720 - Invoice Selection Program hanging due to infinite loop
  --- 2010-02-24   Jason McCleskey     P-1725 - Do not consolidate Prospect Services (Lexinet) invoices (Sales Channel = 'PS')
  --- 2010-08-02   Jason McCleskey     P-2174/Story 836 - Accounting Services Cleanup - Globalized
  ---                                       prepay window for use in views and future changes
  --- 2010-11-17   Greg Wright         P-2231 Do not mail/email invoices with rejected credit cards.
  --- 2010-12-09   Greg Wright         P-2231 Do not mail/email credit card invoices where the remaining amount
  ---                                       due is greater than zero.
  --- 2011-02-01   Greg Wright         P-2472 Allow credit card invoices with sales channels of LC, MS, or LZ
  ---                                       to be sent by email.
  --- 2011-04-16   Jeff Yeager         Trying to improve BPA performance by making little changes.
  --- 2011-06-01   Greg Wright         Reverting back to 1.82 version for now for lifeway.com testing.
  --- 2011-07-08   Greg Wright         P-2577 Print individual JDA Inv if customer has BH collector.
  --- 2011-08-04   Greg Wright         P-2502 Derive transaction logo from ra_customer_trx_all.attribute3 when possible.
  --- 2011-09-16   Greg Wright         P-2708 Suppress unprintable characters in comments and purchase order.
  --- 2011-09-29   Greg Wright         P-2723 Accomodate total line for page counts in detail section.
  --- 2011-10-14   Jason McCleskey     P-2039 - Invoice Selection Performance
  --- 2011-11-28   Greg Wright         P-2776 Suppress invoices for WO sales channels with gift cards.
  --- 2012-01-13   Greg Wright         1 - P-2832, Modified to name the invoice extract file based on the start time of 
  ---                                      LWX AR Auto Invoicing Set, when started by that request set.
  ---                                  2 - Prevent consolidation of invoices when language='Es'.
  ---                                  3 - Only call get_wo_gift_card_receipt for 'WO' sales channel. 
  --- 2012-01-25   Greg Wright         Per code review, made parent request id lookup a function.
  --- 2012-09-06   Greg Wright         P-2890 - Added logic for new cust_email_adr column on 
  ---                                  lwx.lwx_ar_stmt_headers table.
  --- 2013-03-20   Greg Wright         P-3197 Do not generate a statement before 25 days have passed
  ---                                  since the last statement.
  --- 2013-06-01   Greg Wright         P-3076 Accomodate CSV Statements.
  --- 2014-02-03   Darrin Fuqua        R12: Profile OE_INVENTORY_ITEM_FOR_FREIGHT does not exist in R12, so changed
  ---                                  code to get system parameter of same name.
  --- 2014-03-17   Greg Wright         R12: Refixed the consolidated statement code and replaced remaining 
  ---                                  references to OE_INVENTORY_ITEM_FOR_FREIGHT with gn_freight_item.
  --- 2014-06-11   Greg Wright         R12: P-3708 BPA went from (parent and child process) to grandchild.
  --- 2015-01-10   Greg Wriight        P-3963 Extreme Tickets, includes the following already applied in PROD:
  ---                                  - P-3825 Accomodate loss of duplex printing for stmt detail pages.
  ---                                  - P-3926 Extreme Tix
  ---                                  - P-3925 Discount Display
  --- 2015-07-07   Greg Wright         P-4158, ERU-433 Reference email_web_invoices function.
  --- 2016-01-22   Jason McCleskey     OF-325 - Move Statement Archive off of Samson
  --- 2016-03-29   Greg Wright         OF-2558 Correct update of lwx_ar_stmt_lines.partial_pmt_ind
  ---                                  and create function for handling badly formed email addresses.
  --- 2016-09-26   Greg Wright         OF-2616 Modify the tax and freight routines to accomodate WMU invoices
  ---                                  in the BPA setup.
  --- 2016-11-17   Greg Wright         Added XML code for consolidated invoices.
  --- 2017-04-26   Greg Wright         OF-2592 Add invoices to statement PDF.
  --- 2017-04-26   Greg Wright         OF-2763 Fix access of contact information for statement PDFs.
  --- 2017-05-04   Greg Wright         Changes made to speed up queries using global associative arrays
  ---                                  and result caching.
  --- 2017-05-10   Greg Wright         OF-2592 More changes from 2nd code review. Also:
  ---                                  - Set up separate associative array for prepaid.
  ---                                  - Trans Date and Order Date must be MM-DD-YYYY.
  --- 2017-05-24   Greg Wright         Add capability for single XML to PDF invoices.
  --- 2017-05-29   Greg Wright         Fix bugs in PDF invoices found in TEST.
  --- 2017-07-14   Greg Wright         OF-2877 PROD-only XML problem - increase variable size.
  --- 2017-08-02   Greg Wright         OF-2893 Detail tax line should be suppressed
  --- 2017-08-15   Greg Wright         OF-2899 Flash Commerce
  --- 2018-02-19   Greg Wright         OF-2981 Added Use Tax Message function Lwx_Get_Use_Tax_Message.
  --- 2018-04-11   Greg Wright         OF-2934 - Provide the ability to receive a formatted address with
  ---                                  the addressee appended to the front.
  --- 2018-04-12   Greg Wright         OF-3035 Refine the calling of lwx_use_tax_message.
  --- 2018-05-11   Greg Wright         OF-3043 - Break up 'Address' into individual lines.
  --- 2018-06-14   Greg Wright         OF-3004 - As part of moving the statement process to DNI, 
  ---                                            they need an indicator for foreign statement addresses.
  --- 2018-07-24   Greg Wright         OF-3086 - Accomodate Multiple party sites with same location ID.
  --- 2019-01-25   Greg Wright         OF-3186 expect two programs for each BPA call instead of three.
  --- 2020-02-18   Rich Stewart        OF-3392 Changes to due-date handling, affecting procedure Generate_Con_Stmt
  ---                                  and procedure Lwx_Ar_Build_F3_Type_Rec.
  --- 2020-02-18   Rich Stewart        OF-3393 changes to take addresses with missing geocodes into account
  ---                                          within the get_site_info procedure, called from the Generate_Con_Stmt,
  ---                                          and avoid causing the Generate_Con_Stmt to generate unnecessary warnings.
  --- ***************************************************************************************************************

  gn_freight_item  NUMBER := TO_NUMBER(lwx_fnd_query.get_sys_param_value('OE_INVENTORY_ITEM_FOR_FREIGHT'));
  gcv_newline      CONSTANT VARCHAR2(2) := chr(13)||chr(10);
  
  --- ***************************************************************************************************************
  --- Procedure:   log
  --- Procedure Description:
  ---   Local logging procedure to simplify calls to fnd_file.  
  ---
  ---     Parameters Used:
  ---       PV_WHICH      - o  - Write to Output File Only
  ---                       lo - Write to Log and Output Files
  ---                       l  - Write to Log File Only  (Default)
  ---                       d  - Debug message to log file
  ---       PV_MESSAGE    - Message to be logged
  ---       PV_TIMESTAMP  - n - No - Do not put timestamp on message
  ---                       b - Beginning - Add timestamp at beginning of message
  ---                       e - End - Add timestamp at end of message
  ---
  ---  Development and Maintenance History:
  ---  ------------------------------------
  ---  DATE        AUTHOR                  DESCRIPTION
  ---  ----------  --------------------    -----------------------------------------------------------
  ---  2011-10-14   Jason McCleskey          P-2039 - Invoice Selection Performance 
  --- ***************************************************************************************************************
  PROCEDURE log( pv_which     VARCHAR2
                ,pv_message   VARCHAR2
                ,pv_timestamp VARCHAR2 DEFAULT 'N') IS
    lv_message VARCHAR2(4000);
  BEGIN

    -- Put timestamp on message if needed
    IF (lower(pv_timestamp) = 'b') THEN
      lv_message := to_char(sysdate, 'hh24:mi:ss') || ' ' || pv_message;
    ELSIF (lower(pv_timestamp) = 'e') THEN
      lv_message := pv_message || ' ' || to_char(sysdate, 'hh24:mi:ss');
    ELSE
      lv_message := pv_message;
    END IF;

    -- Put in Both Log and Output files
    IF (lower(pv_which) = 'lo') THEN
      fnd_file.put_line(fnd_file.output, lv_message);
    -- Put in the Output File Only
    ELSIF (lower(pv_which) = 'o') THEN
      fnd_file.put_line(fnd_file.output, lv_message);
    -- Debug Message - Put in the LogFile if debug is turned on
    ELSIF (lower(pv_which) = 'd') THEN
      IF g_debug_mode = 'Y' THEN
         fnd_file.put_line(fnd_file.log, lv_message);
      END IF;
    -- Put in the Log file Only (Default)
    ELSE
      fnd_file.put_line(fnd_file.log,lv_message);
    END IF;
  END log;

  --- ***************************************************************************************************************
  --- Procedure: App Error 
  --- Description:
  ---   Utility function for formatting error messages and raising application error.
  ---     Standardizes look/feel of messages and makes it a lot cleaner in the core 
  ---     processing code without multi-line chunks of error messages cluttering it up
  ---
  ---     Parameters Used:
  ---       PN_ERRNUM   - Error Number to be used for the RAISE
  ---       PV_HEADER   - Header of the message     
  ---       PV_STAGE    - Stage where the error occurred at
  ---       PV_CODE     - Error code that generated the message (often sqlcode)
  ---       PV_MESSAGE  - Error Message (often sqlerrm)
  ---
  ---  Development and Maintenance History:
  ---  ------------------------------------
  ---  DATE        AUTHOR                  DESCRIPTION
  ---  ----------  --------------------    -----------------------------------------------------------
  ---  2011-10-14   Jason McCleskey          P-2039 - Invoice Selection Performance 
  --- ***************************************************************************************************************
  PROCEDURE app_error (pn_errnum          NUMBER,
                       pv_header_message  VARCHAR2,
                       pv_stage           VARCHAR2 DEFAULT NULL,
                       pv_error_code      VARCHAR2 DEFAULT NULL,
                       pv_detail_message  VARCHAR2 DEFAULT NULL) IS
  BEGIN
    RAISE_APPLICATION_ERROR
          (pn_errnum,' ***>> '
                     ||pv_header_message||gcv_newline
                     ||case 
                         when pv_stage is null then null
                         else 'v_process_stage: '||pv_stage||gcv_newline
                       end
                     ||case
                         when pv_error_code is null then null
                         else 'Error Code:    '||pv_error_code||gcv_newline
                       end
                     ||case 
                         when pv_detail_message is null then null
                         else 'Error Message: '||pv_detail_message||gcv_newline
                       end);
  END app_error;

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
  FUNCTION get_prepay_window RETURN NUMBER IS
  BEGIN
    RETURN gn_prepay_window;  
  END get_prepay_window;
  
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
  ---  2010-08-02        Jason McCleskey             P-2174/Story 836 - Accounting Services Cleanup - Globalized 
  ---                                                  prepay window for use in views and future changes
  ---                                                  Modified cursor to be based on tables instead of views
  ---                                                  since queries from external systems won't have org context
  --- ***************************************************************************************************************
  FUNCTION get_prepay ( pn_paysched_id    NUMBER
                       ,pv_check_window   VARCHAR2
                       ,pv_check_debits   VARCHAR2
                      ) RETURN NUMBER IS

    n_return              NUMBER;

    
    CURSOR cur_prepay IS
    -- Prepayment (and associated invoices) only receive special treatment for 45 days
    -- Prepayment Receipts section 
    SELECT DISTINCT PS.PAYMENT_SCHEDULE_ID
      FROM ar.ar_payment_schedules_all        ps, 
           ar.ar_receivable_applications_all  app,
           ar.ar_cash_receipts_all            rec,
           ar.ar_receipt_methods              meth
     WHERE ps.payment_schedule_id = pn_paysched_id         
       AND ps.class = 'PMT'
       AND ps.cash_receipt_id = app.cash_receipt_id
       AND app.applied_payment_schedule_id = -7
       AND ps.cash_receipt_id = rec.cash_receipt_id
       AND rec.receipt_method_id = meth.receipt_method_id
       AND instr(upper(meth.name),'PM - CASH W/ORDER') > 0
       AND rec.receipt_date >= decode(pv_check_window,
                                        'Y',trunc(sysdate)-get_prepay_window,
                                        rec.receipt_date)
    UNION ALL
    -- Debit Items which have Prepayments applied to them 
    SELECT DISTINCT APP.PAYMENT_SCHEDULE_ID
    FROM ar.ar_receivable_applications_all  app,
         ar.ar_payment_schedules_all        ps,
         ar.ar_cash_receipts_all            rec,
         ar.ar_receipt_methods              meth
    WHERE pv_check_debits = 'Y'
      AND ps.payment_schedule_id = pn_paysched_id 
      AND ps.customer_trx_id is not null
      AND ps.payment_schedule_id = app.applied_payment_schedule_id 
      AND nvl(app.applied_payment_schedule_id, -999) > 0 
      AND app.cash_receipt_id = rec.cash_receipt_id 
      AND rec.receipt_method_id = meth.receipt_method_id
      AND instr(upper(meth.name),'PM - CASH W/ORDER') > 0 
      AND ps.creation_date >= decode(pv_check_window,
                                       'Y',trunc(sysdate)-get_prepay_window,
                                       ps.creation_date);
                                        
  BEGIN

    OPEN cur_prepay;
    FETCH cur_prepay INTO n_return;
    IF (cur_prepay%NOTFOUND) THEN
        n_return := null;
    END IF;
    CLOSE cur_prepay;
    RETURN n_return;       
  END get_prepay;                     

  --- ***************************************************************************************************************
  --- Function: get_trx_logo
  --- Function Description: Compare customer logo and transaction logo to determine display logo.
  --- Parameters:
  ---   p_trx_logo  - the logo value from ra_customer_trx_all.attribute3.
  ---   p_cust_logo - the logo code used at the customer level.
  ---
  ---  Development and Maintenance History:
  ---  ------------------------------------
  ---  DATE              AUTHOR                      DESCRIPTION 
  ---  ----------        ------------------------    ----------------------------------------------------------- 
  ---  2011-08-05        Greg Wright                 Creation.
  --- ***************************************************************************************************************
  FUNCTION get_trx_logo  (p_trx_logo IN VARCHAR2,
                          p_cust_logo  IN VARCHAR2) RETURN VARCHAR2
  IS
  trx_logo VARCHAR2(30);
  BEGIN
    IF p_trx_logo IS NULL THEN
      trx_logo:= p_cust_logo;
    ELSE
      IF p_trx_logo = 'CRSP' THEN
        trx_logo:= 'CRD';
      ELSE
        IF SUBSTR(p_trx_logo,3,2) = 'SP' THEN 
          trx_logo:= SUBSTR(p_trx_logo,1,2);
        ELSE
          trx_logo:= p_trx_logo;
        END IF;
      END IF;
    END IF;
    RETURN trx_logo;
  END Get_Trx_Logo;

  --- ***************************************************************************************************************
  --- Function:   get_site_info
  --- Function Description:
  ---     Retrieve the Site Info/Address needed
  ---
  ---     Parameters Used:  
  ---       pn_cust_id      - Customer Id to be queried
  ---       pn_party_id     - Party Id of customer to be queired
  ---       pb_good_site    - Boolean flag - True if successfully found site else False
  ---       pv_address1     - Address Line 1 to be returned
  ---       pv_address2     - Address Line 2 to be returned
  ---       pv_address3     - Address Line 3 to be returned
  ---       pv_address4     - Address Line 4 to be returned
  ---       pv_city         - City to be returned
  ---       pv_state        - State to be returned
  ---       pv_postal_code  - Postal Code to be returned
  ---       pv_country      - Country to be returned
  ---
  ---  Development and Maintenance History:
  ---  ------------------------------------
  ---  DATE              AUTHOR                      DESCRIPTION 
  ---  ----------        ------------------------    -----------------------------------------------------------
  ---  2009-11-18        Jason McCleskey             Initial Creation - Streamline Site Logic and improve readability
  ---  2020-02-18        Rich Stewart                OF-3393 changes to take addresses with missing geocodes into account
  ---                                                and avoid causing the consuming program to generate unnecessary warnings.
  --- ***************************************************************************************************************
  PROCEDURE get_site_info(pn_cust_id                NUMBER,
                          pn_party_id               NUMBER,
                          pb_good_site          OUT BOOLEAN,
                          pv_address1           OUT HZ_LOCATIONS.ADDRESS1%TYPE,
                          pv_address2           OUT HZ_LOCATIONS.ADDRESS2%TYPE,
                          pv_address3           OUT HZ_LOCATIONS.ADDRESS3%TYPE,
                          pv_address4           OUT HZ_LOCATIONS.ADDRESS4%TYPE,
                          pv_city               OUT HZ_LOCATIONS.CITY%TYPE,
                          pv_state              OUT HZ_LOCATIONS.STATE%TYPE,
                          pv_postal_code        OUT HZ_LOCATIONS.POSTAL_CODE%TYPE,
                          pv_country            OUT FND_TERRITORIES_VL.TERRITORY_SHORT_NAME%TYPE,
                          pn_cust_acct_site_id  OUT NUMBER
                          ) IS
    -- OF-3393 used herein to indicate whether or not querying detects missing
    -- geocode data
    l_good_geocode number;
    --
    CURSOR cur_sites (cn_cust_id   NUMBER, 
                      cn_party_id  NUMBER) IS
    SELECT loc.ADDRESS1,
           loc.ADDRESS2,
           loc.ADDRESS3,
           loc.ADDRESS4,
           loc.CITY,
           substr(loc.STATE,1,2),
           substr(loc.POSTAL_CODE,1,12),
           terr.TERRITORY_SHORT_NAME,
           --
           nvl(loc_assign.location_id,0) good_geocode
      FROM AR_LOOKUPS         l_cat,
           FND_TERRITORIES_VL terr,
           FND_LANGUAGES_VL   lang,
           HZ_CUST_ACCT_SITES addr,
           HZ_PARTY_SITES     party_site,
           HZ_CUST_SITE_USES  csu,
           HZ_LOCATIONS       loc,
           HZ_LOC_ASSIGNMENTS loc_assign
     WHERE addr.CUSTOMER_CATEGORY_CODE = l_cat.LOOKUP_CODE(+)
       AND l_cat.LOOKUP_TYPE(+) = 'ADDRESS_CATEGORY'
       AND loc.COUNTRY = terr.TERRITORY_CODE(+)
       AND loc.LANGUAGE = lang.LANGUAGE_CODE(+)
       AND addr.PARTY_SITE_ID = party_site.PARTY_SITE_ID
       AND csu.CUST_ACCT_SITE_ID = addr.CUST_ACCT_SITE_ID
       AND csu.SITE_USE_CODE IN ('STMTS','BILL_TO')
       AND NVL(csu.PRIMARY_FLAG, 'N') = 'Y'
       AND loc.LOCATION_ID = party_site.LOCATION_ID
       AND loc.LOCATION_ID = loc_assign.LOCATION_ID(+) -- n.b. this is an "optional join" OF-3393
       AND addr.cust_account_id = cn_cust_id
       AND party_site.PARTY_ID = cn_party_id
       ORDER BY decode(csu.site_use_code,'STMTS',1,'BILL_TO',2,3);
                      
  BEGIN
    pb_good_site := TRUE;
    
    -- Get Site Address Info 
    OPEN cur_sites (pn_cust_id, pn_party_id);
    FETCH cur_sites INTO pv_address1,
                         pv_address2,
                         pv_address3,
                         pv_address4,
                         pv_city,
                         pv_state,
                         pv_postal_code,
                         pv_country,
                         --
                         l_good_geocode;
    IF cur_sites%NOTFOUND THEN
       log('l', '*** Warning: Primary Bill_To Site Address not found');
       pb_good_site := FALSE;
       pv_address1 := null;
       pv_address2 := null;
       pv_address3 := null;
       pv_address4 := null;
       pv_city := null;
       pv_state := null;
       pv_postal_code := null;
       pv_country := null;
    END IF;
    CLOSE cur_sites;

    IF length(pv_state) > 5 THEN
      pb_good_site := FALSE;
      log('l', '*** Warning: Length of state exceeds 5 characters');
    END IF;

    IF length(pv_postal_code) > 12 THEN
      pb_good_site := FALSE;
      log('l', '*** Warning: Length of postal_code exceeds 12 characters');
    END IF;

    IF l_good_geocode = 0 THEN
      log('l', '*** Warning: missing geocode data');
    END IF;
    
    IF (pb_good_site) THEN 
        -- Find Primary Customer Bill-To Account Site Id
        BEGIN 
        SELECT addr.CUST_ACCT_SITE_ID
          INTO pn_cust_acct_site_id
          FROM HZ_CUST_ACCT_SITES addr,
               HZ_PARTY_SITES     sites,
               HZ_CUST_SITE_USES  hcsu
         WHERE addr.cust_account_id = pn_cust_id
           AND sites.PARTY_SITE_ID = addr.PARTY_SITE_ID
           AND addr.STATUS = 'A'
           AND addr.CUST_ACCT_SITE_ID = hcsu.CUST_ACCT_SITE_ID
           AND hcsu.SITE_USE_CODE = 'BILL_TO'
           AND NVL(hcsu.PRIMARY_FLAG, 'N') = 'Y';
          log('d','CUST_ACCT_SITE_ID ' || pn_cust_acct_site_id);
          EXCEPTION WHEN NO_DATA_FOUND THEN
              pb_good_site := FALSE;
              log('l', '*** Warning: Please fix the address status flag.');
          END;
    END IF;
            
  EXCEPTION WHEN OTHERS THEN
    pb_good_site := FALSE;    
    log('l','*** Error Retrieving Site Info Customer Id '||pn_cust_id);
    log('l',sqlerrm);
  END get_site_info;                          
  
  --- ***************************************************************************************************************
  --- Function:   get_line_amounts
  --- Function Description:
  ---     Retrieve Trx Line Amount Totals
  ---
  ---     Parameters Used:  
  ---       pn_trx_id       - Transaction Id to be queried
  ---       pn_subtot       - Non-Tax/Freight Total to be returned
  ---       pn_ship_hndl    - Ship/Handling amount to be returned
  ---       pn_tax          - Tax Amount to be returned
  ---       pn_pmt_used     - Applied Amount to be returned 
  ---
  ---  Development and Maintenance History:
  ---  ------------------------------------
  ---  DATE              AUTHOR                      DESCRIPTION 
  ---  ----------        ------------------------    ----------------------------------------------------------- 
  ---  2009-11-18        Jason McCleskey             Initial Creation - Remove duplication in F1, F2, and F3 procedures
  --- ***************************************************************************************************************
  PROCEDURE get_line_amounts (pn_trx_id       NUMBER, 
                              pn_subtot       OUT NUMBER,
                              pn_ship_hndl    OUT NUMBER,
                              pn_tax          OUT NUMBER,
                              pn_pmt_used     OUT NUMBER
                             ) IS
   
--  vn_freight_id       NUMBER(15) := TO_NUMBER(FND_PROFILE.VALUE('OE_INVENTORY_ITEM_FOR_FREIGHT'));
    vn_freight_id       NUMBER(15) := gn_freight_item;

  BEGIN

    SELECT NVL(SUM(CASE 
                 WHEN LINE_TYPE IN ('FREIGHT', 'TAX') then 0
                 WHEN NVL(INVENTORY_ITEM_ID, -999) = vn_freight_id THEN 0
                 ELSE nvl(extended_amount,0)
               END),0) sub_total_amnt,
           NVL(SUM(CASE 
                 WHEN NVL(INVENTORY_ITEM_ID, -999) = vn_freight_id
                    THEN NVL(EXTENDED_AMOUNT, 0)
                 ELSE 0
               END),0) ship_hndl_amt,
           NVL(SUM(CASE 
                 WHEN LINE_TYPE = 'TAX' THEN NVL(EXTENDED_AMOUNT, 0)
                 ELSE 0
               END),0) tax_amt
    INTO pn_subtot, pn_ship_hndl, pn_tax
    FROM ar.RA_CUSTOMER_TRX_LINES_ALL 
    WHERE customer_trx_id = nvl(pn_trx_id, -999);
    
    log('d','Sub Total Amount ' ||to_char(pn_subtot, '999,999,999,990.00'));
    log('d','Ship Handling Amount ' || to_char(pn_ship_hndl, '999,999,999,990.00'));
    log('d','Tax Amount ' || to_char(pn_tax, '999,999,999,990.00'));

    SELECT NVL(SUM(NVL(amount_applied, 0)), 0)
      INTO pn_pmt_used
      FROM ar.AR_PAYMENT_SCHEDULES_ALL
     WHERE CUSTOMER_TRX_ID = nvl(pn_trx_id, -999);
    log('d','Payment Used Amount ' ||to_char(pn_pmt_used, '999,999,999,990.00'));

  END get_line_amounts;

  --- ***************************************************************************************************************
  --- Function check_xml_display
  --- Description
  ---    This function will use the customer trx line id to check to see if the current line needs to be displayed.
  ---    This is needed to distinguish the regular shipping and handling versus those special charges.
  --- ***************************************************************************************************************
  FUNCTION check_xml_display(p_customer_trx_line_id IN NUMBER) RETURN NUMBER IS
    v_process_stage               VARCHAR2(600) := NULL;

    v_check_xml_display_result    NUMBER        := 0;
    v_intfc_line_context    RA_CUSTOMER_TRX_LINES.INTERFACE_LINE_CONTEXT%TYPE;
    v_intfc_line_attribute6 RA_CUSTOMER_TRX_LINES.INTERFACE_LINE_ATTRIBUTE6%TYPE;
    v_sales_order_line      RA_CUSTOMER_TRX_LINES.SALES_ORDER_LINE%TYPE;
    v_inventory_item_id     RA_CUSTOMER_TRX_LINES.INVENTORY_ITEM_ID%TYPE;
    v_charge_type_code      OE_PRICE_ADJUSTMENTS.CHARGE_TYPE_CODE%TYPE;

  BEGIN

    -- First check to see if the p_customer_trx_line_id is not null.
    IF p_customer_trx_line_id IS NULL THEN
      v_check_xml_display_result := 1;
      RETURN v_check_xml_display_result;
    ELSE
      v_process_stage := 'Retrieving ra_customer_trx_line info. using p_customer_trx_line_id: ' ||
                         to_char(p_customer_trx_line_id);

      SELECT INTERFACE_LINE_CONTEXT,
             INTERFACE_LINE_ATTRIBUTE6,
             SALES_ORDER_LINE,
             INVENTORY_ITEM_ID
        INTO v_intfc_line_context,
             v_intfc_line_attribute6,
             v_sales_order_line,
             v_inventory_item_id
        FROM RA_CUSTOMER_TRX_LINES_ALL
       WHERE CUSTOMER_TRX_LINE_ID = p_customer_trx_line_id;

      -- Check to see if the current line item is a freight item.
      IF nvl(v_inventory_item_id, -999) =
         gn_freight_item THEN        -- Freight item.  Now check to see if this is coming from OM and if it is, check the charge type code.
        IF v_intfc_line_context = 'ORDER ENTRY' THEN
          -- retrieve the charge type code.
          v_process_stage := 'Retrieve data from oe_price_adjustments using interface line attribute6 value: ' ||
                             v_intfc_line_attribute6;

          BEGIN
            SELECT CHARGE_TYPE_CODE
              INTO v_charge_type_code
              FROM OE_PRICE_ADJUSTMENTS
             WHERE PRICE_ADJUSTMENT_ID = TO_NUMBER(v_intfc_line_attribute6);

            IF v_charge_type_code = 'SHIPPING AND PROCESSING' THEN
              -- Regular freight, and therefore, don't display it.
              RETURN v_check_xml_display_result;
            ELSE
              v_check_xml_display_result := 1;
              RETURN v_check_xml_display_result;
            END IF;

          EXCEPTION
            WHEN NO_DATA_FOUND THEN
              v_check_xml_display_result := 1;
              RETURN v_check_xml_display_result;

          END;
        ELSE
          -- Non OM transaction.  Any line that charges to the item will be treated as a regular shipping and
          -- therefore, not to display the line.
          RETURN v_check_xml_display_result;
        END IF; -- End of checking Interface line context = ORDER ENTRY
      ELSE
        -- Not a freight item.  So display the line.
        v_check_xml_display_result := 1;
        RETURN v_check_xml_display_result;
      END IF;

    END IF; -- End of checking p_customer_trx_line_id IS NULL.

  EXCEPTION
    WHEN OTHERS THEN
      log('l',
                        'ERROR in check_display with v_process_stage: ');
      log('l', v_process_stage);
      log('l',
                        'SQLCODE: ' || sqlcode || ' SQLERRM: ' ||
                        sqlerrm);
      RETURN v_check_xml_display_result;
  END check_xml_display;

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
---  2018-05-11        Greg Wright                 OF-3043 - Break up 'Address' into individual lines.
--- ***************************************************************************************************************
FUNCTION get_statement_xml
          (pv_account_number  VARCHAR2,
           pd_statement_date  DATE
           ) 
   RETURN CLOB IS 

  v_return      CLOB := null;
  v_error_xml   VARCHAR2(4000) := '<ArStatement><AccountNumber>:ERROR:</AccountNumber></ArStatement>';
  d_stmt_date   DATE := null;

 
  CURSOR cur_statement_xml (cv_custnum VARCHAR2, 
                            cd_stmt_date DATE) IS 
  SELECT 
     xmlelement("ArStatement", 
       xmlelement("AccountNumber",sh.send_to_cust_nbr),
       xmlelement("StatementDate",to_char(sh.stmt_dte,'mm-dd-rrrr')),
       xmlelement("LogoCode",sh.logo_cde),
       xmlelement("RepPhoneNbr",sh.rep_phone_nbr),
       xmlelement("LWFax",sh.lw_fax_nbr),
       xmlelement("LWEmail",sh.lw_email_adr),
       xmlelement("AccountName",sh.send_to_cust_nme),
       xmlelement("Address",rtrim(  sh.send_to_line_1_adr||chr(13)||sh.send_to_line_2_adr||chr(13)
                                  ||sh.send_to_line_3_adr||chr(13)||sh.send_to_line_4_adr,
                              chr(13))
                  ),
       xmlelement("Address_Line_1",sh.send_to_line_1_adr),
       xmlelement("Address_Line_2",sh.send_to_line_2_adr),
       xmlelement("Address_Line_3",sh.send_to_line_3_adr),
       xmlelement("Address_Line_4",sh.send_to_line_4_adr),
       xmlelement("City",sh.send_to_city_nme),
       xmlelement("State",sh.send_to_state_cde),
       xmlelement("Zip",sh.send_to_postal_cde),
       xmlelement("Country",sh.send_to_cntry_nme),
       xmlelement("Balance",sh.balance_amt),
       xmlelement("PastDueAmount",sh.over_due_amt),
       xmlelement("DueAmount",sh.due_amt),
       xmlelement("NotDueAmount",sh.not_due_amt),
       xmlelement("PayAmount",sh.to_pay_amt),
       xmlelement("DueDate",to_char(sh.stmt_due_dte,'mm-dd-rr')),
       xmlelement("ScanLine",sh.scan_line_nme),
       xmlelement("PrepaidPageCnt",sh.ppd_page_cnt),
       xmlelement("DetailPageCnt",sh.dtl_page_cnt),
       xmlelement("InvoicePageCnt",sh.invo_page_cnt),
       xmlelement("DetailLineAmt",ltrim(to_char(sh.balance_amt,'999,999,999,990.00PT'))),
       xmlelement("Prepaid",
          (
          SELECT xmlagg(
            xmlelement("Prepaid_Page",
              xmlelement("Prepaid_Stmt_Line_ID",xtt.stmt_line_id),
              xmlelement("Prepaid_Stmt_Line_Nbr",lwx_detail_row(xtt.stmt_hdr_id,xtt.stmt_line_id)),
              xmlelement("Prepaid_Page_Nbr",ceil(lwx_prepaid_row(xtt.stmt_hdr_id,xtt.stmt_line_id)/20)), 
              (-- Transaction and Payment Prepaid
               SELECT xmlagg(
                             xmlelement("Line",
                                xmlelement("LineNbr",lwx_prepaid_row(tt.stmt_hdr_id,tt.stmt_line_id)),
                                xmlelement("StmtHdrID",tt.stmt_hdr_id),
                                xmlelement("StmtLineID",tt.stmt_line_id),
                                xmlelement("RecType",tt.rec_type_cde),
                                xmlelement("TrxDate",to_char(tt.trans_dte,'mm-dd-rr')),
                                xmlelement("DocType",tt.doc_type_nme),
                                xmlelement("SalesChannel",
                                              case 
                                                when tt.doc_type_nme = 'Payment' then arm.printed_name
                                                else flv.meaning
                                              end
                                           ),
                                xmlelement("CustReference",tt.cust_ref_nme), 
                                xmlelement("TrxDueDate",to_char(tt.due_dte,'mm-dd-rr')),
                                xmlelement("TrxNumber",tt.trans_nbr),
                                xmlelement("OriginalAmount",tt.orig_amt),
                                xmlelement("OutstandingAmount",tt.outstnd_amt),
                                xmlelement("OriginalAmountFormatted",ltrim(to_char(tt.orig_amt,'999,999,999,990.00PT'))),
                                xmlelement("OutstandingAmountFormatted",ltrim(to_char(tt.outstnd_amt,'999,999,999,990.00PT'))),
                                xmlelement("PartialPay",tt.partial_pmt_ind),
                                xmlelement("FuturePay",tt.fut_pmt_ind)
                                       )
                             order by tt.stmt_hdr_id, tt.trans_dte, tt.payment_schedule_id)
               FROM lwx.lwx_ar_stmt_lines     tt, 
                    ar.ar_cash_receipts_all   cra, 
                    ar.ar_receipt_methods     arm, 
                    apps.fnd_lookup_values_vl flv
               WHERE tt.stmt_hdr_id = sh.stmt_hdr_id
               AND tt.rec_type_cde = 'F2'
               AND tt.cash_receipt_id = cra.cash_receipt_id (+) 
               AND cra.receipt_method_id = arm.receipt_method_id (+) 
               AND tt.sls_chnl_nme = flv.lookup_code(+)
               AND flv.lookup_type (+) = 'SALES_CHANNEL'
               AND ceil(lwx_prepaid_row(xtt.stmt_hdr_id,xtt.stmt_line_id)/20) = 
                   ceil(lwx_prepaid_row(tt.stmt_hdr_id,tt.stmt_line_id)/20)
              ) -- End Transaction/Payment Prepaid Subquery
            ) -- End Prepaid_Page element list

               ORDER BY xtt.stmt_hdr_id, xtt.trans_dte, xtt.payment_schedule_id 
              ) -- End xmlagg for Prepaid_Page
              FROM   lwx.LWX_AR_STMT_LINES xtt
              WHERE  xtt.STMT_HDR_ID = sh.stmt_hdr_id
              AND    xtt.REC_TYPE_CDE = 'F2'
              AND    (trunc((lwx_prepaid_row(xtt.stmt_hdr_id,xtt.stmt_line_id) - 1) / 20,0)) + 1 =
                           ((lwx_prepaid_row(xtt.stmt_hdr_id,xtt.stmt_line_id) - 1) / 20) + 1
            ) -- End query for prepaid_page  
            ) -- End prepaid element

       ,xmlelement("Detail",
          (
          SELECT xmlagg(
            xmlelement("Detail_Page",
              xmlelement("Detail_Stmt_Line_ID",xtt.stmt_line_id),
              xmlelement("Detail_Stmt_Line_Nbr",lwx_detail_row(xtt.stmt_hdr_id,xtt.stmt_line_id)),
              xmlelement("Detail_Page_Nbr",ceil(lwx_detail_row(xtt.stmt_hdr_id,xtt.stmt_line_id)/20)),
              (-- Transaction and Payment Detail
               SELECT xmlagg(
                             xmlelement("Line",
                                xmlelement("LineNbr",lwx_detail_row(tt.stmt_hdr_id,tt.stmt_line_id)),
                                xmlelement("StmtHdrID",tt.stmt_hdr_id),
                                xmlelement("StmtLineID",tt.stmt_line_id),
                                xmlelement("RecType",tt.rec_type_cde),
                                xmlelement("TrxDate",to_char(tt.trans_dte,'mm-dd-rr')),
                                xmlelement("DocType",tt.doc_type_nme),
                                xmlelement("SalesChannel",
                                              case 
                                                when tt.doc_type_nme = 'Payment' then arm.printed_name
                                                else flv.meaning
                                              end
                                           ),
                                xmlelement("CustReference",tt.cust_ref_nme), 
                                xmlelement("TrxDueDate",to_char(tt.due_dte,'mm-dd-rr')),
                                xmlelement("TrxNumber",tt.trans_nbr),
                                xmlelement("OriginalAmount",tt.orig_amt),
                                xmlelement("OutstandingAmount",tt.outstnd_amt),
                                xmlelement("OriginalAmountFormatted",ltrim(to_char(tt.orig_amt,'999,999,999,990.00PT'))),
                                xmlelement("OutstandingAmountFormatted",ltrim(to_char(tt.outstnd_amt,'999,999,999,990.00PT'))),
                                xmlelement("PartialPay",tt.partial_pmt_ind),
                                xmlelement("FuturePay",tt.fut_pmt_ind)
                                       )
                             order by tt.stmt_hdr_id, tt.trans_dte, tt.payment_schedule_id)
               FROM lwx.lwx_ar_stmt_lines     tt, 
                    ar.ar_cash_receipts_all   cra, 
                    ar.ar_receipt_methods     arm, 
                    apps.fnd_lookup_values_vl flv
               WHERE tt.stmt_hdr_id = sh.stmt_hdr_id
               AND tt.rec_type_cde = 'F3'
               AND tt.cash_receipt_id = cra.cash_receipt_id (+) 
               AND cra.receipt_method_id = arm.receipt_method_id (+) 
               AND tt.sls_chnl_nme = flv.lookup_code(+)
               AND flv.lookup_type (+) = 'SALES_CHANNEL'
               AND ceil(lwx_detail_row(xtt.stmt_hdr_id,xtt.stmt_line_id)/20) = 
                   ceil(lwx_detail_row(tt.stmt_hdr_id,tt.stmt_line_id)/20)
           
              ) -- End Transaction/Payment Detail Subquery
              ) -- End Detail_Page element list
               ORDER BY xtt.stmt_hdr_id, xtt.trans_dte, xtt.payment_schedule_id                
              ) -- End xmlagg for Detail_Page
              FROM   lwx.LWX_AR_STMT_LINES xtt
              WHERE  xtt.STMT_HDR_ID = sh.stmt_hdr_id
              AND    xtt.REC_TYPE_CDE = 'F3'
              AND    (trunc((lwx_detail_row(xtt.stmt_hdr_id,xtt.stmt_line_id) - 1) / 20,0)) + 1 =
                           ((lwx_detail_row(xtt.stmt_hdr_id,xtt.stmt_line_id) - 1) / 20) + 1
            ) -- End query for detail_page  
            ) -- End "Detail" element

       ,xmlelement("ConsolidatedInvoices",
                 (-- Consolidated Invoice Data
                  SELECT xmlagg(
                           xmlelement("Cons_Invoice",
                                xmlelement("Cons_Trans_Dte",to_char(ctt.trans_dte,'MM-DD-YYYY')),
                                xmlelement("Cons_Trans_Nbr",ctt.trans_nbr),
                                xmlelement("Cons_Page_Cnt",ctt.page_cnt),
                                xmlelement("Cons_Line_Cnt",ctt.line_cnt),
                                xmlelement("Cons_Logo_Cde",ctt.logo_cde),
                                xmlelement("Cons_Doc_Title_Nme",ctt.doc_title_nme),
                                xmlelement("Cons_Rep_Msg_Nme",ctt.rep_msg_nme),
                                xmlelement("Cons_Ship_To_Cust_Nbr",ctt.ship_to_cust_nbr),
                                xmlelement("Cons_Ship_To_Cust_Nme",ctt.ship_to_cust_nme),
                                xmlelement("Cons_Ship_To_Line_1_Adr",ctt.ship_to_line_1_adr),
                                xmlelement("Cons_Ship_To_Line_2_Adr",ctt.ship_to_line_2_adr),
                                xmlelement("Cons_Ship_To_Line_3_Adr",ctt.ship_to_line_3_adr),
                                xmlelement("Cons_Ship_To_Line_4_Adr",ctt.ship_to_line_4_adr),
                                xmlelement("Cons_Ship_To_City_Nme",ctt.ship_to_city_nme),
                                xmlelement("Cons_Ship_To_State_Cde",ctt.ship_to_state_cde),
                                xmlelement("Cons_Ship_To_Postal_Cde",ctt.ship_to_postal_cde),
                                xmlelement("Cons_Ship_To_Cntry_Nme",ctt.ship_to_cntry_nme),
                                xmlelement("Cons_Ship_To_Address",
                                            rtrim(           ctt.ship_to_line_1_adr||
                                                    chr(13)||ctt.ship_to_line_2_adr||
                                                    chr(13)||ctt.ship_to_line_3_adr||
                                                    chr(13)||ctt.ship_to_line_4_adr,chr(13))),
                                xmlelement("Cons_Ship_To_City_State_Zip",
                                            rtrim(           ctt.ship_to_city_nme||
                                                        ' '||ctt.ship_to_state_cde||
                                                        ' '||ctt.ship_to_postal_cde)),
                                xmlelement("Cons_Bill_To_Cust_Nbr",ctt.bill_to_cust_nbr),
                                xmlelement("Cons_Bill_To_Cust_Nme",ctt.bill_to_cust_nme),
                                xmlelement("Cons_Bill_To_Line_1_Adr",ctt.bill_to_line_1_adr),
                                xmlelement("Cons_Bill_To_Line_2_Adr",ctt.bill_to_line_2_adr),
                                xmlelement("Cons_Bill_To_Line_3_Adr",ctt.bill_to_line_3_adr),
                                xmlelement("Cons_Bill_To_Line_4_Adr",ctt.bill_to_line_4_adr),
                                xmlelement("Cons_Bill_To_Address",
                                            rtrim(           ctt.bill_to_line_1_adr||
                                                    chr(13)||ctt.bill_to_line_2_adr||
                                                    chr(13)||ctt.bill_to_line_3_adr||
                                                    chr(13)||ctt.bill_to_line_4_adr,chr(13))),
                                xmlelement("Cons_Bill_To_City_State_Zip",
                                            rtrim(           ctt.bill_to_city_nme||
                                                        ' '||ctt.bill_to_state_cde||
                                                        ' '||ctt.bill_to_postal_cde)),
                                xmlelement("Cons_Bill_To_City_Nme",ctt.bill_to_city_nme),
                                xmlelement("Cons_Bill_To_State_Cde",ctt.bill_to_state_cde),
                                xmlelement("Cons_Bill_To_Postal_Cde",ctt.bill_to_postal_cde),
                                xmlelement("Cons_Bill_To_Cntry_Nme",ctt.bill_to_cntry_nme),
                                xmlelement("Cons_Cust_Ref_Nme",ctt.cust_ref_nme),
                                xmlelement("Cons_Term_Msg1_Nme",ctt.term_msg1_nme),   
                                xmlelement("Cons_Term_Msg2_Nme",ctt.term_msg2_nme),
                                xmlelement("Cons_Order_Dte",to_char(ctt.order_dte,'MM-DD-YYYY')),
                                xmlelement("Cons_Ship_Meth_Nme",ctt.ship_meth_nme),
                                xmlelement("Cons_Cust_Cont_Nme",ctt.cust_cont_nme),
                                xmlelement("Cons_Cust_Cont_Phone_Nbr",ctt.cust_cont_phone_nbr),
                                xmlelement("Cons_Sls_Chnl_Nme",ctt.sls_chnl_nme),
                                xmlelement("Cons_Stmt_Line_Id",ctt.stmt_line_id),
                                xmlelement("Cons_Mkt_Msg1_Nme",ctt.mkt_msg1_nme),  
                                xmlelement("Cons_Mkt_Msg2_Nme",ctt.mkt_msg2_nme),
                                xmlelement("Cons_Mkt_Msg3_Nme",ctt.mkt_msg3_nme),
                                xmlelement("Cons_Mkt_Msg4_Nme",ctt.mkt_msg4_nme),
                                xmlelement("Cons_Sub_Total_Amt",ctt.sub_total_amt),
                                xmlelement("Cons_Sub_Total_Amt_Fmt",ltrim(to_char(ctt.sub_total_amt,'$999,999,999.00'))),                                
                                xmlelement("Cons_Ship_Hndl_Amt",ctt.ship_hndl_amt),
                                xmlelement("Cons_Ship_Hndl_Amt_Fmt",ltrim(to_char(ctt.ship_hndl_amt,'$999,999,999.00'))),                           

                                xmlelement("Cons_Tax_Amt",ctt.tax_amt),
                                xmlelement("Cons_Tax_Amt_Fmt",ltrim(to_char(ctt.tax_amt,'$999,999,999.00'))),                           

                                xmlelement("Cons_Inv_Total",(ctt.sub_total_amt + ctt.ship_hndl_amt + ctt.tax_amt)),
                                xmlelement("Cons_Inv_Total_Fmt",ltrim(to_char((ctt.sub_total_amt + ctt.ship_hndl_amt + ctt.tax_amt),'$999,999,999.00'))),                              
                           
                                xmlelement("Cons_Pmt_Used_Amt",ctt.pmt_used_amt),
                                xmlelement("Cons_Pmt_Used_Amt_Fmt",ltrim(to_char(ctt.pmt_used_amt,'$999,999,999.00'))),                                
                                xmlelement("Cons_Total_Due_Amt",ctt.total_due_amt),
                                xmlelement("Cons_Total_Due_Amt_Fmt",ltrim(to_char(ctt.total_due_amt,'$999,999,999.00'))),                                
                                xmlelement("Cons_Cash_Receipt_Id",ctt.cash_receipt_id),

                                xmlelement("Cons_Batch_Source_ID",(select z.batch_source_id
                                                                   from ar.ra_customer_trx_all z
                                                                   where ctt.customer_trx_id = z.customer_trx_id)),
                                xmlelement("Cons_Inv_Item_List",
                                  ( -- Invoice Item List
                                
                                
                                SELECT distinct xmlagg( 
                                         xmlelement("Cons_Inv_Item_Page",  
                                           xmlelement("Item_Page_Del_Stmt_Nbr",
                                               (case
                                                  when ctt.ship_to_cust_nbr = ctt.bill_to_cust_nbr then ctt.ship_to_cust_nbr
                                                  else ctt.ship_to_cust_nbr || '/' || ctt.bill_to_cust_nbr                                          
                                                end)),                                            
                                           xmlelement("Item_Page_Cnt",ceil(lwx_item_row(xld.stmt_line_id,xld.stmt_line_dtl_id)/16)),
                                     (
                                     SELECT xmlagg( 
                                         xmlelement("Cons_Inv_Item",
                                             xmlelement("Item_Lwx_Item_Row",lwx_item_row(xld.stmt_line_id,ld.stmt_line_dtl_id)),
                                             xmlelement("Item_Line_ID",xld.stmt_line_id),
                                             xmlelement("Item_Dtl_Nbr_LD",ld.stmt_line_dtl_nbr),
                                             xmlelement("Item_Dtl_Nbr_XLD",xld.stmt_line_dtl_nbr),                                             
                                             xmlelement("Item_Line_Type_Cde",ld.line_type_cde),
                                             xmlelement("Item_Ordered_Qty_Cnt",ld.ordered_qty_cnt),
                                             xmlelement("Item_Shipped_Qty_Cnt",ld.shipped_qty_cnt),
                                             xmlelement("Item_Alt_Item_Nbr",ld.alt_item_nbr),
                                             xmlelement("Item_Item_Nbr",ld.item_nbr),
                                             xmlelement("Item_Line_Desc_Txt",ld.line_desc_txt),
                                             xmlelement("Item_Selling_Price_Amt",ld.selling_price_amt),
                                             xmlelement("Item_Selling_Price_Amt_Fmt",ltrim(to_char(ld.selling_price_amt,'$999,999,999.00'))),                                             
                                             xmlelement("Item_Selling_Disc_Amt",ld.selling_disc_amt),
                                             xmlelement("Item_Selling_Disc_Amt_Fmt",ltrim(to_char(ld.selling_disc_amt,'990.0000') || '%')),
                                             xmlelement("Item_Extended_Amt",ld.extended_amt),
                                             xmlelement("Item_Extended_Amt_Fmt",ltrim(to_char(ld.extended_amt,'$999,999,999.00'))),                                             
                                             xmlelement("Item_Customer_Trx_Line_Id",ld.customer_trx_line_id)

                                           ) -- End Con_Inv_Item element list
                                           ORDER BY ld.stmt_line_dtl_id
                                           ) -- End xmlagg for Cons_Inv_Item         
                                  FROM     lwx.lwx_ar_stmt_line_details ld
                                  WHERE    ld.stmt_line_id = ctt.stmt_line_id
                                  AND      check_xml_display(ld.customer_trx_line_id) = 1
                                  AND      ceil(lwx_item_row(xld.stmt_line_id,xld.stmt_line_dtl_id)/16) = 
                                           ceil(lwx_item_row(xld.stmt_line_id,ld.stmt_line_dtl_id)/16)

                                  ) -- End query for Cons_Inv_Item
                                  ) -- End Cons_Inv_Item_Page element list
                                  ORDER BY xld.stmt_line_dtl_id
                                  ) -- End xmlagg for Cons_Inv_Item_Page
                         FROM     lwx.lwx_ar_stmt_line_details xld
                         WHERE    xld.stmt_line_id = ctt.stmt_line_id
                         AND      check_xml_display(xld.customer_trx_line_id) = 1
                         AND      (trunc((lwx_item_row(xld.stmt_line_id,xld.stmt_line_dtl_id) - 1) / 16,0)) + 1 = 
                                  ((lwx_item_row(xld.stmt_line_id,xld.stmt_line_dtl_id) - 1) / 16) + 1
                         ) -- End Cons_Inv_Item_List 
                         ) -- End element def. Cons_Inv_Item_List                                
                         ) -- End  Cons_Invoice element list
                         ) -- End xmlagg for Cons_Invoice
                  FROM   lwx.LWX_AR_STMT_LINES ctt
                  WHERE  ctt.STMT_HDR_ID = sh.stmt_hdr_id
                  AND    ctt.REC_TYPE_CDE = 'F4'
                  AND    NVL(ctt.INCL_CUR_STMT_IND, 'Y') = 'Y' -- Jude Lam 05/17/06 update.
                 ) -- End Query for Consolidated Invoice data
                 ) -- End Consolidated Invoices Element list
       ).getClobVal() -- End element list for ArStatement
  FROM lwx.lwx_ar_stmt_headers sh
  WHERE sh.send_to_cust_nbr = cv_custnum
  AND trunc(sh.stmt_dte) = trunc(cd_stmt_date);


BEGIN

  -- Verify Parameters
  IF (pv_account_number is null) THEN
      v_return := replace(v_error_xml,':ERROR:','No Account Number passed in!');
      goto return_results;
  END IF;
  IF (pd_statement_date is null) THEN 
      v_return := replace(v_error_xml,':ERROR:','No Statement Date passed in!');
      goto return_results;
  END IF;

  -- Generate XML from cursor query 
  OPEN cur_statement_xml (pv_account_number,pd_statement_date);
  FETCH cur_statement_xml INTO v_return;
  IF (cur_statement_xml%NOTFOUND) THEN
         v_return := replace(v_error_xml,':ERROR:','No statement found!');
  END IF;
  CLOSE cur_statement_xml;

  <<return_results>>
  RETURN v_return;  

END get_statement_xml;    
  
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
FUNCTION get_statement_xml (pv_account_number  VARCHAR2,
                            pv_statement_date  VARCHAR2  -- Format - 31-JAN-16 or 31-JAN-2016
                           ) 
 RETURN CLOB IS
  v_return      CLOB := null;
  v_error_xml   VARCHAR2(4000) := '<ArStatement><AccountNumber>:ERROR:</AccountNumber></ArStatement>';
  d_stmt_date   DATE := null;

BEGIN
  IF (pv_statement_date is not null) THEN 
      BEGIN
      d_stmt_date := to_date(pv_statement_date,'DD-MON-RRRR');
      EXCEPTION WHEN OTHERS THEN
          v_return := replace(v_error_xml,':ERROR:','Invalid Statement Date Format: '||pv_statement_date);
      END;
  END IF;

  RETURN nvl(v_return,get_statement_xml(pv_account_number,d_stmt_date));

END get_statement_xml;  

--- ***************************************************************************************************************
--- Function:   get_invoice_xml
--- Description:  Builds an XML document (CLOB) that contains all necessary fields for printing an invoice.
---
---    RETURN - XML Document in CLOB format
---
---  Development and Maintenance History:
---  ------------------------------------
---  DATE              AUTHOR                      DESCRIPTION 
---  ----------        ------------------------    ----------------------------------------------------------- 
---  2017-05-24        Greg Wright                 Generate single invoice in XML format.
---  2018-02-19        Greg Wright                 OF-2981 Added Use Tax Message function Lwx_Get_Use_Tax_Message.
---  2018-04-12        Greg Wright                 OF-3035 Refine the calling of lwx_use_tax_message.
---  2018-04-12        Greg Wright                 OF-2934 Add addressee to ship_to address lines
--- ***************************************************************************************************************
FUNCTION get_invoice_xml
         (pv_customer_trx_id NUMBER
           ) 
   RETURN CLOB IS 

    -- Record Type variable declaration
    v_customer_cur_rec       v_customer_cur_rec_type;
    v_openitem_cur_rec       v_openitem_cur_rec_type;
    v_trx_line_dtl_cur_rec   v_trx_line_dtl_cur_rec_type;

    v_cm_printed_flag        VARCHAR2(1);
    v_retcode                NUMBER;
    v_return                 CLOB := null;
    v_temp_clob              CLOB := null;
    v_error_xml   VARCHAR2(4000) := '<ArStatement><AccountNumber>:ERROR:</AccountNumber></ArStatement>';
    v_master_org_id          NUMBER;
    v_inv_item_status_code   MTL_SYSTEM_ITEMS_B.INVENTORY_ITEM_STATUS_CODE%TYPE;  
  
    -- Temporary variables for extracting trx_number
    v_paren_position           integer;
    v_trx_with_sales_order     VARCHAR2(30);
    v_trx_without_sales_order  VARCHAR2(30);
  
    -- Local varibles declaration
    v_process_stage        VARCHAR2(240);
    v_stmt_hdr_id          LWX_AR_STMT_HEADERS.STMT_HDR_ID%TYPE;
    v_stmt_line_nbr        LWX_AR_STMT_LINES.STMT_LINE_NBR%TYPE;
    v_incl_cur_stmt_ind    LWX_AR_STMT_LINES.INCL_CUR_STMT_IND%TYPE;
    v_rec_type_cde         LWX_AR_STMT_LINES.REC_TYPE_CDE%TYPE;
    v_customer_trx_id      LWX_AR_STMT_LINES.CUSTOMER_TRX_ID%TYPE;
    v_cash_receipt_id      LWX_AR_STMT_LINES.CASH_RECEIPT_ID%TYPE;
    v_payment_schedule_id  LWX_AR_STMT_LINES.PAYMENT_SCHEDULE_ID%TYPE;
    v_page_cnt             LWX_AR_STMT_LINES.PAGE_CNT%TYPE := 0;
    v_line_cnt             LWX_AR_STMT_LINES.LINE_CNT%TYPE := 0;
    v_rep_msg_nme          LWX_AR_STMT_LINES.REP_MSG_NME%TYPE;
    v_bill_to_cust_nbr     LWX_AR_STMT_LINES.BILL_TO_CUST_NBR%TYPE;
    v_bill_to_cust_nme     LWX_AR_STMT_LINES.BILL_TO_CUST_NME%TYPE;
    v_bill_to_addressee    AR.HZ_PARTY_SITES.ADDRESSEE%TYPE;
    v_bill_to_line1_adr    LWX_AR_STMT_LINES.bill_to_line_1_adr%TYPE;
    v_bill_to_line2_adr    LWX_AR_STMT_LINES.BILL_TO_LINE_2_ADR%TYPE;
    v_bill_to_line3_adr    LWX_AR_STMT_LINES.BILL_TO_LINE_3_ADR%TYPE;
    v_bill_to_line4_adr    LWX_AR_STMT_LINES.BILL_TO_LINE_4_ADR%TYPE;
    v_bill_to_city_nme     LWX_AR_STMT_LINES.BILL_TO_CITY_NME%TYPE;
    v_bill_to_state_cde    LWX_AR_STMT_LINES.BILL_TO_STATE_CDE%TYPE;
    v_bill_to_postal_cde   LWX_AR_STMT_LINES.BILL_TO_POSTAL_CDE%TYPE;
    v_bill_to_cntry_nme    LWX_AR_STMT_LINES.bill_to_cntry_nme%TYPE;
    v_bill_to_country      AR.HZ_LOCATIONS.COUNTRY%TYPE;
    v_ship_to_cust_nbr     LWX_AR_STMT_LINES.SHIP_TO_CUST_NBR%TYPE;
    v_ship_to_cust_nme     LWX_AR_STMT_LINES.SHIP_TO_CUST_NME%TYPE;
    v_ship_to_addressee    AR.HZ_PARTY_SITES.ADDRESSEE%TYPE;
    v_ship_to_line1_adr    LWX_AR_STMT_LINES.SHIP_TO_LINE_1_ADR%TYPE;
    v_ship_to_line2_adr    LWX_AR_STMT_LINES.SHIP_TO_LINE_2_ADR%TYPE;
    v_ship_to_line3_adr    LWX_AR_STMT_LINES.SHIP_TO_LINE_3_ADR%TYPE;
    v_ship_to_line4_adr    LWX_AR_STMT_LINES.SHIP_TO_LINE_4_ADR%TYPE;
    v_ship_to_city_nme     LWX_AR_STMT_LINES.SHIP_TO_CITY_NME%TYPE;
    v_ship_to_state_cde    LWX_AR_STMT_LINES.SHIP_TO_STATE_CDE%TYPE;
    v_ship_to_postal_cde   LWX_AR_STMT_LINES.SHIP_TO_POSTAL_CDE%TYPE;
    v_ship_to_cntry_nme    LWX_AR_STMT_LINES.SHIP_TO_CNTRY_NME%TYPE;
    v_ship_to_country      AR.HZ_LOCATIONS.COUNTRY%TYPE;
    v_trans_dte            LWX_AR_STMT_LINES.TRANS_DTE%TYPE;
    v_due_dte              LWX_AR_STMT_LINES.DUE_DTE%TYPE;
    v_trans_nbr            LWX_AR_STMT_LINES.TRANS_NBR%TYPE;
    v_sls_chnl_nme         LWX_AR_STMT_LINES.SLS_CHNL_NME%TYPE;
    v_cust_ref_nme         LWX_AR_STMT_LINES.CUST_REF_NME%TYPE;
    v_fut_pmt_ind          LWX_AR_STMT_LINES.FUT_PMT_IND%TYPE;
    v_partial_pmt_ind      LWX_AR_STMT_LINES.PARTIAL_PMT_IND%TYPE;
    v_doc_ref_nme          LWX_AR_STMT_LINES.DOC_REF_NME%TYPE;
    v_term_msg1_nme        LWX_AR_STMT_LINES.TERM_MSG1_NME%TYPE;
    v_term_msg2_nme        LWX_AR_STMT_LINES.TERM_MSG2_NME%TYPE;
    v_cust_cont_nme        LWX_AR_STMT_LINES.CUST_CONT_NME%TYPE;
    v_cust_cont_phone_nbr  LWX_AR_STMT_LINES.CUST_CONT_PHONE_NBR%TYPE;
    v_order_dte            LWX_AR_STMT_LINES.ORDER_DTE%TYPE;
    v_ship_meth_nme        LWX_AR_STMT_LINES.SHIP_METH_NME%TYPE;
    v_sub_total_amt        LWX_AR_STMT_LINES.SUB_TOTAL_AMT%TYPE := 0;
    v_ship_hndl_amt        LWX_AR_STMT_LINES.SHIP_HNDL_AMT%TYPE := 0;
    v_tax_amt              LWX_AR_STMT_LINES.TAX_AMT%TYPE := 0;
    v_pmt_used_amt         LWX_AR_STMT_LINES.PMT_USED_AMT%TYPE := 0;
    v_total_due_amt        LWX_AR_STMT_LINES.TOTAL_DUE_AMT%TYPE := 0;
    v_mkt_msg1_nme         LWX_AR_STMT_LINES.MKT_MSG1_NME%TYPE;
    v_mkt_msg2_nme         LWX_AR_STMT_LINES.MKT_MSG2_NME%TYPE;
    v_mkt_msg3_nme         LWX_AR_STMT_LINES.MKT_MSG3_NME%TYPE;
    v_mkt_msg4_nme         LWX_AR_STMT_LINES.MKT_MSG4_NME%TYPE;
    v_term_message         ra_terms.DESCRIPTION%TYPE;
    v_ship_meth_code       OE_ORDER_HEADERS.SHIPPING_METHOD_CODE%TYPE;
    v_outstanding_amt      NUMBER;
    v_current_user         LWX_AR_STMT_LINES.CREATED_BY%TYPE;
    v_update_login         LWX_AR_STMT_LINES.LAST_UPDATE_LOGIN%TYPE;
    v_bill_to_customer_id  HZ_CUST_ACCOUNTS.CUST_ACCOUNT_ID%TYPE := 0;
    v_bill_to_party_id     HZ_PARTIES.PARTY_ID%TYPE := 0;
    v_installment_count    NUMBER := 0;
    v_intfc_header_context RA_CUSTOMER_TRX.INTERFACE_HEADER_CONTEXT%TYPE;
    v_trx_logo             LWX_AR_STMT_LINES.LOGO_CDE%TYPE;
    v_doc_type_nme         apps.FND_LOOKUP_VALUES_VL.MEANING%TYPE;
    v_class                ar.ar_payment_schedules_all.class%TYPE;
    v_term_id              ar.ra_customer_trx_all.term_id%TYPE;
    v_attribute3           ar.ra_customer_trx_all.attribute3%TYPE;
    v_attribute5           ar.ra_customer_trx_all.attribute5%TYPE;
    v_attribute6           ar.ra_customer_trx_all.attribute6%TYPE;
    v_attribute7           ar.ra_customer_trx_all.attribute7%TYPE;
    v_batch_source_name    ar.ra_batch_sources_all.name%TYPE;
    v_trx_line_dtl_cnt     PLS_INTEGER := 0; 
    v_org_id               ar.ra_batch_sources_all.org_id%TYPE;   
    v_interface_header_context   ar.ra_customer_trx_all.interface_header_context%TYPE;
    v_total_weight         VARCHAR2(2000);
    v_use_tax_message      VARCHAR2(2000);

--- Variables for lwx_split_line call
    v_msg1                 VARCHAR2(100);
    v_msg2                 VARCHAR2(100);
    v_msg3                 VARCHAR2(100);
    v_msg4                 VARCHAR2(100);
    v_msg_line_cnt         NUMBER;

    -- Transaction Line Detail Cursor Declaration
    CURSOR v_trx_line_dtl_cur(p_customer_trx_id IN NUMBER) IS
      SELECT ctl.REASON_CODE,
             ctl.CUSTOMER_TRX_LINE_ID,
             ctl.QUANTITY_ORDERED,
             ctl.QUANTITY_INVOICED,
             ctl.INVENTORY_ITEM_ID,
             ctl.UNIT_SELLING_PRICE,
             NVL(ctl.UNIT_STANDARD_PRICE, ctl.UNIT_SELLING_PRICE) UNIT_STANDARD_PRICE,
             NVL(ctl.EXTENDED_AMOUNT, 0) EXTENDED_AMOUNT,
             regexp_replace(REPLACE(REPLACE(REPLACE(NVL(ctl.TRANSLATED_DESCRIPTION,
                            ctl.DESCRIPTION),
                            '|',
                            ' '),
                            chr(10),
                            null),
                            chr(13),
                            null),'[[:space:]]+', chr(32))  DESCRIPTION  
        FROM ar.RA_CUSTOMER_TRX_LINES_all ctl
       WHERE CUSTOMER_TRX_ID = p_customer_trx_id
         AND LINE_TYPE NOT IN ('FREIGHT', 'TAX')
         AND ctl.inventory_item_id <> gn_freight_item
         AND NOT (DESCRIPTION = 'Tax' AND EXTENDED_AMOUNT = 0) 
       ORDER BY LINE_NUMBER; 

    CURSOR get_order_ship_meth_Cur(p_customer_trx_id IN NUMBER) IS
      SELECT DISTINCT OOH.ORDERED_DATE,
                      NVL(OOL.SHIPPING_METHOD_CODE,
                          OOH.SHIPPING_METHOD_CODE) SHIPPING_METHOD_CODE
        FROM ont.OE_ORDER_HEADERS_ALL      OOH,
             ont.OE_ORDER_LINES_ALL        OOL,
             ar.RA_CUSTOMER_TRX_LINES_ALL  RCTL
       WHERE RCTL.CUSTOMER_TRX_ID = p_customer_trx_id
         AND RCTL.SALES_ORDER_LINE IS NOT NULL
         AND RCTL.INTERFACE_LINE_CONTEXT = 'ORDER ENTRY'
         AND TO_NUMBER(RCTL.INTERFACE_LINE_ATTRIBUTE6) = OOL.LINE_ID
         AND OOL.HEADER_ID = OOH.HEADER_ID;

    CURSOR cur_invoice_xml_basic (cv_customer_trx_id number) IS 
           SELECT xmlagg(
                    xmlelement("TEMP",
                      xmlelement("Cons_Trans_Dte",to_char(psa.trx_date,'MM-DD-YYYY')),
                      xmlelement("Cons_Trans_Nbr",
                                 (CASE
                                   WHEN rct.interface_header_attribute1 is not NULL AND
                                         rct.INTERFACE_HEADER_CONTEXT = 'ORDER ENTRY' THEN       
                                         rct.trx_number || '(' || rct.interface_header_attribute1 || ')'
                                   ELSE rct.trx_number
                                  END)),
                      xmlelement("Cons_Page_Cnt",ltrim(to_char(v_xml_inv_page_cnt,'99999'))),
                      xmlelement("Cons_Logo_Cde",v_trx_logo),
                      xmlelement("Cons_Doc_Title_Nme",v_doc_type_nme),
                      xmlelement("Cons_Rep_Msg_Nme",
                                  substr('Questions concerning this ' ||
                                         v_doc_type_nme || ' Call:' ||
                                         rct.ATTRIBUTE4,1,60)),
                      xmlelement("Cons_Ship_To_Cust_Nbr",v_ship_to_cust_nbr),
                      xmlelement("Cons_Ship_To_Cust_Nme",v_ship_to_cust_nme),
                      xmlelement("Cons_Ship_To_Line_1_Adr",v_ship_to_line1_adr),
                      xmlelement("Cons_Ship_To_Line_2_Adr",v_ship_to_line2_adr),
                      xmlelement("Cons_Ship_To_Line_3_Adr",v_ship_to_line3_adr),
                      xmlelement("Cons_Ship_To_Line_4_Adr",v_ship_to_line4_adr),
                      xmlelement("Cons_Ship_To_City_Nme",v_ship_to_city_nme),
                      xmlelement("Cons_Ship_To_State_Cde",v_ship_to_state_cde),
                      xmlelement("Cons_Ship_To_Postal_Cde",v_ship_to_postal_cde),
                      xmlelement("Cons_Ship_To_Cntry_Nme",v_ship_to_cntry_nme),
                      xmlelement("Cons_Ship_To_Address",
                                  rtrim(v_ship_to_line1_adr||
                                        chr(13)||v_ship_to_line2_adr||
                                        chr(13)||v_ship_to_line3_adr||
                                        chr(13)||v_ship_to_line4_adr,chr(13))),
                      xmlelement("Cons_Ship_To_City_State_Zip",
                                  rtrim(v_ship_to_city_nme||
                                        ' '||v_ship_to_state_cde||
                                        ' '||v_ship_to_postal_cde)),
                      xmlelement("Cons_Bill_To_Cust_Nbr",v_bill_to_cust_nbr),
                      xmlelement("Cons_Bill_To_Cust_Nme",v_bill_to_cust_nme),
                      xmlelement("Cons_Bill_To_Line_1_Adr",v_bill_to_line1_adr),
                      xmlelement("Cons_Bill_To_Line_2_Adr",v_bill_to_line2_adr),
                      xmlelement("Cons_Bill_To_Line_3_Adr",v_bill_to_line3_adr),
                      xmlelement("Cons_Bill_To_Line_4_Adr",v_bill_to_line4_adr),
                      xmlelement("Cons_Bill_To_City_Nme",v_bill_to_city_nme),
                      xmlelement("Cons_Bill_To_State_Cde",v_bill_to_state_cde),
                      xmlelement("Cons_Bill_To_Postal_Cde",v_bill_to_postal_cde),
                      xmlelement("Cons_Bill_To_Cntry_Nme",v_bill_to_cntry_nme),
                      xmlelement("Cons_Bill_To_Address",
                                  rtrim(v_bill_to_line1_adr||
                                        chr(13)||v_bill_to_line2_adr||
                                        chr(13)||v_bill_to_line3_adr||
                                        chr(13)||v_bill_to_line4_adr,chr(13))),
                      xmlelement("Cons_Bill_To_City_State_Zip",
                                  rtrim(v_bill_to_city_nme||
                                        ' '||v_bill_to_state_cde||
                                        ' '||v_bill_to_postal_cde)),
                      xmlelement("Cons_Cust_Ref_Nme",
                                  regexp_replace(rct.PURCHASE_ORDER, '[^ -{^}~]', '')),
                      xmlelement("Cons_Term_Msg1_Nme",v_term_msg1_nme),   
                      xmlelement("Cons_Term_Msg2_Nme",v_term_msg2_nme),
                      xmlelement("Cons_Order_Dte",to_char(v_order_dte,'MM-DD-YYYY')),
                      xmlelement("Cons_Ship_Meth_Nme",v_ship_meth_nme),
                      xmlelement("Cons_Cust_Cont_Nme",v_cust_cont_nme),
                      xmlelement("Cons_Cust_Cont_Phone_Nbr",v_cust_cont_phone_nbr),
                      xmlelement("Cons_Sls_Chnl_Nme",
                                 (case
                                   when rct.interface_header_context = 'Interest Invoice' then 'LF'
                                   else rct.attribute5
                                  end)),                                
                      xmlelement("Cons_Mkt_Msg1_Nme",v_mkt_msg1_nme),  
                      xmlelement("Cons_Mkt_Msg2_Nme",v_mkt_msg2_nme),
                      xmlelement("Cons_Mkt_Msg3_Nme",v_mkt_msg3_nme),
                      xmlelement("Cons_Mkt_Msg4_Nme",v_mkt_msg4_nme),
                      xmlelement("Cons_Total_Weight",v_total_weight),
                      xmlelement("Cons_Sub_Total_Amt",v_sub_total_amt),
                      xmlelement("Cons_Sub_Total_Amt_Fmt",ltrim(to_char(v_sub_total_amt,'$999,999,999.00'))),                                
                      xmlelement("Cons_Ship_Hndl_Amt",v_ship_hndl_amt),
                      xmlelement("Cons_Ship_Hndl_Amt_Fmt",ltrim(to_char(v_ship_hndl_amt,'$999,999,999.00'))),                           
                      xmlelement("Cons_Tax_Amt",v_tax_amt),
                      xmlelement("Cons_Tax_Amt_Fmt",ltrim(to_char(v_tax_amt,'$999,999,999.00'))),                           
                      xmlelement("Cons_Inv_Total",(v_sub_total_amt + v_ship_hndl_amt + v_tax_amt)),
                      xmlelement("Cons_Inv_Total_Fmt",ltrim(to_char((v_sub_total_amt + v_ship_hndl_amt + v_tax_amt),'$999,999,999.00'))),                              
                      xmlelement("Cons_Pmt_Used_Amt",v_pmt_used_amt),
                      xmlelement("Cons_Pmt_Used_Amt_Fmt",ltrim(to_char(v_pmt_used_amt,'$999,999,999.00'))),                                
                      xmlelement("Cons_Total_Due_Amt",v_total_due_amt),
                      xmlelement("Cons_Total_Due_Amt_Fmt",ltrim(to_char(v_total_due_amt,'$999,999,999.00'))),                                
                      xmlelement("Cons_Cash_Receipt_Id",psa.cash_receipt_id),
                      xmlelement("Cons_Batch_Source_ID",rct.batch_source_id),
                      xmlelement("Item_Page_Del_Stmt_Nbr",
                                  (case
                                    when v_ship_to_cust_nbr = v_bill_to_cust_nbr then v_ship_to_cust_nbr
                                    else v_ship_to_cust_nbr || '/' || v_bill_to_cust_nbr                                          
                                   end))
                  ) -- End  Cons_Invoice element list
                  ).getClobVal() -- End xmlagg for Cons_Invoice
                  FROM   ar.ra_customer_trx_all      rct,
                         ar.ar_payment_schedules_all psa                  
                  WHERE  rct.customer_trx_id = cv_customer_trx_id
                  AND    rct.customer_trx_id = psa.customer_trx_id;                  

  BEGIN
    IF (pv_customer_trx_id is null) THEN 
        v_return := replace(v_error_xml,':ERROR:','No Customer Trx ID passed in!');
        dbms_output.put_line(':ERROR: No Customer Trx ID passed in!');
        goto return_results;
    END IF;

    v_org_id:= apps.fnd_profile.VALUE('ORG_ID');
    SELECT   rct.customer_trx_id,
             psa.class,
             rct.term_id,
             rct.attribute6,
             rct.attribute7,
             rct.attribute3,
             rct.attribute5,
             bsa.name,
             rct.interface_header_context
    INTO     v_customer_trx_id,
             v_class,
             v_term_id,
             v_attribute6,
             v_attribute7,
             v_attribute3,
             v_attribute5,
             v_batch_source_name,
             v_interface_header_context
    FROM     ar.ra_customer_trx_all                   rct,
             ar.ar_payment_schedules_all              psa,
             ar.hz_cust_accounts                      hca,
             ar.ra_batch_sources_all                  bsa
    WHERE    rct.customer_trx_id = pv_customer_trx_id
    AND      rct.customer_trx_id = psa.customer_trx_id
    AND      psa.customer_id = hca.cust_account_id
    AND      rct.batch_source_id = bsa.batch_source_id
    AND      bsa.org_id = v_org_id;

    -- Get Logo
    IF v_attribute3 = 'CRSP' THEN
       v_trx_logo:= 'CRD';
    ELSE
       IF SUBSTR(v_attribute3,3,2) = 'SP' THEN 
          v_trx_logo:= SUBSTR(v_attribute3,1,2);
       ELSE
          v_trx_logo:= v_attribute3;
       END IF;
    END IF;

    -- get v_doc_type_nme
    SELECT MEANING 
    INTO   v_doc_type_nme
    FROM   apps.FND_LOOKUP_VALUES_VL dc
    WHERE  dc.LOOKUP_TYPE = 'INV/CM'                       
    AND    dc.lookup_code = v_class;

    -- reset the term msg variables.
    v_term_msg1_nme := NULL;
    v_term_msg2_nme := NULL;

    -- Get Term Message
    IF v_term_id IS NOT NULL THEN
      SELECT DESCRIPTION
        INTO v_term_message
        FROM ra_terms
       WHERE TERM_ID = v_term_id;
      IF LENGTH(RTRIM(v_term_message)) > 40 THEN
        v_term_msg1_nme := SUBSTR(v_term_message, 1, 40);
        v_term_msg2_nme := SUBSTR(v_term_message,
                                  INSTR(v_term_message, ' ', -1, 1));
      ELSE
        v_term_msg1_nme := v_term_message;
        v_term_msg2_nme := NULL;
      END IF;
    END IF; -- End of checking v_term_id

    -- Get Order Date and Shipping Method
    v_order_dte      := NULL;
    v_ship_meth_code := NULL;

    FOR get_order_ship_meth_Rec IN get_order_ship_meth_Cur(p_customer_trx_id => v_customer_trx_id) LOOP
      v_order_dte      := get_order_ship_meth_Rec.ordered_date;
      v_ship_meth_code := get_order_ship_meth_Rec.shipping_method_code;
    END LOOP; -- End of get_order_ship_meth_Cur cursor.
                      
    IF v_ship_meth_code IS NOT NULL THEN
      -- Get the Shipping Method Name
      SELECT SHIP_METHOD_MEANING
        INTO v_ship_meth_nme
        FROM apps.WSH_CARRIER_SERVICES_V
       WHERE SHIP_METHOD_CODE = v_ship_meth_code;
    END IF; -- End of v_ship_meth_code check.
   
    -- Get Contact Info
    Get_Bill_To_Contact_Info(p_bill_to_customer_id => v_bill_to_customer_id,
                             p_cust_cont_phone_nbr => v_cust_cont_phone_nbr,
                             p_cust_cont_nme       => v_cust_cont_nme,
                             p_customer_trx_id     => v_customer_trx_id,
                             p_retcode             => v_retcode);
    IF v_retcode <> 0 THEN
      v_cust_cont_phone_nbr :=  '';
      v_cust_cont_nme       :=  '';
    END IF;  
       
    v_mkt_msg1_nme        := SUBSTR(v_attribute6,1,INSTR(v_attribute6, '|') - 1);
    v_mkt_msg2_nme        := SUBSTR(v_attribute6,INSTR(v_attribute6, '|') + 1);
    v_mkt_msg3_nme        := SUBSTR(v_attribute7,1,INSTR(v_attribute7, '|') - 1);
    v_mkt_msg4_nme        := SUBSTR(v_attribute7,INSTR(v_attribute7, '|') + 1);

    -- Get summary amounts
    get_line_amounts(v_customer_trx_id,
                     v_sub_total_amt, 
                     v_ship_hndl_amt, 
                     v_tax_amt,
                     v_pmt_used_amt);
    v_total_due_amt := (v_sub_total_amt + v_ship_hndl_amt + v_tax_amt) -
                        v_pmt_used_amt;

  -- Find Bill_To Address from the invoice.  Jude Lam 04/26/06 Update
    BEGIN
      SELECT loc.ADDRESS1,
             loc.ADDRESS2,
             loc.ADDRESS3,
             loc.ADDRESS4,
             loc.CITY,
             loc.COUNTRY,
             substr(loc.STATE,1,2),
             substr(loc.POSTAL_CODE,1,12),
             terr.TERRITORY_SHORT_NAME,
             HP.PARTY_NAME,
             party_site.addressee,
             HCA.ACCOUNT_NUMBER,
             HCA.CUST_ACCOUNT_ID,
             HP.PARTY_ID
      INTO   v_bill_to_line1_adr,
             v_bill_to_line2_adr,
             v_bill_to_line3_adr,
             v_bill_to_line4_adr,
             v_bill_to_city_nme,
             v_bill_to_country,
             v_bill_to_state_cde,
             v_bill_to_postal_cde,
             v_bill_to_cntry_nme,
             v_bill_to_cust_nme,
             v_bill_to_addressee,
             v_bill_to_cust_nbr,
             v_bill_to_customer_id,
             v_bill_to_party_id
      FROM   apps.FND_TERRITORIES_VL         terr,
             ar.HZ_CUST_ACCT_SITES_ALL       addr,
             ar.HZ_PARTY_SITES               party_site,
             ar.HZ_CUST_SITE_USES_ALL        csu,
             ar.HZ_LOCATIONS                 loc,
             ar.RA_CUSTOMER_TRX_ALL          RCT,
             ar.HZ_PARTIES                   HP,
             ar.HZ_CUST_ACCOUNTS             HCA
      WHERE  RCT.BILL_TO_SITE_USE_ID = CSU.SITE_USE_ID
        AND  CSU.CUST_ACCT_SITE_ID = ADDR.CUST_ACCT_SITE_ID
        AND  ADDR.PARTY_SITE_ID = PARTY_SITE.PARTY_SITE_ID
        AND  PARTY_SITE.LOCATION_ID = LOC.LOCATION_ID
        AND  PARTY_SITE.PARTY_ID = HP.PARTY_ID
        AND  LOC.COUNTRY = TERR.TERRITORY_CODE(+)
        AND  RCT.CUSTOMER_TRX_ID = v_customer_trx_id
        AND  ADDR.CUST_ACCOUNT_ID = HCA.CUST_ACCOUNT_ID;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        dbms_output.put_line('Did not work');
    END;  

    -- Find Ship_To Address
    BEGIN
      SELECT loc.ADDRESS1,
             loc.ADDRESS2,
             loc.ADDRESS3,
             loc.ADDRESS4,
             loc.CITY,
             loc.COUNTRY,
             substr(loc.STATE,1,2),
             substr(loc.POSTAL_CODE,1,12),
             terr.TERRITORY_SHORT_NAME,
             HP.PARTY_NAME,
             party_site.addressee,
             HCA.ACCOUNT_NUMBER
        INTO v_ship_to_line1_adr,
             v_ship_to_line2_adr,
             v_ship_to_line3_adr,
             v_ship_to_line4_adr,
             v_ship_to_city_nme,
             v_ship_to_country,
             v_ship_to_state_cde,
             v_ship_to_postal_cde,
             v_ship_to_cntry_nme,
             v_ship_to_cust_nme,
             v_ship_to_addressee,
             v_ship_to_cust_nbr
        FROM apps.FND_TERRITORIES_VL   terr,
             ar.HZ_CUST_ACCT_SITES_ALL addr,
             ar.HZ_PARTY_SITES         party_site,
             ar.HZ_CUST_SITE_USES_ALL  csu,
             ar.HZ_LOCATIONS           loc,
             ar.RA_CUSTOMER_TRX_ALL    RCT,
             ar.HZ_PARTIES             HP,
             ar.HZ_CUST_ACCOUNTS       HCA
       WHERE NVL(RCT.SHIP_TO_SITE_USE_ID, -999) = CSU.SITE_USE_ID
         AND CSU.CUST_ACCT_SITE_ID = ADDR.CUST_ACCT_SITE_ID
         AND ADDR.PARTY_SITE_ID = PARTY_SITE.PARTY_SITE_ID
         AND PARTY_SITE.LOCATION_ID = LOC.LOCATION_ID
         AND PARTY_SITE.PARTY_ID = HP.PARTY_ID
         AND LOC.COUNTRY = TERR.TERRITORY_CODE(+)
         AND RCT.CUSTOMER_TRX_ID = v_customer_trx_id
         AND ADDR.CUST_ACCOUNT_ID = HCA.CUST_ACCOUNT_ID;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        v_ship_to_line1_adr  := v_bill_to_line1_adr;
        v_ship_to_line2_adr  := v_bill_to_line2_adr;
        v_ship_to_line3_adr  := v_bill_to_line3_adr;
        v_ship_to_line4_adr  := v_bill_to_line4_adr;
        v_ship_to_city_nme   := v_bill_to_city_nme;
        v_ship_to_state_cde  := v_bill_to_state_cde;
        v_ship_to_postal_cde := v_bill_to_postal_cde;
        v_ship_to_country    := v_bill_to_country;
        v_ship_to_cntry_nme  := v_bill_to_cntry_nme;
        v_ship_to_cust_nme   := v_bill_to_cust_nme;
        v_ship_to_addressee  := v_bill_to_addressee;
        v_ship_to_cust_nbr   := v_bill_to_cust_nbr;
    END; -- End of getting ship-to address block.

    -- Append Addressee for ship-to
    IF v_ship_to_line3_adr IS NULL AND
       v_ship_to_line4_adr IS NULL AND
       v_ship_to_addressee IS NOT NULL THEN
       v_ship_to_line3_adr := v_ship_to_line2_adr;
       v_ship_to_line2_adr := v_ship_to_line1_adr;
       v_ship_to_line1_adr := v_ship_to_addressee;
    END IF;   

    -- Get Use Tax Message
    SELECT lwx_get_use_tax_message(decode(v_ship_to_country,'PR','PR','US',nvl(v_ship_to_state_cde,'**'),''))
      INTO v_use_tax_message
      FROM DUAL;
    IF v_use_tax_message IS NOT NULL THEN
      v_msg_line_cnt:= lwx_split_line(v_use_tax_message,v_msg1,v_msg2,v_msg3,v_msg4);
      v_mkt_msg1_nme:= NULL;
      v_mkt_msg2_nme:= NULL;
      v_mkt_msg3_nme:= NULL;
      v_mkt_msg4_nme:= NULL;
      FOR k in 1..v_msg_line_cnt LOOP
        IF k = 1 THEN
          v_mkt_msg1_nme := v_msg1;
        END IF;  
        IF k = 2 THEN
          v_mkt_msg2_nme := v_msg2;
        END IF;  
        IF k = 3 THEN
          v_mkt_msg3_nme := v_msg3;
        END IF;  
        IF k = 4 THEN
          v_mkt_msg4_nme := v_msg4;
        END IF;  
      END LOOP;
    END IF;            

    -- Get Weight
   v_total_weight:= NULL;
   SELECT lwx_ar_invo_stmt_print.Lwx_Get_Total_Weight(v_customer_trx_id,v_interface_header_context)
   INTO   v_total_weight
   FROM   DUAL;
      
    v_openitem_cur_rec.CUSTOMER_TRX_ID:= v_customer_trx_id;
    v_cm_printed_flag := 'N';

    -- Initialize Invoice Item Variables
    v_xml_inv_first_item         := 0;
    v_xml_inv_page_cnt           := 0;
    v_xml_inv_line_cnt           := 0;  

    IF v_batch_source_name = 'JDA_ORA_AR_INVOICES' OR 
       v_batch_source_name = 'D365_ORA_AR_INVOICES' THEN
       -- Set transaction line detail count to 1
       v_trx_line_dtl_cnt := 1;
       -- Insert New Record into the LWX_AR_STMT_LINE_DETAILS Table
       -- Call to Insert New Record into the LWX_AR_STMT_LINE_DETAILS Table
       -- Stores Name and Phone Number (SNP)
       Lwx_Ar_Build_Line_Details_XML
         ('SNP',
          v_class, -- v_openitem_rec.TYPE,
          v_trx_line_dtl_cnt,
          v_openitem_cur_rec,
          v_trx_line_dtl_cur_rec,
          v_retcode);
    ELSE
       -- Invoice/Credit Memo Not from JDA/D365
       -- Set transaction line detail count to 0
       v_trx_line_dtl_cnt := 0;
    END IF; -- End of Check for Invoice/Credit Memo from JDA/D365

    FOR v_trx_line_dtl_rec IN v_trx_line_dtl_cur(v_customer_trx_id) LOOP
        -- Assign Customer details to the Record Type variables
        v_process_stage                             := 'Assign Transaction Line Detail Cursor Record Values to the Type Record';
        v_trx_line_dtl_cur_rec.REASON_CODE          := v_trx_line_dtl_rec.REASON_CODE;
        v_trx_line_dtl_cur_rec.CUSTOMER_TRX_LINE_ID := v_trx_line_dtl_rec.CUSTOMER_TRX_LINE_ID;
        v_trx_line_dtl_cur_rec.QUANTITY_ORDERED     := v_trx_line_dtl_rec.QUANTITY_ORDERED;
        v_trx_line_dtl_cur_rec.QUANTITY_INVOICED    := v_trx_line_dtl_rec.QUANTITY_INVOICED;
        v_trx_line_dtl_cur_rec.INVENTORY_ITEM_ID    := v_trx_line_dtl_rec.INVENTORY_ITEM_ID;
        v_trx_line_dtl_cur_rec.UNIT_SELLING_PRICE   := v_trx_line_dtl_rec.UNIT_SELLING_PRICE;
        v_trx_line_dtl_cur_rec.UNIT_STANDARD_PRICE  := v_trx_line_dtl_rec.UNIT_STANDARD_PRICE;
        v_trx_line_dtl_cur_rec.EXTENDED_AMOUNT      := v_trx_line_dtl_rec.EXTENDED_AMOUNT;
        v_trx_line_dtl_cur_rec.DESCRIPTION          := v_trx_line_dtl_rec.DESCRIPTION;

        IF v_class = 'CM' AND
           v_cm_printed_flag = 'N' THEN
           -- Call to Insert Memo Message into LWX_AR_STMT_LINE_DETAILS
           -- Reason DESCRIPTION Text (RDT)
           v_process_stage := 'Call Procedure to Insert into Line Details Table with Reason DESCRIPTION Text ';
           Lwx_Ar_Build_Line_Details_XML
              ('RDT',
               v_class,
               v_trx_line_dtl_cnt,
               v_openitem_cur_rec,
               v_trx_line_dtl_cur_rec,
               v_retcode);
           v_cm_printed_flag := 'Y';
        END IF; -- End of Check for Credit Memo

        Lwx_Ar_Build_Line_Details_XML
           ('',
            v_class,
            v_trx_line_dtl_cnt,
            v_openitem_cur_rec,
            v_trx_line_dtl_cur_rec,
            v_retcode);

        v_process_stage := 'Check the Current Line whether linked to an Inventory Item.';

        IF nvl(v_trx_line_dtl_rec.INVENTORY_ITEM_ID, -999) != -999 THEN
          SELECT msib.INVENTORY_ITEM_STATUS_CODE
            INTO v_inv_item_status_code
            FROM inv.MTL_SYSTEM_ITEMS_B msib
           WHERE msib.ORGANIZATION_ID = lwx_fnd_utility.master_org
             AND msib.INVENTORY_ITEM_ID = v_trx_line_dtl_rec.INVENTORY_ITEM_ID;

          IF v_inv_item_status_code = 'NYP' AND
             v_batch_source_name = 'Order Management' THEN
             -- Insert a new record into the LWX_AR_STMT_LINE_DETAILS
             -- Call to Insert Cursor Record into the LWX_AR_STMT_LINE_DETAILS
             v_process_stage := 'Call Procedure to Insert into Line Details Table with Expected Publish Date';
             Lwx_Ar_Build_Line_Details_XML
                ('NYP',
                 v_class,
                 v_trx_line_dtl_cnt,
                 v_openitem_cur_rec,
                 v_trx_line_dtl_cur_rec,
                 v_retcode);
          END IF; -- End of Check to Invoice Item Status for NYP/OS
        END IF; -- End of checking inventory item id.
    END LOOP; -- End of Trx Line Detail cursor

    OPEN cur_invoice_xml_basic (pv_customer_trx_id);  
    FETCH cur_invoice_xml_basic INTO v_temp_clob;  

    IF (cur_invoice_xml_basic%NOTFOUND) THEN    
           v_return := replace(v_error_xml,':ERROR:','No invoice found!');
    END IF;
    CLOSE cur_invoice_xml_basic;  
  
    v_temp_clob:= dbms_lob.substr(v_temp_clob,32767,7);
    v_temp_clob:= dbms_lob.substr(v_temp_clob,(length(v_temp_clob) -7));

    v_xml_inv_body:= v_temp_clob;
  
    v_xml_inv_finished:= '<ConsolidatedInvoices><Cons_Invoice>'
                      || v_xml_inv_body
                      || v_xml_inv_element
                      || '</Cons_Inv_Item_Page></Cons_Inv_Item_List>'
                      || '</Cons_Invoice></ConsolidatedInvoices>';


    v_return:= v_xml_inv_finished;

    <<return_results>>
    RETURN v_return;  

  END get_invoice_xml;    

   PROCEDURE Generate_Con_Stmt(errbuf                OUT VARCHAR2,
                              retcode               OUT NUMBER,
                              p_statement_cycle_nme IN VARCHAR2,
                              p_customer_nbr        IN VARCHAR2,
                              p_stmt_as_of_date     IN VARCHAR2,
                              p_debug_flag          IN VARCHAR2) IS

    --- ***************************************************************************************************************
    ---   Program Description:  This is the program that will generate the data file needed by the Heidelberg
    ---                           Printer software.
    ---
    ---   Parameters Used      :  errbuf            - Out type parameter to return Error message from the concurrent
    ---                           retcode           - Out type parameter to return the concurrent status
    ---   p_statement_cycle_nme - In type parameter. This parameter will contain the
    ---                          statement cycle name from the AR_STATEMENT_CYCLES
    ---                          table.  This field is an optional field.If this field
    ---                          is blank, the program should process all statement
    ---                          cycles.  If this field is specified, only the customer
    ---                          that has the statement cycle assigned in their customer
    ---                          header level profile will be considered.
    ---
    ---  Development and Maintenance History:
    ---  -------------------------------------
    ---  DATE         AUTHOR                   DESCRIPTION
    ---  ----------   ------------------------ ---------------------------------------------------------
    ---  20-DEC-2005  S Saravana Bhavan, BCT   Initial Creation
    ---  14-MAR-2006  Rajmohan K, BCT          Added debug message for log file
    ---  2006-04-25   Jude Lam, TITAN          Re-arrange some of the major logic in the detail lines sections.
    ---  2006-07-20   Jude Lam, TITAN          Updated the Generate_Con_Stmt to modify the V_DUE_AMT logic.
    ---  2006-08-25   Jude Lam, TITAN          Updated the Generate_Con_Stmt main query for open items to include close item
    ---                                           that are within the current statement cycle.
    ---  2006-08-30   Jude Lam, TITAN          Updated the Generate_Con_Stmt query for open item to add the time portion.
    ---                                        Updated the Prepayment section to delete F3 record if there is any.
    ---  2006-09-08   Jude Lam, TITAN          Updated the Generate_Con_Stmt so that if the customer has a negative balance,
    ---                                           statement will still be generated.
    ---  2006-09-08   Jude Lam, TITAN          Update the Generate_Con_Stmt parameter for p_stmt_as_of_date to be VARCHAR2 character.
    ---                                        Updated Generate_Con_Stmt to ignore statement date for credit items when
    ---                                           calculate over due and due amount.
    ---  2006-10-17   Jude Lam, TITAN          Updated queries to use base tables instead of views for performance tuning.
    ---  2007-08-09   I. Balodis, TITAN        Added the sales order number to the invoices that merge with statements
    ---  2007-08-13   David Howard, TITAN      Removed the Global statement date query line from the payment schedule query to allow
    ---                                          future dates to print in the invoice print program
    ---  2008-03-19   David Howard	           Update to return greater of due_dte and creation_date
    ---  2008-07-07   Greg Wright              Modified to not consolidate credit card invoices.
    ---  2009-11-12   Jason McCleskey          P-1640 - Modifications for prepay handling
    ---                                           Also changes for performance, proceduralized and readability
    ---  2010-02-24   Jason McCleskey          P-1725 - Do not consolidate Prospect Services (Lexinet) invoices (Sales Channel = 'PS')    
    ---  2012-01-13   Greg Wright              Prevents consolidation of invoices when language='Es'.
    ---  2017-08-15   Greg Wright              OF-2899 Flash Commerce
    ---  2020-02-18   Rich Stewart             OF-3392 Change use of due dates in statement generation:
    ---                                        delay the due date of payments by the amount by which the difference
    ---                                        between the statement date and preceding/last statement date exceeds 30
    ---                                        days.  I.e., when the statement date and preceding/last statement date
    ---                                        are between 30 and 40 days apart, then delay the due date by the amount
    ---                                          "statement date" - ("preceding/last statement date" + "30 days")
    ---                                        This delay/adjustment amount is added to the line-item due-date when
    ---                                        comparing it to the "statement date" wherever the program is choosing line-item
    ---                                        amounts to add to the "overdue amount."
    ---                                        This v_due_date_adjustment is a package-level global variable calculated
    ---                                        here.
    --- ***************************************************************************************************************

    -- Local varibles declaration
    v_process_stage          VARCHAR2(240);
    v_current_open_balance   NUMBER := 0;
    v_total_record_cnt       NUMBER := 0;
    v_invo_page_cnt          NUMBER := 0;
    v_total_page_cnt         NUMBER := 0;
    v_ovr_due_amt            NUMBER := 0;
    v_due_amt                NUMBER := 0;
    v_to_pay_amt             NUMBER := 0;
    v_to_pay_amt_ocr         NUMBER := 0;
    v_no_due_amt             NUMBER := 0;
    v_balance_amt            NUMBER := 0;
    v_printing_count         NUMBER := 0;
    v_prev_statment_run_cnt  NUMBER := 0;
    v_page_number            NUMBER := 0;
    v_term_count             NUMBER := 0;
    v_ppd_page_cnt           NUMBER := 0;
    v_dtl_page_cnt           NUMBER := 0;
    v_ppd_page_cnt_2         NUMBER := 0;
    v_dtl_page_cnt_2         NUMBER := 0;
    v_actual_ovr_due_amt     NUMBER := 0;
    v_printing_original_date DATE;
    v_trx_line_dtl_cnt       PLS_INTEGER := 0;
    v_stmt_line_cnt          PLS_INTEGER := 0;
    v_trx_line_dtl_rec_cnt   NUMBER := 0;
    v_org_id                 HZ_CUST_ACCT_SITES.ORG_ID%TYPE;
    v_min_statement_amount   HZ_CUST_PROFILE_AMTS.MIN_STATEMENT_AMOUNT%TYPE;
    v_statement_days         NUMBER;
    v_choice                 AR_PAYMENT_SCHEDULES.CLASS%TYPE;
    v_trx_type               AR_PAYMENT_SCHEDULES.CLASS%TYPE;
    v_customer_trx_id        AR_PAYMENT_SCHEDULES.CUSTOMER_TRX_ID%TYPE;
    v_term_sequence_number   AR_PAYMENT_SCHEDULES.TERMS_SEQUENCE_NUMBER%TYPE;
    v_batch_source_name      RA_BATCH_SOURCES_ALL.NAME%TYPE;
    v_inv_item_status_code   MTL_SYSTEM_ITEMS_B.INVENTORY_ITEM_STATUS_CODE%TYPE;
    v_scan_line_nme          LWX_AR_STMT_HEADERS.SCAN_LINE_NME%TYPE;

    -- Record Type variable declaration
    v_customer_cur_rec       v_customer_cur_rec_type;
    v_openitem_cur_rec       v_openitem_cur_rec_type;
    v_trx_line_dtl_cur_rec   v_trx_line_dtl_cur_rec_type;
    v_when_others            exception;
    v_cm_printed_flag        VARCHAR2(1) := 'N';
    v_master_org_id          NUMBER;
    v_good_sites             BOOLEAN;
    t_customer_address1      HZ_LOCATIONS.ADDRESS1%TYPE;
    t_customer_address2      HZ_LOCATIONS.ADDRESS2%TYPE;
    t_customer_address3      HZ_LOCATIONS.ADDRESS3%TYPE;
    t_customer_address4      HZ_LOCATIONS.ADDRESS4%TYPE;
    t_customer_city          HZ_LOCATIONS.CITY%TYPE;
    t_customer_state         HZ_LOCATIONS.STATE%TYPE;
    t_customer_postal_code   HZ_LOCATIONS.POSTAL_CODE%TYPE;
    t_customer_country       FND_TERRITORIES_VL.TERRITORY_SHORT_NAME%TYPE;
    t_cust_acct_site_id      HZ_CUST_ACCT_SITES.CUST_ACCT_SITE_ID%TYPE;

     CURSOR v_stmt_dtl_f4_cur(v_stmt_line_id IN NUMBER) IS
      SELECT LINE_TYPE_CDE,
             ORDERED_QTY_CNT,
             SHIPPED_QTY_CNT,
             ALT_ITEM_NBR,
             ITEM_NBR,
             LINE_DESC_TXT,
             SELLING_PRICE_AMT,
             SELLING_DISC_AMT,
             EXTENDED_AMT,
             CUSTOMER_TRX_LINE_ID
        FROM LWX_AR_STMT_LINE_DETAILS
       WHERE STMT_LINE_ID = v_stmt_line_id
       ORDER BY STMT_LINE_DTL_ID;

    -- SQL #2
    -- Customer Cursor Declaration
    CURSOR v_customer_cur IS
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
         AND sc.NAME = p_statement_cycle_nme
         AND sc.statement_cycle_id = hcp.statement_cycle_id
         AND hcpc.profile_class_id(+) = hcp.profile_class_id
         AND ac.account_NUMBER = NVL(p_customer_nbr, ac.account_NUMBER)
         AND ac.party_id = hp.party_id
         AND hcp.send_STATEMENTS = 'Y'
         AND ac.sales_channel_code = sclv.lookup_code (+);

    -- SQL #4
    -- Open Item Cursor Declaration
    -- Jude Lam 05/02/06 modify the where clause.

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
       WHERE aps.CUSTOMER_ID = p_customer_id
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
              END) IS NULL;

    -- SQL #6
    -- Pre-pay Cursor Declaration
    CURSOR v_prepay_cur( p_customer_id      NUMBER,
                         pd_last_stmt_date  DATE,
                         pd_stmt_date       DATE) IS
      SELECT APS.PAYMENT_SCHEDULE_ID,
             APS.STATUS,
             APS.CASH_RECEIPT_ID,
             APS.CASH_APPLIED_DATE_LAST,
             APS.TRX_NUMBER,
             APS.TRX_DATE,
             APS.CLASS,
             APS.AMOUNT_DUE_REMAINING,
             APS.AMOUNT_DUE_ORIGINAL,
             APS.DUE_DATE,
             DTYP.DOC_TYPE_NME,
             CRA.COMMENTS TRUE_COMMENTS
        FROM AR_PAYMENT_SCHEDULES       APS,
             AR_CASH_RECEIPTS_ALL       CRA,
             (-- Document Type Sub Table 
              SELECT LOOKUP_CODE, MEANING doc_type_nme
              FROM FND_LOOKUP_VALUES_VL
              WHERE LOOKUP_TYPE = 'INV/CM') dtyp
       WHERE APS.CUSTOMER_ID = p_customer_id
         AND APS.CLASS = 'PMT'
         AND (APS.STATUS = 'OP' 
              OR
              APS.CASH_APPLIED_DATE_LAST BETWEEN TRUNC(pd_last_stmt_date) AND pd_stmt_date)
         AND APS.CASH_RECEIPT_ID = CRA.CASH_RECEIPT_ID
         AND APS.PAYMENT_SCHEDULE_ID = get_prepay(aps.payment_schedule_id,'Y','N')
         AND aps.class = dtyp.lookup_code (+)
       ORDER BY APS.PAYMENT_SCHEDULE_ID;

    -- SQL #7
    -- Transaction Line Detail Cursor Declaration
    CURSOR v_trx_line_dtl_cur(p_customer_trx_id IN NUMBER) IS
      SELECT ctl.REASON_CODE,
             ctl.CUSTOMER_TRX_LINE_ID,
             ctl.QUANTITY_ORDERED,
             ctl.QUANTITY_INVOICED,
             ctl.INVENTORY_ITEM_ID,
             ctl.UNIT_SELLING_PRICE,
             NVL(ctl.UNIT_STANDARD_PRICE, ctl.UNIT_SELLING_PRICE) UNIT_STANDARD_PRICE,
             NVL(ctl.EXTENDED_AMOUNT, 0) EXTENDED_AMOUNT,
             --             NVL(ctl.TRANSLATED_DESCRIPTION, ctl.DESCRIPTION) DESCRIPTION -- Jude Lam 05/08/06 update to use translated_description field first.
             REPLACE(REPLACE(REPLACE(NVL(ctl.TRANSLATED_DESCRIPTION,
                                         ctl.DESCRIPTION),
                                     '|',
                                     ' '),
                             chr(10),
                             null),
                     chr(13),
                     null) DESCRIPTION -- Jude Lam 10/17/06 update.
        FROM RA_CUSTOMER_TRX_LINES ctl
       WHERE CUSTOMER_TRX_ID = p_customer_trx_id
         AND LINE_TYPE NOT IN ('FREIGHT', 'TAX')
         AND NOT (DESCRIPTION = 'Tax' AND EXTENDED_AMOUNT = 0) -- Jude Lam 09/06/06 to ignore those dummy tax lines from interface and conversion..
       ORDER BY LINE_NUMBER; -- Jude Lam 04/26/06 update to exclude freight and tax line.

    -- Declartion of Cash Receipt Items
    -- Cash Receipts Cursor Declaration
    -- Jude Lam 05/03/06 Rewrite the Prepayment section.  So commenting the following cursor out.
    CURSOR v_cash_receipts_cur(p_cash_receipt_id IN NUMBER) IS
      SELECT ARA.APPLIED_PAYMENT_SCHEDULE_ID,
             APS.TRX_NUMBER,
             APS.TRX_DATE,
             APS.CLASS,
             APS.AMOUNT_DUE_ORIGINAL,
             APS.AMOUNT_DUE_REMAINING,
             APS.DUE_DATE,
             ARA.CASH_RECEIPT_ID,
             RCT.PRINTING_OPTION DEFAULT_PRINTING_OPTION,
             APS.TERM_ID,
             APS.TERMS_SEQUENCE_NUMBER,
             RCT.ATTRIBUTE3,
             RCT.ATTRIBUTE4,
             RCT.ATTRIBUTE5,
             RCT.ATTRIBUTE6,
             RCT.ATTRIBUTE7,
             RCT.PURCHASE_ORDER,
--gw             replace(replace(RCT.COMMENTS,CHR(10),' '),CHR(13),'') COMMENTS, -- Jude Lam 05/17/06 Update  Added this field.
             regexp_replace(rct.COMMENTS, '[^ -{^}~]', '') COMMENTS,
             RCTT.TYPE,
             APS.CUSTOMER_TRX_ID,
             APS.PAYMENT_SCHEDULE_ID,
             DTYP.DOC_TYPE_NME
        FROM AR_RECEIVABLE_APPLICATIONS ARA,
             AR_PAYMENT_SCHEDULES       APS,
             RA_CUSTOMER_TRX            RCT,
             RA_CUST_TRX_TYPES          RCTT,
             (-- Document Type Sub Table 
              SELECT LOOKUP_CODE, MEANING doc_type_nme
              FROM FND_LOOKUP_VALUES_VL
              WHERE LOOKUP_TYPE = 'INV/CM') dtyp             
       WHERE ARA.CASH_RECEIPT_ID = p_cash_receipt_id
         AND NVL(ARA.APPLIED_PAYMENT_SCHEDULE_ID, -999) > 0
         AND ARA.APPLIED_PAYMENT_SCHEDULE_ID = APS.PAYMENT_SCHEDULE_ID
         AND APS.CUSTOMER_TRX_ID = RCT.CUSTOMER_TRX_ID
         AND RCT.CUST_TRX_TYPE_ID = RCTT.CUST_TRX_TYPE_ID
         AND APS.CLASS = DTYP.LOOKUP_CODE (+);

  --- ***************************************************************************************************************
  --- Function check_display
  --- Description
  ---    This function will use the customer trx line id to check to see if the current line needs to be displayed.
  ---    This is needed to distinguish the regular shipping and handling versus those special charges.
  --- ***************************************************************************************************************
  FUNCTION check_display(p_customer_trx_line_id IN NUMBER) RETURN BOOLEAN IS
    v_process_stage VARCHAR2(600) := NULL;

    v_intfc_line_context    RA_CUSTOMER_TRX_LINES.INTERFACE_LINE_CONTEXT%TYPE;
    v_intfc_line_attribute6 RA_CUSTOMER_TRX_LINES.INTERFACE_LINE_ATTRIBUTE6%TYPE;
    v_sales_order_line      RA_CUSTOMER_TRX_LINES.SALES_ORDER_LINE%TYPE;
    v_inventory_item_id     RA_CUSTOMER_TRX_LINES.INVENTORY_ITEM_ID%TYPE;
    v_charge_type_code      OE_PRICE_ADJUSTMENTS.CHARGE_TYPE_CODE%TYPE;

  BEGIN

    -- First check to see if the p_customer_trx_line_id is not null.
    IF p_customer_trx_line_id IS NULL THEN
      RETURN TRUE;
    ELSE
      v_process_stage := 'Retrieving ra_customer_trx_line info. using p_customer_trx_line_id: ' ||
                         to_char(p_customer_trx_line_id);

      SELECT INTERFACE_LINE_CONTEXT,
             INTERFACE_LINE_ATTRIBUTE6,
             SALES_ORDER_LINE,
             INVENTORY_ITEM_ID
        INTO v_intfc_line_context,
             v_intfc_line_attribute6,
             v_sales_order_line,
             v_inventory_item_id
        FROM RA_CUSTOMER_TRX_LINES
       WHERE CUSTOMER_TRX_LINE_ID = p_customer_trx_line_id;

      -- Check to see if the current line item is a freight item.
      IF nvl(v_inventory_item_id, -999) =
--       to_number(fnd_profile.value('OE_INVENTORY_ITEM_FOR_FREIGHT')) THEN
         gn_freight_item THEN        -- Freight item.  Now check to see if this is coming from OM and if it is, check the charge type code.
        IF v_intfc_line_context = 'ORDER ENTRY' THEN
          -- retrieve the charge type code.
          v_process_stage := 'Retrieve data from oe_price_adjustments using interface line attribute6 value: ' ||
                             v_intfc_line_attribute6;

          BEGIN
            SELECT CHARGE_TYPE_CODE
              INTO v_charge_type_code
              FROM OE_PRICE_ADJUSTMENTS
             WHERE PRICE_ADJUSTMENT_ID = TO_NUMBER(v_intfc_line_attribute6);

            IF v_charge_type_code = 'SHIPPING AND PROCESSING' THEN
              -- Regular freight, and therefore, don't display it.
              RETURN FALSE;
            ELSE
              RETURN TRUE;
            END IF;

          EXCEPTION
            WHEN NO_DATA_FOUND THEN
              RETURN TRUE;
          END;
        ELSE
          -- Non OM transaction.  Any line that charges to the item will be treated as a regular shipping and
          -- therefore, not to display the line.
          RETURN FALSE;
        END IF; -- End of checking Interface line context = ORDER ENTRY
      ELSE
        -- Not a freight item.  So display the line.
        RETURN TRUE;
      END IF;

    END IF; -- End of checking p_customer_trx_line_id IS NULL.

  EXCEPTION
    WHEN OTHERS THEN
      log('l',
                        'ERROR in check_display with v_process_stage: ');
      log('l', v_process_stage);
      log('l',
                        'SQLCODE: ' || sqlcode || ' SQLERRM: ' ||
                        sqlerrm);
      ROLLBACK;
      app_error(-20001,'ERROR in check_display.  Please check the log file.');
  END check_display;

  BEGIN
    -- Assign debug mode to the variable.
    g_debug_mode    := p_debug_flag;
    v_master_org_id := lwx_fnd_utility.master_org;

    -- Get Org id from the profile
    v_org_id := TO_NUMBER(fnd_profile.VALUE('ORG_ID'));

    log('d','Start processing Statement with ORG_ID: ' ||
              to_char(v_org_id));

    v_process_stage := 'Customer Cursor Record Process Begin...';

    FOR v_customer_rec IN v_customer_cur LOOP

      -- Assign Customer details to the Record Type variables
      v_process_stage                         := 'Assign Cursor Record values to the Customer Record Type variables';
      v_customer_cur_rec.STATEMENT_CYCLE_ID   := v_customer_rec.STATEMENT_CYCLE_ID;
      v_customer_cur_rec.CUSTOMER_PROFILE_ID  := v_customer_rec.CUSTOMER_PROFILE_ID;
      v_customer_cur_rec.COLLECTOR_ID         := v_customer_rec.COLLECTOR_ID;
      v_customer_cur_rec.SITE_USE_ID          := v_customer_rec.SITE_USE_ID;
      v_customer_cur_rec.STATEMENT_CYCLE_NAME := v_customer_rec.STATEMENT_CYCLE_NAME;
      v_customer_cur_rec.CUSTOMER_ID          := v_customer_rec.CUSTOMER_ID;
      v_customer_cur_rec.CUSTOMER_NUMBER      := v_customer_rec.CUSTOMER_NUMBER;
      v_customer_cur_rec.CUSTOMER_NAME        := v_customer_rec.CUSTOMER_NAME;
      v_customer_cur_rec.PARTY_ID             := v_customer_rec.PARTY_ID;
      v_customer_cur_rec.LANGUAGE             := v_customer_rec.LANGUAGE;
      v_customer_cur_rec.ATTRIBUTE1           := v_customer_rec.ATTRIBUTE1;
      v_customer_cur_rec.SALES_CHANNEL_CODE   := v_customer_rec.SALES_CHANNEL_CODE;
      v_customer_cur_rec.HDR_LOGO_CODE        := v_customer_rec.HDR_LOGO_CODE;
      v_customer_cur_rec.LINE_LOGO_CODE       := v_customer_rec.LINE_LOGO_CODE;      
      v_customer_cur_rec.STMT_MSG1            := v_customer_rec.STMT_MSG1;
      v_customer_cur_rec.STMT_MSG2            := v_customer_rec.STMT_MSG2;
      v_customer_cur_rec.CUST_EMAIL_ADR       := v_customer_rec.cust_email_adr;

      -- Jude Lam 03/06/06
      log('d','Processing Customer Number ' ||
                v_customer_rec.CUSTOMER_NUMBER);
      log('d','Processing Customer Email ' ||
                nvl(v_customer_rec.cust_email_adr,'None'));
                
      log('d','++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++');
      log('d','Inside v_customer_Cur: customer id: ' ||
                TO_CHAR(v_customer_rec.CUSTOMER_ID) || ' SITE_USE_ID: ' ||
                TO_CHAR(v_customer_rec.SITE_USE_ID) || ' customer name: ' ||
                v_customer_rec.CUSTOMER_NAME);

      -- Get the statement date of the current statement cycle (SQL #3)
      v_process_stage := 'Determine the Statement As of Date.  The Statement As of Date passed: ' ||
                         to_char(p_stmt_as_of_date) ||
                         ' and v_customer_statement_cycle_id: ' ||
                         to_char(v_customer_rec.statement_cycle_id) ||
                         ' for sysdate: ' || to_char(sysdate, 'MM/DD/YYYY');

      log('d',v_process_stage);

      -- Use the Statement as of date passed if one passes one.  If not, use sysdate to locate the
      -- Statement cycle specific date that is within the current sysdate.
      IF p_stmt_as_of_date IS NOT NULL THEN
        v_statement_date_global := TO_DATE(p_stmt_as_of_date,
                                           'YYYY/MM/DD HH24:MI:SS');
      ELSE

        SELECT STATEMENT_DATE
          INTO v_statement_date_global
          FROM AR_STATEMENT_CYCLE_DATES
         WHERE STATEMENT_CYCLE_ID = v_customer_rec.STATEMENT_CYCLE_ID
           AND STATEMENT_DATE BETWEEN
               TO_DATE('01-' || TO_CHAR(SYSDATE, 'MON-YYYY'), 'DD-MON-YYYY') -- Jude Lam Update 03/06/06 added the format.
               AND LAST_DAY(SYSDATE);
      END IF;

      v_statement_date_global := TRUNC(v_statement_date_global) + 0.99999; -- Jude Lam update 08/31/06 to set the time stamp to 11:59:59 p.m..

      -- Jude Lam 03/06/06
      log('d','Statement Date Determined: ' ||
                TO_CHAR(v_statement_date_global, 'MM/DD/YYYY HH24:MI:SS'));

      -- Get the last Statement Date for the same customer  Jude Lam 04/26/06 update the v_process_stage to make it clearer.
      v_process_stage := 'Get the Last Statement Date for the Current Customer ID: ' ||
                         to_char(v_customer_rec.customer_id);

      log('d',v_process_stage);

      BEGIN

        SELECT TRUNC(NVL(MAX(ash.STMT_DTE), v_statement_date_global - 30))
          INTO v_last_stmt_date_global
          FROM LWX_AR_STMT_HEADERS ash, HZ_CUST_ACCOUNTS CUST
         WHERE CUST.CUST_ACCOUNT_ID = v_customer_rec.CUSTOMER_ID
           AND ash.SEND_TO_CUST_NBR = CUST.ACCOUNT_NUMBER;

      EXCEPTION
        WHEN NO_DATA_FOUND THEN
          v_last_stmt_date_global := NVL(v_statement_date_global, SYSDATE) - 30;
        WHEN OTHERS THEN
          --Raise the user defined exception
          RAISE v_when_others;
      END;

      v_last_stmt_date_global := TRUNC(v_last_stmt_date_global);

      -- Jude Lam 03/06/06
      log('d','Last Statement Date Determined: ' ||
                TO_CHAR(v_last_stmt_date_global, 'DD-MON-YYYY'));

      -- Calculation of the due-date adjustment:
      declare
        date_distance_adjusted number := 0;
      begin
        date_distance_adjusted :=
          v_statement_date_global - (v_last_stmt_date_global + 30);
        --
        -- Effectively, if the "current statement date" and the "last statement date"
        -- are between 30 and 40 days apart, then we want to adjust the line item
        -- due date by the amount for which the difference between the dates exceeds
        -- 30 days.  And otherwise, the due-date should not be adjusted at all, i.e.,
        -- the adjustment must be 0.
        if     0 <= date_distance_adjusted
           and      date_distance_adjusted <= 10
        then
          v_due_date_adjustment := date_distance_adjusted;
        else
          v_due_date_adjustment := 0;
        end if;
	--
	log('d','Calculated v_due_date_adjustment is:  '||to_char(v_due_date_adjustment,'tm9'));
      end;

      -- Calculate the current open balance for the customer
      v_process_stage := 'Get the Current Open Balance for the Customer Id: ' ||
                         TO_CHAR(v_customer_rec.CUSTOMER_ID);


      -- invoice print...
      SELECT SUM(nvl(A.AMOUNT_DUE_REMAINING, 0))
      	INTO v_current_open_balance
      	FROM AR_PAYMENT_SCHEDULES A
       WHERE A.CUSTOMER_ID = v_customer_rec.CUSTOMER_ID 
         AND A.STATUS = 'OP' 
         AND lwx_ar_query.get_wo_gift_card_receipt(A.PAYMENT_SCHEDULE_ID) IS NULL
         AND get_prepay(a.payment_schedule_id,'Y','Y') IS NULL;

      v_current_open_balance := nvl(v_current_open_balance,0);
      log('d','Open Balance for the customer: ' ||
                TO_CHAR(v_current_open_balance, '9,999,999,990.00'));

      -- The absolute value of the minimum statement amount will now be 5, regardless of the customer parameter.
      v_min_statement_amount := 5;
      v_statement_days := trunc(v_statement_date_global) - trunc(v_last_stmt_date_global);
      log('d','Days since last statement for customer: ' || to_char(v_statement_days, '99999')); 

      IF (abs(v_current_open_balance) >= v_min_statement_amount) AND
         (v_statement_days >= 25) THEN
      
        -- Begin Validation of Bill-to Site Setup.
        v_good_sites := TRUE;
        v_process_stage := 'Find Customer Site Address and Id for Customer Number-Customer ID: ' ||
                            v_customer_cur_rec.customer_number||'-'||v_customer_cur_rec.customer_id;
        get_site_info(v_customer_cur_rec.CUSTOMER_ID,
                      v_customer_cur_rec.PARTY_ID,
                      v_good_sites,
                      t_customer_address1,
                      t_customer_address2,
                      t_customer_address3,
                      t_customer_address4,
                      t_customer_city,
                      t_customer_state,
                      t_customer_postal_code,
                      t_customer_country,
                      t_cust_acct_site_id);
        IF (NOT v_good_sites) THEN 
            log('l','*** Warning: Please fix the Primary Bill_To Site Details for customer number: ' ||
                                            v_customer_rec.CUSTOMER_NUMBER || ' Customer Skipped');
        END IF;

      END IF;

      -- Jude Lam 09/08/06 Update to use ABS for absolute dollar.
      -- If true then do the rest of the step else skip the current customer
      IF (abs(v_current_open_balance) >= v_min_statement_amount) AND (v_good_sites) AND
         (v_statement_days >= 25) THEN

        -- Find out the customer has chosen to receive consolidated statement
        log('d','Customer Consolidated Statement flag: ' ||v_customer_rec.new_cons_inv_flag);

        -- Call to Insert F1 Type Record into LWX_AR_STMT_HEADERS

        v_process_stage := 'Call Procedure Lwx_Ar_Build_F1_Type_Rec to Insert F1 Type Records for customer id: ' ||
                           to_char(v_customer_rec.customer_id);

        Lwx_Ar_Build_F1_Type_Rec(v_customer_cur_rec,
                                 v_stmt_header_id,
                                 t_customer_address1,
                                 t_customer_address2,
                                 t_customer_address3,
                                 t_customer_address4,
                                 t_customer_city,
                                 t_customer_state,
                                 t_customer_postal_code,
                                 t_customer_country,
                                 t_cust_acct_site_id,
                                 retcode);

        IF retcode = 2 THEN
          v_process_stage := '****** Error occurred in Lwx_Ar_Build_F1_Type_Rec.  Please check previous messages.';
          RAISE v_when_others;
        ELSE
          log('d','v_stmt_header_id: ' || v_stmt_header_id);
        END IF;

        -- Handle the Statement of Details section
        -- Reset Statement Line counter variable
        v_stmt_line_cnt := 0;

        FOR v_openitem_rec IN v_openitem_cur(v_customer_rec.CUSTOMER_ID) LOOP

          IF v_openitem_rec.INTERFACE_HEADER_ATTRIBUTE1 IS NOT NULL AND v_openitem_rec.INTERFACE_HEADER_CONTEXT = 'ORDER ENTRY' THEN
            v_openitem_cur_rec.TRX_NUMBER            := v_openitem_rec.TRX_NUMBER || '(' || v_openitem_rec.INTERFACE_HEADER_ATTRIBUTE1 || ')';
          ELSE
            v_openitem_cur_rec.TRX_NUMBER            := v_openitem_rec.TRX_NUMBER;
          END IF;

          -- Assign Open Item details to the Record Type Variables
          v_process_stage                            := 'Assign Open Item Cursor Record Values to the Open Item Record Type variables';
          v_openitem_cur_rec.CUSTOMER_TRX_ID         := v_openitem_rec.CUSTOMER_TRX_ID;
          v_openitem_cur_rec.TRX_DATE                := v_openitem_rec.TRX_DATE;
          v_openitem_cur_rec.CASH_RECEIPT_ID         := v_openitem_rec.CASH_RECEIPT_ID;
          v_openitem_cur_rec.PAYMENT_SCHEDULE_ID     := v_openitem_rec.PAYMENT_SCHEDULE_ID;
          v_openitem_cur_rec.CLASS                   := v_openitem_rec.CLASS;
          v_openitem_cur_rec.AMOUNT_DUE_ORIGINAL     := v_openitem_rec.AMOUNT_DUE_ORIGINAL;
          v_openitem_cur_rec.AMOUNT_DUE_REMAINING    := v_openitem_rec.AMOUNT_DUE_REMAINING;
          v_openitem_cur_rec.DUE_DATE                := v_openitem_rec.DUE_DATE;
          v_openitem_cur_rec.ATTRIBUTE3              := v_openitem_rec.ATTRIBUTE3;
          v_openitem_cur_rec.ATTRIBUTE4              := v_openitem_rec.ATTRIBUTE4;
          v_openitem_cur_rec.ATTRIBUTE5              := v_openitem_rec.ATTRIBUTE5;
          v_openitem_cur_rec.ATTRIBUTE6              := v_openitem_rec.ATTRIBUTE6;
          v_openitem_cur_rec.ATTRIBUTE7              := v_openitem_rec.ATTRIBUTE7;
          v_openitem_cur_rec.DEFAULT_PRINTING_OPTION := v_openitem_rec.DEFAULT_PRINTING_OPTION;
          v_openitem_cur_rec.TYPE                    := v_openitem_rec.TYPE;
          v_openitem_cur_rec.TERM_ID                 := v_openitem_rec.TERM_ID;
          v_openitem_cur_rec.PAYMENT_TYPE_CODE       := nvl(v_openitem_rec.PAYMENT_TYPE_CODE,'***');
          v_openitem_cur_rec.PURCHASE_ORDER          := substr(nvl(v_openitem_rec.PURCHASE_ORDER,
                                                                   v_openitem_rec.comments),
                                                               1,
                                                               30);
          v_openitem_cur_rec.DOC_TYPE_NME            := v_openitem_rec.doc_type_nme;                                                                
          v_openitem_cur_rec.TRUE_PURCHASE_ORDER     := v_openitem_rec.Purchase_Order;
          IF v_openitem_rec.CLASS = 'PMT' THEN
            v_openitem_cur_rec.TRUE_COMMENTS         := v_openitem_rec.cash_comments;
          ELSE
            v_openitem_cur_rec.TRUE_COMMENTS         := v_openitem_rec.comments;                   
          END IF;
          
          -- Jude Lam 09/06/06 Update on Credit Memo notes printing update.
          v_cm_printed_flag := 'N';

          -- Jude Lam 03/06/06
          log('d','*** Inside v_openitem_cur loop for customer id: ' ||
                    TO_CHAR(v_customer_rec.CUSTOMER_ID) ||
                    ' for ps schedule id: ' ||
                    TO_CHAR(v_openitem_rec.PAYMENT_SCHEDULE_ID) ||
                    ' Class: ' || v_openitem_rec.CLASS ||
                    ' Customer Trx ID ' || v_openitem_rec.CUSTOMER_TRX_ID ||
                    ' Sales Channel code: ' ||
                    v_openitem_cur_rec.ATTRIBUTE5 || ' Type: ' ||
                    v_openitem_cur_rec.type);

          -- Check to see whether the open item is a prepayment item
          IF (v_openitem_rec.CLASS = 'PMT')
            AND (v_openitem_rec.payment_schedule_id = get_prepay(v_openitem_rec.payment_schedule_id,'Y','N')) THEN
              log('d','Prepay item - skip until prepay loop.');
          ELSE

            -- Increment statement line counter
            v_stmt_line_cnt := v_stmt_line_cnt + 1;
            -- Insert the open item record into the LWX_AR_STMT_LINES table for Type F3 record.
            -- Call to Lwx_AR_Build_Data_Phase_For_F3_Type_Rec to Insert F3 Type Record

            v_process_stage := 'Call Procedure to Insert F3 Type Records when not a prepayment';

            Lwx_Ar_Build_F3_Type_Rec(v_stmt_line_cnt,
                                     v_customer_cur_rec,
                                     v_openitem_cur_rec,
                                     retcode);
            IF retcode = 2 THEN
              v_process_stage := '****** Error occurred in Lwx_Ar_Build_F3_Type_Rec.  Please check previous messages.';
              RAISE v_when_others;
            END IF;

            -- If the item is invoice or credit memo or debit memo, then
            IF v_openitem_rec.TYPE IN ('INV', 'CM', 'DM') THEN

              -- Assign value to the parameter variables
              v_choice                 := v_openitem_rec.CLASS;
              v_customer_trx_id        := v_openitem_rec.CUSTOMER_TRX_ID;
              v_trx_type               := v_openitem_rec.CLASS;
              v_term_sequence_number   := v_openitem_rec.TERMS_SEQUENCE_NUMBER;
              v_printing_count         := 0;
              v_printing_original_date := NULL;
              v_prev_statment_run_cnt  := 0;

              BEGIN
                v_process_stage := 'Count term count for the customer transaction using customer_trx_id: ' ||
                                   to_char(v_openitem_rec.customer_trx_id);

                SELECT COUNT(*)
                  INTO v_term_count
                  FROM AR_PAYMENT_SCHEDULES
                 WHERE CUSTOMER_TRX_ID = v_openitem_rec.CUSTOMER_TRX_ID;

                log('d','Customer Trx ID: ' ||
                          to_char(v_openitem_rec.customer_trx_id) ||
                          ' Term Count ' || v_term_count);

              EXCEPTION
                WHEN NO_DATA_FOUND THEN
                  v_term_count := 0;
                  -- Not included in the previous statement run
                WHEN OTHERS THEN
                  --Raise the user defined excption
                  RAISE v_when_others;
              END;

              BEGIN
                v_process_stage := 'Count previous statment run count for the customer transaction for customer_trx_id: ' ||
                                   to_char(v_openitem_rec.customer_trx_id);
                SELECT COUNT(*)
                  INTO v_prev_statment_run_cnt
                  FROM LWX_AR_STMT_LINES
                 WHERE CUSTOMER_TRX_ID = v_openitem_rec.CUSTOMER_TRX_ID
                   AND STMT_HDR_ID != v_stmt_header_id;

                log('d','Previous Statment Run Count ' ||
                          v_prev_statment_run_cnt ||
                          ' for customer_trx_id: ' ||
                          to_char(v_openitem_rec.customer_trx_id));

              EXCEPTION
                WHEN NO_DATA_FOUND THEN
                  v_prev_statment_run_cnt := 0;
                  -- Not included in the previous statement run
                WHEN OTHERS THEN
                  --Raise the user defined excption
                  RAISE v_when_others;
              END;

              IF v_customer_rec.new_cons_inv_flag = 'Y' AND
                 v_customer_rec.attribute1 <> 'Es' AND 
                 v_openitem_rec.TRX_DATE <= v_statement_date_global AND
                 v_openitem_rec.DEFAULT_PRINTING_OPTION = 'PRI' AND
                 nvl(v_openitem_rec.PAYMENT_TYPE_CODE,'XXX') <> 'CREDIT_CARD' AND
                 nvl(v_openitem_rec.ATTRIBUTE5,'XX') not in ('EG','PS') AND
                 v_prev_statment_run_cnt = 0 THEN

                 -- call the AR_INVOICE_SQL_FUNC_PUB.Update_Customer_Trx to setup the Printing data correctly
                 v_process_stage := 'Call to Standard Procedure to Setup the Printing Data for customer_trx_id: ' ||
                                    to_char(v_customer_trx_id);
                 log('l', v_process_stage);
                 Ar_Invoice_Sql_Func_Pub.Update_Customer_Trx(v_choice,
                                                             v_customer_trx_id,
                                                             v_trx_type,
                                                             v_term_count,
                                                             v_term_sequence_number,
                                                             v_printing_count,
                                                             v_printing_original_date);

                 -- Insert a new record of F4 type into LWX_AR_STMT_LINES
                 v_process_stage := 'Call Procedure to Insert F4 Type Records';

                 log('l', v_process_stage);

                 Lwx_Ar_Build_F4_Type_Rec(v_stmt_line_cnt,
                                          v_customer_cur_rec,
                                          v_openitem_cur_rec,
                                          retcode);
                 IF retcode = 2 THEN
                   v_process_stage := '****** Error occurred in Lwx_Ar_Build_F4_Type_Rec.  Please check previous messages.';
                   RAISE v_when_others;
                 END IF;

                 BEGIN
                   v_process_stage := 'Find the Batch Source Name for the Customer transaction ' ||
                                      v_openitem_rec.CUSTOMER_TRX_ID;

                   SELECT bsa.NAME
                     INTO v_batch_source_name
                     FROM RA_BATCH_SOURCES bsa, RA_CUSTOMER_TRX rct
                    WHERE rct.CUSTOMER_TRX_ID =
                          v_openitem_rec.CUSTOMER_TRX_ID
                      AND bsa.BATCH_SOURCE_ID = rct.BATCH_SOURCE_ID;

                   log('d','Batch Source Name ' || v_batch_source_name);

                 EXCEPTION
                   WHEN NO_DATA_FOUND THEN
                     v_batch_source_name := '';
                   WHEN OTHERS THEN
                     --Raise the user defined excption
                     RAISE v_when_others;
                 END;

                 IF v_batch_source_name = 'JDA_ORA_AR_INVOICES' OR 
                    v_batch_source_name = 'D365_ORA_AR_INVOICES' THEN
                   -- Set transaction line detail count to 1
                   v_trx_line_dtl_cnt := 1;

                   -- Insert New Record into the LWX_AR_STMT_LINE_DETAILS Table
                   -- Call to Insert New Record into the LWX_AR_STMT_LINE_DETAILS Table
                   -- Stores Name and Phone Number (SNP)
                   v_process_stage := 'Call Procedure to Insert Line Detail Records inside batch source for JDA/D365.';

                   log('d',v_process_stage);

                   Lwx_Ar_Build_Line_Details('SNP',
                                             v_openitem_rec.TYPE,
                                             v_trx_line_dtl_cnt,
                                             v_openitem_cur_rec,
                                             v_trx_line_dtl_cur_rec,
                                             retcode);

                   IF retcode = 2 THEN
                     v_process_stage := '****** Error occurred in Lwx_Ar_Build_Line_Details.  Please check previous messages.';
                     RAISE v_when_others;
                   END IF;

                 ELSE
                   -- Invoice/Credit Memo Not from JDA/D365
                   -- Set transaction line detail count to 0
                   v_trx_line_dtl_cnt := 0;
                 END IF; -- End of Check for Invoice/Credit Memo from JDA/D365

                 FOR v_trx_line_dtl_rec IN v_trx_line_dtl_cur(v_openitem_rec.CUSTOMER_TRX_ID) LOOP
                   -- Assign Customer details to the Record Type variables
                   v_process_stage                             := 'Assign Transaction Line Detail Cursor Record Values to the Type Record';
                   v_trx_line_dtl_cur_rec.REASON_CODE          := v_trx_line_dtl_rec.REASON_CODE;
                   v_trx_line_dtl_cur_rec.CUSTOMER_TRX_LINE_ID := v_trx_line_dtl_rec.CUSTOMER_TRX_LINE_ID;
                   v_trx_line_dtl_cur_rec.QUANTITY_ORDERED     := v_trx_line_dtl_rec.QUANTITY_ORDERED;
                   v_trx_line_dtl_cur_rec.QUANTITY_INVOICED    := v_trx_line_dtl_rec.QUANTITY_INVOICED;
                   v_trx_line_dtl_cur_rec.INVENTORY_ITEM_ID    := v_trx_line_dtl_rec.INVENTORY_ITEM_ID;
                   v_trx_line_dtl_cur_rec.UNIT_SELLING_PRICE   := v_trx_line_dtl_rec.UNIT_SELLING_PRICE;
                   v_trx_line_dtl_cur_rec.UNIT_STANDARD_PRICE  := v_trx_line_dtl_rec.UNIT_STANDARD_PRICE;
                   v_trx_line_dtl_cur_rec.EXTENDED_AMOUNT      := v_trx_line_dtl_rec.EXTENDED_AMOUNT;
                   v_trx_line_dtl_cur_rec.DESCRIPTION          := v_trx_line_dtl_rec.DESCRIPTION;

                   log('d','****** Inside v_trx_line_dtl_cur: customer trx id: ' ||
                             TO_CHAR(v_openitem_rec.CUSTOMER_TRX_ID) ||
                             ' CUSTOMER_TRX_LINE_ID: ' ||
                             TO_CHAR(v_trx_line_dtl_rec.CUSTOMER_TRX_LINE_ID) ||
                             ' QUANTITY_ORDERED: ' ||
                             TO_CHAR(v_trx_line_dtl_rec.QUANTITY_ORDERED) ||
                             ' QUANTITY_INVOICED: ' ||
                             TO_CHAR(v_trx_line_dtl_rec.QUANTITY_INVOICED) ||
                             ' INVENTORY_ITEM_ID: ' ||
                             TO_CHAR(v_trx_line_dtl_rec.INVENTORY_ITEM_ID) ||
                             ' UNIT_SELLING_PRICE: ' ||
                             TO_CHAR(v_trx_line_dtl_rec.UNIT_SELLING_PRICE) ||
                             ' UNIT_STANDARD_PRICE: ' ||
                             TO_CHAR(v_trx_line_dtl_rec.UNIT_STANDARD_PRICE) ||
                             ' EXTENDED_AMOUNT: ' ||
                             TO_CHAR(v_trx_line_dtl_rec.EXTENDED_AMOUNT) ||
                             ' DESCRIPTION: ' ||
                             TO_CHAR(v_trx_line_dtl_rec.DESCRIPTION));

                   IF v_openitem_rec.TYPE = 'CM' AND
                      v_cm_printed_flag = 'N' THEN
                     -- Call to Insert Memo Message into LWX_AR_STMT_LINE_DETAILS
                     -- Reason DESCRIPTION Text (RDT)
                     v_process_stage := 'Call Procedure to Insert into Line Details Table with Reason DESCRIPTION Text ';

                     log('l', v_process_stage);

                     Lwx_Ar_Build_Line_Details('RDT',
                                               v_openitem_rec.TYPE,
                                               v_trx_line_dtl_cnt,
                                               v_openitem_cur_rec,
                                               v_trx_line_dtl_cur_rec,
                                               retcode);

                     IF retcode = 2 THEN
                       v_process_stage := '****** Error occurred in Lwx_Ar_Build_Line_Details.  Please check previous messages.';
                       RAISE v_when_others;
                     END IF;

                     v_cm_printed_flag := 'Y';

                   END IF; -- End of Check for Credit Memo

                   -- Insert the current detail record.
                   v_process_stage := 'Call Procedure to Insert into Line Details for the current line details for customer trx id: ' ||
                                      to_char(v_openitem_rec.CUSTOMER_TRX_ID) ||
                                      ' and customer_trx_line_id: ' ||
                                      to_char(v_trx_line_dtl_cur_rec.customer_trx_line_id);

                   log('d',v_process_stage);

                   Lwx_Ar_Build_Line_Details('',
                                             v_openitem_rec.TYPE,
                                             v_trx_line_dtl_cnt,
                                             v_openitem_cur_rec,
                                             v_trx_line_dtl_cur_rec,
                                             retcode);
                   IF retcode = 2 THEN
                     v_process_stage := '****** Error occurred in Lwx_Ar_Build_Line_Details.  Please check previous messages.';
                     RAISE v_when_others;
                   END IF;

                   -- Check Item status and insert additional memo line if needed.
                   -- SQL #9
                   v_process_stage := 'Check the Current Line whether linked to an Inventory Item.';

                   IF nvl(v_trx_line_dtl_rec.INVENTORY_ITEM_ID, -999) != -999 THEN

                     SELECT msib.INVENTORY_ITEM_STATUS_CODE
                       INTO v_inv_item_status_code
                       FROM MTL_SYSTEM_ITEMS_B msib
                      WHERE msib.ORGANIZATION_ID = v_master_org_id
                        AND msib.INVENTORY_ITEM_ID =
                            v_trx_line_dtl_rec.INVENTORY_ITEM_ID;

                     log('d','Inventory Item ID: ' ||
                               to_char(v_trx_line_dtl_rec.inventory_item_id) ||
                               ' Inventory Item Status Code ' ||
                               v_inv_item_status_code);

                     IF v_inv_item_status_code = 'NYP' AND
                        v_batch_source_name = 'Order Management' THEN

                       -- Insert a new record into the LWX_AR_STMT_LINE_DETAILS
                       -- Call to Insert Cursor Record into the LWX_AR_STMT_LINE_DETAILS
                       v_process_stage := 'Call Procedure to Insert into Line Details Table with Expected Publish Date';

                       log('d',v_process_stage);

                       Lwx_Ar_Build_Line_Details('NYP',
                                                 v_openitem_rec.TYPE,
                                                 v_trx_line_dtl_cnt,
                                                 v_openitem_cur_rec,
                                                 v_trx_line_dtl_cur_rec,
                                                 retcode);
                       IF retcode = 2 THEN
                         v_process_stage := '****** Error occurred in Lwx_Ar_Build_Line_Details.  Please check previous messages.';
                         RAISE v_when_others;
                       END IF;

                     END IF; -- End of Check to Invoice Item Status for NYP/OS

                   END IF; -- End of checking inventory item id.

                   log('d','End of v_trx_line_dtl_cur: customer trx id: ' ||
                             TO_CHAR(v_openitem_rec.CUSTOMER_TRX_ID));
                 END LOOP; -- End of Trx Line Detail cursor

                 -- Update the F4 header record in the LWX_AR_STMT_LINES table for
                 -- the page number and detail line count
                 v_process_stage := 'Getting current value from ar_statement_headers_s.currval.';

                 SELECT AR_STATEMENT_HEADERS_S.CURRVAL
                   INTO v_stmt_header_id
                   FROM DUAL;

                 v_process_stage := 'Getting current value from lwx_ar_stmt_lines_s.currval.';

                 SELECT LWX_AR_STMT_LINES_S.CURRVAL
                   INTO v_stmt_line_id
                   FROM DUAL;

                 log('d','Statement Header ID ' || v_stmt_header_id ||
                           ' Statement Line ID ' || v_stmt_line_id);

                 v_process_stage := 'Get the Page Number for STMT_LINE ID: ' ||
                                    to_char(v_stmt_line_id);

                  v_page_number := 0;
                  FOR v_stmt_dtl_f4_rec IN v_stmt_dtl_f4_cur(v_stmt_line_id) LOOP
                    IF check_display(v_stmt_dtl_f4_rec.customer_trx_line_id) THEN
                      v_page_number := v_page_number + 1;
                    END IF; -- End of check to see if this needs to be displayed.
                  END LOOP; -- End of Detail F4 Type Record Cursor Loop

                 -- Save the line record count.
                 v_trx_line_dtl_rec_cnt := v_page_number;

                 log('d','Page Number ' || v_page_number);

                 -- If the decimal portion of the  division value is zero,
                 -- then no need to add the extra page

                 IF (MOD(v_page_number, 16) = 0) THEN
                   v_page_number := FLOOR(v_page_number / 16);
                 ELSIF (MOD(v_page_number, 16) = v_page_number) THEN
                   v_page_number := 1;
                 ELSE
                   v_page_number := FLOOR(v_page_number / 16) + 1;
                 END IF; -- End of calculate page number

                 -- Update the F4 Header Record in the LWX_AR_STMT_LINES Table
                 v_process_stage := 'Update Statement Lines with Page Count ' ||
                                    to_char(v_page_number) ||
                                    ' and Line Count ' ||
                                    to_char(v_trx_line_dtl_rec_cnt) ||
                                    ' with statement line id: ' ||
                                    to_char(v_stmt_line_id);

                 log('d',v_process_stage);

                 UPDATE LWX_AR_STMT_LINES
                    SET PAGE_CNT = v_page_number,
                        LINE_CNT = v_trx_line_dtl_rec_cnt
                  WHERE STMT_HDR_ID = v_stmt_header_id
                    AND STMT_LINE_ID = v_stmt_line_id;

              END IF; -- End of Default Printing Option Check
            END IF; -- End of Open Item Type Check for Invoice/Credit Memo/Debit Memo
          END IF; -- End of v_openitem_rec.class = 'PMT' and get_prepay check.

          log('l',
                            'End of v_openitem_cur loop for customer id: ' ||
                            TO_CHAR(v_customer_rec.CUSTOMER_ID));

        END LOOP; -- End of Open Item process for Not a Pre-payment Item

        -- *** Handle the Prepaid order section

        -- Select all of the prepayment items (OPEN ISSUE)
        FOR v_prepay_rec IN v_prepay_cur(v_customer_rec.CUSTOMER_ID,
                                         v_last_stmt_date_global,
                                         v_statement_date_global) 
        LOOP

            log('d','*** Inside v_prepay_cur: PAYMENT_SCHEDULE_ID: ' ||
                      v_prepay_rec.PAYMENT_SCHEDULE_ID || ' STATUS ' ||
                      v_prepay_rec.STATUS || ' CASH_RECEIPT_ID ' ||
                      v_prepay_rec.CASH_RECEIPT_ID ||
                      ' CASH_APPLIED_DATE_LAST ' ||
                      v_prepay_rec.CASH_APPLIED_DATE_LAST);

            v_process_stage                            := 'Assign Open Item Cursor Record Values to the Open Item Record Type variables for prepayment header.';
            v_openitem_cur_rec.CUSTOMER_TRX_ID         := NULL;
            v_openitem_cur_rec.TRX_NUMBER              := v_prepay_rec.TRX_NUMBER;
            v_openitem_cur_rec.TRX_DATE                := v_prepay_rec.TRX_DATE;
            v_openitem_cur_rec.CASH_RECEIPT_ID         := v_prepay_rec.CASH_RECEIPT_ID;
            v_openitem_cur_rec.PAYMENT_SCHEDULE_ID     := v_prepay_rec.PAYMENT_SCHEDULE_ID;
            v_openitem_cur_rec.CLASS                   := v_prepay_rec.CLASS;
            v_openitem_cur_rec.AMOUNT_DUE_ORIGINAL     := v_prepay_rec.AMOUNT_DUE_ORIGINAL;
            v_openitem_cur_rec.AMOUNT_DUE_REMAINING    := v_prepay_rec.AMOUNT_DUE_REMAINING;
            v_openitem_cur_rec.DUE_DATE                := v_prepay_rec.DUE_DATE;
            v_openitem_cur_rec.ATTRIBUTE3              := NULL;
            v_openitem_cur_rec.ATTRIBUTE4              := NULL;
            v_openitem_cur_rec.ATTRIBUTE5              := NULL;
            v_openitem_cur_rec.ATTRIBUTE6              := NULL;
            v_openitem_cur_rec.ATTRIBUTE7              := NULL;
            v_openitem_cur_rec.DEFAULT_PRINTING_OPTION := NULL;
            v_openitem_cur_rec.TYPE                    := NULL;
            v_openitem_cur_rec.TERM_ID                 := NULL;
            v_openitem_cur_rec.PURCHASE_ORDER          := NULL;
            v_openitem_cur_rec.DOC_TYPE_NME            := v_prepay_rec.doc_type_nme;
            v_openitem_cur_rec.TRUE_COMMENTS           := v_prepay_rec.TRUE_COMMENTS;
            v_openitem_cur_rec.TRUE_PURCHASE_ORDER     := NULL;

            -- Insert Receipt Record into LWX_AR_STMT_LINES with Type F2 record
            v_process_stage := 'Call Procedure to Insert F2 Type Records into Statement Lines Table for prepayment receipt.';
            log('d',v_process_stage);

            -- Jude Lam 05/03/06 bug fix on statment line assignment.
            v_stmt_line_cnt := v_stmt_line_cnt + 1;

            Lwx_Ar_Build_F2_Type_Rec(v_stmt_line_cnt,
                                     v_customer_cur_rec,
                                     v_openitem_cur_rec,
                                     retcode);

            IF retcode = 2 THEN
              v_process_stage := '****** Error occurred in Lwx_Ar_F2_Type_Rec.  Please check previous messages.';
              RAISE v_when_others;
            END IF;

            FOR v_cash_receipts_rec IN v_cash_receipts_cur(v_prepay_rec.CASH_RECEIPT_ID) LOOP
              -- Call to Insert F2 Type Records into LWX_AR_STMT_LINES for Cash Receipts
              v_stmt_line_cnt := v_stmt_line_cnt + 1;

              v_process_stage                            := 'Assign Open Item Cursor Record Values to the Open Item Record Type variables for prepayment details.';
              v_openitem_cur_rec.CUSTOMER_TRX_ID         := v_cash_receipts_rec.CUSTOMER_TRX_ID;
              v_openitem_cur_rec.TRX_NUMBER              := v_cash_receipts_rec.TRX_NUMBER;
              v_openitem_cur_rec.TRX_DATE                := v_cash_receipts_rec.TRX_DATE;
              v_openitem_cur_rec.CASH_RECEIPT_ID         := v_cash_receipts_rec.CASH_RECEIPT_ID;
              v_openitem_cur_rec.PAYMENT_SCHEDULE_ID     := v_cash_receipts_rec.PAYMENT_SCHEDULE_ID;
              v_openitem_cur_rec.CLASS                   := v_cash_receipts_rec.CLASS;
              v_openitem_cur_rec.AMOUNT_DUE_ORIGINAL     := v_cash_receipts_rec.AMOUNT_DUE_ORIGINAL;
              v_openitem_cur_rec.AMOUNT_DUE_REMAINING    := v_cash_receipts_rec.AMOUNT_DUE_REMAINING;
              v_openitem_cur_rec.DUE_DATE                := v_cash_receipts_rec.DUE_DATE;
              v_openitem_cur_rec.ATTRIBUTE3              := v_cash_receipts_rec.attribute3;
              v_openitem_cur_rec.ATTRIBUTE4              := v_cash_receipts_rec.attribute4;
              v_openitem_cur_rec.ATTRIBUTE5              := v_cash_receipts_rec.attribute5;
              v_openitem_cur_rec.ATTRIBUTE6              := v_cash_receipts_rec.attribute6;
              v_openitem_cur_rec.ATTRIBUTE7              := v_cash_receipts_rec.attribute7;
              v_openitem_cur_rec.DEFAULT_PRINTING_OPTION := v_cash_receipts_rec.default_printing_option;
              v_openitem_cur_rec.TYPE                    := v_cash_receipts_rec.type;
              v_openitem_cur_rec.TERM_ID                 := v_cash_receipts_rec.term_id;
              v_openitem_cur_rec.PURCHASE_ORDER          := substr(nvl(v_cash_receipts_rec.purchase_order,
                                                                       v_cash_receipts_rec.comments),
                                                                   1,
                                                                   30);
              v_openitem_cur_rec.DOC_TYPE_NME            := v_cash_receipts_rec.doc_type_nme;                                                                   
              v_openitem_cur_rec.TRUE_PURCHASE_ORDER     := v_cash_receipts_rec.purchase_order;
              v_openitem_cur_rec.TRUE_COMMENTS           := v_cash_receipts_rec.comments;

              log('d','****** Inside v_cash_receipts_cur: for CASH_RECEIPT_ID: ' ||
                        to_char(v_cash_receipts_rec.CASH_RECEIPT_ID));

              -- Jude Lam 08/30/06 Updated to delete duplicate transaction in both F2 and F3.
              v_process_stage := 'Delete the same customer_trx_id: ' ||
                                 to_char(v_openitem_cur_rec.CUSTOMER_TRX_ID) ||
                                 ' from the F3 record if there is any.';

              SELECT AR_STATEMENT_HEADERS_S.CURRVAL
                INTO v_stmt_header_id
                FROM DUAL;

              log('d',v_process_stage);

              DELETE FROM LWX_AR_STMT_LINES
               WHERE STMT_HDR_ID = v_stmt_header_id
                 AND CUSTOMER_TRX_ID = v_openitem_cur_rec.CUSTOMER_TRX_ID
                 AND REC_TYPE_CDE = 'F3';

              v_process_stage := 'Call Procedure to Insert F2 Type Records into Statement Lines Table';

              log('d',v_process_stage);

              Lwx_Ar_Build_F2_Type_Rec(v_stmt_line_cnt,
                                       v_customer_cur_rec,
                                       v_openitem_cur_rec,
                                       retcode);

              IF retcode = 2 THEN
                v_process_stage := '****** Error occurred in Lwx_Ar_F2_Type_Rec.  Please check previous messages.';
                RAISE v_when_others;
              END IF;

              log('d','End of v_cash_receipts_cur: for CASH_RECEIPT_ID: ' ||
                        to_char(v_cash_receipts_rec.CASH_RECEIPT_ID));

            END LOOP; -- End of v_cash_receipts_cur LOOP.

          log('l',
                            'End of v_prepay_cur: for PAYMENT_SCHEDULE_ID: ' ||
                            v_prepay_rec.PAYMENT_SCHEDULE_ID);

        END LOOP; -- End of prepay cursor loop

        -- Update the Statement header level information for LWX_AR_STMT_HEADERS
        -- Arrive Prepaid Page Count (PPD_PAGE_CNT)
        v_process_stage := 'Arrive Record count for F2 Type Records from the Statement Lines Table using stmt_header_id: ' ||
                           to_char(v_stmt_header_id);

        SELECT COUNT(*)
          INTO v_total_record_cnt
          FROM LWX_AR_STMT_LINES
         WHERE STMT_HDR_ID = v_stmt_header_id
           AND REC_TYPE_CDE = 'F2'
           AND INCL_CUR_STMT_IND = 'Y';

        log('d','Total F2 Type Records ' || v_total_record_cnt);

        IF (MOD(v_total_record_cnt, 20) = 0) THEN
          v_ppd_page_cnt := FLOOR(v_total_record_cnt / 20);
        ELSIF (MOD(v_total_record_cnt, 20) = v_total_record_cnt) THEN
          v_ppd_page_cnt := 1;
        ELSE
          v_ppd_page_cnt := FLOOR(v_total_record_cnt / 20) + 1;
        END IF;

        -- Arrive Detail Page Count (DTL_PAGE_CNT)
        v_process_stage := 'Arrive Record count for F3 Type Records from the Statement Lines Table using stmt_header_id: ' ||
                           to_char(v_stmt_header_id);

        SELECT COUNT(*)
          INTO v_total_record_cnt
          FROM LWX_AR_STMT_LINES
         WHERE STMT_HDR_ID = v_stmt_header_id
           AND REC_TYPE_CDE = 'F3'
           AND INCL_CUR_STMT_IND = 'Y';

        log('d','Total F3 Type Records ' || v_total_record_cnt);

        IF v_total_record_cnt = 0 THEN
          v_dtl_page_cnt := 0;
        ELSIF (MOD(v_total_record_cnt, 20) = 0) THEN
          v_dtl_page_cnt := FLOOR(v_total_record_cnt / 20) + 1;
        ELSIF (MOD(v_total_record_cnt, 20) = v_total_record_cnt) THEN
          v_dtl_page_cnt := 1;
        ELSE
          v_dtl_page_cnt := FLOOR(v_total_record_cnt / 20) + 1;
        END IF;

        -- Arrive Invoice Page Count (INVO_PAGE_CNT)
        v_process_stage := 'Arrive Record count for F4 Type Records from the Statement Lines Table using stmt_header_id: ' ||
                           to_char(v_stmt_header_id);

        -- Jude Lam 05/02/06 Should be the Sum of the PAGE_CNT instead of COUNT(*) based on the design spec.
        SELECT nvl(SUM(NVL(PAGE_CNT, 0)),0)
          INTO v_invo_page_cnt
          FROM LWX_AR_STMT_LINES
         WHERE STMT_HDR_ID = v_stmt_header_id
           AND REC_TYPE_CDE = 'F4'
           AND INCL_CUR_STMT_IND = 'Y';

        log('d','Total F4 Type Records ' || v_total_record_cnt);

        -- Arrive Total Page Count (TOTAL_PAGE_CNT)
        v_process_stage := 'Arrive Total Page Count';

        IF (MOD(v_ppd_page_cnt, 2) = 0) THEN
          v_ppd_page_cnt_2 := FLOOR(v_ppd_page_cnt / 2);
        ELSIF (MOD(v_ppd_page_cnt, 2) = v_ppd_page_cnt) THEN
          v_ppd_page_cnt_2 := 1;
        ELSE
          v_ppd_page_cnt_2 := FLOOR(v_ppd_page_cnt / 2) + 1;
        END IF;

        IF (MOD(v_dtl_page_cnt, 2) = 0) THEN
          v_dtl_page_cnt_2 := FLOOR(v_dtl_page_cnt / 2);
        ELSIF (MOD(v_dtl_page_cnt, 2) = v_dtl_page_cnt) THEN
          v_dtl_page_cnt_2 := 1;
        ELSE
          v_dtl_page_cnt_2 := FLOOR(v_dtl_page_cnt / 2) + 1;
        END IF;

        -- modifed after duplex printing was lost for stmt detail
        v_total_page_cnt := v_ppd_page_cnt + v_dtl_page_cnt +
                            v_invo_page_cnt + 1;

        -- Jude Lam 05/02/06 Modify the query.
        -- Arrive Over due Amount (OVR_DUE_AMT)
        v_process_stage := 'Arrive Over due Amount using stmt_header_id: ' ||
                           to_char(v_stmt_header_id) ||
                           ' and v_last_stmt_date_global: ' ||
                           to_char(v_last_stmt_date_global, 'MM/DD/YYYY');

        --dhoward 19/mar/2008  greater of due_dte and creation_date
        SELECT NVL(DBT.DEBIT_AMT,0) + NVL(CRE.CREDIT_AMT, 0)
          INTO v_ovr_due_amt
          FROM (-- Debit Amount Table
                SELECT SUM(NVL(sl.OUTSTND_AMT, 0)) DEBIT_AMT
                  FROM LWX_AR_STMT_LINES   SL,
                       RA_CUSTOMER_TRX_ALL TRX
                 WHERE STMT_HDR_ID = v_stmt_header_id 
                   AND REC_TYPE_CDE = 'F3' 
                   AND OUTSTND_AMT >= 0 
                   AND SL.CUSTOMER_TRX_ID = TRX.CUSTOMER_TRX_ID(+) 
                   AND (TRUNC(GREATEST(SL.DUE_DTE, NVL(TRX.CREATION_DATE, SL.DUE_DTE))) + v_due_date_adjustment)
                              < TRUNC(v_last_stmt_date_global)
                   AND (CASE trx.attribute5
                          WHEN 'ET' THEN lwx_ar_query.get_wo_gift_card_receipt(sl.PAYMENT_SCHEDULE_ID)
                          WHEN 'WO' THEN lwx_ar_query.get_wo_gift_card_receipt(sl.PAYMENT_SCHEDULE_ID)
                          WHEN 'FC' THEN lwx_ar_query.get_wo_gift_card_receipt(sl.PAYMENT_SCHEDULE_ID)                            
                          ELSE NULL  
                        END) IS NULL
                   -- Prepay items should not be considered overdue until has appeared in F3 section before
                   AND (get_prepay(SL.PAYMENT_SCHEDULE_ID,'N','Y') IS NULL
                        OR 
                        EXISTS (SELECT 1 
                                FROM LWX_AR_STMT_LINES SL2
                                WHERE SL2.STMT_HDR_ID <> v_stmt_header_id
                                AND SL2.REC_TYPE_CDE = 'F3'
                                AND SL2.CUSTOMER_TRX_ID = SL.CUSTOMER_TRX_ID)
                       )
                ) DBT,
               (-- Credit Amount Table 
                SELECT NVL(SUM(NVL(LASL2.OUTSTND_AMT, 0)), 0) CREDIT_AMT
               	  FROM LWX_AR_STMT_LINES LASL2
                 WHERE STMT_HDR_ID = v_stmt_header_id AND
            	       REC_TYPE_CDE = 'F3' AND
        	           OUTSTND_AMT < 0 
                ) CRE;

        log('d','Over due Amount ' ||
                  to_char(v_ovr_due_amt, '999,999,999,990.00'));

        IF v_ovr_due_amt < 0 THEN
          v_actual_ovr_due_amt := v_ovr_due_amt;
          v_ovr_due_amt        := 0;
        ELSE
          v_actual_ovr_due_amt := v_ovr_due_amt;
        END IF;

        -- Arrive Current Transaction (DUE_AMT)
        v_process_stage := 'Arrive Current F3 Transaction Due Amount using stmt_header_id: ' ||
                           to_char(v_stmt_header_id);

        -- Jude Lam 05/02/06 Modify the query.

        SELECT NVL(SUM(nvl(LASL.OUTSTND_AMT, 0)), 0)
          INTO v_due_amt
          FROM  LWX_AR_STMT_LINES LASL
               ,ra_customer_trx_all trx  --dhoward added 03-28-2008
         WHERE LASL.STMT_HDR_ID = v_stmt_header_id
           AND LASL.REC_TYPE_CDE = 'F3'
           --dhoward Greater Date requirement added 03-28-2008
	       AND LASL.customer_trx_id = trx.customer_trx_id (+)
         AND OUTSTND_AMT >= 0 -- Jude Lam 09/21/06 Added this because all credit items are included in over due amt section.
         AND ((--Non Prepay items use regular date logic
                 get_prepay(LASL.PAYMENT_SCHEDULE_ID,'N','Y') IS NULL
         AND (greatest(trunc(LASL.due_dte),nvl(trunc(trx.creation_date),trunc(LASL.due_dte))) + v_due_date_adjustment)
-- [2020-02-28 Fri 15:27]	 
-- SOMETHING ELSE IS NECESSARY HERE?  TO PREVENT ITEMS CREATED BEFORE TODAY'S DATE FROM BEING PUSHED OUT INTO THE FUTURE?
-- BUT I THOUGHT THAT WAS THE ENTIRE POINT OF ADDING THE v_due_date_adjustment TO THE VARIOUS "due-date" VALUES:
-- TO "MAKE THEM LATER," AND THUS PREVENT THEM FROM BEING INCLUDED IN THE "TOTAL OF WHAT IS DUE/OVERDUE," ETC.
-- I kept asking gwright how it is that the line-items are determined to be "paid-off" or "not-paid-off" and
-- thence how they're considered "overdue" or merely "due."
-- Until I have *lots* more clarity about what it means for an item to be considered "overdue," and
-- especially in the context of the statement-generation process, we have some more wood-shedding to do
-- with this statement-generation issue.
-- gwright and I had some back-and-forth about this, and now it seems that he's not sure that what we've done
-- here is the entirely appropriate thing to do.
                     BETWEEN TRUNC(v_last_stmt_date_global) AND v_statement_date_global)
                OR 
                (-- Prepay items should be consider due on first move into F3 section
                 get_prepay(LASL.PAYMENT_SCHEDULE_ID,'N','Y') = LASL.PAYMENT_SCHEDULE_ID
                 AND NOT EXISTS (SELECT 1 
                        FROM LWX_AR_STMT_LINES SL2
                        WHERE SL2.STMT_HDR_ID <> v_stmt_header_id
                        AND SL2.REC_TYPE_CDE = 'F3'
                        AND SL2.CUSTOMER_TRX_ID = LASL.CUSTOMER_TRX_ID))
               );

        log('d','Transaction Due Amount ' ||
                  to_char(v_due_amt, '999,999,999,990.00'));

        -- Jude Lam 07/20/06 Added the IF logic:
        IF v_actual_ovr_due_amt < 0 THEN
          v_due_amt := v_due_amt + v_actual_ovr_due_amt;
        END IF;

        IF v_due_amt < 0 THEN
          v_due_amt := 0;
        END IF;

        -- Arrive Payment Amount (TO_PAY_AMT)
        v_process_stage := 'Derive F3 Payment Amount using stmt_header_id: ' ||
                           to_char(v_stmt_header_id) ||
                           ' and v_statement_date_global: ' ||
                           to_char(v_statement_date_global,
                                   'MM/DD/YYYY HH24:MI:SS');

        -- Jude Lam 05/02/06 Modify the query.
        SELECT NVL((dbt.DBT_AMT + cre.CRE_AMT), 0)
          INTO v_to_pay_amt
          FROM (SELECT nvl(SUM(nvl(LASL1.OUTSTND_AMT, 0)), 0) DBT_AMT
                  FROM LWX_AR_STMT_LINES LASL1
                 WHERE STMT_HDR_ID = v_stmt_header_id
                   AND REC_TYPE_CDE = 'F3'
                   AND OUTSTND_AMT >= 0
                   AND (DUE_DTE + v_due_date_adjustment) <= v_statement_date_global
                ) dbt,
               (SELECT nvl(SUM(nvl(LASL2.OUTSTND_AMT, 0)), 0) CRE_AMT
                  FROM LWX_AR_STMT_LINES LASL2
                 WHERE STMT_HDR_ID = v_stmt_header_id
                   AND REC_TYPE_CDE = 'F3'
                   AND OUTSTND_AMT < 0
                ) cre;

        log('d','Payment Amount ' ||
                  to_char(v_to_pay_amt, '999,999,999,990.00'));

        IF v_to_pay_amt < 0 THEN
          v_to_pay_amt := 0;
        END IF;

        IF v_to_pay_amt > 999999.99 THEN
          v_to_pay_amt_ocr := 0;
          v_process_stage := '*** Warning: (4) Amount due exceeds 999,999.99. Please check customer ' ||
                           v_customer_rec.CUSTOMER_NUMBER;
          log('l', v_process_stage);
        ELSE
          v_to_pay_amt_ocr := v_to_pay_amt;
        END IF;

        v_scan_line_nme := Lwx_Stmt_Scanned_Line_Logic(v_customer_rec.CUSTOMER_NUMBER,
                                                       v_to_pay_amt_ocr,
                                                       retcode);
        -- Arrive Not Due Amount (NOT_DUE_AMT)
        v_process_stage := 'Derive F3 No Due Amount using v_stmt_header_id: ' ||
                           to_char(v_stmt_header_id) ||
                           ' and v_statement_date_global: ' ||
                           to_char(v_statement_date_global,
                                   'MM/DD/YYYY HH24:MI:SS');

        SELECT NVL(SUM(nvl(OUTSTND_AMT, 0)), 0)
          INTO v_no_due_amt
          FROM LWX_AR_STMT_LINES
         WHERE STMT_HDR_ID = v_stmt_header_id
           AND REC_TYPE_CDE = 'F3'
           AND TOTAL_DUE_AMT >= 0
           AND (DUE_DTE + v_due_date_adjustment) > v_statement_date_global;

        log('d','No Due Amount ' ||
                  to_char(v_no_due_amt, '999,999,999,990.00'));

        -- Arrive Balance Amount (BALANCE_AMT)
        v_process_stage := 'Arrive Balance Amount using stmt_header_id: ' ||
                           to_char(v_stmt_header_id);

        -- Jude Lam 05/02/06 Modify the query.
        SELECT NVL(SUM(OUTSTND_AMT), 0)
          INTO v_balance_amt
          FROM LWX_AR_STMT_LINES LASL
         WHERE STMT_HDR_ID = v_stmt_header_id
           AND REC_TYPE_CDE = 'F3';

        log('d','Balance Amount ' ||
                  to_char(v_balance_amt, '999,999,999,990.00'));

        -- Update the Statement Header Level Information for LWX_AR_STMT_HEADERS
        v_process_stage := 'Update the Statement Header Level Informations';

        log('d',v_process_stage);

        log('d','Update the LWX_AR_STMT_HEADERS table header id ' ||
                  v_stmt_header_id || ' PPD Page Count ' || v_ppd_page_cnt ||
                  ' Detail Page Count ' || v_dtl_page_cnt ||
                  ' Invoice Page Count ' || v_invo_page_cnt ||
                  ' Total Page Count ' || v_total_page_cnt ||
                  ' Over Due Amount ' || v_ovr_due_amt || ' Due Amount ' ||
                  v_due_amt || ' To Payment Amount ' || v_to_pay_amt ||
                  ' Not Due Amount ' || v_no_due_amt || ' Balance Amount ' ||
                  v_balance_amt);

        UPDATE LWX_AR_STMT_HEADERS
           SET PPD_PAGE_CNT   = v_ppd_page_cnt,
               DTL_PAGE_CNT   = v_dtl_page_cnt,
               INVO_PAGE_CNT  = v_invo_page_cnt,
               TOTAL_PAGE_CNT = v_total_page_cnt,
               OVER_DUE_AMT   = v_ovr_due_amt,
               DUE_AMT        = v_due_amt,
               TO_PAY_AMT     = v_to_pay_amt,
               NOT_DUE_AMT    = v_no_due_amt,
               BALANCE_AMT    = v_balance_amt,
               SCAN_LINE_NME  = v_scan_line_nme
         WHERE STMT_HDR_ID = v_stmt_header_id;
         
      END IF; -- End of Current open balance check

      log('l',
                        'End of v_customer_Cur: for customer id: ' ||
                        TO_CHAR(v_customer_rec.CUSTOMER_ID));
      log('l',
                        'End Customer ' || v_customer_rec.CUSTOMER_NUMBER);
      log('l',
                        '++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++');

    END LOOP; -- End of Customer cursor

    -- Commit transactions
    COMMIT;
    -- Call to Data File Phase
    Lwx_Data_File_Phase(retcode);
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      -- Write Stage to the Log
      log('l', v_process_stage);
      log('l',
                        v_process_stage || sqlcode || SQLERRM);
      -- Set Concurrent Request Run Status to Error
      retcode := 2;
      --Rollback transactions
      ROLLBACK;
      -- Raise Application Error
      app_error(-20001,'ERROR in Generate_Con_Stmt',null,sqlcode,sqlerrm);
    WHEN v_when_others THEN
      -- Write Stage to the Log
      log('l', v_process_stage);
      log('l',
                        v_process_stage || sqlcode || SQLERRM);
      -- Set Concurrent Request Run Status to Error
      retcode := 2;
      --Rollback transactions
      ROLLBACK;
      -- Raise Application Error
      app_error(-20001,'ERROR in Generate_Con_Stmt',null,sqlcode,sqlerrm);      
    WHEN OTHERS THEN
      -- Write Stage to the Log
      log('l', v_process_stage);
      log('l',v_process_stage || sqlcode || SQLERRM);
      --Rollback transactions
      ROLLBACK;
      -- Set Concurrent Request Run Status to Error
      retcode := 2;
      -- Raise Application Error
      app_error(-20001,'ERROR in Generate_Con_Stmt',null,sqlcode,sqlerrm);
  END Generate_Con_Stmt;

  PROCEDURE Lwx_Ar_Build_F1_Type_Rec(p_customer_cur_rec IN v_customer_cur_rec_type,
                                     p_stmt_header_id   IN OUT NUMBER,
                                     p_customer_address_1   IN HZ_LOCATIONS.ADDRESS1%TYPE,
                                     p_customer_address_2   IN HZ_LOCATIONS.ADDRESS2%TYPE,
                                     p_customer_address_3   IN HZ_LOCATIONS.ADDRESS3%TYPE,
                                     p_customer_address_4   IN HZ_LOCATIONS.ADDRESS4%TYPE,
                                     p_customer_city        IN HZ_LOCATIONS.CITY%TYPE,
                                     p_customer_state       IN HZ_LOCATIONS.STATE%TYPE,
                                     p_customer_postal_code IN HZ_LOCATIONS.POSTAL_CODE%TYPE,
                                     p_customer_country     IN FND_TERRITORIES_VL.TERRITORY_SHORT_NAME%TYPE,
                                     p_cust_acct_site_id    IN HZ_CUST_ACCT_SITES.CUST_ACCT_SITE_ID%TYPE,
                                     retcode            IN OUT NUMBER) IS

    --- ***************************************************************************************************************
    ---   Program DESCRIPTION      :  This is the program that will populate F1 Type Record Data into the Custom Table.
    ---
    ---   Parameters Used          :  errbuf            - Out type parameter to return Error message from the concurrent
    ---                               retcode           - Out type parameter to return the concurrent status
    ---   p_statement_cycle_nme   -   In type parameter. This parameter will contain the
    ---                               statement cycle name from the AR_STATEMENT_CYCLES
    ---                               table.  This field is an optional field.If this field
    ---                               is blank, the program should process all statement
    ---                               cycles.  If this field is specified, only the customer
    ---                               that has the statement cycle assigned in their customer
    ---                               header level profile will be considered.
    ---
    ---  Development and Maintenance History:
    ---  -------------------------------------
    ---  DATE         AUTHOR                   DESCRIPTION
    ---  ----------   ------------------------ ---------------------------------------------------------
    ---  20-DEC-2005  S Saravana Bhavan, BCT   Initial Creation
    ---  14-MAR-2006  Rajmohan K, BCT          Added debug message for log file
    ---  18-NOV-2009  Jason McCleskey          Put Logo Code and Stmt_Msg1/2 in cust cursor instead 
    ---                                          of requerying multiple times in this procedure
    --- ***************************************************************************************************************

    -- Local varibles declaration
    v_process_stage        VARCHAR2(240);
    l_stmt_header_id       LWX_AR_STMT_HEADERS.STMT_HDR_ID%TYPE;
    v_stmt_currency_code   LWX_AR_STMT_HEADERS.STMT_CRNCY_CDE%TYPE;
    v_cust_acct_site_id    HZ_CUST_ACCT_SITES.CUST_ACCT_SITE_ID%TYPE;
    v_customer_address1    HZ_LOCATIONS.ADDRESS1%TYPE;
    v_customer_address2    HZ_LOCATIONS.ADDRESS2%TYPE;
    v_customer_address3    HZ_LOCATIONS.ADDRESS3%TYPE;
    v_customer_address4    HZ_LOCATIONS.ADDRESS4%TYPE;
    v_customer_city        HZ_LOCATIONS.CITY%TYPE;
    v_customer_state       HZ_LOCATIONS.STATE%TYPE;
    v_customer_postal_code HZ_LOCATIONS.POSTAL_CODE%TYPE;
    v_customer_country     FND_TERRITORIES_VL.TERRITORY_SHORT_NAME%TYPE;
    v_telephone_number     AR_COLLECTORS.TELEPHONE_NUMBER%TYPE;
    v_email_address        AR_COLLECTORS.ATTRIBUTE1%TYPE;
    v_fax_number           AR_COLLECTORS.ATTRIBUTE2%TYPE;
    v_statement_due_date   AR_STATEMENT_CYCLE_DATES.STATEMENT_DATE%TYPE;

    v_conc_req_id        LWX_AR_STMT_HEADERS.STMT_RUN_CONC_REQ_ID%TYPE;
    v_current_user       LWX_AR_STMT_HEADERS.CREATED_BY%TYPE;
    v_update_login       LWX_AR_STMT_HEADERS.LAST_UPDATE_LOGIN%TYPE;
    v_cust_email_adr     LWX_AR_STMT_HEADERS.CUST_EMAIL_ADR%TYPE;
  BEGIN
    -- Get the Concurrent Request Id
    v_conc_req_id  := TO_NUMBER(fnd_profile.VALUE('CONC_REQUEST_ID'));
    v_current_user := TO_NUMBER(fnd_profile.VALUE('USER_ID'));
    v_update_login := TO_NUMBER(fnd_profile.VALUE('LOGIN_ID'));
    -- Build Statement summary Message (SQL #1)

    -- Jude Lam 04/26/06 Combine the SQL statement for performance.
    log('d','Statement Summary Message1 ' || p_customer_cur_rec.stmt_msg1);
    log('d','Statement Summary Message2 ' || p_customer_cur_rec.stmt_msg2);

    v_process_stage := 'Find Statement Site Address for customer id: ' ||
                       to_char(p_customer_cur_rec.customer_id);

    v_customer_address1    := p_customer_address_1;
    v_customer_address2    := p_customer_address_2;
    v_customer_address3    := p_customer_address_3;
    v_customer_address4    := p_customer_address_4;
    v_customer_city        := p_customer_city;
    v_customer_state       := p_customer_state;
    v_customer_postal_code := p_customer_postal_code;
    v_customer_country     := p_customer_country;
    v_cust_acct_site_id    := p_cust_acct_site_id;
    v_cust_email_adr       := p_customer_cur_rec.CUST_EMAIL_ADR;

    log('d','Sales Channel Code ' || p_customer_cur_rec.sales_channel_code);
    log('d','Logo Code ' || p_customer_cur_rec.hdr_logo_code);
    log('d','CUST_ACCT_SITE_ID ' || v_cust_acct_site_id);
    log('d','Cust_Email_Adr ' || nvl(v_cust_email_adr,'NULL'));

    v_process_stage := 'Find Telephone Number for the Current Customer Collector Id: ' ||
                       to_char(p_customer_cur_rec.collector_id); -- Jude Lam 05/19/06 update to add collector id.

    -- Find Telephone Number, Fax Number and Email Address
    SELECT TELEPHONE_NUMBER, ATTRIBUTE1, ATTRIBUTE2
      INTO v_telephone_number, v_email_address, v_fax_number
      FROM AR_COLLECTORS
     WHERE COLLECTOR_ID = p_customer_cur_rec.COLLECTOR_ID
       AND STATUS = 'A';

    log('d','Collector ID ' || p_customer_cur_rec.COLLECTOR_ID ||
              ' Collectors Telephone Number ' || v_telephone_number ||
              ' Collectors Email Address ' || v_email_address ||
              ' Collectors Fax Number ' || v_fax_number);

    v_process_stage := 'Insert Data into LWX_AR_STMT_HEADERS - F1 Type Record';
    -- Insert the data into the LWX_AR_STMT_HEADERS

    -- Assign values to the field variables
    v_stmt_currency_code := 'USD';

    v_statement_due_date := v_statement_date_global + 25;

    SELECT AR_STATEMENT_HEADERS_S.NEXTVAL INTO l_stmt_header_id FROM DUAL;

    p_stmt_header_id := l_stmt_header_id;

    INSERT INTO LWX_AR_STMT_HEADERS
      (STMT_HDR_ID,
       STATEMENT_CYCLE_ID,
       STMT_RUN_CONC_REQ_ID,
       STMT_DTE,
       STMT_CRNCY_CDE,
       STMT_LANG_CDE,
       PPD_PAGE_CNT,
       DTL_PAGE_CNT,
       INVO_PAGE_CNT,
       TOTAL_PAGE_CNT,
       LOGO_CDE,
       SEND_TO_CUST_ACCT_SITE_ID,
       SEND_TO_CUST_NBR,
       SEND_TO_CUST_NME,
       SEND_TO_LINE_1_ADR,
       SEND_TO_LINE_2_ADR,
       SEND_TO_LINE_3_ADR,
       SEND_TO_LINE_4_ADR,
       SEND_TO_CITY_NME,
       SEND_TO_STATE_CDE,
       SEND_TO_POSTAL_CDE,
       SEND_TO_CNTRY_NME,
       REP_PHONE_NBR,
       OVER_DUE_AMT,
       DUE_AMT,
       TO_PAY_AMT,
       STMT_DUE_DTE,
       NOT_DUE_AMT,
       BALANCE_AMT,
       MSG1_NME,
       MSG2_NME,
       LW_FAX_NBR,
       LW_EMAIL_ADR,
       CREATED_BY,
       CREATION_DATE,
       LAST_UPDATED_BY,
       LAST_UPDATED_DATE,
       LAST_UPDATE_LOGIN,
       CUST_EMAIL_ADR)
    VALUES
      (l_stmt_header_id,
       p_customer_cur_rec.STATEMENT_CYCLE_ID,
       v_conc_req_id,
       SYSDATE,
       v_stmt_currency_code,
       p_customer_cur_rec.ATTRIBUTE1,
       NULL,
       NULL,
       NULL,
       NULL,
       p_customer_cur_rec.hdr_logo_code,
       v_cust_acct_site_id,
       p_customer_cur_rec.CUSTOMER_NUMBER,
       p_customer_cur_rec.CUSTOMER_NAME,
       v_customer_address1,
       v_customer_address2,
       v_customer_address3,
       v_customer_address4,
       v_customer_city,
       v_customer_state,
       v_customer_postal_code,
       v_customer_country,
       v_telephone_number,
       NULL,
       NULL,
       NULL,
       v_statement_due_date,
       NULL,
       NULL,
       p_customer_cur_rec.stmt_msg1,
       p_customer_cur_rec.stmt_msg2,
       v_fax_number,
       v_email_address,
       v_current_user,
       SYSDATE,
       v_current_user,
       SYSDATE,
       v_update_login,
       v_cust_email_adr);
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      -- Write Stage to the Log
      log('l', v_process_stage);
      -- Set Concurrent Request Run Status to Error
      retcode := 2;
      --Rollback transactions
      ROLLBACK;
      -- Raise Application Error
      app_error(-20001,'ERROR in Lwx_Ar_Build_F1_Type_Rec',null,sqlcode,sqlerrm);
    WHEN OTHERS THEN
      -- Write Stage to the Log
      log('l', v_process_stage);
      -- Set Concurrent Request Run Status to Error
      retcode := 2;
      --Rollback transactions
      ROLLBACK;
      -- Raise Application Error
      app_error(-20001,'ERROR in Lwx_Ar_Build_F1_Type_Rec',null,sqlcode,sqlerrm);
  END Lwx_Ar_Build_F1_Type_Rec;

  PROCEDURE Lwx_Ar_Build_F2_Type_Rec(p_stmt_line_cnt    IN NUMBER,
                                     p_customer_cur_rec IN v_customer_cur_rec_type,
                                     p_openitem_cur_rec IN v_openitem_cur_rec_type,
                                     retcode            OUT NUMBER) IS

    --- ***************************************************************************************************************
    ---   Program DESCRIPTION     :  This is the program that will populate F2 Type Record Data into the Custom Table.
    ---
    ---   Parameters Used         :  p_stmt_line_cnt
    ---                              p_customer_cur_rec
    ---                              p_openitem_cur_rec
    ---                              retcode
    ---
    ---
    ---  Development and Maintenance History:
    ---  -------------------------------------
    ---  DATE         AUTHOR                   DESCRIPTION
    ---  ----------   ------------------------ ---------------------------------------------------------
    ---  20-DEC-2005  S Saravana Bhavan, BCT   Initial Creation
    ---  14-MAR-2006  Rajmohan K, BCT          Added debug message for log file
    ---  2006-04-25   Jude Lam, TITAN          Redo the Freight section to use the Profile Option item.
    ---  2006-05-23   Jude Lam, TITAN          Added the logic to check installment number.
    ---  2006-06-07   Jude Lam, TITAN          Update to pull COMMENTS field from ar_cash_receipts if the class
    ---                                           is a PMT payment type transaction.
    ---  18-NOV-2009  Jason McCleskey          Put Logo Code and Stmt_Msg1/2 in cust cursor instead 
    ---                                          of requerying multiple times in this procedure
    ---                                         Modified to call get_line_amounts instead of duplicated 
    ---                                           code in F2 and F3
    ---                                         Put Doc Type Name in open item cursor instead of requerying
    --- ***************************************************************************************************************

    -- Local varibles declaration
    v_process_stage       VARCHAR2(240);
    v_stmt_hdr_id         LWX_AR_STMT_LINES.STMT_HDR_ID%TYPE;
    v_stmt_line_nbr       LWX_AR_STMT_LINES.STMT_LINE_NBR%TYPE;
    v_incl_cur_stmt_ind   LWX_AR_STMT_LINES.INCL_CUR_STMT_IND%TYPE;
    v_rec_type_cde        LWX_AR_STMT_LINES.REC_TYPE_CDE%TYPE;
    v_customer_trx_id     LWX_AR_STMT_LINES.CUSTOMER_TRX_ID%TYPE;
    v_cash_receipt_id     LWX_AR_STMT_LINES.CASH_RECEIPT_ID%TYPE;
    v_payment_schedule_id LWX_AR_STMT_LINES.PAYMENT_SCHEDULE_ID%TYPE;
    v_spcl_line_ind       LWX_AR_STMT_LINES.SPCL_LINE_IND%TYPE;
    v_trans_dte           LWX_AR_STMT_LINES.TRANS_DTE%TYPE;
    v_trans_nbr           LWX_AR_STMT_LINES.TRANS_NBR%TYPE;
    v_sls_chnl_nme        LWX_AR_STMT_LINES.SLS_CHNL_NME%TYPE;
    v_cust_ref_nme        LWX_AR_STMT_LINES.CUST_REF_NME%TYPE;
    v_fut_pmt_ind         LWX_AR_STMT_LINES.FUT_PMT_IND%TYPE;
    v_partial_pmt_ind     LWX_AR_STMT_LINES.PARTIAL_PMT_IND%TYPE;
    v_due_dte             LWX_AR_STMT_LINES.DUE_DTE%TYPE;
    v_doc_ref_nme         LWX_AR_STMT_LINES.DOC_REF_NME%TYPE;
    v_orig_amt            LWX_AR_STMT_LINES.ORIG_AMT%TYPE;
    v_outstnd_amt         LWX_AR_STMT_LINES.OUTSTND_AMT%TYPE;
    v_sub_total_amt       LWX_AR_STMT_LINES.SUB_TOTAL_AMT%TYPE;
    v_ship_hndl_amt       LWX_AR_STMT_LINES.SHIP_HNDL_AMT%TYPE;
    v_tax_amt             LWX_AR_STMT_LINES.TAX_AMT%TYPE;
    v_pmt_used_amt        LWX_AR_STMT_LINES.PMT_USED_AMT%TYPE;
    v_total_due_amt       LWX_AR_STMT_LINES.TOTAL_DUE_AMT%TYPE;
    v_mkt_msg1_nme        LWX_AR_STMT_LINES.MKT_MSG1_NME%TYPE;
    v_mkt_msg2_nme        LWX_AR_STMT_LINES.MKT_MSG2_NME%TYPE;
    v_mkt_msg3_nme        LWX_AR_STMT_LINES.MKT_MSG3_NME%TYPE;
    v_mkt_msg4_nme        LWX_AR_STMT_LINES.MKT_MSG4_NME%TYPE;
    v_outstanding_amt     NUMBER;
    v_current_user        LWX_AR_STMT_LINES.CREATED_BY%TYPE;
    v_update_login        LWX_AR_STMT_LINES.LAST_UPDATE_LOGIN%TYPE;
    v_installment_count   NUMBER := 0;
    v_trx_logo            LWX_AR_STMT_LINES.LOGO_CDE%TYPE;
    v_true_purchase_order LWX_AR_STMT_LINES.PURCHASE_ORDER%TYPE;
    v_true_comments       LWX_AR_STMT_LINES.COMMENTS%TYPE;
    
  BEGIN
    -- Assign Values to the variables
    v_process_stage := 'Assigning values to the variable';
    v_current_user  := TO_NUMBER(fnd_profile.VALUE('USER_ID'));
    v_update_login  := TO_NUMBER(fnd_profile.VALUE('LOGIN_ID'));

    log('d','Start of Lwx_Ar_Build_F2_Type_Rec Procedure');

    SELECT LWX_AR_STMT_LINES_S.NEXTVAL INTO v_stmt_line_id FROM DUAL;

    SELECT AR_STATEMENT_HEADERS_S.CURRVAL INTO v_stmt_hdr_id FROM DUAL;

    v_stmt_line_nbr       := p_stmt_line_cnt;
    v_rec_type_cde        := 'F2';
    v_customer_trx_id     := p_openitem_cur_rec.CUSTOMER_TRX_ID;
    v_cash_receipt_id     := p_openitem_cur_rec.CASH_RECEIPT_ID;
    v_payment_schedule_id := p_openitem_cur_rec.PAYMENT_SCHEDULE_ID;
    v_spcl_line_ind       := NULL; -- Depends on the Prepaid Process
    v_trans_dte           := p_openitem_cur_rec.TRX_DATE;
    v_trans_nbr           := substr(p_openitem_cur_rec.TRX_NUMBER,1,20);
    v_sls_chnl_nme        := p_openitem_cur_rec.ATTRIBUTE5;
--gw    v_cust_ref_nme        := replace(p_openitem_cur_rec.PURCHASE_ORDER,'|',' ');
    v_cust_ref_nme        := regexp_replace(p_openitem_cur_rec.PURCHASE_ORDER, '[^ -{^}~]', '');
    v_due_dte             := p_openitem_cur_rec.DUE_DATE;
    v_doc_ref_nme         := substr(p_openitem_cur_rec.TRX_NUMBER,1,20);
    v_orig_amt            := p_openitem_cur_rec.AMOUNT_DUE_ORIGINAL;
    v_outstnd_amt         := p_openitem_cur_rec.AMOUNT_DUE_REMAINING;
    v_mkt_msg1_nme        := SUBSTR(p_openitem_cur_rec.ATTRIBUTE6,
                                    1,
                                    INSTR(p_openitem_cur_rec.ATTRIBUTE6, '|') - 1);
    v_mkt_msg2_nme        := SUBSTR(p_openitem_cur_rec.ATTRIBUTE6,
                                    INSTR(p_openitem_cur_rec.ATTRIBUTE6, '|') + 1);
    v_mkt_msg3_nme        := SUBSTR(p_openitem_cur_rec.ATTRIBUTE7,
                                    1,
                                    INSTR(p_openitem_cur_rec.ATTRIBUTE7, '|') - 1);
    v_mkt_msg4_nme        := SUBSTR(p_openitem_cur_rec.ATTRIBUTE7,
                                    INSTR(p_openitem_cur_rec.ATTRIBUTE7, '|') + 1);
    
    v_true_purchase_order := regexp_replace(p_openitem_cur_rec.TRUE_PURCHASE_ORDER, '[^ -{^}~]', '');
    v_true_comments       := regexp_replace(p_openitem_cur_rec.TRUE_COMMENTS, '[^ -{^}~]', '');
                                        
    v_process_stage       := 'Find Current Statement Indicator';
    log('d','Inside Lwx_Ar_Build_F2_Type_Rec Procedure ' ||
              ' Record Type Code ' || v_rec_type_cde ||
              ' Customer Transaction ID ' || v_customer_trx_id ||
              ' Cash Receipt ID ' || v_cash_receipt_id ||
              ' Payment Schedule ID ' || v_payment_schedule_id ||
              ' Transaction Date ' || v_trans_dte ||
              ' Transaction Number ' || v_trans_nbr ||
              ' Sales Channel Name ' || v_sls_chnl_nme ||
              ' Customer Reference ' || v_cust_ref_nme ||
              ' Document Reference Name ' || v_doc_ref_nme ||
              ' Original Amount ' || v_orig_amt || ' Due Date ' ||
              v_due_dte || ' Outstanding Amount ' || v_outstnd_amt ||
              '  Mkt Message1 Name ' || v_mkt_msg1_nme ||
              ' Mkt Message2 Name ' || v_mkt_msg2_nme ||
              ' Mkt Message3 Name ' || v_mkt_msg3_nme ||
              ' Mkt Message4 Name ' || v_mkt_msg4_nme);

    -- Get the current statement indicator
    IF (nvl(trunc(v_due_dte), trunc(v_trans_dte)) + v_due_date_adjustment) <= v_statement_date_global THEN
      v_incl_cur_stmt_ind := 'Y';
    ELSE
      v_incl_cur_stmt_ind := 'N';
    END IF;

    -- Jude Lam 06/07/06 Added the retrieval of COMMENTS into this variable if the class is payment.
    IF p_openitem_cur_rec.class = 'PMT' THEN

      v_process_stage := 'Retrieve COMMENTS information for cash_receipt_id: ' ||
                         to_char(p_openitem_cur_rec.cash_receipt_id);

      -- dhoward 17/Mar/08 - removed multi line chr
--gw      SELECT SUBSTR(replace(replace(COMMENTS,CHR(10),' '),CHR(13),''), 1, 30)
      SELECT SUBSTR(regexp_replace(COMMENTS, '[^ -{^}~]', ''), 1, 30)
        INTO v_cust_ref_nme
        FROM AR_CASH_RECEIPTS
       WHERE CASH_RECEIPT_ID = p_openitem_cur_rec.cash_receipt_id;

    END IF;

    -- Find the statement logo code
    log('d','Sales Channel Code ' || p_customer_cur_rec.sales_channel_code);
    v_trx_logo:= get_trx_logo(p_openitem_cur_rec.attribute3,p_customer_cur_rec.line_logo_code);
    log('d','Logo Code ' || v_trx_logo);

    -- Get the Document Type Name
    log('l',' Document Type Name ' || p_openitem_cur_rec.doc_type_nme);

    -- Get the Outstanding Amount
    v_process_stage := 'Get the Out Standing Amount Calling the Standard Function';

    v_outstanding_amt := NVL(Arpt_Sql_Func_Util.Get_Balance_Due_As_Of_Date(p_openitem_cur_rec.PAYMENT_SCHEDULE_ID,
                                                                           v_statement_date_global,
                                                                           p_openitem_cur_rec.CLASS),
                             0);

    log('d',' Outstanding Amount ' ||
              to_char(v_outstanding_amt, '999,999,999,990.00'));

    IF (v_orig_amt <> v_outstnd_amt) and (v_outstnd_amt <> 0) THEN
      v_partial_pmt_ind := 'P';
    ELSE
      v_partial_pmt_ind := NULL;
    END IF;

    -- Jude Lam 05/03/06 update to check for customer_trx_id first.
    IF p_openitem_cur_rec.customer_trx_id IS NOT NULL THEN
      v_process_stage := 'Query the Sub Total, Shipping, Tax and Applied Amounts for customer_trx_id: ' ||
                       to_char(p_openitem_cur_rec.customer_trx_id);
      
      get_line_amounts(p_openitem_cur_rec.customer_trx_id,
                       v_sub_total_amt, 
                       v_ship_hndl_amt, 
                       v_tax_amt,
                       v_pmt_used_amt);

      -- Arrive Total Due Amount
      v_process_stage := 'Arrive the Total Due Amount';

      v_total_due_amt := (v_sub_total_amt + v_ship_hndl_amt + v_tax_amt) -
                         v_pmt_used_amt;

      -- Jude Lam 05/23/06 Added the following to check to see if the current open item has 1 or more
      -- installment.  If there is one, then set the v_incl_cur_stmt_ind flag back to Y.
      SELECT COUNT(*)
        INTO v_installment_count
        FROM AR_PAYMENT_SCHEDULES
       WHERE CUSTOMER_TRX_ID = p_openitem_cur_rec.customer_trx_id;

      IF v_installment_count = 1 THEN
        v_incl_cur_stmt_ind := 'Y';
      END IF;

    ELSE

      -- Current p_openitem_cur_rec is a Payment.
      v_total_due_amt := 0;
      v_sub_total_amt := 0;
      v_ship_hndl_amt := 0;
      v_tax_amt       := 0;
      v_pmt_used_amt  := 0;

    END IF; -- End of checking customer_Trx_id is not null.

    -- Insert into LWX_AR_STMT_LINES Table
    v_process_stage := 'Insert Record into the LWX_AR_STMT_LINES Table';

    INSERT INTO LWX_AR_STMT_LINES
      (STMT_LINE_ID,
       STMT_HDR_ID,
       STMT_LINE_NBR,
       INCL_CUR_STMT_IND,
       REC_TYPE_CDE,
       CUSTOMER_TRX_ID,
       CASH_RECEIPT_ID,
       PAYMENT_SCHEDULE_ID,
       LOGO_CDE,
       SPCL_LINE_IND,
       TRANS_DTE,
       TRANS_NBR,
       DOC_TYPE_NME,
       SLS_CHNL_NME,
       CUST_REF_NME,
       FUT_PMT_IND,
       PARTIAL_PMT_IND,
       DUE_DTE,
       DOC_REF_NME,
       ORIG_AMT,
       OUTSTND_AMT,
       SUB_TOTAL_AMT,
       SHIP_HNDL_AMT,
       TAX_AMT,
       PMT_USED_AMT,
       TOTAL_DUE_AMT,
       MKT_MSG1_NME,
       MKT_MSG2_NME,
       MKT_MSG3_NME,
       MKT_MSG4_NME,
       CREATED_BY,
       CREATION_DATE,
       LAST_UPDATED_BY,
       LAST_UPDATE_DATE,
       LAST_UPDATE_LOGIN,
       PURCHASE_ORDER,
       COMMENTS)
    VALUES
      (v_stmt_line_id,
       v_stmt_hdr_id,
       v_stmt_line_nbr,
       v_incl_cur_stmt_ind,
       v_rec_type_cde,
       v_customer_trx_id,
       v_cash_receipt_id,
       v_payment_schedule_id,
       v_trx_logo,
       v_spcl_line_ind,
       v_trans_dte,
       v_trans_nbr,
       p_openitem_cur_rec.doc_type_nme,
       v_sls_chnl_nme,
       v_cust_ref_nme,
       v_fut_pmt_ind,
       v_partial_pmt_ind,
       v_due_dte,
       v_doc_ref_nme,
       v_orig_amt,
       v_outstnd_amt,
       v_sub_total_amt,
       v_ship_hndl_amt,
       v_tax_amt,
       v_pmt_used_amt,
       v_total_due_amt,
       v_mkt_msg1_nme,
       v_mkt_msg2_nme,
       v_mkt_msg3_nme,
       v_mkt_msg4_nme,
       v_current_user,
       SYSDATE,
       v_current_user,
       SYSDATE,
       v_update_login,
       v_true_purchase_order,
       v_true_comments);

    log('d','End of Lwx_Ar_Build_F2_Type_Rec Procedure');

  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      -- Write Stage to the Log
      log('l', v_process_stage);
      -- Set Concurrent Request Run Status to Error
      retcode := 2;
      --Rollback transactions
      ROLLBACK;
      -- Raise Application Error
      app_error(-20001,'ERROR in Lwx_Ar_Build_F2_Type_Rec Procedure',null,sqlcode,sqlerrm);
    WHEN OTHERS THEN
      -- Write Stage to the Log
      log('l', v_process_stage);
      -- Set Concurrent Request Run Status to Error
      retcode := 2;
      --Rollback transactions
      ROLLBACK;
      -- Raise Application Error
      app_error(-20001,'ERROR in Lwx_Ar_Build_F2_Type_Rec Procedure',null,sqlcode,sqlerrm);
  END Lwx_Ar_Build_F2_Type_Rec;

  PROCEDURE Lwx_Ar_Build_F3_Type_Rec(p_stmt_line_cnt    IN NUMBER,
                                     p_customer_cur_rec IN v_customer_cur_rec_type,
                                     p_openitem_cur_rec IN v_openitem_cur_rec_type,
                                     retcode            OUT NUMBER) IS

    --- ***************************************************************************************************************
    ---   Program DESCRIPTION  :  This is the program that will populate F3 Type Record Data into the Custom Table.
    ---
    ---   Parameters Used      :  p_stmt_line_cnt
    ---                           p_customer_cur_rec
    ---                           p_openitem_cur_re
    ---                           retcode
    ---
    ---  Development and Maintenance History:
    ---  -------------------------------------
    ---  DATE         AUTHOR                   DESCRIPTION
    ---  ----------   ------------------------ ---------------------------------------------------------
    ---  20-DEC-2005  S Saravana Bhavan, BCT   Initial Creation
    ---  14-MAR-2006  Rajmohan K, BCT          Added debug message for log file
    ---  2006-04-25   Jude Lam, TITAN          Redo the Freight section to use the Profile Option item.
    ---  2006-06-07   Jude Lam, TITAN          Update to pull COMMENTS field from ar_cash_receipts if the class
    ---                                           is a PMT payment type transaction.
    ---  18-NOV-2009  Jason McCleskey          Put Logo Code and Stmt_Msg1/2 in cust cursor instead 
    ---                                          of requerying multiple times in this procedure
    ---                                         Modified to call get_line_amounts instead of duplicated 
    ---                                           code in F2 and F3
    ---                                         Put Doc Type Name in open item cursor instead of requerying
    ---  2020-02-18   Rich Stewart             OF-3392 Changes use of due dates:
    ---                                        The v_due_date_adjustment package-level global is used
    ---                                        to "delay" the due-dates herein.
    --- ***************************************************************************************************************

    -- Local varibles declaration
    v_process_stage       VARCHAR2(240);
    v_stmt_line_id        LWX_AR_STMT_LINES.STMT_LINE_ID%TYPE;
    v_stmt_hdr_id         LWX_AR_STMT_LINES.STMT_HDR_ID%TYPE;
    v_stmt_line_nbr       LWX_AR_STMT_LINES.STMT_LINE_NBR%TYPE;
    v_incl_cur_stmt_ind   LWX_AR_STMT_LINES.INCL_CUR_STMT_IND%TYPE;
    v_rec_type_cde        LWX_AR_STMT_LINES.REC_TYPE_CDE%TYPE;
    v_customer_trx_id     LWX_AR_STMT_LINES.CUSTOMER_TRX_ID%TYPE;
    v_cash_receipt_id     LWX_AR_STMT_LINES.CASH_RECEIPT_ID%TYPE;
    v_payment_schedule_id LWX_AR_STMT_LINES.PAYMENT_SCHEDULE_ID%TYPE;
    v_spcl_line_ind       LWX_AR_STMT_LINES.SPCL_LINE_IND%TYPE;
    v_trans_dte           LWX_AR_STMT_LINES.TRANS_DTE%TYPE;
    v_trans_nbr           LWX_AR_STMT_LINES.TRANS_NBR%TYPE;
    v_sls_chnl_nme        LWX_AR_STMT_LINES.SLS_CHNL_NME%TYPE;
    v_cust_ref_nme        LWX_AR_STMT_LINES.CUST_REF_NME%TYPE;
    v_fut_pmt_ind         LWX_AR_STMT_LINES.FUT_PMT_IND%TYPE;
    v_partial_pmt_ind     LWX_AR_STMT_LINES.PARTIAL_PMT_IND%TYPE;
    v_due_dte             LWX_AR_STMT_LINES.DUE_DTE%TYPE;
    v_doc_ref_nme         LWX_AR_STMT_LINES.DOC_REF_NME%TYPE;
    v_orig_amt            LWX_AR_STMT_LINES.ORIG_AMT%TYPE;
    v_outstnd_amt         LWX_AR_STMT_LINES.OUTSTND_AMT%TYPE;
    v_sub_total_amt       LWX_AR_STMT_LINES.SUB_TOTAL_AMT%TYPE;
    v_ship_hndl_amt       LWX_AR_STMT_LINES.SHIP_HNDL_AMT%TYPE;
    v_tax_amt             LWX_AR_STMT_LINES.TAX_AMT%TYPE;
    v_pmt_used_amt        LWX_AR_STMT_LINES.PMT_USED_AMT%TYPE;
    v_total_due_amt       LWX_AR_STMT_LINES.TOTAL_DUE_AMT%TYPE;
    v_mkt_msg1_nme        LWX_AR_STMT_LINES.MKT_MSG1_NME%TYPE;
    v_mkt_msg2_nme        LWX_AR_STMT_LINES.MKT_MSG2_NME%TYPE;
    v_mkt_msg3_nme        LWX_AR_STMT_LINES.MKT_MSG3_NME%TYPE;
    v_mkt_msg4_nme        LWX_AR_STMT_LINES.MKT_MSG4_NME%TYPE;
    v_outstanding_amt     NUMBER;
    v_current_user        LWX_AR_STMT_LINES.CREATED_BY%TYPE;
    v_update_login        LWX_AR_STMT_LINES.LAST_UPDATE_LOGIN%TYPE;
    v_installment_count   NUMBER := 0;
    v_trx_logo            LWX_AR_STMT_LINES.LOGO_CDE%TYPE;    
    v_true_purchase_order LWX_AR_STMT_LINES.PURCHASE_ORDER%TYPE;
    v_true_comments       LWX_AR_STMT_LINES.COMMENTS%TYPE;
  BEGIN

    log('d','Start of Lwx_Ar_Build_F3_Type_Rec Procedure');

    -- Assign Values to the variables
    v_process_stage := 'Assign Values to the Variable';
    v_current_user  := TO_NUMBER(fnd_profile.VALUE('USER_ID'));
    v_update_login  := TO_NUMBER(fnd_profile.VALUE('LOGIN_ID'));

    SELECT LWX_AR_STMT_LINES_S.NEXTVAL INTO v_stmt_line_id FROM DUAL;

    SELECT AR_STATEMENT_HEADERS_S.CURRVAL INTO v_stmt_hdr_id FROM DUAL;

    v_stmt_line_nbr       := p_stmt_line_cnt;
    v_rec_type_cde        := 'F3';
    v_customer_trx_id     := p_openitem_cur_rec.CUSTOMER_TRX_ID;
    v_cash_receipt_id     := p_openitem_cur_rec.CASH_RECEIPT_ID;
    v_payment_schedule_id := p_openitem_cur_rec.PAYMENT_SCHEDULE_ID;
    v_spcl_line_ind       := 'N';
    v_trans_dte           := p_openitem_cur_rec.TRX_DATE;
    v_trans_nbr           := substr(p_openitem_cur_rec.TRX_NUMBER,1,20);
    v_sls_chnl_nme        := p_openitem_cur_rec.ATTRIBUTE5;
--gw    v_cust_ref_nme        := replace(p_openitem_cur_rec.PURCHASE_ORDER,'|',' ');
    v_cust_ref_nme        := regexp_replace(p_openitem_cur_rec.PURCHASE_ORDER, '[^ -{^}~]', '');
    v_due_dte             := p_openitem_cur_rec.DUE_DATE;
    v_doc_ref_nme         := substr(p_openitem_cur_rec.TRX_NUMBER,1,20);
    v_orig_amt            := p_openitem_cur_rec.AMOUNT_DUE_ORIGINAL;
    v_outstnd_amt         := p_openitem_cur_rec.AMOUNT_DUE_REMAINING;
    v_mkt_msg1_nme        := SUBSTR(p_openitem_cur_rec.ATTRIBUTE6,
                                    1,
                                    INSTR(p_openitem_cur_rec.ATTRIBUTE6, '|') - 1);
    v_mkt_msg2_nme        := SUBSTR(p_openitem_cur_rec.ATTRIBUTE6,
                                    INSTR(p_openitem_cur_rec.ATTRIBUTE6, '|') + 1);
    v_mkt_msg3_nme        := SUBSTR(p_openitem_cur_rec.ATTRIBUTE7,
                                    1,
                                    INSTR(p_openitem_cur_rec.ATTRIBUTE7, '|') - 1);
    v_mkt_msg4_nme        := SUBSTR(p_openitem_cur_rec.ATTRIBUTE7,
                                    INSTR(p_openitem_cur_rec.ATTRIBUTE7, '|') + 1);
    v_true_comments       := regexp_replace(p_openitem_cur_rec.TRUE_COMMENTS, '[^ -{^}~]', '');                                    
    v_true_purchase_order := regexp_replace(p_openitem_cur_rec.TRUE_PURCHASE_ORDER, '[^ -{^}~]', '');     

    log('d','Inside Lwx_Ar_Build_F3_Type_Rec Procedure ' ||
              ' Record Type Code ' || v_rec_type_cde ||
              ' Customer Transaction ID ' || v_customer_trx_id ||
              ' Cash Receipt ID ' || v_cash_receipt_id ||
              ' Payment Schedule ID ' || v_payment_schedule_id ||
              ' Transaction Date ' || v_trans_dte ||
              ' Transaction Number ' || v_trans_nbr ||
              ' Sales Channel Name ' || v_sls_chnl_nme ||
              ' Customer Reference Name ' || v_cust_ref_nme ||
              ' Document Reference Name ' || v_doc_ref_nme ||
              ' Original Amount ' || v_orig_amt || ' Due Date ' ||
              v_due_dte || ' Outstanding Amount ' || v_outstnd_amt ||
              ' Mkt Message1 Name ' || v_mkt_msg1_nme ||
              ' Mkt Message2 Name ' || v_mkt_msg2_nme ||
              ' Mkt Message3 Name ' || v_mkt_msg3_nme ||
              ' Mkt Message4 Name ' || v_mkt_msg4_nme);

    -- Get the current statement indicator
    v_process_stage := 'Get the Current Statement Indicator';

    IF (nvl(trunc(v_due_dte), trunc(v_trans_dte)) + v_due_date_adjustment) <= v_statement_date_global THEN
      v_incl_cur_stmt_ind := 'Y';
    ELSE
      v_incl_cur_stmt_ind := 'N';
    END IF;

    -- Jude Lam 06/07/06 Added the retrieval of COMMENTS into this variable if the class is payment.
    IF p_openitem_cur_rec.class = 'PMT' THEN

      v_process_stage := 'Retrieve COMMENTS information for cash_receipt_id: ' ||
                         to_char(p_openitem_cur_rec.cash_receipt_id);

      -- dhoward 17/Mar/08 - remove multi line chr
--gw      SELECT SUBSTR(replace(replace(COMMENTS,CHR(10),' '),CHR(13),''), 1, 30)
      SELECT SUBSTR(regexp_replace(COMMENTS, '[^ -{^}~]', ''), 1, 30)
        INTO v_cust_ref_nme
        FROM AR_CASH_RECEIPTS
       WHERE CASH_RECEIPT_ID = p_openitem_cur_rec.cash_receipt_id;

    END IF;

    -- Find the statement logo code
    log('d','Sales Channel Code ' || p_customer_cur_rec.sales_channel_code);
    v_trx_logo:= get_trx_logo(p_openitem_cur_rec.attribute3,p_customer_cur_rec.line_logo_code);
    log('d','Logo Code ' || v_trx_logo);
        
    -- Get the Document Type Name
    log('d','Document Type Name ' || p_openitem_cur_rec.doc_type_nme);

    -- Get the FUT Amount
    log('d','Checking due_date and statement date for future payment ind. with due date: ' ||
              to_char(p_openitem_cur_rec.due_Date,
                      'DD-MON-YYYY HH24:MI:SS') ||
              ' and v_statement_date_global: ' ||
              to_char(v_statement_date_global, 'DD-MON-YYYY HH24:MI:SS'));

    IF p_openitem_cur_rec.DUE_DATE > v_statement_date_global THEN
      v_fut_pmt_ind := '*';
    END IF;

    -- Get the Outstanding Amount
    v_process_stage   := 'Arrive the Out Standing Amount by calling arpt_sql_func_util.get_balance_due_as_of_date.';
    v_outstanding_amt := Arpt_Sql_Func_Util.Get_Balance_Due_As_Of_Date(p_openitem_cur_rec.PAYMENT_SCHEDULE_ID,
                                                                       v_statement_date_global,
                                                                       p_openitem_cur_rec.CLASS);

    log('d','Outstanding Amount ' ||
              to_char(v_outstanding_amt, '999,999,999,990.00'));

    IF (v_orig_amt <> v_outstnd_amt) and (v_outstnd_amt <> 0) THEN
      v_partial_pmt_ind := 'P';
    ELSE
      v_partial_pmt_ind := NULL;  
    END IF;

    IF p_openitem_cur_rec.customer_trx_id IS NOT NULL THEN
      -- Jude Lam 05/23/06 Added the following to check to see if the current open item has 1 or more
      -- installment.  If there is one, then set the v_incl_cur_stmt_ind flag back to Y.
      SELECT COUNT(*)
        INTO v_installment_count
        FROM AR_PAYMENT_SCHEDULES
       WHERE CUSTOMER_TRX_ID = p_openitem_cur_rec.customer_trx_id;

      IF v_installment_count = 1 THEN
        v_incl_cur_stmt_ind := 'Y';
      END IF;
    END IF;

    -- 05/03/06 Jude Lam update to add NVL() in customer_Trx_id.
    v_process_stage := 'Query the Sub Total, Shipping, Tax and Applied Amounts for customer_trx_id: ' ||
                       to_char(p_openitem_cur_rec.customer_trx_id);
    get_line_amounts(p_openitem_cur_rec.customer_trx_id,
                     v_sub_total_amt, 
                     v_ship_hndl_amt, 
                     v_tax_amt,
                     v_pmt_used_amt);

    -- Arrive Total Due Amount
    v_total_due_amt := (nvl(v_sub_total_amt, 0) + nvl(v_ship_hndl_amt, 0) +
                       nvl(v_tax_amt, 0)) - nvl(v_pmt_used_amt, 0);

    log('d','Total Due Amout: ' ||
              to_char(v_total_due_amt, '999,999,999,990.00'));

    -- Insert into LWX_AR_STMT_LINES Table
    v_process_stage := 'Insert Record into the LWX_AR_STMT_LINES Table';

    INSERT INTO LWX_AR_STMT_LINES
      (STMT_LINE_ID,
       STMT_HDR_ID,
       STMT_LINE_NBR,
       INCL_CUR_STMT_IND,
       REC_TYPE_CDE,
       CUSTOMER_TRX_ID,
       CASH_RECEIPT_ID,
       PAYMENT_SCHEDULE_ID,
       LOGO_CDE,
       SPCL_LINE_IND,
       TRANS_DTE,
       TRANS_NBR,
       DOC_TYPE_NME,
       SLS_CHNL_NME,
       CUST_REF_NME,
       FUT_PMT_IND,
       PARTIAL_PMT_IND,
       DUE_DTE,
       DOC_REF_NME,
       ORIG_AMT,
       OUTSTND_AMT,
       SUB_TOTAL_AMT,
       SHIP_HNDL_AMT,
       TAX_AMT,
       PMT_USED_AMT,
       TOTAL_DUE_AMT,
       MKT_MSG1_NME,
       MKT_MSG2_NME,
       MKT_MSG3_NME,
       MKT_MSG4_NME,
       CREATED_BY,
       CREATION_DATE,
       LAST_UPDATED_BY,
       LAST_UPDATE_DATE,
       LAST_UPDATE_LOGIN,
       PURCHASE_ORDER,
       COMMENTS)
    VALUES
      (v_stmt_line_id,
       v_stmt_hdr_id,
       v_stmt_line_nbr,
       v_incl_cur_stmt_ind,
       v_rec_type_cde,
       v_customer_trx_id,
       v_cash_receipt_id,
       v_payment_schedule_id,
       v_trx_logo,
       v_spcl_line_ind,
       v_trans_dte,
       v_trans_nbr,
       p_openitem_cur_rec.doc_type_nme,
       v_sls_chnl_nme,
       v_cust_ref_nme,
       v_fut_pmt_ind,
       v_partial_pmt_ind,
       v_due_dte,
       v_doc_ref_nme,
       v_orig_amt,
       v_outstnd_amt,
       v_sub_total_amt,
       v_ship_hndl_amt,
       v_tax_amt,
       v_pmt_used_amt,
       v_total_due_amt,
       v_mkt_msg1_nme,
       v_mkt_msg2_nme,
       v_mkt_msg3_nme,
       v_mkt_msg4_nme,
       v_current_user,
       SYSDATE,
       v_current_user,
       SYSDATE,
       v_update_login,
       v_true_purchase_order,
       v_true_comments);

    log('d','End of Lwx_Ar_Build_F3_Type_Rec Procedure');

  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      -- Write Stage to the Log
      log('l', v_process_stage);
      -- Set Concurrent Request Run Status to Error
      retcode := 2;
      --Rollback transactions
      ROLLBACK;
      -- Raise Application Error
      app_error(-20001,'ERROR in Lwx_Ar_Build_F3_Type_Rec Procedure',null,sqlcode,sqlerrm);
    WHEN OTHERS THEN
      -- Write Stage to the Log
      log('l', v_process_stage);
      -- Set Concurrent Request Run Status to Error
      retcode := 2;
      --Rollback transactions
      ROLLBACK;
      -- Raise Application Error
      app_error(-20001,'ERROR in Lwx_Ar_Build_F3_Type_Rec Procedure',null,sqlcode,sqlerrm);
  END Lwx_Ar_Build_F3_Type_Rec;

  PROCEDURE Get_Bill_To_Contact_Info(p_bill_to_customer_id IN NUMBER,
                                     p_cust_cont_phone_nbr IN OUT VARCHAR2,
                                     p_cust_cont_nme       IN OUT VARCHAR2,
                                     p_customer_trx_id     IN NUMBER,
                                     p_retcode             IN OUT NUMBER) IS
    --- ***************************************************************************************************************
    ---   Program DESCRIPTION  :  This is the Procedure will use the bill-to customer id to retrieve contact info.
    ---
    ---   Parameters Used      :  p_bill_to_customer_id
    ---                           p_cust_cont_phone_nbr

    ---
    ---   Development and Maintenance History:
    ---   -------------------------------------
    ---   DATE         AUTHOR                   DESCRIPTION
    ---   ----------   ------------------------ ---------------------------------------------------------
    ---   2006-04-26   Jude Lam, TITAN          Initial Creation
    ---   2007-11-07   Mike Miller              Issue P-745 (Dev ID D024), added 2 lines to address
    ---                                         problem involving invoices with contact having 2
    ---                                         phones causing abend.
    ---   2017-03-22   Greg Wright              Search by Order sold_to_contact_id
    --- ***************************************************************************************************************

    CURSOR primary_contact_cur IS
       select cnn.FIRST_NAME || ' ' || cnn.LAST_NAME contact_name,
              TRIM(ph.COUNTRY_CODE) || DECODE(ph.COUNTRY_CODE, NULL, NULL, '-') ||
                      TRIM(ph.AREA_CODE) || DECODE(ph.AREA_CODE, NULL, NULL, '-') ||
                      TRIM(ph.PHONE_NUMBER) PHONE_NUMBER
       from   ont.oe_order_headers_all    oh,
              apps.ar_contacts_v          cnn,
              apps.AR_PHONES_V            ph,
              ar.hz_cust_accounts         hca,
              ar.ra_customer_trx_all      rct
       where  rct.customer_trx_id = p_customer_trx_id       
       and    rct.batch_source_id = 1001
       and    to_number(rct.ct_reference) = oh.order_number
       and    oh.sold_to_contact_id is not null
       and    oh.sold_to_contact_id = cnn.CONTACT_ID
       and    ph.CONTACT_POINT_TYPE (+) = 'PHONE'
       AND    ph.OWNER_TABLE_NAME (+) = 'HZ_PARTIES'
       AND    ph.PHONE_TYPE (+) = 'GEN'
       AND    ph.PRIMARY_FLAG (+) = 'Y'                                                  -- issue P-745
       AND    ph.STATUS (+) = 'A'                                                        -- issue P-745
       AND    ph.OWNER_TABLE_ID (+) = cnn.rel_party_id
       AND    oh.sold_to_org_id = hca.cust_account_id;

    v_process_stage      VARCHAR2(240);
    v_bill_to_contact_id RA_CUSTOMER_TRX.BILL_TO_CONTACT_ID%TYPE;
    v_rel_party_id       AR_CONTACTS_V.REL_PARTY_ID%TYPE := -999;

  BEGIN

    log('d','Entering Get_Bill_To_Contact_Info with bill-to customer id: ' ||
              to_char(p_bill_to_customer_id) || ' and p_customer_trx_id: ' ||
              to_char(p_customer_trx_id));

    -- First check to see if the bill_to_contact_id is set with the invoice.
    v_process_stage := 'Getting Bill-to Contact id from the transaction using customer_trx_id: ' ||
                       to_char(p_customer_trx_id);

    SELECT BILL_TO_CONTACT_ID
      INTO v_bill_to_contact_id
      FROM ar.RA_CUSTOMER_TRX_ALL
     WHERE CUSTOMER_TRX_ID = p_customer_trx_id;

    IF v_bill_to_contact_id IS NOT NULL THEN

      v_process_stage := 'Retrieve contact name using bill to contact id: ' ||
                         to_char(v_bill_to_contact_id);

      SELECT FIRST_NAME || ' ' || LAST_NAME, REL_PARTY_ID
        INTO p_cust_cont_nme, v_rel_party_id
        FROM apps.AR_CONTACTS_V
       WHERE CONTACT_ID = v_bill_to_contact_id;

      -- Retrieve the phone if there is any.
      v_process_stage := 'Retrieve contact phone number using contact related party id: ' ||
                         to_char(v_rel_party_id);

      BEGIN

        SELECT TRIM(COUNTRY_CODE) || DECODE(COUNTRY_CODE, NULL, NULL, '-') ||
               TRIM(AREA_CODE) || DECODE(AREA_CODE, NULL, NULL, '-') ||
               TRIM(PHONE_NUMBER) PHONE_NUMBER
          INTO p_cust_cont_phone_nbr
          FROM apps.AR_PHONES_V
         WHERE CONTACT_POINT_TYPE = 'PHONE'
           AND OWNER_TABLE_NAME = 'HZ_PARTIES'
           AND PHONE_TYPE = 'GEN'
           -- below 2 lines added to address invoices with contact having 2 phones -- issue P-745
           AND PRIMARY_FLAG = 'Y'                                                  -- issue P-745
           AND STATUS = 'A'                                                        -- issue P-745
           AND OWNER_TABLE_ID = v_rel_party_id;

      EXCEPTION
        WHEN NO_DATA_FOUND THEN
          p_cust_cont_phone_nbr := NULL;
      END;
    ELSE

      v_process_stage := 'Getting Primary Bill-To Contact names using customer id: ' ||
                         to_char(p_bill_to_customer_id);

      FOR primary_contact_rec IN primary_contact_cur LOOP
        p_cust_cont_nme       := primary_contact_rec.contact_name;
        p_cust_cont_phone_nbr := primary_contact_rec.phone_number;
      END LOOP; -- End of primary_contact_cur LOOP.

    END IF; -- End of checking v_bill_to_contact_id is null.
    p_retcode := 0;

  EXCEPTION
    WHEN OTHERS THEN
      log('l',
                        'ERROR in Get_Bill_To_Contact_Info with v_process_stage: ');
      log('l', v_process_stage);
      log('l',
                        'SQLCODE: ' || sqlcode || ' SQLERRM: ' ||
                        sqlerrm);
      p_retcode := 2; -- Set this to error.
      p_cust_cont_phone_nbr := '';
      p_cust_cont_nme       := '';

  END Get_Bill_To_Contact_Info;

  PROCEDURE Lwx_Ar_Build_F4_Type_Rec(p_stmt_line_cnt    IN NUMBER,
                                     p_customer_cur_rec IN v_customer_cur_rec_type,
                                     p_openitem_cur_rec IN v_openitem_cur_rec_type,
                                     retcode            OUT NUMBER) IS
    --- ***************************************************************************************************************
    ---   Program DESCRIPTION  :  This is the Procedure will populate the F4 Type Record data into the Custom Table
    ---
    ---   Parameters Used      :  p_stmt_line_cnt
    ---                           p_customer_cur_rec
    ---                           p_openitem_cur_re
    ---                           retcode
    ---
    ---   Development and Maintenance History:
    ---   -------------------------------------
    ---   DATE         AUTHOR                   DESCRIPTION
    ---   ----------   ------------------------ ---------------------------------------------------------
    ---   20-DEC-2005  S Saravana Bhavan, BCT   Initial Creation
    ---   14-MAR-2006  Rajmohan K, BCT          Added debug message for log file
    ---   2006-04-26   Jude Lam, TITAN          Updated queries and various clean ups.
    ---   2006-06-20   Jude Lam, TITAN          Updated the Lwx_Ar_Build_F4_Type function to consider the difference
    ---                                            between regular shipping and handling versus those special charges.
    ---   18-NOV-2009  Jason McCleskey          Put Logo Code and Stmt_Msg1/2 in cust cursor instead 
    ---                                          of requerying multiple times in this procedure
    ---                                         Put Doc Type Name in open item cursor instead of requerying
    ---   2018-02-19   Greg Wright              OF-2981 Added Use Tax Message function Lwx_Get_Use_Tax_Message.
    ---   2018-04-12   Greg Wright              OF-3035 Refine the calling of lwx_use_tax_message.    
    --- ***************************************************************************************************************

    -- Local varibles declaration
    v_process_stage        VARCHAR2(240);
    v_stmt_hdr_id          LWX_AR_STMT_HEADERS.STMT_HDR_ID%TYPE;
    v_stmt_line_nbr        LWX_AR_STMT_LINES.STMT_LINE_NBR%TYPE;
    v_incl_cur_stmt_ind    LWX_AR_STMT_LINES.INCL_CUR_STMT_IND%TYPE;
    v_rec_type_cde         LWX_AR_STMT_LINES.REC_TYPE_CDE%TYPE;
    v_customer_trx_id      LWX_AR_STMT_LINES.CUSTOMER_TRX_ID%TYPE;
    v_cash_receipt_id      LWX_AR_STMT_LINES.CASH_RECEIPT_ID%TYPE;
    v_payment_schedule_id  LWX_AR_STMT_LINES.PAYMENT_SCHEDULE_ID%TYPE;
    v_page_cnt             LWX_AR_STMT_LINES.PAGE_CNT%TYPE := 0;
    v_line_cnt             LWX_AR_STMT_LINES.LINE_CNT%TYPE := 0;
    v_rep_msg_nme          LWX_AR_STMT_LINES.REP_MSG_NME%TYPE;
    v_bill_to_cust_nbr     LWX_AR_STMT_LINES.BILL_TO_CUST_NBR%TYPE;
    v_bill_to_cust_nme     LWX_AR_STMT_LINES.BILL_TO_CUST_NME%TYPE;
    v_bill_to_addressee    AR.HZ_PARTY_SITES.ADDRESSEE%TYPE;
    v_bill_to_line1_adr    LWX_AR_STMT_LINES.bill_to_line_1_adr%TYPE;
    v_bill_to_line2_adr    LWX_AR_STMT_LINES.BILL_TO_LINE_2_ADR%TYPE;
    v_bill_to_line3_adr    LWX_AR_STMT_LINES.BILL_TO_LINE_3_ADR%TYPE;
    v_bill_to_line4_adr    LWX_AR_STMT_LINES.BILL_TO_LINE_4_ADR%TYPE;
    v_bill_to_city_nme     LWX_AR_STMT_LINES.BILL_TO_CITY_NME%TYPE;
    v_bill_to_state_cde    LWX_AR_STMT_LINES.BILL_TO_STATE_CDE%TYPE;
    v_bill_to_postal_cde   LWX_AR_STMT_LINES.BILL_TO_POSTAL_CDE%TYPE;
    v_bill_to_cntry_nme    LWX_AR_STMT_LINES.bill_to_cntry_nme%TYPE;
    v_bill_to_country      AR.HZ_LOCATIONS.COUNTRY%TYPE;
    v_ship_to_cust_nbr     LWX_AR_STMT_LINES.SHIP_TO_CUST_NBR%TYPE;
    v_ship_to_cust_nme     LWX_AR_STMT_LINES.SHIP_TO_CUST_NME%TYPE;
    v_ship_to_addressee    AR.HZ_PARTY_SITES.ADDRESSEE%TYPE;
    v_ship_to_line1_adr    LWX_AR_STMT_LINES.SHIP_TO_LINE_1_ADR%TYPE;
    v_ship_to_line2_adr    LWX_AR_STMT_LINES.SHIP_TO_LINE_2_ADR%TYPE;
    v_ship_to_line3_adr    LWX_AR_STMT_LINES.SHIP_TO_LINE_3_ADR%TYPE;
    v_ship_to_line4_adr    LWX_AR_STMT_LINES.SHIP_TO_LINE_4_ADR%TYPE;
    v_ship_to_city_nme     LWX_AR_STMT_LINES.SHIP_TO_CITY_NME%TYPE;
    v_ship_to_state_cde    LWX_AR_STMT_LINES.SHIP_TO_STATE_CDE%TYPE;
    v_ship_to_postal_cde   LWX_AR_STMT_LINES.SHIP_TO_POSTAL_CDE%TYPE;
    v_ship_to_cntry_nme    LWX_AR_STMT_LINES.SHIP_TO_CNTRY_NME%TYPE;
    v_ship_to_country      AR.HZ_LOCATIONS.COUNTRY%TYPE;
    v_trans_dte            LWX_AR_STMT_LINES.TRANS_DTE%TYPE;
    v_due_dte              LWX_AR_STMT_LINES.DUE_DTE%TYPE;
    v_trans_nbr            LWX_AR_STMT_LINES.TRANS_NBR%TYPE;
    v_sls_chnl_nme         LWX_AR_STMT_LINES.SLS_CHNL_NME%TYPE;
    v_cust_ref_nme         LWX_AR_STMT_LINES.CUST_REF_NME%TYPE;
    v_fut_pmt_ind          LWX_AR_STMT_LINES.FUT_PMT_IND%TYPE;
    v_partial_pmt_ind      LWX_AR_STMT_LINES.PARTIAL_PMT_IND%TYPE;
    v_doc_ref_nme          LWX_AR_STMT_LINES.DOC_REF_NME%TYPE;
    v_term_msg1_nme        LWX_AR_STMT_LINES.TERM_MSG1_NME%TYPE;
    v_term_msg2_nme        LWX_AR_STMT_LINES.TERM_MSG2_NME%TYPE;
    v_cust_cont_nme        LWX_AR_STMT_LINES.CUST_CONT_NME%TYPE;
    v_cust_cont_phone_nbr  LWX_AR_STMT_LINES.CUST_CONT_PHONE_NBR%TYPE;
    v_order_dte            LWX_AR_STMT_LINES.ORDER_DTE%TYPE;
    v_ship_meth_nme        LWX_AR_STMT_LINES.SHIP_METH_NME%TYPE;
    v_sub_total_amt        LWX_AR_STMT_LINES.SUB_TOTAL_AMT%TYPE := 0;
    v_ship_hndl_amt        LWX_AR_STMT_LINES.SHIP_HNDL_AMT%TYPE := 0;
    v_tax_amt              LWX_AR_STMT_LINES.TAX_AMT%TYPE := 0;
    v_pmt_used_amt         LWX_AR_STMT_LINES.PMT_USED_AMT%TYPE := 0;
    v_total_due_amt        LWX_AR_STMT_LINES.TOTAL_DUE_AMT%TYPE := 0;
    v_mkt_msg1_nme         LWX_AR_STMT_LINES.MKT_MSG1_NME%TYPE;
    v_mkt_msg2_nme         LWX_AR_STMT_LINES.MKT_MSG2_NME%TYPE;
    v_mkt_msg3_nme         LWX_AR_STMT_LINES.MKT_MSG3_NME%TYPE;
    v_mkt_msg4_nme         LWX_AR_STMT_LINES.MKT_MSG4_NME%TYPE;
    v_term_message         ra_terms.DESCRIPTION%TYPE;
    v_ship_meth_code       OE_ORDER_HEADERS.SHIPPING_METHOD_CODE%TYPE;
    v_outstanding_amt      NUMBER;
    v_current_user         LWX_AR_STMT_LINES.CREATED_BY%TYPE;
    v_update_login         LWX_AR_STMT_LINES.LAST_UPDATE_LOGIN%TYPE;
    v_bill_to_customer_id  HZ_CUST_ACCOUNTS.CUST_ACCOUNT_ID%TYPE := 0;
    v_bill_to_party_id     HZ_PARTIES.PARTY_ID%TYPE := 0;
    v_installment_count    NUMBER := 0;
    v_intfc_header_context RA_CUSTOMER_TRX.INTERFACE_HEADER_CONTEXT%TYPE;
    v_trx_logo             LWX_AR_STMT_LINES.LOGO_CDE%TYPE;
    v_use_tax_message      VARCHAR2(2000);

--- Variables for lwx_split_line    
    v_msg1                 VARCHAR2(100);
    v_msg2                 VARCHAR2(100);
    v_msg3                 VARCHAR2(100);
    v_msg4                 VARCHAR2(100);
    v_msg_line_cnt         NUMBER;

    CURSOR get_order_ship_meth_Cur(p_customer_trx_id IN NUMBER) IS
      SELECT DISTINCT OOH.ORDERED_DATE,
                      NVL(OOL.SHIPPING_METHOD_CODE,
                          OOH.SHIPPING_METHOD_CODE) SHIPPING_METHOD_CODE
        FROM OE_ORDER_HEADERS      OOH,
             OE_ORDER_LINES        OOL,
             RA_CUSTOMER_TRX_LINES RCTL
       WHERE RCTL.CUSTOMER_TRX_ID = p_customer_trx_id
         AND RCTL.SALES_ORDER_LINE IS NOT NULL
         AND RCTL.INTERFACE_LINE_CONTEXT = 'ORDER ENTRY'
         AND TO_NUMBER(RCTL.INTERFACE_LINE_ATTRIBUTE6) = OOL.LINE_ID
         AND OOL.HEADER_ID = OOH.HEADER_ID;

  BEGIN
    log('d','Start of Lwx_Ar_Build_F4_Type_Rec Procedure with customer_trx_id: ' ||
              to_char(p_openitem_cur_rec.customer_trx_id));

    -- Assign Values to the variables
    v_process_stage := 'Assign Values to the Variables';
    v_current_user  := TO_NUMBER(fnd_profile.VALUE('USER_ID'));
    v_update_login  := TO_NUMBER(fnd_profile.VALUE('LOGIN_ID'));

    v_process_stage := 'Getting next sequence id from lwx_ar_stmt_lines_s.';

    SELECT LWX_AR_STMT_LINES_S.NEXTVAL INTO v_stmt_line_id FROM DUAL;

    v_process_stage := 'Getting current sequence id from lwx_ar_stmt_headers_s.';

    SELECT AR_STATEMENT_HEADERS_S.CURRVAL INTO v_stmt_hdr_id FROM DUAL;

    v_stmt_line_nbr       := p_stmt_line_cnt;
    v_rec_type_cde        := 'F4';
    v_customer_trx_id     := p_openitem_cur_rec.CUSTOMER_TRX_ID;
    v_cash_receipt_id     := p_openitem_cur_rec.CASH_RECEIPT_ID;
    v_payment_schedule_id := p_openitem_cur_rec.PAYMENT_SCHEDULE_ID;
    v_trans_dte           := p_openitem_cur_rec.TRX_DATE;
    v_trans_nbr           := substr(p_openitem_cur_rec.TRX_NUMBER,1,20);
    v_sls_chnl_nme        := p_openitem_cur_rec.ATTRIBUTE5;
--gw    v_cust_ref_nme        := replace(p_openitem_cur_rec.PURCHASE_ORDER,'|',' ');
    v_cust_ref_nme        := regexp_replace(p_openitem_cur_rec.PURCHASE_ORDER, '[^ -{^}~]', '');
    v_doc_ref_nme         := substr(p_openitem_cur_rec.TRX_NUMBER,1,20);
    v_due_dte             := p_openitem_cur_rec.DUE_DATE; -- Jude Lam 05/17/06 update
    v_mkt_msg1_nme        := SUBSTR(p_openitem_cur_rec.ATTRIBUTE6,
                                    1,
                                    INSTR(p_openitem_cur_rec.ATTRIBUTE6, '|') - 1);
    v_mkt_msg2_nme        := SUBSTR(p_openitem_cur_rec.ATTRIBUTE6,
                                    INSTR(p_openitem_cur_rec.ATTRIBUTE6, '|') + 1);
    v_mkt_msg3_nme        := SUBSTR(p_openitem_cur_rec.ATTRIBUTE7,
                                    1,
                                    INSTR(p_openitem_cur_rec.ATTRIBUTE7, '|') - 1);
    v_mkt_msg4_nme        := SUBSTR(p_openitem_cur_rec.ATTRIBUTE7,
                                    INSTR(p_openitem_cur_rec.ATTRIBUTE7, '|') + 1);

    log('d','Inside Lwx_Ar_Build_F4_Type_Rec Procedure ' ||
              ' Record Type Code ' || v_rec_type_cde ||
              ' Customer Transaction ID ' || v_customer_trx_id ||
              ' Cash Receipt ID ' || v_cash_receipt_id ||
              ' Payment Schedule ID ' || v_payment_schedule_id ||
              ' Transaction Date ' || v_trans_dte ||
              ' Transaction Number ' || v_trans_nbr ||
              ' Sales Channel Name ' || v_sls_chnl_nme ||
              ' Customer Reference Name ' || v_cust_ref_nme ||
              ' Document Reference Name ' || v_doc_ref_nme ||
              ' Mkt Message1 Name ' || v_mkt_msg1_nme ||
              ' Mkt Message2 Name ' || v_mkt_msg2_nme ||
              ' Mkt Message3 Name ' || v_mkt_msg3_nme ||
              ' Mkt Message4 Name ' || v_mkt_msg4_nme);

    -- Get the current statement indicator
    v_process_stage := 'Get the Current Statement Indicator';

    IF nvl(trunc(v_due_dte), trunc(v_trans_dte)) <= v_statement_date_global THEN
      v_incl_cur_stmt_ind := 'Y';
    ELSE
      v_incl_cur_stmt_ind := 'N';
    END IF;

    log('d','Current statement indicator v_incl_cur_stmt_ind: ' ||
              v_incl_cur_stmt_ind);

    -- Find the statement logo code
    log('d','Sales Channel Code ' || p_customer_cur_rec.sales_channel_code);
    v_trx_logo:= get_trx_logo(p_openitem_cur_rec.attribute3,p_customer_cur_rec.line_logo_code);
    log('d','Logo Code ' || v_trx_logo);
        
    -- Get Document Title Name
    log('d','Document Title Name ' || p_openitem_cur_rec.doc_type_nme);

    -- Get the LWX_AR_STMT_LINES.REP_MSG_NME field data
    v_rep_msg_nme := substr('Questions concerning this ' ||
                            p_openitem_cur_rec.doc_type_nme || ' Call:' ||
                            p_openitem_cur_rec.ATTRIBUTE4,
                            1,
                            60);

    -- Get Bill_To and Ship_To Line Address
    v_process_stage := 'Get the Customer Bill_To Address with customer_trx_id: ' ||
                       to_char(v_customer_trx_id);

    -- Find Bill_To Address from the invoice.  Jude Lam 04/26/06 Update
    SELECT loc.ADDRESS1,
           loc.ADDRESS2,
           loc.ADDRESS3,
           loc.ADDRESS4,
           loc.CITY,
           loc.COUNTRY,
           substr(loc.STATE,1,2),
           substr(loc.POSTAL_CODE,1,12),
           terr.TERRITORY_SHORT_NAME,
           HP.PARTY_NAME,
           party_site.addressee,
           HCA.ACCOUNT_NUMBER,
           HCA.CUST_ACCOUNT_ID,
           HP.PARTY_ID
      INTO v_bill_to_line1_adr,
           v_bill_to_line2_adr,
           v_bill_to_line3_adr,
           v_bill_to_line4_adr,
           v_bill_to_city_nme,
           v_bill_to_country,
           v_bill_to_state_cde,
           v_bill_to_postal_cde,
           v_bill_to_cntry_nme,
           v_bill_to_cust_nme,
           v_bill_to_addressee,
           v_bill_to_cust_nbr,
           v_bill_to_customer_id,
           v_bill_to_party_id
      FROM --             AR_LOOKUPS l_cat
           FND_TERRITORIES_VL terr
           --            ,FND_LANGUAGES_VL lang
          ,
           HZ_CUST_ACCT_SITES addr,
           HZ_PARTY_SITES     party_site,
           HZ_CUST_SITE_USES  csu,
           HZ_LOCATIONS       loc
           --            ,HZ_LOC_ASSIGNMENTS loc_assign
          ,
           RA_CUSTOMER_TRX  RCT,
           HZ_PARTIES       HP,
           HZ_CUST_ACCOUNTS HCA
     WHERE RCT.BILL_TO_SITE_USE_ID = CSU.SITE_USE_ID
       AND CSU.CUST_ACCT_SITE_ID = ADDR.CUST_ACCT_SITE_ID
       AND ADDR.PARTY_SITE_ID = PARTY_SITE.PARTY_SITE_ID
       AND PARTY_SITE.LOCATION_ID = LOC.LOCATION_ID
       AND PARTY_SITE.PARTY_ID = HP.PARTY_ID
       AND LOC.COUNTRY = TERR.TERRITORY_CODE(+)
       AND RCT.CUSTOMER_TRX_ID = v_customer_trx_id
       AND ADDR.CUST_ACCOUNT_ID = HCA.CUST_ACCOUNT_ID;

    log('d','Bill To Customer name and number: ' || v_bill_to_cust_nme || ' ' ||
              v_bill_to_cust_nbr);

    log('d','Bill to Address ' || v_bill_to_line1_adr ||
              v_bill_to_line2_adr || v_bill_to_line3_adr ||
              v_bill_to_line4_adr || v_bill_to_city_nme ||
              v_bill_to_state_cde || v_bill_to_postal_cde ||
              v_bill_to_cntry_nme);

    v_process_stage := 'Get the Customer Ship_To Address';

    -- Find Ship_To Address
    BEGIN
      SELECT loc.ADDRESS1,
             loc.ADDRESS2,
             loc.ADDRESS3,
             loc.ADDRESS4,
             loc.CITY,
             loc.country,
             substr(loc.STATE,1,2),
             substr(loc.POSTAL_CODE,1,12),
             terr.TERRITORY_SHORT_NAME,
             HP.PARTY_NAME,
             party_site.addressee,
             HCA.ACCOUNT_NUMBER
        INTO v_ship_to_line1_adr,
             v_ship_to_line2_adr,
             v_ship_to_line3_adr,
             v_ship_to_line4_adr,
             v_ship_to_city_nme,
             v_ship_to_country,
             v_ship_to_state_cde,
             v_ship_to_postal_cde,
             v_ship_to_cntry_nme,
             v_ship_to_cust_nme,
             v_ship_to_addressee,
             v_ship_to_cust_nbr
        FROM FND_TERRITORIES_VL terr,
             HZ_CUST_ACCT_SITES addr,
             HZ_PARTY_SITES     party_site,
             HZ_CUST_SITE_USES  csu,
             HZ_LOCATIONS       loc,
             RA_CUSTOMER_TRX    RCT,
             HZ_PARTIES         HP,
             HZ_CUST_ACCOUNTS   HCA
       WHERE NVL(RCT.SHIP_TO_SITE_USE_ID, -999) = CSU.SITE_USE_ID
         AND CSU.CUST_ACCT_SITE_ID = ADDR.CUST_ACCT_SITE_ID
         AND ADDR.PARTY_SITE_ID = PARTY_SITE.PARTY_SITE_ID
         AND PARTY_SITE.LOCATION_ID = LOC.LOCATION_ID
         AND PARTY_SITE.PARTY_ID = HP.PARTY_ID
         AND LOC.COUNTRY = TERR.TERRITORY_CODE(+)
         AND RCT.CUSTOMER_TRX_ID = v_customer_trx_id
         AND ADDR.CUST_ACCOUNT_ID = HCA.CUST_ACCOUNT_ID;

    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        v_ship_to_line1_adr  := v_bill_to_line1_adr;
        v_ship_to_line2_adr  := v_bill_to_line2_adr;
        v_ship_to_line3_adr  := v_bill_to_line3_adr;
        v_ship_to_line4_adr  := v_bill_to_line4_adr;
        v_ship_to_city_nme   := v_bill_to_city_nme;
        v_ship_to_state_cde  := v_bill_to_state_cde;
        v_ship_to_postal_cde := v_bill_to_postal_cde;
        v_ship_to_cntry_nme  := v_bill_to_cntry_nme;
        v_ship_to_country    := v_bill_to_country;
        v_ship_to_cust_nme   := v_bill_to_cust_nme;
        v_ship_to_addressee  := v_bill_to_addressee;
        v_ship_to_cust_nbr   := v_bill_to_cust_nbr;

    END; -- End of getting ship-to address block.

    -- Append Addressee for ship-to
    IF v_ship_to_line3_adr IS NULL AND
       v_ship_to_line4_adr IS NULL AND
       v_ship_to_addressee IS NOT NULL THEN
       v_ship_to_line3_adr := v_ship_to_line2_adr;
       v_ship_to_line2_adr := v_ship_to_line1_adr;
       v_ship_to_line1_adr := v_ship_to_addressee;
    END IF;   

    -- Replace Mkt Lines with SUT message if applicable
    SELECT lwx_get_use_tax_message(decode(v_ship_to_country,'PR','PR','US',nvl(v_ship_to_state_cde,'**'),''))
      INTO v_use_tax_message
      FROM DUAL;
    IF v_use_tax_message IS NOT NULL THEN
      v_msg_line_cnt:= lwx_split_line(v_use_tax_message,v_msg1,v_msg2,v_msg3,v_msg4);
      v_mkt_msg1_nme:= NULL;
      v_mkt_msg2_nme:= NULL;
      v_mkt_msg3_nme:= NULL;
      v_mkt_msg4_nme:= NULL;
      FOR k in 1..v_msg_line_cnt LOOP
        IF k = 1 THEN
          v_mkt_msg1_nme := v_msg1;
        END IF;  
        IF k = 2 THEN
          v_mkt_msg2_nme := v_msg2;
        END IF;  
        IF k = 3 THEN
          v_mkt_msg3_nme := v_msg3;
        END IF;  
        IF k = 4 THEN
          v_mkt_msg4_nme := v_msg4;
        END IF;  
      END LOOP;
    END IF;            

    log('d','Ship To Customer name and number: ' || v_ship_to_cust_nme || ' ' ||
              v_ship_to_cust_nbr);

    log('d','Ship to Address ' || v_ship_to_line1_adr ||
              v_ship_to_line2_adr || v_ship_to_line3_adr ||
              v_ship_to_line4_adr || v_ship_to_city_nme ||
              v_ship_to_state_cde || v_ship_to_postal_cde ||
              v_ship_to_cntry_nme);

    -- Get the FUT Amount
    IF p_openitem_cur_rec.DUE_DATE > v_statement_date_global THEN
      v_fut_pmt_ind := '*';
    END IF;

    -- Get the Outstanding Amount
    v_process_stage   := 'Get the Out Standing Amount calling the Standard Function';
    v_outstanding_amt := Arpt_Sql_Func_Util.Get_Balance_Due_As_Of_Date(p_openitem_cur_rec.PAYMENT_SCHEDULE_ID,
                                                                       v_statement_date_global,
                                                                       p_openitem_cur_rec.CLASS);
    log('d','Outstanding Amount ' ||
              to_char(v_outstanding_amt, '999,999,990.00'));

    -- reset the term msg variables.
    v_term_msg1_nme := NULL;
    v_term_msg2_nme := NULL;

    -- Get Term Message
    IF p_openitem_cur_rec.term_id IS NOT NULL THEN
      v_process_stage := 'Get Term Message with term id: ' ||
                         to_char(p_openitem_cur_rec.term_id);

      SELECT DESCRIPTION
        INTO v_term_message
        FROM ra_terms
       WHERE TERM_ID = p_openitem_cur_rec.TERM_ID;

      log('d','Term Message ' || v_term_message);

      IF LENGTH(RTRIM(v_term_message)) > 40 THEN
        v_term_msg1_nme := SUBSTR(v_term_message, 1, 40);
        v_term_msg2_nme := SUBSTR(v_term_message,
                                  INSTR(v_term_message, ' ', -1, 1));
      ELSE
        v_term_msg1_nme := v_term_message;
        v_term_msg2_nme := NULL;
      END IF;
    END IF; -- End of checking p_openitem_cur_rec.term_id;

    -- Get Bill_To Customer Contact Name and Number 04/26/06 Jude Lam, redo the logic and move the code
    -- to a new procedure.

    v_process_stage := 'Get the Bill_To Customer Contact Name and Number using bill-to customer id: ' ||
                       to_char(v_bill_to_customer_id) ||
                       ' and bill-to party id: ' ||
                       to_char(v_bill_to_party_id);

    Get_Bill_To_Contact_Info(p_bill_to_customer_id => v_bill_to_customer_id,
                             p_cust_cont_phone_nbr => v_cust_cont_phone_nbr,
                             p_cust_cont_nme       => v_cust_cont_nme,
                             p_customer_trx_id     => v_customer_trx_id,
                             p_retcode             => retcode);

    -- Get Order Date
    v_process_stage := 'Get the Ordered Date for customer_trx_id: ' ||
                       to_char(v_customer_trx_id);

    v_order_dte      := NULL;
    v_ship_meth_code := NULL;

    FOR get_order_ship_meth_Rec IN get_order_ship_meth_Cur(p_customer_trx_id => v_customer_trx_id) LOOP
      v_order_dte      := get_order_ship_meth_Rec.ordered_date;
      v_ship_meth_code := get_order_ship_meth_Rec.shipping_method_code;
    END LOOP; -- End of get_order_ship_meth_Cur cursor.

    log('d','Ordered Date ' || to_char(v_order_dte, 'MM/DD/YYYY') ||
              ' Shipping method code ' || v_ship_meth_code || ' ' ||
              'Customer TRX ID ' || to_char(v_customer_trx_id));

    IF v_ship_meth_code IS NOT NULL THEN
      -- Get the Shipping Method Name
      v_process_stage := 'Get the Shipping Method Name with ship method code: ' ||
                         v_ship_meth_code;

      SELECT SHIP_METHOD_MEANING
        INTO v_ship_meth_nme
        FROM WSH_CARRIER_SERVICES_V
       WHERE SHIP_METHOD_CODE = v_ship_meth_code;

      log('d','Shipping Method Name ' || v_ship_meth_nme);

    END IF; -- End of v_ship_meth_code check.

    -- Jude Lam 06/20/06 Added the logic to handle sub-total differently between OM related trx and non OM related trx.
    v_process_stage := 'Getting header interface context using customer_trx_id: ' ||
                       to_char(v_customer_trx_id);

    SELECT INTERFACE_HEADER_CONTEXT
      INTO v_intfc_header_context
      FROM RA_CUSTOMER_TRX
     WHERE CUSTOMER_TRX_ID = v_customer_trx_id;

    log('d','F4 Retrieved interface header context using customer_trx_id:' ||
              to_char(v_customer_trx_id) || ': ' || v_intfc_header_context);

    -- Arrive the sub total amount
    v_process_stage := 'Get the Sub Total Amount for customer_trx_id: ' ||
                       to_char(v_customer_trx_id) ||
                       ' interface header context: ' ||
                       v_intfc_header_context;

    IF v_intfc_header_context = 'ORDER ENTRY' THEN

      SELECT nvl(SUM(nvl(EXTENDED_AMOUNT, 0)), 0)
        INTO v_sub_total_amt
        FROM RA_CUSTOMER_TRX_LINES
       WHERE LINE_TYPE NOT IN ('FREIGHT', 'TAX')
            --      AND    CUSTOMER_TRX_ID = p_openitem_cur_rec.CUSTOMER_TRX_ID
         AND CUSTOMER_TRX_ID = v_customer_trx_id
         AND ((NVL(INVENTORY_ITEM_ID, -999) !=
--             TO_NUMBER(FND_PROFILE.VALUE('OE_INVENTORY_ITEM_FOR_FREIGHT'))) OR
             gn_freight_item) OR
             (NVL(INVENTORY_ITEM_ID, -999) =
             gn_freight_item AND
--             TO_NUMBER(FND_PROFILE.VALUE('OE_INVENTORY_ITEM_FOR_FREIGHT')) AND
             ((SELECT NVL(CHARGE_TYPE_CODE, 'XXX')
                   FROM OE_PRICE_ADJUSTMENTS
                  WHERE PRICE_ADJUSTMENT_ID =
                        TO_NUMBER(NVL(INTERFACE_LINE_ATTRIBUTE6, -999))) !=
             'SHIPPING AND PROCESSING')));
    ELSE
      SELECT nvl(SUM(nvl(EXTENDED_AMOUNT, 0)), 0)
        INTO v_sub_total_amt
        FROM RA_CUSTOMER_TRX_LINES
       WHERE LINE_TYPE NOT IN ('FREIGHT', 'TAX')
            --      AND    CUSTOMER_TRX_ID = p_openitem_cur_rec.CUSTOMER_TRX_ID
         AND CUSTOMER_TRX_ID = v_customer_trx_id
         AND NVL(INVENTORY_ITEM_ID, -999) !=
             gn_freight_item;
--             TO_NUMBER(FND_PROFILE.VALUE('OE_INVENTORY_ITEM_FOR_FREIGHT'));
    END IF;

    log('d','Sub Total Amount ' || v_sub_total_amt || ' ' ||
              'Customer_Trx_ID ' || p_openitem_cur_rec.CUSTOMER_TRX_ID);

    -- Arrive Ship Handling Amount
    v_process_stage := 'Get the Ship Handling Amount for customer_trx_id: ' ||
                       to_char(v_customer_trx_id);

    -- Jude Lam 06/20/06 Update the query to consider the difference between regular shipping and handling and special charges.
    IF v_intfc_header_context = 'ORDER ENTRY' THEN
      SELECT NVL(SUM(nvl(EXTENDED_AMOUNT, 0)), 0)
        INTO v_ship_hndl_amt
        FROM RA_CUSTOMER_TRX_LINES
       WHERE CUSTOMER_TRX_ID = p_openitem_cur_rec.CUSTOMER_TRX_ID
         AND LINE_TYPE = 'LINE'
         AND ((NVL(INVENTORY_ITEM_ID, -999) =
             gn_freight_item ) AND
--             TO_NUMBER(FND_PROFILE.VALUE('OE_INVENTORY_ITEM_FOR_FREIGHT'))) AND
             ((SELECT NVL(CHARGE_TYPE_CODE, 'XXX')
                  FROM OE_PRICE_ADJUSTMENTS
                 WHERE PRICE_ADJUSTMENT_ID =
                       TO_NUMBER(NVL(interface_line_attribute6, -999))) =
             'SHIPPING AND PROCESSING'));
    ELSE
      SELECT NVL(SUM(nvl(EXTENDED_AMOUNT, 0)), 0)
        INTO v_ship_hndl_amt
        FROM RA_CUSTOMER_TRX_LINES
       WHERE CUSTOMER_TRX_ID = p_openitem_cur_rec.CUSTOMER_TRX_ID
         AND LINE_TYPE = 'LINE'
         AND NVL(INVENTORY_ITEM_ID, -999) =
             gn_freight_item;
--             TO_NUMBER(FND_PROFILE.VALUE('OE_INVENTORY_ITEM_FOR_FREIGHT'));
    END IF;

    log('d','Ship Handling Amount ' || v_ship_hndl_amt || ' ' ||
              'Customer_Trx_ID ' || p_openitem_cur_rec.CUSTOMER_TRX_ID);

    -- Arrive Tax Amount
    v_process_stage := 'Get the Tax Amount for customer_trx_id: ' ||
                       to_char(v_customer_trx_id);

    SELECT NVL(SUM(nvl(EXTENDED_AMOUNT, 0)), 0)
      INTO v_tax_amt
      FROM RA_CUSTOMER_TRX_LINES
     WHERE LINE_TYPE = 'TAX'
       AND CUSTOMER_TRX_ID = p_openitem_cur_rec.CUSTOMER_TRX_ID;

    log('d','Tax ' || v_tax_amt || ' ' || 'Customer_Trx_ID ' ||
              p_openitem_cur_rec.CUSTOMER_TRX_ID);

    -- Arrive Payment Used Amount
    v_process_stage := 'Get the Payment Used Amount for customer_trx_id: ' ||
                       to_char(v_customer_trx_id);

    SELECT nvl(SUM(nvl(amount_applied, 0)), 0)
      INTO v_pmt_used_amt
      FROM AR_PAYMENT_SCHEDULES
     WHERE CLASS IN ('INV', 'CM')
       AND CUSTOMER_TRX_ID = v_customer_trx_id;

    log('d','Payment Used Amt ' || v_pmt_used_amt || ' ' ||
              'Customer ID ' || p_customer_cur_rec.CUSTOMER_ID || ' ' ||
              'Customer_Trx_ID ' || p_openitem_cur_rec.CUSTOMER_TRX_ID);

    -- Arrive Total Due Amount
    v_process_stage := 'Arrive Total Due Amount with sub_total: ' ||
                       to_char(v_sub_Total_amt) || ' and shipping amt: ' ||
                       to_char(v_ship_hndl_amt) || ' and tax: ' ||
                       to_char(v_tax_amt) || ' and pmt used: ' ||
                       to_char(v_pmt_used_amt);

    v_total_due_amt := (v_sub_total_amt + v_ship_hndl_amt + v_tax_amt) -
                       v_pmt_used_amt;

    log('d','Total Due Amount: ' ||
              to_char(v_total_due_amt, '999,999,999,990.00'));

    IF p_openitem_cur_rec.customer_trx_id IS NOT NULL THEN
      -- Jude Lam 05/23/06 Added the following to check to see if the current open item has 1 or more
      -- installment.  If there is one, then set the v_incl_cur_stmt_ind flag back to Y.
      SELECT COUNT(*)
        INTO v_installment_count
        FROM AR_PAYMENT_SCHEDULES
       WHERE CUSTOMER_TRX_ID = p_openitem_cur_rec.customer_trx_id;

      IF v_installment_count = 1 THEN
        v_incl_cur_stmt_ind := 'Y';
      END IF;
    END IF;

    -- Insert Into table LWX_AR_STMT_LINES for F4 Type Records
    v_process_stage := 'Insert F4 Type Records into LWX_AR_STMT_LINES Table';

    log('d',v_process_stage);

    INSERT INTO LWX_AR_STMT_LINES
      (STMT_LINE_ID,
       STMT_HDR_ID,
       STMT_LINE_NBR,
       INCL_CUR_STMT_IND,
       REC_TYPE_CDE,
       CUSTOMER_TRX_ID,
       CASH_RECEIPT_ID,
       PAYMENT_SCHEDULE_ID,
       PAGE_CNT,
       LINE_CNT,
       LOGO_CDE,
       DOC_TITLE_NME,
       REP_MSG_NME,
       BILL_TO_CUST_NBR,
       BILL_TO_CUST_NME,
       BILL_TO_LINE_1_ADR,
       BILL_TO_LINE_2_ADR,
       BILL_TO_LINE_3_ADR,
       BILL_TO_LINE_4_ADR,
       BILL_TO_CITY_NME,
       BILL_TO_STATE_CDE,
       BILL_TO_POSTAL_CDE,
       BILL_TO_CNTRY_NME,
       SHIP_TO_CUST_NBR,
       SHIP_TO_CUST_NME,
       SHIP_TO_LINE_1_ADR,
       SHIP_TO_LINE_2_ADR,
       SHIP_TO_LINE_3_ADR,
       SHIP_TO_LINE_4_ADR,
       SHIP_TO_CITY_NME,
       SHIP_TO_STATE_CDE,
       SHIP_TO_POSTAL_CDE,
       SHIP_TO_CNTRY_NME,
       TRANS_DTE,
       TRANS_NBR,
       SLS_CHNL_NME,
       CUST_REF_NME,
       FUT_PMT_IND,
       PARTIAL_PMT_IND,
       DOC_REF_NME,
       TERM_MSG1_NME,
       TERM_MSG2_NME,
       CUST_CONT_NME,
       CUST_CONT_PHONE_NBR,
       ORDER_DTE,
       SHIP_METH_NME,
       SUB_TOTAL_AMT,
       SHIP_HNDL_AMT,
       TAX_AMT,
       PMT_USED_AMT,
       TOTAL_DUE_AMT,
       MKT_MSG1_NME,
       MKT_MSG2_NME,
       MKT_MSG3_NME,
       MKT_MSG4_NME,
       CREATED_BY,
       CREATION_DATE,
       LAST_UPDATED_BY,
       LAST_UPDATE_DATE,
       LAST_UPDATE_LOGIN)
    VALUES
      (v_stmt_line_id,
       v_stmt_hdr_id,
       v_stmt_line_nbr,
       v_incl_cur_stmt_ind,
       v_rec_type_cde,
       v_customer_trx_id,
       v_cash_receipt_id,
       v_payment_schedule_id,
       v_page_cnt,
       v_line_cnt,
       v_trx_logo,
       p_openitem_cur_rec.doc_type_nme,
       v_rep_msg_nme,
       v_bill_to_cust_nbr,
       v_bill_to_cust_nme,
       v_bill_to_line1_adr,
       v_bill_to_line2_adr,
       v_bill_to_line3_adr,
       v_bill_to_line4_adr,
       v_bill_to_city_nme,
       v_bill_to_state_cde,
       v_bill_to_postal_cde,
       v_bill_to_cntry_nme,
       v_ship_to_cust_nbr,
       v_ship_to_cust_nme,
       v_ship_to_line1_adr,
       v_ship_to_line2_adr,
       v_ship_to_line3_adr,
       v_ship_to_line4_adr,
       v_ship_to_city_nme,
       v_ship_to_state_cde,
       v_ship_to_postal_cde,
       v_ship_to_cntry_nme,
       v_trans_dte,
       v_trans_nbr,
       v_sls_chnl_nme,
       v_cust_ref_nme,
       v_fut_pmt_ind,
       v_partial_pmt_ind,
       v_doc_ref_nme,
       v_term_msg1_nme,
       v_term_msg2_nme,
       v_cust_cont_nme,
       v_cust_cont_phone_nbr,
       v_order_dte,
       v_ship_meth_nme,
       v_sub_total_amt,
       v_ship_hndl_amt,
       v_tax_amt,
       v_pmt_used_amt,
       v_total_due_amt,
       v_mkt_msg1_nme,
       v_mkt_msg2_nme,
       v_mkt_msg3_nme,
       v_mkt_msg4_nme,
       v_current_user,
       SYSDATE,
       v_current_user,
       SYSDATE,
       v_update_login);

    log('d','End of Lwx_Ar_Build_F4_Type_Rec Procedure');

  EXCEPTION
    WHEN OTHERS THEN
      -- Write Stage to the Log
      log('l',
                        'ERROR in Lwx_Ar_Build_F4_Type_Rec with v_process_stage: ');
      log('l', v_process_stage);
      log('l',
                        'SQLCODE: ' || sqlcode || ' SQLERRM: ' ||
                        sqlerrm);
      -- Set Concurrent Request Run Status to Error
      retcode := 2;
      --Rollback transactions
      ROLLBACK;
  END Lwx_Ar_Build_F4_Type_Rec;

  PROCEDURE Lwx_Ar_Build_Line_Details(p_line_desc_flag       IN VARCHAR2,
                                      p_line_type_cde        IN VARCHAR2,
                                      p_trx_line_dtl_cnt     IN OUT PLS_INTEGER,
                                      p_openitem_cur_rec     IN v_openitem_cur_rec_type,
                                      p_trx_line_dtl_cur_rec IN v_trx_line_dtl_cur_rec_type,
                                      retcode                OUT NUMBER) IS

    --- ***************************************************************************************************************
    ---   Program DESCRIPTION      :  This is the Procedure will Populate the Invoice details to the Custom Table
    ---
    ---   Parameters Used          :  p_line_desc_flag
    ---                               p_line_type_cde
    ---                               p_trx_line_dtl_cnt
    ---                               p_openitem_cur_rec
    ---                               p_trx_line_dtl_cur_rec
    ---                               retcode
    ---
    ---  Development and Maintenance History:
    ---  -------------------------------------
    ---  DATE         AUTHOR                   DESCRIPTION
    ---  ----------   ------------------------ ---------------------------------------------------------
    ---  20-DEC-2005  S Saravana Bhavan, BCT   Initial Creation
    ---  14-MAR-2006  Rajmohan K, BCT          Added debug message for log file
    ---  2006-04-25   Jude Lam, TITAN          Rearranged the logic.
    ---  2006-06-05   Jude Lam, TITAN          Update the query to retrieve cross reference for the alternate item number.
    ---  2006-06-09   Jude Lam, TITAN          Updated to address the divided by zero issue.
    ---  2006-08-24   Jude Lam, TITAN          Updated the LWX_Ar_Build_Line_Detail's query on getting the store information.
    ---  2006-09-05   Jude Lam, TITAN          Added the check for taxable or not for the current line detail to put in the *.
    --- ***************************************************************************************************************

    -- Local varibles declaration
    v_process_stage         VARCHAR2(240);
    v_expected_publish_date VARCHAR2(15);
    v_stmt_line_dtl_id      LWX_AR_STMT_LINE_DETAILS.STMT_LINE_DTL_ID%TYPE;
    v_stmt_line_dtl_nbr     LWX_AR_STMT_LINE_DETAILS.STMT_LINE_DTL_NBR%TYPE;
    v_line_type_cde         LWX_AR_STMT_LINE_DETAILS.LINE_TYPE_CDE%TYPE;
    v_customer_trx_line_id  LWX_AR_STMT_LINE_DETAILS.CUSTOMER_TRX_LINE_ID%TYPE;
    v_ordered_qty_cnt       LWX_AR_STMT_LINE_DETAILS.ORDERED_QTY_CNT%TYPE;
    v_shipped_qty_cnt       LWX_AR_STMT_LINE_DETAILS.SHIPPED_QTY_CNT%TYPE;
    v_item_nbr              LWX_AR_STMT_LINE_DETAILS.ITEM_NBR%TYPE;
    v_alt_item_nbr          LWX_AR_STMT_LINE_DETAILS.ALT_ITEM_NBR%TYPE;
    v_line_desc_txt         LWX_AR_STMT_LINE_DETAILS.LINE_DESC_TXT%TYPE;
    v_selling_price_amt     LWX_AR_STMT_LINE_DETAILS.SELLING_PRICE_AMT%TYPE;
    v_selling_disc_amt      LWX_AR_STMT_LINE_DETAILS.SELLING_DISC_AMT%TYPE;
    v_extended_amt          LWX_AR_STMT_LINE_DETAILS.EXTENDED_AMT%TYPE;
    v_applied_trx_number    LWX_AR_STMT_LINE_DETAILS.LINE_DESC_TXT%TYPE;
    v_credit_memo_reason    AR_LOOKUPS.MEANING%TYPE;
    v_store_phone_number    FND_FLEX_VALUES_VL.ATTRIBUTE2%TYPE;
    v_store_name            FND_FLEX_VALUES_VL.ATTRIBUTE3%TYPE;
    v_for_cnt               PLS_INTEGER;
    v_current_user          LWX_AR_STMT_LINE_DETAILS.CREATED_BY%TYPE;
    v_update_login          LWX_AR_STMT_LINE_DETAILS.LAST_UPDATE_LOGIN%TYPE;
    v_line_tax_amt          NUMBER;
    v_master_org_id         NUMBER;

    CURSOR v_applied_trx_cur(p_cust_trx_id NUMBER) IS
      SELECT rct.TRX_NUMBER
        FROM AR_RECEIVABLE_APPLICATIONS ara, RA_CUSTOMER_TRX rct
       WHERE ara.APPLICATION_TYPE = 'CM'
         AND ara.APPLIED_CUSTOMER_TRX_ID = rct.customer_trx_id
         AND ara.CUSTOMER_TRX_ID = p_cust_trx_id;

    CURSOR v_store_det_cur(p_customer_trx_id NUMBER) IS
      SELECT ffv.ATTRIBUTE2 store_name -- Store Name
            ,
             ffv.ATTRIBUTE3 store_phone_number -- Store Phone Number
        FROM --               GL_CODE_COMBINATIONS     gcc,
             --               RA_CUST_TRX_LINE_GL_DIST rctlg,
              RA_CUSTOMER_TRX     RCT,
             FND_FLEX_VALUES     ffv,
             FND_FLEX_VALUE_SETS ffvs
      --      WHERE rctlg.CODE_COMBINATION_ID = gcc.CODE_COMBINATION_ID
      --       AND rctlg.CUSTOMER_TRX_ID = p_customer_trx_id
      --       AND SUBSTR(gcc.SEGMENT2, 1, 1) = '0'
      --       AND rctlg.ACCOUNT_CLASS = 'REV'
       WHERE RCT.CUSTOMER_TRX_ID = p_customer_trx_id
            --       AND gcc.SEGMENT2 = ffv.FLEX_VALUE
         AND NVL(RCT.ATTRIBUTE9, 'XXX') = FFV.FLEX_VALUE
         AND ffv.FLEX_VALUE_SET_ID = ffvs.FLEX_VALUE_SET_ID
         AND ffvs.FLEX_VALUE_SET_NAME = 'LWX_RESP_CENTER'
      --      ORDER BY rctlg.LAST_UPDATE_DATE DESC;
       ORDER BY rct.LAST_UPDATE_DATE DESC;

  BEGIN
    log('l','Start of Lwx_Ar_Build_Line_Details Procedure');
    v_current_user    := TO_NUMBER(fnd_profile.VALUE('USER_ID'));
    v_update_login    := TO_NUMBER(fnd_profile.VALUE('LOGIN_ID'));
    v_master_org_id   := lwx_fnd_utility.master_org;

    SELECT LWX_AR_STMT_LINE_DETAILS_S.NEXTVAL
      INTO v_stmt_line_dtl_id
      FROM DUAL;

    SELECT LWX_AR_STMT_LINES_S.CURRVAL INTO v_stmt_line_id FROM DUAL;

    log('d','Statement Line Detail ID ' || v_stmt_line_dtl_id ||
              'Statement Line ID ' || v_stmt_line_id);

    v_stmt_line_dtl_nbr := p_trx_line_dtl_cnt;

    --**  04/25/2006 Jude Lam Re-arrange the logic on this section.

    -- Initialize the variable to default as Memo Line entry.
    v_line_type_cde        := 'M';
    v_customer_trx_line_id := NULL;
    v_ordered_qty_cnt      := NULL;
    v_shipped_qty_cnt      := NULL;
    v_item_nbr             := NULL;
    v_alt_item_nbr         := NULL;
    v_selling_price_amt    := NULL;
    v_selling_disc_amt     := NULL;
    v_extended_amt         := NULL;
    v_applied_trx_number   := NULL;

    -- Handle memo line requirements.

    IF p_line_desc_flag = 'SNP' THEN
      -- For Store Name and Store Phone Number
      -- find the store phone number (v_store_phone_number) and store name (v_store_name)
      -- from FND_FLEX_VALUES

      v_process_stage := 'Get Store Name and Phone Number for customer_trx_id: ' ||
                         to_char(p_openitem_cur_rec.customer_trx_id);

      FOR v_store_det_rec IN v_store_det_cur(p_openitem_cur_rec.CUSTOMER_TRX_ID) LOOP
        v_store_name         := v_store_det_rec.STORE_NAME;
        v_store_phone_number := v_store_det_rec.STORE_PHONE_NUMBER;
        EXIT;
      END LOOP;

      log('d',' Store Phone Number ' || v_store_phone_number ||
                ' Store Name ' || v_store_name);

      v_line_desc_txt := v_store_name;

      v_process_stage := 'Insert Memo Lines with Reason DESCRIPTION Text into Line Details Table for store info.';

      log('d',v_process_stage);

      INSERT INTO LWX_AR_STMT_LINE_DETAILS
        (STMT_LINE_DTL_ID,
         STMT_LINE_ID,
         STMT_LINE_DTL_NBR,
         LINE_TYPE_CDE,
         CUSTOMER_TRX_LINE_ID,
         ORDERED_QTY_CNT,
         SHIPPED_QTY_CNT,
         ITEM_NBR,
         ALT_ITEM_NBR,
         LINE_DESC_TXT,
         SELLING_PRICE_AMT,
         SELLING_DISC_AMT,
         EXTENDED_AMT,
         CREATED_BY,
         CREATION_DATE,
         LAST_UPDATED_BY,
         LAST_UPDATE_DATE,
         LAST_UPDATE_LOGIN)
      VALUES
        (v_stmt_line_dtl_id,
         v_stmt_line_id,
         v_stmt_line_dtl_nbr,
         v_line_type_cde,
         v_customer_trx_line_id,
         v_ordered_qty_cnt,
         v_shipped_qty_cnt,
         v_item_nbr,
         v_alt_item_nbr,
         v_line_desc_txt,
         v_selling_price_amt,
         v_selling_disc_amt,
         v_extended_amt,
         v_current_user,
         SYSDATE,
         v_current_user,
         SYSDATE,
         v_update_login);

      v_stmt_line_dtl_nbr := v_stmt_line_dtl_nbr + 1;

    ELSIF p_line_desc_flag = 'NYP' THEN
      -- For Status NYP
      v_process_stage := 'NYP Retrieve expected publishing date for inventory_item_id: ' ||
                         to_char(p_trx_line_dtl_cur_rec.inventory_item_id);
      SELECT to_char(to_date(msib.ATTRIBUTE6, 'YYYY/MM/DD HH24:MI:SS'),
                     'MMDDYY')
        INTO v_expected_publish_date
        FROM MTL_SYSTEM_ITEMS_B msib
       WHERE msib.ORGANIZATION_ID = v_master_org_id
         AND msib.INVENTORY_ITEM_ID =
             p_trx_line_dtl_cur_rec.INVENTORY_ITEM_ID;

      v_line_desc_txt := 'Not Yet Published - Expected Publish Date : ' ||
                         nvl(v_expected_publish_date, 'Not Available');
      v_process_stage := 'Insert Memo Lines with Reason DESCRIPTION Text into Line Details Table for NYP.';

      log('d',v_process_stage);

      INSERT INTO LWX_AR_STMT_LINE_DETAILS
        (STMT_LINE_DTL_ID,
         STMT_LINE_ID,
         STMT_LINE_DTL_NBR,
         LINE_TYPE_CDE,
         CUSTOMER_TRX_LINE_ID,
         ORDERED_QTY_CNT,
         SHIPPED_QTY_CNT,
         ITEM_NBR,
         ALT_ITEM_NBR,
         LINE_DESC_TXT,
         SELLING_PRICE_AMT,
         SELLING_DISC_AMT,
         EXTENDED_AMT,
         CREATED_BY,
         CREATION_DATE,
         LAST_UPDATED_BY,
         LAST_UPDATE_DATE,
         LAST_UPDATE_LOGIN)
      VALUES
        (v_stmt_line_dtl_id,
         v_stmt_line_id,
         v_stmt_line_dtl_nbr,
         v_line_type_cde,
         v_customer_trx_line_id,
         v_ordered_qty_cnt,
         v_shipped_qty_cnt,
         v_item_nbr,
         v_alt_item_nbr,
         v_line_desc_txt,
         v_selling_price_amt,
         v_selling_disc_amt,
         v_extended_amt,
         v_current_user,
         SYSDATE,
         v_current_user,
         SYSDATE,
         v_update_login);

      v_stmt_line_dtl_nbr := v_stmt_line_dtl_nbr + 1;

    ELSIF p_line_desc_flag = 'OS' THEN
      -- For Status OS

      v_process_stage := 'OS Retrieve expected publishing date for inventory_item_id: ' ||
                         to_char(p_trx_line_dtl_cur_rec.inventory_item_id);

      SELECT to_date(msib.ATTRIBUTE6, 'YYYY/MM/DD HH24:MI:SS')
        INTO v_expected_publish_date
        FROM MTL_SYSTEM_ITEMS_B msib
       WHERE msib.ORGANIZATION_ID = v_master_org_id
         AND msib.INVENTORY_ITEM_ID =
             p_trx_line_dtl_cur_rec.INVENTORY_ITEM_ID;

      v_line_desc_txt := 'Out of Stock - Expected Publish Date : ' ||
                         TO_DATE(v_expected_publish_date, 'MMDDYY');

      v_process_stage := 'Insert Memo Lines with Reason DESCRIPTION Text into Line Details Table for OS.';

      log('d',v_process_stage);

      INSERT INTO LWX_AR_STMT_LINE_DETAILS
        (STMT_LINE_DTL_ID,
         STMT_LINE_ID,
         STMT_LINE_DTL_NBR,
         LINE_TYPE_CDE,
         CUSTOMER_TRX_LINE_ID,
         ORDERED_QTY_CNT,
         SHIPPED_QTY_CNT,
         ITEM_NBR,
         ALT_ITEM_NBR,
         LINE_DESC_TXT,
         SELLING_PRICE_AMT,
         SELLING_DISC_AMT,
         EXTENDED_AMT,
         CREATED_BY,
         CREATION_DATE,
         LAST_UPDATED_BY,
         LAST_UPDATE_DATE,
         LAST_UPDATE_LOGIN)
      VALUES
        (v_stmt_line_dtl_id,
         v_stmt_line_id,
         v_stmt_line_dtl_nbr,
         v_line_type_cde,
         v_customer_trx_line_id,
         v_ordered_qty_cnt,
         v_shipped_qty_cnt,
         v_item_nbr,
         v_alt_item_nbr,
         v_line_desc_txt,
         v_selling_price_amt,
         v_selling_disc_amt,
         v_extended_amt,
         v_current_user,
         SYSDATE,
         v_current_user,
         SYSDATE,
         v_update_login);

      v_stmt_line_dtl_nbr := v_stmt_line_dtl_nbr + 1;

    ELSIF p_line_desc_flag = 'RDT' THEN
      -- Reason DESCRIPTION Text
      IF p_trx_line_dtl_cur_rec.reason_code IS NOT NULL THEN
        -- Get Credit Memo Reason
        v_process_stage := 'Get the Credit Memo Reason with reason code: ' ||
                           p_trx_line_dtl_cur_rec.reason_code;

        SELECT MEANING
          INTO v_credit_memo_reason
          FROM AR_LOOKUPS
         WHERE LOOKUP_TYPE = 'CREDIT_MEMO_REASON'
           AND LOOKUP_CODE = p_trx_line_dtl_cur_rec.REASON_CODE;

        log('d',' CREDIT_MEMO_REASON ' || v_credit_memo_reason);

      END IF;

      -- Insert Memo Line
      v_process_stage := 'Insert Memo Lines with Reason DESCRIPTION Text';

      FOR v_for_cnt IN 1 .. 6 LOOP
        log('l', ' v_for_cnt ' || v_for_cnt);

        IF v_for_cnt = 1 THEN
          v_line_desc_txt := 'Credit Reason: ' ||
                             nvl(v_credit_memo_reason, 'Not Provided');
        ELSIF v_for_cnt = 2 THEN

          FOR v_applied_trx_rec IN v_applied_trx_cur(p_openitem_cur_rec.CUSTOMER_TRX_ID) LOOP

            IF v_applied_trx_number IS NULL THEN
              v_applied_trx_number := v_applied_trx_rec.TRX_NUMBER;
            ELSE
              v_applied_trx_number := v_applied_trx_number || ', ' ||
                                      v_applied_trx_rec.TRX_NUMBER;
            END IF;

          END LOOP;

          IF v_applied_trx_number IS NULL THEN
            v_applied_trx_number := ' On Account Credit Memo ';
          END IF;

          v_line_desc_txt := 'Invoice: ' || v_applied_trx_number;

        ELSIF v_for_cnt = 3 THEN
          v_line_desc_txt := RPAD('*', 50, '*');
        ELSIF v_for_cnt = 4 THEN
          v_line_desc_txt := '**';
        ELSIF v_for_cnt = 5 THEN
          v_line_desc_txt := '**' || LPAD('CREDIT NOTE - DO NOT PAY',
                                          48 -
                                          (LENGTH('CREDIT NOTE - DO NOT PAY') / 2),
                                          ' ');
        ELSIF v_for_cnt = 6 THEN
          v_line_desc_txt := RPAD('*', 50, '*');
        END IF;

        -- Jude Lam 05/01/06 This should be in here the first time.  Otherwise, the record
        -- inserted will create a unique constraint violation.
        SELECT LWX_AR_STMT_LINE_DETAILS_S.NEXTVAL
          INTO v_stmt_line_dtl_id
          FROM DUAL;

        INSERT INTO LWX_AR_STMT_LINE_DETAILS
          (STMT_LINE_DTL_ID,
           STMT_LINE_ID,
           STMT_LINE_DTL_NBR,
           LINE_TYPE_CDE,
           CUSTOMER_TRX_LINE_ID,
           ORDERED_QTY_CNT,
           SHIPPED_QTY_CNT,
           ITEM_NBR,
           ALT_ITEM_NBR,
           LINE_DESC_TXT,
           SELLING_PRICE_AMT,
           SELLING_DISC_AMT,
           EXTENDED_AMT,
           CREATED_BY,
           CREATION_DATE,
           LAST_UPDATED_BY,
           LAST_UPDATE_DATE,
           LAST_UPDATE_LOGIN)
        VALUES
          (v_stmt_line_dtl_id,
           v_stmt_line_id,
           v_stmt_line_dtl_nbr,
           v_line_type_cde,
           v_customer_trx_line_id,
           v_ordered_qty_cnt,
           v_shipped_qty_cnt,
           v_item_nbr,
           v_alt_item_nbr,
           v_line_desc_txt,
           v_selling_price_amt,
           v_selling_disc_amt,
           v_extended_amt,
           v_current_user,
           SYSDATE,
           v_current_user,
           SYSDATE,
           v_update_login);

        v_stmt_line_dtl_nbr := v_stmt_line_dtl_nbr + 1;

      END LOOP; -- End of v_for_cnt LOOP.

    END IF; -- End of checking p_line_desc_flag.

    -- Handle the normal detail lines.

    IF p_line_desc_flag IS NULL THEN

      -- Assign Values to the Record Variable
      v_customer_trx_line_id := p_trx_line_dtl_cur_rec.CUSTOMER_TRX_LINE_ID;
      v_ordered_qty_cnt      := p_trx_line_dtl_cur_rec.QUANTITY_ORDERED;
      v_shipped_qty_cnt      := p_trx_line_dtl_cur_rec.QUANTITY_INVOICED;
      v_line_desc_txt        := p_trx_line_dtl_cur_rec.DESCRIPTION;
      v_selling_price_amt    := nvl(p_trx_line_dtl_cur_rec.unit_standard_price,
                                    p_trx_line_dtl_cur_rec.UNIT_SELLING_PRICE);
      v_extended_amt         := p_trx_line_dtl_cur_rec.EXTENDED_AMOUNT;
      v_line_type_cde        := NULL;

      -- Setup the discount percentage amount.
      BEGIN
        IF nvl(p_trx_line_dtl_cur_rec.UNIT_SELLING_PRICE, 0) !=
           nvl(p_trx_line_dtl_cur_rec.UNIT_STANDARD_PRICE, 0) THEN
          v_selling_disc_amt := ROUND((nvl(p_trx_line_dtl_cur_rec.unit_standard_price,
                                           0) - nvl(p_trx_line_dtl_cur_rec.unit_selling_price,
                                                     0)) /
                                      nvl(p_trx_line_dtl_cur_rec.unit_standard_price,
                                          p_trx_line_dtl_cur_rec.unit_selling_price) * 100,
                                      4);
        ELSE
          v_selling_disc_amt := 0;
        END IF;
      EXCEPTION
        WHEN ZERO_DIVIDE THEN
          v_selling_disc_amt := 0;
      END;

      --- Update the logic to show zero discount if the discount is a negative number.
      IF v_selling_disc_amt < 0 THEN
        v_selling_disc_amt := 0;
      END IF;

      log('d','Customer Trx Line ID ' || to_char(v_customer_trx_line_id) ||
                'Inventory item id ' ||
                to_char(p_trx_line_dtl_cur_rec.inventory_item_id) ||
                'Ordered Quantity ' || to_char(v_ordered_qty_cnt) ||
                'Invoiced Quantity ' || to_char(v_shipped_qty_cnt) ||
                'DESCRIPTION ' || v_line_desc_txt || 'Unit Selling Price ' ||
                to_char(v_selling_price_amt, '999,999,990.00') ||
                'Unit Standard Price ' ||
                to_char(v_selling_disc_amt, '999,999,990.00') ||
                'Extended Amount ' ||
                to_char(v_extended_amt, '999,999,990.00'));

      IF nvl(p_trx_line_dtl_cur_rec.inventory_item_id, -999) != -999 THEN

        -- Get Inventory Item Number
        v_process_stage := 'Get the Inventory Item Number for inventory item id: ' ||
                           to_char(p_trx_line_dtl_cur_rec.inventory_item_id);

        SELECT msib.SEGMENT1 || '.' || msib.SEGMENT2
          INTO v_item_nbr
          FROM MTL_SYSTEM_ITEMS_B msib
        --, MTL_PARAMETERS mp  -- Jude Lam 10/17/06 update
         WHERE msib.organization_id = v_master_org_id
              --mp.ORGANIZATION_CODE = 'ITM'
              --           AND mp.ORGANIZATION_ID = msib.ORGANIZATION_ID
           AND msib.INVENTORY_ITEM_ID =
               p_trx_line_dtl_cur_rec.INVENTORY_ITEM_ID;

        log('d','Inventory Item Number ' || v_item_nbr);

        -- Get the Alternate Item Number from Cross Reference if the item is not for freight.
--        IF TO_NUMBER(FND_PROFILE.VALUE('OE_INVENTORY_ITEM_FOR_FREIGHT')) !=
        IF gn_freight_item !=
           p_trx_line_dtl_cur_rec.inventory_item_id THEN

          v_process_stage := 'Get the Cross Reference for the Inventory Item for inventory_item_id: ' ||
                             to_char(p_trx_line_dtl_cur_rec.inventory_item_id);

          BEGIN
            SELECT mcr.CROSS_REFERENCE
              INTO v_alt_item_nbr
              FROM MTL_CROSS_REFERENCES mcr, MTL_SYSTEM_ITEMS_B msib
            --,
            --                   MTL_PARAMETERS       mp
             WHERE msib.INVENTORY_ITEM_ID =
                   p_trx_line_dtl_cur_rec.INVENTORY_ITEM_ID
                  --               AND mp.ORGANIZATION_CODE = 'ITM'
                  --               AND mp.ORGANIZATION_ID = msib.ORGANIZATION_ID
               AND MSIB.ORGANIZATION_ID = v_master_org_id
               AND mcr.INVENTORY_ITEM_ID = msib.INVENTORY_ITEM_ID
               AND mcr.cross_reference_type = msib.attribute13
               AND mcr.organization_id IS NULL; -- Jude Lam 06/05/06 update.
          EXCEPTION
            WHEN NO_DATA_FOUND THEN
              v_alt_item_nbr := NULL;
          END;

        END IF;

      END IF; -- End of checking inventory_item_id = -999.

      -- Jude Lam 09/05/06 Added the logic to put in an asterisk in front of the line description
      -- if the current line is taxable.
      BEGIN
        IF v_customer_trx_line_id IS NOT NULL THEN
          -- Check the tax amount for the current line.
          v_process_stage := 'Getting the total tax amount for customer_trx_line_id: ' ||
                             to_char(v_customer_trx_line_id);
          log('d',v_process_stage);

          SELECT SUM(NVL(EXTENDED_AMOUNT, 0))
            INTO v_line_tax_amt
            FROM RA_CUSTOMER_TRX_LINES
           WHERE LINE_TYPE = 'TAX'
             AND LINK_TO_CUST_TRX_LINE_ID = v_customer_trx_line_id;

          log('d','Total tax amount for the line: ' ||
                    to_char(v_line_tax_amt, '999,999,990.00'));

          IF v_line_tax_amt != 0 THEN
            -- The current line is taxable.  Put an * in front of the description field.
            v_line_desc_txt := '*' || v_line_desc_txt;
          END IF;
        END IF;
      END; -- End of checking taxable item.

      log('d',' Cross Reference for the Inventory Item ' ||
                v_alt_item_nbr);

      v_process_stage := 'Insert Memo Lines with Inventory Item and Cross Reference Details into Line Details Table';

      log('d',v_process_stage);

      INSERT INTO LWX_AR_STMT_LINE_DETAILS
        (STMT_LINE_DTL_ID,
         STMT_LINE_ID,
         STMT_LINE_DTL_NBR,
         LINE_TYPE_CDE,
         CUSTOMER_TRX_LINE_ID,
         ORDERED_QTY_CNT,
         SHIPPED_QTY_CNT,
         ITEM_NBR,
         ALT_ITEM_NBR,
         LINE_DESC_TXT,
         SELLING_PRICE_AMT,
         SELLING_DISC_AMT,
         EXTENDED_AMT,
         CREATED_BY,
         CREATION_DATE,
         LAST_UPDATED_BY,
         LAST_UPDATE_DATE,
         LAST_UPDATE_LOGIN)
      VALUES
        (v_stmt_line_dtl_id,
         v_stmt_line_id,
         v_stmt_line_dtl_nbr,
         v_line_type_cde,
         v_customer_trx_line_id,
         v_ordered_qty_cnt,
         v_shipped_qty_cnt,
         v_item_nbr,
         v_alt_item_nbr,
         v_line_desc_txt,
         v_selling_price_amt,
         v_selling_disc_amt,
         v_extended_amt,
         v_current_user,
         SYSDATE,
         v_current_user,
         SYSDATE,
         v_update_login);

      v_stmt_line_dtl_nbr := v_stmt_line_dtl_nbr + 1;

    END IF;

    p_trx_line_dtl_cnt := v_stmt_line_dtl_nbr;

    log('d','End of Lwx_Ar_Build_Line_Details Procedure');

  EXCEPTION
    WHEN OTHERS THEN
      -- Write Stage to the Log
      log('l', v_process_stage);
      -- Set Concurrent Request Run Status to Error
      retcode := 2;
      --Rollback transactions
      ROLLBACK;
      -- Raise Application Error
      app_error(-20001,'ERROR in Lwx_Ar_Build_Line_Details',null,sqlcode,sqlerrm);
  END Lwx_Ar_Build_Line_Details;
 
  PROCEDURE Lwx_Ar_Build_Line_Details_XML(p_line_desc_flag       IN VARCHAR2,
                                          p_line_type_cde        IN VARCHAR2,
                                          p_trx_line_dtl_cnt     IN OUT PLS_INTEGER,
                                          p_openitem_cur_rec     IN v_openitem_cur_rec_type,
                                          p_trx_line_dtl_cur_rec IN v_trx_line_dtl_cur_rec_type,
                                          retcode                OUT NUMBER) IS

    --- ***************************************************************************************************************
    ---   Program DESCRIPTION      :  This is the Procedure will Populate the Invoice details 
    ---                               to the XML file.
    ---
    ---   Parameters Used          :  p_line_desc_flag
    ---                               p_line_type_cde
    ---                               p_trx_line_dtl_cnt
    ---                               p_openitem_cur_rec
    ---                               p_trx_line_dtl_cur_rec
    ---                               retcode
    ---
    ---  Development and Maintenance History:
    ---  -------------------------------------
    ---  DATE         AUTHOR                   DESCRIPTION
    ---  ----------   ------------------------ ---------------------------------------------------------
    ---  2017-05-24   Greg Wright              Created.
    --- ***************************************************************************************************************

    -- Local variables declaration
    v_invoice_clob          CLOB;
    v_process_stage         VARCHAR2(240);
    v_expected_publish_date VARCHAR2(15);
    v_stmt_line_dtl_id      LWX_AR_STMT_LINE_DETAILS.STMT_LINE_DTL_ID%TYPE;
    v_stmt_line_dtl_nbr     LWX_AR_STMT_LINE_DETAILS.STMT_LINE_DTL_NBR%TYPE;
    v_line_type_cde         LWX_AR_STMT_LINE_DETAILS.LINE_TYPE_CDE%TYPE;
    v_customer_trx_line_id  LWX_AR_STMT_LINE_DETAILS.CUSTOMER_TRX_LINE_ID%TYPE;
    v_ordered_qty_cnt       LWX_AR_STMT_LINE_DETAILS.ORDERED_QTY_CNT%TYPE;
    v_shipped_qty_cnt       LWX_AR_STMT_LINE_DETAILS.SHIPPED_QTY_CNT%TYPE;
    v_item_nbr              LWX_AR_STMT_LINE_DETAILS.ITEM_NBR%TYPE;
    v_alt_item_nbr          LWX_AR_STMT_LINE_DETAILS.ALT_ITEM_NBR%TYPE;
    v_line_desc_txt         LWX_AR_STMT_LINE_DETAILS.LINE_DESC_TXT%TYPE;
    v_selling_price_amt     LWX_AR_STMT_LINE_DETAILS.SELLING_PRICE_AMT%TYPE;
    v_selling_disc_amt      LWX_AR_STMT_LINE_DETAILS.SELLING_DISC_AMT%TYPE;
    v_extended_amt          LWX_AR_STMT_LINE_DETAILS.EXTENDED_AMT%TYPE;
    v_applied_trx_number    LWX_AR_STMT_LINE_DETAILS.LINE_DESC_TXT%TYPE;
    v_credit_memo_reason    AR_LOOKUPS.MEANING%TYPE;
    v_store_phone_number    FND_FLEX_VALUES_VL.ATTRIBUTE2%TYPE;
    v_store_name            FND_FLEX_VALUES_VL.ATTRIBUTE3%TYPE;
    v_for_cnt               PLS_INTEGER;
    v_current_user          LWX_AR_STMT_LINE_DETAILS.CREATED_BY%TYPE;
    v_update_login          LWX_AR_STMT_LINE_DETAILS.LAST_UPDATE_LOGIN%TYPE;
    v_line_tax_amt          NUMBER;
    v_master_org_id         NUMBER;

    CURSOR v_applied_trx_cur(p_cust_trx_id NUMBER) IS
      SELECT rct.TRX_NUMBER
        FROM AR_RECEIVABLE_APPLICATIONS ara, RA_CUSTOMER_TRX rct
       WHERE ara.APPLICATION_TYPE = 'CM'
         AND ara.APPLIED_CUSTOMER_TRX_ID = rct.customer_trx_id
         AND ara.CUSTOMER_TRX_ID = p_cust_trx_id;

    CURSOR v_store_det_cur(p_customer_trx_id NUMBER) IS
      SELECT ffv.ATTRIBUTE2 store_name               
            ,ffv.ATTRIBUTE3 store_phone_number       
        FROM ar.RA_CUSTOMER_TRX_ALL     RCT,
             apps.FND_FLEX_VALUES       ffv,
             apps.FND_FLEX_VALUE_SETS   ffvs
       WHERE RCT.CUSTOMER_TRX_ID = p_customer_trx_id
         AND NVL(RCT.ATTRIBUTE9, 'XXX') = FFV.FLEX_VALUE
         AND ffv.FLEX_VALUE_SET_ID = ffvs.FLEX_VALUE_SET_ID
         AND ffvs.FLEX_VALUE_SET_NAME = 'LWX_RESP_CENTER'
       ORDER BY rct.LAST_UPDATE_DATE DESC;

    CURSOR inv_element_cur IS 
      SELECT xmlagg(
        xmlelement("Cons_Inv_Item",
          xmlelement("Item_Line_Type_Cde",v_line_type_cde),
          xmlelement("Item_Ordered_Qty_Cnt",v_ordered_qty_cnt),
          xmlelement("Item_Shipped_Qty_Cnt",v_shipped_qty_cnt),
          xmlelement("Item_Alt_Item_Nbr",v_alt_item_nbr),
          xmlelement("Item_Item_Nbr",v_item_nbr),
          xmlelement("Item_Line_Desc_Txt",v_line_desc_txt),
          xmlelement("Item_Selling_Price_Amt",v_selling_price_amt),
          xmlelement("Item_Selling_Price_Amt_Fmt",ltrim(to_char(v_selling_price_amt,'$999,999,999.00'))),                                             
          xmlelement("Item_Selling_Disc_Amt",v_selling_disc_amt),
          xmlelement("Item_Selling_Disc_Amt_Fmt",ltrim(to_char(v_selling_disc_amt,'990.0000') || '%')),
          xmlelement("Item_Extended_Amt",v_extended_amt),
          xmlelement("Item_Extended_Amt_Fmt",ltrim(to_char(v_extended_amt,'$999,999,999.00')))                                            
        )
        ).getClobVal()
      FROM DUAL;    

    PROCEDURE create_xml_detail_record is
      BEGIN
        IF v_line_desc_txt = 'Shipping and Processing Charges'  OR
           v_line_desc_txt = '*Shipping and Processing Charges' THEN
          RETURN;
        END IF;
        
        IF v_xml_inv_first_item = 0 THEN
          v_xml_inv_first_item := 1;
          v_xml_inv_page_cnt   := 1;
          v_xml_inv_line_cnt   := 1;
          v_xml_inv_element:= '<Cons_Inv_Item_List><Cons_Inv_Item_Page>'
                           || '<Item_Page_Cnt>1</Item_Page_Cnt>';
        ELSE 
          v_xml_inv_line_cnt:= v_xml_inv_line_cnt + 1;
          IF v_xml_inv_line_cnt > 16 THEN
            v_xml_inv_page_cnt   := v_xml_inv_page_cnt + 1;
            v_xml_inv_line_cnt   := 1;
            v_xml_inv_element:= v_xml_inv_element 
                             ||  '</Cons_Inv_Item_Page><Cons_Inv_Item_Page>'
                             ||  '<Item_Page_Cnt>'
                             ||  ltrim(to_char(v_xml_inv_page_cnt,'99999')) 
                             || '</Item_Page_Cnt>';
          END IF;
        END IF;      
      OPEN inv_element_cur;
      FETCH inv_element_cur INTO v_invoice_clob;  
      CLOSE inv_element_cur;  
      v_xml_inv_element:= v_xml_inv_element || v_invoice_clob;
    END create_xml_detail_record;

  BEGIN
    log('l','Start of Lwx_Ar_Build_Line_Details Procedure');
    v_current_user    := TO_NUMBER(fnd_profile.VALUE('USER_ID'));
    v_update_login    := TO_NUMBER(fnd_profile.VALUE('LOGIN_ID'));
    v_master_org_id   := lwx_fnd_utility.master_org;

    v_stmt_line_dtl_id:= 1; 

    v_stmt_line_dtl_nbr := p_trx_line_dtl_cnt;

    -- Initialize the variable to default as Memo Line entry.
    v_line_type_cde        := 'M';
    v_customer_trx_line_id := NULL;
    v_ordered_qty_cnt      := NULL;
    v_shipped_qty_cnt      := NULL;
    v_item_nbr             := NULL;
    v_alt_item_nbr         := NULL;
    v_selling_price_amt    := NULL;
    v_selling_disc_amt     := NULL;
    v_extended_amt         := NULL;
    v_applied_trx_number   := NULL;

    -- Handle memo line requirements.

    IF p_line_desc_flag = 'SNP' THEN
      -- For Store Name and Store Phone Number
      -- find the store phone number (v_store_phone_number) and store name (v_store_name)
      -- from FND_FLEX_VALUES

      v_process_stage := 'Get Store Name and Phone Number for customer_trx_id: ' ||
                         to_char(p_openitem_cur_rec.customer_trx_id);
      
      FOR v_store_det_rec IN v_store_det_cur(p_openitem_cur_rec.CUSTOMER_TRX_ID) LOOP
        v_store_name         := v_store_det_rec.STORE_NAME;
        v_store_phone_number := v_store_det_rec.STORE_PHONE_NUMBER;
        EXIT;
      END LOOP;

      v_line_desc_txt := v_store_name;

      v_process_stage := 'Insert Memo Lines with Reason DESCRIPTION Text into Line Details Table for store info.';

      create_xml_detail_record;

      v_stmt_line_dtl_nbr := v_stmt_line_dtl_nbr + 1;

    ELSIF p_line_desc_flag = 'NYP' THEN
      -- For Status NYP
      v_process_stage := 'NYP Retrieve expected publishing date for inventory_item_id: ' ||
                         to_char(p_trx_line_dtl_cur_rec.inventory_item_id);
      SELECT to_char(to_date(msib.ATTRIBUTE6, 'YYYY/MM/DD HH24:MI:SS'),
                     'MMDDYY')
        INTO v_expected_publish_date
        FROM inv.MTL_SYSTEM_ITEMS_B msib
       WHERE msib.ORGANIZATION_ID = v_master_org_id
         AND msib.INVENTORY_ITEM_ID =
             p_trx_line_dtl_cur_rec.INVENTORY_ITEM_ID;

      v_line_desc_txt := 'Not Yet Published - Expected Publish Date : ' ||
                         nvl(v_expected_publish_date, 'Not Available');
      v_process_stage := 'Insert Memo Lines with Reason DESCRIPTION Text into Line Details Table for NYP.';

      log('d',v_process_stage);
      create_xml_detail_record;

      v_stmt_line_dtl_nbr := v_stmt_line_dtl_nbr + 1;

    ELSIF p_line_desc_flag = 'OS' THEN
      -- For Status OS

      v_process_stage := 'OS Retrieve expected publishing date for inventory_item_id: ' ||
                         to_char(p_trx_line_dtl_cur_rec.inventory_item_id);

      SELECT to_date(msib.ATTRIBUTE6, 'YYYY/MM/DD HH24:MI:SS')
        INTO v_expected_publish_date
        FROM inv.MTL_SYSTEM_ITEMS_B msib
       WHERE msib.ORGANIZATION_ID = v_master_org_id
         AND msib.INVENTORY_ITEM_ID =
             p_trx_line_dtl_cur_rec.INVENTORY_ITEM_ID;

      v_line_desc_txt := 'Out of Stock - Expected Publish Date : ' ||
                         TO_DATE(v_expected_publish_date, 'MMDDYY');

      v_process_stage := 'Insert Memo Lines with Reason DESCRIPTION Text into Line Details Table for OS.';

      create_xml_detail_record;

      v_stmt_line_dtl_nbr := v_stmt_line_dtl_nbr + 1;

    ELSIF p_line_desc_flag = 'RDT' THEN
      -- Reason DESCRIPTION Text
      IF p_trx_line_dtl_cur_rec.reason_code IS NOT NULL THEN
        -- Get Credit Memo Reason
        v_process_stage := 'Get the Credit Memo Reason with reason code: ' ||
                           p_trx_line_dtl_cur_rec.reason_code;

        SELECT MEANING
          INTO v_credit_memo_reason
          FROM AR_LOOKUPS
         WHERE LOOKUP_TYPE = 'CREDIT_MEMO_REASON'
           AND LOOKUP_CODE = p_trx_line_dtl_cur_rec.REASON_CODE;

        log('d',' CREDIT_MEMO_REASON ' || v_credit_memo_reason);

      END IF;

      -- Insert Memo Line
      v_process_stage := 'Insert Memo Lines with Reason DESCRIPTION Text';

      FOR v_for_cnt IN 1 .. 6 LOOP
        log('l', ' v_for_cnt ' || v_for_cnt);

        IF v_for_cnt = 1 THEN
          v_line_desc_txt := 'Credit Reason: ' ||
                             nvl(v_credit_memo_reason, 'Not Provided');
        ELSIF v_for_cnt = 2 THEN

          FOR v_applied_trx_rec IN v_applied_trx_cur(p_openitem_cur_rec.CUSTOMER_TRX_ID) LOOP

            IF v_applied_trx_number IS NULL THEN
              v_applied_trx_number := v_applied_trx_rec.TRX_NUMBER;
            ELSE
              v_applied_trx_number := v_applied_trx_number || ', ' ||
                                      v_applied_trx_rec.TRX_NUMBER;
            END IF;

          END LOOP;

          IF v_applied_trx_number IS NULL THEN
            v_applied_trx_number := ' On Account Credit Memo ';
          END IF;

          v_line_desc_txt := 'Invoice: ' || v_applied_trx_number;

        ELSIF v_for_cnt = 3 THEN
          v_line_desc_txt := RPAD('*', 40, '*');
        ELSIF v_for_cnt = 4 THEN
          v_line_desc_txt := '**';
        ELSIF v_for_cnt = 5 THEN
          v_line_desc_txt := '**' || LPAD('CREDIT NOTE - DO NOT PAY',
                                          48 -
                                          (LENGTH('CREDIT NOTE - DO NOT PAY') / 2),
                                          ' ');
        ELSIF v_for_cnt = 6 THEN
          v_line_desc_txt := RPAD('*', 40, '*');
        END IF;

        create_xml_detail_record;

        v_stmt_line_dtl_nbr := v_stmt_line_dtl_nbr + 1;

      END LOOP; -- End of v_for_cnt LOOP.

    END IF; -- End of checking p_line_desc_flag.

    -- Handle the normal detail lines.

    IF p_line_desc_flag IS NULL THEN

      -- Assign Values to the Record Variable
      v_customer_trx_line_id := p_trx_line_dtl_cur_rec.CUSTOMER_TRX_LINE_ID;
      v_ordered_qty_cnt      := p_trx_line_dtl_cur_rec.QUANTITY_ORDERED;
      v_shipped_qty_cnt      := p_trx_line_dtl_cur_rec.QUANTITY_INVOICED;
      v_line_desc_txt        := p_trx_line_dtl_cur_rec.DESCRIPTION;
      v_selling_price_amt    := nvl(p_trx_line_dtl_cur_rec.unit_standard_price,
                                    p_trx_line_dtl_cur_rec.UNIT_SELLING_PRICE);
      v_extended_amt         := p_trx_line_dtl_cur_rec.EXTENDED_AMOUNT;
      v_line_type_cde        := NULL;

      -- Setup the discount percentage amount.
      BEGIN
        IF nvl(p_trx_line_dtl_cur_rec.UNIT_SELLING_PRICE, 0) !=
           nvl(p_trx_line_dtl_cur_rec.UNIT_STANDARD_PRICE, 0) THEN
          v_selling_disc_amt := ROUND((nvl(p_trx_line_dtl_cur_rec.unit_standard_price,
                                           0) - nvl(p_trx_line_dtl_cur_rec.unit_selling_price,
                                                     0)) /
                                      nvl(p_trx_line_dtl_cur_rec.unit_standard_price,
                                          p_trx_line_dtl_cur_rec.unit_selling_price) * 100,
                                      4);
        ELSE
          v_selling_disc_amt := 0;
        END IF;
      EXCEPTION
        WHEN ZERO_DIVIDE THEN
          v_selling_disc_amt := 0;
      END;

      --- Update the logic to show zero discount if the discount is a negative number.
      IF v_selling_disc_amt < 0 THEN
        v_selling_disc_amt := 0;
      END IF;

      IF nvl(p_trx_line_dtl_cur_rec.inventory_item_id, -999) != -999 THEN

        -- Get Inventory Item Number
        v_process_stage := 'Get the Inventory Item Number for inventory item id: ' ||
                           to_char(p_trx_line_dtl_cur_rec.inventory_item_id);

        SELECT msib.SEGMENT1 || '.' || msib.SEGMENT2
          INTO v_item_nbr
          FROM MTL_SYSTEM_ITEMS_B msib
         WHERE msib.organization_id = v_master_org_id
           AND msib.INVENTORY_ITEM_ID =
               p_trx_line_dtl_cur_rec.INVENTORY_ITEM_ID;

        log('d','Inventory Item Number ' || v_item_nbr);

        -- Get the Alternate Item Number from Cross Reference if the item is not for freight.
        IF gn_freight_item !=
           p_trx_line_dtl_cur_rec.inventory_item_id THEN

          v_process_stage := 'Get the Cross Reference for the Inventory Item for inventory_item_id: ' ||
                             to_char(p_trx_line_dtl_cur_rec.inventory_item_id);

          BEGIN
            SELECT mcr.CROSS_REFERENCE
              INTO v_alt_item_nbr
              FROM MTL_CROSS_REFERENCES mcr, MTL_SYSTEM_ITEMS_B msib
             WHERE msib.INVENTORY_ITEM_ID =
                   p_trx_line_dtl_cur_rec.INVENTORY_ITEM_ID
               AND MSIB.ORGANIZATION_ID = v_master_org_id
               AND mcr.INVENTORY_ITEM_ID = msib.INVENTORY_ITEM_ID
               AND mcr.cross_reference_type = msib.attribute13
               AND mcr.organization_id IS NULL; -- Jude Lam 06/05/06 update.
          EXCEPTION
            WHEN NO_DATA_FOUND THEN
              v_alt_item_nbr := NULL;
          END;

        END IF;

      END IF; -- End of checking inventory_item_id = -999.

      BEGIN
        IF v_customer_trx_line_id IS NOT NULL THEN
          -- Check the tax amount for the current line.
          v_process_stage := 'Getting the total tax amount for customer_trx_line_id: ' ||
                             to_char(v_customer_trx_line_id);
          log('d',v_process_stage);

          SELECT SUM(NVL(EXTENDED_AMOUNT, 0))
            INTO v_line_tax_amt
            FROM ar.RA_CUSTOMER_TRX_LINES_ALL
           WHERE LINE_TYPE = 'TAX'
             AND LINK_TO_CUST_TRX_LINE_ID = v_customer_trx_line_id;

          log('d','Total tax amount for the line: ' ||
                    to_char(v_line_tax_amt, '999,999,990.00'));

          IF v_line_tax_amt != 0 THEN
            -- The current line is taxable.  Put an * in front of the description field.
            v_line_desc_txt := '*' || v_line_desc_txt;
          END IF;
        END IF;
      END; -- End of checking taxable item.

      log('d',' Cross Reference for the Inventory Item ' ||
                v_alt_item_nbr);

      v_process_stage := 'Insert Memo Lines with Inventory Item and Cross Reference Details into Line Details Table';

      log('d',v_process_stage);
      create_xml_detail_record;

      v_stmt_line_dtl_nbr := v_stmt_line_dtl_nbr + 1;

    END IF;

    p_trx_line_dtl_cnt := v_stmt_line_dtl_nbr;

    log('d','End of Lwx_Ar_Build_Line_Details Procedure');

  EXCEPTION
    WHEN OTHERS THEN
      retcode := 2;
      app_error(-20001,'ERROR in Lwx_Ar_Build_Line_Details',null,sqlcode,sqlerrm);
  END Lwx_Ar_Build_Line_Details_XML;

  FUNCTION Lwx_Stmt_Scanned_Line_Logic(p_account_number IN VARCHAR2,
                                       p_amount_to_pay  IN NUMBER,
                                       retcode          OUT NUMBER)
    RETURN VARCHAR2 IS
    --- ***************************************************************************************************************
    ---   Program DESCRIPTION    :  This is the function will perform the Scanned Line Logic and returns the value
    ---                             to the Calling Program
    ---
    ---   Parameters Used        :  p_account_number
    ---                             p_amount_to_pay
    ---                             retcode
    ---
    ---  Development and Maintenance History:
    ---  -------------------------------------
    ---  DATE         AUTHOR                   DESCRIPTION
    ---  ----------   ------------------------ ---------------------------------------------------------
    ---  20-DEC-2005  S Saravana Bhavan, BCT   Initial Creation
    ---  14-MAR-2006  Rajmohan K, BCT          Added debug message for log file
    ---  2006-10-23   Jude Lam, TITAN          Updated the Lwx_Stmt_Scanned_line and Lwx_Inv_scanned_Line_logic to
    ---                                           keep any trailing zeros after the decimal is trimmed off.
    ---  2008-09-25   Greg Wright              Changed logic for BOA.
    --- ***************************************************************************************************************

    -- Declare Local Variables
    v_process_stage          VARCHAR2(240);
    v_scanned_line           VARCHAR2(200) := null;
    v_account_number         VARCHAR2(10) := null;
    v_amount_to_pay          VARCHAR2(9) := null;
    v_check_digit_constant   VARCHAR2(5);
    v_reference_number       VARCHAR2(9) := null;
    v_scanned_line_chk_digit NUMBER;
  BEGIN
    log('d','Start of Lwx_Stmt_Scanned_Line_Logic Procedure');

    v_process_stage := 'Begin Scanned Line Logic.';

    -- Assign values to the variable
    v_account_number       := LPAD(p_account_number, 10, '0');
    v_amount_to_pay        := trim(to_char(ABS(NVL(p_amount_to_pay, 0)),
                                           '999990.00')); -- Jude Lam 10/23/06 update to keep the trailing zero after decimal.
    v_amount_to_pay        := LPAD(REPLACE(v_amount_to_pay, '.', ''),
                                   9,
                                   '0');
    v_reference_number     := '000000000';
    v_check_digit_constant := '11111';
    v_process_stage        := 'Call to Scanned Line Check Digit Function ';
    -- Call to Get the Check Digit
    v_scanned_line_chk_digit := Lwx_Get_Check_Digit(v_check_digit_constant,
                                                    v_account_number,
                                                    v_amount_to_pay,
                                                    v_reference_number);
    -- Check the Call to Check Digit Status
    IF v_scanned_line_chk_digit = -999 THEN
      -- Function Call Returns Error
      -- Raise Application Error
      app_error(-20001,'ERROR in Scanned Line Check Digit Process');
    END IF;

    v_process_stage := 'Build Scanned Line.';

    -- Build Scanned Line
    v_scanned_line := v_check_digit_constant || v_account_number ||
                      v_amount_to_pay || v_reference_number;
    v_scanned_line := v_scanned_line || TO_CHAR(v_scanned_line_chk_digit);
    log('d','Scanned Line ' || v_scanned_line);
    log('d','Scanned Line Length ' || length(v_scanned_line));
    log('d','End of Lwx_Stmt_Scanned_Line_Logic Procedure');
    RETURN(v_scanned_line);
  EXCEPTION
    WHEN OTHERS THEN
      -- Write Stage to the Log
      log('l', v_process_stage);
      log('l',
                        'Error Code:    ' || sqlcode);
      log('l', 'Error Message: ' || SQLERRM);
      -- Set Concurrent Request Run Status to Error
      retcode := 2;
      -- Raise Application Error
      app_error(-20001,'ERROR in Lwx_Stmt_Scanned_Line_Logic :',null,sqlcode,sqlerrm);
  END Lwx_Stmt_Scanned_Line_Logic;

  FUNCTION Lwx_Get_Check_Digit(p_check_digit_constant IN VARCHAR2,
                               p_account_number       IN VARCHAR2,
                               p_payment_amt          IN VARCHAR2,
                               p_reference_number     IN VARCHAR2)
    RETURN NUMBER IS
    --- ***************************************************************************************************************
    ---   Program DESCRIPTION   :  This function will Arrive the Check Digit for the given parameter value and
    ---                            returns the arrived check digit to the calling program
    ---
    ---   Parameters Used       :  p_check_digit_constant
    ---                            p_account_number
    ---                            p_payment_amt
    ---
    ---  Development and Maintenance History:
    ---  -------------------------------------
    ---  DATE         AUTHOR                   DESCRIPTION
    ---  ----------   ------------------------ ---------------------------------------------------------
    ---  20-DEC-2005  S Saravana Bhavan, BCT   Initial Creation
    ---  14-MAR-2006  Rajmohan K, BCT          Added debug message for log file
    ---  25-SEP-2008  Greg Wright              Added p_reference_number parameter.
    ---  2011-10-14   Jason McCleskey          P-2039 - Invoice Selection Performance 
    --- ***************************************************************************************************************

    -- Declare Local Variables
    v_process_stage      VARCHAR2(240);
    v_build_string       VARCHAR2(50);
    v_add_odd_digits     NUMBER := 0;
    v_add_even_digits    NUMBER := 0;
    v_check_digit        NUMBER := 0;
    v_result             NUMBER;
  BEGIN
    log('d','Start of Lwx_Get_Check_Digit Procedure');
    v_build_string       := p_check_digit_constant || p_account_number ||
                            p_payment_amt || p_reference_number;

    log('d','v_build_string ' || v_build_string);
    log('d','v_build_string length ' || length(v_build_string));

    -- Extract the Odd and Even digits
    v_process_stage := 'Extract Odd and Even Digits';
    log('d',' v_process_stage ' || v_process_stage);

    FOR v_i IN 1 .. (LENGTH(v_build_string)) 
    LOOP
      v_result := to_number(substr(v_build_string,v_i,1));
      IF MOD(v_i,2) = 1 THEN -- Double the numbers from the odd positions and add digits
        IF (v_result > 4) THEN
          v_add_odd_digits:= v_add_odd_digits + MOD((2 * v_result),10) + 1;
        ELSE
          v_add_odd_digits:= v_add_odd_digits + (2 * v_result);
        END IF;
      ELSE                   -- Add the numbers from the even positions.
        v_add_even_digits := v_add_even_digits + v_result;
      END IF;
    END LOOP;

    --Add the Odd and Even digits add up values
    --Find Next Multiple of ten for the Add Up Value
    --Subtract the Odd and Even digits add up Value from the Next Multiple of ten to get the check digit
    v_process_stage := 'Arrive the Check Digits for the given Account Number and Payment Amount ';

    v_check_digit := 10 - mod((v_add_odd_digits + v_add_even_digits), 10);
    IF v_check_digit = 10 THEN
      v_check_digit := 0;
    END IF;

    log('d','Check Digit ' || v_check_digit);
    log('d','End of Lwx_Get_Check_Digit Procedure');
    RETURN(v_check_digit);
  EXCEPTION
    WHEN OTHERS THEN
      log('l',
                        'Error Code:    ' || sqlcode);
      log('l', 'Error Message: ' || SQLERRM);
      -- Write Stage to the Log
      log('l', v_process_stage);
      --v_check_digit := -999;
      RETURN(v_check_digit);
  END Lwx_Get_Check_Digit;

  PROCEDURE Format_Address(p_addr1       IN VARCHAR2,
                           p_addr2       IN VARCHAR2,
                           p_addr3       IN VARCHAR2,
                           p_addr4       IN VARCHAR2,
                           p_city        IN VARCHAR2,
                           p_state       IN VARCHAR2,
                           p_postal_code IN VARCHAR2,
                           p_country     IN VARCHAR2,
                           p_out_addr1   OUT VARCHAR2,
                           p_out_addr2   OUT VARCHAR2,
                           p_out_addr3   OUT VARCHAR2,
                           p_out_addr4   OUT VARCHAR2,
                           p_out_addr5   OUT VARCHAR2,
                           retcode       IN OUT NUMBER) IS

    --- ***************************************************************************************************************
    ---   Program DESCRIPTION  :  This is the procedure that format the address and put the proper value into
    ---                           p_out_xxx variable.
    ---
    ---  Parameters Used       :   retcode
    ---
    ---  Development and Maintenance History:
    ---  -------------------------------------
    ---  DATE         AUTHOR                   DESCRIPTION
    ---  ----------   ------------------------ ---------------------------------------------------------
    ---  2006-04-25   Jude Lam, TITAN          Initial Creation
    ---  2006-05-04   Jude Lam, TITAN          Rewrite the routine so that it will simply put the proper format
    ---                                        into the p_out_addrx variable and let the calling program to use them
    ---                                        appropriately.
    --- ***************************************************************************************************************

    v_process_stage VARCHAR2(240);
    TYPE v_addr_type IS TABLE OF VARCHAR2(200) INDEX BY BINARY_INTEGER;
    v_addr_in_tbl           v_addr_type;
    v_addr_out_tbl          v_addr_type;
    v_current_blank_line_id INTEGER := 5;

  BEGIN

    -- Assign initial value to the p_out_addx variable.
    p_out_addr1 := NULL;
    p_out_addr2 := NULL;
    p_out_addr3 := NULL;
    p_out_addr4 := NULL;
    p_out_addr5 := NULL;

    -- Initialize the pl/sql table.
    v_process_stage := 'Assigning initial value to address pl/sql table.';

    FOR i IN 1 .. 5 LOOP
      v_addr_in_tbl(i) := NULL;
      v_addr_out_tbl(i) := NULL;
    END LOOP;

    v_process_stage := 'Checking p_country: ' || p_country;

    IF p_country != 'United States' THEN
      v_addr_in_tbl(5) := p_country;
      v_current_blank_line_id := v_current_blank_line_id - 1;
    END IF;

    -- Check the city name, if this is bigger than 17 characters, the city needs to be on a line
    -- by itself.  Otherwise, it combines with the state and zip.
    v_process_stage := 'Checking city length with city name: ' || p_city ||
                       ' and lenght: ' || to_char(length(p_city));

    IF length(p_city) > 17 THEN
      v_addr_in_tbl(v_current_blank_line_id) := p_state || ' ' ||
                                                p_postal_code;
      v_current_blank_line_id := v_current_blank_line_id - 1;
      v_addr_in_tbl(v_current_blank_line_id) := p_city;
      v_current_blank_line_id := v_current_blank_line_id - 1;
    ELSE
      v_addr_in_tbl(v_current_blank_line_id) := p_city || ' ' || p_state || ' ' ||
                                                p_postal_code;
      v_current_blank_line_id := v_current_blank_line_id - 1;
    END IF;

    -- Assign the remaining open blank lines with incoming address.
    FOR i IN 1 .. v_current_blank_line_id LOOP
      v_process_stage := 'Assigning inbound address pl/sql table with remaining inbound variable with i value: ' ||
                         to_char(i);
      IF i = 1 THEN
        v_addr_in_tbl(i) := p_addr1;
      ELSIF i = 2 THEN
        v_addr_in_tbl(i) := p_addr2;
      ELSIF i = 3 THEN
        v_addr_in_tbl(i) := p_addr3;
      ELSIF i = 4 THEN
        v_addr_in_tbl(i) := p_addr4;
      END IF;
    END LOOP; -- End of i IN 1..v_current_blank_line_id LOOP.

    -- Build the outbound address table.
    -- Reuse the blank line counter.
    v_current_blank_line_id := 1;

    FOR i IN 1 .. 5 LOOP
      v_process_stage := 'Assigning outbound pl/sql table from inbound pl/sql with i value: ' ||
                         to_char(i);

      IF v_addr_in_tbl(i) IS NOT NULL THEN
        v_addr_out_tbl(v_current_blank_line_id) := v_addr_in_tbl(i);
        v_current_blank_line_id := v_current_blank_line_id + 1;
      END IF;

    END LOOP; -- End of i IN 1..5 LOOP.

    -- Assign from out pl/sql table back to outbound variable.
    FOR i IN 1 .. 5 LOOP
      v_process_stage := 'Assigning outbound variable with out address pl/sql table with i value: ' ||
                         to_char(i);

      IF i = 1 THEN
        p_out_addr1 := substr(v_addr_out_tbl(i), 1, 40);
      ELSIF i = 2 THEN
        p_out_addr2 := substr(v_addr_out_tbl(i), 1, 40);
      ELSIF i = 3 THEN
        p_out_addr3 := substr(v_addr_out_tbl(i), 1, 40);
      ELSIF i = 4 THEN
        p_out_addr4 := substr(v_addr_out_tbl(i), 1, 40);
      ELSIF i = 5 THEN
        p_out_addr5 := substr(v_addr_out_tbl(i), 1, 40);
      END IF;
    END LOOP;

  EXCEPTION
    WHEN OTHERS THEN
      -- Write Stage to the Log
      log('l', v_process_stage);
      -- Set Concurrent Request Run Status to Error
      retcode := 2;
      --Rollback transactions
      ROLLBACK;
      -- Raise Application Error
      app_error(-20001,'ERROR in Format_Address',null,sqlcode,sqlerrm);
  END Format_Address;

  --- ***************************************************************************************************************
  --- Function check_display
  --- Description
  ---    This function will use the customer trx line id to check to see if the current line needs to be displayed.
  ---    This is needed to distinguish the regular shipping and handling versus those special charges.
  --- ***************************************************************************************************************
  FUNCTION check_display(p_customer_trx_line_id IN NUMBER) RETURN BOOLEAN IS
    v_process_stage VARCHAR2(600) := NULL;

    v_intfc_line_context    RA_CUSTOMER_TRX_LINES.INTERFACE_LINE_CONTEXT%TYPE;
    v_intfc_line_attribute6 RA_CUSTOMER_TRX_LINES.INTERFACE_LINE_ATTRIBUTE6%TYPE;
    v_sales_order_line      RA_CUSTOMER_TRX_LINES.SALES_ORDER_LINE%TYPE;
    v_inventory_item_id     RA_CUSTOMER_TRX_LINES.INVENTORY_ITEM_ID%TYPE;
    v_charge_type_code      OE_PRICE_ADJUSTMENTS.CHARGE_TYPE_CODE%TYPE;

  BEGIN

    -- First check to see if the p_customer_trx_line_id is not null.
    IF p_customer_trx_line_id IS NULL THEN
      RETURN TRUE;
    ELSE
      v_process_stage := 'Retrieving ra_customer_trx_line info. using p_customer_trx_line_id: ' ||
                         to_char(p_customer_trx_line_id);

      SELECT INTERFACE_LINE_CONTEXT,
             INTERFACE_LINE_ATTRIBUTE6,
             SALES_ORDER_LINE,
             INVENTORY_ITEM_ID
        INTO v_intfc_line_context,
             v_intfc_line_attribute6,
             v_sales_order_line,
             v_inventory_item_id
        FROM RA_CUSTOMER_TRX_LINES
       WHERE CUSTOMER_TRX_LINE_ID = p_customer_trx_line_id;

      -- Check to see if the current line item is a freight item.
      IF nvl(v_inventory_item_id, -999) =
         gn_freight_item THEN
--         to_number(fnd_profile.value('OE_INVENTORY_ITEM_FOR_FREIGHT')) THEN
        -- Freight item.  Now check to see if this is coming from OM and if it is, check the charge type code.
        IF v_intfc_line_context = 'ORDER ENTRY' THEN
          -- retrieve the charge type code.
          v_process_stage := 'Retrieve data from oe_price_adjustments using interface line attribute6 value: ' ||
                             v_intfc_line_attribute6;

          BEGIN
            SELECT CHARGE_TYPE_CODE
              INTO v_charge_type_code
              FROM OE_PRICE_ADJUSTMENTS
             WHERE PRICE_ADJUSTMENT_ID = TO_NUMBER(v_intfc_line_attribute6);

            IF v_charge_type_code = 'SHIPPING AND PROCESSING' THEN
              -- Regular freight, and therefore, don't display it.
              RETURN FALSE;
            ELSE
              RETURN TRUE;
            END IF;

          EXCEPTION
            WHEN NO_DATA_FOUND THEN
              RETURN TRUE;
          END;
        ELSE
          -- Non OM transaction.  Any line that charges to the item will be treated as a regular shipping and
          -- therefore, not to display the line.
          RETURN FALSE;
        END IF; -- End of checking Interface line context = ORDER ENTRY
      ELSE
        -- Not a freight item.  So display the line.
        RETURN TRUE;
      END IF;

    END IF; -- End of checking p_customer_trx_line_id IS NULL.

  EXCEPTION
    WHEN OTHERS THEN
      log('l','ERROR in check_display with v_process_stage: ');
      log('l', v_process_stage);
      log('l','SQLCODE: ' || sqlcode || ' SQLERRM: ' || sqlerrm);
      ROLLBACK;
      app_error(-20001,'ERROR in check_display.  Please check the log file.');
  END check_display;

  PROCEDURE Lwx_Data_File_Phase(retcode OUT NUMBER) IS
    --- ***************************************************************************************************************
    ---   Program DESCRIPTION  :  This is the procedure that will generate the data file needed by the Heidelberg
    ---                           Printer software.
    ---
    ---  Parameters Used       :   retcode
    ---
    ---  Development and Maintenance History:
    ---  -------------------------------------
    ---  DATE         AUTHOR                   DESCRIPTION
    ---  ----------   ------------------------ ---------------------------------------------------------
    ---  20-DEC-2005  S Saravana Bhavan, BCT   Initial Creation
    ---  14-MAR-2006  Rajmohan K, BCT          Added debug message for log file
    ---  2006-04-25   Jude Lam, TITAN          Update the address generation logic.
    ---  2006-06-20   Jude Lam, TITAN          Updated the function to consider the difference
    ---                                           between regular shipping and handling versus those special charges.
    ---  2006-07-18   Jude Lam, TITAN          Updated the Lwx_Data_File_Phase to format the date to MM-DD-YY for F3-1-3 field.
    ---  2006-07-25   Jude Lam, TITAN          Updated the Lwx_Data_file_Phase to format the date to MM-DD-YY for F2-1-4 field.
    ---  2006-09-06   Jude Lam, TITAN          Updated the Lwx_Data_File_Phase to show Store name on F3-2-4 data field.
    ---  2006-09-26   Jude Lam, TITAN          Updated the Lwx_Data_File_Phase to copy the same store name and sales channel
    ---                                           logic from the F3 section to the F2 section.
    ---  2008-03-18   David Howard	           Payments print payment name in the Point of Sale field.
    ---  2018-06-14   Greg Wright              OF-3004 - As part of moving the statement process to DNI, 
    ---                                                  they need an indicator for foreign statement addresses.    
    --- ***************************************************************************************************************

    -- Local varibles declaration
    v_process_stage        VARCHAR2(240);
    v_first_38_sort_key    VARCHAR2(200);
    v_build_record_fields  VARCHAR2(2000);
    v_build_record_line    VARCHAR2(2000);
    v_f2_total_page        NUMBER;
    v_f3_total_page        NUMBER;
    v_f2_line_cnt          PLS_INTEGER;
    v_f3_line_cnt          PLS_INTEGER;
    v_f4_dtl_cnt           PLS_INTEGER;
    v_conc_req_id          NUMBER(15);
    v_send_to_postal_cde   LWX_AR_STMT_HEADERS.SEND_TO_POSTAL_CDE%TYPE;
    v_f2_rec_count         NUMBER := 0; -- Jude Lam 05/01/06 Per Greg Wright's email, don't generate F2 header record if
    -- there is no F2 record.
    v_sls_chnl_desc    VARCHAR2(30) := NULL;
    v_pymt_name    VARCHAR2(30) := NULL;
    v_rec_prnt_nme     VARCHAR2(30) := NULL;
    v_out_addr1        VARCHAR2(200) := NULL;
    v_out_addr2        VARCHAR2(200) := NULL;
    v_out_addr3        VARCHAR2(200) := NULL;
    v_out_addr4        VARCHAR2(200) := NULL;
    v_out_addr5        VARCHAR2(200) := NULL;
    v_batch_source_nme RA_BATCH_SOURCES.NAME%TYPE;
    v_store_name       VARCHAR2(240);
    v_suppress_csv     VARCHAR2(1)   := 'N'; -- Change to 'Y' when ready to suppress printing CSV statements. 
    -- Declare F1 Type Record Cursor
    -- SQL #11
    CURSOR v_ar_stmt_hdr_f1_cur(p_conc_req_id IN NUMBER) IS
      SELECT STMT_HDR_ID,
             (CASE WHEN STATEMENT_CYCLE_ID IN (1005,1006) THEN 'Y'
              ELSE 'N'
              END) wave_c_or_f,
             (CASE WHEN NVL(SEND_TO_CNTRY_NME,'"') = 'United States' THEN 'N'
              ELSE 'Y'
              END) foreign_addr_y_or_n,
             SEND_TO_CUST_NBR,
             SEND_TO_CUST_NME,
             SEND_TO_LINE_1_ADR,
             SEND_TO_LINE_2_ADR,
             SEND_TO_LINE_3_ADR,
             SEND_TO_LINE_4_ADR,
             SEND_TO_CITY_NME,
             SEND_TO_STATE_CDE,
             SEND_TO_POSTAL_CDE,
             SEND_TO_CNTRY_NME,
             PPD_PAGE_CNT,
             DTL_PAGE_CNT,
             INVO_PAGE_CNT,
             TOTAL_PAGE_CNT,
             LOGO_CDE,
             STMT_DTE,
             LW_FAX_NBR,
             LW_EMAIL_ADR,
             SCAN_LINE_NME,
             MSG1_NME,
             MSG2_NME,
             STMT_DUE_DTE,
             DUE_AMT,
             OVER_DUE_AMT,
             TO_PAY_AMT,
             NOT_DUE_AMT,
             BALANCE_AMT,
             REP_PHONE_NBR,
             CUST_EMAIL_ADR,
             hca.attribute14 stmt_type
        FROM LWX_AR_STMT_HEADERS  sh,
             HZ_CUST_ACCOUNTS     hca
       WHERE sh.STMT_RUN_CONC_REQ_ID = p_conc_req_id
       AND   sh.SEND_TO_CUST_NBR = hca.ACCOUNT_NUMBER
       ORDER BY NVL(SEND_TO_STATE_CDE, 'ZZ'), SEND_TO_CUST_NBR;
    -- Declare F2 Type Record Cursor
    -- SQL #15
    CURSOR v_ar_stmt_lines_f2_cur(v_ar_stmt_hdr_id IN NUMBER) IS
      SELECT SPCL_LINE_IND,
             TRANS_DTE,
             DOC_TYPE_NME,
             SLS_CHNL_NME,
             CUST_REF_NME,
             ORIG_AMT,
             OUTSTND_AMT,
             DUE_DTE,
             TRANS_NBR,
             FUT_PMT_IND,
             PARTIAL_PMT_IND,
             CUSTOMER_TRX_ID,
             CASH_RECEIPT_ID
        FROM LWX_AR_STMT_LINES
       WHERE STMT_HDR_ID = v_ar_stmt_hdr_id
         AND REC_TYPE_CDE = 'F2'
         AND NVL(INCL_CUR_STMT_IND, 'Y') = 'Y' -- Jude Lam 05/17/06 update.
       ORDER BY STMT_LINE_ID;
    -- Declare F3 Type Record Cursor
    -- SQL #12
    -- 05/03/06 Jude Lam update the query to pull in the FUT_PMT_IND column and use it in the data file generation.
    CURSOR v_ar_stmt_lines_f3_cur(v_ar_stmt_hdr_id IN NUMBER) IS
      SELECT SPCL_LINE_IND,
             TRANS_DTE,
             DOC_TYPE_NME,
             SLS_CHNL_NME,
             CUST_REF_NME,
             ORIG_AMT,
             OUTSTND_AMT,
             DUE_DTE,
             TRANS_NBR,
             FUT_PMT_IND,
             PARTIAL_PMT_IND,
             CUSTOMER_TRX_ID,
             CASH_RECEIPT_ID
        FROM LWX_AR_STMT_LINES
       WHERE STMT_HDR_ID = v_ar_stmt_hdr_id
         AND REC_TYPE_CDE = 'F3'
         AND NVL(INCL_CUR_STMT_IND, 'Y') = 'Y' -- Jude Lam 05/17/06 update.
       ORDER BY STMT_LINE_ID;
    -- Declare F4 Type Record Cursor
    -- SQL #13
    CURSOR v_ar_stmt_hdr_f4_cur(v_ar_stmt_hdr_id IN NUMBER) IS
      SELECT TRANS_DTE,
             TRANS_NBR,
             PAGE_CNT,
             LINE_CNT,
             LOGO_CDE,
             DOC_TITLE_NME,
             REP_MSG_NME,
             SHIP_TO_CUST_NBR,
             SHIP_TO_CUST_NME,
             SHIP_TO_LINE_1_ADR,
             SHIP_TO_LINE_2_ADR,
             SHIP_TO_LINE_3_ADR,
             SHIP_TO_LINE_4_ADR,
             SHIP_TO_CITY_NME,
             SHIP_TO_STATE_CDE,
             SHIP_TO_POSTAL_CDE,
             SHIP_TO_CNTRY_NME,
             BILL_TO_CUST_NBR,
             BILL_TO_CUST_NME,
             BILL_TO_LINE_1_ADR,
             BILL_TO_LINE_2_ADR,
             BILL_TO_LINE_3_ADR,
             BILL_TO_LINE_4_ADR,
             BILL_TO_CITY_NME,
             BILL_TO_STATE_CDE,
             BILL_TO_POSTAL_CDE,
             BILL_TO_CNTRY_NME,
             CUST_REF_NME,
             TERM_MSG1_NME,
             TERM_MSG2_NME,
             ORDER_DTE,
             SHIP_METH_NME,
             CUST_CONT_NME,
             CUST_CONT_PHONE_NBR,
             SLS_CHNL_NME,
             STMT_LINE_ID,
             MKT_MSG1_NME,
             MKT_MSG2_NME,
             MKT_MSG3_NME,
             MKT_MSG4_NME,
             SUB_TOTAL_AMT,
             SHIP_HNDL_AMT,
             TAX_AMT,
             PMT_USED_AMT,
             TOTAL_DUE_AMT,
	     cash_receipt_id
        FROM LWX_AR_STMT_LINES
       WHERE STMT_HDR_ID = v_ar_stmt_hdr_id
         AND REC_TYPE_CDE = 'F4'
         AND NVL(INCL_CUR_STMT_IND, 'Y') = 'Y' -- Jude Lam 05/17/06 update.
       ORDER BY STMT_LINE_ID;
    -- Declare F4 Type Detail Record Cursor
    -- SQL #14
    CURSOR v_ar_stmt_dtl_f4_cur(v_ar_stmt_line_id IN NUMBER) IS
      SELECT LINE_TYPE_CDE,
             ORDERED_QTY_CNT,
             SHIPPED_QTY_CNT,
             ALT_ITEM_NBR,
             ITEM_NBR,
             LINE_DESC_TXT,
             SELLING_PRICE_AMT,
             SELLING_DISC_AMT,
             EXTENDED_AMT,
             CUSTOMER_TRX_LINE_ID
        FROM LWX_AR_STMT_LINE_DETAILS
       WHERE STMT_LINE_ID = v_ar_stmt_line_id
       ORDER BY STMT_LINE_DTL_ID;

    CURSOR v_store_det_cur(p_customer_trx_id NUMBER) IS
      SELECT ffv.ATTRIBUTE2 store_name -- Store Name
            ,
             ffv.ATTRIBUTE3 store_phone_number -- Store Phone Number
        FROM RA_CUSTOMER_TRX     RCT,
             FND_FLEX_VALUES     ffv,
             FND_FLEX_VALUE_SETS ffvs
       WHERE RCT.CUSTOMER_TRX_ID = p_customer_trx_id
         AND NVL(RCT.ATTRIBUTE9, 'XXX') = FFV.FLEX_VALUE
         AND ffv.FLEX_VALUE_SET_ID = ffvs.FLEX_VALUE_SET_ID
         AND ffvs.FLEX_VALUE_SET_NAME = 'LWX_RESP_CENTER'
       ORDER BY rct.LAST_UPDATE_DATE DESC;

     CURSOR v_rcpt_prnt_nme_cur (p_rcpt_mthd_id NUMBER) is
	select arm.printed_name
	from AR_CASH_RECEIPTS           ACR,
             AR_RECEIPT_METHODS         ARM
	where ACR.RECEIPT_METHOD_ID = ARM.RECEIPT_METHOD_ID
	and ACR.CASH_RECEIPT_ID = p_rcpt_mthd_id
	and rownum = 1;

  BEGIN
    log('d','Start of Lwx_Data_File_Phase Procedure');
    v_conc_req_id   := TO_NUMBER(fnd_profile.VALUE('CONC_REQUEST_ID'));
    v_f2_line_cnt   := 0;
    v_f3_line_cnt   := 0;
    v_f4_dtl_cnt    := 0;
    v_process_stage := 'Start of F1 Type Header Record Loop...';

    log('l', v_process_stage);

    FOR v_ar_stmt_hdr_f1_rec IN v_ar_stmt_hdr_f1_cur(v_conc_req_id) LOOP

      log('d','Inside v_ar_stmt_hdr_f1_cur: Concurrent Request id: ' ||
                TO_CHAR(v_conc_req_id) || ' Statement Header ID: ' ||
                TO_CHAR(v_ar_stmt_hdr_f1_rec.STMT_HDR_ID));

      IF nvl(v_ar_stmt_hdr_f1_rec.stmt_type,'*') = 'CSV' and v_suppress_csv = 'Y' THEN
        goto skip_for_csv;
      END IF;
      -- Initialize Variables
      v_first_38_sort_key   := NULL;
      v_build_record_fields := NULL;
      v_build_record_line   := NULL;
      v_send_to_postal_cde  := NULL;
      -- ***** Build the F1 Record for the current customer record *****
      -- *** Build Record #1 Line
      v_process_stage := 'Building 38 Character Sort Key for F1 Type Record Line #1.';

      v_send_to_postal_cde := NVL(v_ar_stmt_hdr_f1_rec.SEND_TO_POSTAL_CDE,
                                  '');

      -- Build first 38 character sort portion
      IF v_send_to_postal_cde = '37234' THEN
        v_first_38_sort_key := LPAD('1', 2, ' ');
      ELSE
        v_first_38_sort_key := SUBSTR(v_ar_stmt_hdr_f1_rec.SEND_TO_STATE_CDE,
                                      1,
                                      2);
      END IF;

      v_first_38_sort_key := v_first_38_sort_key ||
                             SUBSTR(v_ar_stmt_hdr_f1_rec.SEND_TO_CUST_NBR,
                                    1,
                                    10);
      v_first_38_sort_key := v_first_38_sort_key || 'F1';
      v_first_38_sort_key := v_first_38_sort_key || '                ';
      v_first_38_sort_key := v_first_38_sort_key || '1';
      v_first_38_sort_key := v_first_38_sort_key || '0000000';
      v_first_38_sort_key := v_first_38_sort_key || '|';
      v_process_stage     := 'Building F1 Type Record Line #1 Field Values ';

      -- Field #1
      v_build_record_fields := LPAD(v_ar_stmt_hdr_f1_rec.PPD_PAGE_CNT,
                                    7,
                                    '0') || '|';

      -- Field #2
      v_build_record_fields := v_build_record_fields ||
                               LPAD(v_ar_stmt_hdr_f1_rec.DTL_PAGE_CNT,
                                    7,
                                    '0') || '|';
      -- Field #3
      v_build_record_fields := v_build_record_fields ||
                               LPAD(v_ar_stmt_hdr_f1_rec.INVO_PAGE_CNT,
                                    7,
                                    '0') || '|';
      -- Field #4
      v_build_record_fields := v_build_record_fields ||
                               LPAD(v_ar_stmt_hdr_f1_rec.TOTAL_PAGE_CNT,
                                    7,
                                    '0') || '|';
      -- Field #5
      v_build_record_fields := v_build_record_fields ||
                               v_ar_stmt_hdr_f1_rec.LOGO_CDE || '|';
      -- Field #6
      v_build_record_fields := v_build_record_fields ||
                               TO_CHAR(v_ar_stmt_hdr_f1_rec.STMT_DTE,
                                       'MM-DD-YY') || '|';
      -- Field #7
      v_build_record_fields := v_build_record_fields ||
                               v_ar_stmt_hdr_f1_rec.SEND_TO_CUST_NBR || '|';
      -- Field #8
      v_build_record_fields := v_build_record_fields ||
                               SUBSTR(v_ar_stmt_hdr_f1_rec.SEND_TO_CUST_NME,
                                      1,
                                      40) || '|';
      IF v_ar_stmt_hdr_f1_rec.cust_email_adr IS NOT NULL AND
         nvl(v_ar_stmt_hdr_f1_rec.stmt_type,'*') <> 'CSV' AND
         instr(v_ar_stmt_hdr_f1_rec.cust_email_adr,'@') > 0 THEN
         v_build_record_fields := v_build_record_fields ||
                                  v_ar_stmt_hdr_f1_rec.cust_email_adr || '|';   
         IF nvl(v_ar_stmt_hdr_f1_rec.invo_page_cnt,0) > 0 THEN
            log('l', '*** Warning: The statement will be emailed, but cust ' || v_ar_stmt_hdr_f1_rec.send_to_cust_nbr || ' has unemailed consolidated invoices.');
         END IF;
      END IF;      

      -- Build Record Line
      v_build_record_line := v_first_38_sort_key || v_build_record_fields;
      -- Write Line of Text to the Output file
      log('o',v_build_record_line);
      log('d',nvl(v_process_stage || v_build_record_line,
                    'v_process_stage||v_build_record_line'));

      -- *** Build Record #2 Line

      -- Reset the Variables with null
      v_first_38_sort_key   := NULL;
      v_build_record_fields := NULL;
      v_build_record_line   := NULL;
      v_process_stage       := 'Building 38 Character Sort Key for F1 Type Record Line #2.';

      -- Build first 38 character sort portion
      IF v_send_to_postal_cde = '37234' THEN
        v_first_38_sort_key := LPAD('1', 2, ' ');
      ELSE
        v_first_38_sort_key := SUBSTR(v_ar_stmt_hdr_f1_rec.SEND_TO_STATE_CDE,
                                      1,
                                      2);
      END IF;

      v_first_38_sort_key := v_first_38_sort_key ||
                             SUBSTR(v_ar_stmt_hdr_f1_rec.SEND_TO_CUST_NBR,
                                    1,
                                    10);
      v_first_38_sort_key := v_first_38_sort_key || 'F1';
      v_first_38_sort_key := v_first_38_sort_key || '                ';
      v_first_38_sort_key := v_first_38_sort_key || '2';
      v_first_38_sort_key := v_first_38_sort_key || '0000000';
      v_first_38_sort_key := v_first_38_sort_key || '|';
      v_process_stage     := 'Building F1 Type Record Line #2 Field Values ';

      -- calling format_address to format the statement send to address:
      v_process_stage := 'Calling Format_Address for F1 Type 2 and 3 address fields.';
      Format_Address(p_addr1       => v_ar_stmt_hdr_f1_rec.send_to_line_1_adr,
                     p_addr2       => v_ar_stmt_hdr_f1_rec.send_to_line_2_adr,
                     p_addr3       => v_ar_stmt_hdr_f1_rec.send_to_line_3_adr,
                     p_addr4       => v_ar_stmt_hdr_f1_rec.send_to_line_4_adr,
                     p_city        => v_ar_stmt_hdr_f1_rec.send_to_city_nme,
                     p_state       => v_ar_stmt_hdr_f1_rec.send_to_state_cde,
                     p_postal_code => v_ar_stmt_hdr_f1_rec.send_to_postal_cde,
                     p_country     => v_ar_stmt_hdr_f1_rec.send_to_cntry_nme,
                     p_out_addr1   => v_out_addr1,
                     p_out_addr2   => v_out_addr2,
                     p_out_addr3   => v_out_addr3,
                     p_out_addr4   => v_out_addr4,
                     p_out_addr5   => v_out_addr5,
                     retcode       => retcode);

      -- Build Record Fields
      -- Field #1 and #2
      v_build_record_fields := v_out_addr1 || '|' || v_out_addr2 || '|';

      -- Build Record Line
      v_build_record_line := v_first_38_sort_key || v_build_record_fields;

      -- Write Line of Text to the Output file
      log('o', v_build_record_line);
      -- *** Build Record #3 Line
      log('d',v_process_stage || v_build_record_line);
      -- Reset the Variables with Null
      v_first_38_sort_key   := NULL;
      v_build_record_fields := NULL;
      v_build_record_line   := NULL;
      v_process_stage       := 'Building 38 Character Sort Key for F1 Type Record Line #3.';

      -- Build first 38 character sort portion
      IF v_send_to_postal_cde = '37234' THEN
        v_first_38_sort_key := LPAD('1', 2, ' ');
      ELSE
        v_first_38_sort_key := SUBSTR(v_ar_stmt_hdr_f1_rec.SEND_TO_STATE_CDE,
                                      1,
                                      2);
      END IF;

      v_first_38_sort_key := v_first_38_sort_key ||
                             SUBSTR(v_ar_stmt_hdr_f1_rec.SEND_TO_CUST_NBR,
                                    1,
                                    10);
      v_first_38_sort_key := v_first_38_sort_key || 'F1';
      v_first_38_sort_key := v_first_38_sort_key || '                ';
      v_first_38_sort_key := v_first_38_sort_key || '3';
      v_first_38_sort_key := v_first_38_sort_key || '0000000';
      v_first_38_sort_key := v_first_38_sort_key || '|';
      v_process_stage     := 'Building F1 Type Record Line #3 Field Values';

      -- Field #1 - 3
      v_build_record_fields := v_out_addr3 || '|' || v_out_addr4 || '|' ||
                               v_out_addr5 || '|';

      -- Build Record Line
      v_build_record_line := v_first_38_sort_key || v_build_record_fields;
      -- Write Line of Text to the Output file
      log('o', v_build_record_line);

      -- *** Build Record #4 Line
      log('d','Building F1 Type Record Line #3 Field Values ' ||
                v_build_record_line);

      -- Reset the Variables with Null
      v_first_38_sort_key   := NULL;
      v_build_record_fields := NULL;
      v_build_record_line   := NULL;
      v_process_stage       := 'Building 38 Character Sort Key for F1 Type Record Line #4.';

      -- Build first 38 character sort portion
      IF v_send_to_postal_cde = '37234' THEN
        v_first_38_sort_key := LPAD('1', 2, ' ');
      ELSE
        v_first_38_sort_key := SUBSTR(v_ar_stmt_hdr_f1_rec.SEND_TO_STATE_CDE,
                                      1,
                                      2);
      END IF;

      v_first_38_sort_key := v_first_38_sort_key ||
                             SUBSTR(v_ar_stmt_hdr_f1_rec.SEND_TO_CUST_NBR,
                                    1,
                                    10);
      v_first_38_sort_key := v_first_38_sort_key || 'F1';
      v_first_38_sort_key := v_first_38_sort_key || '                ';
      v_first_38_sort_key := v_first_38_sort_key || '4';
      v_first_38_sort_key := v_first_38_sort_key || '0000000';
      v_first_38_sort_key := v_first_38_sort_key || '|';
      v_process_stage     := 'Building F1 Type Record Line #4 Field Values ';
      -- Field #1
      v_build_record_fields := v_ar_stmt_hdr_f1_rec.REP_PHONE_NBR || '|';
      -- Field #2
      v_build_record_fields := v_build_record_fields ||
                               trim(to_char(nvl(v_ar_stmt_hdr_f1_rec.OVER_DUE_AMT,
                                                0),
                                            '99999999990.00')) || '|';
      -- Field #3
      v_build_record_fields := v_build_record_fields ||
                               trim(to_char(nvl(v_ar_stmt_hdr_f1_rec.DUE_AMT,
                                                0),
                                            '99999999990.00')) || '|';
      -- Field #4
      v_build_record_fields := v_build_record_fields ||
                               trim(to_char(nvl(v_ar_stmt_hdr_f1_rec.TO_PAY_AMT,
                                                0),
                                            '99999999990.00')) || '|';
      -- Field #5
      v_build_record_fields := v_build_record_fields ||
                               TO_CHAR(v_ar_stmt_hdr_f1_rec.STMT_DUE_DTE,
                                       'MM-DD-YY') || '|';
      -- Field #6
      v_build_record_fields := v_build_record_fields ||
                               trim(to_char(nvl(v_ar_stmt_hdr_f1_rec.NOT_DUE_AMT,
                                                0),
                                            '99999999990.00')) || '|';
      -- Field #7
      v_build_record_fields := v_build_record_fields ||
                               trim(to_char(nvl(v_ar_stmt_hdr_f1_rec.BALANCE_AMT,
                                                0),
                                            '99999999990.00')) || '|';
      -- Build Record Line
      v_build_record_line := v_first_38_sort_key || v_build_record_fields;
      -- Write Line of Text to the Output file
      log('o', v_build_record_line);
      log('d',v_process_stage || v_build_record_line);

      -- *** Build Record #5 Line
      v_process_stage := 'Building 38 Character Sort Key for F1 Type Record Line #5.';
      -- Reset the Variables with Null
      v_first_38_sort_key   := NULL;
      v_build_record_fields := NULL;
      v_build_record_line   := NULL;

      -- Build first 38 character sort portion
      IF v_send_to_postal_cde = '37234' THEN
        v_first_38_sort_key := LPAD('1', 2, ' ');
      ELSE
        v_first_38_sort_key := SUBSTR(v_ar_stmt_hdr_f1_rec.SEND_TO_STATE_CDE,
                                      1,
                                      2);
      END IF;

      v_first_38_sort_key := v_first_38_sort_key ||
                             SUBSTR(v_ar_stmt_hdr_f1_rec.SEND_TO_CUST_NBR,
                                    1,
                                    10);
      v_first_38_sort_key := v_first_38_sort_key || 'F1';
      v_first_38_sort_key := v_first_38_sort_key || '                ';
      v_first_38_sort_key := v_first_38_sort_key || '5';
      v_first_38_sort_key := v_first_38_sort_key || '0000000';
      v_first_38_sort_key := v_first_38_sort_key || '|';
      v_process_stage     := 'Building F1 Type Record Line #5 Field Values ';
      -- Field #1
      v_build_record_fields := v_ar_stmt_hdr_f1_rec.MSG1_NME || '|';
      -- Field #2
      v_build_record_fields := v_build_record_fields ||
                               v_ar_stmt_hdr_f1_rec.MSG2_NME || '|';
      -- Build Record Line
      v_build_record_line := v_first_38_sort_key || v_build_record_fields;
      -- Write Line of Text to the Output file
      log('o', v_build_record_line);
      log('d',v_process_stage || v_build_record_line);
      -- *** Build Record #6 Line
      v_process_stage := 'Building 38 Character Sort Key for F1 Type Record Line #6.';
      -- Reset the Variables with Null
      v_first_38_sort_key   := NULL;
      v_build_record_fields := NULL;
      v_build_record_line   := NULL;

      -- Build first 38 character sort portion
      IF v_send_to_postal_cde = '37234' THEN
        v_first_38_sort_key := LPAD('1', 2, ' ');
      ELSE
        v_first_38_sort_key := SUBSTR(v_ar_stmt_hdr_f1_rec.SEND_TO_STATE_CDE,
                                      1,
                                      2);
      END IF;

      v_first_38_sort_key := v_first_38_sort_key ||
                             SUBSTR(v_ar_stmt_hdr_f1_rec.SEND_TO_CUST_NBR,
                                    1,
                                    10);
      v_first_38_sort_key := v_first_38_sort_key || 'F1';
      v_first_38_sort_key := v_first_38_sort_key || '                ';
      v_first_38_sort_key := v_first_38_sort_key || '6';
      v_first_38_sort_key := v_first_38_sort_key || '0000000';
      v_first_38_sort_key := v_first_38_sort_key || '|';
      v_process_stage     := 'Building F1 Type Record Line #6 Field Values ';

      -- Field #1
      v_build_record_fields := v_ar_stmt_hdr_f1_rec.SCAN_LINE_NME || '|';
      -- Build Record Line
      v_build_record_line := v_first_38_sort_key || v_build_record_fields;
      -- Write Line of Text to the Output file
      log('o', v_build_record_line);
      log('d',v_process_stage || v_build_record_line);
      -- *** Build Record #7 Line
      v_process_stage := 'Building 38 Character Sort Key for F1 Type Record Line #7.';
      -- Reset the Variables with Null
      v_first_38_sort_key   := NULL;
      v_build_record_fields := NULL;
      v_build_record_line   := NULL;

      -- Build first 38 character sort portion
      IF v_send_to_postal_cde = '37234' THEN
        v_first_38_sort_key := LPAD('1', 2, ' ');
      ELSE
        v_first_38_sort_key := SUBSTR(v_ar_stmt_hdr_f1_rec.SEND_TO_STATE_CDE,
                                      1,
                                      2);
      END IF;

      v_first_38_sort_key := v_first_38_sort_key ||
                             SUBSTR(v_ar_stmt_hdr_f1_rec.SEND_TO_CUST_NBR,
                                    1,
                                    10);
      v_first_38_sort_key := v_first_38_sort_key || 'F1';
      v_first_38_sort_key := v_first_38_sort_key || '                ';
      v_first_38_sort_key := v_first_38_sort_key || '7';
      v_first_38_sort_key := v_first_38_sort_key || '0000000';
      v_first_38_sort_key := v_first_38_sort_key || '|';
      v_process_stage     := 'Building F1 Type Record Line #7 Field Values ';
      -- Field #1
      v_build_record_fields := v_ar_stmt_hdr_f1_rec.LW_FAX_NBR || '|';
      -- Field #2
      v_build_record_fields := v_build_record_fields ||
                               v_ar_stmt_hdr_f1_rec.LW_EMAIL_ADR || '|';
      -- Field #3 - 6 
      v_build_record_fields := v_build_record_fields || 'N' || '|' ||                                    -- 1st Indicator
                                                     v_ar_stmt_hdr_f1_rec.WAVE_C_OR_F || '|' ||          -- 2nd Indicator
                                                     v_ar_stmt_hdr_f1_rec.foreign_addr_y_or_n || '|' ||  -- 3rd Indicator
                                                     'N' || '|';                                         -- 4th Indicator
      -- Build Record Line
      v_build_record_line := v_first_38_sort_key || v_build_record_fields;
      -- Write Line of Text to the Output file
      log('o', v_build_record_line);
      log('d',v_process_stage || v_build_record_line);

      -- ***** Count to see if there is any F2 record to be processed:
      v_process_stage := 'Count F2 record for the current statement_hdr_id: ' ||
                         to_char(v_ar_stmt_hdr_f1_rec.STMT_HDR_ID);

      v_f2_rec_count := 0;

      SELECT COUNT(*)
        INTO v_f2_rec_count
        FROM LWX_AR_STMT_LINES
       WHERE STMT_HDR_ID = v_ar_stmt_hdr_f1_rec.STMT_HDR_ID
         AND REC_TYPE_CDE = 'F2';

      -- ***** Build the F2 Record for the Current Customer Record *****
      IF v_f2_rec_count > 0 THEN

        v_process_stage := 'Building 38 Character Sort Key for F2 Type Record Line #1.';
        -- *** Build Record #1 Line

        -- Reset the Variables with Null
        v_first_38_sort_key   := NULL;
        v_build_record_fields := NULL;
        v_build_record_line   := NULL;

        -- Build first 38 character sort portion
        IF v_send_to_postal_cde = '37234' THEN
          v_first_38_sort_key := LPAD('1', 2, ' ');
        ELSE
          v_first_38_sort_key := SUBSTR(v_ar_stmt_hdr_f1_rec.SEND_TO_STATE_CDE,
                                        1,
                                        2);
        END IF;

        v_first_38_sort_key := v_first_38_sort_key ||
                               SUBSTR(v_ar_stmt_hdr_f1_rec.SEND_TO_CUST_NBR,
                                      1,
                                      10);
        v_first_38_sort_key := v_first_38_sort_key || 'F2';
        v_first_38_sort_key := v_first_38_sort_key || '                ';
        v_first_38_sort_key := v_first_38_sort_key || '1';
        v_first_38_sort_key := v_first_38_sort_key || '0000000';
        v_first_38_sort_key := v_first_38_sort_key || '|';

        -- Field #1

        v_process_stage := 'Calculate the Total Page for F2 Record using stmt_hdr_id: ' ||
                           to_char(v_ar_stmt_hdr_f1_rec.stmt_hdr_id);

        SELECT COUNT(*)
          INTO v_f2_total_page
          FROM LWX_AR_STMT_LINES
         WHERE STMT_HDR_ID = v_ar_stmt_hdr_f1_rec.STMT_HDR_ID
           AND INCL_CUR_STMT_IND = 'Y'
           AND REC_TYPE_CDE = 'F2';
        log('l',
                          'F2 Record total page' || v_f2_total_page);

        v_process_stage       := 'Building F2 Type Record Line #1 Field Values ';
        v_build_record_fields := TO_CHAR(FLOOR(v_f2_total_page / 20) + 1) || '|';
        -- Field #2
        v_build_record_fields := v_build_record_fields ||
                                 TO_CHAR(v_f2_total_page) || '|';
        -- Field #3
        v_build_record_fields := v_build_record_fields ||
                                 v_ar_stmt_hdr_f1_rec.LOGO_CDE || '|';
        -- Field #4
        v_build_record_fields := v_build_record_fields ||
                                 to_char(v_ar_stmt_hdr_f1_rec.STMT_DTE,
                                         'MM-DD-YY') || '|';
        -- Field #5
        v_build_record_fields := v_build_record_fields ||
                                 v_ar_stmt_hdr_f1_rec.SEND_TO_CUST_NBR || '|';
        -- Field #6
        v_build_record_fields := v_build_record_fields ||
                                 v_ar_stmt_hdr_f1_rec.SEND_TO_CUST_NME || '|';

        -- Field 7 - 10
        v_process_stage := 'Calling Format_Address for F2 Type 1 Field 7 - 10.';
        Format_Address(v_ar_stmt_hdr_f1_rec.send_to_line_1_adr,
                       v_ar_stmt_hdr_f1_rec.send_to_line_2_adr,
                       v_ar_stmt_hdr_f1_rec.send_to_line_3_adr,
                       v_ar_stmt_hdr_f1_rec.send_to_line_4_adr,
                       v_ar_stmt_hdr_f1_rec.send_to_city_nme,
                       v_ar_stmt_hdr_f1_rec.send_to_state_cde,
                       v_ar_stmt_hdr_f1_rec.send_to_postal_cde,
                       v_ar_stmt_hdr_f1_rec.send_to_cntry_nme,
                       v_out_addr1,
                       v_out_addr2,
                       v_out_addr3,
                       v_out_addr4,
                       v_out_addr5,
                       retcode);

        -- Field #11

        v_build_record_fields := v_build_record_fields || v_out_addr1 || '|' ||
                                 v_out_addr2 || '|' || v_out_addr3 || '|' ||
                                 v_out_addr4 || '|' || v_out_addr5 || '|';

        -- Build Record Line
        v_build_record_line := v_first_38_sort_key || v_build_record_fields;
        -- Write Line of Text to the Output file
        log('o', v_build_record_line);
        log('d','Building F2 Type Record Line #1 Field Values ' ||
                  v_build_record_line);

        v_process_stage := 'Begin F2 Type Record Cursor Loop';
        log('l', v_process_stage);

        -- Open F2 Type Record Cursor Loop
        FOR v_ar_stmt_lines_f2_rec IN v_ar_stmt_lines_f2_cur(v_ar_stmt_hdr_f1_rec.STMT_HDR_ID) LOOP

          log('d','Inside v_ar_stmt_lines_f2_cur: Statement Header id: ' ||
                    v_ar_stmt_hdr_f1_rec.STMT_HDR_ID);
          v_process_stage := 'Building 38 Character Sort Key for F2 Type Record Line #2.';
          -- Build Record #2 line
          -- Increment v_F2_line_cnt by 1
          v_f2_line_cnt := v_f2_line_cnt + 1;
          -- Reset the Variables with Null
          v_first_38_sort_key   := NULL;
          v_build_record_fields := NULL;
          v_build_record_line   := NULL;

          -- Build first 38 character sort portion
          IF v_send_to_postal_cde = '37234' THEN
            v_first_38_sort_key := LPAD('1', 2, ' ');
          ELSE
            v_first_38_sort_key := SUBSTR(v_ar_stmt_hdr_f1_rec.SEND_TO_STATE_CDE,
                                          1,
                                          2);
          END IF;

          v_first_38_sort_key := v_first_38_sort_key ||
                                 SUBSTR(v_ar_stmt_hdr_f1_rec.SEND_TO_CUST_NBR,
                                        1,
                                        10);
          v_first_38_sort_key := v_first_38_sort_key || 'F2';
          v_first_38_sort_key := v_first_38_sort_key || '                ';
          v_first_38_sort_key := v_first_38_sort_key || '2';
          v_first_38_sort_key := v_first_38_sort_key ||
                                 LPAD(v_f2_line_cnt, 7, '0');
          v_first_38_sort_key := v_first_38_sort_key || '|';
          v_process_stage     := 'Building F2 Type Record Line #2 Field Values ';
          -- Field #1
          v_build_record_fields := v_ar_stmt_lines_f2_rec.SPCL_LINE_IND || '|';
          -- Field #2
          v_build_record_fields := v_build_record_fields ||
                                   TO_CHAR(v_ar_stmt_lines_f2_rec.TRANS_DTE,
                                           'MM-DD-YY') || '|';
          -- Field #3
          v_build_record_fields := v_build_record_fields ||
                                   v_ar_stmt_lines_f2_rec.DOC_TYPE_NME || '|';
          -- Field #4
          --          v_build_record_fields := v_build_record_fields ||
          --                                   v_ar_stmt_lines_f2_rec.SLS_CHNL_NME || '|';

          -- Jude Lam 09/26/06 copy the same logic from the F3 section here.
          IF v_ar_stmt_lines_f2_rec.customer_trx_id IS NOT NULL THEN
            -- Check the Batch Source.
            v_process_stage := 'Data_File_Phase: Checking batch source for customer_trx_id for F2: ' ||
                               to_char(v_ar_stmt_lines_f2_rec.customer_trx_id);
            log('d',v_process_stage);

            SELECT RBS.NAME
              INTO v_batch_source_nme
              FROM RA_BATCH_SOURCES RBS, RA_CUSTOMER_TRX RCT
             WHERE RCT.CUSTOMER_TRX_ID =
                   v_ar_stmt_lines_f2_rec.customer_trx_id
               AND RCT.BATCH_SOURCE_ID = RBS.BATCH_SOURCE_ID;

            v_process_stage := 'Data_File_Phase: Batch source name retrieved for customer_trx_id for F2: ' ||
                               to_char(v_ar_stmt_lines_f2_rec.customer_trx_id) ||
                               ' is: ' || v_batch_source_nme;
            log('d',v_process_stage);

            IF v_batch_source_nme = 'JDA_ORA_AR_INVOICES' OR
               v_batch_source_nme = 'D365_ORA_AR_INVOICES' THEN

              -- Pull in the Store Name using ATTRIBUTE9 of the DFF.
              v_store_name := NULL;

              v_process_stage := 'Data_File_Phase: Getting JDA/D365 Store Name using customer_trx_id: ' ||
                                 to_char(v_ar_stmt_lines_f2_rec.customer_trx_id);

              log('d',v_process_stage);

              FOR v_store_det_rec IN v_store_det_cur(v_ar_stmt_lines_f2_rec.customer_trx_id) LOOP
                v_store_name := v_store_det_rec.store_name;
                EXIT;
              END LOOP;

              v_process_stage := 'Data_File_Phase: Store Name retrieved: ' ||
                                 v_store_name;

              v_build_record_fields := v_build_record_fields ||
                                       v_store_name || '|';

            ELSE
	      -- dhoward 18-Mar-08 Payments print payment name
	      IF upper(v_ar_stmt_lines_f2_rec.DOC_TYPE_NME) <> 'PAYMENT' THEN

               IF v_ar_stmt_lines_f2_rec.SLS_CHNL_NME IS NOT NULL THEN

                v_process_stage := 'Retrieve sales channel description using sales channel code: ' ||
                                   v_ar_stmt_lines_f2_rec.sls_chnl_nme;
                BEGIN
                  SELECT substr(ffv.description, 1, 30)
                    INTO v_sls_chnl_desc
                    FROM FND_LOOKUP_VALUES_VL FFV, FND_APPLICATION FA
                   WHERE FFV.LOOKUP_TYPE = 'SALES_CHANNEL'
                     AND FFV.LOOKUP_CODE =
                         v_ar_stmt_lines_f2_rec.sls_chnl_nme
                     AND FFV.VIEW_APPLICATION_ID = FA.APPLICATION_ID
                     AND FA.APPLICATION_SHORT_NAME = 'ONT';

                  v_build_record_fields := v_build_record_fields ||
                                           v_sls_chnl_desc || '|';
                EXCEPTION
                  WHEN NO_DATA_FOUND THEN
                    v_build_record_fields := v_build_record_fields || '|';
                END;
               ELSE
                v_build_record_fields := v_build_record_fields || '|';
               END IF;

	      -- dhoward 18-mar-08 if doc_type_name is payment replace the sales channel
	      ELSIF v_ar_stmt_lines_f2_rec.cash_receipt_id IS NOT NULL and upper(v_ar_stmt_lines_f2_rec.DOC_TYPE_NME) = 'PAYMENT' THEN

                v_process_stage := 'Retrieve receipt method name using cash receipt id: ' ||
                                   to_char(v_ar_stmt_lines_f2_rec.cash_receipt_id);

                BEGIN
		  -- dhoward 03/04/08 - Replaced sales channel name with method printed name
		  OPEN v_rcpt_prnt_nme_cur (v_ar_stmt_lines_f2_rec.cash_receipt_id);
		  FETCH v_rcpt_prnt_nme_cur INTO v_pymt_name;
		  CLOSE v_rcpt_prnt_nme_cur;

		  if v_sls_chnl_desc is not null then

                  	v_build_record_fields := v_build_record_fields ||
                                           v_sls_chnl_desc || '|';
		  else

                    	v_build_record_fields := v_build_record_fields || '|';
		  end if;
                END;
	      ELSE
                	v_build_record_fields := v_build_record_fields || '|';

              END IF;

            END IF; -- End of checking v_batch_source_nme.
          ELSIF v_ar_stmt_lines_f2_rec.customer_trx_id IS NULL AND
                v_ar_stmt_lines_f2_rec.cash_receipt_id IS NOT NULL THEN
	    -- dhoward 03/17/08 - Replaced sales channel name with method printed name
	    OPEN v_rcpt_prnt_nme_cur (v_ar_stmt_lines_f2_rec.cash_receipt_id);
	    FETCH v_rcpt_prnt_nme_cur INTO v_pymt_name;
	    CLOSE v_rcpt_prnt_nme_cur;
	    if v_pymt_name is not null then
            	v_build_record_fields := v_build_record_fields ||
                                     v_pymt_name || '|';
	    else
		v_build_record_fields := v_build_record_fields ||
                                     'Pmt for Stmt|';
	    end if;
	    v_pymt_name := null;
          ELSE
            v_build_record_fields := v_build_record_fields || '|';
          END IF; -- End of checking customer_trx_id

          -- Field #5
          v_build_record_fields := v_build_record_fields ||
                                   v_ar_stmt_lines_f2_rec.CUST_REF_NME || '|';
          -- Field #6  05/03/06 Jude Lam update, simply use the value from the cursor.
          v_build_record_fields := v_build_record_fields ||
                                   v_ar_stmt_lines_f2_rec.fut_pmt_ind || '|';

          --  Field #7
          v_build_record_fields := v_build_record_fields ||
                                   v_ar_stmt_lines_f2_rec.partial_pmt_ind || '|';

          -- Field #8
          v_build_record_fields := v_build_record_fields ||
                                   TO_CHAR(v_ar_stmt_lines_f2_rec.DUE_DTE,
                                           'MM-DD-YY') || '|';
          -- Field #9
          v_build_record_fields := v_build_record_fields ||
                                   v_ar_stmt_lines_f2_rec.TRANS_NBR || '|';
          -- Field #10
          v_build_record_fields := v_build_record_fields ||
                                   trim(to_char(v_ar_stmt_lines_f2_rec.ORIG_AMT,
                                                '99999999990.00')) || '|';
          -- Field #11
          v_build_record_fields := v_build_record_fields ||
                                   trim(to_char(v_ar_stmt_lines_f2_rec.OUTSTND_AMT,
                                                '99999999990.00')) || '|';
          -- Build Record Line
          v_build_record_line := v_first_38_sort_key ||
                                 v_build_record_fields;
          -- Write Line of Text to the Output file
          log('o', v_build_record_line);
          log('d',v_process_stage || v_build_record_line);

        END LOOP; -- End of Line F2 Type Record Cursor Loop

      END IF; -- End of v_f2_rec_count check.

      -- ***** Build the F3 Record for the Current Customer Record *****
      v_process_stage := 'Building 38 Character Sort Key for F3 Type Record Line #1.';
      -- *** Build Record #1 Line

      -- Reset the Variables with Null
      v_first_38_sort_key   := NULL;
      v_build_record_fields := NULL;
      v_build_record_line   := NULL;

      -- Build first 38 character sort portion
      IF v_send_to_postal_cde = '37234' THEN
        v_first_38_sort_key := LPAD('1', 2, ' ');
      ELSE
        v_first_38_sort_key := SUBSTR(v_ar_stmt_hdr_f1_rec.SEND_TO_STATE_CDE,
                                      1,
                                      2);
      END IF;

      v_first_38_sort_key := v_first_38_sort_key ||
                             SUBSTR(v_ar_stmt_hdr_f1_rec.SEND_TO_CUST_NBR,
                                    1,
                                    10);
      v_first_38_sort_key := v_first_38_sort_key || 'F3';
      v_first_38_sort_key := v_first_38_sort_key || '                ';
      v_first_38_sort_key := v_first_38_sort_key || '1';
      v_first_38_sort_key := v_first_38_sort_key || '0000000';
      v_first_38_sort_key := v_first_38_sort_key || '|';
      -- Field #1
      -- Calcualte the Total Page for F3 Record
      v_process_stage := ' Calculate the Total Page for F3 Record using stmt_hdr_id: ' ||
                         to_char(v_ar_stmt_hdr_f1_rec.stmt_hdr_id);

      SELECT COUNT(*)
        INTO v_f3_total_page
        FROM LWX_AR_STMT_LINES
       WHERE STMT_HDR_ID = v_ar_stmt_hdr_f1_rec.STMT_HDR_ID
         AND INCL_CUR_STMT_IND = 'Y'
         AND REC_TYPE_CDE = 'F3'; -- Jude Lam 05/03/06 update for bug fix.

      v_process_stage := 'Building F3 Type Record Line #1 Field Values ';
      log('d','F3 Record total page' || v_f3_total_page);

      v_build_record_fields := TO_CHAR(FLOOR(v_f3_total_page / 20) + 1) || '|';
      -- Field #2
      v_build_record_fields := v_build_record_fields || v_f3_total_page || '|';
      -- Field #3
      v_build_record_fields := v_build_record_fields ||
                               v_ar_stmt_hdr_f1_rec.LOGO_CDE || '|';
      -- Field #4
      v_build_record_fields := v_build_record_fields ||
                               to_char(v_ar_stmt_hdr_f1_rec.STMT_DTE,
                                       'MM-DD-YY') || '|';
      -- Field #5
      v_build_record_fields := v_build_record_fields ||
                               v_ar_stmt_hdr_f1_rec.SEND_TO_CUST_NBR || '|';
      -- Field #6
      v_build_record_fields := v_build_record_fields ||
                               v_ar_stmt_hdr_f1_rec.SEND_TO_CUST_NME || '|';

      -- Field 7 - 10
      v_process_stage := 'Calling Format_Address for F3 Type 1 Field 7 - 10.';
      Format_Address(v_ar_stmt_hdr_f1_rec.send_to_line_1_adr,
                     v_ar_stmt_hdr_f1_rec.send_to_line_2_adr,
                     v_ar_stmt_hdr_f1_rec.send_to_line_3_adr,
                     v_ar_stmt_hdr_f1_rec.send_to_line_4_adr,
                     v_ar_stmt_hdr_f1_rec.send_to_city_nme,
                     v_ar_stmt_hdr_f1_rec.send_to_state_cde,
                     v_ar_stmt_hdr_f1_rec.send_to_postal_cde,
                     v_ar_stmt_hdr_f1_rec.send_to_cntry_nme,
                     v_out_addr1,
                     v_out_addr2,
                     v_out_addr3,
                     v_out_addr4,
                     v_out_addr5,
                     retcode);

      -- Field #11
      v_build_record_fields := v_build_record_fields || v_out_addr1 || '|' ||
                               v_out_addr2 || '|' || v_out_addr3 || '|' ||
                               v_out_addr4 || '|' || v_out_addr5 || '|';

      -- Build Record Line
      v_build_record_line := v_first_38_sort_key || v_build_record_fields;

      -- Write Line of Text to the Output file
      log('o', v_build_record_line);
      log('l',v_process_stage || v_build_record_line);
      log('d','Begin F3 Type Record Cursor Loop.');

      -- Open F3 Type Record Cursor Loop
      FOR v_ar_stmt_lines_f3_rec IN v_ar_stmt_lines_f3_cur(v_ar_stmt_hdr_f1_rec.STMT_HDR_ID) LOOP
        log('d','Inside v_ar_stmt_lines_f3_cur: Statement Header id: ' ||
                  v_ar_stmt_hdr_f1_rec.STMT_HDR_ID);
        v_process_stage := 'Building 38 Character Sort Key for F3 Type Record Line #2.';
        log('l', v_process_stage);
        -- Build Record #2 line
        -- Increment v_F3_line_cnt by 1
        v_f3_line_cnt := v_f3_line_cnt + 1;
        -- Reset the Variables with Null
        v_first_38_sort_key   := NULL;
        v_build_record_fields := NULL;
        v_build_record_line   := NULL;

        -- Build first 38 character sort portion
        IF v_send_to_postal_cde = '37234' THEN
          v_first_38_sort_key := LPAD('1', 2, ' ');
        ELSE
          v_first_38_sort_key := SUBSTR(v_ar_stmt_hdr_f1_rec.SEND_TO_STATE_CDE,
                                        1,
                                        2);
        END IF;

        v_first_38_sort_key := v_first_38_sort_key ||
                               SUBSTR(v_ar_stmt_hdr_f1_rec.SEND_TO_CUST_NBR,
                                      1,
                                      10);
        v_first_38_sort_key := v_first_38_sort_key || 'F3';
        v_first_38_sort_key := v_first_38_sort_key || '                ';
        v_first_38_sort_key := v_first_38_sort_key || '2';
        v_first_38_sort_key := v_first_38_sort_key ||
                               LPAD(v_f3_line_cnt, 7, '0');
        v_first_38_sort_key := v_first_38_sort_key || '|';
        v_process_stage     := 'Building F3 Type Record Line #2 Field Values ';
        -- Field #1
        v_build_record_fields := v_ar_stmt_lines_f3_rec.SPCL_LINE_IND || '|';
        -- Field #2
        v_build_record_fields := v_build_record_fields ||
                                 TO_CHAR(v_ar_stmt_lines_f3_rec.TRANS_DTE,
                                         'MM-DD-YY') || '|';
        -- Field #3
        v_build_record_fields := v_build_record_fields ||
                                 v_ar_stmt_lines_f3_rec.DOC_TYPE_NME || '|';
        -- Field #4
        -- Jude Lam 09/07/06 Update to add the logic to put in store number for JDA invoices.
        IF v_ar_stmt_lines_f3_rec.customer_trx_id IS NOT NULL THEN
          -- Check the Batch Source.
          v_process_stage := 'Data_File_Phase: Checking batch source for customer_trx_id: ' ||
                             to_char(v_ar_stmt_lines_f3_rec.customer_trx_id);
          log('d',v_process_stage);

          SELECT RBS.NAME
            INTO v_batch_source_nme
            FROM RA_BATCH_SOURCES RBS, RA_CUSTOMER_TRX RCT
           WHERE RCT.CUSTOMER_TRX_ID =
                 v_ar_stmt_lines_f3_rec.customer_trx_id
             AND RCT.BATCH_SOURCE_ID = RBS.BATCH_SOURCE_ID;

          v_process_stage := 'Data_File_Phase: Batch source name retrieved for customer_trx_id: ' ||
                             to_char(v_ar_stmt_lines_f3_rec.customer_trx_id) ||
                             ' is: ' || v_batch_source_nme;
          log('d',v_process_stage);

          IF v_batch_source_nme = 'JDA_ORA_AR_INVOICES' OR
             v_batch_source_nme = 'D365_ORA_AR_INVOICES' THEN

            -- Pull in the Store Name using ATTRIBUTE9 of the DFF.
            v_store_name := NULL;

            v_process_stage := 'Data_File_Phase: Getting JDA/D365 Store Name using customer_trx_id: ' ||
                               to_char(v_ar_stmt_lines_f3_rec.customer_trx_id);

            log('d',v_process_stage);

            FOR v_store_det_rec IN v_store_det_cur(v_ar_stmt_lines_f3_rec.customer_trx_id) LOOP
              v_store_name := v_store_det_rec.store_name;
              EXIT;
            END LOOP;

            v_process_stage := 'Data_File_Phase: Store Name retrieved: ' ||
                               v_store_name;

            v_build_record_fields := v_build_record_fields || v_store_name || '|';

          ELSE
	    -- dhoward 18-Mar-08 Payments print payment name
	    if upper(v_ar_stmt_lines_f3_rec.DOC_TYPE_NME) <> 'PAYMENT' THEN

             IF v_ar_stmt_lines_f3_rec.SLS_CHNL_NME IS NOT NULL THEN

              v_process_stage := 'Retrieve sales channel description using sales channel code: ' ||
                                 v_ar_stmt_lines_f3_rec.sls_chnl_nme;

              BEGIN
                SELECT substr(ffv.description, 1, 30)
                  INTO v_sls_chnl_desc
                  FROM FND_LOOKUP_VALUES_VL FFV, FND_APPLICATION FA
                 WHERE FFV.LOOKUP_TYPE = 'SALES_CHANNEL'
                   AND FFV.LOOKUP_CODE =
                       v_ar_stmt_lines_f3_rec.sls_chnl_nme
                   AND FFV.VIEW_APPLICATION_ID = FA.APPLICATION_ID
                   AND FA.APPLICATION_SHORT_NAME = 'ONT';

                v_build_record_fields := v_build_record_fields ||
                                         v_sls_chnl_desc || '|';
              EXCEPTION
                WHEN NO_DATA_FOUND THEN
                  v_build_record_fields := v_build_record_fields || '|';
              END;
             ELSE
                  v_build_record_fields := v_build_record_fields || '|';
             END IF;


	    -- dhoward 18-mar-08 if doc_type_name is payment replace the sales channel
	    elsif v_ar_stmt_lines_f3_rec.cash_receipt_id IS NOT NULL and upper(v_ar_stmt_lines_f3_rec.DOC_TYPE_NME) = 'PAYMENT' THEN

                v_process_stage := 'Retrieve receipt method name using cash receipt id: ' ||
                                   to_char(v_ar_stmt_lines_f3_rec.cash_receipt_id);

                BEGIN
		  -- dhoward 03/04/08 - Replaced sales channel name with method printed name
		  OPEN v_rcpt_prnt_nme_cur (v_ar_stmt_lines_f3_rec.cash_receipt_id);
		  FETCH v_rcpt_prnt_nme_cur INTO v_sls_chnl_desc;
		  CLOSE v_rcpt_prnt_nme_cur;

		  if v_sls_chnl_desc is not null then

                  	v_build_record_fields := v_build_record_fields ||
                                           v_sls_chnl_desc || '|';
		  else

                    	v_build_record_fields := v_build_record_fields || '|';
		  end if;
                END;
	      ELSE
                  v_build_record_fields := v_build_record_fields || '|';
              END IF;

          END IF; -- End of checking v_batch_source_nme.

        ELSIF v_ar_stmt_lines_f3_rec.customer_trx_id IS NULL AND
              v_ar_stmt_lines_f3_rec.cash_receipt_id IS NOT NULL THEN
	  -- dhoward 03/17/08 - Replaced sales channel name with method printed name
	    OPEN v_rcpt_prnt_nme_cur (v_ar_stmt_lines_f3_rec.cash_receipt_id);
	    FETCH v_rcpt_prnt_nme_cur INTO v_pymt_name;
	    CLOSE v_rcpt_prnt_nme_cur;
	    if v_pymt_name is not null then
            	v_build_record_fields := v_build_record_fields ||
                                     v_pymt_name || '|';
	    else
          	v_build_record_fields := v_build_record_fields || 'Pmt for Stmt|';
	    end if;
	    v_pymt_name := null;
        ELSE
          v_build_record_fields := v_build_record_fields || '|';
        END IF; -- End of checking customer_trx_id
        -- Field #5
        v_build_record_fields := v_build_record_fields ||
                                 v_ar_stmt_lines_f3_rec.CUST_REF_NME || '|';
        -- Field #6 05/03/06 Jude Lam simply use the value from the cursor.
        v_build_record_fields := v_build_record_fields ||
                                 v_ar_stmt_lines_f3_rec.fut_pmt_ind || '|';

        -- Field #7
        v_build_record_fields := v_build_record_fields ||
                                 v_ar_stmt_lines_f3_rec.partial_pmt_ind || '|';

        -- Field #8
        v_build_record_fields := v_build_record_fields ||
                                 TO_CHAR(v_ar_stmt_lines_f3_rec.DUE_DTE,
                                         'MM-DD-YY') || '|';
        -- Field #9
        v_build_record_fields := v_build_record_fields ||
                                 v_ar_stmt_lines_f3_rec.TRANS_NBR || '|';
        -- Field #10
        v_build_record_fields := v_build_record_fields ||
                                 trim(to_char(v_ar_stmt_lines_f3_rec.ORIG_AMT,
                                              '99999999990.00')) || '|';
        -- Field #11
        v_build_record_fields := v_build_record_fields ||
                                 trim(to_char(v_ar_stmt_lines_f3_rec.OUTSTND_AMT,
                                              '99999999990.00')) || '|';
        -- Build Record Line
        v_build_record_line := v_first_38_sort_key || v_build_record_fields;
        -- Write Line of Text to the Output file
        log('o', v_build_record_line);
        log('d',v_process_stage || v_build_record_line);
      END LOOP; -- End of Line F3 Type Record Cursor Loop

      -- ***** Build the F4 Record for the Current Customer Record *****
      v_process_stage := 'Begin F4 Type Record Cursor Loop.';
      log('d',v_process_stage);

      -- Open F4 Type Record Cursor Loop
      FOR v_ar_stmt_hdr_f4_rec IN v_ar_stmt_hdr_f4_cur(v_ar_stmt_hdr_f1_rec.STMT_HDR_ID) LOOP

        log('d','Inside v_ar_stmt_hdr_f4_cur: Statement Header id: ' ||
                  v_ar_stmt_hdr_f1_rec.STMT_HDR_ID);

        v_process_stage := 'Building 38 Character Sort Key for F4 Type Record Line #1.';

        log('d',v_process_stage);

        IF v_ar_stmt_hdr_f4_rec.cash_receipt_id IS NOT NULL THEN
		-- dhoward 03/04/08 - Replaced sales channel name with method printed name
		OPEN v_rcpt_prnt_nme_cur (v_ar_stmt_hdr_f4_rec.cash_receipt_id);
		FETCH v_rcpt_prnt_nme_cur INTO v_rec_prnt_nme;
		CLOSE v_rcpt_prnt_nme_cur;
        else
	        v_rec_prnt_nme := null;

	end if;

        -- Reset the Variables with Null
        v_first_38_sort_key   := NULL;
        v_build_record_fields := NULL;
        v_build_record_line   := NULL;

        -- Build Record #1 Line

        -- Build First 38 Character Sort Portion
        IF v_send_to_postal_cde = '37234' THEN
          v_first_38_sort_key := LPAD('1', 2, ' ');
        ELSE
          v_first_38_sort_key := SUBSTR(v_ar_stmt_hdr_f1_rec.SEND_TO_STATE_CDE,
                                        1,
                                        2);
        END IF;

        v_first_38_sort_key := v_first_38_sort_key ||
                               SUBSTR(v_ar_stmt_hdr_f1_rec.SEND_TO_CUST_NBR,
                                      1,
                                      10);
        v_first_38_sort_key := v_first_38_sort_key || 'F4';
        v_first_38_sort_key := v_first_38_sort_key ||
                               TO_CHAR(v_ar_stmt_hdr_f4_rec.TRANS_DTE,
                                       'MM-DD-YY');
        v_first_38_sort_key := v_first_38_sort_key ||
                               lpad(SUBSTR(v_ar_stmt_hdr_f4_rec.TRANS_NBR,
                                           1,
                                           8),
                                    8,
                                    ' ');
        v_first_38_sort_key := v_first_38_sort_key || '1';
        v_first_38_sort_key := v_first_38_sort_key || '0000000';
        v_first_38_sort_key := v_first_38_sort_key || '|';
        v_process_stage     := 'Building F4 Type Record Line #1 Field Values ';
        -- Field #1
        v_build_record_fields := TO_CHAR(v_ar_stmt_hdr_f4_rec.PAGE_CNT) || '|';
        -- Field #2
        v_build_record_fields := v_build_record_fields ||
                                 TO_CHAR(v_ar_stmt_hdr_f4_rec.LINE_CNT) || '|';
        -- Field #3
        v_build_record_fields := v_build_record_fields ||
                                 v_ar_stmt_hdr_f4_rec.LOGO_CDE || '|';
        -- Field #4
        v_build_record_fields := v_build_record_fields ||
                                 v_ar_stmt_hdr_f4_rec.DOC_TITLE_NME || '|';
        -- Field #5
        v_build_record_fields := v_build_record_fields ||
                                 v_ar_stmt_hdr_f4_rec.REP_MSG_NME || '|';
        -- Build Record Line
        v_build_record_line := v_first_38_sort_key || v_build_record_fields;
        -- Write Line of Text to the Output file
        log('o', v_build_record_line);
        log('d',v_process_stage || v_build_record_line);
        -- Build Record #2 Line
        v_process_stage := 'Building 38 Character Sort Key for F4 Type Record Line #2.';
        -- Reset the Variables with Null
        v_first_38_sort_key   := NULL;
        v_build_record_fields := NULL;
        v_build_record_line   := NULL;

        -- Build First 38 Character Sort Portion
        IF v_send_to_postal_cde = '37234' THEN
          v_first_38_sort_key := LPAD('1', 2, ' ');
        ELSE
          v_first_38_sort_key := SUBSTR(v_ar_stmt_hdr_f1_rec.SEND_TO_STATE_CDE,
                                        1,
                                        2);
        END IF;

        v_first_38_sort_key := v_first_38_sort_key ||
                               SUBSTR(v_ar_stmt_hdr_f1_rec.SEND_TO_CUST_NBR,
                                      1,
                                      10);
        v_first_38_sort_key := v_first_38_sort_key || 'F4';
        v_first_38_sort_key := v_first_38_sort_key ||
                               TO_CHAR(v_ar_stmt_hdr_f4_rec.TRANS_DTE,
                                       'MM-DD-YY');
        v_first_38_sort_key := v_first_38_sort_key ||
                               lpad(SUBSTR(v_ar_stmt_hdr_f4_rec.TRANS_NBR,
                                           1,
                                           8),
                                    8,
                                    ' ');
        v_first_38_sort_key := v_first_38_sort_key || '2';
        v_first_38_sort_key := v_first_38_sort_key || '0000000';
        v_first_38_sort_key := v_first_38_sort_key || '|';
        v_process_stage     := 'Building F4 Type Record Line #2 Field Values ';
        -- Field #1
        v_build_record_fields := SUBSTR(v_ar_stmt_hdr_f4_rec.SHIP_TO_CUST_NME,
                                        1,
                                        50) || '|';

        -- Field #2 - 5
        v_process_stage := 'Calling Format_Address for F4 Type 2 Field 2 - 5.';
        Format_Address(v_ar_stmt_hdr_f4_rec.ship_to_line_1_adr,
                       v_ar_stmt_hdr_f4_rec.ship_to_line_2_adr,
                       v_ar_stmt_hdr_f4_rec.ship_to_line_3_adr,
                       v_ar_stmt_hdr_f4_rec.ship_to_line_4_adr,
                       v_ar_stmt_hdr_f4_rec.ship_to_city_nme,
                       v_ar_stmt_hdr_f4_rec.ship_to_state_cde,
                       v_ar_stmt_hdr_f4_rec.ship_to_postal_cde,
                       v_ar_stmt_hdr_f4_rec.ship_to_cntry_nme,
                       v_out_addr1,
                       v_out_addr2,
                       v_out_addr3,
                       v_out_addr4,
                       v_out_addr5,
                       retcode);

        -- Field #6
        -- Assign the Territory Short Name

        v_build_record_fields := v_build_record_fields || v_out_addr1 || '|' ||
                                 v_out_addr2 || '|' || v_out_addr3 || '|' ||
                                 v_out_addr4 || '|' || v_out_addr5 || '|';

        -- Build Record Line
        v_build_record_line := v_first_38_sort_key || v_build_record_fields;
        -- Write Line of Text to the Output file
        log('o', v_build_record_line);
        log('d',v_process_stage || v_build_record_line);
        v_process_stage := 'Building 38 Character Sort Key for F4 Type Record Line #3.';
        log('d',v_process_stage);
        -- Build Record #3 Line

        -- Reset the Variables with Null
        v_first_38_sort_key   := NULL;
        v_build_record_fields := NULL;
        v_build_record_line   := NULL;

        -- Build First 38 Character Sort Portion
        IF v_send_to_postal_cde = '37234' THEN
          v_first_38_sort_key := LPAD('1', 2, ' ');
        ELSE
          v_first_38_sort_key := SUBSTR(v_ar_stmt_hdr_f1_rec.SEND_TO_STATE_CDE,
                                        1,
                                        2);
        END IF;

        v_first_38_sort_key := v_first_38_sort_key ||
                               SUBSTR(v_ar_stmt_hdr_f1_rec.SEND_TO_CUST_NBR,
                                      1,
                                      10);
        v_first_38_sort_key := v_first_38_sort_key || 'F4';
        v_first_38_sort_key := v_first_38_sort_key ||
                               TO_CHAR(v_ar_stmt_hdr_f4_rec.TRANS_DTE,
                                       'MM-DD-YY');
        v_first_38_sort_key := v_first_38_sort_key ||
                               lpad(SUBSTR(v_ar_stmt_hdr_f4_rec.TRANS_NBR,
                                           1,
                                           8),
                                    8,
                                    ' ');
        v_first_38_sort_key := v_first_38_sort_key || '3';
        v_first_38_sort_key := v_first_38_sort_key || '0000000';
        v_first_38_sort_key := v_first_38_sort_key || '|';
        v_process_stage     := 'Building F4 Type Record Line #3 Field Values ';
        -- Field #1
        v_build_record_fields := SUBSTR(v_ar_stmt_hdr_f4_rec.BILL_TO_CUST_NME,
                                        1,
                                        50) || '|';

        -- Field #2 - 5
        v_process_stage := 'Calling Format_Address for F4 Type 3 Field 2 - 5.';
        Format_Address(v_ar_stmt_hdr_f4_rec.bill_to_line_1_adr,
                       v_ar_stmt_hdr_f4_rec.bill_to_line_2_adr,
                       v_ar_stmt_hdr_f4_rec.bill_to_line_3_adr,
                       v_ar_stmt_hdr_f4_rec.bill_to_line_4_adr,
                       v_ar_stmt_hdr_f4_rec.bill_to_city_nme,
                       v_ar_stmt_hdr_f4_rec.bill_to_state_cde,
                       v_ar_stmt_hdr_f4_rec.bill_to_postal_cde,
                       v_ar_stmt_hdr_f4_rec.bill_to_cntry_nme,
                       v_out_addr1,
                       v_out_addr2,
                       v_out_addr3,
                       v_out_addr4,
                       v_out_addr5,
                       retcode);

        v_build_record_fields := v_build_record_fields || v_out_addr1 || '|' ||
                                 v_out_addr2 || '|' || v_out_addr3 || '|' ||
                                 v_out_addr4 || '|' || v_out_addr5 || '|';

        -- Build Record Line
        v_build_record_line := v_first_38_sort_key || v_build_record_fields;
        -- Write Line of Text to the Output file
        log('o', v_build_record_line);
        log('d',v_process_stage || v_build_record_line);

        v_process_stage := 'Building 38 Character Sort Key for F4 Type Record Line #4.';
        -- Build Record #4 Line

        -- Reset the Variables with Null
        v_first_38_sort_key   := NULL;
        v_build_record_fields := NULL;
        v_build_record_line   := NULL;

        -- Build First 38 Character Sort Portion
        IF v_send_to_postal_cde = '37234' THEN
          v_first_38_sort_key := LPAD('1', 2, ' ');
        ELSE
          v_first_38_sort_key := SUBSTR(v_ar_stmt_hdr_f1_rec.SEND_TO_STATE_CDE,
                                        1,
                                        2);
        END IF;

        v_first_38_sort_key := v_first_38_sort_key ||
                               SUBSTR(v_ar_stmt_hdr_f1_rec.SEND_TO_CUST_NBR,
                                      1,
                                      10);
        v_first_38_sort_key := v_first_38_sort_key || 'F4';
        v_first_38_sort_key := v_first_38_sort_key ||
                               TO_CHAR(v_ar_stmt_hdr_f4_rec.TRANS_DTE,
                                       'MM-DD-YY');
        v_first_38_sort_key := v_first_38_sort_key ||
                               lpad(SUBSTR(v_ar_stmt_hdr_f4_rec.TRANS_NBR,
                                           1,
                                           8),
                                    8,
                                    ' ');
        v_first_38_sort_key := v_first_38_sort_key || '4';
        v_first_38_sort_key := v_first_38_sort_key || '0000000';
        v_first_38_sort_key := v_first_38_sort_key || '|';

        -- Field #1
        v_process_stage       := 'Building F4 Type Record Line #4 Field Values ';

	-- dhoward 03/04/08 - Replaced sales channel name with method printed name for payments
        if upper(v_ar_stmt_hdr_f4_rec.DOC_TITLE_NME) <> 'PAYMENT' then
        	v_build_record_fields := v_ar_stmt_hdr_f4_rec.sls_chnl_nme || '|';
	else
		if v_rec_prnt_nme is not null then
			v_build_record_fields := v_rec_prnt_nme || '|';
		else
			v_build_record_fields := '|';
		end if;
	end if;

        -- Field #2
        v_build_record_fields := v_build_record_fields ||
                                 v_ar_stmt_hdr_f4_rec.TERM_MSG1_NME || '|';
        -- Field #3
        v_build_record_fields := v_build_record_fields ||
                                 v_ar_stmt_hdr_f4_rec.TERM_MSG2_NME || '|';
        -- Field #4
        v_build_record_fields := v_build_record_fields ||
                                 SUBSTR(v_ar_stmt_hdr_f4_rec.CUST_CONT_NME,
                                        1,
                                        50) || '|';
        -- Field #5
        v_build_record_fields := v_build_record_fields ||
                                 SUBSTR(v_ar_stmt_hdr_f4_rec.CUST_CONT_PHONE_NBR,
                                        1,
                                        15) || '|';
        -- Build Record Line
        v_build_record_line := v_first_38_sort_key || v_build_record_fields;
        -- Write Line of Text to the Output file
        log('o', v_build_record_line);
        log('d',v_process_stage || v_build_record_line);
        -- Build Record #5 Line
        v_process_stage := 'Building 38 Character Sort Key for F4 Type Record Line #5.';
        -- Reset the Variables with Null
        v_first_38_sort_key   := NULL;
        v_build_record_fields := NULL;
        v_build_record_line   := NULL;

        -- Build First 38 Character Sort Portion
        IF v_send_to_postal_cde = '37234' THEN
          v_first_38_sort_key := LPAD('1', 2, ' ');
        ELSE
          v_first_38_sort_key := SUBSTR(v_ar_stmt_hdr_f1_rec.SEND_TO_STATE_CDE,
                                        1,
                                        2);
        END IF;

        v_first_38_sort_key := v_first_38_sort_key ||
                               SUBSTR(v_ar_stmt_hdr_f1_rec.SEND_TO_CUST_NBR,
                                      1,
                                      10);
        v_first_38_sort_key := v_first_38_sort_key || 'F4';
        v_first_38_sort_key := v_first_38_sort_key ||
                               TO_CHAR(v_ar_stmt_hdr_f4_rec.TRANS_DTE,
                                       'MM-DD-YY');
        v_first_38_sort_key := v_first_38_sort_key ||
                               lpad(SUBSTR(v_ar_stmt_hdr_f4_rec.TRANS_NBR,
                                           1,
                                           8),
                                    8,
                                    ' ');
        v_first_38_sort_key := v_first_38_sort_key || '5';
        v_first_38_sort_key := v_first_38_sort_key || '0000000';
        v_first_38_sort_key := v_first_38_sort_key || '|';
        v_process_stage     := 'Building F4 Type Record Line #5 Field Values ';
        -- Field #1
        v_build_record_fields := v_ar_stmt_hdr_f4_rec.TRANS_NBR || '|';

        -- Jude Lam 05/02/06 for Field #2 and #3.
        IF v_ar_stmt_hdr_f4_rec.BILL_TO_CUST_NBR =
           nvl(v_ar_stmt_hdr_f4_rec.SHIP_TO_CUST_NBR, '-999') OR
           v_ar_stmt_hdr_f4_rec.SHIP_TO_CUST_NBR IS NULL THEN
          -- If bill-to and ship-to customer number is the same, just put in bill-to in field #2 and skip #3.
          v_build_record_fields := v_build_record_fields ||
                                   v_ar_stmt_hdr_f4_rec.BILL_TO_CUST_NBR || '||';
        ELSE
          v_build_record_fields := v_build_record_fields ||
                                   v_ar_stmt_hdr_f4_rec.BILL_TO_CUST_NBR || '/|' ||
                                   v_ar_stmt_hdr_f4_rec.SHIP_TO_CUST_NBR || '|';
        END IF;

        -- Field #4
        v_build_record_fields := v_build_record_fields ||
                                 TO_CHAR(v_ar_stmt_hdr_f4_rec.TRANS_DTE,
                                         'MM-DD-YY') || '|';
        -- Field #5
        v_build_record_fields := v_build_record_fields ||
                                 v_ar_stmt_hdr_f4_rec.CUST_REF_NME || '|';
        -- Field #6
        v_build_record_fields := v_build_record_fields ||
                                 TO_CHAR(v_ar_stmt_hdr_f4_rec.ORDER_DTE,
                                         'MM-DD-YY') || '|';
        -- Field #7
        v_build_record_fields := v_build_record_fields ||
                                 v_ar_stmt_hdr_f4_rec.SHIP_METH_NME || '|';
        -- Field #8
        v_build_record_fields := v_build_record_fields || '|';
        -- Build Record Line
        v_build_record_line := v_first_38_sort_key || v_build_record_fields;
        -- Write Line of Text to the Output file
        log('o', v_build_record_line);
        log('d',v_process_stage || v_build_record_line);
        log('d','Begin F4 Type Line #6 Record Cursor Loop.');

        -- Build Record #6 Line

        -- Reset v_f4_dtl_cnt variable.

        v_f4_dtl_cnt := 0;

        -- Open the F4 Type Record Detail Lines Cursor
        FOR v_ar_stmt_dtl_f4_rec IN v_ar_stmt_dtl_f4_cur(v_ar_stmt_hdr_f4_rec.STMT_LINE_ID) LOOP

          -- Jude Lam 06/20/06 Added the check to see if the current line needs to be displayed.
          IF check_display(v_ar_stmt_dtl_f4_rec.customer_trx_line_id) THEN
            log('d','Inside v_ar_stmt_dtl_f4_cur: Statement Line id: ' ||
                      v_ar_stmt_hdr_f4_rec.STMT_LINE_ID);
            -- Increment v_F3_line_cnt by 1
            v_f4_dtl_cnt := v_f4_dtl_cnt + 1;
            -- Reset the Variables with Null
            v_first_38_sort_key   := NULL;
            v_build_record_fields := NULL;
            v_build_record_line   := NULL;
            v_process_stage       := 'Building 38 Character Sort Key for F4 Type Record Line #5.';

            -- Build First 38 Character Sort Portion
            IF v_send_to_postal_cde = '37234' THEN
              v_first_38_sort_key := LPAD('1', 2, ' ');
            ELSE
              v_first_38_sort_key := SUBSTR(v_ar_stmt_hdr_f1_rec.SEND_TO_STATE_CDE,
                                            1,
                                            2);
            END IF;

            v_first_38_sort_key := v_first_38_sort_key ||
                                   SUBSTR(v_ar_stmt_hdr_f1_rec.SEND_TO_CUST_NBR,
                                          1,
                                          10);
            v_first_38_sort_key := v_first_38_sort_key || 'F4';
            v_first_38_sort_key := v_first_38_sort_key ||
                                   TO_CHAR(v_ar_stmt_hdr_f4_rec.TRANS_DTE,
                                           'MM-DD-YY');
            v_first_38_sort_key := v_first_38_sort_key ||
                                   lpad(SUBSTR(v_ar_stmt_hdr_f4_rec.TRANS_NBR,
                                               1,
                                               8),
                                        8,
                                        ' ');
            v_first_38_sort_key := v_first_38_sort_key || '6';
            v_first_38_sort_key := v_first_38_sort_key ||
                                   LPAD(v_f4_dtl_cnt, 7, '0');
            v_first_38_sort_key := v_first_38_sort_key || '|';
            v_process_stage     := 'Building F4 Type Record Line #6 Field Values ';
            -- Field #1
            v_build_record_fields := v_ar_stmt_dtl_f4_rec.LINE_TYPE_CDE || '|';
            -- Field #2
            v_build_record_fields := v_build_record_fields ||
                                     TO_CHAR(v_ar_stmt_dtl_f4_rec.ORDERED_QTY_CNT) || '|';
            -- Field #3
            v_build_record_fields := v_build_record_fields ||
                                     TO_CHAR(v_ar_stmt_dtl_f4_rec.SHIPPED_QTY_CNT) || '|';

            -- Field #4
            IF v_ar_stmt_dtl_f4_rec.ALT_ITEM_NBR IS NOT NULL THEN
              v_build_record_fields := v_build_record_fields ||
                                       v_ar_stmt_dtl_f4_rec.ALT_ITEM_NBR || '|';
            ELSE
              v_build_record_fields := v_build_record_fields ||
                                       v_ar_stmt_dtl_f4_rec.ITEM_NBR || '|';
            END IF;

            -- Field #5
            v_build_record_fields := v_build_record_fields ||
                                     SUBSTR(v_ar_stmt_dtl_f4_rec.LINE_DESC_TXT,
                                            1,
                                            80) || '|';

            -- Field #6
            IF v_ar_stmt_dtl_f4_rec.LINE_TYPE_CDE = 'M' THEN
              v_build_record_fields := v_build_record_fields || '|';
            ELSE
              v_build_record_fields := v_build_record_fields ||
                                       trim(TO_CHAR(v_ar_stmt_dtl_f4_rec.SELLING_PRICE_AMT,
                                                    '99999999990.00')) || '|';
            END IF;

            -- Field #7
            -- Jude Lam 05/02/06 Add the check for line_type_cde to avoid a % character for a memo line.
            IF v_ar_stmt_dtl_f4_rec.LINE_TYPE_CDE = 'M' THEN
              v_build_record_fields := v_build_record_fields || '|';
            ELSE
              v_build_record_fields := v_build_record_fields ||
                                       trim(TO_CHAR(v_ar_stmt_dtl_f4_rec.SELLING_DISC_AMT,
                                                    '990.0000') || '%') || '|';
            END IF;

            -- Field #8
            IF v_ar_stmt_dtl_f4_rec.LINE_TYPE_CDE = 'M' THEN
              v_build_record_fields := v_build_record_fields || '|';
            ELSE
              v_build_record_fields := v_build_record_fields ||
                                       trim(TO_CHAR(v_ar_stmt_dtl_f4_rec.EXTENDED_AMT,
                                                    '99999999990.00')) || '|';
            END IF;

            -- Build Record Line
            v_build_record_line := v_first_38_sort_key ||
                                   v_build_record_fields;

            -- Write Line of Text to the Output file
            log('o', v_build_record_line);
            log('d',v_process_stage || v_build_record_line);

          END IF; -- End of check to see if this needs to be displayed.

        END LOOP; -- End of Detail F4 Type Record Cursor Loop

        v_process_stage := 'Building 38 Character Sort Key for F4 Type Record Line #7.';
        -- Build Record #7 Line

        -- Reset the Variables with Null
        v_first_38_sort_key   := NULL;
        v_build_record_fields := NULL;
        v_build_record_line   := NULL;

        -- Build First 38 Character Sort Portion
        IF v_send_to_postal_cde = '37234' THEN
          v_first_38_sort_key := LPAD('1', 2, ' ');
        ELSE
          v_first_38_sort_key := SUBSTR(v_ar_stmt_hdr_f1_rec.SEND_TO_STATE_CDE,
                                        1,
                                        2);
        END IF;

        v_first_38_sort_key := v_first_38_sort_key ||
                               SUBSTR(v_ar_stmt_hdr_f1_rec.SEND_TO_CUST_NBR,
                                      1,
                                      10);
        v_first_38_sort_key := v_first_38_sort_key || 'F4';
        v_first_38_sort_key := v_first_38_sort_key ||
                               TO_CHAR(v_ar_stmt_hdr_f4_rec.TRANS_DTE,
                                       'MM-DD-YY');
        v_first_38_sort_key := v_first_38_sort_key ||
                               lpad(SUBSTR(v_ar_stmt_hdr_f4_rec.TRANS_NBR,
                                           1,
                                           8),
                                    8,
                                    ' ');
        v_first_38_sort_key := v_first_38_sort_key || '7';
        v_first_38_sort_key := v_first_38_sort_key || '0000000';
        v_first_38_sort_key := v_first_38_sort_key || '|';
        v_process_stage     := 'Building F4 Type Record Line #7 Field Values ';
        -- Field #1
        v_build_record_fields := v_ar_stmt_hdr_f4_rec.MKT_MSG1_NME || '|';
        -- Field #2
        v_build_record_fields := v_build_record_fields ||
                                 v_ar_stmt_hdr_f4_rec.MKT_MSG2_NME || '|';
        -- Field #3
        v_build_record_fields := v_build_record_fields ||
                                 v_ar_stmt_hdr_f4_rec.MKT_MSG3_NME || '|';
        -- Field #4
        v_build_record_fields := v_build_record_fields ||
                                 v_ar_stmt_hdr_f4_rec.MKT_MSG4_NME || '|';
        -- Field #5
        v_build_record_fields := v_build_record_fields ||
                                 trim(TO_CHAR(nvl(v_ar_stmt_hdr_f4_rec.SUB_TOTAL_AMT,
                                                  0),
                                              '99999999999.00')) || '|';
        -- Field #6
        v_build_record_fields := v_build_record_fields ||
                                 trim(TO_CHAR(nvl(v_ar_stmt_hdr_f4_rec.SHIP_HNDL_AMT,
                                                  0),
                                              '99999999999.00')) || '|';
        -- Field #7
        v_build_record_fields := v_build_record_fields ||
                                 trim(TO_CHAR(nvl(v_ar_stmt_hdr_f4_rec.TAX_AMT,
                                                  0),
                                              '99999999999.00')) || '|';
        -- Field #8
        v_build_record_fields := v_build_record_fields ||
                                 trim(TO_CHAR(nvl(v_ar_stmt_hdr_f4_rec.SUB_TOTAL_AMT,
                                                  0) + nvl(v_ar_stmt_hdr_f4_rec.SHIP_HNDL_AMT,
                                                           0) +
                                              nvl(v_ar_stmt_hdr_f4_rec.TAX_AMT,
                                                  0),
                                              '99999999999.00')) || '|';
        -- Field #9
        v_build_record_fields := v_build_record_fields ||
                                 trim(TO_CHAR(nvl(v_ar_stmt_hdr_f4_rec.PMT_USED_AMT,
                                                  0),
                                              '99999999999.00')) || '|';
        -- Field #10
        v_build_record_fields := v_build_record_fields ||
                                 trim(TO_CHAR(nvl(v_ar_stmt_hdr_f4_rec.TOTAL_DUE_AMT,
                                                  0),
                                              '99999999999.00')) || '|';
        -- Build Record Line
        v_build_record_line := v_first_38_sort_key || v_build_record_fields;
        -- Write Line of Text to the Output file
        log('o', v_build_record_line);
        log('d',v_process_stage || v_build_record_line);

      END LOOP; -- End of Header F4 Type Record Cursor Loop

      <<skip_for_csv>>
      NULL;
      
    END LOOP; -- End of Statement Header F1 Record Loop

    retcode := 0;
  EXCEPTION
    WHEN OTHERS THEN
      -- Write Stage to the Log
      log('l', v_process_stage);
      -- Set Concurrent Request Run Status to Error
      retcode := 2;
      -- Raise Application Error
      app_error(-20001,'ERROR in Lwx_Data_File_Phase.',null,sqlcode,sqlerrm);
  END Lwx_Data_File_Phase;

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
    RETURN VARCHAR2 IS
      v_test_flag  ec.ece_tp_details.test_flag%type := 'P';  -- Production
      
      CURSOR check_edi_status IS
      SELECT nvl(tp.test_flag,'T') test_flag
      FROM ece_tp_details tp
      WHERE tp.tp_header_id = pn_header_id
      AND tp.document_id = decode(pv_document,'INV','INO','CDMO')
      ORDER by decode(tp.test_flag,'T',1,2);
  BEGIN 
    OPEN check_edi_status;
    FETCH check_edi_status INTO v_test_flag;
    IF check_edi_status%NOTFOUND THEN
       v_test_flag := 'T';          
    END IF;
    CLOSE check_edi_status;
           
    RETURN (CASE v_test_flag 
              WHEN 'T' THEN 'Y'
              ELSE 'F'
            END);
  END edi_print;

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
  FUNCTION LWX_Email_Invoice ( pv_om_email   VARCHAR2,
                               pv_cust_email VARCHAR2)
    RETURN VARCHAR2 IS
    return_value         varchar2(50);
  BEGIN 
    return_value:= NULL;
    IF pv_om_email is NULL and pv_cust_email is NULL THEN
      return_value:= NULL;
    ELSE
      IF pv_om_email is not null and length(pv_om_email) < 51 AND
        (INSTR(RTRIM(pv_om_email,' '),' ') = 0)               AND   -- no embedded spaces
        (INSTR(pv_om_email,';') = 0)                          AND   -- no embedded semi-colons
        (INSTR(pv_om_email,',') = 0)                          THEN  -- no embedded commas
        return_value:= pv_om_email;
      ELSE
        IF pv_cust_email is not NULL and length(pv_cust_email) < 51 AND
           (INSTR(RTRIM(pv_cust_email,' '),' ') = 0)                AND   -- no embedded spaces
           (INSTR(pv_cust_email,';') = 0)                           AND   -- no embedded semi-colons
           (INSTR(pv_cust_email,',') = 0)                           THEN  -- no embedded commas
          return_value:= pv_cust_email;
        END IF;
      END IF;        
    END IF;
    return return_value;  
  END LWX_Email_Invoice;

  --- ***************************************************************************************************************
  ---   Program DESCRIPTION  :  This is the program that will be responsible for selecting the appropriate
  ---                           Invoice for physical printing.
  ---
  ---  Parameters Used       :  errbuf            - Out type parameter to return Error message from the concurrent
  ---                           retcode           - Out type parameter to return the concurrent status
  ---
  ---  Development and Maintenance History:
  ---  -------------------------------------
  ---  DATE         AUTHOR                   DESCRIPTION
  ---  ----------   ------------------------ ---------------------------------------------------------
  ---  20-DEC-2005  S Saravana Bhavan, BCT   Initial Creation
  ---  14-MAR-2006  Rajmohan K, BCT          Added debug message for log file
  ---  2006-09-21   Jude Lam, TITAN          Updated the Invoice_Selection procedure's main query for performance update.
  ---                                        Updated the Invoice_Selection procedure for more debug messages.
  ---                                        Updated the Invoice_Selection procedure to cover Credit and Debit Memo EDI
  ---                                           type as well.
  ---  2006-09-26   Jude Lam, TITAN          Added two new parameter to the Invoice_Selection program for performance reason.
  ---  2006-09-27   Jude Lam, TITAN          Additional fixes to Invoice_Selection procedure on number of arguments during the concurrent program submission.
  ---                                        Added additional debug messages in Invoice_Selection procedure.
  ---  2006-12-08   Darrin Fuqua             Added 'WC' and 'WF' to Select statement for temporary version.
  ---  2006-12-11   Darrin Fuqua             Excluded selection criteria other than 'WC' and 'WF' for temporary version.
  ---  2006-12-12   Darrin Fuqua             Commented printing_pending flag to run 'WC' and 'WF'.
  ---  2006-12-20   Darrin Fuqua             Uncommented code for special 'WC' and 'WF' runs.
  ---  2007-06-13   Greg Wright              Patches from 1.53, 1.54, and 1.55 were backed out.
  ---  15-JUN-2007  I. Balodis, TITAN        Created temp. table to write output file of invoices created.
  ---  2008-07-07   Greg Wright              Add  new sort_order, email_addr, and logo to the output in the
  ---                                        LWX_AR_INVOICE_EXTRACT file to facilitate handling of invoices
  ---                                        send by email.
  ---  2008-09-18   Greg Wright              Send on-line Worship orders 'WO' by email.
  ---  2009-11-12   Jason McCleskey          P-1719 - Modify AOL to allow email and Roadrunner to force to Mail
  ---  2009-12-11   Jason McCleskey          P-1720 - Invoice Hanging due to infinite loop (on Incomplete invoices)
  ---                                           Also cleaned up unused code/variables 
  ---  2010-02-24   Jason McCleskey          P-1725 - Do not consolidate Prospect Services (Lexinet) invoices (Sales Channel = 'PS')
  ---  2010-11-16   Greg Wright              P-2231 - Suppress mailing/emailing invoices with credit card problems.
  ---  2010-12-09   Greg Wright              P-2231 Do not mail/email credit card invoices where the remaining amount 
  ---                                           due is greater than zero.
  ---  2011-02-01   Greg Wright              P-2472 Allow credit card invoices with sales channels of LC, MS, or LZ
  ---                                           to be sent by email.
  ---  2011-07-08   Greg Wright              P-2577 Print individual JDA Inv if customer has BH collector.
  ---  2011-10-14   Jason McCleskey          P-2039 - Invoice Selection Performance 
  ---  2012-01-13   Greg Wright              Modified to name the invoice extract file based on the start time of 
  ---                                        LWX AR Auto Invoicing Set, when started by that request set.
  ---                                        Made call of get_wo_gift_card_receipt conditional.
  ---  2012-01-25   Greg Wright              Per code review, made parent request id lookup a function.
  ---  2017-08-15   Greg Wright              OF-2899 Flash Commerce  
  ---  2019-01-25   Greg Wright              OF-3186 expect two programs for each BPA call instead of three.
  --- ***************************************************************************************************************
  PROCEDURE Invoice_Selection 
                             (errbuf           OUT VARCHAR2,
                              retcode          OUT NUMBER,
                              p_trx_start_date IN VARCHAR2,
                              p_trx_end_date   IN VARCHAR2,
                              p_debug_flag     IN VARCHAR2) IS


    TYPE invo_sort_order_type IS RECORD(
      sort_order      NUMBER,
      bpa_mstr_reqid  NUMBER,
      bpa_mstr_status VARCHAR2(1),
      bpa_child_reqid NUMBER,
      output_dir      VARCHAR2(240),
      cust_nbr        VARCHAR2(25),
      email_addr      VARCHAR2(50),
      logo            VARCHAR2(3),
      trx_number      VARCHAR2(20));

    TYPE invo_sort_order_tbl IS TABLE OF invo_sort_order_type INDEX BY BINARY_INTEGER;

    v_invo_sort_order_tbl    invo_sort_order_tbl;
    v_invo_indx              BINARY_INTEGER := 0;

    -- Local varibles declaration
    v_process_stage          VARCHAR2(500);
    v_err_msg                VARCHAR2(255);
    v_term_sequence_number   AR_PAYMENT_SCHEDULES.TERMS_SEQUENCE_NUMBER%TYPE;
    v_conc_req_id            NUMBER;
    v_term_count             NUMBER;
    v_trx_start_date         DATE; -- Jude Lam 09/26/06 Update
    v_trx_end_date           DATE; -- Jude Lam 09/26/06 Update
    v_output_rec             VARCHAR2(2000);
    v_extract_file_handle    UTL_FILE.FILE_TYPE;
    v_error_file_handle      UTL_FILE.FILE_TYPE;
    v_dir_name               VARCHAR2(2000) := 'LWX_FND_OUT_DATA_SOURCE_DIR';
    v_extract_file           VARCHAR2(100) := 'LWX_AR_INVOICE_EXTRACT';
    v_error_file             VARCHAR2(100) := 'LWX_AR_INVOICE_ERROR';
    v_recs_written           NUMBER := 0;
    vb_trx_no_print          BOOLEAN := FALSE;
    v_start_date             DATE;
    v_parent_req_id          NUMBER;
    
    -- Declare Transactions Cursor
    CURSOR cur_transactions ( p_trx_start_date_v DATE
                             ,p_trx_end_date_v   DATE) IS
    SELECT trx.customer_trx_id, 
           trx.trx_number, 
           ps.class,
           cust.account_number customer_number,
           (case  -- Determine if allowed to print a pdf (based on EDI status)
              when cst.ece_tp_location_code is null then 'Y'
              else edi_print(cst.tp_header_id,ps.class)
            end)   generate_pdf,
           (case  -- Sort Order
              when ((nvl(cust.attribute11,'No') <> 'No') 
               and  LWX_Email_Invoice(oeh.attribute7,cust.attribute11) is not NULL 
               and  (instr(lower(nvl(cust.attribute11,'No')),'roadrunner.com') = 0)
               and  (instr(lower(nvl(cust.attribute11,'No')),'rr.com') = 0)) then 9 -- email all
              when ((lwx_ar_query.email_web_invoice(trx.ATTRIBUTE5) = 1) -- True  
               and  LWX_Email_Invoice(oeh.attribute7,cust.attribute11) is not NULL 
               and  (nvl(cust.ATTRIBUTE10,'No') <> 'Yes') 
               and  (trx.ATTRIBUTE8 = 'WEB FORM')
               and  (lower(cust.ATTRIBUTE1) <> 'es') 
               and  (nvl(oeh.ATTRIBUTE7,'***') <> '***') 
               and  (instr(lower(nvl(oeh.attribute7,'No')),'roadrunner.com') = 0)
               and  (instr(lower(nvl(oeh.attribute7,'No')),'rr.com') = 0)
               and  (nvl(rmeth.PAYMENT_TYPE_CODE, 'XX') = 'CREDIT_CARD')) then 5 -- English
              when ((lwx_ar_query.email_web_invoice(trx.ATTRIBUTE5) = 1) -- True   
               and  LWX_Email_Invoice(oeh.attribute7,cust.attribute11) is not NULL                              
               and  (nvl(cust.ATTRIBUTE10,'No') <> 'Yes') 
               and  (trx.ATTRIBUTE8 = 'WEB FORM')
               and  (lower(cust.ATTRIBUTE1) = 'es') 
               and  (nvl(oeh.ATTRIBUTE7,'***') <> '***') 
               and  (instr(lower(nvl(oeh.attribute7,'No')),'roadrunner.com') = 0)
               and  (instr(lower(nvl(oeh.attribute7,'No')),'rr.com') = 0)
               and  (nvl(rmeth.PAYMENT_TYPE_CODE, 'XX') = 'CREDIT_CARD')) then 6 -- Spanish
              when ((trx.ATTRIBUTE5 = 'RW') 
               and  LWX_Email_Invoice(oeh.attribute7,cust.attribute11) is not NULL                 
               and  (nvl(cust.ATTRIBUTE10,'No') <> 'Yes') 
               and  (trx.ATTRIBUTE8 = 'WEB FORM')
               and  (nvl(oeh.ATTRIBUTE7,'***') <> '***') 
               and  (instr(lower(nvl(oeh.attribute7,'No')),'roadrunner.com') = 0)
               and  (instr(lower(nvl(oeh.attribute7,'No')),'rr.com') = 0)
               and  (nvl(rmeth.PAYMENT_TYPE_CODE, 'XX') = 'CREDIT_CARD')) then 7 -- Retail
              when loc.COUNTRY <> 'US' then 0
              when substr(loc.POSTAL_CODE,1,5) = '37234' then 1
              else 2
           end) sort_order,
           nvl(LWX_Email_Invoice(oeh.attribute7,cust.attribute11),'***') email_addr,
           nvl(
               (select nvl(lup.attribute3,'**')
                from apps.fnd_lookup_values lup
                where lup.lookup_type = 'SALES_CHANNEL'
                and lup.lookup_code = trx.attribute5)
               ,'**') logo
    FROM ar.ra_customer_trx_all trx, ar.ar_payment_schedules_all ps, 
         ar.hz_cust_accounts cust, ar.hz_customer_profiles prof, ar.ar_collectors coll, 
         ar.ar_receipt_methods rmeth, ar.hz_cust_site_uses_all bsu, 
         ar.hz_cust_acct_sites_all cst, ar.hz_party_sites pst, ar.hz_locations loc, 
         oe_order_headers oeh
    WHERE trx.bill_to_customer_id = cust.cust_account_id 
    AND trx.printing_option = 'PRI' 
    AND trx.printing_last_printed IS NULL 
    AND trx.creation_date between p_trx_start_date_v AND p_trx_end_date_v -- Jude Lam 09/26/06 Update 
    AND ps.class IN ('INV', 'DM', 'CM') 
    AND (case trx.attribute5
           when 'ET' then lwx_ar_query.get_wo_gift_card_receipt(PS.PAYMENT_SCHEDULE_ID)
           when 'WO' then lwx_ar_query.get_wo_gift_card_receipt(PS.PAYMENT_SCHEDULE_ID)  
           when 'FC' then lwx_ar_query.get_wo_gift_card_receipt(PS.PAYMENT_SCHEDULE_ID)             
             else NULL  
         end) IS NULL
    AND cust.cust_account_id = prof.cust_account_id 
    AND prof.site_use_id is null 
    AND trx.customer_trx_id = ps.customer_trx_id
    AND (
             -- Credit Card Trx
            (rmeth.payment_type_code = 'CREDIT_CARD' and ps.amount_due_remaining <= 0) 
         OR (nvl(prof.attribute1,'N') = 'N') -- Invoices are not consolidated with statements
         OR (cust.attribute1 = 'Es')  -- Language is Spanish
         OR (trx.attribute5 = 'EG') -- Sales Channel is eGiving
         OR (trx.attribute5 = 'PS') -- Sales Channel is Lexinet
        ) 
    AND trx.receipt_method_id = rmeth.receipt_method_id(+) -- Jude Lam 09/26/06 Update 
    AND trx.bill_to_site_use_id = bsu.site_use_id 
    -- Print individual JDA/D365 Inv if customer has BH collector.
    AND prof.collector_id = coll.collector_id
    AND (     substr(trx.TRX_NUMBER,1,1) != 'J'
          OR (substr(trx.TRX_NUMBER,1,1) = 'J' AND coll.name like 'B%')
         ) 
    AND bsu.cust_acct_site_id = cst.cust_acct_site_id 
    AND cst.party_site_id = pst.party_site_id 
    AND pst.location_id = loc.location_id 
    AND oeh.order_number (+) = (case trx.interface_header_context 
                                 when 'ORDER ENTRY' then trx.interface_header_attribute1
                                 else null
                               end)
    -- Exlcude any credit card trx that are in an error state
    AND not exists (select 1 
                    from ar.ar_receivable_applications_all app, ar.ar_cash_receipts_all rec
                    where app.applied_customer_trx_id = trx.customer_trx_id 
                    and app.cash_receipt_id = rec.cash_receipt_id 
                    and rec.cc_error_code is not null)
    ORDER BY sort_order, cust.account_number;

    -- Declare a Custom Exception Concurrent Program Process Timed Out for more than 30 Minutes
    v_concurrent_timed_out EXCEPTION;

    FUNCTION get_parent_task RETURN NUMBER IS
      v_parent_id   NUMBER;
      v_request_id  NUMBER;
      v_description apps.FND_CONCURRENT_REQUESTS.DESCRIPTION%TYPE;

    BEGIN
      v_request_id := fnd_global.CONC_REQUEST_ID; -- start request_id
 
      LOOP
        SELECT parent_request_id, -- request id of parent
               description        -- description of child
        INTO   v_parent_id, 
               v_description
        FROM   apps.fnd_concurrent_requests
        WHERE  request_id = v_request_id;

        IF v_description = 'LWX AR Auto Invoicing Set' THEN
          EXIT;
        END IF;

        IF v_parent_id = -1 THEN
          -- This is expected if the program is run outside of the request set and
          -- if v_description is not 'LWX AR Auto Invoicing Set'
          RETURN v_request_id;
        ELSE
          v_request_id:= v_parent_id;
        END IF;
      END LOOP;

      RETURN v_request_id;
    END get_parent_task;

  BEGIN
    g_debug_mode := p_debug_flag;
    log('l','BEGIN lwx_ar_invo_stmt_print.invoice_selection @','e');

    -- Save off start time based on start time of request set
    -- Default to sysdate if program is run directly
    v_start_date:= sysdate;
    log('l','Start Date for program:' || TO_CHAR(v_start_date,'mm/dd/yyyy:hh24:mi:ss'),'e');

    v_parent_req_id:= get_parent_task; 
    SELECT actual_start_date
    INTO   v_start_date
    FROM   apps.fnd_concurrent_requests
    WHERE  request_id = v_parent_req_id;
    log('l','Start Date for parent request id: ' || to_char(v_parent_req_id) || ' ' || 
            TO_CHAR(v_start_date,'mm/dd/yyyy:hh24:mi:ss'),'e');

    -- Variable Initialization
    IF p_trx_start_date IS NOT NULL THEN
      v_trx_start_date := TRUNC(to_date(p_trx_start_date,
                                        'yyyy/mm/dd hh24:mi:ss'));
    ELSE
      v_trx_start_date := TRUNC(NVL(to_date(p_trx_end_date,
                                            'yyyy/mm/dd hh24:mi:ss'),
                                    sysdate - 1));
    END IF;

    IF p_trx_end_date IS NOT NULL THEN
      v_trx_end_date := TRUNC(to_date(p_trx_end_date,
                                      'yyyy/mm/dd hh24:mi:ss')) + 0.99999;
    ELSE
      v_trx_end_date := TRUNC(sysdate) + 0.99999;
    END IF;

    log('l',  '  Trx Start Date: '||to_char(v_trx_start_date,'mm/dd/rrrr hh24:mi:ss')||gcv_newline
            ||'  Trx End Date: '||to_char(v_trx_end_date,'mm/dd/rrrr hh24:mi:ss')||gcv_newline
            ||'  Debug Mode: ' || p_debug_flag);

    v_process_stage := 'Begin Invoice Selection...';
    log('l','Begin Process Transactions Cursor @','e');
    <<main_loop>>
    FOR rec IN cur_transactions (p_trx_start_date_v => v_trx_start_date,
                                 p_trx_end_date_v   => v_trx_end_date) 
    LOOP

      log('d','Processing Customer Trx ID '||rec.customer_trx_id 
              ||' Trx_Number '||rec.trx_number
              ||' Generate PDF '||rec.generate_pdf);

      -- Check for EDI customer to see if the customer is still in Test mode.  If it is, then
      -- the invoice still needs to be printed.  If not EDI customer at all then print as well
      IF (rec.generate_pdf = 'Y') THEN

        -- Submit Concurrent Program
        v_process_stage := 'Submitting Concurrent Request Trx Number: '||rec.TRX_NUMBER;
        v_conc_req_id := fnd_request.submit_request('AR',
                                                    'ARBPIPMP',
                                                    NULL,
                                                    NULL,
                                                    FALSE,
                                                    NULL, -- R12 Operating Unit
                                                    1, -- Number of Instance
                                                    'ANY', -- Transaction to Print
                                                    'TRX_NUMBER', -- Order By
                                                    NULL, -- Batch
                                                    NULL, -- Transaction Class
                                                    NULL, -- Transaction Type
                                                    NULL, -- Customer Class
                                                    NULL, -- Bill From Customer Name
                                                    NULL, -- Bill To Customer Name
                                                    NULL, -- Bill From Customer Number
                                                    NULL, -- Bill To Customer Number
                                                    rec.TRX_NUMBER, -- Trx number low
                                                    rec.TRX_NUMBER, -- Trx number high
                                                    NULL, -- Installment number
                                                    NULL, -- Low print date
                                                    NULL, -- high print date
                                                    'N', -- Open Invoice
                                                    to_char(rec.CUSTOMER_TRX_ID), -- Invoice String
                                                    NULL, -- R12 Template Id
                                                    NULL, -- R12 Child's Template Id
                                                    NULL, -- R12 Locale
                                                    'N'   -- R12 Index Flag
                                                    );
        v_process_stage := 'Check to See the Status of Concurrent Program Submitted';
        log('d','    Concurrent Request ID '||v_conc_req_id);

        IF v_conc_req_id != 0 THEN

          -- Launch the job to concurrent mgr.
          COMMIT;

          v_invo_indx := v_invo_indx + 1;

          v_invo_sort_order_tbl(v_invo_indx).sort_order := rec.sort_order;
          v_invo_sort_order_tbl(v_invo_indx).bpa_mstr_reqid := v_conc_req_id;
          v_invo_sort_order_tbl(v_invo_indx).bpa_mstr_status := null;
          v_invo_sort_order_tbl(v_invo_indx).cust_nbr := rec.customer_number;
          v_invo_sort_order_tbl(v_invo_indx).email_addr := rec.email_addr;
          v_invo_sort_order_tbl(v_invo_indx).logo := rec.logo;
          v_invo_sort_order_tbl(v_invo_indx).trx_number := rec.trx_number;

        ELSE
          -- Concurrent Request Submission failed
          -- Get Error Message
          v_err_msg := SUBSTR(fnd_message.get, 1, 255);
          -- Write Log File
          log('l','Error in Submitting Concurrent Request.');
          log('l','Error Message : '||v_err_msg);
          EXIT; -- Exit from the Customer Cursor Loop
        END IF; -- End of Concurrent Request Id Check
      ELSE  -- rec.generate_pdf is NOT Y 
        BEGIN
          v_process_stage := 'Get the Term Count and Sequence Number for customer_trx_id: ' 
                             ||rec.customer_trx_id;

          SELECT COUNT(*), MAX(TERMS_SEQUENCE_NUMBER)
            INTO v_term_count, v_term_sequence_number
            FROM AR_PAYMENT_SCHEDULES
           WHERE CUSTOMER_TRX_ID = rec.CUSTOMER_TRX_ID;

          log('l','Term Count ' || v_term_count);

        EXCEPTION
          WHEN NO_DATA_FOUND THEN
            v_term_count := 0;
            v_term_sequence_number := null;
            log('l','Term Count ' || v_term_count);
          WHEN OTHERS THEN
            log('l', v_process_stage);
            -- Raise an application error
            app_error(-20001,'ERROR in Invoice_Selection',v_process_stage,sqlcode,sqlerrm);
        END;

        log('d','Term Sequence Number ' || v_term_sequence_number);

        v_process_stage          := 'Call Standard Procedure to Set the Invoice Flag';
        log('d',v_process_stage);

        ar_invoice_sql_func_pub.update_customer_trx(p_choice => rec.class, 
                                                    p_customer_trx_id => rec.CUSTOMER_TRX_ID,
                                                    p_trx_type => null,
                                                    p_term_count=> v_term_count,
                                                    p_term_sequence_number => v_term_sequence_number,
                                                    p_printing_count => 0,
                                                    p_printing_original_date => null);

      END IF; -- End of Check for Customer Test Mode to print

    END LOOP; -- End of Select Customer Cursor Loop
    log('l','End Process Transactions Cursor @','e');
    

    IF v_invo_indx > 0 THEN

      -- Open utl files for output.
      -- the filenames must be unique, so add a timestamp to the end of a common name
      -- ie. LWX_AR_INVOICE_EXTRACT_YYYYMMDD_HH24MISS.dat
      --
      v_extract_file := v_extract_file||'_'||TO_CHAR(v_start_date,'YYYYMMDD_HH24MISS')||'.dat';

      v_extract_file_handle := UTL_FILE.FOPEN(v_dir_name, v_extract_file, 'W');


      log('l','Begin loop to write output file ('||v_extract_file||' @','e');
      FOR i IN 1 .. v_invo_indx
      LOOP
          -- Check for Master BPA Request to be completed - it will complete once child is done
          --  Note - Not all Master Requests will submit a child request though 
          <<check_master_bpa_loop>>
          LOOP
            BEGIN
              SELECT  master.status_code bpa_mstr_status
                     ,child.request_id bpa_child_req_id
                     ,child.outfile_name
                INTO  v_invo_sort_order_tbl(i).bpa_mstr_status
                     ,v_invo_sort_order_tbl(i).bpa_child_reqid
                     ,v_invo_sort_order_tbl(i).output_dir
                FROM fnd_concurrent_requests master, fnd_concurrent_requests child
               WHERE master.request_id = v_invo_sort_order_tbl(i).bpa_mstr_reqid
               AND master.request_id = child.parent_request_id (+)
               AND master.phase_code = 'C';

               EXIT check_master_bpa_loop;

            EXCEPTION WHEN OTHERS THEN
                DBMS_LOCK.SLEEP(5);
            END;
          END LOOP;

          IF (v_invo_sort_order_tbl(i).bpa_child_reqid is null)
            OR (v_invo_sort_order_tbl(i).bpa_mstr_status <> 'C') THEN
              -- Process the error here
              log('d','WARNING! Trx did not print - Trx Number: '||v_invo_sort_order_tbl(i).trx_number);  
              IF (NOT vb_trx_no_print) THEN
                  vb_trx_no_print := TRUE;
                  -- Setup Error File 
                  v_error_file := v_error_file||'_'||TO_CHAR(SYSDATE,'YYYYMMDD_HH24MISS')||'.dat';
                  v_error_file_handle := UTL_FILE.FOPEN(v_dir_name, v_error_file, 'W');
                  
                  utl_file.put_line(v_error_file_handle,
                                    'LWX AR Invoice Selection - List of Transactions NOT printed');
                  utl_file.put_line(v_error_file_handle,
                                    'Please research - check for Incomplete and/or Open Receivable Trx Type');
                  utl_file.put_line(v_error_file_handle,' ');
                  utl_file.put_line(v_error_file_handle,
                                    rpad('Trx Number',25,' ')||rpad('Customer Number',20,' '));
                  utl_file.put_line(v_error_file_handle,
                                    rpad('-',20,'-')||'     '||rpad('-',20,'-'));
              END IF;              
              -- Write Trx # and Customer # out to Output file
              -- File will be emailed to appropriate AR personnel by LWX AR Invoice Print Job
              utl_file.put_line(v_error_file_handle,
                                rpad(v_invo_sort_order_tbl(i).trx_number,25,' ')||
                                v_invo_sort_order_tbl(i).cust_nbr);
          ELSE 
              -- format the column
              v_output_rec := v_invo_sort_order_tbl(i).sort_order ||','||
                              v_invo_sort_order_tbl(i).bpa_mstr_reqid ||','||
                              v_invo_sort_order_tbl(i).bpa_child_reqid ||','||
                              v_invo_sort_order_tbl(i).output_dir ||','||
                              v_invo_sort_order_tbl(i).cust_nbr ||','||
                              v_invo_sort_order_tbl(i).email_addr ||','||
                              v_invo_sort_order_tbl(i).logo ||','||
                              v_invo_sort_order_tbl(i).trx_number;
              log('d',v_output_rec);                              

              UTL_FILE.PUT_LINE(v_extract_file_handle, v_output_rec);

              -- keep count of records written
              v_recs_written := v_recs_written + 1;
          END IF; ---

      END LOOP;
      log('l','End loop to write output file @','e');
      
      -- close utl files.
      UTL_FILE.FCLOSE(v_extract_file_handle);
      IF (utl_file.is_open(v_error_file_handle)) THEN
          utl_file.fclose(v_error_file_handle);
      END IF;

      log('l',v_recs_written || ' Record(s) written to output file.');

    END IF;

    log('l','END lwx_ar_invo_stmt_print.invoice_selection @','e');

  EXCEPTION
    WHEN utl_file.invalid_path THEN
      log('d','UTL_FILE.INVALID_PATH: '||v_dir_name||v_extract_file);
    WHEN utl_file.invalid_mode THEN
      log('d','UTL_FILE.INVALID_MODE');
    WHEN utl_file.invalid_filehandle THEN
      log('d','UTL_FILE.FILEHANDLE');
    WHEN utl_file.invalid_operation THEN
      log('d','UTL_FILE.INVALID_OPERATION');
    WHEN v_concurrent_timed_out THEN
      -- Write Log File
      log('l', 'Invoice Printing Program Timed Out...');
      log('l', 'v_process_stage: ' || v_process_stage);

      -- Close the Cursor If Open
      IF cur_transactions%ISOPEN THEN
        CLOSE cur_transactions;
      END IF;

      -- Return Concurrent Status as Error
      retcode := 2;
    WHEN OTHERS THEN
      log('l','v_process_stage: ' || v_process_stage);

      -- Close the Cursor If Open
      IF cur_transactions%ISOPEN THEN
        CLOSE cur_transactions;
      END IF;

      log('l', 'Error Code: ' || TO_NUMBER(SQLCODE));
      log('l', 'Error Message: ' || SQLERRM);

  END Invoice_Selection;  
  
  FUNCTION Lwx_Inv_Scanned_Line_Logic(p_account_number IN VARCHAR2,
                                      p_amount_to_pay  IN NUMBER,
                                      p_trx_number     IN VARCHAR2)
    RETURN VARCHAR2 IS
    --- ***************************************************************************************************************
    ---   Program DESCRIPTION      :  This is the function will perform the Scanned Line Logic and returns the value
    ---                               to the Calling Program
    ---
    ---  Parameters Used           :   p_account_number
    ---                                p_amount_to_pay
    ---                                p_trx_number
    ---
    ---  Development and Maintenance History:
    ---  -------------------------------------
    ---  DATE         AUTHOR                   DESCRIPTION
    ---  ----------   ------------------------ ---------------------------------------------------------
    ---  20-DEC-2005  S Saravana Bhavan, BCT   Initial Creation
    ---  14-MAR-2006  Rajmohan K, BCT          Added debug message for log file
    ---  2006-10-23   Jude Lam, TITAN          Updated the Lwx_Stmt_Scanned_line and Lwx_Inv_scanned_Line_logic to
    ---                                           keep any trailing zeros after the decimal is trimmed off.
    ---  2006-10-27   Jude Lam, TITAN          Updated the Lwx_Inv_Scanned_line_logic for a minor bug fix on using the wrong
    ---                                           variable when formatting the amount.
    ---  2008-09-25   Greg Wright              Add v_reference_number.
    ---  2011-10-14   Jason McCleskey          P-2039 - Invoice Selection Performance 
    --- ***************************************************************************************************************

    -- Declare Local Variables
    v_process_stage          VARCHAR2(240);
    v_scanned_line           VARCHAR2(60) := null;
    v_account_number         VARCHAR2(10) := null;
    v_amount_to_pay          VARCHAR2(9) := null;
    v_reference_number       VARCHAR2(9);
    v_check_digit_constant   VARCHAR2(5);
    v_scanned_line_chk_digit NUMBER;
  BEGIN
    log('d','Start of Lwx_Inv_Scanned_Line_Logic Procedure');
    log('d','Account Number ' || p_account_number ||
              'Amount to Pay ' || p_amount_to_pay ||
              'Transaction Number ' || p_trx_number);
    v_process_stage := 'Begin Scanned Line Logic.';

    v_account_number := LPAD(p_account_number, 10, '0');
    -- Convert amount to character, replace decimal with null, and pad leading zeroes up to 9 characters
    v_amount_to_pay := lpad(replace(to_char(abs(nvl(p_amount_to_pay,0)),'FM999990.00'),'.',''),9,'0');
    v_check_digit_constant := '33333';
    v_reference_number     := '000000000';
    v_process_stage        := 'Call to Scanned Line Check Digit Function with acct: ' ||
                              v_account_number || ' and amt_to_pay: ' ||
                              v_amount_to_pay;
    log('d',v_process_stage);
    -- Call to Get the Check Digit
    v_scanned_line_chk_digit := Lwx_Get_Check_Digit(v_check_digit_constant,
                                                    v_account_number,
                                                    v_amount_to_pay,
                                                    v_reference_number);
    -- Check the Call to Check Digit Status
    IF NVL(v_scanned_line_chk_digit, -999) = -999 THEN
      -- Function Call Returns Error

      -- Raise Application Error
      app_error(-20001,'ERROR in  Lwx_Inv_Scanned_Line_Logic:',null,sqlcode,sqlerrm);
    END IF;
    v_process_stage := 'Build Scanned Line.';
    -- Build Scanned Line
    v_scanned_line := v_check_digit_constant || v_account_number ||
                      v_amount_to_pay || v_reference_number;
    v_scanned_line := v_scanned_line || TO_CHAR(v_scanned_line_chk_digit);
    log('d','Scanned_Line ' || v_scanned_line);
    log('d','End of Lwx_Inv_Scanned_Line_Logic Procedure');
    RETURN(v_scanned_line);
  EXCEPTION
    WHEN OTHERS THEN
      -- Write Stage to the Log
      log('l', v_process_stage);
      -- Raise Application Error
      app_error(-20001,'ERROR in  Lwx_Inv_Scanned_Line_Logic:',null,sqlcode,sqlerrm);
  END Lwx_Inv_Scanned_Line_Logic;

  FUNCTION lwx_Item_Row (P_Stmt_Line_Id     IN lwx_ar_stmt_lines.stmt_line_id%TYPE
                        ,P_Stmt_Line_Dtl_Id IN lwx_ar_stmt_line_details.stmt_line_dtl_id%TYPE)
                         RETURN NUMBER RESULT_CACHE IS
    v_return_value NUMBER;       
        
    cursor inv_line(c_stmt_line_id number) is
      select  sd.stmt_line_dtl_id
      from    lwx.lwx_ar_stmt_lines           sl,
              lwx.lwx_ar_stmt_line_details    sd
      where   sl.stmt_line_id = c_stmt_line_id
      and     sl.stmt_line_id = sd.stmt_line_id
      AND     check_xml_display(sd.customer_trx_line_id) = 1
      order by sd.stmt_line_dtl_id;

    v_counter number;
    v_index_stmt_line_dtl_id NUMBER(22);
    v1_stmt_line_id          NUMBER;              
    BEGIN
      v_counter:= 0;
      IF P_STMT_LINE_ID <> nvl(v_last_stmt_line_id,0) THEN
        BEGIN
          row_stmt_line_dtl_id.delete;
          v1_stmt_line_id:= P_STMT_LINE_ID;
          open inv_line(v1_stmt_line_id);
          loop
            fetch inv_line into v_index_stmt_line_dtl_id;
         
            EXIT WHEN inv_line%NOTFOUND;
            v_counter:= v_counter + 1;   
            row_stmt_line_dtl_id(trim(to_char(v_index_stmt_line_dtl_id,'9999999999999999999999'))):= v_counter;
          end loop;  
          close inv_line;
          v_last_stmt_line_id:= P_STMT_LINE_ID;
        END;
      END IF;  

     v_return_value:= nvl(row_stmt_line_dtl_id(trim(to_char(P_Stmt_Line_Dtl_Id,'9999999999999999999999'))),v_counter); 

     return v_return_value;
   END lwx_Item_Row;  

   FUNCTION lwx_Detail_Row (P_Stmt_Hdr_Id      IN lwx_ar_stmt_headers.stmt_hdr_Id%TYPE
                             ,P_Stmt_Line_Id     IN lwx_ar_stmt_lines.stmt_line_id%TYPE)
                         RETURN NUMBER RESULT_CACHE IS
    v_return_value NUMBER;       
        
    cursor inv_line(c_stmt_hdr_id number) is
      SELECT        sl.stmt_line_id
      FROM          lwx.lwx_ar_stmt_headers       sh,
                    lwx.lwx_ar_stmt_lines         sl
      WHERE         sh.stmt_hdr_id = P_Stmt_Hdr_Id
      AND           sh.stmt_hdr_id = sl.stmt_hdr_id
      AND           sl.rec_type_cde = 'F3'
      ORDER BY      sl.stmt_hdr_id,
                    sl.trans_dte,
                    sl.payment_schedule_id
      ;

    v_counter number;
    v_index_stmt_line_id NUMBER(22);
    v1_stmt_hdr_id       NUMBER;              
    BEGIN
      v_counter:= 0;
      IF P_STMT_HDR_ID <> nvl(v_last_stmt_hdr_id,0) THEN
        BEGIN
          row_stmt_line_id.delete;
          v1_stmt_hdr_id:= P_STMT_HDR_ID;
          open inv_line(v1_stmt_hdr_id);
          loop
            fetch inv_line into v_index_stmt_line_id;
         
            EXIT WHEN inv_line%NOTFOUND;
            v_counter:= v_counter + 1;   
            row_stmt_line_id(trim(to_char(v_index_stmt_line_id,'9999999999999999999999'))):= v_counter;
          end loop;  
          close inv_line;
          v_last_stmt_hdr_id:= P_STMT_HDR_ID;
        END;
      END IF;  

     v_return_value:= nvl(row_stmt_line_id(trim(to_char(P_Stmt_Line_Id,'9999999999999999999999'))),v_counter); 

     return v_return_value;    
   END lwx_Detail_Row;  

   FUNCTION lwx_Prepaid_Row (P_Stmt_Hdr_Id      IN lwx_ar_stmt_headers.stmt_hdr_Id%TYPE
                            ,P_Stmt_Line_Id     IN lwx_ar_stmt_lines.stmt_line_id%TYPE)
                         RETURN NUMBER RESULT_CACHE IS
    v_return_value NUMBER;                     
        
    cursor inv_line(c_stmt_hdr_id number) is
      SELECT        sl.stmt_line_id
      FROM          lwx.lwx_ar_stmt_headers       sh,
                    lwx.lwx_ar_stmt_lines         sl
      WHERE         sh.stmt_hdr_id = P_Stmt_Hdr_Id
      AND           sh.stmt_hdr_id = sl.stmt_hdr_id
      AND           sl.rec_type_cde = 'F2' 
      ORDER BY      sl.stmt_hdr_id,
                    sl.trans_dte,
                    sl.payment_schedule_id
      ;

    v_counter number;
    v_index_stmt_line_id NUMBER(22);
    v1_stmt_hdr_id       NUMBER;              
    BEGIN
      v_counter:= 0;
      IF P_STMT_HDR_ID <> nvl(v_last_stmt_hdr_id_prepaid,0) THEN
        BEGIN
          row_stmt_line_id_ppd.delete;
          v1_stmt_hdr_id:= P_STMT_HDR_ID;
          open inv_line(v1_stmt_hdr_id);
          loop
            fetch inv_line into v_index_stmt_line_id;
         
            EXIT WHEN inv_line%NOTFOUND;
            v_counter:= v_counter + 1;   
            row_stmt_line_id_ppd(trim(to_char(v_index_stmt_line_id,'9999999999999999999999'))):= v_counter;
          end loop;  
          close inv_line;
          v_last_stmt_hdr_id_prepaid := P_STMT_HDR_ID;
        END;
      END IF;  

     v_return_value:= nvl(row_stmt_line_id_ppd(trim(to_char(P_Stmt_Line_Id,'9999999999999999999999'))),v_counter); 

     return v_return_value;       
   END lwx_Prepaid_Row;  


  --- ***************************************************************************************************************
  --- Function Lwx_Get_Freight_Amt
  --- Description:
  ---   This is a utility function that will retrieve the Freight amount by summing up the freight lines
  ---      using the item that matches to the one setup in the OE_INVENTORY_ITEM_FOR_FREIGHT profile setup.
  ---
  ---  Development and Maintenance History:
  ---  -------------------------------------
  ---  DATE         AUTHOR                   DESCRIPTION
  ---  ----------   ------------------------ ---------------------------------------------------------
  ---  2011-10-14   Jason McCleskey          P-2039 - Invoice Selection Performance 
  --- ***************************************************************************************************************
  FUNCTION Lwx_Get_Freight_Amt(p_customer_trx_id IN NUMBER) RETURN NUMBER IS

    v_freight_amt      NUMBER := 0;

    CURSOR freight_cur IS
    SELECT sum(nvl(extended_amount, 0)) extended_amount
    FROM   ar.ra_customer_trx_lines_all ln
    WHERE  customer_trx_id = p_customer_trx_id
    AND    inventory_item_id = gn_freight_item
    AND    line_type = 'LINE'
    AND    sales_order_line is null
    AND    ((interface_line_context = 'ORDER ENTRY'
             AND 
             exists (select 1 from oe_price_adjustments
                   where price_adjustment_id = TO_NUMBER(ln.interface_line_attribute6)
                   and charge_type_code = 'SHIPPING AND PROCESSING')
            )
            OR
            (
            interface_line_context <> 'ORDER ENTRY'
            )
           ); 

  BEGIN
    OPEN freight_cur;
    FETCH freight_cur INTO v_freight_amt;
    IF freight_cur%NOTFOUND THEN 
       v_freight_amt := 0;
    END IF;
    CLOSE freight_cur;

    RETURN nvl(v_freight_amt,0);
  EXCEPTION WHEN OTHERS THEN
      app_error(-20001,'Error in Lwx_Get_Freight_Amt using customer_trx_id: '
                        ||p_customer_trx_id,null,sqlcode,sqlerrm);
  END Lwx_Get_Freight_Amt;
  
  --- ***************************************************************************************************************
  --- Function Lwx_Get_Line_Amt
  --- Description:
  ---   This is a utility function that will retrieve the Line amount by summing up the invoice lines
  ---      using the item that DOES NOT matches to the one setup in the OE_INVENTORY_ITEM_FOR_FREIGHT profile setup.
  ---
  ---  Development and Maintenance History:
  ---  -------------------------------------
  ---  DATE         AUTHOR                   DESCRIPTION
  ---  ----------   ------------------------ ---------------------------------------------------------
  ---  2011-10-14   Jason McCleskey          P-2039 - Invoice Selection Performance 
  --- ***************************************************************************************************************
  FUNCTION Lwx_Get_Line_Amt(p_customer_trx_id IN NUMBER) RETURN NUMBER IS

    v_line_amt         NUMBER := 0;

    CURSOR line_cur IS
    SELECT sum(nvl(extended_amount,0))
    FROM ra_customer_trx_lines ln
    WHERE customer_trx_id = p_customer_trx_id
    AND line_type in ('LINE', 'CB')
    AND not exists (select 1 from oe_price_adjustments
                    where price_adjustment_id = TO_NUMBER(ln.interface_line_attribute6)
                    and charge_type_code = 'SHIPPING AND PROCESSING'
                    and ln.interface_line_context = 'ORDER ENTRY'
                    and ln.sales_order_line is null
                    and ln.inventory_item_id = gn_freight_item)
     AND NOT    (ln.interface_line_context <> 'ORDER ENTRY'
             and ln.sales_order_line is null
             and ln.inventory_item_id = gn_freight_item);                   

  BEGIN
    OPEN line_cur;
    FETCH line_cur INTO v_line_amt;
    IF line_cur%NOTFOUND THEN 
       v_line_amt := 0;
    END IF;
    CLOSE line_cur;

    RETURN nvl(v_line_amt,0);
  EXCEPTION WHEN OTHERS THEN
      app_error(-20001,'Error in Lwx_Get_Line_Amt using customer_trx_id: ' ||p_customer_trx_id,
                        null,sqlcode,sqlerrm);
  END Lwx_Get_Line_Amt;

  --- ***************************************************************************************************************
  --- Function Lwx_Get_Item_Xref
  --- Description:
  ---   This is a utility function that will retrieve the Line amount by summing up the invoice lines
  ---      using the item that DOES NOT matches to the one setup in the OE_INVENTORY_ITEM_FOR_FREIGHT profile setup.
  ---
  ---  Development and Maintenance History:
  ---  -------------------------------------
  ---  DATE         AUTHOR                   DESCRIPTION
  ---  ----------   ------------------------ ---------------------------------------------------------
  ---  2011-10-14   Jason McCleskey          P-2039 - Invoice Selection Performance 
  --- ***************************************************************************************************************
  FUNCTION Lwx_Get_Item_Xref(p_item_id IN NUMBER) RETURN VARCHAR2 IS
    v_xref_value MTL_CROSS_REFERENCES.CROSS_REFERENCE%TYPE;

    CURSOR xref_cur IS
    SELECT mcr.cross_reference
    FROM mtl_cross_references mcr,
           mtl_system_items_b   msi,
           mtl_parameters       mp
    WHERE msi.inventory_item_id = p_item_id
    AND msi.organization_id = mp.organization_id
    AND mp.organization_id = mp.master_organization_id
    AND msi.inventory_item_id = mcr.inventory_item_id
    AND msi.attribute13 = mcr.cross_reference_type
    AND mcr.organization_id is null;

  BEGIN

    OPEN xref_cur;
    FETCH xref_cur INTO v_xref_value;
    IF xref_cur%NOTFOUND THEN
       v_xref_value := null;
    END IF;
    CLOSE xref_cur;

    RETURN v_xref_value;
  EXCEPTION WHEN OTHERS THEN
      app_error(-20001,'Error in Lwx_Get_Item_Xref using item_id: '||p_item_id,null,sqlcode,sqlerrm);
  END Lwx_Get_Item_Xref;

  --- ***************************************************************************************************************
  --- Function Lwx_Calc_Discount
  --- Description:
  ---   This is a utility function that will calculate the discount amount.  If the discount turns out to be negative,
  ---   the function will return 0.
  ---
  ---  Development and Maintenance History:
  ---  -------------------------------------
  ---  DATE         AUTHOR                   DESCRIPTION
  ---  ----------   ------------------------ ---------------------------------------------------------
  ---  2011-10-14   Jason McCleskey          P-2039 - Invoice Selection Performance 
  --- ***************************************************************************************************************
  FUNCTION Lwx_Calc_Discount(p_unit_selling_price IN NUMBER,
                             p_unit_list_price    IN NUMBER,
                             p_line_type          IN VARCHAR2,
                             p_item_id            IN NUMBER) RETURN VARCHAR2 IS
    v_disc_amt NUMBER := 0;
    v_return   VARCHAR2(100);
  BEGIN
    IF (p_line_type = 'LINE' AND nvl(p_item_id, -9999) != gn_freight_item) THEN

      BEGIN
        v_disc_amt := ((nvl(p_unit_list_price, 0) -
                      nvl(p_unit_selling_price, 0)) /
                      nvl(p_unit_list_price, p_unit_selling_price)) * 100;
      EXCEPTION WHEN ZERO_DIVIDE THEN
          v_disc_amt := 0;
      END;

      IF v_disc_amt < 0 THEN
        v_disc_amt := 0;
      END IF;

      -- Fix rounding problem introduced by CHO
      IF v_disc_amt <> 0 THEN
        v_disc_amt := ROUND(v_disc_amt,0);
      END IF;

      v_return := to_char(v_disc_amt, '990.00') || '%';
    ELSE
      v_return := null;
    END IF;
    RETURN v_return;
  EXCEPTION WHEN OTHERS THEN
      app_error(-20001,'Error in Lwx_Calc_Discount using unit_selling_price: '
                       ||p_unit_selling_price||' and unit_list_price: '||p_unit_list_price,
                       null,sqlcode,sqlerrm);
  END Lwx_Calc_Discount;

  --- ***************************************************************************************************************
  --- Function Lwx_Get_Order_Date
  --- Description:
  ---   This is a utility function that will retrieve the Order Date from the OM module.  This will only work for those
  ---   invoices that are coming from the OM module.
  ---
  ---  Development and Maintenance History:
  ---  -------------------------------------
  ---  DATE         AUTHOR                   DESCRIPTION
  ---  ----------   ------------------------ ---------------------------------------------------------
  ---  2011-10-14   Jason McCleskey          P-2039 - Invoice Selection Performance 
  --- ***************************************************************************************************************
  FUNCTION Lwx_Get_Order_Date(p_customer_trx_id      IN NUMBER,
                              p_intfc_header_context IN VARCHAR2,
                              p_intfc_header_attr1   IN VARCHAR2) RETURN DATE IS
    v_order_date DATE;
  BEGIN

    IF (p_intfc_header_context = 'ORDER ENTRY') THEN
        SELECT ordered_date
        INTO v_order_date
        FROM oe_order_headers
        WHERE order_number = to_number(p_intfc_header_attr1);
    END IF;

    RETURN v_order_date;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      RETURN NULL;
    WHEN OTHERS THEN
      app_error(-20001,'Error in Lwx_Get_Order_Date using customer_trx_id: ' 
                       ||p_customer_trx_id||gcv_newline
                       ||' p_intfc_header_context: '||p_intfc_header_context||gcv_newline
                       ||' p_intfc_header_attr1: ' ||p_intfc_header_attr1,
                       null,sqlcode,sqlerrm);
  END Lwx_Get_Order_Date;
  
  --- ***************************************************************************************************************
  --- Function Lwx_Get_Order_Qty
  --- Description:
  ---   This is a utility function that will retrieve the Ordered Quantity from the OM module if the transaction is
  ---   generated from OM.
  ---
  ---  Development and Maintenance History:
  ---  -------------------------------------
  ---  DATE         AUTHOR                   DESCRIPTION
  ---  ----------   ------------------------ ---------------------------------------------------------
  ---  2011-10-14   Jason McCleskey          P-2039 - Invoice Selection Performance 
  --- ***************************************************************************************************************
  FUNCTION Lwx_Get_Order_Qty(p_customer_trx_id      IN NUMBER,
                             p_intfc_line_context   IN VARCHAR2,
                             p_so_line              IN VARCHAR2,
                             p_intfc_line_attr6     IN VARCHAR2,
                             p_customer_trx_line_id IN NUMBER,
                             p_line_type            IN VARCHAR2)
    RETURN NUMBER IS

    v_order_qty   NUMBER := 0;
    v_line_number OE_ORDER_LINES.LINE_NUMBER%TYPE;
    v_line_set_id OE_ORDER_LINES.LINE_SET_ID%TYPE;
    v_header_id   OE_ORDER_LINES.HEADER_ID%TYPE;
    
  BEGIN
    -- Process the logic only if the line is from the OM module and the current line is an OE Order Line,
    -- not from OE_PRICE_ADJUSTMENTS table or charges.
    IF (p_intfc_line_context = 'ORDER ENTRY' and p_so_line is not null 
        and p_line_type = 'LINE') THEN
        -- Get the order line number and line set id.
        SELECT line_number, line_set_id, header_id, ordered_quantity
        INTO v_line_number, v_line_set_id, v_header_id, v_order_qty
        FROM oe_order_lines
        WHERE line_id = to_number(p_intfc_line_attr6);

        IF v_line_set_id IS NOT NULL THEN
           -- Added up all the quantity order from the same line originally.
           SELECT nvl(sum(ordered_quantity), 0)
           INTO v_order_qty
           FROM oe_order_lines
           WHERE header_id = v_header_id
           AND line_set_id = v_line_set_id
           AND line_number = v_line_number;
        END IF;
        
    ELSE
      v_order_qty := null;
    END IF;

    RETURN v_order_qty;
  EXCEPTION WHEN OTHERS THEN
      app_error(-20001,'Error in Lwx_Get_Order_Qty using customer_trx_id: ' 
                       ||p_customer_trx_id||gcv_newline
                       ||' p_intfc_line_context: '||p_intfc_line_context||gcv_newline
                       ||' p_so_line: '||p_so_line||gcv_newline
                       ||' p_intfc_line_attr6: '||p_intfc_line_attr6||gcv_newline
                       ||' p_customer_trx_line_id: ' ||p_customer_trx_line_id,
                       null,sqlcode,sqlerrm);
  END Lwx_Get_Order_Qty;

  --- ***************************************************************************************************************
  --- Function Lwx_Get_Intl_Line_Desc
  --- Description:
  ---   This is a utility function that will retrieve the line description for the international invoice.  This is done
  ---   by first calling the standard Oracle line description function used in the BPA engine.  Then, add country of origin
  ---   and extended weight information.
  ---
  ---  Development and Maintenance History:
  ---  -------------------------------------
  ---  DATE         AUTHOR                   DESCRIPTION
  ---  ----------   ------------------------ ---------------------------------------------------------
  ---  2011-10-14   Jason McCleskey          P-2039 - Invoice Selection Performance 
  --- ***************************************************************************************************************
  FUNCTION Lwx_Get_Intl_Line_Desc(p_customer_trx_line_id IN NUMBER,
                                  p_line_type            IN VARCHAR2,
                                  p_intfc_line_context   IN VARCHAR2,
                                  p_inventory_item_id    IN NUMBER,
                                  p_so_line              IN VARCHAR2,
                                  p_qty                  IN NUMBER)
    RETURN VARCHAR2 IS
    v_desc              VARCHAR2(4000);
    
    CURSOR cur_country_and_weights IS
    SELECT nvl(els.lwx_country_of_origin,'Unknown') lwx_country_of_origin, 
           msi.unit_weight, msi.weight_uom_code
    FROM ego_lwx_secondary_agv els, mtl_system_items_b msi, mtl_parameters mp
    WHERE msi.inventory_item_id = p_inventory_item_id
    AND msi.organization_id = mp.organization_id
    AND msi.inventory_item_id = els.inventory_item_id(+)
    AND msi.organization_id = els.organization_id(+)
    AND mp.organization_code = 'ITM';

  BEGIN
    -- Call standard Oracle function to get the base line description.
    v_desc := ar_bpa_utils_pkg.fn_get_line_description(p_customer_trx_line_id);

    -- The condition to get the item additional info. is that the trx line is coming from
    -- OM module, and the line type is a LINE transaction line, not a tax line, and
    -- the line is not for shipping and processing fee, and the line is not a price adjustment
    -- line.

    IF (p_line_type = 'LINE' and p_intfc_line_context = 'ORDER ENTRY' 
        and p_inventory_item_id != gn_freight_item and p_so_line is not null) THEN
        FOR rec IN cur_country_and_weights
        LOOP 
            v_desc := substr(v_desc
                             ||' Country of Origin: '||rec.lwx_country_of_origin
                             ||' Extended Weight: '||to_char(p_qty * rec.unit_weight)
                             ||' '||rec.weight_uom_code
                            ,1,4000);
            EXIT;
        END LOOP;
    END IF;

    RETURN v_desc;

  EXCEPTION WHEN OTHERS THEN
      app_error(-20001,'Error in Lwx_Get_Intl_Line_Desc using customer_trx_line_id: ' 
                       ||p_customer_trx_line_id||gcv_newline
                       ||' p_line_type: '||p_line_type||gcv_newline
                       ||' p_inventory_item_id: '||p_inventory_item_id||gcv_newline
                       ||' p_so_line: '||p_so_line||gcv_newline
                       ||' p_qty: ' ||p_qty,
                       null,sqlcode,sqlerrm);
  END Lwx_Get_Intl_Line_Desc;

  --- ***************************************************************************************************************
  --- Function Lwx_Get_Total_Weight
  --- Description:
  ---   This is a utility function that will retrieve the total weight for each unit of measure in the weight for the invoice.
  ---
  --- Development History
  --- --------------------
  ---  Date         Name                     Description
  --- ------------  -----------------------  ---------------------------------------------------------------------
  ---  2006-07-17   Jude Lam, TITAN          - Updated the main query.
  ---  2006-09-13   Jude Lam, TITAN          - Updated the Lwx_Get_Total_Weight to say the word Total Weight in Spanish
  ---                                           when the Logo code is in Spanish.
  ---  2011-10-14   Jason McCleskey          P-2039 - Invoice Selection Performance 
  --- ***************************************************************************************************************
  FUNCTION Lwx_Get_Total_Weight(p_customer_trx_id      IN NUMBER,
                                p_intfc_header_context IN VARCHAR2)
    RETURN VARCHAR2 IS

    CURSOR v_ttl_weight_cur IS
      SELECT msi.weight_uom_code,
             nvl(sum(nvl(msi.unit_weight,0) 
                     * nvl(rctl.quantity_invoiced, rctl.quantity_credited))
                 ,0) ttl_weight
        FROM mtl_system_items_b    msi,
             ra_customer_trx_lines rctl,
             mtl_parameters        mp
       WHERE mp.organization_code = 'ITM'
         AND mp.organization_id = msi.organization_id
         AND rctl.customer_trx_id = p_customer_trx_id
         AND rctl.inventory_item_id = msi.inventory_item_id
         AND msi.inventory_item_id != gn_freight_item
         AND msi.shippable_item_flag = 'Y' 
         HAVING nvl(sum(nvl(msi.unit_weight,0) *
                        nvl(rctl.quantity_invoiced, rctl.quantity_credited)
                        )
                    ,0) != 0
       GROUP BY msi.weight_uom_code;
       
    CURSOR cur_return_message (cv_weight VARCHAR2) IS
    SELECT decode(attribute3,'BISP','Peso Total: ','Total Weight: ')
           ||cv_weight      message
    FROM ar.ra_customer_trx_all 
    WHERE customer_trx_id = p_customer_trx_id;
    
    v_return           VARCHAR2(2000):= null;
    v_ttl_weight_value VARCHAR2(500) := null;

  BEGIN
    IF p_intfc_header_context = 'ORDER ENTRY' THEN
      FOR v_ttl_weight_rec IN v_ttl_weight_cur 
      LOOP
        v_ttl_weight_value := ltrim(v_ttl_weight_value || ' ' ||
                                    to_char(v_ttl_weight_rec.ttl_weight,
                                            '999990.0000') || ' ' ||
                                    v_ttl_weight_rec.weight_uom_code);
      END LOOP;

      OPEN cur_return_message(v_ttl_weight_value);
      FETCH cur_return_message INTO v_return;
      IF cur_return_message%NOTFOUND THEN
         v_return := null;
      END IF;
      CLOSE cur_return_message;
    ELSE
      v_return := null;
    END IF;
    RETURN v_return;
  EXCEPTION WHEN OTHERS THEN
      app_error(-20001,'Error in LWX_Get_Total_Weight using customer_trx_id: ' 
                       ||p_customer_trx_id,null,sqlcode,sqlerrm);
  END LWX_Get_Total_Weight;

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
  FUNCTION LWX_Get_Use_Tax_Message(p_state_code IN VARCHAR2) RETURN VARCHAR2 IS
    v_return           VARCHAR2(240):= null;    
  BEGIN
    BEGIN
      SELECT lup.description
      INTO   v_return
      FROM   applsys.fnd_lookup_values         lup
      WHERE  lup.lookup_type = 'LWX_AR_USE_TAX_MESSAGE'
        AND  lup.lookup_code = nvl(p_state_code,'**')
        AND  lup.enabled_flag = 'Y'
        AND  lup.start_date_active <= TRUNC(SYSDATE)
        AND  NVL(lup.end_date_active,TRUNC(SYSDATE)+1) > TRUNC(SYSDATE);
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
         v_return:= '';
      WHEN OTHERS THEN
        app_error(-20001,'Error in LWX_Get_Use_Tax_Message',null,sqlcode,sqlerrm);
    END;    
    RETURN v_return;
  END LWX_Get_Use_Tax_Message;
  
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
                            ,str4 OUT VARCHAR2) RETURN number AS
        v_i    NUMBER := 1;
        v_j    NUMBER := 1;
        v_len  NUMBER := 0;
        v_part VARCHAR2(50);
        v_return NUMBER;

        TYPE v_msg_lines IS RECORD (
          v_single_line VARCHAR2(50)
          );

        TYPE v_msg_lines_tab 
          IS TABLE OF v_msg_lines
          INDEX BY BINARY_INTEGER;

        v_msg_section v_msg_lines_tab;
   
    BEGIN
      str1:= NULL;
      str2:= NULL;
      str3:= NULL;
      str4:= NULL;
      LOOP
        v_part := regexp_substr(str, '([^[:blank:]]+)', 1,  v_i);
        EXIT WHEN v_part is NULL;

        IF v_len = 0 THEN
          v_msg_section(v_j).v_single_line := v_part;
          v_len:= length(v_part);
        ELSE
          IF length(v_msg_section(v_j).v_single_line) + 1 + length(v_part) > 50 THEN
            v_j:= v_j + 1;
            v_msg_section(v_j).v_single_line:= v_part;
            v_len:= length(v_part);
          ELSE  
            v_msg_section(v_j).v_single_line:= v_msg_section(v_j).v_single_line || ' ' || v_part;
            v_len:= v_len + 1 + length(v_part);
          END IF;
        END IF;      

        v_i := v_i+1;
        v_return:= v_j;  
      END LOOP;

      FOR k in 1..v_return LOOP
        IF k = 1 THEN
          str1 := v_msg_section(k).v_single_line;
        END IF;  
        IF k = 2 THEN
          str2 := v_msg_section(k).v_single_line;
        END IF;  
        IF k = 3 THEN
          str3 := v_msg_section(k).v_single_line;
        END IF;  
        IF k = 4 THEN
          str4 := v_msg_section(k).v_single_line;
        END IF;  
      END LOOP;

      RETURN v_return;

    END lwx_split_line;

  --- ***************************************************************************************************************
  --- Function lwx_fmt_addr_with_addressee
  --- Description:
  ---   This is a utility function that calls the seeded HZ_FORMAT_PUB.format_address function, which returns
  ---   a formatted address, and then this function sticks addressee on the front, provided address lines 3 and 4 are 
  ---   not used. It is called from the BPA data templates:
  ---     ARInvoiceHeaderVVO.xml
  ---     ARInvoicePrintHeaderVVO.xml
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
    FUNCTION lwx_fmt_addr_with_addressee (p_location_id   IN NUMBER,
                                          p_party_site_id IN NUMBER) 
             RETURN varchar2 AS
      l_formatted_addr     VARCHAR2(2000);
      l_addressee          ar.hz_party_sites.addressee%TYPE;
      l_count              NUMBER;
      
    BEGIN
      l_formatted_addr:= NULL;
      
      SELECT nvl(ps.addressee,'*')
        INTO l_addressee
        FROM ar.hz_party_sites        ps 
       WHERE ps.location_id = p_location_id
       AND   ps.party_site_id = p_party_site_id;

      l_formatted_addr:= apps.HZ_FORMAT_PUB.format_address(p_location_id,null,null,'^'); 
      l_count:= regexp_count(l_formatted_addr,'\^');
      
      IF l_addressee <> '*' AND l_count < 3 THEN
        l_formatted_addr:= l_addressee || '^' || l_formatted_addr;
      END IF;  
      RETURN l_formatted_addr;
    END lwx_fmt_addr_with_addressee;  

END lwx_ar_invo_stmt_print;
/
