/****** Object:  Procedure [dbo].[PS_GeraLancamentosFinanceiro]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[PS_GeraLancamentosFinanceiro]  
	@dia int = 0 
As  
 
Begin  

    --select * from tb_contaParametrizadas
    --select * from tb_contaParametrizadasLancamento
   
    Declare @seq int 
    Declare @corte smallint 	
	declare @venc date
	Declare @venc_final date 
	Declare @carne bit  
    Declare @cd_fornecedor int 
    Declare @cd_funcionario int 
    
	Declare @venc_calculado date 
    Declare @gerado smallint 
    Declare @cd_usuario int = (select cd_funcionario from Processos where cd_processo = 8)
    Declare @loop_Carne bit 
    
    Declare @identify int     
    
	DECLARE cursor_FinanceiroParametro CURSOR FOR  
     select cd_sequencial, dt_corte, venc_inicial, venc_final, fl_carne , cd_fornecedor, cd_funcionario
       from tb_contaParametrizadas 
      where venc_final >= GETDATE() and 
            dt_corte >= case when @dia=0 then 1 else @dia end and 
            --dt_corte <= case when @dia=0 then DAY(getdate()) else @dia end 
            dt_corte <= case when @dia=0 then 30 else @dia end 
            --and cd_sequencial=214
      order by dt_corte
	   OPEN cursor_FinanceiroParametro
	  FETCH NEXT FROM cursor_FinanceiroParametro INTO @seq, @corte, @venc,@venc_final,@carne,@cd_fornecedor, @cd_funcionario
   	  WHILE (@@FETCH_STATUS <> -1)  
	  Begin  

	      --Set @venc_calculado = convert(date,convert(varchar(2),MONTH(getdate()))+'/'+convert(varchar(2),DAY(@venc))+'/'+convert(varchar(4),year(getdate())))
	      Set @venc_calculado = convert(date,convert(varchar(2),MONTH(getdate())) + '/' + case when convert(varchar(2),DAY(@venc))>28 then '28' else convert(varchar(2),DAY(@venc)) end + '/' +convert(varchar(4),year(getdate())))
	      if @corte >= day(@venc)
	         Set @venc_calculado = DATEADD(month,1,@venc_calculado)

          While @venc_calculado < @venc
          begin
	          Set @venc_calculado = DATEADD(month,1,@venc_calculado)
	      End 
	      
	      Set @loop_Carne = 1    
	      While (@venc_calculado >= @venc and @venc_calculado <= @venc_final) and @loop_Carne = 1 
	      Begin
	         
	         Set @loop_Carne = @carne 

print 'inicio'
	         
	         -- Verificar se nao foi gerado
	         select @gerado = COUNT(0) from tb_contaParametrizadasLancamento where cd_sequencial_para = @seq and dt_competencia=@venc_calculado 
	         
	         if isnull(@gerado,0)=0 
	         Begin -- gerar o registro
	            
	            Begin Tran
	            -- Gerar Lancamento Financeiro
	              Insert Into TB_Lancamento (Tipo_Lancamento, Historico, Sequencial_Conta, nome_usuario, cd_fornecedor, cd_funcionario)
				  select 2, HISTORICO , sequencial_conta , @cd_usuario, @cd_fornecedor, @cd_funcionario
					from tb_contaParametrizadas
				   where cd_sequencial = @seq 
				     
				 select @identify = @@IDENTITY 
				 if @identify is null 
				  Begin
					 rollback 
					 Close cursor_FinanceiroParametro
					 Deallocate cursor_FinanceiroParametro					 
					 RAISERROR ('Erro na inclusao do Lancamento no financeiro.', 16, 1)
					 Return  
				  End       
				  
				  Insert Into TB_FormaLancamento (Tipo_ContaLancamento, Forma_Lancamento, Data_Documento, Valor_Previsto, Data_HoraLancamento, 
				         Sequencial_Historico, nome_usuario, Sequencial_Lancamento) 
				  select 2, 7, @venc_calculado, valor, getdate(), 
				        (Select max(sequencial_historico) from TB_HistoricoMovimentacao as h
				          where h.Sequencial_Movimentacao = m.Sequencial_Movimentacao ),
				         @cd_usuario, 
				         @identify                            
				    from tb_contaParametrizadas as m
				   where cd_sequencial = @seq 
				   
				  if @@ROWCOUNT <> 1 
				  Begin
					rollback 
					Close cursor_FinanceiroParametro
					Deallocate cursor_FinanceiroParametro						
					RAISERROR ('Erro na inclusao da Forma de Lancamento no financeiro.', 16, 1)
					Return  
				  End         


                  insert tb_contaParametrizadasLancamento (cd_sequencial_para,dt_competencia,dt_recebido,sequencial_lancamento)
                  values (@seq,@venc_calculado, case when @carne=1 then GETDATE() else null end,@identify)

				  if @@ROWCOUNT <> 1 
				  Begin
					rollback 
					Close cursor_FinanceiroParametro
					Deallocate cursor_FinanceiroParametro						
					RAISERROR ('Erro na inclusao da Conta Parametrizada.', 16, 1)
					Return  
				  End                       
	            
  	              Commit
	            
	         End 
	         
	         Set @venc_calculado = DATEADD(month,1,@venc_calculado)
	         
	      End    
        	   
	      FETCH NEXT FROM cursor_FinanceiroParametro INTO @seq, @corte, @venc, @venc_final, @carne, @cd_fornecedor, @cd_funcionario
	  End
	  Close cursor_FinanceiroParametro
	  Deallocate cursor_FinanceiroParametro

End
