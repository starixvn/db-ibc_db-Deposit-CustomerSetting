ALTER PROCEDURE [dbo].[Dot_Dep_CustomerSelMemBetSetting_Cust]
	@CustId int
AS
 /*
Created: 20090721@Phuc (Tommy)
Task : Update member MIN MAX bet.
DB: DBTXN/CustDB + DB06/bodb02

Revisions:
	- 20091303@Peter : #353 IRP - DBA - Separate HorseRacing AND Financial's setting FROM custsetting AND custoverride
	- 20100405@Phuc: retrieve bet setting for HorseRacing.
	- 20100925@Johnson: retrieve bet setting for Number game AND parlay mixed sports	
	- 20110226@Henry: retrieve setting for HR AU, Greyhound, Harness  
	- 20110620@Henry: support MaxPerBall + support input AGENT LEVEL
	- 20120321@Kiwi: - Change to use Dep_CustSetting/Dep_CustSetting3rd
					 - Remove Ficancials setting (201)
	- 20130716@Elodie: retrieve bet setting for Virtual Soccer
	- 20131211@Elodie: retrieve bet setting for Virtual Racing(181), Greyhounds(182), Motor Racing(184), Tennis(186)
	- 20140123@Elodie: retrieve bet setting for HR Fixed Odds(154) [Redmine:#10922]
	- 20140305@Elodie: retrieve bet setting for Keno(202) [Redmine:#11658]
	- 20140424@Elodie: Fix bug for case not existsed data in CustGameType
									
Param's Explanation:
*/
SET NOCOUNT ON

DECLARE 
	@MinBet_Min MONEY, 
	@MaxBet_Max MONEY, 
	@MaxPerMatch_Min MONEY, 
	@MaxPerMatch_Max MONEY,    
	@MinBetv2_Min MONEY, 
	@MaxBetv2_Max MONEY, 
	@MaxPerMatchv2_Min MONEY, 
	@MaxPerMatchv2_Max MONEY,
	@MinBetv3_Min MONEY, 
	@MaxBetv3_Max MONEY, 
	@MaxPerMatchv3_Min MONEY, 
	@MaxPerMatchv3_Max MONEY,    
	@MinBetv5_Min MONEY, 
	@MaxBetv5_Max MONEY, 
	@MaxPerMatchv5_Min MONEY, 
	@MaxPerMatchv5_Max MONEY,    
	@MinBetv8_Min MONEY, 
	@MaxBetv8_Max MONEY, 
	@MaxPerMatchv8_Min MONEY, 
	@MaxPerMatchv8_Max MONEY,    
	@MinBetv10_Min MONEY, 
	@MaxBetv10_Max MONEY, 
	@MaxPerMatchv10_Min MONEY, 
	@MaxPerMatchv10_Max MONEY,    
	@MinBetv11_Min MONEY, 
	@MaxBetv11_Max MONEY, 
	@MaxPerMatchv11_Min MONEY, 
	@MaxPerMatchv11_Max MONEY,    
	@MinBetv99_Min MONEY, 
	@MaxBetv99_Max MONEY, 
	@MaxPerMatchv99_Min MONEY, 
	@MaxPerMatchv99_Max MONEY,
	
	@MinBetv99MP_Min MONEY, 
	@MaxBetv99MP_Max MONEY, 
	@MaxPerMatchv99MP_Min MONEY, 
	@MaxPerMatchv99MP_Max MONEY,

	--v154
	@MinBetv154_Min MONEY, 
	@MaxBetv154_Max MONEY, 
	@MaxPerMatchv154_Min MONEY, 
	@MaxPerMatchv154_Max MONEY,

	--v201
	@MinBetv201_Min MONEY, 
	@MaxBetv201_Max MONEY, 
	@MaxPerMatchv201_Min MONEY, 
	@MaxPerMatchv201_Max MONEY,   
	
	--v202
	@MinBetv202_1501_Min MONEY, 
	@MaxBetv202_1501_Max MONEY, 
	@MaxPerMatchv202_1501_Min MONEY, 
	@MaxPerMatchv202_1501_Max MONEY,  

	@MinBetv151_Min MONEY, 
	@MaxBetv151_Max MONEY, 
	@MaxPerMatchv151_Min MONEY, 
	@MaxPerMatchv151_Max MONEY,
	--Open Tote
	@MinBetv151OT_Max MONEY, 
	@MaxBetv151OT_Min MONEY, 
	@MaxPerMatchv151OT_Min MONEY, 
	@MaxPerMatchv151OT_Max MONEY,   
	
	--v151_51
	@MinBetv151_51_Min MONEY, 
	@MaxBetv151_51_Max MONEY, 
	@MaxPerMatchv151_51_Min MONEY, 
	@MaxPerMatchv151_51_Max MONEY,
	--v152_41
	@MinBetv152_41_Min MONEY, 
	@MaxBetv152_41_Max MONEY, 
	@MaxPerMatchv152_41_Min MONEY, 
	@MaxPerMatchv152_41_Max MONEY,
	--v152_51
	@MinBetv152_51_Min MONEY, 
	@MaxBetv152_51_Max MONEY, 
	@MaxPerMatchv152_51_Min MONEY, 
	@MaxPerMatchv152_51_Max MONEY,
	--v153_51
	@MinBetv153_51_Min MONEY, 
	@MaxBetv153_51_Max MONEY, 
	@MaxPerMatchv153_51_Min MONEY, 
	@MaxPerMatchv153_51_Max MONEY,	

	--Number game
	@MinBetv161_Max MONEY, 
	@MaxBetv161_Min MONEY, 
	@MaxPerMatchv161_Min MONEY, 
	@MaxPerMatchv161_Max MONEY,
	@MaxPerBallv161_Max MONEY,
	
	--Virtual soccer
	@MinBetv180_Max MONEY, 
	@MaxBetv180_Min MONEY, 
	@MaxPerMatchv180_Min MONEY, 
	@MaxPerMatchv180_Max MONEY,	

	--Virtual horse racing
	@MinBetv181_Max MONEY, 
	@MaxBetv181_Min MONEY, 
	@MaxPerMatchv181_Min MONEY, 
	@MaxPerMatchv181_Max MONEY,
	
	--Virtual greyhounds
	@MinBetv182_Max MONEY, 
	@MaxBetv182_Min MONEY, 
	@MaxPerMatchv182_Min MONEY, 
	@MaxPerMatchv182_Max MONEY,
	
	--Virtual motor racing
	@MinBetv184_Max MONEY, 
	@MaxBetv184_Min MONEY, 
	@MaxPerMatchv184_Min MONEY, 
	@MaxPerMatchv184_Max MONEY,
	
	--Virtual tennis
	@MinBetv186_Max MONEY, 
	@MaxBetv186_Min MONEY, 
	@MaxPerMatchv186_Min MONEY, 
	@MaxPerMatchv186_Max MONEY
  
------------------------------------------------------------------------------------------------------------------------------------------
             
SELECT    
	@MinBet_Min = MAX(CASE WHEN MinBet = 0 THEN NULL ELSE MinBet END),     
	@MaxBet_Max = MIN(CASE WHEN MaxBet = 0 THEN NULL ELSE MaxBet END)    
FROM     
	Dep_CustSetting AS cs WITH (NOLOCK)    
	INNER JOIN custinfo AS ci WITH (NOLOCK) ON (cs.CustID = ci.Recommend OR cs.CustID = ci.MRecommend OR cs.CustID = ci.SRecommend)    
	AND cs.bettype = 1 AND cs.sporttype=1 AND cs.isLive=0
WHERE ci.custid = @CustID    
    
SELECT     
	@MinBetv2_Min = MAX(CASE WHEN MinBet = 0 THEN NULL ELSE MinBet END),     
	@MaxBetv2_Max = MIN(CASE WHEN MaxBet = 0 THEN NULL ELSE MaxBet END)    
FROM     
	Dep_CustSetting AS cs WITH (NOLOCK)    
	INNER JOIN custinfo AS ci WITH (NOLOCK) ON (cs.CustID = ci.Recommend OR cs.CustID = ci.MRecommend OR cs.CustID = ci.SRecommend)    
	AND cs.bettype = 1 AND cs.sporttype=2    
WHERE ci.custid = @CustID    
    
SELECT     
	@MinBetv3_Min = MAX(CASE WHEN MinBet = 0 THEN NULL ELSE MinBet END),     
	@MaxBetv3_Max = MIN(CASE WHEN MaxBet = 0 THEN NULL ELSE MaxBet END)    
FROM     
	Dep_CustSetting AS cs WITH (NOLOCK)    
	INNER JOIN custinfo AS ci WITH (NOLOCK) ON (cs.CustID = ci.Recommend OR cs.CustID = ci.MRecommend OR cs.CustID = ci.SRecommend)    
	AND cs.bettype = 1 AND cs.sporttype=3    
WHERE ci.custid = @CustID    
    
SELECT     
	@MinBetv5_Min = MAX(CASE WHEN MinBet = 0 THEN NULL ELSE MinBet END),     
	@MaxBetv5_Max = MIN(CASE WHEN MaxBet = 0 THEN NULL ELSE MaxBet END)    
FROM     
	Dep_CustSetting AS cs WITH (NOLOCK)    
	INNER JOIN custinfo AS ci WITH (NOLOCK) ON (cs.CustID = ci.Recommend OR cs.CustID = ci.MRecommend OR cs.CustID = ci.SRecommend)    
	AND cs.bettype = 1 AND cs.sporttype=5    
WHERE ci.custid = @CustID    
    
SELECT     
	@MinBetv8_Min = MAX(CASE WHEN MinBet = 0 THEN NULL ELSE MinBet END),     
	@MaxBetv8_Max = MIN(CASE WHEN MaxBet = 0 THEN NULL ELSE MaxBet END)    
FROM     
	Dep_CustSetting AS cs WITH (NOLOCK)    
	INNER JOIN custinfo AS ci WITH (NOLOCK) ON (cs.CustID = ci.Recommend OR cs.CustID = ci.MRecommend OR cs.CustID = ci.SRecommend)    
	AND cs.bettype = 1 AND cs.sporttype=8    
WHERE ci.custid = @CustID    
    
SELECT     
	@MinBetv10_Min = MAX(CASE WHEN MinBet = 0 THEN NULL ELSE MinBet END),     
	@MaxBetv10_Max = MIN(CASE WHEN MaxBet = 0 THEN NULL ELSE MaxBet END)    
FROM     
	Dep_CustSetting AS cs WITH (NOLOCK)    
	INNER JOIN custinfo AS ci WITH (NOLOCK) ON (cs.CustID = ci.Recommend OR cs.CustID = ci.MRecommend OR cs.CustID = ci.SRecommend)    
	AND cs.bettype = 1 AND cs.sporttype=10    
WHERE ci.custid = @CustID    
    
SELECT     
	@MinBetv11_Min = MAX(CASE WHEN MinBet = 0 THEN NULL ELSE MinBet END),     
	@MaxBetv11_Max = MIN(CASE WHEN MaxBet = 0 THEN NULL ELSE MaxBet END)    
FROM     
	Dep_CustSetting AS cs WITH (NOLOCK)    
	INNER JOIN custinfo AS ci WITH (NOLOCK) ON (cs.CustID = ci.Recommend OR cs.CustID = ci.MRecommend OR cs.CustID = ci.SRecommend)    
	AND cs.bettype = 1 AND cs.sporttype=11    
WHERE ci.custid = @CustID    
        
SELECT     
	@MinBetv99_Min = MAX(CASE WHEN MinBet = 0 THEN NULL ELSE MinBet END),     
	@MaxBetv99_Max = MIN(CASE WHEN MaxBet = 0 THEN NULL ELSE MaxBet END)    
FROM     
	Dep_CustSetting AS cs WITH (NOLOCK)    
	INNER JOIN custinfo AS ci WITH (NOLOCK) ON (cs.CustID = ci.Recommend OR cs.CustID = ci.MRecommend OR cs.CustID = ci.SRecommend)    
	AND cs.bettype = 1 AND cs.sporttype=99    
WHERE ci.custid = @CustID    

SELECT 
	@MinBetv99MP_Min = MAX(CASE WHEN MinBet = 0 THEN NULL ELSE MinBet END),
	@MaxBetv99MP_Max = MIN(CASE WHEN MaxBet = 0 THEN NULL ELSE MaxBet END)
FROM 
	Dep_CustSetting AS cs WITH(NOLOCK)
	INNER JOIN custinfo AS ci WITH (NOLOCK) ON (cs.custid = ci.recommend OR cs.custid = ci.mrecommend OR cs.custid = ci.srecommend)
	AND cs.bettype = 9 AND sporttype = 99
WHERE ci.custid = @custid 

--v154
SELECT 
	@MinBetv154_Min = MAX(CASE WHEN MinBet = 0 THEN NULL ELSE MinBet END),
	@MaxBetv154_Max = MIN(CASE WHEN MaxBet = 0 THEN NULL ELSE MaxBet END)
FROM 
	Dep_CustSetting AS cs WITH(NOLOCK)
	INNER JOIN custinfo AS ci WITH (NOLOCK) ON (cs.custid = ci.recommend OR cs.custid = ci.mrecommend OR cs.custid = ci.srecommend)
	AND cs.bettype = 20 AND sporttype = 154
WHERE ci.custid = @custid
		
SELECT     
	@MinBetv151_Min = MAX(CASE WHEN MinBet = 0 THEN NULL ELSE MinBet END),     
	@MaxBetv151_Max = MIN(CASE WHEN MaxBet = 0 THEN NULL ELSE MaxBet END)    
FROM     
	Dep_CustSetting3rd AS cs WITH (NOLOCK)    
	INNER JOIN custinfo AS ci WITH (NOLOCK) ON (cs.CustID = ci.Recommend OR cs.CustID = ci.MRecommend OR cs.CustID = ci.SRecommend)    
	AND cs.bettype = 31 AND cs.sporttype=151    
WHERE ci.custid = @CustID    
    
--Open Tote
SELECT     
	@MinBetv151OT_Max = MAX(CASE WHEN MinBet = 0 THEN NULL ELSE MinBet END),     
	@MaxBetv151OT_Min = MIN(CASE WHEN MaxBet = 0 THEN NULL ELSE MaxBet END)    
FROM     
	Dep_CustSetting3rd AS cs WITH (NOLOCK)    
	INNER JOIN custinfo AS ci WITH (NOLOCK) ON (cs.CustID = ci.Recommend OR cs.CustID = ci.MRecommend OR cs.CustID = ci.SRecommend)    
	AND cs.bettype = 41 AND cs.sporttype=151    
WHERE ci.custid = @CustID    

--v151_51
SELECT     
	@MinBetv151_51_Min = MAX(CASE WHEN MinBet = 0 THEN NULL ELSE MinBet END),     
	@MaxBetv151_51_Max = MIN(CASE WHEN MaxBet = 0 THEN NULL ELSE MaxBet END)    
FROM     
	Dep_CustSetting3rd AS cs WITH (NOLOCK)    
	INNER JOIN custinfo AS ci WITH (NOLOCK) ON (cs.CustID = ci.Recommend OR cs.CustID = ci.MRecommend OR cs.CustID = ci.SRecommend)    
	AND cs.bettype = 51 AND cs.sporttype=151    
WHERE ci.custid = @CustID    
--v152_41
SELECT     
	@MinBetv152_41_Min = MAX(CASE WHEN MinBet = 0 THEN NULL ELSE MinBet END),     
	@MaxBetv152_41_Max = MIN(CASE WHEN MaxBet = 0 THEN NULL ELSE MaxBet END)    
FROM     
	Dep_CustSetting3rd AS cs WITH (NOLOCK)    
	INNER JOIN custinfo AS ci WITH (NOLOCK) ON (cs.CustID = ci.Recommend OR cs.CustID = ci.MRecommend OR cs.CustID = ci.SRecommend)    
	AND cs.bettype = 41 AND cs.sporttype=152    
WHERE ci.custid = @CustID  
--v152_51
SELECT     
	@MinBetv152_51_Min = MAX(CASE WHEN MinBet = 0 THEN NULL ELSE MinBet END),     
	@MaxBetv152_51_Max = MIN(CASE WHEN MaxBet = 0 THEN NULL ELSE MaxBet END)    
FROM     
	Dep_CustSetting3rd AS cs WITH (NOLOCK)    
	INNER JOIN custinfo AS ci WITH (NOLOCK) ON (cs.CustID = ci.Recommend OR cs.CustID = ci.MRecommend OR cs.CustID = ci.SRecommend)    
	AND cs.bettype = 51 AND cs.sporttype=152    
WHERE ci.custid = @CustID  
--v153_51
SELECT     
	@MinBetv153_51_Min = MAX(CASE WHEN MinBet = 0 THEN NULL ELSE MinBet END),     
	@MaxBetv153_51_Max = MIN(CASE WHEN MaxBet = 0 THEN NULL ELSE MaxBet END)    
FROM     
	Dep_CustSetting3rd AS cs WITH (NOLOCK)    
	INNER JOIN custinfo AS ci WITH (NOLOCK) ON (cs.CustID = ci.Recommend OR cs.CustID = ci.MRecommend OR cs.CustID = ci.SRecommend)    
	AND cs.bettype = 51 AND cs.sporttype=153    
WHERE ci.custid = @CustID 

--Number game
SELECT 
	@MinBetv161_Max = MAX(CASE WHEN MinBet = 0 THEN NULL ELSE MinBet END),
	@MaxBetv161_Min = MIN(CASE WHEN MaxBet = 0 THEN NULL ELSE MaxBet END)
FROM
	Dep_CustSetting3rd AS cs WITH (NOLOCK)
	INNER JOIN custinfo AS ci WITH (NOLOCK) ON (cs.custid = ci.recommend OR cs.custid = ci.mrecommend OR cs.custid = ci.srecommend)
	AND cs.sporttype = 161 AND cs.bettype = 81
WHERE ci.custid = @custid	
    
--Virtual Soccer
SELECT 
	@MinBetv180_Max = MAX(CASE WHEN MinBet = 0 THEN NULL ELSE MinBet END),
	@MaxBetv180_Min = MIN(CASE WHEN MaxBet = 0 THEN NULL ELSE MaxBet END)
FROM
	Dep_CustSetting3rd AS cs WITH (NOLOCK)
	INNER JOIN custinfo AS ci WITH (NOLOCK) ON (cs.custid = ci.recommend OR cs.custid = ci.mrecommend OR cs.custid = ci.srecommend)
	AND cs.sporttype = 180 AND cs.bettype = 1201
WHERE ci.custid = @custid
    
--Virtual Horse Racing
SELECT 
	@MinBetv181_Max = MAX(CASE WHEN MinBet = 0 THEN NULL ELSE MinBet END),
	@MaxBetv181_Min = MIN(CASE WHEN MaxBet = 0 THEN NULL ELSE MaxBet END)
FROM
	Dep_CustSetting3rd AS cs WITH (NOLOCK)
	INNER JOIN custinfo AS ci WITH (NOLOCK) ON (cs.custid = ci.recommend OR cs.custid = ci.mrecommend OR cs.custid = ci.srecommend)
	AND cs.sporttype = 181 AND cs.bettype = 1231
WHERE ci.custid = @custid

--Virtual Greyhounds
SELECT 
	@MinBetv182_Max = MAX(CASE WHEN MinBet = 0 THEN NULL ELSE MinBet END),
	@MaxBetv182_Min = MIN(CASE WHEN MaxBet = 0 THEN NULL ELSE MaxBet END)
FROM
	Dep_CustSetting3rd AS cs WITH (NOLOCK)
	INNER JOIN custinfo AS ci WITH (NOLOCK) ON (cs.custid = ci.recommend OR cs.custid = ci.mrecommend OR cs.custid = ci.srecommend)
	AND cs.sporttype = 182 AND cs.bettype = 1231
WHERE ci.custid = @custid

--Virtual Motor Racing
SELECT 
	@MinBetv184_Max = MAX(CASE WHEN MinBet = 0 THEN NULL ELSE MinBet END),
	@MaxBetv184_Min = MIN(CASE WHEN MaxBet = 0 THEN NULL ELSE MaxBet END)
FROM
	Dep_CustSetting3rd AS cs WITH (NOLOCK)
	INNER JOIN custinfo AS ci WITH (NOLOCK) ON (cs.custid = ci.recommend OR cs.custid = ci.mrecommend OR cs.custid = ci.srecommend)
	AND cs.sporttype = 184 AND cs.bettype = 1231
WHERE ci.custid = @custid

--Virtual Tennis
SELECT 
	@MinBetv186_Max = MAX(CASE WHEN MinBet = 0 THEN NULL ELSE MinBet END),
	@MaxBetv186_Min = MIN(CASE WHEN MaxBet = 0 THEN NULL ELSE MaxBet END)
FROM
	Dep_CustSetting3rd AS cs WITH (NOLOCK)
	INNER JOIN custinfo AS ci WITH (NOLOCK) ON (cs.custid = ci.recommend OR cs.custid = ci.mrecommend OR cs.custid = ci.srecommend)
	AND cs.sporttype = 186 AND cs.bettype = 1220
WHERE ci.custid = @custid

--Keno
SELECT 
	@MinBetv202_1501_Min = MAX(CASE WHEN cg.MinBet = 0 THEN NULL ELSE cg.MinBet END),
	@MaxBetv202_1501_Max = MIN(CASE WHEN cg.MaxBet = 0 THEN NULL ELSE cg.MaxBet END),
	@MaxPerMatchv202_1501_Min = 0,
	@MaxPerMatchv202_1501_Max = MIN(CASE WHEN cg.MaxPerGameType = 0 THEN NULL ELSE cg.MaxPerGameType END)
FROM
	CustGameType AS cg WITH (NOLOCK)
	INNER JOIN custinfo AS ci WITH (NOLOCK) ON (cg.custid = ci.recommend OR cg.custid = ci.mrecommend OR cg.custid = ci.srecommend)
	INNER JOIN bodb02.dbo.GameType gt WITH (NOLOCK) ON cg.GameTypeID = gt.GameTypeID	
WHERE ci.custid = @custid AND gt.IBCBetTypeID = 1501
    
SELECT     
	@MaxPerMatch_Min = 0,     
	@MaxperMatch_Max = MIN(CASE WHEN cs.MaxPerMatch = 0 THEN NULL ELSE cs.MaxPerMatch END),     
	@MaxPerMatchv2_Min = 0,    
	@MaxPerMatchv2_Max = MIN(CASE WHEN cs.MaxPerMatch2 = 0 THEN NULL ELSE cs.MaxPerMatch2 END),  
	@MaxPerMatchv3_Min = 0,    
	@MaxPerMatchv3_Max = MIN(CASE WHEN cs.MaxPerMatch3 = 0 THEN NULL ELSE cs.MaxPerMatch3 END),  
	@MaxPerMatchv5_Min = 0,    
	@MaxPerMatchv5_Max = MIN(CASE WHEN cs.MaxPerMatch5 = 0 THEN NULL ELSE cs.MaxPerMatch5 END),  
	@MaxPerMatchv8_Min = 0,    
	@MaxPerMatchv8_Max = MIN(CASE WHEN cs.MaxPerMatch8 = 0 THEN NULL ELSE cs.MaxPerMatch8 END),  
	@MaxPerMatchv10_Min = 0,    
	@MaxPerMatchv10_Max = MIN(CASE WHEN cs.MaxPerMatch10 = 0 THEN NULL ELSE cs.MaxPerMatch10 END),  
	@MaxPerMatchv11_Min = 0,    
	@MaxPerMatchv11_Max = MIN(CASE WHEN cs.MaxPerMatch11 = 0 THEN NULL ELSE cs.MaxPerMatch11 END),  
	@MaxPerMatchv99_Min = 0,    
	@MaxPerMatchv99_Max = MIN(CASE WHEN cs.MaxPerMatch99 = 0 THEN NULL ELSE cs.MaxPerMatch99 END),  
	@MaxPerMatchv99MP_Min = 0,
	@MaxPerMatchv99MP_Max = MIN(CASE WHEN cs.MaxPerMatch99MP = 0 THEN NULL ELSE cs.MaxPerMatch99MP END),
	--v154
	@MaxPerMatchv154_Min = 0,    
	@MaxPerMatchv154_Max = MIN(CASE WHEN cs.MaxPerMatch154 = 0 THEN NULL ELSE cs.MaxPerMatch154 END), 

	@MaxPerMatchv201_Min = 0,    
	@MaxPerMatchv201_Max = 0,
	@MaxPerMatchv151_Min = 0,    
	@MaxPerMatchv151_Max = MIN(CASE WHEN cs.MaxPerMatch151 = 0 THEN NULL ELSE cs.MaxPerMatch151 END), 
	@MaxPerMatchv151OT_Min = 0,    
	@MaxPerMatchv151OT_Max = MIN(CASE WHEN cs.MaxPerMatch151_OT = 0 THEN NULL ELSE cs.MaxPerMatch151_OT END) ,
	
	--v151_51
	@MaxPerMatchv151_51_Min = 0,    
	@MaxPerMatchv151_51_Max = MIN(CASE WHEN cs.MaxPerMatch151_AU = 0 THEN NULL ELSE cs.MaxPerMatch151_AU END), 
	--v152_41
	@MaxPerMatchv152_41_Min = 0,    
	@MaxPerMatchv152_41_Max = MIN(CASE WHEN cs.MaxPerMatch152_UK = 0 THEN NULL ELSE cs.MaxPerMatch152_UK END), 
	--v152_51
	@MaxPerMatchv152_51_Min = 0,    
	@MaxPerMatchv152_51_Max = MIN(CASE WHEN cs.MaxPerMatch152_AU = 0 THEN NULL ELSE cs.MaxPerMatch152_AU END), 
	--v153_51
	@MaxPerMatchv153_51_Min = 0,    
	@MaxPerMatchv153_51_Max = MIN(CASE WHEN cs.MaxPerMatch153_AU = 0 THEN NULL ELSE cs.MaxPerMatch153_AU END), 	

	@MaxPerMatchv161_Min = 0,
	@MaxPerMatchv161_Max = MIN(CASE WHEN cs.MaxPerMatch161 = 0 THEN NULL ELSE cs.MaxPerMatch161 END),
	@MaxPerBallv161_Max = MIN(CASE WHEN cs.MaxPerBall161 = 0  THEN NULL ELSE cs.MaxPerBall161 END),
	
	@MaxPerMatchv180_Min = 0,
	@MaxPerMatchv180_Max = MIN(CASE WHEN cs.maxpermatch180 = 0 THEN NULL ELSE cs.maxpermatch180 END),
	
	@MaxPerMatchv181_Min = 0,
	@MaxPerMatchv181_Max = MIN(CASE WHEN cs.maxpermatch181 = 0 THEN NULL ELSE cs.maxpermatch181 END),
	
	@MaxPerMatchv182_Min = 0,
	@MaxPerMatchv182_Max = MIN(CASE WHEN cs.maxpermatch182 = 0 THEN NULL ELSE cs.maxpermatch182 END),
	
	@MaxPerMatchv184_Min = 0,
	@MaxPerMatchv184_Max = MIN(CASE WHEN cs.maxpermatch184 = 0 THEN NULL ELSE cs.maxpermatch184 END),
	
	@MaxPerMatchv186_Min = 0,
	@MaxPerMatchv186_Max = MIN(CASE WHEN cs.maxpermatch186 = 0 THEN NULL ELSE cs.maxpermatch186 END)

FROM     
 custinfo AS cs WITH (NOLOCK)     
 INNER JOIN custinfo AS ci WITH (NOLOCK) ON (cs.CustID = ci.Recommend OR cs.CustID = ci.MRecommend OR cs.CustID = ci.SRecommend)    
WHERE ci.custid = @CustID    
    
SELECT     
	ci.username,     
	ISNULL(ci.maxpermatch, 0) AS maxpermatch,    

	ISNULL(ci.maxpermatch2, 0) AS maxpermatchv2,    
	ISNULL(ci.maxpermatch3, 0) AS maxpermatchv3,    
	ISNULL(ci.maxpermatch5, 0) AS maxpermatchv5,    
	ISNULL(ci.maxpermatch8, 0) AS maxpermatchv8,    
	ISNULL(ci.maxpermatch10, 0) AS maxpermatchv10,    
	ISNULL(ci.maxpermatch11, 0) AS maxpermatchv11,    
	ISNULL(ci.maxpermatch12, 0) AS maxpermatchv12,
	ISNULL(ci.maxpermatch99, 0) AS maxpermatchv99,    
	ISNULL(ci.maxpermatch99mp,0) AS maxpermatchv99mp,
	ISNULL(ci.maxpermatch154, 0) AS maxpermatchv154,
	0 AS maxpermatchv201, 	    
	ISNULL(ci.maxpermatch151, 0) AS maxpermatchv151,    
	ISNULL(ci.maxpermatch151_OT, 0) AS maxpermatchv151OT,    
	
	ISNULL(ci.maxpermatch151_AU, 0) AS maxpermatchv151_51,    
	ISNULL(ci.maxpermatch152_UK, 0) AS maxpermatchv152_41,    
	ISNULL(ci.maxpermatch152_AU, 0) AS maxpermatchv152_51,    
	ISNULL(ci.maxpermatch153_AU, 0) AS maxpermatchv153_51,    
		
	ISNULL(ci.maxpermatch161,0) AS maxpermatchv161,
	ISNULL(ci.maxperball161,0)	AS maxperballv161, 
    
    isnull(ci.maxpermatch180,0) AS maxpermatchv180,
    isnull(ci.maxpermatch181,0) AS maxpermatchv181,
    isnull(ci.maxpermatch182,0) AS maxpermatchv182,
    isnull(ci.maxpermatch184,0) AS maxpermatchv184,
    isnull(ci.maxpermatch186,0) AS maxpermatchv186,
    
	ISNULL(MAX(CASE WHEN cs.bettype = 1 AND cs.sporttype=1 AND cs.isLive=0 THEN cs.minbet ELSE 0 END), 0) AS minbet,    
	ISNULL(MAX(CASE WHEN cs.bettype = 1 AND cs.sporttype=1 AND cs.isLive=0 THEN cs.maxbet ELSE 0 END), 0) AS maxbet,    
	 
	ISNULL(MAX(CASE WHEN cs.bettype = 1 AND cs.sporttype=2 THEN cs.minbet ELSE 0 END), 0) AS MinBetv2,    
	ISNULL(MAX(CASE WHEN cs.bettype = 1 AND cs.sporttype=2 THEN cs.maxbet ELSE 0 END), 0) AS MaxBetv2,    
	 
	ISNULL(MAX(CASE WHEN cs.bettype = 1 AND cs.sporttype=3 THEN cs.minbet ELSE 0 END), 0) AS MinBetv3,    
	ISNULL(MAX(CASE WHEN cs.bettype = 1 AND cs.sporttype=3 THEN cs.maxbet ELSE 0 END), 0) AS MaxBetv3,    

	ISNULL(MAX(CASE WHEN cs.bettype = 1 AND cs.sporttype=5 THEN cs.minbet ELSE 0 END), 0) AS MinBetv5,    
	ISNULL(MAX(CASE WHEN cs.bettype = 1 AND cs.sporttype=5 THEN cs.maxbet ELSE 0 END), 0) AS MaxBetv5,    

	ISNULL(MAX(CASE WHEN cs.bettype = 1 AND cs.sporttype=8 THEN cs.minbet ELSE 0 END), 0) AS MinBetv8,    
	ISNULL(MAX(CASE WHEN cs.bettype = 1 AND cs.sporttype=8 THEN cs.maxbet ELSE 0 END), 0) AS MaxBetv8,    

	ISNULL(MAX(CASE WHEN cs.bettype = 1 AND cs.sporttype=10 THEN cs.minbet ELSE 0 END), 0) AS MinBetv10,    
	ISNULL(MAX(CASE WHEN cs.bettype = 1 AND cs.sporttype=10 THEN cs.maxbet ELSE 0 END), 0) AS MaxBetv10,    

	ISNULL(MAX(CASE WHEN cs.bettype = 1 AND cs.sporttype=11 THEN cs.minbet ELSE 0 END), 0) AS MinBetv11,    
	ISNULL(MAX(CASE WHEN cs.bettype = 1 AND cs.sporttype=11 THEN cs.maxbet ELSE 0 END), 0) AS MaxBetv11,    

	ISNULL(MAX(CASE WHEN cs.bettype = 2 AND cs.sporttype=12 THEN cs.minbet ELSE 0 END), 0) AS MinBetv12,    
	ISNULL(MAX(CASE WHEN cs.bettype = 2 AND cs.sporttype=12 THEN cs.maxbet ELSE 0 END), 0) AS MaxBetv12,  

	ISNULL(MAX(CASE WHEN cs.bettype = 1 AND cs.sporttype=99 THEN cs.minbet ELSE 0 END), 0) AS MinBetv99,    
	ISNULL(MAX(CASE WHEN cs.bettype = 1 AND cs.sporttype=99 THEN cs.maxbet ELSE 0 END), 0) AS MaxBetv99,    

	ISNULL(MAX(CASE WHEN cs.bettype = 9 AND cs.sporttype = 99 THEN cs.minbet ELSE 0 END), 0) AS MinBetv99MP,
	ISNULL(MAX(CASE WHEN cs.bettype = 9 AND cs.sporttype = 99 THEN cs.maxbet ELSE 0 END), 0) AS MaxBetv99MP,
	
	ISNULL(MAX(CASE WHEN cs.bettype = 20 AND cs.sporttype = 154 THEN cs.minbet ELSE 0 END), 0) AS MinBetv154,
	ISNULL(MAX(CASE WHEN cs.bettype = 20 AND cs.sporttype = 154 THEN cs.maxbet ELSE 0 END), 0) AS MaxBetv154,

	0 AS MinBetv201,    
	0 AS MaxBetv201,    

	ISNULL(MAX(CASE WHEN cs3rd.bettype = 31 AND cs3rd.sporttype=151 THEN cs3rd.minbet ELSE 0 END), 0) AS MinBetv151,    
	ISNULL(MAX(CASE WHEN cs3rd.bettype = 31 AND cs3rd.sporttype=151 THEN cs3rd.maxbet ELSE 0 END), 0) AS MaxBetv151,    

	ISNULL(MAX(CASE WHEN cs3rd.bettype = 41 AND cs3rd.sporttype=151 THEN cs3rd.minbet ELSE 0 END), 0) AS MinBetv151OT,    
	ISNULL(MAX(CASE WHEN cs3rd.bettype = 41 AND cs3rd.sporttype=151 THEN cs3rd.maxbet ELSE 0 END), 0) AS MaxBetv151OT,    
	
	ISNULL(MAX(CASE WHEN cs3rd.bettype = 51 AND cs3rd.sporttype=151 THEN cs3rd.minbet ELSE 0 END), 0) AS MinBetv151_51,    
	ISNULL(MAX(CASE WHEN cs3rd.bettype = 51 AND cs3rd.sporttype=151 THEN cs3rd.maxbet ELSE 0 END), 0) AS MaxBetv151_51,  
	
	ISNULL(MAX(CASE WHEN cs3rd.bettype = 41 AND cs3rd.sporttype=152 THEN cs3rd.minbet ELSE 0 END), 0) AS MinBetv152_41,    
	ISNULL(MAX(CASE WHEN cs3rd.bettype = 41 AND cs3rd.sporttype=152 THEN cs3rd.maxbet ELSE 0 END), 0) AS MaxBetv152_41,  
	
	ISNULL(MAX(CASE WHEN cs3rd.bettype = 51 AND cs3rd.sporttype=152 THEN cs3rd.minbet ELSE 0 END), 0) AS MinBetv152_51,    
	ISNULL(MAX(CASE WHEN cs3rd.bettype = 51 AND cs3rd.sporttype=152 THEN cs3rd.maxbet ELSE 0 END), 0) AS MaxBetv152_51,  
	
	ISNULL(MAX(CASE WHEN cs3rd.bettype = 51 AND cs3rd.sporttype=153 THEN cs3rd.minbet ELSE 0 END), 0) AS MinBetv153_51,    
	ISNULL(MAX(CASE WHEN cs3rd.bettype = 51 AND cs3rd.sporttype=153 THEN cs3rd.maxbet ELSE 0 END), 0) AS MaxBetv153_51,  

	ISNULL(MAX(CASE WHEN cs3rd.sporttype = 161 THEN cs3rd.minbet ELSE 0 END),0) AS MinBetv161,
	ISNULL(MAX(CASE WHEN cs3rd.sporttype = 161 THEN cs3rd.maxbet ELSE 0 END),0) AS MaxBetv161,
	
	ISNULL(MAX(CASE WHEN cs3rd.sporttype = 180 THEN cs3rd.minbet ELSE 0 END),0) AS MinBetv180,
	ISNULL(MAX(CASE WHEN cs3rd.sporttype = 180 THEN cs3rd.maxbet ELSE 0 END),0) AS MaxBetv180,
	
	ISNULL(MAX(CASE WHEN cs3rd.sporttype = 181 THEN cs3rd.minbet ELSE 0 END),0) AS MinBetv181,
	ISNULL(MAX(CASE WHEN cs3rd.sporttype = 181 THEN cs3rd.maxbet ELSE 0 END),0) AS MaxBetv181,
	
	ISNULL(MAX(CASE WHEN cs3rd.sporttype = 182 THEN cs3rd.minbet ELSE 0 END),0) AS MinBetv182,
	ISNULL(MAX(CASE WHEN cs3rd.sporttype = 182 THEN cs3rd.maxbet ELSE 0 END),0) AS MaxBetv182,
	
	ISNULL(MAX(CASE WHEN cs3rd.sporttype = 184 THEN cs3rd.minbet ELSE 0 END),0) AS MinBetv184,
	ISNULL(MAX(CASE WHEN cs3rd.sporttype = 184 THEN cs3rd.maxbet ELSE 0 END),0) AS MaxBetv184,
	
	ISNULL(MAX(CASE WHEN cs3rd.sporttype = 186 THEN cs3rd.minbet ELSE 0 END),0) AS MinBetv186,
	ISNULL(MAX(CASE WHEN cs3rd.sporttype = 186 THEN cs3rd.maxbet ELSE 0 END),0) AS MaxBetv186,

	ISNULL(MAX(CASE WHEN gt.IBCBetTypeID = 1501 THEN cg.MinBet ELSE 0 END),0) AS MinBetv202_1501,
	ISNULL(MAX(CASE WHEN gt.IBCBetTypeID = 1501 THEN cg.Maxbet ELSE 0 END),0) AS MaxBetv202_1501,
	ISNULL(MAX(CASE WHEN gt.IBCBetTypeID = 1501 THEN cg.MaxPerGameType ELSE 0 END),0) AS MaxPerMatchv202_1501,
	
	ISNULL(@MinBet_Min, 0) AS MinBet_Min,    
	ISNULL(@MaxBet_Max, 0) AS MaxBet_Max,    
	ISNULL(@MaxPerMatch_Min, 0) AS MaxPerMatch_Min,    
	ISNULL(@MaxPerMatch_Max, 0) AS MaxPerMatch_Max,    
	 
	ISNULL(@MinBetv2_Min, 0) AS MinBetv2_Min,     
	ISNULL(@MaxBetv2_Max, 0) AS MaxBetv2_Max,     
	ISNULL(@MaxPerMatchv2_Min, 0) AS MaxPerMatchv2_Min,     
	ISNULL(@MaxPerMatchv2_Max, 0) AS MaxPerMatchv2_Max,     
	 
	ISNULL(@MinBetv3_Min, 0) AS MinBetv3_Min,     
	ISNULL(@MaxBetv3_Max, 0) AS MaxBetv3_Max,     
	ISNULL(@MaxPerMatchv3_Min, 0) AS MaxPerMatchv3_Min,     
	ISNULL(@MaxPerMatchv3_Max, 0) AS MaxPerMatchv3_Max,    

	ISNULL(@MinBetv5_Min, 0) AS MinBetv5_Min,     
	ISNULL(@MaxBetv5_Max, 0) AS MaxBetv5_Max,     
	ISNULL(@MaxPerMatchv5_Min, 0) AS MaxPerMatchv5_Min,     
	ISNULL(@MaxPerMatchv5_Max, 0) AS MaxPerMatchv5_Max,    

	ISNULL(@MinBetv8_Min, 0) AS MinBetv8_Min,     
	ISNULL(@MaxBetv8_Max, 0) AS MaxBetv8_Max,     
	ISNULL(@MaxPerMatchv8_Min, 0) AS MaxPerMatchv8_Min,     
	ISNULL(@MaxPerMatchv8_Max, 0) AS MaxPerMatchv8_Max,    

	ISNULL(@MinBetv10_Min, 0) AS MinBetv10_Min,     
	ISNULL(@MaxBetv10_Max, 0) AS MaxBetv10_Max,     
	ISNULL(@MaxPerMatchv10_Min, 0) AS MaxPerMatchv10_Min,     
	ISNULL(@MaxPerMatchv10_Max, 0) AS MaxPerMatchv10_Max,    

	ISNULL(@MinBetv11_Min, 0) AS MinBetv11_Min,     
	ISNULL(@MaxBetv11_Max, 0) AS MaxBetv11_Max,     
	ISNULL(@MaxPerMatchv11_Min, 0) AS MaxPerMatchv11_Min,     
	ISNULL(@MaxPerMatchv11_Max, 0) AS MaxPerMatchv11_Max,    

	ISNULL(@MinBetv99_Min, 0) AS MinBetv99_Min,     
	ISNULL(@MaxBetv99_Max, 0) AS MaxBetv99_Max,     
	ISNULL(@MaxPerMatchv99_Min, 0) AS MaxPerMatchv99_Min,     
	ISNULL(@MaxPerMatchv99_Max, 0) AS MaxPerMatchv99_Max ,  

	ISNULL(@MinBetv99MP_Min, 0) AS MinBetv99MP_Min,     
	ISNULL(@MaxBetv99MP_Max, 0) AS MaxBetv99MP_Max,     
	ISNULL(@MaxPerMatchv99MP_Min, 0) AS MaxPerMatchv99MP_Min,     
	ISNULL(@MaxPerMatchv99MP_Max, 0) AS MaxPerMatchv99MP_Max ,
	
	ISNULL(@MinBetv154_Min, 0) AS MinBetv154_Min,     
	ISNULL(@MaxBetv154_Max, 0) AS MaxBetv154_Max,     
	ISNULL(@MaxPerMatchv154_Min, 0) AS MaxPerMatchv154_Min,     
	ISNULL(@MaxPerMatchv154_Max, 0) AS MaxPerMatchv154_Max ,

	ISNULL(@MinBetv201_Min, 0) AS MinBetv201_Min,     
	ISNULL(@MaxBetv201_Max, 0) AS MaxBetv201_Max,     
	ISNULL(@MaxPerMatchv201_Min, 0) AS MaxPerMatchv201_Min,     
	ISNULL(@MaxPerMatchv201_Max, 0) AS MaxPerMatchv201_Max,    

	ISNULL(@MinBetv202_1501_Min, 0) AS MinBetv202_1501_Min,     
	ISNULL(@MaxBetv202_1501_Max, 0) AS MaxBetv205_1501_Max,     
	ISNULL(@MaxPerMatchv202_1501_Min, 0) AS MaxPerMatchv202_1501_Min,     
	ISNULL(@MaxPerMatchv202_1501_Max, 0) AS MaxPerMatchv202_1501_Max,  

	ISNULL(@MinBetv151_Min, 0) AS MinBetv151_Min,     
	ISNULL(@MaxBetv151_Max, 0) AS MaxBetv151_Max,     
	ISNULL(@MinBetv151OT_Max, 0) AS MinBetv151OT_Max,     
	ISNULL(@MaxBetv151OT_Min, 0) AS MaxBetv151OT_Min,     
	
	ISNULL(@MinBetv151_51_Min, 0) AS MinBetv151_51_Min,     
	ISNULL(@MaxBetv151_51_Max, 0) AS MaxBetv151_51_Max,     
	ISNULL(@MinBetv152_41_Min, 0) AS MinBetv152_41_Min,     
	ISNULL(@MaxBetv152_41_Max, 0) AS MaxBetv152_41_Max,     
	ISNULL(@MinBetv152_51_Min, 0) AS MinBetv152_51_Min,     
	ISNULL(@MaxBetv152_51_Max, 0) AS MaxBetv152_51_Max,     
	ISNULL(@MinBetv153_51_Min, 0) AS MinBetv153_51_Min,     
	ISNULL(@MaxBetv153_51_Max, 0) AS MaxBetv153_51_Max,     
	

	ISNULL(@MaxPerMatchv151_Min, 0) AS MaxPerMatchv151_Min,     
	ISNULL(@MaxPerMatchv151_Max, 0) AS MaxPerMatchv151_Max,
	ISNULL(@MaxPerMatchv151OT_Min, 0) AS MaxPerMatchv151OT_Min,     
	ISNULL(@MaxPerMatchv151OT_Max, 0) AS MaxPerMatchv151OT_Max,
	
	ISNULL(@MaxPerMatchv151_51_Min, 0) AS MaxPerMatchv151_51_Min,     
	ISNULL(@MaxPerMatchv151_51_Max, 0) AS MaxPerMatchv151_51_Max,
	ISNULL(@MaxPerMatchv152_41_Min, 0) AS MaxPerMatchv152_41_Min,     
	ISNULL(@MaxPerMatchv152_41_Max, 0) AS MaxPerMatchv152_41_Max,
	ISNULL(@MaxPerMatchv152_51_Min, 0) AS MaxPerMatchv152_51_Min,     
	ISNULL(@MaxPerMatchv152_51_Max, 0) AS MaxPerMatchv152_51_Max,
	ISNULL(@MaxPerMatchv153_51_Min, 0) AS MaxPerMatchv153_51_Min,     
	ISNULL(@MaxPerMatchv153_51_Max, 0) AS MaxPerMatchv153_51_Max,
	
	ISNULL(@MaxPerMatchv161_Min, 0) AS MaxPerMatchv161_Min,     
	ISNULL(@MaxPerMatchv161_Max, 0) AS MaxPerMatchv161_Max,
	ISNULL(@MaxPerBallv161_Max, 0)	AS MaxPerBallv161_Max,
	
	ISNULL(@MinBetv180_Max, 0) AS MinBetv180_Min,     
	ISNULL(@MaxBetv180_Min, 0) AS MaxBetv180_Max,     
	ISNULL(@MaxPerMatchv180_Min, 0) AS MaxPerMatchv180_Min,     
	ISNULL(@MaxPerMatchv180_Max, 0) AS MaxPerMatchv180_Max,
	
	ISNULL(@MinBetv181_Max, 0) AS MinBetv181_Min,     
	ISNULL(@MaxBetv181_Min, 0) AS MaxBetv181_Max,     
	ISNULL(@MaxPerMatchv181_Min, 0) AS MaxPerMatchv181_Min,     
	ISNULL(@MaxPerMatchv181_Max, 0) AS MaxPerMatchv181_Max,
	
	ISNULL(@MinBetv182_Max, 0) AS MinBetv182_Min,     
	ISNULL(@MaxBetv182_Min, 0) AS MaxBetv182_Max,     
	ISNULL(@MaxPerMatchv182_Min, 0) AS MaxPerMatchv182_Min,     
	ISNULL(@MaxPerMatchv182_Max, 0) AS MaxPerMatchv182_Max,
	
	ISNULL(@MinBetv184_Max, 0) AS MinBetv184_Min,     
	ISNULL(@MaxBetv184_Min, 0) AS MaxBetv184_Max,     
	ISNULL(@MaxPerMatchv184_Min, 0) AS MaxPerMatchv184_Min,     
	ISNULL(@MaxPerMatchv184_Max, 0) AS MaxPerMatchv184_Max,
	
	ISNULL(@MinBetv186_Max, 0) AS MinBetv186_Min,     
	ISNULL(@MaxBetv186_Min, 0) AS MaxBetv186_Max,     
	ISNULL(@MaxPerMatchv186_Min, 0) AS MaxPerMatchv186_Min,     
	ISNULL(@MaxPerMatchv186_Max, 0) AS MaxPerMatchv186_Max
FROM     
	CustInfo ci WITH (NOLOCK)  
	INNER JOIN Dep_CustSetting cs WITH (NOLOCK) ON ci.custid = cs.custid    
	INNER JOIN Dep_CustSetting3rd cs3rd WITH (NOLOCK) ON ci.custid = cs3rd.custid    
	LEFT JOIN CustGameType cg WITH (NOLOCK) ON ci.custid = cg.custid  
	LEFT JOIN bodb02.dbo.GameType gt WITH (NOLOCK) ON cg.GameTypeID = gt.GameTypeID
WHERE ci.custid=@CustID   
GROUP BY    
	ci.username, 
	ci.maxpermatch,    
	ci.maxpermatch2,    
	ci.maxpermatch3,    
	ci.maxpermatch5,    
	ci.maxpermatch8,    
	ci.maxpermatch10,    
	ci.maxpermatch11,  
	ci.maxpermatch12,     
 	ci.maxpermatch99, 
 	ci.maxpermatch99mp,	
	ci.maxpermatch154,	
	ci.maxpermatch201, 
	ci.maxpermatch151,
	ci.maxpermatch151_OT,
	ci.maxpermatch161,
	ci.maxperball161,
	ci.maxpermatch151_AU,
	ci.maxpermatch152_UK,
	ci.maxpermatch152_AU,
	ci.maxpermatch153_AU,
	ci.maxpermatch180,
	ci.maxpermatch181,
	ci.maxpermatch182,
	ci.maxpermatch184,
	ci.maxpermatch186
	
GO
GRANT EXECUTE ON [dbo].[Dot_Dep_CustomerSelMemBetSetting_Cust] TO [Dot_Admin] AS [dbo]
GO
GRANT EXECUTE ON [dbo].[Dot_Dep_CustomerSelMemBetSetting_Cust] TO [Dot_Member] AS [dbo]
GO
GRANT ALTER ON [dbo].[Dot_Dep_CustomerSelMemBetSetting_Cust] TO [vnteam] AS [dbo]
GO
GRANT VIEW DEFINITION ON [dbo].[Dot_Dep_CustomerSelMemBetSetting_Cust] TO [vnteam] AS [dbo]