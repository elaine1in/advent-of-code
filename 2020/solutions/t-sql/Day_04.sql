---------------------------------------------
-- Author:			Elaine Lin
-- Created Date:	2020-12-22
-- References Used:
---------------------------------------------

DROP TABLE IF EXISTS #Attributes
CREATE TABLE #Attributes
	(
	Field NVARCHAR(3)
	)

INSERT INTO #Attributes
		(
		Field
		)
	VALUES
		('byr')
		,('iyr')
		,('eyr')
		,('hgt')
		,('hcl')
		,('ecl')
		,('pid')

SELECT * FROM #Attributes

DROP TABLE IF EXISTS #Day_04
CREATE TABLE #Day_04
	(
	Passport_Info NVARCHAR(MAX)
	)

BULK INSERT #Day_04
FROM '.....\advent-of-code\2020\inputs\Day_04.txt'
WITH
	(
    FIRSTROW = 1,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n'
	);

ALTER TABLE #Day_04 ADD ID INT IDENTITY(1,1) --To preserve input order

SELECT * FROM #Day_04 AS d4

DECLARE @ct_Total_Attributes INT = (SELECT COUNT(*) FROM #Attributes AS a)

---------------------------------------------
-- Part 1
---------------------------------------------
SELECT
	COUNT(*) AS ct
FROM
	(
	SELECT
		a.grp
		,SUM(a.ct_Fields) AS ct_Fields
	FROM
		(
		SELECT
			d4.ID
			,d4.Passport_Info
			,SUM(IIF(d4.Passport_Info IS NULL, 1, 0)) OVER(ORDER BY d4.ID) AS grp
			,SUM(IIF(d4.Passport_Info LIKE CONCAT('%', a.Field, ':', '%'), 1, 0)) AS ct_Fields
		FROM
			#Day_04 AS d4
			CROSS JOIN #Attributes AS a
		WHERE 1=1
		GROUP BY
			d4.ID
			,d4.Passport_Info
		) AS a
	WHERE 1=1
	GROUP BY
		a.grp
	HAVING
		SUM(a.ct_Fields) = @ct_Total_Attributes
	) AS c
WHERE 1=1

---------------------------------------------
-- Part 2
---------------------------------------------
SELECT
	COUNT(*) AS ct
FROM
	(
	SELECT
		a.grp
		,SUM(a.Is_Valid) AS ct_Is_Valid
	FROM
		(
		SELECT
			d4.*
			,CASE
				WHEN a.Field='byr' AND a.Field<>ss2.[value] THEN IIF(ss2.[value] BETWEEN 1920 AND 2002, 1, 0)
				WHEN a.Field='iyr' AND a.Field<>ss2.[value] THEN IIF(ss2.[value] BETWEEN 2010 AND 2020, 1, 0)
				WHEN a.Field='eyr' AND a.Field<>ss2.[value] THEN IIF(ss2.[value] BETWEEN 2020 AND 2030, 1, 0)
				WHEN a.Field='hgt' AND a.Field<>ss2.[value] THEN CASE
																	WHEN ss2.[value] LIKE '%cm' THEN IIF(TRY_CAST(LEFT(ss2.[value], CHARINDEX('cm', ss2.[value])-1) AS INT) BETWEEN 150 AND 193, 1, 0)
																	WHEN ss2.[value] LIKE '%in' THEN IIF(TRY_CAST(LEFT(ss2.[value], CHARINDEX('in', ss2.[value])-1) AS INT) BETWEEN 59 AND 76, 1, 0)
																END
				WHEN a.Field='hcl' AND a.Field<>ss2.[value] THEN IIF(ss2.[value] LIKE '#[0-9a-f][0-9a-f][0-9a-f][0-9a-f][0-9a-f][0-9a-f]', 1, 0)
				WHEN a.Field='ecl' AND a.Field<>ss2.[value] THEN IIF(ss2.[value] IN ('amb', 'blu', 'brn', 'gry', 'grn', 'hzl', 'oth'), 1, 0)
				WHEN a.Field='pid' AND a.Field<>ss2.[value] THEN IIF(ss2.[value] LIKE '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]', 1, 0)
				ELSE 0
			END AS Is_Valid
			,SUM(IIF(d4.Passport_Info IS NULL, 1, 0)) OVER(ORDER BY d4.ID) AS grp
		FROM
			#Day_04 AS d4
			OUTER APPLY STRING_SPLIT(d4.Passport_Info, ' ') AS ss1
			OUTER APPLY STRING_SPLIT(ss1.[value], ':') AS ss2
			LEFT JOIN #Attributes AS a ON ss1.[value] LIKE CONCAT(a.Field, '%')
		WHERE 1=1
		) AS a
	WHERE 1=1
	GROUP BY
		a.grp
	HAVING
		SUM(a.Is_Valid) = @ct_Total_Attributes
	) AS c
WHERE 1=1
