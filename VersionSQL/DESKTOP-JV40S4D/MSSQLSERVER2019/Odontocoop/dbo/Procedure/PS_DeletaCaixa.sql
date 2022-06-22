/****** Object:  Procedure [dbo].[PS_DeletaCaixa]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE procedure [dbo].[PS_DeletaCaixa](@Sequencial_Caixa int)
as
Begin

	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    If (Select count(*) 
          From  TB_HistoricoMovimentacao
          Where Sequencial_Movimentacao = @Sequencial_Caixa And 
                Data_Hora_Fechamento is not Null) > 0 
          Begin          
     	     RAISERROR ('Caixa não pode ser excluido pois já existe movimentação para o mesmo', 16, 1)
             ROLLBACK TRANSACTION
             RETURN
           End
      Else
          Begin
            Delete From TB_HistoricoMovimentacao Where Sequencial_Movimentacao = @Sequencial_Caixa
            Delete From TB_MovimentacaoFinanceira Where Sequencial_Movimentacao = @Sequencial_Caixa
          End       

End
