ALTER PROCEDURE [dbo].[Acc_Dep_CustomerInsMemberVirtualSports_Ag]
	@custid INT,
	@recommend INT,

	@v180aPositionTaking SMALLMONEY,
	@v180MinBet MONEY,
	@v180MaxBet MONEY,
	
	@v181aPositionTaking SMALLMONEY,
	@v181MinBet MONEY,
	@v181MaxBet MONEY,

	@v182aPositionTaking SMALLMONEY,
	@v182MinBet MONEY,
	@v182MaxBet MONEY,

	@v183aPositionTaking SMALLMONEY,
	@v183MinBet MONEY,
	@v183MaxBet MONEY,

	@v184aPositionTaking SMALLMONEY,
	@v184MinBet MONEY,
	@v184MaxBet MONEY,

	@v185aPositionTaking SMALLMONEY,
	@v185MinBet MONEY,
	@v185MaxBet MONEY,

	@v186aPositionTaking SMALLMONEY,
	@v186MinBet MONEY,
	@v186MaxBet MONEY,


	@ErrCode int = 0 OUTPUT,
	@Language VARCHAR(2) = 'E',
	@ErrMsg nvarchar(4000) = '' OUTPUT
AS

--@Source Control
/*
Created: 20122808@Dom
Task : Agent create Member's info and settings for virutal sport in Deposite site
DB: DBTRANS.bodb02
Original:
Revisions:
	- 20121128@Elodie: Get an error message from f_Get_MsgNameByMsgID function by language
	- 20131014@Francis: Support adding new virtual sports with settings
Param's Explanation:
• @ErrCode:
    = 0: Create member successfully.
    > 0: Specific Error.
  
• @ErrMsg: Error description.
*/

declare @startRun datetime
declare @endRun datetime
declare @duration int
set @startRun = getdate()

DECLARE @v180aPositionTaking_Max SMALLMONEY,
		@v180mPositionTaking SMALLMONEY,
		@v180sPositionTaking SMALLMONEY,
		@v180MinBet_Max MONEY,
		@v180MaxBet_Min MONEY,
		@v180MaxPerMatch_Max MONEY,

		@v181aPositionTaking_Max SMALLMONEY,
		@v181mPositionTaking SMALLMONEY,
		@v181sPositionTaking SMALLMONEY,
		@v181MinBet_Max MONEY,
		@v181MaxBet_Min MONEY,
		@v181MaxPerMatch_Max MONEY,

		@v182aPositionTaking_Max SMALLMONEY,
		@v182mPositionTaking SMALLMONEY,
		@v182sPositionTaking SMALLMONEY,
		@v182MinBet_Max MONEY,
		@v182MaxBet_Min MONEY,
		@v182MaxPerMatch_Max MONEY,

		@v183aPositionTaking_Max SMALLMONEY,
		@v183mPositionTaking SMALLMONEY,
		@v183sPositionTaking SMALLMONEY,
		@v183MinBet_Max MONEY,
		@v183MaxBet_Min MONEY,
		@v183MaxPerMatch_Max MONEY,

		@v184aPositionTaking_Max SMALLMONEY,
		@v184mPositionTaking SMALLMONEY,
		@v184sPositionTaking SMALLMONEY,
		@v184MinBet_Max MONEY,
		@v184MaxBet_Min MONEY,
		@v184MaxPerMatch_Max MONEY,

		@v185aPositionTaking_Max SMALLMONEY,
		@v185mPositionTaking SMALLMONEY,
		@v185sPositionTaking SMALLMONEY,
		@v185MinBet_Max MONEY,
		@v185MaxBet_Min MONEY,
		@v185MaxPerMatch_Max MONEY,

		@v186aPositionTaking_Max SMALLMONEY,
		@v186mPositionTaking SMALLMONEY,
		@v186sPositionTaking SMALLMONEY,
		@v186MinBet_Max MONEY,
		@v186MaxBet_Min MONEY,
		@v186MaxPerMatch_Max MONEY,
		
		@DisableVirtualSports BIT,
		
		@srecommend INT,
		@mrecommend INT
		
SELECT @DisableVirtualSports = DisableVirtualSports,
	@mrecommend = mrecommend,
	@srecommend = srecommend
FROM custinfo WITH (NOLOCK)
WHERE custid = @recommend

SELECT @v180sPositionTaking = 0,
	@v180mPositionTaking = 0,
	
	@v181sPositionTaking = 0,
	@v181mPositionTaking = 0,

	@v182sPositionTaking = 0,
	@v182mPositionTaking = 0,

	@v183sPositionTaking = 0,
	@v183mPositionTaking = 0,

	@v184sPositionTaking = 0,
	@v184mPositionTaking = 0,

	@v185sPositionTaking = 0,
	@v185mPositionTaking = 0,

	@v186sPositionTaking = 0,
	@v186mPositionTaking = 0
	

SELECT @v180sPositionTaking = isnull(cs3.spositiontaking,0)
FROM Dep_CustSetting3rd cs3 WITH (NOLOCK)
WHERE cs3.custid = @mrecommend and sporttype = 180
SELECT @v180mPositionTaking = isnull(cs3.mpositiontaking,0)
FROM Dep_CustSetting3rd cs3 WITH (NOLOCK)
WHERE cs3.custid = @recommend and sporttype = 180


SELECT @v181sPositionTaking = isnull(cs3.spositiontaking,0)
FROM Dep_CustSetting3rd cs3 WITH (NOLOCK)
WHERE cs3.custid = @mrecommend and sporttype = 181
SELECT @v181mPositionTaking = isnull(cs3.mpositiontaking,0)
FROM Dep_CustSetting3rd cs3 WITH (NOLOCK)
WHERE cs3.custid = @recommend and sporttype = 181

SELECT @v182sPositionTaking = isnull(cs3.spositiontaking,0)
FROM Dep_CustSetting3rd cs3 WITH (NOLOCK)
WHERE cs3.custid = @mrecommend and sporttype = 182
SELECT @v182mPositionTaking = isnull(cs3.mpositiontaking,0)
FROM Dep_CustSetting3rd cs3 WITH (NOLOCK)
WHERE cs3.custid = @recommend and sporttype = 182

SELECT @v183sPositionTaking = isnull(cs3.spositiontaking,0)
FROM Dep_CustSetting3rd cs3 WITH (NOLOCK)
WHERE cs3.custid = @mrecommend and sporttype = 183
SELECT @v183mPositionTaking = isnull(cs3.mpositiontaking,0)
FROM Dep_CustSetting3rd cs3 WITH (NOLOCK)
WHERE cs3.custid = @recommend and sporttype = 183

SELECT @v184sPositionTaking = isnull(cs3.spositiontaking,0)
FROM Dep_CustSetting3rd cs3 WITH (NOLOCK)
WHERE cs3.custid = @mrecommend and sporttype = 184
SELECT @v184mPositionTaking = isnull(cs3.mpositiontaking,0)
FROM Dep_CustSetting3rd cs3 WITH (NOLOCK)
WHERE cs3.custid = @recommend and sporttype = 184

SELECT @v185sPositionTaking = isnull(cs3.spositiontaking,0)
FROM Dep_CustSetting3rd cs3 WITH (NOLOCK)
WHERE cs3.custid = @mrecommend and sporttype = 185
SELECT @v185mPositionTaking = isnull(cs3.mpositiontaking,0)
FROM Dep_CustSetting3rd cs3 WITH (NOLOCK)
WHERE cs3.custid = @recommend and sporttype = 185

SELECT @v186sPositionTaking = isnull(cs3.spositiontaking,0)
FROM Dep_CustSetting3rd cs3 WITH (NOLOCK)
WHERE cs3.custid = @mrecommend and sporttype = 186
SELECT @v186mPositionTaking = isnull(cs3.mpositiontaking,0)
FROM Dep_CustSetting3rd cs3 WITH (NOLOCK)
WHERE cs3.custid = @recommend and sporttype = 186



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
SELECT @v180aPositionTaking_Max = cs3.apositiontaking
FROM Dep_CustSetting3rd cs3 WITH(NOLOCK)
WHERE cs3.custid = @recommend and sporttype = 180

SELECT @v180MaxPerMatch_Max = min(CASE WHEN ci.maxpermatch180 = 0 THEN NULL ELSE ci.maxpermatch180 END), 
	@v180MinBet_Max = MAX(cs3.minbet), 
	@v180MaxBet_Min = min(cs3.maxbet)
FROM custinfo ci WITH(NOLOCK)
	INNER JOIN Dep_CustSetting3rd cs3 WITH(NOLOCK) ON (ci.custid = cs3.custid OR ci.mrecommend = cs3.custid OR ci.srecommend = cs3.custid)
WHERE ci.custid = @recommend
	AND cs3.sporttype = 180

IF (@v180MinBet < @v180MinBet_Max and @v180MinBet > 0 AND @v180MinBet_Max > 0)
	OR (@v180MaxBet > @v180MaxBet_Min and @v180MaxBet > 0 AND @v180MaxBet_Min > 0)
BEGIN
	 SELECT
		@ErrMsg =	case @Language 
							when 'E' then 'Min bet must be equal to or greater than agent min bet .'
							ELSE [dbo].[f_Get_MsgNamebyMsgID](10006,@Language)
					end
										
	SELECT @ErrCode = 107
	EXEC Acc_CustomerInsUserInfo_Rollback @CustID = @CustID
	RETURN 
END 

IF (@v180aPositionTaking>@v180aPositionTaking_Max)
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
	@custid,
	1201,
	180,
	0,
	@v180aPositionTaking,
	@v180mPositionTaking,
	@v180sPositionTaking,
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
SELECT @v181aPositionTaking_Max = cs3.apositiontaking
FROM Dep_CustSetting3rd cs3 WITH(NOLOCK)
WHERE cs3.custid = @recommend and sporttype = 181

SELECT @v181MaxPerMatch_Max = min(CASE WHEN ci.maxpermatch181 = 0 THEN NULL ELSE ci.maxpermatch181 END), 
	@v181MinBet_Max = MAX(cs3.minbet), 
	@v181MaxBet_Min = min(cs3.maxbet)
FROM custinfo ci WITH(NOLOCK)
	INNER JOIN Dep_CustSetting3rd cs3 WITH(NOLOCK) ON (ci.custid = cs3.custid OR ci.mrecommend = cs3.custid OR ci.srecommend = cs3.custid)
WHERE ci.custid = @recommend
	AND cs3.sporttype = 181

IF (@v181MinBet < @v181MinBet_Max and @v181MinBet > 0 AND @v181MinBet_Max > 0)
	OR (@v181MaxBet > @v181MaxBet_Min and @v181MaxBet > 0 AND @v181MaxBet_Min > 0)
BEGIN
	 SELECT
		@ErrMsg =	case @Language 
							when 'E' then 'Min bet must be equal to or greater than agent min bet .'
							ELSE [dbo].[f_Get_MsgNamebyMsgID](10006,@Language)
					end
										
	SELECT @ErrCode = 107
	EXEC Acc_CustomerInsUserInfo_Rollback @CustID = @CustID
	RETURN 
END 

IF (@v181aPositionTaking>@v181aPositionTaking_Max)
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
	@custid,
	1231,
	181,
	0,
	@v181aPositionTaking,
	@v181mPositionTaking,
	@v181sPositionTaking,
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
SELECT @v182aPositionTaking_Max = cs3.apositiontaking
FROM Dep_CustSetting3rd cs3 WITH(NOLOCK)
WHERE cs3.custid = @recommend and sporttype = 182

SELECT @v182MaxPerMatch_Max = min(CASE WHEN ci.maxpermatch182 = 0 THEN NULL ELSE ci.maxpermatch182 END), 
	@v182MinBet_Max = MAX(cs3.minbet), 
	@v182MaxBet_Min = min(cs3.maxbet)
FROM custinfo ci WITH(NOLOCK)
	INNER JOIN Dep_CustSetting3rd cs3 WITH(NOLOCK) ON (ci.custid = cs3.custid OR ci.mrecommend = cs3.custid OR ci.srecommend = cs3.custid)
WHERE ci.custid = @recommend
	AND cs3.sporttype = 182

IF (@v182MinBet < @v182MinBet_Max and @v182MinBet > 0 AND @v182MinBet_Max > 0)
	OR (@v182MaxBet > @v182MaxBet_Min and @v182MaxBet > 0 AND @v182MaxBet_Min > 0)
BEGIN
	 SELECT
		@ErrMsg =	case @Language 
							when 'E' then 'Min bet must be equal to or greater than agent min bet .'
							ELSE [dbo].[f_Get_MsgNamebyMsgID](10006,@Language)
					end
										
	SELECT @ErrCode = 107
	EXEC Acc_CustomerInsUserInfo_Rollback @CustID = @CustID
	RETURN 
END 

IF (@v182aPositionTaking>@v182aPositionTaking_Max)
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
	@custid,
	1231,
	182,
	0,
	@v182aPositionTaking,
	@v182mPositionTaking,
	@v182sPositionTaking,
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
SELECT @v183aPositionTaking_Max = cs3.apositiontaking
FROM Dep_CustSetting3rd cs3 WITH(NOLOCK)
WHERE cs3.custid = @recommend and sporttype = 183

SELECT @v183MinBet_Max = MAX(cs3.minbet), 
	@v183MaxBet_Min = min(cs3.maxbet)
FROM custinfo ci WITH(NOLOCK)
	INNER JOIN Dep_CustSetting3rd cs3 WITH(NOLOCK) ON (ci.custid = cs3.custid OR ci.mrecommend = cs3.custid OR ci.srecommend = cs3.custid)
WHERE ci.custid = @recommend
	AND cs3.sporttype = 183

IF (@v183MinBet < @v183MinBet_Max and @v183MinBet > 0 AND @v183MinBet_Max > 0)
	OR (@v183MaxBet > @v183MaxBet_Min and @v183MaxBet > 0 AND @v183MaxBet_Min > 0)
BEGIN
	 SELECT
		@ErrMsg =	case @Language 
							when 'E' then 'Min bet must be equal to or greater than agent min bet .'
							ELSE [dbo].[f_Get_MsgNamebyMsgID](10006,@Language)
					end
										
	SELECT @ErrCode = 107
	EXEC Acc_CustomerInsUserInfo_Rollback @CustID = @CustID
	RETURN 
END 

IF (@v183aPositionTaking>@v183aPositionTaking_Max)
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
	@custid,
	1231,
	183,
	0,
	@v183aPositionTaking,
	@v183mPositionTaking,
	@v183sPositionTaking,
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
SELECT @v184aPositionTaking_Max = cs3.apositiontaking
FROM Dep_CustSetting3rd cs3 WITH(NOLOCK)
WHERE cs3.custid = @recommend and sporttype = 184

SELECT @v184MaxPerMatch_Max = min(CASE WHEN ci.maxpermatch184 = 0 THEN NULL ELSE ci.maxpermatch184 END), 
	@v184MinBet_Max = MAX(cs3.minbet), 
	@v184MaxBet_Min = min(cs3.maxbet)
FROM custinfo ci WITH(NOLOCK)
	INNER JOIN Dep_CustSetting3rd cs3 WITH(NOLOCK) ON (ci.custid = cs3.custid OR ci.mrecommend = cs3.custid OR ci.srecommend = cs3.custid)
WHERE ci.custid = @recommend
	AND cs3.sporttype = 184

IF (@v184MinBet < @v184MinBet_Max and @v184MinBet > 0 AND @v184MinBet_Max > 0)
	OR (@v184MaxBet > @v184MaxBet_Min and @v184MaxBet > 0 AND @v184MaxBet_Min > 0)
BEGIN
	 SELECT
		@ErrMsg =	case @Language 
							when 'E' then 'Min bet must be equal to or greater than agent min bet .'
							ELSE [dbo].[f_Get_MsgNamebyMsgID](10006,@Language)
					end
										
	SELECT @ErrCode = 107
	EXEC Acc_CustomerInsUserInfo_Rollback @CustID = @CustID
	RETURN 
END 

IF (@v184aPositionTaking>@v184aPositionTaking_Max)
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
	@custid,
	1231,
	184,
	0,
	@v184aPositionTaking,
	@v184mPositionTaking,
	@v184sPositionTaking,
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
SELECT @v185aPositionTaking_Max = cs3.apositiontaking
FROM Dep_CustSetting3rd cs3 WITH(NOLOCK)
WHERE cs3.custid = @recommend and sporttype = 185

SELECT @v185MinBet_Max = MAX(cs3.minbet), 
	@v185MaxBet_Min = min(cs3.maxbet)
FROM custinfo ci WITH(NOLOCK)
	INNER JOIN Dep_CustSetting3rd cs3 WITH(NOLOCK) ON (ci.custid = cs3.custid OR ci.mrecommend = cs3.custid OR ci.srecommend = cs3.custid)
WHERE ci.custid = @recommend
	AND cs3.sporttype = 185

IF (@v185MinBet < @v185MinBet_Max and @v185MinBet > 0 AND @v185MinBet_Max > 0)
	OR (@v185MaxBet > @v185MaxBet_Min and @v185MaxBet > 0 AND @v185MaxBet_Min > 0)
BEGIN
	 SELECT
		@ErrMsg =	case @Language 
							when 'E' then 'Min bet must be equal to or greater than agent min bet .'
							ELSE [dbo].[f_Get_MsgNamebyMsgID](10006,@Language)
					end
										
	SELECT @ErrCode = 107
	EXEC Acc_CustomerInsUserInfo_Rollback @CustID = @CustID
	RETURN 
END 

IF (@v185aPositionTaking>@v185aPositionTaking_Max)
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
	@custid,
	1231,
	185,
	0,
	@v185aPositionTaking,
	@v185mPositionTaking,
	@v185sPositionTaking,
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
SELECT @v186aPositionTaking_Max = cs3.apositiontaking
FROM Dep_CustSetting3rd cs3 WITH(NOLOCK)
WHERE cs3.custid = @recommend and sporttype = 186

SELECT @v186MaxPerMatch_Max = min(CASE WHEN ci.maxpermatch186 = 0 THEN NULL ELSE ci.maxpermatch186 END), 
	@v186MinBet_Max = MAX(cs3.minbet), 
	@v186MaxBet_Min = min(cs3.maxbet)
FROM custinfo ci WITH(NOLOCK)
	INNER JOIN Dep_CustSetting3rd cs3 WITH(NOLOCK) ON (ci.custid = cs3.custid OR ci.mrecommend = cs3.custid OR ci.srecommend = cs3.custid)
WHERE ci.custid = @recommend
	AND cs3.sporttype = 186

IF (@v186MinBet < @v186MinBet_Max and @v186MinBet > 0 AND @v186MinBet_Max > 0)
	OR (@v186MaxBet > @v186MaxBet_Min and @v186MaxBet > 0 AND @v186MaxBet_Min > 0)
BEGIN
	 SELECT
		@ErrMsg =	case @Language 
							when 'E' then 'Min bet must be equal to or greater than agent min bet .'
							ELSE [dbo].[f_Get_MsgNamebyMsgID](10006,@Language)
					end
										
	SELECT @ErrCode = 107
	EXEC Acc_CustomerInsUserInfo_Rollback @CustID = @CustID
	RETURN 
END 

IF (@v186aPositionTaking>@v186aPositionTaking_Max)
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
	@custid,
	1220,
	186,
	0,
	@v186aPositionTaking,
	@v186mPositionTaking,
	@v186sPositionTaking,
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
GRANT EXECUTE ON [dbo].[Acc_Dep_CustomerInsMemberVirtualSports_Ag] TO [bodbAdminNet] WITH GRANT OPTION  AS [dbo]
GO
GRANT EXECUTE ON [dbo].[Acc_Dep_CustomerInsMemberVirtualSports_Ag] TO [bodbExtAccNet] AS [dbo]
GO
GRANT VIEW DEFINITION ON [dbo].[Acc_Dep_CustomerInsMemberVirtualSports_Ag] TO [vnteam] AS [dbo]