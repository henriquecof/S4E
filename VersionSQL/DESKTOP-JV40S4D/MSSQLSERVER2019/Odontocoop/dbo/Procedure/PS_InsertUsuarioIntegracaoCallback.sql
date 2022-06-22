/****** Object:  Procedure [dbo].[PS_InsertUsuarioIntegracaoCallback]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:		Francisco Damilson
-- Create date: 30/05/2022
-- Description:	Insert Callback
-- =============================================
CREATE PROCEDURE [dbo].[PS_InsertUsuarioIntegracaoCallback] @IdTransacaoCallback INT
AS
BEGIN
	DECLARE @codigoCentroCusto AS INT
	-------------------------------
	--Variaveis Associado
	-------------------------------
	DECLARE @id INT
	DECLARE @transacaoId VARCHAR(60)
	DECLARE @parcelaRetidaComissao VARCHAR(2)
	DECLARE @incluirMensalidades VARCHAR(2)
	DECLARE @parceiro_codigo INT
	DECLARE @parceiro_tipoCobranca INT
	DECLARE @parceiro_adesionista INT
	DECLARE @parceiro_maxMensalidadeId INT
	DECLARE @codigoEmpresa INT
	DECLARE @cnpjEmpresa VARCHAR(50)
	DECLARE @cnpjCentroCusto VARCHAR(50)
	DECLARE @nome VARCHAR(100)
	DECLARE @dataNascimento DATETIME
	DECLARE @cpf VARCHAR(11)
	DECLARE @identidadeNumero VARCHAR(20)
	DECLARE @identidadeOrgaoExpeditor VARCHAR(10)
	DECLARE @sexo INT
	DECLARE @enderecoBoleto VARCHAR(50)
	DECLARE @cd_orientacao_sexual INT
	DECLARE @OutraOrientacaoSexual VARCHAR(10)
	DECLARE @cd_ident_genero INT
	DECLARE @OutraIdentidadeGenero VARCHAR(20)
	DECLARE @agencia INT
	DECLARE @agencia_dv INT
	DECLARE @conta INT
	DECLARE @conta_dv INT
	DECLARE @contaOperacao INT
	DECLARE @matricula VARCHAR(20)
	DECLARE @dataApresentacao VARCHAR(10)
	DECLARE @diaVencimento VARCHAR(8)
	DECLARE @tipoPagamento INT
	DECLARE @origemVenda INT
	DECLARE @departamento INT
	DECLARE @observacaoAssociado VARCHAR(200)
	DECLARE @codSistemaExterno VARCHAR(20)
	DECLARE @dataAssinaturaContrato VARCHAR(20)
	DECLARE @numeroProposta VARCHAR(20)
	DECLARE @senhaAssociado VARCHAR(20)
	DECLARE @cep VARCHAR(20)
	DECLARE @tipoLogradouro INT
	DECLARE @logradouro VARCHAR(20)
	DECLARE @numero INT
	DECLARE @complemento VARCHAR(20)
	DECLARE @bairro INT
	DECLARE @municipio INT
	DECLARE @uf INT
	DECLARE @descricaoUf VARCHAR(20)
	DECLARE @cartao_numero VARCHAR(20)
	DECLARE @cartao_validade VARCHAR(20)
	DECLARE @cartao_codSeguranca VARCHAR(20)
	DECLARE @cartao_bandeira INT
	DECLARE @cartao_diaVencimentoCartao INT
	DECLARE @cartao_nomeImpressoCartao VARCHAR(20)
	DECLARE @cartao_id INT
	DECLARE @cartao_autorizacaoCodigo INT
	DECLARE @cartao_autorizacaoNsu INT
	DECLARE @cartao_pagamentoId INT
	DECLARE @cartao_tokenCartao VARCHAR(100)
	DECLARE @Erro VARCHAR(max)
	-------------------------------
	--Variaveis dependente
	-------------------------------
	DECLARE @depGrauParentesco AS INT
	DECLARE @depNome VARCHAR(100)
	DECLARE @depDataNascimento VARCHAR(10)
	DECLARE @depCPF VARCHAR(10)
	DECLARE @depSexo AS INT
	DECLARE @depPlano AS INT
	DECLARE @depPlanoValor VARCHAR(10)
	DECLARE @depNomeMae VARCHAR(10)
	DECLARE @depNumeroCarteira VARCHAR(10)
	DECLARE @depCarenciaAtendimento AS INT
	DECLARE @depRcaId AS INT
	DECLARE @depNumeroContrato AS INT
	DECLARE @depCdOrientacaoSexual AS INT
	DECLARE @depOutraOrientacaoSexual VARCHAR(10)
	DECLARE @depCdIdentidadeGenero AS INT
	DECLARE @depOutraIdentidadeGenero VARCHAR(10)
	DECLARE @depCNS VARCHAR(10)
	DECLARE @depIdExterno VARCHAR(10)
	DECLARE @depMMYYYY1Pagamento AS INT
	DECLARE @depObservacaoUsuario VARCHAR(10)
	DECLARE @depFuncionarioCadastro AS INT
	DECLARE @depDataCadastroLoteContrato VARCHAR(10)
	-----------------------
	--Variaveos Contato
	-----------------------
	DECLARE @tipo AS INT
	DECLARE @dado VARCHAR(50)
	DECLARE Associado_Cursor CURSOR
	FOR
	SELECT id,
		transacaoId,
		parcelaRetidaComissao,
		incluirMensalidades,
		parceiro_codigo,
		parceiro_tipoCobranca,
		parceiro_adesionista,
		parceiro_maxMensalidadeId,
		codigoEmpresa,
		cnpjEmpresa,
		nome,
		dataNascimento,
		cpf,
		identidadeNumero,
		identidadeOrgaoExpeditor,
		sexo,
		enderecoBoleto,
		cd_orientacao_sexual,
		OutraOrientacaoSexual,
		cd_ident_genero,
		OutraIdentidadeGenero,
		agencia,
		agencia_dv,
		conta,
		conta_dv,
		contaOperacao,
		matricula,
		dataApresentacao,
		diaVencimento,
		tipoPagamento,
		origemVenda,
		departamento,
		observacaoAssociado,
		codSistemaExterno,
		dataAssinaturaContrato,
		numeroProposta,
		senhaAssociado,
		cep,
		tipoLogradouro,
		logradouro,
		numero,
		complemento,
		bairro,
		municipio,
		uf,
		descricaoUf,
		cartao_numero,
		cartao_validade,
		cartao_codSeguranca,
		cartao_bandeira,
		cartao_diaVencimentoCartao,
		cartao_nomeImpressoCartao,
		cartao_id,
		cartao_autorizacaoCodigo,
		cartao_autorizacaoNsu,
		cartao_pagamentoId,
		cartao_tokenCartao
	FROM NovoUsuarioCallback nuc
	WHERE nuc.id = @IdTransacaoCallback
	OPEN Associado_Cursor
	FETCH NEXT
	FROM Associado_Cursor
	INTO @id,
		@transacaoId,
		@parcelaRetidaComissao,
		@incluirMensalidades,
		@parceiro_codigo,
		@parceiro_tipoCobranca,
		@parceiro_adesionista,
		@parceiro_maxMensalidadeId,
		@codigoEmpresa,
		@cnpjEmpresa,
		@nome,
		@dataNascimento,
		@cpf,
		@identidadeNumero,
		@identidadeOrgaoExpeditor,
		@sexo,
		@enderecoBoleto,
		@cd_orientacao_sexual,
		@OutraOrientacaoSexual,
		@cd_ident_genero,
		@OutraIdentidadeGenero,
		@agencia,
		@agencia_dv,
		@conta,
		@conta_dv,
		@contaOperacao,
		@matricula,
		@dataApresentacao,
		@diaVencimento,
		@tipoPagamento,
		@origemVenda,
		@departamento,
		@observacaoAssociado,
		@codSistemaExterno,
		@dataAssinaturaContrato,
		@numeroProposta,
		@senhaAssociado,
		@cep,
		@tipoLogradouro,
		@logradouro,
		@numero,
		@complemento,
		@bairro,
		@municipio,
		@uf,
		@descricaoUf,
		@cartao_numero,
		@cartao_validade,
		@cartao_codSeguranca,
		@cartao_bandeira,
		@cartao_diaVencimentoCartao,
		@cartao_nomeImpressoCartao,
		@cartao_id,
		@cartao_autorizacaoCodigo,
		@cartao_autorizacaoNsu,
		@cartao_pagamentoId,
		@cartao_tokenCartao
	WHILE (@@FETCH_STATUS <> - 1)

    IF 1=1
	BEGIN
		 
			SET @codigoCentroCusto = (
					SELECT cd_centro_custo
					FROM centro_custo
					WHERE CNPJ = @cnpjCentroCusto
					)
			SET @codigoEmpresa = (
					SELECT cd_empresa
					FROM EMPRESA
					WHERE NR_CGC = @cnpjEmpresa
						AND cd_centro_custo = @codigoCentroCusto
					)
			PRINT 'codigo centro de custo ' + convert(VARCHAR, @codigoCentroCusto)
			PRINT @codigoEmpresa
		
		PRINT @Erro
		FETCH NEXT
		FROM Associado_Cursor
		INTO @id,
			@transacaoId,
			@parcelaRetidaComissao,
			@incluirMensalidades,
			@parceiro_codigo,
			@parceiro_tipoCobranca,
			@parceiro_adesionista,
			@parceiro_maxMensalidadeId,
			@codigoEmpresa,
			@cnpjEmpresa,
			@nome,
			@dataNascimento,
			@cpf,
			@identidadeNumero,
			@identidadeOrgaoExpeditor,
			@sexo,
			@enderecoBoleto,
			@cd_orientacao_sexual,
			@OutraOrientacaoSexual,
			@cd_ident_genero,
			@OutraIdentidadeGenero,
			@agencia,
			@agencia_dv,
			@conta,
			@conta_dv,
			@contaOperacao,
			@matricula,
			@dataApresentacao,
			@diaVencimento,
			@tipoPagamento,
			@origemVenda,
			@departamento,
			@observacaoAssociado,
			@codSistemaExterno,
			@dataAssinaturaContrato,
			@numeroProposta,
			@senhaAssociado,
			@cep,
			@tipoLogradouro,
			@logradouro,
			@numero,
			@complemento,
			@bairro,
			@municipio,
			@uf,
			@descricaoUf,
			@cartao_numero,
			@cartao_validade,
			@cartao_codSeguranca,
			@cartao_bandeira,
			@cartao_diaVencimentoCartao,
			@cartao_nomeImpressoCartao,
			@cartao_id,
			@cartao_autorizacaoCodigo,
			@cartao_autorizacaoNsu,
			@cartao_pagamentoId,
			@cartao_tokenCartao
	END
	CLOSE Associado_Cursor
	DEALLOCATE Associado_Cursor
END
