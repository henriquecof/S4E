/****** Object:  Procedure [dbo].[SP_Analisa_Cliente]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[SP_Analisa_Cliente] (
	@cd_SequencialAgenda INT,
	@autoriza_Agenda SMALLINT = 0,
	@cd_sequencial_dep INT = 0,
	@fl_urgencia TINYINT = 0,
	@fl_ortodontia TINYINT = 0
	)
AS
BEGIN
	DECLARE @cd_associado INT
	DECLARE @cd_sequencial INT
	DECLARE @cd_empresa INT
	DECLARE @dt_vencimento SMALLDATETIME
	DECLARE @fl_atendido INT
	DECLARE @qtde INT
	DECLARE @dt_compromisso DATETIME
	DECLARE @cd_especialidade INT
	DECLARE @tp_empresa INT
	DECLARE @cd_funcionario INT
	DECLARE @restrincao BIT
	DECLARE @QT_DIAS_BLOQUEIO_ATENDIMENTO SMALLINT
	DECLARE @cd_especialidadeOrto INT
	DECLARE @cd_seq_sop INT
	DECLARE @fl_cortesia SMALLINT
	DECLARE @dataLimiteAtendimento DATE = NULL
	DECLARE @LicencaS4E VARCHAR(50)

	SELECT @LicencaS4E = LicencaS4E
	FROM Configuracao

	IF @cd_SequencialAgenda > 0
		--Agenda
	BEGIN
		SELECT TOP 1 @cd_especialidadeOrto = cd_especialidade
		FROM especialidade
		WHERE fl_ortodontia = 1

		IF @cd_especialidadeOrto IS NULL
		BEGIN
			RAISERROR (
					'Especialidade Ortodontia nao encontrada.',
					16,
					1
					)

			RETURN
		END

		SELECT @cd_sequencial = a.cd_sequencial,
			@cd_associado = a.cd_associado,
			@cd_sequencial_dep = a.cd_sequencial_dep,
			@dt_compromisso = a.dt_compromisso,
			@cd_especialidade = d.cd_especialidade,
			@tp_empresa = e.tp_empresa,
			@cd_funcionario = a.cd_funcionario,
			@cd_empresa = s.cd_empresa,
			@QT_DIAS_BLOQUEIO_ATENDIMENTO = isnull(dias_tolerancia_atendimento, (
					CASE 
						WHEN fl_urgencia = 0
							THEN CASE 
									WHEN @fl_ortodontia = 0
										THEN isnull(p.QT_DIAS_BLOQUEIO_ATENDIMENTO, 0)
									ELSE isnull(p.QT_DIAS_BLOQUEIO_ATENDIMENTO_ORTO, 0)
									END
						ELSE ISNULL(p.QT_DIAS_BLOQUEIO_ATENDIMENTOU, - 1)
						END
					)),
			@fl_cortesia = ISNULL(p.fl_cortesia, 0)
		FROM agenda AS a
		LEFT OUTER JOIN atuacao_dentista AS d ON a.cd_sequencial_atuacao_dent = d.cd_sequencial
		INNER JOIN ASSOCIADOS AS s ON a.cd_associado = s.cd_associado
		INNER JOIN DEPENDENTES AS d1 ON a.cd_sequencial_dep = d1.CD_SEQUENCIAL
		INNER JOIN PLANOS AS p ON d1.cd_plano = p.cd_plano
		INNER JOIN EMPRESA AS e ON s.cd_empresa = e.CD_EMPRESA
		WHERE (a.nr_autorizacao IS NULL)
			AND (a.cd_sequencial = @cd_SequencialAgenda)

		IF @@ROWCOUNT = 0
		BEGIN
			RAISERROR (
					'Agenda não localizada.',
					16,
					1
					)

			RETURN
		END

		IF @cd_sequencial IS NULL
		BEGIN
			RAISERROR (
					'Agenda não localizada.',
					16,
					1
					)

			RETURN
		END
	END
	ELSE
		--Sem agenda
	BEGIN
		SELECT @cd_sequencial = 0,
			@cd_associado = s.cd_associado,
			@cd_sequencial_dep = d1.cd_sequencial,
			@dt_compromisso = GETDATE(),
			@cd_especialidade = 1,
			@tp_empresa = e.tp_empresa,
			@cd_funcionario = NULL,
			@cd_empresa = s.cd_empresa,
			@QT_DIAS_BLOQUEIO_ATENDIMENTO = isnull(dias_tolerancia_atendimento, (
					CASE 
						WHEN @fl_urgencia = 0
							THEN CASE 
									WHEN @fl_ortodontia = 0
										THEN isnull(p.QT_DIAS_BLOQUEIO_ATENDIMENTO, 0)
									ELSE isnull(p.QT_DIAS_BLOQUEIO_ATENDIMENTO_ORTO, 0)
									END
						ELSE ISNULL(p.QT_DIAS_BLOQUEIO_ATENDIMENTOU, - 1)
						END
					)),
			@fl_cortesia = ISNULL(p.fl_cortesia, 0)
		FROM associados AS s,
			empresa e,
			dependentes AS d1,
			planos AS p
		WHERE s.cd_associado = d1.CD_ASSOCIADO
			AND d1.cd_plano = p.cd_plano
			AND s.cd_empresa = e.CD_EMPRESA
			AND d1.cd_sequencial = @cd_sequencial_dep
	END

	--Apagar análises não autorizadas
	DELETE tb_analise_cliente
	WHERE cd_sequencial_dep = @cd_sequencial_dep

	--Verificar plano ortodôntico
	IF @cd_especialidade = @cd_especialidadeOrto
	BEGIN
		SELECT cd_sequencial_Dep
		FROM dependentes AS d,
			planos AS p,
			historico AS h
		WHERE d.cd_sequencial = @cd_sequencial_dep
			AND d.cd_plano = p.cd_plano
			AND h.cd_sequencial = (
				SELECT TOP 1 cd_sequencial
				FROM historico
				WHERE cd_sequencial_dep = d.cd_sequencial
				ORDER BY dt_situacao DESC,
					cd_sequencial DESC
				)
			AND h.cd_situacao = 1

		--and d.cd_funcionario_dentista = @cd_funcionario
		--and p.fl_exige_dentista = 1
		IF @@ROWCOUNT = 0
		BEGIN
			INSERT tb_analise_cliente (
				cd_Associado,
				cd_sequencial_dep,
				restricao,
				cd_sequencial_agenda
				)
			VALUES (
				@cd_associado,
				@cd_sequencial_dep,
				'Associado não tem plano Ortodontico.',
				@cd_SequencialAgenda
				)
		END
	END

	SELECT @qtde = 0

	SELECT @fl_atendido = 1

	--Verificar titular
	SELECT @fl_atendido = CASE 
			WHEN situacao_historico.fl_atendido_clinica = 1
				AND sh.fl_atendido_clinica = 1
				THEN 1
			ELSE 0
			END
	FROM dependentes,
		historico,
		situacao_historico,
		associados AS a,
		empresa AS e,
		historico AS h,
		situacao_historico sh
	WHERE dependentes.CD_ASSOCIADO = @cd_associado
		AND dependentes.CD_GRAU_PARENTESCO = 1
		AND historico.cd_sequencial = (
			SELECT TOP 1 cd_sequencial
			FROM historico
			WHERE cd_sequencial_dep = dependentes.cd_sequencial
			ORDER BY dt_situacao DESC,
				cd_sequencial DESC
			)
		AND historico.cd_situacao = situacao_historico.cd_situacao_historico
		AND dependentes.cd_associado = a.cd_Associado
		AND a.cd_empresa = e.cd_empresa
		AND h.cd_sequencial = (
			SELECT TOP 1 cd_sequencial
			FROM historico
			WHERE cd_empresa = e.cd_empresa
			ORDER BY dt_situacao DESC,
				cd_sequencial DESC
			)
		AND h.cd_situacao = sh.cd_situacao_historico

	--Verificar dependente
	IF @fl_atendido = 1
		AND @cd_Sequencial_Dep > 1
	BEGIN
		SELECT @fl_atendido = fl_atendido_clinica
		FROM dependentes,
			historico,
			situacao_historico
		WHERE dependentes.cd_sequencial = @cd_sequencial_dep
			AND historico.cd_sequencial = (
				SELECT TOP 1 cd_sequencial
				FROM historico
				WHERE cd_sequencial_dep = dependentes.cd_sequencial
				ORDER BY dt_situacao DESC,
					cd_sequencial DESC
				)
			AND historico.cd_situacao = situacao_historico.cd_situacao_historico
	END

	--Dependente não pode ser atendido. Verificar data fim de atendimento
	IF @fl_atendido = 0
	BEGIN
		SELECT @fl_atendido = CASE 
				WHEN isnull(historico.dt_fim_atendimento, '01/01/2000') >= @dt_compromisso
					THEN 1
				ELSE 0
				END,
			@dataLimiteAtendimento = CASE 
				WHEN historico.cd_situacao = 2
					AND isnull(historico.dt_fim_atendimento, '01/01/2000') >= @dt_compromisso
					THEN historico.dt_fim_atendimento
				ELSE NULL
				END
		FROM dependentes,
			historico,
			situacao_historico
		WHERE dependentes.cd_sequencial = @cd_sequencial_dep
			AND historico.cd_sequencial = (
				SELECT TOP 1 cd_sequencial
				FROM historico
				WHERE cd_sequencial_dep = dependentes.cd_sequencial
				ORDER BY dt_situacao DESC,
					cd_sequencial DESC
				)
			AND historico.cd_situacao = situacao_historico.cd_situacao_historico
	END

	IF @fl_atendido = 0 -- Dependente nao pode ser atendido
	BEGIN
		INSERT tb_analise_cliente (
			cd_Associado,
			cd_sequencial_dep,
			restricao,
			cd_sequencial_agenda
			)
		VALUES (
			@cd_associado,
			@cd_sequencial_dep,
			'Associado em situação que não permite atendimento',
			@cd_SequencialAgenda
			)
	END

	SET @qtde = - 1 * @QT_DIAS_BLOQUEIO_ATENDIMENTO

	IF @fl_cortesia = 0
		AND @QT_DIAS_BLOQUEIO_ATENDIMENTO >= 0
	BEGIN
		--Parcelas
		--Dependente
		INSERT tb_analise_cliente (
			cd_Associado,
			cd_sequencial_dep,
			dt_vencimento,
			cd_sequencial_agenda
			)
		SELECT @cd_associado,
			@cd_sequencial_dep,
			m.dt_vencimento,
			@cd_SequencialAgenda
		FROM mensalidades AS m,
			mensalidades_planos mp
		WHERE m.cd_parcela = mp.cd_parcela_mensalidade
			AND m.cd_associado_empresa = CASE m.tp_associado_empresa
				WHEN 2
					THEN @cd_empresa
				ELSE @cd_associado
				END
			AND mp.cd_sequencial_dep = @cd_sequencial_dep
			AND m.cd_tipo_recebimento = 0
			AND m.vl_parcela > 0
			AND isnull(m.exibir, 1) = 1
			AND m.cd_tipo_parcela NOT IN (
				4,
				101
				)
			AND m.cd_tipo_parcela != CASE 
				WHEN @LicencaS4E = '0069PIOENFNFPNF4FRG94GOG0G4GOMGLMMKERNFEPFMRM4OGP'
					THEN 2
				ELSE - 1
				END
			AND mp.dt_exclusao IS NULL
			AND CASE 
				WHEN datepart(dw, isnull(m.dt_vencimento_new, m.dt_vencimento)) = 7
					THEN DATEADD(day, 2, isnull(m.dt_vencimento_new, m.dt_vencimento))
				WHEN datepart(dw, isnull(m.dt_vencimento_new, m.dt_vencimento)) = 1
					THEN DATEADD(day, 1, isnull(m.dt_vencimento_new, m.dt_vencimento))
				ELSE isnull(m.dt_vencimento_new, m.dt_vencimento)
				END < dateadd(day, @qtde, convert(VARCHAR(10), getdate(), 101))
			AND CASE 
				WHEN datepart(dw, isnull(m.dt_vencimento_new, m.dt_vencimento)) = 7
					THEN DATEADD(day, 2, isnull(m.dt_vencimento_new, m.dt_vencimento))
				WHEN datepart(dw, isnull(m.dt_vencimento_new, m.dt_vencimento)) = 1
					THEN DATEADD(day, 1, isnull(m.dt_vencimento_new, m.dt_vencimento))
				ELSE isnull(m.dt_vencimento_new, m.dt_vencimento)
				END < convert(VARCHAR(10), getdate(), 101)
			AND (
				SELECT count(0)
				FROM tbAutorizacaoConsulta
				WHERE acoDtLimite > convert(DATE, getdate())
					AND acoDtExclusao IS NULL
					AND cd_empresa = @cd_empresa
					AND acoDtVencimentoFatura = isnull(m.dt_vencimento_new, m.dt_vencimento)
				) = 0
			AND m.dataPagamentoTerceiro IS NULL
			AND (
				SELECT count(0)
				FROM mensalidadesAgrupadas X1
				INNER JOIN mensalidades X2 ON X1.cd_parcelamae = X2.cd_parcela
					AND X2.cd_tipo_recebimento = 0
					AND isnull(X2.dt_vencimento_new, X2.dt_vencimento) >= convert(DATE, getdate())
					AND X1.cd_parcela = m.cd_parcela
				) = 0

		--Verificação por empresa, se coletivo empresarial ou adesão
		IF (
				@tp_empresa IN (
					2,
					8
					)
				)
		BEGIN
			INSERT tb_analise_cliente (
				cd_Associado,
				cd_sequencial_dep,
				dt_vencimento,
				cd_sequencial_agenda
				)
			SELECT @cd_associado,
				@cd_sequencial_dep,
				m.dt_vencimento,
				@cd_SequencialAgenda
			FROM mensalidades AS m
			WHERE m.tp_associado_empresa = 2
				AND m.cd_associado_empresa = @cd_empresa
				AND m.cd_tipo_recebimento = 0
				AND m.vl_parcela > 0
				AND isnull(m.exibir, 1) = 1
				AND m.cd_tipo_parcela NOT IN (
					4,
					101
					)
				AND m.cd_tipo_parcela != CASE 
					WHEN @LicencaS4E = '0069PIOENFNFPNF4FRG94GOG0G4GOMGLMMKERNFEPFMRM4OGP'
						THEN 2
					ELSE - 1
					END
				AND CASE 
					WHEN datepart(dw, isnull(m.dt_vencimento_new, m.dt_vencimento)) = 7
						THEN DATEADD(day, 2, isnull(m.dt_vencimento_new, m.dt_vencimento))
					WHEN datepart(dw, isnull(m.dt_vencimento_new, m.dt_vencimento)) = 1
						THEN DATEADD(day, 1, isnull(m.dt_vencimento_new, m.dt_vencimento))
					ELSE isnull(m.dt_vencimento_new, m.dt_vencimento)
					END < dateadd(day, @qtde, convert(VARCHAR(10), getdate(), 101))
				AND CASE 
					WHEN datepart(dw, isnull(m.dt_vencimento_new, m.dt_vencimento)) = 7
						THEN DATEADD(day, 2, isnull(m.dt_vencimento_new, m.dt_vencimento))
					WHEN datepart(dw, isnull(m.dt_vencimento_new, m.dt_vencimento)) = 1
						THEN DATEADD(day, 1, isnull(m.dt_vencimento_new, m.dt_vencimento))
					ELSE isnull(m.dt_vencimento_new, m.dt_vencimento)
					END < convert(VARCHAR(10), getdate(), 101)
				AND (
					SELECT count(0)
					FROM tbAutorizacaoConsulta
					WHERE acoDtLimite > convert(DATE, getdate())
						AND acoDtExclusao IS NULL
						AND cd_empresa = @cd_empresa
						AND acoDtVencimentoFatura = isnull(m.dt_vencimento_new, m.dt_vencimento)
					) = 0
				AND m.dataPagamentoTerceiro IS NULL
				AND (
					SELECT count(0)
					FROM tb_analise_cliente
					WHERE cd_sequencial_dep = @cd_sequencial_dep
						AND dt_vencimento = m.dt_vencimento
					) = 0
				AND (
					SELECT count(0)
					FROM mensalidadesAgrupadas X1
					INNER JOIN mensalidades X2 ON X1.cd_parcelamae = X2.cd_parcela
						AND X2.cd_tipo_recebimento = 0
						AND isnull(X2.dt_vencimento_new, X2.dt_vencimento) >= convert(DATE, getdate())
						AND X1.cd_parcela = m.cd_parcela
					) = 0
		END
	END

	SELECT @qtde = COUNT(0)
	FROM tb_analise_cliente
	WHERE cd_sequencial_dep = @cd_sequencial_dep
		AND nr_autorizacao IS NULL

	IF @qtde = 0
		AND @autoriza_Agenda = 1
		AND @QT_DIAS_BLOQUEIO_ATENDIMENTO > 0
	BEGIN
		UPDATE agenda
		SET nr_autorizacao = 'AUTOM'
		WHERE cd_sequencial = @cd_SequencialAgenda
	END
END
