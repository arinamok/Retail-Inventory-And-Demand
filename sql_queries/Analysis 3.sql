-- Business Analysis

-- Stockout Rate
SELECT 
    AVG(CAST(Stockout AS FLOAT)) AS stockout_rate
FROM sales_data;

-- Overstock Rate
SELECT 
    AVG(CAST(Overstock AS FLOAT)) AS overstock_rate
FROM sales_data;

-- Stockout by Category
SELECT 
    Category,
    AVG(CAST(Stockout AS FLOAT)) AS stockout_rate
FROM sales_data
GROUP BY Category
ORDER BY stockout_rate DESC;

-- Overstock by Category
SELECT 
    Category,
    AVG(CAST(Overstock AS FLOAT)) AS overstock_rate
FROM sales_data
GROUP BY Category
ORDER BY overstock_rate DESC;

-- Top Stockout Products
SELECT TOP 10
    Product_ID,
    AVG(CAST(Stockout AS FLOAT)) AS stockout_rate
FROM sales_data
GROUP BY Product_ID
ORDER BY stockout_rate DESC;

-- Region Level Risk
SELECT
    Region,
    AVG(CAST(Overstock AS FLOAT)) AS overstock_rate,
    AVG(CAST(Stockout AS FLOAT)) AS stockout_rate
FROM sales_data
GROUP BY Region;

-- Promotion Performance. Did promotions actually increase demand and sales?
SELECT
    Promotion,
    AVG(Demand) AS avg_demand,
    AVG(Units_Sold) AS avg_units_sold,
    AVG(CAST(Stockout AS FLOAT)) AS stockout_rate
FROM sales_data
GROUP BY Promotion;

SELECT *
INTO sales_data_final
FROM sales_data;

SELECT *
FROM sales_data_final;