/****** Object:  Procedure [dbo].[SP_Email_Boleto_Aberto]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE procedure [dbo].[SP_Email_Boleto_Aberto]
@cd_empresa integer,
@cd_associado integer
as
begin

  Declare @nome_site varchar(100)
  Declare @URL_CorporativoS4E varchar(100)
  Declare @email_faturamento varchar(100)
  declare @Vencimento_Parcela varchar(10)
  declare @Valor_parcela varchar(10)  
  Declare @sql varchar(max)
  Declare @LicencaS4E varchar(50)
  Declare @Chave varchar(50)
    
  select
  @nome_site = nome_site,
  @URL_CorporativoS4E = URL_CorporativoS4E,
  @email_faturamento = email_faturamento,
  @LicencaS4E = LicencaS4E
  from Configuracao

  if @cd_empresa > 0 
   Begin 
    Declare @nm_fantasia varchar(100)
      
    set @Chave = (select upper(dbo.fn_md5(convert(varchar,isnull(max(semId),0) + 1) + convert(varchar,@cd_empresa) + convert(varchar(10),getdate(),103) + ' ' + convert(varchar(8),getdate(),108))) from tbSaidaEmailBKP)
    set @nm_fantasia = (select nm_fantasia from empresa where cd_empresa = @cd_empresa)
    
    Set @sql = 'Att. ' + upper(@nm_fantasia) + ' - ' + convert(varchar,@cd_empresa) + '
		<br /><br />
		Prezado Cliente,
		<br /><i>(Esta é uma notificação automática.)</i>
		<br /><br /><br />
		Consta em nosso sistema que os vencimentnos abaixo encontram-se em aberto:
		<br /><br />
		<table>
		<tr>
		<th align="center">Vencimento</th>
		<th>&nbsp;</th>
		<th align="left">Valor</th>
		</tr>' 
		   
    --Vencimentos e Valor
    DECLARE cursor_Venc_Valor_parcela CURSOR FOR 
		select convert(varchar(10), t1.dt_vencimento, 103) as vencimento, isnull(vl_parcela,0) as vl_parcela
		from mensalidades T1, empresa T2, historico T3, situacao_historico T4
		where T1.cd_associado_empresa = T2.cd_empresa
		and t2.cd_sequencial_historico = t3.cd_sequencial
		and T3.cd_situacao = T4.cd_situacao_historico 
		and cd_tipo_recebimento = 0 
		and tp_associado_empresa in (2,3) 
		and dt_pagamento is null
		and datediff(day,T1.dt_vencimento,getdate()) > 2
		and T4.fl_envia_cobranca = 1
		and cd_associado_empresa = @cd_empresa
    		
		open cursor_Venc_Valor_parcela
		FETCH NEXT FROM cursor_Venc_Valor_parcela into @Vencimento_Parcela, @Valor_parcela
			WHILE (@@FETCH_STATUS <> -1)
				BEGIN
					Set @sql= @sql + '<tr><td align="center">' + @Vencimento_Parcela + '</td><td>&nbsp;</td><td align="left">R$ ' + @Valor_parcela + '</td></tr>'
					
					fetch next from cursor_Venc_Valor_parcela into @Vencimento_Parcela, @Valor_parcela 
				END
		close cursor_Venc_Valor_parcela
		DEALLOCATE cursor_Venc_Valor_parcela
    --Fim    
		
		Set @sql= @sql + 
		'</table>
		<br />
		Se o pagamento já foi efetuado, por gentileza, desconsidere este aviso, e se tiver sido via depósito, é necessário o envio do comprovante para baixa em nosso sistema.
		<br />
		Caso contrário, regularize a situação o quanto antes para evitar o bloqueio automático dos atendimentos. Para isso, disponibilizamos abaixo um link do boleto atualizado e com vencimento para pagamento na data de hoje.
		<br />		
		<a href="' + @URL_CorporativoS4E + '/SYS/Mailing/IdentificacaoEmail.aspx?ID=' + @Chave + '" target="_blank">Clique aqui</a> para visualizar e imprimir.
		<br /><br />
		Atenciosamente,'
		--<br /><br />
		--' + @nome_site + '
		--<img src="' + @URL_CorporativoS4E + '/SYS/Mailing/VisualizacaoEmail.aspx?ID=' + @Chave + '" width="2" height="2" />'
		
		insert tbSaidaEmail (semEmailRemetente, semEmail, semAssunto, semMensagem, semChave, semDtCadastro, codigo, cd_origeminformacao)
		select @email_faturamento, lower(isnull(tustelefone,'')),'Fatura em aberto - ' + @nome_site, @sql, @Chave, getdate(), @cd_empresa , 3 
		from tb_contato as t
		where t.ttesequencial=50 
		and t.cd_origeminformacao=3 
		and t.cd_sequencial = @cd_empresa 
		and fl_ativo=1
		
		----------------------------------------------------------------
		--Cópia para faturamento@mdodonto.net
		----------------------------------------------------------------
		if (@LicencaS4E = 'THFIEW74WDESD0905423JHGF87454FRDH65232986560SS009')
			begin
				insert tbSaidaEmail (semEmailRemetente, semEmail, semAssunto, semMensagem, semChave, semDtCadastro, codigo, cd_origeminformacao)
				select @email_faturamento, 'faturamento@mdodonto.net','Fatura em aberto - ' + @nm_fantasia, @sql, @Chave, getdate(), @cd_empresa , 3
			end
		
		print 'Empresa'
		print @@rowcount
   End


if @cd_associado > 0 
		begin
			Declare @nm_completo varchar(100)
			--Declare @Chave varchar(50)
				
			set @Chave = (select upper(dbo.fn_md5(convert(varchar,isnull(max(semId),0) + 1) + convert(varchar,@cd_associado) + convert(varchar(10),getdate(),103) + ' ' + convert(varchar(8),getdate(),108))) from tbSaidaEmailBKP)
			set @nm_completo = (select nm_completo from associados where cd_associado = @cd_associado)

			 Set @sql = 'Att. ' + upper(@nm_completo) + ' - ' + convert(varchar,@cd_associado) + '
			<br /><br />
			Prezado Cliente,
			<br /><i>(Esta é uma notificação automática.)</i>
			<br /><br /><br />
			Consta em nosso sistema que os vencimentnos abaixo encontram-se em aberto:
			<br /><br />
			<table>
			<tr>
			<th align="center">Vencimento</th>
			<th>&nbsp;</th>
			<th align="left">Valor</th>
			</tr>' 
				
	--Vencimentos e Valor
    DECLARE cursor_Venc_Valor_parcela CURSOR FOR 
		select convert(varchar(10), t1.dt_vencimento, 103) as vencimento, isnull(vl_parcela,0) as vl_parcela
		from mensalidades T1, associados T2, DEPENDENTES T22, historico T3, situacao_historico T4
		where T1.cd_associado_empresa = T2.cd_associado
		and t22.cd_sequencial_historico = t3.cd_sequencial
		and T3.cd_situacao = T4.cd_situacao_historico 
		and T1.cd_tipo_recebimento = 0 
		and T1.tp_associado_empresa in (1) 
		and T1.dt_pagamento is null
		and datediff(day,T1.dt_vencimento,getdate()) > 2
		and T4.fl_envia_cobranca = 1
		and T1.cd_associado_empresa = @cd_associado
		and T2.cd_associado = T22.cd_associado
		
		open cursor_Venc_Valor_parcela
		FETCH NEXT FROM cursor_Venc_Valor_parcela into @Vencimento_Parcela, @Valor_parcela
			WHILE (@@FETCH_STATUS <> -1)
				BEGIN
					Set @sql= @sql + '<tr><td align="center">' + @Vencimento_Parcela + '</td><td>&nbsp;</td><td align="left">R$ ' + @Valor_parcela + '</td></tr>'
					
					fetch next from cursor_Venc_Valor_parcela into @Vencimento_Parcela, @Valor_parcela 
				END
		close cursor_Venc_Valor_parcela
		DEALLOCATE cursor_Venc_Valor_parcela
    --Fim

	Set @sql= @sql + 
		'</table>
		<br />
		Se o pagamento já foi efetuado, por gentileza, desconsidere este aviso, e se tiver sido via depósito, é necessário o envio do comprovante para baixa em nosso sistema.
		<br />
		Caso contrário, regularize a situação o quanto antes para evitar o bloqueio automático dos atendimentos. Para isso, disponibilizamos abaixo um link do boleto atualizado e com vencimento para pagamento na data de hoje.
		<br />		
		<a href="' + @URL_CorporativoS4E + '/SYS/Mailing/IdentificacaoEmail.aspx?ID=' + @Chave + '" target="_blank">Clique aqui</a> para visualizar e imprimir.
		<br /><br />
		Atenciosamente,'
		
		insert tbSaidaEmail (semEmailRemetente, semEmail, semAssunto, semMensagem, semChave, semDtCadastro, codigo, cd_origeminformacao)
		select @email_faturamento, lower(isnull(tustelefone,'')),'Fatura em aberto - ' + @nome_site, @sql, @Chave, getdate(), @cd_empresa , 3 
		from tb_contato as t
		where t.ttesequencial=50 
		and t.cd_origeminformacao=1 
		and t.cd_sequencial = @cd_associado 
		and t.fl_ativo=1
		
		----------------------------------------------------------------
		--Cópia para faturamento@mdodonto.net
		----------------------------------------------------------------
		if (@LicencaS4E = 'THFIEW74WDESD0905423JHGF87454FRDH65232986560SS009')
			begin
				insert tbSaidaEmail (semEmailRemetente, semEmail, semAssunto, semMensagem, semChave, semDtCadastro, codigo, cd_origeminformacao)
				select @email_faturamento, 'faturamento@mdodonto.net','Fatura em aberto - ' + @nm_fantasia, @sql, @Chave, getdate(), @cd_associado , 1
			end
			
			print 'Associado'
			print @@rowcount
		End
End
