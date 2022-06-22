/****** Object:  Table [dbo].[TB_Conta]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[TB_Conta](
	[Sequencial_Conta] [int] IDENTITY(1,1) NOT NULL,
	[Codigo_Conta] [varchar](10) NOT NULL,
	[Descricao_Conta] [varchar](80) NOT NULL,
	[Sequencial_ContaMae] [int] NOT NULL,
	[CD_Contabilidade] [int] NOT NULL,
	[cd_centro_custo] [int] NOT NULL,
	[nome_usuario] [varchar](20) NULL,
	[Tipo_Conta] [smallint] NULL,
	[Conta_Valida] [smallint] NULL,
	[Sequencial_Conta_Destino] [int] NULL,
	[Gera_Lancamento] [smallint] NULL,
	[Sequencial_Movimentacao] [int] NULL,
	[Descricao_Historico] [varchar](1000) NULL,
	[CD_Contabilidade_realizado] [int] NULL,
	[cd_tipo_exportacao_contabilidade] [smallint] NULL,
	[apelido] [varchar](80) NULL,
	[fl_RelatorioGerencialAdministrativa] [bit] NULL,
	[fl_RelatorioGerencialComercial] [bit] NULL,
	[fl_RelatorioGerencialCredenciadoPF] [bit] NULL,
	[fl_RelatorioGerencialCredenciadoPJ] [bit] NULL,
	[fl_RelatorioGerencialImpostoFederal] [bit] NULL,
	[fl_RelatorioGerencialImpostoMunicipal] [bit] NULL,
 CONSTRAINT [PK_TB_Conta] PRIMARY KEY CLUSTERED 
(
	[Sequencial_Conta] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

SET ANSI_PADDING ON

CREATE NONCLUSTERED INDEX [IX_TB_Conta] ON [dbo].[TB_Conta]
(
	[Codigo_Conta] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
CREATE NONCLUSTERED INDEX [IX_TB_Conta_1] ON [dbo].[TB_Conta]
(
	[Sequencial_ContaMae] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
ALTER TABLE [dbo].[TB_Conta] ADD  CONSTRAINT [DF_TB_Conta_Gera_Lancamento]  DEFAULT ((1)) FOR [Gera_Lancamento]
ALTER TABLE [dbo].[TB_Conta]  WITH NOCHECK ADD  CONSTRAINT [FK_TB_Conta_Contabilidade] FOREIGN KEY([CD_Contabilidade])
REFERENCES [dbo].[Contabilidade] ([cd_contabilidade])
ALTER TABLE [dbo].[TB_Conta] CHECK CONSTRAINT [FK_TB_Conta_Contabilidade]
ALTER TABLE [dbo].[TB_Conta]  WITH CHECK ADD  CONSTRAINT [FK_TB_Conta_Contabilidade2] FOREIGN KEY([CD_Contabilidade_realizado])
REFERENCES [dbo].[Contabilidade] ([cd_contabilidade])
ALTER TABLE [dbo].[TB_Conta] CHECK CONSTRAINT [FK_TB_Conta_Contabilidade2]
ALTER TABLE [dbo].[TB_Conta]  WITH NOCHECK ADD  CONSTRAINT [FK_TB_Conta_TB_Conta] FOREIGN KEY([Sequencial_Conta_Destino])
REFERENCES [dbo].[TB_Conta] ([Sequencial_Conta])
ALTER TABLE [dbo].[TB_Conta] CHECK CONSTRAINT [FK_TB_Conta_TB_Conta]
ALTER TABLE [dbo].[TB_Conta]  WITH NOCHECK ADD  CONSTRAINT [FK_TB_Conta_TB_ContaMae] FOREIGN KEY([Sequencial_ContaMae])
REFERENCES [dbo].[TB_ContaMae] ([Sequencial_ContaMae])
ALTER TABLE [dbo].[TB_Conta] CHECK CONSTRAINT [FK_TB_Conta_TB_ContaMae]
ALTER TABLE [dbo].[TB_Conta]  WITH CHECK ADD  CONSTRAINT [FK_TB_Conta_tipo_exportacao_contabilidade] FOREIGN KEY([cd_tipo_exportacao_contabilidade])
REFERENCES [dbo].[tipo_exportacao_contabilidade] ([cd_tipo_exportacao_contabilidade])
ALTER TABLE [dbo].[TB_Conta] CHECK CONSTRAINT [FK_TB_Conta_tipo_exportacao_contabilidade]
