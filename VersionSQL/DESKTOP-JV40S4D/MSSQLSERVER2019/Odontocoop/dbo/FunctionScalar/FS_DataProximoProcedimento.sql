/****** Object:  Function [dbo].[FS_DataProximoProcedimento]    Committed by VersionSQL https://www.versionsql.com ******/

/*
Objetivo           : Trazer data do possivel próximo atendimento do cliente
Parâmetros Entrada : 
                     @Associado  - Código do Cliente
                     @Sequencial_Dep - Sequencial do Cliente (Dependente)
                     @Data_Atual - Data atual
					 @Clinica - Código da clínica. 0 = Não informado
Parâmetro Saída    :
                     @Data_Saida - Data do Próximo Atendimento
*/
CREATE FUNCTION [dbo].[FS_DataProximoProcedimento] (
	@Associado INT,
	@Sequencial_Dep INT,
	@DataAtual DATETIME,
	@Clinica INT
	)
RETURNS VARCHAR(10)
AS
BEGIN
	DECLARE @DT_Compromisso DATETIME
	DECLARE @VerificarFalta TINYINT
	DECLARE @DT_UltimaFalta DATETIME
	DECLARE @DiasIntervaloConsulta SMALLINT
	DECLARE @fl_DiasIntervaloConsultaVariaveis SMALLINT

	SET @DataAtual = getdate()

	SELECT TOP 1 @DT_Compromisso = isnull(T4.dt_compromisso, '01/01/1900'),
		@DiasIntervaloConsulta = isnull(T3.DiasIntervaloConsulta, 7),
		@fl_DiasIntervaloConsultaVariaveis = isnull((
				SELECT fl_DiasIntervaloConsultaVar
				FROM filial
				WHERE cd_filial = @Clinica
				), 0)
	FROM associados T1
	INNER JOIN dependentes T2 ON t1.cd_associado = t2.cd_associado
	LEFT OUTER JOIN empresa T3 ON t1.cd_empresa = t3.cd_empresa
	LEFT OUTER JOIN agenda T4 ON t2.cd_associado = t4.cd_associado
		AND t2.cd_sequencial = t4.cd_sequencial_dep
	WHERE T2.cd_associado = @Associado
		AND T2.cd_sequencial = @Sequencial_Dep
		AND isnull(T4.cd_sequencial_atuacao_dent, 0) NOT IN (
			SELECT cd_sequencial
			FROM Atuacao_Dentista
			WHERE cd_sequencial = isnull(T4.cd_sequencial_atuacao_dent, 0)
				AND cd_especialidade IN (
					SELECT cd_especialidade
					FROM especialidade
					WHERE fl_contabiliza_marcacao = 0
					)
			)
		AND isnull(T4.cd_sequencial, 0) NOT IN (
			SELECT TT1.cd_sequencial_agenda
			FROM consultas TT1
			WHERE TT1.cd_sequencial_agenda = T4.cd_sequencial
				AND cd_servico IN (
					SELECT cd_servico
					FROM servico
					WHERE fl_DesprezaMarcacao = 1
						AND cd_servico = TT1.cd_servico
					)
			)
		AND isnull(T4.fl_urgencia, 0) <> 1
	ORDER BY T4.dt_compromisso DESC

	-- Se for verificado também com a última falta
	SELECT @VerificarFalta = count(0)
	FROM servico
	WHERE cd_servico IN (
			80000140,
			80000618
			)
		AND fl_DesprezaMarcacao = 0

	IF (@VerificarFalta > 0)
	BEGIN
		SELECT TOP 1 @DT_UltimaFalta = isnull(dt_servico, '01/01/1900')
		FROM consultas
		WHERE cd_servico IN (
				80000140,
				80000618
				)
			AND cd_sequencial_dep = @Sequencial_Dep
			AND dt_cancelamento IS NULL
		ORDER BY dt_servico DESC

		IF (@DT_UltimaFalta > @DT_Compromisso)
			SET @DT_Compromisso = @DT_UltimaFalta
	END

	-- Se não existir nenhum atendimento realizado, assume o dia atual com a possível data
	IF (@DT_Compromisso = '01/01/1900')
		SET @DT_Compromisso = @DataAtual
	ELSE
	-- Somar a quantidade de dias na data do último atendimento
	IF (@fl_DiasIntervaloConsultaVariaveis = 0)
		IF (@DiasIntervaloConsulta > 0)
			SET @DT_Compromisso = DateAdd(dd, @DiasIntervaloConsulta, @DT_Compromisso) --Usuários de empresas
		ELSE
			SET @DT_Compromisso = DateAdd(dd, 7, @DT_Compromisso) -- Valor Default
	ELSE
		SET @DT_Compromisso = DateAdd(dd, @fl_DiasIntervaloConsultaVariaveis, @DT_Compromisso)

	-- Se a data for menor que a data atual, assume a data atual
	IF DateDiff(dd, @DT_Compromisso, @DataAtual) > 0
		SET @DT_Compromisso = @DataAtual

	RETURN Convert(VARCHAR(10), @DT_Compromisso, 103)
END
