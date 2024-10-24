/*<info serverAlias="DBCust-CustDB" executers="wsv_nap,asv_cust,wsv_lap" viewers="" isFunction="0" isNested="1"></info>*/
ALTER PROCEDURE [dbo].Acc_Dep_CustomerInsSetting_Rollback 
	  @CustID INT,
	  @RoleID TINYINT 
AS
/*
	Created: 20240705@Eden 
	Task : Rollback Deposit Customer Setting for New accounts when failed 
	DB: DBCUST/CustDB
	Original:

	Revisions:
		- 20240705@Eden  : Scale out DBCUST - Licensee Customer in GlobCustDB [redmine: #207474]  
		
	Param's Explanation:

	Examples:
		EXEC Acc_Dep_CustomerInsSetting_Rollback @CustID = xxx ,@RoleID = 2
	*/
BEGIN
	SET NOCOUNT ON
	
	DELETE FROM BetLimitControlCustSetting	WITH (ROWLOCK) WHERE CustID = @CustID
	DELETE FROM DepositCustomer				WITH (ROWLOCK) WHERE CustID = @CustID

	DELETE c
	OUTPUT deleted.custid, deleted.seqNo, [dbo].[f_GetDateTime2]() 
	INTO CustVirtualSetting_Del_Inhouse(custid,seqNo,RepUpdateTime)
	FROM CustVirtualSetting c WITH(ROWLOCK) 
	WHERE CustID = @CustID

	DELETE c
	OUTPUT deleted.custid, deleted.Type, [dbo].[f_GetDateTime2]() 
	INTO VRCustLockStatus_Del_Inhouse(custid,Type,RepUpdateTime)
	FROM VRCustLockStatus c WITH(ROWLOCK) 
	WHERE CustID = @CustID

	DELETE c
	OUTPUT deleted.SportType, deleted.CustID, [dbo].[f_GetDateTime2]() 
	INTO VRCustAutoAdjustment_Del_Inhouse(SportType,CustID,RepUpdateTime)
	FROM VRCustAutoAdjustment c WITH(ROWLOCK) 
	WHERE CustID = @CustID AND Sporttype IN(100,99)
	
	DELETE FROM Dep_CustProductStatus WITH (ROWLOCK)
	OUTPUT DELETED.custid, SYSDATETIME()
	INTO Dep_CustProductStatus_Del_InHouse(custid,RepUpdateTime)		
	WHERE CustID = @CustID

	IF @RoleID IN (2,3,4)
	BEGIN			
		DELETE FROM Dep_CustPTSetting_Agent WITH (ROWLOCK) 
		OUTPUT DELETED.custid, DELETED.SportType, DELETED.BetType, DELETED.IsLive, SYSDATETIME()
		INTO Dep_CustPTSetting_Agent_Del_InHouse(custid,SportType,BetType,IsLive,RepUpdateTime)
		WHERE CustID = @CustID
				
		DELETE FROM Dep_CustBetSetting_Agent WITH (ROWLOCK)
		OUTPUT DELETED.custid, DELETED.SportType, DELETED.BetType, SYSDATETIME()
		INTO Dep_CustBetSetting_Agent_Del_InHouse(custid,SportType,BetType,RepUpdateTime)		
		WHERE CustID = @CustID
		
		DELETE FROM Dep_CustBetSettingGame_Agent WITH (ROWLOCK)
		OUTPUT DELETED.custid, DELETED.SportType, DELETED.BetType, SYSDATETIME()
		INTO Dep_CustBetSettingGame_Agent_Del_InHouse(custid,SportType,BetType,RepUpdateTime)		
		WHERE CustID = @CustID
		
		DELETE FROM Dep_CustDiscountSetting_Agent WITH (ROWLOCK)
		OUTPUT DELETED.custid, DELETED.SportType, DELETED.BetType, SYSDATETIME()
		INTO Dep_CustDiscountSetting_Agent_Del_InHouse(custid,SportType,BetType,RepUpdateTime)		
		WHERE CustID = @CustID
		
		DELETE FROM Dep_CustStakeLevel_Agent WITH (ROWLOCK)
		OUTPUT DELETED.custid, DELETED.SportType, DELETED.BetType, SYSDATETIME()
		INTO Dep_CustStakeLevel_Agent_Del_InHouse(custid,SportType,BetType,RepUpdateTime)		
		WHERE CustID = @CustID

		IF @RoleID = 4
		BEGIN
			DELETE Dep_LicenseeProductSetting WITH(ROWLOCK) 
			OUTPUT DELETED.custid, DELETED.ProductSettingID,SYSDATETIME()
			INTO Dep_LicenseeProductSetting_Del_InHouse(custid,ProductSettingID,RepUpdateTime)
			WHERE custid = @custid
		END
		
		IF @roleid = 2
		BEGIN
			DELETE FROM Dep_CustDiscountGroupSetting_Member WITH (ROWLOCK)
			OUTPUT DELETED.AgentID, DELETED.SportType, DELETED.BetType, SYSDATETIME()
			INTO Dep_CustDiscountGroupSetting_Member_Del_InHouse(AgentID,SportType,BetType,RepUpdateTime)		
			WHERE AgentID = @CustID
			
			DELETE FROM Dep_CustPTGroupSetting_Member WITH (ROWLOCK)
			OUTPUT DELETED.AgentID, DELETED.SportType, DELETED.BetType, DELETED.IsLive, SYSDATETIME()
			INTO Dep_CustPTGroupSetting_Member_Del_InHouse(AgentID,SportType,BetType,IsLive,RepUpdateTime)		
			WHERE AgentID = @CustID
			
			DELETE FROM Dep_CustBetSettingGameGroup_Member WITH (ROWLOCK)
			OUTPUT DELETED.AgentID, DELETED.SportType, DELETED.BetType, SYSDATETIME()
			INTO Dep_CustBetSettingGameGroup_Member_Del_InHouse(AgentID,SportType,BetType,RepUpdateTime)		
			WHERE AgentID = @CustID
		END
	END
	ELSE IF @RoleID = 1
	BEGIN
		DELETE FROM Dep_CustPTSetting_Member WITH (ROWLOCK)
		OUTPUT DELETED.custid, DELETED.SportType, DELETED.BetType, DELETED.IsLive, SYSDATETIME()
		INTO Dep_CustPTSetting_Member_Del_InHouse(custid,SportType,BetType,IsLive,RepUpdateTime)
		WHERE CustID = @CustID
		
		DELETE FROM Dep_CustSettingMode WITH (ROWLOCK)
		OUTPUT DELETED.custid, SYSDATETIME()
		INTO Dep_CustSettingMode_Del_InHouse(custid,RepUpdateTime)
		WHERE CustID = @CustID
		
		DELETE FROM Dep_CustStakeLevel_member WITH (ROWLOCK) 
		OUTPUT DELETED.custid, DELETED.SportType, DELETED.BetType, SYSDATETIME()
		INTO Dep_CustStakeLevel_member_Del_InHouse(custid,SportType,BetType,RepUpdateTime)		
		WHERE CustID = @CustID
		
		DELETE FROM Dep_CustBetSetting_Member WITH (ROWLOCK)
		OUTPUT DELETED.custid, DELETED.SportType, DELETED.BetType, SYSDATETIME()
		INTO Dep_CustBetSetting_Member_Del_InHouse(custid,SportType,BetType,RepUpdateTime)		
		WHERE CustID = @CustID		
		
		DELETE FROM Dep_CustBetSettingGame_Member WITH (ROWLOCK)
		OUTPUT DELETED.custid, DELETED.SportType, DELETED.BetType, SYSDATETIME()
		INTO Dep_CustBetSettingGame_Member_Del_InHouse(custid,SportType,BetType,RepUpdateTime)		
		WHERE CustID = @CustID
		
		DELETE FROM Dep_CustDiscountSetting_Member WITH (ROWLOCK)
		OUTPUT DELETED.custid, DELETED.SportType, DELETED.BetType, SYSDATETIME()
		INTO Dep_CustDiscountSetting_Member_Del_InHouse(custid,SportType,BetType,RepUpdateTime)		
		WHERE CustID = @CustID
		
	END
END