/*<info serverAlias="DBCUST-CUSTDB" executers="wsv_nap,wsv_lap" viewers="" isFunction="0"></info>*/
ALTER PROCEDURE [dbo].[Acc_Dep_LicenseeOddsGroupUpd] 
	@CustID INT
	,@OddsGroup VARCHAR(10)
	,@IsActive BIT 
	,@ApplyExistingMember BIT = 0
	
	,@UserID INT = 0
	,@Language varchar(2) = 'E'
	,@IP varchar(15)=''
	,@ErrCode INT = 0 OUTPUT
    ,@ErrMsg NVARCHAR(4000) = '' OUTPUT
AS
/*
	Created: 20210709@Johnson	
	Task : NAP - Update odds group for licensee 
	DB: DBCUST/CustDB
	Original:

	Revisions:
		- 20210709@Johnson: initial sp [redmine:#157702]
		- 20211101@Johnson: exclude BA members when update odds group[redmine:#163957]
		- 20240715@Johnson: Apply In-house Replication for Customer Setting [redmine:#207025]
		- 20241129@Johnson: Apply In-house replication for Credit Setting [RedmineID: #212684]		
	Param's Explanation:
*/
BEGIN	
	SET NOCOUNT ON
	
	DECLARE @startRun DATETIME
	DECLARE @endRun DATETIME
	DECLARE @duration INT
	SET @startRun = GETDATE()
	
	IF @ApplyExistingMember = 1
	BEGIN
		EXEC Acc_Dep_CustomerSelCheckAllowedDownlines
			 @custid = @CustID
			,@Language = 'E'
			,@ErrMsg = @ErrMsg OUTPUT
			,@ErrCode= @ErrCode OUTPUT

		IF @ErrCode <> 0 
			RETURN 
	END	
	
	DECLARE @IsActive_Old BIT,
		@OddsGroup_Old VARCHAR(10)
		
	SELECT @IsActive_Old = IsActive,
		@OddsGroup_Old = Ugroup
	FROM Dep_DefaultOddGroup WITH(NOLOCK)
	WHERE AgentID = @custid
	
	IF (@IsActive = @IsActive_Old AND @OddsGroup = @OddsGroup_Old AND @ApplyExistingMember = 0)
	RETURN;
	
	MERGE Dep_DefaultOddGroup target
	USING (SELECT @custid custid) as source(custid) 
	ON (target.AgentID = source.custid)
	WHEN MATCHED THEN UPDATE SET target.ugroup = @oddsGroup,
							 target.IsActive = @IsActive,
							 target.UserID = @UserID,
							 target.UpdatedDate = GETDATE(),
							 target.RepUpdateTime = SYSDATETIME()
	WHEN NOT MATCHED THEN INSERT(AgentID,Ugroup,UpdatedDate,UserId,IsActive,RepUpdateTime)
							VALUES(source.custid,@oddsGroup,GETDATE(),@userid,@IsActive,SYSDATETIME());
	
	IF @ApplyExistingMember = 1
	BEGIN
		CREATE TABLE #temp(custid INT PRIMARY KEY, isfinished BIT DEFAULT(0))
				
		INSERT INTO #temp(custid)
		SELECT custid
		FROM customer WITH(NOLOCK)	
		WHERE recommend = @custid
			AND roleid = 1
			AND custid NOT IN (SELECT custid FROM [bodb_licensee].dbo.[LicenseeSpecialCust] WITH(NOLOCK))
			AND custid NOT IN (SELECT custid FROM dbo.[Dep_CustBAActive] WITH(NOLOCK))
			AND ugroup <> @oddsGroup
			
		BEGIN TRY
			DECLARE @ids VARCHAR(MAX), @rowcnt INT
			WHILE (1=1)
			BEGIN
				SELECT @ids = ''
		
				UPDATE TOP (2000) #temp
				SET @ids = @ids + CASE @ids WHEN '' THEN '' ELSE ',' END + CAST(custid AS VARCHAR(12))
					,isfinished = 1
				FROM #temp
				WHERE isfinished = 0

				SELECT @rowcnt = @@rowcount	
				
				EXEC Acc_CustomerInfo_Execrep_03 
					@CustList = @ids, 
					@oddsGroup = @oddsGroup,
					@mode = 'UpdateOddsGroup'

				IF @rowcnt < 2000 BREAK

				WAITFOR DELAY '00:00:00.28'
			END
		END TRY
		BEGIN CATCH
			SELECT @ErrMsg = ERROR_MESSAGE(), @ErrCode  = ERROR_NUMBER()   					
			RETURN
		END CATCH	
	END
	
	DECLARE @LogSPData VARCHAR(8000),
			@LogSPData_Old VARCHAR(8000)

	SELECT  @LogSPData ='<Acc_Dep_LicenseeOddsGroupUpd OddsGroup="'+ coalesce(cast(@OddsGroup AS VARCHAR(20)),space(1))+ '" ' +
						'IsActive="'+ coalesce(cast(@IsActive AS VARCHAR(20)),space(1))+ '" ' +
						'ApplyExistingMember="'+ coalesce(cast(@ApplyExistingMember AS VARCHAR(50)),space(1))+ '" ' +						
						'Language="'+ coalesce(cast(@Language as varchar(2)),space(1))+ '" ' +
						'IP="'+ coalesce(cast(@IP as varchar(15)),space(1))+ '" ' +
						'ErrCode="'+ coalesce(cast(@ErrCode as varchar(50)),space(1)) + '" ' +
						'ErrMsg="'+ coalesce(cast(@ErrMsg as varchar(4000)),space(1)) + '" />'
	
	SELECT  @LogSPData_Old ='<Acc_Dep_LicenseeOddsGroupUpd OddsGroup="'+ coalesce(cast(ISNULL(@OddsGroup_Old,'') AS VARCHAR(20)),space(1))+ '" ' +
						'IsActive="'+ coalesce(cast(ISNULL(@IsActive_old,0) AS VARCHAR(20)),space(1))+ '" ' +
						'ApplyExistingMember="'+ coalesce(cast(@ApplyExistingMember AS VARCHAR(50)),space(1))+ '" ' +						
						'Language="'+ coalesce(cast(@Language as varchar(2)),space(1))+ '" ' +
						'IP="'+ coalesce(cast(@IP as varchar(15)),space(1))+ '" ' +
						'ErrCode="'+ coalesce(cast(@ErrCode as varchar(50)),space(1)) + '" ' +
						'ErrMsg="'+ coalesce(cast(@ErrMsg as varchar(4000)),space(1)) + '" />'
	
	
	set @endRun = getdate()
	set @duration  = datediff (millisecond,@startRun,@endRun)

	EXEC dbo.Acc_WriteLog_UserLog_RunSP_Wrapper
			@UserId				= @UserId,
			@CustId				= @CustId,
			@ActionId			= 2217,
			@TrackingValue		= @LogSPData,
			@TrackingValue2		= @LogSPData_Old,
			@Duration			= @Duration
			
END		
		