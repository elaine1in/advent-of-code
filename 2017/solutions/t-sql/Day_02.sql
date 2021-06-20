---------------------------------------------
-- Author:			Elaine Lin
-- Created Date:	2021-04-08
-- References Used:
--	https://stackoverflow.com/questions/42259236/sql-split-tab-delimited-column
--	https://docs.microsoft.com/en-us/sql/t-sql/functions/char-transact-sql?view=sql-server-ver15
---------------------------------------------

DROP TABLE IF EXISTS #Day_02
CREATE TABLE #Day_02
	(
	Input NVARCHAR(MAX)
	)

BULK INSERT #Day_02
FROM '.....\advent-of-code\2017\inputs\Day_02.txt'
WITH
	(
    FIRSTROW = 1,
    FIELDTERMINATOR = ';',
    ROWTERMINATOR = '\n'
	);
	
ALTER TABLE #Day_02 ADD ID INT IDENTITY(0,1) --To preserve input order

DROP TABLE IF EXISTS #Spreadsheet
CREATE TABLE #Spreadsheet
	(
	ID INT
	,Input NVARCHAR(MAX)
	,Num INT
	)

INSERT INTO #Spreadsheet
		(
		ID
		,Input
		,Num
		)
	SELECT
		d.ID
		,d.Input
		,ss.[value] AS Num
	FROM
		#Day_02 AS d
		CROSS APPLY STRING_SPLIT(d.Input, CHAR(9)) AS ss
	WHERE 1=1

DECLARE @Max_Num INT = (SELECT MAX(s.Num) FROM #Spreadsheet AS s)

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
		AND n.Num+1 <= @Max_Num
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
-- Part 1
---------------------------------------------
SELECT
	SUM(a.Diff) AS Answer
FROM
	(
	SELECT
		s.ID
		,(MAX(s.Num) - MIN(s.Num)) AS Diff
	FROM
		#Spreadsheet AS s
	WHERE 1=1
	GROUP BY
		s.ID
	) AS a
WHERE 1=1

---------------------------------------------
-- Part 2
---------------------------------------------
;WITH Spreadsheet AS
	(
	SELECT
		s.ID
		,s.Num AS Spreadsheet_Num
		,n.Num AS Divisor
	FROM
		#Spreadsheet AS s
		JOIN #Numbers AS n ON n.Num<s.Num
	WHERE 1=1
		AND s.Num%n.Num=0
	)

SELECT
	SUM(s.Spreadsheet_Num/s.Divisor) AS Answer
FROM
	Spreadsheet AS s
WHERE 1=1
	AND EXISTS(
				SELECT
					1
				FROM
					Spreadsheet AS s2
				WHERE 1=1
					AND s2.ID=s.ID
					AND s2.Spreadsheet_Num=s.Divisor
				)
