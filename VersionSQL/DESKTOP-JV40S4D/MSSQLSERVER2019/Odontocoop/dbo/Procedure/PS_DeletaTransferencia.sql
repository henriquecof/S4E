/****** Object:  Procedure [dbo].[PS_DeletaTransferencia]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[PS_DeletaTransferencia](@CD_TRANSFERENCIA AS INT)
  As
       Begin

              Declare @cd_filial_Destino Int  
              Declare @cd_filial_Origem Int  
              Declare @cd_Produto Int  
              Declare @qtd Int  

              Begin Transaction
          
              /* Dados da transferencia */
              Select  @cd_filial_Destino  = cd_filial_Destino,
                      @cd_filial_origem  = cd_filial_origem,
                      @cd_Produto  = cd_Produto,
                      @qtd  = qtd_transferencia 
                From  transferencia_estoque 
                Where cd_transferencia = @CD_TRANSFERENCIA              

              /* Diminuir estoque do destino*/
              Update Estoque set qt_estoque = qt_estoque - @qtd
                Where cd_produto = @CD_PRODUTO And
                      cd_filial  = @cd_filial_Destino

              /* Diminuir estoque da origem */
              Update Estoque set qt_estoque = qt_estoque + @qtd
                Where cd_produto = @CD_PRODUTO And
                      cd_filial  = @cd_filial_Origem

              /* Deletar a transferencia */
               Delete From transferencia_estoque  
                  Where cd_transferencia = @CD_TRANSFERENCIA                          

               Commit Transaction
         End 
