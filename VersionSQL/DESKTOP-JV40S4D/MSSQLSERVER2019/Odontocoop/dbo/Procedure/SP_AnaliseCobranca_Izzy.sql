/****** Object:  Procedure [dbo].[SP_AnaliseCobranca_Izzy]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[SP_AnaliseCobranca_Izzy] (
	@acao SMALLINT = 0,
	@cd_situacao INT = 0
	)
AS
BEGIN
	DECLARE @linha VARCHAR(8000) = ''

	IF @acao = 1
	BEGIN
		IF EXISTS (
				SELECT *
				FROM sys.objects
				WHERE object_id = OBJECT_ID(N'[dbo].[MensalidadeResumo]')
					AND type IN (N'U')
				)
			DROP TABLE MensalidadeResumo

		CREATE TABLE MensalidadeResumo (
			codigo INT,
			tipo SMALLINT,
			dias INT NOT NULL,
			situacao INT NOT NULL,
			cd_seqdep INT,
			qtde MONEY,
			valor MONEY,
			uso MONEY,
			vl_totalplano MONEY,
			dt_asscto DATETIME,
			dt_venccto DATETIME,
			nr_contrato VARCHAR(20),
			dt_nascimento DATETIME,
			cpf VARCHAR(11),
			vl_plano MONEY,
			qt_meses INT,
			qtde_abertas INT CONSTRAINT [PK_MensalidadeResumo_1] PRIMARY KEY NONCLUSTERED (
				Codigo ASC,
				tipo ASC
				)
			)

		SET @linha = @linha + 
			'insert into MensalidadeResumo 
			select m.cd_Associado_empresa , m.tp_associado_empresa , datediff(day,min(m.dt_vencimento),getdate()), h.CD_SITUACAO, null , null , null , null , null, null,null,null,null,null,null,null ,
		
			(
	
			  select count(0) 
				from mensalidades as m1 
			   where m1.cd_Associado_empresa = m.cd_Associado_empresa
				 and m1.tp_Associado_empresa in (2,3) 
				 and m1.cd_tipo_parcela in (1,5)
				 and m1.vl_parcela > 0
				 and m1.cd_tipo_recebimento = 0 
				 and case when m1.dt_vencimento_new IS null then m1.dt_vencimento else m1.dt_vencimento_new end <= dateadd(day,-5,getdate())
			
			)
			
		  from mensalidades as m, empresa as e, historico as h 
		 where m.cd_tipo_recebimento=0 
		 and dateadd(day,
		 isnull(e.dias_tolerancia_atendimento,0),
		 case when m.dt_vencimento_new IS null 
		 then m.dt_vencimento 
		 else m.dt_vencimento_new end)<=GETDATE() 
		 and m.TP_ASSOCIADO_EMPRESA in (2,3) and 
			   m.cd_Associado_empresa = e.CD_EMPRESA and e.CD_Sequencial_historico = h.cd_sequencial and m.vl_parcela > 0 
		group by m.cd_Associado_empresa , m.tp_associado_empresa, h.CD_SITUACAO '

		EXEC (@linha)

		SET @linha = 'insert into MensalidadeResumo '
	END

	SET @linha = @linha + 
		'select m.cd_Associado_empresa , m.tp_associado_empresa , datediff(day,min(case when m.dt_vencimento_new IS null then m.dt_vencimento else m.dt_vencimento_new end),getdate()) as dias_atraso, h.CD_SITUACAO, e.cd_sequencial , 
	
	(select isnull(count(0),0) as x_qtde_parcelaspagas
	   from mensalidades as m1 
	  where m1.cd_associado_empresa = m.cd_Associado_empresa and 
			m1.tp_associado_empresa = 1 and 
			m1.cd_tipo_recebimento>2 and 
			m1.cd_tipo_parcela in (1) --and 
			--m1.DT_VENCIMENTO>= DATEADD(year,-2,getdate())
			) as qtde_parcelaspagas,
	        
	(select isnull(SUM(m1.VL_PARCELA),0) as x_valorparcelaspagas
	   from mensalidades as m1 
	  where m1.cd_associado_empresa = m.cd_Associado_empresa and 
			m1.tp_associado_empresa = 1 and 
			m1.cd_tipo_recebimento>2 and 
			m1.cd_tipo_parcela in (1,5)-- and 
			--m1.DT_VENCIMENTO>= DATEADD(year,-2,getdate())
			) as valorparcelaspagas ,

	--(
	--select isnull(sum(isnull(ts.vl_servico,0)),0) as x_uso 
	--   from associados as a , dependentes as d,  empresa as e, tipo_pagamento as t,  consultas as c ,tabela_servicos as ts , SERVICO as s
	--  where m.cd_Associado_empresa = a.cd_Associado and 
	--		a.cd_associado = d.cd_associado and  
	--		a.cd_empresa = e.cd_empresa and 
	--		e.cd_tipo_pagamento = t.cd_tipo_pagamento and 
	--		t.cd_tabela = ts.cd_tabela and 
	--		c.cd_sequencial_dep = d.cd_sequencial and
	--		c.cd_servico = ts.cd_servico and 
	--		ts.cd_servico in (select ps.cd_servico from plano_Servico as ps where ps.cd_plano = d.cd_plano) and 
	--		--c.dt_servico >= DATEADD(year,-2,getdate()) and 
	--		c.dt_cancelamento is null and
	--		c.dt_servico is not null and 
	--		c.status in (3,6,7) and 
	--		c.cd_servico = s.cd_servico 

	--) 
	0 as valoruso, 
	
	emp.qt_vigencia * (
	    Select isnull(sum(d1.vl_plano),0) as x_valorplano
	      from dependentes as d1 , historico as h1 
	     where m.cd_Associado_empresa = d1.cd_Associado and 
	           d1.cd_sequencial_historico = h1.cd_sequencial and 
	           h1.cd_situacao not in (2,3)
	) as valortotalplano, 
	                
    e.dt_assinaturacontrato , 
    dateadd(month,isnull(emp.qt_vigencia,12),isnull(e.dt_assinaturacontrato,getdate())) as dt_fimcontrato, 
    a.nr_Contrato, 
    e.dt_nascimento, 
    a.nr_cpf ,

   (    Select isnull(sum(d1.vl_plano),0) as x_valorplano
	      from dependentes as d1 , historico as h1 
	     where m.cd_Associado_empresa = d1.cd_Associado and 
	           d1.cd_sequencial_historico = h1.cd_sequencial and 
	           h1.cd_situacao not in (2,3)
	) as valor_plano , 
	
	emp.qt_vigencia,
	
	(
	
	  select count(0) 
	    from mensalidades as m1 
	   where m1.cd_Associado_empresa = m.cd_Associado_empresa
	     and m1.tp_Associado_empresa = 1 
	     and m1.cd_tipo_parcela in (1,5)
	     and m1.vl_parcela > 0
	     and m1.cd_tipo_recebimento = 0 
	     and case when m1.dt_vencimento_new IS null then m1.dt_vencimento else m1.dt_vencimento_new end <= dateadd(day,-10,getdate())
	
	)

	  from mensalidades as m, ASSOCIADOS as a, dependentes as e, historico as h  , empresa as emp 
  
	 where m.cd_tipo_recebimento=0 and dateadd(day,isnull(emp.dias_tolerancia_atendimento,0),case when m.dt_vencimento_new IS null then m.dt_vencimento else m.dt_vencimento_new end)<=GETDATE() and m.TP_ASSOCIADO_EMPRESA in (1) and 
		   m.cd_Associado_empresa = a.cd_associado and 
		   a.cd_associado=e.CD_ASSOCIADO and e.CD_GRAU_PARENTESCO=1 and 
		   e.CD_Sequencial_historico = h.cd_sequencial and 
		   a.cd_empresa = emp.cd_empresa and
		   m.cd_tipo_parcela in (1,5) and     
		   m.vl_parcela > 0 '

	IF @cd_situacao > 0
		SET @linha = @linha + ' and h.cd_situacao = ' + CONVERT(VARCHAR(10), @cd_situacao)
	ELSE
		SET @linha = @linha + ' and h.cd_situacao not in (2,3) '

	SET @linha = @linha + ' and m.cd_Associado_empresa not in (select TT1.cd_associado from dependentes TT1, historico TT2, situacao_historico TT3 where TT1.cd_sequencial_historico = TT2.cd_sequencial and TT2.cd_situacao = TT3.cd_situacao_historico and TT1.cd_grau_parentesco = 1 and TT3.fl_gera_cobranca = 1 group by TT1.cd_associado having count(0) > 1) '
	SET @linha = @linha + ' group by m.cd_Associado_empresa , m.tp_associado_empresa, e.cd_sequencial, h.CD_SITUACAO  , emp.qt_vigencia,e.dt_assinaturacontrato, a.nr_Contrato, e.dt_nascimento, a.nr_cpf  '

	PRINT @linha

	EXEC (@linha)

	IF @acao = 1
	BEGIN
		SET @linha = 
			'update mensalidaderesumo
		   set mensalidaderesumo.uso =  resumo.uso 
		  from (   select m.codigo , sum(isnull(ts.vl_servico,0)) as uso 
					 from mensalidaderesumo as m, associados as a , dependentes as d,  empresa as e, tipo_pagamento as t,  
						  consultas as c ,tabela_servicos as ts , SERVICO as s
					where m.codigo = a.cd_Associado and 
    					  a.cd_associado = d.cd_associado and  
						  a.cd_empresa = e.cd_empresa and 
						  e.cd_tipo_pagamento = t.cd_tipo_pagamento and 
						  d.cd_sequencial = c.cd_sequencial_dep and
						  c.cd_servico = s.cd_servico and 
				
						  t.cd_tabela = ts.cd_tabela and 
						  s.cd_servico = ts.cd_servico and 
						  ts.vl_servico > 0 and 
				
						  ts.cd_servico in (select ps.cd_servico from plano_Servico as ps where ps.cd_plano = d.cd_plano) and 
				
						  c.status in (3,6,7) and 
						  c.dt_servico is not null and 
   						  c.dt_cancelamento is null and
				
						  m.tipo=1
					group by m.codigo ) as resumo 
		where mensalidaderesumo.codigo = resumo.codigo '

		PRINT @linha

		EXEC (@linha)
	END
END
