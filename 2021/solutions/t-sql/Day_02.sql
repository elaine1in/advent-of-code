---------------------------------------------
-- Author:			Elaine Lin
-- Created Date:	2021-12-01
-- References Used:
---------------------------------------------

DROP TABLE IF EXISTS #Day_02
CREATE TABLE #Day_02
	(
	command NVARCHAR(50)
	)

BULK INSERT #Day_02
FROM '.....\advent-of-code\2021\inputs\Day_02.txt'
WITH
	(
    FIRSTROW = 1,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n'
	);

ALTER TABLE #Day_02 ADD ID INT IDENTITY(1,1)

---------------------------------------------
-- Part 1, Part 2
---------------------------------------------
;WITH prep_1 AS
	(
	SELECT
		d.ID
		,d.command
		,SUBSTRING(d.command, 1, CHARINDEX(' ', d.command)-1) AS dir
		,CAST(SUBSTRING(d.command, CHARINDEX(' ', d.command)+1, (LEN(d.command)-CHARINDEX(' ', d.command))) AS BIGINT) AS val
	FROM
		#Day_02 AS d
	WHERE 1=1
	)
,prep_2 AS
	(
	SELECT
		p.ID
		,p.dir
		,p.val
		,SUM(IIF(p.dir='forward', p.val, 0)) OVER(ORDER BY p.ID) AS position
		,SUM(CASE
				WHEN p.dir='down' THEN p.val
				WHEN p.dir='up' THEN -p.val
			END) OVER(ORDER BY p.ID) AS aim
	FROM
		prep_1 AS p
	WHERE 1=1
	)

SELECT TOP 1
	p.ID
	,p.dir
	,p.val
	,p.position
	,p.aim
	,SUM(IIF(p.dir='forward', p.aim*p.val, 0)) OVER(ORDER BY p.ID) AS depth
	,p.position*p.aim AS answer_1
	,p.position*SUM(IIF(p.dir='forward', p.aim*p.val, 0)) OVER(ORDER BY p.ID) AS answer_2
FROM
	prep_2 AS p
WHERE 1=1
ORDER BY
	p.ID DESC
