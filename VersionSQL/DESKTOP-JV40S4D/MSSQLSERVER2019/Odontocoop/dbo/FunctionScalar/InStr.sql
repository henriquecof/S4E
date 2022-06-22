/****** Object:  Function [dbo].[InStr]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE Function [dbo].[InStr] 
 (@Valor1 Varchar(1),
  @Valor2 Varchar(100))
RETURNS int
As
  Begin
    Declare @I Int
    Declare @ValorAux Varchar(100)

    Set @ValorAux =  @Valor2
   
    Select @I = 1
    While @I <= Len(@ValorAux)
      Begin
        If SubString(@ValorAux,@I,1) = @Valor1
           Return(@I)        
        Select @I = @I + 1
      End   
    Return(0)  
  End 
