/****** Object:  Table [dbo].[TelefoniaMotivoPausa]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[TelefoniaMotivoPausa](
	[tmpId] [tinyint] NOT NULL,
	[tmpDescricao] [varchar](50) NOT NULL,
 CONSTRAINT [PK_TelefoniaMotivoPausa] PRIMARY KEY CLUSTERED 
(
	[tmpId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
