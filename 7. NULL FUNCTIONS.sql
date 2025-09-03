-- NULL FUNCTIONS
-- NULL means Nothing, unknown
-- NULL Not equals to anything. Null is neihter a zero nor empty string and nor a blank space.

-- Replace
	-- 1. Replace NULL with Values
		-- using IFNULL(val,repValue)  --> in sql server we have ISNULL(val,rep)
        -- Limited to Two Values, FAST, IN SQL Server -> ISNULL, In Oracle -> NVL 
        select isnull(lastname) as isValid, lastname, IFNULL(lastname,"N/A") as modified from Customers;
        
        -- using COALESCE(expr1, expr2, ...)  it returns first non-null value
        -- unlimited param, slow, available in all DB
		select coalesce(lastname, firstname, 'undefined') as lastname_of_fullname, firstname, lastname from Customers;
-- Check if Null Exists
	-- IS NULL
    Select * from customers where score is null or lastname is null;
    -- IS NOT NULL
    Select * from customers where score is not null and lastname is not null;
-- NULLIF(expr1, expr2)
-- Compares two expressions.
-- If they are equal, it returns NULL.
-- If they are not equal, it returns the first expression.

SELECT NULLIF(5, 5);   -- returns NULL  (because both are equal)
SELECT NULLIF(5, 10);  -- returns 5     (because they are not equal)
SELECT NULLIF('abc', 'abc'); -- returns NULL
SELECT NULLIF('abc', 'xyz'); -- returns 'abc'

-- Use Cases
	-- Avoiding division by zero
	SELECT 100 / NULLIF(0, 0);  -- returns NULL instead of error
	SELECT 100 / NULLIF(5, 0);  -- returns 20

	-- Conditional NULL replacement
	-- If CustomerName = 'Unknown', return NULL, otherwise return the name
	SELECT NULLIF(CustomerName, 'Unknown') AS CleanName
	FROM Customers;

-- TASKS Find Avg scores of customers
Select customerid, score from customers;
Select customerid, score,
 avg(score) OVER () AvgScores,
 avg(coalesce(score,0)) OVER () AvgScoresWithoutNull
 from customers;
 
 -- sort customers based on scores
 select * from customers order by coalesce(score,100000000);  -- unprofessional way
 
 Select customerid, score, case when score is null then 1 else 0 end as flag from customers order by flag, score desc;
 
 
 /*
						NULL       Empty String          Blank Space
 representation    		null			""					'  '
 Meaning 			   unkonwn	 Known, empty value      Known, space
 Data type 			   marker		String(0)			  String(1+)
 Storage			very minimal    occupy memory	 each space occupy memory
 Performance			best			fast				slow
 comparison           is null             = 				 =
 */