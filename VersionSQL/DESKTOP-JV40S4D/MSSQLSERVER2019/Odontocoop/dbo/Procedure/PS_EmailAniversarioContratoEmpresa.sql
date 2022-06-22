/****** Object:  Procedure [dbo].[PS_EmailAniversarioContratoEmpresa]    Committed by VersionSQL https://www.versionsql.com ******/

create PROCEDURE [dbo].[PS_EmailAniversarioContratoEmpresa]

AS
BEGIN

declare @html as varchar(max) = ''
declare @cd_empresa int = 0
declare @emailDestinatario varchar(100)
declare @emailRemetente varchar(100) =  (select email_remetente from configuracao)
declare @chave varchar(50) = Right('00000000000000000000000000000000000000000000000000' + convert(varchar, CAST(RAND() * 99999999 AS INTEGER)) + Right(Year(getdate()), 4) + Right('00' + Month(getdate()), 2) + Right('00' + Day(getdate()), 2) + Right('00' + left(convert(varchar(10), getdate(),108),2), 2) + Right('00' + Right(left(convert(varchar(10), getdate(),108),5),2), 2) + Right('00' + right(convert(varchar(10), getdate(),108),2), 2),50);  
    
   Declare AniversarioContratoEmpresa CURSOR FOR   
        select 
			T1.cd_empresa,           			
			T2.tusTelefone
		from empresa T1
		inner join TB_Contato T2 on T2.cd_sequencial = T1.cd_empresa and T2.tteSequencial = 50 and T2.fl_ativo =1
		inner join HISTORICO t3 on t1.CD_Sequencial_historico = t3.cd_sequencial and t3.CD_SITUACAO = 1
		where T1.fl_online = 1 
		and T2.cd_origeminformacao = 3
		and (   
				T1.NM_RAZSOC like '% ME' 
			 or T1.NM_RAZSOC like '% EIRELI' 
			 or T1.NM_RAZSOC like '% MEI'
			 or T1.NM_RAZSOC like '% Sociedade Unipessoal de Advogados'
			 or	T1.NM_RAZSOC like '% - ME' 
			 or T1.NM_RAZSOC like '% - EIRELI' 
			 or T1.NM_RAZSOC like '% - MEI'
			 or T1.NM_RAZSOC like '% - Sociedade Unipessoal de Advogados'
			 or	T1.NM_RAZSOC like '%-ME' 
			 or T1.NM_RAZSOC like '%-EIRELI' 
			 or T1.NM_RAZSOC like '%-MEI'
			 or T1.NM_RAZSOC like '%-Sociedade Unipessoal de Advogados'
			 )
	    and (right('00'+ convert(varchar,day(T1.DT_FECHAMENTO_CONTRATO)),2)+ '/' +
		     right('00'+ convert(varchar, + month(T1.DT_FECHAMENTO_CONTRATO)),2)+ '/' +
			 convert(varchar,year(getdate()))) = CONVERT(varchar(10), getdate(),103)
	    
		group by T1.cd_empresa, T2.tusTelefone
		order by T1.cd_empresa
			
    open AniversarioContratoEmpresa
    
   fetch next from AniversarioContratoEmpresa into @cd_empresa, @emailDestinatario
   
   while (@@fetch_status<>-1) 
   begin

			set	@html  =' Prezado Cliente,<br/><br/>                                                                '
			set	@html +=' A ANS (Agência Nacional de Saúde) editou a Resolução Normativa nº 432/2017 que            '
			set	@html +=' trata da contratação de plano coletivo empresarial por empresário individual (MEI, ME,    '
			set	@html +=' EPP). Diante desta resolução eles passaram a exigir o seguinte:<br/><br/>                 '
			set	@html +=' O § 2º do art. 2º da Resolução diz que para a manutenção do contrato coletivo             '
			set	@html +=' empresarial, o empresário individual deverá conservar a sua inscrição nos órgãos          '
			set	@html +=' competentes, bem como sua regularidade cadastral junto à Receita Federal, de acordo com   '
			set	@html +=' sua forma de constituição. Ou seja, no aniversário do contrato a empresa é obrigada a     '
			set	@html +=' apresentar para a Qualidonto a mesma documentação comprobatória na adesão que são:        '
			set	@html +=' Cartão CNPJ (situação ativo) e comprovação na Junta Comercial.<br/><br/>                  '
			set	@html +=' Verificada a ilegitimidade do contratante no aniversário do contrato, a Qualidonto        '
			set	@html +=' poderá rescindir o contrato, desde que realize a notificação prévia com 60 (sessenta) dias'
			set	@html +=' de antecedência, informando que a rescisão será realizada se não for comprovada, neste    '
			set	@html +=' prazo, a regularidade do seu registro nos órgãos competentes.<br/><br/>                   '
			set	@html +=' Por se tratar de uma obrigação exigida pelo nosso órgão regulador ANS, contamos           '
			set	@html +=' com a compreensão e colaboração!<br/><br/>                                                '
			set	@html +=' Cordialmente,<br/><br/>                                                                   '
			set	@html +=' Qualidonto<br/><br/>                                                                      '
								
			INSERT INTO tbSaidaEmail (semEmailRemetente, cd_origeminformacao, codigo, semEmail, semAssunto, semMensagem, semChave, semDtCadastro, semTipoMensagem, semPrioridadeMensagem, semAssinaturaMensagem, semMensagemConfidencial)
			VALUES (@emailRemetente, --semEmailRemetente
					3, --cd_origeminformacao
					@cd_empresa, --codigo
					@emailDestinatario , --semEmail
					'Aniversário Contrato Empresa', --semAssunto
					@html,--semMensagem
					@chave, --semChave
					getdate(), --semDtCadastro  
					2, --semTipoMensagem
					1, --semPrioridadeMensagem
					1, --semAssinaturaMensagem
					0 --semMensagemConfidencial
			); 
 
     fetch next from AniversarioContratoEmpresa into @cd_empresa, @emailDestinatario
   End 
   
   Close AniversarioContratoEmpresa
   Deallocate AniversarioContratoEmpresa
        
END
