---------------------------------------------
-- Author:			Elaine Lin
-- Created Date:	2021-02-07
-- References Used:
--	https://stackoverflow.com/questions/62026938/restart-row-number-in-t-sql
---------------------------------------------

DROP TABLE IF EXISTS #Day_14
CREATE TABLE #Day_14
	(
	String NVARCHAR(255)
	)

BULK INSERT #Day_14
FROM '.....\advent-of-code\2015\inputs\Day_14.txt'
WITH
	(
    FIRSTROW = 1,
    FIELDTERMINATOR = ';',
    ROWTERMINATOR = '\n'
	);

--SELECT * FROM #Day_14 AS d14

DROP TABLE IF EXISTS #Reindeers
CREATE TABLE #Reindeers
	(
	Reindeer NVARCHAR(100)
	,Speed INT
	,Duration INT
	,Rest INT
	)

INSERT INTO #Reindeers
		(
		Reindeer
		,Speed
		,Duration
		,Rest
		)
	SELECT
		LEFT(d.String, CHARINDEX(' can', d.String)-1) AS Reindeer
		,SUBSTRING(d.String, CHARINDEX('fly', d.String)+4, CHARINDEX('km/s', d.String)-CHARINDEX('fly', d.String)-5) AS Speed
		,SUBSTRING(d.String, CHARINDEX('for', d.String)+4, CHARINDEX(' seconds,', d.String)-CHARINDEX('for', d.String)-4) AS Duration
		,SUBSTRING(d.String, CHARINDEX('rest for', d.String)+9, CHARINDEX(' seconds.', d.String)-CHARINDEX('rest for', d.String)-9) AS Speed
	FROM
		#Day_14 AS d
	WHERE 1=1

--SELECT * FROM #Reindeers AS r

DROP TABLE IF EXISTS #Numbers
CREATE TABLE #Numbers
	(
	Num INT
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
		AND n.Num<2503
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
	OPTION (MAXRECURSION 2503)

--SELECT * FROM #Numbers AS n

DECLARE @Time INT = 2503
---------------------------------------------
-- Part 1
---------------------------------------------
SELECT TOP 1
	f.Reindeer
	,f.Distance AS Answer
FROM
	(
	SELECT
		a.Reindeer
		,((a.Iterations*a.Speed*a.Duration) + (a.Speed*IIF(a.Remaining>a.Duration, a.Duration, a.Remaining))) AS Distance
	FROM
		(
		SELECT
			r.Reindeer
			,r.Speed
			,r.Duration
			,r.Rest
			,FLOOR(@Time/(r.Duration+r.Rest)) AS Iterations
			,@Time-(FLOOR(@Time/(r.Duration+r.Rest))*(r.Duration+r.Rest)) AS Remaining
		FROM
			#Reindeers AS r
		WHERE 1=1
		) AS a
	WHERE 1=1
	) AS f
ORDER BY
	f.Distance DESC
	
---------------------------------------------
-- Part 2
---------------------------------------------
SELECT TOP 1
	w.Reindeer
	,SUM(w.Point) AS Answer
FROM
	(
	SELECT
		f.Reindeer
		,f.Num
		,f.Total_Distance
		,IIF(f.Total_Distance=MAX(f.Total_Distance) OVER(PARTITION BY f.Num), 1, 0) AS Point
	FROM
		(
		SELECT
			a.Reindeer
			,a.Num
			,SUM(IIF(a.rn BETWEEN 1 AND a.Duration, a.Speed, 0)) OVER(PARTITION BY a.Reindeer ORDER BY a.Num) AS Total_Distance
		FROM
			(
			SELECT
				r.Reindeer
				,r.Speed
				,r.Duration
				,r.Rest
				,n.Num
				,((ROW_NUMBER() OVER(PARTITION BY r.Reindeer ORDER BY n.Num)-1) % (r.Duration+r.Rest))+1 AS rn
			FROM
				#Reindeers AS r
				CROSS JOIN #Numbers AS n
			WHERE 1=1
			) AS a
		WHERE 1=1
		) AS f
	WHERE 1=1
	) AS w
WHERE 1=1
GROUP BY
	w.Reindeer
ORDER BY
	Answer DESC
