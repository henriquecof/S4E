/****** Object:  Function [dbo].[F_ACENTO2]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE FUNCTION [dbo].[F_ACENTO2](@Texto varchar(8000))
returns varchar(8000)  
AS  
BEGIN
         Declare @SemAcento varchar(300)   

         Select @SemAcento = replace(@Texto,' ','')   

         Return (UPPER(@SemAcento))  
END
