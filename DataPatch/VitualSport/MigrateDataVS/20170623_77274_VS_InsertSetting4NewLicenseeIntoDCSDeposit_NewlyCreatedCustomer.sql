/*
	Created: 20170626@Helen
	Task: insert the Setting of VS of new licensees into the DCS database.
	Redmine: https://redmine.nexcel.vn/issues/77274
	DB: DBCUST/CUSTDB
*/ 
------------------------------------------------------
DECLARE @ProductID INT = 5 -- VS

CREATE TABLE #supers (custid INT, currency INT, isfinished bit default(0))

DECLARE @max_custid INT, @srecommend INT,  @currency INT ,@SportType INT = 180,@BetType INT = 1201, @bitmapOrder INT
SELECT   @max_custid= xxx ---input maxcustid

SET @bitmapOrder = (SELECT bitmapOrder FROM Dep_ProductStatusProfile WITH(NOLOCK) WHERE Sporttype =  @SportType )
CREATE TABLE #tblCust_member (custid INT,agentid INT, roleid INT,currency INT,srecommend INT, DisableVirtualSports BIT) 

INSERT INTO #tblCust_member (custid,agentid,roleid,currency,srecommend,DisableVirtualSports)			
SELECT ci.custid,ci.recommend,roleid,ci.currency, ci.srecommend,ci.DisableVirtualSports
FROM custInfo CI WITH(NOLOCK)
	INNER JOIN Dep_CustSuper CS WITH(NOLOCK) ON ci.srecommend = cs.custid
WHERE ci.mrecommend NOT IN (SELECT custid FROM custinfo cs1 WITH(NOLOCK)
						   WHERE cs1.srecommend=ci.srecommend and cs1.username like '%Acc%' and cs1.roleid=3 )
	AND ci.custid > @max_custid
	AND cs.site in (
					-- Licensee fee 0.85
					'12Bet', 'asiabet88', 'mansion88', 'alog', 'spondemo', 'TLC', 'SunGame', 'MayFair', 'Zzun88', 'Bodog', 'Vwin', 'Macaubet', 'VCasia', 'Aoncash', 'Bwinning', 'ITCBet', 'i668bet', 'Avia', 'W88', '9bet', '67BET', '3star88', 'SLC88', 'Bet2day', 'OLE777', 'Winner99', '88Macao', 'Boma365', 'Hbobet', 'Mgm88', 'Saloncs', 'Salon365', 'Ae88', 'Hengcai88', 'Senibet', 'Allbetclub', 'Happy1668', 'AG', 'M8bola', 'THBET', '9Club', 'XTD3', '28BET', 'HONBET', 'Q8bola', 'BE7', 'iBET', 'MarvelDH', 'DAYWIN', 'GooBet', 'ISC888', 'KaiHao', 'Liga', 'RYB95', 'SHABAING', 'NBCbet', '666VIP', 'Inbet', 'HonorW', 'DEWA', 'IBO', 'YHY1980', 'Empire555', 'Unobet', 'GamingSoft', 'Newhonbet', '21Cash', 'DUOLE', 'Hecbet', 'DBP', 'Asianbet', 'Baobet', 'HL8', 'Abcasino', 'TGO', 'Lexibet', 'King10', '365online', 'CQ11', 'Uwin18', 'Bolanation', 'KhmerG', 'Gampag', 'IONclub', 'Sun988', 'Mayayule', 'HuangMa', 'Webet138', 'webet88', 'Emmyo', 'BigGaming', 'Boying', 'GDC', 'MrCat', 'TCL', 'Aragon88', 'PKbet', 'VCBA', 'Taipanbet', 'Indowin', 'FLC', 'BetStar', 'Dawoo', 'Ty777', 'Kasking88', 'ABB688', 'Star99', 'BuyWin', 'Uwoniwin', 'Sunrise', 'yq355', 'XTD1', 'XTD2', 'Wawabet', 'BlueOcean', 'Lambo777', 'Deebet', 'Citibet', 'BE7TH', 'Starnet', '12betco', 'sbcbet', 'Brown888', 'CGame', 'IGPTech', 'TGame', 'LZYQ', 'May88', 'Swin', 'LongBao', 'UN168', 'PanguGame', 'K8VN', 'ECLBET', 'Lucky88', 'GPIGAME', '818Bet','SSSSEA'
					-- Licensee fee 0.875
					, 'HAIFA'
					)
	AND ci.roleid = 1
	AND CS.currency NOT IN (27) -- Currency H - it is just test currency, used once in a while 
						   
-- PT processing
PRINT 'PT'
-- For Member
INSERT INTO Dep_CustSettingMode (CustID,IsGroupedPT)
SELECT c.custid,1
FROM #tblCust_member C
WHERE C.roleid = 1 AND NOT EXISTS (SELECT 1 FROM Dep_CustSettingMode C1 (NOLOCK) WHERE c1.CustID = c.Custid)
	
PRINT 'Status'
-- Update if exists
UPDATE T 
		SET bitmapIsDisabled = CASE
									WHEN C.DisableVirtualSports = 0 THEN (SELECT * FROM f_CustSetting_GenerateProductStatus (t.bitmapIsDisabled, @bitmapOrder,0)) 
									ELSE (SELECT * FROM f_CustSetting_GenerateProductStatus (t.bitmapIsDisabled, @bitmapOrder,1)) 
								END --dbo.f_GenerateProductStatus (t.bitmapIsDisabled, 1,0)		
			, bitmapIsHidden = (SELECT * FROM f_CustSetting_GenerateProductStatus (t.bitmapIsHidden, @bitmapOrder,0))--dbo.f_GenerateProductStatus(t.bitmapIsHidden , 1,0)
				
FROM [dbo].[Dep_CustProductStatus] T (ROWLOCK)
	INNER JOIN #tblCust_member C ON C.custid = T.custid

-- Insert new	
INSERT INTO [dbo].[Dep_CustProductStatus](CustID,bitmapIsDisabled,bitmapIsHidden)
SELECT	c.custid
		, CASE	
				WHEN C.DisableVirtualSports = 0 THEN dbo.f_GenerateProductStatus (0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF, @bitmapOrder,0)
				ELSE dbo.f_GenerateProductStatus (0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF, @bitmapOrder,1) 
		END AS bitmapIsDisabled
				
		, dbo.f_GenerateProductStatus (0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF, @bitmapOrder,0)  AS bitmapIsHidden
FROM #tblCust_member C
WHERE NOT EXISTS (SELECT 1 FROM [dbo].[Dep_CustProductStatus] T (NOLOCK) WHERE t.custid = c.custid)

PRINT 'Betting Limit'

CREATE TABLE #SportTypeCheck (SportType SMALLINT, BetType SMALLINT, MaxPerMatchName VARCHAR(200), PRIMARY KEY (SportType,Bettype) )	
INSERT INTO #SportTypeCheck 
VALUES
	(180,1201,'maxpermatch180'),
	(181,1231,'maxpermatch181'),
	(182,1231,'maxpermatch182'),
	(183,1231,'maxpermatch183'),
	(184,1231,'maxpermatch184'),
	(185,1231,'maxpermatch185'),
	(186,1220,'maxpermatch186')
			
-- If first deposit not deployed yet
INSERT INTO Dep_CustBetSetting_Member (CustID, SportType, BetType, MinBet, MaxBet, MaxPerMatch)
SELECT c.custid, csla.sporttype, csla.bettype, csla.minbet, csla.maxbet, a.MaxPerMatch
FROM #tblCust_member C
	INNER JOIN dbo.Dep_CustSetting3rd AS csla WITH (NOLOCK) ON C.custid = csla.CustID  
	INNER JOIN dbo.custInfo CI WITH (NOLOCK) ON CI.custid = C.custid
	CROSS APPLY( VALUES
				('maxpermatch180',ci.maxpermatch180),
				('maxpermatch181',ci.maxpermatch181),
				('maxpermatch182',ci.maxpermatch182),
				('maxpermatch183',ci.maxpermatch183),
				('maxpermatch184',ci.maxpermatch184),
				('maxpermatch185',ci.maxpermatch185),
				('maxpermatch186',ci.maxpermatch186)
         ) AS A(columnname, maxpermatch)
       
       INNER JOIN #SportTypeCheck S ON S.MaxPerMatchName = A.columnname AND csla.SportType = s.SportType AND csla.BetType = s.BetType
WHERE csla.SportType IN (180,181,182,183,184,185,186)
	AND NOT EXISTS (SELECT 1 FROM Dep_CustBetSetting_Member cslm WITH (NOLOCK) WHERE cslm.CustID = C.custid AND cslm.SportType = csla.SportType AND cslm.BetType = csla.BetType)

DROP TABLE #tblCust_member

