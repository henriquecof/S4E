/****** Object:  Procedure [dbo].[SP_Inclui_Comissao2]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[SP_Inclui_Comissao2](
   @cd_seq int,        -- Sequencial do Dependente
   @vl_plano money, 
   @Adesao smallint,   -- Plano gerado Adesao 
   @Operacao smallint,
   @retorno varchar(1000)='' output, -- Operação : 1 - Incluir , 2 - Alterar, 3- Excluir
   @regerar smallint = 0)
AS
Begin -- 0 

   Begin transaction
   
   -- Se Operacao = 1 - Incluir Comissao (Vendedor + Mediadores)
   -- Gerar Mensalidade caso Adesao seja 01

   -- Se Operacao = 3 - Cancelar as Comissoes pendentes

       update comissao_Vendedor 
          set dt_exclusao = getdate()
        where cd_sequencial_dependente = @cd_seq and 
              cd_sequencial_mensalidade_planos is null and 
              cd_sequencial_lote is null

     if @Operacao = 3 
     Begin -- 1  
     
       update mensalidades 
          set cd_tipo_recebimento = 1 ,
              cd_usuario_alteracao = (select cd_funcionario from processos where cd_processo = 2),
              cd_usuario_baixa = (select cd_funcionario from processos where cd_processo = 2),
              dt_baixa = getdate()
         from mensalidades_planos
        where mensalidades.cd_parcela = mensalidades_planos.cd_parcela_mensalidade and 
              mensalidades.cd_tipo_recebimento = 0 and 
              mensalidades_planos.cd_sequencial_dep = @cd_seq and 
              mensalidades.cd_tipo_parcela = 2    
                                        
        Commit
        return  
     End -- 1 


   Declare @qt_parcelas int = 0
   Declare @moeda smallint 
   
   -- Qtde de Parcelas que o Dependente já teve gerada
   if @regerar <> 1
   begin
   select @qt_parcelas = count(0) 
     from mensalidades as m , mensalidades_planos as p , DEPENDENTES as d
    where m.cd_parcela = p.cd_parcela_mensalidade and 
          p.cd_sequencial_dep = d.CD_SEQUENCIAL and 
          p.cd_sequencial_dep = @cd_seq and 
          m.cd_tipo_recebimento not in (1,2) and 
          p.dt_exclusao is null and 
          m.cd_tipo_parcela in (1,2) and 
          m.DT_VENCIMENTO < d.dt_assinaturaContrato 
   end

   -- Verificar a Regra de Comissao do Vendedor 
   Declare @cd_func int
   Declare @cd_emp int
   Declare @tp_pag smallint 
   Declare @vl_base_comissao money 
   Declare @vl_adesao money
   Declare @cd_ass int 
   Declare @cd_plano int   
   Declare @tp_empresa smallint 

   select @cd_func = 0 ,  @cd_emp = 0 

   select @cd_func = cd_funcionario_vendedor , @cd_emp = a.cd_empresa , @tp_pag = a.cd_tipo_pagamento , 
          @cd_ass = a.cd_Associado,
          @cd_plano = d.cd_plano,
          @vl_base_comissao = isnull((case when cd_grau_parentesco=1 then vl_base_comissao_tit else vl_base_comissao_dep end),0),
          @vl_adesao = isnull((case when cd_grau_parentesco=1 then vl_adesao_tit else vl_adesao_dep end),0),
          @tp_empresa = e.TP_EMPRESA
     from dependentes as d , associados as a, empresa as e , preco_plano as p 
    where d.cd_sequencial = @cd_seq and 
          d.cd_Associado = a.cd_Associado and 
          a.cd_empresa = e.cd_empresa and 
          d.cd_plano = p.cd_plano and 
          e.CD_EMPRESA = p.cd_empresa and 
         (p.dt_fim_comercializacao is null or p.dt_fim_comercializacao>getdate())

   print @cd_ass
   
   if @vl_base_comissao=0 -- Caso nao tenha sido definido o valor base para comissao. Pegar o valor passado como parametro
      set @vl_base_comissao=@vl_plano -- So usada na comissao do Vendedor
      
   if @vl_adesao=0 -- Caso nao tenha sido definido o valor da adesao. Pegar o valor passado como parametro
      set @vl_adesao=@vl_plano -- So usada no calculo da Adesao
   

   -- *********************************************
   -- Regra : 1-Comissao Gerada pela empresa
   --         2-Comissao Gerada pela tipo pagamento
   --         3-Comissao Gerada pela tipo empresa
   --         4-Comissao Gerada pelo plano
   --         5-Geral 
   -- *********************************************
   Declare @regra smallint 
   Declare @qtde_cm int 
   
   set @regra = 5 

   select @qtde_cm = count(0)  -- Verificar se tem comissao definida pela plano
	 from cm_vendedor 
	where cd_funcionario = @cd_func and 
		  cd_plano = @cd_plano and 
     	  cd_tipo_comissao in (1,12)
   if @qtde_cm>0 
	  set @regra = 4

   if @regra = 5
   Begin -- 2
	   select @qtde_cm = count(0)  -- Verificar se tem comissao definida pela empresa
		 from cm_vendedor 
		where cd_funcionario = @cd_func and 
			  cd_empresa = @cd_emp and 
     	  cd_tipo_comissao in (1,12)
	   if @qtde_cm>0 
		  set @regra = 1
   End
   
   if @regra = 5 
    Begin -- 2
	   select @qtde_cm = count(0)  -- Verificar se tem comissao definida pelo tipo_pagamento
		 from cm_vendedor 
		where cd_funcionario = @cd_func and 
			  cd_tipo_pagamento = @tp_pag and 
     	  cd_tipo_comissao in (1,12)
	   if @qtde_cm>0 
		  set @regra = 2
    End -- 2 

   if @regra = 5 
    Begin -- 2
	   select @qtde_cm = count(0)  -- Verificar se tem comissao definida pelo tipo_empresa
		 from cm_vendedor 
		where cd_funcionario = @cd_func and 
			  tp_empresa = @tp_empresa and 
     	  cd_tipo_comissao in (1,12)
	   if @qtde_cm>0 
		  set @regra = 3
    End -- 2 

   Declare @cd_parc int
   Declare @perc_pagamento float
   Declare @fl_reteu bit 
   Declare @cd_tipo_comissao smallint 

   if @regra = 1 -- Baseado na Empresa
    Begin -- 4
    	Declare cursor_Inc_Com CURSOR FOR 
	    Select cd_parcela,perc_pagamento, fl_vendedor_reteu , cd_tipo_comissao, moeda
			FROM cm_vendedor 
		    Where cd_funcionario = @cd_func and 
     		  	  cd_empresa = @cd_emp and 
     		  	  cd_tipo_pagamento is null and 
     		  	  tp_empresa is null and 
     		  	  cd_plano is null and 
     			  cd_tipo_comissao in (1,12)
		   order by cd_parcela desc
    End -- 4 

   if @regra = 2 -- Baseado no Tipo Pagamento
    Begin -- 5
    	Declare cursor_Inc_Com CURSOR FOR 
	    Select cd_parcela,perc_pagamento, fl_vendedor_reteu , cd_tipo_comissao, moeda
			FROM cm_vendedor 
		    Where cd_funcionario = @cd_func and 
     		  	  cd_tipo_pagamento = @tp_pag and 
                  cd_empresa is null and 
     		  	  tp_empresa is null and 
     		  	  cd_plano is null and                   
     			  cd_tipo_comissao in (1,12)
		   order by cd_parcela desc
    End -- 5 

   if @regra = 3 -- Baseado no Tipo Empresa
    Begin -- 5
    	Declare cursor_Inc_Com CURSOR FOR 
	    Select cd_parcela,perc_pagamento, fl_vendedor_reteu , cd_tipo_comissao, moeda
			FROM cm_vendedor 
		    Where cd_funcionario = @cd_func and 
     		  	  tp_empresa = @tp_empresa and 
                  cd_empresa is null and 
                  cd_tipo_pagamento is null and 
     		  	  cd_plano is null and                   
     			  cd_tipo_comissao in (1,12)
		   order by cd_parcela desc
    End -- 5 

   if @regra = 4 -- Baseado no Plano
    Begin -- 5
    	Declare cursor_Inc_Com CURSOR FOR 
	    Select cd_parcela,perc_pagamento, fl_vendedor_reteu , cd_tipo_comissao, moeda
			FROM cm_vendedor 
		    Where cd_funcionario = @cd_func and 
		          cd_plano = @cd_plano and 
     		  	  tp_empresa is null and 
                  cd_empresa is null and 
                  cd_tipo_pagamento is null and 
     			  cd_tipo_comissao in (1,12)
		   order by cd_parcela desc
    End -- 5 
        
   if @regra = 5  -- Baseado apenas no vendedor 
    Begin -- 6
    	Declare cursor_Inc_Com CURSOR FOR 
	    Select cd_parcela,perc_pagamento, fl_vendedor_reteu , cd_tipo_comissao, moeda
			FROM cm_vendedor 
		    Where cd_funcionario = @cd_func and 
                  cd_empresa is null and 
                  cd_tipo_pagamento is null and 
                  tp_empresa is null and 
                  cd_plano is null and 
     			  cd_tipo_comissao in (1,12)
		   order by cd_parcela desc
    End -- 6          
       
   OPEN cursor_Inc_Com
   FETCH NEXT FROM cursor_Inc_Com INTO @cd_parc,@perc_pagamento,@fl_reteu,@cd_tipo_comissao,@moeda
   WHILE (@@FETCH_STATUS <> -1)
    BEGIN -- 7 
     if (Select COUNT(0) from comissao_vendedor
          where cd_sequencial_dependente = @cd_seq 
            and cd_funcionario = @cd_func
            and cd_parcela_comissao = @cd_parc + @qt_parcelas
            and dt_exclusao is null ) = 0 
     begin       
		  insert into comissao_vendedor (cd_sequencial_dependente,cd_parcela_comissao,cd_funcionario, valor, 
			 perc_pagamento, fl_vendedor_reteu, dt_inclusao,fl_vitalicio,moeda)
		   values ( @cd_seq, @cd_parc+ @qt_parcelas, @cd_func, 

                case when @moeda=0 then @vl_base_comissao else @perc_pagamento end , 
		        case when @moeda=0 then @perc_pagamento else 100 end ,
		        		   
		    @fl_reteu, getdate(),
			case when @cd_tipo_comissao = 1 then null else 1 end, 
			case when ISNULL(@moeda,0)=0 then null else 1 end)    
      End 
      FETCH NEXT FROM cursor_Inc_Com INTO @cd_parc,@perc_pagamento,@fl_reteu,@cd_tipo_comissao,@moeda
    End -- 7 
    Close cursor_Inc_Com
    Deallocate cursor_Inc_Com

  --- Verificar a Regra de Comissao do Supervisor
   Declare @IndCoord int = 0 
   While @IndCoord<=2
   Begin 
   
	   set @regra = 5 

	   select @qtde_cm = count(0)  -- Verificar se tem comissao definida pela plano
		 from cm_vendedor 
		where cd_plano = @cd_plano and 
			  cd_funcionario in (
					  select cd_chefe from equipe_vendas as ev, funcionario as f where f.cd_equipe = ev.cd_equipe and f.cd_funcionario = @cd_func and cd_chefe is not null and @IndCoord=0
					  union
					  select cd_chefe1 from equipe_vendas as ev, funcionario as f where f.cd_equipe = ev.cd_equipe and f.cd_funcionario = @cd_func and cd_chefe1 is not null and @IndCoord=1
					  union
					  select cd_chefe2 from equipe_vendas as ev, funcionario as f where f.cd_equipe = ev.cd_equipe and f.cd_funcionario = @cd_func and cd_chefe2 is not null and @IndCoord = 2
									 ) and 
 			  cd_tipo_comissao in (5,11) -- Supervisor
	   if @qtde_cm>0 
		  set @regra = 4

	   if @regra = 5
	   Begin -- 2
		   select @qtde_cm = count(0)  -- Verificar se tem comissao definida pela empresa
			 from cm_vendedor 
			where cd_empresa = @cd_emp and 
			  cd_funcionario in (
					  select cd_chefe from equipe_vendas as ev, funcionario as f where f.cd_equipe = ev.cd_equipe and f.cd_funcionario = @cd_func and cd_chefe is not null and @IndCoord=0
					  union
					  select cd_chefe1 from equipe_vendas as ev, funcionario as f where f.cd_equipe = ev.cd_equipe and f.cd_funcionario = @cd_func and cd_chefe1 is not null  and @IndCoord=1
					  union
					  select cd_chefe2 from equipe_vendas as ev, funcionario as f where f.cd_equipe = ev.cd_equipe and f.cd_funcionario = @cd_func and cd_chefe2 is not null  and @IndCoord=2
									 ) and 
 			  cd_tipo_comissao in (5,11) -- Supervisor
		   if @qtde_cm>0 
			  set @regra = 1
	   End
	   
	   if @regra = 5 
		Begin -- 2
		   select @qtde_cm = count(0)  -- Verificar se tem comissao definida pelo tipo_pagamento
			 from cm_vendedor 
			where cd_tipo_pagamento = @tp_pag and 
			  cd_funcionario in (
					  select cd_chefe from equipe_vendas as ev, funcionario as f where f.cd_equipe = ev.cd_equipe and f.cd_funcionario = @cd_func and cd_chefe is not null  and @IndCoord=0
					  union
					  select cd_chefe1 from equipe_vendas as ev, funcionario as f where f.cd_equipe = ev.cd_equipe and f.cd_funcionario = @cd_func and cd_chefe1 is not null  and @IndCoord=1
					  union
					  select cd_chefe2 from equipe_vendas as ev, funcionario as f where f.cd_equipe = ev.cd_equipe and f.cd_funcionario = @cd_func and cd_chefe2 is not null  and @IndCoord=2
									 ) and 
 			  cd_tipo_comissao in (5,11) -- Supervisor
		   if @qtde_cm>0 
			  set @regra = 2
		End -- 2 

	   if @regra = 5 
		Begin -- 2
		   select @qtde_cm = count(0)  -- Verificar se tem comissao definida pelo tipo_empresa
			 from cm_vendedor 
			where tp_empresa = @tp_empresa and 
			  cd_funcionario in (
					  select cd_chefe from equipe_vendas as ev, funcionario as f where f.cd_equipe = ev.cd_equipe and f.cd_funcionario = @cd_func and cd_chefe is not null  and @IndCoord=0
					  union
					  select cd_chefe1 from equipe_vendas as ev, funcionario as f where f.cd_equipe = ev.cd_equipe and f.cd_funcionario = @cd_func and cd_chefe1 is not null and @IndCoord=1
					  union
					  select cd_chefe2 from equipe_vendas as ev, funcionario as f where f.cd_equipe = ev.cd_equipe and f.cd_funcionario = @cd_func and cd_chefe2 is not null and @IndCoord=2
									 ) and 
 			  cd_tipo_comissao in (5,11) -- Supervisor
		   if @qtde_cm>0 
			  set @regra = 3
		End -- 2 

		-- Definida a regra 

		if @regra = 1 -- Baseado na Empresa
		Begin -- 4
			Declare cursor_Inc_Com CURSOR FOR 
			Select cd_parcela,perc_pagamento,0, cd_funcionario , cd_tipo_comissao, moeda
				FROM cm_vendedor 
				Where cd_empresa = @cd_emp and 
					  cd_plano is null and 
					  cd_tipo_pagamento is null and 
					  tp_empresa is null and 
					  cd_funcionario in (
						  select cd_chefe from equipe_vendas as ev, funcionario as f where f.cd_equipe = ev.cd_equipe and f.cd_funcionario = @cd_func and cd_chefe is not null and @IndCoord=0
						  union
						  select cd_chefe1 from equipe_vendas as ev, funcionario as f where f.cd_equipe = ev.cd_equipe and f.cd_funcionario = @cd_func and cd_chefe1 is not null and @IndCoord=1
						  union
						  select cd_chefe2 from equipe_vendas as ev, funcionario as f where f.cd_equipe = ev.cd_equipe and f.cd_funcionario = @cd_func and cd_chefe2 is not null and @IndCoord=2
										 ) and 
 					  cd_tipo_comissao in (5,11) -- Supervisor
			   order by cd_parcela desc
		End    

	   if @regra = 2 -- Baseado no Tipo Pagamento
		Begin -- 5
			Declare cursor_Inc_Com CURSOR FOR 
			Select cd_parcela,perc_pagamento,0, cd_funcionario , cd_tipo_comissao, moeda
				FROM cm_vendedor 
				Where cd_tipo_pagamento = @tp_pag and 
					  cd_empresa is null and 
					  cd_plano is null and 
					  tp_empresa is null and                   
					  cd_funcionario in (
						  select cd_chefe from equipe_vendas as ev, funcionario as f where f.cd_equipe = ev.cd_equipe and f.cd_funcionario = @cd_func and cd_chefe is not null and @IndCoord=0
						  union
						  select cd_chefe1 from equipe_vendas as ev, funcionario as f where f.cd_equipe = ev.cd_equipe and f.cd_funcionario = @cd_func and cd_chefe1 is not null and @IndCoord=1
						  union
						  select cd_chefe2 from equipe_vendas as ev, funcionario as f where f.cd_equipe = ev.cd_equipe and f.cd_funcionario = @cd_func and cd_chefe2 is not null and @IndCoord=2
										 ) and 
 					  cd_tipo_comissao in (5,11) -- Supervisor
			   order by cd_parcela desc    
		End
	    
	   if @regra = 3 -- Baseado no Tipo Empresa
		Begin -- 5  
			Declare cursor_Inc_Com CURSOR FOR 
			Select cd_parcela,perc_pagamento,0, cd_funcionario , cd_tipo_comissao, moeda
				FROM cm_vendedor 
				Where tp_empresa = @tp_empresa and 
					  cd_empresa is null and 
					  cd_tipo_pagamento is null and 
					  cd_plano is null and 
					  cd_funcionario in (
						  select cd_chefe from equipe_vendas as ev, funcionario as f where f.cd_equipe = ev.cd_equipe and f.cd_funcionario = @cd_func and cd_chefe is not null and @IndCoord=0
						  union
						  select cd_chefe1 from equipe_vendas as ev, funcionario as f where f.cd_equipe = ev.cd_equipe and f.cd_funcionario = @cd_func and cd_chefe1 is not null and @IndCoord=1
						  union
						  select cd_chefe2 from equipe_vendas as ev, funcionario as f where f.cd_equipe = ev.cd_equipe and f.cd_funcionario = @cd_func and cd_chefe2 is not null and @IndCoord=2
										 ) and 
 					  cd_tipo_comissao in (5,11) -- Supervisor
			   order by cd_parcela desc    
		End        	   

	   if @regra = 4 -- Baseado no Plano
		Begin -- 5
			Declare cursor_Inc_Com CURSOR FOR 
			Select cd_parcela,perc_pagamento,0, cd_funcionario , cd_tipo_comissao, moeda
				FROM cm_vendedor 
				Where cd_plano = @cd_plano and 
     		  		  tp_empresa is null and 
					  cd_empresa is null and 
					  cd_tipo_pagamento is null and 
					  cd_funcionario in (
						  select cd_chefe from equipe_vendas as ev, funcionario as f where f.cd_equipe = ev.cd_equipe and f.cd_funcionario = @cd_func and cd_chefe is not null and @IndCoord=0
						  union
						  select cd_chefe1 from equipe_vendas as ev, funcionario as f where f.cd_equipe = ev.cd_equipe and f.cd_funcionario = @cd_func and cd_chefe1 is not null and @IndCoord=1
						  union
						  select cd_chefe2 from equipe_vendas as ev, funcionario as f where f.cd_equipe = ev.cd_equipe and f.cd_funcionario = @cd_func and cd_chefe2 is not null and @IndCoord=2
										 ) and 
 					  cd_tipo_comissao in (5,11) -- Supervisor
			   order by cd_parcela desc    
		End 

	   if @regra = 5  -- Baseado apenas no vendedor 
		Begin -- 6
			Declare cursor_Inc_Com CURSOR FOR 
			Select cd_parcela,perc_pagamento,0, cd_funcionario , cd_tipo_comissao, moeda
				FROM cm_vendedor 
				Where  cd_empresa is null and 
					   cd_tipo_pagamento is null and 
					   tp_empresa is null and 
					   cd_plano is null and 
					   cd_funcionario in (
						  select cd_chefe from equipe_vendas as ev, funcionario as f where f.cd_equipe = ev.cd_equipe and f.cd_funcionario = @cd_func and cd_chefe is not null and @IndCoord=0
						  union
						  select cd_chefe1 from equipe_vendas as ev, funcionario as f where f.cd_equipe = ev.cd_equipe and f.cd_funcionario = @cd_func and cd_chefe1 is not null and @IndCoord=1
						  union
						  select cd_chefe2 from equipe_vendas as ev, funcionario as f where f.cd_equipe = ev.cd_equipe and f.cd_funcionario = @cd_func and cd_chefe2 is not null and @IndCoord=2
										 ) and 
 					  cd_tipo_comissao in (5,11) -- Supervisor
			   order by cd_parcela desc    
		End 
	   OPEN cursor_Inc_Com
	   FETCH NEXT FROM cursor_Inc_Com INTO @cd_parc,@perc_pagamento,@fl_reteu,@cd_func,@cd_tipo_comissao,@moeda
	   WHILE (@@FETCH_STATUS <> -1)
		BEGIN -- 7 

		  insert into comissao_vendedor (cd_sequencial_dependente,cd_parcela_comissao,cd_funcionario, valor, 
			 perc_pagamento, fl_vendedor_reteu, dt_inclusao,fl_vitalicio,moeda)
		   values ( @cd_seq, @cd_parc+ @qt_parcelas, @cd_func, 
		            
                case when @moeda=0 then @vl_plano else @perc_pagamento end , 
		        case when @moeda=0 then @perc_pagamento else 100 end ,		            
		            
		            @fl_reteu, getdate(),
		            case when @cd_tipo_comissao = 5 then null else 1 end,
		            case when ISNULL(@moeda,0)=0 then null else 1 end)    

		  FETCH NEXT FROM cursor_Inc_Com INTO @cd_parc,@perc_pagamento,@fl_reteu,@cd_func,@cd_tipo_comissao,@moeda
		End -- 7 
		Close cursor_Inc_Com
		Deallocate cursor_Inc_Com
		
		Set @IndCoord = @IndCoord + 1 
	End     
    
    --- Verificar a Regra de Comissao do Mediador 
	Declare cursor_Inc_Com CURSOR FOR 
    Select cd_parcela,perc_pagamento,0, cd_funcionario , cd_tipo_comissao, moeda
		FROM cm_vendedor 
	    Where cd_funcionario <> @cd_func and 
 		  	  cd_empresa = @cd_emp and 
 			  cd_tipo_comissao in (3,13) -- Mediador
	   order by cd_parcela desc
   OPEN cursor_Inc_Com
   FETCH NEXT FROM cursor_Inc_Com INTO @cd_parc,@perc_pagamento,@fl_reteu,@cd_func,@cd_tipo_comissao,@moeda
   WHILE (@@FETCH_STATUS <> -1)
    BEGIN -- 7 

      insert into comissao_vendedor (cd_sequencial_dependente,cd_parcela_comissao,cd_funcionario, valor, 
         perc_pagamento, fl_vendedor_reteu, dt_inclusao,fl_vitalicio,moeda)
       values ( @cd_seq, @cd_parc+ @qt_parcelas, @cd_func, 
       
                case when @moeda=0 then @vl_plano else @perc_pagamento end , 
		        case when @moeda=0 then @perc_pagamento else 100 end ,	
		        @fl_reteu, getdate(),
       case when @cd_tipo_comissao = 3 then null else 1 end,
       case when ISNULL(@moeda,0)=0 then null else 1 end)    

      FETCH NEXT FROM cursor_Inc_Com INTO @cd_parc,@perc_pagamento,@fl_reteu,@cd_func,@cd_tipo_comissao,@moeda
    End -- 7 
    Close cursor_Inc_Com
    Deallocate cursor_Inc_Com
    
    -- Gerar Adesao
    if @Adesao = 1 
    Begin -- 8
        --print 'cd_ass ' + convert(varchar(10),@cd_ass)
        print @cd_ass
        
        --Declare @retorno1 varchar(1000)
        exec SP_GeraAdesao_XX @cd_ass, @cd_seq , @vl_adesao , @cd_plano , @retorno OUTPUT 
        
        print 'bbb'
        print @retorno
        print 'nnn' 
        if @retorno<>''
        Begin
            print 'kk'
            --Set @retorno = @retorno1
			RAISERROR (@retorno, 16, 1)
			ROLLBACK TRANSACTION
			RETURN
        End 
        
		--insert mensalidades (CD_ASSOCIADO_empresa,TP_ASSOCIADO_EMPRESA,cd_tipo_parcela,
		--   CD_TIPO_PAGAMENTO,CD_TIPO_RECEBIMENTO,DT_VENCIMENTO,DT_GERADO, VL_PARCELA, VL_Acrescimo,VL_Desconto)
		--  values (@cd_ass, 1 , 2 , 7, 0 , getdate() , getdate(), 0,0,0) 
  --       if @@Rowcount =  0 
		--  begin -- 8.1
		--	RAISERROR ('Erro na inclusão da adesão.', 16, 1)
		--	ROLLBACK TRANSACTION
		--	RETURN
		--  end -- 8.1

		--  select @cd_parc = max(CD_PARCELA)
		--	from mensalidades
		--   where cd_associado_empresa = @cd_ass and cd_tipo_parcela = 2 and 
		--		 convert(varchar(10),DT_VENCIMENTO,101) = convert(varchar(10),getdate(),101) and 
		--		 TP_ASSOCIADO_EMPRESA = 1 and vl_parcela = 0 
        
		--insert mensalidades_planos (cd_parcela_mensalidade, cd_sequencial_dep , valor, cd_plano)
		--   values (@cd_parc, @cd_seq, @vl_adesao , @cd_plano)

  --      update dependentes set
  --          cd_gerou_adesao = 1
  --        where cd_sequencial = @cd_seq

  --       if @@Rowcount =  0 
		--  begin -- 8.2
		--	RAISERROR ('Erro na inclusão da adesão do usuário.', 16, 1)
		--	ROLLBACK TRANSACTION
		--	RETURN
		--  end -- 8.2

    End --8 
    
    Commit    

End -- 0
