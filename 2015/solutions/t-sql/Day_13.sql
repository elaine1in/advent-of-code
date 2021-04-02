---------------------------------------------
-- Author:			Elaine Lin
-- Created Date:	2021-04-01
-- References Used:
---------------------------------------------

DROP TABLE IF EXISTS #Day_13
CREATE TABLE #Day_13
	(
	String NVARCHAR(100)
	)

BULK INSERT #Day_13
FROM '.....\advent-of-code\2015\inputs\Day_13.txt'
WITH
	(
    FIRSTROW = 1,
    FIELDTERMINATOR = ';',
    ROWTERMINATOR = '\n'
	);

DROP TABLE IF EXISTS #Potential
CREATE TABLE #Potential
	(
	String NVARCHAR(100)
	,Person_1 NVARCHAR(50)
	,[value] INT
	,Person_2 NVARCHAR(50)
	)

DROP TABLE IF EXISTS #People
CREATE TABLE #People
	(
	Person NVARCHAR(50)
	)

CREATE CLUSTERED INDEX IX_People_001 ON #People (Person)

INSERT INTO #Potential
		(
		String
		,Person_1
		,[value]
		,Person_2
		)
	SELECT
		p.String
		,p.Person_1
		,p.lg*CAST(SUBSTRING(p.String, p.Start_Position, (p.End_Position-p.Start_Position)) AS INT) AS [value]
		,LEFT(p.Person_2, LEN(p.Person_2)-1) AS Person_2
	FROM
		(
		SELECT
			d.String
			,LEFT(d.String, CHARINDEX(' would', d.String)-1) AS Person_1
			,IIF(d.String LIKE '%lose%', -1, 1) AS lg
			,CASE
				WHEN d.String LIKE '%lose%' THEN CHARINDEX('lose ', d.String)+5
				WHEN d.String LIKE '%gain%' THEN CHARINDEX('gain ', d.String)+5
			END AS Start_Position
			,CHARINDEX(' happiness', d.String) AS End_Position
			,RIGHT(d.String, LEN(d.String)-CHARINDEX('to ', d.String)-2) AS Person_2
		FROM
			#Day_13 AS d
		WHERE 1=1
		) AS p
	WHERE 1=1

--SELECT * FROM #Potential AS p
	
INSERT INTO #People
		(
		Person
		)
	SELECT
		p.Person_1 AS Person
	FROM
		#Potential AS p
	WHERE 1=1

	UNION

	SELECT
		p.Person_2 AS Person
	FROM
		#Potential AS p
	WHERE 1=1
	
---------------------------------------------
-- Part 1
---------------------------------------------
;WITH Permutations AS
	(
	SELECT
		up.rn
		,up.Person
		,up.Person_Name
		,ISNULL(LEAD(up.Person_Name, 1) OVER(PARTITION BY up.rn ORDER BY up.Person), FIRST_VALUE(up.Person_Name) OVER(PARTITION BY up.rn ORDER BY up.Person)) AS Lead_Person_Name
	FROM
		(
		SELECT
			ROW_NUMBER() OVER(ORDER BY (SELECT NULL)) AS rn
			,p1.Person AS [1]
			,p2.Person AS [2]
			,p3.Person AS [3]
			,p4.Person AS [4]
			,p5.Person AS [5]
			,p6.Person AS [6]
			,p7.Person AS [7]
			,p8.Person AS [8]
		FROM
			#People AS p1
			JOIN #People AS p2 ON p2.Person<>p1.Person
			JOIN #People AS p3 ON p3.Person<>p2.Person AND p3.Person<>p1.Person
			JOIN #People AS p4 ON p4.Person<>p3.Person AND p4.Person<>p2.Person AND p4.Person<>p1.Person
			JOIN #People AS p5 ON p5.Person<>p4.Person AND p5.Person<>p3.Person AND p5.Person<>p2.Person AND p5.Person<>p1.Person
			JOIN #People AS p6 ON p6.Person<>p5.Person AND p6.Person<>p4.Person AND p6.Person<>p3.Person AND p6.Person<>p2.Person AND p6.Person<>p1.Person
			JOIN #People AS p7 ON p7.Person<>p6.Person AND p7.Person<>p5.Person AND p7.Person<>p4.Person AND p7.Person<>p3.Person AND p7.Person<>p2.Person AND p7.Person<>p1.Person
			JOIN #People AS p8 ON p8.Person<>p7.Person AND p8.Person<>p6.Person AND p8.Person<>p5.Person AND p8.Person<>p4.Person AND p8.Person<>p3.Person AND p8.Person<>p2.Person AND p8.Person<>p1.Person
		WHERE 1=1
		) AS p
		UNPIVOT(Person_Name FOR Person IN ([1], [2], [3], [4], [5], [6], [7], [8])) AS up
	WHERE 1=1
	)

SELECT
	MAX(a.Happiness) AS Answer
FROM
	(
	SELECT
		p.rn
		,SUM(o.[value]) AS Happiness
	FROM
		Permutations AS p
		JOIN #Potential AS o ON (o.Person_1=p.Person_Name AND o.Person_2=p.Lead_Person_Name) OR (o.Person_2=p.Person_Name AND o.Person_1=p.Lead_Person_Name)
	WHERE 1=1
	GROUP BY
		p.rn
	) AS a
WHERE 1=1

---------------------------------------------
-- Part 2
---------------------------------------------
INSERT INTO #Potential
		(
		String
		,Person_1
		,[value]
		,Person_2
		)
	SELECT
		'' AS String
		,p.Person AS Person_1
		,0
		,'Me' AS Person_2
	FROM
		#People AS p
	WHERE 1=1

	UNION ALL
	
	SELECT
		'' AS String
		,'Me' AS Person_1
		,0
		,p.Person AS Person_2
	FROM
		#People AS p
	WHERE 1=1

INSERT INTO #People (Person) VALUES ('Me')

;WITH Permutations AS
	(
	SELECT
		up.rn
		,up.Person
		,up.Person_Name
		,ISNULL(LEAD(up.Person_Name, 1) OVER(PARTITION BY up.rn ORDER BY up.Person), FIRST_VALUE(up.Person_Name) OVER(PARTITION BY up.rn ORDER BY up.Person)) AS Lead_Person_Name
	FROM
		(
		SELECT
			ROW_NUMBER() OVER(ORDER BY (SELECT NULL)) AS rn
			,p1.Person AS [1]
			,p2.Person AS [2]
			,p3.Person AS [3]
			,p4.Person AS [4]
			,p5.Person AS [5]
			,p6.Person AS [6]
			,p7.Person AS [7]
			,p8.Person AS [8]
			,p9.Person AS [9]
		FROM
			#People AS p1
			JOIN #People AS p2 ON p2.Person<>p1.Person
			JOIN #People AS p3 ON p3.Person<>p2.Person AND p3.Person<>p1.Person
			JOIN #People AS p4 ON p4.Person<>p3.Person AND p4.Person<>p2.Person AND p4.Person<>p1.Person
			JOIN #People AS p5 ON p5.Person<>p4.Person AND p5.Person<>p3.Person AND p5.Person<>p2.Person AND p5.Person<>p1.Person
			JOIN #People AS p6 ON p6.Person<>p5.Person AND p6.Person<>p4.Person AND p6.Person<>p3.Person AND p6.Person<>p2.Person AND p6.Person<>p1.Person
			JOIN #People AS p7 ON p7.Person<>p6.Person AND p7.Person<>p5.Person AND p7.Person<>p4.Person AND p7.Person<>p3.Person AND p7.Person<>p2.Person AND p7.Person<>p1.Person
			JOIN #People AS p8 ON p8.Person<>p7.Person AND p8.Person<>p6.Person AND p8.Person<>p5.Person AND p8.Person<>p4.Person AND p8.Person<>p3.Person AND p8.Person<>p2.Person AND p8.Person<>p1.Person
			JOIN #People AS p9 ON p9.Person<>p8.Person AND p9.Person<>p7.Person AND p9.Person<>p6.Person AND p9.Person<>p5.Person AND p9.Person<>p4.Person AND p9.Person<>p3.Person AND p9.Person<>p2.Person AND p9.Person<>p1.Person
		WHERE 1=1
		) AS p
		UNPIVOT(Person_Name FOR Person IN ([1], [2], [3], [4], [5], [6], [7], [8], [9])) AS up
	WHERE 1=1
	)

SELECT
	MAX(a.Happiness) AS Answer
FROM
	(
	SELECT
		p.rn
		,SUM(o.[value]) AS Happiness
	FROM
		Permutations AS p
		JOIN #Potential AS o ON (o.Person_1=p.Person_Name AND o.Person_2=p.Lead_Person_Name) OR (o.Person_2=p.Person_Name AND o.Person_1=p.Lead_Person_Name)
	WHERE 1=1
	GROUP BY
		p.rn
	) AS a
WHERE 1=1
