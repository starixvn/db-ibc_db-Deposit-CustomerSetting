/*<info serverAlias="DBCUST-CUSTDB" executers="bodbAdminNet,bodbDownlineNet,bodbExtAccNet,Dot_Member" viewers="vnteam" isFunction="0"></info>*/
ALTER PROCEDURE [Dep_Customer_Archive_InsCustomer_WithCustID]
	@custid INT,
	@firstname NVARCHAR(50),
	@lastname NVARCHAR(50),
	@creator INT,
	@username VARCHAR(30),
	@userpwd VARCHAR(40),
	@pwdexpiry DATETIME,
	@currency INT,
	@site NVARCHAR(50),
	@ugroup VARCHAR(5) = NULL,
	@createDate SMALLDATETIME, --20181011@Kean: Support for reactivation of member
	@birthday SMALLDATETIME,
	@refcode1	NVARCHAR(50),
	@remark NVARCHAR(50),
	@refcode2 NVARCHAR(50),
	@username2 VARCHAR(50),
	@srecommend INT,
	@mrecommend INT,
	@recommend INT,
	@roleid INT = 1,
	@phone NVARCHAR(50),
	@mobilephone NVARCHAR(50),
	@email NVARCHAR(50),
	@fax NVARCHAR(50),
	@address NVARCHAR(80),
	@city NVARCHAR(50),
	@state NVARCHAR(50),
	@country NVARCHAR(50),
	@postal NVARCHAR(50),
	
	@Language VARCHAR(2)= 'E',
	@ErrCode INT = 0 OUTPUT,
	@ErrMsg NVARCHAR(4000) = '' OUTPUT
WITH EXECUTE AS OWNER
AS
/*
	Created: Dominic@20181228
	Task :	Insert data into table customer with a specified CustID - Redmine #99882
	DB: DBCUST/CustDB

	Revisions:    
		- 20181228@Dominic: First commit
	
	Param's Explanation:
	• @ErrCode:
		= 0: Insert successfully.
		> 0: Specific Error.
  
	• @ErrMsg: Error description.
*/
BEGIN
    SET NOCOUNT ON 
	
	SET IDENTITY_INSERT dbo.Customer ON
		
    INSERT INTO Customer   			
			    (custid, username, firstname, lastname, phone, mobilephone, fax, email, address,
			    city, state, country, postal, userpwd, roleid, srecommend, mrecommend, recommend, 
			    currency, pwdexpiry, creator, Site, creatdate, ugroup, birthday, refcode1, remark, refcode2, username2
			    ) 
 		     VALUES (@custid, @username, @firstname, @lastname, @phone, @mobilephone, @fax, @email, @address, 
			    @city, @state, @country, @postal, @userpwd, @roleid, @srecommend, @mrecommend, @recommend, 
			    @currency, @pwdexpiry, @creator, @site, @createDate, @ugroup, @birthday, @refcode1, @remark, @refcode2, @username2
			    )
	
	SET IDENTITY_INSERT dbo.Customer OFF
	
	
    IF @@ERROR <> 0
    BEGIN
	    SELECT @ErrMsg = CASE @Language 
							    WHEN 'E' THEN 'Create customer failed. Please try again.'
							    ELSE [dbo].[f_Get_MsgNamebyMsgID](40004, @Language)
						    END,
		    @ErrCode = 111
    		
	    -- ROLLBACK MANUALLY
	    DELETE FROM Customer WITH (ROWLOCK) WHERE custId = @CustID
    		
	    RETURN
    END
END
