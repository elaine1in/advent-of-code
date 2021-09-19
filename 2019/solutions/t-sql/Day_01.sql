---------------------------------------------
-- Author:			Elaine Lin
-- Created Date:	2021-09-19
-- References Used:
---------------------------------------------

DROP TABLE IF EXISTS #Day_01
CREATE TABLE #Day_01
	(
	Mass INT
	)

BULK INSERT #Day_01
FROM '.....\advent-of-code\2019\inputs\Day_01.txt'
WITH
	(
    FIRSTROW = 1,
    FIELDTERMINATOR = ';',
    ROWTERMINATOR = '\n'
	);

---------------------------------------------
-- Part 1
---------------------------------------------
SELECT
	SUM(FLOOR(d.Mass/3)-2) AS Answer
FROM
	#Day_01 AS d
WHERE 1=1

---------------------------------------------
-- Part 2
---------------------------------------------
;WITH Modules AS
	(
	SELECT
		0 AS Lvl
		,d.Mass AS Original_Mass
		,d.Mass
		,0 AS Fuel
	FROM
		#Day_01 AS d
	WHERE 1=1

	UNION ALL

	SELECT
		m.Lvl+1
		,d.Mass AS Original_Mass
		,FLOOR(m.Mass/3)-2 AS Mass
		,m.Fuel+FLOOR(m.Mass/3)-2 AS Fuel
	FROM
		Modules AS m
		JOIN #Day_01 AS d ON d.Mass=m.Original_Mass
	WHERE 1=1
		AND FLOOR(m.Mass/3)-2>0
	)

SELECT
	SUM(a.Fuel) AS Answer
FROM
	(
	SELECT
		*
		,ROW_NUMBER() OVER(PARTITION BY m.Original_Mass ORDER BY m.Lvl DESC) AS rn
	FROM
		Modules AS m
	WHERE 1=1
	) AS a
WHERE 1=1
	AND a.rn = 1
