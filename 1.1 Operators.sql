-- Where Operators
/*
1. Comparison Operators (compare 2 values) : =,<> or =!, >,<,>=,<=
2. logical Operators : AND, OR,NOT
3. Range Operators: Between
4. Membership: IN, NOT IN
5. Search Operator :  LIKE
*/
/* Comparison Operator
	 expr1 operator expr2
	 col1 op col2   	---> e.g  firstName = lastName
	 col1 op value  	---> e.g firstName = 'John'
	 Function op value  ---> e.g UPPER(firstName) = 'JOHN'
	 expressionop value ---> e.g price*quantity > 1000
     subquery = value   ---> Advanced topic
*/
Select * from Customers where country <> 'Germany';
Select * from Customers where country = 'Germany';
Select * from Customers where score > 500;
Select * from Customers where score < 500;
Select * from Customers where score >= 350;
Select * from Customers where score <= 750;

/* Logical Operator
  Combine Two Condition
  con1 op con2       -->    op -> [AND,OR,NOT]
*/

Select * from Customers where country = 'Germany' or score >400;
Select * from Customers where country = 'Germany' and score >400;
Select * from Customers where not (country = 'Germany' and score > 400);
/* RANGE OPERATOR BETWEEN */
Select * from Customers where score between 400 and 600; -- boundary inclusive
Select * from Customers where score not between 400 and 600;
/* Membership Operator 
 IN --> Check if value exist in list
 NOT IN --> opposite of IN
*/
Select * from Customers where country in ('Germany', 'UK');
Select * from Customers where country not in ('Germany', 'UK');
/* Search Operator 
Like -> for Pattern Searching
% --> any characters and any no.s of characters
_ --> any single character
// below format not support in MYSQL, Postgre but in  SQL server and Sqllite
[xyz....]  --> any single character ffrom the given list only
*/
Select * from Customers where first_name LIKE 'M%';
Select * from Customers where first_name LIKE '%r%';
Select * from Customers where first_name LIKE '_a%' or first_name Like '_e%';
