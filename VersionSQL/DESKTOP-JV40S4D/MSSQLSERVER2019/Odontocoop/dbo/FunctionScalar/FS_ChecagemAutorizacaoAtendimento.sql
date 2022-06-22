/****** Object:  Function [dbo].[FS_ChecagemAutorizacaoAtendimento]    Committed by VersionSQL https://www.versionsql.com ******/

/*
Objetivo           : Verificar se um determinado associado pode ser atendido
Parâmetros Entrada : 
                     @Associado  - Código do Cliente
                     @Sequencial_Dep - Sequencial do Cliente (Dependente)
Parâmetro Saída    :
                     @Autorizado - Sim ou Não
*/

CREATE function [dbo].[FS_ChecagemAutorizacaoAtendimento](
	@Associado Int,
	@Sequencial_Dep Int
)

RETURNS Smallint

AS
Begin
	Declare @Autorizado Smallint
	Declare @Sit_Ass Smallint
	Declare @Sit_Dep Smallint

	Set @Autorizado = 0
	Set @Sit_Dep = 999

	select @Sit_Ass = T3.fl_atendido_clinica, @Sit_Dep = T4.fl_atendido_clinica
	from Dependentes T1, Associados as T2, Dependentes T12, Situacao_Historico as T3, Situacao_Historico as T4, HISTORICO as T5, HISTORICO as T6
	where T1.cd_associado = T2.cd_Associado
	and T12.cd_associado = T2.cd_Associado
	and T12.CD_GRAU_PARENTESCO = 1
	and T1.CD_Sequencial_historico = T5.cd_sequencial
	and T5.CD_SEQUENCIAL_dep = T1.cd_sequencial
	and T12.CD_Sequencial_historico = T6.cd_sequencial
	and T6.CD_SEQUENCIAL_dep = T12.cd_sequencial
	and T5.CD_SITUACAO = T4.CD_SITUACAO_HISTORICO
	and T6.CD_SITUACAO = T3.CD_SITUACAO_HISTORICO
--	and T1.CD_Sequencial_historico = T4.cd_situacao_historico
--	and T2.cd_situacao = T3.cd_situacao_historico
	and T1.cd_associado = @Associado
	and T1.cd_sequencial = @Sequencial_Dep

	If (@Sit_Dep <> 999)
		Begin
			If (@Sequencial_Dep = 1)
				Begin
					If (@Sit_Ass <> 1)
						Begin
							Set @Autorizado = 0
						End
					Else
						Begin
							Set @Autorizado = 1
						End
				End
			Else
				Begin
					If (@Sit_Ass <> 1 or @Sit_Dep <> 1)
						Begin
							Set @Autorizado = 0
						End
					Else
						Begin
							Set @Autorizado = 1
						End
				End
		End

	Return @Autorizado
End
