/****** Object:  Function [dbo].[InverteHora]    Committed by VersionSQL https://www.versionsql.com ******/

Create Function [dbo].[InverteHora](@hora Varchar(5))
RETURNS Int
AS
Begin
	declare @h int 
    declare @m int
    declare @res int
	Set @h = convert(int,substring(@hora,1,2))
	Set @m = convert(int,substring(@hora,4,2))
	Set @res = @h * 60 + @m
 	return @res
End 
