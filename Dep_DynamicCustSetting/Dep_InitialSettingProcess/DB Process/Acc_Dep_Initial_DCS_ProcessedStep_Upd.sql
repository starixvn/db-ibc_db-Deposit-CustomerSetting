/*<info serverAlias="DBCUST-CUSTDB" executers="" viewers="" isFunction="0"></info>*/
ALTER PROCEDURE [dbo].[Acc_Dep_Initial_DCS_ProcessedStep_Upd]
	@ConfigID INT,
	@CurrentStep TINYINT,
	@UserId	INT = 0,
	@IP	VARCHAR(45) = '',
	@ErrCode INT = 0 OUTPUT,
	@ErrMsg	VARCHAR(200) = '' OUTPUT
AS
/*
	Created: 20220913@Eden
	Task : Update Dep_Initial_ProductConfig.ProcessedStep
	DB: DBCUST/CUSTDB
	Original:

	Revisions:  
	- 20220913@Eden: Flexible Initializing Deposit Customer Setting [RedmineID: #169648]

	Parameter Definition

	Example: 
		EXEC [Acc_Dep_Initial_DCS_ProcessedStep_Upd] 
			@ConfigID = 1,
			@CurrentStep = 2
	
	*/
BEGIN
	SET NOCOUNT ON
	DECLARE @ActionID INT  = 201063
	DECLARE @StartRun DATETIME, @EndRun DATETIME, @Duration INT
	SET @StartRun = GETDATE()
	
	UPDATE Dep_Initial_ProductConfig WITH(ROWLOCK,UPDLOCK)
	SET ProcessedStep =  CASE WHEN ProcessedStep IS NULL THEN CONVERT(VARCHAR,@CurrentStep) ELSE ProcessedStep  + ',' + CONVERT(VARCHAR,@CurrentStep) END
	WHERE ConfigID = @ConfigID

	SET @EndRun = GETDATE()
	SET @Duration = DATEDIFF (MILLISECOND, @StartRun, @EndRun)

	DECLARE @LogData VARCHAR(MAX)
	SELECT  @LogData = '<R '
						+ 'ConfigID="'+ coalesce(cast(@ConfigID as varchar(50)),space(1)) + '" ' 
						+ 'ProcessedStep="'+ coalesce(cast(@CurrentStep as varchar(50)),space(1)) + '" ' 
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


