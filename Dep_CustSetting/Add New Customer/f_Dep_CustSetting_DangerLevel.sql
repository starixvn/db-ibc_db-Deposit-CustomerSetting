/*<info serverAlias="DBCUST-CUSTDB" executers="" viewers="" isFunction="1" isNested="1"></info>*/
ALTER FUNCTION [dbo].[f_Dep_CustSetting_DangerLevel]
	(@site		NVARCHAR(50),
	 @currency	INT)
RETURNS @DangerLevel TABLE (DangerLevel BIGINT)
AS
/*
	Created: 20220913@Tacy
	Task : Customer Setting - Set Danger level (Saba Sports) for newly created members [RedmineID: #177464]
	DB: DBCUST/CUSTDB
	
	Revisions:
		- 20220913@Tacy: Create Function

	Parameter's Explanation:		
*/	
BEGIN
	DECLARE @SoccerLevel TINYINT,
            @BasketballLevel TINYINT

	SELECT	@SoccerLevel=CASE WHEN @site IN ('IG128','SM88','SL88SW','LIVV88SW','365Online','SKY88','Sin88','One88') THEN 10
							  WHEN @currency<>4 THEN 9        
							  WHEN @currency=4	THEN 11  --Currency: TB
                            END,
			@BasketballLevel=CASE WHEN @site IN ('Livv88sw','Haifa') OR @currency=96 
                                                                    OR (@site IN ('Happy8','SM88','AEUG','365Online','368cash') AND @currency=51)        --Currency: INH
                                                                    OR (@site='WINCLUB88' AND @currency=15)        --Currency: IN
                                                            THEN 10 ELSE 9 
                                                    END
	INSERT INTO @DangerLevel(DangerLevel)
    SELECT dbo.f_GenerateDangerLevelInfo(0,@SoccerLevel,@BasketballLevel,1,1)

	RETURN
END
