/****** Object:  Procedure [dbo].[PS_EnviaEmail]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[PS_EnviaEmail]
	@From varchar(200),
	@To varchar(500),
	@ReplyTo varchar(200) = '',
	@Cc varchar(200) = '',
	@BCc varchar(200) = '',
	@SMTPServer varchar(100) = '',
	@Subject varchar(200) = '',
	@Body varchar(max) = ''
	AS
SET NOCOUNT ON

	BEGIN
		Declare @hr int
		Declare @iMsg int
		Declare @source varchar(255)
		Declare @description varchar(500)
		Declare @output varchar(1000)

		Set @SMTPServer = 'Localhost'

		--Create the CDO.Message Object
		EXEC @hr = sp_OACreate 'CDO.Message', @iMsg OUT
           
		IF @hr = 0 --Se o objeto foi criado
			BEGIN
				--Configure the Remote Server Name or IP address
				EXEC @hr = sp_OASetProperty @iMsg, 'Configuration.fields("http://schemas.microsoft.com/cdo/configuration/sendusing").Value','2'
				EXEC @hr = sp_OASetProperty @iMsg, 'Configuration.fields("http://schemas.microsoft.com/cdo/configuration/smtpserver").Value', @SMTPServer
				--Save the configurations to the message object
				EXEC @hr = sp_OAMethod @iMsg, 'Configuration.Fields.Update', null

				--Set the e-mail parameters
				EXEC @hr = sp_OASetProperty @iMsg, 'To', @To
				EXEC @hr = sp_OASetProperty @iMsg, 'ReplyTo', @ReplyTo
				EXEC @hr = sp_OASetProperty @iMsg, 'Cc', @Cc
				EXEC @hr = sp_OASetProperty @iMsg, 'BCc', @BCc
				EXEC @hr = sp_OASetProperty @iMsg, 'From', @From
				EXEC @hr = sp_OASetProperty @iMsg, 'Subject', @Subject
				EXEC @hr = sp_OASetProperty @iMsg, 'HTMLBody', @Body  --'HTMLBody' or 'TextBody'
				EXEC @hr = sp_OAMethod @iMsg, 'Send', NULL
				IF @hr <> 0
				   print 'Erro no Send' 

			END

		IF @hr <> 0
		   BEGIN
			 EXEC @hr = sp_OAGetErrorInfo NULL, @source OUT, @description OUT
			 IF @hr = 0
			   BEGIN
				 SELECT @output = ' Source: ' + @source
				 PRINT @output
				 SELECT @output = ' Description: ' + @description
				 PRINT @output
			   END
			 ELSE
			   BEGIN
				 PRINT ' sp_OAGetErrorInfo failed'
				 RETURN
			 END
		   END
		ELSE
			BEGIN
				PRINT @To + ' - ' + @Subject
			END

		EXEC @hr = sp_OADestroy @iMsg
	END

SET NOCOUNT OFF
