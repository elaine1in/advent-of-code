---------------------------------------------
-- Author:			Elaine Lin
-- Created Date:	2021-10-18
-- References Used:
---------------------------------------------

CREATE OR ALTER PROCEDURE dbo.solve_2019_day_04
	@puzzle_input_begin INT
	,@puzzle_input_end INT
	,@part INT
AS
BEGIN

	DROP TABLE IF EXISTS #Numbers
	CREATE TABLE #Numbers
		(
		Num INT
		)

	;WITH Numbers AS
		(
		SELECT @puzzle_input_begin AS Num

		UNION ALL

		SELECT
			n.Num+1 AS Num
		FROM
			Numbers AS n
		WHERE 1=1
			AND n.Num < @puzzle_input_end
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

	ALTER TABLE #Numbers ADD num_str AS CAST(Num AS NVARCHAR(6)) PERSISTED;

	;WITH prep AS
		(
		SELECT
			n.num_str
			,s.ix
			,SUBSTRING(n.num_str, s.ix, 1) AS pos
			,LAG(SUBSTRING(n.num_str, s.ix, 1)) OVER(PARTITION BY n.num_str ORDER BY s.ix) AS lag_pos
		FROM
			#Numbers AS n
			CROSS JOIN (
						SELECT
							s.ix
						FROM
							(
							VALUES (1)
									,(2)
									,(3)
									,(4)
									,(5)
									,(6)
							) AS s (ix)
						) AS s
		WHERE 1=1
		)
	,solve AS
		(
		SELECT
			a.num_str
			,a.ix
			,a.pos
			,a.lag_pos
			,a.increase
			,SUM(a.grp) OVER(PARTITION BY a.num_str ORDER BY a.ix) AS grp
		FROM
			(
			SELECT
				p.num_str
				,p.ix
				,p.pos
				,p.lag_pos
				,CASE
					WHEN p.lag_pos<=p.pos THEN 1
					ELSE 0
				END AS increase
				,CASE
					WHEN p.lag_pos<>p.pos THEN 1
					ELSE 0
				END AS grp
			FROM
				prep AS p
			WHERE 1=1
			) AS a
		)

	SELECT
		COUNT(*) AS answer
	FROM
		(
		SELECT
			s.num_str
		FROM
			solve AS s
		WHERE 1=1
		GROUP BY
			s.num_str
		HAVING
			SUM(s.increase)=5

		INTERSECT

		SELECT
			s.num_str
		FROM
			solve AS s
		WHERE 1=1
		GROUP BY
			s.num_str
			,s.grp
		HAVING
			(COUNT(*)>=2 AND @part=1) OR (COUNT(*)=2 AND @part=2)
		) AS a
	WHERE 1=1

END
GO

DECLARE @puzzle_input_begin INT = 372037
DECLARE @puzzle_input_end INT = 905157

---------------------------------------------
-- Part 1
---------------------------------------------
EXECUTE dbo.solve_2019_day_04
	@puzzle_input_begin=@puzzle_input_begin
	,@puzzle_input_end=@puzzle_input_end
	,@part=1	-- int

---------------------------------------------
-- Part 2
---------------------------------------------
EXECUTE dbo.solve_2019_day_04
	@puzzle_input_begin=@puzzle_input_begin
	,@puzzle_input_end=@puzzle_input_end
	,@part=2	-- int
