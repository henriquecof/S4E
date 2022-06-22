/****** Object:  Procedure [dbo].[SP_Reajuste_PlanoContinuidade]    Committed by VersionSQL https://www.versionsql.com ******/

create Procedure [dbo].[SP_Reajuste_PlanoContinuidade]
as
Begin

	Declare @cd int = null 
	select @cd = ds_procedure from Processos where cd_processo=20
	if @cd is not null
	begin 

	   update DEPENDENTES 
		  set vl_plano = x.new_vl,executarTrigger=0
		 from (
	   select d_u.CD_SEQUENCIAL, d_u.cd_plano, d_u.vl_plano, d_u.CD_GRAU_PARENTESCO, 
			  case when d_u.CD_GRAU_PARENTESCO=1 then pp.vl_tit when d_u.CD_GRAU_PARENTESCO=10 then pp.vl_agregado else pp.vl_dep end as new_vl, 
			  a.cd_empresa
		 from DEPENDENTES as d inner join HISTORICO as h on d.CD_Sequencial_historico=h.cd_sequencial and d.CD_GRAU_PARENTESCO=1
				 inner join ASSOCIADOS as a on d.CD_ASSOCIADO = a.cd_associado
				 inner join empresa as e on a.cd_empresa = e.cd_empresa 
				 inner join DEPENDENTES as d_u on a.CD_ASSOCIADO = d_u.CD_ASSOCIADO 
				 inner join HISTORICO as h_u on d_u.CD_Sequencial_historico=h_u.cd_sequencial and h_u.CD_SITUACAO in (@cd,1)
				 inner join preco_plano as pp on d_u.cd_plano = pp.cd_plano and a.cd_empresa = pp.cd_empresa and pp.dt_fim_comercializacao is null 
		where h.CD_SITUACAO=@cd 
		  and pp.fl_valor_fixo=1
		  --and a.cd_empresa in (20,11435)
		  and d_u.vl_plano <> case when d_u.CD_GRAU_PARENTESCO=1 then pp.vl_tit when d_u.CD_GRAU_PARENTESCO=10 then pp.vl_agregado else pp.vl_dep end  
		  and pp.vl_dep1 is null 
		  and e.tp_empresa in (2,8)
			  ) as x 
		where DEPENDENTES.CD_SEQUENCIAL=x.CD_SEQUENCIAL
	End    

End 
