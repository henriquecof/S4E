/****** Object:  Function [dbo].[FG_NovaFaixa]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE FUNCTION [dbo].[FG_NovaFaixa](@Dentista int,@DataAtual varchar(10))
  RETURNS Money
As
Begin
   Declare @faixa money
   Declare @Somatorio money
   
   Select @faixa = t4.vl_faixa
    from  funcionario t3, Funcionario_Faixa t4
    where t3.cd_funcionario = @Dentista And 
          t3.cd_faixa       = t4.cd_faixa

  set @Somatorio = 0

   Select @Somatorio =  @Somatorio +  isnull(sum(t2.vl_servico),0)
     from pagamento_dentista t1, pagamento_dentista_guia t2      
     where cd_funcionario = @Dentista and
          month(dt_previsao_pagamento)  = month(@DataAtual) and
          year(dt_previsao_pagamento)   = year(@DataAtual) and
          t1.cd_sequencial = t2.cd_sequencial and
          t1.fl_fechado = 1 

   Select @Somatorio = @Somatorio  + isnull(sum(vl_parcela),0)
     from pagamento_dentista t1
     where cd_funcionario = @Dentista and
          month(dt_previsao_pagamento)  = month(@DataAtual) and
          year(dt_previsao_pagamento)   = year(@DataAtual) and
          t1.cd_sequencial not in (Select cd_sequencial from pagamento_dentista_guia where pagamento_dentista_guia.cd_sequencial = t1.cd_sequencial) and
          t1.fl_fechado = 1 
            
   return @faixa - @Somatorio    

End 
