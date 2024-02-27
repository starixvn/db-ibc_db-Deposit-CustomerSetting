/*<info serverAlias="DBCUST-CUSTDB" executers="bodbAdminNet,bodbExtAccNet,bodbDownlineNet,bodbLicenseeNet,Dot_member" viewers="" isFunction="0"></info>*/

ALTER PROCEDURE [dbo].[Acc_Dep_CustSetting_StatusSelect] 
	@ProductID	INT
	,@CustID	INT
AS
/*
	Created: 20171009@Winne
	Task: select status of DCS product
	DB: DBCUST/CustDB
	Original:
	Revisions:
		- 20171009@Winnie: select status of DCS product RedmineID:#82346
		- 20180719@Winnie: Licensee DCS setting - Support insert/edit setting for sub_licensee - Redmine: 88700
		- 20241101@Tacy: LAP - Merge VS1, VS2, VS3 as Virtual Sports [Redmine: #199521]
	Param's Explanation:
*/
BEGIN
	SET NOCOUNT ON
	DECLARE  @IsDisabled			BIT = 1 
			 ,@IsDisabledDownline	BIT = 1
			 ,@IsDisabledUpline		BIT = 1
			 ,@HasDownline			BIT = 0 
			 ,@bitmapOrder			TINYINT=0
			 ,@SportType			INT=0
			 ,@Bettype			    INT=0
			 ,@RoleID				INT
			 ,@srecommend			INT=0

	CREATE TABLE #tbDep_ProductProfile (ProductSettingID INT PRIMARY KEY,
										ProductID INT,
										SportType SMALLINT,
										BetType SMALLINT,
										bitmapOrder TINYINT)


	SELECT @RoleID=RoleID,@srecommend=srecommend FROM Customer WITH(NOLOCK) WHERE custid=@CustID
	
	INSERT INTO #tbDep_ProductProfile(ProductSettingID, ProductID, SportType, BetType, bitmapOrder)
	SELECT ps.ProductSettingID, ps.ProductID, d.SportType, d.BetType, p.bitmapOrder
	FROM Dep_ProductSetting ps WITH(NOLOCK) 
		INNER JOIN Dep_ProductSettingDetail d WITH(NOLOCK) ON ps.ProductSettingID=d.ProductSettingID  
		INNER JOIN f_Dep_CustSetting_SportBetTypeSettingSelect(@ProductID,4) f 
															ON f.ProductID=ps.ProductID
															AND f.SportType=d.SportType
															AND f.Bettype=d.BetType
															AND f.SettingType=ps.SettingType
		INNER JOIN dbo.Dep_ProductStatusProfile p WITH(NOLOCK) ON f.SportType=p.Sporttype AND f.BetType=p.Bettype

	--Get bitmapOrder:
	SELECT @bitmapOrder=bitmapOrder FROM #tbDep_ProductProfile

	IF @RoleID=4
	BEGIN
		SELECT @IsDisabledUpline=0
		IF EXISTS(SELECT 1 FROM dbo.Customer s WITH (NOLOCK)	WHERE s.srecommend= @CustID	AND s.Roleid=1)
			SELECT @HasDownline=1			

		IF EXISTS (SELECT 1 FROM Dep_LicenseeProductSetting d WITH(NOLOCK) 
					INNER JOIN #tbDep_ProductProfile t ON t.ProductSettingID=d.ProductSettingID
					WHERE CustID=@CustID)	
		BEGIN	
			
			SELECT	@IsDisabled=ISNULL((SELECT value FROM dbo.f_CustSetting_ProductStatusSel(stt.bitmapIsDisabled, @bitmapOrder)),1)	
			FROM dbo.Dep_CustProductStatus stt WITH (NOLOCK)	
			WHERE stt.CustID = @CustID	

			IF	@HasDownline<>0
			BEGIN
				IF EXISTS (
					SELECT  1													
					FROM dbo.Dep_CustProductStatus stt WITH (NOLOCK)	
						INNER JOIN Customer b WITH(NOLOCK)	ON stt.CustID = b.CustID
					WHERE b.srecommend=@CustID AND b.roleid=1 AND (SELECT value FROM dbo.f_CustSetting_ProductStatusSel(stt.bitmapIsDisabled, @bitmapOrder))=1) 
				BEGIN
					SELECT @IsDisabledDownline = 1
				END
				ELSE
					SELECT @IsDisabledDownline = 0		
			END
		END	
	END
	ELSE 
	BEGIN
		IF EXISTS(SELECT 1 FROM dbo.Customer s WITH (NOLOCK) WHERE s.recommend= @CustID	AND s.Roleid=1)
			SELECT @HasDownline=1	
		
		print @bitmapOrder
		SELECT @IsDisabledUpline=ISNULL((SELECT value FROM dbo.f_CustSetting_ProductStatusSel(stt.bitmapIsDisabled, @bitmapOrder)),1)	
		FROM dbo.Dep_CustProductStatus stt WITH (NOLOCK)	
		WHERE stt.CustID = @srecommend	

		SELECT	@IsDisabled=ISNULL((SELECT value FROM dbo.f_CustSetting_ProductStatusSel(stt.bitmapIsDisabled, @bitmapOrder)),1)	
		FROM dbo.Dep_CustProductStatus stt WITH (NOLOCK)	
		WHERE stt.CustID = @CustID	

		IF	@HasDownline<>0
		BEGIN
			IF EXISTS (
				SELECT  1													
				FROM dbo.Dep_CustProductStatus stt WITH (NOLOCK)	
					INNER JOIN Customer b WITH(NOLOCK)	ON stt.CustID = b.CustID
				WHERE b.recommend=@CustID AND b.roleid=1 AND (SELECT value FROM dbo.f_CustSetting_ProductStatusSel(stt.bitmapIsDisabled, @bitmapOrder))=1) 				
			BEGIN						
				SELECT @IsDisabledDownline = 1
			END
			ELSE IF EXISTS(SELECT 1 FROM dbo.Customer s WITH (NOLOCK)	
							INNER JOIN Dep_CustProductStatus cs WITH(NOLOCK) ON s.custid=cs.CustID
								WHERE s.recommend= @CustID	AND s.Roleid=1)
			BEGIN				
				SELECT @IsDisabledDownline = 0		
			END
		END
		
	END
	
	SELECT ProductID, Sporttype, Bettype, bitmapOrder
		,@IsDisabled AS IsDisabled
		,@IsDisabledDownline AS IsDisabledDownline
		,@HasDownline AS HasDownline
		,@IsDisabledUpline AS IsDisabledUpline
	FROM #tbDep_ProductProfile

	DROP TABLE #tbDep_ProductProfile
END
GO