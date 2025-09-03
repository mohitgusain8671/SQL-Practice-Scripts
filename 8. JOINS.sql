-- JOINS IN SQL
use MyDatabase;
Select c.id, c.first_name, o.order_id, o.sales, c.country, o.order_date from Customers c INNER JOIN Orders o on c.id=o.customer_id;
Select c.id, c.first_name, o.order_id, o.sales from Customers c LEFT JOIN Orders o on c.id=o.customer_id;
Select c.id, c.first_name, o.order_id, o.sales from Customers c RIGHT JOIN Orders o on c.id=o.customer_id;
-- MySQL doesn't support FULL OUTER JOIN
-- Select c.id, c.first_name, o.order_id, o.sales from Customers c FULL JOIN Orders o on c.id=o.customer_id;
-- so we can use union between right and left JOIN
Select c.id, c.first_name, o.order_id, o.sales from Customers c LEFT JOIN Orders o on c.id=o.customer_id
UNION
Select c.id, c.first_name, o.order_id, o.sales from Customers c RIGHT JOIN Orders o on c.id=o.customer_id;

-- ADVANCED JOINS
-- LEFT ANTI JOINS Returns all unmatched data of left table
select * from Customers c LEFT JOIN Orders o on c.id=o.customer_id where o.customer_id IS NULL;
-- Right ANTI JOINS Returns all unmatched data of right table
select * from Customers c RIGHT JOIN Orders o on c.id=o.customer_id where c.id IS NULL;
-- FULL ANTI JOIN BOTH TABLES UNMATCHED DATA
-- using full join and then where clause with c.key IS NULL or b.key is NULL
-- below is using UNION of Left Anti and/right Anti
Select c.id, c.first_name, o.order_id, o.sales from Customers c LEFT JOIN Orders o on c.id=o.customer_id where o.customer_id is null
UNION
Select c.id, c.first_name, o.order_id, o.sales from Customers c RIGHT JOIN Orders o on c.id=o.customer_id WHERE c.id IS NULL;

-- GET MATCHED DATA without using INNER JOIN
Select * from Customers as c LEFT JOIN Orders as o on c.id=o.customer_id where o.order_id IS NOT NULL;

-- CROSS JOIN Combine every row from left with every row from right. i.e ALL Possible combinations - CARTESIAN JOINT
SELECT * from Customers Cross JOIN Orders;

use salesdb;
Select * from orders;
SELECT 
  TRIM(CONCAT(COALESCE(c.firstname, ''), ' ', COALESCE(c.lastname, ''))) AS CustomerName,
  o.orderid,
  p.product,
  p.price,
  o.sales,
  TRIM(CONCAT(COALESCE(e.firstname, ''), ' ', COALESCE(e.lastname, ''))) AS SalesPersonName
FROM Customers c 
RIGHT JOIN Orders o ON c.customerid = o.customerid 
JOIN Products p ON o.productid = p.productid
JOIN Employees e ON o.salespersonid = e.employeeid;




