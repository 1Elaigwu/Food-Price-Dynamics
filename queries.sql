show databases;
use food_price_dynamics;

CREATE TABLE wfp_food_prices_nga (
	date DATE,
    admin1 VARCHAR(100),
    admin2 VARCHAR(100),
    market VARCHAR(100),
    latitude DECIMAL(9,6),
    longitude DECIMAL(9,6),
    category VARCHAR(100),
    commodity VARCHAR(100),
    unit VARCHAR(50),
    priceflag VARCHAR(10),
    pricetype VARCHAR(50),
    currency VARCHAR(10),
    price DECIMAL(10,2),
    usdprice DECIMAL(10,2),
    PRIMARY KEY (date, admin1, admin2, market, commodity)
);

    
CREATE TABLE Economic_indicators (
    Country VARCHAR(255),
    Year INT,
    RealPerCapitaGDPGrowthRate DECIMAL(10,2),
    RealGDPGrowthRate DECIMAL(10,2),
    GDPConstantPricesUS DECIMAL(20,2),
    GDPCurrentPricesUS DECIMAL(20,2),
    FinalConsumptionExpenditureCurrentUS DECIMAL(20,2),
    GeneralGovtFinalConsumptionExpenditureCurrentUS DECIMAL(20,2),
    HouseholdFinalConsumptionExpenditureCurrentUS DECIMAL(20,2),
    GrossCapitalFormationCurrentUS DECIMAL(20,2),
    GrossCapitalFormationPrivateSectorCurrentUS DECIMAL(20,2),
    GrossCapitalFormationPublicSectorCurrentUS DECIMAL(20,2),
    ExportsGoodsServicesCurrentUS DECIMAL(20,2),
    ImportsGoodsServicesCurrentUS DECIMAL(20,2),
    FinalConsumptionExpenditureGDP DECIMAL(10,2),
    GeneralGovtFinalConsumptionExpenditureGDP DECIMAL(10,2),
    HouseholdFinalConsumptionExpenditureGDP DECIMAL(10,2),
    GrossCapitalFormationGDP DECIMAL(10,2),
    GrossCapitalFormationPrivateSectorGDP DECIMAL(10,2),
    GrossCapitalFormationPublicSectorGDP DECIMAL(10,2),
    ExportsGoodsServicesGDP DECIMAL(10,2),
    ImportsGoodsServicesGDP DECIMAL(10,2),
    CentralGovtFiscalBalanceCurrentUS DECIMAL(20,2),
    CentralGovtTotalRevenueGrantsCurrentUS DECIMAL(20,2),
    CentralGovtTotalExpenditureNetLendingCurrentUS DECIMAL(20,2),
    CentralGovtFiscalBalanceGDP DECIMAL(10,2),
    CentralGovtTotalRevenueGrantsGDP DECIMAL(10,2),
    CentralGovtTotalExpenditureNetLendingGDP DECIMAL(10,2),
    CurrentAccountBalanceNetBOPCurrentUS DECIMAL(20,2),
    CurrentAccountBalanceAsPercentGDP DECIMAL(10,2),
    InflationConsumerPrices DECIMAL(10,2),
    PRIMARY KEY (Country, Year)
);
-- creating a new table, with details from the existing table "economic_indicators"
CREATE TABLE inflation_nga AS 
	select country, year, InflationConsumerPrices 
	from economic_indicators 
	where Country ='Nigeria' 
	AND year BETWEEN 2002 AND 2023
	order by country;

-- Rename the newly created table
RENAME TABLE inflation_nga TO nga_inflation_data;

select * from economic_indicators;
select * from nga_inflation_data;
select * from wfp_food_prices_nga;

-- Data cleaning
delete from wfp_food_prices_nga where price = 0.00;
delete from wfp_food_prices_nga where usdprice = 0.00;
delete from wfp_food_prices_nga where date = 0000-00-00;

-- Monthly average price per commodity
SELECT DATE_FORMAT(date, '%Y-%m') AS month,
    AVG(price) AS average_price
FROM wfp_food_prices_nga
GROUP BY month
ORDER BY month;

-- Seasonal trends in prices considering dry and rainy seasons, ordered by year, month, and day
SELECT
    YEAR(date) AS year,
    MONTH(date) AS month,
    DAY(date) AS day,
    CASE
        WHEN MONTH(date) IN (11, 12, 1, 2, 3) THEN 'Dry Season'  -- November to March
        WHEN MONTH(date) BETWEEN 4 AND 10 THEN 'Rainy Season' -- April to October
        ELSE 'Unknown'
    END AS season,
    AVG(price) AS average_price
FROM wfp_food_prices_nga
GROUP BY year, month, day, season
ORDER BY year, month, day, season;

-- Average price per commodity and its temporal variation
SELECT commodity,
    AVG(price) AS average_price,
    MIN(price) AS min_price,
    MAX(price) AS max_price
FROM wfp_food_prices_nga
GROUP BY commodity
ORDER BY average_price DESC;

-- Average food prices over the years
SELECT YEAR(date) AS year,
    AVG(price) AS average_price
FROM wfp_food_prices_nga
GROUP BY year
ORDER BY year;

-- Identify months with higher-than-average prices
WITH MonthlyAverage AS (
    SELECT
        EXTRACT(YEAR FROM date) AS year,
        EXTRACT(MONTH FROM date) AS month,
        AVG(price) AS average_price
    FROM
        wfp_food_prices_nga
    GROUP BY
        year, month
)
SELECT
    EXTRACT(YEAR FROM wfp_food_prices_nga.date) AS year,
    EXTRACT(MONTH FROM wfp_food_prices_nga.date) AS month,
    MonthlyAverage.average_price,
    wfp_food_prices_nga.price,
    wfp_food_prices_nga.commodity
FROM
    wfp_food_prices_nga
JOIN
    MonthlyAverage ON EXTRACT(YEAR FROM wfp_food_prices_nga.date) = MonthlyAverage.year
    AND EXTRACT(MONTH FROM wfp_food_prices_nga.date) = MonthlyAverage.month
WHERE
    wfp_food_prices_nga.price > 1.5 * MonthlyAverage.average_price; -- Customize the threshold as needed

    -- Average food prices by region over the years
SELECT
    admin1 AS region,
    YEAR(date) AS year,
    AVG(price) AS average_price
FROM
    wfp_food_prices_nga
GROUP BY
    region, year
ORDER BY
    region, year;
    
-- Regional variation in monthly average food prices
SELECT
    admin1 AS region,
    YEAR(date) AS year,
    MONTH(date) AS month,
    AVG(price) AS average_price
FROM
    wfp_food_prices_nga
GROUP BY
    region, year, month
ORDER BY
    region, year, month;
    
-- Identify regions with consistent price disparities
WITH RegionAverage AS (
    SELECT
        admin1 AS region,
        AVG(price) AS average_price
    FROM
        wfp_food_prices_nga
    GROUP BY
        region
)
SELECT
    wfp_food_prices_nga.date,
    wfp_food_prices_nga.admin1 AS region,
    wfp_food_prices_nga.price,
    RegionAverage.average_price,
    CASE
        WHEN wfp_food_prices_nga.price > 1.2 * RegionAverage.average_price THEN 'High Disparity'
        WHEN wfp_food_prices_nga.price < 0.8 * RegionAverage.average_price THEN 'Low Disparity'
        ELSE 'Normal'
    END AS price_disparity
FROM
    wfp_food_prices_nga
JOIN
    RegionAverage ON wfp_food_prices_nga.admin1 = RegionAverage.region
ORDER BY
    wfp_food_prices_nga.date, wfp_food_prices_nga.admin1;

-- Calculate correlation between inflation and food prices by year
SELECT
    YEAR(wf.date) AS year,
    wf.admin1 AS region,
    AVG(wf.price) AS average_price,
    AVG(ni.InflationConsumerPrices) AS average_inflation
FROM
    wfp_food_prices_nga wf
JOIN
    nga_inflation_data ni ON YEAR(wf.date) = ni.Year
GROUP BY
    YEAR(wf.date), wf.admin1
ORDER BY
    year, region;
    
-- Average food prices over the years
SELECT
    YEAR(date) AS year,
    AVG(price) AS average_price
FROM
    wfp_food_prices_nga
GROUP BY
    year
ORDER BY
    year;
        
-- Analyze inflation impact on food prices
WITH InflationAdjusted AS (
    SELECT
        wf.date,
        wf.admin1 AS region,
        wf.price,
        ni.InflationConsumerPrices AS inflation_rate,
        wf.price / (1 + InflationConsumerPrices / 100) AS price_adjusted
    FROM
        wfp_food_prices_nga wf
    JOIN
       nga_inflation_data ni ON YEAR(wf.date) = ni.Year
)
SELECT
    date,
    region,
    price,
    Inflation_rate,
    price_adjusted,
    ((price_adjusted - price) / price) * 100 AS percentage_change
FROM
    InflationAdjusted
ORDER BY
    date, region;
    
-- Analyze inflation impact on food prices group by year
WITH InflationAdjusted AS (
    SELECT
        wf.date,
        wf.admin1 AS region,
        wf.price,
        ni.InflationConsumerPrices AS inflation_rate,
        wf.price / (1 + ni.InflationConsumerPrices / 100) AS price_adjusted
    FROM
        wfp_food_prices_nga wf
    JOIN
      nga_inflation_data ni ON YEAR(wf.date) = ni.Year
)
SELECT
    YEAR(date) AS year,
    region,
    AVG(price) AS average_price,
    AVG(Inflation_rate) AS average_inflation,
    AVG(price_adjusted) AS average_price_adjusted,
    AVG(((price_adjusted - price) / price) * 100) AS average_percentage_change
FROM
    InflationAdjusted
GROUP BY
    year, region
ORDER BY
    year, region;

-- Calculate correlation between inflation and food prices group by year and region
SELECT
    YEAR(wf.date) AS year,
    wf.admin1 AS region,
    AVG(wf.price) AS avg_price,
    AVG(ni.InflationConsumerPrices) AS avg_inflation
FROM
    wfp_food_prices_nga wf
JOIN
    nga_inflation_data ni ON YEAR(wf.date) = ni.Year
GROUP BY
    YEAR(wf.date), region
ORDER BY
    YEAR(wf.date), region;

-- Seasonal trends in food prices with inflation
SELECT
    YEAR(wf.date),
    wf.admin1 AS region,
    wf.price,
    ni.InflationConsumerPrices,
    CASE
        WHEN MONTH(date) IN (11, 12, 1, 2, 3) THEN 'Dry Season'  -- November to March
        WHEN MONTH(wf.date) BETWEEN 4 AND 10 THEN 'Rainy Season' -- April to October
        ELSE 'Unknown'
    END AS season
FROM
    wfp_food_prices_nga wf
JOIN
	nga_inflation_data ni ON YEAR(wf.date) = ni.Year
ORDER BY
    YEAR(wf.date), region;
    
-- Calculate price volatility
SELECT
    admin1 AS region,
    STDDEV(price) AS price_volatility
FROM
    wfp_food_prices_nga
GROUP BY
    region
ORDER BY
    price_volatility DESC;
       
-- Identify months with high price volatility
WITH MonthlyVolatility AS (
    SELECT
        DATE_FORMAT(date, '%Y-%m') AS month,
        STDDEV(price) AS monthly_volatility
    FROM
        wfp_food_prices_nga
    GROUP BY
        month
)
SELECT
    month,
    monthly_volatility
FROM
    MonthlyVolatility
WHERE
    monthly_volatility > (SELECT AVG(monthly_volatility) * 1.5 FROM MonthlyVolatility)
ORDER BY
    monthly_volatility DESC;
    
-- Calculate price volatility for each commodity
SELECT
    commodity,
    STDDEV(price) AS price_volatility
FROM
    wfp_food_prices_nga
GROUP BY
    commodity
ORDER BY
    price_volatility DESC;

-- Identify commodities with the highest volatility
WITH CommodityVolatility AS (
    SELECT
        commodity,
        STDDEV(price) AS price_volatility
    FROM
        wfp_food_prices_nga
    GROUP BY
        commodity
)
SELECT
    commodity,
    price_volatility
FROM
    CommodityVolatility
WHERE
    price_volatility > (SELECT AVG(price_volatility) * 1.5 FROM CommodityVolatility)
ORDER BY
    price_volatility DESC;

-- Identify commodities with the lowest volatility
WITH CommodityVolatility AS (
    SELECT
        commodity,
        STDDEV(price) AS price_volatility
    FROM
        wfp_food_prices_nga
    GROUP BY
        commodity
)
SELECT
    commodity,
    price_volatility
FROM
    CommodityVolatility
WHERE
    price_volatility < (SELECT AVG(price_volatility) * 0.5 FROM CommodityVolatility)
ORDER BY
    price_volatility ASC;
    
-- Analyze price trends for a specific market (e.g., )
SELECT
    date,
    commodity,
    price
FROM
    wfp_food_prices_nga
WHERE
    admin1 = 'Gombe'
ORDER BY
    date, commodity;
    
-- Explore factors affecting prices in a specific market (e.g., Lagos Market)
SELECT
    date,
    commodity,
    price
FROM
    wfp_food_prices_nga
WHERE
    admin1 = 'Yobe'
    AND market = 'SpecificMarketName' -- Replace with the desired market name
ORDER BY
    date, commodity;

-- Identify unique factors affecting prices in different markets
SELECT
    admin1 AS region,
    market,
    AVG(price) AS average_price
FROM
    wfp_food_prices_nga
GROUP BY
    region, market
ORDER BY
    region, market;
    

-- Overall trend in the average price of staple foods over the past decade
SELECT
    YEAR(date) AS year,
    AVG(price) AS average_price
FROM
    wfp_food_prices_nga
WHERE
    commodity IN ('Maize', 'Millet', 'Yam')  -- Replace with actual staple food names
    AND YEAR(date) BETWEEN 2002 AND 2022  -- Adjust the date range as needed
GROUP BY
    year
ORDER BY
    year;

select distinct category, commodity from wfp_food_prices_nga; 

-- Identify correlation between food prices and inflation rates
-- Calculate Pearson correlation between price and inflation
SELECT
    wf.commodity,
    (
        COUNT(*) * SUM(wf.price * ni.InflationConsumerPrices) - SUM(wf.price) * SUM(ni.InflationConsumerPrices)
    ) / SQRT(
        (COUNT(*) * SUM(wf.price * wf.price) - SUM(wf.price) * SUM(wf.price)) *
        (COUNT(*) * SUM(ni.InflationConsumerPrices * ni.InflationConsumerPrices) - SUM(ni.InflationConsumerPrices) * SUM(ni.InflationConsumerPrices))
    ) AS pearson_correlation
FROM
    wfp_food_prices_nga wf
JOIN
    nga_inflation_data ni ON YEAR(wf.date) = ni.year
WHERE
    wf.commodity IN ('Yam', 'Maize')
GROUP BY
	wf.commodity;

-- Identify Markets with Highest and Lowest Volatility:
-- Calculate price volatility for each market
WITH MarketVolatility AS (
    SELECT
        market,
        STDDEV(price) AS price_volatility
    FROM
        wfp_food_prices_nga
    GROUP BY
        market
)
SELECT
    market,
    price_volatility
FROM
    MarketVolatility
ORDER BY
    price_volatility DESC;

-- Identify markets with lowest volatility
WITH MarketVolatility AS (
    SELECT
        market,
        STDDEV(price) AS price_volatility
    FROM
        wfp_food_prices_nga
    GROUP BY
        market
)
SELECT
    market,
    price_volatility
FROM
    MarketVolatility
ORDER BY
    price_volatility ASC;

-- Calculate price volatility for each commodity
WITH CommodityVolatility AS (
    SELECT
        commodity,
        STDDEV(price) AS price_volatility
    FROM
        wfp_food_prices_nga
    GROUP BY
        commodity
)
SELECT
    commodity,
    price_volatility
FROM
    CommodityVolatility
ORDER BY
    price_volatility DESC;
    
-- Identify seasonal trends in food prices, This query calculates the average price for each month.
SELECT
    EXTRACT(MONTH FROM date) AS month,
    AVG(price) AS average_price
FROM
    wfp_food_prices_nga
GROUP BY
    month
ORDER BY
    month;
 
-- Compare seasonal trends for specific commodities
SELECT
    EXTRACT(MONTH FROM date) AS month,
    commodity,
    AVG(price) AS average_price
FROM
    wfp_food_prices_nga
WHERE
    commodity IN ('rice', 'maize') -- Replace with the specific commodities you want to analyze
GROUP BY
    month, commodity
ORDER BY
    month, commodity;
    -- This query compares seasonal trends for specific commodities (e.g., rice, maize) by calculating the average price for each month.


-- Align seasonal trends with agricultural cycles
SELECT
    CASE
        WHEN EXTRACT(MONTH FROM date) IN (4, 5, 6) THEN 'Planting Season'
        WHEN EXTRACT(MONTH FROM date) IN (7, 8, 9) THEN 'Growing Season'
        WHEN EXTRACT(MONTH FROM date) IN (10, 11, 12) THEN 'Harvesting Season'
        ELSE 'Off-Season'
    END AS agricultural_cycle,
    AVG(price) AS average_price
FROM
    wfp_food_prices_nga
GROUP BY
    agricultural_cycle
ORDER BY
    agricultural_cycle;
