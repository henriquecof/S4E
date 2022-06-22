/****** Object:  Procedure [dbo].[PS_DadosVendaPorVendedorDentalPass]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE Procedure [dbo].[PS_DadosVendaPorVendedorDentalPass]
      (@DT_Inicial varchar(20),
       @DT_Final varchar(20),
       @CD_Filial Int,
       @CD_Funcionario Int) 
As
Begin    

         Select 
                T7.Valor,                                                 
                 Right('00' + Convert(varchar(2),T1.Valor_Cartao),2) +  
                 Right('000000' + Convert(varchar(6),T1.CD_Empresa),6) +  
                 Right('0000' + Convert(varchar(4),T1.Numero_Cartao),4) +  
                 Right('00' + Convert(varchar(2),T1.Digito_Verificador),2) 
                 As Cartao, 
                 Convert(varchar(10),T4.Data_Entrega,103) as dataEntrega,  
                 Convert(varchar(10),T5.Data_Pagamento,103) as dataPagamento,  
                 (Select Isnull(Sum(T100.Valor_Lancamento),0)  
                          From  ABS_Financeiro..TB_FormaLancamento T100 
                          Where T100.Sequencial_Cartao = T1.Sequencial_Cartao) 
                  As Valor_Usado, 
                  (Select Top 1 IsNull(T100.Sequencial_FormaLancamento,0)  
                          From  ABS_Financeiro..TB_FormaLancamento T100,
                                ABS_Financeiro..TB_Lancamento T200, 
                                TB_Pagamento_ContaVendedor T300 
                          Where T100.Sequencial_Lancamento = T200.Sequencial_Lancamento And 
                                T200.Sequencial_Lancamento = T300.Sequencial_Lancamento And 
                                T300.Sequencial_PagamentoContaVendedor = T5.Sequencial_PagamentoContaVendedor) 
                    As Sequencial, 
                  Convert(varchar,T6.CD_Associado) + ' ' + T6.NM_Completo As Associado 
                  From   TB_Cartao T1,  
                         Funcionario T2,
                         TB_Cartao_Vendedor T3,  
                         TB_Venda_CartaoVendedor T4, 
                         TB_Pagamento_ContaVendedor T5,  
                         Associados T6, 
                         ABS_Financeiro..TB_ValorDominio T7 
                   Where T1.Sequencial_Cartao                  = T3.Sequencial_Cartao              And 
                         T3.Sequencial_VendaCartaoVendedor     = T4.Sequencial_VendaCartaoVendedor And 
                         T1.CD_Associado                      = T6.CD_Associado       And  
                         T4.CD_Funcionario                     = T2.CD_Funcionario     And 
                         T2.CD_Empresa                         = @CD_Filial            And
                         T1.Valor_Cartao                       = T7.CodigoValorDominio And 
                         T7.CodigoDominio                      = 10                    And                                               
                         T3.Sequencial_PagamentoContaVendedor = T5.Sequencial_PagamentoContaVendedor And 
                         T5.Data_Pagamento between @DT_Inicial And @DT_Final And
                         T2.CD_Funcionario = @CD_Funcionario 
                         Order By T2.NM_Empregado, T7.CodigoValorDominio 
End
