/****** Object:  Table [dbo].[tbSaidaEmailBKP]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[tbSaidaEmailBKP](
	[semId] [int] NOT NULL,
	[semEmailRemetente] [varchar](100) NULL,
	[cd_origeminformacao] [int] NOT NULL,
	[codigo] [int] NOT NULL,
	[semEmail] [varchar](100) NOT NULL,
	[semAssunto] [varchar](500) NOT NULL,
	[semMensagem] [varchar](max) NOT NULL,
	[semChave] [varchar](100) NOT NULL,
	[semDtCadastro] [datetime] NOT NULL,
	[semDtEnvio] [datetime] NULL,
	[semDtVisualizacao] [datetime] NULL,
	[semDtExclusao] [datetime] NULL,
	[semIP] [varchar](50) NULL,
	[semTipoMensagem] [tinyint] NULL,
	[semPrioridadeMensagem] [tinyint] NULL,
	[semExcluirDuplicadoDia] [bit] NULL,
	[semAssinaturaMensagem] [bit] NULL,
	[mmeID] [int] NULL,
	[semAnexo] [varchar](300) NULL,
	[semMensagemConfidencial] [bit] NULL,
	[semTipoAcessoUsuario] [tinyint] NULL,
	[cd_parcela] [int] NULL,
	[semMsgError] [varchar](2000) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

CREATE NONCLUSTERED INDEX [IX_OrigemInfo_Cod] ON [dbo].[tbSaidaEmailBKP]
(
	[cd_origeminformacao] ASC,
	[codigo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
SET ANSI_PADDING ON

CREATE NONCLUSTERED INDEX [IX_semChave] ON [dbo].[tbSaidaEmailBKP]
(
	[semChave] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
CREATE NONCLUSTERED INDEX [IX_semDtCadastro] ON [dbo].[tbSaidaEmailBKP]
(
	[semDtCadastro] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
CREATE NONCLUSTERED INDEX [IX_semDtEnvio] ON [dbo].[tbSaidaEmailBKP]
(
	[semDtEnvio] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
CREATE NONCLUSTERED INDEX [IX_semDtVisualizacao] ON [dbo].[tbSaidaEmailBKP]
(
	[semDtVisualizacao] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
SET ANSI_PADDING ON

CREATE NONCLUSTERED INDEX [IX_semEmail] ON [dbo].[tbSaidaEmailBKP]
(
	[semEmail] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
CREATE NONCLUSTERED INDEX [IX_semId] ON [dbo].[tbSaidaEmailBKP]
(
	[semId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
ALTER TABLE [dbo].[tbSaidaEmailBKP]  WITH CHECK ADD  CONSTRAINT [FK_tbSaidaEmailBKP_MailingMensagem] FOREIGN KEY([mmeID])
REFERENCES [dbo].[MailingMensagem] ([mmeID])
ALTER TABLE [dbo].[tbSaidaEmailBKP] CHECK CONSTRAINT [FK_tbSaidaEmailBKP_MailingMensagem]
