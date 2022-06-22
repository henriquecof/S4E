/****** Object:  Function [dbo].[NumericPassword]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE FUNCTION [dbo].[NumericPassword] (@password  varchar(50))
 RETURNS int
AS
begin
declare @value As INT,
	@ch As INT,
	@shift1 As INT,
	@shift2 As INT,
	@i As Int,
	@str_len As Int

SET @str_len = Len(@password)
SET @i = 1
WHILE @i<= @str_len
 begin
   set @ch = Ascii(substring(@password, @i, 1))
   set @value = @value  ^ (power(@ch * 2,@shift1))
   set @value = @value ^ (power(@ch * 2 , @shift2))
   set @shift1 = (@shift1 + 7) % 19
   set @shift2 = (@shift2 + 13) % 23
   set @i = @i +1
end 
return( @value)
End
