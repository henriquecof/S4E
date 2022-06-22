/****** Object:  Table [dbo].[ThreadSistemaBKP]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[ThreadSistemaBKP](
	[id] [int] NOT NULL,
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
	[prioridade] [tinyint] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
