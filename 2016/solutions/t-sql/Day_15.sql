---------------------------------------------
-- Author:			Elaine Lin
-- Created Date:	2021-07-22
-- References Used:
---------------------------------------------

DROP TABLE IF EXISTS #Day_15
CREATE TABLE #Day_15
	(
	Line NVARCHAR(255)
	)

BULK INSERT #Day_15
FROM '.....\advent-of-code\2016\inputs\Day_15.txt'
WITH
	(
    FIRSTROW = 1,
    FIELDTERMINATOR = ';',
    ROWTERMINATOR = '\n'
	);

DROP TABLE IF EXISTS #Numbers
CREATE TABLE #Numbers
	(
	Num INT
	)

;WITH Numbers AS
	(
	SELECT 1 AS Num

	UNION ALL

	SELECT
		n.Num+1 AS Num
	FROM
		Numbers AS n
	WHERE 1=1
		AND n.Num<=2500000
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

CREATE CLUSTERED INDEX IX_Numbers_Num ON #Numbers (Num)

DROP TABLE IF EXISTS #Discs
CREATE TABLE #Discs
	(
	Line NVARCHAR(255)
	,disc INT
	,number_of_positions INT
	,current_position INT
	)

INSERT INTO #Discs
		(
		Line
		,disc
		,number_of_positions
		,current_position
		)
	SELECT
		d.Line
		,CAST(SUBSTRING(d.Line, CHARINDEX('#', d.Line)+1, CHARINDEX(' has', d.Line)-CHARINDEX('#', d.Line)) AS INT) AS disc
		,CAST(SUBSTRING(d.Line, CHARINDEX('has ', d.Line)+4, CHARINDEX(' positions', d.Line)-CHARINDEX('has ', d.Line)-4) AS INT) AS number_of_positions
		,CAST(SUBSTRING(d.Line, CHARINDEX('position ', d.Line)+9, CHARINDEX('.', d.Line)-CHARINDEX('position ', d.Line)-9) AS INT) AS current_position
	FROM
		#Day_15 AS d
	WHERE 1=1

---------------------------------------------
-- Part 1
---------------------------------------------
SELECT
	MIN(a.Num) AS Answer
FROM
	(
	SELECT
		n.Num
		,d.Line
		,d.disc
		,d.number_of_positions
		,d.current_position
		,CASE
			WHEN SUM(IIF(((d.disc+n.Num)-(d.number_of_positions-d.current_position))%d.number_of_positions=0, 1, 0)) OVER(PARTITION BY n.Num)=MAX(d.disc) OVER() THEN 1
			ELSE 0
		END AS all_position_0
	FROM
		#Discs AS d
		CROSS JOIN #Numbers AS n
	WHERE 1=1
	) AS a
WHERE 1=1
	AND a.all_position_0 = 1
	
---------------------------------------------
-- Part 2
---------------------------------------------
INSERT INTO #Discs
		(
		Line
		,disc
		,number_of_positions
		,current_position
		)
	SELECT
		'Part 2'
		,MAX(d.disc)+1 AS disc
		,11
		,0
	FROM
		#Discs AS d
	WHERE 1=1

SELECT
	MIN(a.Num) AS Answer
FROM
	(
	SELECT
		n.Num
		,d.Line
		,d.disc
		,d.number_of_positions
		,d.current_position
		,CASE
			WHEN SUM(IIF(((d.disc+n.Num)-(d.number_of_positions-d.current_position))%d.number_of_positions=0, 1, 0)) OVER(PARTITION BY n.Num)=MAX(d.disc) OVER() THEN 1
			ELSE 0
		END AS all_position_0
	FROM
		#Discs AS d
		CROSS JOIN #Numbers AS n
	WHERE 1=1
	) AS a
WHERE 1=1
	AND a.all_position_0 = 1
