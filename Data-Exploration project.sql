 --Exploring the Order table. Examining total revenue, highest, lowest, and average sales generated
SELECT
    COUNT(*) AS total_orders,
    SUM(total_amount) AS total_revenue,
    AVG(total_amount) AS average_order_value,
    MIN(total_amount) AS lowest_order,
    MAX(total_amount) AS highest_order
FROM Orders

--Exploring the Customers table. Examining Each location of customers using the right query
SELECT Country, COUNT(*) AS Totalcustomers_per_country
FROM Customers
GROUP BY Country
ORDER BY Totalcustomers_per_country DESC

--Exploring the Products table. Examining to understand how products are in each category, AND the pricing structures PER CATEGORY
SELECT category, COUNT(category) AS total_products_per_category
FROM Products
GROUP BY category
ORDER BY total_products_per_category ASC

SELECT category,
MIN(Price) AS Lower_price,
MAX(Price) AS Hightest_price,
AVG(Price) AS Average_price
FROM Products
GROUP BY category
ORDER BY Average_price DESC

CREATE VIEW revenue AS 
SELECT category,
MIN(Price) AS Lower_price,
MAX(Price) AS Hightest_price,
AVG(Price) AS Average_price
FROM Products
GROUP BY category

--Exploring Orders Values 
SELECT
order_id,
customer_id,
order_date,
total_amount
FROM Orders
WHERE total_amount >= 1000

SELECT 
order_id,
customer_id,
order_date,
total_amount
FROM Orders
WHERE total_amount BETWEEN 500 AND 999
GROUP BY order_id,
customer_id,
order_date,
total_amount

SELECT
order_id,
customer_id,
order_date,
total_amount
FROM Orders
WHERE total_amount <= 499

--Exploring How many customers are in the Nigeria AND in other 3 countries.
SELECT 
customer_id,
customer_name,
city,
country
FROM Customers
WHERE country = 'NIGERIA'

SELECT 
customer_id,
customer_name,
city,
country
FROM Customers
WHERE country IN('Canada', 'Japan', 'AUSTRIA ')
ORDER BY 
country ASC


--Checking orders by date range
SELECT 
order_id,
customer_id,
order_date,
total_amount
FROM Orders
WHERE order_date BETWEEN '2025-01-1' AND '2025-03-31'
GROUP BY
order_id,
customer_id,
order_date,
total_amount
ORDER BY order_date ASC

---Joining 2 tables together and finding out how many order each customer place
SELECT 
C.customer_id,
C.customer_name,
O.order_id,
O.order_date,
O.total_amount
FROM Customers C
JOIN Orders O
ON C.customer_id = O.customer_id

SELECT 
C.customer_id,
C.customer_name,
COUNT(O.order_id) AS total_order,
C.country
FROM Customers C
INNER JOIN Orders O
ON C.customer_id = O.customer_id
GROUP BY
C.customer_id,
C.customer_name,
C.country
ORDER BY total_order DESC

--now let's calculate the price of each product sold
SELECT 
P.product_id,
P.product_name,
P.category,
SUM(OI.quantity)AS unit_sold,
SUM(OI.quantity * P.price) AS revenue
FROM Order_Items AS OI
INNER JOIN Products AS P
ON OI.product_id = P.product_id
GROUP BY 
P.product_id,
P.product_name,
P.category
ORDER BY revenue DESC 

 --Create view for Visualization purpose
 
CREATE VIEW productsoldrevenue AS
SELECT 
P.product_id,
P.product_name,
P.category,
SUM(OI.quantity)AS unit_sold,
SUM(OI.quantity * P.price) AS revenue
FROM Order_Items AS OI
INNER JOIN Products AS P
ON OI.product_id = P.product_id
GROUP BY 
P.product_id,
P.product_name,
P.category

SELECT
order_id,
customer_id,
order_date,
total_amount,
CASE
WHEN total_amount >=1000 THEN 'Higher_Amount'
WHEN total_amount >=500 THEN 'Average_Amount'
ELSE 'Low_Amount'
END AS Order_Value
FROM Orders
ORDER BY Order_Value ASC

--Let explore revenue each category generate

SELECT
C.customer_name,
C.country,
O.order_id,
O.order_date,
P.product_name,
P.category,
OI.quantity,
P.price,
OI.quantity * P.price AS item_amount
FROM Customers C
JOIN Orders O
ON C.customer_id = O.customer_id
INNER JOIN Order_Items OI
ON O.order_id = OI.order_id
INNER JOIN Products P
ON OI.product_id = P.product_id

--Let's find how much each customer is spending
WITH customerspeding AS
(
SELECT
C.customer_id,
C.customer_name,
SUM(total_amount) AS Total_spending
FROM Customers C
JOIN Orders O
ON C.customer_id = O.customer_id
GROUP BY 
C.customer_id, 
C.customer_name
)

SELECT*
FROM customerspeding
WHERE Total_spending >= 2000
ORDER BY Total_spending ASC

--Exploring the customer and order table using a TEMP table in SQL to classify customer and their spending
DROP TABLE IF EXISTS #customerexpenses
CREATE TABLE #customerexpenses
(
    customer_id INT,
    customer_name VARCHAR(100),
    total_spending DECIMAL(18,2)
);

INSERT INTO #customerexpenses
(
    customer_id,
    customer_name,
    total_spending
)
SELECT
    cu.customer_id,
    cu.customer_name,
    SUM(ord.total_amount) AS total_spending
FROM customers AS cu
INNER JOIN orders AS ord
    ON cu.customer_id = ord.customer_id
GROUP BY
    cu.customer_id,
    cu.customer_name;
-- using WHERE statement to get customers who spent 500 to 1000
    SELECT *
    FROM #customerexpenses
    WHERE total_spending BETWEEN 500 AND 1010
    ORDER BY total_spending ASC

--Still exploring our TEMP table using CASE statement
    SELECT*,
    CASE
    WHEN total_spending >= 2500 THEN 'VIP Customer'
    WHEN total_spending >= 1000 THEN 'Good Customer'
    WHEN total_spending >= 500 THEN 'Upcoming Customer'
    ELSE 'Regular Customer'
    END AS Customerspending_grouping
    FROM #customerexpenses
    ORDER BY total_spending DESC 
