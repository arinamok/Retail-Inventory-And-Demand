-- DATA PROFILING
-- Preview the data
SELECT TOP 10 *
FROM sales_data;

-- Row count
SELECT COUNT(*) AS total_rows
FROM sales_data;

-- Check for NULLs
SELECT 
    SUM(CASE WHEN Date IS NULL THEN 1 ELSE 0 END) AS Date_nulls,
    SUM(CASE WHEN Store_ID IS NULL THEN 1 ELSE 0 END) AS Store_nulls,
    SUM(CASE WHEN Product_ID IS NULL THEN 1 ELSE 0 END) AS Product_nulls,
    SUM(CASE WHEN Demand IS NULL THEN 1 ELSE 0 END) AS Demand_nulls
FROM sales_data;

-- Check for duplicates
SELECT 
    Store_ID,
    Product_ID,
    Date,
    COUNT(*) AS duplicate_count
FROM sales_data
GROUP BY Store_ID, Product_ID, Date
HAVING COUNT(*) > 1;

-- Check for logical errors
SELECT *
FROM sales_data
WHERE Units_Sold > Inventory_Level;

-- Check for negative values
SELECT *
FROM sales_data
WHERE 
    Inventory_Level < 0 
    OR Units_Sold < 0
    OR Demand < 0;

-- Check for unique counts
SELECT 
    COUNT(DISTINCT Store_ID) AS total_stores,
    COUNT(DISTINCT Product_ID) AS total_products,
    COUNT(DISTINCT Category) AS total_categories,
    COUNT(DISTINCT Region) AS total_regions
FROM sales_data;


