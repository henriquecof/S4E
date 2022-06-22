/****** Object:  Procedure [dbo].[BI_GeraHistoricoUsuarios]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[BI_GeraHistoricoUsuarios]
AS BEGIN

		/*
		Data e Hora.: 2022-05-24 13:49:45
		Usuário.: henrique.almeida
		Database.: S4ECLEAN
		Servidor.: 10.1.1.10\homologacao
		Comentário.: REALIZADO PADRONIZAÇÃO T-SQL E FORMATAÇÃO.
        QUERYS ANTIGAS DEIXADAS COMENTADAS.
		*/



/*
ESSA PROCEDURE REALIZA DECLARAÇÃO DE VARIAVEIS.:
@cd_seq int
@dt date
@acao smallint
@qtde int
@total int 
@i int = 0 
@gp int 
@ass int 
@fl_tit smallint
@fl_emp smallint
@cd_seq_aux int 

APOS A DECLARAÇÃO DESSAS VARIAVES REALIZA DELETE NA TABELA HistoricoResumo.
ABERTO UM SELECT JÁ SETANDO A VARIAVAL @total = COUNT(0).
ABERTO UM CURSOR DE NOME c_empHr COM REFERENCIA NAS TABELAS.:
HISTORICO AS h,
SITUACAO_HISTORICO AS sh,
DEPENDENTES AS d,
ASSOCIADOS AS a,
EMPRESA AS e.
SEGUINDO AS CONDIÇÕES NA CLAUSULA WHERE.:
h.CD_SITUACAO = sh.CD_SITUACAO_HISTORICO
AND CD_SEQUENCIAL_dep IS NOT NULL
AND h.CD_SEQUENCIAL_dep = d.CD_SEQUENCIAL
AND d.CD_ASSOCIADO = a.cd_associado
AND a.cd_empresa = e.CD_EMPRESA
AND e.TP_EMPRESA < 10

APOS A VERIFICAÇÃO DO CURSO O MESMO É ABERTO SENDO FEITO AS INSERÇÕES NAS VARIAVEIS ABAIXO SEGUINDO AS CONDIÇÕES REPASSADAS
NA ABERTURA DO CURSO.:
@cd_seq,
@dt,
@acao,
@gp,
@ass;

*/

		SET NOCOUNT ON;

		DECLARE @cd_seq INT
		DECLARE @dt DATE
		DECLARE @acao SMALLINT
		DECLARE @qtde INT
		DECLARE @total INT
		DECLARE @i INT = 0
		DECLARE @gp INT
		DECLARE @ass INT
		DECLARE @fl_tit SMALLINT
		DECLARE @fl_emp SMALLINT
		DECLARE @cd_seq_aux INT

		DELETE historicoresumo

		--SELECT
		--      	@total = COUNT(0)
		--      FROM historico AS H,
		--      	situacao_historico AS SH,
		--      	dependentes AS D,
		--      	associados AS A,
		--      	empresa AS E
		--      WHERE H.cd_situacao = SH.cd_situacao_historico
		--      AND H.cd_sequencial_dep IS NOT NULL
		--      AND H.cd_sequencial_dep = D.cd_sequencial
		--      AND D.cd_associado = A.cd_associado
		--      AND A.cd_empresa = E.cd_empresa
		--      AND E.tp_empresa < 10

		SELECT
        	@total = COUNT(0)
        FROM HISTORICO AS H
        	INNER JOIN SITUACAO_HISTORICO AS SH ON H.CD_SITUACAO = SH.CD_SITUACAO_HISTORICO
        	INNER JOIN DEPENDENTES AS D ON H.CD_SEQUENCIAL_dep = D.CD_SEQUENCIAL
        	INNER JOIN ASSOCIADOS AS A ON D.CD_ASSOCIADO = A.cd_associado
        	INNER JOIN EMPRESA AS E ON A.cd_empresa = E.CD_EMPRESA
        WHERE (H.CD_SEQUENCIAL_dep IS NOT NULL)
        AND (E.TP_EMPRESA < 10)

		DECLARE c_emphr CURSOR FOR
		--SELECT
		--      	cd_sequencial_dep ,
		--      	H.dt_situacao ,
		--      	CASE    WHEN SH.fl_incluir_ans = 1 THEN 1
		--      			ELSE 3 END ,
		--      	D.cd_grau_parentesco ,
		--      	D.cd_associado
		--      FROM historico AS H,
		--      	situacao_historico AS SH,
		--      	dependentes AS D,
		--      	associados AS A,
		--      	empresa AS E
		--      WHERE H.cd_situacao = SH.cd_situacao_historico
		--      AND cd_sequencial_dep IS NOT NULL
		--      AND H.cd_sequencial_dep = D.cd_sequencial
		--      AND D.cd_associado = A.cd_associado
		--      AND A.cd_empresa = E.cd_empresa
		--      AND E.tp_empresa < 10 --and
		--      --a.cd_associado in (1669800,2936000,3277000,4157600)


		SELECT
        	H.CD_SEQUENCIAL_dep ,
        	H.DT_SITUACAO ,
        	CASE    WHEN SH.fl_incluir_ans = 1 THEN 1
        			ELSE 3 END AS Expr1 ,
        	D.CD_GRAU_PARENTESCO ,
        	D.CD_ASSOCIADO
        FROM HISTORICO AS H
        	INNER JOIN SITUACAO_HISTORICO AS SH ON H.CD_SITUACAO = SH.CD_SITUACAO_HISTORICO
        	INNER JOIN DEPENDENTES AS D ON H.CD_SEQUENCIAL_dep = D.CD_SEQUENCIAL
        	INNER JOIN ASSOCIADOS AS A ON D.CD_ASSOCIADO = A.cd_associado
        	INNER JOIN EMPRESA AS E ON A.cd_empresa = E.CD_EMPRESA
        WHERE (H.CD_SEQUENCIAL_dep IS NOT NULL)
        AND (E.TP_EMPRESA < 10)

        ORDER BY H.dt_situacao,
                 H.cd_sequencial
		OPEN c_emphr
		FETCH NEXT FROM c_emphr INTO @cd_seq, @dt, @acao, @gp, @ass
		WHILE (@@fetch_status <> -1)
		BEGIN

			SET @qtde = NULL
			SET @i = @i + 1

			SELECT TOP 1
            	@qtde = pk
            FROM historicoresumo
            WHERE cd_sequencial_dep = @cd_seq
            AND dt_exclusao IS NULL

			IF @acao = 1
			AND @qtde IS NULL BEGIN
				INSERT historicoresumo ( cd_sequencial_dep,
				                         dt_inclusao )
				VALUES ( @cd_seq,
				         @dt )
				-- Se ativar o titular e tiver dependente q tenha sido inativado pelo titular... Voltar
				DECLARE c_emphr_d CURSOR FOR
				SELECT
                	cd_sequencial
                FROM dependentes
                WHERE cd_associado = @ass
                AND cd_grau_parentesco > 1
				OPEN c_emphr_d
				FETCH NEXT FROM c_emphr_d INTO @cd_seq_aux
				WHILE (@@fetch_status <> -1)
				BEGIN

					SELECT TOP 1
                    	@fl_tit = fl_tit
                    FROM historicoresumo
                    WHERE cd_sequencial_dep = @cd_seq_aux
                    ORDER BY pk DESC

					IF @fl_tit = 1 INSERT historicoresumo ( cd_sequencial_dep,
					                                        dt_inclusao )
					VALUES ( @cd_seq_aux,
					         @dt )

					FETCH NEXT FROM c_emphr_d INTO @cd_seq_aux
				END
				CLOSE c_emphr_d
				DEALLOCATE c_emphr_d

			END

			IF @acao = 3
			AND @qtde IS NOT NULL BEGIN
				UPDATE historicoresumo SET dt_exclusao = @dt
				WHERE pk = @qtde -- Cancelar Titular

				IF @gp = 1 UPDATE historicoresumo -- Cancelar Dependente
					SET dt_exclusao = @dt ,
						fl_tit = 1
				WHERE cd_sequencial_dep IN (SELECT
                                            	cd_sequencial
                                            FROM dependentes
                                            WHERE cd_associado = @ass)
				AND dt_exclusao IS NULL

			END

			IF @i % 100 = 0 PRINT CONVERT(VARCHAR(10), @i) + '/' + CONVERT(VARCHAR(10), @total)

			FETCH NEXT FROM c_emphr INTO @cd_seq, @dt, @acao, @gp, @ass
		END
		CLOSE c_emphr
		DEALLOCATE c_emphr

		SET NOCOUNT OFF

	END
