/*<info serverAlias="DBCUST-CUSTDB" executers="bodbAdminNet,bodbExtAccNet,bodbDownlineNet,bodbLicenseeNet" viewers="vnteam" isFunction="0"></info>*/
USE CustDB
GO
ALTER PROCEDURE [dbo].[Acc_Dep_CustSetting_GlobalStakeLevelUpdate] 
	@StakeLevel VARCHAR(MAX)	= ''	
	,@CustID		INT
	,@UserID					INT  
	,@IP						VARCHAR(15)		= ''	
	,@ErrCode				INT				= 0			OUTPUT 
	,@ErrMsg					NVARCHAR(4000)	= ''		OUTPUT  
AS
/*
	Created: 20171107@Winne
	Task: select GlobalStakeLevel of DCS product
	DB: DBCUST/CustDB
	Original:
	Revisions:
		- 20171107@Winnie: select GlobalStakeLevel of DCS product RedmineID:#85133
	Param's Explanation:
		- @StakeLevel = '<ROOT>
									<StakeLevel StakeLevelID="0" GameTypeID="2401" MinLabel="10" MaxLabel="100" MinStake="10" MaxStake="100"/>	
									<StakeLevel StakeLevelID="0" GameTypeID="2401"  MinLabel="10" MaxLabel="100" MinStake="10" MaxStake="100" />
						</ROOT>'
*/
BEGIN
SET NOCOUNT ON
DECLARE @tmpStakeLevel TABLE(
							StakeLevelID	INT							
							,GameTypeID		INT							
							,MinLabel		NVARCHAR(50)
							,MaxLabel		NVARCHAR(50)
							,MinStake		DECIMAL(19,8)
							,MaxStake		DECIMAL(19,8)
							,Isfinished		BIT default(0)
						);
DECLARE @tmpStakeLevel_Old TABLE(
							StakeLevelID	INT							
							,GameTypeID		INT							
							,MinLabel		NVARCHAR(50)
							,MaxLabel		NVARCHAR(50)
							,MinStake		DECIMAL(19,8)
							,MaxStake		DECIMAL(19,8)							
						);
DECLARE @MaxStakeLevelID INT
		,@GameTypeID	INT						
		,@MinLabel		NVARCHAR(50)
		,@MaxLabel		NVARCHAR(50)
		,@MinStake		DECIMAL(19,8)
		,@MaxStake		DECIMAL(19,8)
		,@Currency		INT
		,@SiteID		INT
		,@DocHandler	INT
		,@LogSPData		NVARCHAR(MAX) = ''
		,@LogSPData_OLD	NVARCHAR(MAX) = ''
		,@endRun		DATETIME
		,@duration		INT
		,@startRun		DATETIME
SET	@startRun = GETDATE();  

SELECT @MaxStakeLevelID=MAX(StakeLevelID) FROM Dep_StakeLevel WITH(NOLOCK)
SELECT @Currency=d.currency,@SiteID=s.siteid
FROM Dep_CustSuper d WITH(NOLOCK)
	INNER JOIN Site s WITH(NOLOCK)	 ON d.site=s.site
WHERE d.custid=@CustID

IF	@StakeLevel <> ''
BEGIN
	-- For read xml					
	EXECUTE	sp_xml_preparedocument
				@DocHandler			OUTPUT
			,	@StakeLevel;

	INSERT INTO	@tmpStakeLevel (
						StakeLevelID	
						,GameTypeID								
						,MinLabel		
						,MaxLabel		
						,MinStake		
						,MaxStake)
	SELECT	Data.StakeLevelID		
		,	Data.GameTypeID
		,	Data.MinLabel
		,	Data.MaxLabel
		,	Data.MinStake
		,	Data.MaxStake
	FROM OPENXML (@DocHandler, '/ROOT/StakeLevel', 1) 
	WITH (
		StakeLevelID	INT
		,GameTypeID		INT					
		,MinLabel		NVARCHAR(50)
		,MaxLabel		NVARCHAR(50)
		,MinStake		DECIMAL(19,8)
		,MaxStake		DECIMAL(19,8)
	) AS Data;

	EXECUTE	sp_xml_removedocument
				@DocHandler;
END

INSERT INTO	@tmpStakeLevel_Old (
						StakeLevelID	
						,GameTypeID								
						,MinLabel		
						,MaxLabel		
						,MinStake		
						,MaxStake)
SELECT					StakeLevelID	
						,GameTypeID								
						,MinLabel		
						,MaxLabel		
						,MinStake		
						,MaxStake
FROM Dep_StakeLevel WITH(NOLOCK)
WHERE ExchangeID=@Currency AND SiteID=@SiteID

UPDATE d
SET d.MinLabel=t.MinLabel,d.MaxLabel=t.MaxLabel,d.MinStake=t.MinStake,d.MaxStake=t.MaxStake
FROM Dep_StakeLevel d 
	INNER JOIN @tmpStakeLevel t ON d.StakeLevelID=t.StakeLevelID AND d.GameTypeID=t.GameTypeID

UPDATE t
SET t.Isfinished=1
FROM Dep_StakeLevel d 
	INNER JOIN @tmpStakeLevel t ON d.StakeLevelID=t.StakeLevelID AND d.GameTypeID=t.GameTypeID

WHILE (1 = 1)
BEGIN
	UPDATE TOP (1) @tmpStakeLevel
	SET isfinished = 1
		,@GameTypeID	= GameTypeID				
		,@MinLabel		= MinLabel
		,@MaxLabel		= MaxLabel
		,@MinStake		= MinStake
		,@MaxStake		= MaxStake
	WHERE isfinished = 0
	
	IF @@ROWCOUNT = 0 BREAK
	
	SET @MaxStakeLevelID = @MaxStakeLevelID + 1	

	 INSERT INTO Dep_StakeLevel([StakeLevelID],[GameTypeID],[GameGroupID],[MinLabel],[MaxLabel],[MinStake],[MaxStake],[ExchangeID],[SiteID])
	 VALUES(@MaxStakeLevelID,@GameTypeID,0,@MinLabel,@MaxLabel,@MinStake,@MaxStake,@Currency,@SiteID)
END

		SELECT @LogSPData=(	SELECT
								@UserID		AS '@UserID'
							,	@CustID		AS '@CustID'
							,	@ErrCode	AS '@ErrCode'
							,	@ErrMsg		AS '@ErrMsg'
							,	@IP			AS '@IP'
							,	1			AS '@EnableVirtualrate'
							,	(	SELECT	t.StakeLevelID			AS '@StakeLevelID'
										,	t.GameTypeID			AS '@GameTypeID'
										,	t.MinLabel				AS '@MinLabel'
										,	t.MaxLabel				AS '@MaxLabel'
										,	t.MinStake				AS '@MinStake'
										,	t.MaxStake				AS '@MaxStake'
									FROM	@tmpStakeLevel AS t 
									FOR XML PATH ('s')
								,	TYPE
								)
						FOR XML PATH ('Acc_Dep_CustSetting_GlobalStakeLevelUpdate')
					)

		SELECT @LogSPData_OLD=(	SELECT	
							@UserID		AS '@UserID'
						,	@CustID		AS '@CustID'
						,	@ErrCode	AS '@ErrCode'
						,	@ErrMsg		AS '@ErrMsg'
						,	@IP			AS '@IP'
						,	1			AS '@EnableVirtualrate'
						,	(	SELECT	t.StakeLevelID			AS '@StakeLevelID'
									,	t.GameTypeID			AS '@GameTypeID'
									,	t.MinLabel				AS '@MinLabel'
									,	t.MaxLabel				AS '@MaxLabel'
									,	t.MinStake				AS '@MinStake'
									,	t.MaxStake				AS '@MaxStake'
								FROM	@tmpStakeLevel_Old AS t 
								FOR XML PATH ('s')
							,	TYPE
							)
					FOR XML PATH ('Acc_Dep_CustSetting_GlobalStakeLevelUpdate')
				)
	SET	@endRun = GETDATE();
	SET	@duration = DATEDIFF(MILLISECOND, @startRun, @endRun);	
		BEGIN TRY
			EXECUTE	DBLOG.bodb_CustomerLog.dbo.WriteLog_UserLog_RunSP
						@UserID = @UserID
					,	@CustID = @CustID
					,	@ActionID = 396
					,	@TrackingValue = @LogSPData
					,	@TrackingValue2= @LogSPData_OLD
					,	@Duration = @duration;			
		END TRY
		BEGIN CATCH
			EXECUTE	bodb_CustomerLog.dbo.WriteLog_UserLog_RunSP
						@UserID = @UserID
					,	@CustID = @CustID
					,	@ActionID = 396
					,	@TrackingValue = @LogSPData
					,	@TrackingValue2= @LogSPData_OLD
					,	@Duration = @duration;
		END CATCH;
END	

GO