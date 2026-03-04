CREATE DATABASE Sales;
USE Sales;
CREATE TABLE superstore_sales (
    ship_mode VARCHAR(50),
    segment VARCHAR(50),
    country VARCHAR(50),
    city VARCHAR(50),
    state VARCHAR(50),
    postal_code INT,
    region VARCHAR(50),
    category VARCHAR(50),
    sub_category VARCHAR(50),
    sales DECIMAL(10,2),
    quantity INT,
    discount DECIMAL(4,2),
    profit DECIMAL(10,2)
);
#Total Revenue# 
SELECT SUM(sales) AS total_revenue
 FROM sales.samplesuperstore;
 #Revenue by Region#
 SELECT region,
       SUM(sales) AS total_revenue
FROM sales.samplesuperstore
GROUP BY region
ORDER BY total_revenue DESC;

#Category-wise Sales & Profit#
SELECT category,
       SUM(sales) AS total_sales,
       SUM(profit) AS total_profit
FROM sales.samplesuperstore
GROUP BY category
ORDER BY total_profit DESC;

#Top 10 Profitable Sub-Categories#
SELECT `Sub-Category`,
       SUM(profit) AS total_profit
FROM sales.samplesuperstore
GROUP BY `Sub-Category`
ORDER BY total_profit DESC
LIMIT 10;

#Loss-Making Sub-Categories#
SELECT `Sub-Category`,
       SUM(profit) AS total_profit
FROM sales.samplesuperstore
GROUP BY `Sub-Category`
HAVING SUM(profit) < 0;

#Discount vs Average Profit#
SELECT discount,
       AVG(profit) AS avg_profit
FROM sales.samplesuperstore
GROUP BY discount
ORDER BY discount;

#Segment-wise Revenue#
SELECT segment,
       SUM(sales) AS total_revenue
FROM sales.samplesuperstore
GROUP BY segment
ORDER BY total_revenue DESC;

#Top 10 States by Revenue#
SELECT state,
       SUM(sales) AS total_revenue
FROM sales.samplesuperstore
GROUP BY state
ORDER BY total_revenue DESC
LIMIT 10;

#to check exact column names#
DESCRIBE sales.samplesuperstore;

#Profit Margin by Category#
SELECT category,
       SUM(sales) AS total_sales,
       SUM(profit) AS total_profit,
       ROUND((SUM(profit) / SUM(sales)) * 100, 2) AS profit_margin_percent
FROM sales.samplesuperstore
GROUP BY category
ORDER BY profit_margin_percent DESC;

#Region-wise Average Discount Impact#
SELECT region,
       ROUND(AVG(discount), 2) AS avg_discount,
       ROUND(AVG(profit), 2) AS avg_profit
FROM sales.samplesuperstore
GROUP BY region
ORDER BY avg_discount DESC;

#Top 5 States by Profit#
SELECT state,
       SUM(profit) AS total_profit
FROM sales.samplesuperstore
GROUP BY state
ORDER BY total_profit DESC
LIMIT 5;

#Category Contribution Percentage#
SELECT category,
       SUM(sales) AS total_sales,
       ROUND(SUM(sales) * 100 / 
             (SELECT SUM(sales) FROM sales.samplesuperstore), 2) 
             AS contribution_percent
FROM sales.samplesuperstore
GROUP BY category
ORDER BY contribution_percent DESC;

#Create Region Table#
CREATE TABLE sales.regions_table AS
SELECT DISTINCT region, state
FROM sales.samplesuperstore;

#Create Category Table#
CREATE TABLE sales.category_table AS
SELECT DISTINCT category, `Sub-Category`
FROM sales.samplesuperstore;

#Create Fact Table#
CREATE TABLE sales.sales_fact_table AS
SELECT region, state, category, `Sub-Category`,
       sales, quantity, discount, profit
FROM sales.samplesuperstore;

#Join Category Table to Calculate Profit by Category#
SELECT c.category,
       SUM(f.profit) AS total_profit
FROM sales.sales_fact_table f
JOIN sales.category_table c
ON f.category = c.category
GROUP BY c.category
ORDER BY total_profit DESC;

#Join Region Table to Calculate Revenue by Region#
SELECT r.region,
       SUM(f.sales) AS total_sales
FROM sales.sales_fact_table f
JOIN sales.regions_table r
ON f.state = r.state
GROUP BY r.region
ORDER BY total_sales DESC;

#Region & Category Combined Analysis (Very Strong)#
SELECT r.region,
       c.category,
       SUM(f.sales) AS total_sales,
       SUM(f.profit) AS total_profit
FROM sales.sales_fact_table f
JOIN sales.regions_table r
ON f.state = r.state
JOIN sales.category_table c
ON f.category = c.category
GROUP BY r.region, c.category
ORDER BY r.region, total_profit DESC;

#Loss-making Categories by Region#
SELECT r.region,
       c.category,
       SUM(f.profit) AS total_profit
FROM sales.sales_fact_table f
JOIN sales.regions_table r
ON f.state = r.state
JOIN sales.category_table c
ON f.category = c.category
GROUP BY r.region, c.category
HAVING SUM(f.profit) < 0;

#Identify Top 20% Revenue-Contributing Categories#
SELECT category,
       SUM(sales) AS total_sales,
       ROUND(SUM(sales) * 100 /
            (SELECT SUM(sales) FROM sales.samplesuperstore), 2)
            AS revenue_percent
FROM sales.samplesuperstore
GROUP BY category
ORDER BY revenue_percent DESC;