/****** Object:  Table [dbo].[ContratoTemp]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[ContratoTemp](
	[id] [bigint] IDENTITY(1,1) NOT NULL,
	[chave] [varchar](100) NULL,
	[cd_funcionarioCadastro] [int] NULL,
	[dt_cadastro] [datetime] NULL
) ON [PRIMARY]
