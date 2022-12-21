/*<info serverAlias="DBCUST-CUSTDB" executers="" viewers="" isFunction="0"></info>*/
ALTER PROCEDURE [dbo].[Acc_Dep_Initial_DCS_CurrentStep_Upd]
	@ConfigID INT,
	@CurrentStep TINYINT,
	@UserId	INT = 0,
	@IP	VARCHAR(45) = '',
	@ErrCode INT = 0 OUTPUT,
	@ErrMsg	VARCHAR(200) = '' OUTPUT,
	@MaxCustID INT = 0
AS
/*
	Created: - 20220913@Eden
	Task : Update Dep_Initial_ProductConfig.CurrentStep
	DB: DBCUST/CUSTDB
	Original:

	Revisions:  
	- 20220913@Eden: Flexible Initializing Deposit Customer Setting [RedmineID: #169648]

	Parameter Definition

	Example: 
		EXEC [Acc_Dep_Initial_DCS_CurrentStep_Upd] 
			@ConfigID = 1,
			@CurrentStep = 2
	
	*/
BEGIN
	SET NOCOUNT ON
	DECLARE @ActionID INT  = 201062
	DECLARE @StartRun DATETIME, @EndRun DATETIME, @Duration INT
	SET @StartRun = GETDATE()
	
	UPDATE Dep_Initial_ProductConfig WITH(ROWLOCK,UPDLOCK)
	SET CurrentStep = @CurrentStep
	WHERE ConfigID = @ConfigID

	SET @EndRun = GETDATE()
	SET @Duration = DATEDIFF (MILLISECOND, @StartRun, @EndRun)

	DECLARE @LogData VARCHAR(MAX)
	SELECT  @LogData = '<R '
						+ 'ConfigID="'+ coalesce(cast(@ConfigID as varchar(50)),space(1)) + '" ' 
						+ 'CurrentStep="'+ coalesce(cast(@CurrentStep as varchar(50)),space(1)) + '" ' 
						+ 'MaxCustID="'+ coalesce(cast(@MaxCustID as varchar(50)),space(1)) + '" ' 
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


