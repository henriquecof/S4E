/****** Object:  Procedure [dbo].[PS_BaixaConsulta_Inconsistencia]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE dbo.PS_BaixaConsulta_Inconsistencia (
                 @cd_sequencial INT ,
                 @Acao BIT ,
                 @cd_funcionario INT ,
                 @usuario_cancelamento INT
)
-- =============================================
-- Author:      henrique.almeida
-- Create date: 13/09/2021 16:27
-- Database:    S4ECLEAN
-- Description: REALIZADO PADRONIZAÇÃO E FORMATAÇÃO DE ESTILO T-SQL
-- REALIZAR DOCUMENTAÇÃO DA PROCEDURE USANDO EXTENDED PROPERTIES
-- =============================================



AS
  BEGIN

    DECLARE @cd_sequencial_consulta INT

    SELECT @cd_sequencial_consulta = cd_sequencial_consulta
    FROM Inconsistencia_Consulta
    WHERE cd_sequencial = @cd_sequencial

    IF @cd_sequencial_consulta IS NULL
      BEGIN
        RAISERROR ('Procedimento não Localizado.' , 16 , 1)
        RETURN
      END

    IF @acao = 0 --Excluir
      BEGIN

        BEGIN TRANSACTION
        --Excluir Inconsistencia Consulta
        DELETE Inconsistencia_Consulta
        WHERE cd_sequencial = @cd_sequencial

        IF @@rowcount = 0
          BEGIN
            ROLLBACK TRANSACTION
            RAISERROR ('Exclusão da Inconsistência não processada.' , 16 , 1)
            RETURN
          END
        --Excluir Consulta

        DELETE Consultas_documentacao
        WHERE cd_sequencial = @cd_sequencial_consulta
        DELETE TB_ConsultasDocumentacao
        WHERE cd_sequencial = @cd_sequencial_consulta
        DELETE TB_ConsultasGlosados
        WHERE cd_sequencial = @cd_sequencial_consulta

        UPDATE Consultas
               SET dt_cancelamento = GETDATE() ,
                   status = 4 ,
                   MOTIVO_CANCELAMENTO = 'Exclusão de inconsistência' ,
                   usuario_cancelamento = @usuario_cancelamento
        WHERE cd_sequencial = @cd_sequencial_consulta

        IF @@rowcount = 0
          BEGIN
            ROLLBACK TRANSACTION
            RAISERROR ('Exclusão da Consulta não processada.' , 16 , 1)
            RETURN
          END

        COMMIT
      END

    ELSE
      BEGIN

        BEGIN TRANSACTION
        --Validar Inconsistencia Consulta
        UPDATE Inconsistencia_Consulta
               SET dt_analise = GETDATE() ,
                   cd_funcionario = @cd_funcionario
        WHERE cd_sequencial = @cd_sequencial

        IF @@rowcount = 0
          BEGIN
            ROLLBACK TRANSACTION
            RAISERROR ('Baixa da Inconsistência não processada.' , 16 , 1)
            RETURN
          END

        IF @@rowcount = 0
          BEGIN
            ROLLBACK TRANSACTION
            RAISERROR ('Baixa da Consulta não processada.' , 16 , 1)
            RETURN
          END

        COMMIT


      END

  END
