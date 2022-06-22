/****** Object:  Procedure [dbo].[PS_ExcluirContratosLote]    Committed by VersionSQL https://www.versionsql.com ******/

/*
Objetivo : Exclui contratos que estão no lote
Marcio Nogueira Costa
Parametro Entrada : LotesAssociados - Contem o codigo do associado e sequencial
*/
CREATE procedure [dbo].[PS_ExcluirContratosLote](
                  @LoteAssociados Varchar(100)
)
As
Begin
   Declare @Codigo varchar(15)
   Declare @Sequencial varchar(15)   
   Declare @Lote varchar(15)  
   Declare @numero_contrato varchar(20)
   Declare @Sequencial_Dep int
  
   While @LoteAssociados  <> '' 
    Begin
      Set @Codigo         = Substring(@LoteAssociados,1,dbo.InStr(',',@LoteAssociados)-1)
      Set @LoteAssociados = Substring(@LoteAssociados,dbo.InStr(',',@LoteAssociados)+1,len(@LoteAssociados))
      Set @Sequencial     = Substring(@LoteAssociados,1,dbo.InStr(',',@LoteAssociados)-1)
      Set @LoteAssociados = Substring(@LoteAssociados,dbo.InStr(',',@LoteAssociados)+1,len(@LoteAssociados))
      Set @Lote           = Substring(@LoteAssociados,1,dbo.InStr(';',@LoteAssociados)-1)
      Set @LoteAssociados = Substring(@LoteAssociados,dbo.InStr(';',@LoteAssociados)+1,len(@LoteAssociados))      

     Select @Codigo, @Sequencial, @Lote

      -- 1º Alterar status do associado. Alterar somente quando o 
      --    sequencial é 1.
      if @Codigo > 0
        Begin          
          --buscar o numero do contrato do titular do plano
          Select  @numero_contrato = cd_contrato
            from  lote_contratos_contratos_vendedor
            where cd_sequencial_dep  = @Sequencial and
                  cd_sequencial_lote = @lote   

          --Excluir todos os dependentes desses codigo do determinado contrato
           DECLARE cursor_dep CURSOR FOR   
            Select   cd_sequencial 
               From  dependentes 
               Where cd_associado = @Codigo and
                     nr_contrato  = @numero_contrato
    
           OPEN cursor_dep 
           FETCH NEXT FROM cursor_dep INTO @Sequencial_Dep

            WHILE (@@FETCH_STATUS <> -1)
            BEGIN

				 Begin Transaction

				 Insert into Historico (CD_SITUACAO,CD_SEQUENCIAL_dep,DT_SITUACAO,cd_usuario)
				 values (2, @Sequencial_Dep, getdate(),null)

				 delete from lote_contratos_contratos_vendedor
				 where CD_SEQUENCIAL_DEP = @Sequencial_Dep
					   and cd_sequencial_lote = @lote

				 Commit transaction

                 FETCH NEXT FROM cursor_dep INTO @Sequencial_Dep
			    
            END
            Close cursor_dep
            DEALLOCATE cursor_dep
         End 
  
      if @Codigo = 0
         Begin 

            	 Begin Transaction

				 Insert into Historico (CD_SITUACAO,CD_SEQUENCIAL_dep,DT_SITUACAO,cd_usuario)
				 values (2, @Sequencial, getdate(),null)

				 delete from lote_contratos_contratos_vendedor
				 where CD_SEQUENCIAL_DEP = @Sequencial
					   and cd_sequencial_lote = @lote

				 Commit transaction
         End
     End
END
