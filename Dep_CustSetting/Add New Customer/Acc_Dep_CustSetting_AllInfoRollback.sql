/*<info serverAlias="DBCUST-CUSTDB" executers="" viewers="" isFunction="0"></info>*/
ALTER PROCEDURE [dbo].[Acc_Dep_CustSetting_AllInfoRollback] 
	@CustID INT,
	@RoleID	TINYINT
AS
/*
	Created: 20240710@Johnson
	Task : Insert All Settings Into DCS Structure
	DB:  DBCUST/CustDB
	Original:Acc_Dep_DynamicCustSetting_00
	
	Revisions:
		- 20240710@Johnson: Apply In-house Replication for Customer Setting [redmine:#207025]
		
*/
BEGIN
	SET NOCOUNT ON;
	
	IF @RoleID = 1
	BEGIN		
		DELETE FROM Dep_CustPTSetting_Member 
		OUTPUT DELETED.custid, DELETED.SportType, DELETED.BetType, DELETED.IsLive, SYSDATETIME()
		INTO Dep_CustPTSetting_Member_Del_InHouse(custid,SportType,BetType,IsLive,RepUpdateTime)
		WHERE CustID = @CustID
		
		DELETE FROM Dep_CustSettingMode 
		OUTPUT DELETED.custid, SYSDATETIME()
		INTO Dep_CustSettingMode_Del_InHouse(custid,RepUpdateTime)
		WHERE CustID = @CustID
		
		DELETE FROM Dep_CustStakeLevel_member 
		OUTPUT DELETED.custid, DELETED.SportType, DELETED.BetType, SYSDATETIME()
		INTO Dep_CustStakeLevel_member_Del_InHouse(custid,SportType,BetType,RepUpdateTime)		
		WHERE CustID = @CustID
		
		DELETE FROM Dep_CustBetSetting_Member 
		OUTPUT DELETED.custid, DELETED.SportType, DELETED.BetType, SYSDATETIME()
		INTO Dep_CustBetSetting_Member_Del_InHouse(custid,SportType,BetType,RepUpdateTime)		
		WHERE CustID = @CustID
		
		
		DELETE FROM Dep_CustBetSettingGame_Member 
		OUTPUT DELETED.custid, DELETED.SportType, DELETED.BetType, SYSDATETIME()
		INTO Dep_CustBetSettingGame_Member_Del_InHouse(custid,SportType,BetType,RepUpdateTime)		
		WHERE CustID = @CustID
		
		DELETE FROM Dep_CustDiscountSetting_Member 
		OUTPUT DELETED.custid, DELETED.SportType, DELETED.BetType, SYSDATETIME()
		INTO Dep_CustDiscountSetting_Member_Del_InHouse(custid,SportType,BetType,RepUpdateTime)		
		WHERE CustID = @CustID
		
	END
	ELSE --SMA
	BEGIN
		DELETE FROM Dep_CustPTSetting_Agent 
		OUTPUT DELETED.custid, DELETED.SportType, DELETED.BetType, DELETED.IsLive, SYSDATETIME()
		INTO Dep_CustPTSetting_Agent_Del_InHouse(custid,SportType,BetType,IsLive,RepUpdateTime)
		WHERE CustID = @CustID
		
		DELETE FROM Dep_CustStakeLevel_Agent 
		OUTPUT DELETED.custid, DELETED.SportType, DELETED.BetType, SYSDATETIME()
		INTO Dep_CustStakeLevel_Agent_Del_InHouse(custid,SportType,BetType,RepUpdateTime)		
		WHERE CustID = @CustID
		
		DELETE FROM Dep_CustBetSetting_Agent
		OUTPUT DELETED.custid, DELETED.SportType, DELETED.BetType, SYSDATETIME()
		INTO Dep_CustBetSetting_Agent_Del_InHouse(custid,SportType,BetType,RepUpdateTime)		
		WHERE CustID = @CustID
		
		DELETE FROM Dep_CustBetSettingGame_Agent
		OUTPUT DELETED.custid, DELETED.SportType, DELETED.BetType, SYSDATETIME()
		INTO Dep_CustBetSettingGame_Agent_Del_InHouse(custid,SportType,BetType,RepUpdateTime)		
		WHERE CustID = @CustID
		
		DELETE FROM Dep_CustDiscountSetting_Agent
		OUTPUT DELETED.custid, DELETED.SportType, DELETED.BetType, SYSDATETIME()
		INTO Dep_CustDiscountSetting_Agent_Del_InHouse(custid,SportType,BetType,RepUpdateTime)		
		WHERE CustID = @CustID
		
		IF @roleid = 2
		BEGIN
			DELETE FROM Dep_CustDiscountGroupSetting_Member
			OUTPUT DELETED.AgentID, DELETED.SportType, DELETED.BetType, SYSDATETIME()
			INTO Dep_CustDiscountGroupSetting_Member_Del_InHouse(AgentID,SportType,BetType,RepUpdateTime)		
			WHERE AgentID = @CustID
			
			DELETE FROM Dep_CustPTGroupSetting_Member
			OUTPUT DELETED.AgentID, DELETED.SportType, DELETED.BetType, DELETED.IsLive, SYSDATETIME()
			INTO Dep_CustPTGroupSetting_Member_Del_InHouse(AgentID,SportType,BetType,IsLive,RepUpdateTime)		
			WHERE AgentID = @CustID
			
			DELETE FROM Dep_CustBetSettingGameGroup_Member
			OUTPUT DELETED.AgentID, DELETED.SportType, DELETED.BetType, SYSDATETIME()
			INTO Dep_CustBetSettingGameGroup_Member_Del_InHouse(AgentID,SportType,BetType,RepUpdateTime)		
			WHERE AgentID = @CustID
		END
		
	END
	
	DELETE FROM Dep_CustProductStatus 
	OUTPUT DELETED.custid, SYSDATETIME()
	INTO Dep_CustProductStatus_Del_InHouse(custid,RepUpdateTime)		
	WHERE CustID = @CustID
END	
GO
	
