/****** Object:  Procedure [dbo].[importaaverbacao]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[importaaverbacao]
	@cd_sequencial INT
-- =============================================
-- Author:      henrique.almeida
-- Create date: 13/09/2021 10:49
-- Database:    S4ECLEAN
-- Description: REALIZADO PADRONIZAÇÃO E FORMATAÇÃO DE ESTILO T-SQL
-- REALIZAR DOCUMENTAÇÃO DA PROCEDURE USANDO EXTENDED PROPERTIES
-- =============================================


AS BEGIN

		BEGIN TRANSACTION

		DECLARE @cd_sequencial_old INT

		--SELECT
		--      	@cd_sequencial_old = MAX(a1.cd_sequencial)
		--      FROM Averbacao_lote AS a1,
		--      	(SELECT
		--           	cd_tipo_pagamento ,
		--           	cd_tipo_servico_bancario
		--           FROM Averbacao_lote
		--           WHERE cd_sequencial = 6
		--      	) AS a2
		--      WHERE a1.cd_tipo_pagamento = a2.cd_tipo_pagamento
		--      AND a1.cd_tipo_servico_bancario = a2.cd_tipo_servico_bancario
		--      AND a1.cd_sequencial < 6
		--      AND a1.dt_finalizado IS NOT NULL

		SELECT
        	@cd_sequencial_old = MAX(a1.cd_sequencial)
        FROM Averbacao_lote AS a1
        	INNER JOIN ( SELECT
                         	cd_tipo_pagamento ,
                         	cd_tipo_servico_bancario
                         FROM Averbacao_lote
                         WHERE cd_sequencial = 6 ) AS a2 ON A1.cd_tipo_pagamento = A2.cd_tipo_pagamento
        WHERE a1.cd_tipo_servico_bancario = a2.cd_tipo_servico_bancario
        AND a1.cd_sequencial < 6
        AND a1.dt_finalizado IS NOT NULL

		DECLARE @cd_funcionario INT
		DECLARE @qtlinha INT = 0
		DECLARE @nm_sacado VARCHAR(100)

		SET @cd_funcionario = 0
		SELECT
        	@cd_funcionario = cd_funcionario
        FROM Processos
        WHERE cd_processo = 1

		IF @cd_funcionario = 0
		OR @cd_funcionario IS NULL BEGIN -- 1.1
			ROLLBACK TRANSACTION
			RAISERROR ('Funcionario de atualização do Processo não definido.' , 16 , 1)
			RETURN
		END -- 1.1

		INSERT averbacao ( cd_Associado,
		                   cd_operacao,
		                   cd_sequencial )
			SELECT
            	cd_Associado ,
            	cd_operacao ,
            	@cd_sequencial
            FROM averbacao
            WHERE cd_sequencial = @cd_sequencial_old

		UPDATE averbacao SET mensagem = NULL
		WHERE cd_sequencial = @cd_sequencial

		UPDATE averbacao SET vl_parcela = (SELECT
                                           	SUM(vl_plano)
                                           FROM DEPENDENTES AS d,
                                           	HISTORICO AS h,
                                           	SITUACAO_HISTORICO AS s
                                           WHERE d.CD_ASSOCIADO = averbacao.CD_ASSOCIADO
                                           AND d.CD_Sequencial_historico = h.cd_sequencial
                                           AND h.CD_SITUACAO = s.CD_SITUACAO_HISTORICO
                                           AND s.fl_gera_cobranca = 1
				) ,
				nm_sacado = a.nm_completo
		FROM ASSOCIADOS AS a
		WHERE averbacao.cd_sequencial = @cd_sequencial
		AND averbacao.CD_ASSOCIADO = a.CD_ASSOCIADO

		UPDATE Averbacao_lote SET qtde = (SELECT
                                          	COUNT(0)
                                          FROM averbacao
                                          WHERE cd_sequencial = @cd_sequencial
				) ,
				valor = (SELECT
                         	SUM(vl_parcela)
                         FROM averbacao
                         WHERE cd_sequencial = @cd_sequencial
				)
		WHERE cd_sequencial = @cd_sequencial

		COMMIT

	END
