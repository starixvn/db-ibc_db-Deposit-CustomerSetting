/*<info serverAlias="DBCUST-CUSTDB" executers="bodbAdminNet,bodbDownlineNet,bodbExtAccNet,Dot_Member" viewers="" isFunction="0" isNested="1"></info>*/
ALTER PROCEDURE [dbo].[Dot_Dep_CustomerInsMember_Ag_Cust_Main]     
	@FirstName NVARCHAR(50),    
	@LastName NVARCHAR(50),    
	@Email NVARCHAR(50),    
	@DepositUserName VARCHAR(50),    
	@DepositUserID INT,    
	@Password VARCHAR(40),    
	@OddsType VARCHAR(5),      
	@AgentID INT,    
	@AffiliateID INT = NULL,    
	@BonusCode VARCHAR(20) = NULL,    
	@Country NVARCHAR(50) = '',
	@SubsidiaryID INT = 0,
	@CustID INT = 0 OUTPUT,    
	@Username VARCHAR(50) ='' OUTPUT,    
	@ErrCode INT = 0 OUTPUT,    
	@ErrMsg NVARCHAR(2000) = '' OUTPUT     
AS    
/*    
	Created: 20200907@Eden 
	Task : Clone from Dot_Dep_CustomerInsMember_Ag
	DB: DBCUST/CustDB    
	Original:    
	User: NON API Licensee/API Licensee/12Bet    
	    
	Revisions:    
	 - 20200907@Eden: Minimize UM Time - 1st Deposit [Redmine: #136741]
	 - 20201005@Winfred: Add new OddsAdj dummy customers [redmine:#142952] 
	 - 20201214@Winfred: Adjust PT value with 4 decimal places for SB  [redmine: #146574]
	 - 20210319@Eden: Correct comm group - bettype = 20  [redmine: #151213]
	 - 20220505@Tacy: Add @SubsidiaryID to Insert into DepositCustomer [Redmine: #171861]
	 
	Param's Explanation:    
	? @CustID: return new 12bet Player Cust ID    
	? @Username: return new 12bet Player User name    
	    
	? @ErrCode:    
	 = 0: Transaction recorded successfully.    
	 > 0: Specific Error.    
	     
	? @ErrMsg: Error description.    
*/ 
BEGIN
	SET NOCOUNT ON    
	    
	DECLARE @startRun DATETIME, @endRun DATETIME, @duration int    
	SET @startRun = getdate()    
	    
	----- Elodie @ 01 JUN 2015 -------------------    
	 DECLARE @tmp_Sports TABLE (SportType SMALLINT, SportName NVARCHAR(50))    
	 DECLARE @tmp_GameType TABLE (GameTypeID INT, GameTypeName NVARCHAR(50), IsDisabled BIT, IBCBettypeID INT)    
	    
	 BEGIN TRY    
		  INSERT INTO @tmp_Sports (SportType, SportName)    
		  SELECT SportType, SportName FROM DBAGE.bodb02.dbo.Sports WITH (NOLOCK)      
	 END TRY    
	 BEGIN CATCH    
		  INSERT INTO @tmp_Sports (SportType, SportName)    
		  SELECT SportType, SportName FROM DBTXN.bodb02.dbo.Sports WITH (NOLOCK)     
	 END CATCH     
	    
	 BEGIN TRY      
		  INSERT INTO @tmp_GameType (GameTypeID, GameTypeName, IsDisabled, IBCBettypeID)    
		  SELECT GameTypeID, GameTypeName, IsDisabled, IBCBettypeID FROM DBAGE.bodb02.dbo.GameType WITH (NOLOCK)    
	 END TRY    
	 BEGIN CATCH      
		  INSERT INTO @tmp_GameType (GameTypeID, GameTypeName, IsDisabled, IBCBettypeID)    
		  SELECT GameTypeID, GameTypeName, IsDisabled, IBCBettypeID FROM DBTXN.bodb02.dbo.GameType WITH (NOLOCK)    
	 END CATCH    
	----- /Elodie @ 01 JUN 2015 -------------------    
	    
	---------------------------------    
	--20100922@Thien:   1st phrase - Get rid of members' information for Licensee site (first name, last name, email).    
	--                  Will remove these params once Brian's side removes the calling from Web code.    
	SELECT  @FirstName = '',    
			@LastName = '',    
			@Email = ''    
	---------------------------------    
	    
	DECLARE	 @currency INT,    
			 @recommend INT,    
			 @mrecommend INT,    
			 @srecommend INT,     
			 @agusername VARCHAR(30),    
			 @site VARCHAR(30),    
			 @pwdexpiry DATETIME,    
			 @ugroup VARCHAR(5),    
			 @discount DECIMAL(9,8),     
			 @discountcs DECIMAL(9,8),    
			 @discount1x2 DECIMAL(9,8),--1x2 agent comm     
	   
			 @playerdiscount DECIMAL(9,8),    
			 @playerdiscountcs DECIMAL(9,8),    
			 @playerdiscount1x2 DECIMAL(9,8),--1x2 comm     
			 --v161    
			 @v161playerdiscount DECIMAL(9,8),-- number game com for player    
	
			 --Keno    
			 @v202playerdiscount_1501 DECIMAL(9,8),    
			 @v202discount_1501 DECIMAL(9,8),    
	    
			 @minbet MONEY,     
			 @maxbet MONEY,     
			 @maxpermatch MONEY,     
			 @minbetv2 MONEY,     
			 @maxbetv2 MONEY,     
			 @maxpermatchv2 MONEY,    
	    
			 @minbetv3 MONEY,     
			 @maxbetv3 MONEY,     
			 @maxpermatchv3 MONEY,    
	    
			 @minbetv5 MONEY,     
			 @maxbetv5 MONEY,     
			 @maxpermatchv5 MONEY,    
	    
			 @minbetv8 MONEY,     
			 @maxbetv8 MONEY,     
			 @maxpermatchv8 MONEY,    
	    
			 @minbetv10 MONEY,     
			 @maxbetv10 MONEY,     
			 @maxpermatchv10 MONEY,    
	    
			 @minbetv11 MONEY,     
			 @maxbetv11 MONEY,     
			 @maxpermatchv11 MONEY,    
	 
			 @minbetv99 MONEY,     
			 @maxbetv99 MONEY,     
			 @maxpermatchv99 MONEY,    
	     
			 --Mix Parlay Mixed sports
			 @minbetv1MP MONEY,    
			 @maxbetv1MP MONEY,    
			 @maxpermatchv1MP MONEY, 
			 
			 @minbetv99MP MONEY,    
			 @maxbetv99MP MONEY,    
			 @maxpermatchv99MP MONEY,    
	
			 --Number game    
			 @minbetv161 MONEY,    
			 @maxbetv161 MONEY,    
			 @maxperballv161 MONEY,    
			 @maxpermatchv161 MONEY,     

			 @Success BIT    
	    
	DECLARE  @apositiontaking_1 SMALLMONEY,    
			 @apositiontaking_2 SMALLMONEY,    
			 @apositiontaking_3 SMALLMONEY,    
			 @apositiontaking_4 SMALLMONEY,    
			 @apositiontaking_5 SMALLMONEY,    
			 @apositiontaking_6 SMALLMONEY,    
			 @apositiontaking_7 SMALLMONEY,    
			 @apositiontaking_8 SMALLMONEY,    
			 @apositiontaking_9 SMALLMONEY,    
			 @apositiontaking_10 SMALLMONEY,    
	     
			 @alivepositiontaking_1 SMALLMONEY,    
			 @alivepositiontaking_3 SMALLMONEY,    
			 @alivepositiontaking_7 SMALLMONEY,    
			 @alivepositiontaking_8 SMALLMONEY,    
	     
			 @v2apositiontaking_1 SMALLMONEY,    
			 @v2apositiontaking_2 SMALLMONEY,    
			 @v2apositiontaking_3 SMALLMONEY,    
			 @v2apositiontaking_7 SMALLMONEY,    
			 @v2apositiontaking_8 SMALLMONEY,    
			 --@v2apositiontaking_9 smallmoney,-- not use for baseket ball    
			 @v2apositiontaking_20 SMALLMONEY,    
	     
			 @v3apositiontaking_1 SMALLMONEY,    
			 @v3apositiontaking_2 SMALLMONEY,    
			 @v3apositiontaking_3 SMALLMONEY,    
			 @v3apositiontaking_20 SMALLMONEY,    
	    
			 @v5apositiontaking_1 SMALLMONEY,    
			 @v5apositiontaking_2 SMALLMONEY,    
			 @v5apositiontaking_3 SMALLMONEY,    
			 @v5apositiontaking_20 SMALLMONEY,    
	    
			 @v8apositiontaking_1 SMALLMONEY,    
			 @v8apositiontaking_3 SMALLMONEY,    
			 @v8apositiontaking_20 SMALLMONEY,    
	    
			 @v10apositiontaking_1 SMALLMONEY,    
			 @v10apositiontaking_2 SMALLMONEY,    
			 @v10apositiontaking_3 SMALLMONEY,    
			 @v10apositiontaking_20 SMALLMONEY,    
	    
			 @v11apositiontaking_1 SMALLMONEY,    
			 @v11apositiontaking_20 SMALLMONEY,     

			 @v99apositiontaking_1 SMALLMONEY,    
			 @v99apositiontaking_2 SMALLMONEY,    
			 @v99apositiontaking_3 SMALLMONEY,    
			 @v99apositiontaking_9 SMALLMONEY,-- parlay mixed sports    
			 @v99apositiontaking_20 SMALLMONEY,    
	
			 --positionataking for number game    
			 @v161apositiontaking_81 SMALLMONEY,    
			 @v161apositiontaking_83 SMALLMONEY,    
			 @v161apositiontaking_86 SMALLMONEY,    
			 @v161apositiontaking_88 SMALLMONEY,    
	     
			 @v161alivepositiontaking_85 SMALLMONEY,    
			 @v161alivepositiontaking_86 SMALLMONEY,    
			 @v161alivepositiontaking_87 SMALLMONEY,    
			 @v161alivepositiontaking_89 SMALLMONEY,    
			 @v161alivepositiontaking_90 SMALLMONEY,    

			 --Keno    
			 @v202apositiontaking_1501 SMALLMONEY
	    
	DECLARE	 @MinMinBet MONEY, @MaxMaxBet MONEY, @MaxMaxPerMatch MONEY,    
			 @MinMinBetv2 MONEY, @MaxMaxBetv2 MONEY, @MaxMaxPerMatchv2 MONEY,    
			 @MinMinBetv3 MONEY, @MaxMaxBetv3 MONEY, @MaxMaxPerMatchv3 MONEY,    
			 @MinMinBetv5 MONEY, @MaxMaxBetv5 MONEY, @MaxMaxPerMatchv5 MONEY,    
			 @MinMinBetv8 MONEY, @MaxMaxBetv8 MONEY, @MaxMaxPerMatchv8 MONEY,    
			 @MinMinBetv10 MONEY, @MaxMaxBetv10 MONEY, @MaxMaxPerMatchv10 MONEY,    
			 @MinMinBetv11 MONEY, @MaxMaxBetv11 MONEY, @MaxMaxPerMatchv11 MONEY,    			 
			 @MinMinBetv99 money, @MaxMaxBetv99 money, @MaxMaxPerMatchv99 money,     
	     
			 --Mix parlay mix sport    
			 @MinMinBetv1MP money, @MaxMaxBetv1MP money, @MaxMaxPerMatchv1MP money,    
			 @MinMinBetv99MP money, @MaxMaxBetv99MP money, @MaxMaxPerMatchv99MP money,    
	
			 --Number game    
			 @MinMinBetv161 money, @MaxMaxBetv161 money, @MaxMaxPerMatchv161 money, @MaxMaxPerBallv161 money,    
	    
			 @Aclosed bit,    
			 @Asuspended bit,    
			-- @AgentMaxPerMatch money, @AgentMaxPerMatchb money,    
			-- @MaxPerMatch_AllOtherMember money, @MaxPerMatchv2_AllOtherMember money,    
	    
			 --m2    
			 @mpositiontaking_1 SMALLMONEY,    
			 @mpositiontaking_2 SMALLMONEY,    
			 @mpositiontaking_3 SMALLMONEY,    
			 @mpositiontaking_4 SMALLMONEY,    
			 @mpositiontaking_5 SMALLMONEY,    
			 @mpositiontaking_6 SMALLMONEY,    
			 @mpositiontaking_7 SMALLMONEY,    
			 @mpositiontaking_8 SMALLMONEY,    
			 @mpositiontaking_9 SMALLMONEY,    
			 @mpositiontaking_10 SMALLMONEY,    
			 @mlivepositiontaking_1 SMALLMONEY,    
			 @mlivepositiontaking_3 SMALLMONEY,    
			 @mlivepositiontaking_7 SMALLMONEY,    
			 @mlivepositiontaking_8 SMALLMONEY,    
	     
			 @v2mpositiontaking_1 SMALLMONEY,    
			 @v2mpositiontaking_2 SMALLMONEY,    
			 @v2mpositiontaking_3 SMALLMONEY,    
			 @v2mpositiontaking_7 SMALLMONEY,    
			 @v2mpositiontaking_8 SMALLMONEY,    
			 --@v2mpositiontaking_9 SMALLMONEY,-- not use     
			 @v2mpositiontaking_20 SMALLMONEY,    
	    
			 @v3mpositiontaking_1 SMALLMONEY,    
			 @v3mpositiontaking_2 SMALLMONEY,    
			 @v3mpositiontaking_3 SMALLMONEY,    
			 @v3mpositiontaking_20 SMALLMONEY,    
	    
			 @v5mpositiontaking_1 SMALLMONEY,    
			 @v5mpositiontaking_2 SMALLMONEY,    
			 @v5mpositiontaking_3 SMALLMONEY,    
			 @v5mpositiontaking_20 SMALLMONEY,    
	    
			 @v8mpositiontaking_1 SMALLMONEY,    
			 @v8mpositiontaking_3 SMALLMONEY,    
			 @v8mpositiontaking_20 SMALLMONEY,    
	    
			 @v10mpositiontaking_1 SMALLMONEY,    
			 @v10mpositiontaking_2 SMALLMONEY,    
			 @v10mpositiontaking_3 SMALLMONEY,    
			 @v10mpositiontaking_20 SMALLMONEY,    
	    
			 @v11mpositiontaking_1 SMALLMONEY,    
			 @v11mpositiontaking_20 SMALLMONEY,    
	 
			 @v99mpositiontaking_1 SMALLMONEY,    
			 @v99mpositiontaking_2 SMALLMONEY,    
			 @v99mpositiontaking_3 SMALLMONEY,    
			 @v99mpositiontaking_9 SMALLMONEY,-- mix parlay mixed sports    
			 @v99mpositiontaking_20 SMALLMONEY,    
	
			 --for number game    
			 @v161mpositiontaking_81 SMALLMONEY,    
			 @v161mpositiontaking_83 SMALLMONEY,    
			 @v161mpositiontaking_86 SMALLMONEY,    
			 @v161mpositiontaking_88 SMALLMONEY,    
			 @v161mlivepositiontaking_85 SMALLMONEY,    
			 @v161mlivepositiontaking_86 SMALLMONEY,    
			 @v161mlivepositiontaking_87 SMALLMONEY,    
			 @v161mlivepositiontaking_89 SMALLMONEY,    
			 @v161mlivepositiontaking_90 SMALLMONEY,    

			 --Keno    
			 @v202mpositiontaking_1501 SMALLMONEY,    
	     
			 --s3    
			 @spositiontaking_1 SMALLMONEY,    
			 @spositiontaking_2 SMALLMONEY,    
			 @spositiontaking_3 SMALLMONEY,    
			 @spositiontaking_4 SMALLMONEY,    
			 @spositiontaking_5 SMALLMONEY,    
			 @spositiontaking_6 SMALLMONEY,    
			 @spositiontaking_7 SMALLMONEY,    
			 @spositiontaking_8 SMALLMONEY,    
			 @spositiontaking_9 SMALLMONEY,    
			 @spositiontaking_10 SMALLMONEY,    
	     
			 @slivepositiontaking_1 SMALLMONEY,    
			 @slivepositiontaking_3 SMALLMONEY,    
			 @slivepositiontaking_7 SMALLMONEY,    
			 @slivepositiontaking_8 SMALLMONEY,    
	     
			 @v2spositiontaking_1 SMALLMONEY,    
			 @v2spositiontaking_2 SMALLMONEY,    
			 @v2spositiontaking_3 SMALLMONEY,    
			 @v2spositiontaking_7 SMALLMONEY,    
			 @v2spositiontaking_8 SMALLMONEY,    
			 --@v2spositiontaking_9 SMALLMONEY, -- not use for baseket ball    
			 @v2spositiontaking_20 SMALLMONEY,    
	     
			 @v3spositiontaking_1 SMALLMONEY,    
			 @v3spositiontaking_2 SMALLMONEY,    
			 @v3spositiontaking_3 SMALLMONEY,    
			 @v3spositiontaking_20 SMALLMONEY,    
	    
			 @v5spositiontaking_1 SMALLMONEY,    
			 @v5spositiontaking_2 SMALLMONEY,    
			 @v5spositiontaking_3 SMALLMONEY,    
			 @v5spositiontaking_20 SMALLMONEY,    
	    
			 @v8spositiontaking_1 SMALLMONEY,    
			 @v8spositiontaking_3 SMALLMONEY,    
			 @v8spositiontaking_20 SMALLMONEY,    
	    
			 @v10spositiontaking_1 SMALLMONEY,    
			 @v10spositiontaking_2 SMALLMONEY,    
			 @v10spositiontaking_3 SMALLMONEY,    
			 @v10spositiontaking_20 SMALLMONEY,    
	    
			 @v11spositiontaking_1 SMALLMONEY,    
			 @v11spositiontaking_20 SMALLMONEY,    
	   
			 @v99spositiontaking_1 SMALLMONEY,    
			 @v99spositiontaking_2 SMALLMONEY,    
			 @v99spositiontaking_3 SMALLMONEY,    
			 @v99spositiontaking_9 SMALLMONEY,-- mix parlay mixed sports    
			 @v99spositiontaking_20 SMALLMONEY,    
	
			 @v161spositiontaking_81 SMALLMONEY,    
			 @v161spositiontaking_83 SMALLMONEY,    
			 @v161spositiontaking_86 SMALLMONEY,    
			 @v161spositiontaking_88 SMALLMONEY,    
	     
			 @v161slivepositiontaking_85 SMALLMONEY,    
			 @v161slivepositiontaking_86 SMALLMONEY,    
			 @v161slivepositiontaking_87 SMALLMONEY,    
			 @v161slivepositiontaking_89 SMALLMONEY,     
			 @v161slivepositiontaking_90 SMALLMONEY,     

			 --Keno    
			 @v202spositiontaking_1501 SMALLMONEY,    
	      
			 @adiscount DECIMAL(9,8),    
			 @adiscountcs DECIMAL(9,8),    
			 @adiscount1x2 DECIMAL(9,8),--1x2 master comm     
	    
			 @sdiscount DECIMAL(9,8),    
			 @sdiscountcs DECIMAL(9,8),    
			 @sdiscount1x2 DECIMAL(9,8),--1x2 super comm    
	    
			 @maxdiscount DECIMAL(9,8),    
			 @maxdiscountcs DECIMAL(9,8),    
	     
			  --v161    
			 @v161discount DECIMAL(9,8),    
			 @v161adiscount DECIMAL(9,8),    
			 @v161sdiscount DECIMAL(9,8),  
	
			 --Keno    
			 @v202adiscount_1501 DECIMAL(9,8),    
			 @v202sdiscount_1501 DECIMAL(9,8),    
			 @DisableNumber BIT,-- for number game    	 
			 @HideKeno BIT,    
	    
			 @suspendedFlag VARCHAR(6),    
			 @suspended BIT,    
	    
			 @matchlimit SMALLMONEY,    
			 @virtualmultiplier SMALLMONEY    
	    
	--20140422@Johnson: hardcode bet limit for keno    
	DECLARE @custgametype table(gametypeid int, maxbet money, maxpergametype money)    
	    
	--Init param    
	SELECT @ErrCode = 0, @ErrMsg = '', @pwdexpiry = dateadd(dd, 30, getdate())  
	    
	----------------Affiliate Bonus Code---------------------    
	IF (ISNULL(@AffiliateID, 0) = 0 AND @BonusCode is not null)     
	BEGIN     
		 SELECT @AffiliateID = AffID FROM DBAFF12BET.[Affiliate_12Bet].dbo.AffDetail WITH(NOLOCK) WHERE bonuscode = @BonusCode     
		 IF ISNULL(@AffiliateID,0) > 0 -- @bonuscode is valid, change currency agent from [..]01 --> [..]02    
		 BEGIN    
			DECLARE @_currAgentName VARCHAR(20)    
			SELECT @_currAgentName =username FROM Custinfo WITH(NOLOCK) WHERE custid=@AgentID         
			SELECT @AgentID = CustID FROM CustInfo WITH(NOLOCK) WHERE username = Replace(@_currAgentName, '01', '02')     
		 END     
	END    
	-------------------------------------------------------    
	SELECT    
		 @srecommend = ci.srecommend,    
		 @mrecommend = ci.mrecommend,     
		 @recommend = ci.custID,    
		 @agusername = ci.username,    
		 @currency = ci.currency,     
		 @maxpermatch = maxpermatch,    
		 @maxpermatchv2 = maxpermatch2,    
		 @maxpermatchv3 = maxpermatch3,    
		 @maxpermatchv5 = maxpermatch5,    
		 @maxpermatchv8 = maxpermatch8,    
		 @maxpermatchv10 = maxpermatch10,    
		 @maxpermatchv11 = maxpermatch11,    
	
		 @maxpermatchv161 = maxpermatch161,--number game    
		 @maxperballv161 = maxperball161,  
		 @maxpermatchv1MP = maxpermatch1mp,	
		 @maxpermatchv99MP = maxpermatch99mp, -- mix parlay mix sports    
		 @maxpermatchv99 = maxpermatch99,    

		 ----- add more    
		 @site    = c.site,    
		 @Aclosed   = closed,    
		 @Asuspended   = reject,    
		 @matchlimit   = matchlimit,    
		 @virtualmultiplier = virtualmultiplier,    
	
		 @DisableNumber  = ISNULL(DisableNumber,0),
		 @HideKeno = HideKeno    
	FROM custinfo ci WITH(NOLOCK)     
		INNER JOIN customer c WITH(NOLOCK) ON ci.custid = c.custid    
	WHERE ci.CustID = @AgentID AND ci.roleid = 2    
	     
	--check valid agent here    
	if @recommend IS NULL    
	BEGIN    
		SELECT @ErrMsg = 'Invalid agent.', @ErrCode = 10    
		RETURN    
	END    
	    
	--20110419@Thien: hard-code the ugroup for licensee sites    
	--SELECT @ugroup = case @site when 'DELA' then 'd' else 'a' end    
	    
	--20110426@Thien: rollback for DELA, set to group A again    
	SELECT @ugroup = 'a'    
	    
	--20110916@Thien: Hard-code the ugroup for Alog.    
	--     Adjust all USD, EUR and GBP currency members to 6 pts line (group B), apply this to all existing and future members    
	---20141103@Jim: just Alog member belong to currency US$ and GBP need to set  to  group D as default (exclude  EUR currency member)    
	--20131230@Jim: Hard-code the ugroup for Asiabet88     
	--     Adjust all USD, EUR  currency members to 6 pts line (group B), apply this to all existing and future members    
	--20141103@Jim: fix bug alog member's ugroup are wrong      
	--20141212@Jamie: Set ugroup = a for Alog (USD,GBP) [redmine:#25577]    
	--20150928@Victor: Set uGroup = C for all new Asiabet88 KRW members [redmine: 44141]
	-- 20180222@Elodie: Set uGroup = C for all new AE88 RMB members [Redmine: #90965]  
	/*SELECT @ugroup = 
	CASE	WHEN @site = 'Asiabet88' AND  @currency IN (3,6) THEN 'b' 	
			WHEN @site = 'Asiabet88' AND @currency = 45 THEN 'c'		
			WHEN @site = 'Ae88' AND @currency = 13 THEN 'b'			
			ELSE 'a'    
	END*/

	IF EXISTS (SELECT TOP 1 1 FROM Dep_DefaultOddGroup WITH(NOLOCK) WHERE AgentID=@AgentID AND IsActive=1)
		SELECT @ugroup = Ugroup FROM Dep_DefaultOddGroup WITH(NOLOCK) WHERE AgentID=@AgentID AND IsActive=1
	     
	--Will check the usergroup here    
	--MinBet, MaxBet, Commission get from CA Agent    
	           
	SELECT @minbet		= MAX(CASE WHEN sporttype = 1 AND bettype = 1 THEN minbet ELSE 0 END)    
		  ,@maxbet		= MAX(CASE WHEN sporttype = 1 AND bettype = 1 THEN maxbet ELSE 0 END)    
		  ,@minbetv2	= MAX(CASE WHEN sporttype = 2 AND bettype = 1 THEN minbet ELSE 0 END)    
		  ,@maxbetv2	= MAX(CASE WHEN sporttype = 2 AND bettype = 1 THEN maxbet ELSE 0 END)    
		  ,@minbetv3	= MAX(CASE WHEN sporttype = 3 AND bettype = 1 THEN minbet ELSE 0 END)    
		  ,@maxbetv3	= MAX(CASE WHEN sporttype = 3 AND bettype = 1 THEN maxbet ELSE 0 END)    
		  ,@minbetv5	= MAX(CASE WHEN sporttype = 5 AND bettype = 1 THEN minbet ELSE 0 END)    
		  ,@maxbetv5	= MAX(CASE WHEN sporttype = 5 AND bettype = 1 THEN maxbet ELSE 0 END)    
		  ,@minbetv8	= MAX(CASE WHEN sporttype = 8 AND bettype = 1 THEN minbet ELSE 0 END)    
		  ,@maxbetv8	= MAX(CASE WHEN sporttype = 8 AND bettype = 1 THEN maxbet ELSE 0 END)    
		  ,@minbetv10	= MAX(CASE WHEN sporttype = 10 AND bettype =1 THEN minbet ELSE 0 END)    
		  ,@maxbetv10	= MAX(CASE WHEN sporttype = 10 AND bettype =1 THEN maxbet ELSE 0 END)    
		  ,@minbetv11	= MAX(CASE WHEN sporttype = 11 AND bettype =1 THEN minbet ELSE 0 END)    
		  ,@maxbetv11	= MAX(CASE WHEN sporttype = 11 AND bettype =1 THEN maxbet ELSE 0 END)    
		
		  ,@minbetv99	= MAX(CASE WHEN sporttype = 99 AND bettype =1 THEN minbet ELSE 0 END)    
		  ,@maxbetv99	= MAX(CASE WHEN sporttype = 99 AND bettype =1 THEN maxbet ELSE 0 END)    
	
		  ,@minbetv1MP = MAX(CASE WHEN sporttype = 1 AND bettype =9 THEN minbet ELSE 0 END)    
		  ,@maxbetv1MP = MAX(CASE WHEN sporttype = 1 AND bettype =9 THEN maxbet ELSE 0 END)    
	
		  ,@minbetv99MP = MAX(CASE WHEN sporttype = 99 AND bettype =9 THEN minbet ELSE 0 END)    
		  ,@maxbetv99MP = MAX(CASE WHEN sporttype = 99 AND bettype =9 THEN maxbet ELSE 0 END)    
	
		  ,@discount    = MAX(CASE WHEN sporttype = 1 AND bettype = 1 THEN discount ELSE 0 END)    
		  ,@discountcs  = MAX(CASE WHEN sporttype = 1 AND bettype = 4 THEN discount ELSE 0 END)    
		  ,@discount1x2 = MAX(CASE WHEN sporttype = 1 AND bettype = 5 THEN discount ELSE 0 END)    
	
	FROM Dep_Custsetting WITH(NOLOCK)    
	WHERE custid = @recommend AND islive=0 AND bettype IN (1,3,4,5,9) AND sporttype IN (1,2,3,5,8,10,11,99)    
	    
	SELECT  
		 @minbetv161	= MAX(CASE WHEN sporttype = 161 AND bettype = 81 THEN minbet ELSE 0 END)    
		,@maxbetv161	= MAX(CASE WHEN sporttype = 161 AND bettype = 81 THEN maxbet ELSE 0 END)      
		,@v161discount  = MAX(CASE WHEN sporttype = 161 AND bettype = 81 THEN discount ELSE 0 END)    
	FROM Dep_CustSetting3rd WITH(NOLOCK)    
	WHERE custid = @recommend AND islive=0 AND bettype = 81 AND sporttype = 161
	
	---  Keno    
	SELECT @v202discount_1501 = MAX(CASE WHEN sporttype = 202 AND bettype = 1501 THEN discount ELSE 0 END)    
	FROM custsettinggame WITH(NOLOCK)    
	WHERE custid = @recommend and bettype = 1501 and sporttype =202  
	    
	DECLARE @vMaxbet MONEY, @vMaxpermatch MONEY    
	SELECT @vMaxbet = 0, @vMaxpermatch = 0 -- assign the default value    
	    
	/*    
	-- NumberGame - Hard code MaxBet and MaxPerBall    
	Kiwi@20120327: Rollback Number Game MaxBet and MaxperBall    
	Currency    Revise Max per bet  Revise Max per Ball    
	IN          5000                15000    
	RM          2000                5000    
	RMB         3000                10000    
	TB          20000               50000    
	*/    
	    
	-- HardCode -      
	IF(EXISTS(SELECT top 1 1 FROM Dep_CustBetLimit_Special WITH(NOLOCK) WHERE AgentID = @AgentID))    
	BEGIN    
		 SELECT	@Maxbet				= ISNULL(MAX(CASE WHEN SportType = 1 AND Bettype = 1 THEN MaxBet ELSE NULL END),@Maxbet),     
				@Maxpermatch		= ISNULL(MAX(CASE WHEN SportType = 1 AND Bettype = 1 THEN  MaxPerMatch ELSE NULL END),@Maxpermatch),    
				@maxbetv2			= ISNULL(MAX(CASE WHEN SportType = 2 AND Bettype = 1 THEN MaxBet ELSE NULL END),@maxbetv2),     
				@maxpermatchv2		= ISNULL(MAX(CASE WHEN SportType = 2 AND Bettype = 1 THEN  MaxPerMatch ELSE NULL END),@maxpermatchv2),    
				@maxbetv3			= ISNULL(MAX(CASE WHEN SportType = 3 AND Bettype = 1 THEN MaxBet ELSE NULL END),@maxbetv3),     
				@maxpermatchv3		= ISNULL(MAX(CASE WHEN SportType = 3 AND Bettype = 1 THEN  MaxPerMatch ELSE NULL END),@maxpermatchv3),    
				@maxbetv5			= ISNULL(MAX(CASE WHEN SportType = 5 AND Bettype = 1 THEN MaxBet ELSE NULL END),@maxbetv5),     
				@maxpermatchv5		= ISNULL(MAX(CASE WHEN SportType = 5 AND Bettype = 1 THEN  MaxPerMatch ELSE NULL END),@maxpermatchv5),    
				@maxbetv8			= ISNULL(MAX(CASE WHEN SportType = 8 AND Bettype = 1 THEN MaxBet ELSE NULL END),@maxbetv8),     
				@maxpermatchv8		= ISNULL(MAX(CASE WHEN SportType = 8 AND Bettype = 1 THEN  MaxPerMatch ELSE NULL END),@maxpermatchv8),    
				@maxbetv10			= ISNULL(MAX(CASE WHEN SportType = 10 AND Bettype = 1 THEN MaxBet ELSE NULL END),@maxbetv10),     
				@maxpermatchv10		= ISNULL(MAX(CASE WHEN SportType = 10 AND Bettype = 1 THEN  MaxPerMatch ELSE NULL END),@maxpermatchv10),    
				@maxbetv11			= ISNULL(MAX(CASE WHEN SportType = 11 AND Bettype = 1 THEN MaxBet ELSE NULL END),@maxbetv11),     
				@maxpermatchv11		= ISNULL(MAX(CASE WHEN SportType = 11 AND Bettype = 1 THEN  MaxPerMatch ELSE NULL END),@maxpermatchv11),  
				@maxbetv99			= ISNULL(MAX(CASE WHEN SportType = 99 AND Bettype = 1 THEN MaxBet ELSE NULL END),@maxbetv99),     
				@maxpermatchv99		= ISNULL(MAX(CASE WHEN SportType = 99 AND Bettype = 1 THEN  MaxPerMatch ELSE NULL END),@maxpermatchv99),    
				
				@maxbetv1MP		= ISNULL(MAX(CASE WHEN SportType = 1 AND Bettype = 9 THEN MaxBet ELSE NULL END),@maxbetv1MP),     
				@maxpermatchv1MP	= ISNULL(MAX(CASE WHEN SportType = 1 AND Bettype = 9 THEN  MaxPerMatch ELSE NULL END),@maxpermatchv1MP),    
	  
				@maxbetv99MP		= ISNULL(MAX(CASE WHEN SportType = 99 AND Bettype = 9 THEN MaxBet ELSE NULL END),@maxbetv99MP),     
				@maxpermatchv99MP	= ISNULL(MAX(CASE WHEN SportType = 99 AND Bettype = 9 THEN  MaxPerMatch ELSE NULL END),@maxpermatchv99MP),    
	  
				@maxbetv161			= ISNULL(MAX(CASE WHEN SportType = 161 THEN MaxBet END),@maxbetv161),     
				@maxpermatchv161	= ISNULL(MAX(CASE WHEN SportType = 161 THEN Maxpermatch END),@maxpermatchv161),     
				@maxperballv161		= ISNULL(MAX(CASE WHEN SportType = 161 THEN MaxPerBall END),@maxperballv161)
		 FROM Dep_CustBetLimit_Special WITH(NOLOCK)     
		 WHERE AgentID = @AgentID    
	END     
	ELSE    
	BEGIN    
		 SELECT @Maxbet				= ISNULL(MAX(CASE WHEN SportType = 1 AND Bettype = 1 THEN MaxBet ELSE NULL END),@Maxbet),     
				@Maxpermatch		= ISNULL(MAX(CASE WHEN SportType = 1 AND Bettype = 1 THEN  MaxPerMatch ELSE NULL END),@Maxpermatch),    
				@maxbetv2			= ISNULL(MAX(CASE WHEN SportType = 2 AND Bettype = 1 THEN MaxBet ELSE NULL END),@maxbetv2),     
				@maxpermatchv2		= ISNULL(MAX(CASE WHEN SportType = 2 AND Bettype = 1 THEN  MaxPerMatch ELSE NULL END),@maxpermatchv2),    
				@maxbetv3			= ISNULL(MAX(CASE WHEN SportType = 3 AND Bettype = 1 THEN MaxBet ELSE NULL END),@maxbetv3),     
				@maxpermatchv3		= ISNULL(MAX(CASE WHEN SportType = 3 AND Bettype = 1 THEN  MaxPerMatch ELSE NULL END),@maxpermatchv3),    
				@maxbetv5			= ISNULL(MAX(CASE WHEN SportType = 5 AND Bettype = 1 THEN MaxBet ELSE NULL END),@maxbetv5),     
				@maxpermatchv5		= ISNULL(MAX(CASE WHEN SportType = 5 AND Bettype = 1 THEN  MaxPerMatch ELSE NULL END),@maxpermatchv5),    
				@maxbetv8			= ISNULL(MAX(CASE WHEN SportType = 8 AND Bettype = 1 THEN MaxBet ELSE NULL END),@maxbetv8),     
				@maxpermatchv8		= ISNULL(MAX(CASE WHEN SportType = 8 AND Bettype = 1 THEN  MaxPerMatch ELSE NULL END),@maxpermatchv8),    
				@maxbetv10			= ISNULL(MAX(CASE WHEN SportType = 10 AND Bettype = 1 THEN MaxBet ELSE NULL END),@maxbetv10),     
				@maxpermatchv10		= ISNULL(MAX(CASE WHEN SportType = 10 AND Bettype = 1 THEN  MaxPerMatch ELSE NULL END),@maxpermatchv10),    
				@maxbetv11			= ISNULL(MAX(CASE WHEN SportType = 11 AND Bettype = 1 THEN MaxBet ELSE NULL END),@maxbetv11),     
				@maxpermatchv11		= ISNULL(MAX(CASE WHEN SportType = 11 AND Bettype = 1 THEN  MaxPerMatch ELSE NULL END),@maxpermatchv11),  		
				@maxbetv99			= ISNULL(MAX(CASE WHEN SportType = 99 AND Bettype = 1 THEN MaxBet ELSE NULL END),@maxbetv99),     
				@maxpermatchv99		= ISNULL(MAX(CASE WHEN SportType = 99 AND Bettype = 1 THEN  MaxPerMatch ELSE NULL END),@maxpermatchv99),    
				
				@maxbetv1MP		= ISNULL(MAX(CASE WHEN SportType = 1 AND Bettype = 9 THEN MaxBet ELSE NULL END),@maxbetv1MP),     
				@maxpermatchv1MP   = ISNULL(MAX(CASE WHEN SportType = 1 AND Bettype = 9 THEN  MaxPerMatch ELSE NULL END),@maxpermatchv1MP),    
	   
				@maxbetv99MP		= ISNULL(MAX(CASE WHEN SportType = 99 AND Bettype = 9 THEN MaxBet ELSE NULL END),@maxbetv99MP),     
				@maxpermatchv99MP   = ISNULL(MAX(CASE WHEN SportType = 99 AND Bettype = 9 THEN  MaxPerMatch ELSE NULL END),@maxpermatchv99MP),    
	   
				@maxbetv161			= ISNULL(MAX(CASE WHEN SportType = 161 AND Bettype = 1 THEN MaxBet ELSE NULL END),@maxbetv161),    
				@maxpermatchv161	= ISNULL(MAX(CASE WHEN SportType = 161 AND Bettype = 1 THEN MaxPerMatch ELSE NULL END),@maxpermatchv161),    
				@maxperballv161		= ISNULL(MAX(CASE WHEN SportType = 161 AND Bettype = 1 THEN MaxPerBall ELSE NULL END),@maxperballv161)
		 FROM Dep_CustBetLimit_Special WITH(NOLOCK) 
		 WHERE Site = @site AND CurrencyID = @currency AND AgentID IS NULL    
	END    
	    
	INSERT INTO @custgametype(gametypeid, maxbet, maxpergametype)    
	SELECT gametypeid, maxbet, maxpergametype     
	FROM Dep_CustBetLimitGameType_Special WITH (NOLOCK)     
	WHERE site = @site AND currencyid=@currency    
	--End Hardcode  
	 
	SELECT    
		 @playerdiscount = 0,    
		 @playerdiscountcs = 0,    
		 @playerdiscount1x2 = 0,  
		 @v161playerdiscount= 0, -- for number game    
		 --Keno    
		 @v202playerdiscount_1501 = 0    
	    
	--Position Taking get from Affilate Account    
	IF ISNULL(@AffiliateID,0) > 0    
	BEGIN    
		IF NOT exists(select 1 from DBAFF12BET.[Affiliate_12Bet].dbo.AffInfo with(nolock) where AffID = @AffiliateID)      
		BEGIN    
			Select @ErrMsg = 'Invalid Affiliate agent.', @ErrCode = 12    
			RETURN    
		END     
	END    
	    
	    
	SELECT @apositiontaking_1		= MAX(CASE WHEN bettype = 1 AND sporttype = 1 AND isLive = 0 THEN apositiontaking ELSE 0 END)    
		  ,@apositiontaking_2		= MAX(CASE WHEN bettype = 2 AND sporttype = 1 AND isLive = 0 THEN apositiontaking ELSE 0 END)    
		  ,@apositiontaking_3		= MAX(CASE WHEN bettype = 3 AND sporttype = 1 AND isLive = 0 THEN apositiontaking ELSE 0 END)    
		  ,@apositiontaking_4		= MAX(CASE WHEN bettype = 4 AND sporttype = 1 AND isLive = 0 THEN apositiontaking ELSE 0 END)    
		  ,@apositiontaking_5		= MAX(CASE WHEN bettype = 5 AND sporttype = 1 AND isLive = 0 THEN apositiontaking ELSE 0 END)    
		  ,@apositiontaking_6		= MAX(CASE WHEN bettype = 6 AND sporttype = 1 AND isLive = 0 THEN apositiontaking ELSE 0 END)    
		  ,@apositiontaking_7		= MAX(CASE WHEN bettype = 7 AND sporttype = 1 AND isLive = 0 THEN apositiontaking ELSE 0 END)    
		  ,@apositiontaking_8		= MAX(CASE WHEN bettype = 8 AND sporttype = 1 AND isLive = 0 THEN apositiontaking ELSE 0 END)    
		  ,@apositiontaking_9		= MAX(CASE WHEN bettype = 9 AND sporttype = 1 AND isLive = 0 THEN apositiontaking ELSE 0 END)    
		  ,@apositiontaking_10		= MAX(CASE WHEN bettype = 10 AND sporttype= 1 AND isLive = 0 THEN apositiontaking ELSE 0 END)    
	      
		  ,@mpositiontaking_1		= MAX(CASE WHEN bettype = 1 AND sporttype = 1 AND isLive = 0 THEN mpositiontaking ELSE 0 END)    
		  ,@mpositiontaking_2		= MAX(CASE WHEN bettype = 2 AND sporttype = 1 AND isLive = 0 THEN mpositiontaking ELSE 0 END)    
		  ,@mpositiontaking_3		= MAX(CASE WHEN bettype = 3 AND sporttype = 1 AND isLive = 0 THEN mpositiontaking ELSE 0 END)    
		  ,@mpositiontaking_4		= MAX(CASE WHEN bettype = 4 AND sporttype = 1 AND isLive = 0 THEN mpositiontaking ELSE 0 END)    
		  ,@mpositiontaking_5		= MAX(CASE WHEN bettype = 5 AND sporttype = 1 AND isLive = 0 THEN mpositiontaking ELSE 0 END)    
		  ,@mpositiontaking_6		= MAX(CASE WHEN bettype = 6 AND sporttype = 1 AND isLive = 0 THEN mpositiontaking ELSE 0 END)    
		  ,@mpositiontaking_7		= MAX(CASE WHEN bettype = 7 AND sporttype = 1 AND isLive = 0 THEN mpositiontaking ELSE 0 END)    
		  ,@mpositiontaking_8		= MAX(CASE WHEN bettype = 8 AND sporttype = 1 AND isLive = 0 THEN mpositiontaking ELSE 0 END)    
		  ,@mpositiontaking_9		= MAX(CASE WHEN bettype = 9 AND sporttype = 1 AND isLive = 0 THEN mpositiontaking ELSE 0 END)    
		  ,@mpositiontaking_10		= MAX(CASE WHEN bettype = 10 AND sporttype= 1 AND isLive = 0 THEN mpositiontaking ELSE 0 END)    
	      
		  ,@alivepositiontaking_1	= MAX(CASE WHEN bettype = 1 AND sporttype = 1 AND isLive = 1 THEN apositiontaking ELSE 0 END)    
		  ,@alivepositiontaking_3	= MAX(CASE WHEN bettype = 3 AND sporttype = 1 AND isLive = 1 THEN apositiontaking ELSE 0 END)    
		  ,@alivepositiontaking_7	= MAX(CASE WHEN bettype = 7 AND sporttype = 1 AND isLive = 1 THEN apositiontaking ELSE 0 END)    
		  ,@alivepositiontaking_8	= MAX(CASE WHEN bettype = 8 AND sporttype = 1 AND isLive = 1 THEN apositiontaking ELSE 0 END)    
	      
		  ,@mlivepositiontaking_1	= MAX(CASE WHEN bettype = 1 AND sporttype = 1 AND isLive = 1 THEN mpositiontaking ELSE 0 END)    
		  ,@mlivepositiontaking_3	= MAX(CASE WHEN bettype = 3 AND sporttype = 1 AND isLive = 1 THEN mpositiontaking ELSE 0 END)    
		  ,@mlivepositiontaking_7	= MAX(CASE WHEN bettype = 7 AND sporttype = 1 AND isLive = 1 THEN mpositiontaking ELSE 0 END)    
		  ,@mlivepositiontaking_8	= MAX(CASE WHEN bettype = 8 AND sporttype = 1 AND isLive = 1 THEN mpositiontaking ELSE 0 END)    
	      
		  ,@v2apositiontaking_1		= MAX(CASE WHEN bettype = 1 AND sporttype = 2 AND isLive = 0 THEN apositiontaking ELSE 0 END)    
		  ,@v2apositiontaking_2		= MAX(CASE WHEN bettype = 2 AND sporttype = 2 AND isLive = 0 THEN apositiontaking ELSE 0 END)    
		  ,@v2apositiontaking_3		= MAX(CASE WHEN bettype = 3 AND sporttype = 2 AND isLive = 0 THEN apositiontaking ELSE 0 END)    
		  ,@v2apositiontaking_7		= MAX(CASE WHEN bettype = 7 AND sporttype = 2 AND isLive = 0 THEN apositiontaking ELSE 0 END)    
		  ,@v2apositiontaking_8		= MAX(CASE WHEN bettype = 8 AND sporttype = 2 AND isLive = 0 THEN apositiontaking ELSE 0 END)    
		  ,@v2apositiontaking_20	= MAX(CASE WHEN bettype = 20 AND sporttype= 2 AND isLive = 0 THEN apositiontaking ELSE 0 END)    
	      
		  ,@v2mpositiontaking_1		= MAX(CASE WHEN bettype = 1 AND sporttype = 2 AND isLive = 0 THEN mpositiontaking ELSE 0 END)    
		  ,@v2mpositiontaking_2		= MAX(CASE WHEN bettype = 2 AND sporttype = 2 AND isLive = 0 THEN mpositiontaking ELSE 0 END)     
		  ,@v2mpositiontaking_3		= MAX(CASE WHEN bettype = 3 AND sporttype = 2 AND isLive = 0 THEN mpositiontaking ELSE 0 END)     
		  ,@v2mpositiontaking_7		= MAX(CASE WHEN bettype = 7 AND sporttype = 2 AND isLive = 0 THEN mpositiontaking ELSE 0 END)     
		  ,@v2mpositiontaking_8		= MAX(CASE WHEN bettype = 8 AND sporttype = 2 AND isLive = 0 THEN mpositiontaking ELSE 0 END)     
		  ,@v2mpositiontaking_20	= MAX(CASE WHEN bettype = 20 AND sporttype= 2 AND isLive = 0 THEN mpositiontaking ELSE 0 END)      
	      
		  ,@v3apositiontaking_1		= MAX(CASE WHEN bettype = 1 AND sporttype = 3 AND isLive = 0 THEN apositiontaking ELSE 0 END)    
		  ,@v3apositiontaking_2		= MAX(CASE WHEN bettype = 2 AND sporttype = 3 AND isLive = 0 THEN apositiontaking ELSE 0 END)    
		  ,@v3apositiontaking_3		= MAX(CASE WHEN bettype = 3 AND sporttype = 3 AND isLive = 0 THEN apositiontaking ELSE 0 END)    
		  ,@v3apositiontaking_20	= MAX(CASE WHEN bettype = 20 AND sporttype= 3 AND isLive = 0 THEN apositiontaking ELSE 0 END)    
	      
		  ,@v3mpositiontaking_1		= MAX(CASE WHEN bettype = 1 AND sporttype = 3 AND isLive = 0 THEN mpositiontaking ELSE 0 END)    
		  ,@v3mpositiontaking_2		= MAX(CASE WHEN bettype = 2 AND sporttype = 3 AND isLive = 0 THEN mpositiontaking ELSE 0 END)    
		  ,@v3mpositiontaking_3		= MAX(CASE WHEN bettype = 3 AND sporttype = 3 AND isLive = 0 THEN mpositiontaking ELSE 0 END)    
		  ,@v3mpositiontaking_20	= MAX(CASE WHEN bettype = 20 AND sporttype= 3 AND isLive = 0 THEN mpositiontaking ELSE 0 END)    
	      
		  ,@v5apositiontaking_1		= MAX(CASE WHEN bettype = 1 AND sporttype = 5 AND isLive = 0 THEN apositiontaking ELSE 0 END)     
		  ,@v5apositiontaking_2		= MAX(CASE WHEN bettype = 2 AND sporttype = 5 AND isLive = 0 THEN apositiontaking ELSE 0 END)     
		  ,@v5apositiontaking_3		= MAX(CASE WHEN bettype = 3 AND sporttype = 5 AND isLive = 0 THEN apositiontaking ELSE 0 END)     
		  ,@v5apositiontaking_20	= MAX(CASE WHEN bettype = 20 AND sporttype= 5 AND isLive = 0 THEN apositiontaking ELSE 0 END)     
	      
		  ,@v5mpositiontaking_1		= MAX(CASE WHEN bettype = 1 AND sporttype = 5 AND isLive = 0 THEN mpositiontaking ELSE 0 END)     
		  ,@v5mpositiontaking_2		= MAX(CASE WHEN bettype = 2 AND sporttype = 5 AND isLive = 0 THEN mpositiontaking ELSE 0 END)    
		  ,@v5mpositiontaking_3		= MAX(CASE WHEN bettype = 3 AND sporttype = 5 AND isLive = 0 THEN mpositiontaking ELSE 0 END)    
		  ,@v5mpositiontaking_20	= MAX(CASE WHEN bettype = 20 AND sporttype= 5 AND isLive = 0 THEN mpositiontaking ELSE 0 END)    
	      
		  ,@v8apositiontaking_1		= MAX(CASE WHEN bettype = 1 AND sporttype = 8 AND isLive = 0 THEN apositiontaking ELSE 0 END)      
		  ,@v8apositiontaking_3		= MAX(CASE WHEN bettype = 3 AND sporttype = 8 AND isLive = 0 THEN apositiontaking ELSE 0 END)     
		  ,@v8apositiontaking_20	= MAX(CASE WHEN bettype = 20 AND sporttype= 8 AND isLive = 0 THEN apositiontaking ELSE 0 END)     
	    
		  ,@v8mpositiontaking_1		= MAX(CASE WHEN bettype = 1 AND sporttype = 8 AND isLive = 0 THEN mpositiontaking ELSE 0 END)      
		  ,@v8mpositiontaking_3		= MAX(CASE WHEN bettype = 3 AND sporttype = 8 AND isLive = 0 THEN mpositiontaking ELSE 0 END)      
		  ,@v8mpositiontaking_20	= MAX(CASE WHEN bettype = 20 AND sporttype= 8 AND isLive = 0 THEN mpositiontaking ELSE 0 END)     
	      
		  ,@v10apositiontaking_1	= MAX(CASE WHEN bettype = 1 AND sporttype = 10 AND isLive = 0 THEN apositiontaking ELSE 0 END)       
		  ,@v10apositiontaking_2	= MAX(CASE WHEN bettype = 2 AND sporttype = 10 AND isLive = 0 THEN apositiontaking ELSE 0 END)      
		  ,@v10apositiontaking_3	= MAX(CASE WHEN bettype = 3 AND sporttype = 10 AND isLive = 0 THEN apositiontaking ELSE 0 END)      
		  ,@v10apositiontaking_20	= MAX(CASE WHEN bettype = 20 AND sporttype= 10 AND isLive = 0 THEN apositiontaking ELSE 0 END)      
	      
		  ,@v10mpositiontaking_1	= MAX(CASE WHEN bettype = 1 AND sporttype = 10 AND isLive = 0 THEN mpositiontaking ELSE 0 END)      
		  ,@v10mpositiontaking_2	= MAX(CASE WHEN bettype = 2 AND sporttype = 10 AND isLive = 0 THEN mpositiontaking ELSE 0 END)      
		  ,@v10mpositiontaking_3	= MAX(CASE WHEN bettype = 3 AND sporttype = 10 AND isLive = 0 THEN mpositiontaking ELSE 0 END)      
		  ,@v10mpositiontaking_20	= MAX(CASE WHEN bettype = 20 AND sporttype= 10 AND isLive = 0 THEN mpositiontaking ELSE 0 END)      
	      
		  ,@v11apositiontaking_1	= MAX(CASE WHEN bettype = 1 AND sporttype = 11 AND isLive = 0 THEN apositiontaking ELSE 0 END)      
		  ,@v11apositiontaking_20	= MAX(CASE WHEN bettype = 20 AND sporttype= 11 AND isLive = 0 THEN apositiontaking ELSE 0 END)      
	  
		  ,@v11mpositiontaking_1	= MAX(CASE WHEN bettype = 1 AND sporttype = 11 AND isLive = 0 THEN mpositiontaking ELSE 0 END)      
		  ,@v11mpositiontaking_20	= MAX(CASE WHEN bettype = 20 AND sporttype= 11 AND isLive = 0 THEN mpositiontaking ELSE 0 END)      
		
		  ,@v99apositiontaking_1	= MAX(CASE WHEN bettype = 1 AND sporttype = 99 AND isLive = 0 THEN apositiontaking ELSE 0 END)      
		  ,@v99apositiontaking_2	= MAX(CASE WHEN bettype = 2 AND sporttype = 99 AND isLive = 0 THEN apositiontaking ELSE 0 END)      
		  ,@v99apositiontaking_3	= MAX(CASE WHEN bettype = 3 AND sporttype = 99 AND isLive = 0 THEN apositiontaking ELSE 0 END)      
		  ,@v99apositiontaking_9	= MAX(CASE WHEN bettype = 9 AND sporttype = 99 AND isLive = 0 THEN apositiontaking ELSE 0 END)      
		  ,@v99apositiontaking_20	= MAX(CASE WHEN bettype = 20 AND sporttype= 99 AND isLive = 0 THEN apositiontaking ELSE 0 END)      
	      
		  ,@v99mpositiontaking_1	= MAX(CASE WHEN bettype = 1 AND sporttype = 99 AND isLive = 0 THEN mpositiontaking ELSE 0 END)      
		  ,@v99mpositiontaking_2	= MAX(CASE WHEN bettype = 2 AND sporttype = 99 AND isLive = 0 THEN mpositiontaking ELSE 0 END)      
		  ,@v99mpositiontaking_3	= MAX(CASE WHEN bettype = 3 AND sporttype = 99 AND isLive = 0 THEN mpositiontaking ELSE 0 END)      
		  ,@v99mpositiontaking_9	= MAX(CASE WHEN bettype = 9 AND sporttype = 99 AND isLive = 0 THEN mpositiontaking ELSE 0 END)      
		  ,@v99mpositiontaking_20	= MAX(CASE WHEN bettype = 20 AND sporttype= 99 AND isLive = 0 THEN mpositiontaking ELSE 0 END)      
	FROM Dep_Custsetting WITH(NOLOCK)    
	WHERE custid = @recommend AND bettype IN (1,2,3,4,5,6,7,8,9,10,20) AND sporttype IN (1,2,3,5,8,10,11,99)    
	    
	SELECT 
		   @v161apositiontaking_81		= MAX(CASE WHEN bettype = 81 AND sporttype = 161 AND isLive = 0 THEN apositiontaking ELSE 0 END)     
		  ,@v161apositiontaking_83		= MAX(CASE WHEN bettype = 83 AND sporttype = 161 AND isLive = 0 THEN apositiontaking ELSE 0 END)     
		  ,@v161apositiontaking_86		= MAX(CASE WHEN bettype = 86 AND sporttype = 161 AND isLive = 0 THEN apositiontaking ELSE 0 END)     
		  ,@v161apositiontaking_88		= MAX(CASE WHEN bettype = 88 AND sporttype = 161 AND isLive = 0 THEN apositiontaking ELSE 0 END)     
	      
		  ,@v161mpositiontaking_81		= MAX(CASE WHEN bettype = 81 AND sporttype = 161 AND isLive = 0 THEN mpositiontaking ELSE 0 END)     
		  ,@v161mpositiontaking_83		= MAX(CASE WHEN bettype = 83 AND sporttype = 161 AND isLive = 0 THEN mpositiontaking ELSE 0 END)     
		  ,@v161mpositiontaking_86		= MAX(CASE WHEN bettype = 86 AND sporttype = 161 AND isLive = 0 THEN mpositiontaking ELSE 0 END)     
		  ,@v161mpositiontaking_88		= MAX(CASE WHEN bettype = 88 AND sporttype = 161 AND isLive = 0 THEN mpositiontaking ELSE 0 END)     
	      
		  ,@v161alivepositiontaking_85	= MAX(CASE WHEN bettype = 85 AND sporttype = 161 AND isLive = 1 THEN apositiontaking ELSE 0 END)     
		  ,@v161alivepositiontaking_86	= MAX(CASE WHEN bettype = 86 AND sporttype = 161 AND isLive = 1 THEN apositiontaking ELSE 0 END)     
		  ,@v161alivepositiontaking_87	= MAX(CASE WHEN bettype = 87 AND sporttype = 161 AND isLive = 1 THEN apositiontaking ELSE 0 END)     
		  ,@v161alivepositiontaking_89	= MAX(CASE WHEN bettype = 89 AND sporttype = 161 AND isLive = 1 THEN apositiontaking ELSE 0 END)     
		  ,@v161alivepositiontaking_90	= MAX(CASE WHEN bettype = 90 AND sporttype = 161 AND isLive = 1 THEN apositiontaking ELSE 0 END)     
	      
		  ,@v161mlivepositiontaking_85	= MAX(CASE WHEN bettype = 85 AND sporttype = 161 AND isLive = 1 THEN mpositiontaking ELSE 0 END)    
		  ,@v161mlivepositiontaking_86	= MAX(CASE WHEN bettype = 86 AND sporttype = 161 AND isLive = 1 THEN mpositiontaking ELSE 0 END)    
		  ,@v161mlivepositiontaking_87	= MAX(CASE WHEN bettype = 87 AND sporttype = 161 AND isLive = 1 THEN mpositiontaking ELSE 0 END)    
		  ,@v161mlivepositiontaking_89	= MAX(CASE WHEN bettype = 89 AND sporttype = 161 AND isLive = 1 THEN mpositiontaking ELSE 0 END)    
		  ,@v161mlivepositiontaking_90	= MAX(CASE WHEN bettype = 90 AND sporttype = 161 AND isLive = 1 THEN mpositiontaking ELSE 0 END)    
	FROM Dep_Custsetting3rd WITH(NOLOCK)    
	WHERE custid = @recommend AND bettype IN (81,83,85,86,87,88,89,90) AND sporttype = 161
	    
	--- Keno    
	SELECT   @v202apositiontaking_1501 = MAX(CASE WHEN bettype = 1501 AND sporttype = 202 THEN apositiontaking ELSE 0 END)     
			,@v202mpositiontaking_1501 = MAX(CASE WHEN bettype = 1501 AND sporttype = 202 THEN mpositiontaking ELSE 0 END)     
	FROM custsettinggame with(nolock)     
	WHERE custid = @recommend AND bettype = 1501 AND sporttype =202
	    
	----INSERT MEMBER ---------------------------------------------------------------    
	----Check an account disabled or not     
	--EXEC dbo.Acc_CustomerSelCheckEnable @custid = @recommend, @ErrCode=@ErrCode output,@ErrMsg=@ErrMsg output     
	--if @ErrCode <>0 return     
	     
	DECLARE @ErrType VARCHAR(4000)     
	SELECT @ErrCode = 0    	   	  
	    
	SELECT @spositiontaking_1 = 0, @slivepositiontaking_1 = 0    
	SELECT @spositiontaking_3 = 0, @slivepositiontaking_3 = 0      
	SELECT @spositiontaking_7 = 0, @slivepositiontaking_7 = 0      
	SELECT @spositiontaking_8 = 0, @slivepositiontaking_8 = 0     
	SELECT @spositiontaking_2 = 0     
	SELECT @spositiontaking_4 = 0     
	    
	SELECT @spositiontaking_5 = 0     
	SELECT @spositiontaking_6 = 0     
	SELECT @spositiontaking_9 = 0     
	SELECT @spositiontaking_10 = 0    
	    
	SELECT @v2spositiontaking_1 = 0     
	SELECT @v2spositiontaking_2 = 0     
	SELECT @v2spositiontaking_3 = 0     
	SELECT @v2spositiontaking_7 = 0     
	SELECT @v2spositiontaking_8 = 0     
	--select @v2spositiontaking_9 = 0     
	SELECT @v2spositiontaking_20 = 0     
	    
	SELECT @v3spositiontaking_1 = 0     
	SELECT @v3spositiontaking_2 = 0     
	SELECT @v3spositiontaking_3 = 0     
	SELECT @v3spositiontaking_20 = 0    
	    
	SELECT @v5spositiontaking_1 = 0    
	SELECT @v5spositiontaking_2 = 0     
	SELECT @v5spositiontaking_3 = 0     
	SELECT @v5spositiontaking_20 = 0     
	    
	SELECT @v8spositiontaking_1 = 0     
	SELECT @v8spositiontaking_3 = 0     
	SELECT @v8spositiontaking_20 = 0     
	    
	SELECT @v10spositiontaking_1 = 0     
	SELECT @v10spositiontaking_2 = 0    
	SELECT @v10spositiontaking_3 = 0     
	SELECT @v10spositiontaking_20 = 0    
	    
	SELECT @v11spositiontaking_1 = 0    
	SELECT @v11spositiontaking_20 = 0    

	SELECT @v99spositiontaking_1 = 0    
	SELECT @v99spositiontaking_2 = 0    
	SELECT @v99spositiontaking_3 = 0    
	SELECT @v99spositiontaking_9 = 0    
	SELECT @v99spositiontaking_20 = 0    
	
	SELECT @v161spositiontaking_81 = 0    
	SELECT @v161spositiontaking_83 = 0    
	SELECT @v161spositiontaking_88 = 0    
	SELECT @v161slivepositiontaking_85 = 0    
	SELECT @v161spositiontaking_86 = 0, @v161slivepositiontaking_86 = 0    
	SELECT @v161slivepositiontaking_87 = 0     
	SELECT @v161slivepositiontaking_89 = 0     
	SELECT @v161slivepositiontaking_90 = 0     	    
	
	SELECT @v202spositiontaking_1501 = 0    
	    
	SELECT @adiscount	= MAX(CASE WHEN bettype = 1 THEN adiscount ELSE 0 END)    
		  ,@adiscountcs = MAX(CASE WHEN bettype = 4 THEN adiscount ELSE 0 END)    
		  ,@adiscount1x2= MAX(CASE WHEN bettype = 5 THEN adiscount ELSE 0 END)    	 
	FROM Dep_CustSetting WITH(NOLOCK)    
	WHERE custid = @mrecommend AND sporttype =1 AND bettype IN (1,4,5) AND isLive = 0    	    	    
	    
	SELECT     
	   @v161adiscount   = MAX(CASE WHEN sporttype = 161 AND bettype = 81 THEN adiscount ELSE 0 END)    
	FROM Dep_CustSetting3rd WITH(NOLOCK)    
	WHERE custid = @mrecommend AND islive=0 AND bettype =81 AND sporttype =161   

	--- Keno    
	SELECT @v202adiscount_1501 = MAX(CASE WHEN sporttype = 202 AND bettype = 1501 THEN adiscount ELSE 0 END)     
	FROM custsettinggame WITH (NOLOCK)     
	WHERE custid = @mrecommend AND bettype = 1501 AND sporttype = 202
	    
	SELECT @sdiscount	= MAX(CASE WHEN bettype = 1 THEN sdiscount ELSE 0 END)    
		  ,@sdiscountcs = MAX(CASE WHEN bettype = 4 THEN sdiscount ELSE 0 END)    
		  ,@sdiscount1x2= MAX(CASE WHEN bettype = 5 THEN sdiscount ELSE 0 END)   	  
	FROM Dep_CustSetting WITH(NOLOCK)    
	WHERE custid = @srecommend AND sporttype =1 AND bettype IN (1,4,5) AND isLive = 0    
	    
	SELECT     
		@v161sdiscount  = MAX(CASE WHEN sporttype = 161 AND bettype = 81 THEN sdiscount ELSE 0 END)    
	FROM Dep_CustSetting3rd WITH(NOLOCK)    
	WHERE custid = @srecommend AND islive=0 AND bettype =81 AND sporttype =161

	--- Keno    
	SELECT  @v202sdiscount_1501 = MAX(CASE WHEN sporttype = 202 AND bettype = 1501 THEN sdiscount ELSE 0 END)      
	FROM custsettinggame with (nolock)     
	WHERE custid = @srecommend AND bettype = 1501 AND sporttype =202   
	    
	SELECT    
		 @playerdiscount = case when @playerdiscount > @adiscount then @adiscount else @playerdiscount end,    
		 @playerdiscountcs = case when @playerdiscountcs > @adiscountcs then @adiscountcs else @playerdiscountcs end,    
		 --1x2    
		 @playerdiscount1x2 = case when @playerdiscount1x2 > @adiscount1x2 then @adiscount1x2 else @playerdiscount1x2 end,    
	
		 --v161    
		 @v161playerdiscount= case when @v161playerdiscount> @v161discount then @v161discount else @v161playerdiscount end,    
	 
		 ---  Keno    
		 @v202playerdiscount_1501 = case when @v202playerdiscount_1501 > @v202discount_1501 then @v202discount_1501 else @v202playerdiscount_1501 end    
	     
	-- NOTE : agent can set discount to member more than what he get.   but should not more than Master discount    
	-- which normally Master is get FULL discount from company  (Later might need to detect at SUPERAGENT level    
	    
	SET ANSI_WARNINGS OFF    
	    
	SELECT @MinMinBet		= ISNULL(MAX(CASE WHEN sporttype = 1 AND bettype = 1 AND minbet <> 0 THEN minbet ELSE NULL END),0)    
		  ,@MaxMaxBet		= ISNULL(MIN(CASE WHEN sporttype = 1 AND bettype = 1 AND maxbet <> 0 THEN maxbet ELSE NULL END),0)    
		  ,@MinMinBetv2		= ISNULL(MAX(CASE WHEN sporttype = 2 AND bettype = 1 AND minbet <> 0 THEN minbet ELSE NULL END),0)    
		  ,@MaxMaxBetv2		= ISNULL(MIN(CASE WHEN sporttype = 2 AND bettype = 1 AND maxbet <> 0 THEN maxbet ELSE NULL END),0)    
		  ,@MinMinBetv3		= ISNULL(MAX(CASE WHEN sporttype = 3 AND bettype = 1 AND minbet <> 0 THEN minbet ELSE NULL END),0)    
		  ,@MaxMaxBetv3		= ISNULL(MIN(CASE WHEN sporttype = 3 AND bettype = 1 AND maxbet <> 0 THEN maxbet ELSE NULL END),0)    
		  ,@MinMinBetv5		= ISNULL(MAX(CASE WHEN sporttype = 5 AND bettype = 1 AND minbet <> 0 THEN minbet ELSE NULL END),0)    
		  ,@MaxMaxBetv5		= ISNULL(MIN(CASE WHEN sporttype = 5 AND bettype = 1 AND maxbet <> 0 THEN maxbet ELSE NULL END),0)    
		  ,@MinMinBetv8		= ISNULL(MAX(CASE WHEN sporttype = 8 AND bettype = 1 AND minbet <> 0 THEN minbet ELSE NULL END),0)    
		  ,@MaxMaxBetv8		= ISNULL(MIN(CASE WHEN sporttype = 8 AND bettype = 1 AND maxbet <> 0 THEN maxbet ELSE NULL END),0)    
		  ,@MinMinBetv10	= ISNULL(MAX(CASE WHEN sporttype = 10 AND bettype = 1 AND minbet <> 0 THEN minbet ELSE NULL END),0)    
		  ,@MaxMaxBetv10	= ISNULL(MIN(CASE WHEN sporttype = 10 AND bettype = 1 AND maxbet <> 0 THEN maxbet ELSE NULL END),0)    
		  ,@MinMinBetv11	= ISNULL(MAX(CASE WHEN sporttype = 11 AND bettype = 1 AND minbet <> 0 THEN minbet ELSE NULL END),0)    
		  ,@MaxMaxBetv11	= ISNULL(MIN(CASE WHEN sporttype = 11 AND bettype = 1 AND maxbet <> 0 THEN maxbet ELSE NULL END),0)    		
		  ,@MinMinBetv99	= ISNULL(MAX(CASE WHEN sporttype = 99 AND bettype = 1 AND minbet <> 0 THEN minbet ELSE NULL END),0)    
		  ,@MaxMaxBetv99	= ISNULL(MIN(CASE WHEN sporttype = 99 AND bettype = 1 AND maxbet <> 0 THEN maxbet ELSE NULL END),0)    
		  
		  ,@MinMinBetv1MP	= ISNULL(MAX(CASE WHEN sporttype = 1 AND bettype = 9 AND minbet <> 0 THEN minbet ELSE NULL END),0)    
		  ,@MaxMaxBetv1MP	= ISNULL(MIN(CASE WHEN sporttype = 1 AND bettype = 9 AND maxbet <> 0 THEN maxbet ELSE NULL END),0)    	   
		  
		  ,@MinMinBetv99MP	= ISNULL(MAX(CASE WHEN sporttype = 99 AND bettype = 9 AND minbet <> 0 THEN minbet ELSE NULL END),0)    
		  ,@MaxMaxBetv99MP	= ISNULL(MIN(CASE WHEN sporttype = 99 AND bettype = 9 AND maxbet <> 0 THEN maxbet ELSE NULL END),0)    	   
	FROM Dep_Custsetting cs WITH(NOLOCK)    
		INNER JOIN custinfo ci WITH(NOLOCK) ON (cs.custid = ci.custid or cs.custid = ci.mrecommend or cs.custid = ci.srecommend)    
	WHERE ci.custid = @recommend AND cs.bettype IN (1,3,9) AND cs.sporttype IN (1,2,3,5,8,10,11,99) and cs.islive = 0    
	    
	SELECT   @MinMinBetv161  = ISNULL(MAX(CASE WHEN sporttype = 161 AND bettype = 81 AND minbet <> 0 THEN minbet ELSE NULL END),0)    
			,@MaxMaxBetv161  = ISNULL(MIN(CASE WHEN sporttype = 161 AND bettype = 81 AND maxbet <> 0 THEN maxbet ELSE NULL END),0)    	    
	FROM Dep_CustSetting3rd cs WITH (NOLOCK)    
		INNER JOIN custinfo ci WITH (NOLOCK) on (cs.CustID = ci.CustID or cs.CustID = ci.MRecommend or cs.CustID = ci.SRecommend)     
	WHERE ci.custid = @recommend AND cs.bettype = 81 and cs.sporttype = 161   
	    
	SELECT     
		 @MaxMaxperMatch		= IsNull(Min(case when cs.MaxPerMatch = 0 then NULL else cs.MaxPerMatch end),0),     
		 @MaxMaxPerMatchv2		= IsNull(Min(case when cs.MaxPerMatch2 = 0 then NULL else cs.MaxPerMatch2 end),0),    
		 @MaxMaxPerMatchv3		= IsNull(Min(case when cs.MaxPerMatch3 = 0 then NULL else cs.MaxPerMatch3 end),0),    
		 @MaxMaxPerMatchv5		= IsNull(Min(case when cs.MaxPerMatch5 = 0 then NULL else cs.MaxPerMatch5 end),0),    
		 @MaxMaxPerMatchv8		= IsNull(Min(case when cs.MaxPerMatch8 = 0 then NULL else cs.MaxPerMatch8 end),0),    
		 @MaxMaxPerMatchv10		= IsNull(Min(case when cs.MaxPerMatch10 = 0 then NULL else cs.MaxPerMatch10 end),0),    
		 @MaxMaxPerMatchv11		= IsNull(Min(case when cs.MaxPerMatch11 = 0 then NULL else cs.MaxPerMatch11 end),0), 
		 
		 @MaxMaxPerMatchv99		= IsNull(Min(case when cs.MaxPerMatch99 = 0 then NULL else cs.MaxPerMatch99 end),0),    
		 -- parlay mixed sports    
		 @MaxMaxPerMatchv1MP	= isnull(Min(case when cs.MaxPerMatch1MP = 0 then NULL else cs.MaxPerMatch1MP end),0),    
		 @MaxMaxPerMatchv99MP	= isnull(Min(case when cs.MaxPerMatch99MP = 0 then NULL else cs.MaxPerMatch99MP end),0),    
		 --Number game    
		 @MaxMaxPerMatchv161	= isnull(Min(case when cs.MaxPerMatch161 = 0 then NULL else cs.MaxPerMatch161 end),0),    
		 @MaxMaxPerBallv161		= ISNULL(MIN(CASE WHEN cs.MaxPerBall161 = 0 THEN NULL ELSE cs.MaxPerBall161 END), 0)	    
	FROM custinfo AS cs WITH (NOLOCK)     
		INNER JOIN custinfo AS ci WITH (NOLOCK) ON (cs.CustID = ci.CustID or cs.CustID = ci.MRecommend or cs.CustID = ci.SRecommend)    
	WHERE ci.custid = @Recommend    
	SET ANSI_WARNINGS ON    
	    
	SELECT @ErrType = ''    
	SELECT @ErrType = @ErrType + CASE WHEN b.sporttype = 1 AND MP =1 THEN 'Soccer Parlay' ELSE sportname END + ', '    
	FROM @tmp_Sports sports INNER JOIN    
	(    
		SELECT 1 as sporttype, 0 MP, @MinBet as MinBet, @MinMinBet as MinMinBet    
			union all select 2 as sporttype, 0 MP, @MinBetv2 as MinBet, @MinMinBetv2 as MinMinBet    
			union all select 3 as sporttype, 0 MP, @MinBetv3 as MinBet, @MinMinBetv3 as MinMinBet    
			union all select 5 as sporttype, 0 MP, @MinBetv5 as MinBet, @MinMinBetv5 as MinMinBet    
			union all select 8 as sporttype, 0 MP, @MinBetv8 as MinBet, @MinMinBetv8 as MinMinBet    
			union all select 10 as sporttype, 0 MP, @MinBetv10 as MinBet, @MinMinBetv10 as MinMinBet    
			union all select 11 as sporttype, 0 MP, @MinBetv11 as MinBet, @MinMinBetv11 as MinMinBet     
			
			union all select 99 as sporttype, 0 MP, @MinBetv99 as MinBet, @MinMinBetv99 as MinMinBet    
			--Parlay mixed     
			union all  select 1 as sporttype, 1 MP, @MinBetv1MP as MinBet, @MinMinBetv1MP as MinMinBet    
			union all  select 99 as sporttype, 0 MP, @MinBetv99MP as MinBet, @MinMinBetv99MP as MinMinBet    
	     
			--number game    
			union all select 161 as sporttype, 0 MP, @MinBetv161 as MinBet, @MinMinBetv161 as MinMinBet    	        
	) as b on sports.sporttype = b.sporttype    
	WHERE MinMinBet>0 and MinBet>0 and MinBet<MinMinBet  
	  
	IF @ErrType <>''    
	BEGIN    
		SELECT    
			@ErrMsg = 'Sorry, min bet must be equal to or greater than Super/Master/Agent min bet ('+@ErrType+').',    
			@ErrCode = 205    
		RETURN    
	END    
	    
	select @ErrType = ''    
	select @ErrType = @ErrType + CASE WHEN b.sporttype = 1 AND MP = 1 THEN 'Soccer Parlay' ELSE sportname END + ', '    
	from @tmp_Sports sports inner join    
	(    
		select 1 as sporttype, 0 MP, @MaxBet as MaxBet, @MaxMaxBet as MaxMaxBet    
	 union all select 2 as sporttype, 0 MP, @MaxBetv2 as MaxBet, @MaxMaxBetv2 as MaxMaxBet    
	 union all select 3 as sporttype, 0 MP, @MaxBetv3 as MaxBet, @MaxMaxBetv3 as MaxMaxBet    
	 union all select 5 as sporttype, 0 MP, @MaxBetv5 as MaxBet, @MaxMaxBetv5 as MaxMaxBet    
	 union all select 8 as sporttype, 0 MP, @MaxBetv8 as MaxBet, @MaxMaxBetv8 as MaxMaxBet    
	 union all select 10 as sporttype, 0 MP, @MaxBetv10 as MaxBet, @MaxMaxBetv10 as MaxMaxBet    
	 union all select 11 as sporttype, 0 MP, @MaxBetv11 as MaxBet, @MaxMaxBetv11 as MaxMaxBet     
	 
	 union all select 99 as sporttype, 0 MP, @MaxBetv99 as MaxBet, @MaxMaxBetv99 as MaxMaxBet      
	     
	 --parlay mixed sports    
	 union all select 1 as sporttype, 1 MP, @MaxBetv1MP as MaxBet, @MaxMaxBetv1MP as MaxMaxBet    
	 union all select 99 as sporttype, 0 MP, @MaxBetv99MP as MaxBet, @MaxMaxBetv99MP as MaxMaxBet    
	     
	 --number game     
	 union all select 161 as sporttype, 0 MP, @MaxBetv161 as MaxBet, @MaxMaxBetv161 as MaxMaxBet    
	) as b on sports.sporttype = b.sporttype    
	where MaxMaxBet>0 and MaxBet>0 and MaxBet>MaxMaxBet    
	if @ErrType <>''    
	BEGIN    
	 SELECT    
	  @ErrMsg = 'Sorry, max bet must be equal to or less than Master/Agent max bet ('+@ErrType+').',    
	  @ErrCode = 107    
	 return    
	END    
	    
	select @ErrType = ''    
	select @ErrType = @ErrType + CASE WHEN b.sporttype =1 AND MP = 1 THEN 'Soccer Parlay' ELSE sportname END + ', '    
	from @tmp_Sports sports inner join    
	(    
		select 1 as sporttype, 0 MP, @MaxPerMatch as MaxPerMatch, @MaxMaxPerMatch as MaxMaxPerMatch    
	 union all select 2 as sporttype, 0 MP, @MaxPerMatchv2 as MaxPerMatch, @MaxMaxPerMatchv2 as MaxMaxPerMatch    
	 union all select 3 as sporttype, 0 MP, @MaxPerMatchv3 as MaxPerMatch, @MaxMaxPerMatchv3 as MaxMaxPerMatch    
	 union all select 5 as sporttype, 0 MP, @MaxPerMatchv5 as MaxPerMatch, @MaxMaxPerMatchv5 as MaxMaxPerMatch    
	 union all select 8 as sporttype, 0 MP, @MaxPerMatchv8 as MaxPerMatch, @MaxMaxPerMatchv8 as MaxMaxPerMatch    
	 union all select 10 as sporttype, 0 MP, @MaxPerMatchv10 as MaxPerMatch, @MaxMaxPerMatchv10 as MaxMaxPerMatch    
	 union all select 11 as sporttype, 0 MP, @MaxPerMatchv11 as MaxPerMatch, @MaxMaxPerMatchv11 as MaxMaxPerMatch    
	
	 union all select 99 as sporttype, 0 MP, @MaxPerMatchv99 as MaxPerMatch, @MaxMaxPerMatchv99 as MaxMaxPerMatch    
	 --mixed sports    
	 union all select 1 as sporttype, 1 MP, @MaxPerMatchv1MP as MaxPerMatch, @MaxMaxPerMatchv1MP as MaxMaxPerMatch    
	 union all select 99 as sporttype, 0 MP, @MaxPerMatchv99MP as MaxPerMatch, @MaxMaxPerMatchv99MP as MaxMaxPerMatch    
	 --number game    
	 union all select 161 as sporttype, 0 MP, @MaxPerMatchv161 as MaxPerMatch, @MaxMaxPerMatchv161 as MaxMaxPerMatch       
	) as b on sports.sporttype = b.sporttype    
	where MaxMaxPerMatch>0 and MaxPerMatch>0 and MaxPerMatch>MaxMaxPerMatch    
	if @ErrType <>''    
	BEGIN    
	 SELECT    
	  @ErrMsg = 'Sorry, Max Per Match must be equal to or less than Master/Agent Max Per Match ('+@ErrType+').',    
	  @ErrCode = 107    
	 return    
	END    
	    
	SELECT @ErrType = ''    
	IF @MaxPerBallv161 > 0 AND @MaxMaxPerBallv161 > 0 AND @MaxPerBallv161 > @MaxMaxPerBallv161    
	BEGIN    
	 SELECT @ErrType = @ErrType + sportname     
	 from @tmp_Sports    
	 WHERE sporttype = 161    
	     
	 SELECT @ErrMsg= 'Sorry, Max Per ball must be equal to or less than Master/Agent Max Per Match ('+@ErrType+').',    
		 @ErrCode = 107    
	 RETURN    
	END    

	EXEC dbo.Acc_Dep_CustSetting_Check    
	 @custid	= @custid,    
	 @AgentID	= @AgentID,    
	 @Site		= @Site,    
	 @Currency	= @Currency,    
	 @ProductID = NULL,    
	 @SuperID	= @srecommend,    
	 @ErrCode	= @ErrCode OUTPUT,    	   
	 @ErrMsg	= @ErrMsg OUTPUT

	 IF @ErrCode<>0
		RETURN
	    
	select @pwdexpiry = dateadd(dd, 30, getdate())    
	    
	if @Aclosed = 1    
	BEGIN    
	 SELECT     
	  @ErrMsg = 'Your account was closed. Cannot add member.',     
	  @ErrCode=211    
	 return    
	END    
	    
	--check suspended of Agent     
	if @Asuspended =1 and @suspendedFlag is null    
	BEGIN    
	 set @suspended =1    
	END    
	    	
	--20140812: Change rule generate username    
	IF (@UserName NOT LIKE '%BetTrade%' AND  @UserName NOT LIKE '%CashOut%' AND  @UserName NOT LIKE '%ClearBal%' AND  @UserName NOT LIKE '%01OddsAdj%') OR @UserName IS NULL
	BEGIN  
	SELECT @UserName = dbo.f_LAS_GenerateUsername(@recommend)    
	IF @UserName = ''    
	BEGIN    
	 SELECT @ErrMsg = 'Can not generate username.'    
	  ,@ErrCode = 11    
	    
	 RETURN    
	END    
	END  
	--20080623: Add sitename prefix to the DepositUsername    
	SELECT @DepositUserName = @site + '$' + @DepositUserName    
	     
	DECLARE @IsExistsUsername BIT
	EXEC Acc_Dep_CustomerCheckExists @username = @DepositUserName, @IsExists = @IsExistsUsername OUTPUT

	--Check the unique username2
	IF @IsExistsUsername = 1
	BEGIN    
		SELECT @ErrMsg = 'The username is not available.', @ErrCode = 11    
		RETURN    
	END    
	-----------------------------------------------    
	--reset the @site param    
	select @site=case when @ugroup like 'indo_' then 'INDO' else '' end,    
	 @ugroup = case when @ugroup like 'indo_' then right(@ugroup,1) else @ugroup end    
	    
	--Insert general data     
	EXEC dbo.Dot_Dep_CustomerInsUserInfo
		@custid = @custid OUTPUT,    
		@firstname = @firstname,    
		@lastname = @lastname,    
		@creator = @recommend,    
		@username = @username,    
		@userpwd = @Password,    
		@pwdexpiry = @pwdexpiry,    
		@currency = @currency,    
		@site = @site,    
		@ugroup = @ugroup,    
		@srecommend = @srecommend,    
		@mrecommend = @mrecommend,    
		@recommend = @recommend,    
		@roleid = 1, 
	    
		@country = @Country,    
		@suspended = @suspended,    

		@matchlimit = @matchlimit,    
		@virtualmultiplier = @virtualmultiplier,    	  	 
	 
		@MaxPerMatch = @MaxPerMatch,    
		@MaxPerMatchv2 = @MaxPerMatchv2,    
		@MaxPerMatchv3 = @MaxPerMatchv3,    
		@MaxPerMatchv5 = @MaxPerMatchv5,    
		@MaxPerMatchv8 = @MaxPerMatchv8,    
		@MaxPerMatchv10 = @MaxPerMatchv10,    
		@MaxPerMatchv11 = @MaxPerMatchv11,    	
		@MaxPerMatchv99 = @MaxPerMatchv99,  
		@MaxPerMatchv1MP = @MaxPerMatchv1MP,		
		@MaxPerMatchv99MP = @MaxPerMatchv99MP,    
		@MaxPerMatchv161 = @MaxPerMatchv161,    
		@MaxPerBallv161 = @MaxPerBallv161,    
	    
		@DisableNumber = @DisableNumber,    
		@HideKeno = @HideKeno,    
	   
		@IP = '',    
		@Language = 'E',    
		@ErrCode = @ErrCode OUTPUT,    
		@ErrMsg = @ErrMsg OUTPUT    

	IF @ErrCode <> 0    
		RETURN    

	--Insert SubsidiaryID
	IF @SubsidiaryID<>0
	BEGIN
		INSERT INTO dbo.DepositCustomer (custid, SubsidiaryID)
		VALUES (@CustID, @SubsidiaryID)
	END
	     
	--print @v2mpositiontaking_20    
	INSERT INTO [dbo].[Dep_CustSetting]([custid], [bettype], [sporttype], [apositiontaking], [mpositiontaking], [spositiontaking], [playerdiscount], [discount], [adiscount], [sdiscount], [MinBet], [MaxBet], [islive])    
	select @custid, 1, 1, @apositiontaking_1, @mpositiontaking_1,@spositiontaking_1, @playerdiscount, @discount, @adiscount, @sdiscount,@MinBet, @MaxBet, 0    
	UNION ALL    
	select @custid, 1, 1, @alivepositiontaking_1, @mlivepositiontaking_1, @slivepositiontaking_1, @playerdiscount, @discount, @adiscount, @sdiscount,@MinBet, @MaxBet, 1    
	UNION ALL    
	select @custid, 3, 1, @apositiontaking_3, @mpositiontaking_3, @spositiontaking_3, @playerdiscount, @discount, @adiscount, @sdiscount, @MinBet, @MaxBet, 0    
	UNION ALL    
	select @custid, 3, 1, @alivepositiontaking_3, @mlivepositiontaking_3, @slivepositiontaking_3, @playerdiscount, @discount, @adiscount, @sdiscount, @MinBet, @MaxBet, 1    
	UNION ALL    
	select @custid, 7, 1, @apositiontaking_7, @mpositiontaking_7, @spositiontaking_7, @playerdiscount, @discount, @adiscount, @sdiscount,@MinBet, @MaxBet, 0    
	UNION ALL    
	select @custid, 7, 1, @alivepositiontaking_7, @mlivepositiontaking_7, @slivepositiontaking_7, @playerdiscount, @discount, @adiscount, @sdiscount, @MinBet, @MaxBet, 1    
	UNION ALL    
	select @custid, 8, 1, @apositiontaking_8, @mpositiontaking_8, @spositiontaking_8, @playerdiscount, @discount, @adiscount, @sdiscount,@MinBet, @MaxBet, 0    
	UNION ALL    
	select @custid, 8, 1, @alivepositiontaking_8, @mlivepositiontaking_8, @slivepositiontaking_8, @playerdiscount, @discount, @adiscount, @sdiscount, @MinBet, @MaxBet, 1    
	UNION ALL    
	select @custid, 2, 1, @apositiontaking_2, @mpositiontaking_2, @spositiontaking_2, @playerdiscount, @discount, @adiscount, @sdiscount, @MinBet, @MaxBet, 0    
	UNION ALL    
	select @custid, 4, 1, @apositiontaking_4, @mpositiontaking_4, @spositiontaking_4, @playerdiscountcs, @discountcs, @adiscountcs, @sdiscountcs,@MinBet, @MaxBet, 0    
	UNION ALL    
	select @custid, 5, 1, @apositiontaking_5, @mpositiontaking_5, @spositiontaking_5, @playerdiscount1x2, @discount1x2, @adiscount1x2, @sdiscount1x2, @MinBet, @MaxBet, 0    
	UNION ALL    
	select @custid, 6, 1, @apositiontaking_6, @mpositiontaking_6, @spositiontaking_6, @playerdiscountcs, @discountcs, @adiscountcs, @sdiscountcs, @MinBet, @MaxBet, 0    
	UNION ALL    
	select @custid, 9, 1, @apositiontaking_9, @mpositiontaking_9, @spositiontaking_9, @playerdiscountcs, @discountcs, @adiscountcs, @sdiscountcs, @MinBetv1MP, @MaxBetv1MP, 0    
	UNION ALL    
	select @custid, 10, 1, @apositiontaking_10, @mpositiontaking_10, @spositiontaking_10,@playerdiscountcs, @discountcs, @adiscountcs, @sdiscountcs,@MinBet, @MaxBet, 0    
	    
	UNION ALL    
	select @custid, 1, 2, @v2apositiontaking_1, @v2mpositiontaking_1, @v2spositiontaking_1, @playerdiscount, @discount, @adiscount, @sdiscount, @MinBetv2, @MaxBetv2, 0    
	UNION ALL    
	select @custid, 2, 2, @v2apositiontaking_2, @v2mpositiontaking_2, @v2spositiontaking_2, @playerdiscount, @discount, @adiscount, @sdiscount, @MinBetv2, @MaxBetv2, 0    
	UNION ALL    
	select @custid, 3, 2, @v2apositiontaking_3, @v2mpositiontaking_3, @v2spositiontaking_3,  @playerdiscount, @discount, @adiscount, @sdiscount, @MinBetv2, @MaxBetv2, 0    
	UNION ALL    
	select @custid, 7, 2, @v2apositiontaking_7, @v2mpositiontaking_7, @v2spositiontaking_7, @playerdiscount, @discount, @adiscount, @sdiscount, @MinBetv2, @MaxBetv2, 0    
	UNION ALL    
	select @custid, 8, 2, @v2apositiontaking_8, @v2mpositiontaking_8, @v2spositiontaking_8, @playerdiscount, @discount, @adiscount, @sdiscount, @MinBetv2, @MaxBetv2, 0    
	UNION ALL    
	select @custid, 20, 2, @v2apositiontaking_20, @v2mpositiontaking_20, @v2spositiontaking_20, @playerdiscount1x2, @discount1x2, @adiscount1x2, @sdiscount1x2, @MinBetv2, @MaxBetv2, 0    
	    
	UNION ALL    
	select @custid, 1, 3, @v3apositiontaking_1, @v3mpositiontaking_1, @v3spositiontaking_1, @playerdiscount, @discount, @adiscount, @sdiscount, @MinBetv3, @MaxBetv3, 0    
	UNION ALL    
	select @custid, 2, 3, @v3apositiontaking_2, @v3mpositiontaking_2, @v3spositiontaking_2, @playerdiscount, @discount, @adiscount, @sdiscount, @MinBetv3, @MaxBetv3, 0    
	UNION ALL    
	select @custid, 3, 3, @v3apositiontaking_3, @v3mpositiontaking_3, @v3spositiontaking_3, @playerdiscount, @discount, @adiscount, @sdiscount, @MinBetv3, @MaxBetv3, 0    
	UNION ALL    
	select @custid, 20, 3, @v3apositiontaking_20, @v3mpositiontaking_20, @v3spositiontaking_20, @playerdiscount1x2, @discount1x2, @adiscount1x2, @sdiscount1x2, @MinBetv3, @MaxBetv3, 0    
	    
	UNION ALL    
	select @custid, 1, 5, @v5apositiontaking_1, @v5mpositiontaking_1, @v5spositiontaking_1, @playerdiscount, @discount, @adiscount, @sdiscount, @MinBetv5, @MaxBetv5, 0    
	UNION ALL    
	select @custid, 2, 5, @v5apositiontaking_2, @v5mpositiontaking_2, @v5spositiontaking_2,@playerdiscount, @discount, @adiscount, @sdiscount,@MinBetv5, @MaxBetv5, 0    
	UNION ALL    
	select @custid, 3, 5, @v5apositiontaking_3, @v5mpositiontaking_3, @v5spositiontaking_3, @playerdiscount, @discount, @adiscount, @sdiscount, @MinBetv5, @MaxBetv5, 0    
	UNION ALL    
	select @custid, 20, 5, @v5apositiontaking_20, @v5mpositiontaking_20, @v5spositiontaking_20, @playerdiscount1x2, @discount1x2, @adiscount1x2, @sdiscount1x2, @MinBetv5, @MaxBetv5, 0    
	    
	UNION ALL    
	select @custid, 1, 8, @v8apositiontaking_1, @v8mpositiontaking_1, @v8spositiontaking_1, @playerdiscount, @discount, @adiscount, @sdiscount,@MinBetv8, @MaxBetv8, 0    
	UNION ALL    
	select @custid, 3, 8, @v8apositiontaking_3, @v8mpositiontaking_3, @v8spositiontaking_3, @playerdiscount, @discount, @adiscount, @sdiscount, @MinBetv8, @MaxBetv8, 0    
	UNION ALL    
	select @custid, 20, 8, @v8apositiontaking_20, @v8mpositiontaking_20, @v8spositiontaking_20, @playerdiscount1x2, @discount1x2, @adiscount1x2, @sdiscount1x2, @MinBetv8, @MaxBetv8, 0    
	    
	UNION ALL    
	select @custid, 1, 10, @v10apositiontaking_1, @v10mpositiontaking_1, @v10spositiontaking_1, @playerdiscount, @discount, @adiscount, @sdiscount, @MinBetv10, @MaxBetv10, 0    
	UNION ALL    
	select @custid, 2, 10, @v10apositiontaking_2, @v10mpositiontaking_2, @v10spositiontaking_2, @playerdiscount, @discount, @adiscount, @sdiscount, @MinBetv10, @MaxBetv10, 0    
	UNION ALL    
	select @custid, 3, 10, @v10apositiontaking_3, @v10mpositiontaking_3, @v10spositiontaking_3, @playerdiscount, @discount, @adiscount, @sdiscount, @MinBetv10, @MaxBetv10, 0    
	UNION ALL    
	select @custid, 20, 10, @v10apositiontaking_20, @v10mpositiontaking_20, @v10spositiontaking_20, @playerdiscount1x2, @discount1x2, @adiscount1x2, @sdiscount1x2, @MinBetv10, @MaxBetv10, 0    
	    
	UNION ALL    
	select @custid, 1, 11, @v11apositiontaking_1, @v11mpositiontaking_1, @v11spositiontaking_1, @playerdiscount, @discount, @adiscount, @sdiscount, @MinBetv11, @MaxBetv11, 0    
	UNION ALL    
	select @custid, 20, 11, @v11apositiontaking_20, @v11mpositiontaking_20, @v11spositiontaking_20, @playerdiscount1x2, @discount1x2, @adiscount1x2, @sdiscount1x2, @MinBetv11, @MaxBetv11, 0    
	 
	    
	UNION ALL    
	select @custid, 1, 99, @v99apositiontaking_1, @v99mpositiontaking_1, @v99spositiontaking_1, @playerdiscount, @discount, @adiscount, @sdiscount, @MinBetv99, @MaxBetv99, 0    
	UNION ALL    
	select @custid, 2, 99, @v99apositiontaking_2, @v99mpositiontaking_2, @v99spositiontaking_2, @playerdiscount, @discount, @adiscount, @sdiscount, @MinBetv99, @MaxBetv99, 0    
	UNION ALL    
	select @custid, 3, 99, @v99apositiontaking_3, @v99mpositiontaking_3, @v99spositiontaking_3, @playerdiscount, @discount, @adiscount, @sdiscount, @MinBetv99, @MaxBetv99, 0    
	UNION ALL     
	select @custid, 9, 99, @v99apositiontaking_9, @v99mpositiontaking_9, @v99spositiontaking_9, @playerdiscountcs, @discountcs, @adiscountcs, @sdiscountcs, @MinBetv99MP, @MaxBetv99MP, 0    
	UNION ALL    
	select @custid, 20, 99, @v99apositiontaking_20, @v99mpositiontaking_20, @v99spositiontaking_20, @playerdiscount1x2, @discount1x2, @adiscount1x2, @sdiscount1x2,  @MinBetv99, @MaxBetv99, 0    
	 
	--Insert into custsetting3rd    	    
	INSERT INTO [Dep_CustSetting3rd]    
			   ([custid]    
			   ,[bettype]    
			   ,[sporttype]    
			   ,[apositiontaking]    
			   ,[mpositiontaking]    
			   ,[spositiontaking]    
			   ,[playerdiscount]    
			   ,[discount]    
			   ,[adiscount]    
			   ,[sdiscount]    
			   ,[minbet]    
			   ,[maxbet]    
			   ,[islive])    	
	--v161       
	select @custid, 81, 161, @v161apositiontaking_81, @v161mpositiontaking_81, @v161spositiontaking_81, @v161playerdiscount, @v161discount, @v161adiscount, @v161sdiscount, @MinBetv161, @MaxBetv161, 0     
	UNION ALL              
	select @custid, 83, 161, @v161apositiontaking_83, @v161mpositiontaking_83, @v161spositiontaking_83, @v161playerdiscount, @v161discount, @v161adiscount, @v161sdiscount, @MinBetv161, @MaxBetv161, 0    
	UNION ALL              
	select @custid, 88, 161, @v161apositiontaking_88, @v161mpositiontaking_88, @v161spositiontaking_88, @v161playerdiscount, @v161discount, @v161adiscount, @v161sdiscount, @MinBetv161, @MaxBetv161, 0    
	UNION ALL    
	select @custid, 85, 161, @v161alivepositiontaking_85, @v161mlivepositiontaking_85, @v161slivepositiontaking_85, @v161playerdiscount, @v161discount, @v161adiscount, @v161sdiscount, @MinBetv161, @MaxBetv161, 1    
	UNION ALL    
	select @custid, 86, 161, @v161apositiontaking_86, @v161mpositiontaking_86, @v161spositiontaking_86, @v161playerdiscount, @v161discount, @v161adiscount, @v161sdiscount, @MinBetv161, @MaxBetv161, 0    
	UNION ALL    
	select @custid, 86, 161, @v161alivepositiontaking_86, @v161mlivepositiontaking_86, @v161slivepositiontaking_86, @v161playerdiscount, @v161discount, @v161adiscount, @v161sdiscount, @MinBetv161, @MaxBetv161, 1    
	UNION ALL    
	select @custid, 87 , 161, @v161alivepositiontaking_87, @v161mlivepositiontaking_87, @v161slivepositiontaking_87, @v161playerdiscount, @v161discount, @v161adiscount, @v161sdiscount, @MinBetv161, @MaxBetv161, 1    
	UNION ALL    
	select @custid, 89 , 161, @v161alivepositiontaking_89, @v161mlivepositiontaking_89, @v161slivepositiontaking_89, @v161playerdiscount, @v161discount, @v161adiscount, @v161sdiscount, @MinBetv161, @MaxBetv161, 1    
	UNION ALL    
	select @custid, 90 , 161, @v161alivepositiontaking_90, @v161mlivepositiontaking_90, @v161slivepositiontaking_90, @v161playerdiscount, @v161discount, @v161adiscount, @v161sdiscount, @MinBetv161, @MaxBetv161, 1    
	    
	if (not exists (select 1 from DepositCustomer with (NOLOCK) where custid = @custid) or
		not exists (select 1 from Dep_CustSetting with (NOLOCK) where custid = @custid) or 
		not exists (select 1 from Dep_CustSetting3rd with (NOLOCK) where custid = @custid)) or @@Error <> 0    
	BEGIN    
	 --Error occurs    
	 SELECT     
	  @ErrMsg = 'Add member fail. Please try again',    
	  @ErrCode=215    
	     
	 -- MANUALLY ROLLBACK    
	 DELETE DepositCustomer		WHERE CustID = @CustID
	 DELETE Dep_CustSetting		WHERE CustID = @CustID    
	 DELETE Dep_CustSetting3rd	WHERE CustID = @CustID 
	 EXEC Acc_CustomerInsUserInfo_Rollback @CustID = @CustID    
	 return    
	END    

	
	-- Keno    
	INSERT INTO CustSettingGame(custid, bettype, sporttype, apositiontaking, mpositiontaking, spositiontaking, playerdiscount, discount, adiscount, sdiscount)    
	SELECT @custid, 1501, 202, @v202apositiontaking_1501, @v202mpositiontaking_1501, @v202spositiontaking_1501, @v202playerdiscount_1501, @v202discount_1501, @v202adiscount_1501, @v202sdiscount_1501    
	IF @@ERROR <> 0    
	BEGIN    
	 --Error occurs    
	 SELECT     
	  @ErrMsg = 'Add member fail. Please try again',    
	  @ErrCode=218    
	    
	 -- MANUALLY ROLLBACK    
	 DELETE DepositCustomer		WHERE CustID = @CustID
	 DELETE Dep_CustSetting		WHERE CustID = @CustID    
	 DELETE Dep_CustSetting3rd	WHERE CustID = @CustID 
	 
	 DELETE CustSettingGame		WHERE CustID = @CustID    
	 EXEC Acc_CustomerInsUserInfo_Rollback @CustID = @CustID    
	 return    
	END    
	    
	-- Keno    
	INSERT INTO CustGameType (GameTypeID, CustID, MaxPerGameType, MinBet, MaxBet, IsDisabled)    
	SELECT cg.GameTypeID, @CustID, isnull(t.maxpergametype,cg.MaxPerGameType), cg.MinBet, isnull(t.maxbet,cg.MaxBet), cg.IsDisabled    
	FROM CustGameType cg WITH (NOLOCK)    
	 INNER JOIN @tmp_GameType gt ON cg.GameTypeID = gt.GameTypeID    
	 LEFT JOIN @custgametype t ON cg.GameTypeID = t.gametypeid    
	WHERE cg.CustID = @recommend AND gt.IBCBetTypeID BETWEEN 1501 AND 1599    
	IF @@ERROR <> 0    
	BEGIN    
	 --Error occurs    
	 SELECT     
	  @ErrMsg = 'Add member fail. Please try again',    
	  @ErrCode=218    
	    
	 -- MANUALLY ROLLBACK    
	 DELETE DepositCustomer		WHERE CustID = @CustID
	 DELETE Dep_CustSetting		WHERE CustID = @CustID    
	 DELETE Dep_CustSetting3rd	WHERE CustID = @CustID 
	 
	 DELETE CustSettingGame WHERE CustID = @CustID    
	 DELETE CustGameType WHERE CustID = @CustID    
	 EXEC Acc_CustomerInsUserInfo_Rollback @CustID = @CustID    
	 return    
	END
	---------------------------------------------------------------------------------    
	---- Create balance for new customer    
	--EXEC DBTXN.bodb02.dbo.Dot_BalanceInsCredit @CustID = @CustID  
	EXEC DBTXN.bodb02.dbo.Dot_BalanceCreditInitialize @CustID = @CustID, @errCode = @ErrCode OUTPUT
	 
	    
	IF @ErrCode <> 0    
	BEGIN     
	 --Error occurs    
	 SELECT     
	  @ErrMsg = 'Add member fail. Please try again',    
	  @ErrCode=215    
	     
	 -- MANUALLY ROLLBACK    
	 DELETE DepositCustomer		WHERE CustID = @CustID
	 DELETE Dep_CustSetting		WHERE CustID = @CustID    
	 DELETE Dep_CustSetting3rd	WHERE CustID = @CustID 
	 
	 DELETE CustSettingGame WHERE CustID = @CustID    
	 DELETE CustGameType WHERE CustID = @CustID    
	 EXEC DBTXN.bodb02.dbo.Dot_BalanceCreditRemove @CustID = @CustID --EXEC DBTXN.bodb02.dbo.Dot_BalanceDelCredit @CustID = @CustID
	 EXEC Acc_CustomerInsUserInfo_Rollback @CustID = @CustID    
	 return    
	END    
	    
	--EXEC DBTXN.bodb02.dbo.Dot_BalanceInsDebit @CustID = @CustID    
	EXEC DBTXN.bodb02.dbo.Dot_BalanceDebitInitialize @CustID = @CustID, @errCode = @ErrCode OUTPUT    
	    
	IF @ErrCode <> 0    
	BEGIN     
	 --Error occurs    
	 SELECT     
	  @ErrMsg = 'Add member fail. Please try again',    
	  @ErrCode=215    
	     
	 -- MANUALLY ROLLBACK    
	 DELETE DepositCustomer		WHERE CustID = @CustID
	 DELETE Dep_CustSetting		WHERE CustID = @CustID    
	 DELETE Dep_CustSetting3rd	WHERE CustID = @CustID 
	 
	 DELETE CustSettingGame WHERE CustID = @CustID    
	 DELETE CustGameType WHERE CustID = @CustID    
	 EXEC DBTXN.bodb02.dbo.Dot_BalanceCreditRemove @CustID = @CustID --EXEC DBTXN.bodb02.dbo.Dot_BalanceDelCredit @CustID = @CustID
	 EXEC DBTXN.bodb02.dbo.Dot_BalanceDebitRemove @CustID = @CustID --EXEC DBTXN.bodb02.dbo.Dot_BalanceDelDebit @CustID = @CustID    
	 EXEC Acc_CustomerInsUserInfo_Rollback @CustID = @CustID    
	 return    
	END

	/*HELEN-CUSTOMER SETTING DCS DEPOSIT-START*/
	DECLARE @DCSErrCode INT = 0
	EXEC dbo.Acc_Dep_DynamicCustSetting_00
			@CustID				= @CustID
			, @SuperID			= @srecommend
			, @MasterID			= @mrecommend
			, @AgentID			= @recommend
			, @RoleID			= 1
			, @ProductID		= NULL
			, @ErrCode			= @DCSErrCode OUTPUT
				
	IF @DCSErrCode <> 0 
	BEGIN
		 --Error occur
		 SET @ErrCode = 911
		 -- ROLLBACK MANUALLY
		 -- MANUALLY ROLLBACK    
		 DELETE DepositCustomer		WHERE CustID = @CustID
		 DELETE Dep_CustSetting		WHERE CustID = @CustID    
		 DELETE Dep_CustSetting3rd	WHERE CustID = @CustID 
	 
		
		 DELETE CustSettingGame WHERE CustID = @CustID    
		 DELETE CustGameType WHERE CustID = @CustID    
		 EXEC DBTXN.bodb02.dbo.Dot_BalanceCreditRemove @CustID = @CustID --EXEC DBTXN.bodb02.dbo.Dot_BalanceDelCredit @CustID = @CustID
		 EXEC DBTXN.bodb02.dbo.Dot_BalanceDebitRemove @CustID = @CustID --EXEC DBTXN.bodb02.dbo.Dot_BalanceDelDebit @CustID = @CustID    
		 EXEC Acc_CustomerInsUserInfo_Rollback @CustID = @CustID    
		 RETURN    
	END
	/*HELEN-CUSTOMER SETTING RENOVATION-END*/    
	    
	---------------------------------------------------------------------------------    
	UPDATE customer WITH (ROWLOCK, UPDLOCK) 
	SET  username2 = @DepositUserName,    
		 refcode2 = @DepositUserID    
	WHERE custID = @custID    
	--Bonus
	UPDATE custInfo WITH (ROWLOCK, UPDLOCK) 
	SET BonusWalletFlag=0
	WHERE custID = @custID  
	    
	SELECT @site = site FROM customer (NOLOCK) WHERE CustID = @AgentID  
	  
	--For Dela, turn member to BA    
	if @site = 'DELA'    
	BEGIN    
		SET @ErrMsg=''    
		SET @ErrCode=0    	     
		IF (SELECT EnableBA FROM bodb_licensee.dbo.LicenseeBAConfig WITH (NOLOCK) WHERE LicenseeID = 7) = 1    
		BEGIN    	    
			EXEC [Lrf_CustomerUpdMemberBAStatus]    
				@LicenseeID=7,--Dela    
				@CustID = @CustID,    
				@ModifyBy = 1, --dbaThien    
				@IsBA = 1,    
				@IP = '',    
				@ErrCode = @ErrCode OUTPUT,    
				@ErrMsg = @ErrMsg OUTPUT    
		END    
	END    
	--For Asiabet88, turn USD&EUR players   to BA : 20131230@Jim    
	    
	IF (@site = 'Asiabet88')    
	BEGIN    
	 IF EXISTS (SELECT 1 FROM dbo.Customer WITH (NOLOCK) WHERE CustID=@CustID AND Currency IN (3,6))    
	 BEGIN     
	  SET @ErrMsg=''    
	  SET @ErrCode=0    
	      
	  IF (SELECT EnableBA FROM bodb_licensee.dbo.LicenseeBAConfig WITH (NOLOCK) WHERE LicenseeID = 2) = 1    
	  BEGIN    
			EXEC [Lrf_CustomerUpdMemberBAStatus]    
				@LicenseeID=2,--Asiabet88    
				@CustID = @CustID,    
				@ModifyBy = 3, --pgmviet    
				@IsBA = 1,    
				@IP = '',    
				@ErrCode = @ErrCode OUTPUT,    
				@ErrMsg = @ErrMsg OUTPUT    
	  END    
	 END    
	END    		  
	    
	IF @AffiliateID is not NULL    
	EXEC DBAFF12BET.Affiliate_12BET.dbo.Aff_CustomerInsMember     
	 @IbcCustID = @CustID,    
	 @AffID = @AffiliateID,    
	 @Username = @DepositUserName,    
	 @IBCUsername = @Username,     
	 @DepositCustID = @DepositUserID,    
	 @FirstName = @FirstName,    
	 @LastName = @LastName,    
	 @Currency = @currency,    
	 @Recommend = @recommend,    
	 @Email = @Email    
	    
	--Set default player comm    
	EXEC bodb_Licensee.dbo.Lrf_CustomerSetDefaultComm    
	 @LicenseeName=@site,    
	 @CustID = @CustID,    
	 @ErrCode = @ErrCode OUTPUT,    
	 @ErrMsg = @ErrMsg OUTPUT     
	    
	--Set default bet setting of AG Casino    
	EXEC Lrf_AGC_Customer_SetDefaultSetting      
	 @CustID = @CustID,    
	 @SuperID = @recommend,      
	 @ErrCode = @ErrCode OUTPUT,      
	 @ErrMsg = @ErrMsg OUTPUT    
	    
	--Set default bet setting of 3rd Product    
	EXEC dbo.Lrf_3rdProductCustomerSetDefaultSetting      
	 @CustID = @CustID,    
	 @SuperID = @srecommend,      
	 @ErrCode = @ErrCode OUTPUT,      
	 @ErrMsg = @ErrMsg OUTPUT    

	--Write Info Log
	set @endRun = getdate()    
	set @duration  = datediff (millisecond,@startRun,@endRun)    
	    
	Declare @LogSPData nvarchar(4000)    
	    
	Select @LogSPData = '<Dot_Dep_CustomerInsMember_Ag_Cust custid="'+ coalesce(cast(@custid as varchar(50)),space(1)) + '" ' +    
	'fname="'+ dbo.f_EncodeXMLValue(coalesce(cast(@firstname as nvarchar(50)),space(1))) + '" ' +    
	'lname="'+ dbo.f_EncodeXMLValue(coalesce(cast(@lastname as nvarchar(50)),space(1))) + '" ' +    
	'creator="'+ coalesce(cast(@CustID as varchar(50)),space(1)) + '" ' +    
	'username="'+ coalesce(cast(@username as varchar(30)),space(1)) + '" ' +    
	'Email="'+ dbo.f_EncodeXMLValue(coalesce(cast(@Email as nvarchar(50)),space(1))) + '" ' +    
	'DepositUserName="'+ coalesce(cast(@DepositUserName as varchar(50)),space(1)) + '" ' +    
	'DepositUserID="'+ coalesce(cast(@DepositUserID as varchar(50)),space(1)) + '" ' +    
	'OddsType="'+ coalesce(cast(@OddsType as varchar(5)),space(1)) + '" ' +    
	'SubsidiaryID="'+ coalesce(cast(@SubsidiaryID as varchar(50)),space(1)) + '" ' +    
	'AgentID="'+ coalesce(cast(@AgentID as varchar(50)),space(1)) + '" ' +    
	'AffiliateID="'+ coalesce(cast(@AffiliateID as varchar(50)),space(1)) + '" ' +    
	'BonusCode="'+ coalesce(cast(@BonusCode as varchar(20)),space(1)) + '" ' +    
	'recommend="'+ coalesce(cast(@recommend as varchar(50)),space(1)) + '" ' +    
	'ugroup="'+ coalesce(cast(@ugroup as varchar(5)),space(1)) + '" ' +    
	'success="'+ coalesce(cast(@success as varchar(50)),space(1)) + '" ' +    
	'ErrCode="'+ coalesce(cast(@ErrCode as varchar(50)),space(1)) + '" ' +    
	'ErrMsg="'+ coalesce(cast(@ErrMsg as varchar(4000)),space(1)) + '" />'    
	 
	EXEC dbo.Acc_WriteLog_UserLog_RunSP_Wrapper    
	  @UserID = @CustID,    
	  @CustID = @CustID,    
	  @ActionID = 617,    
	  @TrackingValue = @LogSPData,    
	  @duration = @duration    	
	    
	--Write commission log    
	Select @LogSPData = '<Dot_Dep_CustomerInsMember_Ag_Cust custid="'+ coalesce(cast(@custid as varchar(50)),space(1)) + '" ' +    
	'discount="'+ coalesce(cast(@discount as varchar(50)),space(1)) + '" />'    
	EXEC dbo.Acc_WriteLog_UserLog_RunSP_Wrapper    
	  @UserID = @CustID,    
	  @CustID = @CustID,    
	  @ActionID = 216,    
	  @TrackingValue = @LogSPData,    
	  @duration = @duration    	
	     
	--Write betsetting log    
	Select @LogSPData = '<Dot_Dep_CustomerInsMember_Ag_Cust custid="'+ coalesce(cast(@custid as varchar(50)),space(1)) + '" ' +    
	'MinBet="'+ coalesce(cast(@MinBet as varchar(50)),space(1)) + '" ' +    
	'MaxBet="'+ coalesce(cast(@MaxBet as varchar(50)),space(1)) + '" ' +    
	'MaxPerMatch="'+ coalesce(cast(@MaxPerMatch as varchar(50)),space(1)) + '" />'    
	   
	EXEC dbo.Acc_WriteLog_UserLog_RunSP_Wrapper     
	  @UserID = @CustID,    
	  @CustID = @CustID,    
	  @ActionID = 315,    
	  @TrackingValue = @LogSPData,    
	  @duration = @duration    	
	     
	--Write PT log    
	Select @LogSPData = '<Dot_Dep_CustomerInsMember_Ag_Cust custid="'+ coalesce(cast(@custid as varchar(50)),space(1)) + '" ' +    
	'AgentPT="'+ coalesce(dbo.f_FomatNumericToChar(@apositiontaking_1),space(1)) + '" />'    
	
	EXEC dbo.Acc_WriteLog_UserLog_RunSP_Wrapper     
	  @UserID = @CustID,    
	  @CustID = @CustID,    
	  @ActionID = 422,    
	  @TrackingValue = @LogSPData,    
	  @duration = @duration    
	
	--Write Statuses log     
	Select @LogSPData = '<Dot_Dep_CustomerInsMember_Ag_Cust custid="'+ coalesce(cast(@custid as varchar(50)),space(1)) + '" ' +    
	'suspended="'+ coalesce(cast(@suspended as varchar(50)),space(1)) + '" ' +   
	'DisableNumber="' + coalesce(cast(@DisableNumber as varchar(1)),space(1)) + '" ' +    '" />'    

	EXEC dbo.Acc_WriteLog_UserLog_RunSP_Wrapper      
	  @UserID = @CustID,    
	  @CustID = @CustID,    
	  @ActionID = 1118,    
	  @TrackingValue = @LogSPData,    
	  @duration = @duration    	
	
END

GO 
