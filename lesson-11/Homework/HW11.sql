-- Lesson 11 Homework Tasks

-- Easy-Level Tasks (7)

/* 1.Return: `OrderID`, `CustomerName`, `OrderDate`  
   Task: Show all orders placed after 2022 along with the names of the customers who placed them.  
   Tables Used: `Orders`, `Customers` */ 

   SELECT O.OrderID, 
          C.FirstName,
		      O.OrderDate
   FROM Orders O
   JOIN Customers C 
   ON O.CustomerID = C.CustomerID
   WHERE YEAR(O.OrderDate) > 2022
   ORDER BY O.OrderDate DESC  


/* 2.Return: EmployeeName, DepartmentName
Task: Display the names of employees who work in either the Sales or Marketing department.
Tables Used: Employees, Departments */ 

SELECT E.Name AS EmployeeName, 
       D.DepartmentName
FROM Employees E
JOIN Departments D
ON E.DepartmentID = D.DepartmentID
WHERE D.DepartmentName = 'Sales' OR D.DepartmentName = 'Marketing' 
ORDER BY E.Name

/* 3.Return: DepartmentName, TopEmployeeName, MaxSalary
Task: For each department, show the name of the employee who earns the highest salary.
Tables Used: Departments, Employees (as a derived table) */ 

SELECT 
    D.DepartmentName,
    E.Name AS TopEmployeeName,
    E.Salary AS MaxSalary
FROM Departments D
JOIN Employees E ON D.DepartmentID = E.DepartmentID
JOIN (SELECT DepartmentID, MAX(Salary) AS MaxSalary FROM Employees
GROUP BY DepartmentID) max_sal ON E.DepartmentID = max_sal.DepartmentID 
AND E.Salary = max_sal.MaxSalary
ORDER BY D.DepartmentName



/* 4.Return: CustomerName, OrderID, OrderDate
Task: List all customers from the USA who placed orders in the year 2023.
Tables Used: Customers, Orders */ 

SELECT C.FirstName AS CustomerName, 
       O.OrderID,
	     O.OrderDate
FROM Customers C
JOIN Orders O 
ON C.CustomerID = O.CustomerID
WHERE C.Country = 'USA' AND YEAR(O.OrderDate) = 2023
ORDER BY O.OrderDate DESC


/* 5.Return: CustomerName, TotalOrders
Task: Show how many orders each customer has placed.
Tables Used: Orders (as a derived table), Customers */ 

SELECT C.FirstName AS CustomerName, 
       COUNT(O.OrderID) AS TotalOrders
FROM Customers C
JOIN Orders O
ON C.CustomerID = O.CustomerID
GROUP BY C.CustomerID, C.FirstName


/* 6.Return: ProductName, SupplierName
Task: Display the names of products that are supplied by either Gadget Supplies or Clothing Mart.
Tables Used: Products, Suppliers */

SELECT P.ProductName,
       S.SupplierName
FROM Products P
JOIN Suppliers S
ON P.SupplierID = S.SupplierID
WHERE S.SupplierName = 'Gadget Supplies' OR S.SupplierName = 'Clothing Mart'
ORDER BY P.ProductName


/* 7.Return: CustomerName, MostRecentOrderDate, OrderID
Task: For each customer, show their most recent order. Include customers who haven't placed any orders.
Tables Used: Customers, Orders (as a derived table) */

SELECT C.FirstName AS CustomerName,
       MAX(O.OrderDate) AS MostRecentOrderDate,
	     O.OrderID 
FROM Customers C
LEFT JOIN Orders O
ON C.CustomerID = O.CustomerID
GROUP BY C.FirstName, O.OrderID
ORDER BY C.FirstName


-- Medium-Level Tasks (6)
/* 8.Return: CustomerName, OrderID, OrderTotal
Task: Show the customers who have placed an order where the total amount is greater than 500.
Tables Used: Orders, Customers */ 

SELECT C.FirstName AS CustomerName,
       O.OrderID,
	     O.TotalAmount AS OrderTotal
FROM Orders O
JOIN Customers C
ON O.CustomerID = C.CustomerID
WHERE O.TotalAmount > 500
ORDER BY OrderTotal DESC


/* 9.Return: ProductName, SaleDate, SaleAmount
Task: List product sales where the sale was made in 2022 or the sale amount exceeded 400.
Tables Used: Products, Sales
*/

SELECT P.ProductName,
       S.SaleDate,
	     S.SaleAmount
FROM Products P
JOIN Sales S
ON P.ProductID = S.ProductID
WHERE YEAR(S.SaleDate) = 2022 OR S.SaleAmount > 400  
ORDER BY S.SaleDate DESC 


/* 10.Return: ProductName, TotalSalesAmount
Task: Display each product along with the total amount it has been sold for.
Tables Used: Sales (as a derived table), Products
*/

SELECT P.ProductName,
       SUM(S.SaleAmount) AS TotalSalesAmount
FROM Sales S
JOIN Products P
ON S.ProductID = P.ProductID
GROUP BY P.ProductName
ORDER BY TotalSalesAmount DESC


/* 11.Return: EmployeeName, DepartmentName, Salary
Task: Show the employees who work in the HR department and earn a salary greater than 50000.
Tables Used: Employees, Departments
*/
SELECT E.Name AS EmploeeName,
       D.DepartmentName,
	     E.Salary
FROM Employees E
JOIN Departments D
ON E.DepartmentID = D.DepartmentID
WHERE D.DepartmentName = 'Human Resources' AND E.Salary > 50000
ORDER BY E.Salary DESC


/* 12.Return: ProductName, SaleDate, StockQuantity
Task: List the products that were sold in 2023 and had more than 50 units in stock at the time.
Tables Used: Products, Sales */

SELECT P.ProductName,
       S.SaleDate,
	     P.StockQuantity
FROM Products P
JOIN Sales S
ON P.ProductID = S.ProductID
WHERE YEAR(S.SaleDate) = 2023 AND P.StockQuantity > 50
ORDER BY S.SaleDate


/* 13.Return: EmployeeName, DepartmentName, HireDate
Task: Show employees who either work in the Sales department or were hired after 2020.
Tables Used: Employees, Departments
*/
SELECT E.Name AS EmployeeName,
       D.DepartmentName,
	     E.HireDate
FROM Employees E
JOIN Departments D
ON E.DepartmentID = D.DepartmentID
WHERE D.DepartmentName = 'Sales' OR YEAR(E.HireDate) > 2020
ORDER BY D.DepartmentName, E.HireDate DESC 

-- Hard-Level Tasks (7)
/* 14.Return: CustomerName, OrderID, Address, OrderDate
Task: List all orders made by customers in the USA whose address starts with 4 digits.
Tables Used: Customers, Orders */

SELECT C.FirstName AS CustomerName,
       O.OrderID, 
	     C.Address,
	     O.OrderDate,
	     C.Country
FROM Customers C
JOIN Orders O
ON C.CustomerID = O.CustomerID
WHERE C.Country = 'USA' and C.[Address] LIKE '____ %'
ORDER BY C.Country, C.[Address] ASC


/* 15.Return: ProductName, Category, SaleAmount
Task: Display product sales for items in the Electronics category or where the sale amount exceeded 350.
Tables Used: Products, Sales*/ 

SELECT P.ProductName,
       P.Category, 
	     S.SaleAmount
FROM Products P
JOIN Sales S 
ON P.ProductID = S.ProductID
WHERE P.Category = 'Electronics' OR S.SaleAmount > 350 
ORDER BY P.Category, S.SaleAmount


/* 16.Return: CategoryName, ProductCount
Task: Show the number of products available in each category.
Tables Used: Products (as a derived table), Categories
*/
SELECT C.CategoryName,
       COUNT(P.ProductID) AS ProductCount
FROM Categories C
LEFT JOIN Products P
ON C.CategoryID = P.Category 
GROUP BY C.CategoryID, C.CategoryName
ORDER BY ProductCount DESC 


/* 17.Return: CustomerName, City, OrderID, Amount
Task: List orders where the customer is from Los Angeles and the order amount is greater than 300.
Tables Used: Customers, Orders
*/

SELECT C.FirstName AS CustomerName,
       C.City,
	     O.OrderID,
	     O.TotalAmount
FROM Customers C
JOIN Orders O
ON C.CustomerID = O.CustomerID
WHERE C.City = 'Los Angeles' AND O.TotalAmount > 300
ORDER BY O.TotalAmount DESC


/* 18.Return: EmployeeName, DepartmentName
Task: Display employees who are in the HR or Finance department, or whose name contains at least 4 vowels.
Tables Used: Employees, Departments
*/

SELECT E.Name AS EmployeeName, 
       D.DepartmentName
FROM Employees E
JOIN Departments D
ON E.DepartmentID = D.DepartmentID
WHERE D.DepartmentName IN ('Human Resource', 'Finance') OR
     (LEN(E.Name) - LEN(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(LOWER(E.Name),
	 'a', ''), 'e', ''), 'i', ''), 'o', ''), 'u', '')) >= 4)
ORDER BY D.DepartmentName, E.Name


/* 19.Return: ProductName, QuantitySold, Price
Task: List products that had a sales quantity above 100 and a price above 500.
Tables Used: Sales, Products
*/

SELECT P.ProductName,
       SUM(P.StockQuantity) AS QuantitySold,
	     S.SaleAmount
FROM Products P
JOIN Sales S
ON S.ProductID = P.ProductID
GROUP BY P.ProductID, P.ProductName, S.SaleAmount
HAVING  SUM(P.StockQuantity) > 100 AND S.SaleAmount > 500
ORDER BY QuantitySold DESC


/* 20.Return: EmployeeName, DepartmentName, Salary
Task: Show employees who are in the Sales or Marketing department and have a salary above 60000.
Tables Used: Employees, Departments
*/ 

SELECT E.Name AS EmployeeName,
       D.DepartmentName,
	     E.Salary
FROM Employees E
JOIN Departments D
ON E.DepartmentID = D.DepartmentID
WHERE D.DepartmentName IN ('Sales', 'Marketing') AND E.Salary > 60000
ORDER BY E.Salary DESC


