/****** Object:  Procedure [dbo].[SP_Muda_Plano_Dependente]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[SP_Muda_Plano_Dependente]
AS
begin

	Declare @cd_dependente as integer
	Declare @cd_plano_novo as integer
	Declare @cd_historico as integer
	Declare @cd_associado as integer

	DECLARE cursor_alteracao_plano CURSOR FOR 
		select T1.cd_historico, T1.cd_dependente, T1.cd_plano_novo, T2.cd_associado
		from HistoricoAlteracaoPlano T1, dependentes T2
		where isnull(T1.fl_realizado,0) = 0
			and convert(date,T1.dt_mudanca) <= CONVERT(date, getdate())
			and T1.cd_dependente = T2.CD_SEQUENCIAL 
		GROUP BY  T1.cd_historico, T1.cd_dependente, T1.cd_plano_novo, T2.cd_associado
		
	OPEN cursor_alteracao_plano 
	FETCH NEXT FROM cursor_alteracao_plano INTO @cd_historico, @cd_dependente, @cd_plano_novo, @cd_associado
	WHILE (@@FETCH_STATUS <> -1)
	BEGIN
		--update dependente
		update dependentes
		set cd_plano = @cd_plano_novo
		where cd_sequencial = @cd_dependente
		
		--update historico
		update  HistoricoAlteracaoPlano
		set fl_realizado = 1, dt_realizacao = GETDATE()
		where cd_historico = @cd_historico
		
		
		FETCH NEXT FROM cursor_alteracao_plano INTO @cd_historico, @cd_dependente, @cd_plano_novo, @cd_associado
	 END
	 CLOSE cursor_alteracao_plano
	 DEALLOCATE cursor_alteracao_plano
end
