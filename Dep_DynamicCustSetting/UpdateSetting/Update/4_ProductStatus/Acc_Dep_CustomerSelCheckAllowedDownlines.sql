/*<info serverAlias="DBCUST-CUSTDB" executers="wsv_nap" viewers="" isFunction="0"></info>*/
CREATE PROCEDURE [dbo].[Acc_Dep_CustomerSelCheckAllowedDownlines]    
 @custid   INT = 0     
 ,@IsSetting TINYINT = 0 
 ,@Language  VARCHAR(2) = 'E'    
 ,@ErrCode  INT = 0 OUTPUT    
 ,@ErrMsg  NVARCHAR(200) = '' OUTPUT      
AS      
/*    
Created by: Winnie  
Date: 2018-07-27  
Task : Check Allowed downlines during peak hour at weekend for Licensee  DCS
DB: DBCUST/CUSTDB          
Original SP:           
  
Revisions:         
  -20180801@Winnie: Create SP
  - 20200114@Johnson: set threshold = 500k for normal [redmine: #126572]
  - 20230722@Winfred: NAP LM - Enhance performance when adjusting betlimit for big licensees  [redmine:#195079]
Param's Explanation: 
	+ @IsSetting: 1: Bet Limit , 0 : Other 
   
*/    
    
BEGIN      
 SET NOCOUNT ON    
     
 DECLARE @LimitDownlinesMin INT,   --Peak hours  
  @LimitDownlinesMax INT,    -- Normal   
  @LimitDownlines INT,    
  @TotalDownlines INT,
  @RoleID		  INT   
     
 SET @LimitDownlinesMin = 40000   
 SET @LimitDownlinesMax = 500000

 --GET TOTALDOWNLINE    
 SET @TotalDownlines=1    

 SELECT @RoleID=RoleID FROM Customer WITH(NOLOCK) WHERE Custid=@custid

 IF @IsSetting <> 1
 BEGIN
	 IF(@RoleID=4)     
		 SELECT  @TotalDownlines = count(1)     
		 FROM Custinfo WITH (NOLOCK)    
		 WHERE srecommend=@custID     
 
	 IF(@RoleID=2)     
		 SELECT  @TotalDownlines = count(1)     
		 FROM Custinfo WITH (NOLOCK)    
		 WHERE recommend=@custID     
 END   
 ELSE
 BEGIN
	IF(@RoleID=4)     
		 SELECT  @TotalDownlines = count(1)     
		 FROM Custinfo t WITH (NOLOCK)  
			CROSS APPLY (SELECT TOP 1 CustID FROM Dep_CustSettingMode cm WHERE custid = t.CustID AND IsGroupedBetLimit = 0) q  
		 WHERE srecommend=@custID AND roleid = 1    
 
	 IF(@RoleID=2)     
		 SELECT  @TotalDownlines = count(1)     
		 FROM Custinfo t WITH (NOLOCK)   
			CROSS APPLY (SELECT TOP 1 CustID FROM Dep_CustSettingMode cm WHERE custid = t.CustID AND IsGroupedBetLimit = 0) q 
		 WHERE recommend=@custID AND roleid = 1    
 END
 SELECT  @LimitDownlines = CASE  WHEN  datename(weekday, getdate()) in ('Saturday','Sunday' ) and 
           datepart(hour, getdate()) between 7 and  14 --Weekend's peak hour, from 7PM - 2AM (GMT+8)    
          THEN  @LimitDownlinesMin    
         ELSE @LimitDownlinesMax  END     
     
 IF @TotalDownlines >  @LimitDownlines    
 BEGIN         
  SELECT @ErrMsg= CASE @Language WHEN 'E' THEN 'This function is not available during peak hour since it might affect the performance of the whole system. Please contact IT for further assistance.'  
          ELSE [dbo].[f_Get_MsgNamebyMsgID](90010,@Language) END  
    ,@ErrCode = 113         
 END     
END 
GO