---------------------------------------------
-- Author:			Elaine Lin
-- Created Date:	2021-04-04
-- References Used:
---------------------------------------------

DROP TABLE IF EXISTS #Day_01
CREATE TABLE #Day_01
	(
	String NVARCHAR(10)
	)

BULK INSERT #Day_01
FROM '.....\advent-of-code\2016\inputs\Day_01.txt'
WITH
	(
    FIRSTROW = 1,
    FIELDTERMINATOR = ';',
    ROWTERMINATOR = ', '
	);

ALTER TABLE #Day_01 ADD ID INT IDENTITY(1,1) --To preserve input order
ALTER TABLE #Day_01 ADD LR AS LEFT(String, 1)
ALTER TABLE #Day_01 ADD Num AS CAST(RIGHT(String, LEN(String)-1) AS INT)

DROP TABLE IF EXISTS #Directions
CREATE TABLE #Directions
	(
	ID INT IDENTITY(0,1)
	,Negative_ID INT
	,Direction_Name NVARCHAR(10)
	)

INSERT INTO #Directions
		(
		Direction_Name
		)
	VALUES
		('North')
		,('East')
		,('South')
		,('West')

UPDATE
	d
SET
	d.Negative_ID = (d.ID%4)-4
FROM
	#Directions AS d
WHERE 1=1

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
		AND n.Num+1 <= 1000
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
-- Test Scenario
---------------------------------------------
--TRUNCATE TABLE #Day_01
--INSERT INTO #Day_01
--		(
--		String
--		)
--	VALUES
--		('R5')
--		,('L5')
--		,('R5')
--		,('R3')
--	VALUES
--		('R8')
--		,('R4')
--		,('R4')
--		,('R8')

--SELECT * FROM #Day_01 AS d

---------------------------------------------
-- Part 1
---------------------------------------------
;WITH Instructions AS
	(
	SELECT
		0 AS ID
		,CAST('' AS NVARCHAR(10)) AS String
		,CAST('' AS NVARCHAR(1)) AS LR
		,0 AS Num
		,CAST('North' AS NVARCHAR(10)) AS Direction
		,0 AS X
		,0 AS Y

	UNION ALL

	SELECT
		d.ID
		,d.String
		,d.LR
		,d.Num
		,d3.Direction_Name
		,CASE
			WHEN d3.Direction_Name='East' THEN i.X+d.Num
			WHEN d3.Direction_Name='West' THEN i.X+(d.Num*-1)
			ELSE i.X
		END AS X
		,CASE
			WHEN d3.Direction_Name='North' THEN i.Y+d.Num
			WHEN d3.Direction_Name='South' THEN i.Y+(d.Num*-1)
			ELSE i.Y
		END AS Y
	FROM
		Instructions AS i
		JOIN #Day_01 AS d ON d.ID=i.ID+1
		JOIN #Directions AS d2 ON d2.Direction_Name=i.Direction
		JOIN #Directions AS d3 ON (d3.ID=(d2.ID+IIF(d.LR='R', 1, -1))%4) OR (d3.Negative_ID=(d2.ID+IIF(d.LR='R', 1, -1))%4)
	WHERE 1=1
	)

SELECT TOP 1
	(ABS(i.X) + ABS(i.Y)) AS Answer
FROM
	Instructions AS i
WHERE 1=1
ORDER BY
	i.ID DESC
OPTION (MAXRECURSION 0)

---------------------------------------------
-- Part 2
---------------------------------------------
DROP TABLE IF EXISTS #Visited_Coordinates
CREATE TABLE #Visited_Coordinates
	(
	ID INT
	,String NVARCHAR(10)
	,LR NVARCHAR(1)
	,Num INT
	,Direction NVARCHAR(10)
	,X INT
	,Y INT
	,Num_1 INT
	,Is_LV INT
	,rn INT
	)

;WITH Instructions AS
	(
	SELECT
		0 AS ID
		,CAST('' AS NVARCHAR(10)) AS String
		,CAST('' AS NVARCHAR(1)) AS LR
		,0 AS Num
		,CAST('North' AS NVARCHAR(10)) AS Direction
		,0 AS X
		,0 AS Y
		,0 AS Num_1
		,1 AS Is_LV

	UNION ALL

	SELECT
		d.ID
		,d.String
		,d.LR
		,d.Num
		,d3.Direction_Name
		,CASE
			WHEN d3.Direction_Name='East' THEN i.X+n.Num
			WHEN d3.Direction_Name='West' THEN i.X-n.Num
			ELSE i.X
		END AS X
		,CASE
			WHEN d3.Direction_Name='North' THEN i.Y+n.Num
			WHEN d3.Direction_Name='South' THEN i.Y-n.Num
			ELSE i.Y
		END AS Y
		,n.Num
		,IIF(n.Num=LAST_VALUE(n.Num) OVER(PARTITION BY d.ID ORDER BY n.Num RANGE BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING), 1, 0) AS Is_LV
	FROM
		Instructions AS i
		JOIN #Day_01 AS d ON d.ID=i.ID+1
		JOIN #Directions AS d2 ON d2.Direction_Name=i.Direction
		JOIN #Directions AS d3 ON (d3.ID=(d2.ID+IIF(d.LR='R', 1, -1))%4) OR (d3.Negative_ID=(d2.ID+IIF(d.LR='R', 1, -1))%4)
		JOIN #Numbers AS n ON n.Num<=d.Num AND i.Is_LV=1
	WHERE 1=1
	)

INSERT INTO #Visited_Coordinates
		(
		ID
		,String
		,LR
		,Num
		,Direction
		,X
		,Y
		,Num_1
		,Is_LV
		,rn
		)
	SELECT
		i.ID
		,i.String
		,i.LR
		,i.Num
		,i.Direction
		,i.X
		,i.Y
		,i.Num_1
		,i.Is_LV
		,ROW_NUMBER() OVER(ORDER BY i.ID, i.Num_1) AS rn
	FROM
		Instructions AS i
	WHERE 1=1
	OPTION (MAXRECURSION 0)

SELECT TOP 1
	(ABS(vc.X) + ABS(vc.Y)) AS Answer
FROM
	#Visited_Coordinates AS vc
WHERE 1=1
	AND EXISTS(
				SELECT
					1
				FROM
					#Visited_Coordinates AS vc2
				WHERE 1=1
					AND vc2.rn>vc.rn
					AND vc2.X=vc.X
					AND vc2.Y=vc.Y
				)
ORDER BY
	vc.rn
