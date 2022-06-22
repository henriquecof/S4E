/****** Object:  Procedure [dbo].[PS_CriaLotePagamentoVendedorCorte]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE Procedure [dbo].[PS_CriaLotePagamentoVendedorCorte](@Dia smallint)
As
Begin
    Declare @Funcionario int 

    If @dia = 0 
       Set @dia = day(getdate())

    DECLARE cursor_lote_pagamento CURSOR FOR 
    Select cd_funcionario 
    From   Funcionario
    Where  dia_corte   = @dia 

    OPEN cursor_lote_pagamento
      FETCH NEXT FROM cursor_lote_pagamento INTO @Funcionario

   WHILE (@@FETCH_STATUS <> -1)
   BEGIN
     
       Exec PS_CriaLotesPagamentoDentista @Funcionario

       FETCH NEXT FROM cursor_lote_pagamento INTO @Funcionario
   END
   Close cursor_lote_pagamento
   DEALLOCATE cursor_lote_pagamento

End
