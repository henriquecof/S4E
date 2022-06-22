/****** Object:  Procedure [dbo].[PS_PrecoAssociadoEmpresa]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE Procedure [dbo].[PS_PrecoAssociadoEmpresa]
   (@Codigo_Empresa Int,
    @Codigo_Associado Int,
    @Quantidade_Dependentes Int)
As
Begin
   
   Declare @WL_QuantidadeDependentes Int
   Declare @WL_Valor Money 
   Declare @WL_Pessoas SmallInt   
   Declare @DS_Mensagem Varchar(100)
   Declare @WL_PrecoAssociado Money    
   Declare @WL_PrecoAssociadoUnitario Money
   Declare @I Int  

   -- Saber quantos associados já têm cadastrado com esse associado, 
   -- para saber o valor, devem esta ativos.
   If @Codigo_Associado > 0 
     Begin
       Select @WL_QuantidadeDependentes = Count(*) + 1 
         From Dependentes 
         Where cd_associado = @Codigo_Associado And
               cd_situacao = 1 
     End 
   Else   
     Begin
        Set @WL_QuantidadeDependentes = @Quantidade_Dependentes   
     End

   Set @WL_PrecoAssociado = 0   

   -- 1º CASO.
   -- Quando a quantidade de novos associados for igual a 1 retornar preço.
   If @WL_QuantidadeDependentes = 1 
     Begin
        select @WL_PrecoAssociado = valor
           from preco_empresa
           where cd_empresa = @Codigo_Empresa And 
                 qtd_pessoas = 1            
        If @WL_PrecoAssociado =  0 
          Begin                          
            Select @DS_Mensagem = 'A empresa do associado não está com os preços cadastrados. Por favor entrar em contato com a Administração da ABS.'
            RAISERROR (@DS_Mensagem, 16, 1)            
            return 0
          End 
     End
   Else
      Begin 
        -- 2º CASO.
        -- Se a quantidade for maior que um , saber valor do pagamento de acordo com quantidade de dependentes desse associado.
        -- e o cadastro de preço das empresas   
        Set @WL_Valor = 0
        -- Buscar o preço e a quantidade maxima de associados 
        -- para a quantidade de pessoas selecionada .    
        Select @WL_Valor = valor,
               @WL_Pessoas = qtd_pessoas
           From preco_empresa
           Where cd_empresa = @Codigo_Empresa And         
                 qtd_pessoas = @WL_QuantidadeDependentes
                 order by qtd_pessoas

        If @WL_Valor =  0 
		   Begin      
              -- buscar quantidade maxima    
              Select @WL_Valor = valor,
                     @WL_Pessoas = qtd_pessoas
                From preco_empresa
                Where cd_empresa = @Codigo_Empresa And         
                      qtd_pessoas <> 1
                      order by qtd_pessoas
              If @WL_Valor =  0 
		        Begin                      
		          --Select @DS_Mensagem = 'A empresa do associado não está com os preços cadastrados. Por favor entrar em contato com a Administração da ABS.'
		          --RAISERROR (@DS_Mensagem, 16, 1)            
                  --return 0
                   -- Vou buscar o preço unitário. 
                  Select @WL_Valor = valor,
                       @WL_Pessoas = 1
                  from preco_empresa
                  where cd_empresa = @Codigo_Empresa And 
                        qtd_pessoas = 1         
                  If @WL_Valor =  0 
                    Begin                          
                      Select @DS_Mensagem = 'A empresa do associado não está com os preços cadastrados. Por favor entrar em contato com a Administração da ABS.'
                      RAISERROR (@DS_Mensagem, 16, 1)            
                      return 0
                    End 
              End 
		    End 
          
         Set @WL_PrecoAssociado = @WL_Valor

--         select @WL_QuantidadeDependentes , @WL_Pessoas           

         If @WL_QuantidadeDependentes > @WL_Pessoas          
            Begin 
			   -- 3º CASO
			   -- Fazer composição de preços.
	           
			   -- Buscar preço unitario do associado.   
			   Select @WL_PrecoAssociadoUnitario = valor
				 from preco_empresa
				 where cd_empresa = @Codigo_Empresa And 
					 qtd_pessoas = 1            
			   If @WL_PrecoAssociadoUnitario =  0 
				 Begin                          
				   Select @DS_Mensagem = 'A empresa do associado não está com os preços cadastrados. Por favor entrar em contato com a Administração da ABS.'
				   RAISERROR (@DS_Mensagem, 16, 1)            
                   return 0
				  End 

				--Loop para pegar restante do valor.
				Set @I = @WL_Pessoas + 1
				While  @I <= @WL_QuantidadeDependentes
					Begin
					  Set @WL_PrecoAssociado = @WL_PrecoAssociado + @WL_PrecoAssociadoUnitario
					  Set @I = @I + 1
					End
            End 
End

   If @WL_PrecoAssociado is Null 
	 Begin                          
	   Select @DS_Mensagem = 'A empresa do associado não está com os preços cadastrados. Por favor entrar em contato com a Administração da ABS.'
	   RAISERROR (@DS_Mensagem, 16, 1)            
       return 0
	 End 
   Else 
      Select Convert(Varchar,@WL_PrecoAssociado)           
End
