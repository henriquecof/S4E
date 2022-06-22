/****** Object:  Function [dbo].[FS_RetornaPlanosEmpresa]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE FUNCTION [dbo].[FS_RetornaPlanosEmpresa] (@codigo INT)
RETURNS VARCHAR(1000)
AS
BEGIN
	DECLARE @retorno VARCHAR(1000)
	DECLARE @contrato AS VARCHAR(100)

	SET @retorno = ''

	DECLARE cursor_contrato CURSOR
	FOR
	SELECT DISTINCT T2.nm_plano
	FROM preco_plano T1
	INNER JOIN PLANOS T2 ON T2.cd_plano = T1.cd_plano
	WHERE T1.dt_fim_comercializacao IS NULL
		AND (
			T1.fl_inativo IS NULL
			OR T1.fl_inativo = 0
			)
		AND T1.cd_empresa = @codigo

	OPEN cursor_contrato

	FETCH NEXT
	FROM cursor_contrato
	INTO @contrato

	WHILE (@@fetch_status <> - 1)
	BEGIN
		IF len(@retorno) > 0
			SET @retorno = @retorno + ', ' + @contrato
		ELSE
			SET @retorno = @contrato

		FETCH NEXT
		FROM cursor_contrato
		INTO @contrato
	END

	CLOSE cursor_contrato

	DEALLOCATE cursor_contrato

	RETURN @retorno
END
