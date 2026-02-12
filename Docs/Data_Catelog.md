Data Dictionary for Gold Layer
Overview

The Gold Layer is the business-level data representation structured to support analytical and reporting use cases. It consists of dimension tables and fact tables for specific business metrics.

1. gold.dim_customer

Purpose:
Stores customer details enriched with demographic and geographic data.

Columns:
| Column Name            | Data Type    | Description                                                                      |
| ---------------------- | ------------ | -------------------------------------------------------------------------------- |
| **cst_id**             | INT          | Source system customer identifier.                                               |
| **cst_key**            | NVARCHAR(50) | Surrogate key uniquely identifying each customer record in the dimension table.  |
| **cst_firstname**      | VARCHAR(50)  | The customer’s first name, trimmed of leading and trailing spaces.               |
| **cst_lastname**       | VARCHAR(50)  | The customer’s last name or family name, trimmed of leading and trailing spaces. |
| **cst_marital_status** | VARCHAR(50)  | The marital status of the customer (e.g., ‘Married’, ‘Single’, ‘n/a’).           |
| **cst_gndr**           | VARCHAR(50)  | The gender of the customer (e.g., ‘Male’, ‘Female’, ‘n/a’).                      |
| **cst_create_date**    | DATE         | The date when the customer record was created in the source system.              |
| **dwh_create_date**    | DATETIME2    | The date and time when the record was created in the data warehouse.             |

2. gold.dim_products

Purpose:
Provides information about the products and their attributes.

Columns:
| Column Name              | Data Type    | Description                                                                                                    |
| ------------------------ | ------------ | -------------------------------------------------------------------------------------------------------------- |
| **product_key**          | INT          | Surrogate key uniquely identifying each product record in the product dimension table.                         |
| **product_id**           | INT          | A unique identifier assigned to the product for internal tracking and referencing.                             |
| **product_number**       | NVARCHAR(50) | A structured alphanumeric code representing the product, often used for categorization or inventory.           |
| **product_name**         | NVARCHAR(50) | Descriptive name of the product, including key details such as type, color, and size.                          |
| **category_id**          | NVARCHAR(50) | A unique identifier for the product's category, linking to its high-level classification.                      |
| **category**             | NVARCHAR(50) | The broader classification of the product (e.g., Bikes, Components) to group related items.                    |
| **subcategory**          | NVARCHAR(50) | A more detailed classification of the product within the category, such as product type.                       |
| **maintenance_required** | NVARCHAR(50) | Indicates whether the product requires maintenance (e.g., ‘Yes’, ‘No’).                                        |
| **cost**                 | INT          | The cost or base price of the product, measured in monetary units.                                             |
| **product_line**         | NVARCHAR(50) | The specific product line or series to which the product belongs (e.g., Road, Mountain, Other Sales, Touring). |
| **start_date**           | DATE         | The date when the product became available for sale or use.                                                    |

3. gold.fact_sales

Purpose:
Stores transaction sales data for analytical purposes.

Columns:
| Column Name       | Data Type    | Description                                                                                 |
| ----------------- | ------------ | ------------------------------------------------------------------------------------------- |
| **order_number**  | NVARCHAR(50) | A unique alphanumeric identifier for each sales order (e.g., ‘SO54496’).                    |
| **product_key**   | INT          | Surrogate key linking the order to the product dimension table.                             |
| **customer_key**  | INT          | Surrogate key linking the order to the customer dimension table.                            |
| **order_date**    | DATE         | The date when the order was placed.                                                         |
| **shipping_date** | DATE         | The date when the order was shipped to the customer.                                        |
| **due_date**      | DATE         | The date when the order payment was due.                                                    |
| **sales_amount**  | INT          | The total monetary value of the sale for the line item, in whole currency units (e.g., 25). |
| **quantity**      | INT          | The number of units of the product ordered for the line item (e.g., 1).                     |
| **price**         | INT          | The price per unit of the product for the line item, in whole currency units (e.g., 25).    |
