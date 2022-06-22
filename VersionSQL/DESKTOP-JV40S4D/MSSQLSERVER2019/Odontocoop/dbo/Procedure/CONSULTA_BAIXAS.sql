/****** Object:  Procedure [dbo].[CONSULTA_BAIXAS]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE dbo.CONSULTA_BAIXAS

-- =============================================
-- Author:      henrique.almeida
-- Create date: 10/09/2021 10:45
-- Database:    S4ECLEAN
-- Description: REALIZADO PADRONIZAÇÃO E FORMATAÇÃO DO ESTILO T-SQL
-- =============================================



                 /*
                 ESSA PROCEDURE DECLARA 3 VARIAVEIS.:
                 @dtini datetime,
                 @dtfim datetime,
                 @tp_ep int
                 
                 1º - ABERTURA DE BEGIN
                 2º - REALIZADO VERIFICAÇÃO NA CONDIÇÃO IF PARA A VARIAVEL (@tp_ep = 1)
                 2.1º - ABERTURA DE BEGIN
                 REALIZADO SELECT NAS TABELAS E JOINS.:
                 mensalidades inner join associados 
                 on mensalidades.cd_associado_empresa = associados.cd_associado and mensalidades.tp_associado_empresa = 1
                 left join empresa on associados.cd_empresa = empresa.cd_empresa
                 inner join tipo_pagamento on mensalidades.cd_tipo_pagamento = tipo_pagamento.cd_tipo_pagamento
                 inner join tipo_recebimento on mensalidades.cd_tipo_recebimento = tipo_recebimento.cd_tipo_recebimento
                 
                 USADO COMO CONDIÇÃO NA CLAUSULA WHERE.:
                 dt_baixa between @dtini and @dtfim
                 2.1.2º FECHADO BEGIN
                 3º - SAINDO DA CONDIÇÃO IF E CAINDO EM ELSE
                 3.1º -ABERTURA DE BEGIN 
                 REALIZANDO SELECT NAS TABELAS E JOINS.:
                 mensalidades inner join empresa on mensalidades.cd_associado_empresa = empresa.cd_empresa and mensalidades.tp_associado_empresa = 2
                 inner join tipo_pagamento on mensalidades.cd_tipo_pagamento = tipo_pagamento.cd_tipo_pagamento
                 inner join tipo_recebimento on mensalidades.cd_tipo_recebimento = tipo_recebimento.cd_tipo_recebimento
                 
                 USANDO COMO CONDIÇÃO NA CLAUSULA WHERE.:
                 dt_baixa between @dtini and @dtfim
                 3.1.2º - FECHAMENTO BEGIN
                 4º - FECHANDO BEGIN COM END DO ITEM 1º.
                 */
                 @dtini DATETIME ,
                 @dtfim DATETIME ,
                 @tp_ep INT
AS
  BEGIN

    IF (@tp_ep = 1)
      BEGIN
        SELECT CD_ASSOCIADO_empresa , nm_responsavel , nm_razsoc , CONVERT(VARCHAR(10) , MENSALIDADES.DT_VENCIMENTO , 103) , CONVERT(VARCHAR(10) , DT_PAGAMENTO , 103) , CONVERT(VARCHAR(10) , VL_PARCELA , 103) , CONVERT(VARCHAR(10) , MENSALIDADES.VL_Desconto , 103) , CONVERT(VARCHAR(10) , VL_PAGO , 103) , CONVERT(VARCHAR(10) , dt_baixa , 103) , CD_USUARIO_BAIXA , nm_tipo_pagamento , nm_tipo_recebimento
        FROM MENSALIDADES INNER JOIN ASSOCIADOS ON MENSALIDADES.CD_ASSOCIADO_empresa = ASSOCIADOS.CD_ASSOCIADO
                      AND
                      MENSALIDADES.TP_ASSOCIADO_EMPRESA = 1 LEFT JOIN EMPRESA ON ASSOCIADOS.CD_EMPRESA = EMPRESA.CD_EMPRESA INNER JOIN TIPO_PAGAMENTO ON MENSALIDADES.cd_tipo_pagamento = TIPO_PAGAMENTO.cd_tipo_pagamento INNER JOIN tipo_recebimento ON MENSALIDADES.CD_TIPO_RECEBIMENTO = tipo_recebimento.CD_TIPO_RECEBIMENTO
        WHERE dt_baixa BETWEEN @dtini AND @dtfim
        ORDER BY NM_RAZSOC , dt_baixa , nm_tipo_pagamento , nm_tipo_recebimento , nm_responsavel
      END
    ELSE
      BEGIN
        SELECT CD_ASSOCIADO_empresa , NM_RAZSOC , CONVERT(VARCHAR(10) , MENSALIDADES.dt_vencimento , 103) , CONVERT(VARCHAR(10) , DT_PAGAMENTO , 103) , CONVERT(VARCHAR(10) , VL_PARCELA , 103) , CONVERT(VARCHAR(10) , MENSALIDADES.VL_Desconto , 103) , CONVERT(VARCHAR(10) , VL_PAGO , 103) , CONVERT(VARCHAR(10) , dt_baixa , 103) , CD_USUARIO_BAIXA , nm_tipo_pagamento , nm_tipo_recebimento
        FROM MENSALIDADES INNER JOIN EMPRESA ON MENSALIDADES.CD_ASSOCIADO_empresa = EMPRESA.CD_EMPRESA
                      AND
                      MENSALIDADES.TP_ASSOCIADO_EMPRESA = 2 INNER JOIN TIPO_PAGAMENTO ON MENSALIDADES.cd_tipo_pagamento = TIPO_PAGAMENTO.cd_tipo_pagamento INNER JOIN tipo_recebimento ON MENSALIDADES.CD_TIPO_RECEBIMENTO = tipo_recebimento.CD_TIPO_RECEBIMENTO
        WHERE dt_baixa BETWEEN @dtini AND @dtfim
        ORDER BY dt_baixa , nm_tipo_recebimento , NM_RAZSOC
      END

  END
