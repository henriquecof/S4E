/****** Object:  Procedure [dbo].[SP_RegAuxiliar_Atrasadas]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE Procedure [dbo].[SP_RegAuxiliar_Atrasadas] (@mes varchar(2), @ano varchar(4), @tp_associado smallint = 0,@centro_custo int=0, @grupo int = 0 , @dt_inicial date = null, @dt_final date = null)
as 
Begin 

-- REGISTRO DE CONTRAPRESTAÇÕES Atrasadas – II

Declare @SQL varchar(max)
Declare @dt_i date --= '08/01/2013' 
Declare @dt_f date --= '09/01/2013' 
declare @dt_fmenos1 date 
Declare @licenca varchar(100) 

select @licenca = licencas4e from configuracao 

if @ano > 0
Begin
	Set @dt_i = convert(date,@mes + '/01/' + @ano )
	Set @dt_f = DATEADD(month,1,@dt_i)
End
else 
Begin
	Set @dt_i = @dt_inicial
	Set @dt_f = DATEADD(day,1,@dt_final)
End

set @dt_fmenos1=dateadd(day,-1,@dt_f)

	 Set @SQL = '' 
	 if @tp_associado in (0,1)
	 Begin
		Set @SQL = @SQL + 'SELECT  
				case when te.tp_empresa = 8 then ''CADE'' else ''PF'' end as tipo, 
				m.DT_VENCIMENTO  as DT_VENCIMENTO, 
				m.CD_ASSOCIADO_empresa as codigo, a.nm_completo as nome, 
				isnull(a.nr_cpf,'''') nr_CPF_CGC,
				m.cd_parcela as Documento,  
				convert(varchar(10),m.DT_VENCIMENTO,103) as dt_venc,
				convert(varchar(10), m.dt_emissao,103) as dt_emissao,
			    datediff(day,m.DT_VENCIMENTO,'''+convert(varchar(10),@dt_fmenos1,101)+''') as dias_atraso,				
				m.vl_parcela + isnull(m.vl_acrescimo,0) - isnull(m.vl_desconto,0)-ISNULL(m.vl_imposto,0) as Parcela ,
				
				(SELECT sum(tt1.valor_aliquota)
				FROM parcela_aliquota tt1
				inner join Aliquota tt2 on tt1.cd_aliquota = tt2.cd_aliquota
				WHERE tt1.cd_parcela = m.cd_parcela
				and tT2.cd_grupo_aliquota = 5
				AND tt1.dt_exclusao IS NULL) as iss,

				ISNULL(m.vl_imposto,0) as Imposto,
				isnull(m.vl_taxa,0) as taxa,
				t.nm_tipo_pagamento as Carteira,
			    Case when datediff(day,m.DT_VENCIMENTO,'''+convert(varchar(10),@dt_fmenos1,101)+''') <= 30 then m.vl_parcela + isnull(m.vl_acrescimo,0) - isnull(m.vl_desconto,0)-ISNULL(m.vl_imposto,0) else 0 end as Ate30Dias,
			    Case when datediff(day,m.DT_VENCIMENTO,'''+convert(varchar(10),@dt_fmenos1,101)+''') > 30 and datediff(day,m.DT_VENCIMENTO,'''+convert(varchar(10),@dt_fmenos1,101)+''') <= 60 then m.vl_parcela + isnull(m.vl_acrescimo,0) - isnull(m.vl_desconto,0)-ISNULL(m.vl_imposto,0) else 0 end as Ate60Dias,
			    Case when datediff(day,m.DT_VENCIMENTO,'''+convert(varchar(10),@dt_fmenos1,101)+''') > 60 then m.vl_parcela + isnull(m.vl_acrescimo,0) - isnull(m.vl_desconto,0)-ISNULL(m.vl_imposto,0) else 0 end as Sup60Dias,
				m.lnfid as Lote, nf.lnfProtocolo as Protocolo, p.ds_tipo_parcela as DS_Parcela, 
				sh.NM_SITUACAO_HISTORICO + '' '' + isnull(mc.nm_MOTIVO_CANCELAMENTO,'''') as situacao, e.nm_fantasia, ce.ds_centro_custo, ge.nm_grupo
		   FROM MENSALIDADES as m inner join ASSOCIADOS as a on m.CD_ASSOCIADO_empresa = a.cd_associado and m.tp_associado_empresa = 1 
		          inner join empresa as e on a.cd_empresa = e.cd_empresa 
		          inner join TIPO_PAGAMENTO as t on m.CD_TIPO_Pagamento = t.cd_tipo_pagamento 
		          inner join tipo_parcela as p on m.cd_tipo_parcela = p.cd_tipo_parcela
		          inner join dependentes as d on a.cd_Associado = d.cd_Associado and d.cd_grau_parentesco=1
		          inner join historico as h on d.cd_Sequencial_historico = h.cd_sequencial 
		          inner join situacao_historico as sh on h.cd_situacao = sh.cd_situacao_historico 
		           left join lote_Nfe as nf on m.lnfid = nf.lnfid	
		           left join motivo_cancelamento as mc on h.cd_MOTIVO_CANCELAMENTO = mc.cd_MOTIVO_CANCELAMENTO
		           LEFT JOIN tipo_empresa te ON e.tp_empresa = te.tp_empresa
		           left join centro_custo as ce on e.cd_centro_custo = ce.cd_centro_custo
				   left join grupo as ge on e.cd_grupo = ge.cd_grupo
		  WHERE m.DT_VENCIMENTO < '''+convert(varchar(10),@dt_f,101)+''' 
			and m.dt_emissao is not null 
			--and m.cd_tipo_recebimento = 0 		  
		     '
		  
		 if @centro_custo > 0 
		    Set @SQL = @SQL + ' and e.cd_centro_custo = ' + CONVERT(varchar(10),@centro_custo) 

		if @grupo > 0 
			Set @SQL = @SQL + ' and e.cd_grupo = ' + CONVERT(varchar(10),@grupo) 

		 --Set @SQL = @SQL + ' and e.cd_empresa not in (select cd_Associado_empresa from exclusao_registrosauxiliares_empAssoc where tp_associado_empresa=2	) 
		 --                    and a.cd_associado not in (select cd_Associado_empresa from exclusao_registrosauxiliares_empAssoc where tp_associado_empresa=1	) 
		 --                    and m.cd_tipo_parcela not in (select cd_tipo_parcela from tipo_parcela where fl_excluir_regaux=1 )
		 --                    and m.cd_parcela not in (select cd_parcela from exclusao_regaux_parcelas)  '			    
		    		  
		 Set @SQL = @SQL + '    
		        and (    (m.CD_TIPO_RECEBIMENTO =0 and m.dt_cancelado_contabil is null ) -- Aberta
		              or (m.dt_cancelado_contabil >= '''+convert(varchar(10),@dt_f,101)+''') -- Cancelada depois da competencia
		              or (m.CD_TIPO_RECEBIMENTO >2 and m.dt_cancelado_contabil is null and isnull(m.dt_credito, m.dt_pagamento) >= '''+convert(varchar(10),@dt_f,101)+''' ) -- Pago depois da competencia
		             )'		    		  
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
					case when te.tp_empresa = 8 then ''CADE'' else ''PJ'' end as tipo, 
					m.DT_VENCIMENTO as DT_VENCIMENTO, 
					m.CD_ASSOCIADO_empresa as codigo, e.nm_fantasia as nome, 
					isnull(e.nr_cgc,'''') nr_CPF_CGC,
					m.cd_parcela as Documento,  
					convert(varchar(10),m.DT_VENCIMENTO,103) as dt_venc,
					convert(varchar(10), m.dt_emissao,103) as dt_emissao,
					datediff(day,m.DT_VENCIMENTO,'''+convert(varchar(10),@dt_fmenos1,101)+''') as dias_atraso,				
					m.vl_parcela + isnull(m.vl_acrescimo,0) - isnull(m.vl_desconto,0)-ISNULL(m.vl_imposto,0) as Parcela ,
					
					(SELECT sum(tt1.valor_aliquota)
					FROM parcela_aliquota tt1
					inner join Aliquota tt2 on tt1.cd_aliquota = tt2.cd_aliquota
					WHERE tt1.cd_parcela = m.cd_parcela
					and tT2.cd_grupo_aliquota = 5
					AND tt1.dt_exclusao IS NULL) as iss,

					ISNULL(m.vl_imposto,0) as Imposto,
					isnull(m.vl_taxa,0) as taxa,
					t.nm_tipo_pagamento as Carteira,
					Case when datediff(day,m.DT_VENCIMENTO ,'''+convert(varchar(10),@dt_fmenos1,101)+''') <= 30 then m.vl_parcela + isnull(m.vl_acrescimo,0) - isnull(m.vl_desconto,0)-ISNULL(m.vl_imposto,0) else 0 end as Ate30Dias,
					Case when datediff(day,m.DT_VENCIMENTO ,'''+convert(varchar(10),@dt_fmenos1,101)+''') > 30 and datediff(day,m.DT_VENCIMENTO,'''+convert(varchar(10),@dt_fmenos1,101)+''') <= 60 then m.vl_parcela + isnull(m.vl_acrescimo,0) - isnull(m.vl_desconto,0)-ISNULL(m.vl_imposto,0) else 0 end as Ate60Dias,
					Case when datediff(day,m.DT_VENCIMENTO ,'''+convert(varchar(10),@dt_fmenos1,101)+''') > 60 then m.vl_parcela + isnull(m.vl_acrescimo,0) - isnull(m.vl_desconto,0)-ISNULL(m.vl_imposto,0) else 0 end as Sup60Dias,
					m.lnfid as Lote, nf.lnfProtocolo as Protocolo, p.ds_tipo_parcela as DS_Parcela, 
					sh.NM_SITUACAO_HISTORICO + '' '' + isnull(mc.nm_MOTIVO_CANCELAMENTO,'''') as situacao, e.nm_fantasia, ce.ds_centro_custo, ge.nm_grupo
			   FROM MENSALIDADES as m inner join EMPRESA as e on m.CD_ASSOCIADO_empresa = e.cd_empresa and m.tp_associado_empresa in (2,3) 
			          inner join TIPO_PAGAMENTO as t on m.CD_TIPO_Pagamento = t.cd_tipo_pagamento 
		              inner join historico as h on e.cd_Sequencial_historico = h.cd_sequencial 
		              inner join situacao_historico as sh on h.cd_situacao = sh.cd_situacao_historico 
		              inner join tipo_parcela as p on m.cd_tipo_parcela = p.cd_tipo_parcela
		              left join lote_Nfe as nf on m.lnfid = nf.lnfid		              
		              left join motivo_cancelamento as mc on h.cd_MOTIVO_CANCELAMENTO = mc.cd_MOTIVO_CANCELAMENTO
		              LEFT JOIN tipo_empresa te ON e.tp_empresa = te.tp_empresa
		              left join centro_custo as ce on e.cd_centro_custo = ce.cd_centro_custo
					  left join grupo as ge on e.cd_grupo = ge.cd_grupo
		       WHERE m.DT_VENCIMENTO < '''+convert(varchar(10),@dt_f,101)+'''
				 and m.dt_emissao is not null 
				-- and m.cd_tipo_recebimento = 0 		       
		    '

		 if @centro_custo > 0 
		    Set @SQL = @SQL + ' and e.cd_centro_custo = ' + CONVERT(varchar(10),@centro_custo) 

		if @grupo > 0 
			Set @SQL = @SQL + ' and e.cd_grupo = ' + CONVERT(varchar(10),@grupo) 

		 --Set @SQL = @SQL + ' and e.cd_empresa not in (select cd_Associado_empresa from exclusao_registrosauxiliares_empAssoc where tp_associado_empresa=2	) 
		 --                    and m.cd_tipo_parcela not in (select cd_tipo_parcela from tipo_parcela where fl_excluir_regaux=1 )
		 --                    and m.cd_parcela not in (select cd_parcela from exclusao_regaux_parcelas)  '			    

		 Set @SQL = @SQL + '    
		        and (    (m.CD_TIPO_RECEBIMENTO =0 and m.dt_cancelado_contabil is null ) -- Aberta
		              or (m.dt_cancelado_contabil >= '''+convert(varchar(10),@dt_f,101)+''') -- Cancelada depois da competencia
		              or (m.CD_TIPO_RECEBIMENTO >2 and m.dt_cancelado_contabil is null and isnull(m.dt_credito, m.dt_pagamento) >= '''+convert(varchar(10),@dt_f,101)+''' ) -- Pago depois da competencia
		             ) '	
         

	 End      
     
     Set @SQL = @SQL + ' ORDER BY 2,3'
    
    print @sql
    exec (@sql)
 
 End 
