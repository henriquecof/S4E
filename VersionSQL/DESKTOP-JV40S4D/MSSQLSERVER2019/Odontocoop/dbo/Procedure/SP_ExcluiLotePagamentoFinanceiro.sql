/****** Object:  Procedure [dbo].[SP_ExcluiLotePagamentoFinanceiro]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE Procedure [dbo].[SP_ExcluiLotePagamentoFinanceiro] @lote int
As
Begin

   	
    if (Select count(0)
	      From Pagamento_Dentista_Lancamento 
          where cd_pgto_dentista_lanc=@lote and Sequencial_lancamento is not null)>0
       begin
		 RAISERROR ('Lote j? lan?ado para pagamento. Lote nao pode ser alterado e nem excluido.', 16, 1)
		 Return
       End

     begin tran
		delete arquivo_pagamento_dentista_lancamento where cd_pgto_dentista_lanc =@lote
		if @@ERROR <> 0 
		begin
			rollback 
			RAISERROR ('Erro na exclus?o dos arquivos anexados de Pagamento Dentista.', 16, 1)
			Return
		End 
       
		update consultas
		set vl_acerto_pgto_produtividade = null
		from pagamento_dentista
		where consultas.nr_numero_lote = pagamento_dentista.cd_sequencial
		and pagamento_dentista.cd_pgto_dentista_lanc=@lote
     
		 update pagamento_dentista 
		 set cd_pgto_dentista_lanc = null 
		 where cd_pgto_dentista_lanc=@lote 
		 
		 if @@ERROR <> 0 
		  begin
			 rollback 
			 RAISERROR ('Erro na atualiza??o do Pagamento Dentista.', 16, 1)
			 Return
		   End

     delete Pagamento_Dentista_aliquotas where cd_pgto_dentista_lanc=@lote 
     if @@ERROR <> 0 
      begin
         rollback 
		 RAISERROR ('Erro na exclus?o das aliquotas de Pagamento Dentista.', 16, 1)
		 Return
       End       

	
     delete Pagamento_Dentista_Lancamento where cd_pgto_dentista_lanc=@lote 
     if @@ERROR <> 0 
      begin
         rollback 
		 RAISERROR ('Erro na exclus?o do lan?amento Pagamento Dentista.', 16, 1)
		 Return
       End       
       
     commit   

End 
