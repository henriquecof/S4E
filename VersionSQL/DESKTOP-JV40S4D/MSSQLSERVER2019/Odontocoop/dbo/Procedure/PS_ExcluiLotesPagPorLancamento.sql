/****** Object:  Procedure [dbo].[PS_ExcluiLotesPagPorLancamento]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:      henrique.almeida
-- Create date: 17/09/2021 11:15
-- Database:    S4ECLEAN
-- Description: REALIZADO PADRONIZAÇÃO E FORMATAÇÃO DE ESTILO T-SQL
-- REALIZAR DOCUMENTAÇÃO DA PROCEDURE USANDO EXTENDED PROPERTIES
-- =============================================


CREATE PROCEDURE dbo.PS_ExcluiLotesPagPorLancamento @Lancamento INTEGER

AS
BEGIN
  UPDATE orcamento_clinico
  SET cd_LancamentoIndicacao = NULL
  WHERE cd_LancamentoIndicacao = @Lancamento

  DECLARE @Cd_lote INT
  DECLARE cursor_LotesPagDentista CURSOR FOR SELECT
    cd_sequencial
  FROM pagamento_dentista
  WHERE nr_Lancamento = @Lancamento

  OPEN cursor_LotesPagDentista
  FETCH NEXT FROM cursor_LotesPagDentista INTO @Cd_lote
  EXEC dbo.PS_ApagaLotePagamentoDentista @Cd_lote

  FETCH NEXT FROM cursor_LotesPagDentista INTO @Cd_lote

  CLOSE cursor_LotesPagDentista
  DEALLOCATE cursor_LotesPagDentista
END
