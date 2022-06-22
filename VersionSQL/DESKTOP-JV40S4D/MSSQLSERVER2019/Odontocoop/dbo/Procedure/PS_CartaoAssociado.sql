/****** Object:  Procedure [dbo].[PS_CartaoAssociado]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		marcio
-- Create date: 27/06/2007
-- =============================================
/*
Data e Hora.: 2022-05-24 14:49:42
Usuário.: henrique.almeida
Database.: S4ECLEAN
Servidor.: 10.1.1.10\homologacao
Comentário.: REALIZADO PADRONIZAÇÃO T-SQL E FORMATAÇÃO.
TRECHOS NO CÓDIGO FORAM DEIXADOS COMENTADOS PARA HISTORICO.
*/

CREATE PROCEDURE [dbo].[PS_CartaoAssociado] (
	@CD_Associado INT)
AS BEGIN
		SET NOCOUNT ON;
		-- Mostrar os cartões dental pass cadastrados para associado assim como
		-- valor restante de uso para cada um.
		--SELECT
		--      	RIGHT('00' + CONVERT(VARCHAR(2), T1.Valor_Cartao), 2) +
		--      	RIGHT('000000' + CONVERT(VARCHAR(6), T1.CD_EMPRESA), 6) +
		--      	RIGHT('0000' + CONVERT(VARCHAR(4), T1.Numero_Cartao), 4) +
		--      	RIGHT('00' + CONVERT(VARCHAR(2), Digito_Verificador), 2) AS cartao ,
		--      	T2.Valor AS Valor_Cartao ,
		--      	(SELECT
		--           	ISNULL(SUM(Valor_Lancamento), 0)
		--           FROM ABS_Financeiro..TB_FormaLancamento T100,
		--           	ABS_Financeiro..TB_Lancamento T200
		--           WHERE T100.Tipo_ContaLancamento = 1
		--           AND T100.Forma_Lancamento = 7
		--           AND T100.Sequencial_Cartao = T1.Sequencial_Cartao
		--           AND T100.Sequencial_Lancamento = T200.Sequencial_Lancamento
		--           AND T200.Data_HoraExclusao IS NULL)
		--      	AS ValorUsado ,
		--      	T1.Sequencial_Cartao
		--      FROM TB_Cartao T1,
		--      	ABS_Financeiro..TB_ValorDominio T2
		--      WHERE T1.Valor_Cartao = T2.CodigoValorDominio
		--      AND T2.CodigoDominio = 10
		--      AND T1.cd_associado = @CD_Associado

		SELECT
        	RIGHT('00' + CONVERT(VARCHAR(2), T1.Valor_Cartao), 2) +
        	RIGHT('000000' + CONVERT(VARCHAR(6), T1.CD_EMPRESA), 6) +
        	RIGHT('0000' + CONVERT(VARCHAR(4), T1.Numero_Cartao), 4) +
        	RIGHT('00' + CONVERT(VARCHAR(2), Digito_Verificador), 2) AS cartao ,
        	T2.Valor AS Valor_Cartao ,
        	(
        	SELECT
            	ISNULL(SUM(Valor_Lancamento), 0)
            FROM ABS_Financeiro..TB_FormaLancamento T100
            	INNER JOIN ABS_Financeiro..TB_Lancamento T200 ON T100.SEQUENCIAL_LANCAMENTO = T200.SEQUENCIAL_LANCAMENTO
            WHERE T100.Tipo_ContaLancamento = 1
            AND T100.Forma_Lancamento = 7
            AND T100.Sequencial_Cartao = T1.Sequencial_Cartao
            AND T200.Data_HoraExclusao IS NULL )
        	AS ValorUsado ,
        	T1.Sequencial_Cartao
        FROM TB_Cartao T1
        	INNER JOIN ABS_Financeiro..TB_ValorDominio T2 ON T1.Valor_Cartao = T2.CodigoValorDominio
        WHERE T2.CodigoDominio = 10
        AND T1.cd_associado = @CD_Associado

	END
