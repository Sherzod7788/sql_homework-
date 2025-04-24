-- Homework_8

-- Easy-Level Tasks
-- 1.Using Products table, find the total number of products available in each category.

SELECT Category, COUNT(*) Product_Cnt
FROM Products
GROUP BY Category
ORDER BY Product_Cnt DESC 

-- 2.Using Products table, get the average price of products in the 'Electronics' category.

SELECT Category, AVG(Price) AVG_Price, COUNT(*) Product_Cnt
FROM Products
WHERE Category = 'Electronics'
GROUP BY Category

-- 3.Using Customers table, list all customers from cities that start with 'L'.

SELECT CustomerID, FirstName, LastName, City
FROM Customers
WHERE City LIKE 'L%'
ORDER BY City, FirstName

-- 4.Using Products table, get all product names that end with 'er'.

SELECT ProductID, ProductName
FROM Products
WHERE ProductName LIKE '%er'
ORDER BY ProductID, ProductName 

-- 5.Using Customers table, list all customers from countries ending in 'A'.

SELECT CustomerID, FirstName, LastName, Country
FROM Customers 
WHERE Country LIKE '%A'
ORDER BY CustomerID 

-- 6.Using Products table, show the highest price among all products.

SELECT MAX(Price) Highest_Price
FROM Products 


-- 7.Using Products table, use IIF to label stock as 'Low Stock' if quantity < 30, else 'Sufficient'.

SELECT ProductID, ProductName, Price, StockQuantity, 
IIF(StockQuantity < 30, 'Low Stock', 'Sufficient') AS Quantity_Stock 
FROM Products

-- 8.Using Customers table, find the total number of customers in each country.

SELECT Country, COUNT(*) Num_Customers 
FROM Customers
GROUP BY Country 
ORDER BY Num_Customers DESC

-- 9.Using Orders table, find the minimum and maximum quantity ordered.

SELECT MIN(Quantity) Min_Quantity, MAX(Quantity) Max_Quantity
FROM Orders

-- Medium-Level Tasks
-- 10.Using Orders and Invoices tables, list customer IDs who placed orders in 2023 (using EXCEPT) to find those who did not have invoices.

SELECT DISTINCT CustomerID 
FROM Orders
WHERE OrderDate BETWEEN '2023-01-01' AND '2023-12-31'
EXCEPT
SELECT CustomerID 
FROM Invoices

-- 11.Using Products and Products_Discounted table, Combine all product names from Products and Products_Discounted including duplicates.

SELECT ProductName FROM Products
UNION ALL
SELECT ProductName FROM Products_Discounted 

-- 12.Using Products and Products_Discounted table, Combine all product names from Products and Products_Discounted without duplicates.

SELECT ProductName FROM Products
UNION
SELECT ProductName FROM Products_Discounted 


-- 13.Using Orders table, find the average order amount by year.

SELECT YEAR(OrderDate) Order_Year, AVG(TotalAmount) AVG_TotalAmount
FROM Orders
GROUP BY YEAR(OrderDate) 
ORDER BY Order_Year 

-- 14.Using Products table, use CASE to group products based on price: 'Low' (<100), 'Mid' (100-500), 'High' (>500). Return productname and pricegroup.

SELECT ProductName, Price, CASE  
      WHEN Price < 100 THEN 'Low'  
		  WHEN Price BETWEEN 100 AND 500 THEN 'Mid'  
		  WHEN Price > 500 THEN 'High'  
		  ELSE 'Unknown'
		  END AS Group_of_Price
FROM Products   

-- 15.Using Customers table, list all unique cities where customers live, sorted alphabetically.

SELECT DISTINCT City 
FROM Customers
WHERE City IS NOT NULL
ORDER BY City ASC

-- 16.Using Sales table, find total sales per product Id.

SELECT ProductID, SUM(SaleAmount) Total_Sales
FROM Sales
GROUP BY ProductID
ORDER BY Total_Sales DESC

-- 17.Using Products table, use wildcard to find products that contain 'oo' in the name. Return productname.

SELECT ProductName
FROM Products
WHERE ProductName LIKE '%oo%' 
ORDER BY ProductName 

-- 18.Using Products and Products_Discounted tables, compare product IDs using INTERSECT.

SELECT ProductID FROM Products
INTERSECT
SELECT ProductID FROM Products_Discounted 

-- Hard-Level Tasks
-- 19.Using Invoices table, show top 3 customers with the highest total invoice amount. Return CustomerID and Totalspent.

SELECT top 3 CustomerID, SUM(TotalAmount) TotalSpent
FROM Invoices  
GROUP BY CustomerID
ORDER BY TotalSpent DESC

-- 20.Find product ID and productname that are present in Products but not in Products_Discounted.

SELECT ProductID, ProductName FROM Products 
EXCEPT 
SELECT ProductID, ProductName FROM Products_Discounted 


-- 21.Using Products and Sales tables, list product names and the number of times each has been sold. (Research for Joins)

SELECT P.ProductName, COUNT(S.SaleID) AS Total_Sold FROM Products AS P 
LEFT JOIN Sales AS S
ON P.ProductID = S.ProductID 
GROUP BY P.ProductName
ORDER BY Total_Sold DESC

-- 22.Using Orders table, find top 5 products (by ProductID) with the highest order quantities.

SELECT top 5 ProductID, SUM(Quantity) Highest_Quantity
FROM Orders 
GROUP BY ProductID
ORDER BY Highest_Quantity DESC





















