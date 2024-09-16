USE pizza_sales
SELECT * from order_details;
SELECT * FROM pizzas;
SELECT * FROM orders;
-- KPIS

-- 1) Total Revenue

SELECT 
ROUND(SUM(quantity * price),2) AS [Total Revenue]
FROM order_details AS o
JOIN pizzas AS p 
ON o.pizza_id = p.pizza_id;

-- 2) Average Order Value
-- Total order value / order count
-- So i need the average order value by customer

SELECT 
ROUND(SUM(quantity * price) /COUNT(DISTINCT order_id),2) AS [Average Order Value]
FROM order_details AS o
JOIN pizzas AS p 
ON o.pizza_id = p.pizza_id;

-- 3) Total Pizzas Sold

SELECT 
SUM(quantity) AS [Total Pizzas Sold]
FROM order_details;

-- 4) Total Orders

SELECT 
COUNT(DISTINCT order_id) AS [Total Orders]
FROM order_details;

-- 5) Average Pizza Order
-- pizzas sold/number of pizzas

SELECT 
SUM(quantity)/COUNT(DISTINCT order_id) AS [Average Pizzas Per Order]
FROM order_details;

--6) Daily Trends for Total Orders

SELECT
FORMAT( date, 'dddd') AS DayOfWeek
,COUNT(DISTINCT order_id) AS total_orders
FROM orders
GROUP BY FORMAT( date, 'dddd')
ORDER BY total_orders DESC;

-- 7) Hourly Trends for Total Orders
SELECT
DATEPART(HOUR, time) AS [Hour]
,COUNT( DISTINCT order_id) AS [COUNT]
FROM orders
GROUP BY DATEPART(HOUR, time)
ORDER BY [HOUR];

-- 8) Percentage of Sales by Pizza Category
-- a: Calculate total revenue per category
-- % sales calculated as (a:/total revenue) * 100

SELECT
category
,SUM(quantity * price) AS Revenue
,ROUND(SUM(quantity * price) * 100/(
	SELECT SUM(quantity * price)
	FROM pizzas AS p2
	JOIN order_details AS od2 ON od2.pizza_id = p2.pizza_id
	),2) AS percentage_Sales
FROM
pizzas AS p
JOIN pizza_types AS pt ON p.pizza_type_id = pt.pizza_type_id
JOIN order_details AS od ON od.pizza_id = p.pizza_id
GROUP BY category
ORDER BY Percentage_Sales DESC;

-- 9) Percentage of Sales by Pizza Size

SELECT
size
,SUM(quantity * price) AS Revenue
,ROUND(SUM(quantity * price) * 100/(
	SELECT SUM(quantity * price)
	FROM pizzas AS p2
	JOIN order_details AS od2 ON od2.pizza_id = p2.pizza_id
	),2) AS percentage_Sales
FROM
pizzas AS p
JOIN pizza_types AS pt ON p.pizza_type_id = pt.pizza_type_id
JOIN order_details AS od ON od.pizza_id = p.pizza_id
GROUP BY size
ORDER BY Percentage_Sales DESC;

-- 10) Total Pizzas Sold by Pizza Category

SELECT 
category
, SUM(quantity) AS quantity_sold
FROM
pizzas AS p
JOIN pizza_types AS pt ON p.pizza_type_id = pt.pizza_type_id
JOIN order_details AS od ON od.pizza_id = p.pizza_id
GROUP BY category
ORDER BY SUM(quantity) DESC;

-- 11) Top 5 Best Sellers by Total Pizzas Sold

SELECT TOP 5
name
, SUM(quantity) AS total_pizzas_sold
FROM
pizzas AS p
JOIN pizza_types AS pt ON p.pizza_type_id = pt.pizza_type_id
JOIN order_details AS od ON od.pizza_id = p.pizza_id
GROUp BY name
ORDER BY total_pizzas_sold DESC;

-- 12) Bottom 5 Worst Sellers by Total Pizzas Sold

SELECT TOP 5
name
, SUM(quantity) AS total_pizzas_sold
FROM
pizzas AS p
JOIN pizza_types AS pt ON p.pizza_type_id = pt.pizza_type_id
JOIN order_details AS od ON od.pizza_id = p.pizza_id
GROUp BY name
ORDER BY total_pizzas_sold ASC;

