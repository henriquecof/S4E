/****** Object:  Procedure [dbo].[D_Med]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[D_Med] (
		@ano INT,
		@cpf VARCHAR(11) = '',
		@centrocusto VARCHAR(MAX) = '',
		@tipoimpressao INT = -1,
		@cd_empresa INT = -1)
AS
BEGIN

	--*******************************************************************
	--A T E N Ç Ã O !
	--*******************************************************************
	--Cada cliente tem o seu diferente
	--*******************************************************************

	/*
			  @tipoImpressao
			  -1: Geração do arquivo DMED
			  1: Impressao de IR
			  */

	DECLARE @dtini VARCHAR(16)
	DECLARE @dtfim VARCHAR(16)
	DECLARE @sql VARCHAR(MAX)
	DECLARE @licencas4e VARCHAR(50)
	DECLARE @localcentrocustoenviodmed TINYINT --1: centro de custo da empresa, 2: centro de custo do tipo de pagamento
	DECLARE @tipovalorenviodmed TINYINT --1: Valor da parcela, 2: Valor pago (positivo ou negativo)
	DECLARE @tiposistema TINYINT --1: Operadora, 2: Clínica

	SELECT
		@localcentrocustoenviodmed = ISNULL(Localcentrocustoenviodmed, 1),
		@tipovalorenviodmed = ISNULL(Tipovalorenviodmed, 1),
		@licencas4e = Licencas4e,
		@tiposistema = ISNULL(Tsiid, 1)
	FROM Configuracao

	SET @dtini = '01/01/' + CONVERT(VARCHAR(4), @ano) + ' 00:00'
	SET @dtfim = '12/31/' + CONVERT(VARCHAR(4), @ano) + ' 23:59'
	SET @sql = ''

	--*******************************************************************
	--PF
	--*******************************************************************

	IF (@cd_empresa = -1)
	BEGIN
		SET @sql += '
				select
				e.nm_fantasia,
				a.cd_associado,
				a.nr_cpf,
				a.nm_completo,
				d.nr_cpf_dep,
				convert(varchar(10),d.dt_nascimento,103) dt_nascimento,
				d.nm_dependente,
				d.cd_sequencial cd_sequencial_dep,
				g.nm_grau_parentesco,
				isnull(g2.nm_sigla, g.nm_sigla) nm_sigla,
				d.nm_mae_dep,
				'

		IF (@tipoimpressao = -1)
		BEGIN

			IF (@tipovalorenviodmed = 2)
			BEGIN
				SET @sql += ' isnull(sum(isnull(mp.vl_dmed,mp.valorPago)),0) valor, '
			END
			ELSE
			BEGIN
				SET @sql += ' isnull(sum(isnull(mp.vl_dmed,mp.valor)),0) valor, '
			END

		END
		ELSE
		BEGIN

			IF (@tipovalorenviodmed = 2)
			BEGIN
				SET @sql += ' isnull(isnull(mp.vl_dmed,mp.valorPago),0) valor, '
			END
			ELSE
			BEGIN
				SET @sql += ' isnull(isnull(mp.vl_dmed,mp.valor),0) valor, '
			END

		END

		SET @sql += '
				d.dt_nascimento dt_nascimentoOrder,
				case when d.cd_grau_parentesco = 1 then 1 else 0 end Titular,
				(
					select count(distinct d1.cd_sequencial)
					from dependentes d1, associados a1, empresa e1, mensalidades_planos mp1, mensalidades m1, planos p1, tipo_pagamento tp1
					where d1.cd_associado = a1.cd_associado
					and a1.cd_empresa = e1.cd_empresa
					and d1.cd_sequencial = mp1.cd_sequencial_dep
					and mp1.cd_parcela_mensalidade = m1.cd_parcela
					and d1.cd_plano = p1.cd_plano
					and m1.cd_tipo_pagamento = tp1.cd_tipo_pagamento
					and d1.cd_grau_parentesco = 1
					and m1.tp_associado_empresa = 1
					and (isnull(convert(int,e1.enviarDMED),1) = 1 or mp1.vl_dmed > 0)
					and m1.cd_tipo_recebimento > 2
					and mp1.dt_exclusao is null
					and m1.dt_pagamento >= ''' + @dtini + '''
					and m1.dt_pagamento <= ''' + @dtfim + ''' 
					and a1.nr_cpf = a.nr_cpf
					and case when ' + CONVERT(VARCHAR, @tiposistema) + ' = 2 then 0 else (select count(0) from classificacao_ans where IdConvenio is not null and cd_classificacao = p1.cd_classificacao) end = 0
					'

		IF (@tipovalorenviodmed = 2)
		BEGIN
			SET @sql += ' and coalesce(mp1.vl_dmed,mp1.valorPago,0) > 0 '
		END
		ELSE
		BEGIN
			SET @sql += ' and coalesce(mp1.vl_dmed,mp1.valor,0) > 0 '
		END

		IF (@centrocusto <> '')
		BEGIN
			SET @sql += ' and case when ' + CONVERT(VARCHAR, @localcentrocustoenviodmed) + ' = 2 then tp1.cd_centro_custo else e1.cd_centro_custo end in (' + @centrocusto + ') '
		END

		IF (@cpf <> '')
		BEGIN
			SET @sql += ' and isnull(e1.exibirIRPF,1) = 1 '
		END

		IF (@cd_empresa > 0)
		BEGIN
			SET @sql += ' and a1.cd_empresa = ' + CONVERT(VARCHAR, @cd_empresa)
		END

		SET @sql += '
				) QtdeCPFTitular '

		IF (@tipoimpressao = 1)
		BEGIN
			SET @sql += ' , m.cd_parcela, m.dt_pagamento, tp.nm_tipo_pagamento, tpa.ds_tipo_parcela '
		END

		SET @sql += '
					FROM --dependentes d, associados a, empresa e, mensalidades_planos mp, mensalidades m,	planos p, grau_parentesco g, 	grau_parentesco g2,	tipo_pagamento tp, 	tipo_parcela tpa
					 dbo.DEPENDENTES D INNER JOIN dbo.ASSOCIADOS A ON D.CD_ASSOCIADO = A.cd_associado
					 INNER JOIN EMPRESA E ON A.cd_empresa = E.CD_EMPRESA
					 INNER JOIN dbo.Mensalidades_Planos MP ON MP.cd_sequencial_dep = D.CD_SEQUENCIAL
					 INNER JOIN dbo.Mensalidades M ON M.CD_PARCELA = MP.cd_parcela_mensalidade
					 INNER JOIN dbo.PLANOS P1 ON P1.cd_plano = D.cd_plano
					 INNER JOIN dbo.GRAU_PARENTESCO G ON G.cd_grau_parentesco = D.CD_GRAU_PARENTESCO
					 LEFT JOIN dbo.GRAU_PARENTESCO G2 ON G.cd_grau_ans = G2.cd_grau_parentesco
					 INNER JOIN dbo.TIPO_PAGAMENTO TP ON M.CD_TIPO_PAGAMENTO = TP.cd_tipo_pagamento
					 INNER JOIN dbo.Tipo_parcela TPA ON TPA.cd_tipo_parcela = MP.cd_tipo_parcela

					WHERE 					
					--d.cd_associado = a.cd_associado
					--and a.cd_empresa = e.cd_empresa
					--and d.cd_sequencial = mp.cd_sequencial_dep
					--and mp.cd_parcela_mensalidade = m.cd_parcela
					--and d.cd_plano = p1.cd_plano
					--and d.cd_grau_parentesco = g.cd_grau_parentesco
					--and g.cd_grau_ans *= g2.cd_grau_parentesco
					--and m.cd_tipo_pagamento = tp.cd_tipo_pagamento
					--and m.cd_tipo_parcela = tpa.cd_tipo_parcela and 
					M.TP_ASSOCIADO_EMPRESA = 1
					AND ( ISNULL(CONVERT(INT, E.enviarDMED), 1) = 1 OR MP.vl_dmed > 0 )
					AND M.CD_TIPO_RECEBIMENTO > 2
					AND MP.dt_exclusao IS NULL 
					and m.dt_pagamento >= ''' + @dtini + ''' 
					and m.dt_pagamento <= ''' + @dtfim + '''
					and case when ' + CONVERT(VARCHAR, @tiposistema) + ' = 2 then 0 else (select count(0) from classificacao_ans where IdConvenio is not null and cd_classificacao = p1.cd_classificacao) end = 0
			   '

		IF (@tipovalorenviodmed = 2)
		BEGIN
			SET @sql += ' and coalesce(mp.vl_dmed,mp.valorPago,0) > 0 '
		END
		ELSE
		BEGIN
			SET @sql += ' and coalesce(mp.vl_dmed,mp.valor,0) > 0 '
		END

		IF (@centrocusto <> '')
		BEGIN
			SET @sql += ' and case when ' + CONVERT(VARCHAR, @localcentrocustoenviodmed) + ' = 2 then tp.cd_centro_custo else e.cd_centro_custo end in (' + @centrocusto + ') '
		END

		IF (@cpf <> '')
		BEGIN
			SET @sql += ' and a.nr_cpf = ''' + @cpf + ''''
			SET @sql += ' and isnull(e.exibirIRPF,1) = 1 '
		END

		IF (@cd_empresa > 0)
		BEGIN
			SET @sql += ' and a.cd_empresa = ' + CONVERT(VARCHAR, @cd_empresa)
		END

		IF (@tipoimpressao = -1)
		BEGIN
			SET @sql += ' group by e.nm_fantasia, a.cd_associado, a.nm_completo, a.nr_cpf, d.nm_dependente, d.cd_sequencial, d.cd_grau_parentesco, g.nm_grau_parentesco, isnull(g2.nm_sigla, g.nm_sigla), d.nm_mae_dep, d.nr_cpf_dep, d.dt_nascimento, d.cd_sequencial '
		END

	END

	--*******************************************************************
	--Coletivo por adesão ou empresas específicas ou PF pago em coletivo empresarial
	--*******************************************************************
	--Regra: Coletivo por adesão que não esteja setado como enviarDMED = 0 ou qualquer outra empresa PJ com enviarDMED = 1 ou qualquer outra empresa PJ com vl_dmed > 0

	IF (@sql <> '')
	BEGIN
		SET @sql += ' union all '
	END

	SET @sql += '
		select
		e.nm_fantasia,
		a.cd_associado,
		a.nr_cpf,
		a.nm_completo,
		d.nr_cpf_dep,
		convert(varchar(10),d.dt_nascimento,103) dt_nascimento,
		d.nm_dependente,
		d.cd_sequencial cd_sequencial_dep,
		g.nm_grau_parentesco,
		isnull(g2.nm_sigla, g.nm_sigla) nm_sigla,
		d.nm_mae_dep,
		'

	IF (@tipoimpressao = -1)
	BEGIN

		IF (@tipovalorenviodmed = 2)
		BEGIN
			SET @sql += ' isnull(sum(isnull(mp.vl_dmed,mp.valorPago)),0) valor, '
		END
		ELSE
		BEGIN
			SET @sql += ' isnull(sum(isnull(mp.vl_dmed,mp.valor)),0) valor, '
		END

	END
	ELSE
	BEGIN

		IF (@tipovalorenviodmed = 2)
		BEGIN
			SET @sql += ' isnull(isnull(mp.vl_dmed,mp.valorPago),0) valor, '
		END
		ELSE
		BEGIN
			SET @sql += ' isnull(isnull(mp.vl_dmed,mp.valor),0) valor, '
		END

	END

	SET @sql += '
		d.dt_nascimento dt_nascimentoOrder,
		case when d.cd_grau_parentesco = 1 then 1 else 0 end Titular,
		(
			select count(distinct d1.cd_sequencial)
			from dependentes d1, associados a1, mensalidades_planos mp1, mensalidades m1, planos p1, empresa e1, tipo_pagamento tp1
  			where d1.cd_associado = a1.cd_associado
			and d1.cd_sequencial = mp1.cd_sequencial_dep
			and mp1.cd_parcela_mensalidade = m1.cd_parcela
			and d1.cd_plano = p1.cd_plano
			and d1.cd_grau_parentesco = 1
			and m1.cd_associado_empresa = e1.cd_empresa
			and m1.cd_tipo_pagamento = tp1.cd_tipo_pagamento
			and m1.tp_associado_empresa = 2
			and ((e1.tp_empresa = 8 and isnull(convert(int,e1.enviarDMED),1) = 1) or isnull(convert(int,e1.enviarDMED),0) = 1 or mp1.vl_dmed > 0)
			and m1.cd_tipo_recebimento > 2
			and mp1.dt_exclusao is null
			and m1.dt_pagamento >= ''' + @dtini + '''
			and m1.dt_pagamento <= ''' + @dtfim + ''' 
			and a1.nr_cpf = a.nr_cpf
			and case when ' + CONVERT(VARCHAR, @tiposistema) + ' = 2 then 0 else (select count(0) from classificacao_ans where IdConvenio is not null and cd_classificacao = p1.cd_classificacao) end = 0
			'

	IF (@tipovalorenviodmed = 2)
	BEGIN
		SET @sql += ' and coalesce(mp1.vl_dmed,mp1.valorPago,0) > 0 '
	END
	ELSE
	BEGIN
		SET @sql += ' and coalesce(mp1.vl_dmed,mp1.valor,0) > 0 '
	END

	IF (@centrocusto <> '')
	BEGIN
		SET @sql += ' and case when ' + CONVERT(VARCHAR, @localcentrocustoenviodmed) + ' = 2 then tp1.cd_centro_custo else e1.cd_centro_custo end in (' + @centrocusto + ') '
	END

	IF (@cpf <> '')
	BEGIN
		SET @sql += ' and isnull(e1.exibirIRPF,1) = 1 '
	END

	IF (@cd_empresa > 0)
	BEGIN
		SET @sql += ' and a1.cd_empresa = ' + CONVERT(VARCHAR, @cd_empresa)
	END

	SET @sql += '
		) QtdeCPFTitular '

	IF (@tipoimpressao = 1)
	BEGIN
		SET @sql += ' , m.cd_parcela, m.dt_pagamento, tp.nm_tipo_pagamento, tpa.ds_tipo_parcela '
	END

	SET @sql += '
			FROM --dependentes d,associados a, mensalidades_planos mp, mensalidades m, planos p, grau_parentesco g, grau_parentesco g2, empresa e, tipo_pagamento tp, tipo_parcela tpa
			
			dbo.DEPENDENTES D
			INNER JOIN dbo.ASSOCIADOS A ON A.cd_associado = D.CD_ASSOCIADO
			INNER JOIN dbo.Mensalidades_Planos MP ON D.CD_SEQUENCIAL = MP.cd_sequencial_dep
			INNER JOIN dbo.MENSALIDADES M ON M.CD_PARCELA = MP.cd_parcela_mensalidade
			LEFT JOIN dbo.GRAU_PARENTESCO G ON G.cd_grau_parentesco = D.CD_GRAU_PARENTESCO
			LEFT JOIN dbo.GRAU_PARENTESCO G2 ON G.cd_grau_parentesco = G2.cd_grau_parentesco
			LEFT JOIN dbo.EMPRESA E ON M.CD_ASSOCIADO_empresa = E.CD_EMPRESA
			LEFT JOIN dbo.TIPO_PAGAMENTO TP ON M.CD_TIPO_PAGAMENTO = TP.cd_tipo_pagamento
			LEFT JOIN dbo.Tipo_parcela TPA ON M.cd_tipo_parcela = TPA.cd_tipo_parcela
			INNER JOIN dbo.PLANOS P2 ON P2.cd_plano = D.cd_plano
			
			WHERE 
			
			--d.cd_associado = a.cd_associado
    		--and d.cd_sequencial = mp.cd_sequencial_dep
    		--and mp.cd_parcela_mensalidade = m.cd_parcela
    		--and d.cd_plano = p2.cd_plano
    		--and d.cd_grau_parentesco = g.cd_grau_parentesco
			--and g.cd_grau_ans *= g2.cd_grau_parentesco
    		--and m.cd_associado_empresa = e.cd_empresa
    		--and m.cd_tipo_pagamento = tp.cd_tipo_pagamento
    		--and m.cd_tipo_parcela = tpa.cd_tipo_parcela and 			
			M.TP_ASSOCIADO_EMPRESA = 2
			and ((e.tp_empresa = 8 and isnull(convert(int,e.enviarDMED),1) = 1) or isnull(convert(int,e.enviarDMED),0) = 1 or mp.vl_dmed > 0)
			and m.cd_tipo_recebimento > 2 
			and mp.dt_exclusao is null 
			and m.dt_pagamento >= ''' + @dtini + ''' 
			and m.dt_pagamento <= ''' + @dtfim + '''
			and case when ' + CONVERT(VARCHAR, @tiposistema) + ' = 2 then 0 else (select count(0) from classificacao_ans where IdConvenio is not null and cd_classificacao = p2.cd_classificacao) end = 0
   ';

	IF (@tipovalorenviodmed = 2)
	BEGIN
		SET @sql += ' and coalesce(mp.vl_dmed,mp.valorPago,0) > 0 '
	END
	ELSE
	BEGIN
		SET @sql += ' and coalesce(mp.vl_dmed,mp.valor,0) > 0 '
	END

	IF (@centrocusto <> '')
	BEGIN
		SET @sql += ' and case when ' + CONVERT(VARCHAR, @localcentrocustoenviodmed) + ' = 2 then tp.cd_centro_custo else e.cd_centro_custo end in (' + @centrocusto + ') '
	END

	IF (@cpf <> '')
	BEGIN
		SET @sql += ' and a.nr_cpf = ''' + @cpf + ''''
		SET @sql += ' and isnull(e.exibirIRPF,1) = 1 '
	END

	IF (@cd_empresa > 0)
	BEGIN
		SET @sql += ' and a.cd_empresa = ' + CONVERT(VARCHAR, @cd_empresa)
	END

	IF (@tipoimpressao = -1)
	BEGIN
		SET @sql += ' group by e.nm_fantasia, a.cd_associado, a.nm_completo, a.nr_cpf, d.nm_dependente, d.cd_sequencial, d.cd_grau_parentesco, g.nm_grau_parentesco, isnull(g2.nm_sigla, g.nm_sigla), d.nm_mae_dep, d.nr_cpf_dep, d.dt_nascimento, d.cd_sequencial '
	END

	--*********************************************************************
	--PF FORA DA MENSALIDADE_PLANO
	--*********************************************************************

	IF (@cd_empresa = -1)
	BEGIN

		IF (@sql <> '')
		BEGIN
			SET @sql += ' union all '
		END

		SET @sql += '
				select
				e.nm_fantasia,
				a.cd_associado,
				a.nr_cpf,
				a.nm_completo,
				d.nr_cpf_dep,
				convert(varchar(10),d.dt_nascimento,103) dt_nascimento,
				d.nm_dependente,
				d.cd_sequencial cd_sequencial_dep,
				g.nm_grau_parentesco,
				isnull(g2.nm_sigla, g.nm_sigla) nm_sigla,
				d.nm_mae_dep,
				'

		IF (@tipoimpressao = -1)
		BEGIN

			IF (@tipovalorenviodmed = 2)
			BEGIN
				SET @sql += ' isnull(sum(m.vl_pago),0) valor, '
			END
			ELSE
			BEGIN
				SET @sql += ' isnull(sum(m.vl_parcela),0) valor, '
			END

		END
		ELSE
		BEGIN

			IF (@tipovalorenviodmed = 2)
			BEGIN
				SET @sql += ' isnull(m.vl_pago,0) valor, '
			END
			ELSE
			BEGIN
				SET @sql += ' isnull(m.vl_parcela,0) valor, '
			END

		END

		SET @sql += '
				d.dt_nascimento dt_nascimentoOrder,
				1 Titular,
				1 QtdeCPFTitular '

		IF (@tipoimpressao = 1)
		BEGIN
			SET @sql += ' , m.cd_parcela, m.dt_pagamento, tp.nm_tipo_pagamento, tpa.ds_tipo_parcela '
		END

		SET @sql += '
					FROM --dependentes d, associados a,empresa e, mensalidades m,	planos p, grau_parentesco g, grau_parentesco g2,	tipo_pagamento tp, 	tipo_parcela tpa

					dbo.DEPENDENTES D
					LEFT JOIN dbo.ASSOCIADOS A ON A.cd_associado = D.CD_ASSOCIADO
					LEFT JOIN dbo.EMPRESA E ON A.cd_empresa = E.CD_EMPRESA
					LEFT JOIN dbo.MENSALIDADES M ON M.CD_ASSOCIADO_empresa = A.cd_associado
					LEFT JOIN dbo.PLANOS P3 ON P3.cd_plano = D.cd_plano
					LEFT JOIN dbo.GRAU_PARENTESCO G ON G.cd_grau_parentesco = D.CD_GRAU_PARENTESCO
					LEFT JOIN dbo.GRAU_PARENTESCO G2 ON G.cd_grau_ans = G2.cd_grau_parentesco
					LEFT JOIN dbo.TIPO_PAGAMENTO TP ON M.CD_TIPO_PAGAMENTO = TP.cd_tipo_pagamento
					LEFT JOIN dbo.Tipo_parcela TPA ON M.cd_tipo_parcela = TPA.cd_tipo_parcela
				
					WHERE 
					
					--d.cd_associado = a.cd_associado
					--and a.cd_empresa = e.cd_empresa
					--and a.cd_associado = m.cd_associado_empresa
					--and d.cd_plano = p3.cd_plano
					--and d.cd_grau_parentesco = g.cd_grau_parentesco
					--and g.cd_grau_ans *= g2.cd_grau_parentesco
					--and m.cd_tipo_pagamento = tp.cd_tipo_pagamento
					--and m.cd_tipo_parcela = tpa.cd_tipo_parcela and 				
					M.TP_ASSOCIADO_EMPRESA = 1
					and isnull(convert(int,e.enviarDMED),1) = 1
					and m.cd_tipo_recebimento > 2 
					and d.cd_grau_parentesco = 1
					and m.dt_pagamento >= ''' + @dtini + '''
					and m.dt_pagamento <= ''' + @dtfim + '''
					and (select count(0) from mensalidades_planos where cd_parcela_mensalidade = m.cd_parcela) = 0
					and case when ' + CONVERT(VARCHAR, @tiposistema) + ' = 2 then 0 else (select count(0) from classificacao_ans where IdConvenio is not null and cd_classificacao = p3.cd_classificacao) end = 0
			   '

		IF (@tipovalorenviodmed = 2)
		BEGIN
			SET @sql += ' and coalesce(m.vl_pago,0) > 0 '
		END
		ELSE
		BEGIN
			SET @sql += ' and coalesce(m.vl_parcela,0) > 0 '
		END

		IF (@centrocusto <> '')
		BEGIN
			SET @sql += ' and case when ' + CONVERT(VARCHAR, @localcentrocustoenviodmed) + ' = 2 then tp.cd_centro_custo else e.cd_centro_custo end in (' + @centrocusto + ')'
		END

		IF (@cpf <> '')
		BEGIN
			SET @sql += ' and a.nr_cpf = ''' + @cpf + ''''
			SET @sql += ' and isnull(e.exibirIRPF,1) = 1 '
		END

		IF (@cd_empresa > 0)
		BEGIN
			SET @sql += ' and a.cd_empresa = ' + CONVERT(VARCHAR, @cd_empresa)
		END

		IF (@tipoimpressao = -1)
		BEGIN
			SET @sql += ' group by e.nm_fantasia, a.cd_associado, a.nm_completo, a.nr_cpf, d.nm_dependente, d.cd_sequencial, d.cd_grau_parentesco, g.nm_grau_parentesco, isnull(g2.nm_sigla, g.nm_sigla), d.nm_mae_dep, d.nr_cpf_dep, d.dt_nascimento, d.cd_sequencial '
		END

	END

	--*********************************************************************

	IF (@tipoimpressao = -1)
	BEGIN
		SET @sql += ' order by a.nr_cpf asc, Titular desc, d.nr_cpf_dep asc, dt_nascimentoOrder asc '
	END
	ELSE
	BEGIN
		SET @sql += ' order by a.nr_cpf asc, Titular desc, d.nm_dependente asc '
	END

	PRINT @sql

	EXEC (@sql)

END
