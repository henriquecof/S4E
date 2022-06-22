/****** Object:  Procedure [dbo].[SP_LerArquivoSPC]    Committed by VersionSQL https://www.versionsql.com ******/

Create Procedure [dbo].[SP_LerArquivoSPC] 
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
   Declare @linha_aux varchar(1000) 
   
   Declare @qtde int = 0 
   Declare @pos_ini int
   Declare @pos_fim int
   Declare @CPF_CNPJ varchar(24)  
   Declare @dt_leitura datetime
   
   Set @dt_leitura = CONVERT(varchar(10),getdate(),101)
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
  
    set @caminho = @caminho + '\arquivos\SPC'

   -- Criação da tabela que vai receber os
   -- nomes dos arquivos que vão ser lidos
   Create Table #tmp (out Varchar (1000))

   -- Formação do comando que será usado no DOS para listar os arquivos
   Set @linha = 'dir ' + @caminho + '\leitura\*.* /b'
   
   print @linha

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

		-- Passa por cada arquivo
		Select @arquivo = rtrim(ltrim(out)) from #tmp where id = @min

        print '*********'
        print @arquivo
        print '*********'

        -- Limpa a tabela 
        delete SPC_IMP

        -- 
        IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'import') AND type in (N'U'))
            DROP TABLE Import_SPC
        
        CREATE TABLE Import_SPC(linha varchar(5000) NULL) 

		--Bulk insert TB_TabelaCaixa From @arquivo
     	SET @linha = 'BULK INSERT Import_SPC FROM ''' + @Caminho + '\leitura\' + @arquivo + ''' WITH (KEEPIDENTITY) '
     	print @linha 
		Exec(@linha)

	  --============================================================================
	  -- Lendo registros do arquivo     
	  --============================================================================
      Declare  Dados_Cursor  cursor for  
	  Select replace(linha,'"','') from Import_SPC
      Open Dados_Cursor
      Fetch next from Dados_Cursor Into  @linha
      While (@@fetch_status  <> -1)
		Begin -- Inicio 2
        
          print @linha 

          if PATINDEX('%|%',@linha)=0 
           Begin -- 2.2
           
             select @qtde = COUNT(0) from SPC_IMP
             if @qtde <> convert(int,@linha)
             Begin
             
                print @qtde
                
                Close Dados_Cursor
                Deallocate Dados_Cursor				             
                delete SPC_IMP
			    RAISERROR ('Erro na importação do SPC.', 16, 1)               
			    return
			 End   
           End

           if dbo.SepararPalavra('|',1,@linha)<>'CONSUMIDOR' and PATINDEX('%|%',@linha)>0 
           Begin

             Set @pos_ini = PATINDEX('%(%',@linha)
             Set @pos_fim = PATINDEX('%)%',@linha)-@pos_ini-1
             Select @CPF_CNPJ = replace(replace(replace(substring(@linha,@pos_ini+1,@pos_fim),'.',''),'-',''),'/','')

             insert SPC_IMP(CONSUMIDOR,CPF_CNPJ,ASSOCIADO,DATA_INCLUSAO,CONTRATO,DATA_VENCIMENTO,DATA_COMPRA,VALOR,ORIGEM_INCLUSAO,DATA_LIQUIDACAO,ORIGEM_EXCLUSAO,dt_leitura)
             values (dbo.SepararPalavra('|',1,@linha), @CPF_CNPJ, 
                     dbo.SepararPalavra('|',2,@linha),
                     dbo.ff_data_mm_dd_yyyy(dbo.SepararPalavra('|',3,@linha)),
                     dbo.SepararPalavra('|',4,@linha),
                     dbo.ff_data_mm_dd_yyyy(dbo.SepararPalavra('|',5,@linha)),
                     dbo.ff_data_mm_dd_yyyy(dbo.SepararPalavra('|',6,@linha)),
                     replace(replace(dbo.SepararPalavra('|',7,@linha),'.',''),',','.'),
                     dbo.ff_data_mm_dd_yyyy(dbo.SepararPalavra('|',8,@linha)),
                     case when dbo.SepararPalavra('|',9,@linha) ='' then null else dbo.ff_data_mm_dd_yyyy(dbo.SepararPalavra('|',9,@linha)) end,
                     case when dbo.SepararPalavra('|',10,@linha) ='' then null else dbo.SepararPalavra('|',10,@linha) end,
                     @dt_leitura)
                     

                if @@ROWCOUNT = 0 
				begin -- 2.3.2
                    Close Dados_Cursor
                    Deallocate Dados_Cursor				
					delete SPC_IMP
					RAISERROR ('Erro na importação do SPC.', 16, 1)               
					return

                end -- 2.3.2   
                
          End      
          
		  --- Proximo registro
		  Fetch next from Dados_Cursor Into  @linha

		End --Fim 2
 
      Close Dados_Cursor
      Deallocate Dados_Cursor
 
      -- Movendo arquivos lidos para outro local
      Set @linha = 'move /y "' + @caminho + '\leitura\'+@arquivo+'" "' + @caminho + '\processados\'+@arquivo+'"'
      EXEC SP_Shell @linha , 0 

      -- incrementa variável de controle para passar para o próximo arquivo
      Set @min = @min + 1
      
     End -- fim 1

     -- drop da tabela temporária usada
     Drop table #tmp
   
              
End --1
