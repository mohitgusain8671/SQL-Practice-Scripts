use MyDatabase;
-- This is a comment
/* This is a
multiple line comment */
-- Select Statement 
Select * from Customers;
select * from Orders;
Select order_id, sales from Orders;
Select * from Orders where sales>15;
Select * from Customers where country='Germany';
Select first_name, country from Customers where country!='Germany';
Select * from Customers order by score;	
Select * from Customers order by score DESC;	
Select * from Customers order by country ASC, score DESC; -- if we write only DESC at last it sort last col as DESC other as ASC
SELECT SUM(score) AS totalScore, country FROM Customers GROUP BY Country;
SELECT SUM(score) AS totalScore,COUNT(*) AS TotalCustomers,country FROM Customers GROUP BY Country; 
SELECT SUM(score) AS totalScore, COUNT(*) AS TotalCustomers, country FROM Customers GROUP BY Country HAVING TotalCustomers > 1 AND totalScore > 850; 
SELECT Country, SUM(score) AS totalScore,COUNT(*) AS totalCustomers FROM Customers WHERE score > 400 GROUP BY COUNTRY HAVING totalScore > 430;
-- Get Unique Data 
Select distinct(country) from Customers;
-- Limit the entries
Select * from Customers order by score DESC limit 2;
-- order of coding
-- select, distinct, from, where, group by, having, order by, limit
-- filter by columns, filter duplicates, filter table, filter rows before aggregation, aggregate the data, filter aggregate data, sort data, filter number of rows

-- order of execcution (BTS)
-- FROM, WHERE, GROUP BY, HAVING, SELECT, DISTINCT, ORDER BY, LIMIT

-- Static Values;
Select id, 'New Customer' as CustomerType from Customers;

-- DDL
CREATE TABLE Persons (
	id INT NOT NULL,
    name VARCHAR(50) NOT NULL,
    birth_date DATE,
    phone VARCHAR(15) NOT NULL,
    constraint pk_persons PRIMARY KEY (id)
);
ALTER Table Persons ADD COLUMN EMAIL VARCHAR(100) NOT NULL UNIQUE;
INSERT INTO PERSONS (id,name, phone, EMAIL) values (1,'MOHIT', '9667897066','mohitgusain8671@gmail.com');
Select * from Persons;
drop table persons;

INSERT INTO Persons (id,name,birth_Date, phone)
Select id, first_name,NULL, 'Unknown' FROM Customers;

UPDATE Persons set phone='9667897066' WHERE name = 'Maria' LIMIT 1;
UPDATE Persons set phone='9667797066' WHERE id = 4;
-- My SQL won't allow without limit to execute update and delete command in safe mode using non-key attribute in where
delete from persons where name='Maria' limit 1;
truncate table persons;