/****** Object:  Procedure [dbo].[SP_DesmembraMensalidade_Associado]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE Procedure [dbo].[SP_DesmembraMensalidade_Associado] (@Parcela int, @Valor money)
As
Begin

   Declare @tp_ass int 
   Declare @vl money 
   Declare @cd_tipo_rec int 
   Declare @retorno varchar(1000) 
   
   Declare @cd_sequencial int 
   
   if (isnull(@Parcela,0) =0 or isnull(@Valor,0) = 0) 
   Begin
	Set @retorno = 'Informe a parcela e o valor para desmenbrar.'
	raiserror(@retorno,16,1)
	return        
   End   

   Select @vl = vl_parcela, @tp_ass=tp_associado_empresa,@cd_tipo_rec=cd_tipo_recebimento 
     from mensalidades 
    where cd_parcela = @Parcela
    
   if @vl is null 
   Begin
	Set @retorno = 'Parcela não localizada.'
    raiserror(@retorno,16,1)
	return        
   End  
      
   if @valor > @vl 
   Begin
	Set @retorno = 'Valor a ser desmembrado não pode ser maior que o valor da parcela.'
	raiserror(@retorno,16,1)
	return        
   End  

   if @tp_ass > 1 
   Begin
	Set @retorno = 'Parcela não pertence a associado.'
	raiserror(@retorno,16,1)
	return        
   End  

   if @cd_tipo_rec > 2 
   Begin
	Set @retorno = 'Parcela não está em situação de desmembrar.'
	raiserror(@retorno,16,1)
	return        
   End  
               
   Declare @nova_parcela int 
  
   Begin Transaction
   
	insert mensalidades (CD_ASSOCIADO_empresa,TP_ASSOCIADO_EMPRESA,cd_tipo_parcela,
	   CD_TIPO_PAGAMENTO,CD_TIPO_RECEBIMENTO,DT_VENCIMENTO,DT_GERADO, VL_PARCELA, VL_Acrescimo,VL_Desconto,
	   nf,lnfid,nferps,dt_cancelado_contabil)
	 select cd_Associado_empresa, TP_ASSOCIADO_EMPRESA,cd_tipo_parcela,
	        CD_TIPO_PAGAMENTO,0,DT_VENCIMENTO,dt_gerado, 0, 0,0,
	        nf,lnfid,nferps,dt_cancelado_contabil
	   from mensalidades  
	  where CD_PARCELA = @Parcela 

   Set @nova_parcela = @@IDENTITY
   if @nova_parcela is null 
   Begin
	  ROLLBACK
  	  Set @retorno = 'Erro na criação da nova mensalidade.'
	  raiserror(@retorno,16,1)
	  return       
   End 

     print 'Nova Parcela:' + convert(varchar(10),@nova_parcela)
     
     print  'mensalidades_planos'
     DECLARE cursor_desm_m CURSOR FOR 
     select top 100 cd_sequencial, valor from mensalidades_planos where cd_parcela_mensalidade = @Parcela and dt_exclusao is null and valor > 0 
	 OPEN cursor_desm_m
	 FETCH NEXT FROM cursor_desm_m INTO @cd_sequencial, @vl
     While (@@fetch_status<>-1)
     Begin
 
          -- Parcela Gerada na Mensalidade Anterior. Caso o valor da parcela seja > do que a parcela criada
         if @vl > @valor 
         Begin
 			 insert mensalidades_planos (cd_parcela_mensalidade, cd_sequencial_dep , cd_plano, valor, cd_empresa_filha,cd_tipo_parcela,id_mensalidade_avulsa )
			   select cd_parcela_mensalidade, cd_sequencial_dep, cd_plano , valor - @valor , cd_empresa_filha , cd_tipo_parcela , id_mensalidade_avulsa
				 from mensalidades_planos as p 
				where cd_sequencial = @cd_sequencial 
			 if @@Rowcount =  0 
			  begin -- 3.1.2.1
				ROLLBACK
	            raiserror(@retorno,16,1)
  				Set @retorno = 'Erro no acerto do valor da mensalidade plano atual.'		
				RETURN
			  end -- 3.1.2.1					
		 End	          
		 
         -- Atualizar a data de exclusão a mensalidade Plano na Parcela Original
		  update Mensalidades_Planos 
			 set dt_exclusao=GETDATE(), cd_funcionario_exclusao=(select cd_funcionario from Processos where cd_processo=1)
		   where cd_sequencial = @cd_sequencial 
			  
		 if @@Rowcount =  0 
		  begin -- 3.1.2.1
			ROLLBACK
  			Set @retorno = 'Erro na exclusao da parcela atual.'		
	        raiserror(@retorno,16,1)
			RETURN
		  end -- 3.1.2.1	
 
         -- Parcela Gerada na Nova Mensalidade
 		 insert mensalidades_planos (cd_parcela_mensalidade, cd_sequencial_dep , cd_plano, valor, cd_empresa_filha,cd_tipo_parcela,id_mensalidade_avulsa )
		   select @nova_parcela, cd_sequencial_dep, cd_plano , case when @valor >= valor then valor else @valor end , cd_empresa_filha , cd_tipo_parcela , id_mensalidade_avulsa
			 from mensalidades_planos as p 
			where cd_sequencial = @cd_sequencial 
		 if @@Rowcount =  0 
		  begin -- 3.1.2.1
			ROLLBACK
  			Set @retorno = 'Erro na criação da nova mensalidade plano.'		
	        raiserror(@retorno,16,1)
			RETURN
		  end -- 3.1.2.1				
  
		 
         Set @valor = @valor - @vl
         
         if @valor <= 0 
            break 
            
         FETCH NEXT FROM cursor_desm_m INTO @cd_sequencial, @vl
     End
     Close cursor_desm_m
     Deallocate cursor_desm_m

     -- Atualizar o Valor na Parcela Atual 
      --update mensalidades
      --   set VL_PARCELA =  (select SUM(valor) from Mensalidades_Planos where cd_parcela_mensalidade = @parcela and dt_exclusao is null), 
      --       DT_ALTERACAO = GETDATE(), 
      --       CD_USUARIO_ALTERACAO = (select cd_funcionario from Processos where cd_processo=1)
      -- where CD_PARCELA = @parcela
            update mensalidades
         set VL_PARCELA =  (select SUM(valor) from Mensalidades_Planos where cd_parcela_mensalidade = @parcela and dt_exclusao is null), 
             DT_ALTERACAO = GETDATE(), 
             CD_USUARIO_ALTERACAO = (select cd_funcionario from Processos where cd_processo=1),
             cd_ParcelaOriginal = @Parcela --(NOVO CAMPO)
       where CD_PARCELA = @parcela

	 if @@Rowcount =  0 
	  begin -- 3.1.2.1
		ROLLBACK
  	    Set @retorno = 'Erro na atualização da mensalidade.'		
   	    raiserror(@retorno,16,1)
		RETURN
	  end -- 3.1.2.1			  
     
     -- Atualizar o valor na nova percela 
      --update mensalidades
      --   set VL_PARCELA =  (select SUM(valor) from Mensalidades_Planos where cd_parcela_mensalidade = @nova_parcela and dt_exclusao is null), 
      --       DT_ALTERACAO = GETDATE(), 
      --       CD_USUARIO_ALTERACAO = (select cd_funcionario from Processos where cd_processo=1)
      -- where CD_PARCELA = @nova_parcela
            update mensalidades
         set VL_PARCELA =  (select SUM(valor) from Mensalidades_Planos where cd_parcela_mensalidade = @nova_parcela and dt_exclusao is null), 
             DT_ALTERACAO = GETDATE(), 
             CD_USUARIO_ALTERACAO = (select cd_funcionario from Processos where cd_processo=1),
             cd_ParcelaOriginal = @parcela --(NOVO CAMPO)
       where CD_PARCELA = @nova_parcela

	 if @@Rowcount =  0 
	  begin -- 3.1.2.1
		ROLLBACK
  	    Set @retorno = 'Erro na atualização da nova mensalidade.'		
 	    raiserror(@retorno,16,1)
		RETURN
	  end -- 3.1.2.1			  
     
     commit                            
    
    return  
    
End
