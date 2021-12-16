/*<info serverAlias="DBCust-CustDB" executers="bodbAdminNet,Dot_Member" viewers="" isFunction="0"></info>*/
CREATE PROCEDURE [dbo].[Acc_Dep_CustomerCheckOddsAdj]
	@Site	NVARCHAR(100),
	@IsOffer	BIT OUTPUT 
AS
/*
	Created by: Winfred
	Date: 20201005
	Task: Check OddsAdj dummy customers
	DB: DBCust/CustDB
	Original: 
	
	Revisions:
		- 20201005@Winfred: Check OddsAdj dummy customers [redmine:#142952]
		- 20211112@Eden: Alpha/NAP - In-house Replication (isDeleted & RepUpdateTime) [RedmineID: #164321]

	Explanation's Param:
		
*/   
BEGIN 
	SET NOCOUNT ON
	
	SELECT @IsOffer = 0
    DECLARE	@SiteId CHAR(7) = ''
	
	SELECT @SiteId = SiteId 
	FROM SiteConfig.dbo.LicVendorProfile WITH (NOLOCK)
	WHERE SiteName = @Site

	IF @SiteId <> '' AND EXISTS( SELECT 1 
						FROM DBPRO.bodb02.dbo.LicSiteSetting p WITH (NOLOCK)
						WHERE SiteId = @SiteId AND ApplySpreadAdjustment = 1
							AND ISNULL(p.IsDeleted,0) = 0)
	BEGIN
		SELECT @IsOffer = 1
	END
END
