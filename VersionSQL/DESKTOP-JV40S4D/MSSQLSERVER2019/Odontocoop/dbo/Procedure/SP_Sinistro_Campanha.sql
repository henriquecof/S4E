/****** Object:  Procedure [dbo].[SP_Sinistro_Campanha]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE Procedure [dbo].[SP_Sinistro_Campanha]
  @dt_ini datetime, 
  @dt_fim datetime,
  @cd_centro_custo int, 
  @tabela int, 
  @campanha int 
As  
Begin


select a.cd_associado, Nome_Prospect , telefone_contato_1, telefone_contato_2,telefone_contato_3, 
       SUM(valor_titulo) as vl_atraso , 
       
       (
select sum(isnull(T9.vl_servico,0)) as vl_servico
  from Consultas T1, Servico T2, Filial T3, Funcionario T4, Dependentes T5, Tabela_Servicos T9 --, Associados T6
 where T1.cd_servico = T2.cd_servico 
   and T1.cd_filial = T3.cd_filial 
   and T1.cd_funcionario = T4.cd_funcionario 
   and T1.cd_sequencial_dep = T5.cd_sequencial 
   and T5.cd_associado = a.cd_associado  --T6.cd_associado 
   and T1.cd_servico = T9.cd_servico 
   and T9.cd_tabela = @tabela
   and T1.dt_cancelamento is null 
   and T1.status in (3,6,7) 
   and T1.dt_servico is not null 
   and T1.cd_servico in (select cd_servico from Plano_Servico where cd_servico = T1.cd_servico and cd_plano = T5.cd_plano) 
 --  and t6.cd_associado = a.cd_associado 
   and T9.vl_servico > 0 
   group by t5.cd_associado ) , 
   
(
select SUM(isnull(t100.vl_pago,0)) as vl_pago  
  from MENSALIDADES as t100
 where t100.TP_ASSOCIADO_EMPRESA in (1) and 
       t100.CD_ASSOCIADO_empresa = a.cd_associado and 
       t100.CD_TIPO_RECEBIMENTO > 2 and
       t100.DT_PAGAMENTO is not null and 
       t100.cd_tipo_parcela in (1,2,3) 
group by cd_associado_empresa  )

          
  from tb_Izzy as i , ASSOCIADOS as a, EMPRESA as e
 where i.cd_campanha = @campanha  and i.ID_ERP_CRM = a.cd_associado and a.cd_empresa = e.CD_EMPRESA and 
       e.cd_centro_custo = @cd_centro_custo
 group by a.cd_associado , Nome_Prospect , telefone_contato_1, telefone_contato_2,telefone_contato_3
 

End    
