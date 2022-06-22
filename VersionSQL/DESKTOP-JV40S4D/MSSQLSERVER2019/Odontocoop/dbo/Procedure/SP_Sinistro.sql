/****** Object:  Procedure [dbo].[SP_Sinistro]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE Procedure [dbo].[SP_Sinistro]
    @dt_ini datetime, 
  @dt_fim datetime,
  @cd_centro_custo int, 
  @mes smallint, 
  @tabela int,
  @cd_empresa int ,
  @cd_grupo_empresa int,
  @dt_assinatura_ini datetime = null, 
  @dt_assinatura_fim datetime = null,
  @cd_plano varchar(1000) = null,
  @grupoAnalise int = null,
  @depid int = null,
  @tipoPagamento int = null,
 -- @tipoEmpresa int = null,
  @tipoEmpresa varchar(1000) = null,
  @tipoData int = 1, /* 1 - Data de Serviço, 2 - Data de Previsão, 3 - Data de Pagamento */
  @valorPago int = 1, /* 1 - Vencimento Pago, 2 - Vencimento, 3 - Pagamento */
  @qtVidaIni int = null,
  @qtVidaFin int = null
  ,@mesAssContrato int = 0
  ,@anoAssContrato int = 0
As 
Begin   

    -- *************************************************************************
    -- Essa procedure foi quebrada em 2 variaveis pois estoura o tamanho. 
    -- Cuidado para nao errar o nome da variavel
    -- *************************************************************************
    
    Declare @sql varchar(max)
    Declare @sql1 varchar(max)
    
    Set @sql = '
    select a.cd_empresa cd_associado , a.NM_FANTASIA  nm_responsavel, e.ds_empresa  , 
           a.mm_aaaa_1pagamento_empresa ,a.dt_vencimento, a.DT_FECHAMENTO_CONTRATO, 
           m.NM_MUNICIPIO , nm_tipo_pagamento,  sh.NM_SITUACAO_HISTORICO  ,

       (select count(0) from associados as a1 , dependentes as d1, historico as h1	, situacao_historico as s1
         where a1.cd_empresa = a.cd_empresa and 
               a1.cd_Associado = d1.cd_Associado and d1.cd_grau_parentesco = 1 and 
               d1.cd_sequencial_historico = h1.cd_sequencial and 
               h1.cd_situacao = s1.cd_situacao_historico and 
               s1.fl_atendido_clinica=1 '
			
			  if @dt_assinatura_ini is not null and @dt_assinatura_fim is not null
			  begin
			     Set @sql = @sql +
		                ' and d1.dt_assinaturacontrato >= '''+convert(varchar(10),@dt_assinatura_ini,101)+''' 
		                  and d1.dt_assinaturacontrato <= '''+convert(varchar(10),@dt_assinatura_fim,101)+''' '
			  End
		      if @cd_plano is not null and @cd_plano <> ''
		      begin
			     Set @sql = @sql +
		                ' and d1.cd_plano in ('+@cd_plano+') '		      
		      end 				  
			     Set @sql = @sql +
		                '     ) as qt_tit, 

       (select count(0) 
          from associados as a1 , 
               dependentes as d1 , historico as h1, situacao_historico as s1, 
               dependentes as d2 , historico as h2 , situacao_historico as s2
         where a1.cd_empresa = a.cd_empresa and 
               a1.cd_associado = d1.cd_Associado and d1.cd_grau_parentesco >= 1 and 
               d1.cd_sequencial_historico = h1.cd_sequencial and 
               h1.cd_situacao = s1.cd_situacao_historico and 
               s1.fl_atendido_clinica=1 and 
               a1.cd_associado = d2.cd_Associado and d2.cd_grau_parentesco = 1 and 
               d2.cd_sequencial_historico = h2.cd_sequencial and 
               h2.cd_situacao = s2.cd_situacao_historico and 
               s2.fl_atendido_clinica=1 and 
               d1.CD_SEQUENCIAL <> d2.CD_SEQUENCIAL '
			
			  if @dt_assinatura_ini is not null and @dt_assinatura_fim is not null
			  begin
			     Set @sql = @sql +
		                ' and d1.dt_assinaturacontrato >= '''+convert(varchar(10),@dt_assinatura_ini,101)+''' 
		                  and d1.dt_assinaturacontrato <= '''+convert(varchar(10),@dt_assinatura_fim,101)+''' '
			  End
		      if @cd_plano is not null and @cd_plano <> ''
		      begin
			     Set @sql = @sql +
		                ' and d1.cd_plano in ('+@cd_plano+') '		      
		      end 				  
			     Set @sql = @sql +
		                '      ) as qt_dep, 
               
       -- Colocar o valor total               
       isnull((select SUM(d1.vl_plano) 
         from associados as a1 , dependentes as d1, historico as h1	, situacao_historico as s1
         where a1.cd_empresa = a.cd_empresa and 
               a1.cd_Associado = d1.cd_Associado and d1.cd_grau_parentesco = 1 and 
               d1.cd_sequencial_historico = h1.cd_sequencial and 
               h1.cd_situacao = s1.cd_situacao_historico and 
               s1.fl_atendido_clinica=1  '
			
			  if @dt_assinatura_ini is not null and @dt_assinatura_fim is not null
			  begin
			     Set @sql = @sql +
		                ' and d1.dt_assinaturacontrato >= '''+convert(varchar(10),@dt_assinatura_ini,101)+''' 
		                  and d1.dt_assinaturacontrato <= '''+convert(varchar(10),@dt_assinatura_fim,101)+''' '
			  End
		      if @cd_plano is not null and @cd_plano <> ''
		      begin
			     Set @sql = @sql +
		                ' and d1.cd_plano in ('+@cd_plano+') '		      
		      end 				  
			     Set @sql = @sql +
		                '     ) ,0)
        +  
       isnull((select SUM(d1.vl_plano)
          from associados as a1 , 
               dependentes as d1 , historico as h1, situacao_historico as s1, 
               dependentes as d2 , historico as h2 , situacao_historico as s2
         where a1.cd_empresa = a.cd_empresa and 
               a1.cd_associado = d1.cd_Associado and d1.cd_grau_parentesco >= 1 and 
               d1.cd_sequencial_historico = h1.cd_sequencial and 
               h1.cd_situacao = s1.cd_situacao_historico and 
               s1.fl_atendido_clinica=1 and 
               a1.cd_associado = d2.cd_Associado and d2.cd_grau_parentesco = 1 and 
               d2.cd_sequencial_historico = h2.cd_sequencial and 
               h2.cd_situacao = s2.cd_situacao_historico and 
               s2.fl_atendido_clinica=1 and 
               d1.CD_SEQUENCIAL <> d2.CD_SEQUENCIAL '
			
			  if @dt_assinatura_ini is not null and @dt_assinatura_fim is not null
			  begin
			     Set @sql = @sql +
		                ' and d1.dt_assinaturacontrato >= '''+convert(varchar(10),@dt_assinatura_ini,101)+''' 
		                  and d1.dt_assinaturacontrato <= '''+convert(varchar(10),@dt_assinatura_fim,101)+''' '
			  End
		      if @cd_plano is not null and @cd_plano <> ''
		      begin
			     Set @sql = @sql +
		                ' and d1.cd_plano in ('+@cd_plano+') '		      
		      end 				  
			     Set @sql = @sql +
		                '      ),0) as vl_fatura  , 
               
    isnull(( 
        select SUM(isnull(t103.valor,0))  -- SUM(isnull(t100.vl_pago,0)) 
          from MENSALIDADES as t100 , mensalidades_planos as t103, dependentes as t102 
         where t100.CD_ASSOCIADO_empresa = a.CD_EMPRESA and 
               t100.TP_ASSOCIADO_EMPRESA in (2,3) and '
             
               if @valorPago = 1 /*Vencimento Pago*/
			   begin
			   Set @sql = @sql +   
					   ' t100.DT_VENCIMENTO >= '''+convert(varchar(10),@dt_ini,101)+''' and 
						 t100.DT_VENCIMENTO <= '''+convert(varchar(10),@dt_fim,101)+''' and 
						 t100.CD_TIPO_RECEBIMENTO > 2 and 
						 t100.DT_PAGAMENTO is not null and '
			   end 
			   
			  if @valorPago = 2 /*Vencimento*/
              begin
               Set @sql = @sql +   
					  ' t100.DT_VENCIMENTO >= '''+convert(varchar(10),@dt_ini,101)+''' and 
						t100.DT_VENCIMENTO <= '''+convert(varchar(10),@dt_fim,101)+''' and 
						t100.cd_tipo_recebimento not in (1,2) and 
						'
              end
              
              if @valorPago = 3 /*Pagamento*/
              begin
               Set @sql = @sql +   
					  ' t100.DT_PAGAMENTO >= '''+convert(varchar(10),@dt_ini,101)+''' and 
						t100.DT_PAGAMENTO <= '''+convert(varchar(10),@dt_fim,101)+''' and 
						t100.CD_TIPO_RECEBIMENTO > 2 and
						t100.DT_PAGAMENTO is not null and '
              end
              
              Set @sql = @sql +'  
               t100.cd_tipo_parcela in (1,2,3) and 
               t100.cd_parcela = t103.cd_parcela_mensalidade and 
               t103.cd_sequencial_dep = t102.cd_sequencial and 
               t103.dt_exclusao is null '
			
			  if @dt_assinatura_ini is not null and @dt_assinatura_fim is not null
			  begin
			     Set @sql = @sql +
		                ' and t102.dt_assinaturacontrato >= '''+convert(varchar(10),@dt_assinatura_ini,101)+''' 
		                  and t102.dt_assinaturacontrato <= '''+convert(varchar(10),@dt_assinatura_fim,101)+''' '
			  End
		      if @cd_plano is not null and @cd_plano <> ''
		      begin
			     Set @sql = @sql +
		                ' and t102.cd_plano in ('+@cd_plano+') '		      
		      end 				  
			     Set @sql = @sql +
		                '      ),0) 
      
      + 
      
      isnull(( 
       -- select SUM(isnull(t100.vl_pago,0)) 
        select SUM(isnull(t103.valor,0)) 
          from MENSALIDADES as t100, ASSOCIADOS as t101, dependentes as t102, mensalidades_planos as t103
         where t100.CD_ASSOCIADO_empresa = t101.cd_associado and 
               t101.cd_empresa = a.CD_EMPRESA and 
               t100.TP_ASSOCIADO_EMPRESA in (1) and ' 
                                           
			   if @valorPago = 1 /*Vencimento Pago*/
			   begin
			   Set @sql = @sql +   
					   ' t100.DT_VENCIMENTO >= '''+convert(varchar(10),@dt_ini,101)+''' and 
						 t100.DT_VENCIMENTO <= '''+convert(varchar(10),@dt_fim,101)+''' and 
						 t100.CD_TIPO_RECEBIMENTO > 2 and 
						 t100.DT_PAGAMENTO is not null and '
			   end 
			   
			  if @valorPago = 2 /*Vencimento*/
              begin
               Set @sql = @sql +   
					  ' t100.DT_VENCIMENTO >= '''+convert(varchar(10),@dt_ini,101)+''' and 
						t100.DT_VENCIMENTO <= '''+convert(varchar(10),@dt_fim,101)+''' and 
						t100.cd_tipo_recebimento not in (1,2) and 
						'
              end
              
              if @valorPago = 3 /*Pagamento*/
              begin
               Set @sql = @sql +   
					  ' t100.DT_PAGAMENTO >= '''+convert(varchar(10),@dt_ini,101)+''' and 
						t100.DT_PAGAMENTO <= '''+convert(varchar(10),@dt_fim,101)+''' and 
						t100.CD_TIPO_RECEBIMENTO > 2 and
						t100.DT_PAGAMENTO is not null and '
              end
              
              Set @sql = @sql +'  
               t100.cd_tipo_parcela in (1,2,3) and 
               t100.cd_parcela = t103.cd_parcela_mensalidade and 
               t103.cd_sequencial_dep = t102.cd_sequencial and 
               t103.dt_exclusao is null '
			
			  if @dt_assinatura_ini is not null and @dt_assinatura_fim is not null
			  begin
			     Set @sql = @sql +
		                ' and t102.dt_assinaturacontrato >= '''+convert(varchar(10),@dt_assinatura_ini,101)+''' 
		                  and t102.dt_assinaturacontrato <= '''+convert(varchar(10),@dt_assinatura_fim,101)+''' '
			  End
		      if @cd_plano is not null and @cd_plano <> ''
		      begin
			     Set @sql = @sql +
		                ' and t102.cd_plano in ('+@cd_plano+') '		      
		      end 				  
			     Set @sql = @sql +
		                '	),0) as vl_pago ,                      
      
     case when ' + convert(varchar(10),@tabela) + '> -1 then           
			 isnull((
				select sum(isnull(T9.vl_servico,0)) as vl_servico
				  from Consultas T1, Servico T2, Filial T3, Funcionario T4, Dependentes T5, Associados T6, Empresa T7, Tabela_Servicos T9 
				   , ( 
							select  t1.cd_sequencial, isnull(T1.dt_pagamento,(select data_pagamento from TB_FormaLancamento where Sequencial_Lancamento = T3.Sequencial_Lancamento)) data_pagamento, isnull(t3.sequencial_lancamento,0) sequencial_lancamento, 
							t3.cd_pgto_dentista_lanc,
							isnull((select Data_Documento from TB_FormaLancamento where Sequencial_Lancamento = T3.Sequencial_Lancamento), T1.dt_previsao_pagamento) DataPrevisaoPagamento 
							, (select dt_conhecimento from pagamento_dentista_lancamento where cd_pgto_dentista_lanc = t1.cd_pgto_dentista_lanc) as conhecimento

							from pagamento_dentista as T1, funcionario as T2, Pagamento_Dentista_Lancamento as T3, FILIAL t4 

							where T1.cd_funcionario = T2.cd_funcionario 
							and T1.cd_pgto_dentista_lanc *= T3.cd_pgto_dentista_lanc 
							and t1.cd_filial = t4.cd_filial
					   ) as x
				 
				 where T1.cd_servico = T2.cd_servico 
				   and T1.cd_filial = T3.cd_filial 
				   and T1.cd_funcionario = T4.cd_funcionario 
				   and T1.cd_sequencial_dep = T5.cd_sequencial 
				   and T5.cd_associado = T6.cd_associado 
				   and T6.cd_empresa = T7.cd_empresa 
				   				   
				   and T9.cd_tabela = ' + convert(varchar(10),@tabela) + '
				   and T1.cd_servico = T9.cd_servico 
				   and T1.dt_cancelamento is null 
				   and T1.status in (3,6,7) 
				   and T1.dt_servico is not null 
				   and T1.cd_servico in (select cd_servico from Plano_Servico where cd_servico = T1.cd_servico and cd_plano = T5.cd_plano) 
				   and t7.CD_EMPRESA = a.CD_EMPRESA   
				   and T9.vl_servico > 0 ' 
				   
				   if @tipoData <> 1
					   begin
							set @sql = @sql + 'and t1.nr_numero_lote = x.cd_sequencial'
					   end
				   else
					   begin
							set @sql = @sql + 'and t1.nr_numero_lote *= x.cd_sequencial'
					   end
				   
				   if @tipoData = 1
				   begin               
           			 Set @sql = @sql +
						' and T1.dt_servico >= '''+convert(varchar(10),@dt_ini,101)+''' 
						  and T1.dt_servico <= '''+convert(varchar(10),@dt_fim,101)+''' '
				   end
				   
				   if @tipoData = 2
				   begin               
           			 Set @sql = @sql +
						' and x.DataPrevisaoPagamento >= '''+convert(varchar(10),@dt_ini,101)+''' 
						  and x.DataPrevisaoPagamento <= '''+convert(varchar(10),@dt_fim,101)+''' '
				   end
				   
				   if @tipoData = 3
				   begin               
           			 Set @sql = @sql +
						' and x.data_pagamento >= '''+convert(varchar(10),@dt_ini,101)+''' 
						  and x.data_pagamento <= '''+convert(varchar(10),@dt_fim,101)+''' '
				   end
				   				   
				   --'and T1.dt_servico >= '''+convert(varchar(10),@dt_ini,101)+'''
				   --and t1.dt_servico <= '''+convert(varchar(10),@dt_fim,101)+'''  '
			
			  if @dt_assinatura_ini is not null and @dt_assinatura_fim is not null
			  begin
			     Set @sql = @sql +
		                ' and t5.dt_assinaturacontrato >= '''+convert(varchar(10),@dt_assinatura_ini,101)+''' 
		                  and t5.dt_assinaturacontrato <= '''+convert(varchar(10),@dt_assinatura_fim,101)+''' '
			  End
		      if @cd_plano is not null and @cd_plano <> ''
		      begin
			     Set @sql = @sql +
		                ' and t5.cd_plano in ('+@cd_plano+') '		      
		      end 				  
			     Set @sql = @sql +
		                '	),0) 
				  
		else
			 isnull((
				select sum(isnull(T1.vl_pago_produtividade,0)) as vl_servico
				  from Consultas T1, Servico T2, Filial T3, Funcionario T4, Dependentes T5, Associados T6, Empresa T7, 
				       PLANO_SERVICO as ps
						, ( 
							select  t1.cd_sequencial, isnull(T1.dt_pagamento,(select data_pagamento from TB_FormaLancamento where Sequencial_Lancamento = T3.Sequencial_Lancamento)) data_pagamento, isnull(t3.sequencial_lancamento,0) sequencial_lancamento, 
							t3.cd_pgto_dentista_lanc,
							isnull((select Data_Documento from TB_FormaLancamento where Sequencial_Lancamento = T3.Sequencial_Lancamento), T1.dt_previsao_pagamento) DataPrevisaoPagamento 
							, (select dt_conhecimento from pagamento_dentista_lancamento where cd_pgto_dentista_lanc = t1.cd_pgto_dentista_lanc) as conhecimento

							from pagamento_dentista as T1, funcionario as T2, Pagamento_Dentista_Lancamento as T3, FILIAL t4 

							where T1.cd_funcionario = T2.cd_funcionario 
							and T1.cd_pgto_dentista_lanc *= T3.cd_pgto_dentista_lanc 
							and t1.cd_filial = t4.cd_filial
					   ) as x
				       
				 where T1.cd_servico = T2.cd_servico 
				   and T1.cd_filial = T3.cd_filial 
				   and T1.cd_funcionario = T4.cd_funcionario 
				   and T1.cd_sequencial_dep = T5.cd_sequencial 
				   and T5.cd_associado = T6.cd_associado 
				   and T6.cd_empresa = T7.cd_empresa 
				   
				   and T1.dt_cancelamento is null 
				   and T1.status in (3,6,7) 
				   and T1.dt_servico is not null 
				   --and T1.cd_servico in (select cd_servico from Plano_Servico where cd_servico = T1.cd_servico and cd_plano = T5.cd_plano) 
				   and T1.cd_servico = ps.cd_servico 
				   and T5.cd_plano = ps.cd_plano 
				   and t7.CD_EMPRESA = a.CD_EMPRESA   
				   and T1.nr_numero_lote is not null '
				   
				   if @tipoData <> 1
					   begin
							set @sql = @sql + 'and t1.nr_numero_lote = x.cd_sequencial'
					   end
				   else
					   begin
							set @sql = @sql + 'and t1.nr_numero_lote *= x.cd_sequencial'
					   end
				   
				   if @tipoData = 1
				   begin               
           			 Set @sql = @sql +
						' and T1.dt_servico >= '''+convert(varchar(10),@dt_ini,101)+''' 
						  and T1.dt_servico <= '''+convert(varchar(10),@dt_fim,101)+''' '
				   end
				   
				   if @tipoData = 2
				   begin               
           			 Set @sql = @sql +
						' and x.DataPrevisaoPagamento >= '''+convert(varchar(10),@dt_ini,101)+''' 
						  and x.DataPrevisaoPagamento <= '''+convert(varchar(10),@dt_fim,101)+''' '
				   end
				   
				   if @tipoData = 3
				   begin               
           			 Set @sql = @sql +
						' and x.data_pagamento >= '''+convert(varchar(10),@dt_ini,101)+''' 
						  and x.data_pagamento <= '''+convert(varchar(10),@dt_fim,101)+''' '
				   end
				   
				   --and T1.dt_servico >= '''+convert(varchar(10),@dt_ini,101)+'''
				   --and t1.dt_servico <= '''+convert(varchar(10),@dt_fim,101)+'''  '
			
			  if @dt_assinatura_ini is not null and @dt_assinatura_fim is not null
			  begin
			     Set @sql = @sql +
		                ' and t5.dt_assinaturacontrato >= '''+convert(varchar(10),@dt_assinatura_ini,101)+''' 
		                  and t5.dt_assinaturacontrato <= '''+convert(varchar(10),@dt_assinatura_fim,101)+''' '
			  End
		      if @cd_plano is not null and @cd_plano <> ''
		      begin
			     Set @sql = @sql +
		                ' and t5.cd_plano in ('+@cd_plano+') '		      
		      end 				  
			     Set @sql = @sql +
		                '	),0)
			 +
			 isnull((
				select sum(isnull(T8.vl_servico,0)) as vl_servico
				  from Consultas T1, Servico T2, Filial T3, Funcionario T4, Dependentes T5, Associados T6, Empresa T7, tabela_servicos T8,
				       PLANO_SERVICO as ps 
				       , ( 
							select  t1.cd_sequencial, isnull(T1.dt_pagamento,(select data_pagamento from TB_FormaLancamento where Sequencial_Lancamento = T3.Sequencial_Lancamento)) data_pagamento, isnull(t3.sequencial_lancamento,0) sequencial_lancamento, 
							t3.cd_pgto_dentista_lanc,
							isnull((select Data_Documento from TB_FormaLancamento where Sequencial_Lancamento = T3.Sequencial_Lancamento), T1.dt_previsao_pagamento) DataPrevisaoPagamento 
							, (select dt_conhecimento from pagamento_dentista_lancamento where cd_pgto_dentista_lanc = t1.cd_pgto_dentista_lanc) as conhecimento

							from pagamento_dentista as T1, funcionario as T2, Pagamento_Dentista_Lancamento as T3, FILIAL t4 

							where T1.cd_funcionario = T2.cd_funcionario 
							and T1.cd_pgto_dentista_lanc *= T3.cd_pgto_dentista_lanc 
							and t1.cd_filial = t4.cd_filial
					   ) as x
				       
				 where T1.cd_servico = T2.cd_servico 
				   and T1.cd_filial = T3.cd_filial 
				   and T1.cd_funcionario = T4.cd_funcionario 
				   and T1.cd_sequencial_dep = T5.cd_sequencial 
				   and T5.cd_associado = T6.cd_associado 
				   and T6.cd_empresa = T7.cd_empresa 
				   and T1.cd_servico = T8.cd_servico
				   and T4.cd_tabela = T8.cd_tabela
				  
				   and T1.dt_cancelamento is null 
				   and T1.status in (3,6,7) 
				   and T1.dt_servico is not null 
				   --and T1.cd_servico in (select cd_servico from Plano_Servico where cd_servico = T1.cd_servico and cd_plano = T5.cd_plano) 
				   and T1.cd_servico = ps.cd_servico 
				   and T5.cd_plano = ps.cd_plano 
				   and t7.CD_EMPRESA = a.CD_EMPRESA   
				   and T1.nr_numero_lote is null '
				   
				    if @tipoData <> 1
					   begin
							set @sql = @sql + 'and t1.nr_numero_lote = x.cd_sequencial'
					   end
				   else
					   begin
							set @sql = @sql + 'and t1.nr_numero_lote *= x.cd_sequencial'
					   end
				   
				   if @tipoData = 1
				   begin               
           			 Set @sql = @sql +
						' and T1.dt_servico >= '''+convert(varchar(10),@dt_ini,101)+''' 
						  and T1.dt_servico <= '''+convert(varchar(10),@dt_fim,101)+''' '
				   end
				   
				   if @tipoData = 2
				   begin               
           			 Set @sql = @sql +
						' and x.DataPrevisaoPagamento >= '''+convert(varchar(10),@dt_ini,101)+''' 
						  and x.DataPrevisaoPagamento <= '''+convert(varchar(10),@dt_fim,101)+''' '
				   end
				   
				   if @tipoData = 3
				   begin               
           			 Set @sql = @sql +
						' and x.data_pagamento >= '''+convert(varchar(10),@dt_ini,101)+''' 
						  and x.data_pagamento <= '''+convert(varchar(10),@dt_fim,101)+''' '
				   end
				   
				   --and T1.dt_servico >= '''+convert(varchar(10),@dt_ini,101)+'''
				   --and t1.dt_servico <= '''+convert(varchar(10),@dt_fim,101)+'''  '
			
			  if @dt_assinatura_ini is not null and @dt_assinatura_fim is not null
			  begin
			     Set @sql = @sql +
		                ' and t5.dt_assinaturacontrato >= '''+convert(varchar(10),@dt_assinatura_ini,101)+''' 
		                  and t5.dt_assinaturacontrato <= '''+convert(varchar(10),@dt_assinatura_fim,101)+''' '
			  End
		      if @cd_plano is not null and @cd_plano <> ''
		      begin
			     Set @sql = @sql +
		                ' and t5.cd_plano in ('+@cd_plano+') '		      
		      end 					  
			     Set @sql = @sql +
		                '	),0)
		end as vl_utilizacao '
      
      Set @sql1 = '        
		, case when '+convert(varchar(10),@tabela)+' > -1 then           
			 isnull((
				select sum(isnull(T9.vl_servico,0)) as vl_servico
				  from Consultas T1, Servico T2, Filial T3, Funcionario T4, Dependentes T5, Associados T6, Empresa T7, Tabela_Servicos T9 , 
				       PLANO_SERVICO as ps
				 where T1.cd_servico = T2.cd_servico 
				   and T1.cd_filial = T3.cd_filial 
				   and T1.cd_funcionario = T4.cd_funcionario 
				   and T1.cd_sequencial_dep = T5.cd_sequencial 
				   and T5.cd_associado = T6.cd_associado 
				   and T6.cd_empresa = T7.cd_empresa 
				   and T9.cd_tabela = '+ convert(varchar(10),@tabela)+' 
				   and T1.cd_servico = T9.cd_servico 
				   and T1.dt_cancelamento is null 
				   and T1.status in (2) 
				   and T1.dt_servico is null 
				   --and T1.cd_servico in (select cd_servico from Plano_Servico where cd_servico = T1.cd_servico and cd_plano = T5.cd_plano) 
				   and T1.cd_servico = ps.cd_servico 
				   and T5.cd_plano = ps.cd_plano
				   and t7.CD_EMPRESA = a.CD_EMPRESA   
				   and T9.vl_servico > 0   '
			
			  if @dt_assinatura_ini is not null and @dt_assinatura_fim is not null
			  begin
			     Set @sql1 = @sql1 +
		                ' and t5.dt_assinaturacontrato >= '''+convert(varchar(10),@dt_assinatura_ini,101)+''' 
		                  and t5.dt_assinaturacontrato <= '''+convert(varchar(10),@dt_assinatura_fim,101)+''' '
			  End
		      if @cd_plano is not null and @cd_plano <> ''
		      begin
			     Set @sql1 = @sql1 +
		                ' and t5.cd_plano in ('+@cd_plano+') '		      
		      end 					  
			     Set @sql1 = @sql1 +
		                '	),0) 
		else
			 isnull((
				select sum(isnull(T1.vl_pago_produtividade,0)) as vl_servico
				  from Consultas T1, Servico T2, Filial T3, Funcionario T4, Dependentes T5, Associados T6, Empresa T7, 
				       PLANO_SERVICO as ps
				 where T1.cd_servico = T2.cd_servico 
				   and T1.cd_filial = T3.cd_filial 
				   and T1.cd_funcionario = T4.cd_funcionario 
				   and T1.cd_sequencial_dep = T5.cd_sequencial 
				   and T5.cd_associado = T6.cd_associado 
				   and T6.cd_empresa = T7.cd_empresa 
				   and T1.dt_cancelamento is null 
				   and T1.status in (2) 
				   and T1.dt_servico is null 
				   --and T1.cd_servico in (select cd_servico from Plano_Servico where cd_servico = T1.cd_servico and cd_plano = T5.cd_plano) 
				   and T1.cd_servico = ps.cd_servico 
				   and T5.cd_plano = ps.cd_plano
				   and t7.CD_EMPRESA = a.CD_EMPRESA   
				   and T1.nr_numero_lote is not null  '
			
			  if @dt_assinatura_ini is not null and @dt_assinatura_fim is not null
			  begin
			     Set @sql1 = @sql1 +
		                ' and t5.dt_assinaturacontrato >= '''+convert(varchar(10),@dt_assinatura_ini,101)+''' 
		                  and t5.dt_assinaturacontrato <= '''+convert(varchar(10),@dt_assinatura_fim,101)+''' '
			  End
		      if @cd_plano is not null and @cd_plano <> ''
		      begin
			     Set @sql1 = @sql1 +
		                ' and t5.cd_plano in ('+@cd_plano+') '		      
		      end 		
		      			  
			     Set @sql1 = @sql1 +
		                '			  ),0)
			 +
			 isnull((
				select sum(isnull(T8.vl_servico,0)) as vl_servico
				  from Consultas T1, Servico T2, Filial T3, Funcionario T4, Dependentes T5, Associados T6, Empresa T7, tabela_servicos T8, 
				       PLANO_SERVICO as ps
				 where T1.cd_servico = T2.cd_servico 
				   and T1.cd_filial = T3.cd_filial 
				   and T1.cd_funcionario = T4.cd_funcionario 
				   and T1.cd_sequencial_dep = T5.cd_sequencial 
				   and T5.cd_associado = T6.cd_associado 
				   and T6.cd_empresa = T7.cd_empresa 
				   and T1.cd_servico = T8.cd_servico
				   and T4.cd_tabela = T8.cd_tabela
				   and T1.dt_cancelamento is null 
				   and T1.status in (2) 
				   and T1.dt_servico is null 
				   --and T1.cd_servico in (select cd_servico from Plano_Servico where cd_servico = T1.cd_servico and cd_plano = T5.cd_plano) 
				   and T1.cd_servico = ps.cd_servico 
				   and T5.cd_plano = ps.cd_plano
				   and t7.CD_EMPRESA = a.CD_EMPRESA   
				   and T1.nr_numero_lote is null '
			
			  if @dt_assinatura_ini is not null and @dt_assinatura_fim is not null
			  begin
			     Set @sql1 = @sql1 +
		                ' and t5.dt_assinaturacontrato >= '''+convert(varchar(10),@dt_assinatura_ini,101)+''' 
		                  and t5.dt_assinaturacontrato <= '''+convert(varchar(10),@dt_assinatura_fim,101)+''' '
			  End
		      if @cd_plano is not null and @cd_plano <> ''
		      begin
			     Set @sql1 = @sql1 +
		                ' and t5.cd_plano in ('+@cd_plano+') '		      
		      end 		   
		      
		      Set @sql1 = @sql1 +
		      '  		   ),0)
				  
		end as vl_pendente
		
 from empresa as a, tipo_pagamento as tp , MUNICIPIO as m , tipo_empresa as e , HISTORICO as h, SITUACAO_HISTORICO as sh
where a.cd_tipo_pagamento = tp.cd_tipo_pagamento and 
      a.cd_municipio = m.CD_MUNICIPIO  and
      a.TP_EMPRESA=e.tp_empresa and 
      a.CD_Sequencial_historico=h.cd_sequencial and 
      h.CD_SITUACAO= sh.CD_SITUACAO_HISTORICO and 
      sh.CD_SITUACAO_HISTORICO not in (2) and  
      a.TP_EMPRESA<10'
      
  if  @cd_centro_custo > 0   
      Set @sql1 = @sql1 + ' and  a.cd_centro_Custo = '+convert(varchar(10),@cd_centro_custo)
      
  if @mes > 0 
      Set @sql1 = @sql1 + ' and  substring(convert(varchar(6),a.mm_aaaa_1pagamento_empresa),5,2) = ' +convert(varchar(10),@mes)
   
  if  @cd_empresa > 0    
      Set @sql1 = @sql1 + ' and  a.cd_empresa in (' + convert(varchar(10),@cd_empresa) + ')'	

  if  isnull(@tipoPagamento,0) > 0    
      Set @sql1 = @sql1 + ' and  a.cd_tipo_pagamento  =' + convert(varchar(10),@tipoPagamento) + ' ' 
      
  if  isnull(@tipoEmpresa,0) > 0    
      Set @sql1 = @sql1 + ' and  a.TP_EMPRESA  =' + convert(varchar(10),@tipoEmpresa) + ' '      	  
	  
  if  @cd_grupo_empresa > 0    
      Set @sql1 = @sql1 + ' and  a.cd_grupo = ' +convert(varchar(10),@cd_grupo_empresa)
      
        if  @grupoAnalise > 0    
  	  Set @sql1 = @sql1 + ' and  a.cd_empresa in (select cd_empresa from GrupoAnalise_Empresa where cd_grupoanalise in (' + convert(varchar,@grupoAnalise) + ') ) '

  if  @depid > 0    
  	  Set @sql1 = @sql1 + ' and  a.cd_empresa in (select cd_empresa from Departamento_Empresa where depid in (' + convert(varchar,@depid) + ') ) '

  Set @sql1 = @sql1 + ' order by 2,3 '
      
  --    a.cd_centro_Custo < case when @cd_centro_custo>0 then @cd_centro_custo+1 else 9999 end  and 
  --    substring(convert(varchar(6),a.mm_aaaa_1pagamento_empresa),5,2) >= @mes 
  --    substring(convert(varchar(6),a.mm_aaaa_1pagamento_empresa),5,2) < case when @mes>0 then @mes+1 else 99 end and 
  --    a.cd_empresa <= case when @cd_empresa>0 then @cd_empresa else 9999999 end        
  
--Print string muito grande
DECLARE @String NVARCHAR(MAX);
DECLARE @CurrentEnd BIGINT; ---track the length of the next substring
DECLARE @offset tinyint; ---tracks the amount of offset needed
set @string = replace(  replace(@sql + @sql1, char(13) + char(10), char(10))   , char(13), char(10))

WHILE LEN(@String) > 1
BEGIN
    IF CHARINDEX(CHAR(10), @String) between 1 AND 4000
    BEGIN
           SET @CurrentEnd =  CHARINDEX(char(10), @String) -1
           set @offset = 2
    END
    ELSE
    BEGIN
           SET @CurrentEnd = 4000
            set @offset = 1
    END   
    PRINT SUBSTRING(@String, 1, @CurrentEnd) 
    set @string = SUBSTRING(@String, @CurrentEnd+@offset, LEN(@String))   
END ---End While loop
  
  exec (@sql + @sql1)
  
End 
