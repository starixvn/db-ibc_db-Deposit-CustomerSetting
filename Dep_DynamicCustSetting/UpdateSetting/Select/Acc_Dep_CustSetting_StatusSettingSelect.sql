/*<info serverAlias="DBCUST-CUSTDB" executers="bodbAdminNet,bodbDownlineNet,bodbExtAccNet,bodbLicenseeNet" viewers="vnteam" isFunction="0"></info>*/
ALTER PROCEDURE [dbo].[Acc_Dep_CustSetting_StatusSettingSelect] 
	  @CustID		INT
	, @ProductID	TINYINT = NULL
	, @SettingType	SMALLINT = 4
	, @RoleID INT = NULL
AS
/*
	Created: 20160405@Helen
	Task : Implementing Setting for Deposit customer
	DB: DBCUST/CustDB, DBAGE/bodb02
	Original:

	Revisions:
		- 20170302@Helen: Betradar Virtual Sports  -Integration for Cash [Redmine: 77274]
	Param's Explanation:
	• @CustID: 
	
	*/
BEGIN
	
	DECLARE @IsDisabledDownline BIT, @downlines BIT  = 0 
	DECLARE @SuperID INT, @MasterID INT, @AgentID INT
	
	SELECT @SuperID=ci.srecommend, @MasterID=ci.mrecommend , @AgentID = ci.recommend  
	FROM dbo.custInfo ci WITH(NOLOCK)  
	WHERE ci.custid=@CustID 
	
	SELECT @ProductID AS ProductID,SportType,Bettype,IsLive, SettingType 
	INTO #SportBettypeFilter
	FROM dbo.f_Dep_CustSetting_SportBetTypeSettingSelect(@ProductID,@SettingType)
	
	IF @RoleID = 4
	BEGIN

		IF EXISTS (SELECT 1
					FROM custinfo WITH (NOLOCK)
					WHERE srecommend = @CustID	AND roleid = 3
					)
		SET @downlines = 1			
			
		SELECT pds.ProductID, pdt.SportType
			, pdt.BetType
			, CAST(CASE WHEN stt.CustID IS NULL THEN 1 ELSE (CASE WHEN (SELECT value FROM dbo.f_CustSetting_ProductStatusSel(stt.bitmapIsHidden, PSP.bitmapOrder)) = 0 THEN 0 ELSE 1 END) END AS BIT) AS isHidden  
			
			, CASE WHEN stt.CustID IS NULL THEN 1 ELSE (SELECT value FROM dbo.f_CustSetting_ProductStatusSel (stt.bitmapIsDisabled, PSP.bitmapOrder)) END as isDisabled
			
			, CASE 	
					WHEN @downlines = 0	THEN ISNULL((SELECT value FROM dbo.f_CustSetting_ProductStatusSel (stt.bitmapIsDisabled, PSP.bitmapOrder)),0)
					ELSE ISNULL((
							SELECT TOP 1 1
							FROM dbo.custInfo ci WITH (NOLOCK)
								INNER JOIN dbo.Dep_CustProductStatus cps_temp WITH (NOLOCK) ON ci.custid = cps_temp.CustID
							WHERE srecommend = @CustID	AND roleid = 3
								AND (SELECT value FROM dbo.f_CustSetting_ProductStatusSel(cps_temp.bitmapIsDisabled, PSP.bitmapOrder)) = 1
							), 0)
							
			 END AS IsDisabledDownline
			, 0 AS isDisabledUpline
			, ISNULL(@downlines,0) As HasDownline
			, 0 IsHiddenUpline
			, 1 IsSync
			, 1 IsSyncedDownline
			, 1 IsSyncedUpline
		FROM dbo.Dep_ProductSetting pds WITH (NOLOCK)
			INNER JOIN dbo.Dep_ProductSettingDetail pdt WITH (NOLOCK) ON pds.ProductSettingID = pdt.ProductSettingID
			INNER JOIN #SportBettypeFilter ft ON pdt.SportType = ft.sporttype
												AND pdt.BetType = ft.bettype
												AND pdt.IsLive = ft.islive
												AND pds.SettingType = ft.SettingType
			INNER JOIN dbo.Dep_ProductStatusProfile psp WITH (NOLOCK) ON PSP.Bettype = pdt.BetType AND PSP.Sporttype = PDT.SportType															
			LEFT JOIN dbo.Dep_CustProductStatus stt WITH (NOLOCK)	ON stt.CustID = @CustID
			
		WHERE pds.SettingType = @SettingType
		
	END
	ELSE IF @RoleID = 3
	BEGIN
	
		IF EXISTS (SELECT 1
						FROM custinfo WITH (NOLOCK)
						WHERE mrecommend = @CustID	AND roleid = 2
						)
		SET @downlines = 1	
   
		SELECT pds.ProductID, pdt.SportType
			, pdt.BetType
			, CAST(CASE WHEN stt.CustID IS NULL THEN 1 ELSE (CASE WHEN (SELECT value FROM dbo.f_CustSetting_ProductStatusSel(stt.bitmapIsHidden, PSP.bitmapOrder)) = 0 THEN 0 ELSE 1 END) END AS BIT) AS isHidden  
			, CASE WHEN stt.CustID IS NULL THEN 1 ELSE (SELECT value FROM dbo.f_CustSetting_ProductStatusSel(stt.bitmapIsDisabled, PSP.bitmapOrder)) END as isDisabled
			
			, CASE 	
					WHEN @downlines = 0	THEN ISNULL((SELECT value FROM dbo.f_CustSetting_ProductStatusSel(stt.bitmapIsDisabled, PSP.bitmapOrder)),0)
					ELSE ISNULL((
							SELECT TOP 1 1
							FROM dbo.custInfo ci WITH (NOLOCK)
								INNER JOIN dbo.Dep_CustProductStatus cps_temp WITH (NOLOCK) ON ci.custid = cps_temp.CustID
							WHERE mrecommend = @CustID	AND roleid = 2
								AND (SELECT value FROM dbo.f_CustSetting_ProductStatusSel(cps_temp.bitmapIsDisabled, PSP.bitmapOrder)) = 1
							), 0)
							
			 END AS IsDisabledDownline
			 , dbo.f_GetProductStatus(stt_UPLINE.bitmapIsDisabled, PSP.bitmapOrder) as IsDisabledUpline
			 , ISNULL(@downlines,0) As HasDownline
			 , 0 IsHiddenUpline
			 , 1 IsSync
			 , 1 IsSyncedDownline
			 , 1 IsSyncedUpline
		FROM dbo.Dep_ProductSetting pds WITH (NOLOCK)
			INNER JOIN dbo.Dep_ProductSettingDetail pdt WITH (NOLOCK) ON pds.ProductSettingID = pdt.ProductSettingID
			INNER JOIN #SportBettypeFilter ft ON pdt.SportType = ft.sporttype
												AND pdt.BetType = ft.bettype
												AND pdt.IsLive = ft.islive
												AND pds.SettingType = ft.SettingType
			INNER JOIN dbo.Dep_ProductStatusProfile psp WITH (NOLOCK) ON PSP.Bettype = pdt.BetType AND PSP.Sporttype = PDT.SportType															
			LEFT JOIN dbo.Dep_CustProductStatus stt WITH (NOLOCK)	ON stt.CustID = @CustID
			LEFT JOIN  dbo.Dep_CustProductStatus stt_UPLINE WITH (NOLOCK)	ON stt_UPLINE.CustID = @SuperID
			
		WHERE pds.SettingType = @SettingType
	
	END 		
	ELSE IF @RoleID = 2
	BEGIN
		IF EXISTS ( SELECT 1
					FROM custinfo WITH (NOLOCK)
					WHERE recommend = @CustID	AND roleid = 1
					)
			SET @downlines = 1	
   
		SELECT pds.ProductID, pdt.SportType
			, pdt.BetType
			
			, CAST(CASE WHEN stt.CustID IS NULL THEN 1 ELSE (CASE WHEN (SELECT value FROM dbo.f_CustSetting_ProductStatusSel(stt.bitmapIsHidden, PSP.bitmapOrder)) = 0 THEN 0 ELSE 1 END) END AS BIT) AS isHidden  
			, CASE WHEN stt.CustID IS NULL THEN 1 ELSE  (SELECT value FROM dbo.f_CustSetting_ProductStatusSel(stt.bitmapIsDisabled, PSP.bitmapOrder)) END  as isDisabled
			
			, CASE 	
					WHEN @downlines = 0	THEN ISNULL((SELECT value FROM dbo.f_CustSetting_ProductStatusSel(stt.bitmapIsDisabled, PSP.bitmapOrder)),0)
					ELSE ISNULL((
							SELECT TOP 1 1
							FROM dbo.custInfo ci WITH (NOLOCK)
								INNER JOIN dbo.Dep_CustProductStatus cps_temp WITH (NOLOCK) ON ci.custid = cps_temp.CustID
							WHERE recommend = @CustID	AND roleid = 1
								AND (SELECT value FROM dbo.f_CustSetting_ProductStatusSel(cps_temp.bitmapIsDisabled, PSP.bitmapOrder)) = 1
							), 0)
							
			 END AS IsDisabledDownline
			 
			 , (SELECT value FROM dbo.f_CustSetting_ProductStatusSel(stt_UPLINE.bitmapIsDisabled, PSP.bitmapOrder)) as IsDisabledUpline
			 , ISNULL(@downlines,0) As HasDownline
			 , 0 IsHiddenUpline
			 , 1 IsSync
			 , 1 IsSyncedDownline
			 , 1 IsSyncedUpline
		FROM dbo.Dep_ProductSetting pds WITH (NOLOCK)
			INNER JOIN dbo.Dep_ProductSettingDetail pdt WITH (NOLOCK) ON pds.ProductSettingID = pdt.ProductSettingID
			INNER JOIN #SportBettypeFilter ft ON pdt.SportType = ft.sporttype
												AND pdt.BetType = ft.bettype
												AND pdt.IsLive = ft.islive
												AND pds.SettingType = ft.SettingType
			INNER JOIN dbo.Dep_ProductStatusProfile psp WITH (NOLOCK) ON PSP.Bettype = pdt.BetType AND PSP.Sporttype = PDT.SportType															
			LEFT JOIN dbo.Dep_CustProductStatus stt WITH (NOLOCK)	ON stt.CustID = @CustID
			LEFT JOIN  dbo.Dep_CustProductStatus stt_UPLINE WITH (NOLOCK)	ON stt_UPLINE.CustID = @MasterID
			
		WHERE pds.SettingType = @SettingType
		
	END	
	ELSE IF @RoleID = 1
	BEGIN
		SELECT pds.ProductID, pdt.SportType
				, pdt.BetType
				
				, CAST(CASE WHEN stt.CustID IS NULL  THEN 1 ELSE (CASE WHEN (SELECT value FROM dbo.f_CustSetting_ProductStatusSel(stt.bitmapIsHidden, PSP.bitmapOrder)) = 0 THEN 0 ELSE 1 END) END AS BIT) AS isHidden  
				
				, CASE WHEN stt.CustID IS NULL THEN 1 ELSE (SELECT value FROM dbo.f_CustSetting_ProductStatusSel(stt.bitmapIsDisabled, PSP.bitmapOrder)) END as isDisabled
				, 0 AS IsDisabledDownline
				, (SELECT value FROM dbo.f_CustSetting_ProductStatusSel(stt_UPLINE.bitmapIsDisabled, PSP.bitmapOrder)) as IsDisabledUpline
				, 0 As HasDownline
				, 0 IsHiddenUpline
				, 1 IsSync
				, 1 IsSyncedDownline
				, 1 IsSyncedUpline
			FROM dbo.Dep_ProductSetting pds WITH (NOLOCK)
			INNER JOIN dbo.Dep_ProductSettingDetail pdt WITH (NOLOCK) ON pds.ProductSettingID = pdt.ProductSettingID
				INNER JOIN #SportBettypeFilter ft ON pdt.SportType = ft.sporttype
													AND pdt.BetType = ft.bettype
													AND pdt.IsLive = ft.islive
													AND pds.SettingType = ft.SettingType
				INNER JOIN dbo.Dep_ProductStatusProfile psp WITH (NOLOCK) ON PSP.Bettype = pdt.BetType AND PSP.Sporttype = PDT.SportType															
				LEFT JOIN dbo.Dep_CustProductStatus stt WITH (NOLOCK)	ON stt.CustID = @CustID
				LEFT JOIN  dbo.Dep_CustProductStatus stt_UPLINE WITH (NOLOCK)	ON stt_UPLINE.CustID = @AgentID
				
			WHERE pds.SettingType = @SettingType
						
		
	END	
END

GO
GRANT EXECUTE ON [dbo].[Acc_Dep_CustSetting_StatusSettingSelect] TO [bodbadminNet]
GO
GRANT EXECUTE ON [dbo].[Acc_Dep_CustSetting_StatusSettingSelect] TO [bodbDownlineNet]
GO
GRANT EXECUTE ON [dbo].[Acc_Dep_CustSetting_StatusSettingSelect] TO [bodbExtAccNet]
go
GRANT EXECUTE ON [dbo].[Acc_Dep_CustSetting_StatusSettingSelect] TO  [bodbLicenseeNet]
