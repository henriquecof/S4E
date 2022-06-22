/****** Object:  Function [dbo].[FF_ANSValidarNome]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE FUNCTION [dbo].[FF_ANSValidarNome](@nomeCompleto varchar(200))
RETURNS bit 
Begin

	Declare @nomes varchar(200) = @nomeCompleto
	Declare @individual varchar(20) = null
	Declare @countNomes int = 0
	Declare @primeiroNome varchar(20) = null
	Declare @primeiroNomeSemAcento varchar(20) = null
	Declare @ultimoNome varchar(20) = null
	Declare @ultimoNomeSemAcento varchar(20) = null

	WHILE LEN(@nomes) > 0
	BEGIN
		IF PATINDEX('% %',@nomes) > 0
		BEGIN
			SET @individual = SUBSTRING(@nomes, 0, PATINDEX('% %',@nomes))
			--SELECT @individual
			SET @nomes = SUBSTRING(@nomes, LEN(@individual + '|') + 1, LEN(@nomes))
			
			--contando quantidade de nomes
			set @countNomes += 1
			--primeiro nome
			if(@primeiroNome is null)
				set @primeiroNome = @individual
			-----Validações-----
			--------------------
			--(caracteres nao permitidos)	
			if((dbo.InStr('0', @individual) > 0) 
				or (dbo.InStr('1', @individual) > 0) 
				or (dbo.InStr('2', @individual) > 0) 
				or (dbo.InStr('3', @individual) > 0) 
				or (dbo.InStr('4', @individual) > 0) 
				or (dbo.InStr('5', @individual) > 0) 
				or (dbo.InStr('6', @individual) > 0) 
				or (dbo.InStr('7', @individual) > 0) 
				or (dbo.InStr('8', @individual) > 0) 
				or (dbo.InStr('9', @individual) > 0)
				or (dbo.InStr('@', @individual) > 0)
				or (dbo.InStr('"', @individual) > 0)
				or (dbo.InStr('*', @individual) > 0)
				or (dbo.InStr('/', @individual) > 0)
				or (dbo.InStr('{', @individual) > 0)
				or (dbo.InStr('}', @individual) > 0)
				or (dbo.InStr('$', @individual) > 0)
				or (dbo.InStr('^', @individual) > 0)
				or (dbo.InStr('[', @individual) > 0)
				or (dbo.InStr(']', @individual) > 0)
				or (dbo.InStr('\', @individual) > 0)
				or (dbo.InStr('&', @individual) > 0)
				or (dbo.InStr('!', @individual) > 0)
				or (dbo.InStr('=', @individual) > 0)
				or (dbo.InStr('?', @individual) > 0)
				or (dbo.InStr('+', @individual) > 0)
				or (dbo.InStr('<', @individual) > 0)
				or (dbo.InStr('>', @individual) > 0)
				or (dbo.InStr('(', @individual) > 0)
				or (dbo.InStr(')', @individual) > 0)
				or (dbo.InStr('%', @individual) > 0)
				or (dbo.InStr('.', @individual) > 0)
				or (dbo.InStr(';', @individual) > 0)
				or (dbo.InStr('#', @individual) > 0)
				or (dbo.InStr('~', @individual) > 0)
				or (dbo.InStr(',', @individual) > 0)
			)
				return 0
				
			-----Validações-----
			--------------------
			--(abreviação)
			if ((@individual <> @primeiroNome) and (LEN(@individual) = 1) and (@individual <> 'e' and @individual <> 'y'))
				return 0
		END
		ELSE
		BEGIN
			SET @individual = @nomes
			SET @nomes = NULL
			--SELECT @individual
			
			--contando quantidade de nomes
			set @countNomes += 1
			--ultimo nome
			set @ultimoNome = @individual
			-----Validações-----
			--------------------
			--(caracteres nao permitidos)	
			if((dbo.InStr('0', @individual) > 0) 
				or (dbo.InStr('1', @individual) > 0) 
				or (dbo.InStr('2', @individual) > 0) 
				or (dbo.InStr('3', @individual) > 0) 
				or (dbo.InStr('4', @individual) > 0) 
				or (dbo.InStr('5', @individual) > 0) 
				or (dbo.InStr('6', @individual) > 0) 
				or (dbo.InStr('7', @individual) > 0) 
				or (dbo.InStr('8', @individual) > 0) 
				or (dbo.InStr('9', @individual) > 0)
				or (dbo.InStr('@', @individual) > 0)
				or (dbo.InStr('"', @individual) > 0)
				or (dbo.InStr('*', @individual) > 0)
				or (dbo.InStr('/', @individual) > 0)
				or (dbo.InStr('{', @individual) > 0)
				or (dbo.InStr('}', @individual) > 0)
				or (dbo.InStr('$', @individual) > 0)
				or (dbo.InStr('^', @individual) > 0)
				or (dbo.InStr('[', @individual) > 0)
				or (dbo.InStr(']', @individual) > 0)
				or (dbo.InStr('\', @individual) > 0)
				or (dbo.InStr('&', @individual) > 0)
				or (dbo.InStr('!', @individual) > 0)
				or (dbo.InStr('=', @individual) > 0)
				or (dbo.InStr('?', @individual) > 0)
				or (dbo.InStr('+', @individual) > 0)
				or (dbo.InStr('<', @individual) > 0)
				or (dbo.InStr('>', @individual) > 0)
				or (dbo.InStr('(', @individual) > 0)
				or (dbo.InStr(')', @individual) > 0)
				or (dbo.InStr('%', @individual) > 0)
				or (dbo.InStr('.', @individual) > 0)
				or (dbo.InStr(';', @individual) > 0)
				or (dbo.InStr('#', @individual) > 0)
				or (dbo.InStr('~', @individual) > 0)
				or (dbo.InStr(',', @individual) > 0)
			)
				return 0
		END
	END
	
	--select @primeiroNome , @ultimoNome
	
	-----Validações-----
	--------------------
	--(Nome com apenas uma palavra)
	If(@countNomes <= 1)
	Begin
		return 0
	End
	--(Primeiro nome com apenas uma letra, exceto quando o primeiro nome for: D, I, O, U, Y (com ou sem acento))
	set @primeiroNomeSemAcento = dbo.FF_TiraAcento(@primeiroNome)
	if((LEN(@primeiroNome) = 1) and (@primeiroNomeSemAcento <> 'D' and @primeiroNomeSemAcento <> 'I' and @primeiroNomeSemAcento <> 'U' and @primeiroNomeSemAcento <> 'Y'))
	Begin
		return 0
	end
	--(Último nome com apenas uma letra, exceto quando o último nome for: I, O, U, Y (com ou sem acento))
	set @ultimoNomeSemAcento = dbo.FF_TiraAcento(@ultimoNome)
	if((LEN(@ultimoNome) = 1) and (@ultimoNomeSemAcento <> 'I' and @ultimoNomeSemAcento <> 'O' and @ultimoNomeSemAcento <> 'U' and @ultimoNomeSemAcento <> 'Y'))
	Begin
		return 0
	end
	
	return 1

End
