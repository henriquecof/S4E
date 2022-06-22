/****** Object:  Procedure [dbo].[PS_Criptografia2]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE procedure [dbo].[PS_Criptografia2]
    (
     @Numero Varchar(14),
     @Numero_Saida varchar(14) OUTPUT 
     )    
As  
Begin
            Declare @WL_DSLINHA varchar(14)
            Declare @WL_NRCRIPTOGRAFIA Int
            Declare @WL_DSAux varchar(14)
            Declare @I Int
            Declare @J Int
            Declare @WL_Sair SmallInt            
         
            Set @I = 1
            Set @WL_DSLINHA = ''
            While @I <= 14 
               Begin
                 if (@I % 2) = 0
                    Set @WL_DSLINHA = @WL_DSLINHA + char(convert(int,substring(convert(varchar(50),getdate(),109),len(convert(varchar(50),getdate(),109))-3,2))+ @I)
                 else
                    Set @WL_DSLINHA = @WL_DSLINHA + substring(@Numero,@I,1)

                 Set @I = @I + 1
               End 
                        
            Set @WL_DSAux = ''
            Set @I = 1
            While @I <= Len(@Numero)
              Begin                 
                
                Set @WL_NRCRIPTOGRAFIA = Ascii(substring(@Numero, @I, 1)) + Ascii(substring(@WL_DSLINHA, @I, 1))                

                /*If (Ascii(substring(@Numero, @I, 1)) % 2) = 0 
                  Begin                    
                
                    Set   @WL_Sair = 1
                    While @WL_Sair = 1
                       Begin                          

                         If @WL_NRCRIPTOGRAFIA < 65                            
                            Set @WL_NRCRIPTOGRAFIA = @WL_NRCRIPTOGRAFIA + convert(int,substring(convert(varchar(50),getdate(),109),len(convert(varchar(50),getdate(),109))-3,2))  + Ascii(substring(@WL_DSLINHA, @I, 1))                
                        
                         If @WL_NRCRIPTOGRAFIA > 90                             
                            Set @WL_NRCRIPTOGRAFIA = @WL_NRCRIPTOGRAFIA - convert(int,substring(convert(varchar(50),getdate(),109),len(convert(varchar(50),getdate(),109))-3,2)) - Ascii(substring(@WL_DSLINHA, @I, 1))                
                        
                         If (@WL_NRCRIPTOGRAFIA <= 90 And @WL_NRCRIPTOGRAFIA >= 65) 
                            Set @WL_Sair = 0
                         
                       End                        
                  End
  
                Else*/

                  Begin 
                    
                    Set   @WL_Sair = 1                   
                    While @WL_Sair = 1
                      Begin                         

                        If @WL_NRCRIPTOGRAFIA < 49                                                       
                            Set @WL_NRCRIPTOGRAFIA = @WL_NRCRIPTOGRAFIA + convert(int,substring(convert(varchar(50),getdate(),109),len(convert(varchar(50),getdate(),109))-3,2))  + Ascii(substring(@WL_DSLINHA, @I, 1))                
                        
                        If @WL_NRCRIPTOGRAFIA > 57                            
                             Set @WL_NRCRIPTOGRAFIA = @WL_NRCRIPTOGRAFIA - convert(int,substring(convert(varchar(50),getdate(),109),len(convert(varchar(50),getdate(),109))-3,2)) - Ascii(substring(@WL_DSLINHA, @I, 1))                
                        
                        If (@WL_NRCRIPTOGRAFIA >= 49 And @WL_NRCRIPTOGRAFIA <= 57) 
                            Set @WL_Sair = 0
                       End                                               
                  End
     
                
                Set @WL_DSAux = @WL_DSAux + Char(@WL_NRCRIPTOGRAFIA)
                Set @I = @I + 1

           End
 
    Set @Numero_Saida = @WL_DSAux    
       
End
