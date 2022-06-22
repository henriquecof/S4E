/****** Object:  Procedure [dbo].[Analise_Dentistas]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[Analise_Dentistas]
AS BEGIN

		-- =============================================
		-- Author:      henrique.almeida
		-- Create date: 10/09/2021 08:20
		-- Database:    S4ECLEAN
		-- Description: PROCEDURE REALIZADO PADRONIZAÇÃO E ESTILO NA T-SQL
		-- =============================================



    /*
    ESSA VARIAVAL DECLARA 3 VARIAVEIS.:
    @DT
    @CD_FUNC
    @QTDE
    
    APOS A DECLARAÇÃO DAS VARIAVEIS, SÃO REALIZADOS DELETES NAS TABELAS.:
    S4EBI..USUARIOS_TRATAMENTO
    S4EBI..PERFIL_DENTISTA
    
    SETADO PARA A VARIAVAL @DT O VALOR PARA DATA ATUAL.
    DECLARADO UM CURSOR DE NOME C_EMP1 USANDO COMO REFERENCIA AS TABELAS.:
    FUNCIONARIO F,
    ATUACAO_DENTISTA AD,
    FILIAL FI 
    
    REPASSADAS ALGUMAS CONDIÇÕES NA CLAUSULA WHERE .:
    F.CD_FUNCIONARIO = AD.CD_FUNCIONARIO
    AND AD.CD_FILIAL = FI.CD_FILIAL
    AND F.CD_CARGO IN ( 30, 32 )
    AND F.CD_SITUACAO IN ( 1, 3 )
    AND AD.FL_ATIVO = 1
    AND FI.FL_ATIVA = 1
    AND FI.CD_CLINICA IN ( 1, 2 )
    
    ABERTURA DO CURSO, FECHAMENTO E UPDATES SERÃO DOCUMENTADOS COMO EXTENDED PROPERTIES
    PARA NÃO POLUIR O CÓDIGO.
    16/07/2021 - HENRIQUE ALMEIDA
    
    */



		DECLARE @dt SMALLDATETIME
		DECLARE @cd_func INT
		DECLARE @qtde INTEGER

DELETE s4ebi..usuarios_tratamento
DELETE s4ebi..perfil_dentista

-- Analise de 12 meses
SET @dt = DATEADD(MONTH, -12, CONVERT(SMALLDATETIME, CONVERT(VARCHAR(10), GETDATE(), 101)))

		-- Selecionar todos os dentistas ativos
		DECLARE c_emp1 CURSOR
		FOR
--SELECT DISTINCT
--    	   f.cd_funcionario
--    FROM FUNCIONARIO f,
--    	atuacao_dentista ad,
--    	FILIAL fi
--    WHERE f.CD_FUNCIONARIO = ad.CD_FUNCIONARIO
--    AND ad.cd_filial = fi.cd_filial
--    AND f.cd_cargo IN (30 , 32)
--    AND f.cd_situacao IN (1 , 3)
--    AND ad.fl_ativo = 1
--    AND fi.fl_ativa = 1
--    AND fi.cd_clinica IN (1 , 2) -- and fi.cd_filial in (5105)

/* and fi.cd_filial in (5105)*/
SELECT DISTINCT F.cd_funcionario
    FROM funcionario AS F
          INNER JOIN atuacao_dentista AS AD ON F.cd_funcionario = AD.cd_funcionario
          INNER JOIN filial AS FI ON AD.cd_filial = FI.cd_filial
    WHERE (F.cd_cargo IN (30, 32))
    AND (F.cd_situacao IN (1, 3))
    AND (AD.fl_ativo = 1)
    AND (FI.fl_ativa = 1)
    AND (FI.cd_clinica IN (1, 2))

OPEN c_emp1
FETCH NEXT FROM c_emp1 INTO @cd_func
WHILE (@@fetch_status <> -1)
BEGIN

PRINT @cd_func
PRINT '1'
PRINT GETDATE()
-- Qtde de usuarios em tratamento por dentista

INSERT INTO s4ebi..usuarios_tratamento (cd_funcionario,
                                        cd_associado,
                                        cd_sequencial_dep,
                                        nm_dependente,
                                        cd_empresa,
                                        qtde)
    --SELECT
    --            	c.CD_FUNCIONARIO ,
    --            	d.cd_Associado ,
    --            	c.cd_sequencial_dep ,
    --            	nm_dependente ,
    --            	a.cd_empresa ,
    --            	COUNT(c.cd_sequencial)
    --            FROM Consultas AS c,
    --            	DEPENDENTES AS d,
    --            	ASSOCIADOS AS a
    --            WHERE c.cd_sequencial_dep = d.CD_SEQUENCIAL
    --            AND d.cd_associado = a.cd_associado
    --            AND c.CD_FUNCIONARIO = @cd_func
    --            AND c.dt_servico IS NOT NULL
    --            AND c.dt_cancelamento IS NULL
    --            AND
    --            --a.cd_situacao in (select cd_situacao_historico from situacao_historico where fl_atendido_clinica=1) and
    --            d.cd_situacao IN (SELECT
    --                              	cd_situacao_historico
    --                              FROM SITUACAO_HISTORICO
    --                              WHERE fl_atendido_clinica = 1
    --            )
    --            GROUP BY c.CD_FUNCIONARIO,
    --                     d.cd_associado,
    --                     c.cd_sequencial_dep,
    --                     NM_DEPENDENTE,
    --                     cd_empresa

    SELECT C.cd_funcionario,
           D.cd_associado,
           C.cd_sequencial_dep,
           D.nm_dependente,
           A.cd_empresa,
           COUNT(C.cd_sequencial) AS EXPR1
    FROM consultas AS C
        INNER JOIN dependentes AS D ON C.cd_sequencial_dep = D.cd_sequencial
        INNER JOIN associados AS A ON D.cd_associado = A.cd_associado
    WHERE (C.cd_funcionario = @cd_func)
    AND (C.dt_servico IS NOT NULL)
    AND (C.dt_cancelamento IS NULL)
    AND (D.cd_situacao IN (SELECT cd_situacao_historico
            FROM situacao_historico
            WHERE (fl_atendido_clinica = 1)))
    GROUP BY C.cd_funcionario,
             D.cd_associado,
             C.cd_sequencial_dep,
             D.nm_dependente,
             A.cd_empresa

PRINT '2'
PRINT GETDATE()

-- Total de Procedimentos por Dentista
--SELECT
--         	@qtde = COUNT(*)
--         FROM Consultas AS c,
--         	DEPENDENTES AS d,
--         	SERVICO AS s,
--         	ASSOCIADOS AS a
--         WHERE c.cd_sequencial_dep = d.CD_SEQUENCIAL
--         AND c.CD_SERVICO = s.CD_SERVICO
--         AND c.CD_FUNCIONARIO = @cd_func
--         AND c.dt_servico IS NULL
--         AND c.dt_cancelamento IS NULL
--         AND d.cd_associado = a.cd_associado
--         AND
--         --a.cd_situacao in (select cd_situacao_historico from situacao_historico where fl_atendido_clinica=1) and
--         d.cd_situacao IN (SELECT
--                           	CD_SITUACAO_HISTORICO
--                           FROM SITUACAO_HISTORICO
--                           WHERE fl_atendido_clinica = 1 )

SELECT @qtde = COUNT(*)
FROM consultas AS C
    INNER JOIN dependentes AS D ON C.cd_sequencial_dep = D.cd_sequencial
    INNER JOIN servico AS S ON C.cd_servico = S.cd_servico
    INNER JOIN associados AS A ON D.cd_associado = A.cd_associado
WHERE (C.cd_funcionario = @cd_func)
AND (C.dt_servico IS NULL)
AND (C.dt_cancelamento IS NULL)
AND (D.cd_situacao IN (SELECT cd_situacao_historico
        FROM situacao_historico
        WHERE (fl_atendido_clinica = 1)))

PRINT '2'
PRINT GETDATE()

-- Perfil do dentista (Pendente)
INSERT INTO s4ebi..perfil_dentista (cd_funcionario,
                                    cd_servico,
                                    nm_servico,
                                    qtde,
                                    realizado,
                                    percentual)
    --SELECT
    --            	c.CD_FUNCIONARIO ,
    --            	c.CD_SERVICO ,
    --            	NM_SERVICO ,
    --            	COUNT(*) ,
    --            	0 ,
    --            	CONVERT(MONEY , (CONVERT(INT , CONVERT(FLOAT , COUNT(*)) / @qtde * 10000))) / 100
    --            FROM Consultas AS c,
    --            	DEPENDENTES AS d,
    --            	SERVICO AS s,
    --            	ASSOCIADOS AS a
    --            WHERE c.cd_sequencial_dep = d.CD_SEQUENCIAL
    --            AND c.CD_SERVICO = s.CD_SERVICO
    --            AND c.CD_FUNCIONARIO = @cd_func
    --            AND c.dt_servico IS NULL
    --            AND c.dt_cancelamento IS NULL
    --            AND d.cd_associado = a.cd_associado
    --            AND
    --            --a.cd_situacao in (select cd_situacao_historico from situacao_historico where fl_atendido_clinica=1) and
    --            d.cd_situacao IN (SELECT
    --                              	CD_SITUACAO_HISTORICO
    --                              FROM SITUACAO_HISTORICO
    --                              WHERE fl_atendido_clinica = 1
    --            )
    --            GROUP BY c.CD_FUNCIONARIO,
    --                     c.CD_SERVICO,
    --                     NM_SERVICO

    SELECT C.cd_funcionario,
           C.cd_servico,
           S.nm_servico,
           COUNT(*),
           0,
           CONVERT(MONEY, CONVERT(INT, CONVERT(FLOAT, COUNT(*)) / @qtde * 10000)) / 100
    FROM consultas AS C
        INNER JOIN dependentes AS D ON C.cd_sequencial_dep = D.cd_sequencial
        INNER JOIN servico AS S ON C.cd_servico = S.cd_servico
        INNER JOIN associados AS A ON D.cd_associado = A.cd_associado
    WHERE (C.cd_funcionario = @cd_func)
    AND (C.dt_servico IS NULL)
    AND (C.dt_cancelamento IS NULL)
    AND (D.cd_situacao IN (SELECT cd_situacao_historico
            FROM situacao_historico
            WHERE (fl_atendido_clinica = 1)))
    GROUP BY C.cd_funcionario,
             C.cd_servico,
             S.nm_servico

PRINT '3'
PRINT GETDATE()

-- Total de Procedimentos por Dentista
--SELECT
--         	@qtde = COUNT(*)
--         FROM Consultas AS c,
--         	SERVICO AS s
--         WHERE c.CD_SERVICO = s.CD_SERVICO
--         AND c.CD_FUNCIONARIO = @cd_func
--         AND c.dt_cancelamento IS NULL
--         AND c.dt_servico >= @dt
--         AND c.CD_SERVICO NOT IN (80000142 , 80000144 , 80000150 , 80000490 , 80000495 , 80000500)

SELECT @qtde = COUNT(*)
FROM consultas AS C
    INNER JOIN servico AS S ON C.cd_servico = S.cd_servico
WHERE C.cd_funcionario = @cd_func
AND C.dt_cancelamento IS NULL
AND C.dt_servico >= @dt
AND C.cd_servico NOT IN (80000142, 80000144, 80000150, 80000490, 80000495, 80000500)


PRINT '4'
PRINT GETDATE()
-- Perfil do dentista nos ultimos 12 meses
INSERT INTO s4ebi..perfil_dentista (cd_funcionario,
                                    cd_servico,
                                    nm_servico,
                                    qtde,
                                    realizado,
                                    percentual)
    --SELECT
    --            	c.CD_FUNCIONARIO ,
    --            	c.CD_SERVICO ,
    --            	NM_SERVICO ,
    --            	COUNT(*) ,
    --            	1 ,
    --            	CONVERT(MONEY , (CONVERT(INT , CONVERT(FLOAT , COUNT(*)) / @qtde * 10000))) / 100
    --            FROM Consultas AS c,
    --            	SERVICO AS s
    --            WHERE c.CD_SERVICO = s.CD_SERVICO
    --            AND c.CD_FUNCIONARIO = @cd_func
    --            AND c.dt_cancelamento IS NULL
    --            AND c.dt_servico >= @dt
    --            AND c.CD_SERVICO NOT IN (80000142 , 80000144 , 80000150 , 80000490 , 80000495 , 80000500)

    --            GROUP BY c.CD_FUNCIONARIO,
    --                     c.CD_SERVICO,
    --                     NM_SERVICO

    SELECT C.cd_funcionario,
           C.cd_servico,
           S.nm_servico,
           COUNT(*),
           1,
           CONVERT(MONEY, CONVERT(INT, CONVERT(FLOAT, COUNT(*)) / @qtde * 10000)) / 100
    FROM consultas AS C
        INNER JOIN servico AS S ON C.cd_servico = S.cd_servico
    WHERE (C.cd_funcionario = @cd_func)
    AND (C.dt_cancelamento IS NULL)
    AND (C.dt_servico >= @dt)
    AND (C.cd_servico NOT IN (80000142, 80000144, 80000150, 80000490, 80000495, 80000500))
    GROUP BY C.cd_funcionario,
             C.cd_servico,
             S.nm_servico

PRINT '5'
PRINT GETDATE()
-- Total de Procedimentos Pendentes e Realizados por Dentista
--SELECT
--         	@qtde = COUNT(*) + (
--         	SELECT
--             	COUNT(*)
--             FROM Consultas AS c,
--             	SERVICO AS s
--             WHERE c.CD_SERVICO = s.CD_SERVICO
--             AND c.CD_FUNCIONARIO = @cd_func
--             AND c.dt_cancelamento IS NULL
--             AND c.dt_servico >= @dt
--             AND c.CD_SERVICO NOT IN (80000142 , 80000144 , 80000150 , 80000490 , 80000495 , 80000500))
--         FROM Consultas AS c,
--         	DEPENDENTES AS d,
--         	SERVICO AS s,
--         	ASSOCIADOS AS a
--         WHERE c.cd_sequencial_dep = d.CD_SEQUENCIAL
--         AND c.CD_SERVICO = s.CD_SERVICO
--         AND c.CD_FUNCIONARIO = @cd_func
--         AND c.dt_servico IS NULL
--         AND c.dt_cancelamento IS NULL
--         AND d.cd_associado = a.cd_associado
--         AND
--         --a.cd_situacao in (select cd_situacao_historico from situacao_historico where fl_atendido_clinica=1) and
--         d.cd_situacao IN (SELECT
--                           	CD_SITUACAO_HISTORICO
--                           FROM SITUACAO_HISTORICO
--                           WHERE fl_atendido_clinica = 1 )

SELECT @qtde = COUNT(*) + (SELECT COUNT(*)
            FROM consultas AS C
                  INNER JOIN servico AS S ON C.cd_servico = S.cd_servico
            WHERE C.cd_funcionario = @cd_func
            AND C.dt_cancelamento IS NULL
            AND C.dt_servico >= @dt
            AND C.cd_servico NOT IN (80000142, 80000144, 80000150, 80000490, 80000495, 80000500))
FROM consultas AS C
    INNER JOIN dependentes AS D ON C.cd_sequencial_dep = D.cd_sequencial
    INNER JOIN servico AS S ON C.cd_servico = S.cd_servico
    INNER JOIN associados AS A ON D.cd_associado = A.cd_associado
WHERE C.cd_funcionario = @cd_func
AND C.dt_servico IS NULL
AND C.dt_cancelamento IS NULL
AND D.cd_situacao IN (SELECT cd_situacao_historico
        FROM situacao_historico
        WHERE fl_atendido_clinica = 1)
PRINT '6'
PRINT GETDATE()

INSERT INTO s4ebi..perfil_dentista (cd_funcionario,
                                    cd_servico,
                                    nm_servico,
                                    qtde,
                                    realizado,
                                    percentual)
    --SELECT
    --            	c.CD_FUNCIONARIO ,
    --            	c.CD_SERVICO ,
    --            	NM_SERVICO ,
    --            	COUNT(*) ,
    --            	2 ,
    --            	CONVERT(MONEY , (CONVERT(INT , CONVERT(FLOAT , COUNT(*)) / @qtde * 10000))) / 100
    --            FROM Consultas AS c,
    --            	DEPENDENTES AS d,
    --            	SERVICO AS s,
    --            	ASSOCIADOS AS a
    --            WHERE c.cd_sequencial_dep = d.CD_SEQUENCIAL
    --            AND c.CD_SERVICO = s.CD_SERVICO
    --            AND c.CD_FUNCIONARIO = @cd_func
    --            AND c.dt_cancelamento IS NULL
    --            AND d.cd_associado = a.cd_associado
    --            AND ( ( c.dt_servico IS NULL
    --            AND
    --            --a.cd_situacao in (select cd_situacao_historico from situacao_historico where fl_atendido_clinica=1) and
    --            d.cd_situacao IN (SELECT
    --                              	CD_SITUACAO_HISTORICO
    --                              FROM SITUACAO_HISTORICO
    --                              WHERE fl_atendido_clinica = 1
    --            ) )
    --            OR ( c.dt_servico >= @dt
    --            AND c.CD_SERVICO NOT IN (80000142 , 80000144 , 80000150 , 80000490 , 80000495 , 80000500) ) )
    --            GROUP BY c.CD_FUNCIONARIO,
    --                     c.CD_SERVICO,
    --                     NM_SERVICO

    SELECT C.cd_funcionario,
           C.cd_servico,
           S.nm_servico,
           COUNT(*),
           2,
           CONVERT(MONEY, CONVERT(INT, CONVERT(FLOAT, COUNT(*)) / @qtde * 10000)) / 100
    FROM consultas AS C
        INNER JOIN dependentes AS D ON C.cd_sequencial_dep = D.cd_sequencial
        INNER JOIN servico AS S ON C.cd_servico = S.cd_servico
        INNER JOIN associados AS A ON D.cd_associado = A.cd_associado
    WHERE (C.cd_funcionario = @cd_func)
    AND (C.dt_cancelamento IS NULL)
    AND (C.dt_servico IS NULL)
    AND (D.cd_situacao IN (SELECT cd_situacao_historico
            FROM situacao_historico
            WHERE (fl_atendido_clinica = 1)))
    OR (C.cd_funcionario = @cd_func)
    AND (C.dt_cancelamento IS NULL)
    AND (C.dt_servico >= @dt)
    AND (C.cd_servico NOT IN (80000142, 80000144, 80000150, 80000490, 80000495, 80000500))
    GROUP BY C.cd_funcionario,
             C.cd_servico,
             S.nm_servico

FETCH NEXT FROM c_emp1 INTO @cd_func
END
CLOSE c_emp1
DEALLOCATE c_emp1

PRINT 'S4E'

PRINT GETDATE()

--SELECT
--      	@qtde = COUNT(*)
--      FROM Consultas AS c,
--      	DEPENDENTES AS d,
--      	SERVICO AS s,
--      	ASSOCIADOS AS a
--      WHERE c.cd_sequencial_dep = d.CD_SEQUENCIAL
--      AND c.CD_SERVICO = s.CD_SERVICO
--      AND c.dt_servico IS NULL
--      AND c.dt_cancelamento IS NULL
--      AND d.cd_associado = a.cd_associado
--      AND
--      --a.cd_situacao in (select cd_situacao_historico from situacao_historico where fl_atendido_clinica=1) and
--      d.cd_situacao IN (SELECT
--                        	CD_SITUACAO_HISTORICO
--                        FROM SITUACAO_HISTORICO
--                        WHERE fl_atendido_clinica = 1 )

SELECT @qtde = COUNT(*)
FROM consultas AS C
    INNER JOIN dependentes AS D ON C.cd_sequencial = D.cd_sequencial
    INNER JOIN servico AS S ON C.cd_servico = S.cd_servico
    INNER JOIN associados AS A ON D.cd_associado = A.cd_associado
WHERE C.dt_servico IS NULL
AND C.dt_cancelamento IS NULL
AND D.cd_situacao IN (SELECT cd_situacao_historico
        FROM situacao_historico
        WHERE fl_atendido_clinica = 1)
PRINT '8'
PRINT GETDATE()

-- Perfil do Plano (Pendente)
INSERT s4ebi..perfil_dentista (cd_funcionario,
                               cd_servico,
                               nm_servico,
                               qtde,
                               realizado,
                               percentual)
    --SELECT
    --         	99999999 ,
    --         	c.CD_SERVICO ,
    --         	NM_SERVICO ,
    --         	COUNT(*) ,
    --         	0 ,
    --         	CONVERT(MONEY , (CONVERT(INT , CONVERT(FLOAT , COUNT(*)) / @qtde * 10000))) / 100
    --         FROM Consultas AS c,
    --         	DEPENDENTES AS d,
    --         	SERVICO AS s,
    --         	ASSOCIADOS AS a
    --         WHERE --c.cd_associado = d.cd_associado and
    --         c.cd_sequencial_dep = d.CD_SEQUENCIAL
    --         AND c.CD_SERVICO = s.CD_SERVICO
    --         AND c.dt_servico IS NULL
    --         AND c.dt_cancelamento IS NULL
    --         AND d.cd_associado = a.cd_associado
    --         AND
    --         --a.cd_situacao in (select cd_situacao_historico from situacao_historico where fl_atendido_clinica=1) and
    --         d.cd_situacao IN (SELECT
    --                           	CD_SITUACAO_HISTORICO
    --                           FROM SITUACAO_HISTORICO
    --                           WHERE fl_atendido_clinica = 1
    --         )
    --         GROUP BY c.CD_SERVICO,
    --                  NM_SERVICO

    SELECT 99999999,
           C.cd_servico,
           S.nm_servico,
           COUNT(*),
           0,
           CONVERT(MONEY, CONVERT(INT, CONVERT(FLOAT, COUNT(*)) / @qtde * 10000)) / 100
    FROM consultas AS C
        INNER JOIN dependentes AS D ON C.cd_sequencial_dep = D.cd_sequencial
        INNER JOIN servico AS S ON C.cd_servico = S.cd_servico
        INNER JOIN associados AS A ON D.cd_associado = A.cd_associado
    WHERE (C.dt_servico IS NULL)
    AND (C.dt_cancelamento IS NULL)
    AND (D.cd_situacao IN (SELECT cd_situacao_historico
            FROM situacao_historico
            WHERE (fl_atendido_clinica = 1)))
    GROUP BY C.cd_servico,
             S.nm_servico

PRINT '9'
PRINT GETDATE()

--SELECT
--      	@qtde = COUNT(*)
--      FROM Consultas AS c,
--      	SERVICO AS s
--      WHERE c.CD_SERVICO = s.CD_SERVICO
--      AND c.dt_cancelamento IS NULL
--      AND c.dt_servico >= @dt
--      AND c.CD_SERVICO NOT IN (80000142 , 80000144 , 80000150 , 80000490 , 80000495 , 80000500)

SELECT @qtde = COUNT(*)
FROM consultas AS C
    INNER JOIN servico AS S ON C.cd_servico = S.cd_servico
WHERE C.dt_cancelamento IS NULL
AND C.dt_servico >= @dt
AND C.cd_servico NOT IN (80000142, 80000144, 80000150, 80000490, 80000495, 80000500)


PRINT '10'
PRINT GETDATE()

-- Perfil do Plano nos ultimos 12 meses
INSERT s4ebi..perfil_dentista (cd_funcionario,
                               cd_servico,
                               nm_servico,
                               qtde,
                               realizado,
                               percentual)
    --SELECT
    --         	99999999 ,
    --         	c.CD_SERVICO ,
    --         	NM_SERVICO ,
    --         	COUNT(*) ,
    --         	1 ,
    --         	CONVERT(MONEY , (CONVERT(INT , CONVERT(FLOAT , COUNT(*)) / @qtde * 10000))) / 100
    --         FROM Consultas AS c,
    --         	SERVICO AS s
    --         WHERE c.CD_SERVICO = s.CD_SERVICO
    --         AND c.dt_cancelamento IS NULL
    --         AND c.dt_servico >= @dt
    --         AND c.CD_SERVICO NOT IN (80000142 , 80000144 , 80000150 , 80000490 , 80000495 , 80000500)

    --         GROUP BY c.CD_SERVICO,
    --                  NM_SERVICO

    SELECT 99999999,
           C.cd_servico,
           nm_servico,
           COUNT(*),
           1,
           CONVERT(MONEY, (CONVERT(INT, CONVERT(FLOAT, COUNT(*)) / @qtde * 10000))) / 100
    FROM consultas AS C
        INNER JOIN servico AS S ON C.cd_servico = S.cd_servico
    WHERE C.dt_cancelamento IS NULL
    AND C.dt_servico >= @dt
    AND C.cd_servico NOT IN (80000142, 80000144, 80000150, 80000490, 80000495, 80000500)
    GROUP BY C.cd_servico,
             nm_servico

PRINT '11'
PRINT GETDATE()

-- Perfil do Plano nos ultimos 12 meses
-- Total de Procedimentos Pendentes e Realizados
--SELECT @qtde = COUNT(*) + (SELECT COUNT(*)
--            FROM consultas AS C,
--                 servico AS S
--            WHERE C.cd_servico = S.cd_servico
--            AND C.dt_cancelamento IS NULL
--            AND C.dt_servico >= @dt
--            AND C.cd_servico NOT IN (80000142, 80000144, 80000150, 80000490, 80000495, 80000500))
--FROM consultas AS C,
--     dependentes AS D,
--     servico AS S,
--     associados AS A
--WHERE --c.cd_associado = d.cd_associado and
--C.cd_sequencial_dep = D.cd_sequencial
--AND C.cd_servico = S.cd_servico
--AND C.dt_servico IS NULL
--AND C.dt_cancelamento IS NULL
--AND D.cd_associado = A.cd_associado
--AND
----a.cd_situacao in (select cd_situacao_historico from situacao_historico where fl_atendido_clinica=1) and
--D.cd_situacao IN (SELECT cd_situacao_historico
--        FROM situacao_historico
--        WHERE fl_atendido_clinica = 1)

SELECT @qtde = COUNT(*) + (SELECT COUNT(*)
            FROM consultas AS C
                  INNER JOIN servico AS S ON C.cd_servico = S.cd_servico
            WHERE C.dt_cancelamento IS NULL
            AND C.dt_servico >= @dt
            AND C.cd_servico NOT IN (80000142, 80000144, 80000150, 80000490, 80000495, 80000500))
FROM consultas AS C
    INNER JOIN dependentes AS D ON C.cd_sequencial_dep = D.cd_sequencial
    INNER JOIN servico AS S ON C.cd_servico = S.cd_servico
    INNER JOIN associados AS A ON D.cd_associado = A.cd_associado
WHERE (C.dt_servico IS NULL)
AND (C.dt_cancelamento IS NULL)
AND (D.cd_situacao IN (SELECT cd_situacao_historico
        FROM situacao_historico
        WHERE (fl_atendido_clinica = 1)))

PRINT '12'

PRINT GETDATE()

INSERT INTO s4ebi..perfil_dentista (cd_funcionario,
                                    cd_servico,
                                    nm_servico,
                                    qtde,
                                    realizado,
                                    percentual)
    --SELECT 99999999,
    --       C.cd_servico,
    --       nm_servico,
    --       COUNT(*),
    --       2,
    --       CONVERT(MONEY, (CONVERT(INT, CONVERT(FLOAT, COUNT(*)) / @qtde * 10000))) / 100
    --FROM consultas AS C,
    --     dependentes AS D,
    --     servico AS S,
    --     associados AS A
    --WHERE --c.cd_associado = d.cd_associado and
    --C.cd_sequencial_dep = D.cd_sequencial
    --AND C.cd_servico = S.cd_servico
    --AND C.dt_cancelamento IS NULL
    --AND D.cd_associado = A.cd_associado
    --AND ((C.dt_servico IS NULL AND
    ----a.cd_situacao in (select cd_situacao_historico from situacao_historico where fl_atendido_clinica=1) and
    --D.cd_situacao IN (SELECT cd_situacao_historico
    --        FROM situacao_historico
    --        WHERE fl_atendido_clinica = 1)) OR (C.dt_servico >= @dt AND C.cd_servico NOT IN (80000142, 80000144, 80000150, 80000490, 80000495, 80000500)))
    --GROUP BY C.cd_servico,
    --         nm_servico

    SELECT 99999999,
           C.cd_servico,
           S.nm_servico,
           COUNT(*),
           2,
           CONVERT(MONEY, CONVERT(INT, CONVERT(FLOAT, COUNT(*)) / @qtde * 10000)) / 100
    FROM consultas AS C
        INNER JOIN dependentes AS D ON C.cd_sequencial_dep = D.cd_sequencial
        INNER JOIN servico AS S ON C.cd_servico = S.cd_servico
        INNER JOIN associados AS A ON D.cd_associado = A.cd_associado
    WHERE (C.dt_cancelamento IS NULL)
    AND (C.dt_servico IS NULL)
    AND (D.cd_situacao IN (SELECT cd_situacao_historico
            FROM situacao_historico
            WHERE (fl_atendido_clinica = 1)))
    OR (C.dt_cancelamento IS NULL)
    AND (C.dt_servico >= @dt)
    AND (C.cd_servico NOT IN (80000142, 80000144, 80000150, 80000490, 80000495, 80000500))
    GROUP BY C.cd_servico,
             S.nm_servico

END
