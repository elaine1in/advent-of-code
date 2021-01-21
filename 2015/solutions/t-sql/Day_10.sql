---------------------------------------------
-- Author:			Elaine Lin
-- Created Date:	2021-01-20
-- References Used:
---------------------------------------------

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
		AND n.Num<999999
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

	
DECLARE @aoc_input NVARCHAR(MAX) = '1321131112'

---------------------------------------------
-- Part 1 & Part 2
/*
For whatever reason, after the 43rd iteration, my answer here differs from my python solution...
*/
---------------------------------------------
DECLARE @counter INT = 0

WHILE @counter < 50
	BEGIN
		;WITH Answer AS
			(
			SELECT
				a.aoc_input
				,a.Num
				,a.Num_Part
				,a.Lag_Num_Part
				,a.Change
				,SUM(a.Change) OVER(ORDER BY a.Num) AS grp
			FROM
				(
				SELECT
					@aoc_input AS aoc_input
					,n.Num
					,SUBSTRING(@aoc_input, n.Num, 1) AS Num_Part
					,LAG(SUBSTRING(@aoc_input, n.Num, 1)) OVER(ORDER BY n.Num) AS Lag_Num_Part
					,IIF(SUBSTRING(@aoc_input, n.Num, 1)<>LAG(SUBSTRING(@aoc_input, n.Num, 1)) OVER(ORDER BY n.Num), 1, 0) AS Change
				FROM
					#Numbers AS n
				WHERE 1=1
					AND n.Num <= LEN(@aoc_input)
				) AS a
			WHERE 1=1
			)

		SELECT
			@aoc_input = STRING_AGG(CONCAT(a.ct, a.Num_Part), '') WITHIN GROUP (ORDER BY a.grp)
		FROM
			(
			SELECT
				a.aoc_input
				,a.grp
				,COUNT(*) AS ct
				,MIN(a.Num_Part) AS Num_Part
			FROM
				Answer AS a
			WHERE 1=1
			GROUP BY
				a.aoc_input
				,a.grp
			) AS a
		WHERE 1=1
		
		SET @counter += 1

		--Answer
		IF @counter IN (40, 50)
			BEGIN
				SELECT
					@counter AS [counter]
					,LEN(@aoc_input) AS Answer
				WHERE 1=1
			END
	END
