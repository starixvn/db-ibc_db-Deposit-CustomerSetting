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
		- 20201103@Tina: Get site from Agent for member level [redmine: #144323]
		- 20220930@Eden: Reactive - Enhance to prevent lacking settings [redmine: #178439]
	
	Param's Explanation:
	• @ErrCode:
		= 0: Insert successfully.
		> 0: Specific Error.
  
	• @ErrMsg: Error description.
*/
BEGIN
    SET NOCOUNT ON 
	DECLARE @System_ERROR INT, @Rowcount INT

	IF (@roleid = 1 AND ISNULL(@site,'') = '') --role member and @site does not have value
	BEGIN
		SELECT @site = cus.[site]
		FROM Customer cus WITH (NOLOCK)
		WHERE cus.custid = @recommend
	END
	
	BEGIN TRY
		SET IDENTITY_INSERT dbo.Customer ON
		INSERT INTO Customer   			
					(custid, username, firstname, lastname, phone, mobilephone, fax, email, address,
					city, state, country, postal, userpwd, roleid, srecommend, mrecommend, recommend, 
					currency, pwdexpiry, creator, Site, creatdate, ugroup, birthday, refcode1, remark, refcode2, username2
					) 
 		SELECT @custid, @username, @firstname, @lastname, @phone, @mobilephone, @fax, @email, @address, 
			@city, @state, @country, @postal, @userpwd, @roleid, @srecommend, @mrecommend, @recommend, 
			@currency, @pwdexpiry, @creator, @site, @createDate, @ugroup, @birthday, @refcode1, @remark, @refcode2, @username2
		WHERE NOT EXISTS( SELECT 1 FROM Customer WITH(UPDLOCK,HOLDLOCK) WHERE custid = @custid)

		SELECT @Rowcount = @@ROWCOUNT

		SET IDENTITY_INSERT dbo.Customer OFF

		IF @Rowcount = 0 
		BEGIN
				SELECT @ErrMsg = 'This member has been reactivated by someone else.',
					@ErrCode = 22
    		
			RETURN
		END
	END TRY
	BEGIN CATCH
		SET IDENTITY_INSERT dbo.Customer OFF

		SELECT @ErrMsg = CASE @Language 
								WHEN 'E' THEN 'Create customer failed. Please try again.'
								ELSE [dbo].[f_Get_MsgNamebyMsgID](40004, @Language)
							END,
			@ErrCode = 111
    		
		RETURN
	END CATCH
END
