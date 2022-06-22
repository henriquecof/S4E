/****** Object:  Procedure [dbo].[PS_ApagaLotePagamentoDentista]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE dbo.PS_ApagaLotePagamentoDentista (
                 @Lote INT
)
-- =============================================
-- Author:      henrique.almeida
-- Create date: 13/09/2021 11:31
-- Database:    S4ECLEAN
-- Description: REALIZADO PADRONIZAÇÃO E FORMATAÇÃO DE ESTILO T-SQL
-- REALIZAR DOCUMENTAÇÃO DA PROCEDURE USANDO EXTENDED PROPERTIES
-- =============================================


AS
  BEGIN

    DECLARE @sequencial INT
    DECLARE @Mensagem VARCHAR(1000)
    DECLARE @seq_pgto_dentista_lanc INT
    DECLARE @tipoFaturamento TINYINT

    SELECT @seq_pgto_dentista_lanc = cd_pgto_dentista_lanc , @tipoFaturamento = ISNULL(tipoFaturamento , 1)
    FROM pagamento_dentista
    WHERE cd_sequencial = @lote

    BEGIN TRANSACTION

    IF @seq_pgto_dentista_lanc IS NOT NULL
      BEGIN

        --Estornos de pagamento vinculados
        UPDATE dbo.EstornoPagamentoPrestador
               SET cd_pgto_dentista_lanc = NULL
        WHERE cd_pgto_dentista_lanc = @seq_pgto_dentista_lanc

        -- Cursor que pega todos os registros que estão sendo incluidos
        DECLARE cursor_ApagaLotePagamentoDentista CURSOR
        FOR SELECT sequencial_lancamento
          FROM dbo.Pagamento_Dentista_Lancamento
          WHERE cd_pgto_dentista_lanc = @seq_pgto_dentista_lanc

        OPEN cursor_ApagaLotePagamentoDentista
        FETCH NEXT FROM cursor_ApagaLotePagamentoDentista INTO @sequencial

        WHILE (@@FETCH_STATUS <> -1)
          BEGIN

            IF (SELECT t1.Data_HoraExclusao
                  FROM dbo.TB_Lancamento t1
                  WHERE t1.sequencial_lancamento = @sequencial
              ) IS NULL
              BEGIN

                IF (SELECT t1.Tipo_ContaLancamento
                      FROM dbo.TB_FormaLancamento t1
                      WHERE t1.sequencial_lancamento = @sequencial
                  ) = 1
                  BEGIN
                    CLOSE cursor_ApagaLotePagamentoDentista
                    DEALLOCATE cursor_ApagaLotePagamentoDentista
                    ROLLBACK TRANSACTION
                    SET @Mensagem = 'Pagamento ja realizado. Lote nao pode ser excluido. Lancamento: ' + CONVERT(VARCHAR , @sequencial)
                    RAISERROR (@Mensagem , 16 , 1)
                    RETURN
                  END

              END

            UPDATE dbo.TB_Lancamento
                   SET Data_HoraExclusao = GETDATE()
            WHERE sequencial_lancamento = @sequencial

            FETCH NEXT FROM cursor_ApagaLotePagamentoDentista INTO @sequencial
          END
        CLOSE cursor_ApagaLotePagamentoDentista
        DEALLOCATE cursor_ApagaLotePagamentoDentista

        DELETE FROM dbo.Pagamento_Dentista_Lancamento
        WHERE cd_pgto_dentista_lanc = @seq_pgto_dentista_lanc
      END

    IF (@tipoFaturamento = 1)
      BEGIN
        UPDATE dbo.Consultas
               SET nr_gtoTISS = NULL ,
                   nr_numero_lote = NULL ,
                   vl_pago_produtividade = NULL ,
                   vl_acerto_pgto_produtividade = NULL ,
                   cd_filial = ISNULL(cd_filialOriginal , cd_filial) ,
                   cd_filialOriginal = NULL ,
                   ExecutarTrigger = 0
        WHERE nr_numero_lote = @lote

        UPDATE dbo.ProtocoloConsultas
               SET lotePagamentoDentista = NULL
        WHERE lotePagamentoDentista = @lote
      END
    ELSE

    IF (@tipoFaturamento = 2)
      BEGIN
        UPDATE dbo.Consultas
               SET nr_numero_lote_clinica = NULL ,
                   vl_pago_produtividade_clinica = NULL ,
                   vl_acerto_pgto_produtividade_clinica = NULL ,
                   cd_filial = ISNULL(cd_filialOriginal , cd_filial) ,
                   cd_filialOriginal = NULL ,
                   ExecutarTrigger = 0
        WHERE nr_numero_lote_clinica = @lote
      END

    DELETE FROM pagamento_dentista
    WHERE cd_sequencial = @lote

    COMMIT TRANSACTION
  END
