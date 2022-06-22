/****** Object:  Function [dbo].[FS_CalculoModulo10]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE Function [dbo].[FS_CalculoModulo10](@valor Varchar(43))
RETURNS varchar(10)
AS
Begin
	declare @i int = 1 
    declare @mult int = 2 
    Declare @soma int = 0 
    Declare @divisor int
    Declare @digito int 
    Declare @Calculo int 
    
    Set @i = LEN(@valor)
    While @i > 0 
    Begin
      Set @Calculo = SUBSTRING(@valor,@i,1)*@mult  
      if @Calculo>=10
        Set @Calculo = CONVERT(int,left(convert(varchar(2),@Calculo),1)) + CONVERT(int,right(convert(varchar(2),@Calculo),1))
        
      set @soma = @soma + @Calculo
      Set @i = @i - 1 
      Set @mult = @mult-1 
      if @mult=0
       Set @mult=2 
    End  
    
    --Set @divisor = CONVERT(int,Floor(@soma/10))*10
    Set @divisor = @soma%10
    Set @digito = 10 - @divisor 
    
    if @digito > 9 
       Set @digito = 0
    
 	return convert(varchar(10),@digito)

End
