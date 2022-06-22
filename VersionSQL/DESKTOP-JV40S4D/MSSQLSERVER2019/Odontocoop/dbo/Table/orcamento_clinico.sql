/****** Object:  Table [dbo].[orcamento_clinico]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[orcamento_clinico](
	[cd_orcamento] [int] NOT NULL,
	[cd_associado] [int] NULL,
	[cd_sequencial_dep] [int] NULL,
	[dt_orcamento] [datetime] NULL,
	[dt_validade] [datetime] NULL,
	[ds_validade] [datetime] NULL,
	[ds_observacao] [nvarchar](2000) NULL,
	[cd_usuario_cadastrou] [varchar](50) NULL,
	[cd_funcionario] [int] NULL,
	[cd_tipo_pagamento] [int] NULL,
	[cd_status] [smallint] NULL,
	[dt_status] [datetime] NULL,
	[cd_usuario_aceite] [varchar](50) NULL,
	[cd_filial] [int] NULL,
	[perc_desconto] [float] NULL,
	[nm_motivo_cancelamento] [text] NULL,
	[nr_proposta] [nvarchar](15) NULL,
	[dt_finalizado] [datetime] NULL,
	[nr_NF] [varchar](10) NULL,
	[vl_credito_disponivel] [money] NULL,
	[cd_dentista] [int] NULL,
	[cd_LancamentoIndicacao] [int] NULL,
	[realizadoCallCenter] [bit] NULL,
	[primeiroOrcamento] [bit] NULL,
	[cd_origemOrcamento] [int] NULL,
	[cd_centro_custo] [smallint] NULL,
	[multiplicadorMicroCredito] [money] NULL,
	[microCreditoAtivo] [bit] NULL,
	[valorEntradaMicroCredito] [money] NULL,
	[token] [uniqueidentifier] NULL,
 CONSTRAINT [PK_orcamento_clinico] PRIMARY KEY CLUSTERED 
(
	[cd_orcamento] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

CREATE NONCLUSTERED INDEX [IX_orcamento_clinico_3] ON [dbo].[orcamento_clinico]
(
	[cd_funcionario] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
ALTER TABLE [dbo].[orcamento_clinico]  WITH NOCHECK ADD  CONSTRAINT [FK_orcamento_clinico_ASSOCIADOS] FOREIGN KEY([cd_associado])
REFERENCES [dbo].[ASSOCIADOS] ([cd_associado])
ALTER TABLE [dbo].[orcamento_clinico] CHECK CONSTRAINT [FK_orcamento_clinico_ASSOCIADOS]
ALTER TABLE [dbo].[orcamento_clinico]  WITH NOCHECK ADD  CONSTRAINT [FK_orcamento_clinico_DEPENDENTES] FOREIGN KEY([cd_sequencial_dep])
REFERENCES [dbo].[DEPENDENTES] ([CD_SEQUENCIAL])
ALTER TABLE [dbo].[orcamento_clinico] CHECK CONSTRAINT [FK_orcamento_clinico_DEPENDENTES]
ALTER TABLE [dbo].[orcamento_clinico]  WITH NOCHECK ADD  CONSTRAINT [FK_orcamento_clinico_FILIAL] FOREIGN KEY([cd_filial])
REFERENCES [dbo].[FILIAL] ([cd_filial])
ALTER TABLE [dbo].[orcamento_clinico] CHECK CONSTRAINT [FK_orcamento_clinico_FILIAL]
ALTER TABLE [dbo].[orcamento_clinico]  WITH CHECK ADD  CONSTRAINT [FK_orcamento_clinico_origemOrcamento] FOREIGN KEY([cd_origemOrcamento])
REFERENCES [dbo].[OrigemOrcamento] ([cd_origemOrcamento])
ALTER TABLE [dbo].[orcamento_clinico] CHECK CONSTRAINT [FK_orcamento_clinico_origemOrcamento]
