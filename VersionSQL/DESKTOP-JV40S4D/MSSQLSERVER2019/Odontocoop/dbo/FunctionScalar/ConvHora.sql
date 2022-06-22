/****** Object:  Function [dbo].[ConvHora]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE Function [dbo].[ConvHora](@hora int) 
RETURNS Varchar(5)
AS
Begin

  Declare @h int
  Declare @m int
  Declare @res int
  Declare @Saida varchar(5)

  Set @h = round(@hora / 60,0)
  if @h <= 9  
     Set @Saida = '0' + convert(varchar,@h)
  else 
     Set @Saida = convert(varchar,@h)
 

  Set @m = (@hora % 60)
  if @m > 0 and @m <= 9 
      Set @Saida = @Saida + ':0' + convert(varchar,@m) 
  if @m = 0 
     Set @Saida = @Saida + ':00' 
  if @m > 9    
   Set @Saida = @Saida + ':' + convert(varchar,@m) 

  Return @Saida
End 
