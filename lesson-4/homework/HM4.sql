create database Homework_4
use Homework_4

-- Easy-Level Tasks (10)
-- 1.Write a query to select the top 5 employees from the Employees table.

select top 5 * from Employees 

-- 2.Use SELECT DISTINCT to select unique ProductName values from the Products table.

select distinct ProductName from Products  

-- 3.Write a query that filters the Products table to show products with Price > 100.

select * from Products 
where Price > 100 

-- 4.Write a query to select all CustomerName values that start with 'A' using the LIKE operator.

select FirstName from Customers
where FirstName like 'A%'

-- 5.Order the results of a Products query by Price in ascending order.

select * from Products 
order by Price asc 

-- 6.Write a query that uses the WHERE clause to filter for employees with Salary >= 60000 and Department = 'HR'.

select * from Employees
where Salary >= 60000 and DepartmentName = 'HR'

-- 7.Use ISNULL to replace NULL values in the Email column with the text "noemail@example.com".From Employees table

select EmployeeID, FirstName, LastName, isnull(Email, 'noemail@example.com') as Email from Employees

-- 8.Write a query that shows all products with Price BETWEEN 50 AND 100.

select * from Products 
where Price between 50 and 100

-- 9.Use SELECT DISTINCT on two columns (Category and ProductName) in the Products table.

select distinct Category, ProductName from Products

-- 10.After SELECT DISTINCT on two columns (Category and ProductName) Order the results by ProductName in descending order.

select distinct Category, ProductName from Products 
order by ProductName desc


-- Medium-Level Tasks (10)
-- 11.Write a query to select the top 10 products from the Products table, ordered by Price DESC.

select top 10 * from Products
order by Price desc

-- 12.Use COALESCE to return the first non-NULL value from FirstName or LastName in the Employees table.

select EmployeeID, FirstName, LastName, coalesce(FirstName, LastName) as Name
from Employees

-- 13.Write a query that selects distinct Category and Price from the Products table.

select distinct Category, Price from Products 

-- 14.Write a query that filters the Employees table to show employees whose Age is either between 30 and 40 or Department = 'Marketing'.

select * from Employees 
where (Age between 30 and 40) or (DepartmentName = 'Marketing') 

-- 15.Use OFFSET-FETCH to select rows 11 to 20 from the Employees table, ordered by Salary DESC.

select * from Employees
order by Salary desc offset 10 rows fetch next 10 rows only 

-- 16.Write a query to display all products with Price <= 1000 and Stock > 50, sorted by Stock in ascending order.

select ProductID, ProductName, Price, StockQuantity from Products
where Price <=1000 and StockQuantity > 50
order by StockQuantity asc 

-- 17.Write a query that filters the Products table for ProductName values containing the letter 'e' using LIKE.

select ProductName from Products
where ProductName like '%e%'

-- 18.Use IN operator to filter for employees who work in either 'HR', 'IT', or 'Finance'.

select * from Employees 
where DepartmentName in ('HR', 'IT', 'Finance')

-- 19.Use ORDER BY to display a list of customers ordered by City in ascending and PostalCode in descending order.Use customers table

select * from Customers
order by City asc,  PostalCode desc

-- Hard-Level Tasks
-- 20.Write a query that selects the top 10 products with the highest sales, using TOP(10) and ordered by SalesAmount DESC.

select top 10 * from Sales
order by SaleAmount desc

-- 21.Combine FirstName and LastName into one column named FullName in the Employees table. (only in select statement)

select EmployeeID, FirstName +' '+ LastName as FullName from Employees 

-- 22.Write a query to select the distinct Category, ProductName, and Price for products that are priced above $50, using DISTINCT on three columns.
select distinct Category, ProductName, Price from Products 
where Price > 50
order by Category, ProductName 

-- 23.Write a query that selects products whose Price is less than 10% of the average price in the Products table. (Do some research on how to find average price of all products)

select ProductID, ProductName, Price,
    (select avg(Price) from Products) as AveragePrice,
    (select avg(Price) * 0.1 from Products) as TenPercentOfAverage
from Products
where Price < (select avg(Price) * 0.1 from Products)
order by Price desc

-- 24.Use WHERE clause to filter for employees whose Age is less than 30 and who work in either the 'HR' or 'IT' department.

select * from Employees
where Age < 30 and DepartmentName in ('HR', 'IT')

-- 25.Use LIKE with wildcard to select all customers whose Email contains the domain '@gmail.com'.

select Email from Customers
where Email like '%@gmail.com%'

-- 26.Write a query that uses the ALL operator to find employees whose salary is greater than all employees in the 'Sales' department.
-- I chose IT DepatmentName insted of Sales because there isn't Sales option in the DepartmentName column 
select 
    EmployeeID,
    FirstName,
    LastName,
    Salary,
    DepartmentName
from Employees 
where Salary > all (
        select Salary 
        from Employees 
        where DepartmentName = 'IT')
    
-- 27.Write a query that filters the Orders table for orders placed in the last 180 days using BETWEEN and CURRENT_DATE. (Search how to get the current date)

select * from Orders
where OrderDate between dateadd(day, -180, getdate()) and getdate()




























