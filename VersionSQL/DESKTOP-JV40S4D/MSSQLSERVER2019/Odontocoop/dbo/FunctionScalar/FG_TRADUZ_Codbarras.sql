/****** Object:  Function [dbo].[FG_TRADUZ_Codbarras]    Committed by VersionSQL https://www.versionsql.com ******/

Create Function [dbo].[FG_TRADUZ_Codbarras](@st_bit As varchar(44)) RETURNS varchar(2200)
as 
Begin
    
    Declare @st_prin As varchar(1000)
    Declare @n int 
    Declare @par varchar(5)
    
    Set @st_prin = '<'
    Set @n=1
    While @n < len(@st_bit)
    Begin
        Select @par = letra from barra where id = substring(@st_bit,@n,2)
        Select @st_prin = @st_prin + @par
        Set @n = @n + 2 
    End 
    Set @st_prin = @st_prin + '>'
    return @st_prin

End
