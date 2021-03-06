/****** Object:  Function [dbo].[FS_Lote_GratificacaoFuncOrto]    Committed by VersionSQL https://www.versionsql.com ******/

Create FUNCTION [dbo].[FS_Lote_GratificacaoFuncOrto] 
(
	@cd_parcela int, @funcionarioGratificacao int
)
RETURNS varchar(500)
AS
BEGIN
	-- Declare the return variable here
	DECLARE @Resultado varchar(500)

	SELECT @Resultado = convert(varchar(15),T1.Nr_Lote) + '©' + 
      convert(varchar(10),T1.dt_cadastro,103) + ' ' + convert(varchar(5),T1.dt_cadastro,108)  + '©'+
      (select top 1 T11.nm_empregado from funcionario T11 where T11.cd_funcionario =  T1.funcionarioCadastro)+ '©'+
      (select top 1 T12.nm_empregado from funcionario T12 where T12.cd_funcionario =  T1.funcionarioGratificacao)+ '©'+
      convert(varchar(15),T1.Sequencial_Lancamento)
  FROM Lote_GratificacaoFuncionarioOrto T1
  where T1.cd_parcela = @cd_parcela
  and T1.funcionarioGratificacao = @funcionarioGratificacao

	RETURN @Resultado

END
