--  Basic Queries: SELECT, WHERE, ORDER BY, JOIN, Aggregation, GROUP BY, HAVING
--  Advanced Topic:Subquery, CTE, Window Function, Pagination, TOP
--  TEMP table
--  Table Variable
--  Stored Procedures
--  User Defined Function



--  Check Constrains: Limit the value range that can be placed into a column
SELECT * FROM Employee

INSERT INTO Employee VALUES (5, 'Monster', 5000)
INSERT INTO Employee VALUES (6, 'Monster', -5000)

ALTER TABLE Employee
ADD CONSTRAINT check_Age_Employee CHECK (Age BETWEEN 18 AND 65)

INSERT INTO Employee VALUES (1, 'Fred', 24)

--  Identity Property: Allows Primary Key that set up the auto increment on Primary Key
CREATE TABLE Product (
    Id INT PRIMARY KEY IDENTITY(1, 1),
    ProductName VARCHAR(20) NOT NULL UNIQUE,
    UintPrice MONEY
)

SELECT * FROM Product


INSERT INTO Product VALUES ('Green Tea', 4)
INSERT INTO Product VALUES ('Latte', 5)
INSERT INTO Product VALUES ('Cold Brew', 5)

--  Truncate VS Delete - Both use for delete record from table
--      1.  Delete is DML so it will not reset the property value (Primary Key). Truncate is DDL so it will reset the property value
--      2.  Delete can be use for where clause while Truncate can not.

SELECT * FROM Product
DELETE Product
TRUNCATE TABLE Product

DELETE Product WHERE Id = 3

--  DROP - DROP is DDL statement that will delete the whole table

--   Referential Integrity : Implemented by foreign key that set up the update and delete constrain
--   Department Table and Employee Table
--  ON DELETE SET CASCADE
CREATE TABLE Department (
    Id INT PRIMARY KEY IDENTITY(1, 1),
    DepartmentName VARCHAR (20),
    Location VARCHAR(20)
)

DROP TABLE Employee

CREATE TABLE Employee (
    Id INT PRIMARY KEY IDENTITY(1, 1),
    EmployeeName VARCHAR(20),
    Age INT Check(Age BETWEEN 18 AND 65),
    --DepartmentID INT FOREIGN KEY REFERENCES Department (Id) ON DELETE SET NULL
    DepartmentID INT FOREIGN KEY REFERENCES Department (Id) ON DELETE CASCADE
)

SELECT * FROM Employee
SELECT * FROM Department

INSERT INTO Department VALUES ('IT', 'Virginia')
INSERT INTO Department VALUES ('HR', 'Virginia')
INSERT INTO Department VALUES ('QA', 'Paris')

INSERT INTO Employee VALUES ('Fred', 34, 1)
INSERT INTO Employee VALUES ('Zoe', 19, 2)
INSERT INTO Employee VALUES ('Kim', 22, 3)
INSERT INTO Employee VALUES ('John', 32, 1)

DROP TABLE Employee
DROP TABLE Department

-- DELETE FROM Department WHERE id = 1


--  Composite Primary Key: Combination of 2 or more key that makes primary key
--  Student Table
--  Class Table
--  Enrollment table - Conjunction Table / Associate Table

CREATE TABLE Student (
    Id INT PRIMARY KEY IDENTITY(1, 1),
    StudentName VARCHAR(20)
)

CREATE TABLE Class (
    Id INT PRIMARY KEY IDENTITY(1, 1),
    CourseName VARCHAR(20)
)

-- Creation of Conjunction table/ Associate Table

CREATE TABLE Enrollment (
    StudentID INT NOT NULL,
    CourseID INT NOT NULL,
    CONSTRAINT PK_Enrollment PRIMARY KEY (StudentID, CourseID),
    CONSTRAINT FK_Enrollment_STUDENT FOREIGN KEY (StudentID) REFERENCES Student(Id),
    CONSTRAINT FK_Enrollment_Class FOREIGN KEY (CourseID) REFERENCES Class(Id),    
)


--  Transaction - Group of Logically DML statements that will either will succeed together or fail together
--      3 Modes: 
--          1. Autocommit Transaction - Default take all sql statement individual as one commit
--          2. Implicit Transaction - 
--          3. Explicit Transaction - END Commit or Rollback. BEGIN Transaction

DROP TABLE Product

CREATE TABLE Product (
    Id INT PRIMARY KEY,
    ProductName VARCHAR(20) NOT NULL UNIQUE,
    UintPrice MONEY,
    Quantity INT
)

SELECT * FROM Product

INSERT INTO Product VALUES (1, 'Green Tea', 4, 100)
INSERT INTO Product VALUES (2, 'Latte', 5, 100)
INSERT INTO Product VALUES (3, 'Cold Brew', 5, 100)


--  Properties - 
--  ACID
--  1. Atomicity: Work must be atomic. Either all works done or none works done
--  2. Consistency: Whatever happens in the middle of the transaction, it will never leave our database in the half completed state.
--  3. Isolation: Locking the resource, only one transaction can occur at the time
--  4. Durability: Once Transaction is completed, the changes will be permanent


--  Isolation Level:
--  Concurrency Problem - When two or more users are trying to access the same data.
--  1. Dirty Read - Happens if transaction 1 allows transaction 2 to read the uncommitted data then transaction 1 rolls back. Happens when transaction level is read uncommitted and it solved by using read committed isolation level
--  2. Lost Update - Happen when transaction 1 and transaction 2 read and update same data but transaction 2 finishes its work earlier even thought started the transaction first Happens when transaction level is read uncommitted and it solved by using repeatable read
--  3. Non Repeatable Read  - Happens when Transaction 1 reads same data twice while transaction 2 is updating the data heppends twice. Solve by REPEATABLE READ
--  4. Phantom Read - Happens when transaction 1 reads same data twice while transaction 2 is inserting the data; happens when isolation lavel is repeatable read. Solve by updationg Isolation to Serializable

--  When to use each isolation?
--  

--  Index - On-Desk structure that increase the data retrieval speed; increase speed of select statement
--  Clustered Index - Sort the record. Primary key will automatically generate the cluster index; Only can have only one clusteres index in a table since data can be only sorted in order.
--  Non-Clustered Index - Will not sort the data; Generated by unique key constrains. One table can have multiple non-clustered index


CREATE TABLE Customer (
    Id INT,
    FullName VARCHAR(20),
    City VARCHAR(20),
    Country VARCHAR(20)
)

SELECT * FROM Customer
--  Clustered Index
CREATE CLUSTERED INDEX Clustered_Index_Customer_ID ON Customer (Id)

INSERT INTO Customer VALUES (2, 'David', 'Chicago', 'US')
INSERT INTO Customer VALUES (1, 'Fred', 'New York', 'US')

DROP TABLE Customer

--  NON Clustered Index -- Creates on those fields that are frequently use on JOIN, WHERE, or Aggregation Fields.
CREATE INDEX NonClustered_Index_Customer_City ON Customer (City)


--  Disadvantages: 
--      1. Cost extra space
--      2. Will slow down DML operation on Insert, update, and delete because index tree will be reconstructed


--  Performance Tuning
--      1. We need to see the execution plan/ SQL profiler to discover the performance of current query
--      2. Create Indexes wisely
--      3. Avoid any unnecessary joins
--      4. Avoid SELECT *, use SELECT Fields
--      5. USE Derived table to avoid grouping of non-aggregated fields.
--      6. If the query is implemented using subquery, you can check if you can use join to replace subquery

