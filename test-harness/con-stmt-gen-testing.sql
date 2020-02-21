-- -*- tab-width: 4 indent-tabs-mode: nil -*-
/* 
 Within the rstewar schema:
*/
create table tst_lwx_ar_stmt_headers as select * from lwx.lwx_ar_stmt_headers where 0=1;
grant select,insert,delete,update on tst_lwx_ar_stmt_headers to apps;

create table tst_lwx_ar_stmt_lines as select * from lwx.lwx_ar_stmt_lines where 0=1;
grant select,insert,delete,update on tst_lwx_ar_stmt_lines to apps;

create table tst_lwx_ar_stmt_line_details as select * from lwx.lwx_ar_stmt_line_details where 0=1;
grant select,insert,delete,update on tst_lwx_ar_stmt_line_details to apps;

create or replace procedure
auton_copy_stmt_to_tst_tbls(
