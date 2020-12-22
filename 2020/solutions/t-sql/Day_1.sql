---------------------------------------------
-- Author:			Elaine Lin
-- Created Date:	2020-12-22
-- References Used:
--	https://www.mssqltips.com/sqlservertip/6109/bulk-insert-data-into-sql-server/
--	https://stackoverflow.com/questions/57524470/split-bulkcolumn-into-rows
---------------------------------------------

DROP TABLE IF EXISTS #Day_1
CREATE TABLE #Day_1
	(
	Number INT
	)

BULK INSERT #Day_1
FROM '.....\advent-of-code\2020\inputs\Day_1.txt'
WITH
	(
    FIRSTROW = 1,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n'
	);

---------------------------------------------
-- Part 1
---------------------------------------------
SELECT
	d1.Number
	,d2.Number
	,(d1.Number*d2.Number) AS Answer
FROM
	#Day_1 AS d1
	JOIN #Day_1 AS d2 ON d1.Number<>d2.Number
WHERE 1=1
	AND (d1.Number+d2.Number) = 2020
	
---------------------------------------------
-- Part 2
---------------------------------------------
SELECT
	d1.Number
	,d2.Number
	,d3.Number
	,(d1.Number*d2.Number*d3.Number) AS Answer
FROM
	#Day_1 AS d1
	JOIN #Day_1 AS d2 ON d1.Number<>d2.Number
	JOIN #Day_1 AS d3 ON d2.Number<>d3.Number
WHERE 1=1
	AND (d1.Number+d2.Number+d3.Number) = 2020
