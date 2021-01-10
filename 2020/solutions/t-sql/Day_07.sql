---------------------------------------------
-- Author:			Elaine Lin
-- Created Date:	2020-12-22
-- References Used:
---------------------------------------------

DROP TABLE IF EXISTS #Day_07
CREATE TABLE #Day_07
	(
	Rules NVARCHAR(1000)
	)

BULK INSERT #Day_07
FROM '.....\advent-of-code\2020\inputs\Day_07.txt'
WITH
	(
    FIRSTROW = 1,
    FIELDTERMINATOR = ';',
    ROWTERMINATOR = '\n'
	);

ALTER TABLE #Day_07 ADD ID INT IDENTITY(1,1) --To preserve input order

---------------------------------------------
-- Test Scenario
---------------------------------------------
--TRUNCATE TABLE #Day_07
--INSERT INTO #Day_07
--		(
--		Rules
--		)
--	VALUES
--		('light red bags contain 1 bright white bag, 2 muted yellow bags.')
--		,('dark orange bags contain 3 bright white bags, 4 muted yellow bags.')
--		,('bright white bags contain 1 shiny gold bag.')
--		,('muted yellow bags contain 2 shiny gold bags, 9 faded blue bags.')
--		,('shiny gold bags contain 1 dark olive bag, 2 vibrant plum bags.')
--		,('dark olive bags contain 3 faded blue bags, 4 dotted black bags.')
--		,('vibrant plum bags contain 5 faded blue bags, 6 dotted black bags.')
--		,('faded blue bags contain no other bags.')
--		,('dotted black bags contain no other bags.')
--		----
--		('shiny gold bags contain 2 dark red bags.')
--		,('dark red bags contain 2 dark orange bags.')
--		,('dark orange bags contain 2 dark yellow bags.')
--		,('dark yellow bags contain 2 dark green bags.')
--		,('dark green bags contain 2 dark blue bags.')
--		,('dark blue bags contain 2 dark violet bags.')
--		,('dark violet bags contain no other bags.')

SELECT * FROM #Day_07 AS d7

DROP TABLE IF EXISTS #Day_07_Parse
CREATE TABLE #Day_07_Parse
	(
	ID INT
	,Rules NVARCHAR(1000)
	,Bag NVARCHAR(100)
	,Bag_Contains NVARCHAR(1000)
	,Contained_Bag NVARCHAR(100)
	,Contained_Bag_Number INT
	,Contained_Bag_Name NVARCHAR(100)
	)

INSERT INTO #Day_07_Parse
		(
		ID
		,Rules
		,Bag
		,Bag_Contains
		,Contained_Bag
		)
	SELECT
		d7.ID
		,d7.Rules
		,LEFT(d7.Rules, CHARINDEX('contain', d7.Rules)-2) AS Bag
		,RIGHT(d7.Rules, LEN(d7.Rules)-CHARINDEX('contain', d7.Rules)-7) AS Bag_Contains
		,REPLACE(TRIM(ss.[value]), '.', '') AS Contained_Bag
	FROM
		(
		SELECT
			d.ID
			,REPLACE(d.Rules, 'bags', 'bag') AS Rules
		FROM
			#Day_07 AS d
		WHERE 1=1
		) AS d7
		CROSS APPLY STRING_SPLIT(RIGHT(d7.Rules, LEN(d7.Rules)-CHARINDEX('contain', d7.Rules)-7), ',') AS ss
	WHERE 1=1

UPDATE
	d7p
SET
	d7p.Contained_Bag_Number = CASE
									WHEN d7p.Contained_Bag<>'no other bag' THEN CAST(LEFT(d7p.Contained_Bag, CHARINDEX(' ', d7p.Contained_Bag)-1) AS INT)
									ELSE NULL
								END
	,d7p.Contained_Bag_Name = CASE
									WHEN d7p.Contained_Bag<>'no other bag' THEN RIGHT(d7p.Contained_Bag, LEN(d7p.Contained_Bag)-CHARINDEX(' ', d7p.Contained_Bag))
									ELSE NULL
								END
FROM
	#Day_07_Parse AS d7p
WHERE 1=1

---------------------------------------------
-- Part 1
---------------------------------------------
DECLARE @bag NVARCHAR(100) = 'shiny gold bag'

;WITH Bags AS
	(
	 SELECT
		d7p.ID
		,d7p.Rules
		,d7p.Bag
		,d7p.Bag_Contains
		,d7p.Contained_Bag
		,d7p.Contained_Bag_Number
		,d7p.Contained_Bag_Name
	FROM
		#Day_07_Parse AS d7p
	WHERE 1=1
		AND d7p.Contained_Bag_Name = @bag

	UNION ALL

	SELECT
		d7p.ID
		,d7p.Rules
		,d7p.Bag
		,d7p.Bag_Contains
		,d7p.Contained_Bag
		,d7p.Contained_Bag_Number
		,d7p.Contained_Bag_Name
	FROM
		#Day_07_Parse AS d7p
		JOIN Bags AS b ON b.Bag=d7p.Contained_Bag_Name
	WHERE 1=1
	)

SELECT
	COUNT(*) AS ct
FROM
	(
	SELECT b.Bag FROM Bags AS b WHERE b.Bag<>@bag
	UNION
	SELECT b.Contained_Bag_Name FROM Bags AS b WHERE b.Contained_Bag_Name<>@bag
	) AS a
WHERE 1=1

GO
---------------------------------------------
-- Part 2
---------------------------------------------
DECLARE @bag NVARCHAR(100) = 'shiny gold bag'

;WITH Bags AS
	(
	 SELECT
		d7p.ID
		,d7p.Rules
		,d7p.Bag
		,d7p.Bag_Contains
		,d7p.Contained_Bag
		,d7p.Contained_Bag_Number
		,d7p.Contained_Bag_Name
	FROM
		#Day_07_Parse AS d7p
	WHERE 1=1
		AND d7p.Bag = @bag --reversed from Part 1

	UNION ALL

	SELECT
		d7p.ID
		,d7p.Rules
		,d7p.Bag
		,d7p.Bag_Contains
		,d7p.Contained_Bag
		,(d7p.Contained_Bag_Number*b.Contained_Bag_Number)
		,d7p.Contained_Bag_Name
	FROM
		#Day_07_Parse AS d7p
		JOIN Bags AS b ON b.Contained_Bag_Name=d7p.Bag --reversed from Part 1
	WHERE 1=1
	)

SELECT
	SUM(b.Contained_Bag_Number) AS ct
FROM
	Bags AS b
WHERE 1=1
