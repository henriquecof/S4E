/****** Object:  Procedure [dbo].[BI_Empresa]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE dbo.BI_Empresa
AS
  BEGIN

    /***
    ESSA PROCEDURE REALIZA O DELETE NA TABELA PREVSYSTEMBI..EMPRESA.
    APOS SER REALIZADO O DELETE NA TABELA, É EXECUTADO UM INSERT BASEADO NO SELECT. ESSE SELECT USADO REFERENCIA
    A TABELA EMPRESA.
    ***/

-- =============================================
-- Author:      henrique.almeida
-- Create date: 10/09/2021 08:43
-- Database:    S4ECLEAN
-- Description: REALIZADO PADRONIZAÇÃO E FORMATAÇÃO NO ESTILO T-SQL
-- =============================================



    DELETE PrevsystemBI..EMPRESA

    INSERT PrevsystemBI..EMPRESA (Codigo , Nome , data_contrato , ano_contrato , mes_contrato , dt_cancelamento , ano_cancelamento , mes_cancelamento , UF , MUNICIPIO , Regiao)
           SELECT e.cd_empresa , NM_FANTASIA , DT_FECHAMENTO_CONTRATO , YEAR(DT_FECHAMENTO_CONTRATO) AS ano_fechamento , MONTH(DT_FECHAMENTO_CONTRATO) AS mes_fechamento , CASE WHEN h.cd_situacao = 2 THEN CONVERT(VARCHAR(10) , h.dt_situacao , 101) ELSE NULL END AS dt_cancelamento , CASE WHEN h.cd_situacao = 2 THEN YEAR(h.dt_situacao) ELSE NULL END AS ano_cancelamento , CASE WHEN h.cd_situacao = 2 THEN MONTH(h.dt_situacao) ELSE NULL END AS mes_cancelamento , ISNULL(uf.ufSigla , 'Não informado') AS uf , ISNULL(m.NM_MUNICIPIO , 'Não informado') AS Municipio , ISNULL(r.ds_regiao , 'Não informado') AS Região
           FROM EMPRESA AS e INNER JOIN HISTORICO AS h ON e.CD_Sequencial_historico = h.cd_sequencial LEFT JOIN uf ON e.ufId = uf.ufId LEFT JOIN Municipio AS m ON e.cd_municipio = m.cd_municipio LEFT JOIN Regiao AS r ON m.id_regiao = r.id_regiao
           WHERE TP_EMPRESA = 2

  END
