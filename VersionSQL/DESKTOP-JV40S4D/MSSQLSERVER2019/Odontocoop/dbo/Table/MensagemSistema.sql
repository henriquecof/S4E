/****** Object:  Table [dbo].[MensagemSistema]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[MensagemSistema](
	[msiId] [smallint] NOT NULL,
	[msiCodigo] [varchar](5) NOT NULL,
	[msiDescricao] [varchar](500) NOT NULL,
 CONSTRAINT [PK_MensagemSistema] PRIMARY KEY CLUSTERED 
(
	[msiId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
