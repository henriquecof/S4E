/****** Object:  Function [dbo].[FF_TextoPadraoANS]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION [dbo].[FF_TextoPadraoANS](@Texto varchar(8000)) returns varchar(8000)  
AS  
BEGIN

   Declare @i integer , @sql varchar(100)
   Select @i = 1 , @sql = '.,<>;][{}:\|_/-?!%$@&*()'
   set @sql = '@“”*/{}$^[]\&!=?+<>()%.;#~,'
   
   Set @Texto = @Texto collate sql_latin1_general_cp1251_cs_as

   While @i <= Len(@sql)
   Begin
      Set @texto = replace(@texto,substring(@sql,@i,1),'')
      Set @i = @i+1
   End   
   Return @Texto

END
