---------------------------------------------
-- Author:			Elaine Lin
-- Created Date:	2021-12-01
-- References Used:
--		https://learnsql.com/blog/moving-average-in-sql/
---------------------------------------------

DROP TABLE IF EXISTS #Day_01
CREATE TABLE #Day_01
	(
	number INT
	)

BULK INSERT #Day_01
FROM '.....\GitHub\advent-of-code\2021\inputs\Day_01.txt'
WITH
	(
    FIRSTROW = 1,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n'
	);

ALTER TABLE #Day_01 ADD ID INT IDENTITY(1,1)

---------------------------------------------
-- Part 1
---------------------------------------------
SELECT
	SUM(a.answer) AS answer_1
FROM
	(
	SELECT
		d.number
		,LEAD(d.number) OVER(ORDER BY d.ID) AS lead_number
		,CASE
			WHEN LEAD(d.number) OVER(ORDER BY d.ID)>d.number THEN 1
			ELSE 0
		END AS answer
	FROM
		#Day_01 AS d
	WHERE 1=1
	) AS a
WHERE 1=1

---------------------------------------------
-- Part 2
---------------------------------------------
;WITH prep AS
	(
	SELECT
		d.ID
		,SUM(d.number) OVER(ORDER BY d.ID ROWS BETWEEN CURRENT ROW AND 2 FOLLOWING) AS sum_sliding_window
		,COUNT(*) OVER(ORDER BY d.ID ROWS BETWEEN CURRENT ROW AND 2 FOLLOWING) AS ct
	FROM
		#Day_01 AS d
	WHERE 1=1
	)

SELECT
	SUM(a.answer) AS answer_2
FROM
	(
	SELECT
		p.sum_sliding_window
		,LEAD(p.sum_sliding_window) OVER (ORDER BY p.ID) AS lead_sum_sliding_window
		,CASE
			WHEN LEAD(p.sum_sliding_window) OVER(ORDER BY p.ID)>p.sum_sliding_window THEN 1
			ELSE 0
		END AS answer
	FROM
		prep AS p
	WHERE 1=1
		AND p.ct=3
	) AS a
WHERE 1=1
