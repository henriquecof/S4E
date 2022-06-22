/****** Object:  Procedure [dbo].[SP_LerArquivoBancos_downloads]    Committed by VersionSQL https://www.versionsql.com ******/

create Procedure [dbo].[SP_LerArquivoBancos_downloads] 
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
   Declare @Arquivo varchar (50)
   Declare @Min int
   Declare @Max int
   Declare @linha varchar(1000)
   Declare @fl_existeArquivo smallint = 0 

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

   -- Criação da tabela que vai receber os
   -- nomes dos arquivos que vão ser lidos
   Create Table #tmp (out Varchar (1000))

   -- Formação do comando que será usado no DOS para listar os arquivos
   Set @linha = 'dir ' + @caminho + '\downloads\*.* /b'

   -- Insere os arquivos dentro da tabela para usar depois
   Insert Into #tmp (out)   
   Exec xp_cmdshell @linha

   -- apaga registros que não tem arquivo 
   Delete From #tmp Where out is null

   -- Altera a tabela para colocar coluna com auto incremento, para controle
   Alter Table #tmp Add id Int Identity (1,1)

   --Delete from Import

   -- Configurações para repetição
   Select @min = min(id), @max = max(id) From #tmp 
   While @min <= @max
     Begin -- inicio 1 begin

        Set @fl_existeArquivo = 1 
        
		-- Passa por cada arquivo
		Select @arquivo = rtrim(ltrim(out)) from #tmp where id = @min

        print '*********'
        print @arquivo
        print '*********'

      -- Movendo arquivos lidos para outro local
      Set @linha = 'move /y "' + @caminho + '\downloads\'+@arquivo+'" "' + @caminho + '\retorno\'+@arquivo+'"'
      EXEC SP_Shell @linha , 0 

      -- incrementa variável de controle para passar para o próximo arquivo
      Set @min = @min + 1
      
     End -- fim 1

     -- drop da tabela temporária usada
     Drop table #tmp
     
     if @fl_existeArquivo=1 
        exec SP_LerArquivoBancos
   
              
End --1
