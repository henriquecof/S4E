/****** Object:  Function [dbo].[FF_Parcela_Associado]    Committed by VersionSQL https://www.versionsql.com ******/

Create Function [dbo].[FF_Parcela_Associado] (@cd_associado int , @parc int, @venc date) returns Int 
as
Begin  
	Declare @parc_c int 
	Declare @qtde int = 0 

	DECLARE cursor_pro CURSOR FOR 
	  select top 1000 t10.cd_parcela
		from mensalidades t10
		where t10.dt_vencimento <= @venc And
			  t10.cd_tipo_recebimento  not in (1,2) And 
			  t10.cd_tipo_parcela in (1,2) And
			  t10.TP_ASSOCIADO_EMPRESA=1 and 
			  t10.CD_ASSOCIADO_empresa = @cd_associado 
	order by t10.dt_vencimento , t10.CD_PARCELA desc 
	   
	OPEN cursor_pro
	FETCH NEXT FROM cursor_pro INTO @parc_c

	WHILE (@@FETCH_STATUS <> -1)
	BEGIN

	   Set @qtde = @qtde + 1 
	   if @parc = @parc_c 
		  break 

	   FETCH NEXT FROM cursor_pro INTO @parc_c
	End 
	Close cursor_pro
	Deallocate cursor_pro   		  

	return @qtde
End 	
