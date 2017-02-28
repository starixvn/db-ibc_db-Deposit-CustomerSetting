ALTER PROCEDURE [dbo].[Acc_Dep_CustomerInsMemberVirtualSports_SAg]
	@custid int,
	@creator int,
	@srecommend int,

	@v180sPositionTaking SMALLMONEY,
	@v180mPositionTaking SMALLMONEY,
	@v180MinBet MONEY,
	@v180MaxBet MONEY,

	@v181sPositionTaking SMALLMONEY,
	@v181mPositionTaking SMALLMONEY,
	@v181MinBet MONEY,
	@v181MaxBet MONEY,

	@v182sPositionTaking SMALLMONEY,
	@v182mPositionTaking SMALLMONEY,
	@v182MinBet MONEY,
	@v182MaxBet MONEY,

	@v183sPositionTaking SMALLMONEY,
	@v183mPositionTaking SMALLMONEY,
	@v183MinBet MONEY,
	@v183MaxBet MONEY,

	@v184sPositionTaking SMALLMONEY,
	@v184mPositionTaking SMALLMONEY,
	@v184MinBet MONEY,
	@v184MaxBet MONEY,

	@v185sPositionTaking SMALLMONEY,
	@v185mPositionTaking SMALLMONEY,
	@v185MinBet MONEY,
	@v185MaxBet MONEY,

	@v186sPositionTaking SMALLMONEY,
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
Task : Super create Master's info and settings for virutal sport in Deposite site
DB: DBTRANS.bodb02
Original:
Revisions:
	- 20121128@Elodie: Get an error message from f_Get_MsgNameByMsgID function by language
	- 20131014@Francis: Support adding new virtual sports with settings
    
Param's Explanation:
• @ErrCode:
    = 0: Create master successfully.
    > 0: Specific Error.
  
• @ErrMsg: Error description.
*/

declare @startRun datetime
declare @endRun datetime
declare @duration int
set @startRun = getdate()

DECLARE @v180mPositionTaking_Max SMALLMONEY,
	    @v180MinBet_Max MONEY,
		@v180MaxBet_Min MONEY,
		
		@v181mPositionTaking_Max SMALLMONEY,
	    @v181MinBet_Max MONEY,
		@v181MaxBet_Min MONEY,

		@v182mPositionTaking_Max SMALLMONEY,
	    @v182MinBet_Max MONEY,
		@v182MaxBet_Min MONEY,

		@v183mPositionTaking_Max SMALLMONEY,
	    @v183MinBet_Max MONEY,
		@v183MaxBet_Min MONEY,

		@v184mPositionTaking_Max SMALLMONEY,
	    @v184MinBet_Max MONEY,
		@v184MaxBet_Min MONEY,

		@v185mPositionTaking_Max SMALLMONEY,
	    @v185MinBet_Max MONEY,
		@v185MaxBet_Min MONEY,

		@v186mPositionTaking_Max SMALLMONEY,
	    @v186MinBet_Max MONEY,
		@v186MaxBet_Min MONEY

/**********************************
* validate Min/Max Bet & MaxPerMatch
**********************************/
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
SELECT @v180MinBet_Max = cs3.minbet, 
	@v180MaxBet_Min = cs3.maxbet, 
	@v180mPositionTaking_Max = cs3.mpositiontaking
FROM custinfo ci WITH(NOLOCK)
	INNER JOIN Dep_CustSetting3rd cs3 ON ci.custid = cs3.custid
WHERE ci.custid = @srecommend
	AND cs3.sporttype = 180

IF 	@v180MinBet < @v180MinBet_Max AND @v180MinBet > 0 AND @v180MinBet_Max > 0
	OR @v180MaxBet > @v180MaxBet_Min AND @v180MaxBet > 0 AND @v180MaxBet_Min > 0
BEGIN
	 SELECT
		@ErrMsg =	case @Language 
							when 'E' then 'Min bet must be equal to or greater than super agent min bet .'
							ELSE [dbo].[f_Get_MsgNamebyMsgID](10006,@Language)
					end
										
	SELECT @ErrCode = 107
	EXEC Acc_CustomerInsUserInfo_Rollback @CustID = @CustID
	RETURN 
END 

IF (@v180mPositionTaking+@v180sPositionTaking>@v180mPositionTaking_Max)
BEGIN
	 SELECT @ErrMsg = case @Language 
							when 'E' then 'Wrong position taking (max for super set by company).<br>'
							ELSE [dbo].[f_Get_MsgNamebyMsgID](20004,@Language) + '<br>'
						end
	SELECT @ErrCode = 104
	EXEC Acc_CustomerInsUserInfo_Rollback @CustID = @CustID
	RETURN   
END

/**********************
* Insert Setting
**********************/
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
	@custid,
	1201,
	180,
	0,
	0,
	@v180mpositiontaking,
	0,
	0,
	0,
	0,
	0,
	@v180minbet,
	@v180maxbet
)

IF @@error <> 0
BEGIN
	--Error Occurs
	SELECT @ErrMsg = case @Language 
							when 'E' then 'Create customer fail. Please try again'
							ELSE [dbo].[f_Get_MsgNamebyMsgID](40004,@Language)
						end	
			,  @ErrCode=119
	-- ROLLBACK MANUALLY
	DELETE Dep_CustSetting WITH (ROWLOCK) WHERE custId  =@custid
	DELETE Dep_CustSetting3rd WITH (ROWLOCK) WHERE custId  =@custid
	
	DELETE P2PGameSetting WITH (ROWLOCK) WHERE custId  =@custid
	DELETE P2PGroupComm WITH (ROWLOCK) WHERE custId  =@custid
	DELETE CustSettingGame WITH(ROWLOCK) WHERE custid = @custid
	
	EXEC Acc_CustomerInsUserInfo_Rollback @CustID = @CustID
	RETURN 
END


/**********************************
* validate Min/Max Bet & MaxPerMatch
**********************************/
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
SELECT @v181MinBet_Max = cs3.minbet, 
	@v181MaxBet_Min = cs3.maxbet, 
	@v181mPositionTaking_Max = cs3.mpositiontaking
FROM custinfo ci WITH(NOLOCK)
	INNER JOIN Dep_CustSetting3rd cs3 ON ci.custid = cs3.custid
WHERE ci.custid = @srecommend
	AND cs3.sporttype = 181

IF 	@v181MinBet < @v181MinBet_Max AND @v181MinBet > 0 AND @v181MinBet_Max > 0
	OR @v181MaxBet > @v181MaxBet_Min AND @v181MaxBet > 0 AND @v181MaxBet_Min > 0
BEGIN
	 SELECT
		@ErrMsg =	case @Language 
							when 'E' then 'Min bet must be equal to or greater than super agent min bet .'
							ELSE [dbo].[f_Get_MsgNamebyMsgID](10006,@Language)
					end
										
	SELECT @ErrCode = 107
	EXEC Acc_CustomerInsUserInfo_Rollback @CustID = @CustID
	RETURN 
END 

IF (@v181mPositionTaking+@v181sPositionTaking>@v181mPositionTaking_Max)
BEGIN
	 SELECT @ErrMsg = case @Language 
							when 'E' then 'Wrong position taking (max for super set by company).<br>'
							ELSE [dbo].[f_Get_MsgNamebyMsgID](20004,@Language) + '<br>'
						end
	SELECT @ErrCode = 104
	EXEC Acc_CustomerInsUserInfo_Rollback @CustID = @CustID
	RETURN   
END

/**********************
* Insert Setting
**********************/
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
	@custid,
	1231,
	181,
	0,
	0,
	@v181mpositiontaking,
	0,
	0,
	0,
	0,
	0,
	@v181minbet,
	@v181maxbet
)

IF @@error <> 0
BEGIN
	--Error Occurs
	SELECT @ErrMsg = case @Language 
							when 'E' then 'Create customer fail. Please try again'
							ELSE [dbo].[f_Get_MsgNamebyMsgID](40004,@Language)
						end	
			,  @ErrCode=119
	-- ROLLBACK MANUALLY
	DELETE Dep_CustSetting WITH (ROWLOCK) WHERE custId  =@custid
	DELETE Dep_CustSetting3rd WITH (ROWLOCK) WHERE custId  =@custid
	
	DELETE P2PGameSetting WITH (ROWLOCK) WHERE custId  =@custid
	DELETE P2PGroupComm WITH (ROWLOCK) WHERE custId  =@custid
	DELETE CustSettingGame WITH(ROWLOCK) WHERE custid = @custid
	
	EXEC Acc_CustomerInsUserInfo_Rollback @CustID = @CustID
	RETURN 
END

/**********************************
* validate Min/Max Bet & MaxPerMatch
**********************************/
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
SELECT @v182MinBet_Max = cs3.minbet, 
	@v182MaxBet_Min = cs3.maxbet, 
	@v182mPositionTaking_Max = cs3.mpositiontaking
FROM custinfo ci WITH(NOLOCK)
	INNER JOIN Dep_CustSetting3rd cs3 ON ci.custid = cs3.custid
WHERE ci.custid = @srecommend
	AND cs3.sporttype = 182

IF 	@v182MinBet < @v182MinBet_Max AND @v182MinBet > 0 AND @v182MinBet_Max > 0
	OR @v182MaxBet > @v182MaxBet_Min AND @v182MaxBet > 0 AND @v182MaxBet_Min > 0
BEGIN
	 SELECT
		@ErrMsg =	case @Language 
							when 'E' then 'Min bet must be equal to or greater than super agent min bet .'
							ELSE [dbo].[f_Get_MsgNamebyMsgID](10006,@Language)
					end
										
	SELECT @ErrCode = 107
	EXEC Acc_CustomerInsUserInfo_Rollback @CustID = @CustID
	RETURN 
END 

IF (@v182mPositionTaking+@v182sPositionTaking>@v182mPositionTaking_Max)
BEGIN
	 SELECT @ErrMsg = case @Language 
							when 'E' then 'Wrong position taking (max for super set by company).<br>'
							ELSE [dbo].[f_Get_MsgNamebyMsgID](20004,@Language) + '<br>'
						end
	SELECT @ErrCode = 104
	EXEC Acc_CustomerInsUserInfo_Rollback @CustID = @CustID
	RETURN   
END

/**********************
* Insert Setting
**********************/
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
	@custid,
	1231,
	182,
	0,
	0,
	@v182mpositiontaking,
	0,
	0,
	0,
	0,
	0,
	@v182minbet,
	@v182maxbet
)

IF @@error <> 0
BEGIN
	--Error Occurs
	SELECT @ErrMsg = case @Language 
							when 'E' then 'Create customer fail. Please try again'
							ELSE [dbo].[f_Get_MsgNamebyMsgID](40004,@Language)
						end	
			,  @ErrCode=119
	-- ROLLBACK MANUALLY
	DELETE Dep_CustSetting WITH (ROWLOCK) WHERE custId  =@custid
	DELETE Dep_CustSetting3rd WITH (ROWLOCK) WHERE custId  =@custid
	
	DELETE P2PGameSetting WITH (ROWLOCK) WHERE custId  =@custid
	DELETE P2PGroupComm WITH (ROWLOCK) WHERE custId  =@custid
	DELETE CustSettingGame WITH(ROWLOCK) WHERE custid = @custid
	
	EXEC Acc_CustomerInsUserInfo_Rollback @CustID = @CustID
	RETURN 
END

/**********************************
* validate Min/Max Bet & MaxPerMatch
**********************************/
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
SELECT @v183MinBet_Max = cs3.minbet, 
	@v183MaxBet_Min = cs3.maxbet, 
	@v183mPositionTaking_Max = cs3.mpositiontaking
FROM custinfo ci WITH(NOLOCK)
	INNER JOIN Dep_CustSetting3rd cs3 ON ci.custid = cs3.custid
WHERE ci.custid = @srecommend
	AND cs3.sporttype = 183

IF 	@v183MinBet < @v183MinBet_Max AND @v183MinBet > 0 AND @v183MinBet_Max > 0
	OR @v183MaxBet > @v183MaxBet_Min AND @v183MaxBet > 0 AND @v183MaxBet_Min > 0
BEGIN
	 SELECT
		@ErrMsg =	case @Language 
							when 'E' then 'Min bet must be equal to or greater than super agent min bet .'
							ELSE [dbo].[f_Get_MsgNamebyMsgID](10006,@Language)
					end
										
	SELECT @ErrCode = 107
	EXEC Acc_CustomerInsUserInfo_Rollback @CustID = @CustID
	RETURN 
END 

IF (@v183mPositionTaking+@v183sPositionTaking>@v183mPositionTaking_Max)
BEGIN
	 SELECT @ErrMsg = case @Language 
							when 'E' then 'Wrong position taking (max for super set by company).<br>'
							ELSE [dbo].[f_Get_MsgNamebyMsgID](20004,@Language) + '<br>'
						end
	SELECT @ErrCode = 104
	EXEC Acc_CustomerInsUserInfo_Rollback @CustID = @CustID
	RETURN   
END

/**********************
* Insert Setting
**********************/
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
	@custid,
	1231,
	183,
	0,
	0,
	@v183mpositiontaking,
	0,
	0,
	0,
	0,
	0,
	@v183minbet,
	@v183maxbet
)

IF @@error <> 0
BEGIN
	--Error Occurs
	SELECT @ErrMsg = case @Language 
							when 'E' then 'Create customer fail. Please try again'
							ELSE [dbo].[f_Get_MsgNamebyMsgID](40004,@Language)
						end	
			,  @ErrCode=119
	-- ROLLBACK MANUALLY
	DELETE Dep_CustSetting WITH (ROWLOCK) WHERE custId  =@custid
	DELETE Dep_CustSetting3rd WITH (ROWLOCK) WHERE custId  =@custid
	
	DELETE P2PGameSetting WITH (ROWLOCK) WHERE custId  =@custid
	DELETE P2PGroupComm WITH (ROWLOCK) WHERE custId  =@custid
	DELETE CustSettingGame WITH(ROWLOCK) WHERE custid = @custid
	
	EXEC Acc_CustomerInsUserInfo_Rollback @CustID = @CustID
	RETURN 
END

/**********************************
* validate Min/Max Bet & MaxPerMatch
**********************************/
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
SELECT @v184MinBet_Max = cs3.minbet, 
	@v184MaxBet_Min = cs3.maxbet, 
	@v184mPositionTaking_Max = cs3.mpositiontaking
FROM custinfo ci WITH(NOLOCK)
	INNER JOIN Dep_CustSetting3rd cs3 ON ci.custid = cs3.custid
WHERE ci.custid = @srecommend
	AND cs3.sporttype = 184

IF 	@v184MinBet < @v184MinBet_Max AND @v184MinBet > 0 AND @v184MinBet_Max > 0
	OR @v184MaxBet > @v184MaxBet_Min AND @v184MaxBet > 0 AND @v184MaxBet_Min > 0
BEGIN
	 SELECT
		@ErrMsg =	case @Language 
							when 'E' then 'Min bet must be equal to or greater than super agent min bet .'
							ELSE [dbo].[f_Get_MsgNamebyMsgID](10006,@Language)
					end
										
	SELECT @ErrCode = 107
	EXEC Acc_CustomerInsUserInfo_Rollback @CustID = @CustID
	RETURN 
END 

IF (@v184mPositionTaking+@v184sPositionTaking>@v184mPositionTaking_Max)
BEGIN
	 SELECT @ErrMsg = case @Language 
							when 'E' then 'Wrong position taking (max for super set by company).<br>'
							ELSE [dbo].[f_Get_MsgNamebyMsgID](20004,@Language) + '<br>'
						end
	SELECT @ErrCode = 104
	EXEC Acc_CustomerInsUserInfo_Rollback @CustID = @CustID
	RETURN   
END

/**********************
* Insert Setting
**********************/
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
	@custid,
	1231,
	184,
	0,
	0,
	@v184mpositiontaking,
	0,
	0,
	0,
	0,
	0,
	@v184minbet,
	@v184maxbet
)

IF @@error <> 0
BEGIN
	--Error Occurs
	SELECT @ErrMsg = case @Language 
							when 'E' then 'Create customer fail. Please try again'
							ELSE [dbo].[f_Get_MsgNamebyMsgID](40004,@Language)
						end	
			,  @ErrCode=119
	-- ROLLBACK MANUALLY
	DELETE Dep_CustSetting WITH (ROWLOCK) WHERE custId  =@custid
	DELETE Dep_CustSetting3rd WITH (ROWLOCK) WHERE custId  =@custid
	
	DELETE P2PGameSetting WITH (ROWLOCK) WHERE custId  =@custid
	DELETE P2PGroupComm WITH (ROWLOCK) WHERE custId  =@custid
	DELETE CustSettingGame WITH(ROWLOCK) WHERE custid = @custid
	
	EXEC Acc_CustomerInsUserInfo_Rollback @CustID = @CustID
	RETURN 
END

/**********************************
* validate Min/Max Bet & MaxPerMatch
**********************************/
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
SELECT @v185MinBet_Max = cs3.minbet, 
	@v185MaxBet_Min = cs3.maxbet, 
	@v185mPositionTaking_Max = cs3.mpositiontaking
FROM custinfo ci WITH(NOLOCK)
	INNER JOIN Dep_CustSetting3rd cs3 ON ci.custid = cs3.custid
WHERE ci.custid = @srecommend
	AND cs3.sporttype = 185

IF 	@v185MinBet < @v185MinBet_Max AND @v185MinBet > 0 AND @v185MinBet_Max > 0
	OR @v185MaxBet > @v185MaxBet_Min AND @v185MaxBet > 0 AND @v185MaxBet_Min > 0
BEGIN
	 SELECT
		@ErrMsg =	case @Language 
							when 'E' then 'Min bet must be equal to or greater than super agent min bet .'
							ELSE [dbo].[f_Get_MsgNamebyMsgID](10006,@Language)
					end
										
	SELECT @ErrCode = 107
	EXEC Acc_CustomerInsUserInfo_Rollback @CustID = @CustID
	RETURN 
END 

IF (@v185mPositionTaking+@v185sPositionTaking>@v185mPositionTaking_Max)
BEGIN
	 SELECT @ErrMsg = case @Language 
							when 'E' then 'Wrong position taking (max for super set by company).<br>'
							ELSE [dbo].[f_Get_MsgNamebyMsgID](20004,@Language) + '<br>'
						end
	SELECT @ErrCode = 104
	EXEC Acc_CustomerInsUserInfo_Rollback @CustID = @CustID
	RETURN   
END

/**********************
* Insert Setting
**********************/
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
	@custid,
	1231,
	185,
	0,
	0,
	@v185mpositiontaking,
	0,
	0,
	0,
	0,
	0,
	@v185minbet,
	@v185maxbet
)

IF @@error <> 0
BEGIN
	--Error Occurs
	SELECT @ErrMsg = case @Language 
							when 'E' then 'Create customer fail. Please try again'
							ELSE [dbo].[f_Get_MsgNamebyMsgID](40004,@Language)
						end	
			,  @ErrCode=119
	-- ROLLBACK MANUALLY
	DELETE Dep_CustSetting WITH (ROWLOCK) WHERE custId  =@custid
	DELETE Dep_CustSetting3rd WITH (ROWLOCK) WHERE custId  =@custid
	
	DELETE P2PGameSetting WITH (ROWLOCK) WHERE custId  =@custid
	DELETE P2PGroupComm WITH (ROWLOCK) WHERE custId  =@custid
	DELETE CustSettingGame WITH(ROWLOCK) WHERE custid = @custid
	
	EXEC Acc_CustomerInsUserInfo_Rollback @CustID = @CustID
	RETURN 
END


/**********************************
* validate Min/Max Bet & MaxPerMatch
**********************************/
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
SELECT @v186MinBet_Max = cs3.minbet, 
	@v186MaxBet_Min = cs3.maxbet, 
	@v186mPositionTaking_Max = cs3.mpositiontaking
FROM custinfo ci WITH(NOLOCK)
	INNER JOIN Dep_CustSetting3rd cs3 ON ci.custid = cs3.custid
WHERE ci.custid = @srecommend
	AND cs3.sporttype = 186

IF 	@v186MinBet < @v186MinBet_Max AND @v186MinBet > 0 AND @v186MinBet_Max > 0
	OR @v186MaxBet > @v186MaxBet_Min AND @v186MaxBet > 0 AND @v186MaxBet_Min > 0
BEGIN
	 SELECT
		@ErrMsg =	case @Language 
							when 'E' then 'Min bet must be equal to or greater than super agent min bet .'
							ELSE [dbo].[f_Get_MsgNamebyMsgID](10006,@Language)
					end
										
	SELECT @ErrCode = 107
	EXEC Acc_CustomerInsUserInfo_Rollback @CustID = @CustID
	RETURN 
END 

IF (@v186mPositionTaking+@v186sPositionTaking>@v186mPositionTaking_Max)
BEGIN
	 SELECT @ErrMsg = case @Language 
							when 'E' then 'Wrong position taking (max for super set by company).<br>'
							ELSE [dbo].[f_Get_MsgNamebyMsgID](20004,@Language) + '<br>'
						end
	SELECT @ErrCode = 104
	EXEC Acc_CustomerInsUserInfo_Rollback @CustID = @CustID
	RETURN   
END

/**********************
* Insert Setting
**********************/
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
	@custid,
	1220,
	186,
	0,
	0,
	@v186mpositiontaking,
	0,
	0,
	0,
	0,
	0,
	@v186minbet,
	@v186maxbet
)

IF @@error <> 0
BEGIN
	--Error Occurs
	SELECT @ErrMsg = case @Language 
							when 'E' then 'Create customer fail. Please try again'
							ELSE [dbo].[f_Get_MsgNamebyMsgID](40004,@Language)
						end	
			,  @ErrCode=119
	-- ROLLBACK MANUALLY
	DELETE Dep_CustSetting WITH (ROWLOCK) WHERE custId  =@custid
	DELETE Dep_CustSetting3rd WITH (ROWLOCK) WHERE custId  =@custid
	
	DELETE P2PGameSetting WITH (ROWLOCK) WHERE custId  =@custid
	DELETE P2PGroupComm WITH (ROWLOCK) WHERE custId  =@custid
	DELETE CustSettingGame WITH(ROWLOCK) WHERE custid = @custid
	
	EXEC Acc_CustomerInsUserInfo_Rollback @CustID = @CustID
	RETURN 
END

GO
GRANT EXECUTE ON [dbo].[Acc_Dep_CustomerInsMemberVirtualSports_SAg] TO [bodbAdminNet] AS [dbo]
GO
GRANT EXECUTE ON [dbo].[Acc_Dep_CustomerInsMemberVirtualSports_SAg] TO [bodbExtAccNet] AS [dbo]
GO
GRANT VIEW DEFINITION ON [dbo].[Acc_Dep_CustomerInsMemberVirtualSports_SAg] TO [vnteam] AS [dbo]