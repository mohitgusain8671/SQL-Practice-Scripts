-- NUMERIC FUNCTIONS
-- 1. ROUND --> ROUND(num,decimalPlaces)
	  -- 0 means before decimal , 1 means to one decimal in sql it rounds based on number next to that decimal place if its greater than 5 it increase the number
      Select 3.516 as OG, ROUND(3.516,2) as UPTO_2, ROUND(3.516,1) as UPTO_1, ROUND(3.516,0) as UPTO_0, ROUND(3.516,-1) as UPTO_NEG_1;
-- 2. ABS --> Return only magnitude of number
	Select -10 as Negative, ABS(-10) as ABS_NEG, 10 as Pos, ABS(10) as ABS_POS;
-- 3. CEIL() or CEILING() – Round number UP to nearest integer
-- Always rounds up, even if decimal < 0.5
SELECT CEIL(12.34)   AS ceil_example1,   -- 13
       CEIL(12.98)   AS ceil_example2;   -- 13

-- 4. TRUNCATE() – Cut decimal places WITHOUT rounding
-- Syntax: TRUNCATE(number, decimal_places)
SELECT TRUNCATE(12.98765, 2) AS truncate_example1,  -- 12.98
       TRUNCATE(12.98765, 0) AS truncate_example2;  -- 12

-- 5. MOD() – Modulus (remainder of division)
-- Syntax: MOD(dividend, divisor)
SELECT MOD(10, 3) AS mod_example1,   -- 1
       MOD(25, 7) AS mod_example2;   -- 4

-- 6. POWER() – Raise a number to a power
-- Syntax: POWER(base, exponent)
SELECT POWER(2, 3) AS power_example1,   -- 8
       POWER(5, 2) AS power_example2;   -- 25

-- 7. SQRT() – Square root
-- Syntax: SQRT(number)
SELECT SQRT(16) AS sqrt_example1,    -- 4
       SQRT(81) AS sqrt_example2;    -- 9

-- 8. EXP() – Exponential function (e^x)
-- Syntax: EXP(number)
SELECT EXP(1) AS exp_example1,      -- 2.718...
       EXP(2) AS exp_example2;      -- 7.389...

-- 9. LOG() – Natural logarithm (base e) or custom base
-- Syntax: LOG(number) or LOG(base, number)
SELECT LOG(100)        AS log_natural,  -- 4.605 (ln 100)
       LOG(10, 100)    AS log_base10;   -- 2 (log10(100))

-- 10. RAND() – Generate random number between 0 and 1
-- Syntax: RAND() or RAND(seed)
SELECT RAND()        AS rand_example1,
       RAND(42)      AS rand_with_seed;  -- deterministic output with seed
       
-- 11. FLOOR() – Round number DOWN to nearest integer
-- Always drops decimal part
SELECT FLOOR(12.98)  AS floor_example1,  -- 12
       FLOOR(12.01)  AS floor_example2;  -- 12