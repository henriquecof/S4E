/****** Object:  Function [dbo].[FF_MesAnoExtenso]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE FUNCTION [dbo].[FF_MesAnoExtenso] (@data DATE)
RETURNS VARCHAR(20)
AS
BEGIN
	DECLARE @mes AS VARCHAR(20)
	SET @mes = CASE DATEPART(MONTH, @data)
			WHEN 1
				THEN 'Janeiro'
			WHEN 2
				THEN 'Fevereiro'
			WHEN 3
				THEN 'Março'
			WHEN 4
				THEN 'Abril'
			WHEN 5
				THEN 'Maio'
			WHEN 6
				THEN 'Junho'
			WHEN 7
				THEN 'Julho'
			WHEN 8
				THEN 'Agosto'
			WHEN 9
				THEN 'Setembro'
			WHEN 10
				THEN 'Outubro'
			WHEN 11
				THEN 'Novembro'
			WHEN 12
				THEN 'Dezembro'
			END

	RETURN @mes +' de '+ convert(varchar ,DATEPART(YEAR, @data))
END
