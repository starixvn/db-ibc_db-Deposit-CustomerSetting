USE [CustDB]
GO
/****** Object:  StoredProcedure [dbo].[Acc_AGC_SelSuperSetting_xtest]    Script Date: 10/21/2015 9:17:27 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****** Object:  Stored Procedure dbo.Acc_AGC_SelSuperSetting    Script Date: 8/28/2014 3:01:31 PM ******/
ALTER PROCEDURE	[dbo].[Acc_AGC_SelSuperSetting]
	@CustID		INT
AS
/*
	Created: 20140813@Victor
	Task: Select AG Casino product setting of super
	DB: DBTXN/CustDB
	Original:
	Revisions:
	- 20150916@Winnie: Change for AGCasino new version.
	Param's Explanation:
*/
BEGIN
	SET NOCOUNT ON
	
	DECLARE @CheckedGroup			VARCHAR(500)	
			,@DefaultGroup			VARCHAR(20)		
			,@IsEnabled				BIT				
			,@Upline				INT
			,@UplineIsEnabled		BIT			
			,@UplineCheckedGroup	VARCHAR(500)		
			,@MemberCheckedGroup	VARCHAR(20)
			,@UplineDefaultGroup		VARCHAR(20)		
			,@RoleId				INT	
	
	SELECT @CheckedGroup	=	CheckedGroup
		,@DefaultGroup		=	DefaultGroup
		,@IsEnabled			=	IsEnabled
	FROM dbo.Dep_SuperSetting_AGCasino WITH (NOLOCK) 
	WHERE CustID = @CustID

	SELECT TOP 1 @RoleId=a.roleid FROM dbo.Customer a WITH (NOLOCK) 
	WHERE CustID = @CustID
	IF @RoleId=1	
	SELECT TOP 1  @Upline=a.recommend FROM dbo.Customer a WITH (NOLOCK) 
	WHERE CustID = @CustID
	ELSE IF @RoleId=2
	SELECT TOP 1  @Upline=a.mrecommend FROM dbo.Customer a WITH (NOLOCK) 
	WHERE CustID = @CustID
	ELSE IF @RoleId=3
	SELECT TOP 1  @Upline=a.srecommend FROM dbo.Customer a WITH (NOLOCK) 
	WHERE CustID = @CustID

	SELECT @UplineCheckedGroup	=	CheckedGroup , @UplineDefaultGroup=	DefaultGroup,@UplineIsEnabled=IsEnabled
	FROM dbo.Dep_SuperSetting_AGCasino WITH (NOLOCK) 
	WHERE CustID = @Upline

	SELECT 
		Username AS Username
		,firstname AS Firstname
		,lastname AS Lastname
		,username2 AS Nickname
		,phone AS Phone
		,mobilephone AS Mobilephone
		,fax AS Fax
		,currency AS Currency
		,CASE WHEN a.roleid=1
		THEN (SELECT TOP 1 b.site FROM Customer b WITH (NOLOCK) WHERE b.custid=@Upline)
		ELSE
		a.site
		END AS SiteName
	FROM dbo.Customer a WITH (NOLOCK) 
	WHERE CustID = @CustID

	IF @RoleId<>1
	BEGIN
	SELECT @CheckedGroup AS CheckedGroup
		,@DefaultGroup AS DefaultGroup
		,@IsEnabled AS IsEnabled
		,@UplineCheckedGroup AS UplineCheckedGroup
	END
	ELSE
	BEGIN
	--member
	SELECT @IsEnabled = 0
	SELECT	@MemberCheckedGroup = AGGroup, 
			@IsEnabled = ISNULL(IsEnabled,0)
	FROM dbo.Dep_CustSetting_AGCasino WITH (NOLOCK)
	WHERE CustID = @CustId

	SELECT @UplineIsEnabled = ISNULL(IsEnabled,0) FROM dbo.Dep_SuperSetting_AGCasino WITH (NOLOCK) WHERE CustID = @Upline

	IF (@UplineIsEnabled = 0)
		SELECT @IsEnabled = 0

	IF @MemberCheckedGroup IS NULL
	SELECT @MemberCheckedGroup=@UplineDefaultGroup
	SELECT @MemberCheckedGroup AS CheckedGroup
		  ,@UplineDefaultGroup AS DefaultGroup
		  ,@IsEnabled AS IsEnabled
		  ,@UplineCheckedGroup AS UplineCheckedGroup
	END

	EXEC Acc_Dep_CustomerSelSetting
	 @custid	=@custid,
	 @SportType =250
END

GO
GRANT EXECUTE ON [dbo].[Acc_AGC_SelSuperSetting] TO [bodbAdminNet] AS [dbo]