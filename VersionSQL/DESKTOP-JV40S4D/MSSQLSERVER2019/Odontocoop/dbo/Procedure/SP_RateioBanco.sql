/****** Object:  Procedure [dbo].[SP_RateioBanco]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[SP_RateioBanco] @dtini DATETIME,
	@dtfim DATETIME,
	@convenio VARCHAR(100)
AS
BEGIN
	SET @dtfim = convert(DATETIME, convert(VARCHAR(10), @dtfim, 101) + ' 23:59:59')

	-- Declare @convenio varchar(100) = '13650'
	SELECT T1.cd_sequencial_retorno,
		t6.nm_arquivo,
		T6.convenio,
		t1.dt_pago,
		t6.dt_processado,
		count(0) AS Qtde,
		sum(t1.vl_pago) AS Valor,
		sum(t1.vl_tarifa) AS Tarifa,
		isnull((
				SELECT SUM(vl_pago * (t50.per_retencao)) / 100
				FROM TIPO_PAGAMENTO T40,
					Perc_Tipo_Pagamento T50,
					Lote_Processos_Bancos_Retorno_Mensalidades T10
				WHERE t40.convenio = @convenio
					AND T40.cd_tipo_pagamento = T50.cd_tipo_pagamento
					AND t10.cd_sequencial_retorno = T1.cd_sequencial_retorno
					AND SUBSTRING(t10.nn, 3, 1) = t40.VariacaoCarteira
				), 0) AS Repasse,
		(
			SELECT count(0)
			FROM Lote_Processos_Bancos_Retorno_Mensalidades T100
			WHERE -- t40.convenio = '13650'
				--and T40.cd_tipo_pagamento = T50.cd_tipo_pagamento  
				t100.cd_sequencial_retorno = T1.cd_sequencial_retorno
				AND SUBSTRING(t100.nn, 3, 1) NOT IN (
					SELECT t400.VariacaoCarteira
					FROM TIPO_PAGAMENTO T400,
						Perc_Tipo_Pagamento T500
					WHERE t400.convenio = @convenio
						AND T400.cd_tipo_pagamento = T500.cd_tipo_pagamento
					)
			) AS ErroRepasse,
		(
			SELECT count(0)
			FROM TIPO_PAGAMENTO T4000,
				Perc_Tipo_Pagamento T5000
			WHERE t4000.convenio = @convenio
				AND T4000.cd_tipo_pagamento = T5000.cd_tipo_pagamento
			) AS QtdeVariacao
	FROM Lote_Processos_Bancos_Retorno_Mensalidades AS T1
	INNER JOIN DEB_AUTOMATICO_CR AS T2 ON T1.cd_ocorrencia = T2.cd_ocorrencia
	INNER JOIN MENSALIDADES AS T3 ON T1.cd_parcela = T3.CD_PARCELA
	INNER JOIN DEPENDENTES AS T4 ON T3.CD_ASSOCIADO_empresa = T4.CD_ASSOCIADO
	LEFT OUTER JOIN FUNCIONARIO AS T5 ON T4.cd_funcionario_dentista = T5.cd_funcionario
	INNER JOIN TIPO_PAGAMENTO AS T7 ON T3.CD_TIPO_PAGAMENTO = T7.cd_tipo_pagamento
	INNER JOIN Lote_Processos_Bancos_Retorno AS T6 ON T1.cd_sequencial_retorno = T6.cd_sequencial_retorno
	INNER JOIN PLANOS AS t9 ON T4.cd_plano = t9.cd_plano
	WHERE (T4.CD_GRAU_PARENTESCO = 1)
		AND (T1.cd_ocorrencia = 0)
		AND (T6.convenio = @convenio)
		AND (T1.dt_pago >= @dtini)
		AND (T1.dt_pago <= @dtfim)
		AND (T6.qtde IS NOT NULL)
		AND (t9.fl_exige_dentista = 1)
	GROUP BY T6.dt_processado,
		T1.cd_sequencial_retorno,
		T6.nm_arquivo,
		T6.convenio,
		T1.dt_pago
	ORDER BY T1.dt_pago,
		T6.dt_processado
END
