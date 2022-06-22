/****** Object:  Procedure [dbo].[cria_tabela_auditoria_visanet]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE dbo.cria_tabela_auditoria_visanet
-- =============================================
-- Author:      henrique.almeida
-- Create date: 10/09/2021 10:52
-- Database:    S4ECLEAN
-- Description: REALIZADO PADRONIZAÇÃO E FORMATAÇÃO DO ESTILO T-SQL
-- =============================================



/*
ESSA PROCEDURE DECLARA DUAS VARIAVEIS.:
@I INT
@aux CHAR(170)

1º - A VARIAVEL @i É SETADA COM VALOR 231.
	NO WHILE É CONSIDERADO A VARIAVEL @i < 528
2º - ABERTO BEGIN REALIZANDO SELECT NA VARIAVEL @aux.
2.1º - ESSA VARIÁVEL É UM INSERT NA TABELA VISA_AUDITORIA, QUE USA A VARIAVEL @i COMO UM DOS PARAMETROS NO CONVERT.
2.1.2º - LOGO APOS É REALIZADO EXEC NA VARIAVEL @aUx.
3º - SETADO O VALOR DA VARIAVEL @i = @i + 1
4º - FECHADO O BEGIN.

*/
AS
  BEGIN
    DECLARE @i INT
    DECLARE @aux CHAR(170)
    SET @i = 231
    WHILE @i < 528
      BEGIN

        SELECT @aux = 'insert into visa_auditoria select ' + CONVERT(VARCHAR(3) , @i) + ',cd_associado,vl_parcela,cd_parcela,dt_vencimento,venc_cartao,nr_autorizacao,val_cartao,nr_autorizacao_cartao,cd_rejeicao from vi0' + RIGHT('000' + CONVERT(VARCHAR(3) , @i) , 3)
        EXEC (@aux)
        SET @i = @i + 1
      END

  END
