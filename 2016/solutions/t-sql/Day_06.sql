---------------------------------------------
-- Author:			Elaine Lin
-- Created Date:	2021-03-12
-- References Used:
---------------------------------------------

DROP TABLE IF EXISTS #Day_06
CREATE TABLE #Day_06
	(
	String NVARCHAR(10)
	)

BULK INSERT #Day_06
FROM '.....\advent-of-code\2016\inputs\Day_06.txt'
WITH
	(
    FIRSTROW = 1,
    FIELDTERMINATOR = ';',
    ROWTERMINATOR = '\n'
	);

--SELECT * FROM #Day_06 AS d06

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
		AND n.Num<=10
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
-- Part 1, Part 2
---------------------------------------------
SELECT
	CASE v.rn
		WHEN 1 THEN 'Part 1'
		WHEN 26 THEN 'Part 2'
	END AS Part
	,STRING_AGG(v.Letter, '') WITHIN GROUP(ORDER BY v.Num) AS Answer
FROM
	(
	SELECT
		a.Num
		,a.Letter
		,a.ct
		,ROW_NUMBER() OVER(PARTITION BY a.Num ORDER BY a.ct DESC) AS rn
	FROM
		(
		SELECT
			n.Num
			,SUBSTRING(d.String, n.Num, 1) AS Letter
			,COUNT(*) AS ct
		FROM
			#Day_06 AS d
			JOIN #Numbers AS n ON n.Num<=LEN(d.String)
		WHERE 1=1
		GROUP BY
			n.Num
			,SUBSTRING(d.String, n.Num, 1)
		) AS a
	WHERE 1=1
	) AS v
WHERE 1=1
	AND v.rn IN (1, 26) --most frequent and least frequent occurrence // 26 letters in the alphabet
GROUP BY
	v.rn
