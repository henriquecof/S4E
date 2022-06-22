/****** Object:  Function [dbo].[NExtenso_Convert]    Committed by VersionSQL https://www.versionsql.com ******/

 
CREATE FUNCTION [dbo].[NExtenso_Convert](@Num DECIMAL(18, 6), @Fat DECIMAL(18, 6))
	RETURNS VARCHAR(1000)
AS 
BEGIN 

	DECLARE @Ret VARCHAR(1000), @_Num DECIMAL(18, 6)
	SET @Ret = ''
	SET @_Num = 0
 
	IF @Fat > 0 BEGIN 
		IF @Num = 1000000000 BEGIN 
			SET @Ret = @Ret + ' Um Bilhão'
		END ELSE IF @Num = 1000000 BEGIN 
			SET @Ret = @Ret + ' Um Milhão'
		END ELSE IF @Num = 1000 BEGIN 
			SET @Ret = @Ret + ' Um Mil'
		END ELSE IF @Num >= 100 and @Num < 101 BEGIN 
			SET @Ret = @Ret + 'Cem'
		END ELSE IF @Num > 10 AND @Num < 20 BEGIN
			SET @Ret = @Ret + ISNULL(dbo.NExtenso_Extenso(@Num) + ' e ', '')
		END ELSE BEGIN 
			IF @Fat >= 1000 BEGIN 
				SET @_Num = CAST((@Num - (@Num % @Fat)) * (CAST(1 AS DECIMAL(18, 6)) / @Fat) AS INTEGER)
 
				IF @_Num = 1 BEGIN 
					SET @Ret = @Ret + ISNULL(dbo.NExtenso_Convert(@Fat, @Fat * .1), '')
				END ELSE BEGIN 
					SET @Ret = @Ret + ISNULL(dbo.NExtenso_Convert(@_Num, dbo.NExtenso_Fator(@_Num)), '') + ' ' + ISNULL(dbo.NExtenso_Extenso(@Fat), '')
				END 
 
				SET @_Num = @Num - (@_Num * @Fat)
 
				SET @Fat = dbo.NExtenso_Fator(@_Num)
 
				SET @Ret = @Ret + CASE WHEN (@Fat > 100 OR @Fat < 100) AND CAST((@_Num - (@_Num % @Fat)) * (CAST(1 AS DECIMAL(18, 6)) / @Fat) AS INTEGER) < 100 THEN ' e ' ELSE ', ' END + ISNULL(dbo.NExtenso_Convert(@_Num, @Fat), '')
			END ELSE BEGIN 
				SET @_Num = @Num - (@Num % @Fat)
				SET @Ret = @Ret + ISNULL(dbo.NExtenso_Extenso(@_Num) + ' e ', '') + dbo.NExtenso_Convert(@Num - @_Num, @Fat * .1)
			END 
		END
	END 
	RETURN REPLACE(REPLACE(@Ret + '.', ' e .', ''), '.', '')
END
