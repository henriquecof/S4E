﻿/****** Object:  Table [dbo].[TB_FormaLancamento_2]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[TB_FormaLancamento_2](
	[Sequencial_FormaLancamento] [int] NULL,
	[Tipo_ContaLancamento] [smallint] NULL,
	[Forma_Lancamento] [smallint] NULL,
	[Valor_Lancamento] [decimal](18, 2) NULL,
	[Valor_Previsto] [decimal](18, 2) NULL,
	[Data_Documento] [datetime] NULL,
	[Data_pagamento] [datetime] NULL,
	[Data_Lancamento] [datetime] NULL,
	[Data_HoraLancamento] [datetime] NULL,
	[Sequencial_Lancamento] [int] NULL,
	[SequencialCartao_Car] [int] NULL,
	[Sequencial_Historico] [int] NULL,
	[Sequencial_Historico_Consulta] [int] NULL,
	[nome_usuario] [varchar](20) NULL,
	[Sequencial_FormaLancamento_Vale] [int] NULL,
	[Imprimir_lancamento] [smallint] NULL,
	[Sequencial_HistoricoVale] [int] NULL,
	[Conta_PrevistaAparecer] [smallint] NULL,
	[Sequencial_Cartao] [int] NULL,
	[Origem_Cartao] [smallint] NULL,
	[Data_Efetiva_Cartao] [datetime] NULL,
	[DOC] [varchar](36) NULL,
	[CODAUT] [varchar](20) NULL,
	[CV] [varchar](9) NULL,
	[Numero_Documento] [varchar](500) NULL,
	[Lancamento_Automatico] [smallint] NULL,
	[Controlar_Chegada_Conta] [smallint] NULL,
	[Conta_Chegou] [smallint] NULL,
	[cd_sequencial_malote] [int] NULL,
	[fl_AlteraValorPrev] [bit] NULL,
	[valorMulta] [money] NULL,
	[percMulta] [money] NULL,
	[valorJuros] [money] NULL,
	[percJuros] [money] NULL,
	[valorTaxaAdministracao] [money] NULL,
	[percTaxaAdministracao] [money] NULL,
	[valorTaxaAntecipacao] [money] NULL,
	[percTaxaAntecipacao] [money] NULL,
	[Fl_Conciliado] [tinyint] NULL,
	[lccId] [int] NULL,
	[idLoteMicroCredito] [int] NULL,
	[lccErroConciliacao] [varchar](500) NULL,
	[lccRequisicao] [varchar](50) NULL,
	[nrParcelaLoteC] [smallint] NULL,
	[pagamentoId] [varchar](36) NULL,
	[contaAuditadaContabilidade] [bit] NULL
) ON [PRIMARY]
