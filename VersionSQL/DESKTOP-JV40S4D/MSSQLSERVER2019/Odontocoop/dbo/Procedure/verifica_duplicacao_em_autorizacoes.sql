/****** Object:  Procedure [dbo].[verifica_duplicacao_em_autorizacoes]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE  PROCEDURE [dbo].[verifica_duplicacao_em_autorizacoes]

AS
BEGIN

declare @nraut varchar(6)
declare @qtde int
declare @msg varchar(8000)

set @msg=''

declare cursor_duplicado cursor for
	select autorizacao_atendimento.nr_autorizacao, count(0) from autorizacao_atendimento 
	left join consultas on 
	autorizacao_atendimento.nr_autorizacao=consultas.nr_autorizacao
	where nm_motivo='AUT.INTERNET'
	group by autorizacao_atendimento.nr_autorizacao
open cursor_duplicado
fetch next from cursor_duplicado into @nraut, @qtde
while (@@fetch_status<>-1)
begin
	if (@qtde > 1) 
	begin
		set @msg = @msg + @nraut + ' aut. em ' + convert(varchar(4),@qtde) + ' proc.<br/>'
		print @nraut + ' aut. em ' + convert(varchar(4),@qtde) + ' proc.'
	end
	fetch next from cursor_duplicado into @nraut, @qtde
end
deallocate cursor_duplicado

if (len(@msg)=0) set @msg = 'nenhuma autorização duplicada.'

insert into emails(cd_sequencial,nm_endereco,nm_mensagem,nm_assunto,fl_enviado,nm_anexo)
select max(cd_sequencial)+1,'washington@absonline.com.br',@msg,'duplicação de procedimentos',0,null
from emails

end
