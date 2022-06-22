/****** Object:  Function [dbo].[FS_InformacaoKITAssociado]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE function [dbo].[FS_InformacaoKITAssociado](
	@cd_associado int,
	@cd_sequencial_dep int,
	@dt_fim datetime -- Data de validade do servico. Passar sempre getdate()
)
Returns Varchar(100)
AS
Begin
	Declare @Informacao as Varchar(100)

	select top 1 @Informacao = upper(T02.nm_sop) + ' - Adesão: ' + convert(varchar(10),T01.dt_inicio,103)
	from servicos_opcionais as T01, sop as T02
	where T01.cd_sop = T02.cd_sop
	and T01.cd_sop in (17,18)
	and T01.cd_situacao = 1
	and T01.dt_fim >= @dt_fim
	and T01.cd_associado = @cd_associado
	and T01.cd_sequencial_dep = @cd_sequencial_dep
	order by T01.cd_sop desc

	Return @Informacao
End
