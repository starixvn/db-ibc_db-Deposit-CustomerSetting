/*<info serverAlias="DBPRO-bodb02" executers="asv_cust" viewers="" isFunction="0"></info>*/
CREATE PROCEDURE [dbo].[API_Dep_CustomerCheckOddsAdj]
	@SiteID	CHAR(7)			,
	@ErrCode	INT			 = 0  OUTPUT,
	@ErrMsg	VARCHAR(2000)	 = '' OUTPUT
AS
/*
	Created by: Helios
	Date: 20240812
	Task: Check OddsAdj dummy customers
	DB: DBPRO/bodb02
	Original: 
	
	Revisions:
		- 20240812@Helios: Scale out DBCUST - Licensee Customer in GlobCustDB [redmine: #207474]  

	Explanation's Param:
		
*/   
BEGIN 
	SET NOCOUNT ON
	
	IF NOT EXISTS  ( SELECT 1 
				FROM dbo.LicSiteSetting p WITH (NOLOCK)
				WHERE SiteId = @SiteID AND ApplySpreadAdjustment = 1
				AND ISNULL(p.IsDeleted,0) = 0)
		OR ISNULL(@SiteID,'') = ''
	BEGIN
		SELECT @ErrMsg = 'The site is not offer OddAdj.', @ErrCode = 111    
		RETURN    
	END
END