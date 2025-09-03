-- STRING FUNCTIONS
-- MANIPULATIONS
	-- 1. CONCAT
    SELECT CONCAT(firstname," ",COALESCE(lastname,"")) as fullName from Customers;
    -- 2. UPPER and LOWER
    SELECT
		UPPER(CONCAT(firstname," ",COALESCE(lastname,""))) as fullName_CAPS, 
		LOWER(CONCAT(firstname," ",COALESCE(lastname,""))) as fullName_NOCAPS from customers;
	-- 3. TRIM IN SQL/SERVER WE HAVE LEN() function in MYSql we have LEN()
    select first_name,
		TRIM(first_name) as trimName, 
        LENGTH(first_name) as ogLen, LENGTH(TRIM(first_name)) as trimLen 
    from mydatabase.customers where first_name!=TRIM(first_name);
    -- 4. REPLACE--> replace speecific character with some new character
    -- Remove dashes
    Select '123-456-7890' as phone, replace('123-456-7890','-','/t') as cleaned;
    -- replace file extension
    Select 'file.txt' as oldFile, replace('file.txt','.txt','.csv') as newFile;
-- CALCULATIONS
	-- LEN or LENGTH
    Select firstname, LENGTH(firstname) as firstName_length from customers;
-- EXTRACTION
	-- 1. LEFT --> Extract Specific number of character from start of string
    -- 2. RIGHT --> Extract Specific number of character from end of string
    Select firstname, RIGHT(firstname,3) as last_3_characters, LEFT(firstname,3) as first_3_characters from customers;
    -- 3. SUBSTRING --> Extract part of specified string from the given string
    -- take 3 value --> given String, start, length // length is optional if not then return till length
    select firstname, substring(firstname,2) as SUBSTR_FROM_2ndCharacter from customers;
    
    select firstname, substring(firstname,2,3) as SUBSTR_LEN_3_FROM_2ndCharacter from customers;
    