-- Add Overstock column
ALTER TABLE sales_data
ADD Overstock INT;

SELECT *
FROM sales_data;

-- Fix Overstock using average demand
WITH demand_calc AS (
    SELECT
        Store_ID,
        Product_ID,
        AVG(Demand) AS avg_daily_demand
    FROM sales_data
    GROUP BY Store_ID, Product_ID
)

UPDATE s
SET Overstock =
    CASE
        WHEN s.Inventory_Level > (d.avg_daily_demand * 5)
        THEN 1
        ELSE 0
    END
FROM sales_data s
JOIN demand_calc d
    ON s.Store_ID = d.Store_ID
    AND s.Product_ID = d.Product_ID;

-- Overstock rate
SELECT 
    AVG(CAST(Overstock AS FLOAT)) AS Overstock
FROM sales_data;

-- Overstock by category
SELECT 
    Category,
    AVG(CAST(Overstock AS FLOAT)) AS overstock_rate
FROM sales_data
GROUP BY Category
ORDER BY overstock_rate DESC;

-- Add Stockout column
ALTER TABLE sales_data
ADD Stockout INT;

SELECT *
FROM sales_data;

-- Did demand exceed supply? 1 if sold all available inventory, 0 if still had stock
UPDATE sales_data
SET Stockout = 
    CASE 
        WHEN Units_Sold >= Inventory_Level THEN 1
        ELSE 0
    END;

SELECT 
    Stockout,
    COUNT(*) AS total_rows
FROM sales_data
GROUP BY Stockout;

-- Calculate stockout rate
SELECT 
    AVG(CAST(Stockout AS FLOAT)) AS stockout_rate
FROM sales_data;

-- Stockout by category
SELECT 
    Category,
    AVG(CAST(Stockout AS FLOAT)) AS stockout_rate
FROM sales_data
GROUP BY Category
ORDER BY stockout_rate DESC;

-- Calculate average daily demand
SELECT 
    Store_ID,
    Product_ID,
    AVG(Demand) AS avg_daily_demand
FROM sales_data
GROUP BY Store_ID, Product_ID;

-- Create CTE
-- How much inventory do we need before we place a new order? If lower than the reorder_point, then reorder.
WITH demand_calc AS (
    SELECT 
        Store_ID,
        Product_ID,
        AVG(Demand) * 3 AS reorder_point
    FROM sales_data
    GROUP BY Store_ID, Product_ID
)
SELECT *
FROM demand_calc;

-- Create Reorder_Needed
ALTER TABLE sales_data
ADD Reorder_Needed INT;

-- At what inventory level should we place a new order?
WITH demand_calc AS (
    SELECT
        Store_ID,
        Product_ID,
        AVG(Demand) AS reorder_point
    FROM sales_data
    GROUP BY Store_ID, Product_ID
)

UPDATE s
SET Reorder_Needed =
    CASE
        WHEN s.Inventory_Level < (d.reorder_point * 5)
        THEN 1
        ELSE 0
    END
FROM sales_data s
JOIN demand_calc d
    ON s.Store_ID = d.Store_ID
    AND s.Product_ID = d.Product_ID;

-- Check 
SELECT 
    Reorder_Needed,
    COUNT(*) AS total
FROM sales_data
GROUP BY Reorder_Needed;

-- Check reorder rate
SELECT 
    AVG(CAST(Reorder_Needed AS FLOAT)) AS reorder_rate
FROM sales_data;


-- UPDATE: inventory sold out AND demand exceeded inventory
UPDATE sales_data
SET Stockout =
    CASE
        WHEN Units_Sold >= Inventory_Level
             AND Demand > Inventory_Level
        THEN 1
        ELSE 0
    END;

-- Creating Forecasting Features
-- Month
ALTER TABLE sales_data
ADD Month_Num INT;

UPDATE sales_data
SET Month_Num = MONTH(Date);

-- Day of the Week
ALTER TABLE sales_data
ADD Day_Of_Week INT;

UPDATE sales_data
SET Day_Of_Week = DATEPART(WEEKDAY, Date);

