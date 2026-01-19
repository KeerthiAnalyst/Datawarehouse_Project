-- STORED PROCEDURE--

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
