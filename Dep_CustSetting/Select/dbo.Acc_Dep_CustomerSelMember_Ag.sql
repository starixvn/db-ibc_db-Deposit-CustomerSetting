USE [CustDB]
GO
/****** Object:  StoredProcedure [dbo].[Acc_Dep_CustomerSelMember_Ag]    Script Date: 06/06/2015 14:20:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[Acc_Dep_CustomerSelMember_Ag]
	@CustID INT
AS

/*
Created: 20120321@Dom
TASk : Agent edit customer
DB: DBCUST.CustDB

Revisions:
	- 20131014@Francis: Support selecting new virtual sports with settings via XML param
	- 20140418@Francis: Fix not returning data of bet setting (when customer does not have 3rd party game) bug
	- 20140505@Florent: add new Sport HRFO
	- 20140512@Florent: Add Sport Keno    
	- 20150603@Kathy: Move SP to DBCust.custDB [Redmine:#36216]
     - 20151028@Jim:Implement Muay's Setting for Deposit Customer [Redmine: #45491]
Param's Explanation:
• @CustID: member ID
• @VirtualSportList: VirtualSport Settings XML param
*/
SET NOCOUNT ON

DECLARE @MinBetv1						MONEY, 
		@MinBetv1_Max					MONEY,
		@MinBetv2						MONEY, 
		@MinBetv2_Max					MONEY,
		@MinBetv3						MONEY,  
		@MinBetv3_Max					MONEY,  
		@MinBetv5						MONEY,  
		@MinBetv5_Max					MONEY,  
		@MinBetv8						MONEY,  
		@MinBetv8_Max					MONEY,  
		@MinBetv10						MONEY,  
		@MinBetv10_Max					MONEY,  
		@MinBetv11						MONEY,  
		@MinBetv11_Max					MONEY,  
		@MinBetv44						MONEY,  
		@MinBetv44_Max					MONEY,  
		@MinBetv99						MONEY,  
		@MinBetv99_Max					MONEY,  
		
		@MinBetv154						MONEY,  
		@MinBetv154_Max					MONEY,

		@MaxBetv1						MONEY,
		@MaxBetv1_Min					MONEY,  
		@MaxBetv2						MONEY,
		@MaxBetv2_Min					MONEY,  
		@MaxBetv3						MONEY,
		@MaxBetv3_Min					MONEY,
		@MaxBetv5						MONEY,
		@MaxBetv5_Min					MONEY,
		@MaxBetv8						MONEY,
		@MaxBetv8_Min					MONEY,
		@MaxBetv10						MONEY,
		@MaxBetv10_Min					MONEY,
		@MaxBetv11						MONEY,
		@MaxBetv11_Min					MONEY,
		@MaxBetv44						MONEY,
		@MaxBetv44_Min					MONEY,
		@MaxBetv99						MONEY,
		@MaxBetv99_Min					MONEY,
		
		@MaxBetv154						MONEY,
		@MaxBetv154_Min					MONEY,
		
		@v151MinBet_31					MONEY,
		@v151MinBet_31_Max				MONEY,
		@v151MinBet_41					MONEY,
		@v151MinBet_41_Max				MONEY,
		@v151MinBet_51					MONEY,
		@v151MinBet_51_Max				MONEY,
		@v152MinBet_41					MONEY,
		@v152MinBet_41_Max				MONEY,
		@v152MinBet_51					MONEY,
		@v152MinBet_51_Max				MONEY,
		@v153MinBet_51					MONEY,
		@v153MinBet_51_Max				MONEY,

		@v151MaxBet_31					MONEY,
		@v151MaxBet_31_Min				MONEY,
		@v151MaxBet_41					MONEY,
		@v151MaxBet_41_Min				MONEY,
		@v151MaxBet_51					MONEY,
		@v151MaxBet_51_Min				MONEY,
		@v152MaxBet_41					MONEY,
		@v152MaxBet_41_Min				MONEY,
		@v152MaxBet_51					MONEY,
		@v152MaxBet_51_Min				MONEY,
		@v153MaxBet_51					MONEY,
		@v153MaxBet_51_Min				MONEY,

		@MinBetv161						MONEY,
		@MinBetv161_Max					MONEY,
		@MaxBetv161						MONEY,
		@MaxBetv161_Min					MONEY,

		@MinBetv99MP					MONEY,
		@MinBetv99MP_Max				MONEY,
		@MaxBetv99MP					MONEY,
		@MaxBetv99MP_Min				MONEY,
		
		@MaxPerMatchv1_Min  MONEY,
		@MaxPerMatchv2_Min  MONEY,
		@MaxPerMatchv3_Min  MONEY,
		@MaxPerMatchv5_Min  MONEY,
		@MaxPerMatchv8_Min  MONEY,
		@MaxPerMatchv10_Min  MONEY,
		@MaxPerMatchv11_Min  MONEY,
		@MaxPerMatchv44_Min  MONEY,
		@MaxPerMatchv99_Min  MONEY,
		@MaxPerMatchv154_Min  MONEY,
		@MaxPerMatchv99MP_Min  MONEY,
		@MaxPerMatchv161_Min  MONEY,
		
		@MaxPerMatchv1					MONEY,
		@MaxPerMatchv1_Max				MONEY,
		@MaxPerMatchv2					MONEY,
		@MaxPerMatchv2_Max				MONEY,
		@MaxPerMatchv3					MONEY,
		@MaxPerMatchv3_Max				MONEY,
		@MaxPerMatchv5					MONEY,
		@MaxPerMatchv5_Max				MONEY,
		@MaxPerMatchv8					MONEY,
		@MaxPerMatchv8_Max				MONEY,
		@MaxPerMatchv10					MONEY,
		@MaxPerMatchv10_Max				MONEY,
		@MaxPerMatchv11					MONEY,
		@MaxPerMatchv11_Max				MONEY,	
		@MaxPerMatchv44					MONEY,
		@MaxPerMatchv44_Max				MONEY,
		
		@MaxPerMatchv99					MONEY,
		@MaxPerMatchv99_Max				MONEY,
		@MaxPerMatchv154					MONEY,
		@MaxPerMatchv154_Max				MONEY,

		@MaxPerMatchv99MP				MONEY,
		@MaxPerMatchv99MP_Max			MONEY,
		@MaxPerMatchv161				MONEY,	
		@MaxPerMatchv161_Max			MONEY,	
		@MaxPerBallv161					MONEY,
		@MaxPerBallv161_Max				MONEY,
		
				
		@v151MaxPerMatch_31_Max			MONEY,
		@v151MaxPerMatch_41_Max			MONEY,
		@v151MaxPerMatch_51_Max			MONEY,
		@v152MaxPerMatch_41_Max			MONEY,
		@v152MaxPerMatch_51_Max			MONEY,
		@v153MaxPerMatch_51_Max			MONEY,

		@v151MaxPerMatch_31				MONEY,
		@v151MaxPerMatch_41				MONEY,
		@v151MaxPerMatch_51				MONEY,
		@v152MaxPerMatch_41				MONEY,
		@v152MaxPerMatch_51				MONEY,
		@v153MaxPerMatch_51				MONEY,

		@v151Discount_31				DECIMAL(9,8),
		@v151Discount_31_Max			DECIMAL(9,8),
		@v151Discount_41				DECIMAL(9,8),
		@v151Discount_41_Max			DECIMAL(9,8),
		@v151Discount_51				DECIMAL(9,8),
		@v151Discount_51_Max			DECIMAL(9,8),
		@v152Discount_41				DECIMAL(9,8),
		@v152Discount_41_Max			DECIMAL(9,8),
		@v152Discount_51				DECIMAL(9,8),
		@v152Discount_51_Max			DECIMAL(9,8),
		@v153Discount_51				DECIMAL(9,8),
		@v153Discount_51_Max			DECIMAL(9,8),

		@v1aPositionTaking_1				MONEY,
		@v1aPositionTaking_1_Max			MONEY,
		@v161aPositionTaking_81				MONEY,
		@v161aPositionTaking_81_Max			MONEY,

		@v151aPositionTaking_31			MONEY,
		@v151aPositionTaking_41			MONEY,
		@v151aPositionTaking_51			MONEY,
		@v152aPositionTaking_41			MONEY,
		@v152aPositionTaking_51			MONEY,
		@v153aPositionTaking_51			MONEY,

		@v151aPositionTaking_31_Max MONEY,
		@v151aPositionTaking_41_Max MONEY,
		@v151aPositionTaking_51_Max MONEY,
		@v152aPositionTaking_41_Max MONEY,
		@v152aPositionTaking_51_Max MONEY,
		@v153aPositionTaking_51_Max MONEY,
		
		
		
		
		--Virtual Sports-----------------
		@VirtualSportList VARCHAR(4000), -- replace all old params
		
		@MinBetv180 MONEY,
		@MaxBetv180 MONEY,
		@v180aPositionTaking_1201 SMALLMONEY,
		@minbetv180_max money,
		@maxbetv180_min money,
		@v180aPositionTaking_1201_Max smallmoney,
		@maxpermatchv180 MONEY,
		@maxpermatchv180_max MONEY,
		@MaxPerMatchv180_Min MONEY,
		
		@MinBetv181 MONEY,
		@MaxBetv181 MONEY,
		@minbetv181_max money,
		@maxbetv181_min money,
		@maxpermatchv181 MONEY,
		@maxpermatchv181_max MONEY,
		@MaxPerMatchv181_Min MONEY,
		
		@MinBetv182 MONEY,
		@MaxBetv182 MONEY,
		@minbetv182_max money,
		@maxbetv182_min money,
		@maxpermatchv182 MONEY,
		@maxpermatchv182_max MONEY,
		@MaxPerMatchv182_Min MONEY,
		
		@MinBetv183 MONEY,
		@MaxBetv183 MONEY,
		@minbetv183_max money,
		@maxbetv183_min money,
		@maxpermatchv183 MONEY,
		@maxpermatchv183_max MONEY,
		@MaxPerMatchv183_Min MONEY,
		
		@MinBetv184 MONEY,
		@MaxBetv184 MONEY,
		@minbetv184_max money,
		@maxbetv184_min money,
		@maxpermatchv184 MONEY,
		@maxpermatchv184_max MONEY,
		@MaxPerMatchv184_Min MONEY,
		
		@MinBetv185 MONEY,
		@MaxBetv185 MONEY,
		@minbetv185_max money,
		@maxbetv185_min money,
		@maxpermatchv185 MONEY,
		@maxpermatchv185_max MONEY,
		@MaxPerMatchv185_Min MONEY,
		
		@MinBetv186 MONEY,
		@MaxBetv186 MONEY,
		@minbetv186_max money,
		@maxbetv186_min money,
		@maxpermatchv186 MONEY,
		@maxpermatchv186_max MONEY,
		@MaxPerMatchv186_Min MONEY,

		--Keno
		@KenoList VARCHAR(4000)='', -- repalace all old params
		@vPT SMALLMONEY,
		@vPT_Max SMALLMONEY,	
		
		@recommend				INT,
		@UserName				VARCHAR(50)
		
SELECT @recommend = recommend, @UserName = username FROM custinfo AS ci WITH (NOLOCK) where custid = @CustID

SELECT  @MinBetv1 = max(CASE WHEN cs.bettype = 1 AND cs.sporttype = 1 THEN cs.minbet ELSE 0 END) , 
		@MaxBetv1 = max(CASE WHEN cs.bettype = 1 AND cs.sporttype = 1 THEN cs.maxbet ELSE 0 END),
		@v1aPositionTaking_1 = max(CASE WHEN cs.bettype = 1 AND cs.sporttype = 1 THEN cs.apositiontaking ELSE 0 END),

		@MinBetv2 = max(CASE WHEN cs.bettype = 1 AND cs.sporttype = 2 THEN cs.minbet ELSE 0 END),
		@MaxBetv2 = max(CASE WHEN cs.bettype = 1 AND cs.sporttype = 2 THEN cs.maxbet ELSE 0 END),

		@MinBetv3 = max(CASE WHEN cs.bettype = 1 AND cs.sporttype = 3 THEN cs.minbet ELSE 0 END),
		@MaxBetv3 = max(CASE WHEN cs.bettype = 1 AND cs.sporttype = 3 THEN cs.maxbet ELSE 0 END),

		@MinBetv5 = max(CASE WHEN cs.bettype = 1 AND cs.sporttype = 5 THEN cs.minbet ELSE 0 END),
		@MaxBetv5 = max(CASE WHEN cs.bettype = 1 AND cs.sporttype = 5 THEN cs.maxbet ELSE 0 END),
		
		@MinBetv8 = max(CASE WHEN cs.bettype = 1 AND cs.sporttype = 8 THEN cs.minbet ELSE 0 END),
		@MaxBetv8 = max(CASE WHEN cs.bettype = 1 AND cs.sporttype = 8 THEN cs.maxbet ELSE 0 END),

		@MinBetv10 = max(CASE WHEN cs.bettype = 1 AND cs.sporttype = 10 THEN cs.minbet ELSE 0 END),
		@MaxBetv10 = max(CASE WHEN cs.bettype = 1 AND cs.sporttype = 10 THEN cs.maxbet ELSE 0 END),

		@MinBetv11 = max(CASE WHEN cs.bettype = 1 AND cs.sporttype = 11 THEN cs.minbet ELSE 0 END),
		@MaxBetv11 = max(CASE WHEN cs.bettype = 1 AND cs.sporttype = 11 THEN cs.maxbet ELSE 0 END),
		
		@MinBetv44 = max(CASE WHEN cs.bettype = 3 AND cs.sporttype = 44 THEN cs.minbet ELSE 0 END),
		@MaxBetv44 = max(CASE WHEN cs.bettype = 3 AND cs.sporttype = 44 THEN cs.maxbet ELSE 0 END),
		
		@MinBetv99 = max(CASE WHEN cs.bettype = 1 AND cs.sporttype = 99 THEN cs.minbet ELSE 0 END),
		@MaxBetv99 = max(CASE WHEN cs.bettype = 1 AND cs.sporttype = 99 THEN cs.maxbet ELSE 0 END),

		@MinBetv154 = max(CASE WHEN cs.bettype = 20 AND cs.sporttype = 154 THEN cs.minbet ELSE 0 END),
		@MaxBetv154 = max(CASE WHEN cs.bettype = 20 AND cs.sporttype = 154 THEN cs.maxbet ELSE 0 END),

		@MinBetv99MP = max(CASE WHEN cs.bettype = 9 AND cs.sporttype = 99 THEN cs.minbet ELSE 0 END),
		@MaxBetv99MP = max(CASE WHEN cs.bettype = 9 AND cs.sporttype = 99 THEN cs.maxbet ELSE 0 END),

		@MinBetv161 = max(CASE WHEN cs3rd.bettype = 81 AND cs3rd.sporttype = 161 THEN cs3rd.minbet ELSE 0 END),
		@MaxBetv161 = max(CASE WHEN cs3rd.bettype = 81 AND cs3rd.sporttype = 161 THEN cs3rd.maxbet ELSE 0 END),
		@v161aPositionTaking_81 = max(CASE WHEN cs3rd.bettype = 81 AND cs3rd.sporttype = 161 THEN cs3rd.apositiontaking ELSE 0 END),
		
		
		--Virtual Sports
		@MinBetv180 = max(CASE WHEN cs3rd.bettype = 1201 AND cs3rd.sporttype = 180 THEN cs3rd.minbet ELSE 0 END),
		@MaxBetv180 = max(CASE WHEN cs3rd.bettype = 1201 AND cs3rd.sporttype = 180 THEN cs3rd.maxbet ELSE 0 END),
		@v180aPositionTaking_1201 = max(CASE WHEN cs3rd.bettype = 1201 AND cs3rd.sporttype = 180 THEN cs3rd.apositiontaking ELSE 0 END),

		@MinBetv181 = max(CASE WHEN cs3rd.bettype = 1231 AND cs3rd.sporttype = 181 THEN cs3rd.minbet ELSE 0 END),
		@MaxBetv181 = max(CASE WHEN cs3rd.bettype = 1231 AND cs3rd.sporttype = 181 THEN cs3rd.maxbet ELSE 0 END),
		
		@MinBetv182 = max(CASE WHEN cs3rd.bettype = 1231 AND cs3rd.sporttype = 182 THEN cs3rd.minbet ELSE 0 END),
		@MaxBetv182 = max(CASE WHEN cs3rd.bettype = 1231 AND cs3rd.sporttype = 182 THEN cs3rd.maxbet ELSE 0 END),
		
		@MinBetv183 = max(CASE WHEN cs3rd.bettype = 1231 AND cs3rd.sporttype = 183 THEN cs3rd.minbet ELSE 0 END),
		@MaxBetv183 = max(CASE WHEN cs3rd.bettype = 1231 AND cs3rd.sporttype = 183 THEN cs3rd.maxbet ELSE 0 END),
		
		@MinBetv184 = max(CASE WHEN cs3rd.bettype = 1231 AND cs3rd.sporttype = 184 THEN cs3rd.minbet ELSE 0 END),
		@MaxBetv184 = max(CASE WHEN cs3rd.bettype = 1231 AND cs3rd.sporttype = 184 THEN cs3rd.maxbet ELSE 0 END),
		
		@MinBetv185 = max(CASE WHEN cs3rd.bettype = 1231 AND cs3rd.sporttype = 185 THEN cs3rd.minbet ELSE 0 END),
		@MaxBetv185 = max(CASE WHEN cs3rd.bettype = 1231 AND cs3rd.sporttype = 185 THEN cs3rd.maxbet ELSE 0 END),
		
		@MinBetv186 = max(CASE WHEN cs3rd.bettype = 1220 AND cs3rd.sporttype = 186 THEN cs3rd.minbet ELSE 0 END),
		@MaxBetv186 = max(CASE WHEN cs3rd.bettype = 1220 AND cs3rd.sporttype = 186 THEN cs3rd.maxbet ELSE 0 END),
		

		@v151MinBet_31 = max(CASE WHEN cs3rd.bettype = 31 AND cs3rd.sporttype = 151 THEN cs3rd.minbet ELSE 0 END),
		@v151MaxBet_31 = max(CASE WHEN cs3rd.bettype = 31 AND cs3rd.sporttype = 151 THEN cs3rd.maxbet ELSE 0 END),
		@v151aPositionTaking_31 = max(CASE WHEN cs3rd.bettype = 31 AND cs3rd.sporttype = 151 THEN cs3rd.apositiontaking ELSE 0 END),

		@v151MinBet_41 = max(CASE WHEN cs3rd.bettype = 41 AND cs3rd.sporttype = 151 THEN cs3rd.minbet ELSE 0 END),
		@v151MaxBet_41 = max(CASE WHEN cs3rd.bettype = 41 AND cs3rd.sporttype = 151 THEN cs3rd.maxbet ELSE 0 END),
		@v151aPositionTaking_41 = max(CASE WHEN cs3rd.bettype = 41 AND cs3rd.sporttype = 151 THEN cs3rd.apositiontaking ELSE 0 END),

		@v151MinBet_51 = max(CASE WHEN cs3rd.bettype = 51 AND cs3rd.sporttype = 151 THEN cs3rd.minbet ELSE 0 END),
		@v151MaxBet_51 = max(CASE WHEN cs3rd.bettype = 51 AND cs3rd.sporttype = 151 THEN cs3rd.maxbet ELSE 0 END),
		@v151aPositionTaking_51 = max(CASE WHEN cs3rd.bettype = 51 AND cs3rd.sporttype = 151 THEN cs3rd.apositiontaking ELSE 0 END),

		@v152MinBet_41 = max(CASE WHEN cs3rd.bettype = 41 AND cs3rd.sporttype = 152 THEN cs3rd.minbet ELSE 0 END),
		@v152MaxBet_41 = max(CASE WHEN cs3rd.bettype = 41 AND cs3rd.sporttype = 152 THEN cs3rd.maxbet ELSE 0 END),
		@v152aPositionTaking_41 = max(CASE WHEN cs3rd.bettype = 41 AND cs3rd.sporttype = 152 THEN cs3rd.apositiontaking ELSE 0 END),

		@v152MinBet_51 = max(CASE WHEN cs3rd.bettype = 51 AND cs3rd.sporttype = 152 THEN cs3rd.minbet ELSE 0 END),
		@v152MaxBet_51 = max(CASE WHEN cs3rd.bettype = 51 AND cs3rd.sporttype = 152 THEN cs3rd.maxbet ELSE 0 END),
		@v152aPositionTaking_51 = max(CASE WHEN cs3rd.bettype = 51 AND cs3rd.sporttype = 152 THEN cs3rd.apositiontaking ELSE 0 END),

		@v153MinBet_51 = max(CASE WHEN cs3rd.bettype = 51 AND cs3rd.sporttype = 153 THEN cs3rd.minbet ELSE 0 END),
		@v153MaxBet_51 = max(CASE WHEN cs3rd.bettype = 51 AND cs3rd.sporttype = 153 THEN cs3rd.maxbet ELSE 0 END),
		@v153aPositionTaking_51 = max(CASE WHEN cs3rd.bettype = 51 AND cs3rd.sporttype = 153 THEN cs3rd.apositiontaking ELSE 0 END),
		
		--HR Comm
		@v151Discount_31 = max(CASE WHEN cs3rd.bettype = 31 AND cs3rd.sporttype = 151 THEN cs3rd.playerdiscount ELSE 0 END),
		@v151Discount_41 = max(CASE WHEN cs3rd.bettype = 41 AND cs3rd.sporttype = 151 THEN cs3rd.playerdiscount ELSE 0 END),
		@v151Discount_51 = max(CASE WHEN cs3rd.bettype = 51 AND cs3rd.sporttype = 151 THEN cs3rd.playerdiscount ELSE 0 END),

		@v152Discount_41 = max(CASE WHEN cs3rd.bettype = 41 AND cs3rd.sporttype = 152 THEN cs3rd.playerdiscount ELSE 0 END),
		@v152Discount_51 = max(CASE WHEN cs3rd.bettype = 51 AND cs3rd.sporttype = 152 THEN cs3rd.playerdiscount ELSE 0 END),

		@v153Discount_51 = max(CASE WHEN cs3rd.bettype = 51 AND cs3rd.sporttype = 153 THEN cs3rd.playerdiscount ELSE 0 END)

FROM Dep_CustSetting AS cs WITH (NOLOCK) 
	LEFT JOIN Dep_CustSetting3rd AS cs3rd WITH (NOLOCK) ON cs.custid = cs3rd.custid
WHERE cs.custid = @CustID

--- MIN and MAX setting
SELECT  @MinBetv1_Max = max(case when MinBet = 0 then NULL else MinBet end),
		@MaxBetv1_Min = min(case when MaxBet = 0 then NULL else MaxBet end)
FROM 
	dep_custsetting AS cs WITH (NOLOCK)
	INNER JOIN custinfo AS ci WITH (NOLOCK) ON (cs.CustID = ci.MRecommend OR cs.CustID = ci.SRecommend OR cs.CustID = ci.Recommend) AND cs.bettype = 1 AND cs.sporttype=1
WHERE ci.custid = @CustID
		
SELECT	@MinBetv2_Max = max(case when MinBet = 0 then NULL else MinBet end),
		@MaxBetv2_Min = min(case when MaxBet = 0 then NULL else MaxBet end)
FROM 
	dep_custsetting AS cs WITH (NOLOCK)
	INNER JOIN custinfo AS ci WITH (NOLOCK) ON (cs.CustID = ci.MRecommend OR cs.CustID = ci.SRecommend OR cs.CustID = ci.Recommend) AND cs.bettype = 1 AND cs.sporttype=2
WHERE ci.custid = @CustID		

SELECT	@MinBetv3_Max = max(case when MinBet = 0 then NULL else MinBet end),
		@MaxBetv3_Min = min(case when MaxBet = 0 then NULL else MaxBet end)
FROM 
	dep_custsetting AS cs WITH (NOLOCK)
	INNER JOIN custinfo AS ci WITH (NOLOCK) ON (cs.CustID = ci.MRecommend OR cs.CustID = ci.SRecommend OR cs.CustID = ci.Recommend) AND cs.bettype = 1 AND cs.sporttype=3
WHERE ci.custid = @CustID		

		
SELECT	@MinBetv5_Max = max(case when MinBet = 0 then NULL else MinBet end),
		@MaxBetv5_Min = min(case when MaxBet = 0 then NULL else MaxBet end)
FROM 
	dep_custsetting AS cs WITH (NOLOCK)
	INNER JOIN custinfo AS ci WITH (NOLOCK) ON (cs.CustID = ci.MRecommend OR cs.CustID = ci.SRecommend OR cs.CustID = ci.Recommend) AND cs.bettype = 1 AND cs.sporttype=5
WHERE ci.custid = @CustID		
		
SELECT	@MinBetv8_Max = max(case when MinBet = 0 then NULL else MinBet end),
		@MaxBetv8_Min = min(case when MaxBet = 0 then NULL else MaxBet end)
FROM 
	dep_custsetting AS cs WITH (NOLOCK)
	INNER JOIN custinfo AS ci WITH (NOLOCK) ON (cs.CustID = ci.MRecommend OR cs.CustID = ci.SRecommend OR cs.CustID = ci.Recommend) AND cs.bettype = 1 AND cs.sporttype=8
WHERE ci.custid = @CustID

SELECT	@MinBetv10_Max = max(case when MinBet = 0 then NULL else MinBet end),
		@MaxBetv10_Min = min(case when MaxBet = 0 then NULL else MaxBet end)
FROM 
	dep_custsetting AS cs WITH (NOLOCK)
	INNER JOIN custinfo AS ci WITH (NOLOCK) ON (cs.CustID = ci.MRecommend OR cs.CustID = ci.SRecommend OR cs.CustID = ci.Recommend) AND cs.bettype = 1 AND cs.sporttype=10
WHERE ci.custid = @CustID		

SELECT	@MinBetv11_Max = max(case when MinBet = 0 then NULL else MinBet end),
		@MaxBetv11_Min = min(case when MaxBet = 0 then NULL else MaxBet end)
FROM 
	dep_custsetting AS cs WITH (NOLOCK)
	INNER JOIN custinfo AS ci WITH (NOLOCK) ON (cs.CustID = ci.MRecommend OR cs.CustID = ci.SRecommend OR cs.CustID = ci.Recommend) AND cs.bettype = 1 AND cs.sporttype=11
WHERE ci.custid = @CustID		
---
SELECT	@MinBetv44_Max = max(case when MinBet = 0 then NULL else MinBet end),
		@MaxBetv44_Min = min(case when MaxBet = 0 then NULL else MaxBet end)
FROM 
	dep_custsetting AS cs WITH (NOLOCK)
	INNER JOIN custinfo AS ci WITH (NOLOCK) ON (cs.CustID = ci.MRecommend OR cs.CustID = ci.SRecommend OR cs.CustID = ci.Recommend) AND cs.bettype = 3 AND cs.sporttype=44
WHERE ci.custid = @CustID	
--
SELECT	@MinBetv99_Max = max(case when MinBet = 0 then NULL else MinBet end),
		@MaxBetv99_Min = min(case when MaxBet = 0 then NULL else MaxBet end)
FROM 
	dep_custsetting AS cs WITH (NOLOCK)
	INNER JOIN custinfo AS ci WITH (NOLOCK) ON (cs.CustID = ci.MRecommend OR cs.CustID = ci.SRecommend OR cs.CustID = ci.Recommend) AND cs.bettype = 1 AND cs.sporttype=99
WHERE ci.custid = @CustID	

SELECT	@MinBetv154_Max = max(case when MinBet = 0 then NULL else MinBet end),
		@MaxBetv154_Min = min(case when MaxBet = 0 then NULL else MaxBet end)
FROM 
	dep_custsetting AS cs WITH (NOLOCK)
	INNER JOIN custinfo AS ci WITH (NOLOCK) ON (cs.CustID = ci.MRecommend OR cs.CustID = ci.SRecommend OR cs.CustID = ci.Recommend) AND cs.bettype = 20 AND cs.sporttype=154
WHERE ci.custid = @CustID	

SELECT	@MinBetv99MP_Max = max(case when MinBet = 0 then NULL else MinBet end),
		@MaxBetv99MP_Min = min(case when MaxBet = 0 then NULL else MaxBet end)
FROM 
	dep_custsetting AS cs WITH (NOLOCK)
	INNER JOIN custinfo AS ci WITH (NOLOCK) ON (cs.CustID = ci.MRecommend OR cs.CustID = ci.SRecommend OR cs.CustID = ci.Recommend) AND cs.bettype = 9 AND cs.sporttype=99
WHERE ci.custid = @CustID		

SELECT	@MinBetv161_Max = max(case when MinBet = 0 then NULL else MinBet end),
		@MaxBetv161_Min = min(case when MaxBet = 0 then NULL else MaxBet end)
FROM 
	dep_custsetting3rd AS cs WITH (NOLOCK)
	INNER JOIN custinfo AS ci WITH (NOLOCK) ON (cs.CustID = ci.MRecommend OR cs.CustID = ci.SRecommend OR cs.CustID = ci.Recommend) AND cs.bettype = 81 AND cs.sporttype=161
WHERE ci.custid = @CustID

--Virtual Sports
SELECT	@MinBetv180_Max = max(case when MinBet = 0 then NULL else MinBet end),
		@MaxBetv180_Min = min(case when MaxBet = 0 then NULL else MaxBet end)
FROM 
	dep_custsetting3rd AS cs WITH (NOLOCK)
	INNER JOIN custinfo AS ci WITH (NOLOCK) ON (cs.CustID = ci.MRecommend OR cs.CustID = ci.SRecommend OR cs.CustID = ci.Recommend) AND cs.bettype = 1201 AND cs.sporttype=180
WHERE ci.custid = @CustID

SELECT	@MinBetv181_Max = max(case when MinBet = 0 then NULL else MinBet end),
		@MaxBetv181_Min = min(case when MaxBet = 0 then NULL else MaxBet end)
FROM 
	dep_custsetting3rd AS cs WITH (NOLOCK)
	INNER JOIN custinfo AS ci WITH (NOLOCK) ON (cs.CustID = ci.MRecommend OR cs.CustID = ci.SRecommend OR cs.CustID = ci.Recommend) AND cs.bettype = 1231 AND cs.sporttype=181
WHERE ci.custid = @CustID

SELECT	@MinBetv182_Max = max(case when MinBet = 0 then NULL else MinBet end),
		@MaxBetv182_Min = min(case when MaxBet = 0 then NULL else MaxBet end)
FROM 
	dep_custsetting3rd AS cs WITH (NOLOCK)
	INNER JOIN custinfo AS ci WITH (NOLOCK) ON (cs.CustID = ci.MRecommend OR cs.CustID = ci.SRecommend OR cs.CustID = ci.Recommend) AND cs.bettype = 1231 AND cs.sporttype=182
WHERE ci.custid = @CustID

SELECT	@MinBetv183_Max = max(case when MinBet = 0 then NULL else MinBet end),
		@MaxBetv183_Min = min(case when MaxBet = 0 then NULL else MaxBet end)
FROM 
	dep_custsetting3rd AS cs WITH (NOLOCK)
	INNER JOIN custinfo AS ci WITH (NOLOCK) ON (cs.CustID = ci.MRecommend OR cs.CustID = ci.SRecommend OR cs.CustID = ci.Recommend) AND cs.bettype = 1231 AND cs.sporttype=183
WHERE ci.custid = @CustID

SELECT	@MinBetv184_Max = max(case when MinBet = 0 then NULL else MinBet end),
		@MaxBetv184_Min = min(case when MaxBet = 0 then NULL else MaxBet end)
FROM 
	dep_custsetting3rd AS cs WITH (NOLOCK)
	INNER JOIN custinfo AS ci WITH (NOLOCK) ON (cs.CustID = ci.MRecommend OR cs.CustID = ci.SRecommend OR cs.CustID = ci.Recommend) AND cs.bettype = 1231 AND cs.sporttype=184
WHERE ci.custid = @CustID

SELECT	@MinBetv185_Max = max(case when MinBet = 0 then NULL else MinBet end),
		@MaxBetv185_Min = min(case when MaxBet = 0 then NULL else MaxBet end)
FROM 
	dep_custsetting3rd AS cs WITH (NOLOCK)
	INNER JOIN custinfo AS ci WITH (NOLOCK) ON (cs.CustID = ci.MRecommend OR cs.CustID = ci.SRecommend OR cs.CustID = ci.Recommend) AND cs.bettype = 1231 AND cs.sporttype=185
WHERE ci.custid = @CustID

SELECT	@MinBetv186_Max = max(case when MinBet = 0 then NULL else MinBet end),
		@MaxBetv186_Min = min(case when MaxBet = 0 then NULL else MaxBet end)
FROM 
	dep_custsetting3rd AS cs WITH (NOLOCK)
	INNER JOIN custinfo AS ci WITH (NOLOCK) ON (cs.CustID = ci.MRecommend OR cs.CustID = ci.SRecommend OR cs.CustID = ci.Recommend) AND cs.bettype = 1220 AND cs.sporttype=186
WHERE ci.custid = @CustID



SELECT	@v151MinBet_31_Max = max(case when MinBet = 0 then NULL else MinBet end),
		@v151MaxBet_31_Min = min(case when MaxBet = 0 then NULL else MaxBet end)
FROM 
	dep_custsetting3rd AS cs WITH (NOLOCK)
	INNER JOIN custinfo AS ci WITH (NOLOCK) ON (cs.CustID = ci.MRecommend OR cs.CustID = ci.SRecommend OR cs.CustID = ci.Recommend) AND cs.bettype = 31 AND cs.sporttype=151
WHERE ci.custid = @CustID

SELECT	@v151MinBet_41_Max = max(case when MinBet = 0 then NULL else MinBet end),
		@v151MaxBet_41_Min = min(case when MaxBet = 0 then NULL else MaxBet end)
FROM 
	dep_custsetting3rd AS cs WITH (NOLOCK)
	INNER JOIN custinfo AS ci WITH (NOLOCK) ON (cs.CustID = ci.MRecommend OR cs.CustID = ci.SRecommend OR cs.CustID = ci.Recommend) AND cs.bettype = 41 AND cs.sporttype=151
WHERE ci.custid = @CustID

SELECT	@v151MinBet_51_Max = max(case when MinBet = 0 then NULL else MinBet end),
		@v151MaxBet_51_Min = min(case when MaxBet = 0 then NULL else MaxBet end)
FROM 
	dep_custsetting3rd AS cs WITH (NOLOCK)
	INNER JOIN custinfo AS ci WITH (NOLOCK) ON (cs.CustID = ci.MRecommend OR cs.CustID = ci.SRecommend OR cs.CustID = ci.Recommend) AND cs.bettype = 51 AND cs.sporttype=151
WHERE ci.custid = @CustID

SELECT	@v152MinBet_41_Max = max(case when MinBet = 0 then NULL else MinBet end),
		@v152MaxBet_41_Min = min(case when MaxBet = 0 then NULL else MaxBet end)
FROM 
	dep_custsetting3rd AS cs WITH (NOLOCK)
	INNER JOIN custinfo AS ci WITH (NOLOCK) ON (cs.CustID = ci.MRecommend OR cs.CustID = ci.SRecommend OR cs.CustID = ci.Recommend) AND cs.bettype = 41 AND cs.sporttype=152
WHERE ci.custid = @CustID

SELECT	@v152MinBet_51_Max = max(case when MinBet = 0 then NULL else MinBet end),
		@v152MaxBet_51_Min = min(case when MaxBet = 0 then NULL else MaxBet end)
FROM 
	dep_custsetting3rd AS cs WITH (NOLOCK)
	INNER JOIN custinfo AS ci WITH (NOLOCK) ON (cs.CustID = ci.MRecommend OR cs.CustID = ci.SRecommend OR cs.CustID = ci.Recommend) AND cs.bettype = 51 AND cs.sporttype=152
WHERE ci.custid = @CustID

SELECT	@v153MinBet_51_Max = max(case when MinBet = 0 then NULL else MinBet end),
		@v153MaxBet_51_Min = min(case when MaxBet = 0 then NULL else MaxBet end)
FROM 
	dep_custsetting3rd AS cs WITH (NOLOCK)
	INNER JOIN custinfo AS ci WITH (NOLOCK) ON (cs.CustID = ci.MRecommend OR cs.CustID = ci.SRecommend OR cs.CustID = ci.Recommend) AND cs.bettype = 51 AND cs.sporttype=153
WHERE ci.custid = @CustID

Select	
	@MaxPerMatchv1_Min = 0,
	@MaxPerMatchv2_Min = 0,
	@MaxPerMatchv3_Min = 0,
	@MaxPerMatchv5_Min = 0,
	@MaxPerMatchv8_Min = 0,
	@MaxPerMatchv10_Min = 0,
	@MaxPerMatchv11_Min = 0,
	@MaxPerMatchv44_Min = 0, 
	@MaxPerMatchv99_Min = 0,
	@MaxPerMatchv154_Min = 0,
	@MaxPerMatchv99MP_Min = 0,
	@MaxPerMatchv161_Min = 0,
	
	
	@MaxPerMatchv180_Min = 0,
	@MaxPerMatchv181_Min = 0,
	@MaxPerMatchv182_Min = 0,
	@MaxPerMatchv183_Min = 0,
	@MaxPerMatchv184_Min = 0,
	@MaxPerMatchv185_Min = 0,
	@MaxPerMatchv186_Min = 0,
	
	@MaxPerMatchv1_Max = Min(case when cs.MaxPerMatch = 0 then NULL else cs.MaxPerMatch end), 
	@MaxPerMatchv2_Max = Min(case when cs.MaxPerMatch2 = 0 then NULL else cs.MaxPerMatch2 end),
	@MaxPerMatchv3_Max = Min(case when cs.MaxPerMatch3 = 0 then NULL else cs.MaxPerMatch3 end),
	@MaxPerMatchv5_Max = Min(case when cs.MaxPerMatch5 = 0 then NULL else cs.MaxPerMatch5 end),
	@MaxPerMatchv8_Max = Min(case when cs.MaxPerMatch8 = 0 then NULL else cs.MaxPerMatch8 end),
	@MaxPerMatchv10_Max = Min(case when cs.MaxPerMatch10 = 0 then NULL else cs.MaxPerMatch10 end),
	@MaxPerMatchv11_Max = Min(case when cs.MaxPerMatch11 = 0 then NULL else cs.MaxPerMatch11 end),	
	@MaxPerMatchv44_Max = Min(case when cs.MaxPerMatch44 = 0 then NULL else cs.MaxPerMatch44 end),
	@MaxPerMatchv99_Max = Min(case when cs.MaxPerMatch99 = 0 then NULL else cs.MaxPerMatch99 end),
	@MaxPerMatchv154_Max = Min(case when cs.MaxPerMatch154 = 0 then NULL else cs.MaxPerMatch154 end),
	@MaxPerMatchv99MP_Max = Min(case when cs.MaxPerMatch99MP = 0 then NULL else cs.MaxPerMatch99MP end),
	@MaxPerMatchv161_Max = Min(case when cs.MaxPerMatch161 = 0 then NULL else cs.MaxPerMatch161 end),
	@MaxPerBallv161_Max = Min(case when cs.MaxPerBall161 = 0 then NULL else cs.MaxPerBall161 end),
	
	
	@MaxPerMatchv180_Max = Min(case when cs.MaxPerMatch180 = 0 then NULL else cs.MaxPerMatch180 end),
	@MaxPerMatchv181_Max = Min(case when cs.MaxPerMatch181 = 0 then NULL else cs.MaxPerMatch181 end),
	@MaxPerMatchv182_Max = Min(case when cs.MaxPerMatch182 = 0 then NULL else cs.MaxPerMatch182 end),
	@MaxPerMatchv183_Max = Min(case when cs.MaxPerMatch183 = 0 then NULL else cs.MaxPerMatch183 end),
	@MaxPerMatchv184_Max = Min(case when cs.MaxPerMatch184 = 0 then NULL else cs.MaxPerMatch184 end),
	@MaxPerMatchv185_Max = Min(case when cs.MaxPerMatch185 = 0 then NULL else cs.MaxPerMatch185 end),
	@MaxPerMatchv186_Max = Min(case when cs.MaxPerMatch186 = 0 then NULL else cs.MaxPerMatch186 end),
	@v151MaxPerMatch_31_Max	= Min(case when cs.maxpermatch151 = 0 then NULL else cs.maxpermatch151 end),
	@v151MaxPerMatch_41_Max	= Min(case when cs.maxpermatch151_OT = 0 then NULL else cs.maxpermatch151_OT end),
	@v151MaxPerMatch_51_Max	= Min(case when cs.MaxPerMatch151_AU = 0 then NULL else cs.MaxPerMatch151_AU end),
	@v152MaxPerMatch_41_Max	= Min(case when cs.MaxPerMatch152_UK = 0 then NULL else cs.MaxPerMatch152_UK end),
	@v152MaxPerMatch_51_Max	= Min(case when cs.MaxPerMatch152_AU = 0 then NULL else cs.MaxPerMatch152_AU end),
	@v153MaxPerMatch_51_Max	= Min(case when cs.MaxPerMatch153_AU = 0 then NULL else cs.MaxPerMatch153_AU end)
from 
	custinfo as cs WITH (NOLOCK) 
	INNER JOIN custinfo as ci WITH (NOLOCK) on (cs.CustID = ci.MRecommend or cs.CustID = ci.SRecommend OR cs.CustID = ci.Recommend)
where ci.custid = @CustID

--PT MAX
SELECT	@v1aPositionTaking_1_Max = max(CASE WHEN cs.bettype = 1 AND cs.sporttype = 1 THEN cs.apositiontaking ELSE 0 END),
		@v161aPositionTaking_81_Max = max(CASE WHEN cs3rd.bettype = 81 AND cs3rd.sporttype = 161 THEN cs3rd.apositiontaking ELSE 0 END),
		
		@v180aPositionTaking_1201_Max = max(CASE WHEN cs3rd.bettype = 1201 AND cs3rd.sporttype = 180 THEN cs3rd.apositiontaking ELSE 0 END),
		
		--HR PT Max
		@v151aPositionTaking_31_Max = max(CASE WHEN cs3rd.bettype = 31 AND cs3rd.sporttype = 151 THEN cs3rd.apositiontaking ELSE 0 END),
		@v151aPositionTaking_41_Max = max(CASE WHEN cs3rd.bettype = 41 AND cs3rd.sporttype = 151 THEN cs3rd.apositiontaking ELSE 0 END),
		@v151aPositionTaking_51_Max = max(CASE WHEN cs3rd.bettype = 51 AND cs3rd.sporttype = 151 THEN cs3rd.apositiontaking ELSE 0 END),
		@v152aPositionTaking_41_Max = max(CASE WHEN cs3rd.bettype = 41 AND cs3rd.sporttype = 152 THEN cs3rd.apositiontaking ELSE 0 END),
		@v152aPositionTaking_51_Max = max(CASE WHEN cs3rd.bettype = 51 AND cs3rd.sporttype = 152 THEN cs3rd.apositiontaking ELSE 0 END),
		@v153aPositionTaking_51_Max = max(CASE WHEN cs3rd.bettype = 51 AND cs3rd.sporttype = 153 THEN cs3rd.apositiontaking ELSE 0 END),
		-- Commision Max
		@v151Discount_31_Max = max(CASE WHEN cs3rd.bettype = 31 AND cs3rd.sporttype = 151 THEN cs3rd.discount ELSE 0 END),
		@v151Discount_41_Max = max(CASE WHEN cs3rd.bettype = 41 AND cs3rd.sporttype = 151 THEN cs3rd.discount ELSE 0 END),
		@v151Discount_51_Max = max(CASE WHEN cs3rd.bettype = 51 AND cs3rd.sporttype = 151 THEN cs3rd.discount ELSE 0 END),
		@v152Discount_41_Max = max(CASE WHEN cs3rd.bettype = 41 AND cs3rd.sporttype = 152 THEN cs3rd.discount ELSE 0 END),
		@v152Discount_51_Max = max(CASE WHEN cs3rd.bettype = 51 AND cs3rd.sporttype = 152 THEN cs3rd.discount ELSE 0 END),
		@v153Discount_51_Max = max(CASE WHEN cs3rd.bettype = 51 AND cs3rd.sporttype = 153 THEN cs3rd.discount ELSE 0 END)

FROM Dep_CustSetting AS cs WITH (NOLOCK)
	LEFT JOIN Dep_CustSetting3rd AS cs3rd WITH (NOLOCK) ON cs.custid = cs3rd.custid
 WHERE cs.custid = @recommend
 
 
 
 -- Virtual Sports
SELECT @maxpermatchv180 = ci.maxpermatch180, @maxpermatchv181 = maxpermatch181, @maxpermatchv182 = maxpermatch182,@maxpermatchv183 = maxpermatch183,@maxpermatchv184 = maxpermatch184,@maxpermatchv185 = maxpermatch185,@maxpermatchv186 = maxpermatch186
FROM custinfo ci with (nolock)
WHERE ci.custid = @CustID

Select @VirtualSportList = '<products><product SportType = "180" MaxBet = "'+ coalesce(cast(@MaxBetv180 as varchar(50)),space(1)) + '" ' +
'MaxBet_Min = "'+ coalesce(cast(isnull(@MaxBetv180_Min,0) as varchar(50)),space(1)) + '" ' +
'MinBet = "'+ coalesce(cast(@MinBetv180 as varchar(50)),space(1)) + '" ' +
'MinBet_Max = "'+ coalesce(cast(isnull(@MinBetv180_Max,0) as varchar(50)),space(1)) + '" ' +
'MaxPerMatch = "'+ coalesce(cast(@maxpermatchv180 as varchar(50)),space(1)) + '" ' +
'MaxPerMatch_Max = "'+ coalesce(cast(isnull(@MaxPerMatchv180_Max,0) as varchar(50)),space(1)) + '" ' +
'aPositionTaking = "'+ coalesce(cast(@v180aPositionTaking_1201 as varchar(50)),space(1)) + '" ' +
'aPositionTaking_Max = "'+ coalesce(cast(@v180aPositionTaking_1201_Max as varchar(50)),space(1)) + '"></product>' +

'<product SportType = "181" MaxBet = "'+ coalesce(cast(@MaxBetv181 as varchar(50)),space(1)) + '" ' +
'MaxBet_Min = "'+ coalesce(cast(isnull(@MaxBetv181_Min,0) as varchar(50)),space(1)) + '" ' +
'MinBet = "'+ coalesce(cast(@MinBetv181 as varchar(50)),space(1)) + '" ' +
'MinBet_Max= "'+ coalesce(cast(isnull(@MinBetv181_Max,0) as varchar(50)),space(1)) + '" ' +
'MaxPerMatch = "'+ coalesce(cast(@maxpermatchv181 as varchar(50)),space(1)) + '" ' +
'MaxPerMatch_Max = "'+ coalesce(cast(isnull(@MaxPerMatchv181_Max,0) as varchar(50)),space(1)) + '"></product>' +

'<product SportType = "182" MaxBet = "'+ coalesce(cast(@MaxBetv182 as varchar(50)),space(1)) + '" ' +
'MaxBet_Min = "'+ coalesce(cast(isnull(@MaxBetv182_Min,0) as varchar(50)),space(1)) + '" ' +
'MinBet = "'+ coalesce(cast(@MinBetv182 as varchar(50)),space(1)) + '" ' +
'MinBet_Max= "'+ coalesce(cast(isnull(@MinBetv182_Max,0) as varchar(50)),space(1)) + '" ' +
'MaxPerMatch = "'+ coalesce(cast(@maxpermatchv182 as varchar(50)),space(1)) + '" ' +
'MaxPerMatch_Max = "'+ coalesce(cast(isnull(@MaxPerMatchv182_Max,0) as varchar(50)),space(1)) + '"></product>' +

'<product SportType = "183" MaxBet = "'+ coalesce(cast(@MaxBetv183 as varchar(50)),space(1)) + '" ' +
'MaxBet_Min = "'+ coalesce(cast(isnull(@MaxBetv183_Min,0) as varchar(50)),space(1)) + '" ' +
'MinBet = "'+ coalesce(cast(@MinBetv183 as varchar(50)),space(1)) + '" ' +
'MinBet_Max= "'+ coalesce(cast(isnull(@MinBetv183_Max,0) as varchar(50)),space(1)) + '" ' +
'MaxPerMatch = "'+ coalesce(cast(@maxpermatchv183 as varchar(50)),space(1)) + '" ' +
'MaxPerMatch_Max = "'+ coalesce(cast(isnull(@MaxPerMatchv183_Max,0) as varchar(50)),space(1)) + '"></product>' +

'<product SportType = "184" MaxBet = "'+ coalesce(cast(@MaxBetv184 as varchar(50)),space(1)) + '" ' +
'MaxBet_Min = "'+ coalesce(cast(isnull(@MaxBetv184_Min,0) as varchar(50)),space(1)) + '" ' +
'MinBet = "'+ coalesce(cast(@MinBetv184 as varchar(50)),space(1)) + '" ' +
'MinBet_Max= "'+ coalesce(cast(isnull(@MinBetv184_Max,0) as varchar(50)),space(1)) + '" ' +
'MaxPerMatch = "'+ coalesce(cast(@maxpermatchv184 as varchar(50)),space(1)) + '" ' +
'MaxPerMatch_Max = "'+ coalesce(cast(isnull(@MaxPerMatchv184_Max,0) as varchar(50)),space(1)) + '"></product>' +

'<product SportType = "185" MaxBet = "'+ coalesce(cast(@MaxBetv185 as varchar(50)),space(1)) + '" ' +
'MaxBet_Min = "'+ coalesce(cast(isnull(@MaxBetv185_Min,0) as varchar(50)),space(1)) + '" ' +
'MinBet = "'+ coalesce(cast(@MinBetv185 as varchar(50)),space(1)) + '" ' +
'MinBet_Max= "'+ coalesce(cast(isnull(@MinBetv185_Max,0) as varchar(50)),space(1)) + '" ' +
'MaxPerMatch = "'+ coalesce(cast(@maxpermatchv185 as varchar(50)),space(1)) + '" ' +
'MaxPerMatch_Max = "'+ coalesce(cast(isnull(@MaxPerMatchv185_Max,0) as varchar(50)),space(1)) + '"></product>' +

'<product SportType = "186" MaxBet = "'+ coalesce(cast(@MaxBetv186 as varchar(50)),space(1)) + '" ' +
'MaxBet_Min = "'+ coalesce(cast(isnull(@MaxBetv186_Min,0) as varchar(50)),space(1)) + '" ' +
'MinBet = "'+ coalesce(cast(@MinBetv186 as varchar(50)),space(1)) + '" ' +
'MinBet_Max = "'+ coalesce(cast(isnull(@MinBetv186_Max,0) as varchar(50)),space(1)) + '" ' +
'MaxPerMatch = "'+ coalesce(cast(@maxpermatchv186 as varchar(50)),space(1)) + '" ' +
'MaxPerMatch_Max = "'+ coalesce(cast(isnull(@MaxPerMatchv186_Max,0) as varchar(50)),space(1)) + '"></product>' +
+ '</products>'

 
 --Keno
  -- 20150603@Kathy: Migrate custDB to new server - DBCust
 DECLARE @tmp_GameType TABLE (GameTypeID INT, GameTypeName NVARCHAR(50), IsDisabled BIT, IBCBettypeID INT)
 BEGIN TRY		
	INSERT INTO @tmp_GameType (GameTypeID, GameTypeName, IsDisabled, IBCBettypeID)
	SELECT GameTypeID, GameTypeName, IsDisabled, IBCBettypeID FROM DBAGE.bodb02.dbo.GameType WITH (NOLOCK)
 END TRY
 BEGIN CATCH		
	INSERT INTO @tmp_GameType (GameTypeID, GameTypeName, IsDisabled, IBCBettypeID)
	SELECT GameTypeID, GameTypeName, IsDisabled, IBCBettypeID FROM DBTXN.bodb02.dbo.GameType WITH (NOLOCK)
 END CATCH
 ---
 
--Minbet maxbet matchpermatch
SELECT @vPT = ISNULL(apositiontaking,0) 
FROM  dbo.CustSettingGame WITH (NOLOCK) 
WHERE Bettype =1501 AND CustID=@CustID 
--MinBet_max Maxbet_min

SELECT @vPT_Max= ISNULL(apositiontaking,0) 
FROM  dbo.CustSettingGame WITH (NOLOCK) 
WHERE Bettype =1501 AND CustID=@recommend 

SELECT gt.IBCBetTypeID bettype ,
	ISNULL(Minbet,0) AS Minbet_Up,
	ISNULL(MaxBet,0) AS MaxBet_Up,
	ISNULL(MaxPerGameType,0) AS MaxPerMatch_Up,
	ISNULL(cgt.isDisabled,1) AS isDisabled
INTO #dataUpline
FROM dbo.CustGameType cgt WITH (NOLOCK) 
INNER JOIN @tmp_GameType gt ON cgt.GameTypeID = gt.GameTypeID
WHERE Custid=@recommend 

SELECT gt.IBCBetTypeID bettype ,
	ISNULL(Minbet,0) AS Minbet,
	ISNULL(MaxBet,0) AS MaxBet,
	ISNULL(MaxPerGameType,0) AS MaxPerMatch,
	ISNULL(cgt.isDisabled,1) AS isDisabled
INTO #data
FROM dbo.CustGameType cgt WITH (NOLOCK) 
INNER JOIN @tmp_GameType gt ON cgt.GameTypeID = gt.GameTypeID
WHERE Custid=@CustID 


SELECT @KenoList=@KenoList+'<products>'
DECLARE @i INT =1501,
@j INT =(select max(bettype) from #data)
WHILE (@i<=@j)
BEGIN
	IF (@i=1501)
		BEGIN
			SELECT @KenoList=@KenoList+'<product BetType = "'+coalesce(cast(d.Bettype as varchar(50)),space(1))+ '" ' 
									  +'MaxBet = "'+coalesce(cast(MaxBet as varchar(50)),space(1))+ '" ' 
									  +'MaxBet_Min = "'+ coalesce(cast(MaxBet_up as varchar(50)),space(1)) + '" ' 
									  +'MinBet = "'+coalesce(cast(MinBet as varchar(50)),space(1))+ '" ' 
									  +'MinBet_Max = "'+ coalesce(cast(MinBet_up as varchar(50)),space(1)) + '" ' 
									  +'MaxPerMatch = "'+ coalesce(cast(MaxPerMatch as varchar(50)),space(1)) + '" ' +
									  +'MaxPerMatch_Max = "'+ coalesce(cast(MaxPerMatch_up as varchar(50)),space(1)) + '" '
									  +'isDisabled = "'+ coalesce(cast(d.isDisabled as varchar(50)),space(1)) + '" ' +
									  +'aPositionTaking = "'+ coalesce(cast(@vPT as varchar(50)),space(1)) +'" '
									  +'aPositionTaking_Max = "'+ coalesce(cast(@vPT_Max as varchar(50)),space(1)) +'" '
									  +'aPositionTaking_Min = "0" '
									  + '></product>'
			FROM #data d inner join #dataUpline d2 on d.bettype=d2.bettype
			WHERE d.Bettype=@i
		END
	ELSE
		BEGIN
			SELECT @KenoList=@KenoList+'<product BetType = "'+coalesce(cast(d.Bettype as varchar(50)),space(1))+ '" ' 
									  +'MaxBet = "'+coalesce(cast(MaxBet as varchar(50)),space(1))+ '" ' 
									  +'MaxBet_Min = "'+ coalesce(cast(MaxBet_up as varchar(50)),space(1)) + '" ' 
									  +'MinBet = "'+coalesce(cast(MinBet as varchar(50)),space(1))+ '" ' 
									  +'MinBet_Max = "'+ coalesce(cast(MinBet_up as varchar(50)),space(1)) + '" ' 
									  +'MaxPerMatch = "'+ coalesce(cast(MaxPerMatch as varchar(50)),space(1)) + '" ' +
									  +'MaxPerMatch_Max = "'+ coalesce(cast(MaxPerMatch_up as varchar(50)),space(1)) + '" '
									  +'isDisabled = "'+ coalesce(cast(d.isDisabled as varchar(50)),space(1)) + '" ' +
									  + '></product>'
			FROM #data d inner join #dataUpline d2 on d.bettype=d2.bettype
			WHERE d.Bettype=@i
		END	
	SELECT @i=@i+1
END
SELECT @KenoList=@KenoList+'</products>'

SELECT @MinBetv1  AS MinBetv1,
	@MinBetv2     AS MinBetv2,
	@MinBetv3     AS MinBetv3,
	@MinBetv5     AS MinBetv5,
	@MinBetv8     AS MinBetv8,
	@MinBetv10    AS MinBetv10,
	@MinBetv11    AS MinBetv11,	
	@MinBetv44    AS MinBetv44,	
	@MinBetv99    AS MinBetv99,
	@MinBetv154    AS MinBetv154,
	@MinBetv99MP  AS minbetv99MP,
	@MinBetv161   AS minbetv161,


	isnull(@MinBetv1_Max,0)     AS MinBetv1_Max,
	isnull(@MinBetv2_Max,0)     AS MinBetv2_Max,
	isnull(@MinBetv3_Max,0)     AS MinBetv3_Max,
	isnull(@MinBetv5_Max,0)     AS MinBetv5_Max,
	isnull(@MinBetv8_Max,0)     AS MinBetv8_Max,
	isnull(@MinBetv10_Max,0)    AS MinBetv10_Max,
	isnull(@MinBetv11_Max,0)    AS MinBetv11_Max,	
	isnull(@MinBetv44_Max,0)    AS MinBetv44_Max,
	isnull(@MinBetv99_Max,0)    AS MinBetv99_Max,
	isnull(@MinBetv154_Max,0)    AS MinBetv154_Max,
	isnull(@MinBetv99MP_Max,0)  AS minbetv99MP_Max,
	isnull(@MinBetv161_Max,0)   AS minbetv161_Max,
	--isnull(@MinBetv180_Max,0)   AS minbetv180_Max,
	
	@v151MinBet_31 AS v151MinBet_31,
	@v151MinBet_41 AS v151MinBet_41,
	@v151MinBet_51 AS v151MinBet_51,
	@v152MinBet_41 AS v152MinBet_41,
	@v152MinBet_51 AS v152MinBet_51,
	@v153MinBet_51 AS v153MinBet_51,

	isnull(@v151MinBet_31_Max,0) AS v151MinBet_31_Max,
	isnull(@v151MinBet_41_Max,0) AS v151MinBet_41_Max,
	isnull(@v151MinBet_51_Max,0) AS v151MinBet_51_Max,
	isnull(@v152MinBet_41_Max,0) AS v152MinBet_41_Max,
	isnull(@v152MinBet_51_Max,0) AS v152MinBet_51_Max,
	isnull(@v153MinBet_51_Max,0) AS v153MinBet_51_Max,

	@v151MaxBet_31 AS v151MaxBet_31,
	@v151MaxBet_41 AS v151MaxBet_41,
	@v151MaxBet_51 AS v151MaxBet_51,
	@v152MaxBet_41 AS v152MaxBet_41,
	@v152MaxBet_51 AS v152MaxBet_51,
	@v153MaxBet_51 AS v153MaxBet_51,

	isnull(@v151MaxBet_31_Min,0) AS v151MaxBet_31_Min,
	isnull(@v151MaxBet_41_Min,0) AS v151MaxBet_41_Min,
	isnull(@v151MaxBet_51_Min,0) AS v151MaxBet_51_Min,
	isnull(@v152MaxBet_41_Min,0) AS v152MaxBet_41_Min,
	isnull(@v152MaxBet_51_Min,0) AS v152MaxBet_51_Min,
	isnull(@v153MaxBet_51_Min,0) AS v153MaxBet_51_Min,

	@MaxBetv1 AS MaxBetv1,
	@MaxBetv2 AS MaxBetv2,
	@MaxBetv3 AS MaxBetv3,
	@MaxBetv5 AS MaxBetv5,
	@MaxBetv8 AS MaxBetv8,
	@MaxBetv10 AS MaxBetv10,
	@MaxBetv11 AS MaxBetv11,	
	@MaxBetv44 AS MaxBetv44,
	@MaxBetv99 AS MaxBetv99,
	@MaxBetv154 AS MaxBetv154,
	@MaxBetv99MP AS maxbetv99MP,
	@MaxBetv161 AS maxbetv161,
	--@MaxBetv180 AS maxbetv180,

	isnull(@MaxBetv1_Min,0) AS MaxBetv1_Min,
	isnull(@MaxBetv2_Min,0) AS MaxBetv2_Min,
	isnull(@MaxBetv3_Min,0) AS MaxBetv3_Min,
	isnull(@MaxBetv5_Min,0) AS MaxBetv5_Min,
	isnull(@MaxBetv8_Min,0) AS MaxBetv8_Min,
	isnull(@MaxBetv10_Min,0) AS MaxBetv10_Min,
	isnull(@MaxBetv11_Min,0) AS MaxBetv11_Min,	
	isnull(@MaxBetv44_Min,0) AS MaxBetv44_Min,
	isnull(@MaxBetv99_Min,0) AS MaxBetv99_Min,
	isnull(@MaxBetv154_Min,0) AS MaxBetv154_Min,
	isnull(@MaxBetv99MP_Min,0) AS Maxbetv99MP_Min,
	isnull(@MaxBetv161_Min,0) AS Maxbetv161_Min,
	

	---PT
	@v1aPositionTaking_1 AS v1aPositionTaking_1,
	@v1aPositionTaking_1_Max AS v1aPositionTaking_1_Max,
	@v161aPositionTaking_81 AS v161aPositionTaking_81,
	@v161aPositionTaking_81_Max AS v161aPositionTaking_81_Max,
	

	

	@v151aPositionTaking_31		AS v151aPositionTaking_31,
	@v151aPositionTaking_41		AS v151aPositionTaking_41,
	@v151aPositionTaking_51		AS v151aPositionTaking_51,
	@v152aPositionTaking_41		AS v152aPositionTaking_41,
	@v152aPositionTaking_51		AS v152aPositionTaking_51,
	@v153aPositionTaking_51		AS v153aPositionTaking_51,

	@v151aPositionTaking_31_Max	AS v151aPositionTaking_31_Max,
	@v151aPositionTaking_41_Max	AS v151aPositionTaking_41_Max,
	@v151aPositionTaking_51_Max	AS v151aPositionTaking_51_Max,
	@v152aPositionTaking_41_Max	AS v152aPositionTaking_41_Max,
	@v152aPositionTaking_51_Max	AS v152aPositionTaking_51_Max,
	@v153aPositionTaking_51_Max	AS v153aPositionTaking_51_Max,

	-- Max Per Match
	isnull(@MaxPerMatchv1_Max,0)			AS MaxPerMatchv1_Max,		
	isnull(@MaxPerMatchv2_Max,0)			AS MaxPerMatchv2_Max,		
	isnull(@MaxPerMatchv3_Max,0)			AS MaxPerMatchv3_Max,		
	isnull(@MaxPerMatchv5_Max,0)			AS MaxPerMatchv5_Max,		
	isnull(@MaxPerMatchv8_Max,0)			AS MaxPerMatchv8_Max,		
	isnull(@MaxPerMatchv10_Max,0)			AS MaxPerMatchv10_Max,		
	isnull(@MaxPerMatchv11_Max,0)			AS MaxPerMatchv11_Max,		
	isnull(@MaxPerMatchv44_Max,0)			AS MaxPerMatchv44_Max,
	isnull(@MaxPerMatchv99_Max,0)			AS MaxPerMatchv99_Max,		
	isnull(@MaxPerMatchv154_Max,0)			AS MaxPerMatchv154_Max,	
	isnull(@MaxPerMatchv99MP_Max,0)			AS MaxPerMatchv99MP_Max,	
	isnull(@MaxPerMatchv161_Max,0)			AS MaxPerMatchv161_Max,	
	isnull(@MaxPerBallv161_Max,0)			AS MaxPerBallv161_Max,	
	
	isnull(@v151MaxPerMatch_31_Max,0)		AS v151MaxPerMatch_31_Max,
	isnull(@v151MaxPerMatch_41_Max,0)		AS v151MaxPerMatch_41_Max,
	isnull(@v151MaxPerMatch_51_Max,0)		AS v151MaxPerMatch_51_Max,
	isnull(@v152MaxPerMatch_41_Max,0)		AS v152MaxPerMatch_41_Max,
	isnull(@v152MaxPerMatch_51_Max,0)		AS v152MaxPerMatch_51_Max,
	isnull(@v153MaxPerMatch_51_Max,0)		AS v153MaxPerMatch_51_Max,

	ci.MaxPerMatch				AS MaxPerMatchv1,		
	ci.MaxPerMatch2				AS MaxPerMatchv2,		
	ci.MaxPerMatch3				AS MaxPerMatchv3,		
	ci.MaxPerMatch5				AS MaxPerMatchv5,		
	ci.MaxPerMatch8				AS MaxPerMatchv8,		
	ci.MaxPerMatch10			AS MaxPerMatchv10,		
	ci.MaxPerMatch11			AS MaxPerMatchv11,		
	ci.MaxPerMatch44			AS MaxPerMatchv44,
	ci.MaxPerMatch99			AS MaxPerMatchv99,		
	ci.MaxPerMatch154			AS MaxPerMatchv154,	
	ci.MaxPerMatch99MP			AS MaxPerMatchv99MP,	
	ci.MaxPerMatch161			AS MaxPerMatchv161,	
	ci.MaxPerBall161			AS MaxPerBallv161,	
	
	ci.MaxPerMatch151			AS v151MaxPerMatch_31,
	ci.MaxPerMatch151_OT		AS v151MaxPerMatch_41,
	ci.MaxPerMatch151_AU		AS v151MaxPerMatch_51,
	ci.MaxPerMatch152_UK		AS v152MaxPerMatch_41,
	ci.MaxPerMatch152_AU		AS v152MaxPerMatch_51,
	ci.MaxPerMatch153_AU		AS v153MaxPerMatch_51,

	--discount
	@v151Discount_31 AS v151Discount_31,
	@v151Discount_41 AS v151Discount_41,
	@v151Discount_51 AS v151Discount_51,
	@v152Discount_41 AS v152Discount_41,
	@v152Discount_51 AS v152Discount_51,
	@v153Discount_51 AS v153Discount_51,

	@v151Discount_31_Max AS v151Discount_31_Max,
	@v151Discount_41_Max AS v151Discount_41_Max,
	@v151Discount_51_Max AS v151Discount_51_Max,
	@v152Discount_41_Max AS v152Discount_41_Max,
	@v152Discount_51_Max AS v152Discount_51_Max,
	@v153Discount_51_Max AS v153Discount_51_Max,

	@VirtualSportList AS VirtualSportList,
	@KenoList AS KenoList,

	@UserName AS UserName
FROM custinfo (NOLOCK) ci  WHERE ci.custid = @CustID


DROP TABLE #dataUpline
DROP TABLE #data


GO
GRANT EXECUTE ON [dbo].[Acc_Dep_CustomerSelMember_Ag] TO [bodbAdminNet] AS [dbo]
GO
GRANT VIEW DEFINITION ON [dbo].[Acc_Dep_CustomerSelMember_Ag] TO [vnteam] AS [dbo]