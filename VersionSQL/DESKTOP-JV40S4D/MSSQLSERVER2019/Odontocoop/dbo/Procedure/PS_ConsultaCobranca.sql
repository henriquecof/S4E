/****** Object:  Procedure [dbo].[PS_ConsultaCobranca]    Committed by VersionSQL https://www.versionsql.com ******/

/*
Data e Hora.: 2022-05-23 17:20:57
Usuário.: henrique.almeida
Database.: S4ECLEAN
Servidor.: 10.1.1.10\homologacao
Comentário.: REALIZADO PADRONIZAÇÃ T-SQL E FORMATAÇÃO.
QUERY ANTIGAS DEIXADAS COMENTADAS.
*/


CREATE PROCEDURE [dbo].[PS_ConsultaCobranca] (
	@DataInicial DATETIME,
	@DataFinal DATETIME)
AS BEGIN

		/*Total de cobrancas feitas pagas*/
		--SELECT
		--      	T1.nome_usuario ,
		--      	T4.nm_empregado ,
		--      	T1.tipo_pessoa ,
		--      	T1.faixa_dias_atrasado ,
		--      	SUM(T2.vl_parcela) AS SOMA ,
		--      	COUNT(DISTINCT T1.sequencial) AS QUANTIDADE ,
		--      	1 AS TIPO_PAGAMENTO
		--      FROM tb_listaatrasadosusuario T1,
		--      	mensalidades T2,
		--      	tb_parcelasatrasadasusuario T3,
		--      	funcionario T4
		--      WHERE T1.nome_usuario = T4.cd_funcionario
		--      AND T1.status > 0
		--      AND T1.codigo = T2.cd_associado_empresa
		--      AND T1.tipo_pessoa IN (1, 3)
		--      AND T2.tp_associado_empresa = 1
		--      AND T1.sequencial = T3.sequencial
		--      AND T3.cd_parcela = T2.cd_parcela
		--      AND T1.data_gerado BETWEEN @datainicial AND @datafinal
		--      AND T2.dt_pagamento IS NOT NULL
		--      GROUP BY T1.nome_usuario,
		--               T4.nm_empregado,
		--               T1.tipo_pessoa,
		--               T1.faixa_dias_atrasado

		SELECT
        	T1.nome_usuario ,
        	T4.nm_empregado ,
        	T1.tipo_pessoa ,
        	T1.Faixa_dias_atrasado ,
        	SUM(T2.VL_PARCELA) AS SOMA ,
        	COUNT(DISTINCT T1.sequencial) AS QUANTIDADE ,
        	1 AS TIPO_PAGAMENTO
        FROM TB_ListaAtrasadosUsuario AS T1
        	INNER JOIN FUNCIONARIO AS T4 ON T1.nome_usuario = T4.cd_funcionario
        	INNER JOIN MENSALIDADES AS T2 ON T1.codigo = T2.CD_ASSOCIADO_empresa
        	CROSS JOIN tb_parcelasatrasadasusuario AS T3
        WHERE (T1.status > 0)
        AND (T1.tipo_pessoa IN (1, 3))
        AND (T2.TP_ASSOCIADO_EMPRESA = 1)
        AND (T1.sequencial = T3.sequencial)
        AND (T3.cd_parcela = T2.CD_PARCELA)
        AND (T1.data_gerado BETWEEN @datainicial AND
        @datafinal)
        AND (T2.DT_PAGAMENTO IS NOT NULL)
        GROUP BY T1.nome_usuario,
                 T4.nm_empregado,
                 T1.tipo_pessoa,
                 T1.Faixa_dias_atrasado

        UNION ALL
        --SELECT
        --	T1.nome_usuario ,
        --	T4.nm_empregado ,
        --	T1.tipo_pessoa ,
        --	T1.faixa_dias_atrasado ,
        --	SUM(T2.vl_parcela) AS SOMA ,
        --	COUNT(DISTINCT T1.sequencial) AS QUANTIDADE ,
        --	1 AS TIPO_PAGAMENTO
        --FROM tb_listaatrasadosusuario T1,
        --	mensalidades T2,
        --	tb_parcelasatrasadasusuario T3,
        --	funcionario T4
        --WHERE T1.nome_usuario = T4.cd_funcionario
        --AND T1.status > 0
        --AND T1.codigo = T2.cd_associado_empresa
        --AND T1.tipo_pessoa = 2
        --AND T2.tp_associado_empresa = 2
        --AND T1.sequencial = T3.sequencial
        --AND T3.cd_parcela = T2.cd_parcela
        --AND T1.data_gerado BETWEEN @datainicial AND @datafinal
        --AND T2.dt_pagamento IS NOT NULL
        --GROUP BY T1.nome_usuario,
        --         T4.nm_empregado,
        --         T1.tipo_pessoa,
        --         T1.faixa_dias_atrasado

        SELECT
        	T1.nome_usuario ,
        	T4.nm_empregado ,
        	T1.tipo_pessoa ,
        	T1.Faixa_dias_atrasado ,
        	SUM(T2.VL_PARCELA) AS SOMA ,
        	COUNT(DISTINCT T1.sequencial) AS QUANTIDADE ,
        	1 AS TIPO_PAGAMENTO
        FROM TB_ListaAtrasadosUsuario AS T1
        	INNER JOIN FUNCIONARIO AS T4 ON T1.nome_usuario = T4.cd_funcionario
        	INNER JOIN MENSALIDADES AS T2 ON T1.codigo = T2.CD_ASSOCIADO_empresa
        	CROSS JOIN tb_parcelasatrasadasusuario AS T3
        WHERE (T1.status > 0)
        AND (T1.tipo_pessoa = 2)
        AND (T2.TP_ASSOCIADO_EMPRESA = 2)
        AND (T1.sequencial = T3.sequencial)
        AND (T3.cd_parcela = T2.CD_PARCELA)
        AND (T1.data_gerado BETWEEN @datainicial AND @datafinal)
        AND (T2.DT_PAGAMENTO IS NOT NULL)
        GROUP BY T1.nome_usuario,
                 T4.nm_empregado,
                 T1.tipo_pessoa,
                 T1.Faixa_dias_atrasado


        /*Total de cobrancas feitas nao pagas*/
        UNION ALL
        --SELECT
        --	T1.nome_usuario ,
        --	T4.nm_empregado ,
        --	T1.tipo_pessoa ,
        --	T1.faixa_dias_atrasado ,
        --	SUM(T2.vl_parcela) AS SOMA ,
        --	COUNT(DISTINCT T1.sequencial) AS QUANTIDADE ,
        --	2 AS TIPO_PAGAMENTO
        --FROM tb_listaatrasadosusuario T1,
        --	mensalidades T2,
        --	tb_parcelasatrasadasusuario T3,
        --	funcionario T4
        --WHERE T1.nome_usuario = T4.cd_funcionario
        --AND T1.status > 0
        --AND T1.codigo = T2.cd_associado_empresa
        --AND T2.tp_associado_empresa = 1
        --AND T1.tipo_pessoa IN (1, 3)
        --AND T1.sequencial = T3.sequencial
        --AND T3.cd_parcela = T2.cd_parcela
        --AND T1.data_gerado BETWEEN @datainicial AND @datafinal
        --AND T2.dt_pagamento IS NULL
        --GROUP BY T1.nome_usuario,
        --         T4.nm_empregado,
        --         T1.tipo_pessoa,
        --         T1.faixa_dias_atrasado

        SELECT
        	T1.nome_usuario ,
        	T4.nm_empregado ,
        	T1.tipo_pessoa ,
        	T1.Faixa_dias_atrasado ,
        	SUM(T2.VL_PARCELA) AS SOMA ,
        	COUNT(DISTINCT T1.sequencial) AS QUANTIDADE ,
        	2 AS TIPO_PAGAMENTO
        FROM TB_ListaAtrasadosUsuario AS T1
        	INNER JOIN FUNCIONARIO AS T4 ON T1.nome_usuario = T4.cd_funcionario
        	INNER JOIN MENSALIDADES AS T2 ON T1.codigo = T2.CD_ASSOCIADO_empresa
        	CROSS JOIN tb_parcelasatrasadasusuario AS T3
        WHERE (T1.status > 0)
        AND (T2.TP_ASSOCIADO_EMPRESA = 1)
        AND (T1.tipo_pessoa IN (1, 3))
        AND (T1.sequencial = T3.sequencial)
        AND (T3.cd_parcela = T2.CD_PARCELA)
        AND (T1.data_gerado BETWEEN @datainicial AND
        @datafinal)
        AND (T2.DT_PAGAMENTO IS NULL)
        GROUP BY T1.nome_usuario,
                 T4.nm_empregado,
                 T1.tipo_pessoa,
                 T1.Faixa_dias_atrasado

        UNION ALL
        --SELECT
        --	T1.nome_usuario ,
        --	T4.nm_empregado ,
        --	T1.tipo_pessoa ,
        --	T1.faixa_dias_atrasado ,
        --	SUM(T2.vl_parcela) AS SOMA ,
        --	COUNT(DISTINCT T1.sequencial) AS QUANTIDADE ,
        --	2 AS TIPO_PAGAMENTO
        --FROM tb_listaatrasadosusuario T1,
        --	mensalidades T2,
        --	tb_parcelasatrasadasusuario T3,
        --	funcionario T4
        --WHERE T1.nome_usuario = T4.cd_funcionario
        --AND T1.status > 0
        --AND T1.codigo = T2.cd_associado_empresa
        --AND T1.tipo_pessoa = 2
        --AND T2.tp_associado_empresa = 2
        --AND T1.sequencial = T3.sequencial
        --AND T3.cd_parcela = T2.cd_parcela
        --AND T1.data_gerado BETWEEN @datainicial AND @datafinal
        --AND T2.dt_pagamento IS NULL
        --GROUP BY T1.nome_usuario,
        --         T4.nm_empregado,
        --         T1.tipo_pessoa,
        --         T1.faixa_dias_atrasado
        --ORDER BY 1,
        --         6,
        --         2,
        --         3

        SELECT
        	T1.nome_usuario ,
        	T4.nm_empregado ,
        	T1.tipo_pessoa ,
        	T1.Faixa_dias_atrasado ,
        	SUM(T2.VL_PARCELA) AS SOMA ,
        	COUNT(DISTINCT T1.sequencial) AS QUANTIDADE ,
        	2 AS TIPO_PAGAMENTO
        FROM TB_ListaAtrasadosUsuario AS T1
        	INNER JOIN FUNCIONARIO AS T4 ON T1.nome_usuario = T4.cd_funcionario
        	INNER JOIN MENSALIDADES AS T2 ON T1.codigo = T2.CD_ASSOCIADO_empresa
        	CROSS JOIN tb_parcelasatrasadasusuario AS T3
        WHERE (T1.status > 0)
        AND (T1.tipo_pessoa = 2)
        AND (T2.TP_ASSOCIADO_EMPRESA = 2)
        AND (T1.sequencial = T3.sequencial)
        AND (T3.cd_parcela = T2.CD_PARCELA)
        AND (T1.data_gerado BETWEEN @datainicial AND @datafinal)
        AND (T2.DT_PAGAMENTO IS NULL)
        GROUP BY T1.nome_usuario,
                 T4.nm_empregado,
                 T1.tipo_pessoa,
                 T1.Faixa_dias_atrasado
        ORDER BY T1.nome_usuario,
                 QUANTIDADE,
                 T4.nm_empregado,
                 T1.tipo_pessoa

	END
