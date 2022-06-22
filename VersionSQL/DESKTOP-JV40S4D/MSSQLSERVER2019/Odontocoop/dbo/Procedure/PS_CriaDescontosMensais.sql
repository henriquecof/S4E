/****** Object:  Procedure [dbo].[PS_CriaDescontosMensais]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE Procedure [dbo].[PS_CriaDescontosMensais]
As
Begin
   --Declaração de variaveis.
   Declare @Data_Atual DateTime
   Declare @CD_Funcionario Int
   Declare @Sequencial_DescontoAgendado Int
   Declare @Motivo_Desconto_Padrao varchar(500)
   Declare @valor money
      
   Set @Data_Atual = getdate()

   If Day(@Data_Atual) = 1
     Begin

        Declare Dados_Cursor Cursor For     
        Select Sequencial_DescontoAgendado,Motivo_Desconto_Padrao,valor,cd_funcionario
         From  TB_DescontoAgendado
         Where Data_Inicial >= @Data_Atual And
               @Data_Atual  <= Data_Final And
               data_horaexclusao is null

        Open Dados_Cursor
        Fetch next from Dados_Cursor
        Into  @Sequencial_DescontoAgendado,@Motivo_Desconto_Padrao,@valor,@cd_funcionario
   
       While (@@fetch_status  <> -1)
         Begin                  
       
             Insert into tb_acertodentista 
             values (getdate(),@Motivo_Desconto_Padrao,@valor,@cd_funcionario,null,@Sequencial_DescontoAgendado,0)
              
             Fetch next from Dados_Cursor
             Into  @Sequencial_DescontoAgendado,@Motivo_Desconto_Padrao,@valor,@cd_funcionario
          End
       Close Dados_Cursor
       Deallocate Dados_Cursor
      End
End 
