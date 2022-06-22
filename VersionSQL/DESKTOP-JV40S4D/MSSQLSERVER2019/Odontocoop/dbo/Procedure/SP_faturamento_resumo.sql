/****** Object:  Procedure [dbo].[SP_faturamento_resumo]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[SP_faturamento_resumo] @dt_inicio VARCHAR(10),
	@dt_fim VARCHAR(30)
AS
BEGIN
	DECLARE @Valor MONEY
	DECLARE @Qtde MONEY
	DECLARE @filial INT
	DECLARE @aux INT

	DELETE Resumo_Faturamento_caixa

	INSERT INTO Resumo_Faturamento_caixa
	SELECT cd_filial,
		0,
		0,
		0,
		0,
		0,
		0,
		0
	FROM filial

	/* select para os campos Faturado */
	DECLARE cursor_atrasado CURSOR
	FOR
	SELECT a.cd_filial,
		Sum(m.VL_PARCELA),
		1
	FROM mensalidades AS m,
		associados AS a,
		Resumo_Faturamento_caixa AS t
	WHERE m.cd_associado_Empresa = a.cd_associado
		AND m.DT_vencimento >= @dt_inicio
		AND m.DT_vencimento <= @dt_fim
		AND m.tp_associado_empresa = 1
		AND m.cd_tipo_recebimento NOT IN (
			1,
			2
			)
		AND a.cd_filial = t.cd_filial
		AND m.cd_tipo_pagamento <> 60
		AND (
			a.cd_situacao IN (
				SELECT CD_SITUACAO_HISTORICO
				FROM SITUACAO_HISTORICO
				WHERE fl_gera_cobranca = 1
				)
			OR m.dt_pagamento IS NOT NULL
			)
	GROUP BY a.cd_filial
	
	UNION
	
	SELECT a1.cd_filial,
		Sum(m1.VL_PARCELA),
		2
	FROM mensalidades AS m1,
		EMPRESA AS a1,
		Resumo_Faturamento_caixa AS t1
	WHERE m1.cd_associado_Empresa = a1.cd_EMPRESA
		AND m1.DT_vencimento >= @dt_inicio
		AND m1.DT_vencimento <= @dt_fim
		AND m1.tp_associado_empresa = 2
		AND m1.cd_tipo_recebimento NOT IN (
			1,
			2
			)
		AND a1.cd_filial = t1.cd_filial
		AND a1.tp_empresa = 2
		AND m1.CD_TIPO_PAGaMENTO = 60
		AND m1.cd_associado_empresa != 32085
		AND (
			a1.cd_situacao IN (
				SELECT CD_SITUACAO_HISTORICO
				FROM SITUACAO_HISTORICO
				WHERE fl_gera_cobranca = 1
				)
			OR m1.dt_pagamento IS NOT NULL
			)
	GROUP BY a1.cd_filial

	OPEN cursor_atrasado

	FETCH NEXT
	FROM cursor_atrasado
	INTO @filial,
		@Valor,
		@aux

	WHILE (@@FETCH_STATUS <> - 1)
	BEGIN
		/* Inserir no campo faturadovalor e FaturadoQtde */
		UPDATE Resumo_Faturamento_caixa
		SET FaturadoValor = FaturadoValor + @Valor
		WHERE cd_filial = @filial

		FETCH NEXT
		FROM cursor_atrasado
		INTO @filial,
			@Valor,
			@aux
	END

	DEALLOCATE cursor_atrasado

	/* Recebido Periodo */
	DECLARE cursor_atrasado CURSOR
	FOR
	SELECT a.cd_filial,
		Sum(m.VL_Pago),
		1
	FROM mensalidades AS m,
		associados AS a,
		Resumo_Faturamento_caixa AS t
	WHERE m.cd_associado_Empresa = a.cd_associado
		AND m.DT_vencimento >= @dt_inicio
		AND m.DT_vencimento <= @dt_fim
		AND m.DT_pagamento >= @dt_inicio
		AND m.DT_pagamento <= @dt_fim
		AND m.tp_associado_empresa = 1
		AND a.CD_filial = t.cd_filial
		AND m.cd_tipo_pagamento <> 60
	GROUP BY a.cd_filial
	
	UNION
	
	SELECT a1.CD_filial,
		Sum(m1.VL_Pago),
		2
	FROM mensalidades AS m1,
		EMPRESA AS a1,
		Resumo_Faturamento_caixa AS t1
	WHERE m1.cd_associado_Empresa = a1.cd_EMPRESA
		AND m1.DT_vencimento >= @dt_inicio
		AND m1.DT_vencimento <= @dt_fim
		AND m1.DT_pagamento >= @dt_inicio
		AND m1.DT_pagamento <= @dt_fim
		AND m1.tp_associado_empresa = 2
		AND a1.tp_empresa = 2
		AND a1.cd_filial = t1.cd_filial
		AND m1.CD_TIPO_PAGaMENTO = 60
		AND m1.cd_associado_empresa != 32085
	GROUP BY a1.CD_filial

	OPEN cursor_atrasado

	FETCH NEXT
	FROM cursor_atrasado
	INTO @filial,
		@Valor,
		@aux

	WHILE (@@FETCH_STATUS <> - 1)
	BEGIN
		/* Inserir nos campos Recebidovalor e recebidoQtde*/
		UPDATE Resumo_Faturamento_caixa
		SET recebidoValor = recebidoValor + @Valor
		WHERE cd_filial = @filial

		FETCH NEXT
		FROM cursor_atrasado
		INTO @filial,
			@Valor,
			@aux
	END

	DEALLOCATE cursor_atrasado

	/* Recebimento Fora do Período */
	DECLARE cursor_atrasado CURSOR
	FOR
	SELECT a.CD_filial,
		Sum(m.VL_Pago),
		1
	FROM mensalidades AS m,
		associados AS a,
		Resumo_Faturamento_caixa AS t
	WHERE m.cd_associado_Empresa = a.cd_associado
		AND m.DT_pagamento >= @dt_inicio
		AND m.DT_pagamento <= @dt_fim
		AND m.tp_associado_empresa = 1
		AND a.cd_filial = t.cd_filial
		AND m.cd_tipo_pagamento <> 60
		AND (
			m.DT_vencimento < @dt_inicio
			OR m.DT_vencimento > @dt_fim
			)
	GROUP BY a.cd_filial
	
	UNION
	
	SELECT a1.cd_filial,
		Sum(m1.VL_Pago),
		2
	FROM mensalidades AS m1,
		EMPRESA AS a1,
		Resumo_Faturamento_caixa AS t1
	WHERE m1.cd_associado_Empresa = a1.cd_EMPRESA
		AND m1.DT_pagamento >= @dt_inicio
		AND m1.DT_pagamento <= @dt_fim
		AND m1.tp_associado_empresa = 2
		AND a1.cd_filial = t1.cd_filial
		AND m1.CD_TIPO_PAGaMENTO = 60
		AND m1.cd_associado_empresa != 32085
		AND a1.tp_empresa = 2
		AND (
			m1.DT_vencimento < @dt_inicio
			OR m1.DT_vencimento > @dt_fim
			)
	GROUP BY a1.cd_filial

	OPEN cursor_atrasado

	FETCH NEXT
	FROM cursor_atrasado
	INTO @filial,
		@Valor,
		@aux

	WHILE (@@FETCH_STATUS <> - 1)
	BEGIN
		/* Inserir nos campos RecebidovalorFora e recebidoQtdeFora*/
		UPDATE Resumo_Faturamento_caixa
		SET recebidoValorFora = recebidoValorFora + @Valor
		WHERE cd_filial = @filial

		FETCH NEXT
		FROM cursor_atrasado
		INTO @filial,
			@Valor,
			@aux
	END

	DEALLOCATE cursor_atrasado

	/* Resumo_Faturamento_caixa */
	DECLARE cursor_atrasado CURSOR
	FOR
	SELECT a.cd_filial,
		Sum(m.VL_Parcela),
		1
	FROM mensalidades AS m,
		associados AS a,
		Resumo_Faturamento_caixa AS t
	WHERE m.cd_associado_Empresa = a.cd_associado
		AND m.DT_vencimento >= @dt_inicio
		AND m.DT_vencimento <= @dt_fim
		AND m.cd_tipo_recebimento = 0
		AND m.tp_associado_empresa = 1
		AND a.CD_filial = t.cd_filial
		AND m.cd_tipo_pagamento <> 60
		AND a.cd_situacao IN (
			SELECT CD_SITUACAO_HISTORICO
			FROM SITUACAO_HISTORICO
			WHERE fl_gera_cobranca = 1
			)
	GROUP BY a.CD_filial
	
	UNION
	
	SELECT a1.cd_filial,
		Sum(m1.VL_Parcela),
		2
	FROM mensalidades AS m1,
		EMPRESA AS a1,
		Resumo_Faturamento_caixa AS t1
	WHERE m1.cd_associado_Empresa = a1.cd_EMPRESA
		AND m1.DT_vencimento >= @dt_inicio
		AND m1.DT_vencimento <= @dt_fim
		AND m1.cd_tipo_recebimento = 0
		AND m1.tp_associado_empresa = 2
		AND a1.CD_filial = t1.cd_filial
		AND m1.CD_TIPO_PAGaMENTO = 60
		AND m1.cd_associado_empresa != 32085
		AND a1.tp_empresa = 2
		AND a1.cd_situacao IN (
			SELECT CD_SITUACAO_HISTORICO
			FROM SITUACAO_HISTORICO
			WHERE fl_gera_cobranca = 1
			)
	GROUP BY a1.cd_filial

	OPEN cursor_atrasado

	FETCH NEXT
	FROM cursor_atrasado
	INTO @filial,
		@Valor,
		@aux

	WHILE (@@FETCH_STATUS <> - 1)
	BEGIN
		/* Inserir nos campos Atrasadovalor e AtrasadoQtde*/
		UPDATE Resumo_Faturamento_caixa
		SET atrasadoValor = atrasadoValor + @Valor
		WHERE cd_filial = @filial

		FETCH NEXT
		FROM cursor_atrasado
		INTO @filial,
			@Valor,
			@aux
	END

	DEALLOCATE cursor_atrasado

	/* Pagamento Fora do Período */
	DECLARE cursor_atrasado CURSOR
	FOR
	SELECT a.cd_filial,
		Sum(m.VL_Pago),
		1
	FROM mensalidades AS m,
		associados AS a,
		Resumo_Faturamento_caixa AS t
	WHERE m.cd_associado_Empresa = a.cd_associado
		AND m.DT_vencimento >= @dt_inicio
		AND m.DT_vencimento <= @dt_fim
		AND m.tp_associado_empresa = 1
		AND a.CD_filial = t.cd_filial
		AND m.cd_tipo_pagamento <> 60
		AND (
			m.DT_pagamento < @dt_inicio
			OR m.DT_pagamento > @dt_fim
			)
	GROUP BY a.CD_filial
	
	UNION
	
	SELECT a1.CD_filial,
		Sum(m1.VL_Pago),
		2
	FROM mensalidades AS m1,
		EMPRESA AS a1,
		Resumo_Faturamento_caixa AS t1
	WHERE m1.cd_associado_Empresa = a1.cd_EMPRESA
		AND m1.DT_vencimento >= @dt_inicio
		AND m1.DT_vencimento <= @dt_fim
		AND m1.tp_associado_empresa = 2
		AND a1.CD_filial = t1.cd_filial
		AND m1.CD_TIPO_PAGaMENTO = 60
		AND m1.cd_associado_empresa != 32085
		AND a1.tp_empresa = 2
		AND (
			m1.DT_pagamento < @dt_inicio
			OR m1.DT_pagamento > @dt_fim
			)
		AND m1.dt_pagamento IS NOT NULL
	GROUP BY a1.CD_filial

	OPEN cursor_atrasado

	FETCH NEXT
	FROM cursor_atrasado
	INTO @filial,
		@Valor,
		@aux

	WHILE (@@FETCH_STATUS <> - 1)
	BEGIN
		/* Inserir nos campos RecebidovalorFora e recebidoQtdeFora*/
		UPDATE Resumo_Faturamento_caixa
		SET PagoValorFora = PagoValorFora + @Valor
		WHERE cd_filial = @filial

		FETCH NEXT
		FROM cursor_atrasado
		INTO @filial,
			@Valor,
			@aux
	END

	DEALLOCATE cursor_atrasado

	/* Peso */
	/*
    DECLARE cursor_atrasado CURSOR FOR 
     SELECT a.CD_filial, sum(case 
 when p.vl_pago_produtividade_cred = 0 then p.vl_pago_produtividade 
  else p.vl_pago_produtividade_cred 
 end) , count(*)
       FROM associados as a, Resumo_Faturamento_caixa as t , consultas as m , produtividade_filial as p 
      WHERE a.cd_associado = m.cd_Associado and 
            a.CD_filial = t.cd_filial and 
            m.cd_empresa = p.cd_filial and m.cd_servico = p.cd_servico and 
            m.dt_servico>= @dt_inicio and m.dt_servico<= @dt_fim 
      GROUP BY  a.CD_filial
  
   OPEN cursor_atrasado 
  FETCH NEXT FROM cursor_atrasado INTO @filial, @Valor
  WHILE (@@FETCH_STATUS <> -1)
  BEGIN

      update Resumo_Faturamento_caixa 
         set valoruso=@valor
       where cd_filial = @filial

     FETCH NEXT FROM cursor_atrasado INTO @filial, @Valor
   END
   DEALLOCATE cursor_atrasado
*/
	DELETE Resumo_Faturamento_caixa_financeiro

	INSERT Resumo_Faturamento_caixa_financeiro (
		cd_conta_reduzida,
		nm_titulo,
		ds_tipo_conta,
		valor,
		cd_filial
		)
	SELECT c.cd_conta_reduzida,
		tp.ds_tipo_conta + ' - ' + c1.nm_titulo,
		tp.ds_tipo_conta,
		sum(i.vl_pagamento) AS total,
		c.cd_filial
	FROM item_lancamento AS i
	INNER JOIN contas AS c ON i.cd_conta = c.cd_conta
	INNER JOIN contas AS c1 ON c.cd_conta_reduzida = c1.cd_conta
	LEFT OUTER JOIN tipo_conta AS tp ON c.cd_tipo_conta = tp.cd_tipo_conta
	WHERE i.dt_pagamento >= @dt_inicio
		AND i.dt_pagamento <= @dt_fim
		AND c.cd_tipo_conta <> 6
		AND i.tp_lancamento = 1
	GROUP BY c.cd_conta_reduzida,
		tp.ds_tipo_conta,
		c1.nm_titulo,
		c.cd_filial
	ORDER BY c.cd_filial,
		tp.ds_tipo_conta,
		c.cd_conta_reduzida

	DELETE Resumo_Faturamento_caixa
	WHERE FaturadoValor = 0
		AND RecebidoValor = 0
		AND RecebidoValorFora = 0
		AND AtrasadoValor = 0
		AND PagoValorFora = 0
		AND cd_filial NOT IN (
			SELECT cd_filial
			FROM Resumo_Faturamento_caixa_financeiro
			)
END
