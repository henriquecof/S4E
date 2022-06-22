/****** Object:  Function [dbo].[F_ACENTO]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE FUNCTION [dbo].[F_ACENTO](@Texto varchar(8000))
returns varchar(8000)  
AS  
BEGIN
         Declare @SemAcento varchar(300)   

         Select @SemAcento = replace(@Texto,'á','a')   

         Select @SemAcento = replace(@SemAcento,'à','a')   

         Select @SemAcento = replace(@SemAcento,'ã','a')   

         Select @SemAcento = replace(@SemAcento,'â','a')   

         Select @SemAcento = replace(@SemAcento,'ä','a')   

         Select @SemAcento = replace(@SemAcento,'é','e')   

         Select @SemAcento = replace(@SemAcento,'è','e')   

         Select @SemAcento = replace(@SemAcento,'ê','e')   

         Select @SemAcento = replace(@SemAcento,'í','i')   

         Select @SemAcento = replace(@SemAcento,'ì','i')   

         Select @SemAcento = replace(@SemAcento,'î','i')   

         Select @SemAcento = replace(@SemAcento,'ó','o')   

         Select @SemAcento = replace(@SemAcento,'ò','o')   

         Select @SemAcento = replace(@SemAcento,'ô','o')   

         Select @SemAcento = replace(@SemAcento,'õ','o')   

         Select @SemAcento = replace(@SemAcento,'ú','u')   

         Select @SemAcento = replace(@SemAcento,'ù','u')   

         Select @SemAcento = replace(@SemAcento,'û','u')   

         Select @SemAcento = replace(@SemAcento,'ü','u')   

         Select @SemAcento = replace(@SemAcento,'ç','c')     

         Select @SemAcento = replace(@SemAcento,'ñ','n')     

         Select @SemAcento = replace(@SemAcento,'-','')     

         Select @SemAcento = replace(@SemAcento,'.','')   

         Select @SemAcento = replace(@SemAcento,'''','')     

         Return (UPPER(@SemAcento))  
END
