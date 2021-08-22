---------------------------------------------
-- Author:			Elaine Lin
-- Created Date:	2021-08-21
-- References Used:
---------------------------------------------
USE test_db
GO
CREATE OR ALTER PROCEDURE dbo.solve_2016_day_16
	@fill_length INT
AS
BEGIN

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
			AND n.Num <= @fill_length
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

	;WITH fill_initial AS
		(
		SELECT
			i.a
			,REPLACE(REPLACE(REPLACE(REVERSE(i.a), '1', 'x'), '0', '1'), 'x', '0') AS b
			,i.len_a
			,0 AS Lvl
		FROM
			(
			VALUES
				(CAST('10111011111001111' AS NVARCHAR(MAX)), LEN('10111011111001111'))
			) i (a, len_a)
		WHERE 1=1

		UNION ALL

		SELECT
			CONCAT(fi.a, '0', fi.b) AS a
			,REPLACE(REPLACE(REPLACE(REVERSE(CONCAT(fi.a, '0', fi.b)), '1', 'x'), '0', '1'), 'x', '0') AS b
			,CAST(LEN(CONCAT(fi.a, '0', fi.b)) AS INT) AS len_a
			,(fi.Lvl+1) AS Lvl
		FROM
			fill_initial AS fi
		WHERE 1=1
			AND fi.len_a < @fill_length
		)
	,check_sum AS
		(
		SELECT
			CAST(STRING_AGG(IIF(SUBSTRING(nt.check_data, n.Num, 2)=REVERSE(SUBSTRING(nt.check_data, n.Num, 2)), '1', '0'), '') WITHIN GROUP (ORDER BY n.Num) AS NVARCHAR(MAX)) AS check_sum
			,nt.check_data
			,nt.len_check_data
			,0 AS Lvl
		FROM
			(
			SELECT TOP 1
				LEFT(fi.a, @fill_length) AS check_data
				,CAST(LEN(LEFT(fi.a, @fill_length)) AS INT) AS len_check_data
			FROM
				fill_initial AS fi
			WHERE 1=1
			ORDER BY
				fi.Lvl DESC
			) AS nt
			JOIN #Numbers AS n ON n.Num%2=1 AND n.Num<LEN(nt.check_data)
		WHERE 1=1
		GROUP BY
			nt.check_data
			,nt.len_check_data

		UNION ALL

		SELECT
			--using STUFF() here due to limitation of recursive CTE (unable to use GROUP BY)
			CAST(
				STUFF(
						(
						SELECT 
							IIF(SUBSTRING(cs.check_sum, n.Num, 2)=REVERSE(SUBSTRING(cs.check_sum, n.Num, 2)), '1', '0')
						FROM
							#Numbers AS n
						WHERE 1=1
							AND n.Num%2=1
							AND n.Num<LEN(cs.check_sum)
						FOR XML PATH ('')
						), 1, 0, ''
					   ) AS NVARCHAR(MAX)) AS check_sum
			,cs.check_sum AS check_data
			,CAST(LEN(cs.check_sum) AS INT) AS len_check_data
			,(cs.Lvl+1) AS Lvl
		FROM
			check_sum AS cs
		WHERE 1=1
			AND LEN(cs.check_sum)%2 = 0
		)

	SELECT TOP 1
		cs.check_sum AS answer
	FROM
		check_sum AS cs
	WHERE 1=1
	ORDER BY
		cs.Lvl DESC

END
GO

---------------------------------------------
-- Part 1
---------------------------------------------
EXECUTE dbo.solve_2016_day_16
	@fill_length = 272	-- int
	
---------------------------------------------
-- Part 2 (unable to run...not enough memory)
---------------------------------------------
--EXECUTE dbo.solve_2016_day_16
--	@fill_length = 35651584	-- int
	