/* Window Value Functions
	e.g Month -->  JAN, FEB, MAR, APR
		Sales -->   20,  10,  30,   5
	LEAD(Sales) --> 10,  30,   5, NULL
    LAG(SALES) --> NULL, 20,  10,  30
	Value Function used to access value from other row
    It is used to compare values
    -- e.g if we current row is MAR then LAG() indicate previous Row (i.e FEB) and LEAD indicate next row(i.e APR)
    --Similarly FIRST_VALUE() is for comparing with first row and LAST_VALUE() is for comparing with last rows
    
    so Value Functions are : 
    A. LEAD(expr, offset, default) Returns value from a next row within a window
		--> expr can be of all datatype
        --> Partition Clause is optional and Order Clause is Required
        --> Frame Clause Not allowed.
    B. LAG(expr, offset, default) Returns value from a previous row within a window
		--> expr can be of all datatype
        --> Partition Clause is optional and Order Clause is Required
        --> Frame Clause Not allowed.
	--> offset means number of rows forward or backward from current row. Default Value of offset is 1.
    --> Default Value is value returns if next/previous row is not available (By Default Value of Default is NULL).
    C. FIRST_VALUE(expr)
		--> expr can be of all datatype
        --> Partition Clause is optional and Order Clause is Required
        --> Frame Clause Optional.
    D. LAST_VALUE(expr)
		--> expr can be of all datatype
        --> Partition Clause is optional and Order Clause is Required
        --> Frame Clause Should be Used.
        
	e.g Month 		-->  JAN, FEB, MAR, APR
		Sales 		-->   20,  10,  30,   5
	LEAD(Sales,2,0) -->   30,   5,   0,   0
     LAG(SALES,2,0) -->    0,   0,  20,  10
FIRST_VALUE(Sales)  -->   20,  20,  20,  20
LAST_VALUE(Sales)   -->   20,  10,  30,   5

	--> in first_value and last value window start from first row of current window and on moving to following row window
    --> Due to default Frame CLause Range between Unbounded Preceding and current row for the window
     
	-->for first_value generally default frame clause works but for last its not 
    --> so frame clause should be ROWS Between Current ROW and Unbounded Following
    
	USED FOR TIME SERIES ANALYSIS: Analysis of changes over period of time
		1. Year-Over-Year -> Analyzing Overall growth
        2. Month-Over-Month -> ANalyzing short trends and patterns
	Used For Customer Retention Analysis: Checking Customer loyalty
*/
use salesdb;
-- Analyze Month-over month performance by finding percentage change between curr and prev month
Select *, 
	CurrMonthSales-PrevMonthSales As MoM_change,
	ROUND(CAST((CurrMonthSales-PrevMonthSales) AS FLOAT)/PrevMonthSales * 100 , 2) As MoM_Percentchange
from (
select 
	MONTH(orderdate) as OrderMonth, 
	SUM(sales) CurrMonthSales, 
    LAG(SUM(sales)) OVER(Order by month(orderdate)) PrevMonthSales
from orders Group by MONTH(orderdate))t;
--  find average days between their orders
Select customerid, DATEDIFF(CurrOrder, PrevOrder) Difference,
AVG(coalesce(DATEDIFF(CurrOrder, PrevOrder),0)) OVER (partition by customerid) as AvgDiff 
from (
Select orderid, customerid, orderdate as CurrOrder,
LAG(orderdate) OVER(Partition by customerid order by orderdate) PrevOrder 
from orders order by customerid, orderdate)t;
-- rank customer based on average days between their orders
Select customerid,
AVG(coalesce(DATEDIFF(CurrOrder, PrevOrder),0)) as AvgDiff ,
RANK() OVER(Order by AVG(coalesce(DATEDIFF(CurrOrder, PrevOrder),0)) DESC) as RankCustomer
from (
Select orderid, customerid, orderdate as CurrOrder,
LAG(orderdate) OVER(Partition by customerid order by orderdate) PrevOrder 
from orders order by customerid, orderdate)t group by customerid;

-- find lowest and highest sales for eachproduct
select orderid, productid, sales,
first_value(sales) OVER(partition by productid order by sales) LowestSales,
last_value(sales) OVER(partition by productid order by sales ROWS BETWEEN CURRENT ROW AND unbounded following) HighestSales
from orders;
-- or
select orderid, productid, sales,
first_value(sales) OVER(partition by productid order by sales) LowestSales,
first_value(sales) OVER(partition by productid order by sales Desc) HighestSales
from orders;
