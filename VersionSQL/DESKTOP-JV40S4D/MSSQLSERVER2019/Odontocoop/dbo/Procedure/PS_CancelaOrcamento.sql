/****** Object:  Procedure [dbo].[PS_CancelaOrcamento]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE dbo.PS_CancelaOrcamento (
                 @Orcamento INT ,
                 @TipoCancelamento SMALLINT ,
                 @Motivo TEXT ,
                 @usuario VARCHAR(20)
)
-- =============================================
-- Author:      henrique.almeida
-- Create date: 13/09/2021 17:04
-- Database:    S4ECLEAN
-- Description: REALIZADO PADRONIZAÇÃO E FORMATAÇÃO DE ESTILO T-SQL
-- REALIZAR DOCUMENTAÇÃO DA PROCEDURE USANDO EXTENDED PROPERTIES
-- =============================================


AS
  BEGIN

    --Variaveis
    DECLARE @cd_ass INT
    DECLARE @cd_parc INT
    DECLARE @cd_sequencial INT
    DECLARE @fl_incorp BIT

    --Saber se tem alguma parcela paga, se tiver não pode excluir.
    IF (SELECT COUNT(*)
          FROM MENSALIDADES
          WHERE cd_associado_empresa = (SELECT cd_associado
                    FROM orcamento_clinico
                    WHERE cd_orcamento = @orcamento
                )
                AND
                TP_ASSOCIADO_EMPRESA = 1
                AND
                DT_PAGAMENTO IS NOT NULL
                AND
                cd_parcela IN (SELECT cd_parcela
                    FROM orcamento_mensalidades
                    WHERE cd_orcamento = @Orcamento
                )
      ) > 0
      BEGIN
        ROLLBACK
        RAISERROR ('Existe alguma parcela paga para esse orçamento. Exclusão não pode ser realizada.' , 16 , 1)
        RETURN
      END

    -- exclusao logica
    IF @TipoCancelamento = 1
      BEGIN
        BEGIN TRANSACTION
        --Cancela orcamento
        UPDATE orcamento_clinico
               SET cd_status = 3 ,
                   dt_status = GETDATE() ,
                   nm_motivo_cancelamento = @motivo
        WHERE cd_orcamento = @Orcamento

        --exclui mensalidades
        DECLARE cursor_canc CURSOR
        FOR SELECT cd_associado_empresa , cd_parcela , fl_incorpora
          FROM orcamento_mensalidades
          WHERE cd_orcamento = @Orcamento

        OPEN cursor_canc
        FETCH NEXT FROM cursor_canc
        INTO @cd_ass , @cd_parc , @fl_incorp

        WHILE (@@fetch_status <> -1)
          BEGIN

            IF @fl_incorp = 0
              BEGIN
                UPDATE MENSALIDADES
                       SET CD_TIPO_RECEBIMENTO = 1 ,
                           dt_baixa = GETDATE() ,
                           DT_ALTERACAO = GETDATE() ,
                           CD_USUARIO_ALTERACAO = @usuario ,
                           CD_USUARIO_BAIXA = @usuario
                WHERE cd_associado_empresa = @cd_ass
                       AND
                       TP_ASSOCIADO_EMPRESA = 1
                       AND
                       cd_parcela = @cd_parc
                       AND
                       DT_PAGAMENTO IS NULL
              END

            FETCH NEXT FROM cursor_canc INTO @cd_ass , @cd_parc , @fl_incorp
          END
        CLOSE cursor_canc
        DEALLOCATE cursor_canc

        --exclui comissao do vendedor
        DELETE FROM comissao_vendedor
        WHERE cd_orcamento = @Orcamento
              AND
              cd_sequencial_lote IS NULL

        --exclui logicamente os procedimentos
        DECLARE cursor_canc CURSOR
        FOR SELECT cd_sequencial_pp
          FROM orcamento_servico
          WHERE cd_orcamento = @Orcamento
                AND
                fl_pp = 1

        OPEN cursor_canc
        FETCH NEXT
        FROM cursor_canc INTO @cd_sequencial

        WHILE (@@fetch_status <> -1)
          BEGIN
            UPDATE Consultas
                   SET --dt_cancelamento=getdate(),
                   --motivo_cancelamento='Orçamento Cancelado',
                   --usuario_cancelamento = @usuario,
                   --Status = 4
                   Status = 2
            WHERE cd_sequencial = @cd_sequencial

            FETCH NEXT FROM cursor_canc INTO @cd_sequencial
          END
        CLOSE cursor_canc
        DEALLOCATE cursor_canc

        --Exclui os procedimentos do orcamento
        DELETE orcamento_servico
        WHERE cd_orcamento = @Orcamento

        COMMIT TRANSACTION
      END
    ----------------------------------------------------------------------------------------------
    -- exclusao fisica

    IF @TipoCancelamento = 2
      BEGIN
        BEGIN TRANSACTION

        --associado
        SET @cd_ass = 0
        SELECT @cd_ass = cd_associado
        FROM orcamento_clinico
        WHERE cd_orcamento = @Orcamento

        --exclui logicamente os procedimentos
        DECLARE cursor_canc CURSOR
        FOR SELECT cd_sequencial_pp
          FROM orcamento_servico
          WHERE cd_orcamento = @Orcamento
                AND
                fl_pp = 1

        OPEN cursor_canc
        FETCH NEXT
        FROM cursor_canc INTO @cd_sequencial

        WHILE (@@fetch_status <> -1)
          BEGIN

            UPDATE Consultas
                   SET --dt_cancelamento=getdate(),
                   --motivo_cancelamento='Orçamento Cancelado',
                   --usuario_cancelamento = @usuario,           
                   --Status = 4
                   Status = 2
            WHERE cd_sequencial = @cd_sequencial

            FETCH NEXT FROM cursor_canc INTO @cd_sequencial
          END
        CLOSE cursor_canc
        DEALLOCATE cursor_canc

        --Exclui comissao vendedor.
        DELETE FROM comissao_vendedor
        WHERE cd_orcamento = @Orcamento
              AND
              cd_sequencial_lote IS NULL

        --	 --Mensalidades.
        --exclui mensalidades
        DECLARE cursor_canc CURSOR
        FOR SELECT cd_associado_empresa , cd_parcela , fl_incorpora
          FROM orcamento_mensalidades
          WHERE cd_orcamento = @Orcamento

        OPEN cursor_canc
        FETCH NEXT FROM cursor_canc
        INTO @cd_ass , @cd_parc , @fl_incorp

        WHILE (@@fetch_status <> -1)
          BEGIN

            IF @fl_incorp = 0
              BEGIN
                UPDATE MENSALIDADES
                       SET CD_TIPO_RECEBIMENTO = 1 ,
                           dt_baixa = GETDATE() ,
                           DT_ALTERACAO = GETDATE() ,
                           CD_USUARIO_ALTERACAO = @usuario ,
                           CD_USUARIO_BAIXA = @usuario
                WHERE cd_associado_empresa = @cd_ass
                       AND
                       TP_ASSOCIADO_EMPRESA = 1
                       AND
                       cd_parcela = @cd_parc
                       AND
                       DT_PAGAMENTO IS NULL
              END

            FETCH NEXT FROM cursor_canc INTO @cd_ass , @cd_parc , @fl_incorp
          END
        CLOSE cursor_canc
        DEALLOCATE cursor_canc

        --Exclui os procedimentos do orcamento
        DELETE orcamento_servico
        WHERE cd_orcamento = @Orcamento

        --exclui mensalidades
        DELETE orcamento_mensalidades
        WHERE cd_orcamento = @Orcamento

        --delete from Orcamento_FornecedorMovimentacao
        --where Sequencial_OrcamentoFornecedor in
        --(Select Sequencial_OrcamentoFornecedor
        --From Orcamento_Fornecedor
        --where cd_orcamento = @Orcamento)
        --delete from Orcamento_Fornecedor
        --where cd_orcamento = @Orcamento

        --exclui orcamento clinico
        DELETE orcamento_clinico
        WHERE cd_orcamento = @Orcamento
        COMMIT TRANSACTION
      END

  END
