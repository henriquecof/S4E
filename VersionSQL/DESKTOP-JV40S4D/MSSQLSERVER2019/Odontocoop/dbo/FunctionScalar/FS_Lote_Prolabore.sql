/****** Object:  Function [dbo].[FS_Lote_Prolabore]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		João Paulo
-- Create date: 02/04/2014
-- Description:	Retorna valores da tb Lote_ProlaboreMensalidade
-- =============================================
CREATE FUNCTION [dbo].[FS_Lote_Prolabore] 
(
	@cd_parcela int, @funcionariodiretor int
)
RETURNS varchar(500)
AS
BEGIN
	-- Declare the return variable here
	DECLARE @Resultado varchar(500)

	-- Add the T-SQL statements to compute the return value here  
	SELECT @Resultado = convert(varchar(15),T1.Nr_Lote) + '©' + 
      convert(varchar(10),T1.dt_cadastro,103) + ' ' + convert(varchar(5),T1.dt_cadastro,108)  + '©'+
      (select top 1 T11.nm_empregado from funcionario T11 where T11.cd_funcionario =  T1.cd_funcionario)+ '©'+
      (select top 1 T12.nm_empregado from funcionario T12 where T12.cd_funcionario =  T1.cd_funcionariodiretor)+ '©'+
      convert(varchar(15),T1.Sequencial_Lancamento)
  FROM Lote_ProlaboreMensalidade T1
  where T1.cd_parcela = @cd_parcela
  and T1.cd_funcionariodiretor = @funcionariodiretor


	-- Return the result of the function
	RETURN @Resultado

END
