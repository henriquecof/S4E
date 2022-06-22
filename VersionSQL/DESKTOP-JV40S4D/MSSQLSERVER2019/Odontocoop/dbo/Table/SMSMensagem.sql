/****** Object:  Table [dbo].[SMSMensagem]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[SMSMensagem](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[destinatario] [varchar](100) NULL,
	[assunto] [varchar](200) NULL,
	[dataCadastro] [datetime] NULL,
	[mensagem] [varchar](500) NULL,
	[dataEnvio] [datetime] NULL,
	[respostaEnvio] [text] NULL,
	[codigo] [int] NOT NULL,
	[cd_origeminformacao] [smallint] NOT NULL,
 CONSTRAINT [PK_SMSMensagem] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
