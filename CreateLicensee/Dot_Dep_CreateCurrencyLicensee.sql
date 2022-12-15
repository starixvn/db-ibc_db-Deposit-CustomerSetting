/*<info serverAlias="DBCUST-CUSTDB" executers="Dot_Member" viewers="" isFunction="0"></info>*/
ALTER PROCEDURE [dbo].[Dot_Dep_CreateCurrencyLicensee] 
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
	,   @PT_WM				SMALLMONEY=0
	,   @PT_AP				SMALLMONEY=0
	,   @PT_ApMini			SMALLMONEY=0
	,   @PT_CG				SMALLMONEY=0
	,   @PT_VS3				SMALLMONEY=0
	,	@PT_SabaCasino  	SMALLMONEY=0
	,	@PT_Allbet 			SMALLMONEY=0
	,	@PT_MacauGames  	SMALLMONEY=0
	,	@PT_PP  			SMALLMONEY=0
	,	@PT_AE  			SMALLMONEY=0
	,	@PT_Habanero		SMALLMONEY=0
	,	@StakeLevel			VARCHAR(MAX)	= '<ROOT></ROOT>'
	,	@InsBalCustList		varchar(MAX) = '' OUTPUT
	,	@InsBalExceptCustList varchar(MAX) = '' OUTPUT
AS  
/*  
 Created: 20201118@Winfred  
 Task: Create currency for Licensee
 DB: DBCUST/CustDB  
 Original: Dot_Dep_CreateLicensee 
 Revisions:  	
	- 20201118@Winfred: Create currency for existing licensee [RedmineID:#143761]
	- 20210623@Winfred: Integrate 7 products [RedmineID:#156877]
	- 20210921@Winfred: Integrate 2 products [RedmineID:#160130]
	- 20211101@Winfred: Merge Sports Lottery under Sportsbook [redmine:#164129]
	- 20220117@Winfred: Change message error for stake level group [redmine:#167097]
	- 20220309@Winfred: Sitebuilder - Offer Cash Out for licensee by default [redmine:#169724]
	- 20220307@Winfred: Integrate 3 products Creative Gaming, Advantplay, Advantplay mini products [redmine:#169473]
	- 20220504@Winfred: Enhance PT for Keno no rounded [redmine:#172324]
	- 20220616@Winfred: Integrate new games of Virtual Games product [redmine:#172671]
	- 20220609@Winfred: Integrate Virtual Sports 3 [redmine:#173382]
	- 20220725@Winfred: Enhance Log Virtual Sports 3 [redmine:#173382]
	- 20220301@Eden: Deposit - Sportsbook - Revise customer settings [Redmine: #167898] 
	- 20220722@Eden: LAP - Scale Out DBTrans  [redmine: #158293/#175297]
	- 20220720@Winfred: ONEbook Sitebuilder - Integrate some 3rd products [redmine:#175422]
	- 20221027@Winfred: ONEbook Sitebuilder - Fix Issue extra space when creating stakelevel [redmine:#179663]
	- 20221107@Danny: Discount By Gross Win - Automatically mark on new launch currency [redmine:#179367]

 Param's Explanation: 
	- @LicenseeType = (Boping, OneWorks, Zelianta)
	- @Product:<ROOT>
					<Product 
							ProductID="1" 
							Currency="20" 
							MinBet="1" 
							MaxBet="30000" 
							MaxPerMatch="1000000"
							MaxPerBall="30000" 
					/>
				</ROOT>
	- @StakeLevel  =  <ROOT>
								<StakeLevel Currency="4" GameTypeID="4601"  MinStake="20" MaxStake="100"/>	
								<StakeLevel Currency="4" GameTypeID="4601"  MinStake="20" MaxStake="200" />
								<StakeLevel Currency="4" GameTypeID="4601"  MinStake="20" MaxStake="300" />
						</ROOT>',

	- @InsBalCustList  --> cutsid list will call 2 sp insert balance on DBTRANS SiteDB: (ex: 'CustID1,CustID2')
                    EXEC bodb02.dbo.Dot_BalanceInsCredit @CustID = @CustID 
                    EXEC bodb02.dbo.Dot_BalanceInsDebit @CustID = @CustID
    - @InsBalExceptCustList -->  cutsid and username  list will call sp insert exception balance on SiteDB : (ex: 'CustID1;username1,CustID2;username2,...' )
                    EXEC bodb02.dbo.Task_Cust_CheckBalance_Exception_Ins @custid = @custid, @username = @username

Sample exec:
DECLARE @ErrorCode INT, @Errmsg NVARCHAR(MAX), @InsBalCustList varchar(MAX),  @InsBalExceptCustList varchar(MAX)
EXEC Dot_Dep_CreateCurrencyLicensee @sitename='wtest45'
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
	,	@PT_WM  			=0.82
	,   @PT_AP				=0.8
	,   @PT_ApMini			=0.8
	,   @PT_CG				=0.8
	,	@PT_VS3  			=0.9
	,	@PT_SabaCasino  	=0.9
	,	@PT_Allbet 			=0.9
	,	@PT_MacauGames  	=0.9
	,	@PT_PP  			=0.9
	,	@PT_AE  			=0.9
	,	@PT_Habanero		=0.9
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
																	ProductID="69"
																	Currency="4"	
																	MinBet="1" 
																	MaxBet="300000"	
																	MaxPerMatch="600000"	
																	MaxPerBall="0" 
																/>
																<Product 	
																	ProductID="62"	
																	Currency="4"	
																	MinBet="1" 
																	MaxBet="300000"	
																	MaxPerMatch="600000"	
																	MaxPerBall="0" 
																/>
																<Product 
																	ProductID="51"
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
																<Product 
																	ProductID="6"
																	Currency="4"	
																	MinBet="0" 
																	MaxBet="0"	
																	MaxPerMatch="0"
																	MaxPerBall="0" 
																/>
																<Product 
																	ProductID="22"
																	Currency="4"	
																	MinBet="0" 
																	MaxBet="0"	
																	MaxPerMatch="0"
																	MaxPerBall="0" 
																/>
																<Product 
																	ProductID="32"
																	Currency="4"	
																	MinBet="0" 
																	MaxBet="0"	
																	MaxPerMatch="0"
																	MaxPerBall="0" 
																/>
																<Product 
																	ProductID="45"
																	Currency="4"	
																	MinBet="0" 
																	MaxBet="0"	
																	MaxPerMatch="0"
																	MaxPerBall="0" 
																/>
																<Product 
																	ProductID="61"
																	Currency="4"	
																	MinBet="0" 
																	MaxBet="0"	
																	MaxPerMatch="0"
																	MaxPerBall="0" 
																/>
																<Product 
																	ProductID="21"
																	Currency="4"	
																	MinBet="0" 
																	MaxBet="0"	
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

							<StakeLevel Currency="4" GameTypeID="3401"  MinStake="10" MaxStake="100"/>	
							<StakeLevel Currency="4" GameTypeID="3401"  MinStake="20" MaxStake="500" />
							<StakeLevel Currency="4" GameTypeID="3401"  MinStake="30" MaxStake="1000" />
							<StakeLevel Currency="4" GameTypeID="2401"  MinStake="10" MaxStake="300"/>	
							<StakeLevel Currency="4" GameTypeID="2401"  MinStake="20" MaxStake="400" />
							<StakeLevel Currency="4" GameTypeID="2401"  MinStake="30" MaxStake="900" />
							<StakeLevel Currency="4" GameTypeID="2402"  MinStake="10" MaxStake="1000"/>	
							<StakeLevel Currency="4" GameTypeID="2402"  MinStake="20" MaxStake="5000" />
							<StakeLevel Currency="4" GameTypeID="2402"  MinStake="30" MaxStake="9000" />

							<StakeLevel Currency="4" GameTypeID="3101"  MinStake="10" MaxStake="1000"/>	
							<StakeLevel Currency="4" GameTypeID="3101"  MinStake="20" MaxStake="5000" />
							<StakeLevel Currency="4" GameTypeID="3101"  MinStake="30" MaxStake="9000" />
					</ROOT>',
@Creator=1,@IP='192.168.1.1',@IsCreateSub=1,@LicenseeType='Boping',@ErrCode=@ErrorCode OUTPUT,@Errmsg=@Errmsg OUTPUT
,@InsBalCustList=@InsBalCustList OUTPUT,@InsBalExceptCustList=@InsBalExceptCustList OUTPUT  , @SiteDBGroupID = 0
SELECT @ErrorCode,@Errmsg ,@InsBalCustList,@InsBalExceptCustList 

*/  
BEGIN  
	SET NOCOUNT ON
	DECLARE @InsBalCustList_s		varchar(MAX) = '',
			@InsBalExceptCustList_s varchar(MAX) = ''

	SET @InsBalCustList = ''
	SET @InsBalExceptCustList = ''

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
	SELECT @PT_WM=@PT_WM*100
	SELECT @PT_AP=@PT_AP*100
	SELECT @PT_ApMini=@PT_ApMini*100
	SELECT @PT_CG=@PT_CG*100
	SELECT @PT_VS3=@PT_VS3*100
	SELECT @PT_SabaCasino=@PT_SabaCasino*100
	SELECT @PT_Allbet=@PT_Allbet*100
	SELECT @PT_MacauGames=@PT_MacauGames*100
	SELECT @PT_PP=@PT_PP*100
	SELECT @PT_AE=@PT_AE*100
	SELECT @PT_Habanero=@PT_Habanero*100
	
	SELECT @PT_Sportsbook = @PT_Sportsbook*100
	SELECT @PT_NumberGame = @PT_NumberGame*100
	SELECT @PT_Keno = @PT_Keno*100
	DECLARE @CreatorID INT,  @IsCashOut BIT,@IsBA BIT,@IsStakeLevelGroup BIT = 0 ,@PT_TEMP SMALLMONEY=0,@ProductName VARCHAR(100)
	SELECT @CreatorID=10278938	
	DECLARE @iDoc INT
	
	DECLARE @PT_XML	VARCHAR(MAX), @CurrencyError NVARCHAR(MAX) = ''
	
	DECLARE @startRun DATETIME , @endRun DATETIME , @duration INT, @ListCustIDRollBack VARCHAR(MAX)
	SET @startRun = GETDATE()
	CREATE TABLE #tempSubUserName (Username VARCHAR(30),isfinished BIT DEFAULT(0))
	CREATE TABLE #tempSubCustID (CustID INT,isfinished BIT DEFAULT(0))
	CREATE TABLE #tempDumUserName (Username VARCHAR(30),isfinished BIT DEFAULT(0))
	CREATE TABLE #tempDumCustID (CustID INT,isfinished BIT DEFAULT(0))
	CREATE TABLE #Currency (Currency INT,isfinished BIT DEFAULT(0))
	DECLARE @tmpSubUserName VARCHAR(30)
	DECLARE @tmpSubCustID INT					
	DECLARE @tmpDumUserName VARCHAR(30)
	DECLARE @tmpDumCustID INT	
	CREATE TABLE #tempSuper (CustID INT,isfinished BIT DEFAULT(0))		

	DECLARE  @Pass VARCHAR(100),@SuperID INT,@MasterID INT,@AgentID INT,@AccMasterID INT,@AccAgentID INT,@DummyAgentID INT			
			,@SporttypeID INT,@BettypeID INT,@bitmapOrder INT,@BetLimit VARCHAR(MAX),@LicenseeID INT	
			,@ProductID INT , @StakelevelXML VARCHAR(MAX)
			,@StakeLevel_ByCurrency VARCHAR(MAX)
	
	SELECT @Pass='8058095B7DDB08A608811097E5DB8D'		

	DECLARE @Super VARCHAR(30),@Master VARCHAR(30),@Agent VARCHAR(30),@AccMaster VARCHAR(30),@AccAgent VARCHAR(30),@Transf VARCHAR(30),@Charge VARCHAR(30),@Bonus01 VARCHAR(30)
			,@Bonus02 VARCHAR(30),@Dummy3rd VARCHAR(30),@ClearBal VARCHAR(30)
			,@Withdraw VARCHAR(30),@Currency INT				
			,@MinBet MONEY,@MaxBet MONEY,@MaxPerMatch MONEY
			,@MaxPerNumber MONEY,@MaxPayoutPerMatch MONEY
			,@tmpProductID TINYINT	

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
	BEGIN TRY
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
	END TRY
	BEGIN CATCH
		SELECT  @ErrMsg = N'Invalid XML format'	, @ErrCode = 3 ;		
		RETURN
	END CATCH

	--ADD ',' to stake label
	UPDATE a 
	SET  a.MinLabel  =  CASE WHEN CAST(MinStake AS BIGINT) < MinStake 
						THEN REPLACE(RTRIM(REPLACE(MinStake, '0', ' ')), ' ', '0') 
						ELSE REPLACE(REPLACE(RTRIM(REPLACE(MinStake, '0', ' ')), ' ', '0'),'.','') END 
		,a.MaxLabel  =  CASE WHEN CAST(MaxStake AS BIGINT) < MaxStake 
						THEN REPLACE(RTRIM(REPLACE(MaxStake, '0', ' ')), ' ', '0') 
						ELSE REPLACE(REPLACE(RTRIM(REPLACE(MaxStake, '0', ' ')), ' ', '0'),'.','') END 								
	FROM  @tmpStakeLevel a
		
	UPDATE t
	SET MaxLabel = REVERSE(STUFF (REVERSE(t.MaxLabel),CHARINDEX('.',REVERSE(t.MaxLabel),0) + 4,0,','))
	FROM @tmpStakeLevel t
	WHERE MaxStake > 999
		
	UPDATE t
	SET MaxLabel = REVERSE(STUFF (REVERSE(t.MaxLabel),CHARINDEX('.',REVERSE(t.MaxLabel),0) + 8,0,','))
	FROM @tmpStakeLevel t
	WHERE MaxStake > 999999

	UPDATE t
	SET MaxLabel = REVERSE(STUFF (REVERSE(t.MaxLabel),CHARINDEX('.',REVERSE(t.MaxLabel),0) + 12,0,','))
	FROM @tmpStakeLevel t
	WHERE MaxStake > 999999999
		
	UPDATE t
	SET MinLabel = REVERSE(STUFF (REVERSE(t.MinLabel),CHARINDEX('.',REVERSE(t.MinLabel),0) + 4,0,','))
	FROM @tmpStakeLevel t
	WHERE MinStake > 999
		
	UPDATE t
	SET MinLabel = REVERSE(STUFF (REVERSE(t.MinLabel),CHARINDEX('.',REVERSE(t.MinLabel),0) + 8,0,','))
	FROM @tmpStakeLevel t
	WHERE MinStake > 999999

	UPDATE t
	SET MinLabel = REVERSE(STUFF (REVERSE(t.MinLabel),CHARINDEX('.',REVERSE(t.MinLabel),0) + 12,0,','))
	FROM @tmpStakeLevel t
	WHERE MinStake > 999999999

	---END ADD ',' to stake label

	CREATE TABLE #SportsStatus(ProductID INT,Sporttype INT,Bettype INT,bitmapOrder INT,IsDisable BIT,IsDisableDownLine BIT,HasDownline BIT,IsDisableUpline BIT)
	CREATE TABLE #BetLimit(Sporttype INT,Bettype INT,MinBet MONEY,MaxBet MONEY,MaxPerMatch MONEY,MaxPerNumber MONEY,MaxPayoutPerMatch MONEY)
	CREATE TABLE #BetLimitInput(ProductID INT, Sporttype INT,Bettype INT,MinBet MONEY,MaxBet MONEY,MaxPerMatch MONEY,MaxPerNumber MONEY,MaxPayoutPerMatch MONEY,isfinished BIT DEFAULT(0)
								,BetLimitType TINYINT DEFAULT(1) --1 : Bet Setting tables, 2: Bet setting Game tables
								,PRIMARY KEY(Sporttype,Bettype))
	CREATE TABLE #NewBetLimit(Sporttype INT,Bettype INT,MinBet MONEY,MaxBet MONEY)
	CREATE TABLE #NewBetLimitInput(Sporttype INT,Bettype INT,MinBet MONEY,MaxBet MONEY,isfinished BIT DEFAULT(0),PRIMARY KEY(Sporttype,Bettype))
	CREATE TABLE #ProductInput(ProductID INT,Currency INT,MinBet MONEY,MaxBet MONEY,MaxPerMatch MONEY,MaxPerNumber MONEY,MaxPayoutPerMatch MONEY,Sporttype INT,Bettype INT)
	CREATE TABLE #Product(ProductID INT,Currency INT,MinBet MONEY,MaxBet MONEY,MaxPerMatch MONEY,MaxPerNumber MONEY,MaxPayoutPerMatch MONEY,Sporttype INT,Bettype INT , StakeLevelID	INT)
	CREATE TABLE #Username(Super VARCHAR(30),Master VARCHAR(30),Agent VARCHAR(30),AccMaster VARCHAR(30),AccAgent VARCHAR(30),Transf VARCHAR(30),Charge VARCHAR(30),
							Bonus01 VARCHAR(30),Bonus02 VARCHAR(30),Withdraw VARCHAR(30),Dummy3rd VARCHAR(30),Currency INT,ClearBal VARCHAR(30),				
							isfinished BIT DEFAULT(0) )
	CREATE TABLE #StakelevelInput(ProductID INT, StakeLevelXML VARCHAR(MAX), isfinished BIT DEFAULT(0), PRIMARY KEY(ProductID))
	CREATE TABLE #tempProduct (ProductID INT, PT SMALLMONEY , ProductName VARCHAR(100),isfinished BIT DEFAULT(0))
	CREATE TABLE #CheckBetlimit (ProductID INT, ProductName VARCHAR(100),Currency INT, CurrencyName NVARCHAR(50),MinBet MONEY,MaxBet MONEY, MinBetGlobal MONEY,MaxBetGlobal MONEY, isfinished BIT DEFAULT(0))

	BEGIN TRY
		EXEC sp_xml_preparedocument @iDoc OUTPUT
			, @Product

		INSERT INTO #ProductInput(ProductID ,Currency ,MinBet ,MaxBet ,MaxPerMatch ,MaxPerNumber,MaxPayoutPerMatch,Sporttype,Bettype)
		SELECT ProductID ,Currency ,MinBet ,MaxBet ,MaxPerMatch ,MaxPerBall
			,MaxPayoutPerMatch = CASE WHEN ProductID = 1 THEN ISNULL(MaxPayoutPerMatch, MaxPerMatch * 8) ELSE 0 END -- if SB do not input MaxPayoutPerMatch yet, set = MaxPerMatch * 8 by default
			,Sporttype,Bettype
		FROM OPENXML(@iDoc, '/ROOT/Product', 1) WITH (
				  ProductID		INT
				, Currency		INT
				, MinBet		MONEY
				, MaxBet		MONEY
				, MaxPerMatch	MONEY
				, MaxPerBall	MONEY
				, MaxPayoutPerMatch MONEY
				, Sporttype		INT
				, Bettype		INT
				)

		EXEC sp_xml_removedocument @iDoc
	END TRY
	BEGIN CATCH
		SELECT  @ErrMsg = N'Invalid XML format'	, @ErrCode = 3 ;	
		RETURN
	END CATCH
	
	--Insert Saba Soccer + Saba Basket ball bet setting folllow Soccer/Basketball do not input
	INSERT INTO #ProductInput(ProductID ,Currency ,MinBet ,MaxBet ,MaxPerMatch ,MaxPerNumber,MaxPayoutPerMatch,Sporttype,Bettype)
	SELECT i.ProductID ,i.Currency ,i.MinBet ,i.MaxBet ,i.MaxPerMatch ,i.MaxPerNumber,i.MaxPayoutPerMatch,i.Sporttype + 9900,i.Bettype
	FROM #ProductInput i
		LEFT JOIN  #ProductInput saba ON i.Sporttype + 9900 =  saba.Sporttype AND  i.ProductID = saba.ProductID
	WHERE i.Sporttype  IN (1,2) AND i.bettype = 1
		AND i.ProductID = 1
		AND saba.Sporttype IS NULL

	INSERT INTO #Product(ProductID ,Currency ,MinBet ,MaxBet ,MaxPerMatch ,MaxPerNumber,MaxPayoutPerMatch,Sporttype,Bettype)
	SELECT ProductID ,Currency ,MinBet ,MaxBet ,MaxPerMatch ,MaxPerNumber,MaxPayoutPerMatch ,Sporttype ,Bettype
	FROM #ProductInput
	
	INSERT #Currency (Currency,isfinished)
	SELECT DISTINCT Currency, 0 AS isfinished
	FROM #Product

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
		SELECT @ErrMsg = 'This product does not support the selected currencies', @ErrCode = 10007
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
						WHERE MaxPerNumber < 0 
							OR (MaxBet>0 AND MaxPerNumber > 0 AND MaxBet > MaxPerNumber)
							OR (MaxPerMatch>0 AND MaxPerNumber > 0 AND MaxPerNumber > MaxPerMatch)
			)
	BEGIN
		SELECT @ErrMsg = 'Break rule bet limit', @ErrCode = 10005
		RETURN
	END
	IF EXISTS(SELECT TOP 1 1 
						FROM #Product 
						WHERE MaxPayoutPerMatch < 0 
							OR (MaxPerMatch>0 AND MaxPayoutPerMatch > 0 AND MaxPerMatch > MaxPayoutPerMatch)
			)
	BEGIN
		SELECT @ErrMsg = 'Break rule bet limit', @ErrCode = 10008
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

			SELECT @ErrMsg = @ErrMsg  + ' Violate ' + @ProductName + ' global bet setting, please follow global bet setting: ' +  STUFF((SELECT DISTINCT ', ' + CAST(CurrencyName AS NVARCHAR(50)) + ' ('+ 
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

	IF NOT EXISTS (SELECT TOP 1 1 FROM dbo.Site WITH (NOLOCK) WHERE site = @Sitename) OR NOT EXISTS (SELECT TOP 1 1 FROM bodb_Licensee.dbo.Licensees WITH (NOLOCK) WHERE LicenseeName = @Sitename)
	BEGIN
		SELECT @ErrMsg = 'Site Name does not exist.', @ErrCode = 10003
		RETURN
	END  
	--> Get SiteID
	DECLARE @SiteID INT 
	SELECT @SiteID = siteid FROM dbo.Site WITH (NOLOCK) WHERE site = @Sitename

	INSERT INTO #Username(Super,Master,Agent,AccMaster,AccAgent,Transf,Charge ,Bonus01,Bonus02,Withdraw,Dummy3rd,Currency,ClearBal)
	SELECT DISTINCT @sitename+'Super'+e.currency,@sitename+e.currency,@sitename+e.currency+'01'
			,@sitename+'ACC'+e.currency,@sitename+'ACC'+e.currency+'01',@sitename+'Transfer'+e.currency,
			@sitename+'Charges'+e.currency,@sitename+'Bonus'+e.currency,@sitename+'Bonus02'+e.currency,
			@sitename+'Withdrawal'+e.currency,@sitename+'Dummy3rd'+e.currency,t.Currency,@sitename+e.currency+'01ClearBal'
	FROM #Product t
		INNER JOIN exchange e WITH(NOLOCK) ON t.Currency=e.exchangeid
	WHERE t.ProductID=1

	WHILE (1 = 1)
	BEGIN
		
		UPDATE TOP (1) #Username
		SET isfinished = 1
			,@Super=Super,@Master=Master,@Agent=Agent,@AccMaster=AccMaster,@AccAgent=AccAgent,@Transf=Transf,@Charge=Charge ,@Bonus01=Bonus01,@Withdraw=Withdraw 
			,@Bonus02=Bonus02,@Dummy3rd=Dummy3rd,@ClearBal=ClearBal
			,@Currency=Currency
		WHERE isfinished = 0	

		IF @@ROWCOUNT = 0 BREAK
		
		--Insert super
		EXEC Acc_Dep_CustomerInsMember_Com 
			@Custid=@SuperID OUTPUT,@creator=@CreatorID,@Username=@Super,@userpwd=@Pass,@site=@sitename,@currency=@Currency,
			@IP=@IP,@ErrCode=@ErrCode OUTPUT,@ErrMsg=@ErrMsg OUTPUT

			IF @ErrCode<>0
			BEGIN				
				SELECT @ErrMsg = @ErrMsg + @Super
				SELECT @ListCustIDRollBack= CAST(@SuperID AS VARCHAR(20))																														
				EXEC Dot_Dep_RollBackLicensee @ListCustID=@ListCustIDRollBack	
				RETURN 				
			END
			INSERT INTO #tempSuper(CustID)
			SELECT @SuperID
			--Insert master
			EXEC Acc_Dep_CustomerInsMember_SAg 
				@Custid=@MasterID OUTPUT,@creator=@CreatorID,@Username=@Master,@userpwd=@Pass,@srecommend=@SuperID,
				@IP=@IP,@ErrCode=@ErrCode OUTPUT,@ErrMsg=@ErrMsg OUTPUT
			
			IF @ErrCode<>0
			BEGIN
				SELECT @ErrMsg = @ErrMsg + @Master	
				SELECT @ListCustIDRollBack= CAST(@SuperID AS VARCHAR(20))+','+
													CAST(@MasterID AS VARCHAR(20))																					
				EXEC Dot_Dep_RollBackLicensee @ListCustID=@ListCustIDRollBack					
				RETURN
			END
			--Insert agent
			EXEC Acc_Dep_CustomerInsMember_MAg 
				@Custid=@AgentID OUTPUT,@creator=@CreatorID,@Username=@Agent,@userpwd=@Pass,@mrecommend=@MasterID,
				@IP=@IP,@ErrCode=@ErrCode OUTPUT,@ErrMsg=@ErrMsg OUTPUT,
				@InsBalCustList = @InsBalCustList_s OUTPUT,
				@InsBalExceptCustList = @InsBalExceptCustList_s OUTPUT

			IF @ErrCode<>0
			BEGIN
				SELECT @ErrMsg = @ErrMsg + @Agent
				SELECT @ListCustIDRollBack= CAST(@SuperID AS VARCHAR(20))+','+
													CAST(@MasterID AS VARCHAR(20))+','+
													CAST(@AgentID AS VARCHAR(20))											
				EXEC Dot_Dep_RollBackLicensee @ListCustID=@ListCustIDRollBack
				RETURN
			END

			SELECT @InsBalCustList = @InsBalCustList + ISNULL(',' + @InsBalCustList_s, '')
			SELECT @InsBalExceptCustList = @InsBalExceptCustList + ISNULL(',' + @InsBalExceptCustList_s, '')

			-- Insert dummy account
			EXEC Acc_Dep_CustomerInsMember_SAg 
				@Custid=@AccMasterID OUTPUT,@creator=@CreatorID,@Username=@AccMaster,@userpwd=@Pass,@srecommend=@SuperID,
				@IP=@IP,@ErrCode=@ErrCode OUTPUT,@ErrMsg=@ErrMsg OUTPUT

			IF @ErrCode<>0
			BEGIN
				SELECT @ErrMsg = @ErrMsg + @AccMaster
				SELECT @ListCustIDRollBack= CAST(@SuperID AS VARCHAR(20))+','+
													CAST(@MasterID AS VARCHAR(20))+','+
													CAST(@AgentID AS VARCHAR(20))+','+
													CAST(@AccMasterID AS VARCHAR(20))
													
				EXEC Dot_Dep_RollBackLicensee @ListCustID=@ListCustIDRollBack
				RETURN
			END
			-- Insert dummy account
			EXEC Acc_Dep_CustomerInsMember_MAg 
				@Custid=@AccAgentID OUTPUT,@creator=@CreatorID,@Username=@AccAgent,@userpwd=@Pass,@mrecommend=@AccMasterID,
				@IP=@IP,@ErrCode=@ErrCode OUTPUT,@ErrMsg=@ErrMsg OUTPUT,
				@InsBalCustList = @InsBalCustList_s OUTPUT,
				@InsBalExceptCustList = @InsBalExceptCustList_s OUTPUT
				
			IF @ErrCode<>0
			BEGIN
				SELECT @ErrMsg = @ErrMsg + @AccAgent	
				SELECT @ListCustIDRollBack= CAST(@SuperID AS VARCHAR(20))+','+
													CAST(@MasterID AS VARCHAR(20))+','+
													CAST(@AgentID AS VARCHAR(20))+','+
													CAST(@AccMasterID AS VARCHAR(20))+','+
													CAST(@AccAgentID AS VARCHAR(20))
				EXEC Dot_Dep_RollBackLicensee @ListCustID=@ListCustIDRollBack
				RETURN
			END

			SELECT @InsBalCustList = @InsBalCustList + ISNULL(',' + @InsBalCustList_s, '')
			SELECT @InsBalExceptCustList = @InsBalExceptCustList + ISNULL(',' + @InsBalExceptCustList_s, '')

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

				EXEC Acc_Dep_CustomerInsMember_Ag 
					@custid=@tmpDumCustID OUTPUT,@creator=@creatorID,@username=@tmpDumUserName,@userpwd=@Pass,
					@recommend=@DummyAgentID,@IP=@IP,@ErrCode=@ErrCode OUTPUT,@ErrMsg=@ErrMsg OUTPUT

				INSERT INTO #tempDumCustID(CustID)
				SELECT 	@tmpDumCustID		

				SELECT @InsBalExceptCustList = @InsBalExceptCustList + ISNULL(',' + CONVERT(VARCHAR,@tmpDumCustID) +  ';' + @tmpDumUserName,'')
			END
				

				IF @ErrCode<>0
				BEGIN
					SELECT @ErrMsg = @ErrMsg + 'Create Dummy accounts.'
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
							@IP=@IP,@ErrCode=@ErrCode OUTPUT,@ErrMsg=@ErrMsg OUTPUT	,
							@InsBalCustList = @InsBalCustList_s OUTPUT,
							@InsBalExceptCustList = @InsBalExceptCustList_s OUTPUT	
						
						INSERT INTO #tempSubCustID(CustID)
						SELECT 	@tmpSubCustID				
						
						SELECT @InsBalCustList = @InsBalCustList + ISNULL(',' + @InsBalCustList_s, '')
						SELECT @InsBalExceptCustList = @InsBalExceptCustList + ISNULL(',' + @InsBalExceptCustList_s, '')
					END
					
					
					IF @ErrCode<>0
					BEGIN
						SELECT @ErrMsg = @ErrMsg + 'Create sub agent.'
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
			
			-- Clear stake level for new licensees
			IF EXISTS(SELECT TOP 1 1 
						FROM #Product a
						INNER JOIN Dep_ProductSetting b WITH(NOLOCK) ON a.ProductID = b.ProductID
						WHERE b.SettingType = 7)
			BEGIN
				DELETE sl
				FROM #Product a
				INNER JOIN Dep_ProductSetting b WITH(NOLOCK) ON a.ProductID = b.ProductID
				INNER JOIN Dep_ProductSettingDetail c WITH(NOLOCK) ON b.ProductSettingID = c.ProductSettingID
				INNER JOIN Dep_StakeLevel sl WITH(ROWLOCK) ON sl.GameTypeID = c.BetType 
											AND sl.ExchangeID = @Currency AND sl.SiteID = @SiteID
				WHERE b.SettingType = 7 AND a.Currency = sl.ExchangeID
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
				
			--Sportbooks			
			IF EXISTS(SELECT TOP 1 1 FROM #Product WHERE ProductID=1 AND Currency=@Currency)
			BEGIN
				INSERT INTO #BetLimit(Sporttype,Bettype,MinBet,MaxBet,MaxPerMatch,MaxPerNumber,MaxPayoutPerMatch)
				EXEC Acc_Dep_CustSetting_Game_BetLimitFullLineSettingSelect @SuperID=@SuperID,@ProductID=1,@AgentID=0 
				
				INSERT INTO #BetLimitInput(Sporttype,Bettype,MinBet,MaxBet,MaxPerMatch,MaxPerNumber,MaxPayoutPerMatch,BetLimitType,ProductID)
				SELECT DISTINCT b.Sporttype,b.Bettype,p.MinBet,p.MaxBet,p.MaxPerMatch,p.MaxPerNumber,p.MaxPayoutPerMatch,2,1
				FROM #BetLimit b
					INNER JOIN #Product p ON b.Sporttype = p.Sporttype AND b.Bettype = p.Bettype
				WHERE p.ProductID=1 AND p.Currency=@Currency		
			
				TRUNCATE TABLE #BetLimit				
			
				-- Insert PT		
				SELECT  @PT_XML = ('<ROOT>' + (
									SELECT 
										 SportType AS 'SportType'
										,Bettype AS 'BetType'
										,IsLive AS 'IsLive'
										,@PT_Sportsbook AS 'PT'
									FROM dbo.f_Dep_CustSetting_SportBetTypeSettingSelect(1,1) 
									FOR XML RAW('PT')) + '</ROOT>')
				
				EXEC Acc_Dep_CustSetting_PositionTakingSettingUpd @SuperID=@SuperID,@AgentID=@AgentID,@IsAgentOnly=0,@PT=@PT_XML,@ProductID=1,@UserID=@CreatorID,@IP=@IP,
						@ErrCode=@ErrCode OUTPUT,@ErrMsg=@ErrMsg OUTPUT

				IF @ErrCode<>0
				BEGIN
					SELECT @ErrMsg = @ErrMsg + 'PT Sportbooks.' +@Agent
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
										,@PT_Sportsbook AS 'PT'
									FROM dbo.f_Dep_CustSetting_SportBetTypeSettingSelect(1,1) 
									FOR XML RAW('PT')) + '</ROOT>')
				
						EXEC Acc_Dep_CustSetting_PositionTakingSettingUpd @SuperID=@SuperID,@AgentID=@tmpSubCustID,@IsAgentOnly=1,@PT=@PT_XML,@ProductID=1,@UserID=@CreatorID,@IP=@IP,
							@ErrCode=@ErrCode OUTPUT,@ErrMsg=@ErrMsg OUTPUT						
					END					
					IF @ErrCode<>0
					BEGIN
						SELECT @ErrMsg = @ErrMsg + 'PT DCS Sportbooks sub licensees.'
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

			--Number Games
			IF EXISTS(SELECT TOP 1 1 FROM #Product WHERE ProductID=3 AND Currency=@Currency)
			BEGIN
				INSERT INTO #BetLimit(Sporttype,Bettype,MinBet,MaxBet,MaxPerMatch,MaxPerNumber,MaxPayoutPerMatch)
				EXEC Acc_Dep_CustSetting_Game_BetLimitFullLineSettingSelect @SuperID=@SuperID,@ProductID=3,@AgentID=0 
				
				INSERT INTO #BetLimitInput(Sporttype,Bettype,MinBet,MaxBet,MaxPerMatch,MaxPerNumber,MaxPayoutPerMatch,BetLimitType,ProductID)
				SELECT DISTINCT b.Sporttype,b.Bettype,p.MinBet,p.MaxBet,p.MaxPerMatch,p.MaxPerNumber,p.MaxPayoutPerMatch,2,3
				FROM #BetLimit b
					CROSS JOIN #Product p
				WHERE p.ProductID=3 AND p.Currency=@Currency		
			
				TRUNCATE TABLE #BetLimit	
				
				INSERT INTO #SportsStatus(ProductID,Sporttype ,Bettype,bitmapOrder,IsDisable,IsDisableDownLine,HasDownline,IsDisableUpline)
				EXEC Acc_Dep_CustSetting_StatusSelect @ProductID=3,@CustID=@SuperID
				SELECT @SporttypeID=Sporttype,@BettypeID=Bettype,@bitmapOrder=bitmapOrder FROM #SportsStatus
				-- Insert status
				EXEC Acc_Dep_CustSetting_StatusUpd @ProductID=3,@CustID=@SuperID,@IsDisabled=0,@IsDisabledDownLine=0,@SportType=@SportTypeID,@BetType=@BetTypeID,@bitmapOrder=@bitmapOrder,@UserID=@CreatorID,@IP=@IP,
					@IsAgentOnly=0,@ErrCode=@ErrCode OUTPUT,@ErrMsg=@ErrMsg OUTPUT
						
				IF @ErrCode<>0
				BEGIN
					SELECT @ErrMsg = @ErrMsg + 'Status DCS Number Games.'
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
										,@PT_NumberGame AS 'PT'
									FROM dbo.f_Dep_CustSetting_SportBetTypeSettingSelect(3,1) 
									FOR XML RAW('PT')) + '</ROOT>')
				
				EXEC Acc_Dep_CustSetting_PositionTakingSettingUpd @SuperID=@SuperID,@AgentID=@AgentID,@IsAgentOnly=0,@PT=@PT_XML,@ProductID=3,@UserID=@CreatorID,@IP=@IP,
						@ErrCode=@ErrCode OUTPUT,@ErrMsg=@ErrMsg OUTPUT

				IF @ErrCode<>0
				BEGIN
					SELECT @ErrMsg = @ErrMsg + 'PT Number Games.' +@Agent
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
										,@PT_NumberGame AS 'PT'
									FROM dbo.f_Dep_CustSetting_SportBetTypeSettingSelect(3,1) 
									FOR XML RAW('PT')) + '</ROOT>')
				
						EXEC Acc_Dep_CustSetting_PositionTakingSettingUpd @SuperID=@SuperID,@AgentID=@tmpSubCustID,@IsAgentOnly=1,@PT=@PT_XML,@ProductID=3,@UserID=@CreatorID,@IP=@IP,
							@ErrCode=@ErrCode OUTPUT,@ErrMsg=@ErrMsg OUTPUT						
					END					
					IF @ErrCode<>0
					BEGIN
						SELECT @ErrMsg = @ErrMsg + 'PT DCS Number Games sub licensees.'
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

			--Keno
			IF EXISTS(SELECT TOP 1 1 FROM #Product WHERE ProductID=8 AND Currency=@Currency)
			BEGIN
				INSERT INTO #BetLimit(Sporttype,Bettype,MinBet,MaxBet,MaxPerMatch)
				EXEC Acc_Dep_CustSetting_BetLimitFullLineSettingSelect @SuperID=@SuperID,@ProductID=8,@AgentID=0 		
			
				INSERT INTO #BetLimitInput(Sporttype,Bettype,MinBet,MaxBet,MaxPerMatch)
				SELECT DISTINCT b.Sporttype,b.Bettype,p.MinBet,p.MaxBet,p.MaxPerMatch
				FROM #BetLimit b
					CROSS JOIN #Product p		
				WHERE p.ProductID=8	AND p.Currency=@Currency
				TRUNCATE TABLE #BetLimit

				INSERT INTO #SportsStatus(ProductID,Sporttype ,Bettype,bitmapOrder,IsDisable,IsDisableDownLine,HasDownline,IsDisableUpline)
				EXEC Acc_Dep_CustSetting_StatusSelect @ProductID=8,@CustID=@SuperID
				SELECT @SporttypeID=Sporttype,@BettypeID=Bettype,@bitmapOrder=bitmapOrder FROM #SportsStatus
				-- Insert status
				EXEC Acc_Dep_CustSetting_StatusUpd @ProductID=8,@CustID=@SuperID,@IsDisabled=0,@IsDisabledDownLine=0,@SportType=@SportTypeID,@BetType=@BetTypeID,@bitmapOrder=@bitmapOrder,@UserID=@CreatorID,@IP=@IP,
					@IsAgentOnly=0,@ErrCode=@ErrCode OUTPUT,@ErrMsg=@ErrMsg OUTPUT
						
				IF @ErrCode<>0
				BEGIN
					SELECT @ErrMsg = @ErrMsg + 'Status DCS Keno.'
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
								,@PT_Keno AS 'PT'
							FROM dbo.f_Dep_CustSetting_SportBetTypeSettingSelect(8,1) 
							FOR XML RAW('PT')) + '</ROOT>')
				EXEC Acc_Dep_CustSetting_PositionTakingSettingUpd @SuperID=@SuperID,@AgentID=@AgentID,@IsAgentOnly=0,@PT=@PT_XML,@ProductID=8,@UserID=@CreatorID,@IP=@IP,
						@ErrCode=@ErrCode OUTPUT,@ErrMsg=@ErrMsg OUTPUT

				IF @ErrCode<>0
				BEGIN
					SELECT @ErrMsg = @ErrMsg + 'PT DCS Keno.' +@Agent
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
								,@PT_Keno AS 'PT'
							FROM dbo.f_Dep_CustSetting_SportBetTypeSettingSelect(8,1)
							FOR XML RAW('PT')) + '</ROOT>')
						EXEC Acc_Dep_CustSetting_PositionTakingSettingUpd @SuperID=@SuperID,@AgentID=@tmpSubCustID,@IsAgentOnly=1,@PT=@PT_XML,@ProductID=8,@UserID=@CreatorID,@IP=@IP,
							@ErrCode=@ErrCode OUTPUT,@ErrMsg=@ErrMsg OUTPUT						
					END					
					IF @ErrCode<>0
					BEGIN
						SELECT @ErrMsg = @ErrMsg + 'PT DCS Keno sub licensees.'
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
			
			--Bitcoin			
			IF EXISTS(SELECT TOP 1 1 FROM #Product WHERE ProductID=1 AND Currency=@Currency)
			BEGIN
					SET @ProductID = 69	
					SET @ProductName = 'Bitcoin'
					
					IF EXISTS(SELECT TOP 1 1 FROM #Product WHERE ProductID=@ProductID AND Currency=@Currency)
					BEGIN
						INSERT INTO #BetLimit(Sporttype,Bettype,MinBet,MaxBet,MaxPerMatch)
						EXEC Acc_Dep_CustSetting_BetLimitFullLineSettingSelect @SuperID=@SuperID,@ProductID=@ProductID,@AgentID=0 	
						INSERT INTO #BetLimitInput(Sporttype,Bettype,MinBet,MaxBet,MaxPerMatch)
						SELECT DISTINCT b.Sporttype,b.Bettype,p.MinBet,p.MaxBet,p.MaxPerMatch
						FROM #BetLimit b
							CROSS JOIN #Product p  	
						WHERE p.ProductID=@ProductID AND p.Currency=@Currency	
						TRUNCATE TABLE #BetLimit
					END	
										
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
					-- Insert PT
					IF @ProductID = 28
					BEGIN
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
				,CASE WHEN ProductID = 38 THEN @PT_VirtualGames
					  WHEN ProductID = 51 THEN @PT_WM 
					  WHEN ProductID = 39 THEN @PT_SAGaming 	
					  WHEN ProductID = 21 THEN @PT_Allbet 	
					  WHEN ProductID = 45 THEN @PT_AE
					  ELSE @PT_SAGaming END AS PT
				,CASE WHEN ProductID = 38 THEN 'Virtual Games'
			              WHEN ProductID = 51 THEN 'WM' 
				      WHEN ProductID = 39 THEN 'SA Gaming'  
				      WHEN ProductID = 21 THEN 'Allbet'
				      WHEN ProductID = 45 THEN 'AE Sexy'
				ELSE 'SA Gaming' END AS ProductName
			FROM #Product 
			WHERE ProductID in (38,39,51,21,45) AND Currency=@Currency
		
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

			--Arcadia Gaming , Vgaming , SG,PG Soft, AdvantPlay , AdvantPlay Mini, CG, Saba Casino, Macau Games, PP, Habanero
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
						WHEN 6  THEN @PT_SabaCasino   
						WHEN 22 THEN @PT_MacauGames   
						WHEN 32 THEN @PT_PP   
						WHEN 61 THEN @PT_Habanero  
						END AS PT
				,CASE ProductID 
						WHEN 34 THEN 'Arcadia Gaming'  
						WHEN 36 THEN 'SpadeGaming'  
						WHEN 55 THEN 'PG Soft'  
						WHEN 66 THEN 'Vgaming' 
						WHEN 67 THEN 'AdvantPlay'
						WHEN 68 THEN 'AdvantPlay Mini' 
						WHEN 62 THEN 'CG' 
						WHEN 6  THEN 'Saba Casino' 
						WHEN 22 THEN 'Macau Games' 
						WHEN 32 THEN 'PP' 
						WHEN 61 THEN 'Habanero' 
					END AS ProductName
			FROM #Product 
			WHERE ProductID in (34,66,36,55,62,67,68,6,22,32,61) AND Currency=@Currency
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
																					SELECT ','+CONVERT(VARCHAR,StakeLevelID)
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

			-- Insert betlimit - type 2 (Dep_CustBetSettingGame_xxx tables: SportBooks, NumberGames...)
			--Update value null if not used (to correct dynamic XML)
			UPDATE t
			SET t.MaxPerNumber = CASE WHEN SettingType = 12 THEN t.MaxPerNumber ELSE NULL END,
				t.MaxPayoutPerMatch = CASE WHEN SettingType = 10 THEN t.MaxPayoutPerMatch ELSE NULL END
			FROM #BetLimitInput t
				INNER JOIN Dep_ProductSetting d WITH(NOLOCK) 
					ON t.ProductID = d.ProductID
			WHERE t.BetLimitType = 2
				AND d.SettingType IN (10,12)

			WHILE (1 = 1)
			BEGIN
				SELECT  TOP (1) @tmpProductID = ProductID
				FROM #BetLimitInput			
				WHERE isfinished = 0
					AND BetLimitType = 2
					
				IF @@ROWCOUNT = 0 BREAK

				SELECT  @BetLimit = CONVERT(VARCHAR(MAX),
				(
					SELECT SportType AS '@SportType',
							BetType AS '@BetType',
							MinBet AS '@MinBet',
							MaxBet AS '@MaxBet',
							MaxPerMatch AS '@MaxPerMatch',
							MaxPerNumber AS '@MaxPerNumber',
							MaxPayoutPerMatch AS '@MaxPayoutPerMatch'
					FROM #BetLimitInput	
					WHERE isfinished = 0
						AND ProductID = @tmpProductID
						AND BetLimitType = 2
					FOR XML PATH('BetLimit'), ROOT ('ROOT'),TYPE)
				)

				UPDATE #BetLimitInput
				SET isfinished = 1
				WHERE isfinished = 0
					AND ProductID = @tmpProductID
					AND BetLimitType = 2
				
				EXEC Acc_Dep_CustSetting_Game_BetLimitFullLineUpd @SuperID=@SuperID,
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
							EXEC Acc_Dep_CustSetting_Game_BetLimitFullLineUpd @SuperID=@SuperID,
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
			
			-- Insert betlimit - type 1 (Dep_CustBetSetting_xxx tables, other DCS products)
			WHILE (1 = 1)
			BEGIN
				UPDATE TOP (1) #BetLimitInput
				SET isfinished = 1
					,@SporttypeID=Sporttype,@BettypeID=Bettype					
					,@MinBet=MinBet,@MaxBet=MaxBet,@MaxPerMatch=MaxPerMatch				
				WHERE isfinished = 0
					AND BetLimitType = 1

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
					,@InsBalCustList = @InsBalCustList_s OUTPUT

				IF @ErrMsg<>''
				BEGIN
					SELECT @ErrCode=10000,@ErrMsg='CashOut.'+@ErrMsg
					RETURN
				END

				SELECT @InsBalCustList = @InsBalCustList + ISNULL(',' + @InsBalCustList_s, '')
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
	-- WM	
	IF EXISTS(SELECT TOP 1 1 FROM #Product WHERE ProductID=51)
		SELECT @ProductCode=@ProductCode+'WM,'	
	-- Bitcoin	
	IF EXISTS(SELECT TOP 1 1 FROM #Product WHERE ProductID=1)
		SELECT @ProductCode=@ProductCode+'BTC,'		
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
	-- Saba Casino	
	IF EXISTS(SELECT TOP 1 1 FROM #Product WHERE ProductID=6)
		SELECT @ProductCode=@ProductCode+'CS,'			
	-- Macau Games	
	IF EXISTS(SELECT TOP 1 1 FROM #Product WHERE ProductID=22)
		SELECT @ProductCode=@ProductCode+'VB,'			
	-- PP	
	IF EXISTS(SELECT TOP 1 1 FROM #Product WHERE ProductID=32)
		SELECT @ProductCode=@ProductCode+'PP,'			
	-- Habanero	
	IF EXISTS(SELECT TOP 1 1 FROM #Product WHERE ProductID=61)
		SELECT @ProductCode=@ProductCode+'HB,'				
	-- Allbet	
	IF EXISTS(SELECT TOP 1 1 FROM #Product WHERE ProductID=21)
		SELECT @ProductCode=@ProductCode+'AB,'			
	-- AE Sexy	
	IF EXISTS(SELECT TOP 1 1 FROM #Product WHERE ProductID=45)
		SELECT @ProductCode=@ProductCode+'SXG,'			
		
	SELECT @ProductCode=SUBSTRING(@ProductCode, 1, LEN(@ProductCode) - 1)
	
	-- List Currency
	WHILE (1 = 1)
	BEGIN
			UPDATE TOP (1) #Currency
			SET isfinished = 1 , @Currency=Currency
			WHERE isfinished = 0	
	
			IF @@ROWCOUNT = 0 BREAK
			-- Insert LM Licensee
			EXEC bodb_Licensee.dbo.Dot_Dep_LM_CreateCurrencyLicensee
				@LicenseeName = @sitename, -- from input
				@Currency = @Currency,	
				@ErrCode = @ErrCode OUTPUT,
				@ErrMsg = @ErrMsg OUTPUT
			IF @ErrCode<>0
			BEGIN	
				SELECT @ErrMsg='LAP.'+@ErrMsg			
				RETURN
			END
			
			EXEC bodb_Licensee.dbo.LA_DiscountByGrossWinCurrencyIns
				@SiteName				 =@SiteName
				,@CurrencyId			= @Currency
				,@PT_Sportsbook			= @PT_Sportsbook
				,@UserId				= @CreatorID
				,@IP					= @IP
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
		SELECT @ErrMsg='Create Currency for Licensee successfully'

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
	SELECT @PT_WM=@PT_WM/100
	SELECT @PT_AP=@PT_AP/100
	SELECT @PT_ApMini=@PT_ApMini/100
	SELECT @PT_CG=@PT_CG/100
	SELECT @PT_VS3=@PT_VS3/100
	-----------
	SELECT @PT_Sportsbook=@PT_Sportsbook/100
	SELECT @PT_NumberGame=@PT_NumberGame/100
	SELECT @PT_Keno=@PT_Keno/100
	SELECT @PT_SabaCasino=@PT_SabaCasino/100
	SELECT @PT_Allbet=@PT_Allbet/100
	SELECT @PT_MacauGames=@PT_MacauGames/100
	SELECT @PT_PP=@PT_PP/100
	SELECT @PT_AE=@PT_AE/100
	SELECT @PT_Habanero=@PT_Habanero/100

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
		SELECT  51, @PT_WM
		UNION
		SELECT  62, @PT_CG
		UNION 
		SELECT  67, @PT_AP
		UNION 
		SELECT  68, @PT_ApMini
		UNION 
		SELECT  49, @PT_VS3
		UNION 
		SELECT  6, @PT_SabaCasino
		UNION 
		SELECT  21, @PT_Allbet
		UNION 
		SELECT  22, @PT_MacauGames
		UNION 
		SELECT  32, @PT_PP
		UNION 
		SELECT  45, @PT_AE
		UNION 
		SELECT  61, @PT_Habanero

		DELETE FROM #PTLog WHERE ProductID NOT IN(SELECT ProductID FROM #Product WHERE Currency=@Currency)		
			
		SET @xml = (
					SELECT  (
							SELECT  @sitename														AS '@sitename'
									, @LicenseeType													AS '@LicenseeType'
									, @IP															AS '@IP'								
									, @creator														AS '@creator'			
									, @SuperID														AS '@SuperID'	
									, @IsBA															AS '@BA'
									, @Currency														AS '@Currency'	
									, @IsCashOut													AS '@CashOut'	
									, @IsCreateSub													AS '@Subsidiary'	
									, @ErrCode														AS '@ErrCode'	
									, @ErrMsg														AS '@ErrMsg'	
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
									,  dbo.f_CS_FomatNumber (CAST(bs1.MaxPerNumber 		AS VARCHAR(50)))				AS [@mpb]
									,  dbo.f_CS_FomatNumber (CAST(bs1.MaxPerMatch 		AS VARCHAR(50)))				AS [@mpm]	
									,  dbo.f_CS_FomatNumber (CAST(bs1.MaxPayoutPerMatch AS VARCHAR(50)))				AS [@mppm]	
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
										,  dbo.f_CS_FomatNumber (CAST(bs.MaxPerNumber 		AS VARCHAR(50)))				AS [@mpb]
										,  dbo.f_CS_FomatNumber (CAST(bs.MaxPerMatch 		AS VARCHAR(50)))				AS [@mpm]				
								FROM #Product bs 
								WHERE Currency=@Currency AND bs.ProductID NOT IN(-1,25,1,38,34,66,36,55,39,62,67,68,51,69,6,22,32,61,21,45)			
								ORDER BY ProductID, Sporttype, Bettype				
								FOR XML PATH('Product'), ROOT ('BS2'),
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
		
		EXEC dbo.Acc_WriteLog_UserLog_RunSP_Wrapper
			@UserID = @CreatorID,
			@CustID = @SuperID,
			@ActionID = 2216,
			@TrackingValue = @LogSPData,
			@duration = @duration
	END	

	SET @InsBalCustList = STUFF(@InsBalCustList,1,1,'')
	SET @InsBalExceptCustList = STUFF(@InsBalExceptCustList,1,1,'')

	DECLARE @NewLogData VARCHAR(MAX)
	SELECT @NewLogData = '<R '
						+ 'InsBalCustList="'+ coalesce(cast(@InsBalCustList as varchar(MAX)),space(1)) + '" '
						+ 'InsBalExceptCustList="'+ coalesce(cast(@InsBalExceptCustList as varchar(MAX)),space(1)) + '" '
						+ ' />'

	EXEC dbo.Acc_WriteLog_UserLog_RunSP_Wrapper
		@UserId				= @CreatorID,
		@CustID				= 0,
		@ActionId			= 2220,
		@TrackingValue		= @NewLogData
END
GO