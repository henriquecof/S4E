/****** Object:  Procedure [dbo].[Faturamento_Nao_Fechado]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE dbo.Faturamento_Nao_Fechado
-- =============================================
-- Author:      henrique.almeida
-- Create date: 13/09/2021 09:30
-- Database:    S4ECLEAN
-- Description: REALIZADO PADRONIZAÇÃO E FORMATAÇÃO DE ESTILO T-SQL
-- REALIZAR DOCUMENTAÇÃO DA PROCEDURE USANDO EXTENDED PROPERTIES
-- =============================================


AS
  BEGIN
    /**/
    DECLARE @mens VARCHAR(300)
    DECLARE @seq INT
    DECLARE @qtde INT

    SET @qtde = (SELECT COUNT(0)
        FROM MENSALIDADES
        WHERE TP_ASSOCIADO_EMPRESA = 2
              AND
              MONTH(MENSALIDADES.DT_VENCIMENTO) = MONTH(GETDATE())
              AND
              YEAR(MENSALIDADES.DT_VENCIMENTO) = YEAR(GETDATE())
              AND
              DT_IMPRESSO IS NULL
              AND
              CD_ASSOCIADO_empresa NOT IN (3359 , 32085)
              AND
              CD_TIPO_RECEBIMENTO NOT IN (1 , 2)
              AND
              CD_PARCELA < 32000
    )

    IF (@qtde > 0)
      BEGIN
        SET @seq = (SELECT MAX(cd_sequencial) + 1
            FROM emails
        ) SET @mens = '<font size=1 face=verdana><br/>Clique <a href=http://intra.absonline.com.br/modulos/abs_interno/epnfech.asp?ano=' + CONVERT(VARCHAR(4) , YEAR(GETDATE())) + '&mes=' + CONVERT(VARCHAR(2) , MONTH(GETDATE())) + '>aqui</a> para ver o relatório.</font>'

        INSERT INTO emails (cd_sequencial , nm_endereco , nm_mensagem , nm_assunto , fl_enviado)
        VALUES (@seq , 'iris@absonline.com.br,ubiratan@absonline.com.br,washington@absonline.com.br,cassio@absonline.com.br' , @mens , 'FATURAMENTO NÃO FECHADO - EMPRESA PRIVADA' , 0)

        /*		insert into emails(cd_sequencial,nm_endereco,nm_mensagem,nm_assunto,fl_enviado)
        		values (@seq,'washington@absonline.com.br',@mens,'FATURAMENTO NÃO FECHADO - EMPRESA PRIVADA',0)*/

        PRINT 'Fat.EP.N Fech. enviado'
      END

  END
