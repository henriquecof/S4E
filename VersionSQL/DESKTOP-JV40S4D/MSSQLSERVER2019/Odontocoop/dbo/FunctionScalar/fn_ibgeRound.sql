/****** Object:  Function [dbo].[fn_ibgeRound]    Committed by VersionSQL https://www.versionsql.com ******/

create function [dbo].[fn_ibgeRound](@valor float, @decimals int)
returns varchar(32)

begin
	declare @str varchar(32)
	declare @inteiro varchar(32)
	declare @decimal varchar(32)
	declare @pos int

    --Set @valor = @valor + 0.001
    
	if (@decimals <= 0)
		return round(@valor, 0)

	set @str = convert(varchar(32), @valor)

	set @pos = charindex('.', @str)

	if (@pos > 0)
		begin
			set @inteiro = substring(@str, 0, @pos)
			set @decimal = substring(@str, (@pos+1), len(@str))
		end
	else
		begin
			set @inteiro = @str
			set @decimal = '0'
		end

	if (len(@decimal) <= @decimals)
		return @valor

	-- se a casa decimal subsequente for diferente de 5, arredonda normalmente
	if ((substring(@decimal, (@decimals + 1), len(@decimal)) > '5') or (substring(@decimal, (@decimals + 1), len(@decimal)) < '5'))
		return convert(varchar(20), round(@valor, @decimals))

	return @inteiro + '.' + left(@decimal, @decimals)

	/*
	-- se a casa decimal subsequente for igual de 5...
	if (substring(@decimal, (@decimals + 1), len(@decimal)) = '5')
		begin
			if (convert(int, substring(@decimal, @decimals, 1)) % 2 = 0)
				return @inteiro + '.' + left(@decimal, @decimals)
			else
				return round(convert(float, @inteiro + '.' + left(@decimal, @decimals) + '9'), @decimals)
		end

	return convert(varchar, round(@valor, @decimals))
	*/
end
