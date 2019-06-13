/*<info serverAlias="DBCust-CustDB" executers="bodbAdminNet,bodbLicenseeNet,Dot_member" viewers="" isFunction="0" isNested="0"></info>*/
ALTER PROCEDURE [dbo].[NAP_Admin_VerifySiteName]
	@Sitename	VARCHAR(10),
	@ErrCode	INT = 0 OUTPUT,
	@ErrMsg		NVARCHAR(200) = '' OUTPUT
AS
/*
	Created: 20170704@Harper
	DB: DBCust.CustDB
	Description: Create new site by NAP [RedmineID: #77817]

	Revisions:
		- 20170704@Harper: Create new SP [RedmineID: #77817]
		- 20190425@Winnie:  Onebook SiteBuilder RedmineID: #111321
*/
BEGIN

	IF EXISTS (SELECT TOP 1 1 FROM dbo.Site WITH (NOLOCK) WHERE site = @Sitename)
	BEGIN
		SELECT @ErrMsg = 'Site name: ' + @Sitename + ' already exists !!!'
		     , @ErrCode = 101
		
		RETURN
	END

END
GO
GRANT EXECUTE ON [dbo].[NAP_Admin_VerifySiteName] TO [bodbAdminNet]
GO

