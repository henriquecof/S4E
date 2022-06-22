/****** Object:  Procedure [dbo].[SP_Email_Boleto_Aberto_3_Dias]    Committed by VersionSQL https://www.versionsql.com ******/

create procedure [dbo].[SP_Email_Boleto_Aberto_3_Dias]

as
begin

return

  Declare @nome_site varchar(100)
  Declare @URL_CorporativoS4E varchar(100)
  Declare @email_faturamento varchar(100)
  declare @Vencimento_Parcela varchar(10)
  declare @Valor_parcela varchar(10)  
  Declare @sql varchar(max)
  Declare @sql1 varchar(max)
  Declare @LicencaS4E varchar(50)
  Declare @ChavePJ varchar(50)
  Declare @ChavePF varchar(50)
  Declare @nm_fantasia varchar(500)
  Declare @cd_empresa integer
  Declare @cd_associado integer
  Declare @nm_completo varchar(500)
  declare @Vencimento_ParcelaPF varchar(10)
  declare @Valor_parcelaPF varchar(10)  
  
    
    
  select
  @nome_site = nome_site,
  @URL_CorporativoS4E = URL_CorporativoS4E,
  @email_faturamento = email_faturamento,
  @LicencaS4E = LicencaS4E
  from Configuracao

 		   
	--PJ
    DECLARE cursor_Venc_Valor_parcela_PJ CURSOR FOR 
		select t2.cd_empresa, t2.nm_fantasia, convert(varchar(10), t1.dt_vencimento, 103) as vencimento, isnull(vl_parcela,0) as vl_parcela
		from mensalidades T1, empresa T2, historico T3, situacao_historico T4
		where T1.cd_associado_empresa = T2.cd_empresa
		and t2.cd_sequencial_historico = t3.cd_sequencial
		and T3.cd_situacao = T4.cd_situacao_historico 
		and cd_tipo_recebimento = 0 
		and tp_associado_empresa in (2,3) 
		and dt_pagamento is null
		and datediff(day,T1.dt_vencimento,getdate()) = -3
		and T4.fl_envia_cobranca = 1
    		
		open cursor_Venc_Valor_parcela_PJ
		FETCH NEXT FROM cursor_Venc_Valor_parcela_PJ into @cd_empresa, @nm_fantasia, @Vencimento_Parcela, @Valor_parcela
			WHILE (@@FETCH_STATUS <> -1)
				BEGIN
					
					set @ChavePJ = (select upper(dbo.fn_md5(convert(varchar,isnull(max(semId),0) + 1) + convert(varchar,@cd_empresa) + convert(varchar(10),getdate(),103) + ' ' + convert(varchar(8),getdate(),108))) from tbSaidaEmailBKP)
				
					Set @sql = 'Att. ' + upper(@nm_fantasia) + ' - ' + convert(varchar,@cd_empresa) + '
					<br /><br />
					Prezado Cliente,
					<br /><i>(Esta é uma notificação automática.)</i>
					<br /><br /><br />
					Consta em nosso sistema que a parcela abaixo está perto do seu vencimento:
					<br /><br />
					<table>
					<tr>
					<th align="center">Vencimento</th>
					<th>&nbsp;</th>
					<th align="left">Valor</th>
					</tr>
					<tr><td align="center">' + @Vencimento_Parcela + '</td><td>&nbsp;</td><td align="left">R$ ' + @Valor_parcela + '</td></tr>
					</table>
					<br />
					Se o pagamento já foi efetuado, por gentileza, desconsidere este aviso, e se tiver sido via depósito, é necessário o envio do comprovante para baixa em nosso sistema.
					<br />
					Caso contrário, regularize a situação o quanto antes para evitar o bloqueio automático dos atendimentos. Para isso, disponibilizamos abaixo um link do boleto para impressão.
					<br />		
					<a href="' + @URL_CorporativoS4E + '/SYS/Mailing/IdentificacaoEmail.aspx?ID=' + @ChavePJ + '" target="_blank">Clique aqui</a> para visualizar e imprimir.
					<br /><br />
					Atenciosamente,'
					
				
					--insert tbSaidaEmail (semEmailRemetente, semEmail, semAssunto, semMensagem, semChave, semDtCadastro, codigo, cd_origeminformacao)
					--select @email_faturamento, lower(isnull(tustelefone,'')),'Fatura em aberto - ' + @nome_site, @sql, @ChavePJ, getdate(), @cd_empresa , 3 
					--from tb_contato as t
					--where t.ttesequencial=50 
					--and t.cd_origeminformacao=3 
					--and t.cd_sequencial = @cd_empresa 
					--and fl_ativo=1
					
					insert tbSaidaEmail (semEmailRemetente, semEmail, semAssunto, semMensagem, semChave, semDtCadastro, codigo, cd_origeminformacao)
					select @email_faturamento, 'carlosfilho27@gmail.com', 'Fatura em aberto - ' + @nome_site, @sql, @ChavePJ, getdate(), @cd_empresa , 3 
					
					print @sql
					fetch next from cursor_Venc_Valor_parcela_PJ into @cd_empresa, @nm_fantasia, @Vencimento_Parcela, @Valor_parcela
				END
				
		close cursor_Venc_Valor_parcela_PJ
		DEALLOCATE cursor_Venc_Valor_parcela_PJ
		print 'Empresa'
		print @@rowcount
	----------------------------------------
	
	

	--PF
	DECLARE cursor_Venc_Valor_parcela_PF CURSOR FOR 
		select distinct t1.cd_associado, t1.nm_completo, CONVERT(varchar(10), t4.dt_vencimento, 103) as vencimento, ISNULL(t4.vl_parcela,0) as vl_parcela	
		from associados t1, dependentes t2, historico t3, mensalidades t4, empresa t5, situacao_historico t6, historico t7, situacao_historico t8
		where t1.cd_associado = t2.cd_associado 
		and t1.cd_associado  = t4.cd_associado_empresa
		and t1.cd_empresa = t5.cd_empresa
		and t2.cd_sequencial_historico = t3.cd_sequencial
		and t3.cd_situacao = t6.cd_situacao_historico
		and t5.cd_sequencial_historico = t7.cd_sequencial
		and t7.cd_situacao  = t8.cd_situacao_historico
		and t6.fl_envia_cobranca = 1
		and t8.fl_envia_cobranca = 1
		and t5.fl_online = 1
		and t4.tp_associado_empresa = 1
		and t2.cd_grau_parentesco = 1
		and t4.cd_tipo_recebimento = 0
		and t4.cd_tipo_parcela = 1
		and datediff(day, t4.dt_vencimento, getdate()) = -3 
    		
		open cursor_Venc_Valor_parcela_PF
		FETCH NEXT FROM cursor_Venc_Valor_parcela_PF into @cd_associado, @nm_completo, @Vencimento_ParcelaPF, @Valor_parcelaPF
			WHILE (@@FETCH_STATUS <> -1)
				BEGIN
					
					set @ChavePF = (select upper(dbo.fn_md5(convert(varchar,isnull(max(semId),0) + 1) + convert(varchar,@cd_associado) + convert(varchar(10),getdate(),103) + ' ' + convert(varchar(8),getdate(),108))) from tbSaidaEmailBKP)
				
					Set @sql1 = 'Att. ' + upper(@nm_completo) + ' - ' + convert(varchar,@cd_associado) + '
					<br /><br />
					Prezado Cliente,
					<br /><i>(Esta é uma notificação automática.)</i>
					<br /><br /><br />
					Consta em nosso sistema que a parcela abaixo está perto do seu vencimento:
					<br /><br />
					<table>
					<tr>
					<th align="center">Vencimento</th>
					<th>&nbsp;</th>
					<th align="left">Valor</th>
					</tr>
					<tr><td align="center">' + @Vencimento_ParcelaPF + '</td><td>&nbsp;</td><td align="left">R$ ' + @Valor_parcelaPF + '</td></tr>
					</table>
					<br />
					Se o pagamento já foi efetuado, por gentileza, desconsidere este aviso. Caso contrário, regularize a situação o quanto antes para continuarmos cuidando de sua saúde bucal. Para isso, disponibilizamos abaixo um link do boleto para impressão.
					<br />		
					<a href="' + @URL_CorporativoS4E + '/SYS/Mailing/IdentificacaoEmail.aspx?ID=' + @ChavePF + '" target="_blank">Clique aqui</a> para visualizar e imprimir.
					<br /><br />
					Atenciosamente,'
					
				
					--insert tbSaidaEmail (semEmailRemetente, semEmail, semAssunto, semMensagem, semChave, semDtCadastro, codigo, cd_origeminformacao)
					--select @email_faturamento, lower(isnull(tustelefone,'')),'Fatura em aberto - ' + @nome_site, @sql1, @ChavePF, getdate(), @cd_associado , 1 
					--from tb_contato as t
					--where t.ttesequencial=50 
					--and t.cd_origeminformacao=1 
					--and t.cd_sequencial = @cd_associado 
					--and fl_ativo=1
					
					insert tbSaidaEmail (semEmailRemetente, semEmail, semAssunto, semMensagem, semChave, semDtCadastro, codigo, cd_origeminformacao)
					select @email_faturamento, 'carlosfilho27@gmail.com', 'Fatura em aberto - ' + @nome_site, @sql1, @ChavePF, getdate(), @cd_associado , 1 
					
					print @sql1
					FETCH NEXT FROM cursor_Venc_Valor_parcela_PF into @cd_associado, @nm_completo, @Vencimento_ParcelaPF, @Valor_parcelaPF
				END
				
		close cursor_Venc_Valor_parcela_PF
		DEALLOCATE cursor_Venc_Valor_parcela_PF
		print 'Associados'
		print @@rowcount
	----------------------------------------

End
