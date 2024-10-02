USE AdventureWorks2019

--  1. How many products can you find in the Production.Product table?
--  a: There are 504 Products in the Production.Product Table
SELECT COUNT(ProductID) AS TotalProducts
FROM Production.Product

--  2. Write a query that retrieves the number of products in the Production.Product table that are included in a subcategory. The rows that have NULL in column ProductSubcategoryID are considered to not be a part of any subcategory.
--  a: There are 295 Products with a subCategory
SELECT COUNT(p.ProductID) as TotalProductsWithSubCategory
FROM Production.Product p
WHERE p.ProductSubcategoryID IS NOT NULL

--  3. How many Products reside in each SubCategory? Write a query to display the results with the following titles.
SELECT ProductSubcategoryID, COUNT(ProductID) AS CountedProducts
FROM Production.Product 
GROUP BY ProductSubcategoryID

--  4.      How many products that do not have a product subcategory.
--  a: There are 209 Products do not have a product subcategory.
SELECT COUNT(p.ProductID) as TotalProductsWithSubCategory
FROM Production.Product p
WHERE p.ProductSubcategoryID IS NULL

--  5. Write a query to list the sum of products quantity in the Production.ProductInventory table.
--  a: There are total of 335974 items in the inventory
SELECT ProductID, SUM(Quantity) as TotalInventory
FROM Production.ProductInventory
GROUP BY ProductID
ORDER BY ProductID
--  6. Write a query to list the sum of products in the Production.ProductInventory table and LocationID set to 40 and limit the result to include just summarized quantities less than 100.
SELECT ProductID, SUM(Quantity) as TheSum
FROM Production.ProductInventory
WHERE LocationID BETWEEN 40 AND 100
GROUP BY ProductID

--  7. Write a query to list the sum of products with the shelf information in the Production.ProductInventory table and LocationID set to 40 and limit the result to include just summarized quantities less than 100
SELECT Shelf, ProductID, SUM(Quantity) as TheSum
FROM Production.ProductInventory
WHERE LocationID = 40
GROUP BY Shelf, ProductID
HAVING SUM(Quantity) <= 100

--  8. Write the query to list the average quantity for products where column LocationID has the value of 10 from the table Production.ProductInventory table.
--  a. The average quantity is 295
SELECT AVG(Quantity) as "Average Quantity for Each Product in Location 10"
FROM Production.ProductInventory
WHERE LocationID = 10

--  9. Write query  to see the average quantity  of  products by shelf  from the table Production.ProductInventory
SELECT ProductID, Shelf, AVG(Quantity) as TheAvg
FROM Production.ProductInventory
GROUP BY ProductID, Shelf

--  10. Write query  to see the average quantity  of  products by shelf excluding rows that has the value of N/A in the column Shelf from the table Production.ProductInventory
SELECT ProductID, Shelf, AVG(Quantity) as TheAvg
FROM Production.ProductInventory
WHERE Shelf != 'N/A'
GROUP BY ProductID, Shelf

--  11. List the members (rows) and average list price in the Production.Product table. This should be grouped independently over the Color and the Class column. Exclude the rows where Color or Class are null.

SELECT p.Color, p.Class, COUNT(p.Color) AS TheCount, AVG(p.ListPrice) AS AvgPrice
FROM Production.Product p
WHERE p.Color IS NOT NULL OR p.Class IS NOT NULL
GROUP BY p.Color, p.Class

--  12. Write a query that lists the country and province names from person. CountryRegion and person. StateProvince tables. Join them and produce a result set similar to the following
SELECT cr.Name AS Country, sp.Name AS Province
FROM Person.CountryRegion cr JOIN Person.StateProvince sp ON cr.CountryRegionCode = sp.CountryRegionCode
ORDER BY cr.Name

--  13. Write a query that lists the country and province names from person. CountryRegion and person. StateProvince tables and list the countries filter them by Germany and Canada. Join them and produce a result set similar to the following.
SELECT cr.Name AS Country, sp.Name AS Province
FROM Person.CountryRegion cr JOIN Person.StateProvince sp ON cr.CountryRegionCode = sp.CountryRegionCode
WHERE cr.Name IN ('Germany', 'Canada')
ORDER BY cr.Name

--   Using Northwnd Database: (Use aliases for all the Joins)
USE Northwind

--  14. List all Products that has been sold at least once in last 27 years.
--  Showing the unique product with their most recent order date in past 27 years
SELECT od.ProductID, p.ProductName, MAX(o.OrderDate) AS OrderDate
FROM Orders o JOIN [Order Details] od ON o.OrderID = od.OrderID
                JOIN Products p ON od.ProductID = p.ProductID
WHERE o.OrderDate >= DATEADD(YEAR, -27, GETDATE())
GROUP BY od.ProductID, p.ProductName
ORDER BY od.ProductID

--  15.  List top 5 locations (Zip Code) where the products sold most.
SELECT TOP 5 p.ProductID, p.ProductName, c.Country, c.PostalCode, COUNT(p.ProductID) AS CountOfSales
FROM Orders o JOIN Customers c ON o.CustomerID = c.CustomerID
    JOIN [Order Details] od ON o.OrderID = od.OrderID
    JOIN Products p ON od.ProductID = p.ProductID
GROUP BY p.ProductID, p.ProductName, c.Country, c.PostalCode
ORDER BY COUNT(p.ProductID) DESC

--  16. List top 5 locations (Zip Code) where the products sold most in last 27 years.
SELECT TOP 5 p.ProductID, p.ProductName, c.Country, c.PostalCode, COUNT(p.ProductID) AS CountOfSales
FROM Orders o JOIN Customers c ON o.CustomerID = c.CustomerID
    JOIN [Order Details] od ON o.OrderID = od.OrderID
    JOIN Products p ON od.ProductID = p.ProductID
WHERE o.OrderDate >= DATEADD(YEAR, -27, GETDATE())
GROUP BY p.ProductID, p.ProductName, c.Country, c.PostalCode
ORDER BY COUNT(p.ProductID) DESC

--  17. List all city names and number of customers in that city.     
SELECT c.Country, c.City, COUNT(c.CustomerID) AS CustomerCount
FROM Customers c JOIN (
    SELECT DISTINCT c1.City
    FROM Customers c1
) dt ON c.City = dt.city
GROUP BY c.Country, c.City
ORDER BY c.Country

-- OR 

SELECT c.Country, c.City, COUNT(c.CustomerID) AS CustomerCount
FROM Customers c
WHERE c.City IN (
    SELECT DISTINCT c1.City
    FROM Customers c1
)
GROUP BY c.Country, c.City
ORDER BY c.Country

--  18. List city names which have more than 2 customers, and number of customers in that city
SELECT c.Country, c.City, COUNT(c.CustomerID) AS CustomerCount
FROM Customers c JOIN (
    SELECT DISTINCT c1.City
    FROM Customers c1
) dt ON c.City = dt.city
GROUP BY c.Country, c.City
HAVING COUNT(c.CustomerID) >= 2
ORDER BY c.Country

-- OR

SELECT c.Country, c.City, COUNT(c.CustomerID) AS CustomerCount
FROM Customers c
WHERE c.City IN (
    SELECT DISTINCT c1.City
    FROM Customers c1
)
GROUP BY c.Country, c.City
HAVING COUNT(c.CustomerID) >= 2
ORDER BY c.Country

--  19. List the names of customers who placed orders after 1/1/98 with order date.
SELECT c.ContactName, MIN(o.OrderDate) as "Earlyst Order After 1/1/98"
FROM Customers c JOIN Orders o ON c.CustomerID = o.CustomerID
WHERE o.OrderDate >= '1998-01-01'
GROUP BY c.ContactName
ORDER BY c.ContactName

--  20. List the names of all customers with most recent order dates
SELECT c.ContactName, MAX(o.OrderDate) as "Most Recent Order Date"
FROM Customers c JOIN Orders o ON c.CustomerID = o.CustomerID
GROUP BY c.ContactName
ORDER BY c.ContactName

--  21. Display the names of all customers  along with the  count of products they bought
SELECT c.ContactName, COUNT(od.ProductID) AS "Total Number of Product Bought"
FROM Customers c JOIN Orders o ON c.CustomerID = o.CustomerID
    JOIN [Order Details] od ON o.OrderID = od.OrderID
GROUP BY c.ContactName
ORDER BY COUNT(od.ProductID) DESC

--  OR

-- To remove we need additional subquery which reduces performances
SELECT c.ContactName,
(
    SELECT COUNT(od.OrderID) AS Count 
    FROM Orders o JOIN [Order Details] od ON o.OrderID = od.OrderID
    WHERE o.CustomerID = c.CustomerID
    HAVING COUNT(od.OrderID) != 0
) AS CountOfProduct
FROM Customers c 
ORDER BY CountOfProduct DESC

--  22. Display the customer ids who bought more than 100 Products with count of products.

SELECT c.ContactName, COUNT(od.ProductID) AS "Total Number of Product Bought"
FROM Customers c JOIN Orders o ON c.CustomerID = o.CustomerID
    JOIN [Order Details] od ON o.OrderID = od.OrderID
GROUP BY c.ContactName
HAVING COUNT(od.ProductID) >= 100
ORDER BY COUNT(od.ProductID) DESC

--  OR 

SELECT c.ContactName,
(
    SELECT COUNT(od.OrderID) AS Count 
    FROM Orders o JOIN [Order Details] od ON o.OrderID = od.OrderID
    WHERE o.CustomerID = c.CustomerID
    HAVING COUNT(od.OrderID) >= 100
) AS CountOfProduct
FROM Customers c 
ORDER BY CountOfProduct DESC

--  23. List all of the possible ways that suppliers can ship their products. Display the results as below
--  USE Drived Table and temp column that allows us to group supplier id together
WITH OrderInfoCTE
AS (
    SELECT p.SupplierID, shi.CompanyName, COUNT(p.ProductID) AS TEMP
    FROM Orders o JOIN [Order Details] od ON o.OrderID = od.OrderID
        JOIN Products p ON od.ProductID = p.ProductID
        JOIN Shippers shi ON o.ShipVia = shi.ShipperID
    GROUP BY p.SupplierID, shi.CompanyName
)
SELECT sup.CompanyName AS "Supplier Company Name", cte.CompanyName AS "Shipper Company Name"
FROM Suppliers sup JOIN OrderInfoCTE cte on sup.SupplierID = cte.SupplierID
ORDER BY sup.CompanyName, cte.CompanyName;

--  24. Display the products order each day. Show Order date and Product Name.
SELECT p.ProductName, o.OrderDate, COUNT(od.productID) AS "Count of Products"
FROM Products p JOIN [Order Details] od ON p.ProductID = od.ProductID
    JOIN Orders o ON od.OrderID = o.OrderID
GROUP BY p.ProductName, o.OrderDate

--  25. Displays pairs of employees who have the same job title.
SELECT e1.EmployeeID AS EmployeeID1, e1.FirstName + ' ' + e1.LastName AS Name1,
       e2.EmployeeID AS EmployeeID2, e2.FirstName + ' ' + e2.LastName AS Name2,
       e1.Title
FROM Employees e1
    JOIN Employees e2 ON e1.Title = e2.Title AND e1.EmployeeID < e2.EmployeeID
ORDER BY e1.Title, e1.EmployeeID, e2.EmployeeID;

--  26. Display all the Managers who have more than 2 employees reporting to them.
SELECT e2.FirstName + ' ' + e2.LastName AS ManagerName, COUNT(e1.EmployeeID) AS NumberOfReports
FROM Employees e1 JOIN Employees e2 ON e1.ReportsTo = e2.EmployeeID
GROUP BY e2.FirstName, e2.LastName
HAVING COUNT(e1.ReportsTo) >= 2

--  27. Display the customers and suppliers by city. The results should have the following columns
SELECT City, CompanyName AS Name, ContactName, Type = 'Customer'
FROM Customers
UNION
SELECT City, CompanyName AS Name, ContactName, Type = 'Supplier'
FROM Suppliers