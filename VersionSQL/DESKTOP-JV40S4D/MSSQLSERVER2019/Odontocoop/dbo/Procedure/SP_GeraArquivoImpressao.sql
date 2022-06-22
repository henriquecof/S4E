/****** Object:  Procedure [dbo].[SP_GeraArquivoImpressao]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE Procedure [dbo].[SP_GeraArquivoImpressao] 
    @sequencial int, 
    @arquivo varchar(1000) output,
    @cd_funcionarioCadastro Int = 0,    
    @tipo int = 0 
as
Begin -- 1

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
    Declare @VariacaoCarteira varchar(5)
    declare @impressaoExterna bit    

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
    Declare @nr_autorizacao varchar(20)
    Declare @vl_parcela_L money
    Declare @cd_tipo_recebimento smallint
    Declare @G005 varchar(1)
    Declare @cpf_cnpj as varchar(14)
    Declare @tp_associado_Empresa as smallint 
    Declare @nr_contrato varchar(20)
    Declare @nn varchar(20)
    Declare @tipo_cartao_Hiper smallint = 0 

    -- Variavel de Erro
    Declare @erro bit 
 
    -- Variaveis do Trailler
    Declare @qtde int 
    Declare @vl_total bigint
    Declare @qtde_no int = 0  
    Declare @vl_total_no bigint = 0 
    Declare @numerolinha int = 1 
    Declare @numero_nos int = 1 
    Declare @Fl_reajuste smallint = 0
	Declare @ContratoPJ varchar(300)
	Declare @TipoMSG int = 0
	Declare @MSGComplementar varchar(100) = ''  

    --Select top 1 @caminho = Pasta_Site from configuracao -- Verificar o caminho a ser gravado os arquivos
    Select top 1 @caminho = Pasta_Site_SQL from configuracao -- Verificar o caminho a ser gravado os arquivos
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
           @taxa = ISNULL(vl_taxa,0),
           @qt_diasminimo = ISNULL(tsb.qt_diasminimo,0),
           @VariacaoCarteira = t.VariacaoCarteira ,
           @agencia = t.ag, 
           @dv_ag = t.dv_ag,
           @impressaoExterna = isnull(t.impressaoExterna,'False') 
           
FROM            Lote_Processos_Bancos AS l INNER JOIN
                         TIPO_PAGAMENTO AS t ON l.cd_tipo_pagamento = t.cd_tipo_pagamento INNER JOIN
                         tipo_servico_bancario AS tsb ON l.cd_tipo_servico_bancario = tsb.cd_tipo_servico_bancario LEFT OUTER JOIN
                         TB_Banco_Contratos AS b ON t.banco = b.cd_banco
WHERE        (l.cd_sequencial = @sequencial)
           
    IF @@ROWCOUNT = 0
    Begin -- 1.2
	  Raiserror('Sequencial nao encontrado.',16,1)
	  RETURN
    End -- 1.2
   
    if @impressaoExterna = 'False'
 	       begin
 		 --Nao usa Impressao Externa
 		  return
 	      end
    
    Select @qt_diasminimo = qt_diasminimo from tipo_servico_bancario where cd_tipo_servico_bancario=@cd_tiposervico
    Set @dt_ref = DATEADD(day,@qt_diasminimo,GETDATE())
    while DATEPART(dw,@dt_ref)=1 or DATEPART(dw,@dt_ref)=7
    Begin 
      set @dt_ref = DATEADD(day,1,@dt_ref)
    End 
   -- --select @cd_tiposervico=6 , @cd_tipopagamento = 18 
   
	if @cd_tiposervico = 6 or -- Debito Automatico
       @cd_tiposervico = 1 or -- CNAB 240
       @cd_tiposervico = 12 or -- CNAB 400
       @cd_tiposervico = 44 or -- CNAB 240
       @cd_tiposervico = 41 or -- CNAB 400
       @cd_tiposervico = 46 -- CNAB 400
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
        	
   if @cd_tiposervico in (1,21) -- CNAB 240 ou 400
    Begin -- 1.4
        -- Validar variaveis obrigatorias 
        if @cd_banco is null or @convenio is null or @cedente is null 
		Begin -- 2.1
		  Raiserror('Banco, Convênio ou Cedente não definidos na tabela de Tipo de Pagamento.',16,1)
		  RETURN
		End -- 2.1
    End -- 1.4 
    
    --- Encontrar o @nsa do Arquivo. Sequencial 
    select @nsa = isnull(max(nsa)+1,1) from lote_processos_bancos where convenio = @convenio

	if @cd_tiposervico in (16)
	   Set @nm_arquivo =  'CB' + replace(convert(varchar(4),getdate(),103),'/','') + right('000'+convert(varchar(10),@sequencial),3) + '.REM' 
    else
		Begin
			if @cd_tiposervico in (46)
				Set @nm_arquivo =  'Boleto' +  replace(convert(varchar(8),getdate(),3),'/','') + '.txt' -- alterei aqui
			else
				Set @nm_arquivo =  replace(@nm_tipopagamento,' ','') + '_' + convert(varchar(10),@sequencial) + '_' + replace(convert(varchar(10),getdate(),103),'/','') + case when @cd_tiposervico in (17) then '.ass' else '.txt' end -- alterei aqui
		End
    
       
       
    Set @arquivo = @caminho + '\arquivos\banco\envio\' + 'Grafica_' + @nm_arquivo -- alterei aqui
    
    print @arquivo
    set @linha = 'Del '+  @arquivo
    EXEC SP_Shell @linha , 0 -- Excluir se o arquivo já existir

	if @cd_tiposervico = 6 -- Debito Automatico
    Begin -- 2

        --- Header
        Set @linha = 'A1' + convert(char(20),@convenio) + convert(char(20),substring(@cedente,1,20)) + 
               right('000'+convert(varchar(3),@cd_banco),3) + -- Codigo do Banco
               convert(char(20),substring(@nm_banco,1,20)) +  -- Nome do Banco
               convert(varchar(8),getdate(),112) + -- Data de geração do arquivo (AAAAMMDD)
               right('000000'+convert(varchar(3),@nsa),6) + -- Número sequencial do arquivo (NSA)
               '04DEBITO AUTOMATICO' + Space(52)
        Set @linha = 'ECHO ' + @linha +  '>> ' + @arquivo 
		EXEC SP_Shell @linha

        Select @erro = 0 , @vl_total = 0 , @qtde=0 

		DECLARE cursor_gera_processos_impressao_mens CURSOR FOR  
		
		select m.cd_associado_empresa , m.cd_parcela, m.cd_tipo_pagamento, 
               m.vl_parcela+isnull(m.vl_acrescimo,0)-isnull(m.vl_desconto,0)-isnull(m.vl_imposto,0) , 
               case when m.dt_vencimento<@dt_ref then @dt_ref else m.dt_vencimento end  , a.agencia, a.nr_autorizacao , l.vl_parcela , m.cd_tipo_recebimento , 
               a.nr_conta, a.nr_conta_DV, m.nosso_numero 
		  from Lote_Processos_Impressao_Mensalidades as L, Mensalidades as M, Associados as a
		 where L.cd_sequencial_lote = @sequencial and 
               l.cd_parcela = m.cd_parcela and 
               m.cd_Associado_empresa = a.cd_Associado and 
               m.tp_Associado_empresa = 1   
               
		OPEN cursor_gera_processos_impressao_mens  
		FETCH NEXT FROM cursor_gera_processos_impressao_mens INTO @cd_associado_empresa,@cd_parcela ,@cd_tipo_pagamento_M, @vl_parcela_M,@dt_vencimento,@agencia,@nr_autorizacao,@vl_parcela_L,@cd_tipo_recebimento,@nr_conta,@nr_conta_DV,@nn

		WHILE (@@FETCH_STATUS <> -1)  
		begin  -- 2.2        

           if @cd_tipo_pagamento_M <> @cd_tipopagamento
			Begin -- 2.2.1
              set @erro = 1 
			  update Lote_Processos_Impressao_Mensalidades 
                 set mensagem = 'Tipo de Pagamento do Associado ('+ convert(varchar(20),@cd_associado_empresa) + ') invalido.'
               where cd_sequencial_lote = @sequencial and 
                     cd_parcela = @cd_parcela
			End -- 2.2.1

           if @vl_parcela_M <> @vl_parcela_L
			Begin -- 2.2.2
              set @erro = 1 
			  update Lote_Processos_Impressao_Mensalidades 
                 set mensagem = 'Parcela do Associado ('+ convert(varchar(20),@cd_associado_empresa) + ') diferente do Gerado.'
               where cd_sequencial_lote = @sequencial and 
                     cd_parcela = @cd_parcela
			End -- 2.2.2

           if @agencia is null or LEN(@agencia)>4 
			Begin -- 2.2.3
              set @erro = 1 
			  update Lote_Processos_Impressao_Mensalidades 
                 set mensagem = 'Agencia do Associado ('+ convert(varchar(20),@cd_associado_empresa) + ') não informada ou invalida.'
               where cd_sequencial_lote = @sequencial and 
                     cd_parcela = @cd_parcela
			End -- 2.2.3

--           if @nr_autorizacao is null 
--			Begin -- 2.2.4
--              set @erro = 1 
--			  update Lote_Processos_Impressao_Mensalidades 
--                 set mensagem = 'Identificador do Associado ('+ convert(varchar(20),@cd_associado_empresa) + ') não informado.'
--               where cd_sequencial_lote = @sequencial and 
--                     cd_parcela = @cd_parcela
--			End -- 2.2.4
 
           if @cd_tipo_recebimento > 0 
			Begin -- 2.2.5
              set @erro = 1 
			  update Lote_Processos_Impressao_Mensalidades 
                 set mensagem = 'Associado ('+ convert(varchar(20),@cd_associado_empresa) + ') não encontra-se com a parcela em Aberto.'
               where cd_sequencial_lote = @sequencial and 
                     cd_parcela = @cd_parcela
			End -- 2.2.5

           if @nr_conta is null or @nr_conta = '' or @nr_conta_DV is null or @nr_conta_DV = ''
			Begin -- 2.2.6
              set @erro = 1 
			  update Lote_Processos_Impressao_Mensalidades 
                 set mensagem = 'Conta ou Digito Verificador do Associado ('+ convert(varchar(20),@cd_associado_empresa) + ') invalido.'
               where cd_sequencial_lote = @sequencial and 
                     cd_parcela = @cd_parcela
			End -- 2.2.6

            -- Montar Conta 
            if @cd_banco = 1 
               set @linha = right('00000000000000'+ convert(varchar(14),@nr_conta),14) -- BB ag S/dv e cta S/dv
            else
               set @linha = right('0000000'+convert(varchar(7),@nr_conta),7) + right('0'+convert(varchar(1),@nr_conta_DV),1) + Space(6) -- Bradesco Ag sem DV + Conta c/ DV

           -- Monta Linha

            if @nr_autorizacao is null or @nr_autorizacao = '' -- Nao tem o Numero da Autorizacao
            Begin -- 2.2.7
              Set @nr_autorizacao = right('00000000'+convert(varchar(8),@cd_associado_empresa),8)+'00000002'
              update associados set nr_autorizacao = @nr_autorizacao where cd_Associado = @cd_associado_empresa
            End -- 2.2.7

			Set @linha = 'E' + Left(@nr_autorizacao+space(25),25) + -- Autorizacao. 
  				         right('0000'+convert(varchar(4),@agencia),4) + -- Agencia sem DV (4)
				         @linha + -- Conta (7) + Conta DV (1) + 6 espaco -- Identificação do cliente no Banco
				         convert(varchar(8),@dt_vencimento,112) + -- Data do vencimento (AAAAMMDD)  
					     right('000000000000000'+convert(varchar(15),convert(int,Floor(@vl_parcela_L*100))),15) + -- Valor do débito     
                         '03' + -- Moeda 
                         left('000'+convert(varchar(20),@nn)+SPACE(49),49) + Space(31) + -- Identificação do cliente na Empresa  (25) = @sequencial (6) + Associado(8) + Tipo Pagamento (4) + Parcela (11) + Space(31). 
                         '0' -- Código do movimento (Debito Normal)

 		   Set @linha = 'ECHO ' + @linha + ' >> ' + @arquivo 
		   EXEC SP_Shell @linha
			
           Set @vl_total = @vl_total + convert(int,@vl_parcela_L*100)
           Set @qtde= @qtde + 1 

       	   FETCH NEXT FROM cursor_gera_processos_impressao_mens INTO @cd_associado_empresa,@cd_parcela ,@cd_tipo_pagamento_M, @vl_parcela_M,@dt_vencimento,@agencia,@nr_autorizacao,@vl_parcela_L,@cd_tipo_recebimento,@nr_conta,@nr_conta_DV,@nn
        end -- 2.2
        Close cursor_gera_processos_impressao_mens
        Deallocate cursor_gera_processos_impressao_mens

        -- Escrever Trailler
        Set @linha = 'Z' + right('000000'+convert(varchar(6),@qtde+2),6) + -- Total de registros do arquivo 
                     right('00000000000000000'+convert(varchar(17),@vl_total),17) + -- Valor total dos registros do arquivo
                     Space(126)
        Set @linha = 'ECHO ' + @linha +  '>> ' + @arquivo 
		EXEC SP_Shell @linha

   End -- 2

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
   PRINT 'dias minimo'
   PRINT @qt_diasminimo
		DECLARE cursor_gera_processos_impressao_mens CURSOR FOR  
		select a.cd_associado , m.vl_parcela+isnull(m.vl_acrescimo,0)-isnull(m.vl_desconto,0)-isnull(m.vl_imposto,0) , 
		       a.nr_cpf , m.CD_PARCELA , a.nr_autorizacao, convert(varchar(10),a.val_cartao), convert(varchar(10),a.cd_seguranca), a.cd_bandeira , 
	           case when m.dt_vencimento <= dateadd(day,@qt_diasminimo,convert(varchar(10),getdate(),101)) then dateadd(day,@qt_diasminimo,convert(varchar(10),getdate(),101)) else m.dt_vencimento End 
	           , m.tp_Associado_empresa
               
FROM            Lote_Processos_Impressao_Mensalidades AS L INNER JOIN
                         MENSALIDADES AS M ON L.cd_parcela = M.CD_PARCELA INNER JOIN
                         ASSOCIADOS AS a ON M.CD_ASSOCIADO_empresa = a.cd_associado LEFT OUTER JOIN
                         Bandeira AS BN ON a.cd_bandeira = BN.cd_bandeira
WHERE        (L.cd_sequencial_lote = @sequencial)
ORDER BY M.CD_PARCELA
		OPEN cursor_gera_processos_impressao_mens  
		FETCH NEXT FROM cursor_gera_processos_impressao_mens INTO @cd_associado_empresa,@vl_parcela_M,@cpf_cnpj ,
              @cd_parcela,@nr_autorizacao, @val_cartao, @cd_seguranca, @cd_bandeira,@dt_vencimento, @tp_associado_Empresa

		WHILE (@@FETCH_STATUS <> -1)  
		begin  -- 2.2        

            if (@nr_autorizacao is null or len(@nr_autorizacao) <> 16) 
			Begin -- 2.2.5
              set @erro = 1 
			  update Lote_Processos_Impressao_Mensalidades 
                 set mensagem = 'Associado ('+ convert(varchar(20),@cd_associado_empresa) + ') sem numero de autorização ou errado.'
               where cd_sequencial_lote = @sequencial and 
                     cd_parcela = @cd_parcela
			End -- 2.2.5
			
            if (@val_cartao is null or len(@val_cartao) <> 6) 
			Begin -- 2.2.5
              set @erro = 1 
			  update Lote_Processos_Impressao_Mensalidades 
                 set mensagem = 'Associado ('+ convert(varchar(20),@cd_associado_empresa) + ') sem validade ou errado.'
               where cd_sequencial_lote = @sequencial and 
                     cd_parcela = @cd_parcela
     
			End -- 2.2.5
			
   --         if (@cd_seguranca is null or len(@cd_seguranca)<>3) 
			--Begin -- 2.2.5
   --           set @erro = 1 
			--  update Lote_Processos_Impressao_Mensalidades 
   --              set mensagem = 'Associado ('+ convert(varchar(20),@cd_associado_empresa) + ') sem código de segurança ou errado.'
   --            where cd_sequencial_lote = @sequencial and 
   --                  cd_parcela = @cd_parcela
			--End -- 2.2.5
			
            if @cd_bandeira is null 
			Begin -- 2.2.5
              set @erro = 1 
			  update Lote_Processos_Impressao_Mensalidades 
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
			  update Lote_Processos_Impressao_Mensalidades 
                 set mensagem = 'Linha ('+ convert(varchar(20),@cd_associado_empresa) + ') invalida.'
               where cd_sequencial_lote = @sequencial and 
                     cd_parcela = @cd_parcela               
			End -- 2.2.6
           
		   Set @linha = 'ECHO ' + @linha +  '>> ' + @arquivo 
 		   EXEC SP_Shell @linha

		FETCH NEXT FROM cursor_gera_processos_impressao_mens INTO @cd_associado_empresa,@vl_parcela_M,@cpf_cnpj ,
              @cd_parcela,@nr_autorizacao, @val_cartao, @cd_seguranca, @cd_bandeira,@dt_vencimento, @tp_associado_Empresa
        end -- 2.2
        Close cursor_gera_processos_impressao_mens
        Deallocate cursor_gera_processos_impressao_mens

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

	if @cd_tiposervico = 17 -- Cartao Hipercard - Assinatura em arquivo -- Nos 0,1,5,8 e 9 
    Begin -- 1.4

		--Nr Qtde Tipo Descrição
		--1 1 N HA-TIPO-REG Tipo de registro Fixo igual a 0.
		--2 7 N HA-IDENT-LOJA --Identificação do remetente - informado pela Hipercard
		--9 3 A FILLER Fixo igual a zeros
		--12 15 A HA-TEXTO Texto livre para o lojista
		--27 8 N HA-DT-ARQUIVO Data de envio do arquivo no formato AAAAMMDD
		--35 5 N HA-SEQUENCIA Seqüência do arquivo enviado
		--Seqüencial ascendente com
		--diferença 1.
		--40 3 A HA-VERSAO Versão do layout do arquivo Igual a V20.
		--43 66 A FILLER Fixo igual a brancos.
		--109 2 N HA-CODRET Código de retorno Veja tabela "Código de Retorno".

        --- Header do Arquivo
        Set @linha = '0' + @convenio + '000' + '000dentalcenter' + convert(varchar(8),GETDATE(),112) + 
               right('00000'+convert(varchar(5),@nsa),5) + -- Número sequencial do arquivo
               'V20' + 
               SPACE(66) + '00'

        Set @linha = 'ECHO ' + @linha +  '>> ' + @arquivo 
		EXEC SP_Shell @linha
		
		
		----------- Tipo = 1 
		--1 1 N HM-TIPO-REG Tipo de registro Fixo igual a 1.
		--2 2 N HM-TIPO-CART Identificação do tipo de cartão
		--4 2 N HM-FILIAL Identificação da filial do lojista
		--6 5 N HM-LOJA Identificação da loja
		--11 3 N HM-EST Identificação do estabelecimento
		--14 3 N HM-TIPO-MOV Identifica o tipo de movimento
		--205 - Autorização de Venda
		--Rotativa.
		--213 - Autorização de Venda
		--Parcelada.
		--605 - Cancelamento e/ou troca de
		--plano – Venda Rotativa.
		--613 - Cancelamento e/ou troca de
		--plano – Venda Parcelada.
		--17 2 N HM-PREST
		--Identifica o número de parcelas dos parcelados
		--que vem no detalhe de movimentos
		--Para HM-TIPO-MOV igual a 205,
		--605 e 613 formatar com a zeros.
		--19 90 A FILLER1 Fixo igual a brancos.
		--109 2 N HM-CODRET Código de retorno Veja tabela "Código de Retorno".

        ------------- Tipo = 8 
		--1 1 N TM-TIPO-REG Tipo de registro Fixo igual a 8.
		--2 6 N TM-QTDMOV Quantidade total de registros de movimento
		--8 15 A FILLER1 Fixo igual a brancos.
		--23 13 N TM-VALOR Somatório do MV-VLR-VENDA
		--36 73 A FILLER2 Fixo igual a brancos.
		--109 2 N TM-CODRET Código de retorno Veja tabela "Código de Retorno".

        Select @erro = 0 , @vl_total = 0 , @qtde=0 
   
		DECLARE cursor_gera_processos_impressao_mens CURSOR FOR  
		select a.cd_associado , m.vl_parcela+isnull(m.vl_acrescimo,0)-isnull(m.vl_desconto,0)-isnull(m.vl_imposto,0)   , 
		       a.nr_cpf , m.CD_PARCELA , a.nr_autorizacao, convert(varchar(10),a.val_cartao), convert(varchar(10),a.cd_seguranca), case when len(a.nr_autorizacao)=16 or substring(a.nr_autorizacao,1,1) = 1 then 1 when len(a.nr_autorizacao)=13 then 6 else null end , 
	           case when m.dt_vencimento <= dateadd(day,@qt_diasminimo,convert(varchar(10),getdate(),101)) then dateadd(day,@qt_diasminimo,convert(varchar(10),getdate(),101)) else m.dt_vencimento End 
	           , m.tp_Associado_empresa
               
FROM            Lote_Processos_Impressao_Mensalidades AS L INNER JOIN
                         MENSALIDADES AS M ON L.cd_parcela = M.CD_PARCELA INNER JOIN
                         ASSOCIADOS AS a ON M.CD_ASSOCIADO_empresa = a.cd_associado LEFT OUTER JOIN
                         Bandeira AS BN ON a.cd_bandeira = BN.cd_bandeira
WHERE        (L.cd_sequencial_lote = @sequencial)
ORDER BY 8, M.CD_PARCELA
		OPEN cursor_gera_processos_impressao_mens  
		FETCH NEXT FROM cursor_gera_processos_impressao_mens INTO @cd_associado_empresa,@vl_parcela_M,@cpf_cnpj ,
              @cd_parcela,@nr_autorizacao, @val_cartao, @cd_seguranca, @cd_bandeira,@dt_vencimento, @tp_associado_Empresa

		WHILE (@@FETCH_STATUS <> -1)  
		begin  -- 2.2        

            if (@nr_autorizacao is null or (len(@nr_autorizacao) <> 16 and len(@nr_autorizacao) <> 13)) 
			Begin -- 2.2.5
              set @erro = 1 
			  update Lote_Processos_Impressao_Mensalidades 
                 set mensagem = 'Associado ('+ convert(varchar(20),@cd_associado_empresa) + ') sem numero de autorização ou errado.'
               where cd_sequencial_lote = @sequencial and 
                     cd_parcela = @cd_parcela
			End -- 2.2.5
			
   --         if (@val_cartao is null or len(@val_cartao) <> 6) 
			--Begin -- 2.2.5
   --           set @erro = 1 
			--  update Lote_Processos_Impressao_Mensalidades 
   --              set mensagem = 'Associado ('+ convert(varchar(20),@cd_associado_empresa) + ') sem validade ou errado.'
   --            where cd_sequencial_lote = @sequencial and 
   --                  cd_parcela = @cd_parcela
			--End -- 2.2.5
			
   --         if (@cd_seguranca is null or len(@cd_seguranca)<>3) 
			--Begin -- 2.2.5
   --           set @erro = 1 
			--  update Lote_Processos_Impressao_Mensalidades 
   --              set mensagem = 'Associado ('+ convert(varchar(20),@cd_associado_empresa) + ') sem código de segurança ou errado.'
   --            where cd_sequencial_lote = @sequencial and 
   --                  cd_parcela = @cd_parcela
			--End -- 2.2.5
			
            if @cd_bandeira is null 
			Begin -- 2.2.5
              set @erro = 1 
			  update Lote_Processos_Impressao_Mensalidades 
                 set mensagem = 'Associado ('+ convert(varchar(20),@cd_associado_empresa) + ') com numeração errada (13 ou 16).'
               where cd_sequencial_lote = @sequencial and 
                     cd_parcela = @cd_parcela
			End -- 2.2.5

         
           if @tipo_cartao_Hiper <> @cd_bandeira 
           Begin
               if @tipo_cartao_Hiper <> 0 -- Colocar o nó 8
               Begin
                  -- TRAILER DO MOVIMENTO - TIPO 8
				  Set @linha = '8' + RIGHT('000000' + convert(varchar(6),@qtde_no),6) + space(15) + right('00000000000000000'+convert(varchar(17),@vl_total_no),13) + SPACE(73) + '00'
				  Set @linha = 'ECHO ' + @linha +  '>> ' + @arquivo 
				  EXEC SP_Shell @linha	 
				  
				  Set @qtde= @qtde + 2
				                
               End                
                
			   --- HEADER DO MOVIMENTO - TIPO 1
			  Set @linha = '1' + right('00'+convert(varchar(2),@cd_bandeira),2) + @convenio + '001' + '20500' + SPACE(90) + '00'
			  Set @linha = 'ECHO ' + @linha +  '>> ' + @arquivo 
		      EXEC SP_Shell @linha	
			  
              Set @tipo_cartao_Hiper = @cd_bandeira 
              Set @qtde_no = 0
              Set @vl_total_no =0 
           End

           Set @vl_total = @vl_total + convert(int,@vl_parcela_M*100)
           Set @qtde= @qtde + 1      
           
           Set @qtde_no = @qtde_no + 1 
           Set @vl_total_no =@vl_total_no + convert(int,@vl_parcela_M*100)       
           
			--1 1 N MV-TIPO-REG Tipo de registro Fixo igual a 5.
			--2 3 N MV-TIPO-MOV Tipo de movimento 205 - Autorização de Venda Rotativa.
			--5 6 N MV-NUM-DOC Número do documento de compra
			--11 8 N MV-DT-MOVTO Data do movimento no formato AAAAMMDD Deverá ser menor ou igual a HA-DT-ARQUIVO.
			--19 8 N MV-NUMPOS Número do POS do lojista Campo opcional. Formatar com  zeros se não for informado.
			--27 5 N MV-NUMLOT Número do lote de controle do lojista Campo opcional. Formatar com zeros se não for informado.
			--32 19 N MV-CARTAO Número do cartão Para cartões com 13 dígitos,formatar 000000 mais o número do cartão.
			--51 2 N MV-PREST Número de parcelas da venda parcelada 
			--53 2 N MV-PCPG Retorna o número de parcelas que já foram pagas Fixo igual a zeros.
			--55 2 N MV-PC-CANCL Número de parcelas para cancelamento
			--57 11 N MV-VLR-VENDA Valor da venda Preencher com o valor da transação.
			--68 6 N MV-CONSU Número de autorização Fixo igual a zeros.
			--74 11 N MV-VLR-CANC Valor do cancelamento
			--85 14 A MVIDENTIFICADOR Espaço reservado para o lojista Campo opcional. Formatar com brancos se não for informado.
			--99 10 A FILLER1 Fixo igual a brancos.
			--109 2 N MV-CODRET Código de retorno Veja tabela "Código de Retorno".
           
           --Registro Detalhe 
			Set @linha = '5205' + RIGHT('000000'+convert(varchar(10),@qtde),6) + 
			             convert(varchar(8),GETDATE(),112) +  
			             '00000000' + 
			             right('00000'+convert(varchar(5),@nsa),5) + 
			             '000' + right('0000000' + @nr_autorizacao,16) + '000000' + 
			             right('000000000000000'+Replace(convert(varchar(15),convert(int,Floor(@vl_parcela_M*100))),'.','') ,11) + -- Valor do débito      
			             '000000'+
			             '00000000000' + 
			             right('00000000000000'+convert(varchar(14),@cd_parcela),14) + 
			             SPACE(10) + 
			             '00' 
                          
           if @Linha is null or @Linha = '' 
			Begin -- 2.2.6
              set @erro = 1 
			  update Lote_Processos_Impressao_Mensalidades 
                 set mensagem = 'Linha ('+ convert(varchar(20),@cd_associado_empresa) + ') invalida.'
               where cd_sequencial_lote = @sequencial and 
                     cd_parcela = @cd_parcela               
			End -- 2.2.6
           
		   Set @linha = 'ECHO ' + @linha +  '>> ' + @arquivo 
 		   EXEC SP_Shell @linha

		FETCH NEXT FROM cursor_gera_processos_impressao_mens INTO @cd_associado_empresa,@vl_parcela_M,@cpf_cnpj ,
              @cd_parcela,@nr_autorizacao, @val_cartao, @cd_seguranca, @cd_bandeira,@dt_vencimento, @tp_associado_Empresa
        end -- 2.2
        Close cursor_gera_processos_impressao_mens
        Deallocate cursor_gera_processos_impressao_mens

        -- TRAILER DO MOVIMENTO - TIPO 8  
   	    Set @linha = '8' + RIGHT('000000' + convert(varchar(6),@qtde_no),6) + '000000000000000' + right('00000000000000000'+convert(varchar(17),@vl_total_no),13) + SPACE(73) + '00'
	    Set @linha = 'ECHO ' + @linha +  '>> ' + @arquivo 
	    EXEC SP_Shell @linha	
	    
	    Set @qtde= @qtde + 2

		--1 1 N TA-TIPO-REG Tipo de registro Fixo igual a 9.
		--2 6 N TA-QTDMOV Quantidade total de registro do arquivo
		--Soma de todos os registros do
		--arquivo.
		--8 13 N TA-VALOR
		--Somatório do TM-VALOR
		--Soma dos valores acumulados nos
		--trailers dos movimentos.
		--21 88 A FILLER1 Fixo igual a brancos.
		--109 2 N TA-CODRET Código de retorno Veja tabela "Código de Retorno".
		
        -- Registro Trailer de Lote
        Set @linha = '9' + RIGHT('0000000'+convert(varchar(10),@qtde+2),6) + -- Qtde 
                     right('00000000000000000'+convert(varchar(13),@vl_total),13) + -- Valor total dos registros do arquivo
                     Space(88) + '00'
                     
        Set @linha = 'ECHO ' + @linha +  '>> ' + @arquivo 
		EXEC SP_Shell @linha

   End -- 1.4




/****************BOLETO BANCARIO CNAB400***********************/
if @cd_tiposervico = 41 -- CNAB 400
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
		     

		DECLARE cursor_gera_processos_impressao_mens CURSOR FOR  
		select m.cd_associado_empresa , m.cd_parcela, m.cd_tipo_pagamento, 
               m.vl_parcela+isnull(m.vl_acrescimo,0)-isnull(m.vl_desconto,0)-isnull(m.vl_imposto,0) , 
			   m.dt_vencimento as dt_vencimento , l.vl_parcela , m.cd_tipo_recebimento , 
               a.nr_cpf ,
               dbo.FF_RemoveCaracterSpecial(dbo.FF_TiraAcento(a.nm_completo)), 
               dbo.FF_RemoveCaracterSpecial(dbo.FF_TiraAcento(ltrim(Isnull(TL.NOME_TIPO,'')+' '+a.EndLogradouro+' '+Case When a.EndNumero is null then '' When a.endNumero=0 then '' else convert(varchar(10),a.endnumero) end+' '+ISNULL(a.EndComplemento,'')))) , 
		       dbo.FF_RemoveCaracterSpecial(dbo.FF_TiraAcento(isnull(b.baiDescricao,''))), a.logcep,  
		       dbo.FF_RemoveCaracterSpecial(dbo.FF_TiraAcento(isnull(Cid.NM_MUNICIPIO,''))) , 
		       dbo.FF_RemoveCaracterSpecial(dbo.FF_TiraAcento(isnull(UF.ufSigla,''))),  
		       m.nosso_numero, 
		       case when isnull(a.taxa_cobranca,1) = 1 then m.vl_taxa else 0 end 
               
FROM            Lote_Processos_Impressao_Mensalidades AS L INNER JOIN
                         MENSALIDADES AS M ON L.cd_parcela = M.CD_PARCELA INNER JOIN
                         ASSOCIADOS AS a ON M.CD_ASSOCIADO_empresa = a.cd_associado LEFT OUTER JOIN
                         TB_TIPOLOGRADOURO AS TL ON a.CHAVE_TIPOLOGRADOURO = TL.CHAVE_TIPOLOGRADOURO LEFT OUTER JOIN
                         Bairro AS B ON a.BaiId = B.baiId LEFT OUTER JOIN
                         MUNICIPIO AS CID ON a.CidID = CID.CD_MUNICIPIO LEFT OUTER JOIN
                         UF ON a.ufId = UF.ufId
WHERE        (L.cd_sequencial_lote = @sequencial) AND (M.TP_ASSOCIADO_EMPRESA = 1)
         union 
		select m.cd_associado_empresa , m.cd_parcela, m.cd_tipo_pagamento, 
               m.vl_parcela+isnull(m.vl_acrescimo,0)-isnull(m.vl_desconto,0)-isnull(m.vl_imposto,0) , 
               m.dt_vencimento , l.vl_parcela , m.cd_tipo_recebimento ,
               a.nr_cgc, 
               dbo.FF_RemoveCaracterSpecial(dbo.FF_TiraAcento(a.nm_razsoc)) , 
               dbo.FF_RemoveCaracterSpecial(dbo.FF_TiraAcento(ltrim(Isnull(TL.NOME_TIPO,'')+' '+a.EndLogradouro+' '+Case When a.EndNumero is null then '' When a.endNumero=0 then '' else convert(varchar(10),a.endnumero) end+' '+ISNULL(a.EndComplemento,'')))) , 
	           dbo.FF_RemoveCaracterSpecial(dbo.FF_TiraAcento(isnull(b.baiDescricao,''))), 
	           a.cep,  
	           dbo.FF_RemoveCaracterSpecial(dbo.FF_TiraAcento(isnull(Cid.NM_MUNICIPIO,''))) , 
	           dbo.FF_RemoveCaracterSpecial(dbo.FF_TiraAcento(isnull(UF.ufSigla,''))) , 
	           m.nosso_numero, 0 
               
FROM            Lote_Processos_Impressao_Mensalidades AS L INNER JOIN
                         MENSALIDADES AS M ON L.cd_parcela = M.CD_PARCELA INNER JOIN
                         EMPRESA AS a ON M.CD_ASSOCIADO_empresa = a.CD_EMPRESA LEFT OUTER JOIN
                         TB_TIPOLOGRADOURO AS TL ON a.CHAVE_TIPOLOGRADOURO = TL.CHAVE_TIPOLOGRADOURO LEFT OUTER JOIN
                         Bairro AS B ON a.BaiId = B.baiId LEFT OUTER JOIN
                         MUNICIPIO AS CID ON a.cd_municipio = CID.CD_MUNICIPIO LEFT OUTER JOIN
                         UF ON a.ufId = UF.ufId
WHERE        (L.cd_sequencial_lote = @sequencial) AND (M.TP_ASSOCIADO_EMPRESA IN (2, 3))
ORDER BY M.CD_PARCELA
		OPEN cursor_gera_processos_impressao_mens  
		FETCH NEXT FROM cursor_gera_processos_impressao_mens INTO @cd_associado_empresa,@cd_parcela ,@cd_tipo_pagamento_M, @vl_parcela_M,@dt_vencimento,
		      @vl_parcela_L,@cd_tipo_recebimento,@cpf_cnpj ,@nome, @endereco, @bairro, @cep, @cidade, @uf ,@nn,@taxa

		WHILE (@@FETCH_STATUS <> -1)  
		begin  -- 4.2        

           set @dt_vencimento_parc = @dt_vencimento
           
           if @cep is null 
           begin -- 4.2.0

              set @erro = 1 
			  update Lote_Processos_Impressao_Mensalidades 
                 set mensagem = 'Cep do Associado ('+ convert(varchar(20),@cd_associado_empresa) + ') invalido.'
               where cd_sequencial_lote = @sequencial and 
                     cd_parcela = @cd_parcela

           End -- 4.2.0

           if @cd_tipo_pagamento_M <> @cd_tipopagamento
			Begin -- 4.2.1
              set @erro = 1 
			  update Lote_Processos_Impressao_Mensalidades 
                 set mensagem = 'Tipo de Pagamento do Associado ('+ convert(varchar(20),@cd_associado_empresa) + ') invalido.'
               where cd_sequencial_lote = @sequencial and 
                     cd_parcela = @cd_parcela
			End -- 4.2.1

           if @vl_parcela_M <> @vl_parcela_L
			Begin -- 4.2.2
              set @erro = 1 
			  update Lote_Processos_Impressao_Mensalidades 
                 set mensagem = 'Parcela do Associado ('+ convert(varchar(20),@cd_associado_empresa) + ') diferente do Gerado.'
               where cd_sequencial_lote = @sequencial and 
                     cd_parcela = @cd_parcela
			End -- 4.2.2

           if @cd_tipo_recebimento > 0 
			Begin -- 4.2.5
              set @erro = 1 
			  update Lote_Processos_Impressao_Mensalidades 
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
				RIGHT('000'+convert(varchar(3),@carteira),3) + SPACE(21) + '901' + -- Nº DA CARTEIRA,USO DO BANCO,CARTEIRA,OCORRENCIA
				
				right('0000000000'+convert(varchar(10),@cd_parcela),10) + -- Nº DO DOCUMENTO
				replace(convert(varchar(8),@dt_vencimento,3),'/','') + -- VENCIMENTO
				right('000000000000000'+convert(varchar(15),convert(int,Floor(@vl_parcela_L*100))),13) + -- Valor do débito  
				right('000'+convert(varchar(3),@cd_banco),3) + '00000' + '99N' +-- Codigo do Banco + AGÊNCIA COBRADORA + ESPÉCIE + ACEITE
				replace(convert(varchar(8),GETDATE(),3),'/','') + -- DATA DE EMISSÃO
				'2893' + -- INSTRUÇÃO 1, INSTRUÇÃO 2
				right('0000000000000' + replace(convert(varchar(5),round(@vl_parcela_L*@juros/100/30*100,0)/100),'.',''), 13) + -- Juros de 1dia
				'000000' + '0000000000000' + '0000000000000' + '0000000000000' + -- DESCONTO ATÉ, VALOR DO DESCONTO, VALOR DO I.O.F.,ABATIMENTO
				case when LEN(@cpf_cnpj)>11 then '02' else '01' end + RIGHT('00000000000000'+@cpf_cnpj,14) + -- CÓDIGO DE INSCRIÇÃO, NÚMERO DE INSCRIÇÃO
				left(replace(replace(@nome,'&',''),'''','')+space(40),40)+ -- NOME, BRANCOS
				left(replace(replace(@endereco,'&',''),'''','')+SPACE(40),40)+
				left(replace(replace(@bairro,'&',''),'''','')+SPACE(12),12)+
				right('00000000'+@cep,8)+				
				left(replace(replace(@cidade,'&',''),'''','')+SPACE(15),15)+
				left(@uf+SPACE(2),2)+SPACE(30)+SPACE(4)+'00000000' + ' ' +
				RIGHT('000000'+convert(varchar(6),@qtde+1),6)
		   
		   print @linha
							    
           if @Linha is null or @Linha = '' 
			Begin -- 2.2.6
              set @erro = 1 
			  update Lote_Processos_Impressao_Mensalidades 
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
		   
  		   
                    
		FETCH NEXT FROM cursor_gera_processos_impressao_mens INTO @cd_associado_empresa,@cd_parcela ,@cd_tipo_pagamento_M, @vl_parcela_M,@dt_vencimento,
		      @vl_parcela_L,@cd_tipo_recebimento,@cpf_cnpj ,@nome, @endereco, @bairro, @cep, @cidade, @uf ,@nn,@taxa

        end -- 3.2
        Close cursor_gera_processos_impressao_mens
        Deallocate cursor_gera_processos_impressao_mens

        --- Header
        Set @linha = '9' + SPACE(393)+RIGHT('000000'+convert(varchar(6),@qtde+2),6)
        Set @linha = 'ECHO ' + @linha +  '>> ' + @arquivo 
		EXEC SP_Shell @linha       

   End -- 4
/**************Fim BOLETO BANCARIO CNAB400**********************/


	if @cd_tiposervico = 19 -- Cartao HIPERCARD - TO -- Nos 0,1,30,40 e 99 
    Begin -- 1.4

        --- Header do Arquivo (0)
        Set @linha = '00' + '0000000000000' + @convenio + left(@cedente + SPACE(30),30) + SPACE(5) + 
               RIGHT('0000'+convert(varchar(10),@nsa),4) + 
               convert(varchar(6),GETDATE(),12) + replace(convert(varchar(8),GETDATE(),108) ,':','') + 
               Space(1) + '3' + SPACE(167) + RIGHT('00000'+convert(varchar(5),@numerolinha),5)
               -- right('00000'+convert(varchar(5),@nsa),5) + -- Número sequencial do arquivo

        Set @linha = 'ECHO ' + @linha +  '>> ' + @arquivo 
		EXEC SP_Shell @linha
		
        Select @erro = 0 , @vl_total = 0 , @qtde=0 
   
		DECLARE cursor_gera_processos_impressao_mens CURSOR FOR  
		select a.cd_associado , m.vl_parcela+isnull(m.vl_acrescimo,0)-isnull(m.vl_desconto,0)-isnull(m.vl_imposto,0)  , 
		       a.nr_cpf , m.CD_PARCELA , a.nr_autorizacao, convert(varchar(10),a.val_cartao), convert(varchar(10),a.cd_seguranca), case when len(a.nr_autorizacao)=16 or substring(a.nr_autorizacao,1,1) = 1 then 1 when len(a.nr_autorizacao)=13 then 6 else null end , 
	           case when m.dt_vencimento <= dateadd(day,@qt_diasminimo,convert(varchar(10),getdate(),101)) then dateadd(day,@qt_diasminimo,convert(varchar(10),getdate(),101)) else m.dt_vencimento End 
   		  
FROM            Lote_Processos_Impressao_Mensalidades AS L INNER JOIN
                         MENSALIDADES AS M ON L.cd_parcela = M.CD_PARCELA INNER JOIN
                         ASSOCIADOS AS a ON M.CD_ASSOCIADO_empresa = a.cd_associado LEFT OUTER JOIN
                         Bandeira AS BN ON a.cd_bandeira = BN.cd_bandeira
WHERE        (L.cd_sequencial_lote = @sequencial) AND (L.mensagem IS NULL)
ORDER BY 8, M.CD_PARCELA
		OPEN cursor_gera_processos_impressao_mens  
		FETCH NEXT FROM cursor_gera_processos_impressao_mens INTO @cd_associado_empresa,@vl_parcela_M,@cpf_cnpj ,
              @cd_parcela,@nr_autorizacao, @val_cartao, @cd_seguranca, @cd_bandeira,@dt_vencimento

		WHILE (@@FETCH_STATUS <> -1)  
		begin  -- 2.2        

            Set @numerolinha = @numerolinha + 1 
            
            if (@nr_autorizacao is null or (len(@nr_autorizacao) <> 16 and len(@nr_autorizacao) <> 13)) 
			Begin -- 2.2.5
              set @erro = 1 
			  update Lote_Processos_Impressao_Mensalidades 
                 set mensagem = 'Associado ('+ convert(varchar(20),@cd_associado_empresa) + ') sem numero de autorização ou errado.'
               where cd_sequencial_lote = @sequencial and 
                     cd_parcela = @cd_parcela
			End -- 2.2.5
			
            if (@val_cartao is null or len(@val_cartao) <> 6) 
			Begin -- 2.2.5
			
			     --if @val_cartao is null 
			     --Set @val_cartao = space(6)
			     --Set @val_cartao = left(@val_cartao+space(6),6)
			
				  set @erro = 1 
				  update Lote_Processos_Impressao_Mensalidades 
					 set mensagem = 'Associado ('+ convert(varchar(20),@cd_associado_empresa) + ') sem validade ou errado.'
				   where cd_sequencial_lote = @sequencial and 
						 cd_parcela = @cd_parcela
			End -- 2.2.5
			
            if (rtrim(@val_cartao)='') 
			Begin -- 2.2.5
              set @erro = 1 
			  update Lote_Processos_Impressao_Mensalidades 
                 set mensagem = 'Associado ('+ convert(varchar(20),@cd_associado_empresa) + ') sem validade ou errado.'
               where cd_sequencial_lote = @sequencial and 
                     cd_parcela = @cd_parcela
			End -- 2.2.5
			
			
   --         if (@cd_seguranca is null or len(@cd_seguranca)<>3) 
			--Begin -- 2.2.5
   --           set @erro = 1 
			--  update Lote_Processos_Impressao_Mensalidades 
   --              set mensagem = 'Associado ('+ convert(varchar(20),@cd_associado_empresa) + ') sem código de segurança ou errado.'
   --            where cd_sequencial_lote = @sequencial and 
   --                  cd_parcela = @cd_parcela
			--End -- 2.2.5
			
            if @cd_bandeira is null 
			Begin -- 2.2.5
              set @erro = 1 
			  update Lote_Processos_Impressao_Mensalidades 
                 set mensagem = 'Associado ('+ convert(varchar(20),@cd_associado_empresa) + ') com numeração errada (13 ou 16).'
               where cd_sequencial_lote = @sequencial and 
                     cd_parcela = @cd_parcela
			End -- 2.2.5

           if @qtde_no = 999 -- @tipo_cartao_Hiper <> @cd_bandeira 
           Begin
              -- TRAILER DO MOVIMENTO - TIPO 30
			  Set @linha = '30' + '9999999999999' + '101' + Space(13) + right('000000000'+@tp_ag,9) + 
			               convert(varchar(6),GETDATE(),12) + right('00000000000000000'+convert(varchar(17),@vl_total_no),15) + 
			               '000000000000000' + '000000000000000' + right('00000000000000000'+convert(varchar(17),@vl_total_no),15) + 
			               RIGHT('000000' + convert(varchar(6),@qtde_no),5) + '000' + 
			               RIGHT('000000' + convert(varchar(6),@numero_nos),5) + Space(15) + 
			               RIGHT('000000' + convert(varchar(6),@numerolinha),5) + 
			               RIGHT('000000' + convert(varchar(6),@numero_nos),5) + Space(15) + 
			               RIGHT('000000' + convert(varchar(6),@numerolinha),5)
			               
			  Set @linha = 'ECHO ' + @linha +  '>> ' + @arquivo 
			  EXEC SP_Shell @linha	 

              Set @numero_nos = @numero_nos + 1 -- Qtde de nos tipo 30 
			  Set @qtde_no = 0 -- Qtde de Itens dentro do no (maximo 999)
			  Set @vl_total_no =0 	
              Set @numerolinha = @numerolinha + 1 
  			  
           End
         
           Set @vl_total = @vl_total + convert(int,@vl_parcela_M*100)
           Set @qtde= @qtde + 1      
           
           Set @qtde_no = @qtde_no + 1 
           Set @vl_total_no =@vl_total_no + convert(int,@vl_parcela_M*100)       
           
           --Registro Detalhe (01)
			Set @linha = '01' + right('0000000000000'+convert(varchar(13),@cd_parcela),13) + '101' + 
			             Right('0000000' + @nr_autorizacao,17) + right('000000000'+@tp_ag,9) + SPACE(6) + '00000000' + 
			             Right('000000000000000'+Replace(convert(varchar(15),convert(int,Floor(@vl_parcela_M*100))),'.','') ,15) + -- Valor do débito 
			             '000000000000000' + 
			             Right('000000000000000'+Replace(convert(varchar(15),convert(int,Floor(@vl_parcela_M*100))),'.','') ,15) + -- Valor do débito
			             convert(varchar(6),GETDATE(),12) + 
			             '01' + 
			             Right('000'+convert(varchar(10),@qtde_no),3) + 
			             right('00000'+convert(varchar(5),@numero_nos),5) + 
			             SPACE(55+3+11+40) + 
			             left(convert(varchar(10),@val_cartao)+SPACE(2),2) + right(Space(2)+convert(varchar(10),@val_cartao),2)  + 
			             'N' + SPACE(12) + 
			             RIGHT('00000'+convert(varchar(5),@numerolinha),5)
                          
           if @Linha is null or @Linha = '' 
			Begin -- 2.2.6
              set @erro = 1 
			  update Lote_Processos_Impressao_Mensalidades 
                 set mensagem = 'Linha ('+ convert(varchar(20),@cd_associado_empresa) + ') invalida.'
               where cd_sequencial_lote = @sequencial and 
                     cd_parcela = @cd_parcela               
			End -- 2.2.6
           
		   Set @linha = 'ECHO ' + @linha +  '>> ' + @arquivo 
 		   EXEC SP_Shell @linha

		FETCH NEXT FROM cursor_gera_processos_impressao_mens INTO @cd_associado_empresa,@vl_parcela_M,@cpf_cnpj ,
              @cd_parcela,@nr_autorizacao, @val_cartao, @cd_seguranca, @cd_bandeira,@dt_vencimento
        end -- 2.2
        Close cursor_gera_processos_impressao_mens
        Deallocate cursor_gera_processos_impressao_mens

 		Set @numerolinha = @numerolinha + 1 
 		
		-- TRAILER DO MOVIMENTO - TIPO 30
		Set @linha = '30' + '9999999999999' + '101' + Space(13) + right('000000000'+@tp_ag,9) + 
					   convert(varchar(6),GETDATE(),12) + right('00000000000000000'+convert(varchar(17),@vl_total_no),15) + 
					   '000000000000000' + '000000000000000' + right('00000000000000000'+convert(varchar(17),@vl_total_no),15) + 
					   RIGHT('000000' + convert(varchar(6),@qtde_no),5) + '000' + 
					   RIGHT('000000' + convert(varchar(6),@numero_nos),5) + Space(126) + 
					   RIGHT('000000' + convert(varchar(6),@numerolinha),5) -- + 
					   --RIGHT('000000' + convert(varchar(6),@numero_nos),5) + Space(15) + 
					   --RIGHT('000000' + convert(varchar(6),@numerolinha),5)
		               
		  Set @linha = 'ECHO ' + @linha +  '>> ' + @arquivo 
		  EXEC SP_Shell @linha	 

		Set @numerolinha = @numerolinha + 1 
 
        -- TRAILER DO MOVIMENTO - TIPO 40  
		Set @linha = '40' + '9999999999999' + '101' + Space(14) + right('000000000'+@tp_ag,9) + SPACE(6) + 
					   right('00000000000000000'+convert(varchar(17),@vl_total),15) + 
					   '000000000000000' + '000000000000000' + right('00000000000000000'+convert(varchar(17),@vl_total),15) + 
					   Space(138) + 
					   RIGHT('000000' + convert(varchar(6),@numerolinha),5)
					   
	    Set @linha = 'ECHO ' + @linha +  '>> ' + @arquivo 
	    EXEC SP_Shell @linha	

		Set @numerolinha = @numerolinha + 1 
        -- Registro Trailer de Lote (99)
        Set @linha = '99' + '9999999999999' + Space(96) + '000' + Space(131) + RIGHT('000000' + convert(varchar(6),@numerolinha),5)
                     
        Set @linha = 'ECHO ' + @linha +  '>> ' + @arquivo 
		EXEC SP_Shell @linha

   End -- 1.4

    if @cd_tiposervico = 1 -- CNAB 240
    Begin -- 4

        select @nsa = isnull(max(nsa)+1,1) from lote_processos_bancos where convenio = @convenio
        
        delete boleto where cd_sequencial_lote = @sequencial
        
        Set @instrucao1='Após o vencimento cobrar:'
        
        if (@convenio is null or LEN(@convenio)<6) 
		Begin -- 4.0.3
		  Raiserror('Convenio deve ser informado com no minimo 6 digitos.',16,1)
		  RETURN
		End -- 4.0.3    

        Select @erro = 0 , @vl_total = 0 , @qtde=0 

		DECLARE cursor_gera_processos_impressao_mens CURSOR FOR  
		select m.cd_associado_empresa , m.cd_parcela, m.cd_tipo_pagamento, 
               m.vl_parcela+isnull(m.vl_acrescimo,0)-isnull(m.vl_desconto,0)-isnull(m.vl_imposto,0) , 
			   m.dt_vencimento as dt_vencimento , l.vl_parcela , m.cd_tipo_recebimento , 
               a.nr_cpf ,a.nm_completo, ltrim(Isnull(TL.NOME_TIPO,'')+' '+a.EndLogradouro+' '+Case When a.EndNumero is null then '' When a.endNumero=0 then '' else ', num. '+convert(varchar(10),a.endnumero) end+' '+ISNULL(a.EndComplemento,'')) , 
		       isnull(b.baiDescricao,''), a.logcep,  isnull(Cid.NM_MUNICIPIO,'') , isnull(UF.ufSigla,''),  m.nosso_numero, 
		       case when isnull(a.taxa_cobranca,1) = 1 then m.vl_taxa else 0 end , m.tp_Associado_empresa
   		  
FROM            Lote_Processos_Impressao_Mensalidades AS L INNER JOIN
                         MENSALIDADES AS M ON L.cd_parcela = M.CD_PARCELA INNER JOIN
                         ASSOCIADOS AS a ON M.CD_ASSOCIADO_empresa = a.cd_associado LEFT OUTER JOIN
                         TB_TIPOLOGRADOURO AS TL ON a.CHAVE_TIPOLOGRADOURO = TL.CHAVE_TIPOLOGRADOURO LEFT OUTER JOIN
                         Bairro AS B ON a.BaiId = B.baiId LEFT OUTER JOIN
                         MUNICIPIO AS CID ON a.CidID = CID.CD_MUNICIPIO LEFT OUTER JOIN
                         UF ON a.ufId = UF.ufId
WHERE        (L.cd_sequencial_lote = @sequencial) AND (M.TP_ASSOCIADO_EMPRESA = 1)
         union 
		select m.cd_associado_empresa , m.cd_parcela, m.cd_tipo_pagamento, 
               m.vl_parcela+isnull(m.vl_acrescimo,0)-isnull(m.vl_desconto,0)-isnull(m.vl_imposto,0) , 
               m.dt_vencimento , l.vl_parcela , m.cd_tipo_recebimento ,
               a.nr_cgc, a.nm_razsoc , ltrim(Isnull(TL.NOME_TIPO,'')+' '+a.EndLogradouro+' '+Case When a.EndNumero is null then '' When a.endNumero=0 then '' else ', num. '+convert(varchar(10),a.endnumero) end+' '+ISNULL(a.EndComplemento,'')) , 
	           isnull(b.baiDescricao,''), a.cep,  isnull(Cid.NM_MUNICIPIO,'') , isnull(UF.ufSigla,'') , m.nosso_numero, 0 , m.tp_Associado_empresa
   		  
FROM            Lote_Processos_Impressao_Mensalidades AS L INNER JOIN
                         MENSALIDADES AS M ON L.cd_parcela = M.CD_PARCELA INNER JOIN
                         EMPRESA AS a ON M.CD_ASSOCIADO_empresa = a.CD_EMPRESA LEFT OUTER JOIN
                         TB_TIPOLOGRADOURO AS TL ON a.CHAVE_TIPOLOGRADOURO = TL.CHAVE_TIPOLOGRADOURO LEFT OUTER JOIN
                         Bairro AS B ON a.BaiId = B.baiId LEFT OUTER JOIN
                         MUNICIPIO AS CID ON a.cd_municipio = CID.CD_MUNICIPIO LEFT OUTER JOIN
                         UF ON a.ufId = UF.ufId
WHERE        (L.cd_sequencial_lote = @sequencial) AND (M.TP_ASSOCIADO_EMPRESA IN (2, 3))
ORDER BY M.CD_PARCELA
		OPEN cursor_gera_processos_impressao_mens  
		FETCH NEXT FROM cursor_gera_processos_impressao_mens INTO @cd_associado_empresa,@cd_parcela ,@cd_tipo_pagamento_M, @vl_parcela_M,@dt_vencimento,
		      @vl_parcela_L,@cd_tipo_recebimento,@cpf_cnpj ,@nome, @endereco, @bairro, @cep, @cidade, @uf ,@nn,@taxa, @tp_associado_Empresa

		WHILE (@@FETCH_STATUS <> -1)  
		begin  -- 4.2        

           set @dt_vencimento_parc = @dt_vencimento
           
		   Select @instrucao2='Juros de R$ ' + convert(varchar(10),round(@vl_parcela_L*@juros/100/30*100,0)/100) + ' ao dia.'
		   Select @instrucao3='Multa de R$ ' + convert(varchar(10),round(@vl_parcela_L*@multa/100*100,0)/100) + '.'          
           
           if @cep is null 
           begin -- 4.2.0

              set @erro = 1 
			  update Lote_Processos_Impressao_Mensalidades 
                 set mensagem = 'Cep do Associado ('+ convert(varchar(20),@cd_associado_empresa) + ') invalido.'
               where cd_sequencial_lote = @sequencial and 
                     cd_parcela = @cd_parcela

           End -- 4.2.0

           if @cd_tipo_pagamento_M <> @cd_tipopagamento
			Begin -- 4.2.1
              set @erro = 1 
			  update Lote_Processos_Impressao_Mensalidades 
                 set mensagem = 'Tipo de Pagamento do Associado ('+ convert(varchar(20),@cd_associado_empresa) + ') invalido.'
               where cd_sequencial_lote = @sequencial and 
                     cd_parcela = @cd_parcela
			End -- 4.2.1

           if @vl_parcela_M <> @vl_parcela_L
			Begin -- 4.2.2
              set @erro = 1 
			  update Lote_Processos_Impressao_Mensalidades 
                 set mensagem = 'Parcela do Associado ('+ convert(varchar(20),@cd_associado_empresa) + ') diferente do Gerado.'
               where cd_sequencial_lote = @sequencial and 
                     cd_parcela = @cd_parcela
			End -- 4.2.2

           if @cd_tipo_recebimento > 0 
			Begin -- 4.2.5
              set @erro = 1 
			  update Lote_Processos_Impressao_Mensalidades 
                 set mensagem = 'Associado ('+ convert(varchar(20),@cd_associado_empresa) + ') não encontra-se com a parcela em Aberto.'
               where cd_sequencial_lote = @sequencial and 
                     cd_parcela = @cd_parcela
			End -- 4.2.5


           Set @vl_total = @vl_total + convert(int,@vl_parcela_L*100)
           Set @qtde= @qtde + 1 
           
			 Set @nn = right('000000000000'+@nn,15)
           
           Set @nn = convert(varchar(2),@carteira) + @nn + dbo.FS_CalculoModulo11(convert(varchar(2),@carteira) + @nn,4)

  		   --Set @CampoLivre = @convenio+@nn+'0'+convert(varchar(3),@carteira)
  		   Set @CampoLivre = @convenio+@convenio_dv+substring(@nn,3,3)+SUBSTRING(@nn,1,1)+substring(@nn,6,3)+SUBSTRING(@nn,2,1)+SUBSTRING(@nn,9,9)
		   Set @CampoLivre = @CampoLivre +  dbo.FS_CalculoModulo11(@CampoLivre,3)
		   	
		   Set @codbarras = right('00'+convert(varchar(3),@cd_banco),3)+ '9' + convert(varchar(4),DATEDIFF(day,'10/07/1997',@dt_vencimento_parc)) + -- Fator de Vencimento
		       right('00000000000'+Replace(convert(varchar(12),convert(int,Floor((@vl_parcela_M+@taxa)*100))),'.',''),10) + -- Valor da Parcela 
			   @CampoLivre






 --****************************************************
	   -- *****Busca Mensagens Adicionais****************
	   if @tp_associado_Empresa= 1
	   begin
			set @TipoMSG = 2
	   
			select @Fl_reajuste = COUNT(0)
			from ASSOCIADOS as a , DEPENDENTES as d, Log_reajuste as lr , reajuste as r, mensalidades as m  
			where a.cd_Associado = @cd_associado_empresa
			and a.cd_associado = d.CD_ASSOCIADO 
			and d.CD_SEQUENCIAL = lr.cd_sequencial_dep 
			and lr.id_reajuste = r.id_reajuste 
			and r.mes_assinatura = month(m.dt_vencimento) 
			and r.dt_aplicado_reajuste > DATEADD(month,-2,m.dt_vencimento) 
			and m.cd_parcela = @cd_parcela
			and m.tp_Associado_empresa = 1 
	    
	    
	        set @instrucao4 = ''
			if @Fl_reajuste> 0
			begin
				  select @MSGComplementar = 
				  SUBSTRING((
					  select top 100  t.mensagem 'data()' from TIPO_PAGAMENTO_MENSAGEM as t, mensalidades as m 
					  where t.cd_tipo_pagamento = m.cd_tipo_pagamento 
					  and m.cd_parcela = @cd_parcela
					  and t.nr_linha >= 8 
					  and t.cd_tipo_mensagem = 2 
					  order by nr_linha
				  For XML PATH ('')),
				  0, 1000)
			set @instrucao4=isnull(@instrucao4 + '','') + @MSGComplementar
			end
			
	   end
	   else
	   begin
			set @TipoMSG = 102
		   
			select @ContratoPJ = convert(varchar(10),pp.nr_contrato_plano) + ' ' + convert(varchar(100),ans.ds_classificacao) + ' REGISTRO ANS ' + convert(varchar(29),ans.cd_ans) 
			from empresa as e , reajuste as r, mensalidades as m , preco_plano as pp, planos as p , classificacao_ans as ans 
			where e.cd_empresa = @cd_associado_empresa  
			and e.CD_EMPRESA = r.cd_empresa 
			and e.CD_EMPRESA = m.CD_ASSOCIADO_empresa 
			and month(dateadd(month,1,r.dt_reajuste)) = month(m.dt_vencimento) 
			and year(dateadd(month,1,r.dt_reajuste)) = year(m.dt_vencimento) 
			and m.cd_parcela = @cd_parcela
			and m.tp_Associado_empresa = 2 
			and r.cd_sequencial_pplano = pp.cd_sequencial 
			and pp.cd_plano = p.cd_plano 
			and p.cd_classificacao = ans.cd_classificacao 
            
            set @instrucao4 = ''
            if @ContratoPJ <> ''
            begin
            select @MSGComplementar = 
				  SUBSTRING((
					  select top 100 t.mensagem 'data()' from TIPO_PAGAMENTO_MENSAGEM as t, mensalidades as m 
					  where t.cd_tipo_pagamento = m.cd_tipo_pagamento 
					  and m.cd_parcela = @cd_parcela
					  and t.nr_linha >= 8 
					  and t.cd_tipo_mensagem = 102 
					  order by nr_linha
				  For XML PATH ('')),
				  0, 1000)
		    set @instrucao4=isnull(@instrucao4 + '','') + @MSGComplementar
			end
			
	   end
	   --***************************************************
	
print '---'

print 'convenio: ' + @convenio
			print 'digto: ' + convert(varchar(5),@convenio_dv)
            print 'nn: ' + isnull(@nn,'')
            print 'campo livre: ' + isnull(@CampoLivre,'')
            print 'Codigo Br: ' + isnull(@codbarras, '')
            print 'Tamanho CodBR:' + convert(varchar(10),  isnull(Len(@codbarras),0) )
            print 'DigCodBarras: ' + convert(varchar(2),dbo.FS_DigitoVerificarCodigoBarras(@codbarras))
            print 'sequencial: ' + convert(varchar(10), @sequencial)
            print 'cd_associado_empresa: ' + convert(varchar(10),@cd_associado_empresa)
            print 'parcela: ' + convert(varchar(10),@cd_parcela)
            print 'cedente: ' + @cedente
            print 'cedente: ' + @nr_cnpj
            print 'vencimento: ' + CONVERT(varchar(10),@dt_vencimento,103)
            print 'agencia: ' + convert(varchar(10),@tp_ag)
            print 'digAg: ' + convert(varchar(1),@tp_ag_dv)
            print 'cta: ' + convert(varchar(10),@cta)
            print 'digCta: ' + convert(varchar(10),@dv_cta)
            print 'convencio: ' + convert(varchar(10),@convenio)
            print 'digConv: ' + convert(varchar(1),@convenio_dv)
            print 'carteira: ' + convert(varchar(10),@carteira)
            print 'NN: ' + @nn
            print 'valor: ' + convert(varchar(15),@vl_parcela_L)
            print 'Nome: ' + @nome
            print 'CPF/CNPJ: ' + @cpf_cnpj
            print 'Endereço: ' + @endereco
            print 'Bairro: ' + @bairro
            print 'CEP: ' + @cep
            print 'Cidade: ' + @cidade
            print 'UF: ' + @uf
            print 'multas: ' + convert(varchar(15),round(@vl_parcela_L*@multa/100*100,0)/100)
            print 'juros: ' + convert(varchar(15),round(@vl_parcela_L*@juros/100/30*100,0)/100)
            print 'inst1: ' + @instrucao1
            print 'inst2: ' + @instrucao2
            print 'inst3: ' + @instrucao3
            print 'inst4: ' + @instrucao4
            print 'LinhaDig: ' + @linhaDig1 + ' ' + @linhaDig2 + ' ' + @linhaDig3 + ' ' + @linhaDig4 + ' ' + @linhaDig5 
            print 'CodBr: ' + @codbarras
            print 'codBrVisual: ' + dbo.FG_TRADUZ_Codbarras(@codbarras)
            print 'inst5: ' + @instrucao5
            print 'inst6: ' + @instrucao6  
            
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

           print @linhaDig1
           print @linhaDig2
           print @linhaDig3
           print @linhaDig4
           print @linhaDig5                                            
			
		   Set @nn = LEFT(@nn,LEN(@nn)-1)+'-'+RIGHT(@nn,1)
		   
           insert Boleto (cd_sequencial_lote,cd_associado_empresa,cd_parcela,cedente,cnpj,
             dt_vencimento,agencia,dg_ag,conta,dg_conta,convenio,dg_convenio,carteira,
             nn,valor,pagador,cpf_cnpj_pagador,end_pagador,bai_pagador,cep_pagador,mun_pagador,
             uf_pagador,vl_multa,vl_juros,instrucao1,instrucao2,instrucao3,instrucao4,linha,barra,cod_barra,instrucao5,instrucao6)
             
           values (@sequencial,@cd_associado_empresa,@cd_parcela,@cedente,@nr_cnpj,
           CONVERT(varchar(10),@dt_vencimento,103),@tp_ag,@tp_ag_dv,@cta,@dv_cta, @convenio,@convenio_dv,@carteira,
           @nn,@vl_parcela_L,@nome,@cpf_cnpj, @endereco, @bairro, @cep, @cidade, @uf, 
           round(@vl_parcela_L*@multa/100*100,0)/100, round(@vl_parcela_L*@juros/100/30*100,0)/100,
           @instrucao1, @instrucao2, @instrucao3, @instrucao4, @linhaDig1 + ' ' + @linhaDig2 + ' ' + @linhaDig3 + ' ' + @linhaDig4 + ' ' + @linhaDig5, 
           @codbarras, dbo.FG_TRADUZ_Codbarras(@codbarras),@instrucao5,@instrucao6) 
              
           if @@ROWCOUNT = 0 
			Begin -- 3.2.6
              set @erro = 1 
			  update Lote_Processos_Impressao_Mensalidades 
                 set mensagem = 'Linha ('+ convert(varchar(20),@cd_associado_empresa) + ') invalida.'
               where cd_sequencial_lote = @sequencial and 
                     cd_parcela = @cd_parcela
			End -- 3.2.6
           
		FETCH NEXT FROM cursor_gera_processos_impressao_mens INTO @cd_associado_empresa,@cd_parcela ,@cd_tipo_pagamento_M, @vl_parcela_M,@dt_vencimento,
		      @vl_parcela_L,@cd_tipo_recebimento,@cpf_cnpj ,@nome, @endereco, @bairro, @cep, @cidade, @uf ,@nn,@taxa, @tp_associado_Empresa

        end -- 3.2
        Close cursor_gera_processos_impressao_mens
        Deallocate cursor_gera_processos_impressao_mens 

   End -- 4

    if @cd_tiposervico = 21 -- CNAB 240-BB
    Begin -- 4
    select @nsa = isnull(max(nsa)+1,1) from lote_processos_bancos where convenio = @convenio
        
        delete boleto where cd_sequencial_lote = @sequencial
        
        Set @instrucao1='Após o vencimento cobrar:'
        
        if (@convenio is null or LEN(@convenio)<>6) 
		Begin -- 4.0.3
		  Raiserror('Convenio deve ser informado com no minimo 6 digitos.',16,1)
		  RETURN
		End -- 4.0.3    

        --- Header do Arquivo
        Set @linha = right('000'+convert(varchar(3),@cd_banco),3) + '00000' + SPACE(9) + '2' + -- CÓDIGO DO BANCO, CÓDIGO DO LOTE, TIPO DE REGISTRO, BRANCOS, CÓDIGO DE INSCRIÇÃO
              right('00000000000000'+@nr_cnpj,14) + -- INSCRIÇÃO NÚMERO
              RIGHT('000000000'+@convenio,9) + -- Informar o número do convênio de cobrança, alinhado à direita com zeros à esquerda.
              '0014' + -- Informar 0014 para cobrança cedente
              RIGHT('00'+@carteira,2) + -- Informar o número da carteira de cobrança
              right('000'+@VariacaoCarteira,3) + -- Informar o número da variação da carteira de cobrança
              SPACE(2) + -- Brancos 
              right('00000'+convert(varchar(5),@tp_ag),5) + upper(@tp_ag_dv) + -- AGÊNCIA, DV
              right('000000000000'+convert(varchar(12),@cta),12) + right('0'+CONVERT(varchar(5),@dv_cta),1) + SPACE(1) + -- CONTA,DAC,BRANCOS
              convert(char(30),substring(@cedente,1,30)) +  -- NOME DA EMPRESA
              left(@nm_banco+space(30),30) + SPACE(10) + '1' + -- Nome do Banco, BRANCOS,CÓDIGO DO ARQUIVO
              replace(convert(varchar(10),getdate(),103),'/','') + -- Data de geração do arquivo (DDMMAAAA)
              replace(convert(varchar(8),getdate(),114),':','') + -- HORA DE GERAÇÃO
              '000000' +  -- N.º SEQ. ARQUIVO RET. BB Pode mandar Zero
              '040' + '00000' + space(69) 	-- LAYOUT ARQUIVO,ZEROS,BRANCOS,ZEROS,BRANCOS

        if @Linha is null or @Linha = '' 
		Begin -- 2.2.6
          set @erro = 1 
		  update Lote_Processos_Impressao_Mensalidades 
             set mensagem = 'Linha Header invalida.'
           where cd_sequencial_lote = @sequencial      
		End -- 2.2.6
			       
        Set @linha = 'ECHO ' + @linha +  '>> ' + @arquivo 
		EXEC SP_Shell @linha   
		
        -- Header do Lote 
         Set @linha = right('000'+convert(varchar(3),@cd_banco),3) + '0001' + '1R01' + Space(2) + '040' + SPACE(1) + '2' + -- CÓDIGO DO BANCO, CÓDIGO DO LOTE, TIPO DE REGISTRO, OPERAÇÃO, CÓDIGO DO SERVIÇO,ZEROS,LAYOUT DO LOTE,BRANCOS,CÓDIGO DE INSCRIÇÃO
              right('000000000000000'+@nr_cnpj,15) + -- INSCRIÇÃO NÚMERO,
              RIGHT('000000'+@convenio,9) + -- Informar o número do convênio de cobrança, alinhado à direita com zeros à esquerda.
              '0014' + -- Informar 0014 para cobrança cedente
              RIGHT('00'+@carteira,2) + -- Informar o número da carteira de cobrança
              right('000'+@VariacaoCarteira,3) + -- Informar o número da variação da carteira de cobrança
              SPACE(2) + -- Brancos
              right('00000'+convert(varchar(5),@tp_ag),5) + upper(right('0'+CONVERT(varchar(5),@tp_ag_dv),1)) + --  AGÊNCIA, DV Agencia 
              right('000000000000'+convert(varchar(12),@cta),12) + upper(right('0'+CONVERT(varchar(5),@dv_cta),1)) + '0' +-- CONTA,DAC, zero  
              convert(char(30),substring(@cedente,1,30)) +  -- NOME DA EMPRESA
              SPACE(80) + right('00000000',8) + -- BRANCOS,N.º SEQ. ARQUIVO RET.
              replace(convert(varchar(10),getdate(),103),'/','') + -- Data de geração do arquivo (DDMMAA)
              '00000000' + -- DATA DE CRÉDITO
              space(33)	-- BRANCOS
              
         if @Linha is null or @Linha = '' 
		Begin -- 2.2.6
          set @erro = 1 
		  update Lote_Processos_Impressao_Mensalidades 
             set mensagem = 'Linha Header do Lote invalida.'
           where cd_sequencial_lote = @sequencial      
		End -- 2.2.6
			       
        Set @linha = 'ECHO ' + @linha +  '>> ' + @arquivo 
		EXEC SP_Shell @linha 		              
              
        Select @erro = 0 , @vl_total = 0 , @qtde=0 

		DECLARE cursor_gera_processos_impressao_mens CURSOR FOR  
		select m.cd_associado_empresa , m.cd_parcela, m.cd_tipo_pagamento, 
               m.vl_parcela+isnull(m.vl_acrescimo,0)-isnull(m.vl_desconto,0)-isnull(m.vl_imposto,0) , 
			   m.dt_vencimento as dt_vencimento , l.vl_parcela , m.cd_tipo_recebimento , 
               a.nr_cpf ,a.nm_completo, ltrim(Isnull(TL.NOME_TIPO,'')+' '+a.EndLogradouro+' '+Case When a.EndNumero is null then '' When a.endNumero=0 then '' else ', num. '+convert(varchar(10),a.endnumero) end+' '+ISNULL(a.EndComplemento,'')) , 
		       isnull(b.baiDescricao,''), a.logcep,  isnull(Cid.NM_MUNICIPIO,'') , isnull(UF.ufSigla,''),  m.nosso_numero, 
		       case when isnull(a.taxa_cobranca,1) = 1 then m.vl_taxa else 0 end , m.tp_Associado_empresa
   		  
FROM            Lote_Processos_Impressao_Mensalidades AS L INNER JOIN
                         MENSALIDADES AS M ON L.cd_parcela = M.CD_PARCELA INNER JOIN
                         ASSOCIADOS AS a ON M.CD_ASSOCIADO_empresa = a.cd_associado LEFT OUTER JOIN
                         TB_TIPOLOGRADOURO AS TL ON a.CHAVE_TIPOLOGRADOURO = TL.CHAVE_TIPOLOGRADOURO LEFT OUTER JOIN
                         Bairro AS B ON a.BaiId = B.baiId LEFT OUTER JOIN
                         MUNICIPIO AS CID ON a.CidID = CID.CD_MUNICIPIO LEFT OUTER JOIN
                         UF ON a.ufId = UF.ufId
WHERE        (L.cd_sequencial_lote = @sequencial) AND (M.TP_ASSOCIADO_EMPRESA = 1)
         union 
		select m.cd_associado_empresa , m.cd_parcela, m.cd_tipo_pagamento, 
               m.vl_parcela+isnull(m.vl_acrescimo,0)-isnull(m.vl_desconto,0)-isnull(m.vl_imposto,0) , 
               m.dt_vencimento , l.vl_parcela , m.cd_tipo_recebimento ,
               a.nr_cgc, a.nm_razsoc , ltrim(Isnull(TL.NOME_TIPO,'')+' '+a.EndLogradouro+' '+Case When a.EndNumero is null then '' When a.endNumero=0 then '' else ', num. '+convert(varchar(10),a.endnumero) end+' '+ISNULL(a.EndComplemento,'')) , 
	           isnull(b.baiDescricao,''), a.cep,  isnull(Cid.NM_MUNICIPIO,'') , isnull(UF.ufSigla,'') , m.nosso_numero, 0 , m.tp_Associado_empresa
   		  
FROM            Lote_Processos_Impressao_Mensalidades AS L INNER JOIN
                         MENSALIDADES AS M ON L.cd_parcela = M.CD_PARCELA INNER JOIN
                         EMPRESA AS a ON M.CD_ASSOCIADO_empresa = a.CD_EMPRESA LEFT OUTER JOIN
                         TB_TIPOLOGRADOURO AS TL ON a.CHAVE_TIPOLOGRADOURO = TL.CHAVE_TIPOLOGRADOURO LEFT OUTER JOIN
                         Bairro AS B ON a.BaiId = B.baiId LEFT OUTER JOIN
                         MUNICIPIO AS CID ON a.cd_municipio = CID.CD_MUNICIPIO LEFT OUTER JOIN
                         UF ON a.ufId = UF.ufId
WHERE        (L.cd_sequencial_lote = @sequencial) AND (M.TP_ASSOCIADO_EMPRESA IN (2, 3))
ORDER BY M.CD_PARCELA
		OPEN cursor_gera_processos_impressao_mens  
		FETCH NEXT FROM cursor_gera_processos_impressao_mens INTO @cd_associado_empresa,@cd_parcela ,@cd_tipo_pagamento_M, @vl_parcela_M,@dt_vencimento,
		      @vl_parcela_L,@cd_tipo_recebimento,@cpf_cnpj ,@nome, @endereco, @bairro, @cep, @cidade, @uf ,@nn,@taxa, @tp_associado_Empresa

		WHILE (@@FETCH_STATUS <> -1)  
		begin  -- 4.2 
           
           if @cep is null 
           begin -- 4.2.0

              set @erro = 1 
			  update Lote_Processos_Impressao_Mensalidades 
                 set mensagem = 'Cep do Associado ('+ convert(varchar(20),@cd_associado_empresa) + ') invalido.'
               where cd_sequencial_lote = @sequencial and 
                     cd_parcela = @cd_parcela

           End -- 4.2.0

           if @cd_tipo_pagamento_M <> @cd_tipopagamento
			Begin -- 4.2.1
              set @erro = 1 
			  update Lote_Processos_Impressao_Mensalidades 
                 set mensagem = 'Tipo de Pagamento do Associado ('+ convert(varchar(20),@cd_associado_empresa) + ') invalido.'
               where cd_sequencial_lote = @sequencial and 
                     cd_parcela = @cd_parcela
			End -- 4.2.1

           if @vl_parcela_M <> @vl_parcela_L
			Begin -- 4.2.2
              set @erro = 1 
			  update Lote_Processos_Impressao_Mensalidades 
                 set mensagem = 'Parcela do Associado ('+ convert(varchar(20),@cd_associado_empresa) + ') diferente do Gerado.'
               where cd_sequencial_lote = @sequencial and 
                     cd_parcela = @cd_parcela
			End -- 4.2.2

           if @cd_tipo_recebimento > 0 
			Begin -- 4.2.5
              set @erro = 1 
			  update Lote_Processos_Impressao_Mensalidades 
                 set mensagem = 'Associado ('+ convert(varchar(20),@cd_associado_empresa) + ') não encontra-se com a parcela em Aberto.'
               where cd_sequencial_lote = @sequencial and 
                     cd_parcela = @cd_parcela
			End -- 4.2.5
        
	--SEGMENTO P
           Set @linha = right('000'+convert(varchar(3),@cd_banco),3) + '0001' + '3' + right('00000'+convert(varchar(10),@qtde*3+1),5) + 'P' + SPACE(1) + -- CÓDIGO DO BANCO, CÓDIGO DO LOTE,TIPO DE REGISTRO,N.º DO REGISTRO,SEGMENTO
               '01' + -- CÓD. DE OCORRÊNCIA (Códigos de Movimento para Remessa tratados pelo Banco do Brasil: 01 – Entrada de títulos, 02 – Pedido de
						--baixa, 04 – Concessão de Abatimento, 05 – Cancelamento de Abatimento, 06 – Alteração de Vencimento, 07
						--– Concessão de Desconto, 08 – Cancelamento de Desconto, 09 – Protestar, 10 – Cancela/Sustação da
						--Instrução de protesto, 30 – Recusa da Alegação do Sacado, 31 – Alteração de Outros Dados, 40 – Alteração
						--de Modalidade.)
               RIGHT('00000'+convert(varchar(5),@tp_ag),5) + upper(right('0'+convert(varchar(1),@tp_ag_dv),1)) + -- Agencia e DV  
               RIGHT('00000000000000'+convert(varchar(12),@cta),12) + right('0'+convert(varchar(1),@dv_cta),1) + SPACE(1) + --- Conta e Digito
               right('0000000'+convert(varchar(30),@convenio),7) + Right('0000000000'+convert(varchar(10),@nn),10) + SPACE(3) +
               --dbo.FS_CalculoModulo11_BB(right('000000'+convert(varchar(30),@convenio),6) + Right('00000'+convert(varchar(10),@cd_parcela),5)) + -- DigitoVerificador
               '7' + Space(4) + --COD CARTEIRA; FORMA DE CADASTRO; TIPO DOCUMENTO; IDENT EMISSAO; IDENT DIST
               Right('0000000000'+convert(varchar(10),@cd_parcela),10) + Space(5) + -- N.º DO DOCUMENTO
               replace(convert(varchar(10),@dt_vencimento,103),'/','') + -- Vencimento 
               right('00000000000000000'+convert(varchar(13),convert(int,Floor(@vl_parcela_L*100))),15) + -- Valor do débito  
               '00000 04N' + 
               replace(convert(varchar(10),GETDATE(),103),'/','') + -- Emissao 
               '3' + replace(convert(varchar(10),@dt_vencimento,103),'/','') + -- DATA JUROS MORA
               right('0000000000000'+replace(CONVERT(varchar(10), round(@vl_parcela_L*@juros/100/30*100,0)/100),'.',''),15) + '0' + -- JUROS DE 1 DIA
               '00000000' + '000000000000000' + '000000000000000' + '000000000000000' +   --Data do Desconto 1 , Desconto 1 Valor, Valor do IOF, Valor do Abatimento 
               Right('000000000000000000000000000'+convert(varchar(10),@cd_parcela),25) + '3' + '00' + '0' +-- USO DA EMPRESA, CÓDIGO P/ NEGATIVAÇÃO OU PROTESTO,PRAZO PARA NEGATIVAÇÃO OU PROTESTO  
               '000' + '09' + '0000000000' + SPACE(1)   
               
  		    if @Linha is null or @Linha = '' 
			Begin -- 2.2.6
			  set @erro = 1 
			  update Lote_Processos_Impressao_Mensalidades 
				 set mensagem = 'Linha ('+ convert(varchar(20),@cd_associado_empresa) + ') invalida.'
			   where cd_sequencial_lote = @sequencial and 
					 cd_parcela = @cd_parcela               
			End -- 2.2.6
		
 		   Set @linha = 'ECHO ' + @linha + '>> ' + @arquivo 
		   EXEC SP_Shell @linha
		   
--LINHA Q
    	   Set @linha = right('000'+convert(varchar(3),@cd_banco),3) + '00013' + right('00000'+convert(varchar(10),@qtde*3+2),5) + 'Q' + SPACE(1) + '01' + -- CÓDIGO DO BANCO, CÓDIGO DO LOTE, TIPO DE REGISTRO, OPERAÇÃO, CÓDIGO DO SERVIÇO,ZEROS,LAYOUT DO LOTE,BRANCOS,CÓDIGO DE INSCRIÇÃO
              case when len(@cpf_cnpj)<=11 then '1' else '2' end + right('0000000'+@cpf_cnpj,15) + -- CÓDIGO DE INSCRIÇÃO, INSCRIÇÃO NÚMERO
              left(@nome + SPACE(40),40) + 
              left(@endereco+Space(40),40) + 
              left(@bairro+Space(15),15) + 
              left(@cep+'00000000',8) + 
              left(@cidade+Space(15),15) + 
              Left(@uf +Space(2),2) + 
              '0' + '000000000000000' + SPACE(40) + '000' + SPACE(28)
                
			if @Linha is null or @Linha = '' 
			Begin -- 2.2.6
			  set @erro = 1 
			  update Lote_Processos_Impressao_Mensalidades 
				 set mensagem = 'Linha ('+ convert(varchar(20),@cd_associado_empresa) + ') invalida.'
			   where cd_sequencial_lote = @sequencial and 
					 cd_parcela = @cd_parcela               
			End -- 2.2.6
			
		   Set @linha = 'ECHO ' + @linha + '>> ' + @arquivo 
		   EXEC SP_Shell @linha   
		   

  --LINHA R
    	   Set @linha = right('000'+convert(varchar(3),@cd_banco),3) + '00013' + right('00000'+convert(varchar(10),@qtde*3+3),5) + 'R' + SPACE(1) + '010' + -- CÓDIGO DO BANCO, CÓDIGO DO LOTE, TIPO DE REGISTRO, OPERAÇÃO, CÓDIGO DO SERVIÇO,ZEROS,LAYOUT DO LOTE,BRANCOS,CÓDIGO DE INSCRIÇÃO
              '00000000' + '000000000000000' + '0' + -- DATA 2º DESCONTO,VALOR 2º DESCONTO,ZEROS
              '00000000' + '000000000000000' + '0' + -- DATA 3º DESCONTO,VALOR 3º DESCONTO
              replace(convert(varchar(10),dateadd(day,1,@dt_vencimento),103),'/','') + --Data da Multa 
              right('000000000000000'+replace(CONVERT(varchar(10), round(@vl_parcela_L*@multa/100*100,0)/100),'.',''),15) + --Valor/Percentual a Ser Aplicado
              Space(110) + '0000000000000000' + SPACE(1) + '000000000000' + Space(2) + '0' + Space(9)
                
			if @Linha is null or @Linha = '' 
			Begin -- 2.2.6
			  set @erro = 1 
			  update Lote_Processos_Impressao_Mensalidades 
				 set mensagem = 'Linha ('+ convert(varchar(20),@cd_associado_empresa) + ') invalida.'
			   where cd_sequencial_lote = @sequencial and 
					 cd_parcela = @cd_parcela               
			End -- 2.2.6
			
		   Set @linha = 'ECHO ' + @linha + '>> ' + @arquivo 
		   EXEC SP_Shell @linha   
		   

		   set @dt_vencimento_parc = @dt_vencimento
           
		   Select @instrucao2='Juros de R$ ' + convert(varchar(10),round(@vl_parcela_L*@juros/100/30*100,0)/100) + ' ao dia.'
		   Select @instrucao3='Multa de R$ ' + convert(varchar(10),round(@vl_parcela_L*@multa/100*100,0)/100) + '.'          


           Set @vl_total = @vl_total + convert(int,@vl_parcela_L*100)
           Set @qtde= @qtde + 1 
           
		   
  		   Set @CampoLivre = @nn +  right('0000' + @tp_ag,4) + right('00000000' +@cta,8) + convert(varchar(2),@carteira) --@convenio+substring(@nn,3,3)+SUBSTRING(@nn,1,1)+substring(@nn,6,3)+SUBSTRING(@nn,2,1)+SUBSTRING(@nn,9,9)
				   	
		   Set @codbarras = right('00'+convert(varchar(3),@cd_banco),3)+ '9' + convert(varchar(4),DATEDIFF(day,'10/07/1997',@dt_vencimento_parc)) + -- Fator de Vencimento
		       right('00000000000'+Replace(convert(varchar(12),convert(int,Floor((@vl_parcela_M+@taxa)*100))),'.',''),10) + -- Valor da Parcela 
			   @CampoLivre

            
            
            
             --****************************************************
	   -- *****Busca Mensagens Adicionais****************
	   if @tp_associado_Empresa= 1
	   begin
			set @TipoMSG = 2
	   
			select @Fl_reajuste = COUNT(0)
			from ASSOCIADOS as a , DEPENDENTES as d, Log_reajuste as lr , reajuste as r, mensalidades as m  
			where a.cd_Associado = @cd_associado_empresa
			and a.cd_associado = d.CD_ASSOCIADO 
			and d.CD_SEQUENCIAL = lr.cd_sequencial_dep 
			and lr.id_reajuste = r.id_reajuste 
			and r.mes_assinatura = month(m.dt_vencimento) 
			and r.dt_aplicado_reajuste > DATEADD(month,-2,m.dt_vencimento) 
			and m.cd_parcela = @cd_parcela
			and m.tp_Associado_empresa = 1 
	    
			if @Fl_reajuste> 0
			begin
				  select @MSGComplementar = 
				  SUBSTRING((
					  select top 100  t.mensagem 'data()' from TIPO_PAGAMENTO_MENSAGEM as t, mensalidades as m 
					  where t.cd_tipo_pagamento = m.cd_tipo_pagamento 
					  and m.cd_parcela = @cd_parcela
					  and t.nr_linha >= 8 
					  and t.cd_tipo_mensagem = 2 
					  order by nr_linha
				  For XML PATH ('')),
				  0, 1000)
			end
			set @instrucao4=isnull(@instrucao4 + ' ','') + @MSGComplementar
	   end
	   else
	   begin
			set @TipoMSG = 102
		   
			select @ContratoPJ = convert(varchar(10),pp.nr_contrato_plano) + ' ' + convert(varchar(100),ans.ds_classificacao) + ' REGISTRO ANS ' + convert(varchar(29),ans.cd_ans) 
			from empresa as e , reajuste as r, mensalidades as m , preco_plano as pp, planos as p , classificacao_ans as ans 
			where e.cd_empresa = @cd_associado_empresa  
			and e.CD_EMPRESA = r.cd_empresa 
			and e.CD_EMPRESA = m.CD_ASSOCIADO_empresa 
			and month(dateadd(month,1,r.dt_reajuste)) = month(m.dt_vencimento) 
			and year(dateadd(month,1,r.dt_reajuste)) = year(m.dt_vencimento) 
			and m.cd_parcela = @cd_parcela
			and m.tp_Associado_empresa = 2 
			and r.cd_sequencial_pplano = pp.cd_sequencial 
			and pp.cd_plano = p.cd_plano 
			and p.cd_classificacao = ans.cd_classificacao 
            
            if @ContratoPJ <> ''
            begin
            select @MSGComplementar = 
				  SUBSTRING((
					  select top 100 t.mensagem 'data()' from TIPO_PAGAMENTO_MENSAGEM as t, mensalidades as m 
					  where t.cd_tipo_pagamento = m.cd_tipo_pagamento 
					  and m.cd_parcela = @cd_parcela
					  and t.nr_linha >= 8 
					  and t.cd_tipo_mensagem = 102 
					  order by nr_linha
				  For XML PATH ('')),
				  0, 1000)
			end
			set @instrucao3=@instrucao3 + ' ' + @MSGComplementar
	   end
	   --***************************************************
	
	
			Set @codbarras = left(@codbarras,4) + dbo.FS_DigitoVerificarCodigoBarras(@codbarras) + right(@codbarras,39)
			 
			Set @linhaDig1 = left(@codbarras,4) + left(@CampoLivre,5) 
			Set @linhaDig1 = left(@linhaDig1,5) + '.' + right(@linhaDig1,4) + dbo.FS_CalculoModulo10(@linhaDig1) 
            
			Set @linhaDig2 = substring(@CampoLivre,6,10) 
			Set @linhaDig2 = left(@linhaDig2,5) + '.' + right(@linhaDig2,5) + dbo.FS_CalculoModulo10(@linhaDig2) 

			Set @linhaDig3 = substring(@CampoLivre,16,10) 
			Set @linhaDig3 = left(@linhaDig3,5) + '.' + right(@linhaDig3,5) + dbo.FS_CalculoModulo10(@linhaDig3) 

			Set @linhaDig4 = substring(@codbarras,5,1)

			Set @linhaDig5 = substring(@codbarras,6,14)

			
print '---'
			print @vl_total
			print 'Agencia: ' + convert(varchar(10),@tp_ag)
			print 'digAgencia: ' + convert(varchar(1),@tp_ag_dv)
			print 'NN: ' + @nn
			print 'vencimento: ' + convert(varchar(10),@dt_vencimento_parc, 103)
			print 'convenio: ' + @convenio
			print 'nn33 '+substring(@nn,3,3)
			print 'nn11 '+SUBSTRING(@nn,1,1)
			print 'nn63 '+substring(@nn,6,3)
			print 'nn21 '+SUBSTRING(@nn,2,1)
			print 'nn99 '+SUBSTRING(@nn,9,9)
			print 'Modulo11 ' + dbo.FS_CalculoModulo11(@CampoLivre,3)
            print 'Campo Livre: ' + isnull(@CampoLivre,'')
            print 'Codigo de barras: ' + isnull(@codbarras,'')
            print 'Tam. Cod Barras: ' + isnull(convert(varchar(5),Len(@codbarras)),'')
            print 'Dig. Cod Barras: ' + dbo.FS_DigitoVerificarCodigoBarras(@codbarras)
print '---' 

           print @linhaDig1
           print @linhaDig2
           print @linhaDig3
           print @linhaDig4
           print @linhaDig5                                            
			
		   Set @nn = @nn +'-'+ dbo.FS_CalculoModulo11_BNB(@nn)
		
				
		 insert Boleto (cd_sequencial_lote,cd_associado_empresa,cd_parcela,cedente,cnpj,
             dt_vencimento,agencia,dg_ag,conta,dg_conta,convenio,dg_convenio,carteira,
             nn,valor,pagador,cpf_cnpj_pagador,end_pagador,bai_pagador,cep_pagador,mun_pagador,
             uf_pagador,vl_multa,vl_juros,instrucao1,instrucao2,instrucao3,instrucao4,linha,barra,cod_barra,instrucao5,instrucao6)
             
           values (@sequencial,@cd_associado_empresa,@cd_parcela,@cedente,@nr_cnpj,
           CONVERT(varchar(10),@dt_vencimento,103),@tp_ag,@tp_ag_dv,@cta,@dv_cta, @convenio,@convenio_dv,@carteira,
           @nn,@vl_parcela_L,@nome,@cpf_cnpj, @endereco, @bairro, @cep, @cidade, @uf, 
           round(@vl_parcela_L*@multa/100*100,0)/100, round(@vl_parcela_L*@juros/100/30*100,0)/100,
           @instrucao1, @instrucao2, @instrucao3, @instrucao4, @linhaDig1 + ' ' + @linhaDig2 + ' ' + @linhaDig3 + ' ' + @linhaDig4 + ' ' + @linhaDig5, 
           @codbarras, dbo.FG_TRADUZ_Codbarras(@codbarras),@instrucao5,@instrucao6) 
              
           if @@ROWCOUNT = 0 
			Begin -- 3.2.6
              set @erro = 1 
			  update Lote_Processos_Impressao_Mensalidades 
                 set mensagem = 'Linha ('+ convert(varchar(20),@cd_associado_empresa) + ') invalida.'
               where cd_sequencial_lote = @sequencial and 
                     cd_parcela = @cd_parcela
			End -- 3.2.6
           
		FETCH NEXT FROM cursor_gera_processos_impressao_mens INTO @cd_associado_empresa,@cd_parcela ,@cd_tipo_pagamento_M, @vl_parcela_M,@dt_vencimento,
		      @vl_parcela_L,@cd_tipo_recebimento,@cpf_cnpj ,@nome, @endereco, @bairro, @cep, @cidade, @uf ,@nn,@taxa, @tp_associado_Empresa

        end -- 3.2
        Close cursor_gera_processos_impressao_mens
        Deallocate cursor_gera_processos_impressao_mens 
        

        --- Header do Lote
        Set @linha = right('000'+convert(varchar(3),@cd_banco),3) + '00015' + SPACE(9)+RIGHT('000000'+convert(varchar(6),@qtde*3+2),6) +
             SPACE(217)
             --RIGHT('000000'+convert(varchar(6),@qtde),6) + right('00000000000000000'+convert(varchar(15),convert(int,Floor(@vl_total*100))),17) +
             --'000000' + '00000000000000000' + '0000000000000000000000000000000000000000000000' + SPACE(8) + SPACE(117)

			if @Linha is null or @Linha = '' 
			Begin -- 2.2.6
			  set @erro = 1 
			  update Lote_Processos_Impressao_Mensalidades 
				 set mensagem = 'Linha ('+ convert(varchar(20),@cd_associado_empresa) + ') invalida.'
			   where cd_sequencial_lote = @sequencial and 
					 cd_parcela = @cd_parcela               
			End -- 2.2.6
			
		   Set @linha = 'ECHO ' + @linha + '>> ' + @arquivo 
		   EXEC SP_Shell @linha   
		           
        --- Header do Arquivo
        Set @linha = right('000'+convert(varchar(3),@cd_banco),3) + '99999' + SPACE(9) + '000001' +RIGHT('000000'+convert(varchar(6),@qtde*3+4),6) + 
           '000000' + SPACE(205)
        
        if @Linha is null or @Linha = '' 
		Begin -- 2.2.6
          set @erro = 1 
		  update Lote_Processos_Impressao_Mensalidades 
             set mensagem = 'Linha Trailler invalida.'
           where cd_sequencial_lote = @sequencial      
		End -- 2.2.6
        
        Set @linha = 'ECHO ' + @linha +  '>> ' + @arquivo 
		EXEC SP_Shell @linha             

 End -- 4

             
--###################### CNAB 240 CEF ######################
	if @cd_tiposervico = 44 -- CNAB 240
		Begin -- 4

        select @nsa = isnull(max(nsa)+1,1) from lote_processos_bancos where convenio = @convenio
        
        delete boleto where cd_sequencial_lote = @sequencial
        
        Set @instrucao1='Após o vencimento cobrar:'
        
        if (@convenio is null or LEN(@convenio)<6) 
		Begin -- 4.0.3
		  Raiserror('Convenio deve ser informado com no minimo 6 digitos.',16,1)
		  RETURN
		End -- 4.0.3    

        Select @erro = 0 , @vl_total = 0 , @qtde=0 
        
        --- HEADER
		  Set @linha = right('000'+convert(varchar(3),@cd_banco),3) + -- Codigo do Banco 
		  '00000' + SPACE(9) + case when LEN(@nr_cnpj)>11 then '2' else '1' end +  
		  right('00000000000000'+convert(varchar(14),@nr_cnpj),14) + --num inscricao
		  '0000000000'+'0000000000' + 
		  RIGHT('00000'+convert(varchar(5),@tp_ag),5) + upper(@tp_ag_dv) + -- AGÊNCIA + DV
		  RIGHT('000000000'+@convenio,6) + '00000000' + --convenio + zeros
		  convert(char(30),substring(@cedente,1,30)) + --Nome do Cedente  
		  convert(char(30),substring(@nm_banco,1,30)) + -- Nome do Banco  
		  SPACE(10) + '1' +
		  left(replace(convert(varchar(10),getdate(),103),'/',''),8) + --Data  do Processamento
          replace(convert(varchar(8),getdate(),114),':','') + -- Hora do Processamento 
		  right('000000'+convert(varchar(14),@nsa),6) + --num inscricao
		  '05000000' +
		  SPACE(20) + 
		  'REMESSA-PRODUCAO    ' +
		  SPACE(29)
		  
		  Set @linha = 'ECHO ' + @linha + '>> ' + @arquivo   
		  EXEC SP_Shell @linha    
	  --- FIM HEADER      

	  -- Header do Lote    
		Set @linha =  right('000'+convert(varchar(3),@cd_banco),3) + -- Codigo do Banco    
				   '00011R01' + -- Lote de Servico, Tipo de Registro, Tipo de Operação , tipo de serviço   
				   '00030 ' + -- Uso Exclusivo FEBRABAN/CNAB//Nº da Versão do Layout do Lote//Uso Exclusivo FEBRABAN/CNAB//    
				   case when LEN(@nr_cnpj)>11 then '2' else '1' end +  
				   right('00000000000000'+convert(varchar(14),@nr_cnpj),15) + --num inscricao
				   Right('000'+@convenio,6)+'00000000000000' + -- convenio + Uso Exclusivo CAIXA    
				   right('00000'+@tp_ag,5) + upper(@tp_ag_dv) + -- Agência Mantenedora da Conta // Dígito Verificador da Agência    
				   Right('000'+@convenio,6)+ -- convenio + Uso Exclusivo CAIXA 
				   '0000000' + --modelo boleto
				   '0' + 
				   convert(char(30),substring(@cedente,1,30)) +  -- Nome do Cedente    
				   Space(80) + -- Mensagem 1//Mensagem 2    
				   right('00000000'+convert(varchar(8),@nsa),8) + -- Número sequencial do arquivo (NSA)    
				   replace(convert(varchar(10),getdate(),103),'/','') + -- Data da Geração do Arquivo    
				   '00000000' + Space(33) -- Data do Crédito // Uso Exclusivo FEBRABAN/CNAB    
	            
			Set @linha = 'ECHO ' + @linha +  '>> ' + @arquivo     
			EXEC SP_Shell @linha    

		DECLARE cursor_gera_processos_impressao_mens CURSOR FOR  
		select m.cd_associado_empresa , m.cd_parcela, m.cd_tipo_pagamento, 
               m.vl_parcela+isnull(m.vl_acrescimo,0)-isnull(m.vl_desconto,0)-isnull(m.vl_imposto,0) , 
			   m.dt_vencimento as dt_vencimento , l.vl_parcela , m.cd_tipo_recebimento , 
               a.nr_cpf ,a.nm_completo, ltrim(Isnull(TL.NOME_TIPO,'')+' '+a.EndLogradouro+' '+Case When a.EndNumero is null then '' When a.endNumero=0 then '' else ', num. '+convert(varchar(10),a.endnumero) end+' '+ISNULL(a.EndComplemento,'')) , 
		       isnull(b.baiDescricao,''), a.logcep,  isnull(Cid.NM_MUNICIPIO,'') , isnull(UF.ufSigla,''),  m.nosso_numero, 
		       case when isnull(a.taxa_cobranca,1) = 1 then m.vl_taxa else 0 end , m.tp_Associado_empresa
   		  
FROM            Lote_Processos_Impressao_Mensalidades AS L INNER JOIN
                         MENSALIDADES AS M ON L.cd_parcela = M.CD_PARCELA INNER JOIN
                         ASSOCIADOS AS a ON M.CD_ASSOCIADO_empresa = a.cd_associado LEFT OUTER JOIN
                         TB_TIPOLOGRADOURO AS TL ON a.CHAVE_TIPOLOGRADOURO = TL.CHAVE_TIPOLOGRADOURO LEFT OUTER JOIN
                         Bairro AS B ON a.BaiId = B.baiId LEFT OUTER JOIN
                         MUNICIPIO AS CID ON a.CidID = CID.CD_MUNICIPIO LEFT OUTER JOIN
                         UF ON a.ufId = UF.ufId
WHERE        (L.cd_sequencial_lote = @sequencial) AND (M.TP_ASSOCIADO_EMPRESA = 1)
         union 
		select m.cd_associado_empresa , m.cd_parcela, m.cd_tipo_pagamento, 
               m.vl_parcela+isnull(m.vl_acrescimo,0)-isnull(m.vl_desconto,0)-isnull(m.vl_imposto,0) , 
               m.dt_vencimento , l.vl_parcela , m.cd_tipo_recebimento ,
               a.nr_cgc, a.nm_razsoc , ltrim(Isnull(TL.NOME_TIPO,'')+' '+a.EndLogradouro+' '+Case When a.EndNumero is null then '' When a.endNumero=0 then '' else ', num. '+convert(varchar(10),a.endnumero) end+' '+ISNULL(a.EndComplemento,'')) , 
	           isnull(b.baiDescricao,''), a.cep,  isnull(Cid.NM_MUNICIPIO,'') , isnull(UF.ufSigla,'') , m.nosso_numero, 0 , m.tp_Associado_empresa
   		  
FROM            Lote_Processos_Impressao_Mensalidades AS L INNER JOIN
                         MENSALIDADES AS M ON L.cd_parcela = M.CD_PARCELA INNER JOIN
                         EMPRESA AS a ON M.CD_ASSOCIADO_empresa = a.CD_EMPRESA LEFT OUTER JOIN
                         TB_TIPOLOGRADOURO AS TL ON a.CHAVE_TIPOLOGRADOURO = TL.CHAVE_TIPOLOGRADOURO LEFT OUTER JOIN
                         Bairro AS B ON a.BaiId = B.baiId LEFT OUTER JOIN
                         MUNICIPIO AS CID ON a.cd_municipio = CID.CD_MUNICIPIO LEFT OUTER JOIN
                         UF ON a.ufId = UF.ufId
WHERE        (L.cd_sequencial_lote = @sequencial) AND (M.TP_ASSOCIADO_EMPRESA IN (2, 3))
ORDER BY M.CD_PARCELA
		OPEN cursor_gera_processos_impressao_mens  
		FETCH NEXT FROM cursor_gera_processos_impressao_mens INTO @cd_associado_empresa,@cd_parcela ,@cd_tipo_pagamento_M, @vl_parcela_M,@dt_vencimento,
		      @vl_parcela_L,@cd_tipo_recebimento,@cpf_cnpj ,@nome, @endereco, @bairro, @cep, @cidade, @uf ,@nn,@taxa, @tp_associado_Empresa

		WHILE (@@FETCH_STATUS <> -1)  
		begin  -- 4.2        

           set @dt_vencimento_parc = @dt_vencimento
           
		   Select @instrucao2='Juros de R$ ' + convert(varchar(10),round(@vl_parcela_L*@juros/100/30*100,0)/100) + ' ao dia.'
		   Select @instrucao3='Multa de R$ ' + convert(varchar(10),round(@vl_parcela_L*@multa/100*100,0)/100) + '.'          
           
           if @cep is null 
           begin -- 4.2.0

              set @erro = 1 
			  update Lote_Processos_Impressao_Mensalidades 
                 set mensagem = 'Cep do Associado ('+ convert(varchar(20),@cd_associado_empresa) + ') invalido.'
               where cd_sequencial_lote = @sequencial and 
                     cd_parcela = @cd_parcela

           End -- 4.2.0

           if @cd_tipo_pagamento_M <> @cd_tipopagamento
			Begin -- 4.2.1
              set @erro = 1 
			  update Lote_Processos_Impressao_Mensalidades 
                 set mensagem = 'Tipo de Pagamento do Associado ('+ convert(varchar(20),@cd_associado_empresa) + ') invalido.'
               where cd_sequencial_lote = @sequencial and 
                     cd_parcela = @cd_parcela
			End -- 4.2.1

           if @vl_parcela_M <> @vl_parcela_L
			Begin -- 4.2.2
              set @erro = 1 
			  update Lote_Processos_Impressao_Mensalidades 
                 set mensagem = 'Parcela do Associado ('+ convert(varchar(20),@cd_associado_empresa) + ') diferente do Gerado.'
               where cd_sequencial_lote = @sequencial and 
                     cd_parcela = @cd_parcela
			End -- 4.2.2

           if @cd_tipo_recebimento > 0 
			Begin -- 4.2.5
              set @erro = 1 
			  update Lote_Processos_Impressao_Mensalidades 
                 set mensagem = 'Associado ('+ convert(varchar(20),@cd_associado_empresa) + ') não encontra-se com a parcela em Aberto.'
               where cd_sequencial_lote = @sequencial and 
                     cd_parcela = @cd_parcela
			End -- 4.2.5

			if @nn is null
			Begin -- 4.2.5
              set @erro = 1 
			  update Lote_Processos_Impressao_Mensalidades 
                 set mensagem = 'Parcela do Associado ('+ convert(varchar(20),@cd_associado_empresa) + ') não tem Nosso Numero gerado.'
               where cd_sequencial_lote = @sequencial and 
                     cd_parcela = @cd_parcela
			End -- 4.2.5

           Set @vl_total = @vl_total + convert(int,@vl_parcela_L*100)
           Set @qtde= @qtde + 1 
           
           
        -- Linha P
		Set @linha = right('000'+convert(varchar(3),@cd_banco),3) + -- Codigo do Banco    
				   '00013'+ right('00000'+convert(varchar(5),(@qtde-1)*3+1),5)+'P' + -- Lote de Servico, Tipo de Registro, Nº Sequencial do Registro no Lote,Cód. Segmento do Registro Detalhe
				   space(1) + '01' +  -- espaços + Código de Movimento Remessa    
				   right('00000'+@tp_ag,5) + upper(@tp_ag_dv) + -- Agência Mantenedora da Conta // Dígito Verificador da Agência    
				   Right('000'+@convenio,6)+'00000000000' + -- convenio + Uso Exclusivo CAIXA    
				   case when @carteira='1' then right('00'+convert(varchar(2),@carteira),2) + right('00000000000000'+convert(varchar(14),@nn),14)+'0'     
                              when @carteira in ('24','14') and @cd_banco=104 then right('00'+convert(varchar(2),@carteira),2) + right('00000000000000'+convert(varchar(15),@nn),15)    
                              when @carteira in ('17','18') and @cd_banco=1 and LEN(@convenio)=7 then @convenio + right('000000000'+convert(varchar(15),@nn),10)    
							  when @carteira in ('109') and @cd_banco=341 then '00000' + right('000'+convert(varchar(10),@carteira),3) + right('000000000'+convert(varchar(15),@nn),8) + dbo.FS_CalculoModulo10(right('0000'+@tp_ag,4) + right('00000'+@cta,5) + right('000'+convert(varchar(10),@carteira),3) + right('000000000'+convert(varchar(15),@nn),8))    
                              else 'ERRO ARQUIVO FORA DO PADRAO'    
                         end +
                   '11220' + --cob. simples + cob. registrada + escritural + id. entrega do boleto
                   right('00000000000000'+convert(varchar(14),@cd_parcela),11) + 
                   SPACE(4) + replace(convert(varchar(10),@dt_vencimento,103),'/','') + --vencimento
                   right('000000000000000'+Replace(convert(varchar(15),convert(int,Floor(@vl_parcela_L*100))),'.','') ,15) + -- Valor do débito           
                   '000000'+ -- Agência Encarregada da Cobrança//Dígito Verificador da Agência    
                   '18N' + -- Espécie do Título//Identificação de Título Aceito / Não Aceito    
                   replace(convert(varchar(10),getdate(),103),'/','') + -- Data da Emissão do Título    
                   '1' + replace(convert(varchar(10),@dt_vencimento,103),'/','') + -- Código do Juros de Mora (1-dia,2-Mes,3-Isento)//Data do Juros de Mora//Juros de Mora por Dia     
				   right('000000000000000'+convert(varchar(15),convert(int,case when floor(@vl_parcela_L*1/30)=0 then 1 else floor(@vl_parcela_L*1/30) end)),15)  + -- Taxa (se dia=informar valor, se mes=informar tx)    
				   '000000000000000000000000' + -- Código do Desconto 1//Data do Desconto 1//Valor/Percentual a ser Concedido    
				   '000000000000000' + '000000000000000' + -- Valor do IOF a ser Recolhido//Valor do Abatimento    
				   '0001'+right('0000000000'+convert(varchar(10),@cd_parcela),10) + Space(11) + -- Identificação do Título na Empresa    
				   '3' + '00' + '1' + '030' + --Código para Protesto//Número de Dias para Protesto//Código para Baixa/Devolução//Número de Dias para Baixa/Devolução    
				   '09' + -- Código da Moeda    
				   '0000000000 '
				   
				  print  @linha     -- P    
                              
				   if @Linha is null or @Linha = ''     
					   Begin -- 2.2.6    
								  set @erro = 1     
						 update Lote_Processos_Impressao_Mensalidades     
									 set mensagem = 'Linha P ('+ convert(varchar(20),@cd_associado_empresa) + ') invalida.'    
								   where cd_sequencial_lote = @sequencial and     
										 cd_parcela = @cd_parcela    
					   End -- 2.2.6   
			            
					Set @linha = 'ECHO ' + @linha +  '>> ' + @arquivo     
					EXEC SP_Shell @linha  
			
			
       -- Registro Detalhe - Segmento Q (Obrigatório - Remessa)    
			Set @linha = right('000'+convert(varchar(3),@cd_banco),3) + -- Codigo do Banco    
					 '00013'+ right('00000'+convert(varchar(5),(@qtde-1)*3+2),5)+'Q' + -- Lote de Servico, Tipo de Registro, Nº Sequencial do Registro no Lote,Cód. Segmento do Registro Detalhe    
					 space(1) + '01' +  -- Código de Movimento Remessa 
					 case when LEN(@cpf_cnpj)>11 then '2' else '1' end + --Tipo de Inscrição (1-PF,2-PJ)
					 right('000000000000000'+@cpf_cnpj,15)  + --  Número de Inscrição (cpf/cnpj)    
					 substring(@nome+Space(40),1,40) + substring(@endereco+Space(40),1,40) + substring(@bairro+Space(15),1,15) +     
					 substring(@cep+space(5),1,5) + right('000'+@cep,3) + substring(@cidade+Space(15),1,15) + substring(@uf+space(2),1,2) +     
					 '0000000000000000' + space(40) + '000' + Space(28) 			
			
			print  @linha     -- Q    
                              
				   if @Linha is null or @Linha = ''     
					   Begin -- 2.2.6    
								  set @erro = 1     
						 update Lote_Processos_Impressao_Mensalidades     
									 set mensagem = 'Linha ('+ convert(varchar(20),@cd_associado_empresa) + ') invalida.'    
								   where cd_sequencial_lote = @sequencial and     
										 cd_parcela = @cd_parcela    
					   End -- 2.2.6   
			            
					Set @linha = 'ECHO ' + @linha +  '>> ' + @arquivo     
					EXEC SP_Shell @linha 
					
					
       -- Registro Detalhe - Segmento R (Obrigatório - Remessa)    
			Set @linha = right('000'+convert(varchar(3),@cd_banco),3) + -- Codigo do Banco    
					 '00013'+ right('00000'+convert(varchar(5),(@qtde-1)*3+3),5)+'R' + -- Lote de Servico, Tipo de Registro, Nº Sequencial do Registro no Lote,Cód. Segmento do Registro Detalhe    
					 space(1) + '01' +  -- Código de Movimento Remessa    
                     '0' + '00000000' + '000000000000000' + 
                     '0' + '00000000' + '000000000000000' + 
					 '1' + replace(convert(varchar(10),@dt_vencimento,103),'/','') + -- Código do Juros de Mora (1-dia,2-Mes,3-Isento)//Data do Juros de Mora//Juros de Mora por Dia     
				     right('000000000000000'+replace(CONVERT(varchar(10), round(@vl_parcela_L*@multa/100*100,0)/100),'.',''),15) + --Valor/Percentual a Ser Aplicado
					 space(90) + 
					 space(50) + 
					 space(11)  
					 
			print  @linha     -- R    
                              
				   if @Linha is null or @Linha = ''     
					   Begin -- 2.2.6    
								  set @erro = 1     
						 update Lote_Processos_Impressao_Mensalidades     
									 set mensagem = 'Linha ('+ convert(varchar(20),@cd_associado_empresa) + ') invalida.'    
								   where cd_sequencial_lote = @sequencial and     
										 cd_parcela = @cd_parcela    
					   End -- 2.2.6   
			            
					Set @linha = 'ECHO ' + @linha +  '>> ' + @arquivo     
					EXEC SP_Shell @linha  			
 			


           print 'NOSSO NUMERO : ' + @nn
		    Set @nn = right('000000000000'+@nn,15)
           
           print 'CARTEIRA : ' + convert(varchar(2),@carteira)
            Set @nn = convert(varchar(2),@carteira) + @nn + dbo.FS_CalculoModulo11(convert(varchar(2),@carteira) + @nn,4)

  		   --Set @CampoLivre = @convenio+@nn+'0'+convert(varchar(3),@carteira)
  		   Set @CampoLivre = @convenio+@convenio_dv+substring(@nn,3,3)+SUBSTRING(@nn,1,1)+substring(@nn,6,3)+SUBSTRING(@nn,2,1)+SUBSTRING(@nn,9,9)
		   Set @CampoLivre = @CampoLivre +  dbo.FS_CalculoModulo11(@CampoLivre,3)
		   	
		   Set @codbarras = right('00'+convert(varchar(3),@cd_banco),3)+ '9' + convert(varchar(4),DATEDIFF(day,'10/07/1997',@dt_vencimento_parc)) + -- Fator de Vencimento
		       right('00000000000'+Replace(convert(varchar(12),convert(int,Floor((@vl_parcela_M+@taxa)*100))),'.',''),10) + -- Valor da Parcela 
			   @CampoLivre



 --****************************************************
 -- *****Busca Mensagens Adicionais****************
 --****************************************************
	   if @tp_associado_Empresa= 1
	   begin
			set @TipoMSG = 2
	   
			select @Fl_reajuste = COUNT(0)
			from ASSOCIADOS as a , DEPENDENTES as d, Log_reajuste as lr , reajuste as r, mensalidades as m  
			where a.cd_Associado = @cd_associado_empresa
			and a.cd_associado = d.CD_ASSOCIADO 
			and d.CD_SEQUENCIAL = lr.cd_sequencial_dep 
			and lr.id_reajuste = r.id_reajuste 
			and r.mes_assinatura = month(m.dt_vencimento) 
			and r.dt_aplicado_reajuste > DATEADD(month,-2,m.dt_vencimento) 
			and m.cd_parcela = @cd_parcela
			and m.tp_Associado_empresa = 1 
	    
	    
	        set @instrucao4 = ''
			if @Fl_reajuste> 0
			begin
				  select @MSGComplementar = 
				  SUBSTRING((
					  select top 100  t.mensagem 'data()' from TIPO_PAGAMENTO_MENSAGEM as t, mensalidades as m 
					  where t.cd_tipo_pagamento = m.cd_tipo_pagamento 
					  and m.cd_parcela = @cd_parcela
					  and t.nr_linha >= 8 
					  and t.cd_tipo_mensagem = 2 
					  order by nr_linha
				  For XML PATH ('')),
				  0, 1000)
			set @instrucao4=isnull(@instrucao4 + '','') + @MSGComplementar
			end
			
	   end
	   else
	   begin
			set @TipoMSG = 102
		   
			select @ContratoPJ = convert(varchar(10),pp.nr_contrato_plano) + ' ' + convert(varchar(100),ans.ds_classificacao) + ' REGISTRO ANS ' + convert(varchar(29),ans.cd_ans) 
			from empresa as e , reajuste as r, mensalidades as m , preco_plano as pp, planos as p , classificacao_ans as ans 
			where e.cd_empresa = @cd_associado_empresa  
			and e.CD_EMPRESA = r.cd_empresa 
			and e.CD_EMPRESA = m.CD_ASSOCIADO_empresa 
			and month(dateadd(month,1,r.dt_reajuste)) = month(m.dt_vencimento) 
			and year(dateadd(month,1,r.dt_reajuste)) = year(m.dt_vencimento) 
			and m.cd_parcela = @cd_parcela
			and m.tp_Associado_empresa = 2 
			and r.cd_sequencial_pplano = pp.cd_sequencial 
			and pp.cd_plano = p.cd_plano 
			and p.cd_classificacao = ans.cd_classificacao 
            
            set @instrucao4 = ''
            if @ContratoPJ <> ''
            begin
            select @MSGComplementar = 
				  SUBSTRING((
					  select top 100 t.mensagem 'data()' from TIPO_PAGAMENTO_MENSAGEM as t, mensalidades as m 
					  where t.cd_tipo_pagamento = m.cd_tipo_pagamento 
					  and m.cd_parcela = @cd_parcela
					  and t.nr_linha >= 8 
					  and t.cd_tipo_mensagem = 102 
					  order by nr_linha
				  For XML PATH ('')),
				  0, 1000)
		    set @instrucao4=isnull(@instrucao4 + '','') + @MSGComplementar
			end
			
	   end
	   --***************************************************
	
print '---'

print 'convenio: ' + @convenio
			print 'digto: ' + convert(varchar(5),@convenio_dv)
            print 'nn: ' + isnull(@nn,'')
            print 'campo livre: ' + isnull(@CampoLivre,'')
            print 'Codigo Br: ' + isnull(@codbarras, '')
            print 'Tamanho CodBR:' + convert(varchar(10),  isnull(Len(@codbarras),0) )
            print 'DigCodBarras: ' + convert(varchar(2),dbo.FS_DigitoVerificarCodigoBarras(@codbarras))
            print 'sequencial: ' + convert(varchar(10), @sequencial)
            print 'cd_associado_empresa: ' + convert(varchar(10),@cd_associado_empresa)
            print 'parcela: ' + convert(varchar(10),@cd_parcela)
            print 'cedente: ' + @cedente
            print 'cedente: ' + @nr_cnpj
            print 'vencimento: ' + CONVERT(varchar(10),@dt_vencimento,103)
            print 'agencia: ' + convert(varchar(10),@tp_ag)
            print 'digAg: ' + convert(varchar(1),@tp_ag_dv)
            print 'cta: ' + convert(varchar(10),@cta)
            print 'digCta: ' + convert(varchar(10),@dv_cta)
            print 'convencio: ' + convert(varchar(10),@convenio)
            print 'digConv: ' + convert(varchar(1),@convenio_dv)
            print 'carteira: ' + convert(varchar(10),@carteira)
            print 'NN: ' + @nn
            print 'valor: ' + convert(varchar(15),@vl_parcela_L)
            print 'Nome: ' + @nome
            print 'CPF/CNPJ: ' + @cpf_cnpj
            print 'Endereço: ' + @endereco
            print 'Bairro: ' + @bairro
            print 'CEP: ' + @cep
            print 'Cidade: ' + @cidade
            print 'UF: ' + @uf
            print 'multas: ' + convert(varchar(15),round(@vl_parcela_L*@multa/100*100,0)/100)
            print 'juros: ' + convert(varchar(15),round(@vl_parcela_L*@juros/100/30*100,0)/100)
            print 'inst1: ' + @instrucao1
            print 'inst2: ' + @instrucao2
            print 'inst3: ' + @instrucao3
            print 'inst4: ' + @instrucao4
            print 'LinhaDig: ' + @linhaDig1 + ' ' + @linhaDig2 + ' ' + @linhaDig3 + ' ' + @linhaDig4 + ' ' + @linhaDig5 
            print 'CodBr: ' + @codbarras
            print 'codBrVisual: ' + dbo.FG_TRADUZ_Codbarras(@codbarras)
            print 'inst5: ' + @instrucao5
            print 'inst6: ' + @instrucao6  
            
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

           print @linhaDig1
           print @linhaDig2
           print @linhaDig3
           print @linhaDig4
           print @linhaDig5                                            
			
		   Set @nn = LEFT(@nn,LEN(@nn)-1)+'-'+RIGHT(@nn,1)
		   
           insert Boleto (cd_sequencial_lote,cd_associado_empresa,cd_parcela,cedente,cnpj,
             dt_vencimento,agencia,dg_ag,conta,dg_conta,convenio,dg_convenio,carteira,
             nn,valor,pagador,cpf_cnpj_pagador,end_pagador,bai_pagador,cep_pagador,mun_pagador,
             uf_pagador,vl_multa,vl_juros,instrucao1,instrucao2,instrucao3,instrucao4,linha,barra,cod_barra,instrucao5,instrucao6)
             
           values (@sequencial,@cd_associado_empresa,@cd_parcela,@cedente,@nr_cnpj,
           CONVERT(varchar(10),@dt_vencimento,103),@tp_ag,@tp_ag_dv,@cta,@dv_cta, @convenio,@convenio_dv,@carteira,
           @nn,@vl_parcela_L,@nome,@cpf_cnpj, @endereco, @bairro, @cep, @cidade, @uf, 
           round(@vl_parcela_L*@multa/100*100,0)/100, round(@vl_parcela_L*@juros/100/30*100,0)/100,
           @instrucao1, @instrucao2, @instrucao3, @instrucao4, @linhaDig1 + ' ' + @linhaDig2 + ' ' + @linhaDig3 + ' ' + @linhaDig4 + ' ' + @linhaDig5, 
           @codbarras, dbo.FG_TRADUZ_Codbarras(@codbarras),@instrucao5,@instrucao6) 
              
           if @@ROWCOUNT = 0 
			Begin -- 3.2.6
              set @erro = 1 
			  update Lote_Processos_Impressao_Mensalidades 
                 set mensagem = 'Linha ('+ convert(varchar(20),@cd_associado_empresa) + ') invalida.'
               where cd_sequencial_lote = @sequencial and 
                     cd_parcela = @cd_parcela
			End -- 3.2.6
           
		FETCH NEXT FROM cursor_gera_processos_impressao_mens INTO @cd_associado_empresa,@cd_parcela ,@cd_tipo_pagamento_M, @vl_parcela_M,@dt_vencimento,
		      @vl_parcela_L,@cd_tipo_recebimento,@cpf_cnpj ,@nome, @endereco, @bairro, @cep, @cidade, @uf ,@nn,@taxa, @tp_associado_Empresa

        end -- 3.2
        Close cursor_gera_processos_impressao_mens
        Deallocate cursor_gera_processos_impressao_mens 

		-- Registro Trailer de Lote    
        Set @linha = right('000'+convert(varchar(3),@cd_banco),3) + -- banco    
                     '00015' + Space(9) +  -- Lote de Serviço//Tipo de Registro//Uso Exclusivo FEBRABAN/CNAB    
                     right('000000'+convert(varchar(6),(@qtde*3)+2),6) + -- Quantidade de Registros no Lote    
                     right('000000'+convert(varchar(6),@qtde),6) + -- Quantidade de Títulos em Cobrança    
                     right('00000000000000000'+convert(varchar(17),@vl_total),17) + -- Valor total dos registros do arquivo    
                     '000000' + '00000000000000000' + -- Totalização da Cobrança Caucionada     
                     '000000' + '00000000000000000' + -- Totalização da Cobrança Descontada    
                     Space(31) + Space(117)    
                     
        Set @linha = 'ECHO ' + @linha +  '>> ' + @arquivo     
		EXEC SP_Shell @linha    
		
		    
		-- Escrever Trailler    
		Set @linha = right('000'+convert(varchar(3),@cd_banco),3) + -- banco    
					 '99999' + Space(9) +  -- Lote de Serviço//Tipo de Registro//Uso Exclusivo FEBRABAN/CNAB//    
					 '000001' + right('000000'+convert(varchar(6),(@qtde*3)+4),6) + -- Quantidade de Lotes do Arquivo//Quantidade de Registros no arquivo    
					 Space(6) + Space(205)    
    
		Set @linha = 'ECHO ' + @linha +  '>> ' + @arquivo     
		EXEC SP_Shell @linha 

   End -- 4

/**********************************************************/
/*			BOLETO BANCARIO CNAB 400 C/ REGISTRO		  */
/**********************************************************/

if @cd_tiposervico = 45
	BEGIN -- 4
	
	delete boleto where cd_sequencial_lote = @sequencial
        
        if (@convenio is null or LEN(@convenio) <> 6 ) 
		Begin -- 4.0.3
		  Raiserror('Convenio deve ser informado com 6 digitos.',16,1)
		  RETURN
		End -- 4.0.3    

        Select @erro = 0 , @vl_total = 0 , @qtde=0 
	
	--- HEADER DE REMESSA
		SET @linha = '0'											-- Código do Registro
		+ '1' 														-- Código da Remessa
		+ 'REMESSA' 											    -- Literal da Remessa 
		+ '01' 														-- Código do Serviço
		+ SPACE(7) + 'COBRANCA' 									-- Literal de Serviço
		+ RIGHT('0000' + @tp_ag , 4)								-- Código da Agência
		+ RIGHT('000000'+@convenio,6) 								-- Código do Beneficiário
		+ SPACE(10) 												-- Uso Exclusivo
		+ CONVERT(CHAR(30),SUBSTRING(@cedente,1,30)) + 				-- Nome da Empresa
		+ '104' 													-- Código do Banco
		+ CONVERT(CHAR(15), SUBSTRING(@nm_banco, 1, 15)) 			-- Nome do Banco
		+ REPLACE(CONVERT(VARCHAR(10), GETDATE(), 3), '/', '') 	    -- Data de Geração
		+ SPACE(289) 												-- Uso Exclusivo
		+ RIGHT('00000' + CONVERT(VARCHAR(5), @nsa), 5) 			--Número Sequencial do Arquivo Remessa
		+ '000001'                                                  --Número Sequencial do Registro no Arquivo
		
		SET @linha = 'ECHO ' + @linha + '>> ' + @arquivo   
		EXEC SP_Shell @linha    
	--- FIM HEADER DE REMESSA

		print @linha

	DECLARE cursor_gera_processos_impressao_mens CURSOR FOR  
		select m.cd_associado_empresa , m.cd_parcela, m.cd_tipo_pagamento, 
               m.vl_parcela+isnull(m.vl_acrescimo,0)-isnull(m.vl_desconto,0)-isnull(m.vl_imposto,0) , 
			   m.dt_vencimento as dt_vencimento , l.vl_parcela , m.cd_tipo_recebimento , 
               a.nr_cpf ,
               dbo.FF_RemoveCaracterSpecial(dbo.FF_TiraAcento(a.nm_completo)), 
               dbo.FF_RemoveCaracterSpecial(dbo.FF_TiraAcento(ltrim(Isnull(TL.NOME_TIPO,'')+' '+a.EndLogradouro+' '+Case When a.EndNumero is null then '' When a.endNumero=0 then '' else convert(varchar(10),a.endnumero) end+' '+ISNULL(a.EndComplemento,'')))) , 
		       dbo.FF_RemoveCaracterSpecial(dbo.FF_TiraAcento(isnull(b.baiDescricao,''))), a.logcep,  
		       dbo.FF_RemoveCaracterSpecial(dbo.FF_TiraAcento(isnull(Cid.NM_MUNICIPIO,''))) , 
		       dbo.FF_RemoveCaracterSpecial(dbo.FF_TiraAcento(isnull(UF.ufSigla,''))),  
		       m.nosso_numero, 
		       case when isnull(a.taxa_cobranca,1) = 1 then m.vl_taxa else 0 end 
   		  
FROM            Lote_Processos_Impressao_Mensalidades AS L INNER JOIN
                         MENSALIDADES AS M ON L.cd_parcela = M.CD_PARCELA INNER JOIN
                         ASSOCIADOS AS a ON M.CD_ASSOCIADO_empresa = a.cd_associado LEFT OUTER JOIN
                         TB_TIPOLOGRADOURO AS TL ON a.CHAVE_TIPOLOGRADOURO = TL.CHAVE_TIPOLOGRADOURO LEFT OUTER JOIN
                         Bairro AS B ON a.BaiId = B.baiId LEFT OUTER JOIN
                         MUNICIPIO AS CID ON a.CidID = CID.CD_MUNICIPIO LEFT OUTER JOIN
                         UF ON a.ufId = UF.ufId
WHERE        (L.cd_sequencial_lote = @sequencial) AND (M.TP_ASSOCIADO_EMPRESA = 1)
         union 
		select m.cd_associado_empresa , m.cd_parcela, m.cd_tipo_pagamento, 
               m.vl_parcela+isnull(m.vl_acrescimo,0)-isnull(m.vl_desconto,0)-isnull(m.vl_imposto,0) , 
               m.dt_vencimento , l.vl_parcela , m.cd_tipo_recebimento ,
               a.nr_cgc, 
               dbo.FF_RemoveCaracterSpecial(dbo.FF_TiraAcento(a.nm_razsoc)) , 
               dbo.FF_RemoveCaracterSpecial(dbo.FF_TiraAcento(ltrim(Isnull(TL.NOME_TIPO,'')+' '+a.EndLogradouro+' '+Case When a.EndNumero is null then '' When a.endNumero=0 then '' else convert(varchar(10),a.endnumero) end+' '+ISNULL(a.EndComplemento,'')))) , 
	           dbo.FF_RemoveCaracterSpecial(dbo.FF_TiraAcento(isnull(b.baiDescricao,''))), 
	           a.cep,  
	           dbo.FF_RemoveCaracterSpecial(dbo.FF_TiraAcento(isnull(Cid.NM_MUNICIPIO,''))) , 
	           dbo.FF_RemoveCaracterSpecial(dbo.FF_TiraAcento(isnull(UF.ufSigla,''))) , 
	           m.nosso_numero, 0 
   		  
FROM            Lote_Processos_Impressao_Mensalidades AS L INNER JOIN
                         MENSALIDADES AS M ON L.cd_parcela = M.CD_PARCELA INNER JOIN
                         EMPRESA AS a ON M.CD_ASSOCIADO_empresa = a.CD_EMPRESA LEFT OUTER JOIN
                         TB_TIPOLOGRADOURO AS TL ON a.CHAVE_TIPOLOGRADOURO = TL.CHAVE_TIPOLOGRADOURO LEFT OUTER JOIN
                         Bairro AS B ON a.BaiId = B.baiId LEFT OUTER JOIN
                         MUNICIPIO AS CID ON a.cd_municipio = CID.CD_MUNICIPIO LEFT OUTER JOIN
                         UF ON a.ufId = UF.ufId
WHERE        (L.cd_sequencial_lote = @sequencial) AND (M.TP_ASSOCIADO_EMPRESA IN (2, 3))
ORDER BY M.CD_PARCELA
		OPEN cursor_gera_processos_impressao_mens  
		FETCH NEXT FROM cursor_gera_processos_impressao_mens INTO @cd_associado_empresa,@cd_parcela ,@cd_tipo_pagamento_M, @vl_parcela_M,@dt_vencimento,
		      @vl_parcela_L,@cd_tipo_recebimento,@cpf_cnpj ,@nome, @endereco, @bairro, @cep, @cidade, @uf ,@nn,@taxa

		WHILE (@@FETCH_STATUS <> -1)  
		begin  -- 4.2        

           set @dt_vencimento_parc = @dt_vencimento
           
           if @cep is null 
           begin -- 4.2.0

              set @erro = 1 
			  update Lote_Processos_Impressao_Mensalidades 
                 set mensagem = 'Cep do Associado ('+ convert(varchar(20),@cd_associado_empresa) + ') invalido.'
               where cd_sequencial_lote = @sequencial and 
                     cd_parcela = @cd_parcela

           End -- 4.2.0

           if @cd_tipo_pagamento_M <> @cd_tipopagamento
			Begin -- 4.2.1
              set @erro = 1 
			  update Lote_Processos_Impressao_Mensalidades 
                 set mensagem = 'Tipo de Pagamento do Associado ('+ convert(varchar(20),@cd_associado_empresa) + ') invalido.'
               where cd_sequencial_lote = @sequencial and 
                     cd_parcela = @cd_parcela
			End -- 4.2.1

           if @vl_parcela_M <> @vl_parcela_L
			Begin -- 4.2.2
              set @erro = 1 
			  update Lote_Processos_Impressao_Mensalidades 
                 set mensagem = 'Parcela do Associado ('+ convert(varchar(20),@cd_associado_empresa) + ') diferente do Gerado.'
               where cd_sequencial_lote = @sequencial and 
                     cd_parcela = @cd_parcela
			End -- 4.2.2

           if @cd_tipo_recebimento > 0 
			Begin -- 4.2.5
              set @erro = 1 
			  update Lote_Processos_Impressao_Mensalidades 
                 set mensagem = 'Associado ('+ convert(varchar(20),@cd_associado_empresa) + ') não encontra-se com a parcela em Aberto.'
               where cd_sequencial_lote = @sequencial and 
                     cd_parcela = @cd_parcela
			End -- 4.2.5


           Set @vl_total = @vl_total + convert(int,@vl_parcela_L*100)
           Set @qtde= @qtde + 1 

	--- DADOS DO TÍTULO
		SET @linha = '1'												-- Código do Registro
		+ CASE WHEN LEN(@cpf_cnpj) > 11 THEN '02' ELSE '01' END 		-- Tipo Inscrição
		+ RIGHT('00000000000000' + @cpf_cnpj, 14) 						-- Número Inscrição
		+ RIGHT('0000' + CONVERT(VARCHAR(4), @tp_ag), 4) 				-- Código da Agência
		+ RIGHT('000000'+@convenio,6) 									-- Código do Beneficiário
		+ '2' 															-- ID Emissão
		+ '0'															-- ID Postagem
		+ '00' 															-- Comissão Permanência
		+ '0001'+right('0000000000' + CONVERT(VARCHAR(10), @cd_parcela), 10) + Space(11) -- Identificação do Título na Empresa
		+ '01' 															-- Modalidade Identificação
		+ right('00000000000000000'+CONVERT(VARCHAR(30),@cd_parcela),15)-- Nosso Número
		+ SPACE(2) 														-- Campos em branco
		+ '1' 															-- Uso do banco
		+ SPACE(30) 													-- Mensagem a ser impressa no boleto
		+ '01' 															-- Nº OCORRENCIA    
		+ RIGHT('0000000000'+CONVERT(VARCHAR(10),@cd_parcela),10) + 	-- Número do Documento 
		+ REPLACE(CONVERT(VARCHAR(8),@dt_vencimento,3),'/','') 			-- Vencimento
		+ RIGHT('000000000000000'+convert(varchar(15),convert(int,Floor(@vl_parcela_L*100))),13) -- Valor Nominal do Título
		+ RIGHT('000'+CONVERT(VARCHAR(3),@cd_banco),3) 					-- Código do Banco
		+ '00000' 														-- Agência Cobradora
		+ '99' 															-- Espécie do Título
		+ 'N' 															-- Aceite
		+ REPLACE(CONVERT(VARCHAR(8),GETDATE(),3),'/','') 				-- Data da Emissão do Título
		+ '00' 															-- Instrução 1
		+ '00' 															-- Instrução 2
		+ RIGHT('0000000000000' + CASE WHEn @cd_tipopagamento = 145 THEN '00000' ELSE REPLACE(CONVERT(VARCHAR(5),ROUND(@vl_parcela_L*@juros/100/30*100,0)/100),'.','') END, 13) -- Juros Mora
		+ '000000' 														-- Data do Desconto
		+ '0000000000000' 												-- Valor do Desconto
		+ '0000000000000' 												-- Valor do IOF
		+ '0000000000000' 												-- Valor do abatimento
		+ CASE WHEN LEN(@cpf_cnpj)>11 THEN '02' ELSE '01' END 			-- Tipo Inscrição
		+ RIGHT('00000000000000'+@cpf_cnpj,14) 							-- Número de Inscrição
		+ LEFT(REPLACE(REPLACE(@nome,'&',''),'''','')+SPACE(40),40) 	-- Nome do Pagador
		+ LEFT(REPLACE(REPLACE(@endereco,'&',''),'''','')+SPACE(40),40) -- Endereço do Pagador
		+ LEFT(REPLACE(REPLACE(@bairro,'&',''),'''','')+SPACE(12),12) 	-- Bairro do Pagador
		+ RIGHT('00000000'+@cep,8) 										-- CEP do Pagador
		+ LEFT(REPLACE(REPLACE(@cidade,'&',''),'''','')+SPACE(15),15) 	-- Cidade do Pagador
		+ LEFT(@uf+SPACE(2),2) 											-- UF do Pagador
		+ REPLACE(CONVERT(VARCHAR(10),DATEADD(DAY,1,@dt_vencimento),103),'/','') -- Data da Multa
		+ RIGHT('0000000000'+REPLACE(CONVERT(VARCHAR(10), ROUND(@vl_parcela_L*@multa/100/30*100,0)/100),'.',''),10) -- Valor da Multa
		+ SPACE(22) 													-- Nome do Sacador/Avalista
		+ '00' 															-- Terceira Instrução de Cobrança
		+ '00' 															-- Prazo
		+ '1' 															-- Código da Moeda
		+ RIGHT('000000'+CONVERT(VARCHAR(5),@qtde+1), 6) 			-- Número Sequencial do Registro no Arquivo
	
		SET @linha = 'ECHO ' + @linha +  '>> ' + @arquivo     
		EXEC SP_Shell @linha    
	--- FIM DADOS DO TÍTULO

		print @linha
							    
       if @Linha is null or @Linha = '' 
		Begin -- 2.2.6
          set @erro = 1 
		  update Lote_Processos_Impressao_Mensalidades 
             set mensagem = 'Linha ('+ convert(varchar(20),@cd_associado_empresa) + ') invalida.'
           where cd_sequencial_lote = @sequencial and 
                 cd_parcela = @cd_parcela
		End -- 2.2.6
			
           -- Campo livre bradesco
           -- 20 a 23 - Agência Cedente (Sem o digito verificador, completar com zeros a esquerda quando necessário)
		   -- 24 a 25 - Carteira
		   -- 26 a 36 - 11 - Número do Nosso Número(Sem o digito verificador)
		   -- 37 a 43 - 7  - Conta do Cedente (Sem o digito verificador,completar com zeros a esquerda quando necessário)
		   -- 44 a 44 1 Zero
		   
  		   
                    
		FETCH NEXT FROM cursor_gera_processos_impressao_mens INTO @cd_associado_empresa,@cd_parcela ,@cd_tipo_pagamento_M, @vl_parcela_M,@dt_vencimento,
		      @vl_parcela_L,@cd_tipo_recebimento,@cpf_cnpj ,@nome, @endereco, @bairro, @cep, @cidade, @uf ,@nn,@taxa

        end -- 3.2
        Close cursor_gera_processos_impressao_mens
        Deallocate cursor_gera_processos_impressao_mens

	-- Registro Trailer de Lote    
	SET @linha = '9' -- Código do Registro
				+ Space(393) -- Uso Exclusivo
				+ RIGHT('000000'+CONVERT(VARCHAR(5),@qtde+2), 6)
					
	SET @linha = 'ECHO ' + @linha +  '>> ' + @arquivo     
	EXEC SP_Shell @linha  
	
End -- 4
/*************FIM BANCARIO CNAB 400 C/ REGISTRO************/            

        
/*************CNAB 400 BRADESCO************/            
IF @cd_tiposervico IN (46) -- CNAB 400 BRADESCO
	BEGIN -- 4
		SELECT @nsa = isnull(max(nsa) + 1, 21398)
		FROM lote_processos_bancos
		WHERE convenio = @convenio

		DELETE boleto
		WHERE cd_sequencial_lote = @sequencial

		IF (
				@convenio IS NULL
				OR LEN(@convenio) < 6
				)
		BEGIN -- 4.0.3
			RAISERROR ('Convenio deve ser informado com no minimo 6 digitos.', 16, 1)

			RETURN
		END -- 4.0.3    

		SELECT @erro = 0, @vl_total = 0, @qtde = 0

		--- Header
		SET @linha = '01REMESSA01' + LEFT('COBRANCA' + SPACE(15), 15) + right('0000000000000000000' + @convenio, 20) + convert(CHAR(30), substring(@cedente, 1, 30)) + right('000' + convert(VARCHAR(3), @cd_banco), 3) + -- Codigo do Banco
			convert(CHAR(15), substring(@nm_banco, 1, 15)) + -- Nome do Banco
			replace(convert(VARCHAR(8), getdate(), 3), '/', '') + -- Data de geração do arquivo (DDMMAA)
			SPACE(8) + 'MX' + right('000000' + convert(VARCHAR(7), @nsa), 7) + -- Número sequencial do arquivo (NSA)
			Space(277) + '000001'
		SET @linha = 'ECHO ' + @linha + '>> ' + @arquivo

		EXEC SP_Shell @linha

		DECLARE cursor_gera_processos_impressao_mens CURSOR
		FOR
		SELECT m.cd_associado_empresa, m.cd_parcela, m.cd_tipo_pagamento, m.vl_parcela + isnull(m.vl_acrescimo, 0) - isnull(m.vl_desconto, 0) - isnull(m.vl_imposto, 0), m.dt_vencimento AS dt_vencimento, l.vl_parcela, m.cd_tipo_recebimento, a.nr_cpf, a.nm_completo, ltrim(Isnull(TL.NOME_TIPO, '') + ' ' + a.EndLogradouro + ' ' + CASE 
					WHEN a.EndNumero IS NULL
						THEN ''
					WHEN a.endNumero = 0
						THEN ''
					ELSE ', num. ' + convert(VARCHAR(10), a.endnumero)
					END + ' ' + ISNULL(a.EndComplemento, '')), isnull(b.baiDescricao, ''), a.logcep, isnull(Cid.NM_MUNICIPIO, ''), isnull(UF.ufSigla, ''), m.nosso_numero, CASE 
				WHEN isnull(a.taxa_cobranca, 1) = 1
					THEN m.vl_taxa
				ELSE 0
				END
                
FROM            Lote_Processos_Impressao_Mensalidades AS L INNER JOIN
                         MENSALIDADES AS M ON L.cd_parcela = M.CD_PARCELA INNER JOIN
                         ASSOCIADOS AS a ON M.CD_ASSOCIADO_empresa = a.cd_associado LEFT OUTER JOIN
                         TB_TIPOLOGRADOURO AS TL ON a.CHAVE_TIPOLOGRADOURO = TL.CHAVE_TIPOLOGRADOURO LEFT OUTER JOIN
                         Bairro AS B ON a.BaiId = B.baiId LEFT OUTER JOIN
                         MUNICIPIO AS CID ON a.CidID = CID.CD_MUNICIPIO LEFT OUTER JOIN
                         UF ON a.ufId = UF.ufId
WHERE        (L.cd_sequencial_lote = @sequencial) AND (M.TP_ASSOCIADO_EMPRESA = 1)
		
		UNION
		
		SELECT m.cd_associado_empresa, m.cd_parcela, m.cd_tipo_pagamento, m.vl_parcela + isnull(m.vl_acrescimo, 0) - isnull(m.vl_desconto, 0) - isnull(m.vl_imposto, 0), m.dt_vencimento, l.vl_parcela, m.cd_tipo_recebimento, a.nr_cgc, a.nm_razsoc, ltrim(Isnull(TL.NOME_TIPO, '') + ' ' + a.EndLogradouro + ' ' + CASE 
					WHEN a.EndNumero IS NULL
						THEN ''
					WHEN a.endNumero = 0
						THEN ''
					ELSE ', num. ' + convert(VARCHAR(10), a.endnumero)
					END + ' ' + ISNULL(a.EndComplemento, '')), isnull(b.baiDescricao, ''), a.cep, isnull(Cid.NM_MUNICIPIO, ''), isnull(UF.ufSigla, ''), m.nosso_numero, 0
		
FROM            Lote_Processos_Impressao_Mensalidades AS L INNER JOIN
                         MENSALIDADES AS M ON L.cd_parcela = M.CD_PARCELA INNER JOIN
                         EMPRESA AS a ON M.CD_ASSOCIADO_empresa = a.CD_EMPRESA LEFT OUTER JOIN
                         TB_TIPOLOGRADOURO AS TL ON a.CHAVE_TIPOLOGRADOURO = TL.CHAVE_TIPOLOGRADOURO LEFT OUTER JOIN
                         Bairro AS B ON a.BaiId = B.baiId LEFT OUTER JOIN
                         MUNICIPIO AS CID ON a.cd_municipio = CID.CD_MUNICIPIO LEFT OUTER JOIN
                         UF ON a.ufId = UF.ufId
WHERE        (L.cd_sequencial_lote = @sequencial) AND (M.TP_ASSOCIADO_EMPRESA IN (2, 3))
ORDER BY M.CD_PARCELA

		OPEN cursor_gera_processos_impressao_mens

		FETCH NEXT
		FROM cursor_gera_processos_impressao_mens
		INTO @cd_associado_empresa, @cd_parcela, @cd_tipo_pagamento_M, @vl_parcela_M, @dt_vencimento, @vl_parcela_L, @cd_tipo_recebimento, @cpf_cnpj, @nome, @endereco, @bairro, @cep, @cidade, @uf, @nn, @taxa

		WHILE (@@FETCH_STATUS <> - 1)
		BEGIN -- 4.2        
			SET @dt_vencimento_parc = @dt_vencimento

			IF @cep IS NULL
			BEGIN -- 4.2.0
				SET @erro = 1

				UPDATE Lote_Processos_Impressao_Mensalidades
				SET mensagem = 'Cep do Associado (' + convert(VARCHAR(20), @cd_associado_empresa) + ') invalido.'
				WHERE cd_sequencial_lote = @sequencial
					AND cd_parcela = @cd_parcela
			END -- 4.2.0

			IF @cd_tipo_pagamento_M <> @cd_tipopagamento
			BEGIN -- 4.2.1
				SET @erro = 1

				UPDATE Lote_Processos_Impressao_Mensalidades
				SET mensagem = 'Tipo de Pagamento do Associado (' + convert(VARCHAR(20), @cd_associado_empresa) + ') invalido.'
				WHERE cd_sequencial_lote = @sequencial
					AND cd_parcela = @cd_parcela
			END -- 4.2.1

			IF @vl_parcela_M <> @vl_parcela_L
			BEGIN -- 4.2.2
				SET @erro = 1

				UPDATE Lote_Processos_Impressao_Mensalidades
				SET mensagem = 'Parcela do Associado (' + convert(VARCHAR(20), @cd_associado_empresa) + ') diferente do Gerado.'
				WHERE cd_sequencial_lote = @sequencial
					AND cd_parcela = @cd_parcela
			END -- 4.2.2

			IF @cd_tipo_recebimento > 0
			BEGIN -- 4.2.5
				SET @erro = 1

				UPDATE Lote_Processos_Impressao_Mensalidades
				SET mensagem = 'Associado (' + convert(VARCHAR(20), @cd_associado_empresa) + ') não encontra-se com a parcela em Aberto.'
				WHERE cd_sequencial_lote = @sequencial
					AND cd_parcela = @cd_parcela
			END -- 4.2.5

			SET @vl_total = @vl_total + convert(INT, @vl_parcela_L * 100)
			SET @qtde = @qtde + 1
			--IF @cd_banco = 237
			--BEGIN
			--	SET @cd_parcelaTemp = convert(VARCHAR(20), @cd_parcela) + ','

			--	EXEC PS_BoletoBRADESCO @cd_tipo_pagamento_M, @cd_parcelaTemp, 7021, @sequencial
			--END
			
			SET @linha = '100000 000000000000 ' + RIGHT('0000' + convert(VARCHAR(4), @carteira), 4) + RIGHT('00000' + convert(VARCHAR(5), @agencia), 5) + RIGHT('0000000' + convert(VARCHAR(7), @cta), 7) + convert(VARCHAR(1), @dv_cta) + Left(convert(VARCHAR(25), @cd_parcela) + space(25), 25) + '000' + '20200' + -- Multa
				right('000' + convert(VARCHAR(20), @nn), 11) + dbo.FS_CalculoModulo11_Bradesco(right('00' + @carteira, 2) + @nn) + '00000000002N' + SPACE(11) + '2' + SPACE(2) + '01' + LEFT(convert(VARCHAR(10), @cd_parcela) + space(10), 10) + replace(convert(VARCHAR(8), @dt_vencimento, 3), '/', '') + -- Data do vencimento (DDMMAA)  
				right('000000000000000' + convert(VARCHAR(15), convert(INT, Floor(@vl_parcela_L * 100))), 13) + -- Valor do débito     
				'000' + '00000' + '01N' + replace(convert(VARCHAR(8), GETDATE(), 3), '/', '') + '0000000000' + '0000000000' + '0000000000' + '0000000000' + '0000000000' + '0000000000' + '00' + CASE 
					WHEN LEN(@cpf_cnpj) > 11
						THEN '02'
					ELSE '01'
					END + RIGHT('00000000000000' + @cpf_cnpj, 14) + left(replace(replace(@nome, '&', ''), '''', '') + space(40), 40) + left(replace(replace(@endereco + ' ' + @bairro + ' ' + @cidade + ' ' + @uf + SPACE(40), '&', ''), '''', ''), 40) + space(12) + right('00000000' + @cep, 8) + SPACE(60) + right('000000' + convert(VARCHAR(10), @qtde * 2 + 2 - 2), 6)
			SET @linha = 'ECHO ' + @linha + '>> ' + @arquivo

			EXEC SP_Shell @linha

			SET @linha = '2ATE ' + convert(VARCHAR(8), @dt_vencimento, 3) + ', PAGAVEL EM QUALQUER AGENCIA BANCARIA.' + SPACE(29) + 'APOS ESTA DATA, SOMENTE NO BANCO BRADESCO.' + SPACE(38) + 'APOS O VENCIMENTO COBRAR MULTA DE 2% ACRESCIDO DE JUROS DE 0,033% AO DIA.' + SPACE(132) + RIGHT('000' + convert(VARCHAR(3), @carteira), 3) + RIGHT('0000' + convert(VARCHAR(5), @agencia), 5) + RIGHT('0000000' + convert(VARCHAR(7), @cta), 7) + convert(VARCHAR(1), @dv_cta) + + @nn + dbo.FS_CalculoModulo11_Bradesco(right('00' + @carteira, 2) + @nn) + right('000000' + convert(VARCHAR(10), @qtde * 2 + 2 - 1), 6)
			SET @linha = 'ECHO ' + @linha + '>> ' + @arquivo

			EXEC SP_Shell @linha

			-- Campo livre bradesco
			-- 20 a 23 - Agência Cedente (Sem o digito verificador, completar com zeros a esquerda quando necessário)
			-- 24 a 25 - Carteira
			-- 26 a 36 - 11 - Número do Nosso Número(Sem o digito verificador)
			-- 37 a 43 - 7  - Conta do Cedente (Sem o digito verificador,completar com zeros a esquerda quando necessário)
			-- 44 a 44 1 Zero
			SET @CampoLivre = RIGHT('00000' + convert(VARCHAR(5), @agencia), 4) + right('00' + convert(VARCHAR(2), @carteira), 2) + right('000000000000' + @nn, 11) + RIGHT('0000000' + convert(VARCHAR(7), @cta), 7) + '0'
			SET @codbarras = right('00' + convert(VARCHAR(3), @cd_banco), 3) + '9' + convert(VARCHAR(4), DATEDIFF(day, '10/07/1997', @dt_vencimento_parc)) + -- Fator de Vencimento
				right('00000000000' + Replace(convert(VARCHAR(12), convert(INT, Floor((@vl_parcela_M + @taxa) * 100))), '.', ''), 10) + -- Valor da Parcela 
				@CampoLivre
			--SET @nn = right('00' + convert(VARCHAR(2), @carteira), 2) + '/' + right('000000000000' + @nn, 11) + '-' + dbo.FS_CalculoModulo11_Bradesco(right('00' + @carteira, 2) + @nn)
			SET @nn = right('000000000000' + @nn, 11)

			PRINT '---'
			PRINT @CampoLivre
			PRINT @codbarras
			PRINT Len(@codbarras)
			PRINT dbo.FS_DigitoVerificarCodigoBarras(@codbarras)
			PRINT @nn			
			PRINT '---'

			SET @codbarras = left(@codbarras, 4) + dbo.FS_DigitoVerificarCodigoBarras(@codbarras) + right(@codbarras, 39)
			SET @linhaDig1 = left(@codbarras, 4) + left(@CampoLivre, 5)
			SET @linhaDig1 = left(@linhaDig1, 5) + '.' + right(@linhaDig1, 4) + dbo.FS_CalculoModulo10(@linhaDig1)
			SET @linhaDig2 = substring(@CampoLivre, 6, 10)
			SET @linhaDig2 = left(@linhaDig2, 5) + '.' + right(@linhaDig2, 5) + dbo.FS_CalculoModulo10(@linhaDig2)
			SET @linhaDig3 = substring(@CampoLivre, 16, 10)
			SET @linhaDig3 = left(@linhaDig3, 5) + '.' + right(@linhaDig3, 5) + dbo.FS_CalculoModulo10(@linhaDig3)
			SET @linhaDig4 = substring(@codbarras, 5, 1)
			SET @linhaDig5 = substring(@codbarras, 6, 14)

			PRINT @linhaDig1
			PRINT @linhaDig2
			PRINT @linhaDig3
			PRINT @linhaDig4
			PRINT @linhaDig5

			SET @instrucao1 = 'Após o vencimento cobrar:'
			SET @instrucao2 = 'Juros de R$ ' + CONVERT(VARCHAR(10), round(@vl_parcela_L * @juros / 100 / 30 * 100, 0) / 100) + ' ao dia.'
			SET @instrucao3 = 'Multa de R$ ' + CONVERT(VARCHAR(10), round(@vl_parcela_L * @multa / 100 * 100, 0) / 100) + '.'

			--Set @instrucao4 = 'Após 30 (trinta) dias de atraso protestar.'
			INSERT Boleto (cd_sequencial_lote, cd_associado_empresa, cd_parcela, cedente, cnpj, dt_vencimento, agencia, dg_ag, conta, dg_conta, convenio, dg_convenio, carteira, nn, valor, pagador, cpf_cnpj_pagador, end_pagador, bai_pagador, cep_pagador, mun_pagador, uf_pagador, vl_multa, vl_juros, instrucao1, instrucao2, instrucao3, instrucao4, linha, barra, cod_barra)
			VALUES (@sequencial, @cd_associado_empresa, @cd_parcela, @cedente, @nr_cnpj, CONVERT(VARCHAR(10), @dt_vencimento, 103), @agencia, @dv_ag, @cta, @dv_cta, @convenio, @convenio_dv, @carteira, @nn, @vl_parcela_L, @nome, @cpf_cnpj, @endereco, @bairro, @cep, @cidade, @uf, round(@vl_parcela_L * @multa / 100 * 100, 0) / 100, round(@vl_parcela_L * @juros / 100 / 30 * 100, 0) / 100, @instrucao1, @instrucao2, @instrucao3, @instrucao4, @linhaDig1 + ' ' + @linhaDig2 + ' ' + @linhaDig3 + ' ' + @linhaDig4 + ' ' + @linhaDig5, @codbarras, dbo.FG_TRADUZ_Codbarras(@codbarras))

			IF @@ROWCOUNT = 0
			BEGIN -- 3.2.6
				SET @erro = 1

				UPDATE Lote_Processos_Impressao_Mensalidades
				SET mensagem = 'Linha (' + convert(VARCHAR(20), @cd_associado_empresa) + ') invalida.'
				WHERE cd_sequencial_lote = @sequencial
					AND cd_parcela = @cd_parcela
			END -- 3.2.6

			FETCH NEXT
			FROM cursor_gera_processos_impressao_mens
			INTO @cd_associado_empresa, @cd_parcela, @cd_tipo_pagamento_M, @vl_parcela_M, @dt_vencimento, @vl_parcela_L, @cd_tipo_recebimento, @cpf_cnpj, @nome, @endereco, @bairro, @cep, @cidade, @uf, @nn, @taxa
		END -- 3.2

		CLOSE cursor_gera_processos_impressao_mens

		DEALLOCATE cursor_gera_processos_impressao_mens

		--- Header
		SET @linha = '9' + SPACE(393) + right('000000' + convert(VARCHAR(10), @qtde * 2 + 2), 6)
		SET @linha = 'ECHO ' + @linha + '>> ' + @arquivo

		EXEC SP_Shell @linha
	END -- 4
/*************FIM CNAB 400 BRADESCO************/            
        
              
   if @erro = 1 -- Excluir arquivo 
   Begin -- 90
		--set @linha = 'Del '+  @arquivo
		--EXEC SP_Shell @linha , 0 -- Excluir se o arquivo já existir
	    Raiserror('Erro na geração do Arquivo.',16,1)
		RETURN
   End -- 90
   Else
   Begin -- 90.1
		-- Atualizar Processos_Banco (convenio e nsa)
	   update Lote_Processos_Bancos
 	         set nm_arquivoImpressaoExterna = @nm_arquivo 
               where cd_sequencial = @sequencial
		IF @@ROWCOUNT = 0
		Begin -- 90.1.1
		  set @linha = 'Del '+  @arquivo
		  EXEC SP_Shell @linha , 0 -- Excluir se o arquivo já existir
		  Raiserror('Erro no Fechamento do Arquivo.',16,1)
		  RETURN
		End -- 90.1.1
   End -- 90.1
              
End --1
