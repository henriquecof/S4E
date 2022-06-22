/****** Object:  Function [dbo].[ff_mes]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE FUNCTION [dbo].[ff_mes]	(@data datetime)
RETURNS nvarchar(10)
BEGIN 

	declare  @ret nvarchar(10), @mes int

	set @mes = month(@data)
	select @ret = 
	case @mes
	when 1 then 'Janeiro'
	when 2 then 'Fevereiro'
	when 3 then 'Março'
	when 4 then 'Abril'
	when 5 then 'Maio'
	when 6 then 'Junho'
	when 7 then 'Julho'
	when 8 then 'Agosto'
	when 9 then 'Setembro'
	when 10 then 'Outubro'
	when 11 then 'Novembro'
	when 12 then 'Dezembro'
	end

	return @ret
END
