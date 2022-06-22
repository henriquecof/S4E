/****** Object:  Procedure [dbo].[orcamento_clinico_status]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE dbo.orcamento_clinico_status
-- =============================================
-- Author:      henrique.almeida
-- Create date: 13/09/2021 11:02
-- Database:    S4ECLEAN
-- Description: REALIZADO PADRONIZAÇÃO E FORMATAÇÃO DE ESTILO T-SQL
-- REALIZAR DOCUMENTAÇÃO DA PROCEDURE USANDO EXTENDED PROPERTIES
-- =============================================



AS
begin

	declare @cdorca int
	declare @cdass int
	declare @dtvenc varchar(10)
	declare @dtvencD int
	declare @vlparc varchar(8)
	declare @msg varchar(150)
	
	/* validade vencida */
	update orcamento_clinico set cd_status=2,dt_status=getdate()
	where dt_validade<getdate() and cd_status=0
	
	/* fechado->concluído | fechado->cancelado */
	declare cursor_status cursor for
		select cd_orcamento from orcamento_clinico where cd_status=1
	open cursor_status
	fetch next from cursor_status into @cdorca
	while (@@fetch_status<>-1)
	begin
		if ((select count(0) from orcamento_servico where cd_orcamento=@cdorca and fl_pp=1)=0)
		begin
			if ((select count(0) from orcamento_servico where cd_orcamento=@cdorca and fl_pp=0)=1)
			begin
				/*concluído*/
				update orcamento_clinico set cd_status=4 where cd_orcamento=@cdorca
			end
			else
			begin
				/* cancelado*/
				update orcamento_clinico set cd_status=3 where cd_orcamento=@cdorca
			end
		end
		
		fetch next from cursor_status into @cdorca
	end
	deallocate cursor_status

	/* aviso sobre atraso no pagamento dos orçamentos */

/*	declare cursor_status cursor for
		select mensalidades.cd_associado_empresa, convert(varchar(10),mensalidades.dt_vencimento,103), 
		datediff(day,mensalidades.dt_vencimento,getdate()), convert(varchar(8),mensalidades.vl_parcela), cd_orcamento
		from mensalidades inner join orcamento_mensalidades on 
		mensalidades.cd_associado_empresa=orcamento_mensalidades.cd_associado_empresa and 
		mensalidades.tp_associado_empresa=orcamento_mensalidades.tp_associado_empresa and
		mensalidades.cd_parcela=orcamento_mensalidades.cd_parcela
		where mensalidades.dt_vencimento < getdate()-15 and cd_tipo_recebimento=0
		order by mensalidades.cd_associado_empresa, mensalidades.dt_vencimento
	open cursor_status
	fetch next from cursor_status into @cdass,@dtvenc,@dtvencD,@vlparc,@cdorca
	while (@@fetch_status<>-1)
	begin
		set @msg = '<font size=1 face=verdana>Associado: ' + convert(varchar(6),@cdass) + '<br/>Atraso de ' + convert(varchar(10),@dtvencD) + ' dias no pagamento do orçamento <b>' + right('00000'+convert(varchar(5),@cdorca),5) + '</b> - Venc.' + @dtvenc + ' - Valor R$ ' + @vlparc + '</font>' + char(13)
		*/
		set @msg = '<font size=1 face=verdana>Clique <a href=http://intra.absonline.com.br/modulos/abs_interno/rl_orcamento_atraso.asp>aqui</a> para ver o relatório</font>' + char(13)
		
		insert into emails(cd_sequencial,nm_endereco,nm_mensagem,nm_assunto,fl_enviado,nm_anexo)
			select isnull(max(cd_sequencial)+1,1),'washington@absonline.com.br',@msg,'Cobrança de atrasados - Orçamentos Clínicos',0,null
			from emails

		insert into emails(cd_sequencial,nm_endereco,nm_mensagem,nm_assunto,fl_enviado,nm_anexo)
			select isnull(max(cd_sequencial)+1,1),'ubiratan@absonline.com.br',@msg,'Cobrança de atrasados - Orçamentos Clínicos',0,null
			from emails

		insert into emails(cd_sequencial,nm_endereco,nm_mensagem,nm_assunto,fl_enviado,nm_anexo)
			select isnull(max(cd_sequencial)+1,1),'cassio@absonline.com.br',@msg,'Cobrança de atrasados - Orçamentos Clínicos',0,null
			from emails
/*
		fetch next from cursor_status into @cdass,@dtvenc,@dtvencD,@vlparc,@cdorca		
	end	
	deallocate cursor_status*/
end
