/****** Object:  Function [dbo].[PS_CNPJ]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE Function [dbo].[PS_CNPJ]
  (
  @Cnpj Varchar(12)
  )
RETURNS varchar(2)
AS
BEGIN
    
    Declare @WL_DSSoma Int
    Declare @WL_DSResto Int
    Declare @WL_PrimeiroDigito SmallInt 
    Declare @WL_SegundoDigito SmallInt

    Set @cnpj = Right('000000000000' + @cnpj,12)       
       
    -- Verifica Primeiro Dígito
    Set @WL_DSSoma = (Convert(int,SubString(@Cnpj,12,1)) * 2) + (Convert(int,SubString(@Cnpj,11,1)) * 3) + (Convert(int,SubString(@Cnpj,10,1)) * 4) + (Convert(int,SubString(@Cnpj,9,1)) * 5) + (Convert(int,SubString(@Cnpj,8,1)) * 6) + (Convert(int,SubString(@Cnpj,7,1)) * 7) + (Convert(int,SubString(@Cnpj,6,1)) * 8) + (Convert(int,SubString(@Cnpj,5,1)) * 9) + (Convert(int,SubString(@Cnpj,4,1)) * 2) + (Convert(int,SubString(@Cnpj,3,1)) * 3) + (Convert(int,SubString(@Cnpj,2,1)) * 4) + (Convert(int,SubString(@Cnpj,1,1)) * 5)
    Set @WL_DSResto = @WL_DSSoma % 11
    -- Atribui valor para o primerio dígito
    If @WL_DSResto = 0 Or @WL_DSResto = 1 
        Set @WL_PrimeiroDigito = 0
    Else
        Set @WL_PrimeiroDigito = 11 - @WL_DSResto    

    -- Verifica Segundo Dígito      
    Set @WL_DSSoma = (@WL_PrimeiroDigito*2)+ (Convert(int,SubString(@Cnpj,12,1)) * 3) + (Convert(int,SubString(@Cnpj,11,1)) * 4) + (Convert(int,SubString(@Cnpj,10,1)) * 5) + (Convert(int,SubString(@Cnpj,9,1)) * 6) + (Convert(int,SubString(@Cnpj,8,1)) * 7) + (Convert(int,SubString(@Cnpj,7,1)) * 8) + (Convert(int,SubString(@Cnpj,6,1)) * 9) + (Convert(int,SubString(@Cnpj,5,1)) * 2) + (Convert(int,SubString(@Cnpj,4,1)) * 3) + (Convert(int,SubString(@Cnpj,3,1)) * 4) + (Convert(int,SubString(@Cnpj,2,1)) * 5) + (Convert(int,SubString(@Cnpj,1,1)) * 6)
    Set @WL_DSResto = @WL_DSSoma % 11
    -- Atribui valor para o segundo dígito
    If @WL_DSResto = 0 Or @WL_DSResto = 1 
        Set @WL_SegundoDigito = 0
    Else
        Set @WL_SegundoDigito = 11 - @WL_DSResto    

    --Retorna Valor do Dígito
    return Convert(varchar(1),@WL_PrimeiroDigito) + Convert(varchar(1),@WL_SegundoDigito)    

End 
