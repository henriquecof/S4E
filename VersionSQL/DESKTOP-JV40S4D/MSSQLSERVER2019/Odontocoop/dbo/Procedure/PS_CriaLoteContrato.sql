/****** Object:  Procedure [dbo].[PS_CriaLoteContrato]    Committed by VersionSQL https://www.versionsql.com ******/

/*
Marcio Nogueira Costa
Objetivo : criar novo lote de contratos para receber novas vendas.
feito em 10/07/2008 
Parametros Entrada : Filial - Filial que usuario está logado. 
                     usuario - usuario que está logado no sistema.
*/
CREATE Procedure [dbo].[PS_CriaLoteContrato](
            @Equipe Int,
            @usuario varchar(8)
)
As
Begin
   Declare @NovoLote Int

   Begin Transaction
   
   Insert into lote_contratos
   (cd_sequencial,dt_cadastro,cd_usuario_cadastro,cd_equipe)   
   Select isnull(max(cd_sequencial),0)+1,getdate(), @usuario, @Equipe
   From lote_contratos 

   Select @NovoLote = max(cd_sequencial) 
         from lote_contratos
    
   Commit Transaction

   Select @NovoLote   

End
