/****** Object:  Procedure [dbo].[PS_AcompanhamentoDentista]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[PS_AcompanhamentoDentista]
AS
	Begin
		Begin Transaction

			Declare @dt7atras smalldatetime
			Declare @dt0 smalldatetime
			Declare @dt7 smalldatetime
			Declare @dt14 smalldatetime
			Declare @dt21 smalldatetime

			declare @d_30 smalldatetime
			declare @d_60 smalldatetime
			declare @d_90 smalldatetime
			declare @d_120 smalldatetime
			declare @d_150 smalldatetime
			declare @d_180 smalldatetime
			declare @d_210 smalldatetime
			declare @d_240 smalldatetime
			declare @d_270 smalldatetime
			declare @d_300 smalldatetime
			declare @d_330 smalldatetime
			declare @d_360 smalldatetime

			set @dt7atras = dateadd(day,-7,convert(smalldatetime,convert(varchar(10),getdate(),101)))
			set @dt0 = convert(smalldatetime,convert(varchar(10),getdate(),101))
			set @dt7 = dateadd(day,7,convert(smalldatetime,convert(varchar(10),getdate(),101)))
			set @dt14 = dateadd(day,14,convert(smalldatetime,convert(varchar(10),getdate(),101)))
			set @dt21 = dateadd(day,21,convert(smalldatetime,convert(varchar(10),getdate(),101)))

			set @d_30 = dateadd(day,-30,convert(smalldatetime,convert(varchar(10),getdate(),101)))
			set @d_60 = dateadd(day,-60,convert(smalldatetime,convert(varchar(10),getdate(),101)))
			set @d_90 = dateadd(day,-90,convert(smalldatetime,convert(varchar(10),getdate(),101)))
			set @d_120 = dateadd(day,-120,convert(smalldatetime,convert(varchar(10),getdate(),101)))
			set @d_150 = dateadd(day,-150,convert(smalldatetime,convert(varchar(10),getdate(),101)))
			set @d_180 = dateadd(day,-180,convert(smalldatetime,convert(varchar(10),getdate(),101)))
			set @d_210 = dateadd(day,-210,convert(smalldatetime,convert(varchar(10),getdate(),101)))
			set @d_240 = dateadd(day,-240,convert(smalldatetime,convert(varchar(10),getdate(),101)))
			set @d_270 = dateadd(day,-270,convert(smalldatetime,convert(varchar(10),getdate(),101)))
			set @d_300 = dateadd(day,-300,convert(smalldatetime,convert(varchar(10),getdate(),101)))
			set @d_330 = dateadd(day,-330,convert(smalldatetime,convert(varchar(10),getdate(),101)))
			set @d_360 = dateadd(day,-360,convert(smalldatetime,convert(varchar(10),getdate(),101)))

			--print @d_30 

			delete S4EBI..acompanhamento_dentista
			insert into S4EBI..acompanhamento_dentista

			select distinct f.cd_funcionario, rtrim(f.nm_empregado) as nm_empregado, 
				   rtrim(u.ufDescricao) as nm_uf, u.ufId, rtrim(m.nm_municipio) as nm_municipio, m.cd_municipio, rtrim(b.baiDescricao) as nm_bairro, b.baiId as cd_bairro,
				   fi.NM_Filial, fi.cd_filial, fi.cd_clinica, isnull(convert(int,fi.fl_online),0) as fl_online, 

			-- teto do dentista

			dbo.moeda(isnull((select ff1.vl_faixa from funcionario_faixa as ff1, funcionario as f1 where ff1.cd_faixa = f1.cd_faixa and f1.cd_funcionario = f.cd_funcionario),0)) as teto,

			-- produtividade fechada 360 dias

			dbo.moeda(
				isnull((select sum(vl_parcela)
					from pagamento_dentista 
					where cd_funcionario = f.cd_funcionario
					  and dt_previsao_pagamento>= @d_360 and 
					      dt_previsao_pagamento< @d_330),0 )
						) as prod_fechada_360
			,

isnull((select count(*)
from pagamento_dentista as pd, consultas as c, servico as s
where pd.cd_sequencial = c.nr_numero_lote and
      pd.dt_previsao_pagamento >= @d_360 and pd.dt_previsao_pagamento < @d_330 and
      --c.cd_filial = fi.cd_filial and
      c.cd_servico = s.cd_servico and
      pd.cd_funcionario = f.cd_funcionario 
),0) as Prod_Fechada_Procedimentos_360 ,

-- produtividade fechada 330 dias 

dbo.moeda(
isnull((select sum(vl_parcela)
from pagamento_dentista 
where cd_funcionario = f.cd_funcionario
  and dt_previsao_pagamento>= @d_330 and 
      dt_previsao_pagamento< @d_300),0 )
) as prod_fechada_330

,

isnull((select count(*)
from pagamento_dentista as pd, consultas as c, servico as s
where pd.cd_sequencial = c.nr_numero_lote and
      pd.dt_previsao_pagamento >= @d_330 and pd.dt_previsao_pagamento < @d_300 and
      c.cd_servico = s.cd_servico and
      pd.cd_funcionario = f.cd_funcionario 
),0) as Prod_Fechada_Procedimentos_330 ,

-- produtividade fechada 300 dias 


dbo.moeda(
isnull((select sum(vl_parcela)
from pagamento_dentista 
where cd_funcionario = f.cd_funcionario
  and dt_previsao_pagamento>= @d_300 and 
      dt_previsao_pagamento< @d_270),0 )
) as prod_fechada_300

,

isnull((select count(*)
from pagamento_dentista as pd, consultas as c, servico as s
where pd.cd_sequencial = c.nr_numero_lote and
      pd.dt_previsao_pagamento >= @d_300 and pd.dt_previsao_pagamento < @d_270 and
      c.cd_servico = s.cd_servico and
      pd.cd_funcionario = f.cd_funcionario 
),0) as Prod_Fechada_Procedimentos_300,

-- produtividade fechada 270 dias 

dbo.moeda(
isnull((select sum(vl_parcela)
from pagamento_dentista 
where cd_funcionario = f.cd_funcionario
  and dt_previsao_pagamento>= @d_270 and 
      dt_previsao_pagamento< @d_240),0 )
) as prod_fechada_270

,

isnull((select count(*)
from pagamento_dentista as pd, consultas as c, servico as s
where pd.cd_sequencial = c.nr_numero_lote and
      pd.dt_previsao_pagamento >= @d_270 and pd.dt_previsao_pagamento < @d_240 and
      c.cd_servico = s.cd_servico and
      pd.cd_funcionario = f.cd_funcionario ),0) as Prod_Fechada_Procedimentos_270,

-- produtividade fechada 240 dias 

dbo.moeda(
isnull((select sum(vl_parcela)
from pagamento_dentista 
where cd_funcionario = f.cd_funcionario
  and dt_previsao_pagamento>= @d_240 and 
      dt_previsao_pagamento< @d_210),0 )
) as prod_fechada_240

,

isnull((select count(*)
from pagamento_dentista as pd, consultas as c, servico as s
where pd.cd_sequencial = c.nr_numero_lote and
      pd.dt_previsao_pagamento >= @d_240 and pd.dt_previsao_pagamento < @d_210 and
      c.cd_servico = s.cd_servico and
      pd.cd_funcionario = f.cd_funcionario ),0) as Prod_Fechada_Procedimentos_240,

-- produtividade fechada 210 dias 

dbo.moeda(
isnull((select sum(vl_parcela)
from pagamento_dentista 
where cd_funcionario = f.cd_funcionario
  and dt_previsao_pagamento>= @d_210 and 
      dt_previsao_pagamento< @d_180),0 )
) as prod_fechada_210

,

isnull((select count(*)
from pagamento_dentista as pd, consultas as c, servico as s
where pd.cd_sequencial = c.nr_numero_lote and
      pd.dt_previsao_pagamento >= @d_210 and pd.dt_previsao_pagamento < @d_180 and
      c.cd_servico = s.cd_servico and
      pd.cd_funcionario = f.cd_funcionario ),0) as Prod_Fechada_Procedimentos_210,

-- produtividade fechada 180 dias 

dbo.moeda(
isnull((select sum(vl_parcela)
from pagamento_dentista 
where cd_funcionario = f.cd_funcionario
  and dt_previsao_pagamento>= @d_180 and 
      dt_previsao_pagamento< @d_150),0 )
) as prod_fechada_180

,

isnull((select count(*)
from pagamento_dentista as pd, consultas as c, servico as s
where pd.cd_sequencial = c.nr_numero_lote and
      pd.dt_previsao_pagamento >= @d_180 and pd.dt_previsao_pagamento < @d_150 and
      c.cd_servico = s.cd_servico and
      pd.cd_funcionario = f.cd_funcionario ),0) as Prod_Fechada_Procedimentos_180,

-- produtividade fechada 150 dias 

dbo.moeda(
isnull((select sum(vl_parcela)
from pagamento_dentista 
where cd_funcionario = f.cd_funcionario
  and dt_previsao_pagamento>= @d_150 and 
      dt_previsao_pagamento< @d_120),0 )
) as prod_fechada_150

,

isnull((select count(*)
from pagamento_dentista as pd, consultas as c, servico as s
where pd.cd_sequencial = c.nr_numero_lote and
      pd.dt_previsao_pagamento >= @d_150 and pd.dt_previsao_pagamento < @d_120 and
      c.cd_servico = s.cd_servico and
      pd.cd_funcionario = f.cd_funcionario ),0) as Prod_Fechada_Procedimentos_150,


-- produtividade fechada 120 dias 

dbo.moeda(
isnull((select sum(vl_parcela)
from pagamento_dentista 
where cd_funcionario = f.cd_funcionario
  and dt_previsao_pagamento>= @d_120 and 
      dt_previsao_pagamento< @d_90),0 )
) as prod_fechada_120

,

isnull((select count(*)
from pagamento_dentista as pd, consultas as c, servico as s
where pd.cd_sequencial = c.nr_numero_lote and
      pd.dt_previsao_pagamento >= @d_120 and pd.dt_previsao_pagamento < @d_90 and
      c.cd_servico = s.cd_servico and
      pd.cd_funcionario = f.cd_funcionario ),0) as Prod_Fechada_Procedimentos_120,

-- produtividade fechada 90 dias 

dbo.moeda(
isnull((select sum(vl_parcela)
from pagamento_dentista 
where cd_funcionario = f.cd_funcionario
  and dt_previsao_pagamento>= @d_90 and 
      dt_previsao_pagamento< @d_60),0 )
) as prod_fechada_90

,

isnull((select count(*)
from pagamento_dentista as pd, consultas as c, servico as s
where pd.cd_sequencial = c.nr_numero_lote and
      pd.dt_previsao_pagamento >= @d_90 and pd.dt_previsao_pagamento < @d_60 and
      c.cd_servico = s.cd_servico and
      pd.cd_funcionario = f.cd_funcionario ),0) as Prod_Fechada_Procedimentos_90,

-- produtividade fechada 60 dias 

dbo.moeda(
isnull((select sum(vl_parcela)
from pagamento_dentista 
where cd_funcionario = f.cd_funcionario
  and dt_previsao_pagamento>= @d_60 and 
      dt_previsao_pagamento< @d_30),0 )
) as prod_fechada_60

,

isnull((select count(*)
from pagamento_dentista as pd, consultas as c, servico as s
where pd.cd_sequencial = c.nr_numero_lote and
      pd.dt_previsao_pagamento >= @d_60 and pd.dt_previsao_pagamento < @d_30 and
      c.cd_servico = s.cd_servico and
      pd.cd_funcionario = f.cd_funcionario ),0) as Prod_Fechada_Procedimentos_60,

-- produtividade fechada 30 dias 

dbo.moeda(
isnull((select sum(vl_parcela)
from pagamento_dentista 
where cd_funcionario = f.cd_funcionario
  and dt_previsao_pagamento>= @d_30 and 
      dt_previsao_pagamento< @dt0),0 )
) as prod_fechada_30

,

isnull((select count(*)
from pagamento_dentista as pd, consultas as c, servico as s
where pd.cd_sequencial = c.nr_numero_lote and
      pd.dt_previsao_pagamento >= @d_30 and pd.dt_previsao_pagamento < @dt0 and
      c.cd_servico = s.cd_servico and
      pd.cd_funcionario = f.cd_funcionario ),0) as Prod_Fechada_Procedimentos_30 ,


			-- produtividade em andamento

	dbo.moeda(isnull((Select sum(T4.vl_servico)
	From filial as T1, consultas as T2, servico as T3, tabela_servicos as T4, 
	associados as T5, dependentes as T6, funcionario as T7, funcionario_faixa as T8 
	Where T1.cd_filial = T2.cd_filial 
	and T1.cd_filial <> 657 
	and T2.cd_funcionario = T7.cd_funcionario 
	and T2.dt_servico is not null 
	and T2.dt_cancelamento is null 
	and T2.cd_servico = T3.cd_servico 
	and T2.cd_sequencial_dep = T6.cd_sequencial 
	--and T7.cd_filial = T4.cd_filial 
	and T2.cd_servico = T4.cd_servico 
	and T7.cd_tabela = T4.cd_tabela 
	--and T5.cd_tipo_pagamento = T4.cd_tipo_pagamento 
	and T5.cd_associado = T6.cd_associado 
	and T2.cd_sequencial_dep = T6.cd_sequencial 
	and T7.cd_faixa = T8.cd_faixa 
	and T2.cd_sequencial not in (Select cd_sequencial from TB_ConsultasGlosados t100 where T100.cd_sequencial = T2.cd_sequencial) 
	and T2.cd_sequencial not in (Select cd_sequencial_pp from orcamento_servico t100 where T100.cd_sequencial_pp = T2.cd_sequencial) 
	and T4.vl_servico > 0 
	and T1.fl_ativa = 1 
	--and T2.nr_guia is null 
	and T2.NR_Numero_Lote Is null 
	and T2.cd_funcionario = f.cd_funcionario
	and T2.cd_filial = fi.cd_filial),0)
	+
	isnull((Select
	sum(Case T8.tipo When 1 Then T4.vl_servico When 2 Then 0 End)
	From filial as T1, consultas as T2, servico as T3, tabela_servicos as T4, 
	associados as T5, dependentes as T6, funcionario as T7, 
	TB_ConsultasGlosados as T8, funcionario_faixa as T9 
	Where T1.cd_filial = T2.cd_filial 
	and T1.cd_filial <> 657 
	and T2.cd_funcionario = T7.cd_funcionario 
	and T2.dt_servico is not null 
	and T2.dt_cancelamento is null 
	and T2.cd_servico = T3.cd_servico 
	--and T2.cd_associado = T5.cd_associado 
	--and T7.cd_empresa = T4.cd_filial 
	and T2.cd_servico = T4.cd_servico 
	and T7.cd_tabela = T4.cd_tabela 
	--and T5.cd_tipo_pagamento = T4.cd_tipo_pagamento 
	and T5.cd_associado = T6.cd_associado 
	and T2.cd_sequencial_dep = T6.cd_sequencial 
	and T2.cd_sequencial = T8.cd_sequencial 
	and T2.cd_sequencial = T8.cd_sequencial 
	and T7.cd_faixa = T9.cd_faixa 
	and T1.fl_ativa = 1 
	--and T2.nr_guia is null 
	and T2.NR_Numero_Lote Is null 
	and T2.cd_sequencial not in (Select cd_sequencial_pp from orcamento_servico t100 where T100.cd_sequencial_pp = T2.cd_sequencial)
	and T2.cd_funcionario = f.cd_funcionario
	and T2.cd_filial = fi.cd_filial),0)) as prod_aberta,
		  
			-- produtividade em andamento (procedimentos)

	isnull((Select count(0)
	From filial as T1, consultas as T2, servico as T3, tabela_servicos as T4, 
	associados as T5, dependentes as T6, funcionario as T7, funcionario_faixa as T8 
	Where T1.cd_filial = T2.cd_filial 
	and T1.cd_filial <> 657 
	and T2.cd_funcionario = T7.cd_funcionario 
	and T2.dt_servico is not null 
	and T2.dt_cancelamento is null 
	and T2.cd_servico = T3.cd_servico 
	--and T2.cd_associado = T5.cd_associado 
	--and T7.cd_empresa = T4.cd_filial 
	and T2.cd_servico = T4.cd_servico 
	and T7.cd_tabela = T4.cd_tabela  
	--and T5.cd_tipo_pagamento = T4.cd_tipo_pagamento 
	and T5.cd_associado = T6.cd_associado 
	and T2.cd_sequencial_dep = T6.cd_sequencial 
	and T7.cd_faixa = T8.cd_faixa 
	and T2.cd_sequencial not in (Select cd_sequencial from TB_ConsultasGlosados t100 where T100.cd_sequencial = T2.cd_sequencial) 
	and T2.cd_sequencial not in (Select cd_sequencial_pp from orcamento_servico t100 where T100.cd_sequencial_pp = T2.cd_sequencial) 
	and T4.vl_servico > 0 
	and T1.fl_ativa = 1 
	--and T2.nr_guia is null 
	and T2.NR_Numero_Lote Is null 
	and T2.cd_funcionario = f.cd_funcionario
	and T2.cd_filial = fi.cd_filial),0)
	+
	isnull((Select
	count(0)
	From filial as T1, consultas as T2, servico as T3, tabela_servicos as T4, 
	associados as T5, dependentes as T6, funcionario as T7, 
	TB_ConsultasGlosados as T8, funcionario_faixa as T9 
	Where T1.cd_filial = T2.cd_filial 
	and T1.cd_filial <> 657 
	and T2.cd_funcionario = T7.cd_funcionario 
	and T2.dt_servico is not null 
	and T2.dt_cancelamento is null 
	and T2.cd_servico = T3.cd_servico 
	--and T2.cd_associado = T5.cd_associado 
	--and T7.cd_filial = T4.cd_filial 
	and T2.cd_servico = T4.cd_servico 
	and T7.cd_tabela = T4.cd_tabela  
	--and T5.cd_tipo_pagamento = T4.cd_tipo_pagamento 
	and T5.cd_associado = T6.cd_associado 
	and T2.cd_sequencial_dep = T6.cd_sequencial 
	and T2.cd_sequencial = T8.cd_sequencial 
	and T2.cd_sequencial = T8.cd_sequencial 
	and T7.cd_faixa = T9.cd_faixa 
	and T1.fl_ativa = 1 
	--and T2.nr_guia is null 
	and T2.NR_Numero_Lote Is null 
	and T2.cd_sequencial not in (Select cd_sequencial_pp from orcamento_servico t100 where T100.cd_sequencial_pp = T2.cd_sequencial)
	and T2.cd_funcionario = f.cd_funcionario
	and T2.cd_filial = fi.cd_filial),0) as Prod_Aberta_Procedimentos,

			-- Marcacao Esperada

			(select count(*) 
			  from agenda as T1
			 where t1.cd_funcionario = f.cd_funcionario and 
				   t1.cd_filial = fi.cd_filial and 
				   t1.dt_compromisso >= @dt0 and t1.dt_compromisso <= @dt7) as esperado, 

			-- Agenda 7 dias atrás

			(select count(*)
			  from agenda as T1
			 where t1.cd_funcionario = f.cd_funcionario and 
				   t1.cd_filial = fi.cd_filial and 
				   t1.cd_Associado is not null and 
				   t1.dt_compromisso >= @dt7atras and t1.dt_compromisso < @dt0) as atras7, 

			-- Faltas 7 dias atrás

			(select count(*)
			  from agenda as T1, consultas as T2
			 where t1.cd_funcionario = f.cd_funcionario and 
				   t1.cd_filial = fi.cd_filial and
				   t1.cd_sequencial = t2.cd_sequencial_agenda and
				   t1.cd_Associado is not null and 
                   t2.cd_servico in (140,618) and
				   t1.dt_compromisso >= @dt7atras and t1.dt_compromisso < @dt0) as faltas7,

			-- Agenda ate 7 dias

			(select count(*) 
			  from agenda as T1
			 where t1.cd_funcionario = f.cd_funcionario and 
				   t1.cd_filial = fi.cd_filial and 
				   t1.cd_Associado is not null and 
				   t1.dt_compromisso >= @dt0 and t1.dt_compromisso <= @dt7) as ate7, 


			-- Agenda maior que 7 e ate 14 dias

			(select count(*) 
			  from agenda as T1
			 where t1.cd_funcionario = f.cd_funcionario and 
				   t1.cd_filial = fi.cd_filial and 
				   t1.cd_Associado is not null and 
				   t1.dt_compromisso > @dt7 and t1.dt_compromisso <= @dt14) as ate14, 

			-- Agenda maior que 14 e ate 21 dias

			(select count(*) 
			  from agenda as T1
			 where t1.cd_funcionario = f.cd_funcionario and 
				   t1.cd_filial = fi.cd_filial and 
				   t1.cd_Associado is not null and 
				   t1.dt_compromisso > @dt14 and t1.dt_compromisso <= @dt21) as ate21, 

			-- Agenda maior que 21 dias

			(select count(*) 
			  from agenda as T1
			 where t1.cd_funcionario = f.cd_funcionario and 
				   t1.cd_filial = fi.cd_filial and 
				   t1.cd_Associado is not null and 
				   t1.dt_compromisso > @dt21 ) as maior21 ,


           -- numero de associados em tratamento (
			isnull((select  count(distinct convert(varchar(10),t6.cd_associado) + convert(varchar(5),t2.cd_sequencial_dep)) 
 			From filial as T1, consultas as T2 , -- servico as T3, tabela_servicos as T4, 
                 associados as T5, dependentes as T6 --, funcionario as T7, empresa as T8  
			Where T1.cd_filial = T2.cd_filial  and 
				  t1.cd_filial <> 657  and 
--				  T2.cd_funcionario = T7.cd_funcionario  and 
				  T2.dt_servico is not null  and 
				  T2.dt_cancelamento is null  and 
--				  T2.cd_servico = T3.cd_servico  and 
				  --T2.cd_associado = T5.cd_associado  and 
--				  T7.cd_empresa = T4.cd_filial  and 
--				  T2.cd_servico = T4.cd_servico  and 
--				  T5.cd_tipo_pagamento = T4.cd_tipo_pagamento  and 
				  T5.cd_associado = T6.cd_associado  and 
				  T2.cd_sequencial_dep = T6.cd_sequencial  and 
--				  T5.cd_empresa = T8.cd_empresa  and 
				  T2.cd_sequencial not in (Select cd_sequencial from TB_ConsultasGlosados t100 where t100.cd_sequencial = t2.cd_sequencial)  and 
--				  T4.vl_credenciado > 0  and 
                  --T5.cd_situacao in (select cd_situacao_historico from situacao_historico where fl_atendido_clinica=1) and 
                  T6.cd_situacao in (select cd_situacao_historico from situacao_historico where fl_atendido_clinica=1) and 
				  T1.fl_ativa = 1  and 
				  --T2.nr_guia is null  and 
				  T2.NR_Numero_Lote Is null  and 
				  T2.cd_filial = fi.cd_filial ),0)
			+
		isnull((select count(distinct convert(varchar(10),t6.cd_associado) + convert(varchar(5),t2.cd_sequencial_dep)) 
		   From filial as T1, consultas as T2, -- , servico as T3, tabela_servicos as T4,  
                associados as T5, dependentes as T6, 
				--funcionario as T7,  
                TB_ConsultasGlosados T8
                --,empresa T9  
		   Where T1.cd_filial = T2.cd_filial  and 
				 t1.cd_filial <> 657  and 
				 --T2.cd_funcionario = T7.cd_funcionario  and 
				 T2.dt_servico is not null  and 
				 T2.dt_cancelamento is null  and 
				 --T2.cd_servico = T3.cd_servico  and 
				 --T2.cd_associado = T5.cd_associado  and 
				 --T7.cd_empresa = T4.cd_filial  and 
				 --T2.cd_servico = T4.cd_servico  and 
				 --T5.cd_tipo_pagamento = T4.cd_tipo_pagamento  and 
				 T6.cd_associado = T6.cd_associado  and 
				 T2.cd_sequencial_dep = T6.cd_sequencial  and 
				 t2.cd_sequencial = t8.cd_sequencial  and 

                 --T5.cd_situacao in (select cd_situacao_historico from situacao_historico where fl_atendido_clinica=1) and 
                 T6.cd_situacao in (select cd_situacao_historico from situacao_historico where fl_atendido_clinica=1) and 

				 --T5.cd_empresa = T9.cd_empresa  and 
				 --T4.vl_credenciado > 0  and 

				 T1.fl_ativa = 1  and 
				 --T2.nr_guia is null  and 
				 T2.NR_Numero_Lote Is null  and 
				 T2.cd_filial = fi.cd_filial),0)

			as Associados_EmAberto,

		-- usuários da produtividade fechada 30 dias
		isnull((select count(distinct convert(varchar(10),c.cd_sequencial_dep) + convert(varchar(5),c.cd_sequencial_dep))
		from pagamento_dentista as pd, consultas as c, servico as s
		where pd.cd_sequencial = c.nr_numero_lote and
			  pd.dt_previsao_pagamento >= @d_30 and pd.dt_previsao_pagamento < @dt0 and
			  c.cd_servico = s.cd_servico and
			  pd.cd_funcionario = f.cd_funcionario and
			  pd.cd_funcionario in (select f2.cd_funcionario
									--from funcionario f2, atuacao_dentista_new ad2, filial fi2, municipio m2, uf u2
									from funcionario f2, atuacao_dentista ad2, filial fi2, municipio m2, uf u2
									where f2.cd_funcionario = ad2.cd_funcionario and
										  ad2.cd_filial = fi2.cd_filial and
										  fi2.CidID = m2.CD_MUNICIPIO and
										  m2.CD_UF_num = u2.ufId and
										  f2.cd_cargo in (30,32) and
										  f2.cd_situacao in (1,3) and
										  ad2.fl_ativo = 1 and
										  fi2.fl_ativa = 1 /*and
										  fi2.cd_clinica = 2*/)),0) as Associados_Fechada30,

		--Consultas marcadas nos últimos 7 dias (data de marcação)
			(
				select count(0)
				from agenda
				where cd_funcionario = f.cd_funcionario
				and cd_filial = fi.cd_filial
				and cd_associado is not null
				and cd_sequencial_dep is not null
				and dt_marcado >= dateadd(day,-7,convert(varchar(10),getdate(),101))
			) as ConsultasMarcadasUltimos7Dias,

		--Baixas realizadas nos últimos 7 dias
			(
				select count(0)
				from consultas
				where cd_funcionario = f.cd_funcionario
				and cd_filial = fi.cd_filial
				and dt_cancelamento is null
				and dt_baixa >= dateadd(day,-7,convert(varchar(10),getdate(),101))
			) as ProcedimentosBaixadosUltimos7Dias
		
			--from funcionario f, atuacao_dentista_new ad, filial fi, municipio m, uf u  
			from funcionario f, atuacao_dentista ad, filial fi, municipio m, uf u , Bairro b
			where f.cd_funcionario = ad.cd_funcionario  and 
				  ad.cd_filial = fi.cd_filial  and 
				  fi.CidID = m.cd_municipio  and 
				  m.CD_UF_num = u.ufId   and 
				  fi.baiId = b.baiId   and 
				  f.cd_cargo in (30,32) and 
				  f.cd_situacao in (1,3)       and 
				  ad.fl_ativo = 1       and 
				  fi.fl_ativa = 1 

--			order by u.nm_uf, m.nm_municipio, fi.nm_bairro, f.nm_empregado

		Commit Transaction

        ------------------------------------------------------------------------------------
        ---- Tirar do acompanhamento os dentistas que não têm produtividade a dois meses
        ---- Mandar email com relação  
        ------------------------------------------------------------------------------------
         Declare @sequencial int
		 Declare @cd_funcionario int
		 Declare @nm_empregado varchar(100)
		 Declare @nm_uf varchar(100)
		 Declare @nm_municipio varchar(100)
		 Declare @nm_bairro varchar(100) 
		 Declare @nm_filial varchar(100) 
		 Declare @cd_clinica smallint
         Declare @Aviso as varchar(max)

        DECLARE cursor_dados CURSOR FOR 
        Select sequencial, cd_funcionario, nm_empregado, nm_uf, nm_municipio, 
               nm_bairro, nm_filial, cd_clinica
          From S4EBI..acompanhamento_dentista
          Where prod_fechada_procedimentos1 =0 and prod_fechada_procedimentos2 = 0 and 
                prod_aberta_procedimentos = 0 and 
                cd_funcionario not in (select cd_funcionario from funcionario_especialidade where cd_especialidade=4)
        order by nm_empregado

         Set @Aviso = '<table border=1 style="font-size: 13px; color: #000000; font-family: Tahoma, Verdana; text-align: left;">'
         Set @Aviso = @Aviso + '<tr><td><b>Dentista</b></td><td><b>Tipo</b></td><td><b>Filial</b></td><td><b>Localização</b></td>'
         OPEN cursor_dados
         FETCH NEXT FROM cursor_dados 
         INTO @sequencial, @cd_funcionario, @nm_empregado, @nm_uf, @nm_municipio, 
              @nm_bairro, @nm_filial, @cd_clinica
         WHILE (@@FETCH_STATUS <> -1)
         BEGIN
            if @cd_clinica = 2
               Begin
                   Set @Aviso = @Aviso + '<tr><td>' + convert(varchar,@cd_funcionario) + ' ' + @nm_empregado + '</td>'
                   Set @Aviso = @Aviso + '<td>credenciado</td>'
                   Set @Aviso = @Aviso + '<td>' + @nm_filial + '</td>'
                   Set @Aviso = @Aviso + '<td>' + isnull(@nm_bairro,'') + ' - ' + isnull(@nm_municipio,'') + ' - ' + isnull(@nm_uf,'') + '</td></tr>'
               End
            else
               Begin
                   Set @Aviso = @Aviso + '<tr><td>' + convert(varchar,@cd_funcionario) + ' ' + @nm_empregado + '</td>'
                   Set @Aviso = @Aviso + '<td>interno</td>'
                   Set @Aviso = @Aviso + '<td>' + @nm_filial + '</td>'
                   Set @Aviso = @Aviso + '<td>' + isnull(@nm_bairro,'') + ' - ' + isnull(@nm_municipio,'') + ' - ' + isnull(@nm_uf,'') + '</td></tr>'
               End

             Delete from S4EBI..acompanhamento_dentista
             where sequencial = @sequencial
 
--             if Len(@Aviso) > 7500
--                Begin 
--                    Set @Aviso = @Aviso + '<table>'
--         
--                    Execute PS_EnviaEmail 'portal@absonline.com.br', 'marcio.nogueira@absonline.com.br', '', '', 'Dentista sem produção nos ultimos dois meses', @Aviso, 0
--
--                    Set @Aviso = '<table border=1 style="font-size: 13px; color: #000000; font-family: Tahoma, Verdana; text-align: left;">'
--                    Set @Aviso = @Aviso + '<tr><td><b>Dentista</b></td><td><b>Tipo</b></td><td><b>Filial</b></td><td><b>Localização</b></td>'
--        
--                End

         
             FETCH NEXT FROM cursor_dados 
             INTO @sequencial, @cd_funcionario, @nm_empregado, @nm_uf, @nm_municipio, 
                @nm_bairro, @nm_filial, @cd_clinica
        
          END 
          
         Close  cursor_dados
         DEALLOCATE cursor_dados
     
         --if @Aviso != '<table border=1 style="font-size: 13px; color: #000000; font-family: Tahoma, Verdana; text-align: left;"><tr><td><b>Dentista</b></td><td><b>Tipo</b></td><td><b>Filial</b></td><td><b>Localização</b></td>'
             --Begin
               Set @Aviso = @Aviso + '</table>'
               execute PS_EnviaEmail 'portal@absonline.com.br', 'emanuel@absonline.com.br', '', '', 'Dentista sem produção nos ultimos dois meses', @Aviso, 0
             --End  
 
	End
