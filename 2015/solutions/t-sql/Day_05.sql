---------------------------------------------
-- Author:			Elaine Lin
-- Created Date:	2021-01-09
-- References Used:
---------------------------------------------

DROP TABLE IF EXISTS #Day_05
CREATE TABLE #Day_05
	(
	String NVARCHAR(100)
	)

BULK INSERT #Day_05
FROM '.....\advent-of-code\2015\inputs\Day_05.txt'
WITH
	(
    FIRSTROW = 1,
    FIELDTERMINATOR = ';',
    ROWTERMINATOR = '\n'
	);

SELECT * FROM #Day_05 AS d05

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
		AND n.Num<15
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

---------------------------------------------
-- Part 1
---------------------------------------------
SELECT
	COUNT(*) AS Answer
FROM
	(
	SELECT
		d05.String
		,IIF((d05.String NOT LIKE '%ab%') AND (d05.String NOT LIKE '%cd%') AND (d05.String NOT LIKE '%pq%') AND (d05.String NOT LIKE '%xy%'), 1, 0) AS No_Disallowed
		,SUM(LEN(d05.String)-LEN(REPLACE(d05.String, v.chr, ''))) AS Count_Vowels
	FROM
		#Day_05 AS d05
		CROSS JOIN (
					SELECT
						vowels.chr
					FROM
						(
						VALUES
							('a')
							,('e')
							,('i')
							,('o')
							,('u')
						) AS vowels (chr)
					) AS v
	WHERE 1=1
	GROUP BY
		d05.String
	) AS p1
	JOIN(
		SELECT
			d05.String
			,SUM(IIF(SUBSTRING(d05.String, n.Num, 1)=SUBSTRING(d05.String, n.Num+1, 1), 1, 0)) AS Count_Double
		FROM
			#Day_05 AS d05
			CROSS JOIN #Numbers AS n
		WHERE 1=1
		GROUP BY
			d05.String
		) AS p2 ON p2.String=p1.String
WHERE 1=1
	AND p1.No_Disallowed = 1
	AND p1.Count_Vowels >= 3
	AND p2.Count_Double > 0

---------------------------------------------
-- Part 2
---------------------------------------------
SELECT
	COUNT(*) AS Answer
FROM
	(
	SELECT
		d05.String
		,SUM(IIF(((LEN(d05.String)-LEN(REPLACE(d05.String, SUBSTRING(d05.String, n.Num, 2), '')))/2)>=2, 1, 0)) AS Count_Twice
	FROM
		#Day_05 AS d05
		CROSS JOIN #Numbers AS n
	WHERE 1=1
	GROUP BY
		d05.String
	) AS ct
	JOIN(
		SELECT
			d05.String
			,SUM(IIF(SUBSTRING(d05.String, n.Num, 1)=SUBSTRING(d05.String, n.Num+2, 1), 1, 0)) AS Count_Letter
		FROM
			#Day_05 AS d05
			CROSS JOIN #Numbers AS n
		WHERE 1=1
			AND n.Num < 15
		GROUP BY
			d05.String
		) AS cl ON cl.String=ct.String
WHERE 1=1
	AND ct.Count_Twice > 0
	AND cl.Count_Letter > 0
