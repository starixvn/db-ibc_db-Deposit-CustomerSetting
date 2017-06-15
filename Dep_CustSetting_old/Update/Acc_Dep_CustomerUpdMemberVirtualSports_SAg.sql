ALTER PROCEDURE [dbo].[Acc_Dep_CustomerUpdMemberVirtualSports_SAg]
	@UserID INT,
	
	@CustId INT,
	
	@v180MinBet MONEY,
	@v180MaxBet MONEY,
	@v180MaxPerMatch MONEY,
	@v180sPositionTaking MONEY,
	@v180mPositionTaking SMALLMONEY,

	@v181MinBet MONEY,
	@v181MaxBet MONEY,
	@v181MaxPerMatch MONEY,
	@v181sPositionTaking MONEY,
	@v181mPositionTaking SMALLMONEY,

	@v182MinBet MONEY,
	@v182MaxBet MONEY,
	@v182MaxPerMatch MONEY,
	@v182sPositionTaking MONEY,
	@v182mPositionTaking SMALLMONEY,

	@v183MinBet MONEY,
	@v183MaxBet MONEY,
	@v183MaxPerMatch MONEY,
	@v183sPositionTaking MONEY,
	@v183mPositionTaking SMALLMONEY,

	@v184MinBet MONEY,
	@v184MaxBet MONEY,
	@v184MaxPerMatch MONEY,
	@v184sPositionTaking MONEY,
	@v184mPositionTaking SMALLMONEY,

	@v185MinBet MONEY,
	@v185MaxBet MONEY,
	@v185MaxPerMatch MONEY,
	@v185sPositionTaking MONEY,
	@v185mPositionTaking SMALLMONEY,

	@v186MinBet MONEY,
	@v186MaxBet MONEY,
	@v186MaxPerMatch MONEY,
	@v186sPositionTaking MONEY,
	@v186mPositionTaking SMALLMONEY,
	
	@Language VARCHAR(2) = 'E',
	@ErrCode INT = 0 OUTPUT,
	@ErrMsg NVARCHAR(4000) = '' OUTPUT
 AS

--@Source Control
/*
Created: 20120828@Dom
Task : Super update MinBet, MaxBet, MaxPerMatch, PT of Master for virtual sports
DB: DBTrans.bodb02

Revisions:
    - 20121128@Elodie: Get an error message from f_Get_MsgNameByMsgID function by language
	- 20131014@Francis: Support updating new virtual sports with settings
	- 20131231@Francis: Hotfix failing to update settings of new Virtual Sports for an old master
    
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
 
 DECLARE @v180MinBet_Max MONEY,
		@v180MaxBet_Max MONEY,
		@v180MaxPerMatch_Max MONEY,
		
		@v181MinBet_Max MONEY,
		@v181MaxBet_Max MONEY,
		@v181MaxPerMatch_Max MONEY,

		@v182MinBet_Max MONEY,
		@v182MaxBet_Max MONEY,
		@v182MaxPerMatch_Max MONEY,
		
		@v183MinBet_Max MONEY,
		@v183MaxBet_Max MONEY,
		@v183MaxPerMatch_Max MONEY,
		
		@v184MinBet_Max MONEY,
		@v184MaxBet_Max MONEY,
		@v184MaxPerMatch_Max MONEY,
		
		@v185MinBet_Max MONEY,
		@v185MaxBet_Max MONEY,
		@v185MaxPerMatch_Max MONEY,
				
		@v186MinBet_Max MONEY,
		@v186MaxBet_Max MONEY,
		@v186MaxPerMatch_Max MONEY,
		
		@ErrAcc varchar(4000), 
		@ErrType varchar(4000)
		



--Virtual Soccer
/***********************************
* Validate Setting
***********************************/
IF @v180MinBet < 0
	OR @v180MaxBet < 0
	OR @v180MinBet > @v180MaxPerMatch
	OR @v180MaxBet > @v180MaxPerMatch
BEGIN 
	SELECT @ErrMsg = CASE @Language 
					WHEN 'E' THEN 'Wrong Min bet/ Max bet/ Max per match.'
					ELSE [dbo].[f_Get_MsgNamebyMsgID](10003,@Language)
			END, @ErrCode = 101
	RETURN
END	
	
/***********************************
* Validate Bet Setting
***********************************/

IF @v180sPositionTaking < 0
	OR @v180mPositionTaking < 0
BEGIN
	 Select @ErrMsg = case @Language 
						when 'E' then 'Wrong  position taking.<br>'
						ELSE [dbo].[f_Get_MsgNamebyMsgID](20001,@Language) + '<br>'
					end, @ErrCode = 104
		return
END


SELECT @ErrAcc = ''
SELECT top 100 @ErrAcc = @ErrAcc + username +', '
FROM custInfo ci WITH(NOLOCK)
	INNER JOIN Dep_CustSetting3rd cs3 WITH(NOLOCK) ON ci.custid = cs3.custid
	INNER JOIN (
		SELECT 180 AS sporttype, 1201 AS bettype, @v180mPositionTaking AS mpositiontaking_max	
	) b ON b.sporttype = cs3.sporttype AND cs3.bettype = b.bettype
WHERE ci.mrecommend = @CustId
	AND ci.roleid = 2
	AND cs3.sporttype = 180
	AND cs3.apositiontaking + cs3.mpositiontaking > b.mpositiontaking_max
IF @ErrAcc <> ''
BEGIN
	select @ErrCode = 14
	Select @ErrMsg = case @Language 
						when 'E' then 'Existing agents exceeded new master position taking ('+@ErrAcc+') (for Virtual Soccer).'
						ELSE [dbo].[f_Get_MsgNamebyMsgID](20011,@Language) + ' ('+@ErrAcc+')' + ' (' + [dbo].[f_Get_SportNameBySporttype](180,@Language) + ')'
					end
	return
END


SELECT @ErrAcc = ''
SELECT top 100 @ErrAcc = @ErrAcc + username +', '
FROM custInfo ci WITH(NOLOCK)
	INNER JOIN Dep_CustSetting3rd cs3 WITH(NOLOCK) ON ci.custid = cs3.custid
	INNER JOIN (
		SELECT 180 AS sporttype, 1201 AS bettype, @v180mPositionTaking AS mpositiontaking_max	
	) b ON b.sporttype = cs3.sporttype AND cs3.bettype = b.bettype
WHERE ci.mrecommend = @CustId
	AND ci.roleid = 1
	AND cs3.sporttype = 180
	AND cs3.apositiontaking + cs3.mpositiontaking > b.mpositiontaking_max
IF @ErrAcc <> ''
BEGIN
	select @ErrCode = 15
	Select @ErrMsg =  case @Language 
						when 'E' then 'Existing members exceeded new master position taking ('+@ErrAcc+') (for Virtual Soccer).'
						ELSE [dbo].[f_Get_MsgNamebyMsgID](20012,@Language) + ' ('+@ErrAcc+')' + ' (' + [dbo].[f_Get_SportNameBySporttype](180,@Language) + ')'
					end
	return
END
	 
 /**********************************
 * Update setting
 **********************************/
 UPDATE custinfo WITH (ROWLOCK,UPDLOCK)
 SET maxpermatch180 = @v180MaxPerMatch
 WHERE custid = @CustId

 if (@@error <> 0)
begin
	
	Select @ErrMsg = case @Language 
						when 'E' then 'Update process is unsuccessful !'
						ELSE [dbo].[f_Get_MsgNamebyMsgID](90001,@Language)
					end	, @ErrCode = 103 
	return
END

 /*********************************
 * Update Bet Setting
 *********************************/
IF EXISTS (SELECT 1 FROM Dep_CustSetting3rd WITH (NOLOCK) WHERE sporttype = 180 AND custid = @CustID)
BEGIN
	UPDATE Dep_CustSetting3rd WITH (ROWLOCK, UPDLOCK)
	SET	
		mpositiontaking = @v180mPositionTaking,
 		spositiontaking = 0,
 		minbet = @v180MinBet,
 		maxbet = @v180MaxBet
	WHERE custid = @CustId
		AND sporttype = 180
END
ELSE
BEGIN
	INSERT INTO Dep_CustSetting3rd (custId, bettype, sporttype, apositiontaking, mpositiontaking, spositiontaking, playerdiscount, discount, adiscount, sdiscount, Minbet, Maxbet, islive)
	VALUES (@CustID, 
			1201, 
			180, 
			0, 
			@v180mPositionTaking, 
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


--Virtual Horse Racing
/***********************************
* Validate Setting
***********************************/
IF @v181MinBet < 0
	OR @v181MaxBet < 0
	OR @v181MinBet > @v181MaxPerMatch
	OR @v181MaxBet > @v181MaxPerMatch
BEGIN 
	SELECT @ErrMsg = CASE @Language 
					WHEN 'E' THEN 'Wrong Min bet/ Max bet/ Max per match.'
					ELSE [dbo].[f_Get_MsgNamebyMsgID](10003,@Language)
			END, @ErrCode = 101
	RETURN
END	
	
/***********************************
* Validate Bet Setting
***********************************/

IF @v181sPositionTaking < 0
	OR @v181mPositionTaking < 0
BEGIN
	 Select @ErrMsg = case @Language 
						when 'E' then 'Wrong  position taking.<br>'
						ELSE [dbo].[f_Get_MsgNamebyMsgID](20001,@Language) + '<br>'
					end, @ErrCode = 104
		return
END


SELECT @ErrAcc = ''
SELECT top 100 @ErrAcc = @ErrAcc + username +', '
FROM custInfo ci WITH(NOLOCK)
	INNER JOIN Dep_CustSetting3rd cs3 WITH(NOLOCK) ON ci.custid = cs3.custid
	INNER JOIN (
		SELECT 181 AS sporttype, 1231 AS bettype,@v181mPositionTaking AS mpositiontaking_max	
	) b ON b.sporttype = cs3.sporttype AND cs3.bettype = b.bettype
WHERE ci.mrecommend = @CustId
	AND ci.roleid = 2
	AND cs3.sporttype = 181
	AND cs3.apositiontaking + cs3.mpositiontaking > b.mpositiontaking_max
IF @ErrAcc <> ''
BEGIN
	select @ErrCode = 14
	Select @ErrMsg = case @Language 
						when 'E' then 'Existing agents exceeded new master position taking ('+@ErrAcc+') (for Virtual Horse Racing).'
						ELSE [dbo].[f_Get_MsgNamebyMsgID](20011,@Language) + ' ('+@ErrAcc+')' + ' (' + [dbo].[f_Get_SportNameBySporttype](181,@Language) + ')'
					end
	return
END


SELECT @ErrAcc = ''
SELECT top 100 @ErrAcc = @ErrAcc + username +', '
FROM custInfo ci WITH(NOLOCK)
	INNER JOIN Dep_CustSetting3rd cs3 WITH(NOLOCK) ON ci.custid = cs3.custid
	INNER JOIN (
		SELECT 181 AS sporttype, 1231 AS bettype,@v181mPositionTaking AS mpositiontaking_max	
	) b ON b.sporttype = cs3.sporttype AND cs3.bettype = b.bettype
WHERE ci.mrecommend = @CustId
	AND ci.roleid = 1
	AND cs3.sporttype = 181
	AND cs3.apositiontaking + cs3.mpositiontaking > b.mpositiontaking_max
IF @ErrAcc <> ''
BEGIN
	select @ErrCode = 15
	Select @ErrMsg =  case @Language 
						when 'E' then 'Existing members exceeded new master position taking ('+@ErrAcc+') (for Virtual Horse Racing).'
						ELSE [dbo].[f_Get_MsgNamebyMsgID](20012,@Language) + ' ('+@ErrAcc+')' + ' (' + [dbo].[f_Get_SportNameBySporttype](181,@Language) + ')'
					end
	return
END
	 
 /**********************************
 * Update setting
 **********************************/
 UPDATE custinfo WITH (ROWLOCK,UPDLOCK)
 SET maxpermatch181 = @v181MaxPerMatch
 WHERE custid = @CustId

 if (@@error <> 0)
begin
	
	Select @ErrMsg = case @Language 
						when 'E' then 'Update process is unsuccessful !'
						ELSE [dbo].[f_Get_MsgNamebyMsgID](90001,@Language)
					end	, @ErrCode = 103 
	return
END

 /*********************************
 * Update Bet Setting
 *********************************/
IF EXISTS (SELECT 1 FROM Dep_CustSetting3rd WITH (NOLOCK) WHERE sporttype = 181 AND custid = @CustID)
BEGIN
	UPDATE Dep_CustSetting3rd WITH(ROWLOCK,UPDLOCK)
	SET
 		mpositiontaking = @v181mPositionTaking,
 		spositiontaking = 0,
 		minbet = @v181MinBet,
 		maxbet = @v181MaxBet
	WHERE custid = @CustId
		AND sporttype = 181
END
ELSE
BEGIN
	INSERT INTO Dep_CustSetting3rd (custId, bettype, sporttype, apositiontaking, mpositiontaking, spositiontaking, playerdiscount, discount, adiscount, sdiscount, Minbet, Maxbet, islive)
	VALUES (@CustID, 
			1231, 
			181, 
			0, 
			@v181mPositionTaking, 
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


--Virtual Greyhounds
/***********************************
* Validate Setting
***********************************/
IF @v182MinBet < 0
	OR @v182MaxBet < 0
	OR @v182MinBet > @v182MaxPerMatch
	OR @v182MaxBet > @v182MaxPerMatch
BEGIN 
	SELECT @ErrMsg = CASE @Language 
					WHEN 'E' THEN 'Wrong Min bet/ Max bet/ Max per match.'
					ELSE [dbo].[f_Get_MsgNamebyMsgID](10003,@Language)
			END, @ErrCode = 101
	RETURN
END	
	
/***********************************
* Validate Bet Setting
***********************************/

IF @v182sPositionTaking < 0
	OR @v182mPositionTaking < 0
BEGIN
	 Select @ErrMsg = case @Language 
						when 'E' then 'Wrong  position taking.<br>'
						ELSE [dbo].[f_Get_MsgNamebyMsgID](20001,@Language) + '<br>'
					end, @ErrCode = 104
		return
END


SELECT @ErrAcc = ''
SELECT top 100 @ErrAcc = @ErrAcc + username +', '
FROM custInfo ci WITH(NOLOCK)
	INNER JOIN Dep_CustSetting3rd cs3 WITH(NOLOCK) ON ci.custid = cs3.custid
	INNER JOIN (
		SELECT 182 AS sporttype, 1231 AS bettype, @v182mPositionTaking AS mpositiontaking_max	
	) b ON b.sporttype = cs3.sporttype AND cs3.bettype = b.bettype
WHERE ci.mrecommend = @CustId
	AND ci.roleid = 2
	AND cs3.sporttype = 182
	AND cs3.apositiontaking + cs3.mpositiontaking > b.mpositiontaking_max
IF @ErrAcc <> ''
BEGIN
	select @ErrCode = 14
	Select @ErrMsg = case @Language 
						when 'E' then 'Existing agents exceeded new master position taking ('+@ErrAcc+') (for Virtual Greyhounds).'
						ELSE [dbo].[f_Get_MsgNamebyMsgID](20011,@Language) + ' ('+@ErrAcc+')' + ' (' + [dbo].[f_Get_SportNameBySporttype](182,@Language) + ')'
					end
	return
END


SELECT @ErrAcc = ''
SELECT top 100 @ErrAcc = @ErrAcc + username +', '
FROM custInfo ci WITH(NOLOCK)
	INNER JOIN Dep_CustSetting3rd cs3 WITH(NOLOCK) ON ci.custid = cs3.custid
	INNER JOIN (
		SELECT 182 AS sporttype, 1231 AS bettype, @v182mPositionTaking AS mpositiontaking_max	
	) b ON b.sporttype = cs3.sporttype AND cs3.bettype = b.bettype
WHERE ci.mrecommend = @CustId
	AND ci.roleid = 1
	AND cs3.sporttype = 182
	AND cs3.apositiontaking + cs3.mpositiontaking > b.mpositiontaking_max
IF @ErrAcc <> ''
BEGIN
	select @ErrCode = 15
	Select @ErrMsg =  case @Language 
						when 'E' then 'Existing members exceeded new master position taking ('+@ErrAcc+') (for Virtual Greyhounds).'
						ELSE [dbo].[f_Get_MsgNamebyMsgID](20012,@Language) + ' ('+@ErrAcc+')' + ' (' + [dbo].[f_Get_SportNameBySporttype](182,@Language) + ')'
					end
	return
END
	 
 /**********************************
 * Update setting
 **********************************/
 UPDATE custinfo WITH (ROWLOCK,UPDLOCK)
 SET maxpermatch182 = @v182MaxPerMatch
 WHERE custid = @CustId

 if (@@error <> 0)
begin
	
	Select @ErrMsg = case @Language 
						when 'E' then 'Update process is unsuccessful !'
						ELSE [dbo].[f_Get_MsgNamebyMsgID](90001,@Language)
					end	, @ErrCode = 103 
	return
END

 /*********************************
 * Update Bet Setting
 *********************************/
 IF EXISTS (SELECT 1 FROM Dep_CustSetting3rd WITH (NOLOCK) WHERE sporttype = 182 AND custid = @CustID)
BEGIN
	UPDATE Dep_CustSetting3rd WITH(ROWLOCK,UPDLOCK)
	SET
 		mpositiontaking = @v182mPositionTaking,
 		spositiontaking = 0,
 		minbet = @v182MinBet,
 		maxbet = @v182MaxBet
	WHERE custid = @CustId
		AND sporttype = 182
END
ELSE
BEGIN
	INSERT INTO Dep_CustSetting3rd (custId, bettype, sporttype, apositiontaking, mpositiontaking, spositiontaking, playerdiscount, discount, adiscount, sdiscount, Minbet, Maxbet, islive)
	VALUES (@CustID, 
			1231, 
			182, 
			0, 
			@v182mPositionTaking, 
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

--Virtual Speedway
/***********************************
* Validate Setting
***********************************/
IF @v183MinBet < 0
	OR @v183MaxBet < 0
	OR @v183MinBet > @v183MaxPerMatch
	OR @v183MaxBet > @v183MaxPerMatch
BEGIN 
	SELECT @ErrMsg = CASE @Language 
					WHEN 'E' THEN 'Wrong Min bet/ Max bet/ Max per match.'
					ELSE [dbo].[f_Get_MsgNamebyMsgID](10003,@Language)
			END, @ErrCode = 101
	RETURN
END	
	
/***********************************
* Validate Bet Setting
***********************************/

IF @v183sPositionTaking < 0
	OR @v183mPositionTaking < 0
BEGIN
	 Select @ErrMsg = case @Language 
						when 'E' then 'Wrong  position taking.<br>'
						ELSE [dbo].[f_Get_MsgNamebyMsgID](20001,@Language) + '<br>'
					end, @ErrCode = 104
		return
END


SELECT @ErrAcc = ''
SELECT top 100 @ErrAcc = @ErrAcc + username +', '
FROM custInfo ci WITH(NOLOCK)
	INNER JOIN Dep_CustSetting3rd cs3 WITH(NOLOCK) ON ci.custid = cs3.custid
	INNER JOIN (
		SELECT 183 AS sporttype, 1231 AS bettype, @v183mPositionTaking AS mpositiontaking_max	
	) b ON b.sporttype = cs3.sporttype AND cs3.bettype = b.bettype
WHERE ci.mrecommend = @CustId
	AND ci.roleid = 2
	AND cs3.sporttype = 183
	AND cs3.apositiontaking + cs3.mpositiontaking > b.mpositiontaking_max
IF @ErrAcc <> ''
BEGIN
	select @ErrCode = 14
	Select @ErrMsg = case @Language 
						when 'E' then 'Existing agents exceeded new master position taking ('+@ErrAcc+') (for Virtual Speedway).'
						ELSE [dbo].[f_Get_MsgNamebyMsgID](20011,@Language) + ' ('+@ErrAcc+')' + ' (' + [dbo].[f_Get_SportNameBySporttype](183,@Language) + ')'
					end
	return
END


SELECT @ErrAcc = ''
SELECT top 100 @ErrAcc = @ErrAcc + username +', '
FROM custInfo ci WITH(NOLOCK)
	INNER JOIN Dep_CustSetting3rd cs3 WITH(NOLOCK) ON ci.custid = cs3.custid
	INNER JOIN (
		SELECT 183 AS sporttype, 1231 AS bettype, @v183mPositionTaking AS mpositiontaking_max	
	) b ON b.sporttype = cs3.sporttype AND cs3.bettype = b.bettype
WHERE ci.mrecommend = @CustId
	AND ci.roleid = 1
	AND cs3.sporttype = 183
	AND cs3.apositiontaking + cs3.mpositiontaking > b.mpositiontaking_max
IF @ErrAcc <> ''
BEGIN
	select @ErrCode = 15
	Select @ErrMsg =  case @Language 
						when 'E' then 'Existing members exceeded new master position taking ('+@ErrAcc+') (for Virtual Speedway).'
						ELSE [dbo].[f_Get_MsgNamebyMsgID](20012,@Language) + ' ('+@ErrAcc+')' + ' (' + [dbo].[f_Get_SportNameBySporttype](183,@Language) + ')'
					end
	return
END
	 
 /**********************************
 * Update setting
 **********************************/
 UPDATE custinfo WITH (ROWLOCK,UPDLOCK)
 SET maxpermatch183 = @v183MaxPerMatch
 WHERE custid = @CustId

 if (@@error <> 0)
begin
	
	Select @ErrMsg = case @Language 
						when 'E' then 'Update process is unsuccessful !'
						ELSE [dbo].[f_Get_MsgNamebyMsgID](90001,@Language)
					end	, @ErrCode = 103 
	return
END

 /*********************************
 * Update Bet Setting
 *********************************/
IF EXISTS (SELECT 1 FROM Dep_CustSetting3rd WITH (NOLOCK) WHERE sporttype = 183 AND custid = @CustID)
BEGIN
	 UPDATE Dep_CustSetting3rd WITH(ROWLOCK,UPDLOCK)
	SET
 		mpositiontaking = @v183mPositionTaking,
 		spositiontaking = 0,
 		minbet = @v183MinBet,
 		maxbet = @v183MaxBet
	WHERE custid = @CustId
		AND sporttype = 183
END
ELSE
BEGIN
	INSERT INTO Dep_CustSetting3rd (custId, bettype, sporttype, apositiontaking, mpositiontaking, spositiontaking, playerdiscount, discount, adiscount, sdiscount, Minbet, Maxbet, islive)
	VALUES (@CustID, 
			1231, 
			183, 
			0, 
			@v183mPositionTaking, 
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

--Virtual Motor Racing
/***********************************
* Validate Setting
***********************************/
IF @v184MinBet < 0
	OR @v184MaxBet < 0
	OR @v184MinBet > @v184MaxPerMatch
	OR @v184MaxBet > @v184MaxPerMatch
BEGIN 
	SELECT @ErrMsg = CASE @Language 
					WHEN 'E' THEN 'Wrong Min bet/ Max bet/ Max per match.'
					ELSE [dbo].[f_Get_MsgNamebyMsgID](10003,@Language)
			END, @ErrCode = 101
	RETURN
END	
	
/***********************************
* Validate Bet Setting
***********************************/

IF @v184sPositionTaking < 0
	OR @v184mPositionTaking < 0
BEGIN
	 Select @ErrMsg = case @Language 
						when 'E' then 'Wrong  position taking.<br>'
						ELSE [dbo].[f_Get_MsgNamebyMsgID](20001,@Language) + '<br>'
					end, @ErrCode = 104
		return
END


SELECT @ErrAcc = ''
SELECT top 100 @ErrAcc = @ErrAcc + username +', '
FROM custInfo ci WITH(NOLOCK)
	INNER JOIN Dep_CustSetting3rd cs3 WITH(NOLOCK) ON ci.custid = cs3.custid
	INNER JOIN (
		SELECT 184 AS sporttype, 1231 AS bettype, @v184mPositionTaking AS mpositiontaking_max	
	) b ON b.sporttype = cs3.sporttype AND cs3.bettype = b.bettype
WHERE ci.mrecommend = @CustId
	AND ci.roleid = 2
	AND cs3.sporttype = 184
	AND cs3.apositiontaking + cs3.mpositiontaking > b.mpositiontaking_max
IF @ErrAcc <> ''
BEGIN
	select @ErrCode = 14
	Select @ErrMsg = case @Language 
						when 'E' then 'Existing agents exceeded new master position taking ('+@ErrAcc+') (for Virtual Motor Racing).'
						ELSE [dbo].[f_Get_MsgNamebyMsgID](20011,@Language) + ' ('+@ErrAcc+')' + ' (' + [dbo].[f_Get_SportNameBySporttype](184,@Language) + ')'
					end
	return
END


SELECT @ErrAcc = ''
SELECT top 100 @ErrAcc = @ErrAcc + username +', '
FROM custInfo ci WITH(NOLOCK)
	INNER JOIN Dep_CustSetting3rd cs3 WITH(NOLOCK) ON ci.custid = cs3.custid
	INNER JOIN (
		SELECT 184 AS sporttype, 1231 AS bettype, @v184mPositionTaking AS mpositiontaking_max	
	) b ON b.sporttype = cs3.sporttype AND cs3.bettype = b.bettype
WHERE ci.mrecommend = @CustId
	AND ci.roleid = 1
	AND cs3.sporttype = 184
	AND cs3.apositiontaking + cs3.mpositiontaking > b.mpositiontaking_max
IF @ErrAcc <> ''
BEGIN
	select @ErrCode = 15
	Select @ErrMsg =  case @Language 
						when 'E' then 'Existing members exceeded new master position taking ('+@ErrAcc+') (for Virtual Motor Racing).'
						ELSE [dbo].[f_Get_MsgNamebyMsgID](20012,@Language) + ' ('+@ErrAcc+')' + ' (' + [dbo].[f_Get_SportNameBySporttype](184,@Language) + ')'
					end
	return
END
	 
 /**********************************
 * Update setting
 **********************************/
 UPDATE custinfo WITH (ROWLOCK,UPDLOCK)
 SET maxpermatch184 = @v184MaxPerMatch
 WHERE custid = @CustId

 if (@@error <> 0)
begin
	
	Select @ErrMsg = case @Language 
						when 'E' then 'Update process is unsuccessful !'
						ELSE [dbo].[f_Get_MsgNamebyMsgID](90001,@Language)
					end	, @ErrCode = 103 
	return
END

 /*********************************
 * Update Bet Setting
 *********************************/
IF EXISTS (SELECT 1 FROM Dep_CustSetting3rd WITH (NOLOCK) WHERE sporttype = 184 AND custid = @CustID)
BEGIN
	UPDATE Dep_CustSetting3rd WITH(ROWLOCK,UPDLOCK)
	SET
	 	mpositiontaking = @v184mPositionTaking,
 		spositiontaking = 0,
 		minbet = @v184MinBet,
 		maxbet = @v184MaxBet
	WHERE custid = @CustId
		AND sporttype = 184
END
ELSE
BEGIN
	INSERT INTO Dep_CustSetting3rd (custId, bettype, sporttype, apositiontaking, mpositiontaking, spositiontaking, playerdiscount, discount, adiscount, sdiscount, Minbet, Maxbet, islive)
	VALUES (@CustID, 
			1231, 
			184, 
			0, 
			@v184mPositionTaking, 
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

--Virtual Cycling
/***********************************
* Validate Setting
***********************************/
IF @v185MinBet < 0
	OR @v185MaxBet < 0
	OR @v185MinBet > @v185MaxPerMatch
	OR @v185MaxBet > @v185MaxPerMatch
BEGIN 
	SELECT @ErrMsg = CASE @Language 
					WHEN 'E' THEN 'Wrong Min bet/ Max bet/ Max per match.'
					ELSE [dbo].[f_Get_MsgNamebyMsgID](10003,@Language)
			END, @ErrCode = 101
	RETURN
END	
	
/***********************************
* Validate Bet Setting
***********************************/

IF @v185sPositionTaking < 0
	OR @v185mPositionTaking < 0
BEGIN
	 Select @ErrMsg = case @Language 
						when 'E' then 'Wrong  position taking.<br>'
						ELSE [dbo].[f_Get_MsgNamebyMsgID](20001,@Language) + '<br>'
					end, @ErrCode = 104
		return
END


SELECT @ErrAcc = ''
SELECT top 100 @ErrAcc = @ErrAcc + username +', '
FROM custInfo ci WITH(NOLOCK)
	INNER JOIN Dep_CustSetting3rd cs3 WITH(NOLOCK) ON ci.custid = cs3.custid
	INNER JOIN (
		SELECT 185 AS sporttype, 1231 AS bettype, @v185mPositionTaking AS mpositiontaking_max	
	) b ON b.sporttype = cs3.sporttype AND cs3.bettype = b.bettype
WHERE ci.mrecommend = @CustId
	AND ci.roleid = 2
	AND cs3.sporttype = 185
	AND cs3.apositiontaking + cs3.mpositiontaking > b.mpositiontaking_max
IF @ErrAcc <> ''
BEGIN
	select @ErrCode = 14
	Select @ErrMsg = case @Language 
						when 'E' then 'Existing agents exceeded new master position taking ('+@ErrAcc+') (for Virtual Cycling).'
						ELSE [dbo].[f_Get_MsgNamebyMsgID](20011,@Language) + ' ('+@ErrAcc+')' + ' (' + [dbo].[f_Get_SportNameBySporttype](185,@Language) + ')'
					end
	return
END


SELECT @ErrAcc = ''
SELECT top 100 @ErrAcc = @ErrAcc + username +', '
FROM custInfo ci WITH(NOLOCK)
	INNER JOIN Dep_CustSetting3rd cs3 WITH(NOLOCK) ON ci.custid = cs3.custid
	INNER JOIN (
		SELECT 185 AS sporttype, 1231 AS bettype, @v185mPositionTaking AS mpositiontaking_max	
	) b ON b.sporttype = cs3.sporttype AND cs3.bettype = b.bettype
WHERE ci.mrecommend = @CustId
	AND ci.roleid = 1
	AND cs3.sporttype = 185
	AND cs3.apositiontaking + cs3.mpositiontaking > b.mpositiontaking_max
IF @ErrAcc <> ''
BEGIN
	select @ErrCode = 15
	Select @ErrMsg =  case @Language 
						when 'E' then 'Existing members exceeded new master position taking ('+@ErrAcc+') (for Virtual Cycling).'
						ELSE [dbo].[f_Get_MsgNamebyMsgID](20012,@Language) + ' ('+@ErrAcc+')' + ' (' + [dbo].[f_Get_SportNameBySporttype](185,@Language) + ')'
					end
	return
END
	 
 /**********************************
 * Update setting
 **********************************/
 UPDATE custinfo WITH (ROWLOCK,UPDLOCK)
 SET maxpermatch185 = @v185MaxPerMatch
 WHERE custid = @CustId

 if (@@error <> 0)
begin
	
	Select @ErrMsg = case @Language 
						when 'E' then 'Update process is unsuccessful !'
						ELSE [dbo].[f_Get_MsgNamebyMsgID](90001,@Language)
					end	, @ErrCode = 103 
	return
END

 /*********************************
 * Update Bet Setting
 *********************************/
IF EXISTS (SELECT 1 FROM Dep_CustSetting3rd WITH (NOLOCK) WHERE sporttype = 185 AND custid = @CustID)
BEGIN
	 UPDATE Dep_CustSetting3rd WITH(ROWLOCK,UPDLOCK)
	SET
 		mpositiontaking = @v185mPositionTaking,
 		spositiontaking = 0,
 		minbet = @v185MinBet,
 		maxbet = @v185MaxBet
	WHERE custid = @CustId
		AND sporttype = 185
END
ELSE
BEGIN
	INSERT INTO Dep_CustSetting3rd (custId, bettype, sporttype, apositiontaking, mpositiontaking, spositiontaking, playerdiscount, discount, adiscount, sdiscount, Minbet, Maxbet, islive)
	VALUES (@CustID, 
			1231, 
			185, 
			0, 
			@v185mPositionTaking, 
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



--Virtual Tennis
/***********************************
* Validate Setting
***********************************/
IF @v186MinBet < 0
	OR @v186MaxBet < 0
	OR @v186MinBet > @v186MaxPerMatch
	OR @v186MaxBet > @v186MaxPerMatch
BEGIN 
	SELECT @ErrMsg = CASE @Language 
					WHEN 'E' THEN 'Wrong Min bet/ Max bet/ Max per match.'
					ELSE [dbo].[f_Get_MsgNamebyMsgID](10003,@Language)
			END, @ErrCode = 101
	RETURN
END	
	
/***********************************
* Validate Bet Setting
***********************************/

IF @v186sPositionTaking < 0
	OR @v186mPositionTaking < 0
BEGIN
	 Select @ErrMsg = case @Language 
						when 'E' then 'Wrong  position taking.<br>'
						ELSE [dbo].[f_Get_MsgNamebyMsgID](20001,@Language) + '<br>'
					end, @ErrCode = 104
		return
END


SELECT @ErrAcc = ''
SELECT top 100 @ErrAcc = @ErrAcc + username +', '
FROM custInfo ci WITH(NOLOCK)
	INNER JOIN Dep_CustSetting3rd cs3 WITH(NOLOCK) ON ci.custid = cs3.custid
	INNER JOIN (
		SELECT 186 AS sporttype, 1220 AS bettype,@v186mPositionTaking AS mpositiontaking_max	
	) b ON b.sporttype = cs3.sporttype AND cs3.bettype = b.bettype
WHERE ci.mrecommend = @CustId
	AND ci.roleid = 2
	AND cs3.sporttype = 186
	AND cs3.apositiontaking + cs3.mpositiontaking > b.mpositiontaking_max
IF @ErrAcc <> ''
BEGIN
	select @ErrCode = 14
	Select @ErrMsg = case @Language 
						when 'E' then 'Existing agents exceeded new master position taking ('+@ErrAcc+') (for Virtual Tennis).'
						ELSE [dbo].[f_Get_MsgNamebyMsgID](20011,@Language) + ' ('+@ErrAcc+')' + ' (' + [dbo].[f_Get_SportNameBySporttype](186,@Language) + ')'
					end
	return
END


SELECT @ErrAcc = ''
SELECT top 100 @ErrAcc = @ErrAcc + username +', '
FROM custInfo ci WITH(NOLOCK)
	INNER JOIN Dep_CustSetting3rd cs3 WITH(NOLOCK) ON ci.custid = cs3.custid
	INNER JOIN (
		SELECT 186 AS sporttype, 1220 AS bettype,@v186mPositionTaking AS mpositiontaking_max	
	) b ON b.sporttype = cs3.sporttype AND cs3.bettype = b.bettype
WHERE ci.mrecommend = @CustId
	AND ci.roleid = 1
	AND cs3.sporttype = 186
	AND cs3.apositiontaking + cs3.mpositiontaking > b.mpositiontaking_max
IF @ErrAcc <> ''
BEGIN
	select @ErrCode = 15
	Select @ErrMsg =  case @Language 
						when 'E' then 'Existing members exceeded new master position taking ('+@ErrAcc+') (for Virtual Tennis).'
						ELSE [dbo].[f_Get_MsgNamebyMsgID](20012,@Language) + ' ('+@ErrAcc+')' + ' (' + [dbo].[f_Get_SportNameBySporttype](186,@Language) + ')'
					end
	return
END
	 
 /**********************************
 * Update setting
 **********************************/
 UPDATE custinfo WITH (ROWLOCK,UPDLOCK)
 SET maxpermatch186 = @v186MaxPerMatch
 WHERE custid = @CustId

 if (@@error <> 0)
begin
	
	Select @ErrMsg = case @Language 
						when 'E' then 'Update process is unsuccessful !'
						ELSE [dbo].[f_Get_MsgNamebyMsgID](90001,@Language)
					end	, @ErrCode = 103 
	return
END

 /*********************************
 * Update Bet Setting
 *********************************/
IF EXISTS (SELECT 1 FROM Dep_CustSetting3rd WITH (NOLOCK) WHERE sporttype = 186 AND custid = @CustID)
BEGIN
	 UPDATE Dep_CustSetting3rd WITH(ROWLOCK,UPDLOCK)
	SET
 		mpositiontaking = @v186mPositionTaking,
 		spositiontaking = 0,
 		minbet = @v186MinBet,
 		maxbet = @v186MaxBet
	WHERE custid = @CustId
		AND sporttype = 186
END
ELSE
BEGIN
	INSERT INTO Dep_CustSetting3rd (custId, bettype, sporttype, apositiontaking, mpositiontaking, spositiontaking, playerdiscount, discount, adiscount, sdiscount, Minbet, Maxbet, islive)
	VALUES (@CustID, 
			1220, 
			186, 
			0, 
			@v186mPositionTaking, 
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

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO


GO 
 GRANT VIEW DEFINITION ON [dbo].[Acc_Dep_CustomerUpdMemberVirtualSports_SAg] TO [vnteam]
GO 
 GRANT EXECUTE ON [dbo].[Acc_Dep_CustomerUpdMemberVirtualSports_SAg] TO [bodbAdminNet]
GO 
 GRANT EXECUTE ON [dbo].[Acc_Dep_CustomerUpdMemberVirtualSports_SAg] TO [bodbExtAccNet]
GO 
