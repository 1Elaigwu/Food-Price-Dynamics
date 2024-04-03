## REGIONAL VARIATIONS
### variations in food prices across different regions of Nigeria, identifying areas with consistent price disparities.

#### Average food prices by region over the years
```sql
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
 ```

The query you provided retrieves the average food prices over the years for different regions in Nigeria from a dataset 
named wfp_food_prices_nga. Here's the breakdown of the results:

Region: This column represents the administrative region in Nigeria.
Year: This column represents the year for which the average food price is calculated.
Average Price: This column represents the average price of food items recorded for each region and year combination.
Here's the interpretation of the results for some of the regions:
![Average food prices by region over the years](https://github.com/1Elaigwu/Sql-Adventures/assets/85877218/e3967022-11a1-4f11-ab8c-8c5c5134dc0f)

Abia: The average food prices in Abia were relatively stable from 2014 to 2016, but there was a significant increase 
starting from 2017, reaching a peak in 2023.
Adamawa: The average food prices in Adamawa have been fluctuating over the years, with significant increases observed 
from 2015 to 2023.
Borno: The average food prices in Borno experienced a drastic increase from 2012 to 2017, followed by fluctuations  
in subsequent years.
Gombe: Gombe experienced a similar trend to Adamawa, with fluctuating average food prices and notable increases from  2015 to 2023.
Jigawa: Jigawa experienced a gradual increase in average food prices from 2012 to 2023.
Kaduna: Kaduna witnessed fluctuations in average food prices over the years, with significant increases observed from 2014 to 2023.
Kano: Kano experienced fluctuations in average food prices, with notable increases from 2014 to 2023.
Katsina: Katsina witnessed gradual increases in average food prices from 2012 to 2023.
Kebbi: Kebbi experienced fluctuations in average food prices, with significant increases observed from 2015 to 2023.
Lagos: Lagos experienced fluctuations in average food prices, with notable increases observed from 2012 to 2023.
Oyo: Oyo witnessed fluctuations in average food prices, with notable increases observed from 2012 to 2023.
Sokoto: Sokoto experienced fluctuations in average food prices, with notable increases observed from 2012 to 2017.
Yobe: Yobe experienced fluctuations in average food prices, with notable increases observed from 2015 to 2023.
Zamfara: Zamfara witnessed fluctuations in average food prices, with notable increases observed from 2013 to 2023.
These interpretations provide insights into the regional variations and trends in average food prices across Nigeria over 
the years. Further analysis may be required to understand the underlying factors driving these fluctuations and trends.

#### Regional variation in monthly average food prices
    ```sql  
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
    ```
This query you provided is attempting to retrieve the average food prices for each region, year, and month from the   
wfp_food_prices_nga dataset. Here's how to interpret the query and the results:
admin1 AS region: This renames the administrative division column as "region."
YEAR(date) AS year: This extracts the year from the date column.
MONTH(date) AS month: This extracts the month from the date column.
AVG(price) AS average_price: This calculates the average price of food items for each region, year, and month.
The GROUP BY clause is used to group the data by region, year, and month, ensuring that the average prices 
are calculated for each unique combination of these three factors.
The ORDER BY clause sorts the results in ascending order based on region, year, and month, facilitating easier 
interpretation of the data.
![Regional variation in monthly average food prices](https://github.com/1Elaigwu/Sql-Adventures/assets/85877218/5b85f892-5f25-4923-ad84-c04302d2b4e4)

#### Identify regions with consistent price disparities
```sql
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
  ```

The query provided performs a comparative analysis of food prices against the average prices for each region in 
Nigeria. Here's a breakdown of the query and how to interpret the results:

Common Table Expression (CTE) - RegionAverage:

This part of the query calculates the average price of food items for each region in Nigeria.
It uses the wfp_food_prices_nga table, grouping the data by region and calculating the average price for each region.
The result is stored temporarily in a CTE named RegionAverage.
   
Main Query:

This section of the query selects data from the wfp_food_prices_nga table and joins it with the RegionAverage 
CTE on the region column. It selects columns such as date, region, price, and the calculated average_price 
from the CTE. The query also includes a CASE statement to categorize the price disparity into 'High Disparity,' 
'Low Disparity,' or 'Normal' based on predefined thresholds (1.2 times the average price or 0.8 times the average price). 
The final result set is ordered by date and region.
Interpreting the results:

The query returns 58770 rows, which indicates a substantial amount of data.
Each row contains information about the date, region, price of food items, the average price for that region, 
    and whether the price disparity is categorized as 'High Disparity,' 'Low Disparity,' or 'Normal.'
