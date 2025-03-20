/*<info serverAlias="DBGLOB-GlobCustDB" executers="" viewers="" isFunction="0"></info>*/
ALTER PROCEDURE [dbo].Acc_Dep_Initial_DCS_CheckRunningStatusByConfigID
	@ConfigID INT,
	@IsRunning BIT = 0 OUTPUT
AS
/*
	Created: 20220913@Eden
	Task : Check running status of this config
	DB: DBGLOB-GlobCustDB
	Original:

	Revisions:  
	- 20220913@Eden: Flexible Initializing Deposit Customer Setting [RedmineID: #169648]
	- 20250120@Tacy: Move to GlobCustDB [RedmineID: #216870]

	Parameter Definition

	Example: 
		DECLARE @IsRunning BIT = 0
		EXEC [Acc_Dep_Initial_DCS_CheckRunningStatusByConfigID] 
			@ConfigID = 6,
			@IsRunning = @IsRunning OUTPUT
		SELECT @IsRunning
	
	*/
BEGIN
	SET NOCOUNT ON
	SET @IsRunning = 0

	IF EXISTS(
		SELECT 1
		FROM Dep_Initial_ProductConfig WITH(NOLOCK)
		WHERE ConfigID = @ConfigID
			AND Status = 1 --Running
	)
	BEGIN
		SET @IsRunning = 1
	END
END
GO


