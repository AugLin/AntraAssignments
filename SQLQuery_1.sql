
-- SELECT ALL COLUMNS
SELECT *
FROM Customers

-- SELECT a list of columns
SELECT CustomerID, CompanyName, ContactName
FROM Customers

-- Use alias
SELECT c.CustomerID, c.CompanyName, c.ContactName
FROM Customers c

-- Avoid using SELECT *
-- 1. Unnecessary data from the table

-- SELECT DISTINCT Value : Remove all the duplicate values from the result set
SELECT DISTINCT City
FROM Employees

-- Select that combine with plain text: Retrieve the full name of employee
SELECT FirstName, LastName, FirstName + ' ' + LastName AS FullName, FirstName + ' ' + LastName AS "Full Name"
FROM Employees

-- Identifier: Simply the names given to the database, tables, views, sp, etc.

-- 1. Regular Identifiers 
    -- a. First character: Lowercase a-z, uppercase A-Z, @, #
        -- Starts with @ use to define or declare a variable
            DECLARE @today DATETIME
            SELECT @today = GETDATE()
            PRINT @today

        -- Start with # means trying to create temp table
            -- #: local temp table
            -- ##: global temp table
        
    -- b. Subsequent character: a-z, A-Z, 0-9, @, #, $
        -- Speacial Characters does not means anything
    -- c. Must to be a sql server word
        -- ALL SQL Clauses can not be use as identifer
    -- d. Embedded space is not allowed

-- 2. Delimited Identifers: [], or ""

-- WHERE Statement: Filter the records row by row

-- Customers who are from Germany
SELECT  c.ContactName, c.Country, c.City
FROM Customers c
WHERE c.Country = 'Germany'

-- Product with price is $18
SELECT p.ProductID, p.UnitPrice
FROM Products p
WHERE UnitPrice = 18

-- SELECT customers not from UK !=, <>
SELECT  c.ContactName, c.Country, c.City
FROM Customers c
WHERE c.Country != 'UK'

SELECT  c.ContactName, c.Country, c.City
FROM Customers c
WHERE c.Country <> 'UK'

-- IN Operator
-- Orders that ship to USA and CANADA
SELECT o.OrderID, o.ShipCity, o.ShipCountry
FROM Orders o
WHERE o.ShipCountry IN ('USA', 'CANADA')

SELECT o.OrderID, o.ShipCity, o.ShipCountry
FROM Orders o
WHERE o.ShipCountry = 'USA' OR o.ShipCountry = 'Canada'

-- BETWEEN Operator
SELECT p.ProductName, p.UnitPrice
FROM Products p
WHERE UnitPrice >= 20 AND UnitPrice <= 30

SELECT p.ProductName, p.UnitPrice
FROM Products p
WHERE UnitPrice BETWEEN 20 AND 30

-- NOT Operator
-- List order that does not ship to USA or Canada

SELECT o.OrderID, o.ShipCity, o.ShipCountry
FROM Orders o
WHERE o.ShipCountry != 'USA' OR o.ShipCountry != 'Canada'

SELECT o.OrderID, o.ShipCity, o.ShipCountry
FROM Orders o
WHERE o.ShipCountry NOT IN ('USA', 'CANADA')

SELECT p.ProductName, p.UnitPrice
FROM Products p
WHERE UnitPrice NOT BETWEEN 20 AND 30

-- NULL Values:
-- Check which employees' region is empty

SELECT e.FirstName, e.LastName, e.Region 
FROM Employees e
WHERE e.Region is NULL

SELECT e.FirstName, e.LastName, e.Region 
FROM Employees e
WHERE e.Region is NOT NULL

-- NULL in numerical operation
-- Number with NULL it will change to NULL
-- Use ISNULL(Column, Value) - It will replace the value if record is null.

-- Like Operator - Use to create search expression
-- Work with %
-- Retrieve all the employees whose last name starts with D
SELECT e.FirstName, e.LastName
FROM Employees e
WHERE e.LastName LIKE 'D%'

-- Work with [] and % to search in ranges
-- Find customer with postal code between with number 0 and 3
SELECT c.ContactName, c.PostalCode
FROM Customers c
WHERE c.PostalCode LIKE '[0-3]%'

-- Work with NOT
SELECT c.ContactName, c.PostalCode
FROM Customers c
WHERE c.PostalCode NOT LIKE '[0-3]%'

-- Work with ^ works like not operator
SELECT c.ContactName, c.PostalCode
FROM Customers c
WHERE c.PostalCode LIKE '[^0-3]%'

-- Customer Name starting from letter A bot not followed by l-n
SELECT c.ContactName, c.PostalCode
FROM Customers c
WHERE c.ContactName LIKE 'A[^l-n]%'

-- ORDER BY Statement - Order the result in Ascending or Descending Order
-- Retrieve all customers expect those in Boston and sort by name

SELECT c.ContactName, c.City
FROM Customers c
WHERE c.City != 'Boston'
ORDER BY c.ContactName ASC

-- Retrieve product name and unit price, sand sort by unit price in descending order
SELECT p.ProductName, p.UnitPrice
FROM Products p
ORDER BY p.UnitPrice DESC

-- Order by multiple columns
SELECT p.ProductName, p.UnitPrice
FROM Products p
ORDER BY p.UnitPrice DESC, p.ProductName ASC

SELECT p.ProductName, p.UnitPrice
FROM Products p
ORDER BY 2 DESC, 1 ASC
-- Number means column position


-- JOIN: Use to combine or merge multiple tables together
-- Inner Join: return the records that have matching values in both tables in related columns
-- Find employuuees who have deal with any orders
SELECT e.FirstName + ' ' + e.LastName as "Full Name", o.OrderDate
FROM Employees e INNER JOIN Orders o ON e.EmployeeId = o.EmployeeId

-- Get customers information and corresponding order date
SELECT c.ContactName, c.City, c.Address, o.OrderDate
FROM Customers c INNER JOIN Orders o ON c.CustomerID = o.CustomerID

-- Join multiple tables
-- Get customer name, the corresponding employee who is responsible for this order, and the order date

SELECT c.ContactName, e.FirstName + ' ' + e.LastName AS "Employee Name", o.OrderDate
FROM Customers c INNER JOIN Orders o ON c.CustomerID = o.CustomerID
                INNER JOIN  Employees e On o.EmployeeId = e.EmployeeId

-- Add detailed information about order quantity and prive, join order detail

SELECT c.ContactName, e.FirstName + ' ' + e.LastName AS "Employee Name", o.OrderDate, od.UnitPrice
FROM Customers c INNER JOIN Orders o ON c.CustomerID = o.CustomerID
                INNER JOIN  Employees e On o.EmployeeId = e.EmployeeId
                INNER JOIN [Order Details] od ON od.OrderId = O.OrderID

-- Outer Join:
-- Left Outer Join: Return all records from the left table and matching records from the right table, if there are no matching records, that row it will return null;
-- List all customers whather they have made purchase or not
SELECT c.ContactName, c.CompanyName, c.City, o.OrderDate
FROM Customers c LEFT JOIN Orders o ON c.CustomerID = o.CustomerID

-- Never placed order
SELECT c.ContactName, c.CompanyName, c.City, o.OrderDate
FROM Customers c LEFT JOIN Orders o ON c.CustomerID = o.CustomerID
WHERE o.OrderDate IS NULL


-- Right Outer Join: Return all records from the right table and matching records from the left table, if there are no matching records, that row it will return null;
-- List all customers whather they have made purchase or not

SELECT c.ContactName, c.CompanyName, c.City, o.OrderDate
FROM Orders o RIGHT JOIN Customers c ON c.CustomerID = o.CustomerID

-- When to use left or right join?
-- Most of the time we will use Left Join, because it is rule of thumb and it is easier.

-- Full Outer Join: Return all the rows from both left and right table even if no matching value is found.
-- Match all customer and suppliers by country
SELECT c.ContactName as customer, c.Country as CuustomerCountry, s.country AS SupplierCountry, s.ContactName AS SupplierName
FROM Customers c FULL JOIN Suppliers s ON c.Country = s.Country

-- Cross Join : cartesian product of two tables
-- We will rarely use Cross join because it reduces performance.

SELECT * FROM Customers
SELECT * FROM Orders

SELECT *
FROM Customers c CROSS JOIN Orders

-- Self Join: Joins a table with itself, self Join uses Inner Join
-- Find employees with their manager name
SELECT EmployeeId, FirstName, LastName, ReportsTo
FROM Employees 

SELECT e.FirstName + ' ' + e.LastName AS Employee, m.FirstName + ' ' + m.LastName AS Manager
FROM Employees e INNER JOIN Employees m ON e.ReportsTo = m.EmployeeId

SELECT e.FirstName + ' ' + e.LastName AS Employee, m.FirstName + ' ' + m.LastName AS Manager
FROM Employees e LEFT JOIN Employees m ON e.ReportsTo = m.EmployeeId

-- Batch Directives

USE Northwind -- Start of batch
GO -- Batch seperator


-- DDL must be in different batch