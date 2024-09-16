# Pizza Sales Portfolio Project – SQL & Power BI

### Problem Statement:

**Pizza Place Inc.** needed a comprehensive data-driven approach to understand its sales performance and customer behaviours. The company sought answers to key business questions, including:

- **How much revenue did we generate this year?**
- **What is the average order value and total pizzas sold?**
- **What are the daily and hourly sales trends?**
- **Which pizza categories and sizes drive the most sales?**
- **Which pizzas are the best and worst sellers?**

### Data source:
I got the data from https://www.kaggle.com/datasets/mysarahmadbhat/pizza-place-sales

A zip file is also included in this repository.
### How I would solve the problem
By analyzing KPIs like **Total Revenue**, **Average Order Value**, and **Total Orders**, I will import the data into Microsft SQL server management studio(SSMS) to clean and transform the data after which I will use Power BI to create a report that identifies daily and hourly trends. 
The analysis will further break down sales by pizza category and size, highlighting the top 5 best-selling pizzas and the 5 worst sellers. Insights gained will help the business optimize inventory, target promotions, and refine the product mix to increase profitability.

### Steps I Took

- I launched SSMS and created a new database called pizza_sales.
- I imported the four flat files(order_details, orders, pizza_types and pizzas) into the database.
- Changed the data to the appropriate data type and performed data exploration to understand the data.
- Exported the data and imported it into Power BI.

### Queries Used

You can download all the full queries from the SQL file in this repository. Below is a summary of the main queries:

```sql
## Database Setup
```sql
USE pizza_sales;
```

## KPI Queries

### 1. Total Revenue
```sql
SELECT ROUND(SUM(quantity * price), 2) AS [Total Revenue]
FROM order_details AS o
JOIN pizzas AS p ON o.pizza_id = p.pizza_id;
```

### 2. Average Order Value
```sql
SELECT ROUND(SUM(quantity * price) / COUNT(DISTINCT order_id), 2) AS [Average Order Value]
FROM order_details AS o
JOIN pizzas AS p ON o.pizza_id = p.pizza_id;
```

### 3. Total Pizzas Sold
```sql
SELECT SUM(quantity) AS [Total Pizzas Sold]
FROM order_details;
```

### 4. Total Orders
```sql
SELECT COUNT(DISTINCT order_id) AS [Total Orders]
FROM order_details;
```

### 5. Average Pizzas per Order
```sql
SELECT SUM(quantity) / COUNT(DISTINCT order_id) AS [Average Pizzas Per Order]
FROM order_details;
```

## Business Insights

### 6. Daily Trends for Total Orders
```sql
SELECT FORMAT(date, 'dddd') AS DayOfWeek, COUNT(DISTINCT order_id) AS total_orders
FROM orders
GROUP BY FORMAT(date, 'dddd')
ORDER BY total_orders DESC;
```

### 7. Hourly Trends for Total Orders
```sql
SELECT DATEPART(HOUR, time) AS [Hour], COUNT(DISTINCT order_id) AS [COUNT]
FROM orders
GROUP BY DATEPART(HOUR, time)
ORDER BY [Hour];
```

### 8. Percentage of Sales by Pizza Category
```sql
SELECT category, SUM(quantity * price) AS Revenue,
ROUND(SUM(quantity * price) * 100 / (SELECT SUM(quantity * price) FROM pizzas AS p2
JOIN order_details AS od2 ON od2.pizza_id = p2.pizza_id), 2) AS percentage_Sales
FROM pizzas AS p
JOIN pizza_types AS pt ON p.pizza_type_id = pt.pizza_type_id
JOIN order_details AS od ON od.pizza_id = p.pizza_id
GROUP BY category
ORDER BY percentage_Sales DESC;
```

### 9. Percentage of Sales by Pizza Size
```sql
SELECT size, SUM(quantity * price) AS Revenue,
ROUND(SUM(quantity * price) * 100 / (SELECT SUM(quantity * price) FROM pizzas AS p2
JOIN order_details AS od2 ON od2.pizza_id = p2.pizza_id), 2) AS percentage_Sales
FROM pizzas AS p
JOIN pizza_types AS pt ON p.pizza_type_id = pt.pizza_type_id
JOIN order_details AS od ON od.pizza_id = p.pizza_id
GROUP BY size
ORDER BY percentage_Sales DESC;
```

### 10. Total Pizzas Sold by Pizza Category
```sql
SELECT category, SUM(quantity) AS quantity_sold
FROM pizzas AS p
JOIN pizza_types AS pt ON p.pizza_type_id = pt.pizza_type_id
JOIN order_details AS od ON od.pizza_id = p.pizza_id
GROUP BY category
ORDER BY SUM(quantity) DESC;
```

### 11. Top 5 Best Sellers by Total Pizzas Sold
```sql
SELECT TOP 5 name, SUM(quantity) AS total_pizzas_sold
FROM pizzas AS p
JOIN pizza_types AS pt ON p.pizza_type_id = pt.pizza_type_id
JOIN order_details AS od ON od.pizza_id = p.pizza_id
GROUP BY name
ORDER BY total_pizzas_sold DESC;
```

### 12. Bottom 5 Worst Sellers by Total Pizzas Sold
```sql
SELECT TOP 5 name, SUM(quantity) AS total_pizzas_sold
FROM pizzas AS p
JOIN pizza_types AS pt ON p.pizza_type_id = pt.pizza_type_id
JOIN order_details AS od ON od.pizza_id = p.pizza_id
GROUP BY name
ORDER BY total_pizzas_sold ASC;
```

### Data Visualization
