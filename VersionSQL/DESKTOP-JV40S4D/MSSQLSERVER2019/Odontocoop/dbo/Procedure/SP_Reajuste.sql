/****** Object:  Procedure [dbo].[SP_Reajuste]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE Procedure [dbo].[SP_Reajuste]
as
Begin 
	Declare @cd_emp int 
	Declare @perc float
	Declare @moeda bit 
	declare @dt_reaj datetime 
	Declare @id_reajuste int 

	Declare @cd_seq int
	Declare @plano int
	Declare @fixo int 
	
	Declare @cd_seqpp int 
	Declare @tp_empresa int 
	Declare @mes int
    Declare @dt_referencia_reajuste_pf date 	
	Declare @erro smallint = 0 

	Declare @vl_plano money
	Declare @vl_plano_new money
		
	DECLARE reajuste_r CURSOR FOR 
	select top 300 e.tp_empresa,r.cd_empresa,r.perc_reajuste ,r.fl_moeda,r.dt_reajuste , r.id_reajuste , r.cd_sequencial_pplano, r.mes_assinatura, r.dt_referencia_reajuste_pf
	  from reajuste as r , empresa as e
	 where r.cd_empresa=e.cd_empresa and r.dt_executado_reajuste is null and r.dt_aplicado_reajuste <= GETDATE() -- and r.cd_empresa in (2)

	OPEN reajuste_r 
	FETCH NEXT FROM reajuste_r INTO @tp_empresa,@cd_emp, @perc ,@moeda,@dt_reaj , @id_reajuste , @cd_seqpp,@mes,@dt_referencia_reajuste_pf
	WHILE (@@FETCH_STATUS <> -1)
	BEGIN

      print @cd_emp
      print @tp_empresa
      print @cd_seqpp
      print @dt_referencia_reajuste_pf
      
      Set @erro = 0 
      Begin transaction 
     
      if @tp_empresa in (2,6,8)
      Begin 
         -- Se remover o top o cursor se perde... Nao remover
	     Declare reaj_r2 cursor for 
	     select top 100 cd_sequencial, cd_plano, fl_valor_fixo from preco_plano where cd_empresa = @cd_emp and fl_inativo is null and  cd_sequencial = @cd_seqpp -- cd_plano not in (select cd_plano from planos where fl_cortesia = 1 or fl_exige_dentista=1) 
		  OPEN reaj_r2
		  FETCH NEXT FROM reaj_r2 INTO @cd_seq, @plano,@fixo
		  WHILE (@@FETCH_STATUS <> -1)
		  BEGIN
	  
			 print @cd_emp

			 print 'cccc'
			 -- Criar o novo preco plano e cancela o anterior (trigger_ins)
			 insert into preco_plano (cd_plano,cd_empresa,dt_Inicio,Vl_tit,Vl_dep,vl_agregado,fl_exige_adesao,
					fl_valor_fixo,vl_base_comissao_tit,vl_base_comissao_dep,Vl_adesao_tit,Vl_adesao_dep,qt_dias_adesao,cd_tipo_pagamento_adesao, id_reajuste ,nr_contrato_plano,fl_altera_precopre,
					vl_dep1,vl_dep2,vl_dep3,vl_dep4,vl_dep5)
			 select cd_plano,cd_empresa,convert(varchar(10),GETDATE(),101),
					case when Vl_tit IS null then null when @moeda=1 then Vl_tit+@perc else dbo.FS_FormataFloat((Vl_tit+(Vl_tit*@perc/100)),2) End,
					case when Vl_dep IS null then null when @moeda=1 then Vl_dep+@perc else dbo.FS_FormataFloat((Vl_dep+(Vl_dep*@perc/100)),2) End,
					case when vl_agregado IS null then null when @moeda=1 then vl_agregado+@perc else dbo.FS_FormataFloat((vl_agregado+(vl_agregado*@perc/100)),2) End,
					fl_exige_adesao, fl_valor_fixo,
					case when vl_base_comissao_tit IS null then null when @moeda=1 then vl_base_comissao_tit+@perc else dbo.FS_FormataFloat((vl_base_comissao_tit+(vl_base_comissao_tit*@perc/100)),2) End,
					case when vl_base_comissao_dep IS null then null when @moeda=1 then vl_base_comissao_dep+@perc else dbo.FS_FormataFloat((vl_base_comissao_dep+(vl_base_comissao_dep*@perc/100)),2) End,
					case when Vl_adesao_tit IS null then null when @moeda=1 then Vl_adesao_tit+@perc else dbo.FS_FormataFloat((Vl_adesao_tit+(Vl_adesao_tit*@perc/100)),2) End,
					case when Vl_adesao_dep IS null then null when @moeda=1 then Vl_adesao_dep+@perc else dbo.FS_FormataFloat((Vl_adesao_dep+(Vl_adesao_dep*@perc/100)),2) End,
					qt_dias_adesao,cd_tipo_pagamento_adesao,@id_reajuste, nr_contrato_plano, fl_altera_precopre,
					case when Vl_dep1 IS null then null when @moeda=1 then Vl_dep1+@perc else dbo.FS_FormataFloat((Vl_dep1+(Vl_dep1*@perc/100)),2) End,
					case when Vl_dep2 IS null then null when @moeda=1 then Vl_dep2+@perc else dbo.FS_FormataFloat((Vl_dep2+(Vl_dep2*@perc/100)),2) End,
					case when Vl_dep3 IS null then null when @moeda=1 then Vl_dep3+@perc else dbo.FS_FormataFloat((Vl_dep3+(Vl_dep3*@perc/100)),2) End,
					case when Vl_dep4 IS null then null when @moeda=1 then Vl_dep4+@perc else dbo.FS_FormataFloat((Vl_dep4+(Vl_dep4*@perc/100)),2) End,
					case when Vl_dep5 IS null then null when @moeda=1 then Vl_dep5+@perc else dbo.FS_FormataFloat((Vl_dep5+(Vl_dep5*@perc/100)),2) End
			   from preco_plano             
			  where cd_sequencial = @cd_seq
			  IF @@ERROR <> 0 
			  begin 
				 Set @erro = 1
				 break 
			  End
			  print 'xxxxx'        
	      
			  --- Valor Fixo Nao.. Gerar o Log dos registros  
			  if @fixo=0 
			  Begin 
		         
				 insert log_reajuste (cd_empresa,dt_reajuste,cd_sequencial_dep,vl_anterior,vl_atual, id_reajuste )
				 select @cd_emp, @dt_reaj, d.CD_SEQUENCIAL , d.vl_plano , case when @moeda=1 then d.vl_plano+@perc else dbo.FS_FormataFloat((d.vl_plano+(d.vl_plano*@perc/100)),2) End,@id_reajuste
				   from DEPENDENTES as d, ASSOCIADOS as a, empresa as e, HISTORICO as h , SITUACAO_HISTORICO as sh 
				  where d.CD_ASSOCIADO = a.cd_associado and 
			 			a.cd_empresa = e.CD_EMPRESA and 
						d.CD_Sequencial_historico = h.cd_sequencial and 
						h.CD_SITUACAO = sh.CD_SITUACAO_HISTORICO and 
												(
						  sh.fl_gera_cobranca = 1 
						 or 
						  sh.CD_SITUACAO_HISTORICO in (select mdeId from Processos where cd_processo=20)
						) and
						d.cd_plano = @plano and
						a.cd_empresa = @cd_emp and 
						d.vl_plano > 0 
				  IF @@ERROR <> 0 
				  begin 
					 Set @erro = 1
					 break 
				  End	         

				  update DEPENDENTES 
					 set DEPENDENTES.vl_plano = case when @moeda=1 then DEPENDENTES.vl_plano+@perc else dbo.FS_FormataFloat((DEPENDENTES.vl_plano+(DEPENDENTES.vl_plano*@perc/100)),2) End
				   from ASSOCIADOS as a, empresa as e, HISTORICO as h , SITUACAO_HISTORICO as sh 
				  where DEPENDENTES.CD_ASSOCIADO = a.cd_associado and 
			 			a.cd_empresa = e.CD_EMPRESA and 
						DEPENDENTES.CD_Sequencial_historico = h.cd_sequencial and 
						h.CD_SITUACAO = sh.CD_SITUACAO_HISTORICO and 
												(
						  sh.fl_gera_cobranca = 1 
						 or 
						  sh.CD_SITUACAO_HISTORICO in (select mdeId from Processos where cd_processo=20)
						) and
						DEPENDENTES.cd_plano = @plano and
						a.cd_empresa = @cd_emp and 
						DEPENDENTES.vl_plano > 0 
				  IF @@ERROR <> 0 
				  begin 
					 Set @erro = 1
					 break 
				  End	         
		         
			  End

			FETCH NEXT FROM reaj_r2 INTO @cd_seq, @plano, @fixo
		  End 
		  Close reaj_r2   
		  Deallocate reaj_r2
	  End 	  
      Else
      Begin -- PF 

print 'aqui'

	     Declare reaj_r2 cursor for 
	    
			select top 20000 d1.CD_SEQUENCIAL,d1.vl_plano as valor_atual, case when @moeda=1 then d1.vl_plano+@perc else dbo.FS_FormataFloat((d1.vl_plano+(d1.vl_plano*@perc/100)),2) End as novo_valor
			  from ASSOCIADOS as a , DEPENDENTES as d, HISTORICO as h , SITUACAO_HISTORICO as sh ,  -- titular
				   DEPENDENTES as d1, HISTORICO as h1 , SITUACAO_HISTORICO as sh1  
			 where a.cd_associado = d.CD_ASSOCIADO and d.CD_GRAU_PARENTESCO=1 and d.CD_Sequencial_historico = h.cd_sequencial and h.CD_SITUACAO = sh.CD_SITUACAO_HISTORICO and 						
			 (
						  sh.fl_gera_cobranca = 1 
						 or 
						  sh.CD_SITUACAO_HISTORICO in (select mdeId from Processos where cd_processo=20)
						) and 
				   a.cd_associado = d1.CD_ASSOCIADO and d1.CD_Sequencial_historico = h1.cd_sequencial and h1.CD_SITUACAO = sh1.CD_SITUACAO_HISTORICO and  
				   (
					  sh1.fl_gera_cobranca = 1 
					   or 
					  sh1.CD_SITUACAO_HISTORICO in (select mdeId from Processos where cd_processo=20)
					) and  
				   month(isnull(d.dt_reajuste,d.dt_assinaturaContrato))=@mes and 
				   year(isnull(d.dt_reajuste,d.dt_assinaturaContrato))<year(dateadd(month,1,getdate()))  and
				   datediff(month,isnull(d.dt_reajuste,d.dt_assinaturaContrato),getdate())>10 and 
				   a.CD_EMPRESA = @cd_emp and 
				   d1.cd_plano in (select cd_plano from preco_plano where cd_sequencial=@cd_seqpp) and
				   d1.vl_plano>0 order by a.cd_associado
		  OPEN reaj_r2
		  FETCH NEXT FROM reaj_r2 INTO @cd_seq, @vl_plano,@vl_plano_new
		  WHILE (@@FETCH_STATUS <> -1)
		  BEGIN
	  
			 print convert(varchar(10),@cd_seq)+' ,' + convert(varchar(10),@vl_plano) + ' ,' + convert(varchar(10),@vl_plano_new)

			 insert log_reajuste (cd_empresa,dt_reajuste,cd_sequencial_dep,vl_anterior,vl_atual, id_reajuste )
			 values (@cd_emp, @dt_reaj, @cd_seq, @vl_plano,@vl_plano_new,@id_reajuste)
			  IF @@ERROR <> 0 
			  begin 
				 Set @erro = 1
				 break 
			  End	         

			  update DEPENDENTES 
				 set vl_plano = @vl_plano_new,
				     dt_reajuste = @dt_referencia_reajuste_pf
			   where cd_sequencial=@cd_seq
			  IF @@ERROR <> 0 
			  begin 
				 Set @erro = 1
				 break 
			  End	         
		         
			FETCH NEXT FROM reaj_r2 INTO @cd_seq, @vl_plano,@vl_plano_new
		  End 
		  Close reaj_r2   
		  Deallocate reaj_r2

      End 

	  if @erro = 0 
	  begin 
	       update reajuste 
	        set dt_executado_reajuste=GETDATE(),
	            qt_vidas = case when @tp_empresa not in (2,6,8) then null 
	                       else 
	                           (select COUNT(0)
	                              from preco_plano as pp, ASSOCIADOS as a, 
	                                   DEPENDENTES as d1, HISTORICO as h1, SITUACAO_HISTORICO as sh1, -- Usuario
	                                   DEPENDENTES as d2, HISTORICO as h2, SITUACAO_HISTORICO as sh2 -- titular
	                             where pp.cd_sequencial=@cd_seqpp
	                               and pp.cd_empresa = a.cd_empresa 
	                               and a.cd_associado = d1.CD_ASSOCIADO 
	                               and pp.cd_plano = d1.cd_plano 
	                               and d1.CD_Sequencial_historico = h1.cd_sequencial 
	                               and h1.CD_SITUACAO = sh1.CD_SITUACAO_HISTORICO
	                               and sh1.fl_incluir_ans = 1 
	                               and a.cd_associado = d2.cd_associado and d2.cd_grau_parentesco=1
	                               and d2.CD_Sequencial_historico = h2.cd_sequencial
	                               and h2.CD_SITUACAO = sh2.CD_SITUACAO_HISTORICO
	                               and sh2.fl_incluir_ans=1
	                           )
	                       End
	      where cd_empresa = @cd_emp and dt_reajuste = @dt_reaj and dt_executado_reajuste is null and id_reajuste = @id_reajuste
	     IF @@ERROR <> 0 
	        set @erro=1
	  End
	  
	  if @erro = 0 
	     commit
	  else
	     rollback      
	  
	  	FETCH NEXT FROM reajuste_r INTO @tp_empresa,@cd_emp, @perc ,@moeda,@dt_reaj , @id_reajuste , @cd_seqpp,@mes,@dt_referencia_reajuste_pf
	End 
	Close reajuste_r 
	Deallocate reajuste_r

End	
