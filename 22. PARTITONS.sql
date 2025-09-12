/* SQL PARTITIONING
	DIVIDES BIG TABLE INTO SMALLER PARTITIONS
    While it Still being treated as a Single Logical Table.
    E.G 						|BIG TABLE	|
           DATA OF YEAR 2023	|			|------------>|---------|
           (1st Partiton)		|			|			  |			|
           ---------------------|-----------|			  |	SINGLE	|
           Data of Year 2024	|			|------------>|	TABLE   |--->   USER
           (2nd PArtition)		|			|			  |			|
           ---------------------|-----------|			  |			|
           Data of Year 2025	|			|			  |			|
           (3rd Partition)		|			|			  |			|
           (Its is Most 		|			|------------>|---------|
           Frequently Used)		|			|
           ----------------------------------
	USE CASES:
		1. Parallel Processing each Partiton BY CPU INDEPENDENTLY.
        2. 
	
    -- Creating Partiton:
    LEVEL1 - PARTITION FUNCTION
    LEVEL2 - Partition Scheme
    LEVEL3 - File Groups
    LEVEL4 - DATA FILES
		1. Define Partiton Function: Defines Logic How to divide data into partitions.
			Based on Partition Key Like (Column, Region)
				E.G Using Year (Boundaries are the value from which we decide partition here is last date of year)
					<---------------------|--------------------|---------------------|--------------------->
									2023-12-31			2024-12-31				2025-12-31
					<----Partition-1------|----Partition-2-----|-----Partition-3-----|----Partition-4------|
					ROWS FOR 2023 			Rows for 2024		Rows for 2025			Rows for 2026
					& earlier Year
			Boundary Belong to which partiton is defined BY Logic Left and Logic Right.
				- Logic Left means Boundary belong to Left PArtition and 
                - Logic Right Means Boundary belong to Right Partition.
			SYNTAX:
				CREATE PARTITION FUNCTION func_name (column(DATE)) 
                AS RANGE [LEFT | RIGHT]  FOR VALUES ('B1','B2', 'B3', .... );
		2. FILE GROUPS: Logical Container of one or more data files to help organize partitions.
        3. Data Files: Contains Actually data.
			-- Create File Group
				ALTER DATABASE MyDB 
				ADD FILEGROUP FG2022;
			-- Add data Files
				ALTER DATABASE MyDB 
				ADD FILE (
					NAME = N'Data2022',
					FILENAME = 'D:\SQLData\Data2022.ndf',
					SIZE = 5MB,
					MAXSIZE = UNLIMITED,
					FILEGROWTH = 5MB
				) TO FILEGROUP FG2022;
		4. Create Partition Scheme
				SYNTAX:
					CREATE PARTITION SCHEME partiton_scheme_name
					AS PARTITION pf_name
					TO ([PRIMARY], FG2022, FG2023, FG2024);
		5. Create Table on Partition Scheme
			CREATE TABLE Orders (
				OrderID INT PRIMARY KEY,
				OrderDate DATE NOT NULL,
				Sales DECIMAL(10,2),
				CustomerID INT
			) ON partiton_scheme_name(OrderDate);
		6. Insert Data in Partitioned TABLE.


*/
use temp;
CREATE TABLE orders (
    id INT NOT NULL,
    order_date DATE NOT NULL,
    sales DECIMAL(10,2),
    customerid INT,
    PRIMARY KEY(id, order_date)
)
PARTITION BY RANGE (YEAR(order_date)) (
    PARTITION p0 VALUES LESS THAN (2022),
    PARTITION p1 VALUES LESS THAN (2023),
    PARTITION p2 VALUES LESS THAN (2024),
    PARTITION pmax VALUES LESS THAN MAXVALUE
);

SELECT
    partition_name,
    table_rows
FROM information_schema.partitions
WHERE table_schema = DATABASE()
  AND table_name = 'orders';

select * from orders where order_date='2025-01-12';  -- scan only 20 rows not 40 due to partition

-- MY SQL DOESN't HAVE PARTITON FUNCTION My SQL offer Partitoning at table level inside create table or alter table.
-- MySQL → doesn’t support File Groups. You define partitioning only inside the table.
/*
	Key Differences:
		1. No separate PARTITION FUNCTION or PARTITION SCHEME objects in MySQL.
		2. Partition definition is inline with table creation.
		3. MySQL requires the partitioning key to be part of all unique / primary keys.
		4. We can partition by:
			RANGE (good for dates),
			LIST,
			HASH,
			KEY.
*/
INSERT INTO orders (id, order_date, sales, customerid) VALUES
(1,  '2021-12-15', 100.50, 101),
(2,  '2022-01-05', 200.00, 102),
(3,  '2022-02-14', 150.25, 103),
(4,  '2022-03-01', 75.00, 104),
(5,  '2022-04-22', 300.00, 105),
(6,  '2022-05-30', 120.00, 106),
(7,  '2022-06-10', 220.50, 107),
(8,  '2022-07-19', 185.00, 108),
(9,  '2022-08-03', 90.00, 109),
(10, '2022-09-12', 250.75, 110),

(11, '2023-01-02', 400.00, 111),
(12, '2023-02-20', 330.25, 112),
(13, '2023-03-15', 150.00, 113),
(14, '2023-04-05', 210.40, 114),
(15, '2023-05-28', 500.00, 115),
(16, '2023-06-11', 180.00, 116),
(17, '2023-07-25', 275.00, 117),
(18, '2023-08-14', 90.50, 118),
(19, '2023-09-01', 320.00, 119),
(20, '2023-12-31', 410.10, 120),

(21, '2024-01-10', 600.00, 121),
(22, '2024-02-18', 95.00, 122),
(23, '2024-03-30', 450.50, 123),
(24, '2024-04-25', 300.00, 124),
(25, '2024-05-15', 125.75, 125),
(26, '2024-06-20', 270.00, 126),
(27, '2024-07-09', 150.25, 127),
(28, '2024-08-22', 190.00, 128),
(29, '2024-09-18', 340.00, 129),
(30, '2024-11-05', 500.00, 130),

(31, '2025-01-12', 720.50, 131),
(32, '2025-02-17', 260.00, 132),
(33, '2025-03-21', 315.25, 133),
(34, '2025-04-10', 405.00, 134),
(35, '2025-05-19', 195.00, 135),
(36, '2025-06-08', 285.50, 136),
(37, '2025-07-16', 375.00, 137),
(38, '2025-08-25', 455.75, 138),
(39, '2025-09-30', 525.00, 139),
(40, '2025-12-20', 610.00, 140);