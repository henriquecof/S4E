/****** Object:  Procedure [dbo].[PS_AlteraAgenda]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE dbo.PS_AlteraAgenda (
                 @DentistaDE INT ,
                 @cd_sequencial INT ,
                 @DentistaPARA INT ,
                 @FilialPARA INT ,
                 @Data VARCHAR(10) ,
                 @HoraInicial VARCHAR(5) ,
                 @HoraFinal VARCHAR(5) ,
                 @ValorHora MONEY
)
-- =============================================
-- Author:      henrique.almeida
-- Create date: 13/09/2021 11:28
-- Database:    S4ECLEAN
-- Description: REALIZADO PADRONIZAÇÃO E FORMATAÇÃO DE ESTILO T-SQL
-- REALIZAR DOCUMENTAÇÃO DA PROCEDURE USANDO EXTENDED PROPERTIES
-- =============================================


AS
  BEGIN

    DECLARE @Especialidade INT
    DECLARE @DiferencaHoras INT
    DECLARE @DiferencaMinutos INT
    DECLARE @DiferencaTotal VARCHAR(5)
    DECLARE @qt_tempo_atend INT
    DECLARE @FilialDE INT

    BEGIN TRANSACTION

    SET @Especialidade = 0

    --Saber a especialidade da substituicao  
    SELECT @Especialidade = cd_especialidade , @qt_tempo_atend = qt_tempo_atend , @FilialDE = cd_filial
    FROM atuacao_dentista
    WHERE cd_funcionario = @DentistaDE
          AND
          cd_sequencial = @cd_sequencial

    IF @Especialidade = 0
      BEGIN
        ROLLBACK TRANSACTION
        RAISERROR ('Atuação do dentista que deseja trocar na agenda não existe para esse dia da semana.' , 16 , 1)
        RETURN
      END

    --Calculando diferenca entre as horas.
    SET @DiferencaHoras = DATEDIFF(HOUR , '1/1/1900 ' + @HoraInicial , '1/1/1900 ' + @HoraFinal)

    SET @DiferencaMinutos = DATEDIFF(MINUTE , '1/1/1900 ' + @HoraInicial , '1/1/1900 ' + @HoraFinal) % 60

    SET @DiferencaTotal = RIGHT('00' + LTRIM(CONVERT(VARCHAR(2) , @DiferencaHoras)) , 2) + ':' + RIGHT('00' + LTRIM(CONVERT(VARCHAR(2) , @DiferencaMinutos)) , 2) + ':00'

    ----------------------------------------------------------------------------------------------------------
    --Saber se existe procedimento baixado para essa agenda.
    ----------------------------------------------------------------------------------------------------------

    IF (SELECT COUNT(cd_sequencial)
          FROM Consultas
          WHERE dt_servico IS NOT NULL
                AND
                dt_cancelamento IS NULL
                AND
                cd_sequencial_agenda IN (SELECT cd_sequencial
                    FROM agenda
                    WHERE cd_funcionario = @DentistaDE
                          AND
                          dt_compromisso = @Data
                          AND
                          hr_Compromisso >= dbo.InverteHora(@HoraInicial)
                          AND
                          hr_Compromisso <= dbo.InverteHora(@HoraFinal)
                          AND
                          cd_filial = @FilialDE
                )
      ) > 0
      BEGIN
        ROLLBACK TRANSACTION
        RAISERROR ('A agenda que deseja modificar ja teve algum procedimento baixado, nao sendo mais possivel fazer a mudanca.' , 16 , 1)
        RETURN
      END

    ----------------------------------------------------------------------------------------------------------
    --Inclusao da falta do dentista.
    ----------------------------------------------------------------------------------------------------------
    INSERT INTO Falta_Substituicao_Dentista (cd_sequencial , dt_compromisso , cd_filial , cd_funcionario , qt_horas , cd_funcionario_substituicao , vl_hora)
           SELECT MAX(cd_sequencial) + 1 , @Data , @FilialDE , @DentistaDE , '12/30/1899 ' + @DiferencaTotal , @DentistaPARA , @ValorHora
           FROM Falta_Substituicao_Dentista

    ----------------------------------------------------------------------------------------------------------
    -- Inclusao da atuacao do dentista
    ----------------------------------------------------------------------------------------------------------   
    INSERT INTO atuacao_dentista (cd_funcionario , cd_filial , cd_especialidade , qt_tempo_atend , dia_semana_1 , dia_semana_2 , dia_semana_3 , dia_semana_4 , dia_semana_5 , dia_semana_6 , dia_semana_7 , HI , HF , dt_inicio , dt_fim , fl_ativo , valor_ajuda_custo)
    VALUES (@DentistaPARA , @FilialPARA , @Especialidade , @qt_tempo_atend , CASE WHEN DATEPART(WEEKDAY , @data) = 1 THEN 1 ELSE 0 END , CASE WHEN DATEPART(WEEKDAY , @data) = 2 THEN 1 ELSE 0 END , CASE WHEN DATEPART(WEEKDAY , @data) = 3 THEN 1 ELSE 0 END , CASE WHEN DATEPART(WEEKDAY , @data) = 4 THEN 1 ELSE 0 END , CASE WHEN DATEPART(WEEKDAY , @data) = 5 THEN 1 ELSE 0 END , CASE WHEN DATEPART(WEEKDAY , @data) = 6 THEN 1 ELSE 0 END , CASE WHEN DATEPART(WEEKDAY , @data) = 7 THEN 1 ELSE 0 END , '12/30/1899 ' + @HoraInicial + ':00' , '12/30/1899 ' + @HoraFinal + ':00' , @data , @data , 1 , NULL)

    ----------------------------------------------------------------------------------------------------------
    --Alteracao da agenda do dentista.
    ----------------------------------------------------------------------------------------------------------
    UPDATE agenda
           SET cd_funcionario = @DentistaPARA ,
               cd_filial = @FilialPARA
    WHERE cd_funcionario = @DentistaDE
           AND
           dt_compromisso = @Data
           AND
           hr_Compromisso >= dbo.InverteHora(@HoraInicial)
           AND
           hr_Compromisso <= dbo.InverteHora(@HoraFinal)
           AND
           cd_filial = @FilialDE

    COMMIT TRANSACTION

  END
