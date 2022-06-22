/****** Object:  Procedure [dbo].[ans_gera_competencia_nf]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[ans_gera_competencia_nf]
	@mes INT,
	@ano INT
AS BEGIN

		/*
		Data e Hora.: 2022-05-23 15:26:47
		Usuário.: henrique.almeida
		Database.: S4ECLEAN
		Servidor.: 10.1.1.10\homologacao
		Comentário.: PADRONIZAÇÃO T-SQL E FORMATAÇÃO.
		*/


		DECLARE @dtref CHAR(6),
		        @dtref_ant CHAR(6),
		        @cdep INT,
		        @cdep_ant INT,
		        @vl_ant MONEY,
		        @vl_total MONEY,
		        @qt_benef INT,
		        @nrnf INT

		SET @dtref = RIGHT('00' + CONVERT(NVARCHAR(2) , @mes) , 2) + RIGHT('0000' + CONVERT(NVARCHAR(4) , @ano) , 4)

		IF @mes > 1 SET @dtref_ant = RIGHT('00' + CONVERT(NVARCHAR(2) , @mes - 1) , 2) + RIGHT('0000' + CONVERT(NVARCHAR(4) , @ano) , 4) ELSE
		SET @dtref_ant = '12' + RIGHT('0000' + CONVERT(NVARCHAR(4) , @ano - 1) , 4)

		/* verifica se competência está gerada */
		IF (SELECT
            	COUNT(0)
            FROM ans_ep_nf
            WHERE dt_ref = @dtref
		) > 0 BEGIN
			RAISERROR ('Competência já existente.' , 1 , 1)
			RETURN
		END


		DECLARE cursor_ans CURSOR
		FOR SELECT DISTINCT
            	   notafiscal.CD_EMPRESA ,
            	   ISNULL((SELECT TOP 1
                           	vl_nf
                           FROM ans_ep_nf
                           WHERE ans_ep_nf.CD_EMPRESA = notafiscal.CD_EMPRESA
                           AND dt_ref = @dtref_ant) , 0) ,
            	   vl_total ,
            	   CONVERT(INT , vl_total / vl_plano_ans) ,
            	   nr_nota
            FROM notafiscal
            	INNER JOIN EMPRESA ON notafiscal.CD_EMPRESA = EMPRESA.CD_EMPRESA
            WHERE MONTH(dt_emissao) = @mes
            AND YEAR(dt_emissao) = @ano
            /*mes_ref= @mes and ano_ref= @ano*/
            ORDER BY notafiscal.CD_EMPRESA
		OPEN cursor_ans
		FETCH NEXT FROM cursor_ans INTO @cdep , @vl_ant , @vl_total , @qt_benef , @nrnf
		WHILE (@@fetch_status <> -1)
		BEGIN
			/*if @cdep_ant!=@cdep*/
			INSERT INTO ans_ep_nf ( dt_ref,
			                        CD_EMPRESA,
			                        vl_nf_anterior,
			                        vl_nf,
			                        qt_benef,
			                        nr_nf )
			VALUES ( @dtref,
			         @cdep,
			         @vl_ant,
			         @vl_total,
			         @qt_benef,
			         @nrnf )

			SET @cdep_ant = @cdep

			FETCH NEXT FROM cursor_ans INTO @cdep , @vl_ant , @vl_total , @qt_benef , @nrnf
		END
		DEALLOCATE cursor_ans




	END
