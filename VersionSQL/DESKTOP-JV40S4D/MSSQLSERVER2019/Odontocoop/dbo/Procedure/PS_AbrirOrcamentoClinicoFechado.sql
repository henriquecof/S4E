/****** Object:  Procedure [dbo].[PS_AbrirOrcamentoClinicoFechado]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE dbo.PS_AbrirOrcamentoClinicoFechado (
                 @Orcamento AS INT
)
-- =============================================
-- Author:      henrique.almeida
-- Create date: 13/09/2021 11:17
-- Database:    S4ECLEAN
-- Description: REALIZADO PADRONIZAÇÃO E FORMATAÇÃO DE ESTILO T-SQL
-- =============================================


AS
  BEGIN
    --Se houver mensalidade paga, orcamento não pode aberto
    --Saber se tem alguma parcela paga, se tiver não pode excluir.

    IF (SELECT COUNT(*)
          FROM MENSALIDADES
          WHERE CD_ASSOCIADO_empresa = (SELECT cd_associado
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
        RAISERROR ('Existe alguma parcela paga para esse orçamento. Orçamento não pode ser aberto.' , 16 , 1)
        RETURN

      END


    UPDATE orcamento_clinico
           SET cd_status = 0 ,
               dt_status = NULL ,
               cd_usuario_aceite = NULL
    WHERE cd_orcamento = @orcamento

  END
