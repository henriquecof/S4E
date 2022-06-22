/****** Object:  Procedure [dbo].[SP_RegAuxiliar_Canceladas]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE Procedure [dbo].[SP_RegAuxiliar_Canceladas] (@mes varchar(2), @ano varchar(4), @tp_associado smallint = 0,@centro_custo int=0, @grupo int=0)
as     
Begin     
    
-- REGISTRO DE CONTRAPRESTAÇÕES Canceladas – II    
    
Declare @SQL varchar(max)    
Declare @dt_i date --= '08/01/2013'     
Declare @dt_f date --= '09/01/2013'     
    
Set @SQL = @ano  + right('00'+@mes,2)    
exec SP_RegAuxiliar_CancelaContabil @SQL  
    
Set @dt_i = convert(date,@mes + '/01/' + @ano )    
Set @dt_f = DATEADD(month,1,@dt_i)    
    
  -- Canceladas     
  Set @SQL = ''     
  if @tp_associado in (0,1)    
  Begin    
  Set @SQL = @SQL + 'SELECT     
    ''PF'' as tipo,     
    m.CD_ASSOCIADO_empresa as codigo,     
    a.nm_completo as nome,     
    isnull(a.nr_cpf,'''') nr_CPF_CGC,    
    m.cd_parcela as Documento,      
    convert(varchar(10),isnull(m.dt_negociado,m.DT_VENCIMENTO),103) as dt_venc,    
    convert(varchar(10),m.dt_cancelado_contabil,103) as dt_cancelado,    
    --convert(varchar(10),h.dt_situacao,103) as dt_cancelado,    
    m.vl_parcela + isnull(m.vl_acrescimo,0) - isnull(m.vl_desconto,0) as Parcela ,    
    ISNULL(m.vl_imposto,0) as Imposto,    
    isnull(m.vl_taxa,0) as taxa,    
    t.nm_tipo_pagamento as Carteira,    
    m.lnfid as Lote, nf.lnfProtocolo as Protocolo, p.ds_tipo_parcela as DS_Parcela,         
    sh.NM_SITUACAO_HISTORICO + '' '' + isnull(mc.nm_MOTIVO_CANCELAMENTO,'''') as situacao,    
    m.dt_cancelado_contabil, e.nm_fantasia, planos.nm_plano, convert(varchar(100),a.nr_contrato) as nr_contrato, ce.ds_centro_custo, ge.nm_grupo
     FROM MENSALIDADES as m inner join ASSOCIADOS as a on m.CD_ASSOCIADO_empresa = a.cd_associado     
            inner join empresa as e on a.cd_empresa = e.cd_empresa     
            inner join TIPO_PAGAMENTO as t on m.CD_TIPO_Pagamento = t.cd_tipo_pagamento     
            inner join tipo_parcela as p on m.cd_tipo_parcela = p.cd_tipo_parcela    
             left join lote_Nfe as nf on m.lnfid = nf.lnfid     
            inner join dependentes as d on a.cd_Associado = d.cd_Associado and d.cd_grau_parentesco=1    
            inner join historico as h on d.cd_Sequencial_historico = h.cd_sequencial     
            inner join situacao_historico as sh on h.cd_situacao = sh.cd_situacao_historico     
             left join motivo_cancelamento as mc on h.cd_MOTIVO_CANCELAMENTO = mc.cd_MOTIVO_CANCELAMENTO    
         --   inner join dependentes as dep on a.cd_associado = dep.cd_associado    
            inner join planos as planos on d.cd_plano = planos.cd_plano    
            left join centro_custo as ce on e.cd_centro_custo = ce.cd_centro_custo
			left join grupo as ge on e.cd_grupo = ge.cd_grupo
    WHERE m.tp_associado_empresa = 1     
   and convert(varchar(6),m.dt_cancelado_contabil,112) > convert(varchar(6),m.dt_emissao,112)    
   and m.dt_cancelado_contabil >= '''+convert(varchar(10),@dt_i,101) + ''' and m.dt_cancelado_contabil < '''+convert(varchar(10),@dt_f,101)+'''     
   '    
        
   if @centro_custo > 0     
      Set @SQL = @SQL + ' and e.cd_centro_custo = ' + CONVERT(varchar(10),@centro_custo)    
	  
	if @grupo > 0 
		Set @SQL = @SQL + ' and e.cd_grupo = ' + CONVERT(varchar(10),@grupo)     
    
   Set @SQL = @SQL + ' and e.cd_empresa not in (select cd_Associado_empresa from exclusao_registrosauxiliares_empAssoc where tp_associado_empresa=2 )     
                       and a.cd_associado not in (select cd_Associado_empresa from exclusao_registrosauxiliares_empAssoc where tp_associado_empresa=1 )     
                       and m.cd_tipo_parcela not in (select cd_tipo_parcela from tipo_parcela where fl_excluir_regaux=1 )    
                       and m.cd_parcela not in (select cd_parcela from exclusao_regaux_parcelas)  '           
    
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
		 ''PJ'' as tipo,     
		 m.CD_ASSOCIADO_empresa as codigo,   
		 a.nm_fantasia as nome, --a.NM_RAZSOC as nome,     
		 isnull(a.nr_cgc,'''') nr_CPF_CGC,    
		 m.cd_parcela as Documento,      
		 convert(varchar(10),isnull(m.dt_negociado,m.DT_VENCIMENTO),103) as dt_venc,    
		 convert(varchar(10),m.dt_cancelado_contabil,103) as dt_cancelado,    
		 --convert(varchar(10),h.dt_situacao,103) as dt_cancelado,    
		 m.vl_parcela + isnull(m.vl_acrescimo,0) - isnull(m.vl_desconto,0) as Parcela,    
		 ISNULL(m.vl_imposto,0) as Imposto,    
		 isnull(m.vl_taxa,0) as taxa,    
		 t.nm_tipo_pagamento as Carteira,    
		 m.lnfid as Lote, nf.lnfProtocolo as Protocolo, p.ds_tipo_parcela as DS_Parcela,             
		 sh.NM_SITUACAO_HISTORICO + '' '' + isnull(mc.nm_MOTIVO_CANCELAMENTO,'''') as situacao,    
		 m.dt_cancelado_contabil, a.nm_fantasia,        
		  (select top 1 planos.nm_plano  
             from planos inner join mensalidades_planos as mp on planos.cd_plano = mp.cd_plano
            where mp.cd_parcela_mensalidade=m.CD_PARCELA and cd_tipo_parcela in (1,2)
           ) , 
           a.cd_empresa as nr_contrato, ce.ds_centro_custo, ge.nm_grupo
      FROM MENSALIDADES as m inner join EMPRESA as a on m.CD_ASSOCIADO_empresa = a.cd_empresa     
             inner join TIPO_PAGAMENTO as t on m.CD_TIPO_Pagamento = t.cd_tipo_pagamento    
             inner join tipo_parcela as p on m.cd_tipo_parcela = p.cd_tipo_parcela    
              left join lote_Nfe as nf on m.lnfid = nf.lnfid                   
             inner join historico as h on a.cd_Sequencial_historico = h.cd_sequencial     
             inner join situacao_historico as sh on h.cd_situacao = sh.cd_situacao_historico     
              left join motivo_cancelamento as mc on h.cd_MOTIVO_CANCELAMENTO = mc.cd_MOTIVO_CANCELAMENTO   
              left join centro_custo as ce on a.cd_centro_custo = ce.cd_centro_custo 
			  left join grupo as ge on a.cd_grupo = ge.cd_grupo
     WHERE m.tp_associado_empresa in (2,3)     
       and convert(varchar(6),m.dt_cancelado_contabil,112) > convert(varchar(6),m.dt_emissao ,112)   
       and m.dt_cancelado_contabil >= '''+convert(varchar(10),@dt_i,101) + ''' and m.dt_cancelado_contabil < '''+convert(varchar(10),@dt_f,101)+'''     
    '    
        
   if @centro_custo > 0     
      Set @SQL = @SQL + ' and a.cd_centro_custo = ' + CONVERT(varchar(10),@centro_custo) 
	  
	if @grupo > 0 
		Set @SQL = @SQL + ' and a.cd_grupo = ' + CONVERT(varchar(10),@grupo)     
    
   Set @SQL = @SQL + ' and a.cd_empresa not in (select cd_Associado_empresa from exclusao_registrosauxiliares_empAssoc where tp_associado_empresa=2 )     
                       and m.cd_tipo_parcela not in (select cd_tipo_parcela from tipo_parcela where fl_excluir_regaux=1 )    
                       and m.cd_parcela not in (select cd_parcela from exclusao_regaux_parcelas) '           
          
     End          
         
     Set @SQL = @SQL + ' ORDER BY m.dt_cancelado_contabil, 2'    
        
    print @sql    
    exec (@sql)    
    
     
 End 
