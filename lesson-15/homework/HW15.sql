-- # Lesson-15: Subqueries and Exists

-- ## Level 1: Basic Subqueries

-- # 1. Find Employees with Minimum Salary

**Task: Retrieve employees who earn the minimum salary in the company.**
**Tables: employees (columns: id, name, salary)**

WITH MinSalary AS
(
SELECT MIN(salary) AS Min_salary FROM employees
)
SELECT E.id, E.[name], E.salary FROM employees E
JOIN MinSalary M ON E.salary = M.Min_salary

-- # 2. Find Products Above Average Price
--Task: Retrieve products priced above the average price.
--Tables: products (columns: id, product_name, price)

;WITH AvgPriceProd AS
(
SELECT AVG(price) AS AvgPrice FROM products
)
SELECT P.id, P.product_name, P.price FROM products P
JOIN AvgPriceProd A ON P.price > A.AvgPrice

-- ## Level 2: Nested Subqueries with Conditions

/* 3. Find Employees in Sales Department**
**Task: Retrieve employees who work in the "Sales" department.**
**Tables: employees (columns: id, name, department_id), departments (columns: id, department_name)*/ 

;WITH SalesEmployee AS 
( SELECT E.id,
       E.name,
       D.department_name
FROM employees E
JOIN departments D ON E.department_id = D.id 
)
SELECT id, name, department_name 
FROM SalesEmployee
WHERE department_name = 'Sales'

/* 4. Find Customers with No Orders

**Task: Retrieve customers who have not placed any orders.**
**Tables: customers (columns: customer_id, name), orders (columns: order_id, customer_id)*/

;WITH customers_order AS 
(  SELECT C.customer_id, C.name, O.order_id
   FROM customers C
   LEFT JOIN orders O ON C.customer_id = O.customer_id )
SELECT customer_id, name
FROM customers_order
WHERE order_id IS NULL 


-- ## Level 3: Aggregation and Grouping in Subqueries

-- # 5. Find Products with Max Price in Each Category

Task: Retrieve products with the highest price in each category.
Tables: products (columns: id, product_name, price, category_id)

;WITH MAXPrice AS 
(
       SELECT category_id, MAX(price) AS MaxPrice 
	   FROM products
	   GROUP BY category_id
)
SELECT P.id, P.product_name, P.price, P.category_id 
FROM products P
JOIN MAXPrice M
ON P.price = M.MaxPrice

-- # 6. Find Employees in Department with Highest Average Salary
-- Task: Retrieve employees working in the department with the highest average salary.
-- Tables: employees (columns: id, name, salary, department_id), departments (columns: id, department_name)

;WITH HighestAVGSalary AS
(
     SELECT id, name, 
	        AVG(salary) AS AvgSalary,
	        MAX(salary) AS HighestAvgSalary,
			COUNT(department_id) AS Employee
	 FROM employees
	 GROUP BY id, name 
)
SELECT id, department_name FROM departments

-- ## Level 4: Correlated Subqueries

-- # 7. Find Employees Earning Above Department Average

-- Task: Retrieve employees earning more than the average salary in their department.**
-- Tables: employees (columns: id, name, salary, department_id)**

;WITH DepartmentAVG AS 
(
      SELECT department_id,  AVG(salary) AS AvgSalary FROM employees
	  GROUP BY department_id 
)
SELECT E.id,
       E.[name],
       E.salary, 
	   E.department_id,
	   da.AvgSalary AS departmentavgsalary
FROM employees E
JOIN DepartmentAVG DA 
ON E.department_id = DA.department_id
WHERE E.salary > DA.AvgSalary 
ORDER BY E.department_id, E.salary DESC


-- # 8. Find Students with Highest Grade per Course

-- Task: Retrieve students who received the highest grade in each course.**
-- Tables: students (columns: student_id, name), grades (columns: student_id, course_id, grade)**

WITH CourseMaxGrades AS (
    SELECT  course_id,
            MAX(grade) AS max_grade
    FROM grades
    GROUP BY course_id
),

TopStudents AS (
    SELECT g.student_id,
           g.course_id,
           g.grade,
           s.name AS student_name,
           RANK() OVER (PARTITION BY g.course_id ORDER BY g.grade DESC) AS rank
    FROM grades g
    JOIN students s ON g.student_id = s.student_id
)

SELECT ts.course_id,
       ts.student_id,
       ts.student_name,
       ts.grade AS highest_grade
FROM TopStudents ts
JOIN CourseMaxGrades cmg ON ts.course_id = cmg.course_id AND ts.grade = cmg.max_grade
WHERE ts.rank = 1
ORDER BY ts.course_id  


/* ## Level 5: Subqueries with Ranking and Complex Conditions
**9. Find Third-Highest Price per Category**
**Task: Retrieve products with the third-highest price in each category.**
**Tables: products (columns: id, product_name, price, category_id)**/

WITH RankedProducts AS (
    SELECT
        id,
        product_name,
        price,
        category_id,
        ROW_NUMBER() OVER (PARTITION BY category_id ORDER BY price DESC) as price_rank
    FROM products
)
SELECT
    id,
    product_name,
    price,
    category_id
FROM RankedProducts
WHERE price_rank = 3
ORDER BY category_id, price DESC;
select * from products


/* # 10. Find Employees whose Salary Between Company Average and Department Max Salary
**Task: Retrieve employees with salaries above the company average but below the maximum in their department.**
**Tables: employees (columns: id, name, salary, department_id)**/

WITH CompanyStats AS (
    SELECT AVG(salary) AS company_avg_salary
    FROM employees
),

DepartmentStats AS (
    SELECT 
        department_id,
        MAX(salary) AS dept_max_salary
    FROM employees
    GROUP BY department_id
)

SELECT 
    e.id,
    e.name,
    e.salary,
    e.department_id,
    cs.company_avg_salary,
    ds.dept_max_salary
FROM employees e
JOIN CompanyStats cs ON 1=1
JOIN DepartmentStats ds ON e.department_id = ds.department_id
WHERE e.salary > cs.company_avg_salary
  AND e.salary < ds.dept_max_salary
ORDER BY e.department_id, e.salary DESC;
 


