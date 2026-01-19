--BRONZE_LAYER--

use datawarehouse


if OBJECT_ID('bronze.crm_cust_info' ,'u') is not null
	drop table bronze.crm_cust_info;
create table bronze.crm_cust_info(
	cst_id int,
	cst_key nvarchar(50),
	cst_firstname varchar(50),
	cst_lastname varchar(50),
	cst_material_status varchar(50),
	cst_gndr varchar(50),
	cst_create_date date
)
select * from bronze.crm_cust_info


if OBJECT_ID('bronze.crm_prd_info' ,'u') is not null
	drop table bronze.crm_prd_info;
create table bronze.crm_prd_info(
	prd_id int,
	prd_key nvarchar(50),
	prd_nm nvarchar(50),
	prd_cost int,
	prd_line varchar(50),
	prd_start_dt varchar(50),
	prd_end_dt varchar(50)
)
select * from bronze.crm_prd_info


if OBJECT_ID('bronze.crm_sales_details' ,'u') is not null
	drop table bronze.crm_sales_details;
create table bronze.crm_sales_details(
	sls_ord_num nvarchar(50),
	sls_prd_key nvarchar(50),
	sls_cust_id int,
	sls_order_dt int,
	sls_ship_dt int,
	sls_due_dt int,
	sls_sales int,
	sls_quantity int,
	sls_price int
)
select * from bronze.crm_sales_details


if OBJECT_ID('bronze.erp_cust_az12' ,'u') is not null
	drop table bronze.erp_cust_az12;
create table bronze.erp_cust_az12(
	cid nvarchar(50),
	bdate date,
	gen nvarchar(50)
)
select * from bronze.erp_cust_az12

if OBJECT_ID('bronze.erp_loc_a101' ,'u') is not null
	drop table bronze.erp_loc_a101;
create table bronze.erp_loc_a101(
	cid nvarchar(50),
	cntry nvarchar(50)
)
select * from bronze.erp_loc_a101


if OBJECT_ID('bronze.erp_px_cat_g1v2' ,'u') is not null
	drop table bronze.erp_px_cat_g1v2;
create table bronze.erp_px_cat_g1v2(
	id nvarchar(50),
	cat nvarchar(50),
	subcat nvarchar(50),
	maintenance nvarchar(50)
)
select * from bronze.erp_px_cat_g1v2
