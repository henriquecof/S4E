/****** Object:  Procedure [dbo].[SP_TranferirCredito]    Committed by VersionSQL https://www.versionsql.com ******/

Create PROCEDURE [dbo].[SP_TranferirCredito]
	@cd_orcamento_origem int, 
	@cd_orcamento_destino int,
	@valorTransf as money,
	@CodigoUsuario int
AS
BEGIN
	Declare @erro int 
	Declare @CD_ASSOCIADO_empresa_origem int
	Declare @CD_Filial_origem int
	Declare @CD_Dependente_origem int
	Declare @CD_ASSOCIADO_empresa_destino int
	Declare @CD_Dependente_destino int
	Declare @CD_ConsultaTransf int
	Declare @cdparcela int
	declare @Data as varchar(20)
	
	SELECT @CD_ASSOCIADO_empresa_origem = cd_associado, @CD_Dependente_origem = cd_sequencial_dep, @CD_Filial_origem = cd_filial      
	FROM orcamento_clinico
	where cd_orcamento = @cd_orcamento_origem
	
	SELECT @CD_ASSOCIADO_empresa_destino = cd_associado, @CD_Dependente_destino = cd_sequencial_dep      
	FROM orcamento_clinico
	where cd_orcamento = @cd_orcamento_destino
	
	select @Data = getdate()
	
	
	print 'Associado Origen'
	print @CD_ASSOCIADO_empresa_origem
	print 'Dep Origem'
	print @CD_Dependente_origem
	print 'Associado Destino'
	print @CD_ASSOCIADO_empresa_destino
	print 'Dep Destino'
	print @CD_Dependente_destino
	print 'Filial'
	print @CD_Filial_origem
	
	
	-----------Orçamento de Origem----------------
	--Inserir Procedimento
	Begin Transaction
		insert into Consultas 
		( cd_sequencial, cd_sequencial_dep, dt_servico, dt_baixa, dt_pericia, cd_servico, oclusal, distral, mesial, vestibular, lingual, cd_filial, cd_sequencial_agenda, nr_procedimentoliberado, usuario_baixa, usuario_cadastro, cd_funcionario_analise, cd_sequencial_Exame, status )
		select isnull(max(cd_sequencial),0) + 1, 
		@CD_Dependente_origem, 
		getdate(), 
		getdate(), 
		getdate(), 
		99999999,  
		0, 0, 0, 0, 0, 
		@CD_Filial_origem,
		null,
		1, 
		@CodigoUsuario,
		@CodigoUsuario,
		@CodigoUsuario,
		null,
		3
		from Consultas;
	
	if @@ERROR <> 0 
	begin -- 3.1.1
		print '--- erro ao inserir procedimento na consulta'
		set @erro=1	
		rollback
		return	
	end
	
	else
	begin
		Commit
	end
	
	--Recupera ID da consulta
	select @CD_ConsultaTransf = max(cd_sequencial) from Consultas where cd_sequencial_dep = @CD_Dependente_origem and cd_servico = 99999999 ;
	print 'consulta'
	print @CD_ConsultaTransf
	
	
	--Inserir procediemnto/consulta no orçamento
	Begin Transaction
		Insert into orcamento_servico 
		(cd_sequencial_pp,cd_orcamento,vl_servico,vl_servicoFechadoOrcamento,fl_pp) 
		values(@CD_ConsultaTransf, @cd_orcamento_origem, @valorTransf, @valorTransf,1);
	
	if @@ERROR <> 0 
	begin -- 3.1.1
		print '--- erro ao inserir procedimento no orçamento'
		set @erro=1	
		rollback
		return	
	end
	
	else
	begin
		Commit
	end
	
	----------------------------------------------




	-------Orçamento de Destino----------------------
	--Gera parcela no detino
	EXEC SP_GeraMensalidade_Avulsa @CD_ASSOCIADO_empresa_destino, @CD_Dependente_destino, @Data, 175, 4, @valorTransf, -1, '';

	--Recupera parcela gerada
	select @cdparcela = max(cd_parcela) from MENSALIDADES where CD_ASSOCIADO_empresa = @CD_ASSOCIADO_empresa_destino and CD_TIPO_PAGAMENTO = 175 and cd_tipo_parcela = 4;
	if @cdparcela = 0 
	begin -- 3.1.1
		print '--- erro ao recuperar parcela'
		set @erro=1		
	end
	print'Cd_parcela'
	print @cdparcela

	--Insere parcela no orçamento
	Begin Transaction
		Insert Orcamento_Mensalidades 
		(cd_orcamento,cd_associado_empresa,cd_parcela,vl_parcela,dt_vencimento,fl_incorpora,cd_tipo_pagamento,fl_taxa) 
		values (
		@cd_orcamento_destino, @CD_ASSOCIADO_empresa_destino,@cdparcela ,
		@valorTransf, getdate(), 0, 7, 0);
	
	if @@ERROR <> 0 
	begin -- 3.1.1
		print '--- erro ao inserir parcela no orçamento'
		set @erro=1	
		rollback
		return	
	end
	
	else
	begin
		Commit
	end
	
	--Baixa Parcela
	UPDATE MENSALIDADES
	   SET CD_TIPO_RECEBIMENTO = 175
		  ,DT_PAGAMENTO = getdate()
		  ,DT_BAIXA = getdate()
		  ,DT_ALTERACAO = getdate()
		  ,VL_PAGO = @valorTransf
		  ,CD_USUARIO_BAIXA = @CodigoUsuario
		  ,CD_USUARIO_ALTERACAO = @CodigoUsuario  
	   where cd_parcela = @cdparcela;
	
	if @@ERROR <> 0 
	begin -- 3.1.1
		print '--- erro baixa da parcela'
		set @erro=1		
	end
	----------------------------------------------
	
END
