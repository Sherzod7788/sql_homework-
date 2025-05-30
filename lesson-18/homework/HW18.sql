-- # Lesson-18: View, temp table, variable, functions

-- ### 1. Create a temporary table named MonthlySales to store the total quantity sold and total revenue for each product in the current month.
**Return: ProductID, TotalQuantity, TotalRevenue**

CREATE TABLE #MonthlySales (
ProductID INT,
TotalQuantity INT,
TotalRevenue INT )   

-- ### 2. Create a view named vw_ProductSalesSummary that returns product info along with total sales quantity across all time.
**Return: ProductID, ProductName, Category, TotalQuantitySold**

CREATE VIEW vw_ProductSalesSummary AS 
SELECT P.ProductID,
       P.ProductName,
	   P.Category,
	   COALESCE(SUM(S.Quantity), 0) AS TotalQuantitySold
FROM Products P
LEFT JOIN Sales S ON P.ProductID = S.ProductID
GROUP BY P.ProductID, P.ProductName, P.Category 

--### 3. Create a function named fn_GetTotalRevenueForProduct(@ProductID INT)
**Return: total revenue for the given product ID**

CREATE FUNCTION fn_GetTotalRevenueForProduct(@ProductID INT)
RETURNS DECIMAL(18,2)
AS
BEGIN
    DECLARE @TotalRevenue DECIMAL(18,2)
    SELECT @TotalRevenue = SUM(od.Quantity * od.UnitPrice * (1 - od.Discount))
    FROM OrderDetails od
    WHERE od.ProductID = @ProductID
        IF @TotalRevenue IS NULL
        SET @TotalRevenue = 0.00
        RETURN @TotalRevenue
END
        
-- ### 4. Create a function fn_GetSalesByCategory(@Category VARCHAR(50))
**Return: ProductName, TotalQuantity, TotalRevenue for all products in that category.**

CREATE FUNCTION fn_GetSalesByCategory(@Category VARCHAR(50))
RETURNS TABLE
AS
RETURN
(
    SELECT 
        P.ProductName,
        SUM(S.Quantity) AS TotalQuantity,
        SUM(S.Quantity * P.Price ) AS TotalRevenue
    FROM Products P
    JOIN Sales S ON P.ProductID = S.ProductID
    GROUP BY P.ProductName 
)
		

-- 5. You have to create a function that get one argument as input from user and the function should return 'Yes' 
if the input number is a prime number and 'No' otherwise. You can start it like this:

CREATE FUNCTION fn_IsPrime (@Number INT)
RETURNS VARCHAR(3)
AS
BEGIN
    DECLARE @Result VARCHAR(3) = 'No'
    DECLARE @Divisor INT = 2
    DECLARE @IsPrime BIT = 1
    IF @Number <= 1
        RETURN 'No'
    IF @Number = 2
        RETURN 'Yes'
    IF @Number % 2 = 0
        RETURN 'No'
    WHILE @Divisor <= SQRT(@Number)
    BEGIN
        IF @Number % @Divisor = 0
        BEGIN
            SET @IsPrime = 0
            BREAK
        END
        SET @Divisor = @Divisor + 1
    END
    
    IF @IsPrime = 1
        SET @Result = 'Yes'
        
    RETURN @Result
END

SELECT dbo.fn_IsPrime(7) AS IsPrime 
SELECT dbo.fn_IsPrime(10) AS IsPrime 
SELECT dbo.fn_IsPrime(1) AS IsPrime 
SELECT dbo.fn_IsPrime(997) AS IsPrime 

This is for those who has no idea about prime numbers: A prime number is a number greater than 1 that has only two divisors: 1 and itself(2, 3, 5, 7 and so on).
```

-- 6. Create a table-valued function named fn_GetNumbersBetween that accepts two integers as input:
create table Numbers (Start int, [End] int)
@Start INT
@End INT

CREATE FUNCTION fn_GetNumbersBetween
(
    @Start INT,
    @End INT
)
RETURNS @Numbers TABLE 
(
    Number INT
)
AS
BEGIN
    IF @Start > @End
    BEGIN
        DECLARE @Temp INT = @Start
        SET @Start = @End
        SET @End = @Temp
    END
    DECLARE @Current INT = @Start
    WHILE @Current <= @End
    BEGIN
        INSERT INTO @Numbers (Number)
        VALUES (@Current)
        SET @Current = @Current + 1
    END
    RETURN
END

**The function should return a table with a single column:**
```sql
| Number |
|--------|
| @Start |
...
...
...
|   @end |




**It should include all integer values from @Start to @End, inclusive.**

-- 7. Write a SQL query to return the Nth highest distinct salary from the Employee table. If there are fewer than N distinct 
salaries, return NULL. 

CREATE FUNCTION getNthHighestSalary(@N INT)
RETURNS INT
AS
BEGIN
    DECLARE @Result INT;
    WITH RankedSalaries AS (
        SELECT 
            salary,
            DENSE_RANK() OVER (ORDER BY salary DESC) AS salary_rank
        FROM 
            Employee
        GROUP BY 
            salary  
    )
    SELECT @Result = salary
    FROM RankedSalaries
    WHERE salary_rank = @N
    RETURN @Result
END

### Example 1:

**Input.Employee table:**

```
| id | salary |
+----+--------+
| 1  | 100    |
| 2  | 200    |
| 3  | 300    |

### n = 2

**Output:**
```sql
| getNthHighestSalary(2) |
```
```sql
|    HighestNSalary      |
|------------------------|
| 200                    |
```

### Example 2:

**Input.Employee table:**

```sql
| id | salary |
|----|--------|
| 1  | 100    |
```


### n = 2
**Output:**
```sql
| getNthHighestSalary(2) |
```
```sql
|    HighestNSalary      |
|        null            |
```

**You can also solve this in Leetcode: https://leetcode.com/problems/nth-highest-salary/description/

-- 8. Write a SQL query to find the person who has the most friends.

**Return: Their id, The total number of friends they have**

#### Friendship is mutual. For example, if user A sends a request to user B and it is  accepted, both A and B are considered friends 
with each other. The test case is guaranteed to have only one user with the most friends.

WITH FriendCounts AS (
    SELECT id, COUNT(*) AS num_friends
    FROM (
        SELECT requester_id AS id FROM RequestAccepted
        UNION ALL
        SELECT accepter_id AS id FROM RequestAccepted
    ) AS AllFriendships
    GROUP BY id
)
SELECT TOP 1 WITH TIES
    id,
    num_friends AS num
FROM FriendCounts
ORDER BY num_friends DESC



Output:
```
| id | num |
+----+-----+
| 3  | 3   |
```

Explanation: The person with id 3 is a friend of people 1, 2, and 4, so he has three friends in total, which is the most number 
than any others.



-- 9. Create a View for Customer Order Summary. 

Create a view called vw_CustomerOrderSummary that returns a summary of customer orders. The view must contain the following columns:

> - Column Name | Description
> - customer_id | Unique identifier of the customer
> - name | Full name of the customer
> - total_orders | Total number of orders placed by the customer
> - total_amount | Cumulative amount spent across all orders
> - last_order_date | Date of the most recent order placed by the customer

CREATE VIEW vw_CustomerOrderSummary AS
SELECT 
    C.Customer_id,
    CONCAT(C.First_name, ' ', C.Last_name) AS name,
    COUNT(O.Order_id) AS total_orders,
    MAX(O.Order_date) AS last_order_date
FROM 
    Customers C
LEFT JOIN 
    Orders O ON C.Customer_id = O.Customer_id
GROUP BY 
    C.Customer_id,
    C.First_name,
    C.Last_name
	
-- 10. Write an SQL statement to fill in the missing gaps. You have to write only select statement, no need to modify the table.

```
| RowNumber | Workflow |
|----------------------|
| 1         | Alpha    |
| 2         |          |
| 3         |          |
| 4         |          |
| 5         | Bravo    |
| 6         |          |
| 7         |          |
| 8         |          |
| 9         |          |
| 10        | Charlie  |
| 11        |          |
| 12        |          |
```

Here is the expected output.
```
| RowNumber | Workflow |
|----------------------|
| 1         | Alpha    |
| 2         | Alpha    |
| 3         | Alpha    |
| 4         | Alpha    |
| 5         | Bravo    |
| 6         | Bravo    |
| 7         | Bravo    |
| 8         | Bravo    |
| 9         | Bravo    |
| 10        | Charlie  |
| 11        | Charlie  |
| 12        | Charlie  |

WITH FilledWorkflows AS (
    SELECT 
        RowNumber,
        TestCase,
        LAST_VALUE(TestCase) IGNORE NULLS OVER (
            ORDER BY RowNumber
            ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
        ) AS FilledWorkflow
    FROM Gaps
)
SELECT 
    RowNumber,
    FilledWorkflow AS TestCase
FROM FilledWorkflows
ORDER BY RowNumber

