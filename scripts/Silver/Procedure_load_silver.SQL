-- STORED PROCEDURE--

exec Silver.load_silver
go
create or alter procedure Silver.load_silver as
begin
	declare @start_time datetime ,@end_time datetime,@batch_start_time datetime,@batch_end_time datetime
	begin try
	set @batch_start_time=GETDATE()
    PRINT '====================================='
	PRINT 'LOADING SILVER LAYER'
	PRINT '====================================='
	
	PRINT '-------------------------------------'
	PRINT 'LOADING CRM TABLES'
	PRINT '-------------------------------------'
	
	set @start_time=GETDATE()
	PRINT'>> TRUNCATING TABLE:SILVER.crm_cust_info'
	Truncate table Silver.crm_cust_info
	PRINT'>> INSERTING DATA INTO:silver.crm_cust_info'

Insert into Silver.crm_cust_info(
		cst_id,
		cst_key,
		cst_firstname,
		cst_lastname,
		cst_gndr,
		cst_material_status,
		cst_create_date
		
) 
select cst_id,
	   cst_key,
	   Trim(cst_firstname) as cst_firstname,
	   Trim(cst_lastname) as cst_lastname,
	   case when UPPER(trim(cst_material_status))='M'then 'Married'
            when UPPER(trim(cst_material_status))='S' then 'Single'
	   else 'n/a'
	   end as cst_material_status,
	   case when UPPER(trim(cst_gndr))='M'then 'Male'
            when UPPER(trim(cst_gndr))='F' then 'Female'
	   else 'n/a'
	   end as cst_gndr,
	   cst_create_date
from(select * ,row_number()over(partition by cst_id order by cst_create_date desc)as flag
from Bronze.crm_cust_info
where cst_id is not null
)t
where t.flag=1
set @end_time=GETDATE()
	PRINT '>>Load_Duration:'+ cast(datediff(second,@start_time,@end_time) as varchar) + 'Seconds';
	print '============================================='
	set @start_time=GETDATE()
	PRINT'>> TRUNCATING TABLE:SILVER.crm_prd_info'
	Truncate table Silver.crm_prd_info
	PRINT'>> INSERTING DATA INTO:silver.crm_prd_info'

Insert into silver.crm_prd_info(
	prd_id,
	prd_key,
	prd_cat_id,
	prd_nm ,
	prd_cost ,
	prd_line ,
	prd_start_dt,
	prd_end_dt 

)
select prd_id,
	 substring(prd_key,7,len(prd_key))as prd_key,
	 replace(substring(prd_key,1,5),'-','_')as prd_cat_id,
	 prd_nm,
	 coalesce(prd_cost,0) as prd_cost ,
     case when UPPER(trim(prd_line))='R'then 'Road'
		 when UPPER(trim(prd_line))='S' then 'Other Sales'
		 when UPPER(trim(prd_line))='M'then 'Mountain'
		 when UPPER(trim(prd_line))='T'then 'Touring'
	 else 'N/A'
	 end as prd_line,
	 cast(prd_start_dt as date) as prd_Start_dt,
     cast(lead(prd_start_dt)over(partition by prd_key order by prd_start_dt)-1 as date)  as prd_end_dt
	 from Bronze.crm_prd_info
set @end_time=GETDATE()
	PRINT '>>Load_Duration:'+ cast(datediff(second,@start_time,@end_time) as varchar) + 'Seconds'
	print '============================================='
		
	set @start_time=GETDATE()
	PRINT'>> TRUNCATING TABLE:SILVER.crm_sales_details'
	Truncate table Silver.crm_sales_details
	PRINT'>> INSERTING DATA INTO:silver.crm_sales_details'

Insert into silver.crm_sales_details(
	sls_ord_num,
	sls_prd_key ,
	sls_cust_id ,
	sls_order_dt,
	sls_ship_dt,
	sls_due_dt ,
	sls_sales,
	sls_quantity ,
	sls_price 

)
select sls_ord_num,
	   sls_prd_key,
	   sls_cust_id,
	   case when sls_order_dt <= 0 or len(sls_order_dt)!=8 then null
	        else cast(cast(sls_order_dt as varchar)as date)
			end as sls_order_dt,
       case when sls_ship_dt <= 0 or len(sls_ship_dt)!=8 then null
	        else cast(cast(sls_ship_dt as varchar)as date)
			end as sls_ship_dt,
       case when sls_due_dt <= 0 or len(sls_due_dt)!=8 then null
	        else cast(cast(sls_due_dt as varchar)as date)
			end as sls_due_dt,
       case when sls_sales <=0 or sls_sales is null or  sls_sales!=abs(sls_quantity*sls_price)
	        then sls_quantity*sls_price
			else sls_sales
			end as sls_sales,
        sls_quantity,
	   case when sls_price is null or sls_price<=0 then sls_sales/nullif(sls_quantity,0)
	        else sls_price
			end as sls_price
from bronze.crm_sales_details
set @end_time=GETDATE()
	PRINT '>>Load_Duration:'+ cast(datediff(second,@start_time,@end_time) as varchar) + 'Seconds'
	print '============================================='
	
	set @start_time=GETDATE()
	PRINT'>> TRUNCATING TABLE:SILVER.erp_cust_az12'
	Truncate table Silver.erp_cust_az12
	PRINT'>> INSERTING DATA INTO:silver.erp_cust_az12'

insert into silver.erp_cust_az12(
	cid ,
	bdate ,
	gen 
	)
 select case when cid like 'NAS%' then SUBSTRING(cid,4,len(cid))
        else cid
		end as cid,
		case when bdate >getdate() then null
		else bdate
		end as bdate,
		case when upper(trim(gen)) in('M','Male') then 'Male'
		     when upper(trim(gen)) in('F','Female') then 'Female'
			 else 'n/a'
			 end as gen
 from Bronze.erp_cust_az12
 set @end_time=GETDATE()
	PRINT '>>Load_Duration:'+ cast(datediff(second,@start_time,@end_time) as varchar) + 'Seconds'
	print '============================================='	
	set @start_time=GETDATE()
	PRINT'>> TRUNCATING TABLE:SILVER.erp_loc_a101'
	Truncate table Silver.erp_loc_a101
	PRINT'>> INSERTING DATA INTO:silver.erp_loc_a101'

insert into silver.erp_loc_a101(
	cid ,
	cntry 
)
select replace(cid,'-','') as cid,
	case when trim(cntry) in ('USA','US') THEN 'United States'
            when trim(cntry) = 'DE' THEN 'Germany'
			when trim(cntry) = '' or trim(cntry) is null  THEN 'n/a'
			else cntry
	 end as cntry
from Bronze.erp_loc_a101
set @end_time=GETDATE()     
	PRINT '>>Load_Duration:'+ cast(datediff(second,@start_time,@end_time) as varchar) + 'Seconds'
	print '============================================='
    set @start_time=GETDATE()	
	PRINT'>> TRUNCATING TABLE:SILVER.erp_px_cat_g1v2'
	Truncate table Silver.erp_px_cat_g1v2
	PRINT'>> INSERTING DATA INTO:silver.erp_px_cat_g1v2'

 insert into silver.erp_px_cat_g1v2(
 id,
 cat,
 subcat,
 maintenance)
 select id,cat,subcat,maintenance 
 from Bronze.erp_px_cat_g1v2
 set @end_time=GETDATE()
 PRINT '>>Load_Duration:'+ cast(datediff(second,@start_time,@end_time) as varchar) + 'Seconds'
 print '============================================='
 SET @batch_end_time=GETDATE()
 PRINT '==============================='
	PRINT 'LORDING SILVER LAYER IS COMPLETED'
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
 end
