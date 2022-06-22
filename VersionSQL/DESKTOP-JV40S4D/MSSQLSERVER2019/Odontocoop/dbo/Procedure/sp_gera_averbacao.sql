/****** Object:  Procedure [dbo].[sp_gera_averbacao]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE Procedure [dbo].[sp_gera_averbacao]
   @cd_tipo_pagamento smallint, @cd_tipo_servico_bancario smallint
As
Begin
 
  Begin Transaction 

   Declare @cd_sequencial int
   Declare @cd_funcionario int 
   Declare @qtlinha int = 0
   Declare @nm_sacado varchar(100)
   Declare @dt_venc datetime
   Declare @dt_venc_B datetime
   
   Set @cd_funcionario=0 
   select @cd_funcionario = cd_funcionario from processos where cd_processo = 1
   if @cd_funcionario = 0 or @cd_funcionario is null 
    Begin -- 1.1
  	  ROLLBACK TRANSACTION
	  Raiserror('Funcionario de atualização do Processo não definido.',16,1)
	  RETURN
    End -- 1.1

   Set @cd_sequencial = 0 

   print '----PB 1'
   Select @cd_sequencial=isnull(max(cd_sequencial),0)
     from averbacao_lote
    where cd_tipo_pagamento = @cd_tipo_pagamento and 
          cd_tipo_servico_bancario = @cd_tipo_servico_bancario and 
          dt_finalizado is null   

    if @cd_sequencial=0
    Begin

      -- Verificar se tem algum para entrar no lote 
      select @cd_sequencial = COUNT(0)
        from averbacao as a, ASSOCIADOS as s, EMPRESA as e
       where cd_sequencial is null and 
             a.cd_Associado=s.cd_associado and 
             s.cd_empresa = e.CD_EMPRESA and 
             e.cd_tipo_pagamento=@cd_tipo_pagamento
       
       if @cd_sequencial  = 0 -- Nao tem nenhum contrato. Nao precisa abrir lote
       Begin
          commit 
          return 
       End    

       print '----PB 3'

       insert into averbacao_lote (cd_tipo_servico_bancario, cd_tipo_pagamento, dt_gerado, cd_funcionario) 
        Values (@cd_tipo_servico_bancario, @cd_tipo_pagamento, getdate(), @cd_funcionario)
		if @@Rowcount =  0 
		begin -- 2
		  ROLLBACK TRANSACTION
		  Raiserror('Erro na criação do Lote.',16,1)
		  RETURN
		end -- 2

       print '----PB 3.1'     
       
		Select @cd_sequencial=max(cd_sequencial) 
		  from averbacao_lote
		 where cd_tipo_pagamento = @cd_tipo_pagamento and 
		  	   cd_tipo_servico_bancario = @cd_tipo_servico_bancario and 
			   dt_finalizado is null       
        print '----PB F 3'

    End  
 
          print '----PB 4'
    -- Verificar se existe cd_tipo_servico_bancario p/ cd_tipo_pagamento 
    if (select count(0) from tipo_pagamento where cd_tipo_pagamento=@cd_tipo_pagamento and cd_tipo_servico_bancario=@cd_tipo_servico_bancario)=0
    Begin -- 1 
	  ROLLBACK TRANSACTION
	  Raiserror('Erro na checagem dos dados.',16,1)
	  RETURN
    End -- 1 

    update averbacao 
       set cd_sequencial = @cd_sequencial
      from ASSOCIADOS as s, EMPRESA as e
       where averbacao.cd_sequencial is null and 
             averbacao.cd_Associado=s.cd_associado and 
             s.cd_empresa = e.CD_EMPRESA and 
             e.cd_tipo_pagamento=@cd_tipo_pagamento
	 
	update averbacao 
	   set mensagem=null  
	 where cd_sequencial = @cd_sequencial
	 
	update averbacao 
       set vl_parcela = isnull((select sum(vl_plano) from dependentes as d , historico as h , situacao_historico as s 
                          where d.cd_associado = averbacao.cd_Associado and 
                                d.cd_sequencial_historico = h.cd_sequencial and 
                                h.cd_situacao = s.cd_situacao_historico and 
                                s.fl_gera_cobranca=1),0),
           nm_sacado = a.nm_completo 
      from associados as a                          
     where averbacao.cd_sequencial = @cd_sequencial and averbacao.cd_associado = a.cd_Associado 

    update averbacao_lote 
       set qtde = (select COUNT(0) from averbacao where cd_sequencial = @cd_sequencial),
           valor = (select sum(vl_parcela) from averbacao where cd_sequencial = @cd_sequencial)
     where cd_sequencial=@cd_sequencial  

  Commit 
 
End 
