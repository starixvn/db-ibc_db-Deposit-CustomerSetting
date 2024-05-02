/*<info serverAlias="DBCUST-CUSTDB" executers="wsv_nap" viewers="" isFunction="0"></info>*/
ALTER PROCEDURE [dbo].[Acc_Dep_Initial_DCS_SettingConfig_Del]
	@ConfigID INT,
	@UserId	INT = 0,
	@IP	VARCHAR(45) = '',
	@ErrCode INT = 0 OUTPUT,
	@ErrMsg	VARCHAR(200) = '' OUTPUT
AS
/*
	Created: 20220913@Eden
	Task : Delete Initial Setting config
	DB: DBCUST/CUSTDB
	Original:

	Revisions:  
	- 20220913@Eden: Flexible Initializing Deposit Customer Setting [RedmineID: #169648]

	Parameter Definition

	Example: 
		DECLARE @ErrCode INT = 0 ,@ErrMsg	VARCHAR(200) = ''
		EXEC [Acc_Dep_Initial_DCS_SettingConfig_Del] 
			@ConfigID = 5,
			@UserId = 8,
			@ErrCode =  @ErrCode OUT,
			@ErrMsg = @ErrMsg OUT
		SELECT @ErrCode, @ErrMsg

	*/
BEGIN
	SET NOCOUNT ON
	DECLARE @Status TINYINT
	DECLARE @ActionID INT  = 201065
	DECLARE @StartRun DATETIME, @EndRun DATETIME, @Duration INT
	SET @StartRun = GETDATE()

	IF NOT EXISTS( SELECT 1 FROM Dep_Initial_ProductConfig WITH(NOLOCK) WHERE ConfigID = @ConfigID)
	BEGIN
		SELECT @ErrCode = 301
			,@ErrMsg = 'This row does not exist, please refresh again.'

		RETURN
	END

	IF EXISTS( SELECT 1 FROM Dep_Initial_ProductConfig WITH(NOLOCK) WHERE ConfigID = @ConfigID AND Status <> 0)
	BEGIN
		SELECT @ErrCode = 302
			,@ErrMsg = 'The status of this row is no longer "Planned". You cannot edit or delete this row.'

		RETURN
	END

	DELETE 
	FROM Dep_Initial_BetSetting WITH(ROWLOCK,UPDLOCK)
	WHERE ConfigID = @ConfigID

	DELETE 
	FROM Dep_Initial_ProductConfig_Detail WITH(ROWLOCK,UPDLOCK)
	WHERE ConfigID = @ConfigID 

	DELETE 
	FROM Dep_Initial_ProductConfig WITH(ROWLOCK,UPDLOCK)
	WHERE ConfigID = @ConfigID 

	SET @EndRun = GETDATE()
	SET @Duration = DATEDIFF (MILLISECOND, @StartRun, @EndRun)

	DECLARE @LogData VARCHAR(MAX)
	SELECT  @LogData = '<R '
						+ 'ConfigID="'+ coalesce(cast(@ConfigID as varchar(50)),space(1)) + '" ' 
						+ 'IP="' + COALESCE(@IP, SPACE(1)) + '" '
						+ ' />'

	--Write log:
	EXEC dbo.Acc_WriteLog_UserLog_RunSP_Wrapper
				@UserId				= @UserId,
				@CustId				= 0,
				@ActionId			= @ActionID,
				@TrackingValue		= @LogData,
				@Duration			= @Duration
END
GO


