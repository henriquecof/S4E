/****** Object:  Procedure [dbo].[SP_Dirf]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE Procedure [dbo].[SP_Dirf] (@ano int , @empresa varchar(10))
as
Begin
/*
	Ticket 11049: Correção da dirf com o join de associado com empresa.
*/
	Declare @dtini varchar(20)
	Declare @dtfim varchar(20)
	Declare @sql varchar(8000)
	Declare @tp_empresa smallint
	
	select @tp_empresa = tp_empresa
	from empresa
	where cd_empresa = @empresa

	Set @dtini = '01/01/'+CONVERT(varchar(4),@ano)
	Set @dtfim = '12/31/'+CONVERT(varchar(4),@ano) + ' 23:59'
print @tp_empresa
	if(@tp_empresa = 2 or @tp_empresa = 8)
		begin
			Set @sql='select e.nm_fantasia , a.cd_associado , a.nr_cpf , a.nm_completo  , 
				   d.nr_cpf_dep , convert(varchar(10),d.DT_NASCIMENTO,103) DT_NASCIMENTO, d.NM_DEPENDENTE , g.nm_grau_parentesco ,  
				   isnull(sum(mp.valor),0) as valor, d.DT_NASCIMENTO DT_NASCIMENTOOrder
			  from empresa as e , associados as a, dependentes as d, mensalidades as m , mensalidades_planos as mp, planos as p , GRAU_PARENTESCO as g 
			 where e.cd_empresa = a.cd_empresa 
			   and a.cd_associado = d.cd_associado 
			   and d.cd_grau_parentesco = g.cd_grau_parentesco 
			   and e.cd_empresa = m.CD_ASSOCIADO_empresa 
			   and m.TP_ASSOCIADO_EMPRESA in (2,3)
			   and m.cd_parcela *= mp.cd_parcela_mensalidade 
			   and d.cd_Plano *= p.cd_plano
			   and d.cd_sequencial *= mp.cd_sequencial_dep 
			   and m.cd_tipo_recebimento > 2 
			   and mp.dt_exclusao is null 
			   and e.cd_empresa = ' + @empresa + '
			   and m.dt_pagamento >= ''' + @dtini + ''' 
			   and m.dt_pagamento <= ''' + @dtfim + ''' 
			   
			 group by e.nm_fantasia , a.cd_associado , a.nm_completo  , a.nr_cpf , 
				   d.NM_DEPENDENTE , d.cd_grau_parentesco, g.nm_grau_parentesco , d.nr_cpf_dep , d.DT_NASCIMENTO , d.cd_sequencial
			HAVING isnull(sum(mp.valor),0) > 0
			
			order by a.nr_cpf, d.cd_grau_parentesco, d.nr_cpf_dep, DT_NASCIMENTOOrder'
		end
	else
		begin
			Set @sql='select e.nm_fantasia , a.cd_associado , a.nr_cpf , a.nm_completo  , 
				   d.nr_cpf_dep , convert(varchar(10),d.DT_NASCIMENTO,103) DT_NASCIMENTO, d.NM_DEPENDENTE , g.nm_grau_parentesco ,  
				   isnull(sum(mp.valor),0) as valor, d.DT_NASCIMENTO DT_NASCIMENTOOrder
			  from empresa as e , associados as a, dependentes as d, mensalidades as m , mensalidades_planos as mp, planos as p , GRAU_PARENTESCO as g 
			 where e.cd_empresa = a.cd_empresa 
			   and a.cd_associado = d.cd_associado 
			   and d.cd_grau_parentesco = g.cd_grau_parentesco 
			   and a.cd_associado = m.CD_ASSOCIADO_empresa 
			   and m.TP_ASSOCIADO_EMPRESA = 1
			   and m.cd_parcela *= mp.cd_parcela_mensalidade 
			   and d.cd_Plano *= p.cd_plano
			   and d.cd_sequencial *= mp.cd_sequencial_dep 
			   and m.cd_tipo_recebimento > 2 
			   and mp.dt_exclusao is null 
			   and e.cd_empresa = ' + @empresa + '
			   and m.dt_pagamento >= ''' + @dtini + ''' 
			   and m.dt_pagamento <= ''' + @dtfim + ''' 
			   
			 group by e.nm_fantasia , a.cd_associado , a.nm_completo  , a.nr_cpf , 
				   d.NM_DEPENDENTE , d.cd_grau_parentesco, g.nm_grau_parentesco , d.nr_cpf_dep , d.DT_NASCIMENTO , d.cd_sequencial
			HAVING isnull(sum(mp.valor),0) > 0
			order by a.nr_cpf, d.cd_grau_parentesco, d.nr_cpf_dep, DT_NASCIMENTOOrder'
		end

	print @sql
	exec (@sql)
End 
