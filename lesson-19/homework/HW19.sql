
-- Lesson-19: Stored procedures, Merge and Practice
# ✅ TASKS on **Stored Procedures** and **MERGE**
# 🔵 Part 1: Stored Procedure Tasks


--## 📄 Task 1:
/*
Create a stored procedure that:
Creates a temp table `#EmployeeBonus`
Inserts EmployeeID, FullName (FirstName + LastName), Department, Salary, and BonusAmount into it
(BonusAmount = Salary * BonusPercentage / 100)
Then, selects all data from the temp table.*/


CREATE PROCEDURE EmployeeBonuses @BonusPercentage DECIMAL(5,2)
AS
BEGIN
    SET NOCOUNT ON
    
        CREATE TABLE #EmployeeBonus (
        EmployeeID INT,
        FullName NVARCHAR(100),
        Salary DECIMAL(10,2),
        BonusAmount DECIMAL(10,2)
    );
       INSERT INTO #EmployeeBonus (EmployeeID, FullName, Salary, BonusAmount)
    SELECT 
        EmployeeID,
        FirstName + ' ' + LastName AS FullName,
        Salary,
        Salary * @BonusPercentage / 100 AS BonusAmount
    FROM Employees 
    
    SELECT 
        EmployeeID,
        FullName,
        Salary,
        BonusAmount,
        @BonusPercentage AS BonusPercentage
    FROM  #EmployeeBonus
    ORDER BY FullName
END

EXEC EmployeeBonuses @BonusPercentage = 17.00


/* ## 📄 Task 2:
Create a stored procedure that:
- Accepts a department name and an increase percentage as parameters
- Update salary of all employees in the given department by the given percentage
- Returns updated employees from that department.*/


CREATE PROCEDURE sp_IncreaseDepartmentSalaries
    @DepartmentName NVARCHAR(50),
    @IncreasePercentage DECIMAL(5,2)
AS
BEGIN
    SET NOCOUNT ON
    IF @IncreasePercentage <= 0 OR @IncreasePercentage > 100
    BEGIN
        RAISERROR('Increase percentage must be between 0 and 100', 16, 1)
        RETURN
    END
    BEGIN TRY
        BEGIN TRANSACTION
        CREATE TABLE #UpdatedEmployees (
            EmployeeID INT,
            FullName NVARCHAR(100),
            OldSalary DECIMAL(10,2),
            NewSalary DECIMAL(10,2),
            IncreaseAmount DECIMAL(10,2)
        )
        INSERT INTO #UpdatedEmployees (EmployeeID, FullName, OldSalary)
        SELECT 
            e.EmployeeID,
            e.FirstName + ' ' + e.LastName AS FullName,
            e.Salary
        FROM Employees 
           e.Department = @DepartmentName
            AND e.IsActive = 1
        UPDATE e
        SET e.Salary = ROUND(e.Salary * (1 + @IncreasePercentage/100), 2)
        FROM Employees e
        WHERE e.Department = @DepartmentName
          
        UPDATE #UpdatedEmployees
        SET 
            NewSalary = e.Salary,
            IncreaseAmount = e.Salary - OldSalary
        FROM 
            #UpdatedEmployees ue
        JOIN 
            Employees e ON ue.EmployeeID = e.EmployeeID;
        
            SELECT 
            EmployeeID,
            FullName,
            OldSalary,
            NewSalary,
            IncreaseAmount,
            @IncreasePercentage AS IncreasePercentage,
            @DepartmentName AS Department
        FROM 
            #UpdatedEmployees
        ORDER BY 
            FullName
        DROP TABLE #UpdatedEmployees
        
        COMMIT TRANSACTION
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION
        SELECT 
            ERROR_NUMBER() AS ErrorNumber,
            ERROR_MESSAGE() AS ErrorMessage
    END CATCH
END

EXEC sp_IncreaseDepartmentSalaries 
    @DepartmentName = 'Sales', 
    @IncreasePercentage = 10.00


--# 🔵 Part 2: MERGE Tasks

CREATE PROCEDURE sp_EmployeeSalaryOperations
    @OperationType VARCHAR(20),  
    @DepartmentName NVARCHAR(50) = NULL,
    @Percentage DECIMAL(5,2),
    @ReturnDetailedReport BIT = 1
AS
BEGIN
    SET NOCOUNT ON
        IF @Percentage <= 0 OR @Percentage > 100
    BEGIN
        RAISERROR('Percentage must be between 0 and 100', 16, 1);
        RETURN;
    END

    IF @OperationType NOT IN ('BONUS', 'INCREASE')
    BEGIN
        RAISERROR('Operation type must be either ''BONUS'' or ''INCREASE''', 16, 1);
        RETURN;
    END
    
    BEGIN TRY
        BEGIN TRANSACTION;
        
            CREATE TABLE #Results (
            EmployeeID INT,
            FullName NVARCHAR(100),
            Department NVARCHAR(50),
            OldSalary DECIMAL(10,2),
            NewValue DECIMAL(10,2),  
            Difference DECIMAL(10,2), 
            OperationType VARCHAR(20),
            Percentage DECIMAL(5,2)
        );
        
            IF @OperationType = 'BONUS'
        BEGIN
            INSERT INTO #Results (EmployeeID, FullName, Department, OldSalary, NewValue, Difference, OperationType, Percentage)
            SELECT 
                e.EmployeeID,
                e.FirstName + ' ' + e.LastName AS FullName,
                e.Department,
                e.Salary AS OldSalary,
                ROUND(e.Salary * @Percentage / 100, 2) AS BonusAmount,
                ROUND(e.Salary * @Percentage / 100, 2) AS BonusAmount,
                'BONUS',
                @Percentage
            FROM 
                Employees e
            WHERE 
                (@DepartmentName IS NULL OR e.Department = @DepartmentName)
                AND e.IsActive = 1;
        END

        ELSE IF @OperationType = 'INCREASE'
        BEGIN
         
            INSERT INTO #Results (EmployeeID, FullName, Department, OldSalary, OperationType, Percentage)
            SELECT 
                e.EmployeeID,
                e.FirstName + ' ' + e.LastName AS FullName,
                e.Department,
                e.Salary,
                'INCREASE',
                @Percentage
            FROM 
                Employees e
            WHERE 
                e.Department = @DepartmentName
                AND e.IsActive = 1;
            
            -- Update salaries
            UPDATE e
            SET e.Salary = ROUND(e.Salary * (1 + @Percentage/100), 2)
            FROM 
                Employees e
            WHERE 
                e.Department = @DepartmentName
                AND e.IsActive = 1;
            
            -- Update temp table with new values
            UPDATE r
            SET 
                r.NewValue = e.Salary,
                r.Difference = e.Salary - r.OldSalary
            FROM 
                #Results r
            JOIN 
                Employees e ON r.EmployeeID = e.EmployeeID;
        END
        
        -- Return results if requested
        IF @ReturnDetailedReport = 1
        BEGIN
            SELECT 
                EmployeeID,
                FullName,
                Department,
                OldSalary,
                NewValue,
                Difference,
                OperationType,
                Percentage
            FROM 
                #Results
            ORDER BY 
                Department, FullName;
        END
        ELSE
        BEGIN
            -- Return summary only
            SELECT 
                OperationType,
                Department,
                COUNT(*) AS EmployeeCount,
                SUM(OldSalary) AS OldTotalSalary,
                SUM(NewValue) AS NewTotalValue,
                SUM(Difference) AS TotalDifference,
                Percentage
            FROM 
                #Results
            GROUP BY 
                OperationType, Department, Percentage;
        END
        
        -- Clean up
        DROP TABLE #Results;
        
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;
            
        -- Return error information
        SELECT 
            ERROR_NUMBER() AS ErrorNumber,
            ERROR_MESSAGE() AS ErrorMessage;
    END CATCH
END;




/* ## 📄 Task 3:
Perform a MERGE operation that:
- Updates `ProductName` and `Price` if `ProductID` matches
- Inserts new products if `ProductID` does not exist
- Deletes products from `Products_Current` if they are missing in `Products_New`
- Return the final state of `Products_Current` after the MERGE.
*/ 


CREATE PROCEDURE MergeProducts
AS
BEGIN
    SET NOCOUNT ON;

    -- Step 1: MERGE operation
    MERGE Products_Current AS target
    USING Products_New AS source
    ON target.ProductID = source.ProductID

    -- If matching ProductID, update fields
    WHEN MATCHED THEN
        UPDATE SET 
            target.ProductName = source.ProductName,
            target.Price = source.Price

    -- If ProductID not found in current, insert it
    WHEN NOT MATCHED BY TARGET THEN
        INSERT (ProductID, ProductName, Price)
        VALUES (source.ProductID, source.ProductName, source.Price)

    -- If ProductID in current not in new, delete it
    WHEN NOT MATCHED BY SOURCE THEN
        DELETE;

    -- Step 2: Return final result
    SELECT * FROM Products_Current;
END

EXEC MergeProducts 

/*## 📄 Task 4:
**Tree Node**
Each node in the tree can be one of three types:
- **"Leaf"**: if the node is a leaf node.
- **"Root"**: if the node is the root of the tree.
- **"Inner"**: If the node is neither a leaf node nor a root node.
Write a solution to report the type of each node in the tree.*/  

SELECT 
    t.id,
    CASE 
        WHEN t.p_id IS NULL THEN 'Root'
        WHEN NOT EXISTS (
            SELECT 1 FROM Tree AS child WHERE child.p_id = t.id
        ) THEN 'Leaf'
        ELSE 'Inner'
    END AS node_type
FROM Tree AS t



Output:

| id  | type  |
|-----|-------|
| 1   | Root  |
| 2   | Inner |
| 3   | Leaf  |
| 4   | Leaf  |
| 5   | Leaf  |

🔗 [Solve this puzzle on LeetCode](https://leetcode.com/problems/tree-node/description/)

---

/* ## 📄 Task 5:
**Confirmation Rate**
Find the confirmation rate for each user. If a user has no confirmation requests, the rate should be 0.
*/ 

SELECT 
    s.user_id,
    CAST(
        COUNT(CASE WHEN c.action = 'confirmed' THEN 1 END) * 1.0 
        / NULLIF(COUNT(c.action), 0)
        AS DECIMAL(4,2)
    ) AS confirmation_rate
FROM 
    Signups s
LEFT JOIN 
    Confirmations c ON s.user_id = c.user_id
GROUP BY 
    s.user_id
ORDER BY 
    confirmation_rate ASC, s.user_id DESC 

	   
Output:

| user_id | confirmation_rate |
|---------|-------------------|
| 6       | 0.00               |
| 3       | 0.00               |
| 7       | 1.00               |
| 2       | 0.50               |

🔗 [Solve this puzzle on LeetCode](https://leetcode.com/problems/confirmation-rate/description/)



/*## 📄 Task 6:
**Find employees with the lowest salary**
- Find all employees who have the lowest salary using subqueries.*/

SELECT *
FROM Employees
WHERE salary = (
    SELECT MIN(salary)
    FROM Employees
);


/*## 📄 Task 7: **Get Product Sales Summary
Create a stored procedure called `GetProductSalesSummary` that:
- Accepts a `@ProductID` input
- Returns:
  - ProductName
  - Total Quantity Sold
  - Total Sales Amount (Quantity × Price)
  - First Sale Date
  - Last Sale Date
- If the product has no sales, return `NULL` for quantity, total amount, 
first date, and last date, but still return the product name.*/



CREATE PROCEDURE GetProductSalesSummary
    @ProductID INT
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        p.ProductName,
        SUM(s.Quantity) AS TotalQuantitySold,
        SUM(s.Quantity * p.Price) AS TotalSalesAmount,
        MIN(s.SaleDate) AS FirstSaleDate,
        MAX(s.SaleDate) AS LastSaleDate
    FROM Products p
    LEFT JOIN Sales s ON p.ProductID = s.ProductID
    WHERE p.ProductID = @ProductID
    GROUP BY p.ProductName, p.Price;
END;


EXEC GetProductSalesSummary @ProductID = 1 


