/*<info serverAlias="DBCUST-CUSTDB" executers="bodbAdminNet,wsv_lap" viewers="" isFunction="0"></info>*/
ALTER PROCEDURE [dbo].[Acc_Dep_CustomerSelInfo] 
	@Custid INT
AS
/*
Created: 20150609@David
TASk : 
DB: DBCust.CustDB

Revisions:
  - 20150609@David: Separate CustDB to DBCUST server (Use temp table for sports, bettype, GameType table, call some SPs by link server)
  - 20151028@Jim:Implement Muay's Setting for Deposit Customer [Redmine: #45491]
  - 20190906@Eden: 3rd party products - Remove InActive Products Phase 2 [Redmine: #118699]
*/

BEGIN	
	SET NOCOUNT ON;
	----- David @ 09 JUN 2015 -------------------
	DECLARE @tmp_GameType TABLE (GameTypeID INT, GameTypeName NVARCHAR(50), IsDisabled BIT, IBCBettypeID INT)

	BEGIN TRY		
		INSERT INTO @tmp_GameType (GameTypeID, GameTypeName, IsDisabled, IBCBettypeID)
		SELECT GameTypeID, GameTypeName, IsDisabled, IBCBettypeID FROM DBAGE.bodb02.dbo.GameType WITH (NOLOCK)
	END TRY
	BEGIN CATCH		
		INSERT INTO @tmp_GameType (GameTypeID, GameTypeName, IsDisabled, IBCBettypeID)
		SELECT GameTypeID, GameTypeName, IsDisabled, IBCBettypeID FROM DBTXN.bodb02.dbo.GameType WITH (NOLOCK)
	END CATCH
----- /David @ 09 JUN 2015 -------------------
	--Sport book
	SELECT dc.custid,dc.sporttype,dc.bettype,dc.islive, 
	   dc.minbet,dc.maxbet,CASE dc.sporttype 
	   WHEN 1 THEN CASE WHEN bettype = 9 THEN ci.maxpermatch1MP ELSE ci.maxpermatch END 
	   WHEN 2 THEN  ci.maxpermatch2
	   WHEN 3 THEN  ci.maxpermatch3
	   WHEN 5 THEN  ci.maxpermatch5
	   WHEN 8 THEN  ci.maxpermatch8
	   WHEN 10 THEN  ci.maxpermatch10
	   WHEN 11 THEN  ci.maxpermatch11
	   WHEN 99 THEN  CASE WHEN dc.bettype =9 THEN ci.maxpermatch99MP 
							ELSE ci.maxpermatch99
					 END 
	   WHEN 161 THEN  ci.maxpermatch161
		END MPM
	    ,ci.MaxPerBall161, dc.spositiontaking,dc.mpositiontaking,dc.apositiontaking
		,0,0,0
	FROM Dep_CustSetting dc WITH (NOLOCK) LEFT JOIN custInfo ci WITH (NOLOCK) ON dc.custid=ci.custid
	WHERE dc.custid=@custid	
	UNION ALL -- Racing VirtualSport
	SELECT dc3.custid,dc3.sporttype,dc3.bettype,dc3.islive,dc3.minbet,dc3.maxbet,
		CASE dc3.sporttype 
	   WHEN 161 THEN ci.maxpermatch161
	   END MPM,
	ci.MaxPerBall161,dc3.spositiontaking,dc3.mpositiontaking,dc3.apositiontaking
	,dc3.sdiscount SupRBDiscount,dc3.adiscount MasRBDiscount,dc3.discount AgRBDiscount
	FROM Dep_CustSetting3rd dc3 WITH (NOLOCK) LEFT JOIN	custInfo ci WITH (NOLOCK) ON dc3.custid=ci.custid 
	WHERE dc3.custid=@custID AND dc3.bettype NOT IN (32,42,52)
	UNION ALL -- Keno
	select a.CustID,a.Sporttype,
	KT.IBCBetTypeID,
	0 islive,b.MinBet,b.MaxBet,b.MaxPerGameType,0 MPB,a.spositiontaking,a.mpositiontaking,a.apositiontaking
	,0,0,0
	FROM CustSettingGame a WITH (NOLOCK)LEFT JOIN	CustGameType b WITH (NOLOCK) ON a.custid=b.custid 
	INNER JOIN @tmp_GameType KT ON b.GameTypeID = kt.GameTypeID
	WHERE a.custid=@custID 
	and a.Sporttype=202
	ORDER by sporttype	
END
GO