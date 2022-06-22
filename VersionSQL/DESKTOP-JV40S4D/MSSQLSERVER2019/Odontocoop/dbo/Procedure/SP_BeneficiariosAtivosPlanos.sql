/****** Object:  Procedure [dbo].[SP_BeneficiariosAtivosPlanos]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[SP_BeneficiariosAtivosPlanos] @cd_centro_custo SMALLINT = NULL,
	@CD_GRUPOAnalise INT = NULL,
	@depid INT = NULL,
	@cd_grupo INT = NULL
AS
BEGIN
	IF (
			SELECT LicencaS4E
			FROM Configuracao
			) IN ('THGF6453JD81HDHCBVJG856SHFG57656JHDFDSDFGTHJJJ015')
	BEGIN --1
		IF @cd_centro_custo > 0
		BEGIN --1.1
			SELECT        c.ds_centro_custo, cans.ds_classificacao AS nm_plano, cans.ds_classificacao, COUNT(0) AS qt_tit, SUM(d1.vl_plano) AS vl_plano
FROM            ASSOCIADOS AS a INNER JOIN
                         DEPENDENTES AS d1 ON a.cd_associado = d1.CD_ASSOCIADO INNER JOIN
                         EMPRESA AS e ON a.cd_empresa = e.CD_EMPRESA INNER JOIN
                         Centro_Custo AS c ON e.cd_centro_custo = c.cd_centro_custo INNER JOIN
                         PLANOS AS p ON d1.cd_plano = p.cd_plano INNER JOIN
                         HISTORICO AS h1 ON d1.CD_Sequencial_historico = h1.cd_sequencial INNER JOIN
                         SITUACAO_HISTORICO AS s1 ON h1.CD_SITUACAO = s1.CD_SITUACAO_HISTORICO LEFT OUTER JOIN
                         CLASSIFICACAO_ANS AS cans ON p.cd_classificacao = cans.cd_classificacao INNER JOIN
                         DEPENDENTES AS d2 ON d1.CD_ASSOCIADO = d2.CD_ASSOCIADO INNER JOIN
                         HISTORICO AS h2 ON d2.CD_Sequencial_historico = h2.cd_sequencial INNER JOIN
                         SITUACAO_HISTORICO AS s2 ON h2.CD_SITUACAO = s2.CD_SITUACAO_HISTORICO INNER JOIN
                         HISTORICO AS h3 ON e.CD_Sequencial_historico = h3.cd_sequencial INNER JOIN
                         SITUACAO_HISTORICO AS s3 ON h3.CD_SITUACAO = s3.CD_SITUACAO_HISTORICO
WHERE        (s1.fl_incluir_ans = 1) AND (d2.CD_GRAU_PARENTESCO = 1) AND (s2.fl_incluir_ans = 1) AND (s3.fl_incluir_ans = 1) AND (e.TP_EMPRESA < 10) AND (e.ufId IS NOT NULL) AND (e.cd_centro_custo = @cd_centro_custo)
GROUP BY c.ds_centro_custo, cans.ds_classificacao
ORDER BY c.ds_centro_custo, nm_plano
		END --1.1
		ELSE
		BEGIN --1.2
			SELECT        c.ds_centro_custo, cans.ds_classificacao AS nm_plano, cans.ds_classificacao, COUNT(0) AS qt_tit, SUM(d1.vl_plano) AS vl_plano
FROM            ASSOCIADOS AS a INNER JOIN
                         DEPENDENTES AS d1 ON a.cd_associado = d1.CD_ASSOCIADO INNER JOIN
                         EMPRESA AS e ON a.cd_empresa = e.CD_EMPRESA INNER JOIN
                         Centro_Custo AS c ON e.cd_centro_custo = c.cd_centro_custo INNER JOIN
                         PLANOS AS p ON d1.cd_plano = p.cd_plano INNER JOIN
                         HISTORICO AS h1 ON d1.CD_Sequencial_historico = h1.cd_sequencial INNER JOIN
                         SITUACAO_HISTORICO AS s1 ON h1.CD_SITUACAO = s1.CD_SITUACAO_HISTORICO LEFT OUTER JOIN
                         CLASSIFICACAO_ANS AS cans ON p.cd_classificacao = cans.cd_classificacao INNER JOIN
                         DEPENDENTES AS d2 ON d1.CD_ASSOCIADO = d2.CD_ASSOCIADO INNER JOIN
                         HISTORICO AS h2 ON d2.CD_Sequencial_historico = h2.cd_sequencial INNER JOIN
                         SITUACAO_HISTORICO AS s2 ON h2.CD_SITUACAO = s2.CD_SITUACAO_HISTORICO INNER JOIN
                         HISTORICO AS h3 ON e.CD_Sequencial_historico = h3.cd_sequencial INNER JOIN
                         SITUACAO_HISTORICO AS s3 ON h3.CD_SITUACAO = s3.CD_SITUACAO_HISTORICO
WHERE        (s1.fl_incluir_ans = 1) AND (d2.CD_GRAU_PARENTESCO = 1) AND (s2.fl_incluir_ans = 1) AND (s3.fl_incluir_ans = 1) AND (e.TP_EMPRESA < 10) AND (e.ufId IS NOT NULL)
GROUP BY c.ds_centro_custo, cans.ds_classificacao
ORDER BY c.ds_centro_custo, nm_plano
		END --1.2
	END --1
	ELSE
	BEGIN --2
		DECLARE @sql VARCHAR(max)

		SET @sql = ' Select c.ds_centro_custo , p.nm_plano , cans.ds_classificacao, count(0) as qt_tit, SUM(d1.vl_plano) as vl_plano '
		SET @sql += ' 			from associados as a , '
		SET @sql += ' 				 dependentes as d1, historico as h1, situacao_historico as s1,' -- Usuario 
		SET @sql += ' 				 dependentes as d2, historico as h2, situacao_historico as s2,' -- Titular
		SET @sql += ' 				 planos as p , Centro_Custo as c, '
		SET @sql += ' 				 EMPRESA as e, historico as h3, situacao_historico as s3,' -- Empresa
		SET @sql += ' 				 CLASSIFICACAO_ANS as cans '
		SET @sql += ' 				 where a.cd_Associado = d1.cd_Associado and' -- d1.CD_GRAU_PARENTESCO = 1 and
		SET @sql += ' 					   a.cd_empresa=e.CD_EMPRESA and '
		SET @sql += ' 					   e.cd_centro_custo = c.cd_centro_custo and '
		SET @sql += ' 					   d1.cd_plano= p.cd_plano and '
		SET @sql += ' 					   d1.cd_sequencial_historico = h1.cd_sequencial and '
		SET @sql += ' 					   h1.cd_situacao = s1.cd_situacao_historico and '
		SET @sql += ' 					   s1.fl_incluir_ans=1 and '
		SET @sql += ' 					   p.cd_classificacao *= cans.cd_classificacao and '
		SET @sql += ' 					   d1.CD_ASSOCIADO = d2.cd_associado and '
		SET @sql += ' 					   d2.CD_GRAU_PARENTESCO = 1 and '
		SET @sql += ' 					   d2.cd_sequencial_historico = h2.cd_sequencial and '
		SET @sql += ' 					   h2.cd_situacao = s2.cd_situacao_historico and '
		SET @sql += ' 					   s2.fl_incluir_ans=1 and '
		SET @sql += ' 					   e.CD_Sequencial_historico=h3.cd_sequencial and '
		SET @sql += ' 					   h3.CD_SITUACAO= s3.CD_SITUACAO_HISTORICO and '
		SET @sql += ' 					   s3.fl_incluir_ans=1  and '
		SET @sql += ' 					   e.TP_EMPRESA<10 and '
		SET @sql += ' 					   e.ufid is not null '

		IF @cd_centro_custo > 0
		BEGIN
			SET @sql += ' and e.cd_centro_custo= ' + CONVERT(VARCHAR(5), @cd_centro_custo)
		END

		IF @CD_GRUPOAnalise > 0
		BEGIN
			SET @sql += ' and e.cd_empresa in (select cd_empresa from GrupoAnalise_Empresa where CD_GRUPOAnalise = ' + CONVERT(VARCHAR(10), @CD_GRUPOAnalise) + ')'
		END

		IF @depid > 0
		BEGIN
			SET @sql += ' and e.cd_empresa in (select cd_empresa from Departamento_Empresa where depid = ' + CONVERT(VARCHAR(10), @depid) + ')'
		END

		IF @cd_grupo > 0
		BEGIN
			SET @sql += ' and e.cd_grupo = ' + CONVERT(VARCHAR(10), @cd_grupo) + ''
		END

		SET @sql += ' group by c.ds_centro_custo ,p.nm_plano  , cans.ds_classificacao '
		SET @sql += ' order by c.ds_centro_custo ,p.nm_plano  '

		PRINT (@sql)

		EXEC (@sql)
			-- if @cd_centro_custo > 0
			--Begin --2.1
			--	Select c.ds_centro_custo , p.nm_plano , cans.ds_classificacao, count(0) as qt_tit, SUM(d1.vl_plano) as vl_plano
			--	from associados as a , 
			--		 dependentes as d1, historico as h1, situacao_historico as s1, -- Usuario 
			--		 dependentes as d2, historico as h2, situacao_historico as s2, -- Titular
			--		 planos as p , Centro_Custo as c, 
			--		 EMPRESA as e, historico as h3, situacao_historico as s3, -- Empresa
			--		 CLASSIFICACAO_ANS as cans 
			--		 where a.cd_Associado = d1.cd_Associado and -- d1.CD_GRAU_PARENTESCO = 1 and
			--			   a.cd_empresa=e.CD_EMPRESA and 
			--			   e.cd_centro_custo = c.cd_centro_custo and 
			--			   d1.cd_plano= p.cd_plano and 
			--			   d1.cd_sequencial_historico = h1.cd_sequencial and 
			--			   h1.cd_situacao = s1.cd_situacao_historico and 
			--			   s1.fl_incluir_ans=1 and
			--			   p.cd_classificacao *= cans.cd_classificacao and
			--			   d1.CD_ASSOCIADO = d2.cd_associado and 
			--			   d2.CD_GRAU_PARENTESCO = 1 and 
			--			   d2.cd_sequencial_historico = h2.cd_sequencial and 
			--			   h2.cd_situacao = s2.cd_situacao_historico and 
			--			   s2.fl_incluir_ans=1 and 
			--			   e.CD_Sequencial_historico=h3.cd_sequencial and 
			--			   h3.CD_SITUACAO= s3.CD_SITUACAO_HISTORICO and 
			--			   s3.fl_incluir_ans=1  and 
			--			   e.TP_EMPRESA<10 and 
			--			   e.ufid is not null and 
			--			   e.cd_centro_custo=@cd_centro_custo 
			--   group by c.ds_centro_custo ,p.nm_plano  , cans.ds_classificacao
			--   order by c.ds_centro_custo ,p.nm_plano  
			--End --2.1
			--Else
			--Begin --2.2
			--	Select c.ds_centro_custo , p.nm_plano , cans.ds_classificacao, count(0) as qt_tit, SUM(d1.vl_plano) as vl_plano
			--	from associados as a , 
			--		 dependentes as d1, historico as h1, situacao_historico as s1, -- Usuario 
			--		 dependentes as d2, historico as h2, situacao_historico as s2, -- Titular
			--		 planos as p , Centro_Custo as c, 
			--		 EMPRESA as e, historico as h3, situacao_historico as s3, -- Empresa
			--		 CLASSIFICACAO_ANS as cans 
			--		 where a.cd_Associado = d1.cd_Associado and -- d1.CD_GRAU_PARENTESCO = 1 and
			--			   a.cd_empresa=e.CD_EMPRESA and 
			--			   e.cd_centro_custo = c.cd_centro_custo and 
			--			   d1.cd_plano= p.cd_plano and 
			--			   d1.cd_sequencial_historico = h1.cd_sequencial and 
			--			   h1.cd_situacao = s1.cd_situacao_historico and 
			--			   s1.fl_incluir_ans=1 and
			--			   p.cd_classificacao *= cans.cd_classificacao and
			--			   d1.CD_ASSOCIADO = d2.cd_associado and 
			--			   d2.CD_GRAU_PARENTESCO = 1 and 
			--			   d2.cd_sequencial_historico = h2.cd_sequencial and 
			--			   h2.cd_situacao = s2.cd_situacao_historico and 
			--			   s2.fl_incluir_ans=1 and 
			--			   e.CD_Sequencial_historico=h3.cd_sequencial and 
			--			   h3.CD_SITUACAO= s3.CD_SITUACAO_HISTORICO and 
			--			   s3.fl_incluir_ans=1  and 
			--			   e.TP_EMPRESA<10 and 
			--			   e.ufid is not null  
			--   group by c.ds_centro_custo ,p.nm_plano  , cans.ds_classificacao
			--   order by c.ds_centro_custo ,p.nm_plano  
			--End --2.2                
	END --2
END
