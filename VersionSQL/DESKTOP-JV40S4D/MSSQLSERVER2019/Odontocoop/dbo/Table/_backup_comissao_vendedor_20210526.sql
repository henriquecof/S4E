/****** Object:  Table [dbo].[_backup_comissao_vendedor_20210526]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[_backup_comissao_vendedor_20210526](
	[cd_sequencial] [int] IDENTITY(1,1) NOT NULL,
	[cd_sequencial_dependente] [int] NULL,
	[cd_parcela_comissao] [int] NOT NULL,
	[cd_sequencial_mensalidade_planos] [bigint] NULL,
	[cd_funcionario] [int] NOT NULL,
	[valor] [money] NOT NULL,
	[perc_pagamento] [float] NOT NULL,
	[fl_vendedor_reteu] [bit] NOT NULL,
	[dt_inclusao] [smalldatetime] NOT NULL,
	[cd_sequencial_lote] [int] NULL,
	[dt_exclusao] [datetime] NULL,
	[cd_orcamento] [int] NULL,
	[cd_empresa] [bigint] NULL,
	[cd_parcela] [int] NULL,
	[nr_vidas] [int] NULL,
	[fl_vitalicio] [bit] NULL,
	[cd_sequencial_origem] [int] NULL,
	[id_debito] [int] NULL,
	[id_credito] [int] NULL,
	[cd_parcela_imp] [int] NULL,
	[fl_mostra_plataforma] [smallint] NULL,
	[cd_func_adesionista_cv] [int] NULL,
	[pagamentoComissao] [int] NULL,
	[moeda] [bit] NULL,
	[valor_old] [money] NULL
) ON [PRIMARY]
