/****** Object:  Function [dbo].[ff_semana]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE FUNCTION [dbo].[ff_semana]	(@data datetime)
RETURNS nvarchar(13)
BEGIN 

	declare  @ret nvarchar(13), @mes int

	set @mes = datepart(dw, @data)
	select @ret = 
	case @mes
	when 1 then 'Domingo'
	when 2 then 'Segunda-feira'
	when 3 then 'Terça-feira'
	when 4 then 'Quarta-feira'
	when 5 then 'Quinta-feira'
	when 6 then 'Sexta-feira'
	when 7 then 'Sábado'
	end

	return @ret
END
