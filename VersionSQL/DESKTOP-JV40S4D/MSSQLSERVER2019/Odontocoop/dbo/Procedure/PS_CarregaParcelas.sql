/****** Object:  Procedure [dbo].[PS_CarregaParcelas]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:      henrique.almeida
-- Create date: 2022-04-05 14:28:31
-- Database:    S4ECLEAN
-- Description: REALIZADO CORREÇÃO T-SQL PARA AJUSTE DO BANCO NA MIGRAÇÃO PARA SQL SERVER 2019
-- =============================================



CREATE PROCEDURE [dbo].[PS_CarregaParcelas] (
		@tipo_cliente SMALLINT,
		@associado INT)
AS
BEGIN

	IF @tipo_cliente = 1
	BEGIN
		SELECT T1.cd_parcela,
			   T4.nm_completo AS ASSOCIADO,
			   CONVERT(VARCHAR(10), T1.dt_vencimento, 103) AS DATA_VENCIMENTO,
			   CONVERT(DECIMAL(10, 2), T1.vl_parcela + ISNULL(T1.vl_acrescimo, 0) - ISNULL(T1.vl_desconto, 0) - ISNULL(T1.vl_jurosmultareferencia, 0)) AS PARCELA,
			   CASE
				  WHEN DATEDIFF(DAY, T1.dt_vencimento, GETDATE()) > 0
				  THEN DATEDIFF(DAY, T1.dt_vencimento, GETDATE())
				  ELSE 0
			   END AS DIAS_ATRASO,
			   CASE
				  WHEN DATEDIFF(DAY, T1.dt_vencimento, GETDATE()) > 0
				  THEN CONVERT(DECIMAL(10, 2), T1.vl_parcela * (SELECT ISNULL(T100.perc_multa, 0)
						  FROM dbo.TIPO_PAGAMENTO T100
						  WHERE T100.cd_tipo_pagamento = T1.cd_tipo_pagamento) / 100)
				  ELSE 0
			   END AS MULTA,
			   CASE
				  WHEN DATEDIFF(DAY, T1.dt_vencimento, GETDATE()) > 0
				  THEN CONVERT(DECIMAL(10, 2), (((T1.vl_parcela * ISNULL(T2.perc_juros, 0)) / 30) / 100) * DATEDIFF(DAY, T1.dt_vencimento, GETDATE()))
				  ELSE 0
			   END AS JUROS,
			   T2.nm_tipo_pagamento AS TIPO_PAGAMENTO,
			   T3.ds_tipo_parcela,
			   T3.nm_cor
		FROM dbo.mensalidades AS T1
			INNER JOIN dbo.TIPO_PAGAMENTO AS T2 ON T1.cd_tipo_pagamento = T2.cd_tipo_pagamento
			INNER JOIN dbo.tipo_parcela AS T3 ON T1.cd_tipo_parcela = T3.cd_tipo_parcela
			INNER JOIN dbo.associados AS T4 ON T1.cd_associado_empresa = T4.cd_associado
		WHERE (T1.cd_associado_empresa = @associado)
		AND (T1.tp_associado_empresa = 1)
		AND (T1.dt_pagamento IS NULL)
		AND (T1.cd_tipo_recebimento IN (0, 15))
		ORDER BY T1.cd_parcela
	END
	ELSE
	BEGIN
		/*Pagamentos em aberto de empresas */
		SELECT T1.cd_parcela,
			   T4.nm_razsoc AS ASSOCIADO,
			   CONVERT(VARCHAR(10), T1.dt_vencimento, 103) AS DATA_VENCIMENTO,
			   CONVERT(DECIMAL(10, 2), T1.vl_parcela + ISNULL(T1.vl_acrescimo, 0) - ISNULL(T1.vl_desconto, 0) - ISNULL(T1.vl_jurosmultareferencia, 0)) AS PARCELA,
			   CASE
				  WHEN DATEDIFF(DAY, T1.dt_vencimento, GETDATE()) > 0
				  THEN DATEDIFF(DAY, T1.dt_vencimento, GETDATE())
				  ELSE 0
			   END AS DIAS_ATRASO,
			   CASE
				  WHEN DATEDIFF(DAY, T1.dt_vencimento, GETDATE()) > 0
				  THEN CONVERT(DECIMAL(10, 2), T1.vl_parcela * (SELECT ISNULL(T100.perc_multa, 0)
						  FROM dbo.TIPO_PAGAMENTO T100
						  WHERE T100.cd_tipo_pagamento = T1.cd_tipo_pagamento) / 100)
				  ELSE 0
			   END AS MULTA,
			   CASE
				  WHEN DATEDIFF(DAY, T1.dt_vencimento, GETDATE()) > 0
				  THEN CONVERT(DECIMAL(10, 2), (((T1.vl_parcela * ISNULL(T2.perc_juros, 0)) / 30) / 100) * DATEDIFF(DAY, T1.dt_vencimento, GETDATE()))
				  ELSE 0
			   END AS JUROS,
			   T2.nm_tipo_pagamento AS TIPO_PAGAMENTO,
			   T3.ds_tipo_parcela,
			   T3.nm_cor
		FROM dbo.mensalidades AS T1
			INNER JOIN dbo.TIPO_PAGAMENTO AS T2 ON T1.cd_tipo_pagamento = T2.cd_tipo_pagamento
			INNER JOIN dbo.tipo_parcela AS T3 ON T1.cd_tipo_parcela = T3.cd_tipo_parcela
			INNER JOIN dbo.empresa AS T4 ON T1.cd_associado_empresa = T4.cd_empresa
		WHERE (T1.cd_associado_empresa = @associado)
		AND (T1.tp_associado_empresa = @tipo_cliente)
		AND (T1.dt_pagamento IS NULL)
		AND (T1.cd_tipo_recebimento IN (0, 15))
		ORDER BY T1.cd_parcela
	END
END
