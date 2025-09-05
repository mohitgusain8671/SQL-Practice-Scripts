/* VIEWS
	Database has 3 Level of Archtitecture
    1. Physical Level: 
			-> DATA STORED IN PHHYSICAL LEVEL, 
			-> DBA has Access to its
            -> How data is actually stored on disk. (Lowest Abstraction)
	2. Logical Level: 
			-> How to organize data
            -> What data is stored, and the relationships among data.
            -> App Developers has acces to its
	3. View Level:
			-> The highest level, closest to the end users.
            -> Different views of the database for different users. (Highest Abstraction)
	WHAT IS VIEW: 
		-> Virtual Table based on result set of query without storing data in db. 
        -> Views are Persisted Sql Queries in DB
        -> Views are Abstraction layer between User and Real-Data.
	Diff. Between VIEWS and Table: 
				VIEWS 							TABLE
			No Persistance.					Persisted Data
            Easy to Maintain				Hard to Maintain
            Slow Response 					Fast Response
            Read Only						Read / Write
	Diff. Between VIEWS and CTE 
				VIEWS 													CTE
			Reduce Redundancy in Multiple Query				Reduce Redundancy in 1 Query
            Improves Reusability in Multiple Query			Improves Reusability in 1 Query
			Persisted Logic									Temporary logic
            Need Maintenance (Create/DROP)					No Maintenance (Auto Cleanup)
	CREATE SYNTAX:
		CREATE VIEW view-name AS ( Query )
	Drop Syntax:
		DROP VIEW view_name;
	Update VIEW:
		CREATE OR REPLACE VIEW view-name as (QUERY)
*/
-- Find Running total sales for each MONTH
use salesdb;
drop view MonthlySales;
CREATE or Replace VIEW MonthlySales as (
Select 
	Extract(month from orderdate) as orderMonth, 
	SUM(sales) as totalSales, 
    COUNT(orderid) as totalOrders,
    SUM(quantity) as totalQuantity,
    AVG(sales) as AverageSales
from orders group by orderMonth
);    
select orderMonth, totalSales from MonthlySales;
select orderMonth, AverageSales from MonthlySales;


/* HOW VIEW EXECUTE BY DB
	 1. VIEW QUERY SENT TO DB ENGINE
	 2. DB ENGINE STORE META DATA ABOUT VIEW and THE QUERY OF VIEW IN CATALOG in the disk storage
	 3. Whenever View Get accessed by the User it first execute view and then the query of User using the result of view
     
	 DROP VIEW 
     1. It remove metadata and the query stored in catalog of the view
*/

/* USE CASES OF VIEW
	1. Views can be used to hides the complexity and DB tables. and offers more user friendly and easy to consume objects.
    2. Use View to enforce Security and Protect Sensitive data by hiding columns and/or rows from tables
    3. More Flexibility and dynamic
    4. Store Central complex business Logic to be reused
    5. Offer Multiple Languages
    6. Virtaul Layers in Data Warehouse
*/

select * from orders;
select * from employees;
-- Provide View that combine details from orders, products, customers, and employees.
CREATE OR REPLACE VIEW ALLJOINED as (
select o.orderid, o.sales as OrderAmount,
	c.customerid, c.firstname as CustomerName,
    p.productid, p.product as ProductName, p.price as ProductPrice, 
    e.employeeid, e.firstname as EmployeeName, e.department
from orders o JOIN customers c on o.customerid = c.customerid
JOIN products p on o.productid = p.productid JOIN
employees e on o.salespersonid = e.employeeid
ORDER BY o.orderid
);
CREATE OR REPLACE VIEW ALLSecuredJOINED as (
select o.orderid, o.sales as OrderAmount,
	c.customerid, c.firstname as CustomerName, c.country,
    p.productid, p.product as ProductName, p.price as ProductPrice, 
    e.employeeid, e.firstname as EmployeeName, e.department
from orders o JOIN customers c on o.customerid = c.customerid
JOIN products p on o.productid = p.productid JOIN
employees e on o.salespersonid = e.employeeid
where c.country != 'USA'
ORDER BY o.orderid 
);

            
    
    