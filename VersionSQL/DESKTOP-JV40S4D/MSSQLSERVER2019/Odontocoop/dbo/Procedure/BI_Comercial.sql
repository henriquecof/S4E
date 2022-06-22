/****** Object:  Procedure [dbo].[BI_Comercial]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[BI_Comercial]


/***
PRIMEIRO ESSA PROCEDURE REALIZA A EXCLUSÃO DE REGISTROS QUE CONSTAM COMO NÃO FINALIZADOS NA TABELA PREVSYSTEMBI..COMERCIAL
QUANDO DT_FINALIZACAO_LOTE FOR IS NULL.

APÓS É REALIZADO O INSERT NA PrevsystemBI..comercial CONFORME SELECT USADO PEGANDO COMO REFERENCIA AS TABELAS.:
LOTE_CONTRATOS_CONTRATOS_VENDEDOR T1, 
DEPENDENTES T3, 
ASSOCIADOS T2, 
PLANOS T6 , 
FUNCIONARIO T7 , -- VENDEDOR
EMPRESA AS T5,
EQUIPE_VENDAS T8,
TIPO_PAGAMENTO AS T9, 
LOTE_CONTRATOS AS T10,
FUNCIONARIO T11 
***/

/*
Data e Hora.: 2022-05-24 13:33:47
Usuário.: henrique.almeida
Database.: S4ECLEAN
Servidor.: 10.1.1.10\homologacao
Comentário.: REALIZADO PADRONIZAÇÃO T-SQL E FORMATAÇÃO. QUERY ANTIGA MANTIDA
COMENTADA.
*/



AS BEGIN

		-- Excluir os registros nao finalizados
		DELETE PrevsystemBI..comercial
		WHERE dt_finalizado_lote IS NULL

		INSERT PrevsystemBI..comercial ( id,
		                                 Lote,
		                                 contrato,
		                                 cd_sequencial_dep,
		                                 Cadastro,
		                                 cd_associado,
		                                 Responsavel,
		                                 Usuario,
		                                 CD_EMPRESA,
		                                 EMPRESA,
		                                 cd_equipe,
		                                 Equipe,
		                                 cd_funcionario,
		                                 Vendedor,
		                                 CD_TIPO_PAGAMENTO,
		                                 TipoPagamento,
		                                 cd_plano,
		                                 Plano,
		                                 Valor,
		                                 Ano,
		                                 Mes,
		                                 Dia,
		                                 dt_finalizado_lote,
		                                 cd_funcionario_adesionista,
		                                 dt_assinaturaContrato,
		                                 nm_funcionario_adesionista,
		                                 Ano_assinatura,
		                                 Mes_assinatura,
		                                 Dia_assinatura )

			--SELECT
			--         	T1.id ,
			--         	T1.cd_sequencial_lote ,
			--         	T1.cd_contrato ,
			--         	T3.cd_sequencial ,
			--         	CONVERT(DATETIME , CONVERT(VARCHAR(10) , T1.dt_cadastro , 101)) ,
			--         	T2.cd_associado ,
			--         	T2.nm_completo ,
			--         	T3.NM_DEPENDENTE ,
			--         	T2.CD_EMPRESA ,
			--         	t5.NM_FANTASIA ,
			--         	ISNULL(T1.cd_equipe , 0) ,
			--         	ISNULL(t8.nm_equipe , 'Empresa') ,
			--         	t7.cd_funcionario ,
			--         	t7.nm_empregado ,
			--         	t5.CD_TIPO_PAGAMENTO ,
			--         	t9.nm_tipo_pagamento ,
			--         	t6.cd_plano ,
			--         	t6.nm_plano ,
			--         	T1.vl_contrato ,
			--         	YEAR(T1.dt_cadastro) AS ano ,
			--         	MONTH(T1.dt_cadastro) AS mes ,
			--         	DAY(T1.dt_cadastro) AS dia ,
			--         	t10.dt_finalizado ,
			--         	T3.cd_funcionario_adesionista ,
			--         	T1.dt_assinaturaContrato ,
			--         	ISNULL(t11.nm_empregado , '(Sem Identificação)') ,
			--         	YEAR(T1.dt_assinaturaContrato) AS ano ,
			--         	MONTH(T1.dt_assinaturaContrato) AS mes ,
			--         	DAY(T1.dt_assinaturaContrato) AS dia
			--         FROM lote_contratos_contratos_vendedor T1,
			--         	DEPENDENTES T3,
			--         	ASSOCIADOS T2,
			--         	PLANOS t6,
			--         	FUNCIONARIO t7, -- Vendedor
			--         	EMPRESA AS t5,
			--         	equipe_vendas t8,
			--         	TIPO_PAGAMENTO AS t9,
			--         	lote_contratos AS t10,
			--         	FUNCIONARIO t11 -- Adesionista
			--         WHERE T1.cd_sequencial_dep = T3.cd_sequencial
			--         AND T1.cd_Equipe = t8.cd_Equipe
			--         AND T1.cd_sequencial_lote = t10.cd_sequencial
			--         AND T3.cd_associado = T2.cd_associado
			--         AND T3.cd_plano = t6.cd_plano
			--         AND T3.cd_funcionario_vendedor = t7.cd_funcionario
			--         AND T3.cd_funcionario_adesionista = t11.cd_funcionario
			--         AND T2.cd_empresa = t5.cd_empresa
			--         AND t5.cd_tipo_pagamento = t9.cd_tipo_pagamento
			--         AND T1.id NOT IN (SELECT
			--                           	id
			--                           FROM PrevsystemBI..comercial)
			--         AND T1.fl_excluida IS NULL
			--         AND t5.TP_EMPRESA < 10

			SELECT
            	T1.id ,
            	T1.cd_sequencial_lote ,
            	T1.cd_contrato ,
            	T3.CD_SEQUENCIAL ,
            	CONVERT(DATETIME, CONVERT(VARCHAR(10), T1.dt_cadastro, 101)) AS Expr1 ,
            	T2.cd_associado ,
            	T2.nm_completo ,
            	T3.NM_DEPENDENTE ,
            	T2.cd_empresa ,
            	t5.NM_FANTASIA ,
            	ISNULL(T1.cd_equipe, 0) AS Expr2 ,
            	ISNULL(t8.nm_equipe, 'Empresa') AS Expr3 ,
            	t7.cd_funcionario ,
            	t7.nm_empregado ,
            	t5.cd_tipo_pagamento ,
            	t9.nm_tipo_pagamento ,
            	t6.cd_plano ,
            	t6.nm_plano ,
            	T1.vl_contrato ,
            	YEAR(T1.dt_cadastro) AS ano ,
            	MONTH(T1.dt_cadastro) AS mes ,
            	DAY(T1.dt_cadastro) AS dia ,
            	t10.dt_finalizado ,
            	T3.cd_funcionario_adesionista ,
            	T1.dt_assinaturaContrato ,
            	ISNULL(t11.nm_empregado, '(Sem Identificação)')
            	AS Expr4 ,
            	YEAR(T1.dt_assinaturaContrato) AS ano ,
            	MONTH(T1.dt_assinaturaContrato) AS mes ,
            	DAY(T1.dt_assinaturaContrato) AS dia
            FROM lote_contratos_contratos_vendedor AS T1
            	INNER JOIN DEPENDENTES AS T3 ON T1.cd_sequencial_dep = T3.CD_SEQUENCIAL
            	INNER JOIN equipe_vendas AS t8 ON T1.cd_equipe = t8.cd_equipe
            	INNER JOIN lote_contratos AS t10 ON T1.cd_sequencial_lote = t10.cd_sequencial
            	INNER JOIN ASSOCIADOS AS T2 ON T3.CD_ASSOCIADO = T2.cd_associado
            	INNER JOIN PLANOS AS t6 ON T3.cd_plano = t6.cd_plano
            	INNER JOIN FUNCIONARIO AS t7 ON T3.cd_funcionario_vendedor = t7.cd_funcionario
            	INNER JOIN FUNCIONARIO AS t11 ON T3.cd_funcionario_adesionista = t11.cd_funcionario
            	INNER JOIN EMPRESA AS t5 ON T2.cd_empresa = t5.CD_EMPRESA
            	INNER JOIN TIPO_PAGAMENTO AS t9 ON t5.cd_tipo_pagamento = t9.cd_tipo_pagamento
            WHERE (T1.id NOT IN
            (SELECT
             	T1.id
             FROM PrevsystemBI.dbo.comercial))
            AND (T1.fl_excluida IS NULL)
            AND (t5.TP_EMPRESA < 10)

	END
