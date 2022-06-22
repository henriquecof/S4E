﻿/****** Object:  Table [dbo].[TB_Lancamento_Visao]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[TB_Lancamento_Visao](
	[Sequencial_Lancamento] [int] NOT NULL,
	[Tipo_Lancamento] [smallint] NOT NULL,
	[Historico] [varchar](1500) NULL,
	[Sequencial_Conta] [int] NULL,
	[Tipo_ContaLancamento] [smallint] NOT NULL,
	[Valor_Previsto] [decimal](18, 2) NULL,
	[Forma_Lancamento] [smallint] NOT NULL,
	[Data_Documento] [datetime] NOT NULL,
	[Data_HoraLancamento] [datetime] NOT NULL,
	[SequencialCartao_Car] [int] NULL,
	[Sequencial_Historico] [int] NULL,
	[Conta_PrevistaAparecer] [smallint] NULL,
	[Sequencial_Movimentacao] [int] NOT NULL,
	[Descricao_Movimentacao] [varchar](80) NOT NULL,
	[PodeRealizar] [int] NOT NULL,
	[Sequencial_FormaLancamento] [int] NOT NULL,
	[cd_associado] [int] NULL,
	[cd_sequencial] [int] NULL,
	[cd_fornecedor] [int] NULL,
	[cd_dentista] [int] NULL,
	[cd_funcionario] [int] NULL,
	[cd_associadoempresa] [int] NULL,
	[nome_outros] [varchar](150) NULL,
	[Forma] [varchar](151) NOT NULL,
	[SequencialMovimentacaoConsulta] [int] NULL,
	[Sequencial_Lancamento_Cheque] [int] NULL,
	[Situacao_Cheque] [smallint] NULL,
	[Sequencial_Aprazamento] [int] NULL,
	[Conta_Alterada] [smallint] NULL,
	[Origem_Cartao] [smallint] NULL,
	[Data_Efetiva_Cartao] [datetime] NULL,
	[DOC] [varchar](6) NULL,
	[CODAUT] [varchar](6) NULL,
	[CV] [varchar](9) NULL,
	[Numero_Documento] [varchar](500) NULL
) ON [PRIMARY]