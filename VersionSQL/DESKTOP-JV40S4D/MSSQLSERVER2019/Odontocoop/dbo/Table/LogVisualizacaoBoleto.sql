/****** Object:  Table [dbo].[LogVisualizacaoBoleto]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[LogVisualizacaoBoleto](
	[lvbId] [int] IDENTITY(1,1) NOT NULL,
	[lvbDtCadastro] [datetime] NOT NULL,
	[lvbIP] [varchar](20) NOT NULL,
	[lvbValor] [money] NULL,
	[lvbDtVencimento] [datetime] NULL,
	[cd_parcela] [int] NOT NULL,
	[cd_funcionario] [int] NULL,
	[cd_associado] [int] NULL,
	[cd_empresa] [bigint] NULL,
 CONSTRAINT [PK_LogVisualizacaoBoleto] PRIMARY KEY CLUSTERED 
(
	[lvbId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

CREATE NONCLUSTERED INDEX [IX_LogVisualizacaoBoleto_cd_associado] ON [dbo].[LogVisualizacaoBoleto]
(
	[cd_associado] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
CREATE NONCLUSTERED INDEX [IX_LogVisualizacaoBoleto_cd_empresa] ON [dbo].[LogVisualizacaoBoleto]
(
	[cd_empresa] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
ALTER TABLE [dbo].[LogVisualizacaoBoleto]  WITH CHECK ADD  CONSTRAINT [FK_LogVisualizacaoBoleto_ASSOCIADOS] FOREIGN KEY([cd_associado])
REFERENCES [dbo].[ASSOCIADOS] ([cd_associado])
ALTER TABLE [dbo].[LogVisualizacaoBoleto] CHECK CONSTRAINT [FK_LogVisualizacaoBoleto_ASSOCIADOS]
ALTER TABLE [dbo].[LogVisualizacaoBoleto]  WITH CHECK ADD  CONSTRAINT [FK_LogVisualizacaoBoleto_EMPRESA] FOREIGN KEY([cd_empresa])
REFERENCES [dbo].[EMPRESA] ([CD_EMPRESA])
ON UPDATE CASCADE
ALTER TABLE [dbo].[LogVisualizacaoBoleto] CHECK CONSTRAINT [FK_LogVisualizacaoBoleto_EMPRESA]
ALTER TABLE [dbo].[LogVisualizacaoBoleto]  WITH CHECK ADD  CONSTRAINT [FK_LogVisualizacaoBoleto_MENSALIDADES] FOREIGN KEY([cd_parcela])
REFERENCES [dbo].[MENSALIDADES] ([CD_PARCELA])
ALTER TABLE [dbo].[LogVisualizacaoBoleto] CHECK CONSTRAINT [FK_LogVisualizacaoBoleto_MENSALIDADES]
