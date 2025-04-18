/* # Lesson 3: Importing and Exporting Data

Here are 30 homework tasks for Lesson 3, categorized into easy, medium, and hard levels. These tasks cover:

✅ Importing Data (BULK INSERT, Excel, Text)
✅ Exporting Data (Excel, Text)
✅ Comments, Identity column, NULL/NOT NULL values
✅ Unique Key, Primary Key, Foreign Key, Check Constraint
✅ Differences between UNIQUE KEY and PRIMARY KEY

Notes before doing the tasks: Tasks should be solved using SQL Server. It does not matter the solutions are uppercase
or lowercase, which means case insensitive. Using alies names does not matter in scoring your work. Students are scored 
based on what their query returns(does it fulfill the requirments). One way of solution is enough if it is true, other 
ways might be suggested but should not affect the score.
______________________________________ */ 

-- ## 🟢 Easy-Level Tasks (10)
-- 1. Define and explain the purpose of BULK INSERT in SQL Server.

/* BULK INSERT is a SQL command that used to import large volumes of data from a file like CSV, TXT, or Excel directly into a 
database table quickly and efficiently. It is much faster than row-by-row inserts (INSERT INTO) because it minimizes 
logging and transaction overhead. Also processes multiple rows in a single operation and typically uses minimal transaction
logging. */

-- 2. List four file formats that can be imported into SQL Server.

/* Basically the file formats are vary in bulk insert operations it depends on the database system but here are the 
commonly used formats: CSV(Comma seperated values), TSV(Tab sepatated values), Fixed-Width text files, and Native binary
format (database-specific) */

-- 3. Create a table Products with columns: ProductID (INT, PRIMARY KEY), ProductName (VARCHAR(50)), Price (DECIMAL(10,2)).

create table Products (
ProductID int primary key,
ProductName varchar(50),
Price decimal(10,2) )

-- 4. Insert three records into the Products table using INSERT INTO.

insert into Products values (1, 'Laptop', 900.00), (2, 'Desktop', 700.00), (3, 'Book', 50.99) 
                            
-- 5. Explain the difference between NULL and NOT NULL with examples.  

/* In SQL NULL and NOT NULL are constraints that define whether a column can contain missing or unknown values.
Null can have a column with nothing or unknown values means no value or zero, blank and used when data is 
optional. For example: */
CREATE TABLE Employees (
    EmployeeID INT PRIMARY KEY,
    Name VARCHAR(50) NOT NULL,
    Salary DECIMAL(10,2) NULL,  -- NULL allowed (default)
    Department VARCHAR(50) )
	
INSERT INTO Employees VALUES 
(1, 'John Doe', 50000, 'IT'),
(2, 'Jane Smith', NULL, 'HR'),  -- Salary is unknown
(3, 'Mike Johnson', 75000, NULL)  -- Department not assigned

/* NOT NULL is a fundamental constraint in SQL that ensures a column can't contain NULL values. It's crucial for data 
integrity in database design. NOT NULL forces a column to always have a value, prevents insertion of rows where the column 
is empty and helps maintain data consistency. For example: */
CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY,
    FirstName VARCHAR(50) NOT NULL, -- Must always have a value
    LastName VARCHAR(50) NOT NULL,
    Email VARCHAR(100) NOT NULL,
    Phone VARCHAR(20) NULL) -- NULL values allowed (optional)

-- All required fields provided
INSERT INTO Customers VALUES 
(1, 'John', 'Doe', 'john.doe@email.com', '123-456-7890');

-- Phone is optional (can be NULL)
INSERT INTO Customers (CustomerID, FirstName, LastName, Email)
VALUES (2, 'Jane', 'Smith', 'jane.smith@email.com')

-- 6. Add a UNIQUE constraint to the ProductName column in the Products table. 

alter table Products add constraint UQ_ProductName unique (ProductName)

-- 7. Write a comment in a SQL query explaining its purpose. 
--Header comments at the top of important queries:
-- PURPOSE: Monthly revenue report by product
-- AUTHOR: Data Team
-- LAST UPDATED: 2023-10-15
-- DEPENDENCIES: Orders, Products tables

SELECT
    ProductID,      -- SKU from legacy system
    ProductName,    -- Display name for UI
    CAST(          -- Convert price to decimal
         Price AS DECIMAL(10,2)
    ) AS Price
FROM Products
-- 8. Create a table Categories with a CategoryID as PRIMARY KEY and a CategoryName as UNIQUE. 

create table Categories (
CategoryID int primary key,
CategoryName varchar(50) unique )  

-- 9. Explain the purpose of the IDENTITY column in SQL Server. 
 
 /* An identity column is a special auto-incrementing column in SQL databases that automatically generates a unique 
numeric value for each new row inserted into a table. It's commonly used for primary keys. Values cannot be manually 
inserted by default. */

________________________________________

-- ## 🟠 Medium-Level Tasks (10)
-- 10. Use BULK INSERT to import data from a text file into the Products table.  
bulk insert Products
from 'C:\Users\User\Desktop\importProducts.txt'
with 
(
firstrow = 2,
Fieldterminator = ',',
rowterminator = '\n'
) 

-- 11. Create a FOREIGN KEY in the Products table that references the Categories table.

alter table Products
add constraint FK_Products_Categories
foreign key (CategoryID) references Categories(CategoryID)

-- 12. Explain the differences between PRIMARY KEY and UNIQUE KEY with examples.

/* Both primary keys and unique keys enforce uniqueness in a column or set of columns, but they have important 
differences: Primary key must contain unique values no duplicates, can't contain NULL values, only one primary key
allowed in the table, it serves at the main identifier for the table records, by default creates the cluster index 
but can be changed and used as the target for foreign key relationships.
Unique key also must contain unique values no duplicates, can contain NULL value but only one in the table if the column
is nullable, multiple unique keys are allowed in the table, ensure uniqueness of alternate identifiers.
For example: */

CREATE TABLE Employees (
EmployeeID INT PRIMARY KEY,          -- Primary Key
SSN CHAR(9) UNIQUE NOT NULL,        -- Unique Key (alternate candidate key)
Email VARCHAR(100) UNIQUE ) 


-- 13. Add a CHECK constraint to the Products table ensuring Price > 0.

alter table Products
add constraint CHK_Products_Price_Positive
check (Price > 0)

-- 14. Modify the Products table to add a column Stock (INT, NOT NULL).

alter table Products add Stock int not null  constraint df_Products_Stock default 0 

-- 15. Use the ISNULL function to replace NULL values in a column with a default value.

select isnull(CategoryID, 0) as CategoriesID
from Products

select 
    ProductID,
    ProductName,
    ISNULL(CategoryID, '0') as NoID
from Products

select * from Products

-- 16. Describe the purpose and usage of FOREIGN KEY constraints in SQL Server.

/* Foreign key constraints serve two essential functions in relational databases:
Referential Integrity: They enforce relationships between tables by ensuring that values in one table match 
values in another table. 
Data Consistency: They prevent actions that would destroy links between tables, maintaining the logical correctness
of your data. For exmple: during the creation of the table */
CREATE TABLE Orders (
    OrderID INT PRIMARY KEY,
    CustomerID INT NOT NULL,
    OrderDate DATETIME,
    CONSTRAINT FK_Orders_Customers 
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID))
-- Basic referantioal integrity
-- Prevents inserting orders for non-existent customers
alter table Orders
add constraint FK_Orders_Customers
foreign key (CustomerID) references Customers(CustomerID)
________________________________________

-- ## 🔴 Hard-Level Tasks (10)
-- 17. Write a script to create a Customers table with a CHECK constraint ensuring Age >= 18.

create table Customers (
CustomerID INT IDENTITY(1,1) PRIMARY KEY,
FirstName NVARCHAR(50) NOT NULL,
LastName NVARCHAR(50) NOT NULL,
Email NVARCHAR(100),
Phone NVARCHAR(20),
Age INT,
CONSTRAINT CHK_Customers_Age CHECK (Age >= 18) )

-- 18. Create a table with an IDENTITY column starting at 100 and incrementing by 10.

create table Orders (
OrderID int identity(100, 10),
OrderName varchar(50), 
Category varchar(50))

insert into Orders values ('Book', 'Study'),
                          ('Laptop', 'Electronics'),
						  ('Desktop', 'Electronics')

-- 19. Write a query to create a composite PRIMARY KEY in a new table OrderDetails.

create table OrderDetails (
OrderID int,
ProductID int,
Quantity int,
Primary key (OrderID, ProductID) )

-- 20. Explain with examples the use of COALESCE and ISNULL functions for handling NULL values.
/* Both COALESCE and ISNULL are used to replace NULL values with alternatives, but they have important differences 
in functionality and use cases. ISNULL replaces NULL with a specified replacement value, takes exactly 2 parameters and
works only in SQL server returns the data type of the first argument also simple and fast for basic NULL replacements.*/

SELECT ProductName, ISNULL(DiscontinuedDate, '2099-12-31') AS ActiveUntil
FROM Products;


/* COALESCE function returns the first non-NULL expression among its arguments works with various databases, accepts multiple
parameters, returns the data type with highest precedence and much more flexible for complex NULL handling.
for example: */

SELECT COALESCE(LastName, FirstName + ' (no middle name)', 'Name unknown') AS DisplayName
FROM Customers;

-- 21. Create a table Employees with both PRIMARY KEY on EmpID and UNIQUE KEY on Email.

create table Employees(
EmpID int primary key,
Name varchar(50),
LastName varchar(50),
Email varchar(50) unique )

-- 22. Write a query to create a FOREIGN KEY with ON DELETE CASCADE and ON UPDATE CASCADE options.

CREATE TABLE Orders (
    OrderID INT PRIMARY KEY,
    CustomerID INT NOT NULL,
    OrderDate DATETIME NOT NULL,
    CONSTRAINT FK_Orders_Customers 
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
    ON DELETE CASCADE  
    ON UPDATE CASCADE   )


ALTER TABLE OrderDetails
ADD CONSTRAINT FK_OrderDetails_Products
FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
ON DELETE CASCADE  
ON UPDATE CASCADE;  
