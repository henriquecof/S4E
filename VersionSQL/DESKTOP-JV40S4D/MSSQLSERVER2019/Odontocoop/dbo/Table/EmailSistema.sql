/****** Object:  Table [dbo].[EmailSistema]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[EmailSistema](
	[esiId] [tinyint] IDENTITY(1,1) NOT NULL,
	[esiNome] [varchar](50) NOT NULL,
	[esiSMTP] [varchar](50) NOT NULL,
	[esiEmail] [varchar](50) NOT NULL,
	[esiEmailReply] [varchar](50) NOT NULL,
	[esiSenha] [varchar](50) NOT NULL,
	[esiPorta] [smallint] NOT NULL,
	[esiSSL] [bit] NOT NULL,
	[esiUsuario] [varchar](50) NULL,
	[esiTLS] [bit] NULL,
	[esiTipoEnvio] [tinyint] NULL,
	[esiKeySMTP] [varchar](250) NULL,
 CONSTRAINT [PK_EmailSistema] PRIMARY KEY CLUSTERED 
(
	[esiId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
