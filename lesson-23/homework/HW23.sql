
/* Lesson_23 
## SQL Puzzle Questions with Input and Output Tables
### Puzzle 1: In this puzzle you have to extract the month from the dt column and then 
append zero single digit month if any. Please check out sample input and expected output.*/

SELECT 
    Id,
    Dt,
    RIGHT('0' + CAST(MONTH(Dt) AS VARCHAR), 2) AS MonthPrefixedWithZero
FROM Dates


--### Puzzle 2: In this puzzle you have to find out the unique Ids present in the table. You also have to find out the SUM of Max values of vals columns for each Id and RId. For more details please see the sample input and expected output.

SELECT 
    COUNT(DISTINCT Id) AS Distinct_Ids,
    rID,
    SUM(MaxVal) AS TotalOfMaxVals
FROM (
    SELECT 
        Id, 
        rID, 
        MAX(Vals) AS MaxVal
    FROM MyTabel
    GROUP BY Id, rID
) AS Sub
GROUP BY rID;


--### Puzzle 3: In this puzzle you have to get records with at least 6 characters and maximum 10 characters. Please see the sample input and expected output.

SELECT *
FROM TestFixLengths
WHERE 
    Vals IS NOT NULL
    AND Vals <> ''
    AND LEN(Vals) <= 10;


--### Puzzle 4: In this puzzle you have to find the maximum value for each Id and then get the Item for that Id and Maximum value. Please check out sample input and expected output.

SELECT ID, Item, Vals
FROM (
    SELECT *,
           ROW_NUMBER() OVER (PARTITION BY ID ORDER BY Vals DESC) AS rn
    FROM TestMaximum
) AS ranked
WHERE rn = 1;


--### Puzzle 5: In this puzzle you have to first find the maximum value for each Id and DetailedNumber, and then Sum the data using Id only. Please check out sample input and expected output.

SELECT 
    Id,
    SUM(MaxVals) AS SumofMax
FROM (
    SELECT 
        Id,
        DetailedNumber,
        MAX(Vals) AS MaxVals
    FROM SumOfMax
    GROUP BY Id, DetailedNumber
) AS Sub
GROUP BY Id


--### Puzzle 6: In this puzzle you have to find difference between a and b column between each row and if the difference is not equal to 0 then show the difference i.e. a – b otherwise 0. Now you need to replace this zero with blank.Please check the sample input and the expected output.

SELECT 
    Id,
    a,
    b,
    CASE 
        WHEN a <> b THEN a - b
        ELSE NULL
    END AS OUTPUT
FROM TheZeroPuzzle;


--7. What is the total revenue generated from all sales?  

SELECT SUM(QuantitySold * UnitPrice) AS TotalRevenue
FROM Sales

--8. What is the average unit price of products?  

SELECT AVG(UnitPrice) AS AverageUnitPrice
FROM Sales

--9. How many sales transactions were recorded?  

SELECT COUNT(*) AS TotalTransactions
FROM Sales



--10. What is the highest number of units sold in a single transaction?  

SELECT MAX(QuantitySold) AS MaxUnitsSold
FROM Sales

--11. How many products were sold in each category? 

SELECT Category, SUM(QuantitySold) AS TotalUnitsSold
FROM Sales
GROUP BY Category

--12. What is the total revenue for each region?  

SELECT 
    Region, 
    SUM(QuantitySold * UnitPrice) AS TotalRevenue
FROM 
    Sales
GROUP BY 
    Region


--13. Which product generated the highest total revenue?  

SELECT TOP 1
    Product,
    SUM(QuantitySold * UnitPrice) AS TotalRevenue
FROM Sales
GROUP BY Product
ORDER BY TotalRevenue DESC


--14. Compute the running total of revenue ordered by sale date.  

SELECT 
    SaleDate,
    Product,
    QuantitySold,
    UnitPrice,
    QuantitySold * UnitPrice AS Revenue,
    SUM(QuantitySold * UnitPrice) OVER (ORDER BY SaleDate) AS RunningTotalRevenue
FROM 
    Sales
ORDER BY 
    SaleDate



--15. How much does each category contribute to total sales revenue?  

SELECT 
    Category,
    SUM(QuantitySold * UnitPrice) AS TotalRevenue
FROM 
    Sales
GROUP BY 
    Category


--17. Show all sales along with the corresponding customer names  

SELECT 
    S.SaleID,
    S.SaleDate,
    S.Product,
    S.Category,
    S.QuantitySold,
    S.UnitPrice,
    C.CustomerName,
    C.Region AS CustomerRegion
FROM 
    Sales S
JOIN 
    Customers C ON S.CustomerID = C.CustomerID
ORDER BY 
    S.SaleDate


--18. List customers who have not made any purchases  

SELECT 
    C.CustomerID,
    C.CustomerName,
    C.Region,
    C.JoinDate
FROM 
    Customers C
LEFT JOIN 
    Sales S ON C.CustomerID = S.CustomerID
WHERE 
    S.CustomerID IS NULL



--19. Compute total revenue generated from each customer  

SELECT 
    C.CustomerID,
    C.CustomerName,
    SUM(S.QuantitySold * S.UnitPrice) AS TotalRevenue
FROM 
    Sales S
JOIN 
    Customers C ON S.CustomerID = C.CustomerID
GROUP BY 
    C.CustomerID, C.CustomerName
ORDER BY 
    TotalRevenue DESC


--20. Find the customer who has contributed the most revenue  

SELECT TOP 1
    C.CustomerID,
    C.CustomerName,
    SUM(S.QuantitySold * S.UnitPrice) AS TotalRevenue
FROM 
    Sales S
JOIN 
    Customers C ON S.CustomerID = C.CustomerID
GROUP BY 
    C.CustomerID, C.CustomerName
ORDER BY 
    TotalRevenue DESC


	--21. Calculate the total sales per customer

SELECT 
    C.CustomerID,
    C.CustomerName,
    COUNT(S.SaleID) AS NumberOfSales,
    SUM(S.QuantitySold * S.UnitPrice) AS TotalSalesAmount
FROM 
    Customers C
JOIN 
    Sales S ON C.CustomerID = S.CustomerID
GROUP BY 
    C.CustomerID, C.CustomerName
ORDER BY 
    TotalSalesAmount DESC


--22. List all products that have been sold at least once  

SELECT DISTINCT 
    P.ProductID,
    P.ProductName,
    P.Category,
    P.CostPrice,
    P.SellingPrice
FROM 
    Products P
JOIN 
    Sales S ON P.ProductName = S.Product


--23. Find the most expensive product in the Products table  

SELECT TOP 1 
    ProductID,
    ProductName,
    Category,
    CostPrice,
    SellingPrice
FROM 
    Products
ORDER BY 
    SellingPrice DESC;


--24. Find all products where the selling price is higher than the average selling price in their category  

SELECT 
    P.ProductID,
    P.ProductName,
    P.Category,
    P.SellingPrice,
    AvgCat.AvgSellingPrice
FROM 
    Products P
JOIN 
    (
        SELECT 
            Category, 
            AVG(SellingPrice) AS AvgSellingPrice
        FROM 
            Products
        GROUP BY 
            Category
    ) AS AvgCat ON P.Category = AvgCat.Category
WHERE 
    P.SellingPrice > AvgCat.AvgSellingPrice


