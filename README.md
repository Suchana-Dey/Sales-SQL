# 📊 Sales & Customer Performance Analysis (SQL)

## 📌 Project Overview
This project analyzes retail sales data using MySQL to identify revenue drivers, profitability patterns, discount impact, and regional performance.  
The objective is to simulate real-world Business Analyst decision-making using SQL aggregation, subqueries, and joins.

---

## 🗄️ Database Setup

```sql
CREATE DATABASE Sales;
USE Sales;

---

## 🔎 Key Business Analyses Performed

### 1️⃣ Revenue Analysis
- Total revenue calculation  
- Revenue by region  
- Segment-wise revenue contribution  
- Top 10 states by revenue  

### 2️⃣ Profitability Analysis
- Category-wise sales & profit  
- Top 10 profitable sub-categories  
- Loss-making sub-categories  
- Profit margin by category  
- Top 5 states by profit  

### 3️⃣ Discount Impact Analysis
- Discount vs average profit  
- Region-wise discount impact  

### 4️⃣ Revenue Contribution Percentage
- Category contribution to total revenue  
- Revenue concentration analysis  

---

## 🏗️ Data Modeling (Star Schema Simulation)

To demonstrate JOIN operations, the dataset was structured into:

- `regions_table`
- `category_table`
- `sales_fact_table`

This simulates a simplified data warehouse model used in business environments.

---

## 🧠 SQL Concepts Used

- SELECT
- SUM(), AVG()
- GROUP BY
- HAVING
- ORDER BY
- LIMIT
- ROUND()
- Subqueries
- INNER JOIN
- Table Creation using `CREATE TABLE AS`

---

## 📈 Sample Query

```sql
SELECT category,
       SUM(sales) AS total_sales,
       ROUND(SUM(sales) * 100 /
            (SELECT SUM(sales) FROM sales.samplesuperstore), 2)
            AS revenue_percent
FROM sales.samplesuperstore
GROUP BY category
ORDER BY revenue_percent DESC;
