---------------------------------------------
-- Author:			Elaine Lin
-- Created Date:	2021-03-14
-- References Used:
---------------------------------------------

DROP TABLE IF EXISTS #Day_21
CREATE TABLE #Day_21
	(
	String NVARCHAR(100)
	)

BULK INSERT #Day_21
FROM '.....\advent-of-code\2015\inputs\Day_21.txt'
WITH
	(
    FIRSTROW = 1,
    FIELDTERMINATOR = ';',
    ROWTERMINATOR = '\n'
	);

--SELECT * FROM #Day_21 AS d21

DECLARE @Player_HP INT = 100
DECLARE @Boss_HP INT = (
						SELECT
							CAST(TRIM(ss.[value]) AS INT)
						FROM
							#Day_21 AS d
							CROSS APPLY STRING_SPLIT(d.String, ':') AS ss
						WHERE 1=1
							AND d.String LIKE 'Hit Points%'
							AND ss.[value] NOT LIKE 'Hit Points%'
						)
DECLARE @Boss_Damage INT = (
						SELECT
							CAST(TRIM(ss.[value]) AS INT)
						FROM
							#Day_21 AS d
							CROSS APPLY STRING_SPLIT(d.String, ':') AS ss
						WHERE 1=1
							AND d.String LIKE 'Damage%'
							AND ss.[value] NOT LIKE 'Damage%'
						)
DECLARE @Boss_Armor INT = (
						SELECT
							CAST(TRIM(ss.[value]) AS INT)
						FROM
							#Day_21 AS d
							CROSS APPLY STRING_SPLIT(d.String, ':') AS ss
						WHERE 1=1
							AND d.String LIKE 'Armor%'
							AND ss.[value] NOT LIKE 'Armor%'
						)

--SELECT @Boss_HP AS Boss_HP, @Boss_Damage AS Boss_Damage, @Boss_Armor AS Boss_Armor

DROP TABLE IF EXISTS #Weapons
CREATE TABLE #Weapons
	(
	Item NVARCHAR(100)
	,Cost INT
	,Damage INT
	,Armor INT
	)

INSERT INTO #Weapons
		(
		Item
		,Cost
		,Damage
		,Armor
		)
	VALUES
		('Dagger', 8, 4, 0)
		,('Shortsword', 10, 5, 0)
		,('Warhammer', 25, 6, 0)
		,('Longsword', 40, 7, 0)
		,('Greataxe', 74, 8, 0)

DROP TABLE IF EXISTS #Armor
CREATE TABLE #Armor
	(
	Item NVARCHAR(100)
	,Cost INT
	,Damage INT
	,Armor INT
	)

INSERT INTO #Armor
		(
		Item
		,Cost
		,Damage
		,Armor
		)
	VALUES
		('Leather', 13, 0, 1)
		,('Chainmail', 31, 0, 2)
		,('Splintmail', 53, 0, 3)
		,('Bandedmail', 75, 0, 4)
		,('Platemail', 102, 0, 5)

DROP TABLE IF EXISTS #Rings
CREATE TABLE #Rings
	(
	Item NVARCHAR(100)
	,Cost INT
	,Damage INT
	,Armor INT
	)

INSERT INTO #Rings
		(
		Item
		,Cost
		,Damage
		,Armor
		)
	VALUES
		('Damage +1', 25, 1, 0)
		,('Damage +2', 50, 2, 0)
		,('Damage +3', 100, 3, 0)
		,('Defense +1', 20, 0, 1)
		,('Defense +2', 40, 0, 2)
		,('Defense +3', 80, 0, 3)

;With Armor AS
	(
	SELECT
		a.Item
		,a.Cost
		,a.Damage
		,a.Armor
	FROM
		#Armor AS a
	WHERE 1=1

	UNION ALL

	SELECT
		NULL
		,0
		,0
		,0
	)
,Rings AS
	(
	--All combinations of 2-rings
	SELECT
		r.Item
		,r.Cost
		,r.Damage
		,r.Armor
		,r2.Item AS Item_2
		,r2.Cost AS Cost_2
		,r2.Damage AS Damage_2
		,r2.Armor AS Armor_2
	FROM
		#Rings AS r
		JOIN #Rings AS r2 ON r2.Item<>r.Item
	WHERE 1=1

	UNION ALL

	--1-ring
	SELECT
		r.Item
		,r.Cost
		,r.Damage
		,r.Armor
		,NULL
		,0
		,0
		,0
	FROM
		#Rings AS r
	WHERE 1=1

	UNION ALL

	--0-ring
	SELECT
		NULL
		,0
		,0
		,0
		,NULL
		,0
		,0
		,0
	)

---------------------------------------------
-- Part 1, Part 2
---------------------------------------------
SELECT
	'Part 1' AS Part
	,MIN(a.Gold) AS Answer
FROM
	(
	SELECT
		(w.Cost + a.Cost + r.Cost + r.Cost_2) AS Gold
		,(w.Damage + a.Damage + r.Damage + r.Damage_2) AS Damage
		,(w.Armor + a.Armor + r.Armor + r.Armor_2) AS Armor
	FROM
		#Weapons AS w
		CROSS JOIN Armor AS a
		CROSS JOIN Rings AS r
	WHERE 1=1
	) AS a
WHERE 1=1
	--Player_Turns_To_Win <= Boss_Turns_To_Win
	AND CEILING(@Boss_HP/IIF(a.Damage-@Boss_Armor>0, a.Damage-@Boss_Armor, 1)) <= CEILING(@Player_HP/IIF(@Boss_Damage-a.Armor>0, @Boss_Damage-a.Armor, 1))

UNION ALL

SELECT
	'Part 2' AS Part
	,MAX(a.Gold) AS Answer
FROM
	(
	SELECT
		(w.Cost + a.Cost + r.Cost + r.Cost_2) AS Gold
		,(w.Damage + a.Damage + r.Damage + r.Damage_2) AS Damage
		,(w.Armor + a.Armor + r.Armor + r.Armor_2) AS Armor
	FROM
		#Weapons AS w
		CROSS JOIN Armor AS a
		CROSS JOIN Rings AS r
	WHERE 1=1
	) AS a
WHERE 1=1
	--Player_Turns_To_Win > Boss_Turns_To_Win
	AND CEILING(@Boss_HP/IIF(a.Damage-@Boss_Armor>0, a.Damage-@Boss_Armor, 1)) > CEILING(@Player_HP/IIF(@Boss_Damage-a.Armor>0, @Boss_Damage-a.Armor, 1))
