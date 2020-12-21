/*<info serverAlias="DBCust-CustDB" executers="Dot_Member" viewers="" isFunction="0"></info>*/
CREATE PROCEDURE [dbo].[Dot_Dep_CustomerInsMember_OddAdj]
	@Custid			INT OUTPUT,
	@Creator		INT,
	@Recommend		INT, -- Real Agent 
	@IP				VARCHAR(15)='',
	@ErrCode		INT = 0 OUTPUT,
	@ErrMsg			NVARCHAR(4000) = '' OUTPUT
AS
/*
	Created by: Winfred
	Date: 20201005
	Task: Create Member Dummy OddAdj
	DB: DBCust/CustDB
	Original: 
	
	Revisions:
		- 20201005@Winfred: Check OddsAdj dummy customers [redmine:#142952]

	Explanation's Param:
		
*/   
BEGIN 
	SET NOCOUNT ON
	DECLARE	@Username VARCHAR(30),@Site NVARCHAR(100),	@Userpwd VARCHAR(40),@Language VARCHAR(2),@SubAccID INT  --Sub-AccountID
	
	SELECT @Userpwd = '8058095B7DDB08A608811097E5DB8D',@Language = 'E',@SubAccID = 0
	
	SELECT @Site  = ci.site,@Username = ci.site+ e.currency + '01OddsAdj' 
	FROM Customer as ci with (NOLOCK) 
	INNER JOIN exchange e with(nolock) on ci.currency = e.ExchangeId
	WHERE ci.custid = @Recommend AND ci.roleid = 2
	-- Check Site offer OddAdj
	DECLARE @IsSiteOffer BIT
	EXEC Acc_Dep_CustomerCheckOddsAdj @Site = @Site, @IsOffer = @IsSiteOffer OUTPUT

	IF @IsSiteOffer = 0
	BEGIN    
		SELECT @ErrMsg = 'The site is not offer OddAdj.', @ErrCode = 111    
		RETURN    
	END  
	DECLARE 
			--number game status
			@DisableNumber bit = 0,	
			@MinBetv1 money,
			@MaxBetv1 money,
			@MaxPerMatchv1 money,
			@MinBetv2 money,
			@MaxBetv2 money,
			@MaxPerMatchv2 money,
			@MinBetv3 money,
			@MaxBetv3 money,
			@MaxPerMatchv3 money,

			@MinBetv5 money,
			@MaxBetv5 money,
			@MaxPerMatchv5 money,

			@MinBetv8 money,
			@MaxBetv8 money,
			@MaxPerMatchv8 money,

			@MinBetv10 money,
			@MaxBetv10 money,
			@MaxPerMatchv10 money,

			@MinBetv11 money,
			@MaxBetv11 money,
			@MaxPerMatchv11 money,

			@MinBetv99 money,
			@MaxBetv99 money,
			@MaxPerMatchv99 money,	

			-- mix parlay of mixed sports
			@MinBetv1mp money =0,
			@MaxBetv1mp money =0,
			@MaxPerMatchv1mp money =0,

			@MinBetv99mp money,
			@MaxBetv99mp money,
			@MaxPerMatchv99mp money,
			-- number game
			@MinBetv161 money,
			@MaxBetv161 money,
			@MaxPerMatchv161 money,
			@MaxPerBallv161 money = 0
				
	DECLARE	@v1apositiontaking_1 smallmoney,
			@v1apositiontaking_2 smallmoney,
			@v1apositiontaking_3 smallmoney,
			@v1apositiontaking_4 smallmoney,
			@v1apositiontaking_5 smallmoney,
			@v1apositiontaking_6 smallmoney,
			@v1apositiontaking_7 smallmoney,
			@v1apositiontaking_8 smallmoney,
			@v1apositiontaking_9 smallmoney,
			@v1apositiontaking_10 smallmoney,
			
			@v1alivepositiontaking_1 smallmoney,
			@v1alivepositiontaking_3 smallmoney,
			@v1alivepositiontaking_7 smallmoney,
			@v1alivepositiontaking_8 smallmoney,
			
			@v2apositiontaking_1 smallmoney,
			@v2apositiontaking_2 smallmoney,
			@v2apositiontaking_3 smallmoney,
			@v2apositiontaking_7 smallmoney,
			@v2apositiontaking_8 smallmoney,
			@v2apositiontaking_20 smallmoney,

			@v3apositiontaking_1 smallmoney,
			@v3apositiontaking_2 smallmoney,
			@v3apositiontaking_3 smallmoney,
			@v3apositiontaking_20 smallmoney,

			@v5apositiontaking_1 smallmoney,
			@v5apositiontaking_2 smallmoney,
			@v5apositiontaking_3 smallmoney,
			@v5apositiontaking_20 smallmoney,

			@v8apositiontaking_1 smallmoney,
			@v8apositiontaking_3 smallmoney,
			@v8apositiontaking_20 smallmoney,

			@v10apositiontaking_1 smallmoney,
			@v10apositiontaking_2 smallmoney,
			@v10apositiontaking_3 smallmoney,
			@v10apositiontaking_20 smallmoney,

			@v11apositiontaking_1 smallmoney,
			@v11apositiontaking_20 smallmoney,	

			@v99apositiontaking_1 smallmoney,
			@v99apositiontaking_2 smallmoney,
			@v99apositiontaking_3 smallmoney,
			@v99apositiontaking_20 smallmoney,

			-- mix parlay of mixed sports	
			@v99apositiontaking_9 smallmoney, 

			@v161apositiontaking_81 smallmoney,
			@v161apositiontaking_83 smallmoney,
			@v161apositiontaking_86 smallmoney,
			@v161apositiontaking_88 smallmoney = 0,

			@v161alivepositiontaking_85 smallmoney,
			@v161alivepositiontaking_86 smallmoney,	
			@v161alivepositiontaking_87 smallmoney,
			@v161alivepositiontaking_89 smallmoney = 0,	
			@v161alivepositiontaking_90 smallmoney = 0,
			--Keno
			@KenoList VARCHAR(4000)='',
			@DisableKeno BIT = 0  
	-- Set value default customer dummy
	
	SELECT @DisableNumber=1,
			@MinBetv1=0.0000,
			@MaxBetv1=0.0000,
			@MaxPerMatchv1=0.0000,
			@MinBetv2=0.0000,
			@MaxBetv2=0.0000,
			@MaxPerMatchv2=0.0000,
			@MinBetv3=0.0000,
			@MaxBetv3=0.0000,
			@MaxPerMatchv3=0.0000,
			@MinBetv5=0.0000,
			@MaxBetv5=0.0000,
			@MaxPerMatchv5=0.0000,
			@MinBetv8=0.0000,
			@MaxBetv8=0.0000,
			@MaxPerMatchv8=0.0000,
			@MinBetv10=0.0000,
			@MaxBetv10=0.0000,
			@MaxPerMatchv10=0.0000,
			@MinBetv11=0.0000,
			@MaxBetv11=0.0000,
			@MaxPerMatchv11=0.0000,
			@MinBetv99=0.0000,
			@MaxBetv99=0.0000,
			@MaxPerMatchv99=0.0000,
			@MinBetv1mp=0.0000,
			@MaxBetv1mp=0.0000,
			@MaxPerMatchv1mp=0.0000,
			@MinBetv99mp=0.0000,
			@MaxBetv99mp=0.0000,
			@MaxPerMatchv99mp=0.0000,
			@MinBetv161=0.0000,
			@MaxBetv161=0.0000,
			@MaxPerMatchv161=0.0000,
			@MaxPerBallv161=0.0000,

			@v1apositiontaking_1=0.0000,
			@v1apositiontaking_2=0.0000,
			@v1apositiontaking_3=0.0000,
			@v1apositiontaking_4=0.0000,
			@v1apositiontaking_5=0.0000,
			@v1apositiontaking_6=0.0000,
			@v1apositiontaking_7=0.0000,
			@v1apositiontaking_8=0.0000,
			@v1apositiontaking_9=0.0000,
			@v1apositiontaking_10=0.0000,

			@v1alivepositiontaking_1=0.0000,
			@v1alivepositiontaking_3=0.0000,
			@v1alivepositiontaking_7=0.0000,
			@v1alivepositiontaking_8=0.0000,

			@v2apositiontaking_1=0.0000,
			@v2apositiontaking_2=0.0000,
			@v2apositiontaking_3=0.0000,
			@v2apositiontaking_7=0.0000,
			@v2apositiontaking_8=0.0000,
			@v2apositiontaking_20=0.0000,

			@v3apositiontaking_1=0.0000,
			@v3apositiontaking_2=0.0000,
			@v3apositiontaking_3=0.0000,
			@v3apositiontaking_20=0.0000,

			@v5apositiontaking_1=0.0000,
			@v5apositiontaking_2=0.0000,
			@v5apositiontaking_3=0.0000,
			@v5apositiontaking_20=0.0000,

			@v8apositiontaking_1=0.0000,
			@v8apositiontaking_3=0.0000,
			@v8apositiontaking_20=0.0000,

			@v10apositiontaking_1=0.0000,
			@v10apositiontaking_2=0.0000,
			@v10apositiontaking_3=0.0000,
			@v10apositiontaking_20=0.0000,

			@v11apositiontaking_1=0.0000,
			@v11apositiontaking_20=0.0000,

			@v99apositiontaking_1=0.0000,
			@v99apositiontaking_2=0.0000,
			@v99apositiontaking_3=0.0000,
			@v99apositiontaking_20=0.0000,
			@v99apositiontaking_9=0.0000,

			@v161apositiontaking_81=0.0000,
			@v161apositiontaking_83=0.0000,
			@v161apositiontaking_86=0.0000,
			@v161apositiontaking_88=0.0000,

			@v161alivepositiontaking_85=0.0000,
			@v161alivepositiontaking_86=0.0000,
			@v161alivepositiontaking_87=0.0000,
			@v161alivepositiontaking_89=0.0000,
			@v161alivepositiontaking_90=0.0000,
			@DisableKeno = 0,
			@KenoList='<products><product Bettype="1501" MaxBet="0" MinBet="0" MaxPerMatch="0" IsDisable="1" sPositionTaking="0" mPositionTaking="0" aPositionTaking="0"></product></products>'  
			
	EXEC Acc_Dep_CustomerInsMember_Ag 
			@custid			=	@Custid output,
			@creator		=	@Creator,
			@username		=	@Username,
			@userpwd		=	@Userpwd,
			@recommend		=	@Recommend,
			@DisableNumber	=	@DisableNumber,
			
			@MinBetv1			=	@MinBetv1,
			@MaxBetv1			=	@MaxBetv1,
			@MaxPerMatchv1		=	@MaxPerMatchv1,
			@MinBetv2			=	@MinBetv2,
			@MaxBetv2			=	@MaxBetv2,
			@MaxPerMatchv2		=	@MaxPerMatchv2,
			@MinBetv3			=	@MinBetv3,
			@MaxBetv3			=	@MaxBetv3,
			@MaxPerMatchv3		=	@MaxPerMatchv3,
			@MinBetv5			=	@MinBetv5,
			@MaxBetv5			=	@MaxBetv5,
			@MaxPerMatchv5		=	@MaxPerMatchv5,
			@MinBetv8			=	@MinBetv8,
			@MaxBetv8			=	@MaxBetv8,
			@MaxPerMatchv8		=	@MaxPerMatchv8,
			@MinBetv10			=	@MinBetv10,
			@MaxBetv10			=	@MaxBetv10,
			@MaxPerMatchv10		=	@MaxPerMatchv10,
			@MinBetv11			=	@MinBetv11,
			@MaxBetv11			=	@MaxBetv11,
			@MaxPerMatchv11		=	@MaxPerMatchv11,
			@MinBetv99			=	@MinBetv99,
			@MaxBetv99			=	@MaxBetv99,
			@MaxPerMatchv99		=	@MaxPerMatchv99,
			@MinBetv1mp			=	@MinBetv1mp,
			@MaxBetv1mp			=	@MaxBetv1mp,
			@MaxPerMatchv1mp	=	@MaxPerMatchv1mp,
			@MinBetv99mp		=	@MinBetv99mp,
			@MaxBetv99mp		=	@MaxBetv99mp,
			@MaxPerMatchv99mp	=	@MaxPerMatchv99mp,
			@MinBetv161			=	@MinBetv161,
			@MaxBetv161			=	@MaxBetv161,
			@MaxPerMatchv161	=	@MaxPerMatchv161,
			@MaxPerBallv161		=	@MaxPerBallv161,
			
			@v1apositiontaking_1	=	@v1apositiontaking_1,
			@v1apositiontaking_2	=	@v1apositiontaking_2,
			@v1apositiontaking_3	=	@v1apositiontaking_3,
			@v1apositiontaking_4	=	@v1apositiontaking_4,
			@v1apositiontaking_5	=	@v1apositiontaking_5,
			@v1apositiontaking_6	=	@v1apositiontaking_6,
			@v1apositiontaking_7	=	@v1apositiontaking_7,
			@v1apositiontaking_8	=	@v1apositiontaking_8,
			@v1apositiontaking_9	=	@v1apositiontaking_9,
			@v1apositiontaking_10	=	@v1apositiontaking_10,
			
			@v1alivepositiontaking_1	=	@v1alivepositiontaking_1,
			@v1alivepositiontaking_3	=	@v1alivepositiontaking_3,
			@v1alivepositiontaking_7	=	@v1alivepositiontaking_7,
			@v1alivepositiontaking_8	=	@v1alivepositiontaking_8,
			
			@v2apositiontaking_1	=	@v2apositiontaking_1,
			@v2apositiontaking_2	=	@v2apositiontaking_2,
			@v2apositiontaking_3	=	@v2apositiontaking_3,
			@v2apositiontaking_7	=	@v2apositiontaking_7,
			@v2apositiontaking_8	=	@v2apositiontaking_8,
			@v2apositiontaking_20	=	@v2apositiontaking_20,
			@v3apositiontaking_1	=	@v3apositiontaking_1,
			@v3apositiontaking_2	=	@v3apositiontaking_2,
			@v3apositiontaking_3	=	@v3apositiontaking_3,
			@v3apositiontaking_20	=	@v3apositiontaking_20,
			@v5apositiontaking_1	=	@v5apositiontaking_1,
			@v5apositiontaking_2	=	@v5apositiontaking_2,
			@v5apositiontaking_3	=	@v5apositiontaking_3,
			@v5apositiontaking_20	=	@v5apositiontaking_20,
			@v8apositiontaking_1	=	@v8apositiontaking_1,
			@v8apositiontaking_3	=	@v8apositiontaking_3,
			@v8apositiontaking_20	=	@v8apositiontaking_20,
			@v10apositiontaking_1	=	@v10apositiontaking_1,
			@v10apositiontaking_2	=	@v10apositiontaking_2,
			@v10apositiontaking_3	=	@v10apositiontaking_3,
			@v10apositiontaking_20	=	@v10apositiontaking_20,
			@v11apositiontaking_1	=	@v11apositiontaking_1,
			@v11apositiontaking_20	=	@v11apositiontaking_20,
			@v99apositiontaking_1	=	@v99apositiontaking_1,
			@v99apositiontaking_2	=	@v99apositiontaking_2,
			@v99apositiontaking_3	=	@v99apositiontaking_3,
			@v99apositiontaking_20	=	@v99apositiontaking_20,
			@v99apositiontaking_9	=	@v99apositiontaking_9,
			
			@v161apositiontaking_81		=	@v161apositiontaking_81,
			@v161apositiontaking_83		=	@v161apositiontaking_83,
			@v161apositiontaking_86		=	@v161apositiontaking_86,
			@v161apositiontaking_88		=	@v161apositiontaking_88,
			@v161alivepositiontaking_85		=	@v161alivepositiontaking_85,
			@v161alivepositiontaking_86		=	@v161alivepositiontaking_86,
			@v161alivepositiontaking_87		=	@v161alivepositiontaking_87,
			@v161alivepositiontaking_89		=	@v161alivepositiontaking_89,
			@v161alivepositiontaking_90		=	@v161alivepositiontaking_90,
			
			@KenoList		=	@KenoList,
			@DisableKeno	=	@DisableKeno,
			@IP				=	@IP,
			@Language		=	@Language,
			@SubAccID		=	@SubAccID,
			@ErrCode		=	@ErrCode output,
			@ErrMsg			=	@ErrMsg output
	
END
