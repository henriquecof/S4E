/****** Object:  Procedure [dbo].[PS_BuscaCliente]    Committed by VersionSQL https://www.versionsql.com ******/

/*
Objetivo : Retornar dados dos associados e dependentes
Parâmetros Entrada :
            @CD_Associado - Codigo do Associado
            @NM_Dependente - Nome do Dependente
            @Sequencial - SequencialDependente
            @cpf - cpf titular
            @tipoconsulta : 1 - codigo do associado
                            2 - código do dependente
                            3 - nome dependente
                            4 - cpf
                            5 - Data de Nascimento
			@Clinica - Código da clínica. 0 = Todas
*/
CREATE PROCEDURE [dbo].[PS_BuscaCliente] (
		@cd_associado INT,
		@nm_dependente VARCHAR(80),
		@sequencialdependente INT,
		@cpf VARCHAR(11),
		@tipoconsulta SMALLINT,
		@clinica INT,
		@dt_nascimento DATETIME = '01/01/1900')
AS
BEGIN
	--Consulta pelo codigo do associado.
	IF @tipoconsulta = 1
	BEGIN
		-- Associado e Dependentes

		SELECT DISTINCT TOP 51 T1.cd_associado,
							   T1.nm_completo AS TITULAR,
							   T1.nr_cpf,
							   ISNULL(CONVERT(INT, T1.FL_VIP), 0) FL_VIP,
							   T1.nu_matricula,
							   T2.cd_sequencial,
							   T2.nm_dependente,
							   CASE
								  WHEN T2.cd_grau_parentesco = 1 THEN 1
								  ELSE 0 END AS TITULAR,
							   CONVERT(VARCHAR(10), T2.DT_NASCIMENTO, 103) DT_NASCIMENTO,
							   ISNULL(T5.TP_EMPRESA, 0) AS TP_EMPRESA,
							   T5.cd_empresa,
							   T5.nm_fantasia,
							   T2.cd_plano,
							   T7.nm_plano,
							   T8.nome_tipo,
							   T1.endlogradouro AS NM_ENDERECO,
							   T1.endnumero AS NM_NUMERO,
							   T1.endcomplemento AS NM_COMPLEMENTO_ENDERECO,
							   T1.logcep AS NR_CEP,
							   ISNULL(T1.baiid, 0) AS CD_BAIRRO,
							   T9.baidescricao AS NM_BAIRRO,
							   T6.nm_municipio,
							   T6.cd_uf_num,
							   T10.ufsigla,
							   T4.cd_situacao_historico AS CD_SITUACAO_DEP,
							   CASE
								  WHEN T3.dt_fim_atendimento >= getdate() THEN 1
								  ELSE T4.fl_atendido_clinica END AS SIT_DEP,
							   T4.nm_situacao_historico AS NM_SITUACAO_HISTORICO_DEP,
							   D4.cd_situacao_historico SITUACAOTITULAR,
							   CASE
								  WHEN D3.dt_fim_atendimento > getdate() THEN 1
								  WHEN D4.fl_atendido_clinica = 1
								  AND E4.fl_atendido_clinica = 1 THEN 1
								  ELSE 0 END AS SIT_ASS,
							   D4.nm_situacao_historico,
							   CONVERT(INT, T7.FL_CARENCIAATENDIMENTOPLANO) FL_CARENCIAATENDIMENTOPLANO,
							   ISNULL(CONVERT(INT, T2.FL_CARENCIAATENDIMENTO), 1) FL_CARENCIAATENDIMENTO,
							   E5.ds_vip,
							   T1.cidid,
							   CONVERT(INT, T7.FL_EXIGE_DENTISTA) AS FL_EXIGE_DENTISTA,
							   ISNULL(T11.QT_DIAS_URGENCIA, 0) QT_DIAS_URGENCIA,
							   ISNULL(T11.QT_DIAS_CLINICO, 0) QT_DIAS_CLINICO,
							   T2.cd_grau_parentesco,
							   ISNULL(T2.cd_tipo_rede_atendimento, 1) CD_TIPO_REDE_ATENDIMENTOUSUARIO,
							   ISNULL(T5.cd_tipo_rede_atendimento, 1) CD_TIPO_REDE_ATENDIMENTOEMPRESA
		--FROM associados AS T1,
		--	 dependentes T2,
		--	 historico AS T3,
		--	 situacao_historico AS T4,
		--	 empresa AS T5,
		--	 municipio AS T6,
		--	 planos AS T7,
		--	 tb_tipologradouro AS T8,
		--	 bairro AS T9,
		--	 uf T10,
		--	 regracarenciaatendimento T11,
		--	 dependentes AS D2,
		--	 historico AS D3,
		--	 situacao_historico AS D4,
		--	 historico AS E3,
		--	 situacao_historico AS E4,
		--	 vip E5
		--WHERE (T1.cd_associado = @cd_associado
		--	OR T1.cd_ass = @cd_associado)
		--	AND T1.cd_associado = T2.cd_associado
		--	AND T2.cd_sequencial_historico = T3.cd_sequencial
		--	AND T3.cd_situacao = T4.cd_situacao_historico
		--	AND T1.cd_empresa = T5.cd_empresa
		--	AND T1.cidid *= T6.cd_municipio
		--	AND T1.chave_tipologradouro *= T8.chave_tipologradouro
		--	AND T1.baiid *= T9.baiid
		--	AND T2.cd_plano = T7.cd_plano
		--	AND T1.cd_associado = D2.cd_associado
		--	AND D2.cd_grau_parentesco = 1
		--	AND D2.cd_sequencial_historico = D3.cd_sequencial
		--	AND D3.cd_situacao = D4.cd_situacao_historico
		--	AND T1.ufid *= T10.ufid
		--	AND T5.cd_sequencial_historico = E3.cd_sequencial
		--	AND E3.cd_situacao = E4.cd_situacao_historico
		--	AND T1.FL_VIP *= E5.FL_VIP
		--	AND T5.rcaid *= T11.rcaid
		--ORDER BY T2.cd_grau_parentesco,
		--		 T2.nm_dependente
		FROM associados AS T1
			INNER JOIN dependentes AS T2 ON T1.cd_associado = T2.cd_associado
			INNER JOIN historico AS T3 ON T2.cd_sequencial_historico = T3.cd_sequencial
			INNER JOIN situacao_historico AS T4 ON T3.cd_situacao = T4.cd_situacao_historico
			INNER JOIN empresa AS T5 ON T1.cd_empresa = T5.cd_empresa
			LEFT OUTER JOIN municipio AS T6 ON T1.cidid = T6.cd_municipio
			LEFT OUTER JOIN tb_tipologradouro AS T8 ON T1.chave_tipologradouro = T8.chave_tipologradouro
			LEFT OUTER JOIN bairro AS T9 ON T1.baiid = T9.baiid
			INNER JOIN planos AS T7 ON T2.cd_plano = T7.cd_plano
			INNER JOIN dependentes AS D2 ON T1.cd_associado = D2.cd_associado
			INNER JOIN historico AS D3 ON D2.cd_sequencial_historico = D3.cd_sequencial
			INNER JOIN situacao_historico AS D4 ON D3.cd_situacao = D4.cd_situacao_historico
			LEFT OUTER JOIN uf AS T10 ON T1.ufid = T10.ufid
			INNER JOIN historico AS E3 ON T5.cd_sequencial_historico = E3.cd_sequencial
			INNER JOIN situacao_historico AS E4 ON E3.cd_situacao = E4.cd_situacao_historico
			LEFT OUTER JOIN vip AS E5 ON T1.FL_VIP = E5.FL_VIP
			LEFT OUTER JOIN regracarenciaatendimento AS T11 ON T5.rcaid = T11.rcaid
		WHERE (T1.cd_associado = @cd_associado)
			AND (D2.cd_grau_parentesco = 1)
			OR (D2.cd_grau_parentesco = 1)
			AND (T1.cd_ass = @cd_associado)
		ORDER BY T2.cd_grau_parentesco,
				 T2.nm_dependente

	END

	--Codigo do Dependente
	IF @tipoconsulta = 2
	BEGIN
		-- Apresenta o Dependente e a Situacao do Associado e Dependentes. Se alguma das situacoes nao for 1 o usuário nao pode marcar consulta
		SELECT DISTINCT TOP 51 T1.cd_associado,
							   T1.nm_completo AS TITULAR,
							   T1.nr_cpf,
							   ISNULL(CONVERT(INT, T1.FL_VIP), 0) FL_VIP,
							   T1.nu_matricula,
							   T2.cd_sequencial,
							   T2.nm_dependente,
							   CASE
								  WHEN T2.cd_grau_parentesco = 1 THEN 1
								  ELSE 0 END AS TITULAR,
							   CONVERT(VARCHAR(10), T2.DT_NASCIMENTO, 103) DT_NASCIMENTO,
							   ISNULL(T5.TP_EMPRESA, 0) AS TP_EMPRESA,
							   T5.cd_empresa,
							   T5.nm_fantasia,
							   T2.cd_plano,
							   T7.nm_plano,
							   T8.nome_tipo,
							   T1.endlogradouro AS NM_ENDERECO,
							   T1.endnumero AS NM_NUMERO,
							   T1.endcomplemento AS NM_COMPLEMENTO_ENDERECO,
							   T1.logcep AS NR_CEP,
							   ISNULL(T1.baiid, 0) AS CD_BAIRRO,
							   T9.baidescricao AS NM_BAIRRO,
							   T6.nm_municipio,
							   T6.cd_uf_num,
							   T10.ufsigla,
							   T4.cd_situacao_historico AS CD_SITUACAO_DEP,
							   CASE
								  WHEN T3.dt_fim_atendimento >= getdate() THEN 1
								  ELSE T4.fl_atendido_clinica END AS SIT_DEP,
							   T4.nm_situacao_historico AS NM_SITUACAO_HISTORICO_DEP,
							   D4.cd_situacao_historico SITUACAOTITULAR,
							   CASE
								  WHEN D3.dt_fim_atendimento > getdate() THEN 1
								  WHEN D4.fl_atendido_clinica = 1
								  AND E4.fl_atendido_clinica = 1 THEN 1
								  ELSE 0 END AS SIT_ASS,
							   D4.nm_situacao_historico,
							   CONVERT(INT, T7.FL_CARENCIAATENDIMENTOPLANO) FL_CARENCIAATENDIMENTOPLANO,
							   ISNULL(CONVERT(INT, T2.FL_CARENCIAATENDIMENTO), 1) FL_CARENCIAATENDIMENTO,
							   E5.ds_vip,
							   T1.cidid,
							   CONVERT(INT, T7.FL_EXIGE_DENTISTA) AS FL_EXIGE_DENTISTA,
							   ISNULL(T11.QT_DIAS_URGENCIA, 0) QT_DIAS_URGENCIA,
							   ISNULL(T11.QT_DIAS_CLINICO, 0) QT_DIAS_CLINICO,
							   T2.cd_grau_parentesco,
							   ISNULL(T2.cd_tipo_rede_atendimento, 1) CD_TIPO_REDE_ATENDIMENTOUSUARIO,
							   ISNULL(T5.cd_tipo_rede_atendimento, 1) CD_TIPO_REDE_ATENDIMENTOEMPRESA
		--FROM associados AS T1,
		--	 dependentes T2,
		--	 historico AS T3,
		--	 situacao_historico AS T4,
		--	 empresa AS T5,
		--	 municipio AS T6,
		--	 planos AS T7,
		--	 tb_tipologradouro AS T8,
		--	 bairro AS T9,
		--	 uf T10,
		--	 regracarenciaatendimento T11,
		--	 dependentes AS D2,
		--	 historico AS D3,
		--	 situacao_historico AS D4,
		--	 historico AS E3,
		--	 situacao_historico AS E4,
		--	 vip E5
		--WHERE T2.cd_sequencial = @sequencialdependente
		--	AND T1.cd_associado = T2.cd_associado
		--	AND T2.cd_sequencial_historico = T3.cd_sequencial
		--	AND T3.cd_situacao = T4.cd_situacao_historico
		--	AND T1.cd_empresa = T5.cd_empresa
		--	AND T1.cidid *= T6.cd_municipio
		--	AND T1.chave_tipologradouro *= T8.chave_tipologradouro
		--	AND T1.baiid *= T9.baiid
		--	AND T2.cd_plano = T7.cd_plano
		--	AND T1.cd_associado = D2.cd_associado
		--	AND D2.cd_grau_parentesco = 1
		--	AND D2.cd_sequencial_historico = D3.cd_sequencial
		--	AND D3.cd_situacao = D4.cd_situacao_historico
		--	AND T1.ufid *= T10.ufid
		--	AND T5.cd_sequencial_historico = E3.cd_sequencial
		--	AND E3.cd_situacao = E4.cd_situacao_historico
		--	AND T1.FL_VIP *= E5.FL_VIP
		--	AND T5.rcaid *= T11.rcaid
		--ORDER BY T2.cd_grau_parentesco,
		--		 T2.nm_dependente
		FROM associados AS T1
			INNER JOIN dependentes AS T2 ON T1.cd_associado = T2.cd_associado
			INNER JOIN historico AS T3 ON T2.cd_sequencial_historico = T3.cd_sequencial
			INNER JOIN situacao_historico AS T4 ON T3.cd_situacao = T4.cd_situacao_historico
			INNER JOIN empresa AS T5 ON T1.cd_empresa = T5.cd_empresa
			LEFT OUTER JOIN municipio AS T6 ON T1.cidid = T6.cd_municipio
			LEFT OUTER JOIN tb_tipologradouro AS T8 ON T1.chave_tipologradouro = T8.chave_tipologradouro
			LEFT OUTER JOIN bairro AS T9 ON T1.baiid = T9.baiid
			INNER JOIN planos AS T7 ON T2.cd_plano = T7.cd_plano
			INNER JOIN dependentes AS D2 ON T1.cd_associado = D2.cd_associado
			INNER JOIN historico AS D3 ON D2.cd_sequencial_historico = D3.cd_sequencial
			INNER JOIN situacao_historico AS D4 ON D3.cd_situacao = D4.cd_situacao_historico
			LEFT OUTER JOIN uf AS T10 ON T1.ufid = T10.ufid
			INNER JOIN historico AS E3 ON T5.cd_sequencial_historico = E3.cd_sequencial
			INNER JOIN situacao_historico AS E4 ON E3.cd_situacao = E4.cd_situacao_historico
			LEFT OUTER JOIN vip AS E5 ON T1.FL_VIP = E5.FL_VIP
			LEFT OUTER JOIN regracarenciaatendimento AS T11 ON T5.rcaid = T11.rcaid
		WHERE (T2.cd_sequencial = @sequencialdependente)
			AND (D2.cd_grau_parentesco = 1)
		ORDER BY T2.cd_grau_parentesco,
				 T2.nm_dependente
	END

	--Nome do dependente
	IF @tipoconsulta = 3
	BEGIN
		-- Apresenta o Dependente e a Situacao do Associado e Dependentes. Se alguma das situacoes nao for 1 o usuário nao pode marcar consulta
		SELECT DISTINCT TOP 51 T1.cd_associado,
							   T1.nm_completo AS TITULAR,
							   T1.nr_cpf,
							   ISNULL(CONVERT(INT, T1.FL_VIP), 0) FL_VIP,
							   T1.nu_matricula,
							   T2.cd_sequencial,
							   T2.nm_dependente,
							   CASE
								  WHEN T2.cd_grau_parentesco = 1 THEN 1
								  ELSE 0 END AS TITULAR,
							   CONVERT(VARCHAR(10), T2.DT_NASCIMENTO, 103) DT_NASCIMENTO,
							   ISNULL(T5.TP_EMPRESA, 0) AS TP_EMPRESA,
							   T5.cd_empresa,
							   T5.nm_fantasia,
							   T2.cd_plano,
							   T7.nm_plano,
							   T8.nome_tipo,
							   T1.endlogradouro AS NM_ENDERECO,
							   T1.endnumero AS NM_NUMERO,
							   T1.endcomplemento AS NM_COMPLEMENTO_ENDERECO,
							   T1.logcep AS NR_CEP,
							   ISNULL(T1.baiid, 0) AS CD_BAIRRO,
							   T9.baidescricao AS NM_BAIRRO,
							   T6.nm_municipio,
							   T6.cd_uf_num,
							   T10.ufsigla,
							   T4.cd_situacao_historico AS CD_SITUACAO_DEP,
							   CASE
								  WHEN T3.dt_fim_atendimento >= getdate() THEN 1
								  ELSE T4.fl_atendido_clinica END AS SIT_DEP,
							   T4.nm_situacao_historico AS NM_SITUACAO_HISTORICO_DEP,
							   D4.cd_situacao_historico SITUACAOTITULAR,
							   CASE
								  WHEN D3.dt_fim_atendimento > getdate() THEN 1
								  WHEN D4.fl_atendido_clinica = 1
								  AND E4.fl_atendido_clinica = 1 THEN 1
								  ELSE 0 END AS SIT_ASS,
							   D4.nm_situacao_historico,
							   CONVERT(INT, T7.FL_CARENCIAATENDIMENTOPLANO) FL_CARENCIAATENDIMENTOPLANO,
							   ISNULL(CONVERT(INT, T2.FL_CARENCIAATENDIMENTO), 1) FL_CARENCIAATENDIMENTO,
							   E5.ds_vip,
							   T1.cidid,
							   CONVERT(INT, T7.FL_EXIGE_DENTISTA) AS FL_EXIGE_DENTISTA,
							   ISNULL(T11.QT_DIAS_URGENCIA, 0) QT_DIAS_URGENCIA,
							   ISNULL(T11.QT_DIAS_CLINICO, 0) QT_DIAS_CLINICO,
							   T2.cd_grau_parentesco,
							   ISNULL(T2.cd_tipo_rede_atendimento, 1) CD_TIPO_REDE_ATENDIMENTOUSUARIO,
							   ISNULL(T5.cd_tipo_rede_atendimento, 1) CD_TIPO_REDE_ATENDIMENTOEMPRESA
		--FROM associados AS T1,
		--	 dependentes T2,
		--	 historico AS T3,
		--	 situacao_historico AS T4,
		--	 empresa AS T5,
		--	 municipio AS T6,
		--	 planos AS T7,
		--	 tb_tipologradouro AS T8,
		--	 bairro AS T9,
		--	 uf T10,
		--	 regracarenciaatendimento T11,
		--	 dependentes AS D2,
		--	 historico AS D3,
		--	 situacao_historico AS D4,
		--	 historico AS E3,
		--	 situacao_historico AS E4,
		--	 vip E5
		--WHERE T1.cd_associado = T2.cd_associado
		--	AND T2.cd_sequencial_historico = T3.cd_sequencial
		--	AND T3.cd_situacao = T4.cd_situacao_historico
		--	AND T1.cd_empresa = T5.cd_empresa
		--	AND T1.cidid *= T6.cd_municipio
		--	AND T1.chave_tipologradouro *= T8.chave_tipologradouro
		--	AND T1.baiid *= T9.baiid
		--	AND T2.cd_plano = T7.cd_plano
		--	AND T1.cd_associado = D2.cd_associado
		--	AND D2.cd_grau_parentesco = 1
		--	AND D2.cd_sequencial_historico = D3.cd_sequencial
		--	AND D3.cd_situacao = D4.cd_situacao_historico
		--	AND T2.nm_dependente LIKE @nm_dependente + '%'
		--	AND T1.ufid *= T10.ufid
		--	AND T5.cd_sequencial_historico = E3.cd_sequencial
		--	AND E3.cd_situacao = E4.cd_situacao_historico
		--	AND T1.FL_VIP *= E5.FL_VIP
		--	AND T5.rcaid *= T11.rcaid
		--ORDER BY T2.cd_grau_parentesco,
		--		 T2.nm_dependente
		FROM associados AS T1
			INNER JOIN dependentes AS T2 ON T1.cd_associado = T2.cd_associado
			INNER JOIN historico AS T3 ON T2.cd_sequencial_historico = T3.cd_sequencial
			INNER JOIN situacao_historico AS T4 ON T3.cd_situacao = T4.cd_situacao_historico
			INNER JOIN empresa AS T5 ON T1.cd_empresa = T5.cd_empresa
			LEFT OUTER JOIN municipio AS T6 ON T1.cidid = T6.cd_municipio
			LEFT OUTER JOIN tb_tipologradouro AS T8 ON T1.chave_tipologradouro = T8.chave_tipologradouro
			LEFT OUTER JOIN bairro AS T9 ON T1.baiid = T9.baiid
			INNER JOIN planos AS T7 ON T2.cd_plano = T7.cd_plano
			INNER JOIN dependentes AS D2 ON T1.cd_associado = D2.cd_associado
			INNER JOIN historico AS D3 ON D2.cd_sequencial_historico = D3.cd_sequencial
			INNER JOIN situacao_historico AS D4 ON D3.cd_situacao = D4.cd_situacao_historico
			LEFT OUTER JOIN uf AS T10 ON T1.ufid = T10.ufid
			INNER JOIN historico AS E3 ON T5.cd_sequencial_historico = E3.cd_sequencial
			INNER JOIN situacao_historico AS E4 ON E3.cd_situacao = E4.cd_situacao_historico
			LEFT OUTER JOIN vip AS E5 ON T1.FL_VIP = E5.FL_VIP
			LEFT OUTER JOIN regracarenciaatendimento AS T11 ON T5.rcaid = T11.rcaid
		WHERE (D2.cd_grau_parentesco = 1)
			AND (T2.nm_dependente LIKE @nm_dependente + '%')
		ORDER BY T2.cd_grau_parentesco,
				 T2.nm_dependente
	END

	-- CPF do titular
	IF @tipoconsulta = 4
	BEGIN
		-- Apresenta o Dependente e a Situacao do Associado e Dependentes. Se alguma das situacoes nao for 1 o usuário nao pode marcar consulta

		SELECT DISTINCT TOP 51 T1.cd_associado,
							   T1.nm_completo AS TITULAR,
							   T1.nr_cpf,
							   ISNULL(CONVERT(INT, T1.FL_VIP), 0) FL_VIP,
							   T1.nu_matricula,
							   T2.cd_sequencial,
							   T2.nm_dependente,
							   CASE
								  WHEN T2.cd_grau_parentesco = 1 THEN 1
								  ELSE 0 END AS TITULAR,
							   CONVERT(VARCHAR(10), T2.DT_NASCIMENTO, 103) DT_NASCIMENTO,
							   ISNULL(T5.TP_EMPRESA, 0) AS TP_EMPRESA,
							   T5.cd_empresa,
							   T5.nm_fantasia,
							   T2.cd_plano,
							   T7.nm_plano,
							   T8.nome_tipo,
							   T1.endlogradouro AS NM_ENDERECO,
							   T1.endnumero AS NM_NUMERO,
							   T1.endcomplemento AS NM_COMPLEMENTO_ENDERECO,
							   T1.logcep AS NR_CEP,
							   ISNULL(T1.baiid, 0) AS CD_BAIRRO,
							   T9.baidescricao AS NM_BAIRRO,
							   T6.nm_municipio,
							   T6.cd_uf_num,
							   T10.ufsigla,
							   T4.cd_situacao_historico AS CD_SITUACAO_DEP,
							   CASE
								  WHEN T3.dt_fim_atendimento >= getdate() THEN 1
								  ELSE T4.fl_atendido_clinica END AS SIT_DEP,
							   T4.nm_situacao_historico AS NM_SITUACAO_HISTORICO_DEP,
							   D4.cd_situacao_historico SITUACAOTITULAR,
							   CASE
								  WHEN D3.dt_fim_atendimento > getdate() THEN 1
								  WHEN D4.fl_atendido_clinica = 1
								  AND E4.fl_atendido_clinica = 1 THEN 1
								  ELSE 0 END AS SIT_ASS,
							   D4.nm_situacao_historico,
							   CONVERT(INT, T7.FL_CARENCIAATENDIMENTOPLANO) FL_CARENCIAATENDIMENTOPLANO,
							   ISNULL(CONVERT(INT, T2.FL_CARENCIAATENDIMENTO), 1) FL_CARENCIAATENDIMENTO,
							   E5.ds_vip,
							   T1.cidid,
							   CONVERT(INT, T7.FL_EXIGE_DENTISTA) AS FL_EXIGE_DENTISTA,
							   ISNULL(T11.QT_DIAS_URGENCIA, 0) QT_DIAS_URGENCIA,
							   ISNULL(T11.QT_DIAS_CLINICO, 0) QT_DIAS_CLINICO,
							   T2.cd_grau_parentesco,
							   ISNULL(T2.cd_tipo_rede_atendimento, 1) CD_TIPO_REDE_ATENDIMENTOUSUARIO,
							   ISNULL(T5.cd_tipo_rede_atendimento, 1) CD_TIPO_REDE_ATENDIMENTOEMPRESA
		--FROM associados AS T1,
		--	 dependentes T2,
		--	 historico AS T3,
		--	 situacao_historico AS T4,
		--	 empresa AS T5,
		--	 municipio AS T6,
		--	 planos AS T7,
		--	 tb_tipologradouro AS T8,
		--	 bairro AS T9,
		--	 uf T10,
		--	 regracarenciaatendimento T11,
		--	 dependentes AS D2,
		--	 historico AS D3,
		--	 situacao_historico AS D4,
		--	 historico AS E3,
		--	 situacao_historico AS E4,
		--	 vip E5
		--WHERE T1.nr_cpf = @cpf
		--	AND T1.cd_associado = T2.cd_associado
		--	AND T2.cd_sequencial_historico = T3.cd_sequencial
		--	AND T3.cd_situacao = T4.cd_situacao_historico
		--	AND T1.cd_empresa = T5.cd_empresa
		--	AND T1.cidid *= T6.cd_municipio
		--	AND T1.chave_tipologradouro *= T8.chave_tipologradouro
		--	AND T1.baiid *= T9.baiid
		--	AND T2.cd_plano = T7.cd_plano
		--	AND T1.cd_associado = D2.cd_associado
		--	AND D2.cd_grau_parentesco = 1
		--	AND D2.cd_sequencial_historico = D3.cd_sequencial
		--	AND D3.cd_situacao = D4.cd_situacao_historico
		--	AND T1.ufid *= T10.ufid
		--	AND T5.cd_sequencial_historico = E3.cd_sequencial
		--	AND E3.cd_situacao = E4.cd_situacao_historico
		--	AND T1.FL_VIP *= E5.FL_VIP
		--	AND T5.rcaid *= T11.rcaid
		--ORDER BY T2.cd_grau_parentesco,
		--		 T2.nm_dependente
		FROM associados AS T1
			INNER JOIN dependentes AS T2 ON T1.cd_associado = T2.cd_associado
			INNER JOIN historico AS T3 ON T2.cd_sequencial_historico = T3.cd_sequencial
			INNER JOIN situacao_historico AS T4 ON T3.cd_situacao = T4.cd_situacao_historico
			INNER JOIN empresa AS T5 ON T1.cd_empresa = T5.cd_empresa
			LEFT OUTER JOIN municipio AS T6 ON T1.cidid = T6.cd_municipio
			LEFT OUTER JOIN tb_tipologradouro AS T8 ON T1.chave_tipologradouro = T8.chave_tipologradouro
			LEFT OUTER JOIN bairro AS T9 ON T1.baiid = T9.baiid
			INNER JOIN planos AS T7 ON T2.cd_plano = T7.cd_plano
			INNER JOIN dependentes AS D2 ON T1.cd_associado = D2.cd_associado
			INNER JOIN historico AS D3 ON D2.cd_sequencial_historico = D3.cd_sequencial
			INNER JOIN situacao_historico AS D4 ON D3.cd_situacao = D4.cd_situacao_historico
			LEFT OUTER JOIN uf AS T10 ON T1.ufid = T10.ufid
			INNER JOIN historico AS E3 ON T5.cd_sequencial_historico = E3.cd_sequencial
			INNER JOIN situacao_historico AS E4 ON E3.cd_situacao = E4.cd_situacao_historico
			LEFT OUTER JOIN vip AS E5 ON T1.FL_VIP = E5.FL_VIP
			LEFT OUTER JOIN regracarenciaatendimento AS T11 ON T5.rcaid = T11.rcaid
		WHERE (T1.nr_cpf = @cpf)
			AND (D2.cd_grau_parentesco = 1)
		ORDER BY T2.cd_grau_parentesco,
				 T2.nm_dependente
	END

	-- Data de Nascimento    
	IF @tipoconsulta = 5
	BEGIN
		-- Apresenta o Dependente e a Situacao do Associado e Dependentes. Se alguma das situacoes nao for 1 o usuário nao pode marcar consulta
		SELECT DISTINCT TOP 101 T1.cd_associado,
								T1.nm_completo AS TITULAR,
								T1.nr_cpf,
								ISNULL(CONVERT(INT, T1.FL_VIP), 0) FL_VIP,
								T1.nu_matricula,
								T2.cd_sequencial,
								T2.nm_dependente,
								CASE
								   WHEN T2.cd_grau_parentesco = 1 THEN 1
								   ELSE 0 END AS TITULAR,
								CONVERT(VARCHAR(10), T2.DT_NASCIMENTO, 103) DT_NASCIMENTO,
								ISNULL(T5.TP_EMPRESA, 0) AS TP_EMPRESA,
								T5.cd_empresa,
								T5.nm_fantasia,
								T2.cd_plano,
								T7.nm_plano,
								T8.nome_tipo,
								T1.endlogradouro AS NM_ENDERECO,
								T1.endnumero AS NM_NUMERO,
								T1.endcomplemento AS NM_COMPLEMENTO_ENDERECO,
								T1.logcep AS NR_CEP,
								ISNULL(T1.baiid, 0) AS CD_BAIRRO,
								T9.baidescricao AS NM_BAIRRO,
								T6.nm_municipio,
								T6.cd_uf_num,
								T10.ufsigla,
								T4.cd_situacao_historico AS CD_SITUACAO_DEP,
								CASE
								   WHEN T3.dt_fim_atendimento >= getdate() THEN 1
								   ELSE T4.fl_atendido_clinica END AS SIT_DEP,
								T4.nm_situacao_historico AS NM_SITUACAO_HISTORICO_DEP,
								D4.cd_situacao_historico SITUACAOTITULAR,
								CASE
								   WHEN D3.dt_fim_atendimento > getdate() THEN 1
								   WHEN D4.fl_atendido_clinica = 1
								   AND E4.fl_atendido_clinica = 1 THEN 1
								   ELSE 0 END AS SIT_ASS,
								D4.nm_situacao_historico,
								CONVERT(INT, T7.FL_CARENCIAATENDIMENTOPLANO) FL_CARENCIAATENDIMENTOPLANO,
								ISNULL(CONVERT(INT, T2.FL_CARENCIAATENDIMENTO), 1) FL_CARENCIAATENDIMENTO,
								E5.ds_vip,
								T1.cidid,
								CONVERT(INT, T7.FL_EXIGE_DENTISTA) AS FL_EXIGE_DENTISTA,
								ISNULL(T11.QT_DIAS_URGENCIA, 0) QT_DIAS_URGENCIA,
								ISNULL(T11.QT_DIAS_CLINICO, 0) QT_DIAS_CLINICO,
								T2.cd_grau_parentesco,
								ISNULL(T2.cd_tipo_rede_atendimento, 1) CD_TIPO_REDE_ATENDIMENTOUSUARIO,
								ISNULL(T5.cd_tipo_rede_atendimento, 1) CD_TIPO_REDE_ATENDIMENTOEMPRESA
		--FROM associados AS T1,
		--	 dependentes T2,
		--	 historico AS T3,
		--	 situacao_historico AS T4,
		--	 empresa AS T5,
		--	 municipio AS T6,
		--	 planos AS T7,
		--	 tb_tipologradouro AS T8,
		--	 bairro AS T9,
		--	 uf T10,
		--	 regracarenciaatendimento T11,
		--	 dependentes AS D2,
		--	 historico AS D3,
		--	 situacao_historico AS D4,
		--	 historico AS E3,
		--	 situacao_historico AS E4,
		--	 vip E5
		--WHERE T2.DT_NASCIMENTO = @dt_nascimento
		--	AND T1.cd_associado = T2.cd_associado
		--	AND T2.cd_sequencial_historico = T3.cd_sequencial
		--	AND T3.cd_situacao = T4.cd_situacao_historico
		--	AND T1.cd_empresa = T5.cd_empresa
		--	AND T1.cidid *= T6.cd_municipio
		--	AND T1.chave_tipologradouro *= T8.chave_tipologradouro
		--	AND T1.baiid *= T9.baiid
		--	AND T2.cd_plano = T7.cd_plano
		--	AND T1.cd_associado = D2.cd_associado
		--	AND D2.cd_grau_parentesco = 1
		--	AND D2.cd_sequencial_historico = D3.cd_sequencial
		--	AND D3.cd_situacao = D4.cd_situacao_historico
		--	AND T1.ufid *= T10.ufid
		--	AND T5.cd_sequencial_historico = E3.cd_sequencial
		--	AND E3.cd_situacao = E4.cd_situacao_historico
		--	AND T1.FL_VIP *= E5.FL_VIP
		--	AND T5.rcaid *= T11.rcaid
		--ORDER BY T2.cd_grau_parentesco,
		--		 T2.nm_dependente
		FROM associados AS T1
			INNER JOIN dependentes AS T2 ON T1.cd_associado = T2.cd_associado
			INNER JOIN historico AS T3 ON T2.cd_sequencial_historico = T3.cd_sequencial
			INNER JOIN situacao_historico AS T4 ON T3.cd_situacao = T4.cd_situacao_historico
			INNER JOIN empresa AS T5 ON T1.cd_empresa = T5.cd_empresa
			LEFT OUTER JOIN municipio AS T6 ON T1.cidid = T6.cd_municipio
			LEFT OUTER JOIN tb_tipologradouro AS T8 ON T1.chave_tipologradouro = T8.chave_tipologradouro
			LEFT OUTER JOIN bairro AS T9 ON T1.baiid = T9.baiid
			INNER JOIN planos AS T7 ON T2.cd_plano = T7.cd_plano
			INNER JOIN dependentes AS D2 ON T1.cd_associado = D2.cd_associado
			INNER JOIN historico AS D3 ON D2.cd_sequencial_historico = D3.cd_sequencial
			INNER JOIN situacao_historico AS D4 ON D3.cd_situacao = D4.cd_situacao_historico
			LEFT OUTER JOIN uf AS T10 ON T1.ufid = T10.ufid
			INNER JOIN historico AS E3 ON T5.cd_sequencial_historico = E3.cd_sequencial
			INNER JOIN situacao_historico AS E4 ON E3.cd_situacao = E4.cd_situacao_historico
			LEFT OUTER JOIN vip AS E5 ON T1.FL_VIP = E5.FL_VIP
			LEFT OUTER JOIN regracarenciaatendimento AS T11 ON T5.rcaid = T11.rcaid
		WHERE (T2.DT_NASCIMENTO = @dt_nascimento)
			AND (D2.cd_grau_parentesco = 1)
		ORDER BY T2.cd_grau_parentesco,
				 T2.nm_dependente
	END
END
