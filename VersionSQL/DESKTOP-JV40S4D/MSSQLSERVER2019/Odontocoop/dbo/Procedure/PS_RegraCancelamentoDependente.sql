/****** Object:  Procedure [dbo].[PS_RegraCancelamentoDependente]    Committed by VersionSQL https://www.versionsql.com ******/

/* 
 
    <alt>alteração</alt>
    <doc>
        <titulo>Colocar título</titulo>
        <descricao>motivo</descricao>
        <chamado>chamado ##</chamado>
    </doc>
 
*/
CREATE PROCEDURE [dbo].[PS_RegraCancelamentoDependente] (
	@cd_empresa INT,
	@cd_dependente INT,
	@r VARCHAR(200) OUT
	)
AS
BEGIN --0
	DECLARE @regra AS INT = 0
	DECLARE @nm_dependente AS VARCHAR(200) = (
			SELECT NM_DEPENDENTE
			FROM dependentes
			WHERE CD_SEQUENCIAL = @cd_dependente
			)
	DECLARE @dt_assinaturaContrato AS DATETIME
	DECLARE @dt_servico AS DATETIME

	SELECT @regra = isnull(cd_RegraCancelamentoDependente, 0)
	FROM EMPRESA
	WHERE CD_EMPRESA = @cd_empresa --582 

	--Regra 1 ou sem regra.
	IF @regra = 0
		OR @regra = 1
	BEGIN --1
		SELECT TOP 1 @dt_assinaturaContrato = T1.dt_assinaturaContrato,
			@dt_servico = T2.dt_servico
		FROM dependentes T1
		LEFT OUTER JOIN Consultas T2 ON t1.cd_sequencial = t2.cd_sequencial_dep
		WHERE T1.cd_sequencial = @cd_dependente --13121
			AND T2.dt_servico IS NOT NULL
			AND T2.dt_cancelamento IS NULL
			AND T2.STATUS IN (
				3,
				6,
				7
				)
		ORDER BY dt_servico DESC

		IF (
				DATEDIFF(YY, @dt_assinaturaContrato, GETDATE()) - CASE 
					WHEN DATEADD(YY, DATEDIFF(YY, @dt_assinaturaContrato, GETDATE()), @dt_assinaturaContrato) > GETDATE()
						THEN 1
					ELSE 0
					END
				) > 0
			AND DATEDIFF(MONTH, isnull(@dt_servico, '1990-01-01 00:00:00'), GETDATE()) > 6
			SET @r = 'true'
		ELSE IF (
				DATEDIFF(YY, @dt_assinaturaContrato, GETDATE()) - CASE 
					WHEN DATEADD(YY, DATEDIFF(YY, @dt_assinaturaContrato, GETDATE()), @dt_assinaturaContrato) > GETDATE()
						THEN 1
					ELSE 0
					END
				) = 0
			SET @r = 'Solicitação de cancelamento não pode ser realizada, pois usuário: ' + @nm_dependente + ' tem menos de um ano de contrato.'
		ELSE
			SET @r = 'Solicitação de cancelamento não pode ser realizada, pois usuário: ' + @nm_dependente + ' utilizou o plano nos últimos 6 meses.'
	END --1
			--Regra 2
	ELSE IF @regra = 2
	BEGIN --2
		SELECT TOP 1 @dt_servico = T2.dt_servico
		FROM dependentes T1
		LEFT OUTER JOIN Consultas T2 ON t1.cd_sequencial = t2.cd_sequencial_dep
		WHERE T1.cd_sequencial = @cd_dependente --13121
			AND T2.dt_servico IS NOT NULL
			AND T2.dt_cancelamento IS NULL
			AND T2.STATUS IN (
				3,
				6,
				7
				)
		ORDER BY dt_servico DESC

		IF DATEDIFF(MONTH, isnull(@dt_servico, '1990-01-01 00:00:00'), GETDATE()) > 6
			SET @r = 'true'
		ELSE
			SET @r = 'Solicitação de cancelamento não pode ser realizada, pois usuário: ' + @nm_dependente + ' utilizou o plano nos últimos 6 meses.'
	END --2
	ELSE IF @regra = 3
	BEGIN --3
		SET @r = 'true'
	END --3
	ELSE IF @regra = 4
	BEGIN --4
		SELECT TOP 1 @dt_assinaturaContrato = T1.dt_assinaturaContrato
		FROM dependentes T1
		LEFT OUTER JOIN Consultas T2 ON t1.cd_sequencial = t2.cd_sequencial_dep
		WHERE T1.cd_sequencial = @cd_dependente --13121
			AND T2.dt_servico IS NOT NULL
			AND T2.dt_cancelamento IS NULL
			AND T2.STATUS IN (
				3,
				6,
				7
				)
		ORDER BY dt_servico DESC

		IF (
				DATEDIFF(YY, @dt_assinaturaContrato, GETDATE()) - CASE 
					WHEN DATEADD(YY, DATEDIFF(YY, @dt_assinaturaContrato, GETDATE()), @dt_assinaturaContrato) > GETDATE()
						THEN 1
					ELSE 0
					END
				) > 0
			SET @r = 'true'
		ELSE
			SET @r = 'Solicitação de cancelamento não pode ser realizada, pois usuário: ' + @nm_dependente + ' tem menos de um ano de contrato.'
	END --4
	ELSE IF @regra = 5
	BEGIN --5
		SELECT TOP 1 @dt_assinaturaContrato = T1.dt_assinaturaContrato,
			@dt_servico = T2.dt_servico
		FROM dependentes T1
		LEFT OUTER JOIN Consultas T2 ON t1.cd_sequencial = t2.cd_sequencial_dep
		WHERE T1.cd_sequencial = @cd_dependente --13121
			AND T2.dt_servico IS NOT NULL
			AND T2.dt_cancelamento IS NULL
			AND T2.STATUS IN (
				3,
				6,
				7
				)
		ORDER BY dt_servico DESC

		IF @dt_servico IS NULL
			SET @r = 'true'
		ELSE IF (
				DATEDIFF(YY, @dt_assinaturaContrato, GETDATE()) - CASE 
					WHEN DATEADD(YY, DATEDIFF(YY, @dt_assinaturaContrato, GETDATE()), @dt_assinaturaContrato) > GETDATE()
						THEN 1
					ELSE 0
					END
				) > 0
			SET @r = 'true'
		ELSE
			SET @r = 'Solicitação de cancelamento não pode ser realizada, pois usuário: ' + @nm_dependente + ' tem menos de um ano de contrato.'
	END --5
END --0
