/****** Object:  Table [dbo].[EstornoPagamentoPrestador]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[EstornoPagamentoPrestador](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[cd_funcionarioDentista] [int] NOT NULL,
	[cd_filial] [int] NOT NULL,
	[cd_sequencialConsulta] [int] NOT NULL,
	[justificativa] [varchar](500) NOT NULL,
	[valor] [money] NOT NULL,
	[cd_funcionarioCadastro] [int] NOT NULL,
	[dataCadastro] [datetime] NOT NULL,
	[cd_pgto_dentista_lanc] [int] NULL,
	[cd_funcionarioExclusao] [int] NULL,
	[dataExclusao] [datetime] NULL,
 CONSTRAINT [PK_EstornoPagamentoPrestador] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

CREATE NONCLUSTERED INDEX [IX_cd_filial] ON [dbo].[EstornoPagamentoPrestador]
(
	[cd_filial] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
CREATE NONCLUSTERED INDEX [IX_cd_funcionarioDentista] ON [dbo].[EstornoPagamentoPrestador]
(
	[cd_funcionarioDentista] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
CREATE NONCLUSTERED INDEX [IX_cd_pgto_dentista_lan] ON [dbo].[EstornoPagamentoPrestador]
(
	[cd_pgto_dentista_lanc] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
ALTER TABLE [dbo].[EstornoPagamentoPrestador]  WITH CHECK ADD  CONSTRAINT [FK_EstornoPagamentoPrestador_Consultas] FOREIGN KEY([cd_sequencialConsulta])
REFERENCES [dbo].[Consultas] ([cd_sequencial])
ALTER TABLE [dbo].[EstornoPagamentoPrestador] CHECK CONSTRAINT [FK_EstornoPagamentoPrestador_Consultas]
ALTER TABLE [dbo].[EstornoPagamentoPrestador]  WITH CHECK ADD  CONSTRAINT [FK_EstornoPagamentoPrestador_FILIAL] FOREIGN KEY([cd_filial])
REFERENCES [dbo].[FILIAL] ([cd_filial])
ALTER TABLE [dbo].[EstornoPagamentoPrestador] CHECK CONSTRAINT [FK_EstornoPagamentoPrestador_FILIAL]
ALTER TABLE [dbo].[EstornoPagamentoPrestador]  WITH CHECK ADD  CONSTRAINT [FK_EstornoPagamentoPrestador_Pagamento_Dentista_Lancamento] FOREIGN KEY([cd_pgto_dentista_lanc])
REFERENCES [dbo].[Pagamento_Dentista_Lancamento] ([cd_pgto_dentista_lanc])
ALTER TABLE [dbo].[EstornoPagamentoPrestador] CHECK CONSTRAINT [FK_EstornoPagamentoPrestador_Pagamento_Dentista_Lancamento]
