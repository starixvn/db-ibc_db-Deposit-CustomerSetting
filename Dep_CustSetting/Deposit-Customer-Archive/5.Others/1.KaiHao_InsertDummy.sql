/*
	Task: Add a dummy account to clear balance of licensee KaiHao
	Creator: Dominic
	Run at: DBCUST.CustDB
*/

Use CustDB

--Parameters
DECLARE @_DummyUsername VARCHAR(30) = 'KaiHaoRMB01ClearBal' --Naming convention: Licenseename + Currency + Seq. Number + ClearBal (for example: BE7IN01ClearBal)
DECLARE @_recommend INT = 15582199 --KaiHaoRMB01
DECLARE @_creator INT = 10278938 --starixit
DECLARE @_userpwd VARCHAR(40) ='8058095B7DDB08A608811097E5DB8D' --123qwe

--Output values
DECLARE @_CustID INT
DECLARE @_ErrCode INT
DECLARE @_ErrMsg NVARCHAR(4000) = ''


EXEC Acc_Dep_CustomerInsMember_Ag 
@username=@_DummyUsername
,@recommend=@_recommend
,@creator=@_creator
,@userpwd=@_userpwd
,@DisableNumber=1,@MinBetv1=0.0000,@MaxBetv1=0.0000,@MaxPerMatchv1=0.0000,@MinBetv2=0.0000,@MaxBetv2=0.0000,@MaxPerMatchv2=0.0000
,@MinBetv3=0.0000,@MaxBetv3=0.0000,@MaxPerMatchv3=0.0000,@MinBetv5=0.0000,@MaxBetv5=0.0000,@MaxPerMatchv5=0.0000,@MinBetv8=0.0000
,@MaxBetv8=0.0000,@MaxPerMatchv8=0.0000,@MinBetv10=0.0000,@MaxBetv10=0.0000,@MaxPerMatchv10=0.0000,@MinBetv11=0.0000,@MaxBetv11=0.0000
,@MaxPerMatchv11=0.0000,@MinBetv44=0.0000,@MaxBetv44=0.0000,@MaxPerMatchv44=0.0000,@MinBetv99=0.0000,@MaxBetv99=0.0000
,@MaxPerMatchv99=0.0000,@MinBetv99mp=0.0000,@MaxBetv99mp=0.0000,@MaxPerMatchv99mp=0.0000,@MinBetv161=0.0000,@MaxBetv161=0.0000
,@MaxPerMatchv161=0.0000,@MaxPerBallv161=0.0000,@v1apositiontaking_1=0.0000,@v1apositiontaking_2=0.0000
,@v1apositiontaking_3=0.0000,@v1apositiontaking_4=0.0000,@v1apositiontaking_5=0.0000,@v1apositiontaking_6=0.0000
,@v1apositiontaking_7=0.0000,@v1apositiontaking_8=0.0000,@v1apositiontaking_9=0.0000,@v1apositiontaking_10=0.0000
,@v1alivepositiontaking_1=0.0000,@v1alivepositiontaking_3=0.0000,@v1alivepositiontaking_7=0.0000
,@v1alivepositiontaking_8=0.0000,@v2apositiontaking_1=0.0000,@v2apositiontaking_2=0.0000
,@v2apositiontaking_3=0.0000,@v2apositiontaking_7=0.0000,@v2apositiontaking_8=0.0000
,@v2apositiontaking_20=0.0000,@v3apositiontaking_1=0.0000,@v3apositiontaking_2=0.0000,@v3apositiontaking_3=0.0000
,@v3apositiontaking_20=0.0000,@v5apositiontaking_1=0.0000,@v5apositiontaking_2=0.0000,@v5apositiontaking_3=0.0000
,@v5apositiontaking_20=0.0000,@v8apositiontaking_1=0.0000,@v8apositiontaking_3=0.0000,@v8apositiontaking_20=0.0000
,@v10apositiontaking_1=0.0000,@v10apositiontaking_2=0.0000,@v10apositiontaking_3=0.0000,@v10apositiontaking_20=0.0000
,@v11apositiontaking_1=0.0000,@v11apositiontaking_20=0.0000,@v44apositiontaking_3=0.0000,@v99apositiontaking_1=0.0000
,@v99apositiontaking_2=0.0000,@v99apositiontaking_3=0.0000,@v99apositiontaking_20=0.0000,@v99apositiontaking_9=0.0000
,@v161apositiontaking_81=0.0000,@v161apositiontaking_83=0.0000,@v161apositiontaking_86=0.0000,@v161apositiontaking_88=0.0000
,@v161alivepositiontaking_85=0.0000,@v161alivepositiontaking_86=0.0000,@v161alivepositiontaking_87=0.0000
,@v161alivepositiontaking_89=0.0000,@v161alivepositiontaking_90=0.0000
,@KenoList='<products><product Bettype="1501" MaxBet="0" MinBet="0" MaxPerMatch="0" IsDisable="1" sPositionTaking="0" mPositionTaking="0" aPositionTaking="0"></product><product Bettype="1503" MaxBet="0" MinBet="0" MaxPerMatch="0" IsDisable="1" sPositionTaking="0" mPositionTaking="0" aPositionTaking="0"></product><product Bettype="1504" MaxBet="0" MinBet="0" MaxPerMatch="0" IsDisable="1" sPositionTaking="0" mPositionTaking="0" aPositionTaking="0"></product><product Bettype="1505" MaxBet="0" MinBet="0" MaxPerMatch="0" IsDisable="1" sPositionTaking="0" mPositionTaking="0" aPositionTaking="0"></product><product Bettype="1507" MaxBet="0" MinBet="0" MaxPerMatch="0" IsDisable="1" sPositionTaking="0" mPositionTaking="0" aPositionTaking="0"></product><product Bettype="1508" MaxBet="0" MinBet="0" MaxPerMatch="0" IsDisable="1" sPositionTaking="0" mPositionTaking="0" aPositionTaking="0"></product><product Bettype="1509" MaxBet="0" MinBet="0" MaxPerMatch="0" IsDisable="1" sPositionTaking="0" mPositionTaking="0" aPositionTaking="0"></product><product Bettype="1511" MaxBet="0" MinBet="0" MaxPerMatch="0" IsDisable="1" sPositionTaking="0" mPositionTaking="0" aPositionTaking="0"></product><product Bettype="1513" MaxBet="0" MinBet="0" MaxPerMatch="0" IsDisable="1" sPositionTaking="0" mPositionTaking="0" aPositionTaking="0"></product><product Bettype="1514" MaxBet="0" MinBet="0" MaxPerMatch="0" IsDisable="1" sPositionTaking="0" mPositionTaking="0" aPositionTaking="0"></product></products>'
,@DisableKeno=default,@IP='',@Language=default,@SubAccID=default
,@custid=@_CustID output, @ErrCode=@_ErrCode output,@ErrMsg=@_ErrMsg output


SELECT @_CustID, @_ErrCode, @_ErrMsg