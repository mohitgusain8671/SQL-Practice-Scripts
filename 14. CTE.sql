/* CTE (COMMON TABLE EXPRESSION)
	It is a temporary named result set or virtual table that can be used multiple times within a query
    it is used to simplify and organize complex queries.
	--> Difference Between CTE AND SUBQUERY
		1. In SubQuery the main query comes first and then subquery while in cte cte query comes fitst then main query
		2. CTE QUERY CAN BE USED MULTIPLE TIMES WHILE SUBQUERY CAN't used multiple times
		3. CTE QUERY IS DEFINED USING WITH KEYWORD
		4. CTE QUERY Improves Readability and reusability and modularity.
		5. CTE must always be named but subqueries do not require naming if it is not in from clause
		6. We can use Recursive CTE to handle hierarichal or complex calculation in dataset
	
    --> HOW DB EXECUTE CTE:
    1. Database execute CTE in the order store their result in cache with the name specified to Respective CTE.
    2. GRAB MAIN QUERY AND EXECUTE STEP BY STEP (i.e first checking for the table mentioned in main query inside cache and then disk storage).
	3. Return results
    
    --> We cannot use order by within CTE
    --> CTE TYPES
    A. Non-Recursive CTE:
		1. Standalone CTE: 
			-> Defined and used independently.
            -> Runs independently as it's self contained and doesn't rely on other CTEs or queries.
					Independent ( DB <-> Execute CTE ) -> Intermediate Result -> Used By Main query  -> Result
			Syntax: 
            With CTE_NAME AS ( 
				Query 
            ) 
            MAIN QUERY
        2. NESTED CTE:
			-> CTE INSIDE ANOTHER CTE
            -> A Nested CTE Uses the Result of another CTE so it can't run independently
				DB <-> CTE <-> Intermediate Result <-> Depends on Previous(CTE -> Intermediate Result) -> MAIN QUERY -> Result
			Syntax: 
            With CTE_NAME AS ( 
				Query 
            ), CTE_NAME2 AS (
				Query using CTE1
			)
            MAIN QUERY
    B. Recursive CTE: 
		--> Non - Recursive CTE Executes only once without any repetition
        --> recursive CTE are self-referencing query that repeatedly processes data untill specific condition is met.
					DB <-> CTE <-> Intermediate Result  -> Main Query  --> result
            There is a loop between CTE and Intermediate Result it will run untill a condition met
		--> Syntax: 
        WITH Recursive CTE_NAME As (
			Select ... from ... Where ...                    	---> Called Anchor Query (Execute Only OnceAt start)
            UNION ALL
            Select ... from CTE_NAME WHERE (Break Condition)	---> Called Recursive Query (Execute untill condition met)
		) MAIN QUERY
*/
-- Single Standalone CTE
	-- Find Total Sales Per Customer
	use salesdb;
	WITH CustomerSales as (
		Select Customerid, SUM(sales) as TotalSales from orders group by customerid
	)
	Select 
		c.customerid, c.firstname, c.lastname, c.country, cs.TotalSales 
	from Customers c LEFT JOIN CustomerSales cs on c.customerid = cs.customerid;
-- MULTIPLE STANDALONE CTE
	-- FIND LAST ORDER DATE PER CUSTOMER
    WITH CustomerSales as (
		Select Customerid, SUM(sales) as TotalSales from orders group by customerid
	), 
    LastOrder as (
		Select customerid, MAX(orderdate) as lastORder from orders group by customerid
    )
	Select 
		c.customerid, c.firstname, c.lastname, c.country, cs.TotalSales, ls.lastORder
	from Customers c LEFT JOIN CustomerSales cs on c.customerid = cs.customerid
    LEFT JOIN LastOrder ls on c.customerid = ls.customerid;
    
-- NESTED CTE
	-- RANK CUSTOMER BASED ON TOTAL SALES PER CUSTOMER
    WITH CustomerSales as (
		Select Customerid, SUM(sales) as TotalSales from orders group by customerid
	), 
    LastOrder as (
		Select customerid, MAX(orderdate) as lastORder from orders group by customerid
    ), CustomerRANK as (
		Select *, RANK() OVER(order by TotalSales DESC) as CRANK from CustomerSales
	), SegementCustomer as (
		Select *,
        CASE WHEN TotalSales > 100 THEN 'HIGH'
			 WHEN TotalSales > 60 THEN 'MID'
             ELSE 'LOW'
		END as Segement
        from CustomerRANK
    )
	Select 
		c.customerid, c.firstname, c.lastname, c.country, cs.TotalSales, ls.lastORder, cs.CRANK, cs.Segement
	from Customers c LEFT JOIN SegementCustomer cs on c.customerid = cs.customerid
    LEFT JOIN LastOrder ls on c.customerid = ls.customerid order by CRANK;
    
-- Generate Sequence Number from 1 to 20
WITH RECURSIVE Generate AS (
	-- Anchor
	Select 1 as MyNumber
    UNION ALL
    -- Recursive
    Select MyNumber+1 as MyNumber from Generate where Mynumber<1000
)
Select * from Generate;
-- Show Employee hierarchy by displaying each employee's level within the organization
WITH Recursive Hierarichal as (
	Select employeeid, firstname, managerid , 1 as HLevel from employees WHERE managerid is null
	UNION ALL
	Select e.employeeid, e.firstname, e.managerid, h.HLevel+1 as HLevel 
    from employees as e 
    JOIN Hierarichal h on e.managerid = h.employeeid
)
Select * from Hierarichal;



