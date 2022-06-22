/****** Object:  Procedure [dbo].[PS_ExpirarProcedimentos]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE Procedure [dbo].[PS_ExpirarProcedimentos]
As
Begin
	Declare @qt_DiasExpiracaoProcedimento int
	Declare @qt_DiasExpiracaoProcedimentoRealizado int
	Declare @mensagem varchar(50)
	Declare @licencaS4E varchar(50)

	select
	@qt_DiasExpiracaoProcedimento = isnull(qt_DiasExpiracaoProcedimento, -1),
	@qt_DiasExpiracaoProcedimentoRealizado = isnull(qt_DiasExpiracaoProcedimentoRealizado, -1),
	@licencaS4E = licencaS4E
	from configuracao

	if (@qt_DiasExpiracaoProcedimento > 0)
		begin
			set @mensagem = 'EXPIROU O PRAZO PARA A REALIZAÇÃO DESTE PROCEDIMENTO'

			if (@licencaS4E = '0080OWNECOWNEOPCNPQWROIV94VPRIVNPI3NVIQRNPVINEROF')
				begin
					set @mensagem += ' - 30 DIAS'
				end

			update consultas set
			Status = 10,
			motivo_cancelamento = @mensagem,
			dt_cancelamento = GETDATE(),
			usuario_cancelamento = (select cd_funcionario from Processos where cd_processo = 6),
			executarTrigger = 0
			where dt_servico is null
			and status in (2,5,6)
			and dt_cancelamento is null
			and (select count(0) from orcamento_servico where cd_sequencial_pp = consultas.cd_sequencial) = 0
			and DATEDIFF(day,dt_pericia,getdate()) > @qt_DiasExpiracaoProcedimento
			and nr_gto not like '%RG'
			and (case when @licencaS4E = '0080OWNECOWNEOPCNPQWROIV94VPRIVNPI3NVIQRNPVINEROF' then (select count(0) from consultas T1 where T1.cd_sequencial = consultas.cd_sequencial and T1.dt_pericia >= '06/23/2020') else 1 end) > 0
	end

	if (@qt_DiasExpiracaoProcedimentoRealizado > 0)
		begin
			set @mensagem = 'EXPIROU O PRAZO PARA O ENVIO DESTE PROCEDIMENTO'

			if (@licencaS4E = '0080OWNECOWNEOPCNPQWROIV94VPRIVNPI3NVIQRNPVINEROF')
				begin
					set @mensagem += ' - 60 DIAS'
				end

			update consultas set
			Status = 10,
			motivo_cancelamento = @mensagem,
			dt_cancelamento = GETDATE(),
			usuario_cancelamento = (select cd_funcionario from Processos where cd_processo = 6),
			executarTrigger = 0
			where nr_numero_lote is null
			and status in (3,5,6,7)
			and dt_cancelamento is null
			and (select count(0) from orcamento_servico where cd_sequencial_pp = consultas.cd_sequencial) = 0
			and DATEDIFF(day,dt_servico,getdate()) > @qt_DiasExpiracaoProcedimentoRealizado
			and nr_gto not like '%RG'
			and (case when @licencaS4E = '0080OWNECOWNEOPCNPQWROIV94VPRIVNPI3NVIQRNPVINEROF' then (select count(0) from consultas T1 where T1.cd_sequencial = consultas.cd_sequencial and T1.dt_servico >= '06/23/2020') else 1 end) > 0
			and (case when @licencaS4E = '0080OWNECOWNEOPCNPQWROIV94VPRIVNPI3NVIQRNPVINEROF' then isnull(nr_procedimentoliberado,0) else 0 end) = 0
		end
End
