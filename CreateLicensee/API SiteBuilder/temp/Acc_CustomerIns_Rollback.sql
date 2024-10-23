/*<info serverAlias="DBGlob-GlobCustDB" executers="asv_cust" viewers="" isFunction="0"></info>*/
CREATE PROCEDURE [dbo].[Acc_CustomerIns_Rollback]
(
	@SubAccID	INT = 0, -- for sub account
	@custid		INT,
	@isResetNickname INT = 0
)
AS
/*
	Created: Helen
	Date: 2024-07-04
	Task: register username/nickname/custid for CREDIT
	DB: DBGLOB-GLOBCUSTDB
	
	Revisions:
		- 20240704@Helen: rollback username/nickname/custid for CREDIT/Deposit - [Redmine:199915]
		
	Parameter's Explanation:
	
*/	
BEGIN
	SET NOCOUNT ON
	
	IF @isResetNickname = 1 AND @SubAccID <> 0
	BEGIN
		UPDATE [dbo].CustSubMini WITH (ROWLOCK)  
			SET Username2 = NULL ,Username = NULL ,RepUpdateTime = SYSDATETIME()  
		WHERE subaccid = @subaccid AND CustID = @custid 

		RETURN
	END

	IF @SubAccID = 0 -- normal account
	BEGIN
		DELETE CustInfoMini WITH (ROWLOCK)
		/*
		OUTPUT DELETED.[CustID], SYSDATETIME()
		INTO CustInfoMini_Del_Inhouse ([CustID], [RepUpdateTime])
		*/
		WHERE custID = @custid
	END
	ELSE -- subaccount
	BEGIN
		DELETE CustSubMini WITH (ROWLOCK)
		/*
		OUTPUT DELETED.[subaccid],  SYSDATETIME()
		INTO CustSubMini_Del_Inhouse ([subaccid], [RepUpdateTime])
		*/
		WHERE subaccid = @SubAccID AND custid = @custid
	END

END
GO
    

