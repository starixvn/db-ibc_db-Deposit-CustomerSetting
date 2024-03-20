/*<info serverAlias="DBCUST-CUSTDB" executers="Dot_Admin,Dot_Member,svc_tig" viewers="" isFunction="0"></info>*/
ALTER PROCEDURE [dbo].[Dot_Dep_CustomerUpdMemBetSettingGame_DCS]  
	@CustID INT, --MemberID  
	@Sporttype SMALLINT,
	@Bettype SMALLINT,

	@MinBet MONEY = NULL,  
	@MaxBet MONEY = NULL,  
	@MaxPerMatch MONEY = NULL,  
	@MaxPerNumber MONEY = NULL,
	@MaxPayoutPerMatch MONEY = NULL,
   
	@UserID INT, --updater ID  
	@Language VARCHAR(2) = 'E',  
	@IP VARCHAR(15)= '',   
	@ErrCode INT = 0 OUTPUT,  
	@ErrMsg NVARCHAR(4000) = '' OUTPUT  
AS  
/*  
	Created: 20220415@Eden
	Task : Update member min max bet - use for SB/NG 
	DB: DBCUST/CustDB  
	User: API Licensee  
  
	Revisions:  
		- 20220415@Eden: Deposit - Sportsbook - Revise customer settings [Redmine: #167898]
		- 20240318@Johnson: Write log by service broker [redmine: #199517]
	Param's Explanation:  

	Excution sample: 
	DECLARE @ErrCode INT, @ErrMsg NVARCHAR(4000)
	EXEC Dot_Dep_CustomerUpdMemBetSettingGame_DCS 
		@CustID = 60902493, @Sporttype = 1, @Bettype = 1
		, @MinBet = 10, @MaxBet = 100, @MaxPerMatch = 1000
		, @UserID = 9, @ErrCode = @ErrCode OUTPUT, @ErrMsg = @ErrMsg OUTPUT
	SELECT @ErrCode,@ErrMsg
*/  
BEGIN  
	SET NOCOUNT ON  
  
	DECLARE @startRun DATETIME, @endRun DATETIME, @duration INT  	
	DECLARE @MinMinBet MONEY, @MaxMaxBet MONEY, @MaxMaxPerMatch MONEY, @MaxMaxPerNumber MONEY, @MaxMaxPayoutPerMatch MONEY
		, @Old_MinBet MONEY, @Old_MaxBet MONEY, @Old_MaxPerMatch MONEY , @Old_MaxPerNumber MONEY, @Old_MaxPayoutPerMatch MONEY   
	DECLARE @ErrAcc VARCHAR(4000), @ErrType VARCHAR(4000), @UserName VARCHAR(30), @UplineClosed BIT  
	DECLARE @LogSPData VARCHAR(5000), @TrackingValue2 VARCHAR(5000) 
	DECLARE @RoleID TINYINT, @recommend INT, @mrecommend INT, @srecommend INT, @IsGroupedBetLimit BIT, @Settingtype TINYINT

	SET @startRun = GETDATE()    

	SELECT @RoleID = ci.roleid, 
		@UserName = username,
		@recommend = ci.recommend,
		@mrecommend = ci.mrecommend,
		@srecommend = ci.srecommend
	FROM dbo.custInfo ci WITH (NOLOCK) 
	WHERE custid = @CustID

	IF ISNULL(@roleid,0) <> 1  
	BEGIN  
		 SELECT @ErrMsg = CASE @Language WHEN 'E' THEN 'Invalid user!!' ELSE [dbo].[f_Get_MsgNamebyMsgID](40002,@Language) END,  
				@ErrCode = 100   
		 RETURN  
	END  

	SELECT @IsGroupedBetLimit = IsGroupedBetLimit FROM Dep_CustSettingMode WITH(NOLOCK) WHERE CustID = @CustID

	IF @IsGroupedBetLimit = 1
	BEGIN
		SELECT     
			@Old_MinBet = ISNULL(MinBet ,0),  
			@Old_MaxBet = ISNULL(MaxBet ,0),
			@Old_MaxPerMatch = ISNULL(MaxPerMatch,0),
			@Old_MaxPerNumber = ISNULL(MaxPerNumber,0),
			@Old_MaxPayoutPerMatch = ISNULL(MaxPayoutPerMatch,0)
		FROM       
			dbo.Dep_CustBetSettingGameGroup_Member WITH (NOLOCK)      
		WHERE AgentID = @recommend and bettype = @Bettype and sporttype = @Sporttype
	END
	ELSE
	BEGIN
		SELECT       
			@Old_MinBet = ISNULL(MinBet ,0),  
			@Old_MaxBet = ISNULL(MaxBet ,0),
			@Old_MaxPerMatch = ISNULL(MaxPerMatch,0),
			@Old_MaxPerNumber = ISNULL(MaxPerNumber,0),
			@Old_MaxPayoutPerMatch = ISNULL(MaxPayoutPerMatch,0)
		FROM       
			dbo.Dep_CustBetSettingGame_Member WITH (NOLOCK)      
		WHERE custid = @CustID and bettype = @Bettype and sporttype = @Sporttype
	END
     
	IF  @Old_MinBet = @MinBet AND @Old_MaxBet = @MaxBet AND @Old_MaxPerMatch = @MaxPerMatch 
			AND ISNULL(@Old_MaxPerNumber,0) = ISNULL(@MaxPerNumber,0) AND ISNULL(@Old_MaxPayoutPerMatch,0) = ISNULL(@MaxPayoutPerMatch,0)
		RETURN  --value unchange	

	--no need to check for deposit
	--SELECT @UplineClosed = ISNULL(closed,0)  
	--FROM custinfo (NOLOCK)   
	--WHERE custid = @UserID 

	--IF @UplineClosed = 1   
	--BEGIN  
	--	 SELECT @ErrMsg =  CASE @Language WHEN 'E' THEN 'Your account was closed. Cannot edit member.'  
	--									  WHEN 'CS' THEN N'您的账号已关闭，无法更改会员.'  
	--									  WHEN 'CT' THEN N'您的帳戶已關閉. 無法更改會員.'  
	--									  WHEN 'TH' THEN N'บัญชีของคุณถูกระงับใช้ ไม่สามารถแก้ไข.'  
	--									  WHEN 'J' THEN N'貴方のアカウントは閉鎖されています。新規メンバーの受付はできません。'  
	--									  WHEN 'KO' THEN N'계정이용이 정지되었습니다. 회원정보를 수정 할 수 없습니다.'  
	--									  ELSE N'Your account was closed. Cannot edit member.'  
	--						END, 
	--			@ErrCode = 101
	--	 RETURN  
	--END   

	SELECT TOP 1 @Settingtype = dps.SettingType
	FROM dbo.Dep_ProductSetting dps WITH(NOLOCK)
		INNER JOIN Dep_ProductSettingDetail dpsd  WITH(NOLOCK) ON dps.ProductSettingID = dpsd.ProductSettingID
	WHERE 	dpsd.SportType = @Sporttype AND dpsd.BetType = @Bettype AND dps.SettingType IN (10,12)	
  
	IF @Settingtype = 10 -- not use MaxPerNumber column
	BEGIN
		SELECT @Old_MaxPerNumber = NULL, @MaxPerNumber = NULL
	END
	ELSE IF @Settingtype = 12 -- not use MaxPayoutPerMatch column
	BEGIN
		SELECT @Old_MaxPayoutPerMatch = NULL, @MaxPayoutPerMatch = NULL
	END	

	SELECT   @MinMinBet = MAX(CASE WHEN MinBet = 0 THEN NULL ELSE MinBet END),   
			 @MaxMaxBet = MIN(CASE WHEN MaxBet = 0 THEN NULL ELSE MaxBet END),
			 @MaxMaxperMatch = MIN(CASE WHEN cs.MaxPerMatch = 0 THEN NULL ELSE cs.MaxPerMatch END),
			 @MaxMaxPerNumber = MIN(CASE WHEN cs.MaxPerNumber = 0 THEN NULL ELSE cs.MaxPerNumber END),
			 @MaxMaxPayoutperMatch = MIN(CASE WHEN cs.MaxPayoutPerMatch = 0 THEN NULL ELSE cs.MaxPayoutPerMatch END)
	FROM   dbo.Dep_CustBetSettingGame_Agent AS cs WITH (NOLOCK)  
	WHERE cs.sporttype = @Sporttype 
		AND cs.bettype = @Bettype  
		AND cs.custid IN (@recommend,@mrecommend,@srecommend)

	----------------------------------------------  
	--Update MinBet, MaxBet, MaxPerMatch  
	----------------------------------------------  
	--Check Param  
	IF @MinBet<0 OR @MaxBet < 0 OR @MaxPerMatch <0    
	BEGIN  
		SELECT @ErrCode = 102  
		SELECT @ErrMsg = CASE @Language WHEN 'E' THEN 'Wrong Min bet/ Max bet/ Max per match.'  
										WHEN 'CS' THEN N'最低投注/最高投注/单场最高投注不正确.'  
										WHEN 'CT' THEN N'最低投注/最高投注/單場最高投注不正確.'  
										WHEN 'TH' THEN N'การกำหนดจำนวนเงินสำหรับการวางเดิมพันต่ำสุด/ สูงสุด/สูงสดต่อรายการไม่ถูกต้อง.'  
										WHEN 'J' THEN N'Wrong Min bet/ Max bet/ Max per match.'  
										WHEN 'KO' THEN N'잘못된 최소 배팅/최대 배팅/경기당 최대.'  
										ELSE N'Wrong Min bet/ Max bet/ Max per match.'  
						END  
		RETURN  
	END   
   
	IF ((@MinBet<>0 OR @MaxBet<>0 OR @MaxPerMatch<>0) AND (@MinBet > @MaxBet OR @MaxBet > @MaxPerMatch))  
	BEGIN  
		SELECT @ErrMsg = @UserName + ': '+  CASE @Language  WHEN 'E' THEN 'Min bet must be less than max bet and max bet must be less than max bet per match'  
															WHEN 'CS' THEN N'最低投注不能高于最高投注，最高投注不能高于单场最高投注设定'  
															WHEN 'CT' THEN N'最低投注不能高於最高投注,最高投注不能高於單場最高投注設定'  
															WHEN 'TH' THEN N'จำนวนเงินต่ำสุดที่วางเดิมพันได้ต้องน้อยกว่าจำนวนเงินสูงสุดในการวางเดิมพันและจำนวนเงินสูงสุดในการวางเดิมพันต้องน้อยกว่าจำนวนเงินสูงสุดของเงินเดิมพันต่อเกม.'  
															WHEN 'J' THEN N'Min bet must be less than max bet and max bet must be less than max bet per match'  
															WHEN 'KO' THEN N'최소 배팅은 최대 배팅 이하이여야 하고 최대 배팅은 경기당 최대 배팅보다 작아야 합니다.'  
															ELSE N'Min bet must be less than max bet and max bet must be less than max bet per match'  
											END        
						+ CHAR(13) + CHAR(10) + CONVERT(VARCHAR(20), @MinBet) + '-' + CONVERT(VARCHAR(20), @MaxBet) + '-' + CONVERT(VARCHAR(20), @MaxPerMatch), 
				@ErrCode = 103 
		RETURN  
	END  

	------------------Rule for Max Per Ball, Max Payout Per Match----------------
	--Wrong Max Per Ball
	IF @MaxPerNumber<0 
	BEGIN  
		SELECT @ErrCode = 111  
		SELECT @ErrMsg = [dbo].[f_Get_MsgNamebyMsgID](10002,@Language)  
		RETURN  
	END  
	
	--Wrong Max Payout Per Match
	IF @MaxPayoutperMatch<0 
	BEGIN  
		SELECT @ErrCode = 112  
		SELECT @ErrMsg = [dbo].[f_Get_MsgNamebyMsgID](10059,@Language)  
		RETURN  
	END   

	--Max Per Ball must be greater than or equal to Max Bet and less than or equal to Max Per Match
	 IF (       (@MaxPerNumber<>0 OR @MaxBet<>0 OR @MaxPerMatch<>0) 
			AND (@MaxPerNumber < @MaxBet OR @MaxPerNumber > @MaxPerMatch)  
			AND  @Settingtype = 12 
		)
	 BEGIN  
		SELECT @ErrMsg = @UserName + ': '+  [dbo].[f_Get_MsgNamebyMsgID](10061,@Language)       
			+ CHAR(13) + CHAR(10) + CONVERT(VARCHAR(20), @MaxBet) + '-' + CONVERT(VARCHAR(20), @MaxPerMatch) + '-' + CONVERT(VARCHAR(20), @MaxPerNumber)
			, @ErrCode = 113         
		RETURN  
	 END
	 
	 --Max Per Match must be less than or equal to Max Payout Per Match
	 IF (       (@MaxPayoutperMatch<>0 OR @MaxPerMatch<>0) 
			AND (@MaxPayoutperMatch < @MaxPerMatch)  
			AND  @Settingtype = 10
		)
	 BEGIN  
		SELECT @ErrMsg = @UserName + ': '+  [dbo].[f_Get_MsgNamebyMsgID](10060,@Language)       
			+ CHAR(13) + CHAR(10) + CONVERT(VARCHAR(20), @MaxPerMatch) + '-' + CONVERT(VARCHAR(20), @MaxPayoutperMatch)
			, @ErrCode = 114         
		RETURN  
	 END  

	  --Max Per Ball must be less than or equal to Upline's Max Per Ball
	 IF (       (@MaxPerNumber>0 AND @MaxMaxPerNumber>0) 
			AND (@MaxPerNumber > @MaxMaxPerNumber)  
			AND  @Settingtype = 12
		)
	 BEGIN  
		SELECT @ErrMsg = @UserName + ': '+  [dbo].[f_Get_MsgNamebyMsgID](10066,@Language)       
			+'(' + CONVERT(VARCHAR(20), @MaxMaxPerNumber) + ').'
			, @ErrCode = 115        
		RETURN  
	 END

	  --Max Payout Per Match must be less than or equal to Upline's Max Payout Per Match
	 IF (       (@MaxPayoutperMatch > 0 AND  @MaxMaxPayoutperMatch>0) 
			AND (@MaxPayoutperMatch > @MaxMaxPayoutperMatch)  
			AND  @Settingtype = 10
		)
	 BEGIN  
		SELECT @ErrMsg = @UserName + ': '+  [dbo].[f_Get_MsgNamebyMsgID](10065,@Language)       
			+'(' + CONVERT(VARCHAR(20), @MaxMaxPayoutperMatch) + ').'
			, @ErrCode = 116        
		RETURN  
	 END
	--------------------------------------------------------------------------------------------
   
	IF (@MinMinBet > 0 AND @MinBet > 0 AND @MinBet < @MinMinBet)  
	BEGIN  
		SELECT @ErrMsg = @UserName + ': ' + CASE @Language  WHEN 'E' THEN 'Min bet must be equal to or greater than Agent min bet'  
															WHEN 'CS' THEN N'最低投注需相等于或少于代理最低投注'  
															WHEN 'CT' THEN N'最低投注需相等於或少於代理最低投注'  
															WHEN 'TH' THEN N'จำนวนเงินต่ำสุดในการเล่นต้องเท่ากับหรือมากกว่าจำนวนเงินขั้นต่ำในการเล่นที่กำหนดไว้ของตัวแทน'  
															WHEN 'J' THEN N'Min bet must be equal to or greater than Agent min bet'  
															WHEN 'KO' THEN N'최소 배팅은 에이전트의 최소 배팅 이상이여야 합니다.'  
															ELSE N'Min bet must be equal to or greater than Agent min bet'  
											END        
						+' (' + CONVERT(VARCHAR(20), @MinMinBet) + ').', 
				@ErrCode = 104 
		RETURN  
	END  
   
	IF (@MaxMaxBet > 0 AND @MaxBet > 0 AND @MaxBet > @MaxMaxBet)  
	BEGIN  
		SELECT @ErrMsg = @UserName + ': '+  CASE @Language  WHEN 'E' THEN 'Max bet must be equal to or less than Agent max bet'  
															WHEN 'CS' THEN N'最高投注需相等于或少于代理最高投注'  
															WHEN 'CT' THEN N'最高投注需相等於或少於代理最高投注'  
															WHEN 'TH' THEN N'จำนวนการวางเดิมพันสูงสุดต้องเท่ากับ หรือ น้อยกว่าราคาเดิมพันสูงสุดของตัวแทน '  
															WHEN 'J' THEN N'Max bet must be equal to or less than Agent max bet'  
															WHEN 'KO' THEN N'최대 배팅은 에이전트의 최대 배팅 이하이여야 합니다.'  
															ELSE N'Max bet must be equal to or less than Agent max bet'  
											END        
							+'(' + CONVERT(VARCHAR(20), @MaxMaxBet) + ').', 
				@ErrCode = 105  
		RETURN  
	END  
   
	IF (@MaxMaxPerMatch > 0 AND @MaxPerMatch > 0 AND @MaxPerMatch > @MaxMaxPerMatch)  
	BEGIN  
		SELECT @ErrMsg = @UserName + ': '+  CASE @Language  WHEN 'E' THEN 'Max Per Match must be equal to or less than Agent Max Per Match'  
															WHEN 'CS' THEN N'单场最高投注需相等于或少于代理单场最高投注'  
															WHEN 'CT' THEN N'單場最高投注需相等於或少於代理單場最高投注'  
															WHEN 'TH' THEN N'จำนวนเงินสูงสุดในการเล่นต่อรายการต้องเท่ากับหรือน้อยกว่าจำนวนเงินสูงสุดต่อรายการที่กำหนดไว้ของตัวแทน  '  
															WHEN 'J' THEN N'Max Per Match must be equal to or less than Agent Max Per Match'  
															WHEN 'KO' THEN N'최대 경기는 에이전트의 최대 경기보다 작아야 합니다.'  
															ELSE N'Max Per Match must be equal to or less than Agent Max Per Match'  
											END        
						+'(' + CONVERT(VARCHAR(20), @MaxMaxPerMatch) + ').', 
				@ErrCode = 106  
		RETURN  
	END  

	--update new settings
	IF @IsGroupedBetLimit = 0
	BEGIN

		UPDATE dbo.Dep_CustBetSettingGame_Member WITH (ROWLOCK, UPDLOCK)  
		SET MinBet = @MinBet,  
			MaxBet = @MaxBet,
			MaxPerMatch = @MaxPerMatch,
			MaxPerNumber = @MaxPerNumber,
			MaxPayoutPerMatch = @MaxPayoutPerMatch
		WHERE custid = @CustID 
			AND SportType = @Sporttype 
			AND BetType = @Bettype
	END
	ELSE
	IF @IsGroupedBetLimit = 1 --> Break group
	BEGIN
		--insert sporttype bettyp with input param
		INSERT INTO Dep_CustBetSettingGame_Member(CustID,SportType,BetType,MinBet,MaxBet,MaxPerMatch,MaxPerNumber,MaxPayoutPerMatch)
		SELECT @custID,@SportType,@BetType,@MinBet,@MaxBet,@MaxPerMatch,@MaxPerNumber,@MaxPayoutPerMatch
		WHERE NOT EXISTS(	SELECT TOP 1 1 
							FROM Dep_CustBetSettingGame_Member m WITH(NOLOCK) 
							WHERE m.CustID = @CustID AND m.SportType = @SportType AND m.BetType = @BetType)

		--Insert remain setting from group setting
		INSERT INTO Dep_CustBetSettingGame_Member(CustID,SportType,BetType,MinBet,MaxBet,MaxPerMatch,MaxPerNumber,MaxPayoutPerMatch)
		SELECT @custID,gr.SportType,gr.BetType,gr.MinBet,gr.MaxBet,gr.MaxPerMatch,gr.MaxPerNumber,gr.MaxPayoutPerMatch
		FROM Dep_CustBetSettingGameGroup_Member gr WITH(NOLOCK)
			LEFT JOIN Dep_CustBetSettingGame_Member m WITH(NOLOCK) ON m.CustID = @CustID AND gr.SportType = m.SportType AND gr.BetType = m.BetType
		WHERE m.CustID IS NULL
			AND gr.AgentID = @recommend

		UPDATE Dep_CustSettingMode WITH(ROWLOCK,UPDLOCK) 
		SET IsGroupedBetLimit = 0  
		WHERE custid = @CustID
			AND IsGroupedBetLimit = 1
	END	
  
	SELECT @LogSPData =	'<R Sport="'+ COALESCE(CAST(@SportType AS VARCHAR(50)),SPACE(1)) + '" ' +  
						'BT="'+ COALESCE(CAST(@Bettype AS VARCHAR(50)),SPACE(1)) + '" ' +  	
						'Min="'+ COALESCE(CAST(@minbet AS VARCHAR(50)),SPACE(1)) + '" ' +  
						'Max="'+ COALESCE(CAST(@maxbet AS VARCHAR(50)),SPACE(1)) + '" ' +  
						'MPM="'+ COALESCE(CAST(@maxpermatch AS VARCHAR(50)),SPACE(1)) + '" ' 
						----------
						+ CASE WHEN @settingtype = 12 THEN 'MPB="'+ COALESCE(CAST(@MaxPerNumber AS VARCHAR(50)),SPACE(1)) + '" ' ELSE '' END
						+ CASE WHEN @settingtype = 10 THEN 'MPPM="'+ COALESCE(CAST(@MaxPayoutperMatch AS VARCHAR(50)),SPACE(1)) + '" ' ELSE '' END
						----------
						+ '/>'  
  
	SELECT @TrackingValue2 ='<R Sport="'+ COALESCE(CAST(@SportType AS VARCHAR(50)),SPACE(1)) + '" ' +  
							'BT="'+ COALESCE(CAST(@Bettype AS VARCHAR(50)),SPACE(1)) + '" ' +  	
							'Min="'+ COALESCE(CAST(@Old_minbet AS VARCHAR(50)),SPACE(1)) + '" ' +  
							'Max="'+ COALESCE(CAST(@Old_maxbet AS VARCHAR(50)),SPACE(1)) + '" ' +  
							'MPM="'+ COALESCE(CAST(@Old_maxpermatch AS VARCHAR(50)),SPACE(1)) + '" '
							----------
							+ CASE WHEN @settingtype = 12 THEN 'MPB="'+ COALESCE(CAST(@Old_MaxPerNumber AS VARCHAR(50)),SPACE(1)) + '" ' ELSE '' END
							+ CASE WHEN @settingtype = 10 THEN 'MPPM="'+ COALESCE(CAST(@Old_MaxPayoutperMatch AS VARCHAR(50)),SPACE(1)) + '" ' ELSE '' END
							----------
							+ '/>'  
	
	
	SET @endRun = getdate()  
	SET @duration  = datediff (millisecond,@startRun,@endRun)  
	
	---------- write log for servicebroker
	DECLARE @log xml, @SB_Error BIT = 0
	SELECT @log = (SELECT @UserID as '@UserID',  
					@CustID as '@CustID',  
					393 as '@ActionID',  
					@duration as '@Duration',
					@Language as '@Language',
					@Ip as '@IP',
					@LogSPData as '@TrackingValue',
					@TrackingValue2 as '@TrackingValue2'
				FOR XML PATH('Row')	
				)
				
	EXEC bodb_CustomerLog.sb.CustomerLog_SendMessage @xml = @log, 
													@MessageType='MessageType_CustomerLog_UserLog_DepCustSetting', 
													@functionName = 'UserLog_Others',
													@SB_Error = @SB_Error OUT


	--SELECT @SB_Error
	IF @SB_Error = 1
	BEGIN			
		EXEC DBLOG.bodb_CustomerLog.dbo.WriteLog_UserLog_Dep_CustSetting
				@UserID = @UserID,  
				@CustID = @CustID,  
				@ActionID = 393,  
				@TrackingValue = @LogSPData,  
				@TrackingValue2 = @TrackingValue2,  
				@duration = @duration,
				@Language = @Language,
				@Ip = @IP
	END	
END 
GO 

