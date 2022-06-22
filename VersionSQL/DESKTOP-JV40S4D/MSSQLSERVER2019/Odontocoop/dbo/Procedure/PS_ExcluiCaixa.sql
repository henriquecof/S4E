/****** Object:  Procedure [dbo].[PS_ExcluiCaixa]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE Procedure [dbo].[PS_ExcluiCaixa](@SequencialCaixa int)
As
Begin

     If (Select count(*) 
          From  TB_HistoricoMovimentacao
          Where Sequencial_Movimentacao = @SequencialCaixa And 
                Data_Hora_Fechamento is not Null) > 0 
          Begin          
     	     RAISERROR ('Caixa não pode ser excluido pois já existe movimentação para o mesmo', 16, 1)
             ROLLBACK TRANSACTION
             RETURN
           End

      Delete From TB_PermissaoMovimentacao Where Sequencial_Movimentacao = @SequencialCaixa
      Delete From TB_HistoricoMovimentacao Where Sequencial_Movimentacao = @SequencialCaixa
      Delete From TB_MovimentacaoFinanceira Where Sequencial_Movimentacao = @SequencialCaixa
End
