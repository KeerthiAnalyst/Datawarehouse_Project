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

exec bronze.load_bronzee
go
create or alter procedure bronze.load_bronzee as
begin
  Declare @start_time DATETIME,@end_time DATETIME ,@batch_start_time datetime,@batch_end_time datetime;
  begin try
    SET @batch_start_time=GETDATE()
	PRINT '====================================='
	PRINT 'LOADING BRONZE LAYER'
	PRINT '====================================='
	SET @start_time= GETDATE()
	PRINT '-------------------------------------'
	PRINT 'LOADING CRM TABLES'
	PRINT '-------------------------------------'
	
	SET @start_time= GETDATE()
	PRINT'>> TRUNCATING TABLE:Bronze.crm_cust_info'
	Truncate table Bronze.crm_cust_info

	PRINT'>> INSERTING DATA INTO:Bronze.crm_cust_info'
	BULK INSERT Bronze.crm_cust_info
	FROM 'D:\KEERTHI PROJECT\sql\sql-data-warehouse-project\datasets\source_crm\cust_info.csv'
	WITH (
		FIRSTROW = 2,
		FIELDTERMINATOR = ',',
		ROWTERMINATOR = '\n'
	);
	SET @end_time= GETDATE()
	PRINT '>> Load Duration :' + cast(datediff(second,@start_time,@end_time)as nvarchar) + 'Seconds';
	PRINT '==============================='

	SET @start_time=GETDATE()
	PRINT'>> TRUNCATING TABLE:Bronze.crm_prd_info'
	Truncate table Bronze.crm_prd_info

	PRINT'>> INSERTING DATA INTO:Bronze.crm_prd_info'
	BULK INSERT Bronze.crm_prd_info
	FROM 'D:\KEERTHI PROJECT\sql\sql-data-warehouse-project\datasets\source_crm\prd_info.csv'
	WITH (
		FIRSTROW = 2,
		FIELDTERMINATOR = ',',
		ROWTERMINATOR = '\n'
	);
	SET @end_time= GETDATE()
	PRINT '>> Load Duration :' + cast(datediff(second,@start_time,@end_time)as nvarchar) + 'Seconds';
	PRINT '==============================='

	SET @start_time=GETDATE()
	PRINT'>> TRUNCATING TABLE:bronze.crm_sales_details'
	Truncate table bronze.crm_sales_details

	PRINT'>> INSERTING DATA INTO:bronze.crm_sales_details'
	BULK INSERT Bronze.crm_sales_details
	FROM 'D:\KEERTHI PROJECT\sql\sql-data-warehouse-project\datasets\source_crm\sales_details.csv'
	WITH (
		FIRSTROW = 2,
		FIELDTERMINATOR = ',',
		ROWTERMINATOR = '\n'
	);		
	SET @end_time= GETDATE()
	PRINT '>> Load Duration :' + cast(datediff(second,@start_time,@end_time)as nvarchar) + 'Seconds';
	PRINT '==============================='


	PRINT '-------------------------------------'
	PRINT 'LOADING ERP TABLES'
	PRINT '-------------------------------------'

	SET @start_time=GETDATE()
	PRINT'>> TRUNCATING TABLE:Bronze.erp_cust_az12'
	Truncate table Bronze.erp_cust_az12

	PRINT'>> INSERTING DATA INTO:Bronze.erp_cust_az12'
	BULK INSERT Bronze.erp_cust_az12
	FROM 'D:\KEERTHI PROJECT\sql\sql-data-warehouse-project\datasets\source_erp\cust_az12.csv'
	WITH (
		FIRSTROW = 2,
		FIELDTERMINATOR = ',',
		ROWTERMINATOR = '\n'
	);
	SET @end_time= GETDATE()
	PRINT '>> Load Duration :' + cast(datediff(second,@start_time,@end_time)as nvarchar) + 'Seconds';
	PRINT '==============================='

	SET @start_time=GETDATE()
	PRINT'>> TRUNCATING TABLE:Bronze.erp_loc_a101'
	Truncate table Bronze.erp_loc_a101

	PRINT'>> INSERTING DATA INTO:Bronze.erp_loc_a101'
	BULK INSERT Bronze.erp_loc_a101
	FROM 'D:\KEERTHI PROJECT\sql\sql-data-warehouse-project\datasets\source_erp\loc_a101.csv'
	WITH (
		FIRSTROW = 2,
		FIELDTERMINATOR = ',',
		ROWTERMINATOR = '\n'
	);
	SET @end_time= GETDATE()
	PRINT '>> Load Duration :' + cast(datediff(second,@start_time,@end_time)as nvarchar) + 'Seconds';
	PRINT '==============================='

	SET @start_time=GETDATE()
	PRINT'>> TRUNCATING TABLE:bronze.erp_px_cat_g1v2'
	Truncate table bronze.erp_px_cat_g1v2

	PRINT'>> INSERTING DATA INTO:bronze.erp_px_cat_g1v2'
	BULK INSERT Bronze.erp_px_cat_g1v2
	FROM 'D:\KEERTHI PROJECT\sql\sql-data-warehouse-project\datasets\source_erp\px_cat_g1v2.csv'
	WITH (
		FIRSTROW = 2,
		FIELDTERMINATOR = ',',
		ROWTERMINATOR = '\n'
	);
	SET @end_time= GETDATE()
	PRINT '>> Load Duration :' + cast(datediff(second,@start_time,@end_time)as nvarchar) + 'Seconds';
	PRINT '==============================='


	SET @batch_end_time= GETDATE()
	PRINT '==============================='
	PRINT 'LORDING BRONZE LAYER IS COMPLETED'
	PRINT '>> Load Duration :' + cast(datediff(second,@batch_start_time,@batch_end_time)as nvarchar) + 'Seconds';
	PRINT '==============================='
 end try
 begin catch
	PRINT '========================================='
	PRINT 'Error Occured During Loading Bronze layer'
	PRINT 'Error Message' + ERROR_MESSAGE()
	PRINT 'Error Number' + cast(ERROR_number()as nvarchar)
	PRINT 'Error State' + cast(ERROR_state()as nvarchar)
	PRINT '=========================================='
 end catch
end;
