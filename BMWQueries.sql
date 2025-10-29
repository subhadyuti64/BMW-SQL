-- These SQL queries are written for educational and analytical purposes.
-- They can be directly implemented and tested on the actual BMW sales dataset attached in the Repository.
-- Execute this script in MySQL Workbench (MySQL 8+). 
-- Before running the queries, import or load the dataset into the table `BMW`.

CREATE DATABASE IF NOT EXISTS bmw_sales;
USE bmw_sales;

DROP TABLE IF EXISTS BMW;
CREATE TABLE BMW (
  `Model` TEXT,
  `Year` INTEGER,
  `Region` TEXT,
  `Color` TEXT,
  `Fuel_Type` TEXT,
  `Transmission` TEXT,
  `Engine_Size_L` DOUBLE,
  `Mileage_KM` INTEGER,
  `Price_USD` INTEGER,
  `Sales_Volume` INTEGER,
  `Sales_Classification` TEXT
);

-- 1) View a small sample of the table
SELECT * FROM bmw_sales_data LIMIT 10;

-- 2) Total number of records
SELECT COUNT(*) AS total_records FROM BMW;

-- 3) Count distinct models
SELECT COUNT(DISTINCT `Model`) AS distinct_models FROM BMW;

-- 4) Average and total car price (cast c9)
SELECT ROUND(AVG(CAST(Price_USD AS SIGNED)),2) AS avg_price_usd,
       ROUND(SUM(CAST(Price_USD AS SIGNED)),2) AS total_price_usd
FROM BMW;

-- 5) Average price by model
SELECT `Model`, ROUND(AVG(Price_USD),2) AS avg_price
FROM BMW
GROUP BY `Model`
ORDER BY avg_price DESC;

-- 6) Average price by fuel type
SELECT `Fuel_Type`, ROUND(AVG(Price_USD),2) AS avg_price
FROM BMW
GROUP BY `Fuel_Type`
ORDER BY avg_price DESC;

-- 7) Count cars sold per year (records)
SELECT `Year`, COUNT(*) AS total_records
FROM BMW
GROUP BY `Year`
ORDER BY `Year`;

-- 8) Total sales volume per year (units)
SELECT `Year`, SUM(Sales_Volume) AS total_sales_volume
FROM BMW
GROUP BY `Year`
ORDER BY `Year`;

-- 9) Total revenue per year (Price * Units)
SELECT `Year`, ROUND(SUM(Price_USD * Sales_Volume),2) AS total_revenue
FROM BMW
GROUP BY `Year`
ORDER BY total_revenue DESC;

-- 10) Highest price per model
SELECT `Model`, MAX(Price_USD) AS max_price
FROM BMW
GROUP BY `Model`
ORDER BY max_price DESC;

-- 11) Top 10 models by total revenue (Price * Units)
SELECT `Model`,
       ROUND(SUM(Price_USD * Sales_Volume),2) AS total_revenue,
       SUM(Sales_Volume) AS total_units
FROM BMW
GROUP BY `Model`
ORDER BY total_revenue DESC
LIMIT 10;

-- 12) Average price by Region and Fuel_Type
SELECT `Region`, `Fuel_Type`, ROUND(AVG(Price_USD),2) AS avg_price, COUNT(*) AS cnt
FROM BMW
GROUP BY `Region`, `Fuel_Type`
ORDER BY `Region`, avg_price DESC;

-- 13) Number of Electric cars sold after 2020
SELECT COUNT(*) AS electric_cars_sold_after_2020
FROM BMW
WHERE `Fuel_Type` = 'Electric' AND `Year` > 2020;

-- 14) Cars sold per Color and Region
SELECT `Region`, `Color`, COUNT(*) AS cars_sold
FROM BMW
GROUP BY `Region`, `Color`
ORDER BY `Region`, cars_sold DESC;

-- 15) Model-wise total mileage and average engine size
SELECT `Model`,
       SUM(Mileage_KM) AS total_mileage,
       ROUND(AVG(Engine_Size_L),2) AS avg_engine_size,
       COUNT(*) AS records
FROM BMW
GROUP BY `Model`
ORDER BY total_mileage DESC;

-- 16) Average price by Transmission type per Region
SELECT `Region`, `Transmission`, ROUND(AVG(Price_USD),2) AS avg_price, COUNT(*) AS cnt
FROM BMW
GROUP BY `Region`, `Transmission`
ORDER BY `Region`, avg_price DESC;

-- 17) Top 5 highest-priced cars for each year
SELECT Year, Model, Price_USD
FROM (
  SELECT Year, Model, Price_USD,
         ROW_NUMBER() OVER (PARTITION BY Year ORDER BY Price_USD DESC) AS rn
  FROM BMW
) ranked
WHERE rn <= 5
ORDER BY Year, Price_USD DESC;

-- 18) Total mileage and average engine size per model
SELECT Model,
       SUM(Mileage_KM) AS total_mileage,
       ROUND(AVG(Engine_Size_L), 2) AS avg_engine
FROM BMW
GROUP BY Model
ORDER BY total_mileage DESC;

-- 19) Most Popular Model in each Region
SELECT Region, Model, model_sales FROM (
    SELECT Region, Model,
           COUNT(*) AS model_sales,
           ROW_NUMBER() OVER (PARTITION BY Region ORDER BY COUNT(*) DESC) AS rn
    FROM BMW
    GROUP BY Region, Model
) ranked
WHERE rn = 1;

-- 20) Filter the Low Selling models
SELECT Model, SUM(Sales_Volume) AS total_sales
FROM BMW
GROUP BY Model
HAVING total_sales < 3000
ORDER BY total_sales;

-- 21) Filter high-end luxury cars
SELECT Model, Year, Price_USD, Region
FROM BMW
WHERE Price_USD > 100000
ORDER BY Price_USD DESC;


