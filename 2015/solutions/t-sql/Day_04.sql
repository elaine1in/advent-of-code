---------------------------------------------
-- Author:			Elaine Lin
-- Created Date:	2021-01-08
-- References Used:
--	https://stackoverflow.com/questions/3525997/generate-md5-hash-string-with-t-sql
---------------------------------------------

DECLARE @Day04_Input VARCHAR(8) = 'ckczppom'
DECLARE @counter INT = 0
DECLARE @end INT = 4000000

DROP TABLE IF EXISTS #Numbers
CREATE TABLE #Numbers
	(
	Num INT
	)

WHILE @counter < @end
	BEGIN
		INSERT INTO #Numbers
				(
				Num
				)
			VALUES
				(@counter+1)

		SET @counter += 1
	END

---------------------------------------------
-- Part 1
---------------------------------------------
SELECT
	MIN(IIF(LEFT(a.Hex, 5)='00000', a.Num, NULL)) AS Answer
FROM
	(
	SELECT
		n.Num
		,CONCAT(@Day04_Input, n.Num) AS md5
		,CONVERT(VARCHAR(32), HASHBYTES('MD5', CONCAT(@Day04_Input, n.Num)), 2) AS Hex
	FROM
		#Numbers AS n
	WHERE 1=1
	) AS a
WHERE 1=1

---------------------------------------------
-- Part 2
---------------------------------------------
SELECT
	MIN(IIF(LEFT(a.Hex, 6)='000000', a.Num, NULL)) AS Answer
FROM
	(
	SELECT
		n.Num
		,CONCAT(@Day04_Input, n.Num) AS md5
		,CONVERT(VARCHAR(32), HASHBYTES('MD5', CONCAT(@Day04_Input, n.Num)), 2) AS Hex
	FROM
		#Numbers AS n
	WHERE 1=1
	) AS a
WHERE 1=1
