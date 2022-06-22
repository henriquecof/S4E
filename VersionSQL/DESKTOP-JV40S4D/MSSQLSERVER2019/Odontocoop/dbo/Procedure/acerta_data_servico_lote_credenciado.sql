/****** Object:  Procedure [dbo].[acerta_data_servico_lote_credenciado]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROC dbo.acerta_data_servico_lote_credenciado
AS

-- =============================================
-- Author:      henrique.almeida
-- Create date: 09/09/2021 17:57
-- Database:    S4ECLEAN
-- Description: REALIZADO PADRONIZAÇÃO NA FORMATAÇÃO E ESTILO DA PROCEDURE
-- =============================================



  /*
  ESSA PROCUDURE DECLARA DUAS VARIAVEIS, DO TIPO DATETIME.:
  @DTSERVICO
  @CDSEQPP
  
  TAMBÉM É ABERTO DECLARADO UM CURSOR COM NOME CURSOR_ACERTO.
  NESTE CURSO É REALIZADO UM SELECT NAS TABELAS.:
  PAGAMENTO_DENTISTA,
  PAGAMENTO_DENTISTA_GUIA,
  CONSULTAS,
  AUTORIZACAO_ATENDIMENTO
  
  NA CLAUSULA WHERE SÃO USADAS AS SEGUINTES CONDIÇÕES.:
  WHERE
  FL_FECHADO =1
  AND DT_SERVICO IS NULL
  AND DT_SOLICITACAO IS NOT NULL
  AND PAGAMENTO_DENTISTA.CD_SEQUENCIAL=2360
  
  APOS ISSO O CURSO É ABERTO E SEGUIDO O STATUS DO ENQUANTO (@@FETCH_STATUS<>-1).
  ENQUANTO O STATUS ESTA SENDO VISTO É REALIZADO UPDATE NA TABELA CONSULTAS SETANDO.:
  DT_SERVICO=@DTSERVICO E USANDO COMO CONDIÇÃO CD_SEQUENCIAL=@CDSEQPP
  
  */

  BEGIN

    DECLARE @dtservico DATETIME
    DECLARE @cdseqpp DATETIME
    DECLARE cursor_acerto CURSOR
    FOR SELECT dt_solicitacao , pagamento_dentista_guia.cd_sequencial_pp
      FROM pagamento_dentista INNER JOIN pagamento_dentista_guia ON pagamento_dentista.cd_sequencial = pagamento_dentista_guia.cd_sequencial INNER JOIN Consultas ON pagamento_dentista_guia.cd_sequencial_pp = Consultas.cd_sequencial LEFT JOIN autorizacao_Atendimento ON Consultas.nr_autorizacao = autorizacao_Atendimento.nr_autorizacao
      WHERE fl_fechado = 1
            AND
            dt_servico IS NULL
            AND
            dt_solicitacao IS NOT NULL
            AND
            pagamento_dentista.cd_sequencial = 2360
    OPEN cursor_acerto
    FETCH NEXT FROM cursor_acerto INTO @dtservico , @cdseqpp
    WHILE (@@fetch_status <> -1)
      BEGIN
        UPDATE Consultas
               SET dt_servico = @dtservico
        WHERE cd_sequencial = @cdseqpp

        FETCH NEXT FROM cursor_acerto INTO @dtservico , @cdseqpp
      END
    DEALLOCATE cursor_acerto

  END
