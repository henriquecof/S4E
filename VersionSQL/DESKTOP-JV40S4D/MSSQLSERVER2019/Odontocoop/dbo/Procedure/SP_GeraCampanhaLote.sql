/****** Object:  Procedure [dbo].[SP_GeraCampanhaLote]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[SP_GeraCampanhaLote]
AS
BEGIN
	SET NOCOUNT ON;
               
	--Agendamentos dependentes

	DELETE CampanhaLoteItens
	FROM Campanha X1
	WHERE X1.cd_campanha = CampanhaLoteItens.cd_campanha
	AND CampanhaLoteItens.cd_campanha_lote IS NULL
	AND (
		SELECT COUNT(0)
		FROM CRMChamado T1
		INNER JOIN CRMMotivoDetalhado T2 on T2.mdeId = T1.mdeId
		INNER JOIN CRMMotivo T3 on T3.motId = T2.motId
		INNER JOIN dependentes T4 on T4.cd_associado = CampanhaLoteItens.id_erp_crm
		WHERE T4.cd_grau_parentesco = 1
		AND T1.chasolicitante = isnull(CampanhaLoteItens.cd_sequencial_dep,T4.cd_sequencial)
		AND T1.tsoId = X1.tsoId
		AND T1.chaDtFechamento IS NULL
		AND T1.sitId != 3
		AND ISNULL(T2.mdeAgendamento, 0) = 1
		AND T3.motDescricao = 'MODULO CALL CENTER'
	) > 0
	AND X1.cd_tipo_campanha = 1 --Campanha do tipo cobrança
	AND X1.tsoId = 2

	--Demais agendamentos
               
	DELETE CampanhaLoteItens
	FROM Campanha X1
	WHERE X1.cd_campanha = CampanhaLoteItens.cd_campanha
	AND CampanhaLoteItens.cd_campanha_lote IS NULL
	AND (
		SELECT COUNT(0)
		FROM CRMChamado T1
		INNER JOIN CRMMotivoDetalhado T2 on T2.mdeId = T1.mdeId
		INNER JOIN CRMMotivo T3 on T3.motId = T2.motId
		WHERE T1.chasolicitante = CampanhaLoteItens.id_erp_crm
		AND T1.tsoId = X1.tsoId
		AND T1.chaDtFechamento IS NULL
		AND T1.sitId != 3
		AND ISNULL(T2.mdeAgendamento, 0) = 1
		AND T3.motDescricao = 'MODULO CALL CENTER'
	) > 0
	AND X1.cd_tipo_campanha = 1 --Campanha do tipo cobrança
	AND X1.tsoId != 2
               
	--Prazo ainda não esgotado para reinserção na campanha
 
	DECLARE @cd_campanha as int
	DECLARE vCursorCampanha CURSOR FOR
		select cd_campanha
		from campanha
	OPEN vCursorCampanha
               
	FETCH NEXT FROM vCursorCampanha INTO @cd_campanha
 
	WHILE @@FETCH_STATUS = 0
	BEGIN
		delete CampanhaLoteItens
		where cd_campanha_lote is null
		and cd_campanha = @cd_campanha
		and (
			select count(0)
			from CampanhaLoteItens T1
			inner join CRMChamado T2 on T2.chaId = T1.chaId
			inner join CRMMotivoDetalhado T3 on T3.mdeId = T2.mdeId
			where dateadd(day,isnull(T3.mdeQtDiasNovaCampanha,0),convert(date,T2.chaDtCadastro)) > convert(date,getdate())
			and T1.cd_campanha = @cd_campanha
			and T1.ID_ERP_CRM = CampanhaLoteItens.ID_ERP_CRM
		) > 0
 
		FETCH NEXT FROM vCursorCampanha INTO @cd_campanha
	END
	CLOSE vCursorCampanha
	DEALLOCATE vCursorCampanha
 
	--Criar lotes
	insert into CampanhaLote
	(cd_campanha, dt_cadastro, dt_inicio, dt_fim, hr_inicio, hr_fim, qt_total, qt_positivo, qt_negativo, qt_neutro, cd_campanha_tipo_modulo)
	select cd_campanha, getdate(), convert(date,getdate()), convert(date,getdate()), null, null, count(distinct id_erp_crm), 0, 0, 0, 1
	from CampanhaLoteItens
	where cd_campanha_lote is null
	group by cd_campanha
               
	--Povoar lotes
	update CampanhaLoteItens
	set CampanhaLoteItens.cd_campanha_lote = CampanhaLote.cd_campanha_lote
	from CampanhaLote
	where CampanhaLoteItens.cd_campanha = CampanhaLote.cd_campanha
	and CampanhaLoteItens.cd_campanha_lote is null
	and convert(date,CampanhaLote.dt_cadastro) = convert(date,getdate())
END
