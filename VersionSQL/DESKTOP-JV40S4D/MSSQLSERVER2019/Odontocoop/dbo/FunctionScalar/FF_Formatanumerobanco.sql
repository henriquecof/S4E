/****** Object:  Function [dbo].[FF_Formatanumerobanco]    Committed by VersionSQL https://www.versionsql.com ******/

create Function [dbo].[FF_Formatanumerobanco] (@valor varchar(100))
Returns Varchar(100)
as 
Begin 
	--Possui virgula
	Declare @posv int = patindex('%.%',@valor)

	Declare @casas_dec int = 0 
	if @posv>0 
	begin
	  Set @casas_dec = LEN(@valor)-@posv
	End   

	if @casas_dec =0 
	   Set @valor = @valor + '.'
	  
	Set @valor = replace(@valor + LEFT('00',2 - @casas_dec),'.','')

	return @valor   

End 
