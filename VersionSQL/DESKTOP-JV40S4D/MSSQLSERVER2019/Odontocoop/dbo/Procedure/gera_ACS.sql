/****** Object:  Procedure [dbo].[gera_ACS]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROC dbo.gera_ACS
AS
-- =============================================
-- Author:      henrique.almeida
-- Create date: 13/09/2021 09:33
-- Database:    S4ECLEAN
-- Description: REALIZADO PADRONIZAÇÃO E FORMATAÇÃO DE ESTILO T-SQL
-- =============================================


  BEGIN

    DECLARE @v_dia INT
    DECLARE @v_venc DATETIME
    DECLARE @seq INT , @qt INT , @valor MONEY , @dtvenc DATETIME , @dia INT , @dtref DATETIME
    DECLARE @dtvenc_a DATETIME

    BEGIN TRANSACTION

    PRINT 1

    /* vencimento */
    /*if day(getdate())> 20 */
    SET @dtref = DATEADD(MONTH , 1 , GETDATE())
    /*else
    	set @dtref=getdate()*/

    PRINT 2

    SELECT @dia = DT_VENCIMENTO
    FROM EMPRESA
    WHERE CD_EMPRESA = 100919
    SELECT @dtvenc = CONVERT(DATETIME , CONVERT(VARCHAR(2) , MONTH(@dtref)) + '/' + CONVERT(VARCHAR(2) , @dia) + '/' + CONVERT(VARCHAR(4) , YEAR(@dtref)))
    SET @dtvenc_a = DATEADD(MONTH , -1 , @dtvenc)

    PRINT @dtvenc
    PRINT @dtvenc_a

    /* gera tabela sequência */

    IF (SELECT COUNT(0)
          FROM acs_reader
          WHERE dt_envio IS NULL
      ) = 0
      INSERT INTO acs_reader (cd_sequencial , dt_geracao)
             SELECT ISNULL(MAX(cd_sequencial) + 1 , 1) , GETDATE()
             FROM acs_reader
    ELSE
      UPDATE acs_reader
             SET dt_geracao = GETDATE()
      WHERE dt_envio IS NULL

    PRINT 4

    SELECT @seq = cd_sequencial
    FROM acs_reader
    WHERE dt_envio IS NULL

    PRINT 5

    DELETE FROM acs_registro
    WHERE cd_sequencial = @seq

    --id_situação	
    --0 Normal
    --6 Alterar valor 
    --5 Exclusão

    PRINT @seq
    PRINT @dtvenc

    --Normal
    INSERT INTO acs_registro (cd_sequencial , CD_ASSOCIADO , nr_matricula , nr_contrato , dt_assinatura , aaaa_mm_pagamento , VL_PARCELA , cd_situacao , CD_PARCELA)
           SELECT @seq , CD_ASSOCIADO , LEFT(REPLACE(REPLACE(nu_matricula , '.' , '') , '-' , '') , 11) nu_matricula , LEFT(RTRIM(LTRIM(REPLACE(nr_contrato , 'FTZ' , ''))) , 6) nr_contrato , dt_assinatura_contrato , CONVERT(VARCHAR(6) , DATEADD(MONTH , -1 , MENSALIDADES.dt_vencimento) , 112) AS mm_aaaa_1pagamento , VL_PARCELA , 0 , CD_PARCELA
           FROM ASSOCIADOS INNER JOIN MENSALIDADES ON MENSALIDADES.CD_ASSOCIADO_empresa = ASSOCIADOS.CD_ASSOCIADO
                         AND
                         MENSALIDADES.TP_ASSOCIADO_EMPRESA = 1
                         AND
                         MENSALIDADES.dt_vencimento >= @dtvenc
                         AND
                         MENSALIDADES.dt_vencimento <= @dtvenc
           WHERE ASSOCIADOS.CD_EMPRESA = 100919
                 AND
                 CD_PARCELA < 32000
                 AND
                 VL_PARCELA > 0
                 AND
                 CD_TIPO_RECEBIMENTO = 0
           ORDER BY CD_PARCELA

    --Cancelados
    INSERT INTO acs_registro (cd_sequencial , CD_ASSOCIADO , nr_matricula , nr_contrato , dt_assinatura , aaaa_mm_pagamento , VL_PARCELA , cd_situacao , CD_PARCELA)
           SELECT @seq , CD_ASSOCIADO , LEFT(REPLACE(REPLACE(nu_matricula , '.' , '') , '-' , '') , 11) nu_matricula , LEFT(RTRIM(LTRIM(REPLACE(nr_contrato , 'FTZ' , ''))) , 6) nr_contrato , dt_assinatura_contrato , CONVERT(VARCHAR(6) , MENSALIDADES.dt_vencimento , 112) AS mm_aaaa_1pagamento , 0 , 5 , CD_PARCELA
           FROM ASSOCIADOS INNER JOIN MENSALIDADES ON MENSALIDADES.CD_ASSOCIADO_empresa = ASSOCIADOS.CD_ASSOCIADO
                         AND
                         MENSALIDADES.TP_ASSOCIADO_EMPRESA = 1
                         AND
                         MENSALIDADES.dt_vencimento >= @dtvenc_a
                         AND
                         MENSALIDADES.dt_vencimento <= @dtvenc_a + ' 23:59'
           WHERE ASSOCIADOS.CD_EMPRESA = 100919
                 AND
                 CD_PARCELA < 32000
                 AND
                 VL_PARCELA > 0
                 AND
                 CD_TIPO_RECEBIMENTO = 0
                 AND
                 CD_ASSOCIADO NOT IN (SELECT CD_ASSOCIADO
                     FROM ASSOCIADOS INNER JOIN MENSALIDADES ON MENSALIDADES.CD_ASSOCIADO_empresa = ASSOCIADOS.CD_ASSOCIADO
                       AND
                       MENSALIDADES.TP_ASSOCIADO_EMPRESA = 1
                       AND
                       MENSALIDADES.dt_vencimento >= @dtvenc
                       AND
                       MENSALIDADES.dt_vencimento <= @dtvenc + ' 23:59'
                     WHERE ASSOCIADOS.CD_EMPRESA = 100919
                           AND
                           CD_PARCELA < 32000
                           AND
                           VL_PARCELA > 0
                           AND
                           CD_TIPO_RECEBIMENTO = 0
                 )

    -- Cancelado Manualmente
    INSERT INTO acs_registro (cd_sequencial , CD_ASSOCIADO , nr_matricula , nr_contrato , dt_assinatura , aaaa_mm_pagamento , VL_PARCELA , cd_situacao , CD_PARCELA)
           SELECT @seq , CD_ASSOCIADO , LEFT(REPLACE(REPLACE(nu_matricula , '.' , '') , '-' , '') , 11) nu_matricula , LEFT(RTRIM(LTRIM(REPLACE(nr_contrato , 'FTZ' , ''))) , 6) nr_contrato , dt_assinatura_contrato , CONVERT(VARCHAR(6) , @dtvenc , 112) AS mm_aaaa_1pagamento , 0 , 5 , 1
           FROM ASSOCIADOS
           WHERE CD_ASSOCIADO IN (
                 173196 , 168969 , 168972 , 170644 , 156893 , 106759 , 173880 , 161474 , 161061 , 161026 , 161031 , 159833 , 167841 , 166104 , 161045 , 159758 , 161079 , 166626 , 160736 , 161807 , 196712 , 259417 , 159217 , 176415 , 172196 , 157175 , 165364 , 259833 , 161025 , 191294 , 161058 , 163733 , 174523 , 159486 , 257889 , 159320 , 163261 , 161045 , 159829 ,
                 163733 , 257292 , 257889 , 159701 , 259438 , 278322 , 172499 , 169736 , 168963 , 168988 , 159767 , 161061 , 163239 ,
                 167101 , 167965 , 278322 , 160469 , 162174 , 262088 , 163024 , 197670 , 169453 , 160648 , 261105
                 )
                 AND
                 CD_ASSOCIADO NOT IN (SELECT CD_ASSOCIADO
                     FROM acs_registro
                     WHERE cd_sequencial = @seq
                 )


    -- Alterados
    UPDATE acs_registro
           SET cd_situacao = 6
    WHERE cd_sequencial = @seq
           AND
           cd_situacao = 0
           AND
           CD_ASSOCIADO IN (SELECT x.CD_ASSOCIADO
               FROM (SELECT CD_ASSOCIADO , nm_responsavel , MENSALIDADES.VL_PARCELA
                   FROM ASSOCIADOS INNER JOIN MENSALIDADES ON MENSALIDADES.CD_ASSOCIADO_empresa = ASSOCIADOS.CD_ASSOCIADO
                     AND
                     MENSALIDADES.TP_ASSOCIADO_EMPRESA = 1
                     AND
                     MENSALIDADES.dt_vencimento >= @dtvenc_a
                     AND
                     MENSALIDADES.dt_vencimento <= @dtvenc_a + ' 23:59'
                   WHERE ASSOCIADOS.CD_EMPRESA = 100919
                         AND
                         CD_PARCELA < 32000
                         AND
                         VL_PARCELA > 0
                         AND
                         CD_TIPO_RECEBIMENTO = 0
               ) AS x , (SELECT CD_ASSOCIADO , nm_responsavel , MENSALIDADES.VL_PARCELA
                   FROM ASSOCIADOS INNER JOIN MENSALIDADES ON MENSALIDADES.CD_ASSOCIADO_empresa = ASSOCIADOS.CD_ASSOCIADO
                     AND
                     MENSALIDADES.TP_ASSOCIADO_EMPRESA = 1
                     AND
                     MENSALIDADES.dt_vencimento >= @dtvenc
                     AND
                     MENSALIDADES.dt_vencimento <= @dtvenc + ' 23:59'
                   WHERE ASSOCIADOS.CD_EMPRESA = 100919
                         AND
                         CD_PARCELA < 32000
                         AND
                         VL_PARCELA > 0
                         AND
                         CD_TIPO_RECEBIMENTO = 0
               ) AS y
               WHERE x.CD_ASSOCIADO = y.CD_ASSOCIADO
                     AND
                     x.VL_PARCELA > y.VL_PARCELA
           )

    -- Alterados Manualmente
    UPDATE acs_registro
           SET cd_situacao = 6
    WHERE cd_sequencial = @seq
           AND
           cd_situacao = 0
           AND
           CD_ASSOCIADO IN (165598 , 157899 , 208583 , 159480 , 157828 , 208582 , 375245
           )

    PRINT 7

    COMMIT

  END
