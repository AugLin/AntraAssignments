-- Day 2
-- Aggregation Function + Group by
-- Derived tables
-- Union vs. Union ALL
-- Window function
-- CTE



-- Temp Table - Store the table/data temporarily

--  Local - #
--      Life Scope is within the connection that created it.
--      It is stored in the tembdb database
--      Stores in memory
CREATE TABLE #LocalTemp(
    Num INT
)
DECLARE @variable INT = 1
WHILE (@variable <= 10)
BEGIN 
INSERT INTO #LocalTemp(Num) VALUES (@variable)
SET @variable = @variable + 1
END

SELECT * FROM #LocalTemp

SELECT * FROM tempdb.sys.tables

--  Global - ## 
--      Life scope can be access by any different sessions, also stored in tempdb database, whenever the connection and execution end the table will be dropped

CREATE TABLE ##GlobalTemp(
    Num INT
)
DECLARE @variable2 INT = 1
WHILE (@variable2 <= 10)
BEGIN 
INSERT INTO ##GlobalTemp(Num) VALUES (@variable2)
SET @variable2 = @variable2 + 1
END

SELECT * FROM ##GlobalTemp

SELECT * FROM tempdb.sys.tables

-- Table variable - A variable of table type
--      lifescope: sumbit and use with in a single batch like regular variable
DECLARE @today DATETIME
SELECT @today = GETDATE()
PRINT @today

DECLARE  @WeekDays TABLE (
    DayNum INT,
    DayAbb VARCHAR(20),
    WeekName VARCHAR(20)
)

INSERT INTO @Weekdays VALUES 
    (1, 'Mon', 'Monday'),
    (2, 'Tue', 'Tuesday'),
    (3, 'Wed', 'Wednesday'),
    (4, 'Thur', 'Thursday'),
    (5, 'Fri', 'Friday')
SELECT * FROM tempdb.sys.tables


SELECT * FROM @Weekdays
-- Temp tables vs. table variables
--  1. Both are stored in tempdb database
--  2. Scope: local/global temp table; table variable is within current batch
--  3. They have different sizes
--      a. Size > 100 go temp tables, size < 100 go with table variables
--  4. We can not use temp table in stored procesure or user defined function but we can use table variables in Stored Procedure and User Defined Function.


-- Views: Virtual table that contains data from one or more tables
USE SeptBatch
GO

CREATE DATABASE SeptBatch
CREATE TABLE Employee (Id INT, EName VARCHAR(20), SALARY DECIMAL(10, 2))

SELECT *
FROM Employee

INSERT INTO Employee VALUES
(1, 'Fred', 5000),
(2, 'Laura', 7000),
(3, 'Amy', 6000)

CREATE VIEW vwEmp
AS
SELECT Id, EName, Salary
FROM Employee

SELECT * 
FROM vwEmp


-- Stored Procedure - Preprepared SQL query that we can save in our database and reuse it whenever we want to.

BEGIN
    PRINT 'Hello Anoymous Block'
END

CREATE PROCEDURE spHello
AS 
BEGIN
    PRINT 'Hello Anoymous Block'
END

EXEC spHello

-- Advantages of sp (Stored Procedure)
--  1. It will allow you to reuse the same logic.
--  2. It can be used to prevent SQL injection because it can take parameters

-- SQL injection - if Hakers injects malicious code into our SQL queries thus, destorying our database.

SELECT Id, Name
FROM User
WHERE Id = 1
UNION ALL
SELECT Id, Password 
From USER

-- OR 

SELECT Id, Name
FROM User
WHERE Id = 1 OR 1 = 1

-- OR 

SELECT Id, Name
FROM User
WHERE Id = 1 DROP TABLE User

-- Input: Default type 
CREATE PROCEDURE spAddNumbers
@num1 INT, 
@num2 INT
AS
BEGIN
    PRINT @num1 + @num2
END

EXEC spAddNumbers 1, 2

-- Output
CREATE PROCEDURE spGetName
@Id INT,
@EName VARCHAR(20) OUT
AS
BEGIN
    SELECT @EName = EName
    FROM Employee
    WHERE Id = @Id
END


BEGIN 
    DECLARE @En VARCHAR(20)
    EXECUTE spGetName 2, @En OUT
    PRINT @En
END

EXECUTE spGetName 2

-- Stored Procedure also return tables

CREATE PROCEDURE spGetAllEmployee
AS
BEGIN
    SELECT * 
    FROM Employee
END

EXECUTE spGetAllEmployee

--  Trigger - Special type of stored procedure that will auto run when there is an event occurs
--  DML Trigger - Runs when we DML Operation this will be trigger
--  DDL Trigger - Runs when we DDL Operation this will be trigger
--  LogOn Trigger - Runs after authentification


-- Lifescope sp and views: Will be stored in Database forever as long as you do not drop them

--  Functions

--  Built-In


-- User Defined Function - We created for calculation

CREATE FUNCTION GetTotalRevenue (@price MONEY, @discount REAL, @quantity INT)
RETURNS MONEY
AS
BEGIN
    DECLARE @revenue MONEY
    SET @revenue = @price * (1 - @discount) * @quantity
    RETURN @revenue
END

SELECT UnitPrice, Quantity, Discount, dbo.GetTotalRevenue(UnitPrice, Discount, Quantity) AS Revenue
FROM [Order Details]
ORDER BY Revenue DESC

--  Benefits of USING user defined functions
--  Avoid duplicate and saves time

CREATE FUNCTION ExpensiveProduct(@thresHold money)
RETURNS TABLE
AS 
RETURN SELECT *
        FROM Products
        WHERE UnitPrice > @thresHold


SELECT *
FROM dbo.ExpensiveProduct(10)

--  SP VS UDF
--  1.  Usage. SP for DML related operation, UDF used for Calculation
--  2.  How to invoke them. SP will be called by its name after EXECUTE keyword but UDF must be called in SQL Statement
--  3.  Input/Output: SP may or maynot have input or output parameters but UDF may or maynot have input parameters but it must have output parameter.
--  4.  SP can be used to call UDF but UDF can not call SP

--  Pagination - The process we use to divide large table to small discrete pages

--  OFFSET: SKIP - Use to SKIP first X rows
--  FETCH NEXT x ROWS: SELECT
SELECT CustomerId, ContactName, City
FROM Customers 
ORDER BY CustomerId
OFFSET 10 ROWS

SELECT CustomerId, ContactName, City
FROM Customers 
ORDER BY CustomerId
OFFSET 0 ROWS

SELECT CustomerId, ContactName, City
FROM Customers 
ORDER BY CustomerId
OFFSET 10 ROWS
FETCH NEXT 10 ROWS ONLY

--  TOP, VS OFFSET, FETCH NEXT
--  TOP - USE to Fecth top several records use it or with out ORDER BY
--  offset and fetch: only use it with ORDER BY Clause

DECLARE @PageNum INT
DECLARE @RowOfPage INT
SET @PageNum = 3
SET @RowOfPage = 10
PRINT @RowOfPage

SELECT CustomerId, ContactName, City
FROM Customers 
ORDER BY CustomerId
OFFSET (@PageNum - 1) * @RowOfPage ROWS
FETCH NEXT @RowOfPage ROWS ONLY

DECLARE @PageNum INT
DECLARE @RowOfPage INT
DECLARE @MaxTablePage FLOAT
SET @PageNum = 1
SET @RowOfPage = 10
SELECT @MaxTablePage = COUNT(*) FROM Customers
SET @MaxTablePage = CEILING(@MaxTablePage/@RowOfPage)

WHILE @PageNum <= @MaxTablePage
BEGIN
    SELECT CustomerId, ContactName, City
    FROM Customers 
    ORDER BY CustomerId
    OFFSET (@PageNum - 1) * @RowOfPage ROWS
    FETCH NEXT @RowOfPage ROWS ONLY
    SET @PageNum = @PageNum + 1
END

--  Normalization: The process in datase design that seperate large table to multiple small tables that reduced redundancy and Imrpove data integrity. Also restricted by the Constrains
--  Normal Form
--      First Normal Form   - Atomic Value - One Cell One value
--      Second Normal Form  - First Normal Form + No Partial Dependency     (Use Primary Key, Use Associative Entity)
--      Third Normal Form   - Second Normal Form + No Transitive Dependency (Aggregate Column)
--  One to many relationship 
--  Many to Many Relationship - Use associative entity/table


--  Constrains
USE SeptBatch
GO
DROP TABLE Employee

CREATE TABLE Employee (
    ID INT PRIMARY KEY,
    EName VARCHAR(20) NOT NULL,
    AGE INT
)

INSERT INTO Employee Values 
(1, 'Sam', 45)

INSERT INTO Employee Values 
(NULL, 'AEX', 23)

SELECT * FROM Employee

-- Primary Key vs Unique Key Constraints
--  1.  Unique accept only one Null value while Primary key does not accept any NULL value
--  2.  One table can only have one Primary Key Constraint, but they can have multiple UNIQUE KEY constrains.
--  3.  Primary Key will sort the data by default but unique key will not.
--  4.  Primary key will create clustered index buy default and unique key will create non clustered Index.

DELETE Employee

INSERT INTO Employee Values 
(4, 'Sam', 45)
INSERT INTO Employee Values 
(2, 'Fiona', 45)
INSERT INTO Employee Values 
(3, 'Fred', 45)
INSERT INTO Employee Values 
(1, 'Stella', 45)