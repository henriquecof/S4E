/****** Object:  Procedure [dbo].[SP_GeraArquivoBancos]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE Procedure [dbo].[SP_GeraArquivoBancos] 
    @sequencial int, 
    @arquivo varchar(1000) output,
    @cd_funcionarioCadastro Int = 0,    
    @tipo int = 0
as
Begin -- 1
/*
    --- Observar e dar o erro na qt_diasminimo
    Declare @nm_arquivo varchar(200)  -- alterei aqui
	Declare @caminho VARCHAR(255)
	Declare @retEcho INT --variavel para verificar se o comando foi executado com exito ou ocorreu alguma falha 
    Declare @Linha varchar(8000)

    Declare @cd_tiposervico smallint 
    Declare @cd_tipopagamento smallint 
    Declare @nm_tipopagamento varchar(10) 
    Declare @cd_banco int 
    Declare @convenio varchar(10)
    Declare @convenio_dv char(1)
    Declare @cedente varchar(100)
    Declare @nm_banco varchar(100)
    Declare @nsa int 
    Declare @dt_finalizado datetime 
    Declare @nr_cnpj char(14)
    Declare @tp_ag varchar(10)
    Declare @tp_ag_dv char(1)
    Declare @cta varchar(20)
    Declare @dv_cta varchar(1)
    Declare @carteira int 
    Declare @juros int 
    Declare @multa int 
    Declare @taxa money 
    Declare @qt_diasminimo int 
    Declare @dt_ref datetime 
    Declare @nome varchar(100)
    Declare @endereco varchar(100)
    Declare @bairro varchar(100)
    Declare @cep varchar(8)
    Declare @cidade varchar(50)
    Declare @uf varchar(2)
    Declare @parc_atual int 
    Declare @parc_total int 
    Declare @val_cartao varchar(6)
    Declare @cd_seguranca int 
    Declare @cd_bandeira smallint 

    Declare @codbarras varchar(440)
    Declare @CampoLivre varchar(25)
    Declare @linhaDig1 varchar(54)  
    Declare @linhaDig2 varchar(54)  
    Declare @linhaDig3 varchar(54)  
    Declare @linhaDig4 varchar(54)  
    Declare @linhaDig5 varchar(54) 
    
    Declare @instrucao1 varchar(100) = ''
    Declare @instrucao2 varchar(100) = ''
    Declare @instrucao3 varchar(100) = ''
    Declare @instrucao4 varchar(100) = ''
    Declare @instrucao5 varchar(100) = ''
    Declare @instrucao6 varchar(100) = ''
        
    -- Variaveis do Arquivo
    Declare @cd_associado_empresa int 
    Declare @cd_parcela int 
    Declare @cd_tipo_pagamento_M smallint 
    Declare @vl_parcela_M money  
    Declare @dt_vencimento datetime 
    Declare @dt_vencimento_parc datetime 
    Declare @agencia int 
    Declare @dv_ag varchar(1) 
    Declare @nr_conta varchar(20)
    Declare @nr_conta_DV varchar(1)
    declare @nr_ctaope smallint 
    
    Declare @nr_autorizacao varchar(20)
    Declare @vl_parcela_L money
    Declare @cd_tipo_recebimento smallint
    Declare @G005 varchar(1)
    Declare @cpf_cnpj as varchar(14)
    Declare @tp_associado_Empresa as smallint 
    Declare @nr_contrato varchar(20)
    Declare @nn varchar(20)
    Declare @diasprotesto varchar(2)
    



    -- Variavel de Erro
    Declare @erro bit 
 
    -- Variaveis do Trailler
    Declare @qtde int 
    Declare @vl_total bigint
    Declare @qtde_no int = 0  
    Declare @vl_total_no bigint = 0 
    Declare @numerolinha int = 1 
    Declare @numero_nos int = 1 
    
    Declare @G025 varchar(2)
    Declare @C006aC010 varchar(5)
    Declare @C026 varchar(1)
    Declare @C027 varchar(2)

    
    Declare @SQL_C varchar(Max)


    Select top 1 @caminho = pasta_site from configuracao -- Verificar o caminho a ser gravado os arquivos
    IF @@ROWCOUNT = 0
    Begin -- 1.1
	  Raiserror('Pasta dos Arquivos não definida.',16,1)
	  RETURN
    End -- 1.1
    
    select @cd_tiposervico = l.cd_tipo_servico_bancario, -- Variaveis do Sistema
           @cd_tipopagamento = l.cd_tipo_pagamento ,  
           @nm_tipopagamento = t.nm_tipo_pagamento, 
           @cd_banco = t.banco ,
           @convenio = t.convenio ,
           @convenio_dv = t.dv_convenio,
           @cedente = t.cedente, 
           @nm_banco = b.nm_banco, 
           @dt_finalizado = l.dt_finalizado, 
           @nr_cnpj = t.nr_cnpj,
           @tp_ag = t.ag,
           @tp_ag_dv = t.dv_ag,
           @cta = t.cta,
           @dv_cta = t.dv_cta,
           @carteira = carteira,
           @juros = isnull(perc_juros,0),
           @multa = isnull(perc_multa,0),
           @taxa = 0, --ISNULL(vl_taxa,0)
           @agencia = t.ag ,
           @dv_ag = t.dv_ag,
           @instrucao4 = nm_mensagem1,
           @instrucao5 = nm_mensagem2,
           @instrucao6 = nm_mensagem3,
           @diasprotesto = t.dias_protesto
      from lote_processos_bancos as l, tipo_pagamento as t , tb_banco_contratos as b    
     where l.cd_sequencial = @sequencial and 
           l.cd_tipo_pagamento = t.cd_tipo_pagamento and 
           t.banco *= b.cd_banco 

    IF @@ROWCOUNT = 0
    Begin -- 1.2
	  Raiserror('Sequencial nao encontrado.',16,1)
	  RETURN
    End -- 1.2
    
    Select @qt_diasminimo = qt_diasminimo from tipo_servico_bancario where cd_tipo_servico_bancario=@cd_tiposervico
    Set @dt_ref = DATEADD(day,@qt_diasminimo,GETDATE())
    while DATEPART(dw,@dt_ref)=1 or DATEPART(dw,@dt_ref)=7
    Begin 
      set @dt_ref = DATEADD(day,1,@dt_ref)
    End 

     --Erro se arquivo já tiver sido finalizado
    if @dt_finalizado is not null
    Begin -- 1.3
	  Raiserror('Sequencial já finalizado e Gerado.',16,1)
	  RETURN
    End -- 1.3

    update Lote_Processos_Bancos_Mensalidades set mensagem = null where cd_sequencial_lote = @sequencial
   
	if @cd_tiposervico = 6 or -- Debito Automatico
       @cd_tiposervico in (1,3,5,11) or -- CNAB 240 
       @cd_tiposervico = 9 -- CNAB 400
    Begin -- 1.4

        -- Validar variaveis obrigatorias 
        if @cd_banco is null or @convenio is null or @cedente is null 
		Begin -- 2.1
		  Raiserror('Banco, Convênio ou Cedente não definidos na tabela de Tipo de Pagamento.',16,1)
		  RETURN
		End -- 2.1
    End -- 1.4 
    
  

	if @cd_tiposervico in (16,19) -- Cartao de Credito - Visa e Master - EDS/VAN
    Begin -- 1.4

        -- Validar variaveis obrigatorias 
        if @convenio is null or len(@convenio)<>10
		Begin -- 2.1
		  Raiserror('Convênio precisa ter 10 numeros.',16,1)
		  RETURN
		End -- 2.1
    End -- 1.4 

	if @cd_tiposervico in (17) -- Cartao de Credito - Hiper
    Begin -- 1.4

        -- Validar variaveis obrigatorias 
        if @convenio is null or len(@convenio)<>7
		Begin -- 2.1
		  Raiserror('Convênio precisa ter 7 numeros.',16,1)
		  RETURN
		End -- 2.1
    End -- 1.4 
        	
    --- Encontrar o @nsa do Arquivo. Sequencial 
    select @nsa = isnull(MAX(nsa),218)
      from (
             select isnull(max(nsa)+1,1) as nsa from lote_processos_bancos where convenio = @convenio
              union
             select isnull(max(nsa)+1,1) as nsa from Averbacao_lote where convenio = @convenio
            ) as x  

	Select @nm_arquivo = 
	         case when @cd_tiposervico = 0 then @convenio + '_' + replace(CONVERT(varchar(10),getdate(),103),'/','') + '_' + right('00000'+convert(varchar(10),@nsa),5) + '.txt'
	              when @cd_tiposervico in (6) then 'DBT' + right('00000'+convert(varchar(10),@sequencial),5) + '.txt' -- alterei aqui
	              when @cd_tiposervico =18 then  'CEX.ODONTOART.'+ CONVERT(varchar(8),getdate(),112) + '.sol'
	              when @cd_tiposervico in (16,19) then 'REM' + right('00000'+convert(varchar(10),@sequencial),5) + '.rem' -- alterei aqui
	              when @cd_tiposervico in (9,21) then 'CBR' + right('00000'+convert(varchar(10),@sequencial),5) + '.rem' -- alterei aqui
                  else replace(@nm_tipopagamento,' ','') + '_' + convert(varchar(10),@sequencial) + '_' + replace(convert(varchar(10),getdate(),103),'/','') + '.txt' -- alterei aqui
             end 
	   
	Set @arquivo = @caminho + '\arquivos\banco\envio\' + @nm_arquivo -- alterei aqui
    print @arquivo
    
    set @linha = 'Del '+  @arquivo
    EXEC SP_Shell @linha , 0 -- Excluir se o arquivo já existir            

/*******************Debito Automatico************************/
if @cd_tiposervico = 6 -- Debito Automatico
    Begin -- 2

        --- Header
        Set @linha = 'A1' + convert(char(20),@convenio) + convert(char(20),substring(@cedente,1,20)) + 
               right('000'+convert(varchar(3),@cd_banco),3) + -- Codigo do Banco
               convert(char(20),substring(@nm_banco,1,20)) +  -- Nome do Banco
               convert(varchar(8),getdate(),112) + -- Data de geração do arquivo (AAAAMMDD)
               right('000000'+convert(varchar(6),case when @cd_banco=1 then 0 else @nsa end),6) + -- Número sequencial do arquivo (NSA)
               '04DEBITO AUTOMATICO' + Space(52)
        Set @linha = 'ECHO ' + @linha +  '>> ' + @arquivo 
		EXEC SP_Shell @linha

        Select @erro = 0 , @vl_total = 0 , @qtde=0 

		DECLARE cursor_gera_processos_bancos_mens CURSOR FOR  
		
		select m.cd_associado_empresa , m.cd_parcela, m.cd_tipo_pagamento, 
               m.vl_parcela+isnull(m.vl_acrescimo,0)-isnull(m.vl_desconto,0)-isnull(m.vl_imposto,0) , 
               case when m.dt_vencimento<@dt_ref then @dt_ref else m.dt_vencimento end  , a.agencia, a.nr_autorizacao , l.vl_parcela , m.cd_tipo_recebimento , 
               a.nr_conta, a.nr_conta_DV, m.nosso_numero , isnull(a.nr_conta_operacao,0), isnull(Agencia_DV,'')
		  from Lote_Processos_Bancos_Mensalidades as L, Mensalidades as M, Associados as a
		 where L.cd_sequencial_lote = @sequencial and 
               l.cd_parcela = m.cd_parcela and 
               m.cd_Associado_empresa = a.cd_Associado and 
               m.tp_Associado_empresa = 1   
               
		OPEN cursor_gera_processos_bancos_mens  
		FETCH NEXT FROM cursor_gera_processos_bancos_mens INTO @cd_associado_empresa,@cd_parcela ,@cd_tipo_pagamento_M, @vl_parcela_M,@dt_vencimento,@agencia,@nr_autorizacao,@vl_parcela_L,@cd_tipo_recebimento,@nr_conta,@nr_conta_DV,@nn,@nr_ctaope,@dv_ag

		WHILE (@@FETCH_STATUS <> -1)  
		begin  -- 2.2        

           if @cd_tipo_pagamento_M <> @cd_tipopagamento
			Begin -- 2.2.1
              set @erro = 1 
			  update Lote_Processos_Bancos_Mensalidades 
                 set mensagem = 'Tipo de Pagamento do Associado ('+ convert(varchar(20),@cd_associado_empresa) + ') invalido.'
               where cd_sequencial_lote = @sequencial and 
                     cd_parcela = @cd_parcela
			End -- 2.2.1

   --        if @vl_parcela_M <> @vl_parcela_L
			--Begin -- 2.2.2
   --           set @erro = 1 
			--  update Lote_Processos_Bancos_Mensalidades 
   --              set mensagem = 'Parcela do Associado ('+ convert(varchar(20),@cd_associado_empresa) + ') diferente do Gerado.'
   --            where cd_sequencial_lote = @sequencial and 
   --                  cd_parcela = @cd_parcela
			--End -- 2.2.2

           if @agencia is null or LEN(@agencia)>4 
			Begin -- 2.2.3
              set @erro = 1 
			  update Lote_Processos_Bancos_Mensalidades 
                 set mensagem = 'Agencia do Associado ('+ convert(varchar(20),@cd_associado_empresa) + ') não informada ou invalida.'
               where cd_sequencial_lote = @sequencial and 
                     cd_parcela = @cd_parcela
			End -- 2.2.3

--           if @nr_autorizacao is null 
--			Begin -- 2.2.4
--              set @erro = 1 
--			  update Lote_Processos_Bancos_Mensalidades 
--                 set mensagem = 'Identificador do Associado ('+ convert(varchar(20),@cd_associado_empresa) + ') não informado.'
--               where cd_sequencial_lote = @sequencial and 
--                     cd_parcela = @cd_parcela
--			End -- 2.2.4
 
           if @cd_tipo_recebimento > 0 
			Begin -- 2.2.5
              set @erro = 1 
			  update Lote_Processos_Bancos_Mensalidades 
                 set mensagem = 'Associado ('+ convert(varchar(20),@cd_associado_empresa) + ') não encontra-se com a parcela em Aberto.'
               where cd_sequencial_lote = @sequencial and 
                     cd_parcela = @cd_parcela
			End -- 2.2.5

           if @nr_conta is null or @nr_conta = '' -- or @nr_conta_DV is null or @nr_conta_DV = ''
			Begin -- 2.2.6
              set @erro = 1 
			  update Lote_Processos_Bancos_Mensalidades 
                 set mensagem = 'Conta ou Digito Verificador do Associado ('+ convert(varchar(20),@cd_associado_empresa) + ') invalido.'
               where cd_sequencial_lote = @sequencial and 
                     cd_parcela = @cd_parcela
			End -- 2.2.6

            if @cd_banco = 104 
            begin
               set @linha = convert(varchar(14),@nr_conta) + convert(varchar(1),@nr_conta_DV)
               if LEN(@linha)<9
                  Set @linha = Right('000000000'+@linha,9)
            End
    
            select @linha = case when @cd_banco in (1,351) then right('00000000000000'+ convert(varchar(14),@nr_conta),14)            
                                 when @cd_banco in (104) then right('000000'+right('000'+convert(varchar(30),ISNULL(@nr_ctaope,'0')),3) + @linha,12) + SPACE(2)
                                 when @cd_banco in (237) then right('0000000'+convert(varchar(20),@nr_conta),7) + right('0'+convert(varchar(10),@nr_conta_DV),1) + Space(6)
                                 else right('0000000'+convert(varchar(20),@nr_conta),7) + right('0'+convert(varchar(10),@nr_conta_DV),1) + Space(6)
                                 end 

           -- Monta Linha
           print @linha 

            --if @nr_autorizacao is null or @nr_autorizacao = '' -- Nao tem o Numero da Autorizacao
            --Begin -- 2.2.7
            --  Set @nr_autorizacao = right('00000000'+convert(varchar(12),@cd_associado_empresa),8)+'002'
            --  update associados set nr_autorizacao = @nr_autorizacao where cd_Associado = @cd_associado_empresa
            --End -- 2.2.7

			Set @linha = 'E' + Left(convert(varchar(10),@cd_associado_empresa)+space(25),25) + -- Autorizacao. 
  				         right('00000'+convert(varchar(5),@agencia)+CONVERT(varchar(5),@dv_ag),4) + -- Bradesco (4ag + 1dv)
				         @linha + -- Conta (7) + Conta DV (1) + 6 espaco -- Identificação do cliente no Banco
				         convert(varchar(8),@dt_vencimento,112) + -- Data do vencimento (AAAAMMDD)  
					     right('000000000000000'+convert(varchar(15),convert(int,Floor(@vl_parcela_L*100))),15) + -- Valor do débito     
                         '03' + -- Moeda 
                         left('000'+convert(varchar(20),@nn)+SPACE(2)+CONVERT(varchar(20),@cd_parcela)+Space(49),49) + 
                         Space(31) + -- Identificação do cliente na Empresa  (25) = @sequencial (6) + Associado(8) + Tipo Pagamento (4) + Parcela (11) + Space(31). 
                         '0' -- Código do movimento (Debito Normal)

			
 		   Set @linha = 'ECHO ' + @linha + ' >> ' + @arquivo 
		   EXEC SP_Shell @linha

           if @Linha is null or @Linha = '' 
			Begin -- 2.2.6
              set @erro = 1 
			  update Lote_Processos_Bancos_Mensalidades 
                 set mensagem = 'Linha ('+ convert(varchar(20),@cd_associado_empresa) + ') invalida.'
               where cd_sequencial_lote = @sequencial and 
                     cd_parcela = @cd_parcela               
			End -- 2.2.6
					   
			
           Set @vl_total = @vl_total + convert(int,@vl_parcela_L*100)
           Set @qtde= @qtde + 1 

       	   FETCH NEXT FROM cursor_gera_processos_bancos_mens INTO @cd_associado_empresa,@cd_parcela ,@cd_tipo_pagamento_M, @vl_parcela_M,@dt_vencimento,@agencia,@nr_autorizacao,@vl_parcela_L,@cd_tipo_recebimento,@nr_conta,@nr_conta_DV,@nn,@nr_ctaope,@dv_ag
        end -- 2.2
        Close cursor_gera_processos_bancos_mens
        Deallocate cursor_gera_processos_bancos_mens

        -- Escrever Trailler
        Set @linha = 'Z' + right('000000'+convert(varchar(6),@qtde+2),6) + -- Total de registros do arquivo 
                     right('00000000000000000'+convert(varchar(17),@vl_total),17) + -- Valor total dos registros do arquivo
                     Space(126)
        Set @linha = 'ECHO ' + @linha +  '>> ' + @arquivo 
		EXEC SP_Shell @linha

   End -- 2
/****************Fim Debito Automatico***********************/

   if @cd_tiposervico = 16 -- Cartao Recorrente - Cielo e Master - EDS/Van
    Begin -- 1.4


		--Nr Qtde Tipo Descrição
		--Tipo de registro	N-02	001-002	00 – fixo	Obrigatoriamente igual a 00
		--Data do depósito	N-08	003-010	DDMMAAAA. Data de geração e transmissão do movimento	Formato válido como DDMMAAAA
		--Número do resumo de operações (RO)	N-07	011-017	Identifica o lote de transações - informado pelo estabelecimento.	Rejeição se número < 0 ou não numérico
		--Reservado para o estabelecimento	A-10	018-027	Uso exclusivo do estabelecimento.	Nenhuma verificação
		--Reservado Cielo	N-03	028-030	Zeros	Não lido
		--Número do estabelecimento	N-10	031-040	Número da maquina (contrato Cielo) 	Rejeição se número < 0 ou não numérico
		--Dígito verificador inválido
		--Moeda	N-03	041-043	‘986’ - Reais
		--Indicador do processo	A-01	044-044	 ‘P’ – Produção	Rejeita se diferente de “P”
		--Indicador de venda	A-01	045-045	‘V’ – fixo. Identifica transações de venda	Lote recusado caso diferente de ‘V”. 
		--Indicação de Ec especial	A-01	046-046	Brancos	Somente deverá ser diferente de brancos caso a equipe de sistemas assim determinar.
		--Reservado Cielo	A-204	047-250	Brancos	Não lido


        --- Header do Arquivo
        Set @linha = '00' + 
               replace(CONVERT(varchar(10),getdate(),103),'/','') + --Data do depósito	N-08	003-010	DDMMAAAA. Data de geração e transmissão do movimento	Formato válido como DDMMAAAA
               right('0000000'+convert(varchar(7),@nsa),7) + -- Número sequencial do arquivo
               SPACE(10) + '000' + 
               @convenio + -- Número do estabelecimento	N-10	031-040	Número da maquina (contrato Cielo)
               '986' + --Moeda	N-03	041-043	‘986’ - Reais
               'PV'+
               SPACE(1) + SPACE(204)

        Set @linha = 'ECHO ' + @linha +  '>> ' + @arquivo 
		EXEC SP_Shell @linha

        Select @erro = 0 , @vl_total = 0 , @qtde=0 
   
		DECLARE cursor_gera_processos_bancos_mens CURSOR FOR  
		select a.cd_associado , m.vl_parcela+isnull(m.vl_acrescimo,0)-isnull(m.vl_desconto,0)-isnull(m.vl_imposto,0) , 
		       a.nr_cpf , m.CD_PARCELA , a.nr_autorizacao, convert(varchar(10),a.val_cartao), convert(varchar(10),a.cd_seguranca), a.cd_bandeira , 
	           case when m.dt_vencimento <= dateadd(day,@qt_diasminimo,convert(varchar(10),getdate(),101)) then dateadd(day,@qt_diasminimo,convert(varchar(10),getdate(),101)) else m.dt_vencimento End 
   		  from Lote_Processos_Bancos_Mensalidades as L, Mensalidades as M, Associados as a , bandeira As BN
		 where L.cd_sequencial_lote = @sequencial and 
               l.cd_parcela = m.cd_parcela and 
               m.CD_ASSOCIADO_empresa  = a.cd_Associado and 
               a.cd_bandeira *= bn.cd_bandeira
         order by m.CD_PARCELA 
		OPEN cursor_gera_processos_bancos_mens  
		FETCH NEXT FROM cursor_gera_processos_bancos_mens INTO @cd_associado_empresa,@vl_parcela_M,@cpf_cnpj ,
              @cd_parcela,@nr_autorizacao, @val_cartao, @cd_seguranca, @cd_bandeira,@dt_vencimento

		WHILE (@@FETCH_STATUS <> -1)  
		begin  -- 2.2        

            if (@nr_autorizacao is null or len(@nr_autorizacao) <> 16) 
			Begin -- 2.2.5
              set @erro = 1 
			  update Lote_Processos_Bancos_Mensalidades 
                 set mensagem = 'Associado ('+ convert(varchar(20),@cd_associado_empresa) + ') sem numero de autorização ou errado.'
               where cd_sequencial_lote = @sequencial and 
                     cd_parcela = @cd_parcela
			End -- 2.2.5
			
            if (@val_cartao is null or len(@val_cartao) <> 6) 
			Begin -- 2.2.5
              set @erro = 1 
			  update Lote_Processos_Bancos_Mensalidades 
                 set mensagem = 'Associado ('+ convert(varchar(20),@cd_associado_empresa) + ') sem validade ou errado.'
               where cd_sequencial_lote = @sequencial and 
                     cd_parcela = @cd_parcela
     
			End -- 2.2.5
			
   --         if (@cd_seguranca is null or len(@cd_seguranca)<>3) 
			--Begin -- 2.2.5
   --           set @erro = 1 
			--  update Lote_Processos_Bancos_Mensalidades 
   --              set mensagem = 'Associado ('+ convert(varchar(20),@cd_associado_empresa) + ') sem código de segurança ou errado.'
   --            where cd_sequencial_lote = @sequencial and 
   --                  cd_parcela = @cd_parcela
			--End -- 2.2.5
			
            if @cd_bandeira is null 
			Begin -- 2.2.5
              set @erro = 1 
			  update Lote_Processos_Bancos_Mensalidades 
                 set mensagem = 'Associado ('+ convert(varchar(20),@cd_associado_empresa) + ') sem bandeira.'
               where cd_sequencial_lote = @sequencial and 
                     cd_parcela = @cd_parcela
			End -- 2.2.5

           Set @vl_total = @vl_total + convert(int,@vl_parcela_M*100)
           Set @qtde= @qtde + 1 
           
		--Tipo de registro	N-02	001-002	01 - fixo	Somente aceito se igual a “01”
		--Número do comprovante de venda (CV)
		--PARCELA	N-07	003-009	Número seqüencial atribuído pelo EC que identifica a transação no lote.	 
		--Número do cartão	N-19	010-028	Número do cartão	Nenhuma consistência
		--Código de autorização	A-06	029-034	Se preenchido, consideramos como transação já autorizada, caso contrário, preencher com zeros	Nenhuma consistência
		--Data da venda	N-08	035-042	DDMMAAAA	Somente aceito o formato especificado
		--Opção da venda	N-01	043-043	0 – À vista
		--2 - Parcelado lojista 	Rejeita se diferente de 0 ou 2
		--Rejeitado se diferente dos outros CV’s do lote
		--Valor da venda	N-13-V99	044-058	Venda à vista => valor da venda
		-- Venda parcelada => valor total da venda. 	Rejeição para números maiores do que 9 dígitos. Não pode ser < 0 ou não numérico
		--Quantidade de parcelas	N-03	059-061	Venda à vista => preencher com zeros
		-- Venda parcelada => quantidade de parcelas 	- Não pode ser <0 ou não numérico
		--- Tem que respeitar a “opção de venda”
		--Reservado Cielo	N-15	062-076	Zeros	Numérico igual a zeros
		--Reservado Cielo	N-15	077-091	Zeros	Numérico igual a zeros
		--Reservado Cielo	N-15	092-106	Zeros	Nnumérico igual a zeros
		--Valor da parcela	N-13-V99	107-121	Venda à vista => preencher com zeros
		-- Venda parcelada => Valor da parcela (sem arredondamento)	Rejeição para números maiores do que 9 dígitos
		--Número do resumo de operações (RO)	N-07	122-128	Número do RO informado no registro header	Mesmo número do header
		--Reservado Cielo	N-03	129-131	Zeros	Não lido
		--Número do Estabelecimento Comercial	N-10	132-141	Número da maquina (contrato Cielo)	Deverá ser o mesmo do header
		--Reservado para o estabelecimento
		--Codigo do Associado --Vencimento 	A-30	142-171	Uso exclusivo do estabelecimento.	Sem verificações
		--Status da venda	N-02	172-173	No arquivo de remessa preencher com zeros.
		--Data prevista de crédito	N-08	174-181	No arquivo de remessa preencher com zeros. 
		--Validade do cartão	A-04	182-185	AAMM (informação obrigatória)	Sem verificações
		--Reservado Cielo	N-07	186-192	Zeros	Não lido
		--Reservado Cielo	N-15	193-207	Zeros	Não lido
		--CVV2	A-03	208-210	Código de segurança, qdo não preenchido informar brancos.	Sem verificações
		--Código de erro	A-04	211-214	No arquivo de remessa preencher com brancos. 
		--No arquivo retorno, será formatado conforme tabela Descrição de Erros quando o campo Status de venda estiver preenchido com 99 - somente para remessas via PROCEDA.??	Sem verificações
		--Número de referencia 	A-11	215-225	Brancos	Deve ser brancos
		--Reservado Cielo	A-25	226-250	Brancos	 Não lido

           
           --Registro Detalhe 
			Set @linha = '01' + RIGHT('0000000'+convert(varchar(10),@cd_parcela),7) + '000' + @nr_autorizacao + '000000' + 
			             replace(CONVERT(varchar(10),getdate(),103),'/','') + 
			             --replace(convert(varchar(10),@dt_vencimento,103),'/','') +  
			             '0' + -- Venda a vista
			             right('000000000000000'+Replace(convert(varchar(15),convert(int,Floor(@vl_parcela_M*100))),'.','') ,15) + -- Valor do débito      
			             '000'+
			             '000000000000000' + -- Reservado Cielo
			             '000000000000000' + -- Reservado Cielo
			             '000000000000000' + -- Reservado Cielo
			             '000000000000000' + -- Valor da parcela
			             right('0000000'+convert(varchar(7),@nsa),7) + -- Número sequencial do arquivo
			             '000' + 
                         @convenio + -- Número do estabelecimento	N-10	031-040	Número da maquina (contrato Cielo)
			             right('00000000000000000000000000000'+convert(varchar(30),@cd_associado_empresa),30) + 
                         '0000000000' + 
                         right(convert(varchar(10),@val_cartao),2) + left(convert(varchar(10),@val_cartao),2) + -- Validade Cartao AAMM 
                         '0000000' + '000000000000000' + 
                         case when isnull(@cd_seguranca,'')='' then space(3) else right('000'+convert(varchar(3),@cd_seguranca),3) end + 
                         SPACE(4) + 
                         Space(11) + Space(25)
                          
           if @Linha is null or @Linha = '' 
			Begin -- 2.2.6
              set @erro = 1 
			  update Lote_Processos_Bancos_Mensalidades 
                 set mensagem = 'Linha ('+ convert(varchar(20),@cd_associado_empresa) + ') invalida.'
               where cd_sequencial_lote = @sequencial and 
                     cd_parcela = @cd_parcela               
			End -- 2.2.6
           
		   Set @linha = 'ECHO ' + @linha +  '>> ' + @arquivo 
 		   EXEC SP_Shell @linha

		FETCH NEXT FROM cursor_gera_processos_bancos_mens INTO @cd_associado_empresa,@vl_parcela_M,@cpf_cnpj ,
              @cd_parcela,@nr_autorizacao, @val_cartao, @cd_seguranca, @cd_bandeira,@dt_vencimento
        end -- 2.2
        Close cursor_gera_processos_bancos_mens
        Deallocate cursor_gera_processos_bancos_mens

		--Nr Qtde Tipo Descrição
		--Tipo de registro	N-02	001-002	99 – fixo	Obrigatório o uso do código “99”
		--Quantidade de registros	N-07	003-009	Inclusive header e trailler 	Rejeição se < 0 ou não numérico
		--Valor total bruto	N-13-V99	010-024	Informado pelo estabelecimento – Valor total do lote, somatória do campo valor da venda do registro detalhe	Rejeição se < 0 ou não numérico
		--Valor total aceito	N-13-V99	025-039	No arquivo de remessa preencher com zeros,.
		--No arquivo retorno, será formatado pela Cielo com o valor total aceito	Sem verificações
		--Valor total liquido	N-13-V99	040-054	No arquivo de remessa preencher com zeros.
		--No arquivo retorno, será formatado pela Cielo com o valor total liquido	Sem verificações
		--Data prevista de crédito	N-08	055-062	No arquivo de remessa preencher com zeros. 
		--No arquivo retorno, será formatado pela Cielo com a data prevista de pagamento	Sem verificações
		--Reservado Cielo	A-188	063-250	Brancos	Não lido
		
        -- Registro Trailer de Lote
        Set @linha = '99' + RIGHT('0000000'+convert(varchar(10),@qtde+2),7) + -- Qtde de Cobranças Novas
                     right('00000000000000000'+convert(varchar(17),@vl_total),15) + -- Valor total dos registros do arquivo
                     '000000000000000' + 
                     '000000000000000' +
                     '00000000' +
                     Space(188)
                     
        Set @linha = 'ECHO ' + @linha +  '>> ' + @arquivo 
		EXEC SP_Shell @linha

   End -- 1.4

   if @cd_tiposervico IN (3,5,11) -- SANTANDER pf
    Begin -- 2
       
        -- Variaveis necessarias para gerar a rotina (Variavel_Banco_ServicoBancario)
        if @cd_banco is null 
		Begin -- 2.1
		  Raiserror('Banco, Convênio ou Cedente não definidos na tabela de Tipo de Pagamento.',16,1)
		  RETURN
		End -- 2.1

	   Select @G025=valor from Variavel_Banco_ServicoBancario where variavel='G025' and cd_banco=@cd_banco and cd_tipo_servico_bancario=@cd_tiposervico  
       Select @C006aC010=valor from Variavel_Banco_ServicoBancario where variavel='C006aC010' and cd_banco=@cd_banco and cd_tipo_servico_bancario=@cd_tiposervico  
       Select @C026=valor from Variavel_Banco_ServicoBancario where variavel='C026' and cd_banco=@cd_banco and cd_tipo_servico_bancario=@cd_tiposervico   
       Select @C027=valor from Variavel_Banco_ServicoBancario where variavel='C027' and cd_banco=@cd_banco and cd_tipo_servico_bancario=@cd_tiposervico   

        if Len(rtrim(@G025)) <> 2 or @G025 is null or 
           Len(rtrim(@C006aC010)) <> 5 or @C006aC010 is null or 
           Len(rtrim(@C026)) <> 1 or @C026 is null or 
           Len(rtrim(@C027)) <> 2 or @C027 is null 
		Begin -- 2.0
		
		  Raiserror('Variaveis necessarias para gerar a Rotina não encontrada. Informe ao administrador do sistema.',16,1)
		  RETURN
		End -- 2.0      

        if len(rtrim(@nr_cnpj))<14 -- CNPJ não informado
		Begin -- 2.0.1
		  Raiserror('CNPJ não informado.',16,1)
		  RETURN
		End -- 2.0.1      

        if @carteira is null 
		Begin -- 2.0.3
		  Raiserror('Carteira deve ser informado.',16,1)
		  RETURN
		End -- 2.0.3    

        --- Header do Arquivo
        Set @linha = right('000'+convert(varchar(3),@cd_banco),3) + -- Codigo do Banco
               '00000' + Space(8) + -- Lote de Servico, Tipo de Registro e Uso Exclusivo FEBRABAN / CNAB
               '20' + @nr_cnpj + -- CNPJ 
               right('000'+@tp_ag,4)+right('0000000'+@convenio,11) +
             --  '206200000872830' + -- Codigo de Transmissao 
             --'206200000065072'
               SPACE(25) + 
               convert(char(30),substring(@cedente,1,30)) +  -- Nome do Cedente
               convert(char(30),substring(@nm_banco,1,30)) +  -- Nome do Banco
               Space(10) + '1' + replace(convert(varchar(10),getdate(),103),'/','') + Space(6) + -- Data e Hora da Geração do Arquivo
               right('000000'+convert(varchar(6),@nsa),6) + -- Número sequencial do arquivo (NSA)
               '040' + Space(74) -- No da Versão do Layout do Arquivo // Densidade de Gravação do Arquivo

        Set @linha = 'ECHO ' + @linha +  '>> ' + @arquivo 
		EXEC SP_Shell @linha

        -- Header do Lote
        Set @linha =  right('000'+convert(varchar(3),@cd_banco),3) + -- Codigo do Banco
               '00011R' + -- Lote de Servico, Tipo de Registro, Tipo de Operação
               @G025 + -- Tipo de Serviço (‘01’ = Cobrança,‘02’ = Cobrança Sem Registro / Serviços,‘03’ = Desconto de Títulos,‘04’ = Caução de Títulos
               Space(2) + '030' + -- Uso Exclusivo FEBRABAN/CNAB//Nº da Versão do Layout do Lote//Uso Exclusivo FEBRABAN/CNAB//
               Space(1) + '20' + @nr_cnpj + -- CNPJ
               Space(20) + 
               --'206200000872830' + -- Uso Exclusivo CAIXA
               right('000'+@tp_ag,4)+right('0000000'+@convenio,11) +
               SPACE(5) + 
               convert(char(30),substring(@cedente,1,30)) +  -- Nome do Cedente
               Space(80) + -- Mensagem 1//Mensagem 2
               right('00000000'+convert(varchar(8),@nsa),8) + -- Número sequencial do arquivo (NSA)
			   replace(convert(varchar(10),getdate(),103),'/','') + -- Data da Geração do Arquivo
               Space(41) -- Data do Crédito // Uso Exclusivo FEBRABAN/CNAB

        Set @linha = 'ECHO ' + @linha +  '>> ' + @arquivo 
  		EXEC SP_Shell @linha

        Select @erro = 0 , @vl_total = 0 , @qtde=0 
        
        Set @SQL_C = 'DECLARE cursor_gera_processos_bancos_mens CURSOR FOR '
		 Set @SQL_C = @SQL_C + ' select m.cd_associado_empresa , m.cd_parcela, m.cd_tipo_pagamento, 		 
               m.vl_parcela+isnull(m.vl_acrescimo,0)-isnull(m.vl_desconto,0)-isnull(m.vl_imposto,0)+ISNULL(m.vl_taxa,0)+ISNULL(m.VL_JurosMultaReferencia,0)+ISNULL(m.vl_acrescimoavulso,0)-ISNULL(m.VL_DescontoAvulso,0) , 
               l.dt_vencimento , l.vl_parcela , m.cd_tipo_recebimento , ''1'' as G005,
               a.nr_cpf ,a.nm_completo as nm_completo,dbo.FF_RemoveCaracterSpecial (case when len(isnull(EndBoleto,''''))>5 then EndBoleto else ltrim(Isnull(TL.NOME_TIPO,'''')+'' ''+a.EndLogradouro+'' ''+Case When a.EndNumero is null then '''' When a.endNumero=0 then '''' else convert(varchar(10),a.endnumero) end+'' ''+ISNULL(a.EndComplemento,'''')) end), 
		       dbo.FF_RemoveCaracterSpecial(isnull(b.baiDescricao,'''')), a.logcep,  isnull(Cid.NM_MUNICIPIO,'''') , isnull(UF.ufSigla,''''), m.nosso_numero
   		  from Lote_Processos_Bancos_Mensalidades as L, Mensalidades as M, Associados as a  , TB_TIPOLOGRADOURO as TL, Bairro as B, MUNICIPIO as CID, UF 
		 where L.cd_sequencial_lote = ' + convert(varchar(10),@sequencial) + ' and 
               l.cd_parcela = m.cd_parcela and 
               m.cd_Associado_empresa = a.cd_Associado and 
               m.tp_Associado_empresa = 1  and 
               a.CHAVE_TIPOLOGRADOURO *= tl.CHAVE_TIPOLOGRADOURO and 
               a.BaiId*=b.baiId and 
               a.cidid *= CId.CD_MUNICIPIO and 
               a.ufId *= Uf.ufId '
           if @tipo>0    
              Set @SQL_C = @SQL_C + ' and a.cd_associado ' + case when @tipo=1 then 'not' else '' end + ' in (select distinct cd_Associado from carteiras as c, lote_processos_bancos as l where c.sq_lote = l.cd_sequencial_lote_carteira and l.cd_sequencial = ' + convert(varchar(10),@sequencial) + ') '
  
         Set @SQL_C = @SQL_C + ' union '
		Set @SQL_C = @SQL_C + ' select m.cd_associado_empresa , m.cd_parcela, m.cd_tipo_pagamento, 
               m.vl_parcela+isnull(m.vl_acrescimo,0)-isnull(m.vl_desconto,0)-isnull(m.vl_imposto,0)+ISNULL(m.vl_taxa,0)+ISNULL(m.VL_JurosMultaReferencia,0)+ISNULL(m.vl_acrescimoavulso,0)-ISNULL(m.VL_DescontoAvulso,0) , 
               l.dt_vencimento , l.vl_parcela , m.cd_tipo_recebimento , ''2'' as G005,
               a.nr_cgc, a.nm_razsoc as nm_completo,dbo.FF_RemoveCaracterSpecial ( ltrim(Isnull(TL.NOME_TIPO,'''')+'' ''+a.EndLogradouro+'' ''+Case When a.EndNumero is null then '''' When a.endNumero=0 then '''' else convert(varchar(10),a.endnumero) end+'' ''+ISNULL(a.EndComplemento,'''')) ), 
		       dbo.FF_RemoveCaracterSpecial(isnull(b.baiDescricao,'''')), a.cep,  isnull(Cid.NM_MUNICIPIO,'''') , isnull(UF.ufSigla,''''), m.nosso_numero
   		  from Lote_Processos_Bancos_Mensalidades as L, Mensalidades as M, empresa as a, TB_TIPOLOGRADOURO as TL, Bairro as B, MUNICIPIO as CID, UF 
		 where L.cd_sequencial_lote = ' + convert(varchar(10),@sequencial) + ' and 
               l.cd_parcela = m.cd_parcela and 
               m.cd_Associado_empresa = a.cd_empresa and 
               m.tp_Associado_empresa in (2,3) and 
               a.CHAVE_TIPOLOGRADOURO *= tl.CHAVE_TIPOLOGRADOURO and 
               a.BaiId*=b.baiId and 
               a.cd_municipio *= CId.CD_MUNICIPIO and 
               a.ufId *= Uf.ufId '

        Set @SQL_C = @SQL_C + ' order by nm_completo, l.dt_vencimento, m.cd_parcela  '
        print @sql_C
        exec(@sql_C)

		OPEN cursor_gera_processos_bancos_mens  
		FETCH NEXT FROM cursor_gera_processos_bancos_mens INTO @cd_associado_empresa,@cd_parcela ,@cd_tipo_pagamento_M, @vl_parcela_M,@dt_vencimento,@vl_parcela_L,@cd_tipo_recebimento,@G005,@cpf_cnpj ,
              @nome, @endereco, @bairro, @cep, @cidade, @uf ,@nn

		WHILE (@@FETCH_STATUS <> -1)  
		begin  -- 2.2        

           if @cep is null 
           begin -- 2.2.0

              set @erro = 1 
			  update Lote_Processos_Bancos_Mensalidades 
                 set mensagem = 'Cep do Associado ('+ convert(varchar(20),@cd_associado_empresa) + ') invalido.'
               where cd_sequencial_lote = @sequencial and 
                     cd_parcela = @cd_parcela

           End -- 2.2.0

           if @cd_tipo_pagamento_M <> @cd_tipopagamento
			Begin -- 2.2.1
              set @erro = 1 
			  update Lote_Processos_Bancos_Mensalidades 
                 set mensagem = 'Tipo de Pagamento do Associado ('+ convert(varchar(20),@cd_associado_empresa) + ') invalido.'
               where cd_sequencial_lote = @sequencial and 
                     cd_parcela = @cd_parcela
			End -- 2.2.1

   --        if @vl_parcela_M <> @vl_parcela_L
			--Begin -- 2.2.2
   --           set @erro = 1 
			--  update Lote_Processos_Bancos_Mensalidades 
   --              set mensagem = 'Parcela do Associado ('+ convert(varchar(20),@cd_associado_empresa) + ') diferente do Gerado.'
   --            where cd_sequencial_lote = @sequencial and 
   --                  cd_parcela = @cd_parcela
			--End -- 2.2.2

           if @cd_tipo_recebimento > 0 
			Begin -- 2.2.5
              set @erro = 1 
			  update Lote_Processos_Bancos_Mensalidades 
                 set mensagem = 'Associado ('+ convert(varchar(20),@cd_associado_empresa) + ') não encontra-se com a parcela em Aberto.'
               where cd_sequencial_lote = @sequencial and 
                     cd_parcela = @cd_parcela
			End -- 2.2.5

           Set @vl_total = @vl_total + convert(int,@vl_parcela_L*100)
           Set @qtde= @qtde + 1 
           --Registro Detalhe - Segmento P (Obrigatório - Remessa)
			Set @linha = right('000'+convert(varchar(3),@cd_banco),3) + -- Codigo do Banco
                         '00013'+ right('00000'+convert(varchar(5),(@qtde-1)*3+1),5)+'P' + -- Lote de Servico, Tipo de Registro, Nº Sequencial do Registro no Lote,Cód. Segmento do Registro Detalhe
  				         space(1) + '01' +  -- Código de Movimento Remessa
                         right('00'+@tp_ag,4) + @tp_ag_dv + 
                         right('000000'+@cta,9) + @dv_cta + -- Agência Mantenedora da Conta // Dígito Verificador da Agência//Código do Convênio no Banco (Conta)
                         right('000000'+@cta,9) + @dv_cta +
                         Space(2) + 
                         right('00000000000000'+convert(varchar(12),@nn),12)  + 
                         dbo.FS_CalculoModulo11(right('00000000000000'+convert(varchar(12),@nn),12),4) + -- (Nosso Número = Modalidade da Carteira (2) + Nosso Numero
				         case when @cd_tiposervico = 3 then '5' else '1' end + '11'+SPACE(2) + -- Código da Carteira, Forma de Cadastr. do Título no Banco, Tipo de Documento, Identificação da Emissão do Bloqueto, Identificação da Entrega do Bloqueto
                         right('00000000000'+convert(varchar(11),@cd_parcela),11)  + -- Número do Documento de Cobrança
				         Space(4) + replace(convert(varchar(10),@dt_vencimento,103),'/','') + -- Data do vencimento (DDMMAAAA)  
					     right('000000000000000'+Replace(convert(varchar(15),convert(int,Floor(@vl_parcela_L*100))),'.','') ,15) + -- Valor do débito      
                         '00000' + SPACE(1) + -- Agência Encarregada da Cobrança//Dígito Verificador da Agência
                         '02N' + -- Espécie do Título//Identificação de Título Aceito / Não Aceito
                         replace(convert(varchar(10),getdate(),103),'/','') + -- Data da Emissão do Título
                         '1' + replace(convert(varchar(10),@dt_vencimento,103),'/','') + -- Código do Juros de Mora (1-dia,2-Mes,3-Isento)//Data do Juros de Mora//Juros de Mora por Dia 
                         right('000000000000000'+dbo.FF_Formatanumerobanco(convert(varchar(15),round(convert(float,@vl_parcela_L)*@juros/100/30,2))),15)  + -- Taxa (se dia=informar valor, se mes=informar tx)

                       --  '2' + replace(convert(varchar(10),@dt_vencimento,103),'/','') + -- Código do Juros de Mora (1-dia,2-Mes,3-Isento)//Data do Juros de Mora//Juros de Mora por Dia 
                       --  right('000000000000000'+replace(convert(varchar(15),convert(int,@juros)),'.',''),13)+'00'  + -- Taxa (se dia=informar valor, se mes=informar tx)
                                                  
                         '000000000000000000000000' + -- Código do Desconto 1//Data do Desconto 1//Valor/Percentual a ser Concedido
                         '000000000000000' + '000000000000000' + -- Valor do IOF a ser Recolhido//Valor do Abatimento
                         right('000000000000000000000000000000'+convert(varchar(10),@cd_parcela),25) + -- Identificação do Título na Empresa
                         '3001' + '0' + '29' + --Código para Protesto//Número de Dias para Protesto//Código para Baixa/Devolução//Número de Dias para Baixa/Devolução
                         '00' + -- Código da Moeda
                         space(11) 

           print  @linha     -- P
                          
           if @Linha is null or @Linha = '' 
			Begin -- 2.2.6
              set @erro = 1 
			  update Lote_Processos_Bancos_Mensalidades 
                 set mensagem = 'Linha ('+ convert(varchar(20),@cd_associado_empresa) + 'P) invalida.'
               where cd_sequencial_lote = @sequencial and 
                     cd_parcela = @cd_parcela
			End -- 2.2.6
           
		   Set @linha = 'ECHO ' + @linha +  '>> ' + @arquivo 
 		   EXEC SP_Shell @linha

           -- Registro Detalhe - Segmento Q (Obrigatório - Remessa)
			Set @linha = right('000'+convert(varchar(3),@cd_banco),3) + -- Codigo do Banco
                         '00013'+ right('00000'+convert(varchar(5),(@qtde-1)*3+2),5)+'Q' + -- Lote de Servico, Tipo de Registro, Nº Sequencial do Registro no Lote,Cód. Segmento do Registro Detalhe
  				         space(1) + '01' +  -- Código de Movimento Remessa -- @nr_cnpj
  				         case when len(@cpf_cnpj)>11 then '2' + right('000000000000000'+@cpf_cnpj,15)  else '1' + right('000000000000000'+@cpf_cnpj,15) end  + -- Tipo de Inscrição (1-PF,2-PJ) // Número de Inscrição (cpf/cnpj)
                         substring(@nome+Space(40),1,40) + substring(@endereco+Space(40),1,40) + substring(@bairro+Space(15),1,15) + 
                         substring(@cep+space(5),1,5) + right('000'+@cep,3) + substring(@cidade+Space(15),1,15) + substring(@uf+space(2),1,2) + 
                        -- '0000000000000000' + space(40) + '000' + Space(28) -- Sacados
                         --@G005 + right('000000000000000'+@cpf_cnpj,15) + 
                         '0' + '000000000000000' + 
                         substring(@nome+Space(80),41,40) + 
                         '000000000000' + Space(19) -- Sacados

           print  @linha -- Q

           if @Linha is null or @Linha = '' 
			Begin -- 2.2.7
              set @erro = 1 
			  update Lote_Processos_Bancos_Mensalidades 
                 set mensagem = 'Linha ('+ convert(varchar(20),@cd_associado_empresa) + 'Q) invalida.'
               where cd_sequencial_lote = @sequencial and 
                     cd_parcela = @cd_parcela
			End -- 2.2.7

		   Set @linha = 'ECHO ' + @linha +  '>> ' + @arquivo 
 		   EXEC SP_Shell @linha

         -- Registro Detalhe - Segmento R (Obrigatório - Remessa)
			Set @linha = right('000'+convert(varchar(3),@cd_banco),3) + -- Codigo do Banco
                         '00013'+ right('00000'+convert(varchar(5),(@qtde-1)*3+3),5)+'R' + -- Lote de Servico, Tipo de Registro, Nº Sequencial do Registro no Lote,Cód. Segmento do Registro Detalhe
  				         space(1) + '01' +  -- Código de Movimento Remessa
                         '000000000' + '000000000000000' + 
                         Space(24) + 
                         '2' + replace(convert(varchar(10),@dt_vencimento,103),'/','') + 
                         --right('000000000000000'+replace(convert(varchar(15),round(convert(float,@vl_parcela_L)*@multa/100,2)),'.',''),15) + 
                         right('000000000000000'+convert(varchar(10),@multa),13)+'00'+
                         SPACE(10) + SPACE(40) + SPACE(40) + SPACE(61)

           print  @linha -- Q

           if @Linha is null or @Linha = '' 
			Begin -- 2.2.7
              set @erro = 1 
			  update Lote_Processos_Bancos_Mensalidades 
                 set mensagem = 'Linha ('+ convert(varchar(20),@cd_associado_empresa) + 'R) invalida.'
               where cd_sequencial_lote = @sequencial and 
                     cd_parcela = @cd_parcela
			End -- 2.2.7

		   Set @linha = 'ECHO ' + @linha +  '>> ' + @arquivo 
 		   EXEC SP_Shell @linha 		   
                         
            -- Barra e Linha digitavel             
		   Set @nn = right('00000000000000'+convert(varchar(12),@nn),12)
                     
           
		   Set @nn = @nn + dbo.FS_CalculoModulo11(right('00000000000000'+convert(varchar(12),@nn),12),4)

		   Set @CampoLivre = '9'+right('00000'+@convenio,7)+@nn+'0'+right('000'+convert(varchar(10),@carteira),3)
		   Set @CampoLivre = @CampoLivre +  dbo.FS_CalculoModulo11(@CampoLivre,3)
		   	
		   Set @codbarras = right('00'+convert(varchar(3),@cd_banco),3)+ '9' + convert(varchar(4),DATEDIFF(day,'10/07/1997',@dt_vencimento)) + -- Fator de Vencimento
			   right('00000000000'+Replace(convert(varchar(12),convert(int,Floor((@vl_parcela_M+@taxa)*100))),'.',''),10) + -- Valor da Parcela 
			   @CampoLivre

print '---'
			print @CampoLivre
			print @codbarras
			print Len(@codbarras)
			print dbo.FS_DigitoVerificarCodigoBarras(@codbarras)
print '---'
            
			Set @codbarras = left(@codbarras,4) + dbo.FS_DigitoVerificarCodigoBarras(@codbarras) + right(@codbarras,39)
			 
			Set @linhaDig1 = left(@codbarras,4) + left(@CampoLivre,5) 
			Set @linhaDig1 = left(@linhaDig1,5) + '.' + right(@linhaDig1,4) + dbo.FS_CalculoModulo10(@linhaDig1) 
            
			Set @linhaDig2 = substring(@CampoLivre,6,10) 
			Set @linhaDig2 = left(@linhaDig2,5) + '.' + right(@linhaDig2,5) + dbo.FS_CalculoModulo10(@linhaDig2) 

			Set @linhaDig3 = substring(@CampoLivre,16,10) 
			Set @linhaDig3 = left(@linhaDig3,5) + '.' + right(@linhaDig3,5) + dbo.FS_CalculoModulo10(@linhaDig3) 

			Set @linhaDig4 = substring(@codbarras,5,1)

			Set @linhaDig5 = substring(@codbarras,6,14)

			Set @linha = @linha + @linhaDig1 + ' ' + @linhaDig2 + ' ' + @linhaDig3 + ' ' + @linhaDig4 + ' ' + @linhaDig5 + 
			    @codbarras
	              
		   print @linhaDig1
           print @linhaDig2
           print @linhaDig3
           print @linhaDig4
           print @linhaDig5 
                                                      
			--Gravar Boleto ---		   
           insert Boleto (cd_sequencial_lote,cd_associado_empresa,cd_parcela,cedente,cnpj,
             dt_vencimento,agencia,dg_ag,conta,dg_conta,convenio,dg_convenio,carteira,
             nn,valor,pagador,cpf_cnpj_pagador,end_pagador,bai_pagador,cep_pagador,mun_pagador,
             uf_pagador,vl_multa,vl_juros,instrucao1,instrucao2,instrucao3,instrucao4,linha,barra,cod_barra,fl_lotebanco)
             
           values (@sequencial,@cd_associado_empresa,@cd_parcela,@cedente,@nr_cnpj,
           CONVERT(varchar(10),@dt_vencimento,103),@agencia,@dv_ag,@cta,@dv_cta, @convenio,@convenio_dv,@carteira,
           @nn,@vl_parcela_L,@nome,@cpf_cnpj, @endereco, @bairro, @cep, @cidade, @uf, 
           round(@vl_parcela_L*@multa/100*100,0)/100, round(@vl_parcela_L*@juros/100/30*100,0)/100,
           @instrucao1, @instrucao2, @instrucao3, @instrucao4, @linhaDig1 + ' ' + @linhaDig2 + ' ' + @linhaDig3 + ' ' + @linhaDig4 + ' ' + @linhaDig5, 
           @codbarras, dbo.FG_TRADUZ_Codbarras(@codbarras),1) 
             -------------------------------------------------
              
           if @@ROWCOUNT = 0 
			Begin -- 3.2.6
              set @erro = 1 
			  update Lote_Processos_Bancos_Mensalidades 
                 set mensagem = 'Linha ('+ convert(varchar(20),@cd_associado_empresa) + 'B) invalida.'
               where cd_sequencial_lote = @sequencial and 
                     cd_parcela = @cd_parcela
			End -- 3.2.6

 		   FETCH NEXT FROM cursor_gera_processos_bancos_mens INTO @cd_associado_empresa,@cd_parcela ,@cd_tipo_pagamento_M, @vl_parcela_M,@dt_vencimento,@vl_parcela_L,@cd_tipo_recebimento,@G005,@cpf_cnpj ,
                  @nome, @endereco, @bairro, @cep, @cidade, @uf ,@nn

        end -- 2.2
        Close cursor_gera_processos_bancos_mens
        Deallocate cursor_gera_processos_bancos_mens

        -- Registro Trailer de Lote
        Set @linha = right('000'+convert(varchar(3),@cd_banco),3) + -- banco
                     '00015' + Space(9) +  -- Lote de Serviço//Tipo de Registro//Uso Exclusivo FEBRABAN/CNAB
                     right('000000'+convert(varchar(6),(@qtde*3)+2),6) + -- Quantidade de Registros no Lote
                     SPACE(217)
                     
                     --right('000000'+convert(char(6),@qtde),6) + -- Quantidade de Títulos em Cobrança
                     --right('00000000000000000'+convert(char(17),@vl_total),17) + -- Valor total dos registros do arquivo
                     --'000000' + '00000000000000000' + -- Totalização da Cobrança Caucionada 
                     --'000000' + '00000000000000000' + -- Totalização da Cobrança Descontada
                     --Space(31) + Space(117)
        Set @linha = 'ECHO ' + @linha +  '>> ' + @arquivo 
		EXEC SP_Shell @linha

        -- Escrever Trailler
        Set @linha = right('000'+convert(varchar(3),@cd_banco),3) + -- banco
                     '99999' + Space(9) +  -- Lote de Serviço//Tipo de Registro//Uso Exclusivo FEBRABAN/CNAB//
                     '000001' + right('000000'+convert(varchar(6),(@qtde*3)+4),6) + -- Quantidade de Lotes do Arquivo//Quantidade de Registros no arquivo
                     Space(6) + Space(205)

        Set @linha = 'ECHO ' + @linha +  '>> ' + @arquivo 
		EXEC SP_Shell @linha

   End -- 2
   
--   if @cd_tiposervico = 5 -- SANTANDER PJ
--    Begin -- 2
       
--        -- Variaveis necessarias para gerar a rotina (Variavel_Banco_ServicoBancario)
--        if @cd_banco is null 
--		Begin -- 2.1
--		  Raiserror('Banco, Convênio ou Cedente não definidos na tabela de Tipo de Pagamento.',16,1)
--		  RETURN
--		End -- 2.1
		
--        Select @G025=valor from Variavel_Banco_ServicoBancario where variavel='G025' and cd_banco=@cd_banco and cd_tipo_servico_bancario=@cd_tiposervico  

--        Select @C006aC010=valor from Variavel_Banco_ServicoBancario where variavel='C006aC010' and cd_banco=@cd_banco and cd_tipo_servico_bancario=@cd_tiposervico  

--        Select @C026=valor from Variavel_Banco_ServicoBancario where variavel='C026' and cd_banco=@cd_banco and cd_tipo_servico_bancario=@cd_tiposervico   

--        Select @C027=valor from Variavel_Banco_ServicoBancario where variavel='C027' and cd_banco=@cd_banco and cd_tipo_servico_bancario=@cd_tiposervico   

--        if Len(rtrim(@G025)) <> 2 or @G025 is null or 
--           Len(rtrim(@C006aC010)) <> 5 or @C006aC010 is null or 
--           Len(rtrim(@C026)) <> 1 or @C026 is null or 
--           Len(rtrim(@C027)) <> 2 or @C027 is null 
--		Begin -- 2.0
--		  Raiserror('Variaveis necessarias para gerar a Rotina não encontrada. Informe ao administrador do sistema.',16,1)
--		  RETURN
--		End -- 2.0      

--        if len(rtrim(@nr_cnpj))<14 -- CNPJ não informado
--		Begin -- 2.0.1
--		  Raiserror('CNPJ não informado.',16,1)
--		  RETURN
--		End -- 2.0.1      

--  --      if len(rtrim(@tp_ag))<>5 or @tp_ag_dv = ' ' -- Agencia e Digito
--		--Begin -- 2.0.2
--		--  Raiserror('Agencia deve ter 5 digitos e D. Verificador deve ser informado.',16,1)
--		--  RETURN
--		--End -- 2.0.2      

--        if @carteira is null 
--		Begin -- 2.0.3
--		  Raiserror('Carteira deve ser informado.',16,1)
--		  RETURN
--		End -- 2.0.3    

--        --- Header do Arquivo
--        Set @linha = right('000'+convert(varchar(3),@cd_banco),3) + -- Codigo do Banco
--               '00000' + Space(8) + -- Lote de Servico, Tipo de Registro e Uso Exclusivo FEBRABAN / CNAB
--               '20' + @nr_cnpj + -- CNPJ 
--               '206200000065072' + -- Codigo de Transmissao 
--               SPACE(25) + 
--               convert(char(30),substring(@cedente,1,30)) +  -- Nome do Cedente
--               convert(char(30),substring(@nm_banco,1,30)) +  -- Nome do Banco
--               Space(10) + '1' + replace(convert(varchar(10),getdate(),103),'/','') + Space(6) + -- Data e Hora da Geração do Arquivo
--               right('000000'+convert(varchar(6),@nsa),6) + -- Número sequencial do arquivo (NSA)
--               '040' + Space(74) -- No da Versão do Layout do Arquivo // Densidade de Gravação do Arquivo

--        Set @linha = 'ECHO ' + @linha +  '>> ' + @arquivo 
--		EXEC SP_Shell @linha

--        -- Header do Lote
--        Set @linha =  right('000'+convert(varchar(3),@cd_banco),3) + -- Codigo do Banco
--               '00011R' + -- Lote de Servico, Tipo de Registro, Tipo de Operação
--               @G025 + -- Tipo de Serviço (‘01’ = Cobrança,‘02’ = Cobrança Sem Registro / Serviços,‘03’ = Desconto de Títulos,‘04’ = Caução de Títulos
--               Space(2) + '030' + -- Uso Exclusivo FEBRABAN/CNAB//Nº da Versão do Layout do Lote//Uso Exclusivo FEBRABAN/CNAB//
--               Space(1) + '20' + @nr_cnpj + -- CNPJ
--               Space(20) + 
--               '206200000065072' + -- Uso Exclusivo CAIXA
--               SPACE(5) + 
--               convert(char(30),substring(@cedente,1,30)) +  -- Nome do Cedente
--               Space(80) + -- Mensagem 1//Mensagem 2
--               right('00000000'+convert(varchar(8),@nsa),8) + -- Número sequencial do arquivo (NSA)
--			   replace(convert(varchar(10),getdate(),103),'/','') + -- Data da Geração do Arquivo
--               Space(41) -- Data do Crédito // Uso Exclusivo FEBRABAN/CNAB

--        Set @linha = 'ECHO ' + @linha +  '>> ' + @arquivo 
--  		EXEC SP_Shell @linha

--        Select @erro = 0 , @vl_total = 0 , @qtde=0 
        
--        Set @SQL_C = 'DECLARE cursor_gera_processos_bancos_mens CURSOR FOR '
--		 Set @SQL_C = @SQL_C + ' select m.cd_associado_empresa , m.cd_parcela, m.cd_tipo_pagamento, 		 
--               m.vl_parcela+isnull(m.vl_acrescimo,0)-isnull(m.vl_desconto,0)-isnull(m.vl_imposto,0)+ISNULL(m.vl_taxa,0)+ISNULL(m.VL_JurosMultaReferencia,0)+ISNULL(m.vl_acrescimoavulso,0)-ISNULL(m.VL_DescontoAvulso,0) , 
--               l.dt_vencimento , l.vl_parcela , m.cd_tipo_recebimento , ''1'' as G005,
--               a.nr_cpf ,a.nm_completo as nm_completo,dbo.FF_RemoveCaracterSpecial ( ltrim(Isnull(TL.NOME_TIPO,'''')+'' ''+a.EndLogradouro+'' ''+Case When a.EndNumero is null then '''' When a.endNumero=0 then '''' else convert(varchar(10),a.endnumero) end+'' ''+ISNULL(a.EndComplemento,'''')) ), 
--		        isnull(b.baiDescricao,''''), a.logcep,  isnull(Cid.NM_MUNICIPIO,'''') , isnull(UF.ufSigla,''''), m.nosso_numero
--   		  from Lote_Processos_Bancos_Mensalidades as L, Mensalidades as M, Associados as a  , TB_TIPOLOGRADOURO as TL, Bairro as B, MUNICIPIO as CID, UF 
--		 where L.cd_sequencial_lote = ' + convert(varchar(10),@sequencial) + ' and 
--               l.cd_parcela = m.cd_parcela and 
--               m.cd_Associado_empresa = a.cd_Associado and 
--               m.tp_Associado_empresa = 1  and 
--               a.CHAVE_TIPOLOGRADOURO *= tl.CHAVE_TIPOLOGRADOURO and 
--               a.BaiId*=b.baiId and 
--               a.cidid *= CId.CD_MUNICIPIO and 
--               a.ufId *= Uf.ufId '
--           if @tipo>0    
--              Set @SQL_C = @SQL_C + ' and a.cd_associado ' + case when @tipo=1 then 'not' else '' end + ' in (select distinct cd_Associado from carteiras as c, lote_processos_bancos as l where c.sq_lote = l.cd_sequencial_lote_carteira and l.cd_sequencial = ' + convert(varchar(10),@sequencial) + ') '
  
--         Set @SQL_C = @SQL_C + ' union '
--		Set @SQL_C = @SQL_C + ' select m.cd_associado_empresa , m.cd_parcela, m.cd_tipo_pagamento, 
--               m.vl_parcela+isnull(m.vl_acrescimo,0)-isnull(m.vl_desconto,0)-isnull(m.vl_imposto,0)+ISNULL(m.vl_taxa,0)+ISNULL(m.VL_JurosMultaReferencia,0)+ISNULL(m.vl_acrescimoavulso,0)-ISNULL(m.VL_DescontoAvulso,0) , 
--               l.dt_vencimento , l.vl_parcela , m.cd_tipo_recebimento , ''2'' as G005,
--               a.nr_cgc, a.nm_razsoc as nm_completo,dbo.FF_RemoveCaracterSpecial ( ltrim(Isnull(TL.NOME_TIPO,'''')+'' ''+a.EndLogradouro+'' ''+Case When a.EndNumero is null then '''' When a.endNumero=0 then '''' else convert(varchar(10),a.endnumero) end+'' ''+ISNULL(a.EndComplemento,'''')) ), 
--		        isnull(b.baiDescricao,''''), a.cep,  isnull(Cid.NM_MUNICIPIO,'''') , isnull(UF.ufSigla,''''), m.nosso_numero
--   		  from Lote_Processos_Bancos_Mensalidades as L, Mensalidades as M, empresa as a, TB_TIPOLOGRADOURO as TL, Bairro as B, MUNICIPIO as CID, UF 
--		 where L.cd_sequencial_lote = ' + convert(varchar(10),@sequencial) + ' and 
--               l.cd_parcela = m.cd_parcela and 
--               m.cd_Associado_empresa = a.cd_empresa and 
--               m.tp_Associado_empresa in (2,3) and 
--               a.CHAVE_TIPOLOGRADOURO *= tl.CHAVE_TIPOLOGRADOURO and 
--               a.BaiId*=b.baiId and 
--               a.cd_municipio *= CId.CD_MUNICIPIO and 
--               a.ufId *= Uf.ufId '

--        Set @SQL_C = @SQL_C + ' order by nm_completo, l.dt_vencimento, m.cd_parcela  '
--        print @sql_C
--        exec(@sql_C)

--		OPEN cursor_gera_processos_bancos_mens  
--		FETCH NEXT FROM cursor_gera_processos_bancos_mens INTO @cd_associado_empresa,@cd_parcela ,@cd_tipo_pagamento_M, @vl_parcela_M,@dt_vencimento,@vl_parcela_L,@cd_tipo_recebimento,@G005,@cpf_cnpj ,
--              @nome, @endereco, @bairro, @cep, @cidade, @uf ,@nn

--		WHILE (@@FETCH_STATUS <> -1)  
--		begin  -- 2.2        

--           if @cep is null 
--           begin -- 2.2.0

--              set @erro = 1 
--			  update Lote_Processos_Bancos_Mensalidades 
--                 set mensagem = 'Cep do Associado ('+ convert(varchar(20),@cd_associado_empresa) + ') invalido.'
--               where cd_sequencial_lote = @sequencial and 
--                     cd_parcela = @cd_parcela

--           End -- 2.2.0

--           if @cd_tipo_pagamento_M <> @cd_tipopagamento
--			Begin -- 2.2.1
--              set @erro = 1 
--			  update Lote_Processos_Bancos_Mensalidades 
--                 set mensagem = 'Tipo de Pagamento do Associado ('+ convert(varchar(20),@cd_associado_empresa) + ') invalido.'
--               where cd_sequencial_lote = @sequencial and 
--                     cd_parcela = @cd_parcela
--			End -- 2.2.1

--           if @vl_parcela_M <> @vl_parcela_L
--			Begin -- 2.2.2
--              set @erro = 1 
--			  update Lote_Processos_Bancos_Mensalidades 
--                 set mensagem = 'Parcela do Associado ('+ convert(varchar(20),@cd_associado_empresa) + ') diferente do Gerado.'
--               where cd_sequencial_lote = @sequencial and 
--                     cd_parcela = @cd_parcela
--			End -- 2.2.2

----           if @agencia is null 
----			Begin -- 2.2.3
----              set @erro = 1 
----			  update Lote_Processos_Bancos_Mensalidades 
----                 set mensagem = 'Agencia do Associado ('+ convert(varchar(20),@cd_associado_empresa) + ') não informada.'
----               where cd_sequencial_lote = @sequencial and 
----                     cd_parcela = @cd_parcela
----			End -- 2.2.3

----           if @nr_autorizacao is null 
----			Begin -- 2.2.4
----              set @erro = 1 
----			  update Lote_Processos_Bancos_Mensalidades 
----                 set mensagem = 'Identificador do Associado ('+ convert(varchar(20),@cd_associado_empresa) + ') não informado.'
----               where cd_sequencial_lote = @sequencial and 
----                     cd_parcela = @cd_parcela
----			End -- 2.2.4
 
--           if @cd_tipo_recebimento > 0 
--			Begin -- 2.2.5
--              set @erro = 1 
--			  update Lote_Processos_Bancos_Mensalidades 
--                 set mensagem = 'Associado ('+ convert(varchar(20),@cd_associado_empresa) + ') não encontra-se com a parcela em Aberto.'
--               where cd_sequencial_lote = @sequencial and 
--                     cd_parcela = @cd_parcela
--			End -- 2.2.5

----           if @nr_conta is null or @nr_conta = '' or @nr_conta_DV is null or @nr_conta_DV = ''
----			Begin -- 2.2.6
----              set @erro = 1 
----			  update Lote_Processos_Bancos_Mensalidades 
----                 set mensagem = 'Conta ou Digito Verificador do Associado ('+ convert(varchar(20),@cd_associado_empresa) + ') invalido.'
----               where cd_sequencial_lote = @sequencial and 
----                     cd_parcela = @cd_parcela
----			End -- 2.2.6

----            -- Montar Conta 
----            if @cd_banco = 1 -- Conta (7) + Conta DV (1) - Identificação do cliente no Banco (14 posicoes)
----               set @linha = right('0000000000000'+ convert(varchar(13),@nr_conta),13)+right('0'+convert(varchar(7),@nr_conta_DV),1)
----            else
----               set @linha = right('0000000'+convert(varchar(7),@nr_conta),7) + right('0'+convert(varchar(1),@nr_conta_DV),1) + Space(6)

--           -- Monta Linha

----            if @nr_autorizacao is null -- Nao tem o Numero da Autorizacao
----            Begin -- 2.2.7
----              Set @nr_autorizacao = right('00000000'+convert(varchar(8),@cd_associado_empresa),8)+'00000001'
----              update associados set nr_autorizacao = @nr_autorizacao where cd_Associado = @cd_associado_empresa
----            End -- 2.2.7

----print @vl_parcela_L
----print convert(varchar(15),convert(int,Floor(@vl_parcela_L*100)))


--           --Set @nn = right('000000000000'+@nn,15)
--           --Set @nn = convert(varchar(2),@carteira) + @nn + dbo.FS_CalculoModulo11(convert(varchar(2),@carteira) + @nn,4)

--           Set @vl_total = @vl_total + convert(int,@vl_parcela_L*100)
--           Set @qtde= @qtde + 1 
--          --Registro Detalhe - Segmento P (Obrigatório - Remessa)
--			Set @linha = right('000'+convert(varchar(3),@cd_banco),3) + -- Codigo do Banco
--                         '00013'+ right('00000'+convert(varchar(5),(@qtde-1)*3+1),5)+'P' + -- Lote de Servico, Tipo de Registro, Nº Sequencial do Registro no Lote,Cód. Segmento do Registro Detalhe
--  				         space(1) + '01' +  -- Código de Movimento Remessa
--                         right('00'+@tp_ag,4) + @tp_ag_dv + 
--                         right('000000'+@cta,9) + @dv_cta + -- Agência Mantenedora da Conta // Dígito Verificador da Agência//Código do Convênio no Banco (Conta)
--                         right('000000'+@cta,9) + @dv_cta +
--                         Space(2) + 
--                         right('00000000000000'+convert(varchar(12),@nn),12)  + 
--                         dbo.FS_CalculoModulo11(right('00000000000000'+convert(varchar(12),@nn),12),4) + -- (Nosso Número = Modalidade da Carteira (2) + Nosso Numero
--				         '511'+SPACE(2) + -- Código da Carteira, Forma de Cadastr. do Título no Banco, Tipo de Documento, Identificação da Emissão do Bloqueto, Identificação da Entrega do Bloqueto
--                         right('00000000000'+convert(varchar(11),@cd_parcela),11)  + -- Número do Documento de Cobrança
--				         Space(4) + replace(convert(varchar(10),@dt_vencimento,103),'/','') + -- Data do vencimento (DDMMAAAA)  
--					     right('000000000000000'+Replace(convert(varchar(15),convert(int,Floor(@vl_parcela_L*100))),'.','') ,15) + -- Valor do débito      
--                         '00000' + SPACE(1) + -- Agência Encarregada da Cobrança//Dígito Verificador da Agência
--                         '02N' + -- Espécie do Título//Identificação de Título Aceito / Não Aceito
--                         replace(convert(varchar(10),getdate(),103),'/','') + -- Data da Emissão do Título
--                         '2' + replace(convert(varchar(10),@dt_vencimento,103),'/','') + -- Código do Juros de Mora (1-dia,2-Mes,3-Isento)//Data do Juros de Mora//Juros de Mora por Dia 
--                         right('000000000000000'+replace(convert(varchar(15),convert(int,case when floor(@vl_parcela_L*@juros/30)=0 then 1 else floor(@vl_parcela_L*@juros/30) end)),'.',''),15)  + -- Taxa (se dia=informar valor, se mes=informar tx)
--                         '000000000000000000000000' + -- Código do Desconto 1//Data do Desconto 1//Valor/Percentual a ser Concedido
--                         '000000000000000' + '000000000000000' + -- Valor do IOF a ser Recolhido//Valor do Abatimento
--                         right('000000000000000000000000000000'+convert(varchar(10),@cd_parcela),25) + -- Identificação do Título na Empresa
--                         '3001' + '0' + '29' + --Código para Protesto//Número de Dias para Protesto//Código para Baixa/Devolução//Número de Dias para Baixa/Devolução
--                         '00' + -- Código da Moeda
--                         space(11) 

--           print  @linha     -- P
                          
--           if @Linha is null or @Linha = '' 
--			Begin -- 2.2.6
--              set @erro = 1 
--			  update Lote_Processos_Bancos_Mensalidades 
--                 set mensagem = 'Linha ('+ convert(varchar(20),@cd_associado_empresa) + 'P) invalida.'
--               where cd_sequencial_lote = @sequencial and 
--                     cd_parcela = @cd_parcela
--			End -- 2.2.6
           
--		   Set @linha = 'ECHO ' + @linha +  '>> ' + @arquivo 
-- 		   EXEC SP_Shell @linha

--           -- Registro Detalhe - Segmento Q (Obrigatório - Remessa)
--			Set @linha = right('000'+convert(varchar(3),@cd_banco),3) + -- Codigo do Banco
--                         '00013'+ right('00000'+convert(varchar(5),(@qtde-1)*3+2),5)+'Q' + -- Lote de Servico, Tipo de Registro, Nº Sequencial do Registro no Lote,Cód. Segmento do Registro Detalhe
--  				         space(1) + '01' +  -- Código de Movimento Remessa -- @nr_cnpj
--  				         '2' + right('000000000000000'+@nr_cnpj,15)  + -- Tipo de Inscrição (1-PF,2-PJ) // Número de Inscrição (cpf/cnpj)
--                         --@G005 + right('000000000000000'+@cpf_cnpj,15)  + -- Tipo de Inscrição (1-PF,2-PJ) // Número de Inscrição (cpf/cnpj)
--                        --@G005 + right('000000000000000'+convert(varchar(20),@cd_associado_empresa),15)  + -- Tipo de Inscrição (1-PF,2-PJ) // Número de Inscrição (cpf/cnpj)
--                         substring(@nome+Space(40),1,40) + substring(@endereco+Space(40),1,40) + substring(@bairro+Space(15),1,15) + 
--                         substring(@cep+space(5),1,5) + right('000'+@cep,3) + substring(@cidade+Space(15),1,15) + substring(@uf+space(2),1,2) + 
--                        -- '0000000000000000' + space(40) + '000' + Space(28) -- Sacados
--                         @G005 + right('000000000000000'+@cpf_cnpj,15) + substring(@nome+Space(80),41,40) + 
--                         '000000000000' + Space(19) -- Sacados

--           print  @linha -- Q

--           if @Linha is null or @Linha = '' 
--			Begin -- 2.2.7
--              set @erro = 1 
--			  update Lote_Processos_Bancos_Mensalidades 
--                 set mensagem = 'Linha ('+ convert(varchar(20),@cd_associado_empresa) + 'Q) invalida.'
--               where cd_sequencial_lote = @sequencial and 
--                     cd_parcela = @cd_parcela
--			End -- 2.2.7

--		   Set @linha = 'ECHO ' + @linha +  '>> ' + @arquivo 
-- 		   EXEC SP_Shell @linha

--         -- Registro Detalhe - Segmento R (Obrigatório - Remessa)
--			Set @linha = right('000'+convert(varchar(3),@cd_banco),3) + -- Codigo do Banco
--                         '00013'+ right('00000'+convert(varchar(5),(@qtde-1)*3+3),5)+'R' + -- Lote de Servico, Tipo de Registro, Nº Sequencial do Registro no Lote,Cód. Segmento do Registro Detalhe
--  				         space(1) + '01' +  -- Código de Movimento Remessa
--                         '000000000' + '000000000000000' + -- Tipo de Inscrição (1-PF,2-PJ) // Número de Inscrição (cpf/cnpj)
--                         Space(24) + 
--                         '2' + replace(convert(varchar(10),@dt_vencimento,103),'/','') + 
--                         right('000000000000000'+replace(convert(varchar(15),convert(int,case when round(@vl_parcela_L*@multa,2)=0 then 1 else round(@vl_parcela_L*@multa,2) end)),'.',''),15) + 
--                         SPACE(10) + 'APOS O VENCIMENTO PAGAR NA REDE SANTANDER COBRAR MULTA DE 2%  E JUROS DE MORA DE'+SPACE(61) 

--           print  @linha -- R

--           if @Linha is null or @Linha = '' 
--			Begin -- 2.2.7
--              set @erro = 1 
--			  update Lote_Processos_Bancos_Mensalidades 
--                 set mensagem = 'Linha ('+ convert(varchar(20),@cd_associado_empresa) + 'R) invalida.'
--               where cd_sequencial_lote = @sequencial and 
--                     cd_parcela = @cd_parcela
--			End -- 2.2.7

--		   Set @linha = 'ECHO ' + @linha +  '>> ' + @arquivo 
-- 		   EXEC SP_Shell @linha 		   
                         
--            -- Barra e Linha digitavel             
--		   Set @nn = right('00000000000000'+convert(varchar(12),@nn),12)
                     
           
--		   Set @nn = @nn + dbo.FS_CalculoModulo11(right('00000000000000'+convert(varchar(12),@nn),12),4)

--		   Set @CampoLivre = '9'+right('00000'+@convenio,7)+@nn+'0'+right('000'+convert(varchar(10),@carteira),3)
--		   Set @CampoLivre = @CampoLivre +  dbo.FS_CalculoModulo11(@CampoLivre,3)
		   	
--		   Set @codbarras = right('00'+convert(varchar(3),@cd_banco),3)+ '9' + convert(varchar(4),DATEDIFF(day,'10/07/1997',@dt_vencimento)) + -- Fator de Vencimento
--			   right('00000000000'+Replace(convert(varchar(12),convert(int,Floor((@vl_parcela_M+@taxa)*100))),'.',''),10) + -- Valor da Parcela 
--			   @CampoLivre

--print '---'
--			print @CampoLivre
--			print @codbarras
--			print Len(@codbarras)
--			print dbo.FS_DigitoVerificarCodigoBarras(@codbarras)
--print '---'
            
--			Set @codbarras = left(@codbarras,4) + dbo.FS_DigitoVerificarCodigoBarras(@codbarras) + right(@codbarras,39)
			 
--			Set @linhaDig1 = left(@codbarras,4) + left(@CampoLivre,5) 
--			Set @linhaDig1 = left(@linhaDig1,5) + '.' + right(@linhaDig1,4) + dbo.FS_CalculoModulo10(@linhaDig1) 
            
--			Set @linhaDig2 = substring(@CampoLivre,6,10) 
--			Set @linhaDig2 = left(@linhaDig2,5) + '.' + right(@linhaDig2,5) + dbo.FS_CalculoModulo10(@linhaDig2) 

--			Set @linhaDig3 = substring(@CampoLivre,16,10) 
--			Set @linhaDig3 = left(@linhaDig3,5) + '.' + right(@linhaDig3,5) + dbo.FS_CalculoModulo10(@linhaDig3) 

--			Set @linhaDig4 = substring(@codbarras,5,1)

--			Set @linhaDig5 = substring(@codbarras,6,14)

--			Set @linha = @linha + @linhaDig1 + ' ' + @linhaDig2 + ' ' + @linhaDig3 + ' ' + @linhaDig4 + ' ' + @linhaDig5 + 
--			    @codbarras
	              
--		   print @linhaDig1
--           print @linhaDig2
--           print @linhaDig3
--           print @linhaDig4
--           print @linhaDig5 
                                                      
--			--Gravar Boleto ---		   
--           insert Boleto (cd_sequencial_lote,cd_associado_empresa,cd_parcela,cedente,cnpj,
--             dt_vencimento,agencia,dg_ag,conta,dg_conta,convenio,dg_convenio,carteira,
--             nn,valor,pagador,cpf_cnpj_pagador,end_pagador,bai_pagador,cep_pagador,mun_pagador,
--             uf_pagador,vl_multa,vl_juros,instrucao1,instrucao2,instrucao3,instrucao4,linha,barra,cod_barra,fl_lotebanco)
             
--           values (@sequencial,@cd_associado_empresa,@cd_parcela,@cedente,@nr_cnpj,
--           CONVERT(varchar(10),@dt_vencimento,103),@agencia,@dv_ag,@cta,@dv_cta, @convenio,@convenio_dv,@carteira,
--           @nn,@vl_parcela_L,@nome,@cpf_cnpj, @endereco, @bairro, @cep, @cidade, @uf, 
--           round(@vl_parcela_L*@multa/100*100,0)/100, round(@vl_parcela_L*@juros/100/30*100,0)/100,
--           @instrucao1, @instrucao2, @instrucao3, @instrucao4, @linhaDig1 + ' ' + @linhaDig2 + ' ' + @linhaDig3 + ' ' + @linhaDig4 + ' ' + @linhaDig5, 
--           @codbarras, dbo.FG_TRADUZ_Codbarras(@codbarras),1) 
--             -------------------------------------------------
              
--           if @@ROWCOUNT = 0 
--			Begin -- 3.2.6
--              set @erro = 1 
--			  update Lote_Processos_Bancos_Mensalidades 
--                 set mensagem = 'Linha ('+ convert(varchar(20),@cd_associado_empresa) + 'B) invalida.'
--               where cd_sequencial_lote = @sequencial and 
--                     cd_parcela = @cd_parcela
--			End -- 3.2.6

-- 		   FETCH NEXT FROM cursor_gera_processos_bancos_mens INTO @cd_associado_empresa,@cd_parcela ,@cd_tipo_pagamento_M, @vl_parcela_M,@dt_vencimento,@vl_parcela_L,@cd_tipo_recebimento,@G005,@cpf_cnpj ,
--                  @nome, @endereco, @bairro, @cep, @cidade, @uf ,@nn

--        end -- 2.2
--        Close cursor_gera_processos_bancos_mens
--        Deallocate cursor_gera_processos_bancos_mens

--        -- Registro Trailer de Lote
--        Set @linha = right('000'+convert(varchar(3),@cd_banco),3) + -- banco
--                     '00015' + Space(9) +  -- Lote de Serviço//Tipo de Registro//Uso Exclusivo FEBRABAN/CNAB
--                     right('000000'+convert(varchar(6),(@qtde*3)+2),6) + -- Quantidade de Registros no Lote
--                     SPACE(217)
                     
--                     --right('000000'+convert(char(6),@qtde),6) + -- Quantidade de Títulos em Cobrança
--                     --right('00000000000000000'+convert(char(17),@vl_total),17) + -- Valor total dos registros do arquivo
--                     --'000000' + '00000000000000000' + -- Totalização da Cobrança Caucionada 
--                     --'000000' + '00000000000000000' + -- Totalização da Cobrança Descontada
--                     --Space(31) + Space(117)
--        Set @linha = 'ECHO ' + @linha +  '>> ' + @arquivo 
--		EXEC SP_Shell @linha

--        -- Escrever Trailler
--        Set @linha = right('000'+convert(varchar(3),@cd_banco),3) + -- banco
--                     '99999' + Space(9) +  -- Lote de Serviço//Tipo de Registro//Uso Exclusivo FEBRABAN/CNAB//
--                     '000001' + right('000000'+convert(varchar(6),(@qtde*3)+4),6) + -- Quantidade de Lotes do Arquivo//Quantidade de Registros no arquivo
--                     Space(6) + Space(205)

--        Set @linha = 'ECHO ' + @linha +  '>> ' + @arquivo 
--		EXEC SP_Shell @linha

--   End -- 2
--/**************** FIM BOLETO BANCARIO santander pj***********************/


/****************BOLETO BANCARIO CNAB400 ITAU***********************/
if @cd_tiposervico IN (9) -- CNAB 400
    Begin -- 4

        delete boleto where cd_sequencial_lote = @sequencial
        
        if (@convenio is null or LEN(@convenio)<>5) 
		Begin -- 4.0.3
		  Raiserror('Convenio deve ser informado com 5 digitos.',16,1)
		  RETURN
		End -- 4.0.3    

        Select @erro = 0 , @vl_total = 0 , @qtde=0 

        --- Header
        Set @linha = '01REMESSA01' + LEFT('COBRANCA'+SPACE(15),15) +         
			   right('0000'+@tp_ag,4) + '00' +
			   right('00000'+@cta,5) + @dv_cta + 
			   SPACE(8) +
			   convert(char(30),substring(@cedente,1,30)) + -- Nome do Cedente
			   right('000'+convert(varchar(3),@cd_banco),3) + -- Codigo do Banco
			   convert(char(15),substring(@nm_banco,1,15)) +  -- Nome do Banco
               replace(convert(varchar(8),getdate(),3),'/','') + -- Data de geração do arquivo (DDMMAA)
              -- SPACE(8) + 'MX' + 
               --right('000000'+convert(varchar(7),@nsa),7) + -- Número sequencial do arquivo (NSA)
               Space(294)+'000001' 
        Set @linha = 'ECHO ' + @linha + '>> ' + @arquivo 
		EXEC SP_Shell @linha  
		     

		DECLARE cursor_gera_processos_bancos_mens CURSOR FOR  
		select m.cd_associado_empresa , m.cd_parcela, m.cd_tipo_pagamento, 
               m.vl_parcela+isnull(m.vl_acrescimo,0)-isnull(m.vl_desconto,0)-isnull(m.vl_imposto,0) , 
			   l.dt_vencimento as dt_vencimento , l.vl_parcela , m.cd_tipo_recebimento , 
               a.nr_cpf ,
               dbo.FF_RemoveCaracterSpecial(dbo.FF_TiraAcento(a.nm_completo)), 
               dbo.FF_RemoveCaracterSpecial(dbo.FF_TiraAcento( case when len(isnull(a.endBoleto,''))>5 then a.endBoleto else ltrim(Isnull(TL.NOME_TIPO,'')+' '+a.EndLogradouro+' '+Case When a.EndNumero is null then '' When a.endNumero=0 then '' else convert(varchar(10),a.endnumero) end+' '+ISNULL(a.EndComplemento,''))  end )) , 
		       dbo.FF_RemoveCaracterSpecial(dbo.FF_TiraAcento(isnull(b.baiDescricao,''))), a.logcep,  
		       dbo.FF_RemoveCaracterSpecial(dbo.FF_TiraAcento(isnull(Cid.NM_MUNICIPIO,''))) , 
		       dbo.FF_RemoveCaracterSpecial(dbo.FF_TiraAcento(isnull(UF.ufSigla,''))),  
		       m.nosso_numero, 
		       case when isnull(a.taxa_cobranca,1) = 1 then m.vl_taxa else 0 end 
   		  from Lote_Processos_Bancos_Mensalidades as L, Mensalidades as M, Associados as a  , TB_TIPOLOGRADOURO as TL, Bairro as B, MUNICIPIO as CID, UF 
		 where L.cd_sequencial_lote = @sequencial and 
               l.cd_parcela = m.cd_parcela and 
               m.cd_Associado_empresa = a.cd_Associado and 
               m.tp_Associado_empresa = 1  and 
               a.CHAVE_TIPOLOGRADOURO *= tl.CHAVE_TIPOLOGRADOURO and 
               a.BaiId*=b.baiId and 
               a.cidid *= CId.CD_MUNICIPIO and 
               a.ufId *= Uf.ufId 
         union 
		select m.cd_associado_empresa , m.cd_parcela, m.cd_tipo_pagamento, 
               m.vl_parcela+isnull(m.vl_acrescimo,0)-isnull(m.vl_desconto,0)-isnull(m.vl_imposto,0) , 
               l.dt_vencimento , l.vl_parcela , m.cd_tipo_recebimento ,
               a.nr_cgc, 
               dbo.FF_RemoveCaracterSpecial(dbo.FF_TiraAcento(a.nm_razsoc)) , 
               dbo.FF_RemoveCaracterSpecial(dbo.FF_TiraAcento(ltrim(Isnull(TL.NOME_TIPO,'')+' '+a.endLogradouro+' '+Case When a.EndNumero is null then '' When a.endNumero=0 then '' else convert(varchar(10),a.endnumero) end+' '+ISNULL(a.EndComplemento,'')))) , 
	           dbo.FF_RemoveCaracterSpecial(dbo.FF_TiraAcento(isnull(b.baiDescricao,''))), 
	           a.cep,  
	           dbo.FF_RemoveCaracterSpecial(dbo.FF_TiraAcento(isnull(Cid.NM_MUNICIPIO,''))) , 
	           dbo.FF_RemoveCaracterSpecial(dbo.FF_TiraAcento(isnull(UF.ufSigla,''))) , 
	           m.nosso_numero, 0 
   		  from Lote_Processos_Bancos_Mensalidades as L, Mensalidades as M, empresa as a, TB_TIPOLOGRADOURO as TL, Bairro as B, MUNICIPIO as CID, UF 
		 where L.cd_sequencial_lote = @sequencial and 
               l.cd_parcela = m.cd_parcela and 
               m.cd_Associado_empresa = a.cd_empresa and 
               m.tp_Associado_empresa in (2,3) and 
               a.CHAVE_TIPOLOGRADOURO *= tl.CHAVE_TIPOLOGRADOURO and 
               a.BaiId*=b.baiId and 
               a.cd_municipio *= CId.CD_MUNICIPIO and 
               a.ufId *= Uf.ufId 
         order by m.cd_parcela       
		OPEN cursor_gera_processos_bancos_mens  
		FETCH NEXT FROM cursor_gera_processos_bancos_mens INTO @cd_associado_empresa,@cd_parcela ,@cd_tipo_pagamento_M, @vl_parcela_M,@dt_vencimento,
		      @vl_parcela_L,@cd_tipo_recebimento,@cpf_cnpj ,@nome, @endereco, @bairro, @cep, @cidade, @uf ,@nn,@taxa

		WHILE (@@FETCH_STATUS <> -1)  
		begin  -- 4.2        

           set @dt_vencimento_parc = @dt_vencimento
           
           if @cep is null 
           begin -- 4.2.0

              set @erro = 1 
			  update Lote_Processos_Bancos_Mensalidades 
                 set mensagem = 'Cep do Associado ('+ convert(varchar(20),@cd_associado_empresa) + ') invalido.'
               where cd_sequencial_lote = @sequencial and 
                     cd_parcela = @cd_parcela

           End -- 4.2.0

           if @cd_tipo_pagamento_M <> @cd_tipopagamento
			Begin -- 4.2.1
              set @erro = 1 
			  update Lote_Processos_Bancos_Mensalidades 
                 set mensagem = 'Tipo de Pagamento do Associado ('+ convert(varchar(20),@cd_associado_empresa) + ') invalido.'
               where cd_sequencial_lote = @sequencial and 
                     cd_parcela = @cd_parcela
			End -- 4.2.1

   --        if @vl_parcela_M <> @vl_parcela_L
			--Begin -- 4.2.2
   --           set @erro = 1 
			--  update Lote_Processos_Bancos_Mensalidades 
   --              set mensagem = 'Parcela do Associado ('+ convert(varchar(20),@cd_associado_empresa) + ') diferente do Gerado.'
   --            where cd_sequencial_lote = @sequencial and 
   --                  cd_parcela = @cd_parcela
			--End -- 4.2.2

           if @cd_tipo_recebimento > 0 
			Begin -- 4.2.5
              set @erro = 1 
			  update Lote_Processos_Bancos_Mensalidades 
                 set mensagem = 'Associado ('+ convert(varchar(20),@cd_associado_empresa) + ') não encontra-se com a parcela em Aberto.'
               where cd_sequencial_lote = @sequencial and 
                     cd_parcela = @cd_parcela
			End -- 4.2.5


           Set @vl_total = @vl_total + convert(int,@vl_parcela_L*100)
           Set @qtde= @qtde + 1 
           
			Set @linha = '102' + -- TIPO DE REGISTRO + CÓDIGO DE INSCRIÇÃO
				right('00000000000000'+convert(varchar(14),@nr_cnpj),14)  + -- NÚMERO DE INSCRIÇÃO
				RIGHT('0000'+convert(varchar(4),@tp_ag),4) + '00'  + -- AGÊNCIA + ZEROS
				RIGHT('00000'+convert(varchar(5),@cta),5) + right('0'+convert(varchar(10),@dv_cta),1) + SPACE(4) + -- CONTA + DAC + BRANCOS
				'0000' + --NSTRUÇÃO/ALEGAÇÃO
				
				Right('000000000000000'+convert(varchar(30),@cd_associado_empresa),15) + right('0000000000'+convert(varchar(30),@cd_parcela),10) + --Identificação do titulo na EMpresa
				
				right('0000000000'+convert(varchar(30),@cd_parcela),8) + -- NOSSO NÚMERO
				'0000000000000' + -- QTDE DE MOEDA
				RIGHT('000'+convert(varchar(3),@carteira),3) + SPACE(21) + 'I01' + -- Nº DA CARTEIRA,USO DO BANCO,CARTEIRA,OCORRENCIA
				
				right('0000000000'+convert(varchar(10),@cd_parcela),10) + -- Nº DO DOCUMENTO
				replace(convert(varchar(8),@dt_vencimento,3),'/','') + -- VENCIMENTO
				right('000000000000000'+convert(varchar(15),convert(int,Floor(@vl_parcela_L*100))),13) + -- Valor do débito  
				right('000'+convert(varchar(3),@cd_banco),3) + '00000' + '01N' +-- Codigo do Banco + AGÊNCIA COBRADORA + ESPÉCIE + ACEITE
				replace(convert(varchar(8),GETDATE(),3),'/','') + -- DATA DE EMISSÃO
				'2'+SPACE (1)+'3'+SPACE (1)+ -- INSTRUÇÃO 1, INSTRUÇÃO 2
			--	right('000000000000000'+replace(convert(varchar(15),case when round(convert(float,@vl_parcela_L)*@juros/100/30,2)=0 then 1 else round(convert(float,@vl_parcela_L)*@juros/100/30,2) end),'.',''),13) + 
			    right('000000000000000'+dbo.FF_Formatanumerobanco(convert(varchar(13),round(convert(float,@vl_parcela_L)*@juros/100/30,2))),13) + 
				'000000' + '0000000000000' + '0000000000000' + '0000000000000' + -- DESCONTO ATÉ, VALOR DO DESCONTO, VALOR DO I.O.F.,ABATIMENTO
				case when LEN(@cpf_cnpj)>11 then '02' else '01' end + RIGHT('00000000000000'+@cpf_cnpj,14) + -- CÓDIGO DE INSCRIÇÃO, NÚMERO DE INSCRIÇÃO
				left(replace(replace(@nome,'&',''),'''','')+space(40),40)+ -- NOME, BRANCOS
				left(replace(replace(@endereco,'&',''),'''','')+SPACE(40),40)+
				left(replace(replace(@bairro,'&',''),'''','')+SPACE(12),12)+
				right('00000000'+@cep,8)+				
				left(replace(replace(@cidade,'&',''),'''','')+SPACE(15),15)+
				left(@uf+SPACE(2),2)+SPACE(30)+SPACE(4)+'00000030' + ' ' +
				RIGHT('000000'+convert(varchar(6),@qtde+1),6)
		   
		   print @linha
							    
           if @Linha is null or @Linha = '' 
			Begin -- 2.2.6
              set @erro = 1 
			  update Lote_Processos_Bancos_Mensalidades 
                 set mensagem = 'Linha ('+ convert(varchar(20),@cd_associado_empresa) + ') invalida.'
               where cd_sequencial_lote = @sequencial and 
                     cd_parcela = @cd_parcela
			End -- 2.2.6
			
 		   Set @linha = 'ECHO ' + @linha + '>> ' + @arquivo 
		   EXEC SP_Shell @linha

           -- Campo livre bradesco
           -- 20 a 23 - Agência Cedente (Sem o digito verificador, completar com zeros a esquerda quando necessário)
		   -- 24 a 25 - Carteira
		   -- 26 a 36 - 11 - Número do Nosso Número(Sem o digito verificador)
		   -- 37 a 43 - 7  - Conta do Cedente (Sem o digito verificador,completar com zeros a esquerda quando necessário)
		   -- 44 a 44 1 Zero
		   
  		   
                    
		FETCH NEXT FROM cursor_gera_processos_bancos_mens INTO @cd_associado_empresa,@cd_parcela ,@cd_tipo_pagamento_M, @vl_parcela_M,@dt_vencimento,
		      @vl_parcela_L,@cd_tipo_recebimento,@cpf_cnpj ,@nome, @endereco, @bairro, @cep, @cidade, @uf ,@nn,@taxa

        end -- 3.2
        Close cursor_gera_processos_bancos_mens
        Deallocate cursor_gera_processos_bancos_mens

        --- Header
        Set @linha = '9' + SPACE(393)+RIGHT('000000'+convert(varchar(6),@qtde+2),6)
        Set @linha = 'ECHO ' + @linha +  '>> ' + @arquivo 
		EXEC SP_Shell @linha       

   End -- 4
/**************Fim BOLETO BANCARIO CNAB400 ITAU**********************/


--if @cd_tiposervico = 21 and @cd_tipopagamento = 53 
--    Begin -- 4

--        delete boleto where cd_sequencial_lote = @sequencial
        
--        if (@convenio is null or LEN(@convenio)<>5) 
--		Begin -- 4.0.3
--		  Raiserror('Convenio deve ser informado com 5 digitos.',16,1)
--		  RETURN
--		End -- 4.0.3    

--        Select @erro = 0 , @vl_total = 0 , @qtde=0 

--        --- HEADER
--        Set @linha = '01REMESSA01' + LEFT('COBRANCA'+SPACE(15),15) + '0' +
--			   right('000000000000',12) +	--Código de transmissão
--			   SPACE(7) +	--Brancos
--			   convert(char(30),substring(@cedente,1,30)) +	--Nome do Cedente
--			   right('000'+convert(varchar(3),@cd_banco),3) +	--Identif. do Banco
--			   convert(char(15),substring(@nm_banco,1,15)) +	-- Nome do Banco
--			   left(replace(convert(varchar(8),getdate(),3),'/',''),6) + --Data do Processamento
--			   '01600BPI' +	--Constante
--			   SPACE(286) + '000001'
			   
			   
--        Set @linha = 'ECHO ' + @linha + '>> ' + @arquivo 
--		EXEC SP_Shell @linha  
--		--- FIM HEADER    
		     
		     
		     

--		DECLARE cursor_gera_processos_bancos_mens CURSOR FOR  
--		select m.cd_associado_empresa , m.cd_parcela, m.cd_tipo_pagamento, 
--               m.vl_parcela+isnull(m.vl_acrescimo,0)-isnull(m.vl_desconto,0)-isnull(m.vl_imposto,0) , 
--			   m.dt_vencimento as dt_vencimento , l.vl_parcela , m.cd_tipo_recebimento , 
--               a.nr_cpf ,
--               dbo.FF_RemoveCaracterSpecial(dbo.FF_TiraAcento(a.nm_completo)), 
--               dbo.FF_RemoveCaracterSpecial(dbo.FF_TiraAcento(ltrim(Isnull(TL.NOME_TIPO,'')+' '+a.EndLogradouro+' '+Case When a.EndNumero is null then '' When a.endNumero=0 then '' else convert(varchar(10),a.endnumero) end+' '+ISNULL(a.EndComplemento,'')))) , 
--		       dbo.FF_RemoveCaracterSpecial(dbo.FF_TiraAcento(isnull(b.baiDescricao,''))), a.logcep,  
--		       dbo.FF_RemoveCaracterSpecial(dbo.FF_TiraAcento(isnull(Cid.NM_MUNICIPIO,''))) , 
--		       dbo.FF_RemoveCaracterSpecial(dbo.FF_TiraAcento(isnull(UF.ufSigla,''))),  
--		       m.nosso_numero, 
--		       case when isnull(a.taxa_cobranca,1) = 1 then m.vl_taxa else 0 end
		       
--   		  from Lote_Processos_Bancos_Mensalidades as L, Mensalidades as M, Associados as a  , TB_TIPOLOGRADOURO as TL, Bairro as B, MUNICIPIO as CID, UF 
--		 where L.cd_sequencial_lote = @sequencial and 
--               l.cd_parcela = m.cd_parcela and 
--               m.cd_Associado_empresa = a.cd_Associado and 
--               m.tp_Associado_empresa = 1  and 
--               a.CHAVE_TIPOLOGRADOURO *= tl.CHAVE_TIPOLOGRADOURO and 
--               a.BaiId*=b.baiId and 
--               a.cidid *= CId.CD_MUNICIPIO and 
--               a.ufId *= Uf.ufId 
--         union 
--		select m.cd_associado_empresa , m.cd_parcela, m.cd_tipo_pagamento, 
--               m.vl_parcela+isnull(m.vl_acrescimo,0)-isnull(m.vl_desconto,0)-isnull(m.vl_imposto,0) , 
--               m.dt_vencimento , l.vl_parcela , m.cd_tipo_recebimento ,
--               a.nr_cgc, 
--               dbo.FF_RemoveCaracterSpecial(dbo.FF_TiraAcento(a.nm_razsoc)) , 
--               dbo.FF_RemoveCaracterSpecial(dbo.FF_TiraAcento(ltrim(Isnull(TL.NOME_TIPO,'')+' '+a.EndLogradouro+' '+Case When a.EndNumero is null then '' When a.endNumero=0 then '' else convert(varchar(10),a.endnumero) end+' '+ISNULL(a.EndComplemento,'')))) , 
--	           dbo.FF_RemoveCaracterSpecial(dbo.FF_TiraAcento(isnull(b.baiDescricao,''))), 
--	           a.cep,  
--	           dbo.FF_RemoveCaracterSpecial(dbo.FF_TiraAcento(isnull(Cid.NM_MUNICIPIO,''))) , 
--	           dbo.FF_RemoveCaracterSpecial(dbo.FF_TiraAcento(isnull(UF.ufSigla,''))) , 
--	           m.nosso_numero, 0 
--   		  from Lote_Processos_Bancos_Mensalidades as L, Mensalidades as M, empresa as a, TB_TIPOLOGRADOURO as TL, Bairro as B, MUNICIPIO as CID, UF 
--		 where L.cd_sequencial_lote = @sequencial and 
--               l.cd_parcela = m.cd_parcela and 
--               m.cd_Associado_empresa = a.cd_empresa and 
--               m.tp_Associado_empresa in (2,3) and 
--               a.CHAVE_TIPOLOGRADOURO *= tl.CHAVE_TIPOLOGRADOURO and 
--               a.BaiId*=b.baiId and 
--               a.cd_municipio *= CId.CD_MUNICIPIO and 
--               a.ufId *= Uf.ufId 
--         order by m.cd_parcela       
--		OPEN cursor_gera_processos_bancos_mens  
--		FETCH NEXT FROM cursor_gera_processos_bancos_mens INTO @cd_associado_empresa,@cd_parcela ,@cd_tipo_pagamento_M, @vl_parcela_M,@dt_vencimento,
--		      @vl_parcela_L,@cd_tipo_recebimento,@cpf_cnpj ,@nome, @endereco, @bairro, @cep, @cidade, @uf ,@nn,@taxa

--		WHILE (@@FETCH_STATUS <> -1)  
--		begin  -- 4.2        

--			if @nn = '' or @nn is null
--            begin
--               Set @nn = right('0000000'+@cd_parcela,7)
--               Set @nn = @nn + dbo.FS_CalculoModulo11(@nn,0)
               
--               update mensalidades set nosso_numero = @nn where CD_PARCELA = @cd_parcela
--            End 
            
            
            
--           set @dt_vencimento_parc = @dt_vencimento
           
--           if @cep is null 
--           begin -- 4.2.0

--              set @erro = 1 
--			  update Lote_Processos_Bancos_Mensalidades 
--                 set mensagem = 'Cep do Associado ('+ convert(varchar(20),@cd_associado_empresa) + ') invalido.'
--               where cd_sequencial_lote = @sequencial and 
--                     cd_parcela = @cd_parcela

--           End -- 4.2.0
			
--           if @cd_tipo_pagamento_M <> @cd_tipopagamento
--			Begin -- 4.2.1
--              set @erro = 1 
--			  update Lote_Processos_Bancos_Mensalidades 
--                 set mensagem = 'Tipo de Pagamento do Associado ('+ convert(varchar(20),@cd_associado_empresa) + ') invalido.'
--               where cd_sequencial_lote = @sequencial and 
--                     cd_parcela = @cd_parcela
--			End -- 4.2.1

--           if @vl_parcela_M <> @vl_parcela_L
--			Begin -- 4.2.2
--              set @erro = 1 
--			  update Lote_Processos_Bancos_Mensalidades 
--                 set mensagem = 'Parcela do Associado ('+ convert(varchar(20),@cd_associado_empresa) + ') diferente do Gerado.'
--               where cd_sequencial_lote = @sequencial and 
--                     cd_parcela = @cd_parcela
--			End -- 4.2.2
			

--           if @cd_tipo_recebimento > 0 
--			Begin -- 4.2.5
--              set @erro = 1 
--			  update Lote_Processos_Bancos_Mensalidades 
--                 set mensagem = 'Associado ('+ convert(varchar(20),@cd_associado_empresa) + ') não encontra-se com a parcela em Aberto.'
--               where cd_sequencial_lote = @sequencial and 
--                     cd_parcela = @cd_parcela
--			End -- 4.2.5


--           Set @vl_total = @vl_total + convert(int,@vl_parcela_L*100)
--           Set @qtde= @qtde + 1 
           
--			Set @linha = '102' + -- TIPO DE REGISTRO + CÓDIGO DE INSCRIÇÃO
--				right('00000000000000'+convert(varchar(14),@nr_cnpj),14)  + -- NÚMERO DE INSCRIÇÃO
--				'0' +
--				RIGHT('0000'+convert(varchar(4),@tp_ag),4) + '0'  + -- AGÊNCIA + ZERO
--				RIGHT('0000000'+convert(varchar(7),@convenio),7)  + SPACE(8) + -- CONVENIO + BRANCOS
--				Right('000000000000000'+convert(varchar(30),@cd_associado_empresa),15) + right('0000000000'+convert(varchar(30),@cd_parcela),10) + --Controle do participante - Identificação do titulo na EMpresa
--				'00' +
--				right('0000000'+convert(varchar(30),@cd_parcela),7) +	-- Num. do Título no Banco - NOSSO NÚMERO
--				'0' + -- Incidência da Multa - '0' Sobre o valor Título   '1' Sobre o valor Corrigido
--				'00' + -- Dias para Multa '00' - Após Vencimento  '01-99' - Número de Dias Após Vencimento
--				'0' + -- Tipo da Multa '0' - Valor  '1' - Taxa
--				right('0000000000000' + convert(varchar(13),@multa * 100),13) + -- Multa
--				SPACE(7) + '000000000' + SPACE(1) + '00' + '1' + '01' + -- Brancos(7) + Zeros(9) + Brancos(1) + Zeros(2) + Uso do Branco + Ocorrencia
--				right('0000000000'+convert(varchar(30),@cd_parcela),10) +	-- Número do Título no Cedente - SEU NÚMERO
--				left(replace(convert(varchar(8),@dt_vencimento,3),'/',''),6) + -- VENCIMENTO
--				right('000000000000000'+convert(varchar(15),convert(int,Floor(@vl_parcela_L*100))),13) + -- Valor do débito
--				right('000'+convert(varchar(3),@cd_banco),3) + '00000' + '99N' +-- Codigo do Banco + AGÊNCIA COBRADORA + ESPÉCIE + ACEITE
--				left(replace(convert(varchar(8),GETDATE(),3),'/',''),6) + -- DATA DE EMISSÃO
--				--right('00' + CONVERT(varchar(2), @diasprotesto),2) + SPACE(2) + --- Código do Protesto + Brancos(2)
--				'99' + SPACE(2) + --- Código do Protesto(99 Nao protestar) + Brancos(2)
--				'0' + --Tipo de Juros - '0' - Valor '1' - Taxa
--				right('000000000000' + replace(convert(varchar(5),round(@vl_parcela_L*@juros/100/30*100,0)/100),'.',''), 12) + -- Juros de 1dia
--				'000000' + '0000000000000' + '0000000000000' + '0000000000000' + -- DESCONTO ATÉ, VALOR DO DESCONTO, VALOR DO I.O.F.,ABATIMENTO
--				case when LEN(@cpf_cnpj)>11 then '02'+ RIGHT('00000000000000'+@cpf_cnpj,14) 
--				else '01' + LEFT(@cpf_cnpj,9) + '000' + right(@cpf_cnpj,2) end  + -- CÓDIGO DE INSCRIÇÃO, NÚMERO DE INSCRIÇÃO
--				left(replace(replace(@nome,'&',''),'''','')+space(40),40)+ -- NOME, BRANCOS
--				left(replace(replace(@endereco,'&',''),'''','')+SPACE(40),40)+
--				left(replace(replace(@bairro,'&',''),'''','')+SPACE(12),12)+
--				right('00000000'+@cep,8)+
--				left(replace(replace(@cidade,'&',''),'''','')+SPACE(15),15)+
--				left(@uf+SPACE(2),2)+SPACE(40)+'007' +
--				RIGHT('000000'+convert(varchar(6),@qtde+1),6)
				
--				--'0000' + --NSTRUÇÃO/ALEGAÇÃO				
--				--Right('000000000000000'+convert(varchar(30),@cd_associado_empresa),15) + right('0000000000'+convert(varchar(30),@cd_parcela),10) + --Identificação do titulo na EMpresa
				
--				--right('0000000000'+convert(varchar(30),@cd_parcela),8) + -- NOSSO NÚMERO
--				--'0000000000000' + -- QTDE DE MOEDA
--				--RIGHT('000'+convert(varchar(3),@carteira),3) + SPACE(21) + '901' + -- Nº DA CARTEIRA,USO DO BANCO,CARTEIRA,OCORRENCIA
				
--				--right('0000000000'+convert(varchar(10),@cd_parcela),10) + -- Nº DO DOCUMENTO
--				--replace(convert(varchar(8),@dt_vencimento,3),'/','') + -- VENCIMENTO
--				--right('000000000000000'+convert(varchar(15),convert(int,Floor(@vl_parcela_L*100))),13) + -- Valor do débito  
--				--right('000'+convert(varchar(3),@cd_banco),3) + '00000' + '99N' +-- Codigo do Banco + AGÊNCIA COBRADORA + ESPÉCIE + ACEITE
--				--replace(convert(varchar(8),GETDATE(),3),'/','') + -- DATA DE EMISSÃO
--				--'2893' + -- INSTRUÇÃO 1, INSTRUÇÃO 2
--				--right('0000000000000' + replace(convert(varchar(5),round(@vl_parcela_L*@juros/100/30*100,0)/100),'.',''), 13) + -- Juros de 1dia
--				--'000000' + '0000000000000' + '0000000000000' + '0000000000000' + -- DESCONTO ATÉ, VALOR DO DESCONTO, VALOR DO I.O.F.,ABATIMENTO
--				--case when LEN(@cpf_cnpj)>11 then '02' else '01' end + RIGHT('00000000000000'+@cpf_cnpj,14) + -- CÓDIGO DE INSCRIÇÃO, NÚMERO DE INSCRIÇÃO
--				--left(replace(replace(@nome,'&',''),'''','')+space(40),40)+ -- NOME, BRANCOS
--				--left(replace(replace(@endereco,'&',''),'''','')+SPACE(40),40)+
--				--left(replace(replace(@bairro,'&',''),'''','')+SPACE(12),12)+
--				--right('00000000'+@cep,8)+				
--				--left(replace(replace(@cidade,'&',''),'''','')+SPACE(15),15)+
--				--left(@uf+SPACE(2),2)+SPACE(30)+SPACE(4)+'00000000' + ' ' +
--				--RIGHT('000000'+convert(varchar(6),@qtde+1),6)
		   
--		   print @linha
							    
--           if @Linha is null or @Linha = '' 
--			Begin -- 2.2.6
--              set @erro = 1 
--			  update Lote_Processos_Bancos_Mensalidades 
--                 set mensagem = 'Linha ('+ convert(varchar(20),@cd_associado_empresa) + ') invalida.'
--               where cd_sequencial_lote = @sequencial and 
--                     cd_parcela = @cd_parcela
--			End -- 2.2.6
			
-- 		   Set @linha = 'ECHO ' + @linha + '>> ' + @arquivo 
--		   EXEC SP_Shell @linha

--           -- Campo livre bradesco
--           -- 20 a 23 - Agência Cedente (Sem o digito verificador, completar com zeros a esquerda quando necessário)
--		   -- 24 a 25 - Carteira
--		   -- 26 a 36 - 11 - Número do Nosso Número(Sem o digito verificador)
--		   -- 37 a 43 - 7  - Conta do Cedente (Sem o digito verificador,completar com zeros a esquerda quando necessário)
--		   -- 44 a 44 1 Zero
		   
  		   
                    
--		FETCH NEXT FROM cursor_gera_processos_bancos_mens INTO @cd_associado_empresa,@cd_parcela ,@cd_tipo_pagamento_M, @vl_parcela_M,@dt_vencimento,
--		      @vl_parcela_L,@cd_tipo_recebimento,@cpf_cnpj ,@nome, @endereco, @bairro, @cep, @cidade, @uf ,@nn,@taxa

--        end -- 3.2
--        Close cursor_gera_processos_bancos_mens
--        Deallocate cursor_gera_processos_bancos_mens

--        --- Header
--        Set @linha = '9' + RIGHT('000000'+convert(varchar(6),@qtde),6) + right('0000000000000' + convert(varchar(13),@vl_total),13)+ SPACE(374)+ RIGHT('000000'+convert(varchar(6),@qtde+1),6)
--        --Set @linha = '9' + SPACE(393)+RIGHT('000000'+convert(varchar(6),@qtde+2),6)
--        Set @linha = 'ECHO ' + @linha +  '>> ' + @arquivo 
--		EXEC SP_Shell @linha       

--   End -- 4
--/**************Fim BOLETO BANCARIO CNAB400**********************/
   
   if @erro = 1  -- Excluir arquivo 
   Begin -- 90
     if @cd_tiposervico in (1,12)
      Begin
         delete boleto where cd_sequencial_lote = @sequencial
      End
     Else
      Begin
		set @linha = 'Del '+  @arquivo
		EXEC SP_Shell @linha , 0 -- Excluir se o arquivo já existir
	    Raiserror('Erro na geração do Arquivo.',16,1)
		RETURN
	  End 	
   End -- 90
   Else
   Begin -- 90.1
		-- Atualizar Processos_Banco (convenio e nsa)
	   update lote_processos_bancos
		  set nsa = @nsa,
			  convenio = @convenio, 
			  dt_gerado = getdate(), 
			  dt_finalizado = getdate() , 
			  qtde = (select count(0) from lote_processos_bancos_mensalidades where cd_sequencial_lote = @sequencial) , 
			  valor = (select sum(vl_parcela) from lote_processos_bancos_mensalidades where cd_sequencial_lote = @sequencial), 
			  nm_arquivo = @nm_arquivo -- alterei aqui
		where cd_sequencial = @sequencial
		IF @@ROWCOUNT = 0
		Begin -- 90.1.1
		  set @linha = 'Del '+  @arquivo
		  EXEC SP_Shell @linha , 0 -- Excluir se o arquivo já existir
		  Raiserror('Erro no Fechamento do Arquivo.',16,1)
		  RETURN
		End -- 90.1.1
   End -- 90.1
   
   ---Gera arquivos de Impressao Externa
     Exec dbo.SP_GeraArquivoImpressao @sequencial, @arquivo, @cd_funcionarioCadastro, @tipo   
     */
     return
End --1
