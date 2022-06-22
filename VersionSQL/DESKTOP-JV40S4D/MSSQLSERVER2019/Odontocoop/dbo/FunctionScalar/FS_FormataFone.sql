/****** Object:  Function [dbo].[FS_FormataFone]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE Function [dbo].[FS_FormataFone](@Fone varchar(15))
 Returns varchar(20)
As 
Begin
   Declare @FoneAux Varchar(20)

   If Len(ltrim(rtrim(@Fone))) > 8 
      Set @FoneAux = '(' + substring(@Fone,1,2) + ') ' + substring(@Fone,3,15)
   Else
      Set @FoneAux = @Fone

   Return @FoneAux
End
