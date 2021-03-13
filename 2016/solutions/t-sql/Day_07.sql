---------------------------------------------
-- Author:			Elaine Lin
-- Created Date:	2021-03-13
-- References Used:
---------------------------------------------

DROP TABLE IF EXISTS #Day_07
CREATE TABLE #Day_07
	(
	String NVARCHAR(255)
	)

BULK INSERT #Day_07
FROM '.....\advent-of-code\2016\inputs\Day_07.txt'
WITH
	(
    FIRSTROW = 1,
    FIELDTERMINATOR = ';',
    ROWTERMINATOR = '\n'
	);

ALTER TABLE #Day_07 ADD ID INT IDENTITY(1,1) --To preserve input order

--SELECT * FROM #Day_07 AS d07

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
		AND n.Num<=255
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
	
---------------------------------------------
-- Part 1
---------------------------------------------
SELECT
	COUNT(*) AS Answer
FROM
	(
	SELECT
		c.ID
		,c.String
		,CASE (c.rn%2)
			WHEN 0 THEN 'even'
			WHEN 1 THEN 'odd'
		END AS modulo
		,SUM(IIF(SUBSTRING(c.Chunk, n.Num, 4)=REVERSE(SUBSTRING(c.Chunk, n.Num, 4)) AND cl.ct_distinct_Letters=2, 1, 0)) AS Match_ABBA
	FROM
		(
		SELECT
			d.ID
			,d.String
			,ss2.[value] AS Chunk
			,ROW_NUMBER() OVER(PARTITION BY d.ID ORDER BY (SELECT NULL))-1 AS rn
		FROM
			#Day_07 AS d
			CROSS APPLY STRING_SPLIT(d.String, '[') AS ss
			CROSS APPLY STRING_SPLIT(ss.[value], ']') AS ss2
		WHERE 1=1
		) AS c
		JOIN #Numbers AS n ON n.Num<=LEN(c.Chunk)-3 --substracting 3 because substring is length 4
		CROSS APPLY(
					SELECT
						COUNT(DISTINCT l.Letter) AS ct_distinct_Letters
					FROM
						#Letters AS l
					WHERE 1=1
						AND SUBSTRING(c.Chunk, n.Num, 4) LIKE CONCAT('%', l.Letter, '%')
					) AS cl
	WHERE 1=1
	GROUP BY
		c.ID
		,c.String
		,(c.rn%2)
	) AS a
	PIVOT (MAX(a.Match_ABBA) FOR modulo IN ([even], [odd])) AS p
WHERE 1=1
	AND p.even > 0 --checking for ABBA sequence
	AND p.odd = 0 --the IP also must not have an ABBA within any hypernet sequences
	
---------------------------------------------
-- Part 2
---------------------------------------------
;WITH Chunks AS
	(
	SELECT
		c.ID
		,c.String
		,CASE (c.rn%2)
			WHEN 0 THEN 'even'
			WHEN 1 THEN 'odd'
		END AS modulo
		,SUBSTRING(c.Chunk, n.Num, 3) AS Chunk_smaller
		,cl.ct_distinct_Letters
	FROM
		(
		SELECT
			d.ID
			,d.String
			,ss2.[value] AS Chunk
			,ROW_NUMBER() OVER(PARTITION BY d.ID ORDER BY (SELECT NULL))-1 AS rn
		FROM
			#Day_07 AS d
			CROSS APPLY STRING_SPLIT(d.String, '[') AS ss
			CROSS APPLY STRING_SPLIT(ss.[value], ']') AS ss2
		WHERE 1=1
		) AS c
		JOIN #Numbers AS n ON n.Num<=LEN(c.Chunk)-2 --substracting 2 because substring is length 3
		CROSS APPLY(
					SELECT
						COUNT(DISTINCT l.Letter) AS ct_distinct_Letters
					FROM
						#Letters AS l
					WHERE 1=1
						AND SUBSTRING(c.Chunk, n.Num, 3) LIKE CONCAT('%', l.Letter, '%')
					) AS cl
	WHERE 1=1
	)

SELECT
	COUNT(DISTINCT ce.ID) AS Answer
FROM
	Chunks AS ce
	JOIN Chunks AS co ON co.ID=ce.ID AND co.ct_distinct_Letters=ce.ct_distinct_Letters
WHERE 1=1
	AND ce.modulo='even'
	AND co.modulo='odd'
	--check for ABA / BAB pattern (2 distinct letters)
	AND ce.ct_distinct_Letters=2
	AND LEFT(ce.Chunk_smaller, 1)=RIGHT(ce.Chunk_smaller, 1)
	AND LEFT(co.Chunk_smaller, 1)=RIGHT(co.Chunk_smaller, 1)
	AND SUBSTRING(ce.Chunk_smaller, 1, 1)=SUBSTRING(co.Chunk_smaller, 2, 1)
	AND SUBSTRING(co.Chunk_smaller, 1, 1)=SUBSTRING(ce.Chunk_smaller, 2, 1)
