## TEMPORARY TRENDS

Using EDA to understand the distribution and characteristics of food price data in Nigeria. Distribution of Food Prices Over Time.

### Monthly average price per commodity over time

```sql
SELECT DATE_FORMAT(date, '%Y-%m') AS month,
    AVG(price) AS average_price
FROM wfp_food_prices_nga
GROUP BY month
ORDER BY month;

The query above calculates the average price per commodity over time from a table named wfp_food_prices_nga. It groups the data by date and calculates the average price
for each date. The subsequent rows display the average price per commodity for different months and years. The average price varies significantly over time, indicating
potential fluctuations in market prices. The average price tends to increase and decrease over different periods, reflecting changes in supply and demand dynamics, market
conditions, and other factors affecting commodity prices. There are some unusually high average prices in certain months and years, which could be outliers or may
require further investigation.

Overall, this analysis provides insights into the average price trends of commodities over time, which can be valuable for understanding market dynamics and making
informed decisions related to pricing and supply chain management.

### Average food prices over the years
SELECT YEAR(date) AS year,
    AVG(price) AS average_price
FROM wfp_food_prices_nga
GROUP BY year
ORDER BY year;

The query above calculates the average food prices over the years from a table named wfp_food_prices_nga. It groups the data by the year extracted from the date
column and calculates the average price for each year. The average food prices vary significantly over the years, reflecting changes in market conditions, inflation
rates, supply and demand dynamics, and other factors affecting food prices. There are noticeable fluctuations in average food prices over time, with some years
experiencing substantial increases or decreases compared to others. The years 2004, 2012, 2013, 2014, 2015, 2016, 2021, and 2022 show particularly high average food
prices, indicating potential periods of economic instability, food shortages, or other market disruptions. Conversely, the years 2010, 2011, 2018, and 2019 exhibit
relatively lower average food prices compared to other years. The analysis provides insights into the overall trend of food prices over the years, which can be
valuable for understanding economic patterns, making policy decisions, and assessing the affordability of food for consumers.
![average food prices over the years](https://github.com/1Elaigwu/Sql-Adventures/assets/85877218/7955ecae-6e84-4d76-9e9b-277959334d86)

### Monthly average food prices over the years
SELECT
    YEAR(date) AS year,
    MONTH(date) AS month,
    AVG(price) AS average_price
FROM wfp_food_prices_nga
GROUP BY year, month
ORDER BY year, month;

The query you provided retrieves the average food prices over the years from a dataset named wfp_food_prices_nga. Here's a breakdown of the results:

Year: This column represents the year for which the average food price is calculated. Average Price: This column represents the average price of food items recorded
for each year. Here's the interpretation of the results:

In the year 2002, the average food price was 206.27.
In 2003, the average food price increased significantly to 327.90.
In 2004, there seems to be a drastic spike in the average food price, soaring to 4213.89.
This could be due to various factors such as inflation, scarcity, or other economic reasons.

From 2005 to 2009, the average food prices remained relatively high but fluctuated around the 1000 mark. In 2010 and 2011, the average food prices decreased further
to around 800. A significant increase occurred again in 2012, reaching 2707.93, and continued to rise in the subsequent years, hitting peaks in 2014 (6705.99), 2015
(7049.09), and 2016 (8021.89). There seems to be a decrease in average food prices from 2017 onwards, dropping to 5831.99 in 2017, 4036.69 in 2018, and further
decreasing to 3124.76 in 2019. In 2020, there was a noticeable increase again, with the average food price reaching 5437.97. The year 2021 saw a significant spike in
the average food price, jumping to 9252.77. In 2022, the average food price increased dramatically to 15787.29, indicating a potential crisis or economic instability.
However, in 2023, there was a notable decrease in the average food price, dropping to 3707.79. Overall, the data reflects significant fluctuations and trends in
average food prices over the years, indicating potential economic challenges, crises, or changes in food supply and demand dynamics. Further analysis may be required
to understand the underlying factors driving these fluctuations.

### Average price per commodity and its temporal variation
SELECT commodity,
    AVG(price) AS average_price,
    MIN(price) AS min_price,
    MAX(price) AS max_price
FROM wfp_food_prices_nga
GROUP BY commodity
ORDER BY average_price DESC;

The query above calculates the average price per commodity and its temporal variation by computing the average, minimum, and maximum prices for each commodity listed
in the table wfp_food_prices_nga. It groups the data by commodity and orders the result by the average price in descending order. Each row represents a different
commodity, along with its average, minimum, and maximum prices. The commodities are sorted based on their average prices, with the highest average prices appearing at
the top. Groundnuts (shelled) have the highest average price among the listed commodities, followed by cowpeas (brown), cowpeas (white), and rice (milled, local). The
average prices vary significantly across different commodities, indicating fluctuations in market prices and varying levels of demand and supply. The minimum and
maximum prices provide insights into the range of prices observed for each commodity. Some commodities exhibit wide price ranges, indicating volatility in prices
over time, while others have more stable price trends.
![Average price per commodity and its temporal variation](https://github.com/1Elaigwu/Sql-Adventures/assets/85877218/7136d6b3-85cc-4e9e-9e33-8e8cf7855c89)
Overall, this analysis offers valuable insights into the price fluctuations of different commodities, enabling stakeholders to understand market dynamics, identify
price trends, and make informed decisions related to procurement, pricing strategies, and resource allocation.

### Identify months with higher-than-average prices
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

The query above is designed to identify months where the prices of commodities are significantly higher than their average prices. It calculates the average price of
each commodity for each month and compares the actual price of each commodity against 1.5 times the average price. If the price of a commodity in a particular month
exceeds 1.5 times the average price for that month, it's considered higher than average. The query output includes columns for the year, month, average price for the
month, actual price of the commodity, and the name of the commodity. The results span across multiple years, with each row representing a specific commodity in a
particular month where the price exceeds the 1.5 times average threshold. The commodities listed include various food items such as rice, beans, wheat, maize, millet,
and sorghum, among others. For instance, in 2005, there are several instances where the prices of maize (white), millet, and sorghum (white) significantly exceeded
1.5 times their average prices in different months. Similarly, in 2007 and 2008, there are instances where the prices of maize (white), millet, and sorghum (white)
were substantially higher than their average prices. The fluctuations in prices indicate potential supply-demand imbalances, seasonal variations, economic factors,
and other market dynamics influencing food prices in Nigeria. This information can be valuable for policymakers, traders, and consumers to understand price trends,
plan budgets, and make informed decisions related to food consumption and procurement. In summary, the query identifies significant fluctuations in food prices,
highlighting months where prices substantially deviate from their average values, providing insights into market dynamics and potential economic challenges.
