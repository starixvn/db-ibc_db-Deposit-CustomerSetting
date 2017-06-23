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
('UN168',13,'25','2,500',25,2500),
('UN168',3,'5','15,000',5,15000),
('UN168',51,'5','15,000',5,15000)

---------- 2402 ------------------
INSERT INTO #Stakelevel_2402_tmp (LicenseeName,ExchangeID,[MinLabel],[MaxLabel],[MinStake],[MaxStake])							
VALUES
('UN168',13,'2,000','20,000',2000,20000),
('UN168',3,'1,000','20,000',1000,20000),
('UN168',51,'1,000','20,000',1000,20000)


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
