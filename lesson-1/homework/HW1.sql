-- Homework_1


/* 1.Define the following terms: data, database, relational database, and table?
Basically Data is raw facts or information.
It can be various types like numbers, text, dates, or anything that can be recorded and used.
A database is an organized collection of data, stored so that it can be easily accessed, managed, and updated.
A relational database is a type of database that stores data in tables like spreadsheets and allows the data
in different tables to be related to each other using keys. For example: A "Customers" table and an "Orders" 
table can be connected using a customer ID.
A table is a structure inside a relational database that organizes data into rows and columns.
Each row equal one record. Each column equal a field (like Name, City)*/
-------------------------------------------------------------------------------------------


 /*  2.List five key features of SQL Server?
In SQL Server there are multiple key features 
1. Security Features
SQL Server provides authentication, encryption, and row-level security to protect data.
2. High Availability & Disaster Recovery
Features like Always On Availability Groups, failover clustering, and log shipping help ensure uptime and data safety.
3. Advanced Analytics
Built-in support for machine learning, Python, and R lets you run analytics directly on your data.
4. Integration Services (SSIS)
Tools for building ETL (Extract, Transform, Load) processes to move and clean data from various sources.
5. Business Intelligence (BI)
SQL Server provides Analysis Services (SSAS) and Reporting Services (SSRS) to support data warehousing and reporting needs.*/
-------------------------------------------------------------------------------------------------------------------

/* 3.What are the different authentication modes available when connecting to SQL Server? (Give at least 2)
There are two main authentication modes in SQL Server. Windows and SQL Server authentications.
In Windows authentication it uses your Windows login credentials to connect. Relies on Active Directory for security.
For example: Automatically logs you in with your Windows account.
In SQL Server authentication it requires a username and password created within SQL Server. Independent of Windows accounts.
For example: Login with a SQL account like username: sa, password: yourpass. We can choose either mode or allow both when configuring SQL Server.*/
-------------------------------------------------------------------------------------------------------------------------

/* 4. Create a new database in SSMS named SchoolDB.*/
CREATE DATABASE SchoolDB 

USE SchoolDB


/* 5. Write and execute a query to create a table called Students with columns: StudentID (INT, PRIMARY KEY), Name 
(VARCHAR(50)), Age (INT).*/

CREATE TABLE Students (
StudentID INT PRIMARY KEY,
Name VARCHAR(50),
Age INT )

/* 6. Describe the differences between SQL Server, SSMS, and SQL.

 Microsoft SQL Server is a Relational Database Management System (RDBMS) designed to store, retrieve,
 and manage structured data. It supports transaction processing, business intelligence, and analytics 
 applications in corporate IT environments. Also it includes support for advanced querying, indexing,
 security, high availability, backup, restore, and integration with other Microsoft services like Azure and Power BI.
      SQL Server Management Studio is an integrated environment developed by Microsoft for managing any SQL infrastructure, 
from SQL Server to Azure SQL Database. It provides a graphical interface and set of tools for database development, administration,
and management tasks. Query editor, object explorer, debugging tools, scripting, visual table design, and performance monitoring 
utilities.
      SQL is a standard programming language specifically designed for managing and manipulating relational databases.
 It is used to query, insert, update, and delete data, as well as to define and control database structures and access.
 Basically uses common commands: SELECT, INSERT, UPDATE, DELETE, CREATE, ALTER, and DROP. */
 -------------------------------------------------------------------------------------------------------------------------


 /* 7.Research and explain the different SQL commands: DQL, DML, DDL, DCL, TCL with examples. 

 DQL is Data Query Language retrieves data from the database a subset of SQL (Structured Query Language) used specifically 
 for querying and retrieving data from databases with using SELECT command 
 for example:  SELECT * FROM Students. Mainly it's used for  fetching data from database tables.
 DQL queries don't change the database structure or data in the table. 

 DML stands for Data Manipulation Language, a subset of SQL used to insert, update, delete, and modify data in a database. 
 Unlike DQL, which only retrieves data, DML commands change the actual data stored in tables. For example: 
 INSERT INTO Employees (id, name, salary) VALUES (107, 'Jack', 7000) 
 UPDATE Employees SET salary = 6500 WHERE id = 107
 DELETE FROM Employees WHERE id = 107

 DDL stands for Data Definition Language, a subset of SQL used to define, modify, and manage database structures 
 (tables, schemas, indexes, etc.). Unlike DML, which works with data, DDL commands change the database schema itself.
 For example: 
 Creating table Students
    CREATE TABLE Students (
    StudentID INT PRIMARY KEY,
    FirstName VARCHAR(100),
    LastName VARCHAR(100) )
Adding a new column: ALTER TABLE Students ADD COLUMN Subject VARCHAR(50)
Removing a column: ALTER TABLE Students DROP COLUMN Subject
Delete the entire table structure: DROP TABLE Students
Removing all data (but keep the table structure): TRUNCATE TABLE Students

DCL stands for Data Control Language, a subset of SQL used to manage database security and access permissions. 
It controls who can access or modify data in a database by granting or revoking privileges. For example: 
Giving the permission to user for reading data:  GRANT SELECT ON Employees TO user1
Removing SELECT permission from a user: REVOKE SELECT ON Employees FROM user1
Block a user from updating a table: DENY UPDATE ON employees TO restricted_user

TCL stands for Transaction Control Language, a subset of SQL used to manage transactions in a database. 
Transactions ensure data integrity by grouping SQL operations into logical units that either complete fully or 
roll back entirely if an error occurs. For example: 
Basic Transaction Flow:
BEGIN TRANSACTION  -- Starts a transaction (syntax may vary by DBMS)
  
INSERT INTO orders (order_id, product, quantity) VALUES (101, 'Laptop', 1)  
UPDATE inventory SET stock = stock - 1 WHERE product = 'Laptop'  

COMMIT  -- Saves changes permanently  
-- OR (if an error occurs)  
-- ROLLBACK  -- Reverts all changes  

--Using SAVEPOINT for Partial Rollback:
BEGIN TRANSACTION 

INSERT INTO employees (id, name) VALUES (1, 'Alice') 
SAVEPOINT sp1  -- Creates a restore point  

UPDATE employees SET salary = 5000 WHERE id = 1  
-- Oops, wrong update!  
ROLLBACK TO sp1  -- Undoes only the UPDATE, keeps the INSERT  

COMMIT

-- For Configuring Transactions:
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE  -- Prevents dirty reads, phantom reads  
BEGIN TRANSACTION 
-- Execute critical operations  
COMMIT.*/ 
---------------------------------------------------------------------------------------------------------------------------------------------

/* 8.Write a query to insert three records into the Students table.*/

INSERT INTO Students (StudentID, Name, Age)
VALUES (101, 'John', 30),
       (102, 'Michael', 45),
	     (103, 'Lora', 25)


/* 9.Create a backup of your SchoolDB database and restore it. (write its steps to submit)*/ 

/* I clicked on Object Explorer and chose  Databases from Databases I looked for SchoolDB that I created before 
and right cliked on it then chose tasks after that chose Back up... option and clicked on it, new window puped up 
I found the Destination of Back up file and clicked ADD button, it gave me selection of Backup Destination I 
clicked on three doots which is located right side little square button and I wrote my File name for backup file
and clicked ok button after that Backup file for SchoolDB complited succesfully.  







