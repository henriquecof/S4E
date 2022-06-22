/****** Object:  Procedure [dbo].[SP_Email_Fatura]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE procedure [dbo].[SP_Email_Fatura]
	@NM_EMAIL varchar(100),
	@cd_empresa integer,
	@cd_associado integer,
	@ExcluirDuplicadoDia bit = 1,
	@cd_parcela integer = null
as
begin

  Declare @nome_site varchar(100)
  Declare @URL_CorporativoS4E varchar(100)
  Declare @email_faturamento varchar(100)
  
  select
  @nome_site = nome_site,
  @URL_CorporativoS4E = URL_CorporativoS4E,
  @email_faturamento = email_faturamento
  from Configuracao

  if @cd_empresa > 0 
   Begin 

    Declare @nm_fantasia varchar(100)
    Declare @Chave varchar(50)
    Declare @cnpj varchar(40)
    
    set @cnpj = (select NR_CGC from empresa where cd_empresa = @cd_empresa)
    
    set @Chave = (select upper(dbo.fn_md5(convert(varchar,isnull(max(semId),0) + 1) + convert(varchar,@cd_empresa) + convert(varchar(10),getdate(),103) + ' ' + convert(varchar(8),getdate(),108))) from tbSaidaEmailBKP)
    set @nm_fantasia = (select nm_fantasia from empresa where cd_empresa = @cd_empresa)
    
    insert tbSaidaEmail (semEmailRemetente, semEmail, semAssunto, semMensagem, semChave, semDtCadastro, codigo, cd_origeminformacao, semExcluirDuplicadoDia,cd_parcela)
	select @email_faturamento, lower(isnull(tustelefone,'')),
	       'Fatura ' + @nome_site + case when len(upper(@nm_fantasia))<>0 then ' - ' + upper(@nm_fantasia) else '' end,
	'Att. ' + upper(@nm_fantasia) + ' - ' + convert(varchar,@cd_empresa) + '
	<br /><br />
	Prezado Cliente,
	<br /><br />
	Encaminhamos para apreciação de V.Sa. o relatório analítico e boleto de pagamento da mensalidade do plano odontológico de seus colaboradores.
	<br /><br />
	<a href="' + @URL_CorporativoS4E + '/SYS/Mailing/IdentificacaoEmail.aspx?ID=' + @Chave + '" target="_blank">Clique aqui</a> para visualizar e imprimir.
	<br /><br />
	<b>Atenção!</b> O link acima permite acesso irrestrito ao Portal, portanto será necessário que seja verificado se este e-mail pode ser encaminhado a outros usuários a acessarem o Portal no nome do gestor.
	<br /><br />
	Qualquer dúvida estamos à disposição!
	<br /><br />
	Cordialmente,
	<br /><br />
	Departamento de Faturamento
	<img src="' + @URL_CorporativoS4E + '/SYS/Mailing/VisualizacaoEmail.aspx?ID=' + @Chave + '" width="2" height="2" />
	',
	@Chave, getdate(), @cd_empresa , 3, @ExcluirDuplicadoDia , @cd_parcela
	from tb_contato as t
	where t.ttesequencial=50 and t.cd_origeminformacao=3 and t.cd_sequencial = @cd_empresa and fl_ativo=1
	print 'Empresa'
	print @@rowcount
   End

 if @cd_associado > 0 
  begin

    Declare @nm_completo varchar(100)
    set @Chave = (select upper(dbo.fn_md5(convert(varchar,isnull(max(semId),0) + 1) + convert(varchar,@cd_associado) + convert(varchar(10),getdate(),103) + ' ' + convert(varchar(8),getdate(),108))) from tbSaidaEmailBKP)
    select @nm_completo = nm_completo from associados where cd_associado = @cd_associado

insert tbSaidaEmail (semEmailRemetente, semEmail, semAssunto, semMensagem, semChave, semDtCadastro, codigo, cd_origeminformacao, semExcluirDuplicadoDia, cd_parcela)
select @email_faturamento, lower(isnull(tustelefone,'')),
       'Fatura ' + @nome_site,
'Att. ' + upper(@nm_completo) + '
<br /><br />
Prezado Cliente,
<br /><br />
Encaminhamos para apreciação de V.Sa. o boleto de pagamento da mensalidade do seu plano odontológico.
<br /><br />
<a href="' + @URL_CorporativoS4E + '/SYS/Mailing/IdentificacaoEmail.aspx?ID=' + @Chave + '" target="_blank">Clique aqui</a> para visualizar e imprimir.
<br /><br />
<b>Atenção!</b> O link acima permite acesso irrestrito ao Portal, portanto será necessário que seja verificado se este e-mail pode ser encaminhado a outros usuários a acessarem o Portal em seu nome.
<br /><br />
Cordialmente,
<br /><br />
Departamento de Faturamento
<img src="' + @URL_CorporativoS4E + '/SYS/Mailing/VisualizacaoEmail.aspx?ID=' + @Chave + '" width="2" height="2" />
',
@Chave, getdate(), @cd_associado, 1, @ExcluirDuplicadoDia  , @cd_parcela
from tb_contato as t
where t.ttesequencial=50 and fl_ativo=1 and 
   (
     (t.cd_origeminformacao=1 and t.cd_sequencial = @cd_associado) 
     or 
     (t.cd_origeminformacao=5 and t.cd_sequencial in (select cd_sequencial from dependentes where cd_Associado = @cd_associado and CD_GRAU_PARENTESCO=1) )
    ) 
print 'Associado'
print @@rowcount
   End 

End
