/****** Object:  Procedure [dbo].[PS_AlteraSituacaoSop]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE dbo.PS_AlteraSituacaoSop (
                 @Associado INT ,
                 @contrato VARCHAR(20) ,
                 @sequencialdep INT
)
-- =============================================
-- Author:      henrique.almeida
-- Create date: 13/09/2021 11:29
-- Database:    S4ECLEAN
-- Description: REALIZADO PADRONIZAÇÃO E FORMATAÇÃO DE ESTILO T-SQL
-- REALIZAR DOCUMENTAÇÃO DA PROCEDURE USANDO EXTENDED PROPERTIES
-- =============================================


AS
  BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
    -- interfering with SELECT statements.
    SET NOCOUNT ON;

    DECLARE @sequencial_sop INT
    DECLARE @sequencial_Agendamento INT
    DECLARE @tipo_contrato SMALLINT

    IF @sequencialdep = 1
      BEGIN
        DECLARE cursor_sop1 CURSOR
        FOR SELECT t1.sequencial_sop , t1.sequencial_agendamento , t1.Tipo_Contrato
          FROM dbo.TB_AgendamentoVendaContrato t1
          WHERE t1.cd_associado = @Associado
                AND
                t1.nr_contrato = @contrato
      END
    ELSE
      BEGIN
        DECLARE cursor_sop1 CURSOR
        FOR SELECT t1.sequencial_sop , t1.sequencial_agendamento , t1.Tipo_Contrato
          FROM dbo.TB_AgendamentoVendaContrato t1
          WHERE t1.cd_associado = @Associado
                AND
                t1.cd_sequencial_dep = @sequencialdep
                AND
                t1.nr_contrato = @contrato
      END

    OPEN cursor_sop1
    FETCH NEXT FROM cursor_sop1 INTO @sequencial_sop , @sequencial_Agendamento , @tipo_contrato

    BEGIN TRANSACTION

    WHILE (@@FETCH_STATUS <> -1)
      BEGIN

        IF @tipo_contrato = 3
          BEGIN
            UPDATE dbo.servicos_opcionais
                   SET cd_situacao = 1
            WHERE cd_sequencial = @sequencial_sop
                   AND
                   nr_contrato = @contrato
          END

        UPDATE dbo.TB_AgendamentoVendaContrato
               SET Status = 3
        WHERE sequencial_agendamento = @sequencial_Agendamento

        FETCH NEXT FROM cursor_sop1 INTO @sequencial_sop , @sequencial_Agendamento , @tipo_contrato
      END

    COMMIT TRANSACTION

    CLOSE cursor_sop1
    DEALLOCATE cursor_sop1

  END
