/****** Object:  Procedure [dbo].[SP_Regerar_Comissao]    Committed by VersionSQL https://www.versionsql.com ******/

create pROCEDURE [dbo].[SP_Regerar_Comissao](
   @cd_empresa int,
   @return smallint = 0)
AS
begin -- 0

Begin transaction
-- Gerar comissao
Declare @cd_seq int        -- Sequencial do Dependente
Declare @vl_plano money
Declare @Adesao smallint = 0    -- Plano gerado Adesao 
Declare @Operacao smallint=1
declare @retorno varchar(1000)='' 

Declare cursor_Inc CURSOR FOR 
select d.cd_sequencial, d.vl_plano 
  from empresa as e,associados as a, dependentes as d, historico as h, situacao_historico as sh
  where e.cd_empresa = a.cd_empresa
    and a.cd_associado = d.cd_associado 
    and d.cd_sequencial_historico = h.cd_sequencial 
    and h.cd_situacao = sh.cd_situacao_historico and sh.fl_incluir_ans = 1 
    --and a.cd_associado = 301228946
    and e.cd_empresa = @cd_empresa  
    and d.cd_sequencial not in (select cd_sequencial_dependente from comissao_vendedor where cd_sequencial_dependente = d.cd_sequencial)
   OPEN cursor_Inc
   FETCH NEXT FROM cursor_Inc INTO @cd_seq, @vl_plano
   WHILE (@@FETCH_STATUS <> -1)
    BEGIN -- 7 

      exec SP_Inclui_Comissao2 @cd_seq, @vl_plano, @adesao , @Operacao, @retorno output, 1
      
      FETCH NEXT FROM cursor_Inc INTO @cd_seq, @vl_plano       
    End
    Close cursor_Inc
    Deallocate   cursor_Inc

--begin tran
--update dependentes
--set cd_funcionario_vendedor = 100024
--  from empresa as e,associados as a, historico as h, situacao_historico as sh
--  where e.cd_empresa = a.cd_empresa
--    and a.cd_associado = dependentes.cd_associado 
--    and dependentes.cd_sequencial_historico = h.cd_sequencial 
--    and h.cd_situacao = sh.cd_situacao_historico and sh.fl_incluir_ans = 1 
--    and e.cd_empresa = 2647   

commit

end -- 0
