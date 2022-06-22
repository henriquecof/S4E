/****** Object:  Procedure [dbo].[SP_LerArquivoBancos_s4e]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE Procedure [dbo].[SP_LerArquivoBancos_s4e] 
as
Begin -- 1
/**
	Ticket 6429: Correção do envio de email. Não estava considerando os deb_automatico_cr com fl_entradaconfirmada = 1
**/
   --- Observar o Campo Recorrente (Ajustar Codigo)

   -----------------------------------------------------------
   -- Ambiente Programação
   -----------------------------------------------------------
   Set Quoted_Identifier Off
   Set ARITHABORT On
   Set ANSI_PADDING On
   Set Nocount On

   -----------------------------------------------------------
   -- Declaração de variaveis
   -----------------------------------------------------------
   Declare @Caminho varchar(300)
   Declare @Arquivo varchar (500)
   Declare @Min int
   Declare @Max int
   Declare @linha varchar(1000)
   Declare @linha_aux varchar(1000) 

   Declare @sequencial_retorno int 
   Declare @cd_tipo_servico_bancario int
   Declare @cd_tipo_pagamento smallint 
   Declare @nsa int 
   Declare @convenio varchar(20)
   Declare @WL_Sit int 

   Declare @cd_parcela int 
   Declare @cd_tipo_recebimento int 
   Declare @nosso_numero varchar(500)
   Declare @nn varchar(500)
   Declare @erro int  -- Identifica se o arquivo possui algum erro 
   Declare @qtde_parcelas int 
   Declare @cd_ocorrencia int 
   Declare @dt_Vencimento datetime 
   Declare @dt_prevista_credito date
   Declare @despreza      smallint 

   ----------------------------------
   -- Variaveis de Baixa dos Boletos agrupados
   ----------------------------------
   Declare @qt_agrupada smallint
   Declare @qt_aberta smallint 
   Declare @qt_excluida smallint 
   Declare @qt_acordo smallint 
   Declare @qt_baixada smallint 
   Declare @parcelamae int
   Declare @parcelamae_ant int    
   
   ----------------------------------
   -- Variaveis do CRM
   ----------------------------------
	DECLARE @WL_UsuarioSYS varchar(4)
	DECLARE @WL_chaId int
	DECLARE @WL_data varchar(20)
	DECLARE @WL_hora varchar(20)
	DECLARE @WL_cd_dependente int
	DECLARE @WL_protocolo varchar(50)
	DECLARE @WL_chave varchar(50)
	DECLARE @WL_dsOcorrencia varchar(600)
	DECLARE @WL_rand varchar(7)
	Declare @faixa int 
	set  @WL_UsuarioSYS = 7021

   ----------------------------------
   -- Variaveis do Cursor de Baixa
   ----------------------------------
   Declare @dt_pago datetime 
   Declare @vl_parcela money , @vl_multa money , @vl_desconto money , @vl_pago money , @vl_tarifa money 
   
   Declare @qtde int
   Declare @valor money

   --- Funcionario da Baixa
   Declare @cd_funcionario int 
   select @cd_funcionario = cd_funcionario from processos where cd_processo = 3 
   if @cd_funcionario is null 
   Begin 
	  Raiserror('Funcionário para baixa não definido.',16,1)
	  RETURN     
   End 

   -----------------------------------------------------------
   -- Corpo de programa
   -----------------------------------------------------------
   --recebe o caminho que vai conter os arquivos H:\ foi substituido por \\dados\areas$
    --Select top 1 @caminho = pasta_site from configuracao -- Verificar o caminho a ser gravado os arquivos
    Select top 1 @caminho = Pasta_Site_SQL from configuracao -- Verificar o caminho a ser gravado os arquivos
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
   Set @linha = 'dir ' + @caminho + '\retorno\*.* /b'

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

 	    --Inicializa as variaveis do arquivo 
 	    Set @cd_tipo_servico_bancario = 0   
 	    Set @cd_tipo_pagamento = 0 
	    Set @nsa = 0 
	    Set @convenio = 0 

        -- 
        IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'import') AND type in (N'U'))
            DROP TABLE Import
        
        CREATE TABLE Import(linha varchar(5000) NULL) 

		--Bulk insert TB_TabelaCaixa From @arquivo
     	SET @linha = 'BULK INSERT Import FROM ''' + @Caminho + '\retorno\' + @arquivo + ''' WITH (KEEPIDENTITY, rowterminator=''0x0a'') ' --- Caracter finalizador da linha LF (line feed)
     	print @linha 
		Exec(@linha)

	  --============================================================================
	  -- Lendo registros do arquivo     
	  --============================================================================
      Declare  Dados_Cursor  cursor for  
	  Select replace(linha,'"','') from Import
      Open Dados_Cursor
      Fetch next from Dados_Cursor Into  @linha
      While (@@fetch_status  <> -1)
		Begin -- Inicio 2
        
          print @linha 
          
          if @cd_tipo_servico_bancario = 0 
          Begin -- 2.1 
             
             Set @qtde=0 
             Set @valor = 0 

             if rtrim(substring(@linha,4,5))='00000' and rtrim(substring(@linha,143,1))='2' 
             and Upper(rtrim(substring(@linha,1,3)))='033'
             and Upper(rtrim(substring(@linha,39,9)))='130038500'
             Begin -- 2.2.1
                set @cd_tipo_servico_bancario=-1
                print 'Arquivo deve ser lido na rotina da odontocob'
                  --- gravar erro CRM Processo 4 (Tipo de Pagamento nao localizado para convenio e banco)
                  Close Dados_Cursor
                  Deallocate Dados_Cursor
                  return
             End -- 2.2.1  

             --if Upper(rtrim(substring(@linha,82,17)))='DEBITO AUTOMATICO' and substring(@linha,1,1)='A'
             --Begin -- 2.1.1
             --   set @cd_tipo_servico_bancario=6 
             --   print @cd_tipo_servico_bancario
                
             --   if substring(@linha,2,1)<>'2' -- Arquivo nao é de retorno
             --   Begin -- 2.1.1.1
             --     --- gravar erro CRM Processo 4 (Arquivo nao é de retorno)
             --     Close Dados_Cursor
             --     Deallocate Dados_Cursor
             --     return
             --   End -- 2.1.1.1

             --   set @convenio = rtrim(substring(@linha,3,20))
             --   set @nsa = convert(int,(substring(@linha,74,6)))
                
                           
             --   select @cd_tipo_pagamento = cd_tipo_pagamento  -- Descobrir qual o tipo de pagamento
             --    from tipo_pagamento 
             --    where cd_tipo_servico_bancario = @cd_tipo_servico_bancario and 
             --          convenio = @convenio and 
             --          banco = convert(int,(substring(@linha,43,3)))
             --   if @cd_tipo_pagamento = 0 
             --   Begin -- 2.1.1.2
             --     print 'Erro : Tipo de Pagamento nao localizado'
             --     --- gravar erro CRM Processo 4 (Tipo de Pagamento nao localizado para convenio e banco)
             --     Close Dados_Cursor
             --     Deallocate Dados_Cursor
             --     return
             --   End -- 2.1.1.2

             --End -- 2.1.1     
             
             --if Upper(rtrim(substring(@linha,192,20)))='RETORNO-PRODUCAO' 
             --Begin -- 2.2.1
             --   set @cd_tipo_servico_bancario=1
                
             --   print 'TITULO DE COBRANÇA' 
             --   print @linha
             --   print @cd_tipo_servico_bancario
                
             --   if substring(@linha,143,1)<>'2' -- Arquivo nao é de retorno
             --   Begin -- 2.2.1.1
             --     --- gravar erro CRM Processo 4 (Arquivo nao é de retorno)
             --     print 'erro' 
             --     Close Dados_Cursor
             --     Deallocate Dados_Cursor
             --     return
             --   End -- 2.2.1.1
                
             --   set @convenio = rtrim(substring(@linha,59,6))
             --   set @nsa = convert(int,(substring(@linha,158,6)))
                             
             --   --print 'servico: ' + convert(varchar(10),@cd_tipo_servico_bancario )
             --   --print 'convenio: ' + convert(varchar(10),@convenio )
             --   --print 'banco: ' + substring(@linha,1,3)
             --   --print 'CNPJ: ' + SUBSTRING(@linha,19,14)
                
             --   select @cd_tipo_pagamento = cd_tipo_pagamento  -- Descobrir qual o tipo de pagamento
             --     from tipo_pagamento 
             --    where cd_tipo_servico_bancario = @cd_tipo_servico_bancario and 
             --          convenio = @convenio and 
             --          banco = convert(int,(substring(@linha,1,3))) and 
             --          nr_cnpj = SUBSTRING(@linha,19,14) 
             --   if @cd_tipo_pagamento = 0 
             --   Begin -- 2.2.1.2
             --     print 'Erro : Tipo de Pagamento nao localizado'
             --     --- gravar erro CRM Processo 4 (Tipo de Pagamento nao localizado para convenio e banco)
             --     Close Dados_Cursor
             --     Deallocate Dados_Cursor
             --     return
             --   End -- 2.2.1.2

             --End -- 2.2.1     
             

			  
           if rtrim(substring(@linha,19,14))='31368828000120' and rtrim(substring(@linha,143,1))='2' -- OdontoCob
             
             Begin -- 2.2.1
                set @cd_tipo_servico_bancario=1004
                
                print 'TITULO DE COBRANÇA' 
                print @linha
                print @cd_tipo_servico_bancario
                print 'teste aurea odontocob'
                
                set @convenio = rtrim(substring(@linha,55,7))
                set @nsa = convert(int,(substring(@linha,158,6)))
                
                select @cd_tipo_pagamento = t.cd_tipo_pagamento, 
				       @cd_tipo_servico_bancario =  t.cd_tipo_servico_bancario, -- Descobrir qual o tipo de pagamento
					   @faixa = isnull(b.faixaOcorrencia,700) 
                  from tipo_pagamento as t inner join tipo_servico_bancario as b on t.cd_tipo_servico_bancario=b.cd_tipo_servico_bancario
                 where t.cd_tipo_servico_bancario in (@cd_tipo_servico_bancario) and 
                       t.convenio = @convenio and 
                       t.banco = convert(int,(substring(@linha,1,3))) --and 
                order by cd_tipo_pagamento
                                       
                       --nr_cnpj = SUBSTRING(@linha,19,14) 
                if @cd_tipo_pagamento = 0 
                Begin -- 2.2.1.2
                  print 'Erro : Tipo de Pagamento nao localizado'
                  --- gravar erro CRM Processo 4 (Tipo de Pagamento nao localizado para convenio e banco)
                  Close Dados_Cursor
                  Deallocate Dados_Cursor
                  return
                End -- 2.2.1.2
             End -- 2.2.1                   			                      
  	


             --if Upper(rtrim(substring(@linha,172,18)))='REMESSA PROCESSADA' 
             --Begin -- 2.2.1
             --   set @cd_tipo_servico_bancario=45
                
             --   print 'TITULO DE COBRANÇA - CEF COM REGISTRO' 
             --   print @linha
             --   print @cd_tipo_servico_bancario
                
             --   if substring(@linha,143,1)<>'2' and substring(@linha,143,1)<>'4' -- Arquivo nao é de retorno
             --   Begin -- 2.2.1.1
             --     --- gravar erro CRM Processo 4 (Arquivo nao é de retorno)
             --     print 'erro' 
             --     Close Dados_Cursor
             --     Deallocate Dados_Cursor
             --     return
             --   End -- 2.2.1.1
                
             --   set @convenio = rtrim(substring(@linha,59,6))
             --   set @nsa = convert(int,(substring(@linha,158,6)))
                             
             --   --print 'servico: ' + convert(varchar(10),@cd_tipo_servico_bancario )
             --   --print 'convenio: ' + convert(varchar(10),@convenio )
             --   --print 'banco: ' + substring(@linha,1,3)
             --   --print 'CNPJ: ' + SUBSTRING(@linha,19,14)
                
             --   select @cd_tipo_pagamento = cd_tipo_pagamento  -- Descobrir qual o tipo de pagamento
             --     from tipo_pagamento 
             --    where cd_tipo_servico_bancario = @cd_tipo_servico_bancario and 
             --          convenio = @convenio and 
             --          banco = convert(int,(substring(@linha,1,3))) and 
             --          nr_cnpj = SUBSTRING(@linha,19,14) 
             --   if @cd_tipo_pagamento = 0 
             --   Begin -- 2.2.1.2
             --     print 'Erro : Tipo de Pagamento nao localizado'
             --     --- gravar erro CRM Processo 4 (Tipo de Pagamento nao localizado para convenio e banco)
             --     Close Dados_Cursor
             --     Deallocate Dados_Cursor
             --     return
             --   End -- 2.2.1.2

             --End -- 2.2.1              

             --if Upper(rtrim(substring(@linha,103,20)))='BANCO DO BRASIL' and substring(@linha,1,3) = '001' and 
             --   Upper(rtrim(substring(@linha,181,11)))='PROCESSAMEN'
             --Begin -- 2.2.1
             --   set @cd_tipo_servico_bancario=21--1
                
             --   print 'TITULO DE COBRANÇA CNAB 400' 
             --   print @linha
             --   print @cd_tipo_servico_bancario
                
             --   if substring(@linha,143,1)<>'2' -- Arquivo nao é de retorno
             --   Begin -- 2.2.1.1
             --     --- gravar erro CRM Processo 4 (Arquivo nao é de retorno)
             --     print 'erro' 
             --     Close Dados_Cursor
             --     Deallocate Dados_Cursor
             --     return
             --   End -- 2.2.1.1
                
             --   set @convenio = rtrim(substring(@linha,36,6))
             --   set @nsa = convert(int,(substring(@linha,158,6)))
                
             --   print 'servico: ' + convert(varchar(10),@cd_tipo_servico_bancario )
             --   print 'convenio: ' + convert(varchar(10),@convenio )
             --   print 'banco: ' + substring(@linha,1,3)
             --   print 'CNPJ: ' + SUBSTRING(@linha,19,14)
                
             --   select @cd_tipo_pagamento = cd_tipo_pagamento  -- Descobrir qual o tipo de pagamento
             --     from tipo_pagamento 
             --    where cd_tipo_servico_bancario = @cd_tipo_servico_bancario and 
             --          convenio = @convenio and 
             --          banco = convert(int,(substring(@linha,1,3))) and 
             --          nr_cnpj = SUBSTRING(@linha,19,14) 
             --   if @cd_tipo_pagamento = 0 
             --   Begin -- 2.2.1.2
             --     print 'Erro : Tipo de Pagamento nao localizado'
             --    -- raiserror ('Erro : Tipo de Pagamento nao localizado',16,1)
                  
             --     --- gravar erro CRM Processo 4 (Tipo de Pagamento nao localizado para convenio e banco)
             --     Close Dados_Cursor
             --     Deallocate Dados_Cursor
             --     return
             --   End -- 2.2.1.2

             --End -- 2.2.1                 
             
             --print Upper(rtrim(substring(@linha,1,19)))
             --print LEN(@linha)
             
             --if Upper(rtrim(substring(@linha,1,19)))='02RETORNO01COBRANCA' and LEN(@linha)>=400 -- print 'aqui' 
             --Begin -- 2.2.1
             --   set @cd_tipo_servico_bancario=46
                
             --   print 'TITULO DE COBRANÇA' 
             --   print @linha
             --   print @cd_tipo_servico_bancario
                
             --   set @convenio = rtrim(substring(@linha,40,7))
             --   set @nsa = convert(int,(substring(@linha,390,5)))
                
                
             --   select @cd_tipo_pagamento = cd_tipo_pagamento  -- Descobrir qual o tipo de pagamento
             --     from tipo_pagamento 
             --    where cd_tipo_servico_bancario = @cd_tipo_servico_bancario and 
             --          convenio = @convenio and 
             --          banco = convert(int,(substring(@linha,77,3))) --and 
             --   order by cd_tipo_pagamento
                                       
             --          --nr_cnpj = SUBSTRING(@linha,19,14) 
             --   if @cd_tipo_pagamento = 0 
             --   Begin -- 2.2.1.2
                 
             --     print 'Erro : Tipo de Pagamento nao localizado'
             --     --- gravar erro CRM Processo 4 (Tipo de Pagamento nao localizado para convenio e banco)
             --     Close Dados_Cursor
             --     Deallocate Dados_Cursor
             --     return
             --   End -- 2.2.1.2

             --End -- 2.2.1   
             
             --if Upper(rtrim(substring(@linha,1,5)))='A1SIM'
             --Begin -- 2.3.1
             --   set @cd_tipo_servico_bancario=8 

             --   select @cd_tipo_pagamento = cd_tipo_pagamento, @convenio = convenio,  @nsa=1   -- Descobrir qual o tipo de pagamento
             --     from tipo_pagamento 
             --    where cd_tipo_servico_bancario = @cd_tipo_servico_bancario 
             --   if @cd_tipo_pagamento = 0 
             --   Begin -- 2.3.1.2
             --     --- gravar erro CRM Processo 4 (Tipo de Pagamento nao localizado para convenio e banco)
             --     Close Dados_Cursor
             --     Deallocate Dados_Cursor
             --     return
             --   End -- 2.3.1.2

             --End -- 2.3.1    

             --if Upper(rtrim(substring(@linha,1,20)))='PADRAO CPF E VALOR' 
             --Begin -- 2.2.1
             --   -- Se tipo servico 10 só olha nas parcelas planos 
             --   -- Se tipo servico 11 olha nas parcelas planos + cobrança
                
             --   set @cd_tipo_servico_bancario=10
             --   set @nsa = 1
             --   if SUBSTRING(@linha,41,1)='5'
             --      set @nsa = 5
                   
             --   set @convenio = rtrim(substring(@linha,21,6))

             --   Set @dt_pago = case when rtrim(SUBSTRING(@linha,33,8))='' then null else SUBSTRING(@linha,35,2)+'/'+SUBSTRING(@linha,33,2)+'/'+SUBSTRING(@linha,37,4) end
             --   Set @dt_Vencimento = SUBSTRING(@linha,31,2)+'/01/'+SUBSTRING(@linha,27,4)
                
             --   select @cd_tipo_pagamento = cd_tipo_pagamento  -- Descobrir qual o tipo de pagamento
             --     from tipo_pagamento 
             --    where cd_tipo_servico_bancario in (10) and 
             --          convenio = @convenio 
             --   if @cd_tipo_pagamento = 0 
             --   Begin -- 2.2.1.2
             --     print 'Erro : Tipo de Pagamento nao localizado'
             --     --- gravar erro CRM Processo 4 (Tipo de Pagamento nao localizado para convenio e banco)
             --     Close Dados_Cursor
             --     Deallocate Dados_Cursor
             --     return
             --   End -- 2.2.1.2

             --End -- 2.2.1                 

             --if Upper(rtrim(substring(@linha,1,4)))='SIAP' or Upper(rtrim(substring(@linha,1,4)))='PENS' 
             --Begin -- 2.2.1
             --   set @cd_tipo_servico_bancario=13
             --   set @convenio = rtrim(substring(@linha,5,6))
             --   if Upper(rtrim(substring(@linha,1,4)))='SIAP'   
             --    begin
             --      set @nsa = 1 -- Modelo Servidor
             --      set @cd_tipo_servico_bancario=13
             --    end  
             --   else
             --    begin
             --      set @nsa = 2 -- Modelo Pensionista
             --      set @cd_tipo_servico_bancario=18
             --    end 
                      
             --   Set @dt_Vencimento = SUBSTRING(@linha,15,2)+'/01/'+SUBSTRING(@linha,11,4)
             --   Set @dt_pago = case when rtrim(SUBSTRING(@linha,17,8))='' then null else SUBSTRING(@linha,19,2)+'/'+SUBSTRING(@linha,17,2)+'/'+SUBSTRING(@linha,21,4) end
                
             --   select @cd_tipo_pagamento = cd_tipo_pagamento  -- Descobrir qual o tipo de pagamento
             --     from tipo_pagamento 
             --    where cd_tipo_servico_bancario = @cd_tipo_servico_bancario and convenio = @convenio 
             --   if @cd_tipo_pagamento = 0 
             --   Begin -- 2.2.1.2
             --     print 'Erro : Tipo de Pagamento nao localizado'
             --     --- gravar erro CRM Processo 4 (Tipo de Pagamento nao localizado para convenio e banco)
             --     Close Dados_Cursor
             --     Deallocate Dados_Cursor
             --     return
             --   End -- 2.2.1.2

             --End -- 2.2.1      

             --if Upper(rtrim(substring(@linha,1,4)))='GEPB' 
             --Begin -- 2.2.1
             --   set @cd_tipo_servico_bancario=14
             --   set @convenio = rtrim(substring(@linha,5,6))
             --   set @nsa = 1
             --   Set @dt_Vencimento = SUBSTRING(@linha,15,2)+'/01/'+SUBSTRING(@linha,11,4)
             --   Set @dt_pago = case when rtrim(SUBSTRING(@linha,17,8))='' then null else SUBSTRING(@linha,19,2)+'/'+SUBSTRING(@linha,17,2)+'/'+SUBSTRING(@linha,21,4) end
                
             --   select @cd_tipo_pagamento = cd_tipo_pagamento  -- Descobrir qual o tipo de pagamento
             --     from tipo_pagamento 
             --    where cd_tipo_servico_bancario = @cd_tipo_servico_bancario and convenio = @convenio 
             --   if @cd_tipo_pagamento = 0 
             --   Begin -- 2.2.1.2
             --     print 'Erro : Tipo de Pagamento nao localizado'
             --     --- gravar erro CRM Processo 4 (Tipo de Pagamento nao localizado para convenio e banco)
             --     Close Dados_Cursor
             --     Deallocate Dados_Cursor
             --     return
             --   End -- 2.2.1.2

             --End -- 2.2.1      
             
             --if Upper(rtrim(substring(@linha,1,4)))='PMJP' 
             --Begin -- 2.2.1
             --   set @cd_tipo_servico_bancario=15
             --   set @convenio = rtrim(substring(@linha,5,6))
             --   set @nsa = 1
             --   Set @dt_Vencimento = SUBSTRING(@linha,15,2)+'/01/'+SUBSTRING(@linha,11,4)
             --   Set @dt_pago = case when rtrim(SUBSTRING(@linha,17,8))='' then null else SUBSTRING(@linha,19,2)+'/'+SUBSTRING(@linha,17,2)+'/'+SUBSTRING(@linha,21,4) end
                
             --   select @cd_tipo_pagamento = cd_tipo_pagamento  -- Descobrir qual o tipo de pagamento
             --     from tipo_pagamento 
             --    where cd_tipo_servico_bancario = @cd_tipo_servico_bancario and convenio = @convenio 
             --   if @cd_tipo_pagamento = 0 
             --   Begin -- 2.2.1.2
             --     print 'Erro : Tipo de Pagamento nao localizado'
             --     --- gravar erro CRM Processo 4 (Tipo de Pagamento nao localizado para convenio e banco)
             --     Close Dados_Cursor
             --     Deallocate Dados_Cursor
             --     return
             --   End -- 2.2.1.2

             --End -- 2.2.1                 

             --if Upper(rtrim(substring(@linha,41,5)))='986PV' -- Cartao de Credito
             --Begin -- 2.2.1
             --   set @cd_tipo_servico_bancario=16
             --   set @convenio = rtrim(substring(@linha,31,10))
             --   set @nsa =rtrim(substring(@linha,11,7))
                
             --   select @cd_tipo_pagamento = cd_tipo_pagamento  -- Descobrir qual o tipo de pagamento
             --     from tipo_pagamento 
             --    where cd_tipo_servico_bancario = 16 and convenio = @convenio 
             --      and cd_tipo_pagamento = case when Upper(rtrim(substring(@linha,46,2))) = '' then 18 else Upper(rtrim(substring(@linha,46,2))) end 

             --   if @cd_tipo_pagamento = 0 
             --   Begin -- 2.2.1.2
             --     print 'Erro : Tipo de Pagamento nao localizado'
             --     --- gravar erro CRM Processo 4 (Tipo de Pagamento nao localizado para convenio e banco)
             --     Close Dados_Cursor
             --     Deallocate Dados_Cursor
             --     return
             --   End -- 2.2.1.2

             --End -- 2.2.1                 

             --if Upper(rtrim(substring(@linha,1,1)))='0'  and -- Hiper
             --   Upper(rtrim(substring(@linha,40,3)))='V20'
             --Begin -- 2.2.1
             --   set @cd_tipo_servico_bancario=17
             --   set @convenio = rtrim(substring(@linha,2,7))
             --   set @nsa =rtrim(substring(@linha,35,5))
                
             --   select @cd_tipo_pagamento = cd_tipo_pagamento  -- Descobrir qual o tipo de pagamento
             --     from tipo_pagamento 
             --    where cd_tipo_servico_bancario = @cd_tipo_servico_bancario and convenio = @convenio 
             --   if @cd_tipo_pagamento = 0 
             --   Begin -- 2.2.1.2
             --     print 'Erro : Tipo de Pagamento nao localizado'
             --     --- gravar erro CRM Processo 4 (Tipo de Pagamento nao localizado para convenio e banco)
             --     Close Dados_Cursor
             --     Deallocate Dados_Cursor
             --     return
             --   End -- 2.2.1.2

             --End -- 2.2.1                 

             --if Upper(rtrim(substring(@linha,1,2)))='00'  and -- Hiper
             --   Upper(rtrim(substring(@linha,21,5)))='11320'
             --Begin -- 2.2.1
             --   set @cd_tipo_servico_bancario=19
             --   set @convenio = rtrim(substring(@linha,16,10))
             --   set @nsa =rtrim(substring(@linha,61,4))
                
             --   select @cd_tipo_pagamento = cd_tipo_pagamento  -- Descobrir qual o tipo de pagamento
             --     from tipo_pagamento 
             --    where cd_tipo_servico_bancario = @cd_tipo_servico_bancario and convenio = @convenio 
             --   if @cd_tipo_pagamento = 0 
             --   Begin -- 2.2.1.2
             --     print 'Erro : Tipo de Pagamento nao localizado'
             --     --- gravar erro CRM Processo 4 (Tipo de Pagamento nao localizado para convenio e banco)
             --     Close Dados_Cursor
             --     Deallocate Dados_Cursor
             --     return
             --   End -- 2.2.1.2

             --End -- 2.2.1   

             --if rtrim(substring(@linha,4,5))='00000' and rtrim(substring(@linha,143,1))='2' 
             --and Upper(rtrim(substring(@linha,1,3)))='033'
             
             --Begin -- 2.2.1
             --   set @cd_tipo_servico_bancario=9
                
             --   print 'TITULO DE COBRANÇA' 
             --   print @linha
             --   print @cd_tipo_servico_bancario
             --   print 'teste aurea'
                
             --   set @convenio = rtrim(substring(@linha,55,7))
             --   set @nsa = convert(int,(substring(@linha,158,6)))
                
             --   select @cd_tipo_pagamento = cd_tipo_pagamento  -- Descobrir qual o tipo de pagamento
             --     from tipo_pagamento 
             --    where cd_tipo_servico_bancario in (1, @cd_tipo_servico_bancario) and 
             --          convenio = @convenio and 
             --          banco = convert(int,(substring(@linha,1,3))) --and 
             --   order by cd_tipo_pagamento
                                       
             --          --nr_cnpj = SUBSTRING(@linha,19,14) 
             --   if @cd_tipo_pagamento = 0 
             --   Begin -- 2.2.1.2
             --     print 'Erro : Tipo de Pagamento nao localizado'
             --     --- gravar erro CRM Processo 4 (Tipo de Pagamento nao localizado para convenio e banco)
             --     Close Dados_Cursor
             --     Deallocate Dados_Cursor
             --     return
             --   End -- 2.2.1.2
             --End -- 2.2.1                            

    --         if @cd_tipo_servico_bancario = 0 -- Cartao Unico
    --         Begin -- 2.2.2

    --            --Verificar convenio
				----Encontrar Forma de Pagamento
				----Localizar Associado pelo CPF
				----Baixar a parcela
    --            set @cd_tipo_servico_bancario=7             
    --            set @nsa=1 
    --            set @convenio = rtrim(ltrim(substring(@linha,18,6)))
                
    --            print 'x'+@convenio +'x'
    --            select @cd_tipo_pagamento = cd_tipo_pagamento  -- Descobrir qual o tipo de pagamento
    --              from tipo_pagamento 
    --             where cd_tipo_servico_bancario = @cd_tipo_servico_bancario and 
    --                   convenio = @convenio

    --            if @cd_tipo_pagamento = 0 
    --            Begin -- 2.2.2.2
    --              print 'Erro : Tipo de Pagamento nao localizado (0)'
    --              --- gravar erro CRM Processo 4 (Tipo de Pagamento nao localizado para convenio e banco)
    --              Close Dados_Cursor
    --              Deallocate Dados_Cursor
    --              return
    --            End -- 2.2.2.2                 
             
    --         End -- 2.2.2 
             
             print @cd_tipo_servico_bancario
             print 'teste novo'
             if @cd_tipo_servico_bancario <> 0 
             Begin -- 2.3
             
                print '--- Insert '
                
                --- Criar o Registro no Banco - Processo retorno
                insert into Lote_Processos_Bancos_Retorno(cd_tipo_servico_bancario,cd_tipo_pagamento,dt_processado,nsa,convenio,nm_arquivo, obs)
                  values (@cd_tipo_servico_bancario, @cd_tipo_pagamento, getdate(), @nsa, @convenio,@arquivo, 'Erro na importação do arquivo')
                 if @@RowCount=0 
                Begin -- 2.3.1
                  --- gravar erro CRM Processo 4 (Erro na leitura do arquivo Banco + @cd_tipo_pagamento)
                  Close Dados_Cursor
                  Deallocate Dados_Cursor
                  return
                End -- 2.3.1

                set @sequencial_retorno=IDENT_CURRENT ('Lote_Processos_Bancos_Retorno')
                set @erro = 0 
                print '** sequencial retorno **'
                print @sequencial_retorno
                print '*********'
                

             End  -- 2.3             
             

          End -- 2.1

          if @cd_tipo_servico_bancario=6 and -- Debito Automatico
             substring(@linha,1,1) = 'F' -- Linha de detalhes
          Begin -- 2.2

             set @linha_aux = @linha
             
             -- Localizar Codigo Parcela -- Nosso Numero Sistema Antigo
             Select @nosso_numero = '', @nn='' , @cd_parcela = null , @cd_tipo_recebimento = null , @vl_parcela = null , @qtde_parcelas = 0 
             
			  Declare Dados_Cursor_RB  cursor for  
			   select cd_parcela, cd_tipo_recebimento, vl_parcela+isnull(vl_acrescimo,0)-isnull(vl_desconto,0)-isnull(vl_imposto,0) +ISNULL(vl_taxa,0)+isnull(vl_jurosmultareferencia,0)+isnull(vl_acrescimoavulso,0)-isnull(vl_descontoavulso,0), Nosso_numero,dt_vencimento
				 from MENSALIDADES 
				where NOSSO_NUMERO= convert(varchar(70),convert(bigint,SUBSTRING(@linha_aux,70,70)))
  			  Open Dados_Cursor_RB
			  Fetch next from Dados_Cursor_RB Into @cd_parcela, @cd_tipo_recebimento, @vl_parcela , @nosso_numero, @dt_vencimento
			  While (@@fetch_status  <> -1)
				Begin -- 3.1            
	              
				   if @qtde_parcelas=0 
					  set @nn = @nosso_numero
				   else
					  set @nn = @nn + ','+@nosso_numero
	              
				   set @qtde_parcelas = @qtde_parcelas + 1 
	          
				   Fetch next from Dados_Cursor_RB Into @cd_parcela, @cd_tipo_recebimento, @vl_parcela , @nosso_numero, @dt_vencimento
				End -- 3.1
				Close Dados_Cursor_RB
				Deallocate Dados_Cursor_RB
                 
            
            set @cd_ocorrencia = substring(@linha_aux,68,2)
            if @cd_ocorrencia=31 -- DÉBITO EFETUADO EM DT DIFERENTE DA DT INFORMADA. Não é erro.
               Set @cd_ocorrencia = 0 
            print @cd_ocorrencia

            if @cd_ocorrencia= 0 -- Caso tenha sido debitado verificar se tem algum problema
            begin
           		select @cd_ocorrencia = (case 
					 when @qtde_parcelas = 0 then 97 -- NOSSO NUMERO NÃO ENCONTRADO
					 when @qtde_parcelas = 1 and @cd_tipo_recebimento=0 and Abs(convert(int,substring(@linha_aux,53,15))-convert(int,(@vl_parcela*100)))>100 then 104 -- VALOR DA PARCELA INCORRETO
					 when @qtde_parcelas = 1 and @cd_tipo_recebimento=1 then 102 -- NOSSO NUMERO EXCLUIDO
					 when @qtde_parcelas = 1 and @cd_tipo_recebimento=2 then 103 -- NOSSO NUMERO ACORDADO
					 when @qtde_parcelas = 1 and @cd_tipo_recebimento>2 then 101 -- NOSSO NUMERO BAIXADO ANTERIORMENTE
					 when @qtde_parcelas > 1 then 100 
					 else 0 
				  End)
            end
            
            if @cd_ocorrencia > 96 --and @cd_ocorrencia <> 101 -- 00 - Efetuado, Ate 96 são erros que nao afetam a baixa
               set @erro = 1
               
             set @qtde = @qtde + 1 
             if @cd_ocorrencia=0 -- So atualiza o valor se deu correto
				Set @valor = @valor + convert(money,substring(@linha,53,15))/100
             
			 insert Lote_Processos_Bancos_Retorno_Mensalidades 
               (cd_sequencial_retorno,  nr_linha , cd_parcela, cd_ocorrencia, dt_venc, dt_pago, vl_parcela, 
                vl_multa, vl_desconto, vl_tarifa, vl_pago, nn, nm_linha)
              values (@sequencial_retorno, @qtde , 
                case when @qtde_parcelas <> 1 then Null Else @cd_parcela End,
                @cd_ocorrencia , 
                @dt_vencimento ,  -- venc               
                substring(@linha,49,2)+'/'+substring(@linha,51,2)+'/'+substring(@linha,45,4) , -- pgto
                convert(money,substring(@linha_aux,53,15))/100, -- parcela
                0, -- multa
                0, -- desconto
                0, -- tarifa
                convert(money,substring(@linha,53,15))/100, -- pago
                Case when @cd_ocorrencia=97 then SUBSTRING(@linha_aux,70,70) Else @nn End , 
                @linha_aux)   

                if @@ROWCOUNT = 0 
                begin -- 2.3.2
                
                   print @sequencial_retorno
                   print @qtde
                   print @qtde_parcelas
                   print @cd_ocorrencia
    			   print @linha_aux
                   set @erro = 9  -- Não processar o arquivo
                end -- 2.3.2   
                
          End -- 2.2

          --  if @cd_tipo_servico_bancario in (9) and -- TITULO DE COBRANÇA
          --   substring(@linha,8,1) = '3' and -- Linha de detalhe
          --   substring(@linha,14,1) = 'T' 
          --Begin -- 2.2 
          --   -- T : NOSSO_NUMERO = 39,19 : VALOR_TARIFA = 199,1
          --   print 'entrou servico T'
          --   set @linha_aux = @linha
          --   if SUBSTRING(@linha_aux,38,20) <> ''
          --      Set @despreza = 0 
          --   else   
          --      Set @despreza = 1
                
          --End -- 2.2 
             
    --      if @cd_tipo_servico_bancario in (9) and -- TITULO DE COBRANÇA
    --         substring(@linha,8,1) = '3' and -- Linha de detalhe
    --         substring(@linha,14,1) = 'U' and 
    --         @despreza = 0 and 
    --         substring(@linha,16,2) in ('02','03','06','07','08','09','10','17','25','27','30','59') -- 06 - Liquidacao porem pode variar de acordo com o Banco
    --      Begin -- 2.3             
             
    --         print '11'
    --         print substring(@linha,16,2)
             
    --         -- Localizar Codigo Parcela -- Nosso Numero Sistema Antigo
    --         Select @nosso_numero = convert(varchar(20),convert(bigint,rtrim(ltrim(SUBSTRING(@linha_aux,42,11))))), @nn='' , @cd_parcela = null , @cd_tipo_recebimento = null , @vl_parcela = null , @qtde_parcelas = 0 ,
    --                @qt_agrupada = null, @qt_aberta=0,@qt_excluida=0,@qt_acordo=0,@qt_baixada=0

			 -- Declare Dados_Cursor_RB  cursor for  
			 --  select cd_parcela, cd_tipo_recebimento,  vl_parcela+isnull(vl_acrescimo,0)-isnull(vl_desconto,0)-isnull(vl_imposto,0) +ISNULL(vl_taxa,0)+isnull(vl_jurosmultareferencia,0)+isnull(vl_acrescimoavulso,0)-isnull(vl_descontoavulso,0), Nosso_numero,
			 --  (select count(cd_parcela) from MENSALIDADES where CD_TIPO_RECEBIMENTO = 0 and CD_PARCELA in (
				--	  select cd_parcela from MensalidadesAgrupadas where cd_parcelaMae in (select cd_parcela from MENSALIDADES where NOSSO_NUMERO in (@nosso_numero) ) 
				--																							)
			 --  ) as abertas,
			 --  (select count(cd_parcela) from MENSALIDADES where CD_TIPO_RECEBIMENTO = 1 and CD_PARCELA in (
				--	  select cd_parcela from MensalidadesAgrupadas where cd_parcelaMae in (select cd_parcela from MENSALIDADES where NOSSO_NUMERO in (@nosso_numero) ) 
				--																							)
			 --  ) as exc,
			 --  (select count(cd_parcela) from MENSALIDADES where CD_TIPO_RECEBIMENTO = 2 and CD_PARCELA in (
				--	  select cd_parcela from MensalidadesAgrupadas where cd_parcelaMae in (select cd_parcela from MENSALIDADES where NOSSO_NUMERO in (@nosso_numero) ) 
				--																							)
			 --  ) as acor,
			 --  (select count(cd_parcela) from MENSALIDADES where CD_TIPO_RECEBIMENTO > 2 and CD_PARCELA in (
				--	  select cd_parcela from MensalidadesAgrupadas where cd_parcelaMae in (select cd_parcela from MENSALIDADES where NOSSO_NUMERO in (@nosso_numero) ) 
				--																							)
			 --  ) as baixadas  			   
				-- from MENSALIDADES 
				--where NOSSO_NUMERO= @nosso_numero

			  			  	       
  		--	  Open Dados_Cursor_RB
			 -- Fetch next from Dados_Cursor_RB Into @cd_parcela, @cd_tipo_recebimento, @vl_parcela , @nosso_numero , @qt_aberta, @qt_excluida, @qt_acordo, @qt_baixada
			 -- While (@@fetch_status  <> -1)
				--Begin -- 3.1            

				--   if @qtde_parcelas=0 
				--	  set @nn = @nosso_numero
				--   else
				--	  set @nn = @nn + ','+@nosso_numero
	              
				--   set @qtde_parcelas = @qtde_parcelas + 1 
	          
				--   Fetch next from Dados_Cursor_RB Into @cd_parcela, @cd_tipo_recebimento, @vl_parcela , @nosso_numero , @qt_aberta, @qt_excluida, @qt_acordo, @qt_baixada
				--End -- 3.1
				--Close Dados_Cursor_RB
				--Deallocate Dados_Cursor_RB
                 
    --        set @cd_ocorrencia = case when substring(@linha,16,2) in ('06','07','08','10','17','59') then 0 else 700+CONVERT(int,substring(@linha,16,2)) end 
    --        set @qt_agrupada = isnull(@qt_aberta,0)+isnull(@qt_excluida,0)+isnull(@qt_acordo,0)+isnull(@qt_baixada,0)
         
    --        print '------------'
    --        print substring(@linha,16,2)
    --        print @cd_ocorrencia
            
    --        if @cd_ocorrencia = 0 
    --        begin
				--select @cd_ocorrencia = (case 
				--	 when @qtde_parcelas > 1 then 100 
				--	 when @qtde_parcelas = 1 and @qt_agrupada>0 and @qt_aberta>0 and @qt_baixada=0 and @qt_excluida=0 and @qt_acordo=0 then 35
				--	 when @qtde_parcelas = 1 and @qt_agrupada>0 and @qt_baixada>0 then 101                 
				--	 when @qtde_parcelas = 1 and @qt_agrupada>0 and @qt_excluida>0 then 102
				--	 when @qtde_parcelas = 1 and @qt_agrupada>0 and @qt_acordo>0 then 103
				--	 when @qtde_parcelas = 1 and @qt_agrupada>0 and @qt_aberta=0 then 105 
	            
				--	 when @qtde_parcelas = 0 then 97 -- NOSSO NUMERO NÃO ENCONTRADO
				--	 when @qtde_parcelas = 1 and @cd_tipo_recebimento=0 and Abs(convert(int,substring(@linha_aux,78,15))-convert(int,(@vl_parcela*100)))>500 then 104 -- VALOR DA PARCELA INCORRETO
				--	 when @qtde_parcelas = 1 and @cd_tipo_recebimento=1 then 102 -- NOSSO NUMERO EXCLUIDO
				--	 when @qtde_parcelas = 1 and @cd_tipo_recebimento=2 then 103 -- NOSSO NUMERO ACORDADO
				--	 when @qtde_parcelas = 1 and @cd_tipo_recebimento>2 then 101 -- NOSSO NUMERO BAIXADO ANTERIORMENTE

				--	 Else 0
				--  End)
				  
				--  if @cd_ocorrencia not in (0,31,35) 
				--	set @erro = 1
				-- Set @valor = @valor + convert(money,case when substring(@linha,78,15)='000000000000000' then substring(@linha_aux,78,15) else substring(@linha,78,15) end )/100
				-- set @dt_prevista_credito = convert(varchar(10),substring(@linha,148,2)+'/'+substring(@linha,146,2)+'/'+substring(@linha,150,4),101)
	             				  
    --        End  
            
    --         set @qtde = @qtde + 1 

    --         insert Lote_Processos_Bancos_Retorno_Mensalidades 
    --           (cd_sequencial_retorno,  nr_linha , cd_parcela, cd_ocorrencia, dt_venc, dt_pago, vl_parcela, 
    --            vl_multa, vl_desconto, vl_tarifa, vl_pago, nn,dt_credito,cd_ocorrencia_auxiliar,nm_linha)
    --          values (@sequencial_retorno, @qtde , 
    --            case when @qtde_parcelas <> 1 then Null Else @cd_parcela End,
    --            @cd_ocorrencia , 
    --            case when substring(@linha_aux,72,2)+'/'+substring(@linha_aux,70,2)+'/'+substring(@linha_aux,74,4)='00/00/0000' then null else substring(@linha_aux,72,2)+'/'+substring(@linha_aux,70,2)+'/'+substring(@linha_aux,74,4) End ,  -- venc               
    --            substring(@linha,140,2)+'/'+substring(@linha,138,2)+'/'+substring(@linha,142,4) , -- pgto
    --            convert(money,substring(@linha_aux,78,15))/100, -- parcela
    --            convert(money,substring(@linha,18,15))/100, -- multa
    --            convert(money,substring(@linha,33,15))/100, -- desconto
    --            convert(money,substring(@linha_aux ,194,15))/100, -- tarifa
    --            convert(money,case when @cd_ocorrencia >= 700 then 0 when substring(@linha,78,15)='000000000000000' then substring(@linha_aux,78,15) else substring(@linha,78,15) end )/100, -- pago
    --            Case when @cd_ocorrencia=97 then convert(varchar(20),convert(bigint,rtrim(ltrim(SUBSTRING(@linha_aux,42,11)))))  Else @nn End , 

    --            Case when @cd_ocorrencia >= 700 then null else @dt_prevista_credito end ,

    --            case when @cd_ocorrencia in (703,706,709,719,726,730) then SUBSTRING(@linha_aux,209,10) 
    --                 else null end,                 

    --            @linha_aux)    
    --            if @@ROWCOUNT = 0 
    --            begin -- 2.3.2
    --               set @erro = 1  -- Não processar o arquivo
    --            end -- 2.3.2   
                
    --            --print 'Insert Mens F' 
               
    --      End -- 2.3
                    
    --      if @cd_tipo_servico_bancario in (10,11) and -- Padrao Cpf e Valor
    --         Upper(rtrim(substring(@linha,1,20)))<>'PADRAO CPF E VALOR' 
    --      Begin -- 2.2

    --         set @linha_aux = @linha
             
    --         -- Localizar Codigo Parcela -- Nosso Numero Sistema Antigo
    --         Select @nosso_numero = '', @nn='' , @cd_parcela = null , @cd_tipo_recebimento = null , @vl_parcela = null , @qtde_parcelas = 0 
             
			 -- Declare Dados_Cursor_RB  cursor for  
			 --  select cd_parcela, cd_tipo_recebimento, vl_parcela+isnull(vl_acrescimo,0)-isnull(vl_desconto,0)-isnull(vl_imposto,0) +ISNULL(vl_taxa,0)+isnull(vl_jurosmultareferencia,0)+isnull(vl_acrescimoavulso,0)-isnull(vl_descontoavulso,0), a.cd_associado
				-- from MENSALIDADES as m, associados as a , empresa as e
				--where m.cd_associado_empresa = a.cd_associado and 
				--      m.tp_associado_empresa = 1 and 
				--      a.cd_empresa = e.cd_empresa and 
				--      (e.cd_tipo_pagamento = @cd_tipo_pagamento or m.cd_tipo_pagamento = @cd_tipo_pagamento) and 
				--      a.nr_cpf=SUBSTRING(@linha_aux,1,11) and 
				--      m.dt_vencimento>=@dt_vencimento and 
				--      m.dt_vencimento< dateadd(month,1,@dt_vencimento) and 
				--      m.cd_tipo_recebimento not in (1) and 
				--      m.cd_tipo_parcela in (1, @nsa) 
				
  		--	  Open Dados_Cursor_RB
			 -- Fetch next from Dados_Cursor_RB Into @cd_parcela, @cd_tipo_recebimento, @vl_parcela , @nosso_numero
			 -- While (@@fetch_status  <> -1)
				--Begin -- 3.1            
	              
				--   if @qtde_parcelas=0 
				--	  set @nn = @nosso_numero
				--   else
				--	  set @nn = @nn + ','+@nosso_numero
	              
				--   set @qtde_parcelas = @qtde_parcelas + 1 
	          
				--   Fetch next from Dados_Cursor_RB Into @cd_parcela, @cd_tipo_recebimento, @vl_parcela , @nosso_numero
				--End -- 3.1
				--Close Dados_Cursor_RB
				--Deallocate Dados_Cursor_RB
                 
				--select @cd_ocorrencia = (case 
				--	 when @qtde_parcelas = 0 then 97 -- NOSSO NUMERO NÃO ENCONTRADO
				--	 when @qtde_parcelas = 1 and @cd_tipo_recebimento=0 and Abs(convert(int,substring(@linha_aux,12,7))-convert(int,(@vl_parcela*100)))>200 then 104 -- VALOR DA PARCELA INCORRETO
				--	 when @qtde_parcelas = 1 and @cd_tipo_recebimento=1 then 102 -- NOSSO NUMERO EXCLUIDO
				--	 when @qtde_parcelas = 1 and @cd_tipo_recebimento=2 then 103 -- NOSSO NUMERO ACORDADO
				--	 when @qtde_parcelas = 1 and @cd_tipo_recebimento>2 then 101 -- NOSSO NUMERO BAIXADO ANTERIORMENTE
				--	 when @qtde_parcelas > 1 then 100 
				--	 else 0 
				--  End)
            
    --        if @cd_ocorrencia > 96 --and @cd_ocorrencia <> 101 -- 00 - Efetuado, Ate 96 são erros que nao afetam a baixa
    --           set @erro = 1
               
    --         set @qtde = @qtde + 1 
    --         print substring(@linha,12,7)
    --         if @cd_ocorrencia=0 -- So atualiza o valor se deu correto
				--Set @valor = @valor + convert(money,substring(@linha,12,7))/100
             
			 --insert Lote_Processos_Bancos_Retorno_Mensalidades 
    --           (cd_sequencial_retorno,  nr_linha , cd_parcela, cd_ocorrencia, dt_venc, dt_pago, vl_parcela, 
    --            vl_multa, vl_desconto, vl_tarifa, vl_pago, nn, nm_linha)
    --          values (@sequencial_retorno, @qtde , 
    --            case when @qtde_parcelas <> 1 then Null Else @cd_parcela End,
    --            @cd_ocorrencia , 
    --            @dt_vencimento ,  -- venc               
    --            @dt_pago  , -- pgto
    --            convert(money,substring(@linha_aux,12,7))/100, -- parcela
    --            0, -- multa
    --            0, -- desconto
    --            0, -- tarifa
    --            convert(money,substring(@linha,12,7))/100, -- pago
    --            SUBSTRING(@linha_aux,1,11), 
    --            @linha_aux)   

    --            if @@ROWCOUNT = 0 
    --            begin -- 2.3.2
                
    --               print @sequencial_retorno
    --               print @qtde
    --               print @qtde_parcelas
    --               print @cd_ocorrencia
    --			   print @linha_aux
    --               set @erro = 9  -- Não processar o arquivo
    --            end -- 2.3.2   
                
    --      End -- 2.2

	 if @cd_tipo_servico_bancario in (1004) and -- TITULO DE COBRANÇA
             substring(@linha,8,1) = '3' and -- Linha de detalhe
             substring(@linha,14,1) = 'T' 
          Begin -- 2.2 
             -- T : NOSSO_NUMERO = 39,19 : VALOR_TARIFA = 199,1
             print 'entrou servico T'
             set @linha_aux = @linha
             if SUBSTRING(@linha_aux,38,20) <> ''
                Set @despreza = 0 
             else   
                Set @despreza = 1
                
          End -- 2.2 
             
          if @cd_tipo_servico_bancario in (1004) and -- TITULO DE COBRANÇA
             substring(@linha,8,1) = '3' and -- Linha de detalhe
             substring(@linha,14,1) = 'U' and 
             @despreza = 0 and 
             substring(@linha,16,2) in ('02','03','06','07','08','09','10','17','25','27','30','59') -- 06 - Liquidacao porem pode variar de acordo com o Banco
          Begin -- 2.3             
             
             print '11'
             print substring(@linha,16,2)
             
             -- Localizar Codigo Parcela -- Nosso Numero Sistema Antigo
             Select @nosso_numero = convert(varchar(20),convert(bigint,rtrim(ltrim(SUBSTRING(@linha_aux,42,11))))), @nn='' , @cd_parcela = null , @cd_tipo_recebimento = null , @vl_parcela = null , @qtde_parcelas = 0 ,
                    @qt_agrupada = null, @qt_aberta=0,@qt_excluida=0,@qt_acordo=0,@qt_baixada=0

			  Declare Dados_Cursor_RB  cursor for  
			   select cd_parcela, cd_tipo_recebimento,  vl_parcela+isnull(vl_acrescimo,0)-isnull(vl_desconto,0)-isnull(vl_imposto,0) +ISNULL(vl_taxa,0)+isnull(vl_jurosmultareferencia,0)+isnull(vl_acrescimoavulso,0)-isnull(vl_descontoavulso,0), Nosso_numero,
			   (select count(cd_parcela) from MENSALIDADES where CD_TIPO_RECEBIMENTO = 0 and CD_PARCELA in (
					  select cd_parcela from MensalidadesAgrupadas where cd_parcelaMae in (select cd_parcela from MENSALIDADES where NOSSO_NUMERO in (@nosso_numero) ) 
																											)
			   ) as abertas,
			   (select count(cd_parcela) from MENSALIDADES where CD_TIPO_RECEBIMENTO = 1 and CD_PARCELA in (
					  select cd_parcela from MensalidadesAgrupadas where cd_parcelaMae in (select cd_parcela from MENSALIDADES where NOSSO_NUMERO in (@nosso_numero) ) 
																											)
			   ) as exc,
			   (select count(cd_parcela) from MENSALIDADES where CD_TIPO_RECEBIMENTO = 2 and CD_PARCELA in (
					  select cd_parcela from MensalidadesAgrupadas where cd_parcelaMae in (select cd_parcela from MENSALIDADES where NOSSO_NUMERO in (@nosso_numero) ) 
																											)
			   ) as acor,
			   (select count(cd_parcela) from MENSALIDADES where CD_TIPO_RECEBIMENTO > 2 and CD_PARCELA in (
					  select cd_parcela from MensalidadesAgrupadas where cd_parcelaMae in (select cd_parcela from MENSALIDADES where NOSSO_NUMERO in (@nosso_numero) ) 
																											)
			   ) as baixadas  			   
				 from MENSALIDADES 
				where NOSSO_NUMERO= @nosso_numero

			  			  	       
  			  Open Dados_Cursor_RB
			  Fetch next from Dados_Cursor_RB Into @cd_parcela, @cd_tipo_recebimento, @vl_parcela , @nosso_numero , @qt_aberta, @qt_excluida, @qt_acordo, @qt_baixada
			  While (@@fetch_status  <> -1)
				Begin -- 3.1            

				   if @qtde_parcelas=0 
					  set @nn = @nosso_numero
				   else
					  set @nn = @nn + ','+@nosso_numero
	              
				   set @qtde_parcelas = @qtde_parcelas + 1 
	          
				   Fetch next from Dados_Cursor_RB Into @cd_parcela, @cd_tipo_recebimento, @vl_parcela , @nosso_numero , @qt_aberta, @qt_excluida, @qt_acordo, @qt_baixada
				End -- 3.1
				Close Dados_Cursor_RB
				Deallocate Dados_Cursor_RB
                 
            set @cd_ocorrencia = case when substring(@linha,16,2) in ('06','07','08','10','17','59') then 0 else @faixa+CONVERT(int,substring(@linha,16,2)) end 
            set @qt_agrupada = isnull(@qt_aberta,0)+isnull(@qt_excluida,0)+isnull(@qt_acordo,0)+isnull(@qt_baixada,0)
         
            print '------------'
            print substring(@linha,16,2)
            print @cd_ocorrencia
            
            if @cd_ocorrencia = 0 
            begin
				select @cd_ocorrencia = (case 
					 when @qtde_parcelas > 1 then 100 
					 when @qtde_parcelas = 1 and @qt_agrupada>0 and @qt_aberta>0 and @qt_baixada=0 and @qt_excluida=0 and @qt_acordo=0 then 35
					 when @qtde_parcelas = 1 and @qt_agrupada>0 and @qt_baixada>0 then 101                 
					 when @qtde_parcelas = 1 and @qt_agrupada>0 and @qt_excluida>0 then 102
					 when @qtde_parcelas = 1 and @qt_agrupada>0 and @qt_acordo>0 then 103
					 when @qtde_parcelas = 1 and @qt_agrupada>0 and @qt_aberta=0 then 105 
	            
					 when @qtde_parcelas = 0 then 97 -- NOSSO NUMERO NÃO ENCONTRADO
					 when @qtde_parcelas = 1 and @cd_tipo_recebimento=0 and Abs(convert(int,substring(@linha_aux,78,15))-convert(int,(@vl_parcela*100)))>500 then 104 -- VALOR DA PARCELA INCORRETO
					 when @qtde_parcelas = 1 and @cd_tipo_recebimento=1 then 102 -- NOSSO NUMERO EXCLUIDO
					 when @qtde_parcelas = 1 and @cd_tipo_recebimento=2 then 103 -- NOSSO NUMERO ACORDADO
					 when @qtde_parcelas = 1 and @cd_tipo_recebimento>2 then 101 -- NOSSO NUMERO BAIXADO ANTERIORMENTE

					 Else 0
				  End)
				  
				  if @cd_ocorrencia not in (0,31,35) 
					set @erro = 1
				 Set @valor = @valor + convert(money,case when substring(@linha,78,15)='000000000000000' then substring(@linha_aux,78,15) else substring(@linha,78,15) end )/100
				 set @dt_prevista_credito = convert(varchar(10),substring(@linha,148,2)+'/'+substring(@linha,146,2)+'/'+substring(@linha,150,4),101)
	             				  
            End  
            
             set @qtde = @qtde + 1 

             insert Lote_Processos_Bancos_Retorno_Mensalidades 
               (cd_sequencial_retorno,  nr_linha , cd_parcela, cd_ocorrencia, dt_venc, dt_pago, vl_parcela, 
                vl_multa, vl_desconto, vl_tarifa, vl_pago, nn,dt_credito,cd_ocorrencia_auxiliar,nm_linha)
              values (@sequencial_retorno, @qtde , 
                case when @qtde_parcelas <> 1 then Null Else @cd_parcela End,
                @cd_ocorrencia , 
                case when substring(@linha_aux,72,2)+'/'+substring(@linha_aux,70,2)+'/'+substring(@linha_aux,74,4)='00/00/0000' then null else substring(@linha_aux,72,2)+'/'+substring(@linha_aux,70,2)+'/'+substring(@linha_aux,74,4) End ,  -- venc               
                substring(@linha,140,2)+'/'+substring(@linha,138,2)+'/'+substring(@linha,142,4) , -- pgto
                convert(money,substring(@linha_aux,78,15))/100, -- parcela
                convert(money,substring(@linha,18,15))/100, -- multa
                convert(money,substring(@linha,33,15))/100, -- desconto
                convert(money,substring(@linha_aux ,194,15))/100, -- tarifa
                convert(money,case when @cd_ocorrencia >= 700 then 0 when substring(@linha,78,15)='000000000000000' then substring(@linha_aux,78,15) else substring(@linha,78,15) end )/100, -- pago
                Case when @cd_ocorrencia=97 then convert(varchar(20),convert(bigint,rtrim(ltrim(SUBSTRING(@linha_aux,42,11)))))  Else @nn End , 

                Case when @cd_ocorrencia >= 700 then null else @dt_prevista_credito end ,

                case when @cd_ocorrencia in (703,706,709,719,726,730) then SUBSTRING(@linha_aux,209,10) 
                     else null end,                 

                @linha_aux)    
                if @@ROWCOUNT = 0 
                begin -- 2.3.2
                   set @erro = 1  -- Não processar o arquivo
                end -- 2.3.2   
                
                --print 'Insert Mens F' 
               
          End -- 2.3
            


          if @cd_tipo_servico_bancario in (13,18) and -- Siape e Pensionista 
             Upper(rtrim(substring(@linha,1,4)))<>'SIAP' and 
             Upper(rtrim(substring(@linha,1,4)))<>'PENS'
          Begin -- 2.2

             set @linha_aux = @linha
             
             -- Localizar Codigo Parcela -- Nosso Numero Sistema Antigo
             Select @nosso_numero = '', @nn='' , @cd_parcela = null , @cd_tipo_recebimento = null , @vl_parcela = null , @qtde_parcelas = 0 
             
			  Declare Dados_Cursor_RB  cursor for  
			   select cd_parcela, cd_tipo_recebimento, vl_parcela+isnull(vl_acrescimo,0)-isnull(vl_desconto,0)-isnull(vl_imposto,0) +ISNULL(vl_taxa,0)+isnull(vl_jurosmultareferencia,0)+isnull(vl_acrescimoavulso,0)-isnull(vl_descontoavulso,0), a.cd_associado --, m.dt_vencimento
				 from MENSALIDADES as m, associados as a , empresa as e
				where m.cd_associado_empresa = a.cd_associado and 
				      m.tp_associado_empresa = 1 and 
				      a.cd_empresa = e.cd_empresa and 
				      e.cd_tipo_pagamento = @cd_tipo_pagamento and 
				      a.nr_cpf=substring(@linha_aux,case when @nsa=1 then 74 else 77 end,11) and 
				      m.dt_vencimento>=@dt_vencimento and 
				      m.dt_vencimento< dateadd(month,1,@dt_vencimento) and 
				      m.cd_tipo_recebimento not in (1) and 
				      m.cd_tipo_parcela = 1 
				
  			  Open Dados_Cursor_RB
			  Fetch next from Dados_Cursor_RB Into @cd_parcela, @cd_tipo_recebimento, @vl_parcela , @nosso_numero --,@dt_vencimento
			  While (@@fetch_status  <> -1)
				Begin -- 3.1            
	              
				   if @qtde_parcelas=0 
					  set @nn = @nosso_numero
				   else
					  set @nn = @nn + ','+@nosso_numero
	              
				   set @qtde_parcelas = @qtde_parcelas + 1 
	          
				   Fetch next from Dados_Cursor_RB Into @cd_parcela, @cd_tipo_recebimento, @vl_parcela , @nosso_numero --,@dt_vencimento
				End -- 3.1
				Close Dados_Cursor_RB
				Deallocate Dados_Cursor_RB
				
				select @cd_ocorrencia = (case 
					 when @qtde_parcelas = 0 then 97 -- NOSSO NUMERO NÃO ENCONTRADO
					 when @qtde_parcelas = 1 and @cd_tipo_recebimento=0 and Abs(convert(int,substring(@linha_aux,case when @nsa=1 then 91 else 94 end,11))-convert(int,(@vl_parcela*100)))>200 then 104 -- VALOR DA PARCELA INCORRETO
					 when @qtde_parcelas = 1 and @cd_tipo_recebimento=1 then 102 -- NOSSO NUMERO EXCLUIDO
					 when @qtde_parcelas = 1 and @cd_tipo_recebimento=2 then 103 -- NOSSO NUMERO ACORDADO
					 when @qtde_parcelas = 1 and @cd_tipo_recebimento>2 then 101 -- NOSSO NUMERO BAIXADO ANTERIORMENTE
					 when @qtde_parcelas > 1 then 100 
					 else 0 
					 End)	 
            
            if @cd_ocorrencia > 96 --and @cd_ocorrencia <> 101 -- 00 - Efetuado, Ate 96 são erros que nao afetam a baixa
               set @erro = 1
               
             set @qtde = @qtde + 1 
             
             if @cd_ocorrencia=0 -- So atualiza o valor se deu correto
				Set @valor = @valor + convert(money,substring(@linha_aux,case when @nsa=1 then 91 else 97 end,11))/100
             
			 insert Lote_Processos_Bancos_Retorno_Mensalidades 
               (cd_sequencial_retorno,  nr_linha , cd_parcela, cd_ocorrencia, dt_venc, dt_pago, vl_parcela, 
                vl_multa, vl_desconto, vl_tarifa, vl_pago, nn, nm_linha)
              values (@sequencial_retorno, @qtde , 
                case when @qtde_parcelas <> 1 then Null Else @cd_parcela End,
                @cd_ocorrencia , 
                @dt_vencimento ,  -- venc               
                case when @dt_pago IS null then @dt_Vencimento else @dt_pago end , -- pgto
                convert(money,substring(@linha_aux,case when @nsa=1 then 91 else 94 end,11))/100, -- parcela
                0, -- multa
                0, -- desconto
                0, -- tarifa
                convert(money,substring(@linha_aux,case when @nsa=1 then 91 else 94 end,11))/100, -- pago
                substring(@linha_aux,case when @nsa=1 then 74 else 77 end,11), 
                @linha_aux)   

                if @@ROWCOUNT = 0 
                begin -- 2.3.2
                
                   print @sequencial_retorno
                   print @qtde
                   print @qtde_parcelas
                   print @cd_ocorrencia
    			   print @linha_aux
                   set @erro = 9  -- Não processar o arquivo
                end -- 2.3.2   
                
          End -- 2.2
 
          if @cd_tipo_servico_bancario=14 and -- GEPB 
             Upper(rtrim(substring(@linha,1,4)))<>'GEPB' and 
             substring(@linha,1,19)<>'matricula;cpf;nome;'
          Begin -- 2.2

             set @linha_aux = @linha
             
             -- Localizar Codigo Parcela -- Nosso Numero Sistema Antigo
             Select @nosso_numero = '', @nn='' , @cd_parcela = null , @cd_tipo_recebimento = null , @vl_parcela = null , @qtde_parcelas = 0 
             
			  Declare Dados_Cursor_RB  cursor for  
			   select cd_parcela, cd_tipo_recebimento, vl_parcela+isnull(vl_acrescimo,0)-isnull(vl_desconto,0)-isnull(vl_imposto,0) +ISNULL(vl_taxa,0)+isnull(vl_jurosmultareferencia,0)+isnull(vl_acrescimoavulso,0)-isnull(vl_descontoavulso,0) , a.cd_associado --, m.dt_vencimento
				 from MENSALIDADES as m, associados as a , empresa as e
				where m.cd_associado_empresa = a.cd_associado and 
				      m.tp_associado_empresa = 1 and 
				      a.cd_empresa = e.cd_empresa and 
				      e.cd_tipo_pagamento = @cd_tipo_pagamento and 
				      a.nr_cpf=replace(replace(dbo.SepararPalavra(';',2,@linha_aux),'-',''),'.','') and 
				      m.dt_vencimento>=@dt_vencimento and 
				      m.dt_vencimento< dateadd(month,1,@dt_vencimento) and 
				      m.cd_tipo_recebimento not in (1) and 
				      m.cd_tipo_parcela = 1 
				
  			  Open Dados_Cursor_RB
			  Fetch next from Dados_Cursor_RB Into @cd_parcela, @cd_tipo_recebimento, @vl_parcela , @nosso_numero --,@dt_vencimento
			  While (@@fetch_status  <> -1)
				Begin -- 3.1            
	              
				   if @qtde_parcelas=0 
					  set @nn = @nosso_numero
				   else
					  set @nn = @nn + ','+@nosso_numero
	              
				   set @qtde_parcelas = @qtde_parcelas + 1 
	          
				   Fetch next from Dados_Cursor_RB Into @cd_parcela, @cd_tipo_recebimento, @vl_parcela , @nosso_numero --,@dt_vencimento
				End -- 3.1
				Close Dados_Cursor_RB
				Deallocate Dados_Cursor_RB
				
				select @cd_ocorrencia = (case 
					 when @qtde_parcelas = 0 then 97 -- NOSSO NUMERO NÃO ENCONTRADO
					 when @qtde_parcelas = 1 and @cd_tipo_recebimento=0 and Abs(convert(int,replace(dbo.SepararPalavra(';',8,@linha_aux),',',''))-convert(int,(@vl_parcela*100)))>200 then 104 -- VALOR DA PARCELA INCORRETO
					 when @qtde_parcelas = 1 and @cd_tipo_recebimento=1 then 102 -- NOSSO NUMERO EXCLUIDO
					 when @qtde_parcelas = 1 and @cd_tipo_recebimento=2 then 103 -- NOSSO NUMERO ACORDADO
					 when @qtde_parcelas = 1 and @cd_tipo_recebimento>2 then 101 -- NOSSO NUMERO BAIXADO ANTERIORMENTE
					 when @qtde_parcelas > 1 then 100 
					 else 0 
					 End)	 
            
            if @cd_ocorrencia > 96 --and @cd_ocorrencia <> 101 -- 00 - Efetuado, Ate 96 são erros que nao afetam a baixa
               set @erro = 1
               
             set @qtde = @qtde + 1 
             
             if @cd_ocorrencia=0 -- So atualiza o valor se deu correto
				Set @valor = @valor + convert(money,replace(dbo.SepararPalavra(';',8,@linha_aux),',',''))/100
             
			 insert Lote_Processos_Bancos_Retorno_Mensalidades 
               (cd_sequencial_retorno,  nr_linha , cd_parcela, cd_ocorrencia, dt_venc, dt_pago, vl_parcela, 
                vl_multa, vl_desconto, vl_tarifa, vl_pago, nn, nm_linha)
              values (@sequencial_retorno, @qtde , 
                case when @qtde_parcelas <> 1 then Null Else @cd_parcela End,
                @cd_ocorrencia , 
                @dt_vencimento ,  -- venc               
                case when @dt_pago IS null then @dt_Vencimento else @dt_pago end , -- pgto
                convert(money,replace(dbo.SepararPalavra(';',8,@linha_aux),',',''))/100, -- parcela
                0, -- multa
                0, -- desconto
                0, -- tarifa
                convert(money,replace(dbo.SepararPalavra(';',8,@linha_aux),',',''))/100, -- pago
                dbo.SepararPalavra(';',2,@linha_aux), 
                @linha_aux)   

                if @@ROWCOUNT = 0 
                begin -- 2.3.2
                
                   print @sequencial_retorno
                   print @qtde
                   print @qtde_parcelas
                   print @cd_ocorrencia
    			   print @linha_aux
                   set @erro = 9  -- Não processar o arquivo
                end -- 2.3.2   
                
          End -- 2.2
          
          if @cd_tipo_servico_bancario=15 and -- PMJP 
             Upper(rtrim(substring(@linha,1,4)))<>'PMJP' and 
             substring(@linha,1,28)<>'Nome;Doc. Federal;Matricula;'
          Begin -- 2.2

             set @linha_aux = @linha
             
             -- Localizar Codigo Parcela -- Nosso Numero Sistema Antigo
             Select @nosso_numero = '', @nn='' , @cd_parcela = null , @cd_tipo_recebimento = null , @vl_parcela = null , @qtde_parcelas = 0 
             
			  Declare Dados_Cursor_RB  cursor for  
			   select cd_parcela, cd_tipo_recebimento,vl_parcela+isnull(vl_acrescimo,0)-isnull(vl_desconto,0)-isnull(vl_imposto,0) +ISNULL(vl_taxa,0)+isnull(vl_jurosmultareferencia,0)+isnull(vl_acrescimoavulso,0)-isnull(vl_descontoavulso,0), a.cd_associado --, m.dt_vencimento
				 from MENSALIDADES as m, associados as a , empresa as e
				where m.cd_associado_empresa = a.cd_associado and 
				      m.tp_associado_empresa = 1 and 
				      a.cd_empresa = e.cd_empresa and 
				      e.cd_tipo_pagamento = @cd_tipo_pagamento and 
				      a.nr_cpf=dbo.SepararPalavra(';',2,@linha_aux) and 
				      m.dt_vencimento>=@dt_vencimento and 
				      m.dt_vencimento< dateadd(month,1,@dt_vencimento) and 
				      m.cd_tipo_recebimento not in (1) and 
				      m.cd_tipo_parcela = 1 
				
  			  Open Dados_Cursor_RB
			  Fetch next from Dados_Cursor_RB Into @cd_parcela, @cd_tipo_recebimento, @vl_parcela , @nosso_numero --,@dt_vencimento
			  While (@@fetch_status  <> -1)
				Begin -- 3.1            
	              
				   if @qtde_parcelas=0 
					  set @nn = @nosso_numero
				   else
					  set @nn = @nn + ','+@nosso_numero
	              
				   set @qtde_parcelas = @qtde_parcelas + 1 
	          
				   Fetch next from Dados_Cursor_RB Into @cd_parcela, @cd_tipo_recebimento, @vl_parcela , @nosso_numero --,@dt_vencimento
				End -- 3.1
				Close Dados_Cursor_RB
				Deallocate Dados_Cursor_RB
				
				if dbo.SepararPalavra(';',16,@linha_aux)<>'DESCONTADO'
				   Set @cd_ocorrencia = 56
                else
                begin
                print '200 - valor arqvo' + convert(varchar(15), Abs(convert(int,replace(dbo.SepararPalavra(';',15,@linha_aux),',','')))) 
                print '200 - valor fatur' + convert(varchar(15), Abs(convert(int,(@vl_parcela*100))))
                print convert(varchar(5),@cd_parcela )
					select @cd_ocorrencia = (case 
						 when @qtde_parcelas = 0 then 97 -- NOSSO NUMERO NÃO ENCONTRADO
						 when @qtde_parcelas = 1 and @cd_tipo_recebimento=0 and Abs(convert(int,replace(dbo.SepararPalavra(';',15,@linha_aux),',',''))-convert(int,(@vl_parcela*100)))>200 then 104 -- VALOR DA PARCELA INCORRETO
						 when @qtde_parcelas = 1 and @cd_tipo_recebimento=1 then 102 -- NOSSO NUMERO EXCLUIDO
						 when @qtde_parcelas = 1 and @cd_tipo_recebimento=2 then 103 -- NOSSO NUMERO ACORDADO
						 when @qtde_parcelas = 1 and @cd_tipo_recebimento>2 then 101 -- NOSSO NUMERO BAIXADO ANTERIORMENTE
						 when @qtde_parcelas > 1 then 100 
						 else 0 
					  End)
            end
            
            if @cd_ocorrencia > 96 --and @cd_ocorrencia <> 101 -- 00 - Efetuado, Ate 96 são erros que nao afetam a baixa
               set @erro = 1
               
             set @qtde = @qtde + 1 
             print substring(@linha,12,7)
             
             if @cd_ocorrencia=0 -- So atualiza o valor se deu correto
				Set @valor = @valor + convert(money,replace(dbo.SepararPalavra(';',15,@linha_aux),',',''))/100
             
			 insert Lote_Processos_Bancos_Retorno_Mensalidades 
               (cd_sequencial_retorno,  nr_linha , cd_parcela, cd_ocorrencia, dt_venc, dt_pago, vl_parcela, 
                vl_multa, vl_desconto, vl_tarifa, vl_pago, nn, nm_linha)
              values (@sequencial_retorno, @qtde , 
                case when @qtde_parcelas <> 1 then Null Else @cd_parcela End,
                @cd_ocorrencia , 
                @dt_vencimento ,  -- venc               
                case when @dt_pago IS null then @dt_Vencimento else @dt_pago end , -- pgto
                convert(money,replace(dbo.SepararPalavra(';',15,@linha_aux),',',''))/100, -- parcela
                0, -- multa
                0, -- desconto
                0, -- tarifa
                convert(money,replace(dbo.SepararPalavra(';',15,@linha_aux),',',''))/100, -- pago
                dbo.SepararPalavra(';',2,@linha_aux), 
                @linha_aux)   

                if @@ROWCOUNT = 0 
                begin -- 2.3.2
                
                   print @sequencial_retorno
                   print @qtde
                   print @qtde_parcelas
                   print @cd_ocorrencia
    			   print @linha_aux
                   set @erro = 9  -- Não processar o arquivo
                end -- 2.3.2   
                
          End -- 2.2

          if @cd_tipo_servico_bancario=16 and -- Cartao de Credito - EDS/VAN
             substring(@linha,1,2) = '01' -- Linha de detalhes
          Begin -- 2.2

             set @linha_aux = @linha
             
             -- Localizar Codigo Parcela -- Nosso Numero Sistema Antigo
             Select @nosso_numero = '', @nn='' , @cd_parcela = null , @cd_tipo_recebimento = null , @vl_parcela = null , @qtde_parcelas = 0 
             
			  Declare Dados_Cursor_RB  cursor for  
			   select cd_parcela, cd_tipo_recebimento, vl_parcela+isnull(vl_acrescimo,0)-isnull(vl_desconto,0)-isnull(vl_imposto,0) +ISNULL(vl_taxa,0)+isnull(vl_jurosmultareferencia,0)+isnull(vl_acrescimoavulso,0)-isnull(vl_descontoavulso,0), Nosso_numero,dt_vencimento
				 from MENSALIDADES 
				where cd_parcela=SUBSTRING(@linha_aux,3,7)
  			  Open Dados_Cursor_RB
			  Fetch next from Dados_Cursor_RB Into @cd_parcela, @cd_tipo_recebimento, @vl_parcela , @nosso_numero, @dt_vencimento
			  While (@@fetch_status  <> -1)
				Begin -- 3.1            
	              
				   if @qtde_parcelas=0 
					  set @nn = @nosso_numero
				   else
					  set @nn = @nn + ','+@nosso_numero
	              
				   set @qtde_parcelas = @qtde_parcelas + 1 
	          
				   Fetch next from Dados_Cursor_RB Into @cd_parcela, @cd_tipo_recebimento, @vl_parcela , @nosso_numero, @dt_vencimento
				End -- 3.1
				Close Dados_Cursor_RB
				Deallocate Dados_Cursor_RB
                 
            
            set @cd_ocorrencia = case when substring(@linha_aux,172,2)<>'00' then 200+CONVERT(int,substring(@linha_aux,172,2)) else 0 end 
            
            print @cd_ocorrencia

            if @cd_ocorrencia= 0 -- Caso tenha sido debitado verificar se tem algum problema
            begin
				select @cd_ocorrencia = (case 
					 when @qtde_parcelas = 0 then 97 -- NOSSO NUMERO NÃO ENCONTRADO
					 when @qtde_parcelas = 1 and @cd_tipo_recebimento=0 and Abs(convert(int,substring(@linha_aux,44,15))-convert(int,(@vl_parcela*100)))>100 then 104 -- VALOR DA PARCELA INCORRETO
					 when @qtde_parcelas = 1 and @cd_tipo_recebimento=1 then 102 -- NOSSO NUMERO EXCLUIDO
					 when @qtde_parcelas = 1 and @cd_tipo_recebimento=2 then 103 -- NOSSO NUMERO ACORDADO
					 when @qtde_parcelas = 1 and @cd_tipo_recebimento>2 then 101 -- NOSSO NUMERO BAIXADO ANTERIORMENTE
					 when @qtde_parcelas > 1 then 100 
					 else 0 
				  End)
            end
            
            if @cd_ocorrencia > 96 and @cd_ocorrencia < 200 -- 00 - Efetuado, Ate 96 são erros que nao afetam a baixa ou superior a 200
               set @erro = 1
               
             set @qtde = @qtde + 1 
             if @cd_ocorrencia=0 -- So atualiza o valor se deu correto
				Set @valor = @valor + convert(money,substring(@linha,44,15))/100
             
			 insert Lote_Processos_Bancos_Retorno_Mensalidades 
               (cd_sequencial_retorno,  nr_linha , cd_parcela, cd_ocorrencia, dt_venc, dt_pago, vl_parcela, 
                vl_multa, vl_desconto, vl_tarifa, vl_pago, nn, nm_linha)
              values (@sequencial_retorno, @qtde , 
                case when @qtde_parcelas <> 1 then Null Else @cd_parcela End,
                @cd_ocorrencia , 
                @dt_vencimento ,  -- venc               
                substring(@linha,37,2)+'/'+substring(@linha,35,2)+'/'+substring(@linha,39,4) , -- pgto
                convert(money,substring(@linha_aux,44,15))/100, -- parcela
                0, -- multa
                0, -- desconto
                0, -- tarifa
                convert(money,substring(@linha,44,15))/100, -- pago
                @cd_parcela , 
                @linha_aux)   

                if @@ROWCOUNT = 0 
                begin -- 2.3.2
                
                   print @sequencial_retorno
                   print @qtde
                   print @qtde_parcelas
                   print @cd_ocorrencia
    			   print @linha_aux
                   set @erro = 9  -- Não processar o arquivo
                end -- 2.3.2   
                
          End -- 2.2
       
          if @cd_tipo_servico_bancario=46 and -- TITULO DE COBRANÇA
             substring(@linha,1,1) = '1' and 
             substring(@linha,109,2) in ('02','03','06','09','10','15','16','17','24','30','32')  -- Linha de detalhe
          Begin -- 2.3             
             
             -- Localizar Codigo Parcela -- Nosso Numero Sistema Antigo
             Select @nosso_numero = convert(varchar(20),convert(bigint,rtrim(ltrim(SUBSTRING(@linha,71,11))))), @nn='' , @cd_parcela = null , @cd_tipo_recebimento = null , @vl_parcela = null , @qtde_parcelas = 0 ,
                    @qt_agrupada = null, @qt_aberta=0,@qt_excluida=0,@qt_acordo=0,@qt_baixada=0
			 print @nosso_numero
			  
			 Declare Dados_Cursor_RB  cursor for              
			   select cd_parcela, cd_tipo_recebimento,  vl_parcela+isnull(vl_acrescimo,0)-isnull(vl_desconto,0)-isnull(vl_imposto,0) +ISNULL(vl_taxa,0)+isnull(vl_jurosmultareferencia,0)+isnull(vl_acrescimoavulso,0)-isnull(vl_descontoavulso,0), cd_parcela,
			   (select count(cd_parcela) from MENSALIDADES where CD_TIPO_RECEBIMENTO = 0 and CD_PARCELA in (
					  select cd_parcela from MensalidadesAgrupadas where cd_parcelaMae in (select cd_parcela from MENSALIDADES where nosso_numero in (@nosso_numero) ) 
																											)
			   ) as abertas,
			   (select count(cd_parcela) from MENSALIDADES where CD_TIPO_RECEBIMENTO = 1 and CD_PARCELA in (
					  select cd_parcela from MensalidadesAgrupadas where cd_parcelaMae in (select cd_parcela from MENSALIDADES where nosso_numero in (@nosso_numero) ) 
																											)
			   ) as exc,
			   (select count(cd_parcela) from MENSALIDADES where CD_TIPO_RECEBIMENTO = 2 and CD_PARCELA in (
					  select cd_parcela from MensalidadesAgrupadas where cd_parcelaMae in (select cd_parcela from MENSALIDADES where nosso_numero in (@nosso_numero) ) 
																											)
			   ) as acor,
			   (select count(cd_parcela) from MENSALIDADES where CD_TIPO_RECEBIMENTO > 2 and CD_PARCELA in (
					  select cd_parcela from MensalidadesAgrupadas where cd_parcelaMae in (select cd_parcela from MENSALIDADES where nosso_numero in (@nosso_numero) ) 
																											)
			   ) as baixadas  			   
				 from MENSALIDADES 
				where nosso_numero= @nosso_numero
				      
				      
  			  Open Dados_Cursor_RB
			  Fetch next from Dados_Cursor_RB Into @cd_parcela, @cd_tipo_recebimento, @vl_parcela , @nosso_numero , @qt_aberta, @qt_excluida, @qt_acordo, @qt_baixada
			  While (@@fetch_status  <> -1)
				Begin -- 3.1            

				   if @qtde_parcelas=0 
					  set @nn = @nosso_numero
				   else
					  set @nn = @nn + ','+@nosso_numero
	              
				   set @qtde_parcelas = @qtde_parcelas + 1 
	          
				   Fetch next from Dados_Cursor_RB Into @cd_parcela, @cd_tipo_recebimento, @vl_parcela , @nosso_numero , @qt_aberta, @qt_excluida, @qt_acordo, @qt_baixada
				End -- 3.1
				Close Dados_Cursor_RB
				Deallocate Dados_Cursor_RB
                 
               
            set @qt_agrupada = isnull(@qt_aberta,0)+isnull(@qt_excluida,0)+isnull(@qt_acordo,0)+isnull(@qt_baixada,0)
            
            set @cd_ocorrencia = case when substring(@linha,109,2) in ('06','15','16','17') then 0 else 800+CONVERT(int,substring(@linha,109,2)) end 
            
            if @cd_ocorrencia = 0 
            Begin 
				select @cd_ocorrencia = (case 
					 when @qtde_parcelas > 1 then 100 
					 				
					 when @qt_agrupada>0 and @qt_aberta>0 and @qt_baixada=0 and @qt_excluida=0 and @qt_acordo=0 then 35
					 when @qt_agrupada>0 and @qt_baixada>0 then 101                 
					 when @qt_agrupada>0 and @qt_excluida>0 then 102
					 when @qt_agrupada>0 and @qt_acordo>0 then 103
					 when @qt_agrupada>0 and @qt_aberta=0 then 105 
	            
					 when @qtde_parcelas = 0 then 97 -- NOSSO NUMERO NÃO ENCONTRADO
					 when @qtde_parcelas = 1 and @cd_tipo_recebimento=0 and Abs(convert(int,substring(@linha,153,13))-convert(int,(@vl_parcela*100)))>100 then 104 -- VALOR DA PARCELA INCORRETO
					 when @qtde_parcelas = 1 and @cd_tipo_recebimento=1 then 102 -- NOSSO NUMERO EXCLUIDO
					 when @qtde_parcelas = 1 and @cd_tipo_recebimento=2 then 103 -- NOSSO NUMERO ACORDADO
					 when @qtde_parcelas = 1 and @cd_tipo_recebimento>2 then 101 -- NOSSO NUMERO BAIXADO ANTERIORMENTE

					 Else 0
				  End)
            
				if @cd_ocorrencia not in (0,35) 
				   set @erro = 1
				Set @valor = @valor + convert(money,substring(@linha,254,13))/100   
				set @dt_prevista_credito = convert(varchar(10),substring(@linha,298,2)+'/'+substring(@linha,296,2)+'/20'+substring(@linha,300,2),101)
				   
             End   
             set @qtde = @qtde + 1 
             

             insert Lote_Processos_Bancos_Retorno_Mensalidades 
               (cd_sequencial_retorno,  nr_linha , cd_parcela, cd_ocorrencia, dt_venc, dt_pago, vl_parcela, 
                vl_multa, vl_desconto, vl_tarifa, vl_pago, nn,dt_credito, cd_ocorrencia_auxiliar, nm_linha)
              values (@sequencial_retorno, @qtde , 
                case when @cd_ocorrencia >= 800 then convert(varchar(20),convert(bigint,rtrim(ltrim(SUBSTRING(@linha,38,11))))) 
                     when @qtde_parcelas <> 1 then Null 
                     Else @cd_parcela End,
                @cd_ocorrencia , 
                case when substring(@linha,147,6) = '000000' then null else substring(@linha,149,2)+'/'+substring(@linha,147,2)+'/'+substring(@linha,151,2) end ,  -- venc               
                substring(@linha,113,2)+'/'+substring(@linha,111,2)+'/'+substring(@linha,115,2) , -- pgto
                convert(money,substring(@linha,153,13))/100, -- parcela
                convert(money,substring(@linha,267,13))/100, -- multa
                convert(money,substring(@linha,241,13))/100, -- desconto
                convert(money,substring(@linha,176,13))/100, -- tarifa
                convert(money,substring(@linha,254,13))/100, -- pago
                
                -- Case when @cd_ocorrencia = 97 OR @cd_ocorrencia >= 700 then SUBSTRING(@linha,53,10) else @nn End , 

                convert(varchar(20),convert(bigint,rtrim(ltrim(SUBSTRING(@linha,71,11))))),                                    
                 
                Case when @cd_ocorrencia >= 800 then null else @dt_prevista_credito end ,
                case when SUBSTRING(@linha,319,2)<>'  ' then SUBSTRING(@linha,319,10) else null end, 
                @linha_aux)    
                if @@ROWCOUNT = 0 
                begin -- 2.3.2
                   set @erro = 1  -- Não processar o arquivo
                end -- 2.3.2   
                
                --print 'Insert Mens F' 
               
          End -- 2.3
          

          if @cd_tipo_servico_bancario=17 and -- Cartao de Credito - HiperCard
             substring(@linha,1,2) = '52' -- Linha de detalhes
          Begin -- 2.2

             set @linha_aux = @linha
             
             -- Localizar Codigo Parcela -- Nosso Numero Sistema Antigo
             Select @nosso_numero = '', @nn='' , @cd_parcela = null , @cd_tipo_recebimento = null , @vl_parcela = null , @qtde_parcelas = 0 
             
			  Declare Dados_Cursor_RB  cursor for  
			   select cd_parcela, cd_tipo_recebimento, vl_parcela+isnull(vl_acrescimo,0)-isnull(vl_desconto,0)-isnull(vl_imposto,0) +ISNULL(vl_taxa,0)+isnull(vl_jurosmultareferencia,0)+isnull(vl_acrescimoavulso,0)-isnull(vl_descontoavulso,0) , Nosso_numero,dt_vencimento
				 from MENSALIDADES 
				where cd_parcela=SUBSTRING(@linha_aux,85,14)
  			  Open Dados_Cursor_RB
			  Fetch next from Dados_Cursor_RB Into @cd_parcela, @cd_tipo_recebimento, @vl_parcela , @nosso_numero, @dt_vencimento
			  While (@@fetch_status  <> -1)
				Begin -- 3.1            
	              
				   if @qtde_parcelas=0 
					  set @nn = @nosso_numero
				   else
					  set @nn = @nn + ','+@nosso_numero
	              
				   set @qtde_parcelas = @qtde_parcelas + 1 
	          
				   Fetch next from Dados_Cursor_RB Into @cd_parcela, @cd_tipo_recebimento, @vl_parcela , @nosso_numero, @dt_vencimento
				End -- 3.1
				Close Dados_Cursor_RB
				Deallocate Dados_Cursor_RB
                 
            
            set @cd_ocorrencia = case when substring(@linha_aux,109,2)<>'00' then 300+CONVERT(int,substring(@linha_aux,109,2)) else 0 end 
            
            print @cd_ocorrencia

            if @cd_ocorrencia= 0 -- Caso tenha sido debitado verificar se tem algum problema
            begin
				select @cd_ocorrencia = (case 
					 when @qtde_parcelas = 0 then 97 -- NOSSO NUMERO NÃO ENCONTRADO
					 when @qtde_parcelas = 1 and @cd_tipo_recebimento=0 and Abs(convert(int,substring(@linha_aux,57,11))-convert(int,(@vl_parcela*100)))>100 then 104 -- VALOR DA PARCELA INCORRETO
					 when @qtde_parcelas = 1 and @cd_tipo_recebimento=1 then 102 -- NOSSO NUMERO EXCLUIDO
					 when @qtde_parcelas = 1 and @cd_tipo_recebimento=2 then 103 -- NOSSO NUMERO ACORDADO
					 when @qtde_parcelas = 1 and @cd_tipo_recebimento>2 then 101 -- NOSSO NUMERO BAIXADO ANTERIORMENTE
					 when @qtde_parcelas > 1 then 100 
					 else 0 
				  End)
            end
            
            if @cd_ocorrencia > 96 and @cd_ocorrencia < 200 -- 00 - Efetuado, Ate 96 são erros que nao afetam a baixa ou superior a 200
               set @erro = 1
               
             set @qtde = @qtde + 1 
             if @cd_ocorrencia=0 -- So atualiza o valor se deu correto
				Set @valor = @valor + convert(money,substring(@linha,57,11))/100
             
			 insert Lote_Processos_Bancos_Retorno_Mensalidades 
               (cd_sequencial_retorno,  nr_linha , cd_parcela, cd_ocorrencia, dt_venc, dt_pago, vl_parcela, 
                vl_multa, vl_desconto, vl_tarifa, vl_pago, nn, nm_linha)
              values (@sequencial_retorno, @qtde , 
                case when @qtde_parcelas <> 1 then Null Else @cd_parcela End,
                @cd_ocorrencia , 
                @dt_vencimento ,  -- venc               
                substring(@linha,15,2)+'/'+substring(@linha,17,2)+'/'+substring(@linha,11,4) , -- pgto
                convert(money,substring(@linha_aux,57,11))/100, -- parcela
                0, -- multa
                0, -- desconto
                0, -- tarifa
                convert(money,substring(@linha,57,11))/100, -- pago
                convert(varchar(20),@cd_parcela)+'-'+substring(@linha_aux,32,19) , 
                @linha_aux)   

                if @@ROWCOUNT = 0 
                begin -- 2.3.2
                
                   print @sequencial_retorno
                   print @qtde
                   print @qtde_parcelas
                   print @cd_ocorrencia
    			   print @linha_aux
                   set @erro = 9  -- Não processar o arquivo
                end -- 2.3.2   
                
          End -- 2.2

          if @cd_tipo_servico_bancario=19 and -- Cartao de Credito - HIPERCARD - TO
             substring(@linha,1,2) = '01' -- Linha de detalhes
          Begin -- 2.2

             set @linha_aux = @linha
             
             -- Localizar Codigo Parcela -- Nosso Numero Sistema Antigo
             Select @nosso_numero = '', @nn='' , @cd_parcela = null , @cd_tipo_recebimento = null , @vl_parcela = null , @qtde_parcelas = 0 
             
			  Declare Dados_Cursor_RB  cursor for  
			   select cd_parcela, cd_tipo_recebimento, vl_parcela+isnull(vl_acrescimo,0)-isnull(vl_desconto,0)-isnull(vl_imposto,0) +ISNULL(vl_taxa,0)+isnull(vl_jurosmultareferencia,0)+isnull(vl_acrescimoavulso,0)-isnull(vl_descontoavulso,0) , Nosso_numero,dt_vencimento
				 from MENSALIDADES 
				where cd_parcela=SUBSTRING(@linha_aux,3,13)
  			  Open Dados_Cursor_RB
			  Fetch next from Dados_Cursor_RB Into @cd_parcela, @cd_tipo_recebimento, @vl_parcela , @nosso_numero, @dt_vencimento
			  While (@@fetch_status  <> -1)
				Begin -- 3.1            
	              
				   if @qtde_parcelas=0 
					  set @nn = @nosso_numero
				   else
					  set @nn = @nn + ','+@nosso_numero
	              
				   set @qtde_parcelas = @qtde_parcelas + 1 
	          
				   Fetch next from Dados_Cursor_RB Into @cd_parcela, @cd_tipo_recebimento, @vl_parcela , @nosso_numero, @dt_vencimento
				End -- 3.1
				Close Dados_Cursor_RB
				Deallocate Dados_Cursor_RB
                 
            
            set @cd_ocorrencia = case when substring(@linha_aux,198,2)<>'00' then 600+CONVERT(int,substring(@linha_aux,198,2)) else 0 end 
            
            print @cd_ocorrencia

            if @cd_ocorrencia= 0 -- Caso tenha sido debitado verificar se tem algum problema
            begin
				select @cd_ocorrencia = (case 
					 when @qtde_parcelas = 0 then 97 -- NOSSO NUMERO NÃO ENCONTRADO
					 when @qtde_parcelas = 1 and @cd_tipo_recebimento=0 and Abs(convert(int,substring(@linha_aux,59,15))-convert(int,(@vl_parcela*100)))>100 then 104 -- VALOR DA PARCELA INCORRETO
					 when @qtde_parcelas = 1 and @cd_tipo_recebimento=1 then 102 -- NOSSO NUMERO EXCLUIDO
					 when @qtde_parcelas = 1 and @cd_tipo_recebimento=2 then 103 -- NOSSO NUMERO ACORDADO
					 when @qtde_parcelas = 1 and @cd_tipo_recebimento>2 then 101 -- NOSSO NUMERO BAIXADO ANTERIORMENTE
					 when @qtde_parcelas > 1 then 100 
					 else 0 
				  End)
            end
            
            if @cd_ocorrencia > 96 and @cd_ocorrencia < 200 -- 00 - Efetuado, Ate 96 são erros que nao afetam a baixa ou superior a 200
               set @erro = 1
               
             set @qtde = @qtde + 1 
             if @cd_ocorrencia=0 -- So atualiza o valor se deu correto
				Set @valor = @valor + convert(money,substring(@linha,59,15))/100
             
			 insert Lote_Processos_Bancos_Retorno_Mensalidades 
               (cd_sequencial_retorno,  nr_linha , cd_parcela, cd_ocorrencia, dt_venc, dt_pago, vl_parcela, 
                vl_multa, vl_desconto, vl_tarifa, vl_pago, nn, nm_linha)
              values (@sequencial_retorno, @qtde , 
                case when @qtde_parcelas <> 1 then Null Else @cd_parcela End,
                @cd_ocorrencia , 
                @dt_vencimento ,  -- venc               
                substring(@linha,106,2)+'/'+substring(@linha,108,2)+'/'+substring(@linha,104,2) , -- pgto
                convert(money,substring(@linha_aux,59,15))/100, -- parcela
                0, -- multa
                0, -- desconto
                0, -- tarifa
                convert(money,substring(@linha,59,15))/100, -- pago
                substring(@linha_aux,3,13), 
                @linha_aux)   

                if @@ROWCOUNT = 0 
                begin -- 2.3.2
                
                   print @sequencial_retorno
                   print @qtde
                   print @qtde_parcelas
                   print @cd_ocorrencia
    			   print @linha_aux
                   set @erro = 9  -- Não processar o arquivo
                end -- 2.3.2   
                
          End -- 2.2

          if @cd_tipo_servico_bancario in (1,45) and -- TITULO DE COBRANÇA
             substring(@linha,8,1) = '3' and -- Linha de detalhe
             substring(@linha,14,1) = 'T' 
          Begin -- 2.2 
             -- T : NOSSO_NUMERO = 39,19 : VALOR_TARIFA = 199,1
             print 'entrou servico T'
             set @linha_aux = @linha
             if SUBSTRING(@linha_aux,38,20) <> ''
                Set @despreza = 0 
             else   
                Set @despreza = 1
                
          End -- 2.2 
             
          if @cd_tipo_servico_bancario in (1,45) and -- TITULO DE COBRANÇA
             substring(@linha,8,1) = '3' and -- Linha de detalhe
             substring(@linha,14,1) = 'U' and 
             @despreza = 0 and
             substring(@linha,16,2) in ('02','03','06','09') 
          Begin -- 2.3             
               print 'entrou servico U'
             -- Localizar Codigo Parcela -- Nosso Numero Sistema Antigo
             Select @nosso_numero = '', @nn='' , @cd_parcela = null , @cd_tipo_recebimento = null , @vl_parcela = null , @qtde_parcelas = 0 ,
                    @qt_agrupada = null, @qt_aberta=0,@qt_excluida=0,@qt_acordo=0,@qt_baixada=0
             
            
			  Declare Dados_Cursor_RB  cursor for  
			   select cd_parcela, cd_tipo_recebimento, vl_parcela+isnull(vl_acrescimo,0)-isnull(vl_desconto,0)-isnull(vl_imposto,0) +ISNULL(vl_taxa,0)+isnull(vl_jurosmultareferencia,0)+isnull(vl_acrescimoavulso,0)-isnull(vl_descontoavulso,0) , Nosso_numero,
			   

				   (select count(cd_parcela) from MENSALIDADES where CD_TIPO_RECEBIMENTO = 0 and CD_PARCELA in (
						  select cd_parcela from MensalidadesAgrupadas where cd_parcelaMae in (select cd_parcela from MENSALIDADES 
						   where (NOSSO_NUMERO=rtrim(ltrim(SUBSTRING(@linha_aux,38,20))) or 
				                  NOSSO_NUMERO=SUBSTRING(@linha_aux,case when SUBSTRING(@linha_aux,38,6) = @convenio then 38 else 46 end,11)) and 
				                  dt_vencimento > dateadd(month,-11,getdate()) 
				                                                                               ) 
																												)
				   ) as abertas,
				   (select count(cd_parcela) from MENSALIDADES where CD_TIPO_RECEBIMENTO = 1 and CD_PARCELA in (
						  select cd_parcela from MensalidadesAgrupadas where cd_parcelaMae in (select cd_parcela from MENSALIDADES 
						   where (NOSSO_NUMERO=rtrim(ltrim(SUBSTRING(@linha_aux,38,20))) or 
				                  NOSSO_NUMERO=SUBSTRING(@linha_aux,case when SUBSTRING(@linha_aux,38,6) = @convenio then 38 else 46 end,11)) and 
				                  dt_vencimento > dateadd(month,-11,getdate()) 
				                                                                               ) 

																												)
				   ) as exc,
				   (select count(cd_parcela) from MENSALIDADES where CD_TIPO_RECEBIMENTO = 2 and CD_PARCELA in (
						  select cd_parcela from MensalidadesAgrupadas where cd_parcelaMae in (select cd_parcela from MENSALIDADES 
						   where (NOSSO_NUMERO=rtrim(ltrim(SUBSTRING(@linha_aux,38,20))) or 
				                  NOSSO_NUMERO=SUBSTRING(@linha_aux,case when SUBSTRING(@linha_aux,38,6) = @convenio then 38 else 46 end,11)) and 
				                  dt_vencimento > dateadd(month,-11,getdate()) 
				                                                                               ) 

																												)
				   ) as acor,
				   (select count(cd_parcela) from MENSALIDADES where CD_TIPO_RECEBIMENTO > 2 and CD_PARCELA in (
						  select cd_parcela from MensalidadesAgrupadas where cd_parcelaMae in (select cd_parcela from MENSALIDADES 
						   where (NOSSO_NUMERO=rtrim(ltrim(SUBSTRING(@linha_aux,38,20))) or 
				                  NOSSO_NUMERO=SUBSTRING(@linha_aux,case when SUBSTRING(@linha_aux,38,6) = @convenio then 38 else 46 end,11)) and 
				                  dt_vencimento > dateadd(month,-11,getdate()) 
				                                                                               ) 

																												)
				   ) as baixadas  	
			   
				 from MENSALIDADES 
				where (NOSSO_NUMERO=rtrim(ltrim(SUBSTRING(@linha_aux,38,20))) or 
				       NOSSO_NUMERO=SUBSTRING(@linha_aux,case when SUBSTRING(@linha_aux,38,6) = @convenio then 38 else 46 end,11)) and 
				       dt_vencimento > dateadd(month,-11,getdate())
  			  Open Dados_Cursor_RB
			  Fetch next from Dados_Cursor_RB Into @cd_parcela, @cd_tipo_recebimento, @vl_parcela , @nosso_numero, @qt_aberta, @qt_excluida, @qt_acordo, @qt_baixada
			  While (@@fetch_status  <> -1)
				Begin -- 3.1            

				   if @qtde_parcelas=0 
					  set @nn = @nosso_numero
				   else
					  set @nn = @nn + ','+@nosso_numero
	              
				   set @qtde_parcelas = @qtde_parcelas + 1 
	          
				   Fetch next from Dados_Cursor_RB Into @cd_parcela, @cd_tipo_recebimento, @vl_parcela , @nosso_numero, @qt_aberta, @qt_excluida, @qt_acordo, @qt_baixada
				End -- 3.1
				Close Dados_Cursor_RB
				Deallocate Dados_Cursor_RB
                 
            set @qt_agrupada = isnull(@qt_aberta,0)+isnull(@qt_excluida,0)+isnull(@qt_acordo,0)+isnull(@qt_baixada,0)

            set @cd_ocorrencia = case when  substring(@linha,16,2) in ('06') then 0 else 700+CONVERT(int,substring(@linha,16,2)) end 
           
            if @cd_ocorrencia = 0 
            Begin 
				select @cd_ocorrencia = (case 
					 when @qtde_parcelas > 1 then 100 
					 
					 when @qt_agrupada>0 and @qt_aberta>0 and @qt_baixada=0 and @qt_excluida=0 and @qt_acordo=0 then 35
					 when @qt_agrupada>0 and @qt_baixada>0 then 101                 
					 when @qt_agrupada>0 and @qt_excluida>0 then 102
					 when @qt_agrupada>0 and @qt_acordo>0 then 103
					 when @qt_agrupada>0 and @qt_aberta=0 then 105             

					 when @qtde_parcelas = 0 then 97 -- NOSSO NUMERO NÃO ENCONTRADO
					 when @qtde_parcelas = 1 and @cd_tipo_recebimento=0 and Abs(convert(int,substring(@linha_aux,82,15))-convert(int,(@vl_parcela*100)))>100 then 104 -- VALOR DA PARCELA INCORRETO
					 when @qtde_parcelas = 1 and @cd_tipo_recebimento=1 then 102 -- NOSSO NUMERO EXCLUIDO
					 when @qtde_parcelas = 1 and @cd_tipo_recebimento=2 then 103 -- NOSSO NUMERO ACORDADO
					 when @qtde_parcelas = 1 and @cd_tipo_recebimento>2 then 101 -- NOSSO NUMERO BAIXADO ANTERIORMENTE

					 Else 0
				  End)

			  
				  if @cd_ocorrencia not in (0,35) 
                     set @erro = 1
                  
                  Set @valor = @valor + convert(money,substring(@linha,78,15))/100
                     
            End 

            set @qtde = @qtde + 1 				  


             insert Lote_Processos_Bancos_Retorno_Mensalidades 
               (cd_sequencial_retorno,  nr_linha , cd_parcela, cd_ocorrencia, dt_venc, dt_pago, vl_parcela, 
                vl_multa, vl_desconto, vl_tarifa, vl_pago, nn, dt_credito, nm_linha)
              values (@sequencial_retorno, @qtde , 
                case when @qtde_parcelas <> 1 then Null Else @cd_parcela End,
                @cd_ocorrencia , 
                case when substring(@linha_aux,76,2)+'/'+substring(@linha_aux,74,2)+'/'+substring(@linha_aux,78,4)='00/00/0000' then null else substring(@linha_aux,76,2)+'/'+substring(@linha_aux,74,2)+'/'+substring(@linha_aux,78,4) End ,  -- venc               
                substring(@linha,140,2)+'/'+substring(@linha,138,2)+'/'+substring(@linha,142,4) , -- pgto
                convert(money,substring(@linha_aux,82,15))/100, -- parcela
                convert(money,substring(@linha,18,15))/100, -- multa
                convert(money,substring(@linha,33,15))/100, -- desconto
                convert(money,substring(@linha_aux ,199,15))/100, -- tarifa
                convert(money,substring(@linha,78,15))/100, -- pago
                Case when @cd_ocorrencia=97 then SUBSTRING(@linha_aux,38,20) + ',' + SUBSTRING(@linha_aux,case when SUBSTRING(@linha_aux,38,6) = @convenio then 38 else 46 end,11)  Else @nn End , 
                Case when @cd_ocorrencia >= 100 then null else substring(@linha,148,2)+'/'+substring(@linha,146,2)+'/'+substring(@linha,150,4) end , -- Credito
                @linha_aux)    
                if @@ROWCOUNT = 0 
                begin -- 2.3.2
                
                   print @sequencial_retorno
                   print @qtde
                   print @qtde_parcelas
                   print @cd_ocorrencia
                   print case when substring(@linha_aux,76,2)+'/'+substring(@linha_aux,74,2)+'/'+substring(@linha_aux,78,4)='00/00/0000' then null else substring(@linha_aux,76,2)+'/'+substring(@linha_aux,74,2)+'/'+substring(@linha_aux,78,4) End   -- venc               
					print substring(@linha,140,2)+'/'+substring(@linha,138,2)+'/'+substring(@linha,142,4)  -- pgto
					print convert(money,substring(@linha_aux,82,15))/100 -- parcela
					print convert(money,substring(@linha,18,15))/100 -- multa
					print convert(money,substring(@linha,33,15))/100 -- desconto
					print convert(money,substring(@linha_aux ,199,15))/100 -- tarifa
					print convert(money,substring(@linha,78,15))/100 -- pago
					print Case when @cd_ocorrencia=97 then SUBSTRING(@linha_aux,38,20) + ',' + SUBSTRING(@linha_aux,case when SUBSTRING(@linha_aux,38,6) = @convenio then 38 else 46 end,11)  Else @nn End 
					print @linha_aux
                
                   set @erro = 1  -- Não processar o arquivo
                end -- 2.3.2   
                
                --print 'Insert Mens F' 
               
          End -- 2.3

          --Localizar Associado pelo CPF
		  --Baixar a parcela

          if @cd_tipo_servico_bancario=7 -- Cartao Unico
          Begin -- 2.4             
             
             set @linha_aux = @linha
             -- Localizar Codigo Parcela -- Nosso Numero Sistema Antigo
             Select @nosso_numero = '', @nn='' , @cd_parcela = null , @cd_tipo_recebimento = null , @vl_parcela = null , @qtde_parcelas = 0 , @dt_vencimento =null
             
              --- Aumenta 01 mes na competencia do arquivo
              set @dt_vencimento = dateadd(month,1,CONVERT(datetime,substring(@linha_aux,5,2) + '/01/' + substring(@linha_aux,1,4)))
             
			  Declare Dados_Cursor_RB  cursor for  
			   select cd_parcela, cd_tipo_recebimento, vl_parcela+isnull(vl_acrescimo,0)-isnull(vl_desconto,0)-isnull(vl_imposto,0) +ISNULL(vl_taxa,0)+isnull(vl_jurosmultareferencia,0)+isnull(vl_acrescimoavulso,0)-isnull(vl_descontoavulso,0) , cd_parcela, m.dt_vencimento 
				 from MENSALIDADES as m , associados as a , empresa as e, tipo_pagamento as t 
				where m.cd_associado_empresa = a.cd_associado and 
				      m.tp_Associado_empresa = 1 and 
				      m.cd_tipo_parcela = 1 and 
				      a.cd_empresa = e.cd_empresa and 
				      --m.cd_tipo_recebimento not in (1,2) and 
				      e.cd_tipo_pagamento = t.cd_tipo_pagamento and 
				      t.cd_tipo_servico_bancario=@cd_tipo_servico_bancario and 
				      month(m.dt_vencimento) = month(@dt_vencimento) and 
				      year(m.dt_vencimento) = year(@dt_vencimento) and 
				      a.nr_cpf = substring(@linha_aux,37,11) and 
				      m.cd_tipo_recebimento =0 -- not in (1,2)
				      
  			  Open Dados_Cursor_RB
			  Fetch next from Dados_Cursor_RB Into @cd_parcela, @cd_tipo_recebimento, @vl_parcela , @nosso_numero, @dt_vencimento 
			  While (@@fetch_status  <> -1)
				Begin -- 3.1            
	              
				   if @qtde_parcelas=0 
					  set @nn = @nosso_numero
				   else
					  set @nn = @nn + ','+@nosso_numero
	              
				   set @qtde_parcelas = @qtde_parcelas + 1 
	          
				   Fetch next from Dados_Cursor_RB Into @cd_parcela, @cd_tipo_recebimento, @vl_parcela , @nosso_numero, @dt_vencimento 
				End -- 3.1
				Close Dados_Cursor_RB
				Deallocate Dados_Cursor_RB
                 
            select @cd_ocorrencia = convert(int,SUBSTRING(@linha_aux,35,2))
            if @cd_ocorrencia = 0 
            begin
				select @cd_ocorrencia = (case 
					 when @qtde_parcelas = 0 then 97 -- NOSSO NUMERO NÃO ENCONTRADO
					 when @qtde_parcelas = 1 and @cd_tipo_recebimento=0 and Abs(convert(int,substring(@linha_aux,24,11))-convert(int,(@vl_parcela*100)))>100 then 104 -- VALOR DA PARCELA INCORRETO
					 when @qtde_parcelas = 1 and @cd_tipo_recebimento=1 then 102 -- NOSSO NUMERO EXCLUIDO
					 when @qtde_parcelas = 1 and @cd_tipo_recebimento=2 then 103 -- NOSSO NUMERO ACORDADO
					 when @qtde_parcelas = 1 and @cd_tipo_recebimento>2 then 101 -- NOSSO NUMERO BAIXADO ANTERIORMENTE
					 when @qtde_parcelas > 1 then 100 
					 Else 0 
				  End)
             end
             
            if @cd_ocorrencia=104 
            begin
               print '-----'
               print @nn
               print convert(money,substring(@linha_aux,24,11))-(@vl_parcela*100)
               print substring(@linha_aux,24,11)
               print (@vl_parcela*100)
               print '-----'
            end    
               
            if @cd_ocorrencia > 60 -- Ate 60 os codigos de erro sao do proprio arquivo e deve ser dado baixa
               set @erro = 1

            if @cd_ocorrencia = 0 
            begin
             Set @valor = @valor + convert(money,substring(@linha,24,11))/100
            End 
            
            set @qtde = @qtde + 1 
                             
             insert Lote_Processos_Bancos_Retorno_Mensalidades 
               (cd_sequencial_retorno,  nr_linha , cd_parcela, cd_ocorrencia, dt_venc, dt_pago, vl_parcela, 
                vl_multa, vl_desconto, vl_tarifa, vl_pago, nn, nm_linha)
              values (@sequencial_retorno, @qtde , 
                case when @qtde_parcelas <> 1 then Null Else @cd_parcela End,
                @cd_ocorrencia , 
                @dt_vencimento  ,  -- venc               
                @dt_vencimento  , -- pgto
                convert(money,substring(@linha_aux,24,11))/100, -- parcela
                0, -- multa
                0, -- desconto
                0, -- tarifa
                convert(money,substring(@linha_aux,24,11))/100, -- pago
                Case when @cd_ocorrencia=97 then SUBSTRING(@linha_aux,10,8) + ',' + SUBSTRING(@linha_aux,37,11)  Else @nn End , 
                @linha_aux)    
                if @@ROWCOUNT = 0 
                begin -- 2.3.2
                   set @erro = 1  -- Não processar o arquivo
                end -- 2.3.2   
                
                --print 'Insert Mens F' 
               
          End -- 2.4

          if @cd_tipo_servico_bancario=8 and substring(@linha,1,1) = 'D' -- Coelce
          Begin -- 2.5             
        
             set @linha_aux = @linha
             -- Localizar Codigo Cliente e Matricula 
             Select @nosso_numero = '', @nn='' , @cd_parcela = null , @cd_tipo_recebimento = null , @vl_parcela = null , @qtde_parcelas = 0 , @dt_vencimento =null
             
             If substring(@linha_aux,27,2)='02' 
             Begin
               
               Set @dt_pago = convert(datetime,substring(@linha_aux,31,2)+'/'+substring(@linha_aux,29,2)+'/'+substring(@linha_aux,33,4))
               Set @dt_vencimento = convert(datetime,substring(@linha_aux,129,2)+'/'+substring(@linha_aux,127,2)+'/'+substring(@linha_aux,131,4))		
               Set @nn = 'Mat:'+convert(varchar(15),CONVERT(bigint,substring(@linha_aux,2,25))) + ' - Assoc:'+substring(@linha_aux,360,10) + ' - Parc:'
               
    		   Declare Dados_Cursor_RB  cursor for  
			    select cd_parcela, cd_tipo_recebimento, vl_parcela+isnull(vl_acrescimo,0)-isnull(vl_desconto,0)-isnull(vl_imposto,0) +ISNULL(vl_taxa,0)+isnull(vl_jurosmultareferencia,0)+isnull(vl_acrescimoavulso,0)-isnull(vl_descontoavulso,0) , Nosso_numero,dt_vencimento
				  from MENSALIDADES 
				 where cd_associado_empresa = substring(@linha_aux,360,10) and 
				       tp_Associado_empresa = 1 and 
				       cd_tipo_recebimento not in (1,2) and 
				       cd_tipo_pagamento in (select cd_tipo_pagamento from tipo_pagamento where cd_tipo_servico_bancario = 8) and 
				       dt_vencimento>= convert(datetime,substring(@linha_aux,129,2)+'/01/'+substring(@linha_aux,131,4)) and 
				       dt_vencimento< dateadd(month,1,convert(datetime,substring(@linha_aux,129,2)+'/01/'+substring(@linha_aux,131,4)))
				       
  			      Open Dados_Cursor_RB
			     Fetch next from Dados_Cursor_RB Into @cd_parcela, @cd_tipo_recebimento, @vl_parcela , @nosso_numero,@dt_vencimento
			     While (@@fetch_status  <> -1)
				 Begin -- 3.1            
	              
				   if @qtde_parcelas=0 
					  set @nn = @nn + convert(varchar(10),@cd_parcela)
				   else
					  set @nn = @nn + ','+ convert(varchar(10),@cd_parcela)
	              
				   set @qtde_parcelas = @qtde_parcelas + 1 
	          
				   Fetch next from Dados_Cursor_RB Into @cd_parcela, @cd_tipo_recebimento, @vl_parcela , @nosso_numero,@dt_vencimento
				End -- 3.1
				Close Dados_Cursor_RB
				Deallocate Dados_Cursor_RB

				select @cd_ocorrencia = (case 
					 when @qtde_parcelas = 0 then 97 -- NOSSO NUMERO NÃO ENCONTRADO
					 when @qtde_parcelas = 1 and @cd_tipo_recebimento=0 and Abs(convert(int,substring(@linha_aux,45,10))-convert(int,(@vl_parcela*100)))>100 then 104 -- VALOR DA PARCELA INCORRETO
					 when @qtde_parcelas = 1 and @cd_tipo_recebimento=1 then 102 -- NOSSO NUMERO EXCLUIDO
					 when @qtde_parcelas = 1 and @cd_tipo_recebimento=2 then 103 -- NOSSO NUMERO ACORDADO
					 when @qtde_parcelas = 1 and @cd_tipo_recebimento>2 then 101 -- NOSSO NUMERO BAIXADO ANTERIORMENTE
					 when @qtde_parcelas > 1 then 100 
					 Else 0
				  End)
             
				if @cd_ocorrencia=104 
				begin
				   print '-----'
				   print @nn
				   print convert(money,substring(@linha_aux,45,10))-(@vl_parcela*100)
				   print substring(@linha_aux,45,10)
				   print (@vl_parcela*100)
				   print '-----'
				end    
               
				if @cd_ocorrencia = 0 
  				   Set @valor = @valor + convert(money,substring(@linha,45,10))/100
				else
				   Set @erro = 1
   
                --- Esperar o primeiro arquivo para proceder as baixas
                -- select @cd_ocorrencia = 97 ,  @erro = 1
                -- Procurar a parcela. Definir a Ocorrencia e Somar valor
				--if @cd_ocorrencia = 0 
				-- Set @valor = @valor + convert(money,substring(@@linha_aux,45,10))/100

             End    
             else
             Begin
                set @cd_ocorrencia = 130+convert(int,SUBSTRING(@linha_aux,27,2))
                Set @dt_vencimento = convert(datetime,substring(@linha_aux,129,2)+'/'+substring(@linha_aux,127,2)+'/'+substring(@linha_aux,131,4))		
                Set @dt_pago = @dt_vencimento
                Set @nn = 'Mat:'+convert(varchar(15),CONVERT(bigint,substring(@linha_aux,2,25))) + ' - Assoc:'+substring(@linha_aux,360,10)
                
                select @qtde_parcelas = count(0) 
                  from ASSOCIADOS 
                 where nu_matricula= convert(varchar(15),CONVERT(bigint,substring(@linha_aux,2,25))) and 
                       cd_associado = substring(@linha_aux,360,10) and 
                       cd_empresa in (select cd_empresa from EMPRESA as e, tipo_pagamento as t where e.cd_tipo_pagamento = t.cd_tipo_pagamento and t.cd_tipo_servico_bancario = @cd_tipo_servico_bancario)

                 if @qtde_parcelas=0 -- ASsociado nao localizado 
                    select @cd_ocorrencia = 51 ,  @erro = 1
                    
                 set @qtde_parcelas = 0 
                         
             End
           
             set @qtde = @qtde + 1 
                        
             print @cd_ocorrencia
                             
             insert Lote_Processos_Bancos_Retorno_Mensalidades 
               (cd_sequencial_retorno,  nr_linha , cd_parcela, cd_ocorrencia, dt_venc, dt_pago, vl_parcela, 
                vl_multa, vl_desconto, vl_tarifa, vl_pago, nn, nm_linha)
              values (@sequencial_retorno, @qtde , 
                case when @qtde_parcelas <> 1 then Null Else @cd_parcela End,
                @cd_ocorrencia , 
                @dt_vencimento  ,  -- venc               
                @dt_pago , -- pgto
                convert(money,substring(@linha_aux,45,10))/100, -- parcela
                0, -- multa
                0, -- desconto
                0, -- tarifa
                convert(money,substring(@linha_aux,45,10))/100, -- pago
                @nn , 
                @linha_aux)    
                if @@ROWCOUNT = 0 
                begin -- 2.5.2
                   set @erro = 1  -- Não processar o arquivo
                end -- 2.5.2   
                print '---5'                
                
                --print 'Insert Mens F' 
               
          End -- 2.5


          if @cd_tipo_servico_bancario=21 and -- TITULO DE COBRANÇA
             substring(@linha,8,1) = '3' and -- Linha de detalhe
             substring(@linha,14,1) = 'T' 
          Begin -- 2.2 
             -- T : NOSSO_NUMERO = 39,19 : VALOR_TARIFA = 199,1
             print 'entrou servico T'
             set @linha_aux = @linha
             if SUBSTRING(@linha_aux,38,20) <> ''
                Set @despreza = 0 
             else   
                Set @despreza = 1
                
          End -- 2.2 
             
          if @cd_tipo_servico_bancario=21 and -- TITULO DE COBRANÇA
             substring(@linha,8,1) = '3' and -- Linha de detalhe
             substring(@linha,14,1) = 'U' and 
             @despreza = 0 
          Begin -- 2.3             
               print 'entrou servico U'
             -- Localizar Codigo Parcela -- Nosso Numero Sistema Antigo
             Select @nosso_numero = '', @nn='' , @cd_parcela = null , @cd_tipo_recebimento = null , @vl_parcela = null , @qtde_parcelas = 0 ,
                    @qt_agrupada = null, @qt_aberta=0,@qt_excluida=0,@qt_acordo=0,@qt_baixada=0
             
			  Declare Dados_Cursor_RB  cursor for  
			   select cd_parcela, cd_tipo_recebimento, vl_parcela+isnull(vl_acrescimo,0)-isnull(vl_desconto,0)-isnull(vl_imposto,0) +ISNULL(vl_taxa,0)+isnull(vl_jurosmultareferencia,0)+isnull(vl_acrescimoavulso,0)-isnull(vl_descontoavulso,0) , Nosso_numero,

				   (select count(cd_parcela) from MENSALIDADES where CD_TIPO_RECEBIMENTO = 0 and CD_PARCELA in (
						  select cd_parcela from MensalidadesAgrupadas where cd_parcelaMae in (select cd_parcela from MENSALIDADES 
						   where (NOSSO_NUMERO=rtrim(ltrim(SUBSTRING(@linha_aux,38,20))) or 
				                  NOSSO_NUMERO=SUBSTRING(@linha_aux,case when SUBSTRING(@linha_aux,38,6) = @convenio then 38 else 46 end,11)) and 
				                  dt_vencimento > dateadd(month,-11,getdate()) 
				                                                                               ) 
																												)
				   ) as abertas,
				   (select count(cd_parcela) from MENSALIDADES where CD_TIPO_RECEBIMENTO = 1 and CD_PARCELA in (
						  select cd_parcela from MensalidadesAgrupadas where cd_parcelaMae in (select cd_parcela from MENSALIDADES 
						   where (NOSSO_NUMERO=rtrim(ltrim(SUBSTRING(@linha_aux,38,20))) or 
				                  NOSSO_NUMERO=SUBSTRING(@linha_aux,case when SUBSTRING(@linha_aux,38,6) = @convenio then 38 else 46 end,11)) and 
				                  dt_vencimento > dateadd(month,-11,getdate()) 
				                                                                               ) 

																												)
				   ) as exc,
				   (select count(cd_parcela) from MENSALIDADES where CD_TIPO_RECEBIMENTO = 2 and CD_PARCELA in (
						  select cd_parcela from MensalidadesAgrupadas where cd_parcelaMae in (select cd_parcela from MENSALIDADES 
						   where (NOSSO_NUMERO=rtrim(ltrim(SUBSTRING(@linha_aux,38,20))) or 
				                  NOSSO_NUMERO=SUBSTRING(@linha_aux,case when SUBSTRING(@linha_aux,38,6) = @convenio then 38 else 46 end,11)) and 
				                  dt_vencimento > dateadd(month,-11,getdate()) 
				                                                                               ) 

																												)
				   ) as acor,
				   (select count(cd_parcela) from MENSALIDADES where CD_TIPO_RECEBIMENTO > 2 and CD_PARCELA in (
						  select cd_parcela from MensalidadesAgrupadas where cd_parcelaMae in (select cd_parcela from MENSALIDADES 
						   where (NOSSO_NUMERO=rtrim(ltrim(SUBSTRING(@linha_aux,38,20))) or 
				                  NOSSO_NUMERO=rtrim(ltrim(SUBSTRING(@linha_aux,case when SUBSTRING(@linha_aux,38,6) = @convenio then 38 else 46 end,11)))) and 
				                  dt_vencimento > dateadd(month,-11,getdate()) 
				                                                                               ) 

																												)
				   ) as baixadas  				  


				 from MENSALIDADES 
				where (NOSSO_NUMERO=rtrim(ltrim(SUBSTRING(@linha_aux,38,20))) or 
				       NOSSO_NUMERO=SUBSTRING(@linha_aux,case when SUBSTRING(@linha_aux,38,6) = @convenio then 38 else 46 end,11)) and 
				       dt_vencimento > dateadd(month,-11,getdate())
  			  Open Dados_Cursor_RB
			  Fetch next from Dados_Cursor_RB Into @cd_parcela, @cd_tipo_recebimento, @vl_parcela , @nosso_numero, @qt_aberta, @qt_excluida, @qt_acordo, @qt_baixada
			  While (@@fetch_status  <> -1)
				Begin -- 3.1            

				   if @qtde_parcelas=0 
					  set @nn = @nosso_numero
				   else
					  set @nn = @nn + ','+@nosso_numero
	              
				   set @qtde_parcelas = @qtde_parcelas + 1 
	          
				   Fetch next from Dados_Cursor_RB Into @cd_parcela, @cd_tipo_recebimento, @vl_parcela , @nosso_numero, @qt_aberta, @qt_excluida, @qt_acordo, @qt_baixada
				End -- 3.1
				Close Dados_Cursor_RB
				Deallocate Dados_Cursor_RB

            print @cd_parcela
            print @qtde_parcelas
            print 'x'+rtrim(ltrim(SUBSTRING(@linha_aux,38,20)))+'x'
            print 'x'+SUBSTRING(@linha_aux,case when SUBSTRING(@linha_aux,38,6) = @convenio then 38 else 46 end,11)+'x'
            print '-------------------------------'
                           
            set @qt_agrupada = isnull(@qt_aberta,0)+isnull(@qt_excluida,0)+isnull(@qt_acordo,0)+isnull(@qt_baixada,0)

            set @cd_ocorrencia = case when  substring(@linha,16,2) in ('06','07','08','10','17','59') then 0 else 700+CONVERT(int,substring(@linha,16,2)) end 
           
            if @cd_ocorrencia = 0 
            Begin 
				select @cd_ocorrencia = (case 
					 when @qtde_parcelas > 1 then 100 
					 
					 when @qt_agrupada>0 and @qt_aberta>0 and @qt_baixada=0 and @qt_excluida=0 and @qt_acordo=0 then 35
					 when @qt_agrupada>0 and @qt_baixada>0 then 101                 
					 when @qt_agrupada>0 and @qt_excluida>0 then 102
					 when @qt_agrupada>0 and @qt_acordo>0 then 103
					 when @qt_agrupada>0 and @qt_aberta=0 then 105  				
				
					 when @qtde_parcelas = 0 then 97 -- NOSSO NUMERO NÃO ENCONTRADO
					 when @qtde_parcelas = 1 and @cd_tipo_recebimento=0 and Abs(convert(int,substring(@linha_aux,82,15))-convert(int,(@vl_parcela*100)))>100 then 104 -- VALOR DA PARCELA INCORRETO
					 when @qtde_parcelas = 1 and @cd_tipo_recebimento=1 then 102 -- NOSSO NUMERO EXCLUIDO
					 when @qtde_parcelas = 1 and @cd_tipo_recebimento=2 then 103 -- NOSSO NUMERO ACORDADO
					 when @qtde_parcelas = 1 and @cd_tipo_recebimento>2 then 101 -- NOSSO NUMERO BAIXADO ANTERIORMENTE

					 Else 0
				  End)
				  
				  if @cd_ocorrencia not in (0,35) 
                     set @erro = 1
                  
                  Set @valor = @valor + convert(money,substring(@linha,78,15))/100
                     
            End 

            set @qtde = @qtde + 1 

             insert Lote_Processos_Bancos_Retorno_Mensalidades 
               (cd_sequencial_retorno,  nr_linha , cd_parcela, cd_ocorrencia, dt_venc, dt_pago, vl_parcela, 
                vl_multa, vl_desconto, vl_tarifa, vl_pago, nn, nm_linha)
              values (@sequencial_retorno, @qtde , 
                case when @qtde_parcelas <> 1 then Null Else @cd_parcela End,
                @cd_ocorrencia , 
                case when substring(@linha_aux,76,2)+'/'+substring(@linha_aux,74,2)+'/'+substring(@linha_aux,78,4)='00/00/0000' then null else substring(@linha_aux,76,2)+'/'+substring(@linha_aux,74,2)+'/'+substring(@linha_aux,78,4) End ,  -- venc               
                substring(@linha,140,2)+'/'+substring(@linha,138,2)+'/'+substring(@linha,142,4) , -- pgto
                convert(money,substring(@linha_aux,82,15))/100, -- parcela
                convert(money,substring(@linha,18,15))/100, -- multa
                convert(money,substring(@linha,33,15))/100, -- desconto
                convert(money,substring(@linha_aux ,199,15))/100, -- tarifa
                convert(money,substring(@linha,78,15))/100, -- pago
                Case when @cd_ocorrencia=97 then SUBSTRING(@linha_aux,38,20) + ',' + SUBSTRING(@linha_aux,case when SUBSTRING(@linha_aux,38,6) = @convenio then 38 else 46 end,11)  Else @nn End , 
                @linha_aux)    
                if @@ROWCOUNT = 0 
                begin -- 2.3.2
                
                   print @sequencial_retorno
                   print @qtde
                   print @qtde_parcelas
                   print @cd_ocorrencia
                   print case when substring(@linha_aux,76,2)+'/'+substring(@linha_aux,74,2)+'/'+substring(@linha_aux,78,4)='00/00/0000' then null else substring(@linha_aux,76,2)+'/'+substring(@linha_aux,74,2)+'/'+substring(@linha_aux,78,4) End   -- venc               
					print substring(@linha,140,2)+'/'+substring(@linha,138,2)+'/'+substring(@linha,142,4)  -- pgto
					print convert(money,substring(@linha_aux,82,15))/100 -- parcela
					print convert(money,substring(@linha,18,15))/100 -- multa
					print convert(money,substring(@linha,33,15))/100 -- desconto
					print convert(money,substring(@linha_aux ,199,15))/100 -- tarifa
					print convert(money,substring(@linha,78,15))/100 -- pago
					print Case when @cd_ocorrencia=97 then SUBSTRING(@linha_aux,38,20) + ',' + SUBSTRING(@linha_aux,case when SUBSTRING(@linha_aux,38,6) = @convenio then 38 else 46 end,11)  Else @nn End 
					print @linha_aux
                
                   set @erro = 1  -- Não processar o arquivo
                end -- 2.3.2   
                
                --print 'Insert Mens F' 
               
          End -- 2.3

          if (@cd_tipo_servico_bancario=6 and -- Debito Automatico
             substring(@linha,1,1) = 'Z')  -- Trailler
           or  
             (@cd_tipo_servico_bancario in (41) and -- TITULO DE COBRANÇA
             substring(@linha,1,1) = '9')  -- Trailler
           or  
             (@cd_tipo_servico_bancario=1 and -- TITULO DE COBRANÇA
             substring(@linha,8,1) = '9')  -- Trailler
           or  
             (@cd_tipo_servico_bancario=21 and -- TITULO DE COBRANÇA
             substring(@linha,8,1) = '9')  -- Trailler
           or   
             (@cd_tipo_servico_bancario=8 and -- COELCE
             substring(@linha,1,1) = 'Z')  -- Trailler
           or   
             (@cd_tipo_servico_bancario=17 and -- Hiper
             substring(@linha,1,1) = '9')  -- Trailler
           or   
             (@cd_tipo_servico_bancario in (16,19) and -- Hiper
             substring(@linha,1,2) = '99')  -- Trailler
                        
          Begin -- 2.3
            if @erro = 0 -- Gravar Resumo do Lote
            begin -- 2.3.1
             update Lote_Processos_Bancos_Retorno 
                set obs = 'Erro na BAIXA do arquivo.'
              where cd_sequencial_retorno = @sequencial_retorno 
            end -- 2.3.1  
            
            if @cd_tipo_servico_bancario in (16,19)
            begin
				update Lote_Processos_Bancos_Retorno_Mensalidades 
				   set dt_credito = case when substring(@linha,55,8) in ('00000000','        ') then null else substring(@linha,57,2)+'/'+substring(@linha,55,2)+'/'+substring(@linha,59,4) end
				 where cd_sequencial_retorno = @sequencial_retorno
            end 
          End -- 2.3
          
		  --- Proximo registro
		  Fetch next from Dados_Cursor Into  @linha

		End --Fim 2
 
      Close Dados_Cursor
      Deallocate Dados_Cursor
      
            -- Verificar 2x o mesma parcela no arquivo
      if @erro = 0 
      Begin -- 3      
         if (
				select top 1 count(0) 
				 from (
				  select 1 as c1,cd_parcela
					from Lote_Processos_Bancos_Retorno_Mensalidades 
				   where cd_sequencial_retorno = @sequencial_retorno and cd_ocorrencia in (0,31)
				union all
				  select 2,m.cd_parcela
					from Lote_Processos_Bancos_Retorno_Mensalidades as l inner join MensalidadesAgrupadas as m on l.cd_parcela = m.cd_parcelaMae
				   where cd_sequencial_retorno = @sequencial_retorno and cd_ocorrencia in (35)
				) as x 
				   group by cd_parcela
				  having COUNT(0)>1
			 ) >0 -- Existe + de 1x a parcela
		  Begin
		     set @erro = 1  -- Não processar o arquivo
             update Lote_Processos_Bancos_Retorno 
                set obs = 'Erro Parcela paga em duplicidade no arquivo.'
              where cd_sequencial_retorno = @sequencial_retorno 
              
             update Lote_Processos_Bancos_Retorno_Mensalidades
                set cd_ocorrencia = 107
			  where cd_sequencial_retorno = @sequencial_retorno 
			   and cd_ocorrencia in (0,31,35)
			   and (
					 cd_parcela in (			
						   select cd_parcela
							 from (
							  select 1 as c1,cd_parcela
								from Lote_Processos_Bancos_Retorno_Mensalidades 
							   where cd_sequencial_retorno = @sequencial_retorno and cd_ocorrencia in (0,31)
							union all
							  select 2,m.cd_parcela
								from Lote_Processos_Bancos_Retorno_Mensalidades as l inner join MensalidadesAgrupadas as m on l.cd_parcela = m.cd_parcelaMae
							   where cd_sequencial_retorno = @sequencial_retorno and cd_ocorrencia in (35)
							) as x 
							   group by cd_parcela
							  having COUNT(0)>1
							  )
						or 

					  cd_parcela in (			
               
						   select cd_parcelaMae
							 from MensalidadesAgrupadas as MA inner join (
						   select cd_parcela
							 from (
							  select 1 as c1,cd_parcela
								from Lote_Processos_Bancos_Retorno_Mensalidades 
							   where cd_sequencial_retorno = @sequencial_retorno and cd_ocorrencia in (0,31)
							union all
							  select 2,m.cd_parcela
								from Lote_Processos_Bancos_Retorno_Mensalidades as l inner join MensalidadesAgrupadas as m on l.cd_parcela = m.cd_parcelaMae
							   where cd_sequencial_retorno = @sequencial_retorno and cd_ocorrencia in (35)
							) as x 
							   group by cd_parcela
							  having COUNT(0)>1
							  ) as y on ma.cd_parcela = y.cd_parcela
							  )

					)	
		  
		  End 	 
      
       End 
      -- Fim Verificacao 


	 print '--------------'
     print @erro
     print '--------------'
 
     if @cd_tipo_servico_bancario in (41) and @erro = 0 
     begin 
     
       if (select obs from Lote_Processos_Bancos_Retorno where cd_sequencial_retorno = @sequencial_retorno) <> 'Erro na BAIXA do arquivo.'
       begin 
          update Lote_Processos_Bancos_Retorno set obs = 'Trailler do arquivo nao finalizado.' where cd_sequencial_retorno = @sequencial_retorno 
          Set @erro = 99 
        End
        
     end 
     
  --   -- Critica Arquivo Processado
      if @erro = 0 
      Begin -- 3
			declare @rowcount_ int 
			declare @errorcount_ int 
			declare @errorMSG_ varchar(max) 
			
          Begin Transaction
		  Declare Dados_Cursor_RB  cursor for  
		   select cd_parcela, dt_pago, vl_parcela , vl_multa, vl_desconto, vl_pago , vl_tarifa
             from Lote_Processos_Bancos_Retorno_Mensalidades 
            where cd_sequencial_retorno=@sequencial_retorno and cd_ocorrencia in (0,31)
  		  Open Dados_Cursor_RB
		  Fetch next from Dados_Cursor_RB Into @cd_parcela, @dt_pago, @vl_parcela , @vl_multa, @vl_desconto, @vl_pago , @vl_tarifa
		  While (@@fetch_status  <> -1)
			Begin -- 3.1
			    set @errorcount_ = null
				set @rowcount_ = null 
				set @errorMSG_ = null
			   print convert(varchar(10),@cd_parcela)
			   begin try 
				   update MENSALIDADES 
					  set DT_PAGAMENTO=@dt_pago,
						  CD_TIPO_RECEBIMENTO = case when @cd_tipo_servico_bancario=16 then CD_TIPO_PAGAMENTO else @cd_tipo_pagamento end,
						  VL_PAGO = @vl_pago,
						  DT_BAIXA=GETDATE(),
						  CD_USUARIO_BAIXA=@cd_funcionario,
						  DT_ALTERACAO=GETDATE(),
						  CD_USUARIO_ALTERACAO=@cd_funcionario,
						  VL_SERVICO=@vl_tarifa ,
						  vl_multa = case when @vl_pago > (vl_parcela+isnull(vl_acrescimo,0)-isnull(vl_desconto,0)-case when @cd_tipo_servico_bancario=15 then 0 else isnull(vl_imposto,0) end +ISNULL(vl_taxa,0)+ISNULL(vl_acrescimoavulso,0)) then @vl_pago - (vl_parcela+isnull(vl_acrescimo,0)-isnull(vl_desconto,0)-case when @cd_tipo_servico_bancario=15 then 0 else isnull(vl_imposto,0) end  +ISNULL(vl_taxa,0)+ISNULL(vl_acrescimoavulso,0)) else 0 end,
						  vl_desconto_recebimento = case when @vl_pago < (vl_parcela+isnull(vl_acrescimo,0)-case when @cd_tipo_servico_bancario=15 then 0 else isnull(vl_imposto,0) end -isnull(vl_imposto,0) +ISNULL(vl_taxa,0)+ISNULL(vl_acrescimoavulso,0)) then (vl_parcela+isnull(vl_acrescimo,0)-isnull(vl_desconto,0)-case when @cd_tipo_servico_bancario=15 then 0 else isnull(vl_imposto,0) end +ISNULL(vl_taxa,0)+ISNULL(vl_acrescimoavulso,0)) - @vl_pago else 0 end
					where cd_parcela = @cd_parcela and CD_TIPO_RECEBIMENTO=0
					set @rowcount_ = @@ROWCOUNT
				end try
				begin catch
					print '--- erro - 2.0 ' 
					set @errorcount_ = @@ERROR
					set @errorMSG_ = ERROR_MESSAGE()
			       set @erro=1
			         IF @@TRANCOUNT > 0  
						ROLLBACK TRANSACTION;  
					update Lote_Processos_Bancos_Retorno 
                      set obs = replace(left('Erro na BAIXA da Parcela (' + CONVERT(varchar(20),@cd_parcela) +').' + @errorMSG_,200),'''','')
                    where cd_sequencial_retorno = @sequencial_retorno 
                    break 
				end catch
					 
			    if isnull(@errorcount_,@@ERROR) <> 0 or @rowcount_ = 0 
			    begin -- 3.1.1
			       print '--- erro - 2 ' 
			       set @erro=1
			       rollback 
			       
			       update Lote_Processos_Bancos_Retorno 
                      set obs = replace(left('Erro na BAIXA da Parcela (' + CONVERT(varchar(20),@cd_parcela) +').' + @errorMSG_,200),'''','')
                    where cd_sequencial_retorno = @sequencial_retorno 
              
			       break        
			    end -- 3.1.1

			    --if @@ROWCOUNT = 0 
			    --begin -- 3.1.1
			    --   print '--- erro' 
			    --   set @erro=1
			    --   rollback 
			       
			    --   update Lote_Processos_Bancos_Retorno 
       --               set obs = 'Erro na BAIXA, parcela ja baixado por outro documento (' + CONVERT(varchar(20),@cd_parcela) +').'
       --             where cd_sequencial_retorno = @sequencial_retorno 
              
			    --   break        
			    --end -- 3.1.1	
               Fetch next from Dados_Cursor_RB Into @cd_parcela, @dt_pago, @vl_parcela , @vl_multa, @vl_desconto, @vl_pago , @vl_tarifa
            End -- 3.1  
            Close Dados_Cursor_RB
            Deallocate Dados_Cursor_RB
            
		if @erro = 0
		begin
		Declare @qtde_l int
		Declare @qtde_c int
		Declare @vl_acu money
		Declare @vl_pg money
		        
          Set @parcelamae_ant = 0 
          
		  Declare Dados_Cursor_RB  cursor for  -- Parcela Agrupada
			select m.cd_parcela, l.dt_pago, 
				   m.vl_parcela+ISNULL(m.vl_acrescimo,0)-ISNULL(m.vl_desconto,0)-ISNULL(m.vl_imposto,0)+ISNULL(m.vl_taxa,0)+ISNULL(vl_acrescimoavulso,0) as vl_parcela, 
				   round((l.vl_pago - x.vl)*(m.vl_parcela+ISNULL(m.vl_acrescimo,0)-ISNULL(m.vl_desconto,0)-ISNULL(m.vl_imposto,0)+ISNULL(m.vl_taxa,0)+ISNULL(vl_acrescimoavulso,0)/x.vl)/100,2) as vl_acerto , 
				   0 as desconto , 
				    convert(float,convert(int,((m.vl_parcela+ISNULL(m.vl_acrescimo,0)-ISNULL(m.vl_desconto,0)-ISNULL(m.vl_imposto,0)+ISNULL(m.vl_taxa,0)+ISNULL(vl_acrescimoavulso,0)) * l.vl_pago)*100/x.vl))/100 as vl_pago, 
				   l.vl_tarifa,  a.cd_parcelaMae, l.dt_credito  , x.qtde , l.vl_pago
			 from Lote_Processos_Bancos_Retorno_Mensalidades as l , MensalidadesAgrupadas as a, MENSALIDADES as m, 

				   (select a1.cd_parcelaMae, SUM(m1.vl_parcela+isnull(m1.vl_acrescimo,0)-isnull(m1.VL_Desconto,0)-isnull(m1.vl_imposto,0)+ISNULL(m1.vl_taxa,0)+ISNULL(vl_acrescimoavulso,0)) as vl, COUNT(0) as qtde 
					  from Lote_Processos_Bancos_Retorno_Mensalidades as l1 , MensalidadesAgrupadas as a1, MENSALIDADES as m1
					 where cd_sequencial_retorno=@sequencial_retorno and cd_ocorrencia in (35) 
					   and l1.cd_parcela = a1.cd_parcelaMae 
					   and a1.cd_parcela = m1.CD_PARCELA 
					 group by a1.cd_parcelaMae
					) as x
					
			where cd_sequencial_retorno=@sequencial_retorno and cd_ocorrencia in (35) and 
				  l.cd_parcela = a.cd_parcelaMae and a.cd_parcela = m.CD_PARCELA and a.cd_parcelaMae =x.cd_parcelaMae 

  		  Open Dados_Cursor_RB
		  Fetch next from Dados_Cursor_RB Into @cd_parcela, @dt_pago, @vl_parcela , @vl_multa, @vl_desconto, @vl_pago , @vl_tarifa,@parcelamae, @dt_prevista_credito , @qtde_c, @vl_pg
		  While (@@fetch_status  <> -1)
		  Begin -- 3.1
			   
   print convert(varchar(10),@cd_parcela)
			   
			   Set @qtde_l = @qtde_l + 1 
			   if @parcelamae_ant <> @parcelamae -- Zerar os campos 
			   begin
			      --Set @vl_pago = @vl_pago + isnull(@vl_multa,0)
			      Set @qtde_l = 1 
                  Set @vl_acu = 0
			   End
			   
			   Set @vl_acu = @vl_acu + @vl_pago 
			   if @qtde_l = @qtde_c and @vl_acu <> @vl_pg -- @vl_pg = valor pago no titulo agrupado
			   begin 
			      Set @vl_pago = @vl_pago + (@vl_pg - @vl_acu)
			   End 

			   
			   update MENSALIDADES 
			      set DT_PAGAMENTO=@dt_pago,
			          CD_TIPO_RECEBIMENTO = case when @cd_tipo_servico_bancario=16 then CD_TIPO_PAGAMENTO else @cd_tipo_pagamento end,
			          VL_PAGO = @vl_pago,
			          DT_BAIXA=GETDATE(),
			          CD_USUARIO_BAIXA=@cd_funcionario,
			          DT_ALTERACAO=GETDATE(),
			          CD_USUARIO_ALTERACAO=@cd_funcionario,
			          VL_SERVICO= case when @parcelamae_ant = @parcelamae then 0 else @vl_tarifa end ,
			           vl_multa = case when @vl_pago > @vl_parcela then @vl_pago - @vl_parcela else 0 end,
			          vl_desconto_recebimento = case when @vl_pago < @vl_parcela then @vl_parcela - @vl_pago else 0 end
			        --  dt_credito = @dt_prevista_credito
			    where cd_parcela = @cd_parcela and CD_TIPO_RECEBIMENTO=0
			    if @@ERROR <> 0 or @@ROWCOUNT = 0 
			    begin -- 3.1.1
			       print '--- erro - 3 ' 
			       set @erro=1
			       rollback 
			       
			       update Lote_Processos_Bancos_Retorno 
                      set obs = 'Erro na BAIXA da Parcela (' + CONVERT(varchar(20),@cd_parcela) +').'
                    where cd_sequencial_retorno = @sequencial_retorno 
              
			       break        
			    end -- 3.1.1

			    --if @@ROWCOUNT = 0 
			    --begin -- 3.1.1
			    --   print '--- erro' 
			    --   set @erro=1
			    --   rollback 
			       
			    --   update Lote_Processos_Bancos_Retorno 
       --               set obs = 'Erro na BAIXA, parcela ja baixado por outro documento (' + CONVERT(varchar(20),@cd_parcela) +').'
       --             where cd_sequencial_retorno = @sequencial_retorno 
              
			    --   break        
			    --end -- 3.1.1	
			    
			    Set @parcelamae_ant = @parcelamae
			    
               Fetch next from Dados_Cursor_RB Into @cd_parcela, @dt_pago, @vl_parcela , @vl_multa, @vl_desconto, @vl_pago , @vl_tarifa,@parcelamae,@dt_prevista_credito , @qtde_c, @vl_pg
          End -- 3.1  
          Close Dados_Cursor_RB
          Deallocate Dados_Cursor_RB -- Fim Parcela Agrupada                  
		end
		
		if @erro = 0
			begin
			  --- Limpar informacoes de Titulos nao debitados para envio ao banco
			  declare @situacao int 
			  Declare @FL_GeraCrm int 
			  Declare @fl_limpaEnvio int 
			  Declare @fl_BaixaRetorno int
			  declare @WL_cd_empresa int 
	          
			  Declare Dados_Cursor_RB  cursor for  
			   select m.cd_parcela, m.dt_venc , upper(d.nm_ocorrencia), d.cd_situacao , d.FL_GeraCrm, d.fl_limpaEnvio, d.fl_BaixaRetorno
				 from Lote_Processos_Bancos_Retorno_Mensalidades as m , DEB_AUTOMATICO_CR as d
				where m.cd_sequencial_retorno=@sequencial_retorno and 
					  m.cd_ocorrencia = d.cd_ocorrencia and 
					 -- m.cd_ocorrencia > 0 and 
					  (isnull(d.FL_GeraCrm,0)+isnull(d.fl_limpaEnvio,0)+isnull(d.fl_BaixaRetorno,0))>0
	                  
  			  Open Dados_Cursor_RB
			  Fetch next from Dados_Cursor_RB Into @cd_parcela, @dt_vencimento, @WL_dsOcorrencia , @situacao, @FL_GeraCrm,@fl_limpaEnvio,@fl_BaixaRetorno
			  While (@@fetch_status  <> -1)
				Begin -- 3.1
				   print @cd_parcela
				   
				   if isnull(@fl_limpaEnvio,0)>0 
				   begin 
					   update MENSALIDADES 
						  set cd_lote_processo_banco = null, 
							  executarTrigger=0
						where cd_parcela = @cd_parcela 
						if @@ERROR <> 0 
						begin -- 3.1.1
						   print '--- erro' 
						   set @erro=9
						   rollback 
					       
						   update Lote_Processos_Bancos_Retorno 
							  set obs = 'Erro na Liberação da Parcela (' + CONVERT(varchar(20),@cd_parcela) +').'
							where cd_sequencial_retorno = @sequencial_retorno 
		              
						   break        
						end -- 3.1.1
				   End

				   if isnull(@fl_BaixaRetorno,0)>0 
				   begin 
					   update MENSALIDADES 
						  set cd_lote_processo_banco_baixa = @sequencial_retorno, 
							  executarTrigger=0
						where cd_parcela = @cd_parcela 
						if @@ERROR <> 0 
						begin -- 3.1.1
						   print '--- erro' 
						   set @erro=9
						   rollback 
					       
						   update Lote_Processos_Bancos_Retorno 
							  set obs = 'Erro no registro de Baixa da Parcela (' + CONVERT(varchar(20),@cd_parcela) +').'
							where cd_sequencial_retorno = @sequencial_retorno 
		              
						   break        
						end -- 3.1.1
				   End			   
				   
				   if isnull(@FL_GeraCrm,0)>0
				   begin
						--***********************			    
						--****** Gerar CRM ******
						--***********************
						set  @WL_cd_dependente = 0	
						Set  @WL_cd_empresa = 0 
						set	 @WL_data = convert(varchar(20),getdate(), 112)
						set	 @WL_hora = replace(convert(varchar(12),getdate(), 114), ':','')
						set	 @WL_protocolo = replace(convert(varchar(12),getdate(), 12), ':','') + replace(convert(varchar(8),getdate(), 114), ':','') + @WL_UsuarioSYS 
						set	 @WL_chave = convert(varchar(20),getdate(), 112)+ replace(convert(varchar(12),getdate(), 114), ':','')+ @WL_UsuarioSYS + replace(rand(),'.','')--convert(varchar(10),rand())
						Set  @WL_Sit = 0 
	                    
						---	Buscar Dependente
						select	@WL_cd_dependente = d.cd_sequencial , @WL_SIT = isnull(sh.fl_envia_cobranca,1)
						from mensalidades m, associados a, dependentes d, historico as h , situacao_historico as sh 
						where m.CD_ASSOCIADO_empresa = a.cd_associado
						  and a.cd_associado = d.cd_associado 
 						  and d.CD_GRAU_PARENTESCO = 1
						  and m.cd_parcela = @cd_parcela
						  and m.TP_ASSOCIADO_EMPRESA = 1 
						  and d.cd_sequencial_historico = h.cd_sequencial 
						  and h.cd_situacao = sh.cd_situacao_historico 
	                   
						if @WL_cd_dependente=0
						begin 
                    		select @WL_cd_empresa = m.CD_ASSOCIADO_empresa 
							  from mensalidades m
							 where m.cd_parcela = @cd_parcela
							   and m.TP_ASSOCIADO_EMPRESA = 2 
						End

						---BUscar chaId
						select @WL_chaId = max(chaId) from CRMChamado
						  print 'ChaID = ' + convert(varchar(10),@WL_chaId)
						  
						  --SELECT @WL_dsOcorrencia = nm_ocorrencia
						  --FROM DEB_AUTOMATICO_CR   
						  --where   cd_ocorrencia = @cd_ocorrencia
								print 'Ocorrencia = ' + convert(varchar(10),@WL_dsOcorrencia)
								print 'linha = ' + convert(varchar(10),@linha)
		  
						if @WL_cd_dependente != 0 or @WL_cd_empresa !=0 
							Begin
							   ---Insert Chamado
								INSERT INTO CRMChamado
								   ( tsoId, chaSolicitante, mdeId, chaDtCadastro, chaRespostaEmail
								   , chaRespostaSMS, chaChave, TipoUsuario, Usuario, UsuarioResponsavel
								   , sitId, chaProtocolo, chaDtFechamento, tinId
								   , chaDtPrevisaoSolucao, chaEmailResposta, chaTelefoneResposta, iadId)
								VALUES
								   ( case when @WL_cd_dependente!= 0 then 2 else 3 end, 
									 case when @WL_cd_dependente!= 0 then @WL_cd_dependente else @WL_cd_empresa end, 
									 @FL_GeraCrm
								   , getdate(), 0, 0, @WL_chave
								   , 3, @WL_UsuarioSYS, @WL_UsuarioSYS
								   , 3, @WL_protocolo, getdate(), 2
								   , getdate(), NULL, NULL, NULL)

							select @WL_chaId = max(chaId) from CRMChamado
						 ---LOG Insert
							   INSERT INTO  CRMChamadoLog
								   ( chaId, cloDtCadastro, tloId
								   , TipoUsuario, Usuario,UsuarioNovoResponsavel)
							   VALUES
								   ( @WL_chaId, getdate(), 1
								   , 3, @WL_UsuarioSYS, @WL_UsuarioSYS)

						 ---LOG Fechamento, se observação 
							 INSERT INTO  CRMChamadoLog
								   ( chaId, cloDtCadastro, tloId
								   , TipoUsuario, Usuario)
							 VALUES
								   ( @WL_chaId, getdate(), 5
								   , 3, @WL_UsuarioSYS)				             
					                  
						---Ocorrencia
						set @WL_dsOcorrencia = 'CONFORME ARQUIVO DE RETORNO ' +  convert(varchar(50),@arquivo) + ' PROCESSADO EM ' +  convert(varchar(10),GETDATE(),103) + ', PARCELA DE VENC. ' + convert(varchar(10),@dt_Vencimento, 103) + ', O DEBITO NAO FOI EFETUADO: ' + convert(varchar(50),@WL_dsOcorrencia)  + '.'
						INSERT INTO  CRMChamadoOcorrencia 
								   ( chaId, cocDescricao, cocDtCadastro 
								   , TipoUsuario, Usuario )
							 VALUES
								   (@WL_chaId, @WL_dsOcorrencia ---@linha 
								   ,getdate(),1, @WL_UsuarioSYS)
							End
						else
							Begin
							   print 'Erro CRM: Dependente nao encontrado'
							End
					   			   
						--*******************
						--***** FIM CRM *****
						--*******************
					End
				    
					-- Modificar o Status
					if @situacao is not null and @wl_sit = 1 
					begin 
					  insert HISTORICO (CD_SEQUENCIAL_dep, CD_SITUACAO,DT_SITUACAO)
					  values (@WL_cd_dependente,@situacao,GETDATE())
					End
					-- FIm Modificar o Status
				    
				   Fetch next from Dados_Cursor_RB Into @cd_parcela, @dt_vencimento, @WL_dsOcorrencia , @situacao, @FL_GeraCrm,@fl_limpaEnvio,@fl_BaixaRetorno
				End -- 3.1  
				Close Dados_Cursor_RB
				Deallocate Dados_Cursor_RB

			  -- Enviar e-mail p entreada confirmada no Banco 
			  Declare @email varchar(100)
			  declare @tipo smallint 
			  Declare @pk int 
	          
			  Declare Dados_Cursor_RB  cursor for  
			   select distinct 2, m.cd_associado_empresa , 
						(select top 1 isnull(tustelefone,'')  
						  from tb_contato as t  
						 where t.ttesequencial=50 and t.cd_origeminformacao=3 and t.cd_sequencial = m.cd_associado_empresa and t.fl_ativo=1), 
						 m.cd_parcela 
				 from Lote_Processos_Bancos_Retorno_Mensalidades as l , mensalidades as m , empresa as e 
				where l.cd_parcela = m.cd_Parcela and 
					  m.CD_ASSOCIADO_empresa = e.CD_EMPRESA and 
					  isnull(e.fl_online,0)=1 and 
					  m.TP_ASSOCIADO_EMPRESA=2 and 
					  m.cd_tipo_parcela=1 and 
					  m.CD_TIPO_RECEBIMENTO=0 and 
					  l.cd_sequencial_retorno=@sequencial_retorno and 
					  (exists (select 1 from deb_automatico_cr dac where dac.cd_ocorrencia = l.cd_ocorrencia and dac.fl_entradaconfirmada = 1) or l.cd_ocorrencia in (702,802))
			   union
			   select distinct 1, m.cd_associado_empresa , 
						 (select top 1 tFone  
							from (        
						   select isnull(tustelefone,'') as tFone   
						  from tb_contato as t  
						 where t.ttesequencial=50 and t.cd_origeminformacao=1 and t.cd_sequencial = m.cd_associado_empresa and t.fl_ativo=1  
									  union  
						select isnull(tustelefone,'') as tfone  
						  from tb_contato as t  
						 where t.ttesequencial=50 and t.cd_origeminformacao=5 and t.fl_ativo=1   
						   and t.cd_sequencial in (select cd_sequencial from dependentes where cd_Associado = m.cd_associado_empresa)  
							) as x        
						), m.cd_parcela
				 from Lote_Processos_Bancos_Retorno_Mensalidades as l , mensalidades as m , ASSOCIADOS as a , empresa as e 
				where l.cd_parcela = m.cd_Parcela and 
					  m.CD_ASSOCIADO_empresa = a.cd_associado and
					  a.cd_empresa = e.CD_EMPRESA and 
					  isnull(e.fl_online,0)=1 and 
					  m.TP_ASSOCIADO_EMPRESA=1 and 
					  m.cd_tipo_parcela=1 and 
					  m.CD_TIPO_RECEBIMENTO=0 and 
					  l.cd_sequencial_retorno=@sequencial_retorno  and 
					  (exists (select 1 from deb_automatico_cr dac where dac.cd_ocorrencia = l.cd_ocorrencia and dac.fl_entradaconfirmada = 1) or l.cd_ocorrencia in (702,802))
	                  
  			  Open Dados_Cursor_RB
			  Fetch next from Dados_Cursor_RB Into @tipo, @pk, @email, @cd_parcela 
			  While (@@fetch_status  <> -1)
				Begin -- 3.1
				   if @email is not null  
				   begin  
					 if @tipo=2 
					  exec SP_Email_Fatura @email, @pk , 0, @cd_parcela 
					 else 
					  exec SP_Email_Fatura @email, 0, @pk ,0, @cd_parcela  
				   end  
				   Fetch next from Dados_Cursor_RB Into @tipo, @pk, @email, @cd_parcela 
			  End -- 3.1  
			  Close Dados_Cursor_RB
			  Deallocate Dados_Cursor_RB            
          end

            
            if @erro = 0 
            Begin -- 3.2
               Commit    
               
               select @dt_prevista_credito = max(dt_pago) from lote_processos_bancos_retorno_mensalidades where cd_sequencial_retorno = @sequencial_retorno and dt_pago is not null 
               
               --- Gerar o lancamento financeiro no modulo financeiro
               exec SP_EnviaCreditoBanco_Financeiro @sequencial_retorno, @dt_prevista_credito, @erro
               
               --- Gerar a tarifa bancaria no financeiro
		       update Lote_Processos_Bancos_Retorno 
                  set obs = 'Arquivo baixado com sucesso.',
                    qtde = isnull( (select count(0) 
                              from Lote_Processos_Bancos_Retorno_Mensalidades 
                             where cd_sequencial_retorno=@sequencial_retorno  and cd_ocorrencia in (0,31,35) and vl_pago>0),0),
                    valor = isnull((select SUM(vl_pago)
							  from Lote_Processos_Bancos_Retorno_Mensalidades 
							 where cd_sequencial_retorno=@sequencial_retorno  and cd_ocorrencia in (0,31,35) and vl_pago>0),0)
                where cd_sequencial_retorno = @sequencial_retorno 
                             
            End -- 3.2 
      End -- 3
 
 /*
 
  -- Atualizar os NN para o Itau .. Retorno 702
      if (select nome_site from Configuracao)='Dental Center' and @cd_tipo_pagamento=28709080
      begin 
		  update mensalidades
			 set NOSSO_NUMERO = l.nn, DT_ALTERACAO=GETDATE(),CD_USUARIO_ALTERACAO=7021
			from Lote_Processos_Bancos_Retorno_Mensalidades as l 
		   where l.cd_ocorrencia=702 and l.cd_sequencial_retorno=@sequencial_retorno 
			 and l.cd_parcela = mensalidades.cd_parcela 
			 and mensalidades.cd_tipo_recebimento = 0 
			 
		   insert LOG_NN (cd_parcela,nn)
		   select cd_parcela, nn	 
		     from Lote_Processos_Bancos_Retorno_Mensalidades
		    where cd_sequencial_retorno=@sequencial_retorno and cd_ocorrencia=702
		    
      End 
      -- Retirar dia 01/julho/2014
      if @erro>0 and (select nome_site from Configuracao)='Dental Center'
      Begin
         if @cd_tipo_pagamento in (28709080,18770881,104,10484867) and 
           (select COUNT(0) 
              from Lote_Processos_Bancos_Retorno 
             where nm_arquivo in (select nm_arquivo 
                                    from Lote_Processos_Bancos_Retorno 
                                   where cd_sequencial_retorno = @sequencial_retorno))=1
         begin  
			update mensalidades
			   set mensalidades.NOSSO_NUMERO = x.nn 
			 from (
			select convert(varchar(20),convert(bigint,substring(nn,3,15))) as cd_parcela, convert(varchar(20),convert(bigint,nn)) as nn
			  from Lote_Processos_Bancos_Retorno_Mensalidades 
			 where cd_sequencial_retorno = @sequencial_retorno 
			   and cd_ocorrencia= 97
			   and convert(int,LEFT(nn,3))=100 ) as x 
			 where mensalidades.CD_PARCELA = x.cd_parcela 

			update mensalidades
			   set mensalidades.NOSSO_NUMERO = x.nn 
			 from (
			select Top 1 cd_parcela, nn from LOG_NN 
			 where nn in (
					select convert(varchar(20),convert(bigint,nn)) as nn
					  from Lote_Processos_Bancos_Retorno_Mensalidades 
					 where cd_sequencial_retorno = @sequencial_retorno 
					   and cd_ocorrencia= 97
					   and convert(int,LEFT(nn,3))<>100
			   )
			   order by cd_sequencial desc ) as x
			  where mensalidades.CD_PARCELA = x.cd_parcela   
         End 
         
      End
      
      -- Fim retirar
 
 
 */
 
 
 
      -- Movendo arquivos lidos para outro local
      Set @linha = 'move /y "' + @caminho + '\retorno\'+@arquivo+'" "' + @caminho + '\retorno_processados\'+@arquivo+'"'
      EXEC SP_Shell @linha , 0 

      -- incrementa variável de controle para passar para o próximo arquivo
      Set @min = @min + 1
      
     End -- fim 1

     -- drop da tabela temporária usada
     Drop table #tmp
   
              
End --1
