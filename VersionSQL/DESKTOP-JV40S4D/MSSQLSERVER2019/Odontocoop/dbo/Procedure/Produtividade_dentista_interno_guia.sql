/****** Object:  Procedure [dbo].[Produtividade_dentista_interno_guia]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE dbo.Produtividade_dentista_interno_guia (
                 @cd_seq AS INT
)
-- =============================================
-- Author:      henrique.almeida
-- Create date: 13/09/2021 11:11
-- Database:    S4ECLEAN
-- Description: REALIZADO PADRONIZAÇÃO E FORMATAÇÃO DE ESTILO T-SQL
-- =============================================


AS
  BEGIN
    DECLARE @DS_Mensagem VARCHAR(100)
    DECLARE @cd_func INT
    DECLARE @cdFilialAux INTEGER
    DECLARE @dt_ini DATETIME
    DECLARE @dt_fim DATETIME
    DECLARE @dt_fechado DATETIME

    DECLARE @cd_filial INTEGER
    DECLARE @cd_especialidade INTEGER
    DECLARE @hr_ini DATETIME
    DECLARE @hr_fim DATETIME
    DECLARE @qt_hr DATETIME
    DECLARE @feriado INTEGER
    DECLARE @vl_hora MONEY

    DECLARE @vl_hora_func_esp MONEY
    DECLARE @vl_hora_func MONEY
    DECLARE @vl_hora_clin_esp MONEY
    DECLARE @vl_hora_clin MONEY

    DECLARE @vl_ajuda_custo MONEY
    RETURN
    SELECT @cd_func = CD_FUNCIONARIO , @cdFilialAux = cd_filial , @dt_ini = dt_inicio , @dt_fim = dt_final , @dt_fechado = dt_fechado
    FROM dbo.produtividade_dentista_interno
    WHERE cd_sequencial = @cd_seq


    -- Verifica se o sequencial existe
    IF @cd_func IS NULL
      BEGIN
        SELECT @DS_Mensagem = 'Sequencial não encontrado.'
        RAISERROR (@DS_Mensagem , 16 , 1)
        RETURN
      END


    -- Verifica se o lote já foi fechado
    IF @dt_fechado IS NOT NULL
      BEGIN
        SELECT @DS_Mensagem = 'Lote fechado! Não é permitido refazer o cálculo.'
        RAISERROR (@DS_Mensagem , 16 , 1)
        RETURN
      END


    -- Exclui todos os ítens do sequencial informado para poder refazer o cálculo
    PRINT '1'
    DELETE produtividade_dentista_interno_item
    WHERE cd_sequencial_lote = @cd_seq


    -- Calculas Faltas
    PRINT '2'
    INSERT produtividade_dentista_interno_item (cd_sequencial_lote , data , cd_filial , vl_hora , cd_tipo , qt_hora , ajuda_custo)
           SELECT @cd_seq , dt_compromisso , cd_filial , -ISNULL(vl_hora , 0) , 2 , qt_horas , 0
           FROM Falta_Substituicao_Dentista
           WHERE dt_compromisso >= @dt_ini
                 AND
                 dt_compromisso <= @dt_fim
                 AND
                 cd_funcionario = @cd_func
                 AND
                 cd_filial = @cdFilialAux


    -- Calcula Substituiçoes
    PRINT '3'
    INSERT produtividade_dentista_interno_item (cd_sequencial_lote , data , cd_filial , vl_hora , cd_tipo , qt_hora , ajuda_custo)
           --   select @cd_seq, dt_compromisso, cd_filial, isnull(vl_hora,0), 3, qt_horas, 0
           SELECT @cd_seq , dt_compromisso , cd_filial , 0 , 3 , qt_horas , 0
           FROM Falta_Substituicao_Dentista
           WHERE dt_compromisso >= @dt_ini
                 AND
                 dt_compromisso <= @dt_fim
                 AND
                 cd_funcionario_substituicao = @cd_func
                 AND
                 cd_filial = @cdFilialAux


    -- Calcula Ajustes
    PRINT '4'
    INSERT produtividade_dentista_interno_item (cd_sequencial_lote , data , cd_filial , ajuste_proposito , vl_hora , cd_tipo , qt_hora , ajuda_custo)
           SELECT @cd_seq , data , cd_filial , proposito , vl_ajuste , 5 , '01:00' , 0
           FROM produtividade_dentista_interno_ajuste
           WHERE data >= @dt_ini
                 AND
                 data <= @dt_fim
                 AND
                 cd_funcionario = @cd_func
                 AND
                 cd_filial = @cdFilialAux
                 AND
                 dt_exclusao IS NULL


    -- Calcula Produtividade
    PRINT '5'
    WHILE @dt_ini <= @Dt_fim
      BEGIN
        PRINT @dt_ini
        -- Verifica qual a clinica o dentista atende
        DECLARE cursor_d_emp CURSOR
        FOR SELECT cd_filial , cd_especialidade , CONVERT(VARCHAR(5) , hi , 114) AS hi , CONVERT(VARCHAR(5) , hf , 114) AS hf , CONVERT(VARCHAR(5) , hf - hi , 114) AS qt_hr , (SELECT COUNT(*) FROM feriado_clinico -- Verificar se é feriado
              WHERE dt_feriado = @dt_ini AND (feriado_clinico.cd_filial = atuacao_dentista_new.cd_filial OR feriado_clinico.cd_filial IS NULL) AND dt_exclusao IS NULL) , (SELECT TOP 1 ISNULL(vl_hora , 0) -- Encontra o valor da Hora caso tenha especialidade
              FROM valor_hora_dentista_interno WHERE valor_hora_dentista_interno.cd_filial = atuacao_dentista_new.cd_filial AND dt_inicio = (SELECT MAX(dt_inicio) FROM valor_hora_dentista_interno WHERE valor_hora_dentista_interno.cd_filial = atuacao_dentista_new.cd_filial AND dt_inicio <= @dt_ini AND dt_exclusao IS NULL AND (cd_funcionario = @cd_func AND valor_hora_dentista_interno.cd_especialidade = atuacao_dentista_new.cd_especialidade)) AND dt_exclusao IS NULL AND (cd_funcionario = @cd_func AND valor_hora_dentista_interno.cd_especialidade = atuacao_dentista_new.cd_especialidade) ORDER BY cd_funcionario DESC) , (SELECT TOP 1 ISNULL(vl_hora , 0) -- Encontra o valor da Hora só pelo funcionario 
              FROM valor_hora_dentista_interno WHERE valor_hora_dentista_interno.cd_filial = atuacao_dentista_new.cd_filial AND dt_inicio = (SELECT MAX(dt_inicio) FROM valor_hora_dentista_interno WHERE valor_hora_dentista_interno.cd_filial = atuacao_dentista_new.cd_filial AND dt_inicio <= @dt_ini AND dt_exclusao IS NULL AND (cd_funcionario = @cd_func AND cd_especialidade IS NULL)) AND dt_exclusao IS NULL AND (cd_funcionario = @cd_func AND cd_especialidade IS NULL) ORDER BY cd_funcionario DESC) , (SELECT TOP 1 ISNULL(vl_hora , 0) -- Encontra o valor da Hora apenas pela clinica e especialidade
              FROM valor_hora_dentista_interno WHERE valor_hora_dentista_interno.cd_filial = atuacao_dentista_new.cd_filial AND dt_inicio = (SELECT MAX(dt_inicio) FROM valor_hora_dentista_interno WHERE valor_hora_dentista_interno.cd_filial = atuacao_dentista_new.cd_filial AND dt_inicio <= @dt_ini AND dt_exclusao IS NULL AND (cd_funcionario IS NULL AND valor_hora_dentista_interno.cd_especialidade = atuacao_dentista_new.cd_especialidade)) AND dt_exclusao IS NULL AND (cd_funcionario IS NULL AND valor_hora_dentista_interno.cd_especialidade = atuacao_dentista_new.cd_especialidade) ORDER BY cd_funcionario DESC) , (SELECT TOP 1 ISNULL(vl_hora , 0) -- Encontra o valor da Hora só pela clinica 
              FROM valor_hora_dentista_interno WHERE valor_hora_dentista_interno.cd_filial = atuacao_dentista_new.cd_filial AND dt_inicio = (SELECT MAX(dt_inicio) FROM valor_hora_dentista_interno WHERE valor_hora_dentista_interno.cd_filial = atuacao_dentista_new.cd_filial AND dt_inicio <= @dt_ini AND dt_exclusao IS NULL AND (cd_funcionario = @cd_func AND cd_especialidade IS NULL)) AND dt_exclusao IS NULL AND (cd_funcionario IS NULL AND cd_especialidade IS NULL) ORDER BY cd_funcionario DESC) , CASE WHEN valor_ajuda_custo IS NULL THEN 0 ELSE valor_ajuda_custo END
          FROM atuacao_dentista_new
          WHERE cd_funcionario = @cd_func
                AND
                dt_inicio <= @dt_ini
                AND
                dt_fim >= @dt_ini
                AND
                dia_semana = DATEPART(dw , @dt_ini)
                AND
                cd_filial = @cdFilialAux
          ORDER BY cd_filial , dia_semana



        /*
        		Select cd_filial, cd_especialidade,
        				convert(varchar(5), hi, 114) as hi, convert(varchar(5), hf, 114) as hf, 
        				convert(varchar(5), hf - hi, 114) as qt_hr, 
        				(select count(*) from feriado_clinico -- Verificar se é feriado
        					where dt_feriado = @dt_ini and 
        							(feriado_clinico.cd_filial = atuacao_dentista_new.cd_filial or feriado_clinico.cd_filial is null) and 
        							dt_exclusao is null), 
        				(select top 1 isnull(vl_hora, 0) -- Encontra o valor da Hora 
        					from valor_hora_dentista_interno
        					where valor_hora_dentista_interno.cd_filial = atuacao_dentista_new.cd_filial and dt_inicio = (
        							select max(dt_inicio) from valor_hora_dentista_interno
        							where valor_hora_dentista_interno.cd_filial = atuacao_dentista_new.cd_filial and 
        									dt_inicio <= @dt_ini and dt_exclusao is null and 
        									(cd_funcionario is null or cd_funcionario = @cd_func)) and 
        							dt_exclusao is null and (cd_funcionario is null or cd_funcionario = @cd_func) 
        					order by cd_funcionario desc), 
        				case when valor_ajuda_custo is null then 0 else valor_ajuda_custo end
        		from atuacao_dentista_new 
        		where 
        			cd_funcionario = @cd_func and 
        			dt_inicio <= @dt_ini and 
        			dt_fim >= @dt_ini and 
        			dia_semana = datepart(dw, @dt_ini) and
        			cd_filial = @cdFilialAux
        		order by CD_filial, dia_semana
        */

        OPEN cursor_d_emp
        FETCH NEXT FROM cursor_d_emp INTO @cd_filial , @cd_especialidade , @hr_ini , @hr_fim , @qt_hr , @feriado , @vl_hora_func_esp , @vl_hora_func , @vl_hora_clin_esp , @vl_hora_clin , @vl_ajuda_custo

        WHILE (@@FETCH_STATUS <> -1)
          BEGIN

            SET @vl_hora = 0

            IF @vl_hora_clin IS NOT NULL
              SET @vl_hora = @vl_hora_clin

            IF @vl_hora_clin_esp IS NOT NULL
              SET @vl_hora = @vl_hora_clin_esp

            IF @vl_hora_func IS NOT NULL
              SET @vl_hora = @vl_hora_func

            IF @vl_hora_func_esp IS NOT NULL
              SET @vl_hora = @vl_hora_func_esp

            INSERT produtividade_dentista_interno_item (cd_sequencial_lote , data , cd_filial , HI , HF , cd_especialidade , vl_hora , cd_tipo , qt_hora , ajuda_custo)
                   SELECT @cd_seq , @dt_ini , @cd_filial , @hr_ini , @hr_fim , @cd_especialidade , CASE WHEN @vl_hora IS NULL THEN 0 ELSE CASE WHEN @feriado = 0 THEN @vl_hora ELSE 0 END END , CASE WHEN @feriado = 0 THEN 1 ELSE 4 END , @qt_hr , CASE WHEN @feriado = 0 THEN @vl_ajuda_custo ELSE 0 END

            FETCH NEXT FROM cursor_d_emp INTO @cd_filial , @cd_especialidade , @hr_ini , @hr_fim , @qt_hr , @feriado , @vl_hora_func_esp , @vl_hora_func , @vl_hora_clin_esp , @vl_hora_clin , @vl_ajuda_custo

          END
        DEALLOCATE cursor_d_emp
        SET @dt_ini = DATEADD(DAY , 1 , @dt_ini)
      END


    -- Calcula o valor total da produtividade e atualiza na tabela "Produtividade_dentista_interno"
    PRINT '6'
    -- Setando o atributo "vl_produtividade" para 0 (zero) para reiniciar todo o cálculo
    UPDATE Produtividade_dentista_interno
           SET vl_produtividade = 0
    WHERE cd_sequencial = @cd_seq
    -- Somando os valores das produtividades onde cd_tipo é diferente de 5

    IF (SELECT COUNT(*)
          FROM produtividade_dentista_interno_item
          WHERE cd_sequencial_lote = @cd_seq
                AND
                cd_tipo <> 5
      ) > 0
      BEGIN
        UPDATE Produtividade_dentista_interno
               SET vl_produtividade = (SELECT SUM((CONVERT(INT , LEFT(CONVERT(VARCHAR(5) , qt_hora , 108) , 2)) * vl_hora) + (CONVERT(INT , RIGHT(CONVERT(VARCHAR(5) , qt_hora , 108) , 2)) * (vl_hora / 60))) AS total
                   FROM produtividade_dentista_interno_item
                   WHERE cd_sequencial_lote = @cd_seq
                         AND
                         cd_tipo <> 5
               )
        WHERE cd_sequencial = @cd_seq
      END
    -- Somando ao valor final os valores de ajustes

    IF (SELECT COUNT(*)
          FROM produtividade_dentista_interno_item
          WHERE cd_sequencial_lote = @cd_seq
                AND
                cd_tipo = 5
      ) > 0
      BEGIN
        UPDATE Produtividade_dentista_interno
               SET vl_produtividade = ((SELECT vl_produtividade
                   FROM produtividade_dentista_interno
                   WHERE cd_sequencial = @cd_seq
               ) + (SELECT SUM(vl_hora)
                   FROM produtividade_dentista_interno_item
                   WHERE cd_sequencial_lote = @cd_seq
                         AND
                         cd_tipo = 5
               ))
        WHERE cd_sequencial = @cd_seq
      END
    -- Acrescentando o total da ajuda de custo ao total da produção, sem os descontos dos dias de falta

    IF (SELECT COUNT(*)
          FROM produtividade_dentista_interno_item
          WHERE cd_sequencial_lote = @cd_seq
                AND
                ajuda_custo IS NOT NULL
      ) > 0
      BEGIN
        UPDATE Produtividade_dentista_interno
               SET vl_produtividade = (SELECT vl_produtividade
                   FROM produtividade_dentista_interno
                   WHERE cd_sequencial = @cd_seq
               ) + (SELECT SUM(ajuda_custo)
                   FROM produtividade_dentista_interno_item
                   WHERE cd_sequencial_lote = @cd_seq
                         AND
                         ajuda_custo IS NOT NULL
                         AND
                         cd_tipo <> 2
               )
        WHERE cd_sequencial = @cd_seq
      END
    -- Descontando os valores de ajuda de custo para os dias de falta do valor total da produção

    IF (SELECT COUNT(*)
          FROM produtividade_dentista_interno_item
          WHERE cd_sequencial_lote = @cd_seq
                AND
                ajuda_custo IS NOT NULL
                AND
                cd_tipo = 2
      ) > 0
      BEGIN
        UPDATE Produtividade_dentista_interno
               SET vl_produtividade = ((SELECT vl_produtividade
                   FROM produtividade_dentista_interno
                   WHERE cd_sequencial = @cd_seq
               ) - (SELECT SUM(ajuda_custo)
                   FROM produtividade_dentista_interno_item
                   WHERE cd_sequencial_lote = @cd_seq
                         AND
                         data IN (SELECT data
                             FROM produtividade_dentista_interno_item
                             WHERE cd_sequencial_lote = @cd_seq
                                   AND
                                   cd_tipo = 2
                         )
               ))
        WHERE cd_sequencial = @cd_seq
      END

  END
