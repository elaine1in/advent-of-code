---------------------------------------------
-- Author:			Elaine Lin
-- Created Date:	2021-05-02
-- References Used:
---------------------------------------------

DROP TABLE IF EXISTS #Day_12
CREATE TABLE #Day_12
	(
	Instructions NVARCHAR(100)
	)

BULK INSERT #Day_12
FROM '.....\advent-of-code\2016\inputs\Day_12.txt'
WITH
	(
    FIRSTROW = 1,
    FIELDTERMINATOR = ';',
    ROWTERMINATOR = '\n'
	);

ALTER TABLE #Day_12 ADD ID INT IDENTITY(0,1) --To preserve input order

DROP TABLE IF EXISTS #Day_12_Instructions
CREATE TABLE #Day_12_Instructions
	(
	ID INT
	,Instructions NVARCHAR(100)
	,Command NVARCHAR(3)
	,X NVARCHAR(100)
	,Y NVARCHAR(100)
	)

INSERT INTO #Day_12_Instructions
		(
		ID
		,Instructions
		,Command
		,X
		,Y
		)
	SELECT
		p.ID
		,p.Instructions
		,p.[1] AS Command
		,p.[2] AS X
		,p.[3] AS Y
	FROM
		(
		SELECT
			d.ID
			,d.Instructions
			,ss.[value]
			,ROW_NUMBER() OVER(PARTITION BY d.ID ORDER BY (SELECT NULL)) AS rn
		FROM
			#Day_12 AS d
			CROSS APPLY STRING_SPLIT(d.Instructions, ' ') AS ss
		WHERE 1=1
		) AS ds
		PIVOT (MAX([value]) FOR rn IN ([1], [2], [3])) AS p
	WHERE 1=1

CREATE CLUSTERED INDEX IX_Day_12_Instructions_001 ON #Day_12_Instructions (ID)

---------------------------------------------
-- Part 1
---------------------------------------------
;WITH Instructions AS
	(
	SELECT
		d.ID
		,d.Instructions
		,d.Command
		,d.X
		,d.Y
		,0 AS A
		,0 AS B
		,0 AS C
		,0 AS D
		,0 AS Lvl
	FROM
		#Day_12_Instructions AS d
	WHERE 1=1
		AND d.ID = 0

	UNION ALL

	SELECT
		d.ID
		,d.Instructions
		,d.Command
		,d.X
		,d.Y
		,CASE
			WHEN i.Command='cpy' AND i.Y='a' THEN IIF(TRY_CAST(i.X AS INT) IS NOT NULL, CAST(i.X AS INT), CASE
																												WHEN i.X='a' THEN i.A
																												WHEN i.X='b' THEN i.B
																												WHEN i.X='c' THEN i.C
																												WHEN i.X='d' THEN i.D
																											END)
			WHEN i.Command='inc' AND i.X='a' THEN i.A+1
			WHEN i.Command='dec' AND i.X='a' THEN i.A-1
			ELSE i.A
		END AS A
		,CASE
			WHEN i.Command='cpy' AND i.Y='b' THEN IIF(TRY_CAST(i.X AS INT) IS NOT NULL, CAST(i.X AS INT), CASE
																												WHEN i.X='a' THEN i.A
																												WHEN i.X='b' THEN i.B
																												WHEN i.X='c' THEN i.C
																												WHEN i.X='d' THEN i.D
																											END)
			WHEN i.Command='inc' AND i.X='b' THEN i.B+1
			WHEN i.Command='dec' AND i.X='b' THEN i.B-1
			ELSE i.B
		END AS B
		,CASE
			WHEN i.Command='cpy' AND i.Y='c' THEN IIF(TRY_CAST(i.X AS INT) IS NOT NULL, CAST(i.X AS INT), CASE
																												WHEN i.X='a' THEN i.A
																												WHEN i.X='b' THEN i.B
																												WHEN i.X='c' THEN i.C
																												WHEN i.X='d' THEN i.D
																											END)
			WHEN i.Command='inc' AND i.X='c' THEN i.C+1
			WHEN i.Command='dec' AND i.X='c' THEN i.C-1
			ELSE i.C
		END AS C
		,CASE
			WHEN i.Command='cpy' AND i.Y='d' THEN IIF(TRY_CAST(i.X AS INT) IS NOT NULL, CAST(i.X AS INT), CASE
																												WHEN i.X='a' THEN i.A
																												WHEN i.X='b' THEN i.B
																												WHEN i.X='c' THEN i.C
																												WHEN i.X='d' THEN i.D
																											END)
			WHEN i.Command='inc' AND i.X='d' THEN i.D+1
			WHEN i.Command='dec' AND i.X='d' THEN i.D-1
			ELSE i.D
		END AS D
		,i.Lvl+1 AS Lvl
	FROM
		#Day_12_Instructions AS d
		JOIN Instructions AS i ON i.ID+IIF(i.Command='jnz', CASE
																WHEN TRY_CAST(i.X AS INT) IS NOT NULL THEN IIF(CAST(i.X AS INT)<>0, CAST(i.Y AS INT), 1)
																ELSE CASE
																		WHEN i.X='a' THEN IIF(i.A<>0, CAST(i.Y AS INT), 1)
																		WHEN i.X='b' THEN IIF(i.B<>0, CAST(i.Y AS INT), 1)
																		WHEN i.X='c' THEN IIF(i.C<>0, CAST(i.Y AS INT), 1)
																		WHEN i.X='d' THEN IIF(i.D<>0, CAST(i.Y AS INT), 1)
																	END
															END, 1)=d.ID
	)

SELECT TOP 1
	i.A AS Answer
FROM
	Instructions AS i
ORDER BY i.Lvl DESC
OPTION (MAXRECURSION 0)

---------------------------------------------
-- Part 2
---------------------------------------------
;WITH Instructions AS
	(
	SELECT
		d.ID
		,d.Instructions
		,d.Command
		,d.X
		,d.Y
		,0 AS A
		,0 AS B
		,1 AS C
		,0 AS D
		,0 AS Lvl
	FROM
		#Day_12_Instructions AS d
	WHERE 1=1
		AND d.ID = 0

	UNION ALL

	SELECT
		d.ID
		,d.Instructions
		,d.Command
		,d.X
		,d.Y
		,CASE
			WHEN i.Command='cpy' AND i.Y='a' THEN IIF(TRY_CAST(i.X AS INT) IS NOT NULL, CAST(i.X AS INT), CASE
																												WHEN i.X='a' THEN i.A
																												WHEN i.X='b' THEN i.B
																												WHEN i.X='c' THEN i.C
																												WHEN i.X='d' THEN i.D
																											END)
			WHEN i.Command='inc' AND i.X='a' THEN i.A+1
			WHEN i.Command='dec' AND i.X='a' THEN i.A-1
			ELSE i.A
		END AS A
		,CASE
			WHEN i.Command='cpy' AND i.Y='b' THEN IIF(TRY_CAST(i.X AS INT) IS NOT NULL, CAST(i.X AS INT), CASE
																												WHEN i.X='a' THEN i.A
																												WHEN i.X='b' THEN i.B
																												WHEN i.X='c' THEN i.C
																												WHEN i.X='d' THEN i.D
																											END)
			WHEN i.Command='inc' AND i.X='b' THEN i.B+1
			WHEN i.Command='dec' AND i.X='b' THEN i.B-1
			ELSE i.B
		END AS B
		,CASE
			WHEN i.Command='cpy' AND i.Y='c' THEN IIF(TRY_CAST(i.X AS INT) IS NOT NULL, CAST(i.X AS INT), CASE
																												WHEN i.X='a' THEN i.A
																												WHEN i.X='b' THEN i.B
																												WHEN i.X='c' THEN i.C
																												WHEN i.X='d' THEN i.D
																											END)
			WHEN i.Command='inc' AND i.X='c' THEN i.C+1
			WHEN i.Command='dec' AND i.X='c' THEN i.C-1
			ELSE i.C
		END AS C
		,CASE
			WHEN i.Command='cpy' AND i.Y='d' THEN IIF(TRY_CAST(i.X AS INT) IS NOT NULL, CAST(i.X AS INT), CASE
																												WHEN i.X='a' THEN i.A
																												WHEN i.X='b' THEN i.B
																												WHEN i.X='c' THEN i.C
																												WHEN i.X='d' THEN i.D
																											END)
			WHEN i.Command='inc' AND i.X='d' THEN i.D+1
			WHEN i.Command='dec' AND i.X='d' THEN i.D-1
			ELSE i.D
		END AS D
		,i.Lvl+1 AS Lvl
	FROM
		#Day_12_Instructions AS d
		JOIN Instructions AS i ON i.ID+IIF(i.Command='jnz', CASE
																WHEN TRY_CAST(i.X AS INT) IS NOT NULL THEN IIF(CAST(i.X AS INT)<>0, CAST(i.Y AS INT), 1)
																ELSE CASE
																		WHEN i.X='a' THEN IIF(i.A<>0, CAST(i.Y AS INT), 1)
																		WHEN i.X='b' THEN IIF(i.B<>0, CAST(i.Y AS INT), 1)
																		WHEN i.X='c' THEN IIF(i.C<>0, CAST(i.Y AS INT), 1)
																		WHEN i.X='d' THEN IIF(i.D<>0, CAST(i.Y AS INT), 1)
																	END
															END, 1)=d.ID
	)

SELECT TOP 1
	i.A AS Answer
FROM
	Instructions AS i
ORDER BY i.Lvl DESC
OPTION (MAXRECURSION 0)
