/****** Object:  Procedure [dbo].[SP_Email_LoteComercial]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE procedure [dbo].[SP_Email_LoteComercial] (@cd_funcionario int)
as
begin

  Declare @nome_site varchar(100)
  Declare @URL_CorporativoS4E varchar(100)
  Declare @email_faturamento varchar(100)
  Declare @sql varchar(max)
  Declare @LicencaS4E varchar(50)
  Declare @Chave varchar(50)
  Declare @email varchar(200)
  Declare @nome varchar(100)
  
  Select @nome = nm_empregado from funcionario where cd_funcionario = @cd_funcionario 
    
  select
  @nome_site = nome_site,
  @URL_CorporativoS4E = URL_CorporativoS4E,
  @email_faturamento = email_suporte,
  @LicencaS4E = LicencaS4E
  from Configuracao
	
	set @Chave = (select upper(dbo.fn_md5(convert(varchar,isnull(max(semId),0) + 1) + convert(varchar,@cd_funcionario) + convert(varchar(10),getdate(),103) + ' ' + convert(varchar(8),getdate(),108))) from tbSaidaEmailBKP)

	Set @sql = 'Prezado ' + @nome + ',<br><br>                      
                Informamos que seu relatório de comissão já está fechado e disponível em nosso site, e que o pagamento será efetuado após o envio da nota fiscal para ' + @nome_site + '. Para acesso ao relatório siga os passos abaixo:
                <br><br>
				1º) Entre em nosso site: www.mdodonto.net e clique no menu “CORRETORES”. <br>
				2º) Em “USUÁRIO” selecione a opção: “Corretor PJ” (colocar o CNPJ) ou “Corretor PF” (colocar CPF);<br>
				3º) Senha: “1234” (quando for 1º acesso) ou a sua senha já cadastrada no portal<br>
                <br>
				Cordialmente,<br>'+@nome_site

	insert tbSaidaEmail (semEmailRemetente, semEmail, semAssunto, semMensagem, semChave, semDtCadastro, codigo, cd_origeminformacao)
	select @email_faturamento, lower(isnull(tustelefone,'')),'Fechamento Lote Corretor ' + @nome_site, @sql, @Chave, getdate(), @cd_funcionario , 1
	  from tb_contato 
	 where tteSequencial = 50 and cd_origeminformacao=2 and fl_ativo=1
	   and cd_sequencial = @cd_funcionario
	
	
	----------------------------------------------------------------
	--Cópia
	----------------------------------------------------------------
	if (@LicencaS4E = 'THFIEW74WDESD0905423JHGF87454FRDH65232986560SS009')
		begin
			insert tbSaidaEmail (semEmailRemetente, semEmail, semAssunto, semMensagem, semChave, semDtCadastro, codigo, cd_origeminformacao)
			select @email_faturamento, 'faturamento@mdodonto.net', 'Fechamento Lote Corretor '  + @nome_site + ' ' + convert(varchar,@cd_funcionario), @sql, @Chave, getdate(), @cd_funcionario , 1 

			insert tbSaidaEmail (semEmailRemetente, semEmail, semAssunto, semMensagem, semChave, semDtCadastro, codigo, cd_origeminformacao)
			select @email_faturamento, 'cassio.cacau@s4e.com.br', 'Fechamento Lote Corretor '  + @nome_site + ' ' + convert(varchar,@cd_funcionario), @sql, @Chave, getdate(), @cd_funcionario , 1 
		

			insert tbSaidaEmail (semEmailRemetente, semEmail, semAssunto, semMensagem, semChave, semDtCadastro, codigo, cd_origeminformacao)
			select @email_faturamento, 'danilo@mdodonto.net', 'Fechamento Lote Corretor '  + @nome_site + ' ' + convert(varchar,@cd_funcionario), @sql, @Chave, getdate(), @cd_funcionario , 1 
		end
					

		
End
