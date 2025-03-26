
SELECT *
FROM ecommerce_sales_data;

ALTER TABLE ecommerce_sales_data
MODIFY order_date DATE;

-- total sales amount by payment method

SELECT payment_method, SUM(total_amount) AS Total_amount
FROM ecommerce_sales_data
GROUP BY payment_method;

SELECT DISTINCT category
FROM ecommerce_sales_data;

-- finding duplicates.

WITH duplicate_cte AS
(SELECT *,
ROW_NUMBER() OVER(PARTITION BY order_id, customer_id, customer_name, product_id, product_name, category, price, quantity, total_amount, order_date, payment_method, city, state, country, `status`) AS row_num
FROM ecommerce_sales_data)
SELECT *
FROM duplicate_cte
WHERE row_num > 1;

-- total sales by year

SELECT YEAR(order_date) AS `Year`, SUM(total_amount) AS Total_amount
FROM ecommerce_sales_data
GROUP BY `Year`;

-- Find the total revenue generated per product category

SELECT category, SUM(total_amount) AS Total_amount
FROM ecommerce_sales_data
GROUP BY category;

-- Find the top 5 customers who have spent the most on products

SELECT customer_name, SUM(total_amount) AS Total_spent
FROM ecommerce_sales_data
GROUP BY customer_name
ORDER BY Total_spent DESC
LIMIT 5;

-- Find the average order value by city

SELECT city, AVG(total_amount) AS Avg_order_value
FROM ecommerce_sales_data
GROUP BY city;

-- Find the number of orders and total revenue for each payment method

SELECT payment_method, SUM(total_amount) AS Total_revenue, COUNT(order_id) AS Num_of_orders
FROM ecommerce_sales_data
GROUP BY payment_method;

-- Get the product with the highest total revenue and the lowest total revenue

SELECT product_name, SUM(total_amount) AS Total_revenue
FROM ecommerce_sales_data
GROUP BY product_name
ORDER BY Total_revenue DESC
LIMIT 1;

SELECT product_name, SUM(total_amount) AS Total_revenue
FROM ecommerce_sales_data
GROUP BY product_name
ORDER BY Total_revenue ASC
LIMIT 1;

-- Get the total number of products sold for each product name

SELECT product_name, SUM(quantity) AS Number_sold
FROM ecommerce_sales_data
GROUP BY product_name
ORDER BY Number_sold DESC;

-- Find customers who have placed more than 3 orders

SELECT customer_name, COUNT(DISTINCT order_id) AS Num_of_orders
FROM ecommerce_sales_data
GROUP BY customer_name
HAVING Num_of_orders >= 3;

-- Get the total revenue for each month

SELECT DATE_FORMAT(order_date, '%m') AS `Month`, SUM(total_amount) AS Total_revenue
FROM ecommerce_sales_data
GROUP BY `Month`
ORDER BY `Month` ASC;

-- Find the customers who ordered from the most number of unique cities

SELECT customer_name, COUNT(DISTINCT city) AS Num_of_uneque_city
FROM ecommerce_sales_data
GROUP BY customer_name
ORDER BY Num_of_uneque_city DESC
LIMIT 1;

-- Find the average order value for each state and product category

SELECT category, state, AVG(total_amount) AS avg_value
FROM ecommerce_sales_data
GROUP BY category, state
ORDER BY category, state;

-- Find the customers who spent more than the average spending

SELECT customer_name, SUM(total_amount) AS total_spent
FROM ecommerce_sales_data
GROUP BY customer_name
HAVING total_spent > (SELECT AVG(total_amount) FROM ecommerce_sales_data);

-- Find the percentage of completed orders by country

SELECT country, (SUM(CASE WHEN `status` = 'Canceled' THEN 1 ELSE 0 END) / COUNT(order_id)) * 100 AS completed_perc
FROM ecommerce_sales_data
GROUP BY country;

--  Find the total quantity sold for each product in the past 30 days

SELECT product_name, SUM(quantity) AS total_qty_sold
FROM ecommerce_sales_data
WHERE order_date >= CURDATE() - INTERVAL 30 DAY
GROUP BY product_name;

-- Find the most frequent product ordered by each customer

SELECT customer_name, product_name, COUNT(*) AS product_count
FROM ecommerce_sales_data
GROUP BY customer_name, product_name
ORDER BY customer_name, product_count DESC;

-- Get the number of orders placed before and after a specific date

SELECT 
	COUNT(CASE WHEN order_date < '2025-02-28' THEN 1 END) AS order_before,
    COUNT(CASE WHEN order_date >= '2025-03-01' THEN 1 END) AS order_after
FROM ecommerce_sales_data;

-- Find the city with the highest total revenue and its associated product category

SELECT city, category, SUM(total_amount) AS total_revenue
FROM ecommerce_sales_data
GROUP BY city, category
ORDER BY total_revenue DESC
LIMIT 1;

-- Find the percentage of orders in each status

SELECT `status`, 
	(COUNT(order_id) / (SELECT COUNT(order_id) FROM ecommerce_sales_data )) * 100 AS percentage
FROM ecommerce_sales_data
GROUP BY `status`;

SELECT `status`, COUNT(order_id), (SELECT COUNT(order_id) FROM ecommerce_sales_data)
FROM ecommerce_sales_data
GROUP BY `status`;

-- Find the top-selling product in each city

SELECT product_name, city, SUM(total_amount) AS total_revenue
FROM ecommerce_sales_data
GROUP BY product_name, city
ORDER BY total_revenue DESC
LIMIT 5;

-- Find the customers who ordered the most expensive product

SELECT customer_name, price
FROM ecommerce_sales_data
ORDER BY price DESC;

SELECT customer_name, price
FROM ecommerce_sales_data
WHERE price = (SELECT MAX(price) FROM ecommerce_sales_data);