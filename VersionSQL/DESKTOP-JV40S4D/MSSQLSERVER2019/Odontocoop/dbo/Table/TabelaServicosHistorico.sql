/****** Object:  Table [dbo].[TabelaServicosHistorico]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[TabelaServicosHistorico](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[cd_tabela_servicos] [int] NOT NULL,
	[dataHistorico] [datetime] NOT NULL,
	[usuarioHistorico] [int] NOT NULL,
	[operacaoHistorico] [int] NOT NULL,
	[cdTabelaReferenciaHistorico] [int] NULL,
	[cd_tabelaExclusao] [smallint] NULL,
	[valorAntigo] [varchar](10) NULL,
	[novoValor] [varchar](10) NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[TabelaServicosHistorico]  WITH NOCHECK ADD  CONSTRAINT [FK_TabelaServicosHistorico_TabelaServicos] FOREIGN KEY([cd_tabela_servicos])
REFERENCES [dbo].[tabela_servicos] ([cd_tabela_servicos])
ALTER TABLE [dbo].[TabelaServicosHistorico] CHECK CONSTRAINT [FK_TabelaServicosHistorico_TabelaServicos]
