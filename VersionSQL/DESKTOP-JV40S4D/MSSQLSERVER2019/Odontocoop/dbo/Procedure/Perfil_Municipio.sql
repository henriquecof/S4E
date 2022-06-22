/****** Object:  Procedure [dbo].[Perfil_Municipio]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[Perfil_Municipio]
/*
Data e Hora.: 2022-05-24 14:30:45
Usuário.: henrique.almeida
Database.: S4ECLEAN
Servidor.: 10.1.1.10\homologacao
Comentário.: REALIZADO PADRONIZAÇÃO T-SQL E FORMATAÇÃO.
QUERY ANTIGA COMENTADA DEIXA NO CÓDIGO PARA HISTORICO.
*/

AS BEGIN

		DECLARE @dt_i DATETIME
		DECLARE @dt_f DATETIME

		SET @dt_i = CONVERT(DATETIME , CONVERT(VARCHAR(2) , MONTH(DATEADD(MONTH , -1 , GETDATE()))) + '/01/' + CONVERT(VARCHAR(4) , YEAR(DATEADD(MONTH , -1 , GETDATE()))))
		SET @dt_f = DATEADD(DAY , -1 , DATEADD(MONTH , 1 , @dt_i)) + '23:59'

		DELETE S4Ebi..Perfil_Municipio

		INSERT INTO S4Ebi..Perfil_Municipio ( CD_UF_num,
		                                      cd_municipio,
		                                      nm_municipio,
		                                      vl_receita,
		                                      limite_gasto,
		                                      qt_titular,
		                                      qt_dependentes,
		                                      Qtde_Atendimentos_Necessarios,
		                                      vl_minimo_atendimento,
		                                      vl_maximo_atendimento )

			--SELECT
			--         	CD_UF_num ,
			--         	cd_municipio ,
			--         	nm_municipio ,
			--         	SUM(vl_parcela) AS Receita ,
			--         	SUM(vl_parcela) * .6 AS LimiteGasto ,
			--         	COUNT(0) AS Titulares ,
			--         	SUM(qtde) AS Dependentes ,
			--         	CONVERT(INT , (COUNT(0) + SUM(qtde)) * .45) AS Qtde_Atendimentos_Necessarios ,
			--         	(COUNT(0) + SUM(qtde)) * .45 * 9 AS Qtde_Atendimentos_Necessarios_9 ,
			--         	(COUNT(0) + SUM(qtde)) * .45 * 12 AS Qtde_Atendimentos_Necessarios_12
			--         FROM (SELECT
			--               	a.cd_Associado ,
			--               	a.cd_empresa ,
			--               	m.cd_municipio ,
			--               	m.nm_municipio ,
			--               	m1.vl_parcela ,
			--               	ISNULL(m.CD_UF_num , 9999) AS CD_UF_num ,
			--               	(SELECT
			--                  	COUNT(*)
			--                  FROM Dependentes AS d1
			--                  WHERE a.cd_Associado = d1.cd_Associado
			--                  AND d1.cd_sequencial > 1
			--                  AND d1.CD_SITUACAO IN (SELECT
			--                                         	CD_SITUACAO_HISTORICO
			--                                         FROM SITUACAO_HISTORICO
			--                                         WHERE fl_atendido_clinica = 1)) AS qtde

			--               FROM ASSOCIADOS AS a,
			--               	MUNICIPIO AS m,
			--               	MENSALIDADES AS m1,
			--               	EMPRESA AS e
			--               WHERE a.CidID = m.cd_municipio
			--               AND a.cd_Associado = m1.CD_ASSOCIADO_empresa
			--               AND m1.TP_ASSOCIADO_EMPRESA = 1
			--               AND e.CD_EMPRESA = a.CD_EMPRESA
			--               AND
			--               --      m.cd_uf_num     = 5 and
			--               e.cd_tipo_pagamento NOT IN (11 , 88 , 89 , 90 , 91 , 92 , 94 , 98)
			--               AND m1.dt_vencimento BETWEEN @dt_i AND @dt_f
			--               AND m1.cd_parcela <= 32000
			--         	) AS x
			--         GROUP BY CD_UF_num,
			--                  NM_MUNICIPIO,
			--                  cd_municipio
			--         -- having sum(vl_parcela)>1000 and cd_municipio<>41
			--         ORDER BY CD_UF_num,
			--                  NM_MUNICIPIO

			SELECT
            	CD_UF_num ,
            	CD_MUNICIPIO ,
            	NM_MUNICIPIO ,
            	SUM(VL_PARCELA) AS Receita ,
            	SUM(VL_PARCELA) * .6 AS LimiteGasto ,
            	COUNT(0) AS Titulares ,
            	SUM(qtde) AS Dependentes ,
            	CONVERT(INT, (COUNT(0) + SUM(qtde)) * .45)
            	AS Qtde_Atendimentos_Necessarios ,
            	(COUNT(0) + SUM(qtde)) * .45 * 9 AS Qtde_Atendimentos_Necessarios_9 ,
            	(COUNT(0) + SUM(qtde)) * .45 * 12 AS Qtde_Atendimentos_Necessarios_12
            FROM (SELECT
                  	a.cd_associado ,
                  	a.cd_empresa ,
                  	m.CD_MUNICIPIO ,
                  	m.NM_MUNICIPIO ,
                  	m1.VL_PARCELA ,
                  	ISNULL(m.CD_UF_num, 9999) AS CD_UF_num ,
                  	(SELECT
                     	COUNT(*)
                     FROM DEPENDENTES AS d1
                     WHERE (a.cd_associado = CD_ASSOCIADO)
                     AND (CD_SEQUENCIAL > 1)
                     AND (cd_situacao IN
                     (SELECT
                      	CD_SITUACAO_HISTORICO
                      FROM SITUACAO_HISTORICO
                      WHERE (fl_atendido_clinica = 1)))) AS qtde
                  FROM ASSOCIADOS AS a
                  	INNER JOIN MUNICIPIO AS m ON a.CidID = m.CD_MUNICIPIO
                  	INNER JOIN MENSALIDADES AS m1 ON a.cd_associado = m1.CD_ASSOCIADO_empresa
                  	INNER JOIN EMPRESA AS e ON a.cd_empresa = e.CD_EMPRESA
                  WHERE (m1.TP_ASSOCIADO_EMPRESA = 1)
                  AND (e.cd_tipo_pagamento NOT IN (11, 88, 89, 90, 91, 92, 94, 98))
                  AND (m1.DT_VENCIMENTO BETWEEN @dt_i AND @dt_f)
                  AND (m1.CD_PARCELA <= 32000)) AS x
            GROUP BY CD_UF_num,
                     NM_MUNICIPIO,
                     CD_MUNICIPIO
            ORDER BY CD_UF_num,
                     NM_MUNICIPIO

		INSERT INTO S4Ebi..Perfil_Municipio ( CD_UF_num,
		                                      cd_municipio,
		                                      NM_MUNICIPIO,
		                                      vl_receita,
		                                      limite_gasto,
		                                      qt_titular,
		                                      qt_dependentes,
		                                      Qtde_Atendimentos_Necessarios,
		                                      vl_minimo_atendimento,
		                                      vl_maximo_atendimento )

			SELECT
            	CD_UF_num ,
            	999999 ,
            	NULL ,
            	SUM(vl_receita) ,
            	SUM(limite_gasto) ,
            	SUM(qt_titular) ,
            	SUM(qt_dependentes) ,
            	SUM(Qtde_Atendimentos_Necessarios) ,
            	SUM(vl_minimo_atendimento) ,
            	SUM(vl_maximo_atendimento)
            FROM S4Ebi..Perfil_Municipio
            GROUP BY CD_UF_num



	END
