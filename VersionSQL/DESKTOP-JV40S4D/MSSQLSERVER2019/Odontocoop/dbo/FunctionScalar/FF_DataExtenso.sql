/****** Object:  Function [dbo].[FF_DataExtenso]    Committed by VersionSQL https://www.versionsql.com ******/

create FUNCTION [dbo].[FF_DataExtenso] (@dt datetime)
returns varchar(50)
begin

return right('00' + convert(varchar(2), day(@dt)),2) +  ' de ' + 
 CASE MONTH( @dt)
 WHEN 1 THEN 'Janeiro' WHEN 2 THEN 'Fevereiro' WHEN 3 THEN 'Março' WHEN 4 THEN 'Abril' WHEN 5 THEN 'Maio' WHEN 6 THEN 'Junho' WHEN 7 THEN 'Julho' WHEN 8 THEN 'Agosto' WHEN 9 THEN 'Setembro'
 WHEN 10 THEN 'Outubro' WHEN 11 THEN 'Novembro' WHEN 12 THEN 'Dezembro' END 
  + ' de ' + right('0000' + convert(varchar(4), year(@dt)),4)
	
end
