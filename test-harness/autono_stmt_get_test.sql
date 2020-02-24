-- -*- tab-width: 4 indent-tabs-mode: nil -*-
/*
At present, we must create this inside the apps schema,
since my user schema, rstewar, doesn't have the 
create or replace package privilege...
*/
create or replace package autono_stmt_gen_test
is
  procedure
  invoke_gen_con_stmt_tbls(
      p_statement_cycle_nme IN VARCHAR2
    , p_customer_nbr        IN VARCHAR2
    , p_stmt_as_of_date     IN VARCHAR2
    , p_debug_flag          IN VARCHAR2  
  )
  ;
  procedure
  copy_stmt_data(p_send_to_cust_nbr varchar2, p_statement_cycle_id varchar2)
  ;
end;
/

create or replace package body autono_stmt_gen_test
is
  procedure
  invoke_gen_con_stmt_tbls(
      p_statement_cycle_nme IN VARCHAR2  -- REQUIRED
    --
    -- Need to supply this to keep it "narrowed":
    , p_customer_nbr        IN VARCHAR2  
    --
    -- This is best supplied as well, as the program will otherwise
    -- derive its own default:
    , p_stmt_as_of_date     IN VARCHAR2
    -- 
    , p_debug_flag          IN VARCHAR2  
  )
  is
    -- We require a mechanism to invoke the 
    --   lwx_ar_invo_stmt_print.Generate_Con_Stmt
    -- procedure, and generate some data with it, and then
    -- to save those data to the above "tst" tables 
    -- in the rstewar schema in an autonomous
    -- transaction so that the data generated by the
    -- call to
    --   lwx_ar_invo_stmt_print.Generate_Con_Stmt
    -- can be rolled back.
    --
    -- "Dummy" parameter values demanded by Oracle framework, etc:
    l_errbuf varchar2(2000);
    l_retcode number;
    --
  begin
    lwx_ar_invo_stmt_print.Generate_Con_Stmt(
        errbuf => l_errbuf
      , retcode => l_retcode
      , p_statement_cycle_nme => p_statement_cycle_nme
      , p_customer_nbr => p_customer_nbr
      , p_stmt_as_of_date => p_stmt_as_of_date
      , p_debug_flag => p_debug_flag
    );
    --
    -- First, copy the data produced by the preceding into the
    -- "tst_lwx_ar_stmt*" tables, and commit those results
    -- via an autonomous transaction:
    copy_stmt_data(p_customer_nbr, p_statement_cycle_nme);
    --
    -- Now, rollback the work that was done by the call to
    --   lwx_ar_invo_stmt_print.Generate_Con_Stmt
    -- in order to avoid making persistent changes to the regular
    -- application "lwx_ar_stmt*" tables:
    rollback; 
  end;
  --
  -- We must copy by identifying the header-record's
  -- requisite:
  --   send_to_cust_nbr ::=  a copy of the account number that was passed in, the p_customer_nbr
  --   statement_cycle_id ::=  a copy of the p_statement_cycle_nme parameter, I believe...
  --   
  procedure
  copy_stmt_data(p_send_to_cust_nbr varchar2, p_statement_cycle_id varchar2)
  is
    pragma autonomous_transaction;
  begin
    insert into rstewar.tst_lwx_ar_stmt_line_details
    select dt.*
    from lwx.lwx_ar_stmt_line_details dt, rstewar.v_ar_stmt_info si
    where
        si.send_to_cust_nbr = p_send_to_cust_nbr
    and si.statement_cycle_id = p_statement_cycle_id
    and dt.stmt_line_dtl_id = si.stmt_line_dtl_id
    ;
    --
    insert into rstewar.tst_lwx_ar_stmt_lines
    select sl.*
    from lwx.lwx_ar_stmt_lines sl, rstewar.v_ar_stmt_info si
    where
        si.send_to_cust_nbr = p_send_to_cust_nbr
    and si.statement_cycle_id = p_statement_cycle_id
    and si.stmt_line_id = sl.stmt_line_id
    ;
    --
    insert into rstewar.tst_lwx_ar_stmt_headers 
    select sh.*
    from lwx.lwx_ar_stmt_headers sh, rstewar.v_ar_stmt_info si
    where
        si.send_to_cust_nbr = p_send_to_cust_nbr
    and si.statement_cycle_id = p_statement_cycle_id
    and si.stmt_hdr_id = sh.stmt_hdr_id
    ;
    --
    -- the data inserted into the "tst_lwx_ar_stmt*" tables must be saved:
    commit; 
  end;
  --
end autono_stmt_gen_test;
/