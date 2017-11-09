/*<info serverAlias="DBCUST-CUSTDB" executers="bodbAdminNet,bodbExtAccNet,bodbDownlineNet,bodbLicenseeNet" viewers="vnteam" isFunction="0"></info>*/
USE CustDB
GO
/****** Object:  StoredProcedure dbo.Acc_3rdProductSelSuperStatus    Script Date: 10/09/2017 09:05:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****** Object:  Stored Procedure dbo.Acc_3rdProductSelSuperStatus    Script Date: 11/24/2015 9:44:45 AM ******/

ALTER PROCEDURE [dbo].[Acc_Dep_CustSetting_GlobalStakeLevelUpdate] 
	@StakeLevel VARCHAR(MAX)	= ''	
	,@CustID		INT
	
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
DECLARE @MaxStakeLevelID INT
		,@GameTypeID	INT						
		,@MinLabel		NVARCHAR(50)
		,@MaxLabel		NVARCHAR(50)
		,@MinStake		DECIMAL(19,8)
		,@MaxStake		DECIMAL(19,8)
		,@Currency		INT
		,@SiteID		INT
		,@DocHandler	INT;	

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

UPDATE d
SET d.MinLabel=t.MinLabel,d.MaxLabel=t.MaxLabel,d.MinStake=t.MinStake
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

END	

GO