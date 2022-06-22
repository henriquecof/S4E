/****** Object:  Procedure [dbo].[SP_AJustaConvenio]    Committed by VersionSQL https://www.versionsql.com ******/

/* 
 
    <alt>alteração</alt>
    <doc>
        <titulo>Colocar título</titulo>
        <descricao>motivo</descricao>
        <chamado>chamado ##</chamado>
    </doc>
 
*/

CREATE PROCEDURE [dbo].[SP_AJustaConvenio] (
	@convenio INT,
	@dt_ini DATE,
	@dt_fim DATE
	)
AS
BEGIN
	DECLARE @arq INT
	DECLARE @parc INT
	DECLARE @qtde SMALLINT
	DECLARE @sql VARCHAR(2000)

	DECLARE Dados_Cursor CURSOR
	FOR
	SELECT T1.cd_sequencial_retorno,
		T1.cd_parcela,
		COUNT(0) - 1 AS Expr1
	FROM Lote_Processos_Bancos_Retorno_Mensalidades AS T1
	INNER JOIN DEB_AUTOMATICO_CR AS T2 ON T1.cd_ocorrencia = T2.cd_ocorrencia
	LEFT OUTER JOIN MENSALIDADES AS T3 ON T1.cd_parcela = T3.CD_PARCELA
	INNER JOIN DEPENDENTES AS T4 ON T3.CD_ASSOCIADO_empresa = T4.CD_ASSOCIADO
	INNER JOIN ASSOCIADOS AS T8 ON T4.CD_ASSOCIADO = T8.cd_associado
	LEFT OUTER JOIN FUNCIONARIO AS T5 ON T4.cd_funcionario_dentista = T5.cd_funcionario
	INNER JOIN TIPO_PAGAMENTO AS T7 ON T3.CD_TIPO_PAGAMENTO = T7.cd_tipo_pagamento
	INNER JOIN Lote_Processos_Bancos_Retorno AS T6 ON T1.cd_sequencial_retorno = T6.cd_sequencial_retorno
	INNER JOIN PLANOS AS T9 ON T4.cd_plano = T9.cd_plano
	WHERE (T4.CD_GRAU_PARENTESCO = 1)
		AND (T6.qtde IS NOT NULL)
		AND (T1.cd_ocorrencia = 0)
		AND (T6.convenio = @convenio)
		AND (T1.dt_pago >= CONVERT(VARCHAR(10), @dt_ini, 101))
		AND (T1.dt_pago <= CONVERT(VARCHAR(10), @dt_fim, 101) + ' 23:59')
		AND (T1.fl_excluido IS NULL)
	GROUP BY T1.cd_sequencial_retorno,
		T1.cd_parcela
	HAVING (COUNT(0) > 1)
	ORDER BY T1.cd_parcela

	OPEN Dados_Cursor

	FETCH NEXT
	FROM Dados_Cursor
	INTO @arq,
		@parc,
		@qtde

	WHILE (@@fetch_status <> - 1)
	BEGIN
		SET @sql = 'update Lote_Processos_Bancos_Retorno_Mensalidades
                      set fl_excluido = 1 
                    where cd_sequencial_retorno = ' + CONVERT(VARCHAR(10), @arq) + '
                      and nr_linha in (select top ' + convert(VARCHAR(5), @qtde) + ' nr_linha 
                                         from Lote_Processos_Bancos_Retorno_Mensalidades
                                        where cd_sequencial_retorno = ' + CONVERT(VARCHAR(10), @arq) + '
                                          and fl_excluido is null 
                                          and cd_ocorrencia = 0 
                                          and cd_parcela = ' + CONVERT(VARCHAR(10), @parc) + ' ) '

		EXEC (@sql)

		FETCH NEXT
		FROM Dados_Cursor
		INTO @arq,
			@parc,
			@qtde
	END

	CLOSE Dados_Cursor

	DEALLOCATE Dados_Cursor
END
