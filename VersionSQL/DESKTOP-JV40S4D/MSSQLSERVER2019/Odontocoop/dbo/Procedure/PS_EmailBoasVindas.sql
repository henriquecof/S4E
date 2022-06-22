/****** Object:  Procedure [dbo].[PS_EmailBoasVindas]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[PS_EmailBoasVindas]

AS
BEGIN
declare @html as varchar(max) = ''
declare @codigo int = 0
declare @nome varchar(100)
declare @caminho varchar(100) =  (select url_corporativoS4E+'/SYS/' from configuracao)
declare @licenca varchar(100) = (select LicencaS4E from configuracao)
declare @emailDestinatario varchar(100)
declare @emailRemetente varchar(100) =  (select email_remetente from configuracao)
declare @chave varchar(50) = Right('00000000000000000000000000000000000000000000000000' + convert(varchar, CAST(RAND() * 99999999 AS INTEGER)) + Right(Year(getdate()), 4) + Right('00' + Month(getdate()), 2) + Right('00' + Day(getdate()), 2) + Right('00' + left(convert(varchar(10), getdate(),108),2), 2) + Right('00' + Right(left(convert(varchar(10), getdate(),108),5),2), 2) + Right('00' + right(convert(varchar(10), getdate(),108),2), 2),50);  
  
   Declare cursor_empresa CURSOR FOR   
        select top 1 
			d.CD_ASSOCIADO,           
			d.NM_DEPENDENTE, 
			T2.tusTelefone
	  from DEPENDENTES as d inner join ASSOCIADOS as a on d.CD_ASSOCIADO=a.cd_associado
			  inner join empresa as e on a.cd_empresa = e.cd_empresa
			  inner join TB_Contato T2 on T2.cd_sequencial = a.cd_associado and T2.tteSequencial = 50 and T2.fl_ativo =1
	 where CD_GRAU_PARENTESCO=1
	   and dt_assinaturaContrato>=DATEADD(day,-30,getdate())
	   and dt_assinaturaContrato<=DATEADD(day,-15,getdate())
	   and d.CD_ASSOCIADO not in (select id_erp_crm from tb_Izzy where cd_campanha in (105,115,125,135,146,155))
	   and d.cd_sequencial not in (select ChaSolicitante from CRMChamado where mdeid=460 and tsoId = 2 and chaDtCadastro>=DATEADD(day,-60,GETDATE()))
	   and A.cd_associado not in (select ChaSolicitante from CRMChamado where mdeid=460 and tsoId = 7 and chaDtCadastro>=DATEADD(day,-60,GETDATE()))
	   and a.cd_associado not in (select codigo from tbSaidaEmail where SemAssunto='ODONTOGROUP BOAS VINDAS' and cd_origeminformacao=3)
	   and a.cd_associado not in (select codigo from tbSaidaEmailbkp where SemAssunto='ODONTOGROUP BOAS VINDAS' and cd_origeminformacao=3)
	   and e.tp_empresa in (3,8)
			
    open cursor_empresa
    
   fetch next from cursor_empresa into @codigo, @nome, @emailDestinatario 
   
   while (@@fetch_status<>-1) 
   begin
   
       Set @emailDestinatario = 'cassio.cacau@s4e.com.br' 
       
	   if @codigo > 0
	   begin
			set @html = '<b>Prezado (a) Associado (a)</b>
			<br><br>
            Seja bem-vindo (a) a um dos melhores planos de assistência odontológica do mercado. Agora você pode contar com a segurança da OdontoGroup.
            <br><br>
            Tentamos contato com o (a) senhor (a) para confirmar alguns dados do seu cadastro, porém não obtivemos sucesso.
            <br><br>
            Sua solicitação de adesão foi registrada em nosso sistema e já encaminhamos ao seu e-mail o Guia de Leitura Contratual com as orientações quanto ao plano contratado, ele é de leitura obrigatória.
            <br><br>
            Para o acesso a sua carteirinha, baixe nosso APP através do Apple Store (iOS) ou Play Store (Android).
            <br><br>
            <b>Faça seu primeiro acesso ao APP:</b>
            <br><br>
            Login: CPF completo 
            <br><br>
            Senha: a primeira letra do nome e os 3 dígitos do CPF
            <br><br>
            <b>Rede de Atendimento:</b>
            <br><br>
            Basta acessar o aplicativo através de seu celular e localizar a clínica mais próxima. Também você poderá acessar a área restrita do associado pelo portal  www.odontogroup.com.br e visualizar a sua rede de atendimento. O sistema irá disponibilizar a relação de clínicas credenciadas com nome, endereço e telefone de contato. Aí é só entrar em contato com a clínica e agendar sua consulta.
            <br><br>
            Caso necessite responder este e-mail, por gentileza encaminhar para atendimento@odontogroup.com.br.
            <br><br>
            Se tiver alguma dúvida entre em contato por meio do nosso SAC, através dos números (61) 3421 0000 (Brasília/DF), 4007 1087 (outras capitais), 0800 704 3663 (demais localidades) ou através da área restrita do associado em nosso site www.odontogroup.com.br  ou baixe nosso APP através do Apple Store (iOS) ou Play Store (Android). Nosso horário de atendimento é de 2ª a 6ª feira, das 8h às 18h horário de Brasília/DF.
            <br><br>
            <br><br>  
            Atenciosamente,<br>
            <b>OdontoGroup Sistema de Saúde</b>'

			
			INSERT INTO tbSaidaEmail (semEmailRemetente, cd_origeminformacao, codigo, semEmail, semAssunto, semMensagem, semChave, semDtCadastro, semTipoMensagem, semPrioridadeMensagem, semAssinaturaMensagem, semMensagemConfidencial)
			VALUES (@emailRemetente, --semEmailRemetente
					1, --cd_origeminformacao
					@codigo, --codigo
					@emailDestinatario , --semEmail
					'ODONTOGROUP BOAS VINDAS', --semAssunto
					@html,--semMensagem
					@chave, --semChave
					getdate(), --semDtCadastro  
					null, --semTipoMensagem
					1, --semPrioridadeMensagem
					1, --semAssinaturaMensagem
					0 --semMensagemConfidencial
			); 
		end 	     
     fetch next from cursor_empresa into @codigo, @nome, @emailDestinatario 
   End 
   
   Close cursor_empresa
   Deallocate cursor_empresa
   
  -- print @html
     
END
