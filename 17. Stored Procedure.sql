/* Stored Procedure
	-> A Stored Procedure is a precompiled collection of SQL statements (queries, conditions, loops, etc.) 
    -> It is stored in the database. 
    -> Instead of writing the same SQL queries repeatedly, we can store them once as a procedure and 
    just call the procedure whenever needed.
	-> it is like a function in programming that performs a specific task in the database
    Syntax:
		CREATE PROCEDURE procedure_name as 
			BEGIN
				-- sql stmts
			END
	InSql Server
		EXEC procerdure_name;
	in MYSQL
		 CALL procerdure_name();
         
	PARAMETERS:
	-> Placeholders used to pass values as input from the caller to the procedure allwing dynamic data to be processed.
    1. MySQL Stored Procedure Parameters
		In MySQL, when you define parameters, we must specify their mode:
		IN → input parameter (default)
		OUT → output parameter
		INOUT → works as both input and output
		Example: MySQL
			DELIMITER //
			CREATE PROCEDURE GetCustomerDetailsByCountry (
				IN countryName VARCHAR(50),     -- input parameter
				OUT totalCustomers INT          -- output parameter
			)
			BEGIN
				SELECT COUNT(*) 
				INTO totalCustomers
				FROM customers
				WHERE country = countryName;
			END //
			DELIMITER ;
		Call it like this:
			CALL GetCustomerDetailsByCountry('USA', @total);
			SELECT @total;   -- shows the output value

		2. SQL Server (T-SQL) Stored Procedure Parameters
		In SQL Server, parameters are always declared with a name (starting with @) and a datatype.
		Output parameters must be marked with OUTPUT.
		Example: SQL Server
			CREATE PROCEDURE GetCustomerDetailsByCountry
				@CountryName NVARCHAR(50),          -- input parameter
				@TotalCustomers INT OUTPUT          -- output parameter
			AS
			BEGIN
				SELECT @TotalCustomers = COUNT(*)
				FROM customers
				WHERE country = @CountryName;
			END;
		Execute it like this:
			DECLARE @Total INT;
			EXEC GetCustomerDetailsByCountry @CountryName = 'USA', @TotalCustomers = @Total OUTPUT;
			PRINT @Total;  -- displays result
*/
use salesdb;
-- SYNTAX OF MYSQL
DELIMITER //
CREATE PROCEDURE GetUSACustomerDetails()
BEGIN
    SELECT COUNT(*) AS TotalCustomers, AVG(score) AS AvgScores
    FROM customers
    WHERE country = 'USA';
END //
DELIMITER ;
CALL GetUSACustomerDetails();

-- PAram Stored Procedure
drop procedure GetCustomerDetailsByCountry;
DELIMITER //
CREATE PROCEDURE GetCustomerDetailsByCountry (
    IN countryName VARCHAR(50)
)
BEGIN
    SELECT COUNT(*) AS TotalCustomers, AVG(score) AS AvgScores
    FROM customers
    WHERE country COLLATE utf8mb4_unicode_ci = countryName COLLATE utf8mb4_unicode_ci;
END //
DELIMITER ;
CALL GetCustomerDetailsByCountry('USA');
CALL GetCustomerDetailsByCountry('GERMANY');

-- Output Params
DELIMITER //
CREATE PROCEDURE GetCustomerCountByCountry ( 
	IN countryName VARCHAR(50), -- input parameter 
	OUT totalCustomers INT -- output parameter 
) 
BEGIN 
SELECT 
	COUNT(*) Into TotalCustomers
FROM customers 
WHERE country COLLATE utf8mb4_unicode_ci = countryName COLLATE utf8mb4_unicode_ci; 
END // DELIMITER ; 
CALL GetCustomerCountByCountry('GERMANY',@total);
SELECT @total;   -- shows the output value

-- Alter Procedure in MYSQL
DROP PROCEDURE IF EXISTS GetCustomerDetailsByCountry;
DELIMITER //
CREATE PROCEDURE GetCustomerDetailsByCountry(IN countryName VARCHAR(50))
BEGIN
    SELECT * FROM customers WHERE country = countryName;
END //
DELIMITER ;
-- in SQL SERVEr
/*
ALTER PROCEDURE procedure_name 
    [parameters...]
AS
BEGIN
    -- procedure body
END;
*/

/*
 We can use IF ELSE INSIDE IT SP
 e.g create procedure name()
	BEGIN
		IF CONDITON
			BEGIN
            .....
            END
        ELSE 
			BEGIN 
			END...
        BEGIN TRY
			...
        END TRY
        BEGIN CATCH
			...
        END CATCH
*/
