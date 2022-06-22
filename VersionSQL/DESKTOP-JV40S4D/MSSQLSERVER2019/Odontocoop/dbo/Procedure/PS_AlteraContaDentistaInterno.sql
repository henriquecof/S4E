/****** Object:  Procedure [dbo].[PS_AlteraContaDentistaInterno]    Committed by VersionSQL https://www.versionsql.com ******/

/*-----------------------------------------------------------
Criado por Marcio N. Costa
Objetivo : Alterar contas dentitas internos
-------------------------------------------------------------*/
CREATE PROCEDURE dbo.PS_AlteraContaDentistaInterno (
                 @contas VARCHAR(1000)
)
-- =============================================
-- Author:      henrique.almeida
-- Create date: 13/09/2021 11:29
-- Database:    S4ECLEAN
-- Description: REALIZADO PADRONIZAÇÃO E FORMATAÇÃO DE ESTILO T-SQL
-- =============================================


AS
  BEGIN

    DECLARE @Sequencial_Conta VARCHAR(20)
    DECLARE @filial VARCHAR(20)

    WHILE @contas <> ''
      BEGIN
        SET @filial = SUBSTRING(@contas , 1 , dbo.InStr('|' , @contas) - 1)
        SET @Sequencial_Conta = SUBSTRING(@contas , dbo.InStr('|' , @contas) + 1 , (dbo.InStr('*' , @contas) - 1) - (dbo.InStr('|' , @contas)))
        SET @contas = SUBSTRING(@contas , dbo.InStr('*' , @contas) + 1 , LEN(@contas))

        IF LTRIM(@Sequencial_Conta) = '0'
          UPDATE dbo.FILIAL
                 SET Sequencial_Conta = NULL
          WHERE cd_filial = @filial
        ELSE
          UPDATE dbo.FILIAL
                 SET Sequencial_Conta = @Sequencial_Conta
          WHERE cd_filial = @filial

      END
  END
