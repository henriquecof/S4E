/****** Object:  Function [dbo].[FS_ValidaConsulta]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE  Function [dbo].[FS_ValidaConsulta]
        (
     	 @CD_Associado Int,
         @CD_Sequencial_Dep int,
         @CD_Servico Int,
         @NR_Guia Int,
         @CD_Funcionario Int,         
         @CD_UD Nvarchar(100),
         @Mesial int,
         @Oclusal int,
         @Vestibular int,
         @Lingual int,
         @Distral int,
         @DT_Servico DateTime,
         @ChavePrimaria Int,
         @Filial Int,
         @DT_Cancelamento DateTime,
         @FL_analisa  Smallint
	)
RETURNS Varchar(1000)
AS	
  Begin
-----------------------------------------------------------------------------------
/* Criei uma tabela onde coloquei todos os dentes e seus respectivos tipos 
TABLE : Tipo_Dente
1 - DentesAnteriores
2 - DentesPosteriores
3-  DentesAdulto
4 - DentesLeite
5 - ArcadaAdultoSuperiorEsquerdo
6 - ArcadaAdultoSuperiorDireito
7 - ArcadaAdultoInferiorEsquerdo
8 - ArcadaAdultoInferiorDireito

Tipos de procedimentos
Pode ser:
1 - Interno
2 - Credenciado
3 - Particular
4 - Ortodontico
5 - Inativo

Dentes
Select @DS_DentesAnteriores             = '13,12,11,23,22,21,43,42,41,33,32,31,53,52,51,63,62,61,73,72,71,83,82,81'
Select @DS_DentesPosteriores            = '18,17,16,15,14,28,27,26,25,24,38,37,36,35,34,48,47,46,45,44,55,54,65,64,75,74,84,85'
Select @DS_DentesAdulto                 = '11,12,13,14,15,16,17,18,21,22,23,24,25,26,27,28,48,47,46,45,44,43,42,41,31,32,33,34,35,36,37,38'
Select @DS_DentesLeite                  = '55,54,53,52,51,85,84,83,82,81,61,62,63,64,65,71,72,73,74,75'
Select @DS_ArcadaAdultoSuperiorEsquerdo = '18,17,16,15,14,13,12,11'
Select @DS_ArcadaAdultoSuperiorDireito  = '21,22,23,24,25,26,27,28'
Select @DS_ArcadaAdultoInferiorEsquerdo = '48,47,46,45,44,43,42,41'
Select @DS_ArcadaAdultoInferiorDireito  = '31,32,33,34,35,36,37,38'    
*/        
-----------------------------------------------------------------------------------

-----------------------------------------------------------------------------------
-- Declaracao de variaveis 
-----------------------------------------------------------------------------------
        Declare @CD_UDServico         Nvarchar(100) 
        Declare @WL_Idade             SmallInt 
        Declare @TP_Procedimento      SmallInt
        Declare @DT_Inicial           DateTime
        Declare @DT_Final             DateTime
        Declare @DT_Atual             DateTime
        Declare @DS_Mensagem          Varchar(1000)
        Declare @NR_Quantidade        Int 
        Declare @CD_Plano             Int 
        Declare @CD_Orcamento         Int 
        Declare @CD_EntreiProcEspec   Smallint 
        Declare @Status               Smallint

-----------------------------------------------------------------------------------
-- Inicio do codigo
-----------------------------------------------------------------------------------

       Set @DS_Mensagem = ''
       Select @DT_Atual = '03/01/2008'
       Select @CD_UD = Convert(Int,@CD_UD) 

       If IsNull(@FL_analisa,0) <> 0
           Begin              
             Return @DS_Mensagem 
           End 

       If @DT_Cancelamento Is Not Null 
           Begin 
             If @DT_Servico is Not Null
               Begin             
                 Set @DS_Mensagem = 'Procedimento que foi cancelado não pode ser baixado.'
                 Return @DS_Mensagem
               End   
            Else
               Begin                   
                  Return @DS_Mensagem     
               End 
           End 

       /* Procedimento executado antes do plano*/
       If @Filial = 657 
           Begin 
             Return @DS_Mensagem     
           End        

       -- 1º) Idade do Usuario 
       Select @WL_Idade = DateDiff(Year,IsNull(DT_NASCIMENTO,dateadd(year,-1,@DT_Atual)),@DT_Atual)
             From  Dependentes 
             Where CD_Associado  = @CD_Associado And 
                   CD_Sequencial = @CD_Sequencial_Dep
       If @WL_Idade < 0 
          Begin              
              Set @DS_Mensagem = 'A data de nascimento do associado precisa ser preenchida. Vá para a tela de associados e preencha a data de nascimento.'
              Return @DS_Mensagem
          End      

       Select @TP_Procedimento = TP_Procedimento
           From Servico Where CD_Servico = @CD_Servico       

      -- 3º) Tipo de Procedimento.
       If @TP_Procedimento Is Null 
          Begin              
              Set @DS_Mensagem = 'Tipo de procedimento precisa ser preenchida. Fale com o admnistrador do sistema.'
              Return @DS_Mensagem
          End  

---------------------------------------------------------------------------------------------------------------------------------------         
       -- Se esse procedimento não é particular e está dentro do orçamento,
       -- ele deve ficar como PARTICULAR mesmo assim
       If (Select count(cd_sequencial_pp)
               from orcamento_servico 
               where cd_sequencial_pp = @ChavePrimaria) > 0 
         Begin
             Set @TP_Procedimento = 3
         End        

        -- Testes para procedimentos PARTICULARES.    
       If @TP_Procedimento = 3
          Begin            
             -- PRÓTESE TOTAL 
             -- Testar se o procedimento está no orçamento e se o orçamento está FECHADO.
              If @DT_Servico Is Not Null
                Begin 

                     -- Flag para saber se é um desses procedimentos e não entrar no teste GERAL
                     Select @CD_EntreiProcEspec = 1                                                       

                     -- PRÓTESE TOTAL                    
                     -- Orçamento Fechados. Exceções.
                     If @CD_Servico In (999,4420,4430,4440,4450,4290,4300,4310,4670,4280)
                        Begin
                            Select @CD_EntreiProcEspec = 2
                            -- Saber se têm orçamento fechado com os sguintes procedimentos. (4290, 4300 e 4310).
                            -- Se tiver é para deixar passar. 
                            -- Orçamento fechado.
                           Select @NR_Quantidade = count(t1.cd_orcamento) , @CD_Orcamento = max(t1.cd_orcamento)
                               From   Orcamento_clinico T1, Orcamento_servico T2 , Consultas t3
                               Where  T3.CD_Associado       = @CD_Associado       And 
                                      T3.CD_Sequencial_Dep  = @CD_Sequencial_Dep  And 
                                      T3.CD_Servico         In (4290,4300,4310)    And 
                                      T3.CD_Sequencial      = T2.cd_sequencial_pp And 
                                      T2.cd_orcamento       = T1.cd_orcamento     And 
                                      T1.cd_status          = 1   -- Orçamento fechado : 1 - fechado , 0 - Aberto , 2 - validade vencida, 3 - cancelado.
                           If @NR_Quantidade = 0 
                             Begin	                       
                               Select @DS_Mensagem = 'Para o associado usar esse procedimento ' + convert(varchar,@CD_Servico) + '. Dentro do orçamento precisaria existir pelo menos um desses procedimentos 4290, 4300 ou 4310'                        	                       
	                           Return @DS_Mensagem
                             End   
                        End

                    -- PRÓTESE REMOVÍVEL
                    -- Orçamento Fechados. Exceções.
                    If @CD_Servico In (999,4420,4480,4440,4450,4250,4260,4670)
                        Begin
                            Select @CD_EntreiProcEspec = 2
                            -- Saber se têm orçamento fechado com os sguintes procedimentos. (4250,4260).
                            -- Se tiver é para deixar passar. 
                            -- Orçamento fechado.
                           Select @NR_Quantidade = count(t1.cd_orcamento), @CD_Orcamento = max(t1.cd_orcamento) 
                               From   Orcamento_clinico T1, Orcamento_servico T2 , Consultas t3
                               Where  T3.CD_Associado       = @CD_Associado       And 
                                      T3.CD_Sequencial_Dep  = @CD_Sequencial_Dep  And 
                                      T3.CD_Servico         IN (4250,4260)    And 
                                      T3.CD_Sequencial      = T2.cd_sequencial_pp And 
                                      T2.cd_orcamento       = T1.cd_orcamento     And 
                                      T1.cd_status          = 1   -- Orçamento fechado : 1 - fechado , 0 - Aberto , 2 - validade vencida, 3 - cancelado.
                           If @NR_Quantidade = 0 
                             Begin	                       
                               Select @DS_Mensagem = 'Para o associado usar esse procedimento ' + convert(varchar,@CD_Servico) + '. Dentro do orçamento precisaria existir pelo menos um desses procedimentos 4250 ou 4260'                        	                       
	                           Return @DS_Mensagem
                             End  
                        End

                   -- COROA METALO-PLÁSTICA 
                   -- Orçamento Fechados. Exceções.
                   If @CD_Servico In (999,4420,4490,4090,4610,4080,4500,4510,4610,4470,4460,4200,4110)
                        Begin
                            Select @CD_EntreiProcEspec = 2
                            -- Saber se têm orçamento fechado com os sguintes procedimentos. (4200).
                            -- Se tiver é para deixar passar. 
                            -- Orçamento fechado.
                            Select @NR_Quantidade = count(t1.cd_orcamento), @CD_Orcamento = max(t1.cd_orcamento) 
                                From   Orcamento_clinico T1, Orcamento_servico T2 , Consultas t3
                                Where  T3.CD_Associado       = @CD_Associado       And 
                                       T3.CD_Sequencial_Dep  = @CD_Sequencial_Dep  And 
                                       T3.CD_Servico         = 4200    And 
                                       T3.CD_Sequencial      = T2.cd_sequencial_pp And 
                                       T2.cd_orcamento       = T1.cd_orcamento     And 
                                       T1.cd_status          = 1   -- Orçamento fechado : 1 - fechado , 0 - Aberto , 2 - validade vencida, 3 - cancelado.
                            If @NR_Quantidade = 0 
                              Begin	                            
                                Select @DS_Mensagem = 'Para o associado usar esse procedimento ' + convert(varchar,@CD_Servico) + '. Dentro do orçamento precisaria existir o procedimento 4200'                        	                            
	                            Return @DS_Mensagem
                              End  
                        End

                   -- COROA METALO-CERÂMICA - 
                   -- Orçamento Fechados. Exceções.
                   If @CD_Servico In (999,4420,4490,4090,4610,4080,4500,4510,4470,4520,4190,4320)
                        Begin

                            Select @CD_EntreiProcEspec = 2

                            -- Saber se têm orçamento fechado com os sguintes procedimentos. (4190).
                            -- Se tiver é para deixar passar. 
                            -- Orçamento fechado.
                            Select @NR_Quantidade = count(t1.cd_orcamento), @CD_Orcamento = max(t1.cd_orcamento) 
                                From   Orcamento_clinico T1, Orcamento_servico T2 , Consultas t3
                                Where  T3.CD_Associado       = @CD_Associado       And 
                                       T3.CD_Sequencial_Dep  = @CD_Sequencial_Dep  And 
                                       T3.CD_Servico         = 4190    And 
                                       T3.CD_Sequencial      = T2.cd_sequencial_pp And 
                                       T2.cd_orcamento       = T1.cd_orcamento     And 
                                       T1.cd_status          = 1   -- Orçamento fechado : 1 - fechado , 0 - Aberto , 2 - validade vencida, 3 - cancelado.
                            If @NR_Quantidade = 0 
                              Begin	                        
                                Select @DS_Mensagem = 'Para o associado usar esse procedimento ' + convert(varchar,@CD_Servico) + '. Dentro do orçamento precisaria existir o procedimento 4190'                        
                                Return @DS_Mensagem	                        	                        
                              End  
                        End

                     If @CD_EntreiProcEspec = 1 
                         -- Se orçamento está cancelado , ele não pode ser baixado
                        Set @Status = 0
                        Select @Status = t1.cd_status
                             From   Orcamento_clinico T1, Orcamento_servico T2 , Consultas t3
                                Where  T3.CD_Associado       = @CD_Associado       And 
                                       T3.CD_Sequencial_Dep  = @CD_Sequencial_Dep  And 
                                       T3.CD_Servico         = @CD_Servico         And 
                                       T3.CD_Sequencial      = T2.cd_sequencial_pp And 
                                       T2.cd_orcamento       = T1.cd_orcamento
                       If (@Status >= 3) 
                            Begin	                            
                                Select @DS_Mensagem = 'Procedimento não pode ser baixado pois está dentro de Orçamento que está cancelado.'                         	                            
	                            Return @DS_Mensagem
                             End

                         -- Orçamento fechado.
                         -- Teste Geral
                         Begin
                            Select @NR_Quantidade = count(t1.cd_orcamento), @CD_Orcamento = max(t1.cd_orcamento)  
                                From   Orcamento_clinico T1, Orcamento_servico T2 , Consultas t3
                                Where  T3.CD_Associado       = @CD_Associado       And 
                                       T3.CD_Sequencial_Dep  = @CD_Sequencial_Dep  And 
                                       T3.CD_Servico         = @CD_Servico         And 
                                       T3.CD_Sequencial      = T2.cd_sequencial_pp And 
                                       T2.cd_orcamento       = T1.cd_orcamento     And 
--                                     T3.CD_Sequencial      <> @ChavePrimaria     And
                                       T1.cd_status          = 1   -- Orçamento fechado : 1 - fechado , 0 - Aberto , 2 - validade vencida, 3 - cancelado.

                           If @NR_Quantidade = 0 
                              Begin	                            
                                Select @DS_Mensagem = 'O associado não têm nenhum Orçamento Fechado com esse procedimento. Inclusão não pode ser efetivada.'                         	                            
	                            Return @DS_Mensagem
                             End                   
                        End 

                    -- Incluir o procedimento para compor os custos de todo tratamento particular
/*                    Insert Into Consultas_Orcamento (cd_sequencial, cd_orcamento)
                    Values (@ChavePrimaria, @CD_Orcamento)*/

                End                             
                Return @DS_Mensagem
           End  

---------------------------------------------------------------------------------------------------------------------------------------         
        -- Testes para procedimentos ORTODONTIA    
       If @TP_Procedimento = 4 

          Begin

             -- Só pode ser executada na clinica.
             If @NR_Guia Is Not Null
                 Begin                    
                    Set @DS_Mensagem = 'Procedimento de ortodontia só pode ser feito nas clinicas da ABS.'
                    Return @DS_Mensagem
                 End       

             -- Saber se o associado têm cadastrado servico de ortodontia para ele.
             If (Select Count(CD_Associado)
                      From Servicos_Opcionais 
                      Where CD_Associado = @CD_Associado And
                            CD_Sequencial_Dep = @CD_Sequencial_Dep And 
                            CD_Sequencial <> @ChavePrimaria And
                            CD_Sop = 13) = 0 

                      Begin  
                           Select @NR_Quantidade = count(t1.cd_orcamento) 
                                From   Orcamento_clinico T1, Orcamento_servico T2 , Consultas t3
                                Where  T3.CD_Associado       = @CD_Associado       And 
                                       T3.CD_Sequencial_Dep  = @CD_Sequencial_Dep  And 
                                       T3.CD_Servico         = @CD_Servico         And 
                                       T3.CD_Sequencial      = T2.cd_sequencial_pp And 
                                       T2.cd_orcamento       = T1.cd_orcamento     And 
                                       T1.cd_status          = 1   -- Orçamento fechado : 1 - fechado , 0 - Aberto , 2 - validade vencida, 3 - cancelado.

                           If @NR_Quantidade = 0 
                             Begin                               
                               Set @DS_Mensagem =      'Procedimento de ortodontia não está cadastrado para esse associado.'
                               Return @DS_Mensagem
                           End  
                      End  

             -- Saber se o atendimento para o associado é desse dentista.
             If (Select Count(CD_Associado)
                      From Servicos_Opcionais 
                      Where CD_Associado = @CD_Associado And
                            CD_Sequencial_Dep = @CD_Sequencial_Dep And 
                            --CD_Sequencial <> @ChavePrimaria And
                            CD_Sop = 13 And CD_Funcionario = @CD_Funcionario) = 0 
                 Begin
                    
                    Set @DS_Mensagem = 'Procedimento de ortodontia desse associado não está cadastrado para esse dentista.'
                    Return @DS_Mensagem             
                 End  

             -- Saber se o atendimento para o associado : datas
              Select @DT_Inicial = DT_inicio, @DT_Final = DT_Fim
                      From Servicos_Opcionais 
                      Where CD_Associado = @CD_Associado And
                            CD_Sequencial_Dep = @CD_Sequencial_Dep And 
                            CD_Sop = 13 And CD_Funcionario = @CD_Funcionario

                 If DateDiff(Day, @DT_Inicial, @DT_Atual) < 0 
                   Begin                      
                      Select @DS_Mensagem = 'Associado só pode ser atendido para Ortodontia a partir do dia ' + Convert(varchar,@DT_Inicial,103)                      
                      Return @DS_Mensagem             
                   End  

                 If DateDiff(Day, @DT_Final, @DT_Atual) > 0 
                   Begin                      
                      Select @DS_Mensagem = 'Associado só pode ser atendido para Ortodontia até o dia ' + Convert(varchar,@DT_Final,103)                      
                      Return @DS_Mensagem             
                   End                                 
             Return @DS_Mensagem
          End 

-------------------------------------------------------------------------------------------------------------------------------------------------------------
      -- 2º) criticas gerais.    
     -- Não dá direito. Têm que ter orçamento.
     -- Saber qual o plano do asssociado ou dependete. Dependendo do tipo de plano têm que ter orçamento.
     If (Select count(T2.cd_plano)
          From  Dependentes T1, Plano_Servico T2
          Where T1.CD_Associado  = @CD_Associado And 
                T1.CD_Sequencial = @CD_Sequencial_Dep And 
                T1.CD_Plano      = T2.CD_Plano And 
                T2.CD_Servico    = @CD_Servico) > 0 
          Begin
                -- Têm que ter orçamento fechado para esse associado. 
                -- Verificando se existe orçamento fechado com esse procedimento.
                If (Select count(t1.cd_orcamento) 
                      From   orcamento_clinico T1, orcamento_servico T2 , Consultas t3
                      Where  T3.CD_Associado       = @CD_Associado       And 
                             T3.CD_Sequencial_Dep  = @CD_Sequencial_Dep  And 
                             T3.CD_Servico         = @CD_Servico         And 
                             T3.CD_Sequencial      = T2.cd_sequencial_pp And 
                             T2.cd_orcamento       = T1.cd_orcamento     And 
                             T1.cd_status          = 1) = 0   -- Orçamento fechado : 1 - fechado , 0 - Aberto , 2 - validade vencida, 3 - cancelado.
                 Begin	               
	               Select @DS_Mensagem = 'O serviço não é coberto pelo plano do associado. Precisa existir orcçamento fechado. Inclusão não pode ser efetivada.'	               
	               Return @DS_Mensagem
                 End  
          End  

     -- Saber qual o tipo de pagamento do usuário. Dependendo desse tipo deixar baixar
    If @CD_Servico In (100,510)
      If @DT_Servico Is Not Null
         Begin
           If (Select cd_tipo_pagamento From associados Where cd_associado = @CD_Associado) = 11
             Begin                 
                Return @DS_Mensagem
             End 
         End

      -- Saber qual o tipo de pagamento do usuário. Dependendo desse tipo, o procedimento têm que ter orçamento FECHADO.
    If @CD_Servico Not In (130,140,141,142,143,144,150,999,4420,4430,4440,4450,4290,4300,4310,4670,4420,4480,4440,4450,4250,4260,4670,4420,4490,4090,4610,4080,4500,4510,4610,4470,4460,4200,4110,4420,4490,4090,4610,4080,4500,4510,4470,4520,4190,4280,4320)
      If @DT_Servico Is Not Null
         Begin
           If (Select cd_tipo_pagamento From associados Where cd_associado = @CD_Associado) In (11,94,96,97,98,2,69,9,10,3,24,99)
             Begin 
                -- Verificando se existe orçamento fechado com esse procedimento.
                If (Select count(t1.cd_orcamento) 
                      From   orcamento_clinico T1, orcamento_servico T2 , Consultas t3
                      Where  T3.CD_Associado       = @CD_Associado       And 
                             T3.CD_Sequencial_Dep  = @CD_Sequencial_Dep  And 
                             T3.CD_Servico         = @CD_Servico         And 
                             T3.CD_Sequencial      = T2.cd_sequencial_pp And 
                             T2.cd_orcamento       = T1.cd_orcamento     And 
                             T1.cd_status          = 1) = 0   -- Orçamento fechado : 1 - fechado , 0 - Aberto , 2 - validade vencida, 3 - cancelado.
                   Begin	             
	               Select @DS_Mensagem = 'O associado não têm nenhum Orçamento fechado com esse procedimento ' + convert(varchar,@CD_Servico) + '. Inclusão não pode ser efetivada.'	             
	               Return @DS_Mensagem
                 End                   
                End 
             End 

      -- Saber se o dente já possui algum desses procedimentos abaixo ,se tiver não pode mais ter procedimentos para os mesmo.
       If @CD_UD is Not Null And @CD_Servico Not In (210,5015)
          If (Select Count(cd_sequencial) 
               From  Consultas 
               Where CD_Associado = @CD_Associado And
                     CD_Sequencial_Dep = @CD_Sequencial_Dep And 
                     CD_Sequencial  <> @ChavePrimaria And
                     DT_Servico Is Not Null and
                     CD_Servico In (490,495,730,780,5880,5900,5180,5181) And 
                     CD_UD = @CD_UD) > 0 
                Begin	           
	            Select @DS_Mensagem = 'O dente do associado que possui os procedimentos 490,495,730,780,5880,5900,5180,5181 não pode ter mais nenhum tipo de procedimento cadastrado'	           
	            Return @DS_Mensagem
	        End  

       If @CD_UD is Not Null And @TP_Procedimento <> 3 
          If (Select Count(cd_sequencial) 
               From  Consultas 
               Where CD_Associado = @CD_Associado And
                     CD_Sequencial_Dep = @CD_Sequencial_Dep And 
                     CD_Sequencial  <> @ChavePrimaria     And
                     DT_Servico Is Not Null And
                     CD_Servico In (5010,5020,5030) And 
--                     CD_UD = @CD_UD) > 0  And @CD_Servico not in (5040,5906,5015) Alteração pedida pela claudia em 03/02/2006 por email
                     CD_UD = @CD_UD) > 0  And @CD_Servico not in (5040,5906,5015)
                Begin	           
	            Select @DS_Mensagem = 'O dente do associado que possui os procedimentos 5010,5020,5030 só pode ter mais os procedimentos 5040,5906 ou 5015 cadastrado para o mesmo.'	           
	            Return @DS_Mensagem
	        End          

---------------------------------------------------------------------------------------------------------------------------------------
       -- PROCEDIMENTOS INTERNOS e CREDENCIADOS
       If @TP_Procedimento = 1 Or @TP_Procedimento = 2 
         Begin

           -- Procedimentos internos só podem ser feitos na clinica ,portanto não pode ter GUIA. 
           If @TP_Procedimento = 1
             If @NR_Guia Is Not Null
               Begin                  
                  Set @DS_Mensagem = 'Procedimento interno só pode ser feito nas clinicas da ABS.'
                  Return @DS_Mensagem
               End  

           /*If @NR_Guia Is Null
             If @TP_Procedimento = 2
               Begin
                  
                  Set @DS_Mensagem =      'Procedimento que têm GUIA deve ser de CREDENCIADO.'
                  Return
               End  */

          ----------------- Testes Gerais ------------------------------------------------- 
          -- Procedimentos não podem ter dente.
          If @CD_Servico In (130,140,141,142,143,144,150,460,520,560,1189,1190,1191,510,511,530,3010,3013,3015,3020)
                Begin	
	           If @CD_UD Is Not Null   
	             Begin	               
                   Select @DS_Mensagem = 'Procedimento ' + convert(varchar,@CD_Servico) + ' não pode ter dente cadastrado.' 	               
	               Return @DS_Mensagem
	             End  
                End 

          -- Procedimentos têm que ter dente.
          If @CD_Servico In (220,490,495,500,2120,2150,3050,4140,4160,4470,4490,4520,4530,4540,4550,4610,5902,620,630,720,1030,1187,730,910,920,930,940,980,1060,1120,2010,2011,2012,2013,2140,3110,3140,4400,5010,5020,5030,5040,5050,5180,5181,5310)
                Begin	
	           If @CD_UD Is Null   
	             Begin	               
                   Select @DS_Mensagem = 'Procedimento ' + convert(varchar,@CD_Servico) + ' têm que ter dente cadastrado.' 	               
	               Return @DS_Mensagem
	             End  
                End 

          -- Procedimento 100 - exame clinico - Têm que ter procedimentos antes do plano.            

/*
          If @CD_Servico = 100 And @Filial <> 426
             Begin
                If (select count(cd_sequencial)
                     from consultas 
                     where  cd_Filial         = 657 And 
                            CD_Associado      = @CD_Associado And
	                    CD_Sequencial_Dep = @CD_Sequencial_Dep) = 0 
                  Begin                    
                    Set @DS_Mensagem =      'Para cadastrar exame clinico é necessário que exista procedimentos antes do plano cadastrado.'
                    Return @DS_Mensagem
                  End  
	      End 
*/

          ----------------- Testes que têm haver com tempo e idade ----------------------------

           If (@CD_UD In (16,26,36,46) And DateDiff(Month,@DT_inicial,@DT_Atual) < 6) 
               Begin                  
                  Select @DS_Mensagem = 'Procedimento ' + convert(varchar,@CD_Servico) + ' não pode ser realizado com usuario antes dos 6 anos de idade.'                  
                  Return @DS_Mensagem
                End          

          If (@CD_UD In (17,27,37,47) And DateDiff(Month,@DT_inicial,@DT_Atual) < 12) 
               Begin                  
                  Select @DS_Mensagem = 'Procedimento ' + convert(varchar,@CD_Servico) + ' não pode ser realizado com usuario antes dos 12 anos de idade.'                  
                  Return @DS_Mensagem
                End          

           If (@CD_UD In (18,28,38,48) And DateDiff(Month,@DT_inicial,@DT_Atual) < 15)
               Begin                  
                  Select @DS_Mensagem = 'Procedimento ' + convert(varchar,@CD_Servico) + ' não pode ser realizado com usuario antes dos 45 anos de idade.'                  
                  Return @DS_Mensagem
                End     

           -- Procedimentos só podem ser feitos depois de 6 meses no mesmo dente.
           -- Data do ultimo procedimento desse tipo  
           If @CD_Servico in (3050) 
              Begin
	           Select @DT_inicial = Max(IsNull(DT_servico,'01/01/2000'))
	                From  Consultas 
	                Where CD_Associado = @CD_Associado And
	                      CD_Sequencial_Dep = @CD_Sequencial_Dep And 
	                      CD_Servico = @CD_Servico And 
                              DT_Servico Is Not Null and
                              CD_UD = @CD_UD And  
                              CD_Sequencial  <> @ChavePrimaria     

	           If DateDiff(Month,@DT_inicial,@DT_Atual)  < 6 
	             Begin	                
	                Select @DS_Mensagem = 'Procedimento ' + convert(varchar,@CD_Servico) + ' só pode ser feito depois de 6 meses do ultimo procedimento deste tipo realizado. Data do ultimo procedimento :' + Convert(varchar,@DT_Inicial,103) + ', Sequencial : ' + convert(varchar,@ChavePrimaria)	                
	                Return @DS_Mensagem
	             End               	          
              End 

           -- Procedimentos só podem ser feitos depois de 6 meses.
           -- Data do ultimo procedimento desse tipo  
           If @CD_Servico in (130,520,560,100,510,511,530,3010,3012,3013,3015,3020) 
              Begin
	           Select @DT_inicial = Max(IsNull(DT_servico,'01/01/2000'))
	                From  Consultas 
	                Where CD_Associado = @CD_Associado And
	                      CD_Sequencial_Dep = @CD_Sequencial_Dep And 
	                      CD_Servico = @CD_Servico And 
                              DT_Servico Is Not Null and
                              CD_Sequencial  <> @ChavePrimaria     

-- 1492 - Dra Ana Érica Vale (1492) de Teresina. Só faz exame Clinico
	           If DateDiff(Month,@DT_inicial,@DT_Atual)  < 6 and @CD_Funcionario <> 1492
	             Begin	                
	                Select @DS_Mensagem = 'Procedimento ' + convert(varchar,@CD_Servico) + ' só pode ser feito depois de 6 meses do ultimo procedimento deste tipo realizado. Data do ultimo procedimento :' + Convert(varchar,@DT_Inicial,103) + ', Sequencial : ' + convert(varchar,@ChavePrimaria)	                
	                Return @DS_Mensagem
	             End               	          
              End 

           -- Procedimentos só podem ser feitos depois de 6 meses por ARCADA DENTARIA.
           -- Data do ultimo procedimento desse tipo  
            If @CD_Servico in (3011) 
              Begin
	           Select  @CD_UDServico = Max(IsNull(CD_UD,0)), @DT_inicial = Max(IsNull(DT_servico,'01/01/2000'))
	                From  Consultas 
	                Where CD_Associado = @CD_Associado And
	                      CD_Sequencial_Dep = @CD_Sequencial_Dep And 
                              DT_Servico Is Not Null and
	                      CD_Servico = @CD_Servico
	
	           If DateDiff(Month,@DT_inicial,@DT_Atual)  < 6 
	             Begin
                       If @CD_UD In (Select CD_UD From Tipo_Dente Where TP_TipoDente = 5) And 
                          @CD_UDServico In (Select CD_UD From Tipo_Dente Where TP_TipoDente = 5) 
                         Begin   	                    
  	                       Select @DS_Mensagem = 'Procedimento ' + convert(varchar,@CD_Servico) + ' só pode ser feito depois de 6 meses do ultimo procedimento deste tipo realizado na arcada que está localizada esse dente. Data do ultimo procedimento :' + Convert(varchar,@DT_Inicial,103) + ', Sequencial : ' + convert(varchar,@ChavePrimaria)	                    
	                       Return @DS_Mensagem
                          End          
                       If @CD_UD In (Select CD_UD From Tipo_Dente Where TP_TipoDente = 6) And 
                          @CD_UDServico In (Select CD_UD From Tipo_Dente Where TP_TipoDente = 6) 
                         Begin   	                    
  	                       Select @DS_Mensagem = 'Procedimento ' + convert(varchar,@CD_Servico) + ' só pode ser feito depois de 6 meses do ultimo procedimento deste tipo realizado na arcada que está localizada esse dente. Data do ultimo procedimento :' + Convert(varchar,@DT_Inicial,103) + ', Sequencial : ' + convert(varchar,@ChavePrimaria)	                    
	                       Return @DS_Mensagem
                         End  
                       If @CD_UD In (Select CD_UD From Tipo_Dente Where TP_TipoDente = 7) And 
                          @CD_UDServico In (Select CD_UD From Tipo_Dente Where TP_TipoDente = 7) 
                         Begin   	                    
    	                    Select @DS_Mensagem = 'Procedimento ' + convert(varchar,@CD_Servico) + ' só pode ser feito depois de 6 meses do ultimo procedimento deste tipo realizado na arcada que está localizada esse dente. Data do ultimo procedimento :' + Convert(varchar,@DT_Inicial,103) + ', Sequencial : ' + convert(varchar,@ChavePrimaria)	                    
	                        Return @DS_Mensagem
                         End          
                       If @CD_UD In (Select CD_UD From Tipo_Dente Where TP_TipoDente = 8) And 
                          @CD_UDServico In (Select CD_UD From Tipo_Dente Where TP_TipoDente = 8) 
                         Begin   	                    
  	                        Select @DS_Mensagem = 'Procedimento ' + convert(varchar,@CD_Servico) + ' só pode ser feito depois de 6 meses do ultimo procedimento deste tipo realizado na arcada que está localizada esse dente. Data do ultimo procedimento :' + Convert(varchar,@DT_Inicial,103) + ', Sequencial : ' + convert(varchar,@ChavePrimaria)	                    
	                        Return @DS_Mensagem
                         End  
                     End 
              End 

           -- Procedimentos só podem ser feitos depois de 6 meses por ARCADA DENTARIA. (Superior ou Inferior)
           -- Data do ultimo procedimento desse tipo  
            If @CD_Servico in (3012) 
              Begin
	           Select  @CD_UDServico = Max(CD_UD), @DT_inicial = Max(IsNull(DT_servico,'01/01/2000'))
	                From  Consultas 
	                Where CD_Associado = @CD_Associado And
	                      CD_Sequencial_Dep = @CD_Sequencial_Dep And 
	                      CD_Servico = @CD_Servico And 
                              DT_Servico Is Not Null and
                              CD_Sequencial <> @ChavePrimaria 
	
	           If DateDiff(Month,@DT_inicial,@DT_Atual)  < 6 
	             Begin
                       If (@CD_UD In (Select CD_UD From Tipo_Dente Where TP_TipoDente = 5) Or @CD_UD In (Select CD_UD From Tipo_Dente Where TP_TipoDente = 6)) And 
                          (@CD_UDServico In (Select CD_UD From Tipo_Dente Where TP_TipoDente = 5) Or @CD_UDServico In (Select CD_UD From Tipo_Dente Where TP_TipoDente = 6)) 
                         Begin   	                    
  	                       Select @DS_Mensagem = 'Procedimento ' + convert(varchar,@CD_Servico) + ' só pode ser feito depois de 6 meses do ultimo procedimento deste tipo realizado na arcada que está localizada esse dente. Data do ultimo procedimento :' + Convert(varchar,@DT_Inicial,103) + ', Sequencial : ' + convert(varchar,@ChavePrimaria)	                    
	                       Return @DS_Mensagem
                         End      
                       If (@CD_UD In (Select CD_UD From Tipo_Dente Where TP_TipoDente = 7) Or @CD_UD In (Select CD_UD From Tipo_Dente Where TP_TipoDente = 7)) And 
                          (@CD_UDServico In (Select CD_UD From Tipo_Dente Where TP_TipoDente = 8) Or @CD_UDServico In (Select CD_UD From Tipo_Dente Where TP_TipoDente = 8)) 
                         Begin   	                    
    	                    Select @DS_Mensagem = 'Procedimento ' + convert(varchar,@CD_Servico) + ' só pode ser feito depois de 6 meses do ultimo procedimento deste tipo realizado na arcada que está localizada esse dente. Data do ultimo procedimento :' + Convert(varchar,@DT_Inicial,103) + ', Sequencial : ' + convert(varchar,@ChavePrimaria)	                    
	                        Return @DS_Mensagem
                         End      
                     End 
              End 


          -- Procedimento só pode ser feito para a idade entre 2 e 14 anos
           If @CD_Servico in (530,511) 
               -- Se a empresa do associado for as empresas :
               -- Asseduc e Apomi, não verificar idade.
               If (Select Count(CD_Associado)
                   From  Associados
                   Where cd_Empresa In (100942,100539) And 
                         CD_Associado = @CD_Associado) = 0 
                   Begin                          
	              If @WL_Idade < 2 Or @WL_Idade > 15 
        	             Begin		                
		                   Select @DS_Mensagem = 'Procedimento ' + convert(varchar,@CD_Servico) + ' só pode ser feito com associados entre a idade de 2 a 15 anos. Idade do associado : ' + convert(varchar,@WL_Idade)		                
		                   Return @DS_Mensagem
		                 End      
                   End          	           

          -- Procedimento só pode ser feito para a idade entre 4 e 15 anos
           If @CD_Servico in (620,630,720,730) 
              If @WL_Idade < 4 Or @WL_Idade > 15 
	             Begin	                
	                Select @DS_Mensagem = 'Procedimento ' + convert(varchar,@CD_Servico) + ' só pode ser feito com associados entre a idade de 4 a 15 anos. Idade do associado : ' + convert(varchar,@WL_Idade)	                
	                Return @DS_Mensagem
	             End               	           

          -- Procedimento só pode ser feito para a idade de 15 anos ou maior
           If @CD_Servico in (3050,3010,3011,3012,3013,3015,3020,560) 
              If @WL_Idade <= 15 
	             Begin	                
	                Select @DS_Mensagem = 'Procedimento ' + convert(varchar,@CD_Servico) + ' só pode ser feito com associados com idade superior a 15 anos. Idade do associado : ' + convert(varchar,@WL_Idade)	                
	                Return @DS_Mensagem
                  End  

         -- Procedimentos devem ter somente cadastro uma vez para o mesmo dente.
          If @CD_Servico In (490,495,500,3110,3140,4400,5010,5020,5030,5040,5050,5170,5180,5181)
              Begin
	          If (Select count(cd_sequencial)
	                From  Consultas 
	                Where CD_Associado = @CD_Associado And
	                      CD_Sequencial_Dep = @CD_Sequencial_Dep And 
                              DT_Servico Is Not Null And
                              CD_UD = @CD_UD And  
                              CD_Sequencial <> @ChavePrimaria And
	                      CD_Servico = @CD_Servico) > 0  		
  	                Begin	                   
                       Select @DS_Mensagem = 'Procedimento ' + convert(varchar,@CD_Servico) + ' já foi cadastrado para o dente ' + @CD_UD + '. Esse procedimento só pode ser cadastrado uma vez para o mesmo dente.'	                   
	                   Return @DS_Mensagem
	                End               	          
               End 

         -- Procedimentos devem ter somente cadastro uma vez para o mesmo dente e na mesma face.
          If @CD_Servico In (960)
            Begin
              If @Mesial = 1 
                 Begin
	              Select  @DT_inicial = Max(IsNull(DT_servico,'01/01/2000'))
	                  From  Consultas 
	                  Where CD_Associado = @CD_Associado And
	                        CD_Sequencial_Dep = @CD_Sequencial_Dep And 
                                CD_UD = @CD_UD And  
                                CD_Sequencial <> @ChavePrimaria And
   	                        CD_Servico = @CD_Servico And 
                                DT_Servico Is Not Null and
                                CD_Filial  <> 657 And 
                              Mesial = @Mesial 

                          If DateDiff(Month,@DT_inicial,@DT_Atual)  < 12                  
                            Begin   	                      
  	                          Select @DS_Mensagem = 'Procedimento ' + convert(varchar,@CD_Servico) + ' só pode ser feito depois de 1 ano do ultimo procedimento deste tipo realizado nesse dente e nessa mesma face. Data do ultimo procedimento :' + Convert(varchar,@DT_Inicial,103)	                      
	                          Return @DS_Mensagem
                            End  
                  End                                 	          

                If @Oclusal = 1 
                  Begin
	              Select  @DT_inicial = Max(IsNull(DT_servico,'01/01/2000'))
	                  From  Consultas 
	                  Where CD_Associado = @CD_Associado And
	                        CD_Sequencial_Dep = @CD_Sequencial_Dep And 
                                CD_UD = @CD_UD And  
                                CD_Sequencial <> @ChavePrimaria And
   	                        CD_Servico = @CD_Servico And 
                                DT_Servico Is Not Null and
                                CD_Filial  <> 657 And 
                                Oclusal = @Oclusal

                          If DateDiff(Month,@DT_inicial,@DT_Atual)  < 12                  
                            Begin   	                      
  	                           Select @DS_Mensagem = 'Procedimento ' + convert(varchar,@CD_Servico) + ' só pode ser feito depois de 1 ano do ultimo procedimento deste tipo realizado nesse dente e nessa mesma face. Data do ultimo procedimento :' + Convert(varchar,@DT_Inicial,103)	                      
	                           Return @DS_Mensagem
                            End  
                  End                                 	          

                If @Vestibular = 1 
                  Begin
	              Select  @DT_inicial = Max(IsNull(DT_servico,'01/01/2000'))
	                  From  Consultas 
	                  Where CD_Associado = @CD_Associado And
	                        CD_Sequencial_Dep = @CD_Sequencial_Dep And 
                                CD_UD = @CD_UD And  
                                CD_Sequencial <> @ChavePrimaria And
                                DT_Servico Is Not Null and
   	                        CD_Servico = @CD_Servico And 
                                CD_Filial  <> 657 And 
                                Vestibular = @Vestibular

                          If DateDiff(Month,@DT_inicial,@DT_Atual)  < 12                  
                            Begin   	                      
  	                          Select @DS_Mensagem = 'Procedimento ' + convert(varchar,@CD_Servico) + ' só pode ser feito depois de 1 ano do ultimo procedimento deste tipo realizado nesse dente e nessa mesma face. Data do ultimo procedimento :' + Convert(varchar,@DT_Inicial,103)	                      
	                          Return @DS_Mensagem
                            End  
                 End            
                     	          
                If @Lingual = 1 
                 Begin
	              Select  @DT_inicial = Max(IsNull(DT_servico,'01/01/2000'))
	                  From  Consultas 
	                  Where CD_Associado = @CD_Associado And
	                        CD_Sequencial_Dep = @CD_Sequencial_Dep And 
                                CD_UD = @CD_UD And  
                                CD_Sequencial <> @ChavePrimaria And
                                DT_Servico Is Not Null and
   	                        CD_Servico = @CD_Servico And 
                                CD_Filial  <> 657 And 
                                Lingual = @Lingual

                          If DateDiff(Month,@DT_inicial,@DT_Atual)  < 12                  
                            Begin   	                      
    	                      Select @DS_Mensagem = 'Procedimento ' + convert(varchar,@CD_Servico) + ' só pode ser feito depois de 1 ano do ultimo procedimento deste tipo realizado nesse dente e nessa mesma face. Data do ultimo procedimento :' + Convert(varchar,@DT_Inicial,103)	                      
	                          Return @DS_Mensagem
                            End  
                 End            

                If @Distral = 1 
                 Begin
	              Select  @DT_inicial = Max(IsNull(DT_servico,'01/01/2000'))
	                  From  Consultas 
	                  Where CD_Associado = @CD_Associado And
	                        CD_Sequencial_Dep = @CD_Sequencial_Dep And 
                       CD_UD = @CD_UD And  
                                DT_Servico Is Not Null and
                                CD_Sequencial <> @ChavePrimaria And
   	                        CD_Servico = @CD_Servico And 
                                CD_Filial  <> 657 And 
                                Distral = @Distral

                          If DateDiff(Month,@DT_inicial,@DT_Atual)  < 12                  
                            Begin   	                      
  	                          Select @DS_Mensagem = 'Procedimento ' + convert(varchar,@CD_Servico) + ' só pode ser feito depois de 1 ano do ultimo procedimento deste tipo realizado nesse dente e nessa mesma face. Data do ultimo procedimento :' + Convert(varchar,@DT_Inicial,103)	                      
	                          Return @DS_Mensagem
                            End  
                 End            

               End 

        -- Procedimentos que só podem acontecer depois de um ano, excluido-se os que não foram feitos pela ABS.
          If @CD_Servico In (620)
              Begin
	           Select  @DT_inicial = Max(IsNull(DT_servico,dt_pericia))
	                From  Consultas 
	                Where CD_Associado = @CD_Associado And
	                      CD_Sequencial_Dep = @CD_Sequencial_Dep And 
	                      CD_Servico = @CD_Servico And 

                              CD_UD = @CD_UD And  
                              DT_Servico Is Not Null and
                              CD_Filial  <> 657 And 
                              CD_Sequencial <> @ChavePrimaria                    

	           If DateDiff(Month,@DT_inicial,@DT_Atual)  < 12                  
                         Begin   	                    
  	                       Select @DS_Mensagem = 'Procedimento ' + convert(varchar,@CD_Servico) + ' só pode ser feito depois de 1 ano do ultimo procedimento deste tipo realizado nesse dente. Data do ultimo procedimento :' + Convert(varchar,@DT_Inicial,103)	                    
	                       Return @DS_Mensagem
                         End          
              End         


        -- Procedimentos que só podem acontecer depois de um ano, excluido-se os que não foram feitos pela ABS.
          If @CD_Servico In (980,970,620)
              Begin
	           Select  @DT_inicial = Max(IsNull(DT_servico,dt_pericia))
	                From  Consultas 
	                Where CD_Associado = @CD_Associado And
	                      CD_Sequencial_Dep = @CD_Sequencial_Dep And 
	                      CD_Servico = @CD_Servico And 
                              CD_UD = @CD_UD And  
                              DT_Servico Is Not Null and
                              CD_Filial  <> 657 And 
                              CD_Sequencial <> @ChavePrimaria And 
                              (@Vestibular = Vestibular  And @Mesial=Mesial And @Lingual=Lingual And @Distral=Distral)                                	

	           If DateDiff(Month,@DT_inicial,@DT_Atual)  < 12                  
                         Begin   	                    
  	                       Select @DS_Mensagem = 'Procedimento ' + convert(varchar,@CD_Servico) + ' só pode ser feito depois de 1 ano do ultimo procedimento deste tipo realizado nesse dente. Data do ultimo procedimento :' + Convert(varchar,@DT_Inicial,103)	                    
	                       Return @DS_Mensagem
                         End          
              End         

          -- Procedimento só pode ter certas combinações de faces.
          If @CD_Servico In (970)
              Begin	                    
	           If (@Vestibular + @Mesial + @Lingual) <> 3 And (@Vestibular + @Distral + @Lingual) <> 3
	             Begin	               
                   Select @DS_Mensagem = 'Procedimento  ' + convert(varchar,@CD_Servico) + ' só pode ter as seguintes combinações de faces : VML ou VDL.' 	               
	               Return @DS_Mensagem
	             End  
               End        

          ----------------- Testes especificos por serviço e procedimentos relacionados ----------------------------
          -- olhar dt_servico >= 01/05/2006
          If @Filial = 1                
            If @DT_Servico Is Not Null 
               If Month(@DT_Servico) >= 5 And  Year(@DT_Servico) >= 2006      
                 If @CD_Servico In (2150)
                   Begin

                         -- 1) só pode lançar o 2150 se tiver os codigos 2010,2011,2012,2013 (pendentes data_servico is null) para o mesmo dente
                         If (Select count(cd_sequencial)
	                    From  Consultas 
	                    Where CD_Associado      = @CD_Associado And
	                          CD_Sequencial_Dep = @CD_Sequencial_Dep And 
                              CD_UD             = @CD_UD And  
                              DT_Servico        Is  Null and
                              CD_Sequencial <> @ChavePrimaria And
	                          CD_Servico In (2010,2011,2012,2013,2160,2161,2162)) = 0 		
  	                    Begin	                      
                              Select @DS_Mensagem = 'Procedimento ' + convert(varchar,@CD_Servico) + ' não pode ser feito nesse dente do associado, pois esse dente precisaria ter algum dos procedimentos 2010,2011,2012,2013,2160,2161,2162 cadastrados como pendentes anteriormente.'	                      
	                          Return @DS_Mensagem
                            End     

                         Select @NR_Quantidade = count(cd_sequencial)
	                    From  Consultas 
	                    Where CD_Associado      = @CD_Associado And
	                          CD_Sequencial_Dep = @CD_Sequencial_Dep And 
                                  CD_UD             = @CD_UD And  
                                  DT_Servico        Is Not Null and
                                  DT_Servico        >= '05/01/2006' And
                                  CD_Sequencial <> @ChavePrimaria And
	                          CD_Servico In (2150)

                        -- 2) se têm pendente o 2010 or 2011 só pode ter um 2150 no mesmo dente.
                        If (Select count(cd_sequencial)
	                     From  Consultas 
	                     Where CD_Associado      = @CD_Associado And
	                           CD_Sequencial_Dep = @CD_Sequencial_Dep And 
                               CD_UD             = @CD_UD And  
                               DT_Servico        Is  Null and
                               CD_Sequencial <> @ChavePrimaria And
	                           CD_Servico In (2010,2011)) > 0 And  @NR_Quantidade > 1		 
    	                     Begin	                           
                               Select @DS_Mensagem = 'Procedimento ' + convert(varchar,@CD_Servico) + ' não pode ser feito nesse dente do associado, pois esse procedimento só pode ser feito uma vez para os procedimentos pendentes 2010,2011.' 	                           
                               Return @DS_Mensagem
                             End  

                        -- 3) se têm pendente o 2012,2013 só pode ter dois 2150 no mesmo dente.
                        If (Select count(cd_sequencial)
	                     From  Consultas 
	                     Where CD_Associado      = @CD_Associado And
	                           CD_Sequencial_Dep = @CD_Sequencial_Dep And 
                                   CD_UD             = @CD_UD And  
                                   DT_Servico        Is  Null and
                                   CD_Sequencial <> @ChavePrimaria And
	                  CD_Servico In (2012,2013)) > 0 And  @NR_Quantidade > 2		 
    	                     Begin	                       
                               Select @DS_Mensagem = 'Procedimento ' + convert(varchar,@CD_Servico) + ' não pode ser feito nesse dente do associado, pois esse procedimento só pode ser feito uma vez para os procedimentos pendentes 2012,2013.' 	                       
                               Return @DS_Mensagem
                             End  

                  End                 

          -- Procedimentos que já foram feitos em um determinado dente, só podem fazer outros procedimentos
          If @CD_Servico In (620,630)
              Begin
	           If (Select count(cd_sequencial)
	                From  Consultas 
	                Where CD_Associado = @CD_Associado And
	                      CD_Sequencial_Dep = @CD_Sequencial_Dep And 
                              DT_Servico is not null and
                              CD_UD = @CD_UD And  
                              CD_Sequencial <> @ChavePrimaria And
	                      CD_Servico In (620,630)) > 0 		
  	                Begin	                   
                         Select @DS_Mensagem = 'Procedimento ' + convert(varchar,@CD_Servico) + ' não pode ser feito nesse dente do associado, pois já foi feito o procedimento 630 ou 620 que impede esse cadastro.'	                   
	                     Return @DS_Mensagem
	                End               	          
               End 

          -- Procedimentos que já foram feitos em um determinado dente, só podem fazer outros procedimentos
          If @CD_Servico In (3010)
              Begin
	           If (Select count(cd_sequencial)
	                From  Consultas 
	                Where CD_Associado = @CD_Associado And
	                      CD_Sequencial_Dep = @CD_Sequencial_Dep And 
                              CD_UD = @CD_UD And  
                              DT_Servico Is Not Null and
                              CD_Sequencial <> @ChavePrimaria And
	                      CD_Servico In (3015,3020)) > 0 		
  	                Begin	                   
                           Select @DS_Mensagem = 'Procedimento ' + convert(varchar,@CD_Servico) + ' não pode ser feito nesse dente do associado, pois já foi feito o procedimento 3015 ou 3020 que impede esse cadastro.'	                   
	                       Return @DS_Mensagem
	                End               	          
               End 

          -- Procedimento não pode ser feito , se outros tiverem sido feitos no dente. 
          If @CD_Servico In (3110,3140)
              Begin
	           If (Select count(cd_sequencial)
	                From  Consultas 
	                Where CD_Associado = @CD_Associado And
	                      CD_Sequencial_Dep = @CD_Sequencial_Dep And 
                              CD_UD = @CD_UD And  
                              DT_Servico Is Not Null and
                              CD_Sequencial <> @ChavePrimaria And
	                      CD_Servico In (2010,2011,2012,2013)) > 1 		
  	                Begin	                   
                       Select @DS_Mensagem = 'Procedimento ' + convert(varchar,@CD_Servico) + ' não pode ser feito nesse dente do associado, pois esse dente já têm algum dos procedimentos 2010,2011,2012,2013 cadastrados anteriormente.'	                   
	                   Return @DS_Mensagem
	                End               	          
               End 

          -- Procedimento que só pode ser feito , se outros tiverem sido feitos no dente. (DEVE TER EXODONTIA)
          If @CD_Servico In (5110,5120,5140,5160,5906)
              Begin
	           If (Select count(cd_sequencial)
	                From  Consultas 
	             Where CD_Associado = @CD_Associado And
	                      CD_Sequencial_Dep = @CD_Sequencial_Dep And 
                              CD_UD = @CD_UD And  
                              DT_Servico Is Not Null and
                              CD_Sequencial <> @ChavePrimaria And
	                      CD_Servico In (2010,2011,2012,2013,720)) = 0 		
  	                Begin	                   
                        Select @DS_Mensagem = 'Procedimento ' + convert(varchar,@CD_Servico) + ' não pode ser feito nesse dente do associado, pois esse dente precisaria ter algum dos procedimentos 2010,2011,2012,2013,720 cadastrados anteriormente.'	                   
	                    Return @DS_Mensagem
	                End               	          
               End 

          -- Procedimento que só pode ser feito , se outros tiverem sido feitos no dente. 
          If @CD_Servico In (4400)
              Begin
	           If (Select count(cd_sequencial)
	                From  Consultas 
	                Where CD_Associado = @CD_Associado And
	                      CD_Sequencial_Dep = @CD_Sequencial_Dep And 
                              CD_UD = @CD_UD And  
                              DT_Servico Is Not Null and
                              CD_Sequencial <> @ChavePrimaria And
	                      CD_Servico In (4120,4140,4160,4040,4090,4100,4130,4190,4200,4210,4220,4230)) = 0 		
  	                Begin	                   
                       Select @DS_Mensagem = 'Procedimento ' + convert(varchar,@CD_Servico) + ' não pode ser feito nesse dente do associado, pois esse dente precisaria ter algum dos procedimentos 4140,4120,4160,4040,4090,4100,4130,4190,4200,4210,4220,4230 cadastrados anteriormente.'	                   
	                   Return @DS_Mensagem
	                End               	          
               End 

          -- Procedimento que só pode ser feito , se outros tiverem sido feitos no dente. 
          If @CD_Servico In (5040)
              Begin
	           If (Select count(cd_sequencial)
	                From  Consultas 
	                Where CD_Associado = @CD_Associado And
	                      CD_Sequencial_Dep = @CD_Sequencial_Dep And 
                              CD_UD = @CD_UD And  
                              DT_Servico Is Not Null and
                              CD_Sequencial <> @ChavePrimaria And
	                      CD_Servico In (5010,5020,5030)) = 0 		
  	                Begin	                   
                       Select @DS_Mensagem = 'Procedimento ' + convert(varchar,@CD_Servico) + ' não pode ser feito nesse dente do associado, pois esse dente precisaria ter algum dos procedimentos 5010,5020,5030 cadastrados anteriormente.'	                   
	                   Return @DS_Mensagem
	                End               	          
               End 

          -- Procedimentos que já foram feitos em um determinado dente, só podem fazer outros procedimentos
      If @CD_Servico In (3015)
              Begin
	           If (Select count(cd_sequencial)
	                From  Consultas 
	                Where CD_Associado = @CD_Associado And
	                      CD_Sequencial_Dep = @CD_Sequencial_Dep And 
                              CD_UD = @CD_UD And  
                              DT_Servico Is Not Null and
                              CD_Sequencial <> @ChavePrimaria And
	                      CD_Servico In (3020)) > 0 		
  	                Begin	                   
                       Select @DS_Mensagem = 'Procedimento ' + convert(varchar,@CD_Servico) + ' não pode ser feito nesse dente do associado, pois já foi feito o procedimento 3020 que impede esse cadastro.'	                   
	                   Return @DS_Mensagem
	                End               	          
               End 

        -- Esses procedimentos só podem ser cadastrados se não existirem procedimentos feitos para 
        -- o mesmo dente.%%%
        If @CD_Servico In (910,920,930,940,960,970,980,620,1120)
               Begin
                   If (Select count(cd_sequencial)
	                From  Consultas 
	                Where     CD_Associado = @CD_Associado And
	                          CD_Sequencial_Dep = @CD_Sequencial_Dep And 
                              CD_UD = @CD_UD And  
                              DT_Servico Is Not Null and
                              CD_Sequencial <> @ChavePrimaria And
	                      CD_Servico In (4090,4100,4120,4130,4140,4160,4180,4190,4200,4210,4220,4230,4400,4550,4580,4590,4610,4660)) > 0 		
  	                Begin	                   
                       Select @DS_Mensagem = 'Procedimento ' + convert(varchar,@CD_Servico) + ' não pode ser feito quando determinados procedimentos (4090,4100,4120,4130,4140,4160,4180,4190,4200,4210,4220,4230,4400,4550,4580,4590,4610,4660) já tenha sido cadastrado para esse dente.'	                   
	                   Return @DS_Mensagem
	                End  
               End

          ----------------- Testes especificos por serviço e dentes relacionados ----------------------------

          -- Procedimento só pode ser feito em dentes anteriores.
          If @CD_Servico In (1187,960,970,980)         
            If @CD_UD Not In (Select CD_UD From Tipo_Dente Where TP_TipoDente = 1)
  	                Begin	                   
                       Select @DS_Mensagem = 'Procedimento  ' + convert(varchar,@CD_Servico) + ' só pode ser feito em Dentes Anteriores.' 	                   
	                   Return @DS_Mensagem
	                End            	          

          -- Procedimento só pode ser feito em dentes posteriores.
          If @CD_Servico In (620)
            If @CD_UD Not In (Select CD_UD From Tipo_Dente Where TP_TipoDente = 2)
  	                Begin	                   
                       Select @DS_Mensagem = 'Procedimento ' + convert(varchar,@CD_Servico) + ' só pode ser feito em Dentes Posteriores.'	                   
	                   Return @DS_Mensagem
	                End            	          

          -- O procedimento abaixo não podem ser feito em dente de leite.
          If @CD_Servico In (5010,5030,5880)
            If @CD_UD In (Select CD_UD From Tipo_Dente Where TP_TipoDente = 4)
  	                Begin	                   
                       Select @DS_Mensagem = 'Procedimento ' + convert(varchar,@CD_Servico) + ' não pode ser realizado em Dentes de Leite. Dentes de leite : 51 a 55,61 a 65, 71 a 75, 81 a 85.' 	                   
	                   Return @DS_Mensagem
	                End  
           
          -- O procedimento 720 só pode ser feito em dentes de leite.
    If @CD_Servico In (720,730)
            If @CD_UD Not In (Select CD_UD From Tipo_Dente Where TP_TipoDente = 4)
  	                Begin	                   
                       Select @DS_Mensagem = 'Procedimento ' + convert(varchar,@CD_Servico) + ' só pode ser realizado em Dentes de Leite. Dentes de leite : 51 a 55,61 a 65, 71 a 75, 81 a 85.' 	                   
	                   Return @DS_Mensagem
	                End  

          -- O procedimento  só pode ser feito em dentes de leite.
          If @CD_Servico In (940)
            If @CD_UD In (Select CD_UD From Tipo_Dente Where TP_TipoDente = 4)
  	                Begin	                   
                       Select @DS_Mensagem = 'Procedimento ' + convert(varchar,@CD_Servico) + ' não pode ser realizado em Dentes de Leite. Dentes de leite : 51 a 55,61 a 65, 71 a 75, 81 a 85.' 	                   
	                   Return @DS_Mensagem
	                End            	          

          -- Procedimento só pode ser feito em dentes posteriores que estão definidos abaixo.
          If @CD_Servico In (940)
            If @CD_UD Not In (18,28,38,48,55,54,65,64,74,75,84,85) 
               If @CD_UD Not In (Select CD_UD From Tipo_Dente Where TP_TipoDente = 2)        
  	                Begin	                   
                       Select @DS_Mensagem =  'Procedimento ' + convert(varchar,@CD_Servico) + ' só pode ser feito em Dentes Posteriores e nos dentes 18,28,38,48,55,54,65,64,74,75,84,85. ' 	                   
	                   Return @DS_Mensagem
	                End      


          If @CD_Servico In (910,920,930)   
            If @CD_UD Not In (18,28,38,48,55,54,65,64,74,75,84,85,45,44) 
               If @CD_UD Not In (Select CD_UD From Tipo_Dente Where TP_TipoDente = 2)        
                  If @CD_UD Not In (Select CD_UD From Tipo_Dente Where TP_TipoDente = 4)        
  	                Begin	                   
                        Select @DS_Mensagem =  'Procedimento ' + convert(varchar,@CD_Servico) + ' só pode ser feito em Dentes Posteriores, Dentes de leite e nos dentes 18,28,38,48,55,54,65,64,74,75,84,85,45,44. ' 	                   
	                    Return @DS_Mensagem
	                End      

          -- Procedimento só pode ser feito nos dentes determinados abaixo.
          If @CD_Servico In (2013)
            Begin
                If @CD_UD Not In (16,17,18,26,27,28,36,37,38,46,47,48)
	                Begin	                   
                       Select @DS_Mensagem = 'Procedimento ' + convert(varchar,@CD_Servico) + ' só pode ser feito nos Dentes : 16,17,18,26,27,28,36,37,38,46,47,48' 	                   
	                   Return @DS_Mensagem
	                End  
            End 

          -- Procedimento só pode ser feito em dentes anteriores.       
          If @CD_Servico In (2010)         
            Begin 
                If (@CD_UD Not In (Select CD_UD From Tipo_Dente Where TP_TipoDente = 1)) And (@CD_UD In (13,12,11,21,22,23,31,32,31,41,42,43))
  	                Begin	                   
                       Select @DS_Mensagem = 'Procedimento  ' + convert(varchar,@CD_Servico) + ' só pode ser feito em Dentes Anteriores ou nos dentes 13,12,11,21,22,23,31,32,31,41,42,43.' 	                   
	                   Return @DS_Mensagem
	                End                   
             End 

            -- Procedimento não pode ser feito mais de uma vez para o mesmo dente.
            -- Pedido por Cássio em 27/11/2007
            If @CD_Servico In (2010,2011,2012,2013)   
              Begin
                If (Select count(cd_sequencial)
                    From  Consultas
                    Where CD_Associado = @CD_Associado And
	                      CD_Sequencial_Dep = @CD_Sequencial_Dep And 
                          CD_UD = @CD_UD And  
                          DT_Servico is not Null And
                          DT_Cancelamento is Null And
                          CD_Servico In (2010,2011,2012,2013)) >= 1 
                     Begin	                     
                         Select @DS_Mensagem = 'Procedimentos  2010,2011,2012,2013 só podem ser feitos uma única vez em um dente.' 	                     
	                     Return @DS_Mensagem
	                End             
             End                    

          ----------------- Testes especificos por serviço e faces relacionados ----------------------------

           -- Procedimentos que não podem ter FACE
          If @CD_Servico In (1189,1190,1191,2120,2150,2140,2013)
                Begin	
	           If (@Mesial + @Oclusal + @Vestibular + @Lingual + @Distral) <> 0
	             Begin	         
                     Select @DS_Mensagem = 'Procedimento  ' + convert(varchar,@CD_Servico) + ' não pode ter face cadastrada.' 	               
	                 Return @DS_Mensagem
	             End  
                End 

          -- Procedimento têm que ter face cadastrada.
          If @CD_Servico In (910,920,930,940,970,980) --960
              Begin	
	           If (@Mesial + @Vestibular + @Lingual + @Distral + @Oclusal) = 0
	             Begin	               
                     Select @DS_Mensagem = 'Procedimento  ' + convert(varchar,@CD_Servico) + ' têm que ter FACE cadastrada.' 	               
	                 Return @DS_Mensagem
	             End  
               End     

          -- O procedimento só pode ser feito face (0) OCLUSAL
          If @CD_Servico In (1030,620)
              Begin	
	           If (@Mesial <> 0  Or @Vestibular <> 0 Or @Lingual <> 0 Or @Distral <> 0)
	             Begin	               
                   Select @DS_Mensagem = 'Procedimento  ' + convert(varchar,@CD_Servico) + ' só pode ser feito na face (0) OCLUSAL' 	               
	               Return @DS_Mensagem
	             End  
               End 

          -- Procedimento só pode ser feito nos dentes determinados abaixo.
          If @CD_Servico In (2011)
            Begin
                If @CD_UD Not In (14,15,24,25,34,35,44,45)
	                Begin	                   
                       Select @DS_Mensagem = 'Procedimento ' + convert(varchar,@CD_Servico) + ' só pode ser feito nos Dentes : 14,15,24,25,34,35,44,45' 	                   
	                   Return @DS_Mensagem
	                End  

/*                If @CD_UD In (17,18,28,38,48)
                   If (@Mesial + @Vestibular + @Lingual + @Distral + @Oclusal) <> 0 
	                Begin
	                   
                           Select @DS_Mensagem = 'Procedimento ' + convert(varchar,@CD_Servico) + ' não pode ter face cadastrada para os dentes : 17,18,28,38,48' 
	                   
	                   Return
	                End  */
            End 

          -- Procedimento só pode ser feito nos dentes determinados abaixo.
          If @CD_Servico In (2012)
            Begin
                If @CD_UD Not In (16,17,18,26,27,28,36,37,38,46,47,48)
	                Begin	                   
                       Select @DS_Mensagem = 'Procedimento ' + convert(varchar,@CD_Servico) + ' só pode ser feito nos Dentes : 16,17,18,26,27,28,36,37,38,46,47,48' 	                   
	                   Return @DS_Mensagem
	                End  

/*                If @CD_UD In (17,18,28,38,48)
                   If (@Mesial + @Vestibular + @Lingual + @Distral + @Oclusal) <> 0 
	                Begin
	                   
                           Select @DS_Mensagem = 'Procedimento ' + convert(varchar,@CD_Servico) + ' não pode ter face cadastrada para os dentes : 18,28,38,48' 
	                   
	                   Return
	                End  */
            End 
        
          -- Procedimento só pode ter uma face.       	          
          If @CD_Servico In (910) --,960
              Begin	
	           If (@Mesial + @Vestibular + @Lingual + @Distral + @Oclusal) <> 1
	             Begin	               
                     Select @DS_Mensagem = 'Procedimento  ' + convert(varchar,@CD_Servico) + ' só pode ser feito em uma face.' 	               
	                 Return @DS_Mensagem
	             End  
               End     

          -- Procedimento só pode ter duas faces.       	          
          If @CD_Servico In (920)
              Begin	
	           If (@Mesial + @Vestibular + @Lingual + @Distral + @Oclusal) <> 2
	             Begin	               
                    Select @DS_Mensagem = 'Procedimento  ' + convert(varchar,@CD_Servico) + ' só pode ser feito duas faces.' 	               
	                Return @DS_Mensagem
	             End  
               End     

          -- Procedimento só pode ter três faces.       	          
          If @CD_Servico In (930,970)
              Begin	
	           If (@Mesial + @Vestibular + @Lingual + @Distral + @Oclusal) <> 3
	             Begin	               
                    Select @DS_Mensagem = 'Procedimento  ' + convert(varchar,@CD_Servico) + ' só pode ser feito três faces.' 	               
	                Return @DS_Mensagem
	             End  
               End     

          -- Procedimento só pode ter quatro faces.       	          
          If @CD_Servico In (940)
              Begin	
	           If (@Mesial + @Vestibular + @Lingual + @Distral + @Oclusal) <> 4
	             Begin	               
                     Select @DS_Mensagem = 'Procedimento  ' + convert(varchar,@CD_Servico) + ' só pode ser feito quatro faces.' 	               
	                 Return @DS_Mensagem
	             End  
               End     
      

          -- O procedimento só pode ser feito face M ou D.
          If @CD_Servico In (980)
              Begin	
	           If (@Vestibular <> 0 Or @Lingual <> 0 Or @Oclusal <> 0)
	             Begin	               
                    Select @DS_Mensagem = 'Procedimento  ' + convert(varchar,@CD_Servico) + ' só pode ser feito nas faces M ou D' 	               
	                Return @DS_Mensagem
	             End  
               End 

          -- O procedimento só pode ser feito face V. -- Qualquer face. Pedida por claudia em 13/02/2006
/*          If @CD_Servico In (1060)
              Begin	
	           If (@Mesial <> 0 Or @Oclusal <> 0 Or @Lingual <> 0 Or @Distral <> 0)
	             Begin
	               
                       Select @DS_Mensagem = 'Procedimento  ' + convert(varchar,@CD_Servico) + ' só pode ser feito na face V' 
	               
	               Return

	             End  
               End */

          -- O procedimento só pode ser feito face L.
/*          If @CD_Servico In (1060)
              Begin	
	           If (@Mesial <> 0 Or @Oclusal <> 0 Or @Vestibular <> 0 Or @Distral <> 0)
	             Begin
	               
                       Select @DS_Mensagem = 'Procedimento  ' + convert(varchar,@CD_Servico) + ' só pode ser feito na face L' 
	               
	               Return
	             End  
               End */

         End   

---------------------------------------------------------------------------------------------------------------------------------------         
        -- Testes para procedimentos INATIVOS.    
       If @TP_Procedimento = 5
          Begin             
             Set @DS_Mensagem =      'Procedimento inativo não pode ser cadastrado.'
             Return @DS_Mensagem
          End       
---------------------------------------------------------------------------------------------------------------------------------------         

   Return @DS_Mensagem
      
End
