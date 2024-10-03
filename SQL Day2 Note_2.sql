USE Northwind
-- Aggregation Functions
-- COUNT()
SELECT COUNT(OrderID) AS TotalRecords
FROM Orders

-- COUNT(*) Vs. COUNT(colName): Count * will include all values while Count Columns will not consider null values;

SELECT COUNT(*) AS TotalRecords
FROM Orders

SELECT FirstName, Region
FROM Employees

SELECT COUNT(*), COUNT(Region)
FROM Employees

-- GROUP BY: group rows that have the same value into the summary rows

-- Find total number of orders placed by each customers
SELECT c.CustomerID, c.ContactName, COUNT(o.OrderID) AS NumberofOrders
FROM Customers c JOIN Orders o ON c.CustomerId = o.CustomerId
GROUP BY c.CustomerID, c.ContactName
ORDER BY NumberofOrders

-- A more complex templates:
-- Only retrieve total order number where customer located in USA or Canada, and Order Number should greather or equals 10
-- To filter aggregate field we have to use HAVING clause
SELECT c.CustomerID, c.ContactName, c.Country, COUNT(o.OrderID) AS NumberofOrders
FROM Customers c JOIN Orders o ON c.CustomerId = o.CustomerId
WHERE c.Country IN ('USA', 'Canada')
GROUP BY c.CustomerID, c.ContactName, c.Country
HAVING COUNT(o.OrderID) >= 10
ORDER BY NumberofOrders

-- Difference between WHERE and HAVING
-- 1. Having will only apply to groups as a whole while where applys to only individual rows
-- 2. Where goes before aggregation while HAVING goes after aggregation.
-- 3. WHERE can be use in SELECT, UPDATE, or DELETE but having can only be used in SELECT statement

--  SQL Execution ORDERS
--  FROM/JOIN (Create temp table) -> WHERE -> GROUP BY (All non Aggregate fields) -> HAVING -> SELECT -> DISTINCT -> ORDER 
--                                      |_______________________________________________|
--                                               Can not use Alias from select
--                         Because Select applys in SELECT which is after all filter clauses

--  SELECT fields, Aggregate(field)
--  FROM tables JOIN table 2 ON Condition
--  WHERE criteria --Optional
--  GROUP BY field (ONLY if Aggregate and non aggregate field present)
--  HAVING -- Optional
--  Order BY field (To consider which field to return in order) -- Optional


-- DISTINCT:
-- COUNT DISTINCT: 

SELECT City
FROM Customers

SELECT COUNT(City), COUNT(DISTINCT City)
FROM Customers


-- AVG():
-- List average revenue for each customer

SELECT c.ContactName, c.City, AVG(od.Quantity * od.UnitPrice) AS AvgRevenue
FROM Customers c JOIN ORDERS o ON c.CustomerID = o.CustomerID
                JOIN [Order Details] od ON o.OrderID = od.OrderID
GROUP BY c.ContactName, c.City
ORDER BY AvgRevenue


-- SUM(): Returns the sum value of a numeric column
-- List of Revenue for each customer
SELECT c.ContactName, c.City, SUM(od.Quantity * od.UnitPrice) AS SUMRevenue
FROM Customers c JOIN ORDERS o ON c.CustomerID = o.CustomerID
                JOIN [Order Details] od ON o.OrderID = od.OrderID
GROUP BY c.ContactName, c.City
ORDER BY SUMRevenue

-- MAX(): Returns maximun value of a numeric column
-- List MAximum of Revenue for each customer
SELECT c.ContactName, c.City, MAX(od.Quantity * od.UnitPrice) AS MAXRevenue
FROM Customers c JOIN ORDERS o ON c.CustomerID = o.CustomerID
                JOIN [Order Details] od ON o.OrderID = od.OrderID
GROUP BY c.ContactName, c.City
ORDER BY MAXRevenue

-- MIN(): Returns min value of a numeric column
-- List Cheapest product of Revenue for each customer
SELECT c.ContactName, c.City, MIN(od.UnitPrice) AS CheapestProduct
FROM Customers c JOIN ORDERS o ON c.CustomerID = o.CustomerID
                JOIN [Order Details] od ON o.OrderID = od.OrderID

GROUP BY c.ContactName, c.City
ORDER BY CheapestProduct

-- Top Predicate: Return certain number or certain percentage of records from a query
-- Retrieve top 5 most expensive products
SELECT TOP 5 p.ProductID, p.ProductName, p.UnitPrice
FROM Products p
ORDER BY p.UnitPrice DESC

-- Retrieve top 10 Precent most expensive products
SELECT TOP 10 PERCENT p.ProductID, p.ProductName, p.UnitPrice
FROM Products p
ORDER BY p.UnitPrice DESC

-- List top 5 customers who created the most total revenue
SELECT TOP 5 c.ContactName, c.City, SUM(od.Quantity * od.UnitPrice) AS SUMRevenue
FROM Customers c JOIN ORDERS o ON c.CustomerID = o.CustomerID
                JOIN [Order Details] od ON o.OrderID = od.OrderID
GROUP BY c.ContactName, c.City
ORDER BY SUMRevenue DESC

-- SubQuery: SELECT Statement that is embedded in another SELECT statement
-- Find the customers from the same city where Alejandra Camino lives
SELECT ContactName, City
FROM Customers
WHERE City IN (
    SELECT City
    FROM Customers
    WHERE ContactName = 'Alejandra Camino'
)

-- Find customer who make any orders
-- JOIN

SELECT DISTINCT c.ContactName, c.CustomerID, c.City, c.Country
FROM Customers c JOIN Orders o ON c.CustomerID = o.CustomerID

-- SubQuery
SELECT CustomerID, ContactName, City, Country
FROM Customers
WHERE CustomerID IN(
    SELECT DISTINCT CustomerID
    FROM ORDERS
)

--  SubQuqey VS. JOIN
--  1. Join can only be use in FROM CLause while SubQuery can be use in SELECT, FROM, WHERE, HAVING, and ORDER BY clauses
--  2. SubQuery is easy to understand and maintain
--  3. Join has better performance than SubQuery
--        3 Physical Joins
--          Merge Join, Hash Join, Neested Loop Join, It will select which JOIN will have best performance



-- Get the order information like which employees deal with which order but limit the employees location to London
-- JOIN
SELECT o.OrderDate, e.FirstName, e.LastName
FROM Orders o JOIN Employees e ON o.EmployeeID = e.EmployeeID
WHERE e.City = 'London'
ORDER BY o.OrderDate

-- SubQuery
SELECT o.OrderDate, (SELECT e1.FirstName FROM Employees e1 WHERE e1.EmployeeID = o.EmployeeID) as FirstName, 
(SELECT e2.LastName FROM Employees e2 WHERE e2.EmployeeID = o.EmployeeID) as LastName
FROM Orders o 
WHERE (
    SELECT e3.City
    FROM Employees e3
    WHERE e3.EmployeeID = o.EmployeeID
) IN ('London')
ORDER BY o.OrderDate, LastName, FirstName

-- Find customer who had never made order

-- JOIN
SELECT c.customerID, c.ContactName, c.City, c.Country
FROM Customers c LEFT JOIN Orders o ON c.CustomerID = o.CustomerID
WHERE o.CustomerID IS NULL

--Subquery
SELECT c.customerID, c.ContactName, c.City, c.Country
FROM Customers c
WHERE c.CustomerID NOT IN (
    SELECT DISTINCT CustomerID
    FROM Orders
)

-- Correlation SubQuery: In which inner query is dependent on the outer query
-- Customer name and total number of order by Customer
--  GroupBy is a expensive resource

-- JOIN
SELECT c.CustomerID, c.ContactName, COUNT(o.OrderID) AS NumberofOrders
FROM Customers c JOIN Orders o ON c.CustomerId = o.CustomerId
GROUP BY c.CustomerID, c.ContactName
ORDER BY NumberofOrders

-- SubQuery
SELECT c.CustomerID, c.ContactName, (SELECT COUNT(o.OrderID) FROM Orders o WHERE o.CustomerID = c.CustomerID) AS totalNumberOfOrders
FROM Customers c
ORDER BY totalNumberOfOrders DESC

-- Derived Table: Subquery in a from clause
SELECT dt.ContactName, dt.City
FROM (SELECT *
FROM Customers) dt

-- Get Customers information and the number of orders made by each customer

-- JOIN
SELECT c.CustomerID, c.ContactName, COUNT(o.OrderID) AS NumberofOrders
FROM Customers c JOIN Orders o ON c.CustomerId = o.CustomerId
GROUP BY c.CustomerID, c.ContactName
ORDER BY NumberofOrders DESC

-- Derived Table
SELECT c.CustomerID, c.ContactName, dt.totalNumberOfOrders
FROM Customers c LEFT JOIN (
    SELECT CustomerId, Count(OrderID) as totalNumberOfOrders
    FROM Orders
    GROUP BY CustomerId
) dt ON c.CustomerID = dt.CustomerID
ORDER BY totalNumberOfOrders DESC


-- UNION Vs. UNION ALL: Use to 

-- Common feature:
--  1. Both Union and UNION ALL are used to combine result sets vertically
--  2. Both follows same criteria, 
--      a. they must have same number of column to selected
--      b. Data type of each column must be identical.

-- Dfference
--  1. Union will remove all duplicate values from result set while UNION ALL will not remove
--  2. With UNION the first column of the first column will be sorted ascending order automactically while UNION ALL will not.
--  3. UNION Can not be used in recursive CTE but UNION ALL can be


SELECT City, Country
FROM Customers
UNION
SELECT City, Country
FROM Employees


SELECT City, Country
FROM Customers
UNION ALL
SELECT City, Country
FROM Employees

-- Window Function: Will operate on set of rows and return a single aggregated value for each row by adding extracolumn
-- Always use Drived Table if want to filter on Window function
-- RANK(): Function that will gives a rank based on a certain order

-- Give a rank for product price
SELECT ProductID, ProductName, UnitPrice, Rank() OVER(ORDER BY UnitPrice DESC) AS Rank
FROM Products

-- Product with the 2nd highest price
SELECT dt.ProductName, dt.Rank
FROM (
    SELECT ProductID, ProductName, UnitPrice, Rank() OVER(ORDER BY UnitPrice DESC) AS Rank
    FROM Products
) dt
WHERE dt.Rank = 2

SELECT ProductID, ProductName, UnitPrice, Rank() OVER(ORDER BY UnitPrice DESC) AS Rank
FROM Products
-- DENSE_RANK(): If you do not want to have any value cap then go with dense Rank
SELECT ProductID, ProductName, UnitPrice, Rank() OVER(ORDER BY UnitPrice DESC) AS Rank1, DENSE_RANK() OVER(ORDER BY UnitPrice DESC) AS Rank2
FROM Products 

-- ROW_NUMBER(): Give the ranking of the sorted record starting from 1
SELECT ProductID, ProductName, UnitPrice, Rank() OVER(ORDER BY UnitPrice DESC) AS Rank, ROW_NUMBER() OVER(ORDER BY UnitPrice DESC) Row
FROM Products


-- Partition By: It will divide the result set into small partitions and perform calculation on each subset. Partition by is always used in conjunction with windows function

-- List customer from every country with the ranking for number of orders.
SELECT c.ContactName, c.Country, COUNT(o.OrderID) AS TotalNumberOfOrders, RANK() OVER (PARTITION BY c.Country ORDER BY COUNT(o.OrderID) DESC) as RANK
FROM Customers c JOIN Orders o ON c.CustomerID = O.CustomerID
GROUP BY c.ContactName, c.Country

-- find top 3 customers from every country with maximun orders

SELECT dt.ContactName, dt.Country, dt.TotalNumberOfOrders, dt.Rank
FROM (
    SELECT c.ContactName, c.Country, COUNT(o.OrderID) AS TotalNumberOfOrders, RANK() OVER (PARTITION BY c.Country ORDER BY COUNT(o.OrderID) DESC) as RANK
    FROM Customers c JOIN Orders o ON c.CustomerID = O.CustomerID
    GROUP BY c.ContactName, c.Country
) dt
WHERE dt.RANK <= 3

-- CTE: Common table Expression: a temporary named result set to make your query more readable

SELECT dt.ContactName, dt.Country, dt.TotalNumberOfOrders, dt.Rank
FROM (
    SELECT c.ContactName, c.Country, COUNT(o.OrderID) AS TotalNumberOfOrders, RANK() OVER (PARTITION BY c.Country ORDER BY COUNT(o.OrderID) DESC) as RANK
    FROM Customers c JOIN Orders o ON c.CustomerID = O.CustomerID
    GROUP BY c.ContactName, c.Country
) dt

-- CTE
WITH OrderCountCTE
AS (
    SELECT c.CustomerID, c.ContactName, c.Country, COUNT(o.OrderID) AS TotalNumberOfOrders, RANK() OVER (PARTITION BY c.Country ORDER BY COUNT(o.OrderID) DESC) as RANK
    FROM Customers c JOIN Orders o ON c.CustomerID = O.CustomerID
    GROUP BY  c.CustomerID, c.ContactName, c.Country    
)
SELECT c.CustomerID, c.ContactName, c.Country, cte.TotalNumberOfOrders, cte.Rank
FROM Customers c JOIN OrderCountCTE cte ON c.CustomerID = cte.CustomerID

-- Lifecycle: Use in the very next select Statement, it is with in the a batch

-- Recursive CTE: CTE that call itself recursively
--  1. Initialization
--  2. Recursive Rule

SELECT EmployeeID, FirstName + ' ' + LastName AS Name, ReportsTo
FROM Employees 

-- Level 1 : Andrew
-- Level 2 : Nancy, Janet, Margaret, Steven, Laura
-- Level 3 : Michael, Robert, Anne

WITH EmployeeCTE
AS (
    SELECT EmployeeID, FirstName + ' ' + LastName AS Name, 1 Lvl
    FROM Employees
    Where ReportsTo IS NULL
    UNION ALL
    SELECT e.EmployeeID, FirstName + ' ' + LastName AS Name, cte.Lvl + 1
    FROM Employees e JOIN EmployeeCTE cte ON e.ReportsTo = cte.EmployeeID
)
SELECT *
FROM EmployeeCTE