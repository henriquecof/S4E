/****** Object:  Procedure [dbo].[insere_no_lote_credenciado]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE procedure dbo.insere_no_lote_credenciado
-- =============================================
-- Author:      henrique.almeida
-- Create date: 13/09/2021 10:55
-- Database:    S4ECLEAN
-- Description: REALIZADO PADRONIZAÇÃO E FORMATAÇÃO DE ESTILO T-SQL
-- REALIZADO DOCUMENTAÇÃO DA PROCEDURE USANDO EXTENDED PROPERTIES
-- =============================================



	@sequencias nvarchar(1000), 
	@lote int


as

begin

execute('
declare @cdseq int
declare @vlcred money
declare @vlsaldo money
declare @nrguia int
declare @cdass int
declare @cddep int
declare @cdfunc int
declare @cdserv int
declare @cdemp int

select @vlsaldo=vl_faixa-isnull(vl_parcela,0), @cdfunc=funcionario.cd_funcionario from funcionario_faixa 
inner join funcionario on funcionario_faixa.cd_faixa=funcionario.cd_faixa
inner join pagamento_dentista on pagamento_dentista.cd_funcionario=funcionario.cd_funcionario
where cd_sequencial=' + @lote + '

declare cursor_lote cursor for
	select cd_sequencial, vl_credenciado, isnull(associados.cd_empresa,0)
	from consultas procedimentos_pendentes inner join funcionario on 
         procedimentos_pendentes.cd_funcionario = funcionario.cd_funcionario
	inner join associados on procedimentos_pendentes.cd_associado = associados.cd_associado
	left join tabela_servicos on procedimentos_pendentes.cd_servico = tabela_servicos.cd_servico and 
                                     funcionario.cd_empresa = tabela_servicos.cd_filial and 
                                     tabela_servicos.cd_tipo_pagamento = case when associados.cd_tipo_pagamento = 88 then 60 else associados.cd_tipo_pagamento end 
	where cd_sequencial in (' + @sequencias + ')
open cursor_lote
fetch next from cursor_lote into @cdseq, @vlcred, @cdemp
while (@@fetch_status<>-1)
begin

print 1
	if (@vlsaldo>=@vlcred) or (@cdemp=101412)
	begin
print 2
		select distinct @nrguia=nr_guia, @cdass=cd_associado, @cddep=cd_sequencial_dep, @cdserv=cd_servico from consultas where cd_sequencial = @cdseq
	
			if @cdseq > 1
			begin
                if (select count(0) from pagamento_dentista_guia where cd_sequencial_pp = @cdseq) > 0 
                  begin
                    RAISERROR (''Guia já incluido em outro lote.'',16,1)
		            break
                  end

				select @vlsaldo =  @vlsaldo - @vlcred
				insert into pagamento_dentista_guia (cd_sequencial, cd_sequencial_pp, vl_servico) values(' + @lote + ', @cdseq, @vlcred)
			end

	end
	else
	begin
		RAISERROR (''Valor da faixa esgotado.'',16,1)
		break
	end
	fetch next from cursor_lote into @cdseq, @vlcred, @cdemp
end
deallocate cursor_lote
')
end
