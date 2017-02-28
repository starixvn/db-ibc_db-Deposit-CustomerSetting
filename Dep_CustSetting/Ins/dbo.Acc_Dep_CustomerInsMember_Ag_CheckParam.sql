ALTER PROCEDURE [dbo].[Acc_Dep_CustomerInsMember_Ag_CheckParam]
	
	@recommend int,
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
	
	@MinBetv44 money,
	@MaxBetv44 money,
	@MaxPerMatchv44 money,
	
	@MinBetv99 money,
	@MaxBetv99 money,
	@MaxPerMatchv99 money,
	
	@MinBetv154 money,
	@MaxBetv154 money,
	@MaxPerMatchv154 money,	
	
	--Mix Parlay mix sports
	@MinBetv99MP money,
	@MaxBetv99MP money,
	@MaxPerMatchv99MP money,
	
	--Number game
	@MinBetv161 money,
	@MaxBetv161 money,
	@MaxPerBallv161 money = 0,
	@MaxPerMatchv161 money,

	@v1apositiontaking_1 smallmoney,
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
	
	@v44apositiontaking_3 smallmoney,
	
	@v99apositiontaking_1 smallmoney,
	@v99apositiontaking_2 smallmoney,
	@v99apositiontaking_3 smallmoney,
	@v99apositiontaking_9 smallmoney,
	@v99apositiontaking_20 smallmoney,

	@v154apositiontaking_20 smallmoney,
	
	--Racing
	@v151apositiontaking_31 smallmoney,
	@v151apositiontaking_32 smallmoney,
	@v151apositiontaking_41 smallmoney,
	@v151apositiontaking_42 smallmoney,
	
	@v151apositiontaking_51 smallmoney,
	@v151apositiontaking_52 smallmoney,

	@v152apositiontaking_41 smallmoney,
	@v152apositiontaking_42 smallmoney,
	@v152apositiontaking_51 smallmoney,
	@v152apositiontaking_52 smallmoney,

	@v153apositiontaking_51 smallmoney,
	@v153apositiontaking_52 smallmoney,
	
	@v161apositiontaking_81 smallmoney, 
	@v161apositiontaking_83 smallmoney, 
	@v161apositiontaking_86 smallmoney, 
	@v161apositiontaking_88 smallmoney, 
	@v161alivepositiontaking_85 smallmoney,
	@v161alivepositiontaking_86 smallmoney,
	@v161alivepositiontaking_87 smallmoney,
	@v161alivepositiontaking_89 smallmoney,
	@v161alivepositiontaking_90 smallmoney,

	@v151discount_31 decimal(9,8),	
	@v151discount_41 decimal(9,8),
	@v151discount_51 decimal(9,8),
	@v152discount_41 decimal(9,8),
	@v152discount_51 decimal(9,8),
	@v153discount_51 decimal(9,8),

	@isvalid bit OUTPUT, 
	@errmsg nvarchar(4000) OUTPUT,
	@errcode int OUTPUT,
	@language varchar(2) = 'E'
AS

--@Source Control

/*
Created: 20120323@Dom
Task : check valid parameters.
DB: DBTRANS.bodb02
Original:

Revisions:
   - 20121128@Elodie: Get an error message from f_Get_MsgNameByMsgID function by language
   - 20130912@Don: Extend value range for Number Game PT from 0.9 to 1
   - 20140505@Florent: Add Sport HRFO
   - 20151028@Jim:Implement Muay's Setting for Deposit Customer [Redmine: #45491]
Param's Explanation:
• @ErrCode:
    = 0: check valid parameters successfully.
    > 0: Specific Error.
  
• @ErrMsg: Error description.
*/

SET NOCOUNT ON

declare @ErrType varchar(4000)

Select @isvalid = 1

if 
	@MinBetv1<0
	or @MaxBetv1 < 0
	or @MaxPerMatchv1 <0
	
	or @MinBetv2 <0
	or @MaxBetv2 <0
	or @MaxPerMatchv2 <0
	
	or @MinBetv3 <0
	or @MaxBetv3 <0
	or @MaxPerMatchv3 <0

	or @MinBetv5 <0
	or @MaxBetv5 <0
	or @MaxPerMatchv5 <0

	or @MinBetv8 <0
	or @MaxBetv8 <0
	or @MaxPerMatchv8 <0

	or @MinBetv10 <0
	or @MaxBetv10 <0
	or @MaxPerMatchv10 <0

	or @MinBetv11 <0
	or @MaxBetv11 <0
	or @MaxPerMatchv11 <0
	
	or @MinBetv44 <0
	or @MaxBetv44 <0
	or @MaxPerMatchv44 <0
	
	or @MinBetv99 <0
	or @MaxBetv99 <0
	or @MaxPerMatchv99 <0

	or @MinBetv154 <0
	or @MaxBetv154 <0
	or @MaxPerMatchv154 <0
		
	--Mix Parlay mix sports
	or @MinBetv99MP <0
	or @MaxBetv99MP <0
	or @MaxPerMatchv99MP <0
	
	--Number game
	or @MinBetv161 <0
	or @MaxBetv161 <0
	or @MaxPerBallv161 < 0
	or @MaxPerMatchv161 <0
	
	--Racing
	or @v151apositiontaking_31 < 0
	or @v151apositiontaking_32 < 0
	or @v151apositiontaking_41 < 0
	or @v151apositiontaking_42 < 0
							   
	or @v151apositiontaking_51 < 0
	or @v151apositiontaking_52 < 0
	 						   
	or @v152apositiontaking_41 < 0
	or @v152apositiontaking_42 < 0
	or @v152apositiontaking_51 < 0
	or @v152apositiontaking_52 < 0
	 						   
	or @v153apositiontaking_51 < 0
	or @v153apositiontaking_52 < 0	
	
	or @v151discount_31 < 0
	or @v151discount_41 < 0
	or @v151discount_51 < 0
	or @v152discount_41 < 0
	or @v152discount_51 < 0
	or @v153discount_51 < 0

	or @recommend <=0
	
BEGIN
	select @isvalid = 0, @ErrCode = 102
	Select @ErrMsg = 	case @Language 
						when 'E' then 'Wrong Min bet/ Max bet/ Max per ball/ Max per match/ Credit/ Agent name.'
						ELSE [dbo].[f_Get_MsgNamebyMsgID](10028,@Language)
				end
	return
END
if 
	@v1apositiontaking_1  <0
	or @v1apositiontaking_2  <0
	or @v1apositiontaking_3  <0
	or @v1apositiontaking_4  <0
	or @v1apositiontaking_5  <0
	or @v1apositiontaking_6  <0
	or @v1apositiontaking_7  <0
	or @v1apositiontaking_8  <0
	or @v1apositiontaking_9  <0
	or @v1apositiontaking_10 <0
	or @v1alivepositiontaking_1  <0
	or @v1alivepositiontaking_3  <0
	or @v1alivepositiontaking_7  <0
	or @v1alivepositiontaking_8  <0
	
	
	or @v2apositiontaking_1  <0
	or @v2apositiontaking_2  <0
	or @v2apositiontaking_3  <0
	or @v2apositiontaking_7  <0
	or @v2apositiontaking_8  <0
	or @v2apositiontaking_20  <0

	or @v3apositiontaking_1  <0
	or @v3apositiontaking_2  <0
	or @v3apositiontaking_3  <0
	or @v3apositiontaking_20  <0

	or @v5apositiontaking_1  <0
	or @v5apositiontaking_2  <0
	or @v5apositiontaking_3  <0
	or @v5apositiontaking_20  <0

	or @v8apositiontaking_1  <0
	or @v8apositiontaking_3  <0
	or @v8apositiontaking_20  <0

	or @v10apositiontaking_1  <0
	or @v10apositiontaking_2  <0
	or @v10apositiontaking_3  <0
	or @v10apositiontaking_20  <0

	or @v11apositiontaking_1  <0
	or @v11apositiontaking_20  <0
	
	or @v44apositiontaking_3  <0
		
	or @v99apositiontaking_1  <0
	or @v99apositiontaking_2  <0
	or @v99apositiontaking_3  <0
	or @v99apositiontaking_9 <0
	or @v99apositiontaking_20  <0
	or @v154apositiontaking_20  <0
	
	
	
	or @v161apositiontaking_81 <0
	or @v161apositiontaking_83 <0
	or @v161apositiontaking_86 <0
	or @v161apositiontaking_88 <0
	or @v161alivepositiontaking_85 <0
	or @v161alivepositiontaking_86 <0
	or @v161alivepositiontaking_87 <0
	or @v161alivepositiontaking_89 <0
	or @v161alivepositiontaking_90 <0
	
	
	or @v1apositiontaking_1  >0.9
	or @v1apositiontaking_2  >0.9
	or @v1apositiontaking_3  >0.9
	or @v1apositiontaking_4  >0.9
	or @v1apositiontaking_5  >0.9
	or @v1apositiontaking_6  >0.9
	or @v1apositiontaking_7  >0.9
	or @v1apositiontaking_8  >0.9
	or @v1apositiontaking_9  >0.9
	or @v1apositiontaking_10 >0.9
	or @v1alivepositiontaking_1  >0.9
	or @v1alivepositiontaking_3  >0.9
	or @v1alivepositiontaking_7  >0.9
	or @v1alivepositiontaking_8  >0.9
	
	or @v2apositiontaking_1  >0.9
	or @v2apositiontaking_2  >0.9
	or @v2apositiontaking_3  >0.9
	or @v2apositiontaking_7  >0.9
	or @v2apositiontaking_8  >0.9
	or @v2apositiontaking_20  >0.9

	or @v3apositiontaking_1  >0.9
	or @v3apositiontaking_2  >0.9
	or @v3apositiontaking_3  >0.9
	or @v3apositiontaking_20  >0.9

	or @v5apositiontaking_1  >0.9
	or @v5apositiontaking_2  >0.9
	or @v5apositiontaking_3  >0.9
	or @v5apositiontaking_20  >0.9

	or @v8apositiontaking_1  >0.9
	or @v8apositiontaking_3  >0.9
	or @v8apositiontaking_20  >0.9

	or @v10apositiontaking_1  >0.9
	or @v10apositiontaking_2  >0.9
	or @v10apositiontaking_3  >0.9
	or @v10apositiontaking_20  >0.9

	or @v11apositiontaking_1  >0.9
	or @v11apositiontaking_20  >0.9
	
	or @v44apositiontaking_3  >0.9
	
	or @v99apositiontaking_1  >0.9
	or @v99apositiontaking_2  >0.9
	or @v99apositiontaking_3  >0.9
	or @v99apositiontaking_9 >0.9
	or @v99apositiontaking_20  >0.9	
	
	
	or @v161apositiontaking_81 >1
	or @v161apositiontaking_83 >1
	or @v161apositiontaking_86 >1
	or @v161apositiontaking_88 >1
	or @v161alivepositiontaking_87 >1
	or @v161alivepositiontaking_85 >1
	or @v161alivepositiontaking_86 >1
	or @v161alivepositiontaking_89 >1
	or @v161alivepositiontaking_90 >1
	
	
BEGIN
	select @isvalid = 0, @ErrCode = 103
	Select @ErrMsg = 	case @Language 
						when 'E' then 'Wrong position taking.'
						ELSE [dbo].[f_Get_MsgNamebyMsgID](20001,@Language)
				end
	return
END
	
return
GO
GRANT EXECUTE ON [dbo].[Acc_Dep_CustomerInsMember_Ag_CheckParam] TO [bodbAdminNet] AS [dbo]
GO
GRANT VIEW DEFINITION ON [dbo].[Acc_Dep_CustomerInsMember_Ag_CheckParam] TO [vnteam] AS [dbo]