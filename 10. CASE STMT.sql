/*CASE STATEMENT
The SQL CASE Expression
The CASE expression goes through conditions and returns a value when the first condition is met (like an if-then-else statement). 
So, once a condition is true, it will stop reading and return the result. If no conditions are true, it returns the value in the ELSE clause.
If there is no ELSE part and no conditions are true, it returns NULL.

CASE Syntax
CASE
    WHEN condition1 THEN result1
    WHEN condition2 THEN result2
    WHEN conditionN THEN resultN
    ELSE result
END;
*/

Select *, 
CASE WHEN score>=0 and score<300 then "LOW"
WHEN score>=300 && score<600 then "Medium"
WHEN score>=600 && score<900 then "HIGH"
WHEN score>=900 then "Ultra HIGH"
end as ScoreLabel,
CASE WHEN score>=0 and score<300 then "LOW"
WHEN score>=300 && score<600 then "Medium"
WHEN score>=600 && score<900 then "HIGH"
WHEN score>=900 then "Ultra HIGH"
else "Undefined"
end as ScoreLabelWithElse
from customers;

-- Used for
/*
i. Data Transformation --> derive new information from the given data
ii. Categorizing Data --> for classification
iii. Mapping Values
iv. Handling Null Values.
v. Conditional Aggregation --> Applying Aggregate function only on specific dataset
		e.g calculate how many time customer order with sales>30
        select customerid,
        SUM(case 
			when sales>30 then 1
            else 0
		end) TotalOrders
        From Orders Group by customerid order by customerid
*/

Select *,
CASE When sales > 50 then "High"
When sales>20 then "Medium"
When sales<=20 then "Low"
else "Undefined"
end as SalesType
from orders order by sales desc;

Select 
SUM(sales) as TotalSales,
CASE When sales > 50 then "High"
When sales>20 then "Medium"
When sales<=20 then "Low"
else "Undefined"
end as SalesType
from orders group by SalesType order by TotalSales DESC;

/*
Rules: 
Datatype of result must be matching of case stmt
It can be used anywhere in the query
*/


/* Quick form of CASE STMT if Conditon are equal operator and only one column
e.g CASE COUNTRY
		 WHEN 'GERMANY' THEN 'De'
         WHEN 'INDIA' THEN 'IN'
         WHEN 'United States' THEN 'US'
         ELSE 'NA'
	END as ShortForm
*/

select customerid,
        SUM(case 
			when sales>30 then 1
            else 0
		end) TotalOrdersGreater30,
        COUNT(*) totalOrders
        From Orders Group by customerid order by customerid;