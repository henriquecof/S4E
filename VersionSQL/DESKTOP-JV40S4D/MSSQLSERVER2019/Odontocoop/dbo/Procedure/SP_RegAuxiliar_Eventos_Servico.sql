/****** Object:  Procedure [dbo].[SP_RegAuxiliar_Eventos_Servico]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE Procedure [dbo].[SP_RegAuxiliar_Eventos_Servico] (@mes varchar(2), @ano varchar(4), @tipo as tinyint, @centro_custo varchar(8000) = '', @modelo varchar(8000) = '', @formacaoPreco int = -1)
as 
Begin 

    -- @tipo = 1 - Conhecidos, 2 - Pagos, 3 - Atrasadas na competência , 4 - Atrasados acumulados e 5 - Glosa Fiscal

    -- declare @mes varchar(2)='07', @ano varchar(4)='2014', @tipo as tinyint=1, @centro_custo int=0
    
	Declare @SQL varchar(max)
	Declare @dt_i date --= '08/01/2013' 
	Declare @dt_f date --= '09/01/2013' 
    Declare @tipoFaturamento varchar(1) = 4 -- 1-Parcial, 2-Final, 3-Complementar, 4-Total

	Set @dt_i = convert(date,@mes + '/01/' + @ano )
	Set @dt_f = DATEADD(month,1,@dt_i)

    Set @SQL = '	
	select t1.cd_pgto_dentista_lanc,
	       isnull(t5.nr_gto,t5.cd_sequencial) as numeroGuia_operadora,
		   case when T1.cd_filial IS not null and T4.nr_cgc IS not null then T4.nr_cgc 
				when T1.cd_filial IS not null and T4.nr_cgc IS null then T41.nr_cpf 
				else t6.nr_cpf 
		   end as codigoCNPJ_CPF, 
		   t4.nm_filial as Prestador,
		   t6.nm_empregado as Executante,		   
		   cans.cd_ans as numeroRegistroPlano, 
		   t7.CD_SEQUENCIAL as Codigo,
		   t7.NM_DEPENDENTE as Usuario,
		   t7.cco as CCO ,		   
		   t5.dt_servico as dataRealizacao,
		   isnull(t5.dt_recebimento_protocolo,T2.dt_fechamento) as dataProtocoloCobranca,
		   T1.dt_gerado as dataProcessamentoGuia, 		   
		   case when T2.dt_pagamento IS not null then T2.dt_pagamento 
				when f.Data_pagamento is not null then f.Data_pagamento  
				else null end dataPagamento, ' + 
           @tipoFaturamento + ' as tipoFaturamento,
		   isnull(s.cd_servicoANS,s.cd_servico) AS codigoProcedimento,  
           1 as quantidadeInformada,           
           case when T5.status = 7 then isnull(T5.vl_glosa,0) else isnull(T5.vl_pago_produtividade,0)+isnull(t5.vl_acerto_pgto_produtividade,0) end as valorInformado, -- Verificar se nao esta vinfo zero por conta da glosa
           case when T5.status = 7 then 0 else isnull(T5.vl_pago_produtividade,0)+isnull(t5.vl_acerto_pgto_produtividade,0) end as valorProcessado,
           case when T5.status = 7 then isnull(T5.vl_glosa,0) else 0 end as valorGlosado,
           case when T2.dt_pagamento IS null and f.Data_pagamento is null then 0 else case when T5.status = 7 then 0 else T5.vl_pago_produtividade end end AS valorPagoProc,
           convert(varchar(10),T1.dt_conhecimento,103) dt_conhecimento, S.nm_servico, a.cd_associado, a.nm_completo, 
           T5.cd_sequencial as cd_sequencial_consulta,tp.ds_empresa,
           LC.Numero_Cheque,
           VD.Descricao,isnull(M.valor,0) as Co_Participacao, M.cd_sequencial, T5.status, T7.nr_carteira, e.cd_empresa, e.nm_razsoc, e.nm_fantasia,
           T10.descricaoGrupoClinica, T11.nm_grupo, isnull(T12.RazaoSocial,T19.RazaoSocial) RazaoSocialConvenio,
           T13.nm_empregado Solicitante,
           T14.nm_filial PrestadorSolicitante,
           (select count(0) from orcamento_servico where cd_sequencial_pp = T5.cd_sequencial) ProcedimentoOrcamento,
           T8.nm_plano, T15.vl_dominio descricaoFormacaoPreco, T1.sequencial_lancamento, T16.nm_especialidade,
           case when T4.nr_cgc is not null then ''PJ'' else ''PF'' end tipo_prestador,
           T17.ds_centro_custo ds_centro_custoFilial,
           T18.ufSigla ufSiglaFilial,
           T20.ds_centro_custo ds_centro_custoEmpresa
	        
	  from Pagamento_Dentista_Lancamento T1 
				inner join pagamento_dentista T2 on T1.cd_pgto_dentista_lanc = T2.cd_pgto_dentista_lanc
				inner join Modelo_Pagamento_Prestador T3 on T1.cd_modelo_pgto_prestador = T3.cd_modelo_pgto_prestador
				inner join Filial T4 on T2.cd_filial = T4.cd_filial
				left  join FUNCIONARIO T41 on  T4.cd_funcionario_responsavel = T41.cd_funcionario 
				inner join Consultas T5 on T2.cd_sequencial = T5.nr_numero_lote
				inner join FUNCIONARIO T6 on T2.cd_funcionario = T6.cd_funcionario -- Funcionario da Pagamento Dentista
				inner join Dependentes T7 on T5.cd_sequencial_dep = T7.cd_sequencial
				inner join ASSOCIADOS a on T7.CD_ASSOCIADO = a.cd_associado
				inner join EMPRESA as E on a.cd_empresa = e.cd_empresa
				inner join Planos T8 on T7.cd_plano = T8.cd_plano
				left  join CLASSIFICACAO_ANS Cans on T8.cd_classificacao = Cans.cd_classificacao 
				inner join SERVICO as S on t5.cd_servico = s.CD_SERVICO 
				left  join TB_FormaLancamento as f on T1.sequencial_lancamento = f.Sequencial_Lancamento
				inner join tipo_empresa as tp on E.tp_empresa = tp.tp_empresa 
				left join TB_LancamentoCheque LC ON LC.Sequencial_FormaLancamento = f.Sequencial_FormaLancamento
				left join TB_ValorDominio VD ON VD.CodigoValorDominio = LC.Situacao_Cheque AND VD.CodigoDominio = 7
				left join mensalidades_planos as M on T5.cd_sequencial = M.cd_sequencial_consulta
				left join grupoClinica T10 on T4.idGrupoClinica = T10.idGrupoClinica
				left join grupo T11 on E.cd_grupo = T11.cd_grupo
				left join Convenio T12 on Cans.idConvenio = T12.id
				left join funcionario T13 on T13.cd_funcionario = T5.CD_Funcionario_Solicitante
				left join filial T14 on T14.cd_filial = T5.cd_filial_Solicitante
				left join dominio_valor T15 on T15.cd_sequencial = isnull(T7.formacaoPreco,Cans.formacaoPreco) and T15.cd_dominio = 70
				left join especialidade T16 on T16.cd_especialidade = s.cd_especialidadereferencia
				left join centro_custo T17 on T17.cd_centro_custo = T4.cd_centro_custo
				left join UF T18 on T18.ufId = T4.ufId
				left join configuracao T19 on 1 = 1
				left join centro_custo T20 on T20.cd_centro_custo = E.cd_centro_custo
	 where '
	 
	if @tipo = 1 -- Conhecidos
		begin
			Set @SQL = @SQL + ' T1.dt_conhecimento >= '''+convert(varchar(10),@dt_i,101)+''' and T1.dt_conhecimento < '''+convert(varchar(10),@dt_f,101)+''' '
		end
	if @tipo = 2 -- Pagos
		begin
			Set @SQL = @SQL + '(
				(T2.dt_pagamento >= '''+convert(varchar(10),@dt_i,101)+''' and T2.dt_pagamento < '''+convert(varchar(10),@dt_f,101)+''' ) or 
				(f.Data_pagamento >= '''+convert(varchar(10),@dt_i,101)+'''  and f.Data_pagamento < '''+convert(varchar(10),@dt_f,101)+''' )
				) '
		end
	if @tipo = 3 -- Atrasadas na competência
		begin
			Set @SQL = @SQL + ' T1.dt_conhecimento >= '''+convert(varchar(10),@dt_i,101)+''' and T1.dt_conhecimento < '''+convert(varchar(10),@dt_f,101)+''' and T2.dt_pagamento is null and f.Data_pagamento is null '
		end
	if @tipo = 4 -- Atrasadas acumulados (até a competência)
		begin
			Set @SQL = @SQL + ' (T2.dt_previsao_pagamento < '''+convert(varchar(10),@dt_f,101)+''' or f.Data_Documento < '''+convert(varchar(10),@dt_f,101)+''') '
			Set @SQL = @SQL + ' and (datediff(month,T2.dt_previsao_pagamento,getdate()) <= isnull(T19.qt_Meses_glosa_fiscal,datediff(month,T2.dt_previsao_pagamento,getdate())) or datediff(month,f.Data_Documento,getdate()) <= isnull(T19.qt_Meses_glosa_fiscal,datediff(month,f.Data_Documento,getdate()))) '
			Set @SQL = @SQL + ' and T2.dt_pagamento is null '
			Set @SQL = @SQL + ' and f.Data_pagamento is null '
			Set @SQL = @SQL + ' and T1.dt_conhecimento is not null '
		end
	if @tipo = 5 -- Atrasadas acumulados - Glosa fiscal (até a competência)
		begin
			Set @SQL = @SQL + ' (T2.dt_previsao_pagamento < '''+convert(varchar(10),@dt_f,101)+''' or f.Data_Documento < '''+convert(varchar(10),@dt_f,101)+''') '
			Set @SQL = @SQL + ' and (datediff(month,T2.dt_previsao_pagamento,getdate()) > isnull(T19.qt_Meses_glosa_fiscal,datediff(month,T2.dt_previsao_pagamento,getdate())) or datediff(month,f.Data_Documento,getdate()) > isnull(T19.qt_Meses_glosa_fiscal,datediff(month,f.Data_Documento,getdate()))) '
			Set @SQL = @SQL + ' and T2.dt_pagamento is null '
			Set @SQL = @SQL + ' and f.Data_pagamento is null '
			Set @SQL = @SQL + ' and T1.dt_conhecimento is not null '
		end

	 if @centro_custo <> '' 
	   Set @SQL = @SQL + ' and T1.cd_centro_custo in (' + @centro_custo + ')'
    
	 if @modelo <> '' 
	   Set @SQL = @SQL + ' and T1.cd_modelo_pgto_prestador in (' + @modelo + ')'

	 if @formacaoPreco > 0
	   Set @SQL = @SQL + ' and isnull(T7.formacaoPreco,Cans.formacaoPreco) = ' + convert(varchar,@formacaoPreco)
             
	 Set @SQL = @SQL + ' 
	   and T5.dt_servico is not null
	   and T5.dt_cancelamento is null
	   and (T5.vl_pago_produtividade>0 or T5.vl_glosa>0)
	 order by t1.cd_pgto_dentista_lanc,t5.dt_servico '

     --print @sql
     exec (@SQL)

End
