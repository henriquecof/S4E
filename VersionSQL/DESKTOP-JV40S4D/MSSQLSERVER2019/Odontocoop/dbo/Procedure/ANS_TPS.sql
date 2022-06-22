/****** Object:  Procedure [dbo].[ANS_TPS]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[ANS_TPS] (
		@dt DATETIME = '01/01/1900')
AS
BEGIN
	DELETE Tps;-- Limpar a tabela

	DECLARE @qt INTEGER;
	DECLARE @qt1 INTEGER;
	DECLARE @qt2 INTEGER;
	DECLARE @abrangencia INTEGER;
	DECLARE @comp VARCHAR(6);

	IF @dt IS NULL
		OR @dt = '01/01/1900'
		SET @dt = DATEADD(YEAR, -1, CONVERT(DATETIME, CONVERT(VARCHAR(2), MONTH(GETDATE())) + '/01/' + CONVERT(VARCHAR(4), YEAR(GETDATE()))));

	WHILE @dt < GETDATE()
	BEGIN
	PRINT @dt;

	INSERT INTO Dbo.Tps (Competencia,
						 Qtde_menor_60,
						 Qtde_maior_60,
						 Total,
						 T2.Cd_abrangencia,
						 Ds_abrangencia)
		SELECT CONVERT(VARCHAR, YEAR(DATEADD(DAY, -1, @dt))) + '/' + RIGHT('00' + CONVERT(VARCHAR, MONTH(DATEADD(DAY, -1, @dt))), 2),
			   ISNULL(SUM(CASE
				   WHEN Dbo.Fs_idade(Dbo.Ans_beneficiarios.Dt_nascimento, @dt) < 60 THEN 1
				   ELSE 0
			   END), 0),
			   ISNULL(SUM(CASE
				   WHEN Dbo.Fs_idade(Dbo.Ans_beneficiarios.Dt_nascimento, @dt) < 60 THEN 0
				   ELSE 1
			   END), 0),
			   ISNULL(COUNT(0), 0),
			   ISNULL(T2.Cd_abrangencia, 0),
			   T3.Ds_abrangencia
		FROM Ans_beneficiarios, Classificacao_ans T2, Abrangencia T3
		WHERE Dbo.Ans_beneficiarios.Dt_inclusao < @dt
		AND (
		Dbo.Ans_beneficiarios.Dt_exclusao IS NULL
		OR CONVERT(DATE, Dbo.Ans_beneficiarios.Dt_exclusao) > @dt
		)
		AND Dbo.Ans_beneficiarios.Cd_plano_ans = T2.Cd_ans
		AND T2.Cd_abrangencia *= T3.Cd_abrangencia
		GROUP BY T2.Cd_abrangencia,
				 T3.Ds_abrangencia;


	--insert tps(competencia,qtde_menor_60,qtde_maior_60,total, cd_abrangencia)
	--values (convert(varchar,year(dateadd(day,-1,@dt))) + '/' + right('00'+convert(varchar,month(dateadd(day,-1,@dt))),2) , @qt1, @qt2, @qt, @abrangencia)
	SET @dt = DATEADD(MONTH, 1, @dt);
	END;

	SELECT *,
		   RIGHT(Competencia, 2) + '/01/' + LEFT(Competencia, 4) AS DT
	FROM Dbo.Tps
END;
