/****** Object:  Procedure [dbo].[SP_LerArquivoBancos_OdontoCob]    Committed by VersionSQL https://www.versionsql.com ******/

Create Procedure [dbo].[SP_LerArquivoBancos_OdontoCob] 
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
	Declare @faixa int = 700

	set  @WL_UsuarioSYS = 7021

   ----------------------------------
   -- Variaveis do Cursor de Baixa
   ----------------------------------
   Declare @dt_pago datetime 
   Declare @vl_parcela money , @vl_multa money , @vl_desconto money , @vl_pago money , @vl_tarifa money 
   
   Declare @qtde int
   Declare @valor money
   Declare @dt_credito date

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
		print 'odonto'
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
                set @cd_tipo_servico_bancario=1002
                
                set @convenio = rtrim(substring(@linha,55,7))
                set @nsa = convert(int,(substring(@linha,158,6)))
                
                select @cd_tipo_pagamento = cd_tipo_pagamento , -- Descobrir qual o tipo de pagamento
				       @faixa = isnull(b.faixaOcorrencia,700),
					   @cd_tipo_servico_bancario = t.cd_tipo_servico_bancario
                  from tipo_pagamento as t inner join tipo_servico_bancario as b on t.cd_tipo_servico_bancario=b.cd_tipo_servico_bancario
                 where t.cd_tipo_servico_bancario in (@cd_tipo_servico_bancario,1004) and 
                       t.convenio = @convenio and 
                       t.banco = convert(int,(substring(@linha,1,3))) --and 
                order by cd_tipo_pagamento
                                       
                --nr_cnpj = SUBSTRING(@linha,19,14) 
                if @cd_tipo_pagamento = 0 
                Begin -- 2.2.1.2
                  print 'Erro OC: Tipo de Pagamento nao localizado'
                  --- gravar erro CRM Processo 4 (Tipo de Pagamento nao localizado para convenio e banco)
                  Close Dados_Cursor
                  Deallocate Dados_Cursor
                  return
                End -- 2.2.1.2
             End -- 2.2.1                            

             print @cd_tipo_servico_bancario
             
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

         if @cd_tipo_servico_bancario in (1002,1004) and -- TITULO DE COBRANÇA
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
             
          if @cd_tipo_servico_bancario in (1002,1004) and -- TITULO DE COBRANÇA
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

                case when substring(@linha,16,2) in ('03','06','09','19','26','30') then SUBSTRING(@linha_aux,209,10) 
                     else null end,                 

                @linha_aux)    
                if @@ROWCOUNT = 0 
                begin -- 2.3.2
                   set @erro = 1  -- Não processar o arquivo
                end -- 2.3.2   
                
                --print 'Insert Mens F' 
               
          End -- 2.3

          if (@cd_tipo_servico_bancario in (1002,1004) and substring(@linha,8,1) = '9')  -- Trailler
          Begin -- 2.3
            if @erro = 0 -- Gravar Resumo do Lote
            begin -- 2.3.1
             update Lote_Processos_Bancos_Retorno 
                set obs = 'Erro na BAIXA do arquivo.'
              where cd_sequencial_retorno = @sequencial_retorno 
            end -- 2.3.1  
            
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

	  -- Verificar se tem virtual baixando virtual
	   if @erro = 0 
       Begin -- 3      

         if (select count(0)
			   from Lote_Processos_Bancos_Retorno_Mensalidades  as l inner join MensalidadesAgrupadas as m on l.cd_parcela = m.cd_parcelaMae
						inner join mensalidades as mv on m.cd_parcela = mv.CD_PARCELA
			  where cd_sequencial_retorno = @sequencial_retorno 
				and cd_ocorrencia in (35) 
				and mv.cd_tipo_parcela=101 
			 ) >0 -- Existe + de 1x a parcela
		  Begin
		     set @erro = 1 
		     
             update Lote_Processos_Bancos_Retorno_Mensalidades
                set cd_ocorrencia = 108
              where cd_sequencial_retorno = @sequencial_retorno 
                and cd_ocorrencia in (0,31,35)
                and cd_parcela in (
                                     select l.cd_parcela 
									   from Lote_Processos_Bancos_Retorno_Mensalidades  as l inner join MensalidadesAgrupadas as m on l.cd_parcela = m.cd_parcelaMae
												inner join mensalidades as mv on m.cd_parcela = mv.CD_PARCELA
									  where cd_sequencial_retorno = @sequencial_retorno 
										and cd_ocorrencia in (35) 
										and mv.cd_tipo_parcela=101
								  ) 	
		  
		  End 	
		        
       End   
      -- Fim Verificacao 


	 print '--------------'
     print @erro
     print '--------------'
 
  --   -- Critica Arquivo Processado
      if @erro = 0 
      Begin -- 3
			declare @rowcount_ int 
			declare @errorcount_ int 
			declare @errorMSG_ varchar(max) 
			
          Begin Transaction
		  Declare Dados_Cursor_RB  cursor for  
		   select cd_parcela, dt_pago, vl_parcela , vl_multa, vl_desconto, vl_pago , vl_tarifa, dt_credito 
             from Lote_Processos_Bancos_Retorno_Mensalidades 
            where cd_sequencial_retorno=@sequencial_retorno and cd_ocorrencia in (0,31)
  		  Open Dados_Cursor_RB
		  Fetch next from Dados_Cursor_RB Into @cd_parcela, @dt_pago, @vl_parcela , @vl_multa, @vl_desconto, @vl_pago , @vl_tarifa,@dt_credito
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
						  dt_credito = @dt_credito,
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

			    --   break        
			    --end -- 3.1.1	
               Fetch next from Dados_Cursor_RB Into @cd_parcela, @dt_pago, @vl_parcela , @vl_multa, @vl_desconto, @vl_pago , @vl_tarifa,@dt_credito
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
				   l.vl_tarifa,  a.cd_parcelaMae, l.dt_credito  , x.qtde , l.vl_pago, l.dt_credito
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
		  Fetch next from Dados_Cursor_RB Into @cd_parcela, @dt_pago, @vl_parcela , @vl_multa, @vl_desconto, @vl_pago , @vl_tarifa,@parcelamae, @dt_prevista_credito , @qtde_c, @vl_pg,@dt_credito
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
					  dt_credito=@dt_credito, 
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
			    
               Fetch next from Dados_Cursor_RB Into @cd_parcela, @dt_pago, @vl_parcela , @vl_multa, @vl_desconto, @vl_pago , @vl_tarifa,@parcelamae,@dt_prevista_credito , @qtde_c, @vl_pg,@dt_credito
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

			  -- Enviar e-mail p entrada confirmada no Banco 
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
					  (exists (select 1 from deb_automatico_cr dac where dac.cd_ocorrencia = l.cd_ocorrencia and dac.fl_entradaconfirmada = 1) )
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
					  (exists (select 1 from deb_automatico_cr dac where dac.cd_ocorrencia = l.cd_ocorrencia and dac.fl_entradaconfirmada = 1) )
	                  
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
 
      if @cd_tipo_servico_bancario > 0 
	  begin 
		  -- Movendo arquivos lidos para outro local
		  Set @linha = 'move /y "' + @caminho + '\retorno\'+@arquivo+'" "' + @caminho + '\retorno_processados\'+@arquivo+'"'
		  EXEC SP_Shell @linha , 0 
      End 

      -- incrementa variável de controle para passar para o próximo arquivo
      Set @min = @min + 1
      
     End -- fim 1

     -- drop da tabela temporária usada
     Drop table #tmp
   
              
End --1
