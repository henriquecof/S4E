/****** Object:  Procedure [dbo].[SP_GeraAdesao_XX]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE Procedure [dbo].[SP_GeraAdesao_XX] (@Ass int, @cd_seq int, @vl_adesao money = -1 , @cd_plano int = -1, @retorno varchar(1000)='' output)
As
Begin

   -- Se valor e plano for -1 buscar no cadastro.
   -- Se adesao gerada e aberta... Data superior a assinatura do contrato nao gerar novamente
   --Declare @retorno varchar(1000)
   Declare @dias int 
   Declare @tp_pag int = 7 
   Declare @cd_parc int
   Declare @qtde_adesao_gerada int  
   
   print '1'     
   select @dias = case when p.qt_dias_adesao IS null then 0 else p.qt_dias_adesao end , 
          @tp_pag = case when p.cd_tipo_pagamento_adesao IS null then 7 else p.cd_tipo_pagamento_adesao end , -- Dinheiro
          @cd_plano = case when @cd_plano=-1 then d.cd_plano else @cd_plano end,
          @vl_adesao = isnull((case when @vl_adesao>0 then @vl_adesao 
                                    when cd_grau_parentesco=1 and isnull(vl_adesao_tit,0) = 0 then vl_tit 
                                    when cd_grau_parentesco=1 then Vl_adesao_tit 
                                    when cd_grau_parentesco>1 and isnull(vl_adesao_dep,0) = 0 then Vl_dep 
                                    else Vl_adesao_dep 
                               end),0),
          @qtde_adesao_gerada = 
          (select COUNT(0) 
             from Mensalidades_Planos as mp, MENSALIDADES as m 
            where cd_sequencial_dep=@cd_seq and 
                  mp.cd_parcela_mensalidade=m.CD_PARCELA and 
                  m.cd_tipo_parcela=2 and 
                  m.CD_TIPO_RECEBIMENTO=0 and 
                  m.DT_GERADO > d.dt_assinaturaContrato)                      
     from dependentes as d , associados as a, empresa as e , preco_plano as p 
    where d.cd_sequencial = @cd_seq and 
          d.cd_Associado = a.cd_Associado and 
          a.cd_empresa = e.cd_empresa and 
          d.cd_plano = p.cd_plano and 
          e.CD_EMPRESA = p.cd_empresa and 
         (p.dt_fim_comercializacao is null or p.dt_fim_comercializacao>getdate())

    print 'm'
    print @qtde_adesao_gerada
    print 'm1'         
    if @qtde_adesao_gerada=0 
    Begin -- '2'     
   		
   		--- Existe adesao gerada hj... Se sim usa a mesma
   		set @cd_parc = null 
   		
   		select @cd_parc = max(CD_PARCELA)
		  from mensalidades
		 where cd_associado_empresa = @ass and cd_tipo_parcela = 2 and 
	   		   convert(varchar(10),DT_VENCIMENTO,101) >= convert(varchar(10),getdate(),101) and 
			   TP_ASSOCIADO_EMPRESA = 1 and 
			   CONVERT(varchar(10),dt_gerado,101) = convert(varchar(10),getdate(),101) and 
			   CD_TIPO_RECEBIMENTO=0
		
		if @cd_parc is null 
	   	Begin -- 2.2	
   			insert mensalidades (CD_ASSOCIADO_empresa,TP_ASSOCIADO_EMPRESA,cd_tipo_parcela, CD_TIPO_PAGAMENTO,CD_TIPO_RECEBIMENTO,DT_VENCIMENTO,DT_GERADO, VL_PARCELA, VL_Acrescimo,VL_Desconto)
			values (@ass, 1 , 2 , @tp_pag, 0 , dateadd(day,@dias,convert(varchar(10),getdate(),101)) , getdate(), 0,0,0) 
			if @@Rowcount =  0 
			  begin -- 8.1
				Set @retorno = 'Erro na inclusão da adesão.'
				return
			  end -- 8.1

			print '21'     
			select @cd_parc = max(CD_PARCELA)
			  from mensalidades
			 where cd_associado_empresa = @ass and cd_tipo_parcela = 2 and 
	   			   convert(varchar(10),DT_VENCIMENTO,101) >= convert(varchar(10),getdate(),101) and 
				   TP_ASSOCIADO_EMPRESA = 1 and vl_parcela = 0 
        End -- 2.2
        
		print '22'             
		insert mensalidades_planos (cd_parcela_mensalidade, cd_sequencial_dep , valor, cd_plano) 
		values (@cd_parc, @cd_seq, @vl_adesao , @cd_plano)
	    
		update dependentes set cd_gerou_adesao = 1 where cd_sequencial = @cd_seq
		if @@Rowcount =  0 
		begin -- 8.2
   		  Set @retorno ='Erro na inclusão da adesão do usuário.'
   		  return
		end -- 8.2

    End -- 2      
    
    --Set @retorno ='Erro na inclusão da adesão do usuário.'
    return  
End
