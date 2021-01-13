---------------------------------------------
-- Author:			Elaine Lin
-- Created Date:	2021-01-11
-- References Used:
---------------------------------------------

DROP TABLE IF EXISTS #Day_06
CREATE TABLE #Day_06
	(
	String NVARCHAR(100)
	)

BULK INSERT #Day_06
FROM '.....\advent-of-code\2015\inputs\Day_06.txt'
WITH
	(
    FIRSTROW = 1,
    FIELDTERMINATOR = ';',
    ROWTERMINATOR = '\n'
	);

ALTER TABLE #Day_06 ADD ID INT IDENTITY(1,1) --To preserve input order

SELECT * FROM #Day_06 AS d06

DROP TABLE IF EXISTS #Numbers
CREATE TABLE #Numbers
	(
	Num INT
	)

DROP TABLE IF EXISTS #Lights
CREATE TABLE #Lights
	(
	X INT
	,Y INT
	,Is_Lit INT DEFAULT(0)
	)

;WITH Numbers AS
	(
	SELECT 0 AS Num

	UNION ALL

	SELECT
		n.Num+1 AS Num
	FROM
		Numbers AS n
	WHERE 1=1
		AND n.Num<999
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
	OPTION (MAXRECURSION 1000)

INSERT INTO #Lights
		(
		X
		,Y
		)
	SELECT
		n1.Num
		,n2.Num
	FROM
		#Numbers AS n1
		CROSS JOIN #Numbers AS n2
	WHERE 1=1

CREATE CLUSTERED INDEX IX_Lights_X_Y ON #Lights (X, Y)

---------------------------------------------
-- Part 1
---------------------------------------------
DECLARE @counter INT = 0
DECLARE @range INT = (SELECT COUNT(*) FROM #Day_06 AS d)

DECLARE @action NVARCHAR(10)
DECLARE @coordinate_start_x INT
DECLARE @coordinate_start_y INT
DECLARE @coordinate_end_x INT
DECLARE @coordinate_end_y INT

WHILE @counter < @range
	BEGIN
		SELECT
			@action = d.[Action]
			,@coordinate_start_x = LEFT(d.Coordinate_Start, CHARINDEX(',', d.Coordinate_Start)-1)
			,@coordinate_start_y = RIGHT(d.Coordinate_Start, CHARINDEX(',', REVERSE(d.Coordinate_Start))-1)
			,@coordinate_end_x = LEFT(d.Coordinate_End, CHARINDEX(',', d.Coordinate_End)-1)
			,@coordinate_end_y = RIGHT(d.Coordinate_End, CHARINDEX(',', REVERSE(d.Coordinate_End))-1)
		FROM
			(
			SELECT
				d06.ID
				,d06.String
				,LEFT(d06.String, PATINDEX('%[0-9]%', d06.String)-2) AS [Action]
				,SUBSTRING(d06.String, PATINDEX('%[0-9]%', d06.String), CHARINDEX(' through', d06.String)-PATINDEX('%[0-9]%', d06.String)) AS Coordinate_Start
				,RIGHT(d06.String, CHARINDEX('h', REVERSE(d06.String))-2) AS Coordinate_End
			FROM
				#Day_06 AS d06
			WHERE 1=1
			) AS d
		WHERE 1=1
		ORDER BY
			d.ID
		OFFSET @counter ROWS
		FETCH NEXT 1 ROW ONLY

		---------------------------------------------
		--Update #Lights
		---------------------------------------------
		UPDATE
			l
		SET
			l.Is_Lit = CASE
							WHEN @action='toggle' THEN IIF(l.Is_Lit=0, 1, 0)
							WHEN @action='turn on' THEN 1
							WHEN @action='turn off' THEN 0
						END
		FROM
			#Lights AS l
		WHERE 1=1
			AND l.X BETWEEN @coordinate_start_x AND @coordinate_end_x
			AND l.Y BETWEEN @coordinate_start_y AND @coordinate_end_y

		SET @counter += 1
	END

SELECT
	COUNT(*) AS Answer
FROM
	#Lights AS l
WHERE 1=1
	AND l.Is_Lit = 1

GO

---------------------------------------------
-- Part 2
---------------------------------------------
--Reset values for part 2 processing
UPDATE
	l
SET
	l.Is_Lit = 0
FROM
	#Lights AS l
WHERE 1=1

DECLARE @counter INT = 0
DECLARE @range INT = (SELECT COUNT(*) FROM #Day_06 AS d)

DECLARE @action NVARCHAR(10)
DECLARE @coordinate_start_x INT
DECLARE @coordinate_start_y INT
DECLARE @coordinate_end_x INT
DECLARE @coordinate_end_y INT

WHILE @counter < @range
	BEGIN
		SELECT
			@action = d.[Action]
			,@coordinate_start_x = LEFT(d.Coordinate_Start, CHARINDEX(',', d.Coordinate_Start)-1)
			,@coordinate_start_y = RIGHT(d.Coordinate_Start, CHARINDEX(',', REVERSE(d.Coordinate_Start))-1)
			,@coordinate_end_x = LEFT(d.Coordinate_End, CHARINDEX(',', d.Coordinate_End)-1)
			,@coordinate_end_y = RIGHT(d.Coordinate_End, CHARINDEX(',', REVERSE(d.Coordinate_End))-1)
		FROM
			(
			SELECT
				d06.ID
				,d06.String
				,LEFT(d06.String, PATINDEX('%[0-9]%', d06.String)-2) AS [Action]
				,SUBSTRING(d06.String, PATINDEX('%[0-9]%', d06.String), CHARINDEX(' through', d06.String)-PATINDEX('%[0-9]%', d06.String)) AS Coordinate_Start
				,RIGHT(d06.String, CHARINDEX('h', REVERSE(d06.String))-2) AS Coordinate_End
			FROM
				#Day_06 AS d06
			WHERE 1=1
			) AS d
		WHERE 1=1
		ORDER BY
			d.ID
		OFFSET @counter ROWS
		FETCH NEXT 1 ROW ONLY

		---------------------------------------------
		--Update #Lights
		---------------------------------------------
		UPDATE
			l
		SET
			l.Is_Lit = CASE
							WHEN @action='toggle' THEN l.Is_Lit+2
							WHEN @action='turn on' THEN l.Is_Lit+1
							WHEN @action='turn off' THEN IIF(l.Is_Lit=0, 0, l.Is_Lit-1)
						END
		FROM
			#Lights AS l
		WHERE 1=1
			AND l.X BETWEEN @coordinate_start_x AND @coordinate_end_x
			AND l.Y BETWEEN @coordinate_start_y AND @coordinate_end_y

		SET @counter += 1
	END

SELECT
	SUM(l.Is_Lit) AS Answer
FROM
	#Lights AS l
WHERE 1=1
