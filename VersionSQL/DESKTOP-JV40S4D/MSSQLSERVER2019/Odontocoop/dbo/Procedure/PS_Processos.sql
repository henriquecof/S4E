/****** Object:  Procedure [dbo].[PS_Processos]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[PS_Processos]
AS
BEGIN
      SET NOCOUNT ON;

	--**********************************************************************    
	--ATENÇÃO: COMUM A TODAS AS LICENÇAS
	--**********************************************************************

	declare @cd_funcionarioSYS int = (select cd_funcionario from processos where cd_processo = 6)
	declare @cd_filial int
	declare @mdeId int
	declare @protocolo varchar(50)
	declare @chaId int
	declare @usuarioResponsavel int
	declare @grupoResponsavel int
	declare @mdeTempoMinutoResposta int
	declare @cd_processo int

	--CRM: Aviso de expiração de alvará sanitário em prestadores
	--**********************************************************************
	set @cd_processo = 25
	Declare data_cursor1 cursor for
		select T1.cd_filial, T2.mdeId, T3.usuario, T3.cgrId, T3.mdeTempoMinutoResposta
		from filial T1
		inner join processos T2 on T2.cd_processo = @cd_processo
		inner join CRMMotivoDetalhado T3 on T3.mdeId = T2.mdeId
		where datediff(day,getdate(),T1.dtVencimentoAlvaraSanitario) = 30
		and (select count(0) from processos where cd_processo = @cd_processo and mdeId is not null) > 0
		order by T1.cd_filial
	open data_cursor1
	fetch next from data_cursor1 into @cd_filial, @mdeId, @usuarioResponsavel, @grupoResponsavel, @mdeTempoMinutoResposta
	while (@@fetch_status <> -1)
	begin
		set @protocolo = replace(convert(varchar(12), getdate(),102), '.', '') + replace(convert(varchar(12), getdate(), 114), ':', '') + convert(varchar,@cd_funcionarioSYS)

		--Chamado
		insert into CRMChamado (tsoId, chaSolicitante, mdeId, chaDtCadastro, chaRespostaEmail, chaRespostaSMS, chaChave, TipoUsuario, Usuario, UsuarioResponsavel, cgrId, sitId, chaProtocolo, tinId, chaDtPrevisaoSolucao, chaNovaMensagem)
		values (10, @cd_filial, @mdeId, getdate(), 0, 0, newid(), 1, @cd_funcionarioSYS, @usuarioResponsavel, @grupoResponsavel, 1, @protocolo, 1, dateadd(minute, @mdeTempoMinutoResposta, getdate()), 1)

		select @chaId = @@identity

		---LOG insert
		insert into CRMChamadoLog (chaId, cloDtCadastro, tloId, TipoUsuario, Usuario)
		values (@chaId, getdate(), 1, 1, @cd_funcionarioSYS)

		---Ocorrência
		insert into CRMChamadoOcorrencia (chaId, cocDescricao, cocDtCadastro, TipoUsuario, Usuario)
		values (@chaId, 'AVISO DE EXPIRAÇÃO - ALVARÁ SANITÁRIO', getdate(), 1, @cd_funcionarioSYS)

		fetch next from data_cursor1 into @cd_filial, @mdeId, @usuarioResponsavel, @grupoResponsavel, @mdeTempoMinutoResposta
	end
	close data_cursor1
	deallocate data_cursor1
	--**********************************************************************
	
	--CRM: Aviso de expiração de alvará de funcionamento em prestadores
	--**********************************************************************
	set @cd_processo = 24
	Declare data_cursor2 cursor for
		select T1.cd_filial, T2.mdeId, T3.usuario, T3.cgrId, T3.mdeTempoMinutoResposta
		from filial T1
		inner join processos T2 on T2.cd_processo = @cd_processo
		inner join CRMMotivoDetalhado T3 on T3.mdeId = T2.mdeId
		where datediff(day,getdate(),T1.dtVencimentoAlvaraFuncionamento) = 30
		and (select count(0) from processos where cd_processo = @cd_processo and mdeId is not null) > 0
		order by T1.cd_filial
	open data_cursor2
	fetch next from data_cursor2 into @cd_filial, @mdeId, @usuarioResponsavel, @grupoResponsavel, @mdeTempoMinutoResposta
	while (@@fetch_status <> -1)
	begin
		set @protocolo = replace(convert(varchar(12), getdate(),102), '.', '') + replace(convert(varchar(12), getdate(), 114), ':', '') + convert(varchar,@cd_funcionarioSYS)

		--Chamado
		insert into CRMChamado (tsoId, chaSolicitante, mdeId, chaDtCadastro, chaRespostaEmail, chaRespostaSMS, chaChave, TipoUsuario, Usuario, UsuarioResponsavel, cgrId, sitId, chaProtocolo, tinId, chaDtPrevisaoSolucao, chaNovaMensagem)
		values (10, @cd_filial, @mdeId, getdate(), 0, 0, newid(), 1, @cd_funcionarioSYS, @usuarioResponsavel, @grupoResponsavel, 1, @protocolo, 1, dateadd(minute, @mdeTempoMinutoResposta, getdate()), 1)

		select @chaId = @@identity

		---LOG insert
		insert into CRMChamadoLog (chaId, cloDtCadastro, tloId, TipoUsuario, Usuario)
		values (@chaId, getdate(), 1, 1, @cd_funcionarioSYS)

		---Ocorrência
		insert into CRMChamadoOcorrencia (chaId, cocDescricao, cocDtCadastro, TipoUsuario, Usuario)
		values (@chaId, 'AVISO DE EXPIRAÇÃO - ALVARÁ DE FUNCIONAMENTO', getdate(), 1, @cd_funcionarioSYS)

		fetch next from data_cursor2 into @cd_filial, @mdeId, @usuarioResponsavel, @grupoResponsavel, @mdeTempoMinutoResposta
	end
	close data_cursor2
	deallocate data_cursor2
	--**********************************************************************

END
