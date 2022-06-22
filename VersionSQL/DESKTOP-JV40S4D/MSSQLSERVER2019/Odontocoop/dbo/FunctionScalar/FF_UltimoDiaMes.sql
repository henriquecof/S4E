/****** Object:  Function [dbo].[FF_UltimoDiaMes]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE FUNCTION [dbo].[FF_UltimoDiaMes](@mes int, @ano int)
returns varchar(2)
AS
BEGIN
	declare @data smalldatetime
	declare @ultimodia smalldatetime
	
	set @data = right('00' + convert(varchar,@mes),2) + '/01/' + convert(varchar,@ano)
	set @ultimodia = dateadd(d,-1,dateadd(m,1,@data))

	return convert(varchar(2),@ultimodia,103)
END
