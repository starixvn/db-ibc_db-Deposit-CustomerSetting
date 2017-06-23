/*
	Created By: Helen
	Created Date: 20160420
	Description: Bet Limit for Voidbridge
	
	DB: DBCust/CustDB
	
*/
DELETE FROM GameGroup

INSERT INTO dbo.GameGroup 
		(	GameGroupID, RefSportType, RefBetType, GroupName, IsDeposit)
		
VALUES	(	1          , 212         , 4001      , 'Level 1', 0        )
	,	(	2          , 212         , 4001      , 'Level 2', 0        )
	,	(	3          , 212         , 4001      , 'Level 3', 0        )
	,	(	4          , 212         , 4001      , 'Level 1', 1        )
	,	(	5          , 212         , 4001      , 'Level 2', 1        )
	,	(	6          , 212         , 4001      , 'Level 3', 1        )

DELETE FROM Dep_StakeLevel
DELETE FROM StakeLevelGroupDetail
DELETE FROM Dep_StakeLevelGroupDetail
DELETE FROM StakeLevel WHERE GameTypeID = 4001

-- MYR
CREATE TABLE #Currency (ID INT IDENTITY (1,1), Code VARCHAR(10))

CREATE TABLE #ExchangeIDListPerCurrency (ID INT IDENTITY (1,1),Code VARCHAR(10), ExchangeID INT )

INSERT INTO #Currency (Code)
SELECT 'MYR' AS currency UNION ALL SELECT 'USD' UNION ALL SELECT 'CNY' UNION ALL SELECT 'GBP' 
--UNION ALL SELECT 'VNX' 
UNION ALL SELECT 'VND' 
UNION ALL SELECT 'EUR' UNION ALL SELECT 'THB'
--UNION ALL SELECT  'IDX' 
UNION ALL SELECT 'IDR' UNION ALL SELECT 'INR' UNION ALL SELECT 'KRW' UNION ALL SELECT 'PLN' 
UNION ALL SELECT 'UUS' 
UNION ALL SELECT 'JPY' UNION ALL SELECT 'CAD' UNION ALL SELECT 'AUD' UNION ALL SELECT 'BND' UNION ALL SELECT 'SGD' UNION ALL SELECT 'HKD' UNION ALL SELECT 'TWD' UNION ALL SELECT 'CHF' UNION ALL SELECT 'PHP' UNION ALL SELECT 'ZAR'
UNION ALL SELECT 'MXN' UNION ALL SELECT 'DKK' UNION ALL SELECT 'SEK' UNION ALL SELECT 'NOK' UNION ALL SELECT 'RUB' UNION ALL SELECT 'CZK' UNION ALL SELECT 'RON' UNION ALL SELECT 'NZD' 
UNION ALL SELECT 'MMK' UNION ALL SELECT 'KHR'


INSERT INTO #ExchangeIDListPerCurrency (Code, ExchangeID)
SELECT c.Code,CASE WHEN C.Code = 'UUS' THEN 20 ELSE e.ExchangeID END 
FROM #Currency c
	LEFT JOIN Exchange e WITH (NOLOCK) ON c.Code = e.Code

DECLARE @Start_Index INT = 1
DECLARE @End_Index INT 
DECLARE @StakeLevelID INT = 1

DECLARE @StakeLevelID_Credit INT = 1
DECLARE @ExchangeID  INT



SET IDENTITY_INSERT StakeLevel ON 
 
SET @StakeLevelID_Credit = (SELECT ISNULL(MAX(StakeLevelID),0) FROM StakeLevel WITH (NOLOCK))

SET @Start_Index = @StakeLevelID_Credit + 1

SET @End_Index = (SELECT MAX(ID) FROM #ExchangeIDListPerCurrency) + @StakeLevelID_Credit

SET @StakeLevelID = @Start_Index

-- Credit

WHILE @Start_Index < = @End_Index
BEGIN
	
	SET @ExchangeID = (SELECT ExchangeID FROM #ExchangeIDListPerCurrency WHERE ID = @Start_Index - @StakeLevelID_Credit)
	
	INSERT INTO StakeLevel (StakeLevelID, GameTypeID, GameGroupID, MinLabel, MaxLabel, MinStake, MaxStake, ExchangeId )
	VALUES (	@StakeLevelID     , 4001      , 1         , NULL    , NULL    , NULL    , NULL    , @ExchangeID           )
		,	(	@StakeLevelID + 1 , 4001      , 2         , NULL    , NULL    , NULL    , NULL    , @ExchangeID           )
		,	(	@StakeLevelID + 2 , 4001      , 3         , NULL    , NULL    , NULL    , NULL    , @ExchangeID           )
	
	
	SET @Start_Index	 = @Start_Index + 1
	
	SET @StakeLevelID = @StakeLevelID + 3
		
END

-- Deposit
SET @Start_Index = 1

SET @End_Index = (SELECT MAX(ID) FROM #ExchangeIDListPerCurrency) 

SET @StakeLevelID = 1 

WHILE @Start_Index < = @End_Index
BEGIN
	
	SET @ExchangeID = (SELECT ExchangeID FROM #ExchangeIDListPerCurrency WHERE ID = @Start_Index)
	-- Deposit
	INSERT INTO Dep_StakeLevel (	StakeLevelID, GameTypeID, GameGroupID, MinLabel, MaxLabel, MinStake, MaxStake, ExchangeId )
	VALUES (	@StakeLevelID     , 4001      , 4         , NULL    , NULL    , NULL    , NULL    , @ExchangeID           )
		,	(	@StakeLevelID + 1 , 4001      , 5         , NULL    , NULL    , NULL    , NULL    , @ExchangeID           )
		,	(	@StakeLevelID + 2 , 4001      , 6         , NULL    , NULL    , NULL    , NULL    , @ExchangeID           )
	
	SET @Start_Index	 = @Start_Index + 1
	
	SET @StakeLevelID = @StakeLevelID + 3
		
END


CREATE TABLE #GameType (GameTypeID INT, MYR  VARCHAR(50),  USD VARCHAR(50),  CNY VARCHAR(50),  GBP VARCHAR(50),  VND VARCHAR(50),  EUR VARCHAR(50),  THB VARCHAR(50),  IDR VARCHAR(50),  INR VARCHAR(50),  KRW VARCHAR(50),  PLN VARCHAR(50),  UUS VARCHAR(50),  JPY VARCHAR(50),  CAD VARCHAR(50),  AUD VARCHAR(50),  BND VARCHAR(50),  SGD VARCHAR(50),  HKD VARCHAR(50),  TWD VARCHAR(50),  CHF VARCHAR(50),  PHP VARCHAR(50),  ZAR VARCHAR(50),  MXN VARCHAR(50),  DKK VARCHAR(50),  SEK VARCHAR(50),  NOK VARCHAR(50),  RUB VARCHAR(50),  CZK VARCHAR(50),  RON VARCHAR(50),  NZD VARCHAR(50),  MMK VARCHAR(50),  KHR VARCHAR(50))

INSERT INTO #GameType(GameTypeID, MYR, USD, CNY, GBP, VND, EUR, THB, IDR, INR, KRW, PLN, UUS, JPY, CAD, AUD, BND, SGD, HKD, TWD, CHF, PHP, ZAR, MXN, DKK, SEK, NOK, RUB, CZK, RON, NZD, MMK, KHR)
VALUES (4001, '0.01 - 62.5', '0.01 - 25', '0.02 - 125', '0.05 - 12.5', '0.06 - 500', '0.1 - 25', '0.1 - 750', '0.03 - 250', '5 - 1250', '10 - 25000', '0.25 - 62.5', '0.1 - 25', '10 - 2500', '0.01 - 25', '0.01 - 25', '0.01 - 25', '0.01 - 25', '0.02 - 125', '0.1 - 750', '0.1 - 25', '0.1 - 750', '30 - 250000', '30 - 250000', '0.02 - 125', '0.02 - 125', '0.02 - 125', '3 - 750', '60 - 500000', '0.01 - 62.5', '0.01 - 25', '0.01 - 25', '0.01 - 62.5')
, (4002, '0.25 - 62.5', '0.25 - 25', '0.5 - 125', '1.25 - 12.5', '1.5 - 500', '2.5 - 25', '2.5 - 750', '0.75 - 250', '125 - 1250', '250 - 25000', '6.25 - 62.5', '2.5 - 25', '250 - 2500', '0.25 - 25', '0.25 - 25', '0.25 - 25', '0.25 - 25', '0.5 - 125', '2.5 - 750', '2.5 - 25', '2.5 - 750', '750 - 250000', '750 - 250000', '0.5 - 125', '0.5 - 125', '0.5 - 125', '75 - 750', '1500 - 500000', '0.25 - 62.5', '0.25 - 25', '0.25 - 25', '0.25 - 62.5')
, (4003, '0.2 - 50', '0.2 - 20', '0.4 - 100', '1 - 10', '1.2 - 400', '2 - 20', '2 - 600', '0.6 - 200', '100 - 1000', '200 - 20000', '5 - 50', '2 - 20', '200 - 2000', '0.2 - 20', '0.2 - 20', '0.2 - 20', '0.2 - 20', '0.4 - 100', '2 - 600', '2 - 20', '2 - 600', '600 - 200000', '600 - 200000', '0.4 - 100', '0.4 - 100', '0.4 - 100', '60 - 600', '1200 - 400000', '0.2 - 50', '0.2 - 20', '0.2 - 20', '0.2 - 50')
, (4004, '5 - 500', '1 - 100', '10 - 1000', '1 - 100', '25 - 2500', '1 - 100', '50 - 5000', '20 - 2000', '100 - 10,000', '1500 - 150,000', '5 - 500', '1 - 100', '150 - 15,000', '1 - 100', '1 - 100', '1 - 100', '1 - 100', '10 - 1000', '50 - 5000', '1 - 100', '50 - 5000', '20,000 - 2,000,000', '20,000 - 2,000,000', '10 - 1000', '10 - 1000', '10 - 1000', '100 - 10,000', '25,000 - 2,500,000', '5 - 500', '1 - 100', '1 - 100', '5 - 500')
, (4005, '0.25 - 62.5', '0.25 - 25', '0.5 - 125', '1.25 - 12.5', '1.5 - 500', '2.5 - 25', '2.5 - 750', '0.75 - 250', '125 - 1250', '250 - 25000', '6.25 - 62.5', '2.5 - 25', '250 - 2500', '0.25 - 25', '0.25 - 25', '0.25 - 25', '0.25 - 25', '0.5 - 125', '2.5 - 750', '2.5 - 25', '2.5 - 750', '750 - 250000', '750 - 250000', '0.5 - 125', '0.5 - 125', '0.5 - 125', '75 - 750', '1500 - 500000', '0.25 - 62.5', '0.25 - 25', '0.25 - 25', '0.25 - 62.5')
, (4006, '0.01 - 22.5', '0.01 - 9', '0.02 - 45', '0.05 - 4.5', '0.06 - 180', '0.1 - 9', '0.1 - 270', '0.03 - 90', '5 - 450', '10 - 9000', '0.25 - 22.5', '0.1 - 9', '10 - 900', '0.01 - 9', '0.01 - 9', '0.01 - 9', '0.01 - 9', '0.02 - 45', '0.1 - 270', '0.1 - 9', '0.1 - 270', '30 - 90000', '30 - 90000', '0.02 - 45', '0.02 - 45', '0.02 - 45', '3 - 270', '60 - 180000', '0.01 - 22.5', '0.01 - 9', '0.01 - 9', '0.01 - 22.5')
, (4007, '0.01 - 22.5', '0.01 - 9', '0.02 - 45', '0.05 - 4.5', '0.06 - 180', '0.1 - 9', '0.1 - 270', '0.03 - 90', '5 - 450', '10 - 9000', '0.25 - 22.5', '0.1 - 9', '10 - 900', '0.01 - 9', '0.01 - 9', '0.01 - 9', '0.01 - 9', '0.02 - 45', '0.1 - 270', '0.1 - 9', '0.1 - 270', '30 - 90000', '30 - 90000', '0.02 - 45', '0.02 - 45', '0.02 - 45', '3 - 270', '60 - 180000', '0.01 - 22.5', '0.01 - 9', '0.01 - 9', '0.01 - 22.5')
, (4008, '0.1 - 25', '0.1 - 10', '0.2 - 50', '0.5 - 5', '0.6 - 200', '1 - 10', '1 - 300', '0.3 - 100', '50 - 500', '100 - 10000', '2.5 - 25', '1 - 10', '100 - 1000', '0.1 - 10', '0.1 - 10', '0.1 - 10', '0.1 - 10', '0.2 - 50', '1 - 300', '1 - 10', '1 - 300', '300 - 100000', '300 - 100000', '0.2 - 50', '0.2 - 50', '0.2 - 50', '30 - 300', '600 - 200000', '0.1 - 25', '0.1 - 10', '0.1 - 10', '0.1 - 25')
, (4009, '0.5 - 125', '0.5 - 50', '1 - 250', '2.5 - 25', '3 - 1000', '5 - 50', '5 - 1500', '1.5 - 500', '250 - 2500', '500 - 50000', '12.5 - 125', '5 - 50', '500 - 5000', '0.5 - 50', '0.5 - 50', '0.5 - 50', '0.5 - 50', '1 - 250', '5 - 1500', '5 - 50', '5 - 1500', '1500 - 500000', '1500 - 500000', '1 - 250', '1 - 250', '1 - 250', '150 - 1500', '3000 - 1000000', '0.5 - 125', '0.5 - 50', '0.5 - 50', '0.5 - 125')
, (4010, '0.25 - 62.5', '0.25 - 25', '0.5 - 125', '1.25 - 12.5', '1.5 - 500', '2.5 - 25', '2.5 - 750', '0.75 - 250', '125 - 1250', '250 - 25000', '6.25 - 62.5', '2.5 - 25', '250 - 2500', '0.25 - 25', '0.25 - 25', '0.25 - 25', '0.25 - 25', '0.5 - 125', '2.5 - 750', '2.5 - 25', '2.5 - 750', '750 - 250000', '750 - 250000', '0.5 - 125', '0.5 - 125', '0.5 - 125', '75 - 750', '1500 - 500000', '0.25 - 62.5', '0.25 - 25', '0.25 - 25', '0.25 - 62.5')
, (4011, '0.25 - 62.5', '0.25 - 25', '0.5 - 125', '1.25 - 12.5', '1.5 - 500', '2.5 - 25', '2.5 - 750', '0.75 - 250', '125 - 1250', '250 - 25000', '6.25 - 62.5', '2.5 - 25', '250 - 2500', '0.25 - 25', '0.25 - 25', '0.25 - 25', '0.25 - 25', '0.5 - 125', '2.5 - 750', '2.5 - 25', '2.5 - 750', '750 - 250000', '750 - 250000', '0.5 - 125', '0.5 - 125', '0.5 - 125', '75 - 750', '1500 - 500000', '0.25 - 62.5', '0.25 - 25', '0.25 - 25', '0.25 - 62.5')
, (4012, '0.5 - 125', '0.5 - 50', '1 - 250', '2.5 - 25', '3 - 1000', '5 - 50', '5 - 1500', '1.5 - 500', '250 - 2500', '500 - 50000', '12.5 - 125', '5 - 50', '500 - 5000', '0.5 - 50', '0.5 - 50', '0.5 - 50', '0.5 - 50', '1 - 250', '5 - 1500', '5 - 50', '5 - 1500', '1500 - 500000', '1500 - 500000', '1 - 250', '1 - 250', '1 - 250', '150 - 1500', '3000 - 1000000', '0.5 - 125', '0.5 - 50', '0.5 - 50', '0.5 - 125')
, (4013, '0.09 - 22.5', '0.09 - 9', '0.18 - 45', '0.45 - 4.5', '0.54 - 180', '0.9 - 9', '0.9 - 270', '0.27 - 90', '45 - 450', '90 - 9000', '2.25 - 22.5', '0.9 - 9', '90 - 900', '0.09 - 9', '0.09 - 9', '0.09 - 9', '0.09 - 9', '0.18 - 45', '0.9 - 270', '0.9 - 9', '0.9 - 270', '270 - 90000', '270 - 90000', '0.18 - 45', '0.18 - 45', '0.18 - 45', '27 - 270', '540 - 180000', '0.09 - 22.5', '0.09 - 9', '0.09 - 9', '0.09 - 22.5')
, (4014, '0.25 - 62.5', '0.25 - 25', '0.5 - 125', '1.25 - 12.5', '1.5 - 500', '2.5 - 25', '2.5 - 750', '0.75 - 250', '125 - 1250', '250 - 25000', '6.25 - 62.5', '2.5 - 25', '250 - 2500', '0.25 - 25', '0.25 - 25', '0.25 - 25', '0.25 - 25', '0.5 - 125', '2.5 - 750', '2.5 - 25', '2.5 - 750', '750 - 250000', '750 - 250000', '0.5 - 125', '0.5 - 125', '0.5 - 125', '75 - 750', '1500 - 500000', '0.25 - 62.5', '0.25 - 25', '0.25 - 25', '0.25 - 62.5')
, (4015, '0.1 - 25', '0.1 - 10', '0.2 - 50', '0.5 - 5', '0.6 - 200', '1 - 10', '1 - 300', '0.3 - 100', '50 - 500', '100 - 10000', '2.5 - 25', '1 - 10', '100 - 1000', '0.1 - 10', '0.1 - 10', '0.1 - 10', '0.1 - 10', '0.2 - 50', '1 - 300', '1 - 10', '1 - 300', '300 - 100000', '300 - 100000', '0.2 - 50', '0.2 - 50', '0.2 - 50', '30 - 300', '600 - 200000', '0.1 - 25', '0.1 - 10', '0.1 - 10', '0.1 - 25')
, (4016, '0.01 - 50', '0.01 - 20', '0.02 - 100', '0.05 - 10', '0.06 - 400', '0.1 - 20', '0.1 - 600', '0.03 - 200', '5 - 1000', '10 - 20000', '0.25 - 50', '0.1 - 20', '10 - 2000', '0.01 - 20', '0.01 - 20', '0.01 - 20', '0.01 - 20', '0.02 - 100', '0.1 - 600', '0.1 - 20', '0.1 - 600', '30 - 200000', '30 - 200000', '0.02 - 100', '0.02 - 100', '0.02 - 100', '3 - 600', '60 - 400000', '0.01 - 50', '0.01 - 20', '0.01 - 20', '0.01 - 50')
, (4017, '0.01 - 22.5', '0.01 - 9', '0.02 - 45', '0.05 - 4.5', '0.06 - 180', '0.1 - 9', '0.1 - 270', '0.03 - 90', '5 - 450', '10 - 9000', '0.25 - 22.5', '0.1 - 9', '10 - 900', '0.01 - 9', '0.01 - 9', '0.01 - 9', '0.01 - 9', '0.02 - 45', '0.1 - 270', '0.1 - 9', '0.1 - 270', '30 - 90000', '30 - 90000', '0.02 - 45', '0.02 - 45', '0.02 - 45', '3 - 270', '60 - 180000', '0.01 - 22.5', '0.01 - 9', '0.01 - 9', '0.01 - 22.5')
, (4018, '0.25 - 62.5', '0.25 - 25', '0.5 - 125', '1.25 - 12.5', '1.5 - 500', '2.5 - 25', '2.5 - 750', '0.75 - 250', '125 - 1250', '250 - 25000', '6.25 - 62.5', '2.5 - 25', '250 - 2500', '0.25 - 25', '0.25 - 25', '0.25 - 25', '0.25 - 25', '0.5 - 125', '2.5 - 750', '2.5 - 25', '2.5 - 750', '750 - 250000', '750 - 250000', '0.5 - 125', '0.5 - 125', '0.5 - 125', '75 - 750', '1500 - 500000', '0.25 - 62.5', '0.25 - 25', '0.25 - 25', '0.25 - 62.5')
, (4019, '0.2 - 50', '0.2 - 20', '0.4 - 100', '1 - 10', '1.2 - 400', '2 - 20', '2 - 600', '0.6 - 200', '100 - 1000', '200 - 20000', '5 - 50', '2 - 20', '200 - 2000', '0.2 - 20', '0.2 - 20', '0.2 - 20', '0.2 - 20', '0.4 - 100', '2 - 600', '2 - 20', '2 - 600', '600 - 200000', '600 - 200000', '0.4 - 100', '0.4 - 100', '0.4 - 100', '60 - 600', '1200 - 400000', '0.2 - 50', '0.2 - 20', '0.2 - 20', '0.2 - 50')
, (4020, '0.1 - 25', '0.1 - 10', '0.2 - 50', '0.5 - 5', '0.6 - 200', '1 - 10', '1 - 300', '0.3 - 100', '50 - 500', '100 - 10000', '2.5 - 25', '1 - 10', '100 - 1000', '0.1 - 10', '0.1 - 10', '0.1 - 10', '0.1 - 10', '0.2 - 50', '1 - 300', '1 - 10', '1 - 300', '300 - 100000', '300 - 100000', '0.2 - 50', '0.2 - 50', '0.2 - 50', '30 - 300', '600 - 200000', '0.1 - 25', '0.1 - 10', '0.1 - 10', '0.1 - 25')
, (4021, '0.2 - 50', '0.2 - 20', '0.4 - 100', '1 - 10', '1.2 - 400', '2 - 20', '2 - 600', '0.6 - 200', '100 - 1000', '200 - 20000', '5 - 50', '2 - 20', '200 - 2000', '0.2 - 20', '0.2 - 20', '0.2 - 20', '0.2 - 20', '0.4 - 100', '2 - 600', '2 - 20', '2 - 600', '600 - 200000', '600 - 200000', '0.4 - 100', '0.4 - 100', '0.4 - 100', '60 - 600', '1200 - 400000', '0.2 - 50', '0.2 - 20', '0.2 - 20', '0.2 - 50')
, (4022, '5 - 500', '1 - 100', '10 - 1000', '1 - 100', '25 - 2500', '1 - 100', '50 - 5000', '20 - 2000', '100 - 10,000', '1500 - 150,000', '5 - 500', '1 - 100', '150 - 15,000', '1 - 100', '1 - 100', '1 - 100', '1 - 100', '10 - 1000', '50 - 5000', '1 - 100', '50 - 5000', '20,000 - 2,000,000', '20,000 - 2,000,000', '10 - 1000', '10 - 1000', '10 - 1000', '100 - 10,000', '25,000 - 2,500,000', '5 - 500', '1 - 100', '1 - 100', '5 - 500')
, (4023, '0.25 - 62.5', '0.25 - 25', '0.5 - 125', '1.25 - 12.5', '1.5 - 500', '2.5 - 25', '2.5 - 750', '0.75 - 250', '125 - 1250', '250 - 25000', '6.25 - 62.5', '2.5 - 25', '250 - 2500', '0.25 - 25', '0.25 - 25', '0.25 - 25', '0.25 - 25', '0.5 - 125', '2.5 - 750', '2.5 - 25', '2.5 - 750', '750 - 250000', '750 - 250000', '0.5 - 125', '0.5 - 125', '0.5 - 125', '75 - 750', '1500 - 500000', '0.25 - 62.5', '0.25 - 25', '0.25 - 25', '0.25 - 62.5')
, (4024, '0.1 - 25', '0.1 - 10', '0.2 - 50', '0.5 - 5', '0.6 - 200', '1 - 10', '1 - 300', '0.3 - 100', '50 - 500', '100 - 10000', '2.5 - 25', '1 - 10', '100 - 1000', '0.1 - 10', '0.1 - 10', '0.1 - 10', '0.1 - 10', '0.2 - 50', '1 - 300', '1 - 10', '1 - 300', '300 - 100000', '300 - 100000', '0.2 - 50', '0.2 - 50', '0.2 - 50', '30 - 300', '600 - 200000', '0.1 - 25', '0.1 - 10', '0.1 - 10', '0.1 - 25')
, (4025, '0.2 - 50', '0.2 - 20', '0.4 - 100', '1 - 10', '1.2 - 400', '2 - 20', '2 - 600', '0.6 - 200', '100 - 1000', '200 - 20000', '5 - 50', '2 - 20', '200 - 2000', '0.2 - 20', '0.2 - 20', '0.2 - 20', '0.2 - 20', '0.4 - 100', '2 - 600', '2 - 20', '2 - 600', '600 - 200000', '600 - 200000', '0.4 - 100', '0.4 - 100', '0.4 - 100', '60 - 600', '1200 - 400000', '0.2 - 50', '0.2 - 20', '0.2 - 20', '0.2 - 50')
, (4026, '0.2 - 50', '0.2 - 20', '0.4 - 100', '1 - 10', '1.2 - 400', '2 - 20', '2 - 600', '0.6 - 200', '100 - 1000', '200 - 20000', '5 - 50', '2 - 20', '200 - 2000', '0.2 - 20', '0.2 - 20', '0.2 - 20', '0.2 - 20', '0.4 - 100', '2 - 600', '2 - 20', '2 - 600', '600 - 200000', '600 - 200000', '0.4 - 100', '0.4 - 100', '0.4 - 100', '60 - 600', '1200 - 400000', '0.2 - 50', '0.2 - 20', '0.2 - 20', '0.2 - 50')
, (4027, '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '')
, (4028, '0.1 - 25', '0.1 - 10', '0.2 - 50', '0.5 - 5', '0.6 - 200', '1 - 10', '1 - 300', '0.3 - 100', '50 - 500', '100 - 10000', '2.5 - 25', '1 - 10', '100 - 1000', '0.1 - 10', '0.1 - 10', '0.1 - 10', '0.1 - 10', '0.2 - 50', '1 - 300', '1 - 10', '1 - 300', '300 - 100000', '300 - 100000', '0.2 - 50', '0.2 - 50', '0.2 - 50', '30 - 300', '600 - 200000', '0.1 - 25', '0.1 - 10', '0.1 - 10', '0.1 - 25')
, (4029, '0.5 - 125', '0.5 - 50', '1 - 250', '2.5 - 25', '3 - 1000', '5 - 50', '5 - 1500', '1.5 - 500', '250 - 2500', '500 - 50000', '12.5 - 125', '5 - 50', '500 - 5000', '0.5 - 50', '0.5 - 50', '0.5 - 50', '0.5 - 50', '1 - 250', '5 - 1500', '5 - 50', '5 - 1500', '1500 - 500000', '1500 - 500000', '1 - 250', '1 - 250', '1 - 250', '150 - 1500', '3000 - 1000000', '0.5 - 125', '0.5 - 50', '0.5 - 50', '0.5 - 125')
, (4030, '0.15 - 37.5', '0.15 - 15', '0.3 - 75', '0.75 - 7.5', '0.9 - 300', '1.5 - 15', '1.5 - 450', '0.45 - 150', '75 - 750', '150 - 15000', '3.75 - 37.5', '1.5 - 15', '150 - 1500', '0.15 - 15', '0.15 - 15', '0.15 - 15', '0.15 - 15', '0.3 - 75', '1.5 - 450', '1.5 - 15', '1.5 - 450', '450 - 150000', '450 - 150000', '0.3 - 75', '0.3 - 75', '0.3 - 75', '45 - 450', '900 - 300000', '0.15 - 37.5', '0.15 - 15', '0.15 - 15', '0.15 - 37.5')


CREATE TABLE #GameType_pivot (GameTypeID INT, Code VARCHAR(10),BetLimitValue VARCHAR(400)
, MinLable VARCHAR(100), MaxLable_Level1 VARCHAR(100), MaxLable_Level2 VARCHAR(100),MaxLable_Level3 VARCHAR(100)
, MinStake DECIMAL (19,8),MaxStake_Level1 DECIMAL (19,8), MaxStake_Level2 DECIMAL (19,8) , MaxStake_Level3 DECIMAL (19,8) 
)

INSERT INTO #GameType_pivot (GameTypeID,Code,BetLimitValue)
SELECT   GameTypeID, Code, CASE WHEN BetLimitValue = '' THEN '0 - 0' ELSE BetLimitValue END
FROM #GameType
UNPIVOT
(
       BetLimitValue
       FOR Code IN (MYR, USD, CNY, GBP, VND, EUR, THB, IDR, INR, KRW, PLN, UUS, JPY, CAD, AUD, BND, SGD, HKD, TWD, CHF, PHP, ZAR, MXN, DKK, SEK, NOK, RUB, CZK, RON, NZD, MMK, KHR)
) AS P

UPDATE T
	SET MinLable = replace(LTRIM(RTRIM(SUBSTRING (BetLimitValue,1,CHARINDEX('-',BetLimitValue) - 1))),',','')
	
	, MaxLable_Level1 = (SELECT SUBSTRING(t, 0, CASE CHARINDEX('.00', t) WHEN 0 THEN LEN(t) ELSE CHARINDEX('.00', t) END)
						FROM (SELECT CONVERT(VARCHAR, CAST(REPLACE(LTRIM(RTRIM(SUBSTRING (BetLimitValue,CHARINDEX('-',BetLimitValue) + 1,LEN(BetLimitValue)))),',','') AS MONEY), 1)) s(t))

	, MaxLable_Level2 = (SELECT SUBSTRING(t, 0, CASE CHARINDEX('.00', t) WHEN 0 THEN LEN(t) ELSE CHARINDEX('.00', t) END)
						FROM (SELECT CONVERT(VARCHAR, CAST(CONVERT(MONEY, REPLACE(LTRIM(RTRIM(SUBSTRING (BetLimitValue,CHARINDEX('-',BetLimitValue) + 1,LEN(BetLimitValue)))),',','')) * 5 AS MONEY), 1)) s(t))

	, MaxLable_Level3 = (SELECT SUBSTRING(t, 0, CASE CHARINDEX('.00', t) WHEN 0 THEN LEN(t) ELSE CHARINDEX('.00', t) END)
						FROM (SELECT CONVERT(VARCHAR, CAST(CONVERT(MONEY, REPLACE(LTRIM(RTRIM(SUBSTRING (BetLimitValue,CHARINDEX('-',BetLimitValue) + 1,LEN(BetLimitValue)))),',','')) * 10 AS MONEY), 1)) s(t))
	
	, MinStake=CONVERT(decimal(19,8),REPLACE(LTRIM(RTRIM(SUBSTRING (BetLimitValue,1,CHARINDEX('-',BetLimitValue) - 1))),',',''))
	
	,MaxStake_Level1=	CONVERT(DECIMAL(19,8), REPLACE(LTRIM(RTRIM(SUBSTRING (BetLimitValue,CHARINDEX('-',BetLimitValue) + 1,LEN(BetLimitValue)))),',',''))
	,MaxStake_Level2=	CONVERT(DECIMAL(19,8), REPLACE(LTRIM(RTRIM(SUBSTRING (BetLimitValue,CHARINDEX('-',BetLimitValue) + 1,LEN(BetLimitValue)))),',','')) * 5
	,MaxStake_Level3=	CONVERT(DECIMAL(19,8), REPLACE(LTRIM(RTRIM(SUBSTRING (BetLimitValue,CHARINDEX('-',BetLimitValue) + 1,LEN(BetLimitValue)))),',','')) * 10
	
FROM #GameType_pivot T


SELECT T2.ExchangeID,T1.*
INTO #StakeLevelGroupDetail_tmp
FROM #GameType_pivot T1
	INNER JOIN #ExchangeIDListPerCurrency T2 ON T1.Code = T2.Code

/* FOR Credit StakeLevelGroupDetail*/

INSERT INTO StakeLevelGroupDetail
SELECT SL.StakeLevelID,T.GameTypeID, T.MinLable,T.MaxLable_Level1,T.MinStake,T.MaxStake_Level1
FROM StakeLevel SL (NOLOCK)
	INNER JOIN #StakeLevelGroupDetail_tmp T ON SL.ExchangeId = T.ExchangeID
WHERE SL.GameGroupID = 1 -- LEVEL 1

INSERT INTO StakeLevelGroupDetail
SELECT SL.StakeLevelID,T.GameTypeID, T.MinLable,T.MaxLable_Level2,T.MinStake,T.MaxStake_Level2
FROM StakeLevel SL (NOLOCK)
	INNER JOIN #StakeLevelGroupDetail_tmp T ON SL.ExchangeId = T.ExchangeID
WHERE SL.GameGroupID = 2 -- LEVEL 2

INSERT INTO StakeLevelGroupDetail
SELECT SL.StakeLevelID,T.GameTypeID, T.MinLable,T.MaxLable_Level3,T.MinStake,T.MaxStake_Level3
FROM StakeLevel SL (NOLOCK)
	INNER JOIN #StakeLevelGroupDetail_tmp T ON SL.ExchangeId = T.ExchangeID
WHERE SL.GameGroupID = 3 -- LEVEL 3

/* FOR Deposit Dep_StakeLevelGroupDetail */

INSERT INTO Dep_StakeLevelGroupDetail
SELECT SL.StakeLevelID,T.GameTypeID, T.MinLable,T.MaxLable_Level1,T.MinStake,T.MaxStake_Level1
FROM Dep_StakeLevel SL (NOLOCK)
	INNER JOIN #StakeLevelGroupDetail_tmp T ON SL.ExchangeId = T.ExchangeID
WHERE SL.GameGroupID = 4 -- LEVEL 1

INSERT INTO Dep_StakeLevelGroupDetail
SELECT SL.StakeLevelID,T.GameTypeID, T.MinLable,T.MaxLable_Level2,T.MinStake,T.MaxStake_Level2
FROM Dep_StakeLevel SL (NOLOCK)
	INNER JOIN #StakeLevelGroupDetail_tmp T ON SL.ExchangeId = T.ExchangeID
WHERE SL.GameGroupID = 5 -- LEVEL 2

INSERT INTO Dep_StakeLevelGroupDetail
SELECT SL.StakeLevelID,T.GameTypeID, T.MinLable,T.MaxLable_Level3,T.MinStake,T.MaxStake_Level3
FROM Dep_StakeLevel SL (NOLOCK)
	INNER JOIN #StakeLevelGroupDetail_tmp T ON SL.ExchangeId = T.ExchangeID
WHERE SL.GameGroupID = 6 -- LEVEL 3

SET IDENTITY_INSERT StakeLevel OFF 

DROP TABLE #Currency
DROP TABLE #ExchangeIDListPerCurrency
DROP TABLE #GameType
DROP TABLE #GameType_pivot
DROP TABLE #StakeLevelGroupDetail_tmp