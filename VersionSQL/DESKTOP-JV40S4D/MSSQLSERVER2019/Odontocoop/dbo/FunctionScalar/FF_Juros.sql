/****** Object:  Function [dbo].[FF_Juros]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE function [dbo].[FF_Juros] (@venc date,@data date)
RETURNS bit
Begin

  Declare @qtde as bit = 0 
  Declare @data_ini date 
  Declare @data_fim date 
  set @data_ini = convert(varchar(10),@venc,101)
  set @data_fim = convert(varchar(10),@data,101)
  
  While @data_ini < @data_fim
  Begin
     if datepart(dw,@data_ini) not in (1,7) and (select count(0) from crmferiado where ferdata = @data_ini)=0 
     begin
        Set @qtde = 1 
        break 
     End 
     Set @data_ini = dateadd(day,1,@data_ini)
  End
  return @qtde 

End 
