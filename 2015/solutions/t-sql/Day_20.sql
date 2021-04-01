---------------------------------------------
-- Author:			Elaine Lin
-- Created Date:	2021-03-31
-- References Used:
---------------------------------------------

DECLARE @aoc_input INT = 34000000

DROP TABLE IF EXISTS #Numbers
CREATE TABLE #Numbers
	(
	Num INT
	)

;WITH Numbers AS
	(
	SELECT
		1 AS Num

	UNION ALL

	SELECT
		(n.Num+1) AS Num
	FROM
		Numbers AS n
	WHERE 1=1
		AND n.Num+1 <= 1000000
	)

INSERT INTO #Numbers
		(
		Num
		)
	SELECT
		n.Num
	FROM
		Numbers AS n
	WHERE 1=1
	OPTION (MAXRECURSION 0)

CREATE CLUSTERED INDEX IX_Numbers_001 ON #Numbers (Num)

;WITH Small_Divisors AS
	(
	SELECT
		n.Num AS House_Number
		,sd.Num
	FROM
		#Numbers AS n
		JOIN #Numbers AS sd ON n.Num%sd.Num=0 AND sd.Num<=SQRT(n.Num)
	WHERE 1=1
	)
,Large_Divisors AS
	(
	SELECT
		sd.House_Number
		,(sd.House_Number/sd.Num) AS Num
	FROM
		Small_Divisors AS sd
	WHERE 1=1
		AND sd.House_Number<>SQUARE(sd.Num)
	)
,Divisors AS
	(
	SELECT
		sd.House_Number
		,sd.Num
	FROM
		Small_Divisors AS sd
	WHERE 1=1

	UNION ALL

	SELECT
		ld.House_Number
		,ld.Num
	FROM
		Large_Divisors AS ld
	WHERE 1=1
	)

---------------------------------------------
-- Part 1, Part 2
---------------------------------------------
SELECT
	'Part 1' AS Part
	,MIN(a.House_Number) AS Answer
FROM
	(
	SELECT
		d.House_Number
		,SUM(d.Num)*10 AS Presents
	FROM
		Divisors AS d
	WHERE 1=1
	GROUP BY
		d.House_Number
	) AS a
WHERE 1=1
	AND a.Presents >= @aoc_input

UNION ALL

SELECT
	'Part 2' AS Part
	,MIN(a.House_Number) AS Answer
FROM
	(
	SELECT
		d.House_Number
		,SUM(d.Num)*11 AS Presents
	FROM
		Divisors AS d
	WHERE 1=1
		AND d.House_Number/d.Num<=50
	GROUP BY
		d.House_Number
	) AS a
WHERE 1=1
	AND a.Presents >= @aoc_input
