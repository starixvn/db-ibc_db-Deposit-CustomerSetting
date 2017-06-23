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
('Macaubet',3,'5','15,000',5,15000),
('Macaubet',15,'40','4,000',40,4000),
('Macaubet',4,'100','10,000',100,10000),
('Macaubet',13,'25','2,500',25,2500),
('Macaubet',2,'10','1,000',10,1000),
('9Bet',3,'5','15,000',5,15000),
('9Bet',15,'100','10,000',100,10000),
('Allbetclub',4,'100','10,000',100,10000),

('BE7',2,'10','1,000',10,1000),
('BE7',13,'25','2,500',25,2500),
('BE7',15,'40','4,000',40,4000),
('BE7',4,'100','10,000',100,10000),
('BE7',3,'5','15,000',5,15000),
('Bolanation',15,'100','10,000',100,10000),

('Aoncash',2,'10','1,000',10,1000),
('Aoncash',3,'5','15,000',5,15000),
('Aoncash',4,'100','10,000',100,10000),
('Aoncash',6,'5','15,000',5,15000),
('Aoncash',9,'5','15,000',5,15000),
('Aoncash',13,'25','2,500',25,2500),
('Aoncash',15,'40','4,000',40,4000),
('NBCbet',2,'10','1,000',10,1000),
('NBCbet',3,'5','15,000',5,15000),
('NBCbet',4,'100','10,000',100,10000),
('NBCbet',6,'5','15,000',5,15000),
('NBCbet',9,'5','15,000',5,15000),
('NBCbet',13,'25','2,500',25,2500),
('NBCbet',15,'40','4,000',40,4000),
('Q8bola',2,'10','1,000',10,1000),
('Q8bola',3,'5','15,000',5,15000),
('Q8bola',4,'100','10,000',100,10000),
('Q8bola',6,'5','15,000',5,15000),
('Q8bola',9,'5','15,000',5,15000),
('Q8bola',13,'25','2,500',25,2500),
('Q8bola',15,'40','4,000',40,4000),
('M8bola',2,'10','1,000',10,1000),
('M8bola',3,'5','15,000',5,15000),
('M8bola',4,'100','10,000',100,10000),
('M8bola',6,'5','15,000',5,15000),
('M8bola',9,'5','15,000',5,15000),
('M8bola',13,'25','2,500',25,2500),
('M8bola',15,'40','4,000',40,4000),
('Goobet',4,'100','10,000',100,10000),
('Goobet',3,'5','15,000',5,15000),
('Goobet',32,'250','25,000',250,25000),
('ITCbet',1,'5','15,000',5,15000),
('ITCbet',3,'5','15,000',5,15000),
('ITCbet',6,'5','15,000',5,15000),
('ITCbet',9,'5','15,000',5,15000),
('ITCbet',15,'40','4,000',40,4000),
('Unobet',2,'10','1,000',10,1000),
('Unobet',3,'5','15,000',5,15000),
('Unobet',4,'100','10,000',100,10000),
('Unobet',6,'5','15,000',5,15000),
('Unobet',13,'25','2,500',25,2500),
('Unobet',15,'40','4,000',40,4000),
('BE7TH',4,'100','10,000',100,10000),

('Aragon88',45,'7,200','720,000',7200,720000),
('Aragon88',13,'25','2,500',25,2500),
('Aragon88',3,'5','15,000',5,15000),
('Aragon88',51,'70','7,000',70,7000),
('Aragon88',4,'100','10,000',100,10000),
('Indowin',15,'40','4,000',40,4000),

('Sbcbet',15,'40','4,000',40,4000),

('ISC888',51,'70','7,000',70,7000),
('ISC888',4,'100','10,000',100,10000),
('ISC888',32,'250','25,000',250,25000),
('Liga',15,'40','4,000',40,4000),

('Brown888',45,'7,200','720,000',7200,720000),
('Brown888',13,'25','2,500',25,2500),
('Brown888',3,'5','15,000',5,15000),
('Brown888',51,'70','7,000',70,7000),
('Brown888',32,'250','25,000',250,25000)

--,('21Cash',15,'40','4,000',40,4000)
---------- 2402 ------------------
INSERT INTO #Stakelevel_2402_tmp (LicenseeName,ExchangeID,[MinLabel],[MaxLabel],[MinStake],[MaxStake])							
VALUES
('Macaubet',3,'1,000','20,000',1000,20000),
('Macaubet',15,'2,000','30,000',2000,30000),
('Macaubet',4,'5,000','100,000',5000,100000),
('Macaubet',13,'2,000','20,000',2000,20000),
('Macaubet',2,'1,000','20,000',1000,20000),
('9Bet',3,'1,000','20,000',1000,20000),
('9Bet',15,'2,000','40,000',2000,40000),
('Allbetclub',4,'5,000','100,000',5000,100000),
('BE7',2,'1,000','20,000',1000,20000),
('BE7',13,'2,000','20,000',2000,20000),
('BE7',15,'2,000','30,000',2000,30000),
('BE7',4,'5,000','100,000',5000,100000),
('BE7',3,'1,000','20,000',1000,20000),
('Bolanation',15,'2,000','40,000',2000,40000),
('Aoncash',2,'1,000','20,000',1000,20000),
('Aoncash',3,'1,000','20,000',1000,20000),
('Aoncash',4,'5,000','100,000',5000,100000),
('Aoncash',6,'1,000','20,000',1000,20000),
('Aoncash',9,'1,000','20,000',1000,20000),
('Aoncash',13,'2,000','20,000',2000,20000),
('Aoncash',15,'2,000','30,000',2000,30000),
('NBCbet',2,'1,000','20,000',1000,20000),
('NBCbet',3,'1,000','20,000',1000,20000),
('NBCbet',4,'5,000','100,000',5000,100000),
('NBCbet',6,'1,000','20,000',1000,20000),
('NBCbet',9,'1,000','20,000',1000,20000),
('NBCbet',13,'2,000','20,000',2000,20000),
('NBCbet',15,'2,000','30,000',2000,30000),
('Q8bola',2,'1,000','20,000',1000,20000),
('Q8bola',3,'1,000','20,000',1000,20000),
('Q8bola',4,'5,000','100,000',5000,100000),
('Q8bola',6,'1,000','20,000',1000,20000),
('Q8bola',9,'1,000','20,000',1000,20000),
('Q8bola',13,'2,000','20,000',2000,20000),
('Q8bola',15,'2,000','30,000',2000,30000),
('M8bola',2,'1,000','20,000',1000,20000),
('M8bola',3,'1,000','20,000',1000,20000),
('M8bola',4,'5,000','100,000',5000,100000),
('M8bola',6,'1,000','20,000',1000,20000),
('M8bola',9,'1,000','20,000',1000,20000),
('M8bola',13,'2,000','20,000',2000,20000),
('M8bola',15,'2,000','30,000',2000,30000),
('Goobet',4,'5,000','100,000',5000,100000),
('Goobet',3,'1,000','20,000',1000,20000),
('Goobet',32,'15,000','300,000',15000,300000),
('ITCbet',1,'1,000','20,000',1000,20000),
('ITCbet',3,'1,000','20,000',1000,20000),
('ITCbet',6,'1,000','20,000',1000,20000),
('ITCbet',9,'1,000','20,000',1000,20000),
('ITCbet',15,'2,000','30,000',2000,30000),
('Unobet',2,'1,000','20,000',1000,20000),
('Unobet',3,'1,000','20,000',1000,20000),
('Unobet',4,'5,000','100,000',5000,100000),
('Unobet',6,'1,000','20,000',1000,20000),
('Unobet',13,'2,000','20,000',2000,20000),
('Unobet',15,'2,000','30,000',2000,30000),
('BE7TH',4,'5,000','100,000',5000,100000),

('Aragon88',45,'110,000','5,500,000',110000,5500000),

('Aragon88',13,'2,000','20,000',2000,20000),
('Aragon88',3,'1,000','20,000',1000,20000),
('Aragon88',51,'2,000','50,000',2000,50000),
('Aragon88',4,'5,000','100,000',5000,100000),
('Indowin',15,'2,000','30,000',2000,30000),
('Sbcbet',15,'2,000','30,000',2000,30000),
('ISC888',51,'2,000','50,000',2000,50000),
('ISC888',4,'5,000','100,000',5000,100000),
('ISC888',32,'15,000','300,000',15000,300000),
('Liga',15,'2,000','30,000',2000,30000),

('Brown888',45,'110,000','5,500,000',110000,5500000),

('Brown888',13,'2,000','20,000',2000,20000),
('Brown888',3,'1,000','20,000',1000,20000),
('Brown888',51,'2,000','50,000',2000,50000),
('Brown888',32,'15,000','300,000',15000,300000)
--,('21Cash',15,'2,000','30,000',2000,30000)


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

SELECT COUNT(*) FROM #Stake_Level_tmp	

DROP TABLE #Stakelevel_2401_tmp
DROP TABLE #Stakelevel_2402_tmp
DROP TABLE #Stake_Level_tmp
*/
