/*<info serverAlias="DBCUST-CUSTDB" executers="svc_tig" viewers="" isFunction="0" isNested="1"></info>*/
ALTER PROCEDURE [dbo].[Dot_Dep_RollBackLicenseeDCS] 
		@ListCustID		VARCHAR(MAX),
		@SiteID INT = NULL	
AS
/*  
 Created: 20190425@Winnie  
 Task: Rollback Licensee
 DB: DBCUST/CustDB  
 Original:  
 Revisions:  	
	- 20190425@Winnie:  Onebook SiteBuilder RedmineID: #111321
	- 20200415@Eden: OnebookSiteBuilder - Add Virtual Games And Table Games [RedmineID:#132393] 
	- 20200903@Johnson: offer comm for DCS products [redmine:#140388]
	- 20220614@Eden: DBCUST - modify sp syntax to adapt with the SQL Server upgrade to 2019 [Redmine: #171831] 
	- 20220301@Eden: Deposit - Sportsbook - Revise customer settings [Redmine: #167898] 
	- 20240506@Tacy: SiteBuilder - Integrate Exchange [Redmine: #201239]
	- 20240710@Johnson: Apply In-house Replication for Deposit Customer Setting [redmine:#207025]

 Param's Explanation: 
 */
BEGIN
	CREATE TABLE #tblCustomer(CustID INT,isfinished BIT DEFAULT(0))	
	INSERT INTO #tblCustomer (CustID)
	SELECT ss.value
	FROM STRING_SPLIT(@ListCustID, ',') AS ss
	WHERE value <> ''

	DELETE d
	OUTPUT DELETED.custid, SYSDATETIME()
	INTO Dep_CustProductStatus_Del_InHouse(custid,RepUpdateTime)
	FROM Dep_CustProductStatus d WITH (ROWLOCK) 
		INNER JOIN #tblCustomer t ON d.custid=t.CustID

	DELETE d
	OUTPUT DELETED.custid, DELETED.SportType, DELETED.BetType, DELETED.IsLive, SYSDATETIME()
	INTO Dep_CustPTSetting_Agent_Del_InHouse(custid,SportType,BetType,IsLive,RepUpdateTime)
	FROM Dep_CustPTSetting_Agent d WITH (ROWLOCK) 
		INNER JOIN #tblCustomer t ON d.custid=t.CustID

	DELETE d
	OUTPUT DELETED.custid, DELETED.SportType, DELETED.BetType, SYSDATETIME()
	INTO Dep_CustBetSetting_Agent_Del_InHouse(custid,SportType,BetType,RepUpdateTime)	
	FROM Dep_CustBetSetting_Agent d WITH(ROWLOCK)
		INNER JOIN #tblCustomer t ON d.custid=t.CustID	

	DELETE d
	OUTPUT DELETED.AgentID, DELETED.SportType, DELETED.BetType, DELETED.IsLive, SYSDATETIME()
	INTO Dep_CustPTGroupSetting_Member_Del_InHouse(AgentID,SportType,BetType,IsLive,RepUpdateTime)		
	FROM Dep_CustPTGroupSetting_Member d WITH(ROWLOCK)
		INNER JOIN #tblCustomer t ON d.AgentID=t.CustID	

	DELETE d
	OUTPUT DELETED.custid, DELETED.SportType, DELETED.BetType, SYSDATETIME()
	INTO Dep_CustStakeLevel_Agent_Del_InHouse(custid,SportType,BetType,RepUpdateTime)		
	FROM Dep_CustStakeLevel_Agent d WITH(ROWLOCK)
		INNER JOIN #tblCustomer t ON d.custid=t.CustID	
	
	DELETE d
	OUTPUT DELETED.AgentID, DELETED.SportType, DELETED.BetType, SYSDATETIME()
	INTO Dep_CustDiscountGroupSetting_Member_Del_InHouse(AgentID,SportType,BetType,RepUpdateTime)		
	FROM Dep_CustDiscountGroupSetting_Member d WITH(ROWLOCK)
		INNER JOIN #tblCustomer t ON d.AgentID=t.CustID	
	
	DELETE d
	OUTPUT DELETED.custid, DELETED.SportType, DELETED.BetType, SYSDATETIME()
	INTO Dep_CustDiscountSetting_Member_Del_InHouse(custid,SportType,BetType,RepUpdateTime)			
	FROM Dep_CustDiscountSetting_Member d WITH(ROWLOCK)
		INNER JOIN #tblCustomer t ON d.custid=t.CustID	

	DELETE d
	OUTPUT DELETED.custid, DELETED.SportType, DELETED.BetType, SYSDATETIME()
	INTO Dep_CustBetSettingGame_Agent_Del_InHouse(custid,SportType,BetType,RepUpdateTime)			
	FROM Dep_CustBetSettingGame_Agent d WITH(ROWLOCK)
		INNER JOIN #tblCustomer t ON d.custid=t.CustID
	
	--Exchange: charge comm
	DELETE d
	FROM Dep_CustDiscountSetting_Agent d WITH(ROWLOCK)
		INNER JOIN #tblCustomer t ON d.custid=t.CustID

	--Exchange: PT
	UPDATE d
	SET d.isDeleted=1, d.RepUpdateTime=SYSDATETIME()
	FROM Dep_ChargeInfoSetting d WITH(ROWLOCK, UPDLOCK)
		INNER JOIN #tblCustomer t ON d.custid=t.CustID

	IF @SiteID IS NOT NULL
		DELETE d
		OUTPUT DELETED.StakeLevelID, SYSDATETIME()
		INTO Dep_StakeLevel_Del_InHouse(StakeLevelID,RepUpdateTime)
		FROM Dep_StakeLevel d WITH(ROWLOCK)
		WHERE d.SiteID = @SiteID
END