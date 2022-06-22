/****** Object:  Procedure [dbo].[PS_ConsultaCobrancaGeral]    Committed by VersionSQL https://www.versionsql.com ******/

/*
Data e Hora.: 2022-05-24 14:56:24
Usuário.: henrique.almeida
Database.: S4ECLEAN
Servidor.: 10.1.1.10\homologacao
Comentário.: REALIZADO PADRONIZAÇÃO T-SQL E FORMATAÇÃO.
FORAM MANTIDOS AS QUERYS ANTIGAS COMENTADAS PARA HISTORICO.
*/


CREATE PROCEDURE [dbo].[PS_ConsultaCobrancaGeral] (
	@DataInicial DATETIME,
	@DataFinal DATETIME,
	@NomeUsuario VARCHAR(20),
	@Status INTEGER)
AS BEGIN

		/*Total de cobrancas feitas pagas*/
		--SELECT
		--      	1 AS tipo ,
		--      	t5.dt_comentario ,
		--      	t1.Faixa_dias_atrasado ,
		--      	t1.nome_usuario ,
		--      	t1.status ,
		--      	T2.VL_PARCELA ,
		--      	t3.cd_associado AS codigo ,
		--      	t3.nm_completo AS nome ,
		--      	t4.cd_parcela ,
		--      	CONVERT(VARCHAR(10), t4.Data_Vencimento, 103) AS data ,
		--      	t4.dias_atraso ,
		--      	t5.ds_comentario ,
		--      	CASE WHEN ( t4.cd_parcela >= 1
		--      		AND t1.cd_parcela <= 31999 ) THEN 'Plano'
		--      		 WHEN ( t4.cd_parcela >= 32000
		--      		AND t1.cd_parcela <= 63999 ) THEN 'Serviço Opcional'
		--      		 WHEN ( t4.cd_parcela >= 64000
		--      		AND t1.cd_parcela <= 95999 ) THEN 'Orçamento'
		--      		 WHEN ( t4.cd_parcela >= 96000
		--      		AND t1.cd_parcela <= 127999 ) THEN 'Acordo'
		--      		 WHEN ( t4.cd_parcela >= 128000
		--      		AND t1.cd_parcela <= 159999 ) THEN 'Plano Ortodôtico'
		--      		 WHEN ( t4.cd_parcela >= 160000
		--      		AND t1.cd_parcela <= 191999 ) THEN 'Parcelas Geradas' END AS tipo_plano ,
		--      	CONVERT(VARCHAR(10), T2.DT_PAGAMENTO, 103) AS data_pagamento ,
		--      	CONVERT(VARCHAR(10), t5.dt_comentario, 103) + ' ' + CONVERT(VARCHAR(10), t5.dt_comentario, 108) AS data ,
		--      	CONVERT(VARCHAR(10), t5.data_impressao, 103) + ' ' + CONVERT(VARCHAR(10), t5.data_impressao, 108) AS data_impressao
		--      FROM TB_ListaAtrasadosUsuario t1,
		--      	MENSALIDADES T2,
		--      	ASSOCIADOS t3,
		--      	TB_ParcelasAtrasadasUsuario t4,
		--      	Comentario t5
		--      WHERE t1.status > 0
		--      AND t1.tipo_pessoa = 1
		--      AND t1.codigo = T2.CD_ASSOCIADO_empresa
		--      AND T2.TP_ASSOCIADO_EMPRESA = 1
		--      AND t1.data_gerado BETWEEN @DataInicial AND @DataFinal
		--      AND T2.DT_PAGAMENTO IS NOT NULL
		--      AND t1.nome_usuario = @NomeUsuario
		--      AND t1.codigo = t3.cd_associado
		--      AND t1.sequencial = t4.sequencial
		--      AND t1.sequencial = t5.sequencial
		--      AND t4.cd_parcela = T2.cd_parcela

		SELECT
        	1 AS tipo ,
        	t5.dt_comentario ,
        	t1.Faixa_dias_atrasado ,
        	t1.nome_usuario ,
        	t1.status ,
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
        	CONVERT(VARCHAR(10), T2.DT_PAGAMENTO, 103)
        	AS data_pagamento ,
        	CONVERT(VARCHAR(10), t5.dt_comentario, 103) + ' ' + CONVERT(VARCHAR(10), t5.dt_comentario, 108) AS data ,
        	CONVERT(VARCHAR(10), t5.data_impressao, 103) + ' ' + CONVERT(VARCHAR(10),
        	t5.data_impressao, 108) AS data_impressao
        FROM TB_ListaAtrasadosUsuario AS t1
        	INNER JOIN MENSALIDADES AS T2 ON t1.codigo = T2.CD_ASSOCIADO_empresa
        	INNER JOIN ASSOCIADOS AS t3 ON t1.codigo = t3.cd_associado
        	INNER JOIN Comentario AS t5 ON t1.sequencial = t5.sequencial
        	CROSS JOIN TB_ParcelasAtrasadasUsuario AS t4
        WHERE (t1.status > 0)
        AND (t1.tipo_pessoa = 1)
        AND (T2.TP_ASSOCIADO_EMPRESA = 1)
        AND (t1.data_gerado BETWEEN @DataInicial AND @DataFinal)
        AND (T2.DT_PAGAMENTO IS NOT NULL)
        AND (t1.nome_usuario = @NomeUsuario)
        AND (t1.sequencial = t4.sequencial)
        AND (t4.cd_parcela = T2.CD_PARCELA)

        UNION ALL
        --SELECT
        --	2 AS tipo ,
        --	t5.dt_comentario ,
        --	t1.Faixa_dias_atrasado ,
        --	t1.nome_usuario ,
        --	t1.status ,
        --	T2.VL_PARCELA ,
        --	t3.cd_associado AS codigo ,
        --	t3.nm_completo AS nome ,
        --	t4.cd_parcela ,
        --	CONVERT(VARCHAR(10), t4.Data_Vencimento, 103) AS data ,
        --	t4.dias_atraso ,
        --	t5.ds_comentario ,
        --	CASE WHEN ( t4.cd_parcela >= 1
        --		AND t1.cd_parcela <= 31999 ) THEN 'Plano'
        --		 WHEN ( t4.cd_parcela >= 32000
        --		AND t1.cd_parcela <= 63999 ) THEN 'Serviço Opcional'
        --		 WHEN ( t4.cd_parcela >= 64000
        --		AND t1.cd_parcela <= 95999 ) THEN 'Orçamento'
        --		 WHEN ( t4.cd_parcela >= 96000
        --		AND t1.cd_parcela <= 127999 ) THEN 'Acordo'
        --		 WHEN ( t4.cd_parcela >= 128000
        --		AND t1.cd_parcela <= 159999 ) THEN 'Plano Ortodôtico'
        --		 WHEN ( t4.cd_parcela >= 160000
        --		AND t1.cd_parcela <= 191999 ) THEN 'Parcelas Geradas' END AS tipo_plano ,
        --	CONVERT(VARCHAR(10), T2.DT_PAGAMENTO, 103) AS data_pagamento ,
        --	CONVERT(VARCHAR(10), t5.dt_comentario, 103) + ' ' + CONVERT(VARCHAR(10), t5.dt_comentario, 108) AS data ,
        --	CONVERT(VARCHAR(10), t5.data_impressao, 103) + ' ' + CONVERT(VARCHAR(10), t5.data_impressao, 108) AS data_impressao
        --FROM TB_ListaAtrasadosUsuario t1,
        --	MENSALIDADES T2,
        --	ASSOCIADOS t3,
        --	TB_ParcelasAtrasadasUsuario t4,
        --	Comentario t5
        --WHERE t1.status > 0
        --AND t1.tipo_pessoa = 1
        --AND T2.TP_ASSOCIADO_EMPRESA = 1
        --AND t1.codigo = T2.CD_ASSOCIADO_empresa
        --AND t1.data_gerado BETWEEN @DataInicial AND @DataFinal
        --AND T2.DT_PAGAMENTO IS NULL
        --AND t1.nome_usuario = @NomeUsuario
        --AND t1.codigo = t3.cd_associado
        --AND t1.sequencial = t4.sequencial
        --AND t1.sequencial = t5.sequencial
        --AND t4.cd_parcela = T2.cd_parcela

        SELECT
        	2 AS tipo ,
        	t5.dt_comentario ,
        	t1.Faixa_dias_atrasado ,
        	t1.nome_usuario ,
        	t1.status ,
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
        	CONVERT(VARCHAR(10), T2.DT_PAGAMENTO, 103)
        	AS data_pagamento ,
        	CONVERT(VARCHAR(10), t5.dt_comentario, 103) + ' ' + CONVERT(VARCHAR(10), t5.dt_comentario, 108) AS data ,
        	CONVERT(VARCHAR(10), t5.data_impressao, 103) + ' ' + CONVERT(VARCHAR(10),
        	t5.data_impressao, 108) AS data_impressao
        FROM TB_ListaAtrasadosUsuario AS t1
        	INNER JOIN MENSALIDADES AS T2 ON t1.codigo = T2.CD_ASSOCIADO_empresa
        	INNER JOIN ASSOCIADOS AS t3 ON t1.codigo = t3.cd_associado
        	INNER JOIN Comentario AS t5 ON t1.sequencial = t5.sequencial
        	CROSS JOIN TB_ParcelasAtrasadasUsuario AS t4
        WHERE (t1.status > 0)
        AND (t1.tipo_pessoa = 1)
        AND (T2.TP_ASSOCIADO_EMPRESA = 1)
        AND (t1.data_gerado BETWEEN @DataInicial AND @DataFinal)
        AND (T2.DT_PAGAMENTO IS NULL)
        AND (t1.nome_usuario = @NomeUsuario)
        AND (t1.sequencial = t4.sequencial)
        AND (t4.cd_parcela = T2.CD_PARCELA)

        UNION ALL
        --SELECT
        --	1 AS tipo ,
        --	t5.dt_comentario ,
        --	t1.Faixa_dias_atrasado ,
        --	t1.nome_usuario ,
        --	t1.status ,
        --	T2.VL_PARCELA ,
        --	t3.CD_EMPRESA AS codigo ,
        --	t3.NM_RAZSOC AS nome ,
        --	t4.cd_parcela ,
        --	CONVERT(VARCHAR(10), t4.Data_Vencimento, 103) AS data ,
        --	t4.dias_atraso ,
        --	t5.ds_comentario ,
        --	CASE WHEN ( t4.cd_parcela >= 1
        --		AND t1.cd_parcela <= 31999 ) THEN 'Plano'
        --		 WHEN ( t4.cd_parcela >= 32000
        --		AND t1.cd_parcela <= 63999 ) THEN 'Serviço Opcional'
        --		 WHEN ( t4.cd_parcela >= 64000
        --		AND t1.cd_parcela <= 95999 ) THEN 'Orçamento'
        --		 WHEN ( t4.cd_parcela >= 96000
        --		AND t1.cd_parcela <= 127999 ) THEN 'Acordo'
        --		 WHEN ( t4.cd_parcela >= 128000
        --		AND t1.cd_parcela <= 159999 ) THEN 'Plano Ortodôtico'
        --		 WHEN ( t4.cd_parcela >= 160000
        --		AND t1.cd_parcela <= 191999 ) THEN 'Parcelas Geradas' END AS tipo_plano ,
        --	CONVERT(VARCHAR(10), T2.DT_PAGAMENTO, 103) AS data_pagamento ,
        --	CONVERT(VARCHAR(10), t5.dt_comentario, 103) + ' ' + CONVERT(VARCHAR(10), t5.dt_comentario, 108) AS data ,
        --	CONVERT(VARCHAR(10), t5.data_impressao, 103) + ' ' + CONVERT(VARCHAR(10), t5.data_impressao, 108) AS data_impressao
        --FROM TB_ListaAtrasadosUsuario t1,
        --	MENSALIDADES T2,
        --	EMPRESA t3,
        --	TB_ParcelasAtrasadasUsuario t4,
        --	Comentario t5
        --WHERE t1.status > 0
        --AND t1.codigo = T2.CD_ASSOCIADO_empresa
        --AND T2.TP_ASSOCIADO_EMPRESA = 2
        --AND t1.tipo_pessoa = 2
        --AND t1.data_gerado BETWEEN @DataInicial AND @DataFinal
        --AND T2.DT_PAGAMENTO IS NOT NULL
        --AND t1.nome_usuario = @NomeUsuario
        --AND t1.codigo = t3.CD_EMPRESA
        --AND t1.sequencial = t4.sequencial
        --AND t1.sequencial = t5.sequencial
        --AND t4.cd_parcela = T2.cd_parcela

        SELECT
        	1 AS tipo ,
        	t5.dt_comentario ,
        	t1.Faixa_dias_atrasado ,
        	t1.nome_usuario ,
        	t1.status ,
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
        	CONVERT(VARCHAR(10), T2.DT_PAGAMENTO, 103)
        	AS data_pagamento ,
        	CONVERT(VARCHAR(10), t5.dt_comentario, 103) + ' ' + CONVERT(VARCHAR(10), t5.dt_comentario, 108) AS data ,
        	CONVERT(VARCHAR(10), t5.data_impressao, 103) + ' ' + CONVERT(VARCHAR(10),
        	t5.data_impressao, 108) AS data_impressao
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
        AND (t1.nome_usuario = @NomeUsuario)
        AND (t1.sequencial = t4.sequencial)
        AND (t4.cd_parcela = T2.CD_PARCELA)

        UNION ALL
        --SELECT
        --	2 AS tipo ,
        --	t5.dt_comentario ,
        --	t1.Faixa_dias_atrasado ,
        --	t1.nome_usuario ,
        --	t1.status ,
        --	T2.VL_PARCELA ,
        --	t3.CD_EMPRESA AS codigo ,
        --	t3.NM_RAZSOC AS nome ,
        --	t4.cd_parcela ,
        --	CONVERT(VARCHAR(10), t4.Data_Vencimento, 103) AS data ,
        --	t4.dias_atraso ,
        --	t5.ds_comentario ,
        --	CASE WHEN ( t4.cd_parcela >= 1
        --		AND t1.cd_parcela <= 31999 ) THEN 'Plano'
        --		 WHEN ( t4.cd_parcela >= 32000
        --		AND t1.cd_parcela <= 63999 ) THEN 'Serviço Opcional'
        --		 WHEN ( t4.cd_parcela >= 64000
        --		AND t1.cd_parcela <= 95999 ) THEN 'Orçamento'
        --		 WHEN ( t4.cd_parcela >= 96000
        --		AND t1.cd_parcela <= 127999 ) THEN 'Acordo'
        --		 WHEN ( t4.cd_parcela >= 128000
        --		AND t1.cd_parcela <= 159999 ) THEN 'Plano Ortodôtico'
        --		 WHEN ( t4.cd_parcela >= 160000
        --		AND t1.cd_parcela <= 191999 ) THEN 'Parcelas Geradas' END AS tipo_plano ,
        --	CONVERT(VARCHAR(10), T2.DT_PAGAMENTO, 103) AS data_pagamento ,
        --	CONVERT(VARCHAR(10), t5.dt_comentario, 103) + ' ' + CONVERT(VARCHAR(10), t5.dt_comentario, 108) AS data ,
        --	CONVERT(VARCHAR(10), t5.data_impressao, 103) + ' ' + CONVERT(VARCHAR(10), t5.data_impressao, 108) AS data_impressao
        --FROM TB_ListaAtrasadosUsuario t1,
        --	MENSALIDADES T2,
        --	EMPRESA t3,
        --	TB_ParcelasAtrasadasUsuario t4,
        --	Comentario t5
        --WHERE t1.status > 0
        --AND t1.codigo = T2.CD_ASSOCIADO_empresa
        --AND t1.tipo_pessoa = 2
        --AND T2.TP_ASSOCIADO_EMPRESA = 2
        --AND t1.data_gerado BETWEEN @DataInicial AND @DataFinal
        --AND T2.DT_PAGAMENTO IS NULL
        --AND t1.nome_usuario = @NomeUsuario
        --AND t1.codigo = t3.CD_EMPRESA
        --AND t1.sequencial = t4.sequencial
        --AND t1.sequencial = t5.sequencial
        --AND t4.cd_parcela = T2.cd_parcela
        --ORDER BY 2,
        --         1

        SELECT
        	2 AS tipo ,
        	t5.dt_comentario ,
        	t1.Faixa_dias_atrasado ,
        	t1.nome_usuario ,
        	t1.status ,
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
        	CONVERT(VARCHAR(10), T2.DT_PAGAMENTO, 103)
        	AS data_pagamento ,
        	CONVERT(VARCHAR(10), t5.dt_comentario, 103) + ' ' + CONVERT(VARCHAR(10), t5.dt_comentario, 108) AS data ,
        	CONVERT(VARCHAR(10), t5.data_impressao, 103) + ' ' + CONVERT(VARCHAR(10),
        	t5.data_impressao, 108) AS data_impressao
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
        AND (t1.nome_usuario = @NomeUsuario)
        AND (t1.sequencial = t4.sequencial)
        AND (t4.cd_parcela = T2.CD_PARCELA)
        ORDER BY t5.dt_comentario,
                 tipo


	END
