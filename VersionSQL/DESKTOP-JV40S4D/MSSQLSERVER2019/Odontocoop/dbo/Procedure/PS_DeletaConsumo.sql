/****** Object:  Procedure [dbo].[PS_DeletaConsumo]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[PS_DeletaConsumo] (@CD_REQUISICAO As Int, @NOMEUSUARIO As Varchar(20))
AS
   Begin

              Declare @QTD_Requisicao as float
              Declare @CD_Produto     as Int
              Declare @CD_Filial      as smallint

              Begin Transaction

              Select @QTD_Requisicao = QTD_Requisicao,
                     @CD_Produto     = CD_Produto,
                     @CD_Filial      = CD_Filial
              From Requisicao_Consumo
              Where CD_Requisicao = @CD_REQUISICAO

              Update Estoque 
                   Set QT_Estoque = QT_Estoque + @QTD_Requisicao,
                       nome_usuario = @NOMEUSUARIO  
                   Where CD_Produto     = @CD_Produto And 
                         CD_Filial      = @CD_Filial

              Update Requisicao_Consumo 
                   Set  nome_usuario = @NOMEUSUARIO  
                   Where CD_Requisicao = @CD_REQUISICAO

              Delete From Requisicao_Consumo Where CD_Requisicao = @CD_REQUISICAO

              Commit Transaction
   End 
