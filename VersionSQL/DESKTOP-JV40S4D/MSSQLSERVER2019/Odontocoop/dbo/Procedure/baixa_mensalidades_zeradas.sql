/****** Object:  Procedure [dbo].[baixa_mensalidades_zeradas]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE dbo.baixa_mensalidades_zeradas
/***
ESSA PROCEDURE REALIZA O UPDATE NA TABELA MENSALIDADES, SETANDO O CAMPO DT_PAGAMENTO = DATA ATUAL (DATA:HORA:MINUTO),
CD_TIPO_RECEBIMENTO = 15, DATA DA BAIXA = DATA ATUAL (DATA:HORA:MINUTO) E O CAMPPO CD_USUARIO_BAIXA = SYS

OBEDECENDO OS CRITERIOS DO CAMPO VL_PARCELA <= 0, DT_VENCIMENTO < DATA ATUAL (DATA:HORA:MINUTO) E O CD_TIPO_RECEBIMENTO = 0
***/

-- =============================================
-- Author:      henrique.almeida
-- Create date: 10/09/2021 08:40
-- Database:    S4ECLEAN
-- Description: REALIZADO PADRONIZAÇÃO E FORMATAÇÃO DE ESTILO NA T-SQL
-- =============================================



AS
  BEGIN

    UPDATE MENSALIDADES
           SET DT_PAGAMENTO = GETDATE() ,
               CD_TIPO_RECEBIMENTO = 15 ,
               dt_baixa = GETDATE() ,
               CD_USUARIO_BAIXA = 'SYS'
    WHERE VL_PARCELA <= 0
           AND
           DT_VENCIMENTO < GETDATE()
           AND
           CD_TIPO_RECEBIMENTO = 0

  END
