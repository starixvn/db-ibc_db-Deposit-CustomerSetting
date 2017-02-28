ALTER PROCEDURE [dbo].[Acc_Dep_CustomerInsMemberVirtualSports_Com]
	@custid INT, 

	@v180MinBet MONEY,
	@v180MaxBet MONEY,
	@v180sPositionTaking SMALLMONEY,
	@v180mPositionTaking SMALLMONEY,
	@v180aPositionTaking SMALLMONEY,

	@v181MinBet MONEY,
	@v181MaxBet MONEY,
	@v181sPositionTaking SMALLMONEY,
	@v181mPositionTaking SMALLMONEY,
	@v181aPositionTaking SMALLMONEY,

	@v182MinBet MONEY,
	@v182MaxBet MONEY,
	@v182sPositionTaking SMALLMONEY,
	@v182mPositionTaking SMALLMONEY,
	@v182aPositionTaking SMALLMONEY,

	@v183MinBet MONEY,
	@v183MaxBet MONEY,
	@v183sPositionTaking SMALLMONEY,
	@v183mPositionTaking SMALLMONEY,
	@v183aPositionTaking SMALLMONEY,

	@v184MinBet MONEY,
	@v184MaxBet MONEY,
	@v184sPositionTaking SMALLMONEY,
	@v184mPositionTaking SMALLMONEY,
	@v184aPositionTaking SMALLMONEY,

	@v185MinBet MONEY,
	@v185MaxBet MONEY,
	@v185sPositionTaking SMALLMONEY,
	@v185mPositionTaking SMALLMONEY,
	@v185aPositionTaking SMALLMONEY,

	@v186MinBet MONEY,
	@v186MaxBet MONEY,
	@v186sPositionTaking SMALLMONEY,
	@v186mPositionTaking SMALLMONEY,
	@v186aPositionTaking SMALLMONEY,

	@Language VARCHAR(2)= 'E',
	@ErrCode INT = 0 OUTPUT,
	@ErrMsg NVARCHAR(2000) = '' OUTPUT
 AS
 SET NOCOUNT ON
 DECLARE @startRun DATETIME , @endRun DATETIME , @duration INT
 SET @startRun = GETDATE()
 
 --@Source Control
/*
Created: 20122708@Dom
Task : Company create Super's info and settings for virutal sport in Deposite site
DB: DBTRANS.bodb02
Original:
Revisions:
	- 20121128@Elodie: Get an error message from f_Get_MsgNameByMsgID function by language
	- 20131014@Francis: Support adding new virtual sports with settings
    
Param's Explanation:
• @ErrCode:
    = 0: Create super successfully.
    > 0: Specific Error.
  
• @ErrMsg: Error description.
*/

IF  
    @v180MinBet < 0 
	OR @v180MaxBet < 0
	OR @v180sPositionTaking < 0
	OR @v180mPositionTaking < 0
	OR @v180aPositionTaking < 0
	OR @v180sPositionTaking > 0.9
	OR @v180mPositionTaking > 0.9
	OR @v180aPositionTaking > 0.9
	OR @v180MinBet > @v180MaxBet

	OR @v181MinBet < 0
	OR @v181MaxBet < 0
	OR @v181sPositionTaking < 0
	OR @v181mPositionTaking < 0
	OR @v181aPositionTaking < 0
	OR @v181sPositionTaking > 0.9
	OR @v181mPositionTaking > 0.9
	OR @v181aPositionTaking > 0.9
	OR @v181MinBet > @v181MaxBet

    OR @v182MinBet < 0 
	OR @v182MaxBet < 0
	OR @v182sPositionTaking < 0
	OR @v182mPositionTaking < 0
	OR @v182aPositionTaking < 0
	OR @v182sPositionTaking > 0.9
	OR @v182mPositionTaking > 0.9
	OR @v182aPositionTaking > 0.9
	OR @v182MinBet > @v182MaxBet

	OR @v183MinBet < 0 
	OR @v183MaxBet < 0
	OR @v183sPositionTaking < 0
	OR @v183mPositionTaking < 0
	OR @v183aPositionTaking < 0
	OR @v183sPositionTaking > 0.9
	OR @v183mPositionTaking > 0.9
	OR @v183aPositionTaking > 0.9
	OR @v183MinBet > @v183MaxBet

	OR @v184MinBet < 0 
	OR @v184MaxBet < 0
	OR @v184sPositionTaking < 0
	OR @v184mPositionTaking < 0
	OR @v184aPositionTaking < 0
	OR @v184sPositionTaking > 0.9
	OR @v184mPositionTaking > 0.9
	OR @v184aPositionTaking > 0.9
	OR @v184MinBet > @v184MaxBet

	OR @v185MinBet < 0 
	OR @v185MaxBet < 0
	OR @v185sPositionTaking < 0
	OR @v185mPositionTaking < 0
	OR @v185aPositionTaking < 0
	OR @v185sPositionTaking > 0.9
	OR @v185mPositionTaking > 0.9
	OR @v185aPositionTaking > 0.9
	OR @v185MinBet > @v185MaxBet

	OR @v186MinBet < 0
	OR @v186MaxBet < 0
	OR @v186sPositionTaking < 0
	OR @v186mPositionTaking < 0
	OR @v186aPositionTaking < 0
	OR @v186sPositionTaking > 0.9
	OR @v186mPositionTaking > 0.9
	OR @v186aPositionTaking > 0.9
	OR @v186MinBet > @v186MaxBet
BEGIN 
	SELECT @ErrCode = 3,
			@ErrMsg = CASE @Language 
						WHEN 'E' THEN 'Wrong position taking.'
						ELSE [dbo].[f_Get_MsgNamebyMsgID](20001,@Language)
			          END
	RETURN
END  

--------------------Add Setting--------------------------
INSERT INTO Dep_CustSetting3rd ([custid],
		[bettype],
		[sporttype],
		[islive],
		[apositiontaking],
		[mpositiontaking],
		[spositiontaking],
		[playerdiscount],
		[discount],
		[adiscount],
		[sdiscount],
		[minbet],
		[maxbet]) 
	VALUES (
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
		@v180MaxBet)

IF @@ERROR <> 0
BEGIN
	--Error Occurs
	
	SELECT @ErrMsg = CASE @Language 
							when 'E' then 'Create customer fail. Please try again'
							ELSE [dbo].[f_Get_MsgNamebyMsgID](40004,@Language)
						END	
			, @ErrCode=116
	
	RETURN
END 

INSERT INTO Dep_CustSetting3rd ([custid],
		[bettype],
		[sporttype],
		[islive],
		[apositiontaking],
		[mpositiontaking],
		[spositiontaking],
		[playerdiscount],
		[discount],
		[adiscount],
		[sdiscount],
		[minbet],
		[maxbet]) 
	VALUES (
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
		@v181MaxBet)

IF @@ERROR <> 0
BEGIN
	--Error Occurs
	
	SELECT @ErrMsg = CASE @Language 
							when 'E' then 'Create customer fail. Please try again'
							ELSE [dbo].[f_Get_MsgNamebyMsgID](40004,@Language)
						END	
			, @ErrCode=116
	
	RETURN
END 

INSERT INTO Dep_CustSetting3rd ([custid],
		[bettype],
		[sporttype],
		[islive],
		[apositiontaking],
		[mpositiontaking],
		[spositiontaking],
		[playerdiscount],
		[discount],
		[adiscount],
		[sdiscount],
		[minbet],
		[maxbet]) 
	VALUES (
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
		@v182MaxBet)

IF @@ERROR <> 0
BEGIN
	--Error Occurs
	
	SELECT @ErrMsg = CASE @Language 
							when 'E' then 'Create customer fail. Please try again'
							ELSE [dbo].[f_Get_MsgNamebyMsgID](40004,@Language)
						END	
			, @ErrCode=116
	
	RETURN
END 

INSERT INTO Dep_CustSetting3rd ([custid],
		[bettype],
		[sporttype],
		[islive],
		[apositiontaking],
		[mpositiontaking],
		[spositiontaking],
		[playerdiscount],
		[discount],
		[adiscount],
		[sdiscount],
		[minbet],
		[maxbet]) 
	VALUES (
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
		@v183MaxBet)

IF @@ERROR <> 0
BEGIN
	--Error Occurs
	
	SELECT @ErrMsg = CASE @Language 
							when 'E' then 'Create customer fail. Please try again'
							ELSE [dbo].[f_Get_MsgNamebyMsgID](40004,@Language)
						END	
			, @ErrCode=116
	
	RETURN
END 

INSERT INTO Dep_CustSetting3rd ([custid],
		[bettype],
		[sporttype],
		[islive],
		[apositiontaking],
		[mpositiontaking],
		[spositiontaking],
		[playerdiscount],
		[discount],
		[adiscount],
		[sdiscount],
		[minbet],
		[maxbet]) 
	VALUES (
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
		@v184MaxBet)

IF @@ERROR <> 0
BEGIN
	--Error Occurs
	
	SELECT @ErrMsg = CASE @Language 
							when 'E' then 'Create customer fail. Please try again'
							ELSE [dbo].[f_Get_MsgNamebyMsgID](40004,@Language)
						END	
			, @ErrCode=116
	
	RETURN
END 

INSERT INTO Dep_CustSetting3rd ([custid],
		[bettype],
		[sporttype],
		[islive],
		[apositiontaking],
		[mpositiontaking],
		[spositiontaking],
		[playerdiscount],
		[discount],
		[adiscount],
		[sdiscount],
		[minbet],
		[maxbet]) 
	VALUES (
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
		@v185MaxBet)

IF @@ERROR <> 0
BEGIN
	--Error Occurs
	
	SELECT @ErrMsg = CASE @Language 
							when 'E' then 'Create customer fail. Please try again'
							ELSE [dbo].[f_Get_MsgNamebyMsgID](40004,@Language)
						END	
			, @ErrCode=116
	
	RETURN
END 

INSERT INTO Dep_CustSetting3rd ([custid],
		[bettype],
		[sporttype],
		[islive],
		[apositiontaking],
		[mpositiontaking],
		[spositiontaking],
		[playerdiscount],
		[discount],
		[adiscount],
		[sdiscount],
		[minbet],
		[maxbet]) 
	VALUES (
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
		@v186MaxBet)

IF @@ERROR <> 0
BEGIN
	--Error Occurs
	
	SELECT @ErrMsg = CASE @Language 
							when 'E' then 'Create customer fail. Please try again'
							ELSE [dbo].[f_Get_MsgNamebyMsgID](40004,@Language)
						END	
			, @ErrCode=116
	
	RETURN
END 

GO
GRANT EXECUTE ON [dbo].[Acc_Dep_CustomerInsMemberVirtualSports_Com] TO [bodbAdminNet] AS [dbo]
GO
GRANT EXECUTE ON [dbo].[Acc_Dep_CustomerInsMemberVirtualSports_Com] TO [bodbExtAccNet] AS [dbo]
GO
GRANT VIEW DEFINITION ON [dbo].[Acc_Dep_CustomerInsMemberVirtualSports_Com] TO [vnteam] AS [dbo]