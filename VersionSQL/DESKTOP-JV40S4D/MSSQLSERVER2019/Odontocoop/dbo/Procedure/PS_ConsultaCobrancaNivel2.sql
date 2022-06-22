/****** Object:  Procedure [dbo].[PS_ConsultaCobrancaNivel2]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:      henrique.almeida
-- Create date: 17/09/2021 09:43
-- Database:    S4ECLEAN
-- Description: REALIZADO PADRONIZAÇÃO E FORMATAÇÃO DE ESTILO T-SQL
-- REALIZAR DOCUMENTAÇÃO DA PROCEDURE USANDO EXTENDED PROPERITES
-- =============================================


CREATE PROCEDURE [dbo].[PS_ConsultaCobrancaNivel2] (
	@DataInicial DATETIME,
	@DataFinal DATETIME,
	@TipoPessoa SMALLINT,
	@Faixa SMALLINT,
	@Tipo SMALLINT,
	@NomeUsuario VARCHAR(20))
AS BEGIN

		IF (@Tipo = 1)
		AND ( (@TipoPessoa = 1)
		OR (@TipoPessoa = 3) ) BEGIN
			/*Total de cobrancas feitas pagas*/
			--SELECT
			--         	t1.sequencial ,
			--         	T2.VL_PARCELA ,
			--         	t3.cd_associado AS codigo ,
			--         	t3.nm_completo AS nome ,
			--         	t4.cd_parcela ,
			--         	CONVERT(VARCHAR(10), t4.Data_Vencimento, 103) AS data ,
			--         	t4.dias_atraso ,
			--         	t5.ds_comentario ,
			--         	CASE WHEN ( t4.cd_parcela >= 1
			--         		AND t1.cd_parcela <= 31999 ) THEN 'Plano'
			--         		 WHEN ( t4.cd_parcela >= 32000
			--         		AND t1.cd_parcela <= 63999 ) THEN 'Serviço Opcional'
			--         		 WHEN ( t4.cd_parcela >= 64000
			--         		AND t1.cd_parcela <= 95999 ) THEN 'Orçamento'
			--         		 WHEN ( t4.cd_parcela >= 96000
			--         		AND t1.cd_parcela <= 127999 ) THEN 'Acordo'
			--         		 WHEN ( t4.cd_parcela >= 128000
			--         		AND t1.cd_parcela <= 159999 ) THEN 'Plano Ortodôtico'
			--         		 WHEN ( t4.cd_parcela >= 160000
			--         		AND t1.cd_parcela <= 191999 ) THEN 'Parcelas Geradas' END AS tipo_plano ,
			--         	CONVERT(VARCHAR(10), T2.DT_PAGAMENTO, 103) AS data_pagamento
			--         FROM TB_ListaAtrasadosUsuario t1,
			--         	MENSALIDADES T2,
			--         	ASSOCIADOS t3,
			--         	TB_ParcelasAtrasadasUsuario t4,
			--         	Comentario t5
			--         WHERE t1.Status > 0
			--         AND t1.codigo = T2.CD_ASSOCIADO_empresa
			--         AND T2.TP_ASSOCIADO_EMPRESA = 1
			--         AND t1.tipo_pessoa IN (1, 3)
			--         AND t1.data_gerado BETWEEN @DataInicial AND @DataFinal
			--         AND T2.DT_PAGAMENTO IS NOT NULL
			--         AND t1.Faixa_dias_atrasado = @Faixa
			--         AND t1.nome_usuario = @NomeUsuario
			--         AND t1.codigo = t3.cd_associado
			--         AND t1.sequencial = t4.sequencial
			--         AND t1.sequencial = t5.sequencial
			--         AND t5.cd_sequencial = (SELECT
			--                                 	MAX(cd_sequencial)
			--                                 FROM Comentario t100
			--                                 WHERE t1.sequencial = t100.sequencial)
			--         AND t4.cd_parcela = T2.cd_parcela
			--         ORDER BY t1.sequencial

			SELECT
            	t1.sequencial ,
            	T2.VL_PARCELA ,
            	t3.cd_associado AS codigo ,
            	t3.nm_completo AS nome ,
            	t4.cd_parcela ,
            	CONVERT(VARCHAR(10), t4.Data_Vencimento, 103) AS data ,
            	t4.dias_atraso ,
            	t5.ds_comentario ,
            	CASE WHEN ( t4.cd_parcela >= 1
            		AND t1.cd_parcela <= 31999 ) THEN 'Plano'
            		 WHEN ( t4.cd_parcela >= 32000
            		AND t1.cd_parcela <= 63999 ) THEN 'Serviço Opcional'
            		 WHEN ( t4.cd_parcela >= 64000
            		AND t1.cd_parcela <= 95999 ) THEN 'Orçamento'
            		 WHEN ( t4.cd_parcela >= 96000
            		AND t1.cd_parcela <= 127999 ) THEN 'Acordo'
            		 WHEN ( t4.cd_parcela >= 128000
            		AND t1.cd_parcela <= 159999 ) THEN 'Plano Ortodôtico'
            		 WHEN ( t4.cd_parcela >= 160000
            		AND t1.cd_parcela <= 191999 ) THEN 'Parcelas Geradas' END AS tipo_plano ,
            	CONVERT(VARCHAR(10), T2.DT_PAGAMENTO, 103) AS data_pagamento
            FROM TB_ListaAtrasadosUsuario AS t1
            	INNER JOIN MENSALIDADES AS T2 ON t1.codigo = T2.CD_ASSOCIADO_empresa
            	INNER JOIN ASSOCIADOS AS t3 ON t1.codigo = t3.cd_associado
            	INNER JOIN Comentario AS t5 ON t1.sequencial = t5.sequencial
            	CROSS JOIN TB_ParcelasAtrasadasUsuario AS t4
            WHERE (t1.status > 0)
            AND (T2.TP_ASSOCIADO_EMPRESA = 1)
            AND (t1.tipo_pessoa IN (1, 3))
            AND (t1.data_gerado BETWEEN @DataInicial AND @DataFinal)
            AND (T2.DT_PAGAMENTO IS NOT NULL)
            AND (t1.Faixa_dias_atrasado = @Faixa)
            AND (t1.nome_usuario = @NomeUsuario)
            AND (t1.sequencial = t4.sequencial)
            AND (t5.cd_sequencial =
            (SELECT
             	MAX(cd_sequencial) AS Expr1
             FROM Comentario AS t100
             WHERE (t1.sequencial = sequencial)))
            AND (t4.cd_parcela = T2.CD_PARCELA)
            ORDER BY t1.sequencial
		END


		IF (@Tipo = 1)
		AND (@TipoPessoa = 2) BEGIN
			/*Total de cobrancas feitas pagas*/
			--SELECT
			--         	t1.sequencial ,
			--         	T2.VL_PARCELA ,
			--         	t3.CD_EMPRESA AS codigo ,
			--         	t3.NM_RAZSOC AS nome ,
			--         	t4.cd_parcela ,
			--         	CONVERT(VARCHAR(10), t4.Data_Vencimento, 103) AS data ,
			--         	t4.dias_atraso ,
			--         	t5.ds_comentario ,
			--         	CASE WHEN ( t4.cd_parcela >= 1
			--         		AND t1.cd_parcela <= 31999 ) THEN 'Plano'
			--         		 WHEN ( t4.cd_parcela >= 32000
			--         		AND t1.cd_parcela <= 63999 ) THEN 'Serviço Opcional'
			--         		 WHEN ( t4.cd_parcela >= 64000
			--         		AND t1.cd_parcela <= 95999 ) THEN 'Orçamento'
			--         		 WHEN ( t4.cd_parcela >= 96000
			--         		AND t1.cd_parcela <= 127999 ) THEN 'Acordo'
			--         		 WHEN ( t4.cd_parcela >= 128000
			--         		AND t1.cd_parcela <= 159999 ) THEN 'Plano Ortodôtico'
			--         		 WHEN ( t4.cd_parcela >= 160000
			--         		AND t1.cd_parcela <= 191999 ) THEN 'Parcelas Geradas' END AS tipo_plano ,
			--         	CONVERT(VARCHAR(10), T2.DT_PAGAMENTO, 103) AS data_pagamento
			--         FROM TB_ListaAtrasadosUsuario t1,
			--         	MENSALIDADES T2,
			--         	EMPRESA t3,
			--         	TB_ParcelasAtrasadasUsuario t4,
			--         	Comentario t5
			--         WHERE t1.Status > 0
			--         AND t1.codigo = T2.CD_ASSOCIADO_empresa
			--         AND T2.TP_ASSOCIADO_EMPRESA = 2
			--         AND t1.tipo_pessoa = 2
			--         AND t1.data_gerado BETWEEN @DataInicial AND @DataFinal
			--         AND T2.DT_PAGAMENTO IS NOT NULL
			--         AND t1.Faixa_dias_atrasado = @Faixa
			--         AND t1.nome_usuario = @NomeUsuario
			--         AND t1.codigo = t3.CD_EMPRESA
			--         AND t1.sequencial = t4.sequencial
			--         AND t1.sequencial = t5.sequencial
			--         AND t5.cd_sequencial = (SELECT
			--                                 	MAX(cd_sequencial)
			--                                 FROM Comentario t100
			--                                 WHERE t1.sequencial = t100.sequencial)
			--         AND t4.cd_parcela = T2.cd_parcela
			--         ORDER BY t1.sequencial

			SELECT
            	t1.sequencial ,
            	T2.VL_PARCELA ,
            	t3.CD_EMPRESA AS codigo ,
            	t3.NM_RAZSOC AS nome ,
            	t4.cd_parcela ,
            	CONVERT(VARCHAR(10), t4.Data_Vencimento, 103) AS data ,
            	t4.dias_atraso ,
            	t5.ds_comentario ,
            	CASE WHEN ( t4.cd_parcela >= 1
            		AND t1.cd_parcela <= 31999 ) THEN 'Plano'
            		 WHEN ( t4.cd_parcela >= 32000
            		AND t1.cd_parcela <= 63999 ) THEN 'Serviço Opcional'
            		 WHEN ( t4.cd_parcela >= 64000
            		AND t1.cd_parcela <= 95999 ) THEN 'Orçamento'
            		 WHEN ( t4.cd_parcela >= 96000
            		AND t1.cd_parcela <= 127999 ) THEN 'Acordo'
            		 WHEN ( t4.cd_parcela >= 128000
            		AND t1.cd_parcela <= 159999 ) THEN 'Plano Ortodôtico'
            		 WHEN ( t4.cd_parcela >= 160000
            		AND t1.cd_parcela <= 191999 ) THEN 'Parcelas Geradas' END AS tipo_plano ,
            	CONVERT(VARCHAR(10), T2.DT_PAGAMENTO, 103) AS data_pagamento
            FROM TB_ListaAtrasadosUsuario AS t1
            	INNER JOIN MENSALIDADES AS T2 ON t1.codigo = T2.CD_ASSOCIADO_empresa
            	INNER JOIN EMPRESA AS t3 ON t1.codigo = t3.CD_EMPRESA
            	INNER JOIN Comentario AS t5 ON t1.sequencial = t5.sequencial
            	CROSS JOIN TB_ParcelasAtrasadasUsuario AS t4
            WHERE (t1.status > 0)
            AND (T2.TP_ASSOCIADO_EMPRESA = 2)
            AND (t1.tipo_pessoa = 2)
            AND (t1.data_gerado BETWEEN @DataInicial AND @DataFinal)
            AND (T2.DT_PAGAMENTO IS NOT NULL)
            AND (t1.Faixa_dias_atrasado = @Faixa)
            AND (t1.nome_usuario = @NomeUsuario)
            AND (t1.sequencial = t4.sequencial)
            AND (t5.cd_sequencial =
            (SELECT
             	MAX(cd_sequencial) AS Expr1
             FROM Comentario AS t100
             WHERE (t1.sequencial = sequencial)))
            AND (t4.cd_parcela = T2.CD_PARCELA)
            ORDER BY t1.sequencial

		END

		IF (@Tipo = 2)
		AND ( (@TipoPessoa = 1)
		OR (@TipoPessoa = 3) ) BEGIN
			/*Total de cobrancas feitas pagas*/
			--SELECT
			--         	t1.sequencial ,
			--         	T2.VL_PARCELA ,
			--         	t3.cd_associado AS codigo ,
			--         	t3.nm_completo AS nome ,
			--         	t4.cd_parcela ,
			--         	CONVERT(VARCHAR(10), t4.Data_Vencimento, 103) AS data ,
			--         	t4.dias_atraso ,
			--         	t5.ds_comentario ,
			--         	CASE WHEN ( t4.cd_parcela >= 1
			--         		AND t1.cd_parcela <= 31999 ) THEN 'Plano'
			--         		 WHEN ( t4.cd_parcela >= 32000
			--         		AND t1.cd_parcela <= 63999 ) THEN 'Serviço Opcional'
			--         		 WHEN ( t4.cd_parcela >= 64000
			--         		AND t1.cd_parcela <= 95999 ) THEN 'Orçamento'
			--         		 WHEN ( t4.cd_parcela >= 96000
			--         		AND t1.cd_parcela <= 127999 ) THEN 'Acordo'
			--         		 WHEN ( t4.cd_parcela >= 128000
			--         		AND t1.cd_parcela <= 159999 ) THEN 'Plano Ortodôtico'
			--         		 WHEN ( t4.cd_parcela >= 160000
			--         		AND t1.cd_parcela <= 191999 ) THEN 'Parcelas Geradas' END AS tipo_plano ,
			--         	CONVERT(VARCHAR(10), T2.DT_PAGAMENTO, 103) AS data_pagamento
			--         FROM TB_ListaAtrasadosUsuario t1,
			--         	MENSALIDADES T2,
			--         	ASSOCIADOS t3,
			--         	TB_ParcelasAtrasadasUsuario t4,
			--         	Comentario t5
			--         WHERE t1.Status > 0
			--         AND t1.codigo = T2.CD_ASSOCIADO_empresa
			--         AND t1.tipo_pessoa IN (1, 3)
			--         AND T2.TP_ASSOCIADO_EMPRESA = 1
			--         AND t1.data_gerado BETWEEN @DataInicial AND @DataFinal
			--         AND T2.DT_PAGAMENTO IS NULL
			--         AND t1.Faixa_dias_atrasado = @Faixa
			--         AND t1.nome_usuario = @NomeUsuario
			--         AND t1.codigo = t3.cd_associado
			--         AND t1.sequencial = t4.sequencial
			--         AND t1.sequencial = t5.sequencial
			--         AND t5.cd_sequencial = (SELECT
			--                                 	MAX(cd_sequencial)
			--                                 FROM Comentario t100
			--                                 WHERE t1.sequencial = t100.sequencial)
			--         AND t4.cd_parcela = T2.cd_parcela
			--         ORDER BY t1.sequencial

			SELECT
            	t1.sequencial ,
            	T2.VL_PARCELA ,
            	t3.cd_associado AS codigo ,
            	t3.nm_completo AS nome ,
            	t4.cd_parcela ,
            	CONVERT(VARCHAR(10), t4.Data_Vencimento, 103) AS data ,
            	t4.dias_atraso ,
            	t5.ds_comentario ,
            	CASE WHEN ( t4.cd_parcela >= 1
            		AND t1.cd_parcela <= 31999 ) THEN 'Plano'
            		 WHEN ( t4.cd_parcela >= 32000
            		AND t1.cd_parcela <= 63999 ) THEN 'Serviço Opcional'
            		 WHEN ( t4.cd_parcela >= 64000
            		AND t1.cd_parcela <= 95999 ) THEN 'Orçamento'
            		 WHEN ( t4.cd_parcela >= 96000
            		AND t1.cd_parcela <= 127999 ) THEN 'Acordo'
            		 WHEN ( t4.cd_parcela >= 128000
            		AND t1.cd_parcela <= 159999 ) THEN 'Plano Ortodôtico'
            		 WHEN ( t4.cd_parcela >= 160000
            		AND t1.cd_parcela <= 191999 ) THEN 'Parcelas Geradas' END AS tipo_plano ,
            	CONVERT(VARCHAR(10), T2.DT_PAGAMENTO, 103) AS data_pagamento
            FROM TB_ListaAtrasadosUsuario AS t1
            	INNER JOIN MENSALIDADES AS T2 ON t1.codigo = T2.CD_ASSOCIADO_empresa
            	INNER JOIN ASSOCIADOS AS t3 ON t1.codigo = t3.cd_associado
            	INNER JOIN Comentario AS t5 ON t1.sequencial = t5.sequencial
            	CROSS JOIN TB_ParcelasAtrasadasUsuario AS t4
            WHERE (t1.status > 0)
            AND (t1.tipo_pessoa IN (1, 3))
            AND (T2.TP_ASSOCIADO_EMPRESA = 1)
            AND (t1.data_gerado BETWEEN @DataInicial AND @DataFinal)
            AND (T2.DT_PAGAMENTO IS NULL)
            AND (t1.Faixa_dias_atrasado = @Faixa)
            AND (t1.nome_usuario = @NomeUsuario)
            AND (t1.sequencial = t4.sequencial)
            AND (t5.cd_sequencial =
            (SELECT
             	MAX(cd_sequencial) AS Expr1
             FROM Comentario AS t100
             WHERE (t1.sequencial = sequencial)))
            AND (t4.cd_parcela = T2.CD_PARCELA)
            ORDER BY t1.sequencial
		END


		IF (@Tipo = 2)
		AND (@TipoPessoa = 2) BEGIN
			/*Total de cobrancas feitas pagas*/
			--SELECT
			--         	t1.sequencial ,
			--         	T2.VL_PARCELA ,
			--         	t3.CD_EMPRESA AS codigo ,
			--         	t3.NM_RAZSOC AS nome ,
			--         	t4.cd_parcela ,
			--         	CONVERT(VARCHAR(10), t4.Data_Vencimento, 103) AS data ,
			--         	t4.dias_atraso ,
			--         	t5.ds_comentario ,
			--         	CASE WHEN ( t4.cd_parcela >= 1
			--         		AND t1.cd_parcela <= 31999 ) THEN 'Plano'
			--         		 WHEN ( t4.cd_parcela >= 32000
			--         		AND t1.cd_parcela <= 63999 ) THEN 'Serviço Opcional'
			--         		 WHEN ( t4.cd_parcela >= 64000
			--         		AND t1.cd_parcela <= 95999 ) THEN 'Orçamento'
			--         		 WHEN ( t4.cd_parcela >= 96000
			--         		AND t1.cd_parcela <= 127999 ) THEN 'Acordo'
			--         		 WHEN ( t4.cd_parcela >= 128000
			--         		AND t1.cd_parcela <= 159999 ) THEN 'Plano Ortodôtico'
			--         		 WHEN ( t4.cd_parcela >= 160000
			--         		AND t1.cd_parcela <= 191999 ) THEN 'Parcelas Geradas' END AS tipo_plano ,
			--         	CONVERT(VARCHAR(10), T2.DT_PAGAMENTO, 103) AS data_pagamento
			--         FROM TB_ListaAtrasadosUsuario t1,
			--         	MENSALIDADES T2,
			--         	EMPRESA t3,
			--         	TB_ParcelasAtrasadasUsuario t4,
			--         	Comentario t5
			--         WHERE t1.Status > 0
			--         AND t1.codigo = T2.CD_ASSOCIADO_empresa
			--         AND t1.tipo_pessoa = 2
			--         AND T2.TP_ASSOCIADO_EMPRESA = 2
			--         AND t1.data_gerado BETWEEN @DataInicial AND @DataFinal
			--         AND T2.DT_PAGAMENTO IS NULL
			--         AND t1.Faixa_dias_atrasado = @Faixa
			--         AND t1.nome_usuario = @NomeUsuario
			--         AND t1.codigo = t3.CD_EMPRESA
			--         AND t1.sequencial = t4.sequencial
			--         AND t1.sequencial = t5.sequencial
			--         AND t5.cd_sequencial = (SELECT
			--                                 	MAX(cd_sequencial)
			--                                 FROM Comentario t100
			--                                 WHERE t1.sequencial = t100.sequencial)
			--         AND t4.cd_parcela = T2.cd_parcela
			--         ORDER BY t1.sequencial

			SELECT
            	t1.sequencial ,
            	T2.VL_PARCELA ,
            	t3.CD_EMPRESA AS codigo ,
            	t3.NM_RAZSOC AS nome ,
            	t4.cd_parcela ,
            	CONVERT(VARCHAR(10), t4.Data_Vencimento, 103) AS data ,
            	t4.dias_atraso ,
            	t5.ds_comentario ,
            	CASE WHEN ( t4.cd_parcela >= 1
            		AND t1.cd_parcela <= 31999 ) THEN 'Plano'
            		 WHEN ( t4.cd_parcela >= 32000
            		AND t1.cd_parcela <= 63999 ) THEN 'Serviço Opcional'
            		 WHEN ( t4.cd_parcela >= 64000
            		AND t1.cd_parcela <= 95999 ) THEN 'Orçamento'
            		 WHEN ( t4.cd_parcela >= 96000
            		AND t1.cd_parcela <= 127999 ) THEN 'Acordo'
            		 WHEN ( t4.cd_parcela >= 128000
            		AND t1.cd_parcela <= 159999 ) THEN 'Plano Ortodôtico'
            		 WHEN ( t4.cd_parcela >= 160000
            		AND t1.cd_parcela <= 191999 ) THEN 'Parcelas Geradas' END AS tipo_plano ,
            	CONVERT(VARCHAR(10), T2.DT_PAGAMENTO, 103) AS data_pagamento
            FROM TB_ListaAtrasadosUsuario AS t1
            	INNER JOIN MENSALIDADES AS T2 ON t1.codigo = T2.CD_ASSOCIADO_empresa
            	INNER JOIN EMPRESA AS t3 ON t1.codigo = t3.CD_EMPRESA
            	INNER JOIN Comentario AS t5 ON t1.sequencial = t5.sequencial
            	CROSS JOIN TB_ParcelasAtrasadasUsuario AS t4
            WHERE (t1.status > 0)
            AND (t1.tipo_pessoa = 2)
            AND (T2.TP_ASSOCIADO_EMPRESA = 2)
            AND (t1.data_gerado BETWEEN @DataInicial AND @DataFinal)
            AND (T2.DT_PAGAMENTO IS NULL)
            AND (t1.Faixa_dias_atrasado = @Faixa)
            AND (t1.nome_usuario = @NomeUsuario)
            AND (t1.sequencial = t4.sequencial)
            AND (t5.cd_sequencial =
            (SELECT
             	MAX(cd_sequencial) AS Expr1
             FROM Comentario AS t100
             WHERE (t1.sequencial = sequencial)))
            AND (t4.cd_parcela = T2.CD_PARCELA)
            ORDER BY t1.sequencial


		END
	END
