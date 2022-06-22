/****** Object:  Function [dbo].[FS_RetornaSituacao]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE FUNCTION [dbo].[FS_RetornaSituacao] 
(
	-- Add the parameters for the function here
	@sitEmp int,
	@sitTit int,
	@sitDep int
)
RETURNS int
AS
BEGIN
	-- Declare the return variable here
	DECLARE @Result int=-1

	-- Add the T-SQL statements to compute the return value here
	if @sitDep<>1 
		select @Result=@sitDep
	else if @sitEmp=2
		select @Result=@sitEmp
	else if @sitTit=2
		select @Result=@sitTit
	else if @sitTit<>1 and @sitTit<>2
		select @Result=@sitTit
	else if @sitEmp<>1 and @sitEmp<>2
		select @Result=@sitEmp
	else 
		select @Result=@sitDep
	
	

	-- Return the result of the function
	RETURN @Result

END
