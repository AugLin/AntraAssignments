USE Northwind
GO

--  1. List all cities that have both Employees and Customers.
SELECT DISTINCT e.City
FROM Employees e
    JOIN Customers c ON e.City = c.City

--  2. List all cities that have Customers but no Employee.
--      a. Use sub-query
SELECT DISTINCT City
FROM Customers
WHERE City NOT IN (
    SELECT DISTINCT City
    FROM Employees
)

--      b. Do not use sub-query
SELECT DISTINCT c.City
FROM Customers c LEFT JOIN Employees e ON c.City = e.City
WHERE e.city IS NULL

--  3. List all products and their total order quantities throughout all orders.
SELECT od.ProductID, p.ProductName, SUM(od.Quantity) AS TotalQuantityOrdered
FROM [Order Details] od JOIN Products p ON od.ProductID = p.ProductID
GROUP BY od.ProductID, p.ProductName
ORDER BY od.ProductID

--  4. List all Customer Cities and total products ordered by that city.
SELECT c.City, SUM(od.Quantity) AS TotalProductsOrdered
FROM Customers c
    JOIN Orders o ON c.CustomerID = o.CustomerID
    JOIN [Order Details] od ON o.OrderID = od.OrderID
GROUP BY c.City

--  5. List all Customer Cities that have at least two customers.
--  Ans 1 - USING CTE
WITH CityCustomerCountCTE
AS (
    SELECT City, COUNT(CustomerID) AS CustomerCount
    FROM Customers
    GROUP BY City
)
SELECT City, CustomerCount
FROM CityCustomerCountCTE
WHERE CustomerCount >= 2

--  Ans 2 - Using regular query
SELECT City, COUNT(CustomerID) AS NumberOfCustomers
FROM Customers
GROUP BY City
HAVING COUNT(CustomerID) >= 2

--  6. List all Customer Cities that have ordered at least two different kinds of products.
SELECT c.City, COUNT(DISTINCT od.ProductID) AS CountOfProducts
FROM Customers c JOIN Orders o ON c.CustomerID = o.CustomerID
                    JOIN [Order Details] od ON o.OrderID = od.OrderID
GROUP BY c.City
HAVING COUNT(od.ProductID) >= 2
ORDER BY CountOfProducts DESC

--  OR USING CTE (Faster)
WITH CityProductCountsCTE
AS (
    SELECT c.City, COUNT(DISTINCT od.ProductID) AS CountOfProducts
    FROM Customers c
    JOIN Orders o ON c.CustomerID = o.CustomerID
    JOIN [Order Details] od ON o.OrderID = od.OrderID
    GROUP BY c.City
)
SELECT City, CountOfProducts
FROM CityProductCountsCTE
WHERE CountOfProducts >= 2
ORDER BY CountOfProducts DESC

--  7. List all Customers who have ordered products, but have the ‘ship city’ on the order different from their own customer cities.
SELECT c.CompanyName, c.ContactName, c.City, o.ShipCity
FROM Customers c LEFT JOIN Orders o ON c.CustomerID = o.CustomerID
WHERE c.City != o.ShipCity;

--  USING CTE
WITH OrderCTE
AS (
    SELECT CustomerID, ShipCity
    FROM Orders
)
SELECT c.CompanyName, c.ContactName, c.City, cte.ShipCity
FROM Customers c JOIN OrderCTE cte on c.CustomerID = cte.CustomerID
WHERE c.City != cte.ShipCity

--  8. List 5 most popular products, their average price, and the customer city that ordered most quantity of it.
WITH PopularProductCTE
AS (
    SELECT TOP 5 p.ProductID, p.ProductName, SUM(od.Quantity) AS TotalOrdered, p.UnitPrice AS AveragePrice
    FROM [Order Details] od JOIN Products p ON od.ProductID = p.ProductID
    GROUP BY p.ProductID, p.ProductName, p.UnitPrice
    ORDER BY TotalOrdered DESC
),
CustomerProductQuantityCTE
AS (
    SELECT od.ProductID, c.City, SUM(od.Quantity) AS MaxCustomerOrdered
    FROM Customers c
    JOIN Orders o ON c.CustomerID = o.CustomerID
    JOIN [Order Details] od ON o.OrderID = od.OrderID
    GROUP BY od.ProductID, c.City
)
SELECT cte1.ProductID, cte1.ProductName, cte1.TotalOrdered, cte1.AveragePrice, cte2.City, cte2.MaxCustomerOrdered
FROM PopularProductCTE cte1
JOIN CustomerProductQuantityCTE cte2 ON cte1.ProductID = cte2.ProductID
WHERE cte2.MaxCustomerOrdered = (
    SELECT MAX(MaxCustomerOrdered)
    FROM CustomerProductQuantityCTE cte3
    WHERE cte3.ProductID = cte2.ProductID
)
ORDER BY TotalOrdered DESC

--  9. List all cities that have never ordered something but we have employees there.
--  SubQuery
SELECT DISTINCT e.City
FROM Employees e
WHERE e.City NOT IN (
    SELECT DISTINCT c.City
    FROM Customers c
    JOIN Orders o ON c.CustomerID = o.CustomerID
)

-- Without Subquery
SELECT DISTINCT e.City
FROM Employees e
LEFT JOIN (
    SELECT DISTINCT c.City
    FROM Customers c
    JOIN Orders o ON c.CustomerID = o.CustomerID
) co ON e.City = co.City
WHERE co.City IS NULL


--  10.  List one city, if exists, that is the city from where the employee sold most orders (not the product quantity) is, and also the city of most total quantity of products ordered from. (tip: join  sub-query)
--  USING CTE
WITH CustomerCTE
AS (
    SELECT TOP 1 c.City, COUNT(o.OrderID) AS TotalOrdered
    FROM Customers c JOIN Orders o ON c.CustomerID = o.CustomerID
    GROUP BY c.City
    ORDER BY TotalOrdered DESC
),
    EmployeeCTE
AS (
    SELECT TOP 1 e.City, COUNT(o.OrderID) AS TotalOrdersSold
    FROM Employees e JOIN ORders o ON e.EmployeeID = o.EmployeeID
    GROUP BY e.City
    ORDER BY TotalOrdersSold DESC
)
SELECT cte2.City AS EmployeeCity, cte1.City AS CustomerCity, cte1.TotalOrdered, cte2.TotalOrdersSold
FROM CustomerCTE cte1 JOIN EmployeeCTE cte2 ON cte1.City = cte2.City

--  11. How do you remove the duplicates record of a table?
--  I am a bit unsure what this question ask, but because we should never have duplicate in a RDBMS. Incase there are duplicate
--  we may display them by using Window Function with RANK(), DENSE_RANK(), or ROW_NUMBER() that display if there are duplicate