/*<info serverAlias="DBCUST-CUSTDB" executers="bodbAdminNet" viewers="" isFunction="0"></info>*/
ALTER PROCEDURE [dbo].[Acc_Dep_CustomerInsLicenseeSubsidiary]
	@custid int =0 OUTPUT,
	@username varchar(30),
	@userpwd varchar(40) = '123qwe',
	@ExistedUsername nvarchar(50),
	@ExistedCustID INT = 0 OUTPUT,
	@creator int=0,
	@IP varchar(15)='',
	@Language varchar(2)= 'E',
	@ErrCode int = 0 OUTPUT,
	@ErrMsg nvarchar(4000) = '' OUTPUT,
	@InsBalCustList varchar(MAX) = '' OUTPUT,
	@InsBalExceptCustList varchar(MAX) = '' OUTPUT
AS
/*
	Created: 20190917@Winnie
	Task : create LicenseeSubsidiary
	DB: DBTRANS.bodb02
	Original:

	Revisions:
		- 20190917@Winnie: create LicenseeSubsidiary RedmineID:#120141
		- 20191009@Winnie: NAP - Create Licensee Subsidiary - Keno status of Copied account is enabled while source's status is disabled RedmineID:#121732
		- 20200702@Johnson: add soccer parlay [redmine:#135261]
		- 20201119@Johnson: output @ExistedCustID [redmine: #140966]
		- 20220701@Johnson: HF Keno PT value does not support three decimal digits number[redmine: #174808]
		- 20220301@Eden: Deposit - Sportsbook - Revise customer settings [Redmine: #167898]
		- 20220722@Eden: LAP - Scale Out DBTrans  [redmine: #158293/#175297]
		- 20221207@Tacy: Remove columns and code used by Colossus Bets, GD product [RedmineID: #188096]

	Param's Explanation:
	- @InsBalCustList  --> cutsid list will call 2 sp insert balance on DBTRANS SiteDB: (ex: 'CustID1,CustID2')
                    EXEC bodb02.dbo.Dot_BalanceInsCredit @CustID = @CustID 
                    EXEC bodb02.dbo.Dot_BalanceInsDebit @CustID = @CustID
    - @InsBalExceptCustList -->  cutsid and username  list will call sp insert exception balance on SiteDB : (ex: 'CustID1;username1,CustID2;username2,...' )
                    EXEC bodb02.dbo.Task_Cust_CheckBalance_Exception_Ins @custid = @custid, @username = @username

*/
BEGIN
	SET NOCOUNT ON
	
	DECLARE @mrecommend INT
			
	SELECT @ExistedCustID=CustID,@mrecommend=mrecommend FROM custInfo WITH (NOLOCK) WHERE Username=@ExistedUsername AND Enabled=1
	
	DECLARE @startRun datetime
			,@endRun datetime
			,@duration int
			
	set @startRun = getdate()

	IF @ExistedCustID IS NULL
	BEGIN
		SELECT @ErrCode=101
		SELECT @ErrMsg='Username to copy does not exist.'
		RETURN
	END

	EXEC Acc_Dep_CustomerInsMember_MAg 
		@Custid=@custid OUTPUT,@creator=@creator,@Username=@username,@userpwd=@userpwd,@mrecommend=@mrecommend
		,@IP=@IP,@ErrCode=@ErrCode OUTPUT,@ErrMsg=@ErrMsg OUTPUT	
		,@InsBalCustList = @InsBalCustList OUTPUT
		,@InsBalExceptCustList = @InsBalExceptCustList OUTPUT

		
	IF @ErrCode<>0
		RETURN

	INSERT INTO Dep_CustBetSetting_Agent([CustID],[SportType],[BetType],[MinBet],[MaxBet],[MaxPerMatch])
	SELECT @custid,[SportType],[BetType],[MinBet],[MaxBet],[MaxPerMatch]
	FROM Dep_CustBetSetting_Agent WITH(NOLOCK) WHERE CustID=@Existedcustid

	IF @@ERROR<>0
	BEGIN
		DELETE FROM Dep_CustBetSetting_Agent WHERE CustID=@custid
		SELECT @ErrCode=100
		SELECT @ErrMsg='Create Licensee Subsidiary failled'
	END

	INSERT INTO [Dep_CustDiscountSetting_Agent]([CustID],[SportType],[BetType],[Discount])
	SELECT @custid,[SportType],[BetType],[Discount]
	FROM [Dep_CustDiscountSetting_Agent] WITH(NOLOCK) WHERE CustID=@Existedcustid

	IF @@ERROR<>0
	BEGIN
		DELETE FROM [Dep_CustDiscountSetting_Agent] WHERE CustID=@custid
		DELETE FROM Dep_CustBetSetting_Agent WHERE CustID=@custid
		SELECT @ErrCode=100
		SELECT @ErrMsg='Create Licensee Subsidiary failled'
	END

	INSERT INTO [dbo].[Dep_CustDiscountGroupSetting_Member]
		   ([AgentID]
		   ,[SportType]
		   ,[BetType]
		   ,[PlayerDiscount]
		   ,[AgentDiscount]
		   ,[MasterDiscount]
		   ,[SuperDiscount])
	SELECT @custid
		   ,[SportType]
		   ,[BetType]
		   ,[PlayerDiscount]
		   ,[AgentDiscount]
		   ,[MasterDiscount]
		   ,[SuperDiscount]
	FROM [Dep_CustDiscountGroupSetting_Member] WITH(NOLOCK) WHERE AgentID=@Existedcustid

	IF @@ERROR<>0
	BEGIN
		DELETE FROM [Dep_CustDiscountSetting_Agent] WHERE CustID=@custid
		DELETE FROM Dep_CustBetSetting_Agent WHERE CustID=@custid
		DELETE FROM [Dep_CustDiscountGroupSetting_Member] WHERE AgentID=@custid
		SELECT @ErrCode=100
		SELECT @ErrMsg='Create Licensee Subsidiary failled'
	END

	INSERT INTO [dbo].[Dep_CustPTSetting_Agent]
		   ([CustID]
		   ,[SportType]
		   ,[BetType]
		   ,[IsLive]
		   ,[SuperPT]
		   ,[MasterPT]
		   ,[AgentPT])
	SELECT @custid
		   ,[SportType]
		   ,[BetType]
		   ,[IsLive]
		   ,[SuperPT]
		   ,[MasterPT]
		   ,[AgentPT]
	FROM [Dep_CustPTSetting_Agent]  WHERE CustID=@Existedcustid

	IF @@ERROR<>0
	BEGIN
		DELETE FROM [Dep_CustDiscountSetting_Agent] WHERE CustID=@custid
		DELETE FROM Dep_CustBetSetting_Agent WHERE CustID=@custid
		DELETE FROM [Dep_CustDiscountGroupSetting_Member] WHERE AgentID=@custid
		DELETE FROM [Dep_CustPTSetting_Agent] WHERE CustID=@custid
		SELECT @ErrCode=100
		SELECT @ErrMsg='Create Licensee Subsidiary failled'
	END

	INSERT INTO [dbo].[Dep_CustPTGroupSetting_Member]
		   ([AgentID]
		   ,[SportType]
		   ,[BetType]
		   ,[IsLive]
		   ,[SuperPT]
		   ,[MasterPT]
		   ,[AgentPT])
	SELECT @custid
		   ,[SportType]
		   ,[BetType]
		   ,[IsLive]
		   ,[SuperPT]
		   ,[MasterPT]
		   ,[AgentPT]
	FROM [Dep_CustPTGroupSetting_Member] WITH(NOLOCK) WHERE AgentID=@Existedcustid

	IF @@ERROR<>0
	BEGIN
		DELETE FROM [Dep_CustDiscountSetting_Agent] WHERE CustID=@custid
		DELETE FROM Dep_CustBetSetting_Agent WHERE CustID=@custid
		DELETE FROM [Dep_CustDiscountGroupSetting_Member] WHERE AgentID=@custid
		DELETE FROM [Dep_CustPTGroupSetting_Member] WHERE AgentID=@custid
		DELETE FROM [Dep_CustPTSetting_Agent] WHERE CustID=@custid
		SELECT @ErrCode=100
		SELECT @ErrMsg='Create Licensee Subsidiary failled'
	END

	INSERT INTO [dbo].[Dep_CustStakeLevel_Agent]
		   ([CustID]
		   ,[SportType]
		   ,[BetType]
		   ,[StakeLevelList])
	SELECT @custid,[SportType],[BetType],[StakeLevelList] FROM [Dep_CustStakeLevel_Agent] WITH(NOLOCK) WHERE CustID=@Existedcustid

	IF @@ERROR<>0
	BEGIN
		DELETE FROM [Dep_CustDiscountSetting_Agent] WHERE CustID=@custid
		DELETE FROM Dep_CustBetSetting_Agent WHERE CustID=@custid
		DELETE FROM [Dep_CustDiscountGroupSetting_Member] WHERE AgentID=@custid
		DELETE FROM [Dep_CustPTGroupSetting_Member] WHERE AgentID=@custid
		DELETE FROM [Dep_CustPTSetting_Agent] WHERE CustID=@custid
		DELETE FROM [Dep_CustStakeLevel_Agent] WHERE CustID=@custid
		SELECT @ErrCode=100
		SELECT @ErrMsg='Create Licensee Subsidiary failled'
	END

	INSERT INTO [dbo].[Dep_CustProductStatus]
		   ([CustID]
		   ,[bitmapIsHidden]
		   ,[bitmapIsDisabled])
	SELECT 
			@custid
		   ,[bitmapIsHidden]
		   ,[bitmapIsDisabled]
	FROM [Dep_CustProductStatus] WITH(NOLOCK) WHERE Custid=@ExistedCustID

	IF @@ERROR<>0
	BEGIN
		DELETE FROM [Dep_CustDiscountSetting_Agent] WHERE CustID=@custid
		DELETE FROM Dep_CustBetSetting_Agent WHERE CustID=@custid
		DELETE FROM [Dep_CustDiscountGroupSetting_Member] WHERE AgentID=@custid
		DELETE FROM [Dep_CustPTGroupSetting_Member] WHERE AgentID=@custid
		DELETE FROM [Dep_CustPTSetting_Agent] WHERE CustID=@custid
		DELETE FROM [Dep_CustStakeLevel_Agent] WHERE CustID=@custid
		DELETE FROM [Dep_CustProductStatus] WHERE CustID=@custid
		SELECT @ErrCode=100
		SELECT @ErrMsg='Create Licensee Subsidiary failled'
	END

	------
	INSERT INTO Dep_CustBetSettingGame_Agent([CustID],[SportType],[BetType],[MinBet],[MaxBet],[MaxPerMatch],MaxPerNumber,MaxPayoutPerMatch)
	SELECT @custid,[SportType],[BetType],[MinBet],[MaxBet],[MaxPerMatch],MaxPerNumber,MaxPayoutPerMatch
	FROM Dep_CustBetSettingGame_Agent WITH(NOLOCK) WHERE CustID=@Existedcustid

	IF @@ERROR<>0
	BEGIN
		DELETE FROM Dep_CustBetSettingGame_Agent WHERE CustID=@custid
		DELETE FROM [Dep_CustDiscountSetting_Agent] WHERE CustID=@custid
		DELETE FROM Dep_CustBetSetting_Agent WHERE CustID=@custid
		DELETE FROM [Dep_CustDiscountGroupSetting_Member] WHERE AgentID=@custid
		DELETE FROM [Dep_CustPTGroupSetting_Member] WHERE AgentID=@custid
		DELETE FROM [Dep_CustPTSetting_Agent] WHERE CustID=@custid
		DELETE FROM [Dep_CustStakeLevel_Agent] WHERE CustID=@custid
		DELETE FROM [Dep_CustProductStatus] WHERE CustID=@custid
		SELECT @ErrCode=100
		SELECT @ErrMsg='Create Licensee Subsidiary failled'
	END

	INSERT INTO Dep_CustBetSettingGameGroup_Member(AgentID,[SportType],[BetType],[MinBet],[MaxBet],[MaxPerMatch],MaxPerNumber,MaxPayoutPerMatch)
	SELECT @custid,[SportType],[BetType],[MinBet],[MaxBet],[MaxPerMatch],MaxPerNumber,MaxPayoutPerMatch
	FROM Dep_CustBetSettingGameGroup_Member WITH(NOLOCK) WHERE AgentID=@Existedcustid

	IF @@ERROR<>0
	BEGIN
		DELETE FROM Dep_CustBetSettingGameGroup_Member WHERE AgentID=@custid
		DELETE FROM Dep_CustBetSettingGame_Agent WHERE CustID=@custid
		DELETE FROM [Dep_CustDiscountSetting_Agent] WHERE CustID=@custid
		DELETE FROM Dep_CustBetSetting_Agent WHERE CustID=@custid
		DELETE FROM [Dep_CustDiscountGroupSetting_Member] WHERE AgentID=@custid
		DELETE FROM [Dep_CustPTGroupSetting_Member] WHERE AgentID=@custid
		DELETE FROM [Dep_CustPTSetting_Agent] WHERE CustID=@custid
		DELETE FROM [Dep_CustStakeLevel_Agent] WHERE CustID=@custid
		DELETE FROM [Dep_CustProductStatus] WHERE CustID=@custid
		SELECT @ErrCode=100
		SELECT @ErrMsg='Create Licensee Subsidiary failled'
	END

	Declare @LogSPData varchar(MAX)
	--Log status
	Select @LogSPData = '<Acc_Dep_CustomerInsLicenseeSubsidiary custid="'+ coalesce(cast(@custid as varchar(50)),space(1)) + '" ' +
	'Username="'+ coalesce(@Username,space(1)) + '" ' +	
	'mrecommend="'+ coalesce(cast(@mrecommend as varchar(50)),space(1)) +'" '  + 
	'Creator="'+ coalesce(cast(@Creator as varchar(50)),space(1)) + '" ' +	
	'ExistedCustID="'+ coalesce(cast(@ExistedCustID as varchar(50)),space(1)) + '" ' +
	'ExistedUsername="'+ coalesce(@ExistedUsername,space(1)) + '" ' +		
	'IP="'+ coalesce(@IP,space(1)) + '" ' +	
	'Language="'+ coalesce(@Language,space(1)) + '" ' +	
	'ErrCode="'+ coalesce(cast(@ErrCode as varchar(50)),space(1)) + '" ' +	
	'ErrMsg="'+ coalesce(@ErrMsg,space(1))+
	'" />'

	set @endRun = getdate()
	set @duration  = datediff (millisecond,@startRun,@endRun)

	EXEC DBLOG.bodb_CustomerLog.dbo.WriteLog_UserLog_RunSP 
		@UserID = @Creator,
		@CustID = @CustID,
		@ActionID = 2215,
		@TrackingValue = @LogSPData,
		@duration = @duration

END

GO
