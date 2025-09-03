/* WIndow Aggregate Functions
	--> BY Default Frame Clause in Aggregate are below if we have order by
			ROWS BETWEEN UNBOUNDED PERCEDING AND CURRENT ROW
	--> Above Conditon called Running total or AVG
    --> And Rolling total/AVG where we defined the Frame Clause i.e some boundary window (last 3 days or month)
	--> Partiton, order by , frame clause all are optional in the window aggrgate functions
1. Count(exp) 
	a. return number of rows in a window
    b. expression could be of any datatype
    c. USE CASES ->  
		i. Overall Analysis, 		iii. Check Quality(I.e nulls)
        ii. Category Analysis, 		iv. Identify duplicates
2. SUM(exp) 
	a. return sum of values in a window
    b. expression can only of numeric datatype
    c. USE CASES ->  
		i. Overall Summary, 		iii. Contribution Use case --> comparing value to aggregated value
        ii. Category Summary,
3. AVG(exp) 
	a. return average of values in a window
    b. expression can only of numeric datatype
    c. USE CASES ->  
		i. Overall Analysis, 		iii. Comparison(I.e nulls)
        ii. Category Analysis,
4. MIN(exp) 
	a. return minimum of values in a window
    b. expression can only of numeric datatype
5. MAX(exp) 
	a. return maximum of values in a window
    b. expression can only of numeric datatype
--> MAX and MIN together can use for outlier detection
*/
-- COUNT(*) count all rows in table even if any value is null in the window
-- COUNT(sales) count all rows where sales is not null in the window

-- FInd Total number of orders provide details like orderid and date
Select orderid, orderdate, COUNT(*) OVER() TotalOrders from orders;

-- FInd Total number of orders provide details like orderid and date for each customers
Select customerid, orderid, orderdate, COUNT(*) OVER(partition by customerid) TotalCustomerOrders from orders;

-- Find Total Customers and Customers without null values in score
select *, COUNT(*) OVER() TotalCustomers, COUNT(score) OVER() TotalCustomerWithScore from customers;

-- find Total Sales across all orders and also for each products and provide orderid and order date
Select 
	orderid, orderdate, productid,
    SUM(sales) Over() as totalSales,
    SUM(sales) OVER(partition by productid) as totalProductSales
from orders;

-- find percentage contribution of each products sale to totalSales
Select 
	orderid, productid, sales,
    SUM(sales) Over() as totalSales,
    sales / SUM(sales) OVER() * 100 as '%sales'
from orders;

-- find AVG sales across all orders and also for each product
Select 
	orderid, sales, productid,
    AVG(sales) Over() as totalSales,
    AVG(sales) OVER(partition by productid) as totalProductSales
from orders;

-- find all orders where sales are higher than the average sales across all orders
Select 
	orderid, sales, productid,
    AVG(sales) Over() as totalSales,
    CASE when sales>avg(sales) OVER() then 1
    else 0
    END IsHigher
from orders;
-- or
select * from (
Select 
	orderid, sales, productid,
    AVG(sales) Over() as totalSales
from orders)t where sales>totalSales;

-- find highest and lowest sale across all orders and for each products
Select 
	orderid, sales, productid,
    MIN(sales) Over() as MINSales,
    MAX(sales) Over() as MAXSales,
    MIN(sales) Over(partition by productid) as MINProductSales,
    MAX(sales) Over(partition by productid) as MAXProductSales
from orders;
-- Get highest Salary
Select * from (
select *, MAX(salary) OVER() as highestSalary from employees) t where salary = highestSalary;
-- Find running total i.e for first product consider only that and for next considerd prev and next
-- Find rolling average of curr order including only the next order
Select orderid, productid, orderdate, sales,
AVG(sales) OVER(partition by productid) AvgByProduct,
AVG(sales) OVER(partition by productid order by orderdate) RunningAvgByProduct,
AVG(sales) OVER(partition by productid order by orderdate ROWS between current row and 1 following) RollingAvgByProduct
from orders;
