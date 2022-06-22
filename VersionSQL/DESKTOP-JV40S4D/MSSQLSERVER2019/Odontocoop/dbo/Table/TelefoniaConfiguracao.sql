/****** Object:  Table [dbo].[TelefoniaConfiguracao]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[TelefoniaConfiguracao](
	[tcoURL] [varchar](500) NOT NULL,
	[tcoVersaoSistema] [tinyint] NOT NULL,
	[tcoExtensaoArquivoGravacao] [varchar](4) NULL,
	[tcoEnderecoArquivoGravacao] [varchar](1000) NULL,
	[tcoEnderecoGeracaoProtocolo] [varchar](1000) NULL
) ON [PRIMARY]
