/****** Object:  Function [dbo].[UltimaDataMes]    Committed by VersionSQL https://www.versionsql.com ******/

Create FUNCTION [dbo].[UltimaDataMes](@Data datetime, @month_to_add smallint = 0)
 RETURNS datetime
AS
begin

	declare @ultimodia datetime
	
	set @data = dateadd(m, @month_to_add, right('00' + convert(varchar,month(@data)),2)  + '/01/'+ convert(varchar,year(@data))  )--right('00' + convert(varchar,@mes),2) + '/01/' + convert(varchar,@ano)
	set @ultimodia = dateadd(d,-1,dateadd(m,1,@data))

	return convert(datetime, convert(varchar(10),@ultimodia,102) + ' 23:59:59')

End
