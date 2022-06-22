/****** Object:  Procedure [dbo].[SP_FluxoCaixa_Calculado]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE Procedure [dbo].[SP_FluxoCaixa_Calculado]
as
Begin

	Declare @dt date 
	Set @dt = convert(varchar(10),getdate(),101)
	Set @dt = right('0'+convert(varchar(2),month(@dt)),2)+'/01/'+convert(varchar(4),year(@dt))
	print @dt

	-- Calcula o valor de Cada dia
	update configuracao_fluxoprojetado
	   set vl_acumulado = valor
	  from (
	select e.cd_centro_custo,dbo.FS_ContaDiasUteis(convert(varchar(8),dt_pagamento,126)+'01',dt_pagamento,0,25) as dia , sum(vl_pago) as valor -- , dt_pagamento --, m.cd_tipo_recebimento, t.nm_tipo_pagamento 
	from mensalidades as m, tipo_pagamento as t , associados as a , empresa as e
	where m.cd_tipo_recebimento = t.cd_tipo_pagamento 
	  and m.cd_associado_empresa = a.cd_associado 
	  and a.cd_empresa = e.cd_empresa
	  and m.dt_pagamento >= dateadd(year,-1,@dt)
	  and m.dt_pagamento < @dt
	group by e.cd_centro_custo,dbo.FS_ContaDiasUteis(convert(varchar(8),dt_pagamento,126)+'01',dt_pagamento,0,25)  --, dt_pagamento --, m.cd_tipo_recebimento, t.nm_tipo_pagamento
	--order by 1,2
	) as x
	where configuracao_fluxoprojetado.cd_centro_custo = x.cd_centro_custo
	  and configuracao_fluxoprojetado.dia = x.dia 
	  
	-- atualiza os perc_calculado
	update configuracao_fluxoprojetado
	  set perc_calculado = round((vl_acumulado/x.total)*100 ,2)
	 from 
		  (select cd_centro_custo, sum(vl_acumulado) as total from configuracao_fluxoprojetado  group by cd_centro_custo) as x
	 where configuracao_fluxoprojetado.cd_centro_custo = x.cd_centro_custo

	-- Acertar o % do dia 25
	update configuracao_fluxoprojetado
	   set perc_calculado = round(perc_calculado + (100 - x.total),2)
	  from  (select cd_centro_custo, sum(perc_calculado) as total from configuracao_fluxoprojetado group by cd_centro_custo) as x
	 where configuracao_fluxoprojetado.cd_centro_custo = x.cd_centro_custo 
	   and dia=25

	-- Receita Vista e Despesa Sinistro
	update centro_custo 
	   set perc_receitavista = round((recvista.valor/receita.total)*100 ,2),
	       vl_receitavista  = recvista.valor
	  from (
				select e.cd_centro_custo , sum(vl_pago) as valor -- , dt_pagamento --, m.cd_tipo_recebimento, t.nm_tipo_pagamento 
				from mensalidades as m, tipo_pagamento as t , associados as a , empresa as e
				where m.cd_tipo_recebimento = t.cd_tipo_pagamento 
				  and m.cd_associado_empresa = a.cd_associado 
				  and a.cd_empresa = e.cd_empresa
				  and m.dt_pagamento >= dateadd(year,-1,@dt)
				  and m.dt_pagamento < @dt
				  and m.cd_tipo_recebimento in (6,7)
				 group by e.cd_centro_custo ) as recvista, 
			( select cd_centro_custo, sum(vl_acumulado) as total from configuracao_fluxoprojetado  group by cd_centro_custo) as receita
	 where centro_custo.cd_centro_custo =  recvista.cd_centro_custo
	   and centro_custo.cd_centro_custo =  receita.cd_centro_custo      

	update centro_custo 
	   set perc_despesaprodutividade = round((despesa.valor/receita.total)*100 ,2),
	       vl_despesaprodutividade = despesa.valor 
	from (
			select m.cd_centro_custo, sum(f.valor_lancamento) as valor 
			  from tb_conta as c, tb_lancamento as l,tb_formalancamento as f , tb_historicoMovimentacao as h,  tb_movimentacaofinanceira as m
			 where (c.codigo_conta like '%0401' or c.codigo_conta like '%0704') 
			   and c.Sequencial_conta = l.Sequencial_conta 
			   and l.sequencial_lancamento = f.sequencial_lancamento 
			   and f.Sequencial_historico = h.Sequencial_historico
			   and h.Sequencial_movimentacao = m.Sequencial_movimentacao
			   and f.data_pagamento >= dateadd(year,-1,@dt)
			   and f.data_pagamento < @dt
			group by m.cd_centro_custo 
			) as despesa, 
			 ( select cd_centro_custo, sum(vl_acumulado) as total from configuracao_fluxoprojetado  group by cd_centro_custo) as receita
	 where centro_custo.cd_centro_custo =  despesa.cd_centro_custo
	   and centro_custo.cd_centro_custo =  receita.cd_centro_custo   		
	   
End 	    
