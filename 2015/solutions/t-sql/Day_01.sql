---------------------------------------------
-- Author:			Elaine Lin
-- Created Date:	2021-01-05
-- References Used:
---------------------------------------------

DROP TABLE IF EXISTS #Day_01
CREATE TABLE #Day_01
	(
	Instructions NVARCHAR(MAX)
	)

BULK INSERT #Day_01
FROM 'C:\Users\elain\Documents\GitHub\advent-of-code\2015\inputs\Day_01.txt'
WITH
	(
    FIRSTROW = 1,
    FIELDTERMINATOR = ';',
    ROWTERMINATOR = '\n'
	);

SELECT * FROM #Day_01 AS d01

---------------------------------------------
-- Part 1
---------------------------------------------
SELECT
	(LEN(d01.Instructions)-LEN(REPLACE(d01.Instructions, '(', ''))) - (LEN(d01.Instructions)-LEN(REPLACE(d01.Instructions, ')', ''))) AS Answer
FROM
	#Day_01 AS d01
WHERE 1=1
