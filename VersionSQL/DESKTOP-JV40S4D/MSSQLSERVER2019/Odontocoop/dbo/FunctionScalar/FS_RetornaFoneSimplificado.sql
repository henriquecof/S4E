/****** Object:  Function [dbo].[FS_RetornaFoneSimplificado]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE Function [dbo].[FS_RetornaFoneSimplificado](@Associado int)
Returns Varchar(200)
As
Begin
   Declare @nr_foneresidencial varchar(15)
   Declare @nr_celular varchar(15)   
   Declare @nr_fonetrabalho varchar(15)
   Declare @Fone varchar(200)
   Declare @nr_fax varchar(15)

   Select @nr_foneresidencial = isnull(nr_foneresidencial,''),
          @nr_celular         = isnull(nr_celular,''),          
          @nr_fonetrabalho    = isnull(nr_fonetrabalho,''),
          @nr_fax             = isnull(nr_fax,'')
   From Associados 
   Where CD_Associado = @Associado

   Set @Fone = ''

   If @nr_fax != '' 
      Begin
         If Len(@nr_fax) > 8            
              Set @Fone = @Fone + '(' + Substring(@nr_fax,1,3) + ')' + Substring(@nr_fax,4,Len(@nr_fax))  + '[Fax] '
         Else 
              Set @Fone = @Fone + @nr_fax + '[Fax] '
      End          

   If @nr_foneresidencial != '' 
      Begin
         If Len(@nr_foneresidencial) > 8            
              Set @Fone = @Fone + '(' + Substring(@nr_foneresidencial,1,3) + ')' + Substring(@nr_foneresidencial,4,Len(@nr_foneresidencial)) + '[Res] '
         Else 
              Set @Fone = @Fone + @nr_foneresidencial + '[Res] '
      End          

   If @nr_celular != '' 
      Begin
         If Len(@nr_celular) > 8            
              Set @Fone = @Fone + '(' + Substring(@nr_celular,1,3) + ')' + Substring(@nr_celular,4,Len(@nr_celular))  + '[Cel] '
         Else 
              Set @Fone = @Fone + @nr_celular + '[Cel] '
      End          

   If @nr_fonetrabalho != '' 
      Begin
         If Len(@nr_fonetrabalho) > 8            
              Set @Fone = @Fone + '(' + Substring(@nr_fonetrabalho,1,3) + ')' + Substring(@nr_fonetrabalho,4,Len(@nr_fonetrabalho))  + '[Tra] '
         Else 
              Set @Fone = @Fone + @nr_fonetrabalho + '[Tra] '
      End  

   /*if @Fone != ''
      Set @Fone = Substring(@Fone,1,Len(@Fone)-4) */

   Return @Fone  
End
