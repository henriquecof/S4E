/****** Object:  Table [dbo].[ThreadSistema]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[ThreadSistema](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[descricao] [varchar](1000) NOT NULL,
	[comandoResumido] [varchar](100) NOT NULL,
	[comandoCompleto] [varchar](1000) NOT NULL,
	[dataCadastro] [datetime] NOT NULL,
	[cd_funcionarioCadastro] [int] NULL,
	[dataConclusao] [datetime] NULL,
	[dataClique] [datetime] NULL,
	[dataExclusao] [datetime] NULL,
	[cd_funcionarioExclusao] [int] NULL,
	[chave] [varchar](50) NOT NULL,
	[mensagemUsuario] [varchar](1000) NULL,
	[urlRedirectClique] [varchar](1000) NULL,
	[arquivoDownloadClique] [varchar](1000) NULL,
	[obs] [varchar](max) NULL,
	[execucaoSQL] [bit] NULL,
	[dataExecucaoSQL] [datetime] NULL,
	[prioridade] [tinyint] NULL,
 CONSTRAINT [PK_ThreadSistema] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

CREATE NONCLUSTERED INDEX [IX_cd_funcionarioCadastroThread] ON [dbo].[ThreadSistema]
(
	[cd_funcionarioCadastro] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
SET ANSI_PADDING ON

CREATE NONCLUSTERED INDEX [IX_ChaveThread] ON [dbo].[ThreadSistema]
(
	[chave] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
SET ANSI_PADDING ON

CREATE NONCLUSTERED INDEX [IX_comandoResumidoThread] ON [dbo].[ThreadSistema]
(
	[comandoResumido] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
ALTER TABLE [dbo].[ThreadSistema]  WITH CHECK ADD  CONSTRAINT [FK_ThreadSistema_FUNCIONARIO] FOREIGN KEY([cd_funcionarioCadastro])
REFERENCES [dbo].[FUNCIONARIO] ([cd_funcionario])
ALTER TABLE [dbo].[ThreadSistema] CHECK CONSTRAINT [FK_ThreadSistema_FUNCIONARIO]
ALTER TABLE [dbo].[ThreadSistema]  WITH CHECK ADD  CONSTRAINT [FK_ThreadSistema_FUNCIONARIO1] FOREIGN KEY([cd_funcionarioExclusao])
REFERENCES [dbo].[FUNCIONARIO] ([cd_funcionario])
ALTER TABLE [dbo].[ThreadSistema] CHECK CONSTRAINT [FK_ThreadSistema_FUNCIONARIO1]
