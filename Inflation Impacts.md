## INFLATION IMPACT.
### Explore the impact of inflation on food prices by correlating the dataset with relevant inflation data, if available.

#### Analyze Inflation Impact on Food Prices:
```sql
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
```
The query is aimed at adjusting food prices for inflation and calculating the percentage change 
in prices after adjustment. Here's an interpretation of the query and some suggestions on how to effectively present 
its results: 
Common Table Expression (CTE) - InflationAdjusted: This part of the query calculates the inflation-adjusted prices for food 
items in Nigeria.
It joins the wfp_food_prices_nga table with the nga_inflation_data table based on the year of the date column.
The inflation-adjusted price is calculated by dividing the original price by (1 + inflation rate / 100).
    
Main Query: The main query selects columns from the InflationAdjusted CTE, including the date, region, original price, 
inflation rate,inflation-adjusted price, and the percentage change in price after adjustment.
The percentage change is calculated as ((price_adjusted - price) / price) * 100.

#### Analyze inflation impact on food prices group by year
```sql
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
```
The query performs the following steps: 
Inflation Adjustment: It adjusts the food prices in the wfp_food_prices_nga table for inflation using the 
nga_inflation_data table. This adjustment calculates the price-adjusted value based on the inflation rate for each year.

Data Selection and Calculation: It selects the necessary columns from the wfp_food_prices_nga table and joins 
it with the nga_inflation_data table based on the year. Then, it calculates the inflation-adjusted price for each entry.

Aggregation: It aggregates the data by grouping it based on the year and region. For each group, it calculates the 
average price, average inflation rate, average price adjusted for inflation, and average percentage change.

Sorting and Ordering: Finally, it sorts the results first by year and then by region.

The resulting table provides insights into the average food prices, inflation rates, adjusted prices, and 
percentage changes for each region over the years.

Here's how to interpret the columns in the result:
Year: The year for which the data is aggregated.
Region: The administrative region in Nigeria.
Average Price: The average price of food items in the region for the given year.
Average Inflation: The average inflation rate for the region for the given year.
Average Price Adjusted: The average price of food items adjusted for inflation.
Average Percentage Change: The average percentage change in prices after adjusting for inflation, calculated 
as ((price_adjusted - price) / price) * 100.

For example, let's take the first row in the result:

Year: 2002
Region: Katsina
Average Price: 200.698143
Average Inflation: 12.900000
Average Price Adjusted: 177.7662912714
Average Percentage Change: -11.42604074400000
This indicates that in 2002, the average price of food items in Katsina was 200.70 NGN, with an average inflation rate 
of 12.90%. After adjusting for inflation, the average price becomes 177.77 NGN, reflecting a percentage change of -11.43%.

You can analyze these results to understand the trends in food prices, inflation rates, and their impact on different 
regions in Nigeria over the years.

#### Calculate correlation between inflation and food prices group by year and region
```sql
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
```
The result of the SQL query provides insights into the average food prices and inflation rates across various regions 
of Nigeria over the years 2002 to 2022. Here's a descriptive interpretation of the data:

Yearly Trends: The data shows how average food prices and inflation rates have fluctuated from year to year in Nigeria.

Regional Disparities: It highlights the differences in average food prices and inflation rates across different regions of 
Nigeria. For example, regions like Lagos tend to have higher average prices compared to others, reflecting potential economic 
disparities and factors influencing pricing.

Inflation Impact: The average inflation rates provide an indication of the overall economic stability or volatility within each 
region. Higher inflation rates suggest economic challenges that could affect purchasing power and living standards.

Long-term Patterns: By examining the data over a span of 20 years, one can observe long-term patterns and trends in food prices 
and inflation rates. This could be useful for economic analysis, policy-making, and business planning.

Potential Influencing Factors: The data prompts questions about the factors influencing food prices and inflation rates in each 
region, such as agricultural productivity, market dynamics, government policies, and external economic conditions.

Policy Implications: Policymakers can use this data to assess the effectiveness of existing policies related to inflation  control, 
agricultural development, trade, and consumer protection.

Comparative Analysis: Researchers and analysts can use this data to conduct comparative studies between regions and identify best 
practices or areas for improvement in economic management and policy implementation.

Overall, the data offers valuable insights into the economic dynamics of Nigeria, enabling stakeholders to make informed decisions 
and interventions aimed at promoting economic stability, reducing food insecurity, and improving living standards.
![INFLATION IMPACT Calculate correlation between inflation and food prices group by year and region](https://github.com/1Elaigwu/Sql-Adventures/assets/85877218/d20ada70-14b0-4e61-8a4d-ba9d8d2fb78e)

In summary, the analysis provides valuable insights into the complex relationship between inflation and food prices, 
highlighting regional variations, economic trends, and policy implications in Nigeria's dynamic economic landscape. 
These insights can guide policymakers, researchers, and stakeholders in formulating targeted interventions and strategies aimed 
at promoting economic stability, reducing food insecurity, and enhancing the overall well-being of the population.
