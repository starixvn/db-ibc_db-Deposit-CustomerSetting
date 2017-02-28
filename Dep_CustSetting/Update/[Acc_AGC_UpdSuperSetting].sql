USE [CustDB]
GO
/****** Object:  StoredProcedure [dbo].[Acc_AGC_UpdSuperSetting]    Script Date: 09/16/2015 04:45:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****** Object:  Stored Procedure dbo.Acc_AGC_UpdSuperSetting    Script Date: 8/28/2014 3:01:31 PM ******/
ALTER PROCEDURE	[dbo].[Acc_AGC_UpdSuperSetting]
	@CustID				INT,
	@CheckedGroup		VARCHAR(500),
	@DeletedGroup		VARCHAR(500)='',	
	@DefaultGroup		VARCHAR(20),
	@ApplyGroupToMember	VARCHAR(20)		= '',
	@UserID				INT,
	@IP					VARCHAR(40), 
	@Langkey			VARCHAR(10)		= 'en-US',
	@ErrCode			INT				= 0		OUTPUT,
	@ErrMsg				VARCHAR(8000)	= ''	OUTPUT,	
	@v250_1801PT		SMALLMONEY
AS
/*
	Created: 20140813@Victor
	Task: Update AG Casino product setting of super
	DB: DBTXN/CustDB
	Original:
	Revisions:
	- 20150916@Winnie: Add AGCasino
	Param's Explanation:
*/
BEGIN
	SET NOCOUNT ON
	
	DECLARE @startRun			DATETIME
			,@endRun			DATETIME
			,@duration			INT
			,@LogSPData			VARCHAR(MAX)
			,@TrackingValue2	VARCHAR(MAX)
			,@CheckedGroup_Old	VARCHAR(500) = ''
			,@DefaultGroup_Old	VARCHAR(20) = ''
			,@RoleId			INT
			,@UplineId			INT
			,@v250_1801PT_Old	SMALLMONEY
	SET @startRun = GETDATE()
	CREATE TABLE #DownlineList (CustID INT,RoleId INT)		


	SELECT TOP 1 @RoleId=RoleId FROM Customer(NOLOCK) WHERE custid=@Custid
	IF (@RoleId=4)
	BEGIN
			INSERT INTO #DownlineList  (CustID,RoleId)
			SELECT c.CustID ,c.roleid
			FROM Customer c WITH (NOLOCK) 
			INNER JOIN Dep_SuperSetting_AGCasino d WITH (NOLOCK) ON c.custid=d.CustID
			AND c.srecommend=@CustId AND c.custid<>@CustId

			SELECT @CheckedGroup_Old	=	ISNULL(CheckedGroup, '')
			,@DefaultGroup_Old		=	ISNULL(DefaultGroup, '')
			FROM dbo.Dep_SuperSetting_AGCasino WITH (NOLOCK) 
			WHERE CustID = @CustID
	END
	ELSE IF(@RoleId=3)
	BEGIN
	INSERT INTO #DownlineList (CustID,RoleId)
			SELECT c.CustID ,c.roleid
			FROM Customer c WITH (NOLOCK) 
			INNER JOIN Dep_SuperSetting_AGCasino d WITH (NOLOCK) ON c.custid=d.CustID
			AND c.mrecommend=@CustId AND c.custid<>@CustId

			SELECT TOP 1 @UplineId=srecommend FROM Customer(NOLOCK) WHERE custid=@Custid

			SELECT @CheckedGroup_Old	=	ISNULL(CheckedGroup, '')
			,@DefaultGroup_Old		=	ISNULL(DefaultGroup, '')
			FROM dbo.Dep_SuperSetting_AGCasino WITH (NOLOCK) 
			WHERE CustID = @CustID
	END
	ELSE IF(@RoleId=2)
	BEGIN
			SELECT TOP 1 @UplineId=mrecommend FROM Customer(NOLOCK) WHERE custid=@Custid

			SELECT @CheckedGroup_Old	=	ISNULL(CheckedGroup, '')
			,@DefaultGroup_Old		=	ISNULL(DefaultGroup, '')
			FROM dbo.Dep_SuperSetting_AGCasino WITH (NOLOCK) 
			WHERE CustID = @CustID
	END
	ELSE IF(@RoleId=1)
	BEGIN
			SELECT TOP 1 @UplineId=recommend FROM Customer(NOLOCK) WHERE custid=@Custid

			SELECT @CheckedGroup_Old	=	AGGroup
			,@DefaultGroup_Old		=	''
			FROM dbo.Dep_CustSetting_AGCasino WITH (NOLOCK) 
			WHERE CustID = @CustID
	END
	


	IF(@CheckedGroup <>'' AND @CheckedGroup_Old<>@CheckedGroup)
	BEGIN
	CREATE TABLE #tmpAddedGroup (AddGroup varchar(1))	
				INSERT INTO #tmpAddedGroup (AddGroup)
				SELECT val FROM [dbo].[strSplit_str](@CheckedGroup,',')
				DECLARE @varAddGroup varchar(1)
					WHILE EXISTS(SELECT TOP 1 1 FROM #tmpAddedGroup)
					BEGIN
					SELECT TOP 1 @varAddGroup=AddGroup FROM #tmpAddedGroup
					IF charindex(@varAddGroup,(SELECT TOP 1 CheckedGroup FROM Dep_SuperSetting_AGCasino(NOLOCK) WHERE Custid=@UplineId)) =0
					BEGIN
					SELECT @ErrCode=10032
					SELECT @ErrMsg='Invalid data because it has changed by some other people. Please refresh the page'
					RETURN
					END
					DELETE FROM #tmpAddedGroup WHERE AddGroup=@varAddGroup
					END
	END

	IF(@RoleId<>1)
	BEGIN
		-- Update Setting for Super
		IF (EXISTS(SELECT 1 FROM dbo.Dep_SuperSetting_AGCasino WITH (NOLOCK) WHERE CustID = @CustID))
		BEGIN
		
			IF(@CheckedGroup_Old<>@CheckedGroup)
			BEGIN		
			
			UPDATE dbo.Dep_SuperSetting_AGCasino WITH(ROWLOCK, UPDLOCK)
			SET CheckedGroup = @CheckedGroup
			WHERE CustID = @CustID

			IF(LEN( @DeletedGroup)=1)
			BEGIN
			UPDATE a WITH(ROWLOCK, UPDLOCK)
			SET a.CheckedGroup= CASE WHEN LEFT(
										(REPLACE(a.CheckedGroup,@DeletedGroup,''))
										,1)=',' THEN
			SUBSTRING(
			REPLACE((REPLACE(a.CheckedGroup,@DeletedGroup,'')),',,',',')
			,2,
			LEN(REPLACE(a.CheckedGroup,@DeletedGroup,'')))

			ELSE REPLACE((REPLACE(a.CheckedGroup,@DeletedGroup,'')),',,',',') END
			FROM Dep_SuperSetting_AGCasino a
			INNER JOIN #DownlineList b ON a.CustID=b.CustID
			END
			ELSE IF(LEN( @DeletedGroup)>1)
			BEGIN
				CREATE TABLE #tmpDeletedGroup (delGroup varchar(1))	
				INSERT INTO #tmpDeletedGroup (delGroup)
				SELECT val FROM [dbo].[strSplit_str](@DeletedGroup,',')
				DECLARE @vardelGroup varchar(1)
					WHILE EXISTS(SELECT TOP 1 1 FROM #tmpDeletedGroup)
					BEGIN
					SELECT TOP 1 @vardelGroup=delGroup FROM #tmpDeletedGroup
					UPDATE a WITH(ROWLOCK, UPDLOCK)
					SET a.CheckedGroup= CASE WHEN LEFT(
												(REPLACE(a.CheckedGroup,@vardelGroup,''))
												,1)=',' THEN
					SUBSTRING(
					REPLACE((REPLACE(a.CheckedGroup,@vardelGroup,'')),',,',',')
					,2,
					LEN(REPLACE(a.CheckedGroup,@vardelGroup,'')))

					ELSE REPLACE((REPLACE(a.CheckedGroup,@vardelGroup,'')),',,',',') END
					FROM Dep_SuperSetting_AGCasino a
					INNER JOIN #DownlineList b ON a.CustID=b.CustID
					DELETE FROM #tmpDeletedGroup WHERE delGroup=@vardelGroup
					END
			END
		
			END

				-- update @DefaultGroup
		
			IF(@RoleId=2 AND @DefaultGroup_Old<>@DefaultGroup )
			BEGIN		
			UPDATE dbo.Dep_SuperSetting_AGCasino WITH(ROWLOCK, UPDLOCK)
			SET DefaultGroup = @DefaultGroup
			WHERE CustID = @CustID
			END
			ELSE
			BEGIN
			UPDATE a WITH(ROWLOCK, UPDLOCK)
			SET a.DefaultGroup= LEFT(CheckedGroup,1)
			FROM Dep_SuperSetting_AGCasino a
			INNER JOIN #DownlineList b ON a.CustID=b.CustID
			WHERE b.RoleId=2 AND @DeletedGroup LIKE '%'+ a.DefaultGroup +'%'
			END
		END
		ELSE
		BEGIN
			INSERT INTO dbo.Dep_SuperSetting_AGCasino (CustID, CheckedGroup, DefaultGroup, IsEnabled)
			VALUES (@CustID, @CheckedGroup, @DefaultGroup, 0)
		END

		-- Update Setting for all downline members (that has no setting)
		IF LEN(@ApplyGroupToMember ) > 0 AND @RoleId=2		
		BEGIN
			
			DECLARE @CurrRow INT = 1
					,@RowPerBatch INT = 10000
					,@RowCount INT = 0
			CREATE TABLE #CustList (RowNo INT IDENTITY(1,1), CustID INT)
		
			INSERT INTO #CustList (CustID)
			SELECT CustID 
			FROM Customer c WITH (NOLOCK) 
			WHERE recommend = @CustID AND roleid = 1
				--AND NOT EXISTS(SELECT 1 FROM dbo.Dep_CustSetting_AGCasino cs WITH (NOLOCK) WHERE cs.CustID = c.CustID AND LEN(cs.AGGroup) > 0)
			
			SELECT @RowCount = @@rowcount

			WHILE (@CurrRow <= @RowCount)
			BEGIN

				MERGE dbo.Dep_CustSetting_AGCasino AS dest
				USING (	SELECT CustID 
						FROM #CustList 
						WHERE RowNo BETWEEN @CurrRow AND (@CurrRow + @RowPerBatch - 1)
					  ) AS src (CustID)
				ON (dest.CustID = src.CustID)
				WHEN MATCHED THEN
					UPDATE SET dest.AGGroup = @ApplyGroupToMember
				WHEN NOT MATCHED THEN
					INSERT (CustID, AGGroup, IsEnabled)
					VALUES (src.CustID, @ApplyGroupToMember, 0);
			
				SELECT @CurrRow = @CurrRow + @RowPerBatch
				WAITFOR DELAY '00:00:00.300'
			END
			DROP TABLE #CustList
		END
	END
	ELSE IF @CheckedGroup_Old <>@CheckedGroup
	BEGIN
	--update member here
	UPDATE dbo.Dep_CustSetting_AGCasino WITH (ROWLOCK, UPDLOCK)
	SET AGGroup = @CheckedGroup
	WHERE CustID=@Custid
	
	END

	SELECT @v250_1801PT_Old=
	CASE WHEN @RoleId IN(1,2) THEN	apositiontaking 
	WHEN @RoleId =3 THEN	mpositiontaking 
	WHEN @RoleId =4 THEN	spositiontaking END
	FROM Dep_CustSettingGame(NOLOCK) WHERE CustID=@Custid AND Sporttype=250 AND Bettype=1801

	IF @v250_1801PT_Old<>@v250_1801PT OR @v250_1801PT_Old IS NULL	
	BEGIN
	EXEC Acc_Dep_CustomerUpdSetting
	@CustID				=@CustID,
	@SportType			=250,	
	@v250_1801PT		=@v250_1801PT,	
	@UserID				=@UserID,
	@IP					=@IP,
	@Langkey			=@Langkey,
	@ErrCode			=@ErrCode OUTPUT,
	@ErrMsg				=@ErrMsg  OUTPUT
	END
	-- Write log
	SET @endRun = GETDATE()
	SET @duration  = DATEDIFF(MILLISECOND,@startRun,@endRun)

	SELECT @LogSPData = '<Acc_AGC_UpdSuperSetting CustID="'+ COALESCE(CAST(@CustID as VARCHAR(50)),SPACE(1)) + '" ' +
						'CheckedGroup="'+ COALESCE(CAST(@CheckedGroup as VARCHAR(500)),SPACE(1)) + '" ' +
						'DefaultGroup="'+ COALESCE(CAST(@DefaultGroup as VARCHAR(20)),SPACE(1)) + '" ' +
						'ApplyGroupToMember="'+ COALESCE(CAST(@ApplyGroupToMember as VARCHAR(20)),SPACE(1)) + '" ' +
						'UserID="'+ COALESCE(CAST(@UserID as VARCHAR(50)),SPACE(1)) + '" ' +
						'IP="'+ COALESCE(CAST(@IP as VARCHAR(40)),SPACE(1)) + '" ' +
						'ErrCode="'+ COALESCE(CAST(@ErrCode as VARCHAR(50)),SPACE(1)) + '" ' +
						'ErrMsg="'+ COALESCE(CAST(@ErrMsg as VARCHAR(8000)),SPACE(1))+ '" />'

	SELECT @TrackingValue2 = '<Acc_AGC_UpdSuperSetting CustID="'+ COALESCE(CAST(@CustID as VARCHAR(50)),SPACE(1)) + '" ' +
						'CheckedGroup="'+ COALESCE(CAST(@CheckedGroup_Old as VARCHAR(500)),SPACE(1)) + '" ' +
						'DefaultGroup="'+ COALESCE(CAST(@DefaultGroup_Old as VARCHAR(20)),SPACE(1)) + '" ' +
						'ApplyGroupToMember=""' + '" ' +
						'UserID="'+ COALESCE(CAST(@UserID as VARCHAR(50)),SPACE(1)) + '" ' +
						'IP="'+ COALESCE(CAST(@IP as VARCHAR(40)),SPACE(1)) + '" ' +
						'ErrCode="'+ COALESCE(CAST(@ErrCode as VARCHAR(50)),SPACE(1)) + '" ' +
						'ErrMsg="'+ COALESCE(CAST(@ErrMsg as VARCHAR(8000)),SPACE(1))+ '" />'
	
	EXEC DBLOG.bodb_CustomerLog.dbo.WriteLog_UserLog_RunSP 
				@UserID = @UserID,
				@CustID = @CustID,
				@ActionID = 2039,
				@TrackingValue = @LogSPData,
				@TrackingValue2 = @TrackingValue2,
				@duration = @duration
	
END


GO
GRANT EXECUTE ON [dbo].[Acc_AGC_UpdSuperSetting] TO [bodbAdminNet] AS [dbo]