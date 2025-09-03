-- SET OPERATORS (Used to combine rows of two tables)
-- UNION -> return all distinct rows from both queries and remove duplicates
-- UNION ALL -> return all rows even duplicates rows. Union all is faster than union as it do not remove duplicates
-- EXCEPT -> Also Called MINUS. Return all distinct rows from first query that are not found in second query
-- INTERSECT -> Return commons rows

/* SYNTAX
	Select a,b,c from t1
		SETOP (UNION,UNION ALL, INTERSECT,EXCEPT)
	Select a,b,c from t2
*/
/* Rules
	Rule - 1: So we use set operator between 2 select stmt these 2 stmt can contain any clauses except for order by
				i.e JOIN,where, Group BY etc are allowed but the order by can only allowed at the end of both query
					q1 op q2 order by
	RULE - 2: Both query should return table that contain same number of coulmns in both
    Rule - 3: Datatypes of column of query must be compatible
    RULe - 4: order of column in query must be same (i.e int,string in q1 then in q2 col must be int, string also)
    Rule - 5 Column name in result set is determined by the column names specified in first query
    Rule - 6: Selecting correct columns to get accurate result
*/

-- UNION
Select customerid as ID, firstname as FirstName, lastname as LastName from customers
UNION
select employeeid, firstname, lastname from employees
order by ID;

-- UNION ALL
select customerid as ID, firstname as FirstName, lastname as LastName from customers
UNION ALL
select employeeid, firstname, lastname from employees
order by ID;

-- EXCEPT --> NOT SUPPORTED IN MYSQL
/*
	select customerid as ID, firstname as FirstName, lastname as LastName from customers
	EXCEPT
	select employeeid, firstname, lastname from employees
	order by ID; 
*/

-- INTERSECT --> NOT SUPPORTED IN MYSQL


-- SET OPERATOR COMBINES DIFFERENT INFORMATION FROM DIFFERENT TABLES TO ANALYZE DATA

-- TASK - 1 COMBINE ALL ORDERS DATA INTO ONE REPORt
Select * from orders
UNION
select * from orders_archive;

-- DELTA DETECTION (Identify difference or changes between 2 batches of data.)
-- By using EXCEPT CLAUSE
-- EXCEPT CLAUSE also used to detect two db are same or not to prevent duplication

















