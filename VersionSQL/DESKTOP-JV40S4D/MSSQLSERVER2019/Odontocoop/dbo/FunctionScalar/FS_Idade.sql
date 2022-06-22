/****** Object:  Function [dbo].[FS_Idade]    Committed by VersionSQL https://www.versionsql.com ******/

Create Function [dbo].[FS_Idade] (@data_nascimento date, @data_referencia date)
Returns Int
as
Begin
   if @data_referencia is null
      Set @data_referencia = GETDATE()
  
   if @data_nascimento is null
      Set @data_nascimento = GETDATE()
     
   return DATEDIFF(year,@data_nascimento,@data_referencia) -
     case when CONVERT(varchar(5),@data_nascimento,101)>CONVERT(varchar(5),@data_referencia,101) then 1 else 0 end  
 
End
