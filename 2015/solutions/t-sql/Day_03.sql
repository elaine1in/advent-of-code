---------------------------------------------
-- Author:			Elaine Lin
-- Created Date:	2021-01-07
-- References Used:
---------------------------------------------

DROP TABLE IF EXISTS #Day_03
CREATE TABLE #Day_03
	(
	Moves NVARCHAR(MAX)
	)

BULK INSERT #Day_03
FROM '.....\advent-of-code\2015\inputs\Day_03.txt'
WITH
	(
    FIRSTROW = 1,
    FIELDTERMINATOR = ';',
    ROWTERMINATOR = '\n'
	);

SELECT * FROM #Day_03 AS d03

DROP TABLE IF EXISTS #Directions
CREATE TABLE #Directions
	(
	Num INT
	,Direction NVARCHAR(1)
	,East_West INT
	,North_South INT
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
		AND n.Num<(SELECT LEN(d.Moves) FROM #Day_03 AS d)
	)

INSERT INTO #Directions
		(
		Num
		,Direction
		,East_West
		,North_South
		)
	SELECT
		n.Num
		,SUBSTRING(d03.Moves, n.Num, 1) Direction
		,CASE
			WHEN SUBSTRING(d03.Moves, n.Num, 1)='>' THEN 1
			WHEN SUBSTRING(d03.Moves, n.Num, 1)='<' THEN -1
			ELSE 0
		END AS East_West
		,CASE
			WHEN SUBSTRING(d03.Moves, n.Num, 1)='^' THEN 1
			WHEN SUBSTRING(d03.Moves, n.Num, 1)='v' THEN -1
			ELSE 0
		END AS North_South
	FROM
		#Day_03 AS d03
		CROSS JOIN Numbers AS n
	WHERE 1=1
	OPTION (MAXRECURSION 10000)

---------------------------------------------
-- Part 1
---------------------------------------------
SELECT
	COUNT(*) + 1 AS Answer --need to +1 to include house at starting location
FROM
	(
	SELECT DISTINCT
		SUM(d.East_West) OVER(ORDER BY d.Num) AS Current_East_West
		,SUM(d.North_South) OVER(ORDER BY d.Num) AS Current_North_South
	FROM
		#Directions AS d
	WHERE 1=1
	) AS a
WHERE 1=1

---------------------------------------------
-- Part 2
---------------------------------------------
SELECT
	COUNT(*) AS Answer
FROM
	(
	SELECT
		SUM(d.East_West) OVER(ORDER BY d.Num) AS Current_East_West
		,SUM(d.North_South) OVER(ORDER BY d.Num) AS Current_North_South
	FROM
		#Directions AS d
	WHERE 1=1
		AND d.Num%2 = 1

	UNION

	SELECT
		SUM(d.East_West) OVER(ORDER BY d.Num) AS Current_East_West
		,SUM(d.North_South) OVER(ORDER BY d.Num) AS Current_North_South
	FROM
		#Directions AS d
	WHERE 1=1
		AND d.Num%2 = 0
	) AS a
WHERE 1=1
