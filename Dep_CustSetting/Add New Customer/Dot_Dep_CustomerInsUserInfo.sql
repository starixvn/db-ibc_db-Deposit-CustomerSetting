/*<info serverAlias="DBCUST-CUSTDB" executers="Dot_Member" viewers="" isFunction="0"></info>*/

ALTER PROCEDURE [dbo].[Dot_Dep_CustomerInsUserInfo]
	@custid INT OUTPUT,
	@firstname NVARCHAR(50),
	@lastname NVARCHAR(50),
	@creator INT,
	@username VARCHAR(30),
	@userpwd VARCHAR(40),
	@pwdexpiry DATETIME,
	@currency INT,
	@site NVARCHAR(50),
	@ugroup VARCHAR(5) = NULL,

	@srecommend INT,
	@mrecommend INT,
	@recommend INT,
	@roleid INT,
		
	@country NVARCHAR(50),
	@suspended BIT = NULL,

	@matchlimit SMALLMONEY,
	@virtualmultiplier SMALLMONEY,
	
	@MaxPerMatch MONEY,
	@MaxPerMatchv2 MONEY,
	@MaxPerMatchv3 MONEY,
	@MaxPerMatchv5 MONEY,
	@MaxPerMatchv8 MONEY,
	@MaxPerMatchv10 MONEY,
	@MaxPerMatchv11 MONEY,
	@MaxPerMatchv99 MONEY,
	@MaxPerMatchv1MP MONEY =0,
	@MaxPerMatchv99MP MONEY,		
	@MaxPerMatchv161 MONEY,	
	@MaxPerBallv161 MONEY = 0,	
	
	@DisableNumber BIT = 0,
	@HideKeno BIT = 0,		
	
	@IP VARCHAR(15)='',
	@Language VARCHAR(2)= 'E',
	@ErrCode INT = 0 OUTPUT,
	@ErrMsg NVARCHAR(4000) = '' OUTPUT
AS
/*
	Created: 20190919@Elodie
	Task : Insert general customer's Information in 1st deposit SP process
	DB: DBCUST/CustDB
	Original: Acc_CustomerInsUserInfo

	Revisions:
		- 20190919@Elodie: Initial SP [Redmine: #118699]
		- 20191211@Johnson: Apply Default VR setting for IBO new members [redmine:#125285]
		- 20200624@Johnson: add Soccer Parlay bet limit [redmine: #135261]
	Param's Explanation:
		• @ErrCode:
			= 0: Insert successfully.
			> 0: Specific Error.
  
		• @ErrMsg: Error description.
*/
BEGIN
    SET NOCOUNT ON 
	
    INSERT INTO Customer   			
	(username, firstname, lastname, phone, mobilephone, fax, email, address,
	city, state, country, postal, userpwd, roleid, srecommend, mrecommend, recommend, 
	currency, pwdexpiry, creator, Site, creatdate, ugroup
	) 
 	VALUES (@username, @firstname, @lastname, '', '', '', '', '', 
	'', '', @country, '', @userpwd, @roleid, @srecommend, @mrecommend, @recommend, 
	@currency, @pwdexpiry, @creator, @site, GETDATE(), @ugroup
	)
    
	SELECT @custid=@@IDENTITY
	
    IF @@ERROR <> 0
    BEGIN
	    SELECT @ErrMsg = CASE @Language 
							    WHEN 'E' THEN 'Create customer failed. Please try again.'
							    ELSE [dbo].[f_Get_MsgNamebyMsgID](40004, @Language)
						    END,
		    @ErrCode = 111
    		
	    -- ROLLBACK MANUALLY
	    DELETE FROM Customer WITH (ROWLOCK) WHERE custId = @CustID
    		
	    RETURN
    END
	
	INSERT INTO [dbo].[CustVirtualSetting] (custid, seqNo, bitmapVirtual)
	SELECT @Custid, seqNo, bitmapVirtual
	FROM CustVirtualSetting WITH(NOLOCK)
	WHERE custid = @recommend  

    IF @@ERROR <> 0
    BEGIN
	    SELECT @ErrMsg = CASE @Language 
					       WHEN 'E' THEN 'Create customer failed. Please try again.'
					       ELSE [dbo].[f_Get_MsgNamebyMsgID](40004,@Language)
					     END
		     , @ErrCode = 112

	    -- ROLLBACK MANUALLY
	    DELETE FROM Customer WITH(ROWLOCK) WHERE custId = @CustID
		DELETE FROM CustVirtualSetting WITH(ROWLOCK) WHERE custid = @CustID
	    RETURN
    END	
	
	DECLARE @licensee NVARCHAR(50)
	
	SELECT @licensee = site
	FROM customer WITH(NOLOCK)
	WHERE custid = @recommend
	
	--20191211@Johnson
	--re-set  virtual rate for all sports except soccer to -50 for IBO 
	IF @licensee = 'IBO'
	BEGIN
		DECLARE	@tblVirtualrate		TABLE (
									SportType			INT
								,	BetType				INT
								,	IsLive				BIT
								,	VirtualMultiplier	SMALLMONEY	
								);
										
		INSERT INTO	@tblVirtualrate (
								SportType
							,	BetType
							,	IsLive
							,	VirtualMultiplier
						)
		SELECT	sporttype,bettype,islive,0.5
		from ProfileVirtualSetting 		
		WHERE sporttype <> 1

		DECLARE	@virtualXML			TABLE (
											seqNo		TINYINT PRIMARY KEY
										,	Pos			VARBINARY(64)
										,	Val			VARBINARY(64)
										);
										
		INSERT INTO @virtualXML
					(	seqNo, Pos, Val                       )
				SELECT	seqNo, p1.Pos, p2.Val
				FROM (
					SELECT	DISTINCT seqNo
					FROM	ProfileVirtualSetting WITH (NOLOCK)
				) pvs
				CROSS APPLY (
					SELECT CONVERT(VARBINARY(64), (
						SELECT	CONVERT(VARCHAR, CAST(ipvs.profileID - 64 * (ipvs.seqNo - 1) AS BINARY(1)), 2)
						FROM		@tblVirtualrate			AS tmp
							INNER JOIN	ProfileVirtualSetting	AS ipvs WITH (NOLOCK)
								ON	tmp.sporttype	= ipvs.sporttype
									AND	tmp.bettype		= ipvs.bettype
									AND	tmp.isLive		= ipvs.islive
						WHERE	ipvs.seqNo = pvs.seqNo
						FOR XML PATH ('')						
					), 2) AS Pos
				) p1
				CROSS APPLY (
					SELECT CONVERT(VARBINARY(64), (
						SELECT	CONVERT(VARCHAR, CAST(CASE WHEN CAST(VirtualMultiplier * 100 AS INT) > 200 THEN ((CAST(VirtualMultiplier * 100 AS INT) - 200) / 5 + 200) ELSE CAST(VirtualMultiplier * 100 AS INT) END AS BINARY(1)), 2)
						FROM		@tblVirtualrate			AS tmp
							INNER JOIN	ProfileVirtualSetting	AS ipvs WITH (NOLOCK)
								ON	tmp.sporttype	= ipvs.sporttype
									AND	tmp.bettype		= ipvs.bettype
									AND	tmp.isLive		= ipvs.islive
						WHERE	ipvs.seqNo = pvs.seqNo
						FOR XML PATH ('')						
					), 2) AS Val
				) p2;

		UPDATE cvs
			SET cvs.bitmapVirtual = bm.bitmap
		FROM		CustVirtualSetting	AS cvs WITH(UPDLOCK, ROWLOCK)			
			INNER JOIN	@virtualXML			AS tmp
					ON	cvs.seqNo = tmp.seqNo
			CROSS APPLY (SELECT TOP 1 bitmap FROM dbo.f_GenerateVirtualSetting_inline(cvs.bitmapVirtual, tmp.Val, tmp.Pos)) AS bm
		WHERE	cvs.custid = @custid
		
		IF @@ERROR <> 0
		BEGIN
			SELECT @ErrMsg = CASE @Language 
							   WHEN 'E' THEN 'Create customer failed. Please try again.'
							   ELSE [dbo].[f_Get_MsgNamebyMsgID](40004,@Language)
							 END
				 , @ErrCode = 112

			-- ROLLBACK MANUALLY
			DELETE FROM Customer WITH(ROWLOCK) WHERE custId = @CustID
			DELETE FROM CustVirtualSetting WITH(ROWLOCK) WHERE custid = @CustID
			RETURN
		END	
	END	
	
	INSERT INTO [dbo].[custinfo]
    (
	    custid, currency
	  , maxpermatch, maxpermatch2, maxpermatch3, maxpermatch5, maxpermatch8, maxpermatch10, maxpermatch11
	  , maxpermatch99
	  , roleid, srecommend, mrecommend, recommend, dangercust, autosuspend, autosuspend2, reject, credit, closed, username
	  , MatchLimit, VirtualMultiplier
	  , DisableOutright, DisableCasino, DisableNumber, maxpermatch161, MaxPerMatch99MP, MaxPerBall161
	  , danger, danger2, danger3, Abnormal, DoubleCommLosing
	  , HideKeno, DisableEsports, DisableGoldDeluxe, HideGoldDeluxe, DisableSuperLive,DisableColossusBet,HideColossusBet
	  , MaxPerMatch1MP,maxpermatch164)
    VALUES
    (
	    @custid, @currency
	  , @MaxPerMatch, @MaxPerMatchv2, @MaxPerMatchv3, @MaxPerMatchv5, @MaxPerMatchv8, @MaxPerMatchv10, @MaxPerMatchv11
	  , @MaxPerMatchv99
	  , @roleid, @srecommend, @mrecommend, @recommend, 0, 0, 0, ISNULL(@suspended, 0), 0, 0, @username
	  , @matchlimit, @virtualmultiplier
	  , 0, 0, @DisableNumber,  @MaxPerMatchv161, @MaxPerMatchv99MP, @MaxPerBallv161
	  , 0, 0, 0, 0, 0	
	  , @HideKeno, 0, 0, 0, 0,1,1
	  , @MaxPerMatchv1MP, 0
    )
	
    IF @@ERROR <> 0
    BEGIN 
	    SELECT @ErrMsg = CASE @Language
					       WHEN 'E' THEN 'Create customer failed. Please try again.'
					       ELSE [dbo].[f_Get_MsgNamebyMsgID](40004,@Language)
					     END,
		       @ErrCode = 113

	    -- ROLLBACK MANUALLY
	    DELETE FROM Customer WITH(ROWLOCK) WHERE custId = @CustID
		DELETE FROM CustVirtualSetting WITH(ROWLOCK) WHERE custid = @CustID	
		DELETE FROM custinfo WITH(ROWLOCK) WHERE custId = @CustID
	    RETURN
    END  

	IF NOT EXISTS (SELECT 1 FROM dbo.CustLoginInfo_Member WITH(NOLOCK) WHERE custid = @custid)
	BEGIN
		INSERT INTO CustLoginInfo_Member([CustID],[SecurityCode],[IP],[LastChangedID],[LastChangedDate],ClosedReason)
		VALUES(@custid,NULL,@IP,@creator,GETDATE(),0)

		IF @@ERROR <> 0
		BEGIN
			SELECT	@ErrMsg = CASE @Language
									WHEN 'E' THEN 'Create customer failed. Please try again.'
									ELSE [dbo].[f_Get_MsgNamebyMsgID](40004,@Language)
								END
					,@ErrCode = 114

			DELETE FROM Customer WITH(ROWLOCK) WHERE custId = @CustID
			DELETE FROM CustVirtualSetting WITH(ROWLOCK) WHERE custid = @CustID
			DELETE FROM custinfo WITH(ROWLOCK) WHERE custId = @CustID
			RETURN
		END
	END
END
GO
