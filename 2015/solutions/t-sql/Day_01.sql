---------------------------------------------
-- Author:			Elaine Lin
-- Created Date:	2021-01-05
-- References Used:
--	https://stackoverflow.com/questions/17942508/sql-split-values-to-multiple-rows
---------------------------------------------

DROP TABLE IF EXISTS #Day_01
CREATE TABLE #Day_01
	(
	Instructions NVARCHAR(MAX)
	)

BULK INSERT #Day_01
FROM '.....\advent-of-code\2015\inputs\Day_01.txt'
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

---------------------------------------------
-- Part 2
---------------------------------------------
DROP TABLE IF EXISTS #Floor
CREATE TABLE #Floor
	(
	Num INT
	,Position NVARCHAR(1)
	,[Floor] INT
	)

;WITH Numbers AS
	(
	SELECT 1 AS Num

	UNION ALL

	SELECT
		n.Num+1 AS Num
	FROM
		Numbers AS n
	WHERE 1=1
		AND n.Num<(SELECT LEN(d.Instructions) FROM #Day_01 AS d)
	)

INSERT INTO #Floor
		(
		Num
		,Position
		,[Floor]
		)
	SELECT
		n.Num
		,SUBSTRING(d01.Instructions, n.Num, 1) AS Position
		,SUM(IIF(SUBSTRING(d01.Instructions, n.Num, 1)='(', 1, -1)) OVER(ORDER BY n.Num) AS [Floor]
	FROM
		#Day_01 AS d01
		CROSS JOIN Numbers AS n OPTION (MAXRECURSION 10000)

SELECT
	MIN(IIF(f.[Floor]=-1, f.Num, NULL)) AS Answer
FROM
	#Floor AS f
WHERE 1=1
