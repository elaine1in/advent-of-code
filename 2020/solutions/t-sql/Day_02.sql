---------------------------------------------
-- Author:			Elaine Lin
-- Created Date:	2020-12-22
-- References Used:
--	https://stackoverflow.com/questions/1860457/how-to-count-instances-of-character-in-sql-column
---------------------------------------------

DROP TABLE IF EXISTS #Day_2_Stg
CREATE TABLE #Day_2_Stg
	(
	P_Range NVARCHAR(100)
	,P_Letter NVARCHAR(100)
	,P_Password NVARCHAR(100)
	)

BULK INSERT #Day_2_Stg
FROM '.....\advent-of-code\2020\inputs\Day_02.txt'
WITH
	(
    FIRSTROW = 1,
    FIELDTERMINATOR = ' ',
    ROWTERMINATOR = '\n'
	);

SELECT * FROM #Day_2_Stg AS d2s

DROP TABLE IF EXISTS #Day_2
CREATE TABLE #Day_2
	(
	Number_1 INT
	,Number_2 INT
	,P_Letter NVARCHAR(1)
	,P_Password NVARCHAR(100)
	)

INSERT INTO #Day_2
		(
		Number_1
		,Number_2
		,P_Letter
		,P_Password
		)
	SELECT
		LEFT(d2s.P_Range, CHARINDEX('-', d2s.P_Range)-1) AS Number_1
		,RIGHT(d2s.P_Range, LEN(d2s.P_Range)-CHARINDEX('-', d2s.P_Range)) AS Number_2
		,REPLACE(d2s.P_Letter, ':', '') AS P_Letter
		,d2s.P_Password
	FROM
		#Day_2_Stg AS d2s
	WHERE 1=1

SELECT * FROM #Day_2 AS d2

---------------------------------------------
-- Part 1
---------------------------------------------
SELECT
	COUNT(*) AS ct
FROM
	#Day_2 AS d2
WHERE 1=1
	AND LEN(d2.P_Password)-LEN(REPLACE(d2.P_Password, d2.P_Letter, '')) BETWEEN d2.Number_1 AND d2.Number_2

---------------------------------------------
-- Part 2
---------------------------------------------
SELECT
	COUNT(*) AS ct
FROM
	#Day_2 AS d2
WHERE 1=1
	AND (IIF(SUBSTRING(d2.P_Password, d2.Number_1, 1)=d2.P_Letter, 1, 0) <> IIF(SUBSTRING(d2.P_Password, d2.Number_2, 1)=d2.P_Letter, 1, 0))
