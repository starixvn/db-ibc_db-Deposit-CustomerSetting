ALTER PROCEDURE [dbo].[Acc_Dep_CustomerUpdMemberVirtualSports_MAg] -- agent custid 
	@CustID INT, -- Super ID
	
	@v180MaxPerMatch MONEY,
	@v180MinBet MONEY,
	@v180MaxBet MONEY,
	@v180aPositionTaking SMALLMONEY,
	@v180mPositionTaking SMALLMONEY,
	
	@v181MaxPerMatch MONEY,
	@v181MinBet MONEY,
	@v181MaxBet MONEY,
	@v181aPositionTaking SMALLMONEY,
	@v181mPositionTaking SMALLMONEY,

	@v182MaxPerMatch MONEY,
	@v182MinBet MONEY,
	@v182MaxBet MONEY,
	@v182aPositionTaking SMALLMONEY,
	@v182mPositionTaking SMALLMONEY,

	@v183MaxPerMatch MONEY,
	@v183MinBet MONEY,
	@v183MaxBet MONEY,
	@v183aPositionTaking SMALLMONEY,
	@v183mPositionTaking SMALLMONEY,

	@v184MaxPerMatch MONEY,
	@v184MinBet MONEY,
	@v184MaxBet MONEY,
	@v184aPositionTaking SMALLMONEY,
	@v184mPositionTaking SMALLMONEY,

	@v185MaxPerMatch MONEY,
	@v185MinBet MONEY,
	@v185MaxBet MONEY,
	@v185aPositionTaking SMALLMONEY,
	@v185mPositionTaking SMALLMONEY,

	@v186MaxPerMatch MONEY,
	@v186MinBet MONEY,
	@v186MaxBet MONEY,
	@v186aPositionTaking SMALLMONEY,
	@v186mPositionTaking SMALLMONEY,

	@UserID INT = 0,	
	@Language VARCHAR(2) = 'E',
	@ErrCode INT = 0 OUTPUT,
	@ErrMsg NVARCHAR(4000) = '' OUTPUT
	
 AS

--@Source Control
/*
Created: 20120828@Dom
Task : Master update MinBet, MaxBet, MaxPerMatch, PT of Agent for virtual sports
DB: DBTrans.bodb02

Revisions:
    - 20121128@Elodie: Get an error message from f_Get_MsgNameByMsgID function by language
	- 20131014@Francis: Support updating new virtual sports with settings
	- 20131231@Francis: Hotfix failing to update settings of new Virtual Sports for an old agent
	- 20160913@Elodie: Enhance performance [Redmine:#64064]
    
Param's Explanation:
• @ErrCode:
    = 0: Update successfully.
    > 0: Specific Error.
  
• @ErrMsg: Error description.
*/
 
DECLARE @startRun DATETIME
DECLARE @endRun DATETIME
DECLARE @duration INT
SET @startRun = getdate()
 
DECLARE @ErrType VARCHAR(1000)
DECLARE @ErrAcc nvarchar(4000)

DECLARE @mrecommend INT, @srecommend INT,

		@v180MinBet_Max MONEY,
		@v180MaxBet_Min MONEY,
		@v180aPositionTaking_Max SMALLMONEY,
		@v180MaxPerMatch_Max MONEY,
		
		@v181MinBet_Max MONEY,
		@v181MaxBet_Min MONEY,
		@v181aPositionTaking_Max SMALLMONEY,
		@v181MaxPerMatch_Max MONEY,

		@v182MinBet_Max MONEY,
		@v182MaxBet_Min MONEY,
		@v182aPositionTaking_Max SMALLMONEY,
		@v182MaxPerMatch_Max MONEY,

		@v183MinBet_Max MONEY,
		@v183MaxBet_Min MONEY,
		@v183aPositionTaking_Max SMALLMONEY,
		@v183MaxPerMatch_Max MONEY,

		@v184MinBet_Max MONEY,
		@v184MaxBet_Min MONEY,
		@v184aPositionTaking_Max SMALLMONEY,
		@v184MaxPerMatch_Max MONEY,

		@v185MinBet_Max MONEY,
		@v185MaxBet_Min MONEY,
		@v185aPositionTaking_Max SMALLMONEY,
		@v185MaxPerMatch_Max MONEY,

		@v186MinBet_Max MONEY,
		@v186MaxBet_Min MONEY,
		@v186aPositionTaking_Max SMALLMONEY,
		@v186MaxPerMatch_Max MONEY


		
SELECT @mrecommend = ci.mrecommend, @srecommend = ci.srecommend FROM custInfo ci WITH (NOLOCK) WHERE ci.custid = @CustID


----Virtual Soccer
--SELECT @v180MinBet_Max = MAX(cs3.minbet),
--	@v180MaxBet_Min = MIN(cs3.maxbet),
--	@v180MaxPerMatch_Max = MIN(ci.maxpermatch180),
--	@v180aPositionTaking_Max = MAX(cs3.apositiontaking)
--FROM custInfo ci WITH(NOLOCK)
--	INNER JOIN Dep_CustSetting3rd cs3 ON (ci.srecommend = cs3.custid OR ci.mrecommend = cs3.custid)
--WHERE ci.custid = @mrecommend
--	AND cs3.sporttype = 180

SELECT @v180MinBet_Max = MAX(CASE WHEN cs3.minbet = 0 THEN NULL ELSE cs3.minbet END),
	@v180MaxBet_Min = MIN(CASE WHEN cs3.maxbet = 0 THEN NULL ELSE cs3.maxbet END),
	@v180MaxPerMatch_Max = MIN(CASE WHEN ci.maxpermatch180 = 0 THEN NULL ELSE ci.maxpermatch180 END),
	@v180aPositionTaking_Max = MAX(cs3.apositiontaking)
FROM custInfo ci WITH(NOLOCK)
	INNER JOIN Dep_CustSetting3rd cs3 ON ci.custid = cs3.custid
WHERE ci.custid IN (@mrecommend, @srecommend)
	AND cs3.sporttype = 180

IF @v180MinBet < 0 
	OR @v180MaxBet < 0
	OR @v180MinBet > @v180MaxBet
	OR @v180MinBet > @v180MaxPerMatch
	OR @v180MaxBet > @v180MaxPerMatch
BEGIN 
	Select @ErrMsg = 	case @Language 
						when 'E' then 'Wrong Min bet/ Max bet/ Max per match (for Virtual Soccer).'
						ELSE [dbo].[f_Get_MsgNamebyMsgID](10003,@Language) + ' (' + [dbo].[f_Get_SportNameBySporttype](180,@Language) + ')'
				end, @ErrCode = 102
	return
END 

IF (@v180MinBet < @v180MinBet_Max and @v180minbet > 0 AND @v180MinBet_Max > 0)
	OR (@v180MaxBet > @v180MaxBet_Min and @v180maxbet > 0 AND @v180MaxBet_Min > 0)
	OR (@v180MaxPerMatch > @v180MaxPerMatch_Max and @v180MaxPerMatch > 0 AND @v180MaxPerMatch_Max > 0)
BEGIN
	 SELECT @ErrMsg = case @Language 
						when 'E' then 'Min bet must be equal to or greater than Super Agent min bet (for Virtual Soccer)'
						ELSE [dbo].[f_Get_MsgNamebyMsgID](10016,@Language) + ' (' + [dbo].[f_Get_SportNameBySporttype](180,@Language) + ')'
					end						
			, @ErrCode = 119
	return
END 
-------------------------------------------
--Check all a1<=a4
select @ErrAcc = ''
select top 100 @ErrAcc = @ErrAcc + username +', '
from 
	custinfo as c with (NOLOCK) 
	inner join Dep_CustSetting3rd as cs with (NOLOCK) on c.custid = cs.custid
	inner join (
				   select 	180 as sporttype, 1201 as bettype, @v180apositiontaking as maxpositiontaking
		) as b on cs.sporttype=b.sporttype and cs.bettype = b.bettype
where c.recommend = @custid 
	AND cs.sporttype = 180
	and c.roleid = 1
	and (
			(cs.apositiontaking>b.maxpositiontaking)  
		)
group by username
if @ErrAcc<>''
BEGIN
	Select @ErrMsg = '' +
				case @Language 
						when 'E' then 'Existing members exceeded new agent position taking ('+@ErrAcc+') (for Virtual Soccer).'
						ELSE [dbo].[f_Get_MsgNamebyMsgID](20017,@Language) + ' ('+@ErrAcc+')' + ' (' + [dbo].[f_Get_SportNameBySporttype](180,@Language) + ')'
				end, @ErrCode = 109
	return
END


	
 /*************************************
 * Update Setting
 *************************************/
 UPDATE custinfo WITH(ROWLOCK,UPDLOCK) SET maxpermatch180 = @v180MaxPerMatch
 WHERE custid = @CustID
 if (@@error <> 0)
begin
	
	Select @ErrMsg = case @Language 
						when 'E' then 'Update process is unsuccessful !'
						ELSE [dbo].[f_Get_MsgNamebyMsgID](90001,@Language)
					end	, @ErrCode = 103 
	return
END

 /*************************************
 * Update Bet Setting
 *************************************/
 IF EXISTS (SELECT 1 FROM Dep_CustSetting3rd WITH (NOLOCK) WHERE sporttype = 180 AND custid = @CustID)
BEGIN
	 UPDATE Dep_CustSetting3rd WITH(ROWLOCK,UPDLOCK)
	SET
 		mpositiontaking = 0,
 		apositiontaking = @v180aPositionTaking,
 		minbet = @v180MinBet,
 		maxbet = @v180MaxBet
	WHERE custid = @CustID
		AND sporttype = 180
END
ELSE
BEGIN
	INSERT INTO Dep_CustSetting3rd (custId, bettype, sporttype, apositiontaking, mpositiontaking, spositiontaking, playerdiscount, discount, adiscount, sdiscount, Minbet, Maxbet, islive)
	VALUES (@CustID, 
			1201, 
			180, 
			@v180aPositionTaking, 
			0, 
			0, 
			0, 0, 0, 0, 
			@v180MinBet, 
			@v180MaxBet,
			0)
END

if (@@error <> 0)
begin
	
	Select @ErrMsg = case @Language 
						when 'E' then 'Update process is unsuccessful !'
						ELSE [dbo].[f_Get_MsgNamebyMsgID](90001,@Language)
					end	, @ErrCode = 103 
	return
END	

------Virtual Horse Racing
--SELECT @v181MinBet_Max = MAX(cs3.minbet),
--	@v181MaxBet_Min = MIN(cs3.maxbet),
--	@v181MaxPerMatch_Max = MIN(ci.maxpermatch181),
--	@v181aPositionTaking_Max = MAX(cs3.apositiontaking)
--FROM custInfo ci WITH(NOLOCK)
--	INNER JOIN Dep_CustSetting3rd cs3 ON (ci.srecommend = cs3.custid OR ci.mrecommend = cs3.custid)
--WHERE ci.custid = @mrecommend
--	AND cs3.sporttype = 181

SELECT @v181MinBet_Max = MAX(CASE WHEN cs3.minbet = 0 THEN NULL ELSE cs3.minbet END),
	@v181MaxBet_Min = MIN(CASE WHEN cs3.maxbet = 0 THEN NULL ELSE cs3.maxbet END),
	@v181MaxPerMatch_Max = MIN(CASE WHEN ci.maxpermatch181 = 0 THEN NULL ELSE ci.maxpermatch181 END),
	@v181aPositionTaking_Max = MAX(cs3.apositiontaking)
FROM custInfo ci WITH(NOLOCK)
	INNER JOIN Dep_CustSetting3rd cs3 ON ci.custid = cs3.custid
WHERE ci.custid IN (@mrecommend, @srecommend)
	AND cs3.sporttype = 181

IF @v181MinBet < 0 
	OR @v181MaxBet < 0
	OR @v181MinBet > @v181MaxBet
	OR @v181MinBet > @v181MaxPerMatch
	OR @v181MaxBet > @v181MaxPerMatch
BEGIN 
	Select @ErrMsg = 	case @Language 
						when 'E' then 'Wrong Min bet/ Max bet/ Max per match (for Virtual Horse Racing).'
						ELSE [dbo].[f_Get_MsgNamebyMsgID](10003,@Language) + ' (' + [dbo].[f_Get_SportNameBySporttype](181,@Language) + ')'
				end, @ErrCode = 102
	return
END 

IF (@v181MinBet < @v181MinBet_Max and @v181minbet > 0 AND @v181MinBet_Max > 0)
	OR (@v181MaxBet > @v181MaxBet_Min and @v181maxbet > 0 AND @v181MaxBet_Min > 0)
	OR (@v181MaxPerMatch > @v181MaxPerMatch_Max and @v181MaxPerMatch > 0 AND @v181MaxPerMatch_Max > 0)
BEGIN
	 SELECT @ErrMsg = case @Language 
						when 'E' then 'Min bet must be equal to or greater than Super Agent min bet (for Virtual Horse Racing)'
						ELSE [dbo].[f_Get_MsgNamebyMsgID](10016,@Language) + ' (' + [dbo].[f_Get_SportNameBySporttype](181,@Language) + ')'
					end						
			, @ErrCode = 119
	return
END 
-------------------------------------------
--Check all a1<=a4
select @ErrAcc = ''
select top 100 @ErrAcc = @ErrAcc + username +', '
from 
	custinfo as c with (NOLOCK) 
	inner join Dep_CustSetting3rd as cs with (NOLOCK) on c.custid = cs.custid
	inner join (
				   select 181 as sporttype, 1231 as bettype, @v181apositiontaking as maxpositiontaking
		) as b on cs.sporttype = b.sporttype and cs.bettype = b.bettype
where c.recommend = @custid 
	AND cs.sporttype = 181
	and c.roleid = 1
	and (
			(cs.apositiontaking>b.maxpositiontaking)  
		)
group by username
if @ErrAcc<>''
BEGIN
	Select @ErrMsg = '' +
				case @Language 
						when 'E' then 'Existing members exceeded new agent position taking ('+@ErrAcc+') (for Virtual Horse Racing).'
						ELSE [dbo].[f_Get_MsgNamebyMsgID](20017,@Language) + ' ('+@ErrAcc+')' + ' (' + [dbo].[f_Get_SportNameBySporttype](181,@Language) + ')'
				end, @ErrCode = 109
	return
END


	
 /*************************************
 * Update Setting
 *************************************/
 UPDATE custinfo WITH(ROWLOCK,UPDLOCK) SET maxpermatch181 = @v181MaxPerMatch
 WHERE custid = @CustID
 if (@@error <> 0)
begin
	
	Select @ErrMsg = case @Language 
						when 'E' then 'Update process is unsuccessful !'
						ELSE [dbo].[f_Get_MsgNamebyMsgID](90001,@Language)
					end	, @ErrCode = 103 
	return
END

 /*************************************
 * Update Bet Setting
 *************************************/
IF EXISTS (SELECT 1 FROM Dep_CustSetting3rd WITH (NOLOCK) WHERE sporttype = 181 AND custid = @CustID)
BEGIN
	UPDATE Dep_CustSetting3rd WITH(ROWLOCK,UPDLOCK)
	SET
 		mpositiontaking = 0,
 		apositiontaking = @v181aPositionTaking,
		minbet = @v181MinBet,
 		maxbet = @v181MaxBet
	WHERE custid = @CustID
		AND sporttype = 181
END
ELSE
BEGIN
	INSERT INTO Dep_CustSetting3rd (custId, bettype, sporttype, apositiontaking, mpositiontaking, spositiontaking, playerdiscount, discount, adiscount, sdiscount, Minbet, Maxbet, islive)
	VALUES (@CustID, 
			1231, 
			181, 
			@v181aPositionTaking, 
			0, 
			0, 
			0, 0, 0, 0, 
			@v181MinBet, 
			@v181MaxBet,
			0)
END
if (@@error <> 0)
begin
	
	Select @ErrMsg = case @Language 
						when 'E' then 'Update process is unsuccessful !'
						ELSE [dbo].[f_Get_MsgNamebyMsgID](90001,@Language)
					end	, @ErrCode = 103 
	return
END	

----Virtual Greyhounds
--SELECT @v182MinBet_Max = MAX(cs3.minbet),
--	@v182MaxBet_Min = MIN(cs3.maxbet),
--	@v182MaxPerMatch_Max = MIN(ci.maxpermatch182),
--	@v182aPositionTaking_Max = MAX(cs3.apositiontaking)
--FROM custInfo ci WITH(NOLOCK)
--	INNER JOIN Dep_CustSetting3rd cs3 ON (ci.srecommend = cs3.custid OR ci.mrecommend = cs3.custid)
--WHERE ci.custid = @mrecommend
--	AND cs3.sporttype = 182

SELECT @v182MinBet_Max = MAX(CASE WHEN cs3.minbet = 0 THEN NULL ELSE cs3.minbet END),
	@v182MaxBet_Min = MIN(CASE WHEN cs3.maxbet = 0 THEN NULL ELSE cs3.maxbet END),
	@v182MaxPerMatch_Max = MIN(CASE WHEN ci.maxpermatch182 = 0 THEN NULL ELSE ci.maxpermatch182 END),
	@v182aPositionTaking_Max = MAX(cs3.apositiontaking)
FROM custInfo ci WITH(NOLOCK)
	INNER JOIN Dep_CustSetting3rd cs3 ON ci.custid = cs3.custid
WHERE ci.custid IN (@mrecommend, @srecommend)
	AND cs3.sporttype = 182

IF @v182MinBet < 0 
	OR @v182MaxBet < 0
	OR @v182MinBet > @v182MaxBet
	OR @v182MinBet > @v182MaxPerMatch
	OR @v182MaxBet > @v182MaxPerMatch
BEGIN 
	Select @ErrMsg = 	case @Language 
						when 'E' then 'Wrong Min bet/ Max bet/ Max per match (for Virtual Greyhounds).'
						ELSE [dbo].[f_Get_MsgNamebyMsgID](10003,@Language) + ' (' + [dbo].[f_Get_SportNameBySporttype](182,@Language) + ')'
				end, @ErrCode = 102
	return
END 

IF (@v182MinBet < @v182MinBet_Max and @v182minbet > 0 AND @v182MinBet_Max > 0)
	OR (@v182MaxBet > @v182MaxBet_Min and @v182maxbet > 0 AND @v182MaxBet_Min > 0)
	OR (@v182MaxPerMatch > @v182MaxPerMatch_Max and @v182MaxPerMatch > 0 AND @v182MaxPerMatch_Max > 0)
BEGIN
	 SELECT @ErrMsg = case @Language 
						when 'E' then 'Min bet must be equal to or greater than Super Agent min bet (for Virtual Greyhounds)'
						ELSE [dbo].[f_Get_MsgNamebyMsgID](10016,@Language) + ' (' + [dbo].[f_Get_SportNameBySporttype](182,@Language) + ')'
					end						
			, @ErrCode = 119
	return
END 
-------------------------------------------
--Check all a1<=a4
select @ErrAcc = ''
select top 100 @ErrAcc = @ErrAcc + username +', '
from 
	custinfo as c with (NOLOCK) 
	inner join Dep_CustSetting3rd as cs with (NOLOCK) on c.custid = cs.custid
	inner join (
				   select 	182 as sporttype, 1231 as bettype, @v182apositiontaking as maxpositiontaking
		) as b on cs.sporttype=b.sporttype and cs.bettype = b.bettype
where c.recommend = @custid 
	AND cs.sporttype = 182
	and c.roleid = 1
	and (
			(cs.apositiontaking>b.maxpositiontaking)  
		)
group by username
if @ErrAcc<>''
BEGIN
	Select @ErrMsg = '' +
				case @Language 
						when 'E' then 'Existing members exceeded new agent position taking ('+@ErrAcc+') (for Virtual Greyhounds).'
						ELSE [dbo].[f_Get_MsgNamebyMsgID](20017,@Language) + ' ('+@ErrAcc+')' + ' (' + [dbo].[f_Get_SportNameBySporttype](182,@Language) + ')'
				end, @ErrCode = 109
	return
END


	
 /*************************************
 * Update Setting
 *************************************/
 UPDATE custinfo WITH(ROWLOCK,UPDLOCK) SET maxpermatch182 = @v182MaxPerMatch
 WHERE custid = @CustID
 if (@@error <> 0)
begin
	
	Select @ErrMsg = case @Language 
						when 'E' then 'Update process is unsuccessful !'
						ELSE [dbo].[f_Get_MsgNamebyMsgID](90001,@Language)
					end	, @ErrCode = 103 
	return
END

 /*************************************
 * Update Bet Setting
 *************************************/
IF EXISTS (SELECT 1 FROM Dep_CustSetting3rd WITH (NOLOCK) WHERE sporttype = 182 AND custid = @CustID)
BEGIN
	UPDATE Dep_CustSetting3rd WITH(ROWLOCK,UPDLOCK)
	SET
 		mpositiontaking = 0,
 		apositiontaking = @v182aPositionTaking,
 		minbet = @v182MinBet,
 		maxbet = @v182MaxBet
	WHERE custid = @CustID
		AND sporttype = 182

END
ELSE
BEGIN
	INSERT INTO Dep_CustSetting3rd (custId, bettype, sporttype, apositiontaking, mpositiontaking, spositiontaking, playerdiscount, discount, adiscount, sdiscount, Minbet, Maxbet, islive)
	VALUES (@CustID, 
			1231, 
			182, 
			@v182aPositionTaking, 
			0, 
			0, 
			0, 0, 0, 0, 
			@v182MinBet, 
			@v182MaxBet,
			0)
END
 	
if (@@error <> 0)
begin
	
	Select @ErrMsg = case @Language 
						when 'E' then 'Update process is unsuccessful !'
						ELSE [dbo].[f_Get_MsgNamebyMsgID](90001,@Language)
					end	, @ErrCode = 103 
	return
END	

----Virtual Speedway
SELECT @v183MinBet_Max = MAX(CASE WHEN cs3.minbet = 0 THEN NULL ELSE cs3.minbet END),
	@v183MaxBet_Min = MIN(CASE WHEN cs3.maxbet = 0 THEN NULL ELSE cs3.maxbet END),
	@v183MaxPerMatch_Max = MIN(CASE WHEN ci.maxpermatch183 = 0 THEN NULL ELSE ci.maxpermatch183 END),
	@v183aPositionTaking_Max = MAX(cs3.apositiontaking)
FROM custInfo ci WITH(NOLOCK)
	INNER JOIN Dep_CustSetting3rd cs3 ON ci.custid = cs3.custid
WHERE ci.custid IN (@mrecommend, @srecommend)
	AND cs3.sporttype = 183

IF @v183MinBet < 0 
	OR @v183MaxBet < 0
	OR @v183MinBet > @v183MaxBet
	OR @v183MinBet > @v183MaxPerMatch
	OR @v183MaxBet > @v183MaxPerMatch
BEGIN 
	Select @ErrMsg = 	case @Language 
						when 'E' then 'Wrong Min bet/ Max bet/ Max per match (for Virtual Greyhounds).'
						ELSE [dbo].[f_Get_MsgNamebyMsgID](10003,@Language) + ' (' + [dbo].[f_Get_SportNameBySporttype](183,@Language) + ')'
				end, @ErrCode = 102
	return
END 

IF (@v183MinBet < @v183MinBet_Max and @v183minbet > 0 AND @v183MinBet_Max > 0)
	OR (@v183MaxBet > @v183MaxBet_Min and @v183maxbet > 0 AND @v183MaxBet_Min > 0)
	OR (@v183MaxPerMatch > @v183MaxPerMatch_Max and @v183MaxPerMatch > 0 AND @v183MaxPerMatch_Max > 0)
BEGIN
	 SELECT @ErrMsg = case @Language 
						when 'E' then 'Min bet must be equal to or greater than Super Agent min bet (for Virtual Greyhounds)'
						ELSE [dbo].[f_Get_MsgNamebyMsgID](10016,@Language) + ' (' + [dbo].[f_Get_SportNameBySporttype](183,@Language) + ')'
					end						
			, @ErrCode = 119
	return
END 
-------------------------------------------
--Check all a1<=a4
select @ErrAcc = ''
select top 100 @ErrAcc = @ErrAcc + username +', '
from 
	custinfo as c with (NOLOCK) 
	inner join Dep_CustSetting3rd as cs with (NOLOCK) on c.custid = cs.custid
	inner join (
				   select 	183 as sporttype, 1231 as bettype, @v183apositiontaking as maxpositiontaking
		) as b on cs.sporttype=b.sporttype and cs.bettype = b.bettype
where c.recommend = @custid 
	AND cs.sporttype = 183
	and c.roleid = 1
	and (
			(cs.apositiontaking>b.maxpositiontaking)  
		)
group by username
if @ErrAcc<>''
BEGIN
	Select @ErrMsg = '' +
				case @Language 
						when 'E' then 'Existing members exceeded new agent position taking ('+@ErrAcc+') (for Virtual Greyhounds).'
						ELSE [dbo].[f_Get_MsgNamebyMsgID](20017,@Language) + ' ('+@ErrAcc+')' + ' (' + [dbo].[f_Get_SportNameBySporttype](183,@Language) + ')'
				end, @ErrCode = 109
	return
END


	
 /*************************************
 * Update Setting
 *************************************/
 
 UPDATE custinfo WITH(ROWLOCK,UPDLOCK) SET maxpermatch183 = @v183MaxPerMatch
 WHERE custid = @CustID
 if (@@error <> 0)
begin
	
	Select @ErrMsg = case @Language 
						when 'E' then 'Update process is unsuccessful !'
						ELSE [dbo].[f_Get_MsgNamebyMsgID](90001,@Language)
					end	, @ErrCode = 103 
	return
END

 /*************************************
 * Update Bet Setting
 *************************************/
IF EXISTS (SELECT 1 FROM Dep_CustSetting3rd WITH (NOLOCK) WHERE sporttype = 183 AND custid = @CustID)
BEGIN
	 UPDATE Dep_CustSetting3rd WITH(ROWLOCK,UPDLOCK)
	SET
 		mpositiontaking = 0,
 		apositiontaking = @v183aPositionTaking,
 		minbet = @v183MinBet,
 		maxbet = @v183MaxBet
	WHERE custid = @CustID
		AND sporttype = 183
END
ELSE
BEGIN
	INSERT INTO Dep_CustSetting3rd (custId, bettype, sporttype, apositiontaking, mpositiontaking, spositiontaking, playerdiscount, discount, adiscount, sdiscount, Minbet, Maxbet, islive)
	VALUES (@CustID, 
			1231, 
			183, 
			@v183aPositionTaking, 
			0, 
			0, 
			0, 0, 0, 0, 
			@v183MinBet, 
			@v183MaxBet,
			0)
END

if (@@error <> 0)
begin
	
	Select @ErrMsg = case @Language 
						when 'E' then 'Update process is unsuccessful !'
						ELSE [dbo].[f_Get_MsgNamebyMsgID](90001,@Language)
					end	, @ErrCode = 103 
	return
END	

----Virtual Motor Racing
SELECT @v184MinBet_Max = MAX(CASE WHEN cs3.minbet = 0 THEN NULL ELSE cs3.minbet END),
	@v184MaxBet_Min = MIN(CASE WHEN cs3.maxbet = 0 THEN NULL ELSE cs3.maxbet END),
	@v184MaxPerMatch_Max = MIN(CASE WHEN ci.maxpermatch184 = 0 THEN NULL ELSE ci.maxpermatch184 END),
	@v184aPositionTaking_Max = MAX(cs3.apositiontaking)
FROM custInfo ci WITH(NOLOCK)
	INNER JOIN Dep_CustSetting3rd cs3 ON ci.custid = cs3.custid
WHERE ci.custid IN (@mrecommend, @srecommend)
	AND cs3.sporttype = 184

IF @v184MinBet < 0 
	OR @v184MaxBet < 0
	OR @v184MinBet > @v184MaxBet
	OR @v184MinBet > @v184MaxPerMatch
	OR @v184MaxBet > @v184MaxPerMatch
BEGIN 
	Select @ErrMsg = 	case @Language 
						when 'E' then 'Wrong Min bet/ Max bet/ Max per match (for Virtual Motor Racing).'
						ELSE [dbo].[f_Get_MsgNamebyMsgID](10003,@Language) + ' (' + [dbo].[f_Get_SportNameBySporttype](184,@Language) + ')'
				end, @ErrCode = 102
	return
END 

IF (@v184MinBet < @v184MinBet_Max and @v184minbet > 0 AND @v184MinBet_Max > 0)
	OR (@v184MaxBet > @v184MaxBet_Min and @v184maxbet > 0 AND @v184MaxBet_Min > 0)
	OR (@v184MaxPerMatch > @v184MaxPerMatch_Max and @v184MaxPerMatch > 0 AND @v184MaxPerMatch_Max > 0)
BEGIN
	 SELECT @ErrMsg = case @Language 
						when 'E' then 'Min bet must be equal to or greater than Super Agent min bet (for Virtual Motor Racing)'
						ELSE [dbo].[f_Get_MsgNamebyMsgID](10016,@Language) + ' (' + [dbo].[f_Get_SportNameBySporttype](184,@Language) + ')'
					end						
			, @ErrCode = 119
	return
END 
-------------------------------------------
--Check all a1<=a4
select @ErrAcc = ''
select top 100 @ErrAcc = @ErrAcc + username +', '
from 
	custinfo as c with (NOLOCK) 
	inner join Dep_CustSetting3rd as cs with (NOLOCK) on c.custid = cs.custid
	inner join (
				   select 	184 as sporttype, 1231 as bettype, @v184apositiontaking as maxpositiontaking
		) as b on cs.sporttype=b.sporttype and cs.bettype = b.bettype
where c.recommend = @custid 
	AND cs.sporttype = 184
	and c.roleid = 1
	and (
			(cs.apositiontaking>b.maxpositiontaking)  
		)
group by username
if @ErrAcc<>''
BEGIN
	Select @ErrMsg = '' +
				case @Language 
						when 'E' then 'Existing members exceeded new agent position taking ('+@ErrAcc+') (for Virtual Motor Racing).'
						ELSE [dbo].[f_Get_MsgNamebyMsgID](20017,@Language) + ' ('+@ErrAcc+')' + ' (' + [dbo].[f_Get_SportNameBySporttype](184,@Language) + ')'
				end, @ErrCode = 109
	return
END


	
 /*************************************
 * Update Setting
 *************************************/
 UPDATE custinfo WITH(ROWLOCK,UPDLOCK) SET maxpermatch184 = @v184MaxPerMatch
 WHERE custid = @CustID
 if (@@error <> 0)
begin
	
	Select @ErrMsg = case @Language 
						when 'E' then 'Update process is unsuccessful !'
						ELSE [dbo].[f_Get_MsgNamebyMsgID](90001,@Language)
					end	, @ErrCode = 103 
	return
END

 /*************************************
 * Update Bet Setting
 *************************************/
 IF EXISTS (SELECT 1 FROM Dep_CustSetting3rd WITH (NOLOCK) WHERE sporttype = 184 AND custid = @CustID)
BEGIN
	UPDATE Dep_CustSetting3rd WITH(ROWLOCK,UPDLOCK)
	SET
 		mpositiontaking = 0,
 		apositiontaking = @v184aPositionTaking,
 		minbet = @v184MinBet,
	 	maxbet = @v184MaxBet
	 WHERE custid = @CustID
		AND sporttype = 184
END
ELSE
BEGIN
	INSERT INTO Dep_CustSetting3rd (custId, bettype, sporttype, apositiontaking, mpositiontaking, spositiontaking, playerdiscount, discount, adiscount, sdiscount, Minbet, Maxbet, islive)
	VALUES (@CustID, 
			1231, 
			184, 
			@v184aPositionTaking, 
			0, 
			0, 
			0, 0, 0, 0, 
			@v184MinBet, 
			@v184MaxBet,
			0)
END

if (@@error <> 0)
begin
	
	Select @ErrMsg = case @Language 
						when 'E' then 'Update process is unsuccessful !'
						ELSE [dbo].[f_Get_MsgNamebyMsgID](90001,@Language)
					end	, @ErrCode = 103 
	return
END	

----Virtual Cycling
SELECT @v185MinBet_Max = MAX(CASE WHEN cs3.minbet = 0 THEN NULL ELSE cs3.minbet END),
	@v185MaxBet_Min = MIN(CASE WHEN cs3.maxbet = 0 THEN NULL ELSE cs3.maxbet END),
	@v185MaxPerMatch_Max = MIN(CASE WHEN ci.maxpermatch185 = 0 THEN NULL ELSE ci.maxpermatch185 END),
	@v185aPositionTaking_Max = MAX(cs3.apositiontaking)
FROM custInfo ci WITH(NOLOCK)
	INNER JOIN Dep_CustSetting3rd cs3 ON ci.custid = cs3.custid
WHERE ci.custid IN (@mrecommend, @srecommend)
	AND cs3.sporttype = 185

IF @v185MinBet < 0 
	OR @v185MaxBet < 0
	OR @v185MinBet > @v185MaxBet
	OR @v185MinBet > @v185MaxPerMatch
	OR @v185MaxBet > @v185MaxPerMatch
BEGIN 
	Select @ErrMsg = 	case @Language 
						when 'E' then 'Wrong Min bet/ Max bet/ Max per match (for Virtual Cycling).'
						ELSE [dbo].[f_Get_MsgNamebyMsgID](10003,@Language) + ' (' + [dbo].[f_Get_SportNameBySporttype](185,@Language) + ')'
				end, @ErrCode = 102
	return
END 

IF (@v185MinBet < @v185MinBet_Max and @v185minbet > 0 AND @v185MinBet_Max > 0)
	OR (@v185MaxBet > @v185MaxBet_Min and @v185maxbet > 0 AND @v185MaxBet_Min > 0)
	OR (@v185MaxPerMatch > @v185MaxPerMatch_Max and @v185MaxPerMatch > 0 AND @v185MaxPerMatch_Max > 0)
BEGIN
	 SELECT @ErrMsg = case @Language 
						when 'E' then 'Min bet must be equal to or greater than Super Agent min bet (for Virtual Cycling)'
						ELSE [dbo].[f_Get_MsgNamebyMsgID](10016,@Language) + ' (' + [dbo].[f_Get_SportNameBySporttype](185,@Language) + ')'
					end						
			, @ErrCode = 119
	return
END 
-------------------------------------------
--Check all a1<=a4
select @ErrAcc = ''
select top 100 @ErrAcc = @ErrAcc + username +', '
from 
	custinfo as c with (NOLOCK) 
	inner join Dep_CustSetting3rd as cs with (NOLOCK) on c.custid = cs.custid
	inner join (
				   select 	185 as sporttype, 1231 as bettype, @v185apositiontaking as maxpositiontaking
		) as b on cs.sporttype=b.sporttype and cs.bettype = b.bettype
where c.recommend = @custid 
	AND cs.sporttype = 185
	and c.roleid = 1
	and (
			(cs.apositiontaking>b.maxpositiontaking)  
		)
group by username
if @ErrAcc<>''
BEGIN
	Select @ErrMsg = '' +
				case @Language 
						when 'E' then 'Existing members exceeded new agent position taking ('+@ErrAcc+') (for Virtual Cycling).'
						ELSE [dbo].[f_Get_MsgNamebyMsgID](20017,@Language) + ' ('+@ErrAcc+')' + ' (' + [dbo].[f_Get_SportNameBySporttype](185,@Language) + ')'
				end, @ErrCode = 109
	return
END


	
 /*************************************
 * Update Setting
 *************************************/
 
 UPDATE custinfo WITH(ROWLOCK,UPDLOCK) SET maxpermatch185 = @v185MaxPerMatch
 WHERE custid = @CustID
 if (@@error <> 0)
begin
	
	Select @ErrMsg = case @Language 
						when 'E' then 'Update process is unsuccessful !'
						ELSE [dbo].[f_Get_MsgNamebyMsgID](90001,@Language)
					end	, @ErrCode = 103 
	return
END

 /*************************************
 * Update Bet Setting
 *************************************/
IF EXISTS (SELECT 1 FROM Dep_CustSetting3rd WITH (NOLOCK) WHERE sporttype = 185 AND custid = @CustID)
BEGIN
	UPDATE Dep_CustSetting3rd WITH(ROWLOCK,UPDLOCK)
	SET
 		mpositiontaking = 0,
 		apositiontaking = @v185aPositionTaking,
 		minbet = @v185MinBet,
 		maxbet = @v185MaxBet
	WHERE custid = @CustID
		AND sporttype = 185
END
ELSE
BEGIN
	INSERT INTO Dep_CustSetting3rd (custId, bettype, sporttype, apositiontaking, mpositiontaking, spositiontaking, playerdiscount, discount, adiscount, sdiscount, Minbet, Maxbet, islive)
	VALUES (@CustID, 
			1231, 
			185, 
			@v185aPositionTaking, 
			0, 
			0, 
			0, 0, 0, 0, 
			@v185MinBet, 
			@v185MaxBet,
			0)
END

if (@@error <> 0)
begin
	
	Select @ErrMsg = case @Language 
						when 'E' then 'Update process is unsuccessful !'
						ELSE [dbo].[f_Get_MsgNamebyMsgID](90001,@Language)
					end	, @ErrCode = 103 
	return
END	



------Virtual Tennis
SELECT @v186MinBet_Max = MAX(CASE WHEN cs3.minbet = 0 THEN NULL ELSE cs3.minbet END),
	@v186MaxBet_Min = MIN(CASE WHEN cs3.maxbet = 0 THEN NULL ELSE cs3.maxbet END),
	@v186MaxPerMatch_Max = MIN(CASE WHEN ci.maxpermatch186 = 0 THEN NULL ELSE ci.maxpermatch186 END),
	@v186aPositionTaking_Max = MAX(cs3.apositiontaking)
FROM custInfo ci WITH(NOLOCK)
	INNER JOIN Dep_CustSetting3rd cs3 ON ci.custid = cs3.custid
WHERE ci.custid IN (@mrecommend, @srecommend)
	AND cs3.sporttype = 186

IF @v186MinBet < 0 
	OR @v186MaxBet < 0
	OR @v186MinBet > @v186MaxBet
	OR @v186MinBet > @v186MaxPerMatch
	OR @v186MaxBet > @v186MaxPerMatch
BEGIN 
	Select @ErrMsg = 	case @Language 
						when 'E' then 'Wrong Min bet/ Max bet/ Max per match (for Virtual Tennis).'
						ELSE [dbo].[f_Get_MsgNamebyMsgID](10003,@Language) + ' (' + [dbo].[f_Get_SportNameBySporttype](186,@Language) + ')'
				end, @ErrCode = 102
	return
END 

IF (@v186MinBet < @v186MinBet_Max and @v186minbet > 0 AND @v186MinBet_Max > 0)
	OR (@v186MaxBet > @v186MaxBet_Min and @v186maxbet > 0 AND @v186MaxBet_Min > 0)
	OR (@v186MaxPerMatch > @v186MaxPerMatch_Max and @v186MaxPerMatch > 0 AND @v186MaxPerMatch_Max > 0)
BEGIN
	 SELECT @ErrMsg = case @Language 
						when 'E' then 'Min bet must be equal to or greater than Super Agent min bet (for Virtual Tennis)'
						ELSE [dbo].[f_Get_MsgNamebyMsgID](10016,@Language) + ' (' + [dbo].[f_Get_SportNameBySporttype](186,@Language) + ')'
					end						
			, @ErrCode = 119
	return
END 
-------------------------------------------
--Check all a1<=a4
select @ErrAcc = ''
select top 100 @ErrAcc = @ErrAcc + username +', '
from 
	custinfo as c with (NOLOCK) 
	inner join Dep_CustSetting3rd as cs with (NOLOCK) on c.custid = cs.custid
	inner join (
				   select 186 as sporttype, 1220 as bettype, @v186apositiontaking as maxpositiontaking
		) as b on cs.sporttype = b.sporttype and cs.bettype = b.bettype
where c.recommend = @custid 
	AND cs.sporttype = 186
	and c.roleid = 1
	and (
			(cs.apositiontaking>b.maxpositiontaking)  
		)
group by username
if @ErrAcc<>''
BEGIN
	Select @ErrMsg = '' +
				case @Language 
						when 'E' then 'Existing members exceeded new agent position taking ('+@ErrAcc+') (for Virtual Tennis).'
						ELSE [dbo].[f_Get_MsgNamebyMsgID](20017,@Language) + ' ('+@ErrAcc+')' + ' (' + [dbo].[f_Get_SportNameBySporttype](186,@Language) + ')'
				end, @ErrCode = 109
	return
END


	
 /*************************************
 * Update Setting
 *************************************/
 UPDATE custinfo WITH(ROWLOCK,UPDLOCK) SET maxpermatch186 = @v186MaxPerMatch
 WHERE custid = @CustID
 if (@@error <> 0)
begin
	
	Select @ErrMsg = case @Language 
						when 'E' then 'Update process is unsuccessful !'
						ELSE [dbo].[f_Get_MsgNamebyMsgID](90001,@Language)
					end	, @ErrCode = 103 
	return
END

 /*************************************
 * Update Bet Setting
 *************************************/
IF EXISTS (SELECT 1 FROM Dep_CustSetting3rd WITH (NOLOCK) WHERE sporttype = 186 AND custid = @CustID)
BEGIN
 UPDATE Dep_CustSetting3rd WITH(ROWLOCK,UPDLOCK)
	SET
	 	mpositiontaking = 0,
	 	apositiontaking = @v186aPositionTaking,
	 	minbet = @v186MinBet,
	 	maxbet = @v186MaxBet
	WHERE custid = @CustID
		AND sporttype = 186
END
ELSE
BEGIN
	INSERT INTO Dep_CustSetting3rd (custId, bettype, sporttype, apositiontaking, mpositiontaking, spositiontaking, playerdiscount, discount, adiscount, sdiscount, Minbet, Maxbet, islive)
	VALUES (@CustID, 
			1220, 
			186, 
			@v186aPositionTaking, 
			0, 
			0, 
			0, 0, 0, 0, 
			@v186MinBet, 
			@v186MaxBet,
			0)
END

	
if (@@error <> 0)
begin
	
	Select @ErrMsg = case @Language 
						when 'E' then 'Update process is unsuccessful !'
						ELSE [dbo].[f_Get_MsgNamebyMsgID](90001,@Language)
					end	, @ErrCode = 103 
	return
END

GO 
 GRANT VIEW DEFINITION ON [dbo].[Acc_Dep_CustomerUpdMemberVirtualSports_MAg] TO [vnteam]
GO 
 GRANT EXECUTE ON [dbo].[Acc_Dep_CustomerUpdMemberVirtualSports_MAg] TO [bodbAdminNet]
GO 
 GRANT EXECUTE ON [dbo].[Acc_Dep_CustomerUpdMemberVirtualSports_MAg] TO [bodbExtAccNet]
GO 
