DECLARE @max_custid INT, @srecommend INT, @site varchar (50), @currency int, @member_cnt INT, @SMA_cnt INT, @totalCust_cnt INT 
SELECT  @max_custid= 25098786 --xxx ---input maxcustid

CREATE TABLE #supers (custid int, currency int, isfinished bit default(0))
insert into #supers (custid,currency)
SELECT custid,currency
FROM  Dep_CustSuper with(nolock) 
WHERE site in ('Spondemo','Athena000','ITCbet','Aoncash','Macaubet','9Bet','M8bola','Q8bola','BE7','GooBet','NBCbet','Unobet','BE7th','Bolanation','sbcbet','Allbetclub','Aragon88','indowin')
	AND custid <= @max_custid
	AND currency NOT IN (27) -- Currency H - it is just test currency, used once in a while 
	and custid not in (3233912,8065878,8065893,8066263,8067174,8071614,8071793,8071813,8204710,8248346,8248357,8248721,8249359,8249569,8252720,8253033,8325038,8326431,8330419,8362887,8391974,8404763,8405249,8458906,8488159,10348516,10354255,10354716)



CREATE TABLE #tblCust_sma (custid int, roleid int) 

INSERT INTO #tblCust_sma			
SELECT ci.custid,roleid
FROM custInfo ci WITH(NOLOCK)
	INNER JOIN #supers s on ci.srecommend =  s.custid
WHERE 
	 ci.mrecommend NOT IN (SELECT custid FROM custinfo WITH(NOLOCK)
						   WHERE srecommend=s.custid and username like '%Acc%' and roleid=3)
	AND ci.custid <= @max_custid	
	AND CI.roleid IN (2,3,4)

CREATE TABLE #tblCust_member (custid int,recommend INT) 

INSERT INTO #tblCust_member			
SELECT ci.custid,ci.recommend
FROM custInfo ci WITH(NOLOCK)
	INNER JOIN #supers s on ci.srecommend =  s.custid
WHERE 
	 ci.mrecommend NOT IN (SELECT custid FROM custinfo WITH(NOLOCK)
						   WHERE srecommend=s.custid and username like '%Acc%' and roleid=3)
	AND ci.custid <= @max_custid	
	AND CI.roleid = 1

SET @SMA_cnt = (SELECT COUNT(1) FROM #tblCust_sma)
SET @member_cnt = (SELECT COUNT(1) FROM #tblCust_member)
SET @totalCust_cnt = @SMA_cnt +  @member_cnt

select @SMA_cnt as SMA_cnt, @member_cnt as member_cnt,@totalCust_cnt as total_cnt 
-- PT check
SELECT COUNT(1) AS totalSMA_PT
FROM Dep_CustPTSetting_Agent CS WITH (NOLOCK) 
	INNER JOIN #tblCust_sma sma ON cs.CustID = sma.custid
WHERE cs.SportType = 212 AND cs.BetType = 4001

SELECT COUNT(1) AS totalMember_PT
FROM Dep_CustSettingMode cs WITH (NOLOCK)
	INNER JOIN #tblCust_member member ON cs.CustID = member.custid

SELECT COUNT(1) AS totalAgent_PTGroup
FROM Dep_CustPTGroupSetting_Member cs WITH (NOLOCK)
	INNER JOIN #tblCust_sma sma ON cs.AgentID = sma.custid and sma.roleid = 2 and sporttype = 212
	
SELECT COUNT(distinct s.custid) AS totalAgent_cnt
FROM #tblCust_sma s
	inner join custInfo ci (nolock) on s.custid = ci.recommend and ci.roleid = 1
WHERE s.roleid = 2 

-- StakeLevelGroup check

SELECT COUNT(1) AS totalSMA_SL
FROM Dep_CustStakeLevel_Agent CS WITH (NOLOCK) 
	INNER JOIN #tblCust_sma sma ON cs.CustID = sma.custid
WHERE cs.SportType = 212 AND cs.BetType = 4001

SELECT COUNT(1) AS totalMember_SL
FROM Dep_CustStakeLevel_Member cs WITH (NOLOCK)
	INNER JOIN #tblCust_member member ON cs.CustID = member.custid and cs.SportType = 212 AND cs.BetType = 4001
	
-- Status check
SELECT COUNT(1) AS totalSMA_Status
FROM Dep_CustProductStatus CS WITH (NOLOCK) 
	INNER JOIN #tblCust_sma sma ON cs.CustID = sma.custid
WHERE dbo.f_GetProductStatus (cs.bitmapIsDisabled,1) = 0 AND dbo.f_GetProductStatus (cs.bitmapIsHidden,1) = 0

SELECT COUNT(1) AS totalMember_status
FROM Dep_CustProductStatus cs WITH (NOLOCK)
	INNER JOIN #tblCust_member member ON cs.CustID = member.custid	
WHERE dbo.f_GetProductStatus (cs.bitmapIsDisabled,1) = 0 AND dbo.f_GetProductStatus (cs.bitmapIsHidden,1) = 0

/*
select top 100 * from custinfo c with(nolock)
 where c.srecommend in (select custid from #supers)
 and c.custid <25113006
 and recommend not in (select AgentID  from Dep_CustPTGroupSetting_Member  with(nolock) where SportType=212)
 and mrecommend not in (select custid from custinfo with(nolock) where roleid=3 and username  like '%Acc%')
 and roleid = 1
 */