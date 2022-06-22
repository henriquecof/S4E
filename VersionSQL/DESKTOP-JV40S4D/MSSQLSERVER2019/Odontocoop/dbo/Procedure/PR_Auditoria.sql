/****** Object:  Procedure [dbo].[PR_Auditoria]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE dbo.PR_Auditoria
                 @NomeUsuario VARCHAR(20) ,
                 @NomeCampoAuditado VARCHAR(100) ,
                 @ValorCampoAuditado VARCHAR(100) ,
                 @TipoOperacao INT ,
                 @SequencialTabela INT ,
                 @Descricao1 VARCHAR(350) ,
                 @Descricao2 VARCHAR(350)
-- =============================================
-- Author:      henrique.almeida
-- Create date: 13/09/2021 11:09
-- Database:    S4ECLEAN
-- Description: REALIZADO PADRONIZAÇÃO E FORMATAÇÃO DE ESTILO T-SQL
-- =============================================


AS
  /* Tipos de Operação:
  	1 - Insert
  	2 - Update
  	3 - Delete
  	4 - Calculo
  	...(Pode haver mais operações) */

  BEGIN

    RETURN
    INSERT TB_Auditoria (DataAuditoria , SequencialTabela , TipoOperacao , Descricao1 , Descricao2 , NomeUsuario , NomeCampoAuditado , ValorCampoAuditado)
    VALUES (GETDATE() , @SequencialTabela , @TipoOperacao , @Descricao1 , @Descricao2 , @NomeUsuario , @NomeCampoAuditado , @ValorCampoAuditado)


  END
