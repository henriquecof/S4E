/****** Object:  Procedure [dbo].[PS_GeraLoteComissaoVendedor_Temp]    Committed by VersionSQL https://www.versionsql.com ******/

Create Procedure [dbo].[PS_GeraLoteComissaoVendedor_Temp](@CD_Funcionario Int)
As 
Begin

   --declaração de variaveis--------------------------------------------------------------------------
   declare @cd_sequencial_dependente  int 
   declare @cd_parcela_comissao int
   declare @valor money
   declare @perc_pagamento money
   declare @cd_sequencial int
   declare @NumeroParcela int
   declare @sequencialmensalidade int
   declare @quantidadeparcelapaga int
   declare @usuario_inclusao int
   declare @gerar_lote smallint
   declare @sequencial_lote_comissao int
   declare @vl_parcela money
   Declare @dt_base datetime = getdate()

   -- usuario inclusao --------------------------------------------------------------------------------
  Select @usuario_inclusao = cd_funcionario
     From  processos
     Where cd_processo = 2

   ---- Limpar os temporarios      
   --update comissao_vendedor -- Limpa os registros do Lote para iniciar o processo 
   --   set cd_sequencial_mensalidade_planos = null 
   -- where cd_sequencial_mensalidade_planos is not null and 
   --       cd_funcionario = @CD_Funcionario and 
   --       cd_sequencial_lote is null 

   --Todos os lotes em aberto de comissão desse vendedor ----------------------------------------------
   DECLARE cursor_lote_pro CURSOR FOR 
    Select cd_sequencial, cd_sequencial_dependente, cd_parcela_comissao, valor, perc_pagamento
       from comissao_vendedor
       Where cd_funcionario                   = @CD_Funcionario And
             cd_sequencial_mensalidade_planos is null and
             cd_sequencial_lote               is null And
             dt_exclusao                      is null and 
             fl_vitalicio                     is null -- Nao ser vitalicio 
       Order by cd_sequencial_dependente, cd_parcela_comissao
   
   OPEN cursor_lote_pro
   FETCH NEXT FROM cursor_lote_pro 
   INTO @cd_sequencial, @cd_sequencial_dependente, @cd_parcela_comissao, @valor, 
        @perc_pagamento

   WHILE (@@FETCH_STATUS <> -1)
   BEGIN
         --numero da parcela
         Set @NumeroParcela = 1

         --Saber se essa mensalidade foi paga.
         DECLARE cursor_mensalidade_pro CURSOR FOR 
         Select t2.cd_sequencial, t2.valor, 
			(Select count(cd_sequencial)
						from mensalidades t10, mensalidades_planos t20
						where t10.cd_tipo_recebimento  not in (1,2) And
							  t10.cd_tipo_parcela in (1,2)         And
							  t10.cd_parcela = t20.cd_parcela_mensalidade And
							  t20.cd_sequencial_dep = t2.cd_sequencial_dep  And
							  t20.dt_exclusao is null)  
			From mensalidades t1, mensalidades_planos t2
			Where t1.cd_tipo_recebimento  not in (1,2)  And
				  t1.cd_tipo_parcela in (1,2)         And
				  t1.cd_parcela = t2.cd_parcela_mensalidade And
				  t2.cd_sequencial_dep = @cd_sequencial_dependente  And
				  t2.dt_exclusao is null And
                  t2.cd_sequencial not in (Select cd_sequencial_mensalidade_planos
                                             From Comissao_Vendedor t100 
                                             where cd_sequencial_mensalidade_planos is not null And
                                                   t100.cd_sequencial_dependente = t2.cd_sequencial_dep and 
                                                   t100.cd_funcionario  = @CD_Funcionario)
			Order by 1     

            OPEN cursor_mensalidade_pro
            FETCH NEXT FROM cursor_mensalidade_pro INTO 
                @sequencialmensalidade, @vl_parcela, @quantidadeparcelapaga

            WHILE (@@FETCH_STATUS <> -1)
               BEGIN
                   --Saber se numero da parcela a ser paga como comissão já foi paga pelo associado.
                   --vou comparar o numero da parcela com a quantidade de parcelas pagas. 
                  if (@cd_parcela_comissao <= @quantidadeparcelapaga) --And (@vl_parcela >= @valor)
                    Begin

                       --incluindo comissao no lote
                       update comissao_vendedor set
                          cd_sequencial_mensalidade_planos = @sequencialmensalidade 
                        where cd_sequencial = @cd_sequencial 
                              And cd_sequencial_mensalidade_planos is null
                              And cd_sequencial_lote is null
                              And dt_exclusao is null    

                    End   

                    FETCH NEXT FROM cursor_mensalidade_pro INTO @sequencialmensalidade, @vl_parcela, @quantidadeparcelapaga

               END
               Close cursor_mensalidade_pro
               DEALLOCATE cursor_mensalidade_pro

       FETCH NEXT FROM cursor_lote_pro INTO @cd_sequencial, @cd_sequencial_dependente, @cd_parcela_comissao, @valor, @perc_pagamento

   END
   Close cursor_lote_pro
   DEALLOCATE cursor_lote_pro

End
