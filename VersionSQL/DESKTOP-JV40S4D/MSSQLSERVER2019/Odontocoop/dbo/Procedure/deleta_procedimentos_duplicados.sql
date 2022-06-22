/****** Object:  Procedure [dbo].[deleta_procedimentos_duplicados]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE dbo.deleta_procedimentos_duplicados
-- =============================================
-- Author:      henrique.almeida
-- Create date: 10/09/2021 11:06
-- Database:    S4ECLEAN
-- Description: REALIZADO PADRONIZAÇÃO E FORMATAÇÃO DE ESTILO T-SQL
-- REALIZAR DOCUMENTAÇÃO DA PROCEDURE
-- =============================================




AS
  BEGIN

    DECLARE @cdseq INT

    DECLARE cursor_pp CURSOR
    FOR SELECT cd_sequencial
      FROM procedimentos_pendentes
      WHERE cd_associado = 105827
            AND
            dt_servico = '01/01/1900'
            AND
            cd_sequencial != 207417
            AND
            cd_servico = 910
      UNION
      SELECT cd_sequencial
      FROM procedimentos_pendentes
      WHERE cd_associado = 105827
            AND
            dt_servico = '01/01/1900'
            AND
            cd_sequencial NOT IN (207417 , 213023)
            AND
            cd_servico = 910
      UNION
      SELECT cd_sequencial
      FROM procedimentos_pendentes
      WHERE cd_associado = 106552
            AND
            dt_servico = '01/01/1900'
            AND
            cd_sequencial != 276161
            AND
            cd_servico = 920
            AND
            cd_UD = 25
      UNION
      SELECT cd_sequencial
      FROM procedimentos_pendentes
      WHERE cd_associado = 105866
            AND
            dt_servico = '01/01/1900'
            AND
            cd_sequencial != 177593
            AND
            cd_servico = 910
      UNION
      SELECT cd_sequencial
      FROM procedimentos_pendentes
      WHERE cd_associado = 106777
            AND
            dt_servico = '01/01/1900'
            AND
            cd_sequencial != 264993
            AND
            cd_servico = 970
      UNION
      SELECT cd_sequencial
      FROM procedimentos_pendentes
      WHERE cd_associado = 108078
            AND
            dt_servico = '01/01/1900'
            AND
            cd_sequencial != 733183
            AND
            cd_servico = 510
      UNION
      SELECT cd_sequencial
      FROM procedimentos_pendentes
      WHERE cd_associado = 108571
            AND
            dt_servico = '01/01/1900'
            AND
            cd_sequencial NOT IN (303827 , 323865)
            AND
            cd_servico IN (3010 , 910)
      UNION
      SELECT cd_sequencial
      FROM procedimentos_pendentes
      WHERE cd_associado = 109165
            AND
            dt_servico = '01/01/1900'
            AND
            cd_sequencial != 380942
            AND
            cd_servico = 3010
      UNION
      SELECT cd_sequencial
      FROM procedimentos_pendentes
      WHERE cd_associado = 111750
            AND
            dt_servico = '01/01/1900'
            AND
            cd_sequencial != 691916
            AND
            cd_servico = 510
      UNION
      SELECT cd_sequencial
      FROM procedimentos_pendentes
      WHERE cd_associado = 113766
            AND
            dt_servico = '01/01/1900'
            AND
            cd_sequencial != 401962
            AND
            cd_servico = 510
      UNION
      SELECT cd_sequencial
      FROM procedimentos_pendentes
      WHERE cd_associado = 114215
            AND
            dt_servico = '01/01/1900'
            AND
            cd_sequencial != 423329
            AND
            cd_servico = 910
      UNION
      SELECT cd_sequencial
      FROM procedimentos_pendentes
      WHERE cd_associado = 120081
            AND
            dt_servico = '01/01/1900'
            AND
            cd_sequencial != 521420
            AND
            cd_servico = 620
            AND
            cd_UD = 46
      UNION
      SELECT cd_sequencial
      FROM procedimentos_pendentes
      WHERE cd_associado = 120388
            AND
            dt_servico = '01/01/1900'
            AND
            cd_sequencial != 534599
            AND
            cd_servico = 510
      UNION
      SELECT cd_sequencial
      FROM procedimentos_pendentes
      WHERE cd_associado = 124508
            AND
            dt_servico = '01/01/1900'
            AND
            cd_sequencial != 666852
            AND
            cd_servico = 970
      UNION
      SELECT cd_sequencial
      FROM procedimentos_pendentes
      WHERE cd_associado = 128906
            AND
            dt_servico = '01/01/1900'
            AND
            cd_sequencial != 833442
            AND
            cd_servico = 910
      UNION
      SELECT cd_sequencial
      FROM procedimentos_pendentes
      WHERE cd_associado = 132690
            AND
            dt_servico = '01/01/1900'
            AND
            cd_sequencial != 885602
            AND
            cd_servico = 910
            AND
            cd_UD = 35


    OPEN cursor_pp
    FETCH NEXT FROM cursor_pp INTO @cdseq
    WHILE (@@fetch_status <> -1)
      BEGIN
        BEGIN TRANSACTION
        DELETE FROM procedimentos_pendentes
        WHERE cd_sequencial = @cdseq
        COMMIT TRANSACTION

        FETCH NEXT FROM cursor_pp INTO @cdseq
      END
    DEALLOCATE cursor_pp

  END
