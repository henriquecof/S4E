/****** Object:  Procedure [dbo].[SP_EnviaCreditoBanco_Financeiro]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE Procedure [dbo].[SP_EnviaCreditoBanco_Financeiro] @sequencial int, @data date, @erro tinyint output, @envio smallint = 0
as 
Begin

  Set @erro = 0 

  if @data is null
     Set @data = convert(varchar(10),getdate(),101)
       
  Declare @seqmov int , @seqconta int, @realizado tinyint, @consolidado tinyint, @valor money, @dt_credito date , @identify int, @lancaIndividual tinyint, @cd_parcela int, @nrAutorizacao varchar(20), @cliente varchar(max), @nsuAdministradora varchar(6), @pagamentoId varchar(36)
  declare @nm_tipopag varchar(100), @nm_arquivo varchar(100), @cd_func int
  Declare @SeqConta_pf int, @SeqConta_pj int, @tp_ass int 
  Declare @cd_tipopagamento int , @fl_exige_Dados_cartao  bit 
  Declare @Sequencial_conta_taxa int = null 
  Declare @vl_taxa money 

  select top 1 @cd_func=cd_funcionario from processos where cd_funcionario is not null 
  
  if @envio = 0
  begin  
	  Select @seqmov = sequencial_movimentacao , @seqconta = Sequencial_conta, @realizado = fl_realizado, @consolidado = fl_consolidado, @lancaIndividual = ISNULL(t.lancaIndividual,0), 
	         @nm_tipopag=tp.nm_tipo_pagamento, @nm_arquivo=isnull(l.nm_arquivo, convert(varchar(10),@sequencial)), 
	         @SeqConta_pf = t.Sequencial_conta_pf, @SeqConta_pj = t.Sequencial_conta_pj, 
	         @cd_tipopagamento = l.cd_tipo_pagamento, @fl_exige_Dados_cartao  = ISNULL(tp.fl_exige_Dados_cartao,0), 
			 @Sequencial_conta_taxa = Sequencial_conta_taxa
		from Lote_Processos_Bancos_Retorno as l, TIPO_PAGAMENTO_CAIXA as t, tipo_pagamento as tp 
	   where cd_sequencial_retorno=@sequencial  and l.cd_tipo_pagamento = t.cd_tipo_pagamento and l.cd_tipo_pagamento=tp.cd_tipo_pagamento
   end 
  else 
  begin
	  Select @seqmov = sequencial_movimentacao , @seqconta = Sequencial_conta, @realizado = fl_realizado, @consolidado = fl_consolidado, @lancaIndividual = ISNULL(t.lancaIndividual,0), 
	         @nm_tipopag=tp.nm_tipo_pagamento, @nm_arquivo=isnull(l.nm_arquivo, convert(varchar(10),@sequencial)), 
	         @SeqConta_pf = t.Sequencial_conta_pf, @SeqConta_pj = t.Sequencial_conta_pj,
	         @cd_tipopagamento = l.cd_tipo_pagamento, @fl_exige_Dados_cartao  = ISNULL(tp.fl_exige_Dados_cartao,0), 
			 @Sequencial_conta_taxa = null 
		from Lote_Processos_Bancos as l, TIPO_PAGAMENTO_CAIXA as t, tipo_pagamento as tp
	   where cd_sequencial =@sequencial  and l.cd_tipo_pagamento = t.cd_tipo_pagamento and l.cd_tipo_pagamento=tp.cd_tipo_pagamento  
  end  
   
  if @seqmov is not null 
  begin 
		print '1'
		if @lancaIndividual = 0
			begin
              print '2'
			  if @envio = 0
			  begin 				
				  Declare Dados_Cursor_BF  cursor for  
				   Select l.dt_credito,SUM(l.vl_pago) , 
				          case when @SeqConta_pf IS null or @SeqConta_pj IS null then 0 else m.TP_ASSOCIADO_EMPRESA end , 
						  sum(l.vl_tarifa) 
					 from Lote_Processos_Bancos_Retorno_Mensalidades as l inner join mensalidades as m on l.cd_parcela = m.CD_PARCELA 
					where l.cd_sequencial_retorno=@sequencial and l.cd_ocorrencia IN (0,31,35)
			 		group by l.dt_credito, case when @SeqConta_pf IS null or @SeqConta_pj IS null then 0 else m.TP_ASSOCIADO_EMPRESA end 
			  end		
		      else
		      begin
				  Declare Dados_Cursor_BF  cursor for  
				   Select l.dt_credito,SUM(l.vl_parcela) , 
				          case when @SeqConta_pf IS null or @SeqConta_pj IS null then 0 else m.TP_ASSOCIADO_EMPRESA end  , 
						  0 
					 from Lote_Processos_Bancos_Mensalidades  as l inner join mensalidades as m on l.cd_parcela = m.CD_PARCELA 
					where l.cd_sequencial_lote=@sequencial and l.cd_retorno=0
			 		group by l.dt_credito, case when @SeqConta_pf IS null or @SeqConta_pj IS null then 0 else m.TP_ASSOCIADO_EMPRESA end 
		      end
  				  Open Dados_Cursor_BF
				  Fetch next from Dados_Cursor_BF Into @dt_credito, @valor,@tp_ass,@vl_taxa
				  While (@@fetch_status  <> -1)
				  Begin
					   --- Gerar o lancamento financeiro no modulo financeiro
					  Insert Into TB_Lancamento (Tipo_Lancamento, Historico, Sequencial_Conta, CD_Dentista,Nome_Outros,nome_usuario,cd_sequencial_lote_retorno,cd_sequencial_lote_envio)
					  values (1, 
							 'Recebimento ' + @nm_tipopag + ', arquivo ' + @nm_arquivo + ' - Crédito : ' + convert(varchar(10),isnull(@dt_credito,@data),103), 
							 case when @tp_ass = 0 then @seqconta when @tp_ass=1 then @SeqConta_pf else @SeqConta_pj end, 
							 null , null , @cd_func,case when @envio = 0 then @sequencial else null end , 
							 case when @envio = 0 then null else @sequencial end)
                   					     
						 select @identify = @@IDENTITY 
						 if @identify is null 
						  Begin
							 Set @erro = 1
							 return 
						  End       
						  
						  if @realizado=0  -- Previsto  
						  begin
							  Insert Into TB_FormaLancamento (Tipo_ContaLancamento, Forma_Lancamento, 
										  Data_Documento, Valor_Previsto,  -- Previsto
										  Data_HoraLancamento, Sequencial_Historico, nome_usuario, Sequencial_Lancamento) 
								values (2,case when @fl_exige_Dados_cartao=0 then 7 else 9 end,isnull(@dt_credito,@data), @valor , getdate(), -- Previsto 
										(Select max(sequencial_historico) 
										   from TB_HistoricoMovimentacao as h
										  where h.Sequencial_Movimentacao = @seqmov ),
									   7021, 
									   @identify )
						  End 
						  else
						  Begin 

							  Insert Into TB_FormaLancamento (Tipo_ContaLancamento, Forma_Lancamento, 
										 Data_Documento, Valor_Lancamento, Data_pagamento, Data_Lancamento,
										 Data_HoraLancamento, Sequencial_Historico, nome_usuario, Sequencial_Lancamento) 
								values (1,case when @fl_exige_Dados_cartao=0 then 7 else 9 end,isnull(@dt_credito,@data), @valor , isnull(@dt_credito,@data), getdate(), getdate(),  -- Realizado
										(Select max(sequencial_historico) 
										   from TB_HistoricoMovimentacao as h
										  where h.Sequencial_Movimentacao = @seqmov ),
									   7021, 
									   @identify )                           
							  End  
				                  
						  if @@ROWCOUNT <> 1 
						   Begin
							  Set @erro = 1
						   End         

						   insert TB_MensalidadeAssociado (Sequencial_Lancamento,cd_parcela,tipo_mensalidade_gerada)
						   select @identify, m.cd_parcela,1
							 from Lote_Processos_Bancos_Retorno_Mensalidades as m inner join mensalidades as m1 on m.cd_parcela = m1.CD_PARCELA
							where cd_sequencial_retorno = @sequencial and cd_ocorrencia in (0,31) and m1.TP_ASSOCIADO_EMPRESA=@tp_ass
							  and isnull(m.dt_credito,m.dt_pago) = @dt_credito
						   union 
						   select @identify, ma.cd_parcela,1
							 from Lote_Processos_Bancos_Retorno_Mensalidades as m inner join MensalidadesAgrupadas as ma on m.cd_parcela=ma.cd_parcelaMae
										inner join mensalidades as m1 on ma.cd_parcela = m1.CD_PARCELA
							where cd_sequencial_retorno = @sequencial and cd_ocorrencia in (35)  and m1.TP_ASSOCIADO_EMPRESA=@tp_ass
							  and isnull(m.dt_credito,m.dt_pago) = @dt_credito
				      
						  if @@ROWCOUNT < 1 
						   Begin
							  Set @erro = 1
						   End    

					Fetch next from Dados_Cursor_BF Into @dt_credito, @valor,@tp_ass,@vl_taxa
				End
				Close Dados_Cursor_BF
				Deallocate Dados_Cursor_BF   
		 
			end
			
			
		if @lancaIndividual = 1
			begin
			print '3' 
			
			  if @envio=0
			  begin
				  Declare Dados_Cursor_BFI  cursor for  
				   Select cd_parcela, dt_credito, vl_pago, nrAutorizacao 
				   , ( select convert(varchar,t100.cd_associado) + ' - ' + convert(varchar,t100.nm_completo)
					   from associados t100, mensalidades t200
					   where t100.cd_associado = t200.CD_ASSOCIADO_empresa
						and t200.TP_ASSOCIADO_EMPRESA = 1
						and t200.CD_PARCELA = Lote_Processos_Bancos_Retorno_Mensalidades.cd_parcela
					   UNION
					   select convert(varchar,t100.cd_empresa) + ' - ' + convert(varchar,t100.nm_fantasia)
					   from empresa t100, mensalidades t200
					   where t100.cd_empresa = t200.CD_ASSOCIADO_empresa
						and t200.TP_ASSOCIADO_EMPRESA = 2
						and t200.CD_PARCELA = Lote_Processos_Bancos_Retorno_Mensalidades.cd_parcela
						) as cliente, nsuAdministradora, null  
					from Lote_Processos_Bancos_Retorno_Mensalidades 
					where cd_sequencial_retorno=@sequencial
					and cd_ocorrencia in (0,35)
		       end
		       else
		       begin
				  Declare Dados_Cursor_BFI  cursor for  		       
				   Select cd_parcela, dt_credito, vl_parcela, isnull(nr_autorizacao ,'')
				   , ( select convert(varchar,t100.cd_associado) + ' - ' + convert(varchar,t100.nm_completo)
					   from associados t100, mensalidades t200
					   where t100.cd_associado = t200.CD_ASSOCIADO_empresa
						and t200.TP_ASSOCIADO_EMPRESA = 1
						and t200.CD_PARCELA = Lote_Processos_Bancos_Mensalidades.cd_parcela
					   UNION
					   select convert(varchar,t100.cd_empresa) + ' - ' + convert(varchar,t100.nm_fantasia)
					   from empresa t100, mensalidades t200
					   where t100.cd_empresa = t200.CD_ASSOCIADO_empresa
						and t200.TP_ASSOCIADO_EMPRESA = 2
						and t200.CD_PARCELA = Lote_Processos_Bancos_Mensalidades.cd_parcela
						) as cliente, nsu, pagamentoId
					from Lote_Processos_Bancos_Mensalidades 
					where cd_sequencial_lote=@sequencial
					and cd_retorno=0		       
		       end
  				  Open Dados_Cursor_BFI
				  Fetch next from Dados_Cursor_BFI Into @cd_parcela, @dt_credito, @valor, @nrAutorizacao, @cliente, @nsuAdministradora,@pagamentoId
				  While (@@fetch_status  <> -1)
				  Begin
					   --- Gerar o lancamento financeiro no modulo financeiro
					  Insert Into TB_Lancamento (Tipo_Lancamento, Historico, Sequencial_Conta, CD_Dentista,Nome_Outros,nome_usuario,cd_sequencial_lote_retorno,cd_sequencial_lote_envio)
					  values (1, 
							 'Recebimento ' + @nm_tipopag + ', arquivo ' + @nm_arquivo + ', CODAUT: ' + @nrAutorizacao + ' - Crédito : ' + convert(varchar(10),isnull(@dt_credito,@data),103) + ', Cliente: ' + CONVERT(varchar, @cliente) + ', Parcela: ' + CONVERT(varchar, @cd_parcela), 
							 isnull(@SeqConta_pf,@seqconta) , 
							 null , null , @cd_func,case when @envio = 0 then @sequencial else null end , 
							 case when @envio = 0 then null else @sequencial end)
					     
						 select @identify = @@IDENTITY 
						 if @identify is null 
						  Begin
							 Set @erro = 1
							 return 
						  End       
						  
						  if @realizado=0  -- Previsto  
						  begin
							  Insert Into TB_FormaLancamento (Tipo_ContaLancamento, Forma_Lancamento, 
										  Data_Documento, Valor_Previsto,  -- Previsto
										  Data_HoraLancamento, Sequencial_Historico, nome_usuario, Sequencial_Lancamento, DOC, CODAUT,Origem_Cartao,pagamentoId,Data_Efetiva_Cartao) 
								values (2,case when @fl_exige_Dados_cartao=0 then 7 else 9 end,isnull(@dt_credito,@data), @valor , getdate(), -- Previsto 
										(Select max(sequencial_historico) 
										   from TB_HistoricoMovimentacao as h
										  where h.Sequencial_Movimentacao = @seqmov ),
									   7021, 
									   @identify, @nsuAdministradora, @nrAutorizacao , 1,@pagamentoId,case when @dt_credito is null then null else dateadd(month,-1,@dt_credito) end )     
				          
						  End 
						  else
						  Begin 

							  Insert Into TB_FormaLancamento (Tipo_ContaLancamento, Forma_Lancamento, 
										 Data_Documento, Valor_Lancamento, Data_pagamento, Data_Lancamento,
										 Data_HoraLancamento, Sequencial_Historico, nome_usuario, Sequencial_Lancamento, DOC, CODAUT,Origem_Cartao,pagamentoId,Data_Efetiva_Cartao) 
								values (1,case when @fl_exige_Dados_cartao=0 then 7 else 9 end,isnull(@dt_credito,@data), @valor , isnull(@dt_credito,@data), getdate(), getdate(),  -- Realizado
										(Select max(sequencial_historico) 
										   from TB_HistoricoMovimentacao as h
										  where h.Sequencial_Movimentacao = @seqmov ),
									   7021, 
									   @identify, @nsuAdministradora, @nrAutorizacao,1,@pagamentoId,case when @dt_credito is null then null else dateadd(month,-1,@dt_credito) end  )
						  End  
				                  
						  if @@ROWCOUNT <> 1 
						   Begin
							  Set @erro = 1
						   End        
						   
						   
						   Insert Into TB_MensalidadeAssociado 
							 (cd_parcela, tipo_mensalidade_gerada, Sequencial_Lancamento, vl_desconto, nome_usuario, vl_acrescimo) 
							Select 
							   @cd_parcela , 1, @identify, 0, 7021, 0
						   
						   if @@ROWCOUNT <> 1 
						   Begin
							  Set @erro = 1
						   End
						   						   
						    
					Fetch next from Dados_Cursor_BFI Into  @cd_parcela, @dt_credito, @valor, @nrAutorizacao, @cliente, @nsuAdministradora,@pagamentoId
				End
				Close Dados_Cursor_BFI
				Deallocate Dados_Cursor_BFI  
			end

	 if isnull(@Sequencial_conta_taxa,0) > 0 and @envio = 0 -- Incluir Lancamento da taxa 
		begin

		   Set @valor = 0 

			Select @valor = SUM(l.vl_tarifa) 
			  from Lote_Processos_Bancos_Retorno_Mensalidades as l inner join mensalidades as m on l.cd_parcela = m.CD_PARCELA 
			  where l.cd_sequencial_retorno=@sequencial and l.cd_ocorrencia IN (0,31,35)

				--- Gerar o lancamento financeiro no modulo financeiro
				Insert Into TB_Lancamento (Tipo_Lancamento, Historico, Sequencial_Conta, CD_Dentista,Nome_Outros,nome_usuario,cd_sequencial_lote_retorno)
				values (2,'Tarifa bancaria ' + @nm_tipopag + ', arquivo ' + @nm_arquivo , 
						@Sequencial_conta_taxa, null , null , @cd_func,@sequencial)
                   					     
					select @identify = @@IDENTITY 
					if @identify is null 
					Begin
						Set @erro = 1
						return 
					End       
						  
					if @realizado=0  -- Previsto  
					begin
						Insert Into TB_FormaLancamento (Tipo_ContaLancamento, Forma_Lancamento, 
									Data_Documento, Valor_Previsto,  -- Previsto
									Data_HoraLancamento, Sequencial_Historico, nome_usuario, Sequencial_Lancamento) 
						values (2,case when @fl_exige_Dados_cartao=0 then 7 else 9 end,
						        isnull(@dt_credito,@data), 
								@valor , getdate(), -- Previsto 
								(Select max(sequencial_historico) 
									from TB_HistoricoMovimentacao as h
									where h.Sequencial_Movimentacao = @seqmov ),
								7021, 
								@identify )
					End 
					else
					Begin 

						Insert Into TB_FormaLancamento (Tipo_ContaLancamento, Forma_Lancamento, 
									Data_Documento, Valor_Lancamento, Data_pagamento, Data_Lancamento,
									Data_HoraLancamento, Sequencial_Historico, nome_usuario, Sequencial_Lancamento) 
						values (1,case when @fl_exige_Dados_cartao=0 then 7 else 9 end,
						        isnull(@dt_credito,@data), @valor , 
								isnull(@dt_credito,@data), getdate(), getdate(),  -- Realizado
								(Select max(sequencial_historico) 
									from TB_HistoricoMovimentacao as h
									where h.Sequencial_Movimentacao = @seqmov ),
								7021, 
								@identify )                           
					End  
				                  
					if @@ROWCOUNT <> 1 
					Begin
						Set @erro = 1
					End         

		End 			

  End 
  
End
