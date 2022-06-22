/****** Object:  Procedure [dbo].[PS_DadosVendaComercial]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[PS_DadosVendaComercial] (@DT_Inicial DATETIME,
@DT_Final DATETIME,
@tipo INTEGER = 1,
@equipe INTEGER = -1,
@vendedor INTEGER = -1,
@chefe INTEGER = -1,
@cpfvendedor VARCHAR(11) = '',
@plano VARCHAR(1000) = '',
@tipoEmpresa VARCHAR(1000) = '',
@tipoPagamento VARCHAR(1000) = '',
@grupoEmpresa INTEGER = -1,
@centroCusto INTEGER = -1,
@situacao VARCHAR(1000) = '',
@uf INTEGER = -1,
@municipio INTEGER = -1,
@nm_equipe VARCHAR(1000) = '',
@adesionista INTEGER = -1,
@tipoRecebimento VARCHAR(1000) = '')
AS
BEGIN

	/**************************************************************
	i4871 - Lara a licença UHD68FDSSHDS87622ASBVQ71619A87287776SDS0KJUY66001 os vendedores não são exclusivos da equipe.
	a limitação do vendedor na equipe foi removida 
	***************************************************************/

	UPDATE FUNCIONARIO
	SET cd_equipe = 0
	WHERE cd_equipe IS NULL
	AND cd_funcionario IN (SELECT DISTINCT
			cd_funcionario_vendedor
		FROM DEPENDENTES
		WHERE cd_funcionario_vendedor IS NOT NULL);


	DECLARE @LicensaS4E VARCHAR(50);

	SELECT TOP 1
		@LicensaS4E = LicencaS4E
	FROM Configuracao;

	DECLARE @SQL VARCHAR(MAX);
	DECLARE @ConfigBusca TINYINT;

	SELECT TOP 1
		@ConfigBusca = tipo_DataVendaContrato
	FROM Configuracao;

	SET @SQL = '';

	IF @LicensaS4E = 'UHD68FDSSHDS87622ASBVQ71619A87287776SDS0KJUY66001'
		OR @LicensaS4E = 'U87DJHJ767DFJJHJDFD8676FDJHJSSAQEHBV86265698JJ005'
	BEGIN
		IF @tipo = 1
		BEGIN
			SET @SQL = @SQL + ' Select t1.NM_Equipe,t1.cd_equipe, ';
			--Quantidade de contratos
			SET @SQL = @SQL + ' (Select Count(T100.cd_sequencial_lote) ';
			SET @SQL
			= @SQL
			+ ' From lote_contratos_contratos_vendedor T100, Dependentes T200 , Funcionario T300, 
			associados t400, empresa t500, UF AS uf, municipio AS mu, lote_contratos LC, Equipe_Vendas t900 ';
			--SET @SQL = @SQL + '
			--Where T100.cd_sequencial_dep = T200.cd_sequencial And 
			--		T200.cd_funcionario_vendedor = T300.cd_funcionario And 
			--		T100.cd_sequencial_lote = LC.cd_sequencial And
			--		T300.cd_equipe = T900.cd_equipe And
			--		t200.cd_associado = t400.cd_associado And 
			--		t400.cd_empresa = t500.cd_empresa And 
			--		'



			SET @SQL
			= @SQL
			+ ' 
			
			SELECT * FROM dbo.lote_contratos_contratos_vendedor T100
			INNER JOIN dbo.DEPENDENTES T200 ON T100.cd_sequencial_dep = T200.CD_SEQUENCIAL
			INNER JOIN dbo.FUNCIONARIO T300 ON T200.cd_funcionario_vendedor = T300.cd_funcionario
			INNER JOIN dbo.lote_contratos lc ON T100.cd_sequencial_lote = lc.cd_sequencial 
			INNER JOIN dbo.ASSOCIADOS T400 ON T200.CD_ASSOCIADO = T400.cd_associado';



			IF (@uf <> -1)
			BEGIN
				SET @SQL = @SQL + ' INNER JOIN dbo.UF ON T400.ufId = dbo.UF.ufId ';
				SET @SQL = @SQL + ' dbo.UF.ufId = ' + CONVERT(VARCHAR, @uf) + ' And ';
			END;
			ELSE
			BEGIN
				SET @SQL = @SQL + ' LEFT JOIN dbo.UF ON T400.ufId = dbo.UF.ufId ';
			END;

			IF (@municipio <> -1)
			BEGIN
				SET @SQL = @SQL + ' INNER JOIN dbo.MUNICIPIO mu ON T400.CidID = mu.CD_MUNICIPIO And ';
				SET @SQL = @SQL + ' mu.cd_municipio = ' + CONVERT(VARCHAR, @municipio) + ' And ';
			END;
			ELSE
			BEGIN
				SET @SQL = @SQL + ' LEFT JOIN dbo.MUNICIPIO mu ON T400.Naturalidade = mu.CD_MUNICIPIO And ';
			END;



			IF (@nm_equipe <> '')
			BEGIN
				SET @SQL = @SQL + ' INNER JOIN dbo.equipe_vendas T900 ON T300.cd_equipe = T900.cd_equipe ';
				SET @SQL = @SQL + ' And t900.nm_equipe like ''' + @nm_equipe + ''' ';

			END;
			ELSE
			BEGIN
				SET @SQL = @SQL + ' LEFT JOIN dbo.equipe_vendas T900 ON T300.cd_equipe = T900.cd_equipe ';
			END;


			/*COMENTADOS FORAM REALIZADOS OS JOINS - SUBIRAM PARA OS JOINS PARA MELHORAR A QUERY*/



			--IF (@uf <> - 1)
			--BEGIN
			--	SET @SQL = @SQL + ' t400.ufid = uf.ufid And '
			--	SET @SQL = @SQL + ' uf.ufid = ' + convert(VARCHAR, @uf) + ' And '
			--END
			--ELSE
			--BEGIN
			--	SET @SQL = @SQL + ' t400.ufid *= uf.ufid And '
			--END

			--IF (@municipio <> - 1)
			--BEGIN
			--	SET @SQL = @SQL + ' t400.cidid = mu.cd_municipio And '
			--	SET @SQL = @SQL + ' mu.cd_municipio = ' + convert(VARCHAR, @municipio) + ' And '
			--END
			--ELSE
			--BEGIN
			--	SET @SQL = @SQL + ' t400.cidid *= mu.cd_municipio And '
			--END


			SET @SQL = @SQL + ' where ';


			IF (@ConfigBusca = 1)
			BEGIN
				SET @SQL
				= @SQL + ' T100.dt_cadastro between ''' + CONVERT(VARCHAR(10), @DT_Inicial, 101) + ''' And '''
				+ CONVERT(VARCHAR(10), @DT_Final, 101) + ' 23:59''';
			END;
			ELSE
			BEGIN
				SET @SQL
				= @SQL + ' T100.dt_assinaturaContrato between ''' + CONVERT(VARCHAR(10), @DT_Inicial, 101)
				+ ''' And ''' + CONVERT(VARCHAR(10), @DT_Final, 101) + ' 23:59''';
			END;

			IF (@cpfvendedor <> '')
			BEGIN
				SET @SQL = @SQL + ' And T300.nr_cpf = ''' + @cpfvendedor + '''';
			END;

			IF (@equipe > 0)
			BEGIN
				SET @SQL = @SQL + ' And T300.cd_equipe = ' + CONVERT(VARCHAR, @equipe);
			END;

			IF (@vendedor > 0)
			BEGIN
				SET @SQL = @SQL + ' And T300.cd_funcionario = ' + CONVERT(VARCHAR, @vendedor);
			END;

			IF (@chefe > 0)
			BEGIN
				SET @SQL
				= @SQL + ' and T300.cd_equipe in (select eq.cd_equipe from equipe_vendas eq where eq.cd_chefe = '
				+ CONVERT(VARCHAR, @chefe) + ' or cd_chefe1 = ' + CONVERT(VARCHAR, @chefe) + ' or cd_chefe2 = '
				+ CONVERT(VARCHAR, @chefe) + ')';
			END;

			IF (@plano <> '')
			BEGIN
				SET @SQL = @SQL + ' and T200.cd_plano in (' + @plano + ')';
			END;

			IF (@tipoEmpresa <> '')
			BEGIN
				SET @SQL = @SQL + ' and T500.tp_empresa in (' + @tipoEmpresa + ')';
			END;

			IF (@tipoPagamento <> '')
			BEGIN
				SET @SQL = @SQL + ' and T500.cd_tipo_pagamento in (' + @tipoPagamento + ')';
			END;

			--##TIPORECEBIMENTO##
			IF (@tipoRecebimento <> '')
			BEGIN
				SET @SQL
				= @SQL
				+ 'and (select count(0)                                 
								from mensalidades_planos t1000,                     
									 mensalidades t2000                             
								where t1000.cd_sequencial_dep = T100.cd_sequencial_dep 
								and t2000.cd_parcela = t1000.cd_parcela_mensalidade 
								and t2000.cd_tipo_recebimento in(' + @tipoRecebimento + ') 
								) > 0 ';
			END;

			IF (@grupoEmpresa > 0)
			BEGIN
				SET @SQL = @SQL + ' and T500.cd_grupo = ' + CONVERT(VARCHAR, @grupoEmpresa);
			END;

			IF (@centroCusto > 0)
			BEGIN
				SET @SQL = @SQL + ' and T500.cd_centro_custo = ' + CONVERT(VARCHAR, @centroCusto);
			END;

			IF (@situacao <> '')
			BEGIN
				SET @SQL
				= @SQL
				+ ' and (select top 1 cd_situacao from historico where cd_sequencial_dep = T200.cd_sequencial order by convert(date,dt_situacao) desc, cd_sequencial desc) in ('
				+ @situacao + ')';
			END;
			/*COMENTADOS FORAM REALIZADOS OS JOINS - BLOCO LEVADO PARA O JOIN*/
			--IF (@nm_equipe <> '')
			--BEGIN
			--	SET @SQL = @SQL + ' And t900.nm_equipe like ''' + @nm_equipe + ''' '
			--	SET @SQL = @SQL + ' And t300.cd_equipe = t900.cd_equipe '
			--END
			--ELSE
			--BEGIN
			--	SET @SQL = @SQL + ' And t300.cd_equipe *= t900.cd_equipe '
			--END

			IF (@adesionista > 0)
			BEGIN
				SET @SQL = @SQL + ' AND T200.cd_funcionario_adesionista = ' + CONVERT(VARCHAR, @adesionista);
			END;

			SET @SQL = @SQL + ' ) As QuantidadeContrato, ';


			--Soma dos contratos
			SET @SQL = @SQL + ' IsNull((Select Sum(T100.vl_contrato) ';
			--SET @SQL = @SQL + ' From lote_contratos_contratos_vendedor T100, Dependentes T200 , 
			--Funcionario T300, associados t400, empresa t500, UF AS uf, municipio AS mu, lote_contratos LC, Equipe_Vendas t900 '
			--SET @SQL = @SQL + ' 		
			--Where T100.cd_sequencial_dep = T200.cd_sequencial And 
			--		T200.cd_funcionario_vendedor = T300.cd_funcionario And 
			--		T100.cd_sequencial_lote = LC.cd_sequencial And
			--		T300.cd_equipe = T1.cd_equipe And 
			--		t200.cd_associado = t400.cd_associado And 
			--		t400.cd_empresa = t500.cd_empresa And 
			--		'
			SET @SQL
			= @SQL
			+ ' FROM dbo.lote_contratos_contratos_vendedor T100 
			INNER JOIN dbo.DEPENDENTES T200 ON T100.cd_sequencial_dep = T200.CD_SEQUENCIAL
			INNER JOIN dbo.FUNCIONARIO T300 ON T200.cd_funcionario_vendedor = T300.cd_funcionario
			AND T300.cd_equipe = T1.cd_equipe
			INNER JOIN dbo.lote_contratos lc ON T100.cd_sequencial_lote = lc.cd_sequencial
			INNER JOIN dbo.ASSOCIADOS T400 ON T200.CD_ASSOCIADO = T400.cd_associado
			INNER JOIN dbo.EMPRESA T500 ON T400.cd_empresa = T500.CD_EMPRESA';


			IF (@uf <> -1)
			BEGIN
				SET @SQL = @SQL + ' INNER JOIN dbo.UF ON T400.ufId = dbo.UF.ufId and ';
				SET @SQL = @SQL + ' uf.ufid = ' + CONVERT(VARCHAR, @uf) + ' And ';
			END;
			ELSE
			BEGIN
				SET @SQL = @SQL + ' LEFT JOIN dbo.UF ON T400.ufId = dbo.UF.ufId ';
			END;

			IF (@municipio <> -1)
			BEGIN
				SET @SQL = @SQL + ' INNER JOIN dbo.MUNICIPIO mu ON T400.CidID = mu.CD_MUNICIPIO and ';
				SET @SQL = @SQL + ' mu.cd_municipio = ' + CONVERT(VARCHAR, @municipio) + ' And ';
			END;
			ELSE
			BEGIN
				SET @SQL = @SQL + ' LEFT JOIN dbo.MUNICIPIO mu ON T400.CidID = mu.CD_MUNICIPIO ';
			END;

			IF (@nm_equipe <> '')
			BEGIN
				SET @SQL = @SQL + ' INNER JOIN dbo.equipe_vendas t900 ON t300.cd_equipe = t900.cd_equipe ';
				SET @SQL = @SQL + ' And t900.nm_equipe like''' + @nm_equipe + ''' ';

			END;
			ELSE
			BEGIN
				SET @SQL = @SQL + ' LEFT JOIN dbo.equipe_vendas t900 ON t300.cd_equipe = t900.cd_equipe ';
			END;


			--IF (@uf <> - 1)
			--BEGIN
			--	SET @SQL = @SQL + ' t400.ufid = uf.ufid and '
			--	SET @SQL = @SQL + ' uf.ufid = ' + convert(VARCHAR, @uf) + ' And '
			--END
			--ELSE
			--BEGIN
			--	SET @SQL = @SQL + ' t400.ufid *= uf.ufid and '
			--END

			--IF (@municipio <> - 1)
			--BEGIN
			--	SET @SQL = @SQL + ' t400.cidid = mu.cd_municipio and '
			--	SET @SQL = @SQL + ' mu.cd_municipio = ' + convert(VARCHAR, @municipio) + ' And '
			--END
			--ELSE
			--BEGIN
			--	SET @SQL = @SQL + ' t400.cidid *= mu.cd_municipio and '
			--END


			SET @SQL = @SQL + ' where ';


			IF (@ConfigBusca = 1)
			BEGIN
				SET @SQL
				= @SQL + ' T100.dt_cadastro between ''' + CONVERT(VARCHAR(10), @DT_Inicial, 101) + ''' And '''
				+ CONVERT(VARCHAR(10), @DT_Final, 101) + ' 23:59''';
			END;
			ELSE
			BEGIN
				SET @SQL
				= @SQL + ' T100.dt_assinaturaContrato between ''' + CONVERT(VARCHAR(10), @DT_Inicial, 101)
				+ ''' And ''' + CONVERT(VARCHAR(10), @DT_Final, 101) + ' 23:59''';
			END;

			IF (@cpfvendedor <> '')
			BEGIN
				SET @SQL = @SQL + ' And T300.nr_cpf = ''' + @cpfvendedor + '''';
			END;

			IF (@equipe > 0)
			BEGIN
				SET @SQL = @SQL + ' And T300.cd_equipe = ' + CONVERT(VARCHAR, @equipe);
			END;

			IF (@vendedor > 0)
			BEGIN
				SET @SQL = @SQL + ' And T300.cd_funcionario = ' + CONVERT(VARCHAR, @vendedor);
			END;

			IF (@chefe > 0)
			BEGIN
				SET @SQL
				= @SQL + ' and T300.cd_equipe in (select eq.cd_equipe from equipe_vendas eq where eq.cd_chefe = '
				+ CONVERT(VARCHAR, @chefe) + ' or cd_chefe1 = ' + CONVERT(VARCHAR, @chefe) + ' or cd_chefe2 = '
				+ CONVERT(VARCHAR, @chefe) + ')';
			END;

			IF (@plano <> '')
			BEGIN
				SET @SQL = @SQL + ' and T200.cd_plano in (' + @plano + ')';
			END;

			IF (@tipoEmpresa <> '')
			BEGIN
				SET @SQL = @SQL + ' and T500.tp_empresa in (' + @tipoEmpresa + ')';
			END;

			IF (@tipoPagamento <> '')
			BEGIN
				SET @SQL = @SQL + ' and T500.cd_tipo_pagamento in (' + @tipoPagamento + ')';
			END;

			--##TIPORECEBIMENTO##
			IF (@tipoRecebimento <> '')
			BEGIN
				SET @SQL
				= @SQL
				+ 'and (select count(0)                                 
 								from mensalidades_planos t1000,                     
 									 mensalidades t2000                             
 								where t1000.cd_sequencial_dep = T100.cd_sequencial_dep 
 								and t2000.cd_parcela = t1000.cd_parcela_mensalidade 
 								and t2000.cd_tipo_recebimento in(' + @tipoRecebimento + ') 
 								) > 0 ';
			END;

			IF (@grupoEmpresa > 0)
			BEGIN
				SET @SQL = @SQL + ' and T500.cd_grupo = ' + CONVERT(VARCHAR, @grupoEmpresa);
			END;

			IF (@centroCusto > 0)
			BEGIN
				SET @SQL = @SQL + ' and T500.cd_centro_custo = ' + CONVERT(VARCHAR, @centroCusto);
			END;

			IF (@situacao <> '')
			BEGIN
				SET @SQL
				= @SQL
				+ ' and (select top 1 cd_situacao from historico where cd_sequencial_dep = T200.cd_sequencial order by convert(date,dt_situacao) desc, cd_sequencial desc) in ('
				+ @situacao + ')';
			END;

			--IF (@nm_equipe <> '')
			--BEGIN
			--	SET @SQL = @SQL + ' And t900.nm_equipe like''' + @nm_equipe + ''' '
			--	SET @SQL = @SQL + ' And t300.cd_equipe = t900.cd_equipe '
			--END
			--ELSE
			--BEGIN
			--	SET @SQL = @SQL + ' And t300.cd_equipe *= t900.cd_equipe '
			--END

			IF (@adesionista > 0)
			BEGIN
				SET @SQL = @SQL + ' AND T200.cd_funcionario_adesionista = ' + CONVERT(VARCHAR, @adesionista);
			END;

			SET @SQL = @SQL + ' ),0) ';
			SET @SQL = @SQL + ' As ValorContrato, ';


			--Quantidade de vidas dos contratos importados. Associados com situação igual a 6


			--SET @SQL = @SQL + ' IsNull((Select Count(T100.cd_sequencial) '
			--SET @SQL = @SQL + ' From Dependentes T100, Funcionario T200, Historico T300, associados t400, 
			--empresa t500, UF AS uf, municipio AS mu, lote_contratos_contratos_vendedor cv, lote_contratos LC, Equipe_Vendas ev '
			--SET @SQL = @SQL + ' Where T100.cd_funcionario_vendedor = T200.cd_funcionario '
			--SET @SQL = @SQL + ' And T200.cd_equipe = T1.cd_equipe '
			--SET @SQL = @SQL + ' And t100.CD_Sequencial_historico = t300.cd_sequencial '
			--SET @SQL = @SQL + ' And t100.cd_associado = t400.cd_associado '
			--SET @SQL = @SQL + ' And t400.cd_empresa = t500.cd_empresa '
			--SET @SQL = @SQL + ' And T300.DT_SITUACAO between ''' + CONVERT(VARCHAR(10), @DT_Inicial, 101) + 
			--''' And ''' + CONVERT(VARCHAR(10), @DT_Final, 101) + ' 23:59'''
			--SET @SQL = @SQL + ' And T300.cd_situacao = 6 '
			--SET @SQL = @SQL + ' And T100.cd_sequencial = cv.cd_sequencial_dep '
			--SET @SQL = @SQL + ' And cv.cd_sequencial_lote = LC.cd_sequencial '
			--SET @SQL = @SQL + ' And T200.cd_equipe end = T1.cd_equipe '

			SET @SQL
			= @SQL
			+ '
			FROM dbo.DEPENDENTES t100 INNER JOIN dbo.FUNCIONARIO t200
			ON t100.cd_funcionario_vendedor = t200.cd_funcionario
			AND t200.cd_equipe = t1.cd_equipe
			INNER JOIN dbo.HISTORICO t300 ON t100.CD_Sequencial_historico = t300.cd_sequencial
			INNER JOIN dbo.ASSOCIADOS t400 ON t100.CD_ASSOCIADO = t400.cd_associado
			INNER JOIN dbo.EMPRESA t500 ON t400.cd_empresa = t500.CD_EMPRESA
			INNER JOIN dbo.lote_contratos_contratos_vendedor cv ON t100.CD_SEQUENCIAL = cv.cd_sequencial_dep
			INNER JOIN dbo.lote_contratos lc ON cv.cd_sequencial_lote = lc.cd_sequencial';




			IF (@uf <> -1)
			BEGIN
				SET @SQL = @SQL + ' INNER JOIN dbo.UF ON t400.ufId = dbo.UF.ufId ';
				SET @SQL = @SQL + ' And uf.ufid = ' + CONVERT(VARCHAR, @uf);
			END;
			ELSE
			BEGIN
				SET @SQL = @SQL + ' left JOIN dbo.UF ON t400.ufId = dbo.UF.ufId ';
			END;
			/*COMENTADOS FORAM REALIZADOS OS JOINS*/


			--IF (@uf <> -1)
			--BEGIN
			--	SET @SQL = @SQL + ' And t400.ufid = uf.ufid '
			--	SET @SQL = @SQL + ' And uf.ufid = ' + CONVERT(VARCHAR, @uf)
			--END
			--ELSE
			--BEGIN
			--	SET @SQL = @SQL + ' And t400.ufid *= uf.ufid '
			--END

			IF (@municipio <> -1)
			BEGIN
				SET @SQL = @SQL + ' INNER JOIN dbo.MUNICIPIO mu ON t400.CidID = mu.CD_MUNICIPIO ';
				SET @SQL = @SQL + ' And mu.cd_municipio = ' + CONVERT(VARCHAR, @municipio);
			END;
			ELSE
			BEGIN
				SET @SQL = @SQL + ' left JOIN dbo.MUNICIPIO mu ON t400.CidID = mu.CD_MUNICIPIO ';
			END;

			--IF (@municipio <> - 1)			
			--	BEGIN
			--		SET @SQL = @SQL + ' And t400.cidid = mu.cd_municipio '
			--		SET @SQL = @SQL + ' And mu.cd_municipio = ' + CONVERT(VARCHAR, @municipio)
			--	END
			--				ELSE
			--	BEGIN
			--		SET @SQL = @SQL + ' And t400.cidid *= mu.cd_municipio '
			--	END



			IF (@nm_equipe <> '')
			BEGIN
				SET @SQL = @SQL + ' INNER JOIN dbo.equipe_vendas ev ON t200.cd_equipe = ev.cd_equipe ';
				SET @SQL = @SQL + ' And ev.nm_equipe like ''' + @nm_equipe + ''' ';

			END;
			ELSE
			BEGIN
				SET @SQL = @SQL + ' left JOIN dbo.equipe_vendas ev ON t200.cd_equipe = ev.cd_equipe ';
			END;

			SET @SQL = @SQL + ' where ';

			SET @SQL
			= @SQL + ' And T300.DT_SITUACAO between ''' + CONVERT(VARCHAR(10), @DT_Inicial, 101) + ''' And '''
			+ CONVERT(VARCHAR(10), @DT_Final, 101) + ' 23:59''';
			SET @SQL = @SQL + ' And T300.cd_situacao = 6 ';

			IF (@cpfvendedor <> '')
			BEGIN
				SET @SQL = @SQL + ' And T200.nr_cpf = ''' + @cpfvendedor + '''';
			END;

			IF (@equipe > 0)
			BEGIN
				SET @SQL = @SQL + ' And T200.cd_equipe = ' + CONVERT(VARCHAR, @equipe);
			END;

			IF (@vendedor > 0)
			BEGIN
				SET @SQL = @SQL + ' And T200.cd_funcionario = ' + CONVERT(VARCHAR, @vendedor);
			END;

			IF (@plano <> '')
			BEGIN
				SET @SQL = @SQL + ' and T100.cd_plano in (' + @plano + ')';
			END;

			IF (@tipoEmpresa <> '')
			BEGIN
				SET @SQL = @SQL + ' and T500.tp_empresa in (' + @tipoEmpresa + ')';
			END;

			IF (@tipoPagamento <> '')
			BEGIN
				SET @SQL = @SQL + ' and T500.cd_tipo_pagamento in (' + @tipoPagamento + ')';
			END;

			--##TIPORECEBIMENTO##
			IF (@tipoRecebimento <> '')
			BEGIN
				SET @SQL
				= @SQL
				+ 'and (select count(0)                                 
 								from mensalidades_planos t1000,                     
 									 mensalidades t2000                             
 								where t1000.cd_sequencial_dep = cv.cd_sequencial_dep 
 								and t2000.cd_parcela = t1000.cd_parcela_mensalidade 
 								and t2000.cd_tipo_recebimento in(' + @tipoRecebimento + ') 
 								) > 0 ';
			END;

			IF (@grupoEmpresa > 0)
			BEGIN
				SET @SQL = @SQL + ' and T500.cd_grupo = ' + CONVERT(VARCHAR, @grupoEmpresa);
			END;

			IF (@centroCusto > 0)
			BEGIN
				SET @SQL = @SQL + ' and T500.cd_centro_custo = ' + CONVERT(VARCHAR, @centroCusto);
			END;

			IF (@situacao <> '')
			BEGIN
				SET @SQL
				= @SQL
				+ ' and (select top 1 cd_situacao from historico where cd_sequencial_dep = T100.cd_sequencial order by convert(date,dt_situacao) desc, cd_sequencial desc) in ('
				+ @situacao + ')';
			END;

			/*COMENTADOS FORAM REALIZADOS OS JOINS*/
			--IF (@nm_equipe <> '')
			--BEGIN
			--	SET @SQL = @SQL + ' And T200.cd_equipe = ev.cd_equipe '
			--	SET @SQL = @SQL + ' And ev.nm_equipe like ''' + @nm_equipe + ''' '

			--END
			--ELSE
			--BEGIN
			--	SET @SQL = @SQL + ' And T200.cd_equipe *= ev.cd_equipe '
			--END

			IF (@adesionista > 0)
			BEGIN
				SET @SQL = @SQL + ' AND T100.cd_funcionario_adesionista = ' + CONVERT(VARCHAR, @adesionista);
			END;

			SET @SQL = @SQL + ' ),0) ';
			SET @SQL = @SQL + ' As QuantidadeImportado, ';

			--Soma de vidas dos contratos importados. Associados com situação igual a 6


			SET @SQL = @SQL + ' IsNull((Select Sum(T100.vl_plano) ';
			SET @SQL
			= @SQL
			+ ' From Dependentes T100, Funcionario T200, Historico T300, associados t400, 
				  empresa t500, UF AS uf, municipio AS mu, lote_contratos_contratos_vendedor cv, 
				  lote_contratos LC, Equipe_Vendas ev ';
			SET @SQL = @SQL + ' Where T100.cd_funcionario_vendedor = T200.cd_funcionario ';
			SET @SQL = @SQL + ' And T200.cd_equipe = T1.cd_equipe ';
			SET @SQL = @SQL + ' And t100.CD_Sequencial_historico = t300.cd_sequencial ';
			SET @SQL = @SQL + ' And t100.cd_associado = t400.cd_associado ';
			SET @SQL = @SQL + ' And t400.cd_empresa = t500.cd_empresa ';
			SET @SQL
			= @SQL + ' And T300.DT_SITUACAO between ''' + CONVERT(VARCHAR(10), @DT_Inicial, 101) + ''' And '''
			+ CONVERT(VARCHAR(10), @DT_Final, 101) + ' 23:59''';
			SET @SQL = @SQL + ' And T300.cd_situacao = 6 ';
			SET @SQL = @SQL + ' And T100.cd_sequencial = cv.cd_sequencial_dep ';
			SET @SQL = @SQL + ' And cv.cd_sequencial_lote = LC.cd_sequencial ';
			SET @SQL = @SQL + ' And T200.cd_equipe = T1.cd_equipe ';

			IF (@uf <> -1)
			BEGIN
				SET @SQL = @SQL + ' And t400.ufid = uf.ufid ';
				SET @SQL = @SQL + ' And uf.ufid = ' + CONVERT(VARCHAR, @uf);
			END;
			ELSE
			BEGIN
				SET @SQL = @SQL + ' And t400.ufid *= uf.ufid ';
			END;

			IF (@municipio <> -1)
			BEGIN
				SET @SQL = @SQL + ' And t400.cidid = mu.cd_municipio ';
				SET @SQL = @SQL + ' And mu.cd_municipio = ' + CONVERT(VARCHAR, @municipio);
			END;
			ELSE
			BEGIN
				SET @SQL = @SQL + ' And t400.cidid *= mu.cd_municipio ';
			END;

			IF (@cpfvendedor <> '')
			BEGIN
				SET @SQL = @SQL + ' And T200.nr_cpf = ''' + @cpfvendedor + '''';
			END;

			IF (@equipe > 0)
			BEGIN
				SET @SQL = @SQL + ' And T200.cd_equipe = ' + CONVERT(VARCHAR, @equipe);
			END;

			IF (@vendedor > 0)
			BEGIN
				SET @SQL = @SQL + ' And T200.cd_funcionario = ' + CONVERT(VARCHAR, @vendedor);
			END;

			IF (@plano <> '')
			BEGIN
				SET @SQL = @SQL + ' and T100.cd_plano in (' + @plano + ')';
			END;

			IF (@tipoEmpresa <> '')
			BEGIN
				SET @SQL = @SQL + ' and T500.tp_empresa in (' + @tipoEmpresa + ')';
			END;

			IF (@tipoPagamento <> '')
			BEGIN
				SET @SQL = @SQL + ' and T500.cd_tipo_pagamento in (' + @tipoPagamento + ')';
			END;

			--##TIPORECEBIMENTO##
			IF (@tipoRecebimento <> '')
			BEGIN
				SET @SQL
				= @SQL
				+ 'and (select count(0)                                 
 								from mensalidades_planos t1000,                     
 									 mensalidades t2000                             
 								where t1000.cd_sequencial_dep = cv.cd_sequencial_dep 
 								and t2000.cd_parcela = t1000.cd_parcela_mensalidade 
 								and t2000.cd_tipo_recebimento in(' + @tipoRecebimento + ') 
 								) > 0 ';
			END;

			IF (@grupoEmpresa > 0)
			BEGIN
				SET @SQL = @SQL + ' and T500.cd_grupo = ' + CONVERT(VARCHAR, @grupoEmpresa);
			END;

			IF (@centroCusto > 0)
			BEGIN
				SET @SQL = @SQL + ' and T500.cd_centro_custo = ' + CONVERT(VARCHAR, @centroCusto);
			END;

			IF (@situacao <> '')
			BEGIN
				SET @SQL
				= @SQL
				+ ' and (select top 1 cd_situacao from historico where cd_sequencial_dep = T100.cd_sequencial order by convert(date,dt_situacao) desc, cd_sequencial desc) in ('
				+ @situacao + ')';
			END;

			IF (@nm_equipe <> '')
			BEGIN
				SET @SQL = @SQL + ' And ev.nm_equipe like ''' + @nm_equipe + ''' ';
				SET @SQL = @SQL + ' And t200.cd_equipe = ev.cd_equipe ';
			END;
			ELSE
			BEGIN
				SET @SQL = @SQL + ' And t200.cd_equipe *= ev.cd_equipe ';
			END;

			IF (@adesionista > 0)
			BEGIN
				SET @SQL = @SQL + ' AND T100.cd_funcionario_adesionista = ' + CONVERT(VARCHAR, @adesionista);
			END;

			SET @SQL = @SQL + ' ),0) ';
			SET @SQL = @SQL + ' As ValorImportado, ';

			--Quantidade de vidas dos contratos cancelados
			SET @SQL = @SQL + ' IsNull((Select Count(T100.cd_sequencial) ';
			SET @SQL
			= @SQL
			+ ' From Dependentes T100, Funcionario T200, Historico T300 , ASSOCIADOS t400, empresa t500, UF AS uf, municipio AS mu '; --, lote_contratos_contratos_vendedor cv, lote_contratos LC, Equipe_Vendas ev '
			SET @SQL = @SQL + ' Where T100.cd_funcionario_vendedor = T200.cd_funcionario ';
			SET @SQL = @SQL + ' And T200.cd_equipe = T1.cd_equipe ';
			SET @SQL = @SQL + ' And t100.CD_Sequencial_historico = t300.cd_sequencial ';
			SET @SQL
			= @SQL + ' And T300.DT_SITUACAO between ''' + CONVERT(VARCHAR(10), @DT_Inicial, 101) + ''' And '''
			+ CONVERT(VARCHAR(10), @DT_Final, 101) + ' 23:59''';
			SET @SQL = @SQL + ' And T100.CD_ASSOCIADO = t400.cd_associado ';
			SET @SQL = @SQL + ' And t400.cd_empresa = t500.CD_EMPRESA ';
			SET @SQL = @SQL + ' And t500.TP_EMPRESA<10 ';
			SET @SQL = @SQL + ' And T300.cd_situacao in (2) ';
			SET @SQL = @SQL + ' and t200.cd_equipe is not null ';

			--set @SQL = @SQL + ' And T100.cd_sequencial = cv.cd_sequencial_dep ' 
			--set @SQL = @SQL + ' And cv.cd_sequencial_lote = LC.cd_sequencial '
			--set @SQL = @SQL + ' And case when LC.cd_empresa is null then isnull(LC.cd_equipe,T200.cd_equipe) else T200.cd_equipe end = T1.cd_equipe '
			IF (@uf <> -1)
			BEGIN
				SET @SQL = @SQL + ' And t400.ufid = uf.ufid ';
				SET @SQL = @SQL + ' And uf.ufid = ' + CONVERT(VARCHAR, @uf);
			END;
			ELSE
			BEGIN
				SET @SQL = @SQL + ' And t400.ufid *= uf.ufid ';
			END;

			IF (@municipio <> -1)
			BEGIN
				SET @SQL = @SQL + ' And t400.cidid = mu.cd_municipio ';
				SET @SQL = @SQL + ' And mu.cd_municipio = ' + CONVERT(VARCHAR, @municipio);
			END;
			ELSE
			BEGIN
				SET @SQL = @SQL + ' And t400.cidid *= mu.cd_municipio ';
			END;

			IF (@cpfvendedor <> '')
			BEGIN
				SET @SQL = @SQL + ' And T200.nr_cpf = ''' + @cpfvendedor + '''';
			END;

			IF (@equipe > 0)
			BEGIN
				SET @SQL = @SQL + ' And T200.cd_equipe = ' + CONVERT(VARCHAR, @equipe);
			END;

			IF (@vendedor > 0)
			BEGIN
				SET @SQL = @SQL + ' And T200.cd_funcionario = ' + CONVERT(VARCHAR, @vendedor);
			END;

			IF (@plano <> '')
			BEGIN
				SET @SQL = @SQL + ' and T100.cd_plano in (' + @plano + ')';
			END;

			IF (@tipoEmpresa <> '')
			BEGIN
				SET @SQL = @SQL + ' and T500.tp_empresa in (' + @tipoEmpresa + ')';
			END;

			IF (@tipoPagamento <> '')
			BEGIN
				SET @SQL = @SQL + ' and T500.cd_tipo_pagamento in (' + @tipoPagamento + ')';
			END;

			--##TIPORECEBIMENTO##
			IF (@tipoRecebimento <> '')
			BEGIN
				SET @SQL
				= @SQL
				+ 'and (select count(0)                                 
 								from mensalidades_planos t1000,                     
 									 mensalidades t2000                             
 								where t1000.cd_sequencial_dep = cv.cd_sequencial_dep 
 								and t2000.cd_parcela = t1000.cd_parcela_mensalidade 
 								and t2000.cd_tipo_recebimento in(' + @tipoRecebimento + ') 
 								) > 0 ';
			END;

			IF (@grupoEmpresa > 0)
			BEGIN
				SET @SQL = @SQL + ' and T500.cd_grupo = ' + CONVERT(VARCHAR, @grupoEmpresa);
			END;

			IF (@centroCusto > 0)
			BEGIN
				SET @SQL = @SQL + ' and T500.cd_centro_custo = ' + CONVERT(VARCHAR, @centroCusto);
			END;

			IF (@situacao <> '')
			BEGIN
				SET @SQL
				= @SQL
				+ ' and (select top 1 cd_situacao from historico where cd_sequencial_dep = T100.cd_sequencial order by convert(date,dt_situacao) desc, cd_sequencial desc) in ('
				+ @situacao + ')';
			END;

			IF (@adesionista > 0)
			BEGIN
				SET @SQL = @SQL + ' AND T100.cd_funcionario_adesionista = ' + CONVERT(VARCHAR, @adesionista);
			END;

			SET @SQL = @SQL + ' ),0) ';
			SET @SQL = @SQL + ' As QuantidadeCancelado, ';
			--Soma de contratos cancelados
			SET @SQL = @SQL + ' IsNull((Select Sum(T100.vl_plano) ';

			/*ESSE BLOCO FOI COMENTADO PARA SER REALIZADO OS JOINS*/
			--SET @SQL
			--    = @SQL
			--      + ' From Dependentes T100, Funcionario T200, Historico T300 , ASSOCIADOS t400, empresa t500, UF AS uf, municipio AS mu '; --, lote_contratos_contratos_vendedor cv, lote_contratos LC, Equipe_Vendas ev '
			--SET @SQL = @SQL + ' Where T100.cd_funcionario_vendedor = T200.cd_funcionario ';
			--SET @SQL = @SQL + ' And T200.cd_equipe = T1.cd_equipe ';
			--SET @SQL
			--    = @SQL + ' And T300.DT_SITUACAO between ''' + CONVERT(VARCHAR(10), @DT_Inicial, 101) + ''' And '''
			--      + CONVERT(VARCHAR(10), @DT_Final, 101) + ' 23:59''';
			--SET @SQL = @SQL + ' And t100.CD_Sequencial_historico = t300.cd_sequencial ';
			--SET @SQL = @SQL + ' and T100.CD_ASSOCIADO = t400.cd_associado ';
			--SET @SQL = @SQL + ' and t400.cd_empresa = t500.CD_EMPRESA ';
			--SET @SQL = @SQL + ' and t500.TP_EMPRESA<10 ';
			--SET @SQL = @SQL + ' And T300.cd_situacao in (2) ';
			--SET @SQL = @SQL + ' and t200.cd_equipe is not null ';



			SET @SQL
			= @SQL
			+ ' 
			FROM dbo.Dependentes T100 
			INNER JOIN dbo.Funcionario T200 ON t100.cd_funcionario_vendedor = t200.cd_funcionario
								AND t200.cd_equipe = t1.cd_equipe AND t200.cd_equipe IS NOT NULL
			INNER JOIN dbo.Associados T400 ON T100.CD_ASSOCIADO = T400.cd_associado
			INNER JOIN dbo.Empresa T500 ON t400.cd_empresa = t500.CD_EMPRESA AND t500.TP_EMPRESA <10
			INNER JOIN dbo.Historico T300 ON t100.CD_Sequencial_historico= t300.cd_sequencial AND t300.CD_SITUACAO IN (2)';



			IF (@uf <> -1)
			BEGIN
				SET @SQL = @SQL + ' INNER JOIN dbo.UF ON T400.ufId = dbo.UF.ufId ';
				SET @SQL = @SQL + ' And uf.ufid = ' + CONVERT(VARCHAR, @uf);
			END;
			ELSE
			BEGIN
				SET @SQL = @SQL + ' LEFT JOIN dbo.UF ON T400.ufId = dbo.UF.ufId ';
			END;

			IF (@municipio <> -1)
			BEGIN
				SET @SQL = @SQL + ' INNER JOIN dbo.Municipio mu ON T400.CidID = mu.CD_MUNICIPIO ';
				SET @SQL = @SQL + ' And mu.cd_municipio = ' + CONVERT(VARCHAR, @municipio);
			END;
			ELSE
			BEGIN
				SET @SQL = @SQL + ' LEFT JOIN dbo.MUNICIPIO mu ON T400.CidID = mu.CD_MUNICIPIO ';
			END;

			/*COMENTADOS FORAM REALIZADOS OS JOINS*/
			--IF (@uf <> -1)
			--BEGIN
			--    SET @SQL = @SQL + ' And t400.ufid = uf.ufid ';
			--    SET @SQL = @SQL + ' And uf.ufid = ' + CONVERT(VARCHAR, @uf);
			--END;
			--ELSE
			--BEGIN
			--    SET @SQL = @SQL + ' And t400.ufid *= uf.ufid ';
			--END;

			--IF (@municipio <> -1)
			--BEGIN
			--    SET @SQL = @SQL + ' And t400.cidid = mu.cd_municipio ';
			--    SET @SQL = @SQL + ' And mu.cd_municipio = ' + CONVERT(VARCHAR, @municipio);
			--END;
			--ELSE
			--BEGIN
			--    SET @SQL = @SQL + ' And t400.cidid *= mu.cd_municipio ';
			--END;


			SET @SQL = @SQL + ' where ';


			IF (@cpfvendedor <> '')
			BEGIN
				SET @SQL = @SQL + ' T200.nr_cpf = ''' + @cpfvendedor + '''';
			END;
			/*ESSE BLOCO FOI COMENTADO POR CONTA DO AND NO INICIO DA QUERY QUE FOI RETIRADO*/
			--IF (@cpfvendedor <> '')
			--BEGIN
			--    SET @SQL = @SQL + ' And T200.nr_cpf = ''' + @cpfvendedor + '''';
			--END;

			IF (@equipe > 0)
			BEGIN
				SET @SQL = @SQL + ' And T200.cd_equipe = ' + CONVERT(VARCHAR, @equipe);
			END;

			IF (@vendedor > 0)
			BEGIN
				SET @SQL = @SQL + ' And T200.cd_funcionario = ' + CONVERT(VARCHAR, @vendedor);
			END;

			IF (@plano <> '')
			BEGIN
				SET @SQL = @SQL + ' and T100.cd_plano in (' + @plano + ')';
			END;

			IF (@tipoEmpresa <> '')
			BEGIN
				SET @SQL = @SQL + ' and T500.tp_empresa in (' + @tipoEmpresa + ')';
			END;

			IF (@tipoPagamento <> '')
			BEGIN
				SET @SQL = @SQL + ' and T500.cd_tipo_pagamento in (' + @tipoPagamento + ')';
			END;

			--##TIPORECEBIMENTO##
			IF (@tipoRecebimento <> '')
			BEGIN
				SET @SQL
				= @SQL
				+ 'and (select count(0)                                 
 								from mensalidades_planos t1000,                     
 									 mensalidades t2000                             
 								where t1000.cd_sequencial_dep = cv.cd_sequencial_dep 
 								and t2000.cd_parcela = t1000.cd_parcela_mensalidade 
 								and t2000.cd_tipo_recebimento in(' + @tipoRecebimento + ') 
 								) > 0 ';
			END;

			IF (@grupoEmpresa > 0)
			BEGIN
				SET @SQL = @SQL + ' and T500.cd_grupo = ' + CONVERT(VARCHAR, @grupoEmpresa);
			END;

			IF (@centroCusto > 0)
			BEGIN
				SET @SQL = @SQL + ' and T500.cd_centro_custo = ' + CONVERT(VARCHAR, @centroCusto);
			END;

			IF (@situacao <> '')
			BEGIN
				SET @SQL
				= @SQL
				+ ' and (select top 1 cd_situacao from historico where cd_sequencial_dep = T100.cd_sequencial order by convert(date,dt_situacao) desc, cd_sequencial desc) in ('
				+ @situacao + ')';
			END;

			IF (@adesionista > 0)
			BEGIN
				SET @SQL = @SQL + ' AND T100.cd_funcionario_adesionista = ' + CONVERT(VARCHAR, @adesionista);
			END;

			SET @SQL = @SQL + ' ),0) ';
			SET @SQL = @SQL + ' As ValorCancelado, ';
			SET @SQL = @SQL + ' (Select Count(distinct T400.cd_associado) ';
			--       SET @SQL
			--           = @SQL
			--             + ' From lote_contratos_contratos_vendedor T100, Dependentes T200 , 
			-- Funcionario T300, associados t400, empresa t500 , UF AS uf, municipio AS mu, 
			-- lote_contratos LC, Equipe_Vendas t900 ';
			--       SET @SQL
			--           = @SQL
			--             + ' 
			--Where T100.cd_sequencial_dep = T200.cd_sequencial And 
			--T200.cd_funcionario_vendedor = T300.cd_funcionario And 
			--t200.cd_associado = t400.cd_associado And 
			--t400.cd_empresa = t500.cd_empresa And 
			--T100.cd_sequencial_lote = LC.cd_sequencial And 
			--case T300.cd_equipe = T1.cd_equipe And 
			--T200.cd_grau_parentesco = 1 And ';


			SET @SQL
			= @SQL
			+ '  FROM dbo.lote_contratos_contratos_vendedor T100 INNER JOIN dbo.DEPENDENTES T200 ON T100.cd_sequencial_dep = T200.CD_SEQUENCIAL
			INNER JOIN dbo.FUNCIONARIO T300 ON T200.cd_funcionario_vendedor = T300.cd_funcionario
			INNER JOIN dbo.Associados T400 ON T200.CD_ASSOCIADO = T400.cd_associado
			INNER JOIN dbo.Empresa T500 ON T400.cd_empresa = T500.CD_EMPRESA
			INNER JOIN dbo.lote_contratos lc ON T100.cd_sequencial_lote = lc.cd_sequencial AND T300.cd_equipe = T1.CD_EQUIPE AND T200.CD_GRAU_PARENTESCO =1';


			IF (@uf <> -1)
			BEGIN
				SET @SQL = @SQL + ' INNER JOIN dbo.UF ON T400.ufId = dbo.UF.ufId ';
				SET @SQL = @SQL + ' uf.ufid = ' + CONVERT(VARCHAR, @uf) + ' And ';
			END;
			ELSE
			BEGIN
				SET @SQL = @SQL + ' LEFT JOIN dbo.UF ON T400.ufId = dbo.UF.ufId ';
			END;


			IF (@municipio <> -1)
			BEGIN
				SET @SQL = @SQL + ' INNER JOIN dbo.Municipio mu ON T400.CidID = mu.CD_MUNICIPIO And ';
				SET @SQL = @SQL + ' mu.cd_municipio = ' + CONVERT(VARCHAR, @municipio) + ' And';
			END;
			ELSE
			BEGIN
				SET @SQL = @SQL + ' LEFT JOIN dbo.Municipio mu ON T400.CidID = mu.CD_MUNICIPIO ';
			END;

			IF (@nm_equipe <> '')
			BEGIN
				SET @SQL = @SQL + ' INNER JOIN dbo.equipe_vendas T900 ON T300.cd_equipe = T900.cd_equipe ';
				SET @SQL = @SQL + ' And t900.nm_equipe like''' + @nm_equipe + ''' ';
			END;
			ELSE
			BEGIN
				SET @SQL = @SQL + ' LEFT JOIN dbo.equipe_vendas T900 ON T300.cd_equipe = T900.cd_equipe ';
			END;

			/*COMENTADOS FORAM REALIZADOS OS JOINS*/
			--IF (@uf <> -1)
			--BEGIN
			--    SET @SQL = @SQL + ' t400.ufid = uf.ufid And ';
			--    SET @SQL = @SQL + ' uf.ufid = ' + CONVERT(VARCHAR, @uf) + ' And ';
			--END;
			--ELSE
			--BEGIN
			--    SET @SQL = @SQL + ' t400.ufid *= uf.ufid And ';
			--END;

			--IF (@municipio <> -1)
			--BEGIN
			--    SET @SQL = @SQL + ' t400.cidid = mu.cd_municipio And ';
			--    SET @SQL = @SQL + ' mu.cd_municipio = ' + CONVERT(VARCHAR, @municipio) + ' And';
			--END;
			--ELSE
			--BEGIN
			--    SET @SQL = @SQL + ' t400.cidid *= mu.cd_municipio And ';
			--END;


			SET @SQL = @SQL + ' WHERE ';

			IF (@ConfigBusca = 1)
			BEGIN
				SET @SQL
				= @SQL + ' T100.dt_cadastro between ''' + CONVERT(VARCHAR(10), @DT_Inicial, 101) + ''' And '''
				+ CONVERT(VARCHAR(10), @DT_Final, 101) + ' 23:59''';
			END;
			ELSE
			BEGIN
				SET @SQL
				= @SQL + ' T100.dt_assinaturaContrato between ''' + CONVERT(VARCHAR(10), @DT_Inicial, 101)
				+ ''' And ''' + CONVERT(VARCHAR(10), @DT_Final, 101) + ' 23:59''';
			END;

			IF (@cpfvendedor <> '')
			BEGIN
				SET @SQL = @SQL + ' And T300.nr_cpf = ''' + @cpfvendedor + '''';
			END;

			IF (@equipe > 0)
			BEGIN
				SET @SQL = @SQL + ' And T300.cd_equipe = ' + CONVERT(VARCHAR, @equipe);
			END;

			IF (@vendedor > 0)
			BEGIN
				SET @SQL = @SQL + ' And T300.cd_funcionario = ' + CONVERT(VARCHAR, @vendedor);
			END;

			IF (@chefe > 0)
			BEGIN
				SET @SQL
				= @SQL + ' and T300.cd_equipe in (select eq.cd_equipe from equipe_vendas eq where eq.cd_chefe = '
				+ CONVERT(VARCHAR, @chefe) + ' or cd_chefe1 = ' + CONVERT(VARCHAR, @chefe) + ' or cd_chefe2 = '
				+ CONVERT(VARCHAR, @chefe) + ')';
			END;

			IF (@plano <> '')
			BEGIN
				SET @SQL = @SQL + ' and T200.cd_plano in (' + @plano + ')';
			END;

			IF (@tipoEmpresa <> '')
			BEGIN
				SET @SQL = @SQL + ' and T500.tp_empresa in (' + @tipoEmpresa + ')';
			END;

			IF (@tipoPagamento <> '')
			BEGIN
				SET @SQL = @SQL + ' and T500.cd_tipo_pagamento in (' + @tipoPagamento + ')';
			END;

			--##TIPORECEBIMENTO##
			IF (@tipoRecebimento <> '')
			BEGIN
				SET @SQL
				= @SQL
				+ 'and (select count(0)                                 
 								from mensalidades_planos t1000,                     
 									 mensalidades t2000                             
 								where t1000.cd_sequencial_dep = T100.cd_sequencial_dep 
 								and t2000.cd_parcela = t1000.cd_parcela_mensalidade 
 								and t2000.cd_tipo_recebimento in(' + @tipoRecebimento + ') 
 								) > 0 ';
			END;

			IF (@grupoEmpresa > 0)
			BEGIN
				SET @SQL = @SQL + ' and T500.cd_grupo = ' + CONVERT(VARCHAR, @grupoEmpresa);
			END;

			IF (@centroCusto > 0)
			BEGIN
				SET @SQL = @SQL + ' and T500.cd_centro_custo = ' + CONVERT(VARCHAR, @centroCusto);
			END;

			IF (@situacao <> '')
			BEGIN
				SET @SQL
				= @SQL
				+ ' and (select top 1 cd_situacao from historico where cd_sequencial_dep = T200.cd_sequencial order by convert(date,dt_situacao) desc, cd_sequencial desc) in ('
				+ @situacao + ')';
			END;


			/*COMENTADOS FORAM REALIZADOS OS JOINS*/
			--IF (@nm_equipe <> '')
			--BEGIN
			--    SET @SQL = @SQL + ' And t900.nm_equipe like''' + @nm_equipe + ''' ';
			--    SET @SQL = @SQL + ' And t300.cd_equipe = t900.cd_equipe ';
			--END;
			--ELSE
			--BEGIN
			--    SET @SQL = @SQL + ' And t300.cd_equipe *= t900.cd_equipe ';
			--END;

			IF (@adesionista > 0)
			BEGIN
				SET @SQL = @SQL + ' AND T200.cd_funcionario_adesionista = ' + CONVERT(VARCHAR, @adesionista);
			END;

			SET @SQL = @SQL + ' ) As qtde_associados ';
			SET @SQL = @SQL + ' From equipe_vendas T1 ';

			IF (@chefe > 0)
			BEGIN
				SET @SQL
				= @SQL + ' where (T1.cd_chefe = ' + CONVERT(VARCHAR, @chefe) + ' or T1.cd_chefe1 = '
				+ CONVERT(VARCHAR, @chefe) + 'or T1.cd_chefe2 = ' + CONVERT(VARCHAR, @chefe) + ') ';
			END;

			SET @SQL = @SQL + ' Order By 3 desc ';
		END;

		IF @tipo = 2
		BEGIN
			SET @SQL = @SQL + ' select p.cd_plano, p.nm_plano, COUNT(0), SUM(l.vl_contrato), ';
			--Qtde Contratos
			SET @SQL = @SQL + ' (Select Count(distinct T400.cd_associado) ';
			SET @SQL
			= @SQL
			+ ' From lote_contratos_contratos_vendedor T100, Dependentes T200 , Funcionario T300, associados t400, empresa t500, lote_contratos LC, Equipe_Vendas t900 ';
			SET @SQL = @SQL + ' Where T100.cd_sequencial_dep = T200.cd_sequencial And ';
			SET @SQL = @SQL + ' T200.cd_funcionario_vendedor = T300.cd_funcionario And ';
			SET @SQL = @SQL + ' t200.cd_associado = t400.cd_associado And ';
			SET @SQL = @SQL + ' t400.cd_empresa = t500.cd_empresa And ';
			SET @SQL = @SQL + ' t200.cd_plano = p.cd_plano and ';
			SET @SQL = @SQL + ' T200.cd_grau_parentesco = 1 and ';
			SET @SQL = @SQL + ' T100.cd_sequencial_lote = LC.cd_sequencial And ';

			IF (@ConfigBusca = 1)
			BEGIN
				SET @SQL
				= @SQL + ' T100.dt_cadastro between ''' + CONVERT(VARCHAR(10), @DT_Inicial, 101) + ''' And '''
				+ CONVERT(VARCHAR(10), @DT_Final, 101) + ' 23:59''';
			END;
			ELSE
			BEGIN
				SET @SQL
				= @SQL + ' T100.dt_assinaturaContrato between ''' + CONVERT(VARCHAR(10), @DT_Inicial, 101)
				+ ''' And ''' + CONVERT(VARCHAR(10), @DT_Final, 101) + ' 23:59''';
			END;

			IF (@cpfvendedor <> '')
			BEGIN
				SET @SQL = @SQL + ' And T300.nr_cpf = ''' + @cpfvendedor + '''';
			END;

			IF (@equipe > 0)
			BEGIN
				SET @SQL = @SQL + ' And T300.cd_equipe = ' + CONVERT(VARCHAR, @equipe);
			END;

			IF (@vendedor > 0)
			BEGIN
				SET @SQL = @SQL + ' And T300.cd_funcionario = ' + CONVERT(VARCHAR, @vendedor);
			END;

			IF (@chefe > 0)
			BEGIN
				SET @SQL
				= @SQL + ' and T300.cd_equipe in (select eq.cd_equipe from equipe_vendas eq where eq.cd_chefe = '
				+ CONVERT(VARCHAR, @chefe) + ' or cd_chefe1 = ' + CONVERT(VARCHAR, @chefe) + ' or cd_chefe2 = '
				+ CONVERT(VARCHAR, @chefe) + ')';
			END;

			IF (@plano <> '')
			BEGIN
				SET @SQL = @SQL + ' and T200.cd_plano in (' + @plano + ')';
			END;

			IF (@tipoEmpresa <> '')
			BEGIN
				SET @SQL = @SQL + ' and T500.tp_empresa in (' + @tipoEmpresa + ')';
			END;

			IF (@tipoPagamento <> '')
			BEGIN
				SET @SQL = @SQL + ' and T500.cd_tipo_pagamento in (' + @tipoPagamento + ')';
			END;

			--##TIPORECEBIMENTO##
			IF (@tipoRecebimento <> '')
			BEGIN
				SET @SQL
				= @SQL
				+ 'and (select count(0)                                 
 								from mensalidades_planos t1000,                     
 									 mensalidades t2000                             
 								where t1000.cd_sequencial_dep = T100.cd_sequencial_dep 
 								and t2000.cd_parcela = t1000.cd_parcela_mensalidade 
 								and t2000.cd_tipo_recebimento in(' + @tipoRecebimento + ') 
 								) > 0 ';
			END;

			IF (@grupoEmpresa > 0)
			BEGIN
				SET @SQL = @SQL + ' and T500.cd_grupo = ' + CONVERT(VARCHAR, @grupoEmpresa);
			END;

			IF (@centroCusto > 0)
			BEGIN
				SET @SQL = @SQL + ' and T500.cd_centro_custo = ' + CONVERT(VARCHAR, @centroCusto);
			END;

			IF (@situacao <> '')
			BEGIN
				SET @SQL
				= @SQL
				+ ' and (select top 1 cd_situacao from historico where cd_sequencial_dep = T200.cd_sequencial order by convert(date,dt_situacao) desc, cd_sequencial desc) in ('
				+ @situacao + ')';
			END;

			IF (@nm_equipe <> '')
			BEGIN
				SET @SQL = @SQL + ' And t900.nm_equipe like''' + @nm_equipe + ''' ';
				SET @SQL = @SQL + ' And T300.cd_equipe = t900.cd_equipe ';
			END;
			ELSE
			BEGIN
				SET @SQL = @SQL + ' And T300.cd_equipe *= t900.cd_equipe ';
			END;

			IF (@adesionista > 0)
			BEGIN
				SET @SQL = @SQL + ' AND T200.cd_funcionario_adesionista = ' + CONVERT(VARCHAR, @adesionista);
			END;

			SET @SQL = @SQL + ' ) As contratos ';
			--valor total da comissao
			SET @SQL = @SQL + ' , (Select SUM(IsNull(t100.vl_contrato,0)) ';
			SET @SQL
			= @SQL
			+ ' From lote_contratos_contratos_vendedor T100, Dependentes T200 , Funcionario T300, associados t400, empresa t500, lote_contratos LC, Equipe_Vendas t900 ';
			SET @SQL = @SQL + ' Where T100.cd_sequencial_dep = T200.cd_sequencial And ';
			SET @SQL = @SQL + ' T200.cd_funcionario_vendedor = T300.cd_funcionario And ';
			SET @SQL = @SQL + ' t200.cd_associado = t400.cd_associado And ';
			SET @SQL = @SQL + ' t400.cd_empresa = t500.cd_empresa And ';
			SET @SQL = @SQL + ' T100.cd_sequencial_lote = LC.cd_sequencial And ';

			IF (@ConfigBusca = 1)
			BEGIN
				SET @SQL
				= @SQL + ' T100.dt_cadastro between ''' + CONVERT(VARCHAR(10), @DT_Inicial, 101) + ''' And '''
				+ CONVERT(VARCHAR(10), @DT_Final, 101) + ' 23:59''';
			END;
			ELSE
			BEGIN
				SET @SQL
				= @SQL + ' T100.dt_assinaturaContrato between ''' + CONVERT(VARCHAR(10), @DT_Inicial, 101)
				+ ''' And ''' + CONVERT(VARCHAR(10), @DT_Final, 101) + ' 23:59''';
			END;

			IF (@cpfvendedor <> '')
			BEGIN
				SET @SQL = @SQL + ' And T300.nr_cpf = ''' + @cpfvendedor + '''';
			END;

			IF (@equipe > 0)
			BEGIN
				SET @SQL = @SQL + ' And T300.cd_equipe = ' + CONVERT(VARCHAR, @equipe);
			END;

			IF (@vendedor > 0)
			BEGIN
				SET @SQL = @SQL + ' And T300.cd_funcionario = ' + CONVERT(VARCHAR, @vendedor);
			END;

			IF (@chefe > 0)
			BEGIN
				SET @SQL
				= @SQL + ' and T300.cd_equipe in (select eq.cd_equipe from equipe_vendas eq where eq.cd_chefe = '
				+ CONVERT(VARCHAR, @chefe) + ' or cd_chefe1 = ' + CONVERT(VARCHAR, @chefe) + ' or cd_chefe2 = '
				+ CONVERT(VARCHAR, @chefe) + ')';
			END;

			IF (@plano <> '')
			BEGIN
				SET @SQL = @SQL + ' and T200.cd_plano in (' + @plano + ')';
			END;

			IF (@tipoEmpresa <> '')
			BEGIN
				SET @SQL = @SQL + ' and T500.tp_empresa in (' + @tipoEmpresa + ')';
			END;

			IF (@tipoPagamento <> '')
			BEGIN
				SET @SQL = @SQL + ' and T500.cd_tipo_pagamento in (' + @tipoPagamento + ')';
			END;

			--##TIPORECEBIMENTO##
			IF (@tipoRecebimento <> '')
			BEGIN
				SET @SQL
				= @SQL
				+ 'and (select count(0)                                 
 								from mensalidades_planos t1000,                     
 									 mensalidades t2000                             
 								where t1000.cd_sequencial_dep = T100.cd_sequencial_dep 
 								and t2000.cd_parcela = t1000.cd_parcela_mensalidade 
 								and t2000.cd_tipo_recebimento in(' + @tipoRecebimento + ') 
 								) > 0 ';
			END;

			IF (@grupoEmpresa > 0)
			BEGIN
				SET @SQL = @SQL + ' and T500.cd_grupo = ' + CONVERT(VARCHAR, @grupoEmpresa);
			END;

			IF (@centroCusto > 0)
			BEGIN
				SET @SQL = @SQL + ' and T500.cd_centro_custo = ' + CONVERT(VARCHAR, @centroCusto);
			END;

			IF (@situacao <> '')
			BEGIN
				SET @SQL
				= @SQL
				+ ' and (select top 1 cd_situacao from historico where cd_sequencial_dep = T200.cd_sequencial order by convert(date,dt_situacao) desc, cd_sequencial desc) in ('
				+ @situacao + ')';
			END;

			IF (@nm_equipe <> '')
			BEGIN
				SET @SQL = @SQL + ' And t900.nm_equipe like''' + @nm_equipe + ''' ';
				SET @SQL = @SQL + ' And T300.cd_equipe = t900.cd_equipe ';
			END;
			ELSE
			BEGIN
				SET @SQL = @SQL + ' And T300.cd_equipe *= t900.cd_equipe ';
			END;

			IF (@adesionista > 0)
			BEGIN
				SET @SQL = @SQL + ' AND T200.cd_funcionario_adesionista = ' + CONVERT(VARCHAR, @adesionista);
			END;

			SET @SQL = @SQL + ' ) As vl_total, ';
			SET @SQL
			= @SQL
			+ ' (select count(distinct T200.cd_sequencial_dep) 
	  		from mensalidades as T100 , mensalidades_planos as T200 , dependentes as T300 ,lote_contratos_contratos_vendedor as T400 , 
	  		funcionario as t500, lote_contratos as t600, associados as t700, empresa as t800, uf as t900, municipio as t1000, Equipe_Vendas t901
	  		where T100.cd_parcela = T200.cd_parcela_mensalidade 
	  		and T200.cd_sequencial_dep = T300.cd_sequencial
	  		and T300.cd_sequencial = T400.cd_sequencial_dep
	  		and t300.cd_funcionario_vendedor = t500.cd_funcionario
	  		and t400.cd_sequencial_lote = t600.cd_sequencial 
	  		and t300.cd_Associado = t700.cd_Associado 
	  		and t700.cd_empresa = t800.cd_empresa 
	  		and T200.dt_exclusao is null 
	  		and T200.valor >0 
	  		and T100.cd_tipo_parcela = 2 
	  		and t100.cd_tipo_recebimento not in (1) 
	  		and T300.cd_plano = p.cd_plano ';

			IF (@ConfigBusca = 1)
			BEGIN
				SET @SQL
				= @SQL + ' and T400.dt_cadastro between ''' + CONVERT(VARCHAR(10), @DT_Inicial, 101) + ''' And '''
				+ CONVERT(VARCHAR(10), @DT_Final, 101) + ' 23:59'' ';
			END;
			ELSE
			BEGIN
				SET @SQL
				= @SQL + ' and T400.dt_assinaturaContrato between ''' + CONVERT(VARCHAR(10), @DT_Inicial, 101)
				+ ''' And ''' + CONVERT(VARCHAR(10), @DT_Final, 101) + ' 23:59'' ';
			END;

			IF (@uf <> -1)
			BEGIN
				SET @SQL = @SQL + ' and t700.ufid = t900.ufid ';
				SET @SQL = @SQL + ' and t900.ufid = ' + CONVERT(VARCHAR, @uf) + '';
			END;
			ELSE
			BEGIN
				SET @SQL = @SQL + ' and t700.ufid *= t900.ufid ';
			END;

			IF (@municipio <> -1)
			BEGIN
				SET @SQL = @SQL + ' and t700.cidid = t1000.cd_municipio ';
				SET @SQL = @SQL + ' And t1000.cd_municipio = ' + CONVERT(VARCHAR, @municipio);
			END;
			ELSE
			BEGIN
				SET @SQL = @SQL + ' and t700.cidid *= t1000.cd_municipio ';
			END;

			IF (@cpfvendedor <> '')
			BEGIN
				SET @SQL = @SQL + ' And T500.nr_cpf = ''' + @cpfvendedor + '''';
			END;

			IF (@equipe > 0)
			BEGIN
				--SET @SQL = @SQL + ' And case when t600.cd_empresa is null then isnull(t600.cd_equipe,T400.cd_equipe) else T400.cd_equipe end = ' + convert(VARCHAR, @equipe)
				SET @SQL = @SQL + ' And T500.cd_equipe = ' + CONVERT(VARCHAR, @equipe);
			END;

			IF (@vendedor > 0)
			BEGIN
				SET @SQL = @SQL + ' And T500.cd_funcionario = ' + CONVERT(VARCHAR, @vendedor);
			END;

			IF (@chefe > 0)
			BEGIN
				--SET @SQL = @SQL + ' and case when t600.cd_empresa is null then isnull(t600.cd_equipe,T400.cd_equipe) else T400.cd_equipe end in (select eq.cd_equipe from equipe_vendas eq where eq.cd_chefe = ' + convert(VARCHAR, @chefe) + ' or cd_chefe1 = ' + convert(VARCHAR, @chefe) + ' or cd_chefe2 = ' + convert(VARCHAR, @chefe) + ')'
				SET @SQL
				= @SQL + ' and t500.cd_equipe in (select eq.cd_equipe from equipe_vendas eq where eq.cd_chefe = '
				+ CONVERT(VARCHAR, @chefe) + ' or cd_chefe1 = ' + CONVERT(VARCHAR, @chefe) + ' or cd_chefe2 = '
				+ CONVERT(VARCHAR, @chefe) + ')';
			END;

			IF (@plano <> '')
			BEGIN
				SET @SQL = @SQL + ' and T300.cd_plano in (' + @plano + ')';
			END;

			IF (@tipoEmpresa <> '')
			BEGIN
				SET @SQL = @SQL + ' and T800.tp_empresa in (' + @tipoEmpresa + ')';
			END;

			IF (@tipoPagamento <> '')
			BEGIN
				SET @SQL = @SQL + ' and T800.cd_tipo_pagamento in (' + @tipoPagamento + ')';
			END;

			--##TIPORECEBIMENTO##
			IF (@tipoRecebimento <> '')
			BEGIN
				SET @SQL
				= @SQL
				+ 'and (select count(0)                                 
 								from mensalidades_planos t1000,                     
 									 mensalidades t2000                             
 								where t1000.cd_sequencial_dep = T400.cd_sequencial_dep 
 								and t2000.cd_parcela = t1000.cd_parcela_mensalidade 
 								and t2000.cd_tipo_recebimento in(' + @tipoRecebimento + ') 
 								) > 0 ';
			END;

			IF (@grupoEmpresa > 0)
			BEGIN
				SET @SQL = @SQL + ' and T800.cd_grupo = ' + CONVERT(VARCHAR, @grupoEmpresa);
			END;

			IF (@centroCusto > 0)
			BEGIN
				SET @SQL = @SQL + ' and T800.cd_centro_custo = ' + CONVERT(VARCHAR, @centroCusto);
			END;

			IF (@situacao <> '')
			BEGIN
				SET @SQL
				= @SQL
				+ ' and (select top 1 cd_situacao from historico where cd_sequencial_dep = T300.cd_sequencial order by convert(date,dt_situacao) desc, cd_sequencial desc) in ('
				+ @situacao + ')';
			END;

			IF (@nm_equipe <> '')
			BEGIN
				SET @SQL = @SQL + ' And t901.nm_equipe like''' + @nm_equipe + ''' ';
				SET @SQL = @SQL + ' And t500.cd_equipe = t901.cd_equipe ';
			END;
			ELSE
			BEGIN
				SET @SQL = @SQL + ' And t500.cd_equipe *= t901.cd_equipe ';
			END;

			IF (@adesionista > 0)
			BEGIN
				SET @SQL = @SQL + ' AND T300.cd_funcionario_adesionista = ' + CONVERT(VARCHAR, @adesionista);
			END;

			SET @SQL = @SQL + ' ) as C_A ';
			SET @SQL
			= @SQL
			+ ' from funcionario f, lote_contratos_contratos_vendedor as l , DEPENDENTES as d, ASSOCIADOS as a, PLANOS as p , EMPRESA as e , TIPO_PAGAMENTO as t, GRUPO as g, Centro_Custo as cc, UF AS uf, municipio AS mu, lote_contratos LC, Equipe_Vendas ev ';

			IF (@ConfigBusca = 1)
			BEGIN
				SET @SQL
				= @SQL + ' where l.dt_cadastro between ''' + CONVERT(VARCHAR(10), @DT_Inicial, 101) + ''' And '''
				+ CONVERT(VARCHAR(10), @DT_Final, 101) + ' 23:59'' and ';
			END;
			ELSE
			BEGIN
				SET @SQL
				= @SQL + ' where l.dt_assinaturaContrato between ''' + CONVERT(VARCHAR(10), @DT_Inicial, 101)
				+ ''' And ''' + CONVERT(VARCHAR(10), @DT_Final, 101) + ' 23:59'' and ';
			END;

			SET @SQL = @SQL + ' l.cd_sequencial_dep = d.CD_SEQUENCIAL ';
			SET @SQL = @SQL + ' and d.cd_plano = p.cd_plano ';
			SET @SQL = @SQL + ' and d.CD_ASSOCIADO = a.cd_associado ';
			SET @SQL = @SQL + ' and a.cd_empresa = e.CD_EMPRESA ';
			SET @SQL = @SQL + ' and e.cd_tipo_pagamento = t.cd_tipo_pagamento ';
			SET @SQL = @SQL + ' and e.cd_grupo *= g.cd_grupo ';
			SET @SQL = @SQL + ' and e.cd_centro_custo = cc.cd_centro_custo ';
			SET @SQL = @SQL + ' and f.cd_funcionario *= d.cd_funcionario_vendedor ';
			SET @SQL = @SQL + ' And l.cd_sequencial_lote = LC.cd_sequencial ';

			IF (@uf <> -1)
			BEGIN
				SET @SQL = @SQL + ' and a.ufid = uf.ufid ';
				SET @SQL = @SQL + ' and uf.ufid = ' + CONVERT(VARCHAR, @uf) + '';
			END;
			ELSE
			BEGIN
				SET @SQL = @SQL + ' and a.ufid *= uf.ufid ';
			END;

			IF (@municipio <> -1)
			BEGIN
				SET @SQL = @SQL + ' and a.cidid = mu.cd_municipio ';
				SET @SQL = @SQL + ' And mu.cd_municipio = ' + CONVERT(VARCHAR, @municipio);
			END;
			ELSE
			BEGIN
				SET @SQL = @SQL + ' and a.cidid *= mu.cd_municipio ';
			END;

			IF (@cpfvendedor <> '')
			BEGIN
				SET @SQL = @SQL + ' And f.nr_cpf = ''' + @cpfvendedor + '''';
			END;

			IF (@equipe > 0)
			BEGIN
				SET @SQL = @SQL + ' And f.cd_equipe  = ' + CONVERT(VARCHAR, @equipe);
			END;

			IF (@vendedor > 0)
			BEGIN
				SET @SQL = @SQL + ' and d.cd_funcionario_vendedor = ' + CONVERT(VARCHAR, @vendedor);
			END;

			IF (@chefe > 0)
			BEGIN
				--SET @SQL = @SQL + ' and l.cd_equipe in (select eq.cd_equipe from equipe_vendas eq where eq.cd_chefe = ' + convert(VARCHAR, @chefe) + ' or cd_chefe1 = ' + convert(VARCHAR, @chefe) + ' or cd_chefe2 = ' + convert(VARCHAR, @chefe) + ')'
				SET @SQL
				= @SQL + ' and f.cd_equipe in (select eq.cd_equipe from equipe_vendas eq where eq.cd_chefe = '
				+ CONVERT(VARCHAR, @chefe) + ' or cd_chefe1 = ' + CONVERT(VARCHAR, @chefe) + ' or cd_chefe2 = '
				+ CONVERT(VARCHAR, @chefe) + ')';
			END;

			IF (@plano <> '')
			BEGIN
				SET @SQL = @SQL + ' and d.cd_plano in (' + @plano + ')';
			END;

			IF (@tipoEmpresa <> '')
			BEGIN
				SET @SQL = @SQL + ' and e.tp_empresa in (' + @tipoEmpresa + ')';
			END;

			IF (@tipoPagamento <> '')
			BEGIN
				SET @SQL = @SQL + ' and e.cd_tipo_pagamento in (' + @tipoPagamento + ')';
			END;

			--##TIPORECEBIMENTO##
			IF (@tipoRecebimento <> '')
			BEGIN
				SET @SQL
				= @SQL
				+ 'and (select count(0)                                 
 								from mensalidades_planos t1000,                     
 									 mensalidades t2000                             
 								where t1000.cd_sequencial_dep = l.cd_sequencial_dep 
 								and t2000.cd_parcela = t1000.cd_parcela_mensalidade 
 								and t2000.cd_tipo_recebimento in(' + @tipoRecebimento + ') 
 								) > 0 ';
			END;

			IF (@grupoEmpresa > 0)
			BEGIN
				SET @SQL = @SQL + ' and e.cd_grupo = ' + CONVERT(VARCHAR, @grupoEmpresa);
			END;

			IF (@centroCusto > 0)
			BEGIN
				SET @SQL = @SQL + ' and e.cd_centro_custo = ' + CONVERT(VARCHAR, @centroCusto);
			END;

			IF (@situacao <> '')
			BEGIN
				SET @SQL
				= @SQL
				+ ' and (select top 1 cd_situacao from historico where cd_sequencial_dep = d.cd_sequencial order by convert(date,dt_situacao) desc, cd_sequencial desc) in ('
				+ @situacao + ')';
			END;

			IF (@nm_equipe <> '')
			BEGIN
				SET @SQL = @SQL + ' And ev.nm_equipe like''' + @nm_equipe + ''' ';
				SET @SQL = @SQL + ' And f.cd_equipe = ev.cd_equipe ';
			END;
			ELSE
			BEGIN
				SET @SQL = @SQL + ' And f.cd_equipe *= ev.cd_equipe ';
			END;

			IF (@adesionista > 0)
			BEGIN
				SET @SQL = @SQL + ' And d.cd_funcionario_adesionista = ' + CONVERT(VARCHAR, @adesionista);
			END;

			SET @SQL = @SQL + ' group by p.cd_plano, p.nm_plano ';
			SET @SQL = @SQL + ' order by 3 desc ';
		END;

		IF @tipo = 3
		BEGIN
			SET @SQL = @SQL + ' select t.cd_tipo_pagamento, t.nm_tipo_pagamento, COUNT(0), SUM(l.vl_contrato), ';
			--Qtde Contratos
			SET @SQL = @SQL + ' (Select Count(distinct T400.cd_associado) ';
			SET @SQL
			= @SQL
			+ ' From lote_contratos_contratos_vendedor T100, Dependentes T200 , Funcionario T300 , associados t400, empresa t500, tipo_pagamento t600, lote_contratos LC, Equipe_Vendas t900 ';
			SET @SQL = @SQL + ' Where T100.cd_sequencial_dep = T200.cd_sequencial ';
			SET @SQL = @SQL + ' And T200.cd_funcionario_vendedor = T300.cd_funcionario ';
			SET @SQL = @SQL + ' And t200.cd_associado = t400.cd_associado ';
			SET @SQL = @SQL + ' and t400.cd_empresa = t500.cd_empresa ';
			SET @SQL = @SQL + ' and t500.cd_tipo_pagamento = t600.cd_tipo_pagamento ';
			SET @SQL = @SQL + ' and t600.cd_tipo_pagamento = t.cd_tipo_pagamento ';
			SET @SQL = @SQL + ' and T200.cd_grau_parentesco = 1 ';
			SET @SQL = @SQL + ' and T100.cd_sequencial_lote = LC.cd_sequencial ';

			IF (@ConfigBusca = 1)
			BEGIN
				SET @SQL
				= @SQL + ' And T100.dt_cadastro between ''' + CONVERT(VARCHAR(10), @DT_Inicial, 101) + ''' And '''
				+ CONVERT(VARCHAR(10), @DT_Final, 101) + ' 23:59''';
			END;
			ELSE
			BEGIN
				SET @SQL
				= @SQL + ' And T100.dt_assinaturaContrato between ''' + CONVERT(VARCHAR(10), @DT_Inicial, 101)
				+ ''' And ''' + CONVERT(VARCHAR(10), @DT_Final, 101) + ' 23:59''';
			END;

			IF (@cpfvendedor <> '')
			BEGIN
				SET @SQL = @SQL + ' And T300.nr_cpf = ''' + @cpfvendedor + '''';
			END;

			IF (@equipe > 0)
			BEGIN
				SET @SQL = @SQL + ' And T300.cd_equipe = ' + CONVERT(VARCHAR, @equipe);
			END;

			IF (@vendedor > 0)
			BEGIN
				SET @SQL = @SQL + ' And T300.cd_funcionario = ' + CONVERT(VARCHAR, @vendedor);
			END;

			IF (@chefe > 0)
			BEGIN
				SET @SQL
				= @SQL + ' and T300.cd_equipe in (select eq.cd_equipe from equipe_vendas eq where eq.cd_chefe = '
				+ CONVERT(VARCHAR, @chefe) + ' or cd_chefe1 = ' + CONVERT(VARCHAR, @chefe) + ' or cd_chefe2 = '
				+ CONVERT(VARCHAR, @chefe) + ')';
			END;

			IF (@plano <> '')
			BEGIN
				SET @SQL = @SQL + ' and T200.cd_plano in (' + @plano + ')';
			END;

			IF (@tipoEmpresa <> '')
			BEGIN
				SET @SQL = @SQL + ' and T500.tp_empresa in (' + @tipoEmpresa + ')';
			END;

			IF (@tipoPagamento <> '')
			BEGIN
				SET @SQL = @SQL + ' and T500.cd_tipo_pagamento in (' + @tipoPagamento + ')';
			END;

			--##TIPORECEBIMENTO##
			IF (@tipoRecebimento <> '')
			BEGIN
				SET @SQL
				= @SQL
				+ 'and (select count(0)                                 
 								from mensalidades_planos t1000,                     
 									 mensalidades t2000                             
 								where t1000.cd_sequencial_dep = t100.cd_sequencial_dep 
 								and t2000.cd_parcela = t1000.cd_parcela_mensalidade 
 								and t2000.cd_tipo_recebimento in(' + @tipoRecebimento + ') 
 								) > 0 ';
			END;

			IF (@grupoEmpresa > 0)
			BEGIN
				SET @SQL = @SQL + ' and T500.cd_grupo = ' + CONVERT(VARCHAR, @grupoEmpresa);
			END;

			IF (@centroCusto > 0)
			BEGIN
				SET @SQL = @SQL + ' and T500.cd_centro_custo = ' + CONVERT(VARCHAR, @centroCusto);
			END;

			IF (@situacao <> '')
			BEGIN
				SET @SQL
				= @SQL
				+ ' and (select top 1 cd_situacao from historico where cd_sequencial_dep = T200.cd_sequencial order by convert(date,dt_situacao) desc, cd_sequencial desc) in ('
				+ @situacao + ')';
			END;

			IF (@nm_equipe <> '')
			BEGIN
				SET @SQL = @SQL + ' And t900.nm_equipe like''' + @nm_equipe + ''' ';
				SET @SQL = @SQL + ' And T300.cd_equipe = t900.cd_equipe ';
			END;
			ELSE
			BEGIN
				SET @SQL = @SQL + ' And T300.cd_equipe *= t900.cd_equipe ';
			END;

			IF (@adesionista > 0)
			BEGIN
				SET @SQL = @SQL + ' AND T200.cd_funcionario_adesionista = ' + CONVERT(VARCHAR, @adesionista);
			END;

			SET @SQL = @SQL + ' ) As contratos ';
			--Valor total
			SET @SQL = @SQL + ' , (Select SUM(isnull(T100.vl_contrato,0)) ';
			SET @SQL
			= @SQL
			+ ' From lote_contratos_contratos_vendedor T100, Dependentes T200 , Funcionario T300 , associados t400, empresa t500, tipo_pagamento t600, lote_contratos LC, Equipe_Vendas t900 ';
			SET @SQL = @SQL + ' Where T100.cd_sequencial_dep = T200.cd_sequencial ';
			SET @SQL = @SQL + ' And T200.cd_funcionario_vendedor = T300.cd_funcionario ';
			SET @SQL = @SQL + ' And t200.cd_associado = t400.cd_associado ';
			SET @SQL = @SQL + ' and t400.cd_empresa = t500.cd_empresa ';
			SET @SQL = @SQL + ' and t500.cd_tipo_pagamento = t600.cd_tipo_pagamento ';
			SET @SQL = @SQL + ' and T100.cd_sequencial_lote = LC.cd_sequencial ';

			IF (@ConfigBusca = 1)
			BEGIN
				SET @SQL
				= @SQL + ' And T100.dt_cadastro between ''' + CONVERT(VARCHAR(10), @DT_Inicial, 101) + ''' And '''
				+ CONVERT(VARCHAR(10), @DT_Final, 101) + ' 23:59''';
			END;
			ELSE
			BEGIN
				SET @SQL
				= @SQL + ' And T100.dt_assinaturaContrato between ''' + CONVERT(VARCHAR(10), @DT_Inicial, 101)
				+ ''' And ''' + CONVERT(VARCHAR(10), @DT_Final, 101) + ' 23:59''';
			END;

			IF (@cpfvendedor <> '')
			BEGIN
				SET @SQL = @SQL + ' And T300.nr_cpf = ''' + @cpfvendedor + '''';
			END;

			IF (@equipe > 0)
			BEGIN
				SET @SQL = @SQL + ' And T300.cd_equipe = ' + CONVERT(VARCHAR, @equipe);
			END;

			IF (@vendedor > 0)
			BEGIN
				SET @SQL = @SQL + ' And T300.cd_funcionario = ' + CONVERT(VARCHAR, @vendedor);
			END;

			IF (@chefe > 0)
			BEGIN
				SET @SQL
				= @SQL + ' and T300.cd_equipe in (select eq.cd_equipe from equipe_vendas eq where eq.cd_chefe = '
				+ CONVERT(VARCHAR, @chefe) + ' or cd_chefe1 = ' + CONVERT(VARCHAR, @chefe) + ' or cd_chefe2 = '
				+ CONVERT(VARCHAR, @chefe) + ')';
			END;

			IF (@plano <> '')
			BEGIN
				SET @SQL = @SQL + ' and T200.cd_plano in (' + @plano + ')';
			END;

			IF (@tipoEmpresa <> '')
			BEGIN
				SET @SQL = @SQL + ' and T500.tp_empresa in (' + @tipoEmpresa + ')';
			END;

			IF (@tipoPagamento <> '')
			BEGIN
				SET @SQL = @SQL + ' and T500.cd_tipo_pagamento in (' + @tipoPagamento + ')';
			END;

			--##TIPORECEBIMENTO##
			IF (@tipoRecebimento <> '')
			BEGIN
				SET @SQL
				= @SQL
				+ 'and (select count(0)                                 
 								from mensalidades_planos t1000,                     
 									 mensalidades t2000                             
 								where t1000.cd_sequencial_dep = t100.cd_sequencial_dep 
 								and t2000.cd_parcela = t1000.cd_parcela_mensalidade 
 								and t2000.cd_tipo_recebimento in(' + @tipoRecebimento + ') 
 								) > 0 ';
			END;

			IF (@grupoEmpresa > 0)
			BEGIN
				SET @SQL = @SQL + ' and T500.cd_grupo = ' + CONVERT(VARCHAR, @grupoEmpresa);
			END;

			IF (@centroCusto > 0)
			BEGIN
				SET @SQL = @SQL + ' and T500.cd_centro_custo = ' + CONVERT(VARCHAR, @centroCusto);
			END;

			IF (@situacao <> '')
			BEGIN
				SET @SQL
				= @SQL
				+ ' and (select top 1 cd_situacao from historico where cd_sequencial_dep = T200.cd_sequencial order by convert(date,dt_situacao) desc, cd_sequencial desc) in ('
				+ @situacao + ')';
			END;

			IF (@nm_equipe <> '')
			BEGIN
				SET @SQL = @SQL + ' And t900.nm_equipe like''' + @nm_equipe + ''' ';
				SET @SQL = @SQL + ' And T300.cd_equipe = t900.cd_equipe ';
			END;
			ELSE
			BEGIN
				SET @SQL = @SQL + ' And T300.cd_equipe *= t900.cd_equipe ';
			END;

			IF (@adesionista > 0)
			BEGIN
				SET @SQL = @SQL + ' AND T200.cd_funcionario_adesionista = ' + CONVERT(VARCHAR, @adesionista);
			END;

			SET @SQL = @SQL + ' ) As vl_total ';
			SET @SQL
			= @SQL
			+ ' from funcionario f, lote_contratos_contratos_vendedor as l, DEPENDENTES as d, ASSOCIADOS as a, PLANOS as p, EMPRESA as e, TIPO_PAGAMENTO as t, lote_contratos LC, uf, municipio mu, Equipe_Vendas ev ';

			IF (@ConfigBusca = 1)
			BEGIN
				SET @SQL
				= @SQL + ' where l.dt_cadastro between ''' + CONVERT(VARCHAR(10), @DT_Inicial, 101) + ''' And '''
				+ CONVERT(VARCHAR(10), @DT_Final, 101) + ' 23:59'' and ';
			END;
			ELSE
			BEGIN
				SET @SQL
				= @SQL + ' where l.dt_assinaturaContrato between ''' + CONVERT(VARCHAR(10), @DT_Inicial, 101)
				+ ''' And ''' + CONVERT(VARCHAR(10), @DT_Final, 101) + ' 23:59'' and ';
			END;

			SET @SQL = @SQL + ' l.cd_sequencial_dep = d.CD_SEQUENCIAL ';
			SET @SQL = @SQL + ' and d.cd_plano = p.cd_plano ';
			SET @SQL = @SQL + ' and d.CD_ASSOCIADO = a.cd_associado ';
			SET @SQL = @SQL + ' and a.cd_empresa = e.CD_EMPRESA ';
			SET @SQL = @SQL + ' and e.cd_tipo_pagamento = t.cd_tipo_pagamento ';
			SET @SQL = @SQL + ' and f.cd_funcionario *= d.cd_funcionario_vendedor ';
			SET @SQL = @SQL + ' and l.cd_sequencial_lote = LC.cd_sequencial ';

			IF (@uf <> -1)
			BEGIN
				SET @SQL = @SQL + ' and a.ufid = uf.ufid ';
				SET @SQL = @SQL + ' and uf.ufid = ' + CONVERT(VARCHAR, @uf) + '';
			END;
			ELSE
			BEGIN
				SET @SQL = @SQL + ' and a.ufid *= uf.ufid ';
			END;

			IF (@municipio <> -1)
			BEGIN
				SET @SQL = @SQL + ' and a.cidid = mu.cd_municipio ';
				SET @SQL = @SQL + ' And mu.cd_municipio = ' + CONVERT(VARCHAR, @municipio);
			END;
			ELSE
			BEGIN
				SET @SQL = @SQL + ' and a.cidid *= mu.cd_municipio ';
			END;

			IF (@cpfvendedor <> '')
			BEGIN
				SET @SQL = @SQL + ' And f.nr_cpf = ''' + @cpfvendedor + '''';
			END;

			IF (@equipe > 0)
			BEGIN
				SET @SQL = @SQL + ' And f.cd_equipe = ' + CONVERT(VARCHAR, @equipe);
			END;

			IF (@vendedor > 0)
			BEGIN
				SET @SQL = @SQL + ' and d.cd_funcionario_vendedor = ' + CONVERT(VARCHAR, @vendedor);
			END;

			IF (@chefe > 0)
			BEGIN
				SET @SQL
				= @SQL + ' and f.cd_equipe in (select eq.cd_equipe from equipe_vendas eq where eq.cd_chefe = '
				+ CONVERT(VARCHAR, @chefe) + ' or cd_chefe1 = ' + CONVERT(VARCHAR, @chefe) + ' or cd_chefe2 = '
				+ CONVERT(VARCHAR, @chefe) + ')';
			END;

			IF (@plano <> '')
			BEGIN
				SET @SQL = @SQL + ' and d.cd_plano in (' + @plano + ')';
			END;

			IF (@tipoEmpresa <> '')
			BEGIN
				SET @SQL = @SQL + ' and e.tp_empresa in (' + @tipoEmpresa + ')';
			END;

			IF (@tipoPagamento <> '')
			BEGIN
				SET @SQL = @SQL + ' and e.cd_tipo_pagamento in (' + @tipoPagamento + ')';
			END;

			--##TIPORECEBIMENTO##
			IF (@tipoRecebimento <> '')
			BEGIN
				SET @SQL
				= @SQL
				+ 'and (select count(0)                                 
 								from mensalidades_planos t1000,                     
 									 mensalidades t2000                             
 								where t1000.cd_sequencial_dep = l.cd_sequencial_dep 
 								and t2000.cd_parcela = t1000.cd_parcela_mensalidade 
 								and t2000.cd_tipo_recebimento in(' + @tipoRecebimento + ') 
 								) > 0 ';
			END;

			IF (@grupoEmpresa > 0)
			BEGIN
				SET @SQL = @SQL + ' and e.cd_grupo = ' + CONVERT(VARCHAR, @grupoEmpresa);
			END;

			IF (@centroCusto > 0)
			BEGIN
				SET @SQL = @SQL + ' and e.cd_centro_custo = ' + CONVERT(VARCHAR, @centroCusto);
			END;

			IF (@situacao <> '')
			BEGIN
				SET @SQL
				= @SQL
				+ ' and (select top 1 cd_situacao from historico where cd_sequencial_dep = d.cd_sequencial order by convert(date,dt_situacao) desc, cd_sequencial desc) in ('
				+ @situacao + ')';
			END;

			IF (@nm_equipe <> '')
			BEGIN
				SET @SQL = @SQL + ' And ev.nm_equipe like''' + @nm_equipe + ''' ';
				SET @SQL = @SQL + ' And f.cd_equipe = ev.cd_equipe ';
			END;
			ELSE
			BEGIN
				SET @SQL = @SQL + ' And f.cd_equipe *= ev.cd_equipe ';
			END;

			IF (@adesionista > 0)
			BEGIN
				SET @SQL = @SQL + ' And d.cd_funcionario_adesionista = ' + CONVERT(VARCHAR, @adesionista);
			END;

			SET @SQL = @SQL + ' group by t.cd_tipo_pagamento , t.nm_tipo_pagamento ';
			SET @SQL = @SQL + ' order by 3 desc ';
		END;

		IF @tipo = 4
		BEGIN
			SET @SQL
			= @SQL
			+ ' select isnull(g.cd_grupo, -1) as cd_grupo, isnull(g.nm_grupo, ''SEM GRUPO'') AS nm_grupo, COUNT(0), SUM(l.vl_contrato), ';
			--Qtde Contratos
			SET @SQL = @SQL + ' (Select Count(distinct T400.cd_associado) ';
			SET @SQL
			= @SQL
			+ ' From lote_contratos_contratos_vendedor T100, Dependentes T200 , Funcionario T300 , associados t400, empresa t500, GRUPO t600, lote_contratos LC, Equipe_Vendas t900 ';
			SET @SQL = @SQL + ' Where T100.cd_sequencial_dep = T200.cd_sequencial ';
			SET @SQL = @SQL + ' And T200.cd_funcionario_vendedor = T300.cd_funcionario ';
			SET @SQL = @SQL + ' And t200.cd_associado = t400.cd_associado ';
			SET @SQL = @SQL + ' and t400.cd_empresa = t500.cd_empresa ';
			SET @SQL = @SQL + ' and t500.cd_grupo *= t600.cd_grupo ';
			SET @SQL = @SQL + ' and t600.cd_grupo = g.cd_grupo';
			SET @SQL = @SQL + ' and T200.cd_grau_parentesco = 1 ';
			SET @SQL = @SQL + ' and T100.cd_sequencial_lote = LC.cd_sequencial ';

			IF (@ConfigBusca = 1)
			BEGIN
				SET @SQL
				= @SQL + ' And T100.dt_cadastro between ''' + CONVERT(VARCHAR(10), @DT_Inicial, 101) + ''' And '''
				+ CONVERT(VARCHAR(10), @DT_Final, 101) + ' 23:59''';
			END;
			ELSE
			BEGIN
				SET @SQL
				= @SQL + ' And T100.dt_assinaturaContrato between ''' + CONVERT(VARCHAR(10), @DT_Inicial, 101)
				+ ''' And ''' + CONVERT(VARCHAR(10), @DT_Final, 101) + ' 23:59''';
			END;

			IF (@cpfvendedor <> '')
			BEGIN
				SET @SQL = @SQL + ' And T300.nr_cpf = ''' + @cpfvendedor + '''';
			END;

			IF (@equipe > 0)
			BEGIN
				SET @SQL = @SQL + ' And T300.cd_equipe = ' + CONVERT(VARCHAR, @equipe);
			END;

			IF (@vendedor > 0)
			BEGIN
				SET @SQL = @SQL + ' And T300.cd_funcionario = ' + CONVERT(VARCHAR, @vendedor);
			END;

			IF (@chefe > 0)
			BEGIN
				SET @SQL
				= @SQL + ' and T300.cd_equipe in (select eq.cd_equipe from equipe_vendas eq where eq.cd_chefe = '
				+ CONVERT(VARCHAR, @chefe) + ' or cd_chefe1 = ' + CONVERT(VARCHAR, @chefe) + ' or cd_chefe2 = '
				+ CONVERT(VARCHAR, @chefe) + ')';
			END;

			IF (@plano <> '')
			BEGIN
				SET @SQL = @SQL + ' and T200.cd_plano in (' + @plano + ')';
			END;

			IF (@tipoEmpresa <> '')
			BEGIN
				SET @SQL = @SQL + ' and T500.tp_empresa in (' + @tipoEmpresa + ')';
			END;

			IF (@tipoPagamento <> '')
			BEGIN
				SET @SQL = @SQL + ' and T500.cd_tipo_pagamento in (' + @tipoPagamento + ')';
			END;

			--##TIPORECEBIMENTO##
			IF (@tipoRecebimento <> '')
			BEGIN
				SET @SQL
				= @SQL
				+ 'and (select count(0)                                 
							from mensalidades_planos t1000,                     
								 mensalidades t2000                             
							where t1000.cd_sequencial_dep = t100.cd_sequencial_dep 
							and t2000.cd_parcela = t1000.cd_parcela_mensalidade 
							and t2000.cd_tipo_recebimento in(' + @tipoRecebimento + ') 
							) > 0 ';
			END;

			IF (@grupoEmpresa > 0)
			BEGIN
				SET @SQL = @SQL + ' and T500.cd_grupo = ' + CONVERT(VARCHAR, @grupoEmpresa);
			END;

			IF (@centroCusto > 0)
			BEGIN
				SET @SQL = @SQL + ' and T500.cd_centro_custo = ' + CONVERT(VARCHAR, @centroCusto);
			END;

			IF (@situacao <> '')
			BEGIN
				SET @SQL
				= @SQL
				+ ' and (select top 1 cd_situacao from historico where cd_sequencial_dep = T200.cd_sequencial order by convert(date,dt_situacao) desc, cd_sequencial desc) in ('
				+ @situacao + ')';
			END;

			IF (@nm_equipe <> '')
			BEGIN
				SET @SQL = @SQL + ' And t900.nm_equipe like''' + @nm_equipe + ''' ';
				SET @SQL = @SQL + ' And T300.cd_equipe = t900.cd_equipe ';
			END;
			ELSE
			BEGIN
				SET @SQL = @SQL + ' And T300.cd_equipe *= t900.cd_equipe ';
			END;

			IF (@adesionista > 0)
			BEGIN
				SET @SQL = @SQL + ' AND T200.cd_funcionario_adesionista = ' + CONVERT(VARCHAR, @adesionista);
			END;

			SET @SQL = @SQL + ' ) As contratos ';
			--Valor total
			SET @SQL = @SQL + ' , (Select SUM(isnull(T100.vl_contrato,0)) ';
			SET @SQL
			= @SQL
			+ ' From lote_contratos_contratos_vendedor T100, Dependentes T200 , Funcionario T300 , associados t400, empresa t500, GRUPO t600, lote_contratos LC, Equipe_Vendas t900 ';
			SET @SQL = @SQL + ' Where T100.cd_sequencial_dep = T200.cd_sequencial ';
			SET @SQL = @SQL + ' And T200.cd_funcionario_vendedor = T300.cd_funcionario ';
			SET @SQL = @SQL + ' And t200.cd_associado = t400.cd_associado ';
			SET @SQL = @SQL + ' and t400.cd_empresa = t500.cd_empresa ';
			SET @SQL = @SQL + ' and t500.cd_grupo *= t600.cd_grupo ';
			SET @SQL = @SQL + ' and T100.cd_sequencial_lote = LC.cd_sequencial ';

			IF (@ConfigBusca = 1)
			BEGIN
				SET @SQL
				= @SQL + ' And T100.dt_cadastro between ''' + CONVERT(VARCHAR(10), @DT_Inicial, 101) + ''' And '''
				+ CONVERT(VARCHAR(10), @DT_Final, 101) + ' 23:59''';
			END;
			ELSE
			BEGIN
				SET @SQL
				= @SQL + ' And T100.dt_assinaturaContrato between ''' + CONVERT(VARCHAR(10), @DT_Inicial, 101)
				+ ''' And ''' + CONVERT(VARCHAR(10), @DT_Final, 101) + ' 23:59''';
			END;

			IF (@cpfvendedor <> '')
			BEGIN
				SET @SQL = @SQL + ' And T300.nr_cpf = ''' + @cpfvendedor + '''';
			END;

			IF (@equipe > 0)
			BEGIN
				SET @SQL = @SQL + ' And T300.cd_equipe = ' + CONVERT(VARCHAR, @equipe);
			END;

			IF (@vendedor > 0)
			BEGIN
				SET @SQL = @SQL + ' And T300.cd_funcionario = ' + CONVERT(VARCHAR, @vendedor);
			END;

			IF (@chefe > 0)
			BEGIN
				SET @SQL
				= @SQL + ' and T300.cd_equipe in (select eq.cd_equipe from equipe_vendas eq where eq.cd_chefe = '
				+ CONVERT(VARCHAR, @chefe) + ' or cd_chefe1 = ' + CONVERT(VARCHAR, @chefe) + ' or cd_chefe2 = '
				+ CONVERT(VARCHAR, @chefe) + ')';
			END;

			IF (@plano <> '')
			BEGIN
				SET @SQL = @SQL + ' and T200.cd_plano in (' + @plano + ')';
			END;

			IF (@tipoEmpresa <> '')
			BEGIN
				SET @SQL = @SQL + ' and T500.tp_empresa in (' + @tipoEmpresa + ')';
			END;

			IF (@tipoPagamento <> '')
			BEGIN
				SET @SQL = @SQL + ' and T500.cd_tipo_pagamento in (' + @tipoPagamento + ')';
			END;

			--##TIPORECEBIMENTO##
			IF (@tipoRecebimento <> '')
			BEGIN
				SET @SQL
				= @SQL
				+ 'and (select count(0)                                 
							from mensalidades_planos t1000,                     
								 mensalidades t2000                             
							where t1000.cd_sequencial_dep = t100.cd_sequencial_dep 
							and t2000.cd_parcela = t1000.cd_parcela_mensalidade 
							and t2000.cd_tipo_recebimento in(' + @tipoRecebimento + ') 
							) > 0 ';
			END;

			IF (@grupoEmpresa > 0)
			BEGIN
				SET @SQL = @SQL + ' and T500.cd_grupo = ' + CONVERT(VARCHAR, @grupoEmpresa);
			END;

			IF (@centroCusto > 0)
			BEGIN
				SET @SQL = @SQL + ' and T500.cd_centro_custo = ' + CONVERT(VARCHAR, @centroCusto);
			END;

			IF (@situacao <> '')
			BEGIN
				SET @SQL
				= @SQL
				+ ' and (select top 1 cd_situacao from historico where cd_sequencial_dep = T200.cd_sequencial order by convert(date,dt_situacao) desc, cd_sequencial desc) in ('
				+ @situacao + ')';
			END;

			IF (@nm_equipe <> '')
			BEGIN
				SET @SQL = @SQL + ' And t900.nm_equipe like''' + @nm_equipe + ''' ';
				SET @SQL = @SQL + ' And T300.cd_equipe = t900.cd_equipe ';
			END;
			ELSE
			BEGIN
				SET @SQL = @SQL + ' And T300.cd_equipe *= t900.cd_equipe ';
			END;

			IF (@adesionista > 0)
			BEGIN
				SET @SQL = @SQL + ' AND T200.cd_funcionario_adesionista = ' + CONVERT(VARCHAR, @adesionista);
			END;

			SET @SQL = @SQL + ' ) As vl_total ';
			SET @SQL
			= @SQL
			+ ' from funcionario f, lote_contratos_contratos_vendedor as l, DEPENDENTES as d, ASSOCIADOS as a, PLANOS as p, EMPRESA as e, GRUPO as g, lote_contratos LC, uf, municipio mu, Equipe_Vendas ev ';

			IF (@ConfigBusca = 1)
			BEGIN
				SET @SQL
				= @SQL + ' where l.dt_cadastro between ''' + CONVERT(VARCHAR(10), @DT_Inicial, 101) + ''' And '''
				+ CONVERT(VARCHAR(10), @DT_Final, 101) + ' 23:59'' and ';
			END;
			ELSE
			BEGIN
				SET @SQL
				= @SQL + ' where l.dt_assinaturaContrato between ''' + CONVERT(VARCHAR(10), @DT_Inicial, 101)
				+ ''' And ''' + CONVERT(VARCHAR(10), @DT_Final, 101) + ' 23:59'' and ';
			END;

			SET @SQL = @SQL + ' l.cd_sequencial_dep = d.CD_SEQUENCIAL ';
			SET @SQL = @SQL + ' and d.cd_plano = p.cd_plano ';
			SET @SQL = @SQL + ' and d.CD_ASSOCIADO = a.cd_associado ';
			SET @SQL = @SQL + ' and a.cd_empresa = e.CD_EMPRESA ';
			SET @SQL = @SQL + ' and e.cd_grupo *= g.cd_grupo ';
			SET @SQL = @SQL + ' and f.cd_funcionario *= d.cd_funcionario_vendedor ';
			SET @SQL = @SQL + ' and l.cd_sequencial_lote = LC.cd_sequencial ';

			IF (@uf <> -1)
			BEGIN
				SET @SQL = @SQL + ' and a.ufid = uf.ufid ';
				SET @SQL = @SQL + ' and uf.ufid = ' + CONVERT(VARCHAR, @uf) + '';
			END;
			ELSE
			BEGIN
				SET @SQL = @SQL + ' and a.ufid *= uf.ufid ';
			END;

			IF (@municipio <> -1)
			BEGIN
				SET @SQL = @SQL + ' and a.cidid = mu.cd_municipio ';
				SET @SQL = @SQL + ' And mu.cd_municipio = ' + CONVERT(VARCHAR, @municipio);
			END;
			ELSE
			BEGIN
				SET @SQL = @SQL + ' and a.cidid *= mu.cd_municipio ';
			END;

			IF (@cpfvendedor <> '')
			BEGIN
				SET @SQL = @SQL + ' And f.nr_cpf = ''' + @cpfvendedor + '''';
			END;

			IF (@equipe > 0)
			BEGIN
				SET @SQL = @SQL + ' And f.cd_equipe = ' + CONVERT(VARCHAR, @equipe);
			END;

			IF (@vendedor > 0)
			BEGIN
				SET @SQL = @SQL + ' and d.cd_funcionario_vendedor = ' + CONVERT(VARCHAR, @vendedor);
			END;

			IF (@chefe > 0)
			BEGIN
				SET @SQL
				= @SQL + ' and f.cd_equipe in (select eq.cd_equipe from equipe_vendas eq where eq.cd_chefe = '
				+ CONVERT(VARCHAR, @chefe) + ' or cd_chefe1 = ' + CONVERT(VARCHAR, @chefe) + ' or cd_chefe2 = '
				+ CONVERT(VARCHAR, @chefe) + ')';
			END;

			IF (@plano <> '')
			BEGIN
				SET @SQL = @SQL + ' and d.cd_plano in (' + @plano + ')';
			END;

			IF (@tipoEmpresa <> '')
			BEGIN
				SET @SQL = @SQL + ' and e.tp_empresa in (' + @tipoEmpresa + ')';
			END;

			IF (@tipoPagamento <> '')
			BEGIN
				SET @SQL = @SQL + ' and e.cd_tipo_pagamento in (' + @tipoPagamento + ')';
			END;

			--##TIPORECEBIMENTO##
			IF (@tipoRecebimento <> '')
			BEGIN
				SET @SQL
				= @SQL
				+ 'and (select count(0)                                 
							from mensalidades_planos t1000,                     
								 mensalidades t2000                             
							where t1000.cd_sequencial_dep = l.cd_sequencial_dep 
							and t2000.cd_parcela = t1000.cd_parcela_mensalidade 
							and t2000.cd_tipo_recebimento in(' + @tipoRecebimento + ') 
							) > 0 ';
			END;

			IF (@grupoEmpresa > 0)
			BEGIN
				SET @SQL = @SQL + ' and e.cd_grupo = ' + CONVERT(VARCHAR, @grupoEmpresa);
			END;

			IF (@centroCusto > 0)
			BEGIN
				SET @SQL = @SQL + ' and e.cd_centro_custo = ' + CONVERT(VARCHAR, @centroCusto);
			END;

			IF (@situacao <> '')
			BEGIN
				SET @SQL
				= @SQL
				+ ' and (select top 1 cd_situacao from historico where cd_sequencial_dep = d.cd_sequencial order by convert(date,dt_situacao) desc, cd_sequencial desc) in ('
				+ @situacao + ')';
			END;

			IF (@nm_equipe <> '')
			BEGIN
				SET @SQL = @SQL + ' And ev.nm_equipe like''' + @nm_equipe + ''' ';
				SET @SQL = @SQL + ' And f.cd_equipe = ev.cd_equipe ';
			END;
			ELSE
			BEGIN
				SET @SQL = @SQL + ' And f.cd_equipe *= ev.cd_equipe ';
			END;

			IF (@adesionista > 0)
			BEGIN
				SET @SQL = @SQL + ' And d.cd_funcionario_adesionista = ' + CONVERT(VARCHAR, @adesionista);
			END;

			SET @SQL = @SQL + ' group by g.cd_grupo , g.nm_grupo ';
			SET @SQL = @SQL + ' order by 3 desc ';
		END;

		IF @tipo = 5
		BEGIN
			SET @SQL = @SQL + ' select cc.cd_centro_custo, cc.ds_centro_custo, COUNT(0), SUM(l.vl_contrato), ';
			--Qtde Contratos
			SET @SQL = @SQL + ' (Select Count(distinct T400.cd_associado) ';
			SET @SQL
			= @SQL
			+ ' From lote_contratos_contratos_vendedor T100, Dependentes T200 , Funcionario T300 , associados t400, empresa t500, Centro_Custo t600, lote_contratos LC, Equipe_Vendas t900 ';
			SET @SQL = @SQL + ' Where T100.cd_sequencial_dep = T200.cd_sequencial ';
			SET @SQL = @SQL + ' And T200.cd_funcionario_vendedor = T300.cd_funcionario ';
			SET @SQL = @SQL + ' And t200.cd_associado = t400.cd_associado ';
			SET @SQL = @SQL + ' and t400.cd_empresa = t500.cd_empresa ';
			SET @SQL = @SQL + ' and t500.cd_centro_custo = t600.cd_centro_custo ';
			SET @SQL = @SQL + ' and t600.cd_centro_custo = cc.cd_centro_custo ';
			SET @SQL = @SQL + ' and T200.cd_grau_parentesco = 1 ';
			SET @SQL = @SQL + ' and T100.cd_sequencial_lote = LC.cd_sequencial ';

			IF (@ConfigBusca = 1)
			BEGIN
				SET @SQL
				= @SQL + ' And T100.dt_cadastro between ''' + CONVERT(VARCHAR(10), @DT_Inicial, 101) + ''' And '''
				+ CONVERT(VARCHAR(10), @DT_Final, 101) + ' 23:59''';
			END;
			ELSE
			BEGIN
				SET @SQL
				= @SQL + ' And T100.dt_assinaturaContrato between ''' + CONVERT(VARCHAR(10), @DT_Inicial, 101)
				+ ''' And ''' + CONVERT(VARCHAR(10), @DT_Final, 101) + ' 23:59''';
			END;

			IF (@cpfvendedor <> '')
			BEGIN
				SET @SQL = @SQL + ' And T300.nr_cpf = ''' + @cpfvendedor + '''';
			END;

			IF (@equipe > 0)
			BEGIN
				SET @SQL = @SQL + ' And T300.cd_equipe = ' + CONVERT(VARCHAR, @equipe);
			END;

			IF (@vendedor > 0)
			BEGIN
				SET @SQL = @SQL + ' And T300.cd_funcionario = ' + CONVERT(VARCHAR, @vendedor);
			END;

			IF (@chefe > 0)
			BEGIN
				SET @SQL
				= @SQL + ' and T300.cd_equipe in (select eq.cd_equipe from equipe_vendas eq where eq.cd_chefe = '
				+ CONVERT(VARCHAR, @chefe) + ' or cd_chefe1 = ' + CONVERT(VARCHAR, @chefe) + ' or cd_chefe2 = '
				+ CONVERT(VARCHAR, @chefe) + ')';
			END;

			IF (@plano <> '')
			BEGIN
				SET @SQL = @SQL + ' and T200.cd_plano in (' + @plano + ')';
			END;

			IF (@tipoEmpresa <> '')
			BEGIN
				SET @SQL = @SQL + ' and T500.tp_empresa in (' + @tipoEmpresa + ')';
			END;

			IF (@tipoPagamento <> '')
			BEGIN
				SET @SQL = @SQL + ' and T500.cd_tipo_pagamento in (' + @tipoPagamento + ')';
			END;

			--##TIPORECEBIMENTO##
			IF (@tipoRecebimento <> '')
			BEGIN
				SET @SQL
				= @SQL
				+ 'and (select count(0)                                 
							from mensalidades_planos t1000,                     
								 mensalidades t2000                             
							where t1000.cd_sequencial_dep = t100.cd_sequencial_dep 
							and t2000.cd_parcela = t1000.cd_parcela_mensalidade 
							and t2000.cd_tipo_recebimento in(' + @tipoRecebimento + ') 
							) > 0 ';
			END;

			IF (@grupoEmpresa > 0)
			BEGIN
				SET @SQL = @SQL + ' and T500.cd_grupo = ' + CONVERT(VARCHAR, @grupoEmpresa);
			END;

			IF (@centroCusto > 0)
			BEGIN
				SET @SQL = @SQL + ' and T500.cd_centro_custo = ' + CONVERT(VARCHAR, @centroCusto);
			END;

			IF (@situacao <> '')
			BEGIN
				SET @SQL
				= @SQL
				+ ' and (select top 1 cd_situacao from historico where cd_sequencial_dep = T200.cd_sequencial order by convert(date,dt_situacao) desc, cd_sequencial desc) in ('
				+ @situacao + ')';
			END;

			IF (@nm_equipe <> '')
			BEGIN
				SET @SQL = @SQL + ' And t900.nm_equipe like''' + @nm_equipe + ''' ';
				SET @SQL = @SQL + ' And T300.cd_equipe = t900.cd_equipe ';
			END;
			ELSE
			BEGIN
				SET @SQL = @SQL + ' And T300.cd_equipe *= t900.cd_equipe ';
			END;

			IF (@adesionista > 0)
			BEGIN
				SET @SQL = @SQL + ' AND T200.cd_funcionario_adesionista = ' + CONVERT(VARCHAR, @adesionista);
			END;

			SET @SQL = @SQL + ' ) As contratos ';
			--Valor total
			SET @SQL = @SQL + ' , (Select SUM(isnull(T100.vl_contrato,0)) ';
			SET @SQL
			= @SQL
			+ ' From lote_contratos_contratos_vendedor T100, Dependentes T200 , Funcionario T300 , associados t400, empresa t500, Centro_Custo t600, lote_contratos LC, Equipe_Vendas t900 ';
			SET @SQL = @SQL + ' Where T100.cd_sequencial_dep = T200.cd_sequencial ';
			SET @SQL = @SQL + ' And T200.cd_funcionario_vendedor = T300.cd_funcionario ';
			SET @SQL = @SQL + ' And t200.cd_associado = t400.cd_associado ';
			SET @SQL = @SQL + ' and t400.cd_empresa = t500.cd_empresa ';
			SET @SQL = @SQL + ' and t500.cd_centro_custo = t600.cd_centro_custo ';
			SET @SQL = @SQL + ' and T100.cd_sequencial_lote = LC.cd_sequencial ';

			IF (@ConfigBusca = 1)
			BEGIN
				SET @SQL
				= @SQL + ' And T100.dt_cadastro between ''' + CONVERT(VARCHAR(10), @DT_Inicial, 101) + ''' And '''
				+ CONVERT(VARCHAR(10), @DT_Final, 101) + ' 23:59''';
			END;
			ELSE
			BEGIN
				SET @SQL
				= @SQL + ' And T100.dt_assinaturaContrato between ''' + CONVERT(VARCHAR(10), @DT_Inicial, 101)
				+ ''' And ''' + CONVERT(VARCHAR(10), @DT_Final, 101) + ' 23:59''';
			END;

			IF (@cpfvendedor <> '')
			BEGIN
				SET @SQL = @SQL + ' And T300.nr_cpf = ''' + @cpfvendedor + '''';
			END;

			IF (@equipe > 0)
			BEGIN
				SET @SQL = @SQL + ' And T300.cd_equipe = ' + CONVERT(VARCHAR, @equipe);
			END;

			IF (@vendedor > 0)
			BEGIN
				SET @SQL = @SQL + ' And T300.cd_funcionario = ' + CONVERT(VARCHAR, @vendedor);
			END;

			IF (@chefe > 0)
			BEGIN
				--SET @SQL = @SQL + ' and case when LC.cd_empresa is null then isnull(LC.cd_equipe,T300.cd_equipe) else T300.cd_equipe end in (select eq.cd_equipe from equipe_vendas eq where eq.cd_chefe = ' + convert(VARCHAR, @chefe) + ' or cd_chefe1 = ' + convert(VARCHAR, @chefe) + ' or cd_chefe2 = ' + convert(VARCHAR, @chefe) + ')'
				SET @SQL
				= @SQL + ' and T300.cd_equipe in (select eq.cd_equipe from equipe_vendas eq where eq.cd_chefe = '
				+ CONVERT(VARCHAR, @chefe) + ' or cd_chefe1 = ' + CONVERT(VARCHAR, @chefe) + ' or cd_chefe2 = '
				+ CONVERT(VARCHAR, @chefe) + ')';
			END;

			IF (@plano <> '')
			BEGIN
				SET @SQL = @SQL + ' and T200.cd_plano in (' + @plano + ')';
			END;

			IF (@tipoEmpresa <> '')
			BEGIN
				SET @SQL = @SQL + ' and T500.tp_empresa in (' + @tipoEmpresa + ')';
			END;

			IF (@tipoPagamento <> '')
			BEGIN
				SET @SQL = @SQL + ' and T500.cd_tipo_pagamento in (' + @tipoPagamento + ')';
			END;

			--##TIPORECEBIMENTO##
			IF (@tipoRecebimento <> '')
			BEGIN
				SET @SQL
				= @SQL
				+ 'and (select count(0)                                 
							from mensalidades_planos t1000,                     
								 mensalidades t2000                             
							where t1000.cd_sequencial_dep = t100.cd_sequencial_dep 
							and t2000.cd_parcela = t1000.cd_parcela_mensalidade 
							and t2000.cd_tipo_recebimento in(' + @tipoRecebimento + ') 
							) > 0 ';
			END;

			IF (@grupoEmpresa > 0)
			BEGIN
				SET @SQL = @SQL + ' and T500.cd_grupo = ' + CONVERT(VARCHAR, @grupoEmpresa);
			END;

			IF (@centroCusto > 0)
			BEGIN
				SET @SQL = @SQL + ' and T500.cd_centro_custo = ' + CONVERT(VARCHAR, @centroCusto);
			END;

			IF (@situacao <> '')
			BEGIN
				SET @SQL
				= @SQL
				+ ' and (select top 1 cd_situacao from historico where cd_sequencial_dep = T200.cd_sequencial order by convert(date,dt_situacao) desc, cd_sequencial desc) in ('
				+ @situacao + ')';
			END;

			IF (@nm_equipe <> '')
			BEGIN
				SET @SQL = @SQL + ' And t900.nm_equipe like''' + @nm_equipe + ''' ';
				SET @SQL = @SQL + ' And T300.cd_equipe = t900.cd_equipe ';
			END;
			ELSE
			BEGIN
				SET @SQL = @SQL + ' And T300.cd_equipe *= t900.cd_equipe ';
			END;

			IF (@adesionista > 0)
			BEGIN
				SET @SQL = @SQL + ' AND T200.cd_funcionario_adesionista = ' + CONVERT(VARCHAR, @adesionista);
			END;

			SET @SQL = @SQL + ' ) As vl_total ';
			SET @SQL
			= @SQL
			+ ' from funcionario f, lote_contratos_contratos_vendedor as l, DEPENDENTES as d, ASSOCIADOS as a, PLANOS as p, EMPRESA as e, Centro_Custo as cc, lote_contratos LC, uf, municipio mu, Equipe_Vendas ev ';

			IF (@ConfigBusca = 1)
			BEGIN
				SET @SQL
				= @SQL + ' where l.dt_cadastro between ''' + CONVERT(VARCHAR(10), @DT_Inicial, 101) + ''' And '''
				+ CONVERT(VARCHAR(10), @DT_Final, 101) + ' 23:59'' and ';
			END;
			ELSE
			BEGIN
				SET @SQL
				= @SQL + ' where l.dt_assinaturaContrato between ''' + CONVERT(VARCHAR(10), @DT_Inicial, 101)
				+ ''' And ''' + CONVERT(VARCHAR(10), @DT_Final, 101) + ' 23:59'' and ';
			END;

			SET @SQL = @SQL + ' l.cd_sequencial_dep = d.CD_SEQUENCIAL ';
			SET @SQL = @SQL + ' and d.cd_plano = p.cd_plano ';
			SET @SQL = @SQL + ' and d.CD_ASSOCIADO = a.cd_associado ';
			SET @SQL = @SQL + ' and a.cd_empresa = e.CD_EMPRESA ';
			SET @SQL = @SQL + ' and e.cd_centro_custo = cc.cd_centro_custo ';
			SET @SQL = @SQL + ' and f.cd_funcionario *= d.cd_funcionario_vendedor ';
			SET @SQL = @SQL + ' and l.cd_sequencial_lote = LC.cd_sequencial ';

			IF (@uf <> -1)
			BEGIN
				SET @SQL = @SQL + ' and a.ufid = uf.ufid ';
				SET @SQL = @SQL + ' and uf.ufid = ' + CONVERT(VARCHAR, @uf) + '';
			END;
			ELSE
			BEGIN
				SET @SQL = @SQL + ' and a.ufid *= uf.ufid ';
			END;

			IF (@municipio <> -1)
			BEGIN
				SET @SQL = @SQL + ' and a.cidid = mu.cd_municipio ';
				SET @SQL = @SQL + ' And mu.cd_municipio = ' + CONVERT(VARCHAR, @municipio);
			END;
			ELSE
			BEGIN
				SET @SQL = @SQL + ' and a.cidid *= mu.cd_municipio ';
			END;

			IF (@cpfvendedor <> '')
			BEGIN
				SET @SQL = @SQL + ' And f.nr_cpf = ''' + @cpfvendedor + '''';
			END;

			IF (@equipe > 0)
			BEGIN
				--SET @SQL = @SQL + ' And case when LC.cd_empresa is null then isnull(LC.cd_equipe,f.cd_equipe) else f.cd_equipe end = ' + convert(VARCHAR, @equipe)
				SET @SQL = @SQL + ' And f.cd_equipe = ' + CONVERT(VARCHAR, @equipe);
			END;

			IF (@vendedor > 0)
			BEGIN
				SET @SQL = @SQL + ' and d.cd_funcionario_vendedor = ' + CONVERT(VARCHAR, @vendedor);
			END;

			IF (@chefe > 0)
			BEGIN
				--SET @SQL = @SQL + ' and case when LC.cd_empresa is null then isnull(LC.cd_equipe,f.cd_equipe) else f.cd_equipe end in (select eq.cd_equipe from equipe_vendas eq where eq.cd_chefe = ' + convert(VARCHAR, @chefe) + ' or cd_chefe1 = ' + convert(VARCHAR, @chefe) + ' or cd_chefe2 = ' + convert(VARCHAR, @chefe) + ')'
				SET @SQL
				= @SQL + ' and f.cd_equipe in (select eq.cd_equipe from equipe_vendas eq where eq.cd_chefe = '
				+ CONVERT(VARCHAR, @chefe) + ' or cd_chefe1 = ' + CONVERT(VARCHAR, @chefe) + ' or cd_chefe2 = '
				+ CONVERT(VARCHAR, @chefe) + ')';
			END;

			IF (@plano <> '')
			BEGIN
				SET @SQL = @SQL + ' and d.cd_plano in (' + @plano + ')';
			END;

			IF (@tipoEmpresa <> '')
			BEGIN
				SET @SQL = @SQL + ' and e.tp_empresa in (' + @tipoEmpresa + ')';
			END;

			IF (@tipoPagamento <> '')
			BEGIN
				SET @SQL = @SQL + ' and e.cd_tipo_pagamento in (' + @tipoPagamento + ')';
			END;

			--##TIPORECEBIMENTO##
			IF (@tipoRecebimento <> '')
			BEGIN
				SET @SQL
				= @SQL
				+ 'and (select count(0)                                 
							from mensalidades_planos t1000,                     
								 mensalidades t2000                             
							where t1000.cd_sequencial_dep = l.cd_sequencial_dep 
							and t2000.cd_parcela = t1000.cd_parcela_mensalidade 
							and t2000.cd_tipo_recebimento in(' + @tipoRecebimento + ') 
							) > 0 ';
			END;

			IF (@grupoEmpresa > 0)
			BEGIN
				SET @SQL = @SQL + ' and e.cd_grupo = ' + CONVERT(VARCHAR, @grupoEmpresa);
			END;

			IF (@centroCusto > 0)
			BEGIN
				SET @SQL = @SQL + ' and e.cd_centro_custo = ' + CONVERT(VARCHAR, @centroCusto);
			END;

			IF (@situacao <> '')
			BEGIN
				SET @SQL
				= @SQL
				+ ' and (select top 1 cd_situacao from historico where cd_sequencial_dep = d.cd_sequencial order by convert(date,dt_situacao) desc, cd_sequencial desc) in ('
				+ @situacao + ')';
			END;

			IF (@nm_equipe <> '')
			BEGIN
				SET @SQL = @SQL + ' And ev.nm_equipe like''' + @nm_equipe + ''' ';
				SET @SQL = @SQL + ' And f.cd_equipe = ev.cd_equipe ';
			END;
			ELSE
			BEGIN
				SET @SQL = @SQL + ' And f.cd_equipe *= ev.cd_equipe ';
			END;

			IF (@adesionista > 0)
			BEGIN
				SET @SQL = @SQL + ' And d.cd_funcionario_adesionista = ' + CONVERT(VARCHAR, @adesionista);
			END;

			SET @SQL = @SQL + ' group by cc.cd_centro_custo , cc.ds_centro_custo ';
			SET @SQL = @SQL + ' order by 3 desc ';
		END;
	END;
	ELSE
	BEGIN
		IF @tipo = 1
		BEGIN
			SET @SQL = @SQL + ' Select t1.NM_Equipe,t1.cd_equipe, ';
			--Quantidade de contratos
			SET @SQL = @SQL + ' (Select Count(T100.cd_sequencial_lote) ';
			SET @SQL
			= @SQL
			+ ' From lote_contratos_contratos_vendedor T100, Dependentes T200 , Funcionario T300, associados t400, empresa t500, UF AS uf, municipio AS mu, lote_contratos LC, Equipe_Vendas t900 ';
			SET @SQL
			= @SQL
			+ ' Where T100.cd_sequencial_dep = T200.cd_sequencial And 
	  		T200.cd_funcionario_vendedor = T300.cd_funcionario And 
	  		T100.cd_sequencial_lote = LC.cd_sequencial And
	  		t300.cd_equipe = t1.cd_equipe and
	  		t200.cd_associado = t400.cd_associado And 
	  		t400.cd_empresa = t500.cd_empresa And 
	  		';

			IF (@uf <> -1)
			BEGIN
				SET @SQL = @SQL + ' t400.ufid = uf.ufid And ';
				SET @SQL = @SQL + ' uf.ufid = ' + CONVERT(VARCHAR, @uf) + ' And ';
			END;
			ELSE
			BEGIN
				SET @SQL = @SQL + ' t400.ufid *= uf.ufid And ';
			END;

			IF (@municipio <> -1)
			BEGIN
				SET @SQL = @SQL + ' t400.cidid = mu.cd_municipio And ';
				SET @SQL = @SQL + ' mu.cd_municipio = ' + CONVERT(VARCHAR, @municipio) + ' And ';
			END;
			ELSE
			BEGIN
				SET @SQL = @SQL + ' t400.cidid *= mu.cd_municipio And ';
			END;

			IF (@ConfigBusca = 1)
			BEGIN
				SET @SQL
				= @SQL + ' T100.dt_cadastro between ''' + CONVERT(VARCHAR(10), @DT_Inicial, 101) + ''' And '''
				+ CONVERT(VARCHAR(10), @DT_Final, 101) + ' 23:59''';
			END;
			ELSE
			BEGIN
				SET @SQL
				= @SQL + ' T100.dt_assinaturaContrato between ''' + CONVERT(VARCHAR(10), @DT_Inicial, 101)
				+ ''' And ''' + CONVERT(VARCHAR(10), @DT_Final, 101) + ' 23:59''';
			END;

			IF (@cpfvendedor <> '')
			BEGIN
				SET @SQL = @SQL + ' And T300.nr_cpf = ''' + @cpfvendedor + '''';
			END;

			IF (@equipe > 0)
			BEGIN
				--SET @SQL = @SQL + ' And case when LC.cd_empresa is null then isnull(LC.cd_equipe,T300.cd_equipe) else T300.cd_equipe end = ' + convert(VARCHAR, @equipe)
				SET @SQL = @SQL + ' and T300.cd_equipe = ''' + CONVERT(VARCHAR, @equipe) + '''';
			END;

			IF (@vendedor > 0)
			BEGIN
				SET @SQL = @SQL + ' And T300.cd_funcionario = ' + CONVERT(VARCHAR, @vendedor);
			END;

			IF (@chefe > 0)
			BEGIN
				--SET @SQL = @SQL + ' and case when LC.cd_empresa is null then isnull(LC.cd_equipe,T300.cd_equipe) else T300.cd_equipe end in (select eq.cd_equipe from equipe_vendas eq where eq.cd_chefe = ' + convert(VARCHAR, @chefe) + ' or cd_chefe1 = ' + convert(VARCHAR, @chefe) + ' or cd_chefe2 = ' + convert(VARCHAR, @chefe) + ')'
				SET @SQL
				= @SQL + ' and T300.cd_equipe in (select eq.cd_equipe from equipe_vendas eq where eq.cd_chefe = '
				+ CONVERT(VARCHAR, @chefe) + ' or cd_chefe1 = ' + CONVERT(VARCHAR, @chefe) + ' or cd_chefe2 = '
				+ CONVERT(VARCHAR, @chefe) + ')';
			END;

			IF (@plano <> '')
			BEGIN
				SET @SQL = @SQL + ' and T200.cd_plano in (' + @plano + ')';
			END;

			IF (@tipoEmpresa <> '')
			BEGIN
				SET @SQL = @SQL + ' and T500.tp_empresa in (' + @tipoEmpresa + ')';
			END;

			IF (@tipoPagamento <> '')
			BEGIN
				SET @SQL = @SQL + ' and T500.cd_tipo_pagamento in (' + @tipoPagamento + ')';
			END;

			--##TIPORECEBIMENTO##
			IF (@tipoRecebimento <> '')
			BEGIN
				SET @SQL
				= @SQL
				+ 'and (select count(0)                                 
								from mensalidades_planos t1000,                     
									 mensalidades t2000                             
								where t1000.cd_sequencial_dep = T100.cd_sequencial_dep 
								and t2000.cd_parcela = t1000.cd_parcela_mensalidade 
								and t2000.cd_tipo_recebimento in(' + @tipoRecebimento + ') 
								) > 0 ';
			END;

			IF (@grupoEmpresa > 0)
			BEGIN
				SET @SQL = @SQL + ' and T500.cd_grupo = ' + CONVERT(VARCHAR, @grupoEmpresa);
			END;

			IF (@centroCusto > 0)
			BEGIN
				SET @SQL = @SQL + ' and T500.cd_centro_custo = ' + CONVERT(VARCHAR, @centroCusto);
			END;

			IF (@situacao <> '')
			BEGIN
				SET @SQL
				= @SQL
				+ ' and (select top 1 cd_situacao from historico where cd_sequencial_dep = T200.cd_sequencial order by convert(date,dt_situacao) desc, cd_sequencial desc) in ('
				+ @situacao + ')';
			END;

			IF (@nm_equipe <> '')
			BEGIN
				SET @SQL = @SQL + ' And t900.nm_equipe like ''' + @nm_equipe + ''' ';
				SET @SQL = @SQL + ' And T300.cd_equipe = t900.cd_equipe ';
			END;
			ELSE
			BEGIN
				SET @SQL = @SQL + ' And T300.cd_equipe *= t900.cd_equipe ';
			END;

			IF (@adesionista > 0)
			BEGIN
				SET @SQL = @SQL + ' AND T200.cd_funcionario_adesionista = ' + CONVERT(VARCHAR, @adesionista);
			END;

			SET @SQL = @SQL + ' ) As QuantidadeContrato, ';
			--Soma dos contratos
			SET @SQL = @SQL + ' IsNull((Select Sum(T100.vl_contrato) ';
			SET @SQL
			= @SQL
			+ ' From lote_contratos_contratos_vendedor T100, Dependentes T200 , Funcionario T300, associados t400, empresa t500, UF AS uf, municipio AS mu, lote_contratos LC, Equipe_Vendas t900 ';
			SET @SQL
			= @SQL
			+ ' Where T100.cd_sequencial_dep = T200.cd_sequencial And 
	  		T200.cd_funcionario_vendedor = T300.cd_funcionario And 
	  		T100.cd_sequencial_lote = LC.cd_sequencial And
	  		T300.cd_equipe = T1.cd_equipe And 
	  		t200.cd_associado = t400.cd_associado And 
	  		t400.cd_empresa = t500.cd_empresa And 
	  		';

			IF (@uf <> -1)
			BEGIN
				SET @SQL = @SQL + ' t400.ufid = uf.ufid and ';
				SET @SQL = @SQL + ' uf.ufid = ' + CONVERT(VARCHAR, @uf) + ' And ';
			END;
			ELSE
			BEGIN
				SET @SQL = @SQL + ' t400.ufid *= uf.ufid and ';
			END;

			IF (@municipio <> -1)
			BEGIN
				SET @SQL = @SQL + ' t400.cidid = mu.cd_municipio and ';
				SET @SQL = @SQL + ' mu.cd_municipio = ' + CONVERT(VARCHAR, @municipio) + ' And ';
			END;
			ELSE
			BEGIN
				SET @SQL = @SQL + ' t400.cidid *= mu.cd_municipio and ';
			END;

			IF (@ConfigBusca = 1)
			BEGIN
				SET @SQL
				= @SQL + ' T100.dt_cadastro between ''' + CONVERT(VARCHAR(10), @DT_Inicial, 101) + ''' And '''
				+ CONVERT(VARCHAR(10), @DT_Final, 101) + ' 23:59''';
			END;
			ELSE
			BEGIN
				SET @SQL
				= @SQL + ' T100.dt_assinaturaContrato between ''' + CONVERT(VARCHAR(10), @DT_Inicial, 101)
				+ ''' And ''' + CONVERT(VARCHAR(10), @DT_Final, 101) + ' 23:59''';
			END;

			IF (@cpfvendedor <> '')
			BEGIN
				SET @SQL = @SQL + ' And T300.nr_cpf = ''' + @cpfvendedor + '''';
			END;

			IF (@equipe > 0)
			BEGIN
				--SET @SQL = @SQL + ' And case when LC.cd_empresa is null then isnull(LC.cd_equipe,T300.cd_equipe) else T300.cd_equipe end = ' + convert(VARCHAR, @equipe)
				SET @SQL = @SQL + ' And T300.cd_equipe = ' + CONVERT(VARCHAR, @equipe);
			END;

			IF (@vendedor > 0)
			BEGIN
				SET @SQL = @SQL + ' And T300.cd_funcionario = ' + CONVERT(VARCHAR, @vendedor);
			END;

			IF (@chefe > 0)
			BEGIN
				--SET @SQL = @SQL + ' and case when LC.cd_empresa is null then isnull(LC.cd_equipe,T300.cd_equipe) else T300.cd_equipe end in (select eq.cd_equipe from equipe_vendas eq where eq.cd_chefe = ' + convert(VARCHAR, @chefe) + ' or cd_chefe1 = ' + convert(VARCHAR, @chefe) + ' or cd_chefe2 = ' + convert(VARCHAR, @chefe) + ')'
				SET @SQL
				= @SQL + ' and T300.cd_equipe in (select eq.cd_equipe from equipe_vendas eq where eq.cd_chefe = '
				+ CONVERT(VARCHAR, @chefe) + ' or cd_chefe1 = ' + CONVERT(VARCHAR, @chefe) + ' or cd_chefe2 = '
				+ CONVERT(VARCHAR, @chefe) + ')';
			END;

			IF (@plano <> '')
			BEGIN
				SET @SQL = @SQL + ' and T200.cd_plano in (' + @plano + ')';
			END;

			IF (@tipoEmpresa <> '')
			BEGIN
				SET @SQL = @SQL + ' and T500.tp_empresa in (' + @tipoEmpresa + ')';
			END;

			IF (@tipoPagamento <> '')
			BEGIN
				SET @SQL = @SQL + ' and T500.cd_tipo_pagamento in (' + @tipoPagamento + ')';
			END;

			--##TIPORECEBIMENTO##
			IF (@tipoRecebimento <> '')
			BEGIN
				SET @SQL
				= @SQL
				+ 'and (select count(0)                                 
 								from mensalidades_planos t1000,                     
 									 mensalidades t2000                             
 								where t1000.cd_sequencial_dep = T100.cd_sequencial_dep 
 								and t2000.cd_parcela = t1000.cd_parcela_mensalidade 
 								and t2000.cd_tipo_recebimento in(' + @tipoRecebimento + ') 
 								) > 0 ';
			END;

			IF (@grupoEmpresa > 0)
			BEGIN
				SET @SQL = @SQL + ' and T500.cd_grupo = ' + CONVERT(VARCHAR, @grupoEmpresa);
			END;

			IF (@centroCusto > 0)
			BEGIN
				SET @SQL = @SQL + ' and T500.cd_centro_custo = ' + CONVERT(VARCHAR, @centroCusto);
			END;

			IF (@situacao <> '')
			BEGIN
				SET @SQL
				= @SQL
				+ ' and (select top 1 cd_situacao from historico where cd_sequencial_dep = T200.cd_sequencial order by convert(date,dt_situacao) desc, cd_sequencial desc) in ('
				+ @situacao + ')';
			END;

			IF (@nm_equipe <> '')
			BEGIN
				SET @SQL = @SQL + ' And t900.nm_equipe like''' + @nm_equipe + ''' ';
				SET @SQL = @SQL + ' And T300.cd_equipe = t900.cd_equipe ';
			END;
			ELSE
			BEGIN
				SET @SQL = @SQL + ' And T300.cd_equipe *= t900.cd_equipe ';
			END;

			IF (@adesionista > 0)
			BEGIN
				SET @SQL = @SQL + ' AND T200.cd_funcionario_adesionista = ' + CONVERT(VARCHAR, @adesionista);
			END;

			SET @SQL = @SQL + ' ),0) ';
			SET @SQL = @SQL + ' As ValorContrato, ';
			--Quantidade de vidas dos contratos importados. Associados com situação igual a 6
			SET @SQL = @SQL + ' IsNull((Select Count(T100.cd_sequencial) ';
			SET @SQL
			= @SQL
			+ ' From Dependentes T100, Funcionario T200, Historico T300, associados t400, empresa t500, UF AS uf, municipio AS mu, lote_contratos_contratos_vendedor cv, lote_contratos LC, Equipe_Vendas ev ';
			SET @SQL = @SQL + ' Where T100.cd_funcionario_vendedor = T200.cd_funcionario ';
			SET @SQL = @SQL + ' And T200.cd_equipe = T1.cd_equipe ';
			SET @SQL = @SQL + ' And t100.CD_Sequencial_historico = t300.cd_sequencial ';
			SET @SQL = @SQL + ' And t100.cd_associado = t400.cd_associado ';
			SET @SQL = @SQL + ' And t400.cd_empresa = t500.cd_empresa ';
			SET @SQL
			= @SQL + ' And T300.DT_SITUACAO between ''' + CONVERT(VARCHAR(10), @DT_Inicial, 101) + ''' And '''
			+ CONVERT(VARCHAR(10), @DT_Final, 101) + ' 23:59''';
			SET @SQL = @SQL + ' And T300.cd_situacao = 6 ';
			SET @SQL = @SQL + ' And T100.cd_sequencial = cv.cd_sequencial_dep ';
			SET @SQL = @SQL + ' And cv.cd_sequencial_lote = LC.cd_sequencial ';
			SET @SQL = @SQL + ' And T200.cd_equipe = T1.cd_equipe ';

			IF (@uf <> -1)
			BEGIN
				SET @SQL = @SQL + ' And t400.ufid = uf.ufid ';
				SET @SQL = @SQL + ' And uf.ufid = ' + CONVERT(VARCHAR, @uf);
			END;
			ELSE
			BEGIN
				SET @SQL = @SQL + ' And t400.ufid *= uf.ufid ';
			END;

			IF (@municipio <> -1)
			BEGIN
				SET @SQL = @SQL + ' And t400.cidid = mu.cd_municipio ';
				SET @SQL = @SQL + ' And mu.cd_municipio = ' + CONVERT(VARCHAR, @municipio);
			END;
			ELSE
			BEGIN
				SET @SQL = @SQL + ' And t400.cidid *= mu.cd_municipio ';
			END;

			IF (@cpfvendedor <> '')
			BEGIN
				SET @SQL = @SQL + ' And T200.nr_cpf = ''' + @cpfvendedor + '''';
			END;

			IF (@equipe > 0)
			BEGIN
				SET @SQL = @SQL + ' And T200.cd_equipe = ' + CONVERT(VARCHAR, @equipe);
			END;

			IF (@vendedor > 0)
			BEGIN
				SET @SQL = @SQL + ' And T200.cd_funcionario = ' + CONVERT(VARCHAR, @vendedor);
			END;

			IF (@plano <> '')
			BEGIN
				SET @SQL = @SQL + ' and T100.cd_plano in (' + @plano + ')';
			END;

			IF (@tipoEmpresa <> '')
			BEGIN
				SET @SQL = @SQL + ' and T500.tp_empresa in (' + @tipoEmpresa + ')';
			END;

			IF (@tipoPagamento <> '')
			BEGIN
				SET @SQL = @SQL + ' and T500.cd_tipo_pagamento in (' + @tipoPagamento + ')';
			END;

			--##TIPORECEBIMENTO##
			IF (@tipoRecebimento <> '')
			BEGIN
				SET @SQL
				= @SQL
				+ 'and (select count(0)                                 
 								from mensalidades_planos t1000,                     
 									 mensalidades t2000                             
 								where t1000.cd_sequencial_dep = cv.cd_sequencial_dep 
 								and t2000.cd_parcela = t1000.cd_parcela_mensalidade 
 								and t2000.cd_tipo_recebimento in(' + @tipoRecebimento + ') 
 								) > 0 ';
			END;

			IF (@grupoEmpresa > 0)
			BEGIN
				SET @SQL = @SQL + ' and T500.cd_grupo = ' + CONVERT(VARCHAR, @grupoEmpresa);
			END;

			IF (@centroCusto > 0)
			BEGIN
				SET @SQL = @SQL + ' and T500.cd_centro_custo = ' + CONVERT(VARCHAR, @centroCusto);
			END;

			IF (@situacao <> '')
			BEGIN
				SET @SQL
				= @SQL
				+ ' and (select top 1 cd_situacao from historico where cd_sequencial_dep = T100.cd_sequencial order by convert(date,dt_situacao) desc, cd_sequencial desc) in ('
				+ @situacao + ')';
			END;

			IF (@nm_equipe <> '')
			BEGIN
				SET @SQL = @SQL + ' And ev.nm_equipe like ''' + @nm_equipe + ''' ';
				SET @SQL = @SQL + ' And T200.cd_equipe = ev.cd_equipe ';
			END;
			ELSE
			BEGIN
				SET @SQL = @SQL + ' And T200.cd_equipe *= ev.cd_equipe ';
			END;

			IF (@adesionista > 0)
			BEGIN
				SET @SQL = @SQL + ' AND T100.cd_funcionario_adesionista = ' + CONVERT(VARCHAR, @adesionista);
			END;

			SET @SQL = @SQL + ' ),0) ';
			SET @SQL = @SQL + ' As QuantidadeImportado, ';
			--Soma de vidas dos contratos importados. Associados com situação igual a 6
			SET @SQL = @SQL + ' IsNull((Select Sum(T100.vl_plano) ';
			SET @SQL
			= @SQL
			+ ' From Dependentes T100, Funcionario T200, Historico T300, associados t400, empresa t500, UF AS uf, municipio AS mu, lote_contratos_contratos_vendedor cv, lote_contratos LC, Equipe_Vendas ev ';
			SET @SQL = @SQL + ' Where T100.cd_funcionario_vendedor = T200.cd_funcionario ';
			SET @SQL = @SQL + ' And T200.cd_equipe = T1.cd_equipe ';
			SET @SQL = @SQL + ' And t100.CD_Sequencial_historico = t300.cd_sequencial ';
			SET @SQL = @SQL + ' And t100.cd_associado = t400.cd_associado ';
			SET @SQL = @SQL + ' And t400.cd_empresa = t500.cd_empresa ';
			SET @SQL
			= @SQL + ' And T300.DT_SITUACAO between ''' + CONVERT(VARCHAR(10), @DT_Inicial, 101) + ''' And '''
			+ CONVERT(VARCHAR(10), @DT_Final, 101) + ' 23:59''';
			SET @SQL = @SQL + ' And T300.cd_situacao = 6 ';
			SET @SQL = @SQL + ' And T100.cd_sequencial = cv.cd_sequencial_dep ';
			SET @SQL = @SQL + ' And cv.cd_sequencial_lote = LC.cd_sequencial ';
			SET @SQL = @SQL + ' And T200.cd_equipe = T1.cd_equipe ';

			IF (@uf <> -1)
			BEGIN
				SET @SQL = @SQL + ' And t400.ufid = uf.ufid ';
				SET @SQL = @SQL + ' And uf.ufid = ' + CONVERT(VARCHAR, @uf);
			END;
			ELSE
			BEGIN
				SET @SQL = @SQL + ' And t400.ufid *= uf.ufid ';
			END;

			IF (@municipio <> -1)
			BEGIN
				SET @SQL = @SQL + ' And t400.cidid = mu.cd_municipio ';
				SET @SQL = @SQL + ' And mu.cd_municipio = ' + CONVERT(VARCHAR, @municipio);
			END;
			ELSE
			BEGIN
				SET @SQL = @SQL + ' And t400.cidid *= mu.cd_municipio ';
			END;

			IF (@cpfvendedor <> '')
			BEGIN
				SET @SQL = @SQL + ' And T200.nr_cpf = ''' + @cpfvendedor + '''';
			END;

			IF (@equipe > 0)
			BEGIN
				SET @SQL = @SQL + ' And T200.cd_equipe = ' + CONVERT(VARCHAR, @equipe);
			END;

			IF (@vendedor > 0)
			BEGIN
				SET @SQL = @SQL + ' And T200.cd_funcionario = ' + CONVERT(VARCHAR, @vendedor);
			END;

			IF (@plano <> '')
			BEGIN
				SET @SQL = @SQL + ' and T100.cd_plano in (' + @plano + ')';
			END;

			IF (@tipoEmpresa <> '')
			BEGIN
				SET @SQL = @SQL + ' and T500.tp_empresa in (' + @tipoEmpresa + ')';
			END;

			IF (@tipoPagamento <> '')
			BEGIN
				SET @SQL = @SQL + ' and T500.cd_tipo_pagamento in (' + @tipoPagamento + ')';
			END;

			--##TIPORECEBIMENTO##
			IF (@tipoRecebimento <> '')
			BEGIN
				SET @SQL
				= @SQL
				+ 'and (select count(0)                                 
 								from mensalidades_planos t1000,                     
 									 mensalidades t2000                             
 								where t1000.cd_sequencial_dep = cv.cd_sequencial_dep 
 								and t2000.cd_parcela = t1000.cd_parcela_mensalidade 
 								and t2000.cd_tipo_recebimento in(' + @tipoRecebimento + ') 
 								) > 0 ';
			END;

			IF (@grupoEmpresa > 0)
			BEGIN
				SET @SQL = @SQL + ' and T500.cd_grupo = ' + CONVERT(VARCHAR, @grupoEmpresa);
			END;

			IF (@centroCusto > 0)
			BEGIN
				SET @SQL = @SQL + ' and T500.cd_centro_custo = ' + CONVERT(VARCHAR, @centroCusto);
			END;

			IF (@situacao <> '')
			BEGIN
				SET @SQL
				= @SQL
				+ ' and (select top 1 cd_situacao from historico where cd_sequencial_dep = T100.cd_sequencial order by convert(date,dt_situacao) desc, cd_sequencial desc) in ('
				+ @situacao + ')';
			END;

			IF (@nm_equipe <> '')
			BEGIN
				SET @SQL = @SQL + ' And ev.nm_equipe like ''' + @nm_equipe + ''' ';
				SET @SQL = @SQL + ' And T200.cd_equipe = ev.cd_equipe ';
			END;
			ELSE
			BEGIN
				SET @SQL = @SQL + ' And T200.cd_equipe *= ev.cd_equipe ';
			END;

			IF (@adesionista > 0)
			BEGIN
				SET @SQL = @SQL + ' AND T100.cd_funcionario_adesionista = ' + CONVERT(VARCHAR, @adesionista);
			END;

			SET @SQL = @SQL + ' ),0) ';
			SET @SQL = @SQL + ' As ValorImportado, ';
			--Quantidade de vidas dos contratos cancelados
			SET @SQL = @SQL + ' IsNull((Select Count(T100.cd_sequencial) ';
			SET @SQL
			= @SQL
			+ ' From Dependentes T100, Funcionario T200, Historico T300 , ASSOCIADOS t400, empresa t500, UF AS uf, municipio AS mu, lote_contratos_contratos_vendedor cv, lote_contratos LC, Equipe_Vendas ev ';
			SET @SQL = @SQL + ' Where T100.cd_funcionario_vendedor = T200.cd_funcionario ';
			SET @SQL = @SQL + ' And T200.cd_equipe = T1.cd_equipe ';
			SET @SQL = @SQL + ' And t100.CD_Sequencial_historico = t300.cd_sequencial ';
			SET @SQL
			= @SQL + ' And T300.DT_SITUACAO between ''' + CONVERT(VARCHAR(10), @DT_Inicial, 101) + ''' And '''
			+ CONVERT(VARCHAR(10), @DT_Final, 101) + ' 23:59''';
			SET @SQL = @SQL + ' And T100.CD_ASSOCIADO = t400.cd_associado ';
			SET @SQL = @SQL + ' And t400.cd_empresa = t500.CD_EMPRESA ';
			SET @SQL = @SQL + ' And t500.TP_EMPRESA<10 ';
			SET @SQL = @SQL + ' And T300.cd_situacao in (2) ';
			SET @SQL = @SQL + ' And T100.cd_sequencial = cv.cd_sequencial_dep ';
			SET @SQL = @SQL + ' And cv.cd_sequencial_lote = LC.cd_sequencial ';
			SET @SQL = @SQL + ' And T200.cd_equipe = T1.cd_equipe ';

			IF (@uf <> -1)
			BEGIN
				SET @SQL = @SQL + ' And t400.ufid = uf.ufid ';
				SET @SQL = @SQL + ' And uf.ufid = ' + CONVERT(VARCHAR, @uf);
			END;
			ELSE
			BEGIN
				SET @SQL = @SQL + ' And t400.ufid *= uf.ufid ';
			END;

			IF (@municipio <> -1)
			BEGIN
				SET @SQL = @SQL + ' And t400.cidid = mu.cd_municipio ';
				SET @SQL = @SQL + ' And mu.cd_municipio = ' + CONVERT(VARCHAR, @municipio);
			END;
			ELSE
			BEGIN
				SET @SQL = @SQL + ' And t400.cidid *= mu.cd_municipio ';
			END;

			IF (@cpfvendedor <> '')
			BEGIN
				SET @SQL = @SQL + ' And T200.nr_cpf = ''' + @cpfvendedor + '''';
			END;

			IF (@equipe > 0)
			BEGIN
				SET @SQL = @SQL + ' And T200.cd_equipe = ' + CONVERT(VARCHAR, @equipe);
			END;

			IF (@vendedor > 0)
			BEGIN
				SET @SQL = @SQL + ' And T200.cd_funcionario = ' + CONVERT(VARCHAR, @vendedor);
			END;

			IF (@plano <> '')
			BEGIN
				SET @SQL = @SQL + ' and T100.cd_plano in (' + @plano + ')';
			END;

			IF (@tipoEmpresa <> '')
			BEGIN
				SET @SQL = @SQL + ' and T500.tp_empresa in (' + @tipoEmpresa + ')';
			END;

			IF (@tipoPagamento <> '')
			BEGIN
				SET @SQL = @SQL + ' and T500.cd_tipo_pagamento in (' + @tipoPagamento + ')';
			END;

			--##TIPORECEBIMENTO##
			IF (@tipoRecebimento <> '')
			BEGIN
				SET @SQL
				= @SQL
				+ 'and (select count(0)                                 
 								from mensalidades_planos t1000,                     
 									 mensalidades t2000                             
 								where t1000.cd_sequencial_dep = cv.cd_sequencial_dep 
 								and t2000.cd_parcela = t1000.cd_parcela_mensalidade 
 								and t2000.cd_tipo_recebimento in(' + @tipoRecebimento + ') 
 								) > 0 ';
			END;

			IF (@grupoEmpresa > 0)
			BEGIN
				SET @SQL = @SQL + ' and T500.cd_grupo = ' + CONVERT(VARCHAR, @grupoEmpresa);
			END;

			IF (@centroCusto > 0)
			BEGIN
				SET @SQL = @SQL + ' and T500.cd_centro_custo = ' + CONVERT(VARCHAR, @centroCusto);
			END;

			IF (@situacao <> '')
			BEGIN
				SET @SQL
				= @SQL
				+ ' and (select top 1 cd_situacao from historico where cd_sequencial_dep = T100.cd_sequencial order by convert(date,dt_situacao) desc, cd_sequencial desc) in ('
				+ @situacao + ')';
			END;

			IF (@nm_equipe <> '')
			BEGIN
				SET @SQL = @SQL + ' And ev.nm_equipe like ''' + @nm_equipe + ''' ';
				SET @SQL = @SQL + ' And T200.cd_equipe = ev.cd_equipe ';
			END;
			ELSE
			BEGIN
				SET @SQL = @SQL + ' And T200.cd_equipe *= ev.cd_equipe ';
			END;

			IF (@adesionista > 0)
			BEGIN
				SET @SQL = @SQL + ' AND T100.cd_funcionario_adesionista = ' + CONVERT(VARCHAR, @adesionista);
			END;

			SET @SQL = @SQL + ' ),0) ';
			SET @SQL = @SQL + ' As QuantidadeCancelado, ';
			--Soma de contratos cancelados
			SET @SQL = @SQL + ' IsNull((Select Sum(T100.vl_plano) ';
			SET @SQL
			= @SQL
			+ ' From Dependentes T100, Funcionario T200, Historico T300 , ASSOCIADOS t400, empresa t500, UF AS uf, municipio AS mu, lote_contratos_contratos_vendedor cv, lote_contratos LC, Equipe_Vendas ev ';
			SET @SQL = @SQL + ' Where T100.cd_funcionario_vendedor = T200.cd_funcionario ';
			SET @SQL = @SQL + ' And T200.cd_equipe = T1.cd_equipe ';
			SET @SQL
			= @SQL + ' And T300.DT_SITUACAO between ''' + CONVERT(VARCHAR(10), @DT_Inicial, 101) + ''' And '''
			+ CONVERT(VARCHAR(10), @DT_Final, 101) + ' 23:59''';
			SET @SQL = @SQL + ' And t100.CD_Sequencial_historico = t300.cd_sequencial ';
			SET @SQL = @SQL + ' and T100.CD_ASSOCIADO = t400.cd_associado ';
			SET @SQL = @SQL + ' and t400.cd_empresa = t500.CD_EMPRESA ';
			SET @SQL = @SQL + ' and t500.TP_EMPRESA<10 ';
			SET @SQL = @SQL + ' And T300.cd_situacao in (2) ';
			SET @SQL = @SQL + ' And T100.cd_sequencial = cv.cd_sequencial_dep ';
			SET @SQL = @SQL + ' And cv.cd_sequencial_lote = LC.cd_sequencial ';
			SET @SQL = @SQL + ' And T200.cd_equipe = T1.cd_equipe ';

			IF (@uf <> -1)
			BEGIN
				SET @SQL = @SQL + ' And t400.ufid = uf.ufid ';
				SET @SQL = @SQL + ' And uf.ufid = ' + CONVERT(VARCHAR, @uf);
			END;
			ELSE
			BEGIN
				SET @SQL = @SQL + ' And t400.ufid *= uf.ufid ';
			END;

			IF (@municipio <> -1)
			BEGIN
				SET @SQL = @SQL + ' And t400.cidid = mu.cd_municipio ';
				SET @SQL = @SQL + ' And mu.cd_municipio = ' + CONVERT(VARCHAR, @municipio);
			END;
			ELSE
			BEGIN
				SET @SQL = @SQL + ' And t400.cidid *= mu.cd_municipio ';
			END;

			IF (@cpfvendedor <> '')
			BEGIN
				SET @SQL = @SQL + ' And T200.nr_cpf = ''' + @cpfvendedor + '''';
			END;

			IF (@equipe > 0)
			BEGIN
				SET @SQL = @SQL + ' And T200.cd_equipe = ' + CONVERT(VARCHAR, @equipe);
			END;

			IF (@vendedor > 0)
			BEGIN
				SET @SQL = @SQL + ' And T200.cd_funcionario = ' + CONVERT(VARCHAR, @vendedor);
			END;

			IF (@plano <> '')
			BEGIN
				SET @SQL = @SQL + ' and T100.cd_plano in (' + @plano + ')';
			END;

			IF (@tipoEmpresa <> '')
			BEGIN
				SET @SQL = @SQL + ' and T500.tp_empresa in (' + @tipoEmpresa + ')';
			END;

			IF (@tipoPagamento <> '')
			BEGIN
				SET @SQL = @SQL + ' and T500.cd_tipo_pagamento in (' + @tipoPagamento + ')';
			END;

			--##TIPORECEBIMENTO##
			IF (@tipoRecebimento <> '')
			BEGIN
				SET @SQL
				= @SQL
				+ 'and (select count(0)                                 
 								from mensalidades_planos t1000,                     
 									 mensalidades t2000                             
 								where t1000.cd_sequencial_dep = cv.cd_sequencial_dep 
 								and t2000.cd_parcela = t1000.cd_parcela_mensalidade 
 								and t2000.cd_tipo_recebimento in(' + @tipoRecebimento + ') 
 								) > 0 ';
			END;

			IF (@grupoEmpresa > 0)
			BEGIN
				SET @SQL = @SQL + ' and T500.cd_grupo = ' + CONVERT(VARCHAR, @grupoEmpresa);
			END;

			IF (@centroCusto > 0)
			BEGIN
				SET @SQL = @SQL + ' and T500.cd_centro_custo = ' + CONVERT(VARCHAR, @centroCusto);
			END;

			IF (@situacao <> '')
			BEGIN
				SET @SQL
				= @SQL
				+ ' and (select top 1 cd_situacao from historico where cd_sequencial_dep = T100.cd_sequencial order by convert(date,dt_situacao) desc, cd_sequencial desc) in ('
				+ @situacao + ')';
			END;

			IF (@nm_equipe <> '')
			BEGIN
				SET @SQL = @SQL + ' And ev.nm_equipe like ''' + @nm_equipe + ''' ';
				SET @SQL = @SQL + ' And T200.cd_equipe = ev.cd_equipe ';
			END;
			ELSE
			BEGIN
				SET @SQL = @SQL + ' And T200.cd_equipe *= ev.cd_equipe ';
			END;

			IF (@adesionista > 0)
			BEGIN
				SET @SQL = @SQL + ' AND T100.cd_funcionario_adesionista = ' + CONVERT(VARCHAR, @adesionista);
			END;

			SET @SQL = @SQL + ' ),0) ';
			SET @SQL = @SQL + ' As ValorCancelado, ';
			SET @SQL = @SQL + ' (Select Count(distinct T400.cd_associado) ';
			SET @SQL
			= @SQL
			+ ' From lote_contratos_contratos_vendedor T100, Dependentes T200 , Funcionario T300, associados t400, empresa t500 , UF AS uf, municipio AS mu, lote_contratos LC, Equipe_Vendas t900 ';
			SET @SQL
			= @SQL
			+ ' Where T100.cd_sequencial_dep = T200.cd_sequencial And 
	  		T200.cd_funcionario_vendedor = T300.cd_funcionario And 
	  		t200.cd_associado = t400.cd_associado And 
	  		t400.cd_empresa = t500.cd_empresa And 
	  		T100.cd_sequencial_lote = LC.cd_sequencial And 
	  		T300.cd_equipe = T1.cd_equipe And 
	  		T200.cd_grau_parentesco = 1 And ';

			IF (@uf <> -1)
			BEGIN
				SET @SQL = @SQL + ' t400.ufid = uf.ufid And ';
				SET @SQL = @SQL + ' uf.ufid = ' + CONVERT(VARCHAR, @uf) + ' And ';
			END;
			ELSE
			BEGIN
				SET @SQL = @SQL + ' t400.ufid *= uf.ufid And ';
			END;

			IF (@municipio <> -1)
			BEGIN
				SET @SQL = @SQL + ' t400.cidid = mu.cd_municipio And ';
				SET @SQL = @SQL + ' mu.cd_municipio = ' + CONVERT(VARCHAR, @municipio) + ' And';
			END;
			ELSE
			BEGIN
				SET @SQL = @SQL + ' t400.cidid *= mu.cd_municipio And ';
			END;

			IF (@ConfigBusca = 1)
			BEGIN
				SET @SQL
				= @SQL + ' T100.dt_cadastro between ''' + CONVERT(VARCHAR(10), @DT_Inicial, 101) + ''' And '''
				+ CONVERT(VARCHAR(10), @DT_Final, 101) + ' 23:59''';
			END;
			ELSE
			BEGIN
				SET @SQL
				= @SQL + ' T100.dt_assinaturaContrato between ''' + CONVERT(VARCHAR(10), @DT_Inicial, 101)
				+ ''' And ''' + CONVERT(VARCHAR(10), @DT_Final, 101) + ' 23:59''';
			END;

			IF (@cpfvendedor <> '')
			BEGIN
				SET @SQL = @SQL + ' And T300.nr_cpf = ''' + @cpfvendedor + '''';
			END;

			IF (@equipe > 0)
			BEGIN
				--SET @SQL = @SQL + ' And case when LC.cd_empresa is null then isnull(LC.cd_equipe,T300.cd_equipe) else T300.cd_equipe end = ' + convert(VARCHAR, @equipe)
				SET @SQL = @SQL + ' And T300.cd_equipe = ' + CONVERT(VARCHAR, @equipe);
			END;

			IF (@vendedor > 0)
			BEGIN
				SET @SQL = @SQL + ' And T300.cd_funcionario = ' + CONVERT(VARCHAR, @vendedor);
			END;

			IF (@chefe > 0)
			BEGIN
				--SET @SQL = @SQL + ' and case when LC.cd_empresa is null then isnull(LC.cd_equipe,T300.cd_equipe) else T300.cd_equipe end in (select eq.cd_equipe from equipe_vendas eq where eq.cd_chefe = ' + convert(VARCHAR, @chefe) + ' or cd_chefe1 = ' + convert(VARCHAR, @chefe) + ' or cd_chefe2 = ' + convert(VARCHAR, @chefe) + ')'
				SET @SQL
				= @SQL + ' and T300.cd_equipe in (select eq.cd_equipe from equipe_vendas eq where eq.cd_chefe = '
				+ CONVERT(VARCHAR, @chefe) + ' or cd_chefe1 = ' + CONVERT(VARCHAR, @chefe) + ' or cd_chefe2 = '
				+ CONVERT(VARCHAR, @chefe) + ')';
			END;

			IF (@plano <> '')
			BEGIN
				SET @SQL = @SQL + ' and T200.cd_plano in (' + @plano + ')';
			END;

			IF (@tipoEmpresa <> '')
			BEGIN
				SET @SQL = @SQL + ' and T500.tp_empresa in (' + @tipoEmpresa + ')';
			END;

			IF (@tipoPagamento <> '')
			BEGIN
				SET @SQL = @SQL + ' and T500.cd_tipo_pagamento in (' + @tipoPagamento + ')';
			END;

			--##TIPORECEBIMENTO##
			IF (@tipoRecebimento <> '')
			BEGIN
				SET @SQL
				= @SQL
				+ 'and (select count(0)                                 
 								from mensalidades_planos t1000,                     
 									 mensalidades t2000                             
 								where t1000.cd_sequencial_dep = T100.cd_sequencial_dep 
 								and t2000.cd_parcela = t1000.cd_parcela_mensalidade 
 								and t2000.cd_tipo_recebimento in(' + @tipoRecebimento + ') 
 								) > 0 ';
			END;

			IF (@grupoEmpresa > 0)
			BEGIN
				SET @SQL = @SQL + ' and T500.cd_grupo = ' + CONVERT(VARCHAR, @grupoEmpresa);
			END;

			IF (@centroCusto > 0)
			BEGIN
				SET @SQL = @SQL + ' and T500.cd_centro_custo = ' + CONVERT(VARCHAR, @centroCusto);
			END;

			IF (@situacao <> '')
			BEGIN
				SET @SQL
				= @SQL
				+ ' and (select top 1 cd_situacao from historico where cd_sequencial_dep = T200.cd_sequencial order by convert(date,dt_situacao) desc, cd_sequencial desc) in ('
				+ @situacao + ')';
			END;

			IF (@nm_equipe <> '')
			BEGIN
				SET @SQL = @SQL + ' And t900.nm_equipe like''' + @nm_equipe + ''' ';
				SET @SQL = @SQL + ' And T300.cd_equipe = t900.cd_equipe ';
			END;
			ELSE
			BEGIN
				SET @SQL = @SQL + ' And T300.cd_equipe *= t900.cd_equipe ';
			END;

			IF (@adesionista > 0)
			BEGIN
				SET @SQL = @SQL + ' AND T200.cd_funcionario_adesionista = ' + CONVERT(VARCHAR, @adesionista);
			END;

			SET @SQL = @SQL + ' ) As qtde_associados ';
			SET @SQL = @SQL + ' From equipe_vendas T1 ';

			IF (@chefe > 0)
			BEGIN
				SET @SQL
				= @SQL + ' where (T1.cd_chefe = ' + CONVERT(VARCHAR, @chefe) + ' or T1.cd_chefe1 = '
				+ CONVERT(VARCHAR, @chefe) + 'or T1.cd_chefe2 = ' + CONVERT(VARCHAR, @chefe) + ') ';
			END;

			SET @SQL = @SQL + ' Order By 3 desc ';
		END;

		IF @tipo = 2
		BEGIN
			SET @SQL = @SQL + ' select p.cd_plano, p.nm_plano, COUNT(0), SUM(l.vl_contrato), ';
			--Qtde Contratos
			SET @SQL = @SQL + ' (Select Count(distinct T400.cd_associado) ';
			SET @SQL
			= @SQL
			+ ' From lote_contratos_contratos_vendedor T100, Dependentes T200 , Funcionario T300, associados t400, empresa t500, lote_contratos LC, Equipe_Vendas t900 ';
			SET @SQL = @SQL + ' Where T100.cd_sequencial_dep = T200.cd_sequencial And ';
			SET @SQL = @SQL + ' T200.cd_funcionario_vendedor = T300.cd_funcionario And ';
			SET @SQL = @SQL + ' t200.cd_associado = t400.cd_associado And ';
			SET @SQL = @SQL + ' t400.cd_empresa = t500.cd_empresa And ';
			SET @SQL = @SQL + ' t200.cd_plano = p.cd_plano and ';
			SET @SQL = @SQL + ' T200.cd_grau_parentesco = 1 and ';
			SET @SQL = @SQL + ' T100.cd_sequencial_lote = LC.cd_sequencial And ';

			IF (@ConfigBusca = 1)
			BEGIN
				SET @SQL
				= @SQL + ' T100.dt_cadastro between ''' + CONVERT(VARCHAR(10), @DT_Inicial, 101) + ''' And '''
				+ CONVERT(VARCHAR(10), @DT_Final, 101) + ' 23:59''';
			END;
			ELSE
			BEGIN
				SET @SQL
				= @SQL + ' T100.dt_assinaturaContrato between ''' + CONVERT(VARCHAR(10), @DT_Inicial, 101)
				+ ''' And ''' + CONVERT(VARCHAR(10), @DT_Final, 101) + ' 23:59''';
			END;

			IF (@cpfvendedor <> '')
			BEGIN
				SET @SQL = @SQL + ' And T300.nr_cpf = ''' + @cpfvendedor + '''';
			END;

			IF (@equipe > 0)
			BEGIN
				--SET @SQL = @SQL + ' And case when LC.cd_empresa is null then isnull(LC.cd_equipe,T300.cd_equipe) else T300.cd_equipe end = ' + convert(VARCHAR, @equipe)
				SET @SQL = @SQL + ' and T300.cd_equipe = ''' + CONVERT(VARCHAR, @equipe) + '''';
			END;

			IF (@vendedor > 0)
			BEGIN
				SET @SQL = @SQL + ' And T300.cd_funcionario = ' + CONVERT(VARCHAR, @vendedor);
			END;

			IF (@chefe > 0)
			BEGIN
				--SET @SQL = @SQL + ' and case when LC.cd_empresa is null then isnull(LC.cd_equipe,T300.cd_equipe) else T300.cd_equipe end in (select eq.cd_equipe from equipe_vendas eq where eq.cd_chefe = ' + convert(VARCHAR, @chefe) + ' or cd_chefe1 = ' + convert(VARCHAR, @chefe) + ' or cd_chefe2 = ' + convert(VARCHAR, @chefe) + ')'
				SET @SQL
				= @SQL + ' and T300.cd_equipe in (select eq.cd_equipe from equipe_vendas eq where eq.cd_chefe = '
				+ CONVERT(VARCHAR, @chefe) + ' or cd_chefe1 = ' + CONVERT(VARCHAR, @chefe) + ' or cd_chefe2 = '
				+ CONVERT(VARCHAR, @chefe) + ')';
			END;

			IF (@plano <> '')
			BEGIN
				SET @SQL = @SQL + ' and T200.cd_plano in (' + @plano + ')';
			END;

			IF (@tipoEmpresa <> '')
			BEGIN
				SET @SQL = @SQL + ' and T500.tp_empresa in (' + @tipoEmpresa + ')';
			END;

			IF (@tipoPagamento <> '')
			BEGIN
				SET @SQL = @SQL + ' and T500.cd_tipo_pagamento in (' + @tipoPagamento + ')';
			END;

			--##TIPORECEBIMENTO##
			IF (@tipoRecebimento <> '')
			BEGIN
				SET @SQL
				= @SQL
				+ 'and (select count(0)                                 
 								from mensalidades_planos t1000,                     
 									 mensalidades t2000                             
 								where t1000.cd_sequencial_dep = T100.cd_sequencial_dep 
 								and t2000.cd_parcela = t1000.cd_parcela_mensalidade 
 								and t2000.cd_tipo_recebimento in(' + @tipoRecebimento + ') 
 								) > 0 ';
			END;

			IF (@grupoEmpresa > 0)
			BEGIN
				SET @SQL = @SQL + ' and T500.cd_grupo = ' + CONVERT(VARCHAR, @grupoEmpresa);
			END;

			IF (@centroCusto > 0)
			BEGIN
				SET @SQL = @SQL + ' and T500.cd_centro_custo = ' + CONVERT(VARCHAR, @centroCusto);
			END;

			IF (@situacao <> '')
			BEGIN
				SET @SQL
				= @SQL
				+ ' and (select top 1 cd_situacao from historico where cd_sequencial_dep = T200.cd_sequencial order by convert(date,dt_situacao) desc, cd_sequencial desc) in ('
				+ @situacao + ')';
			END;

			--IF (@nm_equipe <> '')
			--BEGIN
			--    SET @SQL = @SQL + ' And t900.nm_equipe like''' + @nm_equipe + ''' ';
			--    SET @SQL = @SQL + ' And T300.cd_equipe = t900.cd_equipe ';
			--END;
			--ELSE
			--BEGIN
			--    SET @SQL = @SQL + ' And T300.cd_equipe *= t900.cd_equipe ';
			--END;

			IF (@adesionista > 0)
			BEGIN
				SET @SQL = @SQL + ' AND T200.cd_funcionario_adesionista = ' + CONVERT(VARCHAR, @adesionista);
			END;

			SET @SQL = @SQL + ' ) As contratos ';
			--valor total da comissao
			SET @SQL = @SQL + ' , (Select SUM(IsNull(t100.vl_contrato,0)) ';
			--SET @SQL
			--    = @SQL
			--      + ' From lote_contratos_contratos_vendedor T100, Dependentes T200 , Funcionario T300, 
			--      associados t400, empresa t500, lote_contratos LC, Equipe_Vendas t900 ';
			--SET @SQL = @SQL + ' Where T100.cd_sequencial_dep = T200.cd_sequencial And ';
			--SET @SQL = @SQL + ' T200.cd_funcionario_vendedor = T300.cd_funcionario And ';
			--SET @SQL = @SQL + ' t200.cd_associado = t400.cd_associado And ';
			--SET @SQL = @SQL + ' t400.cd_empresa = t500.cd_empresa And ';
			--SET @SQL = @SQL + ' T100.cd_sequencial_lote = LC.cd_sequencial And ';


			SET @SQL
			= @SQL
			+ ' FROM dbo.lote_contratos_contratos_vendedor T100 
            INNER JOIN dbo.DEPENDENTES T200 ON T200.CD_SEQUENCIAL = T100.cd_sequencial_dep
            INNER JOIN dbo.FUNCIONARIO T300 ON T300.cd_funcionario = T200.cd_funcionario_vendedor
            INNER JOIN dbo.ASSOCIADOS T400 ON T400.cd_associado = T200.CD_ASSOCIADO
            INNER JOIN dbo.EMPRESA T500 ON T500.CD_EMPRESA = T400.cd_empresa
            INNER JOIN dbo.lote_contratos LC ON LC.cd_sequencial = T100.cd_sequencial_lote';


			IF (@nm_equipe <> '')
			BEGIN
				SET @SQL = @SQL + ' INNER JOIN dbo.equipe_vendas T900 ON T900.cd_equipe = T300.cd_equipe ';
				SET @SQL = @SQL + ' And t900.nm_equipe like''' + @nm_equipe + ''' ';
			END;
			ELSE
			BEGIN
				SET @SQL = @SQL + ' LEFT JOIN dbo.equipe_vendas T900 ON T900.cd_equipe = T300.cd_equipe ';
			END;



			SET @SQL = @SQL + ' WHERE ';

			IF (@ConfigBusca = 1)
			BEGIN
				SET @SQL
				= @SQL + ' T100.dt_cadastro between ''' + CONVERT(VARCHAR(10), @DT_Inicial, 101) + ''' And '''
				+ CONVERT(VARCHAR(10), @DT_Final, 101) + ' 23:59''';
			END;
			ELSE
			BEGIN
				SET @SQL
				= @SQL + ' T100.dt_assinaturaContrato between ''' + CONVERT(VARCHAR(10), @DT_Inicial, 101)
				+ ''' And ''' + CONVERT(VARCHAR(10), @DT_Final, 101) + ' 23:59''';
			END;

			IF (@cpfvendedor <> '')
			BEGIN
				SET @SQL = @SQL + ' And T300.nr_cpf = ''' + @cpfvendedor + '''';
			END;

			IF (@equipe > 0)
			BEGIN
				--SET @SQL = @SQL + ' And case when LC.cd_empresa is null then isnull(LC.cd_equipe,T300.cd_equipe) else T300.cd_equipe end = ' + convert(VARCHAR, @equipe)
				SET @SQL = @SQL + ' And T300.cd_equipe = ' + CONVERT(VARCHAR, @equipe);
			END;

			IF (@vendedor > 0)
			BEGIN
				SET @SQL = @SQL + ' And T300.cd_funcionario = ' + CONVERT(VARCHAR, @vendedor);
			END;

			IF (@chefe > 0)
			BEGIN
				--SET @SQL = @SQL + ' and case when LC.cd_empresa is null then isnull(LC.cd_equipe,T300.cd_equipe) else T300.cd_equipe end in (select eq.cd_equipe from equipe_vendas eq where eq.cd_chefe = ' + convert(VARCHAR, @chefe) + ' or cd_chefe1 = ' + convert(VARCHAR, @chefe) + ' or cd_chefe2 = ' + convert(VARCHAR, @chefe) + ')'
				SET @SQL
				= @SQL + ' and T300.cd_equipe in (select eq.cd_equipe from equipe_vendas eq where eq.cd_chefe = '
				+ CONVERT(VARCHAR, @chefe) + ' or cd_chefe1 = ' + CONVERT(VARCHAR, @chefe) + ' or cd_chefe2 = '
				+ CONVERT(VARCHAR, @chefe) + ')';
			END;

			IF (@plano <> '')
			BEGIN
				SET @SQL = @SQL + ' and T200.cd_plano in (' + @plano + ')';
			END;

			IF (@tipoEmpresa <> '')
			BEGIN
				SET @SQL = @SQL + ' and T500.tp_empresa in (' + @tipoEmpresa + ')';
			END;

			IF (@tipoPagamento <> '')
			BEGIN
				SET @SQL = @SQL + ' and T500.cd_tipo_pagamento in (' + @tipoPagamento + ')';
			END;

			--##TIPORECEBIMENTO##
			IF (@tipoRecebimento <> '')
			BEGIN
				SET @SQL
				= @SQL
				+ 'and (select count(0)                                 
 								from mensalidades_planos t1000,                     
 									 mensalidades t2000                             
 								where t1000.cd_sequencial_dep = T100.cd_sequencial_dep 
 								and t2000.cd_parcela = t1000.cd_parcela_mensalidade 
 								and t2000.cd_tipo_recebimento in(' + @tipoRecebimento + ') 
 								) > 0 ';
			END;

			IF (@grupoEmpresa > 0)
			BEGIN
				SET @SQL = @SQL + ' and T500.cd_grupo = ' + CONVERT(VARCHAR, @grupoEmpresa);
			END;

			IF (@centroCusto > 0)
			BEGIN
				SET @SQL = @SQL + ' and T500.cd_centro_custo = ' + CONVERT(VARCHAR, @centroCusto);
			END;

			IF (@situacao <> '')
			BEGIN
				SET @SQL
				= @SQL
				+ ' and (select top 1 cd_situacao from historico where cd_sequencial_dep = T200.cd_sequencial order by convert(date,dt_situacao) desc, cd_sequencial desc) in ('
				+ @situacao + ')';
			END;


			/*COMENTADOS FORAM REALIZADOS OS JOINS*/

			--IF (@nm_equipe <> '')
			--BEGIN
			--    SET @SQL = @SQL + ' And t900.nm_equipe like''' + @nm_equipe + ''' ';
			--    SET @SQL = @SQL + ' And T300.cd_equipe = t900.cd_equipe ';
			--END;
			--ELSE
			--BEGIN
			--    SET @SQL = @SQL + ' And T300.cd_equipe *= t900.cd_equipe ';
			--END;

			IF (@adesionista > 0)
			BEGIN
				SET @SQL = @SQL + ' AND T200.cd_funcionario_adesionista = ' + CONVERT(VARCHAR, @adesionista);
			END;

			SET @SQL = @SQL + ' ) As vl_total, ';
			SET @SQL = @SQL + ' (select count(distinct T200.cd_sequencial_dep)';
			--       SET @SQL = @SQL + '
			--from mensalidades as T100 , mensalidades_planos as T200 , dependentes as T300 ,lote_contratos_contratos_vendedor as T400 , 
			--funcionario as t500, lote_contratos as t600, associados as t700, 
			-- empresa as t800, uf as t900, municipio as t1000, Equipe_Vendas t901

			--where T100.cd_parcela = T200.cd_parcela_mensalidade OK
			--and T200.cd_sequencial_dep = T300.cd_sequencial OK
			--and T300.cd_sequencial = T400.cd_sequencial_dep OK
			--and t300.cd_funcionario_vendedor = t500.cd_funcionario OK
			--and t400.cd_sequencial_lote = t600.cd_sequencial  OK
			--and t300.cd_Associado = t700.cd_Associado OK
			--and t700.cd_empresa = t800.cd_empresa OK
			--and T200.dt_exclusao is null 
			--and T200.valor >0 
			--and T100.cd_tipo_parcela = 2 
			--and t100.cd_tipo_recebimento not in (1) 
			--and T300.cd_plano = p.cd_plano ';

			SET @SQL
			= @SQL
			+ ' FROM 
            dbo.MENSALIDADES T100 INNER JOIN dbo.Mensalidades_Planos T200
            ON T200.cd_parcela_mensalidade = T100.CD_PARCELA
            INNER JOIN dbo.DEPENDENTES T300 ON T300.CD_SEQUENCIAL = T200.cd_sequencial_dep
            INNER JOIN dbo.lote_contratos_contratos_vendedor T400 ON T400.cd_sequencial_dep = T300.CD_SEQUENCIAL
            INNER JOIN dbo.FUNCIONARIO T500 ON T300.cd_funcionario_vendedor = T500.cd_funcionario
            INNER JOIN dbo.lote_contratos T600 ON T400.cd_sequencial_lote = T600.cd_sequencial
            INNER JOIN dbo.ASSOCIADOS T700 ON T700.cd_associado = T300.CD_ASSOCIADO
            INNER JOIN dbo.EMPRESA T800 ON T700.cd_empresa = T800.CD_EMPRESA';



			IF (@uf <> -1)
			BEGIN
				SET @SQL = @SQL + ' INNER JOIN dbo.UF T900 ON T900.ufId = T700.ufId ';
				SET @SQL = @SQL + ' and t900.ufid = ' + CONVERT(VARCHAR, @uf) + '';
			END;
			ELSE
			BEGIN
				SET @SQL = @SQL + ' LEFT JOIN dbo.UF T900 ON T900.ufId = T700.ufId ';
			END;


			IF (@municipio <> -1)
			BEGIN
				SET @SQL = @SQL + ' INNER JOIN dbo.MUNICIPIO T1000 ON T1000.CD_MUNICIPIO = T700.CidID ';
				SET @SQL = @SQL + ' And t1000.cd_municipio = ' + CONVERT(VARCHAR, @municipio);
			END;
			ELSE
			BEGIN
				SET @SQL = @SQL + ' LEFT JOIN dbo.MUNICIPIO T1000 ON T1000.CD_MUNICIPIO = T700.CidID ';
			END;

			IF (@nm_equipe <> '')
			BEGIN
				SET @SQL = @SQL + ' INNER JOIN dbo.equipe_vendas T901 ON T901.cd_equipe = T500.cd_equipe ';
				SET @SQL = @SQL + ' And t901.nm_equipe like''' + @nm_equipe + ''' ';
			END;
			ELSE
			BEGIN
				SET @SQL = @SQL + 'LEFT JOIN dbo.equipe_vendas t901 ON t500.cd_equipe = t901.cd_equipe ';
			END;



			SET @SQL = @SQL + ' WHERE ';





			IF (@ConfigBusca = 1)
			BEGIN
				SET @SQL
				= @SQL + ' and T400.dt_cadastro between ''' + CONVERT(VARCHAR(10), @DT_Inicial, 101) + ''' And '''
				+ CONVERT(VARCHAR(10), @DT_Final, 101) + ' 23:59'' ';
			END;
			ELSE
			BEGIN
				SET @SQL
				= @SQL + ' and T400.dt_assinaturaContrato between ''' + CONVERT(VARCHAR(10), @DT_Inicial, 101)
				+ ''' And ''' + CONVERT(VARCHAR(10), @DT_Final, 101) + ' 23:59'' ';
			END;


			/*COMENTADOS FORAM REALIZADOS OS JOINS*/
			--IF (@uf <> -1)
			--BEGIN
			--    SET @SQL = @SQL + ' and t700.ufid = t900.ufid ';
			--    SET @SQL = @SQL + ' and t900.ufid = ' + CONVERT(VARCHAR, @uf) + '';
			--END;
			--ELSE
			--BEGIN
			--    SET @SQL = @SQL + ' and t700.ufid *= t900.ufid ';
			--END;

			--IF (@municipio <> -1)
			--BEGIN
			--    SET @SQL = @SQL + ' and t700.cidid = t1000.cd_municipio ';
			--    SET @SQL = @SQL + ' And t1000.cd_municipio = ' + CONVERT(VARCHAR, @municipio);
			--END;
			--ELSE
			--BEGIN
			--    SET @SQL = @SQL + ' and t700.cidid *= t1000.cd_municipio ';
			--END;

			IF (@cpfvendedor <> '')
			BEGIN
				SET @SQL = @SQL + ' And T500.nr_cpf = ''' + @cpfvendedor + '''';
			END;

			IF (@equipe > 0)
			BEGIN
				--SET @SQL = @SQL + ' And case when t600.cd_empresa is null then isnull(t600.cd_equipe,T400.cd_equipe) else T400.cd_equipe end = ' + convert(VARCHAR, @equipe)
				SET @SQL = @SQL + ' And t500.cd_equipe = ' + CONVERT(VARCHAR, @equipe);
			END;

			IF (@vendedor > 0)
			BEGIN
				SET @SQL = @SQL + ' And T500.cd_funcionario = ' + CONVERT(VARCHAR, @vendedor);
			END;

			IF (@chefe > 0)
			BEGIN
				--SET @SQL = @SQL + ' and case when t600.cd_empresa is null then isnull(t600.cd_equipe,T400.cd_equipe) else T400.cd_equipe end in (select eq.cd_equipe from equipe_vendas eq where eq.cd_chefe = ' + convert(VARCHAR, @chefe) + ' or cd_chefe1 = ' + convert(VARCHAR, @chefe) + ' or cd_chefe2 = ' + convert(VARCHAR, @chefe) + ')'
				SET @SQL
				= @SQL + ' and t500.cd_equipe in (select eq.cd_equipe from equipe_vendas eq where eq.cd_chefe = '
				+ CONVERT(VARCHAR, @chefe) + ' or cd_chefe1 = ' + CONVERT(VARCHAR, @chefe) + ' or cd_chefe2 = '
				+ CONVERT(VARCHAR, @chefe) + ')';
			END;

			IF (@plano <> '')
			BEGIN
				SET @SQL = @SQL + ' and T300.cd_plano in (' + @plano + ')';
			END;

			IF (@tipoEmpresa <> '')
			BEGIN
				SET @SQL = @SQL + ' and T800.tp_empresa in (' + @tipoEmpresa + ')';
			END;

			IF (@tipoPagamento <> '')
			BEGIN
				SET @SQL = @SQL + ' and T800.cd_tipo_pagamento in (' + @tipoPagamento + ')';
			END;

			--##TIPORECEBIMENTO##
			IF (@tipoRecebimento <> '')
			BEGIN
				SET @SQL
				= @SQL
				+ 'and (select count(0)                                 
 								from mensalidades_planos t1000,                     
 									 mensalidades t2000                             
 								where t1000.cd_sequencial_dep = T400.cd_sequencial_dep 
 								and t2000.cd_parcela = t1000.cd_parcela_mensalidade 
 								and t2000.cd_tipo_recebimento in(' + @tipoRecebimento + ') 
 								) > 0 ';
			END;

			IF (@grupoEmpresa > 0)
			BEGIN
				SET @SQL = @SQL + ' and T800.cd_grupo = ' + CONVERT(VARCHAR, @grupoEmpresa);
			END;

			IF (@centroCusto > 0)
			BEGIN
				SET @SQL = @SQL + ' and T800.cd_centro_custo = ' + CONVERT(VARCHAR, @centroCusto);
			END;

			IF (@situacao <> '')
			BEGIN
				SET @SQL
				= @SQL
				+ ' and (select top 1 cd_situacao from historico where cd_sequencial_dep = T300.cd_sequencial order by convert(date,dt_situacao) desc, cd_sequencial desc) in ('
				+ @situacao + ')';
			END;
			/*COMENTADOS FORAM REALIZADOS OS JOINS*/
			--IF (@nm_equipe <> '')
			--BEGIN
			--    SET @SQL = @SQL + ' And t901.nm_equipe like''' + @nm_equipe + ''' ';
			--    SET @SQL = @SQL + ' And t500.cd_equipe = t901.cd_equipe ';
			--END;
			--ELSE
			--BEGIN
			--    SET @SQL = @SQL + ' And t500.cd_equipe *= t901.cd_equipe ';
			--END;

			IF (@adesionista > 0)
			BEGIN
				SET @SQL = @SQL + ' AND T300.cd_funcionario_adesionista = ' + CONVERT(VARCHAR, @adesionista);
			END;

			SET @SQL = @SQL + ' ) as C_A ';


			--SET @SQL
			--    = @SQL
			--      + ' from funcionario f, lote_contratos_contratos_vendedor as l , 
			--      DEPENDENTES as d, ASSOCIADOS as a, PLANOS as p , EMPRESA as e , 
			--      TIPO_PAGAMENTO as t, GRUPO as g, Centro_Custo as cc, UF AS uf, 
			--      municipio AS mu, lote_contratos LC, Equipe_Vendas ev ';

			SET @SQL
			= @SQL
			+ ' FROM dbo.lote_contratos_contratos_vendedor l 
            INNER JOIN dbo.DEPENDENTES d ON d.CD_SEQUENCIAL = l.cd_sequencial_dep
            INNER JOIN dbo.PLANOS p ON d.cd_plano = p.cd_plano
            INNER JOIN dbo.ASSOCIADOS a ON a.cd_associado = d.CD_ASSOCIADO
            INNER JOIN dbo.EMPRESA e ON a.cd_empresa = e.CD_EMPRESA
            INNER JOIN dbo.TIPO_PAGAMENTO t ON t.cd_tipo_pagamento = e.cd_tipo_pagamento
            INNER JOIN dbo.lote_contratos lc ON lc.cd_sequencial = l.cd_sequencial_lote
            LEFT JOIN dbo.GRUPO g ON g.CD_GRUPO = e.cd_grupo
            LEFT JOIN dbo.FUNCIONARIO f ON f.cd_funcionario = d.cd_funcionario_vendedor
            INNER JOIN dbo.Centro_Custo cc ON e.cd_centro_custo = cc.cd_centro_custo';




			IF (@uf <> -1)
			BEGIN
				SET @SQL = @SQL + ' INNER JOIN dbo.UF ON UF.ufId = a.ufId ';
				SET @SQL = @SQL + ' and uf.ufid = ' + CONVERT(VARCHAR, @uf) + '';
			END;
			ELSE
			BEGIN
				SET @SQL = @SQL + ' LEFT JOIN dbo.UF ON UF.ufId = a.ufId ';
			END;

			IF (@municipio <> -1)
			BEGIN
				SET @SQL = @SQL + ' INNER JOIN dbo.MUNICIPIO MU ON MU.CD_MUNICIPIO = a.CidID ';
				SET @SQL = @SQL + ' And mu.cd_municipio = ' + CONVERT(VARCHAR, @municipio);
			END;
			ELSE
			BEGIN
				SET @SQL = @SQL + ' LEFT JOIN dbo.MUNICIPIO MU ON MU.CD_MUNICIPIO = a.CidID ';
			END;

			IF (@nm_equipe <> '')
			BEGIN
				SET @SQL = @SQL + ' INNER JOIN dbo.equipe_vendas EV ON F.cd_equipe = EV.cd_equipe ';
				SET @SQL = @SQL + ' And ev.nm_equipe like''' + @nm_equipe + ''' ';
			END;
			ELSE
			BEGIN
				SET @SQL = @SQL + ' LEFT JOIN dbo.equipe_vendas EV ON F.cd_equipe = EV.cd_equipe ';
			END;



			IF (@ConfigBusca = 1)
			BEGIN
				SET @SQL
				= @SQL + ' where l.dt_cadastro between ''' + CONVERT(VARCHAR(10), @DT_Inicial, 101) + ''' And '''
				+ CONVERT(VARCHAR(10), @DT_Final, 101) + ' 23:59'' and ';
			END;
			ELSE
			BEGIN
				SET @SQL
				= @SQL + ' where l.dt_assinaturaContrato between ''' + CONVERT(VARCHAR(10), @DT_Inicial, 101)
				+ ''' And ''' + CONVERT(VARCHAR(10), @DT_Final, 101) + ' 23:59'' ';
			END;

			/*COMENTADOS FORAM REALIZADOS OS JOINS*/
			--SET @SQL = @SQL + ' l.cd_sequencial_dep = d.CD_SEQUENCIAL ';
			--SET @SQL = @SQL + ' and d.cd_plano = p.cd_plano ';
			--SET @SQL = @SQL + ' and d.CD_ASSOCIADO = a.cd_associado ';
			--SET @SQL = @SQL + ' and a.cd_empresa = e.CD_EMPRESA ';
			--SET @SQL = @SQL + ' and e.cd_tipo_pagamento = t.cd_tipo_pagamento ';
			--SET @SQL = @SQL + ' and e.cd_grupo *= g.cd_grupo ';
			--SET @SQL = @SQL + ' and e.cd_centro_custo = cc.cd_centro_custo ';
			--SET @SQL = @SQL + ' and f.cd_funcionario *= d.cd_funcionario_vendedor ';
			--SET @SQL = @SQL + ' And l.cd_sequencial_lote = LC.cd_sequencial ';

			--IF (@uf <> -1)
			--BEGIN
			--    SET @SQL = @SQL + ' and a.ufid = uf.ufid ';
			--    SET @SQL = @SQL + ' and uf.ufid = ' + CONVERT(VARCHAR, @uf) + '';
			--END;
			--ELSE
			--BEGIN
			--    SET @SQL = @SQL + ' and a.ufid *= uf.ufid ';
			--END;

			--IF (@municipio <> -1)
			--BEGIN
			--    SET @SQL = @SQL + ' and a.cidid = mu.cd_municipio ';
			--    SET @SQL = @SQL + ' And mu.cd_municipio = ' + CONVERT(VARCHAR, @municipio);
			--END;
			--ELSE
			--BEGIN
			--    SET @SQL = @SQL + ' and a.cidid *= mu.cd_municipio ';
			--END;



			IF (@cpfvendedor <> '')
			BEGIN
				SET @SQL = @SQL + ' And f.nr_cpf = ''' + @cpfvendedor + '''';
			END;

			IF (@equipe > 0)
			BEGIN
				--SET @SQL = @SQL + ' And case when LC.cd_empresa is null then isnull(LC.cd_equipe,f.cd_equipe) else f.cd_equipe end = ' + convert(VARCHAR, @equipe)
				SET @SQL = @SQL + ' And f.cd_equipe = ' + CONVERT(VARCHAR, @equipe);
			END;

			IF (@vendedor > 0)
			BEGIN
				SET @SQL = @SQL + ' and d.cd_funcionario_vendedor = ' + CONVERT(VARCHAR, @vendedor);
			END;

			IF (@chefe > 0)
			BEGIN
				--SET @SQL = @SQL + ' and l.cd_equipe in (select eq.cd_equipe from equipe_vendas eq where eq.cd_chefe = ' + convert(VARCHAR, @chefe) + ' or cd_chefe1 = ' + convert(VARCHAR, @chefe) + ' or cd_chefe2 = ' + convert(VARCHAR, @chefe) + ')'
				SET @SQL
				= @SQL + ' and f.cd_equipe in (select eq.cd_equipe from equipe_vendas eq where eq.cd_chefe = '
				+ CONVERT(VARCHAR, @chefe) + ' or cd_chefe1 = ' + CONVERT(VARCHAR, @chefe) + ' or cd_chefe2 = '
				+ CONVERT(VARCHAR, @chefe) + ')';
			END;

			IF (@plano <> '')
			BEGIN
				SET @SQL = @SQL + ' and d.cd_plano in (' + @plano + ')';
			END;

			IF (@tipoEmpresa <> '')
			BEGIN
				SET @SQL = @SQL + ' and e.tp_empresa in (' + @tipoEmpresa + ')';
			END;

			IF (@tipoPagamento <> '')
			BEGIN
				SET @SQL = @SQL + ' and e.cd_tipo_pagamento in (' + @tipoPagamento + ')';
			END;

			--##TIPORECEBIMENTO##
			IF (@tipoRecebimento <> '')
			BEGIN
				SET @SQL
				= @SQL
				+ 'and (select count(0)                                 
 								from mensalidades_planos t1000,                     
 									 mensalidades t2000                             
 								where t1000.cd_sequencial_dep = l.cd_sequencial_dep 
 								and t2000.cd_parcela = t1000.cd_parcela_mensalidade 
 								and t2000.cd_tipo_recebimento in(' + @tipoRecebimento + ') 
 								) > 0 ';
			END;

			IF (@grupoEmpresa > 0)
			BEGIN
				SET @SQL = @SQL + ' and e.cd_grupo = ' + CONVERT(VARCHAR, @grupoEmpresa);
			END;

			IF (@centroCusto > 0)
			BEGIN
				SET @SQL = @SQL + ' and e.cd_centro_custo = ' + CONVERT(VARCHAR, @centroCusto);
			END;

			IF (@situacao <> '')
			BEGIN
				SET @SQL
				= @SQL
				+ ' and (select top 1 cd_situacao from historico where cd_sequencial_dep = d.cd_sequencial order by convert(date,dt_situacao) desc, cd_sequencial desc) in ('
				+ @situacao + ')';
			END;

			--IF (@nm_equipe <> '')
			--BEGIN
			--    SET @SQL = @SQL + ' And ev.nm_equipe like''' + @nm_equipe + ''' ';
			--    SET @SQL = @SQL + ' And f.cd_equipe = ev.cd_equipe ';
			--END;
			--ELSE
			--BEGIN
			--    SET @SQL = @SQL + ' And f.cd_equipe *= ev.cd_equipe ';
			--END;

			IF (@adesionista > 0)
			BEGIN
				SET @SQL = @SQL + ' And d.cd_funcionario_adesionista = ' + CONVERT(VARCHAR, @adesionista);
			END;

			SET @SQL = @SQL + ' group by p.cd_plano, p.nm_plano ';
			SET @SQL = @SQL + ' order by 3 desc ';
		END;

		IF @tipo = 3
		BEGIN
			SET @SQL = @SQL + ' select t.cd_tipo_pagamento, t.nm_tipo_pagamento, COUNT(0), SUM(l.vl_contrato), ';
			--Qtde Contratos
			SET @SQL = @SQL + ' (Select Count(distinct T400.cd_associado) ';
			--SET @SQL
			--    = @SQL
			--      + ' From lote_contratos_contratos_vendedor T100, Dependentes T200 , 
			--      Funcionario T300 , associados t400, empresa t500, 
			--      tipo_pagamento t600, lote_contratos LC, Equipe_Vendas t900 ';
			--SET @SQL = @SQL + ' Where T100.cd_sequencial_dep = T200.cd_sequencial ';
			--SET @SQL = @SQL + ' And T200.cd_funcionario_vendedor = T300.cd_funcionario ';
			--SET @SQL = @SQL + ' And t200.cd_associado = t400.cd_associado ';
			--SET @SQL = @SQL + ' and t400.cd_empresa = t500.cd_empresa ';
			--SET @SQL = @SQL + ' and t500.cd_tipo_pagamento = t600.cd_tipo_pagamento ';
			--SET @SQL = @SQL + ' and t600.cd_tipo_pagamento = t.cd_tipo_pagamento ';
			--SET @SQL = @SQL + ' and T200.cd_grau_parentesco = 1 ';
			--SET @SQL = @SQL + ' and T100.cd_sequencial_lote = LC.cd_sequencial ';

			SET @SQL
			= @SQL
			+ ' FROM dbo.lote_contratos_contratos_vendedor T100 INNER JOIN dbo.DEPENDENTES T200 
            ON T200.CD_SEQUENCIAL = T100.cd_sequencial_dep AND T200.CD_GRAU_PARENTESCO = 1
            INNER JOIN dbo.FUNCIONARIO T300 ON T200.cd_funcionario_vendedor = T300.cd_funcionario
            INNER JOIN dbo.ASSOCIADOS T400 ON T400.cd_associado = T200.CD_ASSOCIADO
            INNER JOIN dbo.EMPRESA T500 ON T400.cd_empresa = T500.CD_EMPRESA
            INNER JOIN dbo.TIPO_PAGAMENTO T600 ON T600.cd_tipo_pagamento = T500.cd_tipo_pagamento
            INNER JOIN dbo.lote_contratos LC ON LC.cd_sequencial = T100.cd_sequencial_lote';


			IF (@nm_equipe <> '')
			BEGIN
				SET @SQL = @SQL + ' INNER JOIN dbo.equipe_vendas T900 ON T300.cd_equipe = T900.cd_equipe ';
				SET @SQL = @SQL + ' And t900.nm_equipe like''' + @nm_equipe + ''' ';
			END;
			ELSE
			BEGIN
				SET @SQL = @SQL + ' LEFT JOIN dbo.equipe_vendas T900 ON T300.cd_equipe = T900.cd_equipe ';
			END;


			SET @SQL = @SQL + ' WHERE t600.cd_tipo_pagamento = t.cd_tipo_pagamento ';






			IF (@ConfigBusca = 1)
			BEGIN
				SET @SQL
				= @SQL + ' And T100.dt_cadastro between ''' + CONVERT(VARCHAR(10), @DT_Inicial, 101) + ''' And '''
				+ CONVERT(VARCHAR(10), @DT_Final, 101) + ' 23:59''';
			END;
			ELSE
			BEGIN
				SET @SQL
				= @SQL + ' And T100.dt_assinaturaContrato between ''' + CONVERT(VARCHAR(10), @DT_Inicial, 101)
				+ ''' And ''' + CONVERT(VARCHAR(10), @DT_Final, 101) + ' 23:59''';
			END;

			IF (@cpfvendedor <> '')
			BEGIN
				SET @SQL = @SQL + ' And T300.nr_cpf = ''' + @cpfvendedor + '''';
			END;

			IF (@equipe > 0)
			BEGIN
				--SET @SQL = @SQL + ' And case when LC.cd_empresa is null then isnull(LC.cd_equipe,T300.cd_equipe) else T300.cd_equipe end = ' + convert(VARCHAR, @equipe)
				SET @SQL = @SQL + ' and T300.cd_equipe = ''' + CONVERT(VARCHAR, @equipe) + '''';
			END;

			IF (@vendedor > 0)
			BEGIN
				SET @SQL = @SQL + ' And T300.cd_funcionario = ' + CONVERT(VARCHAR, @vendedor);
			END;

			IF (@chefe > 0)
			BEGIN
				--SET @SQL = @SQL + ' and case when LC.cd_empresa is null then isnull(LC.cd_equipe,T300.cd_equipe) else T300.cd_equipe end in (select eq.cd_equipe from equipe_vendas eq where eq.cd_chefe = ' + convert(VARCHAR, @chefe) + ' or cd_chefe1 = ' + convert(VARCHAR, @chefe) + ' or cd_chefe2 = ' + convert(VARCHAR, @chefe) + ')'
				SET @SQL
				= @SQL + ' and T300.cd_equipe in (select eq.cd_equipe from equipe_vendas eq where eq.cd_chefe = '
				+ CONVERT(VARCHAR, @chefe) + ' or cd_chefe1 = ' + CONVERT(VARCHAR, @chefe) + ' or cd_chefe2 = '
				+ CONVERT(VARCHAR, @chefe) + ')';
			END;

			IF (@plano <> '')
			BEGIN
				SET @SQL = @SQL + ' and T200.cd_plano in (' + @plano + ')';
			END;

			IF (@tipoEmpresa <> '')
			BEGIN
				SET @SQL = @SQL + ' and T500.tp_empresa in (' + @tipoEmpresa + ')';
			END;

			IF (@tipoPagamento <> '')
			BEGIN
				SET @SQL = @SQL + ' and T500.cd_tipo_pagamento in (' + @tipoPagamento + ')';
			END;

			--##TIPORECEBIMENTO##
			IF (@tipoRecebimento <> '')
			BEGIN
				SET @SQL
				= @SQL
				+ 'and (select count(0)                                 
 								from mensalidades_planos t1000,                     
 									 mensalidades t2000                             
 								where t1000.cd_sequencial_dep = t100.cd_sequencial_dep 
 								and t2000.cd_parcela = t1000.cd_parcela_mensalidade 
 								and t2000.cd_tipo_recebimento in(' + @tipoRecebimento + ') 
 								) > 0 ';
			END;

			IF (@grupoEmpresa > 0)
			BEGIN
				SET @SQL = @SQL + ' and T500.cd_grupo = ' + CONVERT(VARCHAR, @grupoEmpresa);
			END;

			IF (@centroCusto > 0)
			BEGIN
				SET @SQL = @SQL + ' and T500.cd_centro_custo = ' + CONVERT(VARCHAR, @centroCusto);
			END;

			IF (@situacao <> '')
			BEGIN
				SET @SQL
				= @SQL
				+ ' and (select top 1 cd_situacao from historico where cd_sequencial_dep = T200.cd_sequencial order by convert(date,dt_situacao) desc, cd_sequencial desc) in ('
				+ @situacao + ')';
			END;

			--IF (@nm_equipe <> '')
			--BEGIN
			--    SET @SQL = @SQL + ' And t900.nm_equipe like''' + @nm_equipe + ''' ';
			--    SET @SQL = @SQL + ' And T300.cd_equipe = t900.cd_equipe ';
			--END;
			--ELSE
			--BEGIN
			--    SET @SQL = @SQL + ' And T300.cd_equipe *= t900.cd_equipe ';
			--END;

			IF (@adesionista > 0)
			BEGIN
				SET @SQL = @SQL + ' AND T200.cd_funcionario_adesionista = ' + CONVERT(VARCHAR, @adesionista);
			END;

			SET @SQL = @SQL + ' ) As contratos ';
			--Valor total
			SET @SQL = @SQL + ' , (Select SUM(isnull(T100.vl_contrato,0)) ';
			SET @SQL
			= @SQL
			+ ' From lote_contratos_contratos_vendedor T100, Dependentes T200 , Funcionario T300 , associados t400, empresa t500, tipo_pagamento t600, lote_contratos LC, Equipe_Vendas t900 ';
			SET @SQL = @SQL + ' Where T100.cd_sequencial_dep = T200.cd_sequencial ';
			SET @SQL = @SQL + ' And T200.cd_funcionario_vendedor = T300.cd_funcionario ';
			SET @SQL = @SQL + ' And t200.cd_associado = t400.cd_associado ';
			SET @SQL = @SQL + ' and t400.cd_empresa = t500.cd_empresa ';
			SET @SQL = @SQL + ' and t500.cd_tipo_pagamento = t600.cd_tipo_pagamento ';
			SET @SQL = @SQL + ' and T100.cd_sequencial_lote = LC.cd_sequencial ';

			IF (@ConfigBusca = 1)
			BEGIN
				SET @SQL
				= @SQL + ' And T100.dt_cadastro between ''' + CONVERT(VARCHAR(10), @DT_Inicial, 101) + ''' And '''
				+ CONVERT(VARCHAR(10), @DT_Final, 101) + ' 23:59''';
			END;
			ELSE
			BEGIN
				SET @SQL
				= @SQL + ' And T100.dt_assinaturaContrato between ''' + CONVERT(VARCHAR(10), @DT_Inicial, 101)
				+ ''' And ''' + CONVERT(VARCHAR(10), @DT_Final, 101) + ' 23:59''';
			END;

			IF (@cpfvendedor <> '')
			BEGIN
				SET @SQL = @SQL + ' And T300.nr_cpf = ''' + @cpfvendedor + '''';
			END;

			IF (@equipe > 0)
			BEGIN
				--SET @SQL = @SQL + ' And case when LC.cd_empresa is null then isnull(LC.cd_equipe,T300.cd_equipe) else T300.cd_equipe end = ' + convert(VARCHAR, @equipe)
				SET @SQL = @SQL + ' And T300.cd_equipe = ' + CONVERT(VARCHAR, @equipe);
			END;

			IF (@vendedor > 0)
			BEGIN
				SET @SQL = @SQL + ' And T300.cd_funcionario = ' + CONVERT(VARCHAR, @vendedor);
			END;

			IF (@chefe > 0)
			BEGIN
				--SET @SQL = @SQL + ' and case when LC.cd_empresa is null then isnull(LC.cd_equipe,T300.cd_equipe) else T300.cd_equipe end in (select eq.cd_equipe from equipe_vendas eq where eq.cd_chefe = ' + convert(VARCHAR, @chefe) + ' or cd_chefe1 = ' + convert(VARCHAR, @chefe) + ' or cd_chefe2 = ' + convert(VARCHAR, @chefe) + ')'
				SET @SQL
				= @SQL + ' and T300.cd_equipe in (select eq.cd_equipe from equipe_vendas eq where eq.cd_chefe = '
				+ CONVERT(VARCHAR, @chefe) + ' or cd_chefe1 = ' + CONVERT(VARCHAR, @chefe) + ' or cd_chefe2 = '
				+ CONVERT(VARCHAR, @chefe) + ')';
			END;

			IF (@plano <> '')
			BEGIN
				SET @SQL = @SQL + ' and T200.cd_plano in (' + @plano + ')';
			END;

			IF (@tipoEmpresa <> '')
			BEGIN
				SET @SQL = @SQL + ' and T500.tp_empresa in (' + @tipoEmpresa + ')';
			END;

			IF (@tipoPagamento <> '')
			BEGIN
				SET @SQL = @SQL + ' and T500.cd_tipo_pagamento in (' + @tipoPagamento + ')';
			END;

			--##TIPORECEBIMENTO##
			IF (@tipoRecebimento <> '')
			BEGIN
				SET @SQL
				= @SQL
				+ 'and (select count(0)                                 
 								from mensalidades_planos t1000,                     
 									 mensalidades t2000                             
 								where t1000.cd_sequencial_dep = t100.cd_sequencial_dep 
 								and t2000.cd_parcela = t1000.cd_parcela_mensalidade 
 								and t2000.cd_tipo_recebimento in(' + @tipoRecebimento + ') 
 								) > 0 ';
			END;

			IF (@grupoEmpresa > 0)
			BEGIN
				SET @SQL = @SQL + ' and T500.cd_grupo = ' + CONVERT(VARCHAR, @grupoEmpresa);
			END;

			IF (@centroCusto > 0)
			BEGIN
				SET @SQL = @SQL + ' and T500.cd_centro_custo = ' + CONVERT(VARCHAR, @centroCusto);
			END;

			IF (@situacao <> '')
			BEGIN
				SET @SQL
				= @SQL
				+ ' and (select top 1 cd_situacao from historico where cd_sequencial_dep = T200.cd_sequencial order by convert(date,dt_situacao) desc, cd_sequencial desc) in ('
				+ @situacao + ')';
			END;

			--IF (@nm_equipe <> '')
			--BEGIN
			--    SET @SQL = @SQL + ' And t900.nm_equipe like''' + @nm_equipe + ''' ';
			--    SET @SQL = @SQL + ' And T300.cd_equipe = t900.cd_equipe ';
			--END;
			--ELSE
			--BEGIN
			--    SET @SQL = @SQL + ' And T300.cd_equipe *= t900.cd_equipe ';
			--END;

			IF (@adesionista > 0)
			BEGIN
				SET @SQL = @SQL + ' AND T200.cd_funcionario_adesionista = ' + CONVERT(VARCHAR, @adesionista);
			END;

			SET @SQL = @SQL + ' ) As vl_total ';



			--SET @SQL
			--    = @SQL
			--      + ' from funcionario f, lote_contratos_contratos_vendedor as l, 
			--      DEPENDENTES as d, ASSOCIADOS as a, PLANOS as p, EMPRESA as e, 
			--      TIPO_PAGAMENTO as t, lote_contratos LC, uf, municipio mu, Equipe_Vendas ev ';


			--SET @SQL = @SQL + ' l.cd_sequencial_dep = d.CD_SEQUENCIAL ';
			--SET @SQL = @SQL + ' and d.cd_plano = p.cd_plano ';
			--SET @SQL = @SQL + ' and d.CD_ASSOCIADO = a.cd_associado ';
			--SET @SQL = @SQL + ' and a.cd_empresa = e.CD_EMPRESA ';
			--SET @SQL = @SQL + ' and e.cd_tipo_pagamento = t.cd_tipo_pagamento ';
			--SET @SQL = @SQL + ' and f.cd_funcionario *= d.cd_funcionario_vendedor ';
			--SET @SQL = @SQL + ' and l.cd_sequencial_lote = LC.cd_sequencial 

			SET @SQL
			= @SQL
			+ ' FROM 
            dbo.lote_contratos_contratos_vendedor L INNER JOIN dbo.DEPENDENTES D ON D.CD_SEQUENCIAL = L.cd_sequencial_dep
            INNER JOIN dbo.PLANOS P ON D.cd_plano = P.cd_plano
            INNER JOIN dbo.ASSOCIADOS A ON A.cd_associado = D.CD_ASSOCIADO
            INNER JOIN dbo.EMPRESA E ON A.cd_empresa = E.CD_EMPRESA
            INNER JOIN dbo.TIPO_PAGAMENTO T ON T.cd_tipo_pagamento = A.cd_tipo_pagamento
            LEFT JOIN dbo.FUNCIONARIO F ON F.cd_funcionario = D.cd_funcionario_vendedor
            INNER JOIN dbo.lote_contratos LC ON LC.cd_sequencial = L.cd_sequencial_lote';


			IF (@uf <> -1)
			BEGIN
				SET @SQL = @SQL + ' INNER JOIN dbo.UF ON UF.ufId = A.ufId ';
				SET @SQL = @SQL + ' and uf.ufid = ' + CONVERT(VARCHAR, @uf) + '';
			END;
			ELSE
			BEGIN
				SET @SQL = @SQL + ' LEFT JOIN dbo.UF ON UF.ufId = A.ufId ';
			END;

			IF (@municipio <> -1)
			BEGIN
				SET @SQL = @SQL + ' INNER JOIN dbo.MUNICIPIO MU ON MU.CD_MUNICIPIO = A.CidID ';
				SET @SQL = @SQL + ' And mu.cd_municipio = ' + CONVERT(VARCHAR, @municipio);
			END;
			ELSE
			BEGIN
				SET @SQL = @SQL + ' LEFT JOIN dbo.MUNICIPIO MU ON MU.CD_MUNICIPIO = A.CidID ';
			END;

			IF (@nm_equipe <> '')
			BEGIN
				SET @SQL = @SQL + ' INNER JOIN dbo.equipe_vendas EV ON F.cd_equipe = EV.cd_equipe ';
				SET @SQL = @SQL + ' And ev.nm_equipe like''' + @nm_equipe + ''' ';
			END;
			ELSE
			BEGIN
				SET @SQL = @SQL + ' LEFT JOIN dbo.equipe_vendas EV ON F.cd_equipe = EV.cd_equipe ';
			END;

			IF (@ConfigBusca = 1)
			BEGIN
				SET @SQL
				= @SQL + ' where l.dt_cadastro between ''' + CONVERT(VARCHAR(10), @DT_Inicial, 101) + ''' And '''
				+ CONVERT(VARCHAR(10), @DT_Final, 101) + ' 23:59'' and ';
			END;
			ELSE
			BEGIN
				SET @SQL
				= @SQL + ' where l.dt_assinaturaContrato between ''' + CONVERT(VARCHAR(10), @DT_Inicial, 101)
				+ ''' And ''' + CONVERT(VARCHAR(10), @DT_Final, 101) + ' 23:59'' and ';
			END;

			--SET @SQL = @SQL + ' l.cd_sequencial_dep = d.CD_SEQUENCIAL ';
			--SET @SQL = @SQL + ' and d.cd_plano = p.cd_plano ';
			--SET @SQL = @SQL + ' and d.CD_ASSOCIADO = a.cd_associado ';
			--SET @SQL = @SQL + ' and a.cd_empresa = e.CD_EMPRESA ';
			--SET @SQL = @SQL + ' and e.cd_tipo_pagamento = t.cd_tipo_pagamento ';
			--SET @SQL = @SQL + ' and f.cd_funcionario *= d.cd_funcionario_vendedor ';
			--SET @SQL = @SQL + ' and l.cd_sequencial_lote = LC.cd_sequencial ';

			--IF (@uf <> -1)
			--BEGIN
			--    SET @SQL = @SQL + ' and a.ufid = uf.ufid ';
			--    SET @SQL = @SQL + ' and uf.ufid = ' + CONVERT(VARCHAR, @uf) + '';
			--END;
			--ELSE
			--BEGIN
			--    SET @SQL = @SQL + ' and a.ufid *= uf.ufid ';
			--END;

			--IF (@municipio <> -1)
			--BEGIN
			--    SET @SQL = @SQL + ' and a.cidid = mu.cd_municipio ';
			--    SET @SQL = @SQL + ' And mu.cd_municipio = ' + CONVERT(VARCHAR, @municipio);
			--END;
			--ELSE
			--BEGIN
			--    SET @SQL = @SQL + ' and a.cidid *= mu.cd_municipio ';
			--END;

			IF (@cpfvendedor <> '')
			BEGIN
				SET @SQL = @SQL + ' And f.nr_cpf = ''' + @cpfvendedor + '''';
			END;

			IF (@equipe > 0)
			BEGIN
				--SET @SQL = @SQL + ' And case when LC.cd_empresa is null then isnull(LC.cd_equipe,f.cd_equipe) else f.cd_equipe end = ' + convert(VARCHAR, @equipe)
				SET @SQL = @SQL + ' And f.cd_equipe = ' + CONVERT(VARCHAR, @equipe);
			END;

			IF (@vendedor > 0)
			BEGIN
				SET @SQL = @SQL + ' and d.cd_funcionario_vendedor = ' + CONVERT(VARCHAR, @vendedor);
			END;

			IF (@chefe > 0)
			BEGIN
				--SET @SQL = @SQL + ' and case when LC.cd_empresa is null then isnull(LC.cd_equipe,f.cd_equipe) else f.cd_equipe end in (select eq.cd_equipe from equipe_vendas eq where eq.cd_chefe = ' + convert(VARCHAR, @chefe) + ' or cd_chefe1 = ' + convert(VARCHAR, @chefe) + ' or cd_chefe2 = ' + convert(VARCHAR, @chefe) + ')'
				SET @SQL
				= @SQL + ' and f.cd_equipe in (select eq.cd_equipe from equipe_vendas eq where eq.cd_chefe = '
				+ CONVERT(VARCHAR, @chefe) + ' or cd_chefe1 = ' + CONVERT(VARCHAR, @chefe) + ' or cd_chefe2 = '
				+ CONVERT(VARCHAR, @chefe) + ')';
			END;

			IF (@plano <> '')
			BEGIN
				SET @SQL = @SQL + ' and d.cd_plano in (' + @plano + ')';
			END;

			IF (@tipoEmpresa <> '')
			BEGIN
				SET @SQL = @SQL + ' and e.tp_empresa in (' + @tipoEmpresa + ')';
			END;

			IF (@tipoPagamento <> '')
			BEGIN
				SET @SQL = @SQL + ' and e.cd_tipo_pagamento in (' + @tipoPagamento + ')';
			END;

			--##TIPORECEBIMENTO##
			IF (@tipoRecebimento <> '')
			BEGIN
				SET @SQL
				= @SQL
				+ 'and (select count(0)                                 
 								from mensalidades_planos t1000,                     
 									 mensalidades t2000                             
 								where t1000.cd_sequencial_dep = l.cd_sequencial_dep 
 								and t2000.cd_parcela = t1000.cd_parcela_mensalidade 
 								and t2000.cd_tipo_recebimento in(' + @tipoRecebimento + ') 
 								) > 0 ';
			END;

			IF (@grupoEmpresa > 0)
			BEGIN
				SET @SQL = @SQL + ' and e.cd_grupo = ' + CONVERT(VARCHAR, @grupoEmpresa);
			END;

			IF (@centroCusto > 0)
			BEGIN
				SET @SQL = @SQL + ' and e.cd_centro_custo = ' + CONVERT(VARCHAR, @centroCusto);
			END;

			IF (@situacao <> '')
			BEGIN
				SET @SQL
				= @SQL
				+ ' and (select top 1 cd_situacao from historico where cd_sequencial_dep = d.cd_sequencial order by convert(date,dt_situacao) desc, cd_sequencial desc) in ('
				+ @situacao + ')';
			END;

			--IF (@nm_equipe <> '')
			--BEGIN
			--    SET @SQL = @SQL + ' And ev.nm_equipe like''' + @nm_equipe + ''' ';
			--    SET @SQL = @SQL + ' And f.cd_equipe = ev.cd_equipe ';
			--END;
			--ELSE
			--BEGIN
			--    SET @SQL = @SQL + ' And f.cd_equipe *= ev.cd_equipe ';
			--END;

			IF (@adesionista > 0)
			BEGIN
				SET @SQL = @SQL + ' And d.cd_funcionario_adesionista = ' + CONVERT(VARCHAR, @adesionista);
			END;

			SET @SQL = @SQL + ' group by t.cd_tipo_pagamento , t.nm_tipo_pagamento ';
			SET @SQL = @SQL + ' order by 3 desc ';
		END;

		IF @tipo = 4
		BEGIN
			SET @SQL
			= @SQL
			+ ' select isnull(g.cd_grupo, -1) as cd_grupo, isnull(g.nm_grupo, ''SEM GRUPO'') AS nm_grupo, COUNT(0), SUM(l.vl_contrato), ';
			--Qtde Contratos
			SET @SQL = @SQL + ' (Select Count(distinct T400.cd_associado) ';
			--SET @SQL
			--    = @SQL
			--      + ' From lote_contratos_contratos_vendedor T100, Dependentes T200 , 
			--      Funcionario T300 , associados t400, empresa t500, GRUPO t600, lote_contratos LC, Equipe_Vendas t900 ';
			--SET @SQL = @SQL + ' Where T100.cd_sequencial_dep = T200.cd_sequencial ';
			--SET @SQL = @SQL + ' And T200.cd_funcionario_vendedor = T300.cd_funcionario ';
			--SET @SQL = @SQL + ' And t200.cd_associado = t400.cd_associado ';
			--SET @SQL = @SQL + ' and t400.cd_empresa = t500.cd_empresa ';
			--SET @SQL = @SQL + ' and t500.cd_grupo *= t600.cd_grupo ';
			--SET @SQL = @SQL + ' and t600.cd_grupo = g.cd_grupo';
			--SET @SQL = @SQL + ' and T200.cd_grau_parentesco = 1 ';
			--SET @SQL = @SQL + ' and T100.cd_sequencial_lote = LC.cd_sequencial ';

			SET @SQL
			= @SQL
			+ ' FROM dbo.lote_contratos_contratos_vendedor T100 INNER JOIN dbo.DEPENDENTES T200 ON T200.CD_SEQUENCIAL = T100.cd_sequencial_dep
            INNER JOIN dbo.FUNCIONARIO T300 ON T200.cd_funcionario_vendedor = T300.cd_funcionario
            INNER JOIN dbo.ASSOCIADOS T400 ON T400.cd_associado = T200.CD_ASSOCIADO
            INNER JOIN dbo.EMPRESA T500 ON T400.cd_empresa = T500.CD_EMPRESA
            LEFT JOIN dbo.GRUPO T600 ON T600.CD_GRUPO = T500.cd_grupo 
            INNER JOIN dbo.lote_contratos LC ON LC.cd_sequencial = T100.cd_sequencial_lote';



			IF (@nm_equipe <> '')
			BEGIN
				SET @SQL = @SQL + ' INNER JOIN dbo.equipe_vendas T900 ON T300.cd_equipe = T900.cd_equipe ';
				SET @SQL = @SQL + ' And t900.nm_equipe like''' + @nm_equipe + ''' ';
			END;
			ELSE
			BEGIN
				SET @SQL = @SQL + ' LEFT JOIN dbo.equipe_vendas T900 ON T300.cd_equipe = T900.cd_equipe ';
			END;

			SET @SQL
			= @SQL
			+ ' WHERE t600.cd_grupo = g.cd_grupo
                               and T200.cd_grau_parentesco = 1
                               ';
			IF (@ConfigBusca = 1)
			BEGIN
				SET @SQL
				= @SQL + ' And T100.dt_cadastro between ''' + CONVERT(VARCHAR(10), @DT_Inicial, 101) + ''' And '''
				+ CONVERT(VARCHAR(10), @DT_Final, 101) + ' 23:59''';
			END;
			ELSE
			BEGIN
				SET @SQL
				= @SQL + ' And T100.dt_assinaturaContrato between ''' + CONVERT(VARCHAR(10), @DT_Inicial, 101)
				+ ''' And ''' + CONVERT(VARCHAR(10), @DT_Final, 101) + ' 23:59''';
			END;

			IF (@cpfvendedor <> '')
			BEGIN
				SET @SQL = @SQL + ' And T300.nr_cpf = ''' + @cpfvendedor + '''';
			END;

			IF (@equipe > 0)
			BEGIN
				--SET @SQL = @SQL + ' And case when LC.cd_empresa is null then isnull(LC.cd_equipe,T300.cd_equipe) else T300.cd_equipe end = ' + convert(VARCHAR, @equipe)
				SET @SQL = @SQL + ' and T300.cd_equipe = ''' + CONVERT(VARCHAR, @equipe) + '''';
			END;

			IF (@vendedor > 0)
			BEGIN
				SET @SQL = @SQL + ' And T300.cd_funcionario = ' + CONVERT(VARCHAR, @vendedor);
			END;

			IF (@chefe > 0)
			BEGIN
				--SET @SQL = @SQL + ' and case when LC.cd_empresa is null then isnull(LC.cd_equipe,T300.cd_equipe) else T300.cd_equipe end in (select eq.cd_equipe from equipe_vendas eq where eq.cd_chefe = ' + convert(VARCHAR, @chefe) + ' or cd_chefe1 = ' + convert(VARCHAR, @chefe) + ' or cd_chefe2 = ' + convert(VARCHAR, @chefe) + ')'
				SET @SQL
				= @SQL + ' and T300.cd_equipe in (select eq.cd_equipe from equipe_vendas eq where eq.cd_chefe = '
				+ CONVERT(VARCHAR, @chefe) + ' or cd_chefe1 = ' + CONVERT(VARCHAR, @chefe) + ' or cd_chefe2 = '
				+ CONVERT(VARCHAR, @chefe) + ')';
			END;

			IF (@plano <> '')
			BEGIN
				SET @SQL = @SQL + ' and T200.cd_plano in (' + @plano + ')';
			END;

			IF (@tipoEmpresa <> '')
			BEGIN
				SET @SQL = @SQL + ' and T500.tp_empresa in (' + @tipoEmpresa + ')';
			END;

			IF (@tipoPagamento <> '')
			BEGIN
				SET @SQL = @SQL + ' and T500.cd_tipo_pagamento in (' + @tipoPagamento + ')';
			END;

			--##TIPORECEBIMENTO##
			IF (@tipoRecebimento <> '')
			BEGIN
				SET @SQL
				= @SQL
				+ 'and (select count(0)                                 
							from mensalidades_planos t1000,                     
								 mensalidades t2000                             
							where t1000.cd_sequencial_dep = t100.cd_sequencial_dep 
							and t2000.cd_parcela = t1000.cd_parcela_mensalidade 
							and t2000.cd_tipo_recebimento in(' + @tipoRecebimento + ') 
							) > 0 ';
			END;

			IF (@grupoEmpresa > 0)
			BEGIN
				SET @SQL = @SQL + ' and T500.cd_grupo = ' + CONVERT(VARCHAR, @grupoEmpresa);
			END;

			IF (@centroCusto > 0)
			BEGIN
				SET @SQL = @SQL + ' and T500.cd_centro_custo = ' + CONVERT(VARCHAR, @centroCusto);
			END;

			IF (@situacao <> '')
			BEGIN
				SET @SQL
				= @SQL
				+ ' and (select top 1 cd_situacao from historico where cd_sequencial_dep = T200.cd_sequencial order by convert(date,dt_situacao) desc, cd_sequencial desc) in ('
				+ @situacao + ')';
			END;

			--IF (@nm_equipe <> '')
			--BEGIN
			--    SET @SQL = @SQL + ' And t900.nm_equipe like''' + @nm_equipe + ''' ';
			--    SET @SQL = @SQL + ' And T300.cd_equipe = t900.cd_equipe ';
			--END;
			--ELSE
			--BEGIN
			--    SET @SQL = @SQL + ' And T300.cd_equipe *= t900.cd_equipe ';
			--END;

			IF (@adesionista > 0)
			BEGIN
				SET @SQL = @SQL + ' AND T200.cd_funcionario_adesionista = ' + CONVERT(VARCHAR, @adesionista);
			END;

			SET @SQL = @SQL + ' ) As contratos ';
			--Valor total
			SET @SQL = @SQL + ' , (Select SUM(isnull(T100.vl_contrato,0)) ';
			--SET @SQL
			--    = @SQL
			--      + ' From lote_contratos_contratos_vendedor T100, Dependentes T200 , 
			--      Funcionario T300 , associados t400, empresa t500, GRUPO t600, lote_contratos LC, Equipe_Vendas t900 ';
			--SET @SQL = @SQL + ' Where T100.cd_sequencial_dep = T200.cd_sequencial ';
			--SET @SQL = @SQL + ' And T200.cd_funcionario_vendedor = T300.cd_funcionario ';
			--SET @SQL = @SQL + ' And t200.cd_associado = t400.cd_associado ';
			--SET @SQL = @SQL + ' and t400.cd_empresa = t500.cd_empresa ';
			--SET @SQL = @SQL + ' and t500.cd_grupo *= t600.cd_grupo ';
			--SET @SQL = @SQL + ' and T100.cd_sequencial_lote = LC.cd_sequencial ';

			SET @SQL
			= @SQL
			+ '  FROM dbo.lote_contratos_contratos_vendedor T100 
            INNER JOIN dbo.DEPENDENTES T200 ON T200.CD_SEQUENCIAL = T100.cd_sequencial_dep
            INNER JOIN dbo.FUNCIONARIO T300 ON T300.cd_funcionario = T200.cd_funcionario_vendedor
            INNER JOIN dbo.ASSOCIADOS T400 ON T400.cd_associado = T200.CD_ASSOCIADO
            INNER JOIN dbo.EMPRESA T500 ON T500.CD_EMPRESA = T500.CD_EMPRESA
            LEFT JOIN dbo.GRUPO T600 ON T600.CD_GRUPO = T500.cd_grupo
            INNER JOIN dbo.lote_contratos LC ON LC.cd_sequencial = T100.cd_sequencial_lote';



			IF (@nm_equipe <> '')
			BEGIN
				SET @SQL = @SQL + ' INNER JOIN dbo.equipe_vendas T900 ON T300.cd_equipe = T900.cd_equipe ';
				SET @SQL = @SQL + ' And t900.nm_equipe like''' + @nm_equipe + ''' ';
			END;
			ELSE
			BEGIN
				SET @SQL = @SQL + ' LEFT JOIN dbo.equipe_vendas T900 ON T300.cd_equipe = T900.cd_equipe ';
			END;


			SET @SQL = @SQL + ' WHERE ';

			IF (@ConfigBusca = 1)
			BEGIN
				SET @SQL
				= @SQL + ' T100.dt_cadastro between ''' + CONVERT(VARCHAR(10), @DT_Inicial, 101) + ''' And '''
				+ CONVERT(VARCHAR(10), @DT_Final, 101) + ' 23:59''';
			END;
			ELSE
			BEGIN
				SET @SQL
				= @SQL + ' And T100.dt_assinaturaContrato between ''' + CONVERT(VARCHAR(10), @DT_Inicial, 101)
				+ ''' And ''' + CONVERT(VARCHAR(10), @DT_Final, 101) + ' 23:59''';
			END;


			/*ESSE BLOCO FOI COMENTADO POR CONTA DO AND NO INICIO DA CONSULTA, O MESMO FOI RETIRADO*/
			--IF (@ConfigBusca = 1)
			--BEGIN
			--    SET @SQL
			--        = @SQL + ' And T100.dt_cadastro between ''' + CONVERT(VARCHAR(10), @DT_Inicial, 101) + ''' And '''
			--          + CONVERT(VARCHAR(10), @DT_Final, 101) + ' 23:59''';
			--END;
			--ELSE
			--BEGIN
			--    SET @SQL
			--        = @SQL + ' And T100.dt_assinaturaContrato between ''' + CONVERT(VARCHAR(10), @DT_Inicial, 101)
			--          + ''' And ''' + CONVERT(VARCHAR(10), @DT_Final, 101) + ' 23:59''';
			--END;

			IF (@cpfvendedor <> '')
			BEGIN
				SET @SQL = @SQL + ' And T300.nr_cpf = ''' + @cpfvendedor + '''';
			END;

			IF (@equipe > 0)
			BEGIN
				--SET @SQL = @SQL + ' And case when LC.cd_empresa is null then isnull(LC.cd_equipe,T300.cd_equipe) else T300.cd_equipe end = ' + convert(VARCHAR, @equipe)
				SET @SQL = @SQL + ' And T300.cd_equipe = ' + CONVERT(VARCHAR, @equipe);
			END;

			IF (@vendedor > 0)
			BEGIN
				SET @SQL = @SQL + ' And T300.cd_funcionario = ' + CONVERT(VARCHAR, @vendedor);
			END;

			IF (@chefe > 0)
			BEGIN
				--SET @SQL = @SQL + ' and case when LC.cd_empresa is null then isnull(LC.cd_equipe,T300.cd_equipe) else T300.cd_equipe end in (select eq.cd_equipe from equipe_vendas eq where eq.cd_chefe = ' + convert(VARCHAR, @chefe) + ' or cd_chefe1 = ' + convert(VARCHAR, @chefe) + ' or cd_chefe2 = ' + convert(VARCHAR, @chefe) + ')'
				SET @SQL
				= @SQL + ' and T300.cd_equipe in (select eq.cd_equipe from equipe_vendas eq where eq.cd_chefe = '
				+ CONVERT(VARCHAR, @chefe) + ' or cd_chefe1 = ' + CONVERT(VARCHAR, @chefe) + ' or cd_chefe2 = '
				+ CONVERT(VARCHAR, @chefe) + ')';
			END;

			IF (@plano <> '')
			BEGIN
				SET @SQL = @SQL + ' and T200.cd_plano in (' + @plano + ')';
			END;

			IF (@tipoEmpresa <> '')
			BEGIN
				SET @SQL = @SQL + ' and T500.tp_empresa in (' + @tipoEmpresa + ')';
			END;

			IF (@tipoPagamento <> '')
			BEGIN
				SET @SQL = @SQL + ' and T500.cd_tipo_pagamento in (' + @tipoPagamento + ')';
			END;

			--##TIPORECEBIMENTO##
			IF (@tipoRecebimento <> '')
			BEGIN
				SET @SQL
				= @SQL
				+ 'and (select count(0)                                 
							from mensalidades_planos t1000,                     
								 mensalidades t2000                             
							where t1000.cd_sequencial_dep = t100.cd_sequencial_dep 
							and t2000.cd_parcela = t1000.cd_parcela_mensalidade 
							and t2000.cd_tipo_recebimento in(' + @tipoRecebimento + ') 
							) > 0 ';
			END;

			IF (@grupoEmpresa > 0)
			BEGIN
				SET @SQL = @SQL + ' and T500.cd_grupo = ' + CONVERT(VARCHAR, @grupoEmpresa);
			END;

			IF (@centroCusto > 0)
			BEGIN
				SET @SQL = @SQL + ' and T500.cd_centro_custo = ' + CONVERT(VARCHAR, @centroCusto);
			END;

			IF (@situacao <> '')
			BEGIN
				SET @SQL
				= @SQL
				+ ' and (select top 1 cd_situacao from historico where cd_sequencial_dep = T200.cd_sequencial order by convert(date,dt_situacao) desc, cd_sequencial desc) in ('
				+ @situacao + ')';
			END;

			--IF (@nm_equipe <> '')
			--BEGIN
			--    SET @SQL = @SQL + ' And t900.nm_equipe like''' + @nm_equipe + ''' ';
			--    SET @SQL = @SQL + ' And T300.cd_equipe = t900.cd_equipe ';
			--END;
			--ELSE
			--BEGIN
			--    SET @SQL = @SQL + ' And T300.cd_equipe *= t900.cd_equipe ';
			--END;

			IF (@adesionista > 0)
			BEGIN
				SET @SQL = @SQL + ' AND T200.cd_funcionario_adesionista = ' + CONVERT(VARCHAR, @adesionista);
			END;

			SET @SQL = @SQL + ' ) As vl_total ';
			--SET @SQL
			--    = @SQL
			--      + ' from funcionario f, lote_contratos_contratos_vendedor as l, 
			--      DEPENDENTES as d, ASSOCIADOS as a, PLANOS as p, EMPRESA as e, GRUPO as g, 
			--      lote_contratos LC, uf, municipio mu, Equipe_Vendas ev ';

			SET @SQL
			= @SQL
			+ ' FROM 
                  dbo.lote_contratos_contratos_vendedor L 
                  INNER JOIN dbo.DEPENDENTES D ON D.CD_SEQUENCIAL = L.cd_sequencial_dep
                  INNER JOIN dbo.PLANOS P ON D.cd_plano = P.cd_plano
                  INNER JOIN dbo.ASSOCIADOS A ON A.cd_associado = D.CD_ASSOCIADO
                  INNER JOIN dbo.EMPRESA E ON A.cd_empresa = E.CD_EMPRESA
                  LEFT JOIN dbo.GRUPO G ON G.CD_GRUPO = E.cd_grupo
                  LEFT JOIN dbo.FUNCIONARIO F ON F.cd_funcionario = D.cd_funcionario_vendedor
                  INNER JOIN dbo.lote_contratos LC ON LC.cd_sequencial = L.cd_sequencial_lote
                  INNER JOIN dbo.MUNICIPIO MU ON MU.CD_MUNICIPIO = A.CidID';


			IF (@uf <> -1)
			BEGIN
				SET @SQL = @SQL + ' INNER JOIN dbo.UF ON UF.ufId = A.ufId ';
				SET @SQL = @SQL + ' and uf.ufid = ' + CONVERT(VARCHAR, @uf) + '';
			END;
			ELSE
			BEGIN
				SET @SQL = @SQL + ' LEFT JOIN dbo.UF ON UF.ufId = A.ufId ';
			END;

			IF (@municipio <> -1)
			BEGIN
				SET @SQL = @SQL + ' INNER JOIN dbo.MUNICIPIO MU ON MU.CD_MUNICIPIO = A.CidID ';
				SET @SQL = @SQL + ' And mu.cd_municipio = ' + CONVERT(VARCHAR, @municipio);
			END;
			ELSE
			BEGIN
				SET @SQL = @SQL + ' LEFT JOIN dbo.MUNICIPIO MU ON MU.CD_MUNICIPIO = A.CidID ';
			END;






			IF (@ConfigBusca = 1)
			BEGIN
				SET @SQL
				= @SQL + ' where l.dt_cadastro between ''' + CONVERT(VARCHAR(10), @DT_Inicial, 101) + ''' And '''
				+ CONVERT(VARCHAR(10), @DT_Final, 101) + ' 23:59'' and ';
			END;
			ELSE
			BEGIN
				SET @SQL
				= @SQL + ' where l.dt_assinaturaContrato between ''' + CONVERT(VARCHAR(10), @DT_Inicial, 101)
				+ ''' And ''' + CONVERT(VARCHAR(10), @DT_Final, 101) + ' 23:59'' and ';
			END;

			--SET @SQL = @SQL + ' l.cd_sequencial_dep = d.CD_SEQUENCIAL ';
			--SET @SQL = @SQL + ' and d.cd_plano = p.cd_plano ';
			--SET @SQL = @SQL + ' and d.CD_ASSOCIADO = a.cd_associado ';
			--SET @SQL = @SQL + ' and a.cd_empresa = e.CD_EMPRESA ';
			--SET @SQL = @SQL + ' and e.cd_grupo *= g.cd_grupo ';
			--SET @SQL = @SQL + ' and f.cd_funcionario *= d.cd_funcionario_vendedor ';
			--SET @SQL = @SQL + ' and l.cd_sequencial_lote = LC.cd_sequencial ';

			--IF (@uf <> -1)
			--BEGIN
			--    SET @SQL = @SQL + ' and a.ufid = uf.ufid ';
			--    SET @SQL = @SQL + ' and uf.ufid = ' + CONVERT(VARCHAR, @uf) + '';
			--END;
			--ELSE
			--BEGIN
			--    SET @SQL = @SQL + ' and a.ufid *= uf.ufid ';
			--END;

			--IF (@municipio <> -1)
			--BEGIN
			--    SET @SQL = @SQL + ' and a.cidid = mu.cd_municipio ';
			--    SET @SQL = @SQL + ' And mu.cd_municipio = ' + CONVERT(VARCHAR, @municipio);
			--END;
			--ELSE
			--BEGIN
			--    SET @SQL = @SQL + ' and a.cidid *= mu.cd_municipio ';
			--END;

			IF (@cpfvendedor <> '')
			BEGIN
				SET @SQL = @SQL + ' And f.nr_cpf = ''' + @cpfvendedor + '''';
			END;

			IF (@equipe > 0)
			BEGIN
				--SET @SQL = @SQL + ' And case when LC.cd_empresa is null then isnull(LC.cd_equipe,f.cd_equipe) else f.cd_equipe end = ' + convert(VARCHAR, @equipe)
				SET @SQL = @SQL + ' And f.cd_equipe = ' + CONVERT(VARCHAR, @equipe);
			END;

			IF (@vendedor > 0)
			BEGIN
				SET @SQL = @SQL + ' and d.cd_funcionario_vendedor = ' + CONVERT(VARCHAR, @vendedor);
			END;

			IF (@chefe > 0)
			BEGIN
				--SET @SQL = @SQL + ' and case when LC.cd_empresa is null then isnull(LC.cd_equipe,f.cd_equipe) else f.cd_equipe end in (select eq.cd_equipe from equipe_vendas eq where eq.cd_chefe = ' + convert(VARCHAR, @chefe) + ' or cd_chefe1 = ' + convert(VARCHAR, @chefe) + ' or cd_chefe2 = ' + convert(VARCHAR, @chefe) + ')'
				SET @SQL
				= @SQL + ' and f.cd_equipe in (select eq.cd_equipe from equipe_vendas eq where eq.cd_chefe = '
				+ CONVERT(VARCHAR, @chefe) + ' or cd_chefe1 = ' + CONVERT(VARCHAR, @chefe) + ' or cd_chefe2 = '
				+ CONVERT(VARCHAR, @chefe) + ')';
			END;

			IF (@plano <> '')
			BEGIN
				SET @SQL = @SQL + ' and d.cd_plano in (' + @plano + ')';
			END;

			IF (@tipoEmpresa <> '')
			BEGIN
				SET @SQL = @SQL + ' and e.tp_empresa in (' + @tipoEmpresa + ')';
			END;

			IF (@tipoPagamento <> '')
			BEGIN
				SET @SQL = @SQL + ' and e.cd_tipo_pagamento in (' + @tipoPagamento + ')';
			END;

			--##TIPORECEBIMENTO##
			IF (@tipoRecebimento <> '')
			BEGIN
				SET @SQL
				= @SQL
				+ 'and (select count(0)                                 
							from mensalidades_planos t1000,                     
								 mensalidades t2000                             
							where t1000.cd_sequencial_dep = l.cd_sequencial_dep 
							and t2000.cd_parcela = t1000.cd_parcela_mensalidade 
							and t2000.cd_tipo_recebimento in(' + @tipoRecebimento + ') 
							) > 0 ';
			END;

			IF (@grupoEmpresa > 0)
			BEGIN
				SET @SQL = @SQL + ' and e.cd_grupo = ' + CONVERT(VARCHAR, @grupoEmpresa);
			END;

			IF (@centroCusto > 0)
			BEGIN
				SET @SQL = @SQL + ' and e.cd_centro_custo = ' + CONVERT(VARCHAR, @centroCusto);
			END;

			IF (@situacao <> '')
			BEGIN
				SET @SQL
				= @SQL
				+ ' and (select top 1 cd_situacao from historico where cd_sequencial_dep = d.cd_sequencial order by convert(date,dt_situacao) desc, cd_sequencial desc) in ('
				+ @situacao + ')';
			END;

			--IF (@nm_equipe <> '')
			--BEGIN
			--    SET @SQL = @SQL + ' And ev.nm_equipe like''' + @nm_equipe + ''' ';
			--    SET @SQL = @SQL + ' And f.cd_equipe = ev.cd_equipe ';
			--END;
			--ELSE
			--BEGIN
			--    SET @SQL = @SQL + ' And f.cd_equipe *= ev.cd_equipe ';
			--END;

			IF (@adesionista > 0)
			BEGIN
				SET @SQL = @SQL + ' And d.cd_funcionario_adesionista = ' + CONVERT(VARCHAR, @adesionista);
			END;

			SET @SQL = @SQL + ' group by g.cd_grupo , g.nm_grupo ';
			SET @SQL = @SQL + ' order by 3 desc ';
		END;

		IF @tipo = 5
		BEGIN
			SET @SQL = @SQL + ' select cc.cd_centro_custo, cc.ds_centro_custo, COUNT(0), SUM(l.vl_contrato), ';
			--Qtde Contratos
			SET @SQL = @SQL + ' (Select Count(distinct T400.cd_associado) ';
			--SET @SQL
			--    = @SQL
			--      + ' From lote_contratos_contratos_vendedor T100, Dependentes T200 , 
			--      Funcionario T300 , associados t400, empresa t500, Centro_Custo t600, 
			--      lote_contratos LC, Equipe_Vendas t900 ';
			--SET @SQL = @SQL + ' Where T100.cd_sequencial_dep = T200.cd_sequencial ';
			--SET @SQL = @SQL + ' And T200.cd_funcionario_vendedor = T300.cd_funcionario ';
			--SET @SQL = @SQL + ' And t200.cd_associado = t400.cd_associado ';
			--SET @SQL = @SQL + ' and t400.cd_empresa = t500.cd_empresa ';
			--SET @SQL = @SQL + ' and t500.cd_centro_custo = t600.cd_centro_custo ';
			--SET @SQL = @SQL + ' and t600.cd_centro_custo = cc.cd_centro_custo ';
			--SET @SQL = @SQL + ' and T200.cd_grau_parentesco = 1 ';
			--SET @SQL = @SQL + ' and T100.cd_sequencial_lote = LC.cd_sequencial ';

			SET @SQL = @SQL + ' FROM dbo.lote_contratos_contratos_vendedor T100
            INNER JOIN dbo.DEPENDENTES T200 ON T200.CD_SEQUENCIAL = T100.cd_sequencial_dep AND T200.CD_GRAU_PARENTESCO =1
            INNER JOIN dbo.FUNCIONARIO T300 ON T200.cd_funcionario_vendedor = T300.cd_funcionario
            INNER JOIN dbo.ASSOCIADOS T400 ON T400.cd_associado = T200.CD_ASSOCIADO
            INNER JOIN dbo.EMPRESA T500 ON T400.cd_empresa = T500.CD_EMPRESA
            INNER JOIN dbo.Centro_Custo T600 ON T500.cd_centro_custo = T600.cd_centro_custo AND T600.cd_centro_custo = CC.CD_CENTRO_CUSTO
            INNER JOIN dbo.lote_contratos LC ON LC.cd_sequencial = T100.cd_sequencial_lote'



			IF (@nm_equipe <> '')
			BEGIN
				SET @SQL = @SQL + ' INNER JOIN dbo.equipe_vendas T900 ON T300.cd_equipe = T900.cd_equipe ';
				SET @SQL = @SQL + ' And t900.nm_equipe like''' + @nm_equipe + ''' ';
			END;
			ELSE
			BEGIN
				SET @SQL = @SQL + ' LEFT JOIN dbo.equipe_vendas T900 ON T300.cd_equipe = T900.cd_equipe';
			END

			SET @SQL = @SQL + ' WHERE '

			IF (@ConfigBusca = 1)
			BEGIN
				SET @SQL
				= @SQL + '  T100.dt_cadastro between ''' + CONVERT(VARCHAR(10), @DT_Inicial, 101) + ''' And '''
				+ CONVERT(VARCHAR(10), @DT_Final, 101) + ' 23:59''';
			END;
			ELSE
			BEGIN
				SET @SQL
				= @SQL + ' And T100.dt_assinaturaContrato between ''' + CONVERT(VARCHAR(10), @DT_Inicial, 101)
				+ ''' And ''' + CONVERT(VARCHAR(10), @DT_Final, 101) + ' 23:59''';
			END;


			--IF (@ConfigBusca = 1)
			--BEGIN
			--    SET @SQL
			--        = @SQL + ' And T100.dt_cadastro between ''' + CONVERT(VARCHAR(10), @DT_Inicial, 101) + ''' And '''
			--          + CONVERT(VARCHAR(10), @DT_Final, 101) + ' 23:59''';
			--END;
			--ELSE
			--BEGIN
			--    SET @SQL
			--        = @SQL + ' And T100.dt_assinaturaContrato between ''' + CONVERT(VARCHAR(10), @DT_Inicial, 101)
			--          + ''' And ''' + CONVERT(VARCHAR(10), @DT_Final, 101) + ' 23:59''';
			--END;

			IF (@cpfvendedor <> '')
			BEGIN
				SET @SQL = @SQL + ' And T300.nr_cpf = ''' + @cpfvendedor + '''';
			END;

			IF (@equipe > 0)
			BEGIN
				--SET @SQL = @SQL + ' And case when LC.cd_empresa is null then isnull(LC.cd_equipe,T300.cd_equipe) else T300.cd_equipe end = ' + convert(VARCHAR, @equipe)
				SET @SQL = @SQL + ' And T300.cd_equipe = ' + CONVERT(VARCHAR, @equipe);
			END;

			IF (@vendedor > 0)
			BEGIN
				SET @SQL = @SQL + ' And T300.cd_funcionario = ' + CONVERT(VARCHAR, @vendedor);
			END;

			IF (@chefe > 0)
			BEGIN
				--SET @SQL = @SQL + ' and case when LC.cd_empresa is null then isnull(LC.cd_equipe,T300.cd_equipe) else T300.cd_equipe end in (select eq.cd_equipe from equipe_vendas eq where eq.cd_chefe = ' + convert(VARCHAR, @chefe) + ' or cd_chefe1 = ' + convert(VARCHAR, @chefe) + ' or cd_chefe2 = ' + convert(VARCHAR, @chefe) + ')'
				SET @SQL
				= @SQL + ' and T300.cd_equipe in (select eq.cd_equipe from equipe_vendas eq where eq.cd_chefe = '
				+ CONVERT(VARCHAR, @chefe) + ' or cd_chefe1 = ' + CONVERT(VARCHAR, @chefe) + ' or cd_chefe2 = '
				+ CONVERT(VARCHAR, @chefe) + ')';
			END;

			IF (@plano <> '')
			BEGIN
				SET @SQL = @SQL + ' and T200.cd_plano in (' + @plano + ')';
			END;

			IF (@tipoEmpresa <> '')
			BEGIN
				SET @SQL = @SQL + ' and T500.tp_empresa in (' + @tipoEmpresa + ')';
			END;

			IF (@tipoPagamento <> '')
			BEGIN
				SET @SQL = @SQL + ' and T500.cd_tipo_pagamento in (' + @tipoPagamento + ')';
			END;

			--##TIPORECEBIMENTO##
			IF (@tipoRecebimento <> '')
			BEGIN
				SET @SQL
				= @SQL
				+ 'and (select count(0)                                 
							from mensalidades_planos t1000,                     
								 mensalidades t2000                             
							where t1000.cd_sequencial_dep = t100.cd_sequencial_dep 
							and t2000.cd_parcela = t1000.cd_parcela_mensalidade 
							and t2000.cd_tipo_recebimento in(' + @tipoRecebimento + ') 
							) > 0 ';
			END;

			IF (@grupoEmpresa > 0)
			BEGIN
				SET @SQL = @SQL + ' and T500.cd_grupo = ' + CONVERT(VARCHAR, @grupoEmpresa);
			END;

			IF (@centroCusto > 0)
			BEGIN
				SET @SQL = @SQL + ' and T500.cd_centro_custo = ' + CONVERT(VARCHAR, @centroCusto);
			END;

			IF (@situacao <> '')
			BEGIN
				SET @SQL
				= @SQL
				+ ' and (select top 1 cd_situacao from historico where cd_sequencial_dep = T200.cd_sequencial order by convert(date,dt_situacao) desc, cd_sequencial desc) in ('
				+ @situacao + ')';
			END;

			--IF (@nm_equipe <> '')
			--BEGIN
			--    SET @SQL = @SQL + ' And t900.nm_equipe like''' + @nm_equipe + ''' ';
			--    SET @SQL = @SQL + ' And T300.cd_equipe = t900.cd_equipe ';
			--END;
			--ELSE
			--BEGIN
			--    SET @SQL = @SQL + ' And T300.cd_equipe *= t900.cd_equipe ';
			--END;

			IF (@adesionista > 0)
			BEGIN
				SET @SQL = @SQL + ' AND T200.cd_funcionario_adesionista = ' + CONVERT(VARCHAR, @adesionista);
			END;

			SET @SQL = @SQL + ' ) As contratos ';
			--Valor total
			SET @SQL = @SQL + ' , (Select SUM(isnull(T100.vl_contrato,0)) ';
			--SET @SQL
			--    = @SQL
			--      + ' From lote_contratos_contratos_vendedor T100, Dependentes T200 , Funcionario T300 ,
			--      associados t400, empresa t500, Centro_Custo t600, lote_contratos LC, Equipe_Vendas t900 ';
			--SET @SQL = @SQL + ' Where T100.cd_sequencial_dep = T200.cd_sequencial ';
			--SET @SQL = @SQL + ' And T200.cd_funcionario_vendedor = T300.cd_funcionario ';
			--SET @SQL = @SQL + ' And t200.cd_associado = t400.cd_associado ';
			--SET @SQL = @SQL + ' and t400.cd_empresa = t500.cd_empresa ';
			--SET @SQL = @SQL + ' and t500.cd_centro_custo = t600.cd_centro_custo ';
			--SET @SQL = @SQL + ' and T100.cd_sequencial_lote = LC.cd_sequencial ';
			
			SET @SQL = @SQL +'

			FROM dbo.lote_contratos_contratos_vendedor T100
			INNER JOIN dbo.DEPENDENTES T200
				ON T200.CD_SEQUENCIAL = T100.cd_sequencial_dep
			INNER JOIN dbo.FUNCIONARIO T300
				ON T200.cd_funcionario_vendedor = T300.cd_funcionario
			INNER JOIN dbo.ASSOCIADOS T400
				ON T400.cd_associado = T200.CD_ASSOCIADO
			INNER JOIN dbo.EMPRESA T500
				ON T400.cd_empresa = T500.CD_EMPRESA
			INNER JOIN dbo.Centro_Custo T600
				ON T500.cd_centro_custo = T600.cd_centro_custo
			INNER JOIN dbo.lote_contratos LC
				ON LC.cd_sequencial = T100.cd_sequencial_lote
			INNER JOIN dbo.MUNICIPIO MU
				ON A.CIDID = MU.CD_MUNICIPIO'



			IF (@nm_equipe <> '')
			BEGIN
				SET @SQL = @SQL + ' INNER JOIN dbo.equipe_vendas T900 ON T300.cd_equipe = T900.cd_equipe';
				SET @SQL = @SQL + ' And t900.nm_equipe like''' + @nm_equipe + ''' ';
			END;
			ELSE
			BEGIN
				SET @SQL = @SQL + ' LEFT JOIN dbo.equipe_vendas T900 ON T300.cd_equipe = T900.cd_equipe ';
			END;

			IF (@uf <> -1)
			BEGIN
				SET @SQL = @SQL + ' INNER JOIN dbo.UF ON A.UFID = UF.ufId ';
				SET @SQL = @SQL + ' and uf.ufid = ' + CONVERT(VARCHAR, @uf) + '';
			END;
			ELSE
			BEGIN
				SET @SQL = @SQL + ' LEFT JOIN dbo.UF ON A.UFID = UF.ufId ';
			END;

			IF (@municipio <> -1)
			BEGIN
				SET @SQL = @SQL + ' INNER JOIN dbo.MUNICIPIO MU ON A.CIDID = MU.CD_MUNICIPIO ';
				SET @SQL = @SQL + ' And mu.cd_municipio = ' + CONVERT(VARCHAR, @municipio);
			END;
			ELSE
			BEGIN
				SET @SQL = @SQL + ' LEFT JOIN dbo.MUNICIPIO MU ON A.CIDID = MU.CD_MUNICIPIO ';
			END;

			IF (@nm_equipe <> '')
			BEGIN
				SET @SQL = @SQL + ' INNER JOIN dbo.equipe_vendas EV ON F.CD_EQUIPE = EV.cd_equipe ';
				SET @SQL = @SQL + ' And ev.nm_equipe like''' + @nm_equipe + ''' ';

			END;
			ELSE
			BEGIN
				SET @SQL = @SQL + ' LEFT JOIN dbo.equipe_vendas EV ON F.CD_EQUIPE = EV.cd_equipe ';
			END;



			SET @SQL = @SQL + ' WHERE '



			IF (@ConfigBusca = 1)
			BEGIN
				SET @SQL
				= @SQL + '  T100.dt_cadastro between ''' + CONVERT(VARCHAR(10), @DT_Inicial, 101) + ''' And '''
				+ CONVERT(VARCHAR(10), @DT_Final, 101) + ' 23:59''';
			END;
			ELSE
			BEGIN
				SET @SQL
				= @SQL + ' And T100.dt_assinaturaContrato between ''' + CONVERT(VARCHAR(10), @DT_Inicial, 101)
				+ ''' And ''' + CONVERT(VARCHAR(10), @DT_Final, 101) + ' 23:59''';
			END;

			--IF (@ConfigBusca = 1)
			--BEGIN
			--    SET @SQL
			--        = @SQL + ' And T100.dt_cadastro between ''' + CONVERT(VARCHAR(10), @DT_Inicial, 101) + ''' And '''
			--          + CONVERT(VARCHAR(10), @DT_Final, 101) + ' 23:59''';
			--END;
			--ELSE
			--BEGIN
			--    SET @SQL
			--        = @SQL + ' And T100.dt_assinaturaContrato between ''' + CONVERT(VARCHAR(10), @DT_Inicial, 101)
			--          + ''' And ''' + CONVERT(VARCHAR(10), @DT_Final, 101) + ' 23:59''';
			--END;

			IF (@cpfvendedor <> '')
			BEGIN
				SET @SQL = @SQL + ' And T300.nr_cpf = ''' + @cpfvendedor + '''';
			END;

			IF (@equipe > 0)
			BEGIN
				--SET @SQL = @SQL + ' And case when LC.cd_empresa is null then isnull(LC.cd_equipe,T300.cd_equipe) else T300.cd_equipe end = ' + convert(VARCHAR, @equipe)
				SET @SQL = @SQL + ' And T300.cd_equipe = ' + CONVERT(VARCHAR, @equipe);
			END;

			IF (@vendedor > 0)
			BEGIN
				SET @SQL = @SQL + ' And T300.cd_funcionario = ' + CONVERT(VARCHAR, @vendedor);
			END;

			IF (@chefe > 0)
			BEGIN
				--SET @SQL = @SQL + ' and case when LC.cd_empresa is null then isnull(LC.cd_equipe,T300.cd_equipe) else T300.cd_equipe end in (select eq.cd_equipe from equipe_vendas eq where eq.cd_chefe = ' + convert(VARCHAR, @chefe) + ' or cd_chefe1 = ' + convert(VARCHAR, @chefe) + ' or cd_chefe2 = ' + convert(VARCHAR, @chefe) + ')'
				SET @SQL
				= @SQL + ' and T300.cd_equipe in (select eq.cd_equipe from equipe_vendas eq where eq.cd_chefe = '
				+ CONVERT(VARCHAR, @chefe) + ' or cd_chefe1 = ' + CONVERT(VARCHAR, @chefe) + ' or cd_chefe2 = '
				+ CONVERT(VARCHAR, @chefe) + ')';
			END;

			IF (@plano <> '')
			BEGIN
				SET @SQL = @SQL + ' and T200.cd_plano in (' + @plano + ')';
			END;

			IF (@tipoEmpresa <> '')
			BEGIN
				SET @SQL = @SQL + ' and T500.tp_empresa in (' + @tipoEmpresa + ')';
			END;

			IF (@tipoPagamento <> '')
			BEGIN
				SET @SQL = @SQL + ' and T500.cd_tipo_pagamento in (' + @tipoPagamento + ')';
			END;

			--##TIPORECEBIMENTO##
			IF (@tipoRecebimento <> '')
			BEGIN
				SET @SQL
				= @SQL
				+ 'and (select count(0)                                 
							from mensalidades_planos t1000,                     
								 mensalidades t2000                             
							where t1000.cd_sequencial_dep = t100.cd_sequencial_dep 
							and t2000.cd_parcela = t1000.cd_parcela_mensalidade 
							and t2000.cd_tipo_recebimento in(' + @tipoRecebimento + ') 
							) > 0 ';
			END;

			IF (@grupoEmpresa > 0)
			BEGIN
				SET @SQL = @SQL + ' and T500.cd_grupo = ' + CONVERT(VARCHAR, @grupoEmpresa);
			END;

			IF (@centroCusto > 0)
			BEGIN
				SET @SQL = @SQL + ' and T500.cd_centro_custo = ' + CONVERT(VARCHAR, @centroCusto);
			END;

			IF (@situacao <> '')
			BEGIN
				SET @SQL
				= @SQL
				+ ' and (select top 1 cd_situacao from historico where cd_sequencial_dep = T200.cd_sequencial order by convert(date,dt_situacao) desc, cd_sequencial desc) in ('
				+ @situacao + ')';
			END;

			--IF (@nm_equipe <> '')
			--BEGIN
			--    SET @SQL = @SQL + ' And t900.nm_equipe like''' + @nm_equipe + ''' ';
			--    SET @SQL = @SQL + ' And T300.cd_equipe = t900.cd_equipe ';
			--END;
			--ELSE
			--BEGIN
			--    SET @SQL = @SQL + ' And T300.cd_equipe *= t900.cd_equipe ';
			--END;

			IF (@adesionista > 0)
			BEGIN
				SET @SQL = @SQL + ' AND T200.cd_funcionario_adesionista = ' + CONVERT(VARCHAR, @adesionista);
			END;

			SET @SQL = @SQL + ' ) As vl_total ';


			--SET @SQL
			--    = @SQL
			--      + ' from funcionario f, lote_contratos_contratos_vendedor as l, 
			--      DEPENDENTES as d, ASSOCIADOS as a, PLANOS as p, EMPRESA as e, 
			--      Centro_Custo as cc, lote_contratos LC, uf, municipio mu, Equipe_Vendas ev ';

			--       SET @SQL = @SQL + ' l.cd_sequencial_dep = d.CD_SEQUENCIAL ';
			--SET @SQL = @SQL + ' and d.cd_plano = p.cd_plano ';
			--SET @SQL = @SQL + ' and d.CD_ASSOCIADO = a.cd_associado ';
			--SET @SQL = @SQL + ' and a.cd_empresa = e.CD_EMPRESA ';
			--SET @SQL = @SQL + ' and e.cd_centro_custo = cc.cd_centro_custo ';
			--SET @SQL = @SQL + ' and f.cd_funcionario *= d.cd_funcionario_vendedor ';
			--SET @SQL = @SQL + ' and l.cd_sequencial_lote = LC.cd_sequencial ';





			SET @SQL = @SQL + ' FROM dbo.lote_contratos_contratos_vendedor l INNER JOIN dbo.DEPENDENTES d
                   ON d.CD_SEQUENCIAL = l.cd_sequencial_dep
                   INNER JOIN dbo.PLANOS p ON p.cd_plano = d.cd_plano
                   INNER JOIN dbo.ASSOCIADOS a ON a.cd_associado = d.CD_ASSOCIADO
                   INNER JOIN dbo.EMPRESA e ON a.cd_empresa = e.CD_EMPRESA
                   INNER JOIN dbo.Centro_Custo cc ON e.cd_centro_custo = cc.cd_centro_custo
                   LEFT JOIN dbo.FUNCIONARIO f ON f.cd_funcionario = d.cd_funcionario_vendedor
                   INNER JOIN dbo.lote_contratos lc ON lc.cd_sequencial = l.cd_sequencial_lote '




			IF (@uf <> -1)
			BEGIN
				SET @SQL = @SQL + ' INNER JOIN dbo.UF ON UF.ufId = a.ufId ';
				SET @SQL = @SQL + ' and uf.ufid = ' + CONVERT(VARCHAR, @uf) + '';
			END;
			ELSE
			BEGIN
				SET @SQL = @SQL + ' LEFT JOIN dbo.UF ON UF.ufId = a.ufId ';
			END;

			IF (@municipio <> -1)
			BEGIN
				SET @SQL = @SQL + ' INNER JOIN dbo.MUNICIPIO mu ON mu.CD_MUNICIPIO = a.CidID ';
				SET @SQL = @SQL + ' And mu.cd_municipio = ' + CONVERT(VARCHAR, @municipio);
			END;
			ELSE
			BEGIN
				SET @SQL = @SQL + ' LEFT JOIN dbo.MUNICIPIO mu ON mu.CD_MUNICIPIO = a.CidID ';
			END;


			IF (@nm_equipe <> '')
			BEGIN
				SET @SQL = @SQL + ' INNER JOIN dbo.equipe_vendas EV ON F.cd_equipe = EV.cd_equipe ';
				SET @SQL = @SQL + ' And ev.nm_equipe like''' + @nm_equipe + ''' ';
			END;
			ELSE
			BEGIN
				SET @SQL = @SQL + ' LEFT JOIN dbo.equipe_vendas EV ON F.cd_equipe = EV.cd_equipe ';
			END;



			IF (@ConfigBusca = 1)
			BEGIN
				SET @SQL
				= @SQL + ' where l.dt_cadastro between ''' + CONVERT(VARCHAR(10), @DT_Inicial, 101) + ''' And '''
				+ CONVERT(VARCHAR(10), @DT_Final, 101) + ' 23:59'' and ';
			END;
			ELSE
			BEGIN
				SET @SQL
				= @SQL + ' where l.dt_assinaturaContrato between ''' + CONVERT(VARCHAR(10), @DT_Inicial, 101)
				+ ''' And ''' + CONVERT(VARCHAR(10), @DT_Final, 101) + ' 23:59'' and ';
			END;

			--SET @SQL = @SQL + ' l.cd_sequencial_dep = d.CD_SEQUENCIAL ';
			--SET @SQL = @SQL + ' and d.cd_plano = p.cd_plano ';
			--SET @SQL = @SQL + ' and d.CD_ASSOCIADO = a.cd_associado ';
			--SET @SQL = @SQL + ' and a.cd_empresa = e.CD_EMPRESA ';
			--SET @SQL = @SQL + ' and e.cd_centro_custo = cc.cd_centro_custo ';
			--SET @SQL = @SQL + ' and f.cd_funcionario *= d.cd_funcionario_vendedor ';
			--SET @SQL = @SQL + ' and l.cd_sequencial_lote = LC.cd_sequencial ';

			--IF (@uf <> -1)
			--BEGIN
			--    SET @SQL = @SQL + ' and a.ufid = uf.ufid ';
			--    SET @SQL = @SQL + ' and uf.ufid = ' + CONVERT(VARCHAR, @uf) + '';
			--END;
			--ELSE
			--BEGIN
			--    SET @SQL = @SQL + ' and a.ufid *= uf.ufid ';
			--END;

			--IF (@municipio <> -1)
			--BEGIN
			--    SET @SQL = @SQL + ' and a.cidid = mu.cd_municipio ';
			--    SET @SQL = @SQL + ' And mu.cd_municipio = ' + CONVERT(VARCHAR, @municipio);
			--END;
			--ELSE
			--BEGIN
			--    SET @SQL = @SQL + ' and a.cidid *= mu.cd_municipio ';
			--END;

			IF (@cpfvendedor <> '')
			BEGIN
				SET @SQL = @SQL + ' And f.nr_cpf = ''' + @cpfvendedor + '''';
			END;

			IF (@equipe > 0)
			BEGIN
				--SET @SQL = @SQL + ' And case when LC.cd_empresa is null then isnull(LC.cd_equipe,f.cd_equipe) else f.cd_equipe end = ' + convert(VARCHAR, @equipe)
				SET @SQL = @SQL + ' And f.cd_equipe = ' + CONVERT(VARCHAR, @equipe);
			END;

			IF (@vendedor > 0)
			BEGIN
				SET @SQL = @SQL + ' and d.cd_funcionario_vendedor = ' + CONVERT(VARCHAR, @vendedor);
			END;

			IF (@chefe > 0)
			BEGIN
				--SET @SQL = @SQL + ' and case when LC.cd_empresa is null then isnull(LC.cd_equipe,f.cd_equipe) else f.cd_equipe end in (select eq.cd_equipe from equipe_vendas eq where eq.cd_chefe = ' + convert(VARCHAR, @chefe) + ' or cd_chefe1 = ' + convert(VARCHAR, @chefe) + ' or cd_chefe2 = ' + convert(VARCHAR, @chefe) + ')'
				SET @SQL
				= @SQL + ' and f.cd_equipe in (select eq.cd_equipe from equipe_vendas eq where eq.cd_chefe = '
				+ CONVERT(VARCHAR, @chefe) + ' or cd_chefe1 = ' + CONVERT(VARCHAR, @chefe) + ' or cd_chefe2 = '
				+ CONVERT(VARCHAR, @chefe) + ')';
			END;

			IF (@plano <> '')
			BEGIN
				SET @SQL = @SQL + ' and d.cd_plano in (' + @plano + ')';
			END;

			IF (@tipoEmpresa <> '')
			BEGIN
				SET @SQL = @SQL + ' and e.tp_empresa in (' + @tipoEmpresa + ')';
			END;

			IF (@tipoPagamento <> '')
			BEGIN
				SET @SQL = @SQL + ' and e.cd_tipo_pagamento in (' + @tipoPagamento + ')';
			END;

			--##TIPORECEBIMENTO##
			IF (@tipoRecebimento <> '')
			BEGIN
				SET @SQL
				= @SQL
				+ 'and (select count(0)                                 
							from mensalidades_planos t1000,                     
								 mensalidades t2000                             
							where t1000.cd_sequencial_dep = l.cd_sequencial_dep 
							and t2000.cd_parcela = t1000.cd_parcela_mensalidade 
							and t2000.cd_tipo_recebimento in(' + @tipoRecebimento + ') 
							) > 0 ';
			END;

			IF (@grupoEmpresa > 0)
			BEGIN
				SET @SQL = @SQL + ' and e.cd_grupo = ' + CONVERT(VARCHAR, @grupoEmpresa);
			END;

			IF (@centroCusto > 0)
			BEGIN
				SET @SQL = @SQL + ' and e.cd_centro_custo = ' + CONVERT(VARCHAR, @centroCusto);
			END;

			IF (@situacao <> '')
			BEGIN
				SET @SQL
				= @SQL
				+ ' and (select top 1 cd_situacao from historico where cd_sequencial_dep = d.cd_sequencial order by convert(date,dt_situacao) desc, cd_sequencial desc) in ('
				+ @situacao + ')';
			END;

			--IF (@nm_equipe <> '')
			--BEGIN
			--    SET @SQL = @SQL + ' And ev.nm_equipe like''' + @nm_equipe + ''' ';
			--    SET @SQL = @SQL + ' And f.cd_equipe = ev.cd_equipe ';
			--END;
			--ELSE
			--BEGIN
			--    SET @SQL = @SQL + ' And f.cd_equipe *= ev.cd_equipe ';
			--END;

			IF (@adesionista > 0)
			BEGIN
				SET @SQL = @SQL + ' And d.cd_funcionario_adesionista = ' + CONVERT(VARCHAR, @adesionista);
			END;

			SET @SQL = @SQL + ' group by cc.cd_centro_custo , cc.ds_centro_custo ';
			SET @SQL = @SQL + ' order by 3 desc ';
		END;
	END;


	PRINT @SQL;

	EXEC (@SQL);

END;
