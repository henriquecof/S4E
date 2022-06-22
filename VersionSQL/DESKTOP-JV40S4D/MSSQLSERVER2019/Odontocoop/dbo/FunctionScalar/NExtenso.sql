/****** Object:  Function [dbo].[NExtenso]    Committed by VersionSQL https://www.versionsql.com ******/

 
CREATE FUNCTION [dbo].[NExtenso](@Num DECIMAL(15, 2))
	RETURNS VARCHAR(1000)
AS 
BEGIN 

	DECLARE @Ret VARCHAR(500)
	IF @Num > 0 BEGIN 
		
		SET @Ret = ''
		SET @Ret = dbo.NExtenso_Convert(@Num, dbo.NExtenso_Fator(@Num)) + 
			CASE FLOOR(@Num) WHEN 0 THEN '' WHEN 1 THEN ' Real' ELSE ' Reais' END 
			 
		SET @Num = @Num - FLOOR(@Num) 
		IF @Num > 0 BEGIN 
			
			SET @Ret = @Ret  + ' e ' 
			SET @Num = REPLACE(CAST(@Num AS VARCHAR(20)), '0.', '')
			SET @Ret = @Ret + dbo.NExtenso_Convert(@Num, dbo.NExtenso_Fator(@Num)) + CASE @Num WHEN 1 THEN ' Centavo' ELSE ' Centavos' END
		END
	END ELSE BEGIN
		SET @Ret = 'Zero Reais'
	END
	RETURN @Ret
END 
