/*
	Created: Helen
	Date: 20160810
	Task: import stakelevel global setting 
	DB: DBCUST/CustDB
*/ 

USE [CustDB]

GO

DELETE Dep_StakeLevel WHERE GameTypeID IN (2401,2402)


GO

CREATE TABLE #StakeLevel_2401 (Code VARCHAR(10),minlable varchar(100), maxlable varchar(100),minstake money,maxstake money)
CREATE TABLE #StakeLevel_2402 (Code VARCHAR(10),minlable varchar(100), maxlable varchar(100),minstake money,maxstake money)

INSERT INTO #StakeLevel_2401
VALUES
('USD','2.5','500',2.5,500),
('EUR','2.5','500',2.5,500),
('HKD','10','1.500',10,1500),
('MYR','5','1.000',5,1000),
('CNY','10','1.500',10,1500),
('THB','50','10.000',50,10000),
('IDR','25','3.000',25,3000),
('KRW','2.500','300.000',2500,300000),
('UUS','2.500','300.000',2500,300000)


INSERT INTO #StakeLevel_2402
VALUES
('USD','2.5','500',2.5,500),
('EUR','2.5','500',2.5,500),
('HKD','10','1.500',10,1500),
('MYR','5','1.000',5,1000),
('CNY','10','1.500',10,1500),
('THB','50','10.000',50,10000),
('IDR','25','3.000',25,3000),
('KRW','2.500','300.000',2500,300000),
('UUS','2.500','300.000',2500,300000)


CREATE TABLE #ExchangeIDListPerCurrency (Code VARCHAR(10), ExchangeID INT )


INSERT INTO #ExchangeIDListPerCurrency (Code, ExchangeID)
SELECT c.Code,CASE WHEN C.Code = 'UUS' THEN 20 ELSE e.ExchangeID END 
FROM #StakeLevel_2401  AS c
	LEFT JOIN DBCUST.CUSTDB.dbo.Exchange e WITH (NOLOCK) ON c.Code = e.Code 

DECLARE @max_StakeLevelID INT = 0
SET @max_StakeLevelID = (SELECT MAX(StakeLevelID) FROM Dep_StakeLevel WITH (NOLOCK))

CREATE TABLE #Stake_Level_tmp (ID INT IDENTITY (1,1), GameTypeID INT,[MinLabel] VARCHAR(50),[MaxLabel] VARCHAR(50),[MinStake] MONEY,[MaxStake] MONEY,[ExchangeId] INT, StakeLevelID INT)	

INSERT INTO #Stake_Level_tmp (GameTypeID,[MinLabel],[MaxLabel],[MinStake],[MaxStake],[ExchangeId])

SELECT	2401 GameTypeID,st.minlable,st.maxlable,st.minstake,st.maxstake,e.ExchangeID
FROM #StakeLevel_2401 ST
	INNER JOIN #ExchangeIDListPerCurrency E ON st.Code = e.Code

UNION ALL

SELECT	2402 GameTypeID,st.minlable,st.maxlable,st.minstake,st.maxstake,e.ExchangeID
FROM #StakeLevel_2402 ST
	INNER JOIN #ExchangeIDListPerCurrency E ON st.Code = e.Code

UPDATE 	#Stake_Level_tmp SET StakeLevelID = @max_StakeLevelID + ID

INSERT INTO Dep_StakeLevel (StakeLevelID,GameTypeID,[MinLabel],[MaxLabel],[MinStake],[MaxStake],[ExchangeId])
SELECT StakeLevelID,GameTypeID,[MinLabel],[MaxLabel],[MinStake],[MaxStake],[ExchangeId]
FROM #Stake_Level_tmp

DROP TABLE #StakeLevel_2401

DROP TABLE #StakeLevel_2402

DROP TABLE #ExchangeIDListPerCurrency
