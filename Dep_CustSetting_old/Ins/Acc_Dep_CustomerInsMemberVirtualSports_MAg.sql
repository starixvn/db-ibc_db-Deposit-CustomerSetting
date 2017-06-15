ALTER PROCEDURE [dbo].[Acc_Dep_CustomerInsMemberVirtualSports_MAg] 
	@custid INT,
	@mrecommend int,

	@v180aPositionTaking SMALLMONEY,
	@v180mPositionTaking SMALLMONEY,
	@v180MinBet MONEY,
	@v180MaxBet MONEY,
	
	@v181aPositionTaking SMALLMONEY,
	@v181mPositionTaking SMALLMONEY,
	@v181MinBet MONEY,
	@v181MaxBet MONEY,

	@v182aPositionTaking SMALLMONEY,
	@v182mPositionTaking SMALLMONEY,
	@v182MinBet MONEY,
	@v182MaxBet MONEY,

	@v183aPositionTaking SMALLMONEY,
	@v183mPositionTaking SMALLMONEY,
	@v183MinBet MONEY,
	@v183MaxBet MONEY,

	@v184aPositionTaking SMALLMONEY,
	@v184mPositionTaking SMALLMONEY,
	@v184MinBet MONEY,
	@v184MaxBet MONEY,

	@v185aPositionTaking SMALLMONEY,
	@v185mPositionTaking SMALLMONEY,
	@v185MinBet MONEY,
	@v185MaxBet MONEY,

	@v186aPositionTaking SMALLMONEY,
	@v186mPositionTaking SMALLMONEY,
	@v186MinBet MONEY,
	@v186MaxBet MONEY,

	@ErrCode int = 0 OUTPUT,
	@Language VARCHAR(2) = 'E',
	@ErrMsg nvarchar(4000) = '' OUTPUT
AS
--@Source Control
/*
Created: 20122808@Dom
Task : Master create Agent's info and settings for virutal sport in Deposite site
DB: DBTRANS.bodb02
Original:
Revisions:
	- 20121128@Elodie: Get an error message from f_Get_MsgNameByMsgID function by language
	- 20131014@Francis: Support adding new virtual sports with settings
    
Param's Explanation:
• @ErrCode:
    = 0: Create agent successfully.
    > 0: Specific Error.
  
• @ErrMsg: Error description.
*/

declare @startRun datetime
declare @endRun datetime
declare @duration int
set @startRun = getdate()

DECLARE 

		@v180mPositionTaking_Max SMALLMONEY,
		@v180MinBet_Max MONEY,
		@v180MaxBet_Min MONEY,
		@v180MaxPerMatch_Max MONEY,

		@v181mPositionTaking_Max SMALLMONEY,
		@v181MinBet_Max MONEY,
		@v181MaxBet_Min MONEY,
		@v181MaxPerMatch_Max MONEY,

		@v182mPositionTaking_Max SMALLMONEY,
		@v182MinBet_Max MONEY,
		@v182MaxBet_Min MONEY,
		@v182MaxPerMatch_Max MONEY,

		@v183mPositionTaking_Max SMALLMONEY,
		@v183MinBet_Max MONEY,
		@v183MaxBet_Min MONEY,
		@v183MaxPerMatch_Max MONEY,

		@v184mPositionTaking_Max SMALLMONEY,
		@v184MinBet_Max MONEY,
		@v184MaxBet_Min MONEY,
		@v184MaxPerMatch_Max MONEY,

		@v185mPositionTaking_Max SMALLMONEY,
		@v185MinBet_Max MONEY,
		@v185MaxBet_Min MONEY,
		@v185MaxPerMatch_Max MONEY,

		@v186mPositionTaking_Max SMALLMONEY,
		@v186MinBet_Max MONEY,
		@v186MaxBet_Min MONEY,
		@v186MaxPerMatch_Max MONEY,

		@DisableVirtualSports BIT
		
SELECT @DisableVirtualSports = DisableVirtualSports
FROM custinfo WITH (NOLOCK)
WHERE custid = @mrecommend


/***********************************
* Validate Min/max Bet
***********************************/
IF(@v180MinBet>@v180MaxBet)
BEGIN
	SELECT
		@ErrMsg =	case @Language 
							when 'E' then 'Min Bet must be less than Max Bet and Max Bet must be less than Max Per Match.'
							ELSE [dbo].[f_Get_MsgNamebyMsgID](10005,@Language)
					end
										
	Select @ErrCode = 103
	EXEC Acc_CustomerInsUserInfo_Rollback @CustID = @CustID
	RETURN
END

/****************************
* Validate Bet Setting
****************************/
SELECT
	@v180MinBet_Max = cs3.minbet, 
	@v180MaxBet_Min = cs3.maxbet, 
	@v180mPositionTaking_Max = cs3.mpositiontaking
FROM custinfo ci WITH(NOLOCK)
	INNER JOIN Dep_CustSetting3rd cs3 ON ci.custid = cs3.custid
WHERE ci.custid = @mrecommend
	AND cs3.sporttype = 180

IF  (@v180MinBet < @v180MinBet_Max and @v180minbet>0 AND @v180MinBet_Max > 0)
	OR (@v180MaxBet > @v180MaxBet_Min and @v180maxbet>0 AND @v180MaxBet_Min > 0)
BEGIN
	 SELECT
		@ErrMsg =	case @Language 
							when 'E' then 'Min bet must be equal to or greater than super agent min bet .'
							ELSE [dbo].[f_Get_MsgNamebyMsgID](10006,@Language)
					end
										
	SELECT @ErrCode = 107
	RETURN 
END 

IF (@v180mPositionTaking+@v180aPositionTaking>@v180mPositionTaking_Max)
BEGIN
	 SELECT @ErrMsg = case @Language 
							when 'E' then 'Wrong position taking (max for super set by company).<br>'
							ELSE [dbo].[f_Get_MsgNamebyMsgID](20004,@Language) + '<br>'
						end
	SELECT @ErrCode = 104
	RETURN   
END

/****************************
* Add Bet Setting
****************************/

INSERT INTO Dep_CustSetting3rd
(
	custid,
	bettype,
	sporttype,
	islive,
	apositiontaking,
	mpositiontaking,
	spositiontaking,
	playerdiscount,
	discount,
	adiscount,
	sdiscount,
	minbet,
	maxbet
)
VALUES
(
	@custid/* custid	*/,
	1201,
	180,
	0,
	@v180aPositionTaking,
	0,
	0,
	0,
	0,
	0,
	0,
	@v180MinBet,
	@v180MaxBet
)
IF @@error <> 0
BEGIN
	--Error Occurs
	SELECT @ErrMsg = case @Language 
							when 'E' then 'Create customer fail. Please try again'
							ELSE [dbo].[f_Get_MsgNamebyMsgID](40004,@Language)
						end	
			,  @ErrCode=119
	
	RETURN 
END




/***********************************
* Validate Min/max Bet
***********************************/
IF(@v181MinBet>@v181MaxBet)
BEGIN
	SELECT
		@ErrMsg =	case @Language 
							when 'E' then 'Min Bet must be less than Max Bet and Max Bet must be less than Max Per Match.'
							ELSE [dbo].[f_Get_MsgNamebyMsgID](10005,@Language)
					end
										
	Select @ErrCode = 103
	EXEC Acc_CustomerInsUserInfo_Rollback @CustID = @CustID
	RETURN
END

/****************************
* Validate Bet Setting
****************************/
SELECT 
	@v181MinBet_Max = cs3.minbet, 
	@v181MaxBet_Min = cs3.maxbet, 
	@v181mPositionTaking_Max = cs3.mpositiontaking
FROM custinfo ci WITH(NOLOCK)
	INNER JOIN Dep_CustSetting3rd cs3 ON ci.custid = cs3.custid
WHERE ci.custid = @mrecommend
	AND cs3.sporttype = 181

IF  (@v181MinBet < @v181MinBet_Max and @v181minbet>0 AND @v181MinBet_Max > 0)
	OR (@v181MaxBet > @v181MaxBet_Min and @v181maxbet>0 AND @v181MaxBet_Min > 0)
BEGIN
	 SELECT
		@ErrMsg =	case @Language 
							when 'E' then 'Min bet must be equal to or greater than super agent min bet .'
							ELSE [dbo].[f_Get_MsgNamebyMsgID](10006,@Language)
					end
										
	SELECT @ErrCode = 107
	RETURN 
END 

IF (@v181mPositionTaking+@v181aPositionTaking>@v181mPositionTaking_Max)
BEGIN
	 SELECT @ErrMsg = case @Language 
							when 'E' then 'Wrong position taking (max for super set by company).<br>'
							ELSE [dbo].[f_Get_MsgNamebyMsgID](20004,@Language) + '<br>'
						end
	SELECT @ErrCode = 104
	RETURN   
END

/****************************
* Add Bet Setting
****************************/

INSERT INTO Dep_CustSetting3rd
(
	custid,
	bettype,
	sporttype,
	islive,
	apositiontaking,
	mpositiontaking,
	spositiontaking,
	playerdiscount,
	discount,
	adiscount,
	sdiscount,
	minbet,
	maxbet
)
VALUES
(
	@custid/* custid	*/,
	1231,
	181,
	0,
	@v181aPositionTaking,
	0,
	0,
	0,
	0,
	0,
	0,
	@v181MinBet,
	@v181MaxBet
)
IF @@error <> 0
BEGIN
	--Error Occurs
	SELECT @ErrMsg = case @Language 
							when 'E' then 'Create customer fail. Please try again'
							ELSE [dbo].[f_Get_MsgNamebyMsgID](40004,@Language)
						end	
			,  @ErrCode=119
	
	RETURN 
END

/***********************************
* Validate Min/max Bet
***********************************/
IF(@v182MinBet>@v182MaxBet)
BEGIN
	SELECT
		@ErrMsg =	case @Language 
							when 'E' then 'Min Bet must be less than Max Bet and Max Bet must be less than Max Per Match.'
							ELSE [dbo].[f_Get_MsgNamebyMsgID](10005,@Language)
					end
										
	Select @ErrCode = 103
	EXEC Acc_CustomerInsUserInfo_Rollback @CustID = @CustID
	RETURN
END

/****************************
* Validate Bet Setting
****************************/
SELECT
	@v182MinBet_Max = cs3.minbet, 
	@v182MaxBet_Min = cs3.maxbet, 
	@v182mPositionTaking_Max = cs3.mpositiontaking
FROM custinfo ci WITH(NOLOCK)
	INNER JOIN Dep_CustSetting3rd cs3 ON ci.custid = cs3.custid
WHERE ci.custid = @mrecommend
	AND cs3.sporttype = 182

IF  (@v182MinBet < @v182MinBet_Max and @v182minbet>0 AND @v182MinBet_Max > 0)
	OR (@v182MaxBet > @v182MaxBet_Min and @v182maxbet>0 AND @v182MaxBet_Min > 0)
BEGIN
	 SELECT
		@ErrMsg =	case @Language 
							when 'E' then 'Min bet must be equal to or greater than super agent min bet .'
							ELSE [dbo].[f_Get_MsgNamebyMsgID](10006,@Language)
					end
										
	SELECT @ErrCode = 107
	RETURN 
END 

IF (@v182mPositionTaking+@v182aPositionTaking>@v182mPositionTaking_Max)
BEGIN
	 SELECT @ErrMsg = case @Language 
							when 'E' then 'Wrong position taking (max for super set by company).<br>'
							ELSE [dbo].[f_Get_MsgNamebyMsgID](20004,@Language) + '<br>'
						end
	SELECT @ErrCode = 104
	RETURN   
END

/****************************
* Add Bet Setting
****************************/

INSERT INTO Dep_CustSetting3rd
(
	custid,
	bettype,
	sporttype,
	islive,
	apositiontaking,
	mpositiontaking,
	spositiontaking,
	playerdiscount,
	discount,
	adiscount,
	sdiscount,
	minbet,
	maxbet
)
VALUES
(
	@custid/* custid	*/,
	1231,
	182,
	0,
	@v182aPositionTaking,
	0,
	0,
	0,
	0,
	0,
	0,
	@v182MinBet,
	@v182MaxBet
)
IF @@error <> 0
BEGIN
	--Error Occurs
	SELECT @ErrMsg = case @Language 
							when 'E' then 'Create customer fail. Please try again'
							ELSE [dbo].[f_Get_MsgNamebyMsgID](40004,@Language)
						end	
			,  @ErrCode=119
	
	RETURN 
END

/***********************************
* Validate Min/max Bet
***********************************/
IF(@v183MinBet>@v183MaxBet)
BEGIN
	SELECT
		@ErrMsg =	case @Language 
							when 'E' then 'Min Bet must be less than Max Bet and Max Bet must be less than Max Per Match.'
							ELSE [dbo].[f_Get_MsgNamebyMsgID](10005,@Language)
					end
										
	Select @ErrCode = 103
	EXEC Acc_CustomerInsUserInfo_Rollback @CustID = @CustID
	RETURN
END

/****************************
* Validate Bet Setting
****************************/
SELECT
	@v183MinBet_Max = cs3.minbet, 
	@v183MaxBet_Min = cs3.maxbet, 
	@v183mPositionTaking_Max = cs3.mpositiontaking
FROM custinfo ci WITH(NOLOCK)
	INNER JOIN Dep_CustSetting3rd cs3 ON ci.custid = cs3.custid
WHERE ci.custid = @mrecommend
	AND cs3.sporttype = 183

IF  (@v183MinBet < @v183MinBet_Max and @v183minbet>0 AND @v183MinBet_Max > 0)
	OR (@v183MaxBet > @v183MaxBet_Min and @v183maxbet>0 AND @v183MaxBet_Min > 0)
BEGIN
	 SELECT
		@ErrMsg =	case @Language 
							when 'E' then 'Min bet must be equal to or greater than super agent min bet .'
							ELSE [dbo].[f_Get_MsgNamebyMsgID](10006,@Language)
					end
										
	SELECT @ErrCode = 107
	RETURN 
END 

IF (@v183mPositionTaking+@v183aPositionTaking>@v183mPositionTaking_Max)
BEGIN
	 SELECT @ErrMsg = case @Language 
							when 'E' then 'Wrong position taking (max for super set by company).<br>'
							ELSE [dbo].[f_Get_MsgNamebyMsgID](20004,@Language) + '<br>'
						end
	SELECT @ErrCode = 104
	RETURN   
END

/****************************
* Add Bet Setting
****************************/

INSERT INTO Dep_CustSetting3rd
(
	custid,
	bettype,
	sporttype,
	islive,
	apositiontaking,
	mpositiontaking,
	spositiontaking,
	playerdiscount,
	discount,
	adiscount,
	sdiscount,
	minbet,
	maxbet
)
VALUES
(
	@custid/* custid	*/,
	1231,
	183,
	0,
	@v183aPositionTaking,
	0,
	0,
	0,
	0,
	0,
	0,
	@v183MinBet,
	@v183MaxBet
)
IF @@error <> 0
BEGIN
	--Error Occurs
	SELECT @ErrMsg = case @Language 
							when 'E' then 'Create customer fail. Please try again'
							ELSE [dbo].[f_Get_MsgNamebyMsgID](40004,@Language)
						end	
			,  @ErrCode=119
	
	RETURN 
END

/***********************************
* Validate Min/max Bet
***********************************/
IF(@v184MinBet>@v184MaxBet)
BEGIN
	SELECT
		@ErrMsg =	case @Language 
							when 'E' then 'Min Bet must be less than Max Bet and Max Bet must be less than Max Per Match.'
							ELSE [dbo].[f_Get_MsgNamebyMsgID](10005,@Language)
					end
										
	Select @ErrCode = 103
	EXEC Acc_CustomerInsUserInfo_Rollback @CustID = @CustID
	RETURN
END

/****************************
* Validate Bet Setting
****************************/
SELECT
	@v184MinBet_Max = cs3.minbet, 
	@v184MaxBet_Min = cs3.maxbet, 
	@v184mPositionTaking_Max = cs3.mpositiontaking
FROM custinfo ci WITH(NOLOCK)
	INNER JOIN Dep_CustSetting3rd cs3 ON ci.custid = cs3.custid
WHERE ci.custid = @mrecommend
	AND cs3.sporttype = 184

IF  (@v184MinBet < @v184MinBet_Max and @v184minbet>0 AND @v184MinBet_Max > 0)
	OR (@v184MaxBet > @v184MaxBet_Min and @v184maxbet>0 AND @v184MaxBet_Min > 0)
BEGIN
	 SELECT
		@ErrMsg =	case @Language 
							when 'E' then 'Min bet must be equal to or greater than super agent min bet .'
							ELSE [dbo].[f_Get_MsgNamebyMsgID](10006,@Language)
					end
										
	SELECT @ErrCode = 107
	RETURN 
END 

IF (@v184mPositionTaking+@v184aPositionTaking>@v184mPositionTaking_Max)
BEGIN
	 SELECT @ErrMsg = case @Language 
							when 'E' then 'Wrong position taking (max for super set by company).<br>'
							ELSE [dbo].[f_Get_MsgNamebyMsgID](20004,@Language) + '<br>'
						end
	SELECT @ErrCode = 104
	RETURN   
END

/****************************
* Add Bet Setting
****************************/

INSERT INTO Dep_CustSetting3rd
(
	custid,
	bettype,
	sporttype,
	islive,
	apositiontaking,
	mpositiontaking,
	spositiontaking,
	playerdiscount,
	discount,
	adiscount,
	sdiscount,
	minbet,
	maxbet
)
VALUES
(
	@custid/* custid	*/,
	1231,
	184,
	0,
	@v184aPositionTaking,
	0,
	0,
	0,
	0,
	0,
	0,
	@v184MinBet,
	@v184MaxBet
)
IF @@error <> 0
BEGIN
	--Error Occurs
	SELECT @ErrMsg = case @Language 
							when 'E' then 'Create customer fail. Please try again'
							ELSE [dbo].[f_Get_MsgNamebyMsgID](40004,@Language)
						end	
			,  @ErrCode=119
	
	RETURN 
END

/***********************************
* Validate Min/max Bet
***********************************/
IF(@v185MinBet>@v185MaxBet)
BEGIN
	SELECT
		@ErrMsg =	case @Language 
							when 'E' then 'Min Bet must be less than Max Bet and Max Bet must be less than Max Per Match.'
							ELSE [dbo].[f_Get_MsgNamebyMsgID](10005,@Language)
					end
										
	Select @ErrCode = 103
	EXEC Acc_CustomerInsUserInfo_Rollback @CustID = @CustID
	RETURN
END

/****************************
* Validate Bet Setting
****************************/
SELECT
	@v185MinBet_Max = cs3.minbet, 
	@v185MaxBet_Min = cs3.maxbet, 
	@v185mPositionTaking_Max = cs3.mpositiontaking
FROM custinfo ci WITH(NOLOCK)
	INNER JOIN Dep_CustSetting3rd cs3 ON ci.custid = cs3.custid
WHERE ci.custid = @mrecommend
	AND cs3.sporttype = 185

IF  (@v185MinBet < @v185MinBet_Max and @v185minbet>0 AND @v185MinBet_Max > 0)
	OR (@v185MaxBet > @v185MaxBet_Min and @v185maxbet>0 AND @v185MaxBet_Min > 0)
BEGIN
	 SELECT
		@ErrMsg =	case @Language 
							when 'E' then 'Min bet must be equal to or greater than super agent min bet .'
							ELSE [dbo].[f_Get_MsgNamebyMsgID](10006,@Language)
					end
										
	SELECT @ErrCode = 107
	RETURN 
END 

IF (@v185mPositionTaking+@v185aPositionTaking>@v185mPositionTaking_Max)
BEGIN
	 SELECT @ErrMsg = case @Language 
							when 'E' then 'Wrong position taking (max for super set by company).<br>'
							ELSE [dbo].[f_Get_MsgNamebyMsgID](20004,@Language) + '<br>'
						end
	SELECT @ErrCode = 104
	RETURN   
END

/****************************
* Add Bet Setting
****************************/

INSERT INTO Dep_CustSetting3rd
(
	custid,
	bettype,
	sporttype,
	islive,
	apositiontaking,
	mpositiontaking,
	spositiontaking,
	playerdiscount,
	discount,
	adiscount,
	sdiscount,
	minbet,
	maxbet
)
VALUES
(
	@custid/* custid	*/,
	1231,
	185,
	0,
	@v185aPositionTaking,
	0,
	0,
	0,
	0,
	0,
	0,
	@v185MinBet,
	@v185MaxBet
)
IF @@error <> 0
BEGIN
	--Error Occurs
	SELECT @ErrMsg = case @Language 
							when 'E' then 'Create customer fail. Please try again'
							ELSE [dbo].[f_Get_MsgNamebyMsgID](40004,@Language)
						end	
			,  @ErrCode=119
	
	RETURN 
END


/***********************************
* Validate Min/max Bet
***********************************/
IF(@v186MinBet>@v186MaxBet)
BEGIN
	SELECT
		@ErrMsg =	case @Language 
							when 'E' then 'Min Bet must be less than Max Bet and Max Bet must be less than Max Per Match.'
							ELSE [dbo].[f_Get_MsgNamebyMsgID](10005,@Language)
					end
										
	Select @ErrCode = 103
	EXEC Acc_CustomerInsUserInfo_Rollback @CustID = @CustID
	RETURN
END

/****************************
* Validate Bet Setting
****************************/
SELECT
	@v186MinBet_Max = cs3.minbet, 
	@v186MaxBet_Min = cs3.maxbet, 
	@v186mPositionTaking_Max = cs3.mpositiontaking
FROM custinfo ci WITH(NOLOCK)
	INNER JOIN Dep_CustSetting3rd cs3 ON ci.custid = cs3.custid
WHERE ci.custid = @mrecommend
	AND cs3.sporttype = 186

IF  (@v186MinBet < @v186MinBet_Max and @v186minbet>0 AND @v186MinBet_Max > 0)
	OR (@v186MaxBet > @v186MaxBet_Min and @v186maxbet>0 AND @v186MaxBet_Min > 0)
BEGIN
	 SELECT
		@ErrMsg =	case @Language 
							when 'E' then 'Min bet must be equal to or greater than super agent min bet .'
							ELSE [dbo].[f_Get_MsgNamebyMsgID](10006,@Language)
					end
										
	SELECT @ErrCode = 107
	RETURN 
END 

IF (@v186mPositionTaking+@v186aPositionTaking>@v186mPositionTaking_Max)
BEGIN
	 SELECT @ErrMsg = case @Language 
							when 'E' then 'Wrong position taking (max for super set by company).<br>'
							ELSE [dbo].[f_Get_MsgNamebyMsgID](20004,@Language) + '<br>'
						end
	SELECT @ErrCode = 104
	RETURN   
END

/****************************
* Add Bet Setting
****************************/

INSERT INTO Dep_CustSetting3rd
(
	custid,
	bettype,
	sporttype,
	islive,
	apositiontaking,
	mpositiontaking,
	spositiontaking,
	playerdiscount,
	discount,
	adiscount,
	sdiscount,
	minbet,
	maxbet
)
VALUES
(
	@custid/* custid	*/,
	1220,
	186,
	0,
	@v186aPositionTaking,
	0,
	0,
	0,
	0,
	0,
	0,
	@v186MinBet,
	@v186MaxBet
)
IF @@error <> 0
BEGIN
	--Error Occurs
	SELECT @ErrMsg = case @Language 
							when 'E' then 'Create customer fail. Please try again'
							ELSE [dbo].[f_Get_MsgNamebyMsgID](40004,@Language)
						end	
			,  @ErrCode=119
	
	RETURN 
END


GO
GRANT EXECUTE ON [dbo].[Acc_Dep_CustomerInsMemberVirtualSports_MAg] TO [bodbAdminNet] AS [dbo]
GO
GRANT EXECUTE ON [dbo].[Acc_Dep_CustomerInsMemberVirtualSports_MAg] TO [bodbExtAccNet] AS [dbo]
GO
GRANT VIEW DEFINITION ON [dbo].[Acc_Dep_CustomerInsMemberVirtualSports_MAg] TO [vnteam] AS [dbo]