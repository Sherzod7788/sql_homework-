
--# Lesson 22: Aggregated Window Functions



-1. **Compute Running Total Sales per Customer**

SELECT sale_id,
       order_date,
	   customer_name,
	   total_amount,
	   SUM(total_amount) OVER (ORDER BY order_date ROWS BETWEEN UNBOUNDED PRECEDING 
       AND CURRENT ROW) AS RunningTotal 
FROM sales_data

--2. **Count the Number of Orders per Product Category**

SELECT product_name,
       product_category,
	   COUNT(*) OVER (PARTITION BY product_category) AS NumProduct 
FROM sales_data


--3. **Find the Maximum Total Amount per Product Category**

WITH CTE AS 
(
SELECT *, MAX(total_amount) OVER (PARTITION BY product_category) AS MaxTotalAmount
FROM sales_data
)
SELECT * FROM CTE 
WHERE total_amount = MaxTotalAmount 

--4. **Find the Minimum Price of Products per Product Category**

WITH CTE AS 
(
SELECT *, MIN(unit_price) OVER (PARTITION BY product_category) AS MinPrice
FROM sales_data
)
SELECT DISTINCT product_category, MinPrice
FROM CTE 


--5. **Compute the Moving Average of Sales of 3 days (prev day, curr day, next day)**

SELECT order_date,
       total_amount,  
	   AVG(total_amount) OVER (ORDER BY order_date 
          ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING) AS MovAVG
FROM sales_data 
ORDER BY order_date

--6. **Find the Total Sales per Region**

SELECT sale_id,
       customer_name,
	   product_name,
	   total_amount,
	   region,
	   SUM(total_amount) OVER (PARTITION BY region) AS TotalSale
FROM sales_data

--7. **Compute the Rank of Customers Based on Their Total Purchase Amount**

SELECT customer_name,
       product_name,
	   SUM(total_amount) AS TotalPurchase,
	   RANK() OVER (ORDER BY SUM(total_amount) DESC) AS Ranked
FROM sales_data 
GROUP BY customer_name, product_name 


--8. **Calculate the Difference Between Current and Previous Sale Amount per Customer**

SELECT 
    customer_name,
    order_date,
    total_amount,
    LAG(total_amount) OVER (PARTITION BY customer_name ORDER BY order_date) AS previous_amount,
    total_amount - LAG(total_amount) OVER (PARTITION BY customer_name ORDER BY order_date) AS amount_difference
FROM sales_data


--9. **Find the Top 3 Most Expensive Products in Each Category**

SELECT * FROM (
     SELECT product_category,
            product_name,
			unit_price,
            DENSE_RANK() OVER (PARTITION BY product_category ORDER BY unit_price DESC) AS PriceRanked
      FROM sales_data ) AS Ranked 
WHERE PriceRanked <= 3     


--10. **Compute the Cumulative Sum of Sales Per Region by Order Date**

SELECT *, SUM(total_amount) OVER (PARTITION BY region ORDER BY order_date
          ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS CumulativeSum 
FROM sales_data
ORDER BY region, order_date 


--## Medium Questions

--11. **Compute Cumulative Revenue per Product Category**

SELECT 
    product_category,
    order_date,
    product_name,
    total_amount,
    SUM(total_amount) OVER (
        PARTITION BY product_category 
        ORDER BY order_date
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS cumulative_revenue
FROM sales_data
ORDER BY product_category, order_date


--12. **Here you need to find out the sum of previous values. Please go through the sample input and expected output.**

SELECT *, SUM(ID) OVER (ORDER BY ID) AS SumPreValues FROM sample GROUP BY ID 


--13. **Sum of Previous Values to Current Value**

SELECT Value, SUM(Value) OVER (ORDER BY Value ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS SUMofPrevious
FROM OneColumn

--14. **Generate row numbers for the given data. The condition is that the first row number for every partition should be odd number.For more details please check the sample input and expected output.**

WITH CTE AS (
  SELECT *, ROW_NUMBER() OVER (ORDER BY Id, Vals) AS rn
  FROM Row_Nums
)
SELECT 
  Id,
  Vals,
  CASE 
    WHEN rn = 2 THEN 3
    WHEN rn > 2 THEN rn + 1
    ELSE rn
  END AS RowNumber
FROM CTE

--15. **Find customers who have purchased items from more than one product_category**

SELECT customer_id, customer_name
FROM sales_data
GROUP BY customer_id, customer_name
HAVING COUNT(DISTINCT product_category) > 1

--16. **Find Customers with Above-Average Spending in Their Region**

SELECT customer_id, customer_name, region, total_spent, avg_spent_per_region
FROM (
    SELECT 
        customer_id,
        customer_name,
        region,
        SUM(total_amount) AS total_spent,
        AVG(SUM(total_amount)) OVER (PARTITION BY region) AS avg_spent_per_region
    FROM sales_data
    GROUP BY customer_id, customer_name, region
) AS regional_sales
WHERE total_spent > avg_spent_per_region;


--17. **Rank customers based on their total spending (total_amount) within each region. If multiple customers have the same spending, they should receive the same rank.**

SELECT 
    customer_id,
    customer_name,
    region,
    total_spent,
    RANK() OVER (PARTITION BY region ORDER BY total_spent DESC) AS spending_rank
FROM (
    SELECT 
        customer_id,
        customer_name,
        region,
        SUM(total_amount) AS total_spent
    FROM sales_data
    GROUP BY customer_id, customer_name, region
) AS regional_spending


--18. **Calculate the running total (cumulative_sales) of total_amount for each customer_id, ordered by order_date.**

SELECT 
    customer_id,
    customer_name,
    order_date,
    total_amount,
    SUM(total_amount) OVER (
        PARTITION BY customer_id 
        ORDER BY order_date
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS cumulative_sales
FROM sales_data


--19. **Calculate the sales growth rate (growth_rate) for each month compared to the previous month.**

SELECT 
    FORMAT(order_date, 'yyyy-MM') AS order_month,
    SUM(total_amount) AS monthly_sales,
    LAG(SUM(total_amount)) OVER (ORDER BY FORMAT(order_date, 'yyyy-MM')) AS prev_month_sales,
    CAST(
        (SUM(total_amount) - LAG(SUM(total_amount)) OVER (ORDER BY FORMAT(order_date, 'yyyy-MM')))
        / NULLIF(LAG(SUM(total_amount)) OVER (ORDER BY FORMAT(order_date, 'yyyy-MM')), 0) * 100 
        AS DECIMAL(10,2)
    ) AS growth_rate
FROM sales_data
GROUP BY FORMAT(order_date, 'yyyy-MM')
ORDER BY order_month


--20. **Identify customers whose total_amount is higher than their last order''s total_amount.(Table sales_data)**

SELECT 
    customer_id,
    customer_name,
    order_date,
    total_amount,
    LAG(total_amount) OVER (PARTITION BY customer_id ORDER BY order_date) AS previous_total,
    CASE 
        WHEN total_amount > LAG(total_amount) OVER (PARTITION BY customer_id ORDER BY order_date)
        THEN 'Yes'
        ELSE 'No'
    END AS IsHigherThanPrevious
FROM sales_data
WHERE LAG(total_amount) OVER (PARTITION BY customer_id ORDER BY order_date) IS NOT NULL
  AND total_amount > LAG(total_amount) OVER (PARTITION BY customer_id ORDER BY order_date)



--## Hard Questions
--21. **Identify Products that prices are above the average product price**

WITH CTE AS (
    SELECT 
        customer_id,
        customer_name,
        order_date,
        total_amount,
        LAG(total_amount) OVER (PARTITION BY customer_id ORDER BY order_date) AS previous_total
    FROM sales_data
)
SELECT *
FROM CTE
WHERE previous_total IS NOT NULL AND total_amount > previous_total


--22. **In this puzzle you have to find the sum of val1 and val2 for each group and put that value at the beginning of the group in the new column. The challenge here is to do this in a single select. For more details please see the sample input and expected output.**

SELECT 
    Id,
    Grp,
    Val1,
    Val2,
    CASE 
        WHEN ROW_NUMBER() OVER (PARTITION BY Grp ORDER BY Id) = 1 
        THEN SUM(Val1 + Val2) OVER (PARTITION BY Grp)
        ELSE NULL
    END AS Tot
FROM MyData;



--23. **Here you have to sum up the value of the cost column based on the values of Id. For Quantity if values are different then we have to add those values.Please go through the sample input and expected output for details.**

SELECT
    ID,
    SUM(DISTINCT Cost) AS Cost,
    SUM(DISTINCT Quantity) AS Quantity
FROM TheSumPuzzle
GROUP BY ID;


--24. **From following set of integers, write an SQL statement to determine the expected outputs**

WITH Numbers AS (
    SELECT TOP 100 ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS SeatNumber
    FROM sys.all_objects 
),
MissingSeats AS (
    SELECT n.SeatNumber
    FROM Numbers n
    LEFT JOIN Seats s ON n.SeatNumber = s.SeatNumber
    WHERE s.SeatNumber IS NULL
),
GroupedGaps AS (
    SELECT 
        SeatNumber,
        SeatNumber - ROW_NUMBER() OVER (ORDER BY SeatNumber) AS grp
    FROM MissingSeats
)
SELECT 
    MIN(SeatNumber) AS GapStart,
    MAX(SeatNumber) AS GapEnd
FROM GroupedGaps
GROUP BY grp
ORDER BY GapStart;


--25. **In this puzzle you need to generate row numbers for the given data. The condition is that the first row number for every partition should be even number.For more details please check the sample input and expected output.**

WITH Numbered AS (
    SELECT *,
           ROW_NUMBER() OVER (PARTITION BY Id ORDER BY Vals) AS rn
    FROM Intigers
),
BaseRow AS (
    SELECT *,
           DENSE_RANK() OVER (ORDER BY Id) * 2 AS base
    FROM Numbered
)
SELECT 
    Id,
    Vals,
    base + rn - 1 AS Changed
FROM BaseRow
ORDER BY Id, Changed;


