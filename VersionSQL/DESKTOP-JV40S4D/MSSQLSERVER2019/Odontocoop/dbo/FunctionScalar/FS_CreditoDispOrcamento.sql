/****** Object:  Function [dbo].[FS_CreditoDispOrcamento]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
Create FUNCTION [dbo].[FS_CreditoDispOrcamento] 
(
	-- Add the parameters for the function here
	@cd_orcamento int
)
RETURNS money
AS
BEGIN
	-- Declare the return variable here
	DECLARE @valorCredito money

	select @valorCredito = Case when @cd_orcamento IS null then 0 
	when (select isnull(TipoBaixaOrcamento,1) from Configuracao)<3 then --'Total(1) ou Parcial(2)
	isnull((select vl_credito_disponivel from orcamento_clinico OS where @cd_orcamento = OS.cd_orcamento),0) - 
	ISNULL((select sum(vl_servico) 
	from orcamento_servico as OS1, Consultas as CON 
	where @cd_orcamento = OS1.cd_orcamento and 
	OS1.cd_sequencial_pp = CON.cd_sequencial and 
	CON.Status in (3,6,7) and 
	CON.dt_servico is not null),0) 
	else 0
	End 

	-- Return the result of the function
	RETURN @valorCredito

END
