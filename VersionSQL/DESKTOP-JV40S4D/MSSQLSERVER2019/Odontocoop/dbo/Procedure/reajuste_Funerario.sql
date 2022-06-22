/****** Object:  Procedure [dbo].[reajuste_Funerario]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE Procedure [dbo].[reajuste_Funerario]
As
Begin

---------------------------------------------------
--Declaração de Variaveis
---------------------------------------------------
Declare @cdass int
Declare @MESSAGE CHAR(200)
Declare @data datetime
Declare @cd_sequencial Int

---------------------------------------------------
-- Corpo Programa : Regras
---------------------------------------------------

begin transaction

-- Saber se reajuste já foi concedido.
Declare cursor_reajuste cursor for
Select cd_associado,dt_inicio from servicos_opcionais
      Where cd_sop = 14

Open cursor_reajuste
  Fetch next From cursor_reajuste 
    Into @cdass,@data

While (@@fetch_status<>-1)
   Begin
    
          Declare Cursor_Dependentes Cursor For
             Select Dependentes.cd_sequencial 
             From Dependentes , Situacao_historico        
             Where Dependentes.CD_Situacao = Situacao_Historico.CD_Situacao_Historico And
                   Situacao_historico.FL_Gera_Cobranca = 1 And
                   Dependentes.CD_Sequencial > 1   And
                   Dependentes.CD_Associado = @cdass
        
             Open Cursor_Dependentes
               Fetch next From Cursor_Dependentes 
               Into @cd_sequencial

             While (@@fetch_status<>-1) -- 3º CURSOR.
                Begin
   	                 Insert Into servicos_opcionais 
                        (CD_ASSOCIADO,CD_SOP,DT_INICIO,DT_FIM,VL_SERVICO,
                         CD_SEQUENCIAL,cd_usuario,dt_usuario,cd_funcionario,
                         vl_perc_comissao,fl_fatura,fl_incorpora, cd_situacao,cd_sequencial_dep)
	                     Select @cdass,14,@data,'01/01/2099',0,max(cd_sequencial)+1,
                         'SYS',getdate(),null,0,0,1,1,@cd_sequencial
                         From Servicos_Opcionais        

                     Fetch next From Cursor_Dependentes 
                     Into @cd_sequencial
                End             
                Close Cursor_Dependentes
                Deallocate Cursor_Dependentes        

                 Fetch next From cursor_reajuste 
                 Into @cdass,@data

   End                                            
   Close cursor_reajuste
   Deallocate cursor_reajuste        

   Commit Transaction

End
