---------------------------------------------
-- Author:			Elaine Lin
-- Created Date:	2021-03-16
-- References Used:
---------------------------------------------

DROP TABLE IF EXISTS #Day_23
CREATE TABLE #Day_23
	(
	String NVARCHAR(100)
	)

BULK INSERT #Day_23
FROM '.....\advent-of-code\2015\inputs\Day_23.txt'
WITH
	(
    FIRSTROW = 1,
    FIELDTERMINATOR = ';',
    ROWTERMINATOR = '\n'
	);

ALTER TABLE #Day_23 ADD ID INT IDENTITY(1,1) --To preserve input order

DROP TABLE IF EXISTS #Instructions
CREATE TABLE #Instructions
	(
	ID INT
	,String NVARCHAR(100)
	,Command NVARCHAR(3)
	,Register NVARCHAR(1)
	,Num INT
	)

;WITH Instructions AS
	(
	SELECT
		d.ID
		,d.String
		,ss.[value]
		,ROW_NUMBER() OVER(PARTITION BY d.ID ORDER BY (SELECT NULL))
			+ IIF(LEN(d.String)-LEN(REPLACE(d.String, ' ', ''))=1 AND LEFT(ss.[value], 1) IN ('+', '-'), 1, 0) AS rn
		,LEN(d.String)-LEN(REPLACE(d.String, ' ', '')) AS ct_Spaces
	FROM
		#Day_23 AS d
		CROSS APPLY STRING_SPLIT(d.String, ' ') AS ss
	WHERE 1=1
	)

INSERT INTO #Instructions
		(
		ID
		,String
		,Command
		,Register
		,Num
		)
	SELECT
		c.ID
		,c.String
		,c.[value] AS Command
		,LEFT(r.[value], 1) AS Register
		,CAST(n.[value] AS INT) AS Num
	FROM
		Instructions AS c
		LEFT JOIN Instructions AS r ON r.ID=c.ID AND r.rn=2
		LEFT JOIN Instructions AS n ON n.ID=c.ID AND n.rn=3
	WHERE 1=1
		AND c.rn=1

--SELECT * FROM #Instructions AS i

---------------------------------------------
-- Part 1
---------------------------------------------
;WITH Instructions_Part_1 AS
	(
	SELECT
		i.ID
		,i.String
		,i.Command
		,i.Register
		,i.Num
		,0 AS A
		,0 AS B
		,1 AS Lvl
	FROM
		#Instructions AS i
	WHERE 1=1
		AND i.ID = 1

	UNION ALL

	SELECT
		i2.ID
		,i2.String
		,i2.Command
		,i2.Register
		,i2.Num
		,CASE
			WHEN i2.Command='hlf' AND i2.Register='a' THEN i.A/2
			WHEN i2.Command='tpl' AND i2.Register='a' THEN i.A*3
			WHEN i2.Command='inc' AND i2.Register='a' THEN i.A+1
			ELSE i.A
		END AS A
		,CASE
			WHEN i2.Command='hlf' AND i2.Register='b' THEN i.B/2
			WHEN i2.Command='tpl' AND i2.Register='b' THEN i.B*3
			WHEN i2.Command='inc' AND i2.Register='b' THEN i.B+1
			ELSE i.B
		END AS B
		,i.Lvl + 1
	FROM
		Instructions_Part_1 AS i
		JOIN #Instructions AS i2 ON i2.ID=i.ID+CASE
													WHEN i.Command IN ('hlf', 'tpl', 'inc') THEN 1
													WHEN i.Command='jmp' THEN i.Num
													WHEN i.Command='jie' THEN CASE
																				WHEN i.Register='a' THEN IIF(i.A%2=0, i.Num, 1)
																				WHEN i.Register='b' THEN IIF(i.B%2=0, i.Num, 1)
																			END
													WHEN i.Command='jio' THEN CASE
																				WHEN i.Register='a' THEN IIF(i.A=1, i.Num, 1)
																				WHEN i.Register='b' THEN IIF(i.B=1, i.Num, 1)
																			END
												END
	)

SELECT TOP 1
	*
FROM
	Instructions_Part_1 AS i
WHERE 1=1
ORDER BY
	i.Lvl DESC
OPTION(MAXRECURSION 10000)

---------------------------------------------
-- Part 2
---------------------------------------------
;WITH Instructions_Part_2 AS
	(
	SELECT
		i.ID
		,i.String
		,i.Command
		,i.Register
		,i.Num
		,1 AS A
		,0 AS B
		,1 AS Lvl
	FROM
		#Instructions AS i
	WHERE 1=1
		AND i.ID = 1

	UNION ALL

	SELECT
		i2.ID
		,i2.String
		,i2.Command
		,i2.Register
		,i2.Num
		,CASE
			WHEN i2.Command='hlf' AND i2.Register='a' THEN i.A/2
			WHEN i2.Command='tpl' AND i2.Register='a' THEN i.A*3
			WHEN i2.Command='inc' AND i2.Register='a' THEN i.A+1
			ELSE i.A
		END AS A
		,CASE
			WHEN i2.Command='hlf' AND i2.Register='b' THEN i.B/2
			WHEN i2.Command='tpl' AND i2.Register='b' THEN i.B*3
			WHEN i2.Command='inc' AND i2.Register='b' THEN i.B+1
			ELSE i.B
		END AS B
		,i.Lvl + 1
	FROM
		Instructions_Part_2 AS i
		JOIN #Instructions AS i2 ON i2.ID=i.ID+CASE
													WHEN i.Command IN ('hlf', 'tpl', 'inc') THEN 1
													WHEN i.Command='jmp' THEN i.Num
													WHEN i.Command='jie' THEN CASE
																				WHEN i.Register='a' THEN IIF(i.A%2=0, i.Num, 1)
																				WHEN i.Register='b' THEN IIF(i.B%2=0, i.Num, 1)
																			END
													WHEN i.Command='jio' THEN CASE
																				WHEN i.Register='a' THEN IIF(i.A=1, i.Num, 1)
																				WHEN i.Register='b' THEN IIF(i.B=1, i.Num, 1)
																			END
												END
	)

SELECT TOP 1
	*
FROM
	Instructions_Part_2 AS i
WHERE 1=1
ORDER BY
	i.Lvl DESC
OPTION(MAXRECURSION 10000)
