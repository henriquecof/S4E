/****** Object:  Procedure [dbo].[DeducaoPrestadorCorretor_AtualizarLiquido]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE dbo.DeducaoPrestadorCorretor_AtualizarLiquido
                 @lote INT
-- =============================================
-- Author:      henrique.almeida
-- Create date: 10/09/2021 11:03
-- Database:    S4ECLEAN
-- Description: REALIZADO PADRONIZAÇÃO E FORMATAÇÃO DE ESTILO T-SQL
-- =============================================



/*
ESSA PROCEDURE ABRE UM BLOCO BEGIN/END
1º - DENTRO DO BLOCO SÃO DECLARADAS DUAS VARIAVEIS.:
 @vl_liquido money=0
 @vl_bruto money=0
2º REALIZADOS DOIS SELECTS.:
2.1º - REALIZADO SELECT NA TABELA LOTE_COMISSAO, USANDO NA CLAUSULA WHERE A CONDIÇÃO.: cd_sequencial = @lote. NESSE SELECT É RETORNO VALORES PARA A VARIAVEL @vl_bruto.
OBS.: DENTRTO DO SELECT, PARA A VARIAVEL @vl_bruto É CRIADA OUTRA VARIAVEL @lote.
2.2º - REALIZADO SELECT NA TABELA PAGAMENTO_CORRETOR_ALIQUOTAS, USANDO NA CLAUSULA WHERE A CONDIÇÃO.: 
id_retido = 1 
and dt_exclusao is null
and cd_lote_comissao = @lote.
OBS.: NESSE SELECT É RETORNADO VALORES PARA A VARIAVEL @vl_liquido
3º - REALIZADO UPDATE NA TABELA LOTE_COMISSAO, SETANDO OS VALORES.:
vl_total_bruto = @vl_bruto, 
vl_total = (@vl_bruto - @vl_liquido)

USADO COMO CONDIÇÃO NA CLAUSULA WHERE.:
where cd_sequencial = @lote
4º - FECHADO BLOCO BEGIN/END.

*/
AS
  BEGIN
    DECLARE @vl_liquido MONEY = 0
    DECLARE @vl_bruto MONEY = 0

    -- Atualizar lote de comissão
    SELECT @vl_bruto = ISNULL((SELECT SUM(ROUND(valor * perc_pagamento / 100 , 2)) FROM comissao_vendedor WHERE cd_sequencial_lote = @lote) , 0) -- case when vl_total_bruto IS null then vl_total else vl_total_bruto end 
    FROM lote_comissao
    WHERE cd_sequencial = @lote

    SELECT @vl_liquido = ISNULL(SUM(ISNULL(valor_aliquota , 0)) , 0)
    FROM Pagamento_Corretor_Aliquotas
    WHERE id_retido = 1
          AND
          dt_exclusao IS NULL
          AND
          cd_lote_comissao = @lote

    UPDATE lote_comissao
           SET vl_total_bruto = @vl_bruto ,
               vl_total = (@vl_bruto - @vl_liquido)
    WHERE cd_sequencial = @lote
  END
