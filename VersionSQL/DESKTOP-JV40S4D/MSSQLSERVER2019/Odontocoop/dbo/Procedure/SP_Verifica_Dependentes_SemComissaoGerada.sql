/****** Object:  Procedure [dbo].[SP_Verifica_Dependentes_SemComissaoGerada]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE Procedure [dbo].[SP_Verifica_Dependentes_SemComissaoGerada]
as 
Begin

 -- Tipo : 1 - dependente, 2-Associado, 3-Empresa, 4-Funcionario
 
select e.CD_EMPRESA,  e.NM_RAZSOC , a.cd_associado, a.nm_completo,  convert(varchar(10),d.dt_assinaturaContrato,103) as DtAssCto,  d.vl_plano, f.nm_empregado, p.nm_plano , d.cd_sequencial 
  from empresa as e,associados as a, dependentes as d, historico as h, situacao_historico as sh, lote_contratos_contratos_vendedor as l , funcionario as f , planos as p
  where e.cd_empresa = a.cd_empresa
    and a.cd_associado = d.cd_associado 
    and d.cd_sequencial_historico = h.cd_sequencial 
    and h.cd_situacao = sh.cd_situacao_historico and sh.fl_incluir_ans = 1 
    and d.cd_sequencial = l.cd_sequencial_dep and l.cd_sequencial_lote > 1 
    and d.cd_funcionario_vendedor = f.cd_funcionario 
    and d.cd_plano = p.cd_plano 
    and d.dt_assinaturacontrato>=DATEADD(MONTH,-2,GETDATE()) 
    and d.cd_sequencial not in (select cd_sequencial_dependente from comissao_vendedor where cd_sequencial_dependente = d.cd_sequencial)
    and d.CD_SEQUENCIAL not in (select cd_sequencial from exclusao_comissao where cd_tipo=1)
    and d.cd_sequencial not in (select cd_sequencial_dep from tb_comissaovendedoroperacao where Data_Operacao is null)
    and a.cd_associado not in (select cd_sequencial from exclusao_comissao where cd_tipo=2)
    and e.cd_empresa  not in (select cd_sequencial from exclusao_comissao where cd_tipo=3) 
    and f.cd_funcionario not in (select cd_sequencial from exclusao_comissao where cd_tipo=4) 
    
End 
