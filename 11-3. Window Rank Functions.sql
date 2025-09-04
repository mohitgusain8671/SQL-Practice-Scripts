/* Window Ranking Functions
	- Rank Products or rows bbased on the value of some column
    - Ranking first require sorting the data
    - Ranking type:
		a. Integer Based Ranking: Assigning Integer value to each rows. (Discrete Values)
        b. Percentage Based Ranking: Assigning Percentage to each rows. (Lies Between 0 and 1) (Continous)
	- Percentage Based analysis used for distribution analysis like finding Top 20% product.
    - Integer Based Ranking used for top/bottom analysis like find top 3 products.

	- Integer Based Ranking Functions
    USE CASE : TOP/Bottom N-Analysis, Assign Unique Ids, Identify duplicates
		a. ROW_NUMBER() : Assign a Unique number to each row in a window. and don't handle ties
			-> Expression is empty
            -> Partition is Optional and Order by is required.
            -> Frame Clause Not allowed.
        b. RANK(): Assign a rank to each row in a window with gaps (i.e if two rows ties and assigned as 1 then next row assigned 3)
			-> Expression is empty
            -> Partition is Optional and Order by is required.
            -> Frame Clause Not allowed.
        c. DENSE_RANK() : Assign a rank to each row in a window without gaps
			-> Expression is empty
            -> Partition is Optional and Order by is required.
            -> Frame Clause Not allowed.
        d. NTILE() : Divides Rows into specified number of approximately equal groups
			-> Expression must be a number
            -> Partition is Optional and Order by is required.
            -> Frame Clause Not allowed.
            --> Used for 
				i. datasegementation (Divide dataset into distinct subset based on certain criteria)
            and ii. equalizing load processing
	
    - Percentage Based Ranking:
		a. CUME_DIST() : calculates the cumulative distribution of a value within a set of values.
			-> Expression is empty
            -> Partition is Optional and Order by is required.
            -> Frame Clause Not allowed.
        b. PERCENT_RANK() : Return Percentile ranking number of a row
			-> Expression is empty
            -> Partition is Optional and Order by is required.
            -> Frame Clause Not allowed.
        
*/
use salesdb;
-- RANK ORDER BASED ON THEIR SALES FROM HIGH TO LOW
Select orderid, productid, sales, orderdate,
row_number() OVER(Order by sales desc) as ROW_NUMBER_RANK from orders;

-- RANK ORDER BASED ON THEIR SALES FROM HIGH TO LOW (Assign Same Rank for tie with gaps)
Select orderid, productid, sales, orderdate,
row_number() OVER(Order by sales desc) as ROW_NUMBER_RANK,
RANK() OVER(Order by sales desc) as RANK_USING_RANK
from orders;

-- RANK ORDER BASED ON THEIR SALES FROM HIGH TO LOW (Assign Same Rank for tie without gaps)
Select orderid, productid, sales,
row_number() OVER(Order by sales desc) as ROW_NUMBER_RANK,
RANK() OVER(Order by sales desc) as RANK_USING_RANK,
dense_rank() OVER(Order by sales desc) as DENSE_RANK_FX 
from orders;

-- FIND TOP HIGHEST SALES OF EACH PRODUCT
Select * from (
Select  orderid, productid, sales,
row_number() OVER(partition by productid order by sales desc) as ROW_NUMBER_RANK
from orders)t where ROW_NUMBER_RANK = 1;

-- FIND 2 Lowest Customer Based on their total sales
Select customerid, SUM(sales) TOTALSALES,
row_number() OVER(Order by SUM(sales)) as SalesRank_ROW
from orders group by customerid limit 2;

-- ASSIGN UNIQUE IDS to the Rows of the Order Archive tables
Select *, ROW_NUMBER() OVER(order by orderid) UniqueID from orders_archive;

-- Identify Duplicate rows in order archive and return clean data
-- Rank based on PK if there are other than 1 on rank i.e duplicates
Select * from (
Select *, row_number() OVER(partition by orderid order by creationtime DESC) rn
from orders_Archive) t where rn=1;

-- NTILES
-- NTILE(n) OVER (ORDER BY col) splits rows into n buckets
-- Bucket size = floor(total_rows / n)
-- Remainder = total_rows % n
-- The first 'remainder' buckets get 1 extra row
-- Remaining buckets get the base size
Select orderid, sales, NTILE(1) OVER(order by sales Desc) OneBucket, -- every bucket 1
NTILE(2) OVER(order by sales Desc) TwoBucket, -- two bucket of equal size 5
NTILE(3) OVER(order by sales Desc) ThreeBucket, -- three bucket first bucket 4 rest 3
NTILE(4) OVER(order by sales Desc) fourBucket -- four buckets first 2 bucket contain 3 rows and rest 2 contain 2 rows
from orders;
-- use case 1 data segementation 
-- divide order into 3 category high, med ,low sales
Select *, 
	CASE WHEN Buckets = 1 then 'HIGH' 
		WHEN Buckets = 2 then 'MED' 
		WHEN Buckets = 3 then 'LOW'
	END Segements from (
Select orderid, sales, ntile(3) OVER(Order by sales desc) as Buckets from orders)t;

/* Percentage Based Ranking
	1. CUME_DIST:
		--> Formula = Position Number / No. of Rows 
        --> Calculates Distribution of datapoints within a window
        --> On Tie in PositionNo. it takes the last occuerence
        --> It includes current row
        e.g SALES -->  100 		, 	80 	  , 	80	, 	50	  , 	30       (ORDER BY DESC)
		CUME_DIST -->  1/5(0.2) , 3/5(0.6), 3/5(0.6), 4/5(0.8), 5/5(1)
    2. PERCENT_RANK 
		--> Formula = Position Nr - 1 / No.of rows - 1
        --> On Tie in PositionNo. it takes the first occuerence
        --> It Excludes Current Row
        e.g SALES -->  100 		, 	80 	  , 	80	, 	50	  , 	30       (ORDER BY DESC)
		CUME_DIST -->  0/4(0) , 1/4(0.25), 1/4(0.25), 3/4(0.75), 4/4(1)
*/
Select orderid, sales,
cume_dist() OVER(order by sales desc) as CumeRANK,
percent_rank() OVER(order by sales desc) as PercentANK from orders;

-- Find Rpoduct fall within highest 40% of product
select *, distRank * 100 as Percent from (
Select product, price,
cume_dist() OVER(Order by price DESC) distRank from products)t
where distRank <=0.4;