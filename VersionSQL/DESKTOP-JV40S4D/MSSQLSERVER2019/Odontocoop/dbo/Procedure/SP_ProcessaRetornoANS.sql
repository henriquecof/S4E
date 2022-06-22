/****** Object:  Procedure [dbo].[SP_ProcessaRetornoANS]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE Procedure [dbo].[SP_ProcessaRetornoANS] 
  @sequencial int
As
Begin
   
   Declare @cod varchar(30)
   Declare @cco varchar(12)
   Declare @pk int 
   Declare @erro varchar(1000)
   Declare @tipoMovimento varchar(100)
   
   Declare @dt_fechado datetime 
   
   select @dt_fechado=dt_fechado from ANS where cd_sequencial = @sequencial 
   if @dt_fechado is null 
   begin 
	   Set @erro = 'Arquivo não fechado. Favor fechar o arquivo antes de processar o retorno' 
	   Raiserror(@erro,16,1)
	   RETURN
   End 
      
   Begin Transaction 
         
   Print 'Incluidos'
   DECLARE cursor_ProcessaRetornoANS CURSOR FOR  
	select codigobeneficiario , cco , cd_pk 
	  from ANS_Retorno_Incluidos
	 where cd_sequencial = @sequencial 
	 order by cd_pk 
           
	OPEN cursor_ProcessaRetornoANS
	FETCH NEXT FROM cursor_ProcessaRetornoANS INTO @cod, @cco,@pk

	WHILE (@@FETCH_STATUS <> -1)  
	begin  -- 2.2        
	   
	   print @cco
	 --  update DEPENDENTES 
		--  set cco = @cco
		--where CD_SEQUENCIAL = @cod and (cco is null or cco=@cco)
		--if @@ROWCOUNT = 0 
		--   update ANS_Retorno_Incluidos set mensagem = 'Erro na atualizacao (Dependentes)' where cd_pk = @pk 

	   update Ans_Beneficiarios  
		  set cco = @cco
		where cd_beneficiario = @cod and (cco is null or cco=@cco)
		if @@ROWCOUNT = 0 
		   update ANS_Retorno_Incluidos set mensagem = 'Erro na atualizacao (Beneficiarios)' where cd_pk = @pk 

       FETCH NEXT FROM cursor_ProcessaRetornoANS INTO @cod, @cco, @pk
    End
    close cursor_ProcessaRetornoANS
    Deallocate cursor_ProcessaRetornoANS    		
        
   Declare @mensagemErro varchar(500)
   Declare @passou smallint = 1 
   
   Print 'Rejeitados' 
   
   DECLARE cursor_ProcessaRetornoANS CURSOR FOR  
	select tipoMovimento , isnull( codigoBeneficiario,'0'), cco, mensagemErro, cd_pk 
	  from ANS_Retorno_rejeitados
	 where cd_sequencial = @sequencial and not (tipoMovimento = 'CANCELAMENTO' and cco = '000000000000') -- and tipoMovimento='REATIVAÇÃO'
	 order by cd_pk 
           
	OPEN cursor_ProcessaRetornoANS
	FETCH NEXT FROM cursor_ProcessaRetornoANS INTO @tipoMovimento, @cod, @cco,@mensagemErro, @pk

	WHILE (@@FETCH_STATUS <> -1)  
	begin  -- 2.2        
      
      print @cod 
      print @cco 
      
	  if @tipoMovimento = 'CANCELAMENTO'
	  Begin
		   --update ans_Beneficiarios 
		   --   set mensagemErro = @mensagemErro 
		   -- where CD_SEQUENCIAL_dep = (select cd_sequencial from dependentes where cco = convert(varchar(20),@cco)) and cd_arquivo_envio_exc = @sequencial
		
			update ans_Beneficiarios 
			   set cd_arquivo_envio_exc=null , dt_exclusao=null, cd_motivo_exclusao_Ans=null,mensagemErro=null
			 where cco = convert(varchar(20),@cco) and cd_arquivo_envio_exc = @sequencial
			
			Set @passou = @@ROWCOUNT  
			 
	  End  
	  

	  if @tipoMovimento in ('INCLUSÃO')
	  Begin
   	       print 'en'
   	       
		   update ans_Beneficiarios 
			  set mensagemErro = @mensagemErro 
			where cd_beneficiario = @cod and cd_arquivo_envio_inc = @sequencial and tipo_Movimentacao=1
			
		   Set @passou = @@ROWCOUNT 
			
   	       print 'en22'			
		   delete ans_Beneficiarios where cd_beneficiario = @cod and cd_arquivo_envio_inc = @sequencial and tipo_Movimentacao=1
		   
		   Set @passou = @@ROWCOUNT 
	   
	  End  
	  
	  if @tipoMovimento in ('REATIVAÇÃO')
	  Begin
   	       print 're'
   	       
		   update ans_Beneficiarios 
			  set ans_Beneficiarios.mensagemErro = @mensagemErro 
			-- from dependentes
			where -- ans_Beneficiarios.CD_SEQUENCIAL_dep = dependentes.cd_sequencial and 
			      -- dependentes.cco = convert(varchar(20),@cco) and 
			      cco = convert(varchar(20),@cco) and 
			      cd_arquivo_envio_inc = @sequencial and 
			      tipo_Movimentacao=3
			
		   Set @passou = @@ROWCOUNT 
			
   	       print 're22'			
		   delete ans_Beneficiarios 
		    where cco = convert(varchar(20),@cco) and  --CD_SEQUENCIAL_dep = (select cd_sequencial from dependentes where cco = convert(varchar(20),@cco)) and 
		          cd_arquivo_envio_inc = @sequencial and 
		          tipo_Movimentacao=3
		   
		   Set @passou = @@ROWCOUNT 
		   
	  End  
	  
	  
      if @tipoMovimento = 'MUDANÇA CONTRATUAL'
	  Begin
		   update ConferenciaANS_Verificacao 
			  set mensagemErro = @mensagemErro 
			where  cco = convert(varchar(20),@cco)  
			  and cd_arquivo_envio_inc = @sequencial
			  			
		   Set @passou = @@ROWCOUNT 
		     
	  End  	  

	  if @tipoMovimento = 'RETIFICAÇÃO'
	  Begin
		   update ConferenciaANS_Verificacao 
			  set mensagemErro = @mensagemErro 
			where cco = convert(varchar(20),@cco) 
			  and cd_arquivo_envio_inc = @sequencial
			    
			Set @passou = @@ROWCOUNT 	
						 		  
	  End 
	  	   
	  if @passou = 0 
	   Begin
	     ROLLBACK TRANSACTION
	     Set @erro = 'Erro na leitura dos Rejeitados.' + CONVERT(varchar(10),@cod)
	     Raiserror(@erro,16,1)
	     Close cursor_ProcessaRetornoANS
	     Deallocate cursor_ProcessaRetornoANS
	     RETURN
	   End 
	
       FETCH NEXT FROM cursor_ProcessaRetornoANS INTO @tipoMovimento, @cod, @cco,@mensagemErro, @pk
    End
    close cursor_ProcessaRetornoANS
    Deallocate cursor_ProcessaRetornoANS    		   
  
    --delete ans_Beneficiarios where mensagemErro is not null and cd_arquivo_envio_exc is null 
    --update ans_Beneficiarios set cd_arquivo_envio_exc=null , dt_exclusao=null, cd_motivo_exclusao_Ans=null,mensagemErro=null  where mensagemErro is not null and cd_arquivo_envio_exc is not null 
    
    update Ans_Beneficiarios set mudanca_contratual=null where mudanca_contratual is not null and  mensagemErro is null 
    update Ans_Beneficiarios set retificacao=null where retificacao is not null  and  mensagemErro is null 
  
    Commit
    
End
