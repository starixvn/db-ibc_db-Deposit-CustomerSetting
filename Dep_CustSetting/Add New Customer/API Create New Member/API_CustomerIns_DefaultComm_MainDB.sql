/*<info serverAlias="DBCUST-CustDB" executers="" viewers="" isFunction="0"></info>*/
ALTER PROCEDURE [dbo].[API_CustomerIns_DefaultComm_MainDB](
	 @DefaultComms VARCHAR(MAX)--Json format
	,@Recommend	INT
	,@CustID	INT
	,@ErrCode	INT = 0 OUTPUT
	,@ErrMsg	VARCHAR(2000) = '' OUTPUT
)
AS
/*
	Created: 20240705@Eden  
	Task : First Deposit --> Insert default player comm on Site DB
	DB:  DBCUST-CustDB
	Original sp: 
	
	Revisions: 
		- 20240705@Eden  : Scale out DBCUST - Licensee Customer in GlobCustDB [redmine: #207474]
		- 20240705@Helios  : Scale out DBCUST - Licensee Customer in GlobCustDB - Apply code in house [redmine: #207474] 

	Param's Explanation: 
		@DefaultComms:	[
						{"SportType":1,"BetType":1,"Discount":0.05000000},
						{"SportType":1,"BetType":4,"Discount":0.05000000},
						...
					]

	Examples:
		DECLARE @ErrCode INT = 0, @ErrMsg	VARCHAR(2000) = '' 
			,@DefaultComms  VARCHAR(MAX)  = '[
						{"SportType":1,"BetType":1,"Discount":0.05000000},
						{"SportType":1,"BetType":4,"Discount":0.05000000},
						{"SportType":1,"BetType":5,"Discount":0.05000000},
						{"SportType":1,"BetType":9,"Discount":0.13000000},
						{"SportType":2,"BetType":2,"Discount":0.05000000},
						{"SportType":161,"BetType":81,"Discount":0.12000000},
						{"SportType":165,"BetType":1901,"Discount":0.01000000},
						{"SportType":167,"BetType":7301,"Discount":0.00000000},
						{"SportType":171,"BetType":3801,"Discount":0.00000000},
						{"SportType":172,"BetType":7701,"Discount":0.00000000}
					]'
		EXEC [API_CustomerIns_DefaultComm_MainDB] 
			 @DefaultComms = @DefaultComms
			,@CustID = 123
			,@Recommend = 111
			,@ErrCode	= @ErrCode	OUT
			,@ErrMsg	= @ErrMsg OUT

		SELECT @ErrCode ,@ErrMsg

*/			   				
BEGIN
	SET NOCOUNT ON
	BEGIN TRY
		DECLARE @tblSettingDCS AS TABLE (sporttype SMALLINT,Bettype SMALLINT, Discount DECIMAL(9,8))  

		INSERT INTO @tblSettingDCS(SportType, BetType, Discount)
		SELECT SportType, BetType, Discount
		FROM OPENJSON(@DefaultComms) WITH (
					 SportType SMALLINT  '$.SportType'
					,BetType SMALLINT	'$.BetType'
					,Discount DECIMAL(9,8)  '$.Discount'
				)
		WHERE Discount IS NOT NULL -- Not apply Player comm

		DECLARE @IsGroupedComm BIT 

		SELECT @IsGroupedComm = IsGroupedComm  
		FROM dbo.Dep_CustSettingMode WITH(NOLOCK)  
		WHERE custid = @CustID  

		IF @IsGroupedComm = 1
		BEGIN
			--move to individual setting  
			INSERT INTO dbo.Dep_CustDiscountSetting_Member (
				CustID  
				,SportType  
				,BetType  
				,PlayerDiscount  
				,AgentDiscount  
				,MasterDiscount  
				,SuperDiscount
				,RepUpdateTime
			)  
			SELECT @CustID  
				,grp.SportType  
				,grp.BetType  
				,grp.PlayerDiscount
				,grp.AgentDiscount  
				,grp.MasterDiscount  
				,grp.SuperDiscount  
				,SYSDATETIME ()
			FROM dbo.Dep_CustDiscountGroupSetting_Member grp WITH(NOLOCK)  
				LEFT JOIN dbo.Dep_CustDiscountSetting_Member cs WITH(NOLOCK) 
					ON cs.custid = @custid  
					AND cs.sporttype = grp.sporttype  
					AND cs.bettype = grp.bettype  
			WHERE AgentID = @Recommend  
				AND cs.custid IS NULL 

			UPDATE dbo.Dep_CustSettingMode WITH(UPDLOCK,ROWLOCK)  
			SET 
				  IsGroupedComm = 0  
				, RepUpdateTime = SYSDATETIME ()
			WHERE CustID = @CustID  
		END

		UPDATE c
		SET 
			  c.PlayerDiscount = t.Discount  
			, c.RepUpdateTime = SYSDATETIME ()
		FROM dbo.Dep_CustDiscountSetting_Member c WITH(UPDLOCK,ROWLOCK)  
			INNER JOIN @tblSettingDCS t 
				ON c.SportType = t.sporttype
				AND c.BetType = t.Bettype
		WHERE CustID = @CustID   
	END TRY
	BEGIN CATCH
		SELECT @ErrCode	= 950
			   ,@ErrMsg	= ERROR_MESSAGE()

		RETURN
	END CATCH
END	