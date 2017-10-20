/*<info serverAlias="DBCUST-CUSTDB" executers="bodbAdminNet,bodbExtAccNet,bodbDownlineNet,bodbLicenseeNet" viewers="vnteam" isFunction="0"></info>*/
USE CustDB
GO
/****** Object:  StoredProcedure dbo.Acc_3rdProductSelSuperStatus    Script Date: 10/09/2017 09:05:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****** Object:  Stored Procedure dbo.Acc_3rdProductSelSuperStatus    Script Date: 11/24/2015 9:44:45 AM ******/

ALTER PROCEDURE dbo.Acc_Dep_CustSetting_StatusSelect 
	@ProductID INT
	, @CustID INT	
AS
/*
	Created: 20171009@Winne
	Task: select status of DCS product
	DB: DBCUST/CustDB
	Original:
	Revisions:
		- 20171009@Winnie: select status of DCS product RedmineID:#82346
	Param's Explanation:
*/
BEGIN
	SET NOCOUNT ON
	DECLARE  @IsDisabled			BIT = 1 
			 ,@IsDisabledDownline	BIT = 1
			 ,@HasDownline			BIT = 0 
			 ,@bitmapOrder			TINYINT=0
			 ,@SportType			INT=0
			 ,@Bettype			    INT=0

	IF EXISTS(SELECT TOP 1 1 FROM dbo.Customer s WITH (NOLOCK)	WHERE s.srecommend= @CustID	AND s.Roleid=1)
		SELECT @HasDownline=1		
		
	SELECT @bitmapOrder=bitmapOrder,@SportType=d.SportType,@Bettype=d.BetType
	FROM Dep_ProductSetting ps WITH(NOLOCK) 
		INNER JOIN Dep_ProductSettingDetail d WITH(NOLOCK) ON ps.ProductSettingID=d.ProductSettingID  
		INNER JOIN dbo.Dep_ProductStatusProfile p WITH(NOLOCK) ON d.SportType=p.Sporttype AND d.BetType=p.Bettype
	WHERE ProductID = @ProductID AND SettingType=4			
	
	IF EXISTS (SELECT TOP 1 1 FROM Dep_ProductSetting ps WITH(NOLOCK) 
									INNER JOIN Dep_LicenseeProductSetting d WITH(NOLOCK) ON ps.ProductSettingID=d.ProductSettingID 
								WHERE ProductID=@ProductID AND SettingType =4 AND CustID=@CustID)	
	BEGIN	
		SELECT	@IsDisabled=ISNULL((SELECT value FROM dbo.f_CustSetting_ProductStatusSel(stt.bitmapIsDisabled, @bitmapOrder)),1)	
		FROM dbo.Dep_CustProductStatus stt WITH (NOLOCK)	
		WHERE stt.CustID = @CustID	

		IF	@HasDownline<>0
		BEGIN
			IF EXISTS (
				SELECT TOP 1 1													
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
		
	SELECT @ProductID AS ProductID,@SportType AS Sporttype, @Bettype AS Bettype,@bitmapOrder AS bitmapOrder,@IsDisabled AS IsDisabled,@IsDisabledDownline AS IsDisabledDownline,@HasDownline AS HasDownline
END
GO