/****** Object:  Procedure [dbo].[SP_TROCA_SITUACAO]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[SP_TROCA_SITUACAO]
as 
begin

   Declare @DataGeracao as date 
   set @DataGeracao = getdate()  --- -1 -- Nao alterem 
   
 --  -- Cancelar os usuarios e empresa que estao em Pre e Com adesao aberta superior a 30 dias
 --  Create table #tb_m (cod int, tipo int)
   
 --  insert #tb_m (cod,tipo)
	--select m.CD_ASSOCIADO_empresa, 2 
	--  from mensalidades as m inner join empresa as e on m.CD_ASSOCIADO_empresa=e.cd_empresa 
	--			inner join historico as h on e.CD_Sequencial_historico = h.cd_sequencial 
	-- where m.cd_tipo_parcela = 2 
	--   and m.CD_TIPO_RECEBIMENTO=0 
	--   and m.dt_vencimento<=DATEADD(month,-1,getdate())
	--   and m.tp_associado_empresa = 2
	--   and h.CD_SITUACAO=16
	--union
	--select m.CD_ASSOCIADO_empresa, 1
	--  from mensalidades as m inner join associados as a on m.CD_ASSOCIADO_empresa=a.cd_associado
	--			inner join DEPENDENTES as d on a.cd_associado = d.CD_ASSOCIADO and d.CD_GRAU_PARENTESCO=1
	--			inner join historico as h on d.CD_Sequencial_historico = h.cd_sequencial 
	-- where m.cd_tipo_parcela = 2 
	--   and m.CD_TIPO_RECEBIMENTO=0 
	--   and m.dt_vencimento<=DATEADD(month,-1,getdate())
	--   and m.tp_associado_empresa = 1
	--   and h.CD_SITUACAO=16
   
 --  insert HISTORICO (cd_empresa, CD_SITUACAO, DT_SITUACAO, cd_usuario, cd_MOTIVO_CANCELAMENTO)
 --  select cod , 2, @DataGeracao, 7021, 19 
 --    from #tb_m 
 --   where tipo=2 

 --  insert HISTORICO (CD_SEQUENCIAL_dep, CD_SITUACAO, DT_SITUACAO, cd_usuario, cd_MOTIVO_CANCELAMENTO)
 --  select d.CD_SEQUENCIAL , 2, @DataGeracao, 7021, 19 
 --    from #tb_m as t inner join ASSOCIADOS as a on t.cod = a.cd_associado 
 --           inner join DEPENDENTES as d on a.cd_associado=d.CD_ASSOCIADO
 --   where t.tipo=1 and d.CD_GRAU_PARENTESCO=1
        
 --   update mensalidades 
 --      set CD_TIPO_RECEBIMENTO=1 , DT_BAIXA=@DataGeracao, CD_USUARIO_BAIXA=7021
 --     from #tb_m as t 
 --    where mensalidades.CD_ASSOCIADO_empresa=t.cod 
	--   and mensalidades.tp_associado_empresa = t.tipo 
 --      and mensalidades.cd_tipo_recebimento = 0        
 --      and mensalidades.cd_tipo_parcela = 2 
	--   and mensalidades.dt_vencimento<=DATEADD(month,-1,getdate())

 --   select * from #tb_m

 --   drop table #tb_m
   
 --  --  Ajustar a data de assinatura do contrato 
	--update ASSOCIADOS
	--  set dia_vencimento=case when day(x.DT_PAGAMENTO)>30 then 30 else day(x.DT_PAGAMENTO) end
	--  from (
	--		select m.CD_ASSOCIADO_empresa, mp.cd_sequencial_dep, m.DT_PAGAMENTO, l.dt_assinaturaContrato, a.cd_associado
	--		  from mensalidades as m inner join mensalidades_planos as mp on m.CD_PARCELA = mp.cd_parcela_mensalidade
	--				  inner join lote_contratos_contratos_vendedor as l on l.cd_sequencial_dep = mp.cd_sequencial_dep
	--				  inner join DEPENDENTES as d on l.cd_sequencial_dep=d.cd_Sequencial
	--				  inner join ASSOCIADOS as a on d.CD_ASSOCIADO = a.cd_Associado
	--				  inner join empresa as e on a.cd_empresa=e.cd_empresa
	--		 where m.TP_ASSOCIADO_EMPRESA=1 and m.cd_tipo_parcela=2 and mp.valor>0 and m.VL_PARCELA>0 
	--		   and m.DT_PAGAMENTO>=dateadd(month,-1,@DataGeracao)
	--		   and m.DT_PAGAMENTO<>l.dt_assinaturaContrato	   
	--		   and e.TP_EMPRESA=3
	--		   and d.CD_GRAU_PARENTESCO=1
 --          ) as x 
 --    where ASSOCIADOS.cd_associado = x.cd_associado

	--update DEPENDENTES
	--  set dt_assinaturaContrato=x.DT_PAGAMENTO,
	--      mm_aaaa_1pagamento = convert(varchar(6),DATEADD(month,1,x.DT_PAGAMENTO),112)
	--  from (
	--		select m.CD_ASSOCIADO_empresa, mp.cd_sequencial_dep, m.DT_PAGAMENTO, l.dt_assinaturaContrato
	--		  from mensalidades as m inner join mensalidades_planos as mp on m.CD_PARCELA = mp.cd_parcela_mensalidade
	--				  inner join lote_contratos_contratos_vendedor as l on l.cd_sequencial_dep = mp.cd_sequencial_dep
	--				  inner join DEPENDENTES as d on l.cd_sequencial_dep=d.cd_Sequencial
	--				  inner join ASSOCIADOS as a on d.CD_ASSOCIADO = a.cd_Associado
	--				  inner join empresa as e on a.cd_empresa=e.cd_empresa
	--		 where m.TP_ASSOCIADO_EMPRESA=1 and m.cd_tipo_parcela=2 and mp.valor>0 and m.VL_PARCELA>0 
	--		   and m.DT_PAGAMENTO>=dateadd(month,-1,@DataGeracao)
	--		   and m.DT_PAGAMENTO<>l.dt_assinaturaContrato	   
	--		   and e.TP_EMPRESA=3
 --          ) as x 
 --    where DEPENDENTES.cd_Sequencial = x.cd_sequencial_dep 
   
	--update lote_contratos_contratos_vendedor
	--  set dt_assinaturaContrato=x.DT_PAGAMENTO
	--  from (
	--		select m.CD_ASSOCIADO_empresa, mp.cd_sequencial_dep, m.DT_PAGAMENTO, l.dt_assinaturaContrato
	--		  from mensalidades as m inner join mensalidades_planos as mp on m.CD_PARCELA = mp.cd_parcela_mensalidade
	--				  inner join lote_contratos_contratos_vendedor as l on l.cd_sequencial_dep = mp.cd_sequencial_dep
	--				  inner join DEPENDENTES as d on l.cd_sequencial_dep=d.cd_Sequencial
	--				  inner join ASSOCIADOS as a on d.CD_ASSOCIADO = a.cd_Associado
	--				  inner join empresa as e on a.cd_empresa=e.cd_empresa
	--	 where m.TP_ASSOCIADO_EMPRESA=1 and m.cd_tipo_parcela=2 and mp.valor>0 and m.VL_PARCELA>0 
	--		   and m.DT_PAGAMENTO>=dateadd(month,-1,@DataGeracao)
	--		   and m.DT_PAGAMENTO<>l.dt_assinaturaContrato
	--		   and e.TP_EMPRESA=3			   
	--	   ) as x 
	-- where lote_contratos_contratos_vendedor.cd_sequencial_dep=x.cd_sequencial_dep

           
 --print 'Se Situacao = 1 -- Ativo e Dias > 60 mover para INADIMPLENTE (4)'
	--insert into historico (CD_SEQUENCIAL_dep, DT_SITUACAO, CD_SITUACAO)
	--Select cd_seqdep ,@DataGeracao,18 
	--  from MensalidadeResumo as m, ASSOCIADOS as a, DEPENDENTES as d, empresa as e , HISTORICO as h , historico as eh -- Historico da Empresa
	-- where m.codigo=a.cd_associado and 
	--	   a.cd_empresa=e.CD_EMPRESA and 
	--	   e.cd_sequencial_historico = eh.cd_sequencial and eh.cd_situacao = 1 and 
	--	   a.cd_associado=d.CD_ASSOCIADO and d.CD_GRAU_PARENTESCO=1 and 
	--	   d.CD_Sequencial_historico=h.CD_SEQUENCIAL and
	--	   h.CD_SITUACAO = 1 and 
	--	   m.situacao=1 and 
	--	   m.tipo=1 and 
	--	   m.dias>90  and m.qtde_abertas >= 3 and 
	--	   e.TP_EMPRESA in (3,10) 
		   


    -- Cancelar por inadiplencia nos dias 11 e 12
  --  if DAY(getdate()) in (12,13)
  --  Begin

		--Declare @dt_ref date = dateadd(day,-1,convert(date,convert(varchar(2),month(getdate()))+'/01/'+convert(varchar(4),year(getdate()))))

		--insert HISTORICO (cd_sequencial_dep, CD_SITUACAO, cd_MOTIVO_CANCELAMENTO, DT_SITUACAO)
		--select dep.CD_SEQUENCIAL, 2, 3, GETDATE() 
		----select x.cd_associado , x.nm_completo, x.cd_associado, x.v1, x.v2
		-- from (
		--select a.cd_associado, a.nm_completo, e.nm_razsoc , m.dt_vencimento as v1  , 

		--	   ( select top 1 m1.dt_vencimento
		--		   from mensalidades as m1
		--		  where m1.cd_associado_empresa = a.cd_Associado  
		--			and m1.dt_vencimento>m.dt_vencimento 
		--			and m1.dt_vencimento<=dateadd(month,1,m.dt_vencimento)
		--			and m1.dt_vencimento<=@dt_ref
		--			and m1.CD_TIPO_RECEBIMENTO = 0 
		--			and m1.TP_ASSOCIADO_EMPRESA = 1 
		--			and m1.cd_tipo_parcela = 1 
		--	   ) as v2


		--  from mensalidades as m inner join ASSOCIADOS as a on m.cd_associado_empresa = a.cd_associado 
		--			inner join DEPENDENTES as d on a.cd_associado=d.CD_ASSOCIADO
		--			inner join HISTORICO as h on d.CD_Sequencial_historico = h.cd_sequencial 
		--			inner join empresa as e on a.cd_empresa = e.cd_empresa 
		-- where m.dt_vencimento>dateadd(month,-6,@dt_ref)
		--   and m.dt_vencimento<=@dt_ref
		--   and CD_TIPO_RECEBIMENTO = 0 
		--   and m.TP_ASSOCIADO_EMPRESA = 1 
		--   and m.cd_tipo_parcela = 1 
		--   and a.cd_empresa not in (select cd_empresa from GrupoAnalise_Empresa where CD_GRUPOAnalise=50)
		--   and d.CD_GRAU_PARENTESCO=1
		--   and h.CD_SITUACAO=1
		--	 ) x inner join DEPENDENTES as dep on x.cd_associado = dep.CD_ASSOCIADO
		--  where v2 is not null  and dep.CD_GRAU_PARENTESCO=1



  --  End


          
	 --    Declare @tp_ass int 
	 --    Declare @cd_empresa int 
  --       Declare @dt_adesao date
  --       Declare @qtde int 
         
  --       -- Criar adesao para quem nao tem          
	 --    Declare Dados_Cursor_Adesao  cursor for  
		--  select 2, e.cd_empresa , convert(varchar(10),e.DT_FECHAMENTO_CONTRATO,101)
		--    from empresa as e inner join historico as h on e.cd_sequencial_historico = h.cd_sequencial
	 --      where h.cd_situacao = 1 
		--     and e.tp_empresa = 2 
		--	 and e.CD_EMPRESA not in (select distinct cd_Associado_empresa from mensalidades where cd_tipo_parcela=2 and tp_Associado_empresa=2 and CD_TIPO_RECEBIMENTO<>1)
		--	 and e.cd_empresa in (select t1.cd_empresa from empresa as t1 inner join associados as t2 on t1.cd_empresa = t2.cd_empresa group by t1.cd_empresa)
		--	 and e.dt_fechamento_contrato >='02/01/2018'
		--	 and e.cd_empresa not in (select cd_empresa from grupoanalise_empresa where cd_grupoanalise=50)
			 
  --      union 
        
		--  select 1, a.cd_associado , convert(varchar(10),d.dt_assinaturaContrato,101) --, e.cd_empresa
		--    from associados as a inner join dependentes as d on a.cd_associado = d.CD_ASSOCIADO 
		--            inner join empresa as e on a.cd_empresa = e.cd_empresa 
		--            inner join historico as h on d.cd_sequencial_historico = h.cd_sequencial
	 --      where h.cd_situacao = 1 
		--     and e.tp_empresa = 3 
		--     and d.CD_GRAU_PARENTESCO = 1 
		--     and a.cd_associado not in (select distinct cd_Associado_empresa from mensalidades where cd_tipo_parcela=2 and tp_Associado_empresa=1 and CD_TIPO_RECEBIMENTO<>1)
		--     and a.dt_assinatura_contrato >= '02/01/2018'
		--     and e.cd_empresa not in (select cd_empresa from grupoanalise_empresa where cd_grupoanalise=50)
		     
   		   
		--  Open Dados_Cursor_Adesao
		-- Fetch next from Dados_Cursor_Adesao Into @tp_ass, @cd_empresa, @dt_adesao
		-- While (@@fetch_status  <> -1)
		-- Begin -- 3.1
	 
		--   Set @qtde= 0 
		   
		--   Begin tran 
		   
		--   insert mensalidades (CD_ASSOCIADO_empresa,TP_ASSOCIADO_EMPRESA,cd_tipo_parcela, CD_TIPO_PAGAMENTO,CD_TIPO_RECEBIMENTO,DT_VENCIMENTO,DT_GERADO, VL_PARCELA)
		--   values (@cd_empresa, @tp_ass , 2 , 7, 0 , @dt_adesao , getdate(), 0) 
		--	if @@Rowcount =  0 
		--	  begin -- 8.1
		--		 rollback
		--		 close Dados_Cursor_Adesao
		--		 deallocate Dados_Cursor_Adesao 					 
		--		 print 'Erro na inclusao da mensalidade.' + convert(varchar(10),@cd_empresa)
		--		 return     
		--	  end -- 8.1

		--		select @qtde = max(CD_PARCELA)
		--		  from mensalidades
		--		 where cd_associado_empresa = @cd_empresa and cd_tipo_parcela = 2 and TP_ASSOCIADO_EMPRESA = @tp_ass and vl_parcela = 0 and cd_tipo_recebimento = 0
		        
		--        if @tp_ass = 1 
		--        begin
		--			insert mensalidades_planos (cd_parcela_mensalidade, cd_sequencial_dep , valor, cd_plano) 
  --					select @qtde, d.CD_SEQUENCIAL , 0 , d.cd_plano       
		--			 from dependentes as d inner join historico as h on d.CD_Sequencial_historico = h.cd_sequencial
		--			where d.cd_associado = @cd_empresa and h.CD_SITUACAO in (1,16)
		--		end
		--		else 	
		--        begin
		--			insert mensalidades_planos (cd_parcela_mensalidade, cd_sequencial_dep , valor, cd_plano) 
  --					select @qtde, d.CD_SEQUENCIAL , 0 , d.cd_plano       
		--			 from associados as a inner join dependentes as d on a.cd_associado = d.cd_associado 
		--			          inner join historico as h on d.CD_Sequencial_historico = h.cd_sequencial
		--			where a.cd_empresa = @cd_empresa and h.CD_SITUACAO in (1,16)
		--		end
		--		if @@Rowcount =  0 
		--		  begin -- 8.1
		--			 rollback
		--			 close Dados_Cursor_Adesao
		--			 deallocate Dados_Cursor_Adesao 					 
		--			 print 'Erro na inclusao da mensalidade plano.' + convert(varchar(10),@cd_empresa)
		--			 return     
		--		  end -- 8.1	    

		--	 Commit   
			             
		--	 Fetch next from Dados_Cursor_Adesao Into @tp_ass, @cd_empresa, @dt_adesao
		--   End   
		--   Close Dados_Cursor_Adesao
		--   Deallocate Dados_Cursor_Adesao 

  --        -- Baixa as mensalidades 
  --        update mensalidades 
  --           set executarTrigger=0, 
  --               DT_PAGAMENTO=dt_vencimento, 
  --               CD_TIPO_RECEBIMENTO=CD_TIPO_PAGAMENTO, 
  --               CD_USUARIO_BAIXA=7021,
  --               DT_BAIXA = GETDATE(),
  --               VL_PAGO=0
  --         where cd_tipo_parcela = 2 and CD_TIPO_RECEBIMENTO=0 and VL_PARCELA=0      
          
  --       ------ Quem esta devendo adesao e nao esta em pre
  --       --insert HISTORICO (cd_empresa, cd_situacao, dt_situacao)
  --       --select e.CD_EMPRESA , 16, GETDATE()
  --       --  from mensalidades as m 
  --       --            inner join empresa as e on m.cd_Associado_empresa = e.cd_empresa 
  --       --            inner join historico as h on e.cd_sequencial_historico = h.cd_sequencial 
  --       -- where m.tp_associado_empresa = 2 and cd_tipo_parcela = 2 and m.vl_parcela > 0 and cd_tipo_recebimento = 0 
  --       --   and h.cd_situacao = 1 
  --       --   and e.cd_empresa not in (select cd_empresa from grupoanalise_empresa where cd_grupoanalise=50)
          
  --       insert HISTORICO (CD_SEQUENCIAL_dep, cd_situacao, dt_situacao) 
  --       select d.CD_SEQUENCIAL,16,GETDATE()
  --         from mensalidades as m 
  --                   inner join DEPENDENTES as d on m.cd_Associado_empresa = d.CD_ASSOCIADO 
  --                   inner join historico as h on d.cd_sequencial_historico = h.cd_sequencial 
  --                   inner join ASSOCIADOS as a on d.CD_ASSOCIADO=a.cd_associado
  --        where d.CD_GRAU_PARENTESCO=1
  --          and m.tp_associado_empresa = 1 and cd_tipo_parcela = 2 and m.vl_parcela > 0 and cd_tipo_recebimento = 0 
  --          and h.cd_situacao = 1 
  --          and a.cd_empresa not in (select cd_empresa from grupoanalise_empresa where cd_grupoanalise=50)
          
          ---- Se pagou adesao nos ultimos 7 dias e PF ajustar o Data de Assinatura e vencimento pela data de pagamento da adesao 
          --update DEPENDENTES 
          --  set dt_assinaturaContrato = m.dt_vencimento, mm_aaaa_1pagamento=convert(varchar(6),DATEADD(MONTH,1,m.dt_vencimento),112)
          -- from associados, mensalidades as m , empresa as e 
          --where DEPENDENTES.CD_ASSOCIADO = ASSOCIADOS.cd_associado
          --  and associados.cd_associado = m.CD_ASSOCIADO_empresa and m.TP_ASSOCIADO_EMPRESA=1
          --  and ASSOCIADOS.cd_empresa = e.cd_empresa and e.TP_EMPRESA=3
          --  and cd_tipo_parcela = 2 
          --  and m.VL_PARCELA>0 
          --  and m.CD_TIPO_RECEBIMENTO>2 
          --  and m.DT_PAGAMENTO >= DATEADD(DAY,-10,GETDATE())


          --update ASSOCIADOS 
          --  set associados.dia_vencimento = DAY(m.dt_vencimento), dt_assinatura_contrato = m.dt_vencimento
          -- from mensalidades as m , empresa as e 
          --where cd_associado = m.CD_ASSOCIADO_empresa and m.TP_ASSOCIADO_EMPRESA=1
          --  and ASSOCIADOS.cd_empresa = a.cd_empresa and e.TP_EMPRESA=3
          --  and cd_tipo_parcela = 2 
          --  and m.VL_PARCELA>0 
          --  and m.CD_TIPO_RECEBIMENTO>2 
          --  and m.DT_PAGAMENTO >= DATEADD(DAY,-10,GETDATE())
          
       --   -- Quem esta em pre c 7 dias do pagamento da adesao, mover para ativo 
       --   insert HISTORICO (CD_SEQUENCIAL_dep, CD_SITUACAO, DT_SITUACAO)
       --   select d.cd_Sequencial , 1, GETDATE() 
       --     from DEPENDENTES as d inner join HISTORICO as h on d.CD_Sequencial_historico=h.cd_sequencial 
       --               inner join ASSOCIADOS as a on d.CD_ASSOCIADO = a.cd_associado
       --    where h.CD_SITUACAO = 16
       --      and a.cd_empresa in (
						 --  select m.CD_ASSOCIADO_empresa -- Empresas q estao pagas
						 --  from mensalidades as m 
							--		 inner join empresa as e on m.cd_Associado_empresa = e.cd_empresa 
							--		 inner join historico as h on e.cd_sequencial_historico = h.cd_sequencial 
						 -- where m.tp_associado_empresa = 2 and cd_tipo_parcela = 2 and cd_tipo_recebimento > 2 
							--and h.cd_situacao = 16
							--and dateadd(day,7,convert(varchar(10),h.DT_SITUACAO,101)) <= CONVERT(varchar(10),getdate(),101)
							--and dateadd(day,7,convert(varchar(10),m.dt_vencimento,101)) <= CONVERT(varchar(10),getdate(),101)
       --                          )
                                   
       --   insert HISTORICO (CD_SEQUENCIAL_dep, CD_SITUACAO, DT_SITUACAO)
       --   select d.cd_Sequencial , 1, GETDATE() 
       --    from mensalidades as m 
       --              inner join DEPENDENTES as d on m.cd_Associado_empresa = d.CD_ASSOCIADO 
       --              inner join historico as h on d.cd_sequencial_historico = h.cd_sequencial 
       --   where m.tp_associado_empresa = 1 and cd_tipo_parcela = 2 and cd_tipo_recebimento > 2 
       --     and h.cd_situacao = 16      
       --     and dateadd(day,7,convert(varchar(10),h.DT_SITUACAO,101)) <= CONVERT(varchar(10),getdate(),101)
       --     and dateadd(day,7,convert(varchar(10),m.dt_vencimento,101)) >= CONVERT(varchar(10),getdate(),101) 


		 -- Buscar Suspensos e spc que nao estao no Arquivo de Resumo e mover para cancelados = 2
			--print 'Buscar Suspensos;spc que nao estao no Arquivo de Resumo e mover para cancelados = 2'
			--insert into historico (CD_SEQUENCIAL_dep, DT_SITUACAO, CD_SITUACAO,cd_motivo_cancelamento)
			--select d.CD_SEQUENCIAL ,GETDATE(),2 , sh.cd_MOTIVO_CANCELAMENTO 
			--  from dependentes as d, HISTORICO  as sh , ASSOCIADOS as a , empresa as e , historico as eh -- Historico da Empresa
			-- where d.CD_Sequencial_historico=sh.cd_sequencial  and 
			--	   sh.CD_SITUACAO in (3) and d.CD_GRAU_PARENTESCO=1 and 
			--	   d.CD_ASSOCIADO = a.cd_associado and 
			--	   a.cd_empresa=e.CD_EMPRESA and 
			--	   e.cd_sequencial_historico = eh.cd_sequencial and eh.cd_situacao = 1 and 
			--	   e.TP_EMPRESA in (3) and 
			--	   a.cd_associado not in (select distinct CD_ASSOCIADO_empresa from MENSALIDADES where TP_ASSOCIADO_EMPRESA=1 and CD_TIPO_RECEBIMENTO=0)

		 --  insert into historico (CD_empresa, DT_SITUACAO, CD_SITUACAO,cd_motivo_cancelamento)
		 --  select e.CD_empresa,GETDATE(), 2, eh.cd_motivo_cancelamento 
			-- from empresa as e, historico as eh -- Historico da Empresa
			--where e.cd_sequencial_historico = eh.cd_sequencial and eh.cd_situacao in (3) and 
	 	--		  e.tp_empresa in (2,6,8) and 
	 	--		  e.cd_empresa not in (select distinct CD_ASSOCIADO_empresa from MENSALIDADES where TP_ASSOCIADO_EMPRESA=2 and CD_TIPO_RECEBIMENTO=0) 
				  
		   -- 'Buscar Suspensos por tempo determinado que dia já chegou voltar para normal'
			print 'Buscar Suspensos por tempo determinado que dia já chegou voltar para normal'
		   insert into historico (CD_SEQUENCIAL_dep, DT_SITUACAO, CD_SITUACAO,cd_MOTIVO_CANCELAMENTO)
		   select d.CD_SEQUENCIAL ,convert(varchar(10),GETDATE(),101) + ' 23:59', case when sh.CD_SITUACAO in (17) then 1 else 2 end , case when sh.CD_SITUACAO in (19) and sh.cd_MOTIVO_CANCELAMENTO IS not null then sh.cd_MOTIVO_CANCELAMENTO else null end
			 from dependentes as d, HISTORICO  as sh , ASSOCIADOS as a , empresa as e , historico as eh -- Historico da Empresa
			where d.CD_Sequencial_historico=sh.cd_sequencial  and 
				  sh.CD_SITUACAO in (17,20) and 
				  d.CD_ASSOCIADO = a.cd_associado and 
				  a.cd_empresa=e.CD_EMPRESA and 
				  e.cd_sequencial_historico = eh.cd_sequencial and -- eh.cd_situacao = 1 and 
				  sh.dt_fim_atendimento <= @DataGeracao           

		   insert into historico (CD_empresa, DT_SITUACAO, CD_SITUACAO,cd_MOTIVO_CANCELAMENTO)
		   select e.CD_EMPRESA , convert(varchar(10),GETDATE(),101) + ' 23:59', case when eh.CD_SITUACAO in (17) then 1 else 2 end , case when eh.CD_SITUACAO in (19) and eh.cd_MOTIVO_CANCELAMENTO IS not null then eh.cd_MOTIVO_CANCELAMENTO else null end
			 from empresa as e , historico as eh -- Historico da Empresa
			where e.cd_sequencial_historico = eh.cd_sequencial and 
				  eh.CD_SITUACAO in (17,20) and 
				  eh.dt_fim_atendimento <= @DataGeracao                          		  	   

end
