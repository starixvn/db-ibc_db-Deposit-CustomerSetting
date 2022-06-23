/*<info serverAlias="DBCUST-CUSTDB" executers="Dot_Member" viewers="" isFunction="0"></info>*/
ALTER PROCEDURE [dbo].[Dot_Dep_CreateLicensee] 
		@sitename			VARCHAR(10)
	,	@Product			VARCHAR(MAX)	
	,	@ErrCode			INT = 0				OUTPUT
	,	@ErrMsg				NVARCHAR(MAX) = ''	OUTPUT
	,	@Creator			VARCHAR(20)
	,	@IP					VARCHAR(50)	
	,	@IsCreateSub		BIT
	,   @LicenseeType		VARCHAR(50)
	,	@PT_Sportsbook		SMALLMONEY
	,	@PT_VirtualSports1	SMALLMONEY=0
	,	@PT_VirtualSports2	SMALLMONEY=0
	,	@PT_NumberGame		SMALLMONEY=0
	,	@PT_Keno			SMALLMONEY=0
	,	@PT_Loterry			SMALLMONEY=0
	,   @PT_VirtualGames	SMALLMONEY=0
	,   @PT_TableGame		SMALLMONEY=0
	,   @PT_ArcadiaGaming	SMALLMONEY=0
	,   @PT_Vgaming			SMALLMONEY=0
	,   @PT_PGSoft			SMALLMONEY=0
	,   @PT_SAGaming		SMALLMONEY=0
	,   @PT_SpadeGaming		SMALLMONEY=0
	,   @PT_AP				SMALLMONEY=0
	,   @PT_ApMini			SMALLMONEY=0
	,   @PT_CG				SMALLMONEY=0
	,   @PT_VS3				SMALLMONEY=0
	,	@StakeLevel			VARCHAR(MAX)	= ''
	,	@IsChinaView		BIT
AS  
/*  
 Created: 20190425@Winnie  
 Task: Create Licensee
 DB: DBCUST/CustDB  
 Original:  
 Revisions:  	
	- 20190425@Winnie:  Onebook SiteBuilder RedmineID: #111321
	- 20191016@Winnie:  Deposit - Non Peak Hours Promotion RedmineID: #119417
	- 20191202@Winnie:  Deposit - Change Non Peak Hours Promotion to Saba Promotion RedmineID: #124795
	- 20200415@Eden: OnebookSiteBuilder - Add Virtual Games And Table Games [RedmineID:#132393]
	- 20200702@Johnson: add soccer parlay [redmine: #135261]
	- 20200623@Eden: Seperate BetLimit SportsBook [RedmineID:#134183]
	- 20200720@Winfred: SiteBuilder - Create struct xml PT [RedmineID:#135872]
	- 20200820@Elodie: Change default spread group [RedmineID:#139547]
	- 20200827@Winfred: Check Offered currency on deposit [RedmineID:#140084]
	- 20210623@Winfred: Integrate 7 products [RedmineID:#156877]
	- 20211101@Winfred: Merge Sports Lottery under Sportsbook [redmine:#164129]
	- 20220117@Winfred: Change message error for stake level group and add parameter CV [redmine:#167097]
	- 20220309@Winfred: Sitebuilder - Offer Cash Out for licensee by default [redmine:#169724]
	- 20220307@Winfred: Integrate 3 products Creative Gaming, Advantplay, Advantplay mini products [redmine:#169473]
	- 20220413@Elodie: Remove code to delete site in case of error [RedmineID: #170752]
	- 20220504@Winfred: Enhance PT for Keno no rounded [redmine:#172324]
	- 20220609@Winfred: Integrate Virtual Sports 3 [redmine:#173382]

 Param's Explanation: 
 @LicenseeType = (Boping, OneWorks, Zelianta)
 @Product:<ROOT>
				<Product 
						ProductID="1" 
						Currency="20" 
						MinBet="1" 
						MaxBet="30000" 
						MaxPerMatch="1000000"
						MaxPerBall="30000" 
				/>
			</ROOT>
 @StakeLevel  =  <ROOT>
							<StakeLevel Currency="4" GameTypeID="4601"  MinStake="20" MaxStake="100"/>	
							<StakeLevel Currency="4" GameTypeID="4601"  MinStake="20" MaxStake="200" />
							<StakeLevel Currency="4" GameTypeID="4601"  MinStake="20" MaxStake="300" />
					</ROOT>',
Sample exec:
DECLARE @ErrorCode INT, @Errmsg NVARCHAR(MAX)
EXEC Dot_Dep_CreateLicensee @sitename='wtest45'
	,	@PT_Sportsbook		=0.88
	,	@PT_VirtualSports1	=0.88
	,	@PT_VirtualSports2	=0.88
	,	@PT_NumberGame		=0.88
	,	@PT_Keno			=0.88
	,	@PT_Loterry			=0.88
	,	@PT_VirtualGames	=0.85
	,	@PT_TableGame		=0.80
	,	@PT_ArcadiaGaming 	=0.81
	,	@PT_Vgaming  		=0.83
	,	@PT_PGSoft  		=0.85
	,	@PT_SAGaming  		=0.8
	,	@PT_SpadeGaming  	=0.8
	,   @PT_AP				=0.8
	,   @PT_ApMini			=0.8
	,   @PT_CG				=0.8
	,	@PT_VS3  			=0.9	
,@Product='<ROOT>
															<Product 
																	ProductID="1" 
																	Sporttype="1"
																	Bettype="1"
																	Currency="4" 
																	MinBet="1" 
																	MaxBet="10000" 
																	MaxPerMatch="1000000"
																	MaxPerBall="0" 
															/>
															<Product 
																	ProductID="1" 
																	Sporttype="2"
																	Bettype="1"
																	Currency="4" 
																	MinBet="2" 
																	MaxBet="20000" 
																	MaxPerMatch="2000000"
																	MaxPerBall="0" 
															/>
															<Product 
																	ProductID="1" 
																	Sporttype="3"
																	Bettype="1"
																	Currency="4" 
																	MinBet="3" 
																	MaxBet="30000" 
																	MaxPerMatch="3000000"
																	MaxPerBall="0" 
															/>
															<Product 
																	ProductID="1" 
																	Sporttype="5"
																	Bettype="1"
																	Currency="4" 
																	MinBet="4" 
																	MaxBet="40000" 
																	MaxPerMatch="4000000"
																	MaxPerBall="0" 
															/>
															<Product 
																	ProductID="1" 
																	Sporttype="8"
																	Bettype="1"
																	Currency="4" 
																	MinBet="5" 
																	MaxBet="50000" 
																	MaxPerMatch="50000"
																	MaxPerBall="0" 
															/>
															<Product 
																	ProductID="1" 
																	Sporttype="10"
																	Bettype="1"
																	Currency="4" 
																	MinBet="6" 
																	MaxBet="60000" 
																	MaxPerMatch="6000000"
																	MaxPerBall="0" 
															/>
															<Product 
																	ProductID="1" 
																	Sporttype="11"
																	Bettype="1"
																	Currency="4" 
																	MinBet="7" 
																	MaxBet="70000" 
																	MaxPerMatch="7000000"
																	MaxPerBall="0" 
															/>
															<Product 
																	ProductID="1" 
																	Sporttype="99"
																	Bettype="1"
																	Currency="4" 
																	MinBet="8" 
																	MaxBet="80000" 
																	MaxPerMatch="8000000"
																	MaxPerBall="0" 
															/>
															<Product 
																	ProductID="1" 
																	Sporttype="1"
																	Bettype="9"
																	Currency="4" 
																	MinBet="9" 
																	MaxBet="90000" 
																	MaxPerMatch="9000000"
																	MaxPerBall="0" 
															/>
															<Product 
																	ProductID="1" 
																	Sporttype="99"
																	Bettype="9"
																	Currency="4" 
																	MinBet="99" 
																	MaxBet="9900000" 
																	MaxPerMatch="99000000"
																	MaxPerBall="0" 
															/>
															<Product 
																	ProductID="1" 
																	Sporttype="43"
																	Bettype="1"
																	Currency="4" 
																	MinBet="43" 
																	MaxBet="430000" 
																	MaxPerMatch="430000"
																	MaxPerBall="0" 
															/>
															<Product 
																	ProductID="5" 
																	Currency="4" 
																	MinBet="1" 
																	MaxBet="30000" 
																	MaxPerMatch="1000000"
																	MaxPerBall="0" 
															/>														
															<Product 
																	ProductID="27" 
																	Currency="4" 
																	MinBet="1" 
																	MaxBet="30000" 
																	MaxPerMatch="1000000"
																	MaxPerBall="0" 
															/>
															<Product 
																	ProductID="28" 
																	Currency="4" 
																	MinBet="1" 
																	MaxBet="30000" 
																	MaxPerMatch="1000000"
																	MaxPerBall="0" 
															/>
															<Product 
																	ProductID="8" 
																	Currency="4" 
																	MinBet="1" 
																	MaxBet="30000" 
																	MaxPerMatch="1000000"
																	MaxPerBall="30000" 
															/>
															<Product 
																	ProductID="3" 
																	Currency="4" 
																	MinBet="1" 
																	MaxBet="30000" 
																	MaxPerMatch="1000000"
																	MaxPerBall="30000" 
															/>
															<Product 
																	ProductID="-1" 
																	Currency="0" 
																	MinBet="0" 
																	MaxBet="0" 
																	MaxPerMatch="0"
																	MaxPerBall="0" 
															/>
															<Product 
																	ProductID="40" 
																	Currency="4" 
																	MinBet="1" 
																	MaxBet="70000" 
																	MaxPerMatch="700000"
																	MaxPerBall="0" 
															/>	
															<Product 
																	ProductID="38" 
																	Currency="4" 
																	MinBet="0" 
																	MaxBet="0" 
																	MaxPerMatch="0"
																	MaxPerBall="0" 
															/><Product 	
																	ProductID="63"
																	Currency="4"	
																	MinBet="1" 
																	MaxBet="500000"	
																	MaxPerMatch="600000"	
																	MaxPerBall="0" 
																/>
																<Product 
																	ProductID="34"
																	Currency="4"	
																	MinBet="0" 
																	MaxBet="0"	
																	MaxPerMatch="0"
																	MaxPerBall="0" 
																/>
																<Product 
																	ProductID="66"
																	Currency="4"	
																	MinBet="0" 
																	MaxBet="0"	
																	MaxPerMatch="0"
																	MaxPerBall="0" 
																/>
																<Product 
																	ProductID="36"
																	Currency="4"	
																	MinBet="0" 
																	MaxBet="0"	
																	MaxPerMatch="0"
																	MaxPerBall="0" 
																/>
																<Product 
																	ProductID="55"
																	Currency="4"	
																	MinBet="0" 
																	MaxBet="0"	
																	MaxPerMatch="0"
																	MaxPerBall="0" 
																/>
																<Product	
																	ProductID="39"	
																	Currency="4"	
																	MinBet="0"	
																	MaxBet="0"	
																	MaxPerMatch="0"	
																	MaxPerBall="0"	
																/>
																<Product	
																	ProductID="62"	
																	Currency="4"	
																	MinBet="0"	
																	MaxBet="0"	
																	MaxPerMatch="0"	
																	MaxPerBall="0"	
																/>
																<Product	
																	ProductID="67"	
																	Currency="4"	
																	MinBet="0"	
																	MaxBet="0"	
																	MaxPerMatch="0"	
																	MaxPerBall="0"	
																/>
																<Product	
																	ProductID="68"	
																	Currency="4"	
																	MinBet="0"	
																	MaxBet="0"	
																	MaxPerMatch="0"	
																	MaxPerBall="0"	
																/>
																<Product 
																	ProductID="49" 
																	Currency="4" 
																	MinBet="1" 
																	MaxBet="20000" 
																	MaxPerMatch="0"
																	MaxPerBall="0" 
																/>
														</ROOT>' ,
@StakeLevel =  '<ROOT>
							<StakeLevel Currency="4" GameTypeID="4601"  MinStake="20" MaxStake="100"/>	
							<StakeLevel Currency="4" GameTypeID="4601"  MinStake="20" MaxStake="2000" />
							<StakeLevel Currency="4" GameTypeID="4601"  MinStake="20" MaxStake="3000000" />
							<StakeLevel Currency="4" GameTypeID="4602"  MinStake="20" MaxStake="100"/>	
							<StakeLevel Currency="4" GameTypeID="4602"  MinStake="20" MaxStake="2000" />
							<StakeLevel Currency="4" GameTypeID="4602"  MinStake="20" MaxStake="3000000" />
							<StakeLevel Currency="4" GameTypeID="4605"  MinStake="20" MaxStake="100"/>	
							<StakeLevel Currency="4" GameTypeID="4605"  MinStake="20" MaxStake="2000" />
							<StakeLevel Currency="4" GameTypeID="4605"  MinStake="20" MaxStake="3000000" />
							
							<StakeLevel Currency="4" GameTypeID="3001"  MinStake="10" MaxStake="100"/>	
							<StakeLevel Currency="4" GameTypeID="3001"  MinStake="20" MaxStake="200" />
							<StakeLevel Currency="4" GameTypeID="3001"  MinStake="30" MaxStake="500" />
					</ROOT>',
@Creator=1,@IP='192.168.1.1',@IsCreateSub=1,@LicenseeType='Boping',@IsChinaView=1 ,@ErrCode=@ErrorCode OUTPUT,@Errmsg=@Errmsg OUTPUT
SELECT @ErrorCode,@Errmsg

*/  
BEGIN  
	SET NOCOUNT ON  
	SELECT @PT_VirtualSports1=@PT_VirtualSports1*100
	SELECT @PT_VirtualSports2=@PT_VirtualSports2*100
	SELECT @PT_Loterry=@PT_Loterry*100
	SELECT @PT_VirtualGames=@PT_VirtualGames*100
	SELECT @PT_TableGame=@PT_TableGame*100
	
	SELECT @PT_ArcadiaGaming=@PT_ArcadiaGaming*100
	SELECT @PT_Vgaming=@PT_Vgaming*100
	SELECT @PT_PGSoft=@PT_PGSoft*100
	SELECT @PT_SAGaming=@PT_SAGaming*100
	SELECT @PT_SpadeGaming=@PT_SpadeGaming*100
	SELECT @PT_AP=@PT_AP*100
	SELECT @PT_ApMini=@PT_ApMini*100
	SELECT @PT_CG=@PT_CG*100
	SELECT @PT_VS3=@PT_VS3*100
	
	DECLARE @PT_Esports SMALLMONEY
	SELECT @PT_Esports=@PT_Sportsbook*100
	DECLARE @CreatorID INT,  @IsCashOut BIT,@IsBA BIT,@IsStakeLevelGroup BIT = 0 ,@PT_TEMP SMALLMONEY=0,@ProductName VARCHAR(100)
	SELECT @CreatorID=10278938	
	DECLARE @iDoc INT
	
	DECLARE @PT_XML	VARCHAR(MAX), @CurrencyError NVARCHAR(MAX) = ''
	
	DECLARE @startRun DATETIME , @endRun DATETIME , @duration INT, @ListCustIDRollBack VARCHAR(MAX), @DisableKeno VARCHAR(2)
	SET @startRun = GETDATE()
	CREATE TABLE #tempSubUserName (Username VARCHAR(30),isfinished BIT DEFAULT(0))
	CREATE TABLE #tempSubCustID (CustID INT,isfinished BIT DEFAULT(0))
	CREATE TABLE #tempDumUserName (Username VARCHAR(30),isfinished BIT DEFAULT(0))
	CREATE TABLE #tempDumCustID (CustID INT,isfinished BIT DEFAULT(0))
	DECLARE @tmpSubUserName VARCHAR(30)
	DECLARE @tmpSubCustID INT					
	DECLARE @tmpDumUserName VARCHAR(30)
	DECLARE @tmpDumCustID INT	
	CREATE TABLE #tempSuper (CustID INT,isfinished BIT DEFAULT(0))	
	
	DECLARE @PTDummy SMALLMONEY,@PTKeno VARCHAR(10)
			,@Pass VARCHAR(100),@SuperID INT,@MasterID INT,@AgentID INT,@AccMasterID INT,@AccAgentID INT,@DummyAgentID INT			
			,@DisableNumber BIT,@KenoList VARCHAR(MAX),@KenoListDummy VARCHAR(MAX)
			,@SporttypeID INT,@BettypeID INT,@bitmapOrder INT,@BetLimit VARCHAR(MAX),@LicenseeID INT	
			,@ProductID INT , @StakelevelXML VARCHAR(MAX)--, @Max_StakeLevelID INT
			,@StakeLevel_ByCurrency VARCHAR(MAX)
	
	SELECT @PTDummy=0.0000
	SELECT @PTKeno= dbo.f_FomatNumericToChar(@PT_Keno)
	SELECT @Pass='8058095B7DDB08A608811097E5DB8D'	

	SELECT @KenoListDummy='	
			<products><product Bettype="1501" MaxBet="0" MinBet="0" MaxPerMatch="0" IsDisable="1" sPositionTaking="0" mPositionTaking="0" 
				aPositionTaking="0"></product></products>'		

	DECLARE @Super VARCHAR(30),@Master VARCHAR(30),@Agent VARCHAR(30),@AccMaster VARCHAR(30),@AccAgent VARCHAR(30),@Transf VARCHAR(30),@Charge VARCHAR(30),@Bonus01 VARCHAR(30)
			,@Bonus02 VARCHAR(30),@Dummy3rd VARCHAR(30),@ClearBal VARCHAR(30)
			,@Withdraw VARCHAR(30),@Currency INT			
			,@MinBetNG	MONEY,@MaxBetNG		MONEY,@MaxPerMatchNG	MONEY,@MaxPerBallNG MONEY
			,@MinBetKN	VARCHAR(30),@MaxBetKN		VARCHAR(30),@MaxPerMatchKN	VARCHAR(30)			
			,@MinBet	MONEY,@MaxBet		MONEY,@MaxPerMatch	MONEY
	DECLARE @MinBetv1 MONEY,@MaxBetv1 MONEY,@MaxPerMatchv1 MONEY,
			@MinBetv2 MONEY,@MaxBetv2 MONEY,@MaxPerMatchv2 MONEY,
			@MinBetv3 MONEY,@MaxBetv3 MONEY,@MaxPerMatchv3 MONEY,
			@MinBetv5 MONEY,@MaxBetv5 MONEY,@MaxPerMatchv5 MONEY,
			@MinBetv8 MONEY,@MaxBetv8 MONEY,@MaxPerMatchv8 MONEY,
			@MinBetv10 MONEY,@MaxBetv10 MONEY,@MaxPerMatchv10 MONEY,
			@MinBetv11 MONEY,@MaxBetv11 MONEY,@MaxPerMatchv11 MONEY,
			@MinBetv99 MONEY,@MaxBetv99 MONEY,@MaxPerMatchv99 MONEY,
			@MinBetv1MP MONEY,@MaxBetv1MP MONEY,@MaxPerMatchv1MP MONEY,
			@MinBetv99MP MONEY,@MaxBetv99MP MONEY,@MaxPerMatchv99MP MONEY,
			@MinBetv43 MONEY,@MaxBetv43 MONEY,@MaxPerMatchv43 MONEY		

		--Check if XML is null or empty
	IF @Product IS NULL	OR @Product = ''
		RETURN

	DECLARE @tmpStakeLevel TABLE(
									 Currency		INT							
									,GameTypeID		INT							
									,MinLabel		NVARCHAR(50)
									,MaxLabel		NVARCHAR(50)
									,MinStake		DECIMAL(19,8)
									,MaxStake		DECIMAL(19,8)								
							);

	EXECUTE	sp_xml_preparedocument
				@iDoc			OUTPUT
			,	@StakeLevel;

	INSERT INTO	@tmpStakeLevel (
						Currency	
						,GameTypeID								
						,MinLabel		
						,MaxLabel		
						,MinStake		
						,MaxStake)
	SELECT	Data.Currency		
		,	Data.GameTypeID
		,	Data.MinStake
		,	Data.MaxStake
		,	Data.MinStake
		,	Data.MaxStake
	FROM OPENXML (@iDoc, '/ROOT/StakeLevel', 1) 
	WITH (
		 Currency		INT
		,GameTypeID		INT					
		,MinStake		NVARCHAR(50)
		,MaxStake		NVARCHAR(50)
	) AS Data;

	EXECUTE	sp_xml_removedocument	@iDoc;

	--INSERT default stake level for UUS
	INSERT INTO	@tmpStakeLevel (
						Currency	
						,GameTypeID								
						,MinLabel		
						,MaxLabel		
						,MinStake		
						,MaxStake)
	SELECT DISTINCT Currency = 20, GameTypeID,st.MinStake,st.MaxStake,st.MinStake,st.MaxStake
	FROM @tmpStakeLevel t
	CROSS APPLY ( SELECT 5 AS MinStake ,500 AS MaxStake UNION ALL
				  SELECT 5 AS MinStake ,1000 AS MaxStake UNION ALL
				  SELECT 5 AS MinStake ,2000 AS MaxStake ) st

	--ADD ',' to stake label
	UPDATE t
	SET MinLabel = REVERSE(STUFF (REVERSE(t.MinLabel),4,0,','))
	FROM @tmpStakeLevel t
	WHERE MinStake > 999

	UPDATE t
	SET MinLabel = REVERSE(STUFF (REVERSE(t.MinLabel),8,0,','))
	FROM @tmpStakeLevel t
	WHERE MinStake > 999999

	UPDATE t
	SET MaxLabel = REVERSE(STUFF (REVERSE(t.MaxLabel),4,0,','))
	FROM @tmpStakeLevel t
	WHERE MaxStake > 999

	UPDATE t
	SET MinLabel = REVERSE(STUFF (REVERSE(t.MinLabel),12,0,','))
	FROM @tmpStakeLevel t
	WHERE MinStake > 999999999

	UPDATE t
	SET MaxLabel = REVERSE(STUFF (REVERSE(t.MaxLabel),8,0,','))
	FROM @tmpStakeLevel t
	WHERE MaxStake > 999999

	UPDATE t
	SET MaxLabel = REVERSE(STUFF (REVERSE(t.MaxLabel),12,0,','))
	FROM @tmpStakeLevel t
	WHERE MaxStake > 999999999

	---END ADD ',' to stake label

	CREATE TABLE #SportsStatus(ProductID INT,Sporttype INT,Bettype INT,bitmapOrder INT,IsDisable BIT,IsDisableDownLine BIT,HasDownline BIT,IsDisableUpline BIT)
	CREATE TABLE #BetLimit(Sporttype INT,Bettype INT,MinBet MONEY,MaxBet MONEY,MaxPerMatch MONEY)
	CREATE TABLE #BetLimitInput(Sporttype INT,Bettype INT,MinBet MONEY,MaxBet MONEY,MaxPerMatch MONEY,isfinished BIT DEFAULT(0),PRIMARY KEY(Sporttype,Bettype))
	CREATE TABLE #NewBetLimit(Sporttype INT,Bettype INT,MinBet MONEY,MaxBet MONEY)
	CREATE TABLE #NewBetLimitInput(Sporttype INT,Bettype INT,MinBet MONEY,MaxBet MONEY,isfinished BIT DEFAULT(0),PRIMARY KEY(Sporttype,Bettype))
	CREATE TABLE #ProductInput(ProductID INT,Currency INT,MinBet MONEY,MaxBet MONEY,MaxPerMatch MONEY,MaxPerBall MONEY,Sporttype INT,Bettype INT)
	CREATE TABLE #Product(ProductID INT,Currency INT,MinBet MONEY,MaxBet MONEY,MaxPerMatch MONEY,MaxPerBall MONEY,Sporttype INT,Bettype INT , StakeLevelID	INT) --, PRIMARY KEY(ProductID,Currency)
	CREATE TABLE #Username(Super VARCHAR(30),Master VARCHAR(30),Agent VARCHAR(30),AccMaster VARCHAR(30),AccAgent VARCHAR(30),Transf VARCHAR(30),Charge VARCHAR(30),
							Bonus01 VARCHAR(30),Bonus02 VARCHAR(30),Withdraw VARCHAR(30),Dummy3rd VARCHAR(30),Currency INT,ClearBal VARCHAR(30),
							MinBetv1 MONEY,MaxBetv1 MONEY,MaxPerMatchv1 MONEY,
							MinBetv2 MONEY,MaxBetv2 MONEY,MaxPerMatchv2 MONEY,
							MinBetv3 MONEY,MaxBetv3 MONEY,MaxPerMatchv3 MONEY,
							MinBetv5 MONEY,MaxBetv5 MONEY,MaxPerMatchv5 MONEY,
							MinBetv8 MONEY,MaxBetv8 MONEY,MaxPerMatchv8 MONEY,
							MinBetv10 MONEY,MaxBetv10 MONEY,MaxPerMatchv10 MONEY,
							MinBetv11 MONEY,MaxBetv11 MONEY,MaxPerMatchv11 MONEY,
							MinBetv99 MONEY,MaxBetv99 MONEY,MaxPerMatchv99 MONEY,
							MinBetv1MP MONEY,MaxBetv1MP MONEY,MaxPerMatchv1MP MONEY,
							MinBetv99MP MONEY,MaxBetv99MP MONEY,MaxPerMatchv99MP MONEY,
							MinBetv43 MONEY,MaxBetv43 MONEY,MaxPerMatchv43 MONEY,					
							MinBetNG	MONEY,MaxBetNG	MONEY,MaxPerMatchNG		MONEY,MaxPerBallNG MONEY,
							MinBetKN	INT,MaxBetKN	INT,MaxPerMatchKN		INT,						
							isfinished BIT DEFAULT(0) )
	CREATE TABLE #StakelevelInput(ProductID INT, StakeLevelXML VARCHAR(MAX), isfinished BIT DEFAULT(0), PRIMARY KEY(ProductID))
	CREATE TABLE #tempProduct (ProductID INT, PT SMALLMONEY , ProductName VARCHAR(100),isfinished BIT DEFAULT(0))
	CREATE TABLE #CheckBetlimit (ProductID INT, ProductName VARCHAR(100),Currency INT, CurrencyName NVARCHAR(50),MinBet MONEY,MaxBet MONEY, MinBetGlobal MONEY,MaxBetGlobal MONEY, isfinished BIT DEFAULT(0))

	EXEC sp_xml_preparedocument @iDoc OUTPUT
		, @Product

	INSERT INTO #ProductInput(ProductID ,Currency ,MinBet ,MaxBet ,MaxPerMatch ,MaxPerBall,Sporttype,Bettype)
	SELECT *
		FROM OPENXML(@iDoc, '/ROOT/Product', 1) WITH (
				  ProductID		INT
				, Currency		INT
				, MinBet		MONEY
				, MaxBet		MONEY
				, MaxPerMatch	MONEY
				, MaxPerBall	MONEY
				, Sporttype		INT
				, Bettype		INT
				)

	EXEC sp_xml_removedocument @iDoc

	INSERT INTO #Product(ProductID ,Currency ,MinBet ,MaxBet ,MaxPerMatch ,MaxPerBall,Sporttype,Bettype)
	SELECT ProductID ,Currency ,MinBet ,MaxBet ,MaxPerMatch ,MaxPerBall ,Sporttype ,Bettype
	FROM #ProductInput

	INSERT INTO #Product(ProductID ,Currency ,MinBet ,MaxBet ,MaxPerMatch ,MaxPerBall, Sporttype, Bettype)
	SELECT DISTINCT ProductID ,20 ,1 ,10 ,100,CASE WHEN ProductID=3 THEN 100 ELSE 0 END , i.Sporttype, i.Bettype
	FROM #ProductInput i
	WHERE NOT EXISTS(SELECT TOP 1 1 FROM #Product p WHERE p.ProductID=i.ProductID AND ISNUll(p.Sporttype,0) =ISNUll(i.Sporttype,0) AND ISNUll(p.Bettype,0) = ISNUll(i.Bettype,0)  AND p.Currency=20 )
		
	IF EXISTS(SELECT TOP 1 1 
				FROM #Product a
				INNER JOIN Dep_ProductSetting b WITH(NOLOCK) ON a.ProductID = b.ProductID
				WHERE b.SettingType = 8
			)
	BEGIN
		UPDATE a
		SET a.Sporttype = c.SportType , a.Bettype = c.BetType
		FROM #Product a
		INNER JOIN Dep_ProductSetting b WITH(NOLOCK) ON a.ProductID = b.ProductID
		INNER JOIN Dep_ProductSettingDetail c WITH(NOLOCK) ON b.ProductSettingID = c.ProductSettingID
		WHERE b.SettingType = 8
		SET @IsStakeLevelGroup = 1
	END
	
	IF EXISTS(SELECT TOP 1 1 
						FROM #Product a
						INNER JOIN exchange b WITH(NOLOCK) ON a.Currency = b.ExchangeId
						WHERE b.IsActive = 0 OR b.OfferSite NOT IN (2,0) 
			)
	BEGIN
		SELECT @CurrencyError = STUFF((
			SELECT ',' + CAST(KQ.currency AS NVARCHAR(5)) + ''
			FROM (
				SELECT DISTINCT b.currency,b.Code
				FROM #Product a
					INNER JOIN exchange b WITH(NOLOCK) ON a.Currency = b.ExchangeId
				WHERE b.IsActive = 0 OR b.OfferSite NOT IN (2,0)
				 ) KQ
				 ORDER BY KQ.Code
				FOR XML PATH('')
			 ), 1, 1, '')
         
		SELECT @ErrMsg = 'The '+ @CurrencyError +' currency is/are not offered for Licensee. Please check again!', @ErrCode = 10006
		RETURN
	END
	
	IF EXISTS(SELECT TOP 1 1 
				FROM #Product a
					INNER JOIN Dep_ProductSetting b WITH(NOLOCK) ON a.ProductID = b.ProductID
				WHERE b.SettingType = 8 AND NOT EXISTS(SELECT TOP 1 1 
														FROM DEP_StakeLevel WITH(NOLOCK) 
														WHERE  GameTypeID = a.Bettype AND ExchangeID = a.Currency )
			)
	BEGIN
		SELECT  @ErrMsg = 'This product does not support the selected currencies', @ErrCode = 10007
		RETURN
	END

	IF EXISTS(SELECT TOP 1 1 
						FROM #Product
						WHERE  MinBet<0 OR MaxBet<0 OR MinBet>MaxBet OR (ProductID <> 49 AND (MaxPerMatch<0  OR MaxBet>MaxPerMatch))
			)
	BEGIN
		SELECT @ErrMsg = 'Break rule bet limit', @ErrCode = 10002
		RETURN
	END
	IF EXISTS(SELECT TOP 1 1 
						FROM #Product 
						WHERE (ISNULL(MaxPerBall,0)<0 OR MaxBet>ISNULL(MaxPerBall,0)) AND ProductID=3
			)
	BEGIN
		SELECT @ErrMsg = 'Break rule bet limit', @ErrCode = 10005
		RETURN
	END

	INSERT INTO #CheckBetlimit(ProductID, ProductName, Currency, CurrencyName, MinBet, MaxBet, MinBetGlobal, MaxBetGlobal)
	SELECT a.ProductID, CASE WHEN a.ProductID = 49 THEN 'VS3' ELSE CAST(a.ProductID AS NVARCHAR(50)) END AS ProductName,a.Currency,e.currency AS ExchangeName, a.MinBet,a.MaxBet, dpb.MinBet as MinBetGlobal,dpb.MaxBet as MaxBetGlobal
	FROM #Product a
	INNER JOIN Dep_ProductSetting b WITH(NOLOCK) ON a.ProductID = b.ProductID
	INNER JOIN Dep_ProductSettingDetail c WITH(NOLOCK) ON b.ProductSettingID = c.ProductSettingID
	INNER JOIN Dep_ProductBetSetting dpb WITH(NOLOCK) ON c.SportType = dpb.Sporttype AND c.BetType = dpb.Bettype AND dpb.Currency = a.Currency
	INNER JOIN exchange e WITH(NOLOCK) ON e.ExchangeId = a.Currency
	WHERE b.SettingType = 11 AND ((dpb.MinBet <> 0 OR dpb.MaxBet <> 0) OR (dpb.MinBet = dpb.MaxBet AND dpb.MinBet <> 0)) AND (a.MinBet < dpb.MinBet OR a.MaxBet < dpb.MinBet OR dpb.MaxBet < a.MinBet OR dpb.MaxBet < a.MaxBet) 

	-- Check global betlimit for setting type 11
	IF EXISTS(SELECT TOP 1 1 FROM #CheckBetlimit)
	BEGIN
		SELECT  @ErrCode = 10008, @ErrMsg = ''
		WHILE(1 =1)
		BEGIN	
			UPDATE TOP (1) c 
			SET c.isfinished = 1
				,@ProductID = c.ProductID
				,@ProductName = C.ProductName
			FROM #CheckBetlimit c 
			WHERE isfinished = 0
					
			IF @@ROWCOUNT = 0 BREAK	

			SELECT @ErrMsg = @ErrMsg + ' Violate ' + @ProductName + ' global bet setting, please follow global bet setting: ' +  STUFF((SELECT DISTINCT ', ' + CAST(CurrencyName AS NVARCHAR(50)) + ' ('+ 
										dbo.f_CS_FomatNumber (CAST( MinBetGlobal AS VARCHAR(50))) +'-'+ 
										dbo.f_CS_FomatNumber (CAST(MaxBetGlobal AS VARCHAR(50))) +')'
										FROM #CheckBetlimit
										WHERE ProductID = @ProductID
										FOR XML PATH('')), 1, 1, '')
			UPDATE c 
			SET c.isfinished = 1
			FROM #CheckBetlimit c 
			WHERE isfinished = 0 AND c.ProductID = @ProductID
		END
		RETURN
	END

	TRUNCATE TABLE #CheckBetlimit
	INSERT INTO #CheckBetlimit(ProductID, ProductName, Currency, CurrencyName)
	SELECT a.ProductID, CASE WHEN a.ProductID = 49 THEN 'VS3' ELSE CAST(a.ProductID AS NVARCHAR(50)) END AS ProductName,a.Currency,e.currency AS ExchangeName
	FROM #Product a
	INNER JOIN Dep_ProductSetting b WITH(NOLOCK) ON a.ProductID = b.ProductID
	INNER JOIN Dep_ProductSettingDetail c WITH(NOLOCK) ON b.ProductSettingID = c.ProductSettingID
	INNER JOIN exchange e WITH(NOLOCK) ON e.ExchangeId = a.Currency
	LEFT JOIN Dep_ProductBetSetting dpb WITH(NOLOCK) ON c.SportType = dpb.Sporttype AND c.BetType = dpb.Bettype AND dpb.Currency = a.Currency
	WHERE b.SettingType = 11 AND (dpb.Sporttype IS NULL OR (ISNULL(dpb.MinBet,0) = 0 AND ISNULL(dpb.MaxBet,0) = 0 ))

	-- Check exists global betlimit for setting type 11
	IF EXISTS(SELECT TOP 1 1 FROM #CheckBetlimit)
	BEGIN
		SELECT  @ErrCode = 10009, @ErrMsg = ''
		WHILE(1 =1)
		BEGIN	
			UPDATE TOP (1) c 
			SET c.isfinished = 1
				,@ProductID = c.ProductID
				,@ProductName = C.ProductName
			FROM #CheckBetlimit c 
			WHERE isfinished = 0
					
			IF @@ROWCOUNT = 0 BREAK	

			SELECT @ErrMsg = @ErrMsg + ' Unsupported currency for ' + @ProductName + ':' +  STUFF((SELECT DISTINCT ', ' + CAST(CurrencyName AS NVARCHAR(50)) 
										FROM #CheckBetlimit
										WHERE ProductID = @ProductID
										FOR XML PATH('')), 1, 1, '')
			UPDATE c 
			SET c.isfinished = 1
			FROM #CheckBetlimit c 
			WHERE isfinished = 0 AND c.ProductID = @ProductID
		END
		RETURN
	END

	IF NOT EXISTS(SELECT TOP 1 1 
						FROM #Product 
						WHERE ProductID=1
			)
	BEGIN
		SELECT @ErrMsg = 'Must offer Sportbook', @ErrCode = 10004
		RETURN
	END

	IF EXISTS (SELECT TOP 1 1 FROM dbo.Site WITH (NOLOCK) WHERE site = @Sitename) OR EXISTS (SELECT TOP 1 1 FROM bodb_Licensee.dbo.Licensees WITH (NOLOCK) WHERE LicenseeName = @Sitename)
	BEGIN
		SELECT @ErrMsg = 'Site Name already exists.', @ErrCode = 10003
		RETURN
	END
	ELSE
	BEGIN
		INSERT INTO dbo.Site(site, ServerID, isLicensee, isActive, isDeposit, IsChinaView)
		VALUES (@sitename, 0, 1, 1, 1 , @IsChinaView)
	
		IF @@ERROR <> 0
		BEGIN
			SELECT @ErrMsg = 'Insert Site Failed', @ErrCode = 10001

			--DELETE dbo.Site
			--WHERE site = @sitename AND isDeposit = 1

			RETURN
		END
	END   
	--> Get SiteID
	DECLARE @SiteID INT 
	SELECT @SiteID = siteid FROM dbo.Site WITH (NOLOCK) WHERE site = @Sitename

	--> Insert Bet Restriction Site
	EXEC NAP_BetRestriction_SiteIns
		@SiteID = @SiteID, 
		@UserId = @CreatorID,
		@LiveBetAccept = - 2, 
		@SeizeBetTicket = 0 , 
		@FollowAccount = NULL,
		@ErrMsg = @ErrMsg OUTPUT,
		@ErrCode =@ErrCode OUTPUT
	SELECT @ErrCode, @ErrMsg

	IF @ErrCode <> 0
		RETURN

	INSERT INTO #Username(Super,Master,Agent,AccMaster,AccAgent,Transf,Charge ,Bonus01,Bonus02,Withdraw,Dummy3rd,Currency,ClearBal)
	SELECT DISTINCT @sitename+'Super'+e.currency,@sitename+e.currency,@sitename+e.currency+'01'
			,@sitename+'ACC'+e.currency,@sitename+'ACC'+e.currency+'01',@sitename+'Transfer'+e.currency,
			@sitename+'Charges'+e.currency,@sitename+'Bonus'+e.currency,@sitename+'Bonus02'+e.currency,
			@sitename+'Withdrawal'+e.currency,@sitename+'Dummy3rd'+e.currency,t.Currency,@sitename+e.currency+'01ClearBal'
	FROM #Product t
		INNER JOIN exchange e WITH(NOLOCK) ON t.Currency=e.exchangeid
	WHERE t.ProductID=1
	
	UPDATE u
	SET u.MinBetv1=t.MinBet,u.MaxBetv1=t.MaxBet,u.MaxPerMatchv1=t.MaxPerMatch
	FROM #Username u
		INNER JOIN #Product t ON u.Currency=t.Currency
	WHERE t.ProductID=1 AND t.Sporttype = 1 ANd t.Bettype = 1

	UPDATE u
	SET u.MinBetv2=t.MinBet,u.MaxBetv2=t.MaxBet,u.MaxPerMatchv2=t.MaxPerMatch
	FROM #Username u
		INNER JOIN #Product t ON u.Currency=t.Currency
	WHERE t.ProductID=1 AND t.Sporttype = 2 ANd t.Bettype = 1

	UPDATE u
	SET u.MinBetv3=t.MinBet,u.MaxBetv3=t.MaxBet,u.MaxPerMatchv3=t.MaxPerMatch
	FROM #Username u
		INNER JOIN #Product t ON u.Currency=t.Currency
	WHERE t.ProductID=1 AND t.Sporttype = 3 ANd t.Bettype = 1

	UPDATE u
	SET u.MinBetv5=t.MinBet,u.MaxBetv5=t.MaxBet,u.MaxPerMatchv5=t.MaxPerMatch
	FROM #Username u
		INNER JOIN #Product t ON u.Currency=t.Currency
	WHERE t.ProductID=1 AND t.Sporttype = 5 ANd t.Bettype = 1

	UPDATE u
	SET u.MinBetv8=t.MinBet,u.MaxBetv8=t.MaxBet,u.MaxPerMatchv8=t.MaxPerMatch
	FROM #Username u
		INNER JOIN #Product t ON u.Currency=t.Currency
	WHERE t.ProductID=1 AND t.Sporttype = 8 ANd t.Bettype = 1

	UPDATE u
	SET u.MinBetv10=t.MinBet,u.MaxBetv10=t.MaxBet,u.MaxPerMatchv10=t.MaxPerMatch
	FROM #Username u
		INNER JOIN #Product t ON u.Currency=t.Currency
	WHERE t.ProductID=1 AND t.Sporttype = 10 ANd t.Bettype = 1

	UPDATE u
	SET u.MinBetv11=t.MinBet,u.MaxBetv11=t.MaxBet,u.MaxPerMatchv11=t.MaxPerMatch
	FROM #Username u
		INNER JOIN #Product t ON u.Currency=t.Currency
	WHERE t.ProductID=1 AND t.Sporttype = 11 ANd t.Bettype = 1

	UPDATE u
	SET u.MinBetv99=t.MinBet,u.MaxBetv99=t.MaxBet,u.MaxPerMatchv99=t.MaxPerMatch
	FROM #Username u
		INNER JOIN #Product t ON u.Currency=t.Currency
	WHERE t.ProductID=1 AND t.Sporttype = 99 ANd t.Bettype = 1
	
	UPDATE u
	SET u.MinBetv1MP=t.MinBet,u.MaxBetv1MP=t.MaxBet,u.MaxPerMatchv1MP=t.MaxPerMatch
	FROM #Username u
		INNER JOIN #Product t ON u.Currency=t.Currency
	WHERE t.ProductID=1 AND t.Sporttype = 1 ANd t.Bettype = 9

	UPDATE u
	SET u.MinBetv99MP=t.MinBet,u.MaxBetv99MP=t.MaxBet,u.MaxPerMatchv99MP=t.MaxPerMatch
	FROM #Username u
		INNER JOIN #Product t ON u.Currency=t.Currency
	WHERE t.ProductID=1 AND t.Sporttype = 99 ANd t.Bettype = 9

	UPDATE u
	SET u.MinBetv43=t.MinBet,u.MaxBetv43=t.MaxBet,u.MaxPerMatchv43=t.MaxPerMatch
	FROM #Username u
		INNER JOIN #Product t ON u.Currency=t.Currency
	WHERE t.ProductID=1 AND t.Sporttype = 43 ANd t.Bettype = 1

	UPDATE u
		SET u.MinBetKN=t.MinBet,u.MaxBetKN=t.MaxBet,u.MaxPerMatchKN=t.MaxPerMatch
	FROM #Username u
		INNER JOIN #Product t ON u.Currency=t.Currency
	WHERE t.ProductID=8

	UPDATE u
		SET u.MinBetNG=t.MinBet,u.MaxBetNG=t.MaxBet,u.MaxPerMatchNG=t.MaxPerMatch,u.MaxPerBallNG=t.MaxPerBall
	FROM #Username u
		INNER JOIN #Product t ON u.Currency=t.Currency
	WHERE t.ProductID=3

	WHILE (1 = 1)
	BEGIN
		
		UPDATE TOP (1) #Username
		SET isfinished = 1
			,@Super=Super,@Master=Master,@Agent=Agent,@AccMaster=AccMaster,@AccAgent=AccAgent,@Transf=Transf,@Charge=Charge ,@Bonus01=Bonus01,@Withdraw=Withdraw 
			,@Bonus02=Bonus02,@Dummy3rd=Dummy3rd,@ClearBal=ClearBal
			,@MinBetv1= ISNULL(MinBetv1,0),@MaxBetv1=ISNULL(MaxBetv1,0),@MaxPerMatchv1=ISNULL(MaxPerMatchv1,0)
			,@MinBetv2= ISNULL(MinBetv2,0),@MaxBetv2=ISNULL(MaxBetv2,0),@MaxPerMatchv2=ISNULL(MaxPerMatchv2,0)
			,@MinBetv3= ISNULL(MinBetv3,0),@MaxBetv3=ISNULL(MaxBetv3,0),@MaxPerMatchv3=ISNULL(MaxPerMatchv3,0)
			,@MinBetv5= ISNULL(MinBetv5,0),@MaxBetv5=ISNULL(MaxBetv5,0),@MaxPerMatchv5=ISNULL(MaxPerMatchv5,0)
			,@MinBetv8= ISNULL(MinBetv8,0),@MaxBetv8=ISNULL(MaxBetv8,0),@MaxPerMatchv8=ISNULL(MaxPerMatchv8,0)
			,@MinBetv10= ISNULL(MinBetv10,0),@MaxBetv10=ISNULL(MaxBetv10,0),@MaxPerMatchv10=ISNULL(MaxPerMatchv10,0)
			,@MinBetv11= ISNULL(MinBetv11,0),@MaxBetv11=ISNULL(MaxBetv11,0),@MaxPerMatchv11=ISNULL(MaxPerMatchv11,0)
			,@MinBetv99= ISNULL(MinBetv99,0),@MaxBetv99=ISNULL(MaxBetv99,0),@MaxPerMatchv99=ISNULL(MaxPerMatchv99,0)
			,@MinBetv1MP= ISNULL(MinBetv1MP,0),@MaxBetv1MP=ISNULL(MaxBetv1MP,0),@MaxPerMatchv1MP=ISNULL(MaxPerMatchv1MP,0)
			,@MinBetv99MP= ISNULL(MinBetv99MP,0),@MaxBetv99MP=ISNULL(MaxBetv99MP,0),@MaxPerMatchv99MP=ISNULL(MaxPerMatchv99MP,0)
			,@MinBetv43= ISNULL(MinBetv43,0),@MaxBetv43=ISNULL(MaxBetv43,0),@MaxPerMatchv43=ISNULL(MaxPerMatchv43,0)
			,@MinBetNG=ISNULL(MinBetNG,0),@MaxBetNG=ISNULL(MaxBetNG,0),@MaxPerMatchNG=ISNULL(MaxPerMatchNG,0),@MaxPerBallNG=ISNULL(MaxPerBallNG,0)
			,@MinBetKN=CAST(ISNULL(MinBetKN,0) AS VARCHAR(30)),@MaxBetKN=CAST(ISNULL(MaxBetKN,0) AS VARCHAR(30)),@MaxPerMatchKN=CAST(ISNULL(MaxPerMatchKN,0) AS VARCHAR(30))
			,@Currency=Currency
		WHERE isfinished = 0	

		IF @@ROWCOUNT = 0 BREAK
		
		IF EXISTS(SELECT TOP 1 1 FROM #Product WHERE Currency=@Currency AND ProductID=3)
			SELECT @DisableNumber=0
		ELSE 	
			SELECT @DisableNumber=1

		
		IF EXISTS(SELECT TOP 1 1 FROM #Product WHERE Currency=@Currency AND ProductID=8)
			SELECT @DisableKeno=0
		ELSE 	
			SELECT @DisableKeno=1

		SELECT @KenoList='	
		<products><product Bettype="1501" MaxBet="'+@MaxBetKN+'" MinBet="'+@MinBetKN+'" MaxPerMatch="'+@MaxPerMatchKN+'" IsDisable="'+@DisableKeno+'" sPositionTaking="'+@PTKeno+'" mPositionTaking="'+@PTKeno+'" 
			aPositionTaking="'+@PTKeno+'"></product></products>'
		--Insert super
		EXEC Acc_Dep_CustomerInsMember_Com 
			@Custid=@SuperID OUTPUT,@creator=@CreatorID,@Username=@Super,@userpwd=@Pass,@site=@sitename,@currency=@Currency,
			@MinBetv1= @MinBetv1,@MaxBetv1=@MaxBetv1,@MaxPerMatchv1=@MaxPerMatchv1,
			@MinBetv2= @MinBetv2,@MaxBetv2=@MaxBetv2,@MaxPerMatchv2=@MaxPerMatchv2,
			@MinBetv3= @MinBetv3,@MaxBetv3=@MaxBetv3,@MaxPerMatchv3=@MaxPerMatchv3,
			@MinBetv5= @MinBetv5,@MaxBetv5=@MaxBetv5,@MaxPerMatchv5=@MaxPerMatchv5,
			@MinBetv8= @MinBetv8,@MaxBetv8=@MaxBetv8,@MaxPerMatchv8=@MaxPerMatchv8,
			@MinBetv10= @MinBetv10,@MaxBetv10=@MaxBetv10,@MaxPerMatchv10=@MaxPerMatchv10,
			@MinBetv11= @MinBetv11,@MaxBetv11=@MaxBetv11,@MaxPerMatchv11=@MaxPerMatchv11,
			@MinBetv99= @MinBetv99,@MaxBetv99=@MaxBetv99,@MaxPerMatchv99=@MaxPerMatchv99,
			@MinBetv1MP= @MinBetv1MP,@MaxBetv1MP=@MaxBetv1MP,@MaxPerMatchv1MP=@MaxPerMatchv1MP,
			@MinBetv99MP= @MinBetv99MP,@MaxBetv99MP=@MaxBetv99MP,@MaxPerMatchv99MP=@MaxPerMatchv99MP,
			@MinBetv161=@MinBetNG,@MaxBetv161=@MaxBetNG,@MaxPerMatchv161=@MaxPerMatchNG,@MaxPerBallv161=@MaxPerBallNG,
			@v1spositiontaking_1=@PT_Sportsbook,@v1spositiontaking_2=@PT_Sportsbook,@v1spositiontaking_3=@PT_Sportsbook,@v1spositiontaking_4=@PT_Sportsbook,@v1spositiontaking_5=@PT_Sportsbook,
			@v1spositiontaking_6=@PT_Sportsbook,@v1spositiontaking_7=@PT_Sportsbook,@v1spositiontaking_8=@PT_Sportsbook,@v1spositiontaking_9=@PT_Sportsbook,@v1spositiontaking_10=@PT_Sportsbook,
			@v1slivepositiontaking_1=@PT_Sportsbook,@v1slivepositiontaking_3=@PT_Sportsbook,@v1slivepositiontaking_7=@PT_Sportsbook,@v1slivepositiontaking_8=@PT_Sportsbook,
			@v2spositiontaking_1=@PT_Sportsbook,@v2spositiontaking_2=@PT_Sportsbook,@v2spositiontaking_3=@PT_Sportsbook,@v2spositiontaking_7=@PT_Sportsbook,@v2spositiontaking_8=@PT_Sportsbook,@v2spositiontaking_20=@PT_Sportsbook,
			@v3spositiontaking_1=@PT_Sportsbook,@v3spositiontaking_2=@PT_Sportsbook,@v3spositiontaking_3=@PT_Sportsbook,@v3spositiontaking_20=@PT_Sportsbook,
			@v5spositiontaking_1=@PT_Sportsbook,@v5spositiontaking_2=@PT_Sportsbook,@v5spositiontaking_3=@PT_Sportsbook,@v5spositiontaking_20=@PT_Sportsbook,
			@v8spositiontaking_1=@PT_Sportsbook,@v8spositiontaking_3=@PT_Sportsbook,@v8spositiontaking_20=@PT_Sportsbook,
			@v10spositiontaking_1=@PT_Sportsbook,@v10spositiontaking_2=@PT_Sportsbook,@v10spositiontaking_3=@PT_Sportsbook,@v10spositiontaking_20=@PT_Sportsbook,
			@v11spositiontaking_1=@PT_Sportsbook,@v11spositiontaking_20=@PT_Sportsbook,			
			@v99spositiontaking_1=@PT_Sportsbook,@v99spositiontaking_2=@PT_Sportsbook,@v99spositiontaking_3=@PT_Sportsbook,@v99spositiontaking_9=@PT_Sportsbook,@v99spositiontaking_20=@PT_Sportsbook,
			@v161spositiontaking_81=@PT_NumberGame,@v161spositiontaking_83=@PT_NumberGame,@v161spositiontaking_86=@PT_NumberGame,@v161spositiontaking_88=@PT_NumberGame,@v161slivepositiontaking_85=@PT_NumberGame,
			@v161slivepositiontaking_86=@PT_NumberGame,@v161slivepositiontaking_87=@PT_NumberGame,@v161slivepositiontaking_89=@PT_NumberGame,@v161slivepositiontaking_90=@PT_NumberGame,
			@v1mpositiontaking_1=@PT_Sportsbook,@v1mpositiontaking_2=@PT_Sportsbook,@v1mpositiontaking_3=@PT_Sportsbook,@v1mpositiontaking_4=@PT_Sportsbook,@v1mpositiontaking_5=@PT_Sportsbook,
			@v1mpositiontaking_6=@PT_Sportsbook,@v1mpositiontaking_7=@PT_Sportsbook,@v1mpositiontaking_8=@PT_Sportsbook,@v1mpositiontaking_9=@PT_Sportsbook,@v1mpositiontaking_10=@PT_Sportsbook,
			@v1mlivepositiontaking_1=@PT_Sportsbook,@v1mlivepositiontaking_3=@PT_Sportsbook,@v1mlivepositiontaking_7=@PT_Sportsbook,@v1mlivepositiontaking_8=@PT_Sportsbook,
			@v2mpositiontaking_1=@PT_Sportsbook,@v2mpositiontaking_2=@PT_Sportsbook,@v2mpositiontaking_3=@PT_Sportsbook,@v2mpositiontaking_7=@PT_Sportsbook,@v2mpositiontaking_8=@PT_Sportsbook,
			@v2mpositiontaking_20=@PT_Sportsbook,
			@v3mpositiontaking_1=@PT_Sportsbook,@v3mpositiontaking_2=@PT_Sportsbook,@v3mpositiontaking_3=@PT_Sportsbook,@v3mpositiontaking_20=@PT_Sportsbook,
			@v5mpositiontaking_1=@PT_Sportsbook,@v5mpositiontaking_2=@PT_Sportsbook,@v5mpositiontaking_3=@PT_Sportsbook,@v5mpositiontaking_20=@PT_Sportsbook,@v8mpositiontaking_1=@PT_Sportsbook,
			@v8mpositiontaking_3=@PT_Sportsbook,@v8mpositiontaking_20=@PT_Sportsbook,
			@v10mpositiontaking_1=@PT_Sportsbook,@v10mpositiontaking_2=@PT_Sportsbook,@v10mpositiontaking_3=@PT_Sportsbook,@v10mpositiontaking_20=@PT_Sportsbook,
			@v11mpositiontaking_1=@PT_Sportsbook,@v11mpositiontaking_20=@PT_Sportsbook,			
			@v99mpositiontaking_1=@PT_Sportsbook,@v99mpositiontaking_2=@PT_Sportsbook,@v99mpositiontaking_3=@PT_Sportsbook,@v99mpositiontaking_9=@PT_Sportsbook,@v99mpositiontaking_20=@PT_Sportsbook,
			@v161mpositiontaking_81=@PT_NumberGame,@v161mpositiontaking_83=@PT_NumberGame,@v161mpositiontaking_86=@PT_NumberGame,@v161mpositiontaking_88=@PT_NumberGame,@v161mlivepositiontaking_85=@PT_NumberGame,
			@v161mlivepositiontaking_86=@PT_NumberGame,@v161mlivepositiontaking_87=@PT_NumberGame,@v161mlivepositiontaking_89=@PT_NumberGame,@v161mlivepositiontaking_90=@PT_NumberGame,
			@v1apositiontaking_1=@PT_Sportsbook,@v1apositiontaking_2=@PT_Sportsbook,@v1apositiontaking_3=@PT_Sportsbook,@v1apositiontaking_4=@PT_Sportsbook,@v1apositiontaking_5=@PT_Sportsbook,
			@v1apositiontaking_6=@PT_Sportsbook,@v1apositiontaking_7=@PT_Sportsbook,@v1apositiontaking_8=@PT_Sportsbook,@v1apositiontaking_9=@PT_Sportsbook,@v1apositiontaking_10=@PT_Sportsbook,
			@v1alivepositiontaking_1=@PT_Sportsbook,@v1alivepositiontaking_3=@PT_Sportsbook,@v1alivepositiontaking_7=@PT_Sportsbook,@v1alivepositiontaking_8=@PT_Sportsbook,
			@v2apositiontaking_1=@PT_Sportsbook,@v2apositiontaking_2=@PT_Sportsbook,@v2apositiontaking_3=@PT_Sportsbook,@v2apositiontaking_7=@PT_Sportsbook,@v2apositiontaking_8=@PT_Sportsbook,@v2apositiontaking_20=@PT_Sportsbook,
			@v3apositiontaking_1=@PT_Sportsbook,@v3apositiontaking_2=@PT_Sportsbook,@v3apositiontaking_3=@PT_Sportsbook,@v3apositiontaking_20=@PT_Sportsbook,
			@v5apositiontaking_1=@PT_Sportsbook,@v5apositiontaking_2=@PT_Sportsbook,@v5apositiontaking_3=@PT_Sportsbook,@v5apositiontaking_20=@PT_Sportsbook,
			@v8apositiontaking_1=@PT_Sportsbook,@v8apositiontaking_3=@PT_Sportsbook,@v8apositiontaking_20=@PT_Sportsbook,
			@v10apositiontaking_1=@PT_Sportsbook,@v10apositiontaking_2=@PT_Sportsbook,@v10apositiontaking_3=@PT_Sportsbook,@v10apositiontaking_20=@PT_Sportsbook,
			@v11apositiontaking_1=@PT_Sportsbook,@v11apositiontaking_20=@PT_Sportsbook,
			@v99apositiontaking_1=@PT_Sportsbook,
			@v99apositiontaking_2=@PT_Sportsbook,@v99apositiontaking_3=@PT_Sportsbook,@v99apositiontaking_9=@PT_Sportsbook,@v99apositiontaking_20=@PT_Sportsbook,
			@v161apositiontaking_81=@PT_NumberGame,@v161apositiontaking_83=@PT_NumberGame,@v161apositiontaking_86=@PT_NumberGame,@v161apositiontaking_88=@PT_NumberGame,@v161alivepositiontaking_85=@PT_NumberGame,
			@v161alivepositiontaking_86=@PT_NumberGame,@v161alivepositiontaking_87=@PT_NumberGame,@v161alivepositiontaking_89=@PT_NumberGame,@v161alivepositiontaking_90=@PT_NumberGame,@DisableNumber=@DisableNumber,
			@KenoList=@KenoList,@IP=@IP,@ErrCode=@ErrCode OUTPUT,@ErrMsg=@ErrMsg OUTPUT

			IF @ErrCode<>0
			BEGIN				
				SELECT @ErrMsg = @ErrMsg + @Super
				SELECT @ListCustIDRollBack= CAST(@SuperID AS VARCHAR(20))																														
				EXEC Dot_Dep_RollBackLicensee @ListCustID=@ListCustIDRollBack	
				--DELETE dbo.Site WITH(ROWLOCK)WHERE site = @sitename AND isDeposit = 1
 				RETURN 				
			END
			INSERT INTO #tempSuper(CustID)
			SELECT @SuperID
			--Insert master
			EXEC Acc_Dep_CustomerInsMember_SAg 
				@Custid=@MasterID OUTPUT,@creator=@CreatorID,@Username=@Master,@userpwd=@Pass,@srecommend=@SuperID,
				@MinBetv1= @MinBetv1,@MaxBetv1=@MaxBetv1,@MaxPerMatchv1=@MaxPerMatchv1,
				@MinBetv2= @MinBetv2,@MaxBetv2=@MaxBetv2,@MaxPerMatchv2=@MaxPerMatchv2,
				@MinBetv3= @MinBetv3,@MaxBetv3=@MaxBetv3,@MaxPerMatchv3=@MaxPerMatchv3,
				@MinBetv5= @MinBetv5,@MaxBetv5=@MaxBetv5,@MaxPerMatchv5=@MaxPerMatchv5,
				@MinBetv8= @MinBetv8,@MaxBetv8=@MaxBetv8,@MaxPerMatchv8=@MaxPerMatchv8,
				@MinBetv10= @MinBetv10,@MaxBetv10=@MaxBetv10,@MaxPerMatchv10=@MaxPerMatchv10,
				@MinBetv11= @MinBetv11,@MaxBetv11=@MaxBetv11,@MaxPerMatchv11=@MaxPerMatchv11,
				@MinBetv99= @MinBetv99,@MaxBetv99=@MaxBetv99,@MaxPerMatchv99=@MaxPerMatchv99,
				@MinBetv1MP= @MinBetv1MP,@MaxBetv1MP=@MaxBetv1MP,@MaxPerMatchv1MP=@MaxPerMatchv1MP,
				@MinBetv99MP= @MinBetv99MP,@MaxBetv99MP=@MaxBetv99MP,@MaxPerMatchv99MP=@MaxPerMatchv99MP,
				@MinBetv161=@MinBetNG,@MaxBetv161=@MaxBetNG,@MaxPerMatchv161=@MaxPerMatchNG,@MaxPerBallv161=@MaxPerBallNG,
				@v1spositiontaking_1=@PT_Sportsbook,@v1spositiontaking_2=@PT_Sportsbook,@v1spositiontaking_3=@PT_Sportsbook,@v1spositiontaking_4=@PT_Sportsbook,@v1spositiontaking_5=@PT_Sportsbook,
				@v1spositiontaking_6=@PT_Sportsbook,@v1spositiontaking_7=@PT_Sportsbook,@v1spositiontaking_8=@PT_Sportsbook,@v1spositiontaking_9=@PT_Sportsbook,@v1spositiontaking_10=@PT_Sportsbook,
				@v1slivepositiontaking_1=@PT_Sportsbook,@v1slivepositiontaking_3=@PT_Sportsbook,@v1slivepositiontaking_7=@PT_Sportsbook,@v1slivepositiontaking_8=@PT_Sportsbook,
				@v2spositiontaking_1=@PT_Sportsbook,@v2spositiontaking_2=@PT_Sportsbook,@v2spositiontaking_3=@PT_Sportsbook,@v2spositiontaking_7=@PT_Sportsbook,@v2spositiontaking_8=@PT_Sportsbook,@v2spositiontaking_20=@PT_Sportsbook,
				@v3spositiontaking_1=@PT_Sportsbook,@v3spositiontaking_2=@PT_Sportsbook,@v3spositiontaking_3=@PT_Sportsbook,@v3spositiontaking_20=@PT_Sportsbook,
				@v5spositiontaking_1=@PT_Sportsbook,@v5spositiontaking_2=@PT_Sportsbook,@v5spositiontaking_3=@PT_Sportsbook,@v5spositiontaking_20=@PT_Sportsbook,
				@v8spositiontaking_1=@PT_Sportsbook,@v8spositiontaking_3=@PT_Sportsbook,@v8spositiontaking_20=@PT_Sportsbook,
				@v10spositiontaking_1=@PT_Sportsbook,@v10spositiontaking_2=@PT_Sportsbook,@v10spositiontaking_3=@PT_Sportsbook,@v10spositiontaking_20=@PT_Sportsbook,
				@v11spositiontaking_1=@PT_Sportsbook,@v11spositiontaking_20=@PT_Sportsbook,				
				@v99spositiontaking_1=@PT_Sportsbook,@v99spositiontaking_2=@PT_Sportsbook,@v99spositiontaking_3=@PT_Sportsbook,@v99spositiontaking_9=@PT_Sportsbook,@v99spositiontaking_20=@PT_Sportsbook,
				@v161spositiontaking_81=@PT_NumberGame,@v161spositiontaking_83=@PT_NumberGame,@v161spositiontaking_86=@PT_NumberGame,@v161spositiontaking_88=@PT_NumberGame,@v161slivepositiontaking_85=@PT_NumberGame,
				@v161slivepositiontaking_86=@PT_NumberGame,@v161slivepositiontaking_87=@PT_NumberGame,@v161slivepositiontaking_89=@PT_NumberGame,@v161slivepositiontaking_90=@PT_NumberGame,
				@v1mpositiontaking_1=@PT_Sportsbook,@v1mpositiontaking_2=@PT_Sportsbook,@v1mpositiontaking_3=@PT_Sportsbook,@v1mpositiontaking_4=@PT_Sportsbook,@v1mpositiontaking_5=@PT_Sportsbook,
				@v1mpositiontaking_6=@PT_Sportsbook,@v1mpositiontaking_7=@PT_Sportsbook,@v1mpositiontaking_8=@PT_Sportsbook,@v1mpositiontaking_9=@PT_Sportsbook,@v1mpositiontaking_10=@PT_Sportsbook,
				@v1mlivepositiontaking_1=@PT_Sportsbook,@v1mlivepositiontaking_3=@PT_Sportsbook,@v1mlivepositiontaking_7=@PT_Sportsbook,@v1mlivepositiontaking_8=@PT_Sportsbook,
				@v2mpositiontaking_1=@PT_Sportsbook,@v2mpositiontaking_2=@PT_Sportsbook,@v2mpositiontaking_3=@PT_Sportsbook,@v2mpositiontaking_7=@PT_Sportsbook,@v2mpositiontaking_8=@PT_Sportsbook,
				@v2mpositiontaking_20=@PT_Sportsbook,
				@v3mpositiontaking_1=@PT_Sportsbook,@v3mpositiontaking_2=@PT_Sportsbook,@v3mpositiontaking_3=@PT_Sportsbook,@v3mpositiontaking_20=@PT_Sportsbook,
				@v5mpositiontaking_1=@PT_Sportsbook,@v5mpositiontaking_2=@PT_Sportsbook,@v5mpositiontaking_3=@PT_Sportsbook,@v5mpositiontaking_20=@PT_Sportsbook,@v8mpositiontaking_1=@PT_Sportsbook,
				@v8mpositiontaking_3=@PT_Sportsbook,@v8mpositiontaking_20=@PT_Sportsbook,
				@v10mpositiontaking_1=@PT_Sportsbook,@v10mpositiontaking_2=@PT_Sportsbook,@v10mpositiontaking_3=@PT_Sportsbook,@v10mpositiontaking_20=@PT_Sportsbook,
				@v11mpositiontaking_1=@PT_Sportsbook,@v11mpositiontaking_20=@PT_Sportsbook,			
				@v99mpositiontaking_1=@PT_Sportsbook,@v99mpositiontaking_2=@PT_Sportsbook,@v99mpositiontaking_3=@PT_Sportsbook,@v99mpositiontaking_9=@PT_Sportsbook,@v99mpositiontaking_20=@PT_Sportsbook,
				@v161mpositiontaking_81=@PT_NumberGame,@v161mpositiontaking_83=@PT_NumberGame,@v161mpositiontaking_86=@PT_NumberGame,@v161mpositiontaking_88=@PT_NumberGame,@v161mlivepositiontaking_85=@PT_NumberGame,
				@v161mlivepositiontaking_86=@PT_NumberGame,@v161mlivepositiontaking_87=@PT_NumberGame,@v161mlivepositiontaking_89=@PT_NumberGame,@v161mlivepositiontaking_90=@PT_NumberGame,
				@DisableNumber=@DisableNumber,
				@KenoList=@KenoList,@IP=@IP,@ErrCode=@ErrCode OUTPUT,@ErrMsg=@ErrMsg OUTPUT
			
			IF @ErrCode<>0
			BEGIN
				SELECT @ErrMsg = @ErrMsg + @Master	
				SELECT @ListCustIDRollBack= CAST(@SuperID AS VARCHAR(20))+','+
													CAST(@MasterID AS VARCHAR(20))																					
				EXEC Dot_Dep_RollBackLicensee @ListCustID=@ListCustIDRollBack	
				--DELETE dbo.Site WITH(ROWLOCK)WHERE site = @sitename AND isDeposit = 1					
				RETURN
			END
			--Insert agent
			EXEC Acc_Dep_CustomerInsMember_MAg 
				@Custid=@AgentID OUTPUT,@creator=@CreatorID,@Username=@Agent,@userpwd=@Pass,@mrecommend=@MasterID,
				@MinBetv1= @MinBetv1,@MaxBetv1=@MaxBetv1,@MaxPerMatchv1=@MaxPerMatchv1,
				@MinBetv2= @MinBetv2,@MaxBetv2=@MaxBetv2,@MaxPerMatchv2=@MaxPerMatchv2,
				@MinBetv3= @MinBetv3,@MaxBetv3=@MaxBetv3,@MaxPerMatchv3=@MaxPerMatchv3,
				@MinBetv5= @MinBetv5,@MaxBetv5=@MaxBetv5,@MaxPerMatchv5=@MaxPerMatchv5,
				@MinBetv8= @MinBetv8,@MaxBetv8=@MaxBetv8,@MaxPerMatchv8=@MaxPerMatchv8,
				@MinBetv10= @MinBetv10,@MaxBetv10=@MaxBetv10,@MaxPerMatchv10=@MaxPerMatchv10,
				@MinBetv11= @MinBetv11,@MaxBetv11=@MaxBetv11,@MaxPerMatchv11=@MaxPerMatchv11,
				@MinBetv99= @MinBetv99,@MaxBetv99=@MaxBetv99,@MaxPerMatchv99=@MaxPerMatchv99,
				@MinBetv1MP= @MinBetv1MP,@MaxBetv1MP=@MaxBetv1MP,@MaxPerMatchv1MP=@MaxPerMatchv1MP,
				@MinBetv99MP= @MinBetv99MP,@MaxBetv99MP=@MaxBetv99MP,@MaxPerMatchv99MP=@MaxPerMatchv99MP,
				@MinBetv161=@MinBetNG,@MaxBetv161=@MaxBetNG,@MaxPerMatchv161=@MaxPerMatchNG,@MaxPerBallv161=@MaxPerBallNG,				
				@v1mpositiontaking_1=@PT_Sportsbook,@v1mpositiontaking_2=@PT_Sportsbook,@v1mpositiontaking_3=@PT_Sportsbook,@v1mpositiontaking_4=@PT_Sportsbook,@v1mpositiontaking_5=@PT_Sportsbook,
				@v1mpositiontaking_6=@PT_Sportsbook,@v1mpositiontaking_7=@PT_Sportsbook,@v1mpositiontaking_8=@PT_Sportsbook,@v1mpositiontaking_9=@PT_Sportsbook,@v1mpositiontaking_10=@PT_Sportsbook,
				@v1mlivepositiontaking_1=@PT_Sportsbook,@v1mlivepositiontaking_3=@PT_Sportsbook,@v1mlivepositiontaking_7=@PT_Sportsbook,@v1mlivepositiontaking_8=@PT_Sportsbook,
				@v2mpositiontaking_1=@PT_Sportsbook,@v2mpositiontaking_2=@PT_Sportsbook,@v2mpositiontaking_3=@PT_Sportsbook,@v2mpositiontaking_7=@PT_Sportsbook,@v2mpositiontaking_8=@PT_Sportsbook,
				@v2mpositiontaking_20=@PT_Sportsbook,
				@v3mpositiontaking_1=@PT_Sportsbook,@v3mpositiontaking_2=@PT_Sportsbook,@v3mpositiontaking_3=@PT_Sportsbook,@v3mpositiontaking_20=@PT_Sportsbook,
				@v5mpositiontaking_1=@PT_Sportsbook,@v5mpositiontaking_2=@PT_Sportsbook,@v5mpositiontaking_3=@PT_Sportsbook,@v5mpositiontaking_20=@PT_Sportsbook,@v8mpositiontaking_1=@PT_Sportsbook,
				@v8mpositiontaking_3=@PT_Sportsbook,@v8mpositiontaking_20=@PT_Sportsbook,
				@v10mpositiontaking_1=@PT_Sportsbook,@v10mpositiontaking_2=@PT_Sportsbook,@v10mpositiontaking_3=@PT_Sportsbook,@v10mpositiontaking_20=@PT_Sportsbook,
				@v11mpositiontaking_1=@PT_Sportsbook,@v11mpositiontaking_20=@PT_Sportsbook,				
				@v99mpositiontaking_1=@PT_Sportsbook,@v99mpositiontaking_2=@PT_Sportsbook,@v99mpositiontaking_3=@PT_Sportsbook,@v99mpositiontaking_9=@PT_Sportsbook,@v99mpositiontaking_20=@PT_Sportsbook,
				@v161mpositiontaking_81=@PT_NumberGame,@v161mpositiontaking_83=@PT_NumberGame,@v161mpositiontaking_86=@PT_NumberGame,@v161mpositiontaking_88=@PT_NumberGame,@v161mlivepositiontaking_85=@PT_NumberGame,
				@v161mlivepositiontaking_86=@PT_NumberGame,@v161mlivepositiontaking_87=@PT_NumberGame,@v161mlivepositiontaking_89=@PT_NumberGame,@v161mlivepositiontaking_90=@PT_NumberGame,
				@v1apositiontaking_1=@PT_Sportsbook,@v1apositiontaking_2=@PT_Sportsbook,@v1apositiontaking_3=@PT_Sportsbook,@v1apositiontaking_4=@PT_Sportsbook,@v1apositiontaking_5=@PT_Sportsbook,
				@v1apositiontaking_6=@PT_Sportsbook,@v1apositiontaking_7=@PT_Sportsbook,@v1apositiontaking_8=@PT_Sportsbook,@v1apositiontaking_9=@PT_Sportsbook,@v1apositiontaking_10=@PT_Sportsbook,
				@v1alivepositiontaking_1=@PT_Sportsbook,@v1alivepositiontaking_3=@PT_Sportsbook,@v1alivepositiontaking_7=@PT_Sportsbook,@v1alivepositiontaking_8=@PT_Sportsbook,
				@v2apositiontaking_1=@PT_Sportsbook,@v2apositiontaking_2=@PT_Sportsbook,@v2apositiontaking_3=@PT_Sportsbook,@v2apositiontaking_7=@PT_Sportsbook,@v2apositiontaking_8=@PT_Sportsbook,@v2apositiontaking_20=@PT_Sportsbook,
				@v3apositiontaking_1=@PT_Sportsbook,@v3apositiontaking_2=@PT_Sportsbook,@v3apositiontaking_3=@PT_Sportsbook,@v3apositiontaking_20=@PT_Sportsbook,
				@v5apositiontaking_1=@PT_Sportsbook,@v5apositiontaking_2=@PT_Sportsbook,@v5apositiontaking_3=@PT_Sportsbook,@v5apositiontaking_20=@PT_Sportsbook,
				@v8apositiontaking_1=@PT_Sportsbook,@v8apositiontaking_3=@PT_Sportsbook,@v8apositiontaking_20=@PT_Sportsbook,
				@v10apositiontaking_1=@PT_Sportsbook,@v10apositiontaking_2=@PT_Sportsbook,@v10apositiontaking_3=@PT_Sportsbook,@v10apositiontaking_20=@PT_Sportsbook,
				@v11apositiontaking_1=@PT_Sportsbook,@v11apositiontaking_20=@PT_Sportsbook,
				@v99apositiontaking_1=@PT_Sportsbook,
				@v99apositiontaking_2=@PT_Sportsbook,@v99apositiontaking_3=@PT_Sportsbook,@v99apositiontaking_9=@PT_Sportsbook,@v99apositiontaking_20=@PT_Sportsbook,
				@v161apositiontaking_81=@PT_NumberGame,@v161apositiontaking_83=@PT_NumberGame,@v161apositiontaking_86=@PT_NumberGame,@v161apositiontaking_88=@PT_NumberGame,@v161alivepositiontaking_85=@PT_NumberGame,
				@v161alivepositiontaking_86=@PT_NumberGame,@v161alivepositiontaking_87=@PT_NumberGame,@v161alivepositiontaking_89=@PT_NumberGame,@v161alivepositiontaking_90=@PT_NumberGame,@DisableNumber=@DisableNumber,
				@KenoList=@KenoList,@IP=@IP,@ErrCode=@ErrCode OUTPUT,@ErrMsg=@ErrMsg OUTPUT

			IF @ErrCode<>0
			BEGIN
				SELECT @ErrMsg = @ErrMsg + @Agent
				--DELETE dbo.Site WITH(ROWLOCK)WHERE site = @sitename AND isDeposit = 1	
				SELECT @ListCustIDRollBack= CAST(@SuperID AS VARCHAR(20))+','+
													CAST(@MasterID AS VARCHAR(20))+','+
													CAST(@AgentID AS VARCHAR(20))											
				EXEC Dot_Dep_RollBackLicensee @ListCustID=@ListCustIDRollBack
				RETURN
			END
			-- Insert dummy account
			EXEC Acc_Dep_CustomerInsMember_SAg 
				@Custid=@AccMasterID OUTPUT,@creator=@CreatorID,@Username=@AccMaster,@userpwd=@Pass,@srecommend=@SuperID
				,@MinBetv1=@PTDummy,@MaxBetv1=@PTDummy,@MaxPerMatchv1=@PTDummy,
				@MinBetv2=@PTDummy,@MaxBetv2=@PTDummy,@MaxPerMatchv2=@PTDummy,
				@MinBetv3=@PTDummy,@MaxBetv3=@PTDummy,@MaxPerMatchv3=@PTDummy,
				@MinBetv5=@PTDummy,@MaxBetv5=@PTDummy,@MaxPerMatchv5=@PTDummy,
				@MinBetv8=@PTDummy,@MaxBetv8=@PTDummy,@MaxPerMatchv8=@PTDummy,
				@MinBetv10=@PTDummy,@MaxBetv10=@PTDummy,@MaxPerMatchv10=@PTDummy,
				@MinBetv11=@PTDummy,@MaxBetv11=@PTDummy,@MaxPerMatchv11=@PTDummy,				
				@MinBetv99=@PTDummy,@MaxBetv99=@PTDummy,@MaxPerMatchv99=@PTDummy,
				@MinBetv1MP= @PTDummy,@MaxBetv1MP=@PTDummy,@MaxPerMatchv1MP=@PTDummy,
				@MinBetv99MP=@PTDummy,@MaxBetv99MP=@PTDummy,@MaxPerMatchv99MP=@PTDummy,
				@MinBetv161=@PTDummy,@MaxBetv161=@PTDummy,@MaxPerMatchv161=@PTDummy,@MaxPerBallv161=@PTDummy,
				@v1spositiontaking_1=@PTDummy,@v1spositiontaking_2=@PTDummy,@v1spositiontaking_3=@PTDummy,@v1spositiontaking_4=@PTDummy,@v1spositiontaking_5=@PTDummy,
				@v1spositiontaking_6=@PTDummy,@v1spositiontaking_7=@PTDummy,@v1spositiontaking_8=@PTDummy,@v1spositiontaking_9=@PTDummy,@v1spositiontaking_10=@PTDummy,
				@v1slivepositiontaking_1=@PTDummy,@v1slivepositiontaking_3=@PTDummy,@v1slivepositiontaking_7=@PTDummy,@v1slivepositiontaking_8=@PTDummy,
				@v2spositiontaking_1=@PTDummy,@v2spositiontaking_2=@PTDummy,@v2spositiontaking_3=@PTDummy,@v2spositiontaking_7=@PTDummy,@v2spositiontaking_8=@PTDummy,@v2spositiontaking_20=@PTDummy,
				@v3spositiontaking_1=@PTDummy,@v3spositiontaking_2=@PTDummy,@v3spositiontaking_3=@PTDummy,@v3spositiontaking_20=@PTDummy,
				@v5spositiontaking_1=@PTDummy,@v5spositiontaking_2=@PTDummy,@v5spositiontaking_3=@PTDummy,@v5spositiontaking_20=@PTDummy,
				@v8spositiontaking_1=@PTDummy,@v8spositiontaking_3=@PTDummy,@v8spositiontaking_20=@PTDummy,
				@v10spositiontaking_1=@PTDummy,@v10spositiontaking_2=@PTDummy,@v10spositiontaking_3=@PTDummy,@v10spositiontaking_20=@PTDummy,
				@v11spositiontaking_1=@PTDummy,@v11spositiontaking_20=@PTDummy,				
				@v99spositiontaking_1=@PTDummy,@v99spositiontaking_2=@PTDummy,@v99spositiontaking_3=@PTDummy,@v99spositiontaking_9=@PTDummy,@v99spositiontaking_20=@PTDummy,
				@v161spositiontaking_81=@PTDummy,@v161spositiontaking_83=@PTDummy,@v161spositiontaking_86=@PTDummy,@v161spositiontaking_88=@PTDummy,@v161slivepositiontaking_85=@PTDummy,
				@v161slivepositiontaking_86=@PTDummy,@v161slivepositiontaking_87=@PTDummy,@v161slivepositiontaking_89=@PTDummy,@v161slivepositiontaking_90=@PTDummy,
				@v1mpositiontaking_1=@PTDummy,@v1mpositiontaking_2=@PTDummy,@v1mpositiontaking_3=@PTDummy,@v1mpositiontaking_4=@PTDummy,@v1mpositiontaking_5=@PTDummy,
				@v1mpositiontaking_6=@PTDummy,@v1mpositiontaking_7=@PTDummy,@v1mpositiontaking_8=@PTDummy,@v1mpositiontaking_9=@PTDummy,@v1mpositiontaking_10=@PTDummy,
				@v1mlivepositiontaking_1=@PTDummy,@v1mlivepositiontaking_3=@PTDummy,@v1mlivepositiontaking_7=@PTDummy,@v1mlivepositiontaking_8=@PTDummy,
				@v2mpositiontaking_1=@PTDummy,@v2mpositiontaking_2=@PTDummy,@v2mpositiontaking_3=@PTDummy,@v2mpositiontaking_7=@PTDummy,@v2mpositiontaking_8=@PTDummy,
				@v2mpositiontaking_20=@PTDummy,
				@v3mpositiontaking_1=@PTDummy,@v3mpositiontaking_2=@PTDummy,@v3mpositiontaking_3=@PTDummy,@v3mpositiontaking_20=@PTDummy,
				@v5mpositiontaking_1=@PTDummy,@v5mpositiontaking_2=@PTDummy,@v5mpositiontaking_3=@PTDummy,@v5mpositiontaking_20=@PTDummy,@v8mpositiontaking_1=@PTDummy,
				@v8mpositiontaking_3=@PTDummy,@v8mpositiontaking_20=@PTDummy,
				@v10mpositiontaking_1=@PTDummy,@v10mpositiontaking_2=@PTDummy,@v10mpositiontaking_3=@PTDummy,@v10mpositiontaking_20=@PTDummy,
				@v11mpositiontaking_1=@PTDummy,@v11mpositiontaking_20=@PTDummy,				
				@v99mpositiontaking_1=@PTDummy,@v99mpositiontaking_2=@PTDummy,@v99mpositiontaking_3=@PTDummy,@v99mpositiontaking_9=@PTDummy,@v99mpositiontaking_20=@PTDummy,
				@v161mpositiontaking_81=@PTDummy,@v161mpositiontaking_83=@PTDummy,@v161mpositiontaking_86=@PTDummy,@v161mpositiontaking_88=@PTDummy,@v161mlivepositiontaking_85=@PTDummy,
				@v161mlivepositiontaking_86=@PTDummy,@v161mlivepositiontaking_87=@PTDummy,@v161mlivepositiontaking_89=@PTDummy,@v161mlivepositiontaking_90=@PTDummy,
				@DisableNumber=1,
				@KenoList=@KenoListDummy,@IP=@IP,@ErrCode=@ErrCode OUTPUT,@ErrMsg=@ErrMsg OUTPUT

			IF @ErrCode<>0
			BEGIN
				SELECT @ErrMsg = @ErrMsg + @AccMaster
				--DELETE dbo.Site WITH(ROWLOCK)WHERE site = @sitename AND isDeposit = 1	
				SELECT @ListCustIDRollBack= CAST(@SuperID AS VARCHAR(20))+','+
													CAST(@MasterID AS VARCHAR(20))+','+
													CAST(@AgentID AS VARCHAR(20))+','+
													CAST(@AccMasterID AS VARCHAR(20))
													
				EXEC Dot_Dep_RollBackLicensee @ListCustID=@ListCustIDRollBack
				RETURN
			END
			-- Insert dummy account
			EXEC Acc_Dep_CustomerInsMember_MAg 
				@Custid=@AccAgentID OUTPUT,@creator=@CreatorID,@Username=@AccAgent,@userpwd=@Pass,@mrecommend=@AccMasterID
				,@MinBetv1=@PTDummy,@MaxBetv1=@PTDummy,@MaxPerMatchv1=@PTDummy,
				@MinBetv2=@PTDummy,@MaxBetv2=@PTDummy,@MaxPerMatchv2=@PTDummy,
				@MinBetv3=@PTDummy,@MaxBetv3=@PTDummy,@MaxPerMatchv3=@PTDummy,
				@MinBetv5=@PTDummy,@MaxBetv5=@PTDummy,@MaxPerMatchv5=@PTDummy,
				@MinBetv8=@PTDummy,@MaxBetv8=@PTDummy,@MaxPerMatchv8=@PTDummy,
				@MinBetv10=@PTDummy,@MaxBetv10=@PTDummy,@MaxPerMatchv10=@PTDummy,
				@MinBetv11=@PTDummy,@MaxBetv11=@PTDummy,@MaxPerMatchv11=@PTDummy,				
				@MinBetv99=@PTDummy,@MaxBetv99=@PTDummy,@MaxPerMatchv99=@PTDummy,
				@MinBetv1MP= @PTDummy,@MaxBetv1MP=@PTDummy,@MaxPerMatchv1MP=@PTDummy,
				@MinBetv99MP=@PTDummy,@MaxBetv99MP=@PTDummy,@MaxPerMatchv99MP=@PTDummy,
				@MinBetv161=@PTDummy,@MaxBetv161=@PTDummy,@MaxPerMatchv161=@PTDummy,@MaxPerBallv161=@PTDummy,				
				@v1mpositiontaking_1=@PTDummy,@v1mpositiontaking_2=@PTDummy,@v1mpositiontaking_3=@PTDummy,@v1mpositiontaking_4=@PTDummy,@v1mpositiontaking_5=@PTDummy,
				@v1mpositiontaking_6=@PTDummy,@v1mpositiontaking_7=@PTDummy,@v1mpositiontaking_8=@PTDummy,@v1mpositiontaking_9=@PTDummy,@v1mpositiontaking_10=@PTDummy,
				@v1mlivepositiontaking_1=@PTDummy,@v1mlivepositiontaking_3=@PTDummy,@v1mlivepositiontaking_7=@PTDummy,@v1mlivepositiontaking_8=@PTDummy,
				@v2mpositiontaking_1=@PTDummy,@v2mpositiontaking_2=@PTDummy,@v2mpositiontaking_3=@PTDummy,@v2mpositiontaking_7=@PTDummy,@v2mpositiontaking_8=@PTDummy,
				@v2mpositiontaking_20=@PTDummy,
				@v3mpositiontaking_1=@PTDummy,@v3mpositiontaking_2=@PTDummy,@v3mpositiontaking_3=@PTDummy,@v3mpositiontaking_20=@PTDummy,
				@v5mpositiontaking_1=@PTDummy,@v5mpositiontaking_2=@PTDummy,@v5mpositiontaking_3=@PTDummy,@v5mpositiontaking_20=@PTDummy,@v8mpositiontaking_1=@PTDummy,
				@v8mpositiontaking_3=@PTDummy,@v8mpositiontaking_20=@PTDummy,
				@v10mpositiontaking_1=@PTDummy,@v10mpositiontaking_2=@PTDummy,@v10mpositiontaking_3=@PTDummy,@v10mpositiontaking_20=@PTDummy,
				@v11mpositiontaking_1=@PTDummy,@v11mpositiontaking_20=@PTDummy,				
				@v99mpositiontaking_1=@PTDummy,@v99mpositiontaking_2=@PTDummy,@v99mpositiontaking_3=@PTDummy,@v99mpositiontaking_9=@PTDummy,@v99mpositiontaking_20=@PTDummy,
				@v161mpositiontaking_81=@PTDummy,@v161mpositiontaking_83=@PTDummy,@v161mpositiontaking_86=@PTDummy,@v161mpositiontaking_88=@PTDummy,@v161mlivepositiontaking_85=@PTDummy,
				@v161mlivepositiontaking_86=@PTDummy,@v161mlivepositiontaking_87=@PTDummy,@v161mlivepositiontaking_89=@PTDummy,@v161mlivepositiontaking_90=@PTDummy,
				@v1apositiontaking_1=@PTDummy,@v1apositiontaking_2=@PTDummy,@v1apositiontaking_3=@PTDummy,@v1apositiontaking_4=@PTDummy,@v1apositiontaking_5=@PTDummy,
				@v1apositiontaking_6=@PTDummy,@v1apositiontaking_7=@PTDummy,@v1apositiontaking_8=@PTDummy,@v1apositiontaking_9=@PTDummy,@v1apositiontaking_10=@PTDummy,
				@v1alivepositiontaking_1=@PTDummy,@v1alivepositiontaking_3=@PTDummy,@v1alivepositiontaking_7=@PTDummy,@v1alivepositiontaking_8=@PTDummy,
				@v2apositiontaking_1=@PTDummy,@v2apositiontaking_2=@PTDummy,@v2apositiontaking_3=@PTDummy,@v2apositiontaking_7=@PTDummy,@v2apositiontaking_8=@PTDummy,@v2apositiontaking_20=@PTDummy,
				@v3apositiontaking_1=@PTDummy,@v3apositiontaking_2=@PTDummy,@v3apositiontaking_3=@PTDummy,@v3apositiontaking_20=@PTDummy,
				@v5apositiontaking_1=@PTDummy,@v5apositiontaking_2=@PTDummy,@v5apositiontaking_3=@PTDummy,@v5apositiontaking_20=@PTDummy,
				@v8apositiontaking_1=@PTDummy,@v8apositiontaking_3=@PTDummy,@v8apositiontaking_20=@PTDummy,
				@v10apositiontaking_1=@PTDummy,@v10apositiontaking_2=@PTDummy,@v10apositiontaking_3=@PTDummy,@v10apositiontaking_20=@PTDummy,
				@v11apositiontaking_1=@PTDummy,@v11apositiontaking_20=@PTDummy,
				@v99apositiontaking_1=@PTDummy,
				@v99apositiontaking_2=@PTDummy,@v99apositiontaking_3=@PTDummy,@v99apositiontaking_9=@PTDummy,@v99apositiontaking_20=@PTDummy,
				@v161apositiontaking_81=@PTDummy,@v161apositiontaking_83=@PTDummy,@v161apositiontaking_86=@PTDummy,@v161apositiontaking_88=@PTDummy,@v161alivepositiontaking_85=@PTDummy,
				@v161alivepositiontaking_86=@PTDummy,@v161alivepositiontaking_87=@PTDummy,@v161alivepositiontaking_89=@PTDummy,@v161alivepositiontaking_90=@PTDummy,@DisableNumber=1,
				@KenoList=@KenoListDummy,@IP=@IP,@ErrCode=@ErrCode OUTPUT,@ErrMsg=@ErrMsg OUTPUT
				
			IF @ErrCode<>0
			BEGIN
				SELECT @ErrMsg = @ErrMsg + @AccAgent
				--DELETE dbo.Site WITH(ROWLOCK)WHERE site = @sitename AND isDeposit = 1	
				SELECT @ListCustIDRollBack= CAST(@SuperID AS VARCHAR(20))+','+
													CAST(@MasterID AS VARCHAR(20))+','+
													CAST(@AgentID AS VARCHAR(20))+','+
													CAST(@AccMasterID AS VARCHAR(20))+','+
													CAST(@AccAgentID AS VARCHAR(20))
				EXEC Dot_Dep_RollBackLicensee @ListCustID=@ListCustIDRollBack
				RETURN
			END
			-- Insert tranfer
			INSERT INTO #tempDumUserName(Username)
			SELECT @ClearBal
			UNION ALL
			SELECT @Transf
			UNION ALL
			SELECT @Charge
			UNION ALL
			SELECT @Bonus01
			UNION ALL
			SELECT @Bonus02
			UNION ALL
			SELECT @Withdraw
			UNION ALL
			SELECT @Dummy3rd
			WHILE (1 = 1)
			BEGIN		
				UPDATE TOP (1) #tempDumUserName
				SET isfinished = 1
					,@tmpDumUserName=Username
				WHERE isfinished = 0

				IF @@ROWCOUNT = 0 OR @ErrCode<>0 BREAK 

				IF @tmpDumUserName LIKE '%ClearBal'
					SET @DummyAgentID = @AgentID
				ELSE 
					SET @DummyAgentID = @AccAgentID

				EXEC Acc_Dep_CustomerInsMember_Ag @custid=@tmpDumCustID 
					OUTPUT,@creator=@creatorID,@username=@tmpDumUserName,@userpwd=@Pass,@recommend=@DummyAgentID,@DisableNumber=1,
					@MinBetv1=@PTDummy,@MaxBetv1=@PTDummy,@MaxPerMatchv1=@PTDummy,
					@MinBetv2=@PTDummy,@MaxBetv2=@PTDummy,@MaxPerMatchv2=@PTDummy,
					@MinBetv3=@PTDummy,@MaxBetv3=@PTDummy,@MaxPerMatchv3=@PTDummy,
					@MinBetv5=@PTDummy,@MaxBetv5=@PTDummy,@MaxPerMatchv5=@PTDummy,
					@MinBetv8=@PTDummy,@MaxBetv8=@PTDummy,@MaxPerMatchv8=@PTDummy,
					@MinBetv10=@PTDummy,@MaxBetv10=@PTDummy,@MaxPerMatchv10=@PTDummy,
					@MinBetv11=@PTDummy,@MaxBetv11=@PTDummy,@MaxPerMatchv11=@PTDummy,					
					@MinBetv99=@PTDummy,@MaxBetv99=@PTDummy,@MaxPerMatchv99=@PTDummy,
					@MinBetv1MP= @PTDummy,@MaxBetv1MP=@PTDummy,@MaxPerMatchv1MP=@PTDummy,
					@MinBetv99mp=@PTDummy,@MaxBetv99mp=@PTDummy,@MaxPerMatchv99mp=@PTDummy,
					@MinBetv161=@PTDummy,@MaxBetv161=@PTDummy,@MaxPerMatchv161=@PTDummy,@MaxPerBallv161=@PTDummy,
					@v1apositiontaking_1=@PTDummy,@v1apositiontaking_2=@PTDummy,@v1apositiontaking_3=@PTDummy,@v1apositiontaking_4=@PTDummy,@v1apositiontaking_5=@PTDummy,@v1apositiontaking_6=@PTDummy,
					@v1apositiontaking_7=@PTDummy,@v1apositiontaking_8=@PTDummy,@v1apositiontaking_9=@PTDummy,@v1apositiontaking_10=@PTDummy,@v1alivepositiontaking_1=@PTDummy,@v1alivepositiontaking_3=@PTDummy,
					@v1alivepositiontaking_7=@PTDummy,@v1alivepositiontaking_8=@PTDummy,
					@v2apositiontaking_1=@PTDummy,@v2apositiontaking_2=@PTDummy,@v2apositiontaking_3=@PTDummy,@v2apositiontaking_7=@PTDummy,@v2apositiontaking_8=@PTDummy,@v2apositiontaking_20=@PTDummy,
					@v3apositiontaking_1=@PTDummy,@v3apositiontaking_2=@PTDummy,@v3apositiontaking_3=@PTDummy,@v3apositiontaking_20=@PTDummy,
					@v5apositiontaking_1=@PTDummy,@v5apositiontaking_2=@PTDummy,@v5apositiontaking_3=@PTDummy,@v5apositiontaking_20=@PTDummy,
					@v8apositiontaking_1=@PTDummy,@v8apositiontaking_3=@PTDummy,@v8apositiontaking_20=@PTDummy,
					@v10apositiontaking_1=@PTDummy,@v10apositiontaking_2=@PTDummy,@v10apositiontaking_3=@PTDummy,@v10apositiontaking_20=@PTDummy,
					@v11apositiontaking_1=@PTDummy,@v11apositiontaking_20=@PTDummy,					
					@v99apositiontaking_1=@PTDummy,@v99apositiontaking_2=@PTDummy,@v99apositiontaking_3=@PTDummy,@v99apositiontaking_20=@PTDummy,@v99apositiontaking_9=@PTDummy,
					@v161apositiontaking_81=@PTDummy,@v161apositiontaking_83=@PTDummy,@v161apositiontaking_86=@PTDummy,@v161apositiontaking_88=@PTDummy,@v161alivepositiontaking_85=@PTDummy,
					@v161alivepositiontaking_86=@PTDummy,@v161alivepositiontaking_87=@PTDummy,@v161alivepositiontaking_89=@PTDummy,@v161alivepositiontaking_90=@PTDummy,
					@KenoList=@KenoListDummy,@IP=@IP,@ErrCode=@ErrCode OUTPUT,@ErrMsg=@ErrMsg OUTPUT

				INSERT INTO #tempDumCustID(CustID)
				SELECT 	@tmpDumCustID		

			END
				

				IF @ErrCode<>0
				BEGIN
					SELECT @ErrMsg = @ErrMsg + 'Create Dummy accounts.'
					--DELETE dbo.Site WITH(ROWLOCK)WHERE site = @sitename AND isDeposit = 1	
					SELECT @ListCustIDRollBack= CAST(@SuperID AS VARCHAR(20))+','+
													CAST(@MasterID AS VARCHAR(20))+','+
													CAST(@AgentID AS VARCHAR(20))+','+
													CAST(@AccMasterID AS VARCHAR(20))+','+
													CAST(@AccAgentID AS VARCHAR(20))+','
					SELECT @ListCustIDRollBack=@ListCustIDRollBack+				
						ISNULL(STUFF((Select ','+ CAST(CustID AS VARCHAR(20))
						from #tempDumCustID T1
						FOR XML PATH('')),1,1,''),'') 									
					EXEC Dot_Dep_RollBackLicensee @ListCustID=@ListCustIDRollBack			
					RETURN
				END	
				-- -- Insert Sub licensees
				IF @IsCreateSub=1 
				BEGIN			
					
					INSERT INTO #tempSubUserName(Username)
					SELECT @Master+'02'
					UNION ALL
					SELECT @Master+'03'
					UNION ALL
					SELECT @Master+'04'
					UNION ALL
					SELECT @Master+'05'
					UNION ALL
					SELECT @Master+'06'
					UNION ALL
					SELECT @Master+'07'
					UNION ALL
					SELECT @Master+'08'
					UNION ALL
					SELECT @Master+'09'
					UNION ALL
					SELECT @Master+'10'
					UNION ALL
					SELECT @Master+'11'

					WHILE (1 = 1)
					BEGIN		
						UPDATE TOP (1) #tempSubUserName
						SET isfinished = 1
							,@tmpSubUserName=Username
						WHERE isfinished = 0

						IF @@ROWCOUNT = 0 OR @ErrCode<>0 BREAK 

						EXEC Acc_Dep_CustomerInsMember_MAg 
						@Custid=@tmpSubCustID OUTPUT,@creator=@CreatorID,@Username=@tmpSubUserName,@userpwd=@Pass,@mrecommend=@MasterID,
						@MinBetv1= @MinBetv1,@MaxBetv1=@MaxBetv1,@MaxPerMatchv1=@MaxPerMatchv1,
						@MinBetv2= @MinBetv2,@MaxBetv2=@MaxBetv2,@MaxPerMatchv2=@MaxPerMatchv2,
						@MinBetv3= @MinBetv3,@MaxBetv3=@MaxBetv3,@MaxPerMatchv3=@MaxPerMatchv3,
						@MinBetv5= @MinBetv5,@MaxBetv5=@MaxBetv5,@MaxPerMatchv5=@MaxPerMatchv5,
						@MinBetv8= @MinBetv8,@MaxBetv8=@MaxBetv8,@MaxPerMatchv8=@MaxPerMatchv8,
						@MinBetv10= @MinBetv10,@MaxBetv10=@MaxBetv10,@MaxPerMatchv10=@MaxPerMatchv10,
						@MinBetv11= @MinBetv11,@MaxBetv11=@MaxBetv11,@MaxPerMatchv11=@MaxPerMatchv11,
						@MinBetv99= @MinBetv99,@MaxBetv99=@MaxBetv99,@MaxPerMatchv99=@MaxPerMatchv99,
						@MinBetv1MP= @MinBetv1MP,@MaxBetv1MP=@MaxBetv1MP,@MaxPerMatchv1MP=@MaxPerMatchv1MP,
						@MinBetv99MP= @MinBetv99MP,@MaxBetv99MP=@MaxBetv99MP,@MaxPerMatchv99MP=@MaxPerMatchv99MP,
						@MinBetv161=@MinBetNG,@MaxBetv161=@MaxBetNG,@MaxPerMatchv161=@MaxPerMatchNG,@MaxPerBallv161=@MaxPerBallNG,				
						@v1mpositiontaking_1=@PT_Sportsbook,@v1mpositiontaking_2=@PT_Sportsbook,@v1mpositiontaking_3=@PT_Sportsbook,@v1mpositiontaking_4=@PT_Sportsbook,@v1mpositiontaking_5=@PT_Sportsbook,
						@v1mpositiontaking_6=@PT_Sportsbook,@v1mpositiontaking_7=@PT_Sportsbook,@v1mpositiontaking_8=@PT_Sportsbook,@v1mpositiontaking_9=@PT_Sportsbook,@v1mpositiontaking_10=@PT_Sportsbook,
						@v1mlivepositiontaking_1=@PT_Sportsbook,@v1mlivepositiontaking_3=@PT_Sportsbook,@v1mlivepositiontaking_7=@PT_Sportsbook,@v1mlivepositiontaking_8=@PT_Sportsbook,
						@v2mpositiontaking_1=@PT_Sportsbook,@v2mpositiontaking_2=@PT_Sportsbook,@v2mpositiontaking_3=@PT_Sportsbook,@v2mpositiontaking_7=@PT_Sportsbook,@v2mpositiontaking_8=@PT_Sportsbook,
						@v2mpositiontaking_20=@PT_Sportsbook,
						@v3mpositiontaking_1=@PT_Sportsbook,@v3mpositiontaking_2=@PT_Sportsbook,@v3mpositiontaking_3=@PT_Sportsbook,@v3mpositiontaking_20=@PT_Sportsbook,
						@v5mpositiontaking_1=@PT_Sportsbook,@v5mpositiontaking_2=@PT_Sportsbook,@v5mpositiontaking_3=@PT_Sportsbook,@v5mpositiontaking_20=@PT_Sportsbook,@v8mpositiontaking_1=@PT_Sportsbook,
						@v8mpositiontaking_3=@PT_Sportsbook,@v8mpositiontaking_20=@PT_Sportsbook,
						@v10mpositiontaking_1=@PT_Sportsbook,@v10mpositiontaking_2=@PT_Sportsbook,@v10mpositiontaking_3=@PT_Sportsbook,@v10mpositiontaking_20=@PT_Sportsbook,
						@v11mpositiontaking_1=@PT_Sportsbook,@v11mpositiontaking_20=@PT_Sportsbook,						
						@v99mpositiontaking_1=@PT_Sportsbook,@v99mpositiontaking_2=@PT_Sportsbook,@v99mpositiontaking_3=@PT_Sportsbook,@v99mpositiontaking_9=@PT_Sportsbook,@v99mpositiontaking_20=@PT_Sportsbook,
						@v161mpositiontaking_81=@PT_NumberGame,@v161mpositiontaking_83=@PT_NumberGame,@v161mpositiontaking_86=@PT_NumberGame,@v161mpositiontaking_88=@PT_NumberGame,@v161mlivepositiontaking_85=@PT_NumberGame,
						@v161mlivepositiontaking_86=@PT_NumberGame,@v161mlivepositiontaking_87=@PT_NumberGame,@v161mlivepositiontaking_89=@PT_NumberGame,@v161mlivepositiontaking_90=@PT_NumberGame,
						@v1apositiontaking_1=@PT_Sportsbook,@v1apositiontaking_2=@PT_Sportsbook,@v1apositiontaking_3=@PT_Sportsbook,@v1apositiontaking_4=@PT_Sportsbook,@v1apositiontaking_5=@PT_Sportsbook,
						@v1apositiontaking_6=@PT_Sportsbook,@v1apositiontaking_7=@PT_Sportsbook,@v1apositiontaking_8=@PT_Sportsbook,@v1apositiontaking_9=@PT_Sportsbook,@v1apositiontaking_10=@PT_Sportsbook,
						@v1alivepositiontaking_1=@PT_Sportsbook,@v1alivepositiontaking_3=@PT_Sportsbook,@v1alivepositiontaking_7=@PT_Sportsbook,@v1alivepositiontaking_8=@PT_Sportsbook,
						@v2apositiontaking_1=@PT_Sportsbook,@v2apositiontaking_2=@PT_Sportsbook,@v2apositiontaking_3=@PT_Sportsbook,@v2apositiontaking_7=@PT_Sportsbook,@v2apositiontaking_8=@PT_Sportsbook,@v2apositiontaking_20=@PT_Sportsbook,
						@v3apositiontaking_1=@PT_Sportsbook,@v3apositiontaking_2=@PT_Sportsbook,@v3apositiontaking_3=@PT_Sportsbook,@v3apositiontaking_20=@PT_Sportsbook,
						@v5apositiontaking_1=@PT_Sportsbook,@v5apositiontaking_2=@PT_Sportsbook,@v5apositiontaking_3=@PT_Sportsbook,@v5apositiontaking_20=@PT_Sportsbook,
						@v8apositiontaking_1=@PT_Sportsbook,@v8apositiontaking_3=@PT_Sportsbook,@v8apositiontaking_20=@PT_Sportsbook,
						@v10apositiontaking_1=@PT_Sportsbook,@v10apositiontaking_2=@PT_Sportsbook,@v10apositiontaking_3=@PT_Sportsbook,@v10apositiontaking_20=@PT_Sportsbook,
						@v11apositiontaking_1=@PT_Sportsbook,@v11apositiontaking_20=@PT_Sportsbook,
						@v99apositiontaking_1=@PT_Sportsbook,
						@v99apositiontaking_2=@PT_Sportsbook,@v99apositiontaking_3=@PT_Sportsbook,@v99apositiontaking_9=@PT_Sportsbook,@v99apositiontaking_20=@PT_Sportsbook,
						@v161apositiontaking_81=@PT_NumberGame,@v161apositiontaking_83=@PT_NumberGame,@v161apositiontaking_86=@PT_NumberGame,@v161apositiontaking_88=@PT_NumberGame,@v161alivepositiontaking_85=@PT_NumberGame,
						@v161alivepositiontaking_86=@PT_NumberGame,@v161alivepositiontaking_87=@PT_NumberGame,@v161alivepositiontaking_89=@PT_NumberGame,@v161alivepositiontaking_90=@PT_NumberGame,@DisableNumber=@DisableNumber,
						@KenoList=@KenoList,@IP=@IP,@ErrCode=@ErrCode OUTPUT,@ErrMsg=@ErrMsg OUTPUT	
						
						INSERT INTO #tempSubCustID(CustID)
						SELECT 	@tmpSubCustID					
					END
					
					
					IF @ErrCode<>0
					BEGIN
						SELECT @ErrMsg = @ErrMsg + 'Create sub agent.'
						--DELETE dbo.Site WITH(ROWLOCK)WHERE site = @sitename AND isDeposit = 1	
						SELECT @ListCustIDRollBack= CAST(@SuperID AS VARCHAR(20))+','+
													CAST(@MasterID AS VARCHAR(20))+','+
													CAST(@AgentID AS VARCHAR(20))+','+
													CAST(@AccMasterID AS VARCHAR(20))+','+
													CAST(@AccAgentID AS VARCHAR(20))+','
						SELECT @ListCustIDRollBack=@ListCustIDRollBack+				
						ISNULL(STUFF((Select ','+ CAST(CustID AS VARCHAR(20))
						from #tempDumCustID T1
						FOR XML PATH('')),1,1,''),'')
						SELECT @ListCustIDRollBack=@ListCustIDRollBack+','
						SELECT @ListCustIDRollBack=@ListCustIDRollBack+				
						ISNULL(STUFF((Select ','+ CAST(CustID AS VARCHAR(20))
						from #tempSubCustID T1
						FOR XML PATH('')),1,1,''),'')
						EXEC Dot_Dep_RollBackLicensee @ListCustID=@ListCustIDRollBack
						RETURN
					END							
				END

			SELECT @StakeLevel_ByCurrency = CONVERT(VARCHAR(MAX),
													(SELECT (SELECT 
																 0 AS '@StakeLevelID'
																,GameTypeID AS '@GameTypeID'
																,MinLabel AS '@MinLabel'
																,MaxLabel AS '@MaxLabel'
																,MinStake AS '@MinStake'
																,MaxStake AS '@MaxStake'
															FROM @tmpStakeLevel WHERE currency = @Currency
															FOR XML PATH('StakeLevel'),TYPE
															)
													FOR XML PATH('ROOT'),TYPE
													)) 

			--Create Global Stake level : 
			EXEC [dbo].[Acc_Dep_CustSetting_GlobalStakeLevelUpdate] 
					 @StakeLevel = @StakeLevel_ByCurrency	
					,@CustID	= @SuperID
					,@UserID	= @CreatorID 
					,@IP		= @IP
					,@ErrCode	= @ErrCode OUTPUT 
					,@ErrMsg	= @ErrMsg OUTPUT

			IF @ErrCode<>0
			BEGIN
				SELECT @ErrMsg = @ErrMsg + 'Create Global Stake level.'
				--DELETE dbo.Site WITH(ROWLOCK)WHERE site = @sitename AND isDeposit = 1	
				SELECT @ListCustIDRollBack= CAST(@SuperID AS VARCHAR(20))+','+
											CAST(@MasterID AS VARCHAR(20))+','+
											CAST(@AgentID AS VARCHAR(20))+','+
											CAST(@AccMasterID AS VARCHAR(20))+','+
											CAST(@AccAgentID AS VARCHAR(20))+','
				SELECT @ListCustIDRollBack=@ListCustIDRollBack+				
				ISNULL(STUFF((Select ','+ CAST(CustID AS VARCHAR(20))
				from #tempDumCustID T1
				FOR XML PATH('')),1,1,''),'')
				SELECT @ListCustIDRollBack=@ListCustIDRollBack+','
				SELECT @ListCustIDRollBack=@ListCustIDRollBack+				
				ISNULL(STUFF((Select ','+ CAST(CustID AS VARCHAR(20))
				from #tempSubCustID T1
				FOR XML PATH('')),1,1,''),'')
				EXEC Dot_Dep_RollBackLicenseeDCS @ListCustID=@ListCustIDRollBack, @siteID = @SiteID
				RETURN
			END		

			--Esports			
			IF EXISTS(SELECT TOP 1 1 FROM #Product WHERE ProductID=1 AND Currency=@Currency)
			BEGIN
				INSERT INTO #BetLimit(Sporttype,Bettype,MinBet,MaxBet,MaxPerMatch)
				EXEC Acc_Dep_CustSetting_BetLimitFullLineSettingSelect @SuperID=@SuperID,@ProductID=16,@AgentID=0 		
			
				INSERT INTO #BetLimitInput(Sporttype,Bettype,MinBet,MaxBet,MaxPerMatch)
				SELECT DISTINCT b.Sporttype,b.Bettype,p.MinBet,p.MaxBet,p.MaxPerMatch
				FROM #BetLimit b
					CROSS JOIN #Product p		
				WHERE p.ProductID=1 AND p.Currency=@Currency AND p.Sporttype = 43
				TRUNCATE TABLE #BetLimit				
			
				-- Insert PT		
				SELECT  @PT_XML = ('<ROOT>' + (
									SELECT 
										 SportType AS 'SportType'
										,Bettype AS 'BetType'
										,IsLive AS 'IsLive'
										,@PT_Esports AS 'PT'
									FROM dbo.f_Dep_CustSetting_SportBetTypeSettingSelect(16,1) 
									FOR XML RAW('PT')) + '</ROOT>')
				
				EXEC Acc_Dep_CustSetting_PositionTakingSettingUpd @SuperID=@SuperID,@AgentID=@AgentID,@IsAgentOnly=0,@PT=@PT_XML,@ProductID=16,@UserID=@CreatorID,@IP=@IP,
						@ErrCode=@ErrCode OUTPUT,@ErrMsg=@ErrMsg OUTPUT

				IF @ErrCode<>0
				BEGIN
					SELECT @ErrMsg = @ErrMsg + 'PT ESports.' +@Agent
					DELETE FROM Dep_LicenseeProductSetting WHERE CustID=@SuperID
					SELECT @ListCustIDRollBack= CAST(@SuperID AS VARCHAR(20))+','+
													CAST(@MasterID AS VARCHAR(20))+','+
													CAST(@AgentID AS VARCHAR(20))+','+
													CAST(@AccMasterID AS VARCHAR(20))+','+
													CAST(@AccAgentID AS VARCHAR(20))+','
					SELECT @ListCustIDRollBack=@ListCustIDRollBack+				
						ISNULL(STUFF((Select ','+ CAST(CustID AS VARCHAR(20))
						from #tempDumCustID T1
						FOR XML PATH('')),1,1,''),'')
					SELECT @ListCustIDRollBack=@ListCustIDRollBack+','
					SELECT @ListCustIDRollBack=@ListCustIDRollBack+				
						ISNULL(STUFF((Select ','+ CAST(CustID AS VARCHAR(20))
						from #tempSubCustID T1
						FOR XML PATH('')),1,1,''),'')
					EXEC Dot_Dep_RollBackLicenseeDCS @ListCustID=@ListCustIDRollBack
					RETURN
				END		

				IF @IsCreateSub=1  
				BEGIN
					UPDATE #tempSubCustID SET isfinished=0
					WHILE (1 = 1)
					BEGIN		
						UPDATE TOP (1) #tempSubCustID
						SET isfinished = 1
							,@tmpSubCustID=CustID
						WHERE isfinished = 0

						IF @@ROWCOUNT = 0 OR @ErrCode<>0 BREAK 
						
						SELECT  @PT_XML = ('<ROOT>' + (
									SELECT 
										 SportType AS 'SportType'
										,Bettype AS 'BetType'
										,IsLive AS 'IsLive'
										,@PT_Esports AS 'PT'
									FROM dbo.f_Dep_CustSetting_SportBetTypeSettingSelect(16,1) 
									FOR XML RAW('PT')) + '</ROOT>')
				
						EXEC Acc_Dep_CustSetting_PositionTakingSettingUpd @SuperID=@SuperID,@AgentID=@tmpSubCustID,@IsAgentOnly=1,@PT=@PT_XML,@ProductID=16,@UserID=@CreatorID,@IP=@IP,
							@ErrCode=@ErrCode OUTPUT,@ErrMsg=@ErrMsg OUTPUT						
					END					
					IF @ErrCode<>0
					BEGIN
						SELECT @ErrMsg = @ErrMsg + 'PT DCS ESports sub licensees.'
						DELETE FROM Dep_LicenseeProductSetting WHERE CustID=@SuperID
						SELECT @ListCustIDRollBack= CAST(@SuperID AS VARCHAR(20))+','+
													CAST(@MasterID AS VARCHAR(20))+','+
													CAST(@AgentID AS VARCHAR(20))+','+
													CAST(@AccMasterID AS VARCHAR(20))+','+
													CAST(@AccAgentID AS VARCHAR(20))+','
						SELECT @ListCustIDRollBack=@ListCustIDRollBack+				
						ISNULL(STUFF((Select ','+ CAST(CustID AS VARCHAR(20))
						from #tempDumCustID T1
						FOR XML PATH('')),1,1,''),'')			
						SELECT @ListCustIDRollBack=@ListCustIDRollBack+','				
						SELECT @ListCustIDRollBack=@ListCustIDRollBack+				
							ISNULL(STUFF((Select ','+ CAST(CustID AS VARCHAR(20))
							from #tempSubCustID T1
							FOR XML PATH('')),1,1,''),'')
						EXEC Dot_Dep_RollBackLicenseeDCS @ListCustID=@ListCustIDRollBack
						RETURN
					END					
				END					
			END

			--VS
			IF EXISTS(SELECT TOP 1 1 FROM #Product WHERE ProductID=5 AND Currency=@Currency)
			BEGIN
				INSERT INTO #BetLimit(Sporttype,Bettype,MinBet,MaxBet,MaxPerMatch)
				EXEC Acc_Dep_CustSetting_BetLimitFullLineSettingSelect @SuperID=@SuperID,@ProductID=5,@AgentID=0 		
			
				INSERT INTO #BetLimitInput(Sporttype,Bettype,MinBet,MaxBet,MaxPerMatch)
				SELECT DISTINCT b.Sporttype,b.Bettype,p.MinBet,p.MaxBet,p.MaxPerMatch
				FROM #BetLimit b
					CROSS JOIN #Product p		
				WHERE p.ProductID=5	AND p.Currency=@Currency
				TRUNCATE TABLE #BetLimit

				INSERT INTO #SportsStatus(ProductID,Sporttype ,Bettype,bitmapOrder,IsDisable,IsDisableDownLine,HasDownline,IsDisableUpline)
				EXEC Acc_Dep_CustSetting_StatusSelect @ProductID=5,@CustID=@SuperID
				SELECT @SporttypeID=Sporttype,@BettypeID=Bettype,@bitmapOrder=bitmapOrder FROM #SportsStatus
				-- Insert status
				EXEC Acc_Dep_CustSetting_StatusUpd @ProductID=5,@CustID=@SuperID,@IsDisabled=0,@IsDisabledDownLine=0,@SportType=@SportTypeID,@BetType=@BetTypeID,@bitmapOrder=@bitmapOrder,@UserID=@CreatorID,@IP=@IP,
					@IsAgentOnly=0,@ErrCode=@ErrCode OUTPUT,@ErrMsg=@ErrMsg OUTPUT
						
				IF @ErrCode<>0
				BEGIN
					SELECT @ErrMsg = @ErrMsg + 'Status DCS Virtual Sports.'
					DELETE FROM Dep_LicenseeProductSetting WHERE CustID=@SuperID
					SELECT @ListCustIDRollBack= CAST(@SuperID AS VARCHAR(20))+','+
													CAST(@MasterID AS VARCHAR(20))+','+
													CAST(@AgentID AS VARCHAR(20))+','+
													CAST(@AccMasterID AS VARCHAR(20))+','+
													CAST(@AccAgentID AS VARCHAR(20))+','
					SELECT @ListCustIDRollBack=@ListCustIDRollBack+				
						ISNULL(STUFF((Select ','+ CAST(CustID AS VARCHAR(20))
						from #tempDumCustID T1
						FOR XML PATH('')),1,1,''),'')
					SELECT @ListCustIDRollBack=@ListCustIDRollBack+','
					SELECT @ListCustIDRollBack=@ListCustIDRollBack+				
						ISNULL(STUFF((Select ','+ CAST(CustID AS VARCHAR(20))
						from #tempSubCustID T1
						FOR XML PATH('')),1,1,''),'')	
					EXEC Dot_Dep_RollBackLicenseeDCS @ListCustID=@ListCustIDRollBack
					
					RETURN
				END		

				TRUNCATE TABLE #SportsStatus
				-- Insert PT
				SELECT  @PT_XML = ('<ROOT>' + (
							SELECT 
								 SportType AS 'SportType'
								,Bettype AS 'BetType'
								,IsLive AS 'IsLive'
								,@PT_VirtualSports1 AS 'PT'
							FROM dbo.f_Dep_CustSetting_SportBetTypeSettingSelect(5,1) 
							FOR XML RAW('PT')) + '</ROOT>')
				EXEC Acc_Dep_CustSetting_PositionTakingSettingUpd @SuperID=@SuperID,@AgentID=@AgentID,@IsAgentOnly=0,@PT=@PT_XML,@ProductID=5,@UserID=@CreatorID,@IP=@IP,
						@ErrCode=@ErrCode OUTPUT,@ErrMsg=@ErrMsg OUTPUT

				IF @ErrCode<>0
				BEGIN
					SELECT @ErrMsg = @ErrMsg + 'PT DCS Virtual Sports.' +@Agent
					DELETE FROM Dep_LicenseeProductSetting WHERE CustID=@SuperID
					SELECT @ListCustIDRollBack= CAST(@SuperID AS VARCHAR(20))+','+
													CAST(@MasterID AS VARCHAR(20))+','+
													CAST(@AgentID AS VARCHAR(20))+','+
													CAST(@AccMasterID AS VARCHAR(20))+','+
													CAST(@AccAgentID AS VARCHAR(20))+','
					SELECT @ListCustIDRollBack=@ListCustIDRollBack+				
						ISNULL(STUFF((Select ','+ CAST(CustID AS VARCHAR(20))
						from #tempDumCustID T1
						FOR XML PATH('')),1,1,''),'')
					SELECT @ListCustIDRollBack=@ListCustIDRollBack+','
					SELECT @ListCustIDRollBack=@ListCustIDRollBack+				
						ISNULL(STUFF((Select ','+ CAST(CustID AS VARCHAR(20))
						from #tempSubCustID T1
						FOR XML PATH('')),1,1,''),'') 	
					EXEC Dot_Dep_RollBackLicenseeDCS @ListCustID=@ListCustIDRollBack
					RETURN
				END		

				IF @IsCreateSub=1  
				BEGIN
					UPDATE #tempSubCustID SET isfinished=0
					WHILE (1 = 1)
					BEGIN		
						UPDATE TOP (1) #tempSubCustID
						SET isfinished = 1
							,@tmpSubCustID=CustID
						WHERE isfinished = 0

						IF @@ROWCOUNT = 0 OR @ErrCode<>0 BREAK 
						SELECT  @PT_XML = ('<ROOT>' + (
							SELECT 
								 SportType AS 'SportType'
								,Bettype AS 'BetType'
								,IsLive AS 'IsLive'
								,@PT_VirtualSports1 AS 'PT'
							FROM dbo.f_Dep_CustSetting_SportBetTypeSettingSelect(5,1)
							FOR XML RAW('PT')) + '</ROOT>')
						EXEC Acc_Dep_CustSetting_PositionTakingSettingUpd @SuperID=@SuperID,@AgentID=@tmpSubCustID,@IsAgentOnly=1,@PT=@PT_XML,@ProductID=5,@UserID=@CreatorID,@IP=@IP,
							@ErrCode=@ErrCode OUTPUT,@ErrMsg=@ErrMsg OUTPUT						
					END					
					IF @ErrCode<>0
					BEGIN
						SELECT @ErrMsg = @ErrMsg + 'PT DCS Virtual Sports sub licensees.'
						DELETE FROM Dep_LicenseeProductSetting WHERE CustID=@SuperID
						SELECT @ListCustIDRollBack= CAST(@SuperID AS VARCHAR(20))+','+
													CAST(@MasterID AS VARCHAR(20))+','+
													CAST(@AgentID AS VARCHAR(20))+','+
													CAST(@AccMasterID AS VARCHAR(20))+','+
													CAST(@AccAgentID AS VARCHAR(20))+','
						SELECT @ListCustIDRollBack=@ListCustIDRollBack+				
						ISNULL(STUFF((Select ','+ CAST(CustID AS VARCHAR(20))
						from #tempDumCustID T1
						FOR XML PATH('')),1,1,''),'')		
						SELECT @ListCustIDRollBack=@ListCustIDRollBack+','				
						SELECT @ListCustIDRollBack=@ListCustIDRollBack+				
							ISNULL(STUFF((Select ','+ CAST(CustID AS VARCHAR(20))
							from #tempSubCustID T1
							FOR XML PATH('')),1,1,''),'')	
						EXEC Dot_Dep_RollBackLicenseeDCS @ListCustID=@ListCustIDRollBack
						RETURN
					END					
				END					
			END

			--vs2
			IF EXISTS(SELECT TOP 1 1 FROM #Product WHERE ProductID=27 AND Currency=@Currency)
			BEGIN
				INSERT INTO #BetLimit(Sporttype,Bettype,MinBet,MaxBet,MaxPerMatch)
				EXEC Acc_Dep_CustSetting_BetLimitFullLineSettingSelect @SuperID=@SuperID,@ProductID=27,@AgentID=0 	
				INSERT INTO #BetLimitInput(Sporttype,Bettype,MinBet,MaxBet,MaxPerMatch)
				SELECT DISTINCT b.Sporttype,b.Bettype,p.MinBet,p.MaxBet,p.MaxPerMatch
				FROM #BetLimit b
					CROSS JOIN #Product p		
				WHERE p.ProductID=27 AND p.Currency=@Currency	
				TRUNCATE TABLE #BetLimit

				INSERT INTO #SportsStatus(ProductID,Sporttype ,Bettype,bitmapOrder,IsDisable,IsDisableDownLine,HasDownline,IsDisableUpline)
				EXEC Acc_Dep_CustSetting_StatusSelect @ProductID=27,@CustID=@SuperID
				SELECT @SporttypeID=Sporttype,@BettypeID=Bettype,@bitmapOrder=bitmapOrder FROM #SportsStatus

				EXEC Acc_Dep_CustSetting_StatusUpd @ProductID=27,@CustID=@SuperID,@IsDisabled=0,@IsDisabledDownLine=0,@SportType=@SportTypeID,@BetType=@BetTypeID,@bitmapOrder=@bitmapOrder,@UserID=@CreatorID,@IP=@IP,
					@IsAgentOnly=0,@ErrCode=@ErrCode OUTPUT,@ErrMsg=@ErrMsg OUTPUT

				IF @ErrCode<>0
				BEGIN
					SELECT @ErrMsg = @ErrMsg + 'Status DCS Virtual Sports 2.'+@Super
					DELETE FROM Dep_LicenseeProductSetting WHERE CustID=@SuperID
					SELECT @ListCustIDRollBack= CAST(@SuperID AS VARCHAR(20))+','+
												CAST(@MasterID AS VARCHAR(20))+','+
												CAST(@AgentID AS VARCHAR(20))+','+
												CAST(@AccMasterID AS VARCHAR(20))+','+
												CAST(@AccAgentID AS VARCHAR(20))+','
					SELECT @ListCustIDRollBack=@ListCustIDRollBack+				
						ISNULL(STUFF((Select ','+ CAST(CustID AS VARCHAR(20))
						from #tempDumCustID T1
						FOR XML PATH('')),1,1,''),'')
					SELECT @ListCustIDRollBack=@ListCustIDRollBack+','
					SELECT @ListCustIDRollBack=@ListCustIDRollBack+				
						ISNULL(STUFF((Select ','+ CAST(CustID AS VARCHAR(20))
						from #tempSubCustID T1
						FOR XML PATH('')),1,1,''),'')
					EXEC Dot_Dep_RollBackLicenseeDCS @ListCustID=@ListCustIDRollBack
					RETURN
				END	

				TRUNCATE TABLE #SportsStatus
				-- Insert PT
				SELECT  @PT_XML = ('<ROOT>' + (
							SELECT 
								 SportType AS 'SportType'
								,Bettype AS 'BetType'
								,IsLive AS 'IsLive'
								,@PT_VirtualSports2 AS 'PT'
							FROM dbo.f_Dep_CustSetting_SportBetTypeSettingSelect(27,1) 
							FOR XML RAW('PT')) + '</ROOT>')
				EXEC Acc_Dep_CustSetting_PositionTakingSettingUpd @SuperID=@SuperID,@AgentID=@AgentID,@IsAgentOnly=0,@PT=@PT_XML,@ProductID=27,@UserID=@CreatorID,@IP=@IP,
							@ErrCode=@ErrCode OUTPUT,@ErrMsg=@ErrMsg OUTPUT

				IF @ErrCode<>0
				BEGIN
					SELECT @ErrMsg = @ErrMsg + 'PT DCS Virtual Sports 2.'+@Agent
					DELETE FROM Dep_LicenseeProductSetting WHERE CustID=@SuperID
					SELECT @ListCustIDRollBack= CAST(@SuperID AS VARCHAR(20))+','+
												CAST(@MasterID AS VARCHAR(20))+','+
												CAST(@AgentID AS VARCHAR(20))+','+
												CAST(@AccMasterID AS VARCHAR(20))+','+
												CAST(@AccAgentID AS VARCHAR(20))+','
					SELECT @ListCustIDRollBack=@ListCustIDRollBack+				
						ISNULL(STUFF((Select ','+ CAST(CustID AS VARCHAR(20))
						from #tempDumCustID T1
						FOR XML PATH('')),1,1,''),'')
					SELECT @ListCustIDRollBack=@ListCustIDRollBack+','
					SELECT @ListCustIDRollBack=@ListCustIDRollBack+				
						ISNULL(STUFF((Select ','+ CAST(CustID AS VARCHAR(20))
						from #tempSubCustID T1
						FOR XML PATH('')),1,1,''),'')	
					EXEC Dot_Dep_RollBackLicenseeDCS @ListCustID=@ListCustIDRollBack
					RETURN
				END	

				IF @IsCreateSub=1  
				BEGIN
					UPDATE #tempSubCustID SET isfinished=0
					WHILE (1 = 1)
					BEGIN		
						UPDATE TOP (1) #tempSubCustID
						SET isfinished = 1
							,@tmpSubCustID=CustID
						WHERE isfinished = 0

						IF @@ROWCOUNT = 0 OR @ErrCode<>0 BREAK 
						-- Insert PT
						SELECT  @PT_XML = ('<ROOT>' + (
									SELECT 
										 SportType AS 'SportType'
										,Bettype AS 'BetType'
										,IsLive AS 'IsLive'
										,@PT_VirtualSports2 AS 'PT'
									FROM dbo.f_Dep_CustSetting_SportBetTypeSettingSelect(27,1)
									FOR XML RAW('PT')) + '</ROOT>')
						EXEC Acc_Dep_CustSetting_PositionTakingSettingUpd @SuperID=@SuperID,@AgentID=@tmpSubCustID,@IsAgentOnly=1,@PT=@PT_XML,@ProductID=27,@UserID=@CreatorID,@IP=@IP,
							@ErrCode=@ErrCode OUTPUT,@ErrMsg=@ErrMsg OUTPUT
						
					END					
					IF @ErrCode<>0
					BEGIN
						SELECT @ErrMsg = @ErrMsg + 'PT DCS Virtual Sports 2 Sub licensees.'
						DELETE FROM Dep_LicenseeProductSetting WHERE CustID=@SuperID
						SELECT @ListCustIDRollBack= CAST(@SuperID AS VARCHAR(20))+','+
												CAST(@MasterID AS VARCHAR(20))+','+
												CAST(@AgentID AS VARCHAR(20))+','+
												CAST(@AccMasterID AS VARCHAR(20))+','+
												CAST(@AccAgentID AS VARCHAR(20))+','
						SELECT @ListCustIDRollBack=@ListCustIDRollBack+				
						ISNULL(STUFF((Select ','+ CAST(CustID AS VARCHAR(20))
						from #tempDumCustID T1
						FOR XML PATH('')),1,1,''),'')
						SELECT @ListCustIDRollBack=@ListCustIDRollBack+','
						SELECT @ListCustIDRollBack=@ListCustIDRollBack+				
							ISNULL(STUFF((Select ','+ CAST(CustID AS VARCHAR(20))
							from #tempSubCustID T1
							FOR XML PATH('')),1,1,''),'')	
						EXEC Dot_Dep_RollBackLicenseeDCS @ListCustID=@ListCustIDRollBack
						RETURN
					END			
				END
			END

			-- lottery , Sports Lottery
			TRUNCATE TABLE #tempProduct
			INSERT INTO #tempProduct(ProductID, PT,ProductName)
			SELECT DISTINCT ProductID 
				,@PT_Loterry AS PT
				,CASE WHEN ProductID = 28 THEN 'Lottery' ELSE 'Sports Lottery' END AS ProductName
			FROM #Product 
			WHERE ProductID in (28,63) AND Currency=@Currency
	
			IF EXISTS(SELECT TOP 1 1 FROM #tempProduct)
			BEGIN	
				WHILE(1 =1)
				BEGIN
					
					UPDATE TOP (1) c 
					SET c.isfinished = 1
						,@ProductID = c.ProductID
						,@PT_TEMP = C.PT
						,@ProductName = C.ProductName
					FROM #tempProduct c 
					WHERE isfinished = 0
					
					IF @@ROWCOUNT = 0 BREAK
					
					INSERT INTO #BetLimit(Sporttype,Bettype,MinBet,MaxBet,MaxPerMatch)
					EXEC Acc_Dep_CustSetting_BetLimitFullLineSettingSelect @SuperID=@SuperID,@ProductID=@ProductID,@AgentID=0 	
					INSERT INTO #BetLimitInput(Sporttype,Bettype,MinBet,MaxBet,MaxPerMatch)
					SELECT DISTINCT b.Sporttype,b.Bettype,p.MinBet,p.MaxBet,p.MaxPerMatch
					FROM #BetLimit b
						CROSS JOIN #Product p  	
					WHERE p.ProductID=@ProductID AND p.Currency=@Currency	
					TRUNCATE TABLE #BetLimit	
						
					INSERT INTO #SportsStatus(ProductID,Sporttype ,Bettype,bitmapOrder,IsDisable,IsDisableDownLine,HasDownline,IsDisableUpline)
					EXEC Acc_Dep_CustSetting_StatusSelect @ProductID=@ProductID,@CustID=@SuperID
					SELECT @SporttypeID=Sporttype,@BettypeID=Bettype,@bitmapOrder=bitmapOrder FROM #SportsStatus

					EXEC Acc_Dep_CustSetting_StatusUpd @ProductID=@ProductID,@CustID=@SuperID,@IsDisabled=0,@IsDisabledDownLine=0,@SportType=@SportTypeID,@BetType=@BetTypeID,@bitmapOrder=@bitmapOrder,@UserID=@CreatorID,@IP=@IP,
						@IsAgentOnly=0,@ErrCode=@ErrCode OUTPUT,@ErrMsg=@ErrMsg OUTPUT

					IF @ErrCode<>0
					BEGIN
						SELECT @ErrMsg = @ErrMsg + 'Status DCS ' + @ProductName + '.' +@Super
						DELETE FROM Dep_LicenseeProductSetting WHERE CustID=@SuperID
						SELECT @ListCustIDRollBack= CAST(@SuperID AS VARCHAR(20))+','+
												CAST(@MasterID AS VARCHAR(20))+','+
												CAST(@AgentID AS VARCHAR(20))+','+
												CAST(@AccMasterID AS VARCHAR(20))+','+
												CAST(@AccAgentID AS VARCHAR(20))+','
						SELECT @ListCustIDRollBack=@ListCustIDRollBack+				
							ISNULL(STUFF((Select ','+ CAST(CustID AS VARCHAR(20))
							from #tempDumCustID T1
							FOR XML PATH('')),1,1,''),'')
						SELECT @ListCustIDRollBack=@ListCustIDRollBack+','	
						SELECT @ListCustIDRollBack=@ListCustIDRollBack+				
							ISNULL(STUFF((Select ','+ CAST(CustID AS VARCHAR(20))
							from #tempSubCustID T1
							FOR XML PATH('')),1,1,''),'')
						EXEC Dot_Dep_RollBackLicenseeDCS @ListCustID=@ListCustIDRollBack
						RETURN
					END	

					TRUNCATE TABLE #SportsStatus
					IF @ProductID = 28
					BEGIN
						-- Insert PT
						SELECT  @PT_XML = ('<ROOT>' + (
									SELECT 
										 SportType AS 'SportType'
										,Bettype AS 'BetType'
										,IsLive AS 'IsLive'
										,@PT_TEMP AS 'PT'
									FROM dbo.f_Dep_CustSetting_SportBetTypeSettingSelect(@ProductID,1)
									FOR XML RAW('PT')) + '</ROOT>')
						EXEC Acc_Dep_CustSetting_PositionTakingSettingUpd @SuperID=@SuperID,@AgentID=@AgentID,@IsAgentOnly=0,@PT=@PT_XML,@ProductID=@ProductID,@UserID=@CreatorID,@IP=@IP,
								@ErrCode=@ErrCode OUTPUT,@ErrMsg=@ErrMsg OUTPUT

						IF @ErrCode<>0
						BEGIN
							SELECT @ErrMsg = @ErrMsg + 'PT DCS ' + @ProductName + '.' +@Super
							DELETE FROM Dep_LicenseeProductSetting WHERE CustID=@SuperID
							SELECT @ListCustIDRollBack= CAST(@SuperID AS VARCHAR(20))+','+
													CAST(@MasterID AS VARCHAR(20))+','+
													CAST(@AgentID AS VARCHAR(20))+','+
													CAST(@AccMasterID AS VARCHAR(20))+','+
													CAST(@AccAgentID AS VARCHAR(20))+','
							SELECT @ListCustIDRollBack=@ListCustIDRollBack+				
								ISNULL(STUFF((Select ','+ CAST(CustID AS VARCHAR(20))
								from #tempDumCustID T1
								FOR XML PATH('')),1,1,''),'')
							SELECT @ListCustIDRollBack=@ListCustIDRollBack+','
							SELECT @ListCustIDRollBack=@ListCustIDRollBack+				
								ISNULL(STUFF((Select ','+ CAST(CustID AS VARCHAR(20))
								from #tempSubCustID T1
								FOR XML PATH('')),1,1,''),'')
							EXEC Dot_Dep_RollBackLicenseeDCS @ListCustID=@ListCustIDRollBack
							RETURN
						END	

						IF @IsCreateSub=1  
						BEGIN
							UPDATE #tempSubCustID SET isfinished=0
							WHILE (1 = 1)
							BEGIN		
								UPDATE TOP (1) #tempSubCustID
								SET isfinished = 1
									,@tmpSubCustID=CustID
								WHERE isfinished = 0

								IF @@ROWCOUNT = 0 OR @ErrCode<>0 BREAK 
								-- Insert PT
								SELECT  @PT_XML = ('<ROOT>' + (
											SELECT 
												 SportType AS 'SportType'
												,Bettype AS 'BetType'
												,IsLive AS 'IsLive'
												,@PT_TEMP AS 'PT'
											FROM dbo.f_Dep_CustSetting_SportBetTypeSettingSelect(@ProductID,1) 
											FOR XML RAW('PT')) + '</ROOT>')		
								EXEC Acc_Dep_CustSetting_PositionTakingSettingUpd @SuperID=@SuperID,@AgentID=@tmpSubCustID,@IsAgentOnly=1,@PT=@PT_XML,@ProductID=@ProductID,@UserID=@CreatorID,@IP=@IP,
									@ErrCode=@ErrCode OUTPUT,@ErrMsg=@ErrMsg OUTPUT													
							END	

							
							IF @ErrCode<>0
							BEGIN
								SELECT @ErrMsg = @ErrMsg + 'PT DCS ' + @ProductName + ' sub licensees.'
								DELETE FROM Dep_LicenseeProductSetting WHERE CustID=@SuperID
								SELECT @ListCustIDRollBack= CAST(@SuperID AS VARCHAR(20))+','+
														CAST(@MasterID AS VARCHAR(20))+','+
														CAST(@AgentID AS VARCHAR(20))+','+
														CAST(@AccMasterID AS VARCHAR(20))+','+
														CAST(@AccAgentID AS VARCHAR(20))+','
								SELECT @ListCustIDRollBack=@ListCustIDRollBack+				
									ISNULL(STUFF((Select ','+ CAST(CustID AS VARCHAR(20))
									from #tempDumCustID T1
									FOR XML PATH('')),1,1,''),'')
								SELECT @ListCustIDRollBack=@ListCustIDRollBack+',' 	
								SELECT @ListCustIDRollBack=@ListCustIDRollBack+				
									ISNULL(STUFF((Select ','+ CAST(CustID AS VARCHAR(20))
									from #tempSubCustID T1
									FOR XML PATH('')),1,1,''),'')
								EXEC Dot_Dep_RollBackLicenseeDCS @ListCustID=@ListCustIDRollBack
								RETURN
							END	
					
						END
					END
				END
			END
			
			-- Virtual Sports 3
			TRUNCATE TABLE #tempProduct
			INSERT INTO #tempProduct(ProductID, PT,ProductName)
			SELECT DISTINCT ProductID 
				,@PT_VS3 AS PT
				,'Virtual Sports 3'  AS ProductName
			FROM #Product 
			WHERE ProductID in (49) AND Currency=@Currency
	
			IF EXISTS(SELECT TOP 1 1 FROM #tempProduct)
			BEGIN	
				WHILE(1 =1)
				BEGIN
					
					UPDATE TOP (1) c 
					SET c.isfinished = 1
						,@ProductID = c.ProductID
						,@PT_TEMP = C.PT
						,@ProductName = C.ProductName
					FROM #tempProduct c 
					WHERE isfinished = 0
					
					IF @@ROWCOUNT = 0 BREAK
					
					INSERT INTO #NewBetLimit(Sporttype,Bettype,MinBet,MaxBet)
					EXEC Acc_Dep_CustSetting_NewBetLimitFullLineSettingSelect @SuperID=@SuperID,@ProductID=@ProductID,@AgentID=0 	
					INSERT INTO #NewBetLimitInput(Sporttype,Bettype,MinBet,MaxBet)
					SELECT DISTINCT b.Sporttype,b.Bettype,p.MinBet,p.MaxBet
					FROM #NewBetLimit b
						CROSS JOIN #Product p  	
					WHERE p.ProductID=@ProductID AND p.Currency=@Currency	
					TRUNCATE TABLE #NewBetLimit	
						
					INSERT INTO #SportsStatus(ProductID,Sporttype ,Bettype,bitmapOrder,IsDisable,IsDisableDownLine,HasDownline,IsDisableUpline)
					EXEC Acc_Dep_CustSetting_StatusSelect @ProductID=@ProductID,@CustID=@SuperID
					SELECT @SporttypeID=Sporttype,@BettypeID=Bettype,@bitmapOrder=bitmapOrder FROM #SportsStatus

					EXEC Acc_Dep_CustSetting_StatusUpd @ProductID=@ProductID,@CustID=@SuperID,@IsDisabled=0,@IsDisabledDownLine=0,@SportType=@SportTypeID,@BetType=@BetTypeID,@bitmapOrder=@bitmapOrder,@UserID=@CreatorID,@IP=@IP,
						@IsAgentOnly=0,@ErrCode=@ErrCode OUTPUT,@ErrMsg=@ErrMsg OUTPUT

					IF @ErrCode<>0
					BEGIN
						SELECT @ErrMsg = @ErrMsg + 'Status DCS ' + @ProductName + '.' +@Super
						DELETE FROM Dep_LicenseeProductSetting WHERE CustID=@SuperID
						SELECT @ListCustIDRollBack= CAST(@SuperID AS VARCHAR(20))+','+
												CAST(@MasterID AS VARCHAR(20))+','+
												CAST(@AgentID AS VARCHAR(20))+','+
												CAST(@AccMasterID AS VARCHAR(20))+','+
												CAST(@AccAgentID AS VARCHAR(20))+','
						SELECT @ListCustIDRollBack=@ListCustIDRollBack+				
							ISNULL(STUFF((Select ','+ CAST(CustID AS VARCHAR(20))
							from #tempDumCustID T1
							FOR XML PATH('')),1,1,''),'')
						SELECT @ListCustIDRollBack=@ListCustIDRollBack+','	
						SELECT @ListCustIDRollBack=@ListCustIDRollBack+				
							ISNULL(STUFF((Select ','+ CAST(CustID AS VARCHAR(20))
							from #tempSubCustID T1
							FOR XML PATH('')),1,1,''),'')
						EXEC Dot_Dep_RollBackLicenseeDCS @ListCustID=@ListCustIDRollBack
						RETURN
					END	

					TRUNCATE TABLE #SportsStatus
					
					-- Insert PT
					SELECT  @PT_XML = ('<ROOT>' + (
								SELECT 
									 SportType AS 'SportType'
									,Bettype AS 'BetType'
									,IsLive AS 'IsLive'
									,@PT_TEMP AS 'PT'
								FROM dbo.f_Dep_CustSetting_SportBetTypeSettingSelect(@ProductID,1)
								FOR XML RAW('PT')) + '</ROOT>')
					EXEC Acc_Dep_CustSetting_PositionTakingSettingUpd @SuperID=@SuperID,@AgentID=@AgentID,@IsAgentOnly=0,@PT=@PT_XML,@ProductID=@ProductID,@UserID=@CreatorID,@IP=@IP,
							@ErrCode=@ErrCode OUTPUT,@ErrMsg=@ErrMsg OUTPUT

					IF @ErrCode<>0
					BEGIN
						SELECT @ErrMsg = @ErrMsg + 'PT DCS ' + @ProductName + '.' +@Super
						DELETE FROM Dep_LicenseeProductSetting WHERE CustID=@SuperID
						SELECT @ListCustIDRollBack= CAST(@SuperID AS VARCHAR(20))+','+
												CAST(@MasterID AS VARCHAR(20))+','+
												CAST(@AgentID AS VARCHAR(20))+','+
												CAST(@AccMasterID AS VARCHAR(20))+','+
												CAST(@AccAgentID AS VARCHAR(20))+','
						SELECT @ListCustIDRollBack=@ListCustIDRollBack+				
							ISNULL(STUFF((Select ','+ CAST(CustID AS VARCHAR(20))
							from #tempDumCustID T1
							FOR XML PATH('')),1,1,''),'')
						SELECT @ListCustIDRollBack=@ListCustIDRollBack+','
						SELECT @ListCustIDRollBack=@ListCustIDRollBack+				
							ISNULL(STUFF((Select ','+ CAST(CustID AS VARCHAR(20))
							from #tempSubCustID T1
							FOR XML PATH('')),1,1,''),'')
						EXEC Dot_Dep_RollBackLicenseeDCS @ListCustID=@ListCustIDRollBack
						RETURN
					END	

					IF @IsCreateSub=1  
					BEGIN
						UPDATE #tempSubCustID SET isfinished=0
						WHILE (1 = 1)
						BEGIN		
							UPDATE TOP (1) #tempSubCustID
							SET isfinished = 1
								,@tmpSubCustID=CustID
							WHERE isfinished = 0

							IF @@ROWCOUNT = 0 OR @ErrCode<>0 BREAK 
							-- Insert PT
							SELECT  @PT_XML = ('<ROOT>' + (
										SELECT 
											 SportType AS 'SportType'
											,Bettype AS 'BetType'
											,IsLive AS 'IsLive'
											,@PT_TEMP AS 'PT'
										FROM dbo.f_Dep_CustSetting_SportBetTypeSettingSelect(@ProductID,1) 
										FOR XML RAW('PT')) + '</ROOT>')		
							EXEC Acc_Dep_CustSetting_PositionTakingSettingUpd @SuperID=@SuperID,@AgentID=@tmpSubCustID,@IsAgentOnly=1,@PT=@PT_XML,@ProductID=@ProductID,@UserID=@CreatorID,@IP=@IP,
								@ErrCode=@ErrCode OUTPUT,@ErrMsg=@ErrMsg OUTPUT													
						END	

						
						IF @ErrCode<>0
						BEGIN
							SELECT @ErrMsg = @ErrMsg + 'PT DCS ' + @ProductName + ' sub licensees.'
							DELETE FROM Dep_LicenseeProductSetting WHERE CustID=@SuperID
							SELECT @ListCustIDRollBack= CAST(@SuperID AS VARCHAR(20))+','+
													CAST(@MasterID AS VARCHAR(20))+','+
													CAST(@AgentID AS VARCHAR(20))+','+
													CAST(@AccMasterID AS VARCHAR(20))+','+
													CAST(@AccAgentID AS VARCHAR(20))+','
							SELECT @ListCustIDRollBack=@ListCustIDRollBack+				
								ISNULL(STUFF((Select ','+ CAST(CustID AS VARCHAR(20))
								from #tempDumCustID T1
								FOR XML PATH('')),1,1,''),'')
							SELECT @ListCustIDRollBack=@ListCustIDRollBack+',' 	
							SELECT @ListCustIDRollBack=@ListCustIDRollBack+				
								ISNULL(STUFF((Select ','+ CAST(CustID AS VARCHAR(20))
								from #tempSubCustID T1
								FOR XML PATH('')),1,1,''),'')
							EXEC Dot_Dep_RollBackLicenseeDCS @ListCustID=@ListCustIDRollBack
							RETURN
						END	
				
					END
					
				END
			END

			--Table Game
			IF EXISTS(SELECT TOP 1 1 FROM #Product WHERE ProductID=40 AND Currency=@Currency)
			BEGIN
				INSERT INTO #BetLimit(Sporttype,Bettype,MinBet,MaxBet,MaxPerMatch)
				EXEC Acc_Dep_CustSetting_BetLimitFullLineSettingSelect @SuperID=@SuperID,@ProductID=40,@AgentID=0 		
			
				INSERT INTO #BetLimitInput(Sporttype,Bettype,MinBet,MaxBet,MaxPerMatch)
				SELECT DISTINCT b.Sporttype,b.Bettype,p.MinBet,p.MaxBet,p.MaxPerMatch
				FROM #BetLimit b
					CROSS JOIN #Product p		
				WHERE p.ProductID=40 AND p.Currency=@Currency
				TRUNCATE TABLE #BetLimit

				INSERT INTO #SportsStatus(ProductID,Sporttype ,Bettype,bitmapOrder,IsDisable,IsDisableDownLine,HasDownline,IsDisableUpline)
				EXEC Acc_Dep_CustSetting_StatusSelect @ProductID=40,@CustID=@SuperID
				SELECT @SporttypeID=Sporttype,@BettypeID=Bettype,@bitmapOrder=bitmapOrder FROM #SportsStatus
				-- Insert status
				EXEC Acc_Dep_CustSetting_StatusUpd @ProductID=40,@CustID=@SuperID,@IsDisabled=0,@IsDisabledDownLine=0,@SportType=@SportTypeID,@BetType=@BetTypeID,@bitmapOrder=@bitmapOrder,@UserID=@CreatorID,@IP=@IP,
					@IsAgentOnly=0,@ErrCode=@ErrCode OUTPUT,@ErrMsg=@ErrMsg OUTPUT
						
				IF @ErrCode<>0
				BEGIN
					SELECT @ErrMsg = @ErrMsg + 'Status DCS Table Game.'
					DELETE FROM Dep_LicenseeProductSetting WHERE CustID=@SuperID
					SELECT @ListCustIDRollBack= CAST(@SuperID AS VARCHAR(20))+','+
													CAST(@MasterID AS VARCHAR(20))+','+
													CAST(@AgentID AS VARCHAR(20))+','+
													CAST(@AccMasterID AS VARCHAR(20))+','+
													CAST(@AccAgentID AS VARCHAR(20))+','
					SELECT @ListCustIDRollBack=@ListCustIDRollBack+				
						ISNULL(STUFF((Select ','+ CAST(CustID AS VARCHAR(20))
						from #tempDumCustID T1
						FOR XML PATH('')),1,1,''),'')
					SELECT @ListCustIDRollBack=@ListCustIDRollBack+','
					SELECT @ListCustIDRollBack=@ListCustIDRollBack+				
						ISNULL(STUFF((Select ','+ CAST(CustID AS VARCHAR(20))
						from #tempSubCustID T1
						FOR XML PATH('')),1,1,''),'')	
					EXEC Dot_Dep_RollBackLicenseeDCS @ListCustID=@ListCustIDRollBack
					
					RETURN
				END		

				TRUNCATE TABLE #SportsStatus
				-- Insert PT
				SELECT  @PT_XML = ('<ROOT>' + (
							SELECT 
								 SportType AS 'SportType'
								,Bettype AS 'BetType'
								,IsLive AS 'IsLive'
								,@PT_TableGame AS 'PT'
							FROM dbo.f_Dep_CustSetting_SportBetTypeSettingSelect(40,1)
							FOR XML RAW('PT')) + '</ROOT>')	
				EXEC Acc_Dep_CustSetting_PositionTakingSettingUpd @SuperID=@SuperID,@AgentID=@AgentID,@IsAgentOnly=0,@PT=@PT_XML,@ProductID=40,@UserID=@CreatorID,@IP=@IP,
						@ErrCode=@ErrCode OUTPUT,@ErrMsg=@ErrMsg OUTPUT

				IF @ErrCode<>0
				BEGIN
					SELECT @ErrMsg = @ErrMsg + 'PT DCS Table Game.' +@Agent
					DELETE FROM Dep_LicenseeProductSetting WHERE CustID=@SuperID
					SELECT @ListCustIDRollBack= CAST(@SuperID AS VARCHAR(20))+','+
													CAST(@MasterID AS VARCHAR(20))+','+
													CAST(@AgentID AS VARCHAR(20))+','+
													CAST(@AccMasterID AS VARCHAR(20))+','+
													CAST(@AccAgentID AS VARCHAR(20))+','
					SELECT @ListCustIDRollBack=@ListCustIDRollBack+				
						ISNULL(STUFF((Select ','+ CAST(CustID AS VARCHAR(20))
						from #tempDumCustID T1
						FOR XML PATH('')),1,1,''),'')
					SELECT @ListCustIDRollBack=@ListCustIDRollBack+','
					SELECT @ListCustIDRollBack=@ListCustIDRollBack+				
						ISNULL(STUFF((Select ','+ CAST(CustID AS VARCHAR(20))
						from #tempSubCustID T1
						FOR XML PATH('')),1,1,''),'') 	
					EXEC Dot_Dep_RollBackLicenseeDCS @ListCustID=@ListCustIDRollBack
					RETURN
				END		

				IF @IsCreateSub=1  
				BEGIN
					UPDATE #tempSubCustID SET isfinished=0
					WHILE (1 = 1)
					BEGIN		
						UPDATE TOP (1) #tempSubCustID
						SET isfinished = 1
							,@tmpSubCustID=CustID
						WHERE isfinished = 0

						IF @@ROWCOUNT = 0 OR @ErrCode<>0 BREAK
						-- Insert PT
						SELECT  @PT_XML = ('<ROOT>' + (
									SELECT 
										 SportType AS 'SportType'
										,Bettype AS 'BetType'
										,IsLive AS 'IsLive'
										,@PT_TableGame AS 'PT'
									FROM dbo.f_Dep_CustSetting_SportBetTypeSettingSelect(40,1)
									FOR XML RAW('PT')) + '</ROOT>') 
						EXEC Acc_Dep_CustSetting_PositionTakingSettingUpd @SuperID=@SuperID,@AgentID=@tmpSubCustID,@IsAgentOnly=1,@PT=@PT_XML,@ProductID=40,@UserID=@CreatorID,@IP=@IP,
							@ErrCode=@ErrCode OUTPUT,@ErrMsg=@ErrMsg OUTPUT						
					END					
					IF @ErrCode<>0
					BEGIN
						SELECT @ErrMsg = @ErrMsg + 'PT DCS Table Game sub licensees.'
						DELETE FROM Dep_LicenseeProductSetting WHERE CustID=@SuperID
						SELECT @ListCustIDRollBack= CAST(@SuperID AS VARCHAR(20))+','+
													CAST(@MasterID AS VARCHAR(20))+','+
													CAST(@AgentID AS VARCHAR(20))+','+
													CAST(@AccMasterID AS VARCHAR(20))+','+
													CAST(@AccAgentID AS VARCHAR(20))+','
						SELECT @ListCustIDRollBack=@ListCustIDRollBack+				
						ISNULL(STUFF((Select ','+ CAST(CustID AS VARCHAR(20))
						from #tempDumCustID T1
						FOR XML PATH('')),1,1,''),'')		
						SELECT @ListCustIDRollBack=@ListCustIDRollBack+','				
						SELECT @ListCustIDRollBack=@ListCustIDRollBack+				
							ISNULL(STUFF((Select ','+ CAST(CustID AS VARCHAR(20))
							from #tempSubCustID T1
							FOR XML PATH('')),1,1,''),'')	
						EXEC Dot_Dep_RollBackLicenseeDCS @ListCustID=@ListCustIDRollBack
						RETURN
					END					
				END					
			END

			--Virtual Games , SA Gaming
			TRUNCATE TABLE #tempProduct
			INSERT INTO #tempProduct(ProductID, PT,ProductName)
			SELECT DISTINCT ProductID 
				,CASE WHEN ProductID = 38 THEN @PT_VirtualGames ELSE @PT_SAGaming END AS PT
				,CASE WHEN ProductID = 38 THEN 'Virtual Games' ELSE 'SA Gaming' END AS ProductName
			FROM #Product 
			WHERE ProductID in (38,39) AND Currency=@Currency
		
			IF EXISTS(SELECT TOP 1 1 FROM #tempProduct)
			BEGIN
				WHILE(1 =1)
				BEGIN
					
					UPDATE TOP (1) c 
					SET c.isfinished = 1
						,@ProductID = c.ProductID
						,@PT_TEMP = C.PT
						,@ProductName = C.ProductName
					FROM #tempProduct c 
					WHERE isfinished = 0
					
					IF @@ROWCOUNT = 0 BREAK
			
					INSERT INTO #SportsStatus(ProductID,Sporttype ,Bettype,bitmapOrder,IsDisable,IsDisableDownLine,HasDownline,IsDisableUpline)
					EXEC Acc_Dep_CustSetting_StatusSelect @ProductID=@ProductID,@CustID=@SuperID
					SELECT @SporttypeID=Sporttype,@BettypeID=Bettype,@bitmapOrder=bitmapOrder FROM #SportsStatus
					-- Insert status
					EXEC Acc_Dep_CustSetting_StatusUpd @ProductID=@ProductID,@CustID=@SuperID,@IsDisabled=0,@IsDisabledDownLine=0,@SportType=@SportTypeID,@BetType=@BetTypeID,@bitmapOrder=@bitmapOrder,@UserID=@CreatorID,@IP=@IP,
						@IsAgentOnly=0,@ErrCode=@ErrCode OUTPUT,@ErrMsg=@ErrMsg OUTPUT
							
					IF @ErrCode<>0
					BEGIN
						SELECT @ErrMsg = @ErrMsg + 'Status DCS '+ @ProductName +'.'
						DELETE FROM Dep_LicenseeProductSetting WHERE CustID=@SuperID
						SELECT @ListCustIDRollBack= CAST(@SuperID AS VARCHAR(20))+','+
														CAST(@MasterID AS VARCHAR(20))+','+
														CAST(@AgentID AS VARCHAR(20))+','+
														CAST(@AccMasterID AS VARCHAR(20))+','+
														CAST(@AccAgentID AS VARCHAR(20))+','
						SELECT @ListCustIDRollBack=@ListCustIDRollBack+				
							ISNULL(STUFF((Select ','+ CAST(CustID AS VARCHAR(20))
							from #tempDumCustID T1
							FOR XML PATH('')),1,1,''),'')
						SELECT @ListCustIDRollBack=@ListCustIDRollBack+','
						SELECT @ListCustIDRollBack=@ListCustIDRollBack+				
							ISNULL(STUFF((Select ','+ CAST(CustID AS VARCHAR(20))
							from #tempSubCustID T1
							FOR XML PATH('')),1,1,''),'')	
						EXEC Dot_Dep_RollBackLicenseeDCS @ListCustID=@ListCustIDRollBack
						
						RETURN
					END		

					TRUNCATE TABLE #SportsStatus
					-- Insert PT
					SELECT  @PT_XML = ('<ROOT>' + (
										SELECT 
											 SportType AS 'SportType'
											,Bettype AS 'BetType'
											,IsLive AS 'IsLive'
											,@PT_TEMP AS 'PT'
										FROM dbo.f_Dep_CustSetting_SportBetTypeSettingSelect(@ProductID,1)
										FOR XML RAW('PT')) + '</ROOT>')
					EXEC Acc_Dep_CustSetting_PositionTakingSettingUpd @SuperID=@SuperID,@AgentID=@AgentID,@IsAgentOnly=0,@PT=@PT_XML,@ProductID=@ProductID,@UserID=@CreatorID,@IP=@IP,
							@ErrCode=@ErrCode OUTPUT,@ErrMsg=@ErrMsg OUTPUT

					IF @ErrCode<>0
					BEGIN
						SELECT @ErrMsg = @ErrMsg + 'PT DCS ' + @ProductName+'.' +@Agent
						DELETE FROM Dep_LicenseeProductSetting WHERE CustID=@SuperID
						SELECT @ListCustIDRollBack= CAST(@SuperID AS VARCHAR(20))+','+
														CAST(@MasterID AS VARCHAR(20))+','+
														CAST(@AgentID AS VARCHAR(20))+','+
														CAST(@AccMasterID AS VARCHAR(20))+','+
														CAST(@AccAgentID AS VARCHAR(20))+','
						SELECT @ListCustIDRollBack=@ListCustIDRollBack+				
							ISNULL(STUFF((Select ','+ CAST(CustID AS VARCHAR(20))
							from #tempDumCustID T1
							FOR XML PATH('')),1,1,''),'')
						SELECT @ListCustIDRollBack=@ListCustIDRollBack+','
						SELECT @ListCustIDRollBack=@ListCustIDRollBack+				
							ISNULL(STUFF((Select ','+ CAST(CustID AS VARCHAR(20))
							from #tempSubCustID T1
							FOR XML PATH('')),1,1,''),'') 	
						EXEC Dot_Dep_RollBackLicenseeDCS @ListCustID=@ListCustIDRollBack
						RETURN
					END		

					IF @IsCreateSub=1  
					BEGIN
						UPDATE #tempSubCustID SET isfinished=0
						WHILE (1 = 1)
						BEGIN		
							UPDATE TOP (1) #tempSubCustID
							SET isfinished = 1
								,@tmpSubCustID=CustID
							WHERE isfinished = 0

							IF @@ROWCOUNT = 0 OR @ErrCode<>0 BREAK 
							-- Insert PT
							SELECT  @PT_XML = ('<ROOT>' + (
												SELECT 
													 SportType AS 'SportType'
													,Bettype AS 'BetType'
													,IsLive AS 'IsLive'
													,@PT_TEMP AS 'PT'
												FROM dbo.f_Dep_CustSetting_SportBetTypeSettingSelect(@ProductID,1)  
												FOR XML RAW('PT')) + '</ROOT>')
							EXEC Acc_Dep_CustSetting_PositionTakingSettingUpd @SuperID=@SuperID,@AgentID=@tmpSubCustID,@IsAgentOnly=1,@PT=@PT_XML,@ProductID=@ProductID,@UserID=@CreatorID,@IP=@IP,
								@ErrCode=@ErrCode OUTPUT,@ErrMsg=@ErrMsg OUTPUT						
						END					
						IF @ErrCode<>0
						BEGIN
							SELECT @ErrMsg = @ErrMsg + 'PT DCS '+ @ProductName +' sub licensees.'
							DELETE FROM Dep_LicenseeProductSetting WHERE CustID=@SuperID
							SELECT @ListCustIDRollBack= CAST(@SuperID AS VARCHAR(20))+','+
														CAST(@MasterID AS VARCHAR(20))+','+
														CAST(@AgentID AS VARCHAR(20))+','+
														CAST(@AccMasterID AS VARCHAR(20))+','+
														CAST(@AccAgentID AS VARCHAR(20))+','
							SELECT @ListCustIDRollBack=@ListCustIDRollBack+				
							ISNULL(STUFF((Select ','+ CAST(CustID AS VARCHAR(20))
							from #tempDumCustID T1
							FOR XML PATH('')),1,1,''),'')		
							SELECT @ListCustIDRollBack=@ListCustIDRollBack+','				
							SELECT @ListCustIDRollBack=@ListCustIDRollBack+				
								ISNULL(STUFF((Select ','+ CAST(CustID AS VARCHAR(20))
								from #tempSubCustID T1
								FOR XML PATH('')),1,1,''),'')	
							EXEC Dot_Dep_RollBackLicenseeDCS @ListCustID=@ListCustIDRollBack
							RETURN
						END					
					END	
						
					INSERT INTO #StakelevelInput (ProductID,StakeLevelXML)
					SELECT  ProductID = @ProductID,
							StakelevelXML = CONVERT(VARCHAR(MAX),
																	(SELECT dp.SportType AS SportType
																		,dp.BetType as BetType
																		,SUBSTRING((
																					SELECT ',' + CONVERT(VARCHAR,StakeLevelID)
																					FROM Dep_StakeLevel WITH(NOLOCK)
																					WHERE GameTypeID = dp.BetType
																						AND exchangeID = @Currency
																						AND SiteID = @SiteID
																					FOR XML PATH('')
																					),2,1000) AS StakeLevelList
																	FROM Dep_ProductSettingDetail dp WITH(NOLOCK)
																		INNER JOIN Dep_ProductSetting d  WITH(NOLOCK) ON d.ProductSettingID = dp.ProductSettingID 
																	WHERE d.ProductID = @ProductID AND SettingType = 7	
																	FOR XML RAW ('StakeLevel'), ROOT ('ROOT') 	
																	))
				END	
			END

			--Arcadia Gaming , Saba.club,Vgaming , SG,PG Soft , AdvantPlay , AdvantPlay Mini, CG
			TRUNCATE TABLE #tempProduct
			INSERT INTO #tempProduct(ProductID, PT,ProductName)
			SELECT ProductID 
				,CASE ProductID 
						WHEN 34 THEN @PT_ArcadiaGaming  
						WHEN 36 THEN @PT_SpadeGaming  
						WHEN 55 THEN @PT_PGSoft  
						WHEN 66 THEN @PT_Vgaming  
						WHEN 67 THEN @PT_AP  
						WHEN 68 THEN @PT_ApMini  
						WHEN 62 THEN @PT_CG  
						END AS PT
				,CASE ProductID 
						WHEN 34 THEN 'Arcadia Gaming'  
						WHEN 36 THEN 'SpadeGaming' 
						WHEN 55 THEN 'PG Soft'  
						WHEN 66 THEN 'Vgaming'  
						WHEN 67 THEN 'AdvantPlay'
						WHEN 68 THEN 'AdvantPlay Mini' 
						WHEN 62 THEN 'CG' 
					END AS ProductName
			FROM #Product 
			WHERE ProductID in (34,66,36,55,62,67,68) AND Currency=@Currency
			IF EXISTS(SELECT TOP 1 1 FROM #tempProduct)
			BEGIN
				WHILE(1 =1)
				BEGIN
					
					UPDATE TOP (1) c 
					SET c.isfinished = 1
						,@ProductID = c.ProductID
						,@PT_TEMP = C.PT
						,@ProductName = C.ProductName
					FROM #tempProduct c 
					WHERE isfinished = 0
					
					IF @@ROWCOUNT = 0 BREAK
			
					INSERT INTO #SportsStatus(ProductID,Sporttype ,Bettype,bitmapOrder,IsDisable,IsDisableDownLine,HasDownline,IsDisableUpline)
					EXEC Acc_Dep_CustSetting_StatusSelect @ProductID=@ProductID,@CustID=@SuperID
					SELECT @SporttypeID=Sporttype,@BettypeID=Bettype,@bitmapOrder=bitmapOrder FROM #SportsStatus
					-- Insert status
					EXEC Acc_Dep_CustSetting_StatusUpd @ProductID=@ProductID,@CustID=@SuperID,@IsDisabled=0,@IsDisabledDownLine=0,@SportType=@SportTypeID,@BetType=@BetTypeID,@bitmapOrder=@bitmapOrder,@UserID=@CreatorID,@IP=@IP,
						@IsAgentOnly=0,@ErrCode=@ErrCode OUTPUT,@ErrMsg=@ErrMsg OUTPUT
							
					IF @ErrCode<>0
					BEGIN
						SELECT @ErrMsg = @ErrMsg + 'Status DCS '+ @ProductName +'.'
						DELETE FROM Dep_LicenseeProductSetting WHERE CustID=@SuperID
						SELECT @ListCustIDRollBack= CAST(@SuperID AS VARCHAR(20))+','+
														CAST(@MasterID AS VARCHAR(20))+','+
														CAST(@AgentID AS VARCHAR(20))+','+
														CAST(@AccMasterID AS VARCHAR(20))+','+
														CAST(@AccAgentID AS VARCHAR(20))+','
						SELECT @ListCustIDRollBack=@ListCustIDRollBack+				
							ISNULL(STUFF((Select ','+ CAST(CustID AS VARCHAR(20))
							from #tempDumCustID T1
							FOR XML PATH('')),1,1,''),'')
						SELECT @ListCustIDRollBack=@ListCustIDRollBack+','
						SELECT @ListCustIDRollBack=@ListCustIDRollBack+				
							ISNULL(STUFF((Select ','+ CAST(CustID AS VARCHAR(20))
							from #tempSubCustID T1
							FOR XML PATH('')),1,1,''),'')	
						EXEC Dot_Dep_RollBackLicenseeDCS @ListCustID=@ListCustIDRollBack
						
						RETURN
					END		

					TRUNCATE TABLE #SportsStatus
					-- Insert PT
					SELECT  @PT_XML = ('<ROOT>' + (
										SELECT 
											 SportType AS 'SportType'
											,Bettype AS 'BetType'
											,IsLive AS 'IsLive'
											,@PT_TEMP AS 'PT'
										FROM dbo.f_Dep_CustSetting_SportBetTypeSettingSelect(@ProductID,1)
										FOR XML RAW('PT')) + '</ROOT>')
					EXEC Acc_Dep_CustSetting_PositionTakingSettingUpd @SuperID=@SuperID,@AgentID=@AgentID,@IsAgentOnly=0,@PT=@PT_XML,@ProductID=@ProductID,@UserID=@CreatorID,@IP=@IP,
							@ErrCode=@ErrCode OUTPUT,@ErrMsg=@ErrMsg OUTPUT

					IF @ErrCode<>0
					BEGIN
						SELECT @ErrMsg = @ErrMsg + 'PT DCS ' + @ProductName+'.' +@Agent
						DELETE FROM Dep_LicenseeProductSetting WHERE CustID=@SuperID
						SELECT @ListCustIDRollBack= CAST(@SuperID AS VARCHAR(20))+','+
														CAST(@MasterID AS VARCHAR(20))+','+
														CAST(@AgentID AS VARCHAR(20))+','+
														CAST(@AccMasterID AS VARCHAR(20))+','+
														CAST(@AccAgentID AS VARCHAR(20))+','
						SELECT @ListCustIDRollBack=@ListCustIDRollBack+				
							ISNULL(STUFF((Select ','+ CAST(CustID AS VARCHAR(20))
							from #tempDumCustID T1
							FOR XML PATH('')),1,1,''),'')
						SELECT @ListCustIDRollBack=@ListCustIDRollBack+','
						SELECT @ListCustIDRollBack=@ListCustIDRollBack+				
							ISNULL(STUFF((Select ','+ CAST(CustID AS VARCHAR(20))
							from #tempSubCustID T1
							FOR XML PATH('')),1,1,''),'') 	
						EXEC Dot_Dep_RollBackLicenseeDCS @ListCustID=@ListCustIDRollBack
						RETURN
					END		

					IF @IsCreateSub=1  
					BEGIN
						UPDATE #tempSubCustID SET isfinished=0
						WHILE (1 = 1)
						BEGIN		
							UPDATE TOP (1) #tempSubCustID
							SET isfinished = 1
								,@tmpSubCustID=CustID
							WHERE isfinished = 0

							IF @@ROWCOUNT = 0 OR @ErrCode<>0 BREAK 
							-- Insert PT
							SELECT  @PT_XML = ('<ROOT>' + (
												SELECT 
													 SportType AS 'SportType'
													,Bettype AS 'BetType'
													,IsLive AS 'IsLive'
													,@PT_TEMP AS 'PT'
												FROM dbo.f_Dep_CustSetting_SportBetTypeSettingSelect(@ProductID,1)  
												FOR XML RAW('PT')) + '</ROOT>')
							EXEC Acc_Dep_CustSetting_PositionTakingSettingUpd @SuperID=@SuperID,@AgentID=@tmpSubCustID,@IsAgentOnly=1,@PT=@PT_XML,@ProductID=@ProductID,@UserID=@CreatorID,@IP=@IP,
								@ErrCode=@ErrCode OUTPUT,@ErrMsg=@ErrMsg OUTPUT						
						END					
						IF @ErrCode<>0
						BEGIN
							SELECT @ErrMsg = @ErrMsg + 'PT DCS '+ @ProductName +' sub licensees.'
							DELETE FROM Dep_LicenseeProductSetting WHERE CustID=@SuperID
							SELECT @ListCustIDRollBack= CAST(@SuperID AS VARCHAR(20))+','+
														CAST(@MasterID AS VARCHAR(20))+','+
														CAST(@AgentID AS VARCHAR(20))+','+
														CAST(@AccMasterID AS VARCHAR(20))+','+
														CAST(@AccAgentID AS VARCHAR(20))+','
							SELECT @ListCustIDRollBack=@ListCustIDRollBack+				
							ISNULL(STUFF((Select ','+ CAST(CustID AS VARCHAR(20))
							from #tempDumCustID T1
							FOR XML PATH('')),1,1,''),'')		
							SELECT @ListCustIDRollBack=@ListCustIDRollBack+','				
							SELECT @ListCustIDRollBack=@ListCustIDRollBack+				
								ISNULL(STUFF((Select ','+ CAST(CustID AS VARCHAR(20))
								from #tempSubCustID T1
								FOR XML PATH('')),1,1,''),'')	
							EXEC Dot_Dep_RollBackLicenseeDCS @ListCustID=@ListCustIDRollBack
							RETURN
						END					
					END	
						
					INSERT INTO #StakelevelInput (ProductID,StakeLevelXML)
					SELECT  ProductID = @ProductID,
							StakelevelXML = CONVERT(VARCHAR(MAX),
																	(SELECT dp.SportType AS SportType
																		,dp.BetType as BetType
																		,SUBSTRING((
																					SELECT ',' +CONVERT(VARCHAR,StakeLevelID)
																					FROM Dep_StakeLevel WITH(NOLOCK)
																					WHERE GameTypeID = dp.BetType
																						AND exchangeID = @Currency
																					FOR XML PATH('')
																					),2,100) AS StakeLevelList
																	FROM Dep_ProductSettingDetail dp WITH(NOLOCK)
																			INNER JOIN Dep_ProductSetting d  WITH(NOLOCK) ON d.ProductSettingID = dp.ProductSettingID 
																	WHERE d.ProductID = @ProductID AND SettingType = 8	
																	FOR XML RAW ('StakeLevel'), ROOT ('ROOT') 	
																	))
													
				  
				  	UPDATE a		
					SET a.StakeLevelID = b.StakeLevelID
					FROM #Product a 
					INNER JOIN Dep_StakeLevel b WITH(NOLOCK) ON b.GameTypeID = a.Bettype AND b.ExchangeID = a.Currency
					WHERE a.ProductID = @ProductID AND a.Currency = @Currency									
				END	
			END
			
			-- Insert betlimit
			WHILE (1 = 1)
			BEGIN
				UPDATE TOP (1) #BetLimitInput
				SET isfinished = 1
					,@SporttypeID=Sporttype,@BettypeID=Bettype					
					,@MinBet=MinBet,@MaxBet=MaxBet,@MaxPerMatch=MaxPerMatch				
				WHERE isfinished = 0	
				IF @@ROWCOUNT = 0 BREAK
				SELECT @BetLimit='<ROOT><BetLimit SportType="'+ CAST(@SporttypeID AS VARCHAR(10))+'" BetType="'+CAST(@BettypeID AS VARCHAR(10))+'" MinBet="'+ CAST(@MinBet AS VARCHAR(30))+'" MaxBet="'+CAST(@MaxBet AS VARCHAR(30))+'" MaxPerMatch="'+CAST(@MaxPerMatch AS VARCHAR(30))+'"/></ROOT>'
				EXEC Acc_Dep_CustSetting_BetLimitFullLineUpd @SuperID=@SuperID,
					@BetLimit=@BetLimit,@AgentID=@AgentID,@IsAgentOnly=0,@ApplyExistedMem=1,@UserID=@CreatorID,@IP=@IP,@ErrCode=@ErrCode OUTPUT,@ErrMsg=@ErrMsg OUTPUT

				IF @ErrCode<>0
				BEGIN
					SELECT @ErrMsg = @ErrMsg + 'Betlimit DCS'+@Agent
					DELETE FROM Dep_LicenseeProductSetting WHERE CustID=@SuperID
					SELECT @ListCustIDRollBack= CAST(@SuperID AS VARCHAR(20))+','+
												CAST(@MasterID AS VARCHAR(20))+','+
												CAST(@AgentID AS VARCHAR(20))+','+
												CAST(@AccMasterID AS VARCHAR(20))+','+
												CAST(@AccAgentID AS VARCHAR(20))+','
					SELECT @ListCustIDRollBack=@ListCustIDRollBack+				
						ISNULL(STUFF((Select ','+ CAST(CustID AS VARCHAR(20))
						from #tempDumCustID T1
						FOR XML PATH('')),1,1,''),'') 
					SELECT @ListCustIDRollBack=@ListCustIDRollBack+','	
					SELECT @ListCustIDRollBack=@ListCustIDRollBack+				
						ISNULL(STUFF((Select ','+ CAST(CustID AS VARCHAR(20))
						from #tempSubCustID T1
						FOR XML PATH('')),1,1,''),'')
					EXEC Dot_Dep_RollBackLicenseeDCS @ListCustID=@ListCustIDRollBack
					RETURN
				END	
				IF @IsCreateSub=1  
				BEGIN
					UPDATE #tempSubCustID SET isfinished=0
						WHILE (1 = 1)
						BEGIN		
							UPDATE TOP (1) #tempSubCustID
							SET isfinished = 1
								,@tmpSubCustID=CustID
							WHERE isfinished = 0

							IF @@ROWCOUNT = 0 OR @ErrCode<>0 BREAK 	
							EXEC Acc_Dep_CustSetting_BetLimitFullLineUpd @SuperID=@SuperID,
							@BetLimit=@BetLimit,@AgentID=@tmpSubCustID,@IsAgentOnly=1,@ApplyExistedMem=1,@UserID=@CreatorID,@IP=@IP,@ErrCode=@ErrCode OUTPUT,@ErrMsg=@ErrMsg OUTPUT									
														
						END			

				
					IF @ErrCode<>0
					BEGIN
						SELECT @ErrMsg = @ErrMsg + 'Betlimit DCS Sub licensees'
						DELETE FROM Dep_LicenseeProductSetting WHERE CustID=@SuperID
						SELECT @ListCustIDRollBack= CAST(@SuperID AS VARCHAR(20))+','+
												CAST(@MasterID AS VARCHAR(20))+','+
												CAST(@AgentID AS VARCHAR(20))+','+
												CAST(@AccMasterID AS VARCHAR(20))+','+
												CAST(@AccAgentID AS VARCHAR(20))+','
						SELECT @ListCustIDRollBack=@ListCustIDRollBack+				
							ISNULL(STUFF((Select ','+ CAST(CustID AS VARCHAR(20))
							from #tempDumCustID T1
							FOR XML PATH('')),1,1,''),'') 	
						SELECT @ListCustIDRollBack=@ListCustIDRollBack+','
						SELECT @ListCustIDRollBack=@ListCustIDRollBack+				
							ISNULL(STUFF((Select ','+ CAST(CustID AS VARCHAR(20))
							from #tempSubCustID T1
							FOR XML PATH('')),1,1,''),'')	
						EXEC Dot_Dep_RollBackLicenseeDCS @ListCustID=@ListCustIDRollBack
						RETURN
					END	
					
				END

			END
			
			-- Insert New betlimit
			WHILE (1 = 1)
			BEGIN
				UPDATE TOP (1) #NewBetLimitInput
				SET isfinished = 1
					,@SporttypeID=Sporttype,@BettypeID=Bettype,@MinBet=MinBet,@MaxBet=MaxBet				
				WHERE isfinished = 0	
				IF @@ROWCOUNT = 0 BREAK
				SELECT @BetLimit='<ROOT><BetLimit SportType="'+ CAST(@SporttypeID AS VARCHAR(10))+'" BetType="'+CAST(@BettypeID AS VARCHAR(10))+'" MinBet="'+ CAST(@MinBet AS VARCHAR(30))+'" MaxBet="'+CAST(@MaxBet AS VARCHAR(30))+'"/></ROOT>'
				EXEC Acc_Dep_CustSetting_NewBetLimitFullLineUpd @SuperID=@SuperID,
					@BetLimit=@BetLimit,@AgentID=@AgentID,@IsAgentOnly=0,@ApplyExistedMem=1,@UserID=@CreatorID,@IP=@IP,@ErrCode=@ErrCode OUTPUT,@ErrMsg=@ErrMsg OUTPUT

				IF @ErrCode<>0
				BEGIN
					SELECT @ErrMsg = @ErrMsg + 'New Betlimit DCS'+@Agent
					DELETE FROM Dep_LicenseeProductSetting WHERE CustID=@SuperID
					SELECT @ListCustIDRollBack= CAST(@SuperID AS VARCHAR(20))+','+
												CAST(@MasterID AS VARCHAR(20))+','+
												CAST(@AgentID AS VARCHAR(20))+','+
												CAST(@AccMasterID AS VARCHAR(20))+','+
												CAST(@AccAgentID AS VARCHAR(20))+','
					SELECT @ListCustIDRollBack=@ListCustIDRollBack+				
						ISNULL(STUFF((Select ','+ CAST(CustID AS VARCHAR(20))
						from #tempDumCustID T1
						FOR XML PATH('')),1,1,''),'') 
					SELECT @ListCustIDRollBack=@ListCustIDRollBack+','	
					SELECT @ListCustIDRollBack=@ListCustIDRollBack+				
						ISNULL(STUFF((Select ','+ CAST(CustID AS VARCHAR(20))
						from #tempSubCustID T1
						FOR XML PATH('')),1,1,''),'')
					EXEC Dot_Dep_RollBackLicenseeDCS @ListCustID=@ListCustIDRollBack
					RETURN
				END	
				IF @IsCreateSub=1  
				BEGIN
					UPDATE #tempSubCustID SET isfinished=0
					WHILE (1 = 1)
					BEGIN		
						UPDATE TOP (1) #tempSubCustID
						SET isfinished = 1
							,@tmpSubCustID=CustID
						WHERE isfinished = 0

						IF @@ROWCOUNT = 0 OR @ErrCode<>0 BREAK 	
						EXEC Acc_Dep_CustSetting_NewBetLimitFullLineUpd @SuperID=@SuperID,
						@BetLimit=@BetLimit,@AgentID=@tmpSubCustID,@IsAgentOnly=1,@ApplyExistedMem=1,@UserID=@CreatorID,@IP=@IP,@ErrCode=@ErrCode OUTPUT,@ErrMsg=@ErrMsg OUTPUT
					END			

					IF @ErrCode<>0
					BEGIN
						SELECT @ErrMsg = @ErrMsg + 'New Betlimit DCS Sub licensees'
						DELETE FROM Dep_LicenseeProductSetting WHERE CustID=@SuperID
						SELECT @ListCustIDRollBack= CAST(@SuperID AS VARCHAR(20))+','+
												CAST(@MasterID AS VARCHAR(20))+','+
												CAST(@AgentID AS VARCHAR(20))+','+
												CAST(@AccMasterID AS VARCHAR(20))+','+
												CAST(@AccAgentID AS VARCHAR(20))+','
						SELECT @ListCustIDRollBack=@ListCustIDRollBack+				
							ISNULL(STUFF((Select ','+ CAST(CustID AS VARCHAR(20))
							from #tempDumCustID T1
							FOR XML PATH('')),1,1,''),'') 	
						SELECT @ListCustIDRollBack=@ListCustIDRollBack+','
						SELECT @ListCustIDRollBack=@ListCustIDRollBack+				
							ISNULL(STUFF((Select ','+ CAST(CustID AS VARCHAR(20))
							from #tempSubCustID T1
							FOR XML PATH('')),1,1,''),'')	
						EXEC Dot_Dep_RollBackLicenseeDCS @ListCustID=@ListCustIDRollBack
						RETURN
					END	
					
				END

			END
			
			-- Insert StakeLevel
			WHILE (1 = 1)
			BEGIN
				UPDATE TOP (1) #StakelevelInput
				SET isfinished = 1
					,@ProductID = ProductID			
					,@StakelevelXML = StakeLevelXML		
				WHERE isfinished = 0	
				IF @@ROWCOUNT = 0 BREAK
				
				EXEC [dbo].[Acc_Dep_CustSetting_StakeLevelUpd]
						@CustID	= @AgentID	
					,	@ProductID	= @ProductID
					,	@StakeLevel	= @StakelevelXML
					,	@IsAgentOnly = 0
					,	@UserID	= @CreatorID
					,   @IP=@IP,@ErrCode=@ErrCode OUTPUT,@ErrMsg=@ErrMsg OUTPUT	

				IF @ErrCode<>0
				BEGIN
					SELECT @ErrMsg = @ErrMsg + 'Stake Level DCS'+@Agent
					DELETE FROM Dep_LicenseeProductSetting WHERE CustID=@SuperID
					SELECT @ListCustIDRollBack= CAST(@SuperID AS VARCHAR(20))+','+
												CAST(@MasterID AS VARCHAR(20))+','+
												CAST(@AgentID AS VARCHAR(20))+','+
												CAST(@AccMasterID AS VARCHAR(20))+','+
												CAST(@AccAgentID AS VARCHAR(20))+','
					SELECT @ListCustIDRollBack=@ListCustIDRollBack+				
						ISNULL(STUFF((Select ','+ CAST(CustID AS VARCHAR(20))
						from #tempDumCustID T1
						FOR XML PATH('')),1,1,''),'') 
					SELECT @ListCustIDRollBack=@ListCustIDRollBack+','	
					SELECT @ListCustIDRollBack=@ListCustIDRollBack+				
						ISNULL(STUFF((Select ','+ CAST(CustID AS VARCHAR(20))
						from #tempSubCustID T1
						FOR XML PATH('')),1,1,''),'')
					EXEC Dot_Dep_RollBackLicenseeDCS @ListCustID=@ListCustIDRollBack
					RETURN
				END	
				IF @IsCreateSub=1  
				BEGIN
					UPDATE #tempSubCustID SET isfinished=0
						WHILE (1 = 1)
						BEGIN		
							UPDATE TOP (1) #tempSubCustID
							SET isfinished = 1
								,@tmpSubCustID=CustID
							WHERE isfinished = 0

							IF @@ROWCOUNT = 0 OR @ErrCode<>0 BREAK 	

							EXEC [dbo].[Acc_Dep_CustSetting_StakeLevelUpd]
								@CustID	= @tmpSubCustID	
							,	@ProductID	= @ProductID
							,	@StakeLevel	= @StakelevelXML
							,	@IsAgentOnly = 1
							,	@UserID	= @CreatorID
							,   @IP=@IP,@ErrCode=@ErrCode OUTPUT,@ErrMsg=@ErrMsg OUTPUT																
						END			

				
					IF @ErrCode<>0
					BEGIN
						SELECT @ErrMsg = @ErrMsg + 'Stake Level DCS Sub licensees'
						DELETE FROM Dep_LicenseeProductSetting WHERE CustID=@SuperID
						SELECT @ListCustIDRollBack= CAST(@SuperID AS VARCHAR(20))+','+
												CAST(@MasterID AS VARCHAR(20))+','+
												CAST(@AgentID AS VARCHAR(20))+','+
												CAST(@AccMasterID AS VARCHAR(20))+','+
												CAST(@AccAgentID AS VARCHAR(20))+','
						SELECT @ListCustIDRollBack=@ListCustIDRollBack+				
							ISNULL(STUFF((Select ','+ CAST(CustID AS VARCHAR(20))
							from #tempDumCustID T1
							FOR XML PATH('')),1,1,''),'') 	
						SELECT @ListCustIDRollBack=@ListCustIDRollBack+','
						SELECT @ListCustIDRollBack=@ListCustIDRollBack+				
							ISNULL(STUFF((Select ','+ CAST(CustID AS VARCHAR(20))
							from #tempSubCustID T1
							FOR XML PATH('')),1,1,''),'')	
						EXEC Dot_Dep_RollBackLicenseeDCS @ListCustID=@ListCustIDRollBack
						RETURN
					END	
					
				END

			END
			TRUNCATE TABLE #Betlimit
			TRUNCATE TABLE #BetlimitInput
			TRUNCATE TABLE #NewBetlimit
			TRUNCATE TABLE #NewBetlimitInput
			TRUNCATE TABLE #tempSubUserName
			TRUNCATE TABLE #tempSubCustID
			TRUNCATE TABLE #tempDumUserName
			TRUNCATE TABLE #tempDumCustID
			TRUNCATE TABLE #StakelevelInput
				-- Insert cashout
			SELECT @ErrMsg=''
			IF EXISTS(SELECT TOP 1 1 FROM #Product WHERE ProductID=1)
			BEGIN
				EXEC [Acc_3rdProductUpdSuperStatus] @ProductID=25, @CustID=@SuperID,@IsEnable=1,@ApplyToMember=1,@UserID=@CreatorID,@IP=@IP,@ErrMsg=@ErrMsg OUTPUT
				IF @ErrMsg<>''
				BEGIN
					SELECT @ErrCode=10000,@ErrMsg='CashOut.'+@ErrMsg
					RETURN
				END
			END		
	END
	
	DECLARE @ProductCode VARCHAR(100)=''
	IF EXISTS(SELECT TOP 1 1 FROM #Product WHERE ProductID=1)
	BEGIN
		SELECT @ProductCode=@ProductCode+'SB,SPR,CO,'
		SELECT @IsCashOut=1
	END	
	IF EXISTS(SELECT TOP 1 1 FROM #Product WHERE ProductID=5)
		SELECT @ProductCode=@ProductCode+'VS,'
	IF EXISTS(SELECT TOP 1 1 FROM #Product WHERE ProductID=27)
		SELECT @ProductCode=@ProductCode+'VS2,'
	IF EXISTS(SELECT TOP 1 1 FROM #Product WHERE ProductID=28)
		SELECT @ProductCode=@ProductCode+'LT,'
	IF EXISTS(SELECT TOP 1 1 FROM #Product WHERE ProductID=8)
		SELECT @ProductCode=@ProductCode+'KN,'
	IF EXISTS(SELECT TOP 1 1 FROM #Product WHERE ProductID=3)
		SELECT @ProductCode=@ProductCode+'NG,'
	IF EXISTS(SELECT TOP 1 1 FROM #Product WHERE ProductID=-1)
	BEGIN
		SELECT @ProductCode=@ProductCode+'BA,'
		SELECT @IsBA=1
	END
	--> Add Virtual Games, Table Games to LM
	IF EXISTS(SELECT TOP 1 1 FROM #Product WHERE ProductID=38)
		SELECT @ProductCode=@ProductCode+'VRG,'
	IF EXISTS(SELECT TOP 1 1 FROM #Product WHERE ProductID=40)
		SELECT @ProductCode=@ProductCode+'TG,'
	--Arcadia Gaming
	IF EXISTS(SELECT TOP 1 1 FROM #Product WHERE ProductID=34)
		SELECT @ProductCode=@ProductCode+'CC,'
	--SpadeGaming		
	IF EXISTS(SELECT TOP 1 1 FROM #Product WHERE ProductID=36)
		SELECT @ProductCode=@ProductCode+'SG,'
	--SA Gaming	
	IF EXISTS(SELECT TOP 1 1 FROM #Product WHERE ProductID=39)
		SELECT @ProductCode=@ProductCode+'SAG,'
	--	PG Soft
	IF EXISTS(SELECT TOP 1 1 FROM #Product WHERE ProductID=55)
		SELECT @ProductCode=@ProductCode+'PGS,'
	-- 	Sports Lottery
	IF EXISTS(SELECT TOP 1 1 FROM #Product WHERE ProductID=63)
		SELECT @ProductCode=@ProductCode+'SLT,'
	-- Vgaming	
	IF EXISTS(SELECT TOP 1 1 FROM #Product WHERE ProductID=66)
		SELECT @ProductCode=@ProductCode+'VGA,'	
	-- CG	
	IF EXISTS(SELECT TOP 1 1 FROM #Product WHERE ProductID=62)
		SELECT @ProductCode=@ProductCode+'CG,'
	-- AdvantPlay	
	IF EXISTS(SELECT TOP 1 1 FROM #Product WHERE ProductID=67)
		SELECT @ProductCode=@ProductCode+'AP,'
	-- AdvantPlay Mini	
	IF EXISTS(SELECT TOP 1 1 FROM #Product WHERE ProductID=68)
		SELECT @ProductCode=@ProductCode+'APM,'		
	-- Virtual Sports 3	
	IF EXISTS(SELECT TOP 1 1 FROM #Product WHERE ProductID=49)
		SELECT @ProductCode=@ProductCode+'VS3,'			
			
	SELECT @ProductCode=SUBSTRING(@ProductCode, 1, LEN(@ProductCode) - 1)
	-- Insert LM Licensee
	EXEC bodb_Licensee.dbo.Dot_Dep_LM_CreateNewLicensee
		@LicenseeName = @sitename, -- from input
		@LicenseeType = @LicenseeType, -- from input (Boping, OneWorks, Zelianta)
		@ProductCode = @ProductCode, -- from imput, ex: SB,VS,VS2
		@SystemisActive = 'LRF,OA,Accounting', -- harcode		
		@ErrCode = @ErrCode OUTPUT,
		@ErrMsg = @ErrMsg OUTPUT
	IF @ErrCode<>0
	BEGIN	
		SELECT @ErrMsg='LAP.'+@ErrMsg			
		RETURN
	END
	-- Insert BA
	IF EXISTS(SELECT TOP 1 1 FROM #Product WHERE ProductID=-1)
	BEGIN
		SELECT @LicenseeID=LicenseeID FROM bodb_Licensee.dbo.Licensees WITH(NOLOCK) WHERE LicenseeName=@sitename
		CREATE TABLE #tmpCurrency(Currency INT,CurrencyName VARCHAR(50))
		DECLARE @BA VARCHAR(250)		
		
		EXEC bodb_Licensee.dbo.Acc_BA_LicConfigUpd @EnableBA=1,@OtherComm=0.0025,@ErrCode=@ErrCode OUTPUT,@IP=@IP,
		@1x2Comm=0.0025,@groupc=0.0025,@groupb=0.0025,@groupa=0.0025,@UserID=@CreatorID,@ErrMsg=@ErrMsg OUTPUT,@groupd=0.0025,@LicenseeID=@LicenseeID
		IF @ErrCode<>0
		BEGIN	
			SELECT @ErrMsg='Enable BA Licensee Config.'+@ErrMsg			
			RETURN
		END
		INSERT INTO #tmpCurrency(Currency,CurrencyName)
		EXEC bodb_Licensee.dbo.Acc_BA_GroupCurrencySel @LicenseeID=@LicenseeID

		SELECT 
		  @BA =  STUFF
		  (
			(
			  SELECT DISTINCT ',' + 'd' + CAST(p.Currency AS VARCHAR(30))
				FROM #tmpCurrency AS p       
				FOR XML PATH('')
			), 1, 1, N''
		  )
		FROM #tmpCurrency AS u

		EXEC bodb_Licensee.dbo.Acc_BA_GroupCurrencyUpd @IP=@IP,@ModifyBy=@CreatorID,@str=@BA,@ErrCode=@ErrCode OUTPUT,@ErrMsg=@ErrMsg OUTPUT,@LicenseeID=@LicenseeID
		IF @ErrCode<>0
		BEGIN	
			SELECT @ErrMsg='Enable BA Group Currency.'+@ErrMsg			
			RETURN
		END
	END

	IF @ErrCode=0
		SELECT @ErrMsg='Create Licensee successfully'

	SELECT @PT_VirtualSports1=@PT_VirtualSports1/100
	SELECT @PT_VirtualSports2=@PT_VirtualSports2/100
	SELECT @PT_Loterry=@PT_Loterry/100
	SELECT @PT_VirtualGames=@PT_VirtualGames/100
	SELECT @PT_TableGame=@PT_TableGame/100
	
	SELECT @PT_ArcadiaGaming=@PT_ArcadiaGaming/100
	SELECT @PT_Vgaming=@PT_Vgaming/100
	SELECT @PT_PGSoft=@PT_PGSoft/100
	SELECT @PT_SAGaming=@PT_SAGaming/100
	SELECT @PT_SpadeGaming=@PT_SpadeGaming/100
	SELECT @PT_AP=@PT_AP/100
	SELECT @PT_ApMini=@PT_ApMini/100
	SELECT @PT_CG=@PT_CG/100
	SELECT @PT_VS3=@PT_VS3/100

	DECLARE @XML XML
	CREATE TABLE #PTLog(ProductID INT,PT FLOAT)					
	
	SET @endRun = GETDATE()
	SET @duration  = DATEDIFF (millisecond,@startRun,@endRun)
	DECLARE @LogSPData VARCHAR(MAX)
	WHILE (1 = 1)
	BEGIN		
		UPDATE TOP (1) #tempSuper
		SET isfinished = 1
			,@SuperID=CustID
		WHERE isfinished = 0
		
		IF @@ROWCOUNT = 0 BREAK
		SELECT @Currency=Currency FROM Customer WITH(NOLOCK) WHERE custid=@SuperID
		--Write general info	
		TRUNCATE TABLE #PTLog
		INSERT INTO #PTLog(ProductID,PT)
		SELECT  1, @PT_Sportsbook												
		UNION 
		SELECT  5, @PT_VirtualSports1											
		UNION 
		SELECT  27, @PT_VirtualSports2											
		UNION 
		SELECT  3, @PT_NumberGame												
		UNION 
		SELECT  8, @PT_Keno														
		UNION 
		SELECT  28, @PT_Loterry	
		UNION 
		SELECT  38, @PT_VirtualGames	
		UNION 
		SELECT  40, @PT_TableGame
		UNION 
		SELECT  34, @PT_ArcadiaGaming
		UNION 
		SELECT  36, @PT_SpadeGaming
		UNION 
		SELECT  39, @PT_SAGaming
		UNION 
		SELECT  55, @PT_PGSoft
		UNION 
		SELECT  66, @PT_Vgaming
		UNION 
		SELECT  62, @PT_CG
		UNION 
		SELECT  67, @PT_AP
		UNION 
		SELECT  68, @PT_ApMini
		UNION 
		SELECT  49, @PT_VS3
		
		DELETE FROM #PTLog WHERE ProductID NOT IN(SELECT ProductID FROM #Product WHERE Currency=@Currency)		
			
		SET @xml = (
					SELECT  (
							SELECT  @sitename														AS '@sitename'
									, @LicenseeType													AS '@LicenseeType'
									, @IP															AS '@IP'								
									, @creator														AS '@creator'			
									, @SuperID														AS '@SuperID'	
									, @IsBA															AS '@BA'	
									, @IsCashOut													AS '@CashOut'	
									, @IsCreateSub													AS '@Subsidiary'	
									, @ErrCode														AS '@ErrCode'	
									, @ErrMsg														AS '@ErrMsg'
									, @IsChinaView													AS '@IsChinaView'	
							FOR XML PATH('GeneralInfo'), 
							TYPE
							),
							(
								SELECT	ProductID 														AS '@ID'
										,  CAST(PT AS VARCHAR(50))										AS '@PT'										
								FROM #PTLog								
							FOR XML PATH ('Product'),ROOT ('PT'),
							TYPE
							),
							(
								SELECT CASE WHEN  bs1.Sporttype = 1 AND bs1.bettype = 9 THEN 1999
											WHEN  bs1.Sporttype = 99 AND bs1.bettype = 9 THEN 999
										ELSE bs1.Sporttype END															AS [@ID]
									,  dbo.f_CS_FomatNumber (CAST(bs1.MinBet			AS VARCHAR(50)))				AS [@minb]
									,  dbo.f_CS_FomatNumber (CAST(bs1.MaxBet			AS VARCHAR(50)))				AS [@maxb]
									,  dbo.f_CS_FomatNumber (CAST(bs1.MaxPerBall 		AS VARCHAR(50)))				AS [@mpb]
									,  dbo.f_CS_FomatNumber (CAST(bs1.MaxPerMatch 		AS VARCHAR(50)))				AS [@mpm]		
								FROM #Product bs1
								WHERE bs1.Currency=@Currency	
									AND bs1.ProductID = 1
								ORDER BY ProductID, Sporttype, Bettype	
								FOR XML PATH('Sport'), ROOT ('BS1'),
								TYPE
							),
							(
								SELECT  ProductID																			AS [@ID]
										,  dbo.f_CS_FomatNumber (CAST(bs.MinBet			AS VARCHAR(50)))					AS [@minb]
										,  dbo.f_CS_FomatNumber (CAST(bs.MaxBet			AS VARCHAR(50)))					AS [@maxb]
										,  dbo.f_CS_FomatNumber (CAST(bs.MaxPerBall 		AS VARCHAR(50)))				AS [@mpb]
										,  dbo.f_CS_FomatNumber (CAST(bs.MaxPerMatch 		AS VARCHAR(50)))				AS [@mpm]				
								FROM #Product bs 
								WHERE Currency=@Currency AND bs.ProductID NOT IN(-1,25,1,38,34,66,36,55,39,62,67,68,49)		
								ORDER BY ProductID, Sporttype, Bettype				
								FOR XML PATH('Product'), ROOT ('BS2'),
								TYPE
							),
							(
								SELECT  ProductID																			AS [@ID]
										,  dbo.f_CS_FomatNumber (CAST(bs3.MinBet			AS VARCHAR(50)))				AS [@minb]
										,  dbo.f_CS_FomatNumber (CAST(bs3.MaxBet			AS VARCHAR(50)))				AS [@maxb]		
								FROM #Product bs3 
								WHERE Currency=@Currency AND bs3.ProductID IN(49)		
								ORDER BY ProductID, Sporttype, Bettype				
								FOR XML PATH('Product'), ROOT ('BS3'),
								TYPE
							),
							(
								SELECT	ds.ProductID AS [@ID],
									(
										SELECT st1.GameTypeID																	AS [@ID]
											,  dbo.f_CS_FomatNumber (CAST(st1.MinStake		AS VARCHAR(50)))					AS [@MinStake]
											,  dbo.f_CS_FomatNumber (CAST(st1.MaxStake		AS VARCHAR(50)))					AS [@MaxStake]
										FROM @tmpStakeLevel st1 
											INNER JOIN Dep_ProductSettingDetail dt1 WITH(NOLOCK) ON st1.GameTypeID = dt1.BetType
											INNER JOIN Dep_ProductSetting ds1 WITH(NOLOCK) ON dt1.ProductSettingID = ds1.ProductSettingID
										WHERE st1.Currency = @Currency AND ds1.SettingType = 7
											AND ds1.ProductID = ds.ProductID 
										ORDER BY st1.GameTypeID
										FOR XML PATH('Bettype'),TYPE
									) 
								FROM @tmpStakeLevel st 
									INNER JOIN Dep_ProductSettingDetail dt WITH(NOLOCK) ON st.GameTypeID = dt.BetType
									INNER JOIN Dep_ProductSetting ds WITH(NOLOCK) ON dt.ProductSettingID = ds.ProductSettingID
								WHERE st.Currency = @Currency AND ds.SettingType = 7
								GROUP BY ds.ProductID
								ORDER BY ds.ProductID
								FOR XML PATH('Product'), ROOT ('SL'),
								TYPE
							),
							(
								SELECT p.ProductID																		AS [@ID]
									,  dbo.f_CS_FomatNumber (CAST(p.StakeLevelID		AS VARCHAR(50)))				AS [@StakeLevelID]
								FROM #Product P 
									INNER JOIN Dep_ProductSetting ds1 WITH(NOLOCK) ON ds1.ProductID = P.ProductID
									INNER JOIN Dep_ProductSettingDetail dt1 WITH(NOLOCK) ON dt1.ProductSettingID = ds1.ProductSettingID
								WHERE p.Currency = @Currency AND ds1.SettingType = 8
								ORDER BY p.ProductID
								FOR XML PATH('Product'), ROOT ('StakeLevelGroup'),
								TYPE
							)							
					FOR XML PATH('R'), 
					TYPE
					)
		SET @logSpData = REPLACE(CONVERT(VARCHAR(MAX), @xml), '" />', '"/"')		
		
		EXEC DBLOG.bodb_CustomerLog.dbo.WriteLog_UserLog_RunSP 
			@UserID = @CreatorID,
			@CustID = @SuperID,
			@ActionID = 2214,
			@TrackingValue = @LogSPData,
			@duration = @duration
	END	
END
GO