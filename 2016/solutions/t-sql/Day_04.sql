---------------------------------------------
-- Author:			Elaine Lin
-- Created Date:	2021-03-11
-- References Used:
--	https://www.sqlservertutorial.net/sql-server-string-functions/sql-server-string_agg-function/
---------------------------------------------

DROP TABLE IF EXISTS #Day_04
CREATE TABLE #Day_04
	(
	String NVARCHAR(100)
	)

BULK INSERT #Day_04
FROM '.....\advent-of-code\2016\inputs\Day_04.txt'
WITH
	(
    FIRSTROW = 1,
    FIELDTERMINATOR = ';',
    ROWTERMINATOR = '\n'
	);

--SELECT * FROM #Day_04 AS d04

DROP TABLE IF EXISTS #Letters
CREATE TABLE #Letters
	(
	ID INT IDENTITY(1,1)
	,Letter NVARCHAR(1)
	)

INSERT INTO #Letters
		(Letter)
	VALUES
		('a'),('b'),('c'),('d'),('e'),('f'),('g'),('h'),('i'),('j'),('k'),('l'),('m'),('n'),('o'),('p'),('q'),('r'),('s'),('t'),('u'),('v'),('w'),('x'),('y'),('z')

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
		AND n.Num<=100
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
	OPTION (MAXRECURSION 1000)

DROP TABLE IF EXISTS #Rooms_2
CREATE TABLE #Rooms_2
	(
	String NVARCHAR(100)
	,[Name] NVARCHAR(100)
	,Sector_ID INT
	,[Checksum] NVARCHAR(10)
	,Letter NVARCHAR(1)
	,ct INT
	,rn INT
	)

;WITH Rooms AS
	(
	SELECT
		i.String
		,i.[Name]
		,CAST(LEFT(i.Part, CHARINDEX('[', i.Part)-1) AS INT) AS Sector_ID
		,RIGHT(i.Part, CHARINDEX('[', REVERSE(i.Part))) AS [Checksum]
	FROM
		(
		SELECT
			d.String
			,LEFT(d.String, LEN(d.String)-CHARINDEX('-', REVERSE(d.String))) AS [Name]
			,RIGHT(d.String, CHARINDEX('-', REVERSE(d.String))-1) AS Part
		FROM
			#Day_04 AS d
		WHERE 1=1
		) AS i
	WHERE 1=1
	)

INSERT INTO #Rooms_2
		(
		String
		,[Name]
		,Sector_ID
		,[Checksum]
		,Letter
		,ct
		,rn
		)
	SELECT
		r.String
		,r.[Name]
		,r.Sector_ID
		,REPLACE(REPLACE(r.[Checksum], '[', ''), ']', '') AS [Checksum]
		,l.Letter
		,LEN(r.[Name])-LEN(REPLACE(r.[Name], l.Letter, '')) AS ct
		,ROW_NUMBER() OVER(PARTITION BY r.String ORDER BY LEN(r.[Name])-LEN(REPLACE(r.[Name], l.Letter, '')) DESC, l.Letter) AS rn
	FROM
		Rooms AS r
		JOIN #Letters AS l ON r.[Checksum] LIKE CONCAT('%', l.Letter, '%')
	WHERE 1=1

---------------------------------------------
-- Part 1
---------------------------------------------
SELECT
	SUM(a.Sector_ID) AS Answer
FROM
	(
	SELECT
		r.String
		,r.[Name]
		,r.Sector_ID
		,r.[Checksum]
		,LEN(r.[Checksum]) AS Len_Checksum
		,SUM(IIF(r.rn=n.Num, 1, 0)) AS [Match]
	FROM
		#Rooms_2 AS r
		JOIN #Numbers AS n ON n.Num<=LEN(r.[Checksum]) AND r.Letter=SUBSTRING(r.[Checksum], n.Num, 1)
	WHERE 1=1
		AND r.ct > 0
	GROUP BY
		r.String
		,r.[Name]
		,r.Sector_ID
		,r.[Checksum]
	HAVING
		LEN(r.[Checksum]) = SUM(IIF(r.rn=n.Num, 1, 0))
	) AS a
WHERE 1=1

---------------------------------------------
-- Part 2
---------------------------------------------
SELECT
	a.Sector_ID AS Answer
FROM
	(
	SELECT
		r.[Name]
		,r.Sector_ID
		,STRING_AGG(l2.Letter, '') WITHIN GROUP(ORDER BY n.Num) AS Translated
	FROM
		(
		SELECT DISTINCT
			r.String
			,r.Sector_ID
			,r.[Name]
		FROM
			#Rooms_2 AS r
		WHERE 1=1
		) AS r
		JOIN #Numbers AS n ON n.Num<=LEN(r.[Name])
		JOIN #Letters AS l ON l.Letter=SUBSTRING(r.[Name], n.Num, 1)
		JOIN #Letters AS l2 ON l2.ID=((l.ID+r.Sector_ID)%26)
	GROUP BY
		r.[Name]
		,r.Sector_ID
	) AS a
WHERE 1=1
	AND a.Translated LIKE 'northpole%'
