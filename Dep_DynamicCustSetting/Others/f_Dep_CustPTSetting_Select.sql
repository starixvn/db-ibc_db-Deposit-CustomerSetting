/*<info serverAlias="DBTP-bodb02" executers="" isFunction="1" isNested="1"></info>*/
ALTER FUNCTION [dbo].[f_Dep_CustPTSetting_Select]
	(@CustID	INT,
	 @Sporttype	SMALLINT,
	 @Bettype	SMALLINT,
	 @IsLive	BIT)
RETURNS TABLE
AS
/*
	Created: 20240226@Tacy
	Task : Get agent PT setting for Non-Sports
	DB: DBTP/bodb02
	Original:

	Revisions:
		- 20240205@Tacy: Initial SP [RedmineID: #200454]

	Param's Explanation::		
*/	
RETURN
	WITH CTE_Customer AS (--Get: CustInfo
		SELECT @CustID AS CustID
			, @Sporttype AS Sporttype
			, @Bettype AS Bettype
			, @IsLive AS IsLive
			, cm.IsGroupedPT
			, c.recommend, s.siteid
		FROM Customer c WITH (NOLOCK) 
			INNER JOIN Site s WITH (NOLOCK) ON s.site=c.site
			INNER JOIN Dep_CustSettingMode cm WITH (NOLOCK) ON cm.CustID=c.custid
		WHERE c.CustID=@CustID
	)
	,CTE_CustRefPTSetting AS (--Get SportTypePT, BetTypePT
		--Not offered Saba Play
		SELECT c.CustID, c.Sporttype, c.Bettype, psd.IsLive
			, ref.SportTypeRefPT, ref.BetTypeRefPT
		FROM CTE_Customer c
		INNER JOIN SportBettypeSettingMatrix ref WITH (NOLOCK)
				ON	ref.Sporttype	= c.sporttype 
				AND ref.Bettype		= c.bettype
				AND ref.isLive		= c.isLive
				AND ref.isLicensee	= 1
		INNER JOIN Dep_ProductSettingDetail psd WITH (NOLOCK) 
				ON psd.SportType=ref.SportTypeRefPT
				AND psd.BetType=ref.BetTypeRefPT
		INNER JOIN Dep_ProductSetting ps WITH (NOLOCK) 
				ON ps.ProductSettingID=psd.ProductSettingID
		OUTER APPLY (SELECT RefProductID
					 FROM ProductSiteConfig psf WITH (NOLOCK) 
					 WHERE psf.SiteID=c.SiteID 
					 AND psf.ProductID=ref.RealProductId
					 AND psf.Environment<>2) psf
		WHERE ps.SettingType IN (1) AND psd.SettingStatus<>2 
			AND ref.isDeleted = 0 AND ref.Site='All'
			AND psf.RefProductID IS NULL	
	UNION --offered Saba Play
		SELECT c.CustID, c.Sporttype, c.Bettype, psd.IsLive
			, ref.SportTypeRefPT, ref.BetTypeRefPT
		FROM CTE_Customer c
		INNER JOIN SportBettypeSettingMatrix ref WITH (NOLOCK)
				ON	ref.Sporttype	= c.sporttype 
				AND ref.Bettype		= c.bettype
				AND ref.isLive	= c.isLive
				AND ref.isLicensee	= 1
		INNER JOIN Dep_ProductSettingDetail psd WITH (NOLOCK) 
				ON psd.SportType=ref.SportTypeRefPT
				AND psd.BetType=ref.BetTypeRefPT
		INNER JOIN Dep_ProductSetting ps WITH (NOLOCK) 
				ON ps.ProductSettingID=psd.ProductSettingID
		CROSS APPLY (SELECT RefProductID
					 FROM ProductSiteConfig psf WITH (NOLOCK) 
					 WHERE psf.SiteID=c.SiteID 
					 AND psf.ProductID=ref.RealProductId
					 AND psf.Environment<>2) psf
		WHERE ps.SettingType IN (1) AND psd.SettingStatus<>2 
			AND ref.isDeleted = 0 AND ref.Site='Saba Play'	--offered SAB
	)
	,CTE_CustPTSetting_Prize AS (
		--Jackpot Prize/Promotion Prize/Tournament Prize bettyes
		--AGCasino, Saba Promotion
		SELECT c.custid, c.SportType, c.BetType
		,CASE WHEN sm.SubProduct LIKE '%Contribution%' THEN 100 ELSE 0 END AgentPT
		FROM CTE_Customer c
			OUTER APPLY (SELECT typeid
						 FROM bettype b WITH (NOLOCK)
						 WHERE b.typeid=c.BetType
							AND ( b.typenamee like '%Promotion'
								OR b.typenamee like '%Prize%'
								OR b.typeid=3150 --AE Sexy Lucky Draw
								) --Jackpot Prize/Promotion Prize/Tournament Prize bettyes
						 ) b
			OUTER APPLY (SELECT sm.ProductID, sm.SubProduct
						 FROM SportBettypeMatrix sm WITH (NOLOCK)
						 WHERE sm.SportType=c.SportType
							AND sm.BetType=c.BetType
							AND sm.ProductID IN (11,37) -- Saba Promotion, AGCasino
						 ) sm
		WHERE sm.ProductID IS NOT NULL	
			OR b.typeid IS NOT NULL	
	UNION -- Contribution bettypes
		SELECT c.custid, c.SportType, c.BetType, 100 AS AgentPT
		FROM CTE_Customer c
		CROSS APPLY (SELECT typeid
						 FROM bettype b WITH (NOLOCK)
						 WHERE b.typeid=c.BetType
							AND ( b.typenamee like '%Contribution%')
						 ) b
	)
	,CTE_CustPTSetting_Exchange AS (--Exchange PT
		SELECT c.custid, c.SportType, c.BetType, ex.AgentPT
		FROM CTE_Customer c
			INNER JOIN custInfo ci WITH (NOLOCK) ON ci.custid=c.CustID
			CROSS APPLY (SELECT 1 AS Val 
						 FROM SportBettypeMatrix sm WITH (NOLOCK)
						 WHERE sm.SportType=c.SportType
							AND sm.BetType=sm.BetType
							AND sm.ProductID IN (31)) sm 
			OUTER APPLY (SELECT PT AS AgentPT
						 FROM Dep_ChargeInfoSetting ex WITH (NOLOCK)
						 WHERE ex.custid=ci.srecommend
							AND CAST(GETDATE() AS DATE) BETWEEN ex.FromDate AND ex.ToDate) ex
	)
	,CTE_CustPTSetting_NonGroup AS (
		SELECT c.custid, c.SportType, c.BetType, dcs.AgentPT
		FROM CTE_Customer c
		INNER JOIN CTE_CustRefPTSetting a 
				ON a.custid=c.custid
				AND a.SportType=c.SportType
				AND a.BetType=c.BetType
		INNER JOIN Dep_CustPTSetting_Member dcs WITH (NOLOCK)
				ON c.CustID=dcs.CustID	
				AND a.SportTypeRefPT=dcs.SportType
				AND a.BetTypeRefPT=dcs.BetType
				AND a.isLive=dcs.IsLive
		LEFT JOIN CTE_CustPTSetting_Exchange ex 
				ON ex.custid=c.custid
				AND ex.SportType=c.SportType
				AND ex.BetType=c.BetType
		LEFT JOIN CTE_CustPTSetting_Prize pr 
				ON pr.custid=c.custid
				AND pr.SportType=c.SportType
				AND pr.BetType=c.BetType
		WHERE c.isGroupedPT=0 AND ex.CustID IS NULL AND pr.CustID IS NULL
	)
	,CTE_CustPTSetting_Group AS (--isGroupedPT=1
		SELECT c.custid, c.SportType, c.BetType, dcs.AgentPT
		FROM CTE_Customer c
		INNER JOIN CTE_CustRefPTSetting a 
				ON a.custid=c.custid
				AND a.SportType=c.SportType
				AND a.BetType=c.BetType
		INNER JOIN Dep_CustPTGroupSetting_Member dcs WITH (NOLOCK)
				ON c.recommend=dcs.AgentID	
				AND a.SportTypeRefPT=dcs.SportType
				AND a.BetTypeRefPT=dcs.BetType
				AND a.isLive=dcs.IsLive
		LEFT JOIN CTE_CustPTSetting_Exchange ex 
				ON ex.custid=c.custid
				AND ex.SportType=c.SportType
				AND ex.BetType=c.BetType
		LEFT JOIN CTE_CustPTSetting_Prize pr 
				ON pr.custid=c.custid
				AND pr.SportType=c.SportType
				AND pr.BetType=c.BetType
		WHERE c.isGroupedPT=1 AND ex.CustID IS NULL AND pr.CustID IS NULL
	)
	,CTE_CustPTSetting_All AS (
		SELECT pr.CustID, pr.Sporttype, pr.Bettype, pr.AgentPT
		FROM CTE_CustPTSetting_Prize pr
		UNION
		SELECT ex.CustID, ex.Sporttype, ex.Bettype, ex.AgentPT
		FROM CTE_CustPTSetting_Exchange ex
		UNION
		SELECT g.CustID, g.Sporttype, g.Bettype, g.AgentPT
		FROM CTE_CustPTSetting_Group g
		UNION
		SELECT ng.CustID, ng.Sporttype, ng.Bettype, ng.AgentPT
		FROM CTE_CustPTSetting_NonGroup ng
	)
	SELECT c.custid, c.SportType, c.BetType, cs.AgentPT
	FROM CTE_Customer c
	LEFT JOIN CTE_CustPTSetting_All cs 
		ON cs.custid=c.custid
		AND cs.SportType=c.SportType
		AND cs.BetType=c.BetType
;