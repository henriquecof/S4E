/****** Object:  Function [dbo].[FS_CalculoModulo11_Santander]    Committed by VersionSQL https://www.versionsql.com ******/

create Function [dbo].[FS_CalculoModulo11_Santander](@valor Varchar(30))
RETURNS varchar(1)
AS
Begin
    Declare @tamanho int
	declare @i int = 1 
    declare @mult int = 2
    Declare @soma int = 0 
    Declare @divisor int
    Declare @digito int 
    
    Set @i = LEN(@valor)
    While @i > 0 
    Begin
      set @soma = @soma + SUBSTRING(@valor,@i,1)*@mult 
      
      Set @i = @i - 1 
      
      Set @mult = @mult+1 
      if @mult=10
       Set @mult=2

    End  

    Set @divisor = @soma%11
    
    Set @digito = case when @divisor = 10 then 1
                       when @divisor <= 1 then 0
                       else 11 - @divisor
                  end      

 	return convert(varchar(1),@digito)
    
  --  Set @divisor = CONVERT(int,Floor(@soma/11))
  --  Set @soma = @soma - (@divisor*11)
  --  if @soma < 2 
  --    Set @digito = 0 
  --  else 
  --    Set @digito = 11 - @soma
    
 	--return convert(varchar(1),@digito)

End
