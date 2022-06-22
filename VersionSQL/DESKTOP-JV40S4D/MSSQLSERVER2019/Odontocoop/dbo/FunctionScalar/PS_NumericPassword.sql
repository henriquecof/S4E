/****** Object:  Function [dbo].[PS_NumericPassword]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE FUNCTION [dbo].[PS_NumericPassword] (@password  varchar(14))
 RETURNS int
AS
begin

   declare @value As int,
           @ch As float,
           @ps1 as int,
           @ps2 as int,
           @shift1 As float,
           @shift2 As float,
           @i As Int,
           @j as int,
           @str_len As Int

           select @shift1 =0, @shift2 =0, @value = 0 , @str_len = Len(@password), @i = 1, @ps1 = 0, @ps2 = 0

            WHILE @i<= @str_len
              Begin

                 set @ch = Ascii(substring(@password, @i, 1))
                 select @ps1 = (power(2,@shift1)) * @ch
                 select @ps2 = (power(2,@shift2)) * @ch
                 set @value = @value  ^ @ps1
                 set @value = @value ^ @ps2

                 /* modulo */  
                 select @shift1 = (@shift1 + 7)  - (cast((@shift1 + 7)/19 as bigint) * 19)
                 select @shift2 = (@shift2 + 13) - (cast((@shift2 + 13)/23 as bigint) * 23)

                 set @i = @i +1
               end 

             return( @value)

End
