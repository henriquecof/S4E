/****** Object:  Procedure [dbo].[stpDOC_geraBloco_Versoes]    Committed by VersionSQL https://www.versionsql.com ******/

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

--CREATE FUNCTION [dbo].[fncDocumentacao_BuscaTag] (
--	@Ds_Procedure VARCHAR(MAX),
--	@Nm_Tag VARCHAR(50)       ,
--	@Nm_Wrap VARCHAR(50)       = NULL )
--RETURNS XML
--AS BEGIN

--		DECLARE @Ds_Bloco VARCHAR(MAX) = ''

--		DECLARE @Tag1 VARCHAR(MAX) = '<' + @Nm_Tag + '>'
--		DECLARE @Tag2 VARCHAR(MAX) = '</' + @Nm_Tag + '>'

--		DECLARE @achou INT = 1

--		WHILE (@achou = 1)
--		BEGIN

--			SET @achou = 0

--			DECLARE @Pos1 INT,
--			        @Pos2 INT,
--			        @Pos3 INT

--			SET @Pos1 = CHARINDEX(@Tag1, @Ds_Procedure)
--			SET @Pos2 = CHARINDEX(@Tag2, @Ds_Procedure)

--			IF ( @Pos1 > 0
--			AND @Pos2 > 0 ) BEGIN
--				SET @Pos3 = @Pos2 - @Pos1 + LEN(@Tag2)
--				SET @Ds_Bloco = @Ds_Bloco + SUBSTRING(@Ds_Procedure, @Pos1, @Pos3)
--				SET @Ds_Procedure = SUBSTRING(@Ds_Procedure, @Pos2 + LEN(@Tag2), LEN(@Ds_Procedure))
--				SET @achou = 1
--			END

--		END

--		IF ( @Nm_Wrap IS NOT NULL
--		AND @Ds_Bloco <> '' ) SET @Ds_Bloco = '<' + @Nm_Wrap + '>' + @Ds_Bloco + '</' + @Nm_Wrap + '>'

--		DECLARE @Ds_Retorno XML
--		SET @Ds_Retorno = @Ds_Bloco

--		RETURN @Ds_Retorno

--	END
--GO

CREATE PROCEDURE [dbo].[stpDOC_geraBloco_Versoes] (
	@Nm_Procedure VARCHAR(MAX),
	@Id_Log_Referencia INT,
	@bloco VARCHAR(MAX) OUTPUT
)
AS BEGIN

		SET @bloco = '
    <div class="divTitulo azul">
        <b>Histórico de Versões</b>
    </div>
    
    <table class="tabResult" id="tabVersoes" cellpadding=0 cellspacing=0 style="width:100%">
        <thead>
            <tr>
                <td align="center" style="width:60px">Versão</td>
                <td align="center" style="width:160px">Data</td>
                <td style="width:280px">Autor</td>
                <td align="center" style="width:60px">Chamado</td>
                <td>Motivo</td>
            </tr>
        </thead>
        <tbody>'


		IF (OBJECT_ID('TempDB..#Versoes') IS NOT NULL) DROP TABLE #versoes
		SELECT
        	*
        	INTO
        		#versoes
        FROM dbo.log_procedures WITH (NOLOCK)
        WHERE nm_procedure = @nm_procedure
        ORDER BY id_auditoria DESC


		WHILE EXISTS (SELECT
                      	*
                      FROM #versoes)
		BEGIN

			DECLARE @id_log INT,
			        @dt_log DATETIME,
			        @nm_login VARCHAR(MAX),
			        @ds_alt XML,
			        @ds_doc XML

			SELECT TOP (1)
            	@id_log = id_auditoria ,
            	@dt_log = dt_evento ,
            	@nm_login = nm_login ,
            	@ds_alt = ds_alt ,
            	@ds_doc = ds_doc
            FROM #versoes
            ORDER BY id_auditoria DESC

			DECLARE @vatual VARCHAR(MAX)
			SELECT
            	@vatual = COUNT(*)
            FROM #versoes

			DECLARE @alt_texto VARCHAR(MAX),
			        @alt_chamado VARCHAR(MAX)
			SET @alt_texto = ISNULL(@ds_alt.value('(/alt/text())[1]', 'varchar(max)'), '')
			SET @alt_chamado = ISNULL(@ds_doc.value('(/doc/chamado)[1]', 'varchar(max)'), '')

			DECLARE @corBG varchar(MAX) = 'white'
			IF (@Id_Log = @Id_Log_Referencia) SET @corbg = 'lightgray'


			SET @bloco = @bloco + '
            <tr style="background:' + @corbg + '">
                <td align="center">' + @vatual + '</td>
                <td align="center"><a href="./' + CAST(@id_log AS VARCHAR(MAX)) + '.html">' + CONVERT(VARCHAR(10), @dt_log, 103) + ' ' + CONVERT(VARCHAR(8), @dt_log, 114) + '</a></td>
                <td>' + @nm_login + '</td>
                <td align="center">' + @alt_chamado + '</td>
                <td>' + @alt_texto + '</td>
            </tr>'


			DELETE #versoes
			WHERE id_auditoria = @id_log

		END

		SET @bloco = @bloco + '
        </tbody>
    </table>'

	END
