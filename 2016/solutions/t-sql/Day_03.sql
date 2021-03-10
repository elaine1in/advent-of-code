---------------------------------------------
-- Author:			Elaine Lin
-- Created Date:	2021-03-09
-- References Used:
---------------------------------------------

DROP TABLE IF EXISTS #Day_03
CREATE TABLE #Day_03
	(
	String NVARCHAR(100)
	)

BULK INSERT #Day_03
FROM '.....\advent-of-code\2016\inputs\Day_03.txt'
WITH
	(
    FIRSTROW = 1,
    FIELDTERMINATOR = ';',
    ROWTERMINATOR = '\n'
	);

ALTER TABLE #Day_03 ADD ID INT IDENTITY(0,1) --To preserve input order

--SELECT * FROM #Day_03 AS d03

DROP TABLE IF EXISTS #Sides
CREATE TABLE #Sides
	(
	ID INT
	,String NVARCHAR(100)
	,Side INT
	,rn INT
	)

INSERT INTO #Sides
		(
		ID
		,String
		,Side
		,rn
		)
	SELECT
		d.ID
		,d.String
		,CAST(ss.[value] AS INT) AS Side
		,ROW_NUMBER() OVER(PARTITION BY d.ID ORDER BY (SELECT NULL)) AS rn
	FROM
		#Day_03 AS d
		CROSS APPLY STRING_SPLIT(d.String, ' ') AS ss
	WHERE 1=1
		AND ISNUMERIC(ss.[value])=1

---------------------------------------------
-- Part 1
---------------------------------------------
SELECT
	SUM(IIF((s1.Side+s2.Side>s3.Side) AND (s1.Side+s3.Side>s2.Side) AND (s2.Side+s3.Side>s1.Side), 1, 0)) AS Answer
FROM
	#Sides AS s1
	JOIN #Sides AS s2 ON s2.ID=s1.ID
	JOIN #Sides AS s3 ON s3.ID=s2.ID
WHERE 1=1
	AND s1.rn=1
	AND s2.rn=2
	AND s3.rn=3

---------------------------------------------
-- Part 2
---------------------------------------------
SELECT
	SUM(IIF((a.Side_1+a.Side_2>a.Side_3) AND (a.Side_1+a.Side_3>a.Side_2) AND (a.Side_2+a.Side_3>a.Side_1), 1, 0)) AS Answer
FROM
	(
	SELECT
		s.ID
		,s.String
		,s.Side AS Side_1
		,LEAD(s.Side, 1) OVER(PARTITION BY s.rn ORDER BY s.ID) AS Side_2
		,LEAD(s.Side, 2) OVER(PARTITION BY s.rn ORDER BY s.ID) AS Side_3
	FROM
		#Sides AS s
	WHERE 1=1
	) AS a
WHERE 1=1
	AND a.ID%3=0
