/****** Object:  Procedure [dbo].[PS_DocumentacaoProcedimento]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[PS_DocumentacaoProcedimento]
	(
		@cd_servico int,
		@cd_exigedocumentacao bit
	)
AS
	Begin
	
		if(@cd_exigedocumentacao = 1)
			begin
				insert into TB_ConsultasDocumentacao
				(foto_digitalizada, cd_sequencial)
				select 0, cd_sequencial
				from consultas T1
				where (T1.dt_servico is null or T1.nr_numero_lote is null)
				and (select count(0) from TB_ConsultasDocumentacao where cd_sequencial = T1.cd_sequencial) = 0
				and T1.cd_servico = @cd_servico
			end

		if(@cd_exigedocumentacao = 0)
			begin
				delete TB_ConsultasDocumentacao
				where isnull(foto_digitalizada,1) = 0
				and ds_motivo is null
				and (
				select count(0)
				from consultas
				where cd_sequencial = TB_ConsultasDocumentacao.cd_sequencial
				and (dt_servico is null or nr_numero_lote is null)
				and cd_servico = @cd_servico
				) > 0
			end
	end
