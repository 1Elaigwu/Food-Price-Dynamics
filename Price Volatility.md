## PRICE VOLATILITY
### Measure and analyze the volatility of food prices, identifying commodities that exhibit the highest and lowest volatility.
        
#### Price Volatility Analysis:
```sql
        SELECT
            admin1 AS region,
            STDDEV(price) AS price_volatility
        FROM
            wfp_food_prices_nga
        GROUP BY
            region
        ORDER BY
            price_volatility DESC;
```

The SQL query you provided calculates the standard deviation of food prices (price_volatility) for each administrative 
region (admin1) in Nigeria. Here's an interpretation of the query results:

Price Volatility: The standard deviation of prices measures the degree of dispersion or variability of food prices 
within each region. A higher standard deviation indicates greater price volatility, which implies that food prices 
fluctuate more widely within that region over time.

Insights from the Results:
High Price Volatility: Regions like Abia, Kebbi, Kaduna, Adamawa, and Lagos exhibit the highest price volatility, 
with standard deviations ranging from around 12,000 to over 23,000. This suggests that food prices in these regions 
experience significant fluctuations, potentially influenced by factors such as market dynamics, supply chain disruptions,
and demand variations.
Moderate Price Volatility: Other regions like Oyo, Jigawa, Gombe, Zamfara, Kano, and Katsina also demonstrate moderate 
price volatility, with standard deviations ranging from around 11,000 to 13,000. While not as volatile as the highest-ranking 
regions, these areas still experience notable fluctuations in food prices.
Low Price Volatility: Borno, Yobe, and Sokoto exhibit comparatively lower price volatility, with standard deviations 
ranging from around 6,000 to less than 100. These regions experience relatively stable food prices, indicating more 
consistent pricing patterns over time.
Potential Factors: The observed differences in price volatility across regions could be attributed to various factors 
such as agricultural productivity, market infrastructure, transportation networks, government policies, climate conditions, 
and socio-economic factors. Regions with higher volatility may face challenges related to market integration, supply chain 
inefficiencies, conflict, and economic instability, which contribute to price fluctuations.

Policy Implications: Understanding regional variations in price volatility is crucial for policymakers, government 
agencies, and stakeholders involved in food security and economic development. It highlights the need for targeted 
interventions, including improved market infrastructure, price stabilization measures, risk management strategies, 
and social safety nets to mitigate the adverse effects of price volatility on vulnerable populations and promote food 
affordability and access.

Data Integrity: The presence of Sokoto with an unusually low standard deviation (88.47) compared to other regions and 
the #adm1+name entry with a standard deviation of 0 raises questions about data accuracy or completeness for these regions. 
Further investigation may be necessary to ensure data integrity and reliability.
![PRICE VOLATILITY Price Volatility Analysis](https://github.com/1Elaigwu/Sql-Adventures/assets/85877218/689bfb61-1da5-4c04-a4c9-7d128d6fd5c0)

In summary, the analysis of price volatility across administrative regions provides valuable insights into the dynamics 
of food markets, informing policy decisions and interventions aimed at enhancing food security, stability, and resilience in Nigeria.

#### Identify Months with High Price Volatility:
```sql
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
```
The query calculates the standard deviation of prices for each month from the dataset "wfp_food_prices_nga". It then 
filters the results to include only months where the monthly price volatility exceeds 1.5 times the average volatility 
across all months. Finally, it orders the results in descending order based on the monthly volatility. This provides insights 
into months with unusually high price fluctuations, which can be valuable for understanding market dynamics and  making 
informed decisions related to food prices and economic policies.
![PRICE VOLATILITY Identify months with high price volatility](https://github.com/1Elaigwu/Sql-Adventures/assets/85877218/191d6cf8-bdcd-4899-878c-bfc38f7861ac)

The query retrieves months with monthly price volatility exceeding 1.5 times the average. This indicates periods of 
significant price fluctuations, crucial for economic analysis and policy-making. High volatility months may signify market 
disruptions, supply chain issues, or economic instability, prompting businesses and policymakers to assess and address 
underlying factors contributing to price fluctuations.

### Measure and Analyze Volatility:
#### Calculate price volatility for each commodity
```sql
        SELECT
            commodity,
            STDDEV(price) AS price_volatility
        FROM
            wfp_food_prices_nga
        GROUP BY
            commodity
        ORDER BY
            price_volatility DESC;
```

This query computes the standard deviation of prices for each commodity in the "wfp_food_prices_nga" dataset. 
It groups the results by commodity and orders them in descending order based on price volatility.
![PRICE VOLATILITY Measure and Analyze Volatility](https://github.com/1Elaigwu/Sql-Adventures/assets/85877218/3ae78499-1ea1-4683-b336-5942c1577dde)

The insights gained from the results reveal the commodities with the highest price fluctuations. For instance,
commodities like yam, groundnuts (shelled), and local rice exhibit significantly higher price volatility compared to others like tomatoes or wheat. Understanding such volatility can aid in market analysis, supply chain management, and policy-making decisions related to food security and agricultural economics.

#### Identify Commodities with Highest Volatility:
 ```sql     
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
```
The query calculates the standard deviation of prices for each commodity in the "wfp_food_prices_nga" dataset. 
It filters out commodities whose price volatility exceeds 1.5 times the average volatility.

The results reveal commodities with significant price fluctuations, indicating potential market instability or 
factors influencing pricing dynamics. For instance:

Yam, groundnuts (shelled), and local rice exhibit the highest price volatility, indicating potential challenges in
supply chain management or market dynamics affecting their prices.
Commodities like cowpeas (brown), cowpeas (white), and cassava meal (gari, yellow) also demonstrate considerable 
price fluctuations, suggesting potential risks for stakeholders involved in their production or distribution.
Understanding and monitoring the volatility of these commodities is crucial for stakeholders in the food supply 
chain,policymakers, and economists to mitigate risks, ensure food security, and make informed decisions related 
to agriculture and trade.

### Identify Commodities with Lowest Volatility:
 ```sql  
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
```
The query identifies commodities with the lowest price volatility, highlighting items that exhibit relatively stable pricing 
behavior over the observed period. Here are some insights:

Tomatoes, Maize, and Fuel (petrol-gasoline): These commodities demonstrate the lowest price volatility, suggesting 
stable market conditions or consistent supply and demand dynamics.

Wheat, Onions, and Spinach: They also exhibit low volatility, indicating steady pricing trends and minimal fluctuations, 
which could be influenced by factors like consistent production or stable consumer demand.

Bananas, Sorghum, and Beans (niebe): These commodities show relatively stable pricing patterns, indicating a reliable 
market environment or effective supply chain management.

Milk, Groundnuts, and White Beans: Despite being susceptible to market dynamics, they maintain lower volatility compared 
to other commodities, reflecting stable pricing structures or effective market regulations.

Oil (palm), Meat (goat), and Meat (beef): While slightly more volatile than the aforementioned items, they still 
demonstrate relatively stable pricing behavior compared to other commodities in the dataset.

Understanding commodities with low price volatility is crucial for stakeholders involved in production, distribution, 
and trade, as they provide insights into market stability, consumer preferences, and economic conditions, allowing for 
informed decision-making and risk management strategies.
