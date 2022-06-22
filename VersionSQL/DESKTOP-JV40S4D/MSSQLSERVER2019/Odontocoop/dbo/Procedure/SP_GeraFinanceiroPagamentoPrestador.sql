/****** Object:  Procedure [dbo].[SP_GeraFinanceiroPagamentoPrestador]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE Procedure [dbo].[SP_GeraFinanceiroPagamentoPrestador] @lote int, @nome_usuario int , @dtConhecimento varchar(10)
as
Begin

  if (select count(0) 
       from pagamento_dentista_lancamento 
      where cd_pgto_dentista_lanc = @lote and sequencial_lancamento is not null)>0
  Begin
	 RAISERROR ('Lote enviado anteriormente ao financeiro.', 16, 1)
	 Return  
  End     

  Declare @identify int 
  Declare @incremento_mes smallint = 0 
  Declare @dt_vencimento smallint 
  
  -- Fazer a divisao caso tenha acerto 
  Declare @acerto money, @consulta_acerto money
  Declare @vl_lote money 
  Declare @vl_ajuste money -- Valor acrescido ou descrecido de cada R$ 1,00 do lote
  Declare @seq_cons int 
	  
  select top 1 @incremento_mes = f.qt_incremento_mes_fatura , @dt_vencimento = f.dt_vencimento 
    from pagamento_dentista as pd, FILIAL as f
   where cd_pgto_dentista_lanc = @lote and 
         pd.cd_filial = f.cd_filial 
  
  -- Olhar se a conta e o caixa nao estao inativos
  begin tran

	update consultas 
	  set vl_acerto_pgto_produtividade = 0
	where nr_numero_lote in (select cd_sequencial from pagamento_dentista where cd_pgto_dentista_lanc =  @lote) and isnull(vl_acerto_pgto_produtividade,0) <> 0 
	if @@ERROR<>0 
	  Begin
		 rollback 
		 RAISERROR ('Erro no valor do acerto.', 16, 1)
		 Return  
	  End   

	Select @acerto = isnull(vl_acerto,0), @vl_lote = vl_lote from Pagamento_Dentista_Lancamento where cd_pgto_dentista_lanc = @lote 

	Select @consulta_acerto = isnull(sum(isnull(vl_acerto_pgto_produtividade,0)),0) 
	  from consultas 
	 where nr_numero_lote in (select cd_sequencial from pagamento_dentista where cd_pgto_dentista_lanc =  @lote)

	if @acerto <> @consulta_acerto -- Se o acerto estiver diferente da consulta apagar e iniciar
	Begin

	   Set @vl_ajuste = case when @acerto<0 then -1 else 1 end * FLOOR(abs((@acerto / @vl_lote)*100))
	   Set @vl_ajuste = @vl_ajuste/100
	   
	   update consultas
          set vl_acerto_pgto_produtividade = round(vl_pago_produtividade * @vl_ajuste ,2)
        where nr_numero_lote in (select cd_sequencial from pagamento_dentista where cd_pgto_dentista_lanc =  @lote)   
		if @@ERROR<>0 
		  Begin
			 rollback 
			 RAISERROR ('Erro na atualização do valor do acerto.', 16, 1)
			 Return  
		  End 	    
		  
	   Select @consulta_acerto = @acerto - isnull(sum(isnull(vl_acerto_pgto_produtividade,0)),0) 
		 from consultas 
		where nr_numero_lote in (select cd_sequencial from pagamento_dentista where cd_pgto_dentista_lanc =  @lote) 
	   
	   if @consulta_acerto <> 0 
	   Begin
	      
		  Select top 1 @seq_cons = cd_sequencial from Consultas where nr_numero_lote in (select cd_sequencial from pagamento_dentista where cd_pgto_dentista_lanc =  @lote)   
	      
		  update Consultas set vl_acerto_pgto_produtividade = vl_acerto_pgto_produtividade + @consulta_acerto where cd_sequencial = @seq_cons
			if @@ERROR<>0 
			  Begin
				 rollback 
				 RAISERROR ('Erro no ajuste da primeira linha do acerto.', 16, 1)
				 Return  
			  End 	   
	   End 
	      
	End 
	  
  Insert Into TB_Lancamento (Tipo_Lancamento, Historico, Sequencial_Conta, CD_Dentista,Nome_Outros,nome_usuario)
  select 2, 
         'Produtividade ' + 
         case when pg.cd_filial Is Null then '' else fi.nm_filial end + 
         case when pg.cd_funcionario IS null then '' else 'Dentista ' + f.nm_empregado end + 
         ', ref. lote : ' + convert(varchar(10),@lote)
         + case when pg.idConvenio_ans is not null then ', Convênio: ' + cv.RazaoSocial else '' end  --add #16898
         , m.cd_conta , 
         case when pg.cd_funcionario IS null then null else pg.cd_funcionario  end ,
         case when pg.cd_funcionario IS null then fi.nm_filial else null end ,
         @nome_usuario
         /* add #16898 */

FROM            Pagamento_Dentista_Lancamento AS pg LEFT OUTER JOIN
                         FILIAL AS fi ON pg.cd_filial = fi.cd_filial LEFT OUTER JOIN
                         FUNCIONARIO AS f ON pg.cd_funcionario = f.cd_funcionario INNER JOIN
                         Modelo_Pagamento_Prestador AS m ON pg.cd_modelo_pgto_prestador = m.cd_modelo_pgto_prestador LEFT OUTER JOIN
                         Convenio AS cv ON pg.idConvenio_ans = cv.Id
WHERE        (pg.cd_pgto_dentista_lanc = @lote)
     
     select @identify = @@IDENTITY 
     if @identify is null 
	  Begin
	     rollback 
		 RAISERROR ('Erro na inclusao do Lancamento no financeiro.', 16, 1)
		 Return  
	  End       

  Insert Into TB_FormaLancamento (Tipo_ContaLancamento, Forma_Lancamento, 
              Data_Documento, Valor_Previsto, 
             Data_HoraLancamento, Sequencial_Historico, nome_usuario, Sequencial_Lancamento) 
    select 2,7,
            convert(date,
isnull((select top 1 dt_previsao_pagamento from pagamento_dentista where cd_pgto_dentista_lanc = @lote),
(
case
when @dt_vencimento > dbo.LastDayMonth(convert(date,dateadd(month,Isnull(@incremento_mes,0),getdate()))) then
convert(varchar(2),month(dateadd(month,Isnull(@incremento_mes,0),getdate()))) + '/' + convert(varchar(2),dbo.LastDayMonth(convert(date,dateadd(month,Isnull(@incremento_mes,0),getdate())))) + '/' + convert(varchar(4),year(dateadd(month,Isnull(@incremento_mes,0),getdate())))
else
convert(varchar(2),month(dateadd(month,Isnull(@incremento_mes,0),getdate()))) + '/' + convert(varchar(2),@dt_vencimento) + '/' + convert(varchar(4),year(dateadd(month,Isnull(@incremento_mes,0),getdate())))
end
)
)
),
          vl_bruto - (select isnull(sum(valor_aliquota),0) 
                        from Pagamento_Dentista_Aliquotas as pda 
                       where pda.cd_pgto_dentista_lanc = pl.cd_pgto_dentista_lanc and 
                             pda.dt_exclusao is null and 
                             pda.id_retido = 1),
     getdate(), 
    (Select max(sequencial_historico) 
       from TB_HistoricoMovimentacao as h
      where h.Sequencial_Movimentacao = m.Sequencial_Movimentacao ),
     @nome_usuario, 
     @identify                            
    from pagamento_dentista_lancamento pl, Modelo_Pagamento_Prestador as m
  where pl.cd_modelo_pgto_prestador = m.cd_modelo_pgto_prestador and cd_pgto_dentista_lanc = @lote 
  if @@ROWCOUNT <> 1 
   Begin
     rollback 
	 RAISERROR ('Erro na inclusao da Forma de Lancamento no financeiro.', 16, 1)
	 Return  
   End         
  
  update pagamento_dentista_lancamento set sequencial_lancamento = @identify, dt_conhecimento = @dtConhecimento where cd_pgto_dentista_lanc = @lote 
  if @@ROWCOUNT <> 1 
   Begin
     rollback 
	 RAISERROR ('Erro na vinculação do Lancamento ao lote.', 16, 1)
	 Return  
   End         
   
   
   commit 
   
End
