 
 -- Homework_9
 
 
 -- Easy-Level Tasks (10)
 -- Easy (10 puzzles)
--1.Using Products, Suppliers table List all combinations of product names and supplier names.

SELECT  P.ProductName, S.SupplierName
FROM Products P
CROSS JOIN Suppliers S

--2.Using Departments, Employees table Get all combinations of departments and employees.

SELECT D.DepartmentID, E.EmployeeID
FROM Departments D
CROSS JOIN Employees E

--3.Using Products, Suppliers table List only the combinations where the supplier actually supplies the product. Return supplier name and product name

SELECT P.ProductName, S.SupplierName 
FROM Products P
JOIN Suppliers S
ON P.SupplierID = S.SupplierID 
ORDER BY P.ProductName, S.SupplierName

--4.Using Orders, Customers table List customer names and their orders ID.

SELECT C.FirstName AS Customer_Name, O.OrderID AS Orders_ID  
FROM Orders O
JOIN Customers C
ON O.CustomerID = C.CustomerID 
ORDER BY C.FirstName, O.OrderID  

--5.Using Courses, Students table Get all combinations of students and courses.

SELECT C.CourseName AS Course_Name, S.Name AS Student_Name 
FROM Courses C
CROSS JOIN Students S
ORDER BY Course_Name, Student_Name

--6.Using Products, Orders table Get product names and orders where product IDs match.

SELECT
    P.ProductName,
    O.OrderID,
    O.OrderDate,
    O.Quantity,
    O.TotalAmount
FROM Products P
INNER JOIN Orders O ON P.ProductID = O.ProductID
ORDER BY P.ProductName, O.OrderDate DESC

--7.Using Departments, Employees table List employees whose DepartmentID matches the department.

SELECT E.Name, D.DepartmentName 
FROM Employees E
JOIN Departments D 
ON E.DepartmentID = D.DepartmentID
ORDER BY D.DepartmentName


--8.Using Students, Enrollments table List student names and their enrolled course IDs.

SELECT S.Name, E.CourseID FROM Enrollments E
JOIN Students S
ON E.StudentID = S.StudentID 
ORDER BY   S.Name
 
-- 9.Using Payments, Orders table List all orders that have matching payments.

SELECT O.OrderID,
       O.OrderDate,
	     O.TotalAmount,
	     P.PaymentDate,
	     P.Amount,
	     P.PaymentMethod
FROM Orders O
LEFT JOIN Payments P
ON O.OrderID = P.OrderID
ORDER BY O.OrderID DESC  

--10.Using Orders, Products table Show orders where product price is more than 100.

SELECT O.ProductID, P.Price FROM Orders O
JOIN Products P
ON O.ProductID = P.ProductID
WHERE P.Price > 100

-- Medium (10 puzzles)
--11.Using Employees, Departments table List employee names and department names where department IDs are not equal. It means: Show all mismatched employee-department combinations.

SELECT E.Name, D.DepartmentName 
FROM Employees E
CROSS JOIN Departments D
WHERE E.DepartmentID <> D.DepartmentID
ORDER BY E.Name, D.DepartmentName


--12.Using Orders, Products table Show orders where ordered quantity is greater than stock quantity.

SELECT O.OrderID, 
       O.Quantity,
       P.ProductID,
	     P.StockQuantity
FROM Orders O
JOIN Products P
ON O.ProductID = P.ProductID
WHERE P.StockQuantity > O.Quantity
ORDER BY O.Quantity, P.StockQuantity DESC


--13.Using Customers, Sales table List customer names and product IDs where sale amount is 500 or more.

SELECT S.ProductID, 
       S.CustomerID,
	     S.SaleDate,
	     S.SaleAmount,
	     C.FirstName,
	     C.LastName
FROM Sales S
JOIN Customers C
ON S.CustomerID = C.CustomerID
WHERE SaleAmount >= 500
ORDER BY S.ProductID, C.FirstName, C.LastName

--14.Using Courses, Enrollments, Students table List student names and course names they’re enrolled in.
 
SELECT S.Name AS StudentName, C.CourseName 
FROM Students S
JOIN Enrollments E
ON S.StudentID = E.StudentID
JOIN Courses C
ON E.CourseID = C.CourseID
ORDER BY S.Name, C.CourseName 

--15.Using Products, Suppliers table List product and supplier names where supplier name contains “Tech”.

SELECT S.SupplierID,
       S.SupplierName,
       P.ProductID,
	     P.ProductName
FROM Suppliers S
JOIN Products P
ON S.SupplierID = P.SupplierID
WHERE SupplierName LIKE '%Tech%'
ORDER BY SupplierName

--16.Using Orders, Payments table Show orders where payment amount is less than total amount.

SELECT O.OrderID,
	     O.TotalAmount,
	     SUM(P.Amount) AS PaymentAmount
FROM Orders O
LEFT JOIN Payments P
ON O.OrderID = P.OrderID
GROUP BY O.OrderID, O.TotalAmount
HAVING SUM(P.Amount) < O.TotalAmount or SUM(P.Amount) IS NULL 

--17.Using Employees table List employee names with salaries greater than their manager’s salary.

SELECT E.Name AS Employee, 
       E.Salary AS Employee_Salary,
	     M.Name AS Manager,
	     M.Salary AS Manager_Salary
FROM Employees E
JOIN Employees M  
ON E.ManagerID = M.EmployeeID
WHERE E.Salary > M.Salary
ORDER BY E.Salary, M.Salary DESC 

--18.Using Products, Categories table Show products where category is either 'Electronics' or 'Furniture'.

SELECT P.ProductID,
       P.ProductName,
	     C.CategoryName
FROM Products P
JOIN Categories C
ON P.Category = C.CategoryID
WHERE CategoryName = 'Electronics' or CategoryName = 'Furniture' 

--19.Using Sales, Customers table Show all sales from customers who are from 'USA'.

SELECT S.SaleID,
       S.SaleDate,
	     S.SaleAmount,
       C.FirstName,
	     C.Country
FROM Sales S
LEFT JOIN Customers C
ON S.CustomerID = C.CustomerID
WHERE Country = 'USA' 
ORDER BY S.SaleDate DESC 

--20.Using Orders, Customers table List orders made by customers from 'Germany' and order total > 100.

SELECT O.OrderID,
       O.OrderDate,
	     O.TotalAmount,
	     C.CustomerID,
	     C.FirstName,
	     C.Country
FROM Orders O
JOIN Customers C
ON O.CustomerID = C.CustomerID 
WHERE Country = 'Germany' and TotalAmount > 100
ORDER BY O.OrderDate DESC

-- Hard (5 puzzles)
--21.Using Employees table List all pairs of employees from different departments.

SELECT 
    E1.EmployeeID AS emp1_id,
    E1.Name AS emp1_name,
    E1.DepartmentID AS emp1_dept,
    E2.EmployeeID AS emp2_id,
    E2.Name AS emp2_name,
    E2.DepartmentID AS emp2_dept
FROM Employees E1
JOIN Employees E2 
ON E1.DepartmentID <> E2.DepartmentID
   AND E1.EmployeeID < E2.EmployeeID  
ORDER BY E1.DepartmentID, E2.DepartmentID

--22.Using Payments, Orders, Products table List payment details where the paid amount is not equal to (Quantity × Product Price).

SELECT PA.PaymentID,
       PA.OrderID,
	     PA.Amount,
	     O.OrderID,
	     O.Quantity,
	     PRO.ProductName,
	     PRO.Price,
	     (O.Quantity * PRO.Price) AS ExpaectedAmount,
	     (PA.Amount -(O.Quantity * PRO.Price)) AS [Difference]
FROM Payments PA
JOIN Orders O
ON PA.OrderID = O.OrderID
JOIN Products PRO 
ON O.ProductID = PRO.ProductID
WHERE PA.Amount <> (O.Quantity * PRO.Price)
ORDER BY (PA.Amount - (O.Quantity * PRO.Price)) DESC

--23.Using Students, Enrollments, Courses table Find students who are not enrolled in any course.

SELECT S.StudentID,
       S.Name,
       E.EnrollmentID,
       C.CourseID,
       C.CourseName  
FROM Students S
JOIN Enrollments E 
ON S.StudentID = E.StudentID
JOIN Courses C 
ON E.CourseID = C.CourseID
WHERE S.StudentID <> C.CourseID  


--24.Using Employees table List employees who are managers of someone, but their salary is less than or equal to the person they manage.

SELECT M.ManagerID, 
       M.Name AS Manager,
  	   M.Salary AS ManagerSalary,
  	   E.EmployeeID,
	     E.Name AS Employee,
	     E.Salary AS EmployeeSalary
FROM Employees M 
JOIN Employees E 
ON M.ManagerID = E.EmployeeID
WHERE M.Salary <= E.Salary
ORDER BY E.Salary - M.Salary DESC

--25.Using Orders, Payments, Customers table List customers who have made an order, but no payment has been recorded for it.

SELECT C.CustomerID,
       C.FirstName,
  	   O.OrderID,
  	   O.OrderDate,
	     O.TotalAmount,
	     P.PaymentID
FROM Orders O
JOIN Customers C
ON O.CustomerID = C.CustomerID
LEFT JOIN Payments P
ON O.OrderID = P.OrderID
WHERE P.PaymentID IS NULL
ORDER BY O.OrderDate DESC, C.FirstName



