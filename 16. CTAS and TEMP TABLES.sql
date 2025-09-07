/*
	TABLE - Structured Collection of Data.
    Types of Table
		1. Permanent Table: Remin Untill we dropped it
			--> By USing CREATE / SELECT and CTAS
					CREATE / INSERT											CTAS
            Create | Define Structure of table.			Create Table as Select create new table based on select query.
            Insert Data into the table
            
					CTAS 																	VIEWS
		We Store the Result of Query										We Store the Query Not the Result.
		User Query Directly use the result of CTE Query Stored in DB		if User Query using VIEW then it first execute view query and then User Query.
		It is Faster.														It is Slower.
		It Shows The Older Data.											Provide Updated Data From View Query.
        
        CTAS SYNTAX :  
			A. CREATE TABLE tab-name (col1 d1 size, ..... )       --DDL COMMAND
            B. CTAS: Create Table Name AS ( QUERY )
		USE CASES OF CTAS
			a. Creating Snapshots of Data
            b. Faster
            c. Physical Data marts in DWH for Faster Retrieval.
        2. Temporary Tables:
			--> Stores Intermediate Results in temporary storage within DB during the session
            --> The DB drop all temporary table once the session end.
            Session is the time between Connecting to and Disconnection from Database
            SYNTAX: (IN  SQL SERVER)
				Select ....
                INTO #(NEW_TABLe)
                FROM ... WHERE...
*/
-- Total Number of orders per MONTH
use salesdb;
CREATE TABLE CTE_First AS (
SELECT 
	MONTHNAME(orderdate) OrderMonth,
    COUNT(orderid) TotalOrders,
    SUM(sales) TotalSales
from orders group by MONTHNAME(orderdate)
);
select OrderMonth, TotalOrders from CTE_First;
drop table CTE_First;

-- Temporary Tables
CREATE TEMPORARY TABLE temp_orders LIKE orders;
drop temporary table temp_orders;
CREATE TEMPORARY TABLE temp_orders as (select * from orders);
select * from temp_orders;

-- CTAS ARE CREATED IN THE USER Space in DISK STORAGE
-- Temporary tables stored in TEMP Space in DISK STORAGe
-- Temporary table can used to perform task which might can cause data loss or changes in original data
-- Automatic CLeanup in TEMP TABLEs when current session ends

/*
	Extract data from OG TABLE STORE IN TEMP
    Perform Transformation in TEMP if everything good
    Load into Permanent table
