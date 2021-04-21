---------------------------------------------
-- Author:			Elaine Lin
-- Created Date:	2021-04-18
-- References Used:
--		https://stackoverflow.com/questions/30665719/how-to-multiply-all-values-within-a-column-with-sql-like-sum
---------------------------------------------

DROP TABLE IF EXISTS #Day_10
CREATE TABLE #Day_10
	(
	Instructions NVARCHAR(255)
	)

BULK INSERT #Day_10
FROM '.....\advent-of-code\2016\inputs\Day_10.txt'
WITH
	(
    FIRSTROW = 1,
    FIELDTERMINATOR = ';',
    ROWTERMINATOR = '\n'
	);

DROP TABLE IF EXISTS #Bots
CREATE TABLE #Bots
	(
	Bot INT
	,Value_Num INT
	)

DROP TABLE IF EXISTS #Outputs
CREATE TABLE #Outputs
	(
	[Output] INT
	,Value_Num INT
	)

DROP TABLE IF EXISTS #Stage
CREATE TABLE #Stage
	(
	Instructions NVARCHAR(255)
	,Part_1 NVARCHAR(100)
	,Part_2 NVARCHAR(100)
	,Part_3 NVARCHAR(100)
	)

INSERT INTO #Stage
		(
		Instructions
		,Part_1
		,Part_2
		,Part_3
		)
	SELECT
		d.Instructions
		,CASE
			WHEN d.Instructions LIKE 'value %' THEN SUBSTRING(d.Instructions, CHARINDEX('value ', d.Instructions)+6, CHARINDEX(' goes', d.Instructions)-CHARINDEX('value ', d.Instructions)-6)
			WHEN d.Instructions LIKE 'bot %' THEN SUBSTRING(d.Instructions, CHARINDEX('bot ', d.Instructions)+4, CHARINDEX(' gives', d.Instructions)-CHARINDEX('bot ', d.Instructions)-4)
		END AS Part_1
		,CASE
			WHEN d.Instructions LIKE 'value %' THEN RIGHT(d.Instructions, CHARINDEX(' ', REVERSE(d.Instructions))-1)
			WHEN d.Instructions LIKE 'bot %' THEN SUBSTRING(d.Instructions, CHARINDEX('low to ', d.Instructions)+7, CHARINDEX(' and', d.Instructions)-CHARINDEX('low to ', d.Instructions)-7)
		END AS Part_2
		,CASE
			WHEN d.Instructions LIKE 'bot %' THEN SUBSTRING(d.Instructions, CHARINDEX('high to ', d.Instructions)+8, LEN(d.Instructions)-CHARINDEX('high to ', d.Instructions)-7)
		END AS Part_3
	FROM
		#Day_10 AS d
	WHERE 1=1

INSERT INTO #Bots
		(
		Bot
		,Value_Num
		)
	SELECT
		s.Part_2 AS Bot
		,s.Part_1 AS Value_Num
	FROM
		#Stage AS s
	WHERE 1=1
		AND s.Instructions LIKE 'value %'

DECLARE @Value_1 INT = 61
DECLARE @Value_2 INT = 17

WHILE NOT EXISTS(SELECT 1 FROM #Bots AS b1 JOIN #Bots AS b2 ON b2.Bot=b1.Bot WHERE b1.Value_Num=@Value_1 AND b2.Value_Num=@Value_2)
	OR
	(SELECT COUNT(*) FROM #Outputs AS o WHERE 1=1 AND o.[Output] IN (0, 1, 2))<>3
	BEGIN
		INSERT INTO #Bots
				(
				Bot
				,Value_Num
				)
			SELECT
				ss.[value] AS Bot
				,b.Low_Value AS Value_Num
			FROM
				#Stage AS s
				CROSS APPLY STRING_SPLIT(s.Part_2, ' ') AS ss
				JOIN(
					SELECT
						b.Bot
						,MIN(b.Value_Num) AS Low_Value
						,MAX(b.Value_Num) AS High_Value
					FROM
						#Bots AS b
					WHERE 1=1
					GROUP BY
						b.Bot
					) AS b ON b.Bot=s.Part_1
			WHERE 1=1
				AND s.Instructions LIKE 'bot %'
				AND s.Part_2 LIKE 'bot %'
				AND ss.[value] <> 'bot'
				--Checking that only Bots with 2-microchips are considered
				AND EXISTS(
							SELECT
								1
							FROM
								#Bots AS b2
							WHERE 1=1
								AND b2.Bot = s.Part_1
							GROUP BY
								b2.Bot
							HAVING
								COUNT(*) > 1
							)
				--Checking that value has not already been inserted (to avoid duplicates)
				AND NOT EXISTS(
								SELECT
									1
								FROM
									#Bots AS b3
								WHERE 1=1
									AND b3.Bot = ss.[value]
									AND b3.Value_Num = b.Low_Value
								)

			UNION ALL

			SELECT
				ss.[value] AS Bot
				,b.High_Value AS Value_Num
			FROM
				#Stage AS s
				CROSS APPLY STRING_SPLIT(s.Part_3, ' ') AS ss
				JOIN(
					SELECT
						b.Bot
						,MIN(b.Value_Num) AS Low_Value
						,MAX(b.Value_Num) AS High_Value
					FROM
						#Bots AS b
					WHERE 1=1
					GROUP BY
						b.Bot
					) AS b ON b.Bot=s.Part_1
			WHERE 1=1
				AND s.Instructions LIKE 'bot %'
				AND s.Part_3 LIKE 'bot %'
				AND ss.[value] <> 'bot'
				--Checking that only Bots with 2-microchips are considered
				AND EXISTS(
							SELECT
								1
							FROM
								#Bots AS b2
							WHERE 1=1
								AND b2.Bot = s.Part_1
							GROUP BY
								b2.Bot
							HAVING
								COUNT(*) > 1
							)
				--Checking that value has not already been inserted (to avoid duplicates)
				AND NOT EXISTS(
								SELECT
									1
								FROM
									#Bots AS b3
								WHERE 1=1
									AND b3.Bot = ss.[value]
									AND b3.Value_Num = b.High_Value
								)

		INSERT INTO #Outputs
				(
				[Output]
				,Value_Num
				)
			SELECT
				ss.[value] AS [Output]
				,b.Low_Value AS Value_Num
			FROM
				#Stage AS s
				CROSS APPLY STRING_SPLIT(s.Part_2, ' ') AS ss
				JOIN(
					SELECT
						b.Bot
						,MIN(b.Value_Num) AS Low_Value
						,MAX(b.Value_Num) AS High_Value
					FROM
						#Bots AS b
					WHERE 1=1
					GROUP BY
						b.Bot
					) AS b ON b.Bot=s.Part_1
			WHERE 1=1
				AND s.Instructions LIKE 'bot %'
				AND s.Part_2 LIKE 'output %'
				AND ss.[value] <> 'output'
				--Checking that only Bots with 2-microchips are considered
				AND EXISTS(
							SELECT
								1
							FROM
								#Bots AS b2
							WHERE 1=1
								AND b2.Bot = s.Part_1
							GROUP BY
								b2.Bot
							HAVING
								COUNT(*) > 1
							)
				--Checking that value has not already been inserted (to avoid duplicates)
				AND NOT EXISTS(
								SELECT
									1
								FROM
									#Outputs AS b3
								WHERE 1=1
									AND b3.[Output] = ss.[value]
									AND b3.Value_Num = b.Low_Value
								)

			UNION ALL

			SELECT
				ss.[value] AS [Output]
				,b.High_Value AS Value_Num
			FROM
				#Stage AS s
				CROSS APPLY STRING_SPLIT(s.Part_3, ' ') AS ss
				JOIN(
					SELECT
						b.Bot
						,MIN(b.Value_Num) AS Low_Value
						,MAX(b.Value_Num) AS High_Value
					FROM
						#Bots AS b
					WHERE 1=1
					GROUP BY
						b.Bot
					) AS b ON b.Bot=s.Part_1
			WHERE 1=1
				AND s.Instructions LIKE 'bot %'
				AND s.Part_3 LIKE 'output %'
				AND ss.[value] <> 'output'
				--Checking that only Bots with 2-microchips are considered
				AND EXISTS(
							SELECT
								1
							FROM
								#Bots AS b2
							WHERE 1=1
								AND b2.Bot = s.Part_1
							GROUP BY
								b2.Bot
							HAVING
								COUNT(*) > 1
							)
				--Checking that value has not already been inserted (to avoid duplicates)
				AND NOT EXISTS(
								SELECT
									1
								FROM
									#Outputs AS b3
								WHERE 1=1
									AND b3.[Output] = ss.[value]
									AND b3.Value_Num = b.High_Value
								)
	END

---------------------------------------------
-- Part 1
---------------------------------------------
SELECT
	b1.Bot AS Answer
FROM
	#Bots AS b1
	JOIN #Bots AS b2 ON b2.Bot=b1.Bot
WHERE 1=1
	AND b1.Value_Num = @Value_1
	AND b2.Value_Num = @Value_2
	
---------------------------------------------
-- Part 1
---------------------------------------------
SELECT
	ROUND(EXP(SUM(LOG(o.Value_Num))), 1) AS Answer
FROM
	#Outputs AS o
WHERE 1=1
	AND o.[Output] IN (0, 1, 2)
