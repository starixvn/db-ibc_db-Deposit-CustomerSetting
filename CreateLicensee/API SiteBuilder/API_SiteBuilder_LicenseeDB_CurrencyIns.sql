/*<info serverAlias="DBCUST-bodb_Licensee" executers="asv_cust" viewers="" isFunction="0"></info>*/
ALTER PROCEDURE [dbo].[API_SiteBuilder_LicenseeDB_CurrencyIns]
	  @SiteName		VARCHAR(10)  
	, @CurrencyList	VARCHAR(MAX)
	, @PT_Sportsbook SMALLMONEY
	, @IP			VARCHAR(50)	= ''
	, @ErrCode		INT = 0 OUTPUT
	, @ErrMsg		NVARCHAR(MAX) = '' OUTPUT
	, @LicenseeId	INT = 0 OUTPUT
	, @ErrExtraInfo VARCHAR(MAX) = '' OUTPUT -- Log DB
AS
/*
	Created: 20240705@Eden  
	Task : SiteBuider --> Create new currency setting on Licensee DB
	DB: DBCUST-bodb_Licensee
	Original sp: 
	
	Revisions: 
		- 20240705@Eden  : Scale out DBCUST - Licensee Customer in GlobCustDB [redmine: #207474]

	Param's Explanation: 
		Sample Format:
*/			   					
BEGIN
	SET NOCOUNT ON;  
	DECLARE @TmpCurrency TABLE (Currency INT, isfinished bit default 0)
	DECLARE @Error AS TABLE (Step VARCHAR(MAX), ErrMsg NVARCHAR(MAX))
	DECLARE @SPErrMsg  NVARCHAR(MAX) = ''
		, @tmpSuperWildCard VARCHAR(100)
		, @Currency INT 
		, @Step VARCHAR(MAX)
		, @CreatorID INT = 10278938
		, @Doing NVARCHAR(MAX)

	SET @SiteName = LTRIM(RTRIM(@SiteName))
	SET @tmpSuperWildCard = @SiteName + 'Super'

	BEGIN TRY
		INSERT INTO @TmpCurrency(Currency)
		SELECT Currency
		FROM OPENJSON(@CurrencyList) WITH (Currency INT  '$.Currency')
	END TRY
	BEGIN CATCH
		SELECT  @ErrMsg = N'Invalid Json Input'	, @ErrCode = 50001 ;	
		RETURN
	END CATCH
	
	WHILE (1 = 1)
	BEGIN
		SELECT @ErrCode = 0, @ErrMsg = '', @Step = '', @SPErrMsg = ''
		
		UPDATE TOP (1) t
		SET   @Currency = t.Currency 
			, t.isfinished = 1
		FROM @TmpCurrency t
		WHERE isfinished = 0	

		IF @@ROWCOUNT = 0 BREAK

		SET @Step = 'Nap_LM_Licensee_AddAgent_New'

		BEGIN TRY
			EXEC Nap_LM_Licensee_AddAgent_New 
				  @LicenseeName		= @SiteName
				, @SuperWildCard	= @tmpSuperWildCard
				, @Currency			= @Currency
				, @IsSpecial		= 0
				, @ErrMsg			= @SPErrMsg OUTPUT

			IF ISNULL(@SPErrMsg,'') <> ''
			BEGIN
				INSERT INTO @Error (ErrMsg, Step)
				SELECT @SPErrMsg, @Step

				GOTO WritelogCurrency; --Skip next step
			END
		END TRY
		BEGIN CATCH
				SELECT @SPErrMsg = ERROR_MESSAGE()
				INSERT INTO @Error (ErrMsg,Step)
				SELECT @SPErrMsg, @Step

				GOTO WritelogCurrency; --Skip next step
		END CATCH

		SET @Step = 'LA_DiscountByGrossWinCurrencyIns'

		BEGIN TRY
			EXEC dbo.LA_DiscountByGrossWinCurrencyIns
				 @SiteName				= @SiteName
				,@CurrencyId			= @Currency
				,@PT_Sportsbook			= @PT_Sportsbook
				,@UserId				= @CreatorID
				,@IP					= @IP
		END TRY
		BEGIN CATCH
				SELECT @SPErrMsg = ERROR_MESSAGE()
				INSERT INTO @Error (ErrMsg,Step)
				SELECT @SPErrMsg, @Step
		END CATCH

		WritelogCurrency: --Log each Currency
		SET @Doing =  N'<Action value="Licensee_AddAgent">'
					+ N'<RedmineId>0</RedmineId>'
					+ N'<SpName>Nap_LM_Licensee_AddAgent</SpName>'
					+ N'<UpdatedBy UserId="0" UserName="Site Builder" />'
					+ N'<Agent'
							+ N' LicenseeName="' + @SiteName + '"'
							+ N' SuperWildCard="' + @SiteName + 'Super"'
							+ N' IsSpecial="False"'
							+ N' Currency="' + CAST(@Currency as VARCHAR(10)) + '"'
							+ N'</Agent>'
					+ (CASE WHEN ISNULL(@SPErrMsg, '') <> '' THEN N'<Result>' + @SPErrMsg + N'</Result>' ELSE '' END)
					+ N'</Action>'

		BEGIN TRY
			SET @Step = 'Writelog'

			EXEC DBLOG.bodb_CustomerLog.dbo.WriteLog_UserLog_UserControl
				@CustID		=	0,
				@UserID		=	0,
				@TypeID		=	0,
				@ActionID	=	5527,
				@Doing		=	@Doing,
				@Duration	=   0
		END TRY
		BEGIN CATCH
				SELECT @SPErrMsg = ERROR_MESSAGE()
				INSERT INTO @Error (ErrMsg,Step)
				SELECT @SPErrMsg, @Step
		END CATCH
	END

	SELECT @LicenseeId = LicenseeId FROM Licensees WITH(NOLOCK) WHERE LicenseeName = @SiteName
	
	IF EXISTS (SELECT 1 FROM @Error WHERE ISNULL(ErrMsg , '') <> '')
	BEGIN
		SELECT	@ErrCode = 50109,
				@ErrMsg = 'Process has completed. Warning: ' + STUFF((
							SELECT ';' + ErrMsg + '(' + Step + ')' 
							FROM @Error
							WHERE ISNULL(ErrMsg, '') <> ''
							FOR XML PATH('')), 1, 1, '')

		SET @ErrExtraInfo = (
			SELECT Step, ErrMsg
			FROM @Error
			FOR Json PATH
			)
	END
END	
GO
