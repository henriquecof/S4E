/****** Object:  Procedure [dbo].[PS_ConsultaCobrancaTodos]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:      henrique.almeida
-- Create date: 17/09/2021 09:46
-- Database:    S4ECLEAN
-- Description: REALIZADO PADRONIZAÇÃO E FORMATAÇÃO DE ESTILO T-SQL
-- REALIZAR DOCUMENTAÇÃO DA PROCEDURE USANDO EXTENDED PROPERTIES
-- =============================================


CREATE PROCEDURE [dbo].[PS_ConsultaCobrancaTodos] (
	@DataInicial DATETIME,
	@DataFinal DATETIME,
	@NomeUsuario VARCHAR(20),
	@status INT)
AS BEGIN

		DECLARE @Status_inicial INT
		DECLARE @Status_final INT

		IF @status = 0 BEGIN
			SET @Status_inicial = 1
			SET @Status_final = 999
		END ELSE
		BEGIN
			SET @Status_inicial = @status
			SET @Status_final = @status
		END


		IF @NomeUsuario != '' BEGIN
			/*Total de cobrancas feitas pagas*/
			SELECT
            	t5.cd_usuario ,
            	t5.dt_comentario ,
            	t3.nm_completo AS nome ,
            	t5.ds_comentario ,
            	t1.codigo ,
            	CONVERT(VARCHAR(10), t5.dt_comentario, 103) + ' ' + CONVERT(VARCHAR(10), t5.dt_comentario, 108) AS data ,
            	t1.status ,
            	t1.tipo_pessoa ,
            	t1.Faixa_dias_atrasado ,
            	CONVERT(VARCHAR(10), t5.data_impressao, 103) + ' ' + CONVERT(VARCHAR(10), t5.data_impressao, 108) AS data_impressao ,
            	t5.cd_funcionario_inclusao ,
            	t1.nome_usuario ,
            	t1.sequencial ,
            	t4.cd_parcela ,
            	CONVERT(VARCHAR(10), t4.Data_Vencimento, 103) AS data_v ,
            	t4.dias_atraso ,
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
            	AS data_pagamento
            FROM TB_ListaAtrasadosUsuario AS t1
            	INNER JOIN MENSALIDADES AS T2 ON t1.codigo = T2.CD_ASSOCIADO_empresa
            	INNER JOIN ASSOCIADOS AS t3 ON t1.codigo = t3.cd_associado
            	INNER JOIN Comentario AS t5 ON t1.sequencial = t5.sequencial
            	CROSS JOIN TB_ParcelasAtrasadasUsuario AS t4
            WHERE (t1.status >= @Status_inicial)
            AND (t1.status <= @Status_final)
            AND (t1.tipo_pessoa IN (1, 3))
            AND (T2.TP_ASSOCIADO_EMPRESA = 1)
            AND (t1.data_gerado BETWEEN @DataInicial AND @DataFinal)
            AND (T2.DT_PAGAMENTO IS NOT NULL)
            AND (t1.nome_usuario = @NomeUsuario)
            AND (t1.sequencial = t4.sequencial)
            AND (t5.cd_sequencial =
            (SELECT
             	MAX(cd_sequencial) AS Expr1
             FROM Comentario AS t100
             WHERE (t1.sequencial = sequencial)))
            AND (t4.cd_parcela = T2.CD_PARCELA)
            UNION ALL
            SELECT
            	t5.cd_usuario ,
            	t5.dt_comentario ,
            	t3.nm_completo AS nome ,
            	t5.ds_comentario ,
            	t1.codigo ,
            	CONVERT(VARCHAR(10), t5.dt_comentario, 103) + ' ' + CONVERT(VARCHAR(10), t5.dt_comentario, 108) AS data ,
            	t1.status ,
            	t1.tipo_pessoa ,
            	t1.Faixa_dias_atrasado ,
            	CONVERT(VARCHAR(10), t5.data_impressao, 103) + ' ' + CONVERT(VARCHAR(10), t5.data_impressao, 108) AS data_impressao ,
            	t5.cd_funcionario_inclusao ,
            	t1.nome_usuario ,
            	t1.sequencial ,
            	t4.cd_parcela ,
            	CONVERT(VARCHAR(10), t4.Data_Vencimento, 103) AS data_v ,
            	t4.dias_atraso ,
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
            	AS data_pagamento
            FROM TB_ListaAtrasadosUsuario AS t1
            	INNER JOIN MENSALIDADES AS T2 ON t1.codigo = T2.CD_ASSOCIADO_empresa
            	INNER JOIN ASSOCIADOS AS t3 ON t1.codigo = t3.cd_associado
            	INNER JOIN Comentario AS t5 ON t1.sequencial = t5.sequencial
            	CROSS JOIN TB_ParcelasAtrasadasUsuario AS t4
            WHERE (t1.status >= @Status_inicial)
            AND (t1.status <= @Status_final)
            AND (t1.tipo_pessoa IN (1, 3))
            AND (T2.TP_ASSOCIADO_EMPRESA = 1)
            AND (t1.data_gerado BETWEEN @DataInicial AND @DataFinal)
            AND (T2.DT_PAGAMENTO IS NULL)
            AND (t1.nome_usuario = @NomeUsuario)
            AND (t1.sequencial = t4.sequencial)
            AND (t5.cd_sequencial =
            (SELECT
             	MAX(cd_sequencial) AS Expr1
             FROM Comentario AS t100
             WHERE (t1.sequencial = sequencial)))
            AND (t4.cd_parcela = T2.CD_PARCELA)
            UNION ALL
            SELECT
            	t5.cd_usuario ,
            	t5.dt_comentario ,
            	t3.NM_RAZSOC AS nome ,
            	t5.ds_comentario ,
            	t1.codigo ,
            	CONVERT(VARCHAR(10), t5.dt_comentario, 103) + ' ' + CONVERT(VARCHAR(10), t5.dt_comentario, 108) AS data ,
            	t1.status ,
            	t1.tipo_pessoa ,
            	t1.Faixa_dias_atrasado ,
            	CONVERT(VARCHAR(10), t5.data_impressao, 103) + ' ' + CONVERT(VARCHAR(10), t5.data_impressao, 108) AS data_impressao ,
            	t5.cd_funcionario_inclusao ,
            	t1.nome_usuario ,
            	t1.sequencial ,
            	t4.cd_parcela ,
            	CONVERT(VARCHAR(10), t4.Data_Vencimento, 103) AS data_v ,
            	t4.dias_atraso ,
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
            	AS data_pagamento
            FROM TB_ListaAtrasadosUsuario AS t1
            	INNER JOIN MENSALIDADES AS T2 ON t1.codigo = T2.CD_ASSOCIADO_empresa
            	INNER JOIN EMPRESA AS t3 ON t1.codigo = t3.CD_EMPRESA
            	INNER JOIN Comentario AS t5 ON t1.sequencial = t5.sequencial
            	CROSS JOIN TB_ParcelasAtrasadasUsuario AS t4
            WHERE (t1.status >= @Status_inicial)
            AND (t1.status <= @Status_final)
            AND (T2.TP_ASSOCIADO_EMPRESA = 2)
            AND (t1.tipo_pessoa = 2)
            AND (t1.data_gerado BETWEEN @DataInicial AND @DataFinal)
            AND (T2.DT_PAGAMENTO IS NOT NULL)
            AND (t1.nome_usuario = @NomeUsuario)
            AND (t1.sequencial = t4.sequencial)
            AND (t5.cd_sequencial =
            (SELECT
             	MAX(cd_sequencial) AS Expr1
             FROM Comentario AS t100
             WHERE (t1.sequencial = sequencial)))
            AND (t4.cd_parcela = T2.CD_PARCELA)
            UNION ALL
            SELECT
            	t5.cd_usuario ,
            	t5.dt_comentario ,
            	t3.NM_RAZSOC AS nome ,
            	t5.ds_comentario ,
            	t1.codigo ,
            	CONVERT(VARCHAR(10), t5.dt_comentario, 103) + ' ' + CONVERT(VARCHAR(10), t5.dt_comentario, 108) AS data ,
            	t1.status ,
            	t1.tipo_pessoa ,
            	t1.Faixa_dias_atrasado ,
            	CONVERT(VARCHAR(10), t5.data_impressao, 103) + ' ' + CONVERT(VARCHAR(10), t5.data_impressao, 108) AS data_impressao ,
            	t5.cd_funcionario_inclusao ,
            	t1.nome_usuario ,
            	t1.sequencial ,
            	t4.cd_parcela ,
            	CONVERT(VARCHAR(10), t4.Data_Vencimento, 103) AS data_v ,
            	t4.dias_atraso ,
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
            	AS data_pagamento
            FROM TB_ListaAtrasadosUsuario AS t1
            	INNER JOIN MENSALIDADES AS T2 ON t1.codigo = T2.CD_ASSOCIADO_empresa
            	INNER JOIN EMPRESA AS t3 ON t1.codigo = t3.CD_EMPRESA
            	INNER JOIN Comentario AS t5 ON t1.sequencial = t5.sequencial
            	CROSS JOIN TB_ParcelasAtrasadasUsuario AS t4
            WHERE (t1.status >= @Status_inicial)
            AND (t1.status <= @Status_final)
            AND (t1.tipo_pessoa = 2)
            AND (T2.TP_ASSOCIADO_EMPRESA = 2)
            AND (t1.data_gerado BETWEEN @DataInicial AND @DataFinal)
            AND (T2.DT_PAGAMENTO IS NULL)
            AND (t1.nome_usuario = @NomeUsuario)
            AND (t1.sequencial = t4.sequencial)
            AND (t5.cd_sequencial =
            (SELECT
             	MAX(cd_sequencial) AS Expr1
             FROM Comentario AS t100
             WHERE (t1.sequencial = sequencial)))
            AND (t4.cd_parcela = T2.CD_PARCELA)
            ORDER BY t1.nome_usuario,
                     t5.dt_comentario
		END ELSE
		BEGIN
			/*Total de cobrancas feitas pagas*/
			SELECT
            	t5.cd_usuario ,
            	t5.dt_comentario ,
            	t3.nm_completo AS nome ,
            	t5.ds_comentario ,
            	t1.codigo ,
            	CONVERT(VARCHAR(10), t5.dt_comentario, 103) + ' ' + CONVERT(VARCHAR(10), t5.dt_comentario, 108) AS data ,
            	t1.status ,
            	t1.tipo_pessoa ,
            	t1.Faixa_dias_atrasado ,
            	CONVERT(VARCHAR(10), t5.data_impressao, 103) + ' ' + CONVERT(VARCHAR(10), t5.data_impressao, 108) AS data_impressao ,
            	t5.cd_funcionario_inclusao ,
            	t1.nome_usuario ,
            	t1.sequencial ,
            	t4.cd_parcela ,
            	CONVERT(VARCHAR(10), t4.Data_Vencimento, 103) AS data_v ,
            	t4.dias_atraso ,
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
            	AS data_pagamento
            FROM TB_ListaAtrasadosUsuario AS t1
            	INNER JOIN MENSALIDADES AS T2 ON t1.codigo = T2.CD_ASSOCIADO_empresa
            	INNER JOIN ASSOCIADOS AS t3 ON t1.codigo = t3.cd_associado
            	INNER JOIN Comentario AS t5 ON t1.sequencial = t5.sequencial
            	CROSS JOIN TB_ParcelasAtrasadasUsuario AS t4
            WHERE (t1.status >= @Status_inicial)
            AND (t1.status <= @Status_final)
            AND (t1.tipo_pessoa IN (1, 3))
            AND (T2.TP_ASSOCIADO_EMPRESA = 1)
            AND (t1.data_gerado BETWEEN @DataInicial AND @DataFinal)
            AND (T2.DT_PAGAMENTO IS NOT NULL)
            AND (t1.sequencial = t4.sequencial)
            AND (t5.cd_sequencial =
            (SELECT
             	MAX(cd_sequencial) AS Expr1
             FROM Comentario AS t100
             WHERE (t1.sequencial = sequencial)))
            AND (t4.cd_parcela = T2.CD_PARCELA)
            UNION ALL
            SELECT
            	t5.cd_usuario ,
            	t5.dt_comentario ,
            	t3.nm_completo AS nome ,
            	t5.ds_comentario ,
            	t1.codigo ,
            	CONVERT(VARCHAR(10), t5.dt_comentario, 103) + ' ' + CONVERT(VARCHAR(10), t5.dt_comentario, 108) AS data ,
            	t1.status ,
            	t1.tipo_pessoa ,
            	t1.Faixa_dias_atrasado ,
            	CONVERT(VARCHAR(10), t5.data_impressao, 103) + ' ' + CONVERT(VARCHAR(10), t5.data_impressao, 108) AS data_impressao ,
            	t5.cd_funcionario_inclusao ,
            	t1.nome_usuario ,
            	t1.sequencial ,
            	t4.cd_parcela ,
            	CONVERT(VARCHAR(10), t4.Data_Vencimento, 103) AS data_v ,
            	t4.dias_atraso ,
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
            	AS data_pagamento
            FROM TB_ListaAtrasadosUsuario AS t1
            	INNER JOIN MENSALIDADES AS T2 ON t1.codigo = T2.CD_ASSOCIADO_empresa
            	INNER JOIN ASSOCIADOS AS t3 ON t1.codigo = t3.cd_associado
            	INNER JOIN Comentario AS t5 ON t1.sequencial = t5.sequencial
            	CROSS JOIN TB_ParcelasAtrasadasUsuario AS t4
            WHERE (t1.status >= @Status_inicial)
            AND (t1.status <= @Status_final)
            AND (t1.tipo_pessoa IN (1, 3))
            AND (T2.TP_ASSOCIADO_EMPRESA = 1)
            AND (t1.data_gerado BETWEEN @DataInicial AND @DataFinal)
            AND (T2.DT_PAGAMENTO IS NULL)
            AND (t1.sequencial = t4.sequencial)
            AND (t5.cd_sequencial =
            (SELECT
             	MAX(cd_sequencial) AS Expr1
             FROM Comentario AS t100
             WHERE (t1.sequencial = sequencial)))
            AND (t4.cd_parcela = T2.CD_PARCELA)
            UNION ALL
            SELECT
            	t5.cd_usuario ,
            	t5.dt_comentario ,
            	t3.NM_RAZSOC AS nome ,
            	t5.ds_comentario ,
            	t1.codigo ,
            	CONVERT(VARCHAR(10), t5.dt_comentario, 103) + ' ' + CONVERT(VARCHAR(10), t5.dt_comentario, 108) AS data ,
            	t1.status ,
            	t1.tipo_pessoa ,
            	t1.Faixa_dias_atrasado ,
            	CONVERT(VARCHAR(10), t5.data_impressao, 103) + ' ' + CONVERT(VARCHAR(10), t5.data_impressao, 108) AS data_impressao ,
            	t5.cd_funcionario_inclusao ,
            	t1.nome_usuario ,
            	t1.sequencial ,
            	t4.cd_parcela ,
            	CONVERT(VARCHAR(10), t4.Data_Vencimento, 103) AS data_v ,
            	t4.dias_atraso ,
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
            	AS data_pagamento
            FROM TB_ListaAtrasadosUsuario AS t1
            	INNER JOIN MENSALIDADES AS T2 ON t1.codigo = T2.CD_ASSOCIADO_empresa
            	INNER JOIN EMPRESA AS t3 ON t1.codigo = t3.CD_EMPRESA
            	INNER JOIN Comentario AS t5 ON t1.sequencial = t5.sequencial
            	CROSS JOIN TB_ParcelasAtrasadasUsuario AS t4
            WHERE (t1.status >= @Status_inicial)
            AND (t1.status <= @Status_final)
            AND (T2.TP_ASSOCIADO_EMPRESA = 2)
            AND (t1.tipo_pessoa = 2)
            AND (t1.data_gerado BETWEEN @DataInicial AND @DataFinal)
            AND (T2.DT_PAGAMENTO IS NOT NULL)
            AND (t1.sequencial = t4.sequencial)
            AND (t5.cd_sequencial =
            (SELECT
             	MAX(cd_sequencial) AS Expr1
             FROM Comentario AS t100
             WHERE (t1.sequencial = sequencial)))
            AND (t4.cd_parcela = T2.CD_PARCELA)
            UNION ALL
            SELECT
            	t5.cd_usuario ,
            	t5.dt_comentario ,
            	t3.NM_RAZSOC AS nome ,
            	t5.ds_comentario ,
            	t1.codigo ,
            	CONVERT(VARCHAR(10), t5.dt_comentario, 103) + ' ' + CONVERT(VARCHAR(10), t5.dt_comentario, 108) AS data ,
            	t1.status ,
            	t1.tipo_pessoa ,
            	t1.Faixa_dias_atrasado ,
            	CONVERT(VARCHAR(10), t5.data_impressao, 103) + ' ' + CONVERT(VARCHAR(10), t5.data_impressao, 108) AS data_impressao ,
            	t5.cd_funcionario_inclusao ,
            	t1.nome_usuario ,
            	t1.sequencial ,
            	t4.cd_parcela ,
            	CONVERT(VARCHAR(10), t4.Data_Vencimento, 103) AS data_v ,
            	t4.dias_atraso ,
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
            	AS data_pagamento
            FROM TB_ListaAtrasadosUsuario AS t1
            	INNER JOIN MENSALIDADES AS T2 ON t1.codigo = T2.CD_ASSOCIADO_empresa
            	INNER JOIN EMPRESA AS t3 ON t1.codigo = t3.CD_EMPRESA
            	INNER JOIN Comentario AS t5 ON t1.sequencial = t5.sequencial
            	CROSS JOIN TB_ParcelasAtrasadasUsuario AS t4
            WHERE (t1.status >= @Status_inicial)
            AND (t1.status <= @Status_final)
            AND (t1.tipo_pessoa = 2)
            AND (T2.TP_ASSOCIADO_EMPRESA = 2)
            AND (t1.data_gerado BETWEEN @DataInicial AND @DataFinal)
            AND (T2.DT_PAGAMENTO IS NULL)
            AND (t1.sequencial = t4.sequencial)
            AND (t5.cd_sequencial =
            (SELECT
             	MAX(cd_sequencial) AS Expr1
             FROM Comentario AS t100
             WHERE (t1.sequencial = sequencial)))
            AND (t4.cd_parcela = T2.CD_PARCELA)
            ORDER BY t1.nome_usuario,
                     t5.dt_comentario
		END

	END
