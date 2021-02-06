---------------------------------------------
-- Author:			Elaine Lin
-- Created Date:	2021-02-05
-- References Used:
---------------------------------------------

DROP TABLE IF EXISTS #Day_15_Stg
CREATE TABLE #Day_15_Stg
	(
	String NVARCHAR(100)
	)

BULK INSERT #Day_15_Stg
FROM '.....\advent-of-code\2015\inputs\Day_15.txt'
WITH
	(
    FIRSTROW = 1,
    FIELDTERMINATOR = ';',
    ROWTERMINATOR = '\n'
	);

SELECT * FROM #Day_15_Stg AS d15

DROP TABLE IF EXISTS #Day_15
CREATE TABLE #Day_15
	(
	Ingredient NVARCHAR(100)
	,capacity INT
	,[durability] INT
	,flavor INT
	,texture INT
	,calories INT
	)

INSERT INTO #Day_15
		(
		Ingredient
		,capacity
		,[durability]
		,flavor
		,texture
		,calories
		)
	SELECT
		p.Ingredient
		,p.capacity
		,p.[durability]
		,p.flavor
		,p.texture
		,p.calories
	FROM
		(
		SELECT
			s.Ingredient
			,LEFT(TRIM(ss.[value]), CHARINDEX(' ', TRIM(ss.[value]))-1) AS Property
			,RIGHT(TRIM(ss.[value]), CHARINDEX(' ', REVERSE(TRIM(ss.[value])))-1) AS [Value]
		FROM
			(
			SELECT
				LEFT(d15.String, CHARINDEX(': ', d15.String)-1) AS Ingredient
				,RIGHT(d15.String, CHARINDEX(' :', REVERSE(d15.String))-1) AS PV
			FROM
				#Day_15_Stg AS d15
			WHERE 1=1
			) AS s
			CROSS APPLY STRING_SPLIT(s.PV, ',') AS ss
		WHERE 1=1
		) AS v
		PIVOT(MAX([Value]) FOR Property IN ([capacity], [durability], [flavor], [texture], [calories])) AS p
	WHERE 1=1

SELECT * FROM #Day_15 AS d15

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
		AND n.Num<100
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
	OPTION (MAXRECURSION 100)

SELECT * FROM #Numbers AS n

DROP TABLE IF EXISTS #Valid_Combinations
CREATE TABLE #Valid_Combinations
	(
	Ingredient_1 NVARCHAR(100)
	,Num_1 INT
	,Ingredient_2 NVARCHAR(100)
	,Num_2 INT
	,Ingredient_3 NVARCHAR(100)
	,Num_3 INT
	,Ingredient_4 NVARCHAR(100)
	,Num_4 INT
	)

;WITH Combinations AS
	(
	SELECT
		i.Ingredient
		,n.Num
	FROM
		(
		SELECT
			d15.Ingredient
		FROM
			#Day_15 AS d15
		WHERE 1=1
		) AS i
		CROSS JOIN #Numbers AS n
	WHERE 1=1
	)

INSERT INTO #Valid_Combinations
		(
		Ingredient_1
		,Num_1
		,Ingredient_2
		,Num_2
		,Ingredient_3
		,Num_3
		,Ingredient_4
		,Num_4
		)
	SELECT
		c1.Ingredient AS Ingredient_1
		,c1.Num AS Num_1
		,c2.Ingredient AS Ingredient_2
		,c2.Num AS Num_2
		,c3.Ingredient AS Ingredient_3
		,c3.Num AS Num_3
		,c4.Ingredient AS Ingredient_4
		,c4.Num AS Num_4
	FROM
		Combinations AS c1
		JOIN Combinations AS c2 ON c2.Ingredient<>c1.Ingredient
		JOIN Combinations AS c3 ON c3.Ingredient<>c2.Ingredient AND c3.Ingredient<>c1.Ingredient
		JOIN Combinations AS c4 ON c4.Ingredient<>c3.Ingredient AND c4.Ingredient<>c2.Ingredient AND c4.Ingredient<>c1.Ingredient
	WHERE 1=1
		AND (c1.Num+c2.Num+c3.Num+c4.Num)=100
		
---------------------------------------------
-- Part 1, Part 2
---------------------------------------------
SELECT
	MAX(a.Score) AS Answer_1
	,MAX(IIF(a.calories=500, a.Score, NULL)) AS Answer_2
FROM
	(
	SELECT
		((vc.Num_1*d15_1.capacity) + (vc.Num_2*d15_2.capacity) + (vc.Num_3*d15_3.capacity) + (vc.Num_4*d15_4.capacity)) AS capacity
		,((vc.Num_1*d15_1.[durability]) + (vc.Num_2*d15_2.[durability]) + (vc.Num_3*d15_3.[durability]) + (vc.Num_4*d15_4.[durability])) AS [durability]
		,((vc.Num_1*d15_1.flavor) + (vc.Num_2*d15_2.flavor) + (vc.Num_3*d15_3.flavor) + (vc.Num_4*d15_4.flavor)) AS flavor
		,((vc.Num_1*d15_1.texture) + (vc.Num_2*d15_2.texture) + (vc.Num_3*d15_3.texture) + (vc.Num_4*d15_4.texture)) AS texture
		,((vc.Num_1*d15_1.calories) + (vc.Num_2*d15_2.calories) + (vc.Num_3*d15_3.calories) + (vc.Num_4*d15_4.calories)) AS calories
		,(
			((vc.Num_1*d15_1.capacity) + (vc.Num_2*d15_2.capacity) + (vc.Num_3*d15_3.capacity) + (vc.Num_4*d15_4.capacity))
			*
			((vc.Num_1*d15_1.[durability]) + (vc.Num_2*d15_2.[durability]) + (vc.Num_3*d15_3.[durability]) + (vc.Num_4*d15_4.[durability]))
			*
			((vc.Num_1*d15_1.flavor) + (vc.Num_2*d15_2.flavor) + (vc.Num_3*d15_3.flavor) + (vc.Num_4*d15_4.flavor))
			*
			((vc.Num_1*d15_1.texture) + (vc.Num_2*d15_2.texture) + (vc.Num_3*d15_3.texture) + (vc.Num_4*d15_4.texture))
			) AS Score
	FROM
		#Valid_Combinations AS vc
		JOIN #Day_15 AS d15_1 ON d15_1.Ingredient=vc.Ingredient_1
		JOIN #Day_15 AS d15_2 ON d15_2.Ingredient=vc.Ingredient_2
		JOIN #Day_15 AS d15_3 ON d15_3.Ingredient=vc.Ingredient_3
		JOIN #Day_15 AS d15_4 ON d15_4.Ingredient=vc.Ingredient_4
	WHERE 1=1
	) AS a
WHERE 1=1
	AND a.capacity > 0
	AND a.[durability] > 0
	AND a.flavor > 0
	AND a.texture > 0
