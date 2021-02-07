---------------------------------------------
-- Author:			Elaine Lin
-- Created Date:	2021-02-06
-- References Used:
---------------------------------------------

DROP TABLE IF EXISTS #Day_09
CREATE TABLE #Day_09
	(
	String NVARCHAR(100)
	)

BULK INSERT #Day_09
FROM '.....\advent-of-code\2015\inputs\Day_09.txt'
WITH
	(
    FIRSTROW = 1,
    FIELDTERMINATOR = ';',
    ROWTERMINATOR = '\n'
	);

--SELECT * FROM #Day_09 AS d09

;WITH Places AS
	(
	SELECT
		pd.String
		,LEFT(pd.Places, CHARINDEX(' to ', pd.Places)-1) AS p1
		,SUBSTRING(pd.Places, CHARINDEX(' to ', pd.Places)+4, LEN(pd.Places)-CHARINDEX(' to ', pd.Places)-3) AS p2
		,CAST(pd.Distance AS INT) AS Distance
	FROM
		(
		SELECT
			d09.String
			,LEFT(d09.String, CHARINDEX(' = ', d09.String)-1) AS Places
			,RIGHT(d09.String, CHARINDEX(' = ', REVERSE(d09.String))-1) AS Distance
		FROM
			#Day_09 AS d09
		WHERE 1=1
		) AS pd
	WHERE 1=1
	)
,All_Places AS
	(
	SELECT
		p.p1
		,p.p2
		,p.Distance
	FROM
		Places AS p
	WHERE 1=1

	UNION ALL

	SELECT
		p.p2
		,p.p1
		,p.Distance
	FROM
		Places AS p
	WHERE 1=1
	)
,Distinct_Places AS
	(
	SELECT DISTINCT
		ap.p1
	FROM
		All_Places AS ap
	WHERE 1=1
	)
,Paths AS
	(
	SELECT
		ROW_NUMBER() OVER(ORDER BY (SELECT NULL)) AS rn
		,d1.p1 AS p1
		,d2.p1 AS p2
		,d3.p1 AS p3
		,d4.p1 AS p4
		,d5.p1 AS p5
		,d6.p1 AS p6
		,d7.p1 AS p7
		,d8.p1 AS p8
	FROM
		Distinct_Places AS d1
		JOIN Distinct_Places AS d2 ON d2.p1<>d1.p1
		JOIN Distinct_Places AS d3 ON d3.p1<>d2.p1 AND d3.p1<>d1.p1
		JOIN Distinct_Places AS d4 ON d4.p1<>d3.p1 AND d4.p1<>d2.p1 AND d4.p1<>d1.p1
		JOIN Distinct_Places AS d5 ON d5.p1<>d4.p1 AND d5.p1<>d3.p1 AND d5.p1<>d2.p1 AND d5.p1<>d1.p1
		JOIN Distinct_Places AS d6 ON d6.p1<>d5.p1 AND d6.p1<>d4.p1 AND d6.p1<>d3.p1 AND d6.p1<>d2.p1 AND d6.p1<>d1.p1
		JOIN Distinct_Places AS d7 ON d7.p1<>d6.p1 AND d7.p1<>d5.p1 AND d7.p1<>d4.p1 AND d7.p1<>d3.p1 AND d7.p1<>d2.p1 AND d7.p1<>d1.p1
		JOIN Distinct_Places AS d8 ON d8.p1<>d7.p1 AND d8.p1<>d6.p1 AND d8.p1<>d5.p1 AND d8.p1<>d4.p1 AND d8.p1<>d3.p1 AND d8.p1<>d2.p1 AND d8.p1<>d1.p1
	WHERE 1=1
	)

---------------------------------------------
-- Part 1, Part 2
---------------------------------------------
--Solution A
SELECT
	'A' AS Solution
	,MIN(p12.Distance + p23.Distance + p34.Distance + p45.Distance + p56.Distance + p67.Distance + p78.Distance) AS Answer_1
	,MAX(p12.Distance + p23.Distance + p34.Distance + p45.Distance + p56.Distance + p67.Distance + p78.Distance) AS Answer_2
FROM
	Paths AS p
	JOIN All_Places AS p12 ON p12.p1=p.p1 AND p12.p2=p.p2
	JOIN All_Places AS p23 ON p23.p1=p.p2 AND p23.p2=p.p3
	JOIN All_Places AS p34 ON p34.p1=p.p3 AND p34.p2=p.p4
	JOIN All_Places AS p45 ON p45.p1=p.p4 AND p45.p2=p.p5
	JOIN All_Places AS p56 ON p56.p1=p.p5 AND p56.p2=p.p6
	JOIN All_Places AS p67 ON p67.p1=p.p6 AND p67.p2=p.p7
	JOIN All_Places AS p78 ON p78.p1=p.p7 AND p78.p2=p.p8
WHERE 1=1

UNION ALL

--Solution B
SELECT
	'B' AS Solution
	,MIN(a.Distance) AS Answer_1
	,MAX(a.Distance) AS Answer_2
FROM
	(
	SELECT
		ps.rn
		,SUM(ap.Distance) AS Distance
	FROM
		(
		SELECT
			up.rn
			,up.Place
			,up.[Stop]
			,LEAD(up.Place, 1) OVER(PARTITION BY up.rn ORDER BY up.[Stop]) AS Lead_Place
		FROM
			Paths AS p
			UNPIVOT(Place FOR [Stop] IN ([p1], [p2], [p3], [p4], [p5], [p6], [p7], [p8])) AS up
		WHERE 1=1
		) AS ps
		JOIN All_Places AS ap ON ap.p1=ps.Place AND ap.p2=ps.Lead_Place
	WHERE 1=1
	GROUP BY
		ps.rn
	) AS a
WHERE 1=1
