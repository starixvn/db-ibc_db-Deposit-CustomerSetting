ALTER PROCEDURE [dbo].[Acc_Dep_CustomerUpdMemberVirtualSports_Ag]
	@custid int,
	@userid int,

	@v180aPositionTaking SMALLMONEY,
	@v180mPositionTaking SMALLMONEY,
	@v180sPositionTaking SMALLMONEY,
	@v180MinBet MONEY,
	@v180MaxBet MONEY,
	@v180MaxPerMatch MONEY,
	
	@v181aPositionTaking SMALLMONEY,
	@v181mPositionTaking SMALLMONEY,
	@v181sPositionTaking SMALLMONEY,
	@v181MinBet MONEY,
	@v181MaxBet MONEY,
	@v181MaxPerMatch MONEY,

	@v182aPositionTaking SMALLMONEY,
	@v182mPositionTaking SMALLMONEY,
	@v182sPositionTaking SMALLMONEY,
	@v182MinBet MONEY,
	@v182MaxBet MONEY,
	@v182MaxPerMatch MONEY,

    @v183aPositionTaking SMALLMONEY,
	@v183mPositionTaking SMALLMONEY,
	@v183sPositionTaking SMALLMONEY,
	@v183MinBet MONEY,
	@v183MaxBet MONEY,
	@v183MaxPerMatch MONEY,

	@v184aPositionTaking SMALLMONEY,
	@v184mPositionTaking SMALLMONEY,
	@v184sPositionTaking SMALLMONEY,
	@v184MinBet MONEY,
	@v184MaxBet MONEY,
	@v184MaxPerMatch MONEY,

	@v185aPositionTaking SMALLMONEY,
	@v185mPositionTaking SMALLMONEY,
	@v185sPositionTaking SMALLMONEY,
	@v185MinBet MONEY,
	@v185MaxBet MONEY,
	@v185MaxPerMatch MONEY,

	@v186aPositionTaking SMALLMONEY,
	@v186mPositionTaking SMALLMONEY,
	@v186sPositionTaking SMALLMONEY,
	@v186MinBet MONEY,
	@v186MaxBet MONEY,
	@v186MaxPerMatch MONEY,

	@ErrCode int = 0 OUTPUT,
	@Language VARCHAR(2) = 'E',
	@ErrMsg nvarchar(4000) = '' OUTPUT
AS

--@Source Control
/*
Created: 20120828@Dom
Task : Agent update MinBet, MaxBet, MaxPerMatch, PT of member for virtual sports
DB: DBTrans.bodb02

Revisions:
    - 20121128@Elodie: Get an error message from f_Get_MsgNameByMsgID function by language
	- 20131014@Francis: Support updating new virtual sports with settings
    - 20131211@Francis: Fix bug for updating position taking for Virtual Sports at Member level (only apostiontaking column will be affected)
	- 20131231@Francis: Hotfix failing to update settings of new Virtual Sports for an old member
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

DECLARE @recommend int, @mrecommend int, @srecommend int,-- Super ID
		@v180apositiontaking_max SMALLMONEY,
		@v180MinBet_Max MONEY,
		@v180MaxBet_Min MONEY,

		@v181apositiontaking_max SMALLMONEY,
		@v181MinBet_Max MONEY,
		@v181MaxBet_Min MONEY,

		@v182apositiontaking_max SMALLMONEY,
		@v182MinBet_Max MONEY,
		@v182MaxBet_Min MONEY,

		@v183apositiontaking_max SMALLMONEY,
		@v183MinBet_Max MONEY,
		@v183MaxBet_Min MONEY,

		@v184apositiontaking_max SMALLMONEY,
		@v184MinBet_Max MONEY,
		@v184MaxBet_Min MONEY,

		@v185apositiontaking_max SMALLMONEY,
		@v185MinBet_Max MONEY,
		@v185MaxBet_Min MONEY,

		@v186apositiontaking_max SMALLMONEY,
		@v186MinBet_Max MONEY,
		@v186MaxBet_Min MONEY
			
SELECT @recommend = recommend, @mrecommend = ci.mrecommend, @srecommend = ci.srecommend
FROM custInfo ci WITH (NOLOCK) 
WHERE ci.custid = @custid

------Virtual Soccer
SELECT @v180apositiontaking_max = apositiontaking FROM Dep_CustSetting3rd cs3 WHERE cs3.custid = @recommend

--SELECT @v180MinBet_Max = MAX(CASE WHEN cs3.minbet = 0 THEN NULL ELSE cs3.minbet END),
--	@v180MaxBet_Min = MIN(CASE WHEN cs3.maxbet = 0 THEN NULL ELSE cs3.maxbet END)
--FROM Dep_CustSetting3rd cs3 WITH (NOLOCK)
--INNER JOIN custInfo ci WITH (NOLOCK) ON (ci.srecommend = ci.custid OR ci.mrecommend = ci.custid OR ci.recommend = cs3.custid) 
--WHERE ci.custid = @custid
--	AND cs3.sporttype = 180

SELECT @v180MinBet_Max = MAX(CASE WHEN cs3.minbet = 0 THEN NULL ELSE cs3.minbet END),
	@v180MaxBet_Min = MIN(CASE WHEN cs3.maxbet = 0 THEN NULL ELSE cs3.maxbet END)
FROM Dep_CustSetting3rd cs3 WITH (NOLOCK)
INNER JOIN custInfo ci WITH (NOLOCK) ON cs3.custid = ci.custid
WHERE ci.custid IN (@recommend,@mrecommend,@srecommend)
	AND cs3.sporttype = 180
/*************************************
* Validate 
*************************************/

IF @v180aPositionTaking > @v180apositiontaking_max
	OR @v180aPositionTaking < 0
	OR @v180mPositionTaking < 0
	OR @v180sPositionTaking < 0
BEGIN
	 SELECT @ErrMsg = case @Language 
						when 'E' then 'Wrong  position taking.<br>'
						ELSE [dbo].[f_Get_MsgNamebyMsgID](20001,@Language) + '<br>'
					end, @ErrCode = 104
	RETURN
END

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

/*********************************
* Update info	
*********************************/
UPDATE custInfo WITH(ROWLOCK,UPDLOCK)
SET
	maxpermatch180 = @v180MaxPerMatch
WHERE custid = @custid
if (@@error <> 0)
begin
	
	Select @ErrMsg = case @Language 
						when 'E' then 'Update process is unsuccessful !'
						ELSE [dbo].[f_Get_MsgNamebyMsgID](90001,@Language)
					end	, @ErrCode = 103 
	return
END
	
/*******************************
* Update Bet Setting
*******************************/
IF EXISTS (SELECT 1 FROM Dep_CustSetting3rd WITH (NOLOCK) WHERE sporttype = 180 AND custid = @CustID)
BEGIN
	UPDATE Dep_CustSetting3rd WITH(ROWLOCK,UPDLOCK)
	SET
		minbet = @v180MinBet,
		maxbet = @v180MaxBet,
		apositiontaking = @v180aPositionTaking,
		mpositiontaking = 0,
		spositiontaking = 0
	WHERE custid = @custid
	AND	sporttype = 180
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
SELECT @v181apositiontaking_max = apositiontaking FROM Dep_CustSetting3rd cs3 WHERE cs3.custid = @recommend

--SELECT @v181MinBet_Max = MAX(CASE WHEN cs3.minbet = 0 THEN NULL ELSE cs3.minbet END),
--	@v181MaxBet_Min = MIN(CASE WHEN cs3.maxbet = 0 THEN NULL ELSE cs3.maxbet END)
--FROM Dep_CustSetting3rd cs3 WITH (NOLOCK)
--INNER JOIN custInfo ci WITH (NOLOCK) ON (ci.srecommend = ci.custid OR ci.mrecommend = ci.custid OR ci.recommend = cs3.custid) 
--WHERE ci.custid = @custid
--	AND cs3.sporttype = 181

SELECT @v181MinBet_Max = MAX(CASE WHEN cs3.minbet = 0 THEN NULL ELSE cs3.minbet END),
	@v181MaxBet_Min = MIN(CASE WHEN cs3.maxbet = 0 THEN NULL ELSE cs3.maxbet END)
FROM Dep_CustSetting3rd cs3 WITH (NOLOCK)
INNER JOIN custInfo ci WITH (NOLOCK) ON ci.custid = cs3.custid
WHERE ci.custid IN (@recommend, @mrecommend, @srecommend)
	AND cs3.sporttype = 181
/*************************************
* Validate 
*************************************/

IF @v181aPositionTaking > @v181apositiontaking_max
	OR @v181aPositionTaking < 0
	OR @v181mPositionTaking < 0
	OR @v181sPositionTaking < 0
BEGIN
	 SELECT @ErrMsg = case @Language 
						when 'E' then 'Wrong  position taking.<br>'
						ELSE [dbo].[f_Get_MsgNamebyMsgID](20001,@Language) + '<br>'
					end, @ErrCode = 104
	RETURN
END

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

/*********************************
* Update info	
*********************************/
UPDATE custInfo WITH(ROWLOCK,UPDLOCK)
SET
	maxpermatch181 = @v181MaxPerMatch
WHERE custid = @custid
if (@@error <> 0)
begin
	
	Select @ErrMsg = case @Language 
						when 'E' then 'Update process is unsuccessful !'
						ELSE [dbo].[f_Get_MsgNamebyMsgID](90001,@Language)
					end	, @ErrCode = 103 
	return
END
	
/*******************************
* Update Bet Setting
*******************************/
IF EXISTS (SELECT 1 FROM Dep_CustSetting3rd WITH (NOLOCK) WHERE sporttype = 181 AND custid = @CustID)
BEGIN
	UPDATE Dep_CustSetting3rd WITH(ROWLOCK,UPDLOCK)
	SET
		minbet = @v181MinBet,
		maxbet = @v181MaxBet,
		apositiontaking = @v181aPositionTaking,
		mpositiontaking = 0,
		spositiontaking = 0
	WHERE custid = @custid
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

------Virtual Greyhounds
SELECT @v182apositiontaking_max = apositiontaking FROM Dep_CustSetting3rd cs3 WHERE cs3.custid = @recommend

SELECT @v182MinBet_Max = MAX(CASE WHEN cs3.minbet = 0 THEN NULL ELSE cs3.minbet END),
	@v182MaxBet_Min = MIN(CASE WHEN cs3.maxbet = 0 THEN NULL ELSE cs3.maxbet END)
FROM Dep_CustSetting3rd cs3 WITH (NOLOCK)
INNER JOIN custInfo ci WITH (NOLOCK) ON ci.custid = cs3.custid
WHERE ci.custid IN (@recommend, @mrecommend, @srecommend)
	AND cs3.sporttype = 182

/*************************************
* Validate 
*************************************/

IF @v182aPositionTaking > @v182apositiontaking_max
	OR @v182aPositionTaking < 0
	OR @v182mPositionTaking < 0
	OR @v182sPositionTaking < 0
BEGIN
	 SELECT @ErrMsg = case @Language 
						when 'E' then 'Wrong  position taking.<br>'
						ELSE [dbo].[f_Get_MsgNamebyMsgID](20001,@Language) + '<br>'
					end, @ErrCode = 104
	RETURN
END

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

/*********************************
* Update info	
*********************************/
UPDATE custInfo WITH(ROWLOCK,UPDLOCK)
SET
	maxpermatch182 = @v182MaxPerMatch
WHERE custid = @custid
if (@@error <> 0)
begin
	
	Select @ErrMsg = case @Language 
						when 'E' then 'Update process is unsuccessful !'
						ELSE [dbo].[f_Get_MsgNamebyMsgID](90001,@Language)
					end	, @ErrCode = 103 
	return
END
	
/*******************************
* Update Bet Setting
*******************************/
IF EXISTS (SELECT 1 FROM Dep_CustSetting3rd WITH (NOLOCK) WHERE sporttype = 182 AND custid = @CustID)
BEGIN
	UPDATE Dep_CustSetting3rd WITH(ROWLOCK,UPDLOCK)
	SET
		minbet = @v182MinBet,
		maxbet = @v182MaxBet,
		apositiontaking = @v182aPositionTaking,
		mpositiontaking = 0,
		spositiontaking = 0
	WHERE custid = @custid
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

------Virtual Speedway
SELECT @v183apositiontaking_max = apositiontaking FROM Dep_CustSetting3rd cs3 WHERE cs3.custid = @recommend

SELECT @v183MinBet_Max = MAX(CASE WHEN cs3.minbet = 0 THEN NULL ELSE cs3.minbet END),
	@v183MaxBet_Min = MIN(CASE WHEN cs3.maxbet = 0 THEN NULL ELSE cs3.maxbet END)
FROM Dep_CustSetting3rd cs3 WITH (NOLOCK)
INNER JOIN custInfo ci WITH (NOLOCK) ON ci.custid = cs3.custid
WHERE ci.custid IN (@recommend, @mrecommend, @srecommend)
	AND cs3.sporttype = 183

/*************************************
* Validate 
*************************************/

IF @v183aPositionTaking > @v183apositiontaking_max
	OR @v183aPositionTaking < 0
	OR @v183mPositionTaking < 0
	OR @v183sPositionTaking < 0
BEGIN
	 SELECT @ErrMsg = case @Language 
						when 'E' then 'Wrong  position taking.<br>'
						ELSE [dbo].[f_Get_MsgNamebyMsgID](20001,@Language) + '<br>'
					end, @ErrCode = 104
	RETURN
END

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

/*********************************
* Update info	
*********************************/

UPDATE custInfo WITH(ROWLOCK,UPDLOCK)
SET
	maxpermatch183 = @v183MaxPerMatch
WHERE custid = @custid
if (@@error <> 0)
begin
	
	Select @ErrMsg = case @Language 
						when 'E' then 'Update process is unsuccessful !'
						ELSE [dbo].[f_Get_MsgNamebyMsgID](90001,@Language)
					end	, @ErrCode = 103 
	return
END
	
/*******************************
* Update Bet Setting
*******************************/
IF EXISTS (SELECT 1 FROM Dep_CustSetting3rd WITH (NOLOCK) WHERE sporttype = 183 AND custid = @CustID)
BEGIN
	UPDATE Dep_CustSetting3rd WITH(ROWLOCK,UPDLOCK)
	SET
		minbet = @v183MinBet,
		maxbet = @v183MaxBet,
		apositiontaking = @v183aPositionTaking,
		mpositiontaking = 0,
		spositiontaking = 0
	WHERE custid = @custid
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

------Virtual Motor Racing
SELECT @v184apositiontaking_max = apositiontaking FROM Dep_CustSetting3rd cs3 WHERE cs3.custid = @recommend

SELECT @v184MinBet_Max = MAX(CASE WHEN cs3.minbet = 0 THEN NULL ELSE cs3.minbet END),
	@v184MaxBet_Min = MIN(CASE WHEN cs3.maxbet = 0 THEN NULL ELSE cs3.maxbet END)
FROM Dep_CustSetting3rd cs3 WITH (NOLOCK)
INNER JOIN custInfo ci WITH (NOLOCK) ON ci.custid = cs3.custid
WHERE ci.custid IN (@recommend, @mrecommend, @srecommend)
	AND cs3.sporttype = 184

/*************************************
* Validate 
*************************************/

IF @v184aPositionTaking > @v184apositiontaking_max
	OR @v184aPositionTaking < 0
	OR @v184mPositionTaking < 0
	OR @v184sPositionTaking < 0
BEGIN
	 SELECT @ErrMsg = case @Language 
						when 'E' then 'Wrong  position taking.<br>'
						ELSE [dbo].[f_Get_MsgNamebyMsgID](20001,@Language) + '<br>'
					end, @ErrCode = 104
	RETURN
END

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

/*********************************
* Update info	
*********************************/
UPDATE custInfo WITH(ROWLOCK,UPDLOCK)
SET
	maxpermatch184 = @v184MaxPerMatch
WHERE custid = @custid
if (@@error <> 0)
begin
	
	Select @ErrMsg = case @Language 
						when 'E' then 'Update process is unsuccessful !'
						ELSE [dbo].[f_Get_MsgNamebyMsgID](90001,@Language)
					end	, @ErrCode = 103 
	return
END
	
/*******************************
* Update Bet Setting
*******************************/
IF EXISTS (SELECT 1 FROM Dep_CustSetting3rd WITH (NOLOCK) WHERE sporttype = 184 AND custid = @CustID)
BEGIN
	UPDATE Dep_CustSetting3rd WITH(ROWLOCK,UPDLOCK)
	SET
		minbet = @v184MinBet,
		maxbet = @v184MaxBet,
		apositiontaking = @v184aPositionTaking,
		mpositiontaking = 0,
		spositiontaking = 0
	WHERE custid = @custid
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

------Virtual Cycling
SELECT @v185apositiontaking_max = apositiontaking FROM Dep_CustSetting3rd cs3 WHERE cs3.custid = @recommend

SELECT @v185MinBet_Max = MAX(CASE WHEN cs3.minbet = 0 THEN NULL ELSE cs3.minbet END),
	@v185MaxBet_Min = MIN(CASE WHEN cs3.maxbet = 0 THEN NULL ELSE cs3.maxbet END)
FROM Dep_CustSetting3rd cs3 WITH (NOLOCK)
INNER JOIN custInfo ci WITH (NOLOCK) ON ci.custid = cs3.custid
WHERE ci.custid IN (@recommend, @mrecommend, @srecommend)
	AND cs3.sporttype = 185

/*************************************
* Validate 
*************************************/

IF @v185aPositionTaking > @v185apositiontaking_max
	OR @v185aPositionTaking < 0
	OR @v185mPositionTaking < 0
	OR @v185sPositionTaking < 0
BEGIN
	 SELECT @ErrMsg = case @Language 
						when 'E' then 'Wrong  position taking.<br>'
						ELSE [dbo].[f_Get_MsgNamebyMsgID](20001,@Language) + '<br>'
					end, @ErrCode = 104
	RETURN
END

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

/*********************************
* Update info	
*********************************/

UPDATE custInfo WITH(ROWLOCK,UPDLOCK)
SET
	maxpermatch185 = @v185MaxPerMatch
WHERE custid = @custid
if (@@error <> 0)
begin
	
	Select @ErrMsg = case @Language 
						when 'E' then 'Update process is unsuccessful !'
						ELSE [dbo].[f_Get_MsgNamebyMsgID](90001,@Language)
					end	, @ErrCode = 103 
	return
END

	
/*******************************
* Update Bet Setting
*******************************/

IF EXISTS (SELECT 1 FROM Dep_CustSetting3rd WITH (NOLOCK) WHERE sporttype = 185 AND custid = @CustID)
BEGIN
	UPDATE Dep_CustSetting3rd WITH(ROWLOCK,UPDLOCK)
	SET
		minbet = @v185MinBet,
		maxbet = @v185MaxBet,
		apositiontaking = @v185aPositionTaking,
		mpositiontaking = 0,
		spositiontaking = 0
	WHERE custid = @custid
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
SELECT @v186apositiontaking_max = apositiontaking FROM Dep_CustSetting3rd cs3 WHERE cs3.custid = @recommend

SELECT @v186MinBet_Max = MAX(CASE WHEN cs3.minbet = 0 THEN NULL ELSE cs3.minbet END),
	@v186MaxBet_Min = MIN(CASE WHEN cs3.maxbet = 0 THEN NULL ELSE cs3.maxbet END)
FROM Dep_CustSetting3rd cs3 WITH (NOLOCK)
INNER JOIN custInfo ci WITH (NOLOCK) ON ci.custid = cs3.custid
WHERE ci.custid IN (@recommend, @mrecommend, @srecommend)
	AND cs3.sporttype = 186

/*************************************
* Validate 
*************************************/

IF @v186aPositionTaking > @v186apositiontaking_max
	OR @v186aPositionTaking < 0
	OR @v186mPositionTaking < 0
	OR @v186sPositionTaking < 0
BEGIN
	 SELECT @ErrMsg = case @Language 
						when 'E' then 'Wrong  position taking.<br>'
						ELSE [dbo].[f_Get_MsgNamebyMsgID](20001,@Language) + '<br>'
					end, @ErrCode = 104
	RETURN
END

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

/*********************************
* Update info	
*********************************/
UPDATE custInfo WITH(ROWLOCK,UPDLOCK)
SET
	maxpermatch186 = @v186MaxPerMatch
WHERE custid = @custid
if (@@error <> 0)
begin
	
	Select @ErrMsg = case @Language 
						when 'E' then 'Update process is unsuccessful !'
						ELSE [dbo].[f_Get_MsgNamebyMsgID](90001,@Language)
					end	, @ErrCode = 103 
	return
END
	
/*******************************
* Update Bet Setting
*******************************/
IF EXISTS (SELECT 1 FROM Dep_CustSetting3rd WITH (NOLOCK) WHERE sporttype = 186 AND custid = @CustID)
BEGIN
	UPDATE Dep_CustSetting3rd WITH(ROWLOCK,UPDLOCK)
	SET
		minbet = @v186MinBet,
		maxbet = @v186MaxBet,
		apositiontaking = @v186aPositionTaking,
		mpositiontaking = 0,
		spositiontaking = 0
	WHERE custid = @custid
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
 GRANT VIEW DEFINITION ON [dbo].[Acc_Dep_CustomerUpdMemberVirtualSports_Ag] TO [vnteam]
GO 
 GRANT EXECUTE ON [dbo].[Acc_Dep_CustomerUpdMemberVirtualSports_Ag] TO [bodbAdminNet]
GO 
 GRANT EXECUTE ON [dbo].[Acc_Dep_CustomerUpdMemberVirtualSports_Ag] TO [bodbExtAccNet]
GO 
