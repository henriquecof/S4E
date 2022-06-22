/****** Object:  Procedure [dbo].[SP_Autoriza_Agenda]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[SP_Autoriza_Agenda] (@cd_SequencialAgenda INT) -- Sequencial da Agenda
AS
BEGIN
	DECLARE @cd_sequencial INT

	-- Verificar todos os associados marcados para os proximos 4 dias
	IF @cd_SequencialAgenda > 0
		EXEC SP_Analisa_Cliente @cd_SequencialAgenda,
			1
	ELSE
	BEGIN -- 1
		DECLARE cursor_aut_agenda CURSOR
		FOR
		/* Pessoa Juridica Pagamento Especial, Particular e etc...*/
SELECT        a.cd_sequencial
FROM            agenda AS a LEFT OUTER JOIN
                         atuacao_dentista AS d ON a.cd_sequencial_atuacao_dent = d.cd_sequencial INNER JOIN
                         ESPECIALIDADE AS esp ON d.cd_especialidade = esp.cd_especialidade INNER JOIN
                         ASSOCIADOS AS s ON a.cd_associado = s.cd_associado INNER JOIN
                         EMPRESA AS e ON s.cd_empresa = e.CD_EMPRESA INNER JOIN
                         HISTORICO AS h ON e.CD_Sequencial_historico = h.cd_sequencial
WHERE        (h.CD_SITUACAO = 1) AND (esp.fl_autoriza_atend_automatico = 1) AND (a.dt_compromisso > DATEADD(d, - 1, GETDATE())) AND (a.dt_compromisso < DATEADD(d, 5, GETDATE())) AND (a.nr_autorizacao IS NULL) AND 
                         (e.TP_EMPRESA < 7)

		OPEN cursor_aut_agenda

		FETCH NEXT
		FROM cursor_aut_agenda
		INTO @cd_sequencial

		WHILE (@@FETCH_STATUS <> - 1)
		BEGIN -- 2 
			-- print @cd_sequencial
			EXEC SP_Analisa_Cliente @cd_sequencial,
				1

			FETCH NEXT
			FROM cursor_aut_agenda
			INTO @cd_sequencial
		END -- 2 

		CLOSE cursor_aut_agenda

		DEALLOCATE cursor_aut_agenda

		PRINT '--Remover autorizacao se usuario estiver cancelado'

		UPDATE agenda -- Titular
		SET nr_autorizacao = NULL
		FROM dependentes,
			historico,
			situacao_historico
		WHERE agenda.cd_Associado = dependentes.cd_Associado
			AND dependentes.cd_grau_parentesco = 1
			AND -- Titular 
			agenda.nr_autorizacao = 'AUTOM'
			AND agenda.dt_compromisso > getdate()
			AND agenda.dt_compromisso < dateadd(d, 5, getdate())
			AND dependentes.cd_sequencial_historico = historico.cd_sequencial
			AND historico.cd_situacao = situacao_historico.cd_situacao_historico
			AND situacao_historico.fl_atendido_clinica = 0

		PRINT '--Remover autorizacao se usuario estiver cancelado'

		UPDATE agenda -- Dependentes 
		SET nr_autorizacao = NULL
		FROM dependentes,
			historico,
			situacao_historico
		WHERE agenda.cd_sequencial_dep = dependentes.cd_sequencial
			AND dependentes.cd_grau_parentesco > 1
			AND -- Dependentes
			agenda.nr_autorizacao = 'AUTOM'
			AND agenda.dt_compromisso > getdate()
			AND agenda.dt_compromisso < dateadd(d, 5, getdate())
			AND dependentes.cd_sequencial_historico = historico.cd_sequencial
			AND historico.cd_situacao = situacao_historico.cd_situacao_historico
			AND situacao_historico.fl_atendido_clinica = 0
	END -- 1 
END
