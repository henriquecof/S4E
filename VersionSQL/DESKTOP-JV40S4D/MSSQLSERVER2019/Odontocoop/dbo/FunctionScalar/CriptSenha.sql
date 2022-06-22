/****** Object:  Function [dbo].[CriptSenha]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE FUNCTION [dbo].[CriptSenha](@Psenha As varchar(50),@nota As varchar(14),@rad float)
 RETURNS int
AS
begin
declare @v_sqlerrm As varchar(50),
	@SenhaCript As varchar(50),
	@chave As varchar(50),
	@to_text As varchar(50),
	@var1 As varchar(50),
	@MIN_ASC as int,
        @MAX_ASC as int,
	@NUM_ASC as int,
	@offset As int,
	@str_len As Int,
	@i As Int,
	@ch As Int/*,
	@rad as float*/

set @MIN_ASC = 32
set @MAX_ASC = 126
set @NUM_ASC = @MAX_ASC - @MIN_ASC + 1

set @chave = substring(@nota,3,4)
/*set @rad =rand()*/
/*set @rad = (rand(cast(@chave as integer)))*1000*/
/*set @rad =1*/
set @to_text = ''
set @offset = dbo.NumericPassword(@chave)
set @str_len = Len(@Psenha)
set @i = 1
 while  @i <= @str_len
   begin
       set @ch = AscII(substring(@Psenha, @i, 1))
       If @ch >= @MIN_ASC And @ch <= @MAX_ASC 
         begin
 	   set @ch = @ch - @MIN_ASC 
	   set @offset = FLOOR((@NUM_ASC + 1) * @rad)
	   set @ch = ((@ch + @offset) % @NUM_ASC)
	   set @ch = @ch + @MIN_ASC
	   set @to_text = @to_text + Char(@ch)
	 End 
    set @i = @i + 1 
  end
 RETURN (@to_text)
End 
