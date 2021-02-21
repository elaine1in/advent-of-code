---------------------------------------------
-- Author:			Elaine Lin
-- Created Date:	2021-02-20
-- References Used:
---------------------------------------------

DROP TABLE IF EXISTS #Day_12
CREATE TABLE #Day_12
	(
	String NVARCHAR(10)
	)

BULK INSERT #Day_12
FROM '.....\advent-of-code\2020\inputs\Day_12.txt'
WITH
	(
    FIRSTROW = 1,
    FIELDTERMINATOR = ';',
    ROWTERMINATOR = '\n'
	);

ALTER TABLE #Day_12 ADD ID INT IDENTITY(1,1) --To preserve input order

DROP TABLE IF EXISTS #Directions
CREATE TABLE #Directions
	(
	ID INT IDENTITY(0,1)
	,Negative_ID INT
	,Direction_Name NVARCHAR(10)
	,Direction_Letter NVARCHAR(1)
	)

INSERT INTO #Directions
		(
		Direction_Name
		,Direction_Letter
		)
	VALUES
		('North', 'N')
		,('East', 'E')
		,('South', 'S')
		,('West', 'W')

UPDATE
	d
SET
	d.Negative_ID = (d.ID%4)-4
FROM
	#Directions AS d
WHERE 1=1

SELECT * FROM #Directions AS d

---------------------------------------------
-- Test Scenario
---------------------------------------------
--TRUNCATE TABLE #Day_12
--INSERT INTO #Day_12
--		(
--		String
--		)
--	VALUES
--		('F10')
--		,('N3')
--		,('F7')
--		,('R90')
--		,('F11')
		
SELECT * FROM #Day_12 AS d12

DROP TABLE IF EXISTS #Instructions_Stg
CREATE TABLE #Instructions_Stg
	(
	ID INT
	,String NVARCHAR(10)
	,[Action] NVARCHAR(1)
	,[Value] INT
	,Current_Direction_ID INT
	,Waypoint_X INT
	,Waypoint_Y INT
	)

INSERT INTO #Instructions_Stg
		(
		ID
		,String
		,[Action]
		,[Value]
		,Current_Direction_ID
		,Waypoint_X
		,Waypoint_Y
		)
	SELECT
		d.ID
		,d.String
		,LEFT(d.String, 1) AS [Action]
		,CAST(RIGHT(d.String, LEN(d.String)-1) AS INT) AS [Value]
		,IIF(d.ID=1, 1, NULL) AS Current_Direction_ID
		,IIF(d.ID=1, 10, NULL) AS Waypoint_X
		,IIF(d.ID=1, 1, NULL) AS Waypoint_Y
	FROM
		#Day_12 AS d
	WHERE 1=1	

/*
For Part 1 & Part 2
	Grab TOP 1 record ORDER BY ID DESC as the solution is implemented using /running totals/
	Hence, the last row is the final result

	Part 1 solely uses window functions
	Part 2 uses recursive CTE and window functions
*/
---------------------------------------------
-- Part 1
---------------------------------------------
;WITH Instructions AS
	(
	SELECT
		i.ID
		,i.String
		,i.[Action]
		,i.[Value]
		,i.Current_Direction_ID
		,IIF(i.[Action] IN ('L', 'R'), ((i.[Value]/90)*IIF(i.[Action]='L', -1, 1)), NULL) AS Direction_Index_Value
		,SUM(
			ISNULL(i.Current_Direction_ID, 0)
			+
			ISNULL(IIF(i.[Action] IN ('L', 'R'), ((i.[Value]/90)*IIF(i.[Action]='L', -1, 1)), NULL), 0)
			) OVER(ORDER BY i.ID) % 4 AS New_Current_Direction_ID
	FROM
		#Instructions_Stg AS i
	WHERE 1=1
	)

SELECT TOP 1
	(ABS(a.North-a.South) + ABS(a.East-a.West)) AS Answer
FROM
	(
	SELECT
		i.ID
		,i.String
		,i.[Action]
		,i.[Value]
		,i.Current_Direction_ID
		,i.Direction_Index_Value
		,i.New_Current_Direction_ID
		,d.Direction_Letter
		,SUM(
			ISNULL(IIF(i.[Action]='N', i.[Value], NULL), 0)
			+
			ISNULL(IIF(i.[Action]='F' AND d.Direction_Letter='N', i.[Value], NULL), 0)
			) OVER(ORDER BY i.ID) AS North
		,SUM(
			ISNULL(IIF(i.[Action]='S', i.[Value], NULL), 0)
			+
			ISNULL(IIF(i.[Action]='F' AND d.Direction_Letter='S', i.[Value], NULL), 0)
			) OVER(ORDER BY i.ID) AS South
		,SUM(
			ISNULL(IIF(i.[Action]='E', i.[Value], NULL), 0)
			+
			ISNULL(IIF(i.[Action]='F' AND d.Direction_Letter='E', i.[Value], NULL), 0)
			) OVER(ORDER BY i.ID) AS East
		,SUM(
			ISNULL(IIF(i.[Action]='W', i.[Value], NULL), 0)
			+
			ISNULL(IIF(i.[Action]='F' AND d.Direction_Letter='W', i.[Value], NULL), 0)
			) OVER(ORDER BY i.ID) AS West
	FROM
		Instructions AS i
		JOIN #Directions AS d ON (d.ID=i.New_Current_Direction_ID) OR (d.Negative_ID=i.New_Current_Direction_ID)
	WHERE 1=1
	) AS a
WHERE 1=1
ORDER BY
	a.ID DESC

---------------------------------------------
-- Part 2
---------------------------------------------
;WITH Instructions AS
	(
	SELECT
		i.ID
		,i.String
		,i.[Action]
		,i.[Value]
		,i.Waypoint_X
		,i.Waypoint_Y
	FROM
		#Instructions_Stg AS i
	WHERE 1=1
		AND i.ID = 1

	UNION ALL

	SELECT
		i2.ID
		,i2.String
		,i2.[Action]
		,i2.[Value]
		,CASE
			WHEN i2.[Action]='R' THEN CASE (i2.[Value]/90)%4
										WHEN 0 THEN i.Waypoint_X
										WHEN 1 THEN i.Waypoint_Y
										WHEN 2 THEN i.Waypoint_X*-1
										WHEN 3 THEN i.Waypoint_Y*-1
									END
			WHEN i2.[Action]='L' THEN CASE (i2.[Value]/90)%4
										WHEN 0 THEN i.Waypoint_X
										WHEN 1 THEN i.Waypoint_Y*-1
										WHEN 2 THEN i.Waypoint_X*-1
										WHEN 3 THEN i.Waypoint_Y
									END
			ELSE i.Waypoint_X + CASE
									WHEN i2.[Action]='E' THEN i2.[Value]
									WHEN i2.[Action]='W' THEN i2.[Value]*-1
									ELSE 0
								END
		END AS Waypoint_X
		,CASE
			WHEN i2.[Action]='R' THEN CASE (i2.[Value]/90)%4
										WHEN 0 THEN i.Waypoint_Y
										WHEN 1 THEN i.Waypoint_X*-1
										WHEN 2 THEN i.Waypoint_Y*-1
										WHEN 3 THEN i.Waypoint_X
									END
			WHEN i2.[Action]='L' THEN CASE (i2.[Value]/90)%4
										WHEN 0 THEN i.Waypoint_Y
										WHEN 1 THEN i.Waypoint_X
										WHEN 2 THEN i.Waypoint_Y*-1
										WHEN 3 THEN i.Waypoint_X*-1
									END
			ELSE i.Waypoint_Y + CASE
									WHEN i2.[Action]='N' THEN i2.[Value]
									WHEN i2.[Action]='S' THEN i2.[Value]*-1
									ELSE 0
								END
		END AS Waypoint_Y
	FROM
		Instructions AS i
		JOIN #Instructions_Stg AS i2 ON i.ID+1=i2.ID
	WHERE 1=1
	)

SELECT TOP 1
	i.ID
	,i.String
	,i.[Action]
	,i.[Value]
	,i.Waypoint_X
	,i.Waypoint_Y
	,SUM(IIF(i.[Action]='F', i.[Value]*i.Waypoint_X, NULL)) OVER(ORDER BY i.ID) AS Ship_X
	,SUM(IIF(i.[Action]='F', i.[Value]*i.Waypoint_Y, NULL)) OVER(ORDER BY i.ID) AS Ship_Y
	,ABS(SUM(IIF(i.[Action]='F', i.[Value]*i.Waypoint_X, NULL)) OVER(ORDER BY i.ID)) + ABS(SUM(IIF(i.[Action]='F', i.[Value]*i.Waypoint_Y, NULL)) OVER(ORDER BY i.ID)) AS Answer
FROM
	Instructions AS i
WHERE 1=1
ORDER BY
	i.ID DESC
OPTION (MAXRECURSION 1000)
