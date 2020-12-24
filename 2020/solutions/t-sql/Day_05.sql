---------------------------------------------
-- Author:			Elaine Lin
-- Created Date:	2020-12-22
-- References Used:
--	https://stackoverflow.com/questions/1580017/how-to-replace-multiple-characters-in-sql
---------------------------------------------

DROP TABLE IF EXISTS #Day_05
CREATE TABLE #Day_05
	(
	Binary_Space_Partitioning NVARCHAR(10)
	)

BULK INSERT #Day_05
FROM '.....\advent-of-code\2020\inputs\Day_05.txt'
WITH
	(
    FIRSTROW = 1,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n'
	);

ALTER TABLE #Day_05 ADD ID INT IDENTITY(1,1) --To preserve input order

SELECT * FROM #Day_05 AS d5

DROP TABLE IF EXISTS #Numbers
CREATE TABLE #Numbers
	(
	Number INT
	)

INSERT INTO #Numbers
		(
		Number
		)
	VALUES
		(1)
		,(2)
		,(3)
		,(4)
		,(5)
		,(6)
		,(7)

SELECT * FROM #Numbers

DROP TABLE IF EXISTS #BSP_FB
CREATE TABLE #BSP_FB
	(
	[First_Row] INT
	,Last_Row INT
	,Position_1 NVARCHAR(1)
	,Position_2 NVARCHAR(1)
	,Position_3 NVARCHAR(1)
	,Position_4 NVARCHAR(1)
	,Position_5 NVARCHAR(1)
	,Position_6 NVARCHAR(1)
	,Position_7 NVARCHAR(1)
	,Lvl INT
	)

DROP TABLE IF EXISTS #BSP_LR
CREATE TABLE #BSP_LR
	(
	[First_Row] INT
	,Last_Row INT
	,Position_1 NVARCHAR(1)
	,Position_2 NVARCHAR(1)
	,Position_3 NVARCHAR(1)
	,Lvl INT
	)

DROP TABLE IF EXISTS #Seat_IDs
CREATE TABLE #Seat_IDs
	(
	Seat_ID INT
	)

---------------------------------------------
-- Populate temp tables 
---------------------------------------------
;WITH BSP_FB AS
	(
	SELECT
		0 AS [First_Row]
		,127 AS Last_Row
		,N'' AS Position_1
		,N'' AS Position_2
		,N'' AS Position_3
		,N'' AS Position_4
		,N'' AS Position_5
		,N'' AS Position_6
		,N'' AS Position_7
		,0 AS Lvl

	UNION ALL

	SELECT
		IIF(p.Position='F', b.[First_Row], CAST(CEILING((b.[First_Row]+b.Last_Row)/(2*1.0)) AS INT)) AS [First_Row]
		,IIF(p.Position='F', CAST(FLOOR((b.[First_Row]+b.Last_Row)/(2*1.0)) AS INT), b.Last_Row) AS Last_Row
		,p.Position AS Position_7
		,b.Position_1 AS Position_6
		,b.Position_2 AS Position_5
		,b.Position_3 AS Position_4
		,b.Position_4 AS Position_3
		,b.Position_5 AS Position_2
		,b.Position_6 AS Position_1
		,(b.Lvl + 1) AS Lvl
	FROM
		#Numbers AS n
		CROSS JOIN (
					SELECT
						*
					FROM
						(
						VALUES
							(N'F')
							,(N'B')
						) AS p (Position)
					) AS p
		JOIN BSP_FB AS b ON b.Lvl=n.Number-1
	WHERE 1=1
		AND n.Number <= 7 --7 characters
	)

INSERT INTO #BSP_FB
		(
		[First_Row]
		,Last_Row
		,Position_1
		,Position_2
		,Position_3
		,Position_4
		,Position_5
		,Position_6
		,Position_7
		,Lvl
		)
	SELECT
		b.[First_Row]
		,b.Last_Row
		,b.Position_1
		,b.Position_2
		,b.Position_3
		,b.Position_4
		,b.Position_5
		,b.Position_6
		,b.Position_7
		,b.Lvl
	FROM
		BSP_FB AS b
	WHERE 1=1

;WITH BSP_LR AS
	(
	SELECT
		0 AS [First_Row]
		,7 AS Last_Row
		,N'' AS Position_1
		,N'' AS Position_2
		,N'' AS Position_3
		,0 AS Lvl

	UNION ALL

	SELECT
		IIF(p.Position='L', b.[First_Row], CAST(CEILING((b.[First_Row]+b.Last_Row)/(2*1.0)) AS INT)) AS [First_Row]
		,IIF(p.Position='L', CAST(FLOOR((b.[First_Row]+b.Last_Row)/(2*1.0)) AS INT), b.Last_Row) AS Last_Row
		,p.Position AS Position_3
		,b.Position_1 AS Position_2
		,b.Position_2 AS Position_1
		,(b.Lvl + 1) AS Lvl
	FROM
		#Numbers AS n
		CROSS JOIN (
					SELECT
						*
					FROM
						(
						VALUES
							(N'L')
							,(N'R')
						) AS p (Position)
					) AS p
		JOIN BSP_LR AS b ON b.Lvl=n.Number-1
	WHERE 1=1
		AND n.Number <= 3 --3 characters
	)

INSERT INTO #BSP_LR
		(
		[First_Row]
		,Last_Row
		,Position_1
		,Position_2
		,Position_3
		,Lvl
		)
	SELECT
		b.[First_Row]
		,b.Last_Row
		,b.Position_1
		,b.Position_2
		,b.Position_3
		,b.Lvl
	FROM
		BSP_LR AS b
	WHERE 1=1

;WITH Seat_IDs AS
	(
	SELECT DISTINCT
		(b1.[First_Row]*8)+b2.[First_Row] AS Seat_ID
	FROM
		#BSP_FB AS b1
		CROSS JOIN #BSP_LR AS b2
		JOIN #Day_05 AS d5 ON d5.Binary_Space_Partitioning=CONCAT(b1.Position_7, b1.Position_6, b1.Position_5, b1.Position_4, b1.Position_3, b1.Position_2, b1.Position_1, b2.Position_3, b2.Position_2, b2.Position_1)
	WHERE 1=1
	)

INSERT INTO #Seat_IDs
		(
		Seat_ID
		)
	SELECT
		s.Seat_ID
	FROM
		Seat_IDs AS s
	WHERE 1=1

---------------------------------------------
-- Create Function for Multi-Replace
---------------------------------------------
DROP FUNCTION IF EXISTS dbo.Multi_Replace
GO
CREATE FUNCTION dbo.Multi_Replace
	(
	@String NVARCHAR(10)
	)
RETURNS NVARCHAR(10)
AS
BEGIN

	DECLARE @Bad_Characters TABLE
		(
		[Character] NVARCHAR(1)
		,Replace_With NVARCHAR(1)
		)

	INSERT INTO @Bad_Characters
			(
			[Character]
			,Replace_With
			)
		VALUES
			(N'F', N'0')
			,(N'B', N'1')
			,(N'L', N'0')
			,(N'R', N'1')

	DECLARE @New_String NVARCHAR(100)
	SET @New_String = @String

	SELECT
		@New_String = REPLACE(@New_String, bc.[Character], bc.Replace_With)
	FROM
		@Bad_Characters AS bc
	WHERE 1=1

	RETURN @New_String

END
GO

SELECT
	d5.ID
	,d5.Binary_Space_Partitioning
	,dbo.Multi_Replace(d5.Binary_Space_Partitioning)
FROM
	#Day_05 AS d5
WHERE 1=1
ORDER BY
	d5.ID

---------------------------------------------
-- Part 1
---------------------------------------------
SELECT
	MAX(s.Seat_ID) AS Max_Seat_ID
FROM
	#Seat_IDs AS s
WHERE 1=1

---------------------------------------------
-- Part 2
---------------------------------------------
SELECT
	(a.Seat_ID+a.Lead_Seat_ID)/2 AS Seat_ID
FROM
	(
	SELECT
		s.Seat_ID
		,LEAD(s.Seat_ID) OVER(ORDER BY s.Seat_ID) AS Lead_Seat_ID
		,LEAD(s.Seat_ID) OVER(ORDER BY s.Seat_ID) - s.Seat_ID AS Diff
	FROM
		#Seat_IDs AS s
	WHERE 1=1
	) AS a
WHERE 1=1
	AND a.Diff<>1
