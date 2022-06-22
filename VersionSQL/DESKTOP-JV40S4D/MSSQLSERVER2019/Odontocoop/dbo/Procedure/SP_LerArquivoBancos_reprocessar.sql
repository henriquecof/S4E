/****** Object:  Procedure [dbo].[SP_LerArquivoBancos_reprocessar]    Committed by VersionSQL https://www.versionsql.com ******/

create Procedure [dbo].[SP_LerArquivoBancos_reprocessar] (@sequencial int) 
as
Begin -- 1

   --- Observar o Campo Recorrente (Ajustar Codigo)

   -----------------------------------------------------------
   -- Ambiente Programação
   -----------------------------------------------------------
   Set Quoted_Identifier Off
   Set Nocount On

   -----------------------------------------------------------
   -- Declaração de variaveis
   -----------------------------------------------------------
   Declare @Caminho varchar(200)
   Declare @Arquivo varchar (50)=null
   Declare @linha varchar(1000)

   -----------------------------------------------------------
   -- Corpo de programa
   -----------------------------------------------------------
   --recebe o caminho que vai conter os arquivos H:\ foi substituido por \\dados\areas$
    Select top 1 @caminho = pasta_site from configuracao -- Verificar o caminho a ser gravado os arquivos
    IF @@ROWCOUNT = 0
    Begin -- 1.1
	  Raiserror('Pasta dos Arquivos não definida.',16,1)
	  RETURN
    End -- 1.1
  
    set @caminho = @caminho + '\arquivos\banco'
    
    --print @caminho
    
    select @arquivo=nm_arquivo from Lote_Processos_Bancos_Retorno where cd_sequencial_retorno=@sequencial
    if isnull(@arquivo,'')<>''
    Begin 
		-- Movendo arquivos lidos para outro local
		Set @linha = 'move /y "' + @caminho + '\retorno_processados\'+@arquivo+'" "' + @caminho + '\retorno\'+@arquivo+'"'
		EXEC SP_Shell @linha , 0 

		exec SP_LerArquivoBancos
    End 
              
End --1
