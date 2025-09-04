/*
	- Window Function are the analytical functions
	- It performs calculation on specific subset of data without losing the level of details of rows
	- Used to perform row level calculations

	e.g .. id, product, sales in a table 
	- if we need to find sales of every product
	- usign group by return unique number of products 
	- but window function perform row level and return same number of rows.
	i.e window function return result for each rows

	Window Aggregate functions are same as of Group by aggregate functions
	Window function also has rank functions and value functions also.
*/

use salesdb;
-- Find total sales for each orders
Select Sum(sales) TotalSales from orders;
-- find total sales for each product
Select productid, Sum(sales) TotalSales from orders group by productid;
-- find total sales for each product and provide order id and order date also
Select productid, Sum(sales) Over(partition by productid) TotalSales, orderid, orderdate from orders;   -- Window Function

/* Syntax of window function
	Fx is Window functions
   Fx(expr) OVER(___)
	- expr could b e column, empty, number , multiple arguments, conditons
    - Over is used to define window(subset of data) it tells sql we are using window functions
    - Empty Over Means Calculation perform on entire datasets
	- Inside over we can have Partition Clause (work like group by) used to divide the dataset into windows and
	- Order clause to sort the dataset of each window
	- Frame Clause it is used to define subset of rows in a window
    NOTE : (Partition used to define the windows in a entire dataset order by perform sort the dataset of each windows and frame clause used to select only specific rows from a window)
   
   FRAME CLAUSE CONTAINS: (It cannot use without order by) (Lower must be before higher)
	  1. Frame Types: ROWS and RANGES
	  2. FRAME BOUNDARY(Lower): CURRENT ROW, N PRECEDING, UNBOUNDED PRECEDING
      3. 2. FRAME BOUNDARY(higher): CURRENT ROW, N FOllOWING, UNBOUNDED FOllOWING
   
   e.g: 
   AVG(sales) OVER(Partition by Category Order by orderdate ROWS BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING)
   
   e.g SUM(SALES) OVER(Order by Month ROWS BETWEEN CURRENT ROW AND 2 FOLLOWING)
		Data --> MONTH --> JAN, FEB, MAR, APR, JUN
				 SALES -->  20,  10,  30,  5 ,  70
		Above Query perform SUM Operation on 3 rows at once i.e 123,234,345,45,5
        There is no partiton a single window and we are taking current and next 2 rows in calculation
		RES -->  60, 45, 105, 75, 70
   
   --> UNBOUNDED FOLLOWING Means till the last possible rows and Preceding means previous rows
   
   Aggregate Functions are 
   1. COUNT(expr) expr--> all datatypes, PARTITION CLAUSE OPTIONAL, ORDER BY OPTIONAL, FRAME CLAUSE OPTIONAL
   2. SUM(expr) expr--> only numeric, PARTITION CLAUSE OPTIONAL, ORDER BY OPTIONAL
   3. AVG(expr) expr--> only numeric, PARTITION CLAUSE OPTIONAL, ORDER BY OPTIONAL
   4. MAX(expr) expr--> only numeric, PARTITION CLAUSE OPTIONAL, ORDER BY OPTIONAL
   5. MIN(expr) expr--> only numeric, PARTITION CLAUSE OPTIONAL, ORDER BY OPTIONAL
   
   RANK Functions are 
   1. RANK() expr--> empty, PARTITION CLAUSE OPTIONAL, ORDER BY Required
   2. ROW_NUMBER() expr--> empty, PARTITION CLAUSE OPTIONAL, ORDER BY Required
   3. DENSE_RANK() expr--> empty, PARTITION CLAUSE OPTIONAL, ORDER BY Required
   4. PERCENT_RANK() expr--> empty, PARTITION CLAUSE OPTIONAL, ORDER BY Required
   5. CUME_DIST() expr--> empty, PARTITION CLAUSE OPTIONAL, ORDER BY Required
   5. NTILE(n) expr--> only numeric, PARTITION CLAUSE OPTIONAL, ORDER BY Required
   
   VALUE FUNCTIONS
   1. LEAD(exp) expr--> all datatypes, PARTITION CLAUSE OPTIONAL, ORDER BY Required
   2. LAG(exp) expr--> all datatypes, PARTITION CLAUSE OPTIONAL, ORDER BY Required
   3. FIRST_VALUE(expr) expr--> all datatypes, PARTITION CLAUSE OPTIONAL, ORDER BY Required
   
*/

-- Find Total Sales for each combination of products and order status with provide orderid
Select 
	productid, 
    Sum(sales) Over(partition by productid, orderstatus) TotalSales, 
    orderid, orderdate, orderstatus 
from orders;
-- Rank Each Order Based on Their Sales from highest to lowestprovide orderd id and date also
Select 
	productid, 
    RANK() Over(Order By Sales DESC) RANKSALES, 
    DENSE_RANK() Over(Order By Sales DESC) DENSERANKSALES, 
    orderid, orderdate, sales 
from orders;

Select 
	productid, 
    sales,
    Sum(sales) Over(partition by orderstatus order by orderdate rows between current row and 2 following) TotalSales, 
    orderid, orderdate, orderstatus 
from orders;

/*
	RULES OF WINDOW FUNCTIONS
    1. It can be used only inside SELECT and ORDER BY CLAUSE
    2. Nesting Window Functions are not allowed
    3. SQL Execute window functions after where clauses.
    4. Window functions can be used with Group by clause only if same columns are used
*/
-- RANK CUSTOMERS BASED ON THEIR TOAL SALES
Select 
	customerid, 
	SUM(sales) totalSales, 
	RANK() OVER(Order by SUM(sales) DESC) as CustomerRANK 
from orders group by customerid;