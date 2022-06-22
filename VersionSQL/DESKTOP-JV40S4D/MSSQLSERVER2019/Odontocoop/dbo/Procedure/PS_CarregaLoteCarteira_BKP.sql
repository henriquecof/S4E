/****** Object:  Procedure [dbo].[PS_CarregaLoteCarteira_BKP]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:      henrique.almeida
-- Create date: 17/09/2021 09:32
-- Database:    S4ECLEAN
-- Description: REALIZADO PADRONIZAÇÃO E FORMTAÇÃO DE ESTILO T-SQL
-- REALIZAR DOCUMENTAÇÃO DA PROCEDURE USANDO EXTENDED PROPERTIES
-- =============================================


CREATE PROCEDURE [dbo].[PS_CarregaLoteCarteira_BKP] (
	-- Add the parameters for the stored procedure here
	@SQ_Lote INT)
AS BEGIN
		BEGIN TRANSACTION
		DECLARE @LayoutCarteira VARCHAR(50)

		--Lotes Separados por Layout
		SELECT
        	@LayoutCarteira = end_LayoutCarteira
        FROM Lotes_Carteiras
        WHERE sq_lote = @SQ_Lote

		IF @LayoutCarteira <> '' BEGIN
			INSERT INTO Carteiras ( sq_lote,
			                        CD_SEQUENCIAL_dep,
			                        cd_Associado,
			                        Cod_Carteira )
				--140 para teste
				--select top 14000  T1.cd_sequencial, T1.CD_ASSOCIADO, T1.nr_carteira
				--SELECT TOP 14000
				--            	@SQ_Lote ,
				--            	T1.cd_sequencial ,
				--            	T1.cd_Associado ,
				--            	T1.nr_carteira
				--            FROM DEPENDENTES AS T1,
				--            	PLANOS T2,
				--            	ASSOCIADOS T3,
				--            	EMPRESA T4,
				--            	HISTORICO T5
				--            WHERE T1.cd_sequencial NOT IN (SELECT
				--                                           	T2.CD_SEQUENCIAL_dep
				--                                           FROM Carteiras T2
				--                                           WHERE T2.dt_exclusao IS NULL)
				--            AND T1.cd_plano = T2.cd_plano
				--            AND T1.cd_Associado = T3.cd_Associado
				--            AND T3.CD_empresa = T4.CD_empresa
				--            AND T1.Sq_lote_carteira IS NULL
				--            AND T4.Tp_empresa < 10
				--            AND T2.end_LayoutCarteira = @LayoutCarteira
				--            AND T4.fl_gera_carteira = 1
				--            AND ( T2.cd_classificacao IS NOT NULL
				--            OR NOT T2.cd_classificacao = 0 )
				--            AND T1.dt_assinaturaContrato >= '2014-06-26 00:00:00'--getdate()
				--            AND T1.CD_Sequencial_historico = T5.cd_sequencial
				--            AND T1.cd_sequencial = T5.CD_SEQUENCIAL_dep
				--            AND T5.CD_SITUACAO = 1

				SELECT TOP (14000)
                	@SQ_Lote AS Expr1 ,
                	T1.CD_SEQUENCIAL ,
                	T1.CD_ASSOCIADO ,
                	T1.nr_carteira
                FROM DEPENDENTES AS T1
                	INNER JOIN PLANOS AS T2 ON T1.cd_plano = T2.cd_plano
                	INNER JOIN ASSOCIADOS AS T3 ON T1.CD_ASSOCIADO = T3.cd_associado
                	INNER JOIN EMPRESA AS T4 ON T3.cd_empresa = T4.CD_EMPRESA
                	INNER JOIN HISTORICO AS T5 ON T1.CD_Sequencial_historico = T5.cd_sequencial
                		AND T1.CD_SEQUENCIAL = T5.CD_SEQUENCIAL_dep
                WHERE (T1.CD_SEQUENCIAL NOT IN
                (SELECT
                 	cd_sequencial_dep
                 FROM Carteiras AS T2
                 WHERE (dt_exclusao IS NULL)))
                AND (T1.Sq_lote_carteira IS NULL)
                AND (T4.TP_EMPRESA < 10)
                AND (T2.end_LayoutCarteira = @LayoutCarteira)
                AND (T4.fl_gera_carteira = 1)
                AND ( T2.cd_classificacao IS NOT NULL
                OR NOT (T2.cd_classificacao = 0) )
                AND (T1.dt_assinaturaContrato >= '2014-06-26 00:00:00')
                AND (T5.CD_SITUACAO = 1)
		END

		COMMIT TRANSACTION
	END
