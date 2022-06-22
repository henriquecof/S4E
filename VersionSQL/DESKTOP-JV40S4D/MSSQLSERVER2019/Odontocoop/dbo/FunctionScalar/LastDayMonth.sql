/****** Object:  Function [dbo].[LastDayMonth]    Committed by VersionSQL https://www.versionsql.com ******/

Create FUNCTION [dbo].[LastDayMonth](@Data varchar(10))
 RETURNS int
AS
begin

  return  day(dateadd(day,-1,convert(varchar,month(dateadd(month,1,@Data))) + '/01/' + convert(varchar,year(dateadd(month,1,@Data)))))

End 
