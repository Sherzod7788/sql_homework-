-- # Lesson-16: CTEs and Derived Tables

-- # Easy Tasks

-- 1. Create a numbers table using a recursive query from 1 to 1000.

;WITH numbers AS 
(
    SELECT 1 AS n
    UNION ALL
    SELECT n + 1
    FROM numbers
    WHERE n < 1000
)
SELECT n
FROM numbers
ORDER BY n


-- 2. Write a query to find the total sales per employee using a derived table.(Sales, Employees)

SELECT 
    e.EmployeeID,
    e.FirstName,
    e.LastName,
    emp_sales.total_sales_amount,
    emp_sales.total_sales_count
FROM Employees e
JOIN (
        SELECT 
        EmployeeID,
        SUM(SalesAmount) AS total_sales_amount,
        COUNT(SalesID) AS total_sales_count
    FROM Sales
    GROUP BY EmployeeID
) AS emp_sales ON e.EmployeeID = emp_sales.EmployeeID
ORDER BY emp_sales.total_sales_amount DESC


-- 3. Create a CTE to find the average salary of employees.(Employees)

;WITH AVGSalary AS 
(
       SELECT AVG(Salary) AS AVG_Salary
	   FROM Employees
)
SELECT 
    e.EmployeeID,
    e.FirstName,
    e.LastName,
    e.Salary,
    eas.AVG_Salary,
    e.Salary - eas.AVG_Salary AS difference_from_avg
FROM Employees e
CROSS JOIN AvgSalary eas
ORDER BY difference_from_avg DESC


-- 4. Write a query using a derived table to find the highest sales for each product.(Sales, Products)

SELECT P.ProductID,
       P.ProductName,
	   MaxSales.MaxSaleAmount AS HighestSaleAmount
FROM Products P
JOIN (    SELECT ProductID,
          MAX(SalesAmount) AS MaxSaleAmount
		  FROM Sales
		  GROUP BY ProductID 
     ) AS MaxSales ON P.ProductID = MaxSales.ProductID
ORDER BY MaxSales.MaxSaleAmount

-- 5. Beginning at 1, write a statement to double the number for each record, the max value you get should be less than 1000000.

;WITH nums AS 
(
     SELECT 1 AS N
	 UNION ALL
	 SELECT N * 2
	 FROM nums
	 WHERE N *2 < 1000000
)
SELECT N
FROM nums
ORDER BY N 


-- 6. Use a CTE to get the names of employees who have made more than 5 sales.(Sales, Employees)

;WITH EmployeeSales AS 
(
    SELECT E.EmployeeID,
	       E.FirstName,
		   E.LastName,
	       COUNT(S.SalesID) AS TotalSales
	FROM Employees E
	JOIN Sales S ON E.EmployeeID = S.EmployeeID
	GROUP BY E.EmployeeID, E.FirstName, E.LastName
) 
SELECT EmployeeID,
       FirstName,
	   LastName,
	   TotalSales
FROM EmployeeSales
WHERE TotalSales > 5
ORDER BY TotalSales DESC


-- 7. Write a query using a CTE to find all products with sales greater than $500.(Sales, Products)

;WITH ExpenciveProducts AS
(
       SELECT P.ProductID, P.ProductName, SUM(S.SalesAmount) AS TotalSales
	   FROM Products P
	   JOIN Sales S ON P.ProductID = S.ProductID
	   GROUP BY P.ProductID, P.ProductName
	   HAVING SUM(S.SalesAmount) > 500
)
SELECT ProductID, ProductName, TotalSales
FROM ExpenciveProducts
ORDER BY TotalSales DESC 


-- 8. Create a CTE to find employees with salaries above the average salary.(Employees)

;WITH CompanyAverage AS
(
        SELECT AVG(salary) AS avg_salary
        FROM Employees
)
SELECT 
    E.EmployeeID,
    E.FirstName,
    E.LastName,
    E.Salary,
    ROUND(ca.avg_salary, 2) AS company_avg_salary,
    ROUND(e.salary - ca.avg_salary, 2) AS above_avg_by
FROM Employees E
CROSS JOIN CompanyAverage ca
WHERE E.salary > ca.avg_salary
ORDER BY above_avg_by DESC



-- Medium Tasks
-- 1. Write a query using a derived table to find the top 5 employees by the number of orders made.(Employees, Sales)

SELECT E.EmployeeID,
       E.FirstName, 
	   E.LastName,
	   OrderCount.OrderCnt
FROM Employees E
JOIN (   SELECT TOP 5 EmployeeID, COUNT(*) AS OrderCnt
         FROM Sales
		 GROUP BY EmployeeID
		 ORDER BY OrderCnt DESC
	) AS OrderCount ON E.EmployeeID = OrderCount.EmployeeID
ORDER BY OrderCount.OrderCnt DESC 

-- 2. Write a query using a derived table to find the sales per product category.(Sales, Products)

SELECT PCategory,
       TotalSales,
       NumofSales 
FROM (
       SELECT 
            P.CategoryID AS PCategory,
            SUM(SalesAmount) AS TotalSales,
		    COUNT(DISTINCT S.SalesID) AS NumofSales
        FROM Sales S
        JOIN Products P ON S.ProductID = P.ProductID
        GROUP BY P.CategoryID
) AS CategorySale
ORDER BY TotalSales DESC


-- 3. Write a script to return the factorial of each value next to it.(Numbers1)

SELECT 
    n.number,
    ROUND(EXP(SUM(LOG(n2.number))), 0) AS factorial
FROM Numbers1 n
CROSS APPLY (
    SELECT number 
    FROM Numbers1 n2 
    WHERE n2.number > 0 AND n2.number <= n.number
) n2
GROUP BY n.number
ORDER BY n.number

-- 4. This script uses recursion to split a string into rows of substrings for each character in the string.(Example)

WITH SplitString AS (
        SELECT 
        1 AS position,
        SUBSTRING('Hello', 1, 1) AS character,
        'Hello' AS original_string
    UNION ALL
    SELECT 
        position + 1,
        SUBSTRING(original_string, position + 1, 1),
        original_string
    FROM SplitString
    WHERE position < LEN(original_string)  
)
SELECT 
    position,
    character
FROM SplitString
OPTION (MAXRECURSION 100)  


-- 5. Use a CTE to calculate the sales difference between the current month and the previous month.(Sales)

WITH MonthlySales AS 
(
    SELECT 
        YEAR(SaleDate) AS year,
        MONTH(SaleDate) AS month,
        SUM(SalesAmount) AS total_sales
    FROM Sales
    GROUP BY YEAR(SaleDate), MONTH(SaleDate)
),
SalesWithPrevious AS 
(
    SELECT
        year,
        month,
        total_sales,
        LAG(total_sales) OVER (ORDER BY year, month) AS previous_month_sales
    FROM MonthlySales
)
SELECT
    year,
    month,
    total_sales AS current_month_sales,
    previous_month_sales,
    total_sales - previous_month_sales AS sales_difference,
    CASE 
        WHEN previous_month_sales IS NULL THEN NULL
        ELSE ROUND((total_sales - previous_month_sales) * 100.0 / previous_month_sales, 2)
    END AS percentage_change
FROM SalesWithPrevious
ORDER BY year, month

-- 6. Create a derived table to find employees with sales over $45000 in each quarter.(Sales, Employees)

SELECT 
    e.EmployeeID,
    e.FirstName,
    e.LastName,
    q.quarter,
    q.quarterly_sales
FROM Employees e
JOIN (
    SELECT 
        EmployeeID,
        DATEPART(QUARTER, SaleDate) AS quarter,
        SUM(SalesAmount) AS quarterly_sales
    FROM Sales
    WHERE YEAR(SaleDate) = YEAR(GETDATE()) 
    GROUP BY EmployeeID, DATEPART(QUARTER, SaleDate)
    HAVING SUM(SalesAmount) > 45000
) AS q ON e.EmployeeID = q.EmployeeID
ORDER BY e.LastName, e.FirstName, q.quarter


--# Difficult Tasks
--1. This script uses recursion to calculate Fibonacci numbers

WITH Numbers AS (
    SELECT TOP 20
        ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) - 1 AS n
    FROM sys.objects a
    CROSS JOIN sys.objects b
),
Fibonacci AS (
    SELECT 
        n,
        CAST(ROUND(
            (POWER((1 + SQRT(5)) / 2, n) - POWER((1 - SQRT(5)) / 2, n)) / SQRT(5), 
            0
        ) AS INT) AS fib_number
    FROM Numbers
)
SELECT 
    n AS position,
    fib_number
FROM Fibonacci
ORDER BY n


--2. Find a string where all characters are the same and the length is greater than 1.(FindSameCharacters)

SELECT  Vals
FROM FindSameCharacters
WHERE LEN(Vals) > 1  -- Length greater than 1
AND REPLICATE(LEFT(Vals, 1), LEN(Vals)) = Vals


--3.Create a numbers table that shows all numbers 1 through n and their order gradually increasing by the next number in the sequence.(Example:n=5 | 1, 12, 123, 1234, 12345)

;WITH Numbers1 AS 
(
       SELECT 
        1 AS n,
        CAST('1' AS VARCHAR(100)) AS sequence
        UNION ALL
        SELECT 
        n + 1,
        CAST(CONCAT(sequence, n + 1) AS VARCHAR(100))
    FROM Numbers1
    WHERE n < 5 
)
SELECT 
    n,
    sequence
FROM Numbers1
ORDER BY n


--4. Write a query using a derived table to find the employees who have made the most sales in the last 6 months.(Employees,Sales)

SELECT E.EmployeeID,
       E.FirstName,
	   E.LastName,
	   recent_sales.sales_count,
       recent_sales.total_sales_amount
FROM Employees E
JOIN (   SELECT 
        S.EmployeeID,
        COUNT(*) AS sales_count,
        SUM(SalesAmount) AS total_sales_amount
    FROM Sales S
    WHERE S.SaleDate >= DATEADD(month, -6, GETDATE()) 
    GROUP BY s.EmployeeID
) AS recent_sales ON E.EmployeeID = recent_sales.EmployeeID
ORDER BY recent_sales.sales_count DESC, recent_sales.total_sales_amount DESC
 

--5. Write a T-SQL query to remove the duplicate integer values present in the string column. Additionally, remove the single integer character that appears in the string.(RemoveDuplicateIntsFromNames)

 ;WITH SplitValues AS (
    SELECT
        PawanName,
        TRIM(value) AS IntVal
    FROM RemoveDuplicateIntsFromNames
    CROSS APPLY STRING_SPLIT(Pawan_slug_name, ' ')
), Filtered AS (
    SELECT
        PawanName,
        IntVal
    FROM SplitValues
    WHERE ISNUMERIC(IntVal) = 1
      AND LEN(IntVal) > 1  
), DistinctValues AS (
    SELECT DISTINCT
        PawanName,
        IntVal
    FROM Filtered
)
SELECT
    PawanName,
    STRING_AGG(IntVal, ' ') AS CleanedString
FROM DistinctValues
GROUP BY PawanName

 























