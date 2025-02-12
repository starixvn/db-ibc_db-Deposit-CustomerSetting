/*<info serverAlias="DBCUST-CustDB" executers="" viewers="" isFunction="1"></info>*/
USE [CustDB]
GO

ALTER FUNCTION [dbo].[f_DelayTime](@KeyId VARCHAR(50))
RETURNS VARCHAR(50)
/*
	Created: 20250115@Virgil
	Revision:      
		- 20250115@Virgil: Create function delay time for script Initial setting [Redmine: #216274]
*/ 
AS
BEGIN
	RETURN (SELECT CASE WHEN @KeyId = 'Key1' THEN '00:00:00:100'
						WHEN @KeyId = 'Key2' THEN '00:00:00:200'
						WHEN @KeyId = 'Key3' THEN '00:00:00:500'
						ELSE '00:00:00:280' END)
END
GO

