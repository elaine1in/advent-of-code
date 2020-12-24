---------------------------------------------
-- Author:			Elaine Lin
-- Created Date:	2020-12-22
-- References Used:
---------------------------------------------

DROP TABLE IF EXISTS #Day_06
CREATE TABLE #Day_06
	(
	Questions NVARCHAR(100)
	)

BULK INSERT #Day_06
FROM '.....\advent-of-code\2020\inputs\Day_06.txt'
WITH
	(
    FIRSTROW = 1,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n'
	);

ALTER TABLE #Day_06 ADD ID INT IDENTITY(1,1) --To preserve input order

SELECT * FROM #Day_06 AS d6

DROP TABLE IF EXISTS #Letters
CREATE TABLE #Letters
	(
	Letter NVARCHAR(1)
	)

INSERT INTO #Letters
		(
		Letter
		)
	VALUES
		('a')
		,('b')
		,('c')
		,('d')
		,('e')
		,('f')
		,('g')
		,('h')
		,('i')
		,('j')
		,('k')
		,('l')
		,('m')
		,('n')
		,('o')
		,('p')
		,('q')
		,('r')
		,('s')
		,('t')
		,('u')
		,('v')
		,('w')
		,('x')
		,('y')
		,('z')

SELECT * FROM #Letters

DROP TABLE IF EXISTS #Answers
CREATE TABLE #Answers
	(
	ID INT
	,Questions NVARCHAR(100)
	,Letter NVARCHAR(1)
	,grp INT
	,Answered_Yes INT
	)

;WITH Answers AS
	(
	SELECT
		d6.ID
		,d6.Questions
		,l.Letter
		,SUM(IIF(d6.Questions IS NULL, 1, 0)) OVER(ORDER BY d6.ID) AS grp
		,IIF(d6.Questions LIKE CONCAT('%', l.Letter, '%'), 1, 0) AS Answered_Yes
	FROM
		#Day_06 AS d6
		CROSS JOIN #Letters AS l
	WHERE 1=1
	)

INSERT INTO #Answers
		(
		ID
		,Questions
		,Letter
		,grp
		,Answered_Yes
		)
	SELECT
		a.ID
		,a.Questions
		,a.Letter
		,a.grp
		,a.Answered_Yes
	FROM
		Answers AS a
	WHERE 1=1

---------------------------------------------
-- Part 1
---------------------------------------------
SELECT
	COUNT(*) AS ct
FROM
	(
	SELECT
		a.grp
		,a.Letter
		,SUM(a.Answered_Yes) AS Answered_Yes
	FROM
		#Answers AS a
	WHERE 1=1
	GROUP BY
		a.grp
		,a.Letter
	HAVING
		SUM(a.Answered_Yes) > 0
	) AS af
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
		,a.Letter
		,SUM(a.Answered_Yes) AS ct_Answered_Yes --count number of 'Yes'
		,COUNT(DISTINCT a.ID) AS ct_ID --count number of Passsengers
	FROM
		#Answers AS a
	WHERE 1=1
		AND a.Questions IS NOT NULL
	GROUP BY
		a.grp
		,a.Letter
	HAVING
		SUM(a.Answered_Yes) = COUNT(DISTINCT a.ID)
	) AS af
WHERE 1=1
