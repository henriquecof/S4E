/****** Object:  Procedure [dbo].[PS_DeletaProduto]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[PS_DeletaProduto](@CD_PRODUTO As Int)
AS
   Begin

               Begin Transaction
               
               Delete From Orcamento_Produto 
                  From  Solicitacao_Produto T2, Orcamento_Produto T1
                  Where T1.CD_Solicitacao_Produto = T2.CD_Solicitacao_Produto And
                        T2.CD_Produto = @CD_PRODUTO

               Delete From Solicitacao_Produto
                    Where CD_Produto = @CD_PRODUTO

               Delete From Requisicao_Consumo
                    Where CD_Produto = @CD_PRODUTO

               Delete From Estoque
                    Where CD_Produto = @CD_PRODUTO

               Delete From produtos_inventario
                    Where CD_Produto = @CD_PRODUTO

               Delete From movimento_inventario
                    Where CD_Produto = @CD_PRODUTO

               Delete From transferencia_estoque
                    Where CD_Produto = @CD_PRODUTO

               Delete From Produtos Where CD_Produto = @CD_PRODUTO

               Commit Transaction
         End 
