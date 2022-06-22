/****** Object:  Function [dbo].[FS_RetornaFone]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE Function [dbo].[FS_RetornaFone](@Associado int)
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
              Set @Fone = @Fone + ' Fone Residencial : (' + Substring(@nr_fax,1,3) + ') ' + Substring(@nr_fax,4,Len(@nr_fax))  + '<br>'
         Else 
              Set @Fone = @Fone + ' Fone Residencial : ' + @nr_fax + '<br>'
      End          

   If @nr_foneresidencial != '' 
      Begin
         If Len(@nr_foneresidencial) > 8            
              Set @Fone = @Fone + ' Fone Residencial : (' + Substring(@nr_foneresidencial,1,3) + ') ' + Substring(@nr_foneresidencial,4,Len(@nr_foneresidencial))  + '<br>'
         Else 
              Set @Fone = @Fone + ' Fone Residencial : ' + @nr_foneresidencial + '<br>'
      End          

   If @nr_celular != '' 
      Begin
         If Len(@nr_celular) > 8            
              Set @Fone = @Fone + ' Celular : (' + Substring(@nr_celular,1,3) + ') ' + Substring(@nr_celular,4,Len(@nr_celular))  + '<br>'
         Else 
              Set @Fone = @Fone + ' Celular : ' + @nr_celular + '<br>'
      End          

   If @nr_fonetrabalho != '' 
      Begin
         If Len(@nr_fonetrabalho) > 8            
              Set @Fone = @Fone + ' Fone Trabalho : (' + Substring(@nr_fonetrabalho,1,3) + ') ' + Substring(@nr_fonetrabalho,4,Len(@nr_fonetrabalho))  + '<br>'
         Else 
              Set @Fone = @Fone + ' Fone Trabalho : ' + @nr_fonetrabalho + '<br>'
      End  


   if @Fone != ''
      Set @Fone = Substring(@Fone,1,Len(@Fone)-4) 

   Return @Fone  
End
