/****** Object:  Function [dbo].[FS_DigitoVerificarCodigoBarras]    Committed by VersionSQL https://www.versionsql.com ******/

Create Function [dbo].[FS_DigitoVerificarCodigoBarras](@valor Varchar(43))
RETURNS varchar(1)
AS
Begin
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
    
    Set @divisor = CONVERT(int,Floor(@soma/11))
    Set @soma = @soma - (@divisor*11)
    Set @digito = 11 - @soma
    
    if @digito <= 1 or @digito > 9 
      Set @digito = 1 
    
 	return convert(varchar(1),@digito)

End
