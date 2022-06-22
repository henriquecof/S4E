/****** Object:  Procedure [dbo].[sp_gera_ortodontia]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE Procedure [dbo].[sp_gera_ortodontia]
As 
Begin

delete Ortodontia 

insert into Ortodontia 
(id, cd_filial, nm_razsoc, cd_associado, nm_dependente, dt_inicio, vl_servico, 
 cd_funcionario,nm_empregado, dt_venciment, dt_ultorto,dt_consulta, fl_inc, nm_situacao, cd_centro_custo, dt_kit)

select d.CD_SEQUENCIAL, d.cd_clinica ,
  
       e.NM_FANTASIA, a.cd_associado, d.NM_DEPENDENTE , d.dt_assinaturaContrato , d.vl_plano ,
       d.cd_funcionario_dentista , f.nm_empregado , 

(select top 1 m.dt_vencimento
   from MENSALIDADES as M, Mensalidades_Planos as MP
  where mp.cd_sequencial_dep = d.cd_sequencial and 
        mp.cd_parcela_mensalidade=m.cd_parcela and 
        m.cd_tipo_parcela=1 and 
        m.CD_TIPO_RECEBIMENTO>2 and 
        mp.dt_exclusao IS null 
order by m.dt_vencimento desc ), 
        
(select top 1 con.dt_servico 
   from consultas as con , ServicoEspecialidade as se, ESPECIALIDADE as es
  where con.cd_sequencial_dep = d.cd_sequencial and 
        con.cd_funcionario = f.cd_funcionario and
        con.cd_servico = se.cd_servico and 
        se.cd_especialidade=es.cd_especialidade and
        es.fl_ortodontia=1 and
        con.Status  not in (1,2,4,8) 
order by con.dt_servico desc  )   , 

(select top 1 ag.dt_compromisso
   from agenda as ag
  where ag.cd_sequencial_dep = d.cd_sequencial and 
        ag.cd_funcionario = f.cd_funcionario 
order by ag.dt_compromisso desc  )   , 

       1 , sh.NM_SITUACAO_HISTORICO , c.cd_centro_custo, 
       case when d.dt_RecKitOrto Is not null then convert(varchar(10),d.dt_RecKitOrto,103) else convert(varchar(5),DATEDIFF(day,d.dt_assinaturaContrato,GETDATE())) + ' dias' end 
       
  from PLANOS as p , dependentes as d, ASSOCIADOS as a , empresa as e , Centro_Custo as c , 
       funcionario as f , HISTORICO as h , SITUACAO_HISTORICO as sh
 where p.cd_plano = d.cd_plano and 
       d.CD_ASSOCIADO = a.cd_associado and 
       d.cd_funcionario_dentista= f.cd_funcionario and 
       d.CD_Sequencial_historico=h.cd_sequencial and 
       h.CD_SITUACAO = sh.CD_SITUACAO_HISTORICO and 
       --sh.fl_atendido_clinica=1 and 
       sh.fl_incluir_ans=1 and 
       a.cd_empresa=e.CD_EMPRESA and 
       e.cd_centro_custo=c.cd_centro_custo and 
       p.fl_exige_dentista= 1  and 
       e.tp_empresa < 10 
order by c.cd_centro_custo,f.cd_funcionario, e.NM_FANTASIA , d.nm_dependente 

	 update ortodontia
	    set qt_pagas = (select count(0)
						  from Mensalidades_Planos as mp inner join MENSALIDADES as m on mp.cd_parcela_mensalidade = m.CD_PARCELA 
						where Ortodontia.id = mp.cd_sequencial_dep  
						  and mp.dt_exclusao is null and m.CD_TIPO_RECEBIMENTO not in (1,2)
						)

	 update ortodontia
	    set qt_consultas = (select count(0)
						      from consultas as c
						     where Ortodontia.id = c.cd_sequencial_dep  
						       and c.dt_servico is not null 
							   and c.Status in (3,6,9)
							   and c.cd_servico in (86000357,86000365 ,86000373)
						    )	

End 
