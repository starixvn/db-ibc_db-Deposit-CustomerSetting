/*
	Created: 20170608@Helen
	Task: Betradar Virtual Sports  -Integration for Cash
	DB:DBCUST/CUSTDB

	VR: cs.sporttype = 180 AND cs.bettype = 1201 -- Virtual Soccer
		  SELECT 181 as sporttype, 1231 as bettype
	UNION SELECT 182, 1231
	UNION SELECT 183, 1231
	UNION SELECT 184, 1231
	UNION SELECT 185, 1231
	UNION SELECT 186, 1220

	-- max per match
	UPDATE CustInfo WITH(UPDLOCK,ROWLOCK)
		SET maxpermatch181 = maxpermatch180, 
			maxpermatch182 = maxpermatch180, 
			maxpermatch183 = maxpermatch180, 
			maxpermatch184 = maxpermatch180, 
			maxpermatch185 = maxpermatch180,
			maxpermatch186 = maxpermatch180
		WHERE srecommend = @srecommend
			AND custid <= @maxcustid

	PT & Bet Setting
	Dep_CustSetting3rd
	INSERT INTO [dbo].[Dep_CustSetting3rd]([custid],[bettype] ,[sporttype],[islive],[apositiontaking] ,[mpositiontaking] ,[spositiontaking],[playerdiscount],[discount],[adiscount],[sdiscount],[minbet],[maxbet])

	CustInfo.DisableVirtualSports	CustInfo.HideVirtualSports
		
*/
USE CustDB
GO

INSERT INTO [dbo].[Dep_ProductSetting] (ProductSettingID,ProductID,SettingType,TemplateID,DisplayOrder,SettingLevel)
VALUES 
	-- Virtual Sports
	--Status
	(9,5,4,0,1,1)
	-- PT
	,(10,5,1,0,2,1)
	-- 2: Bet Setting
	,(11,5,2,0,3,2)
	
	-- BetRadar VS
	--Status
	--,(12,27,4,0,1,1)
	-- PT
	,(13,27,1,0,2,1)
	-- 2: Bet Setting
	,(14,27,2,0,3,2)
	
GO
INSERT INTO [dbo].[Dep_ProductSettingDetail] (ProductSettingID,SportType,BetType,IsLive,MaxDefaultValue,SettingStatus)
VALUES 
	-- Virtual Sports
	(9,180,1201,0,0,1)
	,(10,180,1201,0,0,1)
	-- Bet Setting
	/*
		180	1201
		181	1231
		182	1231
		183	1231
		184	1231
		185	1231
		186	1220
	*/	
	,(11,180,1201,0,0,1)
	,(11,181,1231,0,0,1)
	,(11,182,1231,0,0,1)
	,(11,183,1231,0,0,1)
	,(11,184,1231,0,0,1)
	,(11,185,1231,0,0,1)
	,(11,186,1220,0,0,1)
	
	-- Betradar VS
	-- Virtual Sports
	-- Status
	--,(12,190,2701,0,0,1)
	-- PT	
	,(13,190,2701,0,0,1)
	-- Bet Setting
	,(14,190,2701,0,0,1)
	,(14,191,2701,0,0,1)
	,(14,199,2799,0,0,1) -- 199 Virtual Sports Parlay dummy sport for bet setting
	
GO

INSERT INTO [dbo].Dep_ProductStatusProfile (Sporttype,Bettype,bitmapOrder)
VALUES (180,1201,4) -- Virtual Sports
		,(190,2701,4) -- Betradar VS
GO

