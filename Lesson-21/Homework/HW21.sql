
-- # Lesson 21  WINDOW FUNCTIONS

-- 1. Write a query to assign a row number to each sale based on the SaleDate.

SELECT *, ROW_NUMBER() OVER ( ORDER BY SaleDate) AS RowNumber FROM ProductSales

-- 2. Write a query to rank products based on the total quantity sold. give the same rank for the same amounts without skipping numbers.

SELECT SaleID, SUM(Quantity) AS TotalQuantity ,
       DENSE_RANK() OVER (ORDER BY SUM(Quantity) DESC) AS Ranking
FROM ProductSales 
GROUP BY SaleID
ORDER BY Ranking, SaleID 

-- 3. Write a query to identify the top sale for each customer based on the SaleAmount.

WITH CTE AS 
(
SELECT *, ROW_NUMBER() OVER (PARTITION BY CustomerID ORDER BY SaleAmount DESC) AS RankedSale FROM ProductSales
) 
SELECT * FROM CTE WHERE RankedSale = 1 ORDER BY CustomerID 

-- 4. Write a query to display each sale's amount along with the next sale amount in the order of SaleDate.

SELECT SaleID, SaleDate, LEAD(SaleAmount) OVER (ORDER BY SaleDate) AS LeadDate FROM ProductSales ORDER BY SaleDate 

-- 5. Write a query to display each sale's amount along with the previous sale amount in the order of SaleDate.

SELECT SaleID, SaleDate, SaleAmount, 
LAG(SaleAmount) OVER (ORDER BY SaleDate) AS PreviousSaleAmount 
FROM ProductSales	

-- 6. Write a query to identify sales amounts that are greater than the previous sale's amount
WITH PreviousSale As
(
SELECT SaleID, 
       SaleDate,
	     SaleAmount,
       LAG(SaleAmount) OVER (ORDER BY SaleDate DESC) AS GreaterAmount
FROM ProductSales
) 
SELECT SaleID, 
       SaleDate,
	     SaleAmount AS CurrentSaleAmount,
	     GreaterAmount
FROM PreviousSale
WHERE SaleAmount > GreaterAmount OR GreaterAmount IS NULL 
ORDER BY SaleDate

-- 7. Write a query to calculate the difference in sale amount from the previous sale for every product

SELECT 
    SaleID,
    SaleDate,
    SaleAmount AS CurrentSaleAmount,
    LAG(SaleAmount) OVER ( ORDER BY SaleDate) AS PreviousSaleAmount,
    SaleAmount - LAG(SaleAmount) OVER ( ORDER BY SaleDate) AS AmountDifference
FROM ProductSales
ORDER BY SaleID, SaleDate

-- 8. Write a query to compare the current sale amount with the next sale amount in terms of percentage change.

WITH SalesWithNext AS (
    SELECT 
        SaleID,
        SaleDate,
        SaleAmount AS CurrentAmount,
        LEAD(SaleAmount) OVER (ORDER BY SaleDate) AS NextAmount,
        LEAD(SaleDate) OVER (ORDER BY SaleDate) AS NextSaleDate
    FROM 
        ProductSales
)
SELECT 
    SaleID,
    SaleDate,
    CurrentAmount,
    NextSaleDate,
    NextAmount,
    CASE 
        WHEN NextAmount IS NULL THEN NULL
        ELSE ROUND(((NextAmount - CurrentAmount) * 100.0 / CurrentAmount), 2)
    END AS PercentageChange
FROM SalesWithNext
ORDER BY SaleID, SaleDate


-- 9. Write a query to calculate the ratio of the current sale amount to the previous sale amount within the same product.

WITH SalesWithPrevious AS (
    SELECT 
        SaleID,
        SaleDate,
        SaleAmount AS CurrentAmount,
        LAG(SaleAmount) OVER ( ORDER BY SaleDate) AS PreviousAmount
    FROM ProductSales
)
SELECT 
    SaleID,
    SaleDate,
    CurrentAmount,
    PreviousAmount,
    CASE 
        WHEN PreviousAmount IS NULL THEN NULL
        WHEN PreviousAmount = 0 THEN NULL  
        ELSE ROUND(CurrentAmount * 1.0 / PreviousAmount, 2)
    END AS AmountRatio
FROM SalesWithPrevious
ORDER BY SaleID, SaleDate


-- 10. Write a query to calculate the difference in sale amount from the very first sale of that product.

WITH FirstAmounts AS (
    SELECT SaleID,
	       SaleDate,
         FIRST_VALUE(SaleAmount) OVER ( ORDER BY SaleDate) AS FirstAmount
    FROM ProductSales
)
SELECT 
    P.SaleID,
    P.SaleDate,
    P.SaleAmount AS CurrentAmount,
    fa.FirstAmount,
    P.SaleAmount - fa.FirstAmount AS AmountDifferenceFromFirst
FROM ProductSales P
JOIN FirstAmounts fa ON P.SaleID = fa.SaleID
GROUP BY 
    P.SaleID,
    P.SaleDate,
    P.SaleAmount,
    fa.FirstAmount
ORDER BY P.SaleID, P.SaleDate


-- 11. Write a query to find sales that have been increasing continuously for a product 
(i.e., each sale amount is greater than the previous sale amount for that product).

WITH SalesWithTrend AS 
(
    SELECT SaleID,
           SaleDate,
           SaleAmount,
           LAG(SaleAmount) OVER (ORDER BY SaleDate) AS PrevAmount
    FROM ProductSales
)
SELECT  s.*,
        p.ProductName
FROM SalesWithTrend s
JOIN ProductSales p ON s.SaleID = p.SaleID
WHERE  s.PrevAmount IS NULL OR s.SaleAmount > s.PrevAmount  
ORDER BY s.SaleID, s.SaleDate 



--12. Write a query to calculate a "closing balance"(running total) for sales amounts which adds the current sale amount to a running total of previous sales.

SELECT 
    SaleID,
    SaleDate,
    SaleAmount,
    SUM(SaleAmount) OVER (ORDER BY SaleDate, SaleID) AS OverallRunningTotal,
    SUM(SaleAmount) OVER  (ORDER BY SaleDate) AS ProductRunningTotal,
    LAG(SaleDate) OVER (ORDER BY SaleDate) AS PreviousSaleDateForProduct
FROM ProductSales
ORDER BY SaleDate, SaleID


--13. Write a query to calculate the moving average of sales amounts over the last 3 sales.

SELECT SaleID,
       SaleDate,
	     SaleAmount,
	     AVG(SaleAmount) OVER (ORDER BY SaleDate ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) AS AVGSale
FROM ProductSales 
ORDER BY SaleDate


--14. Write a query to show the difference between each sale amount and the average sale amount.

SELECT SaleID,
       SaleDate,
	     SaleAmount AS CurrentSaleAmount,
	     AVG(SaleAmount) OVER () AS AVGSale,
	     SaleAmount - AVG(SaleAmount) OVER () AS DifferenceSaleAmount
FROM ProductSales
ORDER BY SaleID, SaleDate 


--15. Find Employees Who Have the Same Salary Rank

WITH RankedEmployees AS (
    SELECT 
        EmployeeID,
        Name,
        Salary,
        DENSE_RANK() OVER (ORDER BY Salary DESC) AS Rnk
    FROM Employees1
)
SELECT 
    Rnk,
    STRING_AGG(Name, ', ') AS employees_with_same_rank,
    COUNT(*) AS employee_count,
    Salary
FROM RankedEmployees
GROUP BY Rnk, Salary
HAVING COUNT(*) > 1
ORDER BY Rnk

--16. Identify the Top 2 Highest Salaries in Each Department

WITH CTE AS
(
SELECT EmployeeID,
       Name,
	     Department,
	     Salary,
	     ROW_NUMBER() OVER (PARTITION BY Department ORDER BY Salary DESC) AS TopSalary
FROM Employees1
)
SELECT * FROM CTE WHERE TopSalary <=2

--17. Find the Lowest-Paid Employee in Each Department

WITH CTE AS
(
SELECT EmployeeID,
       Name,
	     Department,
	     Salary,
	     ROW_NUMBER() OVER (PARTITION BY Department ORDER BY Salary ASC) AS LowestSalary
FROM Employees1
)
SELECT * FROM CTE WHERE LowestSalary = 1


--18. Calculate the Running Total of Salaries in Each Department

SELECT EmployeeID,
       Name,
	     Salary, 
	     SUM(Salary) OVER (ORDER BY EmployeeID
	                       ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS TotalRunSalary
FROM Employees1
ORDER BY EmployeeID, HireDate 


--19. Find the Total Salary of Each Department Without GROUP BY

SELECT DISTINCT EmployeeID,
       Name,
	     Salary,
	     Department,
	     SUM(Salary) OVER (PARTITION BY Department) AS TotalSalary
FROM Employees1
ORDER BY Department 


--20. Calculate the Average Salary in Each Department Without GROUP BY

SELECT DISTINCT 
       EmployeeID,
       Name,
	     Salary,
	     Department,
	     AVG(Salary) OVER (PARTITION BY Department) AS AVGSalary
FROM Employees1
ORDER BY Department 


--21. Find the Difference Between an Employee’s Salary and Their Department’s Average

SELECT EmployeeID,
       Name,
	     Salary,
	     Department,
	     AVG(Salary) OVER (PARTITION BY Department) AS AVGSalary,
	     Salary - AVG(Salary) OVER (PARTITION BY Department) AS SalaryDifference
FROM Employees1
ORDER BY Department 


--22. Calculate the Moving Average Salary Over 3 Employees (Including Current, Previous, and Next)

SELECT EmployeeID,
       Name,
	     Salary,
	     Department,
	     AVG(Salary) OVER (ORDER BY EmployeeID 
	                       ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING) AS MovingAVGSalary
FROM Employees1
ORDER BY EmployeeID


--23. Find the Sum of Salaries for the Last 3 Hired Employees

;WITH CTE AS 
(
SELECT EmployeeID,
       Name, 
	     Salary, 
	     HireDate,
	     DENSE_RANK() OVER (ORDER BY HireDate DESC) AS HireRnk
FROM Employees1
)
SELECT SUM(Salary) AS SumL3Salary FROM CTE WHERE HireRnk <= 3
