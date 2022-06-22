/****** Object:  Procedure [dbo].[PS_TelefoniaProcessamento]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[PS_TelefoniaProcessamento]
AS
BEGIN
	SET NOCOUNT ON;
	
	--Atualizar telefones (datas e quantidade de ocorrências)
	
	--Empresa
	update TB_Contato set
	tusQuantidade = isnull(tusQuantidade,0) + 1,
	tusDtAtualizacao = T1.treDtCadastro,
	cd_funcionarioAtualizacao = T3.UsuarioResponsavel,
	executarTrigger = 0
	from TelefoniaRetorno T1
	left join CRMChamadoOcorrencia T2 on T2.cocProtocolo = T1.cocProtocolo
	left join CRMChamado T3 on T3.chaId = T2.chaId
	where TB_Contato.tusTelefone = case when left(T1.treCallee, 1) = 0 then substring(T1.treCallee,2,len(T1.treCallee) - 1) else T1.treCallee end
	and T1.treDialedTime is not null
	and T1.cocProtocolo is not null
	and T3.tsoId = 3 --Empresa
	and TB_Contato.cd_origeminformacao = 3 --Empresa
	
	--Responsável financeiro
	update TB_Contato set
	tusQuantidade = isnull(tusQuantidade,0) + 1,
	tusDtAtualizacao = T1.treDtCadastro,
	cd_funcionarioAtualizacao = T3.UsuarioResponsavel,
	executarTrigger = 0
	from TelefoniaRetorno T1
	left join CRMChamadoOcorrencia T2 on T2.cocProtocolo = T1.cocProtocolo
	left join CRMChamado T3 on T3.chaId = T2.chaId
	where TB_Contato.tusTelefone = case when left(T1.treCallee, 1) = 0 then substring(T1.treCallee,2,len(T1.treCallee) - 1) else T1.treCallee end
	and T1.treDialedTime is not null
	and T1.cocProtocolo is not null
	and T3.tsoId = 2 --Usuário do Plano
	and TB_Contato.cd_origeminformacao = 1 --Associado
	
	--Usuário do plano
	update TB_Contato set
	tusQuantidade = isnull(tusQuantidade,0) + 1,
	tusDtAtualizacao = T1.treDtCadastro,
	cd_funcionarioAtualizacao = T3.UsuarioResponsavel,
	executarTrigger = 0
	from TelefoniaRetorno T1
	left join CRMChamadoOcorrencia T2 on T2.cocProtocolo = T1.cocProtocolo
	left join CRMChamado T3 on T3.chaId = T2.chaId
	where TB_Contato.tusTelefone = case when left(T1.treCallee, 1) = 0 then substring(T1.treCallee,2,len(T1.treCallee) - 1) else T1.treCallee end
	and T1.treDialedTime is not null
	and T1.cocProtocolo is not null
	and T3.tsoId = 2 --Usuário do Plano
	and TB_Contato.cd_origeminformacao = 5 --Dependente
	
	--Limpar tabela de produção para ficar rápida a navegação
	insert into TelefoniaRetornoBKP
	select * from TelefoniaRetorno
	where datediff(day,treDtCadastro,getdate()) > 0
	
	delete TelefoniaRetorno
	where datediff(day,treDtCadastro,getdate()) > 0
END
