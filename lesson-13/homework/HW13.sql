-- # Lesson 13 ----Practice: String Functions, Mathematical Functions

-- ## Easy Tasks

-- 1. You need to write a query that outputs "100-Steven King", meaning emp_id + first_name + last_name in that format using employees table.

SELECT CONCAT(EMPLOYEE_ID, ' - ', FIRST_NAME, ' ', LAST_NAME) FROM Employees 
WHERE FIRST_NAME = 'Steven' AND LAST_NAME = 'King'  

-- 2. Update the portion of the phone_number in the employees table, within the phone number the substring '124' will be replaced by '999'

UPDATE Employees
SET PHONE_NUMBER = REPLACE(PHONE_NUMBER, '124', '999')
WHERE PHONE_NUMBER LIKE '%124%'

-- 3. That displays the first name and the length of the first name for all employees whose name starts with the letters 
-- 'A', 'J' or 'M'. Give each column an appropriate label. Sort the results by the employees' first names.(Employees)

SELECT FIRST_NAME AS Employees, LEN(FIRST_NAME) FROM Employees
WHERE FIRST_NAME LIKE ('A%') OR 
      FIRST_NAME LIKE ('J%') OR
	  FIRST_NAME LIKE ('M%')  
ORDER BY FIRST_NAME 


-- 4. Write an SQL query to find the total salary for each manager ID.(Employees table)

SELECT MANAGER_ID,
       SUM(SALARY) AS TotalSalary 
FROM Employees
GROUP BY MANAGER_ID
ORDER BY TotalSalary DESC 

-- 5. Write a query to retrieve the year and the highest value from the columns Max1, Max2, and Max3 for each row in the TestMax table

SELECT Year1,
       GREATEST(Max1, Max2, Max3) AS highest_value
FROM TestMax
ORDER BY Year1

-- 6. Find me odd numbered movies and description is not boring.(cinema)

SELECT id, [description]  
FROM cinema
WHERE id % 2 = 1 AND [description] <> 'boring'

-- 7. You have to sort data based on the Id but Id with 0 should always be the last row. Now the question 
-- is can you do that with a single order by column.(SingleOrder)

SELECT * FROM SingleOrder
ORDER BY 
    CASE WHEN Id = 0 THEN 1 ELSE 0 END, Id

-- 8. Write an SQL query to select the first non-null value from a set of columns. If the first column is null, move to the next, and so on. If all columns are null, return null.(person)

SELECT id,
    CASE 
        WHEN ssn IS NOT NULL THEN ssn
        WHEN passportid IS NOT NULL THEN passportid
        WHEN itin IS NOT NULL THEN itin
        ELSE NULL
    END AS first_non_null_value
FROM person


-- ## Medium Tasks

-- 1. Split column FullName into 3 part ( Firstname, Middlename, and Lastname).(Students Table)

SELECT FullName,
    PARSENAME(REPLACE (FullName, ' ', '.'), 3) AS first_name,
    PARSENAME(REPLACE(FullName, ' ', '.'), 2) AS middle_name,
    PARSENAME(REPLACE(FullName, ' ', '.'), 1) AS last_name
FROM Students


-- 2. For every customer that had a delivery to California, provide a result set of the customer orders that were delivered to Texas. (Orders Table)

SELECT * FROM Orders
WHERE DeliveryState = 'TX'
AND CustomerID IN (
    SELECT DISTINCT CustomerID 
    FROM Orders 
    WHERE DeliveryState = 'CA')
	
-- 3. Write an SQL statement that can group concatenate the following values.(DMLTable)

SELECT  STRING_AGG(String, ', ') AS FollowingValue  FROM DMLTable 


-- 4. Find all employees whose names (concatenated first and last) contain the letter "a" at least 3 times.

SELECT 
    EMPLOYEE_ID,
    FIRST_NAME,
    LAST_NAME,
    CONCAT(FIRST_NAME, ' ', LAST_NAME) AS FULL_NAME,
    LEN(CONCAT(FIRST_NAME, LAST_NAME)) - LEN(REPLACE(LOWER(CONCAT(FIRST_NAME, LAST_NAME)), 'a', '')) AS a_count
FROM 
    Employees
WHERE 
    LEN(CONCAT(FIRST_NAME, LAST_NAME)) - LEN(REPLACE(LOWER(CONCAT(FIRST_NAME, LAST_NAME)), 'a', '')) >= 3
ORDER BY 
    a_count DESC
	
-- 5. The total number of employees in each department and the percentage of those employees who have been with the company for more than 3 years(Employees)

SELECT DEPARTMENT_ID,
       COUNT(EMPLOYEE_ID) AS total_employees,
       SUM(CASE WHEN DATEDIFF(YEAR, HIRE_DATE, GETDATE()) > 3 THEN 1 ELSE 0 END) AS employees_over_3_years,
       ROUND(
            CASE 
            WHEN COUNT(EMPLOYEE_ID) = 0 THEN 0
            ELSE SUM(CASE WHEN DATEDIFF(YEAR, HIRE_DATE, GETDATE()) > 3 THEN 1.0 ELSE 0 END) * 100 / COUNT(EMPLOYEE_ID)
        END, 2 ) AS percentage_over_3_years
FROM Employees
GROUP BY DEPARTMENT_ID
ORDER BY total_employees DESC

-- 6. Write an SQL statement that determines the most and least experienced Spaceman ID by their job description.(Personal)

SELECT JobDescription,
       MAX(SpacemanID) AS most_experienced_spaceman,
       MAX(MissionCount) AS max_mission,
       MIN(SpacemanID) AS least_experienced_spaceman,
       MIN(MissionCount) AS min_mission
FROM Personal
WHERE JobDescription LIKE '%Spaceman%'
GROUP BY JobDescription

-- ## Difficult Tasks
-- 1. Write an SQL query that separates the uppercase letters, lowercase letters, numbers, and other characters from the given string 'tf56sd#%OqH' into separate columns.

;WITH CharacterAnalysis AS (
    SELECT 
        'tf56sd#%OqH' AS original_string,
        SUBSTRING('tf56sd#%OqH', number, 1) AS character,
        number AS position
    FROM master.dbo.spt_values
    WHERE type = 'P' 
    AND number BETWEEN 1 AND LEN('tf56sd#%OqH') )
SELECT 
    original_string,
    STRING_AGG(CASE WHEN character LIKE '[A-Z]' THEN character ELSE '' END, '') 
        WITHIN GROUP (ORDER BY position) AS uppercase_letters,
    STRING_AGG(CASE WHEN character LIKE '[a-z]' THEN character ELSE '' END, '') 
        WITHIN GROUP (ORDER BY position) AS lowercase_letters,
    STRING_AGG(CASE WHEN character LIKE '[0-9]' THEN character ELSE '' END, '') 
        WITHIN GROUP (ORDER BY position) AS numbers,
    STRING_AGG(CASE WHEN character NOT LIKE '[A-Za-z0-9]' THEN character ELSE '' END, '') 
        WITHIN GROUP (ORDER BY position) AS other_characters
FROM CharacterAnalysis


-- 2. Write an SQL query that replaces each row with the sum of its value and the previous rows' value. (Students table)

SELECT 
    StudentID,  
    FullName,
    SUM(Grade) OVER (ORDER BY StudentID ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS running_sum
FROM Students
ORDER BY StudentID

-- 3. You are given the following table, which contains a VARCHAR column that contains mathematical equations. Sum the equations and provide the answers in the output.(Equations)
DECLARE @sql NVARCHAR(MAX)
DECLARE @result DECIMAL(18,2)

SELECT 
    Equation,
    (SELECT @sql = 'SELECT @res = ' + equation,
            sp_executesql @sql, N'@res DECIMAL(18,2) OUTPUT', @res = @result OUTPUT,
            @result) AS result
FROM 
    Equations

-- 4. Given the following dataset, find the students that share the same birthday.(Student Table)

SELECT 
    Birthday,
    COUNT(*) AS student_count
FROM Student
GROUP BY Birthday
HAVING COUNT(*) > 1
ORDER BY Birthday


-- 5. You have a table with two players (Player A and Player B) and their scores. If a pair of players have multiple
entries, aggregate their scores into a single row for each unique pair of players. Write an SQL query to calculate the
total score for each unique player pair(PlayerScores)

SELECT 
    CASE WHEN PlayerA < PlayerB THEN PlayerA ELSE PlayerB END AS player1,
    CASE WHEN PlayerA < PlayerB THEN PlayerB ELSE PlayerA END AS player2,
    SUM(score) AS total_score
FROM 
    PlayerScores
GROUP BY 
    CASE WHEN PlayerA < PlayerB THEN PlayerA ELSE PlayerB END,
    CASE WHEN PlayerA < PlayerB THEN PlayerB ELSE PlayerA END
ORDER BY 
    player1, player2




