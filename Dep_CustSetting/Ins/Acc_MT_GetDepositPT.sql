USE CustDB
GO
/****** Object:  StoredProcedure [dbo].[Acc_MT_GetKenoPT]    Script Date: 6/12/2015 4:03:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[Acc_MT_GetDepositPT]
    @username  varchar(50),  
    @Sporttype int = 203,
    @Bettype   int,
    @ErrCode   int = 0 output,  
    @ErrMsg    varchar(100) = '' output
AS
 /*
  Created: Winnie
  Date: 20150612
  Task: View PT setting of deposit customer 
  DB: DBCUST/CUSTDB

  Revisions:
  -- 20150917@Winnie: Add AGCasino
  Parameters Explanation:
 */
SET NOCOUNT ON
IF @Sporttype=250
SELECT @Bettype=1801
DECLARE @tmp_Bettype TABLE (TypeID INT, TypeNamee NVARCHAR(50))	
declare @roleid int,
        @custid int,
        @srecommend int,
        @mrecommend int,
        @recommend int,
        @SAg varchar(50),
        @MAg varchar(50),
        @Ag varchar(50),
		@sportname varchar(50),
        @typename varchar(50),
		@s4 smallmoney, @m4 smallmoney, @a4 smallmoney, @n4 smallmoney, @l4 smallmoney,
        @s3 smallmoney, @m3 smallmoney, @a3 smallmoney, @n3 smallmoney, @l3 smallmoney,
        @s2 smallmoney ,@m2 smallmoney, @a2 smallmoney, @n2 smallmoney, @l2 smallmoney,
        @s1 smallmoney, @m1 smallmoney, @a1 smallmoney, @n1 smallmoney, @l1 smallmoney

	BEGIN TRY		
		SELECT @sportname=sportname FROM DBAGE.bodb02.dbo.Sports WITH (NOLOCK) WHERE Sporttype=@Sporttype
	END TRY
	BEGIN CATCH
		SELECT @sportname=sportname FROM DBAGE.bodb02.dbo.Sports WITH (NOLOCK) WHERE Sporttype=@Sporttype
	END CATCH

	BEGIN TRY			
		INSERT INTO @tmp_Bettype (TypeID, TypeNamee)
		SELECT TypeID, TypeNamee FROM DBAGE.bodb02.dbo.Bettype WITH (NOLOCK)
	END TRY
	BEGIN CATCH		
		INSERT INTO @tmp_Bettype (TypeID, TypeNamee)
		SELECT TypeID, TypeNamee FROM DBTXN.bodb02.dbo.Bettype WITH (NOLOCK)
	END CATCH

	
select @custid = p.custid,      
       @roleid = p.roleid,
       @srecommend = p.srecommend,
       @mrecommend = p.mrecommend,
       @recommend = p.recommend,
       @SAg = s.username,
       @MAg = m.username,
       @Ag = a.username
       
  from CustInfo p WITH(NOLOCK)
  left join CustInfo a with(nolock) on p.recommend = a.custid
  left join CustInfo m with(nolock) on p.mrecommend = m.custid
  left join CustInfo s with(nolock) on p.srecommend = s.custid  
 where p.username = @username

if @@rowcount = 0
begin
    select @ErrCode = 101, @ErrMsg ='Invalid UserName!'
    return
end

select @custid CustID,
       @username UserName,
       @roleid RoleID,      
       @srecommend SAgID,
       @mrecommend MAgID,
       @recommend AgID,
       @SAg SAg,
       @MAg MAg,
       @Ag Ag
IF @Bettype!=0
BEGIN
	SELECT @typename=typenamee FROM @tmp_Bettype WHERE TypeID=@Bettype
 SELECT
 @s4=su.[spositiontaking],@m4=su.[mpositiontaking],@a4=su.[apositiontaking],@n4=0 ,@l4=p.[MaxPositiontaking]
 FROM Dep_CustSettingGame  su WITH(NOLOCK) 
 LEFT JOIN ProductGlobalSetting p WITH(NOLOCK) ON su.sporttype=p.sporttype AND su.bettype=p.bettype AND p.[IsDep]=1
 WHERE su.SportType=@Sporttype AND su.bettype=@Bettype AND custid=@srecommend

 SELECT 
 @s3=ma.[spositiontaking],@m3=ma.[mpositiontaking],@a3=ma.[apositiontaking],@n3=0 ,@l3=su.[spositiontaking] 
 FROM Dep_CustSettingGame  ma WITH(NOLOCK) 
 LEFT JOIN Dep_CustSettingGame su WITH(NOLOCK) ON ma.sporttype=su.sporttype AND ma.bettype=su.bettype AND su.Custid=@srecommend
 WHERE ma.SportType=@Sporttype AND ma.bettype=@Bettype AND ma.custid=@mrecommend

 SELECT
 @s2=ag.[spositiontaking],@m2=ag.[mpositiontaking],@a2=ag.[apositiontaking],@n2=0,@l2=ma.[mpositiontaking] 
 FROM Dep_CustSettingGame  ag WITH(NOLOCK) 
 LEFT JOIN Dep_CustSettingGame ma WITH(NOLOCK) ON ag.sporttype=ma.sporttype AND ag.bettype=ma.bettype AND ma.Custid=@mrecommend
 WHERE ag.SportType=@Sporttype AND ag.bettype=@Bettype AND ag.custid=@recommend

 SELECT
 @s1=c.[spositiontaking],@m1=c.[mpositiontaking],@a1=c.[apositiontaking],@n1=0 ,@l1=ag.[apositiontaking]
 FROM Dep_CustSettingGame  c WITH(NOLOCK) 
 LEFT JOIN Dep_CustSettingGame ag WITH(NOLOCK) ON c.sporttype=ag.sporttype AND c.bettype=ag.bettype AND ag.Custid=@recommend
 WHERE c.SportType=@Sporttype AND c.bettype=@Bettype AND c.custid=@CustId AND @roleid = 1

   select @sporttype AS sporttype, @bettype AS bettype, @sportname AS sportname, @typename AS typename,
                @s4 AS s4, @m4 AS m4, @a4 As a4, @n4 AS n4, @l4 As l4,
                @s3 AS s3, @m3 AS m3, @a3 AS a3, @n3 AS n3, @l3 As l3,
                @s2 As s2, @m2 As m2, @a2 As a2, @n2 AS n2, @l2 As l2,
                @s1 As s1, @m1 AS m1, @a1 AS a1, @n1 AS n1, @l1 As l1 
END
ELSE -- bettype=0
BEGIN
SELECT @Bettype=2001
SELECT @typename=typenamee FROM @tmp_Bettype WHERE TypeID=@Bettype
 SELECT 
 @s4=su.[spositiontaking],@m4=su.[mpositiontaking],@a4=su.[apositiontaking],@n4=0 ,@l4=p.[MaxPositiontaking]
 FROM Dep_CustSettingGame  su WITH(NOLOCK) 
 LEFT JOIN ProductGlobalSetting p WITH(NOLOCK) ON su.sporttype=p.sporttype AND su.bettype=p.bettype AND p.[IsDep]=1
 WHERE su.SportType=@Sporttype AND su.bettype=@Bettype AND custid=@srecommend

 SELECT 
 @s3=ma.[spositiontaking],@m3=ma.[mpositiontaking],@a3=ma.[apositiontaking],@n3=0 ,@l3=su.[spositiontaking] 
 FROM Dep_CustSettingGame  ma WITH(NOLOCK) 
 LEFT JOIN Dep_CustSettingGame su WITH(NOLOCK) ON ma.sporttype=su.sporttype AND ma.bettype=su.bettype AND su.Custid=@srecommend
 WHERE ma.SportType=@Sporttype AND ma.bettype=@Bettype AND ma.custid=@mrecommend

 SELECT
 @s2=ag.[spositiontaking],@m2=ag.[mpositiontaking],@a2=ag.[apositiontaking],@n2=0,@l2=ma.[mpositiontaking] 
 FROM Dep_CustSettingGame  ag WITH(NOLOCK) 
 LEFT JOIN Dep_CustSettingGame ma WITH(NOLOCK) ON ag.sporttype=ma.sporttype AND ag.bettype=ma.bettype AND ma.Custid=@mrecommend
 WHERE ag.SportType=@Sporttype AND ag.bettype=@Bettype AND ag.custid=@recommend

 SELECT
 @s1=c.[spositiontaking],@m1=c.[mpositiontaking],@a1=c.[apositiontaking],@n1=0 ,@l1=ag.[apositiontaking]
 FROM Dep_CustSettingGame  c WITH(NOLOCK) 
 LEFT JOIN Dep_CustSettingGame ag WITH(NOLOCK) ON c.sporttype=ag.sporttype AND c.bettype=ag.bettype AND ag.Custid=@recommend
 WHERE c.SportType=@Sporttype AND c.bettype=@Bettype AND c.custid=@CustId AND @roleid = 1

   select @sporttype AS sporttype, @bettype AS bettype, @sportname AS sportname, @typename AS typename,
                @s4 AS s4, @m4 AS m4, @a4 As a4, @n4 AS n4, @l4 As l4,
                @s3 AS s3, @m3 AS m3, @a3 AS a3, @n3 AS n3, @l3 As l3,
                @s2 As s2, @m2 As m2, @a2 As a2, @n2 AS n2, @l2 As l2,
                @s1 As s1, @m1 AS m1, @a1 AS a1, @n1 AS n1, @l1 As l1 INTO #temp

SELECT @Bettype=2005
SELECT @typename=typenamee FROM @tmp_Bettype WHERE TypeID=@Bettype
 SELECT 
 @s4=su.[spositiontaking],@m4=su.[mpositiontaking],@a4=su.[apositiontaking],@n4=0 ,@l4=p.[MaxPositiontaking]
 FROM Dep_CustSettingGame  su WITH(NOLOCK) 
 LEFT JOIN ProductGlobalSetting p WITH(NOLOCK) ON su.sporttype=p.sporttype AND su.bettype=p.bettype AND p.[IsDep]=1
 WHERE su.SportType=@Sporttype AND su.bettype=@Bettype AND custid=@srecommend

 SELECT 
 @s3=ma.[spositiontaking],@m3=ma.[mpositiontaking],@a3=ma.[apositiontaking],@n3=0 ,@l3=su.[spositiontaking] 
 FROM Dep_CustSettingGame  ma WITH(NOLOCK) 
 LEFT JOIN Dep_CustSettingGame su WITH(NOLOCK) ON ma.sporttype=su.sporttype AND ma.bettype=su.bettype AND su.Custid=@srecommend
 WHERE ma.SportType=@Sporttype AND ma.bettype=@Bettype AND ma.custid=@mrecommend

 SELECT
 @s2=ag.[spositiontaking],@m2=ag.[mpositiontaking],@a2=ag.[apositiontaking],@n2=0,@l2=ma.[mpositiontaking] 
 FROM Dep_CustSettingGame  ag WITH(NOLOCK) 
 LEFT JOIN Dep_CustSettingGame ma WITH(NOLOCK) ON ag.sporttype=ma.sporttype AND ag.bettype=ma.bettype AND ma.Custid=@mrecommend
 WHERE ag.SportType=@Sporttype AND ag.bettype=@Bettype AND ag.custid=@recommend

 SELECT
 @s1=c.[spositiontaking],@m1=c.[mpositiontaking],@a1=c.[apositiontaking],@n1=0 ,@l1=ag.[apositiontaking]
 FROM Dep_CustSettingGame  c WITH(NOLOCK) 
 LEFT JOIN Dep_CustSettingGame ag WITH(NOLOCK) ON c.sporttype=ag.sporttype AND c.bettype=ag.bettype AND ag.Custid=@recommend
 WHERE c.SportType=@Sporttype AND c.bettype=@Bettype AND c.custid=@CustId AND @roleid = 1

	INSERT INTO #temp
   select @sporttype AS sporttype, @bettype AS bettype, @sportname AS sportname, @typename AS typename,
                @s4 AS s4, @m4 AS m4, @a4 As a4, @n4 AS n4, @l4 As l4,
                @s3 AS s3, @m3 AS m3, @a3 AS a3, @n3 AS n3, @l3 As l3,
                @s2 As s2, @m2 As m2, @a2 As a2, @n2 AS n2, @l2 As l2,
                @s1 As s1, @m1 AS m1, @a1 AS a1, @n1 AS n1, @l1 As l1 
	SELECT * FROM #temp
END
GO

GRANT EXECUTE ON [dbo].[Acc_MT_GetDepositPT] TO [bodbAdminNet] AS [dbo]
GO

GRANT EXECUTE ON [dbo].[Acc_MT_GetDepositPT] TO [bodbDownlineNet] AS [dbo]
GO

GRANT EXECUTE ON [dbo].[Acc_MT_GetDepositPT] TO [bodbDownlineNetView] AS [dbo]
GO

GRANT EXECUTE ON [dbo].[Acc_MT_GetDepositPT] TO [bodbExtAccNet] AS [dbo]
GO

GRANT VIEW DEFINITION ON [dbo].[Acc_MT_GetDepositPT] TO [vnteam] AS [dbo]
GO

