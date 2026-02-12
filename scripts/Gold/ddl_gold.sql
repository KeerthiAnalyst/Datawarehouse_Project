use datawarehouse

if OBJECT_ID('gold.dim_customer' ,'V') is not null
	drop VIEW gold.dim_customer;
go
CREATE VIEW gold.dim_customer AS 
SELECT 
	ROW_NUMBER()over(order by cst_id) as customer_key,--surrogate key is sys-gen unique identifier assigned to each records in table
	cc.cst_id as customer_id,
	cc.cst_key as customer_number,
	cc.cst_firstname as first_name,
	cc.cst_lastname as last_name,
	le.cntry as country,
	cc.cst_marital_status as marital_status,
	case when cc.cst_gndr !='n/a' then cc.cst_gndr -- CRM is the master for gender info
			 else coalesce(ee.gen,'n/a')
			 end as gender,
	ee.bdate as birthdate,
	cc.cst_create_date as create_date
From silver.crm_cust_info cc
left join silver.erp_cust_az12 ee on cc.cst_key=ee.cid
left join silver.erp_loc_a101 le on cc.cst_key=le.cid

if OBJECT_ID('gold.dim_product' ,'V') is not null
	drop VIEW gold.dim_product;

go
create view gold.dim_product as
select 
	ROW_NUMBER()over(order by prd_key,prd_start_dt) as product_key,
	pn.prd_id as product_id,
	pn.prd_key as product_number,
	pn.prd_nm as product_name,
	pn.prd_cat_id as category_id,
	pc.cat as category,
	pc.subcat as subcategory,
	pc.maintenance,
	pn.prd_cost as cost,
	pn.prd_line as product_line,
	pn.prd_start_dt as start_date
from silver.crm_prd_info pn
left join silver.erp_px_cat_g1v2 pc
on pn.prd_cat_id=pc.id
where pn.prd_end_dt is null -- filter out the historical data

if OBJECT_ID('gold.fact_sales' ,'V') is not null
	drop VIEW gold.fact_sales;
go
create view gold.fact_sales as
select 
	sa.sls_ord_num as order_number,
	pr.product_key,
	cd.customer_key,
	sa.sls_order_dt as order_date,
	sa.sls_ship_dt as shipment_date,
	sa.sls_due_dt as due_date,
	sa.sls_sales as sales_amount,
	sa.sls_quantity as quantity,
	sa.sls_price as price
from silver.crm_sales_details sa
left join Gold.dim_product pr
on sa.sls_prd_key=pr.product_number
left join Gold.dim_customer cd
on sa.sls_cust_id=cd.customer_id
