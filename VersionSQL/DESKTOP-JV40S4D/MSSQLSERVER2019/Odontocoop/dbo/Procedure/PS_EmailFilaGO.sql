/****** Object:  Procedure [dbo].[PS_EmailFilaGO]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[PS_EmailFilaGO]
AS
Begin
		Declare @RemetenteEmail varchar(205)
		Declare @Nome_Email_Remetente varchar(100)
		Declare @URL_CorporativoS4E varchar(100)
		Declare @LicencaS4E varchar(50)
		Declare @Email_Reply varchar(100)
		Declare @URL_Site varchar(100)

		select @Nome_Email_Remetente = Nome_Email_Remetente,
		       @URL_CorporativoS4E = URL_CorporativoS4E,
		       @LicencaS4E = LicencaS4E,
		       @Email_Reply = Email_Reply,
		       @URL_Site = URL_Site
		from Configuracao
		
		set @RemetenteEmail = @Nome_Email_Remetente + ' <' + @Email_Reply + '>'

		--Transferir os e-mails enviados para a tabela de BKP
		insert into tbSaidaEmailBKP
		select * from tbSaidaEmail where (semDtEnvio is not null or semDtExclusao is not null)
		
		--Deletar os e-mails enviados da tabela de produção
		delete tbSaidaEmail where (semDtEnvio is not null or semDtExclusao is not null)

		SET NOCOUNT ON;

		----Declarando variáveis
		Declare @WL_RowCnt int
		Declare @WL_MaxRows int

		----Declarando variáveis do select
		Declare @WL_semId int
		Declare @WL_semEmail varchar(100)
		Declare @WL_semAssunto varchar(500)
		Declare @WL_semMensagem varchar(max)
		Declare @WL_semChave varchar(100)
		Declare @WL_CorpoMensagem varchar(max)

        --Inicializando contador
		Set @WL_RowCnt = 1

		--Criando arquivo temporario
		Create Table #ArquivoTemp
		(
			RowNum int IDENTITY (1,1) Primary key,
			semId int,
			semEmail varchar(100),
			semAssunto varchar(500),
			semMensagem varchar(max),
			semChave varchar(100)
		)

		--Dados que estão sendo alterados
		Insert into #ArquivoTemp
		(semId, semEmail, semAssunto, semMensagem, semChave)

		select top 40 semId, semEmail, semAssunto, semMensagem, semChave
		from tbSaidaEmail
		where semDtExclusao is null
		and semDtEnvio is null
		order by semId

		--Numero total de registros
		Select @WL_MaxRows = count(*) from #ArquivoTemp

		--Loop enquanto contador menor que numero de registros
		WHILE exists (
						Select semId, isnull(semEmail,'') semEmail, isnull(semAssunto,'') semAssunto, isnull(semMensagem,'') semMensagem, isnull(semChave,'') semChave
						from #ArquivoTemp
						where Rownum <= @WL_MaxRows
						and RowNum = @WL_RowCnt
					)
		Begin
			--Pegando variaveis do registro
			Select
				@WL_semId = semId,
				@WL_semEmail = semEmail,
				@WL_semAssunto = semAssunto,
				@WL_semMensagem = semMensagem,
				@WL_semChave = semChave
			from #ArquivoTemp
			where Rownum <= @WL_MaxRows
			and RowNum = @WL_RowCnt

				Set @WL_CorpoMensagem = ''
				Set @WL_CorpoMensagem = @WL_CorpoMensagem + '<html>' + char(10)
				Set @WL_CorpoMensagem = @WL_CorpoMensagem + '<head>' + char(10)
				Set @WL_CorpoMensagem = @WL_CorpoMensagem + '<title>' + @Nome_Email_Remetente + '</title>' + char(10)
				Set @WL_CorpoMensagem = @WL_CorpoMensagem + '<meta http-equiv="content-type" content="text/html; charset=iso-8859-1" />' + char(10)
				Set @WL_CorpoMensagem = @WL_CorpoMensagem + '</head>' + char(10)
				Set @WL_CorpoMensagem = @WL_CorpoMensagem + '<body bgcolor="#ffffff" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">' + char(10)
				Set @WL_CorpoMensagem = @WL_CorpoMensagem + '<br>' + char(10)
				Set @WL_CorpoMensagem = @WL_CorpoMensagem + '<center>' + char(10)
				Set @WL_CorpoMensagem = @WL_CorpoMensagem + '<table cellpadding="1" cellspacing="1" border="0" bgcolor="#999999">' + char(10)
				Set @WL_CorpoMensagem = @WL_CorpoMensagem + '<tr>' + char(10)
				Set @WL_CorpoMensagem = @WL_CorpoMensagem + '<td bgcolor="#ffffff">' + char(10)
				Set @WL_CorpoMensagem = @WL_CorpoMensagem + '<table width="750" cellpadding="0" cellspacing="0" border="0">' + char(10)
				Set @WL_CorpoMensagem = @WL_CorpoMensagem + '<tr>' + char(10)
				Set @WL_CorpoMensagem = @WL_CorpoMensagem + '<td><img src="' + @URL_CorporativoS4E + '/SYS/Licenca/' + @LicencaS4E + '/Imagens/Logo_Email.gif" width="750" alt="" border="0"></td>' + char(10)
				Set @WL_CorpoMensagem = @WL_CorpoMensagem + '</tr>' + char(10)
				Set @WL_CorpoMensagem = @WL_CorpoMensagem + '<tr>' + char(10)
				Set @WL_CorpoMensagem = @WL_CorpoMensagem + '<td bgcolor="#FFFFFF">' + char(10)
				Set @WL_CorpoMensagem = @WL_CorpoMensagem + '<table width="100%" border="0" cellpadding="20" cellspacing="0">' + char(10)
				Set @WL_CorpoMensagem = @WL_CorpoMensagem + '<tr>' + char(10)
				Set @WL_CorpoMensagem = @WL_CorpoMensagem + '<td align="left"><font color="#000000"><span style="color: #000000; font-size: 13px; font-family: Tahoma, Verdana;">' + char(10)
				Set @WL_CorpoMensagem = @WL_CorpoMensagem + @WL_semMensagem + char(10)
				Set @WL_CorpoMensagem = @WL_CorpoMensagem + '<br /><br />' + char(10)
				Set @WL_CorpoMensagem = @WL_CorpoMensagem + '<b>' + @URL_Site + '</b>' + char(10)
				Set @WL_CorpoMensagem = @WL_CorpoMensagem + '</span></font></td>' + char(10)
				Set @WL_CorpoMensagem = @WL_CorpoMensagem + '</tr>' + char(10)
				Set @WL_CorpoMensagem = @WL_CorpoMensagem + '</table>' + char(10)
				Set @WL_CorpoMensagem = @WL_CorpoMensagem + '</td>' + char(10)
				Set @WL_CorpoMensagem = @WL_CorpoMensagem + '</tr>' + char(10)
				Set @WL_CorpoMensagem = @WL_CorpoMensagem + '</table>' + char(10)
				Set @WL_CorpoMensagem = @WL_CorpoMensagem + '</td>' + char(10)
				Set @WL_CorpoMensagem = @WL_CorpoMensagem + '</tr>' + char(10)
				Set @WL_CorpoMensagem = @WL_CorpoMensagem + '</table>' + char(10)
				Set @WL_CorpoMensagem = @WL_CorpoMensagem + '<br /><br />' + char(10)
				Set @WL_CorpoMensagem = @WL_CorpoMensagem + '<font size="1" color="#000000"><span style="color: #000000; font-size: 9px; font-family: Tahoma, Verdana;">' + char(10)
				Set @WL_CorpoMensagem = @WL_CorpoMensagem + 'Caso deseje cancelar o recebimento de e-mails da ' + @Nome_Email_Remetente + ', acesse o nosso site e altere em seu cadastro essa opção.' + char(10)
				Set @WL_CorpoMensagem = @WL_CorpoMensagem + '</span></font>' + char(10)
				Set @WL_CorpoMensagem = @WL_CorpoMensagem + '</center>' + char(10)
				Set @WL_CorpoMensagem = @WL_CorpoMensagem + '<br>' + char(10)
				Set @WL_CorpoMensagem = @WL_CorpoMensagem + '<img src="' + @URL_CorporativoS4E + '/SYS/Mailing/VisualizacaoEmail.aspx?ID=' + @WL_semChave + '" width="2" height="2" alt="" />' + char(10)
				Set @WL_CorpoMensagem = @WL_CorpoMensagem + '</body>' + char(10)
				Set @WL_CorpoMensagem = @WL_CorpoMensagem + '</html>'
        
				execute PS_EnviaEmail @RemetenteEmail, @WL_semEmail, @Email_Reply, '', '', '', @WL_semAssunto, @WL_CorpoMensagem
				update tbSaidaEmail set semDtEnvio = getdate() where semChave = @WL_semChave

			Set @WL_RowCnt = @WL_RowCnt + 1
		End

		--Excluir arquivo temporario
		Drop Table #ArquivoTemp
End
