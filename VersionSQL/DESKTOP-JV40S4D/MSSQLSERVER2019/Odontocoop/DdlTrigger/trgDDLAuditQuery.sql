/****** Object:  DdlTrigger [trgDDLAuditQuery]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
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

--CREATE PROCEDURE [dbo].[stpDOC_geraBloco_Versoes] (
--	@Nm_Procedure VARCHAR(MAX),
--	@Id_Log_Referencia INT,
--	@bloco VARCHAR(MAX) OUTPUT
--)
--AS BEGIN

--		SET @bloco = '
--    <div class="divTitulo azul">
--        <b>Histórico de Versões</b>
--    </div>

--    <table class="tabResult" id="tabVersoes" cellpadding=0 cellspacing=0 style="width:100%">
--        <thead>
--            <tr>
--                <td align="center" style="width:60px">Versão</td>
--                <td align="center" style="width:160px">Data</td>
--                <td style="width:280px">Autor</td>
--                <td align="center" style="width:60px">Chamado</td>
--                <td>Motivo</td>
--            </tr>
--        </thead>
--        <tbody>'


--		IF (OBJECT_ID('TempDB..#Versoes') IS NOT NULL) DROP TABLE #versoes
--		SELECT
--        	*
--        	INTO
--        		#versoes
--        FROM dbo.log_procedures WITH (NOLOCK)
--        WHERE nm_procedure = @nm_procedure
--        ORDER BY id_auditoria DESC


--		WHILE EXISTS (SELECT
--                      	*
--                      FROM #versoes)
--		BEGIN

--			DECLARE @id_log INT,
--			        @dt_log DATETIME,
--			        @nm_login VARCHAR(MAX),
--			        @ds_alt XML,
--			        @ds_doc XML

--			SELECT TOP (1)
--            	@id_log = id_auditoria ,
--            	@dt_log = dt_evento ,
--            	@nm_login = nm_login ,
--            	@ds_alt = ds_alt ,
--            	@ds_doc = ds_doc
--            FROM #versoes
--            ORDER BY id_auditoria DESC

--			DECLARE @vatual VARCHAR(MAX)
--			SELECT
--            	@vatual = COUNT(*)
--            FROM #versoes

--			DECLARE @alt_texto VARCHAR(MAX),
--			        @alt_chamado VARCHAR(MAX)
--			SET @alt_texto = ISNULL(@ds_alt.value('(/alt/text())[1]', 'varchar(max)'), '')
--			SET @alt_chamado = ISNULL(@ds_doc.value('(/doc/chamado)[1]', 'varchar(max)'), '')

--			DECLARE @corBG varchar(MAX) = 'white'
--			IF (@Id_Log = @Id_Log_Referencia) SET @corbg = 'lightgray'


--			SET @bloco = @bloco + '
--            <tr style="background:' + @corbg + '">
--                <td align="center">' + @vatual + '</td>
--                <td align="center"><a href="./' + CAST(@id_log AS VARCHAR(MAX)) + '.html">' + CONVERT(VARCHAR(10), @dt_log, 103) + ' ' + CONVERT(VARCHAR(8), @dt_log, 114) + '</a></td>
--                <td>' + @nm_login + '</td>
--                <td align="center">' + @alt_chamado + '</td>
--                <td>' + @alt_texto + '</td>
--            </tr>'


--			DELETE #versoes
--			WHERE id_auditoria = @id_log

--		END

--		SET @bloco = @bloco + '
--        </tbody>
--    </table>'

--	END


--CREATE PROCEDURE [dbo].[stpEscreve_Arquivo_FSO] (
--	@String VARCHAR(MAX),
--	@Ds_Arquivo VARCHAR(1501)
--)
--AS BEGIN

--		DECLARE @objFileSystem INT,
--		        @objTextStream INT,
--		        @objErrorObject INT,
--		        @strErrorMessage VARCHAR(1000),
--		        @Command VARCHAR(1000),
--		        @hr INT

--		SET NOCOUNT ON

--		SELECT
--        	@strErrorMessage = 'opening the File System Object'

--		EXECUTE @hr = sp_OACreate
--			'Scripting.FileSystemObject',
--			@objFileSystem OUT


--		IF @HR = 0 SELECT
--                   	@objErrorObject = @objFileSystem ,
--                   	@strErrorMessage = 'Creating file "' + @Ds_Arquivo + '"'


--		IF @HR = 0 EXECUTE @hr = sp_OAMethod
--			@objFileSystem,
--			'CreateTextFile',
--			@objTextStream OUT,
--			@Ds_Arquivo,
--			2,
--			True

--		IF @HR = 0 SELECT
--                   	@objErrorObject = @objTextStream ,
--                   	@strErrorMessage = 'writing to the file "' + @Ds_Arquivo + '"'


--		IF @HR = 0 EXECUTE @hr = sp_OAMethod
--			@objTextStream,
--			'Write',
--			NULL,
--			@String


--		IF @HR = 0 SELECT
--                   	@objErrorObject = @objTextStream ,
--                   	@strErrorMessage = 'closing the file "' + @Ds_Arquivo + '"'


--		IF @HR = 0 EXECUTE @hr = sp_OAMethod
--			@objTextStream,
--			'Close'


--		IF @hr <> 0 BEGIN

--			DECLARE @Source VARCHAR(255),
--			        @Description VARCHAR(255),
--			        @Helpfile VARCHAR(255),
--			        @HelpID INT

--			EXECUTE sp_OAGetErrorInfo
--				@objErrorObject,
--				@source OUTPUT,
--				@Description OUTPUT,
--				@Helpfile OUTPUT,
--				@HelpID OUTPUT


--			SELECT
--            	@strErrorMessage = 'Error whilst ' + COALESCE(@strErrorMessage, 'doing something') + ', ' + COALESCE(@Description, '')


--			RAISERROR (@strErrorMessage,16,1)

--		END


--		EXECUTE sp_OADestroy
--			@objTextStream

--		EXECUTE sp_OADestroy
--			@objTextStream

--	END

--CREATE PROCEDURE [dbo].[stpDOC_Gera_Arquivos] (
--    @Ds_Caminho VARCHAR(500),
--    @Fl_Todos INT = 0
--)
--AS 
--BEGIN


--    SET NOCOUNT ON


--    IF (OBJECT_ID('TempDB..#Procedures') IS NOT NULL) DROP TABLE #Procedures
--    SELECT Nm_Procedure, Id_Auditoria
--    INTO #Procedures
--    FROM dbo.Log_Procedures WITH(NOLOCK)

--    IF (OBJECT_ID('TempDB..#Ultimo_Log') IS NOT NULL) DROP TABLE #Ultimo_Log
--    SELECT Nm_Procedure, MAX(Id_Auditoria) AS Id_Auditoria
--    INTO #Ultimo_Log 
--    FROM #Procedures 
--    GROUP BY Nm_Procedure

--    IF (@Fl_Todos = 0) DELETE #Procedures WHERE Id_Auditoria NOT IN (SELECT Id_Auditoria FROM #Ultimo_Log)

--    DECLARE @Html_index varchar(max) = '
--    <!DOCTYPE html>
--    <html>
--    <head>
--        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
--        <title>Documentação</title>
--    </head>

--    <body style="font-family:Verdana; font-size:14px">
--        <h2>Versionamento de Stored Procedures</h2>
--        <ul>
--    '


--    DECLARE @Nm_Arquivo VARCHAR(100)

--    WHILE EXISTS (SELECT * FROM #Procedures) 
--    BEGIN
        
--        DECLARE @Nm_Procedure varchar(max), @Id_Auditoria int, @Id_Max int
--        SELECT TOP(1) @Nm_Procedure = Nm_Procedure, @Id_Auditoria = Id_Auditoria FROM #Procedures A 
--        SELECT @Id_Max = Id_Auditoria FROM #Ultimo_Log WHERE Nm_Procedure = @Nm_Procedure
        
--        DECLARE @Nm_Login varchar(max), @Ds_Procedure varchar(max), @Dt_Log datetime, @Ds_Alt xml, @Ds_Doc xml, @Ds_Steps xml	
        
--        SELECT 
--            @Nm_Login = Nm_Login,
--            @Ds_Procedure = Ds_Procedure,
--            @Dt_Log = Dt_Evento,
--            @Ds_Alt = Ds_Alt,
--            @Ds_Doc = Ds_Doc
--        FROM 
--            dbo.Log_Procedures A WITH(NOLOCK)
--        WHERE 
--            Nm_Procedure = @Nm_Procedure 
--            AND Id_Auditoria = @Id_Auditoria
        
        
--        DECLARE @Doc_Titulo varchar(max), @Doc_Descricao varchar(max)
--        SET @Doc_Titulo = IsNull(@Ds_Doc.value('(/doc/titulo)[1]','varchar(max)'),@Nm_Procedure)
--        SET @Doc_Descricao = IsNull(@Ds_Doc.value('(/doc/descricao)[1]','varchar(max)'),'<red>/doc/descricao em branco ou não definido.</red>')
        
--        DECLARE @bloco_Versoes varchar(max) = ''
--        EXEC dbo.stpDOC_geraBloco_Versoes @Nm_Procedure, @Id_Auditoria, @bloco_Versoes OUT
    
--        DECLARE @Html varchar(max)
--        SET @Html = 
--        '
--        <!DOCTYPE html>
--        <html>

--            <head>
--                <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
--                <title>Documentação</title>

--                <style type="text/css">
--                    .tabResult thead {
--                        background: #03a9f4;
--                        color: #fff;
--                        font-weight: bold;
--                        text-align: center;
--                        line-height: 28px;
--                    }

--                    .tabResult td {
--                        padding: 5px;
--                        border: 1px solid #eaeaea;
--                    }

--                    .tabResult tr:hover {
--                        background: #539eb5 !important;
--                    }

--                </style>

--            </head>

--            <body style="font-family:Verdana; font-size:14px">

--                <a href="../index.html">Voltar à Home</a>
--                <br/>
--                <br/>

--                <div style="margin-bottom:10px">
--                    <div class="header grad_preto">
--                        <table cellpadding=0 cellspacing=0 style="width:100%">
--                            <tr>
--                                <td><b>' + @Doc_Titulo + '</b></td>
--                                <td align="right"><b><a href="../index.html" style="text-decoration:none; color:white">Voltar</a></b></td>
--                            </tr>
--                        </table>
--                    </div>	
--                    <div style="padding:5px; margin-top:10px">' + @Doc_Descricao + '</div>
--                </div>
            
--                <br/>
                
--                ' + @bloco_Versoes + '
            
--                <br/>
            
--                <div class="divTitulo verde">
--                    <b>Código Fonte</b>
--                </div>
            
--                <pre id="preQuery" class="sh_sql"><xmp>' + @Ds_Procedure + '</xmp></pre>

--            </body>

--        </html>'
        
        
--        DECLARE @Ds_Caminho_Arquivo VARCHAR(500) = @Ds_Caminho + @Nm_Procedure + '\'
--        EXEC master.dbo.xp_create_subdir @Ds_Caminho_Arquivo
        
--        SET @Nm_Arquivo = @Ds_Caminho_Arquivo + CAST(@Id_Auditoria AS VARCHAR(MAX)) + '.html'
    
--        EXEC dbo.stpEscreve_Arquivo_FSO @Html, @Nm_Arquivo

--        IF (@Id_Auditoria = @Id_Max) 
--        BEGIN
            
--            SET @Nm_Arquivo = @Ds_Caminho_Arquivo + 'index.html'
--            EXEC dbo.stpEscreve_Arquivo_FSO @Html, @Nm_Arquivo
            
--            SET @Html_index = @Html_index + '
--                <div style="padding:5px">
--                    <li><a href="' + @Ds_Caminho_Arquivo + 'index.html" style="text-decoration:none; color:black">' + @Nm_Procedure + '</a></li>
--                </div>
--            '	
--        END

--        DELETE #Procedures WHERE Id_Auditoria = @Id_Auditoria

--    END


--    SET @Html_index = @Html_index+'
--            </ul>

--        </body>
--    </html>
--    '

--    SET @Nm_Arquivo = @Ds_Caminho + 'index.html'
--    EXEC dbo.stpEscreve_Arquivo_FSO @Html_index, @Nm_Arquivo
    
--END

CREATE TRIGGER [trgDDLAuditQuery]
ON DATABASE 
FOR ALTER_PROCEDURE
AS
BEGIN

SET NOCOUNT ON
   
    DECLARE @EventAtual XML = EVENTDATA()
    
    DECLARE @Nm_Procedure VARCHAR(MAX) = @EventAtual.value('(/EVENT_INSTANCE/ObjectName)[1]', 'nvarchar(max)')
    DECLARE @QueryAtual VARCHAR(MAX) = @EventAtual.value('(/EVENT_INSTANCE/TSQLCommand)[1]', 'nvarchar(max)')
    
    DECLARE @Nm_Login VARCHAR(MAX) = @EventAtual.value('(/EVENT_INSTANCE/LoginName/text())[1]','varchar(50)')
    
    DECLARE @altAtual XML = dbo.fncDocumentacao_BuscaTag(@QueryAtual,'alt',NULL)
    DECLARE @docAtual XML = dbo.fncDocumentacao_BuscaTag(@QueryAtual,'doc',NULL)
    
    DECLARE @Max_Id_Alteracao INT
SELECT @max_id_alteracao = MAX(id_auditoria)
FROM dbo.log_procedures
WHERE nm_procedure = @nm_procedure

DECLARE @eventanterior XML = (SELECT TOP (1) ds_query
        FROM dbo.log_procedures
        WHERE id_auditoria = @max_id_alteracao
    ORDER BY id_auditoria DESC)
DECLARE @queryanterior VARCHAR(MAX) = @eventanterior.value('(/EVENT_INSTANCE/TSQLCommand)[1]', 'nvarchar(max)')
DECLARE @altanterior XML = dbo.fncdocumentacao_buscatag(@queryanterior, 'alt', NULL)

DECLARE @dsatual VARCHAR(MAX) = @altatual.value('(/alt)[1]', 'nvarchar(max)')
DECLARE @dsanterior VARCHAR(MAX) = @altanterior.value('(/alt)[1]', 'nvarchar(max)')

IF (ISNULL(@dsatual, '') = ISNULL(@dsanterior, '')
    OR ISNULL(@dsatual, '') = '')
BEGIN
ROLLBACK
RAISERROR ('O motivo de alteração não foi informado. FAVOR INFORMAR O MOTIVO DA ALTERAÇÃO USANDO A TAG <alt> como comentário (/* <alt>Descrição da alteração</alt> */).', 16, 1)
RETURN
END


INSERT INTO dbo.log_procedures (dt_evento,
                                nm_procedure,
                                nm_login,
                                ds_procedure,
                                ds_alt,
                                ds_doc,
                                ds_query)
    SELECT GETDATE(),
           @nm_procedure,
           @nm_login,
           @queryatual,
           @altatual,
           @docatual,
           @eventatual


EXEC dbo.stpdoc_gera_arquivos @ds_caminho = 'C:\Documentação\' -- varchar(500)



END

DISABLE TRIGGER [trgDDLAuditQuery] ON DATABASE
