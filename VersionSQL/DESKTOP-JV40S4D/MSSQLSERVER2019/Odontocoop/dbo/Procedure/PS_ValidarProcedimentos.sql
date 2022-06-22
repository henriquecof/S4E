/****** Object:  Procedure [dbo].[PS_ValidarProcedimentos]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[PS_ValidarProcedimentos]
--------------------------------------------------------------------------------
-- REGRAS DE NEGOCIO DOS PROCEDIMENTOS
--------------------------------------------------------------------------------
	(
		@CD_Sequencial_Dep int,
		@CD_Servico Int,
		@CD_Funcionario Int,
		@CD_UD Nvarchar(100),
		@Mesial int,
		@Oclusal int,
		@Vestibular int,
		@Lingual int,
		@Distal int,
		@DT_Servico DateTime,
		@ChavePrimaria Int,
		@Filial Int,
		@Status Smallint,
		@Operacao smallint, -- 1 - Temp, 3 - Consultas
		@FinalTransacao int output, --1 - commit 2 - rollback 3 - commit gravando inconsistencia 4 - rollback gravando inconsistencia
		@DS_Mensagem varchar(max) output,
		@regiao int = null,
		@Acao smallint = 0 -- 1 - Inclusão
	)
AS
	Begin
  
		/*
		Tabela com todos os dentes e seus respectivos tipos 
		
		TABLE: Tipo_Dente
		1 - DentesAnteriores
		2 - DentesPosteriores
		3-  DentesAdulto
		4 - DentesLeite
		5 - ArcadaAdultoSuperiorEsquerdo
		6 - ArcadaAdultoSuperiorDireito
		7 - ArcadaAdultoInferiorEsquerdo
		8 - ArcadaAdultoInferiorDireito
		
		DentesAnteriores             = '13,12,11,23,22,21,43,42,41,33,32,31,53,52,51,63,62,61,73,72,71,83,82,81'
		DentesPosteriores            = '18,17,16,15,14,28,27,26,25,24,38,37,36,35,34,48,47,46,45,44,55,54,65,64,75,74,84,85'
		DentesAdulto                 = '11,12,13,14,15,16,17,18,21,22,23,24,25,26,27,28,48,47,46,45,44,43,42,41,31,32,33,34,35,36,37,38'
		DentesLeite                  = '55,54,53,52,51,85,84,83,82,81,61,62,63,64,65,71,72,73,74,75'
		ArcadaAdultoSuperiorEsquerdo = '18,17,16,15,14,13,12,11'
		ArcadaAdultoSuperiorDireito  = '21,22,23,24,25,26,27,28'
		ArcadaAdultoInferiorEsquerdo = '48,47,46,45,44,43,42,41'
		ArcadaAdultoInferiorDireito  = '31,32,33,34,35,36,37,38'    
		
		Tipos de procedimentos
		Pode ser:
		1 - Interno
		2 - Credenciado
		3 - Particular
		4 - Ortodontico
		5 - Inativo
		
		Status Tabela Consulta (Referência: Consultas_Status): 
		1  - procedimento antes do plano - Não executa regras.                       
		2  - procedimento pendente - dt_servico is null - Executa regras. 
		3  - procedimento executado - dt_servico is not null - Executa regras.
		4  - procedimento cancelado - dt_cancelamento e motivo_cancelamento - Não executa regras.
		5  - procedimento inconsistente - Não executa regras.
		6  - procedimento liberado - Não executa regras.
		7  - procedimento glosado - Não executa regras.
		8  - dente hígido ou ausente - Não executa regras.
		9  - recurso de glosa autorizado - Não executa regras.
		10 - procedimento expirado - Não executa regras.
		
		Demais Informações:
		Procedimento Glosado            -> Tabela TB_ConsultasGlosados
		Procedimento exige documentacao -> Tabela TB_ConsultasDocumentacao
		procedimento inconsistente      -> Tabela Inconsistencia_Consulta
		*/

		--Valores DEFAULT, caso não entre em nenhuma situação de erro.
		Set @DS_Mensagem = ''
		Set @FinalTransacao = 0
		Set @ChavePrimaria = isnull(@ChavePrimaria,0)
		
		Declare @CD_Associado Int
		Declare @CD_Empresa Int
		Declare @WL_Idade SmallInt
		Declare @TP_Procedimento SmallInt
		Declare @DT_Atual DateTime
		Declare @NR_Quantidade Int
		Declare @CD_Plano Int
		Declare @CD_Orcamento Int
		Declare @CD_EntreiProcEspec Smallint = 0 
		Declare @QuantidaRevisao Int
		Declare @Dt_ProcedimentoBanco DateTime
		Declare @dt_assinaturaContrato datetime
		Declare @CombinacaoFaces Varchar(200)
		Declare @FacesTeste Varchar(200)
		Declare @FacesEntradaAux varchar(30)
		Declare @FacesEntrada varchar(30)
		Declare @OclusalAux smallint
		Declare @DistalAux smallint 
		Declare @MesialAux smallint
		Declare @VestibularAux smallint
		Declare @LingualAux smallint
		Declare @QT_Meses Smallint
		Declare @IdadeAux Smallint
		Declare @IdadeAux2 Smallint
		Declare @CD_Dado1_Cursor varchar(max)
		Declare @CD_Dado2_Cursor varchar(max)
		Declare @CD_Dado3_Cursor int
		Declare @CD_Dado4_Cursor int   
		Declare @planoortodontico smallint 
		Declare @tp_empresa smallint = 99
		Declare @cd_especialidade_ref int 
		Declare @cd_centro_custo smallint
		Declare @LicencaS4E varchar(50)
		Declare @tipoChecagemInconsistencia tinyint
		Declare @mensagemAmigavel varchar(max)
		Declare @regras varchar(max)
		Declare @mensagemRegra30 varchar(max)
		Declare @CNPJClinica varchar(14)

		set @regras = ''

		--Dados Iniciais
		--tipoChecagemInconsistencia >> 1: Diagnóstico e Execução, 2: Diagnóstico

		select @LicencaS4E = LicencaS4E, @tipoChecagemInconsistencia = isnull(tipoChecagemInconsistencia,1) from Configuracao
		Select @DT_Atual = getdate(), @CD_UD = Convert(Int,@CD_UD) 
		Select @TP_Procedimento = TP_Procedimento From Servico Where CD_Servico = @CD_Servico

		/*** #9424 ***/
		if @LicencaS4E = 'UHD68FDSSHDS87622ASBVQ71619A87287776SDS0KJUY66001'
		begin
			Set @mensagemRegra30 = '30;O associado possui cobertura parcial para esse procedimento.'
		end
		else
		begin
			Set @mensagemRegra30 = '30;O associado não possui cobertura para esse procedimento.'
		end
		/*** Fim #9424 ***/

		--Tipo de procedimento
		If @TP_Procedimento Is Null
		Begin
			Set @FinalTransacao = 2
			if (@DS_Mensagem <> '')
				Set @DS_Mensagem += '©'
			Set @DS_Mensagem += '31;O procedimento precisa ter o tipo cadastrado.'
		End

		-------------------------------------------------------------------------------------------------------
		--Carregar plano de tratamento
		-------------------------------------------------------------------------------------------------------
		Declare @tempTableConsultas table(
			cd_sequencial int,
			cd_sequencial_dep int,
			cd_funcionario int,
			cd_servico int,
			cd_ud nvarchar(100),
			oclusal bit,
			distral bit,
			mesial bit,
			vestibular bit,
			lingual bit,
			dt_servico datetime,
			dt_cancelamento datetime,
			cd_filial int,
			cd_sequencial_agenda int,
			status int,
			statusInclusao int,
			rboId tinyint,
			nr_gto varchar(50),
			nr_cgc varchar(14),
			liberadoCoberturaAnterior bit --- #14426
		)
		insert into @tempTableConsultas (cd_sequencial, cd_sequencial_dep, cd_funcionario, cd_servico, cd_ud, oclusal, distral, mesial, vestibular, lingual, dt_servico, dt_cancelamento, cd_filial, cd_sequencial_agenda, status, statusInclusao, rboId, nr_gto, nr_cgc)
		select X1.cd_sequencial, X1.cd_sequencial_dep, X1.cd_funcionario, X1.cd_servico, X1.cd_ud, X1.oclusal, X1.distral, X1.mesial, X1.vestibular, X1.lingual, X1.dt_servico, X1.dt_cancelamento, X1.cd_filial, X1.cd_sequencial_agenda, X1.status, X1.statusInclusao, X1.rboId, X1.nr_gto, X2.nr_cgc
		from consultas X1
		inner join filial X2 on X2.cd_filial = X1.cd_filial
		where X1.cd_sequencial_dep in
		(
			select cd_sequencial2 from DependenteCorrelacionado where cd_sequencial1 = @CD_Sequencial_Dep
			union
			select cd_sequencial1 from DependenteCorrelacionado where cd_sequencial2 = @CD_Sequencial_Dep
			union
			select @CD_Sequencial_Dep
		)
		and X1.dt_cancelamento is null
		and (X1.status not in (1,4,7,10) or (X1.status = 7 and X1.dt_servico is not null))
		and X1.cd_servico <> 80000500
		-------------------------------------------------------------------------------------------------------
		
		select @CNPJClinica = isnull(nr_cgc,'NAOINFORMADO')
		from filial
		where cd_filial = @Filial

		-------------------------------------------------------------------------------------------------------
		--Verificar inconsistência apenas no diagnóstico
		-------------------------------------------------------------------------------------------------------
		if (@ChavePrimaria > 0 and @tipoChecagemInconsistencia = 2)
			begin
				select cd_sequencial
				from @tempTableConsultas
				where cd_sequencial = @ChavePrimaria
				and status <> statusInclusao

				if @@rowcount > 0
					begin
						return
					end
			end
		-------------------------------------------------------------------------------------------------------

		-------------------------------------------------------------------------------------------------------
		--Dados do Cliente
		-------------------------------------------------------------------------------------------------------
		Select
		@WL_Idade = dbo.FS_Idade(IsNull(t1.DT_NASCIMENTO,dateadd(year,-1,getdate())),getdate()),
		@CD_PLANO = t1.CD_PLANO,
		@CD_Associado = t1.CD_Associado,
		@dt_assinaturaContrato = isnull(dt_assinaturaContrato,getdate()),
		@planoortodontico = fl_exige_dentista,
		@tp_empresa = TP_EMPRESA,
		@CD_Empresa = t4.cd_empresa,
		@cd_centro_custo = t4.cd_centro_custo
		From Dependentes t1, Planos t2, ASSOCIADOS t3, empresa t4
		Where t1.CD_Sequencial = @CD_Sequencial_Dep And
		t1.cd_plano = t2.cd_plano and 
		t1.CD_ASSOCIADO = t3.cd_associado and 
		t3.cd_empresa = t4.CD_EMPRESA  


		--************************************************************
		--Verificar as regras existentes para o procedimento
		--************************************************************
		Declare cursor_regras Cursor For
		
			select distinct codigo_regra
			from TB_Regra_Servico
			where CHARINDEX(',' + convert(varchar(10),@cd_centro_custo) + ',', ',' + isnull(centro_custo,convert(varchar(10),@cd_centro_custo)) + ',') > 0
			and CHARINDEX(',' + convert(varchar(10),@CD_PLANO) + ',', ',' + isnull(plano,convert(varchar(10),@CD_PLANO)) + ',') > 0
			and CHARINDEX(',' + Convert(varchar(10),@CD_Servico) + ',',',' + cd_servico + ',') > 0
		
		OPEN cursor_regras
		FETCH NEXT FROM cursor_regras INTO @CD_Dado1_Cursor
		
		WHILE (@@FETCH_STATUS <> -1)
			BEGIN
				if(@regras <> '')
					begin
						set @regras += ','
					end
				set @regras += convert(varchar,@CD_Dado1_Cursor)
		
				FETCH NEXT FROM cursor_regras INTO @CD_Dado1_Cursor
			END
		Close cursor_regras
		DEALLOCATE cursor_regras
		--************************************************************
		
		If @WL_Idade < 0
			Begin
				if (@DS_Mensagem <> '')
					Set @DS_Mensagem += '©'
				Set @DS_Mensagem += '31;A data de nascimento do beneficiário é obrigatória e não está informada em seu cadastro.'
				If @Operacao = 3
					Begin
						Set @FinalTransacao = 2
					End
				Else
					Begin
						Set @FinalTransacao = 3
				End
			End
 
		--Procedimento antes do plano e cancelado
		If @Status = 1
			Begin
				If @DT_Servico is Not Null
					Begin
						if @Status = 1
							if (@DS_Mensagem <> '')
								Set @DS_Mensagem += '©'
							Set @DS_Mensagem += '31;Procedimento pré existente não pode ser baixado.'
						If @Operacao = 3
							Begin
								Set @FinalTransacao = 2
							End
						Else
							Begin
								Set @FinalTransacao = 3
							End

					End
				Else
					Begin
						Return
					End
			End

		--Procedimento cancelado ou antes do plano não executa
		If @Status in (1,4,5,6,7,8)
			Begin
				Return
			End


		--REGRA 1: Procedimentos liberados dos testes

if(CHARINDEX(',1,',',' + @regras + ',') > 0)
	begin
		Declare cursor_001 Cursor For
			Select cd_servico, mensagemAmigavel From TB_Regra_Servico Where Codigo_Regra = 1
			and CHARINDEX(',' + convert(varchar(10),@cd_centro_custo) + ',', ',' + isnull(centro_custo,convert(varchar(10),@cd_centro_custo)) + ',') > 0
			and CHARINDEX(',' + convert(varchar(10),@CD_PLANO) + ',', ',' + isnull(plano,convert(varchar(10),@CD_PLANO)) + ',') > 0
		OPEN cursor_001
		FETCH NEXT FROM cursor_001 INTO @CD_Dado1_Cursor, @mensagemAmigavel
		WHILE (@@FETCH_STATUS <> -1)
			BEGIN
				If CHARINDEX(',' + Convert(varchar(10),@CD_Servico) + ',',',' + @CD_Dado1_Cursor + ',') > 0   
					Begin
						Close cursor_001
						DEALLOCATE cursor_001
						Return
				End
				FETCH NEXT FROM cursor_001 INTO @CD_Dado1_Cursor, @mensagemAmigavel
			END
		Close cursor_001
		DEALLOCATE cursor_001
	end


		--Verificar cobertura
		if (
			(select count(0)
			from plano_servico T1, dependentes T2
			where T1.cd_plano = T2.cd_plano
			and T1.cd_servico = @CD_Servico
			and T2.cd_sequencial = @CD_Sequencial_Dep)
			+
			(Select count(0)
			From Consultas c
			where c.cd_sequencial = @ChavePrimaria
			and isnull(convert(int, c.liberadoCoberturaAnterior),0)=1) ---#14426
			) = 0
		Set @TP_Procedimento = 3
	    	 
--- REGRAS PROCEDIMENTOS PARTICULARES--------------------------------------------------------------------------

    -- Se esse procedimento não é particular e está dentro do orçamento,
    -- ele deve ficar como PARTICULAR mesmo assim
     If @ChavePrimaria > 0 and @Operacao = 3 
        If (Select count(cd_sequencial_pp)
               From orcamento_servico 
               Where cd_sequencial_pp = @ChavePrimaria) > 0 
           Set @TP_Procedimento = 3
        
     print '9.@FinalTransacao: ' + convert(varchar(10),@FinalTransacao)
        
     If @TP_Procedimento = 3
      Begin            
             
             print '9.0.@FinalTransacao: ' + convert(varchar(10),@FinalTransacao)    
             
             Select @CD_EntreiProcEspec = 1        
             -- PRÓTESE TOTAL 
             -- Testar se o procedimento está no orçamento e se estiver 
             -- no orçamento está FECHADO.
              If @DT_Servico Is Not Null
                Begin -- Inicio Particular Data de Servico 
                     
                     print '9.1.@FinalTransacao: ' + convert(varchar(10),@FinalTransacao)                
                     -- Flag para saber se é um desses procedimentos e 
                     -- não entrar no teste GERAL
                      

					 Declare cursor_002 Cursor For          
						Select cd_servico,cd_servico2, mensagemAmigavel From TB_Regra_Servico Where Codigo_Regra = 2
						and CHARINDEX(',' + convert(varchar(10),@cd_centro_custo) + ',', ',' + isnull(centro_custo,convert(varchar(10),@cd_centro_custo)) + ',') > 0
						and CHARINDEX(',' + convert(varchar(10),@CD_PLANO) + ',', ',' + isnull(plano,convert(varchar(10),@CD_PLANO)) + ',') > 0

					  OPEN cursor_002 
					  FETCH NEXT FROM cursor_002 INTO @CD_Dado1_Cursor,@CD_Dado2_Cursor, @mensagemAmigavel

					   -- Inicio do Loop.
					   WHILE (@@FETCH_STATUS <> -1)
					   BEGIN -- Regra 02 While 
                            print '9.2.@FinalTransacao: ' + convert(varchar(10),@FinalTransacao)	       
							 -- Orçamento Fechados. Exceções.
							 -- REGRA 2 : Procedimento particular só pode ser feitos depois de outros.
							 If CHARINDEX(',' + Convert(varchar(10),@CD_Servico) + ',',',' + @CD_Dado1_Cursor + ',') > 0   
								Begin
									Select @CD_EntreiProcEspec = 2
									-- Saber se têm orçamento fechado com os sguintes procedimentos. (4290, 4300 e 4310).
									-- Se tiver é para deixar passar. 
									-- Orçamento fechado.
								   Select @NR_Quantidade = count(t1.cd_orcamento) , @CD_Orcamento = max(t1.cd_orcamento)
									   From   Orcamento_clinico T1, Orcamento_servico T2 , @tempTableConsultas t3
									   Where  T3.CD_Sequencial_Dep  = @CD_Sequencial_Dep  And 
											  CHARINDEX(',' + Convert(varchar,T3.CD_Servico) + ',',',' + @CD_Dado2_Cursor + ',') > 0 And
											  T3.CD_Sequencial      = T2.cd_sequencial_pp And 
											  T3.DT_Cancelamento    is null And
											  T2.cd_orcamento       = T1.cd_orcamento     And 
											  T1.cd_status          = 1   -- Orçamento fechado : 1 - fechado , 0 - Aberto , 2 - validade vencida, 3 - cancelado.

								   If @NR_Quantidade = 0 
									 Begin -- Inicio If @NR_Quantidade = 0 
                                               print '9.3.@FinalTransacao: ' + convert(varchar(10),@FinalTransacao)											 
											if (@DS_Mensagem <> '')
												Set @DS_Mensagem += '©'
												
												if (@mensagemAmigavel is not null)
													begin
														Set @DS_Mensagem += '02;REGRA 2: ' + @mensagemAmigavel
													end
												else
													begin
														Set @DS_Mensagem += '02;REGRA 2: O procedimento ' + Convert(varchar(10),@CD_Servico) + ' precisa ter o procedimento ' + @CD_Dado2_Cursor + ' no orçamento.'
													end
												
											   If @Operacao = 3 -- Consultas TEMP
												  Begin
					          						Set @FinalTransacao = 2
												  End
											   Else
												 Begin
													Set @FinalTransacao = 3
												  End
                                               print '9.4.@FinalTransacao: ' + convert(varchar(10),@FinalTransacao)		  

								     End -- Fim If @NR_Quantidade = 0 
                                End -- Fim
                                
                                FETCH NEXT FROM cursor_002 INTO @CD_Dado1_Cursor,@CD_Dado2_Cursor, @mensagemAmigavel
                       END -- Regra 02 While 
                       Close cursor_002
                       DEALLOCATE cursor_002
  
                End
     
              print '10.@FinalTransacao: ' + convert(varchar(10),@FinalTransacao)
     
              --Não entrou no teste. Entrar Teste Geral
              If @CD_EntreiProcEspec = 1 
              Begin
                    print '10.1.@FinalTransacao: ' + convert(varchar(10),@FinalTransacao)
                	-- Se orçamento está cancelado , ele não pode ser baixado
  					Set @Status = 0
  					if @Operacao=3 -- Consultas
						Select @Status = t1.cd_status
						  From Orcamento_clinico T1, Orcamento_servico T2 , @tempTableConsultas t3
						 Where  
							   T3.CD_Sequencial_Dep  = @CD_Sequencial_Dep  And 
							   T3.CD_Servico         = @CD_Servico         And 
							   T3.DT_Cancelamento    is null And
	  						   T3.CD_Sequencial      = T2.cd_sequencial_pp And 
							   T2.cd_orcamento       = T1.cd_orcamento and 
							   t3.cd_sequencial      = @ChavePrimaria 
                    
                     print '10.2.@FinalTransacao: ' + convert(varchar(10),@FinalTransacao)
					 If (@Status >= 3) 
						 Begin
							if (@DS_Mensagem <> '')
								Set @DS_Mensagem += '©'
   							Set @DS_Mensagem += '31;Procedimento não pode ser baixado por estar dentro de um orçamento cancelado.'                         
							Set @FinalTransacao = 3
						 End
                     print '10.3.@FinalTransacao: ' + convert(varchar(10),@FinalTransacao)
                     
                     if @Operacao=1 -- ConsultasTemp
                        Select @NR_Quantidade = 0, @CD_Orcamento = 0 
                     else   
                       Select @NR_Quantidade = count(t1.cd_orcamento), @CD_Orcamento = max(t1.cd_orcamento)  
                       From   Orcamento_clinico T1, Orcamento_servico T2 , @tempTableConsultas t3
                       Where 
                              T3.CD_Sequencial_Dep  = @CD_Sequencial_Dep And 
                              T3.CD_Servico         = @CD_Servico         And 
                              T3.DT_Cancelamento    is null And
                              T3.CD_Sequencial      = T2.cd_sequencial_pp And 
                              T2.cd_orcamento       = T1.cd_orcamento     And 
                              T1.cd_status          = 1   and -- Orçamento fechado : 1 - fechado , 0 - Aberto , 2 - validade vencida, 3 - cancelado.
						      t3.cd_sequencial      = @ChavePrimaria 
                              
                     print '10.4.@FinalTransacao: ' + convert(varchar(10),@FinalTransacao)
                     If @NR_Quantidade = 0 
  		                Begin
							if (@DS_Mensagem <> '')
								Set @DS_Mensagem += '©'
							Set @DS_Mensagem += @mensagemRegra30 -- #9424
	     	   	           
							If @Operacao = 3 -- Consultas
								Begin
									Set @FinalTransacao = 2  
								End
							Else
								Begin
									Set @FinalTransacao = 3
                				End
						End
              End

      End
     
     print '10.9.@FinalTransacao: ' + convert(varchar(10),@FinalTransacao)      


  --End

  print '11.@FinalTransacao: ' + convert(varchar(10),@FinalTransacao)


  -----------------------------------------------------------------------------------------------
  -- REGRA 3 : Para baixar procedimento precisa ter outros realizados
  -- EX : baixar 1052 precisa o 1051 realizado

if(CHARINDEX(',3,',',' + @regras + ',') > 0)
	begin
	    Declare cursor_003 Cursor For          
	    Select cd_servico,cd_servico2, mensagemAmigavel From TB_Regra_Servico Where Codigo_Regra = 3
	    and CHARINDEX(',' + convert(varchar(10),@cd_centro_custo) + ',', ',' + isnull(centro_custo,convert(varchar(10),@cd_centro_custo)) + ',') > 0
	    and CHARINDEX(',' + convert(varchar(10),@CD_PLANO) + ',', ',' + isnull(plano,convert(varchar(10),@CD_PLANO)) + ',') > 0
	
		OPEN cursor_003 
		FETCH NEXT FROM cursor_003 INTO @CD_Dado1_Cursor,@CD_Dado2_Cursor, @mensagemAmigavel
	
		-- Inicio do Loop.
		WHILE (@@FETCH_STATUS <> -1)
		BEGIN
		       
	
			 If CHARINDEX(',' + Convert(varchar(10),@CD_Servico) + ',',',' + @CD_Dado1_Cursor + ',') > 0 And   
				 @DT_Servico Is Not Null
				Begin
					  Select @NR_Quantidade = count(cd_sequencial) 
						   From   @tempTableConsultas as t1
							Where CHARINDEX(',' + Convert(varchar,CD_Servico) + ',',',' + @CD_Dado2_Cursor + ',') > 0 And
								  DT_Servico         is not null    
				                                  
					   If @NR_Quantidade = 0 
						 Begin
							if (@DS_Mensagem <> '')
								Set @DS_Mensagem += '©'
								
								if (@mensagemAmigavel is not null)
									begin
										Set @DS_Mensagem += '03;REGRA 3: ' + @mensagemAmigavel
									end
								else
									begin
										Set @DS_Mensagem += '03;REGRA 3: Para baixar o procedimento ' + Convert(varchar(10),@CD_Servico) + ' precisaria existir o procedimento ' + @CD_Dado2_Cursor + ' realizado anteriormente.'
									end
								
							   If @Operacao = 3 -- Consultas TEMP
			   					 Begin
								   Set @FinalTransacao = 2
								 End
							   Else
								 Begin
								   Set @FinalTransacao = 3
	            				 End
	
						 End                         
	           End
	
	       FETCH NEXT FROM cursor_003 INTO @CD_Dado1_Cursor,@CD_Dado2_Cursor, @mensagemAmigavel
	     END
	   Close cursor_003
	   DEALLOCATE cursor_003
	end




-----------------------------------------------------------------------------------------------
  -- REGRA 4 : Para baixar determinado procedimento precisa existir outros pendentes 
  -- EX : baixar 1052 precisa o 1051,1054,1055 pendente

if(CHARINDEX(',4,',',' + @regras + ',') > 0)
	begin
	    Declare cursor_004 Cursor For          
	    Select cd_servico,cd_servico2, mensagemAmigavel From TB_Regra_Servico Where Codigo_Regra = 4
	    and CHARINDEX(',' + convert(varchar(10),@cd_centro_custo) + ',', ',' + isnull(centro_custo,convert(varchar(10),@cd_centro_custo)) + ',') > 0
	    and CHARINDEX(',' + convert(varchar(10),@CD_PLANO) + ',', ',' + isnull(plano,convert(varchar(10),@CD_PLANO)) + ',') > 0
	
		OPEN cursor_004 
		FETCH NEXT FROM cursor_004 INTO @CD_Dado1_Cursor,@CD_Dado2_Cursor, @mensagemAmigavel
	
		-- Inicio do Loop.
		WHILE (@@FETCH_STATUS <> -1)
		BEGIN
	
			 If CHARINDEX(',' + Convert(varchar(10),@CD_Servico) + ',',',' + @CD_Dado1_Cursor + ',') > 0 And   
				@DT_Servico Is Not Null
				Begin
					  Select @NR_Quantidade = count(cd_sequencial) 
						   From   @tempTableConsultas as t1
							Where CHARINDEX(',' + convert(varchar,CD_Servico) + ',',',' + @CD_Dado2_Cursor + ',') > 0 And
								  DT_Servico         is null
				                                  
					   If @NR_Quantidade = 0 
						 Begin
			
							if (@DS_Mensagem <> '')
								Set @DS_Mensagem += '©'
								
								if (@mensagemAmigavel is not null)
									begin
										Set @DS_Mensagem += '04;REGRA 4: ' + @mensagemAmigavel
									end
								else
									begin
										Set @DS_Mensagem += '04;REGRA 4: Para baixar o procedimento ' + Convert(varchar(10),@CD_Servico) + ' precisaria existir o procedimento ' + @CD_Dado2_Cursor + ' pendente.'
									end
								
							   If @Operacao = 3 -- Consultas TEMP
			   					 Begin
								   Set @FinalTransacao = 2
								 End
							   Else
								 Begin
								   Set @FinalTransacao = 3
	            				 End
	
						 End                         
				End
	
	        FETCH NEXT FROM cursor_004 INTO @CD_Dado1_Cursor,@CD_Dado2_Cursor, @mensagemAmigavel
	    END 
	   Close cursor_004
	   DEALLOCATE cursor_004
	end





----------------------------------------------------------------------------------------------
  -- REGRA 5 : Procedimentos precisam ter dente

if(CHARINDEX(',5,',',' + @regras + ',') > 0)
	begin
	    Declare cursor_005 Cursor For          
	    Select cd_servico, mensagemAmigavel From TB_Regra_Servico Where Codigo_Regra = 5
	    and CHARINDEX(',' + convert(varchar(10),@cd_centro_custo) + ',', ',' + isnull(centro_custo,convert(varchar(10),@cd_centro_custo)) + ',') > 0
	    and CHARINDEX(',' + convert(varchar(10),@CD_PLANO) + ',', ',' + isnull(plano,convert(varchar(10),@CD_PLANO)) + ',') > 0
	
		OPEN cursor_005 
		FETCH NEXT FROM cursor_005 INTO @CD_Dado1_Cursor, @mensagemAmigavel
	
	 -- Inicio do Loop.
		WHILE (@@FETCH_STATUS <> -1)
		BEGIN
	          If CHARINDEX(',' + Convert(varchar(10),@CD_Servico) + ',',',' + @CD_Dado1_Cursor + ',') > 0  
	             Begin	
		           If @CD_UD Is Null   
		             Begin
				if (@DS_Mensagem <> '')
					Set @DS_Mensagem += '©'
					
					if (@mensagemAmigavel is not null)
						begin
							Set @DS_Mensagem += '05;REGRA 5: ' + @mensagemAmigavel
						end
					else
						begin
							Set @DS_Mensagem += '05;REGRA 5: Procedimento ' + @CD_Dado1_Cursor + ' precisa ter o dente informado.'
						end
					
	                      If @Operacao = 3 -- Consultas TEMP
							  Begin
							    Set @FinalTransacao = 2
							  End
						   Else
							  Begin
								Set @FinalTransacao = 3
							  End  
		            End  
	             End
	         FETCH NEXT FROM cursor_005 INTO @CD_Dado1_Cursor, @mensagemAmigavel
	     END
	     Close cursor_005
	     DEALLOCATE cursor_005
	end



-----------------------------------------------------------------------------------------------
  -- REGRA 6 : Procedimentos não podem ter dente

if(CHARINDEX(',6,',',' + @regras + ',') > 0)
	begin
		  Declare cursor_006 Cursor For          
		    Select cd_servico, mensagemAmigavel From TB_Regra_Servico Where Codigo_Regra = 6
		    and CHARINDEX(',' + convert(varchar(10),@cd_centro_custo) + ',', ',' + isnull(centro_custo,convert(varchar(10),@cd_centro_custo)) + ',') > 0
		    and CHARINDEX(',' + convert(varchar(10),@CD_PLANO) + ',', ',' + isnull(plano,convert(varchar(10),@CD_PLANO)) + ',') > 0
		
			OPEN cursor_006 
			FETCH NEXT FROM cursor_006 INTO @CD_Dado1_Cursor, @mensagemAmigavel
		
			-- Inicio do Loop.
			WHILE (@@FETCH_STATUS <> -1)
			BEGIN
		
		         If CHARINDEX(',' + Convert(varchar(10),@CD_Servico) + ',',',' + @CD_Dado1_Cursor + ',') > 0 
		             Begin	
			           If @CD_UD Is Not Null   
			             Begin
					if (@DS_Mensagem <> '')
						Set @DS_Mensagem += '©'
						
						if (@mensagemAmigavel is not null)
							begin
								Set @DS_Mensagem += '06;REGRA 6: ' + @mensagemAmigavel
							end
						else
							begin
								Set @DS_Mensagem += '06;REGRA 6: Procedimento ' + @CD_Dado1_Cursor + ' não pode ter o dente informado.'
							end
										
		                       If @Operacao = 3 -- Consultas TEMP
								  Begin
									Set @FinalTransacao = 2
								  End
							   Else
								  Begin
									Set @FinalTransacao = 3
								  End  
			             End  
		             End 
		        FETCH NEXT FROM cursor_006 INTO @CD_Dado1_Cursor, @mensagemAmigavel
		    END
		    Close cursor_006
		    DEALLOCATE cursor_006
	end



-----------------------------------------------------------------------------------------------
  -- REGRA 7 : Procedimentos não podem ser feitos nos sequintes dentes

if(CHARINDEX(',7,',',' + @regras + ',') > 0)
	begin
	    Declare cursor_007 Cursor For          
	    Select cd_servico,cd_ud, mensagemAmigavel From TB_Regra_Servico Where Codigo_Regra = 7
	    and CHARINDEX(',' + convert(varchar(10),@cd_centro_custo) + ',', ',' + isnull(centro_custo,convert(varchar(10),@cd_centro_custo)) + ',') > 0
	    and CHARINDEX(',' + convert(varchar(10),@CD_PLANO) + ',', ',' + isnull(plano,convert(varchar(10),@CD_PLANO)) + ',') > 0
	
		OPEN cursor_007 
		FETCH NEXT FROM cursor_007 INTO @CD_Dado1_Cursor,@CD_Dado2_Cursor, @mensagemAmigavel
	
		-- Inicio do Loop.
		WHILE (@@FETCH_STATUS <> -1)
		BEGIN
	
			   If CHARINDEX(',' + Convert(varchar(10),@CD_Servico) + ',',',' + @CD_Dado1_Cursor + ',') > 0 And
				  @CD_UD Is not null   
				   Begin
					   If CHARINDEX(',' + Convert(varchar,@CD_UD) + ',',',' + @CD_Dado2_Cursor + ',') > 0   
						 Begin
	
							if (@DS_Mensagem <> '')
								Set @DS_Mensagem += '©'
								
								if (@mensagemAmigavel is not null)
									begin
										Set @DS_Mensagem += '07;REGRA 7: ' + @mensagemAmigavel
									end
								else
									begin
										Set @DS_Mensagem += '07;REGRA 7: O procedimento ' + Convert(varchar(10),@CD_Servico) + ' não pode ser realizado no dente ' + @CD_Dado2_Cursor + '.'
									end
								
							   If @Operacao = 3 -- Consultas TEMP
								  Begin
									Set @FinalTransacao = 2
								  End
							   Else
								  Begin
									Set @FinalTransacao = 3
								  End  
						 End 
				   End
	          FETCH NEXT FROM cursor_007 INTO @CD_Dado1_Cursor,@CD_Dado2_Cursor, @mensagemAmigavel
	    END
	    Close cursor_007
	    DEALLOCATE cursor_007
	end



-----------------------------------------------------------------------------------------------
    -- REGRA 8 : Procedimentos so podem ser feitos nos sequintes dentes

if(CHARINDEX(',8,',',' + @regras + ',') > 0)
	begin
	    Declare cursor_008 Cursor For          
	    Select cd_servico,cd_ud, mensagemAmigavel From TB_Regra_Servico Where Codigo_Regra = 8
	    and CHARINDEX(',' + convert(varchar(10),@cd_centro_custo) + ',', ',' + isnull(centro_custo,convert(varchar(10),@cd_centro_custo)) + ',') > 0
	    and CHARINDEX(',' + convert(varchar(10),@CD_PLANO) + ',', ',' + isnull(plano,convert(varchar(10),@CD_PLANO)) + ',') > 0
	
		OPEN cursor_008 
		FETCH NEXT FROM cursor_008 INTO @CD_Dado1_Cursor,@CD_Dado2_Cursor, @mensagemAmigavel
	
		-- Inicio do Loop.
		WHILE (@@FETCH_STATUS <> -1)
		BEGIN
	
	   If CHARINDEX(',' + Convert(varchar(10),@CD_Servico) + ',',',' + @CD_Dado1_Cursor + ',') > 0 And
	      @CD_UD Is not null   
	       Begin
	           If CHARINDEX(',' + Convert(varchar,@CD_UD) + ',',',' + @CD_Dado2_Cursor + ',') = 0   
	             Begin
	                   
				if (@DS_Mensagem <> '')
					Set @DS_Mensagem += '©'
					
					if (@mensagemAmigavel is not null)
						begin
							Set @DS_Mensagem += '08;REGRA 8: ' + @mensagemAmigavel
						end
					else
						begin
							Set @DS_Mensagem += '08;REGRA 8: O procedimento ' + Convert(varchar(10),@CD_Servico) + ' só pode ser realizado no dente ' + @CD_Dado2_Cursor + '.'
						end
					
					   If @Operacao = 3 -- Consultas TEMP
						  Begin
							Set @FinalTransacao = 2
						  End
					   Else
						  Begin
							Set @FinalTransacao = 3
						  End  
	             End 
	       End
	      FETCH NEXT FROM cursor_008 INTO @CD_Dado1_Cursor,@CD_Dado2_Cursor, @mensagemAmigavel
	   END
	   Close cursor_008
	   DEALLOCATE cursor_008
	end


-----------------------------------------------------------------------------------------------
    -- REGRA 9 : Procedimentos que não podem ter FACE

if(CHARINDEX(',9,',',' + @regras + ',') > 0)
	begin
	    Declare cursor_009 Cursor For          
	    Select cd_servico, mensagemAmigavel From TB_Regra_Servico Where Codigo_Regra = 9
	    and CHARINDEX(',' + convert(varchar(10),@cd_centro_custo) + ',', ',' + isnull(centro_custo,convert(varchar(10),@cd_centro_custo)) + ',') > 0
	    and CHARINDEX(',' + convert(varchar(10),@CD_PLANO) + ',', ',' + isnull(plano,convert(varchar(10),@CD_PLANO)) + ',') > 0
	
		OPEN cursor_009 
		FETCH NEXT FROM cursor_009 INTO @CD_Dado1_Cursor, @mensagemAmigavel
	
		-- Inicio do Loop.
		WHILE (@@FETCH_STATUS <> -1)
		BEGIN
	
			   If CHARINDEX(',' + Convert(varchar(10),@CD_Servico) + ',',',' + @CD_Dado1_Cursor + ',') > 0 And
				  (@Mesial + @Oclusal + @Vestibular + @Lingual + @Distal) <> 0   
						Begin	
							if (@DS_Mensagem <> '')
								Set @DS_Mensagem += '©'
								
								if (@mensagemAmigavel is not null)
									begin
										Set @DS_Mensagem += '09;REGRA 9: ' + @mensagemAmigavel
									end
								else
									begin
										Set @DS_Mensagem += '09;REGRA 9: Procedimento ' + Convert(varchar(10),@CD_Servico) + ' não pode ter a face informada.'
									end
								
						   If @Operacao = 3 -- Consultas TEMP
							  Begin
								Set @FinalTransacao = 2
							  End
						   Else
							  Begin
								Set @FinalTransacao = 3  
							  End  
						End 
	           FETCH NEXT FROM cursor_009 INTO @CD_Dado1_Cursor, @mensagemAmigavel
	    END
	 Close cursor_009
	 DEALLOCATE cursor_009
	end




-----------------------------------------------------------------------------------------------
    -- REGRA 10 : Procedimento só pode ser feita em uma combinação de faces       	          

if(CHARINDEX(',10,',',' + @regras + ',') > 0)
	begin
	    Declare cursor_010 Cursor For          
	    Select cd_servico, Faces, mensagemAmigavel From TB_Regra_Servico Where Codigo_Regra = 10
	    and CHARINDEX(',' + convert(varchar(10),@cd_centro_custo) + ',', ',' + isnull(centro_custo,convert(varchar(10),@cd_centro_custo)) + ',') > 0
	    and CHARINDEX(',' + convert(varchar(10),@CD_PLANO) + ',', ',' + isnull(plano,convert(varchar(10),@CD_PLANO)) + ',') > 0
	
		OPEN cursor_010
		FETCH NEXT FROM cursor_010 INTO @CD_Dado1_Cursor, @CD_Dado2_Cursor, @mensagemAmigavel
	
		-- Inicio do Loop.
		WHILE (@@FETCH_STATUS <> -1)
		BEGIN
	
	       If CHARINDEX(',' + Convert(varchar(10),@CD_Servico) + ',',',' + @CD_Dado1_Cursor + ',') > 0 
	  	     Begin	
	
	             Set @FacesTeste =  ''''+@CD_Dado2_Cursor+''''
	             Set @FacesTeste = replace(@FacesTeste,',',''',''')
	
	             --Combinação que esta sendo cadastrada
	             Set @FacesEntrada = '' 
	             If @Mesial <> 0 
	                Set @FacesEntrada = @FacesEntrada +  'M'
	 
	             If @Vestibular <> 0
	                Set @FacesEntrada = @FacesEntrada + 'V'
	
	             If @Lingual <> 0 
	                Set @FacesEntrada = @FacesEntrada + 'L'
	
	             If @Distal <> 0 
	                Set @FacesEntrada = @FacesEntrada + 'D'
	
	             If @Oclusal <> 0 
	                Set @FacesEntrada = @FacesEntrada + 'O'
	
	             if CHARINDEX(@FacesEntrada,@FacesTeste) = 0 
		             Begin
				if (@DS_Mensagem <> '')
					Set @DS_Mensagem += '©'
					
					if (@mensagemAmigavel is not null)
						begin
							Set @DS_Mensagem += '10;REGRA 10: ' + @mensagemAmigavel
						end
					else
						begin
							Set @DS_Mensagem += '10;REGRA 10: Procedimento ' + @CD_Dado1_Cursor + ' só pode ser realizado com a combinação das faces ' + @FacesTeste + '.'
						end
					
	                       If @Operacao = 3 -- Consultas TEMP
							  Begin
								Set @FinalTransacao = 2
							  End
						   Else
							  Begin
								Set @FinalTransacao = 3  
							  End  
		             End  
	        End 
	      FETCH NEXT FROM cursor_010 INTO @CD_Dado1_Cursor, @CD_Dado2_Cursor, @mensagemAmigavel
	END
	Close cursor_010
	DEALLOCATE cursor_010
	end



-----------------------------------------------------------------------------------------------
-- REGRA 11 : Procedimento deve ser informado apenas uma vez (Boca, dente, região)

if(CHARINDEX(',11,',',' + @regras + ',') > 0)
	begin
		Declare cursor_011 Cursor For
		
			select cd_servico, mensagemAmigavel
			From TB_Regra_Servico
			Where Codigo_Regra = 11
			and CHARINDEX(',' + convert(varchar(10),@cd_centro_custo) + ',', ',' + isnull(centro_custo,convert(varchar(10),@cd_centro_custo)) + ',') > 0
			and CHARINDEX(',' + convert(varchar(10),@CD_PLANO) + ',', ',' + isnull(plano,convert(varchar(10),@CD_PLANO)) + ',') > 0
			and CHARINDEX(',' + Convert(varchar(10),@CD_Servico) + ',',',' + cd_servico + ',') > 0
		
		OPEN cursor_011
		FETCH NEXT FROM cursor_011 INTO @CD_Dado1_Cursor, @mensagemAmigavel
		
		WHILE (@@FETCH_STATUS <> -1)
			BEGIN
			
				select top 1 @Dt_ProcedimentoBanco = isnull(dt_servico,getdate()+1)
				From @tempTableConsultas
				Where CD_Servico = @CD_Servico
				and isnull(isnull(cd_ud,rboId),7) = isnull(isnull(@CD_UD,@regiao),7)
				and CD_Sequencial <> @ChavePrimaria
				order by 1 desc
				
				if @@rowcount > 0 
					Begin
						if @Dt_ProcedimentoBanco > getdate()
							Begin
								if (@DS_Mensagem <> '')
									Set @DS_Mensagem += '©'
						
								if (@mensagemAmigavel is not null)
									begin
										Set @DS_Mensagem += '11;REGRA 11: ' + @mensagemAmigavel
									end
								else
									begin
										Set @DS_Mensagem += '11;REGRA 11: O procedimento ' + convert(varchar(10),@CD_Servico) + ' está pendente para ser realizado e só pode ser informado uma vez para o mesmo dente ou região.'
									end
			       
								If @Operacao = 3 -- Consultas TEMP
									Begin
										Set @FinalTransacao = 1
									End
								Else
									Begin
										Set @FinalTransacao = 3
									End
							End
				
						Else
							Begin
								if (@DS_Mensagem <> '')
									Set @DS_Mensagem += '©'
				
									if (@mensagemAmigavel is not null)
										begin
											Set @DS_Mensagem += '11;REGRA 11: ' + @mensagemAmigavel
										end
									else
										begin
											Set @DS_Mensagem += '11;REGRA 11: O procedimento ' + convert(varchar(10),@CD_Servico) + ' só pode ser realizado uma vez para o mesmo dente ou região. Data do último procedimento: ' + Convert(varchar,@Dt_ProcedimentoBanco,103) + '.'
										end
				
								If @Operacao = 3 -- Consultas TEMP
									Begin
										Set @FinalTransacao = 1
									End
								Else
									Begin
										set @FinalTransacao = 3
								End
							End
					End
			
				FETCH NEXT FROM cursor_011 INTO @CD_Dado1_Cursor, @mensagemAmigavel
			END
		Close cursor_011
		DEALLOCATE cursor_011
	end

-----------------------------------------------------------------------------------------------
-- REGRA 12 : Procedimentos só podem ser feitos depois de um determinado numero de meses no mesmo dente (auto-excludente).

if(CHARINDEX(',12,',',' + @regras + ',') > 0)
	begin
		Declare cursor_012 Cursor For
		
			Select cd_servico, QT_Meses, mensagemAmigavel
			From TB_Regra_Servico
			Where Codigo_Regra = 12
			and CHARINDEX(',' + convert(varchar(10),@cd_centro_custo) + ',', ',' + isnull(centro_custo,convert(varchar(10),@cd_centro_custo)) + ',') > 0
			and CHARINDEX(',' + convert(varchar(10),@CD_PLANO) + ',', ',' + isnull(plano,convert(varchar(10),@CD_PLANO)) + ',') > 0
			and CHARINDEX(',' + Convert(varchar(10),@CD_Servico) + ',',',' + cd_servico + ',') > 0
			and isnull(@CD_UD,@regiao) is not null
		
		OPEN cursor_012
		FETCH NEXT FROM cursor_012 INTO @CD_Dado1_Cursor,@CD_Dado3_Cursor, @mensagemAmigavel
		
		WHILE (@@FETCH_STATUS <> -1)
			BEGIN
		
				select top 1 @Dt_ProcedimentoBanco = isnull(dt_servico,getdate()+1)
				From @tempTableConsultas
				Where isnull(isnull(cd_ud,rboId),7) = isnull(isnull(@CD_UD,@regiao),7)
				and CD_Sequencial <> @ChavePrimaria
				and (dt_servico is null or DateDiff(Month,dt_servico,@DT_Atual) < @CD_Dado3_Cursor)
				and CHARINDEX(',' + convert(varchar,CD_Servico) + ',',',' + @CD_Dado1_Cursor + ',') > 0
		    
				if @@rowcount > 0 
					Begin
						if @Dt_ProcedimentoBanco  > getdate()
							Begin
								if (@DS_Mensagem <> '')
									Set @DS_Mensagem += '©'
									
								if (@mensagemAmigavel is not null)
									begin
										Set @DS_Mensagem += '12;REGRA 12: ' + @mensagemAmigavel
									end
								else
									begin
										Set @DS_Mensagem += '12;REGRA 12: O procedimento ' + Convert(varchar(10),@CD_Servico) + ' está pendente para ser realizado. O procedimento só pode ser realizado a cada ' + convert(varchar,@CD_Dado3_Cursor) + ' mês(es) para o mesmo dente.'
									end
					
								If @Operacao = 3 -- Consultas TEMP
									Begin
										Set @FinalTransacao = 1
									End
								Else
									Begin
										Set @FinalTransacao = 3
									End
							End
		
						else
							Begin
								if (@DS_Mensagem <> '')
									Set @DS_Mensagem += '©'
									
									if (@mensagemAmigavel is not null)
										begin
											Set @DS_Mensagem += '12;REGRA 12: ' + @mensagemAmigavel
										end
									else
										begin
											Set @DS_Mensagem += '12;REGRA 12: Procedimento ' + Convert(varchar(10),@CD_Servico) + ' só pode ser realizado a cada ' + convert(varchar,@CD_Dado3_Cursor) + ' mês(es) para o mesmo dente. Data do último procedimento: ' + Convert(varchar,@Dt_ProcedimentoBanco,103) + '.'
										end
									
								If @Operacao = 3 -- Consultas TEMP
									Begin
										Set @FinalTransacao = 1
									End
								Else
									Begin
										set @FinalTransacao = 3
									End
							End
					End
		
					FETCH NEXT FROM cursor_012 INTO @CD_Dado1_Cursor, @CD_Dado3_Cursor, @mensagemAmigavel
			END
		Close cursor_012
		DEALLOCATE cursor_012
	end

    -----------------------------------------------------------------------------------------------
    -- REGRA 13 : Procedimentos só podem ser feitos depois de um determinado numero de mês(es) 
    --            no mesmo dente com determinada combinação de faces

if(CHARINDEX(',13,',',' + @regras + ',') > 0)
	begin
	    Declare cursor_013 Cursor For          
	    Select cd_servico,faces,QT_Meses, mensagemAmigavel From TB_Regra_Servico Where Codigo_Regra = 13
	    and CHARINDEX(',' + convert(varchar(10),@cd_centro_custo) + ',', ',' + isnull(centro_custo,convert(varchar(10),@cd_centro_custo)) + ',') > 0
	    and CHARINDEX(',' + convert(varchar(10),@CD_PLANO) + ',', ',' + isnull(plano,convert(varchar(10),@CD_PLANO)) + ',') > 0
	
		OPEN cursor_013
		FETCH NEXT FROM cursor_013 INTO @CD_Dado1_Cursor,@CD_Dado2_Cursor,@CD_Dado3_Cursor, @mensagemAmigavel
	
		-- Inicio do Loop.
		WHILE (@@FETCH_STATUS <> -1)
		BEGIN
	
	      If CHARINDEX(',' + Convert(varchar(10),@CD_Servico) + ',',',' + @CD_Dado1_Cursor + ',') > 0 And
	        @CD_UD is not null 
	          Begin
	               --- Observar primeiro se não tem procedimento pendente.
	               --- Procedimento estando pendente, não pode entrar outro pendente ou realizado.
	      
	             Set @FacesTeste =  ''''+@CD_Dado2_Cursor+''''
	             Set @FacesTeste = replace(@FacesTeste,',',''',''')
	
	             --Combinação que esta sendo cadastrada
	             --Set @FacesEntrada = '' 
	             --If @Mesial <> 0 
	             --   Set @FacesEntrada = @FacesEntrada +  'M'
	 
	             --If @Vestibular <> 0
	             --   Set @FacesEntrada = @FacesEntrada + 'V'
	
	             --If @Lingual <> 0 
	             --   Set @FacesEntrada = @FacesEntrada + 'L'
	
	             --If @Distal <> 0 
	             --   Set @FacesEntrada = @FacesEntrada + 'D'
	
	             --If @Oclusal <> 0 
	             --   Set @FacesEntrada = @FacesEntrada + 'O'
	
	            Declare cursor_013_001 Cursor For 
			    Select  isnull(dt_servico,getdate()+1) , oclusal,  distral, mesial, vestibular, lingual
						From  @tempTableConsultas as t1
						Where CD_UD = @CD_UD And
							  CD_Sequencial     <>  @ChavePrimaria and 
							 (dt_servico is null or dt_servico >= dateadd(month,@CD_Dado3_Cursor * -1,getdate())) and 
							 CHARINDEX(',' + convert(varchar,CD_Servico) + ',',',' + @CD_Dado1_Cursor + ',') > 0
	
				OPEN cursor_013_001
				FETCH NEXT FROM cursor_013_001 INTO @Dt_ProcedimentoBanco,@OclusalAux,@DistalAux,@MesialAux,@VestibularAux,@LingualAux
	
				-- Inicio do Loop.
				WHILE (@@FETCH_STATUS <> -1)
				BEGIN
				
				     Set @CD_Dado4_Cursor = 0 -- Mensagem de Erro se 1 
				     if @LicencaS4E in ('JHGF76EREFJHFDI87W6EWE7VCDJHCFSU276734EDUYHHAJ011','HYYT76658HFKJNXBEY46WUYU1276745JHFJDHJDFDVCGFD020') and
	                    (@Mesial=@MesialAux) and  
					    (@Vestibular=@VestibularAux) and
					    (@Lingual=@LingualAux) and
					    (@Distal=@DistalAux) and 
					    (@Oclusal=@OclusalAux) 			     
				     Begin 
				        Set @CD_Dado4_Cursor = 1
				     End   
	
				     if @LicencaS4E not in ('JHGF76EREFJHFDI87W6EWE7VCDJHCFSU276734EDUYHHAJ011','HYYT76658HFKJNXBEY46WUYU1276745JHFJDHJDFDVCGFD020') and
	                    (@Mesial>0     and @MesialAux>0) or 
						(@Vestibular>0 and @VestibularAux>0) or 
						(@Lingual>0    and @LingualAux>0) or 
						(@Distal>0    and @DistalAux>0) or 
						(@Oclusal>0    and @OclusalAux>0) 
					 Begin 
				        Set @CD_Dado4_Cursor = 1
				     End   
				     
					 if @CD_Dado4_Cursor = 1
						Begin
						
	   					   if @Dt_ProcedimentoBanco  > getdate()
							  Begin 
							if (@DS_Mensagem <> '')
								Set @DS_Mensagem += '©'
								
								if (@mensagemAmigavel is not null)
									begin
										Set @DS_Mensagem += '13;REGRA 13: ' + @mensagemAmigavel
									end
								else
									begin
										Set @DS_Mensagem += '13;REGRA 13: O procedimento ' + Convert(varchar(10),@CD_Servico) + ' está pendente para ser realizado. O procedimento só pode ser realizado a cada ' + convert(varchar,@CD_Dado3_Cursor) + ' mês(es) dentro na mesma combinação de faces.'
									end
								
							   If @Operacao = 3 -- Consultas TEMP
								  Begin
									Set @FinalTransacao = 1
								  End
							   Else
								  Begin
									Set @FinalTransacao = 3
								   End
						   
							  End 
	
							Else
							  Begin
								if (@DS_Mensagem <> '')
									Set @DS_Mensagem += '©'
									
									if (@mensagemAmigavel is not null)
										begin
											Set @DS_Mensagem += '13;REGRA 13: ' + @mensagemAmigavel
										end
									else
										begin
											Set @DS_Mensagem += '13;REGRA 13: Procedimento ' + Convert(varchar(10),@CD_Servico) + ' só pode ser realizado a cada ' + convert(varchar,@CD_Dado3_Cursor) + ' mês(es) na mesma combinação de faces. Data do último procedimento: ' + Convert(varchar,@Dt_ProcedimentoBanco,103) + '.'
										end
									
								 If @Operacao = 3 -- Consultas TEMP
									  Begin
										Set @FinalTransacao = 1
									  End
								   Else
									  Begin
										set @FinalTransacao = 3
									  End
	
							  End   
	                 End 			
					 FETCH NEXT FROM cursor_013_001 INTO @Dt_ProcedimentoBanco,@OclusalAux,@DistalAux,@MesialAux,@VestibularAux,@LingualAux
				End
	
			     close cursor_013_001
			     deallocate cursor_013_001
	
	       End
	       FETCH NEXT FROM cursor_013 INTO @CD_Dado1_Cursor,@CD_Dado2_Cursor,@CD_Dado3_Cursor, @mensagemAmigavel
	   END
	   Close cursor_013
	   DEALLOCATE cursor_013
	end



    -----------------------------------------------------------------------------------------------
    -- REGRA 14 : Procedimentos só podem ser feitos em determinado dente com uma determinada idade

    Declare cursor_014 Cursor For          
    Select idade, cd_ud, mensagemAmigavel From TB_Regra_Servico Where Codigo_Regra = 14
    and CHARINDEX(',' + convert(varchar(10),@cd_centro_custo) + ',', ',' + isnull(centro_custo,convert(varchar(10),@cd_centro_custo)) + ',') > 0
    and CHARINDEX(',' + convert(varchar(10),@CD_PLANO) + ',', ',' + isnull(plano,convert(varchar(10),@CD_PLANO)) + ',') > 0

	OPEN cursor_014
	FETCH NEXT FROM cursor_014 INTO @CD_Dado3_Cursor,@CD_Dado1_Cursor, @mensagemAmigavel

	-- Inicio do Loop.
	WHILE (@@FETCH_STATUS <> -1)
	BEGIN
			If CHARINDEX(',' + convert(varchar,@CD_UD) + ',',',' + @CD_Dado1_Cursor + ',') > 0 
			   Begin

				 If (@WL_Idade < @CD_Dado3_Cursor)
					   Begin
						if (@DS_Mensagem <> '')
							Set @DS_Mensagem += '©'
							
							if (@mensagemAmigavel is not null)
								begin
									Set @DS_Mensagem += '14;REGRA 14: ' + @mensagemAmigavel
								end
							else
								begin
									Set @DS_Mensagem += '14;REGRA 14: Procedimento ' + Convert(varchar(10),@CD_Servico) + ' não pode ser realizado no dente '+ @CD_Dado1_Cursor + ' com usuario antes dos ' + convert(varchar(10),@CD_Dado3_Cursor) + ' anos de idade.'
								end
							
						  If @Operacao = 3 -- Consultas TEMP
								  Begin
									Set @FinalTransacao = 1
								  End
							   Else
								  Begin
									set @FinalTransacao = 3
								  End  
					   End  
			   End
	      FETCH NEXT FROM cursor_014 INTO @CD_Dado3_Cursor,@CD_Dado1_Cursor, @mensagemAmigavel
    END
   Close cursor_014
   DEALLOCATE cursor_014


 
-----------------------------------------------------------------------------------------------
-- REGRA 15 : Procedimentos só podem ser feitos entre determinada idades

if(CHARINDEX(',15,',',' + @regras + ',') > 0)
	begin
		Declare cursor_015 Cursor For          
		
			Select idade, idade2, mensagemAmigavel
			From TB_Regra_Servico
			Where Codigo_Regra = 15
			and CHARINDEX(',' + convert(varchar(10),@cd_centro_custo) + ',', ',' + isnull(centro_custo,convert(varchar(10),@cd_centro_custo)) + ',') > 0
			and CHARINDEX(',' + convert(varchar(10),@CD_PLANO) + ',', ',' + isnull(plano,convert(varchar(10),@CD_PLANO)) + ',') > 0
			and CHARINDEX(',' + Convert(varchar(10),@CD_Servico) + ',',',' + cd_servico + ',') > 0
		
		OPEN cursor_015
		FETCH NEXT FROM cursor_015 INTO @CD_Dado3_Cursor, @CD_Dado4_Cursor, @mensagemAmigavel
		
		WHILE (@@FETCH_STATUS <> -1)
			BEGIN
		
				If @WL_Idade < @CD_Dado3_Cursor Or @WL_Idade > @CD_Dado4_Cursor
					Begin
						if (@DS_Mensagem <> '')
							Set @DS_Mensagem += '©'
						
						if (@mensagemAmigavel is not null)
							begin
								Set @DS_Mensagem += '15;REGRA 15: ' + @mensagemAmigavel
							end
						else
							begin
								Set @DS_Mensagem += '15;REGRA 15: Procedimento ' + Convert(varchar(10),@CD_Servico) + ' só pode ser realizado em paciente com idade entre ' + convert(varchar,@CD_Dado3_Cursor) + ' e ' + convert(varchar,@CD_Dado4_Cursor) + ' anos. Idade do paciente: ' + convert(varchar,@WL_Idade) + '.'
							end
						
						If @Operacao = 3 -- Consultas TEMP
							Begin
								Set @FinalTransacao = 1
							End
						Else
							Begin
								set @FinalTransacao = 3
							End
					End
		
				FETCH NEXT FROM cursor_015 INTO @CD_Dado3_Cursor, @CD_Dado4_Cursor, @mensagemAmigavel
			END
		Close cursor_015
		DEALLOCATE cursor_015
	end



    -----------------------------------------------------------------------------------------------
    -- REGRA 16 : Procedimentos só pode ser realizados em determinado dente se outros tiverem sido realizados

if(CHARINDEX(',16,',',' + @regras + ',') > 0)
	begin
	    Declare cursor_016 Cursor For          
	    Select cd_servico,cd_servico2, mensagemAmigavel From TB_Regra_Servico Where Codigo_Regra = 16
	    and CHARINDEX(',' + convert(varchar(10),@cd_centro_custo) + ',', ',' + isnull(centro_custo,convert(varchar(10),@cd_centro_custo)) + ',') > 0
	    and CHARINDEX(',' + convert(varchar(10),@CD_PLANO) + ',', ',' + isnull(plano,convert(varchar(10),@CD_PLANO)) + ',') > 0
	
		OPEN cursor_016
		FETCH NEXT FROM cursor_016 INTO @CD_Dado1_Cursor,@CD_Dado2_Cursor, @mensagemAmigavel
	
		-- Inicio do Loop.
		WHILE (@@FETCH_STATUS <> -1)
		BEGIN
	
			 If CHARINDEX(',' + Convert(varchar(10),@CD_Servico) + ',',',' + @CD_Dado1_Cursor + ',') > 0 And
			   @CD_UD is not null
			   Begin
				   Set @NR_Quantidade = 0 
	
				   Select @NR_Quantidade = count(cd_sequencial)
							From  @tempTableConsultas as t1
						Where CD_UD = @CD_UD And  
								  CD_Sequencial     <> @ChavePrimaria And
								  DT_SERVICO        IS NOT NULL And
								  CHARINDEX(',' + convert(varchar,CD_Servico) + ',',',' + @CD_Dado2_Cursor + ',') > 0
						
					 If @NR_Quantidade = 0                  
							  Begin
		                      
								if (@DS_Mensagem <> '')
									Set @DS_Mensagem += '©'
									
									if (@mensagemAmigavel is not null)
										begin
											Set @DS_Mensagem += '16;REGRA 16: ' + @mensagemAmigavel
										end
									else
										begin
											Set @DS_Mensagem += '16;REGRA 16: Procedimento ' + Convert(varchar(10),@CD_Servico) + ' não pode ser realizado no dente, pois precisaria ter o procedimento ' + @CD_Dado2_Cursor + ' realizado no mesmo.'
										end
									
	    						 If @Operacao = 3 -- Consultas TEMP
									  Begin
										Set @FinalTransacao = 2
									  End
								   Else
									  Begin
										set @FinalTransacao = 3
									  End  
							  End   
			   End
	
	           FETCH NEXT FROM cursor_016 INTO @CD_Dado1_Cursor,@CD_Dado2_Cursor, @mensagemAmigavel
	      END
	      Close cursor_016
	      DEALLOCATE cursor_016
	end



    -----------------------------------------------------------------------------------------------
    -- REGRA 17 : Se já existir procedimentos realizados para um determinado dente, outros procedimentos não podem ser realizados

if(CHARINDEX(',17,',',' + @regras + ',') > 0)
	begin
	    Declare cursor_017 Cursor For          
	    Select cd_servico,cd_servico2, mensagemAmigavel From TB_Regra_Servico Where Codigo_Regra = 17
	    and CHARINDEX(',' + convert(varchar(10),@cd_centro_custo) + ',', ',' + isnull(centro_custo,convert(varchar(10),@cd_centro_custo)) + ',') > 0
	    and CHARINDEX(',' + convert(varchar(10),@CD_PLANO) + ',', ',' + isnull(plano,convert(varchar(10),@CD_PLANO)) + ',') > 0
	
		OPEN cursor_017
		FETCH NEXT FROM cursor_017 INTO @CD_Dado1_Cursor,@CD_Dado2_Cursor, @mensagemAmigavel
	
		-- Inicio do Loop.
		WHILE (@@FETCH_STATUS <> -1)
		BEGIN
	
	      If CHARINDEX(',' + Convert(varchar(10),@CD_Servico) + ',',',' + @CD_Dado1_Cursor + ',') > 0 And
	         @CD_UD is not null
	         Begin
	
	             Set @NR_Quantidade = 0 
	
	             Select @NR_Quantidade = count(cd_sequencial)
						From  @tempTableConsultas as t1
						Where CD_UD = @CD_UD And
	                          DT_SERVICO        Is Not NUll And
	                          CD_Sequencial     <> @ChavePrimaria And
	                          CHARINDEX(',' + convert(varchar,CD_Servico) + ',',',' + @CD_Dado2_Cursor + ',') > 0		
	
		         If @NR_Quantidade > 0
						  Begin
	                        
					if (@DS_Mensagem <> '')
						Set @DS_Mensagem += '©'
						
						if (@mensagemAmigavel is not null)
							begin
								Set @DS_Mensagem += '17;REGRA 17: ' + @mensagemAmigavel
							end
						else
							begin
								Set @DS_Mensagem += '17;REGRA 17: Procedimento ' + Convert(varchar(10),@CD_Servico) + ' não pode ser realizado no dente, pois já existe o procedimento ' + @CD_Dado2_Cursor + ' informado anteriormente.'
							end
						
	    					 If @Operacao = 3 -- Consultas TEMP
							      Begin
									Set @FinalTransacao = 2
								  End
							   Else
								  Begin
									set @FinalTransacao = 3
								  End  
						  End   
		         
	          End
	
	          FETCH NEXT FROM cursor_017 INTO @CD_Dado1_Cursor,@CD_Dado2_Cursor, @mensagemAmigavel
	   END
	   Close cursor_017
	   DEALLOCATE cursor_017
	end



    -----------------------------------------------------------------------------------------------
    -- REGRA 18 : O dente do associado que possui os procedimentos só pode ter mais alguns procedimentos cadastrado para o mesmo

	    Declare cursor_018 Cursor For          
	    Select cd_servico,cd_servico2, mensagemAmigavel From TB_Regra_Servico Where Codigo_Regra = 18
	    and CHARINDEX(',' + convert(varchar(10),@cd_centro_custo) + ',', ',' + isnull(centro_custo,convert(varchar(10),@cd_centro_custo)) + ',') > 0
	    and CHARINDEX(',' + convert(varchar(10),@CD_PLANO) + ',', ',' + isnull(plano,convert(varchar(10),@CD_PLANO)) + ',') > 0
	
		OPEN cursor_018
		FETCH NEXT FROM cursor_018 INTO @CD_Dado1_Cursor,@CD_Dado2_Cursor, @mensagemAmigavel
	
		-- Inicio do Loop.
		WHILE (@@FETCH_STATUS <> -1)
		BEGIN
	
	       If CHARINDEX(',' + Convert(varchar(10),@CD_Servico) + ',',',' + @CD_Dado2_Cursor + ',') = 0 And -- O servico nao esta na lista dos permitidos
	         @CD_UD is not null
	         Begin
	
	             Set @NR_Quantidade = 0 
	
	             Select @NR_Quantidade = count(cd_sequencial)
						From  consultas as t1
						Where T1.cd_sequencial_dep in
						(
							select cd_sequencial2 from DependenteCorrelacionado where cd_sequencial1 = @CD_Sequencial_Dep
							union
							select cd_sequencial1 from DependenteCorrelacionado where cd_sequencial2 = @CD_Sequencial_Dep
							union
							select @CD_Sequencial_Dep
						)
						and
	                          CD_UD = @CD_UD And
	                          (DT_SERVICO Is Not NUll or Status in (1)) And
	                          dt_cancelamento is null And
	                          status not in (4,7,10) And
	                          cd_servico <> 80000500 And
	                          CD_Sequencial <> @ChavePrimaria And
		                      CHARINDEX(',' + convert(varchar,CD_Servico) + ',',',' + @CD_Dado1_Cursor + ',') > 0
	
		         If @NR_Quantidade > 0                  
						  Begin
	
				if (@DS_Mensagem <> '')
					Set @DS_Mensagem += '©'
	
					if (@mensagemAmigavel is not null)
						begin
							Set @DS_Mensagem += '18;REGRA 18: ' + @mensagemAmigavel
						end
					else
						begin
							Set @DS_Mensagem += '18;REGRA 18: O dente que possui o procedimento ' + @CD_Dado1_Cursor + ' só pode conter o procedimento ' + @CD_Dado2_Cursor + ' informado para o mesmo.'
						end
					
	                 		 If @Operacao = 3 -- Consultas TEMP
							      Begin
									Set @FinalTransacao = 2
								  End
							   Else
								  Begin
									set @FinalTransacao = 3
								  End  
						  End   
		         
	       End
	       FETCH NEXT FROM cursor_018 INTO @CD_Dado1_Cursor,@CD_Dado2_Cursor, @mensagemAmigavel
	      	
	    END
	    Close cursor_018
	    DEALLOCATE cursor_018



    -----------------------------------------------------------------------------------------------
    -- REGRA 19 : Procedimentos precisam ter face cadastrada , seja ela qual for

if(CHARINDEX(',19,',',' + @regras + ',') > 0)
	begin
	    Declare cursor_019 Cursor For          
	    Select cd_servico, mensagemAmigavel From TB_Regra_Servico Where Codigo_Regra = 19
	    and CHARINDEX(',' + convert(varchar(10),@cd_centro_custo) + ',', ',' + isnull(centro_custo,convert(varchar(10),@cd_centro_custo)) + ',') > 0
	    and CHARINDEX(',' + convert(varchar(10),@CD_PLANO) + ',', ',' + isnull(plano,convert(varchar(10),@CD_PLANO)) + ',') > 0
	
		OPEN cursor_019
		FETCH NEXT FROM cursor_019 INTO @CD_Dado1_Cursor, @mensagemAmigavel
	
		-- Inicio do Loop.
		WHILE (@@FETCH_STATUS <> -1)
		BEGIN
	
	      If CHARINDEX(',' + Convert(varchar(10),@CD_Servico) + ',',',' + @CD_Dado1_Cursor + ',') > 0 And
	       (@Mesial + @Vestibular + @Lingual + @Distal + @Oclusal) = 0
	       Begin
	           
		if (@DS_Mensagem <> '')
			Set @DS_Mensagem += '©'
			
			if (@mensagemAmigavel is not null)
				begin
					Set @DS_Mensagem += '19;REGRA 19: ' + @mensagemAmigavel
				end
			else
				begin
					Set @DS_Mensagem += '19;REGRA 19: O procedimento ' + @CD_Dado1_Cursor + ' precisa de face informada.'
				end
			
	     		 If @Operacao = 3 -- Consultas TEMP
				      Begin
						Set @FinalTransacao = 2
					  End
				   Else
					  Begin
						set @FinalTransacao = 3
					  End  
	       End
	
		   FETCH NEXT FROM cursor_019 INTO @CD_Dado1_Cursor, @mensagemAmigavel
	    END
	 Close cursor_019
	 DEALLOCATE cursor_019
	end




  -----------------------------------------------------------------------------------------------
    -- REGRA 20 : Procedimentos precisam ter uma face cadastrada , seja ela qual for

if(CHARINDEX(',20,',',' + @regras + ',') > 0)
	begin
	    Declare cursor_020 Cursor For          
	    Select cd_servico, mensagemAmigavel From TB_Regra_Servico Where Codigo_Regra = 20
	    and CHARINDEX(',' + convert(varchar(10),@cd_centro_custo) + ',', ',' + isnull(centro_custo,convert(varchar(10),@cd_centro_custo)) + ',') > 0
	    and CHARINDEX(',' + convert(varchar(10),@CD_PLANO) + ',', ',' + isnull(plano,convert(varchar(10),@CD_PLANO)) + ',') > 0
	
		OPEN cursor_020
		FETCH NEXT FROM cursor_020 INTO @CD_Dado1_Cursor, @mensagemAmigavel
	
		-- Inicio do Loop.
		WHILE (@@FETCH_STATUS <> -1)
		BEGIN
	
	      If CHARINDEX(',' + Convert(varchar(10),@CD_Servico) + ',',',' + @CD_Dado1_Cursor + ',') > 0 And
	       (@Mesial + @Vestibular + @Lingual + @Distal + @Oclusal) <> 1
	       Begin
	
		if (@DS_Mensagem <> '')
			Set @DS_Mensagem += '©'
			
			if (@mensagemAmigavel is not null)
				begin
					Set @DS_Mensagem += '20;REGRA 20: ' + @mensagemAmigavel
				end
			else
				begin
					Set @DS_Mensagem += '20;REGRA 20: O procedimento ' + @CD_Dado1_Cursor + ' só pode ter uma face informada.'
				end
			
	     		 If @Operacao = 3 -- Consultas TEMP
				      Begin
						Set @FinalTransacao = 2
					  End
				   Else
					  Begin
						set @FinalTransacao = 3
					  End  
	       End
	       FETCH NEXT FROM cursor_020 INTO @CD_Dado1_Cursor, @mensagemAmigavel
	    END
	 Close cursor_020
	 DEALLOCATE cursor_020
	end


 
-----------------------------------------------------------------------------------------------
    -- REGRA 21 : Procedimentos precisam ter duas faces cadastrada , seja ela qual for

if(CHARINDEX(',21,',',' + @regras + ',') > 0)
	begin
	    Declare cursor_021 Cursor For          
	    Select cd_servico, mensagemAmigavel From TB_Regra_Servico Where Codigo_Regra = 21
	    and CHARINDEX(',' + convert(varchar(10),@cd_centro_custo) + ',', ',' + isnull(centro_custo,convert(varchar(10),@cd_centro_custo)) + ',') > 0
	    and CHARINDEX(',' + convert(varchar(10),@CD_PLANO) + ',', ',' + isnull(plano,convert(varchar(10),@CD_PLANO)) + ',') > 0
	
		OPEN cursor_021
		FETCH NEXT FROM cursor_021 INTO @CD_Dado1_Cursor, @mensagemAmigavel
	
		-- Inicio do Loop.
		WHILE (@@FETCH_STATUS <> -1)
		BEGIN
	
			If CHARINDEX(',' + Convert(varchar(10),@CD_Servico) + ',',',' + @CD_Dado1_Cursor + ',') > 0 And
			   (@Mesial + @Vestibular + @Lingual + @Distal + @Oclusal) <> 2
			   Begin
	
					if (@DS_Mensagem <> '')
						Set @DS_Mensagem += '©'
						
						if (@mensagemAmigavel is not null)
							begin
								Set @DS_Mensagem += '21;REGRA 21: ' + @mensagemAmigavel
							end
						else
							begin
								Set @DS_Mensagem += '21;REGRA 21: O procedimento ' + @CD_Dado1_Cursor + ' precisa de duas faces informadas.'
							end
						
	     			 If @Operacao = 3 -- Consultas TEMP
						  Begin
							Set @FinalTransacao = 2
						  End
					   Else
						  Begin
							set @FinalTransacao = 3
						  End  
			   End	
	       FETCH NEXT FROM cursor_021 INTO @CD_Dado1_Cursor, @mensagemAmigavel
	    END
	    Close cursor_021
	    DEALLOCATE cursor_021
	end


 
-----------------------------------------------------------------------------------------------
    -- REGRA 22 : Procedimentos precisam ter tres faces cadastradas , seja ela qual for

if(CHARINDEX(',22,',',' + @regras + ',') > 0)
	begin
	    Declare cursor_022 Cursor For          
	    Select cd_servico, mensagemAmigavel From TB_Regra_Servico Where Codigo_Regra = 22
	    and CHARINDEX(',' + convert(varchar(10),@cd_centro_custo) + ',', ',' + isnull(centro_custo,convert(varchar(10),@cd_centro_custo)) + ',') > 0
	    and CHARINDEX(',' + convert(varchar(10),@CD_PLANO) + ',', ',' + isnull(plano,convert(varchar(10),@CD_PLANO)) + ',') > 0
	
		OPEN cursor_022
		FETCH NEXT FROM cursor_022 INTO @CD_Dado1_Cursor, @mensagemAmigavel
	
		-- Inicio do Loop.
		WHILE (@@FETCH_STATUS <> -1)
		BEGIN
	
	      If CHARINDEX(',' + Convert(varchar(10),@CD_Servico) + ',',',' + @CD_Dado1_Cursor + ',') > 0 And
	       (@Mesial + @Vestibular + @Lingual + @Distal + @Oclusal) <> 3
	       Begin
	            
			if (@DS_Mensagem <> '')
				Set @DS_Mensagem += '©'
				
				if (@mensagemAmigavel is not null)
					begin
						Set @DS_Mensagem += '22;REGRA 22: ' + @mensagemAmigavel
					end
				else
					begin
						Set @DS_Mensagem += '22;REGRA 22: O procedimento ' + @CD_Dado1_Cursor + ' precisa de três faces informadas.'
					end
				
	     		 If @Operacao = 3 -- Consultas TEMP
				      Begin
						Set @FinalTransacao = 2
					  End
				   Else
					  Begin
						set @FinalTransacao = 3
					  End  
	       End
	       FETCH NEXT FROM cursor_022 INTO @CD_Dado1_Cursor, @mensagemAmigavel
	    END
	    Close cursor_022
	    DEALLOCATE cursor_022
	end



-----------------------------------------------------------------------------------------------
    -- REGRA 23 : Procedimentos precisam ter quatro faces cadastradas , seja ela qual for

if(CHARINDEX(',23,',',' + @regras + ',') > 0)
	begin
	    Declare cursor_023 Cursor For          
	    Select cd_servico, mensagemAmigavel From TB_Regra_Servico Where Codigo_Regra = 23
	    and CHARINDEX(',' + convert(varchar(10),@cd_centro_custo) + ',', ',' + isnull(centro_custo,convert(varchar(10),@cd_centro_custo)) + ',') > 0
	    and CHARINDEX(',' + convert(varchar(10),@CD_PLANO) + ',', ',' + isnull(plano,convert(varchar(10),@CD_PLANO)) + ',') > 0
	
		OPEN cursor_023
		FETCH NEXT FROM cursor_023 INTO @CD_Dado1_Cursor, @mensagemAmigavel
	
		-- Inicio do Loop.
		WHILE (@@FETCH_STATUS <> -1)
		BEGIN
	
	       If CHARINDEX(',' + Convert(varchar(10),@CD_Servico) + ',',',' + @CD_Dado1_Cursor + ',') > 0 And
	       @CD_UD Is Null
	       
	       Begin
	
			if (@DS_Mensagem <> '')
				Set @DS_Mensagem += '©'
				
				if (@mensagemAmigavel is not null)
					begin
						Set @DS_Mensagem += '23;REGRA 23: ' + @mensagemAmigavel
					end
				else
					begin
						Set @DS_Mensagem += '23;REGRA 23: O procedimento ' + @CD_Dado1_Cursor + ' precisa de quatro faces informadas.'
					end
				
	     		 If @Operacao = 3 -- Consultas TEMP
				      Begin
						Set @FinalTransacao = 2
					  End
				   Else
					  Begin
						set @FinalTransacao = 3
					  End  
	       End
	
	     	FETCH NEXT FROM cursor_023 INTO @CD_Dado1_Cursor, @mensagemAmigavel
	    END
	 Close cursor_023
	 DEALLOCATE cursor_023
	end



-----------------------------------------------------------------------------------------------
    -- REGRA 24 : Procedimentos só pode ser realizado uma vez para determinado dente se existirem outros pendentes 

if(CHARINDEX(',24,',',' + @regras + ',') > 0)
	begin
	    Declare cursor_024 Cursor For          
	    Select cd_servico,cd_servico2, mensagemAmigavel From TB_Regra_Servico Where Codigo_Regra = 24
	    and CHARINDEX(',' + convert(varchar(10),@cd_centro_custo) + ',', ',' + isnull(centro_custo,convert(varchar(10),@cd_centro_custo)) + ',') > 0
	    and CHARINDEX(',' + convert(varchar(10),@CD_PLANO) + ',', ',' + isnull(plano,convert(varchar(10),@CD_PLANO)) + ',') > 0
	
		OPEN cursor_024
		FETCH NEXT FROM cursor_024 INTO @CD_Dado1_Cursor,@CD_Dado2_Cursor, @mensagemAmigavel
	
		-- Inicio do Loop.
		WHILE (@@FETCH_STATUS <> -1)
		BEGIN
	
			If CHARINDEX(',' + Convert(varchar(10),@CD_Servico) + ',',',' + @CD_Dado1_Cursor + ',') > 0 And
			   @CD_UD is Not Null
			   Begin
	
				  Select @NR_Quantidade = count(cd_sequencial) 
					   From   @tempTableConsultas as t1
						Where CHARINDEX(',' + convert(varchar,CD_Servico) + ',',',' + @CD_Dado2_Cursor + ',') > 0 And
							  DT_Servico         is null And
							  CD_UD = @CD_UD     And
							  CD_Sequencial <> @ChavePrimaria
	
		    
				 If @NR_Quantidade > 1 
					 Begin
	
						if (@DS_Mensagem <> '')
							Set @DS_Mensagem += '©'
							
							if (@mensagemAmigavel is not null)
								begin
									Set @DS_Mensagem += '24;REGRA 24: ' + @mensagemAmigavel
								end
							else
								begin
									Set @DS_Mensagem += '24;REGRA 24: Procedimento ' + @CD_Dado1_Cursor + ' não pode ser feito nesse dente, pois só pode ser realizado uma vez para o procedimento pendente ' + @CD_Dado2_Cursor + '.'
								end
							
						   If @Operacao = 3 -- Consultas TEMP
			   				 Begin
							   Set @FinalTransacao = 2
							 End
						   Else
							 Begin
							   Set @FinalTransacao = 3
	            			 End
		  
					 End
			   End
	 
	        FETCH NEXT FROM cursor_024 INTO @CD_Dado1_Cursor,@CD_Dado2_Cursor, @mensagemAmigavel
	    END
	 Close cursor_024
	 DEALLOCATE cursor_024
	end



 --------------------------------------------------------------------------------------------------------------------------
-- REGRA 25 : Procedimentos só pode ser realizado duas vezes para determinado dente se existirem outros pendentes 

if(CHARINDEX(',25,',',' + @regras + ',') > 0)
	begin
	    Declare cursor_025 Cursor For          
	    Select cd_servico,cd_servico2, mensagemAmigavel From TB_Regra_Servico Where Codigo_Regra = 25
	    and CHARINDEX(',' + convert(varchar(10),@cd_centro_custo) + ',', ',' + isnull(centro_custo,convert(varchar(10),@cd_centro_custo)) + ',') > 0
	    and CHARINDEX(',' + convert(varchar(10),@CD_PLANO) + ',', ',' + isnull(plano,convert(varchar(10),@CD_PLANO)) + ',') > 0
	
		OPEN cursor_025
		FETCH NEXT FROM cursor_025 INTO @CD_Dado1_Cursor,@CD_Dado2_Cursor, @mensagemAmigavel
	
		-- Inicio do Loop.
		WHILE (@@FETCH_STATUS <> -1)
		BEGIN
	
	      If CHARINDEX(',' + Convert(varchar(10),@CD_Servico) + ',',',' + @CD_Dado1_Cursor + ',') > 0 And
	       @CD_UD is Not Null
	       Begin
	
	          Select @NR_Quantidade = count(cd_sequencial) 
	               From   @tempTableConsultas as t1
						Where CHARINDEX(',' + convert(varchar,CD_Servico) + ',',',' + @CD_Dado2_Cursor + ',') > 0 And
	                      DT_Servico         is null And
	                      CD_UD = @CD_UD     And
	                      CD_Sequencial <> @ChavePrimaria
	
	    
		     If @NR_Quantidade > 2 
	             Begin
	      
			if (@DS_Mensagem <> '')
				Set @DS_Mensagem += '©'
				
				if (@mensagemAmigavel is not null)
					begin
						Set @DS_Mensagem += '25;REGRA 25: ' + @mensagemAmigavel
					end
				else
					begin
						Set @DS_Mensagem += '25;REGRA 25: Procedimento ' + @CD_Dado1_Cursor + ' não pode ser feito nesse dente, pois esse procedimento só pode ser realizado uma vez para o procedimento pendente ' + @CD_Dado2_Cursor + '.'
					end
				
	                   If @Operacao = 3 -- Consultas TEMP
			   		     Begin
						   Set @FinalTransacao = 2
					     End
				       Else
					     Begin
				           Set @FinalTransacao = 3
	            	     End
	
	             End
	       End
	       	FETCH NEXT FROM cursor_025 INTO @CD_Dado1_Cursor,@CD_Dado2_Cursor, @mensagemAmigavel
	  END
	 Close cursor_025
	 DEALLOCATE cursor_025
	end


 
    --------------------------------------------------------------------------------------------------------------------------
    -- REGRA 26 : Procedimento que só pode ser realizado , se outros tiverem sido realizados no dente

if(CHARINDEX(',26,',',' + @regras + ',') > 0)
	begin
	    Declare cursor_026 Cursor For          
	    Select cd_servico,cd_servico2, mensagemAmigavel From TB_Regra_Servico Where Codigo_Regra = 26
	    and CHARINDEX(',' + convert(varchar(10),@cd_centro_custo) + ',', ',' + isnull(centro_custo,convert(varchar(10),@cd_centro_custo)) + ',') > 0
	    and CHARINDEX(',' + convert(varchar(10),@CD_PLANO) + ',', ',' + isnull(plano,convert(varchar(10),@CD_PLANO)) + ',') > 0
	
		OPEN cursor_026
		FETCH NEXT FROM cursor_026 INTO @CD_Dado1_Cursor,@CD_Dado2_Cursor, @mensagemAmigavel
	
		-- Inicio do Loop.
		WHILE (@@FETCH_STATUS <> -1)
		BEGIN
	
	     If CHARINDEX(',' + Convert(varchar(10),@CD_Servico) + ',',',' + @CD_Dado1_Cursor + ',') > 0 And @CD_UD is Not Null
	       Begin
	
				 Select top 1 @Dt_ProcedimentoBanco = isnull(dt_servico,getdate()+1)  
					From  @tempTableConsultas as t1
						Where CD_UD             = @CD_UD And  
						  CD_Sequencial     <> @ChavePrimaria And
						  CHARINDEX(',' + convert(varchar,CD_Servico) + ',',',' + @CD_Dado2_Cursor + ',') > 0 
				  Order by 1 desc
	
	        	  if @@rowcount = 0 --SE NÃO TIVER NENHUM, CAI NA INCONSISTÊNCIA
						  Begin
	
							if @Dt_ProcedimentoBanco  = getdate()+1
							  Begin 
							if (@DS_Mensagem <> '')
								Set @DS_Mensagem += '©'
								
								if (@mensagemAmigavel is not null)
									begin
										Set @DS_Mensagem += '26;REGRA 26: ' + @mensagemAmigavel
									end
								else
									begin
										Set @DS_Mensagem += '26;REGRA 26: O procedimento ' + @CD_Dado1_Cursor + ' está pendente para ser realizado. Outro procedimento não pode ser realizado nesse dente, pois precisaria do procedimento ' +@CD_Dado2_Cursor + ' informado anteriormente.'
									end
								
							   If @Operacao = 3 -- Consultas TEMP
								  Begin
									Set @FinalTransacao = 2
								  End
							   Else
								  Begin
									set @FinalTransacao = 3
								  End  
							  End 
	
							if @Dt_ProcedimentoBanco is Not null                  
							  Begin
					if (@DS_Mensagem <> '')
						Set @DS_Mensagem += '©'
						
						if (@mensagemAmigavel is not null)
							begin
								Set @DS_Mensagem += '26;REGRA 26: ' + @mensagemAmigavel
							end
						else
							begin
								Set @DS_Mensagem += '26;REGRA 26: Procedimento ' + @CD_Dado1_Cursor + ' não pode ser realizado nesse dente, pois precisaria do procedimento ' + @CD_Dado2_Cursor + ' informado anteriormente.'
							end
						
	        					 If @Operacao = 3 -- Consultas TEMP
								  Begin
									Set @FinalTransacao = 2
								  End
							   Else
								  Begin
									set @FinalTransacao = 3
								  End  
							  End   
						  End
	       End
	
	      FETCH NEXT FROM cursor_026 INTO @CD_Dado1_Cursor,@CD_Dado2_Cursor, @mensagemAmigavel
	
	  END
	 Close cursor_026
	 DEALLOCATE cursor_026
	end


 

-----------------------------------------------------------------------------------------------
-- REGRA 27 : Procedimentos só podem ser realizados após um determinado número de meses

if(CHARINDEX(',27,',',' + @regras + ',') > 0)
	begin
		Declare cursor_027 Cursor For
		
			Select cd_servico, QT_Meses, mensagemAmigavel
			From TB_Regra_Servico
			Where Codigo_Regra = 27
			and CHARINDEX(',' + convert(varchar(10),@cd_centro_custo) + ',', ',' + isnull(centro_custo,convert(varchar(10),@cd_centro_custo)) + ',') > 0
			and CHARINDEX(',' + convert(varchar(10),@CD_PLANO) + ',', ',' + isnull(plano,convert(varchar(10),@CD_PLANO)) + ',') > 0
			and CHARINDEX(',' + Convert(varchar(10),@CD_Servico) + ',',',' + cd_servico + ',') > 0
		
		OPEN cursor_027
		FETCH NEXT FROM cursor_027 INTO @CD_Dado1_Cursor, @CD_Dado3_Cursor, @mensagemAmigavel
		
		WHILE (@@FETCH_STATUS <> -1)
			BEGIN
		
				select top 1 @Dt_ProcedimentoBanco = isnull(dt_servico,getdate()+1)
				From @tempTableConsultas
				where CD_Servico = @CD_Servico
				and CD_Sequencial <> @ChavePrimaria
				and (dt_servico is null or DateDiff(Month,dt_servico,@DT_Atual) < @CD_Dado3_Cursor)
				order by 1 desc
		 
				if @@rowcount > 0
					Begin
						if @Dt_ProcedimentoBanco > getdate()
							Begin
								if (@DS_Mensagem <> '')
									Set @DS_Mensagem += '©'
						
									if (@mensagemAmigavel is not null)
										begin
											Set @DS_Mensagem += '27;REGRA 27: ' + @mensagemAmigavel
										end
									else
										begin
											Set @DS_Mensagem += '27;REGRA 27: O procedimento ' + @CD_Dado1_Cursor + ' está pendente para ser realizado. O procedimento só pode ser realizado a cada ' + convert(varchar,@CD_Dado3_Cursor)  + ' mês(es).'
										end
				       
									If @Operacao = 3 -- Consultas TEMP
										Begin
											Set @FinalTransacao = 1
										End
									Else
										Begin
											Set @FinalTransacao = 3
										End
									End
		
						Else If DateDiff(Month,@Dt_ProcedimentoBanco,@DT_Atual) < @CD_Dado3_Cursor
							Begin
								if (@DS_Mensagem <> '')
									Set @DS_Mensagem += '©'
		
									if (@mensagemAmigavel is not null)
										begin
											Set @DS_Mensagem += '27;REGRA 27: ' + @mensagemAmigavel
										end
									else
										begin
											Set @DS_Mensagem += '27;REGRA 27: Procedimento ' + @CD_Dado1_Cursor + ' só pode ser realizado a cada ' + convert(varchar,@CD_Dado3_Cursor) + ' mês(es). Data do último procedimento: ' + Convert(varchar,@Dt_ProcedimentoBanco,103) + '.'
										end
							
									If @Operacao = 3 -- Consultas TEMP
										Begin
											Set @FinalTransacao = 1
										End
									Else
										Begin
											set @FinalTransacao = 3
										End
							End
					End
		
				FETCH NEXT FROM cursor_027 INTO @CD_Dado1_Cursor,@CD_Dado3_Cursor, @mensagemAmigavel
			END
		Close cursor_027
		DEALLOCATE cursor_027
	end

-----------------------------------------------------------------------------------------------
-- REGRA 28 : Procedimento só pode ser realizado determinado número de vezes em determinado número de meses (se não informado: 12 meses)
-----------------------------------------------------------------------------------------------

if(CHARINDEX(',28,',',' + @regras + ',') > 0)
	begin
		Declare cursor_028 Cursor For          
			Select cd_servico, Numero, isnull(QT_Meses,12), mensagemAmigavel
			From TB_Regra_Servico
			Where Codigo_Regra = 28
			and CHARINDEX(',' + convert(varchar(10),@cd_centro_custo) + ',', ',' + isnull(centro_custo,convert(varchar(10),@cd_centro_custo)) + ',') > 0
			and CHARINDEX(',' + convert(varchar(10),@CD_PLANO) + ',', ',' + isnull(plano,convert(varchar(10),@CD_PLANO)) + ',') > 0
		OPEN cursor_028
		FETCH NEXT FROM cursor_028 INTO @CD_Dado1_Cursor,@CD_Dado3_Cursor,@CD_Dado4_Cursor, @mensagemAmigavel
		WHILE (@@FETCH_STATUS <> -1)
			BEGIN
				If CHARINDEX(',' + Convert(varchar(10),@CD_Servico) + ',',',' + @CD_Dado1_Cursor + ',') > 0 
						Begin
							Select @NR_Quantidade = Count(cd_sequencial)
							From @tempTableConsultas as t1
							Where CD_Servico = @CD_Servico
							And isnull(DT_Servico,getdate()) >= dateadd(month,-1*@CD_Dado4_Cursor,Getdate())
							And CD_Sequencial <> @ChavePrimaria
	                   
							if @NR_Quantidade >= @CD_Dado3_Cursor
								Begin
									if (@DS_Mensagem <> '')
										Set @DS_Mensagem += '©'
										if (@mensagemAmigavel is not null)
											begin
												Set @DS_Mensagem += '28;REGRA 28: ' + @mensagemAmigavel
											end
										else
											begin
												Set @DS_Mensagem += '28;REGRA 28: O procedimento ' + Convert(varchar(10),@CD_Servico) + ' só pode ser realizado ' + convert(varchar(10),@CD_Dado3_Cursor) + ' vez(es) a cada ' + convert(varchar(10),@CD_Dado4_Cursor) + ' mês(es).'
											end
											If @Operacao = 3 -- Consultas TEMP
												  Begin
													Set @FinalTransacao = 1
												  End
											   Else
												  Begin
													set @FinalTransacao = 3
												  End  
											End
								End
			FETCH NEXT FROM cursor_028 INTO @CD_Dado1_Cursor,@CD_Dado3_Cursor,@CD_Dado4_Cursor, @mensagemAmigavel
		END
	Close cursor_028
	DEALLOCATE cursor_028
end

-----------------------------------------------------------------------------------------------
    -- REGRA 29 : Procedimento só pode ser executado uma vez e tem de ter plano ortodontico

if(CHARINDEX(',29,',',' + @regras + ',') > 0)
	begin
	    Declare cursor_029 Cursor For          
	    Select cd_servico, mensagemAmigavel From TB_Regra_Servico Where Codigo_Regra = 29
	    and CHARINDEX(',' + convert(varchar(10),@cd_centro_custo) + ',', ',' + isnull(centro_custo,convert(varchar(10),@cd_centro_custo)) + ',') > 0
	    and CHARINDEX(',' + convert(varchar(10),@CD_PLANO) + ',', ',' + isnull(plano,convert(varchar(10),@CD_PLANO)) + ',') > 0
	
		OPEN cursor_029
		FETCH NEXT FROM cursor_029 INTO @CD_Dado1_Cursor, @mensagemAmigavel
	
		-- Inicio do Loop.
		WHILE (@@FETCH_STATUS <> -1)
		BEGIN
	
	         If CHARINDEX(',' + Convert(varchar(10),@CD_Servico) + ',',',' + @CD_Dado1_Cursor + ',') > 0 
	             Begin
	                  
	                  print 'Entrei'
	                  Select  @NR_Quantidade = Count(cd_sequencial)
		                From  @tempTableConsultas as t1
						Where CD_Servico = @CD_Servico        And
	                          CD_Sequencial     <> @ChavePrimaria
	                          
	                 print 'Qtde'
	                 print @NR_Quantidade
	                 print 'Qtde2'
	                   
	                 if @NR_Quantidade >= 1 
	                  Begin
			if (@DS_Mensagem <> '')
				Set @DS_Mensagem += '©'
				
				if (@mensagemAmigavel is not null)
					begin
						Set @DS_Mensagem += '29;REGRA 29: ' + @mensagemAmigavel
					end
				else
					begin
						Set @DS_Mensagem += '29;REGRA 29: O procedimento ' + Convert(varchar(10),@CD_Servico) + ' só pode ser realizado uma única vez.'
					end
				
	                    If @Operacao = 3 -- Consultas TEMP
							  Begin
								Set @FinalTransacao = 1
							  End
						   Else
							  Begin
								set @FinalTransacao = 3
							  End  
	                  End
	              End
	        FETCH NEXT FROM cursor_029 INTO @CD_Dado1_Cursor, @mensagemAmigavel
	    END
	Close cursor_029
	DEALLOCATE cursor_029
	end


    ---------------------- PROCEDIMENTOS INATIVOS ----------------------------------------------------------------------------------------------

    If @TP_Procedimento = 5 And (DateDiff(day,@DT_Servico,getdate())=0 Or @DT_Servico is null)
          Begin
	if (@DS_Mensagem <> '')
		Set @DS_Mensagem += '©'
             Set @DS_Mensagem += '31;Procedimento ' + convert(varchar(20),@CD_Servico)  + ' inativo.'
			If @Operacao = 3 -- Consultas TEMP
				  Begin
					Set @FinalTransacao = 2
				  End
			   Else
				  Begin
					set @FinalTransacao = 3
				  End               

          End 
          
    --------------------------------Testes Somente da Odontoart------------------------------------------------------------------------------------
   
         If @CD_Servico = 84000074 And @ChavePrimaria is not null And @DT_Servico is not null
            Begin
            
                 --Pagando agenda atual
                 Declare @cd_sequencial_agenda int
                 
                 Select @cd_sequencial_agenda from @tempTableConsultas where cd_sequencial = @ChavePrimaria
                          
				 -- O procedimento 84000074  - Aplicação de selante de fóssulas e fissuras 
				 -- pode ser baixado 2 procedimentos na mesma agenda entretando o segundo 
				 --deve ser GLOSADO sem pagamento. VAI CAIR NA INCOSISTENCIA.
		   		 Select @NR_Quantidade = count(t1.cd_sequencial) 
					From   @tempTableConsultas t1 
					Where T1.CD_Servico = @CD_Servico          And 
                           cd_sequencial_agenda = @cd_sequencial_agenda And
                           DT_Servico is not null
                           
                 If @NR_Quantidade >= 2
                   Begin
			if (@DS_Mensagem <> '')
				Set @DS_Mensagem += '©'
				Set @DS_Mensagem += '31;Duas aplicações de selantes de fóssulas e fissuras não podem ser baixadas na mesma agenda.'				
				
                      If @Operacao = 3 -- Consultas TEMP
						  Begin
							Set @FinalTransacao = 2
						  End
					   Else
						  Begin
					        Set @FinalTransacao = 3
                    	  End  

                   End       
		    End
		    
            --Em procedimentos de Ortodontia deve ser observado se o cliente já foi 
            --atendido no mês corrente para qualquer procedimento ORTO em 
            --QUALQUER DENTISTA cujo procedimento tenha VALOR. 
            --CASO sim deixar na INCONSISTENCIA por ASSOCIADO JÁ ATENDIDO EM ORTO NO MÊS.

            if @LicencaS4E not in ('GF24DFDSDS67562E3DSHGFDASASF65634343878SDSHGHD004')
		begin
	             select @TP_Procedimento = case when COUNT(0) >= 1 then 4 else 0 end 
	               from servicoespecialidade 
	              where cd_especialidade in (select cd_especialidade from ESPECIALIDADE where fl_ortodontia=1) and 
	                    cd_servico in (@CD_Servico)             
	                   
				  If @TP_Procedimento = 4 And @DT_Servico is not null and @CD_Servico not in (80000131,80001188,80001323,80000001,81000065,81000421)
					  Begin
					 
			     		 Select  @NR_Quantidade = count(t1.cd_sequencial) 
			 			  From   @tempTableConsultas t1 
						Where DT_Servico            Is not null            And
	                             Month(DT_Servico)     = Month(@DT_Servico)     And
	                             Year(DT_Servico)      = Year(@DT_Servico)      And
	                             t1.cd_servico in (select e100.cd_servico 
	                                                 from SERVICOespecialidade as e100, tabela_servicos as t100 , funcionario as f100
	                                                where e100.cd_especialidade in (select cd_especialidade from ESPECIALIDADE where fl_ortodontia=1) and 
	                                                      f100.cd_funcionario = t1.cd_funcionario and 
	                                                      f100.cd_tabela = t100.cd_tabela and 
	                                                      e100.cd_servico=t100.cd_servico and 
	                                                      t100.vl_servico>0 and 
	                                                      e100.CD_Servico not in (80000131,80001188,80001323,80000001,81000065,81000421) 
	                                               )
	                             
	                             
	                             --T1.CD_Servico         = @CD_Servico          And 
	                             --(Select vl_servico from tabela_servicos 
	                             --   where cd_tabela = (select cd_tabela from funcionario t100 where t100.cd_funcionario = t1.cd_funcionario) And
	                             --         cd_servico = @CD_Servico) > 0 
	                                   
	                If @NR_Quantidade >= 2
	                   Begin
				if (@DS_Mensagem <> '')
					Set @DS_Mensagem += '©'
					Set @DS_Mensagem += '31;Dois procedimentos ortodônticos não podem ser baixados no mesmo mês.'
					
	                      If @Operacao = 3 -- Consultas TEMP
							  Begin
								Set @FinalTransacao = 2
							  End
						  Else
							  Begin
						        Set @FinalTransacao = 3
	                    	  End  

	                   End 
	                                        
	            	  End 
		end

-----------------------------------------------------------------------------------------------
    -- REGRA 33 : Em processo de auditoria

if(CHARINDEX(',33,',',' + @regras + ',') > 0)
	begin
	    Declare cursor_033 Cursor For          
	    Select cd_servico, mensagemAmigavel From TB_Regra_Servico Where Codigo_Regra = 33
	    and CHARINDEX(',' + convert(varchar(10),@cd_centro_custo) + ',', ',' + isnull(centro_custo,convert(varchar(10),@cd_centro_custo)) + ',') > 0
	    and CHARINDEX(',' + convert(varchar(10),@CD_PLANO) + ',', ',' + isnull(plano,convert(varchar(10),@CD_PLANO)) + ',') > 0
	
		OPEN cursor_033
		FETCH NEXT FROM cursor_033 INTO @CD_Dado1_Cursor, @mensagemAmigavel
	
		-- Inicio do Loop.
		WHILE (@@FETCH_STATUS <> -1)
		BEGIN
			 If CHARINDEX(',' + Convert(varchar(10),@CD_Servico) + ',',',' + @CD_Dado1_Cursor + ',') > 0
				 Begin
				if (@DS_Mensagem <> '')
					Set @DS_Mensagem += '©'
					
					if (@mensagemAmigavel is not null)
						begin
							Set @DS_Mensagem += '33;REGRA 33: ' + @mensagemAmigavel
						end
					else
						begin
							Set @DS_Mensagem += '33;REGRA 33: O procedimento ' + Convert(varchar(10),@CD_Servico) + ' precisa de liberação manual.' 
						end
					
				   If @Operacao = 3 -- Consultas TEMP
					  Begin
						Set @FinalTransacao = 1
					  End
				   Else
					  Begin
						Set @FinalTransacao = 3
					   End  
				  End
	        FETCH NEXT FROM cursor_033 INTO @CD_Dado1_Cursor, @mensagemAmigavel
	    END
	Close cursor_033
	DEALLOCATE cursor_033   
	end




-------------------------------------------------------------------------------------------------

   -- Regra 34 : Procedimentos só podem ser feitos depois de um determinado periodo para o mesmo cliente, exceto procedimento lançado
   -- Qualquer procedimento lançado nesse grupo que nao seja o mesmo procedimento será barrado
   -- Exemplo : Profilaxia + Rasp Sub + Rasp Supra .. Se ja tem lancado a Profilaxia o sistema barra a Supra e Sub porem deixa passar a Profilaxia

if(CHARINDEX(',34,',',' + @regras + ',') > 0)
	begin
	    Declare cursor_034 Cursor For          
	    Select cd_servico,QT_Meses, mensagemAmigavel From TB_Regra_Servico Where Codigo_Regra = 34
	    and CHARINDEX(',' + convert(varchar(10),@cd_centro_custo) + ',', ',' + isnull(centro_custo,convert(varchar(10),@cd_centro_custo)) + ',') > 0
	    and CHARINDEX(',' + convert(varchar(10),@CD_PLANO) + ',', ',' + isnull(plano,convert(varchar(10),@CD_PLANO)) + ',') > 0
	
		OPEN cursor_034
		FETCH NEXT FROM cursor_034 INTO @CD_Dado1_Cursor,@CD_Dado3_Cursor, @mensagemAmigavel
	
		-- Inicio do Loop.
		WHILE (@@FETCH_STATUS <> -1)
		BEGIN
	
	
	         If CHARINDEX(',' + Convert(varchar(10),@CD_Servico) + ',',',' + @CD_Dado1_Cursor + ',') > 0
	             Begin
	             -- Remover o codigo do servico da lista pois ele pode ser duplicado
	               Set @CD_Dado2_Cursor = replace(replace(@CD_Dado1_Cursor,Convert(varchar(10),@CD_Servico),''),',,',',')  
	               
	               --- Observar primeiro se não tem procedimento pendente.
	               --- Procedimento estando pendente, não pode entrar outro pendente ou realizado.
	              Select top 1 @Dt_ProcedimentoBanco = isnull(dt_servico,getdate()+1)  
		                From  @tempTableConsultas as t1
						Where CHARINDEX(',' + convert(varchar,CD_Servico) + ',',',' + @CD_Dado2_Cursor + ',') > 0 And
	                          CD_Sequencial     <> @ChavePrimaria
	               order by 1 desc
	
	              if @@rowcount >0 
	                  Begin
	     				if @Dt_ProcedimentoBanco  > getdate()
	                      Begin 
				if (@DS_Mensagem <> '')
					Set @DS_Mensagem += '©'
	                       Set @DS_Mensagem += '34;REGRA 34: O procedimento ' + @CD_Dado1_Cursor + ' está pendente para ser realizado. O procedimento só pode ser realizado a cada ' + convert(varchar,@CD_Dado3_Cursor)  + ' mês(es).' 
	                       If @Operacao = 3 -- Consultas TEMP
							  Begin
								Set @FinalTransacao = 1
							  End
						   Else
							  Begin
	      				        Set @FinalTransacao = 3
					           End  
	                      End 
	
	                    If DateDiff(Month,@Dt_ProcedimentoBanco,@DT_Atual) < @CD_Dado3_Cursor                  
	                      Begin
				if (@DS_Mensagem <> '')
					Set @DS_Mensagem += '©'
					
					if (@mensagemAmigavel is not null)
						begin
							Set @DS_Mensagem += '34;REGRA 34: ' + @mensagemAmigavel
						end
					else
						begin
							Set @DS_Mensagem += '34;REGRA 34: Somente um dos procedimentos ' + @CD_Dado1_Cursor + ' pode ser realizado a cada ' + convert(varchar,@CD_Dado3_Cursor) + ' mês(es). Data do último procedimento: ' + Convert(varchar,@Dt_ProcedimentoBanco,103) + '.'
						end
					
	                         If @Operacao = 3 -- Consultas TEMP
								  Begin
									Set @FinalTransacao = 1
								  End
							   Else
								  Begin
									set @FinalTransacao = 3
								  End  
	                      End   
	                  End
	              End
	        FETCH NEXT FROM cursor_034 INTO @CD_Dado1_Cursor,@CD_Dado3_Cursor, @mensagemAmigavel
	    END
	Close cursor_034
	DEALLOCATE cursor_034   
	end

	--REGRA 35: Restriçao de Rede
	if (select count(0) from Plano_Rede where cd_plano = @CD_Plano) > 0
		begin
			if (
				select count(0)
				from Plano_Rede T1
				inner join @tempTableConsultas T2 on T2.cd_filial = T1.cd_filial
				inner join servico T3 on T3.cd_servico = T2.cd_servico
				where T1.cd_plano = @CD_Plano
				and T2.cd_sequencial = @ChavePrimaria
				and (isnull(T1.cd_especialidade,T3.cd_especialidadereferencia) = T3.cd_especialidadereferencia or (select count(0) from especialidade where cd_especialidade = T3.cd_especialidadereferencia and fl_avaliadignostico_regra34 = 1) > 0)
			) = 0
			begin
				if (@DS_Mensagem <> '')
					Set @DS_Mensagem += '©'
				
				if (@mensagemAmigavel is not null)
					begin
						Set @DS_Mensagem += '35;REGRA 35: ' + @mensagemAmigavel
					end
				else
					begin
						Set @DS_Mensagem += '35;REGRA 35: Rede inválida para esse procedimento.'
				end

				If @Operacao = 3 -- Consultas TEMP
					Begin
						Set @FinalTransacao = 2
					End
				Else
					Begin
						Set @FinalTransacao = 3
					End
			end
		end


   -- Regra 36 : Apenas um dos procedimentos pode ser feito em determinado periodo para o mesmo cliente
   -- Qualquer procedimento lançado nesse grupo que nao seja o mesmo procedimento será barrado
   -- Exemplo : Profilaxia + Rasp Sub + Rasp Supra .. Se ja tem lancado a Profilaxia o sistema barra a Supra e Sub porem deixa passar a Profilaxia

if(CHARINDEX(',36,',',' + @regras + ',') > 0)
	begin
	    Declare cursor_036 Cursor For          
	    Select cd_servico,QT_Meses, mensagemAmigavel From TB_Regra_Servico Where Codigo_Regra = 36
	    and CHARINDEX(',' + convert(varchar(10),@cd_centro_custo) + ',', ',' + isnull(centro_custo,convert(varchar(10),@cd_centro_custo)) + ',') > 0
	    and CHARINDEX(',' + convert(varchar(10),@CD_PLANO) + ',', ',' + isnull(plano,convert(varchar(10),@CD_PLANO)) + ',') > 0
	
		OPEN cursor_036
		FETCH NEXT FROM cursor_036 INTO @CD_Dado1_Cursor,@CD_Dado3_Cursor, @mensagemAmigavel
	
		-- Inicio do Loop.
		WHILE (@@FETCH_STATUS <> -1)
		BEGIN
	
	
	         If CHARINDEX(',' + Convert(varchar(10),@CD_Servico) + ',',',' + @CD_Dado1_Cursor + ',') > 0
	             Begin
	               --- Observar primeiro se não tem procedimento pendente.
	               --- Procedimento estando pendente, não pode entrar outro pendente ou realizado.
	              Select top 1 @Dt_ProcedimentoBanco = isnull(dt_servico,getdate()+1)  
		                From  @tempTableConsultas as t1
						Where CHARINDEX(',' + convert(varchar,CD_Servico) + ',',',' + @CD_Dado1_Cursor + ',') > 0 And
	                          CD_Sequencial     <> @ChavePrimaria
	               order by 1 desc
	
	              if @@rowcount >0 
	                  Begin
	     				if @Dt_ProcedimentoBanco  > getdate()
	                      Begin 
				if (@DS_Mensagem <> '')
					Set @DS_Mensagem += '©'
					
					if (@mensagemAmigavel is not null)
						begin
							Set @DS_Mensagem += '36;REGRA 36: ' + @mensagemAmigavel
						end
					else
						begin
							Set @DS_Mensagem += '36;REGRA 36: O procedimento ' + @CD_Dado1_Cursor + ' está pendente para ser realizado. O procedimento só pode ser realizado a cada ' + convert(varchar,@CD_Dado3_Cursor)  + ' mês(es).'
						end
	                       
	                       If @Operacao = 3 -- Consultas TEMP
							  Begin
								Set @FinalTransacao = 1
							  End
						   Else
							  Begin
	      				        Set @FinalTransacao = 3
					           End  
	                      End 
	
	                    If DateDiff(Month,@Dt_ProcedimentoBanco,@DT_Atual) < @CD_Dado3_Cursor                  
	                      Begin
				if (@DS_Mensagem <> '')
					Set @DS_Mensagem += '©'
					
					if (@mensagemAmigavel is not null)
						begin
							Set @DS_Mensagem += '36;REGRA 36: ' + @mensagemAmigavel
						end
					else
						begin
							Set @DS_Mensagem += '36;REGRA 36: Somente um dos procedimentos ' + @CD_Dado1_Cursor + ' pode ser realizado a cada ' + convert(varchar,@CD_Dado3_Cursor) + ' mês(es). Data do último procedimento: ' + Convert(varchar,@Dt_ProcedimentoBanco,103) + '.'
						end
					
	                         If @Operacao = 3 -- Consultas TEMP
								  Begin
									Set @FinalTransacao = 1
								  End
							   Else
								  Begin
									set @FinalTransacao = 3
								  End  
	                      End   
	                  End
	              End
	        FETCH NEXT FROM cursor_036 INTO @CD_Dado1_Cursor,@CD_Dado3_Cursor, @mensagemAmigavel
	    END
	Close cursor_036
	DEALLOCATE cursor_036   
	end


   
   
   
   
-----------------------------------------------------------------------------------------------
    -- REGRA 38 : Procedimentos só podem ser feitos depois de um determinado numero de mês(es) no mesmo prestador

if(CHARINDEX(',38,',',' + @regras + ',') > 0)
	begin
	    Declare cursor_038 Cursor For          
	    Select cd_servico,QT_Meses, mensagemAmigavel From TB_Regra_Servico Where Codigo_Regra = 38
	    and CHARINDEX(',' + convert(varchar(10),@cd_centro_custo) + ',', ',' + isnull(centro_custo,convert(varchar(10),@cd_centro_custo)) + ',') > 0
	    and CHARINDEX(',' + convert(varchar(10),@CD_PLANO) + ',', ',' + isnull(plano,convert(varchar(10),@CD_PLANO)) + ',') > 0
	
		OPEN cursor_038
		FETCH NEXT FROM cursor_038 INTO @CD_Dado1_Cursor,@CD_Dado3_Cursor, @mensagemAmigavel
	
		-- Inicio do Loop.
		WHILE (@@FETCH_STATUS <> -1)
		BEGIN
	
	        If CHARINDEX(',' + Convert(varchar(10),@CD_Servico) + ',',',' + @CD_Dado1_Cursor + ',') > 0 
	             Begin
	               --- Observar primeiro se não tem procedimento pendente.
	               --- Procedimento estando pendente, não pode entrar outro pendente ou realizado.
	               
	              Select top 1 @Dt_ProcedimentoBanco = isnull(dt_servico,getdate()+1)  
	                      From  @tempTableConsultas as t1
						Where CD_Servico        = @CD_Servico And
	                            cd_funcionario    = @CD_Funcionario and 
	                            CD_Sequencial     <> @ChavePrimaria and 
	                           (dt_servico is null or dt_servico >= dateadd(month,@CD_Dado3_Cursor * -1,getdate()))
	            
	              if @@rowcount >0 
	                  Begin
	     				if @Dt_ProcedimentoBanco  > getdate()
	                      Begin 
				if (@DS_Mensagem <> '')
					Set @DS_Mensagem += '©'
					
					if (@mensagemAmigavel is not null)
						begin
							Set @DS_Mensagem += '38;REGRA 38: ' + @mensagemAmigavel
						end
					else
						begin
							Set @DS_Mensagem += '38;REGRA 38: O procedimento ' + Convert(varchar(10),@CD_Servico) + ' está pendente para ser realizado. O procedimento só pode ser realizado a cada ' + convert(varchar,@CD_Dado3_Cursor) + ' mês(es) para o mesmo prestador.'
						end
					
	                       If @Operacao = 3 -- Consultas TEMP
							  Begin
								Set @FinalTransacao = 1
							  End
						   Else
							  Begin
	      				        Set @FinalTransacao = 3
					           End  
	                      End 
	
	                    If DateDiff(Month,@Dt_ProcedimentoBanco,@DT_Atual) < @CD_Dado3_Cursor                  
	                      Begin
				if (@DS_Mensagem <> '')
					Set @DS_Mensagem += '©'
					
					if (@mensagemAmigavel is not null)
						begin
							Set @DS_Mensagem += '38;REGRA 38: ' + @mensagemAmigavel
						end
					else
						begin
							Set @DS_Mensagem += '38;REGRA 38: Procedimento ' + Convert(varchar(10),@CD_Servico) + ' só pode ser realizado a cada ' + convert(varchar,@CD_Dado3_Cursor) + ' mês(es) para o mesmo prestador. Data do último procedimento: ' + Convert(varchar,@Dt_ProcedimentoBanco,103) + '.'
						end
					
	                         If @Operacao = 3 -- Consultas TEMP
								  Begin
									Set @FinalTransacao = 1
								  End
							   Else
								  Begin
									set @FinalTransacao = 3
								  End  
	                      End   
	                  End
	              End
	        FETCH NEXT FROM cursor_038 INTO @CD_Dado1_Cursor,@CD_Dado3_Cursor, @mensagemAmigavel
	    END
	    Close cursor_038
	    DEALLOCATE cursor_038
	end

  

-----------------------------------------------------------------------------------------------
-- REGRA 40 : Procedimentos só podem ser realizados após um determinado número de meses (Boca, dente, região)

if(CHARINDEX(',40,',',' + @regras + ',') > 0)
	begin
		Declare cursor_040 Cursor For
		
			select cd_servico, QT_Meses, mensagemAmigavel
			From TB_Regra_Servico
			Where Codigo_Regra = 40
			and CHARINDEX(',' + convert(varchar(10),@cd_centro_custo) + ',', ',' + isnull(centro_custo,convert(varchar(10),@cd_centro_custo)) + ',') > 0
			and CHARINDEX(',' + convert(varchar(10),@CD_PLANO) + ',', ',' + isnull(plano,convert(varchar(10),@CD_PLANO)) + ',') > 0
			and CHARINDEX(',' + Convert(varchar(10),@CD_Servico) + ',',',' + cd_servico + ',') > 0
		
		OPEN cursor_040
		FETCH NEXT FROM cursor_040 INTO @CD_Dado1_Cursor, @CD_Dado3_Cursor, @mensagemAmigavel
		
		WHILE (@@FETCH_STATUS <> -1)
			BEGIN
			
				select top 1 @Dt_ProcedimentoBanco = isnull(dt_servico,getdate()+1)
				From @tempTableConsultas
				Where CD_Servico = @CD_Servico
				and isnull(isnull(cd_ud,rboId),7) = isnull(isnull(@CD_UD,@regiao),7)
				and CD_Sequencial <> @ChavePrimaria
				and (dt_servico is null or DateDiff(Month,dt_servico,@DT_Atual) < @CD_Dado3_Cursor)
				order by 1 desc
				
				if @@rowcount > 0 
					Begin
						if @Dt_ProcedimentoBanco > getdate()
							Begin
								if (@DS_Mensagem <> '')
									Set @DS_Mensagem += '©'
						
								if (@mensagemAmigavel is not null)
									begin
										Set @DS_Mensagem += '40;REGRA 40: ' + @mensagemAmigavel
									end
								else
									begin
										Set @DS_Mensagem += '40;REGRA 40: O procedimento ' + @CD_Dado1_Cursor + ' está pendente para ser realizado. O procedimento só pode ser realizado a cada ' + convert(varchar,@CD_Dado3_Cursor)  + ' mês(es) para o mesmo dente ou região.'
									end
			       
								If @Operacao = 3 -- Consultas TEMP
									Begin
										Set @FinalTransacao = 1
									End
								Else
									Begin
										Set @FinalTransacao = 3
									End
							End
				
						Else If DateDiff(Month,@Dt_ProcedimentoBanco,@DT_Atual) < @CD_Dado3_Cursor
							Begin
								if (@DS_Mensagem <> '')
									Set @DS_Mensagem += '©'
				
									if (@mensagemAmigavel is not null)
										begin
											Set @DS_Mensagem += '40;REGRA 40: ' + @mensagemAmigavel
										end
									else
										begin
											Set @DS_Mensagem += '40;REGRA 40: Procedimento ' + @CD_Dado1_Cursor + ' só pode ser realizado a cada ' + convert(varchar,@CD_Dado3_Cursor) + ' mês(es) para o mesmo dente ou região. Data do último procedimento: ' + Convert(varchar,@Dt_ProcedimentoBanco,103) + '.'
										end
				
								If @Operacao = 3 -- Consultas TEMP
									Begin
										Set @FinalTransacao = 1
									End
								Else
									Begin
										set @FinalTransacao = 3
								End
							End
					End
			
				FETCH NEXT FROM cursor_040 INTO @CD_Dado1_Cursor, @CD_Dado3_Cursor, @mensagemAmigavel
			END
		Close cursor_040
		DEALLOCATE cursor_040
	end

-----------------------------------------------------------------------------------------------
    -- REGRA 41 : Em processo de auditoria

if(CHARINDEX(',41,',',' + @regras + ',') > 0)
	begin
	    Declare cursor_041 Cursor For         
	    Select cd_servico, mensagemAmigavel From TB_Regra_Servico Where Codigo_Regra = 41
	    and CHARINDEX(',' + convert(varchar(10),@cd_centro_custo) + ',', ',' + isnull(centro_custo,convert(varchar(10),@cd_centro_custo)) + ',') > 0
	    and CHARINDEX(',' + convert(varchar(10),@CD_PLANO) + ',', ',' + isnull(plano,convert(varchar(10),@CD_PLANO)) + ',') > 0
	 
	      OPEN cursor_041
	      FETCH NEXT FROM cursor_041 INTO @CD_Dado1_Cursor, @mensagemAmigavel
	 
	      -- Inicio do Loop.
	      WHILE (@@FETCH_STATUS <> -1)
	      BEGIN
	            If CHARINDEX(',' + Convert(varchar(10),@CD_Servico) + ',',',' + @CD_Dado1_Cursor + ',') > 0
	                  Begin
				if (@DS_Mensagem <> '')
					Set @DS_Mensagem += '©'
					
					if (@mensagemAmigavel is not null)
						begin
							Set @DS_Mensagem += '41;REGRA 41: ' + @mensagemAmigavel
						end
					else
						begin
							Set @DS_Mensagem += '41;REGRA 41: Procedimento em análise pelo setor de contas odontológicas.'
						end
					
	                     If @Operacao = 3 -- Consultas TEMP
	                          Begin
	                             Set @FinalTransacao = 1
	                          End
	                     Else
	                          Begin
	                             Set @FinalTransacao = 3
	                           End 
	                    End
	        FETCH NEXT FROM cursor_041 INTO @CD_Dado1_Cursor, @mensagemAmigavel
	    END
	Close cursor_041
	DEALLOCATE cursor_041  
	end

    -- REGRA 42 : Só pode ser feito 01 dos procedimento em determinado período.

if(CHARINDEX(',42,',',' + @regras + ',') > 0)
	begin
	    Declare cursor_042 Cursor For          
	    Select cd_servico,QT_Meses, mensagemAmigavel From TB_Regra_Servico Where Codigo_Regra = 42
	    and CHARINDEX(',' + convert(varchar(10),@cd_centro_custo) + ',', ',' + isnull(centro_custo,convert(varchar(10),@cd_centro_custo)) + ',') > 0
	    and CHARINDEX(',' + convert(varchar(10),@CD_PLANO) + ',', ',' + isnull(plano,convert(varchar(10),@CD_PLANO)) + ',') > 0
	
		OPEN cursor_042
		FETCH NEXT FROM cursor_042 INTO @CD_Dado1_Cursor,@CD_Dado3_Cursor, @mensagemAmigavel
	
		-- Inicio do Loop.
		WHILE (@@FETCH_STATUS <> -1)
		BEGIN
	
	        If CHARINDEX(',' + Convert(varchar(10),@CD_Servico) + ',',',' + @CD_Dado1_Cursor + ',') > 0 
	             Begin
	               --- Observar primeiro se não tem procedimento pendente.
	               --- Procedimento estando pendente, não pode entrar outro pendente ou realizado.
	               
	              Select top 1 @Dt_ProcedimentoBanco = isnull(dt_servico,getdate()+1)  
	                      From  @tempTableConsultas as t1
						Where CD_Sequencial     <> @ChavePrimaria and 
	                          CD_Servico <> Convert(varchar(10),@CD_Servico) and 
	                         (dt_servico is null or dt_servico >= dateadd(month,@CD_Dado3_Cursor * -1,getdate())) and 
	                          CHARINDEX(',' + convert(varchar,CD_Servico) + ',',',' + @CD_Dado1_Cursor + ',') > 0    
	
	            
	              if @@rowcount >0 
	                  Begin
	     				if @Dt_ProcedimentoBanco  > getdate()
	                      Begin 
				if (@DS_Mensagem <> '')
					Set @DS_Mensagem += '©'
					
					if (@mensagemAmigavel is not null)
						begin
							Set @DS_Mensagem += '42;REGRA 42: ' + @mensagemAmigavel
						end
					else
						begin
							Set @DS_Mensagem += '42;REGRA 42: O procedimento ' + Convert(varchar(10),@CD_Servico) + ' está pendente para ser realizado. O procedimentos '+ @CD_Dado1_Cursor +' só pode ser realizado a cada ' + convert(varchar,@CD_Dado3_Cursor) + ' mês(es).' 
						end
					
	                       If @Operacao = 3 -- Consultas TEMP
							  Begin
								Set @FinalTransacao = 1
							  End
						   Else
							  Begin
	      				        Set @FinalTransacao = 3
					           End  
	                      End 
	
	                    If DateDiff(Month,@Dt_ProcedimentoBanco,@DT_Atual) < @CD_Dado3_Cursor                  
	                      Begin
				if (@DS_Mensagem <> '')
					Set @DS_Mensagem += '©'
					
					if (@mensagemAmigavel is not null)
						begin
							Set @DS_Mensagem += '42;REGRA 42: ' + @mensagemAmigavel
						end
					else
						begin
							Set @DS_Mensagem += '42;REGRA 42: O procedimento '+ @CD_Dado1_Cursor +' só pode ser realizado a cada ' + convert(varchar,@CD_Dado3_Cursor) + ' mês(es).'
						end
					
	    	                 
	                         If @Operacao = 3 -- Consultas TEMP
								  Begin
									Set @FinalTransacao = 1
								  End
							   Else
								  Begin
									set @FinalTransacao = 3
								  End  
	                      End   
	                  End
	              End
	        FETCH NEXT FROM cursor_042 INTO @CD_Dado1_Cursor,@CD_Dado3_Cursor, @mensagemAmigavel
	    END
	    Close cursor_042
	    DEALLOCATE cursor_042
	end

-----------------------------------------------------------------------------------------------
-- REGRA 43 : Procedimentos só podem ser realizados após um determinado número de dias (Boca, dente, região)

if(CHARINDEX(',43,',',' + @regras + ',') > 0)
	begin
		Declare cursor_043 Cursor For
			Select QT_Meses, mensagemAmigavel
			From TB_Regra_Servico
			Where Codigo_Regra = 43
			and CHARINDEX(',' + convert(varchar(10),@cd_centro_custo) + ',', ',' + isnull(centro_custo,convert(varchar(10),@cd_centro_custo)) + ',') > 0
			and CHARINDEX(',' + convert(varchar(10),@CD_PLANO) + ',', ',' + isnull(plano,convert(varchar(10),@CD_PLANO)) + ',') > 0
			and CHARINDEX(',' + Convert(varchar(10),@CD_Servico) + ',',',' + cd_servico + ',') > 0
		
		OPEN cursor_043
		FETCH NEXT FROM cursor_043 INTO @CD_Dado1_Cursor, @mensagemAmigavel
		
		WHILE (@@FETCH_STATUS <> -1)
			BEGIN
		
				select top 1 @Dt_ProcedimentoBanco = isnull(dt_servico,getdate()+1)
				from @tempTableConsultas
				where CD_Servico = @CD_Servico
				and isnull(isnull(cd_ud,rboId),7) = isnull(isnull(@CD_UD,@regiao),7)
				and (dt_servico is null or DateDiff(day,dt_servico,@DT_Atual) < @CD_Dado1_Cursor)
				and CD_Sequencial <> @ChavePrimaria
				order by 1 desc
		 
				if @@rowcount > 0
					Begin
						if @Dt_ProcedimentoBanco > getdate()
							Begin
								if (@DS_Mensagem <> '')
									Set @DS_Mensagem += '©'
									
									if (@mensagemAmigavel is not null)
										begin
											Set @DS_Mensagem += '43;REGRA 43: ' + @mensagemAmigavel
										end
									else
										begin
											Set @DS_Mensagem += '43;REGRA 43: O procedimento ' + Convert(varchar(10),@CD_Servico) + ' está pendente para ser realizado. O procedimento só pode ser realizado a cada ' + convert(varchar,@CD_Dado1_Cursor)  + ' dia(s).'
										end
		
								If @Operacao = 3 -- Consultas TEMP
									Begin
										Set @FinalTransacao = 1
									End
								Else
									Begin
										Set @FinalTransacao = 3
									End
							End
		
						Else
							Begin
								if (@DS_Mensagem <> '')
									Set @DS_Mensagem += '©'
						
									if (@mensagemAmigavel is not null)
										begin
											Set @DS_Mensagem += '43;REGRA 43: ' + @mensagemAmigavel + '. Data do último procedimento: ' + Convert(varchar,@Dt_ProcedimentoBanco,103) + '.'
										end
									else
										begin
											Set @DS_Mensagem += '43;REGRA 43: Procedimento ' + Convert(varchar(10),@CD_Servico) + ' só pode ser realizado a cada ' + convert(varchar,@CD_Dado1_Cursor) + ' dia(s). Data do último procedimento: ' + Convert(varchar,@Dt_ProcedimentoBanco,103) + '.'
										end
						
								If @Operacao = 3 -- Consultas TEMP
									Begin
										Set @FinalTransacao = 1
									End
								Else
									Begin
										set @FinalTransacao = 3
									End
							End
					End
			
				FETCH NEXT FROM cursor_043 INTO @CD_Dado1_Cursor, @mensagemAmigavel
			END
		Close cursor_043
		DEALLOCATE cursor_043
	end

    -----------------------------------------------------------------------------------------------
    -- REGRA 44 : Se já existir procedimento para uma determinada região, outro procedimento não pode ser informado depois de determinados DIAS

if(CHARINDEX(',44,',',' + @regras + ',') > 0)
	begin
	    Declare cursor_044 Cursor For
	    Select cd_servico, QT_Meses, mensagemAmigavel From TB_Regra_Servico Where Codigo_Regra = 44
	    and CHARINDEX(',' + convert(varchar(10),@cd_centro_custo) + ',', ',' + isnull(centro_custo,convert(varchar(10),@cd_centro_custo)) + ',') > 0
	    and CHARINDEX(',' + convert(varchar(10),@CD_PLANO) + ',', ',' + isnull(plano,convert(varchar(10),@CD_PLANO)) + ',') > 0
	
		OPEN cursor_044
		FETCH NEXT FROM cursor_044 INTO @CD_Dado1_Cursor,@CD_Dado2_Cursor, @mensagemAmigavel
	
		WHILE (@@FETCH_STATUS <> -1)
		BEGIN
	
	      If CHARINDEX(',' + Convert(varchar(10),@CD_Servico) + ',',',' + @CD_Dado1_Cursor + ',') > 0 And
	         @regiao is not null
	         Begin
	
	             Set @NR_Quantidade = 0
	
	             Select @NR_Quantidade = count(cd_sequencial)
						From  @tempTableConsultas as t1
						Where rboId = @regiao And
	                          CD_Sequencial     <> @ChavePrimaria And
	                          CHARINDEX(',' + convert(varchar,CD_Servico) + ',',',' + @CD_Dado1_Cursor + ',') > 0 And
	                          (dt_servico is null or dt_servico >= dateadd(day,@CD_Dado2_Cursor * -1,getdate()))
	
		         If @NR_Quantidade > 0
						  Begin
	                        
					if (@DS_Mensagem <> '')
						Set @DS_Mensagem += '©'
						
						if (@mensagemAmigavel is not null)
							begin
								Set @DS_Mensagem += '44;REGRA 44: ' + @mensagemAmigavel
							end
						else
							begin
								Set @DS_Mensagem += '44;REGRA 44: Procedimento ' + Convert(varchar(10),@CD_Servico) + ' não pode ser realizado na região, pois já existe o procedimento ' + @CD_Dado1_Cursor + ' informado na mesma região.'
							end
						
	    					 If @Operacao = 3 -- Consultas TEMP
							      Begin
									Set @FinalTransacao = 2
								  End
							   Else
								  Begin
									set @FinalTransacao = 3
								  End  
						  End   
		         
	          End
	
	          FETCH NEXT FROM cursor_044 INTO @CD_Dado1_Cursor,@CD_Dado2_Cursor, @mensagemAmigavel
	   END
	   Close cursor_044
	   DEALLOCATE cursor_044
	end

    -----------------------------------------------------------------------------------------------
    -- REGRA 45 : Em processo de auditoria

if(CHARINDEX(',45,',',' + @regras + ',') > 0)
	begin
	    Declare cursor_045 Cursor For         
	    Select cd_servico, mensagemAmigavel From TB_Regra_Servico Where Codigo_Regra = 45
	    and CHARINDEX(',' + convert(varchar(10),@cd_centro_custo) + ',', ',' + isnull(centro_custo,convert(varchar(10),@cd_centro_custo)) + ',') > 0
	    and CHARINDEX(',' + convert(varchar(10),@CD_PLANO) + ',', ',' + isnull(plano,convert(varchar(10),@CD_PLANO)) + ',') > 0
	 
	      OPEN cursor_045
	      FETCH NEXT FROM cursor_045 INTO @CD_Dado1_Cursor, @mensagemAmigavel
	 
	      WHILE (@@FETCH_STATUS <> -1)
	      BEGIN
	            If CHARINDEX(',' + Convert(varchar(10),@CD_Servico) + ',',',' + @CD_Dado1_Cursor + ',') > 0
	                  Begin
				if (@DS_Mensagem <> '')
					Set @DS_Mensagem += '©'
					
					if (@mensagemAmigavel is not null)
						begin
							Set @DS_Mensagem += '45;REGRA 45: ' + @mensagemAmigavel
						end
					else
						begin
							Set @DS_Mensagem += '45;REGRA 45: Procedimento aguardando upload de imagem para posterior análise do setor de contas odontológicas.'
						end
	
	                     If @Operacao = 3 -- Consultas TEMP
	                          Begin
	                             Set @FinalTransacao = 1
	                          End
	                     Else
	                          Begin
	                             Set @FinalTransacao = 3
	                           End 
	                    End
	        FETCH NEXT FROM cursor_045 INTO @CD_Dado1_Cursor, @mensagemAmigavel
	    END
		Close cursor_045
		DEALLOCATE cursor_045  
	end
	
    -----------------------------------------------------------------------------------------------
    -- REGRA 46 : Se um procedimento for lançado, outro só poderá ser lançado após determinados DIAS

if(CHARINDEX(',46,',',' + @regras + ',') > 0)
	begin
	    Declare cursor_046 Cursor For
	    Select cd_servico, cd_servico2, QT_Meses, mensagemAmigavel From TB_Regra_Servico Where Codigo_Regra = 46
	    and CHARINDEX(',' + convert(varchar(10),@cd_centro_custo) + ',', ',' + isnull(centro_custo,convert(varchar(10),@cd_centro_custo)) + ',') > 0
	    and CHARINDEX(',' + convert(varchar(10),@CD_PLANO) + ',', ',' + isnull(plano,convert(varchar(10),@CD_PLANO)) + ',') > 0
	
		OPEN cursor_046
		FETCH NEXT FROM cursor_046 INTO @CD_Dado1_Cursor,@CD_Dado2_Cursor,@CD_Dado3_Cursor, @mensagemAmigavel
	
		WHILE (@@FETCH_STATUS <> -1)
		BEGIN
	
	      If CHARINDEX(',' + Convert(varchar(10),@CD_Servico) + ',',',' + @CD_Dado1_Cursor + ',') > 0
	         Begin
	
	             Set @NR_Quantidade = 0
	
	             Select @NR_Quantidade = count(cd_sequencial)
						From  @tempTableConsultas as t1
						Where CD_Sequencial <> @ChavePrimaria And
	                          CHARINDEX(',' + convert(varchar,CD_Servico) + ',',',' + @CD_Dado2_Cursor + ',') > 0 And
	                          (dt_servico is null or dt_servico >= dateadd(day,@CD_Dado3_Cursor * -1,getdate()))
	
		         If @NR_Quantidade > 0
						  Begin
	                        
					if (@DS_Mensagem <> '')
						Set @DS_Mensagem += '©'
						
						if (@mensagemAmigavel is not null)
							begin
								Set @DS_Mensagem += '46;REGRA 46: ' + @mensagemAmigavel
							end
						else
							begin
								Set @DS_Mensagem += '46;REGRA 46: Procedimento ' + Convert(varchar(10),@CD_Servico) + ' não pode ser realizado, pois já existe o procedimento ' + @CD_Dado2_Cursor + ' informado.'
							end
						
	    					 If @Operacao = 3 -- Consultas TEMP
							      Begin
									Set @FinalTransacao = 2
								  End
							   Else
								  Begin
									set @FinalTransacao = 3
								  End  
						  End   
		         
	          End
	
	          FETCH NEXT FROM cursor_046 INTO @CD_Dado1_Cursor,@CD_Dado2_Cursor,@CD_Dado3_Cursor, @mensagemAmigavel
	   END
	   Close cursor_046
	   DEALLOCATE cursor_046
	end

   
  -- REGRA 47 : Procedimentos só podem ser feitos determinado numero de vezes no periodo, para o mesmo dente ou regiao por prestador 

if(CHARINDEX(',47,',',' + @regras + ',') > 0)
	begin
	    Declare cursor_047 Cursor For          
	    Select cd_servico,Numero,isnull(QT_Meses,12), mensagemAmigavel From TB_Regra_Servico Where Codigo_Regra = 47
	    and CHARINDEX(',' + convert(varchar(10),@cd_centro_custo) + ',', ',' + isnull(centro_custo,convert(varchar(10),@cd_centro_custo)) + ',') > 0
	    and CHARINDEX(',' + convert(varchar(10),@CD_PLANO) + ',', ',' + isnull(plano,convert(varchar(10),@CD_PLANO)) + ',') > 0
	
		OPEN cursor_047
		FETCH NEXT FROM cursor_047 INTO @CD_Dado1_Cursor,@CD_Dado3_Cursor,@CD_Dado4_Cursor, @mensagemAmigavel
	
		-- Inicio do Loop.
		WHILE (@@FETCH_STATUS <> -1)
		BEGIN
	
	         If CHARINDEX(',' + Convert(varchar(10),@CD_Servico) + ',',',' + @CD_Dado1_Cursor + ',') > 0 
	             Begin
	                  print 'Entrei'
	                  Select  @NR_Quantidade = Count(cd_sequencial)
		                From  @tempTableConsultas as t1
						Where CD_Servico = @CD_Servico        And
		                      cd_funcionario    = @CD_Funcionario and 
		                      isnull(isnull(cd_ud,rboId),7) = isnull(isnull(@CD_UD,@regiao),7) And
	                          isnull(DT_Servico,getdate())  >= dateadd(month,-1*@CD_Dado4_Cursor,Getdate())    And
	                          CD_Sequencial     <> @ChavePrimaria
	                          
	                 print 'Qtde'
	                 print @NR_Quantidade
	                 print 'Qtde2'
	                   
	                 if @NR_Quantidade >= @CD_Dado3_Cursor
	                  Begin
			if (@DS_Mensagem <> '')
				Set @DS_Mensagem += '©'
				
				if (@mensagemAmigavel is not null)
					begin
						Set @DS_Mensagem += '47;REGRA 47: ' + @mensagemAmigavel
					end
				else
					begin
						Set @DS_Mensagem += '47;REGRA 47: O procedimento ' + Convert(varchar(10),@CD_Servico) + ' só pode ser realizado ' + convert(varchar(10),@CD_Dado3_Cursor) + ' vez(es) a cada ' + convert(varchar(10),@CD_Dado4_Cursor) + ' mês(es) para a mesma dente\regiao por prestador.' 
					end
				
	                    If @Operacao = 3 -- Consultas TEMP
							  Begin
								Set @FinalTransacao = 1
							  End
						   Else
							  Begin
								set @FinalTransacao = 3
							  End  
	                  End
	              End
	        FETCH NEXT FROM cursor_047 INTO @CD_Dado1_Cursor,@CD_Dado3_Cursor,@CD_Dado4_Cursor, @mensagemAmigavel
	    END
	Close cursor_047
	DEALLOCATE cursor_047   
	end


    -----------------------------------------------------------------------------------------------
    -- REGRA 48 : O Procedimento A(1), so pode ser executado se o procedimento B(2) tiver sido apos determinado periodo de tempo na regiao pelo mesmo prestador

if(CHARINDEX(',48,',',' + @regras + ',') > 0)
	begin
	    Declare cursor_048 Cursor For          
	    Select cd_servico,cd_servico2,isnull(QT_Meses,1), mensagemAmigavel From TB_Regra_Servico Where Codigo_Regra = 48
	    and CHARINDEX(',' + convert(varchar(10),@cd_centro_custo) + ',', ',' + isnull(centro_custo,convert(varchar(10),@cd_centro_custo)) + ',') > 0
	    and CHARINDEX(',' + convert(varchar(10),@CD_PLANO) + ',', ',' + isnull(plano,convert(varchar(10),@CD_PLANO)) + ',') > 0
	
		OPEN cursor_048
		FETCH NEXT FROM cursor_048 INTO @CD_Dado1_Cursor,@CD_Dado2_Cursor,@CD_Dado4_Cursor, @mensagemAmigavel
	
		-- Inicio do Loop.
		WHILE (@@FETCH_STATUS <> -1)
		BEGIN
	
			 If CHARINDEX(',' + Convert(varchar(10),@CD_Servico) + ',',',' + @CD_Dado1_Cursor + ',') > 0 And
			   @regiao is not null
			   Begin
				   Set @NR_Quantidade = 0 
	
				   Select @NR_Quantidade = count(cd_sequencial)
							From  @tempTableConsultas as t1
						Where CHARINDEX(',' + convert(varchar,CD_UD) + ',',',' + (select rboUd from regiaoboca where rboid=@regiao) + ',') > 0 And  
								  CD_Sequencial     <> @ChavePrimaria And
								  cd_funcionario    = @CD_Funcionario and 
								  isnull(DT_Servico,getdate())  >= dateadd(month,-1*@CD_Dado4_Cursor,Getdate())    And
								  CHARINDEX(',' + convert(varchar,CD_Servico) + ',',',' + @CD_Dado2_Cursor + ',') > 0
						
					 If @NR_Quantidade > 0
							  Begin
		                      
								if (@DS_Mensagem <> '')
									Set @DS_Mensagem += '©'
									if (@mensagemAmigavel is not null)
										begin
											Set @DS_Mensagem += '48;REGRA 48: ' + @mensagemAmigavel
										end
									else
										begin
											Set @DS_Mensagem += '48;REGRA 48: O Procedimento ' + Convert(varchar(10),@CD_Servico) + ' so pode ser realizado apos ' + convert(varchar(10),@CD_Dado4_Cursor,10) + ' mês(es), pois existe o procedimento(s) ' + @CD_Dado2_Cursor + ' realizado ou a realizar.'
										end
		 						 
	    						 If @Operacao = 3 -- Consultas TEMP
									  Begin
										Set @FinalTransacao = 2
									  End
								   Else
									  Begin
										set @FinalTransacao = 3
									  End  
							  End   
			   End
	
	           FETCH NEXT FROM cursor_048 INTO @CD_Dado1_Cursor,@CD_Dado2_Cursor,@CD_Dado4_Cursor, @mensagemAmigavel
	      END
	      Close cursor_048
	      DEALLOCATE cursor_048
	end
      
    -----------------------------------------------------------------------------------------------
    -- REGRA 49 : Se já existir procedimento para uma determinada região, outro procedimento não pode ser informado depois de determinados DIAS por prestador

if(CHARINDEX(',49,',',' + @regras + ',') > 0)
	begin
	    Declare cursor_049 Cursor For
	    Select cd_servico, QT_Meses, mensagemAmigavel From TB_Regra_Servico Where Codigo_Regra = 49
	    and CHARINDEX(',' + convert(varchar(10),@cd_centro_custo) + ',', ',' + isnull(centro_custo,convert(varchar(10),@cd_centro_custo)) + ',') > 0
	    and CHARINDEX(',' + convert(varchar(10),@CD_PLANO) + ',', ',' + isnull(plano,convert(varchar(10),@CD_PLANO)) + ',') > 0
	
		OPEN cursor_049
		FETCH NEXT FROM cursor_049 INTO @CD_Dado1_Cursor,@CD_Dado2_Cursor, @mensagemAmigavel
	
		WHILE (@@FETCH_STATUS <> -1)
		BEGIN
	
	      If CHARINDEX(',' + Convert(varchar(10),@CD_Servico) + ',',',' + @CD_Dado1_Cursor + ',') > 0 And
	         @regiao is not null
	         Begin
	
	             Set @NR_Quantidade = 0
	
	             Select @NR_Quantidade = count(cd_sequencial)
						From  @tempTableConsultas as t1
						Where rboId = @regiao And
	                          CD_Sequencial     <> @ChavePrimaria And
	                          cd_funcionario    = @CD_Funcionario and 
	                          CHARINDEX(',' + convert(varchar,CD_Servico) + ',',',' + @CD_Dado1_Cursor + ',') > 0 And
	                          (dt_servico is null or dt_servico >= dateadd(day,@CD_Dado2_Cursor * -1,getdate()))
	
		         If @NR_Quantidade > 0
						  Begin
	                        
					if (@DS_Mensagem <> '')
						Set @DS_Mensagem += '©'
						if (@mensagemAmigavel is not null)
							begin
								Set @DS_Mensagem += '49;REGRA 49: ' + @mensagemAmigavel
							end
						else
							begin
								Set @DS_Mensagem += '49;REGRA 49: Procedimento ' + Convert(varchar(10),@CD_Servico) + ' não pode ser realizado na região, pois já existe o procedimento ' + @CD_Dado1_Cursor + ' informado na mesma região no prestador.'
							end
		 	                 
	    					 If @Operacao = 3 -- Consultas TEMP
							      Begin
									Set @FinalTransacao = 2
								  End
							   Else
								  Begin
									set @FinalTransacao = 3
								  End  
						  End   
		         
	          End
	
	          FETCH NEXT FROM cursor_049 INTO @CD_Dado1_Cursor,@CD_Dado2_Cursor, @mensagemAmigavel
	   END
	   Close cursor_049
	   DEALLOCATE cursor_049
	end
      
      
   -- Regra 50 : Apenas um dos procedimentos pode ser feito em determinado número de dias para o mesmo cliente
   -- Qualquer procedimento lançado nesse grupo que nao seja o mesmo procedimento será barrado
   -- Exemplo : Profilaxia + Rasp Sub + Rasp Supra .. Se ja tem lancado a Profilaxia o sistema barra a Supra e Sub porem deixa passar a Profilaxia

if(CHARINDEX(',50,',',' + @regras + ',') > 0)
	begin
	    Declare cursor_050 Cursor For
	    Select cd_servico,QT_Meses, mensagemAmigavel From TB_Regra_Servico Where Codigo_Regra = 50
	    and CHARINDEX(',' + convert(varchar(10),@cd_centro_custo) + ',', ',' + isnull(centro_custo,convert(varchar(10),@cd_centro_custo)) + ',') > 0
	    and CHARINDEX(',' + convert(varchar(10),@CD_PLANO) + ',', ',' + isnull(plano,convert(varchar(10),@CD_PLANO)) + ',') > 0
	
		OPEN cursor_050
		FETCH NEXT FROM cursor_050 INTO @CD_Dado1_Cursor,@CD_Dado3_Cursor, @mensagemAmigavel
	
		-- Inicio do Loop.
		WHILE (@@FETCH_STATUS <> -1)
		BEGIN
	
	
	         If CHARINDEX(',' + Convert(varchar(10),@CD_Servico) + ',',',' + @CD_Dado1_Cursor + ',') > 0
	             Begin
	               --- Observar primeiro se não tem procedimento pendente.
	               --- Procedimento estando pendente, não pode entrar outro pendente ou realizado.
	              Select top 1 @Dt_ProcedimentoBanco = isnull(dt_servico,getdate()+1)  
		                From  @tempTableConsultas as t1
						Where CHARINDEX(',' + convert(varchar,CD_Servico) + ',',',' + @CD_Dado1_Cursor + ',') > 0 And
	                          CD_Sequencial     <> @ChavePrimaria
	               order by 1 desc
	
	              if @@rowcount >0 
	                  Begin
	     				if @Dt_ProcedimentoBanco  > getdate()
	                      Begin 
				if (@DS_Mensagem <> '')
					Set @DS_Mensagem += '©'
					if (@mensagemAmigavel is not null)
						begin
							Set @DS_Mensagem += '50;REGRA 50: ' + @mensagemAmigavel
						end
					else
						begin
							Set @DS_Mensagem += '50;REGRA 50: O procedimento ' + @CD_Dado1_Cursor + ' está pendente para ser realizado. O procedimento só pode ser realizado a cada ' + convert(varchar,@CD_Dado3_Cursor)  + ' dia(s).' 
						end
					
	                       If @Operacao = 3 -- Consultas TEMP
							  Begin
								Set @FinalTransacao = 1
							  End
						   Else
							  Begin
	      				        Set @FinalTransacao = 3
					           End  
	                      End 
	
	                    If DateDiff(day,@Dt_ProcedimentoBanco,@DT_Atual) < @CD_Dado3_Cursor                  
	                      Begin
				if (@DS_Mensagem <> '')
					Set @DS_Mensagem += '©'
					if (@mensagemAmigavel is not null)
						begin
							Set @DS_Mensagem += '50;REGRA 50: ' + @mensagemAmigavel
						end
					else
						begin
							Set @DS_Mensagem += '50;REGRA 50: Somente um dos procedimentos ' + @CD_Dado1_Cursor + ' pode ser realizado a cada ' + convert(varchar,@CD_Dado3_Cursor) + ' dia(s). Data do último procedimento: ' + Convert(varchar,@Dt_ProcedimentoBanco,103) + '.'
						end
					
	                         If @Operacao = 3 -- Consultas TEMP
								  Begin
									Set @FinalTransacao = 1
								  End
							   Else
								  Begin
									set @FinalTransacao = 3
								  End  
	                      End   
	                  End
	              End
	        FETCH NEXT FROM cursor_050 INTO @CD_Dado1_Cursor,@CD_Dado3_Cursor, @mensagemAmigavel
	    END
	Close cursor_050
	DEALLOCATE cursor_050   
	end

-----------------------------------------------------------------------------------------------
-- REGRA 51 : Procedimentos só podem ser feitos após um determinado numero de dias (auto-excludente)

if(CHARINDEX(',51,',',' + @regras + ',') > 0)
	begin
		Declare cursor_051 Cursor For
		
			Select cd_servico, QT_Meses, mensagemAmigavel
			From TB_Regra_Servico
			Where Codigo_Regra = 51
			and CHARINDEX(',' + convert(varchar(10),@cd_centro_custo) + ',', ',' + isnull(centro_custo,convert(varchar(10),@cd_centro_custo)) + ',') > 0
			and CHARINDEX(',' + convert(varchar(10),@CD_PLANO) + ',', ',' + isnull(plano,convert(varchar(10),@CD_PLANO)) + ',') > 0
			and CHARINDEX(',' + Convert(varchar(10),@CD_Servico) + ',',',' + cd_servico + ',') > 0
		
		OPEN cursor_051
		FETCH NEXT FROM cursor_051 INTO @CD_Dado1_Cursor, @CD_Dado3_Cursor, @mensagemAmigavel
		
		WHILE (@@FETCH_STATUS <> -1)
			BEGIN
		
				select top 1 @Dt_ProcedimentoBanco = isnull(dt_servico,getdate()+1)
				From @tempTableConsultas as t1
				where CD_Sequencial <> @ChavePrimaria
				and (dt_servico is null or DateDiff(day,dt_servico,@DT_Atual) < @CD_Dado3_Cursor)
				and CHARINDEX(',' + convert(varchar,CD_Servico) + ',',',' + @CD_Dado1_Cursor + ',') > 0
		        
				if @@rowcount > 0
					Begin
						if @Dt_ProcedimentoBanco > getdate()
							Begin
								if (@DS_Mensagem <> '')
									Set @DS_Mensagem += '©'
				
								if (@mensagemAmigavel is not null)
									begin
										Set @DS_Mensagem += '51;REGRA 51: ' + @mensagemAmigavel
									end
								else
									begin
										Set @DS_Mensagem += '51;REGRA 51: O procedimento ' + Convert(varchar(10),@CD_Servico) + ' está pendente para ser realizado. O procedimento só pode ser realizado depois de ' + convert(varchar,@CD_Dado3_Cursor) + ' dia(s) por auto-excludência.'
									end
								 	                 
								If @Operacao = 3 -- Consultas TEMP
									Begin
										Set @FinalTransacao = 2
									End
								Else
									Begin
										set @FinalTransacao = 3
									End
							end
						else
							begin
								if (@DS_Mensagem <> '')
									Set @DS_Mensagem += '©'
				
								if (@mensagemAmigavel is not null)
									begin
										Set @DS_Mensagem += '51;REGRA 51: ' + @mensagemAmigavel
									end
								else
									begin
										Set @DS_Mensagem += '51;REGRA 51: Procedimento ' + Convert(varchar(10),@CD_Servico) + ' só pode ser realizado depois de ' + convert(varchar,@CD_Dado3_Cursor) + ' dia(s) por auto-excludência. Data do último procedimento: ' + Convert(varchar,@Dt_ProcedimentoBanco,103) + '.'
									end
								 	                 
								If @Operacao = 3 -- Consultas TEMP
									Begin
										Set @FinalTransacao = 2
									End
								Else
									Begin
										set @FinalTransacao = 3
									End
							end
					End
		
				FETCH NEXT FROM cursor_051 INTO @CD_Dado1_Cursor,@CD_Dado3_Cursor, @mensagemAmigavel
			END
		Close cursor_051
		DEALLOCATE cursor_051
	end

-----------------------------------------------------------------------------------------------
-- REGRA 52 : Procedimentos só podem ser feitos depois de um determinado numero de dias no mesmo dente ou região para o mesmo dentista (auto-excludente)
-----------------------------------------------------------------------------------------------

if(CHARINDEX(',52,',',' + @regras + ',') > 0)
	begin
		Declare cursor_052 Cursor For
		
			Select cd_servico, QT_Meses, mensagemAmigavel
			From TB_Regra_Servico
			Where Codigo_Regra = 52
			and CHARINDEX(',' + convert(varchar(10),@cd_centro_custo) + ',', ',' + isnull(centro_custo,convert(varchar(10),@cd_centro_custo)) + ',') > 0
			and CHARINDEX(',' + convert(varchar(10),@CD_PLANO) + ',', ',' + isnull(plano,convert(varchar(10),@CD_PLANO)) + ',') > 0
			and CHARINDEX(',' + Convert(varchar(10),@CD_Servico) + ',',',' + cd_servico + ',') > 0
			and isnull(@CD_UD,@regiao) is not null
		
		OPEN cursor_052
		FETCH NEXT FROM cursor_052 INTO @CD_Dado1_Cursor, @CD_Dado3_Cursor, @mensagemAmigavel
		
		WHILE (@@FETCH_STATUS <> -1)
			BEGIN
		
				Select top 1 @Dt_ProcedimentoBanco = isnull(dt_servico,getdate()+1)
				From @tempTableConsultas
				Where isnull(isnull(cd_ud,rboId),7) = isnull(isnull(@CD_UD,@regiao),7)
				and CD_Sequencial <> @ChavePrimaria
				and (dt_servico is null or DateDiff(day,dt_servico,@DT_Atual) < @CD_Dado3_Cursor)
				and cd_funcionario = @CD_Funcionario
				and CHARINDEX(',' + convert(varchar,CD_Servico) + ',',',' + @CD_Dado1_Cursor + ',') > 0
		
				if @@rowcount > 0
					Begin
						if @Dt_ProcedimentoBanco > getdate()
							Begin
								if (@DS_Mensagem <> '')
									Set @DS_Mensagem += '©'
		
								if (@mensagemAmigavel is not null)
									begin
										Set @DS_Mensagem += '52;REGRA 52: ' + @mensagemAmigavel
									end
								else
									begin
										Set @DS_Mensagem += '52;REGRA 52: O procedimento ' + Convert(varchar(10),@CD_Servico) + ' está pendente para ser realizado. O procedimento só pode ser realizado a cada ' + convert(varchar,@CD_Dado3_Cursor) + ' dia(s) para o mesmo dente ou região para o mesmo dentista.'
									end
		
								If @Operacao = 3 -- Consultas TEMP
									Begin
										Set @FinalTransacao = 1
									End
								Else
									Begin
										Set @FinalTransacao = 3
									End  
							End
		
						else
							Begin
								if (@DS_Mensagem <> '')
									Set @DS_Mensagem += '©'
		
								if (@mensagemAmigavel is not null)
									begin
										Set @DS_Mensagem += '52;REGRA 52: ' + @mensagemAmigavel
									end
								else
									begin
										Set @DS_Mensagem += '52;REGRA 52: Procedimento ' + Convert(varchar(10),@CD_Servico) + ' só pode ser realizado a cada ' + convert(varchar,@CD_Dado3_Cursor) + ' dia(s) para o mesmo dente ou região para o mesmo dentista. Data do último procedimento: ' + Convert(varchar,@Dt_ProcedimentoBanco,103) + '.'
									end
		
								If @Operacao = 3 -- Consultas TEMP
									Begin
										Set @FinalTransacao = 1
									End
								Else
									Begin
										set @FinalTransacao = 3
									End  
							End
					End
		
		
				FETCH NEXT FROM cursor_052 INTO @CD_Dado1_Cursor,@CD_Dado3_Cursor, @mensagemAmigavel
			END
		Close cursor_052
		DEALLOCATE cursor_052
	end

-----------------------------------------------------------------------------------------------
-- REGRA 53 : Procedimentos auto-excludentes no mesmo dente ou região para o mesmo prestador
-----------------------------------------------------------------------------------------------

if(CHARINDEX(',53,',',' + @regras + ',') > 0)
	begin
		Declare cursor_053 Cursor For
		
			Select cd_servico, mensagemAmigavel
			From TB_Regra_Servico
			Where Codigo_Regra = 53
			and CHARINDEX(',' + convert(varchar(10),@cd_centro_custo) + ',', ',' + isnull(centro_custo,convert(varchar(10),@cd_centro_custo)) + ',') > 0
			and CHARINDEX(',' + convert(varchar(10),@CD_PLANO) + ',', ',' + isnull(plano,convert(varchar(10),@CD_PLANO)) + ',') > 0
			and CHARINDEX(',' + Convert(varchar(10),@CD_Servico) + ',',',' + cd_servico + ',') > 0
			and isnull(@CD_UD,@regiao) is not null
		
		OPEN cursor_053
		FETCH NEXT FROM cursor_053 INTO @CD_Dado1_Cursor, @mensagemAmigavel
		
		WHILE (@@FETCH_STATUS <> -1)
			BEGIN
		
				select top 1 @Dt_ProcedimentoBanco = isnull(dt_servico,getdate() +1)
				From @tempTableConsultas
				Where isnull(isnull(cd_ud,rboId),7) = isnull(isnull(@CD_UD,@regiao),7)
				and CD_Sequencial <> @ChavePrimaria
				and cd_funcionario = @CD_Funcionario
				and CHARINDEX(',' + convert(varchar,CD_Servico) + ',',',' + @CD_Dado1_Cursor + ',') > 0
		
				if @@rowcount > 0
					Begin
						if @Dt_ProcedimentoBanco > getdate()
							Begin
								if (@DS_Mensagem <> '')
									Set @DS_Mensagem += '©'
		
								if (@mensagemAmigavel is not null)
									begin
										Set @DS_Mensagem += '53;REGRA 53: ' + @mensagemAmigavel
									end
								else
									begin
										Set @DS_Mensagem += '53;REGRA 53: O procedimento ' + Convert(varchar(10),@CD_Servico) + ' está pendente para ser realizado. O procedimento só pode ser realizado uma vez para o mesmo dente ou região para o mesmo prestador.'
									end
		
								If @Operacao = 3 -- Consultas TEMP
									Begin
										Set @FinalTransacao = 1
									End
								Else
									Begin
										Set @FinalTransacao = 3
									End
							End
		
						else
							Begin
								if (@DS_Mensagem <> '')
									Set @DS_Mensagem += '©'
		
								if (@mensagemAmigavel is not null)
									begin
										Set @DS_Mensagem += '53;REGRA 53: ' + @mensagemAmigavel
									end
								else
									begin
										Set @DS_Mensagem += '53;REGRA 53: Procedimento ' + Convert(varchar(10),@CD_Servico) + ' só pode ser realizado uma vez para o mesmo dente ou região para o mesmo prestador. Data do último procedimento: ' + Convert(varchar,@Dt_ProcedimentoBanco,103) + '.'
									end
		
								If @Operacao = 3 -- Consultas TEMP
									Begin
										Set @FinalTransacao = 1
									End
								Else
									Begin
										set @FinalTransacao = 3
									End  
							End
					End
		
		
				FETCH NEXT FROM cursor_053 INTO @CD_Dado1_Cursor, @mensagemAmigavel
			END
		Close cursor_053
		DEALLOCATE cursor_053
	end

-----------------------------------------------------------------------------------------------
-- REGRA 54 : Procedimentos auto-excludentes por quantidade, dias

if(CHARINDEX(',54,',',' + @regras + ',') > 0)
	begin
		Declare cursor_054 Cursor For
		
			select cd_servico, QT_Meses, Numero, mensagemAmigavel
			from TB_Regra_Servico
			where Codigo_Regra = 54
			and CHARINDEX(',' + convert(varchar(10),@cd_centro_custo) + ',', ',' + isnull(centro_custo,convert(varchar(10),@cd_centro_custo)) + ',') > 0
			and CHARINDEX(',' + convert(varchar(10),@CD_PLANO) + ',', ',' + isnull(plano,convert(varchar(10),@CD_PLANO)) + ',') > 0
			and CHARINDEX(',' + Convert(varchar(10),@CD_Servico) + ',',',' + cd_servico + ',') > 0
		
		OPEN cursor_054
		FETCH NEXT FROM cursor_054 INTO @CD_Dado1_Cursor, @CD_Dado2_Cursor, @CD_Dado3_Cursor, @mensagemAmigavel
		
		WHILE (@@FETCH_STATUS <> -1)
			BEGIN
			
				Set @NR_Quantidade = 0
			
				select @NR_Quantidade = count(cd_sequencial)
				from @tempTableConsultas
				where CD_Sequencial <> @ChavePrimaria
				and CHARINDEX(',' + convert(varchar,CD_Servico) + ',',',' + @CD_Dado1_Cursor + ',') > 0
				and (dt_servico is null or dt_servico >= dateadd(day,@CD_Dado2_Cursor * -1,getdate()))
			
				If @NR_Quantidade >= @CD_Dado3_Cursor
					Begin
						if (@DS_Mensagem <> '')
							Set @DS_Mensagem += '©'
		
						if (@mensagemAmigavel is not null)
							begin
								Set @DS_Mensagem += '54;REGRA 54: ' + @mensagemAmigavel
							end
						else
							begin
								if (CHARINDEX(Convert(varchar(10),@CD_Servico),',') > 0)
									begin
										Set @DS_Mensagem += '54;REGRA 54: Procedimento ' + Convert(varchar(10),@CD_Servico) + ' não pode ser incluído, pois o procedimento ' + @CD_Dado1_Cursor + ' já foi informado ' + convert(varchar,@CD_Dado3_Cursor) + ' vez(es) ou mais no período de ' + convert(varchar,@CD_Dado2_Cursor) + ' dia(s).'
									end
								else
									begin
										Set @DS_Mensagem += '54;REGRA 54: Procedimento ' + Convert(varchar(10),@CD_Servico) + ' não pode ser incluído, pois já foi informado ' + convert(varchar,@CD_Dado3_Cursor) + ' vez(es) ou mais no período de ' + convert(varchar,@CD_Dado2_Cursor) + ' dia(s).'
									end
							end
						 	                 
						If @Operacao = 3 -- Consultas TEMP
							Begin
								Set @FinalTransacao = 2
							End
						Else
							Begin
								set @FinalTransacao = 3
							End
					End
			
				FETCH NEXT FROM cursor_054 INTO @CD_Dado1_Cursor, @CD_Dado2_Cursor, @CD_Dado3_Cursor, @mensagemAmigavel
			END
		Close cursor_054
		DEALLOCATE cursor_054
	end

-----------------------------------------------------------------------------------------------
-- REGRA 55 : Procedimentos auto-excludentes por quantidade, dias, dentista
-----------------------------------------------------------------------------------------------

if(CHARINDEX(',55,',',' + @regras + ',') > 0)
	begin
		Declare cursor_055 Cursor For
		
			select cd_servico, QT_Meses, Numero, mensagemAmigavel
			from TB_Regra_Servico
			where Codigo_Regra = 55
			and CHARINDEX(',' + convert(varchar(10),@cd_centro_custo) + ',', ',' + isnull(centro_custo,convert(varchar(10),@cd_centro_custo)) + ',') > 0
			and CHARINDEX(',' + convert(varchar(10),@CD_PLANO) + ',', ',' + isnull(plano,convert(varchar(10),@CD_PLANO)) + ',') > 0
			and CHARINDEX(',' + Convert(varchar(10),@CD_Servico) + ',',',' + cd_servico + ',') > 0
		
		OPEN cursor_055
		FETCH NEXT FROM cursor_055 INTO @CD_Dado1_Cursor, @CD_Dado2_Cursor, @CD_Dado3_Cursor, @mensagemAmigavel
		
		WHILE (@@FETCH_STATUS <> -1)
			BEGIN
			
				Set @NR_Quantidade = 0
			
				select @NR_Quantidade = count(cd_sequencial)
				from @tempTableConsultas
				where CD_Sequencial <> @ChavePrimaria
				and cd_funcionario = @CD_Funcionario
				and CHARINDEX(',' + convert(varchar,CD_Servico) + ',',',' + @CD_Dado1_Cursor + ',') > 0
				and (dt_servico is null or dt_servico >= dateadd(day,@CD_Dado2_Cursor * -1,getdate()))
			
				If @NR_Quantidade >= @CD_Dado3_Cursor
					Begin
						if (@DS_Mensagem <> '')
							Set @DS_Mensagem += '©'
		
						if (@mensagemAmigavel is not null)
							begin
								Set @DS_Mensagem += '55;REGRA 55: ' + @mensagemAmigavel
							end
						else
							begin
								if (CHARINDEX(Convert(varchar(10),@CD_Servico),',') > 0)
									begin
										Set @DS_Mensagem += '55;REGRA 55: Procedimento ' + Convert(varchar(10),@CD_Servico) + ' não pode ser incluído, pois o procedimento ' + @CD_Dado1_Cursor + ' já foi informado ' + convert(varchar,@CD_Dado3_Cursor) + ' vez(es) ou mais no período de ' + convert(varchar,@CD_Dado2_Cursor) + ' dia(s) para o mesmo dentista.'
									end
								else
									begin
										Set @DS_Mensagem += '55;REGRA 55: Procedimento ' + Convert(varchar(10),@CD_Servico) + ' não pode ser incluído, pois já foi informado ' + convert(varchar,@CD_Dado3_Cursor) + ' vez(es) ou mais no período de ' + convert(varchar,@CD_Dado2_Cursor) + ' dia(s) para o mesmo dentista.'
									end
							end
						 	                 
						If @Operacao = 3 -- Consultas TEMP
							Begin
								Set @FinalTransacao = 2
							End
						Else
							Begin
								set @FinalTransacao = 3
							End
					End
			
				FETCH NEXT FROM cursor_055 INTO @CD_Dado1_Cursor, @CD_Dado2_Cursor, @CD_Dado3_Cursor, @mensagemAmigavel
			END
		Close cursor_055
		DEALLOCATE cursor_055
	end

-----------------------------------------------------------------------------------------------
-- REGRA 56 : Procedimentos auto-excludentes por quantidade, meses
-----------------------------------------------------------------------------------------------

if(CHARINDEX(',56,',',' + @regras + ',') > 0)
	begin
		Declare cursor_056 Cursor For
		
			select cd_servico, QT_Meses, Numero, mensagemAmigavel
			from TB_Regra_Servico
			where Codigo_Regra = 56
			and CHARINDEX(',' + convert(varchar(10),@cd_centro_custo) + ',', ',' + isnull(centro_custo,convert(varchar(10),@cd_centro_custo)) + ',') > 0
			and CHARINDEX(',' + convert(varchar(10),@CD_PLANO) + ',', ',' + isnull(plano,convert(varchar(10),@CD_PLANO)) + ',') > 0
			and CHARINDEX(',' + Convert(varchar(10),@CD_Servico) + ',',',' + cd_servico + ',') > 0
		
		OPEN cursor_056
		FETCH NEXT FROM cursor_056 INTO @CD_Dado1_Cursor, @CD_Dado2_Cursor, @CD_Dado3_Cursor, @mensagemAmigavel
		
		WHILE (@@FETCH_STATUS <> -1)
			BEGIN
			
				Set @NR_Quantidade = 0
			
				select @NR_Quantidade = count(cd_sequencial)
				from @tempTableConsultas
				where CD_Sequencial <> @ChavePrimaria
				and CHARINDEX(',' + convert(varchar,CD_Servico) + ',',',' + @CD_Dado1_Cursor + ',') > 0
				and (dt_servico is null or dt_servico >= dateadd(month,@CD_Dado2_Cursor * -1,getdate()))
			
				If @NR_Quantidade >= @CD_Dado3_Cursor
					Begin
						if (@DS_Mensagem <> '')
							Set @DS_Mensagem += '©'
		
						if (@mensagemAmigavel is not null)
							begin
								Set @DS_Mensagem += '56;REGRA 56: ' + @mensagemAmigavel
							end
						else
							begin
								if (CHARINDEX(Convert(varchar(10),@CD_Servico),',') > 0)
									begin
										Set @DS_Mensagem += '56;REGRA 56: Procedimento ' + Convert(varchar(10),@CD_Servico) + ' não pode ser incluído, pois o procedimento ' + @CD_Dado1_Cursor + ' já foi informado ' + convert(varchar,@CD_Dado3_Cursor) + ' vez(es) ou mais no período de ' + convert(varchar,@CD_Dado2_Cursor) + ' mês(es).'
									end
								else
									begin
										Set @DS_Mensagem += '56;REGRA 56: Procedimento ' + Convert(varchar(10),@CD_Servico) + ' não pode ser incluído, pois já foi informado ' + convert(varchar,@CD_Dado3_Cursor) + ' vez(es) ou mais no período de ' + convert(varchar,@CD_Dado2_Cursor) + ' mês(es).'
									end
							end
						 	                 
						If @Operacao = 3 -- Consultas TEMP
							Begin
								Set @FinalTransacao = 2
							End
						Else
							Begin
								set @FinalTransacao = 3
							End
					End
			
				FETCH NEXT FROM cursor_056 INTO @CD_Dado1_Cursor, @CD_Dado2_Cursor, @CD_Dado3_Cursor, @mensagemAmigavel
			END
		Close cursor_056
		DEALLOCATE cursor_056
	end

-----------------------------------------------------------------------------------------------
-- REGRA 57 : Procedimentos auto-excludentes por quantidade, meses, dentista
-----------------------------------------------------------------------------------------------

if(CHARINDEX(',57,',',' + @regras + ',') > 0)
	begin
		Declare cursor_057 Cursor For
		
			select cd_servico, QT_Meses, Numero, mensagemAmigavel
			from TB_Regra_Servico
			where Codigo_Regra = 57
			and CHARINDEX(',' + convert(varchar(10),@cd_centro_custo) + ',', ',' + isnull(centro_custo,convert(varchar(10),@cd_centro_custo)) + ',') > 0
			and CHARINDEX(',' + convert(varchar(10),@CD_PLANO) + ',', ',' + isnull(plano,convert(varchar(10),@CD_PLANO)) + ',') > 0
			and CHARINDEX(',' + Convert(varchar(10),@CD_Servico) + ',',',' + cd_servico + ',') > 0
		
		OPEN cursor_057
		FETCH NEXT FROM cursor_057 INTO @CD_Dado1_Cursor, @CD_Dado2_Cursor, @CD_Dado3_Cursor, @mensagemAmigavel
		
		WHILE (@@FETCH_STATUS <> -1)
			BEGIN
			
				Set @NR_Quantidade = 0
			
				select @NR_Quantidade = count(cd_sequencial)
				from @tempTableConsultas
				where CD_Sequencial <> @ChavePrimaria
				and cd_funcionario = @CD_Funcionario
				and CHARINDEX(',' + convert(varchar,CD_Servico) + ',',',' + @CD_Dado1_Cursor + ',') > 0
				and (dt_servico is null or dt_servico >= dateadd(month,@CD_Dado2_Cursor * -1,getdate()))
			
				If @NR_Quantidade >= @CD_Dado3_Cursor
					Begin
						if (@DS_Mensagem <> '')
							Set @DS_Mensagem += '©'
		
						if (@mensagemAmigavel is not null)
							begin
								Set @DS_Mensagem += '57;REGRA 57: ' + @mensagemAmigavel
							end
						else
							begin
								if (CHARINDEX(Convert(varchar(10),@CD_Servico),',') > 0)
									begin
										Set @DS_Mensagem += '57;REGRA 57: Procedimento ' + Convert(varchar(10),@CD_Servico) + ' não pode ser lançado, pois o procedimento ' + @CD_Dado1_Cursor + ' já foi informado ' + convert(varchar,@CD_Dado3_Cursor) + ' vez(es) ou mais no período de ' + convert(varchar,@CD_Dado2_Cursor) + ' mês(es) para o mesmo dentista.'
									end
								else
									begin
										Set @DS_Mensagem += '57;REGRA 57: Procedimento ' + Convert(varchar(10),@CD_Servico) + ' não pode ser lançado, pois já foi informado ' + convert(varchar,@CD_Dado3_Cursor) + ' vez(es) ou mais no período de ' + convert(varchar,@CD_Dado2_Cursor) + ' mês(es) para o mesmo dentista.'
									end
							end
		
						If @Operacao = 3 -- Consultas TEMP
							Begin
								Set @FinalTransacao = 2
							End
						Else
							Begin
								set @FinalTransacao = 3
							End
					End
			
				FETCH NEXT FROM cursor_057 INTO @CD_Dado1_Cursor, @CD_Dado2_Cursor, @CD_Dado3_Cursor, @mensagemAmigavel
			END
		Close cursor_057
		DEALLOCATE cursor_057
	end

-----------------------------------------------------------------------------------------------
-- REGRA 58 : Procedimentos só podem ser realizados a partir de determinada idade

if(CHARINDEX(',58,',',' + @regras + ',') > 0)
	begin
		Declare cursor_058 Cursor For
		
			select idade, mensagemAmigavel
			From TB_Regra_Servico
			Where Codigo_Regra = 58
			and CHARINDEX(',' + convert(varchar(10),@cd_centro_custo) + ',', ',' + isnull(centro_custo,convert(varchar(10),@cd_centro_custo)) + ',') > 0
			and CHARINDEX(',' + convert(varchar(10),@CD_PLANO) + ',', ',' + isnull(plano,convert(varchar(10),@CD_PLANO)) + ',') > 0
			and CHARINDEX(',' + Convert(varchar(10),@CD_Servico) + ',',',' + cd_servico + ',') > 0
		
		OPEN cursor_058
		FETCH NEXT FROM cursor_058 INTO @CD_Dado1_Cursor, @mensagemAmigavel
		
		WHILE (@@FETCH_STATUS <> -1)
			BEGIN
		
				If (@WL_Idade < @CD_Dado1_Cursor)
					Begin
						if (@DS_Mensagem <> '')
							Set @DS_Mensagem += '©'
						
						if (@mensagemAmigavel is not null)
							begin
								Set @DS_Mensagem += '58;REGRA 58: ' + @mensagemAmigavel
							end
						else
							begin
								Set @DS_Mensagem += '58;REGRA 58: Procedimento ' + Convert(varchar(10),@CD_Servico) + ' não pode ser lançado em pacientes com menos de ' + convert(varchar(10),@CD_Dado1_Cursor) + ' anos. Idade do paciente: ' + convert(varchar,@WL_Idade) + '.'
							end
						
						If @Operacao = 3 -- Consultas TEMP
							Begin
								Set @FinalTransacao = 1
							End
						Else
							Begin
								set @FinalTransacao = 3
							End
					End
		
				FETCH NEXT FROM cursor_058 INTO @CD_Dado1_Cursor, @mensagemAmigavel
			END
		Close cursor_058
		DEALLOCATE cursor_058
	end

-----------------------------------------------------------------------------------------------
-- REGRA 59 : Procedimentos só podem ser feitos após um determinado numero de meses (auto-excludente - exceto ele próprio)

if(CHARINDEX(',59,',',' + @regras + ',') > 0)
	begin
		Declare cursor_059 Cursor For
		
			Select cd_servico, QT_Meses, mensagemAmigavel
			From TB_Regra_Servico
			Where Codigo_Regra = 59
			and CHARINDEX(',' + convert(varchar(10),@cd_centro_custo) + ',', ',' + isnull(centro_custo,convert(varchar(10),@cd_centro_custo)) + ',') > 0
			and CHARINDEX(',' + convert(varchar(10),@CD_PLANO) + ',', ',' + isnull(plano,convert(varchar(10),@CD_PLANO)) + ',') > 0
			and CHARINDEX(',' + Convert(varchar(10),@CD_Servico) + ',',',' + cd_servico + ',') > 0
		
		OPEN cursor_059
		FETCH NEXT FROM cursor_059 INTO @CD_Dado1_Cursor, @CD_Dado3_Cursor, @mensagemAmigavel
		
		WHILE (@@FETCH_STATUS <> -1)
			BEGIN
				select top 1 @Dt_ProcedimentoBanco = isnull(dt_servico,getdate() + 1)
				From @tempTableConsultas
				where CD_Sequencial <> @ChavePrimaria
				and (dt_servico is null or DateDiff(month,dt_servico,@DT_Atual) < @CD_Dado3_Cursor)
				and CHARINDEX(',' + convert(varchar,CD_Servico) + ',',',' + @CD_Dado1_Cursor + ',') > 0
				and cd_servico <> @CD_Servico
			
				if @@rowcount > 0
					Begin
						if @Dt_ProcedimentoBanco > getdate()
							Begin
								if (@DS_Mensagem <> '')
									Set @DS_Mensagem += '©'
				
								if (@mensagemAmigavel is not null)
									begin
										Set @DS_Mensagem += '59;REGRA 59: ' + @mensagemAmigavel
									end
								else
									begin
										Set @DS_Mensagem += '59;REGRA 59: Existem procedimentos a serem realizados informados anteriormente que conflitaram com o lançamento do procedimento ' + Convert(varchar(10),@CD_Servico) + '.'
									end
								 	                 
								If @Operacao = 3 -- Consultas TEMP
									Begin
										Set @FinalTransacao = 2
									End
								Else
									Begin
										set @FinalTransacao = 3
									End
							end
						else
							begin
								if (@DS_Mensagem <> '')
									Set @DS_Mensagem += '©'
				
								if (@mensagemAmigavel is not null)
									begin
										Set @DS_Mensagem += '59;REGRA 59: ' + @mensagemAmigavel + '. Data do último procedimento: ' + Convert(varchar,@Dt_ProcedimentoBanco,103) + '.'
									end
								else
									begin
										Set @DS_Mensagem += '59;REGRA 59: Existem procedimentos realizados anteriormente há menos de ' + convert(varchar,@CD_Dado3_Cursor) + ' mês(es) que conflitaram com o lançamento do procedimento ' + Convert(varchar(10),@CD_Servico) + '. Data do procedimento conflitante: ' + Convert(varchar,@Dt_ProcedimentoBanco,103) + '.'								Set @DS_Mensagem += '59;REGRA 59: Existem procedimentos realizados anteriormente há menos de ' + convert(varchar,@CD_Dado3_Cursor) + ' mês(es) que conflitaram com o lançamento do procedimento ' + Convert(varchar(10),@CD_Servico) + '. Data do procedimento conflitante: ' + Convert(varchar,@Dt_ProcedimentoBanco,103) + '.'
									end
								 	                 
								If @Operacao = 3 -- Consultas TEMP
									Begin
										Set @FinalTransacao = 2
									End
								Else
									Begin
										set @FinalTransacao = 3
									End
							end
					End
		
				FETCH NEXT FROM cursor_059 INTO @CD_Dado1_Cursor, @CD_Dado3_Cursor, @mensagemAmigavel
			END
		Close cursor_059
		DEALLOCATE cursor_059
	end

-----------------------------------------------------------------------------------------------
-- REGRA 60 : Procedimentos só podem ser realizados determinado número de vezes no mês corrente

if(CHARINDEX(',60,',',' + @regras + ',') > 0)
	begin
		Declare cursor_060 Cursor For
		
			select cd_servico, Numero, mensagemAmigavel
			from TB_Regra_Servico
			where Codigo_Regra = 60
			and CHARINDEX(',' + convert(varchar(10),@cd_centro_custo) + ',', ',' + isnull(centro_custo,convert(varchar(10),@cd_centro_custo)) + ',') > 0
			and CHARINDEX(',' + convert(varchar(10),@CD_PLANO) + ',', ',' + isnull(plano,convert(varchar(10),@CD_PLANO)) + ',') > 0
			and CHARINDEX(',' + Convert(varchar(10),@CD_Servico) + ',',',' + cd_servico + ',') > 0
		
		OPEN cursor_060
		FETCH NEXT FROM cursor_060 INTO @CD_Dado1_Cursor, @CD_Dado2_Cursor, @mensagemAmigavel
		
		WHILE (@@FETCH_STATUS <> -1)
			BEGIN
			
				Set @NR_Quantidade = 0
			
				select @NR_Quantidade = count(cd_sequencial)
				from @tempTableConsultas
				where CD_Sequencial <> @ChavePrimaria
				and cd_servico = @CD_Servico
				and month(dt_servico) = month(getdate())
				and year(dt_servico) = year(getdate())
			
				If @NR_Quantidade >= @CD_Dado2_Cursor
					Begin
						if (@DS_Mensagem <> '')
							Set @DS_Mensagem += '©'
		
						if (@mensagemAmigavel is not null)
							begin
								Set @DS_Mensagem += '60;REGRA 60: ' + @mensagemAmigavel
							end
						else
							begin
								Set @DS_Mensagem += '60;REGRA 60: Procedimento ' + Convert(varchar(10),@CD_Servico) + ' não pode ser lançado, pois já foi realizado ' + convert(varchar,@CD_Dado2_Cursor) + ' vez(es) ou mais no mês corrente.'
							end
						 	                 
						If @Operacao = 3 -- Consultas TEMP
							Begin
								Set @FinalTransacao = 2
							End
						Else
							Begin
								set @FinalTransacao = 3
							End
					End
			
				FETCH NEXT FROM cursor_060 INTO @CD_Dado1_Cursor, @CD_Dado2_Cursor, @mensagemAmigavel
			END
		Close cursor_060
		DEALLOCATE cursor_060
	end


-----------------------------------------------------------------------------------------------
-- REGRA 61 : Procedimentos só podem ser realizados determinado número de vezes no mês corrente para a mesma clínica ou mesmo dentista

if(CHARINDEX(',61,',',' + @regras + ',') > 0)
	begin
		Declare cursor_061 Cursor For
		
			select cd_servico, Numero, mensagemAmigavel
			from TB_Regra_Servico
			where Codigo_Regra = 61
			and CHARINDEX(',' + convert(varchar(10),@cd_centro_custo) + ',', ',' + isnull(centro_custo,convert(varchar(10),@cd_centro_custo)) + ',') > 0
			and CHARINDEX(',' + convert(varchar(10),@CD_PLANO) + ',', ',' + isnull(plano,convert(varchar(10),@CD_PLANO)) + ',') > 0
			and CHARINDEX(',' + Convert(varchar(10),@CD_Servico) + ',',',' + cd_servico + ',') > 0
		
		OPEN cursor_061
		FETCH NEXT FROM cursor_061 INTO @CD_Dado1_Cursor, @CD_Dado2_Cursor, @mensagemAmigavel
		
		WHILE (@@FETCH_STATUS <> -1)
			BEGIN
			
				Set @NR_Quantidade = 0
		
				select @NR_Quantidade = sum(x.qtde)
				from (
					select count(cd_sequencial) qtde
					from @tempTableConsultas
					where CD_Sequencial <> @ChavePrimaria
					and cd_servico = @CD_Servico
					and cd_funcionario = @CD_Funcionario
					and month(dt_servico) = month(getdate())
					and year(dt_servico) = year(getdate())
					union
					select count(cd_sequencial) qtde
					from @tempTableConsultas
					where CD_Sequencial <> @ChavePrimaria
					and cd_servico = @CD_Servico
					and cd_filial = @Filial
					and cd_funcionario <> @CD_Funcionario
					and month(dt_servico) = month(getdate())
					and year(dt_servico) = year(getdate())
				) x
			
				If @NR_Quantidade >= @CD_Dado2_Cursor
					Begin
						if (@DS_Mensagem <> '')
							Set @DS_Mensagem += '©'
		
						if (@mensagemAmigavel is not null)
							begin
								Set @DS_Mensagem += '61;REGRA 61: ' + @mensagemAmigavel
							end
						else
							begin
								Set @DS_Mensagem += '61;REGRA 61: Procedimento ' + Convert(varchar(10),@CD_Servico) + ' não pode ser lançado, pois já foi realizado ' + convert(varchar,@CD_Dado2_Cursor) + ' vez(es) ou mais no mês corrente para o mesmo prestador.'
							end
						 	                 
						If @Operacao = 3 -- Consultas TEMP
							Begin
								Set @FinalTransacao = 2
							End
						Else
							Begin
								set @FinalTransacao = 3
							End
					End
			
				FETCH NEXT FROM cursor_061 INTO @CD_Dado1_Cursor, @CD_Dado2_Cursor, @mensagemAmigavel
			END
		Close cursor_061
		DEALLOCATE cursor_061
	end

-----------------------------------------------------------------------------------------------
-- REGRA 62 : Procedimentos só podem ser realizados em paciente entre determinadas idades

if(CHARINDEX(',62,',',' + @regras + ',') > 0)
	begin
		Declare cursor_062 Cursor For
		
			select idade, idade2, mensagemAmigavel
			From TB_Regra_Servico
			Where Codigo_Regra = 62
			and CHARINDEX(',' + convert(varchar(10),@cd_centro_custo) + ',', ',' + isnull(centro_custo,convert(varchar(10),@cd_centro_custo)) + ',') > 0
			and CHARINDEX(',' + convert(varchar(10),@CD_PLANO) + ',', ',' + isnull(plano,convert(varchar(10),@CD_PLANO)) + ',') > 0
			and CHARINDEX(',' + Convert(varchar(10),@CD_Servico) + ',',',' + cd_servico + ',') > 0
		
		OPEN cursor_062
		FETCH NEXT FROM cursor_062 INTO @CD_Dado1_Cursor, @CD_Dado2_Cursor, @mensagemAmigavel
		
		WHILE (@@FETCH_STATUS <> -1)
			BEGIN
		
				If (@WL_Idade < @CD_Dado1_Cursor or @WL_Idade > @CD_Dado2_Cursor)
					Begin
						if (@DS_Mensagem <> '')
							Set @DS_Mensagem += '©'
						
						if (@mensagemAmigavel is not null)
							begin
								Set @DS_Mensagem += '62;REGRA 62: ' + @mensagemAmigavel
							end
						else
							begin
								Set @DS_Mensagem += '62;REGRA 62: O procedimento ' + convert(varchar(10),@CD_Servico) + ' só pode ser lançado em pacientes entre ' + convert(varchar(10),@CD_Dado1_Cursor) + ' e ' + convert(varchar(10),@CD_Dado2_Cursor) + ' anos. Idade do paciente: ' + convert(varchar,@WL_Idade) + '.'
							end
						
						If @Operacao = 3 -- Consultas TEMP
							Begin
								Set @FinalTransacao = 1
							End
						Else
							Begin
								set @FinalTransacao = 3
							End
					End
		
				FETCH NEXT FROM cursor_062 INTO @CD_Dado1_Cursor, @CD_Dado2_Cursor, @mensagemAmigavel
			END
		Close cursor_062
		DEALLOCATE cursor_062
	end

-----------------------------------------------------------------------------------------------
-- REGRA 63 : Procedimentos só podem ser realizados após um determinado número de meses (Boca, dente/face, região)

if(CHARINDEX(',63,',',' + @regras + ',') > 0)
	begin
		Declare cursor_063 Cursor For
		
			select QT_Meses, mensagemAmigavel
			From TB_Regra_Servico
			Where Codigo_Regra = 63
			and CHARINDEX(',' + convert(varchar(10),@cd_centro_custo) + ',', ',' + isnull(centro_custo,convert(varchar(10),@cd_centro_custo)) + ',') > 0
			and CHARINDEX(',' + convert(varchar(10),@CD_PLANO) + ',', ',' + isnull(plano,convert(varchar(10),@CD_PLANO)) + ',') > 0
			and CHARINDEX(',' + Convert(varchar(10),@CD_Servico) + ',',',' + cd_servico + ',') > 0
		
		OPEN cursor_063
		FETCH NEXT FROM cursor_063 INTO @CD_Dado1_Cursor, @mensagemAmigavel
		
		WHILE (@@FETCH_STATUS <> -1)
			BEGIN
			
				select top 1 @Dt_ProcedimentoBanco = isnull(dt_servico,getdate()+1)
				From @tempTableConsultas
				Where CD_Servico = @CD_Servico
				and isnull(isnull(cd_ud,rboId),7) = isnull(isnull(@CD_UD,@regiao),7)
				and isnull(oclusal,999) = isnull(@Oclusal,999)
				and isnull(distral,999) = isnull(@Distal,999)
				and isnull(mesial,999) = isnull(@Mesial,999)
				and isnull(vestibular,999) = isnull(@Vestibular,999)
				and isnull(lingual,999) = isnull(@Lingual,999)
				and CD_Sequencial <> @ChavePrimaria
				and (dt_servico is null or DateDiff(Month,dt_servico,@DT_Atual) < @CD_Dado1_Cursor)
				order by 1 desc
				
				if @@rowcount > 0 
					Begin
						if @Dt_ProcedimentoBanco > getdate()
							Begin
								if (@DS_Mensagem <> '')
									Set @DS_Mensagem += '©'
						
								if (@mensagemAmigavel is not null)
									begin
										Set @DS_Mensagem += '63;REGRA 63: ' + @mensagemAmigavel
									end
								else
									begin
										Set @DS_Mensagem += '63;REGRA 63: O procedimento ' + Convert(varchar(10),@CD_Servico) + ' está pendente para ser realizado. O procedimento só pode ser realizado a cada ' + convert(varchar,@CD_Dado1_Cursor)  + ' mês(es).'
									end
			       
								If @Operacao = 3 -- Consultas TEMP
									Begin
										Set @FinalTransacao = 1
									End
								Else
									Begin
										Set @FinalTransacao = 3
									End
							End
				
						Else
							Begin
								if (@DS_Mensagem <> '')
									Set @DS_Mensagem += '©'
				
									if (@mensagemAmigavel is not null)
										begin
											Set @DS_Mensagem += '63;REGRA 63: ' + @mensagemAmigavel + '. Data do último procedimento: ' + Convert(varchar,@Dt_ProcedimentoBanco,103) + '.'
										end
									else
										begin
											Set @DS_Mensagem += '63;REGRA 63: Procedimento ' + Convert(varchar(10),@CD_Servico) + ' só pode ser realizado a cada ' + convert(varchar,@CD_Dado1_Cursor) + ' mês(es). Data do último procedimento: ' + Convert(varchar,@Dt_ProcedimentoBanco,103) + '.'
										end
				
								If @Operacao = 3 -- Consultas TEMP
									Begin
										Set @FinalTransacao = 1
									End
								Else
									Begin
										set @FinalTransacao = 3
								End
							End
					End
			
				FETCH NEXT FROM cursor_063 INTO @CD_Dado1_Cursor, @mensagemAmigavel
			END
		Close cursor_063
		DEALLOCATE cursor_063
	end

-----------------------------------------------------------------------------------------------
-- REGRA 64 : Procedimento deve ser informado apenas uma vez (Boca, dente/face, região)

if(CHARINDEX(',64,',',' + @regras + ',') > 0)
	begin
		Declare cursor_064 Cursor For
		
			select cd_servico, mensagemAmigavel
			From TB_Regra_Servico
			Where Codigo_Regra = 64
			and CHARINDEX(',' + convert(varchar(10),@cd_centro_custo) + ',', ',' + isnull(centro_custo,convert(varchar(10),@cd_centro_custo)) + ',') > 0
			and CHARINDEX(',' + convert(varchar(10),@CD_PLANO) + ',', ',' + isnull(plano,convert(varchar(10),@CD_PLANO)) + ',') > 0
			and CHARINDEX(',' + Convert(varchar(10),@CD_Servico) + ',',',' + cd_servico + ',') > 0
		
		OPEN cursor_064
		FETCH NEXT FROM cursor_064 INTO @CD_Dado1_Cursor, @mensagemAmigavel
		
		WHILE (@@FETCH_STATUS <> -1)
			BEGIN
			
				select top 1 @Dt_ProcedimentoBanco = isnull(dt_servico,getdate()+1)
				From @tempTableConsultas
				Where CD_Servico = @CD_Servico
				and isnull(isnull(cd_ud,rboId),7) = isnull(isnull(@CD_UD,@regiao),7)
				and isnull(oclusal,999) = isnull(@Oclusal,999)
				and isnull(distral,999) = isnull(@Distal,999)
				and isnull(mesial,999) = isnull(@Mesial,999)
				and isnull(vestibular,999) = isnull(@Vestibular,999)
				and isnull(lingual,999) = isnull(@Lingual,999)
				and CD_Sequencial <> @ChavePrimaria
				order by 1 desc
				
				if @@rowcount > 0 
					Begin
						if @Dt_ProcedimentoBanco > getdate()
							Begin
								if (@DS_Mensagem <> '')
									Set @DS_Mensagem += '©'
						
								if (@mensagemAmigavel is not null)
									begin
										Set @DS_Mensagem += '64;REGRA 64: ' + @mensagemAmigavel
									end
								else
									begin
										Set @DS_Mensagem += '64;REGRA 64: O procedimento ' + convert(varchar(10),@CD_Servico) + ' está pendente para ser realizado e só pode ser informado uma vez para o mesmo dente ou região.'
									end
			       
								If @Operacao = 3 -- Consultas TEMP
									Begin
										Set @FinalTransacao = 1
									End
								Else
									Begin
										Set @FinalTransacao = 3
									End
							End
				
						Else
							Begin
								if (@DS_Mensagem <> '')
									Set @DS_Mensagem += '©'
				
									if (@mensagemAmigavel is not null)
										begin
											Set @DS_Mensagem += '64;REGRA 64: ' + @mensagemAmigavel + '. Data do último procedimento: ' + Convert(varchar,@Dt_ProcedimentoBanco,103) + '.'
										end
									else
										begin
											Set @DS_Mensagem += '64;REGRA 64: O procedimento ' + convert(varchar(10),@CD_Servico) + ' só pode ser realizado uma vez para o mesmo dente ou região. Data do último procedimento: ' + Convert(varchar,@Dt_ProcedimentoBanco,103) + '.'
										end
				
								If @Operacao = 3 -- Consultas TEMP
									Begin
										Set @FinalTransacao = 1
									End
								Else
									Begin
										set @FinalTransacao = 3
								End
							End
					End
			
				FETCH NEXT FROM cursor_064 INTO @CD_Dado1_Cursor, @mensagemAmigavel
			END
		Close cursor_064
		DEALLOCATE cursor_064
	end

-----------------------------------------------------------------------------------------------
-- REGRA 65 : Ao lançar determinado procedimento, verificar se outros foram lançados antes de um determinado número de dias

if(CHARINDEX(',65,',',' + @regras + ',') > 0)
	begin
		Declare cursor_065 Cursor For
		
			select cd_servico2, qt_meses, mensagemAmigavel
			From TB_Regra_Servico
			Where Codigo_Regra = 65
			and CHARINDEX(',' + convert(varchar(10),@cd_centro_custo) + ',', ',' + isnull(centro_custo,convert(varchar(10),@cd_centro_custo)) + ',') > 0
			and CHARINDEX(',' + convert(varchar(10),@CD_PLANO) + ',', ',' + isnull(plano,convert(varchar(10),@CD_PLANO)) + ',') > 0
			and CHARINDEX(',' + Convert(varchar(10),@CD_Servico) + ',',',' + cd_servico + ',') > 0
		
		OPEN cursor_065
		FETCH NEXT FROM cursor_065 INTO @CD_Dado1_Cursor, @CD_Dado2_Cursor, @mensagemAmigavel
		
		WHILE (@@FETCH_STATUS <> -1)
			BEGIN
			
				select top 1 @Dt_ProcedimentoBanco = isnull(dt_servico,getdate()+1)
				From @tempTableConsultas
				where CHARINDEX(',' + convert(varchar,cd_servico) + ',',',' + @CD_Dado1_Cursor + ',') > 0
				and CD_Sequencial <> @ChavePrimaria
				and (dt_servico is null or DateDiff(day,dt_servico,@DT_Atual) < @CD_Dado2_Cursor)
				order by 1 desc
				
				if @@rowcount > 0
					Begin
						if @Dt_ProcedimentoBanco > getdate()
							Begin
								if (@DS_Mensagem <> '')
									Set @DS_Mensagem += '©'
						
								if (@mensagemAmigavel is not null)
									begin
										Set @DS_Mensagem += '65;REGRA 65: ' + @mensagemAmigavel
									end
								else
									begin
										Set @DS_Mensagem += '65;REGRA 65: Um dos procedimentos ' + @CD_Dado1_Cursor + ' está pendente, conflitando com o lançamento do procedimento ' + convert(varchar(10),@CD_Servico) + '.'
									end
			       
								If @Operacao = 3 -- Consultas TEMP
									Begin
										Set @FinalTransacao = 1
									End
								Else
									Begin
										Set @FinalTransacao = 3
									End
							End
				
						Else
							Begin
								if (@DS_Mensagem <> '')
									Set @DS_Mensagem += '©'
				
									if (@mensagemAmigavel is not null)
										begin
											Set @DS_Mensagem += '65;REGRA 65: ' + @mensagemAmigavel + '. Data do último procedimento: ' + Convert(varchar,@Dt_ProcedimentoBanco,103) + '.'
										end
									else
										begin
											Set @DS_Mensagem += '65;REGRA 65: Um dos procedimento(s) ' + @CD_Dado1_Cursor + ' foi realizado há menos de ' + convert(varchar(10),@CD_Dado2_Cursor) + ' dia(s), conflitando com o lançamento do procedimento ' + convert(varchar(10),@CD_Servico) + '. Data do último procedimento: ' + Convert(varchar,@Dt_ProcedimentoBanco,103) + '.'
										end
				
								If @Operacao = 3 -- Consultas TEMP
									Begin
										Set @FinalTransacao = 1
									End
								Else
									Begin
										set @FinalTransacao = 3
								End
							End
					End
			
				FETCH NEXT FROM cursor_065 INTO @CD_Dado1_Cursor, @CD_Dado2_Cursor, @mensagemAmigavel
			END
		Close cursor_065
		DEALLOCATE cursor_065
	end

-----------------------------------------------------------------------------------------------
-- REGRA 66 : Ao lançar determinado procedimento, verificar se outros foram lançados antes de um determinado número de dias (Boca, dente, região)

if(CHARINDEX(',66,',',' + @regras + ',') > 0)
	begin
		Declare cursor_066 Cursor For
		
			select cd_servico2, qt_meses, mensagemAmigavel
			From TB_Regra_Servico
			Where Codigo_Regra = 66
			and CHARINDEX(',' + convert(varchar(10),@cd_centro_custo) + ',', ',' + isnull(centro_custo,convert(varchar(10),@cd_centro_custo)) + ',') > 0
			and CHARINDEX(',' + convert(varchar(10),@CD_PLANO) + ',', ',' + isnull(plano,convert(varchar(10),@CD_PLANO)) + ',') > 0
			and CHARINDEX(',' + Convert(varchar(10),@CD_Servico) + ',',',' + cd_servico + ',') > 0
		
		OPEN cursor_066
		FETCH NEXT FROM cursor_066 INTO @CD_Dado1_Cursor, @CD_Dado2_Cursor, @mensagemAmigavel
		
		WHILE (@@FETCH_STATUS <> -1)
			BEGIN
			
				select top 1 @Dt_ProcedimentoBanco = isnull(dt_servico,getdate()+1)
				From @tempTableConsultas
				where CHARINDEX(',' + convert(varchar,cd_servico) + ',',',' + @CD_Dado1_Cursor + ',') > 0
				and CD_Sequencial <> @ChavePrimaria
				and (dt_servico is null or DateDiff(day,dt_servico,@DT_Atual) < @CD_Dado2_Cursor)
				and isnull(isnull(cd_ud,rboId),7) = isnull(isnull(@CD_UD,@regiao),7)
				order by 1 desc
				
				if @@rowcount > 0
					Begin
						if @Dt_ProcedimentoBanco > getdate()
							Begin
								if (@DS_Mensagem <> '')
									Set @DS_Mensagem += '©'
						
								if (@mensagemAmigavel is not null)
									begin
										Set @DS_Mensagem += '66;REGRA 66: ' + @mensagemAmigavel
									end
								else
									begin
										Set @DS_Mensagem += '66;REGRA 66: Um dos procedimentos ' + @CD_Dado1_Cursor + ' está pendente, conflitando com o lançamento do procedimento ' + convert(varchar(10),@CD_Servico) + '.'
									end
			       
								If @Operacao = 3 -- Consultas TEMP
									Begin
										Set @FinalTransacao = 1
									End
								Else
									Begin
										Set @FinalTransacao = 3
									End
							End
				
						Else
							Begin
								if (@DS_Mensagem <> '')
									Set @DS_Mensagem += '©'
				
									if (@mensagemAmigavel is not null)
										begin
											Set @DS_Mensagem += '66;REGRA 66: ' + @mensagemAmigavel + '. Data do último procedimento: ' + Convert(varchar,@Dt_ProcedimentoBanco,103) + '.'
										end
									else
										begin
											Set @DS_Mensagem += '66;REGRA 66: Um dos procedimento(s) ' + @CD_Dado1_Cursor + ' foi realizado há menos de ' + convert(varchar(10),@CD_Dado2_Cursor) + ' dia(s), conflitando com o lançamento do procedimento ' + convert(varchar(10),@CD_Servico) + '. Data do último procedimento: ' + Convert(varchar,@Dt_ProcedimentoBanco,103) + '.'
										end
				
								If @Operacao = 3 -- Consultas TEMP
									Begin
										Set @FinalTransacao = 1
									End
								Else
									Begin
										set @FinalTransacao = 3
								End
							End
					End
			
				FETCH NEXT FROM cursor_066 INTO @CD_Dado1_Cursor, @CD_Dado2_Cursor, @mensagemAmigavel
			END
		Close cursor_066
		DEALLOCATE cursor_066
	end


-----------------------------------------------------------------------------------------------
-- REGRA 67 : Ao lançar determinado procedimento, verificar se outros foram lançados antes de um determinado número de dias (Boca, dente/face, região)

if(CHARINDEX(',67,',',' + @regras + ',') > 0)
	begin
		Declare cursor_067 Cursor For
		
			select cd_servico2, qt_meses, mensagemAmigavel
			From TB_Regra_Servico
			Where Codigo_Regra = 67
			and CHARINDEX(',' + convert(varchar(10),@cd_centro_custo) + ',', ',' + isnull(centro_custo,convert(varchar(10),@cd_centro_custo)) + ',') > 0
			and CHARINDEX(',' + convert(varchar(10),@CD_PLANO) + ',', ',' + isnull(plano,convert(varchar(10),@CD_PLANO)) + ',') > 0
			and CHARINDEX(',' + Convert(varchar(10),@CD_Servico) + ',',',' + cd_servico + ',') > 0
		
		OPEN cursor_067
		FETCH NEXT FROM cursor_067 INTO @CD_Dado1_Cursor, @CD_Dado2_Cursor, @mensagemAmigavel
		
		WHILE (@@FETCH_STATUS <> -1)
			BEGIN
			
				select top 1 @Dt_ProcedimentoBanco = isnull(dt_servico,getdate()+1)
				From @tempTableConsultas
				where CHARINDEX(',' + convert(varchar,cd_servico) + ',',',' + @CD_Dado1_Cursor + ',') > 0
				and CD_Sequencial <> @ChavePrimaria
				and (dt_servico is null or DateDiff(day,dt_servico,@DT_Atual) < @CD_Dado2_Cursor)
				and isnull(isnull(cd_ud,rboId),7) = isnull(isnull(@CD_UD,@regiao),7)
				and isnull(oclusal,999) = isnull(@Oclusal,999)
				and isnull(distral,999) = isnull(@Distal,999)
				and isnull(mesial,999) = isnull(@Mesial,999)
				and isnull(vestibular,999) = isnull(@Vestibular,999)
				and isnull(lingual,999) = isnull(@Lingual,999)
				order by 1 desc
				
				if @@rowcount > 0
					Begin
						if @Dt_ProcedimentoBanco > getdate()
							Begin
								if (@DS_Mensagem <> '')
									Set @DS_Mensagem += '©'
						
								if (@mensagemAmigavel is not null)
									begin
										Set @DS_Mensagem += '67;REGRA 67: ' + @mensagemAmigavel
									end
								else
									begin
										Set @DS_Mensagem += '67;REGRA 67: Um dos procedimentos ' + @CD_Dado1_Cursor + ' está pendente, conflitando com o lançamento do procedimento ' + convert(varchar(10),@CD_Servico) + '.'
									end
			       
								If @Operacao = 3 -- Consultas TEMP
									Begin
										Set @FinalTransacao = 1
									End
								Else
									Begin
										Set @FinalTransacao = 3
									End
							End
				
						Else
							Begin
								if (@DS_Mensagem <> '')
									Set @DS_Mensagem += '©'
				
									if (@mensagemAmigavel is not null)
										begin
											Set @DS_Mensagem += '67;REGRA 67: ' + @mensagemAmigavel + '. Data do último procedimento: ' + Convert(varchar,@Dt_ProcedimentoBanco,103) + '.'
										end
									else
										begin
											Set @DS_Mensagem += '67;REGRA 67: Um dos procedimento(s) ' + @CD_Dado1_Cursor + ' foi realizado há menos de ' + convert(varchar(10),@CD_Dado2_Cursor) + ' dia(s), conflitando com o lançamento do procedimento ' + convert(varchar(10),@CD_Servico) + '. Data do último procedimento: ' + Convert(varchar,@Dt_ProcedimentoBanco,103) + '.'
										end
				
								If @Operacao = 3 -- Consultas TEMP
									Begin
										Set @FinalTransacao = 1
									End
								Else
									Begin
										set @FinalTransacao = 3
								End
							End
					End
			
				FETCH NEXT FROM cursor_067 INTO @CD_Dado1_Cursor, @CD_Dado2_Cursor, @mensagemAmigavel
			END
		Close cursor_067
		DEALLOCATE cursor_067
	end

-----------------------------------------------------------------------------------------------
-- REGRA 68 : Auto-Excludência (Boca, dente, região)

if(CHARINDEX(',68,',',' + @regras + ',') > 0)
	begin
		Declare cursor_068 Cursor For
		
			select cd_servico, mensagemAmigavel
			From TB_Regra_Servico
			Where Codigo_Regra = 68
			and CHARINDEX(',' + convert(varchar(10),@cd_centro_custo) + ',', ',' + isnull(centro_custo,convert(varchar(10),@cd_centro_custo)) + ',') > 0
			and CHARINDEX(',' + convert(varchar(10),@CD_PLANO) + ',', ',' + isnull(plano,convert(varchar(10),@CD_PLANO)) + ',') > 0
			and CHARINDEX(',' + Convert(varchar(10),@CD_Servico) + ',',',' + cd_servico + ',') > 0
		
		OPEN cursor_068
		FETCH NEXT FROM cursor_068 INTO @CD_Dado1_Cursor, @mensagemAmigavel
		
		WHILE (@@FETCH_STATUS <> -1)
			BEGIN
			
				select top 1 @Dt_ProcedimentoBanco = isnull(dt_servico,getdate()+1)
				From @tempTableConsultas
				where CHARINDEX(',' + convert(varchar,cd_servico) + ',',',' + @CD_Dado1_Cursor + ',') > 0
				and CD_Sequencial <> @ChavePrimaria
				and isnull(isnull(cd_ud,rboId),7) = isnull(isnull(@CD_UD,@regiao),7)
				order by 1 desc
				
				if @@rowcount > 0
					Begin
						if @Dt_ProcedimentoBanco > getdate()
							Begin
								if (@DS_Mensagem <> '')
									Set @DS_Mensagem += '©'
						
								if (@mensagemAmigavel is not null)
									begin
										Set @DS_Mensagem += '68;REGRA 68: ' + @mensagemAmigavel
									end
								else
									begin
										Set @DS_Mensagem += '68;REGRA 68: O procedimento ' + Convert(varchar(10),@CD_Servico) + ' não pode ser lançado, pois já existe(m) o(s) procedimento(s) ' + @CD_Dado1_Cursor + ' informado(s) anteriormente.'
									end
			       
								If @Operacao = 3 -- Consultas TEMP
									Begin
										Set @FinalTransacao = 1
									End
								Else
									Begin
										Set @FinalTransacao = 3
									End
							End
				
						Else
							Begin
								if (@DS_Mensagem <> '')
									Set @DS_Mensagem += '©'
				
								if (@mensagemAmigavel is not null)
									begin
										Set @DS_Mensagem += '68;REGRA 68: ' + @mensagemAmigavel + '. Data do último procedimento: ' + Convert(varchar,@Dt_ProcedimentoBanco,103) + '.'
									end
								else
									begin
										Set @DS_Mensagem += '68;REGRA 68: O procedimento ' + Convert(varchar(10),@CD_Servico) + ' não pode ser realizado, pois já existe(m) o(s) procedimento(s) ' + @CD_Dado1_Cursor + ' realizado(s) anteriormente. Data do último procedimento: ' + Convert(varchar,@Dt_ProcedimentoBanco,103) + '.'
									end
				
								If @Operacao = 3 -- Consultas TEMP
									Begin
										Set @FinalTransacao = 1
									End
								Else
									Begin
										set @FinalTransacao = 3
								End
							End
					End
			
				FETCH NEXT FROM cursor_068 INTO @CD_Dado1_Cursor, @mensagemAmigavel
			END
		Close cursor_068
		DEALLOCATE cursor_068
	end

-----------------------------------------------------------------------------------------------
-- REGRA 69 : Auto-Excludência (Boca, dente/face, região)

if(CHARINDEX(',69,',',' + @regras + ',') > 0)
	begin
		Declare cursor_069 Cursor For
		
			select cd_servico, mensagemAmigavel
			From TB_Regra_Servico
			Where Codigo_Regra = 69
			and CHARINDEX(',' + convert(varchar(10),@cd_centro_custo) + ',', ',' + isnull(centro_custo,convert(varchar(10),@cd_centro_custo)) + ',') > 0
			and CHARINDEX(',' + convert(varchar(10),@CD_PLANO) + ',', ',' + isnull(plano,convert(varchar(10),@CD_PLANO)) + ',') > 0
			and CHARINDEX(',' + Convert(varchar(10),@CD_Servico) + ',',',' + cd_servico + ',') > 0
		
		OPEN cursor_069
		FETCH NEXT FROM cursor_069 INTO @CD_Dado1_Cursor, @mensagemAmigavel
		
		WHILE (@@FETCH_STATUS <> -1)
			BEGIN
			
				select top 1 @Dt_ProcedimentoBanco = isnull(dt_servico,getdate()+1)
				From @tempTableConsultas
				where CHARINDEX(',' + convert(varchar,cd_servico) + ',',',' + @CD_Dado1_Cursor + ',') > 0
				and CD_Sequencial <> @ChavePrimaria
				and isnull(isnull(cd_ud,rboId),7) = isnull(isnull(@CD_UD,@regiao),7)
				and isnull(oclusal,999) = isnull(@Oclusal,999)
				and isnull(distral,999) = isnull(@Distal,999)
				and isnull(mesial,999) = isnull(@Mesial,999)
				and isnull(vestibular,999) = isnull(@Vestibular,999)
				and isnull(lingual,999) = isnull(@Lingual,999)
				order by 1 desc
				
				if @@rowcount > 0
					Begin
						if @Dt_ProcedimentoBanco > getdate()
							Begin
								if (@DS_Mensagem <> '')
									Set @DS_Mensagem += '©'
						
								if (@mensagemAmigavel is not null)
									begin
										Set @DS_Mensagem += '69;REGRA 69: ' + @mensagemAmigavel
									end
								else
									begin
										Set @DS_Mensagem += '69;REGRA 69: O procedimento ' + Convert(varchar(10),@CD_Servico) + ' não pode ser lançado, pois já existe(m) o(s) procedimento(s) ' + @CD_Dado1_Cursor + ' informado(s) anteriormente.'
									end
			       
								If @Operacao = 3 -- Consultas TEMP
									Begin
										Set @FinalTransacao = 1
									End
								Else
									Begin
										Set @FinalTransacao = 3
									End
							End
				
						Else
							Begin
								if (@DS_Mensagem <> '')
									Set @DS_Mensagem += '©'
				
								if (@mensagemAmigavel is not null)
									begin
										Set @DS_Mensagem += '69;REGRA 69: ' + @mensagemAmigavel + '. Data do último procedimento: ' + Convert(varchar,@Dt_ProcedimentoBanco,103) + '.'
									end
								else
									begin
										Set @DS_Mensagem += '69;REGRA 69: O procedimento ' + Convert(varchar(10),@CD_Servico) + ' não pode ser realizado, pois já existe(m) o(s) procedimento(s) ' + @CD_Dado1_Cursor + ' realizado(s) anteriormente. Data do último procedimento: ' + Convert(varchar,@Dt_ProcedimentoBanco,103) + '.'
									end
				
								If @Operacao = 3 -- Consultas TEMP
									Begin
										Set @FinalTransacao = 1
									End
								Else
									Begin
										set @FinalTransacao = 3
								End
							End
					End
			
				FETCH NEXT FROM cursor_069 INTO @CD_Dado1_Cursor, @mensagemAmigavel
			END
		Close cursor_069
		DEALLOCATE cursor_069
	end

-----------------------------------------------------------------------------------------------
-- REGRA 70 : Procedimentos só podem ser realizados após um determinado número de dias (Boca, dente/face, região)

if(CHARINDEX(',70,',',' + @regras + ',') > 0)
	begin
		Declare cursor_070 Cursor For
			Select QT_Meses, mensagemAmigavel
			From TB_Regra_Servico
			Where Codigo_Regra = 70
			and CHARINDEX(',' + convert(varchar(10),@cd_centro_custo) + ',', ',' + isnull(centro_custo,convert(varchar(10),@cd_centro_custo)) + ',') > 0
			and CHARINDEX(',' + convert(varchar(10),@CD_PLANO) + ',', ',' + isnull(plano,convert(varchar(10),@CD_PLANO)) + ',') > 0
			and CHARINDEX(',' + Convert(varchar(10),@CD_Servico) + ',',',' + cd_servico + ',') > 0
		
		OPEN cursor_070
		FETCH NEXT FROM cursor_070 INTO @CD_Dado1_Cursor, @mensagemAmigavel
		
		WHILE (@@FETCH_STATUS <> -1)
			BEGIN
		
				select top 1 @Dt_ProcedimentoBanco = isnull(dt_servico,getdate()+1)
				from @tempTableConsultas
				where CD_Servico = @CD_Servico
				and isnull(isnull(cd_ud,rboId),7) = isnull(isnull(@CD_UD,@regiao),7)
				and isnull(oclusal,999) = isnull(@Oclusal,999)
				and isnull(distral,999) = isnull(@Distal,999)
				and isnull(mesial,999) = isnull(@Mesial,999)
				and isnull(vestibular,999) = isnull(@Vestibular,999)
				and isnull(lingual,999) = isnull(@Lingual,999)
				and (dt_servico is null or DateDiff(day,dt_servico,@DT_Atual) < @CD_Dado1_Cursor)
				and CD_Sequencial <> @ChavePrimaria
				order by 1 desc
		 
				if @@rowcount > 0
					Begin
						if @Dt_ProcedimentoBanco > getdate()
							Begin
								if (@DS_Mensagem <> '')
									Set @DS_Mensagem += '©'
									
								if (@mensagemAmigavel is not null)
									begin
										Set @DS_Mensagem += '70;REGRA 70: ' + @mensagemAmigavel
									end
								else
									begin
										Set @DS_Mensagem += '70;REGRA 70: O procedimento ' + Convert(varchar(10),@CD_Servico) + ' está pendente para ser realizado. O procedimento só pode ser realizado a cada ' + convert(varchar,@CD_Dado1_Cursor)  + ' dia(s).'
									end
		
								If @Operacao = 3 -- Consultas TEMP
									Begin
										Set @FinalTransacao = 1
									End
								Else
									Begin
										Set @FinalTransacao = 3
									End
							End
		
						Else
							Begin
								if (@DS_Mensagem <> '')
									Set @DS_Mensagem += '©'
						
									if (@mensagemAmigavel is not null)
										begin
											Set @DS_Mensagem += '70;REGRA 70: ' + @mensagemAmigavel + '. Data do último procedimento: ' + Convert(varchar,@Dt_ProcedimentoBanco,103) + '.'
										end
									else
										begin
											Set @DS_Mensagem += '70;REGRA 70: Procedimento ' + Convert(varchar(10),@CD_Servico) + ' só pode ser realizado a cada ' + convert(varchar,@CD_Dado1_Cursor) + ' dia(s). Data do último procedimento: ' + Convert(varchar,@Dt_ProcedimentoBanco,103) + '.'
										end
						
								If @Operacao = 3 -- Consultas TEMP
									Begin
										Set @FinalTransacao = 1
									End
								Else
									Begin
										set @FinalTransacao = 3
									End
							End
					End
			
				FETCH NEXT FROM cursor_070 INTO @CD_Dado1_Cursor, @mensagemAmigavel
			END
		Close cursor_070
		DEALLOCATE cursor_070
	end

-----------------------------------------------------------------------------------------------
-- REGRA 71 : Tempo mínimo de pausa do procedimento para nova realização

if(CHARINDEX(',71,',',' + @regras + ',') > 0)
	begin
		Declare cursor_071 Cursor For
		
			select QT_Meses, mensagemAmigavel
			from TB_Regra_Servico
			where Codigo_Regra = 71
			and CHARINDEX(',' + convert(varchar(10),@cd_centro_custo) + ',', ',' + isnull(centro_custo,convert(varchar(10),@cd_centro_custo)) + ',') > 0
			and CHARINDEX(',' + convert(varchar(10),@CD_PLANO) + ',', ',' + isnull(plano,convert(varchar(10),@CD_PLANO)) + ',') > 0
			and CHARINDEX(',' + Convert(varchar(10),@CD_Servico) + ',',',' + cd_servico + ',') > 0
		
		OPEN cursor_071
		FETCH NEXT FROM cursor_071 INTO @CD_Dado1_Cursor, @mensagemAmigavel
		
		WHILE (@@FETCH_STATUS <> -1)
			BEGIN
		
				select top 1 @Dt_ProcedimentoBanco = dt_servico
				from @tempTableConsultas
				where CD_Servico = @CD_Servico
				and dt_servico is not null
				and CD_Sequencial <> @ChavePrimaria
				order by 1 desc
		 
				if @@rowcount > 0
					Begin
						if @Dt_ProcedimentoBanco < convert(date,dateadd(day,-convert(int,@CD_Dado1_Cursor),getdate()))
							Begin
								if (@DS_Mensagem <> '')
									Set @DS_Mensagem += '©'
									
								if (@mensagemAmigavel is not null)
									begin
										Set @DS_Mensagem += '71;REGRA 71: ' + @mensagemAmigavel + '. Data do último procedimento: ' + Convert(varchar,@Dt_ProcedimentoBanco,103) + '.'
									end
								else
									begin
										Set @DS_Mensagem += '71;REGRA 71: O procedimento ' + Convert(varchar(10),@CD_Servico) + ' excedeu o tempo mínimo de pausa de ' + convert(varchar,@CD_Dado1_Cursor)  + ' dia(s) para nova realização. Data do último procedimento: ' + Convert(varchar,@Dt_ProcedimentoBanco,103) + '.'
									end
		
								If @Operacao = 3 -- Consultas TEMP
									Begin
										Set @FinalTransacao = 1
									End
								Else
									Begin
										Set @FinalTransacao = 3
									End
							End
		
					End
			
				FETCH NEXT FROM cursor_071 INTO @CD_Dado1_Cursor, @mensagemAmigavel
			END
		Close cursor_071
		DEALLOCATE cursor_071
	end


-----------------------------------------------------------------------------------------------
-- REGRA 72 : Procedimentos não podem ser lançados juntos na mesma GTO

if(CHARINDEX(',72,',',' + @regras + ',') > 0)
	begin
		Declare cursor_072 Cursor For
		
			select cd_servico, mensagemAmigavel
			from TB_Regra_Servico
			where Codigo_Regra = 72
			and CHARINDEX(',' + convert(varchar(10),@cd_centro_custo) + ',', ',' + isnull(centro_custo,convert(varchar(10),@cd_centro_custo)) + ',') > 0
			and CHARINDEX(',' + convert(varchar(10),@CD_PLANO) + ',', ',' + isnull(plano,convert(varchar(10),@CD_PLANO)) + ',') > 0
			and CHARINDEX(',' + Convert(varchar(10),@CD_Servico) + ',',',' + cd_servico + ',') > 0
		
		OPEN cursor_072
		FETCH NEXT FROM cursor_072 INTO @CD_Dado1_Cursor, @mensagemAmigavel
		
		WHILE (@@FETCH_STATUS <> -1)
			BEGIN
		
				select T1.cd_servico
				from @tempTableConsultas T1
				where T1.cd_sequencial = @ChavePrimaria
				and (
					select count(0)
					from @tempTableConsultas
					where nr_gto = T1.nr_gto
					and CHARINDEX(',' + convert(varchar,cd_servico) + ',',',' + @CD_Dado1_Cursor + ',') > 0
					and cd_servico <> @CD_Servico
				) > 0
		 
				if @@rowcount > 0
					Begin
						if (@DS_Mensagem <> '')
							Set @DS_Mensagem += '©'
							
						if (@mensagemAmigavel is not null)
							begin
								Set @DS_Mensagem += '72;REGRA 72: ' + @mensagemAmigavel + '.'
							end
						else
							begin
								Set @DS_Mensagem += '72;REGRA 72: Os procedimentos ' + convert(varchar,@CD_Dado1_Cursor)  + ' não podem ser lançados juntos na mesma GTO.'
							end
			
						If @Operacao = 3 -- Consultas TEMP
							Begin
								Set @FinalTransacao = 1
							End
						Else
							Begin
								Set @FinalTransacao = 3
							End
					End
			
				FETCH NEXT FROM cursor_072 INTO @CD_Dado1_Cursor, @mensagemAmigavel
			END
		Close cursor_072
		DEALLOCATE cursor_072
	end

-----------------------------------------------------------------------------------------------
-- REGRA 73 : Procedimentos só podem ser feitos após um determinado numero de dias para o mesmo dente/região (auto-excludente)

if(CHARINDEX(',73,',',' + @regras + ',') > 0)
	begin
		Declare cursor_073 Cursor For
		
			Select cd_servico, QT_Meses, mensagemAmigavel
			From TB_Regra_Servico
			Where Codigo_Regra = 73
			and CHARINDEX(',' + convert(varchar(10),@cd_centro_custo) + ',', ',' + isnull(centro_custo,convert(varchar(10),@cd_centro_custo)) + ',') > 0
			and CHARINDEX(',' + convert(varchar(10),@CD_PLANO) + ',', ',' + isnull(plano,convert(varchar(10),@CD_PLANO)) + ',') > 0
			and CHARINDEX(',' + Convert(varchar(10),@CD_Servico) + ',',',' + cd_servico + ',') > 0
		
		OPEN cursor_073
		FETCH NEXT FROM cursor_073 INTO @CD_Dado1_Cursor, @CD_Dado3_Cursor, @mensagemAmigavel
		
		WHILE (@@FETCH_STATUS <> -1)
			BEGIN
		
				select top 1 @Dt_ProcedimentoBanco = isnull(dt_servico,getdate()+1)
				from @tempTableConsultas as t1
				where isnull(isnull(cd_ud,rboId),7) = isnull(isnull(@CD_UD,@regiao),7)
				and CD_Sequencial <> @ChavePrimaria
				and (dt_servico is null or DateDiff(day,dt_servico,@DT_Atual) < @CD_Dado3_Cursor)
				and CHARINDEX(',' + convert(varchar,CD_Servico) + ',',',' + @CD_Dado1_Cursor + ',') > 0
		        
				if @@rowcount > 0
					Begin
						if @Dt_ProcedimentoBanco > getdate()
							Begin
								if (@DS_Mensagem <> '')
									Set @DS_Mensagem += '©'
				
								if (@mensagemAmigavel is not null)
									begin
										Set @DS_Mensagem += '73;REGRA 73: ' + @mensagemAmigavel
									end
								else
									begin
										Set @DS_Mensagem += '73;REGRA 73: O procedimento ' + Convert(varchar(10),@CD_Servico) + ' está pendente para ser realizado. O procedimento só pode ser realizado depois de ' + convert(varchar,@CD_Dado3_Cursor) + ' dia(s) para o mesmo dente/região por auto-excludência.'
									end
								 	                 
								If @Operacao = 3 -- Consultas TEMP
									Begin
										Set @FinalTransacao = 2
									End
								Else
									Begin
										set @FinalTransacao = 3
									End
							end
						else
							begin
								if (@DS_Mensagem <> '')
									Set @DS_Mensagem += '©'
				
								if (@mensagemAmigavel is not null)
									begin
										Set @DS_Mensagem += '73;REGRA 73: ' + @mensagemAmigavel
									end
								else
									begin
										Set @DS_Mensagem += '73;REGRA 73: Procedimento ' + Convert(varchar(10),@CD_Servico) + ' só pode ser realizado depois de ' + convert(varchar,@CD_Dado3_Cursor) + ' dia(s) para o mesmo dente/região por auto-excludência. Data do último procedimento: ' + Convert(varchar,@Dt_ProcedimentoBanco,103) + '.'
									end
								 	                 
								If @Operacao = 3 -- Consultas TEMP
									Begin
										Set @FinalTransacao = 2
									End
								Else
									Begin
										set @FinalTransacao = 3
									End
							end
					End
		
				FETCH NEXT FROM cursor_073 INTO @CD_Dado1_Cursor,@CD_Dado3_Cursor, @mensagemAmigavel
			END
		Close cursor_073
		DEALLOCATE cursor_073
	end

-----------------------------------------------------------------------------------------------
-- REGRA 74 : Procedimentos só podem ser feitos depois de um determinado numero de dias no mesmo dente ou região para o mesma clínica (auto-excludente)
-----------------------------------------------------------------------------------------------

if(CHARINDEX(',74,',',' + @regras + ',') > 0)
	begin
		Declare cursor_074 Cursor For
		
			Select cd_servico, QT_Meses, mensagemAmigavel
			From TB_Regra_Servico
			Where Codigo_Regra = 74
			and CHARINDEX(',' + convert(varchar(10),@cd_centro_custo) + ',', ',' + isnull(centro_custo,convert(varchar(10),@cd_centro_custo)) + ',') > 0
			and CHARINDEX(',' + convert(varchar(10),@CD_PLANO) + ',', ',' + isnull(plano,convert(varchar(10),@CD_PLANO)) + ',') > 0
			and CHARINDEX(',' + Convert(varchar(10),@CD_Servico) + ',',',' + cd_servico + ',') > 0
			and isnull(@CD_UD,@regiao) is not null
		
		OPEN cursor_074
		FETCH NEXT FROM cursor_074 INTO @CD_Dado1_Cursor, @CD_Dado3_Cursor, @mensagemAmigavel
		
		WHILE (@@FETCH_STATUS <> -1)
			BEGIN
		
				Select top 1 @Dt_ProcedimentoBanco = isnull(dt_servico,getdate()+1)
				From @tempTableConsultas
				Where isnull(isnull(cd_ud,rboId),7) = isnull(isnull(@CD_UD,@regiao),7)
				and CD_Sequencial <> @ChavePrimaria
				and (dt_servico is null or DateDiff(day,dt_servico,@DT_Atual) < @CD_Dado3_Cursor)
				and (cd_filial = @Filial or nr_cgc = @CNPJClinica)
				and CHARINDEX(',' + convert(varchar,CD_Servico) + ',',',' + @CD_Dado1_Cursor + ',') > 0
		
				if @@rowcount > 0
					Begin
						if @Dt_ProcedimentoBanco > getdate()
							Begin
								if (@DS_Mensagem <> '')
									Set @DS_Mensagem += '©'
		
								if (@mensagemAmigavel is not null)
									begin
										Set @DS_Mensagem += '74;REGRA 74: ' + @mensagemAmigavel
									end
								else
									begin
										Set @DS_Mensagem += '74;REGRA 74: O procedimento ' + Convert(varchar(10),@CD_Servico) + ' está pendente para ser realizado. O procedimento só pode ser realizado a cada ' + convert(varchar,@CD_Dado3_Cursor) + ' dia(s) para o mesmo dente ou região para a mesma clínica.'
									end
		
								If @Operacao = 3 -- Consultas TEMP
									Begin
										Set @FinalTransacao = 1
									End
								Else
									Begin
										Set @FinalTransacao = 3
									End  
							End
		
						else
							Begin
								if (@DS_Mensagem <> '')
									Set @DS_Mensagem += '©'
		
								if (@mensagemAmigavel is not null)
									begin
										Set @DS_Mensagem += '74;REGRA 74: ' + @mensagemAmigavel
									end
								else
									begin
										Set @DS_Mensagem += '74;REGRA 74: Procedimento ' + Convert(varchar(10),@CD_Servico) + ' só pode ser realizado a cada ' + convert(varchar,@CD_Dado3_Cursor) + ' dia(s) para o mesmo dente ou região para a mesma clínica. Data do último procedimento: ' + Convert(varchar,@Dt_ProcedimentoBanco,103) + '.'
									end
		
								If @Operacao = 3 -- Consultas TEMP
									Begin
										Set @FinalTransacao = 1
									End
								Else
									Begin
										set @FinalTransacao = 3
									End  
							End
					End
		
		
				FETCH NEXT FROM cursor_074 INTO @CD_Dado1_Cursor,@CD_Dado3_Cursor, @mensagemAmigavel
			END
		Close cursor_074
		DEALLOCATE cursor_074
	end

-----------------------------------------------------------------------------------------------
-- REGRA 75 : Procedimentos auto-excludentes por quantidade, dias, clínica
-----------------------------------------------------------------------------------------------

if(CHARINDEX(',75,',',' + @regras + ',') > 0)
	begin
		Declare cursor_075 Cursor For
		
			select cd_servico, QT_Meses, Numero, mensagemAmigavel
			from TB_Regra_Servico
			where Codigo_Regra = 75
			and CHARINDEX(',' + convert(varchar(10),@cd_centro_custo) + ',', ',' + isnull(centro_custo,convert(varchar(10),@cd_centro_custo)) + ',') > 0
			and CHARINDEX(',' + convert(varchar(10),@CD_PLANO) + ',', ',' + isnull(plano,convert(varchar(10),@CD_PLANO)) + ',') > 0
			and CHARINDEX(',' + Convert(varchar(10),@CD_Servico) + ',',',' + cd_servico + ',') > 0
		
		OPEN cursor_075
		FETCH NEXT FROM cursor_075 INTO @CD_Dado1_Cursor, @CD_Dado2_Cursor, @CD_Dado3_Cursor, @mensagemAmigavel
		
		WHILE (@@FETCH_STATUS <> -1)
			BEGIN
			
				Set @NR_Quantidade = 0
			
				select @NR_Quantidade = count(cd_sequencial)
				from @tempTableConsultas
				where CD_Sequencial <> @ChavePrimaria
				and (cd_filial = @Filial or nr_cgc = @CNPJClinica)
				and CHARINDEX(',' + convert(varchar,CD_Servico) + ',',',' + @CD_Dado1_Cursor + ',') > 0
				and (dt_servico is null or dt_servico >= dateadd(day,@CD_Dado2_Cursor * -1,getdate()))
			
				If @NR_Quantidade >= @CD_Dado3_Cursor
					Begin
						if (@DS_Mensagem <> '')
							Set @DS_Mensagem += '©'
		
						if (@mensagemAmigavel is not null)
							begin
								Set @DS_Mensagem += '75;REGRA 75: ' + @mensagemAmigavel
							end
						else
							begin
								if (CHARINDEX(Convert(varchar(10),@CD_Servico),',') > 0)
									begin
										Set @DS_Mensagem += '75;REGRA 75: Procedimento ' + Convert(varchar(10),@CD_Servico) + ' não pode ser incluído, pois o procedimento ' + @CD_Dado1_Cursor + ' já foi informado ' + convert(varchar,@CD_Dado3_Cursor) + ' vez(es) ou mais no período de ' + convert(varchar,@CD_Dado2_Cursor) + ' dia(s) para a mesma clínica.'
									end
								else
									begin
										Set @DS_Mensagem += '75;REGRA 75: Procedimento ' + Convert(varchar(10),@CD_Servico) + ' não pode ser incluído, pois já foi informado ' + convert(varchar,@CD_Dado3_Cursor) + ' vez(es) ou mais no período de ' + convert(varchar,@CD_Dado2_Cursor) + ' dia(s) para a mesma clínica.'
									end
							end
						 	                 
						If @Operacao = 3 -- Consultas TEMP
							Begin
								Set @FinalTransacao = 2
							End
						Else
							Begin
								set @FinalTransacao = 3
							End
					End
			
				FETCH NEXT FROM cursor_075 INTO @CD_Dado1_Cursor, @CD_Dado2_Cursor, @CD_Dado3_Cursor, @mensagemAmigavel
			END
		Close cursor_075
		DEALLOCATE cursor_075
	end

-----------------------------------------------------------------------------------------------
-- REGRA 76 : Procedimentos auto-excludentes por quantidade, meses, clínica
-----------------------------------------------------------------------------------------------

if(CHARINDEX(',76,',',' + @regras + ',') > 0)
	begin
		Declare cursor_076 Cursor For
		
			select cd_servico, QT_Meses, Numero, mensagemAmigavel
			from TB_Regra_Servico
			where Codigo_Regra = 76
			and CHARINDEX(',' + convert(varchar(10),@cd_centro_custo) + ',', ',' + isnull(centro_custo,convert(varchar(10),@cd_centro_custo)) + ',') > 0
			and CHARINDEX(',' + convert(varchar(10),@CD_PLANO) + ',', ',' + isnull(plano,convert(varchar(10),@CD_PLANO)) + ',') > 0
			and CHARINDEX(',' + Convert(varchar(10),@CD_Servico) + ',',',' + cd_servico + ',') > 0
		
		OPEN cursor_076
		FETCH NEXT FROM cursor_076 INTO @CD_Dado1_Cursor, @CD_Dado2_Cursor, @CD_Dado3_Cursor, @mensagemAmigavel
		
		WHILE (@@FETCH_STATUS <> -1)
			BEGIN
			
				Set @NR_Quantidade = 0
			
				select @NR_Quantidade = count(cd_sequencial)
				from @tempTableConsultas
				where CD_Sequencial <> @ChavePrimaria
				and (cd_filial = @Filial or nr_cgc = @CNPJClinica)
				and CHARINDEX(',' + convert(varchar,CD_Servico) + ',',',' + @CD_Dado1_Cursor + ',') > 0
				and (dt_servico is null or dt_servico >= dateadd(month,@CD_Dado2_Cursor * -1,getdate()))
			
				If @NR_Quantidade >= @CD_Dado3_Cursor
					Begin
						if (@DS_Mensagem <> '')
							Set @DS_Mensagem += '©'
		
						if (@mensagemAmigavel is not null)
							begin
								Set @DS_Mensagem += '76;REGRA 76: ' + @mensagemAmigavel
							end
						else
							begin
								if (CHARINDEX(Convert(varchar(10),@CD_Servico),',') > 0)
									begin
										Set @DS_Mensagem += '76;REGRA 76: Procedimento ' + Convert(varchar(10),@CD_Servico) + ' não pode ser lançado, pois o procedimento ' + @CD_Dado1_Cursor + ' já foi informado ' + convert(varchar,@CD_Dado3_Cursor) + ' vez(es) ou mais no período de ' + convert(varchar,@CD_Dado2_Cursor) + ' mês(es) para a mesma clínica.'
									end
								else
									begin
										Set @DS_Mensagem += '76;REGRA 76: Procedimento ' + Convert(varchar(10),@CD_Servico) + ' não pode ser lançado, pois já foi informado ' + convert(varchar,@CD_Dado3_Cursor) + ' vez(es) ou mais no período de ' + convert(varchar,@CD_Dado2_Cursor) + ' mês(es) para a mesma clínica.'
									end
							end
		
						If @Operacao = 3 -- Consultas TEMP
							Begin
								Set @FinalTransacao = 2
							End
						Else
							Begin
								set @FinalTransacao = 3
							End
					End
			
				FETCH NEXT FROM cursor_076 INTO @CD_Dado1_Cursor, @CD_Dado2_Cursor, @CD_Dado3_Cursor, @mensagemAmigavel
			END
		Close cursor_076
		DEALLOCATE cursor_076
	end
	
-----------------------------------------------------------------------------------------------
-- REGRA 77 : Procedimento só pode ser realizado determinado número de vezes em determinado número de anos (se não informado: 1 ano)
-----------------------------------------------------------------------------------------------

if(CHARINDEX(',77,',',' + @regras + ',') > 0)
	begin
		Declare cursor_077 Cursor For
			Select cd_servico, Numero, isnull(QT_Meses,1), mensagemAmigavel
			From TB_Regra_Servico
			Where Codigo_Regra = 77
			and CHARINDEX(',' + convert(varchar(10),@cd_centro_custo) + ',', ',' + isnull(centro_custo,convert(varchar(10),@cd_centro_custo)) + ',') > 0
			and CHARINDEX(',' + convert(varchar(10),@CD_PLANO) + ',', ',' + isnull(plano,convert(varchar(10),@CD_PLANO)) + ',') > 0
		OPEN cursor_077
		FETCH NEXT FROM cursor_077 INTO @CD_Dado1_Cursor,@CD_Dado3_Cursor,@CD_Dado4_Cursor, @mensagemAmigavel
		WHILE (@@FETCH_STATUS <> -1)
			BEGIN
				If CHARINDEX(',' + Convert(varchar(10),@CD_Servico) + ',',',' + @CD_Dado1_Cursor + ',') > 0
						Begin
							Select @NR_Quantidade = Count(cd_sequencial)
							From @tempTableConsultas as t1
							Where CD_Servico = @CD_Servico
							And isnull(DT_Servico,getdate()) >= dateadd(year,-1*@CD_Dado4_Cursor,Getdate())
							And CD_Sequencial <> @ChavePrimaria
	                   
							if @NR_Quantidade >= @CD_Dado3_Cursor
								Begin
									if (@DS_Mensagem <> '')
										Set @DS_Mensagem += '©'
										if (@mensagemAmigavel is not null)
											begin
												Set @DS_Mensagem += '77;REGRA 77: ' + @mensagemAmigavel
											end
										else
											begin
												Set @DS_Mensagem += '77;REGRA 77: O procedimento ' + Convert(varchar(10),@CD_Servico) + ' só pode ser realizado ' + convert(varchar(10),@CD_Dado3_Cursor) + ' vez(es) a cada ' + convert(varchar(10),@CD_Dado4_Cursor) + ' ano(s).'
											end
											If @Operacao = 3 -- Consultas TEMP
												  Begin
													Set @FinalTransacao = 1
												  End
											   Else
												  Begin
													set @FinalTransacao = 3
												  End  
											End
								End
			FETCH NEXT FROM cursor_077 INTO @CD_Dado1_Cursor,@CD_Dado3_Cursor,@CD_Dado4_Cursor, @mensagemAmigavel
		END
	Close cursor_077
	DEALLOCATE cursor_077
end

-----------------------------------------------------------------------------------------------
-- REGRA 78 : Procedimentos por quantidade, meses, clínica (CNPJ)
-----------------------------------------------------------------------------------------------

if(CHARINDEX(',78,',',' + @regras + ',') > 0)
	begin
		Declare cursor_078 Cursor For
		
			select cd_servico, QT_Meses, Numero, mensagemAmigavel
			from TB_Regra_Servico
			where Codigo_Regra = 78
			and CHARINDEX(',' + convert(varchar(10),@cd_centro_custo) + ',', ',' + isnull(centro_custo,convert(varchar(10),@cd_centro_custo)) + ',') > 0
			and CHARINDEX(',' + convert(varchar(10),@CD_PLANO) + ',', ',' + isnull(plano,convert(varchar(10),@CD_PLANO)) + ',') > 0
			and CHARINDEX(',' + Convert(varchar(10),@CD_Servico) + ',',',' + cd_servico + ',') > 0
		
		OPEN cursor_078
		FETCH NEXT FROM cursor_078 INTO @CD_Dado1_Cursor, @CD_Dado2_Cursor, @CD_Dado3_Cursor, @mensagemAmigavel
		
		WHILE (@@FETCH_STATUS <> -1)
			BEGIN
			
				Set @NR_Quantidade = 0
			
				select @NR_Quantidade = count(cd_sequencial)
				from @tempTableConsultas
				where CD_Sequencial <> @ChavePrimaria
				and (cd_filial = @Filial or nr_cgc = @CNPJClinica)
				and CD_Servico = @CD_Servico
				and (dt_servico is null or dt_servico >= dateadd(month,@CD_Dado2_Cursor * -1,getdate()))
			
				If @NR_Quantidade >= @CD_Dado3_Cursor
					Begin
						if (@DS_Mensagem <> '')
							Set @DS_Mensagem += '©'
		
						if (@mensagemAmigavel is not null)
							begin
								Set @DS_Mensagem += '78;REGRA 78: ' + @mensagemAmigavel
							end
						else
							begin
								if (CHARINDEX(Convert(varchar(10),@CD_Servico),',') > 0)
									begin
										Set @DS_Mensagem += '78;REGRA 78: Procedimento ' + Convert(varchar(10),@CD_Servico) + ' não pode ser lançado, pois o procedimento ' + @CD_Dado1_Cursor + ' já foi informado ' + convert(varchar,@CD_Dado3_Cursor) + ' vez(es) ou mais no período de ' + convert(varchar,@CD_Dado2_Cursor) + ' mês(es) para a mesma clínica.'
									end
								else
									begin
										Set @DS_Mensagem += '78;REGRA 78: Procedimento ' + Convert(varchar(10),@CD_Servico) + ' não pode ser lançado, pois já foi informado ' + convert(varchar,@CD_Dado3_Cursor) + ' vez(es) ou mais no período de ' + convert(varchar,@CD_Dado2_Cursor) + ' mês(es) para a mesma clínica.'
									end
							end
		
						If @Operacao = 3 -- Consultas TEMP
							Begin
								Set @FinalTransacao = 2
							End
						Else
							Begin
								set @FinalTransacao = 3
							End
					End
			
				FETCH NEXT FROM cursor_078 INTO @CD_Dado1_Cursor, @CD_Dado2_Cursor, @CD_Dado3_Cursor, @mensagemAmigavel
			END
		Close cursor_078
		DEALLOCATE cursor_078
	end


----------------------------------------------------
--Retirar mensagens duplicadas
----------------------------------------------------

DECLARE @list varchar(max)
DECLARE @pos INT
DECLARE @len INT
DECLARE @value varchar(max)

SET @list = @DS_Mensagem + '©'
set @DS_Mensagem = ''
set @pos = 0
set @len = 0

WHILE CHARINDEX('©', @list, @pos+1)>0
BEGIN
    set @len = CHARINDEX('©', @list, @pos+1) - @pos
    set @value = SUBSTRING(@list, @pos, @len)
    
    if (CHARINDEX(@value, @DS_Mensagem) = 0)
		begin
			if (@DS_Mensagem <> '')
				begin
					Set @DS_Mensagem += '©'
				end
			set @DS_Mensagem += @value
		end
    set @pos = CHARINDEX('©', @list, @pos+@len) +1
END
----------------------------------------------------

End
