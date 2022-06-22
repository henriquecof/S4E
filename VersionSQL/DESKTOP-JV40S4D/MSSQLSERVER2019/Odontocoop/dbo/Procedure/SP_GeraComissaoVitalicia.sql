/****** Object:  Procedure [dbo].[SP_GeraComissaoVitalicia]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE Procedure [dbo].[SP_GeraComissaoVitalicia]
as
Begin 
	declare @cd_funcionario int 
	declare @cd_sequencial_dependente int 
	declare @valor money 
	declare @cd_parcela_comissao int 
	Declare @perc_pagamento float
	Declare @ult_parcela_gerada int 
	Declare @qtde_parcelas_abertas int 
	declare @cd_sequencial int 

	DECLARE cursor_cm_vit_f CURSOR FOR  
	 select distinct cd_funcionario from comissao_vendedor where fl_vitalicio=1 and dt_exclusao is null 
	OPEN cursor_cm_vit_f   
	FETCH NEXT FROM cursor_cm_vit_f INTO @cd_funcionario

	WHILE (@@FETCH_STATUS <> -1)  
	begin  -- Inicio Cursor

		DECLARE cursor_cm_vit CURSOR FOR  
		select cd_sequencial,cd_sequencial_dependente, valor, cd_parcela_comissao, perc_pagamento, 
			   isnull((select MAX(cd_parcela_comissao) 
						 from comissao_vendedor as c1 
						where c1.cd_funcionario=@cd_funcionario 
						  -- and isnull(c1.fl_vitalicio,0)=0 
						  and c1.cd_sequencial_origem = c.cd_sequencial
						  and c1.cd_sequencial_dependente=c.cd_sequencial_dependente 
						  and c1.dt_exclusao is null),cd_parcela_comissao-1) as ultgerada, -- Ultima Parcela gerada
			   (select COUNT(0) 
				  from comissao_vendedor as c2 
				 where c2.cd_funcionario=@cd_funcionario 
				  -- and isnull(c2.fl_vitalicio,0)=0 
				   and c2.cd_sequencial_origem = c.cd_sequencial
				   and c2.cd_sequencial_dependente=c.cd_sequencial_dependente 
				   and c2.cd_sequencial_mensalidade_planos is null 
				   and c2.dt_exclusao is null)  as qtgerada -- Qtde Parcela aberta
		  from comissao_vendedor as c
		 where cd_funcionario=@cd_funcionario and fl_vitalicio=1 and dt_exclusao is null and cd_sequencial_dependente is not null 
		 OPEN cursor_cm_vit  
		 FETCH NEXT FROM cursor_cm_vit INTO @cd_sequencial,@cd_sequencial_dependente,@valor,@cd_parcela_comissao,@perc_pagamento,@ult_parcela_gerada,@qtde_parcelas_abertas

		 WHILE (@@FETCH_STATUS <> -1)  
		 begin  -- Inicio Cursor
		    
			While @qtde_parcelas_abertas <= 30
			Begin

			   Set @ult_parcela_gerada = @ult_parcela_gerada + 1 
			   Set @qtde_parcelas_abertas = @qtde_parcelas_abertas + 1 
		       	       
			   insert comissao_vendedor (cd_sequencial_dependente,cd_parcela_comissao,cd_funcionario,valor,perc_pagamento,fl_vendedor_reteu,dt_inclusao,cd_sequencial_origem)
			   values (@cd_sequencial_dependente,@ult_parcela_gerada,@cd_funcionario,@valor,@perc_pagamento,0,GETDATE(),@cd_sequencial)
		       
			End 
			FETCH NEXT FROM cursor_cm_vit INTO @cd_sequencial,@cd_sequencial_dependente,@valor,@cd_parcela_comissao,@perc_pagamento,@ult_parcela_gerada,@qtde_parcelas_abertas
		 End 
		 Close cursor_cm_vit
		 Deallocate cursor_cm_vit

		FETCH NEXT FROM cursor_cm_vit_f INTO @cd_funcionario
	End
	Close cursor_cm_vit_f
	Deallocate cursor_cm_vit_f     
End 
