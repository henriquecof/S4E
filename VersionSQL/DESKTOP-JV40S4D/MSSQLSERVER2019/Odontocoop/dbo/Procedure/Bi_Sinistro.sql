/****** Object:  Procedure [dbo].[Bi_Sinistro]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[Bi_Sinistro] AS BEGIN

		DELETE Migracao2019BI..Sinistro

		DECLARE @dt_ini DATETIME
		DECLARE @dt_fim DATETIME

		SET @dt_fim = RIGHT('00' + CONVERT(VARCHAR(2), MONTH(GETDATE())), 2) + '/01/' + CONVERT(VARCHAR(4), YEAR(GETDATE()))
		SET @dt_ini = DATEADD(YEAR, -1, @dt_fim)

		PRINT @dt_ini
		PRINT @dt_fim

		DECLARE @sql VARCHAR(MAX)
		DECLARE @sql1 VARCHAR(MAX)
		DECLARE @sql2 VARCHAR(MAX)

		-- 	Fatura / Vidas / Cortesia /  Corretor /
		--  Sinistro/Comissao/Imposto (16%) e Taxa ADm (10%)
		-- $ Per Capta Class / $ Per Capta Orto / Rent. Med 12 meses / 
		--  Novo Per Capta com Ajuste ANS / Novo Per Capta Sujerido


		SET @sql = '
    insert Migracao2019BI..sinistro (cd_empresa,cd_plano,empresa,plano,ds_empresa,mm_aaaa_1pagamento_empresa,dt_vencimento,
           DT_FECHAMENTO_CONTRATO,MUNICIPIO,tipo_pagamento,SITUACAO,plataforma,qt_tit,qt_dep,qt_cortesia,
           fatura,pago,sinistro,pendente,comissao)
    select a.cd_empresa cd_associado ,x.cd_plano , a.NM_FANTASIA  nm_responsavel, p.nm_plano, e.ds_empresa  , 
           a.mm_aaaa_1pagamento_empresa ,a.dt_vencimento, a.DT_FECHAMENTO_CONTRATO, 
           m.NM_MUNICIPIO , nm_tipo_pagamento,  sh.NM_SITUACAO_HISTORICO  ,isnull(f.nm_empregado,''SEM PLATAFORMA''), 
           
       (select count(0) from associados as a1 , dependentes as d1, historico as h1	, situacao_historico as s1
         where a1.cd_empresa = a.cd_empresa and 
               a1.cd_Associado = d1.cd_Associado and d1.cd_grau_parentesco = 1 and 
               d1.cd_plano = x.cd_plano and 
               d1.cd_sequencial_historico = h1.cd_sequencial and 
               h1.cd_situacao = s1.cd_situacao_historico and 
               s1.fl_atendido_clinica=1 ) as qt_tit, 

       (select count(0) 
          from associados as a1 , 
               dependentes as d1 , historico as h1, situacao_historico as s1, 
               dependentes as d2 , historico as h2 , situacao_historico as s2
         where a1.cd_empresa = a.cd_empresa and 
               a1.cd_associado = d1.cd_Associado and d1.cd_grau_parentesco >= 1 and 
               d1.cd_plano = x.cd_plano and 
               d1.cd_sequencial_historico = h1.cd_sequencial and 
               h1.cd_situacao = s1.cd_situacao_historico and 
               s1.fl_atendido_clinica=1 and 
               a1.cd_associado = d2.cd_Associado and d2.cd_grau_parentesco = 1 and 
               d2.cd_sequencial_historico = h2.cd_sequencial and 
               h2.cd_situacao = s2.cd_situacao_historico and 
               s2.fl_atendido_clinica=1 and 
               d1.CD_SEQUENCIAL <> d2.CD_SEQUENCIAL  ) as qt_dep, 
               
        (select count(0) 
          from associados as a1 , 
               dependentes as d1 , historico as h1, situacao_historico as s1, planos as p1 ,
               dependentes as d2 , historico as h2 , situacao_historico as s2
         where a1.cd_empresa = a.cd_empresa and 
               a1.cd_associado = d1.cd_Associado and d1.cd_grau_parentesco >= 1 and 
               d1.cd_plano = x.cd_plano and 
               d1.cd_plano = p1.cd_plano and p1.fl_cortesia = 1 and 
               d1.cd_sequencial_historico = h1.cd_sequencial and 
               h1.cd_situacao = s1.cd_situacao_historico and 
               s1.fl_atendido_clinica=1 and 
               a1.cd_associado = d2.cd_Associado and d2.cd_grau_parentesco = 1 and 
               d2.cd_sequencial_historico = h2.cd_sequencial and 
               h2.cd_situacao = s2.cd_situacao_historico and 
               s2.fl_atendido_clinica=1 and 
               d1.CD_SEQUENCIAL <> d2.CD_SEQUENCIAL  ) as qt_cortesia,               
               
       -- Colocar o valor total               
       isnull((select SUM(d1.vl_plano) 
          from associados as a1 , dependentes as d1, historico as h1	, situacao_historico as s1
         where a1.cd_empresa = a.cd_empresa and 
               a1.cd_Associado = d1.cd_Associado and d1.cd_grau_parentesco = 1 and 
               d1.cd_plano = x.cd_plano and 
               d1.cd_sequencial_historico = h1.cd_sequencial and 
               h1.cd_situacao = s1.cd_situacao_historico and 
               s1.fl_atendido_clinica=1  ) ,0)
        +  
       isnull((select SUM(d1.vl_plano)
          from associados as a1 , 
               dependentes as d1 , historico as h1, situacao_historico as s1, 
               dependentes as d2 , historico as h2 , situacao_historico as s2
         where a1.cd_empresa = a.cd_empresa and 
               a1.cd_associado = d1.cd_Associado and d1.cd_grau_parentesco >= 1 and 
               d1.cd_plano = x.cd_plano and 
               d1.cd_sequencial_historico = h1.cd_sequencial and 
               h1.cd_situacao = s1.cd_situacao_historico and 
               s1.fl_atendido_clinica=1 and 
               a1.cd_associado = d2.cd_Associado and d2.cd_grau_parentesco = 1 and 
               d2.cd_sequencial_historico = h2.cd_sequencial and 
               h2.cd_situacao = s2.cd_situacao_historico and 
               s2.fl_atendido_clinica=1 and 
               d1.CD_SEQUENCIAL <> d2.CD_SEQUENCIAL  ),0) as vl_fatura  , 
               
    isnull(( 
        select SUM(isnull(t101.valor,0)) -- SUM(isnull(t100.vl_pago,0)) 
          from MENSALIDADES as t100, mensalidades_planos as t101, dependentes as t102
         where t100.CD_ASSOCIADO_empresa = a.CD_EMPRESA and 
               t100.cd_parcela = t101.cd_parcela_mensalidade and 
               t101.cd_sequencial_dep = t102.cd_sequencial and 
               t102.cd_plano = x.cd_plano and 
               t100.TP_ASSOCIADO_EMPRESA in (2,3) and 
               t100.DT_pagamento >= ''' + CONVERT(VARCHAR(10), @dt_ini, 101) + ''' and 
               t100.DT_pagamento <  ''' + CONVERT(VARCHAR(10), @dt_fim, 101) + ''' and 
               t100.CD_TIPO_RECEBIMENTO > 2 and
               t100.DT_PAGAMENTO is not null and 
               t100.cd_tipo_parcela in (1,2,3)
         
      ),0) 
      
      + 
      
      isnull(( 
        select SUM(isnull(t102.valor,0)) -- SUM(isnull(t100.vl_pago,0)) 
          from MENSALIDADES as t100, ASSOCIADOS as t101, mensalidades_planos as t102, dependentes as t103
         where t100.CD_ASSOCIADO_empresa = t101.cd_associado and 
               t101.cd_empresa = a.CD_EMPRESA and 
               t100.cd_parcela = t102.cd_parcela_mensalidade and 
               t102.cd_sequencial_dep = t103.cd_sequencial and 
               t103.cd_plano = x.cd_plano and 
               t100.TP_ASSOCIADO_EMPRESA in (1) and 
               t100.DT_pagamento >= ''' + CONVERT(VARCHAR(10), @dt_ini, 101) + ''' and 
               t100.DT_pagamento <  ''' + CONVERT(VARCHAR(10), @dt_fim, 101) + ''' and 
               t100.CD_TIPO_RECEBIMENTO > 2 and
               t100.DT_PAGAMENTO is not null and 
               t100.cd_tipo_parcela in (1,2,3)  ),0) as vl_pago , '

		SET @sql1 = '   
    	 isnull((
				select sum(isnull(T1.vl_pago_produtividade,0)) as vl_servico
				  from Consultas T1, Servico T2, Filial T3, Funcionario T4, Dependentes T5, Associados T6, -- Empresa T7, 
				       PLANO_SERVICO as ps
				 where T1.cd_servico = T2.cd_servico 
				   and T1.cd_filial = T3.cd_filial 
				   and T1.cd_funcionario = T4.cd_funcionario 
				   and T1.cd_sequencial_dep = T5.cd_sequencial 
				   and T5.cd_associado = T6.cd_associado 
				   and t5.cd_plano = x.cd_plano 
				   and T6.cd_empresa = a.cd_empresa  -- T7.cd_empresa 
				   and T1.dt_cancelamento is null 
				   and T1.status in (3,6,7) 
				   and T1.dt_servico is not null 
				   --and T1.cd_servico in (select cd_servico from Plano_Servico where cd_servico = T1.cd_servico and cd_plano = T5.cd_plano) 
				   and T1.cd_servico = ps.cd_servico 
				   and T5.cd_plano = ps.cd_plano 
				  -- and t7.CD_EMPRESA = a.CD_EMPRESA   
				   and T1.nr_numero_lote is not null
				   and T1.dt_servico >= ''' + CONVERT(VARCHAR(10), @dt_ini, 101) + '''
				   and t1.dt_servico <  ''' + CONVERT(VARCHAR(10), @dt_fim, 101) + ''' ),0)
			 +
			 isnull((
				select sum(isnull(T8.vl_servico,0)) as vl_servico
				  from Consultas T1, Servico T2, Filial T3, Funcionario T4, Dependentes T5, Associados T6,-- Empresa T7, 
				       tabela_servicos T8, PLANO_SERVICO as ps 
				 where T1.cd_servico = T2.cd_servico 
				   and T1.cd_filial = T3.cd_filial 
				   and T1.cd_funcionario = T4.cd_funcionario 
				   and T1.cd_sequencial_dep = T5.cd_sequencial 
				   and T5.cd_associado = T6.cd_associado 
				   and t5.cd_plano = x.cd_plano 
				   and T6.cd_empresa = a.cd_empresa -- T7.cd_empresa 
				   and T1.cd_servico = T8.cd_servico
				   and T4.cd_tabela = T8.cd_tabela
				   and T1.dt_cancelamento is null 
				   and T1.status in (3,6,7) 
				   and T1.dt_servico is not null 
				   --and T1.cd_servico in (select cd_servico from Plano_Servico where cd_servico = T1.cd_servico and cd_plano = T5.cd_plano) 
				   and T1.cd_servico = ps.cd_servico 
				   and T5.cd_plano = ps.cd_plano 
				  -- and t7.CD_EMPRESA = a.CD_EMPRESA   
				   and T1.nr_numero_lote is null
				   and T1.dt_servico >= ''' + CONVERT(VARCHAR(10), @dt_ini, 101) + '''
				   and t1.dt_servico <  ''' + CONVERT(VARCHAR(10), @dt_fim, 101) + ''' ),0)
		 as vl_utilizacao '

		SET @sql2 = '        
		, null as vl_pendente, 
		
		isnull((select round(sum(t1.valor * (t1.perc_pagamento/100)),2)
		   from mensalidades as t4 , mensalidades_planos as t5, comissao_vendedor as t1, dependentes as t2
		  where t4.cd_Associado_empresa = a.cd_empresa and t4.tp_Associado_empresa = 2 and t4.cd_tipo_recebimento > 2 
		    and t4.cd_parcela = t5.cd_parcela_mensalidade 
		    and t5.cd_sequencial = t1.cd_sequencial_mensalidade_planos 
		    and t1.cd_sequencial_dependente = t2.cd_sequencial and t1.cd_sequencial_dependente is not null 
		    and t2.cd_plano = x.cd_plano 
		    and T4.dt_pagamento >= ''' + CONVERT(VARCHAR(10), @dt_ini, 101) + '''
		    and t4.dt_pagamento <  ''' + CONVERT(VARCHAR(10), @dt_fim, 101) + ''' )
		    ,0) as vl_comissao

 from 
 
 --empresa as a, tipo_pagamento as tp , MUNICIPIO as m , tipo_empresa as e , 
 --     HISTORICO as h, SITUACAO_HISTORICO as sh, funcionario as f , 
      
      --(
      --  select x1.cd_empresa, x2.cd_plano 
      --    from associados as x1, dependentes as x2
      --   where x1.cd_associado = x2.cd_associado
      --   group by x1.cd_empresa, x2.cd_plano  
        
      --) as x, planos as p
 Empresa as a 
 inner join Tipo_pagamento as tp on a.cd_tipo_pagamento = tp.cd_tipo_pagamento
 left join Funcionario as f on a.cd_func_vendedor = f.cd_funcionario
 inner join Municipio as m on a.cd_municipio = m.cd_municipio
 inner join Tipo_empresa as e on a.tp_empresa = e.tp_empresa
 inner join Historico as h on a.cd_sequencial_historico = h.cd_sequencial
 inner join (select x1.cd_empresa, x2.cd_plano 
		from associados as x1, dependentes as x2
         where x1.cd_associado = x2.cd_associado
         group by x1.cd_empresa, x2.cd_plano) as x on a.cd_empresa = x.cd_empresa
 inner join Planos as p on x.cd_plano = p.cd_plano
 inner join Situacao_Historico as sh on h.cd_situacao = sh.cd_situacao_historico and sh.cd_situacao_historico not in (2)
where 
	  --a.cd_tipo_pagamento = tp.cd_tipo_pagamento and 
   --   a.cd_func_vendedor *= f.cd_funcionario and 
   --   a.cd_municipio = m.CD_MUNICIPIO  and
   --   a.TP_EMPRESA=e.tp_empresa and 
   --   a.CD_Sequencial_historico=h.cd_sequencial and 
   --   a.cd_empresa = x.cd_empresa and
   --   x.cd_plano = p.cd_plano and 
   --   h.CD_SITUACAO= sh.CD_SITUACAO_HISTORICO and 
      sh.CD_SITUACAO_HISTORICO not in (2) and  
      a.TP_EMPRESA<10'


		SET @sql2 = @sql2 + ' order by 2,3 '

		PRINT @sql
		PRINT @sql1
		PRINT @sql2
		PRINT @dt_fim


		EXEC (@sql + @sql1 + @sql2)

		UPDATE
		Migracao2019BI..Sinistro
		SET mes_contrato = RIGHT(mm_aaaa_1pagamento_empresa, 2)
		   ,imposto = ROUND(pago * 0.16, 2)
		   ,taxaadm = ROUND(pago * 0.1, 2)
		   ,vl_per_capta = ROUND(CASE
				WHEN (qt_tit + qt_dep + qt_cortesia) = 0
				THEN 0
				ELSE fatura / (qt_tit + qt_dep + qt_cortesia) END, 2)
		   ,tempo_contrato = CASE
								WHEN dbo.FS_Idade(DT_FECHAMENTO_CONTRATO, @dt_fim) < 1
								THEN 'Inferior a 1 ano'
								WHEN dbo.FS_Idade(DT_FECHAMENTO_CONTRATO, @dt_fim) < 2
								THEN 'Inferior a 2 anos'
								WHEN dbo.FS_Idade(DT_FECHAMENTO_CONTRATO, @dt_fim) < 3
								THEN 'Inferior a 3 anos'
								WHEN dbo.FS_Idade(DT_FECHAMENTO_CONTRATO, @dt_fim) < 5
								THEN 'Inferior a 5 anos'
								ELSE 'Superior a 5 anos' END

		UPDATE
		Migracao2019BI..Sinistro
		SET Saldo = ROUND(pago - (Sinistro + comissao + imposto + taxaadm), 2)

		UPDATE
		Migracao2019BI..Sinistro
		SET rentabilidade = ROUND(CASE
			WHEN Saldo = 0 OR
				pago = 0
			THEN 0
			ELSE CASE
					WHEN Saldo < 0
					THEN -1
					ELSE 1 END * ABS((Saldo) * 100) / pago END, 2)

		UPDATE
		Migracao2019BI..Sinistro
		SET faixa_vidas = CASE
							 WHEN x.qtde <= 49
							 THEN 'Até 49 vidas'
							 WHEN x.qtde <= 99
							 THEN '50 a 99 vidas'
							 ELSE 'Superior 100 vidas' END
		FROM
		(SELECT
				cd_empresa
			   ,SUM(qt_tit + qt_dep + qt_cortesia) AS qtde
			FROM Migracao2019BI..Sinistro
			GROUP BY cd_empresa) AS x, Migracao2019BI..Sinistro AS si
		WHERE
		si.cd_empresa = x.cd_empresa

		UPDATE
		Migracao2019BI..Sinistro
		SET ds_empresa = 'ORTODONTIA'
		WHERE
		cd_plano IN (SELECT
				cd_plano
			FROM PLANO_SERVICO
			WHERE cd_servico = 86000357)
	END
