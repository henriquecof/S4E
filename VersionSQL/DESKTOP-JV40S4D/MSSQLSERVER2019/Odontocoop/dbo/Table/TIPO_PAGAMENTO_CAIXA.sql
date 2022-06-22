/****** Object:  Table [dbo].[TIPO_PAGAMENTO_CAIXA]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[TIPO_PAGAMENTO_CAIXA](
	[cd_tipo_pagamento] [int] NOT NULL,
	[sequencial_movimentacao] [int] NOT NULL,
	[Sequencial_conta] [int] NOT NULL,
	[fl_realizado] [tinyint] NOT NULL,
	[fl_consolidado] [tinyint] NOT NULL,
	[sequencial_conta_pf] [int] NULL,
	[sequencial_conta_pj] [int] NULL,
	[Sequencial_conta_taxa] [int] NULL,
	[lancaIndividual] [tinyint] NULL,
	[sequencial_conta_ca] [int] NULL,
	[fl_separa_centro_custo] [bit] NULL
) ON [PRIMARY]
