/*<info serverAlias="DBCUST-CUSTDB" executers="" viewers="" isFunction="0"></info>*/
ALTER PROCEDURE Acc_Dep_DynamicCustSetting_11 
	@CustID INT = -1
	,@ActionID SMALLINT = -1
	,@LstCustID VARCHAR(MAX) = ''
AS
/*
	Creator : 20230704@Eden
	Task : Delete custsetting for archive process
		use instead of Acc_CustomerInfo_Execrep_10, @ActionID = 7
	DB: DBCUST/CustDB
	Revisions:
		- 20230704@Eden: Enhance for Scale Out [#179092]
		- 20250403@Tacy: Enhance Archive service to adapt IHR [#222312]
	Parameter:
		@ActionID: 
				7: Delete Customer Setting
	
*/
BEGIN
	IF NOT (dbo.f_CheckServerName() = 1 -- run on DBCUST ONLY	
			AND dbo.f_CheckEnvironment() = 'Active' -- run on KBT	
		)
		RETURN

	DECLARE  @IsDelete_Dep_CustStakeLevel_Member		BIT = 1
			,@IsDelete_Dep_CustBetSetting_Member		BIT = 1
			,@IsDelete_Dep_CustDiscountSetting_Member	BIT = 1
			,@IsDelete_Dep_CustPTSetting_Member			BIT = 1
			,@BatchSize INT = 2000

	CREATE TABLE #LstCustID(CustID INT)

	IF @CustID <> -1 -- Update Specific custID
	BEGIN
		INSERT INTO #LstCustID(CustID) 
		SELECT @CustID
	END
	ELSE -- Update list of customer
	BEGIN
		INSERT INTO #LstCustID(CustID) 
		SELECT value 
		FROM string_split(@LstCustID,',')
	END

	IF @ActionID = 7
	BEGIN
		DELETE CustVirtualSetting 
			OUTPUT deleted.custid, deleted.seqNo, dbo.f_GetDateTime2()
			INTO CustVirtualSetting_Del_InHouse (custid, seqNo, RepUpdateTime)
		WHERE CustID IN (SELECT CustID FROM #LstCustID)

		DELETE Dep_CustProductStatus 
			OUTPUT deleted.custid, dbo.f_GetDateTime2()
			INTO Dep_CustProductStatus_Del_InHouse (custid, RepUpdateTime)
		WHERE CustID IN (SELECT CustID FROM #LstCustID)

		DELETE Dep_CustSetting_AGCasino 
			OUTPUT deleted.custid, dbo.f_GetDateTime2()
			INTO Dep_CustSetting_AGCasino_Del_InHouse (custid, RepUpdateTime)
		WHERE CustID IN (SELECT CustID FROM #LstCustID)

		DELETE Dep_CustSettingGame 
			OUTPUT deleted.custid, deleted.SportType, deleted.BetType, dbo.f_GetDateTime2()
			INTO Dep_CustSettingGame_Del_InHouse (custid, Sporttype, Bettype, RepUpdateTime)
		WHERE CustID IN (SELECT CustID FROM #LstCustID)
		
		DELETE Dep_CustSettingMode 
			OUTPUT deleted.custid, dbo.f_GetDateTime2()
			INTO Dep_CustSettingMode_Del_InHouse (custid, RepUpdateTime)
		WHERE CustID IN (SELECT CustID FROM #LstCustID)

		DELETE Dep_CustProductSetting 
			OUTPUT deleted.custid, deleted.ProductId, dbo.f_GetDateTime2()
			INTO Dep_CustProductSetting_Del_InHouse (custid, ProductId, RepUpdateTime)
		WHERE CustID IN (SELECT CustID FROM #LstCustID)

		DELETE Dep_CustBetSettingGame_Member 
			OUTPUT deleted.custid, deleted.SportType, deleted.BetType, dbo.f_GetDateTime2()
			INTO Dep_CustBetSettingGame_Member_Del_InHouse (custid, SportType, BetType, RepUpdateTime)
		WHERE CustID IN (SELECT CustID FROM #LstCustID)

		WHILE (1=1)
		BEGIN
			IF @IsDelete_Dep_CustBetSetting_Member = 1  
			BEGIN 
				DELETE TOP (@BatchSize) rmv 
					OUTPUT deleted.custid, deleted.SportType, deleted.BetType, dbo.f_GetDateTime2()
					INTO Dep_CustBetSetting_Member_Del_InHouse (custid, SportType, BetType, RepUpdateTime)
				FROM Dep_CustBetSetting_Member rmv
				WHERE CustID IN (SELECT CustID FROM #LstCustID)

				IF @@ROWCOUNT = 0  
					SELECT @IsDelete_Dep_CustBetSetting_Member = 0  
			END

			IF @IsDelete_Dep_CustDiscountSetting_Member = 1  
			BEGIN 
				DELETE TOP (@BatchSize) rmv 
					OUTPUT deleted.custid, deleted.SportType, deleted.BetType, dbo.f_GetDateTime2()
					INTO Dep_CustDiscountSetting_Member_Del_InHouse (custid, SportType, BetType, RepUpdateTime)
				FROM Dep_CustDiscountSetting_Member rmv
				WHERE CustID IN (SELECT CustID FROM #LstCustID)

				IF @@ROWCOUNT = 0  
					SELECT @IsDelete_Dep_CustDiscountSetting_Member = 0  
			END

			IF @IsDelete_Dep_CustPTSetting_Member = 1  
			BEGIN 
				DELETE TOP (@BatchSize) rmv 
				OUTPUT deleted.custid, deleted.SportType, deleted.BetType, deleted.IsLive, dbo.f_GetDateTime2()
				INTO Dep_CustPTSetting_Member_Del_InHouse (custid, SportType, BetType, IsLive, RepUpdateTime)
				FROM Dep_CustPTSetting_Member rmv
				WHERE CustID IN (SELECT CustID FROM #LstCustID)

				IF @@ROWCOUNT = 0  
					SELECT @IsDelete_Dep_CustPTSetting_Member = 0  
			END

			IF @IsDelete_Dep_CustStakeLevel_Member = 1  
			BEGIN 
				DELETE TOP (@BatchSize) rmv 
				OUTPUT deleted.custid, deleted.SportType, deleted.BetType, dbo.f_GetDateTime2()
				INTO Dep_CustStakeLevel_Member_Del_InHouse (custid, SportType, BetType, RepUpdateTime)
				FROM Dep_CustStakeLevel_Member rmv
				WHERE CustID IN (SELECT CustID FROM #LstCustID)

				IF @@ROWCOUNT = 0  
					SELECT @IsDelete_Dep_CustStakeLevel_Member = 0  
			END

			IF  (@IsDelete_Dep_CustBetSetting_Member = 1)  
			 OR (@IsDelete_Dep_CustPTSetting_Member = 1)  
			 OR (@IsDelete_Dep_CustStakeLevel_Member = 1)  
			 OR (@IsDelete_Dep_CustDiscountSetting_Member = 1)  
				WAITFOR DELAY '00:00:00.1'
			ELSE
				BREAK;
		END
	END

	DROP TABLE #LstCustID
END