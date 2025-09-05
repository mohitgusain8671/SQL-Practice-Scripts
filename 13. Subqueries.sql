/* 
	SubQuery: Query Inside Another Query
    SubQuery used to produce intermediate result or table which we cannot access 
    but main query can use that result and the original tables to produce the desired output
    
    SubQuery can only used by the main Query.
    Type of SubQueries:
    A. Based on Dependency
		1. Non-Correlated SubQuery --> Independent of main query
        2. Correlated SubQuery --> Depend on main query
	B. Based on Result Types
		1. Scalar SubQuery --> Return single row.
        2. Row SubQuery --> Return multiple rows.
        3. Table SubQuery --> return multiple rows, columns.
	C. Based on Location / Clauses
		1. Used in Select
        2. Used in from
        3. Used in JOIN
        4. used in Where --> a. in conditional  operators
							 b. in logical operators
*/
-- Scalar SubQuery
	use salesdb;
	Select AVG(Sales) from orders; -- return single row and column
-- Row SubQuery
	Select orderid from orders; -- return single column but multiple rows
-- table subquery
	select orderid, customerid from orders;
	Select * from orders; -- return multiple rows and columns

/* Subquery inside from Clause (Used as Temporary table for main query)
   -->  Syntax : 
		Select col1, col2 , ... from (
			Select columns from table1 where cond
		) as AliasTable ;
*/
	-- Find products that have higer price than average price of all products;
	 -- main query
	Select * from (
		Select *, AVG(price) OVER() as AvgPrice from products -- subquery
	)t where price > AvgPrice ;
    -- Rank Customer Based on total amount of sales
    Select * , ROW_NUMBER() OVER(Order by totalSales DESC) RankCustomer from (
		Select customerid, sum(sales) as totalSales from orders group by customerid
    )t;

/* Subquery inside Select Clause 
   -->  Syntax : 
		Select col1, 
			(select col from table1 where condition) as alias
        from table1;
	-->  Scalar Subqueries are allowed to used in this
*/
	-- show product id, name, price and total number of orders
    Select *, 
		(select COUNT(*) from orders where productid = products.productid) as totalOrders
	from products;
    
/* Subquery in JOIN Clause (Used to prepare the data before joining it with other tables.)
*/
	-- show all customer details and find total orders of each customer.
    Select c.*, t.totalOrders from customers c LEFT JOIN (
		Select customerid, COUNT(*) as totalOrders from orders group by customerid
    )t on c.customerid = t.customerid;
  
/* Subquery in WHERE Clause
	--> Used For complex filtering logic and makes query more flexible and dynamic.
    --> Used in Comparison Operator (filter data by comparing two values) -> only Scalar Subquery allowed
			Select col1,coll2, from table1 where coln = (Scalar Subquery)
	--> Logical Operators:
		A. IN or NOT IN --> ROW SUBQUERY is used and check if any value matches
			Select col1,col2, from t1, where cn IN (RowSubQuery)
		B. ANY --> Select if the value matches at least any one of the value in the list
			Select col1,col2, from t1, where cn (comparison operator) ANY(RowSubQuery)
		C. ALL --> Checks if value matches all values with in a list
			Select col1,col2, from t1, where cn (comparison operator) ALL(RowSubQuery)
*/
	-- find product that have price higher than average
    Select * from products where price > (Select AVG(price) from products);
    
    -- SHow Details of orders made by customer in germany
    Select * from orders where customerid IN (select customerid from customers where country='Germany');
    
    -- SHow Details of orders made by customer NOT IN germany
	Select * from orders where customerid IN (select customerid from customers where country<>'Germany'); 
    -- or
    Select * from orders where customerid NOT IN (select customerid from customers where country='Germany');
    
    -- Find Female Employees having salary greater than any male employees
    select * from employees where gender='F' and salary > any(
    Select salary from employees where gender='M');
    -- Find Female Employees having salary lesser than or equal to all male employees
    select * from employees where gender='F' and salary <= all(
    Select salary from employees where gender='M');
    
/* Subquery Based on Dependency between main and subquery
	--> Non-correlated subquery it is a subquery that runs independently from main query.
    --> correlated subquery it is a subquery that relays on values from the main query.
    Differnece :
		Non-Correlated														Correlated
    SubQuery Independent from main query						SubQuery ependent of the main query
    Subquery execute once and result used by main query			Executed for each row processed by main query
    Can be executed on its own									Cannot be executed on its own
    Easier to read												Harder to read and more complex
    Executed only once leader to better performance.			Executed multiple time lead to bad performance
    Used for static comparisons, Filtering with constants.		Row By row Comparison and dynamic Filtering
*/
    -- show all customer details and find total orders of each customer.
    Select c.*, (Select COUNT(*) from orders where customerid = c.customerid) as totalOrders from customers c;

-- CORRELATED SUBQUERY EXISTS
/* Used for checking the existence of a row in another table)
	Exists check if subquery returns any row
    Sntax
		Select col1, col2, from table1 where exists (
			Select 1 from table2 where table2.ID = table1.ID
		)
*/
	-- SHOW ORDER DETAILS FOR CUSTOMER IN GERMANY
    Select * from orders o where exists (
		Select 1 from customers c where country='Germany' and c.customerid = o.customerid
    );
    
    Select * from orders o where not exists (
		Select 1 from customers c where country='Germany' and c.customerid = o.customerid
    );
    
    
