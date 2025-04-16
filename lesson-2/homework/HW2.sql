-- Homework_2
USE SchoolDB
/* Basic-Level Tasks (10)
1.Create a table Employees with columns: EmpID INT, Name (VARCHAR(50)), and Salary (DECIMAL(10,2)).*/

create table Employees (
EmpID INT, 
Name varchar(50),
Salary decimal(10, 2) )

/*2.Insert three records into the Employees table using different INSERT INTO approaches (single-row insert and multiple-row insert).*/

insert into Employees (EmpID, Name, Salary)
values (1, 'Sara', 64000),
       (2, 'Tom', 55000),
	   (3, 'Jim', 99000),
	   (4, 'Steve', 67000), 
	   (5, 'Peter', 45000)

/*3.Update the Salary of an employee where EmpID = 1.*/
update Employees
set Salary = 70000
where EmpID = 1

select * from Employees

/*4.Delete a record from the Employees table where EmpID = 2.*/

delete from Employees
where EmpID = 2

/*5.Demonstrate the difference between DELETE, TRUNCATE, and DROP commands on a test table.
Delete command is used to remove a row inside the table. It can be used with where clause in order to filter data.
For example:*/

delete from Test1
where EmpID = 3

/* Truncate command is used to remove all rows in a time quickly does not use where clause, much more faster than
delete command also resets indentity counters for example: */

truncate table Test1

/* Drop command is used to remove entire table structure and removes the table completely as well as all relationships
indexes, triggers are also dropped for example: */

drop table Test1  

/* 6.Modify the Name column in the Employees table to VARCHAR(100).*/

alter table Employees alter column Name varchar(100)

/* 7.Add a new column Department (VARCHAR(50)) to the Employees table.*/

alter table Employees add Department varchar(50) 


/* 8.Change the data type of the Salary column to FLOAT.*/

alter table Employees alter column Salary float 


/* 9.Create another table Departments with columns DepartmentID (INT, PRIMARY KEY) and DepartmentName (VARCHAR(50)).*/

create table Departments (
DepartmentID INT Primary key,
DepartmentName varchar(50) )

/* 10.Remove all records from the Employees table without deleting its structure.*/ 

truncate table Employees 
------------------------------------------------------------------------------------------------------------------
/* Intermediate-Level Tasks (6)
11.Insert five records into the Departments table using INSERT INTO SELECT from an existing table.*/

select * into Departments from Employees
select * from Departments

/* 12.Update the Department of all employees where Salary > 5000 to 'Management'.*/

update Employees
set Department = 'Managemenet' 
where Salary > 5000

select * from Employees

/* 13.Write a query that removes all employees but keeps the table structure intact.*/

Truncate table Employees 

/* 14.Drop the Department column from the Employees table.*/

alter table Employees drop column Department 

/* 15.Rename the Employees table to StaffMembers using SQL commands.*/

exec sp_rename 'Employees', 'StaffMembers'   

select * from StaffMembers 

/* 16.Write a query to completely remove the Departments table from the database.*/

drop table Departments 

select * from Departments 
--------------------------------------------------------------------------------------------------------------------
/* Advanced-Level Tasks (9)
17.Create a table named Products with at least 5 columns, including: ProductID (Primary Key), ProductName (VARCHAR),
Category (VARCHAR), Price (DECIMAL) */

create table Products (
ProductID int primary key,
ProductName varchar(100),
Category varchar(100), 
Price decimal(10,2) ) 

/* 18.Add a CHECK constraint to ensure Price is always greater than 0.*/

alter table Products
add constraint CHK_PricePositive check (Price > 0)

/* 19.Modify the table to add a StockQuantity column with a DEFAULT value of 50.*/

alter table Products
add StockQuantity int default 50

select * from Products

/* 20.Rename Category to ProductCategory*/

exec sp_rename 'Products.Category', 'ProductCategory' 

/* 21.Insert 5 records into the Products table using standard INSERT INTO queries.*/

insert into Products (ProductID, ProductName, ProductCategory, Price, StockQuantity)
values (101, 'Laptop', 'Electronics', 999.90, 5),
       (102, 'Fruit', 'Grocery', 4.50, 100),
	   (103, 'Printer', 'Electronics', 455.00, 50),
	   (104, 'Desktop', 'Electronics', 700.00, 80),
	   (105, 'Mercedes', 'Vehicle', 1000.00, 100) 


/* 22.Use SELECT INTO to create a backup table called Products_Backup containing all Products data.*/

select * into Products_Backup from Products 
select * from Products_Backup

/* 23.Rename the Products table to Inventory.*/ 

exec sp_rename 'Products', 'Inventory'
select * from Inventory

/* 24.Alter the Inventory table to change the data type of Price from DECIMAL(10,2) to FLOAT.*/ 

alter table Inventory alter column Price float 

/* 25.Add an IDENTITY column named ProductCode that starts from 1000 and increments by 5.*/ 

alter table Inventory add ProductCode INT Identity (1000, 5) 




































