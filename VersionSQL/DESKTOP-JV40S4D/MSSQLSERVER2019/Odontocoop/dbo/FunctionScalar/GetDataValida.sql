/****** Object:  Function [dbo].[GetDataValida]    Committed by VersionSQL https://www.versionsql.com ******/

create function [dbo].[GetDataValida](@dia integer, @mes integer, @ano integer, @addSeNaoExistir integer )
Returns datetime
As
Begin

	declare @dtstr varchar(10) = CAST(@ano as varchar(4)) + '-' +  CAST(@mes as varchar(2))+  '-' +  CAST(@dia as varchar(2))
	declare @primeiraDataMes varchar(10) = CAST(@ano as varchar(4)) + '-' +  CAST(@mes as varchar(2))+  '-' +  '01'
	declare @ultimaDataMes  datetime = dateadd(day, -1, dateadd(month, 1, dateadd(day, 1 - day(@primeiraDataMes), @primeiraDataMes)))
	declare @ultimoDiaMes integer = DAY(@ultimaDataMes)
	return  case when @dia > @ultimoDiaMes Then DATEADD(day, @addSeNaoExistir, @ultimaDataMes) Else @dtstr End 

End 
