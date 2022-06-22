/****** Object:  Procedure [dbo].[PS_CRM_ExpiracaoCobranca]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[PS_CRM_ExpiracaoCobranca]
As
Begin
	DECLARE @WL_UsuarioSYS int
	DECLARE @WL_chaId int
	
	select @WL_UsuarioSYS = cd_funcionario 
	from Processos
	where cd_processo = 6
	
	DECLARE WL_cursor CURSOR FOR
		select T1.chaId
		from CRMChamado T1, CRMMotivoDetalhado T2, CRMMotivo T3
		where T1.mdeId = T2.mdeId
		and T2.motId = T3.motId
		and ((T2.mdeDescricao = 'AGENDADO' and T3.motDescricao = 'MODULO CALL CENTER') or isnull(convert(int,T2.mdeAgendamento),0) = 1)
		and T1.sitId != 3
		and T1.chaDtPrevisaoSolucao < convert(varchar(10),getdate(),101)
	OPEN WL_cursor
	FETCH NEXT FROM WL_cursor INTO @WL_chaId
	WHILE @@FETCH_STATUS = 0
		BEGIN
		
			--Desvincular a mensalidade do cobrador
			update mensalidades set
			chaId = null,
			cd_usuario_alteracao = @WL_UsuarioSYS
			where chaId = @WL_chaId
			and (
				(dt_pagamento is null and cd_tipo_parcela not in (5,6)) --Não entra parcela de cobrança/acordo
				or
				(dt_pagamento is null and cd_tipo_parcela in (5,6) and dt_vencimento < convert(varchar(10),getdate(),101)) --Parcelas de cobrança/acordo vencidas
			)
			
			--Inserir mensagem de fechamento pelo sistema
			insert into CRMChamadoOcorrencia
			(chaId, cocDescricao, cocDtCadastro, TipoUsuario, Usuario)
			values (@WL_chaId, 'Atendimento expirado.', getdate(), 1, @WL_UsuarioSYS)
			
			--Fechar o chamado
			update CRMChamado set
			sitId = 3,
			chaDtFechamento = chaDtPrevisaoSolucao
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
