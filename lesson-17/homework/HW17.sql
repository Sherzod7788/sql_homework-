
-- Lesson-17: Practice


-- 1. You must provide a report of all distributors and their sales by region.  If a distributor did not have any sales for a region, provide a zero-dollar value for that day.  Assume there is at least one sale for each region

;WITH DistinctRegions AS
(
    SELECT DISTINCT Region 
    FROM #RegionSales
),
DistinctDistributors AS (
    SELECT DISTINCT Distributor 
    FROM #RegionSales
),
AllCombinations AS (
    SELECT 
        r.Region,
        d.Distributor
    FROM DistinctRegions r
    CROSS JOIN DistinctDistributors d
) ,
ActualSales AS (
    SELECT 
        Region,
        Distributor,
        SUM(Sales) AS Sales
    FROM #RegionSales
    GROUP BY Region, Distributor
)
SELECT 
    ac.Region,
    ac.Distributor,
    COALESCE(s.Sales, 0) AS Sales
FROM AllCombinations ac
LEFT JOIN ActualSales s ON ac.Region = s.Region 
                      AND ac.Distributor = s.Distributor
ORDER BY 
    ac.Distributor,  
    CASE ac.Region   
        WHEN 'North' THEN 1
        WHEN 'South' THEN 2
        WHEN 'East' THEN 3
        WHEN 'West' THEN 4
    END



**Expected Output:**
```
|Region |Distributor   | Sales |
|-------|--------------|-------|
|North  |ACE           | 10    |
|South  |ACE           | 67    |
|East   |ACE           | 54    |
|West   |ACE           | 0     |
|North  |Direct Parts  | 8     |
|South  |Direct Parts  | 7     |
|East   |Direct Parts  | 0     |
|West   |Direct Parts  | 12    |
|North  |ACME          | 65    |
|South  |ACME          | 9     |
|East   |ACME          | 1     |
|West   |ACME          | 7     |
```

--### 2. Find managers with at least five direct reports

;WITH DirectReportCounts AS
(   SELECT 
        managerId AS manager_id,
        COUNT(*) AS number_of_reports
    FROM Employee
    WHERE managerId IS NOT NULL
    GROUP BY managerId
    HAVING COUNT(*) >= 5
)
SELECT 
    e.id,
    e.name AS manager_name,
    e.department,
    drc.number_of_reports
FROM Employee e
JOIN DirectReportCounts drc ON e.id = drc.manager_id
ORDER BY drc.number_of_reports DESC

**Expected Output:**
```
+------+
| name |
+------+
| John |
+------+
```

```
You cal also solve this puzzle in Leetcode: https://leetcode.com/problems/managers-with-at-least-5-direct-reports/description/?envType=study-plan-v2&envId=top-sql-50
```

---

-- ### 3. Write a solution to get the names of products that have at least 100 units ordered in February 2020 and their amount.

;WITH FebruarySales AS (
    SELECT 
        p.product_id,
        p.product_name,
        SUM(o.unit) AS units_sold
    FROM Orders o
    JOIN Products p ON o.product_id = p.product_id
    WHERE o.order_date >= '2020-02-01' 
      AND o.order_date < '2020-03-01'
    GROUP BY p.product_id, p.product_name
)
SELECT 
    product_name,
    units_sold
FROM FebruarySales
WHERE units_sold >= 100
ORDER BY units_sold DESC



**Expected Output:**
```
| product_name       | unit  |
+--------------------+-------+
| Leetcode Solutions | 130   |
| Leetcode Kit       | 100   |
```

--### 4. Write an SQL statement that returns the vendor from which each customer has placed the most orders

WITH VendorOrderCounts AS 
(
    SELECT 
        CustomerID,
        vendor,
        COUNT(*) AS order_count,
        ROW_NUMBER() OVER (PARTITION BY CustomerID ORDER BY COUNT(*) DESC) AS rank
    FROM Orders
    GROUP BY CustomerID, Vendor
)
SELECT 
    CustomerID,
    Vendor
FROM VendorOrderCounts voc
WHERE voc.rank = 1
ORDER BY CustomerID

**Expected Output:**
```
| CustomerID | Vendor       |
|------------|--------------|
| 1001       | Direct Parts |
| 2002       | ACME         |
```

### 5. You will be given a number as a variable called @Check_Prime check if this number is prime then return 'This number is prime' else return 'This number is not prime'


**Expected Output:**
```
This number is not prime(or "This number is prime")
```

DECLARE @Check_Prime INT = 91
DECLARE @IsPrime BIT = 1
DECLARE @Divisor INT = 2
DECLARE @Sqrt INT = SQRT(@Check_Prime)
IF @Check_Prime < 2
    SET @IsPrime = 0
ELSE IF @Check_Prime = 2
    SET @IsPrime = 1
ELSE IF @Check_Prime % 2 = 0
    SET @IsPrime = 0
ELSE
BEGIN
    SET @Divisor = 3
    WHILE @Divisor <= @Sqrt
    BEGIN
        IF @Check_Prime % @Divisor = 0
        BEGIN
            SET @IsPrime = 0
            BREAK
        END
        SET @Divisor = @Divisor + 2
    END
END
SELECT CASE 
    WHEN @IsPrime = 1 THEN 'This number is prime'
    ELSE 'This number is not prime'
END AS PrimeCheckResult

### 6. Write an SQL query to return the number of locations,in which location most signals sent, and total number of signal for each device from the given table.

WITH DeviceLocationCounts AS (
    SELECT 
        Device_id,
        Locations,
        COUNT(*) AS location_signal_count
    FROM Device
    GROUP BY Device_id, Locations
)
SELECT 
    Device_id,
    COUNT(DISTINCT Locations) AS no_of_location,
    (
        SELECT TOP 1 Locations 
        FROM DeviceLocationCounts d2 
        WHERE d2.Device_id = d1.Device_id 
        ORDER BY location_signal_count DESC
    ) AS max_signal_location,
    SUM(location_signal_count) AS no_of_signals
FROM DeviceLocationCounts d1
GROUP BY Device_id
ORDER BY Device_id



**Expected Output:**
```
| Device_id | no_of_location | max_signal_location | no_of_signals |
|-----------|----------------|---------------------|---------------|
| 12        | 2              | Bangalore           | 6             |
| 13        | 2              | Secunderabad        | 5             |
```

---

### 7. Write a SQL  to find all Employees who earn more than the average salary in their corresponding department. 
Return EmpID, EmpName,Salary in your output

;WITH EmpSalary AS 
(
      SELECT DeptID,  AVG(Salary) AS AvgSalary 
	  FROM Employee
	  GROUP BY DeptID
)
SELECT E.EmpID AS EmpID,
       E.EmpName AS EmpName, 
	   E.Salary AS [Salary]
FROM Employee E
JOIN EmpSalary ES
ON E.DeptID = ES.DeptID
WHERE E.Salary > ES.AvgSalary 
ORDER BY E.DeptID,  E.EmpName 


**Expected Output:**
```
| EmpID | EmpName | Salary |
|-------|---------|--------|
| 1001  | Mark    | 60000  |
| 1004  | Peter   | 35000  |
| 1005  | John    | 55000  |
| 1007  | Donald  | 35000  |
```

### 8. You are part of an office lottery pool where you keep a table of the winning lottery numbers along with a table 
of each ticket’s chosen numbers.  If a ticket has some but not all the winning numbers, you win $10.  If a ticket has all 
the winning numbers, you win $100.    Calculate the total winnings for today’s drawing.

WITH WinningNumbers AS (
    SELECT 25 AS Number UNION ALL
    SELECT 45 UNION ALL
    SELECT 78
),
TicketMatches AS (
    SELECT 
        t.[TicketID],
        COUNT(DISTINCT w.Number) AS matched_numbers,
        (SELECT COUNT(*) FROM WinningNumbers) AS total_winning_numbers
    FROM Tickets t
    LEFT JOIN WinningNumbers w ON t.Number = w.Number
    GROUP BY t.[TicketID]
)
SELECT 
    SUM(
        CASE 
            WHEN matched_numbers = total_winning_numbers THEN 100  
            WHEN matched_numbers > 0 THEN 10                       
            ELSE 0                                                
        END
    ) AS total_winnings
FROM TicketMatches



**Winning Numbers:**
```
|Number|
--------
|  25  |
|  45  |
|  78  |

```


**Tickets:**
```
| Ticket ID | Number |
|-----------|--------|
| A23423    | 25     |
| A23423    | 45     |
| A23423    | 78     |
| B35643    | 25     |
| B35643    | 45     |
| B35643    | 98     |
| C98787    | 67     |
| C98787    | 86     |
| C98787    | 91     |
```

**Expected Output would be $110, as you have one winning ticket, and one ticket that has some but not all the winning numbers.**

---

### 9. The Spending table keeps the logs of the spendings history of users that make purchases from an online shopping website which has a desktop and a mobile devices.

## Write an SQL query to find the total number of users and the total amount spent using mobile only, desktop only and both mobile and desktop together for each date.

WITH UserDeviceUsage AS (
    SELECT 
        [User_id],
        Spend_date,
        MAX(CASE WHEN [Platform] = 'Mobile' THEN 1 ELSE 0 END) AS used_mobile,
        MAX(CASE WHEN [Platform] = 'Desktop' THEN 1 ELSE 0 END) AS used_desktop
    FROM Spending
    GROUP BY [User_id], Spend_date
),
DeviceCategories AS (
    SELECT
        Spend_date,
        [User_id],
        CASE
            WHEN used_mobile = 1 AND used_desktop = 0 THEN 'mobile_only'
            WHEN used_mobile = 0 AND used_desktop = 1 THEN 'desktop_only'
            WHEN used_mobile = 1 AND used_desktop = 1 THEN 'both_devices'
        END AS device_category
    FROM UserDeviceUsage
),
TransactionTotals AS (
    SELECT
        t.Spend_date,
        dc.device_category,
        COUNT(DISTINCT t.[User_id]) AS number_of_users,
        SUM(t.Amount) AS total_amount_spent
    FROM user_transactions t
    JOIN DeviceCategories dc ON t.[User_id] = dc.[User_id] AND t.Spend_date = dc.Spend_date
    GROUP BY t.Spend_date, dc.device_category
)
SELECT
    Spend_date,
    device_category,
    number_of_users,
    total_amount_spent
FROM TransactionTotals
WHERE device_category IS NOT NULL
ORDER BY Spend_date, device_category

SELECT * FROM Spending 

**Expected Output:**
```
| Row | Spend_date | Platform | Total_Amount | Total_users |
|-----|------------|----------|--------------|-------------|
| 1   | 2019-07-01 | Mobile   | 100          | 1           |
| 2   | 2019-07-01 | Desktop  | 100          | 1           |
| 3   | 2019-07-01 | Both     | 200          | 1           |
| 4   | 2019-07-02 | Mobile   | 100          | 1           |
| 5   | 2019-07-02 | Desktop  | 100          | 1           |
| 6   | 2019-07-02 | Both     | 0            | 0           |
```

---


### 10. Write an SQL Statement to de-group the following data.

**Input Table: 'Grouped'**
```
|Product  |Quantity|
--------------------
|Pencil   |   3    |
|Eraser   |   4    |
|Notebook |   2    |
```

**Expected Output:**
```
|Product  |Quantity|
--------------------
|Pencil   |   1    |
|Pencil   |   1    |
|Pencil   |   1    |
|Eraser   |   1    |
|Eraser   |   1    |
|Eraser   |   1    |
|Eraser   |   1    |
|Notebook |   1    |
|Notebook |   1    |
select * from Grouped

WITH items AS (
    SELECT 'Pencil' AS item, 3 AS quantity UNION ALL
    SELECT 'Eraser', 4 UNION ALL
    SELECT 'Notebook', 2
),
numbers AS (
    SELECT ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS n
    FROM master.dbo.spt_values
    WHERE type = 'P' AND number < 100 
)
SELECT 
    i.item,
    1 AS quantity  
FROM items i
JOIN numbers n ON n.n <= i.quantity
ORDER BY i.item








