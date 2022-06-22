/****** Object:  Procedure [dbo].[PS_Gerar_Cartao]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE Procedure [dbo].[PS_Gerar_Cartao]
    (
     @CD_Empresa   Int,
     @Valor_Cartao SmallInt,
     @Devolve_Serie SmallInt
    )
As
Begin
   -------------------------------------------------
   -- Declaração de variaveis
   -------------------------------------------------
   Declare @Cartao Varchar(14)   
   Declare @Sequencial_Cartao Int    
   Declare @Serie varchar(14)
   Declare @Digito_Verificador varchar(2)      
   Declare @Status SmallInt

   Begin Transaction

   -------------------------------------------------
   -- 1º Passo : Saber se a empresa está cadastrada
   -------------------------------------------------
   If (Select Count(CD_Empresa)
         From  Empresa 
         Where CD_Empresa = @CD_Empresa) = 0 
      Begin
         Rollback Transaction
         RAISERROR ('Empresa não cadastrada.', 16, 1)
         Return
       End   

   ----------------------------------------------------------------------
   -- 2º Passo : Saber se valor pedido está dentro dos parâmetros aceitos
   ----------------------------------------------------------------------
   If @Valor_Cartao Not In (1,2,3)
       Begin
         Rollback Transaction
         RAISERROR ('Valor só pode assumir seguintes valores 1 - R$20,00, 2 - R$40,00, 3 - R$60,00.', 16, 1)
         Return
       End   
   

        -------------------------------------------------------------------------
        -- 5º Passo : Descobrindo sequencial 
        --            Esse sequencial vai ser por empresa e por valor do cartao 
        -------------------------------------------------------------------------
        Select @Sequencial_Cartao = IsNull(Max(Numero_Cartao),0)+1
          From  TB_Cartao
          Where CD_Empresa   = @CD_Empresa   And
                Valor_Cartao = @Valor_Cartao     

        If @Sequencial_Cartao > 9999 
          Begin
            Rollback Transaction
            RAISERROR ('Numero de cartões excedido para o codigo da empresa para o valor com valor passado.', 16, 1)
            Return
          End   

          ------------------------------------------------------------------
          -- 6º Passo : Calculando o DV , igual ao CNPJ
          ------------------------------------------------------------------
          Set @Cartao = Right('00' + Convert(varchar(2),@Valor_Cartao),2) + Right('000000' + Convert(varchar(6),@CD_Empresa),6) + Right('0000' + Convert(varchar(4),@Sequencial_Cartao),4)  

          Set @Digito_Verificador = dbo.PS_CNPJ(@Cartao) 
          Set @Cartao      = @Cartao + @Digito_Verificador

          ------------------------------------------------------------------
          -- 7º Passo : Numero criptografado
          ------------------------------------------------------------------       
          exec dbo.PS_Criptografia2 @Cartao,@Serie OUTPUT       

          if @CD_Empresa = 101090
             Set @Status = 1
            Else
             Set @Status = 4

          -------------------------------------------------------------------
          -- 8º Passo : Inserindo o cartão
          -------------------------------------------------------------------
          Insert Into TB_Cartao
          (Valor_Cartao,CD_Empresa, Numero_Cartao, Digito_Verificador,
            Serie, Status, Data_Status, cd_associado)
          Values 
          (@Valor_Cartao,@CD_Empresa, @Sequencial_Cartao,  
           convert(smallint,@Digito_Verificador), @Serie, @Status,
           getdate(),null)

     Commit Transaction
           
     If @Devolve_Serie = 1
        Select @Cartao, @Serie   

End
