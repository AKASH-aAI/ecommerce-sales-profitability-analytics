CREATE DATABASE ecommerce_analytics;

SHOW DATABASES;

USE ecommerce_analytics;

CREATE TABLE ecommerce_sales(
    `Order ID` VARCHAR(20),
    `Order Date` Date,
    `Customer Nmae` VARCHAR(30),
    `Region` VARCHAR(20),
    `City` VARCHAR(30),
    `Category` VARCHAR(50),
    `Sub-Category` VARCHAR(100),
    `Product Nmae` VARCHAR(200),
    `Quantity` INT,
    `Unit Price` DECIMAL(12,2),
    `Discount` DECIMAL(8,4),
    `Sales` DECIMAL(12,2),
    `Profit` DECIMAL(12,2),
    `Payment Mode` VARCHAR(50),
    `Order Month` VARCHAR(7),
    `Profit Margin` DECIMAL(12,2)
);

-- Q1:Identify which product categories generate the highest sales
-- and profit, and which categories have weaker profit margins.

SELECT category,round(sum(sales),2) as total_sales,
round(sum(profit),2) as total_profit,
round(sum(profit)/nullif(sum(sales),0)*100,2) AS
profit_margin_percent,
sum(Quantity) as total_quantity
from ecommerce_sales
GROUP BY Category ORDER BY total_profit DESC;

-- Q2: Identify the most and least profitable products based on total profit.

SELECT `product name`,round(sum(sales),2) as total_sales,
round(sum(profit),2) as total_profit, round(sum(profit)/
nullif(sum(sales),0)*100,2) as profit_margin_percent,
sum(Quantity) as total_quantity from ecommerce_sales
GROUP BY `Product name` ORDER BY total_profit DESC LIMIT 10;

-- Q3: Discount Impact and Profit Leakage Analysis
-- Identify sub-categories where high discounts are associated
-- with weak profit margins or negative total profit.


SELECT `sub-category`,round(sum(sales*Discount)/
nullif(sum(sales),0),2) as Weighted_Avg_Discount,
round(sum(sales),2) as total_sales,
round(sum(profit)/nullif(sum(sales),0)*100,2)
as profit_margin_percent
from ecommerce_sales GROUP BY `Sub-Category`
ORDER BY profit_margin_percent ASC;

-- Q4: Month-over-Month Sales and Profit Growth
-- Compare monthly sales and profit with the previous month.

with monthly_sales as (
    SELECT `order month`,
    sum(sales) as total_sales,
    sum(profit) as total_profit
    from ecommerce_sales GROUP BY `Order Month`
)
SELECT `order month`,
round(total_sales,2) as total_sales,
round((total_sales - LAG(total_sales) over (order by `order month`))/
nullif(LAG(total_sales) over (order BY `order month`),0)*100,2) as
Sales_Growth_Percent,
round(total_profit,2) as total_profit,
round((total_profit - lag(total_profit) over (order by `order month`))/
nullif(lag(total_profit) over (order by `order month`),0)*100,2)
as profit_growth_percent
from monthly_sales 
ORDER BY `order month`;

-- Q5: High-Sales, Low-Profit Product Analysis

SELECT `product name` , round(sum(sales),2) as total_sales,
round(sum(profit),2) as total_profit,round(sum(Profit)/
nullif(sum(sales),0)*100,2) as profit_margin_percent
from ecommerce_sales GROUP BY `product name` ORDER BY
total_sales DESC LIMIT 10;

-- Q6:Identify the 50 products with the lowest profit margins.

SELECT `product name`,round(sum(profit)/
nullif(sum(sales),0)*100,2) as profit_margin_percent
from ecommerce_sales
group by `product name` order by profit_margin_percent ASC
LIMIT 50;

-- Q7: Identify the products that contribute the most to
-- overall business profit.

SELECT `product name`, round(sum(profit),2) as
total_profit, round(sum(profit)/(SELECT sum(profit)
from ecommerce_sales)*100,2) as profit_contribution_percent
from ecommerce_sales group by `product name` order by
total_profit DESC LIMIT 10;

SELECT SUM(Profit) AS Total_Business_Profit
FROM ecommerce_sales;

-- Q8: Compare total profit and profit margin across discount levels.

SELECT discount,round(sum(sales),2) as total_sales,
round(sum(profit),2) as total_profit, round(sum(profit)/
nullif(sum(sales),0)*100,2) as profit_margin_percent
from ecommerce_sales GROUP BY Discount ORDER BY
profit_margin_percent DESC;

-- Q9: Compare total sales, total profit, and profit margin
-- across payment modes.

SELECT `payment mode`, round(sum(sales),2) as 
total_sales,round(sum(profit),2) as total_profit,
round(sum(profit)/nullif(sum(sales),0)*100,2) AS
profit_margin_percent FROM ecommerce_sales
group by `payment mode`
order by profit_margin_percent DESC;

-- Q10: Sales vs Profit Performance Analysis
-- Identify months where sales are high but profitability is weak.

SELECT `order month`,round(sum(profit)/
nullif(sum(sales),0)*100,2) as profit_margin_percent
from ecommerce_sales GROUP BY `Order Month`
ORDER BY profit_margin_percent DESC;

SELECT * FROM ecommerce_sales; 