/****** Object:  Procedure [dbo].[PS_PrecoAssociadoEmpresa2]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE Procedure [dbo].[PS_PrecoAssociadoEmpresa2]
   (@Codigo_Empresa Int,
    @Associado Int,
    @Quantidade_Dependentes Int)
As
Begin
   
   Declare @WL_ValorAssociado  Money
   Declare @WL_ValorDependente Money   
   Declare @WL_ValorGeral Money   
   Declare @I Int
   Declare @DS_Mensagem varchar(300)


   If (Select count(cd_empresa) 
        From  TB_Empresa_LiberarVenda 
        Where cd_empresa = @Codigo_Empresa
              And tipo = 1) >= 1
    Begin 
        Select 0
        Return
    End

   Set @WL_ValorGeral = 0

   -- Saber se valores das empresas estão cadastrados.
   -- 1º) Valor para associado principal.
    Set @WL_ValorAssociado = -1
    Select @WL_ValorAssociado = isnull(valor,0)
     From preco_empresa
     Where qtd_pessoas = 1 And
           CD_Empresa = @Codigo_Empresa   

   If @WL_ValorAssociado = -1
      Begin                          
        Select @DS_Mensagem = 'A empresa não está com o preço do associado principal cadastrado. Por favor entrar em contato com a Administração da ABS.'
        RAISERROR (@DS_Mensagem, 16, 1)            
        return 0
      End    

    -- 2º) Valor para associado principal.
    Set @WL_ValorDependente = -1
    Select @WL_ValorDependente = isnull(valor,0)
         From preco_empresa
        Where qtd_pessoas = 2 And
              CD_Empresa = @Codigo_Empresa   

   If @WL_ValorDependente = -1
      Begin                          
        Select @DS_Mensagem = 'A empresa não está com o preço do dependente do associado cadastrado. Por favor entrar em contato com a Administração da ABS.'
        RAISERROR (@DS_Mensagem, 16, 1)            
        return 0
      End    

   -- 3º) Calculo do valor.
   -- Associado.
   If @Associado > 0 
      Set @WL_ValorGeral = @WL_ValorGeral + @WL_ValorAssociado

   -- Dependentes.
   Set @WL_ValorGeral = @WL_ValorGeral +  (@WL_ValorDependente * @Quantidade_Dependentes) 
     
   Select Convert(Varchar,@WL_ValorGeral)           

End
