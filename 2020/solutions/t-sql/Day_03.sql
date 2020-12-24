---------------------------------------------
-- Author:			Elaine Lin
-- Created Date:	2020-12-22
-- References Used:
--	https://www.sqlservergeeks.com/sql-multiply-all-values-in-a-column/
---------------------------------------------

DROP TABLE IF EXISTS #Day_03_Stg
CREATE TABLE #Day_03_Stg
	(
	Map NVARCHAR(100)
	)

BULK INSERT #Day_03_Stg
FROM '.....\advent-of-code\2020\inputs\Day_03.txt'
WITH
	(
    FIRSTROW = 1,
    FIELDTERMINATOR = ' ',
    ROWTERMINATOR = '\n'
	);

ALTER TABLE #Day_03_Stg ADD ID INT IDENTITY(1,1) --To preserve input order

SELECT * FROM #Day_03_Stg AS d3s

DROP TABLE IF EXISTS #Day_03
CREATE TABLE #Day_03
	(
	ID INT
	,Map NVARCHAR(MAX)
	)

DECLARE @ct INT = (SELECT COUNT(*) FROM #Day_03_Stg)

INSERT INTO #Day_03
		(
		ID
		,Map
		)
	SELECT
		d3s.ID
		,REPLICATE(d3s.Map, @ct)
	FROM
		#Day_03_Stg AS d3s
	WHERE 1=1

SELECT * FROM #Day_03 AS d3 ORDER BY d3.ID

---------------------------------------------
-- Part 1
---------------------------------------------
SELECT
	SUM(IIF(SUBSTRING(d3.Map, ((d3.ID-1)*3)+1, 1)='#', 1, 0)) AS ct
FROM
	#Day_03 AS d3
WHERE 1=1

---------------------------------------------
-- Part 2
---------------------------------------------
DROP TABLE IF EXISTS #Slopes
CREATE TABLE #Slopes
	(
	ID INT IDENTITY(1,1)
	,[Right] INT
	,Down INT
	,Trees INT
	)

INSERT INTO #Slopes
		(
		[Right]
		,Down
		)
	VALUES
		(1, 1)
		,(3, 1)
		,(5, 1)
		,(7, 1)
		,(1, 2)

SELECT
	ROUND(EXP(SUM(LOG(a.ct))), 0) AS answer
FROM
	(
	SELECT
		s.ID
		,s.[Right]
		,s.Down
		,CASE
			WHEN s.Down=1 THEN SUM(IIF(SUBSTRING(d3.Map, ((d3.ID-1)*s.[Right])+1, 1)='#', 1, 0))
			WHEN s.Down=2 THEN SUM(IIF(d3.ID%2=1 AND d3.ID<>1 AND SUBSTRING(d3.Map, (d3.ID/2)+1, 1)='#', 1, 0))
		END AS ct
	FROM
		#Day_03 AS d3
		CROSS JOIN #Slopes AS s
	WHERE 1=1
	GROUP BY
		s.ID
		,s.[Right]
		,s.Down
	) AS a
WHERE 1=1
