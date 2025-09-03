-- Aggregate Function
/*
aggregate functions are special functions.
perform a calculation on a set (group) of values.
and it return a single summarized value.
*/

/*
1. COUNT() → Returns the number of rows
	SELECT COUNT(*) FROM employees;
	-- total number of employees


2. SUM() → Returns the total sum of a numeric column
	SELECT SUM(salary) FROM employees;
	-- total salary expense
    
3. AVG() → Returns the average (mean) value
	SELECT AVG(salary) FROM employees;
	-- average employee salary

4. MIN() → Returns the smallest value
	SELECT MIN(salary) FROM employees;
	-- lowest salary
    
5. MAX() → Returns the largest value
	SELECT MAX(salary) FROM employees;
	-- highest salary
*/
use salesdb;
select 
count(*) as TotalElements, 
SUM(sales) as totalSales, 
avg(sales) as totalAverage,
max(sales) as MaxSales, 
min(sales) as MinSales from orders;

select 
customerid,
count(*) as TotalElements, 
SUM(sales) as totalSales, 
avg(sales) as totalAverage,
max(sales) as MaxSales, 
min(sales) as MinSales from orders group by customerid;