/****** Object:  Procedure [dbo].[PS_FecharInventario]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[PS_FecharInventario](@CD_INVENTARIO AS INT,@NOME_USUARIO AS Varchar(20))
  As
       Begin

              Declare @CD_Filial As Int
              Declare @CD_Produto As Int, @QT_Produto As Float, @Quantidade As Float

              Begin Transaction

              /* Saber qual a filial desse inventario */
              Declare Inventario_Cursor  cursor for 
	      Select  CD_Filial
	      From    Inventario
	      Where   CD_Inventario  = @CD_INVENTARIO

              Open Inventario_Cursor
                   Fetch next from Inventario_Cursor 
                   Into @CD_Filial

              CLOSE Inventario_Cursor
              DEALLOCATE Inventario_Cursor

              /* Produtos do inventario que vão ser colocados no estoque */
              Declare Produtos_Cursor  cursor for 
	      Select  CD_PRODUTO, QT_PRODUTO
	      From    Produtos_Inventario
	      Where   CD_Inventario  = @CD_INVENTARIO 

              Open Produtos_Cursor
                   Fetch next from Produtos_Cursor 
                   Into @CD_PRODUTO, @QT_PRODUTO

              While (@@fetch_status  <> -1)
                 Begin
                     
                    Select @Quantidade = Count(CD_PRODUTO) 
                         From Estoque
                    Where CD_Filial =  @CD_Filial And
                          CD_Produto = @CD_PRODUTO

                    If @Quantidade = 0 
                       Begin
                          Update Movimento_Inventario Set QuantidadeAnteriorEstoque = 0, NOME_USUARIO = @NOME_USUARIO
                              Where CD_Inventario = @CD_INVENTARIO  And  
                                    CD_Produto = @CD_Produto 

                          Insert Into Estoque (CD_PRODUTO, CD_FILIAL, QT_ESTOQUE, NOME_USUARIO) 
                              Values (@CD_PRODUTO, @CD_Filial, @QT_PRODUTO, @NOME_USUARIO)                          
                       End 
                    Else
                       Begin

                          Update Movimento_Inventario Set QuantidadeAnteriorEstoque = (Select QT_Estoque From Estoque Where CD_Produto = @CD_Produto And CD_Filial = @CD_Filial),
                                                          Nome_Usuario = @NOME_USUARIO
                              Where CD_Inventario = @CD_INVENTARIO  And  
                                    CD_Produto = @CD_Produto 

                          Update Estoque Set QT_Estoque = @QT_PRODUTO, NOME_USUARIO = @NOME_USUARIO
                              Where CD_Filial =  @CD_Filial And
                                    CD_Produto = @CD_PRODUTO

                       End   

                    Fetch next from Produtos_Cursor 
                         Into @CD_PRODUTO, @QT_PRODUTO
                  End 

               CLOSE Produtos_Cursor
               DEALLOCATE Produtos_Cursor

               Update inventario set dt_fechamento = getdate(),nome_usuario = @nome_usuario where cd_inventario =  @CD_INVENTARIO

               Commit Transaction
         End 
