
ALTER PROCEDURE dbo.Dot_Dep_3rdProductSelCustStatus @CustID INT
	, @ProductId INT
	, @IsEnabled BIT = NULL OUTPUT  
AS  
/*  
 Created: 20150304@Winnie  
 Task: Get 3rd product status of member  
 DB: DBCUST/CustDB  
 Original:  
 Revisions:  
	- 20151002@Patrick: Support MGC
	- 20151106@Patrick: Support RnG Game & rename field named DisableMicroGame to DisableMicroGameLC

 Param's Explanation:  
*/  
BEGIN  
	SET NOCOUNT ON  
   
	IF @ProductId IN (14,17) --MGC
	BEGIN
		SET @IsEnabled = 0
		SELECT @IsEnabled = CASE WHEN @ProductId = 14 THEN ~DisableMicrogameLC
								WHEN @ProductId = 17 THEN ~DisableMicrogameRNG END--CASE WHEN ISNULL(DisableMicrogame, 1) = 1 THEN 0 ELSE 1 END
		FROM dbo.custInfo WITH(NOLOCK)
		WHERE custid = @CustID
	END
	ELSE
	BEGIN
		DECLARE @Srecommend  INT, @IsLineEnabled BIT
		SELECT @Srecommend = srecommend
		FROM dbo.Customer c WITH (NOLOCK)
		WHERE c.CustID = @CustID
   
		SELECT @IsLineEnabled = ISNULL(IsEnabled, 0)
		FROM dbo.Dep_SupperProductSetting WITH (NOLOCK)
		WHERE CustID = @Srecommend  AND ProductId = @ProductId
  
		IF (@IsLineEnabled = 0)
		BEGIN
			SELECT @IsEnabled = 0
			RETURN
		END
  
		SELECT @IsEnabled = ISNULL(IsEnabled,0)  
		FROM dbo.Dep_CustProductSetting WITH (NOLOCK)  
		WHERE CustID = @CustId AND ProductId = @ProductId
	END
   
END  
GO
GRANT EXECUTE ON [dbo].[Dot_Dep_3rdProductSelCustStatus] TO [Dot_member]
GO
