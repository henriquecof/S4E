/****** Object:  Procedure [dbo].[PS_ConsultaFaturaResumida]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:      henrique.almeida
-- Create date: 17/09/2021 09:47
-- Database:    S4ECLEAN
-- Description: REALIZADO PADRONIZAÇÃO E FORMATAÇÃO DE ESTILO T-SQL
-- REALIZAR DOCUMENTAÇÃO DA PROCEDURE USANDO EXTENDED PROPERTIES
-- =============================================


CREATE PROCEDURE dbo.PS_ConsultaFaturaResumida (@Empresa INT,
@DT_Vencimento VARCHAR(10),
@tipoRelatorio TINYINT = 1)
AS
BEGIN
  --@tipoRelatorio  
  --1: Agrupado por titular  
  --2: Detalhado por usuário  
  DECLARE @cd_parc INT
  DECLARE @cd_parc_ant INT
  DECLARE @Dt_VencAnt DATETIME

  SELECT
    @Dt_VencAnt = DATEADD(MONTH, -1, @DT_Vencimento)

  SELECT
    @Dt_VencAnt = CONVERT(DATETIME, CONVERT(VARCHAR(2), MONTH(@Dt_VencAnt)) + '/01/' + CONVERT(VARCHAR(4), YEAR(@Dt_VencAnt)))

  DELETE ConsultaFaturaResumida
  WHERE cd_empresa = @Empresa

  SELECT
    @cd_parc = cd_parcela
  FROM MENSALIDADES
  WHERE CD_ASSOCIADO_empresa = @Empresa
  AND cd_tipo_parcela = 1
  AND CD_TIPO_RECEBIMENTO NOT IN (1, 2)
  AND TP_ASSOCIADO_EMPRESA = 2
  AND DT_VENCIMENTO >= @DT_Vencimento
  AND DT_VENCIMENTO <= @DT_Vencimento + ' 23:59'

  SELECT
    @cd_parc_ant = cd_parcela
  FROM MENSALIDADES
  WHERE CD_ASSOCIADO_empresa = @Empresa
  AND cd_tipo_parcela = 1
  AND CD_TIPO_RECEBIMENTO NOT IN (1, 2)
  AND TP_ASSOCIADO_EMPRESA = 2
  AND DT_VENCIMENTO >= @Dt_VencAnt
  AND DT_VENCIMENTO < DATEADD(MONTH, 1, @Dt_VencAnt)

  IF (@tipoRelatorio = 1)
  BEGIN
    INSERT INTO ConsultaFaturaResumida (cd_empresa,
    tipo,
    cd_associado,
    valor)
      SELECT
        @Empresa
       ,1
       ,d.cd_associado
       ,SUM(m.valor)
      FROM Mensalidades_Planos AS m
      INNER JOIN DEPENDENTES AS d
        ON m.cd_sequencial_dep = d.cd_sequencial
      WHERE m.cd_parcela_mensalidade = @cd_parc
      AND m.dt_exclusao IS NULL
      GROUP BY d.cd_associado

      UNION

      SELECT
        @Empresa
       ,2
       ,d.cd_associado
       ,SUM(m.valor)
      FROM Mensalidades_Planos AS m
      INNER JOIN DEPENDENTES AS d
        ON m.cd_sequencial_dep = d.cd_sequencial
      WHERE m.cd_parcela_mensalidade = @cd_parc_ant
      AND m.dt_exclusao IS NULL
      GROUP BY d.cd_associado
  END

  IF (@tipoRelatorio = 2)
  BEGIN
    INSERT INTO ConsultaFaturaResumida (cd_empresa,
    tipo,
    cd_associado,
    valor,
    cd_sequencial_dep)
      SELECT
        @Empresa
       ,1
       ,d.cd_associado
       ,SUM(m.valor)
       ,d.cd_sequencial
      FROM Mensalidades_Planos AS m
      INNER JOIN DEPENDENTES AS d
        ON m.cd_sequencial_dep = d.cd_sequencial
      WHERE m.cd_parcela_mensalidade = @cd_parc
      AND m.dt_exclusao IS NULL
      GROUP BY d.cd_associado
              ,d.cd_sequencial

      UNION

      SELECT
        @Empresa
       ,2 AS tipo
       ,d.cd_associado
       ,SUM(m.valor)
       ,d.cd_sequencial
      FROM Mensalidades_Planos AS m
      INNER JOIN DEPENDENTES AS d
        ON m.cd_sequencial_dep = d.cd_sequencial
      WHERE m.cd_parcela_mensalidade = @cd_parc_ant
      AND m.dt_exclusao IS NULL
      GROUP BY d.cd_associado
              ,d.cd_sequencial
  END
END
