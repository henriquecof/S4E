/****** Object:  Table [dbo].[NotificacaoCampanhaPushBkp]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[NotificacaoCampanhaPushBkp](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[cd_sequencial_dep] [int] NULL,
	[dt_envio_notificacao] [datetime] NULL,
	[cd_campanha] [int] NULL,
	[mensagem_push] [varchar](max) NULL,
	[titulo_push] [varchar](500) NULL,
	[token_push] [text] NULL,
	[deviceTypeId] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
