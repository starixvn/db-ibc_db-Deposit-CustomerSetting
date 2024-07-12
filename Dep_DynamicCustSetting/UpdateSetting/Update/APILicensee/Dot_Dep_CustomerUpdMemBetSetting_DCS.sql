/*<info serverAlias="DBCUST-CUSTDB" executers="Dot_Admin,svc_tig,svc_tig" viewers="vnteam" isFunction="0"></info>*/
ALTER PROCEDURE [dbo].[Dot_Dep_CustomerUpdMemBetSetting_DCS]  
	@CustID INT, --MemberID  
	@Sporttype SMALLINT,
	@Bettype SMALLINT,

	@MinBet MONEY,  
	@MaxBet MONEY,  
	@MaxPerMatch MONEY,  
   
	@UserID INT, --updater ID  
	@Language VARCHAR(2) = 'E',  
	@IP VARCHAR(15)= '',   
	@ErrCode INT = 0 OUTPUT,  
	@ErrMsg NVARCHAR(4000) = '' OUTPUT  
AS  
/*  
	Created: 20170901@Elodie
	Task : Update member min max bet.  
	DB: DBCUST/CustDB  
	User: API Licensee  
  
	Revisions:  
		- 20180921@Johnson: format log [Redmine:#101293]
		- 20220218@Winfred: LG VS3  - Licensee DCS setting for new BetLimit  - Redmine: 168395
		- 20220517@Tacy: Insert history of member bet setting [RedmineID: 170739]
		- 20240320@Johnson: Write log by service broker [redmine: #199517]
		- 20240705@Johnson: Apply In-house Replication for Customer Setting [redmine:#207025]
	Param's Explanation:  

	Excution sample: 
	DECLARE @ErrCode INT, @ErrMsg NVARCHAR(4000)
	EXEC Dot_Dep_CustomerUpdMemBetSetting_DCS @CustID = 778038, @Sporttype = 180, @Bettype = 1201, @MinBet = 10, @MaxBet = 100, @MaxPerMatch = 1000, @UserID = 9, @ErrCode = @ErrCode OUTPUT, @ErrMsg = @ErrMsg OUTPUT
*/  
BEGIN  
	SET NOCOUNT ON  

	DECLARE @CustList VARCHAR(MAX)
  
	DECLARE @startRun DATETIME, @endRun DATETIME, @duration INT  	
	DECLARE @MinMinBet MONEY, @MaxMaxBet MONEY, @MaxMaxPerMatch MONEY, @Old_MinBet MONEY, @Old_MaxBet MONEY, @Old_MaxPerMatch MONEY   
	DECLARE @ErrAcc VARCHAR(4000), @ErrType VARCHAR(4000), @UserName VARCHAR(30), @recommend INT, @roleid TINYINT, @UplineClosed BIT  , @IsNotMaxPerMatch INT, @mrecommend INT, @srecommend INT
	DECLARE @LogSPData VARCHAR(5000), @TrackingValue2 VARCHAR(5000) 

	DECLARE @History_BetSetting TABLE(
		CustID				INT
		, SportType			SMALLINT
		, BetType			SMALLINT
		, MaxBet			MONEY
		, MaxPerMatch		MONEY
		, UpdateTime		DATETIME
		)

	SET @startRun = GETDATE()  
	SET @IsNotMaxPerMatch = 0
		  
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

	--no need to check
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
	
	SELECT       
		@Old_MinBet = ISNULL(MinBet ,0),  
		@Old_MaxBet = ISNULL(MaxBet ,0),
		@Old_MaxPerMatch = ISNULL(MaxPerMatch,0)  
	FROM       
		dbo.Dep_CustBetSetting_Member WITH (NOLOCK)      
	WHERE custid = @CustID and bettype = @Bettype and sporttype = @Sporttype
     
	IF  @Old_MinBet = @MinBet AND @Old_MaxBet = @MaxBet AND (@IsNotMaxPerMatch = 1 OR (@IsNotMaxPerMatch = 0 AND @Old_MaxPerMatch = @MaxPerMatch))
		RETURN    
  
	IF EXISTS(	SELECT TOP 1 1 
				FROM dbo.Dep_ProductSetting dps WITH(NOLOCK)
					INNER JOIN Dep_ProductSettingDetail dpsd  WITH(NOLOCK) ON dps.ProductSettingID = dpsd.ProductSettingID
				WHERE 	dpsd.SportType = @Sporttype AND dpsd.BetType = @Bettype AND dps.SettingType	 = 11		
			)
	BEGIN
		SET @IsNotMaxPerMatch = 1
	END		 
	
	SELECT   @MinMinBet = MAX(CASE WHEN MinBet = 0 THEN NULL ELSE MinBet END),   
			 @MaxMaxBet = MIN(CASE WHEN MaxBet = 0 THEN NULL ELSE MaxBet END),
			 @MaxMaxperMatch = MIN(CASE WHEN cs.MaxPerMatch = 0 AND @IsNotMaxPerMatch = 0 THEN NULL ELSE cs.MaxPerMatch END)  
	FROM   dbo.Dep_CustBetSetting_Agent AS cs WITH (NOLOCK)  
	WHERE cs.custid IN (@recommend,@mrecommend,@srecommend)
		AND cs.sporttype = @Sporttype 
		AND cs.bettype = @Bettype  

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
   
	IF ((@MinBet<>0 OR @MaxBet<>0 OR (@IsNotMaxPerMatch = 0 AND @MaxPerMatch<>0)) AND (@MinBet > @MaxBet OR (@IsNotMaxPerMatch = 0 AND @MaxBet > @MaxPerMatch)))  
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
   
	IF (@IsNotMaxPerMatch = 0 AND @MaxMaxPerMatch > 0 AND @MaxPerMatch > 0 AND @MaxPerMatch > @MaxMaxPerMatch)  
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

	UPDATE dbo.Dep_CustBetSetting_Member WITH (ROWLOCK, UPDLOCK)  
	SET MinBet = @MinBet,  
		MaxBet = @MaxBet,
		MaxPerMatch = CASE WHEN @IsNotMaxPerMatch = 0 THEN @MaxPerMatch ELSE MaxPerMatch END,
		RepUpdateTime = SYSDATETIME()
	OUTPUT deleted.CustID, deleted.SportType, deleted.BetType, deleted.MaxBet, deleted.MaxPerMatch, GETDATE()
		INTO @History_BetSetting(CustID, SportType, BetType, MaxBet, MaxPerMatch, UpdateTime)
	WHERE custid = @CustID AND SportType = @Sporttype AND BetType = @Bettype

	IF (@@ERROR <> 0)  
	BEGIN     
		 SELECT @ErrMsg = @UserName + ': '+  CASE @Language   WHEN 'E' THEN 'Update process is unsuccessful !'  
															  WHEN 'CS' THEN N'更新程序不成功 !'  
															  WHEN 'CT' THEN N'更新程序不成功 !'  
															  WHEN 'TH' THEN N'ขั้นตอนหรือกระบวนการในการปรับยอดไม่เสร็จสิ้น!'  
															  WHEN 'J' THEN N'アップデート出来ません。'  
															  WHEN 'KO' THEN N'업데이트에 실패했습니다.'  
															  ELSE N'Update process is unsuccessful !'  
											 END, 
				@ErrCode = 107  
		 RETURN  
	END  

	--Insert history bet setting
	IF NOT EXISTS (SELECT 1
					FROM @History_BetSetting
					WHERE custid = @CustID AND SportType = @Sporttype AND BetType = @Bettype
					  AND MaxBet = @MaxBet AND 
					  (@IsNotMaxPerMatch=1 OR MaxPerMatch=@MaxPerMatch)
	)
	BEGIN 
		SET @CustList = (SELECT CustID		AS '@CustID',
								SportType	AS '@SportType',
								BetType		AS '@BetType',
								MaxBet		AS '@MaxBet',
								MaxPerMatch	AS '@MaxPerMatch',
								'NULL'		AS '@StakeLevelList',
								UpdateTime	AS '@UpdateTime'
							FROM @History_BetSetting
							FOR XML PATH ('r'), ROOT ('root')
						)

		EXECUTE Acc_Dep_DynamicCustSetting_07 @CustList=@CustList, @ErrMsg=@ErrMsg OUTPUT

		IF @ErrMsg<>''
			RETURN 
	END

	SELECT @LogSPData =	'<R Sport="'+ COALESCE(CAST(@SportType AS VARCHAR(50)),SPACE(1)) + '" ' +  
						'BT="'+ COALESCE(CAST(@Bettype AS VARCHAR(50)),SPACE(1)) + '" ' +  	
						'Min="'+ COALESCE(CAST(@minbet AS VARCHAR(50)),SPACE(1)) + '" ' +  
						'Max="'+ COALESCE(CAST(@maxbet AS VARCHAR(50)),SPACE(1)) + '" ' +  
						'MPM="'+ COALESCE(CAST(@maxpermatch AS VARCHAR(50)),SPACE(1)) + '" />'  
  
	SELECT @TrackingValue2 ='<R Sport="'+ COALESCE(CAST(@SportType AS VARCHAR(50)),SPACE(1)) + '" ' +  
							'BT="'+ COALESCE(CAST(@Bettype AS VARCHAR(50)),SPACE(1)) + '" ' +  	
							'Min="'+ COALESCE(CAST(@Old_minbet AS VARCHAR(50)),SPACE(1)) + '" ' +  
							'Max="'+ COALESCE(CAST(@Old_maxbet AS VARCHAR(50)),SPACE(1)) + '" ' +  
							'MPM="'+ COALESCE(CAST(@Old_maxpermatch AS VARCHAR(50)),SPACE(1)) + '" />'  
  
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
					GETDATE() as '@LogDate',
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
