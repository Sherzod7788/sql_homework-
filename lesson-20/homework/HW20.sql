
--# Lesson-20: Practice

--# 1. Find customers who purchased at least one item in March 2024 using EXISTS

SELECT DISTINCT s1.CustomerName
FROM #Sales s1
WHERE EXISTS (
    SELECT 1
    FROM #Sales s2
    WHERE s2.CustomerName = s1.CustomerName
      AND s2.SaleDate >= '2024-03-01'
      AND s2.SaleDate < '2024-04-01'
)

--# 2. Find the product with the highest total sales revenue using a subquery.

SELECT Product, SUM(Quantity * Price) AS TotalRevenue
FROM #Sales
GROUP BY Product
HAVING SUM(Quantity * Price) = (
    SELECT MAX(TotalRev)
    FROM (
        SELECT SUM(Quantity * Price) AS TotalRev
        FROM #Sales
        GROUP BY Product
    ) AS RevenueByProduct
)

--# 3. Find the second highest sale amount using a subquery

SELECT MAX(Quantity * Price) AS MaxAmount
FROM #Sales
WHERE (Quantity * Price) < (SELECT MAX(Quantity * Price) 
FROM #Sales) 


--# 4. Find the total quantity of products sold per month using a subquery

SELECT 
    SaleMonth,
    SUM(MonthlyQuantity) AS TotalQuantitySold
FROM (
    SELECT 
        FORMAT(SaleDate, 'yyyy-MM') AS SaleMonth,
        Quantity AS MonthlyQuantity
    FROM #Sales
) AS MonthlyData
GROUP BY SaleMonth
ORDER BY SaleMonth


select * from #Sales
--# 5. Find customers who bought same products as another customer using EXISTS

SELECT DISTINCT s1.CustomerName
FROM #Sales s1
WHERE EXISTS (
    SELECT 1
    FROM #Sales s2
    WHERE s2.Product = s1.Product
      AND s2.CustomerName <> s1.CustomerName
);


--# 6. Return how many fruits does each person have in individual fruit level

SELECT 
    Name,
    COUNT(CASE WHEN Fruit = 'Apple' THEN 1 END) AS Apple,
    COUNT(CASE WHEN Fruit = 'Orange' THEN 1 END) AS Orange,
    COUNT(CASE WHEN Fruit = 'Banana' THEN 1 END) AS Banana
FROM Fruits
GROUP BY Name
ORDER BY Name

**Expected Output**
```
+-----------+-------+--------+--------+
| Name      | Apple | Orange | Banana |
+-----------+-------+--------+--------+
| Francesko |   3   |   2    |   1    |
| Li        |   2   |   1    |   1    |
| Mario     |   3   |   1    |   2    |
+-----------+-------+--------+--------+


--# 7. Return older people in the family with younger ones

WITH FamilyTree AS (
    SELECT ParentID, ChildID
    FROM Family
    UNION ALL
    SELECT f.ParentID, ft.ChildID
    FROM Family f
    JOIN FamilyTree ft ON f.ChildID = ft.ParentID
)
SELECT * FROM FamilyTree
ORDER BY ParentID, ChildID


select * from Family
**1 Oldest person in the family --grandfather**
**2 Father**
**3 Son**
**4 Grandson**

**Expected output**
```
+-----+-----+
| PID |CHID |
+-----+-----+
|  1  |  2  |
|  1  |  3  |
|  1  |  4  |
|  2  |  3  |
|  2  |  4  |
|  3  |  4  |
+-----+-----+

```

--# 8. Write an SQL statement given the following requirements. For every customer that had 
a delivery to California, provide a result set of the customer orders that were delivered to Texas


SELECT *
FROM #Orders
WHERE DeliveryState = 'TX'
  AND CustomerID IN (
      SELECT DISTINCT CustomerID
      FROM #Orders
      WHERE DeliveryState = 'CA')


--# 9. Insert the names of residents if they are missing

UPDATE #residents
SET fullname = 
    SUBSTRING(
        address, 
        CHARINDEX('name=', address) + 5, 
        CHARINDEX(' ', address + ' ', CHARINDEX('name=', address)) - CHARINDEX('name=', address) - 5
    )
WHERE fullname IS NULL 
  AND address LIKE '%name=%'


--# 10. Write a query to return the route to reach from Tashkent to Khorezm. The result 
should include the cheapest and the most expensive routes

WITH RoutePaths AS (
    SELECT 
        CAST(DepartureCity + ' - ' + ArrivalCity AS VARCHAR(MAX)) AS Route,
        ArrivalCity,
        Cost
    FROM #Routes
    WHERE DepartureCity = 'Tashkent'
    UNION ALL
    SELECT 
        CAST(rp.Route + ' - ' + r.ArrivalCity AS VARCHAR(MAX)) AS Route,
        r.ArrivalCity,
        rp.Cost + r.Cost AS Cost
    FROM RoutePaths rp
    JOIN #Routes r
        ON rp.ArrivalCity = r.DepartureCity
        AND CHARINDEX(r.ArrivalCity, rp.Route) = 0 -- avoid cycles
)
SELECT TOP 1 WITH TIES 'Cheapest' AS Type, Route, Cost
FROM RoutePaths
WHERE ArrivalCity = 'Khorezm'
ORDER BY Cost ASC
UNION ALL
SELECT TOP 1 WITH TIES 'Most Expensive' AS Type, Route, Cost
FROM RoutePaths
WHERE ArrivalCity = 'Khorezm'
ORDER BY Cost DESC


**Expected Output**
```
|             Route                                 |Cost |
|Tashkent - Samarkand - Khorezm                     | 500 |
|Tashkent - Jizzakh - Samarkand - Bukhoro - Khorezm | 650 |
```

--# 11. Rank products based on their order of insertion.

SELECT 
    ID,
    Vals,
    ROW_NUMBER() OVER (ORDER BY ID) AS InsertionRank
FROM #RankingPuzzle



--# Question 12
--# Find employees whose sales were higher than the average sales in their department

SELECT 
    EmployeeID,
    EmployeeName,
    Department,
    SalesAmount,
    SalesMonth,
    SalesYear
FROM #EmployeeSales e
WHERE SalesAmount > (
    SELECT AVG(SalesAmount)
    FROM #EmployeeSales
    WHERE Department = e.Department
      AND SalesYear = e.SalesYear
);


# 13. Find employees who had the highest sales in any given month using EXISTS

SELECT e.EmployeeID, e.EmployeeName, e.Department, e.SalesAmount, e.SalesMonth, e.SalesYear
FROM #EmployeeSales e
WHERE NOT EXISTS (
    SELECT 1
    FROM #EmployeeSales e2
    WHERE e2.SalesYear = e.SalesYear
      AND e2.SalesMonth = e.SalesMonth
      AND e2.SalesAmount > e.SalesAmount )
	

# 14. Find employees who made sales in every month using NOT EXISTS

WITH AllMonths AS (
    SELECT DISTINCT SalesMonth FROM Products
)
SELECT DISTINCT P1.ProductID
FROM Products P1
WHERE NOT EXISTS (
    SELECT 1
    FROM AllMonths M
    WHERE NOT EXISTS (
        SELECT 1
        FROM Products P2
        WHERE P2.ProductID = P1.ProductID
        AND P2.SalesMonth = M.SalesMonth
    )
);



-- # 15. Retrieve the names of products that are more expensive than the average price of
all products.

WITH CTE AS 
(
SELECT AVG(Price) AS AvgPrice 
FROM Products 
) 
SELECT [Name] FROM Products, CTE WHERE Products.Price > CTE.AvgPrice 


--# 16. Find the products that have a stock count lower than the highest stock count.

WITH CTE AS 
(
SELECT MAX(Stock) AS MaxStock 
FROM Products 
)
SELECT *
FROM Products, CTE
WHERE Products.Stock < CTE.Stock 


--# 17. Get the names of products that belong to the same category as 'Laptop'.

SELECT * FROM Products 
WHERE Category = (
         SELECT Category
		 FROM Products
		 WHERE Name = 'Laptop' )  


-- 18. Retrieve products whose price is greater than the lowest price in the Electronics category.

SELECT * FROM Products 
WHERE Price > (  
         SELECT MIN(Price) AS LowestPrice
		 FROM Products 
		 WHERE Category= 'Electronics')



--# 19. Find the products that have a higher price than the average price of their 
respective category.

WITH Category AS 
(
SELECT Category, 
       AVG(Price) AS AvgPrice
FROM Products
GROUP BY Category
) 
SELECT P.ProductID,
       P.Name,
	   P.Category,
	   P.Price
FROM Products P
JOIN Category C ON P.Category = C.Category
WHERE P.Price > C.AvgPrice


--# 20. Find the products that have been ordered at least once.

SELECT * FROM Products P
WHERE EXISTS (
        SELECT 1 FROM Orders O
		WHERE O.ProductID = P.ProductID )

--# 21. Retrieve the names of products that have been ordered more than the average quantity 
ordered.

WITH Avg_Quantity AS 
(
SELECT AVG(Quantity * 1.0) AS AVGQuantity 
FROM Orders
)
SELECT P.Name
FROM Products P
JOIN Orders O ON P.ProductID = O.ProductID
GROUP BY P.ProductID, P.Name
HAVING SUM(O.Quantity) > (SELECT AVGQuantity FROM Avg_Quantity)  

select * from Orders 

select * from Products
--# 22. Find the products that have never been ordered.

SELECT P.Name
FROM Products P
WHERE NOT EXISTS (
        SELECT 1 
		FROM Orders O
		WHERE O.ProductID = P.ProductID )



--# 23. Retrieve the product with the highest total quantity ordered.

SELECT top 1 P.ProductID, 
             P.Name,
			       SUM(O.Quantity) AS TotalQuantity
FROM Products P
JOIN Orders O ON P.ProductID = O.ProductID
GROUP BY P.ProductID, P.Name
ORDER BY TotalQuantity DESC 

