/****** Object:  Procedure [dbo].[PS_CRM_FecharAgendamentosCobrancaPagos]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[PS_CRM_FecharAgendamentosCobrancaPagos]
As
Begin
	DECLARE @WL_UsuarioSYS int
	DECLARE @WL_chaId int
	
	select @WL_UsuarioSYS = cd_funcionario
	from Processos
	where cd_processo = 6
	
	DECLARE WL_cursor CURSOR FOR
		select distinct T1.chaId
		from mensalidades T1, TB_MensalidadeAssociado T2, TB_FormaLancamento T3
		where T1.cd_parcela = T2.cd_parcela
		and T2.sequencial_lancamento = T3.sequencial_lancamento
		and T3.Tipo_ContaLancamento = 1 --Realizado
		and T1.vl_pago > 0
		and T2.data_exclusao is null
		and datediff(day,T1.dt_pagamento,getdate())=1
		and T1.cd_tipo_recebimento > 1
		and T1.chaId is not null
		and T1.chaId in (
			select TT1.chaId
			from CRMChamado TT1, CRMMotivoDetalhado TT2, CRMMotivo TT3
			where TT1.mdeId = TT2.mdeId
			and TT2.motId = TT3.motId
			and ((TT2.mdeDescricao = 'AGENDADO' and TT3.motDescricao = 'MODULO CALL CENTER') or isnull(convert(int,TT2.mdeAgendamento),0) = 1)
			and TT1.sitId != 3
			and TT1.chaId = T1.chaId
		)
	OPEN WL_cursor
	FETCH NEXT FROM WL_cursor INTO @WL_chaId
	WHILE @@FETCH_STATUS = 0
		BEGIN
			
			--Inserir mensagem de fechamento pelo sistema
			insert into CRMChamadoOcorrencia
			(chaId, cocDescricao, cocDtCadastro, TipoUsuario, Usuario)
			values (@WL_chaId, 'Pagamento realizado.', getdate(), 1, @WL_UsuarioSYS)
			
			--Fechar o chamado
			update CRMChamado set
			sitId = 3,
			chaDtFechamento = getdate()
			where chaId = @WL_chaId
			
			--LOG de fechamento
			insert into CRMChamadoLog
			(chaId, cloDtCadastro, tloId, TipoUsuario, Usuario)
			values (@WL_chaId, getdate(), 5, 1, @WL_UsuarioSYS)
	
			FETCH NEXT FROM WL_cursor
			INTO @WL_chaId
		END
	
	CLOSE WL_cursor
	DEALLOCATE WL_cursor
End
