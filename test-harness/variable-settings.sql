var p_customer_nbr number
var customer_id number
var statement_cycle_nme varchar2(50)

begin
  :p_customer_nbr := &1; -- carried in from command line!
  select 
    sc.name
  , ac.cust_account_id
  into
    :statement_cycle_nme
  , :customer_id
  from
    hz_cust_accounts ac
  , ar_statement_cycles sc
  , hz_customer_profiles hcp
  where
      ac.account_number = :p_customer_nbr
  and sc.statement_cycle_id = hcp.statement_cycle_id
  and ac.cust_account_id = hcp.cust_account_Id
  and hcp.site_use_id is null
  ;
end;
/
