---------------------------------------------
-- Author:			Elaine Lin
-- Created Date:	2021-01-06
-- References Used:
--	https://stackoverflow.com/questions/368351/whats-the-best-way-to-select-the-minimum-value-from-several-columns
---------------------------------------------

DROP TABLE IF EXISTS #Day_02
CREATE TABLE #Day_02
	(
	Box NVARCHAR(100)
	)

BULK INSERT #Day_02
FROM '.....\advent-of-code\2015\inputs\Day_02.txt'
WITH
	(
    FIRSTROW = 1,
    FIELDTERMINATOR = ';',
    ROWTERMINATOR = '\n'
	);

ALTER TABLE #Day_02 ADD ID INT IDENTITY(1,1) --To preserve input order

SELECT * FROM #Day_02 AS d02

---------------------------------------------
-- Part 1
---------------------------------------------
SELECT
	SUM(a.total) AS Answer
FROM
	(
	SELECT
		s.Box
		,(s.l*s.w) AS lw
		,(s.w*s.h) AS wh
		,(s.h*s.l) AS hl
		,ca.slack
		,(2*((s.l*s.w)+(s.w*s.h)+(s.h*s.l)))+ca.slack AS total
	FROM
		(
		SELECT
			d02.Box
			,CAST(LEFT(d02.Box, CHARINDEX('x', d02.Box)-1) AS INT) AS l
			,CAST(SUBSTRING(d02.Box, CHARINDEX('x', d02.Box)+1, CHARINDEX('x', d02.Box, CHARINDEX('x', d02.Box)+1)-CHARINDEX('x', d02.Box)-1) AS INT) AS w
			,CAST(RIGHT(d02.Box, CHARINDEX('x', REVERSE(d02.Box))-1) AS INT) AS h
		FROM
			#Day_02 AS d02
		WHERE 1=1
		) AS s
		CROSS APPLY (SELECT MIN(v.side) AS slack FROM (VALUES (s.l*s.w), (s.w*s.h), (s.h*s.l) ) AS v(side)) AS ca
	WHERE 1=1
	) AS a
WHERE 1=1

---------------------------------------------
-- Part 2
---------------------------------------------
;WITH Sides AS
	(
	SELECT
		d02.ID
		,d02.Box
		,CAST(ss.[value] AS INT) AS v
		,ROW_NUMBER() OVER(PARTITION BY d02.ID ORDER BY CAST(ss.[value] AS INT)) AS rn
	FROM
		#Day_02 AS d02
		CROSS APPLY STRING_SPLIT(d02.Box, 'x') AS ss
	WHERE 1=1
	)

SELECT
	SUM((2*(s1.v+s2.v)) + (s1.v*s2.v*s3.v)) AS Answer
FROM
	Sides AS s1
	JOIN Sides AS s2 ON s2.ID=s1.ID AND s1.rn=1 AND s2.rn=2
	LEFT JOIN Sides AS s3 ON s3.ID=s2.ID AND s2.rn=2 AND s3.rn=3
WHERE 1=1
