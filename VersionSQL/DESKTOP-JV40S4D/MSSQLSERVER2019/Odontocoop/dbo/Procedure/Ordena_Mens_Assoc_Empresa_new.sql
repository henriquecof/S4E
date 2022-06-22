/****** Object:  Procedure [dbo].[Ordena_Mens_Assoc_Empresa_new]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE procedure [dbo].[Ordena_Mens_Assoc_Empresa_new]	
	@wl_ep integer
as
begin

	declare @wl_assoc money

	DECLARE cursor_oo CURSOR FOR
		select cd_associado from associados where cd_empresa = @wl_ep
	OPEN cursor_oo
	FETCH NEXT FROM cursor_oo INTO @wl_assoc
	WHILE (@@FETCH_STATUS <> -1)
	begin
		exec dbo.SP_Ordena_Parcelas_new	@wl_assoc, 1
		FETCH NEXT FROM cursor_oo INTO @wl_assoc
	end
	DEALLOCATE cursor_oo

end
