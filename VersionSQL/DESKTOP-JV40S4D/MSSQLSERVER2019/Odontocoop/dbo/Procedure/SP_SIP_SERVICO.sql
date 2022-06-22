/****** Object:  Procedure [dbo].[SP_SIP_SERVICO]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE Procedure [dbo].[SP_SIP_SERVICO] @trimestre smallint, @ano smallint, @IdConvenio int =-1
as
Begin 

    Declare @dt_ref varchar(10)
    Declare @sql varchar(max)
    
    Set @dt_ref = convert(varchar(2),(((@trimestre-1)*3)+1))+'/01/'+CONVERT(varchar(4),@ano)
    print @dt_ref 

	Set @sql = 'select sans.CD_SERVICO, sans.NM_SERVICO , COUNT(0) as quantidade, sum(vl_pago_produtividade) as valor
				  from Consultas t3 , dependentes d , CLASSIFICACAO_ANS as c,PLANOS as p, SERVICO as s , SERVICO as sans 
				  where t3.dt_servico >= '''+@dt_ref+''' and T3.dt_servico < DATEADD(month,3,'''+@dt_ref+''') and nr_numero_lote is not null 
				  and  t3.cd_servico = s.CD_SERVICO 
				  and  s.cd_servicoANS = sans.CD_SERVICO 
				  and  t3.status in (3,6,7) and sans.cd_servicoans not in (select cd_servico from categoriaANS_Servico)
				  and  t3.vl_pago_produtividade>0
				  and  t3.cd_sequencial_dep = d.CD_SEQUENCIAL and d.cd_plano not in (19,20,21) 
				  and  d.cd_plano=p.cd_plano
				  and  p.cd_classificacao=c.cd_classificacao
				  and  C.idconvenio is null
				group by sans.CD_SERVICO, sans.NM_SERVICO'

	exec(@sql)
  
End 
