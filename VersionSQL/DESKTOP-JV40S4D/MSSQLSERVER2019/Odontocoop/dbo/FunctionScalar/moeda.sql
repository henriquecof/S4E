/****** Object:  Function [dbo].[moeda]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE FUNCTION [dbo].[moeda] (@vl money) RETURNS varchar(30)
begin 

  if @vl is null
    return '0,00'

   return replace(convert(varchar(30),@vl),'.',',')

End 
