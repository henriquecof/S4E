/****** Object:  Function [dbo].[FF_TiraAcento]    Committed by VersionSQL https://www.versionsql.com ******/

Create FUNCTION [dbo].[FF_TiraAcento](@Texto varchar(8000))
returns varchar(8000)  
AS  
BEGIN
   Set @Texto = @Texto collate sql_latin1_general_cp1251_cs_as
   Return @Texto
END
