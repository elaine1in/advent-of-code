---------------------------------------------
-- Author:			Elaine Lin
-- Created Date:	2021-02-06
-- References Used:
---------------------------------------------

DROP TABLE IF EXISTS #Day_16
CREATE TABLE #Day_16
	(
	String NVARCHAR(100)
	)

BULK INSERT #Day_16
FROM '.....\advent-of-code\2015\inputs\Day_16.txt'
WITH
	(
    FIRSTROW = 1,
    FIELDTERMINATOR = ';',
    ROWTERMINATOR = '\n'
	);

SELECT * FROM #Day_16 AS d16

DROP TABLE IF EXISTS #MFCSAM
CREATE TABLE #MFCSAM
	(
	children INT
	,cats INT
	,samoyeds INT
	,pomeranians INT
	,akitas INT
	,vizslas INT
	,goldfish INT
	,trees INT
	,cars INT
	,perfumes INT
	)

INSERT INTO #MFCSAM
		(
		children
		,cats
		,samoyeds
		,pomeranians
		,akitas
		,vizslas
		,goldfish
		,trees
		,cars
		,perfumes
		)
	SELECT
		3 AS children
		,7 AS cats
		,2 AS samoyeds
		,3 AS pomeranians
		,0 AS akitas
		,0 AS vizslas
		,5 AS goldfish
		,3 AS trees
		,2 AS cars
		,1 AS perfumes

SELECT * FROM #MFCSAM AS m

---------------------------------------------
-- Part 1
---------------------------------------------
SELECT
	p.Aunt AS Answer
FROM
	(
	SELECT
		a.Aunt
		,LEFT(TRIM(ss.[value]), CHARINDEX(':', TRIM(ss.[value]))-1) AS Compound
		,SUBSTRING(TRIM(ss.[value]), CHARINDEX(':', TRIM(ss.[value]))+2, LEN(TRIM(ss.[value]))-CHARINDEX(':', TRIM(ss.[value]))+2) AS [value]
	FROM
		(
		SELECT
			LEFT(d16.String, CHARINDEX(':', d16.String)-1) AS Aunt
			,SUBSTRING(d16.String, CHARINDEX(':', d16.String)+2, LEN(d16.String)-CHARINDEX(':', d16.String)+2) AS Compounds
		FROM
			#Day_16 AS d16
		WHERE 1=1
		) AS a
		CROSS APPLY STRING_SPLIT(a.Compounds, ',') AS ss
	WHERE 1=1
	) AS s
	PIVOT(MAX([value]) FOR Compound IN ([children], [cats], [samoyeds], [pomeranians], [akitas], [vizslas], [goldfish], [trees], [cars], [perfumes])) AS p
WHERE 1=1
	AND EXISTS(
				SELECT
					1
				FROM
					#MFCSAM AS m
				WHERE 1=1
					AND (m.children=p.children OR p.children IS NULL)
					AND (m.cats=p.cats OR p.cats IS NULL)
					AND (m.samoyeds=p.samoyeds OR p.samoyeds IS NULL)
					AND (m.pomeranians=p.pomeranians OR p.pomeranians IS NULL)
					AND (m.akitas=p.akitas OR p.akitas IS NULL)
					AND (m.vizslas=p.vizslas OR p.vizslas IS NULL)
					AND (m.goldfish=p.goldfish OR p.goldfish IS NULL)
					AND (m.trees=p.trees OR p.trees IS NULL)
					AND (m.cars=p.cars OR p.cars IS NULL)
					AND (m.perfumes=p.perfumes OR p.perfumes IS NULL)
				)

---------------------------------------------
-- Part 2
---------------------------------------------
SELECT
	p.Aunt AS Answer
FROM
	(
	SELECT
		a.Aunt
		,LEFT(TRIM(ss.[value]), CHARINDEX(':', TRIM(ss.[value]))-1) AS Compound
		,SUBSTRING(TRIM(ss.[value]), CHARINDEX(':', TRIM(ss.[value]))+2, LEN(TRIM(ss.[value]))-CHARINDEX(':', TRIM(ss.[value]))+2) AS [value]
	FROM
		(
		SELECT
			LEFT(d16.String, CHARINDEX(':', d16.String)-1) AS Aunt
			,SUBSTRING(d16.String, CHARINDEX(':', d16.String)+2, LEN(d16.String)-CHARINDEX(':', d16.String)+2) AS Compounds
		FROM
			#Day_16 AS d16
		WHERE 1=1
		) AS a
		CROSS APPLY STRING_SPLIT(a.Compounds, ',') AS ss
	WHERE 1=1
	) AS s
	PIVOT(MAX([value]) FOR Compound IN ([children], [cats], [samoyeds], [pomeranians], [akitas], [vizslas], [goldfish], [trees], [cars], [perfumes])) AS p
WHERE 1=1
	AND EXISTS(
				SELECT
					1
				FROM
					#MFCSAM AS m
				WHERE 1=1
					AND (m.children=p.children OR p.children IS NULL)
					AND (m.cats<p.cats OR p.cats IS NULL)
					AND (m.samoyeds=p.samoyeds OR p.samoyeds IS NULL)
					AND (m.pomeranians>p.pomeranians OR p.pomeranians IS NULL)
					AND (m.akitas=p.akitas OR p.akitas IS NULL)
					AND (m.vizslas=p.vizslas OR p.vizslas IS NULL)
					AND (m.goldfish>p.goldfish OR p.goldfish IS NULL)
					AND (m.trees<p.trees OR p.trees IS NULL)
					AND (m.cars=p.cars OR p.cars IS NULL)
					AND (m.perfumes=p.perfumes OR p.perfumes IS NULL)
				)
