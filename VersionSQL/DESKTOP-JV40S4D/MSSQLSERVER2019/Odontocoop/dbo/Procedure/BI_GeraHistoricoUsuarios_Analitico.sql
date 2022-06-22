/****** Object:  Procedure [dbo].[BI_GeraHistoricoUsuarios_Analitico]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[BI_GeraHistoricoUsuarios_Analitico] (
	@comp_base DATE = '05/01/2014'
)
AS

	-- =============================================
	-- Author:      henrique.almeida
	-- Create date: 10/09/2021 08:46
	-- Database:    S4ECLEAN
	-- Description: REALIZADO PADRONIZAÇÃO E FORMATAÇÃO NO ESTILO T-SQL
	-- =============================================



  /*
  ESSA PROCEDURE REALIZA DECLARAÇÃO DE 7 VARIAVEIS ABAIXO.:
  @CD_SEQ INT
  @COMP_INI DATE 
  @COMP_FIM DATE
  @FL_ORTO SMALLINT 
  @TOTAL INT 
  @QTDE INT
  @I INT = 0
  
  APOS A DECLARAÇÃO REALIZA LIMPEZA NA TABELA PREVSYSTEMBI..HISTORICO_ATIVOSMENSAL SEGUINDO COMO CONDIÇÃO
  NA CLAUSULA WHERE.:
  COMPETENCIA >= CONVERT(VARCHAR(6),DATEADD(MONTH,-1,GETDATE()),112)
  
  APOS ISSO É REALIZADO SELECT SETANDO O VALOR DE @TOTAL = COUNT(0).
  DECLARADO UM CURSOR DE NOME C_EMPHR COM REFERENCIA NAS TABELAS.:
  HISTORICORESUMO AS H, 
  DEPENDENTES AS D , 
  ASSOCIADOS AS A, 
  EMPRESA AS E, 
  PLANOS AS P
  
  APOS ISSO CURSOR É ABERTO REALIZANDO INSERÇÃO NAS VARIAVEIS.:
  @CD_SEQ, 
  @COMP_INI,
  @COMP_FIM, 
  @FL_ORTO
  
  */ BEGIN
		SET NOCOUNT ON;

		DECLARE @cd_seq INT
		DECLARE @Comp_ini DATE
		DECLARE @Comp_fim DATE
		DECLARE @fl_orto SMALLINT
		DECLARE @total INT
		DECLARE @qtde INT
		DECLARE @i INT = 0

		--Declare @competencia int = convert(int,left(convert(varchar(10),dateadd(month,-1,getdate()),112),6))
		--Declare @comp_base date = '08/01/2012' -- Inicio do Sistema

		--Declare @acao smallint
		--Declare @gp int
		--Declare @ass int

		DELETE PrevsystemBI..Historico_AtivosMensal
		WHERE competencia >= CONVERT(VARCHAR(6) , DATEADD(MONTH , -1 , GETDATE()) , 112)

		--SELECT
		--      	@total = COUNT(0)
		--      FROM HistoricoResumo AS h,
		--      	DEPENDENTES AS d,
		--      	ASSOCIADOS AS a,
		--      	EMPRESA AS e
		--      WHERE h.cd_sequencial_dep = d.cd_sequencial
		--      AND d.cd_associado = a.cd_associado
		--      AND a.CD_EMPRESA = e.CD_EMPRESA
		--      AND e.TP_EMPRESA < 10

		SELECT
        	@total = COUNT(0)
        FROM HistoricoResumo AS h
        	INNER JOIN DEPENDENTES AS d ON h.cd_sequencial_dep = d.CD_SEQUENCIAL
        	INNER JOIN ASSOCIADOS AS a ON d.CD_ASSOCIADO = a.cd_associado
        	INNER JOIN EMPRESA AS e ON a.cd_empresa = e.CD_EMPRESA
        WHERE (e.TP_EMPRESA < 10)

		DECLARE c_empHr CURSOR FOR
		--SELECT
		--      	cd_sequencial_dep ,
		--      	dt_inclusao ,
		--      	ISNULL(dt_exclusao , DATEADD(MONTH , 1 , GETDATE())) ,
		--      	p.fl_exige_dentista
		--      FROM HistoricoResumo AS h,
		--      	DEPENDENTES AS d,
		--      	ASSOCIADOS AS a,
		--      	EMPRESA AS e,
		--      	PLANOS AS p
		--      WHERE h.cd_sequencial_dep = d.cd_sequencial
		--      AND d.cd_associado = a.cd_associado
		--      AND a.CD_EMPRESA = e.CD_EMPRESA
		--      AND e.TP_EMPRESA < 10
		--      AND d.cd_plano = p.cd_plano --and
		--      --   h.cd_sequencial_dep=121100
		--      ORDER BY pk

		SELECT
        	h.cd_sequencial_dep ,
        	h.dt_inclusao ,
        	ISNULL(h.dt_exclusao, DATEADD(MONTH, 1, GETDATE())) AS Expr1 ,
        	p.fl_exige_dentista
        FROM HistoricoResumo AS h
        	INNER JOIN DEPENDENTES AS d ON h.cd_sequencial_dep = d.CD_SEQUENCIAL
        	INNER JOIN ASSOCIADOS AS a ON d.CD_ASSOCIADO = a.cd_associado
        	INNER JOIN EMPRESA AS e ON a.cd_empresa = e.CD_EMPRESA
        	INNER JOIN PLANOS AS p ON d.cd_plano = p.cd_plano
        WHERE (e.TP_EMPRESA < 10)
        ORDER BY h.pk

		OPEN c_empHr
		FETCH NEXT FROM c_empHr INTO @cd_seq , @Comp_ini , @Comp_fim , @fl_orto
		WHILE (@@fetch_status <> -1)
		BEGIN

			SET @Comp_fim = DATEADD(MONTH , -1 , @comp_fim) -- Mes Anterior

			IF @Comp_ini < @comp_base SET @Comp_ini = @comp_base

			SET @qtde = NULL
			SET @i = @i + 1

			WHILE CONVERT(VARCHAR(6) , @Comp_ini , 112) <= CONVERT(VARCHAR(6) , @Comp_fim , 112)
			BEGIN

				--print convert(varchar(6),@Comp_ini,112)

				SELECT TOP 1
                	@qtde = competencia
                FROM PrevsystemBI..Historico_AtivosMensal
                WHERE cd_sequencial_dep = @cd_seq
                AND competencia = CONVERT(VARCHAR(6) , @Comp_ini , 112)

				-- print @qtde

				IF @qtde IS NULL INSERT PrevsystemBI..Historico_AtivosMensal ( competencia,
				                                                               cd_sequencial_dep,
				                                                               ano,
				                                                               mes,
				                                                               fl_orto )
				VALUES ( CONVERT(VARCHAR(6) , @Comp_ini , 112),
				         @cd_seq,
				         YEAR(@comp_ini),
				         MONTH(@comp_ini),
				         @fl_orto )

				SET @Comp_ini = DATEADD(MONTH , 1 , @comp_ini)
				SET @qtde = NULL

			END

			IF @i % 100 = 0 PRINT CONVERT(VARCHAR(10) , @i) + '/' + CONVERT(VARCHAR(10) , @total)

			FETCH NEXT FROM c_empHr INTO @cd_seq , @Comp_ini , @Comp_fim , @fl_orto
		END
		CLOSE c_empHr
		DEALLOCATE c_empHr

		SET NOCOUNT OFF

	END
