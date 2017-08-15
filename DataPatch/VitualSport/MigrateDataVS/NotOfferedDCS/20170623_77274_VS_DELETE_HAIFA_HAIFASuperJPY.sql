ALTER PROCEDURE [dbo].[Acc_Dep_DynamicCustSetting_09]
 	 @srecommend INT 
	, @max_custid INT 
	, @target VARCHAR(20) 
	
AS
BEGIN
	
	SET NOCOUNT ON
	
	IF (@target = 'REPLICATED' AND @@SERVERNAME = 'DBCUST') RETURN	-- run at all replicated servers
	IF (@target = 'DBCUST' AND @@SERVERNAME <> 'DBCUST') RETURN -- run at DBCUST only
	
	IF (dbo.f_CheckRepTable('Dep_CustSettingMode') = 0
		OR dbo.f_CheckRepTable('Dep_CustPTSetting_Member') = 0
		OR dbo.f_CheckRepTable('Dep_CustPTSetting_Agent') = 0
		OR dbo.f_CheckRepTable('Dep_CustPTGroupSetting_Member') = 0
		
		OR dbo.f_CheckRepTable('Dep_ProductSetting') = 0
		OR dbo.f_CheckRepTable('Dep_ProductSettingDetail') = 0
		OR dbo.f_CheckRepTable('Dep_LicenseeProductSetting') = 0 
		
		OR dbo.f_CheckRepTable('Dep_ProductStatusProfile') = 0 
		OR dbo.f_CheckRepTable('Dep_CustProductStatus') = 0 
	
		OR dbo.f_CheckRepTable('Dep_CustBetSetting_Agent') = 0 
		OR dbo.f_CheckRepTable('Dep_CustBetSetting_Member') = 0 
			
	   )
		RETURN
		
	DELETE Dep_LicenseeProductSetting WHERE CustID = @srecommend AND ProductSettingID IN (9,10,11)

	DELETE A
	FROM Dep_CustPTSetting_Agent A 
		INNER JOIN Custinfo ci WITH (NOLOCK) ON A.CustID = CI.custid
	WHERE ci.srecommend = @srecommend AND a.SportType IN (180,181,182,184,184,185,186,190,191,199)

	DELETE A
	FROM Dep_CustPTGroupSetting_Member A 
		INNER JOIN Custinfo ci WITH (NOLOCK) ON A.AgentID = CI.custid
	WHERE ci.srecommend = @srecommend AND a.SportType IN (180,181,182,184,184,185,186,190,191,199)

	DELETE A
	FROM Dep_CustBetSetting_Agent A 
		INNER JOIN Custinfo ci WITH (NOLOCK) ON A.CustID = CI.custid
	WHERE ci.srecommend = @srecommend AND a.SportType IN (180,181,182,183,184,185,186,190,191,199)


	DELETE A
	FROM Dep_CustBetSetting_Member A 
		INNER JOIN Custinfo ci WITH (NOLOCK) ON A.CustID = CI.custid
	WHERE ci.srecommend = @srecommend AND a.SportType IN (180,181,182,183,184,185,186,190,191,199)


	DELETE A
	FROM Dep_CustSettingMode A 
		INNER JOIN Custinfo ci WITH (NOLOCK) ON A.CustID = CI.custid
	WHERE ci.srecommend = @srecommend 


	DELETE A
	FROM Dep_CustProductStatus A 
		INNER JOIN Custinfo ci WITH (NOLOCK) ON A.CustID = CI.custid
	WHERE ci.srecommend = @srecommend 
END

GO
-- RUN ON DBCUST ONLY 
DECLARE @srecommend INT = 10557007, @max_custid INT = xxx
EXEC dbo.[Acc_Dep_DynamicCustSetting_09] @srecommend = @srecommend,  @max_custid=@max_custid,@target = 'DBCUST'

GO
