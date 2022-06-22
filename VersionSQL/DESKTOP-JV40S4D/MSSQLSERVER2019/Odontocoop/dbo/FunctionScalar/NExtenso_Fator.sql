/****** Object:  Function [dbo].[NExtenso_Fator]    Committed by VersionSQL https://www.versionsql.com ******/

 
CREATE FUNCTION [dbo].[NExtenso_Fator](@Num INTEGER)
	RETURNS INTEGER
AS
BEGIN 

	IF @Num < 10 RETURN 1
	ELSE IF @Num < 100 RETURN 10
	ELSE IF @Num < 1000 RETURN 100
	ELSE IF @Num < 1000000 RETURN 1000
	ELSE IF @Num < 1000000000 RETURN 1000000
	ELSE IF @Num < 1000000000000 RETURN 1000000000
	RETURN NULL
END
