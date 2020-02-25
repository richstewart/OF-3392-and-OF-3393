-- -*- tab-width: 4 indent-tabs-mode: nil -*-
/*
 Within the rstewar schema:
*/
/* 
This sequence is to be used to help distinguish test runs apart.
We shall use it to label a test run within the stored procedure which
copies data from the "main" statement-application tables into the
"tst_lwx_ar*" tables created herein:
*/
create sequence stmt_tst_seq;

create table tst_lwx_ar_stmt_headers as select * from lwx.lwx_ar_stmt_headers where 0=1;
grant select,insert,delete,update on tst_lwx_ar_stmt_headers to apps;
alter table tst_lwx_ar_stmt_headers add (test_date date, test_sequence number);

create table tst_lwx_ar_stmt_lines as select * from lwx.lwx_ar_stmt_lines where 0=1;
grant select,insert,delete,update on tst_lwx_ar_stmt_lines to apps;
alter table tst_lwx_ar_stmt_lines add (test_date date, test_sequence number);

create table tst_lwx_ar_stmt_line_details as select * from lwx.lwx_ar_stmt_line_details where 0=1;
grant select,insert,delete,update on tst_lwx_ar_stmt_line_details to apps;
alter table tst_lwx_ar_stmt_line_details add (test_date date, test_sequence number);
