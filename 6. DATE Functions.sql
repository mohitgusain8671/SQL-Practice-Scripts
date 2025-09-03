-- ===========================================
-- MySQL Date Functions Reference
-- Using `sales` table as an example
-- ===========================================

-- 1. NOW() – Current date and time (YYYY-MM-DD HH:MM:SS)
SELECT NOW() AS current_datetime;

-- 2. CURDATE() – Current date only (YYYY-MM-DD)
SELECT CURDATE() AS curr_date;

-- 3. CURTIME() – Current time only (HH:MM:SS)
SELECT CURTIME() AS curr_time;

-- 4. DATE() – Extract date part from datetime
SELECT orderid,
       DATE(orderdate) AS order_date_only
FROM orders;

-- 5. EXTRACT() – Extract year, month, day etc. from date
SELECT orderid,
       EXTRACT(YEAR FROM orderdate) AS order_year,
       EXTRACT(MONTH FROM orderdate) AS order_month,
       EXTRACT(DAY FROM orderdate) AS order_day
FROM orders;

-- 6. DATE_ADD() – Add interval (days, months, years) to a date
SELECT orderid, orderdate,
       DATE_ADD(orderdate, INTERVAL 7 DAY) AS order_date_plus_7_days
FROM orders;

-- 7. DATE_SUB() – Subtract interval from a date
SELECT orderid, orderdate,
       DATE_SUB(orderdate, INTERVAL 3 DAY) AS order_date_minus_3_days
FROM orders;

-- 8. DATEDIFF() – Difference in days between two dates
-- Example: Days from sale_date until 2024-08-15
SELECT orderid, orderdate,
       DATEDIFF('2025-08-15', orderdate) AS days_until_aug15
FROM orders;

-- 9. DATE_FORMAT() – Format date in custom way
-- %W = weekday, %M = month name, %d = day, %Y = year
SELECT orderid, orderdate,
       DATE_FORMAT(orderdate, '%W, %M %d, %Y') AS formatted_sale_date
FROM orders;

-- 10. ADDDATE() – Same as DATE_ADD (alternative syntax)
SELECT orderid, orderdate,
       ADDDATE(orderdate, INTERVAL 10 DAY) AS order_date_plus_10_days
FROM orders;

-- 11. ADDTIME() – Add time (hours, minutes, seconds) to a time/datetime
SELECT orderid, orderdate,
       ADDTIME('10:30:00', '02:30:00') AS order_time_plus_2hrs_30min
FROM orders;

-- 12 ISDATE, CAST, CASE
-- BELOW STMT Won't work as ISDATE not a function in Mysql
select
	-- CAST(OrderDate as DATE) OrderDate,  throws error if not the standard format
	OrderDate,
    ISDATE(OrderDate),
    CASE WHEN ISDATE(OrderDate)=1 THEN CAST(OrderDate as DATE) 
    END NewOrderDate
FROM ( 
Select '2025-08-20' AS OrderDate UNION
Select '2025-07-20' UNION
Select '2025-08-22' UNION
Select '2025-08'
)t;
    
