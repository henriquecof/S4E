/****** Object:  Function [dbo].[fncDocumentacao_BuscaTag]    Committed by VersionSQL https://www.versionsql.com ******/

--IF (OBJECT_ID('dbo.Log_Procedures') IS NULL)
--BEGIN

--    -- DROP TABLE dbo.Log_Procedures
--    CREATE TABLE dbo.Log_Procedures (
--        Id_Auditoria INT IDENTITY(1,1),
--        Dt_Evento DATETIME NOT NULL,
--        Nm_Procedure VARCHAR(100),
--        Nm_Login VARCHAR(100),
--        Ds_Procedure VARCHAR(MAX),
--        Ds_Alt XML,
--        Ds_Doc XML,
--        Ds_Query XML
--    )

--    CREATE CLUSTERED INDEX SK01_Log_Procedures ON dbo.Log_Procedures(Id_Auditoria)

--END

CREATE FUNCTION [dbo].[fncDocumentacao_BuscaTag] (
	@Ds_Procedure VARCHAR(MAX),
	@Nm_Tag VARCHAR(50)       ,
	@Nm_Wrap VARCHAR(50)       = NULL )
RETURNS XML
AS BEGIN

		DECLARE @Ds_Bloco VARCHAR(MAX) = ''

		DECLARE @Tag1 VARCHAR(MAX) = '<' + @Nm_Tag + '>'
		DECLARE @Tag2 VARCHAR(MAX) = '</' + @Nm_Tag + '>'

		DECLARE @achou INT = 1

		WHILE (@achou = 1)
		BEGIN

			SET @achou = 0

			DECLARE @Pos1 INT,
			        @Pos2 INT,
			        @Pos3 INT

			SET @Pos1 = CHARINDEX(@Tag1, @Ds_Procedure)
			SET @Pos2 = CHARINDEX(@Tag2, @Ds_Procedure)

			IF ( @Pos1 > 0
			AND @Pos2 > 0 ) BEGIN
				SET @Pos3 = @Pos2 - @Pos1 + LEN(@Tag2)
				SET @Ds_Bloco = @Ds_Bloco + SUBSTRING(@Ds_Procedure, @Pos1, @Pos3)
				SET @Ds_Procedure = SUBSTRING(@Ds_Procedure, @Pos2 + LEN(@Tag2), LEN(@Ds_Procedure))
				SET @achou = 1
			END

		END

		IF ( @Nm_Wrap IS NOT NULL
		AND @Ds_Bloco <> '' ) SET @Ds_Bloco = '<' + @Nm_Wrap + '>' + @Ds_Bloco + '</' + @Nm_Wrap + '>'

		DECLARE @Ds_Retorno XML
		SET @Ds_Retorno = @Ds_Bloco

		RETURN @Ds_Retorno

	END
