---------------------------------------------
-- Author:			Elaine Lin
-- Created Date:	2021-04-06
-- References Used: (Adapted from Advent of Code 2015 Day 4)
--	https://stackoverflow.com/questions/3525997/generate-md5-hash-string-with-t-sql
---------------------------------------------

DECLARE @end INT = 28000000

DROP TABLE IF EXISTS #Numbers
CREATE TABLE #Numbers
	(
	Num INT
	)

;WITH Numbers AS
	(
	SELECT
		1 AS Num

	UNION ALL

	SELECT
		(n.Num+1) AS Num
	FROM
		Numbers AS n
	WHERE 1=1
		AND n.Num+1 <= @end
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

DECLARE @Day05_Input VARCHAR(8) = 'ojvtpuvg'

---------------------------------------------
-- Part 1
---------------------------------------------
SELECT
	STRING_AGG(a2.code, '') WITHIN GROUP (ORDER BY a2.rn) AS Answer
FROM
	(
	SELECT
		ROW_NUMBER() OVER(ORDER BY a.Num) AS rn
		,a.Num
		,a.Hex
		,SUBSTRING(a.Hex, 6, 1) AS code
	FROM
		(
		SELECT
			n.Num
			,CONCAT(@Day05_Input, n.Num) AS md5
			,CONVERT(VARCHAR(32), HASHBYTES('MD5', CONCAT(@Day05_Input, n.Num)), 2) AS Hex
		FROM
			#Numbers AS n
		WHERE 1=1
		) AS a
	WHERE 1=1
		AND LEFT(a.Hex, 5) = '00000'
	) AS a2
WHERE 1=1
	AND a2.rn <= 8

---------------------------------------------
-- Part 2
---------------------------------------------
SELECT
	STRING_AGG(a2.Code, '') WITHIN GROUP (ORDER BY a2.ix) AS Answer
FROM
	(
	SELECT
		ROW_NUMBER() OVER(PARTITION BY TRY_CAST(SUBSTRING(a.Hex, 6, 1) AS INT) ORDER BY a.Num) AS rn_ix
		,a.Num
		,a.Hex
		,TRY_CAST(SUBSTRING(a.Hex, 6, 1) AS INT) AS ix
		,SUBSTRING(a.Hex, 7, 1) AS code
	FROM
		(
		SELECT
			n.Num
			,CONCAT(@Day05_Input, n.Num) AS md5
			,CONVERT(VARCHAR(32), HASHBYTES('MD5', CONCAT(@Day05_Input, n.Num)), 2) AS Hex
		FROM
			#Numbers AS n
		WHERE 1=1
		) AS a
	WHERE 1=1
		AND LEFT(a.Hex, 5) = '00000'
	) AS a2
WHERE 1=1
	AND a2.rn_ix = 1
	AND a2.ix BETWEEN 0 AND 7
