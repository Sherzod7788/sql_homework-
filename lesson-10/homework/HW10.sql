-- Homework_10

-- Easy-Level Tasks (10)
/* 1.Using the Employees and Departments tables, write a query to return the names and salaries of employees whose salary is greater than 50000, along with their department names.
🔁 Expected Output: EmployeeName, Salary, DepartmentName*/

SELECT E.Name AS EmployeeName,
       E.Salary, 
	     D.DepartmentName 
FROM Employees E
JOIN Departments D
ON E.DepartmentID = D.DepartmentID
WHERE E.Salary > 50000
ORDER BY Salary DESC

/* 2.Using the Customers and Orders tables, write a query to display customer names and order dates for orders placed in the year 2023.
🔁 Expected Output: FirstName, LastName, OrderDate*/

SELECT  C.FirstName,  
        C.LastName,
	    	O.OrderDate
FROM Customers C
JOIN Orders O
ON C.CustomerID = O.CustomerID
WHERE O.OrderDate BETWEEN '2023-01-01' AND '2023-12-31'


/* 3.Using the Employees and Departments tables, write a query to show all employees along with their department names. Include employees who do not belong to any department.
🔁 Expected Output: EmployeeName, DepartmentName
(Hint: Use a LEFT OUTER JOIN)*/

SELECT E.Name AS EmployeeName,
       D.DepartmentName 
FROM Employees E
LEFT JOIN Departments D
ON E.DepartmentID = D.DepartmentID
ORDER BY E.Name  


/* 4.Using the Products and Suppliers tables, write a query to list all suppliers and the products they supply. Show suppliers even if they don’t supply any product.
🔁 Expected Output: SupplierName, ProductName*/ 

SELECT S.SupplierName, 
       P.ProductName
FROM Suppliers S
LEFT JOIN Products P
ON S.SupplierID = P.SupplierID
ORDER BY S.SupplierName

/* 5.Using the Orders and Payments tables, write a query to return all orders and their corresponding payments. Include orders without payments and payments not linked to any order.
🔁 Expected Output: OrderID, OrderDate, PaymentDate, Amount*/ 

SELECT O.OrderID,
       O.OrderDate,
	     P.PaymentDate, 
	     P.Amount
FROM Orders O
LEFT JOIN Payments P
ON O.OrderID = P.OrderID 
ORDER BY P.Amount DESC

/* 6.Using the Employees table, write a query to show each employee's name along with the name of their manager.
🔁 Expected Output: EmployeeName, ManagerName*/

SELECT E.Name AS EmployeeName,
       M.Name AS ManagerName
FROM Employees E
LEFT JOIN Employees M
ON E.ManagerID = M.EmployeeID
ORDER BY EmployeeName, ManagerName


/* 7.Using the Students, Courses, and Enrollments tables, write a query to list the names of students who are enrolled in the course named 'Math 101'.
🔁 Expected Output: StudentName, CourseName*/

SELECT S.Name AS StudentName, 
       C.CourseName
FROM Students S
JOIN Enrollments E
ON E.StudentID = S.StudentID
JOIN Courses C
ON E.CourseID = C.CourseID
WHERE C.CourseName = 'Math 101'
ORDER BY C.CourseName


/* 8.Using the Customers and Orders tables, write a query to find customers who have placed an order with more than 3 items. Return their name and the quantity they ordered.
🔁 Expected Output: FirstName, LastName, Quantity*/

SELECT C.FirstName, 
       C.LastName,
	     O.Quantity 
FROM Customers C
JOIN Orders O 
ON C.CustomerID = O.CustomerID
WHERE O.Quantity > 3
ORDER BY O.Quantity DESC


/* 9.Using the Employees and Departments tables, write a query to list employees working in the 'Human Resources' department.
🔁 Expected Output: EmployeeName, DepartmentName*/

SELECT E.Name AS EmployeeName,
       D.DepartmentName
FROM Employees E
JOIN Departments D
ON E.DepartmentID = D.DepartmentID 
WHERE D.DepartmentName = 'Human Resources'
ORDER BY  D.DepartmentName 

🟠 -- Medium-Level Tasks (9)
/* 10.Using the Employees and Departments tables, write a query to return department names that have more than 10 employees.
🔁 Expected Output: DepartmentName, EmployeeCount*/ 

SELECT D.DepartmentName,
       D.DepartmentID,
	     COUNT(E.EmployeeID) AS EmployeeCount
FROM Departments D
JOIN Employees E
ON D.DepartmentID = E.DepartmentID
GROUP BY D.DepartmentID, D.DepartmentName
HAVING COUNT(E.EmployeeID) > 10
ORDER BY EmployeeCount DESC 


/* 11.Using the Products and Sales tables, write a query to find products that have never been sold.
🔁 Expected Output: ProductID, ProductName*/

SELECT P.ProductID,
       P.ProductName
FROM Products P
LEFT JOIN Sales S
ON P.ProductID = S.ProductID
WHERE S.SaleID IS NULL
ORDER BY P.ProductName


/* 12.Using the Customers and Orders tables, write a query to return customer names who have placed at least one order.
🔁 Expected Output: FirstName, LastName, TotalOrders*/

SELECT C.FirstName,
       C.LastName, 
	     COUNT(O.OrderID) AS TotalOrders
FROM Customers C
JOIN Orders O
ON C.CustomerID = O.CustomerID
GROUP BY C.FirstName, C.LastName
HAVING COUNT(O.OrderID) >= 1
ORDER BY TotalOrders DESC

/* 13.Using the Employees and Departments tables, write a query to show only those records where both employee and department exist (no NULLs).
🔁 Expected Output: EmployeeName, DepartmentName*/

SELECT E.Name AS EmployeeName,
       D.DepartmentName
FROM Employees E
JOIN Departments D
ON E.DepartmentID = D.DepartmentID 
ORDER BY E.Name, D.DepartmentName ASC 


/* 14.Using the Employees table, write a query to find pairs of employees who report to the same manager.
🔁 Expected Output: Employee1, Employee2, ManagerID*/

SELECT E1.Name AS Employee1,
       E2.Name AS Employee2,
       E1.ManagerID AS ManagerID
FROM Employees E1
JOIN Employees E2 
ON E1.ManagerID = E2.ManagerID 
AND E1.EmployeeID <> E2.EmployeeID 
ORDER BY E1.ManagerID, E1.Name, E2.Name


/* 15.Using the Orders and Customers tables, write a query to list all orders placed in 2022 along with the customer name.
🔁 Expected Output: OrderID, OrderDate, FirstName, LastName*/

SELECT O.OrderID,
       O.OrderDate,
	     C.FirstName,
	     C.LastName
FROM Orders O
JOIN Customers C
ON O.CustomerID = C.CustomerID
WHERE O.OrderDate BETWEEN '2022-01-01' AND '2022-12-31'
ORDER BY O.OrderDate ASC

/* 16.Using the Employees and Departments tables, write a query to return employees from the 'Sales' department whose salary is above 60000.
🔁 Expected Output: EmployeeName, Salary, DepartmentName*/

SELECT E.Name AS EmployeeName,
       E.Salary,
	     D.DepartmentName
FROM Employees E
JOIN Departments D
ON E.DepartmentID = D.DepartmentID
WHERE D.DepartmentName = 'Sales' AND E.Salary > 60000
ORDER BY E.Salary DESC 

/* 17.Using the Orders and Payments tables, write a query to return only those orders that have a corresponding payment.
🔁 Expected Output: OrderID, OrderDate, PaymentDate, Amount*/

SELECT O.OrderID,
       O.OrderDate,
	     P.PaymentDate,
	     P.Amount
FROM Orders O
JOIN Payments P
ON O.OrderID = P.OrderID
ORDER BY  O.OrderDate DESC 

/* 18.Using the Products and Orders tables, write a query to find products that were never ordered.
🔁 Expected Output: ProductID, ProductName*/

SELECT P.ProductID,
       P.ProductName
FROM Products P
LEFT JOIN Orders O
ON P.ProductID = O.ProductID
WHERE O.ProductID IS NULL 
ORDER BY P.ProductName

-- Hard-Level Tasks (9)
/* 19.Using the Employees table, write a query to find employees whose salary is greater than the average salary of all employees.
🔁 Expected Output: EmployeeName, Salary*/

SELECT Name AS EmployeeName, Salary 
FROM Employees 
WHERE Salary > (SELECT AVG(Salary) FROM Employees)

/* 20.Using the Orders and Payments tables, write a query to list all orders placed before 2020 that have no corresponding payment.
🔁 Expected Output: OrderID, OrderDate*/

SELECT O.OrderID,
       O.OrderDate
FROM Orders O
LEFT JOIN Payments P
ON O.OrderID = P.OrderID
WHERE YEAR(O.OrderDate) < 2020 AND P.OrderID IS NULL
ORDER BY O.OrderDate DESC

/* 21.Using the Products and Categories tables, write a query to return products that do not have a matching category.
🔁 Expected Output: ProductID, ProductName*/

SELECT P.ProductID,
       P.ProductName
FROM Products P
LEFT JOIN Categories C
ON P.CategoryID = C.CategoryID
WHERE C.CategoryID IS NULL


/* 22.Using the Employees table, write a query to find employees who report to the same manager and earn more than 60000.
 🔁 Expected Output: Employee1, Employee2, ManagerID, Salary*/

SELECT E1.Name AS Employee1,
       E2.Name AS Employee2,
	     E1.ManagerID AS ManagerID,
	     E1.Salary AS Salary1,
	     E2.Salary AS Salary2
FROM Employees E1
JOIN Employees E2
ON E1.ManagerID = E2.ManagerID
AND E1.EmployeeID < E2.EmployeeID
WHERE  E1.Salary > 60000 
AND E2.Salary >60000
ORDER BY E1.ManagerID, E1.Name, E2.Name 


/* 23.Using the Employees and Departments tables, write a query to return employees who work in departments whose name starts with the letter 'M'.
🔁 Expected Output: EmployeeName, DepartmentName*/

SELECT E.Name AS EmployeeName,
       D.DepartmentName   
FROM Employees E
JOIN Departments D
ON E.DepartmentID = D.DepartmentID
WHERE E.Name LIKE 'M%' 
ORDER BY E.Name


/* 24.Using the Products and Sales tables, write a query to list sales where the amount is greater than 500, including product names.
🔁 Expected Output: SaleID, ProductName, SaleAmount*/

SELECT S.SaleID,
       P.ProductName,
	     S.SaleAmount
FROM Products P
JOIN Sales S
ON P.ProductID = S.ProductID
WHERE S.SaleAmount > 500
ORDER BY P.ProductName ASC
select * from Sales


/* 25.Using the Students, Courses, and Enrollments tables, write a query to find students who have not enrolled in the course 'Math 101'.
🔁 Expected Output: StudentID, StudentName*/

SELECT S.StudentID,
       S.Name AS StudentName
FROM Students S
LEFT JOIN Enrollments E
ON S.StudentID = E.StudentID
LEFT JOIN Courses C
ON E.CourseID = C.CourseID
AND C.CourseName = 'Math 101'
WHERE C.CourseName IS NULL

/* 26.Using the Orders and Payments tables, write a query to return orders that are missing payment details.
🔁 Expected Output: OrderID, OrderDate, PaymentID*/

SELECT O.OrderID,
       O.OrderDate,
	     P.PaymentID
FROM Orders O
LEFT JOIN Payments P
ON O.OrderID = P.OrderID
WHERE P.PaymentID IS NULL 
ORDER BY O.OrderDate DESC


/* 27.Using the Products and Categories tables, write a query to list products that belong to either the 'Electronics' or 'Furniture' category.
🔁 Expected Output: ProductID, ProductName, CategoryName*/

SELECT P.ProductID,
       P.ProductName,
	     C.CategoryName
FROM Products P
JOIN Categories C
ON P.CategoryID = C.CategoryID
WHERE C.CategoryName IN ('Electronic', 'Furniture')
ORDER BY C.CategoryName, P.ProductName




