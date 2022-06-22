/****** Object:  Function [dbo].[PS_CriptSenha]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE  FUNCTION [dbo].[PS_CriptSenha](@Psenha As varchar(14),@rad As varchar(14))
 
 RETURNS varchar(14)
 
AS
 
  Begin
 
  Declare @v_sqlerrm As varchar(14), 
          @SenhaCript As varchar(14), 
          @to_text As varchar(14), 
          @var1 As varchar(14), 
          @MIN_ASC as int, 
          @MAX_ASC as int, 
          @NUM_ASC as int, 
          @str_len As Int, 
          @i As Int, 
          @ch As Int, 
          @offset as int
 
   set @var1 = convert(varchar(14), abs(       convert   ( bigint, @rad   )    )     )
 
   set @MIN_ASC = 64
 
   set @MAX_ASC = 90
 
   set @NUM_ASC = @MAX_ASC - @MIN_ASC + 1
 
   set @offset = dbo.PS_NumericPassword(@var1)
 
   set @to_text = ''
 
   set @str_len = Len(@Psenha)
 
   set @i = 1 
   while  @i <= @str_len 
     begin
 
       set @ch = AscII(substring(@Psenha, @i, 1)) 
       If @ch >= @MIN_ASC And @ch <= @MAX_ASC  
         begin 
               set @ch = @ch - @MIN_ASC  
               set @offset = FLOOR((@NUM_ASC + 1) * cast(('0.' + @var1) as float) ) 
               set @ch = ((@ch + @offset) % @NUM_ASC) 
               set @ch = @ch + @MIN_ASC 
         End  
        set @to_text = @to_text + Char(@ch)             
        set @i = @i + 1 
 
  end
 
 RETURN (@to_text)
 
End 
