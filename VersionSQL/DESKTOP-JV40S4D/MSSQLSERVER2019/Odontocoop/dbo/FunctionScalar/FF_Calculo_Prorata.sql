/****** Object:  Function [dbo].[FF_Calculo_Prorata]    Committed by VersionSQL https://www.versionsql.com ******/

create Function [dbo].[FF_Calculo_Prorata] (@dt_asscto date,@dt_iniciobertura date) 
RETURNS smallInt      
as
Begin
 
  Declare @mm_i as smallint = month(@dt_asscto)
  Declare @mm_f as smallint = month(@dt_iniciobertura)
  Declare @dia_i as smallint = day(@dt_asscto)
  Declare @dias as smallint = 0 
  
  While @mm_i <= @mm_f
  Begin 
     set @dias = @dias + case when @mm_i <> @mm_f then 30 else day(@dt_iniciobertura) end - @dia_i
     Set @dia_i = 0 
     Set @mm_i = @mm_i + 1 
  End 
 
  return @dias
  
End 
