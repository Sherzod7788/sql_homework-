-- Homework_7 

--Easy-Level Tasks (10)
-- 1.Write a query to find the minimum (MIN) price of a product in the Products table.

SELECT MIN(Price) AS Minumum FROM Products

-- 2.Write a query to find the maximum (MAX) Salary from the Employees table.

SELECT MAX(Salary) AS Maximum FROM Employees 

-- 3.Write a query to count the number of rows in the Customers table using COUNT(*).

SELECT COUNT(*) AS Rows_number FROM Customers 

-- 4.Write a query to count the number of unique product categories (COUNT(DISTINCT Category)) from the Products table.

SELECT COUNT(DISTINCT Category) AS Unique_Product FROM Products

-- 5.Write a query to find the total (SUM) sales amount for the product with id 7 in the Sales table.

SELECT ProductID, SUM(SaleAmount) AS TotalSUM 
FROM Sales
WHERE ProductID = 7 
GROUP BY ProductID

-- 6.Write a query to calculate the average (AVG) age of employees in the Employees table.

SELECT AVG(Age) AS Avg_Age 
FROM Employees 


-- 7.Write a query that uses GROUP BY to count the number of employees in each department.

SELECT DepartmentName, COUNT(*) AS Employee_Count 
FROM Employees
GROUP BY DepartmentName
ORDER BY Employee_Count DESC 

-- 8.Write a query to show the minimum and maximum Price of products grouped by Category. Use products table.

SELECT Category,  MIN(Price) AS Minimum_Price, MAX(Price) AS Maximum_Price
FROM Products
GROUP BY Category
ORDER BY Category

-- 9.Write a query to calculate the total (SUM) sales per Customer in the Sales table.

SELECT CustomerID, SUM(SaleAmount) AS Total_SalesAmount, COUNT(*) AS Num_of_Purchase 
FROM Sales 
GROUP BY CustomerID
ORDER BY Total_SalesAmount DESC 

-- 10.Write a query to use HAVING to filter departments having more than 5 employees from the Employees table.(DeptID is enough, if you don't have DeptName).

SELECT DepartmentName, COUNT(*) AS Employeecount
FROM Employees
GROUP BY DepartmentName 
HAVING COUNT(*) > 5
ORDER BY Employeecount DESC 

-- Medium-Level Tasks (9)
-- 11.Write a query to calculate the total sales and average sales for each product category from the Sales table.

SELECT ProductID, SUM(SaleAmount) AS Total_Sale, AVG(SaleAmount) AS Average_Sale 
FROM Sales
GROUP BY ProductID
ORDER BY Total_Sale DESC

-- 12.Write a query that uses COUNT(columnname) to count the number of employees from the Department HR.
 
SELECT  COUNT(*) AS Num_Employees
FROM Employees
WHERE DepartmentName = 'HR'

-- 13.Write a query that finds the highest (MAX) and lowest (MIN) Salary by department in the Employees table.(DeptID is enough, if you don't have DeptName).

SELECT DepartmentName, MAX(Salary) AS Highest,  MIN(Salary) AS Lowest
FROM Employees
GROUP BY DepartmentName
ORDER BY Highest desc, Lowest desc

-- 14.Write a query that uses GROUP BY to calculate the average salary per Department.(DeptID is enough, if you don't have DeptName).

SELECT DepartmentName, AVG(Salary) AS AVG_Salary 
FROM Employees
GROUP BY DepartmentName
ORDER BY AVG_Salary DESC

-- 15.Write a query to show the AVG salary and COUNT(*) of employees working in each department.(DeptID is enough, if you don't have DeptName).

SELECT DepartmentName, AVG(Salary) AS AVG_Salary, COUNT(*) AS Num_Employees 
FROM Employees 
GROUP BY DepartmentName
ORDER BY DepartmentName

-- 16.Write a query that uses HAVING to filter product categories with an average price greater than 400.

SELECT Category, AVG(Price) AS AVG_Price, COUNT(*) AS Product_Count
FROM Products
GROUP BY Category
HAVING AVG(Price) > 400
ORDER BY AVG_Price DESC 

-- 17.Write a query that calculates the total sales for each year in the Sales table, and use GROUP BY to group them.

SELECT YEAR(SaleDate)AS Sales_Year,
       SUM(SaleAmount) AS TotalSales
FROM Sales
GROUP BY YEAR(SaleDate)
ORDER BY Sales_Year

-- 18.Write a query that uses COUNT to show the number of customers who placed at least 3 orders.

SELECT CustomerID, COUNT(Quantity) AS Placed_Orders
FROM Orders
GROUP BY CustomerID
HAVING COUNT(Quantity) >= 3
ORDER BY Placed_Orders DESC

-- 19.Write a query that applies the HAVING clause to filter out Departments with total salary expenses greater than 500,000.(DeptID is enough, if you don't have DeptName).

SELECT DepartmentName, SUM(Salary) AS Total_Salary
FROM Employees
GROUP BY DepartmentName
HAVING SUM(Salary) > 500.000
ORDER BY Total_Salary DESC 

-- Hard-Level Tasks (6)
-- 20.Write a query that shows the average (AVG) sales for each product category, and then uses HAVING to filter categories with an average sales amount greater than 200.

SELECT Category, AVG(Price) AS AVG_Price, COUNT(*) 
FROM Products 
GROUP BY Category
HAVING AVG(Price) > 200
ORDER BY AVG_Price DESC

-- 21.Write a query to calculate the total (SUM) sales for each Customer, then filter the results using HAVING to include only Customers with total sales over 1500.

SELECT CustomerID, SUM(TotalAmount) AS Total_Sale, COUNT(*) Number_Orders
FROM Orders
GROUP BY CustomerID
HAVING SUM(TotalAmount) >1500
ORDER BY Total_Sale DESC 

-- 22.Write a query to find the total (SUM) and average (AVG) salary of employees grouped by department, and use HAVING to include only departments with an average salary greater than 65000.

SELECT DepartmentName, SUM(Salary) Total_Salary, AVG(Salary) AVG_Salary, COUNT(*) Employee_Cnt
FROM Employees
GROUP BY DepartmentName
HAVING AVG(Salary) > 65000
ORDER BY AVG_Salary DESC 

-- 23.Write a query that finds the maximum (MAX) and minimum (MIN) order value for each customer, and then applies HAVING to exclude customers with an order value less than 50.

SELECT CustomerID, MAX(TotalAmount) MAX_Total, MIN(TotalAmount) MIN_Total, COUNT(*) Total_Orders
FROM Orders
GROUP BY CustomerID
HAVING MIN(TotalAmount) >= 50
ORDER BY MAX_Total DESC

-- 24.Write a query that calculates the total sales (SUM) and counts distinct products sold in each month, and then applies HAVING to filter the months with more than 8 products sold.

SELECT
    DATEFROMPARTS(YEAR(SaleDate), MONTH(SaleDate), 1) AS sales_month,
    SUM(SaleAmount) AS total_sales,
    COUNT(DISTINCT ProductID) AS product_count
FROM Sales
GROUP BY YEAR(SaleDate), MONTH(SaleDate)
HAVING COUNT(DISTINCT ProductID) > 8
ORDER BY sales_month DESC


-- 25.Write a query to find the MIN and MAX order quantity per Year. From orders table. (Do some research)

SELECT DATEPART(YEAR, OrderDate) AS order_year, MIN(Quantity) Min_Quantity, MAX(Quantity) Max_Quantity
FROM Orders
GROUP BY OrderDate
























