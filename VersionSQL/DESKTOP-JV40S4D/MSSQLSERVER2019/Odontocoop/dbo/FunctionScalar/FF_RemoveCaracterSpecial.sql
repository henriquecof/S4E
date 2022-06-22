/****** Object:  Function [dbo].[FF_RemoveCaracterSpecial]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE Function [dbo].[FF_RemoveCaracterSpecial](@Texto varchar(8000)) returns varchar(8000)  
AS  
BEGIN

   Declare @i integer , @sql varchar(100)
   Select @i = 1 , @sql = '<>;][{}:\|_/-ª?!'
   Set @Texto = @Texto collate sql_latin1_general_cp1251_cs_as

   While @i <= Len(@sql)
   Begin
      Set @texto = replace(@texto,substring(@sql,@i,1),'')
      Set @i = @i+1
   End   
   Return @Texto

END
