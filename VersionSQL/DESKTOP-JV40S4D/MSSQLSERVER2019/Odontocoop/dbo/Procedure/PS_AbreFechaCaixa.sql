/****** Object:  Procedure [dbo].[PS_AbreFechaCaixa]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE dbo.PS_AbreFechaCaixa
-- =============================================
-- Author:      henrique.almeida
-- Create date: 13/09/2021 11:14
-- Database:    S4ECLEAN
-- Description: REALIZADO PADRONIZAÇÃO E FORMATAÇÃO DE ESTILO T-SQL
-- =============================================


(
                 @Valor_Final AS MONEY ,
                 @Sequencial_Historico AS INT ,
                 @Usuario AS VARCHAR(40) ,
                 @Data_LancamentoInicial AS DATETIME ,
                 @Data_LancamentoFinal AS DATETIME
)
AS
  BEGIN
    DECLARE @Sequencial_Movimentacao INT
    DECLARE @Sequencial_HistoricoNew INT
    DECLARE @ValorExcedentePago MONEY
    DECLARE @ValorExcedenteRecebido MONEY

    BEGIN TRANSACTION
    PRINT 'inicio'


    SET @ValorExcedentePago = (SELECT ISNULL(SUM(Valor_Lancamento) , 0) AS SaldoRecebimento
        FROM TB_FormaLancamento T1 , TB_Lancamento T2
        WHERE T1.Sequencial_Lancamento = T2.Sequencial_Lancamento
              AND
              T1.Tipo_ContaLancamento = 1
              AND
              T2.Tipo_Lancamento = 2
              AND
              T2.Data_HoraExclusao IS NULL
              AND
              T1.Sequencial_Historico = @Sequencial_Historico
              AND
              Data_pagamento > @Data_LancamentoInicial
    ) SET @ValorExcedenteRecebido = (SELECT ISNULL(SUM(Valor_Lancamento) , 0) AS SaldoRecebimento
        FROM TB_FormaLancamento T1 , TB_Lancamento T2
        WHERE T1.Sequencial_Lancamento = T2.Sequencial_Lancamento
              AND
              T1.Tipo_ContaLancamento = 1
              AND
              T2.Tipo_Lancamento = 1
              AND
              T2.Data_HoraExclusao IS NULL
              AND
              T1.Sequencial_Historico = @Sequencial_Historico
              AND
              Data_pagamento > @Data_LancamentoInicial
    ) SELECT @Sequencial_Movimentacao = Sequencial_Movimentacao
    FROM TB_HistoricoMovimentacao
    WHERE Sequencial_Historico = @Sequencial_Historico

    -- Fechando Caixa.
    UPDATE TB_HistoricoMovimentacao
           SET Data_Fechamento = @Data_LancamentoInicial ,
               Valor_Saldo_Final = @Valor_Final - @ValorExcedenteRecebido + @ValorExcedentePago ,
               Data_Hora_Fechamento = GETDATE() ,
               nome_usuario = @Usuario ,
               Data_LancamentoFinal = @Data_LancamentoFinal
    WHERE Sequencial_Historico = @Sequencial_Historico


    -- Criando novo caixa.                       
    INSERT INTO TB_HistoricoMovimentacao (Data_Abertura , Valor_Saldo_Inicial , Sequencial_Movimentacao , Data_Hora_Abertura , nome_usuario , Data_LancamentoInicial)
           SELECT DATEADD(DAY , 1 , @Data_LancamentoInicial) , @Valor_Final - @ValorExcedenteRecebido + @ValorExcedentePago , Sequencial_Movimentacao , GETDATE() , @Usuario , @Data_LancamentoInicial
           FROM TB_HistoricoMovimentacao
           WHERE Sequencial_Historico = @Sequencial_Historico

    SET @Sequencial_HistoricoNew = SCOPE_IDENTITY()

    UPDATE TB_FormaLancamento
           SET Sequencial_Historico = @Sequencial_HistoricoNew
    WHERE Data_pagamento > @Data_LancamentoInicial
           AND
           Sequencial_Historico = @Sequencial_Historico

    IF @Data_LancamentoInicial < (SELECT TOP 1 Data_Abertura
          FROM TB_HistoricoMovimentacao
          WHERE Sequencial_Historico = @Sequencial_Historico
      )
      BEGIN
        ROLLBACK TRANSACTION
        RAISERROR ('Data não pode ser inferior a competência atual do caixa aberto.' , 16 , 1)
        RETURN
      END
    -- Antes de abrir ou fechar o caixa atual, verificar já não existe caixa aberto

    IF (SELECT COUNT(Sequencial_Historico)
          FROM TB_HistoricoMovimentacao
          WHERE Sequencial_Movimentacao = @Sequencial_Movimentacao
                AND
                Data_Hora_Fechamento IS NULL
      ) > 1
      BEGIN
        ROLLBACK TRANSACTION
        RAISERROR ('Não pode existir dois caixas abertos ao mesmo tempo.' , 16 , 1)
        RETURN
      END

    COMMIT TRANSACTION

  END
