# Restaurant Orders Analysis (SQL + Power BI)
SQL and Power BI Project | Microsoft SQL Server

An analysis of 5,370 restaurant orders from January to March 2023 to understand menu performance, customer ordering behavior, revenue trends, and peak ordering times.

The goal was to turn raw restaurant transaction data into actionable business insights that could help improve revenue, menu performance, and operational planning.

## Project Snapshot

| Total Revenue | Total Orders | Items Sold | Avg. Order Value | Avg. Items / Order |
|---|---|---|---|---|
| $159.2K | 5,370 | 12,097 | $29.80 | 2.3



**Analysis period:** January 1 – March 31, 2023
**Menu:** 32 dishes across 4 categories

## Key Findings

**1. Italian and Asian dishes drive revenue**

Italian and Asian dishes generated 60.4% of total revenue, making them the restaurant's strongest revenue categories.

**2. Most orders are relatively small**

83.5% of orders contain only 1–3 items, with an average order containing approximately 2.3 items. This suggests an opportunity to increase order value through combos, sides, and add-ons.

**3. Demand is concentrated around lunch and dinner**

The busiest periods are 12:00–13:00 and 17:00–19:00, which together account for approximately 55% of all orders. 

**4. Some dishes significantly outperform others**

Hamburger (622 orders) and Edamame (620 orders) are the most frequently ordered dishes, while Chicken Tacos is by far the least ordered (123 orders).

## Business Questions

The analysis focuses on four areas:

**Menu Performance**
- Which dishes are ordered most frequently?
- Which dishes generate the most revenue?
- Which categories have the highest average prices?
- Which menu items are underperforming?

**Customer Ordering Behavior**
- How many items do customers typically order?
- What percentage of orders are small, medium, or large?
- Which orders have the highest total value?

**Revenue Performance**
- How much revenue does each category generate?
- How does revenue change month over month?
- Which month performed best?

**Demand & Operations**
- What are the busiest ordering hours?
- Which weekdays have the highest demand?
- When should staffing levels be increased?

## Dataset

[Restaurant Orders](https://mavenanalytics.io/data-playground/restaurant-orders) from Maven Analytics Data Playground. It contains two tables:

| Table | Description |
|---|---|
| `menu_items` | Menu items with name, category and price |
| `order_details` | Each ordered item with order ID, date and time |

Data period: **1 January 2023 to 31 March 2023**

## Tools

- Microsoft SQL Server Management Studio (SSMS)
- SQL
- GitHub

## SQL Skills Demonstrated

- Filtering, sorting and aggregation: `WHERE`, `ORDER BY`, `GROUP BY`, `HAVING`, `COUNT`, `SUM`, `AVG`, `MIN`, `MAX`
- Joins: `INNER JOIN`, `LEFT JOIN`
- Subqueries and Common Table Expressions (CTEs)
- Conditional logic: `CASE WHEN`
- Window functions: `RANK()`, `LAG()`, `SUM() OVER()`
- Date and time functions: `DATEPART`, `DATENAME`

## Analysis

### 1. Menu Performance

**Menu Overview**

The restaurant offers 32 dishes across 4 categories

**Most and least expensive items**

| item_name | price | type |
|---|---|---|
| Shrimp Scampi | 19.95 | most expensive |
| Edamame | 5.00 | cheapest |


**Average price by category**

| category | dishes | average_price |
|---|---|---|
| American | 6 | 10.07 |
| Asian | 8 | 13.48 |
| Italian | 9 | 16.75 |
| Mexican | 9 | 11.80 |

**Insight:** Italian dishes have the highest average price, while American dishes are the cheapest on average.

**Most and least ordered dishes**

| item_name | category | order_count |
|---|---|---|
| Hamburger | American | 622 |
| Edamame | Asian | 620 |
| ... | ... | ... |
| Chicken Tacos | Mexican | 123 |


**Insight:** Edamame is the cheapest menu item at $5.00 but is also the second most ordered dish, suggesting strong customer demand for low-priced starters or sides. Chicken Tacos, with only 123 orders, is the weakest performer by order volume.

**Top 3 dishes by revenue in each category**

| category | item_name | revenue |
|---|---|---|
| American | Cheeseburger | 8,132.85 |
| American | Hamburger | 8,054.90 |
| American | French Fries | 3,997.00 |
| Asian | Korean Beef Bowl | 10,554.60 |
| Asian | Tofu Pad Thai | 8,149.00 |
| Asian | Orange Chicken | 7,524.00 |
| Italian | Spaghetti & Meatballs | 8,436.50 |
| Italian | Eggplant Parmesan | 7,119.00 |
| Italian | Chicken Parmesan | 6,533.80 |
| Mexican | Steak Torta | 6,821.55 |
| Mexican | Chicken Burrito | 5,892.25 |
| Mexican | Steak Burrito | 5,292.30 |

**Insight:** Korean Beef Bowl is the highest-revenue dish in the menu. The American category also shows an interesting difference between popularity and revenue: Hamburger is ordered more frequently, while Cheeseburger generates more revenue because of its higher price.

### 2. Customer Ordering Behavior

**Order Overview**

|Metric|Value|
|---|---|
|Total Orders | 5,370 |
|Total Items Sold | 12,097 |
|Average Items per Order | 2.3 |
|Average Order Value | $29.80 |
|Largest Order | 14 items |
|Orders with 12+ Items | 20 |


**Order size distribution**

| size | orders | share |
|---|---|---|
| Small (1-3 items) | 4,486 | 83.5% 
| Medium (4-8 items) | 797 | 14.8%
| Large (9+ items) | 87 | 1.6%

**Insight:** The vast majority of orders contain only 1–3 items. This represents a potential opportunity to increase average order value through combo meals, side-dish recommendations, drink add-ons or dessert promotions.

### 3. Revenue Performance

**Highest-Value Orders**

| order_id | total | 
|---|---|
| 440 | 192.15|
| 2075 | 191.05 |
| 1957 | 190.10 |
| 330  | 189.70 |
| 2675 | 185.10 |

**Insight:** The highest-value order was $192.15 and contained 14 items, including 8 Italian dishes.

**Monthly revenue**

| month | revenue | previous_month | change | running_total |
|---|---|---|---| ---|
| January | 53,816.95 | - | - | 53,816.95 |
| February | 50,790.35 | 53,816.95 | -3,026.60 (-5.6%) | 104,607.30 |
| March | 54,610.60	 | 	50,790.35 | 	+3,820.25 (+7.5%) | 159,217.90 |

**Insight:** February generated the lowest revenue, while March was the strongest month. The February decline is partly explained by the shorter month. 


**Revenue share by category**

| category | share_of_revenue |
|---|---|
| Italian | 31.1% |
| Asian | 29.3% |
| Mexican | 21.9% |
| American | 17.7% |

**Insight:** Italian and Asian dishes bring in 60.4% of revenue. American dishes are among the most popular by order volume, but their lower prices mean they contribute the smallest share of revenue.

### 4. Demand & Time Analysis

**Busiest Ordering Hours** 

| hour | orders |
|---|---|
| 12:00 | 647 |
| 17:00 | 623 |
| 18:00 | 596 |
| 13:00 | 595 |
| 19:00 | 498 |

**Orders by weekday**

| weekday | orders |
|---|---|
| Monday | 885 |
| Sunday | 796 |
| Friday | 787 |
| Tuesday | 766 |
| Thursday | 743 |
| Saturday | 711 |
| Wednesday | 682 |


**Insight:** Lunch (12:00-13:00) accounts for 23% of orders and dinner (17:00-19:00) for 32%. Orders after 22:00 are very rare. Monday is the busiest weekday with 885 orders, while Wednesday has the lowest demand with 682 orders.

## Recommendations

Based on the analysis, I would recommend four actions.

**1. Promote high-revenue categories**

Italian and Asian dishes generate 60.4% of revenue.

The restaurant could give these categories more visibility on the menu and promote high-performing dishes such as:

- Korean Beef Bowl
- Spaghetti & Meatballs
- Tofu Pad Thai

**2. Review underperforming dishes**

Chicken Tacos received only 123 orders, significantly below the top-performing dishes.

The restaurant could test:

- a different price
- recipe changes
- improved menu positioning
- promotional offers

If performance does not improve, the dish could be considered for replacement.

**3. Increase average order value**

With 83.5% of orders containing only 1–3 items, there is an opportunity to encourage customers to add more items.

Possible strategies:
- combo meals
- side + main bundles
- drink add-ons
- dessert recommendations

**4. Optimize staffing**

More staff should be scheduled during the busiest periods:
- 12:00–13:00
- 17:00–19:00

Monday may also require additional staffing because it has the highest weekly order volume.

## How to Reproduce

**1. Download the dataset**

Download the [Restaurant Orders](https://mavenanalytics.io/data-playground/restaurant-orders) from Maven Analytics Data Playground. 
**2. Create the database tables**

Run:

`create_restaurant_db.sql`.

**3. Run the analysis**

Execute:

`restaurant_analysis.sql`.


## Conclusion

The analysis shows that the restaurant's revenue is primarily driven by Italian and Asian dishes, while American dishes generate high order volume at lower prices.

Customer orders are generally small, with 83.5% containing 1–3 items, creating an opportunity to increase average order value through bundles and add-ons.

Demand is concentrated around lunch and dinner, particularly between 12:00–13:00 and 17:00–19:00, which provides a clear opportunity to optimize staffing.

Overall, the analysis demonstrates how SQL can be used not only to retrieve data, but to identify business problems, quantify opportunities, and make data-driven recommendations.




