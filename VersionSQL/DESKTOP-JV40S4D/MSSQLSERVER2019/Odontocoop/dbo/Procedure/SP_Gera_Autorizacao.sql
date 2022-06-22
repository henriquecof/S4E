/****** Object:  Procedure [dbo].[SP_Gera_Autorizacao]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[SP_Gera_Autorizacao]
AS
BEGIN
	DECLARE @cd_filial SMALLINT
	DECLARE @qtde INT
	DECLARE @aux_filial VARCHAR(200)
	DECLARE @aux_filial2 VARCHAR(200)
	DECLARE @menor INT
	DECLARE @posicao INT
	DECLARE @maximo INT

	SELECT @menor = 50000,
		@aux_filial = ''

	DECLARE cursor_h CURSOR
	FOR
	SELECT f.cd_filial,
		isnull(count(a.nr_autorizacao), 0)
	FROM filial AS f
	LEFT OUTER JOIN autorizacao_atendimento AS a ON f.cd_filial = a.cd_filial
	WHERE f.cd_clinica = 1
	GROUP BY f.cd_filial
	HAVING count(a.nr_autorizacao) < 500
	ORDER BY isnull(count(a.nr_autorizacao), 0)

	OPEN cursor_h

	FETCH NEXT
	FROM cursor_h
	INTO @cd_filial,
		@qtde

	WHILE (@@FETCH_STATUS <> - 1)
	BEGIN
		SELECT @aux_filial = @aux_filial + ltrim(convert(VARCHAR(5), @cd_filial)) + ','

		IF @qtde < @menor
		BEGIN
			SELECT @menor = @qtde
		END

		FETCH NEXT
		FROM cursor_h
		INTO @cd_filial,
			@qtde
	END

	DEALLOCATE cursor_h

	SELECT @menor = 1000 - @menor

	SELECT @menor,
		@aux_filial

	SELECT @maximo = (
			SELECT isnull(max(nr_autorizacao), 0) + 1
			FROM autorizacao_atendimento
			)

	WHILE @menor > 0
	BEGIN
		SELECT @aux_filial2 = @aux_filial

		WHILE len(@aux_filial2) > 0
		BEGIN
			SELECT @posicao = PATINDEX('%,%', @aux_filial2)

			SELECT @cd_filial = left(@aux_filial2, @posicao - 1),
				@aux_filial2 = substring(@aux_filial2, @posicao + 1, len(@aux_filial2) - @posicao)

			INSERT INTO autorizacao_atendimento (
				nr_autorizacao,
				cd_filial
				)
			VALUES (
				@maximo,
				@cd_filial
				)

			SELECT @maximo = @maximo + 1
		END

		SELECT @menor = @menor - 1
	END
END
