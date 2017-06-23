/*
	Created: 20170227@Helen
	Task: Allbet Licensee - Batch 2,3 launching -[redmine: 71612]
	DB: DBCUST/custdb
*/
CREATE TABLE #Stakelevel_2401_tmp (LicenseeName VARCHAR(200), ExchangeID INT,
							[MinLabel] [nvarchar](50) NULL,
							[MaxLabel] [nvarchar](50) NULL,
							[MinStake] [decimal](19, 8) NULL,
							[MaxStake] [decimal](19, 8) NULL,
							)

CREATE TABLE #Stakelevel_2402_tmp (LicenseeName VARCHAR(200), ExchangeID INT,
							[MinLabel] [nvarchar](50) NULL,
							[MaxLabel] [nvarchar](50) NULL,
							[MinStake] [decimal](19, 8) NULL,
							[MaxStake] [decimal](19, 8) NULL,
							)
														
INSERT INTO #Stakelevel_2401_tmp (LicenseeName,ExchangeID,[MinLabel],[MaxLabel],[MinStake],[MaxStake])							
VALUES
('Emmyo',2,'10','1,000',10,1000),
('Emmyo',15,'40','4,000',40,4000),
('Emmyo',4,'100','10,000',100,10000),
('Emmyo',3,'5','15,000',5,15000),
('Emmyo',13,'25','2,500',25,2500),
('Emmyo',6,'5','15,000',5,15000),
('TCL',13,'50','5,000',50,5000),
('Webet138',13,'25','2,500',25,2500),
('May88',51,'70','7,000',70,7000)

---------- 2402 ------------------
INSERT INTO #Stakelevel_2402_tmp (LicenseeName,ExchangeID,[MinLabel],[MaxLabel],[MinStake],[MaxStake])							
VALUES
('Emmyo',2,'1,000','20,000',1000,20000),
('Emmyo',15,'2,000','30,000',2000,30000),
('Emmyo',4,'5,000','100,000',5000,100000),
('Emmyo',3,'1,000','20,000',1000,20000),
('Emmyo',13,'2,000','20,000',2000,20000),
('Emmyo',6,'1,000','20,000',1000,20000),
('TCL',13,'2,000','40,000',2000,40000),
('Webet138',13,'2,000','20,000',2000,20000),
('May88',51,'2,000','50,000',2000,50000)


CREATE TABLE #Stake_Level_tmp (ID INT IDENTITY (1,1), GameTypeID INT,[MinLabel] VARCHAR(50),[MaxLabel] VARCHAR(50),[MinStake] MONEY,[MaxStake] MONEY,[ExchangeId] INT,SiteID INT, StakeLevelID INT)	

INSERT INTO #Stake_Level_tmp (GameTypeID,[MinLabel],[MaxLabel],[MinStake],[MaxStake],[ExchangeId],[SiteID])

SELECT	2401 GameTypeID,st.[MinLabel],st.[MaxLabel],st.minstake,st.maxstake,st.ExchangeID,S.siteid
FROM #Stakelevel_2401_tmp ST
	INNER JOIN Site (NOLOCK) S ON ST.LicenseeName = S.site
UNION ALL
SELECT	2402 GameTypeID,st.[MinLabel],st.[MaxLabel],st.minstake,st.maxstake,st.ExchangeID,S.siteid
FROM #Stakelevel_2402_tmp ST
	INNER JOIN Site (NOLOCK) S ON ST.LicenseeName = S.site

-- DELETE IF EXISTS 
DELETE SL
FROM Dep_StakeLevel SL 
	INNER JOIN #Stake_Level_tmp T ON T.ExchangeID = SL.ExchangeID AND SL.GameTypeID = T.GameTypeID AND SL.SiteID = T.SiteID
	
DECLARE @max_StakeLevelID INT = 0

SET @max_StakeLevelID = (SELECT MAX(StakeLevelID) FROM Dep_StakeLevel WITH (NOLOCK))

UPDATE 	#Stake_Level_tmp SET StakeLevelID = @max_StakeLevelID + ID

-- INSERT NEW INTO Dep_StakeLevel
INSERT INTO Dep_StakeLevel (StakeLevelID,GameTypeID,[MinLabel],[MaxLabel],[MinStake],[MaxStake],[ExchangeId],SiteID)
SELECT StakeLevelID,GameTypeID,[MinLabel],[MaxLabel],[MinStake],[MaxStake],[ExchangeId],SiteID
FROM #Stake_Level_tmp

/*
-- Checking data inserted into Dep_StakeLevel
SELECT SL.*
FROM Dep_StakeLevel SL 
	INNER JOIN #Stake_Level_tmp T ON T.ExchangeID = SL.ExchangeID AND SL.GameTypeID = T.GameTypeID AND SL.SiteID = T.SiteID

SELECT s.site,st.* from Dep_StakeLevel st (nolock)
	INNER JOIN Site (NOLOCK) S ON ST.SiteID = S.siteid
WHERE GameTypeID = 2401 and site in ('TCL','May88','Webet138','Emmyo')

SELECT COUNT(*) FROM #Stake_Level_tmp	

DROP TABLE #Stakelevel_2401_tmp
DROP TABLE #Stakelevel_2402_tmp
DROP TABLE #Stake_Level_tmp
*/
