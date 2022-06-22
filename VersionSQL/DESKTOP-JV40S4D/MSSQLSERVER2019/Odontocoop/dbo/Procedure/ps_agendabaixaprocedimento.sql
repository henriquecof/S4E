/****** Object:  Procedure [dbo].[ps_agendabaixaprocedimento]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE dbo.ps_agendabaixaprocedimento
-- =============================================
-- Author:      henrique.almeida
-- Create date: 13/09/2021 11:23
-- Database:    S4ECLEAN
-- Description: REALIZADO PADRONIZAÇÃO E FORMATAÇÃO DE ESTILO T-SQL
-- =============================================


(
                 @Sequencial_ConsultasDocumentacao INT ,
                 @Data VARCHAR(10) ,
                 @cd_funcionario INT ,
                 @cd_associado INT ,
                 @cd_sequencialdep INT ,
                 @cd_usuario VARCHAR(8) ,
                 @cd_sequencial INT ,
                 @Liberar SMALLINT ,
                 @clinica_ins INT ,
                 @cd_sequencialagenda INT
)

AS
  BEGIN

    DECLARE @hr_comromisso INT
    DECLARE @clinica INT
    DECLARE @DS_Mensagem VARCHAR(500)
    DECLARE @nr_numero_lote INT

    BEGIN TRANSACTION

    SELECT @nr_numero_lote = nr_numero_lote /*,
     @cd_sequencialagenda = cd_sequencial_agenda*/
    FROM Consultas
    WHERE cd_sequencial = @cd_sequencial

    /* Se procedimento ja foi pago nao pode ser alterado*/
    IF @nr_numero_lote IS NOT NULL
      BEGIN
        SELECT @DS_Mensagem = 'procedimento esta dentro de lote de pagamento. Nao pode ser mais alterado.'
        ROLLBACK TRANSACTION
        RAISERROR (@DS_Mensagem , 16 , 1)
        RETURN
      END

    IF @clinica_ins = 0
      BEGIN
        SET @clinica = 0
        SELECT DISTINCT @clinica = cd_filial
        FROM atuacao_dentista_new
        WHERE cd_funcionario = @cd_funcionario
      END
    ELSE
      BEGIN
        SET @clinica = @clinica_ins
      END

    IF @clinica = 0
      BEGIN
        SELECT @DS_Mensagem = 'Dentista precisa ter atuacao cadastrada.'
        ROLLBACK TRANSACTION
        RAISERROR (@DS_Mensagem , 16 , 1)
        RETURN
      END

    /*Documentacao obrigatoria*/
    IF @Sequencial_ConsultasDocumentacao <> 0
      BEGIN
        UPDATE TB_ConsultasDocumentacao
               SET foto_digitalizada = 1
        WHERE Sequencial_ConsultasDocumentacao = @Sequencial_ConsultasDocumentacao
      END

    IF @cd_sequencialagenda = 0
      BEGIN
        /*agenda : gerar agenda ficticia para baixa do procedimento*/
        SELECT @hr_comromisso = 0
        SELECT @hr_comromisso = COUNT(cd_sequencial)
        FROM agenda
        WHERE cd_funcionario = @cd_funcionario
              AND
              CONVERT(VARCHAR(10) , dt_compromisso , 101) = @data

        SELECT @hr_comromisso = dbo.InverteHora('08:00') + (@hr_comromisso + 1)

        INSERT INTO agenda (dt_compromisso , hr_compromisso , cd_funcionario , cd_filial , cd_associado , cd_sequencial_dep , nm_anotacao , dt_marcado , nm_observacao , cd_usuario , nm_motivoatendimento)
        VALUES (@Data , @hr_comromisso , @cd_funcionario , @clinica , @cd_associado , @cd_sequencialdep , '' , GETDATE() , 'Agenda gerada automaticamente para baixa de procedimento' , @cd_usuario , '')

        SELECT @cd_sequencialagenda = MAX(cd_sequencial)
        FROM agenda
      END

    /* baixar procedimento*/
    IF @Liberar = 1
      BEGIN
        UPDATE Consultas
               SET Status = 3 ,
                   dt_servico = @Data ,
                   dt_baixa = GETDATE() ,
                   cd_funcionario = @cd_funcionario ,
                   usuario_baixa = @cd_usuario ,
                   cd_filial = @clinica_ins ,
                   cd_sequencial_agenda = @cd_sequencialagenda ,
                   nr_procedimentoliberado = 1
        WHERE cd_sequencial = @cd_sequencial

        UPDATE ConsultasTemp
               SET Status = 3 ,
                   dt_servico = @Data ,
                   dt_baixa = GETDATE() ,
                   CD_FUNCIONARIO = @cd_funcionario ,
                   usuario_baixa = @cd_usuario ,
                   cd_filial = @clinica_ins ,
                   cd_sequencial_agenda = @cd_sequencialagenda ,
                   nr_procedimentoliberado = 1
        WHERE cd_sequencial = @cd_sequencial

      END
    ELSE
      BEGIN
        UPDATE ConsultasTemp
               SET Status = 3 ,
                   dt_servico = @Data ,
                   dt_baixa = GETDATE() ,
                   usuario_baixa = @cd_usuario ,
                   CD_FUNCIONARIO = @cd_funcionario ,
                   cd_filial = @clinica_ins ,
                   cd_sequencial_agenda = @cd_sequencialagenda ,
                   nr_procedimentoliberado = NULL
        WHERE cd_sequencial = @cd_sequencial

        UPDATE Consultas
               SET Status = 3 ,
                   dt_servico = @Data ,
                   dt_baixa = GETDATE() ,
                   usuario_baixa = @cd_usuario ,
                   CD_FUNCIONARIO = @cd_funcionario ,
                   cd_filial = @clinica_ins ,
                   cd_sequencial_agenda = @cd_sequencialagenda ,
                   nr_procedimentoliberado = NULL
        WHERE cd_sequencial = @cd_sequencial
      END

    COMMIT TRANSACTION

  END
