/****** Object:  Procedure [dbo].[SP_GeraArquivosAverbacao]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[SP_GeraArquivosAverbacao] @sequencial INT,
	@arquivo VARCHAR(1000) OUTPUT
AS
BEGIN -- 1
	DECLARE @caminho VARCHAR(255)
	DECLARE @retEcho INT --variavel para verificar se o comando foi executado com exito ou ocorreu alguma falha 
	DECLARE @Linha VARCHAR(8000)
	DECLARE @arquivoAux VARCHAR(1000)
	DECLARE @cd_tiposervico SMALLINT
	DECLARE @cd_tipopagamento SMALLINT
	DECLARE @nm_tipopagamento VARCHAR(10)
	DECLARE @cd_banco INT
	DECLARE @convenio VARCHAR(10)
	DECLARE @cedente VARCHAR(100)
	DECLARE @nm_banco VARCHAR(100)
	DECLARE @nsa INT
	DECLARE @dt_finalizado DATETIME
	DECLARE @nr_cnpj CHAR(14)
	DECLARE @tp_ag VARCHAR(10)
	DECLARE @tp_ag_dv CHAR(1)
	DECLARE @cta VARCHAR(20)
	DECLARE @carteira INT
	DECLARE @juros INT
	DECLARE @multa INT
	-- Variaveis do Arquivo
	DECLARE @cd_associado_empresa INT
	DECLARE @vl_parcela_M MONEY
	DECLARE @cpf_cnpj VARCHAR(14)
	DECLARE @rg VARCHAR(20)
	DECLARE @nome VARCHAR(100)
	DECLARE @endereco VARCHAR(100)
	DECLARE @numerocasa INT
	DECLARE @compend VARCHAR(100)
	DECLARE @bairro VARCHAR(100)
	DECLARE @cep VARCHAR(8)
	DECLARE @cidade VARCHAR(50)
	DECLARE @uf VARCHAR(2)
	DECLARE @matricula VARCHAR(9)
	DECLARE @ope VARCHAR(1)
	DECLARE @dt_apres DATETIME
	DECLARE @dt_nasc DATETIME
	DECLARE @cd_parcela INT
	DECLARE @nr_autorizacao VARCHAR(50)
	DECLARE @val_cartao VARCHAR(10)
	DECLARE @cd_seguranca VARCHAR(10)
	DECLARE @cd_bandeira SMALLINT
	-- Variavel de Erro
	DECLARE @erro BIT = 0
	-- Variaveis do Trailler
	DECLARE @qtde INT
	DECLARE @vl_total BIGINT

	SELECT TOP 1 @caminho = pasta_site
	FROM configuracao -- Verificar o caminho a ser gravado os arquivos

	IF @@ROWCOUNT = 0
	BEGIN -- 1.1
		RAISERROR (
				'Pasta dos Arquivos não definida.',
				16,
				1
				)

		RETURN
	END -- 1.1

	SELECT @cd_tiposervico = l.cd_tipo_servico_bancario, -- Variaveis do Sistema
		@cd_tipopagamento = l.cd_tipo_pagamento,
		@nm_tipopagamento = t.nm_tipo_pagamento,
		@cd_banco = t.banco,
		@convenio = t.convenio,
		@cedente = t.cedente,
		@nm_banco = b.nm_banco,
		@dt_finalizado = l.dt_finalizado,
		@nr_cnpj = t.nr_cnpj,
		@tp_ag = t.ag,
		@tp_ag_dv = t.dv_ag,
		@cta = t.cta,
		@carteira = carteira,
		@juros = isnull(perc_juros, 0),
		@multa = isnull(perc_multa, 0)
	FROM Averbacao_lote AS l
	INNER JOIN TIPO_PAGAMENTO AS t ON l.cd_tipo_pagamento = t.cd_tipo_pagamento
	LEFT OUTER JOIN TB_Banco_Contratos AS b ON t.banco = b.cd_banco
	WHERE (l.cd_sequencial = @sequencial)

	IF @@ROWCOUNT = 0
	BEGIN -- 1.2
		RAISERROR (
				'Sequencial nao encontrado.',
				16,
				1
				)

		RETURN
	END -- 1.2

	-- --select @cd_tiposervico=6 , @cd_tipopagamento = 18 
	-- Erro se arquivo já tiver sido finalizado
	IF @dt_finalizado IS NOT NULL
	BEGIN -- 1.3
		RAISERROR (
				'Sequencial já finalizado e Gerado.',
				16,
				1
				)

		RETURN
	END -- 1.3

	IF @cd_tiposervico = 8 -- Conta Energia
		OR @cd_tiposervico = 5 -- Cartao Recorrente
	BEGIN -- 1.4
		-- Validar variaveis obrigatorias 
		IF @convenio IS NULL
			OR @cedente IS NULL
		BEGIN -- 2.1
			RAISERROR (
					'Banco, Convênio ou Cedente não definidos na tabela de Tipo de Pagamento.',
					16,
					1
					)

			RETURN
		END -- 2.1

		IF len(@convenio) <> 6
		BEGIN -- 2.0.3
			RAISERROR (
					'Convênio deve possuir 6 digitos.',
					16,
					1
					)

			RETURN
		END -- 2.0.3  

		IF len(rtrim(@nr_cnpj)) < 14 -- CNPJ não informado
		BEGIN -- 2.0.1
			RAISERROR (
					'CNPJ não informado.',
					16,
					1
					)

			RETURN
		END -- 2.0.1      

		IF len(rtrim(@tp_ag)) <> 6
			AND len(@cta) <> 6 -- Agencia e Digito
		BEGIN -- 2.0.2
			RAISERROR (
					'Agencia e Conta deve ter 6 digitos.',
					16,
					1
					)

			RETURN
		END -- 2.0.2      

		--- Encontrar o @nsa do Arquivo. Sequencial 
		SELECT @nsa = isnull(max(nsa) + 1, 1)
		FROM averbacao_lote
		WHERE convenio = @convenio

		UPDATE averbacao
		SET mensagem = NULL
		WHERE cd_sequencial = @sequencial

		SET @arquivoAux = @convenio + '_' + replace(CONVERT(VARCHAR(10), getdate(), 103), '/', '') + '_' + convert(VARCHAR(10), @nsa) + '.txt'
		SET @arquivo = @caminho + '\arquivos\averbacao\envio\' + @arquivoAux
		SET @linha = 'Del ' + @arquivo

		EXEC SP_Shell @linha,
			0 -- Excluir se o arquivo já existir

		--Nr Qtde Tipo Descrição
		--1 001 001 001 X Código do Registro A
		--2 002 002 001 9 Código da Remessa 2
		--3 003 008 006 9 Código do Cliente Seu Nr Informado pela centercob
		--4 009 016 008 9 Data de Geração do Arquivo formato ddmmaaaa
		--5 017 986 984 X brancos
		--6 987 994 008 X brancos Reservado
		--7 995 1000 006 6 Número sequencial do arquivo
		--8 1001 1006 006 9 Número sequencial da linha 1
		--- Header do Arquivo
		SET @linha = 'A2' + @convenio + -- Código do Cliente Seu Nr Informado pela centercob
			replace(CONVERT(VARCHAR(10), getdate(), 103), '/', '') + -- Data de Geração do Arquivo formato ddmmaaaa
			Space(978) + right('00000' + convert(VARCHAR(6), @nsa), 6) + -- Número sequencial do arquivo
			'000001' -- Número sequencial da linha 1
		SET @linha = 'ECHO ' + @linha + '>> ' + @arquivo

		EXEC SP_Shell @linha

		SELECT @erro = 0,
			@vl_total = 0,
			@qtde = 0

		DECLARE cursor_gera_processos_bancos_mens CURSOR
		FOR
		SELECT m.cd_associado,
			isnull(m.vl_parcela, 0),
			a.nu_matricula,
			m.cd_operacao,
			a.dt_apresentacao,
			m.nm_sacado,
			a.nr_cpf,
			a.nr_identidade,
			a.dt_nascimento,
			ltrim(Isnull(TL.NOME_TIPO, '') + ' ' + a.EndLogradouro),
			a.EndNumero,
			isnull(a.EndComplemento, ' '),
			isnull(b.baiDescricao, ''),
			a.logcep,
			isnull(Cid.NM_MUNICIPIO, ''),
			isnull(UF.ufSigla, ''),
			m.cd_sequencial_averbacao,
			a.nr_autorizacao,
			convert(VARCHAR(10), a.val_cartao),
			convert(VARCHAR(10), a.cd_seguranca),
			a.cd_bandeira
		FROM Averbacao_lote AS L
		INNER JOIN averbacao AS M ON L.cd_sequencial = M.cd_sequencial
		INNER JOIN ASSOCIADOS AS a ON M.cd_Associado = a.cd_associado
		LEFT OUTER JOIN TB_TIPOLOGRADOURO AS TL ON a.CHAVE_TIPOLOGRADOURO = TL.CHAVE_TIPOLOGRADOURO
		LEFT OUTER JOIN Bairro AS B ON a.BaiId = B.baiId
		LEFT OUTER JOIN MUNICIPIO AS CID ON a.CidID = CID.CD_MUNICIPIO
		LEFT OUTER JOIN UF ON a.ufId = UF.ufId
		LEFT OUTER JOIN Bandeira AS BN ON a.cd_bandeira = BN.cd_bandeira
		WHERE (L.cd_sequencial = @sequencial)
		ORDER BY M.cd_sequencial_averbacao

		OPEN cursor_gera_processos_bancos_mens

		FETCH NEXT
		FROM cursor_gera_processos_bancos_mens
		INTO @cd_associado_empresa,
			@vl_parcela_M,
			@matricula,
			@ope,
			@dt_apres,
			@nome,
			@cpf_cnpj,
			@rg,
			@dt_nasc,
			@endereco,
			@numerocasa,
			@compend,
			@bairro,
			@cep,
			@cidade,
			@uf,
			@cd_parcela,
			@nr_autorizacao,
			@val_cartao,
			@cd_seguranca,
			@cd_bandeira

		WHILE (@@FETCH_STATUS <> - 1)
		BEGIN -- 2.2        
			IF @cep IS NULL
			BEGIN -- 2.2.0
				SET @erro = 1

				UPDATE averbacao
				SET mensagem = 'Cep do Associado (' + convert(VARCHAR(20), @cd_associado_empresa) + ') invalido.'
				WHERE cd_sequencial_averbacao = @cd_parcela
			END -- 2.2.0

			IF @dt_apres IS NULL
				AND @cd_tiposervico = 8
			BEGIN -- 2.2.5
				SET @erro = 1

				UPDATE averbacao
				SET mensagem = 'Associado (' + convert(VARCHAR(20), @cd_associado_empresa) + ') sem data de apresentação.'
				WHERE cd_sequencial_averbacao = @cd_parcela
			END -- 2.2.5

			IF @matricula IS NULL
				AND @cd_tiposervico = 8
			BEGIN -- 2.2.5
				SET @erro = 1

				UPDATE averbacao
				SET mensagem = 'Associado (' + convert(VARCHAR(20), @cd_associado_empresa) + ') sem matricula.'
				WHERE cd_sequencial_averbacao = @cd_parcela
			END -- 2.2.5

			IF (
					@nr_autorizacao IS NULL
					OR len(@nr_autorizacao) <> 16
					)
				AND @cd_tiposervico = 5
			BEGIN -- 2.2.5
				SET @erro = 1

				UPDATE averbacao
				SET mensagem = 'Associado (' + convert(VARCHAR(20), @cd_associado_empresa) + ') sem numero de autorização ou errado.'
				WHERE cd_sequencial_averbacao = @cd_parcela
			END -- 2.2.5

			IF (
					@val_cartao IS NULL
					OR len(@val_cartao) <> 6
					)
				AND @cd_tiposervico = 5
			BEGIN -- 2.2.5
				SET @erro = 1

				UPDATE averbacao
				SET mensagem = 'Associado (' + convert(VARCHAR(20), @cd_associado_empresa) + ') sem validade ou errado.'
				WHERE cd_sequencial_averbacao = @cd_parcela
			END -- 2.2.5

			IF (
					@cd_seguranca IS NULL
					OR len(@cd_seguranca) <> 3
					)
				AND @cd_tiposervico = 5
			BEGIN -- 2.2.5
				SET @erro = 1

				UPDATE averbacao
				SET mensagem = 'Associado (' + convert(VARCHAR(20), @cd_associado_empresa) + ') sem código de segurança ou errado.'
				WHERE cd_sequencial_averbacao = @cd_parcela
			END -- 2.2.5

			IF @cd_bandeira IS NULL
				AND @cd_tiposervico = 5
			BEGIN -- 2.2.5
				SET @erro = 1

				UPDATE averbacao
				SET mensagem = 'Associado (' + convert(VARCHAR(20), @cd_associado_empresa) + ') sem bandeira.'
				WHERE cd_sequencial_averbacao = @cd_parcela
			END -- 2.2.5

			IF @ope NOT IN (
					'I',
					'A',
					'C'
					)
			BEGIN -- 2.2.5
				SET @erro = 1

				UPDATE averbacao
				SET mensagem = 'Associado (' + convert(VARCHAR(20), @cd_associado_empresa) + ') com operação invalida.'
				WHERE cd_sequencial_averbacao = @cd_parcela
			END -- 2.2.5			

			SET @vl_total = @vl_total + convert(INT, @vl_parcela_M * 100)
			SET @qtde = @qtde + 1
			--Nr INI FIM Qtde Tipo Descrição
			--1 001 001 001 X Código do Registro D
			--2 002 002 001 9 Código da Remessa 2
			--3 003 008 006 9 Código do Cliente Seu Nr Informado pela centercob
			--4 009 009 001 x Tipo Cobrança E = Energia, C= Cartão, D = Débito Aut.
			--5 010 034 025 9 Unidade Consumidora do cliente
			--6 035 044 010 9 Número Identificador do Cliente Número Identificador do Cliente (10 dígitos) opcional
			--7 045 045 001 X Ocorrência I = Inclusão, C = Cancelamento, A = Alteração
			--8 046 069 024 X Brancos
			--9 070 119 050 X Cidade
			--10 120 121 002 X UF
			--11 122 129 008 9 CEP Preenchimento Obrigatório
			--12 130 135 006 9 Codigo Concessionária Pegar códigos com a Centercob
			--13 136 141 006 9 Código do Vendedor Pegar códigos com a Centercob
			--14 142 149 008 9 Data de Faturamento formato ddmmaaaa
			--15 150 157 008 9 Data de Vencimento formato ddmmaaaa
			--16 158 158 001 X Tipo Pessoa F=Física, J= Jurídica
			--17 159 228 070 X Titular da conta
			--18 229 298 070 X Nome do Comprador (Fantasia)
			--19 299 368 070 X Razão Social do Comprador
			--20 369 383 015 X CNPJ ou CPF somente nr com espaços a direita
			--21 384 403 020 X Inscrição Estadual ou RG somente nr com espaços a direita
			--22 404 411 008 9 Data de Nascimento formato ddmmaaaa
			--23 412 461 050 X Email
			--24 462 511 050 X Logradouro
			--25 512 517 006 X Número
			--26 518 547 030 X Bairro
			--27 548 577 030 X Complemento
			--28 578 587 010 9 Telefone 1 Código de área + Numero
			--29 588 597 010 9 Telefone 2 Código de área + Numero
			--30 598 607 010 9 Celular Código de área + Numero
			--31 608 617 010 9 Fax Código de área + Numero
			--32 618 667 050 X Nome do Pai
			--33 668 717 050 X Nome da Mãe
			--34 718 725 008 9 Data de Vencimento da 1º Parcela formato ddmmaaaa
			--35 726 735 010 9 Valor (1) (2 casas Decimais apenas números)
			--36 736 737 002 9 Quantidade de Parcelas (1) (Se for mensalista preecher com Zeros)
			--37 738 747 010 9 Valor (2) Preenchimento Opcional
			--38 748 749 002 9 Quantidade de Parcelas (2) Preenchimento Opcional
			--39 750 759 010 9 Valor (3) Preenchimento Opcional
			--40 760 761 002 9 Quantidade de Parcelas (3) Preenchimento Opcional
			--41 762 771 010 9 Valor (4) Preenchimento Opcional
			--42 772 773 002 9 Quantidade de Parcelas (4) Preenchimento Opcional
			--43 774 783 010 X Nr Autorização
			--44 784 785 002 9 Codigo Ocorrencia Retorno Ver Nota 1
			--45 786 885 100 X Descrição Ocorrência
			--46 886 910 025 X Número Identificador do Cliente Número Identificador do Cliente (25 dígitos) opcional
			--47 911 918 008 X Agencia Usado apenas quando for débito automático
			--47 919 921 003 X Dígito da Agencia Usado apenas quando for débito automático
			--47 922 933 012 X Conta Usado apenas quando for débito automático
			--47 934 936 003 X Dígito da Conta Usado apenas quando for débito automático
			--47 937 940 004 X Operação Usado apenas quando for débito automático
			--48 941 941 001 X Seguro Vida com Sorte S = SIM / N ou ESPAÇO = NÃO
			--49 942 1000 059 X Brancos
			--48 1001 1006 006 9 Número sequencial da linha Incrementar 1 a cada linha
			--Registro Detalhe - Segmento P (Obrigatório - Remessa)
			SET @linha = 'D2' + @convenio + CASE 
					WHEN @cd_tiposervico = 8
						THEN 'E'
					ELSE 'C'
					END + right('0000000000000000000000000' + convert(VARCHAR(25), CASE 
							WHEN @cd_tiposervico = 8
								THEN @matricula
							ELSE ''
							END), 25) + -- Unidade Consumidora do cliente
				right('0000000000' + convert(VARCHAR(10), @cd_associado_empresa), 10) + -- Número Identificador do Cliente
				@ope + SPACE(24) + substring(@cidade + Space(50), 1, 50) + substring(@uf + space(2), 1, 2) + substring(@cep + '00000000', 1, 8) + right('000000' + CASE 
						WHEN @cd_tiposervico = 8
							THEN @tp_ag
						ELSE convert(VARCHAR(6), @cd_bandeira)
						END, 6) + -- Codigo Concessionária // Bandeira no Cartao 
				right('000000' + @cta, 6) + -- Código do Vendedor
				replace(CONVERT(VARCHAR(10), getdate(), 103), '/', '') + -- Data de Faturamento
				replace(CONVERT(VARCHAR(10), dateadd(day, CASE 
								WHEN @cd_tiposervico = 8
									THEN 0
								ELSE 3
								END, getdate()), 103), '/', '') + -- Data de Vencimento
				'F' + substring(@nome + Space(70), 1, 70) + SPACE(140) + substring(@cpf_cnpj + SPACE(15), 1, 15) + -- CPF 
				substring(@rg + SPACE(20), 1, 20) + -- CPF 
				replace(CONVERT(VARCHAR(10), @dt_nasc, 103), '/', '') + Space(50) + -- E-mail 
				substring(@endereco + Space(50), 1, 50) + RIGHT('000000' + convert(VARCHAR(10), @numerocasa), 6) + substring(@bairro + Space(50), 1, 30) + substring(@compend + Space(50), 1, 30) + SPACE(140) + -- Telefone 1,Telefone 2,Telefone 3,Telefone 4,Nome do Pai,Nome do Mae
				replace(CONVERT(VARCHAR(10), getdate(), 103), '/', '') + -- Data de Vencimento da 1º Parcela
				right('000000000000000' + Replace(convert(VARCHAR(15), CASE 
								WHEN @ope = 'E'
									THEN 0
								ELSE convert(INT, Floor(@vl_parcela_M * 100))
								END), '.', ''), 10) + -- Valor do débito      
				'00' + -- Mensalista 
				'000000000000' + '000000000000' + '000000000000' + -- Valor (2,3,4) + Quantidade de Parcelas (2,3,4)
				right('0000000000' + convert(VARCHAR(10), @cd_associado_empresa), 10) + '00' + -- Codigo Ocorrencia Retorno
				SPACE(100) + --Descrição Ocorrência
				right('0000000000' + convert(VARCHAR(10), @cd_associado_empresa), 10) + SPACE(15) + Space(31) + CASE 
					WHEN @cd_tiposervico = 8
						THEN Space(59)
					ELSE @nr_autorizacao + @cd_seguranca + @val_cartao + SPACE(34)
					END + RIGHT('000000' + convert(VARCHAR(10), @qtde + 1), 6)

			IF @Linha IS NULL
				OR @Linha = ''
			BEGIN -- 2.2.6
				SET @erro = 1

				UPDATE averbacao
				SET mensagem = 'Linha (' + convert(VARCHAR(20), @cd_associado_empresa) + ') invalida.'
				WHERE cd_sequencial_averbacao = @cd_parcela
			END -- 2.2.6

			SET @linha = 'ECHO ' + @linha + '>> ' + @arquivo

			EXEC SP_Shell @linha

			FETCH NEXT
			FROM cursor_gera_processos_bancos_mens
			INTO @cd_associado_empresa,
				@vl_parcela_M,
				@matricula,
				@ope,
				@dt_apres,
				@nome,
				@cpf_cnpj,
				@rg,
				@dt_nasc,
				@endereco,
				@numerocasa,
				@compend,
				@bairro,
				@cep,
				@cidade,
				@uf,
				@cd_parcela,
				@nr_autorizacao,
				@val_cartao,
				@cd_seguranca,
				@cd_bandeira
		END -- 2.2

		CLOSE cursor_gera_processos_bancos_mens

		DEALLOCATE cursor_gera_processos_bancos_mens

		--Nr Qtde Tipo Descrição
		--1 001 001 001 X Código do Registro Z
		--2 002 007 006 9 Qtde de Cobranças Novas Numero de Cobranças do arquivo
		--3 008 017 010 9 Soma dos Valores das Cobranças Soma das Cobranças enviadas
		--3 018 1000 983 X Brancos
		--4 1001 1006 006 9 Número sequencial da linha Incrementar 1 a cada linha
		-- Registro Trailer de Lote
		SET @linha = 'Z' + RIGHT('000000' + convert(VARCHAR(10), @qtde), 6) + -- Qtde de Cobranças Novas
			right('00000000000000000' + convert(VARCHAR(17), @vl_total), 10) + -- Valor total dos registros do arquivo
			Space(983) + RIGHT('000000' + convert(VARCHAR(10), @qtde + 2), 6)
		SET @linha = 'ECHO ' + @linha + '>> ' + @arquivo

		EXEC SP_Shell @linha
	END -- 1.4

	IF @erro = 1 -- Excluir arquivo 
	BEGIN -- 90
		SET @linha = 'Del ' + @arquivo

		EXEC SP_Shell @linha,
			0 -- Excluir se o arquivo já existir

		RAISERROR (
				'Erro na geração do Arquivo.',
				16,
				1
				)

		RETURN
	END -- 90
	ELSE
	BEGIN -- 90.1
		-- Atualizar Processos_Banco (convenio e nsa)
		UPDATE averbacao_lote
		SET nsa = @nsa,
			convenio = @convenio,
			dt_gerado = getdate(),
			dt_finalizado = getdate(),
			nm_arquivo = @arquivoAux
		WHERE cd_sequencial = @sequencial

		IF @@ROWCOUNT = 0
		BEGIN -- 90.1.1
			SET @linha = 'Del ' + @arquivo

			EXEC SP_Shell @linha,
				0 -- Excluir se o arquivo já existir

			RAISERROR (
					'Erro no Fechamento do Arquivo.',
					16,
					1
					)

			RETURN
		END -- 90.1.1
	END -- 90.1
END --1
