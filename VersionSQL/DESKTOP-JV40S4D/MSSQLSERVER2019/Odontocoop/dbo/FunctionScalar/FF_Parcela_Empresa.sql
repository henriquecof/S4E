/****** Object:  Function [dbo].[FF_Parcela_Empresa]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE Function [dbo].[FF_Parcela_Empresa] (@cd_empresa int , @parc int, @venc date) returns Int -- , @parcela_buscada int
as
Begin  
	Declare @parc_c int 
	Declare @qtde int = 0 

	DECLARE cursor_pro CURSOR FOR 
	  select top 1000 t10.cd_parcela
		from mensalidades t10
		where t10.dt_vencimento <= @venc And
			  t10.cd_tipo_recebimento  not in (1,2) And 
			  t10.cd_tipo_parcela in (1)         And
			  t10.CD_ASSOCIADO_empresa = @cd_empresa and 
			  TP_ASSOCIADO_EMPRESA in (2,3)
	order by t10.dt_vencimento , t10.CD_PARCELA desc 
	   
	OPEN cursor_pro
	FETCH NEXT FROM cursor_pro INTO @parc_c

	WHILE (@@FETCH_STATUS <> -1)
	BEGIN

	   Set @qtde = @qtde + 1 
	   if @parc = @parc_c -- or (@parcela_buscada>0 and @qtde > @parcela_buscada)
		  break 

	   FETCH NEXT FROM cursor_pro INTO @parc_c
	End 
	Close cursor_pro
	Deallocate cursor_pro   		  

	return @qtde
End 	
