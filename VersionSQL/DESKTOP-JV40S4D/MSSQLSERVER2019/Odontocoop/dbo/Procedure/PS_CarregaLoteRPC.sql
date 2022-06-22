/****** Object:  Procedure [dbo].[PS_CarregaLoteRPC]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:      henrique.almeida
-- Create date: 17/09/2021 09:35
-- Database:    S4ECLEAN
-- Description: REALIZADO PADRONIZAÇÃO E FORMATAÇÃO DE ESTILO T-SQL
-- REALIZAR DOCUMENTAÇÃO DA PROCEDURE USANDO EXTENDED PROPERTIES
-- =============================================


CREATE PROCEDURE [dbo].[PS_CarregaLoteRPC] (
	@AnoTrimeste VARCHAR(6),
	@variacao INT = -1)
AS BEGIN

		SET NOCOUNT ON;

		DECLARE @Mensagem VARCHAR(1000)

		IF (SELECT
            	COUNT(0)
            FROM Lote_RPC
            WHERE ano_trimestre = @AnoTrimeste
            AND dt_finalizado IS NULL)
		> 0 BEGIN
			SET @Mensagem = 'Existe um Lote RPC aberto. Favor fecha-lo antes de gerar um novo'
			RAISERROR (@Mensagem, 16, 1)
			RETURN
		END

		SELECT
        	@variacao = ISNULL(MAX(cd_variacao), 0) + 1
        FROM Lote_RPC
        WHERE ano_trimestre = @AnoTrimeste
		IF @variacao > 1 BEGIN
			INSERT INTO Lote_RPC ( ano_trimestre,
			                       cd_variacao,
			                       dt_gerado )
				SELECT
                	ano_trimestre ,
                	@variacao ,
                	dt_gerado
                FROM Lote_RPC
                WHERE ano_trimestre = @AnoTrimeste
                AND cd_variacao = @variacao - 1

			INSERT INTO Lote_RPC_Empresa ( cd_empresa,
			                               ds_classificacao,
			                               cd_ans,
			                               cd_grupo_plano,
			                               dt_cadastro,
			                               dt_exclusao,
			                               dt_inicial_aplicacao,
			                               dt_final_aplicacao,
			                               dt_inicial_analise,
			                               dt_final_analise,
			                               mod_contratacao,
			                               perc_reajuste,
			                               qt_beneficiarios,
			                               uf_contrato,
			                               disp_beneficiarios,
			                               cd_caracteristica_reajuste,
			                               reajuste_linear,
			                               alt_franq_coparticipacao,
			                               perc_reajuste_copart,
			                               cd_plano_operadora,
			                               ano_trimestre,
			                               cd_variacao,
			                               ds_justificativa,
			                               nr_contrato_plano )

				SELECT
                	cd_empresa ,
                	ds_classificacao ,
                	cd_ans ,
                	cd_grupo_plano ,
                	dt_cadastro ,
                	dt_exclusao ,
                	dt_inicial_aplicacao ,
                	dt_final_aplicacao ,
                	dt_inicial_analise ,
                	dt_final_analise ,
                	mod_contratacao ,
                	perc_reajuste ,
                	qt_beneficiarios ,
                	uf_contrato ,
                	disp_beneficiarios ,
                	cd_caracteristica_reajuste ,
                	reajuste_linear ,
                	alt_franq_coparticipacao ,
                	perc_reajuste_copart ,
                	cd_plano_operadora ,
                	ano_trimestre ,
                	@variacao ,
                	ds_justificativa ,
                	nr_contrato_plano
                FROM Lote_RPC_Empresa
                WHERE ano_trimestre = @AnoTrimeste
                AND cd_variacao = @variacao - 1

			RETURN

		END


		DECLARE @tipoRpc TINYINT
		SELECT
        	@tipoRpc = ISNULL(tipoRpc, 3)
        FROM Configuracao

		--Declare @AnoTrimeste varchar(6) = 201401
		--Declare @variacao int = 1
		DECLARE @m1 INT,
		        @m2 INT,
		        @m3 INT,
		        @ano INT

		SET @ano = CONVERT(INT, LEFT(@AnoTrimeste, 4))

		IF CONVERT(INT, RIGHT(@AnoTrimeste, 2)) = 1 SELECT
                                                    	@m1 = 12 ,
                                                    	@m2 = 1 ,
                                                    	@m3 = 2

		IF CONVERT(INT, RIGHT(@AnoTrimeste, 2)) = 2 SELECT
                                                    	@m1 = 3 ,
                                                    	@m2 = 4 ,
                                                    	@m3 = 5

		IF CONVERT(INT, RIGHT(@AnoTrimeste, 2)) = 3 SELECT
                                                    	@m1 = 6 ,
                                                    	@m2 = 7 ,
                                                    	@m3 = 8

		IF CONVERT(INT, RIGHT(@AnoTrimeste, 2)) = 4 SELECT
                                                    	@m1 = 9 ,
                                                    	@m2 = 10 ,
                                                    	@m3 = 11

		IF @tipoRpc = 1 SELECT
                        	@m1 = CONVERT(INT, RIGHT(@AnoTrimeste, 2)) ,
                        	@m2 = CONVERT(INT, RIGHT(@AnoTrimeste, 2)) ,
                        	@m3 = CONVERT(INT, RIGHT(@AnoTrimeste, 2))

		INSERT INTO Lote_RPC ( ano_trimestre,
		                       cd_variacao,
		                       dt_gerado )
		VALUES ( @AnoTrimeste,
		         @variacao,
		         GETDATE() )

		INSERT INTO Lote_RPC_Empresa ( [cd_empresa],
		                               [ds_classificacao],
		                               [cd_ans],
		                               [cd_grupo_plano],
		                               [dt_cadastro],
		                               [dt_exclusao],
		                               [dt_inicial_aplicacao],
		                               [mod_contratacao],
		                               [perc_reajuste],
		                               [qt_beneficiarios],
		                               [uf_contrato],
		                               [disp_beneficiarios],
		                               [cd_caracteristica_reajuste],
		                               [reajuste_linear],
		                               [alt_franq_coparticipacao],
		                               [perc_reajuste_copart],
		                               [cd_plano_operadora],
		                               [ano_trimestre],
		                               [cd_variacao],
		                               [ds_justificativa] )

			--SELECT DISTINCT
			--         	   T1.cd_empresa , --T1.NM_RAZSOC, T1.NM_FANTASIA,
			--         	   T7.ds_classificacao ,
			--         	   T7.cd_ans ,--T6.nm_plano,
			--         	   NULL ,
			--         	   GETDATE() ,
			--         	   NULL ,
			--         	   RIGHT('00' + CONVERT(VARCHAR(2), MONTH(T1.DT_FECHAMENTO_CONTRATO)), 2) + '/' +
			--         	CASE    WHEN MONTH(T1.DT_FECHAMENTO_CONTRATO) = 12
			--         		AND @tipoRpc = 3 THEN CONVERT(VARCHAR(4), LEFT(@AnoTrimeste, 4) - 1)
			--         			ELSE LEFT(@AnoTrimeste, 4) END ,
			--         	   (SELECT
			--                 	mod_contratacao
			--                 FROM Configuracao) ,
			--         	   0 ,
			--         	   COUNT(T4.cd_sequencial_dep) qt_beneficiarios ,
			--         	   T1.ufId ,
			--         	   'E' ,
			--         	   3 ,
			--         	   1 ,
			--         	   0 ,
			--         	   0 ,
			--         	   '999999999' ,
			--         	   @AnoTrimeste ,
			--         	   @variacao ,
			--         	   (SELECT TOP 1
			--                 	ds_justificativa
			--                 FROM ANS_Justificativa_RPC
			--                 WHERE fl_reajustepositivo = 0)

			--         FROM EMPRESA T1,
			--         	ASSOCIADOS T2,
			--         	DEPENDENTES T3,
			--         	Ans_Beneficiarios T4, --HISTORICO T5, PLANOS T6,
			--         	CLASSIFICACAO_ANS T7
			--         WHERE T1.cd_empresa = T2.cd_empresa
			--         AND T2.cd_associado = T3.cd_associado
			--         AND T3.cd_sequencial = T4.cd_sequencial_dep
			--         AND T4.dt_exclusao IS NULL -- Incluida
			--         AND T4.cd_plano_ans = T7.cd_ans -- Incluida
			--         AND T1.tp_empresa NOT IN (3)
			--         AND T7.tp_empresa = 2
			--         AND ( -- Resolver o problema do mes 12 q deve voltar 1 ano
			--         ( MONTH(T1.DT_FECHAMENTO_CONTRATO) IN (CASE WHEN CONVERT(INT, RIGHT(@AnoTrimeste, 2)) = 1 THEN @m2
			--         		                                    ELSE @m1 END, @m2, @m3)
			--         AND YEAR(T1.DT_FECHAMENTO_CONTRATO) < @ano )
			--         OR ( MONTH(T1.DT_FECHAMENTO_CONTRATO) IN (@m1)
			--         AND YEAR(T1.DT_FECHAMENTO_CONTRATO) < @ano -
			--         CASE    WHEN CONVERT(INT, RIGHT(@AnoTrimeste, 2)) = 1 THEN 1
			--         		ELSE 0 END -- VOlta 1 ano
			--         ) )

			--         GROUP BY T1.cd_empresa,
			--                  T1.NM_RAZSOC,
			--                  T1.NM_FANTASIA,
			--                  T7.ds_classificacao,
			--                  T7.cd_ans,
			--                  T1.DT_FECHAMENTO_CONTRATO,
			--                  T1.ufId --, T6.nm_plano, T6.cd_grupo_plano
			--         ORDER BY 1

			SELECT DISTINCT
            	   T1.CD_EMPRESA ,
            	   T7.ds_classificacao ,
            	   T7.cd_ans ,
            	   NULL ,
            	   GETDATE() ,
            	   NULL ,
            	   RIGHT('00' + CONVERT(VARCHAR(2), MONTH(T1.DT_FECHAMENTO_CONTRATO)), 2)
            	+ '/' + CASE WHEN MONTH(T1.DT_FECHAMENTO_CONTRATO) = 12
            		AND @tipoRpc = 3 THEN CONVERT(VARCHAR(4), LEFT(@AnoTrimeste, 4) - 1)
            			     ELSE LEFT(@AnoTrimeste, 4) END ,
            	   (SELECT
                    	mod_contratacao
                    FROM Configuracao) ,
            	   0 ,
            	   COUNT(T4.cd_sequencial_dep) AS qt_beneficiarios ,
            	   T1.ufId ,
            	   'E' ,
            	   3 ,
            	   1 ,
            	   0 ,
            	   0 ,
            	   '999999999' ,
            	   @AnoTrimeste ,
            	   @variacao ,
            	   (SELECT TOP (1)
                    	ds_justificativa
                    FROM ANS_Justificativa_RPC
                    WHERE (fl_reajustepositivo = 0))
            FROM EMPRESA AS T1
            	INNER JOIN ASSOCIADOS AS T2 ON T1.CD_EMPRESA = T2.cd_empresa
            	INNER JOIN DEPENDENTES AS T3 ON T2.cd_associado = T3.CD_ASSOCIADO
            	INNER JOIN Ans_Beneficiarios AS T4 ON T3.CD_SEQUENCIAL = T4.cd_sequencial_dep
            	INNER JOIN CLASSIFICACAO_ANS AS T7 ON T4.cd_plano_ans = T7.cd_ans
            WHERE (T4.dt_exclusao IS NULL)
            AND (T1.TP_EMPRESA NOT IN (3))
            AND (T7.tp_empresa = 2)
            AND (MONTH(T1.DT_FECHAMENTO_CONTRATO) IN
            (CASE   WHEN CONVERT(INT, RIGHT(@AnoTrimeste, 2)) = 1 THEN @m2
            		ELSE @m1 END,
            @m2, @m3))
            AND (YEAR(T1.DT_FECHAMENTO_CONTRATO) < @ano)
            OR (T4.dt_exclusao IS NULL)
            AND (T1.TP_EMPRESA NOT IN (3))
            AND (T7.tp_empresa = 2)
            AND (MONTH(T1.DT_FECHAMENTO_CONTRATO) IN (@m1))
            AND (YEAR(T1.DT_FECHAMENTO_CONTRATO)
            < @ano - CASE WHEN CONVERT(INT, RIGHT(@AnoTrimeste, 2)) = 1 THEN 1
            		      ELSE 0 END)
            GROUP BY T1.CD_EMPRESA,
                     T1.NM_RAZSOC,
                     T1.NM_FANTASIA,
                     T7.ds_classificacao,
                     T7.cd_ans,
                     T1.DT_FECHAMENTO_CONTRATO,
                     T1.ufId
            ORDER BY T1.CD_EMPRESA

	END
