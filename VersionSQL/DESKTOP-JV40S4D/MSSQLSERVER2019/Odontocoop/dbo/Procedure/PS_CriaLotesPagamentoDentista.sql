/****** Object:  Procedure [dbo].[PS_CriaLotesPagamentoDentista]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE Procedure [dbo].[PS_CriaLotesPagamentoDentista]
(
	@CRO Int = 0,
	@DataCorte varchar(10),
	@cd_filial int = 0,
	@usuario_abertura int = 0,
	@cd_funcionarioDentista int = 0,
	@DataProtocolo varchar(10) = '',
	@TipoLiberacaoVisualizacao int = -1,
	@dt_liberacao_visualizacao varchar(10) = '',
	@dt_competencia_pagamento varchar(10) = '',
	@dataBuscaProtocoloInicial varchar(10) = '',
	@dataBuscaProtocoloFinal varchar(10) = '',
	@centroCusto varchar(max) = '',
	@tipoFaturamento int = 1, --1: Pagamento pela Operadora, 2: Pagamento pela Clínica
	@codigosPlano varchar(max) = '',
	@filtroConvenio int = -2  -- -2:Indiferente, (x >-2 AND x <> 0): Com Convenio, 0: Sem Convenio ---#16898
)
As
Begin
/*********************************************************************************************************************************
	Ticket #16898 - criado filtro para convenio - Separar lotes pelo convenio
	Ticket #22285 - Ajuste para calcular o valor dos procedimentos de acordo com a tabela, mesmo sem indicar os procedimentos diretamente na tabela do dentista. (ticket 21505)
	Ticket () - Ajuste para não contabilizar os procedimentos de recurso de glosa no teto de pagamento para dentista
**********************************************************************************************************************************/
	
	Declare @SQL varchar(max)
	Declare @Data_Atual DateTime
	Declare @CD_Funcionario Int
	Declare @CD_Empresa Int
	Declare @CD_Sequencial Int
	Declare @Valor_Teto Money
	Declare @Valor_Teto_Clinica Money
	Declare @Valor_Teto_Dentista Money
	Declare @Valor_Procedimento Money
	Declare @Valor_Total_Pagar Money
    declare @Valor_Total_Pagar_Recurso money
	Declare @CD_Pagamento_Dentista Int
	Declare @Quantidade_Procedimento Int
	Declare @Aviso_Numero_Procedimentos Int
	Declare @NM_Funcionario varchar(80)
	Declare @NM_Filial varchar(80)
	Declare @CriarLote int
	Declare @CD_Tabela int
	Declare @CD_TabelaClinica int
	Declare @Data varchar(10)
	Declare @Data_Corte_Final datetime
	Declare @Dia_Corte int
	Declare @Idade_Dep int
	Declare @cd_sequencial_dep int
	Declare @cd_sequencial_depComparacao int
	Declare @Altera_ProdutDent int
	Declare @Cd_servico int
	Declare @Valor_Acrecimo14anos Money
	Declare @Cd_EspecialidadeClinico int
	Declare @Cd_EspecialidadeServico int
	Declare @Vl_fixo_Produtividade money
	Declare @LocalTabelaPagamentoDentista int
	Declare @Teste bit
	Declare @fl_CalcProdCenCusto bit
	Declare @cd_Centrocusto_padraoprodutividade int
	Declare @QtdeGTOLote int
	Declare @tipoRede tinyint
	Declare @pontosMaximosProcedimentoUsuarioLote float
	Declare @qtdeMaximaProcedimentoUsuarioLote int
	Declare @cd_peso float
	Declare @somaPeso float
	Declare @calcular bit
	Declare @dt_servico datetime
    Declare @nr_gto varchar(100)
	Declare @auditoriaClinicoPagamentoProtocolo bit

	--Variaveis para a separacao dos lotes de acordo com o modelo adotado
	Declare @totalProcedimentos int
	Declare @totalProdutividade money
	Declare @tipo int -- Se @tipo > 0 pegar o modelo do funcionario e se 0 pegar da Filial
	Declare @modelo int
	Declare @perc_modelo float
	Declare @vl_correcao money -- Usado para fazer a correção dos lotes devido ao percentual de divisão
	Declare @cd_filialPrestador int -- Destino forçado de clínica ao calcular o lote
	Declare @fl_CalcProdConvenio bit
	Declare @fl_CalcProdSeparacao smallint -- 0 - Lote Unico, 1 - Centro de Custo , 2 - Convenio 

    select
		@LocalTabelaPagamentoDentista = isnull(LocalTabelaPagamentoDentista,1),
		@Altera_ProdutDent = isnull(fl_Maior14a_aumentaProdDent,0),
		@Valor_Acrecimo14anos = isnull(Valor_Acrecimo14anos,0),
		@fl_CalcProdCenCusto = fl_CalcProdCenCusto,
		@cd_Centrocusto_padraoprodutividade = isnull(cd_Centrocusto_padraoprodutividade,0),
		@auditoriaClinicoPagamentoProtocolo = isnull(auditoriaClinicoPagamentoProtocolo,0), 
		@fl_CalcProdConvenio = isnull(fl_CalcProdConvenio,0)
    from configuracao

	if(@codigosPlano = '')
		begin
			set @codigosPlano = null
		end

	Set @Data_Atual = getdate()

	set @Cd_EspecialidadeClinico = 0

	 Select @fl_CalcProdSeparacao = Case when isnull(@fl_CalcProdCenCusto,0) > 0 then 1 -- Calculado pelo CC
	                                     when @fl_CalcProdConvenio > 0 then 2 -- Calculado pelo Convenio 
	                                     else 0 end -- Lote Unico 
	
  
	if RTrim(@DataCorte) = ''
		Begin
			Set @Dia_Corte = 0
			--Data de corte
			if(@cd_funcionarioDentista > 0)
				begin
					Select @Dia_Corte = dia_corte
					From funcionario
					Where cd_funcionario = @cd_funcionarioDentista
				end
			else
				begin
					Select @Dia_Corte = dia_corte
					From funcionario
					Where cro = @CRO
				end
			If @Dia_Corte = 0 and (@CRO <> 0 or @cd_filial <> 0)
				Begin
					Select 2 as gerou
					return
				End
	   
			Set @Data_Corte_final = convert(varchar(10),DATEADD(day,-1,convert(varchar,month(@Data_Atual)) + '/01/' +  convert(varchar,year(@Data_Atual))),101) -- Ultima dia do mes anterior
		End
	Else
		Begin
			Set @Data_Corte_final = @DataCorte
		End

		Set @Data_Corte_final = @Data_Corte_final + ' 23:59:59'
         
		if (@LocalTabelaPagamentoDentista = 1 and @cd_funcionarioDentista > 0)
			begin
				select @Teste = count(0)
				from funcionario T1
				where T1.cd_funcionario = @cd_funcionarioDentista
				and T1.cd_tabela is not null
				and T1.cd_faixa is not null
				if @Teste = 0 and (@CRO <> 0 or @cd_filial <> 0)
					Begin
						Select 3 as gerou
						return
					End
			end
			
		if (@LocalTabelaPagamentoDentista = 2 and @cd_filial > 0)
			begin
				select @Teste = count(0)
				from filial T1
				where T1.cd_filial = @cd_filial
				and T1.cd_tabela is not null
				if @Teste = 0 and (@CRO <> 0 or @cd_filial <> 0)
					Begin
						Select 3 as gerou
						return
					End
			end

		--Início transação
		Begin transaction
		
			Set @SQL = 'Declare Dados_Cursor Cursor For
			select T1.cd_funcionario, T1.cd_filial, T2.nm_filial, T2.tipoRede, T2.pontosMaximosProcedimentoUsuarioLote, T2.qtdeMaximaProcedimentoUsuarioLote, T3.nm_empregado, min(T3.cd_tabela) cd_tabela, min(T2.cd_tabela) cd_tabelaFilial, isnull(min(T2.vl_teto_filial),999999) as valor_teto_Clinica, min(T4.vl_faixa) as valor_teto_dentista, 0 as Vl_fixo_Produtividade, (select top 1 case when cd_especialidade = 1 Then 1 else 0 end from funcionario_especialidade where cd_funcionario = T1.cd_funcionario order by cd_especialidade), count(0)
			from consultas T1, filial T2, funcionario T3, funcionario_faixa T4, servico T5, dependentes T6, configuracao T7
			where T1.cd_filial = T2.cd_filial
			and T1.cd_funcionario = T3.cd_funcionario
			and T3.cd_faixa = T4.cd_faixa
			and T1.cd_servico = T5.cd_servico
			and T1.cd_sequencial_dep = T6.cd_sequencial
			and T1.status in (3,6,7)
			and T1.dt_servico is not null
			and T1.dt_cancelamento is null
			and case when isnull(T7.TipoValorCalculoProdutividadeDentista,1) = 1 then (select count(0) from tabela_servicos where cd_servico = T1.cd_servico) else 1 end > 0
			'
			
			if @tipoFaturamento = 1
				begin
					Set @SQL = @SQL + ' and T1.nr_numero_lote is null '
				end
			else if @tipoFaturamento = 2
				begin
					Set @SQL = @SQL + ' and T1.nr_numero_lote_clinica is null '
				end

			if @LocalTabelaPagamentoDentista = 1
				begin
					Set @SQL = @SQL + ' and T3.cd_tabela is not null '
				end
				
			if @LocalTabelaPagamentoDentista = 2
				begin
					Set @SQL = @SQL + ' and T2.cd_tabela is not null '
				end
			
			if @CRO > 0
				begin
					Set @SQL = @SQL + ' and T3.CRO = ' + convert(varchar(10),@CRO)
				end
				
			if @cd_filial > 0
				begin
					Set @SQL = @SQL + ' and T1.cd_filial = ' + convert(varchar(10),@cd_filial)
				end
				
			if @cd_funcionarioDentista > 0
				begin
					Set @SQL = @SQL + ' and T1.cd_funcionario = ' + convert(varchar(10),@cd_funcionarioDentista)
				end
				
			if @auditoriaClinicoPagamentoProtocolo = 1
				begin
					Set @SQL = @SQL + ' and T1.dt_recebimento_protocolo is not null '
				end

			If @centroCusto <> ''
				begin
					Set @SQL = @SQL + ' and T2.cd_centro_custo in (' + @centroCusto + ') '
				end
				
			If @codigosPlano is not null
				begin
					Set @SQL = @SQL + ' and T6.cd_plano in (' + @codigosPlano + ') '
				end
				
			if @tipoFaturamento = 2
				begin
					Set @SQL = @SQL + ' and (select count(0) from FUNCIONARIO_ESPECIALIDADE where percentualRepasse is not null and cd_funcionario = T1.cd_funcionario) > 0 '
				end
							
			If @filtroConvenio > -2 ---INICIO #16898
				begin
					Set @SQL = @SQL + ' and (Select Count(0) from dependentes d, planos as p, CLASSIFICACAO_ANS ans '
					Set @SQL = @SQL + '		where T1.cd_sequencial_dep = d.CD_SEQUENCIAL '
					Set @SQL = @SQL + '		and d.cd_plano = p.cd_plano '
					Set @SQL = @SQL + '		and p.cd_classificacao = ans.cd_classificacao '

					If @filtroConvenio = 0
					begin
						Set @SQL = @SQL + ' and ans.IdConvenio is null '
					end
					If @filtroConvenio <> 0
					begin
						Set @SQL = @SQL + ' and ans.IdConvenio is not null '
					end
					If @filtroConvenio > 0
					begin
						Set @SQL = @SQL + ' and ans.IdConvenio = ' + convert(varchar(5), @filtroConvenio)
					end
					Set @SQL = @SQL + ' ) > 0 '
				end---FIM #16898


			Set @SQL = @SQL + '
			and convert(date,T1.dt_servico) <= ''' + convert(varchar,convert(date,@Data_Corte_final)) + '''
			and case when ''' + @dataBuscaProtocoloInicial + ''' <> '''' then case when T1.dt_recebimento_protocolo >= ''' + @dataBuscaProtocoloInicial + ' 00:00'' then 1 else 0 end else 1 end = 1
			and case when ''' + @dataBuscaProtocoloFinal + ''' <> '''' then case when T1.dt_recebimento_protocolo <= ''' + @dataBuscaProtocoloFinal + ' 23:59:59'' then 1 else 0 end else 1 end = 1
			and case when T3.periciaFinal = 1 or T5.periciaFinal = 1 then case when T1.dtPericiaFinal is null then 0 else 1 end else 1 end = 1
			group by T1.cd_funcionario, T1.cd_filial, T2.nm_filial, T2.tipoRede, T2.pontosMaximosProcedimentoUsuarioLote, T2.qtdeMaximaProcedimentoUsuarioLote, T3.nm_empregado, t2.cd_tipo_faturamento
			order by T1.cd_funcionario'

			exec(@sql)
			
			Open Dados_Cursor
			Fetch next from Dados_Cursor  
				Into @CD_Funcionario, @CD_Empresa, @NM_Filial, @tipoRede, @pontosMaximosProcedimentoUsuarioLote, @qtdeMaximaProcedimentoUsuarioLote, @NM_Funcionario, @CD_Tabela, @CD_TabelaClinica, @Valor_Teto_Clinica,@valor_Teto_Dentista, @Vl_fixo_Produtividade, @Cd_EspecialidadeClinico, @totalProcedimentos
 
				--Iniciando loop dos dentistas
				Set @Aviso_Numero_Procedimentos = 0

				While (@@fetch_status <> -1)
					Begin
						--Valor total da Produtividade
						Select @totalProdutividade = 
						(
							select isnull(sum(ValorTEMP),0) from
							(
								select
								case
									when @tipoFaturamento = 2 then
										(isnull(convert(money,T6.percentualRepasse),0)/100)
									else
										1
									end
								*
								isnull(
									case
										when T5.cd_orcamento is not null and @tipoFaturamento = 2 then isnull(T5.vl_servicoFechadoOrcamento,0) --Valor de orçamento
										when T1.vl_pago_manual is not null then T1.vl_pago_manual --Valor informado manualmente
										else
											case
												when isnull(T3.RefAtualizacaoTabelaDentista,1) = 1 then --Última tabela
													case
														when isnull(T3.LocalTabelaPagamentoDentista,1) = 1 then --Tabela por dentista
															case
																when isnull(T3.TipoValorCalculoProdutividadeDentista,1) = 1 then --Valor em R$
																	isnull((select top 1 TT1.vl_servico from tabela_servicos TT1, tabela_referencia TT2 where TT1.cd_tabela_referencia = TT2.cd_tabela_referencia and TT1.cd_tabela = @CD_Tabela and TT1.cd_servico = T1.cd_servico and TT1.cd_plano = T11.cd_plano order by TT2.dt_inicio desc, TT2.cd_tabela_referencia desc),(select top 1 TT1.vl_servico from tabela_servicos TT1, tabela_referencia TT2 where TT1.cd_tabela_referencia = TT2.cd_tabela_referencia and TT1.cd_tabela = @CD_Tabela and TT1.cd_servico = T1.cd_servico and TT1.cd_plano is null order by TT2.dt_inicio desc, TT2.cd_tabela_referencia desc))
																when T3.TipoValorCalculoProdutividadeDentista = 2 then --Valor em US, convertido para R$
																	isnull(isnull((select top 1 round(TT1.vl_servico * case when TT1.tipoMoedaCalculo = 2 then 1 else T22.vl_us end,2) from tabela_servicos TT1, tabela_referencia TT2 where TT1.cd_tabela_referencia = TT2.cd_tabela_referencia and TT1.cd_tabela = @CD_Tabela and TT1.cd_servico = T22.cd_servico and TT1.cd_plano = T11.cd_plano and TT1.cd_especialidade is null order by TT2.dt_inicio desc, TT2.cd_tabela_referencia desc),(select top 1 round(TT1.vl_servico * case when TT1.tipoMoedaCalculo = 2 then 1 else T22.vl_us end,2) from tabela_servicos TT1, tabela_referencia TT2 where TT1.cd_tabela_referencia = TT2.cd_tabela_referencia and TT1.cd_tabela = @CD_Tabela and TT1.cd_servico = T22.cd_servico and TT1.cd_plano is null and TT1.cd_especialidade is null order by TT2.dt_inicio desc, TT2.cd_tabela_referencia desc)),isnull(isnull((select top 1 round(TT1.vl_servico * case when TT1.tipoMoedaCalculo = 2 then 1 else T22.vl_us end,2) from tabela_servicos TT1, tabela_referencia TT2 where TT1.cd_tabela_referencia = TT2.cd_tabela_referencia and TT1.cd_tabela = @CD_Tabela and TT1.cd_especialidade = T22.cd_especialidadereferencia and TT1.cd_plano = T11.cd_plano and TT1.cd_servico is null order by TT2.dt_inicio desc, TT2.cd_tabela_referencia desc),(select top 1 round(TT1.vl_servico * case when TT1.tipoMoedaCalculo = 2 then 1 else T22.vl_us end,2) from tabela_servicos TT1, tabela_referencia TT2 where TT1.cd_tabela_referencia = TT2.cd_tabela_referencia and TT1.cd_tabela = @CD_Tabela and TT1.cd_especialidade = T22.cd_especialidadereferencia and TT1.cd_plano is null and TT1.cd_servico is null order by TT2.dt_inicio desc, TT2.cd_tabela_referencia desc)),(select top 1 round(TT1.vl_servico * case when TT1.tipoMoedaCalculo = 2 then 1 else T22.vl_us end,2) from tabela_servicos TT1, tabela_referencia TT2 where TT1.cd_tabela_referencia = TT2.cd_tabela_referencia and TT1.cd_tabela = @CD_Tabela and TT1.cd_especialidade is null and TT1.cd_plano is null and TT1.cd_servico is null order by TT2.dt_inicio desc, TT2.cd_tabela_referencia desc)))
															end
														when T3.LocalTabelaPagamentoDentista = 2 then --Tabela por clínica
															case
																when isnull(T3.TipoValorCalculoProdutividadeDentista,1) = 1 then --Valor em R$
																	isnull((select top 1 TT1.vl_servico from tabela_servicos TT1, tabela_referencia TT2 where TT1.cd_tabela_referencia = TT2.cd_tabela_referencia and TT1.cd_tabela = @CD_TabelaClinica and TT1.cd_servico = T1.cd_servico and TT1.cd_plano = T11.cd_plano order by TT2.dt_inicio desc, TT2.cd_tabela_referencia desc),(select top 1 TT1.vl_servico from tabela_servicos TT1, tabela_referencia TT2 where TT1.cd_tabela_referencia = TT2.cd_tabela_referencia and TT1.cd_tabela = @CD_TabelaClinica and TT1.cd_servico = T1.cd_servico and TT1.cd_plano is null order by TT2.dt_inicio desc, TT2.cd_tabela_referencia desc))
																when T3.TipoValorCalculoProdutividadeDentista = 2 then --Valor em US, convertido para R$
																	isnull(isnull((select top 1 round(TT1.vl_servico * case when TT1.tipoMoedaCalculo = 2 then 1 else T22.vl_us end,2) from tabela_servicos TT1, tabela_referencia TT2 where TT1.cd_tabela_referencia = TT2.cd_tabela_referencia and TT1.cd_tabela = @CD_TabelaClinica and TT1.cd_servico = T22.cd_servico and TT1.cd_plano = T11.cd_plano and TT1.cd_especialidade is null order by TT2.dt_inicio desc, TT2.cd_tabela_referencia desc),(select top 1 round(TT1.vl_servico * case when TT1.tipoMoedaCalculo = 2 then 1 else T22.vl_us end,2) from tabela_servicos TT1, tabela_referencia TT2 where TT1.cd_tabela_referencia = TT2.cd_tabela_referencia and TT1.cd_tabela = @CD_TabelaClinica and TT1.cd_servico = T22.cd_servico and TT1.cd_plano is null and TT1.cd_especialidade is null order by TT2.dt_inicio desc, TT2.cd_tabela_referencia desc)),isnull(isnull((select top 1 round(TT1.vl_servico * case when TT1.tipoMoedaCalculo = 2 then 1 else T22.vl_us end,2) from tabela_servicos TT1, tabela_referencia TT2 where TT1.cd_tabela_referencia = TT2.cd_tabela_referencia and TT1.cd_tabela = @CD_TabelaClinica and TT1.cd_especialidade = T22.cd_especialidadereferencia and TT1.cd_plano = T11.cd_plano and TT1.cd_servico is null order by TT2.dt_inicio desc, TT2.cd_tabela_referencia desc),(select top 1 round(TT1.vl_servico * case when TT1.tipoMoedaCalculo = 2 then 1 else T22.vl_us end,2) from tabela_servicos TT1, tabela_referencia TT2 where TT1.cd_tabela_referencia = TT2.cd_tabela_referencia and TT1.cd_tabela = @CD_TabelaClinica and TT1.cd_especialidade = T22.cd_especialidadereferencia and TT1.cd_plano is null and TT1.cd_servico is null order by TT2.dt_inicio desc, TT2.cd_tabela_referencia desc)),(select top 1 round(TT1.vl_servico * case when TT1.tipoMoedaCalculo = 2 then 1 else T22.vl_us end,2) from tabela_servicos TT1, tabela_referencia TT2 where TT1.cd_tabela_referencia = TT2.cd_tabela_referencia and TT1.cd_tabela = @CD_TabelaClinica and TT1.cd_especialidade is null and TT1.cd_plano is null and TT1.cd_servico is null order by TT2.dt_inicio desc, TT2.cd_tabela_referencia desc)))
															end
													end
												when T3.RefAtualizacaoTabelaDentista = 2 then --Tabela por data de referência x data de realização do procedimento
													case
														when isnull(T3.LocalTabelaPagamentoDentista,1) = 1 then --Tabela por dentista
															case
																when isnull(T3.TipoValorCalculoProdutividadeDentista,1) = 1 then --Valor em R$
																	isnull((select top 1 TT1.vl_servico from tabela_servicos TT1, tabela_referencia TT2 where TT1.cd_tabela_referencia = TT2.cd_tabela_referencia and TT1.cd_tabela = @CD_Tabela and TT1.cd_servico = T1.cd_servico and TT1.cd_plano = T11.cd_plano and convert(date,T1.dt_servico) >= TT2.dt_inicio and convert(date,T1.dt_servico) <= isnull(TT2.dt_fim,getdate())),(select top 1 TT1.vl_servico from tabela_servicos TT1, tabela_referencia TT2 where TT1.cd_tabela_referencia = TT2.cd_tabela_referencia and TT1.cd_tabela = @CD_Tabela and TT1.cd_servico = T1.cd_servico and TT1.cd_plano is null and convert(date,T1.dt_servico) >= TT2.dt_inicio and convert(date,T1.dt_servico) <= isnull(TT2.dt_fim,getdate())))
																when T3.TipoValorCalculoProdutividadeDentista = 2 then --Valor em US, convertido para R$
																	isnull(isnull((select top 1 round(TT1.vl_servico * case when TT1.tipoMoedaCalculo = 2 then 1 else T22.vl_us end,2) from tabela_servicos TT1, tabela_referencia TT2 where TT1.cd_tabela_referencia = TT2.cd_tabela_referencia and TT1.cd_tabela = @CD_Tabela and TT1.cd_servico = T22.cd_servico and TT1.cd_plano = T11.cd_plano and TT1.cd_especialidade is null and convert(date,T1.dt_servico) >= TT2.dt_inicio and convert(date,T1.dt_servico) <= isnull(TT2.dt_fim,getdate())),(select top 1 round(TT1.vl_servico * case when TT1.tipoMoedaCalculo = 2 then 1 else T22.vl_us end,2) from tabela_servicos TT1, tabela_referencia TT2 where TT1.cd_tabela_referencia = TT2.cd_tabela_referencia and TT1.cd_tabela = @CD_Tabela and TT1.cd_servico = T22.cd_servico and TT1.cd_plano is null and TT1.cd_especialidade is null and convert(date,T1.dt_servico) >= TT2.dt_inicio and convert(date,T1.dt_servico) <= isnull(TT2.dt_fim,getdate()))),isnull(isnull((select top 1 round(TT1.vl_servico * case when TT1.tipoMoedaCalculo = 2 then 1 else T22.vl_us end,2) from tabela_servicos TT1, tabela_referencia TT2 where TT1.cd_tabela_referencia = TT2.cd_tabela_referencia and TT1.cd_tabela = @CD_Tabela and TT1.cd_especialidade = T22.cd_especialidadereferencia and TT1.cd_plano = T11.cd_plano and TT1.cd_servico is null and convert(date,T1.dt_servico) >= TT2.dt_inicio and convert(date,T1.dt_servico) <= isnull(TT2.dt_fim,getdate())),(select top 1 round(TT1.vl_servico * case when TT1.tipoMoedaCalculo = 2 then 1 else T22.vl_us end,2) from tabela_servicos TT1, tabela_referencia TT2 where TT1.cd_tabela_referencia = TT2.cd_tabela_referencia and TT1.cd_tabela = @CD_Tabela and TT1.cd_especialidade = T22.cd_especialidadereferencia and TT1.cd_plano is null and TT1.cd_servico is null and convert(date,T1.dt_servico) >= TT2.dt_inicio and convert(date,T1.dt_servico) <= isnull(TT2.dt_fim,getdate()))),(select top 1 round(TT1.vl_servico * case when TT1.tipoMoedaCalculo = 2 then 1 else T22.vl_us end,2) from tabela_servicos TT1, tabela_referencia TT2 where TT1.cd_tabela_referencia = TT2.cd_tabela_referencia and TT1.cd_tabela = @CD_Tabela and TT1.cd_especialidade is null and TT1.cd_plano is null and TT1.cd_servico is null and convert(date,T1.dt_servico) >= TT2.dt_inicio and convert(date,T1.dt_servico) <= isnull(TT2.dt_fim,getdate()))))
															end
														when T3.LocalTabelaPagamentoDentista = 2 then --Tabela por clínica
															case
																when isnull(T3.TipoValorCalculoProdutividadeDentista,1) = 1 then --Valor em R$
																	isnull((select top 1 TT1.vl_servico from tabela_servicos TT1, tabela_referencia TT2 where TT1.cd_tabela_referencia = TT2.cd_tabela_referencia and TT1.cd_tabela = @CD_TabelaClinica and TT1.cd_servico = T1.cd_servico and TT1.cd_plano = T11.cd_plano and convert(date,T1.dt_servico) >= TT2.dt_inicio and convert(date,T1.dt_servico) <= isnull(TT2.dt_fim,getdate())),(select top 1 TT1.vl_servico from tabela_servicos TT1, tabela_referencia TT2 where TT1.cd_tabela_referencia = TT2.cd_tabela_referencia and TT1.cd_tabela = @CD_TabelaClinica and TT1.cd_servico = T1.cd_servico and TT1.cd_plano is null and convert(date,T1.dt_servico) >= TT2.dt_inicio and convert(date,T1.dt_servico) <= isnull(TT2.dt_fim,getdate())))
																when T3.TipoValorCalculoProdutividadeDentista = 2 then --Valor em US, convertido para R$
																	isnull(isnull((select top 1 round(TT1.vl_servico * case when TT1.tipoMoedaCalculo = 2 then 1 else T22.vl_us end,2) from tabela_servicos TT1, tabela_referencia TT2 where TT1.cd_tabela_referencia = TT2.cd_tabela_referencia and TT1.cd_tabela = @CD_TabelaClinica and TT1.cd_servico = T22.cd_servico and TT1.cd_plano = T11.cd_plano and TT1.cd_especialidade is null and convert(date,T1.dt_servico) >= TT2.dt_inicio and convert(date,T1.dt_servico) <= isnull(TT2.dt_fim,getdate())),(select top 1 round(TT1.vl_servico * case when TT1.tipoMoedaCalculo = 2 then 1 else T22.vl_us end,2) from tabela_servicos TT1, tabela_referencia TT2 where TT1.cd_tabela_referencia = TT2.cd_tabela_referencia and TT1.cd_tabela = @CD_TabelaClinica and TT1.cd_servico = T22.cd_servico and TT1.cd_plano is null and TT1.cd_especialidade is null and convert(date,T1.dt_servico) >= TT2.dt_inicio and convert(date,T1.dt_servico) <= isnull(TT2.dt_fim,getdate()))),isnull(isnull((select top 1 round(TT1.vl_servico * case when TT1.tipoMoedaCalculo = 2 then 1 else T22.vl_us end,2) from tabela_servicos TT1, tabela_referencia TT2 where TT1.cd_tabela_referencia = TT2.cd_tabela_referencia and TT1.cd_tabela = @CD_TabelaClinica and TT1.cd_especialidade = T22.cd_especialidadereferencia and TT1.cd_plano = T11.cd_plano and TT1.cd_servico is null and convert(date,T1.dt_servico) >= TT2.dt_inicio and convert(date,T1.dt_servico) <= isnull(TT2.dt_fim,getdate())),(select top 1 round(TT1.vl_servico * case when TT1.tipoMoedaCalculo = 2 then 1 else T22.vl_us end,2) from tabela_servicos TT1, tabela_referencia TT2 where TT1.cd_tabela_referencia = TT2.cd_tabela_referencia and TT1.cd_tabela = @CD_TabelaClinica and TT1.cd_especialidade = T22.cd_especialidadereferencia and TT1.cd_plano is null and TT1.cd_servico is null and convert(date,T1.dt_servico) >= TT2.dt_inicio and convert(date,T1.dt_servico) <= isnull(TT2.dt_fim,getdate()))),(select top 1 round(TT1.vl_servico * case when TT1.tipoMoedaCalculo = 2 then 1 else T22.vl_us end,2) from tabela_servicos TT1, tabela_referencia TT2 where TT1.cd_tabela_referencia = TT2.cd_tabela_referencia and TT1.cd_tabela = @CD_TabelaClinica and TT1.cd_especialidade is null and TT1.cd_plano is null and TT1.cd_servico is null and convert(date,T1.dt_servico) >= TT2.dt_inicio and convert(date,T1.dt_servico) <= isnull(TT2.dt_fim,getdate()))))
															end
													end
												when T3.RefAtualizacaoTabelaDentista = 3 then --Tabela por data de referência de fator x data de realização do procedimento
													(select top 1 round(case when TF2.tipoValor = 2 then TF2.valor else TF1.vl_servico * case when TF1.tipoMoedaCalculo = 2 then 1 else TF2.valor end end, 2) from tabela_servicos TF1, tabela_fator TF2 where TF1.cd_tabela = case when isnull(T3.LocalTabelaPagamentoDentista,1) = 1 then @CD_Tabela else @CD_TabelaClinica end and TF1.cd_servico = T1.cd_servico and isnull(TF2.cd_servico,TF1.cd_servico) = T1.cd_servico and coalesce(TF2.cd_plano,TF1.cd_plano,T11.cd_plano) = T11.cd_plano and isnull(TF1.cd_plano,T11.cd_plano) = isnull(TF2.cd_plano,T11.cd_plano) and isnull(TF2.cd_especialidade,T22.cd_especialidadereferencia) = T22.cd_especialidadereferencia and case when isnull(T3.LocalTabelaPagamentoDentista,1) = 1 then TF2.cd_funcionario else TF2.cd_filial end = case when isnull(T3.LocalTabelaPagamentoDentista,1) = 1 then T1.cd_funcionario else T1.cd_filial end and convert(date,isnull(T1.dt_servico,getdate())) >= TF2.dataInicial and convert(date,isnull(T1.dt_servico,getdate())) <= isnull(TF2.dataFinal,getdate()) and TF2.dataExclusao is null order by TF2.cd_plano desc, TF1.cd_plano desc, TF2.cd_servico desc, TF2.cd_especialidade desc)
												else
													0
											end
										end
								,0)
								+
								case when @Altera_ProdutDent = 1 and dbo.FS_Idade (isnull(T11.DT_NASCIMENTO,'1900-01-01'), T1.DT_Servico) < 14 and T1.cd_servico <>  81000065 and @Cd_EspecialidadeClinico > 0 and T22.cd_especialidadereferencia in (1,4) then @Valor_Acrecimo14anos else 0 end
								as ValorTEMP
								From consultas T1, dependentes T11, servico T22, Configuracao T3, funcionario T4, orcamento_servico T5, funcionario_especialidade T6
								where T1.cd_sequencial_dep = T11.cd_sequencial
								and T1.cd_servico = T22.CD_Servico
								and T1.cd_funcionario = T4.cd_funcionario
								and T1.cd_sequencial = T5.cd_sequencial_pp
								and T1.cd_funcionario = T6.cd_funcionario
								and T22.cd_especialidadereferencia = T6.cd_especialidade
								and T1.cd_funcionario = @CD_Funcionario
								and T1.CD_Filial = @CD_Empresa
								and convert(date,T1.dt_servico) <= @Data_Corte_final
								and case when @dataBuscaProtocoloInicial <> '' then case when T1.dt_recebimento_protocolo >= @dataBuscaProtocoloInicial + ' 00:00' then 1 else 0 end else 1 end = 1
								and case when @dataBuscaProtocoloFinal <> '' then case when T1.dt_recebimento_protocolo <= @dataBuscaProtocoloFinal + ' 23:59:59' then 1 else 0 end else 1 end = 1
								and T1.DT_Servico Is Not null
								and case when @tipoFaturamento = 1 then case when T1.nr_numero_lote is null then 1 else 0 end else 1 end = 1
								and case when @tipoFaturamento = 2 then case when T1.nr_numero_lote_clinica is null then 1 else 0 end else 1 end = 1
								and T1.dt_cancelamento is null
								and T1.Status in (3,6)
								and case when isnull(T3.TipoValorCalculoProdutividadeDentista,1) = 1 then (select count(0) from tabela_servicos where cd_servico = T1.cd_servico) else 1 end > 0
								and (@tipoFaturamento = 2 or (
									case when T22.periciaFinal = 1 or T4.periciaFinal = 1 then case when T1.dtPericiaFinal is null then 0 else 1 end else 1 end = 1
									and T1.nr_procedimentoliberado = 1
									and (T1.CD_Sequencial_Dep not in (
										Select t10.cd_sequencial 
										From dependentes t10, ASSOCIADOS t20, EMPRESA t30
										Where t10.cd_associado = t20.cd_associado
										and t20.cd_empresa = t30.CD_EMPRESA
										and t30.TP_EMPRESA = 10
									) or T3.incluirProcPartProdutividade = 1)
									and T1.cd_sequencial Not in (Select cd_sequencial from tb_consultasdocumentacao where cd_sequencial = t1.cd_sequencial and foto_digitalizada = 0)
									and (T1.cd_sequencial Not in (select cd_sequencial_pp from orcamento_servico where cd_sequencial_pp = t1.cd_sequencial) or T3.incluirProcPartProdutividade = 1)
									and case when @auditoriaClinicoPagamentoProtocolo = 1 and T1.dt_recebimento_protocolo is null then 0 else 1 end = 1
								))
								and CHARINDEX(',' + convert(varchar(10),T11.cd_plano) + ',', ',' + isnull(@codigosPlano,convert(varchar(10),T11.cd_plano)) + ',') > 0
								
								---INICIO #16898
								and case when @filtroConvenio <= -2 then 1 
									when @filtroConvenio = 0  then (select count(0) from planos as p, CLASSIFICACAO_ANS ans where T11.cd_plano = p.cd_plano and p.cd_classificacao = ans.cd_classificacao and ans.IdConvenio is null)
									when @filtroConvenio = -1 then (select count(0) from planos as p, CLASSIFICACAO_ANS ans where T11.cd_plano = p.cd_plano and p.cd_classificacao = ans.cd_classificacao and ans.IdConvenio is not null)
									when @filtroConvenio > 0  then (select count(0) from planos as p, CLASSIFICACAO_ANS ans where T11.cd_plano = p.cd_plano and p.cd_classificacao = ans.cd_classificacao and ans.IdConvenio is not null and ans.IdConvenio = @filtroConvenio)
									else 0 end > 0
							   ---FIM #16898
							) x
						)
              
					Set @vl_correcao = 0
       
					--Teto
					if @Valor_Teto_clinica < @Valor_Teto_Dentista
						begin
							select @Valor_Teto = @Valor_Teto_clinica - isnull(sum(vl_parcela),0) from pagamento_dentista where cd_filial = @CD_Empresa and cd_pgto_dentista_lanc is null
						end
					else
						begin
							select @Valor_Teto = @Valor_Teto_Dentista - isnull(sum(vl_parcela),0) from pagamento_dentista where cd_funcionario = @CD_funcionario and cd_pgto_dentista_lanc is null
						end
       
					select @tipo = count(0) from funcionario_modelo_pagamento where cd_funcionario = @CD_Funcionario
       
					-- Separar os lotes de acordo com a configuracao da empresa
					if @tipo = 0
						begin
							Declare Modelos_Cursor Cursor For
							select
							cd_modelo, --Modelo
							perc_receita, --Percentual
							case when @Valor_Teto > @totalProdutividade  then @totalProdutividade else @Valor_Teto end * (perc_receita/100), --Valor do Lote
							@Vl_fixo_Produtividade * (perc_receita/100), --Valor fixo para ajustes
							cd_filialPrestador
							from filial_modelo_pagamento
							where cd_filial = @CD_Empresa
						end
					else
						begin
							Declare Modelos_Cursor Cursor For 
							select
							cd_modelo, --Modelo
							perc_receita, --Percentual
							case when @Valor_Teto > @totalProdutividade  then @totalProdutividade else @Valor_Teto end * (perc_receita/100), --Valor do Lote
							@Vl_fixo_Produtividade * (perc_receita/100), --Valor Fixo para ajustes
							cd_filialPrestador
							from funcionario_modelo_pagamento
							where cd_funcionario = @CD_funcionario
						end

					Open Modelos_Cursor
					
					Fetch next from Modelos_Cursor
						Into @modelo, @perc_modelo, @Valor_Teto, @Vl_fixo_Produtividade, @cd_filialPrestador
    
						if @@fetch_status = -1 and @totalProcedimentos > 0 and (@CRO <> 0 or @cd_filial <> 0)
							begin
								select 4 as gerou
								close Modelos_Cursor
								Deallocate Modelos_Cursor  
								Rollback transaction
							return
						end
	        
						While (@@fetch_status <> -1)
							Begin
								--Inicio do loop para os modelos

								Set @CD_Pagamento_Dentista = Null
								Set @Valor_Total_Pagar = 0  
								Set @Quantidade_Procedimento = 0  
								Set @CriarLote = 0  
								Set @Valor_Teto = @Valor_Teto + @vl_correcao -- Aumentar o teto caso tenha sobrado residuo do lote anterior devido os modelos
								Set @vl_correcao = 0

								/*Procedimentos OK*/
								Declare Procedimentos_Cursor Cursor For

								select y.cd_sequencial, y.valorProcedimento, y.idade, y.cd_servico, y.cd_especialidadereferencia, y.QtdeGTOLote, y.cd_sequencial_dep, y.cd_peso, y.dt_servico, y.nr_gto
								from (
									select t1.cd_sequencial,
									case
										when @tipoFaturamento = 2 then
											(isnull(convert(money,T6.percentualRepasse),0)/100)
										else
											1
										end
									*
									isnull(
										case
											when T5.cd_orcamento is not null and @tipoFaturamento = 2 then isnull(T5.vl_servicoFechadoOrcamento,0) --Valor de orçamento
											when T1.vl_pago_manual is not null then T1.vl_pago_manual --Valor informado manualmente
											else
												case
													when isnull(T3.RefAtualizacaoTabelaDentista,1) = 1 then --Última tabela
														case
															when isnull(T3.LocalTabelaPagamentoDentista,1) = 1 then --Tabela por dentista
																case
																	when isnull(T3.TipoValorCalculoProdutividadeDentista,1) = 1 then --Valor em R$
																		isnull((select top 1 TT1.vl_servico from tabela_servicos TT1, tabela_referencia TT2 where TT1.cd_tabela_referencia = TT2.cd_tabela_referencia and TT1.cd_tabela = @CD_Tabela and TT1.cd_servico = T1.cd_servico and TT1.cd_plano = T11.cd_plano order by TT2.dt_inicio desc, TT2.cd_tabela_referencia desc),(select top 1 TT1.vl_servico from tabela_servicos TT1, tabela_referencia TT2 where TT1.cd_tabela_referencia = TT2.cd_tabela_referencia and TT1.cd_tabela = @CD_Tabela and TT1.cd_servico = T1.cd_servico and TT1.cd_plano is null order by TT2.dt_inicio desc, TT2.cd_tabela_referencia desc))
																	when T3.TipoValorCalculoProdutividadeDentista = 2 then --Valor em US, convertido para R$
																		isnull(isnull((select top 1 round(TT1.vl_servico * case when TT1.tipoMoedaCalculo = 2 then 1 else T22.vl_us end,2) from tabela_servicos TT1, tabela_referencia TT2 where TT1.cd_tabela_referencia = TT2.cd_tabela_referencia and TT1.cd_tabela = @CD_Tabela and TT1.cd_servico = T22.cd_servico and TT1.cd_plano = T11.cd_plano and TT1.cd_especialidade is null order by TT2.dt_inicio desc, TT2.cd_tabela_referencia desc),(select top 1 round(TT1.vl_servico * case when TT1.tipoMoedaCalculo = 2 then 1 else T22.vl_us end,2) from tabela_servicos TT1, tabela_referencia TT2 where TT1.cd_tabela_referencia = TT2.cd_tabela_referencia and TT1.cd_tabela = @CD_Tabela and TT1.cd_servico = T22.cd_servico and TT1.cd_plano is null and TT1.cd_especialidade is null order by TT2.dt_inicio desc, TT2.cd_tabela_referencia desc)),isnull(isnull((select top 1 round(TT1.vl_servico * case when TT1.tipoMoedaCalculo = 2 then 1 else T22.vl_us end,2) from tabela_servicos TT1, tabela_referencia TT2 where TT1.cd_tabela_referencia = TT2.cd_tabela_referencia and TT1.cd_tabela = @CD_Tabela and TT1.cd_especialidade = T22.cd_especialidadereferencia and TT1.cd_plano = T11.cd_plano and TT1.cd_servico is null order by TT2.dt_inicio desc, TT2.cd_tabela_referencia desc),(select top 1 round(TT1.vl_servico * case when TT1.tipoMoedaCalculo = 2 then 1 else T22.vl_us end,2) from tabela_servicos TT1, tabela_referencia TT2 where TT1.cd_tabela_referencia = TT2.cd_tabela_referencia and TT1.cd_tabela = @CD_Tabela and TT1.cd_especialidade = T22.cd_especialidadereferencia and TT1.cd_plano is null and TT1.cd_servico is null order by TT2.dt_inicio desc, TT2.cd_tabela_referencia desc)),(select top 1 round(TT1.vl_servico * case when TT1.tipoMoedaCalculo = 2 then 1 else T22.vl_us end,2) from tabela_servicos TT1, tabela_referencia TT2 where TT1.cd_tabela_referencia = TT2.cd_tabela_referencia and TT1.cd_tabela = @CD_Tabela and TT1.cd_especialidade is null and TT1.cd_plano is null and TT1.cd_servico is null order by TT2.dt_inicio desc, TT2.cd_tabela_referencia desc)))
																end
															when T3.LocalTabelaPagamentoDentista = 2 then --Tabela por clínica
																case
																	when isnull(T3.TipoValorCalculoProdutividadeDentista,1) = 1 then --Valor em R$
																		isnull((select top 1 TT1.vl_servico from tabela_servicos TT1, tabela_referencia TT2 where TT1.cd_tabela_referencia = TT2.cd_tabela_referencia and TT1.cd_tabela = @CD_TabelaClinica and TT1.cd_servico = T1.cd_servico and TT1.cd_plano = T11.cd_plano order by TT2.dt_inicio desc, TT2.cd_tabela_referencia desc),(select top 1 TT1.vl_servico from tabela_servicos TT1, tabela_referencia TT2 where TT1.cd_tabela_referencia = TT2.cd_tabela_referencia and TT1.cd_tabela = @CD_TabelaClinica and TT1.cd_servico = T1.cd_servico and TT1.cd_plano is null order by TT2.dt_inicio desc, TT2.cd_tabela_referencia desc))
																	when T3.TipoValorCalculoProdutividadeDentista = 2 then --Valor em US, convertido para R$
																		isnull(isnull((select top 1 round(TT1.vl_servico * case when TT1.tipoMoedaCalculo = 2 then 1 else T22.vl_us end,2) from tabela_servicos TT1, tabela_referencia TT2 where TT1.cd_tabela_referencia = TT2.cd_tabela_referencia and TT1.cd_tabela = @CD_TabelaClinica and TT1.cd_servico = T22.cd_servico and TT1.cd_plano = T11.cd_plano and TT1.cd_especialidade is null order by TT2.dt_inicio desc, TT2.cd_tabela_referencia desc),(select top 1 round(TT1.vl_servico * case when TT1.tipoMoedaCalculo = 2 then 1 else T22.vl_us end,2) from tabela_servicos TT1, tabela_referencia TT2 where TT1.cd_tabela_referencia = TT2.cd_tabela_referencia and TT1.cd_tabela = @CD_TabelaClinica and TT1.cd_servico = T22.cd_servico and TT1.cd_plano is null and TT1.cd_especialidade is null order by TT2.dt_inicio desc, TT2.cd_tabela_referencia desc)),isnull(isnull((select top 1 round(TT1.vl_servico * case when TT1.tipoMoedaCalculo = 2 then 1 else T22.vl_us end,2) from tabela_servicos TT1, tabela_referencia TT2 where TT1.cd_tabela_referencia = TT2.cd_tabela_referencia and TT1.cd_tabela = @CD_TabelaClinica and TT1.cd_especialidade = T22.cd_especialidadereferencia and TT1.cd_plano = T11.cd_plano and TT1.cd_servico is null order by TT2.dt_inicio desc, TT2.cd_tabela_referencia desc),(select top 1 round(TT1.vl_servico * case when TT1.tipoMoedaCalculo = 2 then 1 else T22.vl_us end,2) from tabela_servicos TT1, tabela_referencia TT2 where TT1.cd_tabela_referencia = TT2.cd_tabela_referencia and TT1.cd_tabela = @CD_TabelaClinica and TT1.cd_especialidade = T22.cd_especialidadereferencia and TT1.cd_plano is null and TT1.cd_servico is null order by TT2.dt_inicio desc, TT2.cd_tabela_referencia desc)),(select top 1 round(TT1.vl_servico * case when TT1.tipoMoedaCalculo = 2 then 1 else T22.vl_us end,2) from tabela_servicos TT1, tabela_referencia TT2 where TT1.cd_tabela_referencia = TT2.cd_tabela_referencia and TT1.cd_tabela = @CD_TabelaClinica and TT1.cd_especialidade is null and TT1.cd_plano is null and TT1.cd_servico is null order by TT2.dt_inicio desc, TT2.cd_tabela_referencia desc)))
																end
														end
													when T3.RefAtualizacaoTabelaDentista = 2 then --Tabela por data de referência x data de realização do procedimento
														case
															when isnull(T3.LocalTabelaPagamentoDentista,1) = 1 then --Tabela por dentista
																case
																	when isnull(T3.TipoValorCalculoProdutividadeDentista,1) = 1 then --Valor em R$
																		isnull((select top 1 TT1.vl_servico from tabela_servicos TT1, tabela_referencia TT2 where TT1.cd_tabela_referencia = TT2.cd_tabela_referencia and TT1.cd_tabela = @CD_Tabela and TT1.cd_servico = T1.cd_servico and TT1.cd_plano = T11.cd_plano and convert(date,T1.dt_servico) >= TT2.dt_inicio and convert(date,T1.dt_servico) <= isnull(TT2.dt_fim,getdate())),(select top 1 TT1.vl_servico from tabela_servicos TT1, tabela_referencia TT2 where TT1.cd_tabela_referencia = TT2.cd_tabela_referencia and TT1.cd_tabela = @CD_Tabela and TT1.cd_servico = T1.cd_servico and TT1.cd_plano is null and convert(date,T1.dt_servico) >= TT2.dt_inicio and convert(date,T1.dt_servico) <= isnull(TT2.dt_fim,getdate())))
																	when T3.TipoValorCalculoProdutividadeDentista = 2 then --Valor em US, convertido para R$
																		isnull(isnull((select top 1 round(TT1.vl_servico * case when TT1.tipoMoedaCalculo = 2 then 1 else T22.vl_us end,2) from tabela_servicos TT1, tabela_referencia TT2 where TT1.cd_tabela_referencia = TT2.cd_tabela_referencia and TT1.cd_tabela = @CD_Tabela and TT1.cd_servico = T22.cd_servico and TT1.cd_plano = T11.cd_plano and TT1.cd_especialidade is null and convert(date,T1.dt_servico) >= TT2.dt_inicio and convert(date,T1.dt_servico) <= isnull(TT2.dt_fim,getdate())),(select top 1 round(TT1.vl_servico * case when TT1.tipoMoedaCalculo = 2 then 1 else T22.vl_us end,2) from tabela_servicos TT1, tabela_referencia TT2 where TT1.cd_tabela_referencia = TT2.cd_tabela_referencia and TT1.cd_tabela = @CD_Tabela and TT1.cd_servico = T22.cd_servico and TT1.cd_plano is null and TT1.cd_especialidade is null and convert(date,T1.dt_servico) >= TT2.dt_inicio and convert(date,T1.dt_servico) <= isnull(TT2.dt_fim,getdate()))),isnull(isnull((select top 1 round(TT1.vl_servico * case when TT1.tipoMoedaCalculo = 2 then 1 else T22.vl_us end,2) from tabela_servicos TT1, tabela_referencia TT2 where TT1.cd_tabela_referencia = TT2.cd_tabela_referencia and TT1.cd_tabela = @CD_Tabela and TT1.cd_especialidade = T22.cd_especialidadereferencia and TT1.cd_plano = T11.cd_plano and TT1.cd_servico is null and convert(date,T1.dt_servico) >= TT2.dt_inicio and convert(date,T1.dt_servico) <= isnull(TT2.dt_fim,getdate())),(select top 1 round(TT1.vl_servico * case when TT1.tipoMoedaCalculo = 2 then 1 else T22.vl_us end,2) from tabela_servicos TT1, tabela_referencia TT2 where TT1.cd_tabela_referencia = TT2.cd_tabela_referencia and TT1.cd_tabela = @CD_Tabela and TT1.cd_especialidade = T22.cd_especialidadereferencia and TT1.cd_plano is null and TT1.cd_servico is null and convert(date,T1.dt_servico) >= TT2.dt_inicio and convert(date,T1.dt_servico) <= isnull(TT2.dt_fim,getdate()))),(select top 1 round(TT1.vl_servico * case when TT1.tipoMoedaCalculo = 2 then 1 else T22.vl_us end,2) from tabela_servicos TT1, tabela_referencia TT2 where TT1.cd_tabela_referencia = TT2.cd_tabela_referencia and TT1.cd_tabela = @CD_Tabela and TT1.cd_especialidade is null and TT1.cd_plano is null and TT1.cd_servico is null and convert(date,T1.dt_servico) >= TT2.dt_inicio and convert(date,T1.dt_servico) <= isnull(TT2.dt_fim,getdate()))))
																end
															when T3.LocalTabelaPagamentoDentista = 2 then --Tabela por clínica
																case
																	when isnull(T3.TipoValorCalculoProdutividadeDentista,1) = 1 then --Valor em R$
																		isnull((select top 1 TT1.vl_servico from tabela_servicos TT1, tabela_referencia TT2 where TT1.cd_tabela_referencia = TT2.cd_tabela_referencia and TT1.cd_tabela = @CD_TabelaClinica and TT1.cd_servico = T1.cd_servico and TT1.cd_plano = T11.cd_plano and convert(date,T1.dt_servico) >= TT2.dt_inicio and convert(date,T1.dt_servico) <= isnull(TT2.dt_fim,getdate())),(select top 1 TT1.vl_servico from tabela_servicos TT1, tabela_referencia TT2 where TT1.cd_tabela_referencia = TT2.cd_tabela_referencia and TT1.cd_tabela = @CD_TabelaClinica and TT1.cd_servico = T1.cd_servico and TT1.cd_plano is null and convert(date,T1.dt_servico) >= TT2.dt_inicio and convert(date,T1.dt_servico) <= isnull(TT2.dt_fim,getdate())))
																	when T3.TipoValorCalculoProdutividadeDentista = 2 then --Valor em US, convertido para R$
																		isnull(isnull((select top 1 round(TT1.vl_servico * case when TT1.tipoMoedaCalculo = 2 then 1 else T22.vl_us end,2) from tabela_servicos TT1, tabela_referencia TT2 where TT1.cd_tabela_referencia = TT2.cd_tabela_referencia and TT1.cd_tabela = @CD_TabelaClinica and TT1.cd_servico = T22.cd_servico and TT1.cd_plano = T11.cd_plano and TT1.cd_especialidade is null and convert(date,T1.dt_servico) >= TT2.dt_inicio and convert(date,T1.dt_servico) <= isnull(TT2.dt_fim,getdate())),(select top 1 round(TT1.vl_servico * case when TT1.tipoMoedaCalculo = 2 then 1 else T22.vl_us end,2) from tabela_servicos TT1, tabela_referencia TT2 where TT1.cd_tabela_referencia = TT2.cd_tabela_referencia and TT1.cd_tabela = @CD_TabelaClinica and TT1.cd_servico = T22.cd_servico and TT1.cd_plano is null and TT1.cd_especialidade is null and convert(date,T1.dt_servico) >= TT2.dt_inicio and convert(date,T1.dt_servico) <= isnull(TT2.dt_fim,getdate()))),isnull(isnull((select top 1 round(TT1.vl_servico * case when TT1.tipoMoedaCalculo = 2 then 1 else T22.vl_us end,2) from tabela_servicos TT1, tabela_referencia TT2 where TT1.cd_tabela_referencia = TT2.cd_tabela_referencia and TT1.cd_tabela = @CD_TabelaClinica and TT1.cd_especialidade = T22.cd_especialidadereferencia and TT1.cd_plano = T11.cd_plano and TT1.cd_servico is null and convert(date,T1.dt_servico) >= TT2.dt_inicio and convert(date,T1.dt_servico) <= isnull(TT2.dt_fim,getdate())),(select top 1 round(TT1.vl_servico * case when TT1.tipoMoedaCalculo = 2 then 1 else T22.vl_us end,2) from tabela_servicos TT1, tabela_referencia TT2 where TT1.cd_tabela_referencia = TT2.cd_tabela_referencia and TT1.cd_tabela = @CD_TabelaClinica and TT1.cd_especialidade = T22.cd_especialidadereferencia and TT1.cd_plano is null and TT1.cd_servico is null and convert(date,T1.dt_servico) >= TT2.dt_inicio and convert(date,T1.dt_servico) <= isnull(TT2.dt_fim,getdate()))),(select top 1 round(TT1.vl_servico * case when TT1.tipoMoedaCalculo = 2 then 1 else T22.vl_us end,2) from tabela_servicos TT1, tabela_referencia TT2 where TT1.cd_tabela_referencia = TT2.cd_tabela_referencia and TT1.cd_tabela = @CD_TabelaClinica and TT1.cd_especialidade is null and TT1.cd_plano is null and TT1.cd_servico is null and convert(date,T1.dt_servico) >= TT2.dt_inicio and convert(date,T1.dt_servico) <= isnull(TT2.dt_fim,getdate()))))
																end
														end
													when T3.RefAtualizacaoTabelaDentista = 3 then --Tabela por data de referência de fator x data de realização do procedimento
														(select top 1 round(case when TF2.tipoValor = 2 then TF2.valor else TF1.vl_servico * case when TF1.tipoMoedaCalculo = 2 then 1 else TF2.valor end end, 2) from tabela_servicos TF1, tabela_fator TF2 where TF1.cd_tabela = case when isnull(T3.LocalTabelaPagamentoDentista,1) = 1 then @CD_Tabela else @CD_TabelaClinica end and TF1.cd_servico = T1.cd_servico and isnull(TF2.cd_servico,TF1.cd_servico) = T1.cd_servico and coalesce(TF2.cd_plano,TF1.cd_plano,T11.cd_plano) = T11.cd_plano and isnull(TF1.cd_plano,T11.cd_plano) = isnull(TF2.cd_plano,T11.cd_plano) and isnull(TF2.cd_especialidade,T22.cd_especialidadereferencia) = T22.cd_especialidadereferencia and case when isnull(T3.LocalTabelaPagamentoDentista,1) = 1 then TF2.cd_funcionario else TF2.cd_filial end = case when isnull(T3.LocalTabelaPagamentoDentista,1) = 1 then T1.cd_funcionario else T1.cd_filial end and convert(date,isnull(T1.dt_servico,getdate())) >= TF2.dataInicial and convert(date,isnull(T1.dt_servico,getdate())) <= isnull(TF2.dataFinal,getdate()) and TF2.dataExclusao is null order by TF2.cd_plano desc, TF1.cd_plano desc, TF2.cd_servico desc, TF2.cd_especialidade desc)
													else
														-1
												end
											end
									,-1) valorProcedimento,
									dbo.FS_Idade(isnull(T11.DT_NASCIMENTO,'1900-01-01'), T1.DT_Servico) idade, T1.cd_servico, T22.cd_especialidadereferencia,
									(select count(distinct nr_numero_lote) from consultas where nr_gto = T1.nr_gto and nr_numero_lote is not null) QtdeGTOLote,
									T1.cd_sequencial_dep, isnull(T22.cd_peso,0) cd_peso, T1.dt_servico
									,t1.nr_gto
									From consultas T1, dependentes T11, servico T22, Configuracao T3, funcionario T4, orcamento_servico T5, funcionario_especialidade T6
									Where T1.cd_sequencial_dep = T11.cd_sequencial
									and T1.cd_servico = T22.CD_Servico
									and T1.cd_funcionario = T4.cd_funcionario
									and T1.cd_sequencial = T5.cd_sequencial_pp
									and T1.cd_funcionario = T6.cd_funcionario
									and T22.cd_especialidadereferencia = T6.cd_especialidade
									and convert(date,T1.dt_servico) <= @Data_Corte_final
									and case when @dataBuscaProtocoloInicial <> '' then case when T1.dt_recebimento_protocolo >= @dataBuscaProtocoloInicial + ' 00:00' then 1 else 0 end else 1 end = 1
									and case when @dataBuscaProtocoloFinal <> '' then case when T1.dt_recebimento_protocolo <= @dataBuscaProtocoloFinal + ' 23:59:59' then 1 else 0 end else 1 end = 1
									and T1.DT_Servico Is Not null
									and T1.dt_cancelamento Is null
									and T1.Status in (3,6)
									and case when isnull(T3.TipoValorCalculoProdutividadeDentista,1) = 1 then (select count(0) from tabela_servicos where cd_servico = T1.cd_servico) else 1 end > 0
									and T1.cd_funcionario = @CD_Funcionario
									and T1.CD_Filial = @CD_Empresa
									and case when @tipoFaturamento = 1 then case when T1.nr_numero_lote is null then 1 else 0 end else 1 end = 1
									and case when @tipoFaturamento = 2 then case when T1.nr_numero_lote_clinica is null then 1 else 0 end else 1 end = 1
									and (@tipoFaturamento = 2 or (
										case when T22.periciaFinal = 1 or T4.periciaFinal = 1 then case when T1.dtPericiaFinal is null then 0 else 1 end else 1 end = 1
										and T1.nr_procedimentoliberado = 1
										and (T1.CD_Sequencial_Dep not in (
											Select t10.cd_sequencial 
											From dependentes t10, ASSOCIADOS t20, EMPRESA t30
											Where t10.cd_associado = t20.cd_associado
											and t20.cd_empresa = t30.CD_EMPRESA
											and t30.TP_EMPRESA = 10
										) or T3.incluirProcPartProdutividade = 1)
										and T1.cd_sequencial Not in (Select cd_sequencial from tb_consultasdocumentacao where cd_sequencial = t1.cd_sequencial and foto_digitalizada = 0)
										and (T1.cd_sequencial Not in (select cd_sequencial_pp from orcamento_servico where cd_sequencial_pp = t1.cd_sequencial) or T3.incluirProcPartProdutividade = 1)
										and case when @auditoriaClinicoPagamentoProtocolo = 1 and T1.dt_recebimento_protocolo is null then 0 else 1 end = 1
									))
									and CHARINDEX(',' + convert(varchar(10),T11.cd_plano) + ',', ',' + isnull(@codigosPlano,convert(varchar(10),T11.cd_plano)) + ',') > 0
									
									---INICIO #16898
									and case when @filtroConvenio <= -2 then 1 
										when @filtroConvenio = 0  then (select count(0) from planos as p, CLASSIFICACAO_ANS ans where T11.cd_plano = p.cd_plano and p.cd_classificacao = ans.cd_classificacao and ans.IdConvenio is null)
										when @filtroConvenio = -1 then (select count(0) from planos as p, CLASSIFICACAO_ANS ans where T11.cd_plano = p.cd_plano and p.cd_classificacao = ans.cd_classificacao and ans.IdConvenio is not null)
										when @filtroConvenio > 0  then (select count(0) from planos as p, CLASSIFICACAO_ANS ans where T11.cd_plano = p.cd_plano and p.cd_classificacao = ans.cd_classificacao and ans.IdConvenio is not null and ans.IdConvenio = @filtroConvenio)
										else 0 end > 0
									---FIM #16898

									Union all
									
									/*glosado*/
									Select t1.cd_sequencial, 0 valorProcedimento, dbo.FS_Idade(isnull(T11.DT_NASCIMENTO,'1900-01-01'), T1.DT_Servico) idade, T1.cd_servico, T22.cd_especialidadereferencia,
									(select count(distinct nr_numero_lote) from consultas where nr_gto = T1.nr_gto and nr_numero_lote is not null) QtdeGTOLote,
									T1.cd_sequencial_dep, 0 cd_peso, T1.dt_servico
									,t1.nr_gto
									From consultas t1, Configuracao T3, dependentes T11, servico T22, funcionario T4
									Where T1.cd_sequencial_dep = T11.cd_sequencial
									and T1.cd_servico = T22.CD_Servico
									and T1.cd_funcionario = T4.cd_funcionario
									and convert(date,T1.dt_servico) <= @Data_Corte_final
									and case when @dataBuscaProtocoloInicial <> '' then case when T1.dt_recebimento_protocolo >= @dataBuscaProtocoloInicial + ' 00:00' then 1 else 0 end else 1 end = 1
									and case when @dataBuscaProtocoloFinal <> '' then case when T1.dt_recebimento_protocolo <= @dataBuscaProtocoloFinal + ' 23:59:59' then 1 else 0 end else 1 end = 1
									and T1.DT_Servico Is Not null
									and T1.dt_cancelamento Is null
									and T1.Status = 7
									and case when isnull(T3.TipoValorCalculoProdutividadeDentista,1) = 1 then (select count(0) from tabela_servicos where cd_servico = T1.cd_servico) else 1 end > 0
									and T1.cd_funcionario = @CD_Funcionario
									and T1.CD_Filial = @CD_Empresa
									and case when @tipoFaturamento = 1 then case when T1.nr_numero_lote is null then 1 else 0 end else 1 end = 1
									and case when @tipoFaturamento = 2 then case when T1.nr_numero_lote_clinica is null then 1 else 0 end else 1 end = 1
									and (@tipoFaturamento = 2 or (
										case when T22.periciaFinal = 1 or T4.periciaFinal = 1 then case when T1.dtPericiaFinal is null then 0 else 1 end else 1 end = 1
										and T1.nr_procedimentoliberado = 1
										and (T1.cd_sequencial not in (select cd_sequencial_pp from orcamento_servico where cd_sequencial_pp = t1.cd_sequencial) or T3.incluirProcPartProdutividade = 1)
										and case when @auditoriaClinicoPagamentoProtocolo = 1 and T1.dt_recebimento_protocolo is null then 0 else 1 end = 1
									))
									and CHARINDEX(',' + convert(varchar(10),T11.cd_plano) + ',', ',' + isnull(@codigosPlano,convert(varchar(10),T11.cd_plano)) + ',') > 0
									
									---INICIO #16898
									and case when @filtroConvenio <= -2 then 1 
										 when @filtroConvenio = 0  then (select count(0) from planos as p, CLASSIFICACAO_ANS ans where T11.cd_plano = p.cd_plano and p.cd_classificacao = ans.cd_classificacao and ans.IdConvenio is null)
										 when @filtroConvenio = -1 then (select count(0) from planos as p, CLASSIFICACAO_ANS ans where T11.cd_plano = p.cd_plano and p.cd_classificacao = ans.cd_classificacao and ans.IdConvenio is not null)
										 when @filtroConvenio > 0  then (select count(0) from planos as p, CLASSIFICACAO_ANS ans where T11.cd_plano = p.cd_plano and p.cd_classificacao = ans.cd_classificacao and ans.IdConvenio is not null and ans.IdConvenio = @filtroConvenio)
										else 0 end > 0
									---FIM #16898
								) y
								order by y.cd_sequencial_dep, y.dt_servico

								Set @Valor_Total_Pagar = 0
								Set @Valor_Total_Pagar_Recurso = 0
                                Set @Quantidade_Procedimento = 0
                                Set @cd_sequencial_depComparacao = -1
                                Set @somaPeso = 0
                                Set @cd_peso = 0
                                set @nr_gto = ''

								Open Procedimentos_Cursor
								Fetch next from Procedimentos_Cursor
								Into @CD_Sequencial, @Valor_Procedimento, @Idade_Dep, @Cd_servico, @Cd_EspecialidadeServico, @QtdeGTOLote, @cd_sequencial_dep, @cd_peso, @dt_servico, @nr_gto

								While (@@fetch_status <> -1)
									Begin
										Set @calcular = 0

										If (@CriarLote = 0)
											Begin
												--Novo lote
												Insert into Pagamento_Dentista (cd_funcionario,dt_abertura,data_corte,usuario_abertura,tipoFaturamento)
												Values (@CD_Funcionario,getdate(),convert(datetime,@Data_Corte_final), case when @usuario_abertura = 0 then null else @usuario_abertura end, @tipoFaturamento)
												Set @CD_Pagamento_Dentista = @@IDENTITY
												Set @CriarLote = 1
											End

										If (@Valor_Total_Pagar + @Valor_Procedimento <= @Valor_Teto)
											begin
												if (@pontosMaximosProcedimentoUsuarioLote is not null or @qtdeMaximaProcedimentoUsuarioLote is not null)
													begin
														if (@cd_sequencial_depComparacao <> @cd_sequencial_dep)
															begin
																Set @somaPeso = 0
																Set @cd_sequencial_depComparacao = @cd_sequencial_dep
															end
		
														if(@pontosMaximosProcedimentoUsuarioLote is not null)
															begin
																If (@somaPeso + @cd_peso <= @pontosMaximosProcedimentoUsuarioLote)
																	begin
																		Set @somaPeso += @cd_peso
																		Set @calcular = 1
																	end
															end
														else
															begin
																If (@somaPeso + 1 <= @qtdeMaximaProcedimentoUsuarioLote)
																	begin
																		Set @somaPeso += 1
																		Set @calcular = 1
																	end
															end
													end
												else
													begin
														Set @calcular = 1
													end
											end

										If (@calcular = 1 or @Valor_Procedimento = 0 or @nr_gto like '%RG')
											Begin
												if(@Valor_Procedimento > -1)
													begin
														--************************************************************************************
														---Valor de acréscimo na tabela configuracao (Valor_Acrecimo14anos).
														---0 = null. Válido para especialidades Clínico e Dentística
														if @Altera_ProdutDent = 1 and @Idade_Dep < 14 and @Cd_servico <> 81000065 and @Valor_Procedimento > 0 and @Cd_EspecialidadeClinico > 0 and @Cd_EspecialidadeServico in (1,4)
															set @Valor_Procedimento = @Valor_Procedimento + @Valor_Acrecimo14anos
														--************************************************************************************

														Update Consultas Set
														nr_gtoTISS = case when @tipoFaturamento = 1 then nr_gto else nr_gtoTISS end,
														nr_numero_lote = case when @tipoFaturamento = 1 then @CD_Pagamento_Dentista else nr_numero_lote end,
														nr_numero_lote_clinica = case when @tipoFaturamento = 2 then @CD_Pagamento_Dentista else nr_numero_lote_clinica end,
														vl_pago_produtividade = case when @tipoFaturamento = 1 then round(@Valor_Procedimento, 2) else vl_pago_produtividade end,
														vl_pago_produtividade_clinica = case when @tipoFaturamento = 2 then round(@Valor_Procedimento, 2) else vl_pago_produtividade_clinica end,
														dt_recebimento_protocolo = case when @tipoFaturamento = 1 then case when @DataProtocolo <> '' then @DataProtocolo else dt_recebimento_protocolo end else dt_recebimento_protocolo end,
														ExecutarTrigger = 0
														Where cd_sequencial = @CD_Sequencial
														
														if(@QtdeGTOLote > 0 and @tipoFaturamento = 1)
															begin
																Update Consultas Set
																nr_gtoTISS = nr_gtoTISS + 'R' + convert(varchar(10),@QtdeGTOLote),
																ExecutarTrigger = 0
																Where cd_sequencial = @CD_Sequencial
															end

														if(@cd_filialPrestador > 0)
															begin
																Update Consultas Set
																cd_filialOriginal = cd_filial,
																cd_filial = @cd_filialPrestador,
																ExecutarTrigger = 0
																Where cd_sequencial = @CD_Sequencial
															end
															
														Set @Aviso_Numero_Procedimentos = 1
														if  @nr_gto like '%RG'
                                                            Set @Valor_Total_Pagar_Recurso = @Valor_Total_Pagar_Recurso + @Valor_Procedimento
                                                        else
															Set @Valor_Total_Pagar = @Valor_Total_Pagar + @Valor_Procedimento
														Set @Quantidade_Procedimento += 1
													end
											end

									Fetch Next From Procedimentos_Cursor
									Into @CD_Sequencial, @Valor_Procedimento, @Idade_Dep , @Cd_servico , @Cd_EspecialidadeServico, @QtdeGTOLote, @cd_sequencial_dep, @cd_peso, @dt_servico, @nr_gto
								End
								Close Procedimentos_Cursor
								Deallocate Procedimentos_Cursor

								If @Valor_Total_Pagar < @Valor_Teto
									begin
										Set @vl_correcao = @Valor_Teto - @Valor_Total_Pagar
									end
		
								If @Quantidade_Procedimento = 0
									begin
										delete Pagamento_Dentista Where CD_Sequencial = @CD_Pagamento_Dentista
									end

								If @Quantidade_Procedimento > 0
									begin
										update Pagamento_Dentista set
							                        qt_procedimentos = @Quantidade_Procedimento,
													vl_parcela = round(@Valor_Total_Pagar, 2) + round(@Valor_Total_Pagar_Recurso, 2),
							                        dt_fechamento = @Data_Atual,
							                        fl_fechado = 1,
							                        cd_filial = isnull(@cd_filialPrestador,@CD_Empresa),
													cd_filialOriginal = case when @cd_filialPrestador > 0 then @CD_Empresa else null end,
							                        data_corte = @Data_Corte_final,
							                        --vl_acerto = case when @Vl_fixo_Produtividade > 0 then round(@Vl_fixo_Produtividade - @Valor_Total_Pagar, 2) else 0 end ,
							                        --motivo_acerto = case when @Vl_fixo_Produtividade > 0 then 'Ajuste devido a valor fixo' else NULL end ,
							                        cd_modelo_pgto_prestador = @modelo,
							                        cd_centro_custo =
							                        case
														when @fl_CalcProdCenCusto = 0 then
															@cd_Centrocusto_padraoprodutividade
														else
															case
																when @tipoFaturamento = 1 then
																	(select MIN(e.cd_centro_custo) from Consultas as c, DEPENDENTES as d, ASSOCIADOS as a, EMPRESA as e where c.nr_numero_lote = @CD_Pagamento_Dentista and c.cd_sequencial_dep = d.CD_SEQUENCIAL and d.CD_ASSOCIADO = a.cd_associado and a.cd_empresa = e.CD_EMPRESA)
																when @tipoFaturamento = 2 then
																	(select MIN(e.cd_centro_custo) from Consultas as c, DEPENDENTES as d, ASSOCIADOS as a, EMPRESA as e where c.nr_numero_lote_clinica = @CD_Pagamento_Dentista and c.cd_sequencial_dep = d.CD_SEQUENCIAL and d.CD_ASSOCIADO = a.cd_associado and a.cd_empresa = e.CD_EMPRESA)
																end
														end,
							                        TipoLiberacaoVisualizacao =
							                        case
							                              when @TipoLiberacaoVisualizacao = -1 then null
							                              else @TipoLiberacaoVisualizacao
							                       end,
							                              dt_liberacao_visualizacao =
							                       case
							                              when @dt_liberacao_visualizacao = '' then null
							                              else @dt_liberacao_visualizacao
							                       end,
							                              dt_competencia_pagamento =
							                       case
							                              when @dt_competencia_pagamento = '' then null
							                              else @dt_competencia_pagamento
							                       end
						                              Where CD_Sequencial = @CD_Pagamento_Dentista
									end

									
									if (@fl_CalcProdSeparacao = 1) -- Separar por centro de custo
										Begin
											exec SP_PagamentoDentista_CC @CD_Pagamento_Dentista
										End

									if (@fl_CalcProdSeparacao = 2) -- Separar por convenio
										Begin
											exec SP_PagamentoDentista_Convenio @CD_Pagamento_Dentista
										End

									if (@tipoRede = 3)
										Begin
											update pagamento_dentista set
											vl_parcela = 0
											where CD_Sequencial = @CD_Pagamento_Dentista
										End

					Fetch next from Modelos_Cursor
					Into @modelo, @perc_modelo, @Valor_Teto, @Vl_fixo_Produtividade, @cd_filialPrestador
				End
				Close Modelos_Cursor
				Deallocate Modelos_Cursor
         
		--Próxima clinica
		Fetch next from Dados_Cursor  
		Into @CD_Funcionario, @CD_Empresa, @NM_Filial, @tipoRede, @pontosMaximosProcedimentoUsuarioLote, @qtdeMaximaProcedimentoUsuarioLote, @NM_Funcionario, @CD_Tabela, @CD_TabelaClinica, @Valor_Teto_Clinica,@valor_Teto_Dentista, @Vl_fixo_Produtividade, @Cd_EspecialidadeClinico, @totalProcedimentos
	End
	Close Dados_Cursor  
	Deallocate Dados_Cursor  

	Commit Transaction

	If (@Aviso_Numero_Procedimentos>0)
		begin
			Select 0 as gerou
		end
	else
		begin
			Select 1 as gerou
		end
End
