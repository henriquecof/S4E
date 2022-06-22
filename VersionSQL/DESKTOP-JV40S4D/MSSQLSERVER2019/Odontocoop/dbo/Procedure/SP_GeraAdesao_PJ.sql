/****** Object:  Procedure [dbo].[SP_GeraAdesao_PJ]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE Procedure [dbo].[SP_GeraAdesao_PJ] (@Emp int, @cd_seq_pp int, @retorno varchar(1000) = '' output, @tipoPagamento int = 0 output, @tipoUsuarioConectado smallint = 0)
As
Begin

   -- Se valor e plano for -1 buscar no cadastro.
   -- Se adesao gerada e aberta... Data superior a assinatura do contrato nao gerar novamente
   --Declare @retorno varchar(1000)
   Declare @dias int = 3
   Declare @tp_pag int = 7 
   Declare @cd_parc int
   Declare @qtde_adesao_gerada int  
   Declare @dt_asscto date 
   Declare @valorAcrescimo as money
   
   set @valorAcrescimo = 15
   
   select @dt_asscto = dateadd(day,@dias,dt_inicio),
          @tp_pag = case when @tipoPagamento >0 then @tipoPagamento else cd_tipo_pagamento end 
     from preco_plano as pp, empresa as e 
    where pp.cd_empresa=e.CD_EMPRESA 
      and cd_sequencial = @cd_seq_pp 

   if (@tipoUsuarioConectado = 6 or @tipoUsuarioConectado = 7 or @tipoUsuarioConectado = 10)
   begin
		  set @valorAcrescimo = 0
	   select @dt_asscto = convert(varchar(10),right(mm_aaaa_1pagamento_empresa,2))+'/'+convert(varchar(10),dt_vencimento)+'/'+convert(varchar(10),left(mm_aaaa_1pagamento_empresa,4))
		 from empresa as e 
		where e.CD_EMPRESA = @Emp
   End
   
   select @qtde_adesao_gerada = count(0)           
     from dependentes as d , associados as a, empresa as e --, preco_plano as p 
    where d.cd_Associado = a.cd_Associado and 
          a.cd_empresa = e.cd_empresa and 
          --d.cd_plano = p.cd_plano and 
         -- e.CD_EMPRESA = p.cd_empresa and 
          e.cd_empresa = @Emp and 
         -- p.cd_sequencial = @cd_seq_pp and
          d.cd_sequencial not in (select d1.cd_sequencial 
                                    from dependentes as d1, mensalidades_planos as mp1, mensalidades as m1
                                   where d1.CD_SEQUENCIAL = mp1.cd_sequencial_dep
                                     and mp1.cd_parcela_mensalidade = m1.CD_PARCELA
                                     and mp1.dt_exclusao is null 
                                     and m1.cd_tipo_parcela = 2 
                                     and m1.CD_TIPO_RECEBIMENTO not IN (1)
                                     and m1.CD_ASSOCIADO_empresa = @Emp 
                                     and m1.TP_ASSOCIADO_EMPRESA = 2 
                                  )  --and 
         -- p.fl_inativo is null and 
         --(p.dt_fim_comercializacao is null or p.dt_fim_comercializacao>getdate()) 
         
    if @qtde_adesao_gerada=0 
    Begin -- '2'     
		Set @retorno = 'Não existe  da adesão.'
		return   		
   	End 	
   		--- Existe adesao gerada hj... Se sim usa a mesma
   		set @cd_parc = null 
   		
   		select @cd_parc = max(CD_PARCELA)
		  from mensalidades
		 where cd_associado_empresa = @emp and cd_tipo_parcela = 2 and 
	   		   convert(varchar(10),DT_VENCIMENTO,101) >= convert(varchar(10),dateadd(day,@dias,@dt_asscto),101) and 
			   TP_ASSOCIADO_EMPRESA = 2 and 
			   CONVERT(varchar(10),dt_gerado,101) = convert(varchar(10),getdate(),101) and 
			   CD_TIPO_RECEBIMENTO=0
		
		if @cd_parc is null 
	   	Begin -- 2.2	
   			insert mensalidades (CD_ASSOCIADO_empresa,TP_ASSOCIADO_EMPRESA,cd_tipo_parcela, CD_TIPO_PAGAMENTO,CD_TIPO_RECEBIMENTO,DT_VENCIMENTO,DT_GERADO, VL_PARCELA, VL_Acrescimo,VL_Desconto)
			values (@emp, 2 , 2 , case when @tipoPagamento <= 0 then @tp_pag else @tipoPagamento end, 0 , convert(varchar(10),@dt_asscto,101) , getdate(), 0,@valorAcrescimo,0) 
			if @@Rowcount =  0 
			  begin -- 8.1
				Set @retorno = 'Erro na inclusão da adesão.'
				return
			  end -- 8.1

			print '21'     
			select @cd_parc = max(CD_PARCELA)
			  from mensalidades
			 where cd_associado_empresa = @emp and cd_tipo_parcela = 2 and 
	   			   convert(varchar(10),DT_VENCIMENTO,101) >= convert(varchar(10),@dt_asscto,101) and 
				   TP_ASSOCIADO_EMPRESA = 2 and vl_parcela = 0 
        End -- 2.2
        
		print '22'             
		insert mensalidades_planos (cd_parcela_mensalidade, cd_sequencial_dep , valor, cd_plano) 
  	    select @cd_parc, d.CD_SEQUENCIAL , d.vl_plano , d.cd_plano       
		 from dependentes as d , associados as a, empresa as e --, preco_plano as p 
		where d.cd_Associado = a.cd_Associado and 
			  a.cd_empresa = e.cd_empresa and 
			 -- d.cd_plano = p.cd_plano and 
			 -- e.CD_EMPRESA = p.cd_empresa and 
			  e.cd_empresa = @Emp and 
			 -- p.cd_sequencial = @cd_seq_pp and
			  d.cd_sequencial not in (select d1.cd_sequencial 
										from dependentes as d1, mensalidades_planos as mp1, mensalidades as m1
									   where d1.CD_SEQUENCIAL = mp1.cd_sequencial_dep
										 and mp1.cd_parcela_mensalidade = m1.CD_PARCELA
										 and mp1.dt_exclusao is null 
										 and m1.cd_tipo_parcela = 2 
										 and m1.CD_TIPO_RECEBIMENTO not IN (1)
										 and m1.CD_ASSOCIADO_empresa = @Emp 
										 and m1.TP_ASSOCIADO_EMPRESA = 2 
									  )  --and 
			 -- p.fl_inativo is null and 
			 --(p.dt_fim_comercializacao is null or p.dt_fim_comercializacao>getdate()) 
		
	    
		update dependentes set cd_gerou_adesao = 1 where cd_sequencial in (select cd_sequencial_dep from mensalidades_planos where cd_parcela_mensalidade = @cd_parc )
		if @@Rowcount =  0 
		begin -- 8.2
   		  Set @retorno ='Erro na inclusão da adesão do usuário.'
   		  return
		end -- 8.2

       -- exec SP_Gerar_Imposto @cd_parc -- Gera o imposto 
    --Set @retorno ='Erro na inclusão da adesão do usuário.'
    return  
End
