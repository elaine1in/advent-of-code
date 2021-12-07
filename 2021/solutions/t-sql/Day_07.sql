---------------------------------------------
-- Author:			Elaine Lin
-- Created Date:	2021-12-06
-- References Used:
---------------------------------------------

DROP TABLE IF EXISTS #Day_07
CREATE TABLE #Day_07
	(
	position INT
	)

BULK INSERT #Day_07
FROM '.....\advent-of-code\2021\inputs\Day_07.txt'
WITH
	(
    FIRSTROW = 1,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = ','
	);

---------------------------------------------
-- Test Scenario
---------------------------------------------
--TRUNCATE TABLE #Day_07
--INSERT INTO #Day_07
--	(position)
--VALUES
--	(16),(1),(2),(0),(4),(2),(7),(1),(2),(14)

DECLARE @max_position INT = (SELECT MAX(d.position) FROM #Day_07 AS d)

DROP TABLE IF EXISTS #Numbers
CREATE TABLE #Numbers
	(
	num INT
	)

;WITH Numbers AS
	(
	SELECT 0 AS num

	UNION ALL

	SELECT
		n.num+1 AS num
	FROM
		Numbers AS n
	WHERE 1=1
		AND n.num < @max_position
	)

INSERT INTO #Numbers
		(
		num
		)
	SELECT
		n.num
	FROM
		Numbers AS n
	WHERE 1=1
	OPTION (MAXRECURSION 0)

CREATE CLUSTERED INDEX IX_Numbers_001 ON #Numbers (num)

---------------------------------------------
-- Part 1, Part 2
---------------------------------------------
SELECT
	MIN(a.answer_1) AS answer_1
	,MIN(a.answer_2) AS answer_2
FROM
	(
	SELECT
		n.num
		,SUM(ABS(n.num-d.position)) AS answer_1
		,SUM(ABS(n.num-d.position)*(ABS(n.num-d.position)+1)/2) AS answer_2
	FROM
		#Numbers AS n
		CROSS JOIN #Day_07 AS d
	WHERE 1=1
	GROUP BY
		n.num
	) AS a
WHERE 1=1
