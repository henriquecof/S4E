/****** Object:  Procedure [dbo].[PS_CriaPagamentoDentista]    Committed by VersionSQL https://www.versionsql.com ******/

Create procedure [dbo].[PS_CriaPagamentoDentista](@CD_Funcionario int)
As
Begin
    Declare @CD_Pagamento_Dentista int

    Begin Transaction
    
	Select @CD_Pagamento_Dentista = Max(CD_Sequencial)+1 
		  From Pagamento_Dentista
        
	 Insert into Pagamento_Dentista
	   (cd_sequencial,cd_funcionario,dt_abertura,qt_procedimentos,
	   vl_parcela,fl_fechado,vl_antesglosa,vl_acerto,motivo_acerto)
	 Values 
	   (@CD_Pagamento_Dentista, @CD_Funcionario,getdate(),0,0,0,0,0,null)   

     Select @CD_Pagamento_Dentista

     Commit Transaction
End
