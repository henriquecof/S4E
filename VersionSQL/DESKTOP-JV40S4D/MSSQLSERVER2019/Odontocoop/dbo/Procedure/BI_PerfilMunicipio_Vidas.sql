/****** Object:  Procedure [dbo].[BI_PerfilMunicipio_Vidas]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[BI_PerfilMunicipio_Vidas]
AS BEGIN

		/*
		Data e Hora.: 2022-05-30 16:39:45
		Usuário.: henrique.almeida
		Database.: S4ECLEAN
		Servidor.: 10.1.1.10\homologacao
		Comentário.: REALIZADO PADRONIZAÇÃO T-SQL E FORMATAÇÃO.
		*/



    /***
    ESSA PROCEDURE REALIZA PRIMEIRAMENTE UM INSERT NA TABELA 
    PrevsystemBI..Perfil_Municipio_Vidas USANDO COMO REFERENCIAS AS TABELAS.:
    ASSOCIADOS AS A ,
    DEPENDENTES AS D1 , 
    HISTORICO AS H1 , 
    SITUACAO_HISTORICO AS S1 , 
    FUNCIONARIO AS F1, 
    FILIAL AS FI1,  /* USUARIO */
    DEPENDENTES AS D2 , 
    HISTORICO AS H2 , 
    SITUACAO_HISTORICO AS S2 , 
    FUNCIONARIO AS F2,/* TITULAR */
    UF, 
    MUNICIPIO AS M, 
    BAIRRO AS B , 
    EMPRESA AS E, 
    PLANOS AS P ,
    HISTORICO AS H3, 
    SITUACAO_HISTORICO AS S3, 
    CENTRO_CUSTO AS CC, 
    TIPO_EMPRESA AS TE, 
    TIPO_PAGAMENTO TP, -- EMPRESA
    GRAU_PARENTESCO AS GP , 
    DEPARTAMENTO AS DEPTO
    
    APOS O INSERT SÃO REALIZADOS UPDATES, ONDE ESTÃO COMENTADOS ANTES DE CADA UM PARA ENTENDIMENTO
    ***/


		INSERT INTO PrevsystemBI..Perfil_Municipio_Vidas ( cd_centro_custo,
		                                                   ds_centro_custo,
		                                                   CD_UF_num,
		                                                   nm_uf,
		                                                   cd_municipio,
		                                                   NM_MUNICIPIO,
		                                                   cd_bairro,
		                                                   nm_bairro,
		                                                   cd_plano,
		                                                   nm_plano,
		                                                   TP_EMPRESA,
		                                                   ds_empresa,
		                                                   CD_TIPO_PAGAMENTO,
		                                                   ds_tipo_pagamento,
		                                                   fl_exige_dentista,
		                                                   cd_dentista,
		                                                   nm_dentista,
		                                                   cd_clinica,
		                                                   nm_clinica,
		                                                   CD_EMPRESA,
		                                                   NM_FANTASIA,
		                                                   qtde_usuarios,
		                                                   Valor_Fatura,
		                                                   cd_associado,
		                                                   nm_responsavel,
		                                                   nm_usuario,
		                                                   idade_faixa,
		                                                   cd_sequencial_dep,
		                                                   dt_ass_contrato,
		                                                   fl_ativo,
		                                                   sexo,
		                                                   GRAU_PARENTESCO,
		                                                   tempo_contrato,
		                                                   qt_vidas_funcionario,
		                                                   idade,
		                                                   cd_vendedor,
		                                                   nm_vendedor,
		                                                   Regiao,
		                                                   Departamento )
			SELECT
            	cc.cd_centro_custo ,
            	cc.ds_centro_custo ,
            	UF.ufId ,
            	UF.ufSigla ,
            	CASE    WHEN m.cd_municipio IS NULL THEN 0
            			ELSE m.cd_municipio END AS cd_municipio ,
            	CASE    WHEN m.nm_municipio IS NULL THEN 'NÂO INFORMADO'
            			ELSE m.nm_municipio END AS nm_municipio ,
            	CASE    WHEN m.fl_bairro = 1 THEN ISNULL(a.BaiId , 0)
            			ELSE 0 END BaiId ,
            	CASE    WHEN m.fl_bairro = 1 THEN b.baiDescricao
            		    WHEN ISNULL(m.fl_bairro , 0) = 0
            		AND m.cd_municipio IS NOT NULL THEN m.nm_municipio
            			ELSE 'Não Informado' END baiDescricao ,
            	d1.cd_plano ,
            	p.nm_plano ,
            	e.TP_EMPRESA ,
            	te.ds_empresa ,
            	CASE    WHEN p.fl_exige_dentista = 1 THEN 0
            			ELSE e.CD_TIPO_PAGAMENTO END ,
            	CASE    WHEN p.fl_exige_dentista = 1 THEN 'Ortodontia'
            			ELSE tp.nm_tipo_pagamento END ,
            	p.fl_exige_dentista ,
            	d1.cd_funcionario_dentista ,
            	f1.nm_empregado ,
            	d1.cd_clinica ,
            	fi1.nm_filial ,
            	--null, null, null, null,
            	e.CD_EMPRESA ,
            	e.NM_FANTASIA ,
            	1 ,
            	d1.vl_plano ,
            	a.cd_associado ,
            	a.nm_completo ,
            	d1.NM_DEPENDENTE ,
            	CASE    WHEN dbo.FS_Idade(d1.dt_nascimento , GETDATE()) <= 7 THEN '0 a 7 anos'
            		    WHEN dbo.FS_Idade(d1.dt_nascimento , GETDATE()) <= 12 THEN '8 a 12 anos'
            		    WHEN dbo.FS_Idade(d1.dt_nascimento , GETDATE()) <= 21 THEN '13 a 21 anos'
            		    WHEN dbo.FS_Idade(d1.dt_nascimento , GETDATE()) <= 31 THEN '22 a 31 anos'
            		    WHEN dbo.FS_Idade(d1.dt_nascimento , GETDATE()) <= 41 THEN '32 a 41 anos'
            		    WHEN dbo.FS_Idade(d1.dt_nascimento , GETDATE()) <= 51 THEN '42 a 51 anos'
            		    WHEN dbo.FS_Idade(d1.dt_nascimento , GETDATE()) <= 61 THEN '52 a 61 anos'
            		    WHEN dbo.FS_Idade(d1.dt_nascimento , GETDATE()) <= 71 THEN '62 a 71 anos'
            			ELSE '72 anos e superior' END ,
            	d1.cd_sequencial ,
            	d1.dt_assinaturaContrato ,
            	CASE    WHEN s1.fl_incluir_ans = 1
            		AND s2.fl_incluir_ans = 1
            		AND s3.fl_incluir_ans = 1 THEN 1
            			ELSE 0 END ,
            	CASE    WHEN d1.fl_sexo = 0 THEN 'Feminino'
            			ELSE 'Masculino' END ,
            	gp.nm_grau_parentesco ,
            	CASE    WHEN DATEDIFF(MONTH , d1.dt_assinaturaContrato , GETDATE()) <= 3 THEN 'Até 3 meses'
            		    WHEN DATEDIFF(MONTH , d1.dt_assinaturaContrato , GETDATE()) <= 6 THEN 'Entre 4 e 6 meses'
            		    WHEN DATEDIFF(MONTH , d1.dt_assinaturaContrato , GETDATE()) <= 9 THEN 'Entre 7 e 9 meses'
            		    WHEN DATEDIFF(MONTH , d1.dt_assinaturaContrato , GETDATE()) < 12 THEN 'Entre 10 e 11 meses'
            		    WHEN DATEDIFF(MONTH , d1.dt_assinaturaContrato , GETDATE()) < 24 THEN 'Entre 12 e 23 meses'
            		    WHEN DATEDIFF(MONTH , d1.dt_assinaturaContrato , GETDATE()) < 36 THEN 'Entre 24 e 35 meses'
            		    WHEN DATEDIFF(MONTH , d1.dt_assinaturaContrato , GETDATE()) < 48 THEN 'Entre 36 e 47 meses'
            		    WHEN DATEDIFF(MONTH , d1.dt_assinaturaContrato , GETDATE()) < 60 THEN 'Entre 48 e 59 meses'
            			ELSE 'Superior 60 meses' END ,
            	e.qt_funcionarios qt_vidas_funcionario ,
            	dbo.FS_Idade(d1.dt_nascimento , GETDATE()) ,
            	d1.cd_vendedor ,
            	d1.nm_vendedor ,
            	'Não Indenficado' ,
            	ISNULL(depto.depDescricao , '-')
            --FROM ASSOCIADOS AS a,
            --	DEPENDENTES AS d1,
            --	Historico AS h1,
            --	SITUACAO_HISTORICO AS s1,
            --	FUNCIONARIO AS f1,
            --	FILIAL AS fi1, /* Usuario */
            --	DEPENDENTES AS d2,
            --	Historico AS h2,
            --	SITUACAO_HISTORICO AS s2,
            --	FUNCIONARIO AS f2,/* Titular */
            --	UF,
            --	MUNICIPIO AS m,
            --	Bairro AS b,
            --	EMPRESA AS e,
            --	PLANOS AS p,
            --	Historico AS h3,
            --	SITUACAO_HISTORICO AS s3,
            --	Centro_Custo AS cc,
            --	TIPO_EMPRESA AS te,
            --	TIPO_PAGAMENTO tp, -- Empresa
            --	GRAU_PARENTESCO AS gp,
            --	Departamento AS depto
            --WHERE a.cd_associado = d1.cd_associado
            --AND a.CD_EMPRESA = e.CD_EMPRESA
            --AND e.cd_centro_custo = cc.cd_centro_custo
            --AND e.tp_empresa = te.tp_empresa
            --AND e.CD_TIPO_PAGAMENTO = tp.CD_TIPO_PAGAMENTO
            --AND d1.cd_grau_parentesco = gp.cd_grau_parentesco
            --AND d1.cd_plano = p.cd_plano
            --AND d1.cd_funcionario_dentista = f1.cd_funcionario
            --AND d1.cd_clinica = fi1.cd_filial
            --AND d1.CD_Sequencial_historico = h1.cd_sequencial
            --AND h1.cd_situacao = s1.CD_SITUACAO_HISTORICO
            --AND d1.cd_vendedor = f2.cd_funcionario
            --AND
            ----s1.fl_incluir_ans=1 and

            --d1.cd_associado = d2.cd_associado
            --AND d2.cd_grau_parentesco = 1
            --AND d2.CD_Sequencial_historico = h2.cd_sequencial
            --AND h2.cd_situacao = s2.CD_SITUACAO_HISTORICO
            --AND
            ----s2.fl_incluir_ans=1 and

            --e.CD_Sequencial_historico = h3.cd_sequencial
            --AND h3.cd_situacao = s3.CD_SITUACAO_HISTORICO
            --AND
            ----s3.fl_incluir_ans=1 and

            --ISNULL(a.ufId , 0) = UF.ufId
            --AND ISNULL(a.CidID , 0) = m.cd_municipio
            --AND ISNULL(a.BaiId , 0) = b.BaiId
            --AND e.tp_empresa < 10
            --AND a.depId = depto.depId

            FROM ASSOCIADOS AS a
            	INNER JOIN DEPENDENTES AS d1 ON a.cd_associado = d1.CD_ASSOCIADO
            	INNER JOIN EMPRESA AS e ON a.cd_empresa = e.CD_EMPRESA
            	INNER JOIN Centro_Custo AS cc ON e.cd_centro_custo = cc.cd_centro_custo
            	INNER JOIN TIPO_EMPRESA AS te ON e.TP_EMPRESA = te.tp_empresa
            	INNER JOIN TIPO_PAGAMENTO AS tp ON e.cd_tipo_pagamento = tp.cd_tipo_pagamento
            	INNER JOIN GRAU_PARENTESCO AS gp ON d1.CD_GRAU_PARENTESCO = gp.cd_grau_parentesco
            	INNER JOIN PLANOS AS p ON d1.cd_plano = p.cd_plano
            	INNER JOIN FUNCIONARIO AS f1 ON d1.cd_funcionario_dentista = f1.cd_funcionario
            	INNER JOIN FILIAL AS fi1 ON d1.cd_clinica = fi1.cd_filial
            	INNER JOIN HISTORICO AS h1 ON d1.CD_Sequencial_historico = h1.cd_sequencial
            	INNER JOIN SITUACAO_HISTORICO AS s1 ON h1.CD_SITUACAO = s1.CD_SITUACAO_HISTORICO
            	INNER JOIN FUNCIONARIO AS f2 ON d1.cd_vendedor = f2.cd_funcionario
            	INNER JOIN DEPENDENTES AS d2 ON d1.CD_ASSOCIADO = d2.CD_ASSOCIADO
            	INNER JOIN HISTORICO AS h2 ON d2.CD_Sequencial_historico = h2.cd_sequencial
            	INNER JOIN SITUACAO_HISTORICO AS s2 ON h2.CD_SITUACAO = s2.CD_SITUACAO_HISTORICO
            	INNER JOIN HISTORICO AS h3 ON e.CD_Sequencial_historico = h3.cd_sequencial
            	INNER JOIN SITUACAO_HISTORICO AS s3 ON h3.CD_SITUACAO = s3.CD_SITUACAO_HISTORICO
            	INNER JOIN UF ON ISNULL(a.ufId, 0) = UF.ufId
            	INNER JOIN MUNICIPIO AS m ON ISNULL(a.CidID, 0) = m.CD_MUNICIPIO
            	INNER JOIN Bairro AS b ON ISNULL(a.BaiId, 0) = b.baiId
            	INNER JOIN Departamento AS depto ON a.depId = depto.depId
            WHERE (d2.CD_GRAU_PARENTESCO = 1)
            AND (e.TP_EMPRESA < 10)

		DECLARE @licenca VARCHAR(100)
		SELECT
        	@licenca = LicencaS4E
        FROM Configuracao

		IF @licenca NOT IN ('QJSH717634HGSD981276SDSCVJHSD8721365SAAUS7A615002' , 'HYYT76658HFKJNXBEY46WUYU1276745JHFJDHJDFDVCGFD020') BEGIN

			-- ATUALIZA O ORTODONTISTA E CLINICA PELO ULTIMO ATENDIMENTO
			UPDATE PrevsystemBI..Perfil_Municipio_Vidas SET cd_dentista = y.cd_funcionario ,
					cd_clinica = y.cd_filial ,
					nm_dentista = f.nm_empregado ,
					nm_clinica = fi.nm_filial
			--FROM (
			--         SELECT
			--               	x.cd_sequencial_dep ,
			--               	c.cd_funcionario ,
			--               	c.cd_filial
			--               FROM Consultas AS c,
			--               	ServicoEspecialidade AS s,
			--               	ESPECIALIDADE AS e,
			--               	(SELECT
			--                  	pv.cd_sequencial_dep ,
			--                  	MAX(c.dt_servico) AS dt_serv
			--                  FROM PrevsystemBI..Perfil_Municipio_Vidas AS pv,
			--                  	ServicoEspecialidade AS s,
			--                  	ESPECIALIDADE AS e,
			--                  	Consultas AS c
			--                  WHERE fl_exige_dentista = 1
			--                  AND e.fl_ortodontia = 1
			--                  AND s.cd_especialidade = e.cd_especialidade
			--                  AND s.cd_servico = c.cd_servico
			--                  AND c.cd_sequencial_dep = pv.cd_sequencial_dep
			--                  AND c.dt_servico IS NOT NULL
			--                  AND c.dt_cancelamento IS NULL
			--                  AND c.Status IN (3 , 6 , 7) --and
			--                  GROUP BY pv.cd_sequencial_dep
			--               	) AS x
			--               WHERE c.cd_sequencial_dep = x.cd_sequencial_dep
			--               AND c.dt_servico = x.dt_serv
			--               AND e.fl_ortodontia = 1
			--               AND s.cd_especialidade = e.cd_especialidade
			--               AND s.cd_servico = c.cd_servico
			--               AND c.dt_cancelamento IS NULL
			--               AND c.Status IN (3 , 6 , 7)
			--	) AS y,
			--	FUNCIONARIO AS f,
			--	FILIAL AS fi
			--WHERE PrevsystemBI..Perfil_Municipio_Vidas.cd_sequencial_dep = y.cd_sequencial_dep
			--AND y.cd_funcionario = f.cd_funcionario
			--AND y.cd_filial = fi.cd_filial
			--AND PrevsystemBI..Perfil_Municipio_Vidas.fl_exige_dentista = 1

			FROM (SELECT
                  	x.cd_sequencial_dep ,
                  	c.CD_FUNCIONARIO ,
                  	c.cd_filial
                  FROM ServicoEspecialidade AS s
                  	INNER JOIN ESPECIALIDADE AS e ON s.cd_especialidade = e.cd_especialidade
                  	INNER JOIN Consultas AS c
                  	INNER JOIN (SELECT
                                	pv.cd_sequencial_dep ,
                                	MAX(c.dt_servico) AS dt_serv
                                FROM ESPECIALIDADE AS e
                                	INNER JOIN ServicoEspecialidade AS s ON e.cd_especialidade = s.cd_especialidade
                                	INNER JOIN Consultas AS c ON s.cd_servico = c.cd_servico
                                	CROSS JOIN PrevsystemBI.dbo.Perfil_Municipio_Vidas AS pv
                                WHERE (fl_exige_dentista = 1)
                                AND (e.fl_ortodontia = 1)
                                AND (c.cd_sequencial_dep = pv.cd_sequencial_dep)
                                AND (c.dt_servico IS NOT NULL)
                                AND (c.dt_cancelamento IS NULL)
                                AND (c.Status IN (3, 6, 7))
                                GROUP BY pv.cd_sequencial_dep) AS x ON c.cd_sequencial_dep = x.cd_sequencial_dep
                  		AND c.dt_servico = x.dt_serv ON s.cd_servico = c.cd_servico
                  WHERE (e.fl_ortodontia = 1)
                  AND (c.dt_cancelamento IS NULL)
                  AND (c.Status IN (3, 6, 7))) AS y
				INNER JOIN FUNCIONARIO AS f ON y.CD_FUNCIONARIO = f.cd_funcionario
				INNER JOIN FILIAL AS fi ON y.cd_filial = fi.cd_filial
			WHERE (PrevsystemBI.Perfil_Municipio_Vidas.cd_sequencial_dep = y.cd_sequencial_dep)
			AND (PrevsystemBI.Perfil_Municipio_Vidas.fl_exige_dentista = 1)

		END

		-- FIM VIDAS ATIVAS

		-- ATUALIZAR FL_EXIGE_DENTISTA =1  SE O PLANO TEM COBERTURA ORTODONTICA -- ATUALIZAR A REGIAO
		UPDATE PrevsystemBI..Perfil_Municipio_Vidas SET PrevsystemBI..Perfil_Municipio_Vidas.fl_exige_dentista = 1
		WHERE cd_plano IN (SELECT
                           	cd_plano
                           FROM PLANO_SERVICO
                           WHERE cd_servico = 86000357
		)

		-- ATUALIZAR A REGIAO
		UPDATE PrevsystemBI..Perfil_Municipio_Vidas SET PrevsystemBI..Perfil_Municipio_Vidas.Regiao = r.ds_regiao
		FROM MUNICIPIO AS m INNER JOIN
			Regiao AS r ON M.id_regiao=R.id_regiao
		WHERE PrevsystemBI..Perfil_Municipio_Vidas.cd_municipio = m.cd_municipio
		AND m.id_regiao = r.id_regiao

		-- ATUALIZAR OS QUE NAO INICIARAM TRATAMENTO
		UPDATE PrevsystemBI..Perfil_Municipio_Vidas SET cd_dentista = 0 ,
				nm_dentista = 'Não Identificado'
		WHERE fl_exige_dentista = 1
		AND cd_dentista IS NULL

		UPDATE PrevsystemBI..Perfil_Municipio_Vidas SET cd_clinica = 0 ,
				nm_clinica = 'Não Identificado'
		WHERE fl_exige_dentista = 1
		AND cd_clinica IS NULL

		-- ATUALIZAR OS QUE NAO TEM CONTRATO
		UPDATE PrevsystemBI..Perfil_Municipio_Vidas SET cd_dentista = NULL ,
				cd_clinica = NULL ,
				nm_dentista = NULL ,
				nm_clinica = NULL
		WHERE fl_exige_dentista = 0
		AND cd_dentista IS NOT NULL

		UPDATE PrevsystemBI..Perfil_Municipio_Vidas SET cd_dentista = NULL ,
				cd_clinica = NULL ,
				nm_dentista = NULL ,
				nm_clinica = NULL
		WHERE fl_exige_dentista = 0
		AND cd_clinica IS NOT NULL

	END
