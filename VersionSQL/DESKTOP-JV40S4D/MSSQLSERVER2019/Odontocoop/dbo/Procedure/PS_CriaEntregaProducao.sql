/****** Object:  Procedure [dbo].[PS_CriaEntregaProducao]    Committed by VersionSQL https://www.versionsql.com ******/

/*
Objetivo : Criar lista de dentistas credenciados para receber produção dos mesmos
           Faço isso logo para um ano inteiro.
           Caso tenha alguma mudança de credenciamento vai haver uma atualização na tela de recebimento da produção.
grupos:
Ceara - 5  -  grupo  3
--************************
Maranhao - 9 - grupo 2
Rn - 19
--************************
Pará - 13 grupo 1
Bahia - 4  
Piaui - 16
--************************
*/
CREATE Procedure [dbo].[PS_CriaEntregaProducao](
                    @Grupo smallint,
                    @Data varchar(6)) --Mes/Ano)
As
Begin

   Declare @Data_Atual DateTime
   Declare @I Int
   Declare @cd_grupo smallint
   Declare @SequencialGrupoLotePagamento int
   Declare @CD_Funcionario int
   Declare @CD_Filial int

   Set @Data_Atual = GetDate()

   --Caso haja parametos gerar somente para o grupo e ano 
   If @Grupo <> 0 
      Begin

        Select @SequencialGrupoLotePagamento = Sequencial_GrupoLotePagamento  
             From TB_Grupo_Lote_Pagamento  
             Where cd_grupo = @grupo

         /*Delete From TB_Grupo_Lote_Pagamento_Dentista
            Where Sequencial_GrupoLotePagamento =@SequencialGrupoLotePagamento And
                   Mes_Ano_Entrega = @Data                  */
         
         Declare  Dados_Cursor2  Cursor For     
		 Select t1.cd_funcionario, t2.cd_filial
		 From  funcionario t1, atuacao_dentista_new t2, filial t3
		 Where t2.fl_ativo = 1 and
			  T2.dia_semana       Is Not Null And 
			  T2.qt_tempo_atend   Is Not Null And 
			  t1.cd_funcionario = t2.cd_funcionario And
			  t2.cd_filial  = t3.cd_filial     And
			  T3.fl_inativa = 0                 And
			  t3.cd_clinica = 2                And 
			  t1.cd_grupo   = @grupo     
		 Group by t1.cd_funcionario, t2.cd_filial        

         Open Dados_Cursor2
		 Fetch next from Dados_Cursor2
		 Into  @CD_Funcionario,@CD_Filial

		 While (@@fetch_status  <> -1)
		  Begin                                 													
              if (Select count(*) from TB_Grupo_Lote_Pagamento_Dentista
                          Where cd_funcionario = @CD_Funcionario And
                                CD_FILIAL      = @CD_FILIAL AND
                                Sequencial_GrupoLotePagamento = @SequencialGrupoLotePagamento And
                                Mes_Ano_Entrega =   @Data) = 0
                Begin
			        Insert Into  TB_Grupo_Lote_Pagamento_Dentista
			        Values (@CD_Funcionario, @Data,null, @SequencialGrupoLotePagamento,@CD_Filial,null)
                End  

				Fetch next from Dados_Cursor2
				Into  @CD_Funcionario,@CD_Filial
		  End  
		  close Dados_Cursor2
		  Deallocate Dados_Cursor2        
      End
--   Else
--      Begin
--		   --Gerar uma ano inteiro.
--	   If Month(@Data_Atual) = 12 
--			Begin
--
--			 /*Grupos e data de pagamento*/
--			 Declare  Dados_Cursor1  Cursor For     
--			 Select cd_grupo, Sequencial_GrupoLotePagamento  
--				from TB_Grupo_Lote_Pagamento
--				order by cd_grupo
--
--			Open Dados_Cursor1
--			  Fetch next from Dados_Cursor1
--			  Into  @CD_Grupo , @SequencialGrupoLotePagamento
--
--			While (@@fetch_status  <> -1)
--			  Begin  
--		      
--				 Declare  Dados_Cursor2  Cursor For     
--				 Select t1.cd_funcionario, t2.cd_filial
--				 From  funcionario t1, atuacao_dentista_new t2, filial t3
--				 Where t2.fl_ativo = 1 and
--					  T2.dia_semana       Is Not Null And 
--					  T2.qt_tempo_atend   Is Not Null And 
--					  t1.cd_funcionario = t2.cd_funcionario And
--					  t2.cd_filial = t3.cd_filial And
--					  T3.fl_inativa=0  and
--					  t3.cd_clinica =2 and 
--					  t1.cd_grupo = @cd_grupo     
--				 Group by t1.cd_funcionario, t2.cd_filial        
--
--				 Open Dados_Cursor2
--				 Fetch next from Dados_Cursor2
--				 Into  @CD_Funcionario,@CD_Filial
--
--				 While (@@fetch_status  <> -1)
--				  Begin  
--
--						/*Criar registro para receber produção para o proximo ano inteiro*/       
--						Set @I = 9
--						While @I <= 12
--						  Begin
--							Insert Into  TB_Grupo_Lote_Pagamento_Dentista
--							Values (@CD_Funcionario, right('00' + convert(varchar,@I),2) + convert(varchar,year(@Data_Atual)),null, @SequencialGrupoLotePagamento,@CD_Filial,null)
--
--							Set @I = @I + 1
--				  
--						  End
--
--						Fetch next from Dados_Cursor2
--						Into  @CD_Funcionario,@CD_Filial
--				  End  
--				  close Dados_Cursor2
--				  Deallocate Dados_Cursor2
--		         
--				  Fetch next from Dados_Cursor1
--				  Into  @CD_Grupo , @SequencialGrupoLotePagamento
--			  End 
--			  close Dados_Cursor1
--			  Deallocate Dados_Cursor1
--		   End
--        End
End
