/* ============================================================
   1. MENU ANALYSIS
   ============================================================ */

-- Question: How many items are on the menu?
-- Insight: The menu has 32 items.
SELECT COUNT(menu_item_id) AS item_count
FROM menu_items;

-- Question: What is the most expensive item on the menu?
-- Insight: Shrimp Scampi is the most expensive item at $19.95.
SELECT TOP 1 WITH TIES
    item_name,
    price
FROM menu_items
ORDER BY price DESC;

-- Question: What is the cheapest item on the menu?
-- Insight: Edamame is the cheapest item at $5.00.
SELECT TOP 1 WITH TIES
    item_name,
    price
FROM menu_items
ORDER BY price ASC;

-- Question: How many Italian dishes are there, and what are the cheapest and most expensive?
-- Insight: There are 9 Italian dishes, priced from $14.50 to $19.95.
SELECT
    COUNT(*)   AS italian_dishes,
    MIN(price) AS cheapest,
    MAX(price) AS most_expensive
FROM menu_items
WHERE category = 'Italian';

-- Question: How many dishes are in each category, and what is the average price?
-- Insight: Italian dishes are the most expensive on average ($16.75), American the cheapest ($10.07).
SELECT
    category,
    COUNT(item_name)     AS dish_count,
    ROUND(AVG(price), 2) AS average_price
FROM menu_items
GROUP BY category
ORDER BY average_price DESC;


/* ============================================================
   2. ORDER ANALYSIS
   ============================================================ */

-- Question: What is the date range of the orders?
-- Insight: Orders cover 1 January to 31 March 2023.
SELECT
    MIN(order_date) AS first_date,
    MAX(order_date) AS last_date
FROM order_details;

-- Question: How many orders and items are in the data?
-- Insight: 5,370 orders. 137 of the 12,234 rows have no item_id and are excluded from item analysis.
SELECT
    COUNT(DISTINCT order_id) AS total_orders,
    COUNT(item_id)           AS total_items_with_id,
    COUNT(*)                 AS total_rows
FROM order_details;

-- Question: Which orders had the most items?
-- Insight: The largest orders have 14 items (7 orders, including 330, 440 and 2675).
SELECT TOP 10
    order_id,
    COUNT(item_id) AS item_count
FROM order_details
GROUP BY order_id
ORDER BY item_count DESC;

-- Question: How many orders had more than 12 items?
-- Insight: 20 orders had more than 12 items.
SELECT COUNT(*) AS orders_over_12_items
FROM (
    SELECT order_id
    FROM order_details
    GROUP BY order_id
    HAVING COUNT(item_id) > 12
) AS large_orders;

-- Question: Which items were ordered the most and the least, and in which categories?
-- Insight: Hamburger (622) and Edamame (620) lead. Chicken Tacos is the least ordered (123).
SELECT
    m.item_name,
    m.category,
    COUNT(o.order_details_id) AS order_count
FROM menu_items m
LEFT JOIN order_details o
    ON o.item_id = m.menu_item_id
GROUP BY m.item_name, m.category
ORDER BY order_count DESC;


-- Question: What are the average order value and the average number of items per order?
-- Insight: The average order is worth about $29.80 and contains about 2.3 items.
WITH order_totals AS (
    SELECT
        o.order_id,
        SUM(m.price)   AS order_value,
        COUNT(o.item_id) AS item_count
    FROM order_details o
    JOIN menu_items m
        ON o.item_id = m.menu_item_id
    GROUP BY o.order_id
)
SELECT
    ROUND(AVG(order_value), 2)        AS avg_order_value,
    ROUND(AVG(item_count * 1.0), 2)   AS avg_items_per_order
FROM order_totals;

-- Question: How many orders are small, medium and large?
-- Insight: 83.5% of orders are small (1-3 items), 14.8% medium (4-8) and 1.6% large (9+).
WITH order_items AS (
    SELECT
        order_id,
        COUNT(item_id) AS item_count
    FROM order_details
    GROUP BY order_id
)
SELECT
    size_group,
    COUNT(*) AS order_count
FROM (
    SELECT
        order_id,
        CASE
            WHEN item_count <= 3 THEN 'small'
            WHEN item_count <= 8 THEN 'medium'
            ELSE 'large'
        END AS size_group
    FROM order_items
) AS grouped_orders
GROUP BY size_group
ORDER BY order_count DESC;


/* ============================================================
   3. REVENUE ANALYSIS
   ============================================================ */

-- Question: Which 5 orders spent the most money?
-- Insight: Order 440 is the highest at $192.15.
SELECT TOP 5
    o.order_id,
    SUM(m.price) AS order_total
FROM order_details o
JOIN menu_items m
    ON o.item_id = m.menu_item_id
GROUP BY o.order_id
ORDER BY order_total DESC;


-- Question: Which items were bought in the highest-spending order?
-- Insight: Order 440 has 14 items, 8 of them Italian dishes.
SELECT
    o.order_id,
    m.item_name,
    m.category,
    m.price
FROM order_details o
JOIN menu_items m
    ON o.item_id = m.menu_item_id
WHERE o.order_id = (
    SELECT TOP 1 o2.order_id
    FROM order_details o2
    JOIN menu_items m2
        ON o2.item_id = m2.menu_item_id
    GROUP BY o2.order_id
    ORDER BY SUM(m2.price) DESC
)
ORDER BY m.price DESC;


-- Question: Which items were bought in each of the top 5 highest-spending orders?
-- Insight: The top orders are large group meals with 13-14 items.
WITH top_orders AS (
    SELECT TOP 5
        o.order_id,
        SUM(m.price) AS order_total
    FROM order_details o
    JOIN menu_items m
        ON o.item_id = m.menu_item_id
    GROUP BY o.order_id
    ORDER BY order_total DESC
)
SELECT
    t.order_id,
    t.order_total,
    m.item_name,
    m.price
FROM top_orders t
JOIN order_details o
    ON o.order_id = t.order_id
JOIN menu_items m
    ON o.item_id = m.menu_item_id
ORDER BY t.order_total DESC, t.order_id, m.price DESC;

-- Question: What are the top 3 dishes by revenue in each category?
-- Insight: Korean Beef Bowl earns the most overall ($10,554.60). Cheeseburger beats Hamburger in revenue.
WITH item_revenue AS (
    SELECT
        m.category,
        m.item_name,
        SUM(m.price) AS revenue,
        RANK() OVER (PARTITION BY m.category ORDER BY SUM(m.price) DESC) AS rank_no
    FROM order_details o
    JOIN menu_items m
        ON o.item_id = m.menu_item_id
    GROUP BY m.category, m.item_name
)
SELECT
    category,
    item_name,
    revenue,
    rank_no
FROM item_revenue
WHERE rank_no <= 3
ORDER BY category, rank_no;


-- Question: What is the monthly revenue and how does it change from the previous month?
-- Insight: Revenue fell 5.6% in February and rose 7.5% in March.
WITH monthly AS (
    SELECT
        MONTH(o.order_date)           AS month_no,
        DATENAME(month, o.order_date) AS month_name,
        SUM(m.price)                  AS revenue
    FROM order_details o
    JOIN menu_items m
        ON o.item_id = m.menu_item_id
    GROUP BY MONTH(o.order_date), DATENAME(month, o.order_date)
)
SELECT
    month_name,
    revenue,
    LAG(revenue) OVER (ORDER BY month_no) AS prev_revenue,
    revenue - LAG(revenue) OVER (ORDER BY month_no) AS change_amount,
    ROUND(
        100.0 * (revenue - LAG(revenue) OVER (ORDER BY month_no))
        / LAG(revenue) OVER (ORDER BY month_no), 1
    ) AS change_pct
FROM monthly
ORDER BY month_no;


-- Question: What is the running total of revenue by month?
-- Insight: Total revenue for the quarter is $159,217.90.
WITH monthly AS (
    SELECT
        MONTH(o.order_date)           AS month_no,
        DATENAME(month, o.order_date) AS month_name,
        SUM(m.price)                  AS revenue
    FROM order_details o
    JOIN menu_items m
        ON o.item_id = m.menu_item_id
    GROUP BY MONTH(o.order_date), DATENAME(month, o.order_date)
)
SELECT
    month_name,
    revenue,
    SUM(revenue) OVER (ORDER BY month_no) AS running_total
FROM monthly
ORDER BY month_no;


- Question: What share of total revenue does each category generate?
-- Insight: Italian (31.1%) and Asian (29.3%) generate 60.4% of revenue.
WITH category_revenue AS (
    SELECT
        m.category,
        SUM(m.price) AS total_revenue
    FROM order_details o
    JOIN menu_items m
        ON o.item_id = m.menu_item_id
    GROUP BY m.category
)
SELECT
    category,
    ROUND(100.0 * total_revenue / SUM(total_revenue) OVER (), 1) AS revenue_share_pct
FROM category_revenue
ORDER BY revenue_share_pct DESC;


/* ============================================================
   4. TIME ANALYSIS
   ============================================================ */

-- Question: What are the busiest hours?
-- Insight: Peaks are at lunch (12:00-13:00) and dinner (17:00-19:00).
SELECT
    DATEPART(hour, order_time) AS order_hour,
    COUNT(DISTINCT order_id)   AS order_count
FROM order_details
GROUP BY DATEPART(hour, order_time)
ORDER BY order_count DESC;

-- Question: Which weekdays have the most orders?
-- Insight: Monday is the busiest day (885 orders) and Wednesday the quietest (682).
SELECT
    DATENAME(weekday, order_date) AS weekday_name,
    COUNT(DISTINCT order_id)      AS order_count
FROM order_details
GROUP BY DATENAME(weekday, order_date)
ORDER BY order_count DESC;