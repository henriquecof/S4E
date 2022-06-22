/****** Object:  Function [dbo].[FS_DataCarenciaCarteira]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE FUNCTION [dbo].[FS_DataCarenciaCarteira] (
	@cd_sequencial_dep INT,
	@cd_servico INT,
	@ADD_dias INT
	)
RETURNS VARCHAR(10)
AS
BEGIN
	DECLARE @infoCarencia VARCHAR(100)
	DECLARE @dt_assinaturaContrato DATE
	DECLARE @dataTEMP DATE
	DECLARE @qt_diascarencia SMALLINT
	DECLARE @tp_empresa TINYINT
	DECLARE @fl_CarenciaAtendimento TINYINT
	DECLARE @fl_CarenciaAtendimentoPlano TINYINT
	DECLARE @fl_CarenciaAtendimentoEmpresa TINYINT
	DECLARE @inicioContagemDiasCarencia TINYINT
	DECLARE @Data VARCHAR(10)
	DECLARE @DataRetorno VARCHAR(10)
	DECLARE @licenca VARCHAR(100)
	DECLARE @ADD_diasRCA INT

	SET @infoCarencia = ''
	SET @qt_diascarencia = 0

	SELECT @licenca = licencaS4E
	FROM Configuracao

	--**************************************************************************
	--Dias de carência
	--**************************************************************************
	IF (@cd_servico > 0)
	BEGIN
		--Converter valores em string porque se for personalizada com data de início de vigência, deve desprezar a data de início primeiro atendimento e está diferenciando com o prefixo DIASCARENCIAREFHOJE
		SELECT @infoCarencia = coalesce(convert(VARCHAR, (
						SELECT TOP 1 diasCarencia
						FROM CarenciaPersonalizada
						WHERE cd_sequencial_dep = T5.cd_sequencial
							AND isnull(cd_servico, T3.cd_servico) = T3.cd_servico
							AND isnull(cd_especialidade, T3.cd_especialidadereferencia) = T3.cd_especialidadereferencia
							AND dataExclusao IS NULL
							AND idGrupoCarencia IS NULL
						)), convert(VARCHAR, (
						SELECT TOP 1 DiasCarencia
						FROM CarenciaPersonalizadaEmpresa X1
						INNER JOIN associados X2 ON X1.cd_empresa = X2.cd_empresa
						INNER JOIN dependentes X3 ON X2.cd_associado = X3.cd_associado
						WHERE X3.cd_sequencial = T5.cd_sequencial
							AND X1.DataInicial <= X3.dt_assinaturaContrato
							AND isnull(X1.DataFinal, dateadd(year, 50, getdate())) >= X3.dt_assinaturaContrato
							AND isnull(X1.cd_plano, X3.cd_plano) = X3.cd_plano
							AND isnull(X1.cd_especialidade, T3.cd_especialidadereferencia) = T3.cd_especialidadereferencia
							AND isnull(X1.cd_servico, T3.cd_servico) = T3.cd_servico
							AND CASE 
								WHEN X1.depid IS NULL
									AND X2.depid IS NULL
									THEN 0
								WHEN X1.depid IS NOT NULL
									THEN X1.depid
								ELSE X2.depid
								END = isnull(X2.depid, 0)
							AND X1.DataExclusao IS NULL
							AND X1.idGrupoCarencia IS NULL
						ORDER BY isnull(X1.DataFinal, dateadd(year, 50, getdate()))
						)), (
					SELECT TOP 1 'DIASCARENCIAREFHOJE' + convert(VARCHAR, datediff(day, getdate(), isnull(X1.dataInicioVigencia, T5.dt_assinaturaContrato)) + X1.diasCarencia)
					FROM CarenciaPersonalizada X1
					INNER JOIN GrupoCarenciaProcedimento X2 ON X2.idGrupoCarencia = X1.idGrupoCarencia
					INNER JOIN GrupoCarencia X3 ON X3.idGrupoCarencia = X2.idGrupoCarencia
					WHERE X1.cd_sequencial_dep = T5.cd_sequencial
						AND X2.cd_servico = T1.cd_servico
						AND X1.dataExclusao IS NULL
						AND X2.dataExclusao IS NULL
						AND X3.dataExclusao IS NULL
					), convert(VARCHAR, T1.qt_diascarencia), '0')
		FROM plano_servico T1
		INNER JOIN planos T2 ON T2.cd_plano = T1.cd_plano
		INNER JOIN servico T3 ON T3.cd_servico = T1.cd_servico
		INNER JOIN especialidade T4 ON T4.cd_especialidade = T3.cd_especialidadereferencia
		INNER JOIN dependentes T5 ON 1 = 1
		WHERE 1 = 1
			AND T1.cd_plano = T5.cd_plano
			AND T1.cd_servico = @cd_servico
			AND T5.cd_sequencial = @cd_sequencial_dep

		IF (convert(SMALLINT, replace(@infoCarencia, 'DIASCARENCIAREFHOJE', ''))) < 0
		BEGIN
			SET @infoCarencia = '0'
		END

		SET @qt_diascarencia = convert(SMALLINT, replace(@infoCarencia, 'DIASCARENCIAREFHOJE', ''))
	END

	--**************************************************************************
	--**************************************************************************
	--Data de referência
	--**************************************************************************
	SELECT @Data = CASE 
			WHEN CHARINDEX('DIASCARENCIAREFHOJE', @infoCarencia) > 0
				THEN convert(VARCHAR(10), getdate(), 103)
			WHEN T1.rcaId IS NOT NULL
				THEN CASE 
						WHEN T5.tcaId = 2
							THEN convert(VARCHAR(10), T1.dt_assinaturaContrato, 103)
						WHEN T5.tcaId = 3
							THEN Right('00' + convert(VARCHAR, T3.dt_vencimento), 2) + '/' + Right(convert(VARCHAR, mm_aaaa_1pagamento), 2) + '/' + substring(convert(VARCHAR, mm_aaaa_1pagamento), 1, 4)
						WHEN T5.tcaId = 4
							THEN (
									SELECT convert(VARCHAR(10), min(dt_pagamento), 103)
									FROM mensalidades TT1,
										mensalidades_planos TT2
									WHERE TT1.cd_parcela = TT2.cd_parcela_mensalidade
										AND TT2.cd_sequencial_dep = T1.cd_sequencial
										AND TT1.dt_pagamento >= T1.dt_assinaturaContrato
										AND TT1.cd_tipo_recebimento != 1
									)
						WHEN T5.tcaId = 5
							THEN (
									SELECT convert(VARCHAR(10), min(dt_pagamento), 103)
									FROM mensalidades TT1,
										mensalidades_planos TT2
									WHERE TT1.cd_parcela = TT2.cd_parcela_mensalidade
										AND TT2.cd_sequencial_dep = T1.cd_sequencial
										AND TT1.cd_tipo_recebimento != 1
									)
						WHEN T5.tcaId = 6
							THEN (
									SELECT convert(VARCHAR(10), min(TT1.dt_vencimento), 103)
									FROM mensalidades TT1,
										mensalidades_planos TT2
									WHERE TT1.cd_parcela = TT2.cd_parcela_mensalidade
										AND TT2.cd_sequencial_dep = T1.cd_sequencial
										AND TT1.dt_vencimento >= T1.dt_assinaturaContrato
										AND TT1.cd_tipo_recebimento != 1
									)
						WHEN T5.tcaId = 7
							THEN convert(VARCHAR(10), T1.dt_inicio_cobertura, 103)
						WHEN T5.tcaId = 8
							THEN '01/' + Right(convert(VARCHAR, mm_aaaa_1pagamento), 2) + '/' + substring(convert(VARCHAR, mm_aaaa_1pagamento), 1, 4)
						ELSE ''
						END
			ELSE CASE 
					WHEN T4.tcaId = 2
						THEN convert(VARCHAR(10), T1.dt_assinaturaContrato, 103)
					WHEN T4.tcaId = 3
						THEN Right('00' + convert(VARCHAR, T3.dt_vencimento), 2) + '/' + Right(convert(VARCHAR, mm_aaaa_1pagamento), 2) + '/' + substring(convert(VARCHAR, mm_aaaa_1pagamento), 1, 4)
					WHEN T4.tcaId = 4
						THEN (
								SELECT convert(VARCHAR(10), min(dt_pagamento), 103)
								FROM mensalidades TT1,
									mensalidades_planos TT2
								WHERE TT1.cd_parcela = TT2.cd_parcela_mensalidade
									AND TT2.cd_sequencial_dep = T1.cd_sequencial
									AND TT1.dt_pagamento >= T1.dt_assinaturaContrato
									AND TT1.cd_tipo_recebimento != 1
								)
					WHEN T4.tcaId = 5
						THEN (
								SELECT convert(VARCHAR(10), min(dt_pagamento), 103)
								FROM mensalidades TT1,
									mensalidades_planos TT2
								WHERE TT1.cd_parcela = TT2.cd_parcela_mensalidade
									AND TT2.cd_sequencial_dep = T1.cd_sequencial
									AND TT1.cd_tipo_recebimento != 1
								)
					WHEN T4.tcaId = 6
						THEN (
								SELECT convert(VARCHAR(10), min(TT1.dt_vencimento), 103)
								FROM mensalidades TT1,
									mensalidades_planos TT2
								WHERE TT1.cd_parcela = TT2.cd_parcela_mensalidade
									AND TT2.cd_sequencial_dep = T1.cd_sequencial
									AND TT1.dt_vencimento >= T1.dt_assinaturaContrato
									AND TT1.cd_tipo_recebimento != 1
								)
					WHEN T4.tcaId = 7
						THEN convert(VARCHAR(10), T1.dt_inicio_cobertura, 103)
					WHEN T4.tcaId = 8
						THEN '01/' + Right(convert(VARCHAR, mm_aaaa_1pagamento), 2) + '/' + substring(convert(VARCHAR, mm_aaaa_1pagamento), 1, 4)
					ELSE ''
					END
			END,
		@tp_empresa = T3.tp_empresa,
		@fl_CarenciaAtendimento = isnull(convert(INT, T1.fl_CarenciaAtendimento), 1),
		@fl_CarenciaAtendimentoPlano = convert(INT, T6.fl_CarenciaAtendimentoPlano),
		@fl_CarenciaAtendimentoEmpresa = isnull(convert(INT, T3.fl_CarenciaAtendimentoEmpresa), 1),
		@dt_assinaturaContrato = convert(VARCHAR(10), T1.dt_assinaturaContrato, 101),
		@inicioContagemDiasCarencia = isnull(convert(INT, T7.inicioContagemDiasCarencia), 1),
		@ADD_diasRCA = coalesce(T4.qt_dias_clinico, T5.qt_dias_clinico, 0)
	FROM DEPENDENTES AS T1
	INNER JOIN ASSOCIADOS AS T2 ON T1.CD_ASSOCIADO = T2.cd_associado
	INNER JOIN EMPRESA AS T3 ON T2.cd_empresa = T3.CD_EMPRESA
	INNER JOIN RegraCarenciaAtendimento AS T4 ON T3.rcaId = T4.rcaID
	LEFT OUTER JOIN RegraCarenciaAtendimento AS T5 ON T1.rcaId = T5.rcaID
	INNER JOIN PLANOS AS T6 ON T1.cd_plano = T6.cd_plano
	CROSS JOIN Configuracao AS T7
	WHERE (T4.dt_exclusao IS NULL)
		AND (T5.dt_exclusao IS NULL)
		AND (T1.CD_SEQUENCIAL = @cd_sequencial_dep)

	IF (
			@tp_empresa >= 10
			OR @fl_CarenciaAtendimento = 0
			OR @fl_CarenciaAtendimentoPlano = 0
			OR @fl_CarenciaAtendimentoEmpresa = 0
			)
	BEGIN
		SET @dataTEMP = dateadd(day, @inicioContagemDiasCarencia + @ADD_diasRCA + @ADD_dias, @dt_assinaturaContrato)
		SET @DataRetorno = convert(VARCHAR(10), @dataTEMP, 103)

		IF (
				@licenca = '0083WENFKEOFNOKMFKKERNPFKRNPOKOKFMMKDMVNIRNG9PGRP'
				OR @licenca = 'HYYT76658HFKJNXBEY46WUYU1276745JHFJDHJDFDVCGFD020'
				)
		BEGIN
			SET @DataRetorno = substring(@DataRetorno, 1, 2) + '/' + substring(@DataRetorno, 4, 2) + '/' + substring(@DataRetorno, 9, 2)
		END

		RETURN @DataRetorno
	END

	IF (
			@Data IS NULL
			OR @Data = ''
			)
	BEGIN
		RETURN 'CARÊNCIA'
	END

	SET @dataTEMP = convert(DATE, substring(@Data, 4, 2) + '/' + substring(@Data, 1, 2) + '/' + substring(@Data, 7, 4))
	SET @dataTEMP = dateadd(day, @inicioContagemDiasCarencia + @ADD_diasRCA + @ADD_dias + @qt_diascarencia, @dataTEMP)
	SET @DataRetorno = convert(VARCHAR(10), @dataTEMP, 103)

	IF (
			@licenca = '0083WENFKEOFNOKMFKKERNPFKRNPOKOKFMMKDMVNIRNG9PGRP'
			OR @licenca = 'HYYT76658HFKJNXBEY46WUYU1276745JHFJDHJDFDVCGFD020'
			)
	BEGIN
		SET @DataRetorno = substring(@DataRetorno, 1, 2) + '/' + substring(@DataRetorno, 4, 2) + '/' + substring(@DataRetorno, 9, 2)
	END

	RETURN @DataRetorno
END
