---------------------------------------------
-- Author:			Elaine Lin
-- Created Date:	2021-04-07
-- References Used:
---------------------------------------------

DROP TABLE IF EXISTS #Day_01
CREATE TABLE #Day_01
	(
	Captcha NVARCHAR(MAX)
	)

BULK INSERT #Day_01
FROM '.....\advent-of-code\2017\inputs\Day_01.txt'
WITH
	(
    FIRSTROW = 1,
    FIELDTERMINATOR = ';',
    ROWTERMINATOR = '\n'
	);

DECLARE @Max_Len INT = (
						SELECT
							MAX(LEN(d.Captcha))
						FROM
							#Day_01 AS d
						WHERE 1=1
						)

DROP TABLE IF EXISTS #Numbers
CREATE TABLE #Numbers
	(
	Num INT
	)

;WITH Numbers AS
	(
	SELECT
		1 AS Num

	UNION ALL

	SELECT
		(n.Num+1) AS Num
	FROM
		Numbers AS n
	WHERE 1=1
		AND n.Num+1 <= @Max_Len
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
	OPTION (MAXRECURSION 0)

---------------------------------------------
-- Part 1, Part 2
---------------------------------------------
SELECT
	SUM(IIF(a.Digit=a.Lead_Digit_Part_1, a.Digit, NULL)) AS Answer_1
	,SUM(IIF(a.Digit=a.Lead_Digit_Part_2, a.Digit, NULL)) AS Answer_2
FROM
	(
	SELECT
		n.Num
		,CAST(SUBSTRING(d.Captcha, n.Num, 1) AS INT) AS Digit
		,CAST(SUBSTRING(d.Captcha, IIF(n.Num<>@Max_Len, n.Num+1, 1), 1) AS INT) AS Lead_Digit_Part_1
		,CAST(SUBSTRING(d.Captcha, (n.Num+(@Max_Len/2))%@Max_Len, 1) AS INT) AS Lead_Digit_Part_2
	FROM
		#Day_01 AS d
		CROSS JOIN #Numbers AS n
	WHERE 1=1
	) AS a
WHERE 1=1
