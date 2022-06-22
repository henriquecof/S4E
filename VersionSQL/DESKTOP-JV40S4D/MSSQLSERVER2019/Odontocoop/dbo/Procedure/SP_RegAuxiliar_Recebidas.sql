/****** Object:  Procedure [dbo].[SP_RegAuxiliar_Recebidas]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE Procedure [dbo].[SP_RegAuxiliar_Recebidas] (@mes varchar(2), @ano varchar(4), @tp_associado smallint = 0,@centro_custo int=0, @cd_grupo int=0, @dataInicial date = null, @dataFinal date = null)
as 
Begin 

-- REGISTRO DE CONTRAPRESTAÇÕES RECEBIDAS – II

Declare @dt_i date --= '08/01/2013' 
Declare @dt_f date --= '09/01/2013' 
Declare @SQL varchar(max)
Declare @SQL1 varchar(max)
Declare @SQL2 varchar(max)
--Declare @QtMesesBaixaTituloAns tinyint 

	Begin
	if ISNULL(@dataInicial,'') <> '' and ISNULL(@dataFinal,'') <> ''
		Begin
			Set @dt_i = convert(date,@dataInicial)
			Set @dt_f = convert(date,DATEADD(DAY,1,@dataFinal))
		End
	Else
		Begin
			Set @dt_i = convert(date,@mes + '/01/' + @ano )
			Set @dt_f = DATEADD(month,1,@dt_i)
		End   
	End

	 -- Recebidas 
	 Set @SQL = '' 
	 Set @SQL1 = '' 
	 Set @SQL2 = '' 

	 if @tp_associado in (0,1)
	 Begin
		Set @SQL = @SQL + 'SELECT 
				case when e.tp_empresa=8 then ''CADE'' else ''PF'' end as tipo, -- Alterado
				m.CD_ASSOCIADO_empresa as codigo, a.nm_completo as nome,
				isnull(a.nr_cpf,'''') as nr_CPF_CGC,
				m.cd_parcela as Documento,  
				convert(varchar(10),m.DT_VENCIMENTO,103) as dt_venc,
				convert(varchar(10),m.DT_PAGAMENTO,103) as dt_pgto,
				m.vl_parcela + isnull(m.vl_acrescimo,0) - isnull(m.vl_desconto,0)-ISNULL(m.vl_imposto,0) as vl_debito,
				isnull(m.vl_taxa,0) as taxa,
				isnull(m.vl_multa,0) as multa,
				isnull(m.vl_desconto_recebimento,0) as desconto,
				isnull(m.vl_acrescimoavulso,0) as outras_taxas,
				m.VL_PAGO ,
				case when convert(varchar(6),isnull(m.dt_credito,m.DT_PAGAMENTO),112) < convert(varchar(6),case when regAuxRec_Competencia = 1 then m.dt_vencimento else m.dt_emissao end,112) then m.VL_PAGO else 0 end as vl_pg_futuro,
				case when convert(varchar(10),isnull(m.dt_credito,m.DT_PAGAMENTO),101) > dbo.UltimaDataMes(case when regAuxRec_Competencia = 1 then m.dt_vencimento else m.dt_emissao end,0) then m.VL_PAGO else 0 end as vl_pg_passado ,
				t.nm_tipo_pagamento as tipo_pagamento,
				case when m.dt_cancelado_contabil is null then '''' else ''S'' end as Recuperado,
				m.lnfid as Lote, nf.lnfProtocolo as Protocolo, p.ds_tipo_parcela as Parcela, 
				m.DT_PAGAMENTO, 
				convert(varchar(10),m.dt_emissao, 103) as dt_gerado,
				e.nm_fantasia,
				convert(varchar(10),m.dt_inicio_cobertura, 103) as dt_inicio_cobertura,
				convert(varchar(10),m.dt_credito, 103) as dt_credito,
				isNULL(dp.depDescricao, '''') as depDescricao, ce.ds_centro_custo, ge.nm_grupo
				, ce2.ds_centro_custo as ds_centro_custo_aux -- incluido
		   FROM MENSALIDADES as m inner join ASSOCIADOS as a on m.CD_ASSOCIADO_empresa = a.cd_associado and m.tp_associado_empresa = 1 
		           inner join empresa as e on a.cd_empresa = e.cd_empresa and e.tp_empresa < 10
		           inner join TIPO_PAGAMENTO as t on m.CD_TIPO_RECEBIMENTO = t.cd_tipo_pagamento 
		           inner join tipo_parcela as p on m.cd_tipo_parcela = p.cd_tipo_parcela
		            left join lote_Nfe as nf on m.lnfid = nf.lnfid
		            left join Departamento dp on dp.depId = a.depID
		            inner join configuracao on 1=1
		            left join centro_custo as ce on e.cd_centro_custo = ce.cd_centro_custo
					left join grupo as ge on e.cd_grupo = ge.cd_grupo
					left join centro_custo as ce2 on e.cd_centro_custo_aux = ce2.cd_centro_custo -- incluido
		  WHERE isnull(m.dt_credito,m.DT_PAGAMENTO) >= '''+convert(varchar(10),@dt_i,101) + ''' and isnull(m.dt_credito,m.DT_PAGAMENTO) < '''+convert(varchar(10),@dt_f,101)+''' 
			and m.CD_TIPO_RECEBIMENTO > 2 
			and m.dt_emissao is not null '
		 if @centro_custo > 0 
		    Set @SQL = @SQL + ' and e.cd_centro_custo = ' + CONVERT(varchar(10),@centro_custo) 
		 
		 if @cd_grupo > 0 
		    Set @SQL = @SQL + ' and e.cd_grupo = ' + CONVERT(varchar(10),@cd_grupo) 

		 Set @SQL = @SQL + ' and e.cd_empresa not in (select cd_Associado_empresa from exclusao_registrosauxiliares_empAssoc where tp_associado_empresa=2	) 
		                     and a.cd_associado not in (select cd_Associado_empresa from exclusao_registrosauxiliares_empAssoc where tp_associado_empresa=1	) 
		                     and m.cd_tipo_parcela not in (select cd_tipo_parcela from tipo_parcela where fl_excluir_regaux=1 ) 
		                     and m.cd_parcela not in (select cd_parcela from exclusao_regaux_parcelas) '	
		                     
	 End	 
	 
	 if @tp_associado in (0)
	 Begin
		 Set @SQL = @SQL + ' 
		    union 
		    '
	 End 

	 if @tp_associado in (0,2)
	 Begin	 
		 Set @SQL = @SQL + 'SELECT 
					case when e.tp_empresa=2 then ''PJ'' else ''CADE'' end  as tipo, -- Alterado
					m.CD_ASSOCIADO_empresa as codigo, e.NM_RAZSOC as nome, 
					isnull(e.nr_cgc,'''') as nr_CPF_CGC,
					m.cd_parcela as Documento,  
					convert(varchar(10),m.DT_VENCIMENTO,103) as dt_venc,
					convert(varchar(10),m.DT_PAGAMENTO,103) as dt_pgto,
					m.vl_parcela + isnull(m.vl_acrescimo,0) - isnull(m.vl_desconto,0)-ISNULL(m.vl_imposto,0) as vl_debito,
					isnull(m.vl_taxa,0) as taxa,
					isnull(m.vl_multa,0) as multa,
					isnull(m.vl_desconto_recebimento,0) as desconto,
					isnull(m.vl_acrescimoavulso,0) as outras_taxas,
					m.VL_PAGO ,
					case when convert(varchar(6),isnull(m.dt_credito,m.DT_PAGAMENTO),112) < convert(varchar(6),case when regAuxRec_Competencia = 1 then m.dt_vencimento else m.dt_emissao end,112) then m.VL_PAGO else 0 end as vl_pg_futuro ,
					case when convert(varchar(10),isnull(m.dt_credito,m.DT_PAGAMENTO),101) > dbo.UltimaDataMes(case when regAuxRec_Competencia = 1 then m.dt_vencimento else m.dt_emissao end,0) then m.VL_PAGO else 0 end as vl_pg_passado,
					t.nm_tipo_pagamento as tipo_pagamento,
					case when m.dt_cancelado_contabil is null then '''' else ''S'' end as Recuperado,
				    m.lnfid as Lote, nf.lnfProtocolo as Protocolo, p.ds_tipo_parcela as Parcela, 				
					m.DT_PAGAMENTO, 
					convert(varchar(10),m.dt_emissao, 103) as dt_gerado, 
					e.nm_fantasia,
				    convert(varchar(10),m.dt_inicio_cobertura, 103) as dt_inicio_cobertura,
				    convert(varchar(10),m.dt_credito, 103) as dt_credito,
					'''' depDescricao, ce.ds_centro_custo, ge.nm_grupo
					, ce2.ds_centro_custo as ds_centro_custo_aux -- incluido
			   FROM MENSALIDADES as m inner join EMPRESA as e on m.CD_ASSOCIADO_empresa = e.cd_empresa and m.tp_associado_empresa in (2,3) and e.tp_empresa < 10
			           inner join TIPO_PAGAMENTO as t on m.CD_TIPO_RECEBIMENTO = t.cd_tipo_pagamento 
			           inner join tipo_parcela as p on m.cd_tipo_parcela = p.cd_tipo_parcela
			   		    left join lote_Nfe as nf on m.lnfid = nf.lnfid
			   		    inner join configuracao on 1=1
			   		    left join centro_custo as ce on e.cd_centro_custo = ce.cd_centro_custo
						left join grupo as ge on e.cd_grupo = ge.cd_grupo  
						left join centro_custo as ce2 on e.cd_centro_custo_aux = ce2.cd_centro_custo -- incluido
			  WHERE isnull(m.dt_credito,m.DT_PAGAMENTO) >= '''+convert(varchar(10),@dt_i,101)+''' and isnull(m.dt_credito,m.DT_PAGAMENTO) < '''+convert(varchar(10),@dt_f,101)+'''
				and m.CD_TIPO_RECEBIMENTO > 2
				and m.dt_emissao is not null  '
				
		 if @centro_custo > 0 
		    Set @SQL = @SQL + ' and e.cd_centro_custo = ' + CONVERT(varchar(10),@centro_custo) 	
			
		 if @cd_grupo > 0 
		    Set @SQL = @SQL + ' and e.cd_grupo = ' + CONVERT(varchar(10),@cd_grupo) 	

		 Set @SQL = @SQL + ' and e.cd_empresa not in (select cd_Associado_empresa from exclusao_registrosauxiliares_empAssoc where tp_associado_empresa=2	) 
		                     and m.cd_tipo_parcela not in (select cd_tipo_parcela from tipo_parcela where fl_excluir_regaux=1 )
		                     and m.cd_parcela not in (select cd_parcela from exclusao_regaux_parcelas) '			    

     End      

	 Set @SQL1 = @SQL1 + ' union  '

	 if @tp_associado in (0,1)
	 Begin
		Set @SQL1 = @SQL1 + 'SELECT 
				case when e.tp_empresa=8 then ''CADE'' else ''PF'' end as tipo, 
				m.CD_ASSOCIADO_empresa as codigo, a.nm_completo as nome,
				isnull(a.nr_cpf,'''') as nr_CPF_CGC,
				m.cd_parcela as Documento,  
				convert(varchar(10),m.dt_vencimento,103) as dt_venc,
				convert(varchar(10),me.DT_estorno,103) as dt_pgto,
				(m.VL_PAGO)*-1 as vl_debito,
				isnull(m.vl_taxa,0) as taxa,
				isnull(m.vl_multa,0) as multa,
				isnull(m.vl_desconto_recebimento,0) as desconto,
				isnull(m.vl_acrescimoavulso,0) as outras_taxas,
				(m.VL_PAGO)*-1 as vl_pago ,
				0 as vl_pg_futuro,
				0 as vl_pg_passado ,
				t.nm_tipo_pagamento as tipo_pagamento,
				case when m.dt_cancelado_contabil is null then '''' else ''S'' end as Recuperado,
				m.lnfid as Lote, nf.lnfProtocolo as Protocolo, 
				''Estorno'' as Parcela, 
				me.DT_estorno, 
				convert(varchar(10),m.dt_emissao, 103) as dt_gerado,
				e.nm_fantasia,
				convert(varchar(10),m.dt_inicio_cobertura, 103) as dt_inicio_cobertura,
				convert(varchar(10),me.DT_estorno, 103) as dt_credito,
				isNULL(dp.depDescricao, '''') as depDescricao, ce.ds_centro_custo, ge.nm_grupo
				,ce2.ds_centro_custo as ds_centro_custo_aux
		   FROM MENSALIDADES as m inner join ASSOCIADOS as a on m.CD_ASSOCIADO_empresa = a.cd_associado and m.tp_associado_empresa = 1 
		           inner join Mensalidade_Estorno as me on m.cd_parcela = me.cd_parcela 
		           inner join empresa as e on a.cd_empresa = e.cd_empresa and e.tp_empresa < 10
		           inner join TIPO_PAGAMENTO as t on m.CD_TIPO_RECEBIMENTO = t.cd_tipo_pagamento 
		           inner join tipo_parcela as p on m.cd_tipo_parcela = p.cd_tipo_parcela
		            left join lote_Nfe as nf on m.lnfid = nf.lnfid
		            left join Departamento dp on dp.depId = a.depID
		            inner join configuracao on 1=1
		            left join centro_custo as ce on e.cd_centro_custo = ce.cd_centro_custo
					left join grupo as ge on e.cd_grupo = ge.cd_grupo
					left join centro_custo as ce2 on e.cd_centro_custo_aux = ce2.cd_centro_custo  
		  WHERE me.DT_estorno >= '''+convert(varchar(10),@dt_i,101) + ''' and me.DT_estorno < '''+convert(varchar(10),@dt_f,101)+''' 
			and m.CD_TIPO_RECEBIMENTO > 2 
			and m.dt_emissao is not null '
		 if @centro_custo > 0 
		    Set @SQL1 = @SQL1 + ' and e.cd_centro_custo = ' + CONVERT(varchar(10),@centro_custo) 
		 
		 if @cd_grupo > 0 
		    Set @SQL1 = @SQL1 + ' and e.cd_grupo = ' + CONVERT(varchar(10),@cd_grupo) 

		 Set @SQL1 = @SQL1 + ' and e.cd_empresa not in (select cd_Associado_empresa from exclusao_registrosauxiliares_empAssoc where tp_associado_empresa=2	) 
		                       and a.cd_associado not in (select cd_Associado_empresa from exclusao_registrosauxiliares_empAssoc where tp_associado_empresa=1	) 
		                       and m.cd_tipo_parcela not in (select cd_tipo_parcela from tipo_parcela where fl_excluir_regaux=1 ) 
		                       and m.cd_parcela not in (select cd_parcela from exclusao_regaux_parcelas) '	
		                     
	 End	 
	 
	 if @tp_associado in (0)
	 Begin
		 Set @SQL1 = @SQL1 + ' 
		    union 
		    '
	 End 


	 if @tp_associado in (0,2)
	 Begin	 
		 Set @SQL1 = @SQL1 + 'SELECT 
					case when e.tp_empresa=8 then ''CADE'' else ''PJ'' end as tipo, 
					m.CD_ASSOCIADO_empresa as codigo, e.NM_RAZSOC as nome, 
					isnull(e.nr_cgc,'''') as nr_CPF_CGC,
					m.cd_parcela as Documento,  
					convert(varchar(10),m.DT_VENCIMENTO,103) as dt_venc,
					convert(varchar(10),me.DT_estorno,103) as dt_pgto,
					(m.VL_PAGO)*-1 as vl_debito,
					isnull(m.vl_taxa,0) as taxa,
					isnull(m.vl_multa,0) as multa,
					isnull(m.vl_desconto_recebimento,0) as desconto,
					isnull(m.vl_acrescimoavulso,0) as outras_taxas,
					m.VL_PAGO*-1 as VL_PAGO,
					0 as vl_pg_futuro ,
					0 as vl_pg_passado,
					t.nm_tipo_pagamento as tipo_pagamento,
					case when m.dt_cancelado_contabil is null then '''' else ''S'' end as Recuperado,
				    m.lnfid as Lote, nf.lnfProtocolo as Protocolo, 
					''Estorno'' as Parcela, 				
					me.DT_estorno, 
					convert(varchar(10),m.dt_emissao, 103) as dt_gerado, 
					e.nm_fantasia,
				    convert(varchar(10),m.dt_inicio_cobertura, 103) as dt_inicio_cobertura,
				    convert(varchar(10),me.DT_estorno, 103) as dt_credito,
					'''' depDescricao, ce.ds_centro_custo, ge.nm_grupo					
					,ce2.ds_centro_custo as ds_centro_custo_aux
			   FROM MENSALIDADES as m inner join EMPRESA as e on m.CD_ASSOCIADO_empresa = e.cd_empresa and m.tp_associado_empresa in (2,3) and e.tp_empresa < 10
			           inner join Mensalidade_Estorno as me on m.cd_parcela = me.cd_parcela 
			           inner join TIPO_PAGAMENTO as t on m.CD_TIPO_RECEBIMENTO = t.cd_tipo_pagamento 
			           inner join tipo_parcela as p on m.cd_tipo_parcela = p.cd_tipo_parcela
			   		    left join lote_Nfe as nf on m.lnfid = nf.lnfid
			   		    inner join configuracao on 1=1
			   		    left join centro_custo as ce on e.cd_centro_custo = ce.cd_centro_custo
						left join grupo as ge on e.cd_grupo = ge.cd_grupo
						left join centro_custo as ce2 on e.cd_centro_custo_aux = ce2.cd_centro_custo  
			  WHERE me.DT_estorno >= '''+convert(varchar(10),@dt_i,101)+''' and DT_estorno < '''+convert(varchar(10),@dt_f,101)+'''
				and m.CD_TIPO_RECEBIMENTO > 2
				and m.dt_emissao is not null  '
				
		 if @centro_custo > 0 
		    Set @SQL1 = @SQL1 + ' and e.cd_centro_custo = ' + CONVERT(varchar(10),@centro_custo) 	
			
		 if @cd_grupo > 0 
		    Set @SQL1 = @SQL1 + ' and e.cd_grupo = ' + CONVERT(varchar(10),@cd_grupo) 	

		 Set @SQL1 = @SQL1 + ' and e.cd_empresa not in (select cd_Associado_empresa from exclusao_registrosauxiliares_empAssoc where tp_associado_empresa=2	) 
		                       and m.cd_tipo_parcela not in (select cd_tipo_parcela from tipo_parcela where fl_excluir_regaux=1 )
		                       and m.cd_parcela not in (select cd_parcela from exclusao_regaux_parcelas) '			    

     End      

	 Set @SQL2= @SQL2 + ' union  '

	 if @tp_associado in (0,1)
	 Begin
		Set @SQL2 = @SQL2 + 'SELECT 
				case when e.tp_empresa=8 then ''CADE'' else ''PF'' end as tipo,
				m.CD_ASSOCIADO_empresa as codigo, a.nm_completo as nome,
				isnull(a.nr_cpf,'''') as nr_CPF_CGC,
				m.cd_parcela as Documento,  
				convert(varchar(10),m.dt_vencimento,103) as dt_venc,
				convert(varchar(10),me.DT_recuperacao_estorno,103) as dt_pgto,
				(m.VL_PAGO) as vl_debito,
				isnull(m.vl_taxa,0) as taxa,
				isnull(m.vl_multa,0) as multa,
				isnull(m.vl_desconto_recebimento,0) as desconto,
				isnull(m.vl_acrescimoavulso,0) as outras_taxas,
				(m.VL_PAGO) as vl_pago ,
				0 as vl_pg_futuro,
				0 as vl_pg_passado ,
				t.nm_tipo_pagamento as tipo_pagamento,
				case when m.dt_cancelado_contabil is null then '''' else ''S'' end as Recuperado,
				m.lnfid as Lote, nf.lnfProtocolo as Protocolo, 
				''Reapresentação'' as Parcela, 
				me.DT_recuperacao_estorno, 
				convert(varchar(10),m.dt_emissao, 103) as dt_gerado,
				e.nm_fantasia,
				convert(varchar(10),m.dt_inicio_cobertura, 103) as dt_inicio_cobertura,
				convert(varchar(10),me.DT_recuperacao_estorno, 103) as dt_credito,
				isNULL(dp.depDescricao, '''') as depDescricao, ce.ds_centro_custo, ge.nm_grupo
				,ce2.ds_centro_custo as ds_centro_custo_aux
		   FROM MENSALIDADES as m inner join ASSOCIADOS as a on m.CD_ASSOCIADO_empresa = a.cd_associado and m.tp_associado_empresa = 1 
		           inner join Mensalidade_Estorno as me on m.cd_parcela = me.cd_parcela 
		           inner join empresa as e on a.cd_empresa = e.cd_empresa and e.tp_empresa < 10
		           inner join TIPO_PAGAMENTO as t on m.CD_TIPO_RECEBIMENTO = t.cd_tipo_pagamento 
		           inner join tipo_parcela as p on m.cd_tipo_parcela = p.cd_tipo_parcela
		            left join lote_Nfe as nf on m.lnfid = nf.lnfid
		            left join Departamento dp on dp.depId = a.depID
		            inner join configuracao on 1=1
		            left join centro_custo as ce on e.cd_centro_custo = ce.cd_centro_custo
					left join grupo as ge on e.cd_grupo = ge.cd_grupo  
					left join centro_custo as ce2 on e.cd_centro_custo_aux = ce2.cd_centro_custo
		  WHERE me.DT_recuperacao_estorno >= '''+convert(varchar(10),@dt_i,101) + ''' and me.DT_recuperacao_estorno < '''+convert(varchar(10),@dt_f,101)+''' 
			and m.CD_TIPO_RECEBIMENTO > 2 
			and m.dt_emissao is not null '
		 if @centro_custo > 0 
		    Set @SQL2 = @SQL2 + ' and e.cd_centro_custo = ' + CONVERT(varchar(10),@centro_custo) 
		 
		 if @cd_grupo > 0 
		    Set @SQL2 = @SQL2 + ' and e.cd_grupo = ' + CONVERT(varchar(10),@cd_grupo) 

		 Set @SQL2 = @SQL2 + ' and e.cd_empresa not in (select cd_Associado_empresa from exclusao_registrosauxiliares_empAssoc where tp_associado_empresa=2	) 
		                       and a.cd_associado not in (select cd_Associado_empresa from exclusao_registrosauxiliares_empAssoc where tp_associado_empresa=1	) 
		                       and m.cd_tipo_parcela not in (select cd_tipo_parcela from tipo_parcela where fl_excluir_regaux=1 ) 
		                       and m.cd_parcela not in (select cd_parcela from exclusao_regaux_parcelas) '	
		                     
	 End	 
	 
	 if @tp_associado in (0)
	 Begin
		 Set @SQL2 = @SQL2 + ' 
		    union 
		    '
	 End 


	 if @tp_associado in (0,2)
	 Begin	 
		 Set @SQL2 = @SQL2 + 'SELECT 
					case when e.tp_empresa=8 then ''CADE'' else ''PJ'' end as tipo, 
					m.CD_ASSOCIADO_empresa as codigo, e.NM_RAZSOC as nome, 
					isnull(e.nr_cgc,'''') as nr_CPF_CGC,
					m.cd_parcela as Documento,  
					convert(varchar(10),m.DT_VENCIMENTO,103) as dt_venc,
					convert(varchar(10),me.DT_recuperacao_estorno,103) as dt_pgto,
					(m.VL_PAGO) as vl_debito,
					isnull(m.vl_taxa,0) as taxa,
					isnull(m.vl_multa,0) as multa,
					isnull(m.vl_desconto_recebimento,0) as desconto,
					isnull(m.vl_acrescimoavulso,0) as outras_taxas,
					m.VL_PAGO as VL_PAGO,
					0 as vl_pg_futuro ,
					0 as vl_pg_passado,
					t.nm_tipo_pagamento as tipo_pagamento,
					case when m.dt_cancelado_contabil is null then '''' else ''S'' end as Recuperado,
				    m.lnfid as Lote, nf.lnfProtocolo as Protocolo, 
					''Reapresentação'' as Parcela, 				
					me.DT_recuperacao_estorno, 
					convert(varchar(10),m.dt_emissao, 103) as dt_gerado, 
					e.nm_fantasia,
				    convert(varchar(10),m.dt_inicio_cobertura, 103) as dt_inicio_cobertura,
				    convert(varchar(10),me.DT_recuperacao_estorno, 103) as dt_credito,
					'''' depDescricao, ce.ds_centro_custo, ge.nm_grupo
					,ce2.ds_centro_custo as ds_centro_custo_aux
			   FROM MENSALIDADES as m inner join EMPRESA as e on m.CD_ASSOCIADO_empresa = e.cd_empresa and m.tp_associado_empresa in (2,3) and e.tp_empresa < 10
			           inner join Mensalidade_Estorno as me on m.cd_parcela = me.cd_parcela 
			           inner join TIPO_PAGAMENTO as t on m.CD_TIPO_RECEBIMENTO = t.cd_tipo_pagamento 
			           inner join tipo_parcela as p on m.cd_tipo_parcela = p.cd_tipo_parcela
			   		    left join lote_Nfe as nf on m.lnfid = nf.lnfid
			   		    inner join configuracao on 1=1
			   		    left join centro_custo as ce on e.cd_centro_custo = ce.cd_centro_custo
						left join grupo as ge on e.cd_grupo = ge.cd_grupo 
						left join centro_custo as ce2 on e.cd_centro_custo_aux = ce2.cd_centro_custo 
			  WHERE me.DT_recuperacao_estorno >= '''+convert(varchar(10),@dt_i,101)+''' and DT_recuperacao_estorno < '''+convert(varchar(10),@dt_f,101)+'''
				and m.CD_TIPO_RECEBIMENTO > 2
				and m.dt_emissao is not null  '
				
		 if @centro_custo > 0 
		    Set @SQL2 = @SQL2 + ' and e.cd_centro_custo = ' + CONVERT(varchar(10),@centro_custo) 	
			
		 if @cd_grupo > 0 
		    Set @SQL2 = @SQL2 + ' and e.cd_grupo = ' + CONVERT(varchar(10),@cd_grupo) 	

		 Set @SQL2 = @SQL2 + ' and e.cd_empresa not in (select cd_Associado_empresa from exclusao_registrosauxiliares_empAssoc where tp_associado_empresa=2	) 
		                       and m.cd_tipo_parcela not in (select cd_tipo_parcela from tipo_parcela where fl_excluir_regaux=1 )
		                       and m.cd_parcela not in (select cd_parcela from exclusao_regaux_parcelas) '			    

     End        
	    
     Set @SQL2 = @SQL2 + ' ORDER BY m.DT_PAGAMENTO, 2'
    
    print @SQL 
	print @SQL1
	print @SQL2
    exec (@SQL + ' ' + @SQL1 + ' ' + @SQL2)
 
 End 
