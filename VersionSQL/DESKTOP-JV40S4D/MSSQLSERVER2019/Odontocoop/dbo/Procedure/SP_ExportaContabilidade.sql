/****** Object:  Procedure [dbo].[SP_ExportaContabilidade]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE Procedure [dbo].[SP_ExportaContabilidade] (
  @dti date,
  @dtf date,
  @modelo smallint
  )
as 
Begin

--Declare @dti date = '05/20/2015'
--Declare @dtf date = '06/01/2015'
-- Tipo: 1- Previsto, 2-Realizado, 3- Movimentacao , 4 - Pgto mesmo dia

if @dti is null or @dtf is null 
Begin
  raiserror('Datas não informadas.',16, 1)
  return
End

Set @dtf = DATEADD(DAY,1,@dtf)

if @modelo = 1 -- Alterdata Completo
Begin
	select Tipo, Sequencial_Lancamento, convert(varchar(10),Dt,103) as Data,Valor,descricao,Caixa, conta, DConta,ds_centro_custo,MultaDesconto,
		   case when x.Tipo_Conta = 2 then c1.CD_Contabilidade else c2.CD_Contabilidade end as Conta_D,
		   case when x.Tipo_Conta = 2 then c1.ds_contabilidade else c2.ds_contabilidade end as DConta_D, 
		   case when x.Tipo_Conta = 2 then c2.CD_Contabilidade else c1.CD_Contabilidade end as Conta_C ,
		   case when x.Tipo_Conta = 2 then c2.ds_contabilidade else c1.ds_contabilidade end as dsConta_C
	from (
	SELECT 1 as Tipo, 
		   t2.Sequencial_Lancamento,
		   t10.Data_Documento as Dt, 
		   isnull(T10.Valor_Previsto,T10.Valor_Lancamento) as Valor,
		   T2.Historico as descricao, 
		   t4.Descricao_Movimentacao as Caixa,
		   T1.Codigo_Conta as conta, 
		   t1.Descricao_Conta as DConta,
		   t6.ds_centro_custo , 
		   isnull(t1.CD_Contabilidade_realizado,0) as C_R, -- Realizado
		   isnull(t7.cd_contabilidade,isnull(t1.CD_Contabilidade,0)) as C_T, -- Transicao 
		   0 as MultaDesconto,-- Diferença
		   t5.Tipo_Conta -- 1 - Rec, 2-Pag
	  FROM tb_formalancamento t10 inner join tb_lancamento t2 on t10.sequencial_lancamento = t2.sequencial_lancamento 
			  inner join TB_HistoricoMovimentacao t3 on t10.sequencial_historico    = t3.sequencial_historico
			  inner join TB_MovimentacaoFinanceira T4 on t3.sequencial_movimentacao = t4.sequencial_movimentacao 
			  inner join tb_conta t1 on t2.sequencial_conta = t1.sequencial_conta              
			  inner join tb_contamae t5 on t1.sequencial_contamae     = t5.sequencial_contamae 
			  inner join centro_custo t6 on t4.cd_centro_custo = t6.cd_centro_custo 
			  left  join fornecedores t7 on t2.cd_fornecedor = t7.CD_FORNECEDOR

	 WHERE  t2.Data_HoraExclusao is Null 
	  -- and  t2.Tipo_Lancamento  = 2 -- Saida 
	   And  t10.Data_Documento >= @dti 
	   and  t10.Data_Documento < @dtf 
	   and  t10.Data_Documento <> t10.Data_pagamento
	   and  t5.tipo_classificacao <> 6  
	   and  t1.cd_tipo_exportacao_contabilidade not in (4) 
	union
	SELECT case when t10.Data_Documento <> t10.Data_pagamento then 2 else 4 end as Tipo, 
		   t2.Sequencial_Lancamento,
		   T10.Data_Pagamento as Dt, 
		   isnull(T10.Valor_Lancamento,0) as Valor,
		   T2.Historico as descricao, 
		   t4.Descricao_Movimentacao as Caixa,
		   T1.Codigo_Conta as conta, 
		   t1.Descricao_Conta as DConta,
		   t6.ds_centro_custo , 
		   case when t10.Data_Documento = t10.Data_pagamento or t1.cd_tipo_exportacao_contabilidade in (4) then isnull(t1.CD_Contabilidade_realizado,0) else isnull(t7.cd_contabilidade,isnull(t1.CD_Contabilidade,0)) end as C_T, -- Transicao
		   isnull(t4.CD_Contabilidade,0) as C_R, -- Realizado 
		   isnull(T10.Valor_Lancamento,0)-isnull(T10.Valor_Previsto,isnull(T10.Valor_Lancamento,0)) as MultaDesconto,
		   t5.Tipo_Conta -- 1 - Rec, 2-Pag
	  FROM tb_formalancamento t10 inner join tb_lancamento t2 on t10.sequencial_lancamento = t2.sequencial_lancamento 
			  inner join TB_HistoricoMovimentacao t3 on t10.sequencial_historico    = t3.sequencial_historico
			  inner join TB_MovimentacaoFinanceira T4 on t3.sequencial_movimentacao = t4.sequencial_movimentacao 
			  inner join tb_conta t1 on t2.sequencial_conta = t1.sequencial_conta              
			  inner join tb_contamae t5 on t1.sequencial_contamae     = t5.sequencial_contamae 
			  inner join centro_custo t6 on t4.cd_centro_custo = t6.cd_centro_custo 
			  left  join fornecedores t7 on t2.cd_fornecedor = t7.CD_FORNECEDOR

	 WHERE  t2.Data_HoraExclusao is Null 
	   --and  t2.Tipo_Lancamento  = 2 -- Saida 
	   And  t10.Data_pagamento >= @dti
	   and  t10.Data_pagamento < @dtf 
	   and  t5.tipo_classificacao <> 6  
	 union -- Movimentacao 
	 SELECT 3 as Tipo, 
		   t2.Sequencial_Lancamento,
		   T10.Data_Pagamento as Dt, 
		   isnull(T10.Valor_Lancamento,0) as Valor,
		   T2.Historico as descricao, 
		   t4.Descricao_Movimentacao as Caixa,
		   T1.Codigo_Conta as conta, 
		   t1.Descricao_Conta as DConta,
		   t6.ds_centro_custo , 
			isnull(e4.CD_Contabilidade,0) as C_R, -- Enrrada 
		   isnull(t4.CD_Contabilidade,0) as C_T, -- Saida
		   0 as MultaDesconto,
		   t5.Tipo_Conta -- 1 - Rec, 2-Pag
	  FROM tb_formalancamento t10 inner join tb_lancamento t2 on t10.sequencial_lancamento = t2.sequencial_lancamento -- Saida
			  inner join TB_HistoricoMovimentacao t3 on t10.sequencial_historico    = t3.sequencial_historico -- Saida
			  inner join TB_MovimentacaoFinanceira T4 on t3.sequencial_movimentacao = t4.sequencial_movimentacao  -- Saida
			  inner join tb_conta t1 on t2.sequencial_conta = t1.sequencial_conta  -- Saida            
			  inner join tb_contamae t5 on t1.sequencial_contamae     = t5.sequencial_contamae -- Saida
			  inner join centro_custo t6 on t4.cd_centro_custo = t6.cd_centro_custo -- Saida
			  inner join tb_lancamento e2 on t2.sequencial_lancamento = e2.Sequencial_Lancamento_Origem -- Saida com Entrada
			  inner join tb_formalancamento e10 on e2.sequencial_lancamento = e10.sequencial_lancamento -- Entrada
			  inner join TB_HistoricoMovimentacao e3 on e10.sequencial_historico    = e3.sequencial_historico -- Entrada
			  inner join TB_MovimentacaoFinanceira e4 on e3.sequencial_movimentacao = e4.sequencial_movimentacao  -- Entrada
	          
	 WHERE  t2.Data_HoraExclusao is Null 
	   And  t10.Data_pagamento >= @dti
	   and  t10.Data_pagamento < @dtf 
	   and  t5.tipo_classificacao = 6  
	   and  t2.Tipo_Lancamento  = 2 -- Saida 
	 
	   
	) as x
	   inner join Contabilidade as C1 on x.C_R = c1.cd_contabilidade 
	   inner join Contabilidade as C2 on x.C_T = c2.cd_contabilidade 
	--where x.Sequencial_Lancamento in (137408,137409)
	 Order By 2,1  
End	 

End 
