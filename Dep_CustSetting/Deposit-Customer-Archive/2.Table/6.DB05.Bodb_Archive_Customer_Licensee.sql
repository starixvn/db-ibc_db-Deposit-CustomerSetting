/*
	Task: Create new tables for Depsoit Customer Archive
			1.Customer
			2.CustInfo
			3.CustVirtualSetting
			4.Dep_CustSetting
			5.Dep_CustSetting3rd
			6.Dep_CustProductSetting
			7.Dep_CustSetting_AGCasino
			8.Dep_CustCommRate
			9.CustSettingGame
			10.Dep_CustSettingGame
			11.Dep_CustPTSetting_Member
			12.Dep_CustSettingMode
			13.Dep_CustProductStatus
			14.Dep_CustStakeLevel_Member
			15.Dep_CustBetSetting_Member
			16.Dep_CustDiscountSetting_Member
			17.Dep_CustSpecialLevel
			18.CustGameType
	Database: DB05.Bodb_Archive_Customer_Licensee
*/

USE Bodb_Archive_Customer_Licensee

--1.Customer
	CREATE TABLE Customer (
		[custid] [int] NOT NULL,
		[firstname] [nvarchar](50) NULL,
		[lastname] [nvarchar](50) NULL,
		[address] [nvarchar](80) NULL,
		[postal] [nvarchar](50) NULL,
		[city] [nvarchar](50) NULL,
		[state] [nvarchar](50) NULL,
		[country] [nvarchar](50) NULL,
		[phone] [nvarchar](50) NULL,
		[mobilephone] [nvarchar](50) NULL,
		[fax] [nvarchar](50) NULL,
		[email] [nvarchar](50) NULL,
		[birthday] [smalldatetime] NULL,
		[refcode1] [nvarchar](50) NULL,
		[refcode2] [nvarchar](50) NULL,
		[remark] [nvarchar](50) NULL,
		[creatdate] [smalldatetime] NULL,
		[creator] [int] NOT NULL,
		[username] [varchar](30) NOT NULL,
		[currency] [tinyint] NULL,
		[userpwd] [varchar](40) NULL,
		[lastlogged] [smalldatetime] NULL,
		[pwdexpiry] [datetime] NULL,
		[roleid] [tinyint] NULL,
		[mrecommend] [int] NULL,
		[recommend] [int] NULL,
		[ugroup] [varchar](3) NULL,
		[logincount] [tinyint] NULL,
		[on_sessionid] [int] NULL,
		[site] [varchar](10) NULL,
		[iplogin] [nvarchar](20) NULL,
		[important] [bit] NULL,
		[srecommend] [int] NULL,
		[username2] [varchar](50) NULL
	) ON Customer_Table
	WITH (DATA_COMPRESSION = PAGE) ;


	CREATE UNIQUE CLUSTERED INDEX PK_Customer ON Customer(CustID) WITH (DATA_COMPRESSION = PAGE) ON Customer_Table

--2.CustInfo
	CREATE TABLE [custInfo] (
		[username] [nvarchar](50) NULL,
		[custid] [int] NOT NULL,
		[currency] [int] NULL,
		[roleid] [tinyint] NULL,
		[srecommend] [int] NULL,
		[mrecommend] [int] NULL,
		[recommend] [int] NULL,
		[dangercust] [bit] NULL,
		[autosuspend] [bit] NULL,
		[reject] [bit] NULL,
		[credit] [money] NULL,
		[closed] [bit] NULL,
		[MatchLimit] [smallmoney] NOT NULL,
		[VirtualMultiplier] [smallmoney] NOT NULL,
		[maxpermatch] [money] NULL,
		[maxpermatch2] [money] NULL,
		[maxpermatch3] [money] NULL,
		[maxpermatch5] [money] NULL,
		[maxpermatch8] [money] NULL,
		[maxpermatch10] [money] NULL,
		[maxpermatch11] [money] NULL,
		[maxpermatch12] [money] NULL,
		[maxpermatch99] [money] NULL,
		[Enabled] [bit] NOT NULL,
		[danger] [tinyint] NOT NULL,
		[maxpermatch151] [money] NULL,
		[maxpermatch201] [money] NULL,
		[DisableHorseRacing] [bit] NOT NULL,
		[DisableFinancial] [bit] NOT NULL,
		[DisableCasino] [bit] NOT NULL,
		[SyncCasino] [bit] NOT NULL,
		[danger2] [tinyint] NOT NULL,
		[danger3] [tinyint] NOT NULL,
		[DisableOutright] [bit] NOT NULL,
		[DisableOpenTote] [bit] NOT NULL,
		[maxpermatch151_OT] [money] NOT NULL,
		[MaxPerMatch99MP] [money] NOT NULL,
		[DisableBingo] [bit] NOT NULL,
		[DisableNumber] [bit] NOT NULL,
		[maxpermatch161] [money] NOT NULL,
		[SyncBingo] [bit] NOT NULL,
		[MaxPerBall161] [money] NOT NULL,
		[MaxPerMatch151_AU] [money] NOT NULL,
		[MaxPerMatch152_UK] [money] NOT NULL,
		[MaxPerMatch152_AU] [money] NOT NULL,
		[MaxPerMatch153_AU] [money] NOT NULL,
		[Disable151_AU] [bit] NOT NULL,
		[Disable152_UK] [bit] NOT NULL,
		[Disable152_AU] [bit] NOT NULL,
		[Disable153_AU] [bit] NOT NULL,
		[MaxtransferP2P] [money] NOT NULL,
		[IsAutoResetP2P] [bit] NOT NULL,
		[DisableP2P] [bit] NOT NULL,
		[DisableFunP2P] [bit] NOT NULL,
		[DisableLiveCasino] [bit] NOT NULL,
		[SyncLiveCasino] [bit] NOT NULL,
		[DisableVirtualSports] [bit] NOT NULL,
		[HideVirtualSports] [bit] NOT NULL,
		[maxpermatch180] [money] NULL,
		[Abnormal] [tinyint] NOT NULL,
		[DoubleCommLosing] [bit] NOT NULL,
		[isAutoResetLiveCasino] [bit] NOT NULL,
		[MaxWinLiveCasino] [smallmoney] NOT NULL,
		[maxpermatch186] [money] NULL,
		[maxpermatch181] [money] NULL,
		[maxpermatch182] [money] NULL,
		[DisableCasinoBonus] [bit] NOT NULL,
		[maxpermatch184] [money] NULL,
		[DisableHRFixedOdds] [bit] NULL,
		[maxpermatch154] [money] NULL,
		[autosuspend2] [bit] NULL,
		[maxpermatch183] [money] NULL,
		[maxpermatch185] [money] NULL,
		[HideKeno] [bit] NULL,
		[DisableEsports] [bit] NULL,
		[HideGoldDeluxe] [bit] NULL,
		[DisableGoldDeluxe] [bit] NULL,
		[DisableSuperLive] [bit] NULL,
		[DisableColossusBet] [bit] NULL,
		[HideColossusBet] [bit] NULL,
		[MaxPerMatch44] [money] NULL,
		[DisableMicrogameLC] [bit] NULL,
		[DisableMicrogameRNG] [bit] NULL,
		[DisableBinaryOptions] [bit] NULL,
		[LockUpd] [bit] NULL,
		[MaxPerMatch1MP] [money] NULL,
		[BonusWalletFlag] [bit] NULL
	) ON Customer_Table
	WITH (DATA_COMPRESSION = PAGE) ;


	CREATE UNIQUE CLUSTERED INDEX [PK_custinfo] ON [custInfo](CustID) WITH (DATA_COMPRESSION = PAGE) ON Customer_Table

--3.CustVirtualSetting
	CREATE TABLE [CustVirtualSetting] (
		[custid] [int] NOT NULL,
		[seqNo] [tinyint] NOT NULL,
		[bitmapVirtual] [binary](64) NOT NULL
		) ON CustVirtualSetting_Table
	WITH (DATA_COMPRESSION = PAGE) ;


	CREATE UNIQUE CLUSTERED INDEX [PK_CustVirtualSetting] ON [CustVirtualSetting]([custid],[seqNo]) WITH (DATA_COMPRESSION = PAGE) ON CustVirtualSetting_Table

--4.Dep_CustSetting
	CREATE TABLE [Dep_CustSetting] (
		[custid] [int] NOT NULL,
		[bettype] [smallint] NOT NULL,
		[sporttype] [smallint] NOT NULL,
		[islive] [bit] NOT NULL,
		[apositiontaking] [smallmoney] NOT NULL,
		[mpositiontaking] [smallmoney] NOT NULL,
		[spositiontaking] [smallmoney] NOT NULL,
		[playerdiscount] [decimal](9, 8) NOT NULL,
		[discount] [decimal](9, 8) NOT NULL,
		[adiscount] [decimal](9, 8) NOT NULL,
		[sdiscount] [decimal](9, 8) NOT NULL,
		[minbet] [money] NOT NULL,
		[maxbet] [money] NOT NULL
		) ON Dep_Custsetting_Table
	WITH (DATA_COMPRESSION = PAGE) ;


	CREATE UNIQUE CLUSTERED INDEX [PK_Dep_Custsetting] ON [Dep_CustSetting]([custid],[bettype],[sporttype],[islive]) WITH (DATA_COMPRESSION = PAGE) ON Dep_Custsetting_Table

--5.Dep_CustSetting3rd
	CREATE TABLE [Dep_CustSetting3rd] (
		[custid] [int] NOT NULL,
		[bettype] [smallint] NOT NULL,
		[sporttype] [smallint] NOT NULL,
		[islive] [bit] NOT NULL,
		[apositiontaking] [smallmoney] NOT NULL,
		[mpositiontaking] [smallmoney] NOT NULL,
		[spositiontaking] [smallmoney] NOT NULL,
		[playerdiscount] [decimal](9, 8) NOT NULL,
		[discount] [decimal](9, 8) NOT NULL,
		[adiscount] [decimal](9, 8) NOT NULL,
		[sdiscount] [decimal](9, 8) NOT NULL,
		[minbet] [money] NOT NULL,
		[maxbet] [money] NOT NULL
		) ON Dep_Custsetting3rd_Table
	WITH (DATA_COMPRESSION = PAGE) ;


	CREATE UNIQUE CLUSTERED INDEX [PK_Dep_Custsetting3rd] ON [Dep_CustSetting3rd]([custid],[bettype],[sporttype],[islive]) WITH (DATA_COMPRESSION = PAGE) ON Dep_Custsetting3rd_Table

--6.Dep_CustProductSetting
	CREATE TABLE [Dep_CustProductSetting] (
		[CustID] [int] NOT NULL,
		[ProductId] [int] NOT NULL,
		[IsEnabled] [bit] NULL
		) ON Dep_CustSettingGame_Table
	WITH (DATA_COMPRESSION = PAGE) ;


	CREATE UNIQUE CLUSTERED INDEX [PK_Dep_CustProductSetting] ON [Dep_CustProductSetting]([custid],[ProductId]) WITH (DATA_COMPRESSION = PAGE) ON Dep_CustSettingGame_Table

--7.Dep_CustSetting_AGCasino
	CREATE TABLE [Dep_CustSetting_AGCasino] (
		[CustID] [int] NOT NULL,
		[AGGroup] [varchar](20) NULL,
		[IsEnabled] [bit] NULL
		) ON Dep_CustSettingGame_Table
	WITH (DATA_COMPRESSION = PAGE) ;


	CREATE UNIQUE CLUSTERED INDEX [PK_Dep_CustSetting_AGCasino] ON [Dep_CustSetting_AGCasino]([custid]) WITH (DATA_COMPRESSION = PAGE) ON Dep_CustSettingGame_Table

--8.Dep_CustCommRate
	CREATE TABLE [dbo].[Dep_CustCommRate](
		[CustID] [int] NOT NULL,
		[SportType] [smallint] NOT NULL,
		[BetType] [smallint] NOT NULL,
		[sdiscount] [decimal](9, 8) NULL,
		[adiscount] [decimal](9, 8) NULL,
		[discount] [decimal](9, 8) NULL,
		[playerdiscount] [decimal](9, 8) NULL
		) ON Dep_Custsetting3rd_Table
	WITH (DATA_COMPRESSION = PAGE) ;

	CREATE UNIQUE CLUSTERED INDEX [PK_Dep_CustCommRate] ON [Dep_CustCommRate]([custid],[SportType],[BetType]) WITH (DATA_COMPRESSION = PAGE) ON Dep_Custsetting3rd_Table

--9.CustSettingGame
	CREATE TABLE [dbo].[CustSettingGame](
		[CustID] [int] NOT NULL,
		[Bettype] [smallint] NOT NULL,
		[Sporttype] [smallint] NOT NULL,
		[apositiontaking] [smallmoney] NOT NULL,
		[mpositiontaking] [smallmoney] NOT NULL,
		[spositiontaking] [smallmoney] NOT NULL,
		[playerdiscount] [decimal](9, 8) NOT NULL,
		[discount] [decimal](9, 8) NOT NULL,
		[adiscount] [decimal](9, 8) NOT NULL,
		[sdiscount] [decimal](9, 8) NOT NULL,
		[autopositiontaking] [smallmoney] NOT NULL,
		[isautopositiontaking] [bit] NOT NULL,
		[autompositiontaking] [smallmoney] NOT NULL,
		[isautompositiontaking] [bit] NOT NULL
		) ON CustSettingGame_Table
	WITH (DATA_COMPRESSION = PAGE) ;

	CREATE UNIQUE CLUSTERED INDEX [PK_CustSettingGame] ON [CustSettingGame]([custid],[BetType],[SportType]) WITH (DATA_COMPRESSION = PAGE) ON CustSettingGame_Table

--10.Dep_CustSettingGame
	CREATE TABLE [dbo].[Dep_CustSettingGame](
		[CustID] [int] NOT NULL,
		[Bettype] [smallint] NOT NULL,
		[Sporttype] [smallint] NOT NULL,
		[apositiontaking] [smallmoney] NOT NULL,
		[mpositiontaking] [smallmoney] NOT NULL,
		[spositiontaking] [smallmoney] NOT NULL,
		[playerdiscount] [decimal](9, 8) NOT NULL,
		[discount] [decimal](9, 8) NOT NULL,
		[adiscount] [decimal](9, 8) NOT NULL,
		[sdiscount] [decimal](9, 8) NOT NULL
		) ON Dep_CustSettingGame_Table
	WITH (DATA_COMPRESSION = PAGE) ;

	CREATE UNIQUE CLUSTERED INDEX [PK_Dep_CustSettingGame] ON [Dep_CustSettingGame]([custid],[BetType],[SportType]) WITH (DATA_COMPRESSION = PAGE) ON Dep_CustSettingGame_Table

--11.Dep_CustPTSetting_Member
	CREATE TABLE [dbo].[Dep_CustPTSetting_Member](
		[CustID] [int] NOT NULL,
		[SportType] [smallint] NOT NULL,
		[BetType] [smallint] NOT NULL,
		[IsLive] [bit] NOT NULL,
		[SuperPT] [smallmoney] NULL,
		[MasterPT] [smallmoney] NULL,
		[AgentPT] [smallmoney] NULL
	) ON Dep_CustPTSetting_Table
	WITH (DATA_COMPRESSION = PAGE) ;

	CREATE UNIQUE CLUSTERED INDEX [PK_Dep_CustPTSetting_Member] ON [Dep_CustPTSetting_Member]([custid],[SportType],[BetType],[IsLive]) WITH (DATA_COMPRESSION = PAGE) ON Dep_CustPTSetting_Table
--12.Dep_CustSettingMode
	CREATE TABLE [dbo].[Dep_CustSettingMode](
		[CustID] [int] NOT NULL,
		[IsGroupedPT] [bit] NOT NULL,
		[IsGroupedComm] [bit] NOT NULL,
		[IsGroupedBetLimit] [bit] NOT NULL,
		[IsGroupedStakeLevel] [bit] NOT NULL
	) ON Dep_CustPTSetting_Table
	WITH (DATA_COMPRESSION = PAGE) ;

	CREATE UNIQUE CLUSTERED INDEX [PK_Dep_CustSettingMode] ON [Dep_CustSettingMode]([custid]) WITH (DATA_COMPRESSION = PAGE) ON Dep_CustPTSetting_Table
--13.Dep_CustProductStatus
	CREATE TABLE [dbo].[Dep_CustProductStatus](
		[CustID] [int] NOT NULL,
		[bitmapIsHidden] [binary](32) NOT NULL,
		[bitmapIsDisabled] [binary](32) NOT NULL
	) ON Customer_Table
	WITH (DATA_COMPRESSION = PAGE) ;

	CREATE UNIQUE CLUSTERED INDEX [CIX_Dep_CustProductStatus_custid] ON [Dep_CustProductStatus]([custid]) WITH (DATA_COMPRESSION = PAGE) ON Customer_Table

--14.Dep_CustStakeLevel_Member
	CREATE TABLE [dbo].[Dep_CustStakeLevel_Member](
		[CustID] [int] NOT NULL,
		[SportType] [smallint] NOT NULL,
		[BetType] [smallint] NOT NULL,
		[StakeLevelList] [varchar](200) NULL,
		[LastUpdated] [datetime] NULL
	) ON Dep_CustStakeLevel_Table
	WITH (DATA_COMPRESSION = PAGE) ;

	CREATE UNIQUE CLUSTERED INDEX [PK_Dep_CustStakeLevel_Member] ON [Dep_CustStakeLevel_Member]([custid],[SportType],[BetType]) WITH (DATA_COMPRESSION = PAGE) ON Dep_CustStakeLevel_Table

--15.Dep_CustBetSetting_Member
	CREATE TABLE [dbo].[Dep_CustBetSetting_Member](
		[CustID] [int] NOT NULL,
		[SportType] [smallint] NOT NULL,
		[BetType] [smallint] NOT NULL,
		[MinBet] [money] NULL,
		[MaxBet] [money] NULL,
		[MaxPerMatch] [money] NULL
	) ON Dep_CustBetSetting_Table
	WITH (DATA_COMPRESSION = PAGE) ;

	CREATE UNIQUE CLUSTERED INDEX [PK_Dep_CustBetSetting_Member] ON [Dep_CustBetSetting_Member]([custid],[SportType],[BetType]) WITH (DATA_COMPRESSION = PAGE) ON Dep_CustBetSetting_Table
--16.Dep_CustDiscountSetting_Member
	CREATE TABLE [dbo].[Dep_CustDiscountSetting_Member](
		[CustID] [int] NOT NULL,
		[SportType] [smallint] NOT NULL,
		[BetType] [smallint] NOT NULL,
		[PlayerDiscount] [decimal](9, 8) NULL,
		[AgentDiscount] [decimal](9, 8) NULL,
		[MasterDiscount] [decimal](9, 8) NULL,
		[SuperDiscount] [decimal](9, 8) NULL
	) ON Dep_CustDiscount_Member_Table
	WITH (DATA_COMPRESSION = PAGE) ;

	CREATE UNIQUE CLUSTERED INDEX [PK_Dep_CustDiscountSetting_Member] ON [Dep_CustDiscountSetting_Member]([custid],[SportType],[BetType]) WITH (DATA_COMPRESSION = PAGE) ON Dep_CustDiscount_Member_Table

	GO
--17.Dep_CustSpecialLevel
	CREATE TABLE [dbo].[Dep_CustSpecialLevel](
		[custid] [int] NOT NULL,
		[SpecialLevel] [int] NOT NULL
	) ON DATA
	WITH (DATA_COMPRESSION = PAGE) ;

	CREATE UNIQUE CLUSTERED INDEX [PK_Dep_CustSpecialLevel] ON [Dep_CustSpecialLevel]([custid]) WITH (DATA_COMPRESSION = PAGE) ON DATA

--17.CustGameType
	CREATE TABLE [dbo].[CustGameType](
		[CustID] [int] NOT NULL,
		[GameTypeID] [int] NOT NULL,
		[StakeLevelList] [varchar](100) NULL,
		[MaxPerGameType] [money] NULL,
		[MinBet] [money] NULL,
		[MaxBet] [money] NULL,
		[IsDisabled] [bit] NOT NULL
	) ON CustGameType_Table
	WITH (DATA_COMPRESSION = PAGE) ;

	CREATE UNIQUE CLUSTERED INDEX [PK_CustGameType] ON [CustGameType]([custid],[GameTypeID]) WITH (DATA_COMPRESSION = PAGE) ON CustGameType_Table