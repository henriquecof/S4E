/****** Object:  Procedure [dbo].[SP_FechaProcessoBancos_old]    Committed by VersionSQL https://www.versionsql.com ******/

create PROCEDURE [dbo].[SP_FechaProcessoBancos_old] 
	@sequencial INT, @cd_funcionario int 
AS
BEGIN
	/**
		Ticket 6393: Existia um código 117 fixo no lugar de ser usado o código configurado na tabela de DEB_AUTOMATICO_CR
	**/
     Declare	@cd_parcela int , 
				@vl_parcela money , 
				@vl_tarifa money, 
				@dt_prevista_credito date, 
				@cd_tipo_pagamento int , 
				@dt_pago date,
				@vl_multa money, 
				@vl_desconto money, 
				@vl_pago money, 
				@dt_vencimento date, 
				@arquivo varchar(100)

    Select @cd_tipo_pagamento	= cd_tipo_pagamento, 
			@arquivo			= nm_arquivo 
	from Lote_Processos_Bancos 
	where cd_Sequencial			= @sequencial
    
	Begin Transaction
	
	Declare Dados_Cursor_RB  cursor for  
		select	cd_parcela, convert(varchar(10),getdate(),101), vl_parcela, vl_tarifa , dt_credito   
		from	Lote_Processos_Bancos_Mensalidades 
		where	cd_sequencial_lote	= @sequencial 
				and cd_retorno in (0, 31)  
				and cd_parcela not in (select cd_parcelamae from MensalidadesAgrupadas)
  	
	Open Dados_Cursor_RB
	Fetch next from Dados_Cursor_RB Into @cd_parcela,@dt_pago, @vl_parcela , @vl_tarifa, @dt_prevista_credito  
	While (@@fetch_status  <> -1)
		Begin -- 3.1
			print convert(varchar(10),@cd_parcela)
			   
			update MENSALIDADES 
			    set DT_PAGAMENTO=@dt_pago,
			        CD_TIPO_RECEBIMENTO = @cd_tipo_pagamento,
			        VL_PAGO = @vl_parcela,
			        DT_BAIXA=GETDATE(),
			        CD_USUARIO_BAIXA=@cd_funcionario,
			        DT_ALTERACAO=GETDATE(),
			        CD_USUARIO_ALTERACAO=@cd_funcionario,
			        VL_SERVICO=@vl_tarifa  ,
			        vl_multa = 0,
			        vl_desconto_recebimento = 0,  
                    dt_credito = @dt_prevista_credito  
			where cd_parcela = @cd_parcela  
				  and CD_TIPO_RECEBIMENTO=0
			    
			if @@ERROR <> 0 or @@ROWCOUNT = 0 
			    begin -- 3.1.1
			       rollback 
			       
			       update Lote_Processos_Bancos_Mensalidades 
                      set mensagem = 'Erro na BAIXA da Parcela (' + CONVERT(varchar(20),@cd_parcela) +').'
                    where cd_sequencial_lote = @sequencial and cd_parcela = @cd_parcela
              
			       break        
			    end -- 3.1.1

			Fetch next from Dados_Cursor_RB Into @cd_parcela, @dt_pago, @vl_parcela , @vl_tarifa, @dt_prevista_credito  
        End -- 3.1  
    Close Dados_Cursor_RB
    Deallocate Dados_Cursor_RB


	Declare @qtde_l int
	Declare @qtde_c int
	Declare @vl_acu money
	Declare @vl_pg money
	Declare @parcelamae_ant int 
	Declare @parcelamae int 
         
    Set @parcelamae_ant = 0 
          
	Declare Dados_Cursor_RB  cursor for  -- Parcela Agrupada
		select	m.cd_parcela, convert(varchar(10),getdate(),101), 
				m.vl_parcela+ISNULL(m.vl_acrescimo,0)-ISNULL(m.vl_desconto,0)-ISNULL(m.vl_imposto,0)+ISNULL(m.vl_taxa,0)+ISNULL(vl_acrescimoavulso,0) as vl_parcela, 
				round((l.vl_parcela - x.vl)*(m.vl_parcela+ISNULL(m.vl_acrescimo,0)-ISNULL(m.vl_desconto,0)-ISNULL(m.vl_imposto,0)+ISNULL(m.vl_taxa,0)+ISNULL(vl_acrescimoavulso,0)/x.vl)/100,2) as vl_acerto , 
				0 as desconto , 
				convert(float,convert(int,((m.vl_parcela+ISNULL(m.vl_acrescimo,0)-ISNULL(m.vl_desconto,0)-ISNULL(m.vl_imposto,0)+ISNULL(m.vl_taxa,0)+ISNULL(vl_acrescimoavulso,0)) * l.vl_parcela)*100/x.vl))/100 as vl_pago, 
				l.vl_tarifa,  a.cd_parcelaMae, l.dt_credito , x.qtde , l.vl_parcela
		from	Lote_Processos_Bancos_Mensalidades as l , MensalidadesAgrupadas as a, MENSALIDADES as m, 
				(	select a1.cd_parcelaMae, SUM(m1.vl_parcela+isnull(m1.vl_acrescimo,0)-isnull(m1.VL_Desconto,0)-isnull(m1.vl_imposto,0)+ISNULL(m1.vl_taxa,0)+ISNULL(vl_acrescimoavulso,0)) as vl, 
				           COUNT(0) as qtde 
					from Lote_Processos_Bancos_Mensalidades as l1 , MensalidadesAgrupadas as a1, MENSALIDADES as m1
					where	cd_sequencial_lote=@sequencial
							and l1.cd_parcela = a1.cd_parcelaMae 
							and a1.cd_parcela = m1.CD_PARCELA 
							and l1.cd_retorno=0
					group by a1.cd_parcelaMae
				 ) as x
					
		where	cd_sequencial_retorno=@sequencial and 
				l.cd_parcela = a.cd_parcelaMae and 
				a.cd_parcela = m.CD_PARCELA and 
				a.cd_parcelaMae =x.cd_parcelaMae and 
				l.cd_retorno=0

  	Open Dados_Cursor_RB
	Fetch next from Dados_Cursor_RB Into @cd_parcela, @dt_pago, @vl_parcela , @vl_multa, @vl_desconto, @vl_pago , @vl_tarifa,@parcelamae, @dt_prevista_credito , @qtde_c, @vl_pg
	While (@@fetch_status  <> -1)
		Begin -- 3.1
			print convert(varchar(10),@cd_parcela)
			   
			Set @qtde_l = @qtde_l + 1 
			if @parcelamae_ant <> @parcelamae -- Zerar os campos 
			   begin
			      --Set @vl_pago = @vl_pago + isnull(@vl_multa,0)
			      Set @qtde_l = 1 
                  Set @vl_acu = 0
			   End
			   
			Set @vl_acu = @vl_acu + @vl_pago 
			if @qtde_l = @qtde_c and @vl_acu <> @vl_pg -- @vl_pg = valor pago no titulo agrupado
			   begin 
			      Set @vl_pago = @vl_pago + (@vl_pg - @vl_acu)
			   End 

			   
			update	MENSALIDADES 
			   set	DT_PAGAMENTO=@dt_pago,
			        CD_TIPO_RECEBIMENTO = @cd_tipo_pagamento ,
			        VL_PAGO = @vl_pago,
			        DT_BAIXA=GETDATE(),
			        CD_USUARIO_BAIXA=@cd_funcionario,
			        DT_ALTERACAO=GETDATE(),
			        CD_USUARIO_ALTERACAO=@cd_funcionario,
			        VL_SERVICO= case when @parcelamae_ant = @parcelamae then 0 else @vl_tarifa end ,
			        vl_multa = case when @vl_pago > @vl_parcela then @vl_pago - @vl_parcela else 0 end,
			        vl_desconto_recebimento = case when @vl_pago < @vl_parcela then @vl_parcela - @vl_pago else 0 end,
			        dt_credito = @dt_prevista_credito
			where	cd_parcela = @cd_parcela 
					and CD_TIPO_RECEBIMENTO=0
			if @@ERROR <> 0 or @@ROWCOUNT = 0 
			    begin -- 3.1.1
			       rollback 
			       
			       update Lote_Processos_Bancos_Mensalidades 
                      set mensagem = 'Erro na BAIXA da Parcela (' + CONVERT(varchar(20),@cd_parcela) +').'
                    where cd_sequencial_lote = @sequencial  and cd_parcela = @cd_parcela
              
			       break        
			    end -- 3.1.1

			Set @parcelamae_ant = @parcelamae
			    
    Fetch next from Dados_Cursor_RB Into @cd_parcela, @dt_pago, @vl_parcela , @vl_multa, @vl_desconto, @vl_pago , @vl_tarifa,@parcelamae,@dt_prevista_credito , @qtde_c, @vl_pg
    End -- 3.1  
    Close Dados_Cursor_RB
    Deallocate Dados_Cursor_RB -- Fim Parcela Agrupada            

    --- Limpar informacoes de Titulos nao debitados para envio ao banco
    Declare @situacao int 
    Declare @FL_GeraCrm int 
    Declare @fl_limpaEnvio int 
    Declare @fl_BaixaRetorno int
    declare @WL_cd_empresa int 

    Declare @WL_dsOcorrencia varchar(100)
    declare @WL_cd_dependente int 
    Declare @WL_data varchar(10)
    Declare @WL_hora varchar(10)
    Declare @WL_UsuarioSYS int = 7021
    Declare @WL_protocolo varchar(20)
    Declare @WL_chave varchar(20)
    Declare @WL_chaId int 
          
	Declare Dados_Cursor_RB  cursor for  
		select m.cd_parcela, m.dt_vencimento , upper(d.nm_ocorrencia), d.cd_situacao , d.FL_GeraCrm, d.fl_limpaEnvio, d.fl_BaixaRetorno
        from Lote_Processos_Bancos_Mensalidades as m , DEB_AUTOMATICO_CR as d
        where m.cd_sequencial_lote=@sequencial and 
              m.cd_retorno = d.cd_ocorrencia and 
                 -- m.cd_ocorrencia > 0 and 
              (isnull(d.FL_GeraCrm,0)+isnull(d.fl_limpaEnvio,0)+isnull(d.fl_BaixaRetorno,0))>0
  	Open Dados_Cursor_RB
	Fetch next from Dados_Cursor_RB Into @cd_parcela, @dt_vencimento, @WL_dsOcorrencia , @situacao, @FL_GeraCrm,@fl_limpaEnvio,@fl_BaixaRetorno
	While (@@fetch_status  <> -1)
		Begin -- 3.1
			print @cd_parcela
            
			if isnull(@fl_limpaEnvio,0)>0 
			   begin 
				   update MENSALIDADES 
					  set cd_lote_processo_banco = null, 
						  DT_ALTERACAO=GETDATE(),
						  CD_USUARIO_ALTERACAO=@cd_funcionario
					where cd_parcela = @cd_parcela 
					if @@ERROR <> 0 
						begin -- 3.1.1
							rollback 
				       
							update Lote_Processos_Bancos_Mensalidades 
							set mensagem = 'Erro na Liberação da Parcela (' + CONVERT(varchar(20),@cd_parcela) +').'
							where cd_sequencial_lote = @sequencial  and cd_parcela = @cd_parcela
	              
							break        
						end -- 3.1.1
			    End  
			    
			if isnull(@fl_BaixaRetorno,0)>0 
			   begin 
				   update MENSALIDADES 
					  set cd_lote_processo_banco_baixa = @sequencial, 
						  executarTrigger=0
					where cd_parcela = @cd_parcela 
					if @@ERROR <> 0 
						begin -- 3.1.1
							rollback 
				       
							update Lote_Processos_Bancos_Mensalidades 
							set mensagem = 'Erro no registro de Baixa da Parcela (' + CONVERT(varchar(20),@cd_parcela) +').'
							where cd_sequencial_retorno = @sequencial  and cd_parcela = @cd_parcela
	              
							break        
						end -- 3.1.1
			   End		
			   
			   set  @WL_cd_dependente = 0	
			   			  
			    --***********************			    
			    --****** Gerar CRM ******
			    --***********************
			   if isnull(@FL_GeraCrm,0)>0
			   begin			    
					
					set	 @WL_data = convert(varchar(20),getdate(), 112)
					set	 @WL_hora = replace(convert(varchar(12),getdate(), 114), ':','')
					set	 @WL_protocolo = replace(convert(varchar(12),getdate(), 12), ':','') + replace(convert(varchar(8),getdate(), 114), ':','') + convert(varchar,@WL_UsuarioSYS)
					set	 @WL_chave = convert(varchar(20),getdate(), 112)+ replace(convert(varchar(12),getdate(), 114), ':','')+ convert(varchar,@WL_UsuarioSYS) + replace(rand(),'.','')--convert(varchar(10),rand())

					---	Buscar Dependente
					select	@WL_cd_dependente = d.cd_sequencial 
					from mensalidades m, associados a, dependentes d
					where m.CD_ASSOCIADO_empresa = a.cd_associado
					  and a.cd_associado = d.cd_associado 
 					  and d.CD_GRAU_PARENTESCO = 1
					  and m.cd_parcela = @cd_parcela

					---Buscar chaId
					select @WL_chaId = max(chaId) from CRMChamado
					print 'ChaID = ' + convert(varchar(10),@WL_chaId)
					  
  
					if @WL_cd_dependente != 0 
						Begin
						   ---Insert Chamado
							INSERT INTO CRMChamado
							   ( tsoId, chaSolicitante, mdeId, chaDtCadastro, chaRespostaEmail
							   , chaRespostaSMS, chaChave, TipoUsuario, Usuario, UsuarioResponsavel
							   , sitId, chaProtocolo, chaDtFechamento, tinId
							   , chaDtPrevisaoSolucao, chaEmailResposta, chaTelefoneResposta, iadId)
							VALUES
							   ( 2, @WL_cd_dependente, @FL_GeraCrm
							   , getdate(), 0, 0, @WL_chave
							   , 3, @WL_UsuarioSYS, @WL_UsuarioSYS
							   , 3, @WL_protocolo, getdate(), 2
							   , getdate(), NULL, NULL, NULL)

						select @WL_chaId = max(chaId) from CRMChamado
					 ---LOG Insert
						   INSERT INTO  CRMChamadoLog
							   ( chaId, cloDtCadastro, tloId
							   , TipoUsuario, Usuario,UsuarioNovoResponsavel)
						   VALUES
							   ( @WL_chaId, getdate(), 1
							   , 3, @WL_UsuarioSYS, @WL_UsuarioSYS)

					 ---LOG Fechamento, se observação 
						 INSERT INTO  CRMChamadoLog
							   ( chaId, cloDtCadastro, tloId
							   , TipoUsuario, Usuario)
						 VALUES
							   ( @WL_chaId, getdate(), 5
							   , 3, @WL_UsuarioSYS)				             
				                  
					---Ocorrencia
					set @WL_dsOcorrencia = 'CONFORME ARQUIVO DE RETORNO ' +  convert(varchar(50),@arquivo) + ' PROCESSADO EM ' +  convert(varchar(10),GETDATE(),103) + ', PARCELA DE VENC. ' + convert(varchar(10),@dt_Vencimento, 103) + ', O DEBITO NAO FOI EFETUADO: ' + convert(varchar(50),@WL_dsOcorrencia)  + '.'
					INSERT INTO  CRMChamadoOcorrencia 
							   ( chaId, cocDescricao, cocDtCadastro 
							   , TipoUsuario, Usuario )
						 VALUES
							   (@WL_chaId, @WL_dsOcorrencia ---@linha 
							   ,getdate(),1, @WL_UsuarioSYS)
						End
					else
						Begin
						   print 'Erro CRM: Dependente nao encontrado'
						End
				   			   
					--*******************
					--***** FIM CRM *****
					--*******************
			    End
			    
			    -- Modificar o Status
			    if @situacao is not null and @WL_cd_dependente > 0	 
			    begin 
			      insert HISTORICO (CD_SEQUENCIAL_dep, CD_SITUACAO,DT_SITUACAO)
			      values (@WL_cd_dependente,@situacao,GETDATE())
			    End
			    -- FIm Modificar o Status
			    
		        Fetch next from Dados_Cursor_RB Into @cd_parcela, @dt_vencimento, @WL_dsOcorrencia , @situacao, @FL_GeraCrm,@fl_limpaEnvio,@fl_BaixaRetorno
            End -- 3.1  
            Close Dados_Cursor_RB
            Deallocate Dados_Cursor_RB
            
              
              --- Gerar o lancamento financeiro no modulo financeiro
              exec SP_EnviaCreditoBanco_Financeiro @sequencial, '', '' , 1 -- Envio
                               
               --- Gerar a tarifa bancaria no financeiro
               
		       update Lote_Processos_Bancos
                  set dt_finalizado = getdate()
                where cd_sequencial = @sequencial
                
               Commit                               

END
