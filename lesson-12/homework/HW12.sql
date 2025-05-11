-- Lesson-12: Practice

-- 1. Combine Two Tables

--Table: Person

| Column Name | Type    |
+-------------+---------+
| personId    | int     |
| lastName    | varchar |
| firstName   | varchar |

personId is the primary key (column with unique values) for this table.
This table contains information about the ID of some persons and their first and last names.

-- Table: Address


| Column Name | Type    |
+-------------+---------+
| addressId   | int     |
| personId    | int     |
| city        | varchar |
| state       | varchar |
```

AddressId is the primary key (column with unique values) for this table.
Each row of this table contains information about the city and state of one person with ID = PersonId.


Write a solution to report the first name, last name, city, and state of each person in the Person table.
If the address of a personId is not present in the Address table, report null instead.

The result format is in the following example.

Input: Person table:

| personId | lastName | firstName |
+----------+----------+-----------+
| 1        | Wang     | Allen     |
| 2        | Alice    | Bob       |
```

Address table:

| addressId | personId | city          | state      |
+-----------+----------+---------------+------------+
| 1         | 2        | New York City | New York   |
| 2         | 3        | Leetcode      | California |


Output:


| firstName | lastName | city          | state    |
+-----------+----------+---------------+----------+
| Allen     | Wang     | Null          | Null     |
| Bob       | Alice    | New York City | New York |

SELECT P.firstname,
       P.lastname,
	     A.city,
	     A.[state]
FROM Person P
LEFT JOIN [Address] A 
ON P.personId = A.personId
ORDER BY P.firstname


-- 2. Employees Earning More Than Their Managers
---
Table: Employee

| Column Name | Type    |
+-------------+---------+
| id          | int     |
| name        | varchar |
| salary      | int     |
| managerId   | int     |


-- Write a solution to find the employees who earn more than their managers.

The result format is in the following example.

**Input:**
**Employee table:**
```
| id | name  | salary | managerId |
+----+-------+--------+-----------+
| 1  | Joe   | 70000  | 3         |
| 2  | Henry | 80000  | 4         |
| 3  | Sam   | 60000  | Null      |
| 4  | Max   | 90000  | Null      |
```

**Output:**
```
| Employee |
+----------+
| Joe      |

SELECT E.name as Employee 
FROM Employee E
JOIN Employee M
ON E.managerId = M.Id
WHERE E.salary > M.salary 
ORDER BY E.salary DESC


-- 3. Duplicate Emails
```
| Column Name | Type    |
+-------------+---------+
| id          | int     |
| email       | varchar |
```


**Id is the primary key (column with unique values) for this table.**
**Each row of this table contains an email. The emails will not contain uppercase letters.**

---

**Write a solution to report all the duplicate emails. Note that it''s guaranteed that the email field is not NULL.**

**The result format is in the following example.**


**Input:**
**Person table:**
```
| id | email   |
+----+---------+
| 1  | a@b.com |
| 2  | c@d.com |
| 3  | a@b.com |
```

**Output:**
```
| Email   |
+---------+
| a@b.com |
```

# Explanation: a@b.com is repeated two times.

SELECT MIN(email) AS email
FROM Person1
GROUP BY email
HAVING COUNT(*) > 1

-----------------------------------------------------


-- 4. Delete Duplicate Emails

**Table: Person**
```
| Column Name | Type    |
+-------------+---------+
| id          | int     |
| email       | varchar |
```

**Id is the primary key (column with unique values) for this table.**
**Each row of this table contains an email. The emails will not contain uppercase letters.**
 

**Write a solution to delete all duplicate emails, keeping only one unique email with the smallest id.**

**Please note that you are supposed to write a DELETE statement and not a SELECT one.**



After running your script, the answer shown is the Person table.
The driver will first compile and run your piece of code and then show the Person table.
The final order of the Person table does not matter.

The result format is in the following example.
---

**Input:**
**Person table:**
```
| id | email            |
+----+------------------+
| 1  | john@example.com |
| 2  | bob@example.com  |
| 3  | john@example.com |
```

**Output:**

```
| id | email            |
+----+------------------+
| 1  | john@example.com |
| 2  | bob@example.com  |
```
# Explanation: john@example.com is repeated two times. We keep the row with the smallest Id = 1.

DELETE FROM Person
WHERE id NOT IN (
    SELECT MIN(id)
    FROM Person
    GROUP BY email)

-- 5. Find those parents who has only girls.
**Return Parent Name only.**
```sql



SELECT DISTINCT G.ParentName
FROM girls G
LEFT JOIN boys B
ON G.ParentName = B.ParentName
WHERE B.ParentName IS NULL 
ORDER BY G.ParentName

-- 6. Total over 50 and least
**Find total Sales amount for the orders which weights more than 50 for each customer along with their 
least weight.(from TSQL2012 database, Sales.Orders Table)**


SELECT  custid AS CustomerID,
        SUM(val) AS TotalSalesAmount,
        MIN(freight) AS LeastWeight
FROM Sales.Orders
WHERE freight > 50
GROUP BY custid
ORDER BY TotalSalesAmount DESC


-- 7. Carts

**You have the tables below, write a query to get the expected output**

```sql
DROP TABLE IF EXISTS Cart1;
DROP TABLE IF EXISTS Cart2;
GO

CREATE TABLE Cart1
(
Item  VARCHAR(100) PRIMARY KEY
);
GO

CREATE TABLE Cart2
(
Item  VARCHAR(100) PRIMARY KEY
);
GO

INSERT INTO Cart1 (Item) VALUES
('Sugar'),('Bread'),('Juice'),('Soda'),('Flour');
GO

INSERT INTO Cart2 (Item) VALUES
('Sugar'),('Bread'),('Butter'),('Cheese'),('Fruit');
GO
```


**Expected Output.**

```
| Item Cart 1 | Item Cart 2 |  
|-------------|-------------|  
| Sugar       | Sugar       | 
| Bread       | Bread       |  
| Juice       |             |  
| Soda        |             |  
| Flour       |             |
|             | Butter      |  
|             | Cheese      |  
|             | Fruit       |
```


SELECT c1.Item AS [Item Cart 1],
       c2.Item AS [Item Cart 2]
FROM Cart1 c1
FULL OUTER JOIN 
     Cart2 c2 ON c1.Item = c2.Item
ORDER BY ISNULL(c1.Item, c2.Item),
         CASE WHEN c1.Item IS NULL THEN 1 ELSE 0 END

-- 8. Customers Who Never Order


**Table: Customers**
```
| Column Name | Type    |
+-------------+---------+
| id          | int     |
| name        | varchar |
```


**Id is the primary key (column with unique values) for this table.**
**Each row of this table indicates the ID and name of a customer.**


**Table: Orders**
```
| Column Name | Type |
+-------------+------+
| id          | int  |
| customerId  | int  |
```

**Id is the primary key (column with unique values) for this table.**
**customerId is a foreign key (reference columns) of the ID from the Customers table.**
**Each row of this table indicates the ID of an order and the ID of the customer who ordered it.**

---

**Write a solution to find all customers who never order anything.**

**Return the result table in any order.**

**The result format is in the following example.**

---

**Input:**
**Customers table:**
```
| id | name  |
+----+-------+
| 1  | Joe   |
| 2  | Henry |
| 3  | Sam   |
| 4  | Max   |
```

**Orders table:**
```
| id | customerId |
+----+------------+
| 1  | 3          |
| 2  | 1          |
```

**Output:**
```
| Customers |
+-----------+
| Henry     |
| Max       |
```

```sql
Create table Customers (id int, name varchar(255))
Create table Orders (id int, customerId int)
Truncate table Customers
insert into Customers (id, name) values ('1', 'Joe')
insert into Customers (id, name) values ('2', 'Henry')
insert into Customers (id, name) values ('3', 'Sam')
insert into Customers (id, name) values ('4', 'Max')
Truncate table Orders
insert into Orders (id, customerId) values ('1', '3')
insert into Orders (id, customerId) values ('2', '1')
```
SELECT C.name AS Customers 
FROM Customers C
LEFT JOIN Orders O
ON C.id = O.customerId
WHERE O.customerId IS NULL 


-- 9. Students and Examinations
---

**Table: Students**

```
| Column Name   | Type    |
+---------------+---------+
| student_id    | int     |
| student_name  | varchar |
```

**student_id is the primary key (column with unique values) for this table.**
**Each row of this table contains the ID and the name of one student in the school.**
 

**Table: Subjects**

```
| Column Name  | Type    |
+--------------+---------+
| subject_name | varchar |
```

**subject_name is the primary key (column with unique values) for this table.**
**Each row of this table contains the name of one subject in the school.**

**Table: Examinations**

```
| Column Name  | Type    |
+--------------+---------+
| student_id   | int     |
| subject_name | varchar |
```


**There is no primary key (column with unique values) for this table. It may contain duplicates.**
**Each student from the Students table takes every course from the Subjects table.**
**Each row of this table indicates that a student with ID student_id attended the exam of subject_name.**

--- 


**Write a solution to find the number of times each student attended each exam.**

**Return the result table ordered by student_id and subject_name.**

**The result format is in the following example.**

---

**Input: Students table:**
```
| student_id | student_name |
+------------+--------------+
| 1          | Alice        |
| 2          | Bob          |
| 13         | John         |
| 6          | Alex         |
```


**Subjects table:**
```
| subject_name |
+--------------+
| Math         |
| Physics      |
| Programming  |
```

**Examinations table:**
```
| student_id | subject_name |
+------------+--------------+
| 1          | Math         |
| 1          | Physics      |
| 1          | Programming  |
| 2          | Programming  |
| 1          | Physics      |
| 1          | Math         |
| 13         | Math         |
| 13         | Programming  |
| 13         | Physics      |
| 2          | Math         |
| 1          | Math         |
```


**Output:**
```
| student_id | student_name | subject_name | attended_exams |
+------------+--------------+--------------+----------------+
| 1          | Alice        | Math         | 3              |
| 1          | Alice        | Physics      | 2              |
| 1          | Alice        | Programming  | 1              |
| 2          | Bob          | Math         | 1              |
| 2          | Bob          | Physics      | 0              |
| 2          | Bob          | Programming  | 1              |
| 6          | Alex         | Math         | 0              |
| 6          | Alex         | Physics      | 0              |
| 6          | Alex         | Programming  | 0              |
| 13         | John         | Math         | 1              |
| 13         | John         | Physics      | 1              |
| 13         | John         | Programming  | 1              |
```




# Explanation: 
**The result table should contain all students and all subjects.**
**Alice attended the Math exam 3 times, the Physics exam 2 times, and the Programming exam 1 time.**
**Bob attended the Math exam 1 time, the Programming exam 1 time, and did not attend the Physics exam.**
**Alex did not attend any exams.**
**John attended the Math exam 1 time, the Physics exam 1 time, and the Programming exam 1 time.**

SELECT S.student_id,
       S.student_name,
	     Sj.subject_name,
	     COUNT(E.subject_name) AS attended_exams
FROM Students S
CROSS JOIN Subjects Sj
LEFT JOIN Examinations E
ON S.student_id = E.student_id 
AND Sj.subject_name = E.subject_name
GROUP BY S.student_id, S.student_name, Sj.subject_name
ORDER BY S.student_id, Sj.subject_name


