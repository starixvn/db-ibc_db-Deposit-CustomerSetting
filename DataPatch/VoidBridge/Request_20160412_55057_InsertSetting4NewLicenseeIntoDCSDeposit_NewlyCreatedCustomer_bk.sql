/*
	Created: 20160405@Helen
	Task: insert the Setting of Voidbridge of new licensees into the DCS database.
	Redmine: https://redmine.nexcel.vn/issues/31752
*/ 
DECLARE @max_custid INT
	
SELECT @max_custid = xxx

DECLARE @site varchar (50)
SELECT  @site='12bet'
	
DECLARE @ProductProfileList VARCHAR(200) = '1,2,3'
		, @ProductID INT = 22 -- VB
		-- For ProductStatus param
		, @IsDisable BIT = 0
		, @IsHidden BIT = 0
	
		-- For PT param
		, @SuperPT SMALLINT = 93
		-- For StakelevelGroup params
	
CREATE TABLE #supers (custid int, currency int)

INSERT INTO #supers(custid,currency)
SELECT custid,currency
FROM  Dep_CustSuper with(nolock) 
where site=@site 

CREATE TABLE #tblCust (custid int,agentid int, roleid int) 

INSERT INTO #tblCust			
SELECT custid,recommend,roleid
FROM custInfo WITH(NOLOCK)
WHERE srecommend IN (SELECT custid FROM #supers)
	AND mrecommend NOT IN (SELECT custid FROM custinfo WITH(NOLOCK)
							WHERE srecommend IN (SELECT custid FROM #supers) and username like '%Acc%' and roleid=3)
	AND custid > @max_custid AND roleid = 1							   

-- PT processing
-- For Member
INSERT INTO Dep_CustSettingMode (CustID,IsGroupedPT)
SELECT c.custid,1
FROM #tblCust C
WHERE C.roleid = 1 

-- Status Process

SELECT 212 AS SportType, 4001 AS Bettype, 4 AS SettingType, @IsDisable AS IsDisabled, @IsHidden AS IsHidden, 1 AS bitmapOrder 
INTO #SportBettypeFilter4
		
DECLARE @xmlStrDisabled XML
DECLARE @xmlStrHidden XML
		
SET @xmlStrDisabled = (
		SELECT (
				SELECT ft.bitmapOrder	AS '@b'
					, ft.IsDisabled	AS '@s'
				FROM #SportBettypeFilter4 ft 	
				FOR XML PATH('r')
					, TYPE
				)
		FOR XML PATH('root')
			, TYPE
		)
				
SET @xmlStrHidden = (
		SELECT (
				SELECT ft.bitmapOrder	AS '@b'
					, ft.IsHidden	AS '@s'
				FROM #SportBettypeFilter4 ft 	
				FOR XML PATH('r')
					, TYPE
				)
		FOR XML PATH('root')
			, TYPE
		)
					
INSERT INTO [dbo].[Dep_CustProductStatus]([CustID],bitmapIsDisabled,bitmapIsHidden)
SELECT	c.custid
		, (select bitmap from dbo.f_GenerateProductStatus_multiple (0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF, CONVERT(VARCHAR(MAX),@xmlStrDisabled)))	
		, (select bitmap from dbo.f_GenerateProductStatus_multiple (0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF, CONVERT(VARCHAR(MAX),@xmlStrHidden)))
FROM #tblCust C

-- StakeLevelGroup
-- Insert NEW for level 1
INSERT INTO Dep_CustStakeLevel_member (CustID,SportType,BetType,StakeLevelList)
SELECT C.custid,csla.SportType,csla.BetType, L.list
FROM #tblCust C
	INNER JOIN dbo.Dep_CustStakeLevel_Agent AS csla WITH (NOLOCK) ON C.agentid = csla.CustID
	CROSS APPLY(SELECT TOP 1 ss.val list
				FROM 	dbo.strSplit(csla.StakeLevelList, ',') AS ss
					INNER JOIN Dep_StakeLevel sl WITH (NOLOCK) ON ss.val = sl.StakeLevelID  
				ORDER BY sl.MaxStake, sl.MinStake, SL.GameGroupID
				) AS L					
WHERE C.roleid = 1				
		
DROP TABLE #SportBettypeFilter4
DROP TABLE #tblCust

