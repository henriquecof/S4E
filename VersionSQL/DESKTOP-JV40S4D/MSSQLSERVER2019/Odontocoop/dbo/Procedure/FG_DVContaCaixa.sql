/****** Object:  Procedure [dbo].[FG_DVContaCaixa]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE dbo.FG_DVContaCaixa (
                 @Conta VARCHAR(15)
)
-- =============================================
-- Author:      henrique.almeida
-- Create date: 13/09/2021 09:32
-- Database:    S4ECLEAN
-- Description: REALIZADO PADRONIZAÇÃO E FORMATAÇÃO DE ESTILO T-SQL
-- REALIZAR DOCUMENTAÇÃO DA PROCEDURE USANDO EXTENDED PROPERTIES 
-- =============================================


AS
  BEGIN

    DECLARE @i INT
    DECLARE @NumeroPeso INT
    DECLARE @total INT
    DECLARE @resto INT
    DECLARE @peso VARCHAR(15)

    --------PESO-----------------------------
    SET @Peso = '876543298765432'

    --------CALCULO DO TOTAL-----------------------------
    SET @total = 0
    SET @i = 1
    WHILE @i <= 15
      BEGIN
        --select @total
        --select substring(@peso,@i,1),substring(@Conta, @i, 1)
        SET @total = @total + (CONVERT(INT , SUBSTRING(@peso , @i , 1)) * CONVERT(INT , SUBSTRING(@Conta , @i , 1)))
        SET @i = @i + 1
      END

    SET @total = @total * 10

    SET @resto = @total % 11

    IF @resto = 10
      SET @resto = 0


    SELECT @resto

  END
