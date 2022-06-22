/****** Object:  Function [dbo].[FS_CalculaOrcamento]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE Function [dbo].[FS_CalculaOrcamento]
  (
   @Orcamento Int
  )
RETURNS Money
As  
Begin

  Declare @VL_SomaProcedimentoCobrado Decimal(18,2)
  Declare @VL_SomaServico Decimal(18,2)
  Declare @VL_SomaProcedimentoRealizado Decimal(18,2)
  Declare @VL_Comissao Decimal(18,2)
  Declare @VL_Desconto Decimal(18,2)
  Declare @VL_cdtipopagamento Int
  Declare @VL_DescontoCartao Decimal(18,2)
  Declare @VL_Retornado Money 

  -- Desconto e Tipo Pagamento
  select @vl_desconto = perc_desconto , @VL_cdtipopagamento = cd_tipo_pagamento 
    from orcamento_clinico
    Where cd_Orcamento = @Orcamento

   If (@VL_cdtipopagamento = 4) Or (@VL_cdtipopagamento = 12) Or (@VL_cdtipopagamento = 20) Or (@VL_cdtipopagamento = 21) Or (@VL_cdtipopagamento = 25)
     Begin
       Set @VL_DescontoCartao = 5
     End 
   Else
     Begin
       Set @VL_DescontoCartao = 0
     End 

  -- Saber o valor cobrado no orcamento.
  Select @VL_SomaProcedimentoCobrado = sum(vl_servico) - ((sum(vl_servico) * @vl_desconto)/100) - ((sum(vl_servico) * @VL_DescontoCartao)/100)
     From  Orcamento_Servico 
     Where cd_Orcamento = @Orcamento
   
  -- Trabalhos do orcamento.
  Select @VL_SomaServico = IsNull(Sum(Quantidade * Valor),0) 
     From  Orcamento_Fornecedor 
     Where cd_Orcamento = @Orcamento

  -- Procedimentos realizados.
  Select @VL_SomaProcedimentoRealizado = IsNull(Count(Sequencial_ConsultaOrcamento) * (Select convert(decimal(18,2),vl_dominio) From DOMINIO_VALOR Where cd_sequencial = 1 And cd_dominio=7),0) 
     From  Consultas_Orcamento 
     Where CD_Orcamento = @Orcamento

  -- comissões.
  Select @VL_Comissao = IsNull(Sum((vl_pagamento * perc_pagamento)/100),0)
     From  Comissao_Vendedor 
     Where CD_Orcamento = @Orcamento

  If @VL_SomaProcedimentoCobrado > 0 
     Set @VL_Retornado  = @VL_SomaServico + @VL_SomaProcedimentoRealizado + @VL_Comissao
  Else 
     Set @VL_Retornado  = 0   

  Return @VL_Retornado 

End 
