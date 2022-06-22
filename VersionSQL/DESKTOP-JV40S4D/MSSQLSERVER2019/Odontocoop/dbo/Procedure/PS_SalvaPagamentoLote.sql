/****** Object:  Procedure [dbo].[PS_SalvaPagamentoLote]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE Procedure [dbo].[PS_SalvaPagamentoLote](@Lotes varchar(1000))
As
Begin
   Declare @Sequencial varchar(10)
   Declare @Forma varchar(1)
   Declare @Lote varchar(10)
     
   While @Lotes <> ''
     Begin

       Set @Sequencial = Substring(@Lotes,1,dbo.InStr('@',@Lotes)-1) 
       Set @Lotes      = Substring(@Lotes,dbo.InStr('@',@Lotes)+1,len(@Lotes)) 

       Set @Forma      = Substring(@Lotes,1,dbo.InStr('@',@Lotes)-1) 
       Set @Lotes      = Substring(@Lotes,dbo.InStr('@',@Lotes)+1,len(@Lotes)) 

       Set @Lote       = Substring(@Lotes,1,dbo.InStr(',',@Lotes)-1) 
       Set @Lotes      = Substring(@Lotes,dbo.InStr(',',@Lotes)+1,len(@Lotes)) 

       if @Lote = '0'       
          Begin
		    Update TB_LotePagamentoDentistaInterno set
					 numero_lote = null ,
					 tipo_pagamento = null
				   Where sequencial_lotepagamentodentistainterno = @Sequencial
          End
        else
          Begin
            Update TB_LotePagamentoDentistaInterno set
              numero_lote = @Lote ,
              tipo_pagamento = @Forma
            Where sequencial_lotepagamentodentistainterno = @Sequencial
          End
       

     End
         
End 
