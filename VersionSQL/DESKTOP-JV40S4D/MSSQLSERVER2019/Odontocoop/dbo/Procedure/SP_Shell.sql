/****** Object:  Procedure [dbo].[SP_Shell]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE Procedure [dbo].[SP_Shell] 
  @comando varchar(8000),
  @retorno bit = 1 
As 
Begin

  Declare @retEcho INT --variavel para verificar se o comando foi executado com exito ou ocorreu alguma falha 
  
  Set @comando = REPLACE(@comando,'&',' ')
  Set @comando = REPLACE(@comando,'''',' ')
  
  print @comando
  EXEC @retEcho = MASTER..XP_CMDSHELL @comando, NO_OUTPUT --NO_OUTPUT indica que o comando não irá retornar alguma possível mensagem na sua execução 
  IF @retEcho <> 0 and @retorno=1
	Begin -- 2.2
      Set @comando = 'Erro na execução do Comando. (' + @comando + ')'
	  Raiserror(@comando,16,1)
	  RETURN
	End -- 2.2

End 
