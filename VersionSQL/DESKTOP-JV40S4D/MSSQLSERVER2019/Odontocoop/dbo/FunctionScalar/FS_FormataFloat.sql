/****** Object:  Function [dbo].[FS_FormataFloat]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE Function [dbo].[FS_FormataFloat] (@valor float, @qtde_decimais smallint) Returns Float
as
Begin
--  declare @ind int = left('100000000',@qtde_decimais+1)
--  return convert(float,convert(int,@valor*@ind))/@ind
   return round(@valor,@qtde_decimais)
   
End 
