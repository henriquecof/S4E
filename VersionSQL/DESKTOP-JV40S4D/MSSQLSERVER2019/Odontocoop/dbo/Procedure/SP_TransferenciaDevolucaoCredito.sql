/****** Object:  Procedure [dbo].[SP_TransferenciaDevolucaoCredito]    Committed by VersionSQL https://www.versionsql.com ******/

Create PROCEDURE [dbo].[SP_TransferenciaDevolucaoCredito]
	@Usuario_origem int, ---66895 Manutenção    105516  orçamento
	@cd_parcela_origem int,
	@cd_orcamento_origem int, 
	@Usuario_destino int,
	@cd_parcela_destino int,
	@cd_orcamento_destino int,
	@valorTransf as money,
	@Movimentacao int,
	@Centro_Custo int,
	@CodigoUsuarioTransacao int
AS
BEGIN
	Declare @conta_origem int
	Declare @conta_destino int
	Declare @HistoricoPagamento varchar(1500)
	Declare @HistoricoRecebimento varchar(1500)
	Declare @erro smallint
	declare @TipoConta int
	declare @DescricaoConta varchar(100)
	declare @TipoTransacao smallint
	Declare @CD_ASSOCIADO_origem int
	Declare @NM_ASSOCIADO_origem varchar(300)
	Declare @CD_Filial_origem int
	Declare @OBSconsulta varchar(1000)
	Declare @ConsultaInsert int
	Declare @Associado_Origem int
	Declare @Associado_Destino int
	Declare @Sequencial_Lancamento int
	declare @Data as varchar(20)
	Declare @cdparcela int
	Declare @HistoricoMovimentacao int
	
	set @erro = 0
	set @CD_Filial_origem = 0
	select @Data = getdate()
	
	select @HistoricoMovimentacao = Sequencial_Historico from TB_HistoricoMovimentacao where sequencial_movimentacao = @Movimentacao and Data_Fechamento is null
 
	if @cd_parcela_destino = 0 and @cd_orcamento_destino = 0
		begin
			set @TipoTransacao = 1 --Devoluçao
		end
	else
		begin
			set @TipoTransacao = 2 --Transferencia
		end
	
	
	if @cd_parcela_origem > 0 
		begin
			Select @CD_Filial_origem = Isnull(cd_clinica,0), @Associado_Origem = CD_ASSOCIADO From DEPENDENTES WHERE CD_SEQUENCIAL = @Usuario_origem			
			Set @OBSconsulta = 'TRANSFERIDO PARA PARCELA DE MANUTENÇÃO: ' + convert(varchar(50),@cd_parcela_origem)
		end
	else if @cd_orcamento_origem > 0
		begin
			Select @CD_Filial_origem = Isnull(cd_filial,0), @Associado_Origem = CD_ASSOCIADO from orcamento_clinico where cd_orcamento = @cd_orcamento_origem
			Set @OBSconsulta = 'TRANSFERIDO PARA ORÇAMENTO: ' + convert(varchar(50),@cd_orcamento_destino)
		end
	
		
	if @CD_Filial_origem = 0
	begin 
		Raiserror('Erro ao localizar filial.',16,1)
		RETURN	
	end
			
	 if @Usuario_destino> 0
	 begin
		Select @Associado_Destino = CD_ASSOCIADO From DEPENDENTES WHERE CD_SEQUENCIAL = @Usuario_destino		
	 end
	 
	
	
	Begin Transaction
		
	-----conta saida----------------------------------------------------------------
	set @TipoConta = 2
	if @TipoTransacao = 1
		begin
			set @DescricaoConta= 'ESTORNO DE LAN%AMENTO - SA%DA'
		end
	else
		begin
			set @DescricaoConta= 'Transfer%ncia de Cr%dito entre Clientes - Sa%da'
		end


	Select @conta_origem = isnull(t1.Sequencial_Conta,0)
	From TB_Conta t1, centro_custo T2, TB_ContaMae T3
	Where t1.cd_centro_custo = t2.cd_centro_custo And 
	t1.Sequencial_ContaMae = t3.Sequencial_ContaMae And 
	t3.Tipo_Conta = @TipoConta  And 
	t1.Descricao_Conta like @DescricaoConta And 
	t2.CD_centro_custo = @Centro_Custo And 
	t1.Conta_Valida = 1 And 
	t1.Gera_Lancamento = 1 
				
	if @@ERROR <> 0 or isnull(@conta_origem,0) = 0
	begin -- 3.1.1
		RollBack Transaction
		Raiserror('Erro ao localizar conta de origem.',16,1)
		RETURN	
	end	
	--------------------------------------------------------------------------------------
	
	
	if @TipoTransacao = 2 -- Transferencia
	begin
		-----conta entrada----------------------------------------------------------------
		set @TipoConta = 1
		set @DescricaoConta = 'Transfer%ncia de Cr%dito entre Clientes - Entrada'

		Select @conta_destino = isnull(t1.Sequencial_Conta,0)
		From TB_Conta t1, centro_custo T2, TB_ContaMae T3
		Where t1.cd_centro_custo = t2.cd_centro_custo And 
		t1.Sequencial_ContaMae = t3.Sequencial_ContaMae And 
		t3.Tipo_Conta = @TipoConta  And 
		t1.Descricao_Conta like @DescricaoConta And 
		t2.CD_centro_custo = @Centro_Custo And 
		t1.Conta_Valida = 1 And 
		t1.Gera_Lancamento = 1 
			
		if @@ERROR <> 0 or isnull(@conta_destino,0) = 0
		begin -- 3.1.1
			RollBack Transaction
			Raiserror('Erro ao localizar conta de destino.',16,1)
			RETURN	
		end	
		--------------------------------------------------------------------------------------
		
		------HISTORICO-----------------------------------------------------------------------
		Select @HistoricoPagamento = upper('Movimento de saída de valor em transferência de crédito entre clientes, (' + convert(varchar(10),cd_associado)+ ') ' + nm_dependente + '.')
		From Dependentes
		where cd_sequencial = @Usuario_origem
		
		if @@ERROR <> 0 
		begin -- 3.1.1
			RollBack Transaction
			Raiserror('Erro ao localizar associado de origem.',16,1)
			RETURN	
		end
				
		Select @HistoricoRecebimento = upper('Movimento de entrada de valor em transferência de crédito entre clientes, (' + convert(varchar(10),cd_associado)+ ') ' + nm_dependente + '.')
		From Dependentes
		where cd_sequencial = @Usuario_destino
		
		if @@ERROR <> 0 
		begin -- 3.1.1
			RollBack Transaction
			Raiserror('Erro ao localizar associado de origem.',16,1)
			RETURN	
		end
		--------------------------------------------------------------------------------------
	end
	
	else
	begin
		------HISTORICO-----------------------------------------------------------------------
		Select @HistoricoPagamento = upper('Movimento de saída de valor em devolução de crédito, (' + convert(varchar(10),cd_associado)+ ') ' + nm_dependente + '.')
		From Dependentes
		where cd_sequencial = @Usuario_origem
		
		if @@ERROR <> 0 
		begin -- 3.1.1
			RollBack Transaction
			Raiserror('Erro ao localizar associado de origem.',16,1)
			RETURN	
		end
		--------------------------------------------------------------------------------------
	end
	
	
	
	----------------Origem--------------------------------------------------------------------
	--Inserir Procedimento----------
	Select @ConsultaInsert = isnull(max(cd_sequencial),0) + 1 from Consultas
	
	insert into Consultas 
	(cd_sequencial, cd_sequencial_dep, dt_servico, dt_baixa, dt_pericia, cd_servico, oclusal, distral, mesial, vestibular, lingual, cd_filial, cd_sequencial_agenda, nr_procedimentoliberado, usuario_baixa, usuario_cadastro, cd_funcionario_analise, cd_sequencial_Exame, status, ds_informacao_complementar)
		select @ConsultaInsert, 
		@Usuario_origem, 
		getdate(), 
		getdate(), 
		getdate(), 
		99999999,  
		0, 0, 0, 0, 0, 
		@CD_Filial_origem,
		null,
		1, 
		@CodigoUsuarioTransacao,
		@CodigoUsuarioTransacao,
		@CodigoUsuarioTransacao,
		null,
		3,
		@OBSconsulta
		
	
	if @@ERROR <> 0 
	begin 
		RollBack Transaction
		Raiserror('Erro ao inserir procedimento na consulta - Origem.',16,1)
		RETURN
	end
	-------------------------------------
	
	----Orcamento_servico----------------
	if @cd_orcamento_origem > 0
	begin
		Insert into orcamento_servico 
		(cd_sequencial_pp,cd_orcamento,vl_servico,vl_servicoFechadoOrcamento,fl_pp) 
		values(@ConsultaInsert, @cd_orcamento_origem, @valorTransf, @valorTransf,1)
	end
	if @@ERROR <> 0 
	begin 
		RollBack Transaction
		Raiserror('Erro ao inserir procedimento no orçamento - Origem.',16,1)
		RETURN
	end
	--------------------------------------
	
	-----Lançamento-----------------------
	Insert Into TB_Lancamento (Tipo_Lancamento, Historico, Sequencial_Conta,  
								   CD_Associado, CD_Sequencial,                             
								   nome_usuario,cd_funcionario_lancamento)
	Select 
		2, @HistoricoPagamento, @conta_origem,
		@Associado_Origem, @Usuario_origem,
		nm_empregado, @CodigoUsuarioTransacao
	From FUNCIONARIO where cd_funcionario = @CodigoUsuarioTransacao
	
	if @@ERROR <> 0 
	begin 
		RollBack Transaction
		Raiserror('Erro ao inserir Lançamento - Origem.',16,1)
		RETURN
	end
	--------------------------------------
	
	
	-----Forma Lançamento-----------------
	set @Sequencial_Lancamento = @@IDENTITY
	Insert Into TB_FormaLancamento (Tipo_ContaLancamento, Forma_Lancamento, 
             Data_Lancamento, Data_Documento, Data_Pagamento, Valor_Lancamento,
             Data_HoraLancamento, Sequencial_Historico,
             nome_usuario, Sequencial_Lancamento, fl_AlteraValorPrev) 
		Select 
		1, 175,
		getdate(), getdate(), getdate(), @valorTransf,
		getdate(), @HistoricoMovimentacao,
		@CodigoUsuarioTransacao, @Sequencial_Lancamento, 0
		
	
	if @@ERROR <> 0 
	begin 
		RollBack Transaction
		Raiserror('Erro ao inserir Forma de Lançamento.',16,1)
		RETURN
	end
	--------------------------------------
	
	------------------------------------------------------------------------------------
	
	
	if @TipoTransacao = 2 -- Transferencia
	Begin
		print 'Tranferencia - Destino'
		if  @cd_orcamento_destino > 0
		begin
			--Gera parcela no detino
			--EXEC SP_GeraMensalidade_Avulsa @Associado_Destino, @Usuario_destino,  @Data, 175, 4, @valorTransf, -1, '';
			insert mensalidades (CD_ASSOCIADO_empresa,TP_ASSOCIADO_EMPRESA,cd_tipo_parcela, CD_TIPO_PAGAMENTO,CD_TIPO_RECEBIMENTO,DT_VENCIMENTO,DT_GERADO, VL_PARCELA, VL_Acrescimo,VL_Desconto)
			values (@Associado_Destino, 1 , 4 , 175, 0 , @Data , @Data, @valorTransf,0,0)
			
			
			--Recupera parcela gerada
			select @cdparcela = @@IDENTITY--isnull(max(cd_parcela),0) from MENSALIDADES where CD_ASSOCIADO_empresa = @Associado_Destino and CD_TIPO_PAGAMENTO = 175 and cd_tipo_parcela = 4;
			if @cdparcela = 0 
			begin
				RollBack Transaction
				Raiserror('Erro ao inserir Mensalidade - Destino.',16,1)
				RETURN
			end
			
			Insert Orcamento_Mensalidades 
			(cd_orcamento,cd_associado_empresa,cd_parcela,vl_parcela,dt_vencimento,fl_incorpora,cd_tipo_pagamento,fl_taxa) 
			values (
			@cd_orcamento_destino, @Associado_Destino,@cdparcela ,
			@valorTransf, @Data, 0, 175, 0);
				
			if @@ERROR <> 0 
			begin 
				RollBack Transaction
				Raiserror('Erro ao inserir a parcela no orçamento destino.',16,1)
				RETURN
			end
			
		end
		
		else
		begin
			set @cdparcela = @cd_parcela_destino
		end
		
		
		--Baixa Parcela
		UPDATE MENSALIDADES
		   SET CD_TIPO_RECEBIMENTO = 175
			  ,DT_PAGAMENTO = getdate()
			  ,DT_BAIXA = getdate()
			  ,DT_ALTERACAO = getdate()
			  ,VL_PAGO = @valorTransf
			  ,CD_USUARIO_BAIXA = @CodigoUsuarioTransacao
			  ,CD_USUARIO_ALTERACAO = @CodigoUsuarioTransacao  
		   where cd_parcela = @cdparcela
		
		if @@ERROR <> 0 
		begin -- 3.1.1
			RollBack Transaction
			Raiserror('Erro na baixa da parcela - destino.',16,1)
			RETURN
		end
		
		
		
		
		
		-----Lançamento-----------------------
		Insert Into TB_Lancamento (Tipo_Lancamento, Historico, Sequencial_Conta,  
								   CD_Associado, CD_Sequencial,                             
								   nome_usuario,cd_funcionario_lancamento)
		Select 
		1, @HistoricoRecebimento, @conta_destino,
		@Associado_Destino, @Usuario_destino,
		nm_empregado, @CodigoUsuarioTransacao
		From FUNCIONARIO where cd_funcionario = @CodigoUsuarioTransacao
		
		if @@ERROR <> 0 
		begin 
			RollBack Transaction
			Raiserror('Erro ao inserir Lançamento - Destino.',16,1)
			RETURN
		end
		--------------------------------------
		
		-----Forma Lançamento-----------------
		set @Sequencial_Lancamento = @@IDENTITY
		Insert Into TB_FormaLancamento (Tipo_ContaLancamento, Forma_Lancamento, 
					 Data_Lancamento, Data_Documento, Data_Pagamento, Valor_Lancamento,
					 Data_HoraLancamento, Sequencial_Historico,
					 nome_usuario, Sequencial_Lancamento, fl_AlteraValorPrev) 
		Select 
		1, 175,
		getdate(), getdate(), getdate(), @valorTransf,
		getdate(), @HistoricoMovimentacao,
		@CodigoUsuarioTransacao, @Sequencial_Lancamento, 0
	
		if @@ERROR <> 0 
		begin 
			RollBack Transaction
			Raiserror('Erro ao inserir Forma de Lançamento - Destino.',16,1)
			RETURN
		end
		--------------------------------------
		
		-----Mensalidade Associado-----------------
		Insert Into TB_MensalidadeAssociado 
		 (cd_parcela, tipo_mensalidade_gerada, Sequencial_Lancamento, vl_desconto, nome_usuario, vl_acrescimo) 
		Select 
		   @cdparcela , 1, @Sequencial_Lancamento, 0, @CodigoUsuarioTransacao, 0
		
		if @@ERROR <> 0 
		begin 
			RollBack Transaction
			Raiserror('Erro ao inserir Mensalidade Associado - Destino.',16,1)
			RETURN
		end
		--------------------------------------
	end
		
		if @erro = 1
		Begin
	  
			RollBack Transaction
			Raiserror('Pasta dos Arquivos não definida.',16,1)
			RETURN
		End
		
	Commit
	
	print 'Teste'
END
