/****** Object:  Procedure [dbo].[PS_DadosImprimirCarteiras]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE Procedure [dbo].[PS_DadosImprimirCarteiras](@DataInicial varchar(10),@DataFinal varchar(10),@Impressa smallint)
--ALTER Procedure [dbo].[PS_DadosImprimirCarteiras](@DataInicial varchar(10),@DataFinal varchar(10),@Impressa smallint,@TipoPessoa smallint)
As
Begin

if @Impressa = 0
			   Begin
				 /*Contratos do associado principal e dependentes cadastrados juntos*/
					Select 'Contrato Associado' as tipo, t1.CD_Associado, t3.nm_dependente, t3.cd_sequencial, t1.sequencial_agendamento
					From tb_agendamentovendacontrato t1, dependentes t3, associados t4, empresa t5
					Where t1.cd_associado       = t3.cd_associado    And 
                          t1.cd_associado       = t4.cd_associado    And 
						  --t1.cd_sequencial_dep  = 1                  And
						  t1.nr_contrato        = t3.nr_contrato     And
						  t1.sequencial_sop     is null              And
						  t1.Tipo_Contrato      = 1                  And
						  t1.Carteira_Impressa   is null             And
						  t1.data_horainclusao  between @DataInicial And @DataFinal And
                          t4.cd_empresa = t5.cd_empresa and
                          t5.tp_empresa <> 3
					Union
    				Select 'Contrato Dependente' as tipo, t1.CD_Associado, t3.nm_dependente, t3.cd_sequencial, t1.sequencial_agendamento
					From tb_agendamentovendacontrato t1, dependentes t3, associados t4, empresa t5
					Where t1.cd_associado       = t3.cd_associado    And
                          t1.cd_associado       = t4.cd_associado    And 
						  t1.cd_sequencial_dep  = t3.cd_sequencial   And 
						  t1.sequencial_sop     is null              And
						  t1.Tipo_Contrato      = 2                  And
						  t1.cd_sequencial_dep  > 1                    And
						  t1.Carteira_Impressa   is null              And
						  t1.data_horainclusao  between @DataInicial And @DataFinal And
                          t4.cd_empresa = t5.cd_empresa and
                          t5.tp_empresa <> 3
                          
                    Union
                    Select 'Contrato Associado' as tipo, t1.CD_Associado, t3.nm_dependente, t3.cd_sequencial, t1.sequencial_agendamento
					From tb_agendamentovendacontrato t1, dependentes t3, associados t4, empresa t5
					Where t1.cd_associado       = t3.cd_associado    And 
                          t1.cd_associado       = t4.cd_associado    And 
						  --t1.cd_sequencial_dep  = 1                  And
						  t1.nr_contrato        = t3.nr_contrato     And
						  t1.sequencial_sop     is null              And
						  t1.Tipo_Contrato      = 1                  And
						  t1.Carteira_Impressa   is null             And
						  t1.data_horainclusao  between @DataInicial And @DataFinal And
                          t4.cd_empresa = t5.cd_empresa and
                          t5.tp_empresa = 3
					Union
    				Select 'Contrato Dependente' as tipo, t1.CD_Associado, t3.nm_dependente, t3.cd_sequencial, t1.sequencial_agendamento
					From tb_agendamentovendacontrato t1, dependentes t3, associados t4, empresa t5
					Where t1.cd_associado       = t3.cd_associado    And
                          t1.cd_associado       = t4.cd_associado    And 
						  t1.cd_sequencial_dep  = t3.cd_sequencial   And 
						  t1.sequencial_sop     is null              And
						  t1.Tipo_Contrato      = 2                  And
						  t1.cd_sequencial_dep  > 1                    And
						  t1.Carteira_Impressa   is null              And
						  t1.data_horainclusao  between @DataInicial And @DataFinal And
                          t4.cd_empresa = t5.cd_empresa and
                          t5.tp_empresa = 3
					Order By 1,2,4
			   End
			Else
			   Begin
    				Select 'Contrato Associado' as tipo, t1.CD_Associado, t3.nm_dependente, t3.cd_sequencial, t1.sequencial_agendamento
					From tb_agendamentovendacontrato t1, dependentes t3, associados t4, empresa t5
					Where t1.cd_associado       = t3.cd_associado    And 
                          t1.cd_associado       = t4.cd_associado    And
						  --t1.cd_sequencial_dep  = 1                  And
						  t1.nr_contrato        = t3.nr_contrato     And
						  t1.sequencial_sop     is null              And
						  t1.Tipo_Contrato      = 1                  And
						  t1.Carteira_Impressa  = 1                  And
						  t1.data_horainclusao  between @DataInicial And @DataFinal And
                          t4.cd_empresa = t5.cd_empresa and
                          t5.tp_empresa <> 3
					Union
    				Select 'Contrato Dependente' as tipo, t1.CD_Associado, t3.nm_dependente, t3.cd_sequencial, t1.sequencial_agendamento
					From tb_agendamentovendacontrato t1, dependentes t3, associados t4, empresa t5
					Where t1.cd_associado       = t3.cd_associado    And 
                          t1.cd_associado       = t4.cd_associado    And
						  t1.cd_sequencial_dep  = t3.cd_sequencial   And 
						  t1.sequencial_sop     is null              And
						  t1.Tipo_Contrato      = 2                  And
						  t1.cd_sequencial_dep  > 1                   And
						  t1.Carteira_Impressa  = 1                   And
						  t1.data_horainclusao  between @DataInicial And @DataFinal And
                          t4.cd_empresa = t5.cd_empresa and
                          t5.tp_empresa <> 3
					Union
    				Select 'Contrato Associado' as tipo, t1.CD_Associado, t3.nm_dependente, t3.cd_sequencial, t1.sequencial_agendamento
					From tb_agendamentovendacontrato t1, dependentes t3, associados t4, empresa t5
					Where t1.cd_associado       = t3.cd_associado    And 
                          t1.cd_associado       = t4.cd_associado    And
						  --t1.cd_sequencial_dep  = 1                  And
						  t1.nr_contrato        = t3.nr_contrato     And
						  t1.sequencial_sop     is null              And
						  t1.Tipo_Contrato      = 1                  And
						  t1.Carteira_Impressa  = 1                  And
						  t1.data_horainclusao  between @DataInicial And @DataFinal And
                          t4.cd_empresa = t5.cd_empresa and
                          t5.tp_empresa = 3
					Union
    				Select 'Contrato Dependente' as tipo, t1.CD_Associado, t3.nm_dependente, t3.cd_sequencial, t1.sequencial_agendamento
					From tb_agendamentovendacontrato t1, dependentes t3, associados t4, empresa t5
					Where t1.cd_associado       = t3.cd_associado    And 
                          t1.cd_associado       = t4.cd_associado    And
						  t1.cd_sequencial_dep  = t3.cd_sequencial   And 
						  t1.sequencial_sop     is null              And
						  t1.Tipo_Contrato      = 2                  And
						  t1.cd_sequencial_dep  > 1                   And
						  t1.Carteira_Impressa  = 1                   And
						  t1.data_horainclusao  between @DataInicial And @DataFinal And
                          t4.cd_empresa = t5.cd_empresa and
                          t5.tp_empresa = 3
					Order By 1,2,4
			   End
     End
----pessoa juridica
--if @TipoPessoa = 1
--  Begin
--			if @Impressa = 0
--			   Begin
--				 /*Contratos do associado principal e dependentes cadastrados juntos*/
--					Select 'Contrato Associado' as tipo, t1.CD_Associado, t3.nm_dependente, t3.cd_sequencial, t1.sequencial_agendamento
--					From tb_agendamentovendacontrato t1, dependentes t3, associados t4
--					Where t1.cd_associado       = t3.cd_associado    And 
--                          t1.cd_associado       = t4.cd_associado    And 
--						  --t1.cd_sequencial_dep  = 1                  And
--						  t1.nr_contrato        = t3.nr_contrato     And
--						  t1.sequencial_sop     is null              And
--						  t1.Tipo_Contrato      = 1                  And
--						  t1.Carteira_Impressa   is null             And
--						  t1.data_horainclusao  between @DataInicial And @DataFinal And
--                          t4.tp_empresa <> 3
--					Union
--    				Select 'Contrato Dependente' as tipo, t1.CD_Associado, t3.nm_dependente, t3.cd_sequencial, t1.sequencial_agendamento
--					From tb_agendamentovendacontrato t1, dependentes t3, associados t4
--					Where t1.cd_associado       = t3.cd_associado    And
--                          t1.cd_associado       = t4.cd_associado    And 
--						  t1.cd_sequencial_dep  = t3.cd_sequencial   And 
--						  t1.sequencial_sop     is null              And
--						  t1.Tipo_Contrato      = 2                  And
--						  t1.cd_sequencial_dep  > 1                    And
--						  t1.Carteira_Impressa   is null              And
--						  t1.data_horainclusao  between @DataInicial And @DataFinal And
--                          t4.tp_empresa <> 3
--					Order By 1,2,4
--			   End
--			Else
--			   Begin
--    				Select 'Contrato Associado' as tipo, t1.CD_Associado, t3.nm_dependente, t3.cd_sequencial, t1.sequencial_agendamento
--					From tb_agendamentovendacontrato t1, dependentes t3, associados t4
--					Where t1.cd_associado       = t3.cd_associado    And 
--                          t1.cd_associado       = t4.cd_associado    And
--						  --t1.cd_sequencial_dep  = 1                  And
--						  t1.nr_contrato        = t3.nr_contrato     And
--						  t1.sequencial_sop     is null              And
--						  t1.Tipo_Contrato      = 1                  And
--						  t1.Carteira_Impressa  = 1                  And
--						  t1.data_horainclusao  between @DataInicial And @DataFinal And
--                          t4.tp_empresa <> 3
--					Union
--    				Select 'Contrato Dependente' as tipo, t1.CD_Associado, t3.nm_dependente, t3.cd_sequencial, t1.sequencial_agendamento
--					From tb_agendamentovendacontrato t1, dependentes t3, associados t4
--					Where t1.cd_associado       = t3.cd_associado    And 
--                          t1.cd_associado       = t4.cd_associado    And
--						  t1.cd_sequencial_dep  = t3.cd_sequencial   And 
--						  t1.sequencial_sop     is null              And
--						  t1.Tipo_Contrato      = 2                  And
--						  t1.cd_sequencial_dep  > 1                   And
--						  t1.Carteira_Impressa  = 1                   And
--						  t1.data_horainclusao  between @DataInicial And @DataFinal And
--                          t4.tp_empresa <> 3
--					Order By 1,2,4
--			   End
--     End
--Else
--    --pessoa fisica
--     Begin
--			if @Impressa = 0
--			   Begin
--				 /*Contratos do associado principal e dependentes cadastrados juntos*/
--					Select 'Contrato Associado' as tipo, t1.CD_Associado, t3.nm_dependente, t3.cd_sequencial, t1.sequencial_agendamento
--					From tb_agendamentovendacontrato t1, dependentes t3, associados t4
--					Where t1.cd_associado       = t3.cd_associado    And 
--                          t1.cd_associado       = t4.cd_associado    And 
--						  --t1.cd_sequencial_dep  = 1                  And
--						  t1.nr_contrato        = t3.nr_contrato     And
--						  t1.sequencial_sop     is null              And
--						  t1.Tipo_Contrato      = 1                  And
--						  t1.Carteira_Impressa   is null             And
--						  t1.data_horainclusao  between @DataInicial And @DataFinal And
--                          t4.tp_empresa = 3
--					Union
--    				Select 'Contrato Dependente' as tipo, t1.CD_Associado, t3.nm_dependente, t3.cd_sequencial, t1.sequencial_agendamento
--					From tb_agendamentovendacontrato t1, dependentes t3, associados t4
--					Where t1.cd_associado       = t3.cd_associado    And
--                          t1.cd_associado       = t4.cd_associado    And 
--						  t1.cd_sequencial_dep  = t3.cd_sequencial   And 
--						  t1.sequencial_sop     is null              And
--						  t1.Tipo_Contrato      = 2                  And
--						  t1.cd_sequencial_dep  > 1                    And
--						  t1.Carteira_Impressa   is null              And
--						  t1.data_horainclusao  between @DataInicial And @DataFinal And
--                          t4.tp_empresa = 3
--					Order By 1,2,4
--			   End
--			Else
--			   Begin
--    				Select 'Contrato Associado' as tipo, t1.CD_Associado, t3.nm_dependente, t3.cd_sequencial, t1.sequencial_agendamento
--					From tb_agendamentovendacontrato t1, dependentes t3, associados t4
--					Where t1.cd_associado       = t3.cd_associado    And 
--                          t1.cd_associado       = t4.cd_associado    And
--						  --t1.cd_sequencial_dep  = 1                  And
--						  t1.nr_contrato        = t3.nr_contrato     And
--						  t1.sequencial_sop     is null              And
--						  t1.Tipo_Contrato      = 1                  And
--						  t1.Carteira_Impressa  = 1                  And
--						  t1.data_horainclusao  between @DataInicial And @DataFinal And
--                          t4.tp_empresa = 3
--					Union
--    				Select 'Contrato Dependente' as tipo, t1.CD_Associado, t3.nm_dependente, t3.cd_sequencial, t1.sequencial_agendamento
--					From tb_agendamentovendacontrato t1, dependentes t3, associados t4
--					Where t1.cd_associado       = t3.cd_associado    And 
--                          t1.cd_associado       = t4.cd_associado    And
--						  t1.cd_sequencial_dep  = t3.cd_sequencial   And 
--						  t1.sequencial_sop     is null              And
--						  t1.Tipo_Contrato      = 2                  And
--						  t1.cd_sequencial_dep  > 1                   And
--						  t1.Carteira_Impressa  = 1                   And
--						  t1.data_horainclusao  between @DataInicial And @DataFinal And
--                          t4.tp_empresa = 3
--					Order By 1,2,4
--			   End
--     End  
--End
