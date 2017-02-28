/****** Object:  Stored Procedure dbo.Acc_AGC_UpdSuperStatus    Script Date: 8/28/2014 3:01:31 PM ******/  
ALTER PROCEDURE [dbo].[Acc_AGC_UpdSuperStatus]  
 @CustID    INT,  
 @IsEnableAG   BIT,  
 @ApplyToMember  BIT    = 0,  
 @UserID    INT,  
 @IP     VARCHAR(40),  
 @Langkey   VARCHAR(10)  = 'en-US',  
 @ErrCode   INT    = 0  OUTPUT,  
 @ErrMsg    VARCHAR(8000) = '' OUTPUT  
AS  
/*  
 Created: 20140813@Victor  
 Task: Update AG Casino product status of super  
 DB: DBTXN/CustDB  
 Original:  
 Revisions: 
 --20161025@Winnie:  AG Settings - Allow users to enable AG status for SMA at the same time RedmineID:#66222
 Param's Explanation:  
*/  
BEGIN  
 SET NOCOUNT ON  
   
 DECLARE @startRun   DATETIME  
   ,@endRun   DATETIME  
   ,@duration   INT  
   ,@LogSPData   VARCHAR(MAX)  
   ,@TrackingValue2 VARCHAR(MAX)  
   ,@IsEnabled_Old  BIT = 0  
 SET @startRun = GETDATE()  
  
 SELECT @IsEnabled_Old = ISNULL(IsEnabled, 0)  
 FROM dbo.Dep_SuperSetting_AGCasino WITH (NOLOCK)   
 WHERE CustID = @CustID  
  
 -- Update Status for Super  
 IF (EXISTS(SELECT 1 FROM dbo.Dep_SuperSetting_AGCasino WITH (NOLOCK) WHERE CustID = @CustID))  
 BEGIN  
  UPDATE a
  SET IsEnabled = @IsEnableAG  
  FROM 
  dbo.Dep_SuperSetting_AGCasino a WITH(ROWLOCK,UPDLOCK)  
  INNER JOIN Customer b WITH(NOLOCK) ON a.CustID=b.custid
  WHERE b.srecommend = @CustID  
 END  
 ELSE  
 BEGIN  
  INSERT INTO dbo.Dep_SuperSetting_AGCasino (CustID, CheckedGroup, DefaultGroup, IsEnabled)    
  SELECT  b.CustID, '', '', @IsEnableAG 
  FROM Customer b WITH(NOLOCK) 
  WHERE b.srecommend = @CustID  
  AND roleid IN (2,3,4)
  AND b.Username NOT LIKE '%' + b.site + '%' + 'ACC%'
  AND NOT EXISTS(SELECT TOP 1 1 FROM  dbo.Dep_SuperSetting_AGCasino a WITH(NOLOCK) WHERE a.CustID=b.custid )
 END  
  
 IF @IsEnableAG = 0  
  SET @ApplyToMember = 1  
  
 -- Update Status for all downline members  
 IF (@ApplyToMember = 1)  
 BEGIN  
  DECLARE @CurrRow INT = 1  
    ,@RowPerBatch INT = 10000  
    ,@RowCount INT = 0  
  CREATE TABLE #CustList (RowNo INT IDENTITY(1,1), CustID INT)  
    
  INSERT INTO #CustList (CustID)  
  SELECT CustID FROM Customer WITH (NOLOCK) WHERE srecommend = @CustID AND roleid = 1  
  
  SELECT @RowCount = @@rowcount  
  
  WHILE (@CurrRow <= @RowCount)  
  BEGIN  
   UPDATE dbo.Dep_CustSetting_AGCasino WITH (ROWLOCK, UPDLOCK)  
   SET IsEnabled = @IsEnableAG  
   WHERE CustID IN (SELECT CustID FROM #CustList WHERE RowNo BETWEEN @CurrRow AND (@CurrRow + @RowPerBatch - 1))  
  
   INSERT INTO dbo.Dep_CustSetting_AGCasino (CustID, AGGroup, IsEnabled)  
   SELECT c.CustID, '', @IsEnableAG  
   FROM #CustList c  
   WHERE NOT EXISTS(SELECT 1 FROM dbo.Dep_CustSetting_AGCasino cs WITH (NOLOCK) WHERE cs.CustID = c.CustID)  
    AND RowNo BETWEEN @CurrRow AND (@CurrRow + @RowPerBatch - 1)  
  
   SELECT @CurrRow = @CurrRow + @RowPerBatch  
   WAITFOR DELAY '00:00:00.300'  
  END  
  DROP TABLE #CustList  
 END  
  
 -- Write log  
 SET @endRun = GETDATE()  
 SET @duration  = DATEDIFF(MILLISECOND,@startRun,@endRun)  
  
 SELECT @LogSPData = '<Acc_AGC_UpdSuperStatus CustID="'+ COALESCE(CAST(@CustID as VARCHAR(50)),SPACE(1)) + '" ' +  
      'IsEnableAG="'+ COALESCE(CAST(@IsEnableAG as VARCHAR(1)),SPACE(1)) + '" ' +  
      'ApplyToMember="'+ COALESCE(CAST(@ApplyToMember as VARCHAR(1)),SPACE(1)) + '" ' +  
      'UserID="'+ COALESCE(CAST(@UserID as VARCHAR(50)),SPACE(1)) + '" ' +  
      'IP="'+ COALESCE(CAST(@IP as VARCHAR(40)),SPACE(1)) + '" ' +  
      'ErrCode="'+ COALESCE(CAST(@ErrCode as VARCHAR(50)),SPACE(1)) + '" ' +  
      'ErrMsg="'+ COALESCE(CAST(@ErrMsg as VARCHAR(8000)),SPACE(1))+ '" />'  
  
 SELECT @TrackingValue2 = '<Acc_AGC_UpdSuperStatus CustID="'+ COALESCE(CAST(@CustID as VARCHAR(50)),SPACE(1)) + '" ' +  
      'IsEnableAG="'+ COALESCE(CAST(@IsEnabled_Old as VARCHAR(1)),SPACE(1)) + '" ' +  
      'ApplyToMember=""' +  
      'UserID="'+ COALESCE(CAST(@UserID as VARCHAR(50)),SPACE(1)) + '" ' +  
      'IP="'+ COALESCE(CAST(@IP as VARCHAR(40)),SPACE(1)) + '" ' +  
      'ErrCode="'+ COALESCE(CAST(@ErrCode as VARCHAR(50)),SPACE(1)) + '" ' +  
      'ErrMsg="'+ COALESCE(CAST(@ErrMsg as VARCHAR(8000)),SPACE(1))+ '" />'  
   
 EXEC DBLOG.bodb_CustomerLog.dbo.WriteLog_UserLog_RunSP   
    @UserID = @UserID,  
    @CustID = @CustID,  
    @ActionID = 2210,  
    @TrackingValue = @LogSPData,  
    @TrackingValue2 = @TrackingValue2,  
    @duration = @duration  
   
END

GO
GRANT EXECUTE ON [dbo].Acc_AGC_UpdSuperStatus TO [bodbAdminNet] AS [dbo]