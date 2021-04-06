---------------------------------------------
-- Author:			Elaine Lin
-- Created Date:	2021-04-05
-- References Used:
--	https://therightjoin.wordpress.com/2014/07/18/matrix-multiplication-using-sql/
---------------------------------------------

DROP TABLE IF EXISTS #Day_02
CREATE TABLE #Day_02
	(
	Instructions NVARCHAR(MAX)
	)

BULK INSERT #Day_02
FROM '.....\advent-of-code\2016\inputs\Day_02.txt'
WITH
	(
    FIRSTROW = 1,
    FIELDTERMINATOR = ';',
    ROWTERMINATOR = '\n'
	);
	
ALTER TABLE #Day_02 ADD ID INT IDENTITY(1,1) --To preserve input order

---------------------------------------------
-- Test Scenario
---------------------------------------------
--TRUNCATE TABLE #Day_02
--INSERT INTO #Day_02
--		(Instructions)
--	VALUES
--		('ULL')
--		,('RRDDD')
--		,('LURDL')
--		,('UUUUD')

DROP TABLE IF EXISTS #Keypad
CREATE TABLE #Keypad
	(
	row_num INT
	,col_num INT
	,Code NVARCHAR(1)
	)

DECLARE @Max_Num INT = (SELECT MAX(LEN(d.Instructions)) FROM #Day_02 AS d)

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
	
DECLARE @Len INT

---------------------------------------------
-- Part 1
---------------------------------------------
TRUNCATE TABLE #Keypad
INSERT INTO #Keypad
		(row_num, col_num, Code)
	VALUES
		(0, 0, '1')
		,(0, 1, '2')
		,(0, 2, '3')
		,(1, 0, '4')
		,(1, 1, '5')
		,(1, 2, '6')
		,(2, 0, '7')
		,(2, 1, '8')
		,(2, 2, '9')

SET @Len = (SELECT MAX(p.row_num) FROM #Keypad AS p)

;WITH Commands AS
	(
	SELECT
		ROW_NUMBER() OVER(ORDER BY d.ID, n.Num) AS rn
		,d.Instructions
		,CAST(SUBSTRING(d.Instructions, n.Num, 1) AS NVARCHAR(1)) AS Command
		,IIF(n.Num=LAST_VALUE(n.Num) OVER(PARTITION BY d.ID ORDER BY n.Num RANGE BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING), 1, 0) AS Is_LN
	FROM
		#Day_02 AS d
		JOIN #Numbers AS n ON n.Num<=LEN(d.Instructions)
	WHERE 1=1
	)
,Code AS
	(
	SELECT
		CAST(0 AS BIGINT) AS rn
		,CAST('' AS NVARCHAR(MAX)) AS Instructions
		,CAST('' AS NVARCHAR(1)) AS Command
		,0 AS Is_LN
		,k.row_num
		,k.col_num
		,k.Code
	FROM
		#Keypad AS k
	WHERE 1=1
		AND k.Code = '5'

	UNION ALL

	SELECT
		c2.rn
		,c2.Instructions
		,c2.Command
		,c2.Is_LN
		,ISNULL(k2.row_num, k.row_num) AS row_num
		,ISNULL(k2.col_num, k.col_num) AS col_num
		,ISNULL(k2.Code, k.Code) AS Code
	FROM
		Code AS c
		JOIN Commands AS c2 ON c2.rn=c.rn+1
		JOIN #Keypad AS k ON k.Code=c.Code
		JOIN #Keypad AS k2 ON k2.row_num=CASE
											WHEN (CASE
													WHEN c2.Command='D' THEN 1
													WHEN c2.Command='U' THEN -1
													ELSE 0
												END)+k.row_num<0 THEN 0
											WHEN (CASE
													WHEN c2.Command='D' THEN 1
													WHEN c2.Command='U' THEN -1
													ELSE 0
												END)+k.row_num>@Len THEN @Len
											ELSE (CASE
													WHEN c2.Command='D' THEN 1
													WHEN c2.Command='U' THEN -1
													ELSE 0
												END)+k.row_num
										END AND k2.col_num=CASE
																WHEN (CASE
																		WHEN c2.Command='R' THEN 1
																		WHEN c2.Command='L' THEN -1
																		ELSE 0
																	END)+k.col_num<0 THEN 0
																WHEN (CASE
																		WHEN c2.Command='R' THEN 1
																		WHEN c2.Command='L' THEN -1
																		ELSE 0
																	END)+k.col_num>@Len THEN @Len
																ELSE (CASE
																		WHEN c2.Command='R' THEN 1
																		WHEN c2.Command='L' THEN -1
																		ELSE 0
																	END)+k.col_num
															END
	)

SELECT
	STRING_AGG(c.Code, '') WITHIN GROUP (ORDER BY c.rn) AS Answer
FROM
	Code AS c
WHERE 1=1
	AND c.Is_LN = 1
OPTION (MAXRECURSION 0)

---------------------------------------------
-- Part 2
---------------------------------------------
TRUNCATE TABLE #Keypad
INSERT INTO #Keypad
		(row_num, col_num, Code)
	VALUES
		(0, 0, NULL)
		,(0, 1, NULL)
		,(0, 2, '1')
		,(0, 3, NULL)
		,(0, 4, NULL)
		,(1, 0, NULL)
		,(1, 1, '2')
		,(1, 2, '3')
		,(1, 3, '4')
		,(1, 4, NULL)
		,(2, 0, '5')
		,(2, 1, '6')
		,(2, 2, '7')
		,(2, 3, '8')
		,(2, 4, '9')
		,(3, 0, NULL)
		,(3, 1, 'A')
		,(3, 2, 'B')
		,(3, 3, 'C')
		,(3, 4, NULL)
		,(4, 0, NULL)
		,(4, 1, NULL)
		,(4, 2, 'D')
		,(4, 3, NULL)
		,(4, 4, NULL)

SET @Len = (SELECT MAX(p.row_num) FROM #Keypad AS p)

;WITH Commands AS
	(
	SELECT
		ROW_NUMBER() OVER(ORDER BY d.ID, n.Num) AS rn
		,d.Instructions
		,CAST(SUBSTRING(d.Instructions, n.Num, 1) AS NVARCHAR(1)) AS Command
		,IIF(n.Num=LAST_VALUE(n.Num) OVER(PARTITION BY d.ID ORDER BY n.Num RANGE BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING), 1, 0) AS Is_LN
	FROM
		#Day_02 AS d
		JOIN #Numbers AS n ON n.Num<=LEN(d.Instructions)
	WHERE 1=1
	)
,Code AS
	(
	SELECT
		CAST(0 AS BIGINT) AS rn
		,CAST('' AS NVARCHAR(MAX)) AS Instructions
		,CAST('' AS NVARCHAR(1)) AS Command
		,0 AS Is_LN
		,k.row_num
		,k.col_num
		,k.Code
	FROM
		#Keypad AS k
	WHERE 1=1
		AND k.Code = '5'

	UNION ALL

	SELECT
		c2.rn
		,c2.Instructions
		,c2.Command
		,c2.Is_LN
		,ISNULL(k2.row_num, k.row_num) AS row_num
		,ISNULL(k2.col_num, k.col_num) AS col_num
		,ISNULL(k2.Code, k.Code) AS Code
	FROM
		Code AS c
		JOIN Commands AS c2 ON c2.rn=c.rn+1
		JOIN #Keypad AS k ON k.Code=c.Code
		JOIN #Keypad AS k2 ON k2.row_num=CASE
											WHEN (CASE
													WHEN c2.Command='D' THEN 1
													WHEN c2.Command='U' THEN -1
													ELSE 0
												END)+k.row_num<0 THEN 0
											WHEN (CASE
													WHEN c2.Command='D' THEN 1
													WHEN c2.Command='U' THEN -1
													ELSE 0
												END)+k.row_num>@Len THEN @Len
											ELSE (CASE
													WHEN c2.Command='D' THEN 1
													WHEN c2.Command='U' THEN -1
													ELSE 0
												END)+k.row_num
										END AND k2.col_num=CASE
																WHEN (CASE
																		WHEN c2.Command='R' THEN 1
																		WHEN c2.Command='L' THEN -1
																		ELSE 0
																	END)+k.col_num<0 THEN 0
																WHEN (CASE
																		WHEN c2.Command='R' THEN 1
																		WHEN c2.Command='L' THEN -1
																		ELSE 0
																	END)+k.col_num>@Len THEN @Len
																ELSE (CASE
																		WHEN c2.Command='R' THEN 1
																		WHEN c2.Command='L' THEN -1
																		ELSE 0
																	END)+k.col_num
															END
	)

SELECT
	STRING_AGG(c.Code, '') WITHIN GROUP (ORDER BY c.rn) AS Answer
FROM
	Code AS c
WHERE 1=1
	AND c.Is_LN = 1
OPTION (MAXRECURSION 0)
