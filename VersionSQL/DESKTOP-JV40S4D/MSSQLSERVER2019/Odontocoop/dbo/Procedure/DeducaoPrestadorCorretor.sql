/****** Object:  Procedure [dbo].[DeducaoPrestadorCorretor]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[DeducaoPrestadorCorretor]
	@lote INT
AS BEGIN

        /*
        Data e Hora.: 2022-05-24 14:15:46
        Usuário.: henrique.almeida
        Database.: S4ECLEAN
        Servidor.: 10.1.1.10\homologacao
        Comentário.: REALIZADO PADRONIZAÇÃO T-SQL E FORMATAÇÃO.
        FORAM COMENTADOS TRECHOS PARA PRESERVAR O ORIGINAL.
        */



		--- Verificar se ja tinha sido gerado o imposto
		DECLARE @vl_desconto MONEY
		DECLARE @vl_ref MONEY
		DECLARE @vl_ref_IR MONEY
		DECLARE @cd_ass_emp INT
		DECLARE @tp_ass INT
		DECLARE @cd_tipo_recebimento INT
		DECLARE @vl_liquido MONEY = 0
		DECLARE @vl_bruto MONEY = 0

		-- Cancelar as aliquota para gerar novamente
		UPDATE Pagamento_Corretor_Aliquotas SET dt_exclusao = GETDATE()
		WHERE cd_lote_comissao = @lote
		AND dt_exclusao IS NULL

		IF @@ERROR <> 0 BEGIN
			RAISERROR ('Lote no financeiro não pode ser recalculado.' , 16 , 1)
			RETURN
		END

		DECLARE @qt_dependentes AS INT

		--SELECT
		--      	@qt_dependentes = qt_dependentes
		--      FROM Funcionario_modelo_pagamento AS f,
		--      	comissao_vendedor AS p
		--      WHERE f.cd_funcionario = p.cd_funcionario
		--      AND p.cd_sequencial_lote = @lote

		SELECT
        	@qt_dependentes = qt_dependentes
        FROM Funcionario_modelo_pagamento AS f
        	INNER JOIN comissao_vendedor AS p ON f.cd_funcionario=p.cd_funcionario
        WHERE p.cd_sequencial_lote = @lote

		PRINT 'Dep'
		PRINT @qt_dependentes
		PRINT '-----'

		SELECT
        	@vl_ref = ISNULL(vl_total , 0)
        FROM lote_comissao
        WHERE cd_sequencial = @lote

		PRINT 'ref'
		PRINT @vl_ref
		PRINT '---'

		--Modelo_PgtoPrestador_Aliquota tem que vir de Funcionario_modelo_pagamento
		--selecT * from Pagamento_Dentista_Lancamento
		--select * from comissao_vendedor
		--select * from Modelo_PgtoPrestador_Aliquota
		--select  * from Funcionario_modelo_pagamento

		SELECT
        	@vl_ref_ir = @vl_ref - ISNULL(SUM(CASE WHEN ISNULL(a.vl_maximo_deducao , 0) = 0
        		OR CONVERT(FLOAT , CONVERT(FLOAT , ROUND(@vl_ref * ea.perc_incidencia * a.perc_aliquota , 0)) / 10000) <= ISNULL(a.vl_maximo_deducao , 0) THEN --- Se a aliquota tiver limite maximo de deducao
        			CONVERT(FLOAT , CONVERT(FLOAT , ROUND(@vl_ref * ea.perc_incidencia * a.perc_aliquota , 0)) / 10000)
        			                               ELSE a.vl_maximo_deducao END) , 0) - ISNULL((SELECT
                                                                                                	ISNULL(MAX(vl_deducao_dependente) , 0) * ISNULL(@qt_dependentes , 0)
                                                                                                FROM Aliquota_IR) , 0)
        --FROM lote_comissao AS p,
        --	Funcionario_modelo_pagamento f,
        --	Modelo_PgtoPrestador_Aliquota AS ea,
        --	retencao_aliquota ra,
        --	Aliquota AS a,
        --	referencia_aliquota AS r
        --WHERE f.cd_funcionario = p.cd_funcionario
        --AND ea.cd_modelo_pgto_prestador = f.cd_modelo
        --AND ea.id_retencao_aliquota = ra.id_retencao_aliquota
        --AND ea.cd_aliquota = a.cd_aliquota
        --AND a.id_referencia = r.id_referencia
        --AND p.cd_sequencial = @lote
        --AND a.cd_grupo_aliquota = 3


        FROM lote_comissao AS p
        	INNER JOIN Funcionario_modelo_pagamento AS f ON p.cd_funcionario = f.cd_funcionario
        	INNER JOIN Modelo_PgtoPrestador_Aliquota AS ea ON f.cd_modelo = ea.cd_modelo_pgto_prestador
        	INNER JOIN retencao_aliquota AS ra ON ea.id_retencao_aliquota = ra.id_retencao_aliquota
        	INNER JOIN Aliquota AS a ON ea.cd_aliquota = a.cd_aliquota
        	INNER JOIN referencia_aliquota AS r ON a.id_referencia = r.id_referencia
        WHERE (p.cd_sequencial = @lote)
        AND (a.cd_grupo_aliquota = 3)

		IF @vl_ref_ir < 0 SET @vl_ref_ir = 0

		PRINT 'ref ir'
		PRINT @vl_ref_ir
		PRINT '---'



		-- referencia_aliquota liga na aliquota
		--1	Titulo superior a
		--2	Tabela do IR Pessoa Fisica

		-- Retencao_Aliquota
		-- 0	Não
		-- 1	Sim
		-- 2	Conforme Legislação (Valor referencia)

		--select * from Pagamento_Corretor_Aliquotas
		-- Gerar as aliquotas
		INSERT Pagamento_Corretor_Aliquotas ( cd_lote_comissao,
		                                      cd_aliquota,
		                                      vl_referencia,
		                                      perc_aliquota,
		                                      valor_aliquota,
		                                      dt_gerado,
		                                      id_retido )
			SELECT
            	@lote ,
            	ea.cd_aliquota ,
            	CONVERT(FLOAT , CONVERT(FLOAT , ROUND(@vl_ref * ea.perc_incidencia , 0)) / 100) ,
            	CASE    WHEN r.id_referencia = 2 THEN -- Tabela do IR
            			(SELECT TOP 1
                         	ir.perc_aliquota
                         FROM Aliquota_IR AS ir
                         WHERE vl_maximo >= CONVERT(FLOAT , CONVERT(FLOAT , ROUND(@vl_ref * ea.perc_incidencia , 0)) / 100)
                         AND vl_minimo <= CONVERT(FLOAT , CONVERT(FLOAT , ROUND(@vl_ref * ea.perc_incidencia , 0)) / 100))
            			ELSE a.perc_aliquota END , -- 1parte ( Aliquota IR )
            	ROUND(CASE WHEN r.id_referencia = 2 THEN (SELECT TOP 1
                                                          	ROUND(CONVERT(FLOAT , CONVERT(FLOAT , ROUND(@vl_ref_ir * ea.perc_incidencia * ir.perc_aliquota , 0)) / 10000) - ir.vl_deduzir , 2)
                                                          FROM Aliquota_IR AS ir
                                                          WHERE vl_maximo >= CONVERT(FLOAT , CONVERT(FLOAT , CONVERT(INT , @vl_ref_ir * ea.perc_incidencia)) / 100)
                                                          AND vl_minimo <= CONVERT(FLOAT , CONVERT(FLOAT , CONVERT(INT , @vl_ref_ir * ea.perc_incidencia)) / 100))
            			   ELSE CASE WHEN ISNULL(a.vl_maximo_deducao , 0) = 0
            				OR CONVERT(FLOAT , CONVERT(FLOAT , ROUND(@vl_ref * ea.perc_incidencia * a.perc_aliquota , 0)) / 10000) <= ISNULL(a.vl_maximo_deducao , 0) THEN --- Se a aliquota tiver limite maximo de deducao
            					CONVERT(FLOAT , CONVERT(FLOAT , ROUND(@vl_ref * ea.perc_incidencia * a.perc_aliquota , 0)) / 10000)
            					     ELSE a.vl_maximo_deducao END -- Caso a aliquota tenha valor maximo
            	END , 2) ,
            	GETDATE() ,
            	CASE    WHEN ra.id_retencao_aliquota = 1
            		OR ( ra.id_retencao_aliquota = 2
            		AND r.id_referencia = 1
            		AND @vl_ref >= a.vl_referencia )
            		OR ( ra.id_retencao_aliquota = 2
            		AND r.id_referencia = 2 ) THEN 1
            			ELSE 0 END -- 1 - Retem or (2 Conforme Legislação (Valor referencia) e 1 Titulo superior a) or (2 Conforme Legislação (Valor referencia) e 2 Tabela IR)
            --FROM lote_comissao AS p,
            --	Funcionario_modelo_pagamento f,
            --	Modelo_PgtoPrestador_Aliquota AS ea,
            --	retencao_aliquota ra,
            --	Aliquota AS a,
            --	referencia_aliquota AS r
            --WHERE f.cd_funcionario = p.cd_funcionario
            --AND ea.cd_modelo_pgto_prestador = f.cd_modelo
            --AND ea.id_retencao_aliquota = ra.id_retencao_aliquota
            --AND ea.cd_aliquota = a.cd_aliquota
            --AND a.id_referencia = r.id_referencia
            --AND p.cd_sequencial = @lote

            FROM lote_comissao AS p
            	INNER JOIN Funcionario_modelo_pagamento AS f ON p.cd_funcionario = f.cd_funcionario
            	INNER JOIN Modelo_PgtoPrestador_Aliquota AS ea ON f.cd_modelo = ea.cd_modelo_pgto_prestador
            	INNER JOIN retencao_aliquota AS ra ON ea.id_retencao_aliquota = ra.id_retencao_aliquota
            	INNER JOIN Aliquota AS a ON ea.cd_aliquota = a.cd_aliquota
            	INNER JOIN referencia_aliquota AS r ON a.id_referencia = r.id_referencia
            WHERE (p.cd_sequencial = @lote)


		-- Atualizar lote de comissão
		SELECT
        	@vl_bruto = ISNULL((SELECT
                                	SUM(ROUND(valor * perc_pagamento / 100 , 2))
                                FROM comissao_vendedor
                                WHERE cd_sequencial_lote = @lote) , 0) -- case when vl_total_bruto IS null then vl_total else vl_total_bruto end
        FROM lote_comissao
        WHERE cd_sequencial = @lote

		SELECT
        	@vl_liquido = ISNULL(SUM(ISNULL(valor_aliquota , 0)) , 0)
        FROM Pagamento_Corretor_Aliquotas
        WHERE id_retido = 1
        AND dt_exclusao IS NULL
        AND cd_lote_comissao = @lote

		UPDATE lote_comissao SET vl_total_bruto = @vl_bruto ,
				vl_total = (@vl_bruto - @vl_liquido)
		WHERE cd_sequencial = @lote

		IF @@ERROR <> 0 BEGIN
			RAISERROR ('Erro no calculo dos encargos.' , 16 , 1)
			RETURN
		END

	END
