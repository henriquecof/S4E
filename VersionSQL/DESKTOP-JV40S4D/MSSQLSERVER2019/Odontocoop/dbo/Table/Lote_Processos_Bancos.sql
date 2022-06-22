/****** Object:  Table [dbo].[Lote_Processos_Bancos]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[Lote_Processos_Bancos](
	[cd_sequencial] [int] IDENTITY(1,1) NOT NULL,
	[cd_tipo_servico_bancario] [smallint] NOT NULL,
	[cd_tipo_pagamento] [int] NOT NULL,
	[dt_gerado] [datetime] NOT NULL,
	[dt_finalizado] [datetime] NULL,
	[cd_funcionario] [int] NOT NULL,
	[nsa] [int] NULL,
	[convenio] [varchar](20) NULL,
	[qtde] [int] NULL,
	[valor] [money] NULL,
	[nm_arquivo] [varchar](200) NULL,
	[cd_equipe] [smallint] NULL,
	[cd_sequencial_lote_Carteira] [int] NULL,
	[cd_sequencial_lote_etiqueta] [int] NULL,
	[DT_Envio] [datetime] NULL,
	[cd_UsuarioEnvio] [int] NULL,
	[DT_Recebido] [datetime] NULL,
	[cd_UsuarioRecebimento] [int] NULL,
	[qtde_distinto] [int] NULL,
	[dt_postagem] [datetime] NULL,
	[usuario_postagen] [varchar](200) NULL,
	[cd_tipo_arquivo_banco] [smallint] NULL,
	[nm_arquivoImpressaoExterna] [varchar](200) NULL,
	[periodo_inicial] [datetime] NULL,
	[periodo_final] [datetime] NULL,
 CONSTRAINT [PK_Lote_Processos_Bancos] PRIMARY KEY CLUSTERED 
(
	[cd_sequencial] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

CREATE NONCLUSTERED INDEX [IX_Lote_Processos_Bancos] ON [dbo].[Lote_Processos_Bancos]
(
	[cd_tipo_pagamento] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
CREATE NONCLUSTERED INDEX [IX_Lote_Processos_Bancos_1] ON [dbo].[Lote_Processos_Bancos]
(
	[cd_tipo_servico_bancario] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
CREATE NONCLUSTERED INDEX [IX_Lote_Processos_Bancos_2] ON [dbo].[Lote_Processos_Bancos]
(
	[dt_finalizado] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
ALTER TABLE [dbo].[Lote_Processos_Bancos]  WITH CHECK ADD  CONSTRAINT [FK_Lote_Processos_Bancos_equipe_vendas] FOREIGN KEY([cd_equipe])
REFERENCES [dbo].[equipe_vendas] ([cd_equipe])
ALTER TABLE [dbo].[Lote_Processos_Bancos] CHECK CONSTRAINT [FK_Lote_Processos_Bancos_equipe_vendas]
ALTER TABLE [dbo].[Lote_Processos_Bancos]  WITH CHECK ADD  CONSTRAINT [FK_Lote_Processos_Bancos_Lotes_Carteiras] FOREIGN KEY([cd_sequencial_lote_Carteira])
REFERENCES [dbo].[Lotes_Carteiras] ([SQ_Lote])
ALTER TABLE [dbo].[Lote_Processos_Bancos] CHECK CONSTRAINT [FK_Lote_Processos_Bancos_Lotes_Carteiras]
ALTER TABLE [dbo].[Lote_Processos_Bancos]  WITH CHECK ADD  CONSTRAINT [FK_Lote_Processos_Bancos_Tipo_arquivo_banco] FOREIGN KEY([cd_tipo_arquivo_banco])
REFERENCES [dbo].[Tipo_arquivo_banco] ([cd_tipo_arquivo_banco])
ALTER TABLE [dbo].[Lote_Processos_Bancos] CHECK CONSTRAINT [FK_Lote_Processos_Bancos_Tipo_arquivo_banco]
ALTER TABLE [dbo].[Lote_Processos_Bancos]  WITH NOCHECK ADD  CONSTRAINT [FK_Lote_Processos_Bancos_tipo_servico_bancario] FOREIGN KEY([cd_tipo_servico_bancario])
REFERENCES [dbo].[tipo_servico_bancario] ([cd_tipo_servico_bancario])
ALTER TABLE [dbo].[Lote_Processos_Bancos] CHECK CONSTRAINT [FK_Lote_Processos_Bancos_tipo_servico_bancario]
