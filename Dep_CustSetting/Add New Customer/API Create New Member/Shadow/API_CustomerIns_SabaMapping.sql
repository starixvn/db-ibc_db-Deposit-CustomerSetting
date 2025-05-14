/*<info serverAlias="DBCUST-CustDB" executers="asv_cust" viewers="" isFunction="0"></info>*/
ALTER PROCEDURE [dbo].[API_CustomerIns_SabaMapping]
	@SabaID		BIGINT, 
	@CustID		INT,
	@CustType	TINYINT,
	@IsTest		BIT = 0,
	@ErrCode	INT = 0 OUTPUT,
	@ErrMsg		NVARCHAR(2000) = '' OUTPUT
AS
/*    
	Created: 20241230@Tacy 
	Task : Saba Coins - Phase 2 - Support multiple wallets
	DB: DBCUST/CustDB    
	    
	Revisions:  
		- 20241230@Tacy: Create SP [Redmine: #215807]
*/
BEGIN
	SET NOCOUNT ON;

	DECLARE @TrackingValue VARCHAR(MAX), @TrackingValue2 VARCHAR(MAX)
		, @_dbCustType TINYINT

	--Invalid SabaID
	IF ISNULL(@SabaID,0)=0
	BEGIN
		SELECT @ErrMsg = 'Invalid wallet ID.', @ErrCode = 11      
		RETURN
	END

	--Invalid member
	IF NOT EXISTS (SELECT 1 FROM custInfo WITH (NOLOCK) WHERE custid=@CustID AND roleid=1)
	BEGIN
		SELECT @ErrMsg = 'Invalid member.', @ErrCode = 10      
		RETURN
	END

	--Invalid CustType
	SELECT @_dbCustType = CASE WHEN c.site='SabaCoins' THEN 1 ELSE 0 END
	FROM Customer c WITH (NOLOCK)
	WHERE custid=@CustID

	IF @CustType<>@_dbCustType
	BEGIN
		SELECT @ErrMsg = 'Invalid member.', @ErrCode = 16      
		RETURN
	END

	--cannot map test to real / real to test
	IF EXISTS (SELECT 1 FROM Customer WITH (NOLOCK) WHERE custid=@CustID 
				AND
				(
					(@IsTest=1 AND ((currency<>20 AND @CustType=0) OR (currency<>72 AND @CustType=1))) 
				OR
					(@IsTest=0 AND ((currency=20 AND @CustType=0) OR (currency=72 AND @CustType=1)))
				)
			)
	BEGIN
		SELECT @ErrMsg = 'This member cannot associate with this wallet ID.', @ErrCode = 15      
		RETURN
	END

	--Real mapping: Unchange sabaID
	IF EXISTS (SELECT 1 FROM Dep_CustSabaInfo WITH (NOLOCK) WHERE CustID=@CustID AND SabaID=@SabaID) 
	BEGIN
		SELECT @ErrMsg = 'This member is already associated with this wallet ID.', @ErrCode = 14     
		RETURN
	END

	BEGIN TRY
		IF EXISTS (SELECT 1 FROM Dep_CustSabaInfo WITH (NOLOCK) WHERE CustID=@CustID)
		BEGIN --Allow update for real members
			--Old value
			SET @TrackingValue2 = CONVERT (
									VARCHAR(MAX),
									(SELECT sb.CustID, sb.CustType, sb.SabaID
									 FROM Dep_CustSabaInfo sb WITH(NOLOCK)
									 WHERE CustID=@CustID
									 FOR XML RAW('R'),
									 TYPE)
									)

			UPDATE Dep_CustSabaInfo WITH (ROWLOCK, UPDLOCK)
			SET SabaID=@SabaID
				,RepUpdateTime=dbo.f_GetDateTime2()
			WHERE CustID=@CustID
		END
		ELSE -- Add Real/Shadow mapping
		BEGIN
			INSERT INTO Dep_CustSabaInfo (CustID, CustType, SabaID, RepUpdateTime)
			SELECT @CustID, @CustType, @SabaID, dbo.f_GetDateTime2()
		END

	END TRY
	BEGIN CATCH
		SELECT @ErrCode=ERROR_NUMBER()
			, @ErrMsg=ERROR_MESSAGE()
		RETURN
	END CATCH

	--Write log info
	DECLARE @LogInfo_Tbl TABLE(UserID INT, CustID INT, ActionID INT, TrackingValue VARCHAR(MAX), TrackingValue2 VARCHAR(MAX))

	SET @TrackingValue = CONVERT (
									VARCHAR(MAX),
									(SELECT @CustID		AS CustID
											,@CustType	AS CustType
											,@SabaID	AS SabaID
									 FOR XML RAW('R'),
									 TYPE)
									)

	INSERT INTO @LogInfo_Tbl(UserID, CustID, ActionID, TrackingValue, TrackingValue2)
	SELECT @CustID, @CustID, 271006, @TrackingValue, @TrackingValue2

	SELECT UserID, CustID, ActionID, TrackingValue, TrackingValue2
	FROM @LogInfo_Tbl
END
GO