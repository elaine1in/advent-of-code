---------------------------------------------
-- Author:			Elaine Lin
-- Created Date:	2021-12-03
-- References Used:
---------------------------------------------

DROP TABLE IF EXISTS #Day_03
CREATE TABLE #Day_03
	(
	diagnostic_binary NVARCHAR(50)
	)

BULK INSERT #Day_03
FROM '.....\advent-of-code\2021\inputs\Day_03.txt'
WITH
	(
    FIRSTROW = 1,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n'
	);
	
---------------------------------------------
-- Test Scenario
---------------------------------------------
--TRUNCATE TABLE #Day_03
--INSERT INTO #Day_03
--	(
--	diagnostic_binary
--	)
--VALUES
--	('00100')
--	,('11110')
--	,('10110')
--	,('10111')
--	,('10101')
--	,('01111')
--	,('00111')
--	,('11100')
--	,('10000')
--	,('11001')
--	,('00010')
--	,('01010')
	
DECLARE @max_len INT = (SELECT MAX(LEN(d.diagnostic_binary)) FROM #Day_03 AS d)

DROP TABLE IF EXISTS #Numbers
CREATE TABLE #Numbers
	(
	num INT
	)

;WITH Numbers AS
	(
	SELECT 1 AS num

	UNION ALL

	SELECT
		n.num+1 AS num
	FROM
		Numbers AS n
	WHERE 1=1
		AND n.num < @max_len
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

---------------------------------------------
-- Part 1
---------------------------------------------
;WITH prep AS
	(
	SELECT
		n.num --index
		,SUBSTRING(d.diagnostic_binary, n.num, 1) AS b
		,ROW_NUMBER() OVER(PARTITION BY n.num ORDER BY COUNT(*) DESC) AS grp --grp 1 = gamma rate; grp 2 = epsilon rate
	FROM
		#Day_03 AS d
		CROSS JOIN #Numbers AS n
	WHERE 1=1
	GROUP BY
		n.num
		,SUBSTRING(d.diagnostic_binary, n.num, 1)
	)

SELECT
	p.grp
	,STRING_AGG(p.b, '') WITHIN GROUP(ORDER BY p.num)
FROM
	prep AS p
WHERE 1=1
GROUP BY
	p.grp

--need to convert binary to integer, and then multiply the two values together
