/****** Object:  Procedure [dbo].[SP_AjustaValorComissao]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE Procedure [dbo].[SP_AjustaValorComissao] 
as 
Begin 

	update comissao_vendedor
	   set comissao_vendedor.valor =  DEPENDENTES.vl_plano  
	  from DEPENDENTES
	 where comissao_vendedor.cd_sequencial_dependente = DEPENDENTES.cd_sequencial 
	   and DEPENDENTES.vl_plano <> comissao_vendedor.valor
	   and comissao_vendedor.cd_sequencial_lote is null 
	   
End 	  
