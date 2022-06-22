/****** Object:  Procedure [dbo].[CABECALHO_LOTE]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[CABECALHO_LOTE]
	@IntCd_Lote AS VARCHAR(10)
AS

/*
Data e Hora.: 2022-05-24 14:08:36
Usuário.: henrique.almeida
Database.: S4ECLEAN
Servidor.: 10.1.1.10\homologacao
Comentário.: REALIZADO PADRONIZAÇÃO T-SQL E FORMATAÇÃO.
QUERY ANTIGA DEIXA COMENTADA.
*/

/*
ESSA PROCEDURE POSSUI UM PARAMETRO DE ENTRADA @IntCd_Lote
ESSA PROCEDURE REALIZA UM SELECT NAS TABELAS .:
dbo.FUNCIONARIO, 
dbo.Item_Lote, 
dbo.Lote, 
dbo.equipe_vendas

OBS.: O PRIMEIRO COMENTÁRIO ACIMA ENCONTRA-SE COMENTADO SEM FUNCIONADA NESSA PROCEDURE. HENRIQUE 09:19 21/07/2021*/


	--SELECT
	--   	dbo.Item_Lote.nr_contrato ,
	--   	dbo.Item_Lote.nm_completo ,
	--   	dbo.Item_Lote.Valor ,
	--   	CONVERT (varchar(12),dbo.Item_Lote.DtVenda,103) DtVenda ,
	--   	dbo.Item_Lote.Empresa ,
	--   	dbo.FUNCIONARIO.nm_abreviado VENDEDOR ,
	--   	CONVERT (varchar(12),dbo.Lote.Dt_Inclusao,103) Dt_Inclusao ,
	--   	dbo.Lote.Cd_Lote ,
	--   	dbo.Lote.Cd_Usuario ,
	--   	dbo.Lote.QtdContratos ,
	--   	dbo.equipe_vendas.nm_equipe ,
	--   	dbo.Lote.Cd_Equipe
	--   FROM dbo.FUNCIONARIO,
	--   	dbo.Item_Lote,
	--   	dbo.Lote,
	--   	dbo.equipe_vendas
	--   WHERE dbo.Lote.Cd_Lote = @IntCd_Lote
	--   AND dbo.FUNCIONARIO.cd_funcionario = dbo.Item_Lote.cd_funcionario
	--   AND dbo.Item_Lote.Cd_Lote = dbo.Lote.Cd_Lote
	--   AND dbo.Lote.Cd_Equipe = dbo.equipe_vendas.cd_equipe
	--   ORDER BY dbo.Item_Lote.nm_completo


	SELECT
    	dbo.Item_Lote.nr_contrato ,
    	dbo.Item_Lote.nm_completo ,
    	dbo.Item_Lote.Valor ,
    	CONVERT (varchar(12),dbo.Item_Lote.DtVenda,103) DtVenda ,
    	dbo.Item_Lote.Empresa ,
    	dbo.FUNCIONARIO.nm_abreviado VENDEDOR ,
    	CONVERT (varchar(12),dbo.Lote.Dt_Inclusao,103) Dt_Inclusao ,
    	dbo.Lote.Cd_Lote ,
    	dbo.Lote.Cd_Usuario ,
    	dbo.Lote.QtdContratos ,
    	dbo.equipe_vendas.nm_equipe ,
    	dbo.Lote.Cd_Equipe
    FROM dbo.FUNCIONARIO
    	INNER JOIN dbo.Item_Lote ON dbo.FUNCIONARIO.cd_funcionario = dbo.Item_Lote.cd_funcionario
    	INNER JOIN dbo.Lote ON dbo.Item_Lote.Cd_Lote = dbo.Lote.Cd_Lote
    	INNER JOIN dbo.equipe_vendas ON dbo.Lote.Cd_Equipe = dbo.equipe_vendas.cd_equipe
    WHERE dbo.Lote.Cd_Lote = @IntCd_Lote
    ORDER BY dbo.Item_Lote.nm_completo
