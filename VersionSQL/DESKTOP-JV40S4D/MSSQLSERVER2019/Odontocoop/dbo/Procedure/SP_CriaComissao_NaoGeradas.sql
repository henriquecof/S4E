/****** Object:  Procedure [dbo].[SP_CriaComissao_NaoGeradas]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE Procedure [dbo].[SP_CriaComissao_NaoGeradas]
as
Begin

-- Gerar comissao
Declare @cd_seq int        -- Sequencial do Dependente
Declare @vl_plano money
Declare @Adesao smallint = 0    -- Plano gerado Adesao 
Declare @Operacao smallint=1
declare @retorno varchar(1000)='' 

Declare cursor_Inc CURSOR FOR 
select d.cd_sequencial, d.vl_plano --, a.cd_associado, d.dt_assinaturaContrato
  from empresa as e,associados as a, dependentes as d, historico as h, situacao_historico as sh, lote_contratos_contratos_vendedor as l 
  where e.cd_empresa = a.cd_empresa
    and a.cd_associado = d.cd_associado 
    and d.cd_sequencial_historico = h.cd_sequencial 
    and h.cd_situacao = sh.cd_situacao_historico and sh.fl_incluir_ans = 1 
    and d.cd_sequencial = l.cd_sequencial_dep and l.cd_sequencial_lote > 1 
    and d.dt_assinaturacontrato>=DATEADD(MONTH,-2,GETDATE()) 
    and d.cd_sequencial not in (select cd_sequencial_dependente from comissao_vendedor where cd_sequencial_dependente = d.cd_sequencial)
    and d.CD_SEQUENCIAL not in (select cd_sequencial from exclusao_comissao)
    and a.cd_associado not in (select cd_sequencial from exclusao_comissao where cd_tipo=2)
    and e.cd_empresa  not in (select cd_sequencial from exclusao_comissao where cd_tipo=3) 
    and d.cd_funcionario_vendedor not in (select cd_sequencial from exclusao_comissao where cd_tipo=4)     
  --  and e.CD_EMPRESA = 3026 
   OPEN cursor_Inc
   FETCH NEXT FROM cursor_Inc INTO @cd_seq, @vl_plano
   WHILE (@@FETCH_STATUS <> -1)
    BEGIN -- 7 

      exec SP_Inclui_Comissao2 @cd_seq, @vl_plano, @adesao , @Operacao, @retorno output
      
      FETCH NEXT FROM cursor_Inc INTO @cd_seq, @vl_plano       
    End
    Close cursor_Inc
    Deallocate   cursor_Inc

End 
