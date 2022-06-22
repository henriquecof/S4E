/****** Object:  Procedure [dbo].[PS_NumeroReagendamentoPorData]    Committed by VersionSQL https://www.versionsql.com ******/

create procedure [dbo].[PS_NumeroReagendamentoPorData](@usuario varchar(20))
As
Begin
   Declare @MenorDiaAtual int
   Declare @DiaAtual int
   Declare @MaiorDiaAtualAte7Dias int
   Declare @MaiorDiaAtualDepois7Dias int

   Set @MenorDiaAtual  = 0
   Set @DiaAtual   = 0
   Set @MaiorDiaAtualAte7Dias   = 0
   set @MaiorDiaAtualDepois7Dias   = 0

   Select @MenorDiaAtual = count(*)
	 From TB_ListaAtrasadosUsuario 
	 Where status       = 1 And
		   Datediff(Day,getdate(),data_status)  < 0  And
		   nome_usuario = @usuario

   Select @DiaAtual = count(*) 
	 From TB_ListaAtrasadosUsuario 
	 Where status       = 1 And
		   Datediff(Day,getdate(),data_status)  = 0  And
		   nome_usuario = @usuario

   Select @MaiorDiaAtualAte7Dias = count(*)
	 From TB_ListaAtrasadosUsuario 
	 Where  status       = 1 And
			Datediff(Day,getdate(),data_status)  >= 1 And
			Datediff(Day,getdate(),data_status)  <= 7  And
			nome_usuario = @usuario

   Select @MaiorDiaAtualDepois7Dias = count(*)
	 From TB_ListaAtrasadosUsuario 
	 Where  status       = 1 And
			Datediff(Day,getdate(),data_status)  > 7 And        
			nome_usuario = @usuario

   Select @MenorDiaAtual as MenorDiaAtual, @DiaAtual as DiaAtual, @MaiorDiaAtualAte7Dias as MaiorDiaAtualAte7Dias, @MaiorDiaAtualDepois7Dias as MaiorDiaAtualDepois7Dias   

End
