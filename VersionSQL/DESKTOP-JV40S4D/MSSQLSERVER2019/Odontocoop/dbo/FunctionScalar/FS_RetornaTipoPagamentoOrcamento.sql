/****** Object:  Function [dbo].[FS_RetornaTipoPagamentoOrcamento]    Committed by VersionSQL https://www.versionsql.com ******/

create Function [dbo].[FS_RetornaTipoPagamentoOrcamento](@codigo int)
Returns Varchar(1000)
As
Begin

	Declare @retorno varchar(1000)
	Declare @tipoPagamento varchar(1000)
  
		
	if (@codigo >0)
		begin
			declare cursor_tipo_pagamento CURSOR FOR
				
				select distinct isnull(t3.nm_tipo_pagamento,'') as tipo_pagamento
				from orcamento_mensalidades t1
				inner join mensalidades t2 on t1.cd_parcela = t2.cd_parcela
				inner join tipo_pagamento t3 on t1.cd_tipo_pagamento = t3.cd_tipo_pagamento
				where t1.cd_orcamento = @codigo
				ORDER BY 1
				
			open cursor_tipo_pagamento
		
			while (@@fetch_status <> -1)
				begin
					if len(@retorno) > 0
						set @retorno = @retorno + ', ' + @tipoPagamento
					else
						Set @retorno = @tipoPagamento
		        
				fetch next from cursor_tipo_pagamento into @tipoPagamento
				End
		end 
		Close cursor_tipo_pagamento
		Deallocate cursor_tipo_pagamento
   
	Return @retorno
End
